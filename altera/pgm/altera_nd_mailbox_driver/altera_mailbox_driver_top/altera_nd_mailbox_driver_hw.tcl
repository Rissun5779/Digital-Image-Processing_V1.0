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


# $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_driver/altera_mailbox_driver_top/altera_nd_mailbox_driver_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# 
# altera_nd_mailbox_driver "Altera Mailbox Driver" v1.0
#  2015.07.29.12:46:04
# 
# 

# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.1


# 
# module altera_nd_mailbox_driver
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_nd_mailbox_driver
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property VERSION 18.1
set_module_property GROUP 	"Basic Functions/Configuration and Programming"
set_module_property AUTHOR 	"Altera Corporation"
set_module_property DISPLAY_NAME "Altera Mailbox Driver"
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
set_fileset_property synthesis_fileset TOP_LEVEL altera_nd_mailbox_driver 
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL altera_nd_mailbox_driver
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure
set_fileset_property vhdl_fileset TOP_LEVEL altera_nd_mailbox_driver

proc synth_callback_procedure { entity_name } {
    add_fileset_file altera_nd_mailbox_driver.sv SYSTEM_VERILOG PATH "altera_nd_mailbox_driver.sv"
	add_fileset_file altera_mailbox_avst_to_axi_conversion.sv 	SYSTEM_VERILOG PATH "../altera_mailbox_avst_to_axi_conversion/altera_mailbox_avst_to_axi_conversion.sv" 
	add_fileset_file axi_slave_network_interface.sv 			SYSTEM_VERILOG PATH "../altera_mailbox_avst_to_axi_conversion/axi_slave_network_interface.sv"
	add_fileset_file st_pipeline_base.sv 						SYSTEM_VERILOG PATH "../altera_mailbox_avst_to_axi_conversion/st_pipeline_base.sv"
	add_fileset_file altera_mailbox_cmd_controller.sv 			SYSTEM_VERILOG PATH "../altera_mailbox_cmd_controller/altera_mailbox_cmd_controller.sv"
	add_fileset_file altera_avalon_sc_fifo_export_fill_level.sv SYSTEM_VERILOG PATH "../altera_mailbox_cmd_controller/altera_avalon_sc_fifo_export_fill_level.sv"
	add_fileset_file rout_update_detector.sv 					SYSTEM_VERILOG PATH "../altera_mailbox_cmd_controller/rout_update_detector.sv"
	add_fileset_file altera_mailbox_read_controller.sv  		SYSTEM_VERILOG PATH "../altera_mailbox_read_controller/altera_mailbox_read_controller.sv"
	add_fileset_file altera_mailbox_scheduler.sv  				SYSTEM_VERILOG PATH "../altera_mailbox_scheduler/altera_mailbox_scheduler.sv"
	add_fileset_file altera_mailbox_str_controller.sv  			SYSTEM_VERILOG PATH "../altera_mailbox_streaming_controller/altera_mailbox_str_controller.sv"
	add_fileset_file altera_mailbox_str_read_slave.sv 		 	SYSTEM_VERILOG PATH "../altera_mailbox_streaming_controller/altera_mailbox_str_read_slave.sv"
	add_fileset_file altera_mailbox_streaming_controller.sv 	SYSTEM_VERILOG PATH "../altera_mailbox_streaming_controller/altera_mailbox_streaming_controller.sv"
	add_fileset_file altera_mailbox_urg_controller.sv 			SYSTEM_VERILOG PATH "../altera_mailbox_urgent_controller/altera_mailbox_urg_controller.sv"
 	add_fileset_file altera_avalon_sc_fifo.v	                VERILOG PATH        "../../../sopc_builder_ip/altera_avalon_sc_fifo/altera_avalon_sc_fifo.v"
}


# 
# parameters
# 
add_parameter HAS_URGENT INTEGER 1
set_parameter_property HAS_URGENT DEFAULT_VALUE 1
set_parameter_property HAS_URGENT DISPLAY_NAME HAS_URGENT
set_parameter_property HAS_URGENT TYPE INTEGER
set_parameter_property HAS_URGENT UNITS None
set_parameter_property HAS_URGENT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property HAS_URGENT HDL_PARAMETER true
add_parameter HAS_STREAM INTEGER 1
set_parameter_property HAS_STREAM DEFAULT_VALUE 1
set_parameter_property HAS_STREAM DISPLAY_NAME HAS_STREAM
set_parameter_property HAS_STREAM TYPE INTEGER
set_parameter_property HAS_STREAM UNITS None
set_parameter_property HAS_STREAM ALLOWED_RANGES -2147483648:2147483647
set_parameter_property HAS_STREAM HDL_PARAMETER true
add_parameter GPI_WIDTH INTEGER 4
set_parameter_property GPI_WIDTH DEFAULT_VALUE 4
set_parameter_property GPI_WIDTH DISPLAY_NAME GPI_WIDTH
set_parameter_property GPI_WIDTH TYPE INTEGER
set_parameter_property GPI_WIDTH UNITS None
set_parameter_property GPI_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property GPI_WIDTH HDL_PARAMETER true
add_parameter ADDR_W INTEGER 32
set_parameter_property ADDR_W DEFAULT_VALUE 32
set_parameter_property ADDR_W DISPLAY_NAME ADDR_W
set_parameter_property ADDR_W TYPE INTEGER
set_parameter_property ADDR_W ENABLED false
set_parameter_property ADDR_W UNITS None
set_parameter_property ADDR_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDR_W HDL_PARAMETER true
add_parameter DATA_W INTEGER 64
set_parameter_property DATA_W DEFAULT_VALUE 64
set_parameter_property DATA_W DISPLAY_NAME DATA_W
set_parameter_property DATA_W TYPE INTEGER
set_parameter_property DATA_W ENABLED false
set_parameter_property DATA_W UNITS None
set_parameter_property DATA_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_W HDL_PARAMETER true
add_parameter ID_W INTEGER 4
set_parameter_property ID_W DEFAULT_VALUE 4
set_parameter_property ID_W DISPLAY_NAME ID_W
set_parameter_property ID_W TYPE INTEGER
set_parameter_property ID_W ENABLED false
set_parameter_property ID_W UNITS None
set_parameter_property ID_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ID_W HDL_PARAMETER true
add_parameter USER_W INTEGER 5
set_parameter_property USER_W DEFAULT_VALUE 5
set_parameter_property USER_W DISPLAY_NAME USER_W
set_parameter_property USER_W TYPE INTEGER
set_parameter_property USER_W ENABLED false
set_parameter_property USER_W UNITS None
set_parameter_property USER_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USER_W HDL_PARAMETER true
add_parameter STREAM_WIDTH INTEGER 64 ""
set_parameter_property STREAM_WIDTH DEFAULT_VALUE 64
set_parameter_property STREAM_WIDTH DISPLAY_NAME STREAM_WIDTH
set_parameter_property STREAM_WIDTH TYPE INTEGER
set_parameter_property STREAM_WIDTH UNITS None
set_parameter_property STREAM_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property STREAM_WIDTH DESCRIPTION ""
set_parameter_property STREAM_WIDTH HDL_PARAMETER true

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
set_interface_property axi_slave readDataReorderingDepth 1
set_interface_property axi_slave bridgesToMaster ""
set_interface_property axi_slave ENABLED true
set_interface_property axi_slave EXPORT_OF ""
set_interface_property axi_slave PORT_NAME_MAP ""
set_interface_property axi_slave CMSIS_SVD_VARIABLES ""
set_interface_property axi_slave SVD_ADDRESS_GROUP ""

add_interface_port axi_slave axi_slv_aw_id awid Input ID_W
add_interface_port axi_slave axi_slv_aw_addr awaddr Input ADDR_W
add_interface_port axi_slave axi_slv_aw_len awlen Input 8
add_interface_port axi_slave axi_slv_aw_size awsize Input 3
add_interface_port axi_slave axi_slv_aw_burst awburst Input 2
add_interface_port axi_slave axi_slv_aw_lock awlock Input 1
add_interface_port axi_slave axi_slv_aw_cache awcache Input 4
add_interface_port axi_slave axi_slv_aw_prot awprot Input 3
add_interface_port axi_slave axi_slv_aw_qos awqos Input 4
add_interface_port axi_slave axi_slv_aw_valid awvalid Input 1
add_interface_port axi_slave axi_slv_aw_user awuser Input USER_W
add_interface_port axi_slave axi_slv_aw_ready awready Output 1
#add_interface_port axi_slave axi_slv_w_data wdata Input DATA_W
add_interface_port axi_slave axi_slv_w_data wdata Input 64
#add_interface_port axi_slave axi_slv_w_user wuser Input USER_W
add_interface_port axi_slave axi_slv_w_last wlast Input 1
add_interface_port axi_slave axi_slv_w_ready wready Output 1
add_interface_port axi_slave axi_slv_w_valid wvalid Input 1
#add_interface_port axi_slave axi_slv_w_strb wstrb Input (DATA_W/8)
add_interface_port axi_slave axi_slv_w_strb wstrb Input 8
add_interface_port axi_slave axi_slv_b_id bid Output ID_W
add_interface_port axi_slave axi_slv_b_resp bresp Output 2
#add_interface_port axi_slave axi_slv_b_user buser Output USER_W
add_interface_port axi_slave axi_slv_b_valid bvalid Output 1
add_interface_port axi_slave axi_slv_b_ready bready Input 1
add_interface_port axi_slave axi_slv_r_data rdata Output DATA_W
add_interface_port axi_slave axi_slv_r_resp rresp Output 2
#add_interface_port axi_slave axi_slv_r_user ruser Output USER_W
add_interface_port axi_slave axi_slv_r_last rlast Output 1
add_interface_port axi_slave axi_slv_r_valid rvalid Output 1
add_interface_port axi_slave axi_slv_r_ready rready Input 1
add_interface_port axi_slave axi_slv_ar_id arid Input ID_W
add_interface_port axi_slave axi_slv_ar_addr araddr Input ADDR_W
add_interface_port axi_slave axi_slv_ar_len arlen Input 8
add_interface_port axi_slave axi_slv_ar_size arsize Input 3
add_interface_port axi_slave axi_slv_ar_burst arburst Input 2
add_interface_port axi_slave axi_slv_ar_lock arlock Input 1
add_interface_port axi_slave axi_slv_ar_cache arcache Input 4
add_interface_port axi_slave axi_slv_ar_prot arprot Input 3
add_interface_port axi_slave axi_slv_ar_qos arqos Input 4
add_interface_port axi_slave axi_slv_ar_valid arvalid Input 1
add_interface_port axi_slave axi_slv_ar_user aruser Input USER_W
add_interface_port axi_slave axi_slv_ar_ready arready Output 1
add_interface_port axi_slave axi_slv_r_id rid Output ID_W


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

add_interface_port axi_master axi_mstr_aw_id awid Output ID_W
add_interface_port axi_master axi_mstr_aw_addr awaddr Output ADDR_W
add_interface_port axi_master axi_mstr_aw_len awlen Output 8
add_interface_port axi_master axi_mstr_aw_size awsize Output 3
add_interface_port axi_master axi_mstr_aw_burst awburst Output 2
add_interface_port axi_master axi_mstr_aw_lock awlock Output 1
add_interface_port axi_master axi_mstr_aw_cache awcache Output 4
add_interface_port axi_master axi_mstr_aw_prot awprot Output 3
add_interface_port axi_master axi_mstr_aw_qos awqos Output 4
add_interface_port axi_master axi_mstr_aw_valid awvalid Output 1
add_interface_port axi_master axi_mstr_aw_user awuser Output USER_W
add_interface_port axi_master axi_mstr_aw_ready awready Input 1
#add_interface_port axi_master axi_mstr_w_data wdata Output DATA_W
#add_interface_port axi_master axi_mstr_w_strb wstrb Output (DATA_W/8)
add_interface_port axi_master axi_mstr_w_data wdata Output 32
add_interface_port axi_master axi_mstr_w_strb wstrb Output 4
#add_interface_port axi_master axi_mstr_w_user wuser Output USER_W
add_interface_port axi_master axi_mstr_w_last wlast Output 1
add_interface_port axi_master axi_mstr_w_valid wvalid Output 1
add_interface_port axi_master axi_mstr_w_ready wready Input 1
add_interface_port axi_master axi_mstr_b_id bid Input ID_W
add_interface_port axi_master axi_mstr_b_resp bresp Input 2
#add_interface_port axi_master axi_mstr_b_user buser Input USER_W
add_interface_port axi_master axi_mstr_b_valid bvalid Input 1
add_interface_port axi_master axi_mstr_b_ready bready Output 1
add_interface_port axi_master axi_mstr_ar_id arid Output ID_W
add_interface_port axi_master axi_mstr_ar_addr araddr Output ADDR_W
add_interface_port axi_master axi_mstr_ar_len arlen Output 8
add_interface_port axi_master axi_mstr_ar_size arsize Output 3
add_interface_port axi_master axi_mstr_ar_burst arburst Output 2
add_interface_port axi_master axi_mstr_ar_lock arlock Output 1
add_interface_port axi_master axi_mstr_ar_cache arcache Output 4
add_interface_port axi_master axi_mstr_ar_prot arprot Output 3
add_interface_port axi_master axi_mstr_ar_qos arqos Output 4
add_interface_port axi_master axi_mstr_ar_valid arvalid Output 1
add_interface_port axi_master axi_mstr_ar_user aruser Output USER_W
add_interface_port axi_master axi_mstr_r_id rid Input ID_W
add_interface_port axi_master axi_mstr_ar_ready arready Input 1
add_interface_port axi_master axi_mstr_r_data rdata Input 32
#add_interface_port axi_master axi_mstr_r_data rdata Input DATA_W
add_interface_port axi_master axi_mstr_r_resp rresp Input 2
#add_interface_port axi_master axi_mstr_r_user ruser Input USER_W
add_interface_port axi_master axi_mstr_r_last rlast Input 1
add_interface_port axi_master axi_mstr_r_valid rvalid Input 1
add_interface_port axi_master axi_mstr_r_ready rready Output 1


# 
# connection point command_packet
# 
add_interface command_packet avalon_streaming end
set_interface_property command_packet associatedClock clock
set_interface_property command_packet associatedReset reset
set_interface_property command_packet dataBitsPerSymbol 32
set_interface_property command_packet errorDescriptor ""
set_interface_property command_packet firstSymbolInHighOrderBits true
set_interface_property command_packet maxChannel 0
set_interface_property command_packet readyLatency 0
set_interface_property command_packet ENABLED true
set_interface_property command_packet EXPORT_OF ""
set_interface_property command_packet PORT_NAME_MAP ""
set_interface_property command_packet CMSIS_SVD_VARIABLES ""
set_interface_property command_packet SVD_ADDRESS_GROUP ""

add_interface_port command_packet cmd_pck_valid valid Input 1
add_interface_port command_packet cmd_pck_startofpacket startofpacket Input 1
add_interface_port command_packet cmd_pck_endofpacket endofpacket Input 1
add_interface_port command_packet cmd_pck_ready ready Output 1
add_interface_port command_packet cmd_pck_data data Input 32


# 
# connection point response_packet
# 
add_interface response_packet avalon_streaming start
set_interface_property response_packet associatedClock clock
set_interface_property response_packet associatedReset reset
set_interface_property response_packet dataBitsPerSymbol 32
set_interface_property response_packet errorDescriptor ""
set_interface_property response_packet firstSymbolInHighOrderBits true
set_interface_property response_packet maxChannel 0
set_interface_property response_packet readyLatency 0
set_interface_property response_packet ENABLED true
set_interface_property response_packet EXPORT_OF ""
set_interface_property response_packet PORT_NAME_MAP ""
set_interface_property response_packet CMSIS_SVD_VARIABLES ""
set_interface_property response_packet SVD_ADDRESS_GROUP ""

add_interface_port response_packet rsp_pck_startofpacket startofpacket Output 1
add_interface_port response_packet rsp_pck_valid valid Output 1
add_interface_port response_packet rsp_pck_endofpacket endofpacket Output 1
add_interface_port response_packet rsp_pck_data data Output 32
add_interface_port response_packet rsp_pck_ready ready Input 1


# 
# connection point urgent_packet
# 
add_interface urgent_packet avalon_streaming end
set_interface_property urgent_packet associatedClock clock
set_interface_property urgent_packet associatedReset reset
set_interface_property urgent_packet dataBitsPerSymbol 32
set_interface_property urgent_packet errorDescriptor ""
set_interface_property urgent_packet firstSymbolInHighOrderBits true
set_interface_property urgent_packet maxChannel 0
set_interface_property urgent_packet readyLatency 0
set_interface_property urgent_packet ENABLED true
set_interface_property urgent_packet EXPORT_OF ""
set_interface_property urgent_packet PORT_NAME_MAP ""
set_interface_property urgent_packet CMSIS_SVD_VARIABLES ""
set_interface_property urgent_packet SVD_ADDRESS_GROUP ""

add_interface_port urgent_packet urg_pck_valid valid Input 1
add_interface_port urgent_packet urg_pck_startofpacket startofpacket Input 1
add_interface_port urgent_packet urg_pck_endofpacket endofpacket Input 1
add_interface_port urgent_packet urg_pck_ready ready Output 1
add_interface_port urgent_packet urg_pck_data data Input 32


# 
# connection point stream_packet
# 
add_interface stream_packet avalon_streaming end
set_interface_property stream_packet associatedClock clock
set_interface_property stream_packet associatedReset reset
set_interface_property stream_packet dataBitsPerSymbol 32
set_interface_property stream_packet errorDescriptor ""
set_interface_property stream_packet firstSymbolInHighOrderBits true
set_interface_property stream_packet maxChannel 0
set_interface_property stream_packet readyLatency 0
set_interface_property stream_packet ENABLED true
set_interface_property stream_packet EXPORT_OF ""
set_interface_property stream_packet PORT_NAME_MAP ""
set_interface_property stream_packet CMSIS_SVD_VARIABLES ""
set_interface_property stream_packet SVD_ADDRESS_GROUP ""

add_interface_port stream_packet str_valid valid Input 1
add_interface_port stream_packet str_startofpacket startofpacket Input 1
add_interface_port stream_packet str_endofpacket endofpacket Input 1
add_interface_port stream_packet str_ready ready Output 1
#add_interface_port stream_packet str_data data Input 32


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

add_interface_port stream_select str_select stream_select Output 4

add_interface stream_active conduit end
set_interface_property stream_active associatedClock clock
set_interface_property stream_active associatedReset reset
set_interface_property stream_active ENABLED true
set_interface_property stream_active EXPORT_OF ""
set_interface_property stream_active PORT_NAME_MAP ""
set_interface_property stream_active CMSIS_SVD_VARIABLES ""
set_interface_property stream_active SVD_ADDRESS_GROUP ""

add_interface_port stream_active str_active stream_active Output 1

# 
# connection point interrupt_sender
# 
#add_interface interrupt_sender interrupt end
#set_interface_property interrupt_sender associatedAddressablePoint ""
#set_interface_property interrupt_sender associatedClock clock
#set_interface_property interrupt_sender associatedReset reset
#set_interface_property interrupt_sender bridgedReceiverOffset ""
#set_interface_property interrupt_sender bridgesToReceiver ""
#set_interface_property interrupt_sender ENABLED true
#set_interface_property interrupt_sender EXPORT_OF ""
#set_interface_property interrupt_sender PORT_NAME_MAP ""
#set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
#set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""
#add_interface_port interrupt_sender gpi_irq_str irq Output 1
add_interface irq conduit end
#set_interface_property irq associatedClock clock
#set_interface_property irq associatedReset reset
set_interface_property irq ENABLED true
set_interface_property irq EXPORT_OF ""
set_interface_property irq PORT_NAME_MAP ""
set_interface_property irq CMSIS_SVD_VARIABLES ""
set_interface_property irq SVD_ADDRESS_GROUP ""

add_interface_port irq gpi_irq_str irq Output 1

# 
# connection point gpo
# 
add_interface gpo conduit end
#set_interface_property gpo associatedClock clock
#set_interface_property gpo associatedReset reset
set_interface_property gpo ENABLED true
set_interface_property gpo EXPORT_OF ""
set_interface_property gpo PORT_NAME_MAP ""
set_interface_property gpo CMSIS_SVD_VARIABLES ""
set_interface_property gpo SVD_ADDRESS_GROUP ""

add_interface_port gpo gpo_from_sdm gpo Input 9


# 
# connection point gpi
# 
add_interface gpi conduit end
#set_interface_property gpi associatedClock clock
#set_interface_property gpi associatedReset reset
set_interface_property gpi ENABLED true
set_interface_property gpi EXPORT_OF ""
set_interface_property gpi PORT_NAME_MAP ""
set_interface_property gpi CMSIS_SVD_VARIABLES ""
set_interface_property gpi SVD_ADDRESS_GROUP ""

add_interface_port gpi gpi_to_sdm gpi Output 4

proc elaborate {} {
    set stream_width        [ get_parameter_value "STREAM_WIDTH" ]
    set has_urgent 			[get_parameter_value "HAS_URGENT"]
    set has_stream  		[get_parameter_value "HAS_STREAM"]

    # Set data width
    set_interface_property stream_packet dataBitsPerSymbol $stream_width
	add_interface_port stream_packet str_data data Input $stream_width
	if {$has_urgent == 0} {
        set_interface_property urgent_packet ENABLED false

        set_port_property urg_pck_valid 		termination true
		set_port_property urg_pck_startofpacket termination true
		set_port_property urg_pck_endofpacket 	termination true
		set_port_property urg_pck_ready 		termination true
		set_port_property urg_pck_data 			termination true

    }

    if {$has_stream == 0} {
		set_interface_property stream_packet ENABLED false
		set_interface_property stream_select ENABLED false
		set_interface_property stream_active ENABLED false

		set_port_property str_valid 		termination true
		set_port_property str_startofpacket termination true
		set_port_property str_endofpacket 	termination true
		set_port_property str_ready 		termination true
		set_port_property str_select 		termination true
		set_port_property str_active 		termination true

    }


}