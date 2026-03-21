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
# module fpgamgr
#
hps_utils_add_component_boiler_plate altera_fpgamgr {Altera FPGA Manager}
set_module_property elaboration_callback elaborate

#
# file sets
#
#
# parameters
#
add_parameter compatible string {altr,fpga-mgr altr,socfpga-fpga-mgr}
set_parameter_property compatible affects_elaboration true

set_module_assignment embeddedsw.dts.group fpgamgr
set_module_assignment embeddedsw.dts.params.transport mmio
set_module_assignment embeddedsw.dts.name fpga-mgr
set_module_assignment embeddedsw.dts.vendor altr
# 
# display items
# 


hps_utils_add_clock_reset

#
# Interrupt sender
#
hps_utils_add_irq_sender interrupt_sender

# 
# connection point altera_axi_slave
# 
hps_utils_add_axi_slave axi_slave0 axi_sig0 12
hps_utils_add_axi_slave axi_slave1 axi_sig1 8

proc elaborate {} {
	set_module_assignment embeddedsw.dts.compatible [get_parameter_value compatible]
}
