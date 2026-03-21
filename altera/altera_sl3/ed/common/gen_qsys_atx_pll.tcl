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


package require -exact qsys 14.1
create_system
set_project_property DEVICE_FAMILY
add_instance altera_atx_pll_a10 altera_xcvr_atx_pll_a10
set_instance_property  altera_atx_pll_a10 AUTO_EXPORT 1
set_instance_parameter_value altera_atx_pll_a10 rcfg_debug 0
set_instance_parameter_value altera_atx_pll_a10 enable_pll_reconfig 0
set_instance_parameter_value altera_atx_pll_a10 rcfg_file_prefix "altera_xcvr_atx_pll_a10"
set_instance_parameter_value altera_atx_pll_a10 generate_docs 0
set_instance_parameter_value altera_atx_pll_a10 support_mode "user_mode"
set_instance_parameter_value altera_atx_pll_a10 message_level "error"
set_instance_parameter_value altera_atx_pll_a10 prot_mode "Basic"
set_instance_parameter_value altera_atx_pll_a10 bw_sel "medium"
set_instance_parameter_value altera_atx_pll_a10 refclk_cnt 1
set_instance_parameter_value altera_atx_pll_a10 refclk_index 0
set_instance_parameter_value altera_atx_pll_a10 silicon_rev "false"
set_instance_parameter_value altera_atx_pll_a10 primary_pll_buffer "GX clock output buffer"
set_instance_parameter_value altera_atx_pll_a10 enable_8G_path 1
set_instance_parameter_value altera_atx_pll_a10 enable_16G_path 0
set_instance_parameter_value altera_atx_pll_a10 enable_pcie_clk 0
set_instance_parameter_value altera_atx_pll_a10 set_output_clock_frequency
set_instance_parameter_value altera_atx_pll_a10 set_auto_reference_clock_frequency
set_instance_parameter_value altera_atx_pll_a10 enable_mcgb 0
set_instance_parameter_value altera_atx_pll_a10 mcgb_div 1
set_instance_parameter_value altera_atx_pll_a10 enable_hfreq_clk 0
set_instance_parameter_value altera_atx_pll_a10 enable_mcgb_pcie_clksw 0
set_instance_parameter_value altera_atx_pll_a10 mcgb_aux_clkin_cnt 0
set_instance_parameter_value altera_atx_pll_a10 enable_bonding_clks 0
set_instance_parameter_value altera_atx_pll_a10 enable_fb_comp_bonding 0
set_instance_parameter_value altera_atx_pll_a10 pma_width 64

save_system altera_atx_pll_a10
