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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_native_and_pll_con 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks

namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_native_and_pll_con:: {
  namespace export declare_rule  
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_native_and_pll_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  # \TODO isari: implement gt connection somewhere else
  set pll_to_native_connections {\
      { NAME                                                              ENABLED                                                                                            SPLIT_CONNECTION   ADAPT_CONNECTION   EXPAND_CALLBACK            }\
      { "pll_ref.tx_serial_clk/tx_native_phy_ref.tx_serial_clk0"          "## EXPRESSION \"  ((tx_native_phy_ref.bonded_mode==not_bonded) && !(pll_ref.enable_hfreq_clk))\"" 0                  0                  ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_NoSourceSuffix_UseTargetSuffix }\
      { "pll_ref.tx_bonding_clocks/tx_native_phy_ref.tx_bonding_clocks"   "## EXPRESSION \" !(tx_native_phy_ref.bonded_mode==not_bonded)\""                                  0                  0                  ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_NoSourceSuffix_UseTargetSuffix }\
      { "pll_ref.mcgb_serial_clk/tx_native_phy_ref.tx_serial_clk0"        "## EXPRESSION \"  (pll_ref.enable_hfreq_clk) \""                                                  0                  0                  ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_NoSourceSuffix_UseTargetSuffix }\
  }

    ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${pll_to_native_connections}
}

