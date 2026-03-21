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
# Tcl script for building the DisplayPort Example Design IP blocks
#
# *********************************************************************

# Load required packages
load_package flow
load_package misc

# Copy necessary files
set DP_DIR $::env(QUARTUS_ROOTDIR)../ip/altera/altera_dp
qexec "rm -rf clkrec"
qexec "mkdir clkrec"
qexec "cp $DP_DIR/hw_demo/common/clkrec/* ./clkrec/"
qexec "rm -rf reconfig_mgmt"
qexec "mkdir reconfig_mgmt"
qexec "cp $DP_DIR/hw_demo/common/reconfig_mgmt/* ./reconfig_mgmt/"
# Regenerate the IP 
# qexec "qmegawiz -silent rx_clk_buf.v"
qexec "qmegawiz -silent sv_xcvr_pll.v"
qexec "qmegawiz -silent video_pll_sv.v"
qexec "qmegawiz -silent ./clkrec/clkrec_pll_sv.v"
qexec "qmegawiz -silent gxb_reset.v"
qexec "qmegawiz -silent gxb_reconfig.v"
qexec "qmegawiz -silent gxb_rx.v"
qexec "qmegawiz -silent gxb_tx.v"


qexec "qsys-generate control.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG" 

# Create the project overwriting any previous settings files
project_new mst_sv_dp_demo -overwrite

# Add the assignments to the project
source assignments.tcl

# Clean up by closing the project
project_close
