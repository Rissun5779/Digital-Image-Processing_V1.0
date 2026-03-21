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



onerror quit

set TOP_LEVEL_NAME hmcc_tb
set EXAMPLE_SRCDIR ../src
source ./mentor/msim_setup.tcl


#example design source
vlog     $EXAMPLE_SRCDIR/i2c_32sub.v
vlog -sv $EXAMPLE_SRCDIR/i2c_control.sv
vlog     $EXAMPLE_SRCDIR/m20k_2port.v
vlog -sv $EXAMPLE_SRCDIR/request_generator.sv
vlog -sv $EXAMPLE_SRCDIR/response_monitor.sv
vlog -sv $EXAMPLE_SRCDIR/atx_pll_recal.sv
vlog -sv $EXAMPLE_SRCDIR/hmcc_example.sv
vlog -sv ./hmcc_tb.sv

ld_debug

log -r /*
run -all
quit
