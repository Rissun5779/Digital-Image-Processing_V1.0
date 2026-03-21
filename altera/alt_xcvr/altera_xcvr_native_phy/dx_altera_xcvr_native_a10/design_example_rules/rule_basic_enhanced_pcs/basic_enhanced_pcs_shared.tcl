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


package provide dx_altera_xcvr_native_a10::design_example_rules::basic_enhanced_pcs_shared 18.1

package require alt_xcvr::de_tcl::de_api

namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::basic_enhanced_pcs_shared:: {
  namespace export IsEnableTxdivclkInstance \
                   IsEnableRxdivclkInstance
}

 
proc ::dx_altera_xcvr_native_a10::design_example_rules::basic_enhanced_pcs_shared::IsEnableTxdivclkInstance {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set nphy [::alt_xcvr::de_tcl::de_api::de_getMainInstanceName]
  if { [::alt_xcvr::de_tcl::de_api::de_getData "parameter(${nphy}.duplex_mode)"  VALUE ] == "rx" } {
    return 0
  }
  if { ![::alt_xcvr::de_tcl::de_api::de_getData "parameter(${nphy}.enable_port_tx_pma_div_clkout)"  VALUE ] } {
    return 0
  }
  return 1
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::basic_enhanced_pcs_shared::IsEnableRxdivclkInstance {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set nphy [::alt_xcvr::de_tcl::de_api::de_getMainInstanceName]
  if { [::alt_xcvr::de_tcl::de_api::de_getData "parameter(${nphy}.duplex_mode)"  VALUE ] == "tx" } {
    return 0
  }
  if { ![::alt_xcvr::de_tcl::de_api::de_getData "parameter(${nphy}.enable_port_rx_pma_div_clkout)"  VALUE ] } {
    return 0
  }
  return 1
}

