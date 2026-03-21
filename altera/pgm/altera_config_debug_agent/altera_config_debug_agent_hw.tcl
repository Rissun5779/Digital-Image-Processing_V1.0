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


# $Id: //acds/rel/18.1std/ip/pgm/altera_config_debug_agent/altera_config_debug_agent_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# 
# request TCL package from ACDS 16.0
# 
package require -exact qsys 16.0


# 
# module altera_config_debug_agent
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_config_debug_agent
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera Config Debug Agent"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property composition_callback compose

# 
# parameters
# 
add_parameter USE_AVST_EP INTEGER 1 "Turn on altera avalon st debug agent endpoint"
set_parameter_property USE_AVST_EP DEFAULT_VALUE 1
set_parameter_property USE_AVST_EP DISPLAY_NAME USE_AVST_EP
set_parameter_property USE_AVST_EP TYPE INTEGER
set_parameter_property USE_AVST_EP UNITS None
set_parameter_property USE_AVST_EP ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USE_AVST_EP DESCRIPTION "Turn on altera avalon st debug agent endpoint"
set_parameter_property USE_AVST_EP HDL_PARAMETER true
add_display_item Debug USE_AVST_EP parameter
add_parameter USE_CONFIG_STR_EP INTEGER 1 "Turn on altera config stream endpoint"
set_parameter_property USE_CONFIG_STR_EP DEFAULT_VALUE 1
set_parameter_property USE_CONFIG_STR_EP DISPLAY_NAME USE_CONFIG_STR_EP
set_parameter_property USE_CONFIG_STR_EP TYPE INTEGER
set_parameter_property USE_CONFIG_STR_EP UNITS None
set_parameter_property USE_CONFIG_STR_EP ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USE_CONFIG_STR_EP DESCRIPTION "Turn on altera config stream endpoint"
set_parameter_property USE_CONFIG_STR_EP HDL_PARAMETER true
add_display_item Debug USE_CONFIG_STR_EP parameter
add_parameter MFR_CODE INTEGER 0 ""
set_parameter_property MFR_CODE DEFAULT_VALUE 0
set_parameter_property MFR_CODE DISPLAY_NAME MFR_CODE
set_parameter_property MFR_CODE TYPE INTEGER
set_parameter_property MFR_CODE UNITS None
set_parameter_property MFR_CODE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MFR_CODE DESCRIPTION ""
set_parameter_property MFR_CODE HDL_PARAMETER true
add_display_item "AvalonST Debug Endpoint Parameters" MFR_CODE parameter
add_parameter TYPE_CODE INTEGER 0 ""
set_parameter_property TYPE_CODE DEFAULT_VALUE 0
set_parameter_property TYPE_CODE DISPLAY_NAME TYPE_CODE
set_parameter_property TYPE_CODE TYPE INTEGER
set_parameter_property TYPE_CODE UNITS None
set_parameter_property TYPE_CODE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property TYPE_CODE DESCRIPTION ""
set_parameter_property TYPE_CODE HDL_PARAMETER true
add_display_item "AvalonST Debug Endpoint Parameters" TYPE_CODE parameter
add_parameter PREFER_HOST STRING JTAG ""
set_parameter_property PREFER_HOST DEFAULT_VALUE JTAG
set_parameter_property PREFER_HOST DISPLAY_NAME PREFER_HOST
set_parameter_property PREFER_HOST WIDTH ""
set_parameter_property PREFER_HOST TYPE STRING
set_parameter_property PREFER_HOST UNITS None
set_parameter_property PREFER_HOST DESCRIPTION ""
set_parameter_property PREFER_HOST HDL_PARAMETER true
add_display_item "AvalonST Debug Endpoint Parameters" PREFER_HOST parameter
add_parameter USE_STREAM INTEGER 0 ""
set_parameter_property USE_STREAM DEFAULT_VALUE 0
set_parameter_property USE_STREAM DISPLAY_NAME USE_STREAM
set_parameter_property USE_STREAM TYPE INTEGER
set_parameter_property USE_STREAM UNITS None
set_parameter_property USE_STREAM ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USE_STREAM DESCRIPTION ""
set_parameter_property USE_STREAM HDL_PARAMETER true
add_display_item "Config Stream Parameters" USE_STREAM parameter
add_parameter USE_OFFLOAD INTEGER 0 ""
set_parameter_property USE_OFFLOAD DEFAULT_VALUE 0
set_parameter_property USE_OFFLOAD DISPLAY_NAME USE_OFFLOAD
set_parameter_property USE_OFFLOAD TYPE INTEGER
set_parameter_property USE_OFFLOAD UNITS None
set_parameter_property USE_OFFLOAD ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USE_OFFLOAD DESCRIPTION ""
set_parameter_property USE_OFFLOAD HDL_PARAMETER true
add_display_item "Config Stream Parameters" USE_OFFLOAD parameter


proc compose { } {
    set USE_AVST_EP         [get_parameter_value USE_AVST_EP]
    set USE_CONFIG_STR_EP   [get_parameter_value USE_CONFIG_STR_EP]
    set MFR_CODE            [get_parameter_value MFR_CODE]
    set TYPE_CODE           [get_parameter_value TYPE_CODE]
    set PREFER_HOST         [get_parameter_value PREFER_HOST]
    set USE_STREAM          [get_parameter_value USE_STREAM]
    set USE_OFFLOAD         [get_parameter_value USE_OFFLOAD]

    # Instances and instance parameters
    # (disabled instances are intentionally culled)
    add_instance clock_bridge altera_clock_bridge 18.1
    set_instance_parameter_value clock_bridge {EXPLICIT_CLOCK_RATE} {0.0}
    set_instance_parameter_value clock_bridge {NUM_CLOCK_OUTPUTS} {1}

    add_instance reset_bridge altera_reset_bridge 18.1
    set_instance_parameter_value reset_bridge {ACTIVE_LOW_RESET} {0}
    set_instance_parameter_value reset_bridge {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset_bridge {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset_bridge {USE_RESET_REQUEST} {0}

    add_instance config_debug_agent_bridge altera_config_debug_agent_bridge 18.1
    set_instance_parameter_value config_debug_agent_bridge {MFR_CODE} {0}
    set_instance_parameter_value config_debug_agent_bridge {TYPE_CODE} {0}
    set_instance_parameter_value config_debug_agent_bridge {PREFER_HOST} {JTAG}
    set_instance_parameter_value config_debug_agent_bridge {USE_STREAM} $USE_STREAM
    set_instance_parameter_value config_debug_agent_bridge {USE_OFFLOAD} {0}

    if {$USE_CONFIG_STR_EP != 0} {
        add_instance config_stream_endpoint_0 altera_config_stream_endpoint 18.1
        set_instance_parameter_value config_stream_endpoint_0 {READY_LATENCY} {0}
        set_instance_parameter_value config_stream_endpoint_0 {HAS_URGENT} {0}
        set_instance_parameter_value config_stream_endpoint_0 {HAS_STREAM} $USE_STREAM
        set_instance_parameter_value config_stream_endpoint_0 {MAX_SIZE} {256}
        set_instance_parameter_value config_stream_endpoint_0 {STREAM_WIDTH} {32}
    }

    if {$USE_AVST_EP != 0} {
        add_instance st_debug_agent_endpoint_0 altera_avalon_st_debug_agent_endpoint 18.1
        set_instance_parameter_value st_debug_agent_endpoint_0 {DATA_WIDTH} {32}
        set_instance_parameter_value st_debug_agent_endpoint_0 {CHANNEL_WIDTH} {4}
        set_instance_parameter_value st_debug_agent_endpoint_0 {HAS_MGMT} {0}
        set_instance_parameter_value st_debug_agent_endpoint_0 {READY_LATENCY} {0}
        set_instance_parameter_value st_debug_agent_endpoint_0 {MFR_CODE} $MFR_CODE
        set_instance_parameter_value st_debug_agent_endpoint_0 {TYPE_CODE} $TYPE_CODE
        set_instance_parameter_value st_debug_agent_endpoint_0 {PREFER_HOST} $TYPE_CODE
    }

    # connections and connection parameters
    add_connection clock_bridge.out_clk reset_bridge.clk clock
    add_connection clock_bridge.out_clk config_debug_agent_bridge.clk clock
    add_connection reset_bridge.out_reset config_debug_agent_bridge.reset reset

    if {$USE_AVST_EP != 0} {
        add_connection clock_bridge.out_clk st_debug_agent_endpoint_0.clk clock
        add_connection st_debug_agent_endpoint_0.reset config_debug_agent_bridge.reset reset
        add_connection st_debug_agent_endpoint_0.h2t config_debug_agent_bridge.h2t avalon_streaming
        add_connection config_debug_agent_bridge.t2h st_debug_agent_endpoint_0.t2h avalon_streaming
    } else {
        add_interface h2t avalon_streaming sink
        set_interface_property h2t EXPORT_OF config_debug_agent_bridge.h2t
        add_interface t2h avalon_streaming source
        set_interface_property t2h EXPORT_OF config_debug_agent_bridge.t2h
    }

    if {$USE_CONFIG_STR_EP != 0} {
        add_connection clock_bridge.out_clk config_stream_endpoint_0.clk clock 
        add_connection reset_bridge.out_reset config_stream_endpoint_0.reset reset
        add_connection config_stream_endpoint_0.response config_debug_agent_bridge.response avalon_streaming
        add_connection config_debug_agent_bridge.command config_stream_endpoint_0.command avalon_streaming
        if {$USE_STREAM != 0} {
            add_connection config_debug_agent_bridge.stream config_stream_endpoint_0.stream avalon_streaming
            add_connection config_debug_agent_bridge.stream_active config_stream_endpoint_0.stream_active conduit
        }
        if {$USE_AVST_EP != 0} {
            add_connection st_debug_agent_endpoint_0.reset config_stream_endpoint_0.reset reset
        }
    } else {
        add_interface command avalon_streaming source
        set_interface_property command EXPORT_OF config_debug_agent_bridge.command
        add_interface response avalon_streaming sink
        set_interface_property response EXPORT_OF config_debug_agent_bridge.response
        if {$USE_STREAM != 0} {
            add_interface stream avalon_streaming source
            set_interface_property stream EXPORT_OF config_debug_agent_bridge.stream
            add_interface stream_active conduit end
            set_interface_property stream_active EXPORT_OF config_debug_agent_bridge.stream_active
        }
    }

    # exported interfaces
    add_interface in_clk clock sink
    set_interface_property in_clk EXPORT_OF clock_bridge.in_clk
    add_interface in_reset reset sink
    set_interface_property in_reset EXPORT_OF reset_bridge.in_reset
}
