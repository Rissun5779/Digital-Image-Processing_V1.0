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
set TOP_LEVEL_NAME "cv_dp_harness"
set QSYS_SIMDIR "."
set SYSTEM_INSTANCE_NAME dut
source $QSYS_SIMDIR/mentor/msim_setup.tcl

onerror quit
onbreak quit

# Compile device library files
dev_com

# Compile design files in correct order
com

# Compile the additional test files
vlog -cover bcst   rx_freq_check.sv
vlog -cover bcst   tx_freq_check.sv
vlog -cover bcst   freq_check.sv
vlog -cover bcst   vga_driver.v
vlog -cover bcst   clk_gen.v
vlog -cover bcst   dp_analog_mappings.v
vlog -cover bcst   dp_mif_mappings.v
vlog -cover bcst   reconfig_mgmt_write.v
vlog -cover bcst   reconfig_mgmt_hw_ctrl.v
vlog -cover bcst   cv_dp_example.v
vlog -cover bcst  -sv cv_dp_harness.sv

# Elaborate the top-level design with -debugdb to save sim DB
#elab
elab_debug -debugdb

# Log the transactions 
add log -r {sim:/cv_dp_harness/*}

# Run the simulation
run -all
