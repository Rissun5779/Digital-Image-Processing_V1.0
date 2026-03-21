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


# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# 
# altera_sld_host_endpoint_bridge "altera_sld_host_endpoint_bridge" v1.0
# 

# request TCL package from ACDS 13.0
# 
package require -exact qsys 13.0

# 
# module altera_sld_host_endpoint_bridge
# 
set_module_property NAME altera_sld_host_endpoint_bridge
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Verification/Debug & Performance"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME altera_sld_host_endpoint_bridge
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property ELABORATION_CALLBACK elaborate
set_module_assignment debug.isTransparent true

# 
# parameters
# 
add_parameter ENABLE_JTAG_IO_SELECTION INTEGER 0
set_parameter_property ENABLE_JTAG_IO_SELECTION AFFECTS_ELABORATION true
set_parameter_property ENABLE_JTAG_IO_SELECTION AFFECTS_GENERATION false
set_parameter_property ENABLE_JTAG_IO_SELECTION HDL_PARAMETER true


# 
# display items
# 

#
# connection point clock
#
add_interface clock clock end
set_interface_property clock ENABLED true
add_interface_port clock tck clk Input 1


#
# connection point node
#
add_interface ext_node conduit end
set_interface_property ext_node associatedClock clock
set_interface_property ext_node ENABLED true
add_interface_port ext_node ext_tms tms Input 1
add_interface_port ext_node ext_tdi tdi Input 1
add_interface_port ext_node ext_tdo tdo Output 1

add_interface int_node conduit start
set_interface_property int_node associatedClock clock
set_interface_property int_node ENABLED true
add_interface_port int_node int_tms tms Output 1
add_interface_port int_node int_tdi tdi Output 1
add_interface_port int_node int_tdo tdo Input 1

set_interface_assignment int_node debug.controlledBy ext_node
set_port_property int_tms driven_by ext_tms
set_port_property int_tdi driven_by ext_tdi
set_port_property ext_tdo driven_by int_tdo


#
# Elaboration callback
#
proc elaborate {} {
    set ENABLE_JTAG_IO_SELECTION [get_parameter_value ENABLE_JTAG_IO_SELECTION]

    if {$ENABLE_JTAG_IO_SELECTION != 0} {
        add_interface_port int_node int_select_this select_this Output 1
        add_interface_port ext_node ext_select_this select_this Input 1
        set_port_property int_select_this driven_by ext_select_this
    }
}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}
