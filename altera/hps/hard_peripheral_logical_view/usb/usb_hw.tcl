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
# module usb
#
hps_utils_add_component_boiler_plate usb {Synopsys USB}
#
# file sets
#
#
# parameters
#
set_module_property elaboration_callback elaborate
hps_utils_setup_swEnabled


set_module_assignment embeddedsw.dts.params.host-rx-fifo-size 512
set_module_assignment embeddedsw.dts.params.dev-tx-fifo-size {<512 512 512 512 512 512 512 512 512 512 512 512 512 512 512>}
set_module_assignment embeddedsw.dts.compatible {snps,dwc-otg snps,dwc2}
set_module_assignment embeddedsw.dts.params.dev-perio-tx-fifo-size {<512 512 512 512 512 512 512 512 512 512 512 512 512 512 512>}
set_module_assignment embeddedsw.dts.params.voltage-switch 0
set_module_assignment embeddedsw.dts.name dwc-otg
set_module_assignment embeddedsw.dts.params.dev-nperio-tx-fifo-size 4096
set_module_assignment embeddedsw.dts.params.dma-mask 268435455
set_module_assignment embeddedsw.dts.group usb
set_module_assignment embeddedsw.dts.params.ulpi-ddr 0
set_module_assignment embeddedsw.dts.vendor snps
set_module_assignment embeddedsw.dts.params.dev-rx-fifo-size 512

set_module_assignment embeddedsw.dts.params.clock-names otg
set_module_assignment embeddedsw.dts.params.phy-names usb2-phy
set_module_assignment embeddedsw.dts.params.enable-dynamic-fifo 1
set_module_assignment embeddedsw.dts.params.host-rx-fifo-size 0xa00
set_module_assignment embeddedsw.dts.params.host-perio-tx-fifo-size 0xa00
set_module_assignment embeddedsw.dts.params.host-nperio-tx-fifo-size 0xa00
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
hps_utils_add_axi_slave axi_slave0 axi_sig0 18

proc elaborate {} {
	hps_utils_elab_swEnabled
}
