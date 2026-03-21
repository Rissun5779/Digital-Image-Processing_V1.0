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


# $Id: //acds/rel/18.1std/ip/pgm/altera_sdm_atom_wrapper/altera_axi_sdm_fpga2sdm/altera_sdm_axi_fpga2sdm_hw.tcl#1 $
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
set_module_property NAME altera_sdm_axi_fpga2sdm
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property VERSION 18.1
set_module_property GROUP 	"Basic Functions/Configuration and Programming"
set_module_property AUTHOR 	"Altera Corporation"
set_module_property DISPLAY_NAME "Altera FPGA2SDM Bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list
#set_module_property ELABORATION_CALLBACK elaborate

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_sdm_axi_fpga2sdm
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_sdm_axi_fpga2sdm.sv SYSTEM_VERILOG PATH altera_sdm_axi_fpga2sdm.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_sdm_axi_fpga2sdm
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_sdm_axi_fpga2sdm.sv SYSTEM_VERILOG PATH altera_sdm_axi_fpga2sdm.sv


# 
# parameters
# 


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

add_interface_port axi_slave aw_id awid Input 4
add_interface_port axi_slave aw_addr awaddr Input 32
add_interface_port axi_slave aw_len awlen Input 8
add_interface_port axi_slave aw_size awsize Input 3
add_interface_port axi_slave aw_burst awburst Input 2
add_interface_port axi_slave aw_lock awlock Input 1
add_interface_port axi_slave aw_cache awcache Input 4
add_interface_port axi_slave aw_prot awprot Input 3
add_interface_port axi_slave aw_qos awqos Input 4
add_interface_port axi_slave aw_valid awvalid Input 1
add_interface_port axi_slave aw_user awuser Input 5
add_interface_port axi_slave aw_ready awready Output 1
add_interface_port axi_slave w_data wdata Input 32
add_interface_port axi_slave w_last wlast Input 1
add_interface_port axi_slave w_ready wready Output 1
add_interface_port axi_slave w_valid wvalid Input 1
add_interface_port axi_slave w_strb wstrb Input 4
add_interface_port axi_slave b_id bid Output 4
add_interface_port axi_slave b_resp bresp Output 2
add_interface_port axi_slave b_valid bvalid Output 1
add_interface_port axi_slave b_ready bready Input 1
add_interface_port axi_slave r_data rdata Output 32
add_interface_port axi_slave r_resp rresp Output 2
add_interface_port axi_slave r_last rlast Output 1
add_interface_port axi_slave r_valid rvalid Output 1
add_interface_port axi_slave r_ready rready Input 1
add_interface_port axi_slave ar_id arid Input 4
add_interface_port axi_slave ar_addr araddr Input 32
add_interface_port axi_slave ar_len arlen Input 8
add_interface_port axi_slave ar_size arsize Input 3
add_interface_port axi_slave ar_burst arburst Input 2
add_interface_port axi_slave ar_lock arlock Input 1
add_interface_port axi_slave ar_cache arcache Input 4
add_interface_port axi_slave ar_prot arprot Input 3
add_interface_port axi_slave ar_qos arqos Input 4
add_interface_port axi_slave ar_valid arvalid Input 1
add_interface_port axi_slave ar_user aruser Input 5
add_interface_port axi_slave ar_ready arready Output 1
add_interface_port axi_slave r_id rid Output 4