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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  #\TODO is ENABLED NECESSARY??
  set pll_to_resetCtrl_connections {\
      { NAME                                                                         ENABLED                                                     }\
      { "pll_ref.pll_locked/reset_controller_ref.pll_locked"                         "## EXPRESSION \"!(native_phy_ref.enable_split_interface)\""}\
      { "pll_ref.pll_locked/reset_controller_ref.pll_locked0"                        "## EXPRESSION \" (native_phy_ref.enable_split_interface)\""}\
  }
  #\TODO pll_cal_busy connection??

  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${pll_to_resetCtrl_connections} 
}
