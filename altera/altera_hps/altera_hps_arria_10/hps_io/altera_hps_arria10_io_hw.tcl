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


#########################################
# Represents the SoC partition of the HPS
#########################################
package require -exact qsys 13.0
package require -exact altera_terp 1.0

source ../util/constants.tcl
source ../util/procedures.tcl

set_module_property NAME altera_arria10_hps_io
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"
set_module_property INTERNAL true
set_module_property SUPPORTED_DEVICE_FAMILIES {ARRIA10}
set_module_property SUPPRESS_WARNINGS NO_PORTS_AFTER_ELABORATION

add_parameter border_description string "{}" ""
add_parameter hps_parameter_map string ""

set_module_property composition_callback compose

proc compose {} {
    add_instance border altera_arria10_interface_generator
    array set border_description [get_parameter_value border_description]
    set_instance_parameter_value border interfaceDefinition [array get border_description]
    #set_instance_parameter_value border qipEntries [list "set_instance_assignment -name hps_partition on -entity %entityName% -library %libraryName%"]
    set_instance_parameter_value border ignoreSimulation true
    set_instance_parameter_value border hps_parameter_map [get_parameter_value hps_parameter_map]

    set interfaces $border_description(interfaces)
    expose_border border $interfaces
    
	
}
