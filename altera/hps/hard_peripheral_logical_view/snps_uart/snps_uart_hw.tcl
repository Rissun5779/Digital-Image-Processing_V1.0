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
# module snps_uart
#
hps_utils_add_component_boiler_plate snps_uart {Synopsys UART}

set_module_property elaboration_callback elaborate

#
# file sets
#
#
# parameters
#
hps_utils_setup_swEnabled
add_parameter clk_freq_mhz float 0.0
set_parameter_property clk_freq_mhz affects_elaboration true

set_module_assignment embeddedsw.CMacro.FIFO_MODE  {1}
set_module_assignment embeddedsw.CMacro.FIFO_DEPTH {128}
set_module_assignment embeddedsw.CMacro.FIFO_HWFC  {0}
set_module_assignment embeddedsw.CMacro.FIFO_SWFC  {0}

set_module_assignment embeddedsw.dts.compatible snps,dw-apb-uart
set_module_assignment embeddedsw.dts.group serial
set_module_assignment embeddedsw.dts.params.reg-io-width 4
set_module_assignment embeddedsw.dts.name dw-apb-uart
set_module_assignment embeddedsw.dts.params.reg-shift 2
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

set_interface_assignment axi_slave0 embeddedsw.configuration.isPrintableDevice {1}

proc elaborate {} {
	hps_utils_elab_swEnabled
	set_module_assignment embeddedsw.CMacro.FREQ [hps_utils_float2mhz [get_parameter_value clk_freq_mhz]]
}
