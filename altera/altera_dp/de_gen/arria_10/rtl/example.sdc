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
#
#
# Bitec DisplayPort
# 
#
# All rights reserved. Property of Bitec.
# Restricted rights to use, duplicate or disclose this code are
# granted through contract.
# 
# (C) Copyright Bitec 2010,2011,2012,2013,2014
#     All rights reserved
#
# *********************************************************************
# Author         : $Author: marco $ @ bitec-dsp.com
# Department     : 
# Date           : $Date: 2015-02-17 17:18:05 +0100 (Tue, 17 Feb 2015) $
# Revision       : $Revision: 1584 $
# URL            : $URL: svn://10.9.0.1/dp/trunk/examples/a5_tx_cts/example.sdc $
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
create_clock -name {clk100} -period "100MHz" {refclk1_p}
create_clock -name {clk135} -period "135MHz" {fmc*_gbtclk_m2c_p[0]}

# Create generated clocks
create_generated_clock -name rx_clk_cal -source {rx_phy_top*|clk_cal|clk} -divide_by 2 {rx_phy_top*|clk_cal|q}
create_generated_clock -name tx_clk_cal -source {tx_phy_top*|clk_cal|clk} -divide_by 2 {tx_phy_top*|clk_cal|q}

# Get the clocks from the different PLLs
derive_pll_clocks

# False Paths
#set_clock_groups -asynchronous \
#-group {clk100} \
#-group {rx_phy_top*|clk_cal} \
#-group {tx_phy_top*|clk_cal} \
#-group [get_clocks {rx_phy_top*|dp_rx_video_pll_i|*|outclk0}] \
#-group [get_clocks {rx_phy_top*|dp_rx_video_pll_i|*|outclk1}] \
#-group [get_clocks {rx_phy_top*|dp_rx_video_pll_i|*|outclk2}] \
#-group [get_clocks {tx_phy_top*|dp_tx_video_pll_i|*|outclk0}] \
#-group [get_clocks {tx_phy_top*|dp_tx_video_pll_i|*|outclk1}] \
#-group [get_clocks {tx_phy_top*|dp_tx_video_pll_i|*|outclk2}] \
#-group [get_clocks {dp_clkrec_video_pll_i|*|outclk0}] \
#-group [get_clocks {dp_clkrec_video_pll_i|*|outclk1}] \
#-group [get_clocks {dp_clkrec_video_pll_i|*|outclk2}]

## I2C 
create_clock -name {rx_i2c_clk} -period "400Khz" [get_ports {fmc*_la_tx_n_0}]
set_input_delay -clock [get_clocks rx_i2c_clk] 100.000 [get_ports fmc*_la_tx_p_0]
set_output_delay -clock [get_clocks rx_i2c_clk] 100 [get_ports fmc*_la_tx_p_0]
set_false_path -from [get_clocks clk100] -to [get_ports fmc*_la_tx_p_0]
set_false_path -from {get_ports fmc*_la_tx_p_0} -to {get_clocks clk100}
set_false_path -from {get_ports fmc*_la_tx_n_0} -to {get_clocks clk100}
set_false_path -to [get_ports fmc*_la_tx_p_1]

#Setting LED outputs as false path, since no timing requirement
set_false_path -from * -to [get_ports user_led_*[*]]

#These are part of the 1Mbps AUX interface. Using a clk freq of 2MHz, period is 500 ns.Can be set as asynchronous path. Same for rx_hpd
# TX Aux Out and TX Aux OE
set_false_path -to [get_ports fmc*_la_rx_p_10]
set_false_path -to [get_ports fmc*_la_rx_n_10]
# RX Aux Out and RX Aux OE
set_false_path -to [get_ports fmc*_la_rx_n_6]
set_false_path -to [get_ports fmc*_la_tx_p_9]
# RX HPD
set_false_path -to [get_ports fmc*_la_rx_p_6]

#Setting PB, Reset and RX Power/Cable Detect input as false path, since no timing requirement
set_false_path -from [get_ports user_pb[0]] -to *
set_false_path -from [get_ports cpu_resetn] -to *
set_false_path -from [get_ports fmc*_la_rx_n_8] -to *
set_false_path -from [get_ports fmc*_la_tx_p_10] -to *

# Constraining JTAG interface
# TCK port
create_clock -name altera_reserved_tck -period 100 [get_ports altera_reserved_tck]
# cut all paths to and from tck
set_clock_groups -exclusive -group [get_clocks altera_reserved_tck]
# constrain the TDI port
set_input_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdi]
# constrain the TMS port
set_input_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tms]
# constrain the TDO port
set_output_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdo]
if { [get_collection_size [get_ports {altera_reserved_ntrst}]] > 0 } {
       set_false_path -from [get_ports {altera_reserved_ntrst}]
}
