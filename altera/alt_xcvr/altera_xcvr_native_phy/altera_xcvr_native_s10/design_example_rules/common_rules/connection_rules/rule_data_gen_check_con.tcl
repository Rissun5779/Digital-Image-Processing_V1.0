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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks

namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con:: {
  namespace export declare_rule  
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set data_connections {\
      { NAME                                                                     ENABLED                                                                                                                         EXPAND_CALLBACK                                                                                                                                       }\
      { "data_generator_ref.data_out/tx_native_phy_ref.tx_parallel_data"         "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con::resolveTxConnect"   ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "rx_native_phy_ref.rx_parallel_data/data_checker_ref.data_in"            "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con::resolveRxConnect"   ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${data_connections} 
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con::resolveTxConnect {} {

  set datapath_select [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.datapath_select)" VALUE]
  set transfer_mode   [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.l_tx_fifo_transfer_mode)" VALUE]
  set temp_data_width [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.enh_pld_pcs_width)" VALUE]
  set en_8b10b        [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.std_tx_8b10b_enable)" VALUE]

  set connect 1
  # If the 10G pld-pcs width is 66 or 67 or ddr mode is active, direct connection from the native phy to the data generator
  #  is not possible
  if { ( ($datapath_select == "Enhanced") && ($temp_data_width > 64) ) || ($datapath_select == "Standard" && $en_8b10b) || ($transfer_mode == "x1x2") } {
    set connect 0
  }

  return $connect
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con::resolveRxConnect {} {

  set datapath_select [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.datapath_select)" VALUE]
  set transfer_mode   [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.l_rx_fifo_transfer_mode)" VALUE]
  set temp_data_width [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enh_pld_pcs_width)" VALUE]
  set en_8b10b        [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.std_rx_8b10b_enable)" VALUE]

  set connect 1
  # If the 10G pld-pcs width is 66 or 67 or ddr mode is active, direct connection from the native phy to the data checker 
  #  is not possible
  if { ( ($datapath_select == "Enhanced") && ($temp_data_width > 64) ) || ($datapath_select == "Standard" && $en_8b10b) || ($transfer_mode == "x1x2") } {
    set connect 0
  }

  return $connect
}
