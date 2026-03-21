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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc 18.1

package require alt_xcvr::de_tcl::de_api
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks


namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc:: {
  namespace export declare_rule  
}


proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  #split_suffix is not a core frequency checker parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(freq_check_ref.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(freq_check_ref.split_suffix)"   ENABLED   0  

  # \TODO is setting COUNT to 100 good?
  set checker_parameters {\
    { NAME                                 VALUE                                                                       ENABLED     }\
    { freq_check_ref.CHANNELS              "## MAPS_FROM native_phy_ref.channels MAP_DEFAULT NOVAL"                    1           }\
    { freq_check_ref.gui_split_interfaces  "## MAPS_FROM native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"      1           }\
    { freq_check_ref.COUNT                 100                                                                         1           }\
  }    

  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${checker_parameters}   
  
  set connections {\
    { NAME                                                                          ENABLED   EXPAND_CALLBACK                                                                                      }\
    { "start_freq_check_source_ref/freq_check_ref.start_freq_check"     1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "freq_check_ref.freq_measured/freq_measured_target_ref"           1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "freq_check_ref.clkout_freq/clkout_freq_target_ref"               1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "clkout_source_ref/freq_check_ref.measured_clock"                 1         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${connections}
}