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


set_time_format -unit ns -decimal_places 3

create_clock -name {rx_i2c_clk} -period "400Khz" [get_ports {fmcb_la_tx_p_10}]
create_clock -name {tx_i2c_clk} -period "400Khz" [get_ports {fmcb_la_rx_p_10}]
create_clock -name {ti_i2c_clk} -period "400Khz" [get_ports {fmcb_la_rx_n_9}]
create_clock -name {clk_100} -period "100Mhz" [get_ports {clk_fpga_b3_p}]

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty


## *********************************************************************************
## Transceiver Digitalreset
## *********************************************************************************
# SDC constraint for TX Digital Reset for Bonded Clocks are used
# If your design cannot meet this max skew constraint, please use the transceiver 
# channels away from the HIP block
set_max_skew -exclude to_clock \
              -from [get_registers *hdmi_tx_top*altera_xcvr_reset_control*tx_digitalreset*r_reset] \
              -to [get_pins -compatibility_mode *hdmi_tx_top*twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_*_tx_pld_rst_n] 1.666ns


## *********************************************************************************
## I2C 
## *********************************************************************************
set_input_delay -clock [get_clocks rx_i2c_clk] 100.000 [get_ports fmcb_la_rx_n_8]
set_input_delay -clock [get_clocks tx_i2c_clk] 100.000 [get_ports fmcb_la_tx_n_12]
set_input_delay -clock [get_clocks ti_i2c_clk] 100.000 [get_ports fmcb_la_tx_p_11]
set_output_delay -clock [get_clocks rx_i2c_clk] 100 [get_ports fmcb_la_rx_n_8]
set_output_delay -clock [get_clocks tx_i2c_clk] 100 [get_ports fmcb_la_tx_n_12]
set_output_delay -clock [get_clocks ti_i2c_clk] 100 [get_ports fmcb_la_tx_p_11]

## *********************************************************************************
## False paths 
## *********************************************************************************
# I2C serial clocks are asynchronous to other domains
#set_clock_groups -exclusive -group [get_clocks u_pll_i2c|iopll_0|outclk0]
set_clock_groups -exclusive -group [get_clocks rx_i2c_clk]
set_clock_groups -exclusive -group [get_clocks tx_i2c_clk]
set_clock_groups -exclusive -group [get_clocks ti_i2c_clk]
#set_false_path -from [get_clocks clk_100] -to [get_ports fmcb_la_rx_p_10]

# Reset to fpga is asynchronous
set_false_path -from [get_ports {cpu_resetn}]

# Setting LED outputs as false path, since no timing requirement
set_false_path -from * -to [get_ports user_led*]

# Asynchronous. No timing requirement to the push buttons and dip switches.
set_false_path -from {get_ports {user_pb[*]}}
#set_false_path -from {get_ports {user_dipsw[*]}}

# No timing requirement to the hpd pins and +5V pin.
set_false_path -to {get_ports fmcb_la_rx_p_8}
set_false_path -from {get_ports fmcb_la_tx_p_12}
set_false_path -from {get_ports fmcb_la_rx_p_9}
