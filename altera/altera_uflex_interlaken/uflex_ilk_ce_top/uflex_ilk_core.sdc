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
create_clock -name rx_clk -period 2.5  [get_ports {rx_clk}]
create_clock -name tx_clk -period 2.5  [get_ports {tx_clk}]
create_clock -name mm_clk -period 10.0 [get_ports mm_clk]


###############################
#Set False Path
###############################

#set_false_path -from [get_clocks {tx_clk}] -to [get_clocks {*g_xcvr_native_insts*tx_pma_clk}]
#set_false_path -from [get_clocks {*g_xcvr_native_insts*tx_pma_clk}] -to [get_clocks {tx_clk}]
#set_false_path -from [get_clocks {*g_xcvr_native_insts*rx_pma_clk}] -to [get_clocks {mm_clk}]
#set_false_path -from [get_clocks {*g_xcvr_native_insts*tx_pma_clk}] -to [get_clocks {mm_clk}]
#set_false_path -from [get_clocks {mm_clk}] -to  [get_clocks {*g_xcvr_native_insts*tx_pma_clk}] 
#set_false_path -from [get_clocks {*g_xcvr_native_insts*rx_pma_clk}] -to [get_clocks {rx_clk}]

set_clock_groups -logically_exclusive -group {tx_clk} -group {*g_xcvr_native_insts*tx_pma_clk}
set_clock_groups -logically_exclusive -group {rx_clk} -group {*g_xcvr_native_insts*rx_pma_clk}
set_clock_groups -logically_exclusive -group {mm_clk} -group {*g_xcvr_native_insts*tx_pma_clk}
set_clock_groups -logically_exclusive -group {mm_clk} -group {*g_xcvr_native_insts*rx_pma_clk}


