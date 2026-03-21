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

set RX_CORE_CLK [get_clocks *|phy*|*rxp|*rx_pll*rx_core_clk_kr4]
set TX_CORE_CLK [get_clocks *|phy*|*txp|*tx_pll*tx_core_clk]

create_clock -name {clk_status} -period 10.0    -waveform { 0.000 5.000 } [get_ports {clk_status}]
create_clock -name {reconfig_clk} -period 10.0  -waveform { 0.000 5.000 } [get_ports {reconfig_clk}]

set_clock_groups -exclusive -group $TX_CORE_CLK -group $RX_CORE_CLK -group clk_status -group reconfig_clk
