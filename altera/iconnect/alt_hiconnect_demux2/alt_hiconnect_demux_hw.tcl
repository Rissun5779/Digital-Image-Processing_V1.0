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


package require -exact altera_terp 1.0
package require -exact qsys 15.0

set_module_property NAME alt_hiconnect_demux2
set_module_property VERSION 18.1
set_module_property GROUP "Qsys Interconnect/Memory-Mapped Alpha"
set_module_property DISPLAY_NAME "Demultiplexer"
set_module_property DESCRIPTION "Demux with one-hot select signals"
set_module_property AUTHOR "Altera Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf
set_module_property HIDE_FROM_QUARTUS true

# +-----------------------------------
# | Parameters
# +-----------------------------------
add_parameter ST_DATA_W INTEGER 8 0
set_parameter_property ST_DATA_W DISPLAY_NAME {Packet data width}
set_parameter_property ST_DATA_W UNITS None
set_parameter_property ST_DATA_W ALLOWED_RANGES 0:2147483647
set_parameter_property ST_DATA_W DESCRIPTION {Packet data width}
set_parameter_property ST_DATA_W AFFECTS_ELABORATION true
set_parameter_property ST_DATA_W HDL_PARAMETER false

add_parameter NUM_OUTPUTS INTEGER 2 0
set_parameter_property NUM_OUTPUTS DISPLAY_NAME {Number of demux outputs}
set_parameter_property NUM_OUTPUTS UNITS None
set_parameter_property NUM_OUTPUTS DESCRIPTION {Number of demux outputs}
set_parameter_property NUM_OUTPUTS AFFECTS_ELABORATION true
set_parameter_property NUM_OUTPUTS HDL_PARAMETER false

add_parameter USE_READY INTEGER 0 0
set_parameter_property USE_READY DISPLAY_NAME {Enable backpressure}
set_parameter_property USE_READY UNITS None
set_parameter_property USE_READY DESCRIPTION {Adds the ready signal, and gates the valid signal until the selected source is ready}
set_parameter_property USE_READY ALLOWED_RANGES "0,1"
set_parameter_property USE_READY AFFECTS_ELABORATION true
set_parameter_property USE_READY HDL_PARAMETER false

add_parameter SELECT_AS_CHANNEL INTEGER 0 0
set_parameter_property SELECT_AS_CHANNEL DISPLAY_NAME {Treat select as input channel}
set_parameter_property SELECT_AS_CHANNEL UNITS None
set_parameter_property SELECT_AS_CHANNEL DESCRIPTION {Merges the select signal into the streaming sink}
set_parameter_property SELECT_AS_CHANNEL ALLOWED_RANGES "0,1"
set_parameter_property SELECT_AS_CHANNEL AFFECTS_ELABORATION true
set_parameter_property SELECT_AS_CHANNEL HDL_PARAMETER false

add_parameter MERLIN_PACKET_FORMAT STRING ""
set_parameter_property MERLIN_PACKET_FORMAT DISPLAY_NAME {Merlin packet format descriptor}
set_parameter_property MERLIN_PACKET_FORMAT UNITS None
set_parameter_property MERLIN_PACKET_FORMAT AFFECTS_ELABORATION true
set_parameter_property MERLIN_PACKET_FORMAT HDL_PARAMETER false
set_parameter_property MERLIN_PACKET_FORMAT DESCRIPTION {Merlin packet format descriptor}

# +-----------------------------------
# | Static interfaces
# +-----------------------------------
add_interface clk clock end
add_interface_port clk clk clk Input 1

add_interface reset reset end
add_interface_port reset reset reset Input 1
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges BOTH

# +-----------------------------------
# | Filesets
# +-----------------------------------
add_fileset synth_fileset QUARTUS_SYNTH synth_callback_procedure
add_fileset synthver_fileset SIM_VERILOG synth_callback_procedure
add_fileset synthvhd_fileset SIM_VHDL synth_callback_procedure

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaborate {} {

    set st_data_width [ get_parameter_value ST_DATA_W ]
    set num_outputs   [ get_parameter_value NUM_OUTPUTS ]
    set packet_format [ get_parameter_value MERLIN_PACKET_FORMAT ]
    set sel_as_chan   [ get_parameter_value SELECT_AS_CHANNEL ]
    set use_ready     [ get_parameter_value USE_READY ]

    if { $sel_as_chan == 0 } {
        add_interface sel avalon_streaming end
        set_interface_property sel dataBitsPerSymbol $num_outputs
        set_interface_property sel errorDescriptor ""
        set_interface_property sel maxChannel 0
        set_interface_property sel readyLatency 0
        set_interface_property sel symbolsPerBeat 1
        set_interface_property sel associatedClock clk
        set_interface_property sel associatedReset reset
        add_interface_port sel sel data Input $num_outputs
    }

    # +-----------------------------------
    # | sink
    # +-----------------------------------
    add_interface sink avalon_streaming end
    set_interface_property sink dataBitsPerSymbol $st_data_width
    set_interface_property sink errorDescriptor ""
    set_interface_property sink maxChannel 0
    set_interface_property sink readyLatency 0
    set_interface_property sink symbolsPerBeat 1
    set_interface_property sink associatedClock clk
    set_interface_property sink associatedReset reset
    set_interface_assignment sink merlin.packet_format $packet_format

    add_interface_port sink sink_valid valid Input 1
    add_interface_port sink sink_data data Input $st_data_width
    add_interface_port sink sink_startofpacket startofpacket Input 1
    add_interface_port sink sink_endofpacket endofpacket Input 1
    if { $sel_as_chan } {
        add_interface_port sink sel channel Input $num_outputs
    }
    if { $use_ready } {
        add_interface_port sink sink_ready ready Output 1
    }

    set_merlin_flow_assignments_for_sink

    # +-----------------------------------
    # | sources
    # +-----------------------------------
    for { set i 0 } { $i < $num_outputs } { incr i } {
        add_interface src${i} avalon_streaming start
        set_interface_property src${i} dataBitsPerSymbol $st_data_width
        set_interface_property src${i} errorDescriptor ""
        set_interface_property src${i} maxChannel 0
        set_interface_property src${i} readyLatency 0
        set_interface_property src${i} symbolsPerBeat 1
        set_interface_property src${i} associatedClock clk
        set_interface_property src${i} associatedReset reset
        
        add_interface_port src${i} src${i}_valid valid Output 1
        add_interface_port src${i} src${i}_data data Output $st_data_width
        add_interface_port src${i} src${i}_startofpacket startofpacket Output 1
        add_interface_port src${i} src${i}_endofpacket endofpacket Output 1
        if { $use_ready } {
            add_interface_port src${i} src${i}_ready ready Input 1
        }

        set_interface_assignment src${i} merlin.packet_format $packet_format
    }
}

proc get_channel_for_output { index } {

    set channel   [ string repeat "0" [ get_parameter_value NUM_OUTPUTS ] ]
    set bit_index [ expr [ get_parameter_value NUM_OUTPUTS ] - $index - 1 ]
    set channel   [ string replace $channel $bit_index $bit_index "1" ]

    return $channel
}

proc set_merlin_flow_assignments_for_sink { } {

    set num_outputs   [ get_parameter_value NUM_OUTPUTS ]
    for { set i 0 } { $i < $num_outputs } { incr i } { 

        set_interface_assignment sink merlin.flow.src${i} src${i}
        set_interface_assignment sink merlin.channel.src${i} [ get_channel_for_output $i ]

    }

}

proc synth_callback_procedure { output_name } {

    set this_dir      [ get_module_property MODULE_DIRECTORY ]
    set template_file [ file join $this_dir "alt_hiconnect_demux.sv.terp" ]

    set template_fh [ open $template_file r ]
    set template    [ read $template_fh ]
    close $template_fh

    set params(output_name) $output_name
    set params(NUM_OUTPUTS) [ get_parameter_value NUM_OUTPUTS ]
    set params(st_data_w) [ get_parameter_value ST_DATA_W ]
    set params(use_ready) [ get_parameter_value USE_READY ]

    set result          [ altera_terp $template params ]
    set output_file     [ create_temp_file ${output_name}.sv ]
    set output_handle   [ open $output_file w ]

    puts $output_handle $result
    close $output_handle

    add_fileset_file ${output_name}.sv SYSTEM_VERILOG PATH ${output_file}
}
