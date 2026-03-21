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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_par:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
  # \TODO what to do for --->  SYS_CLK_IN_MHZ  #  T_TX_ANALOGRESET  #  T_TX_DIGITALRESET  #  T_RX_ANALOGRESET  #  T_RX_DIGITALRESET
  # TODO confirm the values for the counters
  set parameters {\
    { NAME                                       VALUE                                                                          ENABLED     }\
    { reset_controller_ref.CHANNELS              "## MAPS_FROM native_phy_ref.channels MAP_DEFAULT NOVAL"                       1           }\
    { reset_controller_ref.gui_split_interfaces  "## MAPS_FROM native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"         1           }\
    { reset_controller_ref.TX_PLL_ENABLE         1                                                                              1           }\
    { reset_controller_ref.TX_ENABLE             1                                                                              1           }\
    { reset_controller_ref.RX_ENABLE             1                                                                              1           }\
    { reset_controller_ref.SYS_CLK_IN_MHZ        100                                                                            1           }\
    { reset_controller_ref.T_TX_ANALOGRESET      70                                                                             1           }\
    { reset_controller_ref.T_TX_DIGITALRESET     20                                                                             1           }\
    { reset_controller_ref.T_RX_ANALOGRESET      70                                                                             1           }\
    { reset_controller_ref.T_RX_DIGITALRESET     4000                                                                           1           }\
  }  

   
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${parameters}   
  
  #split_suffix is not a core reset_controller parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(reset_controller_ref.split_suffix)"   VALUE     "" 
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(reset_controller_ref.split_suffix)"   ENABLED   0 
}
