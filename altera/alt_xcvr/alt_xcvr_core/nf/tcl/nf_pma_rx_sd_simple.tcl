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


proc ::nf_xcvr_native::parameters::getValue_pma_rx_sd_power_mode { device_revision pma_rx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
      set legal_values [intersect $legal_values [list "high_perf"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
            set legal_values [intersect $legal_values [list "low_power"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_sd_prot_mode { device_revision pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "basic_rx" "gpon_rx" "pcie_gen1_rx" "pcie_gen2_rx" "pcie_gen3_rx" "pcie_gen4_rx" "qpi_rx" "sata_rx" "unused"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="basic_rx") }] {
      set legal_values [intersect $legal_values [list "basic_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="pcie_gen1_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_gen1_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="pcie_gen2_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_gen2_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="pcie_gen3_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_gen3_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="pcie_gen4_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_gen4_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "qpi_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="gpon_rx") }] {
      set legal_values [intersect $legal_values [list "gpon_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="sata_rx") }] {
      set legal_values [intersect $legal_values [list "sata_rx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_sd_sd_output_off  $device_revision $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_sd_sd_output_off  $device_revision $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_sd_sd_output_off  $device_revision $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_sd_sd_output_off  $device_revision $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_sd_sd_output_off  $device_revision $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_sd_sd_output_off  $device_revision $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_sd_sd_output_off  $device_revision $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_sd_sd_output_off  $device_revision $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_sd_sd_output_on { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "data_pulse_10" "data_pulse_12" "data_pulse_14" "data_pulse_16" "data_pulse_18" "data_pulse_20" "data_pulse_22" "data_pulse_24" "data_pulse_26" "data_pulse_28" "data_pulse_30" "data_pulse_4" "data_pulse_6" "data_pulse_8" "force_sd_output_on" "reserved_sd_output_on1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "data_pulse_6"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "data_pulse_6"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "force_sd_output_on"]]
      }
   }

   set legal_values [convert_b2a_pma_rx_sd_sd_output_on $legal_values]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_sd_sd_pdb { device_revision pma_rx_sd_prot_mode } {

   set legal_values [list "sd_off" "sd_on"]

   if [expr { ((((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx"))||($pma_rx_sd_prot_mode=="sata_rx")) }] {
      set legal_values [intersect $legal_values [list "sd_on"]]
   } else {
      set legal_values [intersect $legal_values [list "sd_off"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_sd_sd_threshold  $device_revision $pma_rx_sd_link $pma_rx_sd_power_mode $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_sd_sd_threshold  $device_revision $pma_rx_sd_link $pma_rx_sd_power_mode $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_sd_sd_threshold  $device_revision $pma_rx_sd_link $pma_rx_sd_power_mode $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_sd_sd_threshold  $device_revision $pma_rx_sd_link $pma_rx_sd_power_mode $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_sd_sd_threshold  $device_revision $pma_rx_sd_link $pma_rx_sd_power_mode $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_sd_sd_threshold  $device_revision $pma_rx_sd_link $pma_rx_sd_power_mode $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_sd_sd_threshold  $device_revision $pma_rx_sd_link $pma_rx_sd_power_mode $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_sd_sd_threshold  $device_revision $pma_rx_sd_link $pma_rx_sd_power_mode $pma_rx_sd_prot_mode $pma_rx_sd_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "clk_divrx_1" "clk_divrx_10" "clk_divrx_11" "clk_divrx_12" "clk_divrx_13" "clk_divrx_14" "clk_divrx_2" "clk_divrx_3" "clk_divrx_4" "clk_divrx_5" "clk_divrx_6" "clk_divrx_7" "clk_divrx_8" "clk_divrx_9" "force_sd_output_off_when_remote_tx_off_10clkdivrx" "force_sd_output_off_when_remote_tx_off_11clkdivrx" "force_sd_output_off_when_remote_tx_off_12clkdivrx" "force_sd_output_off_when_remote_tx_off_13clkdivrx" "force_sd_output_off_when_remote_tx_off_14clkdivrx" "force_sd_output_off_when_remote_tx_off_1clkdivrx" "force_sd_output_off_when_remote_tx_off_2clkdivrx" "force_sd_output_off_when_remote_tx_off_3clkdivrx" "force_sd_output_off_when_remote_tx_off_4clkdivrx" "force_sd_output_off_when_remote_tx_off_5clkdivrx" "force_sd_output_off_when_remote_tx_off_6clkdivrx" "force_sd_output_off_when_remote_tx_off_7clkdivrx" "force_sd_output_off_when_remote_tx_off_8clkdivrx" "force_sd_output_off_when_remote_tx_off_9clkdivrx" "reserved_sd_output_off1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "clk_divrx_14"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "clk_divrx_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   }

   set legal_values [20nm1_convert_b2a_pma_rx_sd_sd_output_off $legal_values]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "sdlv_0" "sdlv_1" "sdlv_10" "sdlv_11" "sdlv_12" "sdlv_13" "sdlv_14" "sdlv_15" "sdlv_2" "sdlv_3" "sdlv_4" "sdlv_5" "sdlv_6" "sdlv_7" "sdlv_8" "sdlv_9"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "sdlv_4"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               if [expr { ($pma_rx_sd_link=="sr") }] {
                  set legal_values [intersect $legal_values [list "sdlv_5"]]
               } else {
                  if [expr { ($pma_rx_sd_link=="lr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  if [expr { ($pma_rx_sd_link=="sr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  } else {
                     if [expr { ($pma_rx_sd_link=="lr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
                  if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                     if [expr { ($pma_rx_sd_link=="sr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     } else {
                        if [expr { ($pma_rx_sd_link=="lr") }] {
                           set legal_values [intersect $legal_values [list "sdlv_5"]]
                        }
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "sdlv_3"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "clk_divrx_1" "clk_divrx_10" "clk_divrx_11" "clk_divrx_12" "clk_divrx_13" "clk_divrx_14" "clk_divrx_2" "clk_divrx_3" "clk_divrx_4" "clk_divrx_5" "clk_divrx_6" "clk_divrx_7" "clk_divrx_8" "clk_divrx_9" "force_sd_output_off_when_remote_tx_off_10clkdivrx" "force_sd_output_off_when_remote_tx_off_11clkdivrx" "force_sd_output_off_when_remote_tx_off_12clkdivrx" "force_sd_output_off_when_remote_tx_off_13clkdivrx" "force_sd_output_off_when_remote_tx_off_14clkdivrx" "force_sd_output_off_when_remote_tx_off_1clkdivrx" "force_sd_output_off_when_remote_tx_off_2clkdivrx" "force_sd_output_off_when_remote_tx_off_3clkdivrx" "force_sd_output_off_when_remote_tx_off_4clkdivrx" "force_sd_output_off_when_remote_tx_off_5clkdivrx" "force_sd_output_off_when_remote_tx_off_6clkdivrx" "force_sd_output_off_when_remote_tx_off_7clkdivrx" "force_sd_output_off_when_remote_tx_off_8clkdivrx" "force_sd_output_off_when_remote_tx_off_9clkdivrx" "reserved_sd_output_off1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "clk_divrx_14"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "clk_divrx_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   }

   set legal_values [20nm2_convert_b2a_pma_rx_sd_sd_output_off $legal_values]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "sdlv_0" "sdlv_1" "sdlv_10" "sdlv_11" "sdlv_12" "sdlv_13" "sdlv_14" "sdlv_15" "sdlv_2" "sdlv_3" "sdlv_4" "sdlv_5" "sdlv_6" "sdlv_7" "sdlv_8" "sdlv_9"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "sdlv_4"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               if [expr { ($pma_rx_sd_link=="sr") }] {
                  set legal_values [intersect $legal_values [list "sdlv_5"]]
               } else {
                  if [expr { ($pma_rx_sd_link=="lr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  if [expr { ($pma_rx_sd_link=="sr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  } else {
                     if [expr { ($pma_rx_sd_link=="lr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
                  if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                     if [expr { ($pma_rx_sd_link=="sr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     } else {
                        if [expr { ($pma_rx_sd_link=="lr") }] {
                           set legal_values [intersect $legal_values [list "sdlv_5"]]
                        }
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "sdlv_3"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "clk_divrx_1" "clk_divrx_10" "clk_divrx_11" "clk_divrx_12" "clk_divrx_13" "clk_divrx_14" "clk_divrx_2" "clk_divrx_3" "clk_divrx_4" "clk_divrx_5" "clk_divrx_6" "clk_divrx_7" "clk_divrx_8" "clk_divrx_9" "force_sd_output_off_when_remote_tx_off_10clkdivrx" "force_sd_output_off_when_remote_tx_off_11clkdivrx" "force_sd_output_off_when_remote_tx_off_12clkdivrx" "force_sd_output_off_when_remote_tx_off_13clkdivrx" "force_sd_output_off_when_remote_tx_off_14clkdivrx" "force_sd_output_off_when_remote_tx_off_1clkdivrx" "force_sd_output_off_when_remote_tx_off_2clkdivrx" "force_sd_output_off_when_remote_tx_off_3clkdivrx" "force_sd_output_off_when_remote_tx_off_4clkdivrx" "force_sd_output_off_when_remote_tx_off_5clkdivrx" "force_sd_output_off_when_remote_tx_off_6clkdivrx" "force_sd_output_off_when_remote_tx_off_7clkdivrx" "force_sd_output_off_when_remote_tx_off_8clkdivrx" "force_sd_output_off_when_remote_tx_off_9clkdivrx" "reserved_sd_output_off1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "clk_divrx_14"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "clk_divrx_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   }

   set legal_values [20nm3_convert_b2a_pma_rx_sd_sd_output_off $legal_values]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "sdlv_0" "sdlv_1" "sdlv_10" "sdlv_11" "sdlv_12" "sdlv_13" "sdlv_14" "sdlv_15" "sdlv_2" "sdlv_3" "sdlv_4" "sdlv_5" "sdlv_6" "sdlv_7" "sdlv_8" "sdlv_9"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "sdlv_4"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               if [expr { ($pma_rx_sd_link=="sr") }] {
                  set legal_values [intersect $legal_values [list "sdlv_5"]]
               } else {
                  if [expr { ($pma_rx_sd_link=="lr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  if [expr { ($pma_rx_sd_link=="sr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  } else {
                     if [expr { ($pma_rx_sd_link=="lr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
                  if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                     if [expr { ($pma_rx_sd_link=="sr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     } else {
                        if [expr { ($pma_rx_sd_link=="lr") }] {
                           set legal_values [intersect $legal_values [list "sdlv_5"]]
                        }
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "sdlv_3"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "clk_divrx_1" "clk_divrx_10" "clk_divrx_11" "clk_divrx_12" "clk_divrx_13" "clk_divrx_14" "clk_divrx_2" "clk_divrx_3" "clk_divrx_4" "clk_divrx_5" "clk_divrx_6" "clk_divrx_7" "clk_divrx_8" "clk_divrx_9" "force_sd_output_off_when_remote_tx_off_10clkdivrx" "force_sd_output_off_when_remote_tx_off_11clkdivrx" "force_sd_output_off_when_remote_tx_off_12clkdivrx" "force_sd_output_off_when_remote_tx_off_13clkdivrx" "force_sd_output_off_when_remote_tx_off_14clkdivrx" "force_sd_output_off_when_remote_tx_off_1clkdivrx" "force_sd_output_off_when_remote_tx_off_2clkdivrx" "force_sd_output_off_when_remote_tx_off_3clkdivrx" "force_sd_output_off_when_remote_tx_off_4clkdivrx" "force_sd_output_off_when_remote_tx_off_5clkdivrx" "force_sd_output_off_when_remote_tx_off_6clkdivrx" "force_sd_output_off_when_remote_tx_off_7clkdivrx" "force_sd_output_off_when_remote_tx_off_8clkdivrx" "force_sd_output_off_when_remote_tx_off_9clkdivrx" "reserved_sd_output_off1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "clk_divrx_14"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "clk_divrx_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   }

   set legal_values [20nm4_convert_b2a_pma_rx_sd_sd_output_off $legal_values]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "sdlv_0" "sdlv_1" "sdlv_10" "sdlv_11" "sdlv_12" "sdlv_13" "sdlv_14" "sdlv_15" "sdlv_2" "sdlv_3" "sdlv_4" "sdlv_5" "sdlv_6" "sdlv_7" "sdlv_8" "sdlv_9"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "sdlv_4"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               if [expr { ($pma_rx_sd_link=="sr") }] {
                  set legal_values [intersect $legal_values [list "sdlv_5"]]
               } else {
                  if [expr { ($pma_rx_sd_link=="lr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  if [expr { ($pma_rx_sd_link=="sr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  } else {
                     if [expr { ($pma_rx_sd_link=="lr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
                  if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                     if [expr { ($pma_rx_sd_link=="sr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     } else {
                        if [expr { ($pma_rx_sd_link=="lr") }] {
                           set legal_values [intersect $legal_values [list "sdlv_5"]]
                        }
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "sdlv_3"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "clk_divrx_1" "clk_divrx_10" "clk_divrx_11" "clk_divrx_12" "clk_divrx_13" "clk_divrx_14" "clk_divrx_2" "clk_divrx_3" "clk_divrx_4" "clk_divrx_5" "clk_divrx_6" "clk_divrx_7" "clk_divrx_8" "clk_divrx_9" "force_sd_output_off_when_remote_tx_off_10clkdivrx" "force_sd_output_off_when_remote_tx_off_11clkdivrx" "force_sd_output_off_when_remote_tx_off_12clkdivrx" "force_sd_output_off_when_remote_tx_off_13clkdivrx" "force_sd_output_off_when_remote_tx_off_14clkdivrx" "force_sd_output_off_when_remote_tx_off_1clkdivrx" "force_sd_output_off_when_remote_tx_off_2clkdivrx" "force_sd_output_off_when_remote_tx_off_3clkdivrx" "force_sd_output_off_when_remote_tx_off_4clkdivrx" "force_sd_output_off_when_remote_tx_off_5clkdivrx" "force_sd_output_off_when_remote_tx_off_6clkdivrx" "force_sd_output_off_when_remote_tx_off_7clkdivrx" "force_sd_output_off_when_remote_tx_off_8clkdivrx" "force_sd_output_off_when_remote_tx_off_9clkdivrx" "reserved_sd_output_off1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "clk_divrx_6"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "clk_divrx_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   }

   set legal_values [20nm4es_convert_b2a_pma_rx_sd_sd_output_off $legal_values]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "sdlv_0" "sdlv_1" "sdlv_10" "sdlv_11" "sdlv_12" "sdlv_13" "sdlv_14" "sdlv_15" "sdlv_2" "sdlv_3" "sdlv_4" "sdlv_5" "sdlv_6" "sdlv_7" "sdlv_8" "sdlv_9"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "sdlv_3"]]
         }
      } else {
         if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               set legal_values [intersect $legal_values [list "sdlv_3"]]
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  set legal_values [intersect $legal_values [list "sdlv_3"]]
               }
            }
         }
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               if [expr { ($pma_rx_sd_link=="sr") }] {
                  set legal_values [intersect $legal_values [list "sdlv_4"]]
               } else {
                  if [expr { ($pma_rx_sd_link=="lr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_6"]]
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  if [expr { ($pma_rx_sd_link=="sr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_4"]]
                  } else {
                     if [expr { ($pma_rx_sd_link=="lr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_6"]]
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
                  if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                     if [expr { ($pma_rx_sd_link=="sr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_4"]]
                     } else {
                        if [expr { ($pma_rx_sd_link=="lr") }] {
                           set legal_values [intersect $legal_values [list "sdlv_6"]]
                        }
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "sdlv_3"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "clk_divrx_1" "clk_divrx_10" "clk_divrx_11" "clk_divrx_12" "clk_divrx_13" "clk_divrx_14" "clk_divrx_2" "clk_divrx_3" "clk_divrx_4" "clk_divrx_5" "clk_divrx_6" "clk_divrx_7" "clk_divrx_8" "clk_divrx_9" "force_sd_output_off_when_remote_tx_off_10clkdivrx" "force_sd_output_off_when_remote_tx_off_11clkdivrx" "force_sd_output_off_when_remote_tx_off_12clkdivrx" "force_sd_output_off_when_remote_tx_off_13clkdivrx" "force_sd_output_off_when_remote_tx_off_14clkdivrx" "force_sd_output_off_when_remote_tx_off_1clkdivrx" "force_sd_output_off_when_remote_tx_off_2clkdivrx" "force_sd_output_off_when_remote_tx_off_3clkdivrx" "force_sd_output_off_when_remote_tx_off_4clkdivrx" "force_sd_output_off_when_remote_tx_off_5clkdivrx" "force_sd_output_off_when_remote_tx_off_6clkdivrx" "force_sd_output_off_when_remote_tx_off_7clkdivrx" "force_sd_output_off_when_remote_tx_off_8clkdivrx" "force_sd_output_off_when_remote_tx_off_9clkdivrx" "reserved_sd_output_off1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "clk_divrx_14"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "clk_divrx_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   }

   set legal_values [20nm5_convert_b2a_pma_rx_sd_sd_output_off $legal_values]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "sdlv_0" "sdlv_1" "sdlv_10" "sdlv_11" "sdlv_12" "sdlv_13" "sdlv_14" "sdlv_15" "sdlv_2" "sdlv_3" "sdlv_4" "sdlv_5" "sdlv_6" "sdlv_7" "sdlv_8" "sdlv_9"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "sdlv_4"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               if [expr { ($pma_rx_sd_link=="sr") }] {
                  set legal_values [intersect $legal_values [list "sdlv_5"]]
               } else {
                  if [expr { ($pma_rx_sd_link=="lr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  if [expr { ($pma_rx_sd_link=="sr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_5"]]
                  } else {
                     if [expr { ($pma_rx_sd_link=="lr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
                  if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                     if [expr { ($pma_rx_sd_link=="sr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_5"]]
                     } else {
                        if [expr { ($pma_rx_sd_link=="lr") }] {
                           set legal_values [intersect $legal_values [list "sdlv_5"]]
                        }
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "sdlv_3"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "clk_divrx_1" "clk_divrx_10" "clk_divrx_11" "clk_divrx_12" "clk_divrx_13" "clk_divrx_14" "clk_divrx_2" "clk_divrx_3" "clk_divrx_4" "clk_divrx_5" "clk_divrx_6" "clk_divrx_7" "clk_divrx_8" "clk_divrx_9" "force_sd_output_off_when_remote_tx_off_10clkdivrx" "force_sd_output_off_when_remote_tx_off_11clkdivrx" "force_sd_output_off_when_remote_tx_off_12clkdivrx" "force_sd_output_off_when_remote_tx_off_13clkdivrx" "force_sd_output_off_when_remote_tx_off_14clkdivrx" "force_sd_output_off_when_remote_tx_off_1clkdivrx" "force_sd_output_off_when_remote_tx_off_2clkdivrx" "force_sd_output_off_when_remote_tx_off_3clkdivrx" "force_sd_output_off_when_remote_tx_off_4clkdivrx" "force_sd_output_off_when_remote_tx_off_5clkdivrx" "force_sd_output_off_when_remote_tx_off_6clkdivrx" "force_sd_output_off_when_remote_tx_off_7clkdivrx" "force_sd_output_off_when_remote_tx_off_8clkdivrx" "force_sd_output_off_when_remote_tx_off_9clkdivrx" "reserved_sd_output_off1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "clk_divrx_6"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "clk_divrx_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   }

   set legal_values [20nm5es2_convert_b2a_pma_rx_sd_sd_output_off $legal_values]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "sdlv_0" "sdlv_1" "sdlv_10" "sdlv_11" "sdlv_12" "sdlv_13" "sdlv_14" "sdlv_15" "sdlv_2" "sdlv_3" "sdlv_4" "sdlv_5" "sdlv_6" "sdlv_7" "sdlv_8" "sdlv_9"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "sdlv_3"]]
         }
      } else {
         if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               set legal_values [intersect $legal_values [list "sdlv_3"]]
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  set legal_values [intersect $legal_values [list "sdlv_3"]]
               }
            }
         }
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               if [expr { ($pma_rx_sd_link=="sr") }] {
                  set legal_values [intersect $legal_values [list "sdlv_4"]]
               } else {
                  if [expr { ($pma_rx_sd_link=="lr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_6"]]
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  if [expr { ($pma_rx_sd_link=="sr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_4"]]
                  } else {
                     if [expr { ($pma_rx_sd_link=="lr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_6"]]
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
                  if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                     if [expr { ($pma_rx_sd_link=="sr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_4"]]
                     } else {
                        if [expr { ($pma_rx_sd_link=="lr") }] {
                           set legal_values [intersect $legal_values [list "sdlv_6"]]
                        }
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "sdlv_3"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_sd_sd_output_off { device_revision pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "clk_divrx_1" "clk_divrx_10" "clk_divrx_11" "clk_divrx_12" "clk_divrx_13" "clk_divrx_14" "clk_divrx_2" "clk_divrx_3" "clk_divrx_4" "clk_divrx_5" "clk_divrx_6" "clk_divrx_7" "clk_divrx_8" "clk_divrx_9" "force_sd_output_off_when_remote_tx_off_10clkdivrx" "force_sd_output_off_when_remote_tx_off_11clkdivrx" "force_sd_output_off_when_remote_tx_off_12clkdivrx" "force_sd_output_off_when_remote_tx_off_13clkdivrx" "force_sd_output_off_when_remote_tx_off_14clkdivrx" "force_sd_output_off_when_remote_tx_off_1clkdivrx" "force_sd_output_off_when_remote_tx_off_2clkdivrx" "force_sd_output_off_when_remote_tx_off_3clkdivrx" "force_sd_output_off_when_remote_tx_off_4clkdivrx" "force_sd_output_off_when_remote_tx_off_5clkdivrx" "force_sd_output_off_when_remote_tx_off_6clkdivrx" "force_sd_output_off_when_remote_tx_off_7clkdivrx" "force_sd_output_off_when_remote_tx_off_8clkdivrx" "force_sd_output_off_when_remote_tx_off_9clkdivrx" "reserved_sd_output_off1"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "clk_divrx_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "clk_divrx_2"]]
      }
   }

   set legal_values [20nm5es_convert_b2a_pma_rx_sd_sd_output_off $legal_values]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_sd_sd_threshold { device_revision pma_rx_sd_link pma_rx_sd_power_mode pma_rx_sd_prot_mode pma_rx_sd_sup_mode } {

   set legal_values [list "sdlv_0" "sdlv_1" "sdlv_10" "sdlv_11" "sdlv_12" "sdlv_13" "sdlv_14" "sdlv_15" "sdlv_2" "sdlv_3" "sdlv_4" "sdlv_5" "sdlv_6" "sdlv_7" "sdlv_8" "sdlv_9"]

   if [expr { (((($pma_rx_sd_prot_mode=="pcie_gen1_rx")||($pma_rx_sd_prot_mode=="pcie_gen2_rx"))||($pma_rx_sd_prot_mode=="pcie_gen3_rx"))||($pma_rx_sd_prot_mode=="pcie_gen4_rx")) }] {
      if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "sdlv_3"]]
         }
      } else {
         if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               set legal_values [intersect $legal_values [list "sdlv_3"]]
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  set legal_values [intersect $legal_values [list "sdlv_3"]]
               }
            }
         }
      }
   } else {
      if [expr { ($pma_rx_sd_prot_mode=="sata_rx") }] {
         if [expr { ($pma_rx_sd_power_mode=="high_perf") }] {
            if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
               if [expr { ($pma_rx_sd_link=="sr") }] {
                  set legal_values [intersect $legal_values [list "sdlv_4"]]
               } else {
                  if [expr { ($pma_rx_sd_link=="lr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_6"]]
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_sd_power_mode=="mid_power") }] {
               if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                  if [expr { ($pma_rx_sd_link=="sr") }] {
                     set legal_values [intersect $legal_values [list "sdlv_4"]]
                  } else {
                     if [expr { ($pma_rx_sd_link=="lr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_6"]]
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_sd_power_mode=="low_power") }] {
                  if [expr { ($pma_rx_sd_sup_mode=="user_mode") }] {
                     if [expr { ($pma_rx_sd_link=="sr") }] {
                        set legal_values [intersect $legal_values [list "sdlv_4"]]
                     } else {
                        if [expr { ($pma_rx_sd_link=="lr") }] {
                           set legal_values [intersect $legal_values [list "sdlv_6"]]
                        }
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "sdlv_3"]]
      }
   }

   return $legal_values
}


