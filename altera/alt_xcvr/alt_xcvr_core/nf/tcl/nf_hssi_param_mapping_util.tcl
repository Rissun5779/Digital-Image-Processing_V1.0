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


proc ::nf_xcvr_native::parameters::convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4_convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4_convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4_convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4_convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4_convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5_convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5_convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5_convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5_convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5_convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm4es_convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es2_convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm2_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm2_convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm2_convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm2_convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm2_convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm2_convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm5es_convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm1_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm1_convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm1_convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm1_convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm1_convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm1_convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_a2b_cdr_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm3_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_64) "idwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm3_convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_50) "odwidth_50"
   set value_map(width_64) "odwidth_64"
   set value_map(width_66) "odwidth_66"
   set value_map(width_67) "odwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm3_convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth { value } {
   set value_map(width_32) "idwidth_32"
   set value_map(width_40) "idwidth_40"
   set value_map(width_50) "idwidth_50"
   set value_map(width_64) "idwidth_64"
   set value_map(width_66) "idwidth_66"
   set value_map(width_67) "idwidth_67"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm3_convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth { value } {
   set value_map(width_32) "odwidth_32"
   set value_map(width_40) "odwidth_40"
   set value_map(width_64) "odwidth_64"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm3_convert_a2b_pma_rx_deser_deser_factor { value } {
   set value_map(10) "deser_10b"
   set value_map(16) "deser_16b"
   set value_map(20) "deser_20b"
   set value_map(32) "deser_32b"
   set value_map(40) "deser_40b"
   set value_map(64) "deser_64b"
   set value_map(8) "deser_8b"

   return $value_map($value)
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_bw_sel { values } {
   set new_values {}

   set value_map(high_bw) "high"
   set value_map(low_bw) "low"
   set value_map(mid_bw) "medium"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_chgpmp_replicate { values } {
   set new_values {}

   set value_map(disable_replica_bias_ctrl) "false"
   set value_map(enable_replica_bias_ctrl) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_diag_loopback_enable { values } {
   set new_values {}

   set value_map(no_diag_rev_loopback) "false"
   set value_map(diag_rev_loopback) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_disable_up_dn { values } {
   set new_values {}

   set value_map(tristate_up_dn_current) "false"
   set value_map(normal_mode) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_fref_clklow_div { values } {
   set new_values {}

   set value_map(fref_clklow_bypass) "1"
   set value_map(fref_clklow_div2) "2"
   set value_map(fref_clklow_div4) "4"
   set value_map(fref_clklow_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_n_counter { values } {
   set new_values {}

   set value_map(ncnt_bypass) "1"
   set value_map(ncnt_div2) "2"
   set value_map(ncnt_div4) "4"
   set value_map(ncnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_pd_fastlock_mode { values } {
   set new_values {}

   set value_map(fast_lock_disable) "false"
   set value_map(fast_lock_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_pd_l_counter { values } {
   set new_values {}

   set value_map(pd_lcnt_disable) "0"
   set value_map(pd_lcnt_div1) "1"
   set value_map(pd_lcnt_div16) "16"
   set value_map(pd_lcnt_div2) "2"
   set value_map(pd_lcnt_div4) "4"
   set value_map(pd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_pfd_l_counter { values } {
   set new_values {}

   set value_map(pfd_lcnt_disable) "0"
   set value_map(pfd_lcnt_div1) "1"
   set value_map(pfd_lcnt_refclk_test) "100"
   set value_map(pfd_lcnt_div16) "16"
   set value_map(pfd_lcnt_div2) "2"
   set value_map(pfd_lcnt_div4) "4"
   set value_map(pfd_lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_set_cdr_v2i_enable { values } {
   set new_values {}

   set value_map(disable_v2i_bias) "false"
   set value_map(enable_v2i_bias) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_set_cdr_vco_reset { values } {
   set new_values {}

   set value_map(vco_normal) "false"
   set value_map(vco_reset) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_cdr_pll_txpll_hclk_driver_enable { values } {
   set new_values {}

   set value_map(hclk_off) "false"
   set value_map(hclk_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_50) "width_50"
   set value_map(odwidth_64) "width_64"
   set value_map(odwidth_66) "width_66"
   set value_map(odwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth { values } {
   set new_values {}

   set value_map(idwidth_32) "width_32"
   set value_map(idwidth_40) "width_40"
   set value_map(idwidth_50) "width_50"
   set value_map(idwidth_64) "width_64"
   set value_map(idwidth_66) "width_66"
   set value_map(idwidth_67) "width_67"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth { values } {
   set new_values {}

   set value_map(odwidth_32) "width_32"
   set value_map(odwidth_40) "width_40"
   set value_map(odwidth_64) "width_64"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_adapt_adp_dfe_fxtap10 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_0) "radp_dfe_fxtap10_0"
   set value_map(radp_dfe_fltap3_1) "radp_dfe_fxtap10_1"
   set value_map(radp_dfe_fltap3_10) "radp_dfe_fxtap10_10"
   set value_map(radp_dfe_fltap3_11) "radp_dfe_fxtap10_11"
   set value_map(radp_dfe_fltap3_12) "radp_dfe_fxtap10_12"
   set value_map(radp_dfe_fltap3_13) "radp_dfe_fxtap10_13"
   set value_map(radp_dfe_fltap3_14) "radp_dfe_fxtap10_14"
   set value_map(radp_dfe_fltap3_15) "radp_dfe_fxtap10_15"
   set value_map(radp_dfe_fltap3_16) "radp_dfe_fxtap10_16"
   set value_map(radp_dfe_fltap3_17) "radp_dfe_fxtap10_17"
   set value_map(radp_dfe_fltap3_18) "radp_dfe_fxtap10_18"
   set value_map(radp_dfe_fltap3_19) "radp_dfe_fxtap10_19"
   set value_map(radp_dfe_fltap3_2) "radp_dfe_fxtap10_2"
   set value_map(radp_dfe_fltap3_20) "radp_dfe_fxtap10_20"
   set value_map(radp_dfe_fltap3_21) "radp_dfe_fxtap10_21"
   set value_map(radp_dfe_fltap3_22) "radp_dfe_fxtap10_22"
   set value_map(radp_dfe_fltap3_23) "radp_dfe_fxtap10_23"
   set value_map(radp_dfe_fltap3_24) "radp_dfe_fxtap10_24"
   set value_map(radp_dfe_fltap3_25) "radp_dfe_fxtap10_25"
   set value_map(radp_dfe_fltap3_26) "radp_dfe_fxtap10_26"
   set value_map(radp_dfe_fltap3_27) "radp_dfe_fxtap10_27"
   set value_map(radp_dfe_fltap3_28) "radp_dfe_fxtap10_28"
   set value_map(radp_dfe_fltap3_29) "radp_dfe_fxtap10_29"
   set value_map(radp_dfe_fltap3_3) "radp_dfe_fxtap10_3"
   set value_map(radp_dfe_fltap3_30) "radp_dfe_fxtap10_30"
   set value_map(radp_dfe_fltap3_31) "radp_dfe_fxtap10_31"
   set value_map(radp_dfe_fltap3_32) "radp_dfe_fxtap10_32"
   set value_map(radp_dfe_fltap3_33) "radp_dfe_fxtap10_33"
   set value_map(radp_dfe_fltap3_34) "radp_dfe_fxtap10_34"
   set value_map(radp_dfe_fltap3_35) "radp_dfe_fxtap10_35"
   set value_map(radp_dfe_fltap3_36) "radp_dfe_fxtap10_36"
   set value_map(radp_dfe_fltap3_37) "radp_dfe_fxtap10_37"
   set value_map(radp_dfe_fltap3_38) "radp_dfe_fxtap10_38"
   set value_map(radp_dfe_fltap3_39) "radp_dfe_fxtap10_39"
   set value_map(radp_dfe_fltap3_4) "radp_dfe_fxtap10_4"
   set value_map(radp_dfe_fltap3_40) "radp_dfe_fxtap10_40"
   set value_map(radp_dfe_fltap3_41) "radp_dfe_fxtap10_41"
   set value_map(radp_dfe_fltap3_42) "radp_dfe_fxtap10_42"
   set value_map(radp_dfe_fltap3_43) "radp_dfe_fxtap10_43"
   set value_map(radp_dfe_fltap3_44) "radp_dfe_fxtap10_44"
   set value_map(radp_dfe_fltap3_45) "radp_dfe_fxtap10_45"
   set value_map(radp_dfe_fltap3_46) "radp_dfe_fxtap10_46"
   set value_map(radp_dfe_fltap3_47) "radp_dfe_fxtap10_47"
   set value_map(radp_dfe_fltap3_48) "radp_dfe_fxtap10_48"
   set value_map(radp_dfe_fltap3_49) "radp_dfe_fxtap10_49"
   set value_map(radp_dfe_fltap3_5) "radp_dfe_fxtap10_5"
   set value_map(radp_dfe_fltap3_50) "radp_dfe_fxtap10_50"
   set value_map(radp_dfe_fltap3_51) "radp_dfe_fxtap10_51"
   set value_map(radp_dfe_fltap3_52) "radp_dfe_fxtap10_52"
   set value_map(radp_dfe_fltap3_53) "radp_dfe_fxtap10_53"
   set value_map(radp_dfe_fltap3_54) "radp_dfe_fxtap10_54"
   set value_map(radp_dfe_fltap3_55) "radp_dfe_fxtap10_55"
   set value_map(radp_dfe_fltap3_56) "radp_dfe_fxtap10_56"
   set value_map(radp_dfe_fltap3_57) "radp_dfe_fxtap10_57"
   set value_map(radp_dfe_fltap3_58) "radp_dfe_fxtap10_58"
   set value_map(radp_dfe_fltap3_59) "radp_dfe_fxtap10_59"
   set value_map(radp_dfe_fltap3_6) "radp_dfe_fxtap10_6"
   set value_map(radp_dfe_fltap3_60) "radp_dfe_fxtap10_60"
   set value_map(radp_dfe_fltap3_61) "radp_dfe_fxtap10_61"
   set value_map(radp_dfe_fltap3_62) "radp_dfe_fxtap10_62"
   set value_map(radp_dfe_fltap3_63) "radp_dfe_fxtap10_63"
   set value_map(radp_dfe_fltap3_7) "radp_dfe_fxtap10_7"
   set value_map(radp_dfe_fltap3_8) "radp_dfe_fxtap10_8"
   set value_map(radp_dfe_fltap3_9) "radp_dfe_fxtap10_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_adapt_adp_dfe_fxtap10_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap3_sgn_0) "radp_dfe_fxtap10_sgn_0"
   set value_map(radp_dfe_fltap3_sgn_1) "radp_dfe_fxtap10_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_adapt_adp_dfe_fxtap11 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_0) "radp_dfe_fxtap11_0"
   set value_map(radp_dfe_fltap4_1) "radp_dfe_fxtap11_1"
   set value_map(radp_dfe_fltap4_10) "radp_dfe_fxtap11_10"
   set value_map(radp_dfe_fltap4_11) "radp_dfe_fxtap11_11"
   set value_map(radp_dfe_fltap4_12) "radp_dfe_fxtap11_12"
   set value_map(radp_dfe_fltap4_13) "radp_dfe_fxtap11_13"
   set value_map(radp_dfe_fltap4_14) "radp_dfe_fxtap11_14"
   set value_map(radp_dfe_fltap4_15) "radp_dfe_fxtap11_15"
   set value_map(radp_dfe_fltap4_16) "radp_dfe_fxtap11_16"
   set value_map(radp_dfe_fltap4_17) "radp_dfe_fxtap11_17"
   set value_map(radp_dfe_fltap4_18) "radp_dfe_fxtap11_18"
   set value_map(radp_dfe_fltap4_19) "radp_dfe_fxtap11_19"
   set value_map(radp_dfe_fltap4_2) "radp_dfe_fxtap11_2"
   set value_map(radp_dfe_fltap4_20) "radp_dfe_fxtap11_20"
   set value_map(radp_dfe_fltap4_21) "radp_dfe_fxtap11_21"
   set value_map(radp_dfe_fltap4_22) "radp_dfe_fxtap11_22"
   set value_map(radp_dfe_fltap4_23) "radp_dfe_fxtap11_23"
   set value_map(radp_dfe_fltap4_24) "radp_dfe_fxtap11_24"
   set value_map(radp_dfe_fltap4_25) "radp_dfe_fxtap11_25"
   set value_map(radp_dfe_fltap4_26) "radp_dfe_fxtap11_26"
   set value_map(radp_dfe_fltap4_27) "radp_dfe_fxtap11_27"
   set value_map(radp_dfe_fltap4_28) "radp_dfe_fxtap11_28"
   set value_map(radp_dfe_fltap4_29) "radp_dfe_fxtap11_29"
   set value_map(radp_dfe_fltap4_3) "radp_dfe_fxtap11_3"
   set value_map(radp_dfe_fltap4_30) "radp_dfe_fxtap11_30"
   set value_map(radp_dfe_fltap4_31) "radp_dfe_fxtap11_31"
   set value_map(radp_dfe_fltap4_32) "radp_dfe_fxtap11_32"
   set value_map(radp_dfe_fltap4_33) "radp_dfe_fxtap11_33"
   set value_map(radp_dfe_fltap4_34) "radp_dfe_fxtap11_34"
   set value_map(radp_dfe_fltap4_35) "radp_dfe_fxtap11_35"
   set value_map(radp_dfe_fltap4_36) "radp_dfe_fxtap11_36"
   set value_map(radp_dfe_fltap4_37) "radp_dfe_fxtap11_37"
   set value_map(radp_dfe_fltap4_38) "radp_dfe_fxtap11_38"
   set value_map(radp_dfe_fltap4_39) "radp_dfe_fxtap11_39"
   set value_map(radp_dfe_fltap4_4) "radp_dfe_fxtap11_4"
   set value_map(radp_dfe_fltap4_40) "radp_dfe_fxtap11_40"
   set value_map(radp_dfe_fltap4_41) "radp_dfe_fxtap11_41"
   set value_map(radp_dfe_fltap4_42) "radp_dfe_fxtap11_42"
   set value_map(radp_dfe_fltap4_43) "radp_dfe_fxtap11_43"
   set value_map(radp_dfe_fltap4_44) "radp_dfe_fxtap11_44"
   set value_map(radp_dfe_fltap4_45) "radp_dfe_fxtap11_45"
   set value_map(radp_dfe_fltap4_46) "radp_dfe_fxtap11_46"
   set value_map(radp_dfe_fltap4_47) "radp_dfe_fxtap11_47"
   set value_map(radp_dfe_fltap4_48) "radp_dfe_fxtap11_48"
   set value_map(radp_dfe_fltap4_49) "radp_dfe_fxtap11_49"
   set value_map(radp_dfe_fltap4_5) "radp_dfe_fxtap11_5"
   set value_map(radp_dfe_fltap4_50) "radp_dfe_fxtap11_50"
   set value_map(radp_dfe_fltap4_51) "radp_dfe_fxtap11_51"
   set value_map(radp_dfe_fltap4_52) "radp_dfe_fxtap11_52"
   set value_map(radp_dfe_fltap4_53) "radp_dfe_fxtap11_53"
   set value_map(radp_dfe_fltap4_54) "radp_dfe_fxtap11_54"
   set value_map(radp_dfe_fltap4_55) "radp_dfe_fxtap11_55"
   set value_map(radp_dfe_fltap4_56) "radp_dfe_fxtap11_56"
   set value_map(radp_dfe_fltap4_57) "radp_dfe_fxtap11_57"
   set value_map(radp_dfe_fltap4_58) "radp_dfe_fxtap11_58"
   set value_map(radp_dfe_fltap4_59) "radp_dfe_fxtap11_59"
   set value_map(radp_dfe_fltap4_6) "radp_dfe_fxtap11_6"
   set value_map(radp_dfe_fltap4_60) "radp_dfe_fxtap11_60"
   set value_map(radp_dfe_fltap4_61) "radp_dfe_fxtap11_61"
   set value_map(radp_dfe_fltap4_62) "radp_dfe_fxtap11_62"
   set value_map(radp_dfe_fltap4_63) "radp_dfe_fxtap11_63"
   set value_map(radp_dfe_fltap4_7) "radp_dfe_fxtap11_7"
   set value_map(radp_dfe_fltap4_8) "radp_dfe_fxtap11_8"
   set value_map(radp_dfe_fltap4_9) "radp_dfe_fxtap11_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_adapt_adp_dfe_fxtap11_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap4_sgn_0) "radp_dfe_fxtap11_sgn_0"
   set value_map(radp_dfe_fltap4_sgn_1) "radp_dfe_fxtap11_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_adapt_adp_dfe_fxtap8 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_0) "radp_dfe_fxtap8_0"
   set value_map(radp_dfe_fltap1_1) "radp_dfe_fxtap8_1"
   set value_map(radp_dfe_fltap1_10) "radp_dfe_fxtap8_10"
   set value_map(radp_dfe_fltap1_11) "radp_dfe_fxtap8_11"
   set value_map(radp_dfe_fltap1_12) "radp_dfe_fxtap8_12"
   set value_map(radp_dfe_fltap1_13) "radp_dfe_fxtap8_13"
   set value_map(radp_dfe_fltap1_14) "radp_dfe_fxtap8_14"
   set value_map(radp_dfe_fltap1_15) "radp_dfe_fxtap8_15"
   set value_map(radp_dfe_fltap1_16) "radp_dfe_fxtap8_16"
   set value_map(radp_dfe_fltap1_17) "radp_dfe_fxtap8_17"
   set value_map(radp_dfe_fltap1_18) "radp_dfe_fxtap8_18"
   set value_map(radp_dfe_fltap1_19) "radp_dfe_fxtap8_19"
   set value_map(radp_dfe_fltap1_2) "radp_dfe_fxtap8_2"
   set value_map(radp_dfe_fltap1_20) "radp_dfe_fxtap8_20"
   set value_map(radp_dfe_fltap1_21) "radp_dfe_fxtap8_21"
   set value_map(radp_dfe_fltap1_22) "radp_dfe_fxtap8_22"
   set value_map(radp_dfe_fltap1_23) "radp_dfe_fxtap8_23"
   set value_map(radp_dfe_fltap1_24) "radp_dfe_fxtap8_24"
   set value_map(radp_dfe_fltap1_25) "radp_dfe_fxtap8_25"
   set value_map(radp_dfe_fltap1_26) "radp_dfe_fxtap8_26"
   set value_map(radp_dfe_fltap1_27) "radp_dfe_fxtap8_27"
   set value_map(radp_dfe_fltap1_28) "radp_dfe_fxtap8_28"
   set value_map(radp_dfe_fltap1_29) "radp_dfe_fxtap8_29"
   set value_map(radp_dfe_fltap1_3) "radp_dfe_fxtap8_3"
   set value_map(radp_dfe_fltap1_30) "radp_dfe_fxtap8_30"
   set value_map(radp_dfe_fltap1_31) "radp_dfe_fxtap8_31"
   set value_map(radp_dfe_fltap1_32) "radp_dfe_fxtap8_32"
   set value_map(radp_dfe_fltap1_33) "radp_dfe_fxtap8_33"
   set value_map(radp_dfe_fltap1_34) "radp_dfe_fxtap8_34"
   set value_map(radp_dfe_fltap1_35) "radp_dfe_fxtap8_35"
   set value_map(radp_dfe_fltap1_36) "radp_dfe_fxtap8_36"
   set value_map(radp_dfe_fltap1_37) "radp_dfe_fxtap8_37"
   set value_map(radp_dfe_fltap1_38) "radp_dfe_fxtap8_38"
   set value_map(radp_dfe_fltap1_39) "radp_dfe_fxtap8_39"
   set value_map(radp_dfe_fltap1_4) "radp_dfe_fxtap8_4"
   set value_map(radp_dfe_fltap1_40) "radp_dfe_fxtap8_40"
   set value_map(radp_dfe_fltap1_41) "radp_dfe_fxtap8_41"
   set value_map(radp_dfe_fltap1_42) "radp_dfe_fxtap8_42"
   set value_map(radp_dfe_fltap1_43) "radp_dfe_fxtap8_43"
   set value_map(radp_dfe_fltap1_44) "radp_dfe_fxtap8_44"
   set value_map(radp_dfe_fltap1_45) "radp_dfe_fxtap8_45"
   set value_map(radp_dfe_fltap1_46) "radp_dfe_fxtap8_46"
   set value_map(radp_dfe_fltap1_47) "radp_dfe_fxtap8_47"
   set value_map(radp_dfe_fltap1_48) "radp_dfe_fxtap8_48"
   set value_map(radp_dfe_fltap1_49) "radp_dfe_fxtap8_49"
   set value_map(radp_dfe_fltap1_5) "radp_dfe_fxtap8_5"
   set value_map(radp_dfe_fltap1_50) "radp_dfe_fxtap8_50"
   set value_map(radp_dfe_fltap1_51) "radp_dfe_fxtap8_51"
   set value_map(radp_dfe_fltap1_52) "radp_dfe_fxtap8_52"
   set value_map(radp_dfe_fltap1_53) "radp_dfe_fxtap8_53"
   set value_map(radp_dfe_fltap1_54) "radp_dfe_fxtap8_54"
   set value_map(radp_dfe_fltap1_55) "radp_dfe_fxtap8_55"
   set value_map(radp_dfe_fltap1_56) "radp_dfe_fxtap8_56"
   set value_map(radp_dfe_fltap1_57) "radp_dfe_fxtap8_57"
   set value_map(radp_dfe_fltap1_58) "radp_dfe_fxtap8_58"
   set value_map(radp_dfe_fltap1_59) "radp_dfe_fxtap8_59"
   set value_map(radp_dfe_fltap1_6) "radp_dfe_fxtap8_6"
   set value_map(radp_dfe_fltap1_60) "radp_dfe_fxtap8_60"
   set value_map(radp_dfe_fltap1_61) "radp_dfe_fxtap8_61"
   set value_map(radp_dfe_fltap1_62) "radp_dfe_fxtap8_62"
   set value_map(radp_dfe_fltap1_63) "radp_dfe_fxtap8_63"
   set value_map(radp_dfe_fltap1_7) "radp_dfe_fxtap8_7"
   set value_map(radp_dfe_fltap1_8) "radp_dfe_fxtap8_8"
   set value_map(radp_dfe_fltap1_9) "radp_dfe_fxtap8_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_adapt_adp_dfe_fxtap8_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap1_sgn_0) "radp_dfe_fxtap8_sgn_0"
   set value_map(radp_dfe_fltap1_sgn_1) "radp_dfe_fxtap8_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_adapt_adp_dfe_fxtap9 { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_0) "radp_dfe_fxtap9_0"
   set value_map(radp_dfe_fltap2_1) "radp_dfe_fxtap9_1"
   set value_map(radp_dfe_fltap2_10) "radp_dfe_fxtap9_10"
   set value_map(radp_dfe_fltap2_11) "radp_dfe_fxtap9_11"
   set value_map(radp_dfe_fltap2_12) "radp_dfe_fxtap9_12"
   set value_map(radp_dfe_fltap2_13) "radp_dfe_fxtap9_13"
   set value_map(radp_dfe_fltap2_14) "radp_dfe_fxtap9_14"
   set value_map(radp_dfe_fltap2_15) "radp_dfe_fxtap9_15"
   set value_map(radp_dfe_fltap2_16) "radp_dfe_fxtap9_16"
   set value_map(radp_dfe_fltap2_17) "radp_dfe_fxtap9_17"
   set value_map(radp_dfe_fltap2_18) "radp_dfe_fxtap9_18"
   set value_map(radp_dfe_fltap2_19) "radp_dfe_fxtap9_19"
   set value_map(radp_dfe_fltap2_2) "radp_dfe_fxtap9_2"
   set value_map(radp_dfe_fltap2_20) "radp_dfe_fxtap9_20"
   set value_map(radp_dfe_fltap2_21) "radp_dfe_fxtap9_21"
   set value_map(radp_dfe_fltap2_22) "radp_dfe_fxtap9_22"
   set value_map(radp_dfe_fltap2_23) "radp_dfe_fxtap9_23"
   set value_map(radp_dfe_fltap2_24) "radp_dfe_fxtap9_24"
   set value_map(radp_dfe_fltap2_25) "radp_dfe_fxtap9_25"
   set value_map(radp_dfe_fltap2_26) "radp_dfe_fxtap9_26"
   set value_map(radp_dfe_fltap2_27) "radp_dfe_fxtap9_27"
   set value_map(radp_dfe_fltap2_28) "radp_dfe_fxtap9_28"
   set value_map(radp_dfe_fltap2_29) "radp_dfe_fxtap9_29"
   set value_map(radp_dfe_fltap2_3) "radp_dfe_fxtap9_3"
   set value_map(radp_dfe_fltap2_30) "radp_dfe_fxtap9_30"
   set value_map(radp_dfe_fltap2_31) "radp_dfe_fxtap9_31"
   set value_map(radp_dfe_fltap2_32) "radp_dfe_fxtap9_32"
   set value_map(radp_dfe_fltap2_33) "radp_dfe_fxtap9_33"
   set value_map(radp_dfe_fltap2_34) "radp_dfe_fxtap9_34"
   set value_map(radp_dfe_fltap2_35) "radp_dfe_fxtap9_35"
   set value_map(radp_dfe_fltap2_36) "radp_dfe_fxtap9_36"
   set value_map(radp_dfe_fltap2_37) "radp_dfe_fxtap9_37"
   set value_map(radp_dfe_fltap2_38) "radp_dfe_fxtap9_38"
   set value_map(radp_dfe_fltap2_39) "radp_dfe_fxtap9_39"
   set value_map(radp_dfe_fltap2_4) "radp_dfe_fxtap9_4"
   set value_map(radp_dfe_fltap2_40) "radp_dfe_fxtap9_40"
   set value_map(radp_dfe_fltap2_41) "radp_dfe_fxtap9_41"
   set value_map(radp_dfe_fltap2_42) "radp_dfe_fxtap9_42"
   set value_map(radp_dfe_fltap2_43) "radp_dfe_fxtap9_43"
   set value_map(radp_dfe_fltap2_44) "radp_dfe_fxtap9_44"
   set value_map(radp_dfe_fltap2_45) "radp_dfe_fxtap9_45"
   set value_map(radp_dfe_fltap2_46) "radp_dfe_fxtap9_46"
   set value_map(radp_dfe_fltap2_47) "radp_dfe_fxtap9_47"
   set value_map(radp_dfe_fltap2_48) "radp_dfe_fxtap9_48"
   set value_map(radp_dfe_fltap2_49) "radp_dfe_fxtap9_49"
   set value_map(radp_dfe_fltap2_5) "radp_dfe_fxtap9_5"
   set value_map(radp_dfe_fltap2_50) "radp_dfe_fxtap9_50"
   set value_map(radp_dfe_fltap2_51) "radp_dfe_fxtap9_51"
   set value_map(radp_dfe_fltap2_52) "radp_dfe_fxtap9_52"
   set value_map(radp_dfe_fltap2_53) "radp_dfe_fxtap9_53"
   set value_map(radp_dfe_fltap2_54) "radp_dfe_fxtap9_54"
   set value_map(radp_dfe_fltap2_55) "radp_dfe_fxtap9_55"
   set value_map(radp_dfe_fltap2_56) "radp_dfe_fxtap9_56"
   set value_map(radp_dfe_fltap2_57) "radp_dfe_fxtap9_57"
   set value_map(radp_dfe_fltap2_58) "radp_dfe_fxtap9_58"
   set value_map(radp_dfe_fltap2_59) "radp_dfe_fxtap9_59"
   set value_map(radp_dfe_fltap2_6) "radp_dfe_fxtap9_6"
   set value_map(radp_dfe_fltap2_60) "radp_dfe_fxtap9_60"
   set value_map(radp_dfe_fltap2_61) "radp_dfe_fxtap9_61"
   set value_map(radp_dfe_fltap2_62) "radp_dfe_fxtap9_62"
   set value_map(radp_dfe_fltap2_63) "radp_dfe_fxtap9_63"
   set value_map(radp_dfe_fltap2_7) "radp_dfe_fxtap9_7"
   set value_map(radp_dfe_fltap2_8) "radp_dfe_fxtap9_8"
   set value_map(radp_dfe_fltap2_9) "radp_dfe_fxtap9_9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_adapt_adp_dfe_fxtap9_sgn { values } {
   set new_values {}

   set value_map(radp_dfe_fltap2_sgn_0) "radp_dfe_fxtap9_sgn_0"
   set value_map(radp_dfe_fltap2_sgn_1) "radp_dfe_fxtap9_sgn_1"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_cgb_scratch0_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch0_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch0_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch0_fpll_bot) "fpll_bot"
   set value_map(scratch0_fpll_top) "fpll_top"
   set value_map(scratch0_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch0_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch0_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch0_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch0_lcpll_bot) "lcpll_bot"
   set value_map(scratch0_lcpll_hs) "lcpll_hs"
   set value_map(scratch0_lcpll_top) "lcpll_top"
   set value_map(scratch0_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch0_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_cgb_scratch1_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch1_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch1_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch1_fpll_bot) "fpll_bot"
   set value_map(scratch1_fpll_top) "fpll_top"
   set value_map(scratch1_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch1_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch1_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch1_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch1_lcpll_bot) "lcpll_bot"
   set value_map(scratch1_lcpll_hs) "lcpll_hs"
   set value_map(scratch1_lcpll_top) "lcpll_top"
   set value_map(scratch1_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch1_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_cgb_scratch2_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch2_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch2_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch2_fpll_bot) "fpll_bot"
   set value_map(scratch2_fpll_top) "fpll_top"
   set value_map(scratch2_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch2_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch2_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch2_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch2_lcpll_bot) "lcpll_bot"
   set value_map(scratch2_lcpll_hs) "lcpll_hs"
   set value_map(scratch2_lcpll_top) "lcpll_top"
   set value_map(scratch2_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch2_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_cgb_scratch3_x1_clock_src { values } {
   set new_values {}

   set value_map(scratch3_cdr_txpll_b) "cdr_txpll_b"
   set value_map(scratch3_cdr_txpll_t) "cdr_txpll_t"
   set value_map(scratch3_fpll_bot) "fpll_bot"
   set value_map(scratch3_fpll_top) "fpll_top"
   set value_map(scratch3_hfclk_x6_dn) "hfclk_x6_dn"
   set value_map(scratch3_hfclk_x6_up) "hfclk_x6_up"
   set value_map(scratch3_hfclk_xn_dn) "hfclk_xn_dn"
   set value_map(scratch3_hfclk_xn_up) "hfclk_xn_up"
   set value_map(scratch3_lcpll_bot) "lcpll_bot"
   set value_map(scratch3_lcpll_hs) "lcpll_hs"
   set value_map(scratch3_lcpll_top) "lcpll_top"
   set value_map(scratch3_same_ch_txpll) "same_ch_txpll"
   set value_map(scratch3_unused) "unused"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_rx_deser_deser_factor { values } {
   set new_values {}

   set value_map(deser_10b) "10"
   set value_map(deser_16b) "16"
   set value_map(deser_20b) "20"
   set value_map(deser_32b) "32"
   set value_map(deser_40b) "40"
   set value_map(deser_64b) "64"
   set value_map(deser_8b) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_rx_deser_sdclk_enable { values } {
   set new_values {}

   set value_map(sd_clk_disabled) "false"
   set value_map(sd_clk_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_rx_sd_sd_output_off { values } {
   set new_values {}

   set value_map(clk_divrx_1) "0"
   set value_map(clk_divrx_2) "1"
   set value_map(clk_divrx_11) "10"
   set value_map(clk_divrx_12) "11"
   set value_map(clk_divrx_13) "12"
   set value_map(clk_divrx_14) "13"
   set value_map(force_sd_output_off_when_remote_tx_off_1clkdivrx) "14"
   set value_map(force_sd_output_off_when_remote_tx_off_2clkdivrx) "15"
   set value_map(force_sd_output_off_when_remote_tx_off_3clkdivrx) "16"
   set value_map(force_sd_output_off_when_remote_tx_off_4clkdivrx) "17"
   set value_map(force_sd_output_off_when_remote_tx_off_5clkdivrx) "18"
   set value_map(force_sd_output_off_when_remote_tx_off_6clkdivrx) "19"
   set value_map(clk_divrx_3) "2"
   set value_map(force_sd_output_off_when_remote_tx_off_7clkdivrx) "20"
   set value_map(force_sd_output_off_when_remote_tx_off_8clkdivrx) "21"
   set value_map(force_sd_output_off_when_remote_tx_off_9clkdivrx) "22"
   set value_map(force_sd_output_off_when_remote_tx_off_10clkdivrx) "23"
   set value_map(force_sd_output_off_when_remote_tx_off_11clkdivrx) "24"
   set value_map(force_sd_output_off_when_remote_tx_off_12clkdivrx) "25"
   set value_map(force_sd_output_off_when_remote_tx_off_13clkdivrx) "26"
   set value_map(force_sd_output_off_when_remote_tx_off_14clkdivrx) "27"
   set value_map(reserved_sd_output_off1) "28"
   set value_map(clk_divrx_4) "3"
   set value_map(clk_divrx_5) "4"
   set value_map(clk_divrx_6) "5"
   set value_map(clk_divrx_7) "6"
   set value_map(clk_divrx_8) "7"
   set value_map(clk_divrx_9) "8"
   set value_map(clk_divrx_10) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_xcvr_native::parameters::20nm3_convert_b2a_pma_rx_sd_sd_output_on { values } {
   set new_values {}

   set value_map(data_pulse_4) "0"
   set value_map(data_pulse_6) "1"
   set value_map(data_pulse_24) "10"
   set value_map(data_pulse_26) "11"
   set value_map(data_pulse_28) "12"
   set value_map(data_pulse_30) "13"
   set value_map(reserved_sd_output_on1) "14"
   set value_map(force_sd_output_on) "15"
   set value_map(data_pulse_8) "2"
   set value_map(data_pulse_10) "3"
   set value_map(data_pulse_12) "4"
   set value_map(data_pulse_14) "5"
   set value_map(data_pulse_16) "6"
   set value_map(data_pulse_18) "7"
   set value_map(data_pulse_20) "8"
   set value_map(data_pulse_22) "9"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

