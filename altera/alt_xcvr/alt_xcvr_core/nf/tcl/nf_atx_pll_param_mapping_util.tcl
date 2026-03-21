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


proc ::nf_atx_pll::parameters::convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4_convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5_convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm4es_convert_a2b_atx_pll_l_counter_enable { value } {
   set value_map(false) "lcnt_off"
   set value_map(true) "lcnt_on"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm4es_convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_a2b_atx_pll_l_counter_enable { value } {
   set value_map(false) "lcnt_off"
   set value_map(true) "lcnt_on"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es2_convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm2_convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm5es_convert_a2b_atx_pll_l_counter_enable { value } {
   set value_map(false) "lcnt_off"
   set value_map(true) "lcnt_on"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm5es_convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm1_convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_a2b_atx_pll_bw_sel { value } {
   set value_map(high) "high_bw"
   set value_map(low) "low_bw"
   set value_map(medium) "mid_bw"

   return $value_map($value)
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_cp_compensation_enable { values } {
   set new_values {}

   set value_map(cp_mode_disable) "false"
   set value_map(cp_mode_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_dsm_ecn_bypass { values } {
   set new_values {}

   set value_map(pll_ecn_bypass_disable) "false"
   set value_map(pll_ecn_bypass_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_dsm_ecn_test_en { values } {
   set new_values {}

   set value_map(pll_ecn_test_disable) "false"
   set value_map(pll_ecn_test_enable) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_enable_lc_calibration { values } {
   set new_values {}

   set value_map(lc_cal_off) "false"
   set value_map(lc_cal_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_enable_lc_vreg_calibration { values } {
   set new_values {}

   set value_map(lc_cal_reg_off) "false"
   set value_map(lc_cal_reg_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_hclk_divide { values } {
   set new_values {}

   set value_map(hclk_disable) "1"
   set value_map(hclk_div40) "40"
   set value_map(hclk_div50) "50"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_l_counter { values } {
   set new_values {}

   set value_map(lcnt_div1) "1"
   set value_map(lcnt_div16) "16"
   set value_map(lcnt_div2) "2"
   set value_map(lcnt_div4) "4"
   set value_map(lcnt_div8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_l_counter_enable { values } {
   set new_values {}

   set value_map(lcnt_off) "false"
   set value_map(lcnt_on) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_ref_clk_div { values } {
   set new_values {}

   set value_map(bypass) "1"
   set value_map(divide2) "2"
   set value_map(divide4) "4"
   set value_map(divide8) "8"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

proc ::nf_atx_pll::parameters::20nm3_convert_b2a_atx_pll_vco_bypass_enable { values } {
   set new_values {}

   set value_map(lcnt_no_bypass) "false"
   set value_map(lcnt_bypass) "true"

   foreach value $values {
      lappend new_values $value_map($value)
   }
   return $new_values
}

