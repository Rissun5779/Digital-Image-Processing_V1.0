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


# $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_driver/altera_mailbox_avst_to_axi_conversion/altera_mailbox_avst_to_axi_conversion_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# 
# altera_mailbox_avst_axi_conversion "Altera Mailbox AVST AXI Conversion" v15.1
#  2015.07.15.01:14:22
# 
# 

# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.1


# 
# module altera_mailbox_avst_axi_conversion
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_mailbox_avst_to_axi_conversion
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property VERSION 18.1
set_module_property GROUP 	"Basic Functions/Configuration and Programming"
set_module_property AUTHOR 	"Altera Corporation"
set_module_property DISPLAY_NAME "Altera Mailbox AVST to AXI Conversion"
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
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_mailbox_avst_to_axi_conversion
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_mailbox_avst_to_axi_conversion.sv SYSTEM_VERILOG PATH altera_mailbox_avst_to_axi_conversion.sv TOP_LEVEL_FILE
add_fileset_file axi_slave_network_interface.sv SYSTEM_VERILOG PATH axi_slave_network_interface.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_mailbox_avst_to_axi_conversion
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_mailbox_avst_to_axi_conversion.sv SYSTEM_VERILOG PATH altera_mailbox_avst_to_axi_conversion.sv
add_fileset_file axi_slave_network_interface.sv SYSTEM_VERILOG PATH axi_slave_network_interface.sv



# 
# parameters
# 
add_parameter IN_ST_DATA_W INTEGER 75
set_parameter_property IN_ST_DATA_W DEFAULT_VALUE 75
set_parameter_property IN_ST_DATA_W DISPLAY_NAME IN_ST_DATA_W
set_parameter_property IN_ST_DATA_W TYPE INTEGER
set_parameter_property IN_ST_DATA_W UNITS None
set_parameter_property IN_ST_DATA_W HDL_PARAMETER true
add_parameter OUT_ST_DATA_W INTEGER 112
set_parameter_property OUT_ST_DATA_W DEFAULT_VALUE 112
set_parameter_property OUT_ST_DATA_W DISPLAY_NAME OUT_ST_DATA_W
set_parameter_property OUT_ST_DATA_W TYPE INTEGER
set_parameter_property OUT_ST_DATA_W UNITS None
set_parameter_property OUT_ST_DATA_W HDL_PARAMETER true
add_parameter COMMAND_WIDTH INTEGER 32
set_parameter_property COMMAND_WIDTH DEFAULT_VALUE 32
set_parameter_property COMMAND_WIDTH DISPLAY_NAME COMMAND_WIDTH
set_parameter_property COMMAND_WIDTH TYPE INTEGER
set_parameter_property COMMAND_WIDTH ENABLED false
set_parameter_property COMMAND_WIDTH UNITS None
set_parameter_property COMMAND_WIDTH HDL_PARAMETER true
add_parameter RSP_ST_W INTEGER 32
set_parameter_property RSP_ST_W DEFAULT_VALUE 32
set_parameter_property RSP_ST_W DISPLAY_NAME RSP_ST_W
set_parameter_property RSP_ST_W TYPE INTEGER
set_parameter_property RSP_ST_W ENABLED false
set_parameter_property RSP_ST_W UNITS None
set_parameter_property RSP_ST_W HDL_PARAMETER true
add_parameter REQ_WIDTH INTEGER 38
set_parameter_property REQ_WIDTH DEFAULT_VALUE 38
set_parameter_property REQ_WIDTH DISPLAY_NAME REQ_WIDTH
set_parameter_property REQ_WIDTH TYPE INTEGER
set_parameter_property REQ_WIDTH ENABLED false
set_parameter_property REQ_WIDTH UNITS None
set_parameter_property REQ_WIDTH HDL_PARAMETER true
add_parameter WAITING_TIME INTEGER 10
set_parameter_property WAITING_TIME DEFAULT_VALUE 10
set_parameter_property WAITING_TIME DISPLAY_NAME WAITING_TIME
set_parameter_property WAITING_TIME TYPE INTEGER
set_parameter_property WAITING_TIME ENABLED false
set_parameter_property WAITING_TIME UNITS None
set_parameter_property WAITING_TIME HDL_PARAMETER true
add_parameter ADDR_W INTEGER 32
set_parameter_property ADDR_W DEFAULT_VALUE 32
set_parameter_property ADDR_W DISPLAY_NAME ADDR_W
set_parameter_property ADDR_W TYPE INTEGER
set_parameter_property ADDR_W ENABLED false
set_parameter_property ADDR_W UNITS None
set_parameter_property ADDR_W HDL_PARAMETER true
add_parameter DATA_W INTEGER 64
set_parameter_property DATA_W DEFAULT_VALUE 64
set_parameter_property DATA_W DISPLAY_NAME DATA_W
set_parameter_property DATA_W TYPE INTEGER
set_parameter_property DATA_W ENABLED false
set_parameter_property DATA_W UNITS None
set_parameter_property DATA_W HDL_PARAMETER true
add_parameter ID_W INTEGER 4
set_parameter_property ID_W DEFAULT_VALUE 4
set_parameter_property ID_W DISPLAY_NAME ID_W
set_parameter_property ID_W TYPE INTEGER
set_parameter_property ID_W ENABLED false
set_parameter_property ID_W UNITS None
set_parameter_property ID_W HDL_PARAMETER true
add_parameter USER_W INTEGER 5
set_parameter_property USER_W DEFAULT_VALUE 5
set_parameter_property USER_W DISPLAY_NAME USER_W
set_parameter_property USER_W TYPE INTEGER
set_parameter_property USER_W ENABLED false
set_parameter_property USER_W UNITS None
set_parameter_property USER_W HDL_PARAMETER true


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
set_interface_property in_cmd dataBitsPerSymbol 75
set_interface_property in_cmd errorDescriptor ""
set_interface_property in_cmd firstSymbolInHighOrderBits true
set_interface_property in_cmd maxChannel 0
set_interface_property in_cmd readyLatency 0
set_interface_property in_cmd ENABLED true
set_interface_property in_cmd EXPORT_OF ""
set_interface_property in_cmd PORT_NAME_MAP ""
set_interface_property in_cmd CMSIS_SVD_VARIABLES ""
set_interface_property in_cmd SVD_ADDRESS_GROUP ""

add_interface_port in_cmd in_data data Input IN_ST_DATA_W
add_interface_port in_cmd in_valid valid Input 1
add_interface_port in_cmd in_startofpacket startofpacket Input 1
add_interface_port in_cmd in_endofpacket endofpacket Input 1
add_interface_port in_cmd in_ready ready Output 1


# 
# connection point axi_master
# 
add_interface axi_master axi4 start
set_interface_property axi_master associatedClock clock
set_interface_property axi_master associatedReset reset
set_interface_property axi_master readIssuingCapability 1
set_interface_property axi_master writeIssuingCapability 1
set_interface_property axi_master combinedIssuingCapability 1
set_interface_property axi_master ENABLED true
set_interface_property axi_master EXPORT_OF ""
set_interface_property axi_master PORT_NAME_MAP ""
set_interface_property axi_master CMSIS_SVD_VARIABLES ""
set_interface_property axi_master SVD_ADDRESS_GROUP ""

add_interface_port axi_master aw_id awid Output ID_W
add_interface_port axi_master aw_addr awaddr Output ADDR_W
add_interface_port axi_master aw_len awlen Output 8
add_interface_port axi_master aw_size awsize Output 3
add_interface_port axi_master aw_burst awburst Output 2
add_interface_port axi_master aw_lock awlock Output 1
add_interface_port axi_master aw_cache awcache Output 4
add_interface_port axi_master aw_prot awprot Output 3
add_interface_port axi_master aw_qos awqos Output 4
add_interface_port axi_master aw_valid awvalid Output 1
add_interface_port axi_master aw_user awuser Output USER_W
add_interface_port axi_master aw_ready awready Input 1
add_interface_port axi_master w_data wdata Output DATA_W
add_interface_port axi_master w_last wlast Output 1
add_interface_port axi_master w_ready wready Input 1
add_interface_port axi_master w_valid wvalid Output 1
add_interface_port axi_master w_strb wstrb Output (DATA_W/8)
add_interface_port axi_master b_id bid Input ID_W
add_interface_port axi_master b_resp bresp Input 2
add_interface_port axi_master b_valid bvalid Input 1
add_interface_port axi_master b_ready bready Output 1
add_interface_port axi_master r_data rdata Input DATA_W
add_interface_port axi_master r_resp rresp Input 2
add_interface_port axi_master r_last rlast Input 1
add_interface_port axi_master r_valid rvalid Input 1
add_interface_port axi_master r_ready rready Output 1
add_interface_port axi_master ar_id arid Output ID_W
add_interface_port axi_master ar_addr araddr Output ADDR_W
add_interface_port axi_master ar_len arlen Output 8
add_interface_port axi_master ar_size arsize Output 3
add_interface_port axi_master ar_burst arburst Output 2
add_interface_port axi_master ar_lock arlock Output 1
add_interface_port axi_master ar_cache arcache Output 4
add_interface_port axi_master ar_prot arprot Output 3
add_interface_port axi_master ar_qos arqos Output 4
add_interface_port axi_master ar_valid arvalid Output 1
add_interface_port axi_master ar_user aruser Output "(USER_W) - (0) + 1"
add_interface_port axi_master ar_ready arready Input 1
add_interface_port axi_master r_id rid Input ID_W

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaborate {} {

   	set st_in_data_width [ get_parameter_value IN_ST_DATA_W ]
   	   
   	set_interface_property in_cmd dataBitsPerSymbol $st_in_data_width

	add_interface_port in_cmd in_data data Input $st_in_data_width
}
