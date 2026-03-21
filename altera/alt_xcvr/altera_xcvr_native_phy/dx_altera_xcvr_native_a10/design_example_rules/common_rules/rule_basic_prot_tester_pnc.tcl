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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc 18.1

package require alt_xcvr::de_tcl::de_api
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks


namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc:: {
  namespace export declare_rule  

  variable CONST_TX_PCS_FREQ_LOW_LIMIT
  variable CONST_TX_PCS_FREQ_HIGH_LIMIT
  variable CONST_RX_PCS_FREQ_LOW_LIMIT
  variable CONST_RX_PCS_FREQ_HIGH_LIMIT
  variable CONST_TX_DIV_PMA_FREQ_LOW_LIMIT
  variable CONST_TX_DIV_PMA_FREQ_HIGH_LIMIT
  variable CONST_RX_DIV_PMA_FREQ_LOW_LIMIT
  variable CONST_RX_DIV_PMA_FREQ_HIGH_LIMIT

  set CONST_TX_PCS_FREQ_LOW_LIMIT       0.95
  set CONST_TX_PCS_FREQ_HIGH_LIMIT      1.05
  set CONST_RX_PCS_FREQ_LOW_LIMIT       0.94
  set CONST_RX_PCS_FREQ_HIGH_LIMIT      1.06
  set CONST_TX_DIV_PMA_FREQ_LOW_LIMIT   0.93
  set CONST_TX_DIV_PMA_FREQ_HIGH_LIMIT  1.07
  set CONST_RX_DIV_PMA_FREQ_LOW_LIMIT   0.92
  set CONST_RX_DIV_PMA_FREQ_HIGH_LIMIT  1.08
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  #split_suffix is not a core protocol_tester parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(protocol_tester_ref.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(protocol_tester_ref.split_suffix)"   ENABLED   0

  set parameters {\
    { NAME                                           VALUE                                                                                                                                            ENABLED }\
    { protocol_tester_ref.CHANNELS                  "## MAPS_FROM native_phy_ref.channels MAP_DEFAULT NOVAL"                                                                                          1       }\
    { protocol_tester_ref.gui_split_interfaces      "## MAPS_FROM native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"                                                                            1       }\
    { protocol_tester_ref.UNUSED_TX_DATA_WIDTH      "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveUnusedDataWidth"         1       }\
    { protocol_tester_ref.UNUSED_RX_DATA_WIDTH      "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveUnusedDataWidth"         1       }\
      \
    { protocol_tester_ref.EXPECTED_TX_LO_FREQ       "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveLowTxPcsFrequency"       1       }\
    { protocol_tester_ref.EXPECTED_TX_HI_FREQ       "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveHighTxPcsFrequency"      1       }\
    { protocol_tester_ref.EXPECTED_RX_LO_FREQ       "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveLowRxPcsFrequency"       1       }\
    { protocol_tester_ref.EXPECTED_RX_HI_FREQ       "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveHighRxPcsFrequency"      1       }\
      \
    { protocol_tester_ref.EXPECTED_TX_DIV_LO_FREQ   "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveLowTxDivPmaFrequency"    1       }\
    { protocol_tester_ref.EXPECTED_TX_DIV_HI_FREQ   "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveHighTxDivPmaFrequency"   1       }\
    { protocol_tester_ref.EXPECTED_RX_DIV_LO_FREQ   "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveLowRxDivPmaFrequency"    1       }\
    { protocol_tester_ref.EXPECTED_RX_DIV_HI_FREQ   "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveHighRxDivPmaFrequency"   1       }\
  } 

  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${parameters}

  
  #\TODO need to be related to simplified interfaces enabled --> ENABLED
  set connections {\
    { NAME                                                                                       ENABLED   EXPAND_CALLBACK           }\
    { "protocol_tester_ref.unused_tx_parallel_data/tx_native_phy_ref.unused_tx_parallel_data"    1         "NOVAL"                   }\
    { "rx_native_phy_ref.unused_rx_parallel_data/protocol_tester_ref.unused_rx_parallel_data"    1         "NOVAL"                   }\
    { "tx_native_phy_ref.tx_enh_data_valid/protocol_tester_ref.tx_enh_data_valid"                1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
      \
    { "rx_native_phy_ref.rx_is_lockedtodata/protocol_tester_ref.rx_is_lockedtodata"              "## EXPRESSION \"(rx_native_phy_ref.enable_port_rx_is_lockedtodata)\""   ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "rx_native_phy_ref.rx_is_lockedtoref/protocol_tester_ref.rx_is_lockedtoref"                "## EXPRESSION \"(rx_native_phy_ref.enable_port_rx_is_lockedtoref)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.rx_set_locktodata/rx_native_phy_ref.rx_set_locktodata"                "## EXPRESSION \"(rx_native_phy_ref.enable_ports_rx_manual_cdr_mode)\""  ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.rx_set_locktoref/rx_native_phy_ref.rx_set_locktoref"                  "## EXPRESSION \"(rx_native_phy_ref.enable_ports_rx_manual_cdr_mode)\""  ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
      \
    { "data_checker_ref.is_data_locked/protocol_tester_ref.verifier_lock"                       1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "data_checker_ref.error_flag/protocol_tester_ref.verifier_error"                          1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
      \
    { "tx_reset_controller_ref.tx_ready/protocol_tester_ref.tx_ready"                                    1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "rx_reset_controller_ref.rx_ready/protocol_tester_ref.rx_ready"                                    1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
      \
    { "protocol_tester_ref.prbs_gen_start/data_generator_ref.enable"                            1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_check_start/data_checker_ref.enable"                            1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_gen_insert_error/data_generator_ref.insert_error"               1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_gen_reset/data_generator_ref.reset"                             1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_check_reset/data_checker_ref.reset"                             1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${connections}
}

###################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveUnusedDataWidth {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set data_width   [::alt_xcvr::de_tcl::de_api::de_getData "parameter(native_phy_ref.enh_pld_pcs_width)"  VALUE ]
  set num_channels [::alt_xcvr::de_tcl::de_api::de_getData "parameter(native_phy_ref.channels)"  VALUE ]
  return [expr {(128-$data_width)*$num_channels}];
}
###################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::hzToMhz {freq} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  return [expr {int((double(${freq}))/1000000)}]  
}
###################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveTxPcsFrequency {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  # \TODO assumption mgmt_clk 100Mhz and COUNT in freq checker set to 100 --> make those meta data
  set freq   [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.pma_tx_buf_xtx_path_pma_tx_divclk_hz)"  VALUE ]
  return [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::hzToMhz $freq]  
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveLowTxPcsFrequency {} {
  variable CONST_TX_PCS_FREQ_LOW_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveTxPcsFrequency]
  return [expr {int(double(${base_freq})*${CONST_TX_PCS_FREQ_LOW_LIMIT})}]
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveHighTxPcsFrequency {} {
  variable CONST_TX_PCS_FREQ_HIGH_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveTxPcsFrequency]
  return [expr {int(double(${base_freq})*${CONST_TX_PCS_FREQ_HIGH_LIMIT})}]
}
######################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveRxPcsFrequency {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  # \TODO assumption mgmt_clk 100Mhz and COUNT in freq checker set to 100 --> make those meta data
  set freq   [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.pma_rx_buf_xrx_path_pma_rx_divclk_hz)"  VALUE ]
  return [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::hzToMhz $freq]
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveLowRxPcsFrequency {} {
  variable CONST_RX_PCS_FREQ_LOW_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveRxPcsFrequency]
  return [expr {int(double(${base_freq})*${CONST_RX_PCS_FREQ_LOW_LIMIT})}]
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveHighRxPcsFrequency {} {
  variable CONST_RX_PCS_FREQ_HIGH_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveRxPcsFrequency]
  return [expr {int(double(${base_freq})*${CONST_RX_PCS_FREQ_HIGH_LIMIT})}]
}
###################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveTxDivPmaFrequency {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  # \TODO assumption mgmt_clk 100Mhz and COUNT in freq checker set to 100 --> make those meta data
  # \TODO if div 0 --> should the checker in protocol tester be disabled
  set div    [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.tx_pma_div_clkout_divider)"  VALUE ]
  set div    [ expr { $div ? $div : 1 } ]
  set freq   [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.pma_tx_buf_xtx_path_pma_tx_divclk_hz)"  VALUE ]
  return [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::hzToMhz [expr {int((double(${freq}))/(double($div)))}]] 
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveLowTxDivPmaFrequency {} {
  variable CONST_TX_DIV_PMA_FREQ_LOW_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveTxDivPmaFrequency]
  return [expr {int(double(${base_freq})*${CONST_TX_DIV_PMA_FREQ_LOW_LIMIT})}]
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveHighTxDivPmaFrequency {} {
  variable CONST_TX_DIV_PMA_FREQ_HIGH_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveTxDivPmaFrequency]
  return [expr {int(double(${base_freq})*${CONST_TX_DIV_PMA_FREQ_HIGH_LIMIT})}]
}
######################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveRxDivPmaFrequency {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  # \TODO assumption mgmt_clk 100Mhz and COUNT in freq checker set to 100 --> make those meta data
  # \TODO if div 0 --> should the checker in protocol tester be disabled
  set div    [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.rx_pma_div_clkout_divider)"  VALUE ]
  set div    [ expr { $div ? $div : 1 } ]
  set freq   [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.pma_rx_buf_xrx_path_pma_rx_divclk_hz)"  VALUE ]
  return [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::hzToMhz [expr {int((double(${freq}))/(double($div)))}]]  
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveLowRxDivPmaFrequency {} {
  variable CONST_RX_DIV_PMA_FREQ_LOW_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveRxDivPmaFrequency]
  return [expr {int(double(${base_freq})*${CONST_RX_DIV_PMA_FREQ_LOW_LIMIT})}]
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveHighRxDivPmaFrequency {} {
  variable CONST_RX_DIV_PMA_FREQ_HIGH_LIMIT
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set base_freq [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc::resolveRxDivPmaFrequency]
  return [expr {int(double(${base_freq})*${CONST_RX_DIV_PMA_FREQ_HIGH_LIMIT})}]
}
