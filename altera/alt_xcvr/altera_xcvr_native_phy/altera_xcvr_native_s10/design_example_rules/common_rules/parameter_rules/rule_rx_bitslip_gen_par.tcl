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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_rx_bitslip_gen_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rx_bitslip_gen_par:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rx_bitslip_gen_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  # MetaData for rx_bitslip
  # Specified the prefix for multi-channel implementations
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(rx_bitslip_gen_ref.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(rx_bitslip_gen_ref.split_suffix)"   ENABLED   0 

  set bitslip_parameters {\
    { NAME                                           VALUE                                                                                                                                                ENABLED   }\
    { rx_bitslip_gen_ref.DATA_WIDTH                "## MAPS_FROM rx_native_phy_ref.rx_checker_data_width MAP_DEFAULT NOVAL"                                                                               1         }\
    { rx_bitslip_gen_ref.CHANNELS                  "## MAPS_FROM rx_native_phy_ref.channels MAP_DEFAULT NOVAL"                                                                                            1         }\
    { rx_bitslip_gen_ref.gui_split_interfaces      "## MAPS_FROM rx_native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"                                                                              1         }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${bitslip_parameters}

  set bitslip_connections {\
    { NAME                                                                              ENABLED                                                                         EXPAND_CALLBACK                                                                                                                                        }\
    { "rx_native_phy_ref.rx_parallel_data/rx_bitslip_gen_ref.rx_parallel_data"          "## EXPRESSION \"( (rx_native_phy_ref.rx_checker_data_width <= 64 ) && !(rx_native_phy_ref.std_rx_8b10b_enable))\""        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix  }\
    { "bus_concat_ref.data_out1/rx_bitslip_gen_ref.rx_parallel_data"                    "## EXPRESSION \"( (rx_native_phy_ref.rx_checker_data_width > 64 ) || rx_native_phy_ref.std_rx_8b10b_enable)\""         ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix  }\
    { "rx_bitslip_gen_ref.rx_bitslip/rx_native_phy_ref.rx_bitslip"                      "## EXPRESSION \"(!(rx_native_phy_ref.enable_port_rx_std_wa_patternalign) )\""  ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix  }\
    { "rx_bitslip_gen_ref.rx_bitslip/rx_native_phy_ref.rx_std_wa_patternalign"          "## EXPRESSION \"( (rx_native_phy_ref.enable_port_rx_std_wa_patternalign) )\""  ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix  }\
    { "protocol_tester_ref.ext_data_pattern/rx_bitslip_gen_ref.ext_data_pattern"        1                                                                               ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_check_reset/rx_bitslip_gen_ref.reset"                   1                                                                               ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${bitslip_connections}  

  set rx_clock_connections [list \
    [list NAME                                                                          SPLIT_CONNECTION   ADAPT_CONNECTION  ENABLED                                                           EXPAND_CALLBACK                                                                                                                                       ]\
    [list "rx_native_phy_ref.rx_clkout/rx_bitslip_gen_ref.clk"                          0                  0                 "## EXPRESSION \"  (!(rx_native_phy_ref.use_rx_clkout2 ) ) \""    ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ]\
    [list "rx_native_phy_ref.rx_clkout2/rx_bitslip_gen_ref.clk"                         0                  0                 "## EXPRESSION \"  ( (rx_native_phy_ref.use_rx_clkout2 ) ) \""    ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ]\
  ]
  ::alt_xcvr::de_tcl::de_api::de_declareConnections ${rx_clock_connections}

}
