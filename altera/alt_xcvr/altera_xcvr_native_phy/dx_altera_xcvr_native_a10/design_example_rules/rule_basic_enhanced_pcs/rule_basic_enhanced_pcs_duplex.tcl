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


package provide dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_duplex 18.1

package require alt_xcvr::de_tcl::de_api

package require dx_altera_xcvr_native_a10::design_example_rules::basic_enhanced_pcs_shared

package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_par
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_atx_pll_par
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_cdr_pll_par
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_par
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_reset_sync_par

package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc

package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_con
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con
package require dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_parl_clk_dist_con

namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_duplex:: {
  namespace export declare_rule  
}

proc ::dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_duplex::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  
  set instances {\
    { NAME                            KIND                                                                                                                                                           ENABLED   }\
    { "reset_sync_inst"               "alt_xcvr_reset_sync"                                                                                                                                          1         }\
    { "rst_ctr_inst"                  "altera_xcvr_reset_control"                                                                                                                                    1         }\
    { "pll_inst"                      "## MAPS_FROM native_phy_ref.tx_pll_type MAPPING {(ATX:altera_xcvr_atx_pll_a10) (fPLL:altera_xcvr_fpll_a10) (CMU:altera_xcvr_cdr_pll_a10)} MAP_DEFAULT NOVAL"  1         }\
    { "data_generator_inst"           "alt_xcvr_data_pattern_gen"                                                                                                                                    1         }\
    { "data_checker_inst"             "alt_xcvr_data_pattern_check"                                                                                                                                  1         }\
    { "protocol_tester_inst"          "alt_xcvr_basic_custom_tester"                                                                                                                                 1         }\
    { "freq_check_txclkout_inst"      "alt_xcvr_freq_checker"                                                                                                                                        1         }\
    { "freq_check_rxclkout_inst"      "alt_xcvr_freq_checker"                                                                                                                                        1         }\
    { "freq_check_txdivclkout_inst"   "alt_xcvr_freq_checker"                                                                                                                                        "## EXPRESSION \" native_phy_ref.enable_port_tx_pma_div_clkout \"  "}\
    { "freq_check_rxdivclkout_inst"   "alt_xcvr_freq_checker"                                                                                                                                        "## EXPRESSION \" native_phy_ref.enable_port_rx_pma_div_clkout \"  "}\
  } 
  #\TODO alt_xcvr_basic_custom_tester is temporary
  
  ::alt_xcvr::de_tcl::de_api::de_declareInstances  ${instances}   

  #\TODO NAME must be unique
  set subRules {\
    { NAME                                 RULE_TYPE                                                                                      INSTANCE_PAIRS                                                                                                                                                      ENABLED }\
    { rst_ctr_inst_par_rule                ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_par             {native_phy_ref native_phy_ref     reset_controller_ref "rst_ctr_inst"}                                                                                             1       }\
    { atx_pll_inst_par_rule                ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_atx_pll_par              {native_phy_ref native_phy_ref     pll_ref "pll_inst"}                                                                                                              "## MAPS_FROM native_phy_ref.tx_pll_type MAPPING {(ATX:1)} MAP_DEFAULT 0" }\
    { cdr_pll_inst_par_rule                ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_cdr_pll_par              {native_phy_ref native_phy_ref     pll_ref "pll_inst"}                                                                                                              "## MAPS_FROM native_phy_ref.tx_pll_type MAPPING {(CMU:1)} MAP_DEFAULT 0" }\
    { data_generator_inst_par_rule         ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_par       {native_phy_ref native_phy_ref     data_generator_ref "data_generator_inst"     data_checker_ref "data_checker_inst"}                                               1       }\
    { reset_sync_par_rule                  ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_reset_sync_par           {reset_sync_ref reset_sync_inst}                                                                                                                                    1       }\
     \
    { data_gen_check_con_rule              ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_con       {tx_native_phy_ref native_phy_ref  rx_native_phy_ref "native_phy_ref"           data_generator_ref "data_generator_inst"   data_checker_ref "data_checker_inst"}    1       }\
    { native_pll_con_rule                  ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con       {native_phy_ref native_phy_ref     pll_ref "pll_inst"}                                                                                                              1       }\
    { rst_ctr_native_con_rule              ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con  {native_phy_ref native_phy_ref     reset_controller_ref "rst_ctr_inst"}                                                                                             1       }\
    { rst_cnt_pll_con_rule                 ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con     {native_phy_ref native_phy_ref     pll_ref "pll_inst"                           reset_controller_ref "rst_ctr_inst"}                                                1       }\
      \
    { basic_prot_tester_pnc_rule           ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc    {native_phy_ref native_phy_ref     tx_native_phy_ref "native_phy_ref"           rx_native_phy_ref "native_phy_ref"                                      protocol_tester_ref "protocol_tester_inst"                          data_generator_ref "data_generator_inst"                        data_checker_ref "data_checker_inst"                    tx_reset_controller_ref "rst_ctr_inst"        rx_reset_controller_ref "rst_ctr_inst"}       1       }\
    { freq_check_txclkout_inst_pnc_rule    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc           {native_phy_ref native_phy_ref     freq_check_ref "freq_check_txclkout_inst"    start_freq_check_source_ref "protocol_tester_inst.start_freq_check_tx"  freq_measured_target_ref "protocol_tester_inst.txfreq_measured"     clkout_freq_target_ref "protocol_tester_inst.txclkout_freq"     clkout_source_ref "native_phy_ref.tx_clkout"}                                                                                                       "## MAPS_FROM native_phy_ref.duplex_mode MAPPING {(rx:0)} MAP_DEFAULT 1" }\
    { freq_check_rxclkout_inst_pnc_rule    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc           {native_phy_ref native_phy_ref     freq_check_ref "freq_check_rxclkout_inst"    start_freq_check_source_ref "protocol_tester_inst.start_freq_check_rx"  freq_measured_target_ref "protocol_tester_inst.rxfreq_measured"     clkout_freq_target_ref "protocol_tester_inst.rxclkout_freq"     clkout_source_ref "native_phy_ref.rx_clkout"}                                                                                                       "## MAPS_FROM native_phy_ref.duplex_mode MAPPING {(tx:0)} MAP_DEFAULT 1" }\
    { freq_check_txdivclk_inst_pnc_rule    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc           {native_phy_ref native_phy_ref     freq_check_ref "freq_check_txdivclkout_inst" start_freq_check_source_ref "protocol_tester_inst.start_freq_check_tx"  freq_measured_target_ref "protocol_tester_inst.txdivfreq_measured"  clkout_freq_target_ref "protocol_tester_inst.txdivclkout_freq"  clkout_source_ref "native_phy_ref.tx_pma_div_clkout"}                                                                                               "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::basic_enhanced_pcs_shared::IsEnableTxdivclkInstance" }\
    { freq_check_rxdivclk_inst_pnc_rule    ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc           {native_phy_ref native_phy_ref     freq_check_ref "freq_check_rxdivclkout_inst" start_freq_check_source_ref "protocol_tester_inst.start_freq_check_rx"  freq_measured_target_ref "protocol_tester_inst.rxdivfreq_measured"  clkout_freq_target_ref "protocol_tester_inst.rxdivclkout_freq"  clkout_source_ref "native_phy_ref.rx_pma_div_clkout"}                                                                                               "## RESOLVE_CALLBACK ::dx_altera_xcvr_native_a10::design_example_rules::basic_enhanced_pcs_shared::IsEnableRxdivclkInstance" }\
    { parl_clk_dist_con_rule               ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_parl_clk_dist_con        {native_phy_ref native_phy_ref     data_generator_ref "data_generator_inst"     data_checker_ref "data_checker_inst"  protocol_tester_ref  "protocol_tester_inst"}  1 }\
  }

  ::alt_xcvr::de_tcl::de_api::de_declareRules       ${subRules}

  #\TODO what to do about en_serial_loopback

  set parameters {\
    { NAME                                           VALUE                                                                                                                                             ENABLED }\
    { data_generator_inst.DATA_WIDTH                 "## MAPS_FROM native_phy_ref.enh_pld_pcs_width MAP_DEFAULT NOVAL"                                                                                 1       }\
    { data_generator_inst.STATIC_PATTERN_EN          1                                                                                                                                                 1       }\
    { data_generator_inst.STATIC_PATTERN             5                                                                                                                                                 1       }\
    { data_generator_inst.PRBS_SEED_VAL              "## MAPS_FROM native_phy_ref.enh_pld_pcs_width MAPPING {(66:3ED0A93E63A8859E0) (64:123456789abcdef) (40:123456789) (32:1234567)} MAP_DEFAULT 1"   1       }\
      \
    { data_checker_inst.DATA_WIDTH                   "## MAPS_FROM native_phy_ref.enh_pld_pcs_width  MAP_DEFAULT NOVAL"                                                                                1       }\
    { data_checker_inst.STATIC_PATTERN_EN            1                                                                                                                                                 1       }\
    { data_checker_inst.STATIC_PATTERN               5                                                                                                                                                 1       }\
  } 

  ::alt_xcvr::de_tcl::de_api::de_declareParameters  ${parameters}
 
  set reset_distribution {\
    { NAME                                                            SPLIT_CONNECTION   ADAPT_CONNECTION   ENABLED   }\
    { "reset_sync_inst.reset/rst_ctr_inst.reset"                      0                  0                  1         }\
    { "reset_sync_inst.reset/protocol_tester_inst.reset"              0                  0                  1         }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareConnections  ${reset_distribution}
}

