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


proc ::nf_atx_pll::parameters::validate_hssi_refclk_divider_clk_divider { device_revision hssi_refclk_divider_powerdown_mode } {

   set legal_values [list "div2_off" "div2_on"]

   if [expr { ($hssi_refclk_divider_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "div2_off"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_refclk_divider_clkbuf_sel { device_revision hssi_refclk_divider_iostandard hssi_refclk_divider_powerdown_mode } {

   set legal_values [list "high_vcm" "low_vcm"]

   if [expr { (($hssi_refclk_divider_powerdown_mode=="powerdown")||($hssi_refclk_divider_iostandard=="hcsl")) }] {
      set legal_values [intersect $legal_values [list "low_vcm"]]
   } else {
      set legal_values [intersect $legal_values [list "high_vcm"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_refclk_divider_core_clk_lvpecl { device_revision hssi_refclk_divider_powerdown_mode } {

   set legal_values [list "core_clk_lvpecl_off" "core_clk_lvpecl_on"]

   if [expr { ($hssi_refclk_divider_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "core_clk_lvpecl_off"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_refclk_divider_enable_lvpecl { device_revision hssi_refclk_divider_powerdown_mode } {

   set legal_values [list "lvpecl_disable" "lvpecl_enable"]

   if [expr { ($hssi_refclk_divider_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "lvpecl_disable"]]
   } else {
      set legal_values [intersect $legal_values [list "lvpecl_enable"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_refclk_divider_sel_pldclk { device_revision hssi_refclk_divider_powerdown_mode hssi_refclk_divider_sup_mode } {

   set legal_values [list "iqclk_sel_lvpecl" "iqclk_sel_pldclk"]

   if [expr { (($hssi_refclk_divider_powerdown_mode=="powerdown")||($hssi_refclk_divider_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "iqclk_sel_lvpecl"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_refclk_divider_term_tristate { device_revision hssi_refclk_divider_iostandard hssi_refclk_divider_optimal hssi_refclk_divider_powerdown_mode } {

   set legal_values [list "tristate_off" "tristate_on"]

   if [expr { (($hssi_refclk_divider_powerdown_mode=="powerdown")||($hssi_refclk_divider_iostandard=="hcsl")) }] {
      set legal_values [intersect $legal_values [list "tristate_on"]]
   } else {
      if [expr { ($hssi_refclk_divider_optimal=="true") }] {
         set legal_values [intersect $legal_values [list "tristate_off"]]
      }
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_refclk_divider_vcm_pup { device_revision hssi_refclk_divider_iostandard hssi_refclk_divider_powerdown_mode } {

   set legal_values [list "pup_off" "pup_on"]

   if [expr { (($hssi_refclk_divider_powerdown_mode=="powerdown")||($hssi_refclk_divider_iostandard=="hcsl")) }] {
      set legal_values [intersect $legal_values [list "pup_off"]]
   } else {
      set legal_values [intersect $legal_values [list "pup_on"]]
   }

   return $legal_values
}

