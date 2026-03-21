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


# for 125MHz AVMM clock
set period_mgmt  8

# for 100MHz AVMM clock
# set period_mgmt  10

create_clock -name {clk100}    -period $period_mgmt [get_ports {clk100}]

derive_pll_clocks -create_base_clock 
derive_clock_uncertainty

set_false_path  -from [get_keepers {cpu_resetn}]
set_false_path -from [get_clocks {clk100}] -to [get_clocks {clk_ref_r}]
  
set RX_CORE_CLK [get_clocks *|phy*|*rxp|*rx_pll*|*|outclk*[0]]
set TX_CORE_CLK [get_clocks *|phy*|*txp|*tx_pll*|*|outclk*[0]]

set_clock_groups -asynchronous -group $TX_CORE_CLK -group $RX_CORE_CLK -group clk100
