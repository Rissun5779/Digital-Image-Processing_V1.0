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


package provide altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs 18.1

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_atx_pll_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_cdr_pll_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_fpll_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_freq_check_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_reset_sync_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_rx_bitslip_gen_par
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_bus_split_concat_par

package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_dist_con
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_con
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_native_and_pll_con
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_freq_check_con
package require altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_con

namespace eval ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs:: {
  namespace export declare_rule  
}


proc ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT

  set instances {\
    { NAME                            KIND                                                                                                                                                              ENABLED                                                                     }\
    { "reset_sync_inst"               "alt_xcvr_reset_sync"                                                                                                                                             1                                                                           }\
    { "rst_ctr_inst"                  "altera_xcvr_reset_control_s10"                                                                                                                                   1                                                                           }\
    { "pll_inst"                      "## MAPS_FROM tx_native_phy_ref.tx_pll_type MAPPING {(ATX:altera_xcvr_atx_pll_s10) (fPLL:altera_xcvr_fpll_s10) (CMU:altera_xcvr_cdr_pll_s10)} MAP_DEFAULT NOVAL"  1                                                                           }\
    { "data_generator_inst"           "alt_xcvr_data_pattern_gen"                                                                                                                                       1                                                                           }\
    { "data_checker_inst"             "alt_xcvr_data_pattern_check"                                                                                                                                     1                                                                           }\
    { "protocol_tester_inst"          "alt_xcvr_basic_custom_tester"                                                                                                                                    1                                                                           }\
    { "freq_check_txclkout_inst"      "alt_xcvr_freq_checker"                                                                                                                                           1                                                                           }\
    { "freq_check_rxclkout_inst"      "alt_xcvr_freq_checker"                                                                                                                                           1                                                                           }\
    { "rx_bitslip_gen_inst"           "alt_xcvr_bit_slip"                                                                                                                                               "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs::enable_rx_bitslip_callback"          }\
    { "bitrev_byterev_polinv_inst"    "alt_xcvr_bitrev_byterev_polinv"                                                                                                                                  "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs::enable_br_br_pi_callback"         }\
    { "bus_split_inst"                "alt_xcvr_12_bus_split"                                                                                                                                           "## EXPRESSION \"(tx_native_phy_ref.std_tx_8b10b_enable)\""                 }\
    { "bus_concat_inst"               "alt_xcvr_21_bus_concat"                                                                                                                                          "## EXPRESSION \"(rx_native_phy_ref.std_rx_8b10b_enable)\""                 }\
  } 
  #\TODO alt_xcvr_basic_custom_tester is temporary
  
  ::alt_xcvr::de_tcl::de_api::de_declareInstances  ${instances}   
 
  #\TODO NAME must be unique
  # [ISARI: GUIDELINE USE native_phy_ref for common things, otherwise use tx_native_phy_ref or rx_native_phy_ref]
  set subRules {\
    { NAME                                 RULE_TYPE                                                                                    ENABLED                                                                                                                                          INSTANCE_PAIRS          }\
    { rst_ctr_inst_par_rule                ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_par              1                                                                                                                                                {native_phy_ref "native_phy_ref"        reset_controller_ref "rst_ctr_inst"} }\
    { atx_pll_inst_par_rule                ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_atx_pll_par               "## EXPRESSION \"(native_phy_ref.tx_pll_type==ATX)\""                                                                                            {tx_native_phy_ref "tx_native_phy_ref"  pll_ref "pll_inst"} }\
    { cdr_pll_inst_par_rule                ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_cdr_pll_par               "## EXPRESSION \"(native_phy_ref.tx_pll_type==CMU)\""                                                                                            {tx_native_phy_ref "tx_native_phy_ref"  pll_ref "pll_inst"} }\
    { fpll_inst_par_rule                   ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_fpll_par                  "## EXPRESSION \"(native_phy_ref.tx_pll_type==fPLL)\""                                                                                           {tx_native_phy_ref "tx_native_phy_ref"  pll_ref "pll_inst"} }\
    { freq_check_txclkout_inst_par_rule    ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_freq_check_par            1                                                                                                                                                {native_phy_ref "native_phy_ref"        frequency_checker_ref "freq_check_txclkout_inst"} }\
    { freq_check_rxclkout_inst_par_rule    ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_freq_check_par            1                                                                                                                                                {native_phy_ref "native_phy_ref"        frequency_checker_ref "freq_check_rxclkout_inst"} }\
    { reset_sync_par_rule                  ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_reset_sync_par            1                                                                                                                                                {reset_sync_ref "reset_sync_inst"} }\
    { basic_prot_tester_par_rule           ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par     1                                                                                                                                                {native_phy_ref "native_phy_ref"        protocol_tester_ref "protocol_tester_inst"   tx_native_phy_ref "tx_native_phy_ref"     rx_native_phy_ref "rx_native_phy_ref"} }\
    { data_gen_check_inst_par_rule         ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par        1                                                                                                                                                {tx_native_phy_ref "tx_native_phy_ref"  rx_native_phy_ref "rx_native_phy_ref"        data_generator_ref "data_generator_inst"  data_checker_ref "data_checker_inst"} }\
    { bus_split_concat_inst_par_rule       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bus_split_concat_par      "## EXPRESSION \" ((tx_native_phy_ref.std_tx_8b10b_enable) || (rx_native_phy_ref.std_rx_8b10b_enable))\""                                        {tx_native_phy_ref     "tx_native_phy_ref"         rx_native_phy_ref           "rx_native_phy_ref"      bus_concat_ref     "bus_concat_inst"        bus_split_ref     "bus_split_inst"    data_generator_ref   "data_generator_inst"  data_checker_ref "data_checker_inst"} }\
    { rx_bitslip_gen_inst_par_rule         ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rx_bitslip_gen_par        "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs::enable_rx_bitslip_callback"                        {rx_native_phy_ref     "rx_native_phy_ref"         rx_bitslip_gen_ref          "rx_bitslip_gen_inst"    bus_concat_ref     "bus_concat_inst"        protocol_tester_ref "protocol_tester_inst"} }\
    { bitrev_byterev_polinv_par_rule       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_par "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs::enable_br_br_pi_callback"                          {native_phy_ref        "native_phy_ref"        tx_native_phy_ref      "tx_native_phy_ref"     rx_native_phy_ref       "rx_native_phy_ref"    bitrev_byterev_polinv_ref       "bitrev_byterev_polinv_inst"} }\
      \
    { rst_dist_con_rule                    ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_dist_con              1                                                                                                                                                {reset_sync_ref "reset_sync_inst"       reset_controller_ref "rst_ctr_inst"          protocol_tester_ref "protocol_tester_inst"} }\
    { basic_prot_tester_con_rule           ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_con     1                                                                                                                                                {tx_native_phy_ref "tx_native_phy_ref"  rx_native_phy_ref "rx_native_phy_ref"        data_generator_ref "data_generator_inst"  data_checker_ref "data_checker_inst"  reset_controller_ref "rst_ctr_inst"   protocol_tester_ref "protocol_tester_inst"} }\
    { data_gen_check_con_rule              ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con        1                                                                                                                                                {tx_native_phy_ref "tx_native_phy_ref"  rx_native_phy_ref "rx_native_phy_ref"        data_generator_ref "data_generator_inst"  data_checker_ref "data_checker_inst" } }\
    { native_pll_con_rule                  ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_native_and_pll_con        1                                                                                                                                                {tx_native_phy_ref "tx_native_phy_ref"  pll_ref "pll_inst"} }\
    { rst_ctr_native_con_rule              ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con   1                                                                                                                                                {tx_native_phy_ref "tx_native_phy_ref"  rx_native_phy_ref "rx_native_phy_ref"        reset_controller_ref "rst_ctr_inst"} }\
    { rst_cnt_pll_con_rule                 ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con      1                                                                                                                                                {native_phy_ref "native_phy_ref"        pll_ref "pll_inst"                           reset_controller_ref "rst_ctr_inst"} }\
    { parl_clk_dist_con_rule               ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con         1                                                                                                                                                {tx_native_phy_ref "tx_native_phy_ref"  rx_native_phy_ref "rx_native_phy_ref"        data_generator_ref "data_generator_inst"   data_checker_ref "data_checker_inst"  protocol_tester_ref "protocol_tester_inst" rx_bitslip_gen_ref "rx_bitslip_gen_inst"} }\
    { freq_check_txclkout_inst_con_rule    ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_freq_check_con            1                                                                                                                                                {frequency_checker_ref "freq_check_txclkout_inst"     source_ref_start_freq_check "protocol_tester_inst.start_freq_check_tx"    target_ref_freq_measured "protocol_tester_inst.txclkout_freq_measured"    target_ref_clkout_freq "protocol_tester_inst.txclkout_freq"       source_ref_clkout "tx_native_phy_ref.tx_clkout"} }\
    { freq_check_rxclkout_inst_con_rule    ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_freq_check_con            1                                                                                                                                                {frequency_checker_ref "freq_check_rxclkout_inst"     source_ref_start_freq_check "protocol_tester_inst.start_freq_check_rx"    target_ref_freq_measured "protocol_tester_inst.rxclkout_freq_measured"    target_ref_clkout_freq "protocol_tester_inst.rxclkout_freq"       source_ref_clkout "rx_native_phy_ref.rx_clkout"} }\
    { bitrev_byterev_polinv_con_rule       ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_con "## RESOLVE_CALLBACK ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs::enable_br_br_pi_callback"                          {tx_native_phy_ref     "tx_native_phy_ref"     rx_native_phy_ref       "rx_native_phy_ref"     bitrev_byterev_polinv_ref       "bitrev_byterev_polinv_inst"} }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareRules       ${subRules}

  #\TODO what to do about en_serial_loopback
  set bus_split_concat_parameters {\
    { NAME                                  VALUE                                                                                                               ENABLED   }\
    { bus_split_inst.DWIDTH_O1              "## EXPRESSION \"(tx_native_phy_ref.display_std_tx_pld_adapt_width)\""                                                  "## EXPRESSION \"(tx_native_phy_ref.std_tx_8b10b_enable)\""         }\
    { bus_split_inst.DWIDTH_O2              "## EXPRESSION \"(tx_native_phy_ref.tx_generator_data_width-tx_native_phy_ref.display_std_tx_pld_adapt_width)\""     "## EXPRESSION \"(tx_native_phy_ref.std_tx_8b10b_enable)\""         }\
    { bus_concat_inst.DWIDTH_I1             "## EXPRESSION \"(rx_native_phy_ref.display_std_rx_pld_adapt_width)\""                                                  "## EXPRESSION \"(rx_native_phy_ref.std_rx_8b10b_enable)\""         }\
    { bus_concat_inst.DWIDTH_I2             "## EXPRESSION \"(rx_native_phy_ref.rx_checker_data_width-rx_native_phy_ref.display_std_rx_pld_adapt_width)\""        "## EXPRESSION \"(rx_native_phy_ref.std_rx_8b10b_enable)\""         }\
  }
  ::alt_xcvr::de_tcl::de_api::de_declareParameters   ${bus_split_concat_parameters}

}

proc ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs::enable_rx_bitslip_callback { } {
  set word_aligner_mode [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.std_rx_word_aligner_mode)" VALUE]
  set en_bitslip_port [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enable_port_rx_std_bitslip)" VALUE]
  set en_patternalign_port [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.enable_port_rx_std_wa_patternalign)" VALUE]

  set enable 0
  if {($word_aligner_mode=="bitslip" && $en_bitslip_port) || ($word_aligner_mode=="manual (PLD controlled)" && $en_patternalign_port)} {
    set enable 1
  }
  return $enable
}

proc ::altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs::enable_br_br_pi_callback { } {
  set tx_polinv_en [::alt_xcvr::de_tcl::de_api::de_getData "parameter(tx_native_phy_ref.std_tx_polinv_enable)" VALUE]
  set rx_bitrev_en [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.std_rx_bitrev_enable)" VALUE]
  set rx_byterev_en [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.std_rx_byterev_enable)" VALUE]
  set rx_polinv_en [::alt_xcvr::de_tcl::de_api::de_getData "parameter(rx_native_phy_ref.std_rx_polinv_enable)" VALUE]

  set enable 0
  if { $tx_polinv_en || $rx_bitrev_en || $rx_byterev_en || $rx_polinv_en } {
    set enable 1
  }
  return $enable
}

