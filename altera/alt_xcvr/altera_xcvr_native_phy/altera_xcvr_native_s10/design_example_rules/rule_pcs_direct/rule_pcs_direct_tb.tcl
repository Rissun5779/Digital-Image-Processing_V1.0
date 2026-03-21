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


package provide altera_xcvr_native_s10::design_example_rules::rule_pcs_direct_tb 18.1

package require alt_xcvr::de_tcl::de_api

namespace eval ::altera_xcvr_native_s10::design_example_rules::rule_pcs_direct_tb:: {
  namespace export declare_rule  
}

proc ::altera_xcvr_native_s10::design_example_rules::rule_pcs_direct_tb::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set instances {\
    { NAME                 KIND                         ENABLED                                                                     }\
    { "dut"                "dut_kind_ref"               1                                                                           }\
    { "tb_stim_gen_inst"   "alt_xcvr_tb_stim_gen"       1                                                                           }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareInstances  ${instances}

  #meta-data\TODO
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(dut.split_suffix)"   VALUE     "_ch"
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(dut.split_suffix)"   ENABLED   0

  #\TODO other parameters!!!
  set parameters {\
    { NAME                                     VALUE                                                                    ENABLED     }\
    { tb_stim_gen_inst.pll_refclk_freq_mhz     "## MAPS_FROM native_phy_ref.tx_pll_refclk MAP_DEFAULT NOVAL"            1           }\
    { tb_stim_gen_inst.CHANNELS                "## MAPS_FROM native_phy_ref.channels MAP_DEFAULT NOVAL"                 1           }\
    { tb_stim_gen_inst.gui_split_interfaces    "## MAPS_FROM native_phy_ref.enable_split_interface MAP_DEFAULT NOVAL"   1           }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${parameters}

   #split_suffix is not a core pll parameter that's why we DISABLE it!!!! ask ILKAY why
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(tb_stim_gen_inst.split_suffix)"   VALUE     "_ch"
  ::alt_xcvr::de_tcl::de_api::de_setData "parameter(tb_stim_gen_inst.split_suffix)"   ENABLED   0


  #\TODO: rx/tx/duplexify the rules
  set connections {\
    { NAME                                                                   SPLIT_CONNECTION   ADAPT_CONNECTION  ENABLED                                                     EXPAND_CALLBACK            }\
    { "tb_stim_gen_inst.mgmt_clk/dut.rst_ctr_inst_clock"                     0                  0                 1                                                           NOVAL                      }\
    { "tb_stim_gen_inst.mgmt_clk/dut.reset_sync_inst_clk"                    0                  0                 1                                                           NOVAL                      }\
    { "tb_stim_gen_inst.mgmt_clk/dut.protocol_tester_inst_clock"             0                  0                 1                                                           NOVAL                      }\
    { "tb_stim_gen_inst.mgmt_clk/dut.freq_check_txclkout_inst_ref_clock"     0                  0                 1                                                           NOVAL                      }\
    { "tb_stim_gen_inst.mgmt_clk/dut.freq_check_rxclkout_inst_ref_clock"     0                  0                 1                                                           NOVAL                      }\
      \
    { "tb_stim_gen_inst.pll_ref_clk/dut.nphy_rx_cdr_refclk0"                 0                  0                 "## EXPRESSION \"native_phy_ref.duplex_mode != tx \""       NOVAL                      }\
    { "tb_stim_gen_inst.pll_ref_clk/dut.rx_nphy_rx_cdr_refclk0"              0                  0                 "## EXPRESSION \"native_phy_ref.duplex_mode == tx \""       NOVAL                      }\
      \
    { "tb_stim_gen_inst.rx_serial_data/dut.nphy_rx_serial_data"              0                  0                 "## EXPRESSION \"native_phy_ref.duplex_mode != tx \""       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "tb_stim_gen_inst.rx_serial_data/dut.rx_nphy_rx_serial_data"           0                  0                 "## EXPRESSION \"native_phy_ref.duplex_mode == tx \""       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      \
    { "tb_stim_gen_inst.pll_ref_clk/dut.pll_inst_pll_refclk0"                0                  0                 1                                                           NOVAL                      }\
    { "tb_stim_gen_inst.mgmt_reset/dut.reset_sync_inst_reset_req"            0                  0                 1                                                           NOVAL                      }\
      \
    { "dut.nphy_tx_serial_data/tb_stim_gen_inst.tx_serial_data"              0                  0                 "## EXPRESSION \"native_phy_ref.duplex_mode != rx \""       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
    { "dut.tx_nphy_tx_serial_data/tb_stim_gen_inst.tx_serial_data"           0                  0                 "## EXPRESSION \"native_phy_ref.duplex_mode == rx \""       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix }\
      \
    { "dut.protocol_tester_inst_pass/tb_stim_gen_inst.pass"                  0                  0                 1                                                           NOVAL                      }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${connections}
}

