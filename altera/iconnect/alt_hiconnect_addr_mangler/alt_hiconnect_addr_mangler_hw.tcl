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


# $Id: //acds/rel/18.1std/ip/iconnect/alt_hiconnect_addr_mangler/alt_hiconnect_addr_mangler_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

package require -exact qsys 15.0

set_module_property NAME alt_hiconnect_addr_mangler
set_module_property VERSION 18.1
set_module_property GROUP "Qsys Interconnect/Memory-Mapped Alpha"
set_module_property DISPLAY_NAME "Memory Mapped Address Mangler"
set_module_property DESCRIPTION "Does the whole address incrementing stuff"
set_module_property AUTHOR "Altera Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property INTERNAL true
set_module_property ELABORATION_CALLBACK elaborate
set_module_property HIDE_FROM_QUARTUS true
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf

# +-----------------------------------
# | files
# | 

add_fileset synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
set_fileset_property synthesis_fileset TOP_LEVEL alt_hiconnect_addr_mangler
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL alt_hiconnect_addr_mangler
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure
set_fileset_property vhdl_fileset TOP_LEVEL alt_hiconnect_addr_mangler

proc synth_callback_procedure { entity_name } {
    add_fileset_file alt_hiconnect_addr_mangler.sv SYSTEM_VERILOG PATH "alt_hiconnect_addr_mangler.sv"
}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter PKT_ADDR_H INTEGER 60
set_parameter_property PKT_ADDR_H DISPLAY_NAME {Input packet address field index - high}
set_parameter_property PKT_ADDR_H UNITS None
set_parameter_property PKT_ADDR_H ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_ADDR_H DISPLAY_HINT ""
set_parameter_property PKT_ADDR_H AFFECTS_GENERATION false
set_parameter_property PKT_ADDR_H HDL_PARAMETER true
set_parameter_property PKT_ADDR_H DESCRIPTION {MSB of the input packet address field index}
add_parameter PKT_ADDR_L INTEGER 36
set_parameter_property PKT_ADDR_L DISPLAY_NAME {Input packet address field index - low}
set_parameter_property PKT_ADDR_L UNITS None
set_parameter_property PKT_ADDR_L ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_ADDR_L DISPLAY_HINT ""
set_parameter_property PKT_ADDR_L AFFECTS_GENERATION false
set_parameter_property PKT_ADDR_L HDL_PARAMETER true
set_parameter_property PKT_ADDR_L DESCRIPTION {LSB of the input packet address field index}

add_parameter PKT_BYTEEN_H INTEGER 35
set_parameter_property PKT_BYTEEN_H DISPLAY_NAME {Input packet byteenable field index - high}
set_parameter_property PKT_BYTEEN_H UNITS None
set_parameter_property PKT_BYTEEN_H ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_BYTEEN_H DISPLAY_HINT ""
set_parameter_property PKT_BYTEEN_H AFFECTS_GENERATION false
set_parameter_property PKT_BYTEEN_H HDL_PARAMETER true
set_parameter_property PKT_BYTEEN_H DESCRIPTION {MSB of the input packet byteenable field index}
add_parameter PKT_BYTEEN_L INTEGER 32
set_parameter_property PKT_BYTEEN_L DISPLAY_NAME {Input packet byteenable field index - low}
set_parameter_property PKT_BYTEEN_L UNITS None
set_parameter_property PKT_BYTEEN_L ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_BYTEEN_L DISPLAY_HINT ""
set_parameter_property PKT_BYTEEN_L AFFECTS_GENERATION false
set_parameter_property PKT_BYTEEN_L HDL_PARAMETER true
set_parameter_property PKT_BYTEEN_L DESCRIPTION {LSB of the input packet byteenable field index}

add_parameter PKT_BURSTWRAP_H INTEGER 67
set_parameter_property PKT_BURSTWRAP_H DISPLAY_NAME {Input packet burstwrap field index - high}
set_parameter_property PKT_BURSTWRAP_H UNITS None
set_parameter_property PKT_BURSTWRAP_H ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_BURSTWRAP_H DISPLAY_HINT ""
set_parameter_property PKT_BURSTWRAP_H AFFECTS_GENERATION false
set_parameter_property PKT_BURSTWRAP_H HDL_PARAMETER true
set_parameter_property PKT_BURSTWRAP_H DESCRIPTION {MSB of the input packet burstwrap field index}
add_parameter PKT_BURSTWRAP_L INTEGER 66 
set_parameter_property PKT_BURSTWRAP_L DISPLAY_NAME {Input packet burstwrap field index - low}
set_parameter_property PKT_BURSTWRAP_L UNITS None
set_parameter_property PKT_BURSTWRAP_L ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_BURSTWRAP_L DISPLAY_HINT ""
set_parameter_property PKT_BURSTWRAP_L AFFECTS_GENERATION false
set_parameter_property PKT_BURSTWRAP_L HDL_PARAMETER true
set_parameter_property PKT_BURSTWRAP_L DESCRIPTION {LSB of the input packet burstwrap field index}

add_parameter PKT_BURST_SIZE_H INTEGER 70
set_parameter_property PKT_BURST_SIZE_H DISPLAY_NAME {Input packet burst size field index - high}
set_parameter_property PKT_BURST_SIZE_H UNITS None
set_parameter_property PKT_BURST_SIZE_H ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_BURST_SIZE_H DISPLAY_HINT ""
set_parameter_property PKT_BURST_SIZE_H AFFECTS_GENERATION false
set_parameter_property PKT_BURST_SIZE_H HDL_PARAMETER true
set_parameter_property PKT_BURST_SIZE_H DESCRIPTION {MSB of the input packet burst size field index}
add_parameter PKT_BURST_SIZE_L INTEGER 68 
set_parameter_property PKT_BURST_SIZE_L DISPLAY_NAME {Input packet burst size field index - low}
set_parameter_property PKT_BURST_SIZE_L UNITS None
set_parameter_property PKT_BURST_SIZE_L ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_BURST_SIZE_L DISPLAY_HINT ""
set_parameter_property PKT_BURST_SIZE_L AFFECTS_GENERATION false
set_parameter_property PKT_BURST_SIZE_L HDL_PARAMETER true
set_parameter_property PKT_BURST_SIZE_L DESCRIPTION {LSB of the input packet burst size field index}

add_parameter PKT_BURST_TYPE_H INTEGER 75
set_parameter_property PKT_BURST_TYPE_H DISPLAY_NAME {Input packet burst type field index - high}
set_parameter_property PKT_BURST_TYPE_H UNITS None
set_parameter_property PKT_BURST_TYPE_H ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_BURST_TYPE_H DISPLAY_HINT ""
set_parameter_property PKT_BURST_TYPE_H AFFECTS_GENERATION false
set_parameter_property PKT_BURST_TYPE_H HDL_PARAMETER true
set_parameter_property PKT_BURST_TYPE_H DESCRIPTION {MSB of the input packet burst type field index}
add_parameter PKT_BURST_TYPE_L INTEGER 74 
set_parameter_property PKT_BURST_TYPE_L DISPLAY_NAME {Input packet burst type field index - low}
set_parameter_property PKT_BURST_TYPE_L UNITS None
set_parameter_property PKT_BURST_TYPE_L ALLOWED_RANGES 0:2147483647
set_parameter_property PKT_BURST_TYPE_L DISPLAY_HINT ""
set_parameter_property PKT_BURST_TYPE_L AFFECTS_GENERATION false
set_parameter_property PKT_BURST_TYPE_L HDL_PARAMETER true
set_parameter_property PKT_BURST_TYPE_L DESCRIPTION {LSB of the input packet burst type field index}

add_parameter ST_DATA_W INTEGER 76
set_parameter_property ST_DATA_W DISPLAY_NAME {ST data width}
set_parameter_property ST_DATA_W UNITS None
set_parameter_property ST_DATA_W ALLOWED_RANGES 0:2147483647
set_parameter_property ST_DATA_W DISPLAY_HINT ""
set_parameter_property ST_DATA_W AFFECTS_GENERATION false
set_parameter_property ST_DATA_W HDL_PARAMETER true
set_parameter_property ST_DATA_W DESCRIPTION {Packet data width}

add_parameter ST_CHANNEL_W INTEGER 32
set_parameter_property ST_CHANNEL_W DISPLAY_NAME {Streaming channel width}
set_parameter_property ST_CHANNEL_W UNITS None
set_parameter_property ST_CHANNEL_W ALLOWED_RANGES 0:2147483647
set_parameter_property ST_CHANNEL_W DISPLAY_HINT ""
set_parameter_property ST_CHANNEL_W AFFECTS_GENERATION false
set_parameter_property ST_CHANNEL_W HDL_PARAMETER true
set_parameter_property ST_CHANNEL_W DESCRIPTION {Streaming channel width}

add_parameter ADDR_HAS_4K_BOUNDARIES INTEGER 0
set_parameter_property ADDR_HAS_4K_BOUNDARIES DEFAULT_VALUE 0
set_parameter_property ADDR_HAS_4K_BOUNDARIES DISPLAY_NAME "Enable 4K address boundary optimization"
set_parameter_property ADDR_HAS_4K_BOUNDARIES DESCRIPTION "Parameter controlling the 4K address boundary optimization applicable to AXI slaves and Avalon slaves which only have connectivity with AXI masters."
set_parameter_property ADDR_HAS_4K_BOUNDARIES AFFECTS_GENERATION false
set_parameter_property ADDR_HAS_4K_BOUNDARIES HDL_PARAMETER true

add_parameter IN_FIXED_OR_RESERVED_BURST INTEGER 1
set_parameter_property IN_FIXED_OR_RESERVED_BURST DEFAULT_VALUE 1
set_parameter_property IN_FIXED_OR_RESERVED_BURST DISPLAY_NAME "Specifies the address mangler will have to process incoming RESERVED or FIXED bursts"
set_parameter_property IN_FIXED_OR_RESERVED_BURST AFFECTS_GENERATION false
set_parameter_property IN_FIXED_OR_RESERVED_BURST HDL_PARAMETER true

add_parameter IN_WRAP_BURST INTEGER 1
set_parameter_property IN_WRAP_BURST DEFAULT_VALUE 1
set_parameter_property IN_WRAP_BURST DISPLAY_NAME "Specifies the address mangler will have to process incoming WRAP bursts"
set_parameter_property IN_WRAP_BURST AFFECTS_GENERATION false
set_parameter_property IN_WRAP_BURST HDL_PARAMETER true

add_parameter IN_INCR_BURST INTEGER 1
set_parameter_property IN_INCR_BURST DEFAULT_VALUE 1
set_parameter_property IN_INCR_BURST DISPLAY_NAME "Specifies the address mangler will have to process incoming INCR bursts"
set_parameter_property IN_INCR_BURST AFFECTS_GENERATION false
set_parameter_property IN_INCR_BURST HDL_PARAMETER true

add_parameter MERLIN_PACKET_FORMAT String ""
set_parameter_property MERLIN_PACKET_FORMAT DISPLAY_NAME {Merlin packet format descriptor}
set_parameter_property MERLIN_PACKET_FORMAT UNITS None
set_parameter_property MERLIN_PACKET_FORMAT DESCRIPTION {Merlin packet format descriptor}
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk
# | 
add_interface clk clock end
set_interface_property clk ptfSchematicName ""

set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF true

add_interface_port clk clk clk Input 1
add_interface_port clk reset reset Input 1

set_interface_property clk_reset synchronousEdges BOTH
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point sink
# | 
add_interface sink avalon_streaming end
set_interface_property sink dataBitsPerSymbol 64
set_interface_property sink errorDescriptor ""
set_interface_property sink maxChannel 0
set_interface_property sink readyLatency 0
set_interface_property sink symbolsPerBeat 1

set_interface_property sink ASSOCIATED_CLOCK clk
set_interface_property sink ENABLED true
set_interface_property sink EXPORT_OF true

add_interface_port sink sink_valid valid Input 1
add_interface_port sink sink_channel channel Input 1
add_interface_port sink sink_startofpacket startofpacket Input 1
add_interface_port sink sink_endofpacket endofpacket Input 1
add_interface_port sink sink_ready ready Output 1
add_interface_port sink sink_data data Input 64
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point src
# | 
add_interface src avalon_streaming start
set_interface_property src dataBitsPerSymbol 64
set_interface_property src errorDescriptor ""
set_interface_property src maxChannel 0
set_interface_property src readyLatency 0
set_interface_property src symbolsPerBeat 1

set_interface_property src ASSOCIATED_CLOCK clk
set_interface_property src ENABLED true
set_interface_property src EXPORT_OF true

add_interface_port src src_endofpacket endofpacket Output 1
add_interface_port src src_data data Output 64
add_interface_port src src_channel channel Output 1
add_interface_port src src_valid valid Output 1
add_interface_port src src_ready ready Input 1
add_interface_port src src_startofpacket startofpacket Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaborate {} {

    set st_data_width [ get_parameter_value ST_DATA_W  ]
    set st_chan_width [ get_parameter_value ST_CHANNEL_W  ]
    set fields        [ get_parameter_value MERLIN_PACKET_FORMAT ]

    set_interface_property src  dataBitsPerSymbol $st_data_width
    set_interface_property sink dataBitsPerSymbol $st_data_width

    set_port_property sink_data WIDTH_EXPR $st_data_width
	set_port_property sink_data vhdl_type std_logic_vector
    set_port_property src_data WIDTH_EXPR $st_data_width
	set_port_property src_data vhdl_type std_logic_vector

    set_interface_assignment sink merlin.packet_format $fields
    set_interface_assignment src merlin.packet_format $fields

    set_interface_assignment sink merlin.flow.src src

    set_port_property sink_channel WIDTH_EXPR $st_chan_width
	set_port_property sink_channel vhdl_type std_logic_vector
    set_port_property src_channel WIDTH_EXPR $st_chan_width
	set_port_property src_channel vhdl_type std_logic_vector
}

