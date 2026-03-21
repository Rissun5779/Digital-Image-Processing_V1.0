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


package require -exact qsys 15.0
source ../util/hps_utils.tcl



# 
# module arm_gic
# 
set_module_property NAME stratix10_arm_gic
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME "ARM GIC"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false

set arm_gic_addr_bits 12

# 
# file sets
# 

# 
# parameters
# 
set_module_assignment embeddedsw.dts.vendor "arm"
set_module_assignment embeddedsw.dts.name "cortex-a9-gic"
set_module_assignment embeddedsw.dts.group "intc"
set_module_assignment embeddedsw.dts.compatible {arm,cortex-a9-gic}

# 
# display items
# 


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true

add_interface_port clock_sink new_signal_2 clk Input 1


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true

add_interface_port reset_sink new_signal_3 reset Input 1


proc arm_gic_add_irq_interface {int_name sig_name width irq_rx_type irq_rx_offset} {
    add_interface $int_name interrupt start
    set_interface_property $int_name associatedAddressablePoint ""
    set_interface_property $int_name associatedClock clock_sink
    set_interface_property $int_name associatedReset reset_sink
    set_interface_property $int_name irqScheme INDIVIDUAL_REQUESTS
    set_interface_property $int_name ENABLED true
    set_interface_assignment $int_name embeddedsw.dts.irq.rx_type $irq_rx_type
    set_interface_assignment $int_name embeddedsw.dts.irq.rx_offset $irq_rx_offset
    add_interface_port $int_name $sig_name irq Input $width
}

proc arm_gic_add_irq_interface_arm_gic_spi {int_name sig_name width irq_rx_offset} {
    arm_gic_add_irq_interface $int_name $sig_name $width arm_gic_spi $irq_rx_offset
}

#
# start with the 19 ppi interrupts
#
arm_gic_add_irq_interface arm_gic_ppi ppi_irq_siq 19 arm_gic_ppi 0

#
# connection point irq_rx_offset_0
#

arm_gic_add_irq_interface_arm_gic_spi irq_rx_offset_0 irq_siq_0 19 0

#
# connection point f2h_irq_0_irq_rx_offset_19
#
arm_gic_add_irq_interface_arm_gic_spi f2h_irq_0_irq_rx_offset_19 irq_siq_19 32 19

#
# connection point f2h_irq_32_irq_rx_offset_51
#
arm_gic_add_irq_interface_arm_gic_spi f2h_irq_32_irq_rx_offset_51 irq_siq_10 32 51

#
# connection point irq_rx_offset_83
#
arm_gic_add_irq_interface_arm_gic_spi irq_rx_offset_83 irq_siq_83 32 83

#
# connection point irq_rx_offset_115
#
arm_gic_add_irq_interface_arm_gic_spi irq_rx_offset_115 irq_siq_115 12 115

# 
# connection point altera_axi_slave
# 
hps_utils_add_axi_slave "axi_slave0" "axi_slave0_signal" 12
hps_utils_add_axi_slave "axi_slave1" "axi_slave1_signal" 8
