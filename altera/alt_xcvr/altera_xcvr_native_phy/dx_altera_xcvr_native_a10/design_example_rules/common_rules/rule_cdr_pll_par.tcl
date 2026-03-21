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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_cdr_pll_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_cdr_pll_par:: {
  namespace export declare_rule  
}


proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_cdr_pll_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set main_parameters {\
    { NAME                                  VALUE                                                                                                                                          ENABLED     }\
    { pll_ref.gui_tx_pll_prot_mode          "## MAPS_FROM native_phy_ref.protocol_mode MAPPING {(pipe_g1:PCIE) (pipe_g2:PCIE) (pipe_g3:PCIE)} MAP_DEFAULT Basic"                           1           }\
    { pll_ref.output_clock_frequency        "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_cdr_pll_par::resolvecdrOutputClkRate"               1           }\
    { pll_ref.reference_clock_frequency     "## MAPS_FROM native_phy_ref.tx_pll_refclk MAP_DEFAULT NOVAL"                                                                                  1           }\
  }
  
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${main_parameters}   
  #\TODO later add MCGB parameters

   #split_suffix is not a core pll parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(pll_ref.split_suffix)"   VALUE     "" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(pll_ref.split_suffix)"   ENABLED   0 

  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(pll_ref.enable_8G_path)"   VALUE     1 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(pll_ref.enable_8G_path)"   ENABLED   0 


}

proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_cdr_pll_par::resolvecdrOutputClkRate {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
   return [expr {[::alt_xcvr::de_tcl::de_api::de_getData "parameter(native_phy_ref.set_data_rate)"  VALUE ]/2}];
}

#\TODO enable_8G_path ----> needs to be made dynamic
