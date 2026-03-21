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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_bus_split_concat_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bus_split_concat_par:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bus_split_concat_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
  # MetaData for the bus_split and bus_concat instances 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(bus_split_ref.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(bus_split_ref.split_suffix)"   ENABLED   0 
  
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(bus_concat_ref.split_suffix)"   VALUE     "_ch" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(bus_concat_ref.split_suffix)"   ENABLED   0 

  set bus_split_parameters {\
    { NAME                                  VALUE                                                                      ENABLED   }\
    { bus_split_ref.gui_split_interfaces   "## MAPS_FROM tx_native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"   1         }\
    { bus_split_ref.CHANNELS               "## MAPS_FROM tx_native_phy_ref.channels MAP_DEFAULT NOVAL"                 1         }\
    { bus_split_ref.DWIDTH_I1              "## MAPS_FROM tx_native_phy_ref.tx_generator_data_width MAP_DEFAULT NOVAL"  1         }\
    { bus_split_ref.DWIDTH_O1              64                                                                          1         }\
    { bus_split_ref.DWIDTH_O2              "## EXPRESSION \"( tx_native_phy_ref.tx_generator_data_width - 64 )\""      1         }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareParameters ${bus_split_parameters}

  set bus_concat_parameters {\
    { NAME                                   VALUE                                                                      ENABLED   }\
    { bus_concat_ref.gui_split_interfaces   "## MAPS_FROM rx_native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"   1         }\
    { bus_concat_ref.CHANNELS               "## MAPS_FROM rx_native_phy_ref.channels MAP_DEFAULT NOVAL"                 1         }\
    { bus_concat_ref.DWIDTH_I1              64                                                                          1         }\
    { bus_concat_ref.DWIDTH_I2              "## EXPRESSION \"( rx_native_phy_ref.rx_checker_data_width - 64 )\""        1         }\
    { bus_concat_ref.DWIDTH_O1              "## MAPS_FROM rx_native_phy_ref.rx_checker_data_width MAP_DEFAULT NOVAL"    1         }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareParameters ${bus_concat_parameters}

  set generator_split_connections {\
      { NAME                                                                   ENABLED  EXPAND_CALLBACK                                                                                                                                       }\
      { "data_generator_ref.data_out/bus_split_ref.data_in1"                   1        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "bus_split_ref.data_out1/tx_native_phy_ref.tx_parallel_data"           1        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "bus_split_ref.data_out2/tx_native_phy_ref.tx_control"                 "## EXPRESSION \"(tx_native_phy_ref.datapath_select==Enhanced)\""        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "bus_split_ref.data_out2/tx_native_phy_ref.tx_datak"                   "## EXPRESSION \"(tx_native_phy_ref.datapath_select==Standard)\""        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${generator_split_connections}  
  
  set checker_concat_connections {\
      { NAME                                                                   ENABLED  EXPAND_CALLBACK                                                                                                                                       }\
      { "rx_native_phy_ref.rx_parallel_data/bus_concat_ref.data_in1"           1        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "rx_native_phy_ref.rx_control/bus_concat_ref.data_in2"                 "## EXPRESSION \"(rx_native_phy_ref.datapath_select==Enhanced)\""        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "rx_native_phy_ref.rx_datak/bus_concat_ref.data_in2"                   "## EXPRESSION \"(rx_native_phy_ref.datapath_select==Standard)\""        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      { "bus_concat_ref.data_out1/data_checker_ref.data_in"                    1        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${checker_concat_connections} 
}

