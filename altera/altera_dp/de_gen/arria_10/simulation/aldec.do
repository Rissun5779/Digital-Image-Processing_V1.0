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
set TOP_LEVEL_NAME "a10_dp_harness"
set SYSTEM_INSTANCE_NAME dut
source rivierapro_setup.tcl

# Compile device library files
dev_com

# Compile design files in correct order
com

# Compile the additional test files
vlog       ../testbench/rx_freq_check.v
vlog       ../testbench/tx_freq_check.v
vlog       ../testbench/freq_check.v
vlog       ../testbench/vga_driver.v
vlog       ../testbench/clk_gen.v
vlog       ../dp_analog_mappings.v
vlog       ../a10_reconfig_arbiter.sv
vlog       ../bitec_reconfig_alt_a10.v
vlog       ../rx_phy/rx_phy_top.v
vlog       ../tx_phy/tx_phy_top.v
vlog       ../a10_dp_demo.v
vlog -v2k5 ../testbench/a10_dp_harness.sv

# Elaborate the top-level design with -debugdb to save sim DB
#elab
elab_debug -debugdb -sv_seed random

# Run the simulation
run -all
