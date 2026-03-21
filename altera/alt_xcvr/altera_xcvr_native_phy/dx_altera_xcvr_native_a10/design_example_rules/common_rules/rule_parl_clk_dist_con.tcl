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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_parl_clk_dist_con 18.1

package require alt_xcvr::de_tcl::de_api
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks

namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_parl_clk_dist_con:: {
  namespace export declare_rule  
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_parl_clk_dist_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

# \TODO: aasumption no simplex design example allowed otherwise some changes has to be done here
   set clock_distribution {\
    { NAME                                                                         SPLIT_CONNECTION   ADAPT_CONNECTION  ENABLED                                                                EXPAND_CALLBACK            }\
    { "native_phy_ref.tx_clkout/data_generator_ref.clk"                            0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != rx) && !(native_phy_ref.enable_port_tx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "native_phy_ref.tx_clkout/protocol_tester_ref.prbs_data_gen_clk"             0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != rx) && !(native_phy_ref.enable_port_tx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "native_phy_ref.tx_clkout/native_phy_ref.tx_coreclkin"                       0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != rx) && !(native_phy_ref.enable_port_tx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      \
    { "native_phy_ref.tx_pma_div_clkout/data_generator_ref.clk"                    0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != rx) &&  (native_phy_ref.enable_port_tx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "native_phy_ref.tx_pma_div_clkout/protocol_tester_ref.prbs_data_gen_clk"     0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != rx) &&  (native_phy_ref.enable_port_tx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "native_phy_ref.tx_pma_div_clkout/native_phy_ref.tx_coreclkin"               0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != rx) &&  (native_phy_ref.enable_port_tx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    \
    { "native_phy_ref.rx_clkout/data_checker_ref.clk"                              0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != tx) && !(native_phy_ref.enable_port_rx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "native_phy_ref.rx_clkout/protocol_tester_ref.prbs_data_check_clk"           0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != tx) && !(native_phy_ref.enable_port_rx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "native_phy_ref.rx_clkout/native_phy_ref.tx_coreclkin"                       0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != tx) && !(native_phy_ref.enable_port_rx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      \
    { "native_phy_ref.rx_pma_div_clkout/data_checker_ref.clk"                      0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != tx) &&  (native_phy_ref.enable_port_rx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "native_phy_ref.rx_pma_div_clkout/protocol_tester_ref.prbs_data_check_clk"   0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != tx) &&  (native_phy_ref.enable_port_rx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "native_phy_ref.rx_pma_div_clkout/native_phy_ref.rx_coreclkin"               0                  0                 "## EXPRESSION \"(native_phy_ref.duplex_mode != tx) &&  (native_phy_ref.enable_port_rx_pma_div_clkout)\""    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${clock_distribution}
}
