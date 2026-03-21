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


package ifneeded dx_altera_xcvr_native_a10::design_example_rules::main_rule                                                 18.1 [list source [file join $dir design_example_rules                           main_rule.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs                                   18.1 [list source [file join $dir design_example_rules/rule_basic_enhanced_pcs   rule_basic_enhanced_pcs.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_duplex                            18.1 [list source [file join $dir design_example_rules/rule_basic_enhanced_pcs   rule_basic_enhanced_pcs_duplex.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_tx                                18.1 [list source [file join $dir design_example_rules/rule_basic_enhanced_pcs   rule_basic_enhanced_pcs_tx.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_rx                                18.1 [list source [file join $dir design_example_rules/rule_basic_enhanced_pcs   rule_basic_enhanced_pcs_rx.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::basic_enhanced_pcs_shared                                 18.1 [list source [file join $dir design_example_rules/rule_basic_enhanced_pcs   basic_enhanced_pcs_shared.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::rule_basic_standard_pcs                                   18.1 [list source [file join $dir design_example_rules/rule_basic_standard_pcs   rule_basic_standard_pcs.tcl]]

package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_par                           18.1 [list source [file join $dir design_example_rules/common_rules              rule_rst_ctrl_par.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_atx_pll_par                            18.1 [list source [file join $dir design_example_rules/common_rules              rule_atx_pll_par.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_cdr_pll_par                            18.1 [list source [file join $dir design_example_rules/common_rules              rule_cdr_pll_par.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_par                     18.1 [list source [file join $dir design_example_rules/common_rules              rule_data_gen_check_par.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_reset_sync_par                         18.1 [list source [file join $dir design_example_rules/common_rules              rule_reset_sync_par.tcl]]

package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_freq_check_pnc                         18.1 [list source [file join $dir design_example_rules/common_rules              rule_freq_check_pnc.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_basic_prot_tester_pnc                  18.1 [list source [file join $dir design_example_rules/common_rules              rule_basic_prot_tester_pnc.tcl]]

package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_data_gen_check_con                     18.1 [list source [file join $dir design_example_rules/common_rules              rule_data_gen_check_con.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_native_and_pll_con                     18.1 [list source [file join $dir design_example_rules/common_rules              rule_native_and_pll_con.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con                18.1 [list source [file join $dir design_example_rules/common_rules              rule_rst_ctrl_and_native_con.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con                   18.1 [list source [file join $dir design_example_rules/common_rules              rule_rst_ctrl_and_pll_con.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::rule_parl_clk_dist_con                      18.1 [list source [file join $dir design_example_rules/common_rules              rule_parl_clk_dist_con.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks   18.1 [list source [file join $dir design_example_rules/common_rules              native_phy_connection_expansion_callbacks.tcl]]

package ifneeded dx_altera_xcvr_native_a10::design_example_rules::main_tb_rule                                              18.1 [list source [file join $dir design_example_rules                           main_tb_rule.tcl]]
package ifneeded dx_altera_xcvr_native_a10::design_example_rules::rule_basic_enhanced_pcs_tb                                18.1 [list source [file join $dir design_example_rules/rule_basic_enhanced_pcs   rule_basic_enhanced_pcs_tb.tcl]]
