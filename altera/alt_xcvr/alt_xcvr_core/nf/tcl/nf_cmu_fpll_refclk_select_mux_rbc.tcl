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


proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_auto_clk_sw_disabled" "pll_auto_clk_sw_enabled"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_auto_clk_sw_disabled"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clk_loss_edge { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clk_loss_both_edges" "pll_clk_loss_rising_edge"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clk_loss_both_edges"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clk_loss_sw_byps" "pll_clk_loss_sw_enabled"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clk_loss_sw_byps"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clk_sel_override { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "normal" "override_clksel"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "normal"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clk_sel_override_value { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "select_clk0" "select_clk1"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "select_clk0"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clk_sw_dly { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list 0:7]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch0_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_0_scratch0_src_adj_pll_clk" "pll_clkin_0_scratch0_src_core_ref_clk" "pll_clkin_0_scratch0_src_lvpecl" "pll_clkin_0_scratch0_src_ref_clk" "pll_clkin_0_scratch0_src_tx_rx_core_ref_clk" "pll_clkin_0_scratch0_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_0_scratch0_src_vss"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch1_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_0_scratch1_src_adj_pll_clk" "pll_clkin_0_scratch1_src_core_ref_clk" "pll_clkin_0_scratch1_src_lvpecl" "pll_clkin_0_scratch1_src_ref_clk" "pll_clkin_0_scratch1_src_tx_rx_core_ref_clk" "pll_clkin_0_scratch1_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_0_scratch1_src_vss"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_0_scratch2_src_adj_pll_clk" "pll_clkin_0_scratch2_src_core_ref_clk" "pll_clkin_0_scratch2_src_lvpecl" "pll_clkin_0_scratch2_src_ref_clk" "pll_clkin_0_scratch2_src_tx_rx_core_ref_clk" "pll_clkin_0_scratch2_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_0_scratch2_src_vss"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch2_src $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_0_scratch3_src_adj_pll_clk" "pll_clkin_0_scratch3_src_core_ref_clk" "pll_clkin_0_scratch3_src_lvpecl" "pll_clkin_0_scratch3_src_ref_clk" "pll_clkin_0_scratch3_src_tx_rx_core_ref_clk" "pll_clkin_0_scratch3_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_0_scratch3_src_vss"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch3_src $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_0_scratch4_src_adj_pll_clk" "pll_clkin_0_scratch4_src_core_ref_clk" "pll_clkin_0_scratch4_src_lvpecl" "pll_clkin_0_scratch4_src_ref_clk" "pll_clkin_0_scratch4_src_tx_rx_core_ref_clk" "pll_clkin_0_scratch4_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_0_scratch4_src_vss"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_0_scratch4_src $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_0_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_0_src_adj_pll_clk" "pll_clkin_0_src_core_ref_clk" "pll_clkin_0_src_lvpecl" "pll_clkin_0_src_ref_clk" "pll_clkin_0_src_tx_rx_core_ref_clk" "pll_clkin_0_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_0_src_vss"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_1_scratch0_src_adj_pll_clk" "pll_clkin_1_scratch0_src_core_ref_clk" "pll_clkin_1_scratch0_src_lvpecl" "pll_clkin_1_scratch0_src_ref_clk" "pll_clkin_1_scratch0_src_tx_rx_core_ref_clk" "pll_clkin_1_scratch0_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_1_scratch0_src_vss"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch0_src $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_1_scratch1_src_adj_pll_clk" "pll_clkin_1_scratch1_src_core_ref_clk" "pll_clkin_1_scratch1_src_lvpecl" "pll_clkin_1_scratch1_src_ref_clk" "pll_clkin_1_scratch1_src_tx_rx_core_ref_clk" "pll_clkin_1_scratch1_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_1_scratch1_src_vss"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch1_src $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_1_scratch2_src_adj_pll_clk" "pll_clkin_1_scratch2_src_core_ref_clk" "pll_clkin_1_scratch2_src_lvpecl" "pll_clkin_1_scratch2_src_ref_clk" "pll_clkin_1_scratch2_src_tx_rx_core_ref_clk" "pll_clkin_1_scratch2_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_1_scratch2_src_vss"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch2_src $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_1_scratch3_src_adj_pll_clk" "pll_clkin_1_scratch3_src_core_ref_clk" "pll_clkin_1_scratch3_src_lvpecl" "pll_clkin_1_scratch3_src_ref_clk" "pll_clkin_1_scratch3_src_tx_rx_core_ref_clk" "pll_clkin_1_scratch3_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_1_scratch3_src_vss"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch3_src $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_1_scratch4_src_adj_pll_clk" "pll_clkin_1_scratch4_src_core_ref_clk" "pll_clkin_1_scratch4_src_lvpecl" "pll_clkin_1_scratch4_src_ref_clk" "pll_clkin_1_scratch4_src_tx_rx_core_ref_clk" "pll_clkin_1_scratch4_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_1_scratch4_src_vss"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_clkin_1_scratch4_src $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_clkin_1_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_clkin_1_src_adj_pll_clk" "pll_clkin_1_src_core_ref_clk" "pll_clkin_1_src_lvpecl" "pll_clkin_1_src_ref_clk" "pll_clkin_1_src_tx_rx_core_ref_clk" "pll_clkin_1_src_vss"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_clkin_1_src_vss"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_manu_clk_sw_disabled" "pll_manu_clk_sw_enabled"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_manu_clk_sw_disabled"]]
   }

   set legal_values [convert_b2a_cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en $legal_values]

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_pll_sw_refclk_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "pll_sw_refclk_src_clk_0" "pll_sw_refclk_src_clk_1"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "pll_sw_refclk_src_clk_0"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux0_iqclk_sel { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "iqtxrxclk0" "iqtxrxclk1" "iqtxrxclk2" "iqtxrxclk3" "iqtxrxclk4" "iqtxrxclk5" "power_down" "ref_iqclk0" "ref_iqclk1" "ref_iqclk10" "ref_iqclk11" "ref_iqclk2" "ref_iqclk3" "ref_iqclk4" "ref_iqclk5" "ref_iqclk6" "ref_iqclk7" "ref_iqclk8" "ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux0_scratch0_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch0_iqtxrxclk0" "scratch0_iqtxrxclk1" "scratch0_iqtxrxclk2" "scratch0_iqtxrxclk3" "scratch0_iqtxrxclk4" "scratch0_iqtxrxclk5" "scratch0_power_down" "scratch0_ref_iqclk0" "scratch0_ref_iqclk1" "scratch0_ref_iqclk10" "scratch0_ref_iqclk11" "scratch0_ref_iqclk2" "scratch0_ref_iqclk3" "scratch0_ref_iqclk4" "scratch0_ref_iqclk5" "scratch0_ref_iqclk6" "scratch0_ref_iqclk7" "scratch0_ref_iqclk8" "scratch0_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch0_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux0_scratch1_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch1_iqtxrxclk0" "scratch1_iqtxrxclk1" "scratch1_iqtxrxclk2" "scratch1_iqtxrxclk3" "scratch1_iqtxrxclk4" "scratch1_iqtxrxclk5" "scratch1_power_down" "scratch1_ref_iqclk0" "scratch1_ref_iqclk1" "scratch1_ref_iqclk10" "scratch1_ref_iqclk11" "scratch1_ref_iqclk2" "scratch1_ref_iqclk3" "scratch1_ref_iqclk4" "scratch1_ref_iqclk5" "scratch1_ref_iqclk6" "scratch1_ref_iqclk7" "scratch1_ref_iqclk8" "scratch1_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch1_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux0_scratch2_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch2_iqtxrxclk0" "scratch2_iqtxrxclk1" "scratch2_iqtxrxclk2" "scratch2_iqtxrxclk3" "scratch2_iqtxrxclk4" "scratch2_iqtxrxclk5" "scratch2_power_down" "scratch2_ref_iqclk0" "scratch2_ref_iqclk1" "scratch2_ref_iqclk10" "scratch2_ref_iqclk11" "scratch2_ref_iqclk2" "scratch2_ref_iqclk3" "scratch2_ref_iqclk4" "scratch2_ref_iqclk5" "scratch2_ref_iqclk6" "scratch2_ref_iqclk7" "scratch2_ref_iqclk8" "scratch2_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch2_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux0_scratch3_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch3_iqtxrxclk0" "scratch3_iqtxrxclk1" "scratch3_iqtxrxclk2" "scratch3_iqtxrxclk3" "scratch3_iqtxrxclk4" "scratch3_iqtxrxclk5" "scratch3_power_down" "scratch3_ref_iqclk0" "scratch3_ref_iqclk1" "scratch3_ref_iqclk10" "scratch3_ref_iqclk11" "scratch3_ref_iqclk2" "scratch3_ref_iqclk3" "scratch3_ref_iqclk4" "scratch3_ref_iqclk5" "scratch3_ref_iqclk6" "scratch3_ref_iqclk7" "scratch3_ref_iqclk8" "scratch3_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch3_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux0_scratch4_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch4_iqtxrxclk0" "scratch4_iqtxrxclk1" "scratch4_iqtxrxclk2" "scratch4_iqtxrxclk3" "scratch4_iqtxrxclk4" "scratch4_iqtxrxclk5" "scratch4_power_down" "scratch4_ref_iqclk0" "scratch4_ref_iqclk1" "scratch4_ref_iqclk10" "scratch4_ref_iqclk11" "scratch4_ref_iqclk2" "scratch4_ref_iqclk3" "scratch4_ref_iqclk4" "scratch4_ref_iqclk5" "scratch4_ref_iqclk6" "scratch4_ref_iqclk7" "scratch4_ref_iqclk8" "scratch4_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch4_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux1_iqclk_sel { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "iqtxrxclk0" "iqtxrxclk1" "iqtxrxclk2" "iqtxrxclk3" "iqtxrxclk4" "iqtxrxclk5" "power_down" "ref_iqclk0" "ref_iqclk1" "ref_iqclk10" "ref_iqclk11" "ref_iqclk2" "ref_iqclk3" "ref_iqclk4" "ref_iqclk5" "ref_iqclk6" "ref_iqclk7" "ref_iqclk8" "ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux1_scratch0_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch0_iqtxrxclk0" "scratch0_iqtxrxclk1" "scratch0_iqtxrxclk2" "scratch0_iqtxrxclk3" "scratch0_iqtxrxclk4" "scratch0_iqtxrxclk5" "scratch0_power_down" "scratch0_ref_iqclk0" "scratch0_ref_iqclk1" "scratch0_ref_iqclk10" "scratch0_ref_iqclk11" "scratch0_ref_iqclk2" "scratch0_ref_iqclk3" "scratch0_ref_iqclk4" "scratch0_ref_iqclk5" "scratch0_ref_iqclk6" "scratch0_ref_iqclk7" "scratch0_ref_iqclk8" "scratch0_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch0_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux1_scratch1_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch1_iqtxrxclk0" "scratch1_iqtxrxclk1" "scratch1_iqtxrxclk2" "scratch1_iqtxrxclk3" "scratch1_iqtxrxclk4" "scratch1_iqtxrxclk5" "scratch1_power_down" "scratch1_ref_iqclk0" "scratch1_ref_iqclk1" "scratch1_ref_iqclk10" "scratch1_ref_iqclk11" "scratch1_ref_iqclk2" "scratch1_ref_iqclk3" "scratch1_ref_iqclk4" "scratch1_ref_iqclk5" "scratch1_ref_iqclk6" "scratch1_ref_iqclk7" "scratch1_ref_iqclk8" "scratch1_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch1_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux1_scratch2_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch2_iqtxrxclk0" "scratch2_iqtxrxclk1" "scratch2_iqtxrxclk2" "scratch2_iqtxrxclk3" "scratch2_iqtxrxclk4" "scratch2_iqtxrxclk5" "scratch2_power_down" "scratch2_ref_iqclk0" "scratch2_ref_iqclk1" "scratch2_ref_iqclk10" "scratch2_ref_iqclk11" "scratch2_ref_iqclk2" "scratch2_ref_iqclk3" "scratch2_ref_iqclk4" "scratch2_ref_iqclk5" "scratch2_ref_iqclk6" "scratch2_ref_iqclk7" "scratch2_ref_iqclk8" "scratch2_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch2_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux1_scratch3_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch3_iqtxrxclk0" "scratch3_iqtxrxclk1" "scratch3_iqtxrxclk2" "scratch3_iqtxrxclk3" "scratch3_iqtxrxclk4" "scratch3_iqtxrxclk5" "scratch3_power_down" "scratch3_ref_iqclk0" "scratch3_ref_iqclk1" "scratch3_ref_iqclk10" "scratch3_ref_iqclk11" "scratch3_ref_iqclk2" "scratch3_ref_iqclk3" "scratch3_ref_iqclk4" "scratch3_ref_iqclk5" "scratch3_ref_iqclk6" "scratch3_ref_iqclk7" "scratch3_ref_iqclk8" "scratch3_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch3_power_down"]]
   }

   return $legal_values
}

proc ::nf_cmu_fpll::parameters::validate_cmu_fpll_refclk_select_mux_xpm_iqref_mux1_scratch4_src { device_revision cmu_fpll_refclk_select_mux_pll_powerdown_mode } {
   set cmu_fpll_refclk_select_mux_pll_powerdown_mode [convert_a2b_cmu_fpll_refclk_select_mux_pll_powerdown_mode $cmu_fpll_refclk_select_mux_pll_powerdown_mode]

   set legal_values [list "scratch4_iqtxrxclk0" "scratch4_iqtxrxclk1" "scratch4_iqtxrxclk2" "scratch4_iqtxrxclk3" "scratch4_iqtxrxclk4" "scratch4_iqtxrxclk5" "scratch4_power_down" "scratch4_ref_iqclk0" "scratch4_ref_iqclk1" "scratch4_ref_iqclk10" "scratch4_ref_iqclk11" "scratch4_ref_iqclk2" "scratch4_ref_iqclk3" "scratch4_ref_iqclk4" "scratch4_ref_iqclk5" "scratch4_ref_iqclk6" "scratch4_ref_iqclk7" "scratch4_ref_iqclk8" "scratch4_ref_iqclk9"]

   if [expr { ($cmu_fpll_refclk_select_mux_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch4_power_down"]]
   }

   return $legal_values
}

