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


package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_con 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks


namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_con:: {
  namespace export declare_rule  
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_con::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

    
  #\TODO need to be related to simplified interfaces enabled --> ENABLED
  set connections {\
    { NAME                                                                                              ENABLED                                                                                                                                  EXPAND_CALLBACK           }\
    { "protocol_tester_ref.unused_tx_parallel_data/tx_native_phy_ref.unused_tx_parallel_data"           "## EXPRESSION \"(tx_native_phy_ref.enable_simple_interface)\""                                                                          "NOVAL"                   }\
    { "rx_native_phy_ref.unused_rx_parallel_data/protocol_tester_ref.unused_rx_parallel_data"           "## EXPRESSION \"(rx_native_phy_ref.enable_simple_interface)\""                                                                          "NOVAL"                   }\
      \
    { "rx_native_phy_ref.rx_is_lockedtodata/protocol_tester_ref.rx_is_lockedtodata"                     "## EXPRESSION \"(rx_native_phy_ref.enable_port_rx_is_lockedtodata)\""                                                                   ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "rx_native_phy_ref.rx_is_lockedtoref/protocol_tester_ref.rx_is_lockedtoref"                       "## EXPRESSION \"(rx_native_phy_ref.enable_port_rx_is_lockedtoref)\""                                                                    ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.rx_set_locktodata/rx_native_phy_ref.rx_set_locktodata"                       "## EXPRESSION \"(rx_native_phy_ref.enable_ports_rx_manual_cdr_mode)\""                                                                  ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.rx_set_locktoref/rx_native_phy_ref.rx_set_locktoref"                         "## EXPRESSION \"(rx_native_phy_ref.enable_ports_rx_manual_cdr_mode)\""                                                                  ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
      \
    { "data_checker_ref.is_data_locked/protocol_tester_ref.verifier_lock"                               1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "data_checker_ref.error_flag/protocol_tester_ref.verifier_error"                                  1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
      \
    { "reset_controller_ref.tx_ready/protocol_tester_ref.tx_ready"                                      1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "reset_controller_ref.rx_ready/protocol_tester_ref.rx_ready"                                      1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
      \
    { "protocol_tester_ref.prbs_gen_start/data_generator_ref.enable"                                    1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_check_start/data_checker_ref.enable"                                    1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_gen_insert_error/data_generator_ref.insert_error"                       1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_gen_reset/data_generator_ref.reset"                                     1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_check_reset/data_checker_ref.reset"                                     1                                                                                                                                        ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "tx_native_phy_ref.tx_dll_lock/tx_native_phy_ref.tx_fifo_wr_en"                                   "## EXPRESSION \"(tx_native_phy_ref.tx_fifo_mode==Basic && tx_native_phy_ref.enable_simple_interface)\""                                 ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.prbs_check_start/rx_native_phy_ref.rx_fifo_rd_en"                            "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_con::rx_fifo_rd_en_callback"   ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    \
    { "protocol_tester_ref.tx_enh_bitslip/tx_native_phy_ref.tx_enh_bitslip"                             "## EXPRESSION \"(tx_native_phy_ref.enable_port_tx_enh_bitslip)\""                                                                       ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.tx_std_bitslipboundarysel/tx_native_phy_ref.tx_std_bitslipboundarysel"       "## EXPRESSION \"(tx_native_phy_ref.std_tx_bitslip_enable)\""                                                                            ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.ext_data_pattern/data_generator_ref.ext_data_pattern"                        "## EXPRESSION \"(tx_native_phy_ref.enable_port_tx_enh_bitslip || tx_native_phy_ref.std_tx_bitslip_enable)\""                            ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
    { "protocol_tester_ref.ext_data_pattern/data_checker_ref.ext_data_pattern"                          "## EXPRESSION \"(tx_native_phy_ref.enable_port_tx_enh_bitslip || tx_native_phy_ref.std_tx_bitslip_enable)\""                            ::altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix       }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${connections}
}

proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_con::rx_fifo_rd_en_callback { } {
  set fifo_mode [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.rx_fifo_mode)"  VALUE ]
  if {${fifo_mode}=="Phase compensation-Basic"} {
    return 1
  }
  return 0
}
