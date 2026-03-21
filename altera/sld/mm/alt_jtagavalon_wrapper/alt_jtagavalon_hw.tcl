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


package require -exact qsys 14.1

# +-----------------------------------
# | module alt_jtagavalon_wrapper
# |
set_module_property DESCRIPTION ""
set_module_property NAME alt_jtagavalon_wrapper
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Bridges and Adapters/Streaming"
set_module_property DISPLAY_NAME "JTAG Avalon"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property elaboration_callback elaborate
set_module_property HELPER_JAR com.altera.jtagavalon.jar

set_module_assignment debug.virtualInterface.link {debug.fabricLink {fabric sld} }
# |
# +-----------------------------------

# +-----------------------------------
# | file sets
# |
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL alt_jtagavalon_wrapper
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file alt_jtagavalon_wrapper.v verilog path alt_jtagavalon_wrapper.v
add_fileset_file alt_jtagavalon.v verilog path alt_jtagavalon.v
add_fileset_file alt_jtagavalon_rom.vhd vhdl path alt_jtagavalon_rom.vhd
# |
# +-----------------------------------

# +-----------------------------------
# | parameters
# |
add_parameter ADDR_WIDTH INTEGER 16 ""
set_parameter_property ADDR_WIDTH ALLOWED_RANGES 1:32
set_parameter_property ADDR_WIDTH DISPLAY_NAME ADDR_WIDTH
set_parameter_property ADDR_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADDR_WIDTH HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 32 ""
set_parameter_property DATA_WIDTH ALLOWED_RANGES 1:128
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_parameter MODE_WIDTH INTEGER 3 ""
set_parameter_property MODE_WIDTH ALLOWED_RANGES 1:8
set_parameter_property MODE_WIDTH DISPLAY_NAME MODE_WIDTH
set_parameter_property MODE_WIDTH AFFECTS_ELABORATION false
set_parameter_property MODE_WIDTH HDL_PARAMETER true

add_parameter INSTANCE_ID INTEGER 0 ""
set_parameter_property INSTANCE_ID ALLOWED_RANGES 0:255
set_parameter_property INSTANCE_ID DISPLAY_NAME INSTANCE_ID
set_parameter_property INSTANCE_ID AFFECTS_ELABORATION false
set_parameter_property INSTANCE_ID HDL_PARAMETER true

add_parameter SLD_AUTO_INSTANCE_INDEX STRING YES
set_parameter_property SLD_AUTO_INSTANCE_INDEX ALLOWED_RANGES {NO YES}
set_parameter_property SLD_AUTO_INSTANCE_INDEX DISPLAY_NAME SLD_AUTO_INSTANCE_INDEX
set_parameter_property SLD_AUTO_INSTANCE_INDEX AFFECTS_ELABORATION false
set_parameter_property SLD_AUTO_INSTANCE_INDEX HDL_PARAMETER true

add_parameter ADDRESS_MAP STRING {}
set_parameter_property ADDRESS_MAP DISPLAY_HINT "columns:120"
set_parameter_property ADDRESS_MAP AFFECTS_ELABORATION true
set_parameter_property ADDRESS_MAP HDL_PARAMETER false
set_parameter_property ADDRESS_MAP SYSTEM_INFO {ADDRESS_MAP avm_jtag}

add_parameter ROM_CONTENTS STRING {}
set_parameter_property ROM_CONTENTS DISPLAY_HINT "columns:120"
set_parameter_property ROM_CONTENTS AFFECTS_ELABORATION false
set_parameter_property ROM_CONTENTS DERIVED true
set_parameter_property ROM_CONTENTS HDL_PARAMETER true

add_parameter ROM_SIZE INTEGER 0
set_parameter_property ROM_SIZE AFFECTS_ELABORATION false
set_parameter_property ROM_SIZE DERIVED true
set_parameter_property ROM_SIZE HDL_PARAMETER true

add_parameter OWNER_ID INTEGER 0
set_parameter_property OWNER_ID ALLOWED_RANGES 0:255
set_parameter_property OWNER_ID DISPLAY_NAME OWNER_ID
set_parameter_property OWNER_ID DISPLAY_HINT "hexadecimal"
set_parameter_property OWNER_ID AFFECTS_ELABORATION false
set_parameter_property OWNER_ID HDL_PARAMETER true

add_parameter USAGE_ID INTEGER 0
set_parameter_property USAGE_ID NEW_INSTANCE_VALUE 256
set_parameter_property USAGE_ID ALLOWED_RANGES 0:4095
set_parameter_property USAGE_ID DISPLAY_NAME USAGE_ID
set_parameter_property USAGE_ID DISPLAY_HINT "hexadecimal"
set_parameter_property USAGE_ID AFFECTS_ELABORATION true
set_parameter_property USAGE_ID HDL_PARAMETER true

add_parameter USER_ID1 INTEGER 0
set_parameter_property USER_ID1 ALLOWED_RANGES 0:255
set_parameter_property USER_ID1 DISPLAY_HINT "hexadecimal"
set_parameter_property USER_ID1 AFFECTS_ELABORATION false
set_parameter_property USER_ID1 HDL_PARAMETER true

add_parameter USER_ID2 INTEGER 0
set_parameter_property USER_ID2 ALLOWED_RANGES 0:4095
set_parameter_property USER_ID2 DISPLAY_HINT "hexadecimal"
set_parameter_property USER_ID2 AFFECTS_ELABORATION false
set_parameter_property USER_ID2 HDL_PARAMETER true

# |
# +-----------------------------------

# +-----------------------------------
# | connection point global_signals_clock
# |
add_interface global_signals_clock clock end

add_interface_port global_signals_clock clk clk Input 1
add_interface_port global_signals_clock rst_n reset_n Input 1

# |
# +-----------------------------------

# +-----------------------------------
# | connection point avm_jtag
# |
add_interface avm_jtag avalon start

set_interface_property avm_jtag adaptsTo ""
set_interface_property avm_jtag burstOnBurstBoundariesOnly false
set_interface_property avm_jtag doStreamReads false
set_interface_property avm_jtag doStreamWrites false
set_interface_property avm_jtag linewrapBursts false

set_interface_property avm_jtag associatedClock global_signals_clock
set_interface_property avm_jtag ENABLED true

add_interface_port avm_jtag av_waitrequest waitrequest Input 1
add_interface_port avm_jtag av_address address Output ADDR_WIDTH
add_interface_port avm_jtag av_write_n write_n Output 1
add_interface_port avm_jtag av_writedata writedata Output DATA_WIDTH
add_interface_port avm_jtag av_read_n read_n Output 1
add_interface_port avm_jtag av_readdata readdata Input DATA_WIDTH

set_interface_assignment avm_jtag debug.controlledBy link
set_interface_assignment avm_jtag debug.providesServices master
# |
# +-----------------------------------

proc elaborate {} {
	set address_map [get_parameter_value ADDRESS_MAP]
	set usage [get_parameter_value USAGE_ID]

	if {$usage == 256} {
		set tcl [call_helper encodeAndCompress [list $address_map cs]]
		eval $tcl

		set_parameter_value ROM_CONTENTS $bits
		set_parameter_value ROM_SIZE [expr {[string length $bits] / 32}]

		send_message {debug text} "ROM contents: $bytes"
	} else {
		set_parameter_value ROM_CONTENTS {}
		set_parameter_value ROM_SIZE 0

		send_message {debug text} "ROM not initialised, set USAGE_ID to 256 to enable ROM"
	}
}
