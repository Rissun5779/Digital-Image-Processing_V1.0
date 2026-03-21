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

# Regenerate the IP/Qsys system
set ED_DIR ./../rtl

qexec "qsys-generate $ED_DIR/hdmi_rx/hdmi_rx.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/hdmi_tx/hdmi_tx.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/i2c_slave/edid_ram.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/i2c_slave/output_buf_i2c.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/gxb/gxb_rx.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/gxb/gxb_rx_reset.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/gxb/gxb_tx.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/gxb/gxb_tx_fpll.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/gxb/gxb_tx_atx_pll.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/gxb/gxb_tx_reset.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/pll/pll_hdmi.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/pll/pll_hdmi_reconfig.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/clock_control.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/nios.qsys --synthesis=VERILOG"
qexec "qsys-generate $ED_DIR/hdr/avalon_st_multiplexer.qsys --synthesis=VERILOG"

# Create the project overwriting any previous settings files
#project_new a10_hdmi2_demo -overwrite

# add the assignments to the project
#source assignments.tcl

# Clean up by closing the project
#project_close
