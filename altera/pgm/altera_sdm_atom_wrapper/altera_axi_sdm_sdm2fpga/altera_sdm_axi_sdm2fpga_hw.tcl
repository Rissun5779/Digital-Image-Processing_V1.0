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


# $Id: //acds/rel/18.1std/ip/pgm/altera_sdm_atom_wrapper/altera_axi_sdm_sdm2fpga/altera_sdm_axi_sdm2fpga_hw.tcl#1 $
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
set_module_property NAME altera_sdm_axi_sdm2fpga
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property VERSION 18.1
set_module_property GROUP 	"Basic Functions/Configuration and Programming"
set_module_property AUTHOR 	"Altera Corporation"
set_module_property DISPLAY_NAME "Altera SDM2FPGA Bridge"
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
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_sdm_axi_sdm2fpga
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_sdm_axi_sdm2fpga.sv SYSTEM_VERILOG PATH altera_sdm_axi_sdm2fpga.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_sdm_axi_sdm2fpga
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_sdm_axi_sdm2fpga.sv SYSTEM_VERILOG PATH altera_sdm_axi_sdm2fpga.sv


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

add_interface_port axi_master aw_id awid Output 4
add_interface_port axi_master aw_addr awaddr Output 32
add_interface_port axi_master aw_len awlen Output 8
add_interface_port axi_master aw_size awsize Output 3
add_interface_port axi_master aw_burst awburst Output 2
add_interface_port axi_master aw_lock awlock Output 1
add_interface_port axi_master aw_cache awcache Output 4
add_interface_port axi_master aw_prot awprot Output 3
add_interface_port axi_master aw_qos awqos Output 4
add_interface_port axi_master aw_valid awvalid Output 1
add_interface_port axi_master aw_user awuser Output 5
add_interface_port axi_master aw_ready awready Input 1
add_interface_port axi_master w_data wdata Output 64
add_interface_port axi_master w_last wlast Output 1
add_interface_port axi_master w_ready wready Input 1
add_interface_port axi_master w_valid wvalid Output 1
add_interface_port axi_master w_strb wstrb Output (64/8)
add_interface_port axi_master b_id bid Input 4
add_interface_port axi_master b_resp bresp Input 2
add_interface_port axi_master b_valid bvalid Input 1
add_interface_port axi_master b_ready bready Output 1
add_interface_port axi_master r_data rdata Input 64
add_interface_port axi_master r_resp rresp Input 2
add_interface_port axi_master r_last rlast Input 1
add_interface_port axi_master r_valid rvalid Input 1
add_interface_port axi_master r_ready rready Output 1
add_interface_port axi_master ar_id arid Output 4
add_interface_port axi_master ar_addr araddr Output 32
add_interface_port axi_master ar_len arlen Output 8
add_interface_port axi_master ar_size arsize Output 3
add_interface_port axi_master ar_burst arburst Output 2
add_interface_port axi_master ar_lock arlock Output 1
add_interface_port axi_master ar_cache arcache Output 4
add_interface_port axi_master ar_prot arprot Output 3
add_interface_port axi_master ar_qos arqos Output 4
add_interface_port axi_master ar_valid arvalid Output 1
add_interface_port axi_master ar_user aruser Output 5
add_interface_port axi_master ar_ready arready Input 1
add_interface_port axi_master r_id rid Input 4


