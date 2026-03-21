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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set tx_connections {\
      { NAME                                                                                      ENABLED      EXPAND_CALLBACK            }\
      { "reset_controller_ref.tx_analogreset/tx_native_phy_ref.tx_analogreset"                 1            ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "reset_controller_ref.tx_digitalreset/tx_native_phy_ref.tx_digitalreset"               1            ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "tx_native_phy_ref.tx_cal_busy/reset_controller_ref.tx_cal_busy"                       1            ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "tx_native_phy_ref.tx_analogreset_stat/reset_controller_ref.tx_analogreset_stat"       1            ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "tx_native_phy_ref.tx_digitalreset_stat/reset_controller_ref.tx_digitalreset_stat"     1            ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  # \TODO TEMPORARY FIX TO BYPASS THE CAL_BUSY, AS ITS x
  set rx_connections {\
      { NAME                                                                                      ENABLED                                                                  EXPAND_CALLBACK            }\
      { "reset_controller_ref.rx_analogreset/rx_native_phy_ref.rx_analogreset"                 1                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "reset_controller_ref.rx_digitalreset/rx_native_phy_ref.rx_digitalreset"               1                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "rx_native_phy_ref.rx_cal_busy/reset_controller_ref.rx_cal_busy"                       1                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "rx_native_phy_ref.rx_analogreset_stat/reset_controller_ref.rx_analogreset_stat"       1                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "rx_native_phy_ref.rx_digitalreset_stat/reset_controller_ref.rx_digitalreset_stat"     1                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "rx_native_phy_ref.rx_is_lockedtodata/reset_controller_ref.rx_is_lockedtodata"         "## EXPRESSION \"(rx_native_phy_ref.enable_port_rx_is_lockedtodata)\""   ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${tx_connections}
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${rx_connections}
 
}
