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


# $Id: //acds/rel/18.1std/ip/pgm/lib/altera_nd_hiconnect_mux/altera_nd_hiconnect_mux_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

package require -exact qsys 15.0
package require -exact altera_terp 1.0

set_module_property NAME altera_nd_hiconnect_mux
set_module_property VERSION 18.1
#set_module_property GROUP "Qsys Interconnect/Memory-Mapped Alpha"
set_module_property DISPLAY_NAME "ND Mailbox Multiplexer"
set_module_property DESCRIPTION "Mux with one-hot select signals"
set_module_property AUTHOR "Altera Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property INTERNAL true
set_module_property ELABORATION_CALLBACK elaborate
set_module_property HIDE_FROM_QUARTUS true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list

add_fileset synth_fileset QUARTUS_SYNTH synth_callback_procedure
add_fileset synthver_fileset SIM_VERILOG synth_callback_procedure
add_fileset synthvhd_fileset SIM_VHDL synth_callback_procedure

# +-----------------------------------
# | parameters
# +-----------------------------------
add_parameter ST_DATA_W INTEGER 71 0
set_parameter_property ST_DATA_W DISPLAY_NAME {Streaming data width}
set_parameter_property ST_DATA_W UNITS None
set_parameter_property ST_DATA_W ALLOWED_RANGES 0:2147483647
set_parameter_property ST_DATA_W DESCRIPTION {StreamingPacket data width}
set_parameter_property ST_DATA_W AFFECTS_ELABORATION true
set_parameter_property ST_DATA_W HDL_PARAMETER false

add_parameter NUM_INPUTS INTEGER 2 0
set_parameter_property NUM_INPUTS DISPLAY_NAME {Number of mux inputs}
set_parameter_property NUM_INPUTS UNITS None
set_parameter_property NUM_INPUTS DESCRIPTION {Number of mux inputs}
set_parameter_property NUM_INPUTS AFFECTS_ELABORATION true
set_parameter_property NUM_INPUTS HDL_PARAMETER false

add_parameter USE_SELECT INTEGER 1 0
set_parameter_property USE_SELECT DISPLAY_NAME {Use select lines}
set_parameter_property USE_SELECT UNITS None
set_parameter_property USE_SELECT DESCRIPTION {If enabled, the mux uses select signals to determine which input wins. Otherwise it uses the valid signals.}
set_parameter_property USE_SELECT ALLOWED_RANGES "0,1"
set_parameter_property USE_SELECT AFFECTS_ELABORATION true
set_parameter_property USE_SELECT HDL_PARAMETER false

add_parameter USE_READY INTEGER 0 0
set_parameter_property USE_READY DISPLAY_NAME {Use ready}
set_parameter_property USE_READY UNITS None
set_parameter_property USE_READY DESCRIPTION {If enabled, the mux passes the ready signal from its source to all its sinks.}
set_parameter_property USE_READY ALLOWED_RANGES "0,1"
set_parameter_property USE_READY AFFECTS_ELABORATION true
set_parameter_property USE_READY HDL_PARAMETER false

add_parameter ENABLE_EOP_EVENTS INTEGER 0 0
set_parameter_property ENABLE_EOP_EVENTS DISPLAY_NAME {Enable endofpacket events}
set_parameter_property ENABLE_EOP_EVENTS UNITS None
set_parameter_property ENABLE_EOP_EVENTS DESCRIPTION {If true, the mux issues a pulse on a separate source interface at the end of every packet.}
set_parameter_property ENABLE_EOP_EVENTS ALLOWED_RANGES "0,1"
set_parameter_property ENABLE_EOP_EVENTS AFFECTS_ELABORATION true
set_parameter_property ENABLE_EOP_EVENTS HDL_PARAMETER false

add_parameter MERLIN_PACKET_FORMAT String ""
set_parameter_property MERLIN_PACKET_FORMAT DISPLAY_NAME {Merlin packet format descriptor}
set_parameter_property MERLIN_PACKET_FORMAT UNITS None
set_parameter_property MERLIN_PACKET_FORMAT AFFECTS_ELABORATION true
set_parameter_property MERLIN_PACKET_FORMAT HDL_PARAMETER false
set_parameter_property MERLIN_PACKET_FORMAT DESCRIPTION {Merlin packet format descriptor}

# +-----------------------------------
# | clock and reset
# +-----------------------------------
add_interface clk clock end
add_interface_port clk clk clk Input 1

add_interface reset reset end
add_interface_port reset reset reset Input 1
set_interface_property reset associatedClock clk
#set_interface_property reset synchronousEdges BOTH
set_interface_property reset synchronousEdges DEASSERT

# +-----------------------------------
# | source
# +-----------------------------------
add_interface src avalon_streaming start
set_interface_property src dataBitsPerSymbol 8
set_interface_property src errorDescriptor ""
set_interface_property src maxChannel 0
set_interface_property src readyLatency 0
set_interface_property src symbolsPerBeat 1

set_interface_property src associatedClock clk
set_interface_property src associatedReset reset

add_interface_port src src_valid valid Output 1
add_interface_port src src_data data Output 8
add_interface_port src src_startofpacket startofpacket Output 1
add_interface_port src src_endofpacket endofpacket Output 1

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaborate {} {

    set st_data_width [ get_parameter_value ST_DATA_W ]
    set num_inputs    [ get_parameter_value NUM_INPUTS ]
    set packet_format [ get_parameter_value MERLIN_PACKET_FORMAT ]
    set use_ready     [ get_parameter_value USE_READY ]
    set use_select    [ get_parameter_value USE_SELECT ]
    set use_eop_event [ get_parameter_value ENABLE_EOP_EVENTS ]

    set_interface_property src dataBitsPerSymbol $st_data_width
    set_port_property src_data WIDTH_EXPR $st_data_width
    if { $use_ready } {
        add_interface_port src src_ready ready Input 1
    }

    if { $use_select } {
        add_interface sel avalon_streaming end
        set_interface_property sel dataBitsPerSymbol $num_inputs
        set_interface_property sel errorDescriptor ""
        set_interface_property sel maxChannel 0
        set_interface_property sel readyLatency 0
        set_interface_property sel symbolsPerBeat 1
        set_interface_property sel associatedClock clk
        set_interface_property sel associatedReset reset
        add_interface_port sel sel data Input $num_inputs
    }

    if { $use_eop_event } {
        add_interface eop_event avalon_streaming start
        set_interface_property eop_event dataBitsPerSymbol 1
        set_interface_property eop_event errorDescriptor ""
        set_interface_property eop_event maxChannel 0
        set_interface_property eop_event readyLatency 0
        set_interface_property eop_event symbolsPerBeat 1
        set_interface_property eop_event associatedClock clk
        set_interface_property eop_event associatedReset reset
        add_interface_port eop_event eop_event data Output 1
    }

    # +-----------------------------------
    # | sinks
    # +-----------------------------------
    for { set i 0 } { $i < $num_inputs } { incr i } {

        add_interface sink${i} avalon_streaming end
        set_interface_property sink${i} dataBitsPerSymbol $st_data_width
        set_interface_property sink${i} errorDescriptor ""
        set_interface_property sink${i} maxChannel 0
        set_interface_property sink${i} readyLatency 0
        set_interface_property sink${i} symbolsPerBeat 1
        
        set_interface_property sink${i} associatedClock clk
        set_interface_property sink${i} associatedReset reset
        
        add_interface_port sink${i} sink${i}_valid valid Input 1
        add_interface_port sink${i} sink${i}_data data Input $st_data_width
        add_interface_port sink${i} sink${i}_startofpacket startofpacket Input 1
        add_interface_port sink${i} sink${i}_endofpacket endofpacket Input 1
        if { $use_ready } {
            add_interface_port sink${i} sink${i}_ready ready Output 1
        }

        set_interface_assignment sink${i} merlin.packet_format $packet_format
        set_interface_assignment sink${i} merlin.flow.src src
    }
    set_interface_assignment src merlin.packet_format $packet_format

}

proc synth_callback_procedure { output_name } {

    set this_dir      [ get_module_property MODULE_DIRECTORY ]
    set template_file [ file join $this_dir "altera_nd_hiconnect_mux.sv.terp" ]

    set template_fh [ open $template_file r ]
    set template    [ read $template_fh ]
    close $template_fh

    set params(output_name) $output_name
    set params(num_inputs) [ get_parameter_value NUM_INPUTS ]
    set params(st_data_w)  [ get_parameter_value ST_DATA_W ]
    set params(use_select) [ get_parameter_value USE_SELECT ]
    set params(use_ready)  [ get_parameter_value USE_READY ]
    set params(enable_eop_events) [ get_parameter_value ENABLE_EOP_EVENTS ]

    set result          [ altera_terp $template params ]
    set output_file     [ create_temp_file ${output_name}.sv ]
    set output_handle   [ open $output_file w ]

    puts $output_handle $result
    close $output_handle

    add_fileset_file ${output_name}.sv SYSTEM_VERILOG PATH ${output_file}
}

