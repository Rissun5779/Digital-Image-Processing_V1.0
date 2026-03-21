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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par 18.1

package require alt_xcvr::de_tcl::de_api


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
   set main_parameters {\
      {NAME                               VALUE                                                                                                                ENABLED     } \
      {pll_ref.mcgb_div                   "1"                                                                                                                  1           } \
      {pll_ref.enable_mcgb                "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::EnableMcgb "       1           } \
      {pll_ref.pma_width                  "## MAPS_FROM tx_native_phy_ref.l_pcs_pma_width MAP_DEFAULT NOVAL"                                                   1           } \
      {pll_ref.enable_bonding_clks        "## EXPRESSION \"( tx_native_phy_ref.bonded_mode != not_bonded ) \" "                                                1           } \
      {pll_ref.enable_hfreq_clk           "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::EnableHfreqClk "   1           } \
      {pll_ref.enable_mcgb_pcie_clksw     "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::EnablePcieClksw"   1           } \
      {pll_ref.mcgb_aux_clkin_cnt         "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::EnableAuxClk"      1           } \
   }
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${main_parameters}   

}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::EnableMcgb {} {

  set is_tx_bonded   [ expr {[::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.bonded_mode)"  VALUE ] != "not_bonded"} ]
  set num_chan       [ ::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.channels)" VALUE ]
  
  # Enable the mcgb in the following situations:
  # 1. For all bonded cases
  # 2. For non-bonded cases where the number of channels is greater than 6
  #    The XN clock network should be used via the MCGB and X6 clock lines
  if { $is_tx_bonded } {
    set en_mcgb 1
  } elseif { $num_chan > 6 } {
    set en_mcgb 1
  } else {
    set en_mcgb 0
  }

  return $en_mcgb

}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::EnableHfreqClk {} {

  set is_tx_bonded   [ expr {[::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.bonded_mode)"  VALUE ] != "not_bonded"} ]
  set num_chan       [ ::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.channels)" VALUE ]
  
  # The MCGB High Frequency Clock is enabled for non-bonded designs where the 
  #  number of channels is greater than 6 
  if { ($is_tx_bonded == 0)  && ($num_chan > 6) } {
    set en_hfclk 1
  } else {
    set en_hfclk 0
  }

  return $en_hfclk

}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::EnablePcieClksw {} {
  
  set lcl_prot_mode  [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.protocol_mode)" VALUE ]

  if { ( ($lcl_prot_mode == "pcie_gen1") || ($lcl_prot_mode=="pcie_gen2") || ($lcl_prot_mode=="pcie_gen3") ) } {
    return 1;
  } else {
    return 0;
  }
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par::EnableAuxClk {} {

  set lcl_prot_mode  [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.protcol_mode)" VALUE ]

  if { ( $lcl_prot_mode=="pcie_gen3" ) } {
    return 1;
  } else {
    return 0;
  }

}
