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


proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xmux_lc_scratch0_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch0_src_coreclk" "scratch0_src_iqclk" "scratch0_src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch0_src_lvpecl"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xmux_lc_scratch1_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch1_src_coreclk" "scratch1_src_iqclk" "scratch1_src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch1_src_lvpecl"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xmux_lc_scratch2_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch2_src_coreclk" "scratch2_src_iqclk" "scratch2_src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch2_src_lvpecl"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xmux_lc_scratch3_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch3_src_coreclk" "scratch3_src_iqclk" "scratch3_src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch3_src_lvpecl"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xmux_lc_scratch4_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch4_src_coreclk" "scratch4_src_iqclk" "scratch4_src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch4_src_lvpecl"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision atx_pll_fb_select hssi_pma_lc_refclk_select_mux_powerdown_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src  $device_revision $atx_pll_fb_select $hssi_pma_lc_refclk_select_mux_powerdown_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src  $device_revision $atx_pll_fb_select $hssi_pma_lc_refclk_select_mux_powerdown_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src  $device_revision $atx_pll_fb_select $hssi_pma_lc_refclk_select_mux_powerdown_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src  $device_revision $atx_pll_fb_select $hssi_pma_lc_refclk_select_mux_powerdown_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src  $device_revision $atx_pll_fb_select $hssi_pma_lc_refclk_select_mux_powerdown_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src  $device_revision $hssi_pma_lc_refclk_select_mux_powerdown_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src  $device_revision $atx_pll_fb_select $hssi_pma_lc_refclk_select_mux_powerdown_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src  $device_revision $atx_pll_fb_select $hssi_pma_lc_refclk_select_mux_powerdown_mode
	}
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xpm_iqref_mux_iqclk_sel { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "iqtxrxclk0" "iqtxrxclk1" "iqtxrxclk2" "iqtxrxclk3" "iqtxrxclk4" "iqtxrxclk5" "power_down" "ref_iqclk0" "ref_iqclk1" "ref_iqclk10" "ref_iqclk11" "ref_iqclk2" "ref_iqclk3" "ref_iqclk4" "ref_iqclk5" "ref_iqclk6" "ref_iqclk7" "ref_iqclk8" "ref_iqclk9"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "power_down"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xpm_iqref_mux_scratch0_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch0_iqtxrxclk0" "scratch0_iqtxrxclk1" "scratch0_iqtxrxclk2" "scratch0_iqtxrxclk3" "scratch0_iqtxrxclk4" "scratch0_iqtxrxclk5" "scratch0_power_down" "scratch0_ref_iqclk0" "scratch0_ref_iqclk1" "scratch0_ref_iqclk10" "scratch0_ref_iqclk11" "scratch0_ref_iqclk2" "scratch0_ref_iqclk3" "scratch0_ref_iqclk4" "scratch0_ref_iqclk5" "scratch0_ref_iqclk6" "scratch0_ref_iqclk7" "scratch0_ref_iqclk8" "scratch0_ref_iqclk9"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch0_power_down"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xpm_iqref_mux_scratch1_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch1_iqtxrxclk0" "scratch1_iqtxrxclk1" "scratch1_iqtxrxclk2" "scratch1_iqtxrxclk3" "scratch1_iqtxrxclk4" "scratch1_iqtxrxclk5" "scratch1_power_down" "scratch1_ref_iqclk0" "scratch1_ref_iqclk1" "scratch1_ref_iqclk10" "scratch1_ref_iqclk11" "scratch1_ref_iqclk2" "scratch1_ref_iqclk3" "scratch1_ref_iqclk4" "scratch1_ref_iqclk5" "scratch1_ref_iqclk6" "scratch1_ref_iqclk7" "scratch1_ref_iqclk8" "scratch1_ref_iqclk9"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch1_power_down"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xpm_iqref_mux_scratch2_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch2_iqtxrxclk0" "scratch2_iqtxrxclk1" "scratch2_iqtxrxclk2" "scratch2_iqtxrxclk3" "scratch2_iqtxrxclk4" "scratch2_iqtxrxclk5" "scratch2_power_down" "scratch2_ref_iqclk0" "scratch2_ref_iqclk1" "scratch2_ref_iqclk10" "scratch2_ref_iqclk11" "scratch2_ref_iqclk2" "scratch2_ref_iqclk3" "scratch2_ref_iqclk4" "scratch2_ref_iqclk5" "scratch2_ref_iqclk6" "scratch2_ref_iqclk7" "scratch2_ref_iqclk8" "scratch2_ref_iqclk9"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch2_power_down"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xpm_iqref_mux_scratch3_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch3_iqtxrxclk0" "scratch3_iqtxrxclk1" "scratch3_iqtxrxclk2" "scratch3_iqtxrxclk3" "scratch3_iqtxrxclk4" "scratch3_iqtxrxclk5" "scratch3_power_down" "scratch3_ref_iqclk0" "scratch3_ref_iqclk1" "scratch3_ref_iqclk10" "scratch3_ref_iqclk11" "scratch3_ref_iqclk2" "scratch3_ref_iqclk3" "scratch3_ref_iqclk4" "scratch3_ref_iqclk5" "scratch3_ref_iqclk6" "scratch3_ref_iqclk7" "scratch3_ref_iqclk8" "scratch3_ref_iqclk9"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch3_power_down"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_hssi_pma_lc_refclk_select_mux_xpm_iqref_mux_scratch4_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "scratch4_iqtxrxclk0" "scratch4_iqtxrxclk1" "scratch4_iqtxrxclk2" "scratch4_iqtxrxclk3" "scratch4_iqtxrxclk4" "scratch4_iqtxrxclk5" "scratch4_power_down" "scratch4_ref_iqclk0" "scratch4_ref_iqclk1" "scratch4_ref_iqclk10" "scratch4_ref_iqclk11" "scratch4_ref_iqclk2" "scratch4_ref_iqclk3" "scratch4_ref_iqclk4" "scratch4_ref_iqclk5" "scratch4_ref_iqclk6" "scratch4_ref_iqclk7" "scratch4_ref_iqclk8" "scratch4_ref_iqclk9"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch4_power_down"]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::20nm1_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision atx_pll_fb_select hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "src_coreclk" "src_iqclk" "src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode!="powerdown") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [exclude $legal_values [list "src_lvpecl"]]
      }
   }
   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "src_lvpecl"]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm2_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision atx_pll_fb_select hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "src_coreclk" "src_iqclk" "src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode!="powerdown") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [exclude $legal_values [list "src_lvpecl"]]
      }
   }
   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "src_lvpecl"]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm3_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision atx_pll_fb_select hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "src_coreclk" "src_iqclk" "src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode!="powerdown") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [exclude $legal_values [list "src_lvpecl"]]
      }
   }
   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "src_lvpecl"]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm4_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision atx_pll_fb_select hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "src_coreclk" "src_iqclk" "src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode!="powerdown") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [exclude $legal_values [list "src_lvpecl"]]
      }
   }
   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "src_lvpecl"]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm4es_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision atx_pll_fb_select hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "src_coreclk" "src_iqclk" "src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode!="powerdown") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [exclude $legal_values [list "src_lvpecl"]]
      }
   }
   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "src_lvpecl"]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision atx_pll_fb_select hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "src_coreclk" "src_iqclk" "src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode!="powerdown") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [exclude $legal_values [list "src_lvpecl"]]
      }
   }
   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "src_lvpecl"]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision atx_pll_fb_select hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "src_coreclk" "src_iqclk" "src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode!="powerdown") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [exclude $legal_values [list "src_lvpecl"]]
      }
   }
   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "src_lvpecl"]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5es_validate_hssi_pma_lc_refclk_select_mux_xmux_refclk_src { device_revision hssi_pma_lc_refclk_select_mux_powerdown_mode } {

   set legal_values [list "src_coreclk" "src_iqclk" "src_lvpecl"]

   if [expr { ($hssi_pma_lc_refclk_select_mux_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "src_lvpecl"]]
   }

   return $legal_values
}


