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


# $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_driver/altera_mailbox_scheduler/altera_mailbox_scheduler_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# 
# altera_mailbox_scheduler "Altera Mailbox Scheduler" v1.0
#  2015.07.03.13:09:27
# 
# 

# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.1


# 
# module altera_mailbox_scheduler
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_mailbox_scheduler
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property VERSION 18.1
set_module_property GROUP 	"Basic Functions/Configuration and Programming"
set_module_property AUTHOR 	"Altera Corporation"
set_module_property DISPLAY_NAME "Altera Mailbox Scheduler"
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
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_mailbox_scheduler
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_mailbox_scheduler.sv SYSTEM_VERILOG PATH altera_mailbox_scheduler.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_mailbox_scheduler
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_mailbox_scheduler.sv SYSTEM_VERILOG PATH altera_mailbox_scheduler.sv TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter IN_CMD_DATA_W INTEGER 64
set_parameter_property IN_CMD_DATA_W DEFAULT_VALUE 64
set_parameter_property IN_CMD_DATA_W DISPLAY_NAME IN_CMD_DATA_W
set_parameter_property IN_CMD_DATA_W TYPE INTEGER
set_parameter_property IN_CMD_DATA_W UNITS None
set_parameter_property IN_CMD_DATA_W HDL_PARAMETER true

add_parameter IN_REQ_DATA_W INTEGER 6
set_parameter_property IN_REQ_DATA_W DEFAULT_VALUE 6
set_parameter_property IN_REQ_DATA_W DISPLAY_NAME IN_REQ_DATA_W
set_parameter_property IN_REQ_DATA_W TYPE INTEGER
set_parameter_property IN_REQ_DATA_W UNITS None
set_parameter_property IN_REQ_DATA_W HDL_PARAMETER true

add_parameter IN_RD_DATA_W INTEGER 38
set_parameter_property IN_RD_DATA_W DEFAULT_VALUE 6
set_parameter_property IN_RD_DATA_W DISPLAY_NAME IN_RD_DATA_W
set_parameter_property IN_RD_DATA_W TYPE INTEGER
set_parameter_property IN_RD_DATA_W UNITS None
set_parameter_property IN_RD_DATA_W HDL_PARAMETER true

add_parameter IN_URG_DATA_W INTEGER 38
set_parameter_property IN_URG_DATA_W DEFAULT_VALUE 6
set_parameter_property IN_URG_DATA_W DISPLAY_NAME IN_URG_DATA_W
set_parameter_property IN_URG_DATA_W TYPE INTEGER
set_parameter_property IN_URG_DATA_W UNITS None
set_parameter_property IN_URG_DATA_W HDL_PARAMETER true

add_parameter OUT_DATA_W INTEGER 74
set_parameter_property OUT_DATA_W DEFAULT_VALUE 74
set_parameter_property OUT_DATA_W DISPLAY_NAME OUT_DATA_W
set_parameter_property OUT_DATA_W TYPE INTEGER
set_parameter_property OUT_DATA_W UNITS None
set_parameter_property OUT_DATA_W HDL_PARAMETER true


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
# connection point src
# 
add_interface src avalon_streaming start
set_interface_property src associatedClock clock
set_interface_property src associatedReset reset
set_interface_property src dataBitsPerSymbol 74
set_interface_property src errorDescriptor ""
set_interface_property src firstSymbolInHighOrderBits true
set_interface_property src maxChannel 0
set_interface_property src readyLatency 0
set_interface_property src ENABLED true
set_interface_property src EXPORT_OF ""
set_interface_property src PORT_NAME_MAP ""
set_interface_property src CMSIS_SVD_VARIABLES ""
set_interface_property src SVD_ADDRESS_GROUP ""

add_interface_port src src_endofpacket endofpacket Output 1
add_interface_port src src_data data Output OUT_DATA_W
add_interface_port src src_valid valid Output 1
add_interface_port src src_startofpacket startofpacket Output 1
add_interface_port src src_ready ready Input 1


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
# connection point cmd_sink
# 
add_interface cmd_sink avalon_streaming end
set_interface_property cmd_sink associatedClock clock
set_interface_property cmd_sink associatedReset reset
set_interface_property cmd_sink dataBitsPerSymbol 74
set_interface_property cmd_sink errorDescriptor ""
set_interface_property cmd_sink firstSymbolInHighOrderBits true
set_interface_property cmd_sink maxChannel 0
set_interface_property cmd_sink readyLatency 0
set_interface_property cmd_sink ENABLED true
set_interface_property cmd_sink EXPORT_OF ""
set_interface_property cmd_sink PORT_NAME_MAP ""
set_interface_property cmd_sink CMSIS_SVD_VARIABLES ""
set_interface_property cmd_sink SVD_ADDRESS_GROUP ""

add_interface_port cmd_sink cmd_data data Input IN_CMD_DATA_W
add_interface_port cmd_sink cmd_valid valid Input 1
add_interface_port cmd_sink cmd_startofpacket startofpacket Input 1
add_interface_port cmd_sink cmd_endofpacket endofpacket Input 1
add_interface_port cmd_sink cmd_ready ready Output 1


# 
# connection point urg_sink
# 
add_interface urg_sink avalon_streaming end
set_interface_property urg_sink associatedClock clock
set_interface_property urg_sink associatedReset reset
set_interface_property urg_sink dataBitsPerSymbol 74
set_interface_property urg_sink errorDescriptor ""
set_interface_property urg_sink firstSymbolInHighOrderBits true
set_interface_property urg_sink maxChannel 0
set_interface_property urg_sink readyLatency 0
set_interface_property urg_sink ENABLED true
set_interface_property urg_sink EXPORT_OF ""
set_interface_property urg_sink PORT_NAME_MAP ""
set_interface_property urg_sink CMSIS_SVD_VARIABLES ""
set_interface_property urg_sink SVD_ADDRESS_GROUP ""

add_interface_port urg_sink urg_data data Input IN_URG_DATA_W
add_interface_port urg_sink urg_valid valid Input 1
add_interface_port urg_sink urg_startofpacket startofpacket Input 1
add_interface_port urg_sink urg_endofpacket endofpacket Input 1
add_interface_port urg_sink urg_ready ready Output 1


# 
# connection point cmd_req
# 
add_interface cmd_req avalon_streaming end
set_interface_property cmd_req associatedClock clock
set_interface_property cmd_req associatedReset reset
set_interface_property cmd_req dataBitsPerSymbol 38
set_interface_property cmd_req errorDescriptor ""
set_interface_property cmd_req firstSymbolInHighOrderBits true
set_interface_property cmd_req maxChannel 0
set_interface_property cmd_req readyLatency 0
set_interface_property cmd_req ENABLED true
set_interface_property cmd_req EXPORT_OF ""
set_interface_property cmd_req PORT_NAME_MAP ""
set_interface_property cmd_req CMSIS_SVD_VARIABLES ""
set_interface_property cmd_req SVD_ADDRESS_GROUP ""

add_interface_port cmd_req cmd_req_data data Input IN_REQ_DATA_W
add_interface_port cmd_req cmd_req_valid valid Input 1
add_interface_port cmd_req cmd_req_ready ready Output 1


# 
# connection point rd_req
# 
add_interface rd_req avalon_streaming end
set_interface_property rd_req associatedClock clock
set_interface_property rd_req associatedReset reset
set_interface_property rd_req dataBitsPerSymbol 38
set_interface_property rd_req errorDescriptor ""
set_interface_property rd_req firstSymbolInHighOrderBits true
set_interface_property rd_req maxChannel 0
set_interface_property rd_req readyLatency 0
set_interface_property rd_req ENABLED true
set_interface_property rd_req EXPORT_OF ""
set_interface_property rd_req PORT_NAME_MAP ""
set_interface_property rd_req CMSIS_SVD_VARIABLES ""
set_interface_property rd_req SVD_ADDRESS_GROUP ""

add_interface_port rd_req rd_req_data data Input IN_RD_DATA_W
add_interface_port rd_req rd_req_valid valid Input 1
add_interface_port rd_req rd_req_ready ready Output 1

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaborate {} {

   	set st_in_cmd_data_width [ get_parameter_value IN_CMD_DATA_W ]
   	set st_in_cmd_req_width [ get_parameter_value IN_REQ_DATA_W ]
   	set st_in_urg_data_width [ get_parameter_value IN_URG_DATA_W ]
   	set st_in_rd_data_width [ get_parameter_value IN_RD_DATA_W ]
   	set st_out_data_width [ get_parameter_value OUT_DATA_W ]
   	   
   	set_interface_property cmd_sink dataBitsPerSymbol $st_in_cmd_data_width
	set_interface_property urg_sink dataBitsPerSymbol $st_in_urg_data_width
	set_interface_property cmd_req dataBitsPerSymbol $st_in_cmd_req_width	
	set_interface_property rd_req dataBitsPerSymbol $st_in_rd_data_width
	set_interface_property src dataBitsPerSymbol $st_out_data_width
	
	add_interface_port cmd_sink cmd_data data Input $st_in_cmd_data_width
	add_interface_port urg_sink urg_data data Input $st_in_urg_data_width
	add_interface_port cmd_req cmd_req_data data Input $st_in_cmd_req_width
	add_interface_port rd_req rd_req_data data Input $st_in_rd_data_width
	add_interface_port src src_data data Output $st_out_data_width
}

