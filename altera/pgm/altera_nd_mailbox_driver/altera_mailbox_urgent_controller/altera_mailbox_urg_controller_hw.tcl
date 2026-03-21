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


# $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_driver/altera_mailbox_urgent_controller/altera_mailbox_urg_controller_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# 
# altera_mailbox_urgent_controller "Altera Mailbox Urgent Controller" v15.1
#  2015.07.15.14:30:00
# 
# 

# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.1


# 
# module altera_mailbox_urgent_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_mailbox_urg_controller
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property VERSION 18.1
set_module_property GROUP 	"Basic Functions/Configuration and Programming"
set_module_property AUTHOR 	"Altera Corporation"
set_module_property DISPLAY_NAME "Altera Mailbox Urgent Controller"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate

set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_mailbox_urg_controller
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_mailbox_urg_controller.sv SYSTEM_VERILOG PATH altera_mailbox_urg_controller.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_mailbox_urg_controller
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_mailbox_urg_controller.sv SYSTEM_VERILOG PATH altera_mailbox_urg_controller.sv


# 
# parameters
# 
add_parameter URG_PCK_WIDTH INTEGER 32
set_parameter_property URG_PCK_WIDTH DEFAULT_VALUE 32
set_parameter_property URG_PCK_WIDTH DISPLAY_NAME URG_PCK_WIDTH
set_parameter_property URG_PCK_WIDTH TYPE INTEGER
set_parameter_property URG_PCK_WIDTH UNITS None
set_parameter_property URG_PCK_WIDTH HDL_PARAMETER true
add_parameter USE_MEMORY_BLOCKS INTEGER 1
set_parameter_property USE_MEMORY_BLOCKS DEFAULT_VALUE 1
set_parameter_property USE_MEMORY_BLOCKS DISPLAY_NAME USE_MEMORY_BLOCKS
set_parameter_property USE_MEMORY_BLOCKS TYPE INTEGER
set_parameter_property USE_MEMORY_BLOCKS UNITS None
set_parameter_property USE_MEMORY_BLOCKS HDL_PARAMETER true


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
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point gpo
# 
add_interface gpo conduit end
set_interface_property gpo associatedClock clock
set_interface_property gpo associatedReset ""
set_interface_property gpo ENABLED true
set_interface_property gpo EXPORT_OF ""
set_interface_property gpo PORT_NAME_MAP ""
set_interface_property gpo CMSIS_SVD_VARIABLES ""
set_interface_property gpo SVD_ADDRESS_GROUP ""

add_interface_port gpo gpo_write gpo_write Input 1
add_interface_port gpo gpo_data gpo_data Input 8


# 
# connection point out_data
# 
add_interface out_data avalon_streaming start
set_interface_property out_data associatedClock clock
set_interface_property out_data associatedReset reset
set_interface_property out_data dataBitsPerSymbol 8
set_interface_property out_data errorDescriptor ""
set_interface_property out_data firstSymbolInHighOrderBits true
set_interface_property out_data maxChannel 0
set_interface_property out_data readyLatency 0
set_interface_property out_data ENABLED true
set_interface_property out_data EXPORT_OF ""
set_interface_property out_data PORT_NAME_MAP ""
set_interface_property out_data CMSIS_SVD_VARIABLES ""
set_interface_property out_data SVD_ADDRESS_GROUP ""

add_interface_port out_data out_data data Output URG_PCK_WIDTH
add_interface_port out_data out_valid valid Output 1
add_interface_port out_data out_startofpacket startofpacket Output 1
add_interface_port out_data out_ready ready Input 1
add_interface_port out_data out_endofpacket endofpacket Output 1


# 
# connection point in_data
# 
add_interface in_data avalon_streaming end
set_interface_property in_data associatedClock clock
set_interface_property in_data associatedReset reset
set_interface_property in_data dataBitsPerSymbol 8
set_interface_property in_data errorDescriptor ""
set_interface_property in_data firstSymbolInHighOrderBits true
set_interface_property in_data maxChannel 0
set_interface_property in_data readyLatency 0
set_interface_property in_data ENABLED true
set_interface_property in_data EXPORT_OF ""
set_interface_property in_data PORT_NAME_MAP ""
set_interface_property in_data CMSIS_SVD_VARIABLES ""
set_interface_property in_data SVD_ADDRESS_GROUP ""

add_interface_port in_data in_data data Input URG_PCK_WIDTH
add_interface_port in_data in_valid valid Input 1
add_interface_port in_data in_startofpacket startofpacket Input 1
add_interface_port in_data in_endofpacket endofpacket Input 1
add_interface_port in_data in_ready ready Output 1

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaborate {} {

   	set st_data_width [ get_parameter_value URG_PCK_WIDTH ]
   	   
   	set_interface_property in_data dataBitsPerSymbol $st_data_width
	set_interface_property out_data dataBitsPerSymbol $st_data_width

	add_interface_port in_data in_data data Input $st_data_width
	add_interface_port out_data out_data data Output $st_data_width
}
