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


proc ::nf_xcvr_native::parameters::getValue_pma_cgb_bitslip_enable { device_revision pma_cgb_bonding_reset_enable pma_cgb_prot_mode pma_cgb_xn_clock_source_sel } {

   set legal_values [list "disable_bitslip" "enable_bitslip"]

   if [expr { (((((((((((($pma_cgb_prot_mode=="unused")||($pma_cgb_prot_mode=="pcie_gen1_tx"))||($pma_cgb_prot_mode=="pcie_gen2_tx"))||($pma_cgb_prot_mode=="pcie_gen3_tx"))||($pma_cgb_prot_mode=="pcie_gen4_tx"))||($pma_cgb_prot_mode=="sata_tx"))||($pma_cgb_prot_mode=="qpi_tx"))||($pma_cgb_bonding_reset_enable=="allow_bonding_reset"))||($pma_cgb_xn_clock_source_sel=="sel_xn_up"))||($pma_cgb_xn_clock_source_sel=="sel_xn_dn"))||($pma_cgb_xn_clock_source_sel=="sel_x6_top"))||($pma_cgb_xn_clock_source_sel=="sel_x6_bot")) }] {
      set legal_values [intersect $legal_values [list "disable_bitslip"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_bonding_mode { device_revision pma_tx_buf_xtx_path_bonding_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_bonding_reset_enable { device_revision pma_cgb_bonding_mode } {

   set legal_values [list "allow_bonding_reset" "disallow_bonding_reset"]

   if [expr { ($pma_cgb_bonding_mode=="x1_reset_bonded") }] {
      set legal_values [intersect $legal_values [list "allow_bonding_reset"]]
   } else {
      set legal_values [intersect $legal_values [list "disallow_bonding_reset"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_cgb_power_down { device_revision pma_cgb_prot_mode } {

   set legal_values [list "normal_cgb" "power_down_cgb"]

   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "power_down_cgb"]]
   } else {
      set legal_values [intersect $legal_values [list "normal_cgb"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_datarate { device_revision pma_tx_buf_xtx_path_datarate } {
   regsub -nocase -all {\D} $pma_cgb_datarate "" pma_cgb_datarate
   regsub -nocase -all {\D} $pma_tx_buf_xtx_path_datarate "" pma_tx_buf_xtx_path_datarate

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values $pma_tx_buf_xtx_path_datarate]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_dprio_cgb_vreg_boost { device_revision pma_tx_buf_power_mode pma_tx_buf_xtx_path_optimal pma_tx_buf_xtx_path_prot_mode } {

   set legal_values [list "boost_1_step" "boost_2_step" "boost_3_step" "boost_4_step" "boost_5_step" "boost_6_step" "boost_7_step" "no_voltage_boost"]

   if [expr { ($pma_tx_buf_xtx_path_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_voltage_boost"]]
   } else {
      if [expr { (($pma_tx_buf_power_mode=="low_power")||($pma_tx_buf_power_mode=="mid_power")) }] {
         if [expr { ($pma_tx_buf_xtx_path_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "no_voltage_boost"]]
         } else {
            set legal_values [intersect $legal_values [list "boost_5_step" "no_voltage_boost"]]
         }
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "no_voltage_boost"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_initial_settings { device_revision pma_tx_buf_xtx_path_initial_settings } {

   set legal_values [list "false" "true"]

   if [expr { ($pma_tx_buf_xtx_path_initial_settings=="false") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_initial_settings=="true") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_observe_cgb_clocks { device_revision pma_cgb_prot_mode pma_cgb_sup_mode } {

   set legal_values [list "observe_cpulseout_bus" "observe_nothing" "observe_x1mux_out"]

   if [expr { (($pma_cgb_prot_mode=="unused")||($pma_cgb_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "observe_nothing"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_pcie_gen3_bitwidth { device_revision pma_rx_buf_pm_tx_rx_pcie_gen_bitwidth } {

   set legal_values [list "pciegen3_narrow" "pciegen3_wide"]

   set legal_values [intersect $legal_values [list "pciegen3_wide"]]
   if [expr { ($pma_rx_buf_pm_tx_rx_pcie_gen_bitwidth=="pcie_gen3_32b") }] {
      set legal_values [intersect $legal_values [list "pciegen3_wide"]]
   } else {
      if [expr { ($pma_rx_buf_pm_tx_rx_pcie_gen_bitwidth=="pcie_gen3_16b") }] {
         set legal_values [intersect $legal_values [list "pciegen3_narrow"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_prot_mode { device_revision pma_tx_buf_xtx_path_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_scratch0_x1_clock_src { device_revision pma_cgb_prot_mode } {

   set legal_values [list "scratch0_cdr_txpll_b" "scratch0_cdr_txpll_t" "scratch0_fpll_bot" "scratch0_fpll_top" "scratch0_hfclk_x6_dn" "scratch0_hfclk_x6_up" "scratch0_hfclk_xn_dn" "scratch0_hfclk_xn_up" "scratch0_lcpll_bot" "scratch0_lcpll_hs" "scratch0_lcpll_top" "scratch0_same_ch_txpll" "scratch0_unused"]

   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "scratch0_unused"]]
   }

   set legal_values [convert_b2a_pma_cgb_scratch0_x1_clock_src $legal_values]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_scratch1_x1_clock_src { device_revision pma_cgb_prot_mode } {

   set legal_values [list "scratch1_cdr_txpll_b" "scratch1_cdr_txpll_t" "scratch1_fpll_bot" "scratch1_fpll_top" "scratch1_hfclk_x6_dn" "scratch1_hfclk_x6_up" "scratch1_hfclk_xn_dn" "scratch1_hfclk_xn_up" "scratch1_lcpll_bot" "scratch1_lcpll_hs" "scratch1_lcpll_top" "scratch1_same_ch_txpll" "scratch1_unused"]

   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "scratch1_unused"]]
   }

   set legal_values [convert_b2a_pma_cgb_scratch1_x1_clock_src $legal_values]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_scratch2_x1_clock_src { device_revision pma_cgb_prot_mode } {

   set legal_values [list "scratch2_cdr_txpll_b" "scratch2_cdr_txpll_t" "scratch2_fpll_bot" "scratch2_fpll_top" "scratch2_hfclk_x6_dn" "scratch2_hfclk_x6_up" "scratch2_hfclk_xn_dn" "scratch2_hfclk_xn_up" "scratch2_lcpll_bot" "scratch2_lcpll_hs" "scratch2_lcpll_top" "scratch2_same_ch_txpll" "scratch2_unused"]

   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "scratch2_unused"]]
   }

   set legal_values [convert_b2a_pma_cgb_scratch2_x1_clock_src $legal_values]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_scratch3_x1_clock_src { device_revision pma_cgb_prot_mode } {

   set legal_values [list "scratch3_cdr_txpll_b" "scratch3_cdr_txpll_t" "scratch3_fpll_bot" "scratch3_fpll_top" "scratch3_hfclk_x6_dn" "scratch3_hfclk_x6_up" "scratch3_hfclk_xn_dn" "scratch3_hfclk_xn_up" "scratch3_lcpll_bot" "scratch3_lcpll_hs" "scratch3_lcpll_top" "scratch3_same_ch_txpll" "scratch3_unused"]

   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "scratch3_unused"]]
   }

   set legal_values [convert_b2a_pma_cgb_scratch3_x1_clock_src $legal_values]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_select_done_master_or_slave { device_revision pma_cgb_prot_mode pma_cgb_x1_clock_source_sel pma_cgb_xn_clock_source_sel } {

   set legal_values [list "choose_master_pcie_sw_done" "choose_slave_pcie_sw_done"]

   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "choose_slave_pcie_sw_done"]]
   } else {
      if [expr { ((((($pma_cgb_xn_clock_source_sel=="sel_xn_up")||($pma_cgb_xn_clock_source_sel=="sel_xn_dn"))||($pma_cgb_xn_clock_source_sel=="sel_x6_top"))||($pma_cgb_xn_clock_source_sel=="sel_x6_bot"))&&($pma_cgb_x1_clock_source_sel!="xn_non_bonding")) }] {
         set legal_values [intersect $legal_values [list "choose_master_pcie_sw_done"]]
      } else {
         set legal_values [intersect $legal_values [list "choose_slave_pcie_sw_done"]]
      }
   }
   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "choose_slave_pcie_sw_done"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_ser_mode { device_revision pma_cgb_prot_mode pma_tx_buf_xtx_path_datawidth } {

   set legal_values [list "eight_bit" "forty_bit" "sixteen_bit" "sixty_four_bit" "ten_bit" "thirty_two_bit" "twenty_bit"]

   if [expr { ($pma_tx_buf_xtx_path_datawidth==8) }] {
      set legal_values [intersect $legal_values [list "eight_bit"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_datawidth==10) }] {
      set legal_values [intersect $legal_values [list "ten_bit"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_datawidth==16) }] {
      set legal_values [intersect $legal_values [list "sixteen_bit"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_datawidth==20) }] {
      set legal_values [intersect $legal_values [list "twenty_bit"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_datawidth==32) }] {
      set legal_values [intersect $legal_values [list "thirty_two_bit"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_datawidth==40) }] {
      set legal_values [intersect $legal_values [list "forty_bit"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_datawidth==64) }] {
      set legal_values [intersect $legal_values [list "sixty_four_bit"]]
   }
   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eight_bit"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_ser_powerdown { device_revision pma_cgb_prot_mode } {

   set legal_values [list "normal_poweron_ser" "powerdown_ser"]

   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "powerdown_ser"]]
   } else {
      set legal_values [intersect $legal_values [list "normal_poweron_ser"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_sup_mode { device_revision pma_tx_buf_xtx_path_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($pma_tx_buf_xtx_path_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_tx_ucontrol_en { device_revision pma_cgb_initial_settings pma_cgb_prot_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_cgb_prot_mode=="unused")||($pma_cgb_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_tx_ucontrol_pcie { device_revision pma_cgb_initial_settings pma_cgb_tx_ucontrol_en pma_rx_buf_xrx_path_uc_pcie_sw } {

   set legal_values [list "gen1" "gen2" "gen3" "gen4"]

   if [expr { (($pma_cgb_tx_ucontrol_en=="disable")||($pma_cgb_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "gen1"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_uc_pcie_sw=="uc_pcie_gen1") }] {
      set legal_values [intersect $legal_values [list "gen1"]]
   } else {
      if [expr { ($pma_rx_buf_xrx_path_uc_pcie_sw=="uc_pcie_gen2") }] {
         set legal_values [intersect $legal_values [list "gen2"]]
      } else {
         if [expr { ($pma_rx_buf_xrx_path_uc_pcie_sw=="uc_pcie_gen3") }] {
            set legal_values [intersect $legal_values [list "gen3"]]
         } else {
            if [expr { ($pma_rx_buf_xrx_path_uc_pcie_sw=="not_allowed") }] {
               set legal_values [intersect $legal_values [list "gen4"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_tx_ucontrol_reset { device_revision pma_cgb_initial_settings pma_cgb_tx_ucontrol_en } {

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_cgb_tx_ucontrol_en=="disable")||($pma_cgb_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_vccdreg_output { device_revision pma_cgb_initial_settings pma_cgb_prot_mode } {

   set legal_values [list "vccdreg_neg_setting1" "vccdreg_neg_setting2" "vccdreg_neg_setting3" "vccdreg_neg_setting4" "vccdreg_nominal" "vccdreg_pos_setting1" "vccdreg_pos_setting10" "vccdreg_pos_setting11" "vccdreg_pos_setting12" "vccdreg_pos_setting13" "vccdreg_pos_setting14" "vccdreg_pos_setting15" "vccdreg_pos_setting16" "vccdreg_pos_setting17" "vccdreg_pos_setting18" "vccdreg_pos_setting19" "vccdreg_pos_setting2" "vccdreg_pos_setting20" "vccdreg_pos_setting21" "vccdreg_pos_setting22" "vccdreg_pos_setting23" "vccdreg_pos_setting24" "vccdreg_pos_setting25" "vccdreg_pos_setting26" "vccdreg_pos_setting27" "vccdreg_pos_setting3" "vccdreg_pos_setting4" "vccdreg_pos_setting5" "vccdreg_pos_setting6" "vccdreg_pos_setting7" "vccdreg_pos_setting8" "vccdreg_pos_setting9"]

   if [expr { (($pma_cgb_prot_mode=="unused")||($pma_cgb_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "vccdreg_nominal"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_x1_clock_source_sel { device_revision cdr_pll_pcie_gen pma_cgb_bonding_mode pma_cgb_prot_mode pma_cgb_sup_mode pma_tx_buf_xtx_path_gt_enabled } {

   set legal_values [list "cdr_txpll_b" "cdr_txpll_t" "fpll_bot" "fpll_bot_g1_g2" "fpll_bot_g2_lcpll_bot_g3" "fpll_bot_g2_lcpll_top_g3" "fpll_top" "fpll_top_g1_g2" "fpll_top_g2_lcpll_bot_g3" "fpll_top_g2_lcpll_top_g3" "lcpll_bot" "lcpll_bot_g1_g2" "lcpll_hs" "lcpll_top" "lcpll_top_g1_g2" "same_ch_txpll" "xn_non_bonding"]

   if [expr { ($pma_tx_buf_xtx_path_gt_enabled=="enable") }] {
      set legal_values [intersect $legal_values [list "lcpll_hs"]]
   }
   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcpll_top"]]
   } else {
      if [expr { ($pma_cgb_prot_mode=="pcie_gen1_tx") }] {
         if [expr { ($pma_cgb_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "lcpll_bot_g1_g2" "lcpll_top_g1_g2" "fpll_bot_g1_g2" "fpll_top_g1_g2"]]
         } else {
            if [expr { ($pma_cgb_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "lcpll_bot_g1_g2" "lcpll_top_g1_g2" "fpll_bot_g1_g2" "fpll_top_g1_g2"]]
            }
         }
      } else {
         if [expr { ($pma_cgb_prot_mode=="pcie_gen2_tx") }] {
            set legal_values [intersect $legal_values [list "lcpll_bot_g1_g2" "lcpll_top_g1_g2" "fpll_bot_g1_g2" "fpll_top_g1_g2"]]
         } else {
            if [expr { (($pma_cgb_prot_mode=="pcie_gen3_tx")||($pma_cgb_prot_mode=="pcie_gen4_tx")) }] {
               set legal_values [intersect $legal_values [list "fpll_bot_g2_lcpll_bot_g3" "fpll_bot_g2_lcpll_top_g3" "fpll_top_g2_lcpll_bot_g3" "fpll_top_g2_lcpll_top_g3"]]
            } else {
               if [expr { ($pma_cgb_bonding_mode=="x1_non_bonded") }] {
                  set legal_values [intersect $legal_values [list "lcpll_hs" "lcpll_top" "lcpll_bot" "fpll_top" "fpll_bot" "cdr_txpll_b" "cdr_txpll_t" "same_ch_txpll"]]
               } else {
                  if [expr { ($pma_cgb_bonding_mode=="x1_reset_bonded") }] {
                     set legal_values [intersect $legal_values [list "lcpll_hs" "lcpll_top" "lcpll_bot" "fpll_top" "fpll_bot" "cdr_txpll_b" "cdr_txpll_t" "same_ch_txpll"]]
                  } else {
                     if [expr { ($pma_cgb_bonding_mode=="x6_xn_bonded") }] {
                        set legal_values [intersect $legal_values [list "lcpll_top"]]
                     } else {
                        if [expr { ($pma_cgb_bonding_mode=="xn_non_bonded") }] {
                           set legal_values [intersect $legal_values [list "xn_non_bonding"]]
                        }
                     }
                  }
               }
            }
         }
      }
   }
   if [expr { ($cdr_pll_pcie_gen=="non_pcie") }] {
      set legal_values [intersect $legal_values [list "lcpll_bot" "lcpll_top" "fpll_bot" "fpll_top" "cdr_txpll_b" "cdr_txpll_t" "same_ch_txpll" "lcpll_hs" "xn_non_bonding"]]
   }
   if [expr { (((((($cdr_pll_pcie_gen=="pcie_gen2_100mhzref")||($cdr_pll_pcie_gen=="pcie_gen3_100mhzref"))||($cdr_pll_pcie_gen=="pcie_gen2_125mhzref"))||($cdr_pll_pcie_gen=="pcie_gen1_125mhzref"))||($cdr_pll_pcie_gen=="pcie_gen1_100mhzref"))||($cdr_pll_pcie_gen=="pcie_gen3_125mhzref")) }] {
      set legal_values [intersect $legal_values [list "lcpll_bot_g1_g2" "lcpll_top_g1_g2" "fpll_bot_g1_g2" "fpll_top_g1_g2" "fpll_bot_g2_lcpll_bot_g3" "fpll_bot_g2_lcpll_top_g3" "fpll_top_g2_lcpll_bot_g3" "fpll_top_g2_lcpll_top_g3"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_x1_div_m_sel { device_revision pma_cgb_prot_mode pma_cgb_x1_clock_source_sel pma_tx_buf_xtx_path_clock_divider_ratio } {

   set legal_values [list "divby2" "divby4" "divby8" "divbypass"]

   if [expr { ($pma_tx_buf_xtx_path_clock_divider_ratio==1) }] {
      set legal_values [intersect $legal_values [list "divbypass"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_clock_divider_ratio==2) }] {
      set legal_values [intersect $legal_values [list "divby2"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_clock_divider_ratio==4) }] {
      set legal_values [intersect $legal_values [list "divby4"]]
   }
   if [expr { ($pma_tx_buf_xtx_path_clock_divider_ratio==8) }] {
      set legal_values [intersect $legal_values [list "divby8"]]
   }
   if [expr { (((((($pma_cgb_prot_mode=="unused")||($pma_cgb_prot_mode=="pcie_gen1_tx"))||($pma_cgb_prot_mode=="pcie_gen2_tx"))||($pma_cgb_prot_mode=="pcie_gen3_tx"))||($pma_cgb_prot_mode=="pcie_gen4_tx"))||($pma_cgb_x1_clock_source_sel=="lcpll_hs")) }] {
      set legal_values [intersect $legal_values [list "divbypass"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_cgb_xn_clock_source_sel { device_revision pma_cgb_bonding_mode pma_cgb_prot_mode } {

   set legal_values [list "sel_cgb_loc" "sel_x6_bot" "sel_x6_top" "sel_xn_dn" "sel_xn_up"]

   if [expr { ($pma_cgb_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "sel_cgb_loc"]]
   } else {
      if [expr { (($pma_cgb_bonding_mode=="x6_xn_bonded")||($pma_cgb_bonding_mode=="xn_non_bonded")) }] {
         set legal_values [intersect $legal_values [list "sel_xn_up" "sel_xn_dn" "sel_x6_top" "sel_x6_bot"]]
      } else {
         set legal_values [intersect $legal_values [list "sel_cgb_loc"]]
      }
   }

   return $legal_values
}

