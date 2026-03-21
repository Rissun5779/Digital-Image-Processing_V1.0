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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_reset_sync_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_reset_sync_par:: {
  namespace export declare_rule  
}


proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_reset_sync_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
  # \TODO this parametrization needs to be changed for sure --> filler
  set parameters {\
    { NAME                               VALUE       ENABLED     }\
    { reset_sync_ref.CLKS_PER_SEC        100000000   1           }\
    { reset_sync_ref.RESET_PER_NS        25          1           }\
  }
  
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${parameters}

}
