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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_slp_data_gen_check_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_slp_data_gen_check_par:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_slp_data_gen_check_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
  set generator_parameters {\
    { NAME                                     VALUE                                                                            ENABLED  }\
    { data_generator_ref.CHANNELS              "## MAPS_FROM tx_native_phy_ref.channels MAP_DEFAULT NOVAL"                      1        }\
    { data_generator_ref.SPLIT_INTERFACE_EN    "## MAPS_FROM tx_native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"        1        }\
    { data_generator_ref.DATA_WIDTH            "## MAPS_FROM tx_native_phy_ref.enh_pld_pcs_width MAP_DEFAULT NOVAL"             1        }\
    { data_generator_ref.STATIC_PATTERN_EN     1                                                                                1        }\
    { data_generator_ref.STATIC_PATTERN        0                                                                                1        }\
    { data_generator_ref.EXTERNAL              1                                                                                1        }\

  }    

  set checker_parameters {\
    { NAME                                     VALUE                                                                          ENABLED     }\
    { data_checker_ref.CHANNELS                "## MAPS_FROM rx_native_phy_ref.channels MAP_DEFAULT NOVAL"                    1           }\
    { data_checker_ref.SPLIT_INTERFACE_EN      "## MAPS_FROM rx_native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"      1           }\
    { data_checker_ref.DATA_WIDTH              "## MAPS_FROM rx_native_phy_ref.enh_pld_pcs_width  MAP_DEFAULT NOVAL"          1           }\
    { data_checker_ref.STATIC_PATTERN_EN       1                                                                              1           }\
    { data_checker_ref.STATIC_PATTERN          0                                                                              1           }\
    { data_checker_ref.EXTERNAL                1                                                                              1           }\

  }    

  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${generator_parameters}   
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${checker_parameters}   
  
  # MetaData for Data Generator 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(data_generator_ref.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(data_generator_ref.split_suffix)"   ENABLED   0 
  
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(data_checker_ref.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(data_checker_ref.split_suffix)"   ENABLED   0 
}
