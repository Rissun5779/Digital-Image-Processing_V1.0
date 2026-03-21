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


proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_bonding_reset_enable { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_bonding_reset_enable hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "allow_bonding_reset" "disallow_bonding_reset"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "disallow_bonding_reset"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_bonding_reset_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_bonding_reset_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_bonding_reset_enable $hssi_pma_cgb_master_bonding_reset_enable $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_cgb_enable_iqtxrxclk { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_cgb_enable_iqtxrxclk hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "disable_iqtxrxclk" "enable_iqtxrxclk"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "disable_iqtxrxclk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_cgb_enable_iqtxrxclk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_cgb_enable_iqtxrxclk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_cgb_enable_iqtxrxclk $hssi_pma_cgb_master_cgb_enable_iqtxrxclk $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_cgb_power_down { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_cgb_power_down hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "normal_cgb" "power_down_cgb"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "power_down_cgb"]]
   } else {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "normal_cgb"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_cgb_power_down.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_cgb_power_down $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_cgb_power_down $hssi_pma_cgb_master_cgb_power_down $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_dft_iqtxrxclk_control { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_dft_iqtxrxclk_control hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "dft_iqtxrxclk_drv_high" "dft_iqtxrxclk_drv_low"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_sup_mode=="user_mode")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "dft_iqtxrxclk_drv_low"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_dft_iqtxrxclk_control.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_dft_iqtxrxclk_control $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_dft_iqtxrxclk_control $hssi_pma_cgb_master_dft_iqtxrxclk_control $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_master_cgb_clock_control0 { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_master_cgb_clock_control0 hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "master_cgb_dft_control_high0" "master_cgb_dft_control_low0" "master_cgb_no_dft_control0"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_sup_mode=="user_mode")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "master_cgb_no_dft_control0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_master_cgb_clock_control0.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_master_cgb_clock_control0 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_master_cgb_clock_control0 $hssi_pma_cgb_master_master_cgb_clock_control0 $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_master_cgb_clock_control1 { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_master_cgb_clock_control1 hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "master_cgb_dft_control_high1" "master_cgb_dft_control_low1" "master_cgb_no_dft_control1"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_sup_mode=="user_mode")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "master_cgb_no_dft_control1"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_master_cgb_clock_control1.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_master_cgb_clock_control1 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_master_cgb_clock_control1 $hssi_pma_cgb_master_master_cgb_clock_control1 $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_master_cgb_clock_control2 { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_master_cgb_clock_control2 hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "master_cgb_dft_control_high2" "master_cgb_dft_control_low2" "master_cgb_no_dft_control2"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_sup_mode=="user_mode")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "master_cgb_no_dft_control2"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_master_cgb_clock_control2.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_master_cgb_clock_control2 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_master_cgb_clock_control2 $hssi_pma_cgb_master_master_cgb_clock_control2 $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_master_cgb_clock_control3 { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_master_cgb_clock_control3 hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "master_cgb_dft_control_high3" "master_cgb_dft_control_low3" "master_cgb_no_dft_control3"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_sup_mode=="user_mode")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "master_cgb_no_dft_control3"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_master_cgb_clock_control3.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_master_cgb_clock_control3 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_master_cgb_clock_control3 $hssi_pma_cgb_master_master_cgb_clock_control3 $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_master_cgb_clock_control4 { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_master_cgb_clock_control4 hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "master_cgb_dft_control_high4" "master_cgb_dft_control_low4" "master_cgb_no_dft_control4"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_sup_mode=="user_mode")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "master_cgb_no_dft_control4"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_master_cgb_clock_control4.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_master_cgb_clock_control4 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_master_cgb_clock_control4 $hssi_pma_cgb_master_master_cgb_clock_control4 $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_master_cgb_clock_control5 { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_master_cgb_clock_control5 hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "master_cgb_dft_control_high5" "master_cgb_dft_control_low5" "master_cgb_no_dft_control5"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_sup_mode=="user_mode")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "master_cgb_no_dft_control5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_master_cgb_clock_control5.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_master_cgb_clock_control5 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_master_cgb_clock_control5 $hssi_pma_cgb_master_master_cgb_clock_control5 $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_mcgb_high_perf_datarate_limit { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_mcgb_high_perf_datarate_limit } {

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 17000000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pma_cgb_master_mcgb_high_perf_datarate_limit.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_high_perf_datarate_limit $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_high_perf_datarate_limit $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pma_cgb_master_mcgb_high_perf_datarate_limit $hssi_pma_cgb_master_mcgb_high_perf_datarate_limit $legal_values { }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_mcgb_high_perf_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_mcgb_high_perf_voltage } {

   set legal_values [list 0:4095]

   set legal_values [compare_eq $legal_values 1100]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pma_cgb_master_mcgb_high_perf_voltage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_high_perf_voltage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_high_perf_voltage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pma_cgb_master_mcgb_high_perf_voltage $hssi_pma_cgb_master_mcgb_high_perf_voltage $legal_values { }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_mcgb_low_power_datarate_limit { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_mcgb_low_power_datarate_limit } {

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 12500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pma_cgb_master_mcgb_low_power_datarate_limit.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_low_power_datarate_limit $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_low_power_datarate_limit $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pma_cgb_master_mcgb_low_power_datarate_limit $hssi_pma_cgb_master_mcgb_low_power_datarate_limit $legal_values { }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_mcgb_low_power_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_mcgb_low_power_voltage } {

   set legal_values [list 0:4095]

   set legal_values [compare_eq $legal_values 900]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pma_cgb_master_mcgb_low_power_voltage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_low_power_voltage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_low_power_voltage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pma_cgb_master_mcgb_low_power_voltage $hssi_pma_cgb_master_mcgb_low_power_voltage $legal_values { }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_mcgb_mid_power_datarate_limit { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_mcgb_mid_power_datarate_limit } {

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 17000000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pma_cgb_master_mcgb_mid_power_datarate_limit.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_mid_power_datarate_limit $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_mid_power_datarate_limit $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pma_cgb_master_mcgb_mid_power_datarate_limit $hssi_pma_cgb_master_mcgb_mid_power_datarate_limit $legal_values { }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_mcgb_mid_power_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_mcgb_mid_power_voltage } {

   set legal_values [list 0:4095]

   set legal_values [compare_eq $legal_values 1000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pma_cgb_master_mcgb_mid_power_voltage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_mid_power_voltage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pma_cgb_master_mcgb_mid_power_voltage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pma_cgb_master_mcgb_mid_power_voltage $hssi_pma_cgb_master_mcgb_mid_power_voltage $legal_values { }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_observe_cgb_clocks { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_observe_cgb_clocks hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "observe_nothing" "observe_x1mux_out"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_sup_mode=="user_mode")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "observe_nothing"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_observe_cgb_clocks.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_observe_cgb_clocks $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_observe_cgb_clocks $hssi_pma_cgb_master_observe_cgb_clocks $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_pcie_gen3_bitwidth { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_pcie_gen3_bitwidth } {

   set legal_values [list "pciegen3_narrow" "pciegen3_wide"]

   set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "pciegen3_wide"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_pcie_gen3_bitwidth.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_pcie_gen3_bitwidth $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_pcie_gen3_bitwidth $hssi_pma_cgb_master_pcie_gen3_bitwidth $legal_values { }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sata_tx" "unused"]

   if [expr { ($hssi_pma_cgb_master_powerdown_mode=="powerdown") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_prot_mode $hssi_pma_cgb_master_prot_mode $legal_values { hssi_pma_cgb_master_powerdown_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_scratch0_x1_clock_src { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_scratch0_x1_clock_src hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "scratch0_fpll_bot" "scratch0_fpll_top" "scratch0_lcpll_bot" "scratch0_lcpll_top" "scratch0_unused"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "scratch0_unused"]]
   }

   set legal_values [convert_b2a_hssi_pma_cgb_master_scratch0_x1_clock_src $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_scratch0_x1_clock_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_scratch0_x1_clock_src $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_scratch0_x1_clock_src $hssi_pma_cgb_master_scratch0_x1_clock_src $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_scratch1_x1_clock_src { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_scratch1_x1_clock_src hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "scratch1_fpll_bot" "scratch1_fpll_top" "scratch1_lcpll_bot" "scratch1_lcpll_top" "scratch1_unused"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "scratch1_unused"]]
   }

   set legal_values [convert_b2a_hssi_pma_cgb_master_scratch1_x1_clock_src $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_scratch1_x1_clock_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_scratch1_x1_clock_src $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_scratch1_x1_clock_src $hssi_pma_cgb_master_scratch1_x1_clock_src $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_scratch2_x1_clock_src { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_scratch2_x1_clock_src hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "scratch2_fpll_bot" "scratch2_fpll_top" "scratch2_lcpll_bot" "scratch2_lcpll_top" "scratch2_unused"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "scratch2_unused"]]
   }

   set legal_values [convert_b2a_hssi_pma_cgb_master_scratch2_x1_clock_src $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_scratch2_x1_clock_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_scratch2_x1_clock_src $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_scratch2_x1_clock_src $hssi_pma_cgb_master_scratch2_x1_clock_src $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_scratch3_x1_clock_src { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_scratch3_x1_clock_src hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "scratch3_fpll_bot" "scratch3_fpll_top" "scratch3_lcpll_bot" "scratch3_lcpll_top" "scratch3_unused"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "scratch3_unused"]]
   }

   set legal_values [convert_b2a_hssi_pma_cgb_master_scratch3_x1_clock_src $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_scratch3_x1_clock_src.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_scratch3_x1_clock_src $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_scratch3_x1_clock_src $hssi_pma_cgb_master_scratch3_x1_clock_src $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_ser_mode { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_ser_mode hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "eight_bit" "forty_bit" "sixteen_bit" "sixty_four_bit" "ten_bit" "thirty_two_bit" "twenty_bit"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "eight_bit"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_ser_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_ser_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_ser_mode $hssi_pma_cgb_master_ser_mode $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_tx_ucontrol_en { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_tx_ucontrol_en hssi_pma_cgb_master_initial_settings hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_initial_settings=="true")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_tx_ucontrol_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_tx_ucontrol_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_tx_ucontrol_en $hssi_pma_cgb_master_tx_ucontrol_en $legal_values { hssi_pma_cgb_master_initial_settings hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_tx_ucontrol_pcie { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_tx_ucontrol_pcie hssi_pma_cgb_master_initial_settings hssi_pma_cgb_master_tx_ucontrol_en } {

   set legal_values [list "gen1" "gen2" "gen3" "gen4"]

   if [expr { (($hssi_pma_cgb_master_tx_ucontrol_en=="disable")||($hssi_pma_cgb_master_initial_settings=="true")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "gen1"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_tx_ucontrol_pcie.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_tx_ucontrol_pcie $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_tx_ucontrol_pcie $hssi_pma_cgb_master_tx_ucontrol_pcie $legal_values { hssi_pma_cgb_master_initial_settings hssi_pma_cgb_master_tx_ucontrol_en }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_tx_ucontrol_reset { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_tx_ucontrol_reset hssi_pma_cgb_master_initial_settings hssi_pma_cgb_master_tx_ucontrol_en } {

   set legal_values [list "disable" "enable"]

   if [expr { (($hssi_pma_cgb_master_tx_ucontrol_en=="disable")||($hssi_pma_cgb_master_initial_settings=="true")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_tx_ucontrol_reset.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_tx_ucontrol_reset $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_tx_ucontrol_reset $hssi_pma_cgb_master_tx_ucontrol_reset $legal_values { hssi_pma_cgb_master_initial_settings hssi_pma_cgb_master_tx_ucontrol_en }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_vccdreg_output { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_vccdreg_output hssi_pma_cgb_master_initial_settings hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "vccdreg_neg_setting1" "vccdreg_neg_setting2" "vccdreg_neg_setting3" "vccdreg_neg_setting4" "vccdreg_nominal" "vccdreg_pos_setting1" "vccdreg_pos_setting10" "vccdreg_pos_setting11" "vccdreg_pos_setting12" "vccdreg_pos_setting13" "vccdreg_pos_setting14" "vccdreg_pos_setting15" "vccdreg_pos_setting16" "vccdreg_pos_setting17" "vccdreg_pos_setting18" "vccdreg_pos_setting19" "vccdreg_pos_setting2" "vccdreg_pos_setting20" "vccdreg_pos_setting21" "vccdreg_pos_setting22" "vccdreg_pos_setting23" "vccdreg_pos_setting24" "vccdreg_pos_setting25" "vccdreg_pos_setting26" "vccdreg_pos_setting27" "vccdreg_pos_setting3" "vccdreg_pos_setting4" "vccdreg_pos_setting5" "vccdreg_pos_setting6" "vccdreg_pos_setting7" "vccdreg_pos_setting8" "vccdreg_pos_setting9"]

   if [expr { (($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_initial_settings=="true")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "vccdreg_nominal"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_vccdreg_output.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_vccdreg_output $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_vccdreg_output $hssi_pma_cgb_master_vccdreg_output $legal_values { hssi_pma_cgb_master_initial_settings hssi_pma_cgb_master_prot_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_x1_clock_source_sel { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_x1_clock_source_sel hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode } {

   set legal_values [list "fpll_bot" "fpll_bot_g1_g2" "fpll_bot_g2_lcpll_bot_g3" "fpll_bot_g2_lcpll_top_g3" "fpll_top" "fpll_top_g1_g2" "fpll_top_g2_lcpll_bot_g3" "fpll_top_g2_lcpll_top_g3" "lcpll_bot" "lcpll_bot_g1_g2" "lcpll_top" "lcpll_top_g1_g2"]

   if [expr { ($hssi_pma_cgb_master_prot_mode=="unused") }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "lcpll_top"]]
   } else {
      if [expr { ($hssi_pma_cgb_master_prot_mode=="pcie_gen1_tx") }] {
         if [expr { ($hssi_pma_cgb_master_sup_mode=="user_mode") }] {
            set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "lcpll_bot_g1_g2" "lcpll_top_g1_g2" "fpll_bot_g1_g2" "fpll_top_g1_g2"]]
         } else {
            if [expr { ($hssi_pma_cgb_master_sup_mode=="engineering_mode") }] {
               set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "lcpll_bot_g1_g2" "lcpll_top_g1_g2" "fpll_bot_g1_g2" "fpll_top_g1_g2"]]
            }
         }
      } else {
         if [expr { ($hssi_pma_cgb_master_prot_mode=="pcie_gen2_tx") }] {
            set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "lcpll_bot_g1_g2" "lcpll_top_g1_g2" "fpll_bot_g1_g2" "fpll_top_g1_g2"]]
         } else {
            if [expr { (($hssi_pma_cgb_master_prot_mode=="pcie_gen3_tx")||($hssi_pma_cgb_master_prot_mode=="pcie_gen4_tx")) }] {
               set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "fpll_bot_g2_lcpll_bot_g3" "fpll_bot_g2_lcpll_top_g3" "fpll_top_g2_lcpll_bot_g3" "fpll_top_g2_lcpll_top_g3"]]
            } else {
               set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "lcpll_top" "lcpll_bot" "fpll_top" "fpll_bot"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_x1_clock_source_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_x1_clock_source_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_x1_clock_source_sel $hssi_pma_cgb_master_x1_clock_source_sel $legal_values { hssi_pma_cgb_master_prot_mode hssi_pma_cgb_master_sup_mode }
   }
}

proc ::nf_hssi_pma_cgb_master::parameters::validate_hssi_pma_cgb_master_x1_div_m_sel { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_pma_cgb_master_x1_div_m_sel hssi_pma_cgb_master_prot_mode } {

   set legal_values [list "divby2" "divby4" "divby8" "divbypass"]

   if [expr { ((((($hssi_pma_cgb_master_prot_mode=="unused")||($hssi_pma_cgb_master_prot_mode=="pcie_gen1_tx"))||($hssi_pma_cgb_master_prot_mode=="pcie_gen2_tx"))||($hssi_pma_cgb_master_prot_mode=="pcie_gen3_tx"))||($hssi_pma_cgb_master_prot_mode=="pcie_gen4_tx")) }] {
      set legal_values [::nf_atx_pll::parameters::intersect $legal_values [list "divbypass"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pma_cgb_master_x1_div_m_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pma_cgb_master_x1_div_m_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pma_cgb_master_x1_div_m_sel $hssi_pma_cgb_master_x1_div_m_sel $legal_values { hssi_pma_cgb_master_prot_mode }
   }
}

