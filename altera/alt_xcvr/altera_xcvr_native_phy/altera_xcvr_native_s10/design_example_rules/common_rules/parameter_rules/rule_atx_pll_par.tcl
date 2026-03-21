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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_atx_pll_par 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_atx_pll_par:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_atx_pll_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
  set main_parameters {\
    { NAME                                        VALUE                                                                                                                                          ENABLED     }\
    { pll_ref.prot_mode                           "## MAPS_FROM tx_native_phy_ref.protocol_mode MAPPING {(pipe_g1:PCIe Gen 1) (pipe_g2:PCIe Gen 2) (pipe_g3:PCIe Gen 3)} MAP_DEFAULT Basic"      1           }\
    { pll_ref.set_output_clock_frequency          "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_atx_pll_par::resolveatxOutputClkRate"                  1           }\
    { pll_ref.set_auto_reference_clock_frequency  "## MAPS_FROM tx_native_phy_ref.tx_pll_refclk MAP_DEFAULT NOVAL"                                                                               1           }\
    { pll_ref.enable_8G_path                      1                                                                                                                                              1           }\
    { pll_ref.usr_analog_voltage                  "## MAPS_FROM tx_native_phy_ref.anlg_voltage MAP_DEFAULT NOVAL"                                                                                1           }\
  }
  
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${main_parameters}   
  #\TODO later add MCGB parameters

   #split_suffix is not a core pll parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(pll_ref.split_suffix)"   VALUE     "" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(pll_ref.split_suffix)"   ENABLED   0 

  set subRules {\
    { NAME            RULE_TYPE                                                                        ENABLED    INSTANCE_PAIRS                                               }\
    { mcgb_par_rule   ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par      1          {tx_native_phy_ref "tx_native_phy_ref"    pll_ref "pll_ref"} }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareRules       ${subRules}

}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_atx_pll_par::resolveatxOutputClkRate {} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
   return [expr {[::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.set_data_rate)"  VALUE ]/2}];
}

#\TODO enable_8G_path ----> needs to be made dynamic
