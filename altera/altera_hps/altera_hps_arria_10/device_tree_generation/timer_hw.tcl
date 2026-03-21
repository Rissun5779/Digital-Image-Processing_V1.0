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


package require -exact qsys 13.0
source hps_utils.tcl

#
# module timer
#
hps_utils_add_component_boiler_plate arria10_timer {ARM internal timer}
#
# file sets
#
#
# parameters
#

set_module_assignment embeddedsw.dts.compatible arm,cortex-a9-twd-timer
set_module_assignment embeddedsw.dts.group timer
set_module_assignment embeddedsw.dts.name cortex-a9-twd-timer
set_module_assignment embeddedsw.dts.vendor arm
# 
# display items
# 


hps_utils_add_clock_reset

#
# Interrupt sender
#
hps_utils_add_irq_sender interrupt_sender
set_interface_assignment interrupt_sender embeddedsw.dts.irq.tx_mask 0xf00

# 
# connection point altera_axi_slave
# 
hps_utils_add_axi_slave axi_slave0 axi_sig0 8
