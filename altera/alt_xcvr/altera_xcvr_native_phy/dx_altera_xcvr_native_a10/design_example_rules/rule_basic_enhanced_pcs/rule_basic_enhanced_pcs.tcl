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


package provide dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs 18.1

package require alt_xcvr::de_tcl::de_api

package require dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_duplex
package require dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_tx
package require dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_rx

namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs:: {
  namespace export declare_rule  
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
  set subRules {\
    { NAME                               RULE_TYPE                                                                            INSTANCE_PAIRS                     ENABLED }\
    { basic_enhanced_pcs_duplex_rule     ::dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_duplex    {native_phy_ref native_phy_ref}    "## EXPRESSION \"native_phy_ref.duplex_mode == duplex \""  }\
    { rule_basic_enhanced_pcs_tx_rule    ::dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_tx        {native_phy_ref native_phy_ref}    "## EXPRESSION \"native_phy_ref.duplex_mode == tx \""      }\
    { rule_basic_enhanced_pcs_rx_rule    ::dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_rx        {native_phy_ref native_phy_ref}    "## EXPRESSION \"native_phy_ref.duplex_mode == rx \""      }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareRules       ${subRules}

}