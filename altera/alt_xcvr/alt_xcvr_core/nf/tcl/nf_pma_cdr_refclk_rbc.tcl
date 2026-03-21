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


proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_cdr_clkin_scratch0_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_cdr_clkin_scratch0_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "cdr_clkin_scratch0_src_refclk_coreclk" "cdr_clkin_scratch0_src_refclk_iqclk"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "cdr_clkin_scratch0_src_refclk_iqclk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_cdr_clkin_scratch0_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_cdr_clkin_scratch0_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_cdr_clkin_scratch0_src $pma_cdr_refclk_cdr_clkin_scratch0_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_cdr_clkin_scratch1_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_cdr_clkin_scratch1_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "cdr_clkin_scratch1_src_refclk_coreclk" "cdr_clkin_scratch1_src_refclk_iqclk"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "cdr_clkin_scratch1_src_refclk_iqclk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_cdr_clkin_scratch1_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_cdr_clkin_scratch1_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_cdr_clkin_scratch1_src $pma_cdr_refclk_cdr_clkin_scratch1_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_cdr_clkin_scratch2_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_cdr_clkin_scratch2_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "cdr_clkin_scratch2_src_refclk_coreclk" "cdr_clkin_scratch2_src_refclk_iqclk"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "cdr_clkin_scratch2_src_refclk_iqclk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_cdr_clkin_scratch2_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_cdr_clkin_scratch2_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_cdr_clkin_scratch2_src $pma_cdr_refclk_cdr_clkin_scratch2_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_cdr_clkin_scratch3_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_cdr_clkin_scratch3_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "cdr_clkin_scratch3_src_refclk_coreclk" "cdr_clkin_scratch3_src_refclk_iqclk"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "cdr_clkin_scratch3_src_refclk_iqclk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_cdr_clkin_scratch3_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_cdr_clkin_scratch3_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_cdr_clkin_scratch3_src $pma_cdr_refclk_cdr_clkin_scratch3_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_cdr_clkin_scratch4_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_cdr_clkin_scratch4_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "cdr_clkin_scratch4_src_refclk_coreclk" "cdr_clkin_scratch4_src_refclk_iqclk"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "cdr_clkin_scratch4_src_refclk_iqclk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_cdr_clkin_scratch4_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_cdr_clkin_scratch4_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_cdr_clkin_scratch4_src $pma_cdr_refclk_cdr_clkin_scratch4_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_receiver_detect_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_receiver_detect_src pma_cdr_refclk_powerdown_mode pma_cdr_refclk_xmux_refclk_src } {

   set legal_values [list "core_refclk_src" "iqclk_src"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "iqclk_src"]]
   } else {
      if [expr { ($pma_cdr_refclk_xmux_refclk_src=="refclk_iqclk") }] {
         set legal_values [intersect $legal_values [list "iqclk_src"]]
      } else {
         if [expr { ($pma_cdr_refclk_xmux_refclk_src=="refclk_coreclk") }] {
            set legal_values [intersect $legal_values [list "core_refclk_src"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_receiver_detect_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_receiver_detect_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_receiver_detect_src $pma_cdr_refclk_receiver_detect_src $legal_values { pma_cdr_refclk_powerdown_mode pma_cdr_refclk_xmux_refclk_src }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_xmux_refclk_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_xmux_refclk_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "refclk_coreclk" "refclk_iqclk"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "refclk_iqclk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_xmux_refclk_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_xmux_refclk_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_xmux_refclk_src $pma_cdr_refclk_xmux_refclk_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_xpm_iqref_mux_iqclk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_xpm_iqref_mux_iqclk_sel pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "iqtxrxclk0" "iqtxrxclk1" "iqtxrxclk2" "iqtxrxclk3" "iqtxrxclk4" "iqtxrxclk5" "power_down" "ref_iqclk0" "ref_iqclk1" "ref_iqclk10" "ref_iqclk11" "ref_iqclk2" "ref_iqclk3" "ref_iqclk4" "ref_iqclk5" "ref_iqclk6" "ref_iqclk7" "ref_iqclk8" "ref_iqclk9"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "power_down"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_xpm_iqref_mux_iqclk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_xpm_iqref_mux_iqclk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_xpm_iqref_mux_iqclk_sel $pma_cdr_refclk_xpm_iqref_mux_iqclk_sel $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_xpm_iqref_mux_scratch0_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_xpm_iqref_mux_scratch0_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "scratch0_iqtxrxclk0" "scratch0_iqtxrxclk1" "scratch0_iqtxrxclk2" "scratch0_iqtxrxclk3" "scratch0_iqtxrxclk4" "scratch0_iqtxrxclk5" "scratch0_power_down" "scratch0_ref_iqclk0" "scratch0_ref_iqclk1" "scratch0_ref_iqclk10" "scratch0_ref_iqclk11" "scratch0_ref_iqclk2" "scratch0_ref_iqclk3" "scratch0_ref_iqclk4" "scratch0_ref_iqclk5" "scratch0_ref_iqclk6" "scratch0_ref_iqclk7" "scratch0_ref_iqclk8" "scratch0_ref_iqclk9"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch0_power_down"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_xpm_iqref_mux_scratch0_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_xpm_iqref_mux_scratch0_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_xpm_iqref_mux_scratch0_src $pma_cdr_refclk_xpm_iqref_mux_scratch0_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_xpm_iqref_mux_scratch1_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_xpm_iqref_mux_scratch1_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "scratch1_iqtxrxclk0" "scratch1_iqtxrxclk1" "scratch1_iqtxrxclk2" "scratch1_iqtxrxclk3" "scratch1_iqtxrxclk4" "scratch1_iqtxrxclk5" "scratch1_power_down" "scratch1_ref_iqclk0" "scratch1_ref_iqclk1" "scratch1_ref_iqclk10" "scratch1_ref_iqclk11" "scratch1_ref_iqclk2" "scratch1_ref_iqclk3" "scratch1_ref_iqclk4" "scratch1_ref_iqclk5" "scratch1_ref_iqclk6" "scratch1_ref_iqclk7" "scratch1_ref_iqclk8" "scratch1_ref_iqclk9"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch1_power_down"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_xpm_iqref_mux_scratch1_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_xpm_iqref_mux_scratch1_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_xpm_iqref_mux_scratch1_src $pma_cdr_refclk_xpm_iqref_mux_scratch1_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_xpm_iqref_mux_scratch2_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_xpm_iqref_mux_scratch2_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "scratch2_iqtxrxclk0" "scratch2_iqtxrxclk1" "scratch2_iqtxrxclk2" "scratch2_iqtxrxclk3" "scratch2_iqtxrxclk4" "scratch2_iqtxrxclk5" "scratch2_power_down" "scratch2_ref_iqclk0" "scratch2_ref_iqclk1" "scratch2_ref_iqclk10" "scratch2_ref_iqclk11" "scratch2_ref_iqclk2" "scratch2_ref_iqclk3" "scratch2_ref_iqclk4" "scratch2_ref_iqclk5" "scratch2_ref_iqclk6" "scratch2_ref_iqclk7" "scratch2_ref_iqclk8" "scratch2_ref_iqclk9"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch2_power_down"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_xpm_iqref_mux_scratch2_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_xpm_iqref_mux_scratch2_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_xpm_iqref_mux_scratch2_src $pma_cdr_refclk_xpm_iqref_mux_scratch2_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_xpm_iqref_mux_scratch3_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_xpm_iqref_mux_scratch3_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "scratch3_iqtxrxclk0" "scratch3_iqtxrxclk1" "scratch3_iqtxrxclk2" "scratch3_iqtxrxclk3" "scratch3_iqtxrxclk4" "scratch3_iqtxrxclk5" "scratch3_power_down" "scratch3_ref_iqclk0" "scratch3_ref_iqclk1" "scratch3_ref_iqclk10" "scratch3_ref_iqclk11" "scratch3_ref_iqclk2" "scratch3_ref_iqclk3" "scratch3_ref_iqclk4" "scratch3_ref_iqclk5" "scratch3_ref_iqclk6" "scratch3_ref_iqclk7" "scratch3_ref_iqclk8" "scratch3_ref_iqclk9"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch3_power_down"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_xpm_iqref_mux_scratch3_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_xpm_iqref_mux_scratch3_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_xpm_iqref_mux_scratch3_src $pma_cdr_refclk_xpm_iqref_mux_scratch3_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_cdr_refclk_xpm_iqref_mux_scratch4_src { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_cdr_refclk_xpm_iqref_mux_scratch4_src pma_cdr_refclk_powerdown_mode } {

   set legal_values [list "scratch4_iqtxrxclk0" "scratch4_iqtxrxclk1" "scratch4_iqtxrxclk2" "scratch4_iqtxrxclk3" "scratch4_iqtxrxclk4" "scratch4_iqtxrxclk5" "scratch4_power_down" "scratch4_ref_iqclk0" "scratch4_ref_iqclk1" "scratch4_ref_iqclk10" "scratch4_ref_iqclk11" "scratch4_ref_iqclk2" "scratch4_ref_iqclk3" "scratch4_ref_iqclk4" "scratch4_ref_iqclk5" "scratch4_ref_iqclk6" "scratch4_ref_iqclk7" "scratch4_ref_iqclk8" "scratch4_ref_iqclk9"]

   if [expr { ($pma_cdr_refclk_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "scratch4_power_down"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_cdr_refclk_xpm_iqref_mux_scratch4_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_cdr_refclk_xpm_iqref_mux_scratch4_src $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_cdr_refclk_xpm_iqref_mux_scratch4_src $pma_cdr_refclk_xpm_iqref_mux_scratch4_src $legal_values { pma_cdr_refclk_powerdown_mode }
   }
}

