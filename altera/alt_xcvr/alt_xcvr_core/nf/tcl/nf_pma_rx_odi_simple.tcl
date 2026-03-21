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


proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_clk_dcd_bypass { device_revision pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "bypass" "no_bypass"]

   if [expr { (($pma_rx_odi_prot_mode=="unused")||($pma_rx_odi_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "no_bypass"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_datarate { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_odi_datarate "" pma_rx_odi_datarate
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($cdr_pll_tx_pll_prot_mode=="txpll_unused") }] {
      set legal_values [compare_eq $legal_values $pma_rx_buf_xrx_path_datarate]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_enable_odi { device_revision pma_rx_odi_initial_settings pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "jitter_modulation" "normal_eye_on_dfe" "normal_eye_on_eqin" "power_down_eye"]

   if [expr { (($pma_rx_odi_prot_mode=="unused")||(($pma_rx_odi_sup_mode=="user_mode")&&($pma_rx_odi_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "power_down_eye"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_initial_settings { device_revision pma_rx_buf_xrx_path_initial_settings } {

   set legal_values [list "false" "true"]

   if [expr { ($pma_rx_buf_xrx_path_initial_settings=="true") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_initial_settings=="false") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_invert_dfe_vref { device_revision pma_adapt_odi_spec_sel pma_rx_odi_initial_settings pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "inversion" "no_inversion"]

   if [expr { ($pma_adapt_odi_spec_sel=="rodi_spec_sel_0") }] {
      set legal_values [intersect $legal_values [list "no_inversion"]]
   } else {
      if [expr { ($pma_adapt_odi_spec_sel=="rodi_spec_sel_1") }] {
         set legal_values [intersect $legal_values [list "inversion"]]
      }
   }
   if [expr { (($pma_rx_odi_prot_mode=="unused")||(($pma_rx_odi_sup_mode=="user_mode")&&($pma_rx_odi_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "no_inversion"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_monitor_bw_sel { device_revision pma_rx_odi_datarate pma_rx_odi_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_odi_datarate "" pma_rx_odi_datarate

   set legal_values [list "bw_1" "bw_2" "bw_3" "bw_4"]

   if [expr { ($pma_rx_odi_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "bw_1"]]
   } else {
      if [expr { ($pma_rx_odi_datarate<=6500000000) }] {
         set legal_values [intersect $legal_values [list "bw_1"]]
      } else {
         if [expr { ($pma_rx_odi_datarate<=12500000000) }] {
            set legal_values [intersect $legal_values [list "bw_2"]]
         } else {
            if [expr { ($pma_rx_odi_datarate<=20000000000) }] {
               set legal_values [intersect $legal_values [list "bw_3"]]
            } else {
               set legal_values [intersect $legal_values [list "bw_4"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_oc_sa_c0 { device_revision pma_rx_odi_initial_settings pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_odi_prot_mode=="unused")||(($pma_rx_odi_sup_mode=="user_mode")&&($pma_rx_odi_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_oc_sa_c180 { device_revision pma_rx_odi_initial_settings pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_odi_prot_mode=="unused")||(($pma_rx_odi_sup_mode=="user_mode")&&($pma_rx_odi_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_phase_steps_64_vs_128 { device_revision pma_rx_odi_initial_settings pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "phase_steps_128" "phase_steps_64"]

   if [expr { (($pma_rx_odi_prot_mode=="unused")||(($pma_rx_odi_sup_mode=="user_mode")&&($pma_rx_odi_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "phase_steps_64"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_phase_steps_sel { device_revision pma_rx_odi_initial_settings pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "step1" "step10" "step100" "step101" "step102" "step103" "step104" "step105" "step106" "step107" "step108" "step109" "step11" "step110" "step111" "step112" "step113" "step114" "step115" "step116" "step117" "step118" "step119" "step12" "step120" "step121" "step122" "step123" "step124" "step125" "step126" "step127" "step128" "step13" "step14" "step15" "step16" "step17" "step18" "step19" "step2" "step20" "step21" "step22" "step23" "step24" "step25" "step26" "step27" "step28" "step29" "step3" "step30" "step31" "step32" "step33" "step34" "step35" "step36" "step37" "step38" "step39" "step4" "step40" "step41" "step42" "step43" "step44" "step45" "step46" "step47" "step48" "step49" "step5" "step50" "step51" "step52" "step53" "step54" "step55" "step56" "step57" "step58" "step59" "step6" "step60" "step61" "step62" "step63" "step64" "step65" "step66" "step67" "step68" "step69" "step7" "step70" "step71" "step72" "step73" "step74" "step75" "step76" "step77" "step78" "step79" "step8" "step80" "step81" "step82" "step83" "step84" "step85" "step86" "step87" "step88" "step89" "step9" "step90" "step91" "step92" "step93" "step94" "step95" "step96" "step97" "step98" "step99"]

   if [expr { (($pma_rx_odi_prot_mode=="unused")||(($pma_rx_odi_sup_mode=="user_mode")&&($pma_rx_odi_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "step40"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_power_mode { device_revision pma_rx_buf_power_mode } {

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

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_prot_mode { device_revision pma_rx_buf_xrx_path_prot_mode } {

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

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_sel_oc_en { device_revision pma_rx_dfe_sel_oc_en pma_rx_odi_initial_settings pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "off_canc_disable" "off_canc_enable"]

   if [expr { ($pma_rx_dfe_sel_oc_en=="off_canc_disable") }] {
      set legal_values [intersect $legal_values [list "off_canc_disable"]]
   } else {
      if [expr { ($pma_rx_dfe_sel_oc_en=="off_canc_enable") }] {
         set legal_values [intersect $legal_values [list "off_canc_enable"]]
      }
   }
   if [expr { (($pma_rx_odi_prot_mode=="unused")||(($pma_rx_odi_sup_mode=="user_mode")&&($pma_rx_odi_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "off_canc_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_step_ctrl_sel { device_revision pma_adapt_adapt_mode pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "dprio_mode" "feedback_mode" "jm_mode"]

   if [expr { ($pma_rx_odi_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "dprio_mode"]]
   } else {
      if [expr { ($pma_rx_odi_sup_mode=="user_mode") }] {
         if [expr { ((($pma_adapt_adapt_mode=="ctle")||($pma_adapt_adapt_mode=="ctle_vga"))||($pma_adapt_adapt_mode=="manual")) }] {
            set legal_values [intersect $legal_values [list "dprio_mode"]]
         } else {
            set legal_values [intersect $legal_values [list "feedback_mode"]]
         }
      }
   }
   if [expr { ($pma_rx_odi_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "dprio_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_v_vert_sel { device_revision pma_adapt_odi_vref_sel pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "minus" "plus"]

   if [expr { ($pma_adapt_odi_vref_sel=="rodi_vref_sel_0") }] {
      set legal_values [intersect $legal_values [list "minus"]]
   } else {
      if [expr { ($pma_adapt_odi_vref_sel=="rodi_vref_sel_1") }] {
         set legal_values [intersect $legal_values [list "plus"]]
      }
   }
   if [expr { ($pma_rx_odi_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "minus"]]
   } else {
      if [expr { ($pma_rx_odi_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "minus"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_v_vert_threshold_scaling { device_revision pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "scale_0" "scale_1" "scale_2" "scale_3"]

   if [expr { (($pma_rx_odi_prot_mode=="unused")||($pma_rx_odi_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "scale_3"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_odi_vert_threshold { device_revision pma_rx_odi_initial_settings pma_rx_odi_prot_mode pma_rx_odi_sup_mode } {

   set legal_values [list "vert_0" "vert_1" "vert_10" "vert_11" "vert_12" "vert_13" "vert_14" "vert_15" "vert_16" "vert_17" "vert_18" "vert_19" "vert_2" "vert_20" "vert_21" "vert_22" "vert_23" "vert_24" "vert_25" "vert_26" "vert_27" "vert_28" "vert_29" "vert_3" "vert_30" "vert_31" "vert_32" "vert_33" "vert_34" "vert_35" "vert_36" "vert_37" "vert_38" "vert_39" "vert_4" "vert_40" "vert_41" "vert_42" "vert_43" "vert_44" "vert_45" "vert_46" "vert_47" "vert_48" "vert_49" "vert_5" "vert_50" "vert_51" "vert_52" "vert_53" "vert_54" "vert_55" "vert_56" "vert_57" "vert_58" "vert_59" "vert_6" "vert_60" "vert_61" "vert_62" "vert_63" "vert_7" "vert_8" "vert_9"]

   if [expr { (($pma_rx_odi_prot_mode=="unused")||(($pma_rx_odi_sup_mode=="user_mode")&&($pma_rx_odi_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "vert_0"]]
   }

   return $legal_values
}

