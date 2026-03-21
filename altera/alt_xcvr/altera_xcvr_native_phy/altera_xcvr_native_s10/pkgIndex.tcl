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


package ifneeded altera_xcvr_native_s10::parameters::data 18.1 [list source [file join $dir tcl parameter_data.tcl]]
package ifneeded altera_xcvr_native_s10::interfaces::data 18.1 [list source [file join $dir tcl interface_data.tcl]]
package ifneeded altera_xcvr_native_s10::fileset 18.1 [list source [file join $dir tcl fileset.tcl]]
package ifneeded altera_xcvr_native_s10::module 18.1 [list source [file join $dir tcl module.tcl]]
package ifneeded altera_xcvr_native_s10::parameters 18.1 [list source [file join $dir tcl parameters.tcl]]
package ifneeded altera_xcvr_native_s10::parameters::ct1_analog 18.1 [list source [file join $dir tcl parameters_ct1_analog.tcl]]
package ifneeded altera_xcvr_native_s10::interfaces 18.1 [list source [file join $dir tcl interfaces.tcl]]
package ifneeded altera_xcvr_native_s10::design_example 18.1 [list source [file join $dir tcl design_example.tcl]]

package ifneeded altera_xcvr_native_s10::design_example_rules::main_rule                                                 18.1 [list source [file join $dir design_example_rules                                 main_rule.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs                                   18.1 [list source [file join $dir design_example_rules/rule_basic_standard_pcs         rule_basic_standard_pcs.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::rule_basic_enhanced_pcs                                   18.1 [list source [file join $dir design_example_rules/rule_basic_enhanced_pcs         rule_basic_enhanced_pcs.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::rule_pcs_direct                                           18.1 [list source [file join $dir design_example_rules/rule_pcs_direct                 rule_pcs_direct.tcl]]

package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_par                  18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_basic_prot_tester_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_par                           18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_rst_ctrl_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_mcgb_par                               18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_mcgb_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_atx_pll_par                            18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_atx_pll_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_fpll_par                               18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_fpll_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_cdr_pll_par                            18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_cdr_pll_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_par                     18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_data_gen_check_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_rx_bitslip_gen_par                     18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_rx_bitslip_gen_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_bus_split_concat_par                   18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_bus_split_concat_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_freq_check_par                         18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_freq_check_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_reset_sync_par                         18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_reset_sync_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_x1x2_if_adapter_par                    18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_x1x2_if_adapter_par.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_par              18.1 [list source [file join $dir design_example_rules/common_rules/parameter_rules    rule_bitrev_byterev_polinv_par.tcl]]

package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_dist_con                           18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_rst_dist_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_basic_prot_tester_con                  18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_basic_prot_tester_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_parl_clk_dist_con                      18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_parl_clk_dist_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_data_gen_check_con                     18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_data_gen_check_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_native_and_pll_con                     18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_native_and_pll_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_native_con                18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_rst_ctrl_and_native_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_rst_ctrl_and_pll_con                   18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_rst_ctrl_and_pll_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_freq_check_con                         18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_freq_check_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_x1x2_if_adapter_con                    18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_x1x2_if_adapter_con.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_bitrev_byterev_polinv_con              18.1 [list source [file join $dir design_example_rules/common_rules/connection_rules   rule_bitrev_byterev_polinv_con.tcl]]

package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks   18.1 [list source [file join $dir design_example_rules/common_rules                    native_phy_connection_expansion_callbacks.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::common_rules::rule_export_interfaces                      18.1 [list source [file join $dir design_example_rules/common_rules                    rule_export_interfaces.tcl]]

package ifneeded altera_xcvr_native_s10::design_example_rules::main_tb_rule                                              18.1 [list source [file join $dir design_example_rules                                 main_tb_rule.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::rule_basic_standard_pcs_tb                                18.1 [list source [file join $dir design_example_rules/rule_basic_standard_pcs         rule_basic_standard_pcs_tb.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::rule_basic_enhanced_pcs_tb                                18.1 [list source [file join $dir design_example_rules/rule_basic_enhanced_pcs         rule_basic_enhanced_pcs_tb.tcl]]
package ifneeded altera_xcvr_native_s10::design_example_rules::rule_pcs_direct_tb                                        18.1 [list source [file join $dir design_example_rules/rule_pcs_direct                 rule_pcs_direct_tb.tcl]]
