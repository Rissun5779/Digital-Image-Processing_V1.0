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


# $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_driver/altera_mailbox_streaming_controller/altera_mailbox_streaming_controller_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $


# 
# altera_mailbox_str_controller "Altera Mailbox Stream Controller" v15.1
#  2015.07.16.20:12:13
# 
# 

# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.1


# 
# module altera_mailbox_str_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_mailbox_streaming_controller
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property VERSION 18.1
set_module_property GROUP 	"Basic Functions/Configuration and Programming"
set_module_property AUTHOR 	"Altera Corporation"
set_module_property DISPLAY_NAME "Altera Mailbox Streaming Controller"
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
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_mailbox_streaming_controller
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_mailbox_str_controller.sv SYSTEM_VERILOG PATH altera_mailbox_str_controller.sv 
add_fileset_file altera_mailbox_str_read_slave.sv SYSTEM_VERILOG PATH altera_mailbox_str_read_slave.sv
add_fileset_file altera_mailbox_streaming_controller.sv SYSTEM_VERILOG PATH altera_mailbox_streaming_controller.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_mailbox_streaming_controller
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_mailbox_str_controller.sv SYSTEM_VERILOG PATH altera_mailbox_str_controller.sv
add_fileset_file altera_mailbox_str_read_slave.sv SYSTEM_VERILOG PATH altera_mailbox_str_read_slave.sv
add_fileset_file altera_mailbox_streaming_controller.sv SYSTEM_VERILOG PATH altera_mailbox_streaming_controller.sv 

# 
# parameters
# 
add_parameter STR_PCK_WIDTH INTEGER 32
set_parameter_property STR_PCK_WIDTH DEFAULT_VALUE 32
set_parameter_property STR_PCK_WIDTH DISPLAY_NAME STR_PCK_WIDTH
set_parameter_property STR_PCK_WIDTH TYPE INTEGER
set_parameter_property STR_PCK_WIDTH UNITS None
set_parameter_property STR_PCK_WIDTH HDL_PARAMETER true
add_parameter NUMB_4K_BLOCK INTEGER 4
set_parameter_property NUMB_4K_BLOCK DEFAULT_VALUE 4
set_parameter_property NUMB_4K_BLOCK DISPLAY_NAME NUMB_4K_BLOCK
set_parameter_property NUMB_4K_BLOCK TYPE INTEGER
set_parameter_property NUMB_4K_BLOCK UNITS None
set_parameter_property NUMB_4K_BLOCK HDL_PARAMETER true
add_parameter GPI_WIDTH INTEGER 4
set_parameter_property GPI_WIDTH DEFAULT_VALUE 4
set_parameter_property GPI_WIDTH DISPLAY_NAME GPI_WIDTH
set_parameter_property GPI_WIDTH TYPE INTEGER
set_parameter_property GPI_WIDTH UNITS None
set_parameter_property GPI_WIDTH HDL_PARAMETER true
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
# connection point gpo
# 
add_interface gpo conduit end
set_interface_property gpo associatedClock clock
set_interface_property gpo associatedReset reset
set_interface_property gpo ENABLED true
set_interface_property gpo EXPORT_OF ""
set_interface_property gpo PORT_NAME_MAP ""
set_interface_property gpo CMSIS_SVD_VARIABLES ""
set_interface_property gpo SVD_ADDRESS_GROUP ""

add_interface_port gpo gpo_write gpo_write Input 1
add_interface_port gpo gpo_data gpo_data Input 8


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

add_interface_port in_data in_data data Input STR_PCK_WIDTH
add_interface_port in_data in_valid valid Input 1
add_interface_port in_data in_startofpacket startofpacket Input 1
add_interface_port in_data in_endofpacket endofpacket Input 1
add_interface_port in_data in_ready ready Output 1


# 
# connection point gpi
# 
add_interface gpi conduit end
set_interface_property gpi associatedClock clock
set_interface_property gpi associatedReset ""
set_interface_property gpi ENABLED true
set_interface_property gpi EXPORT_OF ""
set_interface_property gpi PORT_NAME_MAP ""
set_interface_property gpi CMSIS_SVD_VARIABLES ""
set_interface_property gpi SVD_ADDRESS_GROUP ""

add_interface_port gpi gpi_data gpi_data Output 4


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint ""
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender associatedReset reset
set_interface_property interrupt_sender bridgedReceiverOffset ""
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender gpi_interrupt irq Output 1


# 
# connection point stream_select
# 
add_interface stream_select conduit end
set_interface_property stream_select associatedClock clock
set_interface_property stream_select associatedReset reset
set_interface_property stream_select ENABLED true
set_interface_property stream_select EXPORT_OF ""
set_interface_property stream_select PORT_NAME_MAP ""
set_interface_property stream_select CMSIS_SVD_VARIABLES ""
set_interface_property stream_select SVD_ADDRESS_GROUP ""

add_interface_port stream_select stream_select stream_select Output 4

add_interface stream_active conduit end
set_interface_property stream_active associatedClock clock
set_interface_property stream_active associatedReset reset
set_interface_property stream_active ENABLED true
set_interface_property stream_active EXPORT_OF ""
set_interface_property stream_active PORT_NAME_MAP ""
set_interface_property stream_active CMSIS_SVD_VARIABLES ""
set_interface_property stream_active SVD_ADDRESS_GROUP ""

add_interface_port stream_active stream_active stream_active Output 1

# 
# connection point axi_slave
# 
add_interface axi_slave axi4 end
set_interface_property axi_slave associatedClock clock
set_interface_property axi_slave associatedReset reset
set_interface_property axi_slave readAcceptanceCapability 1
set_interface_property axi_slave writeAcceptanceCapability 1
set_interface_property axi_slave combinedAcceptanceCapability 1
set_interface_property axi_slave ENABLED true
set_interface_property axi_slave EXPORT_OF ""
set_interface_property axi_slave PORT_NAME_MAP ""
set_interface_property axi_slave CMSIS_SVD_VARIABLES ""
set_interface_property axi_slave SVD_ADDRESS_GROUP ""

add_interface_port axi_slave aw_id awid Input ID_W
add_interface_port axi_slave aw_addr awaddr Input ADDR_W
add_interface_port axi_slave aw_len awlen Input 8
add_interface_port axi_slave aw_size awsize Input 3
add_interface_port axi_slave aw_burst awburst Input 2
add_interface_port axi_slave aw_lock awlock Input 1
add_interface_port axi_slave aw_cache awcache Input 4
add_interface_port axi_slave aw_prot awprot Input 3
add_interface_port axi_slave aw_qos awqos Input 4
add_interface_port axi_slave aw_valid awvalid Input 1
add_interface_port axi_slave aw_user awuser Input USER_W
add_interface_port axi_slave aw_ready awready Output 1
add_interface_port axi_slave w_data wdata Input DATA_W
add_interface_port axi_slave w_last wlast Input 1
add_interface_port axi_slave w_ready wready Output 1
add_interface_port axi_slave w_valid wvalid Input 1
add_interface_port axi_slave w_strb wstrb Input (DATA_W/8)
add_interface_port axi_slave b_id bid Output ID_W
add_interface_port axi_slave b_resp bresp Output 2
add_interface_port axi_slave b_valid bvalid Output 1
add_interface_port axi_slave b_ready bready Input 1
add_interface_port axi_slave r_data rdata Output DATA_W
add_interface_port axi_slave r_resp rresp Output 2
add_interface_port axi_slave r_last rlast Output 1
add_interface_port axi_slave r_valid rvalid Output 1
add_interface_port axi_slave r_ready rready Input 1
add_interface_port axi_slave ar_id arid Input ID_W
add_interface_port axi_slave ar_addr araddr Input ADDR_W
add_interface_port axi_slave ar_len arlen Input 8
add_interface_port axi_slave ar_size arsize Input 3
add_interface_port axi_slave ar_burst arburst Input 2
add_interface_port axi_slave ar_lock arlock Input 1
add_interface_port axi_slave ar_cache arcache Input 4
add_interface_port axi_slave ar_prot arprot Input 3
add_interface_port axi_slave ar_qos arqos Input 4
add_interface_port axi_slave ar_valid arvalid Input 1
add_interface_port axi_slave ar_user aruser Input USER_W
add_interface_port axi_slave ar_ready arready Output 1
add_interface_port axi_slave r_id rid Output ID_W

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaborate {} {

   	set st_data_width [ get_parameter_value STR_PCK_WIDTH ]
   	   
   	set_interface_property in_data dataBitsPerSymbol $st_data_width
	add_interface_port in_data in_data data Input $st_data_width

}
