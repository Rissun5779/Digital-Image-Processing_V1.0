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


# Set hierarchy variables used in the Qsys-generated files
source ./ncsim_setup.sh SKIP_ELAB=1 SKIP_SIM=1

# Compile the additional test files
ncvlog -sv    ../testbench/a10_dp_harness.sv
ncvlog        ../testbench/rx_freq_check.v
ncvlog        ../testbench/tx_freq_check.v
ncvlog        ../testbench/freq_check.v
ncvlog        ../testbench/vga_driver.v
ncvlog        ../testbench/clk_gen.v
ncvlog        ../dp_analog_mappings.v
ncvlog -sv    ../a10_reconfig_arbiter.sv
ncvlog        ../bitec_reconfig_alt_a10.v
ncvlog        ../rx_phy/rx_phy_top.v
ncvlog        ../tx_phy/tx_phy_top.v
ncvlog        ../a10_dp_demo.v

source ./ncsim_setup.sh SKIP_FILE_COPY=1 SKIP_DEV_COM=1 SKIP_COM=1 TOP_LEVEL_NAME="a10_dp_harness" USER_DEFINED_ELAB_OPTIONS="\"-timescale 1ns/1ns\"" USER_DEFINED_SIM_OPTIONS=""
