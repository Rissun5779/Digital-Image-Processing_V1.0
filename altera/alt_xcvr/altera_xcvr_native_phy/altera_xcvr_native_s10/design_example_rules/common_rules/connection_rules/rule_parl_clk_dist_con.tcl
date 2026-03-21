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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks

namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con:: {
  namespace export declare_rule  
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set mid_tx_index [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.pcs_bonding_master)"  VALUE ];
  set is_tx_bonded [expr {[::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.bonded_mode)"  VALUE ] != "not_bonded"}]
  set mid_tx_index [expr {${is_tx_bonded} ? "_ch${mid_tx_index}" : ""}];

  set tx_clock_distribution [list \
   [list  NAME                                                                                    SPLIT_CONNECTION   ADAPT_CONNECTION  ENABLED                                                                                                        EXPAND_CALLBACK            ]\
   [list  "tx_native_phy_ref.tx_clkout${mid_tx_index}/data_generator_ref.clk"                     0                  0                 "## EXPRESSION \" !(tx_native_phy_ref.use_tx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion ]\
   [list  "tx_native_phy_ref.tx_clkout${mid_tx_index}/protocol_tester_ref.prbs_data_gen_clk"      0                  0                 "## EXPRESSION \" !(tx_native_phy_ref.use_tx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion ]\
   [list  "tx_native_phy_ref.tx_clkout${mid_tx_index}/x1x2_if_adapter_ref.tx_clkout"              0                  0                 "## EXPRESSION \" (!(tx_native_phy_ref.use_tx_clkout2) && tx_native_phy_ref.enable_double_rate_transfer)\""    ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion ]\
   [list  "tx_native_phy_ref.tx_clkout${mid_tx_index}/tx_native_phy_ref.tx_coreclkin"             0                  0                 "## EXPRESSION \" !(tx_native_phy_ref.use_tx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion ]\
      \
   [list  "tx_native_phy_ref.tx_clkout2${mid_tx_index}/data_generator_ref.clk"                    0                  0                 "## EXPRESSION \"  (tx_native_phy_ref.use_tx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion ]\
   [list  "tx_native_phy_ref.tx_clkout2${mid_tx_index}/protocol_tester_ref.prbs_data_gen_clk"     0                  0                 "## EXPRESSION \"  (tx_native_phy_ref.use_tx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion ]\
   [list  "tx_native_phy_ref.tx_clkout2${mid_tx_index}/x1x2_if_adapter_ref.tx_clkout"             0                  0                 "## EXPRESSION \"  (tx_native_phy_ref.use_tx_clkout2 && tx_native_phy_ref.enable_double_rate_transfer)\""      ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion ]\
   [list  "tx_native_phy_ref.tx_clkout2${mid_tx_index}/tx_native_phy_ref.tx_coreclkin"            0                  0                 "## EXPRESSION \"  (tx_native_phy_ref.use_tx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion ]\
  ]
  
  set rx_clock_distribution [list \
    [list NAME                                                                                    SPLIT_CONNECTION   ADAPT_CONNECTION  ENABLED                                                                                                        EXPAND_CALLBACK                                                                                                                                       ]\
    [list "rx_native_phy_ref.rx_clkout/data_checker_ref.clk"                                      0                  0                 "## EXPRESSION \" !(rx_native_phy_ref.use_rx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ]\
    [list "rx_native_phy_ref.rx_clkout/protocol_tester_ref.prbs_data_check_clk"                   0                  0                 "## EXPRESSION \" !(rx_native_phy_ref.use_rx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ]\
    [list "rx_native_phy_ref.rx_clkout/rx_native_phy_ref.rx_coreclkin"                            0                  0                 "## EXPRESSION \" !(rx_native_phy_ref.use_rx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ]\
      \
    [list "rx_native_phy_ref.rx_clkout2/data_checker_ref.clk"                                     0                  0                 "## EXPRESSION \"  (rx_native_phy_ref.use_rx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ]\
    [list "rx_native_phy_ref.rx_clkout2/protocol_tester_ref.prbs_data_check_clk"                  0                  0                 "## EXPRESSION \"  (rx_native_phy_ref.use_rx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ]\
    [list "rx_native_phy_ref.rx_clkout2/rx_native_phy_ref.rx_coreclkin"                           0                  0                 "## EXPRESSION \"  (rx_native_phy_ref.use_rx_clkout2)\""                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ]\
  ]
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${tx_clock_distribution}
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${rx_clock_distribution}
}


###################
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::bondedOrNonBondedExpansion {connection_name isBonded} {
  if {!${isBonded}} {
    ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix ${connection_name}
  } else {
    ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_NoSourceSuffix_UseTargetSuffix  ${connection_name}
  }
}
###################
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::txBondedOrNonBondedExpansion {connection_name} {
  set is_bonded [expr {[::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.bonded_mode)"  VALUE ] != "not_bonded"}]
  ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::bondedOrNonBondedExpansion ${connection_name} ${is_bonded}
}
###################
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::rxBondedOrNonBondedExpansion {connection_name} {
  set is_bonded [expr {[::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.bonded_mode)"  VALUE ] != "not_bonded"}]
  ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con::bondedOrNonBondedExpansion ${connection_name} ${is_bonded}
}
###################
