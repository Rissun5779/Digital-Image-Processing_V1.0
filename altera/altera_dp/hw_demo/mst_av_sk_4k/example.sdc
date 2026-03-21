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


# *********************************************************************
# Description
# 
# Timing constraints for the DisplayPort Example Design 
#
# *********************************************************************

#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clocks
#**************************************************************

derive_clock_uncertainty

# Create the top-level clock pins
create_clock -name {clk100} -period "100MHz" {clk100}
create_clock -name {clk125} -period "125MHz" {refclk2_qr1_p}

# Create generated clocks
create_generated_clock -name clk_cal -source {clk_cal|clk} -divide_by 2 {clk_cal|q}

# Get the clocks from the different PLLs
derive_pll_clocks

# False Paths
set_clock_groups -asynchronous \
-group {clk100} \
-group {clk125} \
-group [get_clocks {video_pll_i|*|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] \
-group [get_clocks {video_pll_i|*|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] \
-group [get_clocks {video_pll_i|*|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] 

#Setting LED outputs as false path, since no timing requirement
set_false_path -from * -to [get_ports user_led[*]]

#These are part of the 1Mbps AUX interface. Using a clk freq of 2MHz, period is 500 ns.Can be set as asynchronous path. Same for rx_hpd
set_false_path -to [get_ports AUX_*]
set_false_path -to [get_ports RX_HPD]

#Constraining JTAG interface
#TCK port
create_clock -name altera_reserved_tck -period 100 [get_ports altera_reserved_tck]
#cut all paths to and from tck
set_clock_groups -exclusive -group [get_clocks altera_reserved_tck]
#constrain the TDI port
set_input_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdi]
#constrain the TMS port
set_input_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tms]
#constrain the TDO port
set_output_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdo]

