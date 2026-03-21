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


# $Id: //acds/rel/18.1std/ip/pgm/altera_s10_mailbox_client/altera_s10_mailbox_client_core_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $


# 
# altera_s10_mailbox_client "Altera Config Debug Agent Bridge" v100.99.98.97
#  2016.04.03.15:59:28
# 
# 

# 
# request TCL package from ACDS 16.0
# 
package require -exact qsys 16.0

# 
# module altera_s10_mailbox_client
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_s10_mailbox_client_core
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera S10 Mailbox Client Core"
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
set_fileset_property synthesis_fileset TOP_LEVEL altera_s10_mailbox_client_core
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL altera_s10_mailbox_client_core
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure
set_fileset_property vhdl_fileset TOP_LEVEL altera_s10_mailbox_client_core

proc synth_callback_procedure { entity_name } {
    add_fileset_file altera_s10_mailbox_client_core.sv SYSTEM_VERILOG PATH "altera_s10_mailbox_client_core.sv"
}


# 
# parameters
# 
# 
# parameters
# 
add_parameter CMD_FIFO_DEPTH INTEGER 16
set_parameter_property CMD_FIFO_DEPTH DISPLAY_NAME "Command FIFO: Depth"
set_parameter_property CMD_FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property CMD_FIFO_DEPTH AFFECTS_GENERATION false
set_parameter_property CMD_FIFO_DEPTH HDL_PARAMETER true
add_display_item "Mailbox Client Parameters" CMD_FIFO_DEPTH parameter
add_parameter CMD_USE_MEMORY_BLOCKS INTEGER 1
set_parameter_property CMD_USE_MEMORY_BLOCKS DISPLAY_NAME "Command FIFO: Use memory block"
set_parameter_property CMD_USE_MEMORY_BLOCKS AFFECTS_ELABORATION true
set_parameter_property CMD_USE_MEMORY_BLOCKS AFFECTS_GENERATION false
set_parameter_property CMD_USE_MEMORY_BLOCKS HDL_PARAMETER true
set_parameter_property CMD_USE_MEMORY_BLOCKS VISIBLE false
set_parameter_property CMD_USE_MEMORY_BLOCKS DISPLAY_HINT "boolean"
add_display_item "Mailbox Client Parameters" CMD_USE_MEMORY_BLOCKS parameter

add_parameter RSP_FIFO_DEPTH INTEGER 16
set_parameter_property RSP_FIFO_DEPTH DISPLAY_NAME "Response FIFO: Depth"
set_parameter_property RSP_FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property RSP_FIFO_DEPTH AFFECTS_GENERATION false
set_parameter_property RSP_FIFO_DEPTH HDL_PARAMETER true
add_display_item "Mailbox Client Parameters" RSP_FIFO_DEPTH parameter
add_parameter RSP_USE_MEMORY_BLOCKS INTEGER 1
set_parameter_property RSP_USE_MEMORY_BLOCKS DISPLAY_NAME "Response FIFO: Use memory block"
set_parameter_property RSP_USE_MEMORY_BLOCKS AFFECTS_ELABORATION true
set_parameter_property RSP_USE_MEMORY_BLOCKS AFFECTS_GENERATION false
set_parameter_property RSP_USE_MEMORY_BLOCKS HDL_PARAMETER true
set_parameter_property RSP_USE_MEMORY_BLOCKS VISIBLE false
set_parameter_property RSP_USE_MEMORY_BLOCKS DISPLAY_HINT "boolean"
add_display_item "Mailbox Client Parameters" RSP_USE_MEMORY_BLOCKS parameter

add_parameter URG_FIFO_DEPTH INTEGER 4
set_parameter_property URG_FIFO_DEPTH DISPLAY_NAME "Urgent FIFO: Depth"
set_parameter_property URG_FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property URG_FIFO_DEPTH AFFECTS_GENERATION false
set_parameter_property URG_FIFO_DEPTH HDL_PARAMETER true
add_display_item "Mailbox Client Parameters" URG_FIFO_DEPTH parameter
add_parameter URG_USE_MEMORY_BLOCKS INTEGER 1
set_parameter_property URG_USE_MEMORY_BLOCKS DISPLAY_NAME "Urgent FIFO: Use memory block"
set_parameter_property URG_USE_MEMORY_BLOCKS AFFECTS_ELABORATION true
set_parameter_property URG_USE_MEMORY_BLOCKS AFFECTS_GENERATION false
set_parameter_property URG_USE_MEMORY_BLOCKS HDL_PARAMETER true
set_parameter_property URG_USE_MEMORY_BLOCKS VISIBLE false
set_parameter_property URG_USE_MEMORY_BLOCKS DISPLAY_HINT "boolean"
add_display_item "Mailbox Client Parameters" URG_USE_MEMORY_BLOCKS parameter


add_parameter HAS_URGENT INTEGER 1
set_parameter_property HAS_URGENT ALLOWED_RANGES {0 1}
set_parameter_property HAS_URGENT AFFECTS_ELABORATION true
set_parameter_property HAS_URGENT AFFECTS_GENERATION false
set_parameter_property HAS_URGENT HDL_PARAMETER true
set_parameter_property HAS_URGENT VISIBLE false

add_parameter HAS_STREAM INTEGER 0
set_parameter_property HAS_STREAM ALLOWED_RANGES {0 1}
set_parameter_property HAS_STREAM AFFECTS_ELABORATION true
set_parameter_property HAS_STREAM AFFECTS_GENERATION false
set_parameter_property HAS_STREAM HDL_PARAMETER true
set_parameter_property HAS_STREAM VISIBLE false

add_parameter STREAM_WIDTH INTEGER 64
set_parameter_property STREAM_WIDTH ALLOWED_RANGES {32 64}
set_parameter_property STREAM_WIDTH AFFECTS_ELABORATION true
set_parameter_property STREAM_WIDTH AFFECTS_GENERATION false
set_parameter_property STREAM_WIDTH HDL_PARAMETER true
set_parameter_property STREAM_WIDTH VISIBLE false

add_parameter HAS_OFFLOAD INTEGER 0 ""
set_parameter_property HAS_OFFLOAD DEFAULT_VALUE 0
set_parameter_property HAS_OFFLOAD DISPLAY_NAME HAS_OFFLOAD
set_parameter_property HAS_OFFLOAD TYPE INTEGER
set_parameter_property HAS_OFFLOAD UNITS None
set_parameter_property HAS_OFFLOAD ALLOWED_RANGES {0 1}
set_parameter_property HAS_OFFLOAD DESCRIPTION ""
set_parameter_property HAS_OFFLOAD HDL_PARAMETER true
set_parameter_property HAS_OFFLOAD VISIBLE false

add_display_item "Config Stream Parameters" HAS_STREAM parameter
add_display_item "Config Stream Parameters" STREAM_WIDTH parameter
add_display_item "Config Stream Parameters" HAS_URGENT parameter
add_display_item "Config Stream Parameters" HAS_OFFLOAD parameter


# 
# display items
# 
add_display_item "" "Mailbox Client Parameters" GROUP ""
add_display_item "" "Config Stream Parameters" GROUP ""
add_display_item "" "Internal Parameters" GROUP ""
# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1

# 
# connection point command
# 
add_interface command avalon_streaming start
set_interface_property command associatedClock clk
set_interface_property command associatedReset reset
set_interface_property command dataBitsPerSymbol 32
set_interface_property command errorDescriptor ""
set_interface_property command firstSymbolInHighOrderBits true
set_interface_property command maxChannel 0
set_interface_property command readyLatency 0
set_interface_property command ENABLED true
set_interface_property command EXPORT_OF ""
set_interface_property command PORT_NAME_MAP ""
set_interface_property command CMSIS_SVD_VARIABLES ""
set_interface_property command SVD_ADDRESS_GROUP ""

add_interface_port command command_ready ready Input 1
add_interface_port command command_valid valid Output 1
add_interface_port command command_data data Output 32
add_interface_port command command_startofpacket startofpacket Output 1
add_interface_port command command_endofpacket endofpacket Output 1


# 
# connection point response
# 
add_interface response avalon_streaming end
set_interface_property response associatedClock clk
set_interface_property response associatedReset reset
set_interface_property response dataBitsPerSymbol 32
set_interface_property response errorDescriptor ""
set_interface_property response firstSymbolInHighOrderBits true
set_interface_property response maxChannel 0
set_interface_property response readyLatency 0
set_interface_property response ENABLED true
set_interface_property response EXPORT_OF ""
set_interface_property response PORT_NAME_MAP ""
set_interface_property response CMSIS_SVD_VARIABLES ""
set_interface_property response SVD_ADDRESS_GROUP ""

add_interface_port response response_ready ready Output 1
add_interface_port response response_valid valid Input 1
add_interface_port response response_data data Input 32
add_interface_port response response_startofpacket startofpacket Input 1
add_interface_port response response_endofpacket endofpacket Input 1


# 
# connection point urgent
# 
add_interface urgent avalon_streaming start
set_interface_property urgent dataBitsPerSymbol 32
set_interface_property urgent associatedClock clk
set_interface_property urgent associatedReset reset
set_interface_property urgent ENABLED false

# 
# connection point stream
# 
add_interface stream avalon_streaming start
set_interface_property stream associatedClock clk
set_interface_property stream associatedReset reset
set_interface_property stream dataBitsPerSymbol 32
set_interface_property stream errorDescriptor ""
set_interface_property stream firstSymbolInHighOrderBits true
set_interface_property stream maxChannel 0
set_interface_property stream readyLatency 0
set_interface_property stream ENABLED false
set_interface_property stream EXPORT_OF ""
set_interface_property stream PORT_NAME_MAP ""
set_interface_property stream CMSIS_SVD_VARIABLES ""
set_interface_property stream SVD_ADDRESS_GROUP ""


# 
# connection point stream_active
# 
add_interface stream_active conduit end
set_interface_property stream_active associatedClock clk
set_interface_property stream_active associatedReset reset
set_interface_property stream_active ENABLED false
set_interface_property stream_active EXPORT_OF ""
set_interface_property stream_active PORT_NAME_MAP ""
set_interface_property stream_active CMSIS_SVD_VARIABLES ""
set_interface_property stream_active SVD_ADDRESS_GROUP ""

# 
# connection point avmm
# 
add_interface avmm avalon end
set_interface_property avmm addressUnits WORDS
set_interface_property avmm associatedClock clk
set_interface_property avmm associatedReset reset
set_interface_property avmm bitsPerSymbol 8
set_interface_property avmm bridgedAddressOffset 0
set_interface_property avmm bridgesToMaster ""
set_interface_property avmm burstOnBurstBoundariesOnly false
set_interface_property avmm burstcountUnits WORDS
set_interface_property avmm explicitAddressSpan 0
set_interface_property avmm holdTime 0
set_interface_property avmm linewrapBursts false
set_interface_property avmm maximumPendingReadTransactions 1
set_interface_property avmm maximumPendingWriteTransactions 0
set_interface_property avmm readLatency 0
set_interface_property avmm readWaitTime 0
set_interface_property avmm setupTime 0
set_interface_property avmm timingUnits Cycles
set_interface_property avmm transparentBridge false
set_interface_property avmm writeWaitTime 0
set_interface_property avmm ENABLED true
set_interface_property avmm EXPORT_OF ""
set_interface_property avmm PORT_NAME_MAP ""
set_interface_property avmm CMSIS_SVD_VARIABLES ""
set_interface_property avmm SVD_ADDRESS_GROUP ""

add_interface_port avmm avmm_address address Input 4
add_interface_port avmm avmm_write write Input 1
add_interface_port avmm avmm_writedata writedata Input 32
add_interface_port avmm avmm_read read Input 1
add_interface_port avmm avmm_readdata readdata Output 32
add_interface_port avmm avmm_readdatavalid readdatavalid Output 1

# 
# connection point irq
# 
add_interface irq interrupt end
set_interface_property irq associatedAddressablePoint ""
set_interface_property irq associatedClock clk
set_interface_property irq associatedReset reset
set_interface_property irq bridgedReceiverOffset ""
set_interface_property irq bridgesToReceiver ""
set_interface_property irq ENABLED true
set_interface_property irq EXPORT_OF ""
set_interface_property irq PORT_NAME_MAP ""
set_interface_property irq CMSIS_SVD_VARIABLES ""
set_interface_property irq SVD_ADDRESS_GROUP ""

add_interface_port irq irq irq Output 1


proc elaborate {} {
   
    set HAS_STREAM          [get_parameter_value HAS_STREAM]
    set HAS_URGENT          [get_parameter_value HAS_URGENT]
    set HAS_OFFLOAD         [get_parameter_value HAS_OFFLOAD]
    set STREAM_WIDTH        [get_parameter_value STREAM_WIDTH]
    # Add the sub fifo 
    add_hdl_instance cmd_sc_fifo altera_avalon_sc_fifo
    set_instance_parameter_value cmd_sc_fifo USE_PACKETS 1
    set_instance_parameter_value cmd_sc_fifo USE_FILL_LEVEL 1
    set_instance_parameter_value cmd_sc_fifo BITS_PER_SYMBOL 32

    add_hdl_instance urg_sc_fifo altera_avalon_sc_fifo
    set_instance_parameter_value urg_sc_fifo USE_PACKETS 0
    set_instance_parameter_value urg_sc_fifo USE_FILL_LEVEL 1
    set_instance_parameter_value urg_sc_fifo BITS_PER_SYMBOL 32

    add_hdl_instance rsp_sc_fifo altera_avalon_sc_fifo
    set_instance_parameter_value rsp_sc_fifo USE_PACKETS 1
    set_instance_parameter_value rsp_sc_fifo USE_FILL_LEVEL 1
    set_instance_parameter_value rsp_sc_fifo BITS_PER_SYMBOL 32

    if {$HAS_STREAM != 0} {
        set_interface_property stream ENABLED true
        add_interface_port stream int_stream_ready ready Input 1
        add_interface_port stream int_stream_valid valid Output 1
        add_interface_port stream int_stream_data data Output 32
        set_port_property int_stream_data width_expr $STREAM_WIDTH
        set_interface_property stream_active ENABLED true
        add_interface_port stream_active stream_active active Input 1
    }

    if {$HAS_URGENT != 0} {
        set_interface_property urgent ENABLED true
        add_interface_port  urgent urgent_ready ready Input 1
        add_interface_port  urgent urgent_valid valid Output 1
        add_interface_port  urgent urgent_data data Output 32
    }
}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}