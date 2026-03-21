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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_con 18.1

package require alt_xcvr::de_tcl::de_api
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks

namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_con:: {
  namespace export declare_rule  
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set generator_connections {\
      { NAME                                                                     ENABLED                                                                EXPAND_CALLBACK            }\
      { "data_generator_ref.data_out/tx_native_phy_ref.tx_parallel_data"         1                                                                      ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  
  set checker_connections {\
      { NAME                                                                     ENABLED                                                                EXPAND_CALLBACK            }\
      { "rx_native_phy_ref.rx_parallel_data/data_checker_ref.data_in"            1                                                                      ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  
  # \TODO: "reset_controller_ref.tx_ready/data_generator_ref.reset" --> is temporary!!!
  # \TODO: "data_generator_ref.data_out/native_phy_ref.tx_parallel_data"  partial !!!! ok if simplified interface is selected!!!

  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${generator_connections}  
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${checker_connections} 
}
