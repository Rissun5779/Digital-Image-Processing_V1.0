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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_x1x2_if_adapter_con 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks

namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_x1x2_if_adapter_con:: {
#  namespace export declare_rule
}

#Rules for simplified to unsimplified interface adapter for PCS Direct double transfer rate mode
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_x1x2_if_adapter_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
  set reset_connections {\
    { NAME                                                                              ENABLED         EXPAND_CALLBACK            }\
    { "reset_controller_ref.tx_digitalreset/x1x2_if_adapter_ref.tx_digitalreset"        1               ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }

  set generator_connections {\
    { NAME                                                                    ENABLED                                                           EXPAND_CALLBACK            }\
    { "data_generator_ref.data_out/x1x2_if_adapter_ref.gen_data_out"          1                                                                 ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "tx_native_phy_ref.tx_dll_lock/x1x2_if_adapter_ref.tx_fifo_wr_en"       "## EXPRESSION \"(tx_native_phy_ref.tx_fifo_mode==Basic)\""       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "x1x2_if_adapter_ref.tx_data/tx_native_phy_ref.tx_parallel_data"        1                                                                 ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }

  set checker_connections {\
    { NAME                                                                    ENABLED                                                           EXPAND_CALLBACK            }\
    { "rx_native_phy_ref.rx_parallel_data/x1x2_if_adapter_ref.rx_data"        1                                                                 ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "x1x2_if_adapter_ref.check_data_in/data_checker_ref.data_in"            1                                                                 ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${reset_connections}
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${generator_connections}
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${checker_connections}
}
