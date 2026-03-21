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


# $Id: //acds/rel/18.1std/ip/sld/trace/monitors/altera_trace_adc_monitor/altera_trace_adc_monitor_core_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

package require -exact qsys 13.0
# 
# module altera_trace_adc_monitor_core
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_trace_adc_monitor_core
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Altera Trace ADC Monitor Core"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_trace_adc_monitor_core
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file altera_trace_adc_monitor_core.sv SYSTEM_VERILOG PATH altera_trace_adc_monitor_core.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_trace_adc_monitor_core
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file altera_trace_adc_monitor_core.sv SYSTEM_VERILOG PATH altera_trace_adc_monitor_core.sv


# 
# parameters
# 
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

add_parameter CLOCK_FREQ LONG
set_parameter_property CLOCK_FREQ DEFAULT_VALUE 0
set_parameter_property CLOCK_FREQ DISPLAY_NAME CLOCK_FREQ
set_parameter_property CLOCK_FREQ VISIBLE 0
set_parameter_property CLOCK_FREQ AFFECTS_ELABORATION 1
set_parameter_property CLOCK_FREQ HDL_PARAMETER 0
#set_parameter_property CLOCK_FREQ SYSTEM_INFO {clock_rate clk}
#set_parameter_property CLOCK_FREQ SYSTEM_INFO_TYPE CLOCK_RATE
#set_parameter_property CLOCK_FREQ SYSTEM_INFO_ARG {clock}

add_parameter DELAY_COUNT_WIDTH INTEGER 24
set_parameter_property DELAY_COUNT_WIDTH DISPLAY_NAME DELAY_COUNT_WIDTH
set_parameter_property DELAY_COUNT_WIDTH ENABLED true
set_parameter_property DELAY_COUNT_WIDTH UNITS None
set_parameter_property DELAY_COUNT_WIDTH ALLOWED_RANGES {0-24}
set_parameter_property DELAY_COUNT_WIDTH HDL_PARAMETER true
set_parameter_property DELAY_COUNT_WIDTH VISIBLE false
set_parameter_property DELAY_COUNT_WIDTH DERIVED true

add_parameter DELAY_COUNT_CYCLES INTEGER 500000
set_parameter_property DELAY_COUNT_CYCLES DISPLAY_NAME DELAY_COUNT_CYCLES
set_parameter_property DELAY_COUNT_CYCLES ENABLED true
set_parameter_property DELAY_COUNT_CYCLES UNITS None
set_parameter_property DELAY_COUNT_CYCLES ALLOWED_RANGES {0-24}
set_parameter_property DELAY_COUNT_CYCLES HDL_PARAMETER true
set_parameter_property DELAY_COUNT_CYCLES VISIBLE false
set_parameter_property DELAY_COUNT_CYCLES DERIVED true

add_parameter DELAY_MS FLOAT 10
set_parameter_property DELAY_MS DISPLAY_NAME DELAY_MS
set_parameter_property DELAY_MS ENABLED false
set_parameter_property DELAY_MS UNITS MILLISECONDS
set_parameter_property DELAY_MS HDL_PARAMETER false
set_parameter_property DELAY_MS VISIBLE false

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
# connection point adc_data
# 
add_interface adc_data avalon_streaming end
set_interface_property adc_data associatedClock clock
set_interface_property adc_data associatedReset reset
set_interface_property adc_data dataBitsPerSymbol 12
set_interface_property adc_data errorDescriptor ""
set_interface_property adc_data firstSymbolInHighOrderBits true
set_interface_property adc_data maxChannel 31
set_interface_property adc_data readyLatency 0
set_interface_property adc_data ENABLED true
set_interface_property adc_data EXPORT_OF ""
set_interface_property adc_data PORT_NAME_MAP ""
set_interface_property adc_data CMSIS_SVD_VARIABLES ""
set_interface_property adc_data SVD_ADDRESS_GROUP ""

add_interface_port adc_data adc_channel channel Input 5
add_interface_port adc_data adc_data data Input 12
add_interface_port adc_data adc_endofpacket endofpacket Input 1
add_interface_port adc_data adc_startofpacket startofpacket Input 1
add_interface_port adc_data adc_valid valid Input 1

# 
# connection point control
# 
add_interface control avalon end
set_interface_property control addressUnits WORDS
set_interface_property control associatedClock clock
set_interface_property control associatedReset reset
set_interface_property control bitsPerSymbol 8
set_interface_property control burstOnBurstBoundariesOnly false
set_interface_property control burstcountUnits WORDS
set_interface_property control explicitAddressSpan 0
set_interface_property control holdTime 0
set_interface_property control linewrapBursts false
set_interface_property control maximumPendingReadTransactions 0
set_interface_property control readLatency 1
set_interface_property control readWaitTime 1
set_interface_property control setupTime 0
set_interface_property control timingUnits Cycles
set_interface_property control writeWaitTime 0
set_interface_property control ENABLED true

add_interface_port control control_address address Input CONTROL_ADDRESS_WIDTH
add_interface_port control control_read read Input 1
add_interface_port control control_write write Input 1
add_interface_port control control_writedata writedata Input CONTROL_DATA_WIDTH
add_interface_port control control_readdata readdata Output CONTROL_DATA_WIDTH

set_interface_assignment control embeddedsw.configuration.isFlash 0
set_interface_assignment control embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment control embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment control embeddedsw.configuration.isPrintableDevice 0

# 
# connection point capture
# 
add_interface capture avalon_streaming start
set_interface_property capture associatedClock clock
set_interface_property capture associatedReset reset
set_interface_property capture dataBitsPerSymbol 8
set_interface_property capture errorDescriptor ""
set_interface_property capture firstSymbolInHighOrderBits true
set_interface_property capture maxChannel 0
set_interface_property capture readyLatency 0
set_interface_property capture ENABLED true

add_interface_port capture capture_data data Output CAPTURE_DATA_WIDTH
add_interface_port capture capture_valid valid Output 1
add_interface_port capture capture_ready ready Input 1
add_interface_port capture capture_startofpacket startofpacket Output 1
add_interface_port capture capture_endofpacket endofpacket Output 1

set_interface_assignment capture debug.providesServices traceMonitor
set_interface_assignment capture debug.interfaceGroup {associatedControl control}
set_interface_assignment capture debug.monitoredInterfaces adc_data
set_interface_assignment capture debug.visible true

set_interface_assignment capture debug.param.setting.Enable {
  proc get_value {c i} { expr { ([ trace_read_monitor $c $i 4 ] & 1) != 0 } }
  proc set_value {c i v} {
    set read_value [ expr { [ trace_read_monitor $c $i 4 ] & ~1 } ]
    set write_value [ expr { $read_value | (($v != 0) ? 1 : 0) } ]
    trace_write_monitor $c $i 4 $write_value
  }
  set hints boolean
}

set_interface_assignment capture debug.param.setting.Run {
  proc get_value {c i} { expr { ([ trace_read_monitor $c $i 4 ] & 2 ) != 0 } }
  proc set_value {c i v} {
    set read_value [ expr { [ trace_read_monitor $c $i 4 ] & ~2 } ]
    set write_value [ expr { $read_value | (($v != 0) ? 2 : 0) } ]
    trace_write_monitor $c $i 4 $write_value
  }
  set hints boolean
}

set_interface_assignment capture debug.param.setting.Count {
  proc get_value {c i} {expr [ trace_read_monitor $c $i 4 ] >> 8 }
    proc set_value {c i v} {
      set read_value [ expr { [ trace_read_monitor $c $i 4 ] & 0xFF } ]
      set write_value [ expr { $read_value | ($v << 8) } ]
      trace_write_monitor $c $i 4 $write_value
    }
}

set_interface_assignment capture debug.typeName altera_trace_adc_monitor.capture

proc elaborate {} {
  set delay_ms [ get_parameter_value DELAY_MS ]

  if { $delay_ms < 0 || $delay_ms > 100 } {
    send_message error "DELAY_MS must be between 0 and 100 (is: $delay_ms)"
  }

  set clock_rate [ get_parameter_value CLOCK_FREQ ]
  if { $clock_rate == 0 } {
    send_message warning "Unknown clock rate; $delay_ms ms startup delay will be computed assuming a clock rate of 50MHz."
    set clock_rate 50000000
  }

  set delay_count_cycles [ expr $delay_ms * $clock_rate / 1000 ]
  set delay_count_width [ expr ceil(log($delay_count_cycles) / log(2)) ]
  if { $delay_count_width < 1 } {
    set delay_count_width 1
  }
  if { $delay_count_cycles < 1 } {
    set $delay_count_cycles 1
  }
  set_parameter_value DELAY_COUNT_WIDTH $delay_count_width
  set_parameter_value DELAY_COUNT_CYCLES $delay_count_cycles

  add_hdl_instance altera_trace_adc_monitor_wa_inst altera_trace_adc_monitor_wa

  set_interface_assignment capture debug.param.virtual_register(-1) [ get_parameter_value COUNT_WIDTH ]

  set_interface_assignment capture debug.param.adc_control_0_reference_voltage [ get_parameter_value REFERENCE_VOLTAGE ]
  set_interface_assignment capture debug.param.adc_control_count [ get_parameter_value CONTROL_COUNT ]
  set_interface_assignment capture debug.param.adc_control_0_sample_freq [ get_parameter_value SAMPLE_FREQ ]
  set_interface_assignment capture debug.param.adc_control_0_sample_freq_temp_sense [ get_parameter_value SAMPLE_FREQ_TEMP_SENSE ]
  set_interface_assignment capture debug.param.adc_control_0_sequence [ get_parameter_value SEQUENCE ]
  set_interface_assignment capture debug.param.adc_control_0_count_width [ get_parameter_value COUNT_WIDTH ]

}

