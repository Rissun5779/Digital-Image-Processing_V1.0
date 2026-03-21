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
source msim_setup.tcl

onerror quit
onbreak quit

# Compile device library files
dev_com

# Compile design files in correct order
com

# Compile the additional test files
vlog -cover bcst        ../testbench/rx_freq_check.v
vlog -cover bcst        ../testbench/tx_freq_check.v
vlog -cover bcst        ../testbench/freq_check.v
vlog -cover bcst        ../testbench/vga_driver.v
vlog -cover bcst        ../testbench/clk_gen.v
vlog -cover bcst        ../dp_analog_mappings.v
vlog -cover bcst -sv    ../a10_reconfig_arbiter.sv
vlog -cover bcst        ../bitec_reconfig_alt_a10.v
vlog -cover bcst        ../rx_phy/rx_phy_top.v
vlog -cover bcst        ../tx_phy/tx_phy_top.v
vlog -cover bcst        ../a10_dp_demo.v
vlog -cover bcst -sv    ../testbench/a10_dp_harness.sv

# Elaborate the top-level design with -debugdb to save sim DB
#elab
elab_debug -debugdb

# Log the transactions 
add log -r {sim:/a10_dp_harness/*}

# Run the simulation
run -all
