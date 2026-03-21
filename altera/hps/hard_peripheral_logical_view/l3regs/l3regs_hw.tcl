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


package require -exact qsys 12.0
set hard_peripheral_logical_view_dir ..
source "$hard_peripheral_logical_view_dir/common/hps_utils.tcl"

#
# module sdrctl
#
hps_utils_add_component_boiler_plate altera_l3regs {Altera HPS L3 Registers}
#
# file sets
#
#
# parameters
#

set_module_assignment embeddedsw.dts.compatible {altr,l3regs syscon}
set_module_assignment embeddedsw.dts.group rl3regs
set_module_assignment embeddedsw.dts.name l3regs
set_module_assignment embeddedsw.dts.vendor altr
# 
# display items
# 


hps_utils_add_clock_reset

#
# Interrupt sender
#

# 
# connection point altera_axi_slave
# 
hps_utils_add_axi_slave axi_slave0 axi_sig0 12
