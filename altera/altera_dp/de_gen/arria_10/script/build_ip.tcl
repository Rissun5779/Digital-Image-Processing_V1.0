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
#set DP_DIR $::env(QUARTUS_ROOTDIR)../ip/altera/altera_dp
set ED_DIR ./../rtl
# Regenerate the IP 
qexec "qsys-generate $ED_DIR/video_pll_a10.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG" 
qexec "qsys-generate $ED_DIR/clkrec/clkrec_pll_a10.qsys --search-path=./clkrec/*,$ --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/clkrec/clkrec_pll135_a10.qsys --search-path=./clkrec/*,$ --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/clkrec/clkrec_reset_a10.qsys --search-path=./clkrec/*,$ --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/core/dp_core.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG" 
qexec "qsys-generate $ED_DIR/core/dp_rx.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG" 
qexec "qsys-generate $ED_DIR/core/dp_tx.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG" 
#qexec "qsys-generate $ED_DIR/i2c_gpio_buf.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/rx_phy/gxb_rx.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/rx_phy/gxb_rx_reset.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG" 
qexec "qsys-generate $ED_DIR/tx_phy/gxb_tx.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/tx_phy/gxb_tx_fpll.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG" 
qexec "qsys-generate $ED_DIR/tx_phy/gxb_tx_reset.qsys --search-path=../ip/**/*,$ --synthesis=VERILOG" 

# Create the project overwriting any previous settings files
#project_new ./../quartus/a10_dp_demo -overwrite

# Add the assignments to the project
#source ./../quartus/assignments.tcl

# Clean up by closing the project
#project_close
