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


# (C) 2001-2016 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any output
# files any of the foregoing (including device programming or simulation
# files), and any associated documentation or information are expressly subject
# to the terms and conditions of the Altera Program License Subscription
# Agreement, Altera MegaCore Function License Agreement, or other applicable
# license agreement, including, without limitation, that your use is for the
# sole purpose of programming logic devices manufactured by Altera and sold by
# Altera or its authorized distributors.  Please refer to the applicable
# agreement for further details.


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par:: {
  namespace export declare_rule
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  #\TODO
  # INSERT_ERROR_EN ?
  # AVMM_EN ?
  # PRBS_SEED ?
  set generator_parameters {\
    { NAME                                      VALUE                                                                                                                               ENABLED }\
    { data_generator_ref.CHANNELS               "## MAPS_FROM tx_native_phy_ref.channels MAP_DEFAULT NOVAL"                                                                         1       }\
    { data_generator_ref.SPLIT_INTERFACE_EN     "## MAPS_FROM tx_native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"                                                           1       }\
    { data_generator_ref.DATA_WIDTH             "## MAPS_FROM tx_native_phy_ref.tx_generator_data_width MAP_DEFAULT NOVAL"                                                          1       }\
    { data_generator_ref.STATIC_PATTERN         "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveTxStaticPattern" 1       }\
    { data_generator_ref.PRBS_SEED_VAL          "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveTxPrbsSeed"      1       }\
    { data_generator_ref.EXTERNAL               "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveTxExternal"      1       }\
    { data_generator_ref.STATIC_PATTERN_EN      1                                                                                                                                   1       }\
  }

  #\TODO
  # OTHER PARAMETERS ?
  set checker_parameters {\
    { NAME                                      VALUE                                                                                                                                   ENABLED }\
    { data_checker_ref.CHANNELS                 "## MAPS_FROM rx_native_phy_ref.channels MAP_DEFAULT NOVAL"                                                                             1       }\
    { data_checker_ref.SPLIT_INTERFACE_EN       "## MAPS_FROM rx_native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"                                                               1       }\
    { data_checker_ref.DATA_WIDTH               "## MAPS_FROM rx_native_phy_ref.rx_checker_data_width MAP_DEFAULT NOVAL"                                                                1       }\
    { data_checker_ref.STATIC_PATTERN           "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveRxStaticPattern"     1       }\
    { data_checker_ref.EXTERNAL                 "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveRxExternal"          1       }\
    { data_checker_ref.STATIC_PATTERN_EN        1                                                                                                                                       1       }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${generator_parameters}
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${checker_parameters}

  #split_suffix is not a core reset_controller parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(data_generator_ref.split_suffix)"   VALUE     "_ch"
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(data_generator_ref.split_suffix)"   ENABLED   0

  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(data_checker_ref.split_suffix)"   VALUE     "_ch"
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(data_checker_ref.split_suffix)"   ENABLED   0
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveTxStaticPattern {} {

  set data_width [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.tx_generator_data_width)" VALUE]
  set enh_bitslip [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.enable_port_tx_enh_bitslip)" VALUE]
  set std_bitslip [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.std_tx_bitslip_enable)" VALUE]

  #These assignments were picked arbitrarily and can be changed if a more appropriate pattern is found - calam
  switch $data_width {
    66 {set static_pattern 6}
    64 {set static_pattern 6}
    40 {set static_pattern 6}
    32 {set static_pattern 5}
    20 {set static_pattern 4}
    16 {set static_pattern 3}
    10 {set static_pattern 2}
    8  {set static_pattern 1}
    default {set static_pattern 1}
  }

  # This accomodates the 10G Enh LL datapath with Bitslip Enabled
  if { $enh_bitslip || $std_bitslip } { set static_pattern 0 }

  return $static_pattern
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveRxStaticPattern {} {

  set data_width [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.rx_checker_data_width)" VALUE]
  set enh_bitslip [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enable_port_rx_enh_bitslip)" VALUE]
  set std_bitslip_port [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enable_port_rx_std_bitslip)" VALUE]
  set std_patternalign_port [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enable_port_rx_std_wa_patternalign)" VALUE]
  set std_wa_mode [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.std_rx_word_aligner_mode)" VALUE]
  
  #These assignments were picked arbitrarily and can be changed if a more appropriate pattern is found - calam
  switch $data_width {
    66 {set static_pattern 6}
    64 {set static_pattern 6}
    40 {set static_pattern 6}
    32 {set static_pattern 5}
    20 {set static_pattern 4}
    16 {set static_pattern 3}
    10 {set static_pattern 2}
    8  {set static_pattern 1}
    default {set static_pattern 1}
  }

  # This accomodates the 10G Enh LL datapath with Bitslip Enabled
  if { $enh_bitslip || ($std_bitslip_port && $std_wa_mode=="bitslip") || ($std_wa_mode=="manual (PLD controlled)" && $std_patternalign_port) || ($std_wa_mode=="synchronous state machine")} { set static_pattern 0 }

  return $static_pattern
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveTxPrbsSeed {} {
  set data_width [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.tx_generator_data_width)" VALUE]

  #These assignments were picked arbitrarily and can be changed if a more appropriate pattern is found - calam
  switch $data_width {
    66 {set prbs_seed "3123456789abcdef"}
    64 {set prbs_seed "123456789abcdef"}
    40 {set prbs_seed "123456789"}
    32 {set prbs_seed "1234567"}
    20 {set prbs_seed "fedcb"}
    16 {set prbs_seed "abcd"}
    10 {set prbs_seed "3AA"}
    8  {set prbs_seed "75"}
    default {set prbs_seed 1}
  }
  return $prbs_seed
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveTxExternal {} {

  set enh_bitslip [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.enable_port_tx_enh_bitslip)" VALUE]
  set std_bitslip [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.std_tx_bitslip_enable)" VALUE]

  # This accomodates the 10G Enh LL datapath with Bitslip Enabled and 8G std datapath with Bitslip enabled
  set external 0
  if { $enh_bitslip || $std_bitslip} { set external 1 }

  return $external

}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par::resolveRxExternal {} {

  set enh_bitslip [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enable_port_rx_enh_bitslip)" VALUE]
  set std_bitslip_port [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enable_port_rx_std_bitslip)" VALUE]
  set std_patternalign_port [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enable_port_rx_std_wa_patternalign)" VALUE]
  set std_wa_mode [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.std_rx_word_aligner_mode)" VALUE]


  # This accomodates the 10G Enh LL datapath with Bitslip Enabled
  set external 0
  if { $enh_bitslip || ($std_bitslip_port && $std_wa_mode=="bitslip") || ($std_wa_mode=="manual (PLD controlled)" && $std_patternalign_port) || ($std_wa_mode=="synchronous state machine")} { set external 1 }

  return $external

}
