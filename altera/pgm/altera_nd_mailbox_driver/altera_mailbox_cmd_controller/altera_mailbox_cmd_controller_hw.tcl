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


# $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_driver/altera_mailbox_cmd_controller/altera_mailbox_cmd_controller_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# 
# altera_mailbox_cmd_controller "Altera Mailbox Cmd Controller" v15.1
#  2015.07.15.00:46:47
# 
# 

# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.1


# 
# module altera_mailbox_cmd_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_mailbox_cmd_controller
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property VERSION 18.1
set_module_property GROUP 	"Basic Functions/Configuration and Programming"
set_module_property AUTHOR 	"Altera Corporation"
set_module_property DISPLAY_NAME "Altera Mailbox Command Controller"
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
add_fileset synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
set_fileset_property synthesis_fileset TOP_LEVEL altera_mailbox_cmd_controller 
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL altera_mailbox_cmd_controller
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure
set_fileset_property vhdl_fileset TOP_LEVEL altera_mailbox_cmd_controller

proc synth_callback_procedure { entity_name } {
    add_fileset_file altera_mailbox_cmd_controller.sv SYSTEM_VERILOG PATH "altera_mailbox_cmd_controller.sv"
	add_fileset_file altera_avalon_sc_fifo_export_fill_level.sv SYSTEM_VERILOG PATH "altera_avalon_sc_fifo_export_fill_level.sv"
	add_fileset_file rout_update_detector.sv SYSTEM_VERILOG PATH "rout_update_detector.sv"
}

# 
# parameters
# 
add_parameter COMMAND_WIDTH INTEGER 32
set_parameter_property COMMAND_WIDTH DEFAULT_VALUE 32
set_parameter_property COMMAND_WIDTH DISPLAY_NAME COMMAND_WIDTH
set_parameter_property COMMAND_WIDTH TYPE INTEGER
set_parameter_property COMMAND_WIDTH UNITS None
set_parameter_property COMMAND_WIDTH HDL_PARAMETER true
add_parameter REQ_WIDTH INTEGER 6
set_parameter_property REQ_WIDTH DEFAULT_VALUE 6
set_parameter_property REQ_WIDTH DISPLAY_NAME REQ_WIDTH
set_parameter_property REQ_WIDTH TYPE INTEGER
set_parameter_property REQ_WIDTH UNITS None
set_parameter_property REQ_WIDTH HDL_PARAMETER true
add_parameter WAITING_TIME INTEGER 10
set_parameter_property WAITING_TIME DEFAULT_VALUE 10
set_parameter_property WAITING_TIME DISPLAY_NAME WAITING_TIME
set_parameter_property WAITING_TIME TYPE INTEGER
set_parameter_property WAITING_TIME UNITS None
set_parameter_property WAITING_TIME HDL_PARAMETER true
add_parameter OUT_COMMAND_WIDTH INTEGER 64
set_parameter_property OUT_COMMAND_WIDTH DEFAULT_VALUE 64
set_parameter_property OUT_COMMAND_WIDTH DISPLAY_NAME OUT_COMMAND_WIDTH
set_parameter_property OUT_COMMAND_WIDTH TYPE INTEGER
set_parameter_property OUT_COMMAND_WIDTH UNITS None
set_parameter_property OUT_COMMAND_WIDTH HDL_PARAMETER true


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
# connection point in_cmd
# 
add_interface in_cmd avalon_streaming end
set_interface_property in_cmd associatedClock clock
set_interface_property in_cmd associatedReset reset
set_interface_property in_cmd dataBitsPerSymbol 31
set_interface_property in_cmd errorDescriptor ""
set_interface_property in_cmd firstSymbolInHighOrderBits true
set_interface_property in_cmd maxChannel 0
set_interface_property in_cmd readyLatency 0
set_interface_property in_cmd ENABLED true
set_interface_property in_cmd EXPORT_OF ""
set_interface_property in_cmd PORT_NAME_MAP ""
set_interface_property in_cmd CMSIS_SVD_VARIABLES ""
set_interface_property in_cmd SVD_ADDRESS_GROUP ""

add_interface_port in_cmd in_valid valid Input 1
add_interface_port in_cmd in_startofpacket startofpacket Input 1
add_interface_port in_cmd in_endofpacket endofpacket Input 1
add_interface_port in_cmd in_ready ready Output 1
add_interface_port in_cmd in_data data Input COMMAND_WIDTH


# 
# connection point out_cmd
# 
add_interface out_cmd avalon_streaming start
set_interface_property out_cmd associatedClock clock
set_interface_property out_cmd associatedReset reset
set_interface_property out_cmd dataBitsPerSymbol 63
set_interface_property out_cmd errorDescriptor ""
set_interface_property out_cmd firstSymbolInHighOrderBits true
set_interface_property out_cmd maxChannel 0
set_interface_property out_cmd readyLatency 0
set_interface_property out_cmd ENABLED true
set_interface_property out_cmd EXPORT_OF ""
set_interface_property out_cmd PORT_NAME_MAP ""
set_interface_property out_cmd CMSIS_SVD_VARIABLES ""
set_interface_property out_cmd SVD_ADDRESS_GROUP ""

add_interface_port out_cmd out_endofpacket endofpacket Output 1
add_interface_port out_cmd out_data data Output OUT_COMMAND_WIDTH
add_interface_port out_cmd out_valid valid Output 1
add_interface_port out_cmd out_startofpacket startofpacket Output 1
add_interface_port out_cmd out_ready ready Input 1


# 
# connection point cmd_req
# 
add_interface cmd_req avalon_streaming start
set_interface_property cmd_req associatedClock clock
set_interface_property cmd_req associatedReset reset
set_interface_property cmd_req dataBitsPerSymbol 5
set_interface_property cmd_req errorDescriptor ""
set_interface_property cmd_req firstSymbolInHighOrderBits true
set_interface_property cmd_req maxChannel 0
set_interface_property cmd_req readyLatency 0
set_interface_property cmd_req ENABLED true
set_interface_property cmd_req EXPORT_OF ""
set_interface_property cmd_req PORT_NAME_MAP ""
set_interface_property cmd_req CMSIS_SVD_VARIABLES ""
set_interface_property cmd_req SVD_ADDRESS_GROUP ""

add_interface_port cmd_req req_data data Output REQ_WIDTH-1
add_interface_port cmd_req req_valid valid Output 1
add_interface_port cmd_req req_ready ready Input 1


# 
# connection point gpo_write
# 
add_interface gpo_write conduit end
set_interface_property gpo_write associatedClock clock
set_interface_property gpo_write associatedReset reset
set_interface_property gpo_write ENABLED true
set_interface_property gpo_write EXPORT_OF ""
set_interface_property gpo_write PORT_NAME_MAP ""
set_interface_property gpo_write CMSIS_SVD_VARIABLES ""
set_interface_property gpo_write SVD_ADDRESS_GROUP ""

add_interface_port gpo_write gpo_write gpo_write Input 1


# 
# connection point gpo_data
# 
add_interface gpo_data conduit end
set_interface_property gpo_data associatedClock clock
set_interface_property gpo_data associatedReset reset
set_interface_property gpo_data ENABLED true
set_interface_property gpo_data EXPORT_OF ""
set_interface_property gpo_data PORT_NAME_MAP ""
set_interface_property gpo_data CMSIS_SVD_VARIABLES ""
set_interface_property gpo_data SVD_ADDRESS_GROUP ""

add_interface_port gpo_data gpo_data gpo_data Input 8


# 
# connection point rout_update
# 
add_interface rout_update conduit end
set_interface_property rout_update associatedClock clock
set_interface_property rout_update associatedReset reset
set_interface_property rout_update ENABLED true
set_interface_property rout_update EXPORT_OF ""
set_interface_property rout_update PORT_NAME_MAP ""
set_interface_property rout_update CMSIS_SVD_VARIABLES ""
set_interface_property rout_update SVD_ADDRESS_GROUP ""

add_interface_port rout_update rout_update rout_update Input 1

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaborate {} {

   	set st_in_cmd_data_width [ get_parameter_value COMMAND_WIDTH ]
   	set st_in_cmd_req_width [ get_parameter_value REQ_WIDTH ]
   	set st_out_cmd_data_width [ get_parameter_value OUT_COMMAND_WIDTH ]
   	   
   	set_interface_property in_cmd dataBitsPerSymbol $st_in_cmd_data_width
	set_interface_property out_cmd dataBitsPerSymbol $st_out_cmd_data_width
	set_interface_property cmd_req dataBitsPerSymbol $st_in_cmd_req_width
	add_interface_port in_cmd in_data data Input $st_in_cmd_data_width
	add_interface_port out_cmd out_data data Output $st_out_cmd_data_width
	add_interface_port cmd_req req_data data Output $st_in_cmd_req_width
}

