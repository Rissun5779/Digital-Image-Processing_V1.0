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

set period_clk50 20
create_clock -name {clk50} -period $period_clk50 [get_ports {clk50}]

set_false_path -to [get_registers {*ilk_status_sync*}]
set_false_path -to [get_registers {*ilk_pulse_stretch*}]

# clk50 vs usr_clk
set_clock_groups -logically_exclusive -group {clk50} -group {sys_pll|outclk_wire[1]}
# clk50 vs tx_pma_clk
set_clock_groups -logically_exclusive -group {clk50} -group {*g_xcvr_native_insts*tx_pma_clk}
# clk50 vs rx_pma_clk
set_clock_groups -logically_exclusive -group {clk50} -group {*g_xcvr_native_insts*rx_pma_clk}
# usr_clk vs tx_pma_clk
set_clock_groups -logically_exclusive -group {sys_pll|outclk_wire[1]} -group {*g_xcvr_native_insts*tx_pma_clk}
# usr_clk vs rx_pma_clk
set_clock_groups -logically_exclusive -group {sys_pll|outclk_wire[1]} -group {*g_xcvr_native_insts*rx_pma_clk}
# mm_clk vs tx_pma_clk 
set_clock_groups -logically_exclusive -group {sys_pll|outclk_wire[0]} -group {*g_xcvr_native_insts*tx_pma_clk}
# mm_clk vs rx_pma_clk 
set_clock_groups -logically_exclusive -group {sys_pll|outclk_wire[0]} -group {*g_xcvr_native_insts*rx_pma_clk}
# mm_clk vs usr_clk 
set_clock_groups -logically_exclusive -group {sys_pll|outclk_wire[0]} -group {sys_pll|outclk_wire[1]}
