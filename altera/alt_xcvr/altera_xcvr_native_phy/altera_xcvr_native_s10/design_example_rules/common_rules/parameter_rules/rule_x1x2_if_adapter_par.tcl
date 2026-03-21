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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_x1x2_if_adapter_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_x1x2_if_adapter_par:: {
#  namespace export declare_rule
}

#parameter rules for the PCS Direct double transfer rate mode simplified<->unsimplified interface adapter
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_x1x2_if_adapter_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set x1x2_adapter_parameters {\
    { NAME                                      VALUE                                                                           ENABLED }\
    { x1x2_if_adapter_ref.CHANNELS              "## MAPS_FROM native_phy_ref.channels MAP_DEFAULT NOVAL"                        1       }\
    { x1x2_if_adapter_ref.gui_split_interfaces  "## MAPS_FROM native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"          1       }\
    { x1x2_if_adapter_ref.WIDTH                 "## MAPS_FROM native_phy_ref.tx_generator_data_width MAP_DEFAULT NOVAL"         1       }\
    { x1x2_if_adapter_ref.BASIC_TX_FIFO_MODE_EN "## EXPRESSION \"(native_phy_ref.tx_fifo_mode==Basic)\""                        1       }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${x1x2_adapter_parameters}

  #split_suffix is not a core x1x2 interface adapter parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(x1x2_if_adapter_ref.split_suffix)"   VALUE     "_ch"
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(x1x2_if_adapter_ref.split_suffix)"   ENABLED   0
}
