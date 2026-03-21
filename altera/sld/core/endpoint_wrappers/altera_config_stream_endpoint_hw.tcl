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
# altera_config_stream_endpoint "altera_config_stream_endpoint" v1.0
# 

# request TCL package from ACDS 13.0
# 
package require -exact qsys 13.0

# 
# module altera_config_stream_endpoint
# 
set_module_property NAME altera_config_stream_endpoint
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Verification/Debug & Performance"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME altera_config_stream_endpoint
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property ELABORATION_CALLBACK elaborate
set_module_assignment debug.virtualInterface.link {debug.fabricLink {fabric mailbox} }
set_module_assignment debug.isTransparent true

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_config_stream_endpoint_wrapper
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_config_stream_endpoint_wrapper.sv system_verilog path altera_config_stream_endpoint_wrapper.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_config_stream_endpoint_wrapper
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_config_stream_endpoint_wrapper.sv system_verilog path altera_config_stream_endpoint_wrapper.sv


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

add_parameter MAX_SIZE INTEGER 256
set_parameter_property MAX_SIZE ALLOWED_RANGES {256 512 1024 4096 8192 16384}
set_parameter_property MAX_SIZE AFFECTS_ELABORATION false
set_parameter_property MAX_SIZE AFFECTS_GENERATION false
set_parameter_property MAX_SIZE HDL_PARAMETER true

add_parameter STREAM_WIDTH INTEGER 64
set_parameter_property STREAM_WIDTH ALLOWED_RANGES {32 64}
set_parameter_property STREAM_WIDTH AFFECTS_ELABORATION true
set_parameter_property STREAM_WIDTH AFFECTS_GENERATION false
set_parameter_property STREAM_WIDTH HDL_PARAMETER true

add_parameter CLOCK_RATE_CLK INTEGER 0
set_parameter_property CLOCK_RATE_CLK SYSTEM_INFO {CLOCK_RATE clk}
set_parameter_property CLOCK_RATE_CLK AFFECTS_ELABORATION false
set_parameter_property CLOCK_RATE_CLK AFFECTS_GENERATION false
set_parameter_property CLOCK_RATE_CLK HDL_PARAMETER true


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
add_interface command avalon_streaming end
set_interface_property command dataBitsPerSymbol 32
set_interface_property command associatedClock clk
set_interface_property command associatedReset reset
set_interface_property command ENABLED true
set_interface_assignment command debug.controlledBy {link}
set_interface_assignment command debug.interfaceGroup {associatedResponse response associatedStream stream associatedStream_active stream_active associatedUrgent urgent}
add_interface_port command command_ready ready Output 1
add_interface_port command command_valid valid Input 1
add_interface_port command command_data data Input 32
add_interface_port command command_startofpacket startofpacket Input 1
add_interface_port command command_endofpacket endofpacket Input 1


#
# connection point response
#
add_interface response avalon_streaming start
set_interface_property response dataBitsPerSymbol 32
set_interface_property response associatedClock clk
set_interface_property response associatedReset reset
set_interface_property response ENABLED true
add_interface_port response response_ready ready Input 1
add_interface_port response response_valid valid Output 1
add_interface_port response response_data data Output 32
add_interface_port response response_startofpacket startofpacket Output 1
add_interface_port response response_endofpacket endofpacket Output 1


#
# connection point urgent
#
add_interface urgent avalon_streaming end
set_interface_property urgent dataBitsPerSymbol 32
set_interface_property urgent associatedClock clk
set_interface_property urgent associatedReset reset
set_interface_property urgent ENABLED false
add_interface_port urgent urgent_ready ready Output 1
set_port_property urgent_ready termination true
add_interface_port urgent urgent_valid valid Input 1
set_port_property urgent_valid termination true
add_interface_port urgent urgent_data data Input 1
set_port_property urgent_data termination true


#
# connection point stream
#
add_interface stream avalon_streaming end
set_interface_property stream associatedClock clk
set_interface_property stream associatedReset reset
set_interface_property stream ENABLED false
add_interface_port stream stream_ready ready Output 1
set_port_property stream_ready termination true
add_interface_port stream stream_valid valid Input 1
set_port_property stream_valid termination true
add_interface_port stream stream_data data Input 1
set_port_property stream_data termination true


#
# connection point stream_active
#
add_interface stream_active conduit start
set_interface_property stream_active associatedClock clk
set_interface_property stream_active associatedReset reset
set_interface_property stream_active ENABLED false
add_interface_port stream_active stream_active active Output 1
set_port_property stream_active termination true


#
# Elaboration callback
#
proc elaborate {} {
    set READY_LATENCY [get_parameter_value READY_LATENCY]
    set HAS_URGENT [get_parameter_value HAS_URGENT]
    set HAS_STREAM [get_parameter_value HAS_STREAM]
    set STREAM_WIDTH [get_parameter_value STREAM_WIDTH]

    set_interface_property command readyLatency $READY_LATENCY
    set_interface_property response readyLatency $READY_LATENCY
    set_interface_property urgent readyLatency $READY_LATENCY
    set_interface_property stream dataBitsPerSymbol $STREAM_WIDTH
    set_interface_property stream readyLatency $READY_LATENCY

    if {$HAS_URGENT != 0} {
        set_interface_property urgent ENABLED true
        set_port_property urgent_ready termination false
        set_port_property urgent_valid termination false
        set_port_property urgent_data width_expr 32
        set_port_property urgent_data termination false
    }

    if {$HAS_STREAM != 0} {
        set_interface_property stream ENABLED true
        set_port_property stream_ready termination false
        set_port_property stream_valid termination false
        set_port_property stream_data width_expr $STREAM_WIDTH
        set_port_property stream_data termination false
        set_interface_property stream_active ENABLED true
        set_port_property stream_active termination false
    }
}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}
