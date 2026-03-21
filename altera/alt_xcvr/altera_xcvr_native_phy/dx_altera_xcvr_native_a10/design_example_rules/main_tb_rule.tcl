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


package provide dx_altera_xcvr_native_a10::design_example_rules::main_tb_rule 18.1

package require alt_xcvr::de_tcl::de_api

package require dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_tb

namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::main_tb_rule:: {
  namespace export declare_rule  
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::main_tb_rule::declare_rule {  } {

  # \TODO NAME should be unique
  set subRules {\
    { NAME                         RULE_TYPE                                                                        ENABLED                                                            INSTANCE_PAIRS                         }\
    { basic_enhanced_pcs_tb_rule   ::dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_tb    "## EXPRESSION \"main_instance_name.protocol_mode==basic_enh\""    {native_phy_ref main_instance_name dut_kind_ref dut_kind_ref}   }\
  }

  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  #overwrites
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.design_environment)"   VALUE  "QSYS"

  #meta-data\TODO
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.split_suffix)"   ENABLED   0 
    
  ::alt_xcvr::de_tcl::de_api::de_declareRules ${subRules}
}
