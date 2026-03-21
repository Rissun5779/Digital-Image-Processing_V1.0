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


proc ::nf_cmu_fpll::parameters::convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4_convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5_convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm4es_convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es2_convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm2_convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm5es_convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm1_convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_a2b_cmu_fpll_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode { value } {
   set value_map(false) "powerup"
   set value_map(true) "powerdown"

   return $value_map($value)
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c0_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c1_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c2_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c3_pllcout_enable { values } {
   set new_values {}

   set value_map(pllcout_disable) "false"
   set value_map(pllcout_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_0_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_0_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_0_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_1_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_1_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_1_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_2_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_2_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_2_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_3_coarse_dly { values } {
   set new_values {}

   set value_map(pll_coarse_dly_setting0) "0 ps"
   set value_map(pll_coarse_dly_setting5) "1.0 ns"
   set value_map(pll_coarse_dly_setting1) "200 ps"
   set value_map(pll_coarse_dly_setting2) "400 ps"
   set value_map(pll_coarse_dly_setting3) "600 ps"
   set value_map(pll_coarse_dly_setting4) "800 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_3_fine_dly { values } {
   set new_values {}

   set value_map(pll_fine_dly_setting0) "0 ps"
   set value_map(pll_fine_dly_setting2) "100 ps"
   set value_map(pll_fine_dly_setting3) "150 ps"
   set value_map(pll_fine_dly_setting1) "50 ps"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_c_counter_3_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_cal_status { values } {
   set new_values {}

   set value_map(calibration_not_okay) "false"
   set value_map(calibration_okay) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_calibration { values } {
   set new_values {}

   set value_map(fpll_cal_disable) "false"
   set value_map(fpll_cal_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_cmu_rstn_value { values } {
   set new_values {}

   set value_map(cmu_reset) "false"
   set value_map(cmu_normal) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_core_cali_ref_off { values } {
   set new_values {}

   set value_map(ref_off) "false"
   set value_map(ref_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_core_cali_vco_off { values } {
   set new_values {}

   set value_map(vco_off) "false"
   set value_map(vco_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_cp_compensation { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_ctrl_override_setting { values } {
   set new_values {}

   set value_map(pll_ctrl_disable) "false"
   set value_map(pll_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_ctrl_plniotri_override { values } {
   set new_values {}

   set value_map(plniotri_ctrl_disable) "false"
   set value_map(plniotri_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_dprio_broadcast_en { values } {
   set new_values {}

   set value_map(dprio_dprio_broadcast_en_csr_ctrl_disable) "false"
   set value_map(dprio_dprio_broadcast_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_dprio_cvp_inter_sel { values } {
   set new_values {}

   set value_map(dprio_cvp_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_cvp_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_dprio_force_inter_sel { values } {
   set new_values {}

   set value_map(dprio_force_inter_sel_csr_ctrl_disable) "false"
   set value_map(dprio_force_inter_sel_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_dprio_power_iso_en { values } {
   set new_values {}

   set value_map(dprio_power_iso_en_csr_ctrl_disable) "false"
   set value_map(dprio_power_iso_en_csr_ctrl_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_enable { values } {
   set new_values {}

   set value_map(pll_disabled) "false"
   set value_map(pll_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_l_counter_bypass { values } {
   set new_values {}

   set value_map(lcnt_normal) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_dis) "false"
   set value_map(lcnt_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_m_counter_min_tco_enable { values } {
   set new_values {}

   set value_map(cnt_bypass_dly) "false"
   set value_map(cnt_enable_dly) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_nreset_invert { values } {
   set new_values {}

   set value_map(nreset_noninv) "false"
   set value_map(nreset_inv) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_rstn_override { values } {
   set new_values {}

   set value_map(user_reset_normal) "false"
   set value_map(user_reset_override) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_self_reset { values } {
   set new_values {}

   set value_map(pll_slf_rst_off) "false"
   set value_map(pll_slf_rst_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_tclk_mux_en { values } {
   set new_values {}

   set value_map(pll_tclk_mux_disabled) "false"
   set value_map(pll_tclk_mux_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_test_enable { values } {
   set new_values {}

   set value_map(pll_testen_off) "false"
   set value_map(pll_testen_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_vccr_pd_en { values } {
   set new_values {}

   set value_map(vccd_powerdn) "false"
   set value_map(vccd_powerup) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_vco_ph0_en { values } {
   set new_values {}

   set value_map(pll_vco_ph0_dis_en) "false"
   set value_map(pll_vco_ph0_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_vco_ph1_en { values } {
   set new_values {}

   set value_map(pll_vco_ph1_dis_en) "false"
   set value_map(pll_vco_ph1_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_vco_ph2_en { values } {
   set new_values {}

   set value_map(pll_vco_ph2_dis_en) "false"
   set value_map(pll_vco_ph2_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_pll_vco_ph3_en { values } {
   set new_values {}

   set value_map(pll_vco_ph3_dis_en) "false"
   set value_map(pll_vco_ph3_en) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_auto_clk_sw_disabled) "false"
   set value_map(pll_auto_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { values } {
   set new_values {}

   set value_map(pll_clk_loss_sw_byps) "false"
   set value_map(pll_clk_loss_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch2_src_vss) "pll_clkin_0_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch2_src_core_ref_clk) "pll_clkin_0_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch2_src_lvpecl"
   set value_map(pll_clkin_0_scratch2_src_ref_clk) "pll_clkin_0_scratch2_src_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_adj_pll_clk) "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch2_src_lvpecl) "pll_clkin_0_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch3_src_vss) "pll_clkin_0_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch3_src_core_ref_clk) "pll_clkin_0_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch3_src_lvpecl"
   set value_map(pll_clkin_0_scratch3_src_ref_clk) "pll_clkin_0_scratch3_src_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_adj_pll_clk) "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch3_src_lvpecl) "pll_clkin_0_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_0_scratch4_src_vss) "pll_clkin_0_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_0_scratch4_src_core_ref_clk) "pll_clkin_0_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_0_scratch4_src_lvpecl"
   set value_map(pll_clkin_0_scratch4_src_ref_clk) "pll_clkin_0_scratch4_src_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_adj_pll_clk) "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_0_scratch4_src_lvpecl) "pll_clkin_0_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch0_src_vss) "pll_clkin_1_scratch0_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch0_src_core_ref_clk) "pll_clkin_1_scratch0_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch0_src_lvpecl"
   set value_map(pll_clkin_1_scratch0_src_ref_clk) "pll_clkin_1_scratch0_src_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_adj_pll_clk) "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch0_src_lvpecl) "pll_clkin_1_scratch0_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch1_src_vss) "pll_clkin_1_scratch1_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch1_src_core_ref_clk) "pll_clkin_1_scratch1_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch1_src_lvpecl"
   set value_map(pll_clkin_1_scratch1_src_ref_clk) "pll_clkin_1_scratch1_src_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_adj_pll_clk) "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch1_src_lvpecl) "pll_clkin_1_scratch1_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch2_src_vss) "pll_clkin_1_scratch2_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch2_src_core_ref_clk) "pll_clkin_1_scratch2_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch2_src_lvpecl"
   set value_map(pll_clkin_1_scratch2_src_ref_clk) "pll_clkin_1_scratch2_src_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_adj_pll_clk) "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch2_src_lvpecl) "pll_clkin_1_scratch2_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch3_src_vss) "pll_clkin_1_scratch3_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch3_src_core_ref_clk) "pll_clkin_1_scratch3_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch3_src_lvpecl"
   set value_map(pll_clkin_1_scratch3_src_ref_clk) "pll_clkin_1_scratch3_src_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_adj_pll_clk) "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch3_src_lvpecl) "pll_clkin_1_scratch3_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { values } {
   set new_values {}

   set value_map(pll_clkin_1_scratch4_src_vss) "pll_clkin_1_scratch4_src_adj_pll_clk"
   set value_map(pll_clkin_1_scratch4_src_core_ref_clk) "pll_clkin_1_scratch4_src_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_tx_rx_core_ref_clk) "pll_clkin_1_scratch4_src_lvpecl"
   set value_map(pll_clkin_1_scratch4_src_ref_clk) "pll_clkin_1_scratch4_src_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_adj_pll_clk) "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk"
   set value_map(pll_clkin_1_scratch4_src_lvpecl) "pll_clkin_1_scratch4_src_vss"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_cmu_fpll::parameters::20nm3_convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { values } {
   set new_values {}

   set value_map(pll_manu_clk_sw_disabled) "false"
   set value_map(pll_manu_clk_sw_enabled) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

