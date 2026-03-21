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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par 18.1

package require alt_xcvr::de_tcl::de_api

namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par:: {
  namespace export declare_rule  

  variable CONST_TX_PCS_FREQ_LOW_LIMIT
  variable CONST_TX_PCS_FREQ_HIGH_LIMIT
  variable CONST_RX_PCS_FREQ_LOW_LIMIT
  variable CONST_RX_PCS_FREQ_HIGH_LIMIT

  set CONST_TX_PCS_FREQ_LOW_LIMIT       0.95
  set CONST_TX_PCS_FREQ_HIGH_LIMIT      1.05
  set CONST_RX_PCS_FREQ_LOW_LIMIT       0.94
  set CONST_RX_PCS_FREQ_HIGH_LIMIT      1.06
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  #split_suffix is not a core protocol_tester parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(protocol_tester_ref.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(protocol_tester_ref.split_suffix)"   ENABLED   0

  set parameters {\
    { NAME                                           VALUE                                                                                                                                          ENABLED }\
    { protocol_tester_ref.DATA_WIDTH                "## MAPS_FROM native_phy_ref.tx_generator_data_width MAP_DEFAULT NOVAL"                                                                         1       }\
    { protocol_tester_ref.CHANNELS                  "## MAPS_FROM native_phy_ref.channels MAP_DEFAULT NOVAL"                                                                                        1       }\
    { protocol_tester_ref.gui_split_interfaces      "## MAPS_FROM native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"                                                                          1       }\
    { protocol_tester_ref.UNUSED_TX_DATA_WIDTH      "## MAPS_FROM native_phy_ref.unused_tx_parallel_data_width MAP_DEFAULT NOVAL"                                                                   "## EXPRESSION \"(native_phy_ref.enable_simple_interface)\""       }\
    { protocol_tester_ref.UNUSED_RX_DATA_WIDTH      "## MAPS_FROM native_phy_ref.unused_rx_parallel_data_width MAP_DEFAULT NOVAL"                                                                   "## EXPRESSION \"(native_phy_ref.enable_simple_interface)\""       }\
      \
    { protocol_tester_ref.EXPECTED_TX_LO_FREQ       "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::resolveLowTxClkoutFrequency"     1       }\
    { protocol_tester_ref.EXPECTED_TX_HI_FREQ       "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::resolveHighTxClkoutFrequency"    1       }\
    { protocol_tester_ref.EXPECTED_RX_LO_FREQ       "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::resolveLowRxClkoutFrequency"     1       }\
    { protocol_tester_ref.EXPECTED_RX_HI_FREQ       "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::resolveHighRxClkoutFrequency"    1       }\
      \
    { protocol_tester_ref.BYTE_SERIALIZE_X2_EN      "## MAPS_FROM native_phy_ref.std_tx_byte_ser_mode MAPPING {(Serialize x2:1)} MAP_DEFAULT 0"                                                     "## EXPRESSION \"(native_phy_ref.datapath_select==Standard)\""     }\
    { protocol_tester_ref.EN_8B10B                  "## EXPRESSION \"(tx_native_phy_ref.std_tx_8b10b_enable || rx_native_phy_ref.std_rx_8b10b_enable)\""                                            "## EXPRESSION \"(native_phy_ref.datapath_select==Standard)\""     }\
    { protocol_tester_ref.EXT_DATA_PATTERN_EN       "## EXPRESSION \"(tx_native_phy_ref.enable_port_tx_enh_bitslip || tx_native_phy_ref.std_tx_bitslip_enable)\""                                   "## EXPRESSION \"(native_phy_ref.datapath_select==Standard)\""     }\
    { protocol_tester_ref.TX_ENH_BITSLIP_EN         "## EXPRESSION \"(tx_native_phy_ref.enable_port_tx_enh_bitslip)\""                                                                              "## EXPRESSION \"(native_phy_ref.datapath_select==Standard)\""     }\
    { protocol_tester_ref.TX_STD_BITSLIP_EN         "## EXPRESSION \"(tx_native_phy_ref.std_tx_bitslip_enable)\""                                                                                   "## EXPRESSION \"(native_phy_ref.datapath_select==Standard)\""     }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${parameters}
  
}

###################
# \TODO assumption mgmt_clk 100Mhz and COUNT in freq checker set to 100 --> make those meta data
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getClkFrequency { data_rate pma_width clkout_sel datapath byte_ser_int user_div fifo_transfer_mode tx_mode} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT 
  ###################  
  #\EXCEPTION
  #\TODO until finding out if Native phy will disable this option to the following:  
  if { ${clkout_sel}=="pma_div_clkout" && ${user_div} == 0} {
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "Can't generate a design example for div 0!" ERROR 
    return [expr {${data_rate}/(${pma_width}*${div})}]
  }
  ###################
  if {${clkout_sel}=="pcs_clkout"} {
    set div   [expr { (${datapath} == "Standard") ? ${byte_ser_int} : 1 }]
  } elseif {${clkout_sel}=="pcs_x2_clkout"} {
    set div   [expr { (${datapath} == "Standard") ? ${byte_ser_int} : 1 }]
    if { (${fifo_transfer_mode} == "x2") || (${fifo_transfer_mode} == "x1x2") } {
      if {!(((${datapath} == "Standard" && ${byte_ser_int} ==1) || ${datapath} == "PCS Direct") && ${pma_width} == 20 && ${tx_mode}==1)} {
        set div   [expr {${div}/2.}]
      }
    }
  } else {
    set div ${user_div}
  }

  if { ${clkout_sel} != "pma_div_clkout" } {
  return [expr {${data_rate}/(${pma_width}*${div})}]
  } else {
    if { ${clkout_sel}=="pma_div_clkout" && $user_div == 1} {
  return [expr {${data_rate}/(${pma_width}*${div})}]
    } elseif { ${clkout_sel}=="pma_div_clkout" && $user_div == 2} {
      return [expr {${data_rate}/(${pma_width}*${div})}]
    } else {
      return [expr {${data_rate}/(${div}*2)}]
}

  }
}
###################
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getTxClkFrequency { clkout_sel } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT        
  set data_rate           [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.set_data_rate)"  VALUE]
  set pma_width           [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.l_pcs_pma_width)" VALUE]
  set datapath            [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.datapath_select)" VALUE]
  set byte_ser_string     [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.std_tx_byte_ser_mode)" VALUE]
  set byte_ser_int        [expr { (${byte_ser_string} == "Serialize x4") ? 4 : (${byte_ser_string} == "Serialize x2") ? 2 : 1 }]  
  set user_div            [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.tx_pma_div_clkout_divider)"  VALUE ]
  set fifo_transfer_mode  [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.l_tx_fifo_transfer_mode)"  VALUE ]
  return [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getClkFrequency ${data_rate} ${pma_width} ${clkout_sel} ${datapath} ${byte_ser_int} ${user_div} ${fifo_transfer_mode} 1]
}
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getRxClkFrequency { clkout_sel } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT        
  set data_rate           [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.set_data_rate)"  VALUE]
  set pma_width           [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.l_pcs_pma_width)" VALUE]
  set datapath            [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.datapath_select)" VALUE]
  set byte_ser_string     [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.std_rx_byte_deser_mode)" VALUE]
  set byte_ser_int        [expr { (${byte_ser_string} == "Deserialize x4") ? 4 : (${byte_ser_string} == "Deserialize x2") ? 2 : 1 }]  
  set user_div            [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.rx_pma_div_clkout_divider)"  VALUE ]
  set fifo_transfer_mode  [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.l_rx_fifo_transfer_mode)"  VALUE ]
  return [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getClkFrequency ${data_rate} ${pma_width} ${clkout_sel} ${datapath} ${byte_ser_int} ${user_div} ${fifo_transfer_mode} 0]
}
###################
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getTxClkoutFrequency {} {
  set clkout_sel          [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.tx_clkout_sel)" VALUE]
  return [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getTxClkFrequency ${clkout_sel}]
}
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getRxClkoutFrequency {} {
  set clkout_sel          [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.rx_clkout_sel)" VALUE]
  return [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getRxClkFrequency ${clkout_sel}]
}
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getTxClkout2Frequency {} {
  set clkout_sel          [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.tx_clkout2_sel)" VALUE]
  return [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getTxClkFrequency ${clkout_sel}]
}
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getRxClkout2Frequency {} {
  set clkout_sel          [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.rx_clkout2_sel)" VALUE]
  return [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getRxClkFrequency ${clkout_sel}]
}
###################
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::resolveLowTxClkoutFrequency {} {
  variable CONST_TX_PCS_FREQ_LOW_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getTxClkoutFrequency]
  return [expr {int(double(${base_freq})*${CONST_TX_PCS_FREQ_LOW_LIMIT})}]
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::resolveHighTxClkoutFrequency {} {
  variable CONST_TX_PCS_FREQ_HIGH_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getTxClkoutFrequency]
  return [expr {int(double(${base_freq})*${CONST_TX_PCS_FREQ_HIGH_LIMIT})}]
}
###################
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::resolveLowRxClkoutFrequency {} {
  variable CONST_RX_PCS_FREQ_LOW_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getRxClkoutFrequency]
  return [expr {int(double(${base_freq})*${CONST_RX_PCS_FREQ_LOW_LIMIT})}]
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::resolveHighRxClkoutFrequency {} {
  variable CONST_RX_PCS_FREQ_HIGH_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par::getRxClkoutFrequency]
  return [expr {int(double(${base_freq})*${CONST_RX_PCS_FREQ_HIGH_LIMIT})}]
}
