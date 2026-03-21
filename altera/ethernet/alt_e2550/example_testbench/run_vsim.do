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


vlib work
set TOP_LEVEL_NAME "basic_avl_tb_top"
set QUARTUS_INSTALL_DIR $env(QUARTUS_ROOTDIR)
set QSYS_SIMDIR ENET_ENTITY_QMEGA_01312014

do $QSYS_SIMDIR/mentor/msim_setup.tcl

dev_com
com

vlog +acc ./basic_avl_tb_top.sv

elab

run -all
quit
