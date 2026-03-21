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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_par:: {
#  namespace export declare_rule
}

#parameter rules for the PCS Direct double transfer rate mode simplified<->unsimplified interface adapter
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set bitrev_byterev_polinv_parameters {\
    { NAME                                            VALUE                                                                             ENABLED }\
    { bitrev_byterev_polinv_ref.gui_split_interfaces  "## MAPS_FROM native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"            1       }\
    { bitrev_byterev_polinv_ref.CHANNELS              "## MAPS_FROM native_phy_ref.channels MAP_DEFAULT NOVAL"                          1       }\
    { bitrev_byterev_polinv_ref.TX_POLINV_EN          "## MAPS_FROM tx_native_phy_ref.std_tx_polinv_enable MAP_DEFAULT NOVAL"           1       }\
    { bitrev_byterev_polinv_ref.RX_BITREV_EN          "## MAPS_FROM rx_native_phy_ref.std_rx_bitrev_enable MAP_DEFAULT NOVAL"           1       }\
    { bitrev_byterev_polinv_ref.RX_BYTEREV_EN         "## MAPS_FROM rx_native_phy_ref.std_rx_byterev_enable MAP_DEFAULT NOVAL"          1       }\
    { bitrev_byterev_polinv_ref.RX_POLINV_EN          "## MAPS_FROM rx_native_phy_ref.std_rx_polinv_enable MAP_DEFAULT NOVAL"           1       }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${bitrev_byterev_polinv_parameters}

  #split_suffix is not a core x1x2 interface adapter parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(bitrev_byterev_polinv_ref.split_suffix)"   VALUE     "_ch"
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(bitrev_byterev_polinv_ref.split_suffix)"   ENABLED   0
}
