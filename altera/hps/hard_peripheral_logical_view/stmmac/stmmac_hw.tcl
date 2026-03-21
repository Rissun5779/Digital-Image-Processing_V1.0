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
# module stmmac
#
hps_utils_add_component_boiler_plate stmmac {Synopsys GMAC}
#
# file sets
#
#
# parameters
#
set_module_property elaboration_callback elaborate
hps_utils_setup_swEnabled


set_module_assignment embeddedsw.dts.group ethernet
set_module_assignment embeddedsw.dts.name dwmac
set_module_assignment embeddedsw.dts.params.interrupt-names macirq
set_module_assignment embeddedsw.dts.vendor synopsys
set_module_assignment {embeddedsw.dts.params.clock-names} stmmaceth
set_module_assignment {embeddedsw.dts.params.snps,multicast-filter-bins} 256
set_module_assignment {embeddedsw.dts.params.snps,perfect-filter-entries} 128

add_parameter compatible string {altr,socfpga-stmmac snps,dwmac-3.70a snps,dwmac}
add_parameter rx_fifo_depth integer 4096
add_parameter tx_fifo_depth integer 4096

set_parameter_property rx_fifo_depth affects_elaboration true
set_parameter_property tx_fifo_depth affects_elaboration true
set_parameter_property compatible affects_elaboration true

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
hps_utils_add_axi_slave axi_slave0 axi_sig0 13

proc elaborate {} {
	hps_utils_elab_swEnabled
	set_module_assignment {embeddedsw.dts.params.rx-fifo-depth} [get_parameter_value rx_fifo_depth]
	set_module_assignment {embeddedsw.dts.params.tx-fifo-depth} [get_parameter_value tx_fifo_depth]
	set_module_assignment embeddedsw.dts.compatible [get_parameter_value compatible]
}
