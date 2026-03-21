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


#+---------------------------------
#|
#| Avalon-ST SCFIFO component description
#|
#+---------------------------------
package require -exact qsys 15.0

set_module_property NAME alt_hiconnect_sc_fifo
set_module_property DISPLAY_NAME "Avalon-ST Single Clock FIFO"
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Qsys Interconnect/Memory-Mapped Alpha"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property VERSION 18.1
set_module_property EDITABLE false
set_module_property DATASHEET_URL "http://www.altera.com/literature/hb/nios2/qts_qii55014.pdf"
set_module_property HIDE_FROM_QUARTUS true
set_module_property INTERNAL true
set_module_assignment debug.isTransparent 1

# +-----------------------------------
# | callbacks
# |
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK  validate

# +-----------------------------------
# | files
# |
add_fileset synth QUARTUS_SYNTH syn
add_fileset sim_verilog SIM_VERILOG syn
add_fileset sim_vhdl SIM_VHDL syn

set_fileset_property synth TOP_LEVEL alt_hiconnect_sc_fifo
set_fileset_property sim_verilog TOP_LEVEL alt_hiconnect_sc_fifo
set_fileset_property sim_vhdl TOP_LEVEL alt_hiconnect_sc_fifo

# +-----------------------------------
# | parameters
# |
add_parameter IMPL                String  "infer"  ""
add_parameter SYMBOLS_PER_BEAT    INTEGER 1  ""
add_parameter BITS_PER_SYMBOL     INTEGER 8  ""
add_parameter FIFO_DEPTH          INTEGER 16 ""
add_parameter CHANNEL_WIDTH       INTEGER 0  ""
add_parameter ERROR_WIDTH         INTEGER 0  ""
add_parameter USE_PACKETS         INTEGER 0  ""
add_parameter EMPTY_LATENCY       INTEGER 3  ""
add_parameter ENABLE_EXPLICIT_MAXCHANNEL BOOLEAN false
add_parameter EXPLICIT_MAXCHANNEL INTEGER 0  ""
add_parameter ALMOST_FULL_THRESHOLD INTEGER 12  ""
add_parameter SHOWAHEAD           INTEGER 1  ""
add_parameter ENABLE_POP          BOOLEAN 0  ""
add_parameter ENABLE_STOP         BOOLEAN 0  ""

# +-----------------------------------
# | display names and hints
# |
set_parameter_property IMPL              DISPLAY_NAME "Implementation"
set_parameter_property IMPL              DESCRIPTION  "Controls the FIFO storage implementation"
set_parameter_property SYMBOLS_PER_BEAT  DISPLAY_NAME "Symbols per beat"
set_parameter_property SYMBOLS_PER_BEAT  DESCRIPTION  "Number of symbols per transfer"
set_parameter_property BITS_PER_SYMBOL   DISPLAY_NAME "Bits per symbol"
set_parameter_property BITS_PER_SYMBOL   DESCRIPTION  "Number of bits in each symbol"
set_parameter_property FIFO_DEPTH        DISPLAY_NAME "FIFO depth"
set_parameter_property FIFO_DEPTH        DESCRIPTION  "The depth of the FIFO"
set_parameter_property CHANNEL_WIDTH     DISPLAY_NAME "Channel width"
set_parameter_property CHANNEL_WIDTH     DESCRIPTION  "The width of the channel signal. 0 means that the signal is omitted"
set_parameter_property ERROR_WIDTH       DISPLAY_NAME "Error width"
set_parameter_property ERROR_WIDTH       DESCRIPTION  "The width of the error signal. 0 means that the signal is omitted"
set_parameter_property USE_PACKETS       DISPLAY_NAME "Use packets"
set_parameter_property USE_PACKETS       DESCRIPTION  "If enabled, the packet signals will be used"
set_parameter_property EMPTY_LATENCY     DISPLAY_NAME "Latency"
set_parameter_property EMPTY_LATENCY     DESCRIPTION  "The latency of the FIFO, defined as the number of cycles for a write to propagate to the output"
set_parameter_property ENABLE_EXPLICIT_MAXCHANNEL DISPLAY_NAME "Enable explicit maxChannel"
set_parameter_property ENABLE_EXPLICIT_MAXCHANNEL DESCRIPTION  "Allows a maxChannel value to be defined. Otherwise, the value is derived from the channel width"
set_parameter_property EXPLICIT_MAXCHANNEL        DISPLAY_NAME "Explicit maxChannel"
set_parameter_property EXPLICIT_MAXCHANNEL        DESCRIPTION  "The explicit value of maxChannel"
set_parameter_property ALMOST_FULL_THRESHOLD DISPLAY_NAME "Almost full threshold"
set_parameter_property ALMOST_FULL_THRESHOLD DESCRIPTION  "The threshold value after which the sink deasserts ready"
set_parameter_property SHOWAHEAD DISPLAY_NAME "Showahead mode"
set_parameter_property SHOWAHEAD DESCRIPTION  "If enabled, the FIFO output is in showahead mode (ready latency 0). Otherwise, it has ready latency 1."

set_parameter_property IMPL ALLOWED_RANGES "infer,mlab,reg"

set_parameter_property USE_PACKETS DISPLAY_HINT "boolean"
set_parameter_property SHOWAHEAD   DISPLAY_HINT "boolean"

set_parameter_property EMPTY_LATENCY VISIBLE "false"

set_parameter_property IMPL             IS_HDL_PARAMETER true
set_parameter_property SYMBOLS_PER_BEAT IS_HDL_PARAMETER true
set_parameter_property BITS_PER_SYMBOL  IS_HDL_PARAMETER true
set_parameter_property FIFO_DEPTH       IS_HDL_PARAMETER true
set_parameter_property CHANNEL_WIDTH    IS_HDL_PARAMETER true
set_parameter_property ERROR_WIDTH      IS_HDL_PARAMETER true
set_parameter_property USE_PACKETS      IS_HDL_PARAMETER true
set_parameter_property EMPTY_LATENCY    IS_HDL_PARAMETER true
set_parameter_property SHOWAHEAD        IS_HDL_PARAMETER true
set_parameter_property ALMOST_FULL_THRESHOLD IS_HDL_PARAMETER true

proc log2ceil {num} {

    set val 0
    set i 1
    while {$i < $num} {
        set val [expr $val + 1]
        set i [expr 1 << $val]
    }

    return $val;
}

proc validate {} {

    set required_depth [ get_parameter_value "FIFO_DEPTH" ]
    set addr_width     [ log2ceil $required_depth ]
    set real_depth     [ expr (1 << $addr_width) ]
    set impl           [ get_parameter_value "IMPL" ]
    set showahead      [ get_parameter_value "SHOWAHEAD" ]

    if { [ string equal $impl "infer" ] } {
        if { $required_depth != $real_depth } {
            send_message "error" "FIFO depth must be a power of two ($real_depth would be acceptable)"
        }
    }

    if { $showahead == 0 } {
        if { ![ string equal $impl "mlab" ] } {
            send_message "error" "Only the MLAB implementation supports non-showahead mode"
        }
    }

}

proc elaborate {} {

    set symbols_per_beat [ get_parameter_value "SYMBOLS_PER_BEAT" ]
    set bits_per_symbol  [ get_parameter_value "BITS_PER_SYMBOL" ]
    set data_width       [ expr $symbols_per_beat * $bits_per_symbol ]
    set channel_width    [ get_parameter_value "CHANNEL_WIDTH" ]
    set max_channel      [ expr (1 << $channel_width) - 1 ]
    set empty_width      [ log2ceil $symbols_per_beat ] 
    set error_width      [ get_parameter_value "ERROR_WIDTH" ]
    set use_packets      [ get_parameter_value "USE_PACKETS" ]
    set override_maxchannel [ get_parameter_value "ENABLE_EXPLICIT_MAXCHANNEL" ]
    set override_value      [ get_parameter_value "EXPLICIT_MAXCHANNEL" ]
    set enable_pop [ get_parameter_value "ENABLE_POP" ]
    set enable_stop [ get_parameter_value "ENABLE_STOP" ]

    if { $override_maxchannel } {
        set max_channel $override_value
    }

    # clk
    add_interface clk clock end
    add_interface_port clk clk clk Input 1
    add_interface_port clk reset reset Input 1

    set_interface_property clk_reset synchronousEdges BOTH

    # sink interface
    add_interface "in" "avalon_streaming" "sink" "clk"
    set_interface_property "in" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "in" "dataBitsPerSymbol" $bits_per_symbol

    set_interface_property "in" "readyLatency" 0
    set_interface_property "in" "maxChannel" $max_channel

    # source interface
    add_interface "out" "avalon_streaming" "source" "clk"
    set_interface_property "out" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "out" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "out" "readyLatency" "0"
    set_interface_property "out" "maxChannel" "$max_channel"

    set_interface_assignment out debug.controlledBy in

    add_interface_port "in" "in_data" "data" "input" $data_width
    add_interface_port "in" "in_valid" "valid" "input" 1
    if { $enable_stop } {
      # output port in_ready is bound to a minimal (data-only) 
      # st source, "stop".
      add_interface "stop" "avalon_streaming" "source" "clk"
      set_interface_property "stop" associatedClock clk
      set_interface_property "stop" associatedReset clk
      set_interface_property "stop" dataBitsPerSymbol 1
      add_interface_port "stop" "in_ready" "data" "output" 1
    } else {
      # output port in_ready is bound to the "in" sink.
    add_interface_port "in" "in_ready" "ready" "output" 1
    }

    add_interface_port "out" "out_data" "data" "output" $data_width
    add_interface_port "out" "out_valid" "valid" "output" 1
    if { $enable_pop } {
      # input port out_ready is bound to a minimal (data-only)
      # st sink, "pop"
      add_interface "pop" "avalon_streaming" "sink"
      set_interface_property "pop" associatedClock clk
      set_interface_property "pop" associatedReset clk
      set_interface_property "pop" dataBitsPerSymbol 1
      add_interface_port "pop" "out_ready" "data" "input" 1
    } else {
    add_interface_port "out" "out_ready" "ready" "input" 1
    }

    add_interface_port "in" "in_startofpacket" "startofpacket" "input" 1
    add_interface_port "in" "in_endofpacket" "endofpacket" "input" 1

    add_interface_port "out" "out_startofpacket" "startofpacket" "output" 1
    add_interface_port "out" "out_endofpacket" "endofpacket" "output" 1
    add_interface_port "in" "in_empty" "empty" "input" 1
    add_interface_port "out" "out_empty" "empty" "output" 1
    add_interface_port "in" "in_error" "error" "input" 1
    add_interface_port "out" "out_error" "error" "output" 1

    if { $use_packets } {
        if { $symbols_per_beat > 1 } {
            set_port_property in_empty TERMINATION false
            set_port_property in_empty WIDTH $empty_width
            set_port_property out_empty TERMINATION false
            set_port_property out_empty WIDTH $empty_width
        } else {
            set_port_property in_empty TERMINATION true
            set_port_property out_empty TERMINATION true
        }       
    } else {
        set_port_property in_empty TERMINATION true
        set_port_property out_empty TERMINATION true
    }


    if { $error_width > 0 } {
        set_port_property in_error TERMINATION false
        set_port_property in_error WIDTH $error_width
        set_port_property out_error TERMINATION false
        set_port_property out_error WIDTH $error_width
    } else {
        set_port_property "in_error" TERMINATION true
        set_port_property "out_error" TERMINATION true
    }

    if { $use_packets == "0" } {
        set_port_property "in_startofpacket" TERMINATION 1
        set_port_property "in_startofpacket" TERMINATION_VALUE 0
        set_port_property "in_endofpacket" TERMINATION 1
        set_port_property "in_endofpacket" TERMINATION_VALUE 0
        set_port_property "out_startofpacket" TERMINATION 1
        set_port_property "out_endofpacket" TERMINATION 1
    }

    if { $channel_width > 0 } {
        add_interface_port "in" "in_channel" "channel" "input" $channel_width
        add_interface_port "out" "out_channel" "channel" "output" $channel_width
    } else {
        add_interface_port "in" "in_channel" "channel" "input" 1
        add_interface_port "out" "out_channel" "channel" "output" 1
        set_port_property  "in_channel" TERMINATION 1
        set_port_property  "in_channel" TERMINATION_VALUE 0
        set_port_property  "out_channel" TERMINATION 1
    }
}

proc syn { name } {
    add_fileset_file "alt_hiconnect_sc_fifo.sv" SYSTEM_VERILOG PATH "alt_hiconnect_sc_fifo.sv"
    add_fileset_file "alt_st_infer_scfifo.sv" SYSTEM_VERILOG PATH "alt_st_infer_scfifo.sv"
    add_fileset_file "alt_st_mlab_scfifo.sv" SYSTEM_VERILOG PATH "alt_st_mlab_scfifo.sv"
    add_fileset_file "alt_st_reg_scfifo.sv" SYSTEM_VERILOG PATH "alt_st_reg_scfifo.sv"
}

