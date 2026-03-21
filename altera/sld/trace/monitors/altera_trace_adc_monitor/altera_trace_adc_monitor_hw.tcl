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


# $Id: //acds/rel/18.1std/ip/sld/trace/monitors/altera_trace_adc_monitor/altera_trace_adc_monitor_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

package require -exact qsys 13.0

# module properties
set_module_property NAME altera_trace_adc_monitor
set_module_property DISPLAY_NAME "Altera Trace ADC Monitor"

set_module_property VERSION 18.1
set_module_property DESCRIPTION ""
set_module_property AUTHOR "Altera Corporation"
set_module_property COMPOSITION_CALLBACK compose
set_module_property OPAQUE_ADDRESS_MAP false
set_module_property INTERNAL true

add_parameter ADC_DATA_WIDTH INTEGER 12
set_parameter_property ADC_DATA_WIDTH DISPLAY_NAME ADC_DATA_WIDTH
set_parameter_property ADC_DATA_WIDTH ENABLED false
set_parameter_property ADC_DATA_WIDTH UNITS None
set_parameter_property ADC_DATA_WIDTH ALLOWED_RANGES {12}
set_parameter_property ADC_DATA_WIDTH HDL_PARAMETER true
set_parameter_property ADC_DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADC_DATA_WIDTH VISIBLE false

add_parameter ADC_CHANNEL_WIDTH INTEGER 5
set_parameter_property ADC_CHANNEL_WIDTH DISPLAY_NAME ADC_CHANNEL_WIDTH
set_parameter_property ADC_CHANNEL_WIDTH ENABLED false
set_parameter_property ADC_CHANNEL_WIDTH UNITS None
set_parameter_property ADC_CHANNEL_WIDTH ALLOWED_RANGES {5}
set_parameter_property ADC_CHANNEL_WIDTH HDL_PARAMETER true
set_parameter_property ADC_CHANNEL_WIDTH VISIBLE false

add_parameter CAPTURE_DATA_WIDTH INTEGER 8
set_parameter_property CAPTURE_DATA_WIDTH DISPLAY_NAME CAPTURE_DATA_WIDTH
set_parameter_property CAPTURE_DATA_WIDTH ENABLED false
set_parameter_property CAPTURE_DATA_WIDTH UNITS None
set_parameter_property CAPTURE_DATA_WIDTH ALLOWED_RANGES {8}
set_parameter_property CAPTURE_DATA_WIDTH HDL_PARAMETER true
set_parameter_property CAPTURE_DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property CAPTURE_DATA_WIDTH VISIBLE false

add_parameter CONTROL_DATA_WIDTH INTEGER 32
set_parameter_property CONTROL_DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property CONTROL_DATA_WIDTH ENABLED false
set_parameter_property CONTROL_DATA_WIDTH UNITS None
set_parameter_property CONTROL_DATA_WIDTH ALLOWED_RANGES {32}
set_parameter_property CONTROL_DATA_WIDTH HDL_PARAMETER true
set_parameter_property CONTROL_DATA_WIDTH VISIBLE false

add_parameter CONTROL_ADDRESS_WIDTH INTEGER 5
set_parameter_property CONTROL_ADDRESS_WIDTH DISPLAY_NAME CONTROL_ADDRESS_WIDTH
set_parameter_property CONTROL_ADDRESS_WIDTH ENABLED false
set_parameter_property CONTROL_ADDRESS_WIDTH UNITS None
set_parameter_property CONTROL_ADDRESS_WIDTH ALLOWED_RANGES {5}
set_parameter_property CONTROL_ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property CONTROL_ADDRESS_WIDTH VISIBLE false

add_parameter COUNT_WIDTH INTEGER 12
set_parameter_property COUNT_WIDTH DISPLAY_NAME COUNT_WIDTH
set_parameter_property COUNT_WIDTH ENABLED true
set_parameter_property COUNT_WIDTH UNITS None
set_parameter_property COUNT_WIDTH ALLOWED_RANGES {4-24}
set_parameter_property COUNT_WIDTH HDL_PARAMETER true
set_parameter_property COUNT_WIDTH VISIBLE true

add_parameter REFERENCE_VOLTAGE FLOAT 2.5
set_parameter_property REFERENCE_VOLTAGE DISPLAY_NAME        "ADC Reference Voltage"
set_parameter_property REFERENCE_VOLTAGE AFFECTS_ELABORATION  true
set_parameter_property REFERENCE_VOLTAGE HDL_PARAMETER       false
set_parameter_property REFERENCE_VOLTAGE VISIBLE             false
set_parameter_property REFERENCE_VOLTAGE DERIVED             false

add_parameter CONTROL_COUNT INTEGER 1
set_parameter_property CONTROL_COUNT DISPLAY_NAME        "ADC Control Count"
set_parameter_property CONTROL_COUNT AFFECTS_ELABORATION  true
set_parameter_property CONTROL_COUNT HDL_PARAMETER       false
set_parameter_property CONTROL_COUNT VISIBLE             false
set_parameter_property CONTROL_COUNT DERIVED             false

add_parameter SAMPLE_FREQ INTEGER 10000000
set_parameter_property SAMPLE_FREQ DISPLAY_NAME        "ADC Sample Frequency"
set_parameter_property SAMPLE_FREQ AFFECTS_ELABORATION  true
set_parameter_property SAMPLE_FREQ HDL_PARAMETER       false
set_parameter_property SAMPLE_FREQ VISIBLE             false
set_parameter_property SAMPLE_FREQ DERIVED             false

add_parameter SAMPLE_FREQ_TEMP_SENSE INTEGER 10000000
set_parameter_property SAMPLE_FREQ_TEMP_SENSE DISPLAY_NAME        "ADC Sample Frequency Temperature Sense"
set_parameter_property SAMPLE_FREQ_TEMP_SENSE AFFECTS_ELABORATION  true
set_parameter_property SAMPLE_FREQ_TEMP_SENSE HDL_PARAMETER       false
set_parameter_property SAMPLE_FREQ_TEMP_SENSE VISIBLE             false
set_parameter_property SAMPLE_FREQ_TEMP_SENSE DERIVED             false

add_parameter SEQUENCE STRING ""
set_parameter_property SEQUENCE DISPLAY_NAME        "ADC Sample Sequence"
set_parameter_property SEQUENCE AFFECTS_ELABORATION  true
set_parameter_property SEQUENCE HDL_PARAMETER       false
set_parameter_property SEQUENCE VISIBLE             false
set_parameter_property SEQUENCE DERIVED             false

add_parameter CLOCK_FREQ LONG
set_parameter_property CLOCK_FREQ DEFAULT_VALUE 0
set_parameter_property CLOCK_FREQ DISPLAY_NAME CLOCK_FREQ
set_parameter_property CLOCK_FREQ VISIBLE 0
set_parameter_property CLOCK_FREQ AFFECTS_ELABORATION 1
set_parameter_property CLOCK_FREQ HDL_PARAMETER 0

add_instance clock_bridge altera_clock_bridge  

add_interface clk clock end
set_interface_property clk export_of clock_bridge.in_clk

add_instance reset_bridge altera_reset_bridge
set_instance_parameter reset_bridge SYNCHRONOUS_EDGES deassert

add_connection clock_bridge.out_clk reset_bridge.clk

add_interface reset reset end
set_interface_property reset export_of reset_bridge.in_reset

proc set_core_value { parameter } {
  set_instance_parameter_value core $parameter [ get_parameter_value $parameter ]
}

proc compose { } {

    add_instance core altera_trace_adc_monitor_core
    set_core_value COUNT_WIDTH
    set_core_value REFERENCE_VOLTAGE
    set_core_value CONTROL_COUNT
    set_core_value SAMPLE_FREQ
    set_core_value SAMPLE_FREQ_TEMP_SENSE
    set_core_value SEQUENCE
    set_core_value CLOCK_FREQ

    add_instance trace_endpoint altera_trace_monitor_endpoint
    set_instance_parameter_value trace_endpoint TRACE_WIDTH [ get_parameter_value CAPTURE_DATA_WIDTH ]
    set_instance_parameter_value trace_endpoint ADDR_WIDTH [ get_parameter_value CONTROL_ADDRESS_WIDTH ]
    set_instance_parameter_value trace_endpoint READ_LATENCY 1

    # Everything on the same clock domain
    add_connection clock_bridge.out_clk core.clock clock
    add_connection clock_bridge.out_clk trace_endpoint.clk clock

    # Reset connections from the trace endpoint (debug reset domain).
    add_connection trace_endpoint.debug_reset core.reset reset
    add_connection reset_bridge.out_reset core.reset reset

    add_connection core.capture trace_endpoint.capture avalon_streaming

    add_connection trace_endpoint.control core.control avalon

    add_interface adc_data avalon_streaming end
    set_interface_property adc_data EXPORT_OF core.adc_data

}

