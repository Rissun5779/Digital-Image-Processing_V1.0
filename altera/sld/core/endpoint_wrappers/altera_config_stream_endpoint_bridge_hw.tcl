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


# (C) 2001-2016 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# 
# altera_config_stream_endpoint_bridge "altera_config_stream_endpoint_bridge" v1.0
# 

# request TCL package from ACDS 13.0
# 
package require -exact qsys 13.0

# 
# module altera_config_stream_endpoint_bridge
# 
set_module_property NAME altera_config_stream_endpoint_bridge
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Verification/Debug & Performance"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME altera_config_stream_endpoint_bridge
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property ELABORATION_CALLBACK elaborate
set_module_assignment debug.isTransparent true

# 
# parameters
# 
add_parameter READY_LATENCY INTEGER 0
set_parameter_property READY_LATENCY ALLOWED_RANGES {0:7}
set_parameter_property READY_LATENCY AFFECTS_ELABORATION true
set_parameter_property READY_LATENCY AFFECTS_GENERATION false
set_parameter_property READY_LATENCY HDL_PARAMETER true

add_parameter HAS_URGENT INTEGER 0
set_parameter_property HAS_URGENT ALLOWED_RANGES {0 1}
set_parameter_property HAS_URGENT AFFECTS_ELABORATION true
set_parameter_property HAS_URGENT AFFECTS_GENERATION false
set_parameter_property HAS_URGENT HDL_PARAMETER true

add_parameter HAS_STREAM INTEGER 0
set_parameter_property HAS_STREAM ALLOWED_RANGES {0 1}
set_parameter_property HAS_STREAM AFFECTS_ELABORATION true
set_parameter_property HAS_STREAM AFFECTS_GENERATION false
set_parameter_property HAS_STREAM HDL_PARAMETER true

add_parameter STREAM_WIDTH INTEGER 64
set_parameter_property STREAM_WIDTH ALLOWED_RANGES {32 64}
set_parameter_property STREAM_WIDTH AFFECTS_ELABORATION true
set_parameter_property STREAM_WIDTH AFFECTS_GENERATION false
set_parameter_property STREAM_WIDTH HDL_PARAMETER true


# 
# display items
# 

#
# connection point clk
#
add_interface clk clock end
set_interface_property clk ENABLED true
add_interface_port clk clk clk Input 1


#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset ENABLED true
add_interface_port reset reset reset Input 1


#
# connection point command
#
add_interface ext_command avalon_streaming end
set_interface_property ext_command dataBitsPerSymbol 32
set_interface_property ext_command associatedClock clk
set_interface_property ext_command associatedReset reset
set_interface_property ext_command ENABLED true
add_interface_port ext_command ext_command_ready ready Output 1
add_interface_port ext_command ext_command_valid valid Input 1
add_interface_port ext_command ext_command_data data Input 32
add_interface_port ext_command ext_command_startofpacket startofpacket Input 1
add_interface_port ext_command ext_command_endofpacket endofpacket Input 1

add_interface int_command avalon_streaming start
set_interface_property int_command dataBitsPerSymbol 32
set_interface_property int_command associatedClock clk
set_interface_property int_command associatedReset reset
set_interface_property int_command ENABLED true
add_interface_port int_command int_command_ready ready Input 1
add_interface_port int_command int_command_valid valid Output 1
add_interface_port int_command int_command_data data Output 32
add_interface_port int_command int_command_startofpacket startofpacket Output 1
add_interface_port int_command int_command_endofpacket endofpacket Output 1

set_interface_assignment int_command debug.controlledBy ext_command
set_port_property ext_command_ready driven_by int_command_ready
set_port_property int_command_valid driven_by ext_command_valid
set_port_property int_command_data driven_by ext_command_data
set_port_property int_command_startofpacket driven_by ext_command_startofpacket
set_port_property int_command_endofpacket driven_by ext_command_endofpacket


#
# connection point response
#
add_interface ext_response avalon_streaming start
set_interface_property ext_response dataBitsPerSymbol 32
set_interface_property ext_response associatedClock clk
set_interface_property ext_response associatedReset reset
set_interface_property ext_response ENABLED true
add_interface_port ext_response ext_response_ready ready Input 1
add_interface_port ext_response ext_response_valid valid Output 1
add_interface_port ext_response ext_response_data data Output 32
add_interface_port ext_response ext_response_startofpacket startofpacket Output 1
add_interface_port ext_response ext_response_endofpacket endofpacket Output 1

add_interface int_response avalon_streaming end
set_interface_property int_response dataBitsPerSymbol 32
set_interface_property int_response associatedClock clk
set_interface_property int_response associatedReset reset
set_interface_property int_response ENABLED true
add_interface_port int_response int_response_ready ready Output 1
add_interface_port int_response int_response_valid valid Input 1
add_interface_port int_response int_response_data data Input 32
add_interface_port int_response int_response_startofpacket startofpacket Input 1
add_interface_port int_response int_response_endofpacket endofpacket Input 1

set_interface_assignment ext_response debug.controlledBy int_response
set_port_property int_response_ready driven_by ext_response_ready
set_port_property ext_response_valid driven_by int_response_valid
set_port_property ext_response_data driven_by int_response_data
set_port_property ext_response_startofpacket driven_by int_response_startofpacket
set_port_property ext_response_endofpacket driven_by int_response_endofpacket


#
# connection point urgent
#
add_interface ext_urgent avalon_streaming end
set_interface_property ext_urgent dataBitsPerSymbol 32
set_interface_property ext_urgent associatedClock clk
set_interface_property ext_urgent associatedReset reset
set_interface_property ext_urgent ENABLED false

add_interface int_urgent avalon_streaming start
set_interface_property int_urgent dataBitsPerSymbol 32
set_interface_property int_urgent associatedClock clk
set_interface_property int_urgent associatedReset reset
set_interface_property int_urgent ENABLED false

set_interface_assignment int_urgent debug.controlledBy ext_urgent


#
# connection point stream
#
add_interface ext_stream avalon_streaming end
set_interface_property ext_stream associatedClock clk
set_interface_property ext_stream associatedReset reset
set_interface_property ext_stream ENABLED false

add_interface int_stream avalon_streaming start
set_interface_property int_stream associatedClock clk
set_interface_property int_stream associatedReset reset
set_interface_property int_stream ENABLED false

set_interface_assignment int_stream debug.controlledBy ext_stream


#
# connection point stream_active
#
add_interface ext_stream_active conduit start
set_interface_property ext_stream_active associatedClock clk
set_interface_property ext_stream_active associatedReset reset
set_interface_property ext_stream_active ENABLED false

add_interface int_stream_active conduit end
set_interface_property int_stream_active associatedClock clk
set_interface_property int_stream_active associatedReset reset
set_interface_property int_stream_active ENABLED false

set_interface_assignment ext_stream_active debug.controlledBy int_stream_active


#
# Elaboration callback
#
proc elaborate {} {
    set READY_LATENCY [get_parameter_value READY_LATENCY]
    set HAS_URGENT [get_parameter_value HAS_URGENT]
    set HAS_STREAM [get_parameter_value HAS_STREAM]
    set STREAM_WIDTH [get_parameter_value STREAM_WIDTH]

    set_interface_property int_command readyLatency $READY_LATENCY
    set_interface_property ext_command readyLatency $READY_LATENCY
    set_interface_property int_response readyLatency $READY_LATENCY
    set_interface_property ext_response readyLatency $READY_LATENCY
    set_interface_property int_urgent readyLatency $READY_LATENCY
    set_interface_property ext_urgent readyLatency $READY_LATENCY
    set_interface_property int_stream dataBitsPerSymbol $STREAM_WIDTH
    set_interface_property ext_stream dataBitsPerSymbol $STREAM_WIDTH
    set_interface_property int_stream readyLatency $READY_LATENCY
    set_interface_property ext_stream readyLatency $READY_LATENCY

    if {$HAS_URGENT != 0} {
        set_interface_property int_urgent ENABLED true
        add_interface_port int_urgent int_urgent_ready ready Input 1
        set_interface_property ext_urgent ENABLED true
        add_interface_port ext_urgent ext_urgent_ready ready Output 1
        set_port_property ext_urgent_ready driven_by int_urgent_ready
        add_interface_port int_urgent int_urgent_valid valid Output 1
        add_interface_port ext_urgent ext_urgent_valid valid Input 1
        set_port_property int_urgent_valid driven_by ext_urgent_valid
        add_interface_port int_urgent int_urgent_data data Output 32
        add_interface_port ext_urgent ext_urgent_data data Input 32
        set_port_property int_urgent_data driven_by ext_urgent_data
    }

    if {$HAS_STREAM != 0} {
        set_interface_property int_stream ENABLED true
        add_interface_port int_stream int_stream_ready ready Input 1
        set_interface_property ext_stream ENABLED true
        add_interface_port ext_stream ext_stream_ready ready Output 1
        set_port_property ext_stream_ready driven_by int_stream_ready
        add_interface_port int_stream int_stream_valid valid Output 1
        add_interface_port ext_stream ext_stream_valid valid Input 1
        set_port_property int_stream_valid driven_by ext_stream_valid
        add_interface_port int_stream int_stream_data data Output $STREAM_WIDTH
        add_interface_port ext_stream ext_stream_data data Input $STREAM_WIDTH
        set_port_property int_stream_data driven_by ext_stream_data
        set_interface_property int_stream_active ENABLED true
        add_interface_port int_stream_active int_stream_active active Input 1
        set_interface_property ext_stream_active ENABLED true
        add_interface_port ext_stream_active ext_stream_active active Output 1
        set_port_property ext_stream_active driven_by int_stream_active
    }
}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}
