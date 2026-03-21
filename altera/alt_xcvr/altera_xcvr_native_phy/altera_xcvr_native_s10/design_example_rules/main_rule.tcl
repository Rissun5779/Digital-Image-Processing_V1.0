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


package provide altera_xcvr_native_s10::design_example_rules::main_rule 18.1

package require alt_xcvr::de_tcl::de_api

package require altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs
package require altera_xcvr_native_s10::design_example_rules::rule_basic_enhanced_pcs
package require altera_xcvr_native_s10::design_example_rules::rule_pcs_direct

namespace eval ::altera_xcvr_native_s10::design_example_rules::main_rule:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::main_rule::declare_rule {  } {

  set duplex_mode [::alt_xcvr::de_tcl::de_api::de_getData "parameter(main_instance_name.duplex_mode)"   VALUE] 
  set rx_instance_name "rx_nphy"
  set tx_instance_name "tx_nphy"
  set instance_pairs [list native_phy_ref     "main_instance_name" \
                           rx_native_phy_ref  [expr { (${duplex_mode} == "rx") ? ${rx_instance_name} : "main_instance_name" }] \
                           tx_native_phy_ref  [expr { (${duplex_mode} == "tx") ? ${tx_instance_name} : "main_instance_name" }] ]
  ###########################################################################################################################################################################
  ## \TODO for simplex!!! Call here some rules like: create mirror-image <<<<<<--------------------------------------WILL BE ADDED FOR SIMPLEX SUPPORT LATER!!!!!!!
  ## 1) this function declares and instance and parametrization of nphy to tx_nphy. 1: enable the instance, 1: enable the parameters.
  #::alt_xcvr::de_tcl::de_api::de_createDuplicateInstance "main_instance_name" "tx_nphy" 1 1
  ## 2) change some essential parameters - this part will be more complicated
  #::alt_xcvr::de_tcl::de_api::de_setData "parameter(tx_nphy.duplex_mode)"   VALUE     "tx" 
  #::alt_xcvr::de_tcl::de_api::de_setData "parameter(tx_nphy.duplex_mode)"   ENABLED   1 
  ## 3) this functions takes the existing instance and runs it through qsys and gets all the proper derived parameter values
  #::alt_xcvr::de_tcl::de_api::de_validateInstance "tx_phy"; #should the framework try to retain the values applied in step #2??
  ##  remove this stuff after rx_ shown to work
  ##  #overwrites
  ##  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(tx_nphy.design_environment)"   VALUE  "QSYS"
  ##  #meta-data\TODO
  ##  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(tx_nphy.split_suffix)"   VALUE     "_ch" 
  ##  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(tx_nphy.split_suffix)"   ENABLED   0 
  ###########################################################################################################################################################################

  set subRules [list \
    [list NAME                      RULE_TYPE                                                                  INSTANCE_PAIRS      ENABLED                                                               ]\
    [list basic_standard_pcs_rule   ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs    ${instance_pairs}   "## EXPRESSION \"main_instance_name.protocol_mode==basic_std\""       ]\
    [list basic_enhanced_pcs_rule   ::altera_xcvr_native_s10::design_example_rules::rule_basic_enhanced_pcs    ${instance_pairs}   "## EXPRESSION \"main_instance_name.protocol_mode==basic_enh\""       ]\
    [list pcs_direct_rule           ::altera_xcvr_native_s10::design_example_rules::rule_pcs_direct            ${instance_pairs}   "## EXPRESSION \"main_instance_name.protocol_mode==pcs_direct\""       ]\
    [list pcie_pipe_rule            ::altera_xcvr_native_s10::design_example_rules::rule_pcie_pipe             ${instance_pairs}   "## EXPRESSION \"(main_instance_name.protocol_mode==pipe_g3) || (main_instance_name.protocol_mode==pipe_g2) || (main_instance_name.protocol_mode==pipe_g1)\""  ]\
  ]

  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  #overwrites
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.design_environment)"   VALUE  "QSYS"

  #\TODO should we do this for simplex as well???
  #meta-data\TODO
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.split_suffix)"   ENABLED   0   
  
  ###########################################
  # retrieve some useful data and turn it into Meta data ----_HW.TCL CALL \TODO wrap _hw.tcl functions so that it is easier to detect them
  set simple_if [::alt_xcvr::de_tcl::de_api::de_getData "parameter(main_instance_name.enable_simple_interface)" VALUE]
  if {${simple_if}} {
    #Unused parallel data ports only used with simplified interfaces
    ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.unused_tx_parallel_data_width)"   VALUE [get_port_property "unused_tx_parallel_data" WIDTH_VALUE]
    ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.unused_tx_parallel_data_width)"   ENABLED   0
    ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.unused_rx_parallel_data_width)"   VALUE [get_port_property "unused_rx_parallel_data" WIDTH_VALUE]
    ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.unused_rx_parallel_data_width)"   ENABLED   0
  }

  set tmp_tx_data_width [::alt_xcvr::de_tcl::de_api::de_getData "parameter(main_instance_name.l_tx_adapt_pcs_width)" VALUE]
  set tmp_rx_data_width [::alt_xcvr::de_tcl::de_api::de_getData "parameter(main_instance_name.l_rx_adapt_pcs_width)" VALUE]
  set std_tx_8b10b [::alt_xcvr::de_tcl::de_api::de_getData "parameter(main_instance_name.std_tx_8b10b_enable)" VALUE]
  set std_rx_8b10b [::alt_xcvr::de_tcl::de_api::de_getData "parameter(main_instance_name.std_rx_8b10b_enable)" VALUE]
  set tmp_tx_data_width [::altera_xcvr_native_s10::design_example_rules::main_rule::resolveParallelDataWidth ${tmp_tx_data_width} ${std_tx_8b10b}]
  set tmp_rx_data_width [::altera_xcvr_native_s10::design_example_rules::main_rule::resolveParallelDataWidth ${tmp_rx_data_width} ${std_rx_8b10b}]
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.tx_generator_data_width)" VALUE $tmp_tx_data_width
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.rx_checker_data_width)" VALUE $tmp_rx_data_width
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.tx_generator_data_width)" ENABLED 0
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(main_instance_name.rx_checker_data_width)" ENABLED 0


  ::alt_xcvr::de_tcl::de_api::de_declareRules ${subRules}
}

proc ::altera_xcvr_native_s10::design_example_rules::main_rule::resolveParallelDataWidth {adapt_pcs_width std_8b10b} {
  set datapath_select [::alt_xcvr::de_tcl::de_api::de_getData "parameter(main_instance_name.datapath_select)" VALUE]
  set x1x2_en [::alt_xcvr::de_tcl::de_api::de_getData "parameter(main_instance_name.enable_double_rate_transfer)" VALUE]
  set temp_data_width $adapt_pcs_width

  # TODO: Find out if it's generally needed to map from 66 to 64
  # In the case of the enhanced pcs, 66 does not need to map to 64
  if { (${temp_data_width} == 66) && (${datapath_select} != "Enhanced") } {set temp_data_width 64}

  if {${datapath_select} == "Standard" && $std_8b10b} {
    set temp_data_width [expr {${temp_data_width}*9/10}]
  }

  if {$x1x2_en} {
    set temp_data_width [expr {${temp_data_width}/2}]
  }
  return $temp_data_width
}
