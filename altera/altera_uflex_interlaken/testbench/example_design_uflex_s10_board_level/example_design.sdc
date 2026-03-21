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
#create_clock -name rx_usr_clk -period 3.3 [get_ports {rx_usr_clk}]
#create_clock -name tx_usr_clk -period 3.3 [get_ports {tx_usr_clk}]
#create_clock -name mm_clk -period 10.0 [get_ports mm_clk]

#defaut is 30 MHz
#set period_tck 20
#create_clock -name {altera_reserved_tck} -period $period_tck [get_ports {altera_reserved_tck}]

create_generated_clock -name usr_clk -source [get_pins {test_env|test_infra|sys_pll|outclk_wire[1]~CLKENA0|inclk}] \
				             [get_pins {test_env|test_infra|sys_pll|outclk_wire[1]~CLKENA0|outclk}]
																					 
create_generated_clock -name mm_clk -source [get_pins {test_env|test_infra|sys_pll|outclk_wire[0]~CLKENA0|inclk}] \
                                                [get_pins {test_env|test_infra|sys_pll|outclk_wire[0]~CLKENA0|outclk}]
											
set_clock_groups -asynchronous -group  {*g_xcvr_native_insts*rx_pma_clk} -group  {*test_infra|sys_pll|outclk[1]}
set_clock_groups -asynchronous -group  {*g_xcvr_native_insts*tx_pma_clk} -group  {*test_infra|sys_pll|outclk[1]}
set_clock_groups -asynchronous -group  {clk50} -group  {*test_infra|sys_pll|outclk[1]}

#For signalTap
set_clock_groups -asynchronous -group  {*g_xcvr_native_insts*rx_pma_clk} -group  {usr_clk}

set_clock_groups -asynchronous -group  [get_clocks {usr_clk}] -to [get_clocks {*test_env*dut*ilk_100g_inst*g_xcvr_native*tx_pma_clk}]

set_clock_groups -asynchronous -group  {mm_clk} -group  {usr_clk}
set_clock_groups -asynchronous -group  {clk50} -group   {usr_clk}

set_false_path -from [get_clocks {~ALTERA_CLKUSR~}] -to   [get_clocks {test_env|test_dut|dut|ilk_core_*|np_inst|np_inst|g_xcvr_native_insts[*]|tx_pma_clk}]
set_false_path -to   [get_clocks {~ALTERA_CLKUSR~}] -from [get_clocks {test_env|test_dut|dut|ilk_core_*|np_inst|np_inst|g_xcvr_native_insts[*]|tx_pma_clk}]
