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


derive_pll_clocks
derive_clock_uncertainty

create_clock -period 6.4 -name {ref_clk} [get_ports ref_clk]
create_clock -period 20.0 -name {clk_50Mhz} [get_ports clk_50Mhz]

# Cut timing between clocks of MM interfaces and reference clock
set_clock_groups -asynchronous -group {ref_clk} -group {clk_50Mhz}

# Cut timing for AV/CV
set_clock_groups -asynchronous -group {clk_50Mhz} -group {*inst_av_hssi_8g_tx_pcs|wys|txpmalocalclk} -group {*inst_av_hssi_8g_rx_pcs|wys|rcvdclkpma}
