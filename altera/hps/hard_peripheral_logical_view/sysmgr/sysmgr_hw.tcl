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
# module sysmgr
#
hps_utils_add_component_boiler_plate altera_sysmgr {Altera System Manager}
#
# file sets
#
#
# parameters
#
set_module_property elaboration_callback elaborate


set_module_assignment embeddedsw.dts.compatible {altr,sys-mgr syscon}
set_module_assignment embeddedsw.dts.group sysmgr
set_module_assignment embeddedsw.dts.name sys-mgr
set_module_assignment embeddedsw.dts.vendor altr

add_parameter cpu1_start_addr long 0xffd080c4
set_parameter_property cpu1_start_addr affects_elaboration true
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
# the system manager for arria5/cyclone5 has 9 bits
# of address, but the arria10 range goes a bit beyone it.
# We have to specify 10 bits.
hps_utils_add_axi_slave axi_slave0 axi_sig0 10 
proc elaborate {} {
    set_module_assignment {embeddedsw.dts.params.cpu1-start-addr} [get_parameter_value cpu1_start_addr]
}
