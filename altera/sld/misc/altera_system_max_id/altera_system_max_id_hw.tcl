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


# request TCL package from ACDS 14.1
# 
package require -exact qsys 14.1


# 
# module altera_system_max_id
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_system_max_id
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME altera_system_max_id
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property elaboration_callback elaborate


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_system_max_id
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_system_max_id.vhd VHDL PATH altera_system_max_id.vhd TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter MANUFACTURER_ID INTEGER 110 ""
set_parameter_property MANUFACTURER_ID DISPLAY_NAME "Manufacturer ID"
set_parameter_property MANUFACTURER_ID AFFECTS_ELABORATION false
set_parameter_property MANUFACTURER_ID HDL_PARAMETER true

add_parameter BOARD_ID INTEGER 0 ""
set_parameter_property BOARD_ID DISPLAY_NAME "Board ID"
set_parameter_property BOARD_ID AFFECTS_ELABORATION false
set_parameter_property BOARD_ID HDL_PARAMETER true

add_parameter MAX_VERSION INTEGER 16 ""
set_parameter_property MAX_VERSION DISPLAY_NAME "System MAX version number"
set_parameter_property MAX_VERSION AFFECTS_ELABORATION false
set_parameter_property MAX_VERSION HDL_PARAMETER true

add_parameter USE_BOARD_VERSION INTEGER 0 ""
set_parameter_property USE_BOARD_VERSION DISPLAY_NAME "Use board version number"
set_parameter_property USE_BOARD_VERSION AFFECTS_ELABORATION true
set_parameter_property USE_BOARD_VERSION HDL_PARAMETER false
set_parameter_property USE_BOARD_VERSION display_hint boolean

# 
# display items
# 


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true

add_interface_port reset reset_n reset_n Input 1


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1


# 
# connection point slv
# 
add_interface slv avalon end
set_interface_property slv addressUnits WORDS
set_interface_property slv associatedClock clock
set_interface_property slv associatedReset reset
set_interface_property slv bitsPerSymbol 8
set_interface_property slv burstOnBurstBoundariesOnly false
set_interface_property slv burstcountUnits WORDS
set_interface_property slv explicitAddressSpan 0
set_interface_property slv holdTime 0
set_interface_property slv linewrapBursts false
set_interface_property slv maximumPendingReadTransactions 0
set_interface_property slv readLatency 1
set_interface_property slv readWaitTime 1
set_interface_property slv setupTime 0
set_interface_property slv timingUnits Cycles
set_interface_property slv writeWaitTime 0
set_interface_property slv ENABLED true

add_interface_port slv slv_address address Input 3
add_interface_port slv slv_read_n read_n Input 1
add_interface_port slv slv_data_out readdata Output 32
set_interface_assignment slv embeddedsw.configuration.isFlash 0
set_interface_assignment slv embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment slv embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment slv embeddedsw.configuration.isPrintableDevice 0

# 
# connection point board_version
# 
add_interface board_version conduit end
set_interface_property board_version associatedClock clock
set_interface_property board_version associatedReset reset
set_interface_property board_version ENABLED false

add_interface_port board_version board_version version Input 16
set_port_property board_version termination true

proc elaborate {} {
	set use_board_version [get_parameter_value USE_BOARD_VERSION]

	if {$use_board_version} {
		set_interface_property board_version ENABLED true
		set_port_property board_version termination false
	}
}
