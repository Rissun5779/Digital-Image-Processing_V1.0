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


proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_bonding_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_bonding_mode pma_tx_buf_xtx_path_bonding_mode } {

   set legal_values [list "x1_non_bonded" "x1_reset_bonded" "x6_xn_bonded" "xn_non_bonded"]

   if [expr { ($pma_tx_buf_xtx_path_bonding_mode=="x1_non_bonded") }] {
      set legal_values [intersect $legal_values [list "x1_non_bonded"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_bonding_mode=="x1_reset_bonded") }] {
      set legal_values [intersect $legal_values [list "x1_reset_bonded"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_bonding_mode=="xn_non_bonded") }] {
      set legal_values [intersect $legal_values [list "xn_non_bonded"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_bonding_mode=="x6_xn_bonded") }] {
      set legal_values [intersect $legal_values [list "x6_xn_bonded"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_bonding_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_bonding_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_bonding_mode $pma_tx_ser_bonding_mode $legal_values { pma_tx_buf_xtx_path_bonding_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_clk_divtx_deskew { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_clk_divtx_deskew pma_tx_ser_bonding_mode pma_tx_ser_prot_mode } {

   set legal_values [list "deskew_delay0" "deskew_delay1" "deskew_delay10" "deskew_delay11" "deskew_delay12" "deskew_delay13" "deskew_delay14" "deskew_delay15" "deskew_delay2" "deskew_delay3" "deskew_delay4" "deskew_delay5" "deskew_delay6" "deskew_delay7" "deskew_delay8" "deskew_delay9"]

   if [expr { (((($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_bonding_mode=="x1_non_bonded"))||($pma_tx_ser_bonding_mode=="xn_non_bonded"))||($pma_tx_ser_bonding_mode=="x1_reset_bonded")) }] {
      set legal_values [intersect $legal_values [list "deskew_delay8"]]
   } else {
      set legal_values [exclude $legal_values [list "deskew_delay0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_clk_divtx_deskew.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_clk_divtx_deskew $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_clk_divtx_deskew $pma_tx_ser_clk_divtx_deskew $legal_values { pma_tx_ser_bonding_mode pma_tx_ser_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_control_clk_divtx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_control_clk_divtx pma_tx_ser_prot_mode pma_tx_ser_sup_mode } {

   set legal_values [list "dft_control_clkdivtx_high" "dft_control_clkdivtx_low" "no_dft_control_clkdivtx"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "no_dft_control_clkdivtx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_control_clk_divtx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_control_clk_divtx $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_control_clk_divtx $pma_tx_ser_control_clk_divtx $legal_values { pma_tx_ser_prot_mode pma_tx_ser_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode pma_tx_buf_duty_cycle_correction_mode_ctrl } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_initial_settings $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_initial_settings $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_buf_duty_cycle_correction_mode_ctrl $pma_tx_ser_initial_settings $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_buf_duty_cycle_correction_mode_ctrl $pma_tx_ser_initial_settings $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_initial_settings $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_buf_duty_cycle_correction_mode_ctrl $pma_tx_ser_initial_settings $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_initial_settings $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_initial_settings $pma_tx_ser_prot_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_initial_settings { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_initial_settings pma_tx_buf_xtx_path_initial_settings } {

   set legal_values [list "false" "true"]

   if [expr { ($pma_tx_buf_xtx_path_initial_settings=="false") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_initial_settings=="true") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_initial_settings.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_initial_settings $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_initial_settings $pma_tx_ser_initial_settings $legal_values { pma_tx_buf_xtx_path_initial_settings }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_prot_mode pma_tx_buf_xtx_path_prot_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sata_tx" "unused"]

   if [expr { ($pma_tx_buf_xtx_path_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   } else {
      if [expr { ($pma_tx_buf_xtx_path_prot_mode=="basic_tx") }] {
         set legal_values [intersect $legal_values [list "basic_tx"]]
      } else {
         if [expr { ($pma_tx_buf_xtx_path_prot_mode=="pcie_gen1_tx") }] {
            set legal_values [intersect $legal_values [list "pcie_gen1_tx"]]
         } else {
            if [expr { ($pma_tx_buf_xtx_path_prot_mode=="pcie_gen2_tx") }] {
               set legal_values [intersect $legal_values [list "pcie_gen2_tx"]]
            } else {
               if [expr { ($pma_tx_buf_xtx_path_prot_mode=="pcie_gen3_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_gen3_tx"]]
               } else {
                  if [expr { ($pma_tx_buf_xtx_path_prot_mode=="pcie_gen4_tx") }] {
                     set legal_values [intersect $legal_values [list "pcie_gen4_tx"]]
                  } else {
                     if [expr { ($pma_tx_buf_xtx_path_prot_mode=="qpi_tx") }] {
                        set legal_values [intersect $legal_values [list "qpi_tx"]]
                     } else {
                        if [expr { ($pma_tx_buf_xtx_path_prot_mode=="gpon_tx") }] {
                           set legal_values [intersect $legal_values [list "gpon_tx"]]
                        } else {
                           if [expr { ($pma_tx_buf_xtx_path_prot_mode=="sata_tx") }] {
                              set legal_values [intersect $legal_values [list "sata_tx"]]
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_prot_mode $pma_tx_ser_prot_mode $legal_values { pma_tx_buf_xtx_path_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_pma_tx_ser_ser_clk_divtx_user_sel  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_buf_xtx_path_datarate $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_pma_tx_ser_ser_clk_divtx_user_sel  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_buf_xtx_path_datarate $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_pma_tx_ser_ser_clk_divtx_user_sel  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_pma_tx_ser_ser_clk_divtx_user_sel  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_pma_tx_ser_ser_clk_divtx_user_sel  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_buf_xtx_path_datarate $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_pma_tx_ser_ser_clk_divtx_user_sel  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_pma_tx_ser_ser_clk_divtx_user_sel  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_buf_xtx_path_datarate $pma_tx_ser_prot_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_pma_tx_ser_ser_clk_divtx_user_sel  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_buf_xtx_path_datarate $pma_tx_ser_prot_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_ser_clk_mon { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_mon pma_tx_ser_prot_mode pma_tx_ser_sup_mode } {

   set legal_values [list "disable_clk_mon" "enable_clk_mon_0101" "enable_clk_mon_1010"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "disable_clk_mon"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_mon.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_mon $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_mon $pma_tx_ser_ser_clk_mon $legal_values { pma_tx_ser_prot_mode pma_tx_ser_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_ser_powerdown { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_powerdown pma_cgb_ser_powerdown pma_tx_ser_prot_mode } {

   set legal_values [list "normal_poweron_ser" "powerdown_ser"]

   if [expr { ($pma_cgb_ser_powerdown=="powerdown_ser") }] {
      set legal_values [intersect $legal_values [list "powerdown_ser"]]
   }
   if [expr { ($pma_cgb_ser_powerdown=="normal_poweron_ser") }] {
      set legal_values [intersect $legal_values [list "normal_poweron_ser"]]
   }
   if [expr { ($pma_tx_ser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "powerdown_ser"]]
   } else {
      set legal_values [intersect $legal_values [list "normal_poweron_ser"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_powerdown.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_powerdown $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_powerdown $pma_tx_ser_ser_powerdown $legal_values { pma_cgb_ser_powerdown pma_tx_ser_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_tx_ser_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_sup_mode pma_tx_buf_xtx_path_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($pma_tx_buf_xtx_path_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_sup_mode $pma_tx_ser_sup_mode $legal_values { pma_tx_buf_xtx_path_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::20nm1_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode } {

   set legal_values [list "dcc_0000011111" "dcc_1111100000" "dcc_continuous" "dcc_disable"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_duty_cycle_correction_mode_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values { pma_tx_ser_initial_settings pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode } {
   regsub -nocase -all {\D} $pma_tx_buf_xtx_path_datarate "" pma_tx_buf_xtx_path_datarate

   set legal_values [list "divtx_user_1" "divtx_user_2" "divtx_user_33" "divtx_user_40" "divtx_user_66" "divtx_user_off"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_buf_xtx_path_datarate<5000000000)) }] {
      set legal_values [intersect $legal_values [list "divtx_user_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_divtx_user_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_ser_clk_divtx_user_sel $legal_values { pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode } {

   set legal_values [list "dcc_0000011111" "dcc_1111100000" "dcc_continuous" "dcc_disable"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_duty_cycle_correction_mode_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values { pma_tx_ser_initial_settings pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode } {
   regsub -nocase -all {\D} $pma_tx_buf_xtx_path_datarate "" pma_tx_buf_xtx_path_datarate

   set legal_values [list "divtx_user_1" "divtx_user_2" "divtx_user_33" "divtx_user_40" "divtx_user_66" "divtx_user_off"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_buf_xtx_path_datarate<5000000000)) }] {
      set legal_values [intersect $legal_values [list "divtx_user_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_divtx_user_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_ser_clk_divtx_user_sel $legal_values { pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode } {

   set legal_values [list "dcc_0000011111" "dcc_1111100000" "dcc_continuous" "dcc_disable"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_duty_cycle_correction_mode_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values { pma_tx_ser_initial_settings pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode } {
   regsub -nocase -all {\D} $pma_tx_buf_xtx_path_datarate "" pma_tx_buf_xtx_path_datarate

   set legal_values [list "divtx_user_1" "divtx_user_2" "divtx_user_33" "divtx_user_40" "divtx_user_66" "divtx_user_off"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_buf_xtx_path_datarate<5000000000)) }] {
      set legal_values [intersect $legal_values [list "divtx_user_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_divtx_user_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_ser_clk_divtx_user_sel $legal_values { pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode } {

   set legal_values [list "dcc_0000011111" "dcc_1111100000" "dcc_continuous" "dcc_disable"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_duty_cycle_correction_mode_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values { pma_tx_ser_initial_settings pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode } {
   regsub -nocase -all {\D} $pma_tx_buf_xtx_path_datarate "" pma_tx_buf_xtx_path_datarate

   set legal_values [list "divtx_user_1" "divtx_user_2" "divtx_user_33" "divtx_user_40" "divtx_user_66" "divtx_user_off"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_buf_xtx_path_datarate<5000000000)) }] {
      set legal_values [intersect $legal_values [list "divtx_user_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_divtx_user_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_ser_clk_divtx_user_sel $legal_values { pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_buf_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode } {

   set legal_values [list "dcc_0000011111" "dcc_1111100000" "dcc_continuous" "dcc_disable"]

   if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_disable") }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   } else {
      if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_0000011111") }] {
         set legal_values [intersect $legal_values [list "dcc_0000011111"]]
      } else {
         if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_1111100000") }] {
            set legal_values [intersect $legal_values [list "dcc_1111100000"]]
         } else {
            if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_continuous") }] {
               set legal_values [intersect $legal_values [list "dcc_continuous"]]
            }
         }
      }
   }
   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_duty_cycle_correction_mode_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values { pma_tx_buf_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_ser_prot_mode } {

   set legal_values [list "divtx_user_1" "divtx_user_2" "divtx_user_33" "divtx_user_40" "divtx_user_66" "divtx_user_off"]

   if [expr { ($pma_tx_ser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "divtx_user_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_divtx_user_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_ser_clk_divtx_user_sel $legal_values { pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode } {

   set legal_values [list "dcc_0000011111" "dcc_1111100000" "dcc_continuous" "dcc_disable"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_duty_cycle_correction_mode_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values { pma_tx_ser_initial_settings pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode } {
   regsub -nocase -all {\D} $pma_tx_buf_xtx_path_datarate "" pma_tx_buf_xtx_path_datarate

   set legal_values [list "divtx_user_1" "divtx_user_2" "divtx_user_33" "divtx_user_40" "divtx_user_66" "divtx_user_off"]

   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_buf_xtx_path_datarate<5000000000)) }] {
      set legal_values [intersect $legal_values [list "divtx_user_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_divtx_user_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_ser_clk_divtx_user_sel $legal_values { pma_tx_buf_xtx_path_datarate pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_buf_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode } {

   set legal_values [list "dcc_0000011111" "dcc_1111100000" "dcc_continuous" "dcc_disable"]

   if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_disable") }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   } else {
      if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_0000011111") }] {
         set legal_values [intersect $legal_values [list "dcc_0000011111"]]
      } else {
         if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_1111100000") }] {
            set legal_values [intersect $legal_values [list "dcc_1111100000"]]
         } else {
            if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_continuous") }] {
               set legal_values [intersect $legal_values [list "dcc_continuous"]]
            }
         }
      }
   }
   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_duty_cycle_correction_mode_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values { pma_tx_buf_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_ser_prot_mode } {

   set legal_values [list "divtx_user_1" "divtx_user_2" "divtx_user_33" "divtx_user_40" "divtx_user_66" "divtx_user_off"]

   if [expr { ($pma_tx_ser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "divtx_user_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_divtx_user_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_ser_clk_divtx_user_sel $legal_values { pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_pma_tx_ser_duty_cycle_correction_mode_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_duty_cycle_correction_mode_ctrl pma_tx_buf_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode } {

   set legal_values [list "dcc_0000011111" "dcc_1111100000" "dcc_continuous" "dcc_disable"]

   if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_disable") }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   } else {
      if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_0000011111") }] {
         set legal_values [intersect $legal_values [list "dcc_0000011111"]]
      } else {
         if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_1111100000") }] {
            set legal_values [intersect $legal_values [list "dcc_1111100000"]]
         } else {
            if [expr { ($pma_tx_buf_duty_cycle_correction_mode_ctrl=="dcc_continuous") }] {
               set legal_values [intersect $legal_values [list "dcc_continuous"]]
            }
         }
      }
   }
   if [expr { (($pma_tx_ser_prot_mode=="unused")||($pma_tx_ser_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "dcc_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_duty_cycle_correction_mode_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_duty_cycle_correction_mode_ctrl $pma_tx_ser_duty_cycle_correction_mode_ctrl $legal_values { pma_tx_buf_duty_cycle_correction_mode_ctrl pma_tx_ser_initial_settings pma_tx_ser_prot_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_pma_tx_ser_ser_clk_divtx_user_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_tx_ser_ser_clk_divtx_user_sel pma_tx_ser_prot_mode } {

   set legal_values [list "divtx_user_1" "divtx_user_2" "divtx_user_33" "divtx_user_40" "divtx_user_66" "divtx_user_off"]

   if [expr { ($pma_tx_ser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "divtx_user_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_tx_ser_ser_clk_divtx_user_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_tx_ser_ser_clk_divtx_user_sel $pma_tx_ser_ser_clk_divtx_user_sel $legal_values { pma_tx_ser_prot_mode }
   }
}


