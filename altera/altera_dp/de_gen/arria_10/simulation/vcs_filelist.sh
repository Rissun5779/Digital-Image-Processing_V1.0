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


# Compile the additional test files
+systemverilogext+.sv
../../testbench/rx_freq_check.v
../../testbench/tx_freq_check.v
../../testbench/freq_check.v
../../testbench/vga_driver.v
../../testbench/clk_gen.v
../../dp_analog_mappings.v
../../a10_reconfig_arbiter.sv
../../bitec_reconfig_alt_a10.v
../../rx_phy/rx_phy_top.v
../../tx_phy/tx_phy_top.v
../../a10_dp_demo.v
../../testbench/a10_dp_harness.sv
