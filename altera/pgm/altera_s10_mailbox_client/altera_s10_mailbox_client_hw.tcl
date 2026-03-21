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


# $Id: //acds/rel/18.1std/ip/pgm/altera_s10_mailbox_client/altera_s10_mailbox_client_hw.tcl#1 $
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
set_module_property NAME altera_s10_mailbox_client
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera S10 Mailbox Client"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property composition_callback compose
set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list

# 
# parameters
# 
# 
# parameters
# 
add_parameter CMD_FIFO_DEPTH INTEGER 16
set_parameter_property CMD_FIFO_DEPTH DISPLAY_NAME "Command FIFO: Depth"
set_parameter_property CMD_FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property CMD_FIFO_DEPTH AFFECTS_GENERATION true
set_parameter_property CMD_FIFO_DEPTH HDL_PARAMETER true
add_display_item "Mailbox Client Parameters" CMD_FIFO_DEPTH parameter
add_parameter CMD_USE_MEMORY_BLOCKS INTEGER 1
set_parameter_property CMD_USE_MEMORY_BLOCKS DISPLAY_NAME "Command FIFO: Use memory block"
set_parameter_property CMD_USE_MEMORY_BLOCKS AFFECTS_ELABORATION true
set_parameter_property CMD_USE_MEMORY_BLOCKS AFFECTS_GENERATION true
set_parameter_property CMD_USE_MEMORY_BLOCKS HDL_PARAMETER true
set_parameter_property CMD_USE_MEMORY_BLOCKS VISIBLE false
set_parameter_property CMD_USE_MEMORY_BLOCKS DISPLAY_HINT "boolean"
add_display_item "Mailbox Client Parameters" CMD_USE_MEMORY_BLOCKS parameter

add_parameter RSP_FIFO_DEPTH INTEGER 16
set_parameter_property RSP_FIFO_DEPTH DISPLAY_NAME "Response FIFO: Depth"
set_parameter_property RSP_FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property RSP_FIFO_DEPTH AFFECTS_GENERATION true
set_parameter_property RSP_FIFO_DEPTH HDL_PARAMETER true
add_display_item "Mailbox Client Parameters" RSP_FIFO_DEPTH parameter
add_parameter RSP_USE_MEMORY_BLOCKS INTEGER 1
set_parameter_property RSP_USE_MEMORY_BLOCKS DISPLAY_NAME "Response FIFO: Use memory block"
set_parameter_property RSP_USE_MEMORY_BLOCKS AFFECTS_ELABORATION true
set_parameter_property RSP_USE_MEMORY_BLOCKS AFFECTS_GENERATION true
set_parameter_property RSP_USE_MEMORY_BLOCKS HDL_PARAMETER true
set_parameter_property RSP_USE_MEMORY_BLOCKS VISIBLE false
set_parameter_property RSP_USE_MEMORY_BLOCKS DISPLAY_HINT "boolean"
add_display_item "Mailbox Client Parameters" RSP_USE_MEMORY_BLOCKS parameter

add_parameter URG_FIFO_DEPTH INTEGER 4
set_parameter_property URG_FIFO_DEPTH DISPLAY_NAME "Urgent FIFO: Depth"
set_parameter_property URG_FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property URG_FIFO_DEPTH AFFECTS_GENERATION true
set_parameter_property URG_FIFO_DEPTH HDL_PARAMETER true
add_display_item "Mailbox Client Parameters" URG_FIFO_DEPTH parameter
add_parameter URG_USE_MEMORY_BLOCKS INTEGER 1
set_parameter_property URG_USE_MEMORY_BLOCKS DISPLAY_NAME "Urgent FIFO: Use memory block"
set_parameter_property URG_USE_MEMORY_BLOCKS AFFECTS_ELABORATION true
set_parameter_property URG_USE_MEMORY_BLOCKS AFFECTS_GENERATION true
set_parameter_property URG_USE_MEMORY_BLOCKS HDL_PARAMETER true
set_parameter_property URG_USE_MEMORY_BLOCKS VISIBLE false
set_parameter_property URG_USE_MEMORY_BLOCKS DISPLAY_HINT "boolean"
add_display_item "Mailbox Client Parameters" URG_USE_MEMORY_BLOCKS parameter

add_parameter DEBUG INTEGER 0
set_parameter_property DEBUG DISPLAY_NAME "Debug Simulation"
set_parameter_property DEBUG AFFECTS_ELABORATION true
set_parameter_property DEBUG AFFECTS_GENERATION true
set_parameter_property DEBUG HDL_PARAMETER true
set_parameter_property DEBUG VISIBLE true
set_parameter_property DEBUG DISPLAY_HINT "boolean"
add_display_item "Mailbox Client Parameters" DEBUG parameter



add_parameter HAS_URGENT INTEGER 1
set_parameter_property HAS_URGENT ALLOWED_RANGES {0 1}
set_parameter_property HAS_URGENT AFFECTS_ELABORATION true
set_parameter_property HAS_URGENT AFFECTS_GENERATION true
set_parameter_property HAS_URGENT HDL_PARAMETER true
set_parameter_property HAS_URGENT VISIBLE false

add_parameter HAS_STREAM INTEGER 0
set_parameter_property HAS_STREAM ALLOWED_RANGES {0 1}
set_parameter_property HAS_STREAM AFFECTS_ELABORATION true
set_parameter_property HAS_STREAM AFFECTS_GENERATION true
set_parameter_property HAS_STREAM HDL_PARAMETER true
set_parameter_property HAS_STREAM VISIBLE false

add_parameter STREAM_WIDTH INTEGER 64
set_parameter_property STREAM_WIDTH ALLOWED_RANGES {32 64}
set_parameter_property STREAM_WIDTH AFFECTS_ELABORATION true
set_parameter_property STREAM_WIDTH AFFECTS_GENERATION true
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


proc compose { } {
   
    set HAS_STREAM          [get_parameter_value HAS_STREAM]
    set HAS_URGENT          [get_parameter_value HAS_URGENT]
    set HAS_OFFLOAD         [get_parameter_value HAS_OFFLOAD]
    set STREAM_WIDTH        [get_parameter_value STREAM_WIDTH]
    set DEBUG               [get_parameter_value DEBUG]
    set CMD_FIFO_DEPTH      [get_parameter_value CMD_FIFO_DEPTH] 
    set URG_FIFO_DEPTH      [get_parameter_value URG_FIFO_DEPTH] 
    set RSP_FIFO_DEPTH      [get_parameter_value RSP_FIFO_DEPTH]
    set CMD_USE_MEMORY_BLOCKS      [get_parameter_value CMD_USE_MEMORY_BLOCKS] 
    set URG_USE_MEMORY_BLOCKS      [get_parameter_value URG_USE_MEMORY_BLOCKS] 
    set RSP_USE_MEMORY_BLOCKS      [get_parameter_value RSP_USE_MEMORY_BLOCKS] 

    add_instance clock_bridge altera_clock_bridge 18.1
    set_instance_parameter_value clock_bridge {EXPLICIT_CLOCK_RATE} {0.0}
    set_instance_parameter_value clock_bridge {NUM_CLOCK_OUTPUTS} {1}

    add_instance reset_bridge altera_reset_bridge 18.1
    set_instance_parameter_value reset_bridge {ACTIVE_LOW_RESET} {0}
    set_instance_parameter_value reset_bridge {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset_bridge {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset_bridge {USE_RESET_REQUEST} {0}

    add_instance  s10_mailbox_client_inst altera_s10_mailbox_client_core 18.1
    set_instance_parameter_value s10_mailbox_client_inst {CMD_FIFO_DEPTH} $CMD_FIFO_DEPTH
    set_instance_parameter_value s10_mailbox_client_inst {CMD_USE_MEMORY_BLOCKS} $CMD_USE_MEMORY_BLOCKS
    set_instance_parameter_value s10_mailbox_client_inst {RSP_FIFO_DEPTH} $RSP_FIFO_DEPTH
    set_instance_parameter_value s10_mailbox_client_inst {RSP_USE_MEMORY_BLOCKS} $RSP_USE_MEMORY_BLOCKS
    set_instance_parameter_value s10_mailbox_client_inst {URG_FIFO_DEPTH} $URG_FIFO_DEPTH
    set_instance_parameter_value s10_mailbox_client_inst {URG_USE_MEMORY_BLOCKS} $URG_USE_MEMORY_BLOCKS
    set_instance_parameter_value s10_mailbox_client_inst {HAS_URGENT} {1}
    set_instance_parameter_value s10_mailbox_client_inst {HAS_STREAM} {0}
    set_instance_parameter_value s10_mailbox_client_inst {STREAM_WIDTH} {64}
    set_instance_parameter_value s10_mailbox_client_inst {HAS_OFFLOAD} {0}

    # connections and connection parameters
    add_connection clock_bridge.out_clk reset_bridge.clk clock
    add_connection clock_bridge.out_clk s10_mailbox_client_inst.clk clock
    add_connection reset_bridge.out_reset s10_mailbox_client_inst.reset reset

    # exported interfaces
    add_interface in_clk clock sink
    set_interface_property in_clk EXPORT_OF clock_bridge.in_clk
    add_interface in_reset reset sink
    set_interface_property in_reset EXPORT_OF reset_bridge.in_reset
    add_interface avmm avalon end
    set_interface_property avmm EXPORT_OF s10_mailbox_client_inst.avmm
    add_interface irq interrupt end
    set_interface_property irq EXPORT_OF s10_mailbox_client_inst.irq

    if {$DEBUG == 0} {
        add_instance config_stream_endpoint_0 altera_config_stream_endpoint 18.1
        set_instance_parameter_value config_stream_endpoint_0 {READY_LATENCY} {0}
        set_instance_parameter_value config_stream_endpoint_0 {HAS_URGENT} {1}
        set_instance_parameter_value config_stream_endpoint_0 {HAS_STREAM} {0}
        set_instance_parameter_value config_stream_endpoint_0 {MAX_SIZE} {256}
        set_instance_parameter_value config_stream_endpoint_0 {STREAM_WIDTH} {32}

        add_connection clock_bridge.out_clk config_stream_endpoint_0.clk clock 
        add_connection reset_bridge.out_reset config_stream_endpoint_0.reset reset
        add_connection config_stream_endpoint_0.response s10_mailbox_client_inst.response avalon_streaming
        add_connection s10_mailbox_client_inst.command config_stream_endpoint_0.command avalon_streaming
        add_connection s10_mailbox_client_inst.urgent config_stream_endpoint_0.urgent avalon_streaming
    } else {
        add_interface command avalon_streaming source
        set_interface_property command EXPORT_OF s10_mailbox_client_inst.command
        add_interface response avalon_streaming sink
        set_interface_property response EXPORT_OF s10_mailbox_client_inst.response
        add_interface urgent avalon_streaming source
        set_interface_property urgent EXPORT_OF s10_mailbox_client_inst.urgent
    }
}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}