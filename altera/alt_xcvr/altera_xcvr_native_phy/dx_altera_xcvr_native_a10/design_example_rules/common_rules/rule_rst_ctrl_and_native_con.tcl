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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con 18.1

package require alt_xcvr::de_tcl::de_api
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks


namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con:: {
  namespace export declare_rule  
}


proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set resetCtrl_to_native_connections {\
      { NAME                                                                         ENABLED                                                  EXPAND_CALLBACK            }\
      { "reset_controller_ref.tx_analogreset/native_phy_ref.tx_analogreset"          "## EXPRESSION \"(native_phy_ref.duplex_mode != rx)\""   ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "reset_controller_ref.tx_digitalreset/native_phy_ref.tx_digitalreset"        "## EXPRESSION \"(native_phy_ref.duplex_mode != rx)\""   ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "reset_controller_ref.rx_analogreset/native_phy_ref.rx_analogreset"          "## EXPRESSION \"(native_phy_ref.duplex_mode != tx)\""   ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "reset_controller_ref.rx_digitalreset/native_phy_ref.rx_digitalreset"        "## EXPRESSION \"(native_phy_ref.duplex_mode != tx)\""   ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  set native_to_resetCtrl_connections {\
      { NAME                                                                         ENABLED                                                                                                     EXPAND_CALLBACK            }\
      { "native_phy_ref.tx_cal_busy/reset_controller_ref.tx_cal_busy"                "## EXPRESSION \"(native_phy_ref.duplex_mode != rx)\""                                                      ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "native_phy_ref.rx_cal_busy/reset_controller_ref.rx_cal_busy"                "## EXPRESSION \"(native_phy_ref.duplex_mode != tx)\""                                                      ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "native_phy_ref.rx_is_lockedtodata/reset_controller_ref.rx_is_lockedtodata"  "## EXPRESSION \"(native_phy_ref.duplex_mode != tx) && (native_phy_ref.enable_port_rx_is_lockedtodata)\""   ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  
  if { [::alt_xcvr::de_tcl::de_api::de_getData "instance(reset_controller_ref)"  ENABLED ] } {
    ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${resetCtrl_to_native_connections}
    ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${native_to_resetCtrl_connections}
  }
}