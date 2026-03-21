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


derive_pll_clocks -create_base_clock
derive_clock_uncertainty
create_clock -name clk_50 -period 20.0 -waveform {0.0 10.0} [get_ports clk_50]
create_clock -name {altera_reserved_tck} -period 20.0 -waveform {0.0 10.0} [get_ports {altera_reserved_tck}]

# Set clock groups instead of setting false paths
set_clock_groups -logically_exclusive -group {clk_50} -group {hssi_refclk}
set_clock_groups -logically_exclusive -group {clk_50} -group {hmcc_pll|altera_atx_pll_ip|tx_bonding_clocks[0]}
set_clock_groups -logically_exclusive -group {hssi_refclk} -group {hmcc_pll|altera_atx_pll_ip|tx_bonding_clocks[0]}

# false path when crossing clock domains through synchronizer.
# I2C module is currently unused.
# set_false_path -from {altera_hmcc_ip:hmcc|altera_hmcc:altera_hmcc_ed_inst|altera_hmcc_dcore:dcore|altera_hmcc_init_sm:init|load_registers_q} -to {i2c_control:i2c_control|load_registers_sync[0]}  

# false paths from asynchronous inputs
set_false_path -from [get_ports {push_button}]

# false paths to asynchronous outputs
set_false_path -to [get_ports {hmc_ctrl_p_rst_n}]
set_false_path -to [get_ports {heart_beat_n}]
set_false_path -to [get_ports {link_init_complete_n}]
set_false_path -to [get_ports {test_passed_n}]
set_false_path -to [get_ports {test_failed_n}]
