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


package require -exact qsys 15.0
package require -exact altera_terp 1.0

set_module_property DESCRIPTION ""
set_module_property NAME alt_hiconnect_scheduler
set_module_property VERSION 1.2
set_module_property GROUP "Qsys Interconnect/Memory-Mapped Alpha"
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Scheduler"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate

add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "gen" ""
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false

add_fileset SIM_VERILOG SIM_VERILOG "gen" ""
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false

add_parameter NUM_INPUTS INTEGER 2
set_parameter_property NUM_INPUTS DEFAULT_VALUE 2
set_parameter_property NUM_INPUTS DISPLAY_NAME NUM_INPUTS
set_parameter_property NUM_INPUTS TYPE INTEGER
set_parameter_property NUM_INPUTS UNITS None

add_parameter NUM_OUTPUTS INTEGER 2
set_parameter_property NUM_OUTPUTS DEFAULT_VALUE 2
set_parameter_property NUM_OUTPUTS DISPLAY_NAME NUM_OUTPUTS
set_parameter_property NUM_OUTPUTS TYPE INTEGER
set_parameter_property NUM_OUTPUTS UNITS None

add_parameter MULTIBEAT_PACKETS INTEGER 1
set_parameter_property MULTIBEAT_PACKETS DEFAULT_VALUE 1
set_parameter_property MULTIBEAT_PACKETS DISPLAY_NAME MULTIBEAT_PACKETS
set_parameter_property MULTIBEAT_PACKETS TYPE INTEGER
set_parameter_property MULTIBEAT_PACKETS ALLOWED_RANGES "0:1"
set_parameter_property MULTIBEAT_PACKETS UNITS None

add_parameter CONNECTIVITY STRING ""
set_parameter_property CONNECTIVITY DEFAULT_VALUE ""
set_parameter_property CONNECTIVITY DISPLAY_NAME CONNECTIVITY
set_parameter_property CONNECTIVITY TYPE STRING
set_parameter_property CONNECTIVITY UNITS None

add_parameter MAX_PENDING_PACKETS STRING ""
set_parameter_property MAX_PENDING_PACKETS DEFAULT_VALUE ""
set_parameter_property MAX_PENDING_PACKETS DISPLAY_NAME MAX_PENDING_PACKETS
set_parameter_property MAX_PENDING_PACKETS TYPE STRING
set_parameter_property MAX_PENDING_PACKETS UNITS None

add_parameter BUFFER_DEPTHS STRING ""
set_parameter_property BUFFER_DEPTHS DEFAULT_VALUE ""
set_parameter_property BUFFER_DEPTHS DISPLAY_NAME BUFFER_DEPTHS
set_parameter_property BUFFER_DEPTHS TYPE STRING
set_parameter_property BUFFER_DEPTHS UNITS None

add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1

add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges BOTH
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1

proc get_fanin_by_output { } {

    set connectivity_string [ get_parameter_value CONNECTIVITY ]
    set fanin_by_output [ dict create ]

    if { [ string equal $connectivity_string "" ] } {
        for { set i 0 } { $i < [ get_parameter_value NUM_OUTPUTS ] } { incr i } {
            dict set fanin_by_output $i [ get_parameter_value NUM_INPUTS ]
        }
    } else {
        foreach connection_string [ split $connectivity_string , ] {
            set connection_parts [ split $connection_string : ]
            set out [ lindex $connection_parts 1 ]
            dict incr fanin_by_output $out
        }
    }

    return [ dict get $fanin_by_output ]
}

proc get_fanout_by_input { } {

    set connectivity_string [ get_parameter_value CONNECTIVITY ]
    set fanout_by_input [ dict create ]

    if { [ string equal $connectivity_string "" ] } {
        for { set i 0 } { $i < [ get_parameter_value NUM_INPUTS ] } { incr i } {
            dict set fanout_by_input $i [ get_parameter_value NUM_OUTPUTS ] 
        }
    } else {
        foreach connection_string [ split $connectivity_string , ] {
            set connection_parts [ split $connection_string : ]
            set in [ lindex $connection_parts 0 ]
            dict incr fanout_by_input $in
        }
    }

    return [ dict get $fanout_by_input ]
}

proc elaborate { } {

    set num_inputs  [ get_parameter_value NUM_INPUTS ]
    set num_outputs [ get_parameter_value NUM_OUTPUTS ]
    set connectivity_string [ get_parameter_value CONNECTIVITY ]

    set fanin_by_output [ get_fanin_by_output ]
    set fanout_by_input [ get_fanout_by_input ]

    for { set i 0 } { $i < $num_inputs } { incr i } {
        # 
        # connection point in
        # 
        add_interface req${i} avalon_streaming end
        set_interface_property req${i} associatedClock clk
        set_interface_property req${i} associatedReset reset
        set_interface_property req${i} dataBitsPerSymbol 2
        set_interface_property req${i} errorDescriptor ""
        set_interface_property req${i} firstSymbolInHighOrderBits true
        set_interface_property req${i} maxChannel 0
        set_interface_property req${i} readyLatency 0
        set_interface_property req${i} ENABLED true
        set_interface_property req${i} EXPORT_OF ""
        set_interface_property req${i} PORT_NAME_MAP ""
        set_interface_property req${i} CMSIS_SVD_VARIABLES ""
        set_interface_property req${i} SVD_ADDRESS_GROUP ""

        add_interface_port req${i} req${i}_valid valid Input 1
        add_interface_port req${i} req${i}_select channel Input $num_outputs
        add_interface_port req${i} req${i}_startofpacket startofpacket Input 1
        add_interface_port req${i} req${i}_endofpacket endofpacket Input 1
        add_interface_port req${i} req${i}_data data Input 2

        # 
        # connection point pop
        # 
        add_interface pop${i} avalon_streaming start
        set_interface_property pop${i} associatedClock clk
        set_interface_property pop${i} associatedReset reset
        set_interface_property pop${i} dataBitsPerSymbol 1
        set_interface_property pop${i} errorDescriptor ""
        set_interface_property pop${i} firstSymbolInHighOrderBits true
        set_interface_property pop${i} maxChannel 0
        set_interface_property pop${i} readyLatency 0
        set_interface_property pop${i} ENABLED true
        set_interface_property pop${i} EXPORT_OF ""
        set_interface_property pop${i} PORT_NAME_MAP ""
        set_interface_property pop${i} CMSIS_SVD_VARIABLES ""
        set_interface_property pop${i} SVD_ADDRESS_GROUP ""

        add_interface_port pop${i} pop${i} data Output 1

        # 
        # connection point select
        # 
        add_interface demux_select${i} avalon_streaming start
        set_interface_property demux_select${i} associatedClock clk
        set_interface_property demux_select${i} associatedReset reset
        set_interface_property demux_select${i} dataBitsPerSymbol [ dict get $fanout_by_input $i ]
        set_interface_property demux_select${i} errorDescriptor ""
        set_interface_property demux_select${i} firstSymbolInHighOrderBits true
        set_interface_property demux_select${i} maxChannel 0
        set_interface_property demux_select${i} readyLatency 0
        set_interface_property demux_select${i} ENABLED true
        set_interface_property demux_select${i} EXPORT_OF ""
        set_interface_property demux_select${i} PORT_NAME_MAP ""
        set_interface_property demux_select${i} CMSIS_SVD_VARIABLES ""
        set_interface_property demux_select${i} SVD_ADDRESS_GROUP ""

        add_interface_port demux_select${i} demux${i}_select data Output [ dict get $fanout_by_input $i ]

        # 
        # connection point rsp
        # 
        add_interface rsp${i} avalon_streaming end
        set_interface_property rsp${i} associatedClock clk
        set_interface_property rsp${i} associatedReset reset
        set_interface_property rsp${i} dataBitsPerSymbol 1
        set_interface_property rsp${i} errorDescriptor ""
        set_interface_property rsp${i} firstSymbolInHighOrderBits true
        set_interface_property rsp${i} maxChannel 0
        set_interface_property rsp${i} readyLatency 0
        set_interface_property rsp${i} ENABLED true
        set_interface_property rsp${i} EXPORT_OF ""
        set_interface_property rsp${i} PORT_NAME_MAP ""
        set_interface_property rsp${i} CMSIS_SVD_VARIABLES ""
        set_interface_property rsp${i} SVD_ADDRESS_GROUP ""

        add_interface_port rsp${i} rsp${i}_returned data Input 1
    }

    for { set i 0 } { $i < $num_outputs } { incr i } {
        # 
        # connection point grant
        # 
        add_interface mux_select${i} avalon_streaming start
        set_interface_property mux_select${i} associatedClock clk
        set_interface_property mux_select${i} associatedReset reset
        set_interface_property mux_select${i} dataBitsPerSymbol [ dict get $fanin_by_output $i ]
        set_interface_property mux_select${i} errorDescriptor ""
        set_interface_property mux_select${i} firstSymbolInHighOrderBits true
        set_interface_property mux_select${i} maxChannel 0
        set_interface_property mux_select${i} readyLatency 0
        set_interface_property mux_select${i} ENABLED true
        set_interface_property mux_select${i} EXPORT_OF ""
        set_interface_property mux_select${i} PORT_NAME_MAP ""
        set_interface_property mux_select${i} CMSIS_SVD_VARIABLES ""
        set_interface_property mux_select${i} SVD_ADDRESS_GROUP ""

        add_interface_port mux_select${i} mux${i}_select data Output [ dict get $fanin_by_output $i ]

        # 
        # connection point stop
        # 
        add_interface stop${i} avalon_streaming end
        set_interface_property stop${i} associatedClock clk
        set_interface_property stop${i} associatedReset reset
        set_interface_property stop${i} dataBitsPerSymbol 1
        set_interface_property stop${i} errorDescriptor ""
        set_interface_property stop${i} firstSymbolInHighOrderBits true
        set_interface_property stop${i} maxChannel 0
        set_interface_property stop${i} readyLatency 0
        set_interface_property stop${i} ENABLED true
        set_interface_property stop${i} EXPORT_OF ""
        set_interface_property stop${i} PORT_NAME_MAP ""
        set_interface_property stop${i} CMSIS_SVD_VARIABLES ""
        set_interface_property stop${i} SVD_ADDRESS_GROUP ""

        add_interface_port stop${i} stop${i}_n data Input 1
    }
}

proc get_connection_set { } {

    set connectivity_string [ get_parameter_value CONNECTIVITY ]
    set connection_set [ dict create ]
    foreach connection_string [ split $connectivity_string , ] {
        dict set connection_set $connection_string 1
    }

    return [ dict get $connection_set ]
}

proc get_counter_width_by_input { } {

    set pending_packet_string [ get_parameter_value MAX_PENDING_PACKETS ]
    set counter_width_by_input [ dict create ]
    set max_pending_packets_list [ split $pending_packet_string , ]

    if { [ string equal $pending_packet_string "" ] } {
        for { set i 0 } { $i < [ get_parameter_value NUM_INPUTS ] } { incr i } {
            dict set counter_width_by_input $i 6
        }
    } else {
        for { set i 0 } { $i < [ llength $max_pending_packets_list ] } { incr i } {
            set max_pending_packets [ lindex $max_pending_packets_list $i ]
            set counter_width [ expr int(ceil(log($max_pending_packets + 1) / log(2))) ]
            dict set counter_width_by_input $i $counter_width
        }
    }

    return [ dict get $counter_width_by_input ]
}

proc get_buffer_depths { } {

    set buffer_depth_string [ get_parameter_value BUFFER_DEPTHS ]
    if { [ string equal $buffer_depth_string "" ] } {
        set num_buffers [ get_parameter_value NUM_INPUTS ]
        return [ lrepeat $num_buffers 18 ]
    }

    return [ split $buffer_depth_string , ]
}

proc gen { entity_name } {

    set this_dir      [ get_module_property MODULE_DIRECTORY ]
    set template_file [ file join $this_dir "alt_hiconnect_scheduler.sv.terp" ]

    set template_fh [ open $template_file r ]
    set template    [ read $template_fh ]
    close $template_fh

    set params(num_inputs)    [ get_parameter_value NUM_INPUTS  ]
    set params(num_outputs)   [ get_parameter_value NUM_OUTPUTS ]
    set params(multibeat_packets) [ get_parameter_value MULTIBEAT_PACKETS ]
    set params(connectivity) [ get_parameter_value CONNECTIVITY ]
    set params(max_pending_packets) [ get_parameter_value MAX_PENDING_PACKETS ]

    set params(connection_set) [ get_connection_set ]
    set params(fanout_by_input) [ get_fanout_by_input ] 
    set params(fanin_by_output) [ get_fanin_by_output ]
    set params(counter_width_by_input) [ get_counter_width_by_input ]

    set params(buffer_depth_string) [ get_parameter_value BUFFER_DEPTHS ]
    set params(buffer_depths) [ get_buffer_depths ]

    set params(output_name) $entity_name

    set result          [ altera_terp $template params ]
    set output_file     [ create_temp_file ${entity_name}.sv ]
    set output_handle   [ open $output_file w ]

    puts $output_handle $result
    close $output_handle

    add_fileset_file ${entity_name}.sv SYSTEM_VERILOG PATH ${output_file}
    add_fileset_file alt_st_reg_scfifo.sv SYSTEM_VERILOG PATH ../alt_hiconnect_sc_fifo/alt_st_reg_scfifo.sv
    add_fileset_file alt_hiconnect_cmd_rsp_counter.sv SYSTEM_VERILOG PATH alt_hiconnect_cmd_rsp_counter.sv
    add_fileset_file alt_hiconnect_rr_arb.sv SYSTEM_VERILOG PATH alt_hiconnect_rr_arb.sv
    add_fileset_file alt_hiconnect_arb_top.sv SYSTEM_VERILOG PATH alt_hiconnect_arb_top.sv
    add_fileset_file alt_hiconnect_pipeline_base.v VERILOG PATH ../alt_hiconnect_skid_buffer/alt_hiconnect_pipeline_base.v

}

