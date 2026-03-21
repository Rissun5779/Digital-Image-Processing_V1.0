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


#############################################################
#
# Tcl script for building the HDMI Example Design IP blocks
# 
# ###########################################################

# Load required packages
load_package flow
load_package misc

# Regenerate the IP 
qexec "qmegawiz -silent ./i2c/hdmi_rx_edid_ram.v"
qexec "qmegawiz -silent ./i2c/output_buf_i2c.v"
qexec "qmegawiz -silent ./pll/pll_sys.v"
qexec "qmegawiz -silent ./pll/pll_hdmi.v"
qexec "qmegawiz -silent ./reconfig_ip/pll_reconfig.v"
qexec "qmegawiz -silent ./reconfig_ip/gxb_rx_reconfig.v"
qexec "qmegawiz -silent ./native_phy_rx/gxb_rx.v"
qexec "qmegawiz -silent ./native_phy_rx/gxb_rx_reset1.v"
qexec "qmegawiz -silent ./native_phy_tx/gxb_tx.v"
qexec "qmegawiz -silent ./native_phy_tx/gxb_tx_reset.v"

# Regenerate the Qsys system
qexec "qsys-generate ./hdmi_rx/hdmi_rx.qsys --synthesis=VERILOG"
qexec "qsys-generate ./hdmi_tx/hdmi_tx.qsys --synthesis=VERILOG"
qexec "qsys-generate ./qsys_vip_passthrough.qsys --synthesis=VERILOG"

# Comment out the repetitive file path to pass synthesis
set fd [open ./reconfig_ip/gxb_rx_reconfig.qip r]
set file_data [read $fd]
close $fd

set fd [open ./reconfig_ip/gxb_rx_reconfig.qip w]
regsub {(set_global_assignment -library "gxb_rx_reconfig" -name VERILOG_FILE \[file join \$\:\:quartus\(qip_path\) \"gxb_rx_reconfig\/altera_reset_controller.v\"\])} $file_data {#\1} temp
puts -nonewline $fd $temp
close $fd

# Create the project overwriting any previous settings files
project_new av_sk_hdmi2_demo -overwrite

# add the assignments to the project
source assignments.tcl

# Clean up by closing the project
project_close
