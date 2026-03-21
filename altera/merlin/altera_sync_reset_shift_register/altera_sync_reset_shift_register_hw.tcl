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


# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.0


# 
# module altera_sync_reset_shift_register
# 
set_module_property DESCRIPTION "altera_sync_reset_shift_register"
set_module_property NAME altera_sync_reset_shift_register
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME altera_sync_reset_shift_register
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property INTERNAL true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_sync_reset_shift_register
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_sync_reset_shift_register.sv SYSTEM_VERILOG PATH altera_sync_reset_shift_register.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_sync_reset_shift_register
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_sync_reset_shift_register.sv SYSTEM_VERILOG PATH altera_sync_reset_shift_register.sv


# 
# parameters
# 
add_parameter DELAY INTEGER 8
set_parameter_property DELAY DEFAULT_VALUE 8
set_parameter_property DELAY DISPLAY_NAME DELAY
set_parameter_property DELAY TYPE INTEGER
set_parameter_property DELAY UNITS None
set_parameter_property DELAY HDL_PARAMETER true
add_parameter NUM_OUTPUTS INTEGER 1
set_parameter_property NUM_OUTPUTS DEFAULT_VALUE 1
set_parameter_property NUM_OUTPUTS DISPLAY_NAME NUM_OUTPUTS
set_parameter_property NUM_OUTPUTS TYPE INTEGER
set_parameter_property NUM_OUTPUTS UNITS None
set_parameter_property NUM_OUTPUTS HDL_PARAMETER false


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges BOTH
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

#                   name   signal  role
add_interface_port reset reset_in reset Input 1


# 
# connection point reset_source
# 
add_interface reset_source reset start
set_interface_property reset_source associatedClock clock
set_interface_property reset_source associatedDirectReset ""
set_interface_property reset_source associatedResetSinks ""
set_interface_property reset_source synchronousEdges BOTH
set_interface_property reset_source ENABLED true
set_interface_property reset_source EXPORT_OF ""
set_interface_property reset_source PORT_NAME_MAP ""
set_interface_property reset_source CMSIS_SVD_VARIABLES ""
set_interface_property reset_source SVD_ADDRESS_GROUP ""

#                  name            signal  role
add_interface_port reset_source reset_out reset Output 1

