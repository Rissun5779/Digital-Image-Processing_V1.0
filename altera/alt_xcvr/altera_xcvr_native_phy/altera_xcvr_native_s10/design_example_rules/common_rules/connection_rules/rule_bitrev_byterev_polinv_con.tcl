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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_con 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks

namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_con:: {
#  namespace export declare_rule
}

#Rules for simplified to unsimplified interface adapter for PCS Direct double transfer rate mode
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set bitrev_byterev_polinv_connections {\
    { NAME                                                                              ENABLED                                                         EXPAND_CALLBACK         }\
    { "bitrev_byterev_polinv_ref.tx_polinv/tx_native_phy_ref.tx_polinv"                     "## EXPRESSION \"(tx_native_phy_ref.std_tx_polinv_enable)\""    ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "bitrev_byterev_polinv_ref.rx_std_bitrev_ena/rx_native_phy_ref.rx_std_bitrev_ena"     "## EXPRESSION \"(rx_native_phy_ref.std_rx_bitrev_enable)\""    ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "bitrev_byterev_polinv_ref.rx_std_byterev_ena/rx_native_phy_ref.rx_std_byterev_ena"   "## EXPRESSION \"(rx_native_phy_ref.std_rx_byterev_enable)\""   ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "bitrev_byterev_polinv_ref.rx_polinv/rx_native_phy_ref.rx_polinv"                     "## EXPRESSION \"(rx_native_phy_ref.std_rx_polinv_enable)\""    ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${bitrev_byterev_polinv_connections}
}
