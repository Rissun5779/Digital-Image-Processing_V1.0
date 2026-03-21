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
# module dw-gpio
#
hps_utils_add_component_boiler_plate dw-gpio {Synopsys GPIO}

#
# file sets
#
#
# parameters
#

add_parameter embeddedsw.dts.instance.GPIO_PORTA_INTR integer 1
add_parameter embeddedsw.dts.instance.GPIO_PWIDTH_A integer 8
add_parameter embeddedsw.dts.instance.GPIO_PWIDTH_B integer 8
add_parameter embeddedsw.dts.instance.GPIO_PWIDTH_C integer 8
add_parameter embeddedsw.dts.instance.GPIO_PWIDTH_D integer 8

set_module_assignment embeddedsw.dts.compatible {snps,dw-gpio}
set_module_assignment embeddedsw.dts.group gpio
set_module_assignment embeddedsw.dts.params.gpio-controller 
set_module_assignment embeddedsw.dts.name dw-gpio
set_module_assignment embeddedsw.dts.vendor snps
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
hps_utils_add_axi_slave axi_slave0 axi_sig0 8
