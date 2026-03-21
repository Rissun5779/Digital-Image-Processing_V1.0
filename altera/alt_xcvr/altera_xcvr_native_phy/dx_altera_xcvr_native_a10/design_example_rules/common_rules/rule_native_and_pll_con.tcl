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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con 18.1

package require alt_xcvr::de_tcl::de_api
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks

namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con:: {
  namespace export declare_rule  
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set pll_to_native_connections {\
      { NAME                                                                         ENABLED                                                                                                                                        SPLIT_CONNECTION   ADAPT_CONNECTION   EXPAND_CALLBACK            }\
      { "pll_ref.tx_serial_clk/native_phy_ref.tx_serial_clk0"                        "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con::resolveEnableTxSerialClk"     0                  0                  ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_NoSourceSuffix_UseTargetSuffix }\
      { "pll_ref.tx_serial_clk_gt/native_phy_ref.tx_serial_clk0"                     "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con::resolveEnableTxSerialClkGt"   0                  0                  ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_NoSourceSuffix_UseTargetSuffix }\
  }

  if { [::alt_xcvr::de_tcl::de_api::de_getData "instance(pll_ref)"  ENABLED ] } {
    ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${pll_to_native_connections}
  }
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con::resolveEnableTxSerialClk {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  if { (![::alt_xcvr::de_tcl::de_api::de_getData "parameter(pll_ref.enable_8G_path)"  VALUE ])                     || \
       ( [::alt_xcvr::de_tcl::de_api::de_getData "parameter(native_phy_ref.duplex_mode)"  VALUE ] == "rx")         || \
       ( [::alt_xcvr::de_tcl::de_api::de_getData "parameter(native_phy_ref.bonded_mode)"  VALUE ] != "not_bonded") || \
       ( [::alt_xcvr::de_tcl::de_api::de_getData "parameter(native_phy_ref.plls)"  VALUE ] == 0)  } {
    return 0
  }
  return 1
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con::resolveEnableTxSerialClkGt {  } {
   set value [::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con::resolveEnableTxSerialClk]
   return [expr {$value ? 0 : 1}];#inverse
}
