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


package require -exact qsys 13.1
package require altera_terp

set maxNumberSymbols 512
set inBeatsPerCycle 1
set outBeatsPerCycle 1

set_module_property NAME demultiplexer
set_module_property DISPLAY_NAME "Avalon-ST Demultiplexer"
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Basic Functions/Bridges and Adaptors/Streaming"


set_module_property VERSION 18.1
set_module_property EDITABLE false
#set_module_property DATASHEET_URL "http://www.altera.com/literature/hb/nios2/qts_qii55014.pdf"
set_module_property ANALYZE_HDL FALSE
set_module_property HIDE_FROM_QUARTUS true

# +-----------------------------------
# | callbacks
# |
set_module_property ELABORATION_CALLBACK elaborate
set_module_property PARAMETER_UPGRADE_CALLBACK upgrade
add_fileset quartus_synth QUARTUS_SYNTH generate "Demultiplexer Generation"
add_fileset quartus_simulation SIM_VERILOG generate "Demultiplexer Generation"
add_fileset vhdl_simulation    SIM_VHDL    generate "Demultiplexer Generation"

# +-----------------------------------
# | parameters
# |
add_parameter inChannelWidth       INTEGER 1 ""
set_parameter_property inChannelWidth allowed_ranges {0:31}

add_parameter bitsPerSymbol        INTEGER 8 ""
set_parameter_property bitsPerSymbol allowed_ranges {1:4096}

add_parameter usePackets            BOOLEAN false ""
add_parameter inUsePackets          BOOLEAN false ""
set_parameter_property inUsePackets DERIVED true
set_parameter_property inUsePackets VISIBLE false


add_parameter inUseEmptyPort          STRING "AUTO" 
set_parameter_property inUseEmptyPort DERIVED true
set_parameter_property inUseEmptyPort VISIBLE false
add_parameter inUseEmpty              BOOLEAN false ""
set_parameter_property inUseEmpty     DERIVED true
set_parameter_property inUseEmpty     VISIBLE false

add_parameter numOutputInterfaces  INTEGER 2 ""
set_parameter_property numOutputInterfaces allowed_ranges {1:16}

add_parameter useHighBitsOfChannel BOOLEAN true


add_parameter symbolsPerBeat       INTEGER 4 ""
set_parameter_property symbolsPerBeat allowed_ranges {1:512}


add_parameter errorWidth            INTEGER 0 ""
set_parameter_property errorWidth allowed_ranges {0:512}
add_parameter inErrorWidth          INTEGER 0 ""
set_parameter_property inErrorWidth DERIVED true
set_parameter_property inErrorWidth VISIBLE false



# +-----------------------------------
# | display items, names, and descriptions
# |
set_parameter_property numOutputInterfaces  DISPLAY_NAME "Number of Output Ports"
set_parameter_property useHighBitsOfChannel DISPLAY_NAME "Use High Channel Bits"

set_parameter_property bitsPerSymbol        DISPLAY_NAME "Data Bits Per Symbol"
set_parameter_property symbolsPerBeat       DISPLAY_NAME "Data Symbols Per Beat"
set_parameter_property usePackets           DISPLAY_NAME "Include Packet Support"
set_parameter_property inChannelWidth       DISPLAY_NAME "Channel Signal Width (bits)"
set_parameter_property errorWidth           DISPLAY_NAME "Error Signal Width (bits)"

set_parameter_property numOutputInterfaces  DESCRIPTION "Number of output interfaces"
set_parameter_property useHighBitsOfChannel DESCRIPTION "Use High Channel Bits"
set_parameter_property bitsPerSymbol        DESCRIPTION "Number of bits for each symbol in a transfer." 
set_parameter_property symbolsPerBeat       DESCRIPTION "Number of symbols per transfer."
set_parameter_property usePackets           DESCRIPTION "Indicates if packets will be used."
set_parameter_property inChannelWidth       DESCRIPTION "Width of the Channel Signal in bits."
set_parameter_property errorWidth           DESCRIPTION "Width of the Error signal output in bits."

set_parameter_property numOutputInterfaces  GROUP "Functional Parameters"
set_parameter_property useHighBitsOfChannel GROUP "Functional Parameters"
add_display_item "Functional Parameters" HCHmessage1 TEXT "<html>When selected, the high order bits of the input channel signal<br>are used by the demultiplexing function, and the low order<br>bits are passed to the output.<br>When not selected, the low order bits are used, and the high<br> order bits are passed through."
set_parameter_property bitsPerSymbol    GROUP "Input Interface"
set_parameter_property symbolsPerBeat   GROUP "Input Interface"
set_parameter_property usePackets       GROUP "Input Interface"
add_display_item "Input Interface" PKTmessage1 TEXT "<html>When packets are supported, the startofpacket, <br>endofpacket, and empty signals are used."
set_parameter_property inChannelWidth   GROUP "Input Interface"
set_parameter_property errorWidth       GROUP "Input Interface"



proc log2ceil {num} {

    if {$num == 1} {
        return 1
    }

    set val 0
    set i 1
    while {$i < $num} {
        set val [expr $val + 1]
        set i [expr 1 << $val]
    }

    return $val;
}


proc validate {} {
    global inBeatsPerCycle
    global outBeatsPerCycle
    set channel_width    [get_parameter_value "inChannelWidth" ]
    set symbols_per_beat [get_parameter_value "symbolsPerBeat" ]
    set number_output_interfaces [ get_parameter_value "numOutputInterfaces" ]
    set data "_data"
    set valid "_valid"
    set ready "_ready"
    set sop "_startofpacket"
    set eop "_endofpacket"
    set empty "_empty"
    set error "_error"
    set channel "_channel"

    source ../AtlanticComponentsShared/AtlanticCommonValidation.tcl
    set neededChannelBits [log2ceil $number_output_interfaces]
    if {$channel_width < $neededChannelBits} {
        send_message error "Input interface Channel Width($channel_width) is not wide enough to represent the number of output interfaces($number_output_interfaces)."
    }
    validate_requiredSignals "in" "Input"
    validate_dataAndEmptyWidths in_data in_empty $inBeatsPerCycle "in" "Input"
    validate_SoP_EoP_Valid_Widths in_startofpacket in_endofpacket in_valid $inBeatsPerCycle "Input"
    validate_ChannelWidth "in" in_channel $inBeatsPerCycle "Input"
    validate_ErrorWidth in_error $inBeatsPerCycle "Input" 

    for {set i 0} {$i < $number_output_interfaces} {incr i} {
        validate_requiredSignals "out$i" "Output"
        validate_dataAndEmptyWidths "out$i$data" "out$i$empty" $outBeatsPerCycle "out$i" "Output$i"
        validate_SoP_EoP_Valid_Widths "out$i$sop" "out$i$eop" "out$i$valid" $outBeatsPerCycle "Output$i"
        validate_ChannelWidth "out$i" "out$i$channel" $outBeatsPerCycle "Output$i"
        validate_ErrorWidth "out$i$error" $outBeatsPerCycle "Output$i"    
    }
}

proc createVerilogFile {output_name} {
    set this_dir                 [ get_module_property MODULE_DIRECTORY ]
    set template_file            [ file join $this_dir "avalon-st_demultiplexer.sv.terp" ]        
    set template                 [ read [ open $template_file r ] ]    

    set symbols_per_beat         [ get_parameter_value "symbolsPerBeat" ]
    set bits_per_symbol          [ get_parameter_value "bitsPerSymbol" ]
    set use_empty                [ get_Emptyparameter_value "inUseEmptyPort" ]
    set use_high_order_chbits    [ get_parameter_value "useHighBitsOfChannel" ]
    set channel_width            [ get_parameter_value "inChannelWidth" ]
    set num_outputs              [ get_parameter_value "numOutputInterfaces" ]
    set use_packets              [ get_parameter_value "usePackets" ]
    set output_channel_width [expr $channel_width - [log2ceil $num_outputs ] ]
    set selectBits "0:0"
    if {$num_outputs ==1} {
        set selectWidth 0
    } else {
        set selectWidth [log2ceil $num_outputs ]
    }
    
    set colon ":"
    set minus1 "-1"
    set zero "0"
    set selectBits "$selectWidth$minus1$colon$zero"

    if {$use_high_order_chbits} {        
        set selectBits "$channel_width$minus1$colon$output_channel_width"
    } 

    set params(output_name)       $output_name
    set params(use_packets)       $use_packets

    if {($use_packets) && ($symbols_per_beat>1)} {
        set params(use_empty)   1
        set params(emptyWidth)  [ log2ceil $symbols_per_beat ] 
    } else {
        set params(use_empty)   0             
        set params(emptyWidth)  0
    }

    set params(dataWidth)         [ expr $symbols_per_beat * $bits_per_symbol ]
    set params(channelWidth)      $channel_width 
    set params(errorWidth)        [ get_parameter_value "errorWidth" ]
    set params(numOutputs)        $num_outputs
    set params(outChWidth)        $output_channel_width
    set params(selectBits)        $selectBits
    set params(selectWidth)       $selectWidth

    set comma ","
    set colon ":"
    set inPayloadWidth 0
    set inPayloadMap ""
    set inPorts [ get_interface_ports "in"]
    foreach port $inPorts {
        set role [get_port_property $port ROLE]
        if { ($role =="valid") || ($role == "ready") } {
            continue
        }
        set tempWidth [get_port_property $port WIDTH_EXPR]
        set inPayloadWidth  [expr $inPayloadWidth + $tempWidth]
        if {$role == "channel"} {
            if {$channel_width == $selectWidth} { #don't pass channel through to output, all channel bits used for select
                continue
            }
            if {$use_high_order_chbits} {
                set lhs [expr [expr $channel_width - $selectWidth] -1]
                set rhs "0"
            } else {
                set lhs [expr $channel_width -1]
                set rhs $selectWidth
            }
            set lbrack "\["
            set rbrack "\]"

            set port "$port$lbrack$lhs$colon$rhs$rbrack"
        }
        if {$inPayloadMap == ""} {
            set inPayloadMap "$port"
        } else {
            set inPayloadMap "$inPayloadMap$comma$port"
        }
    }
    set params(inPayloadMap) $inPayloadMap

    set params(outPayloadMap) [list]
    for {set i 0} {$i < $num_outputs} {incr i} {
        set outPorts [ get_interface_ports "out$i"]
        set tempStr ""
        set thisWidth 0
        foreach port $outPorts {
            set role [get_port_property $port ROLE]
            if { ($role !="valid") && ($role != "ready") } {
                set tempWidth [get_port_property $port WIDTH_EXPR]
                set thisWidth  [expr $thisWidth + $tempWidth]        
                if {$tempStr == ""} {
                    set tempStr "$port"
                } else {
                    set tempStr "$tempStr$comma$port"
                }
            }
        }
        lappend params(outPayloadMap) $tempStr
        if {$i == 0} {
            set params(outPayloadWidth) $thisWidth
        }
    }

    set result          [ altera_terp $template params ]
    return $result
}

proc generate {output_name} {
    set result [createVerilogFile $output_name]
    set output_file     $output_name
    append output_file ".sv"

    add_fileset_file ${output_file} {SYSTEM_VERILOG} TEXT ${result}
}

proc upgrade { kind, verion, parameters } {
    source ../AtlanticComponentsShared/AtlanticCommonValidation.tcl
    array set parmList [makeUpgradeList $parameters]

    set_parameter_value inChannelWidth       $parmList(inChannelWidth)
    set_parameter_value bitsPerSymbol        $parmList(bitsPerSymbol)
    set_parameter_value usePackets           $parmList(usePackets)
    set_parameter_value numOutputInterfaces  $parmList(numOutputInterfaces)
    set_parameter_value useHighBitsOfChannel $parmList(useHighBitsOfChannel)
    set_parameter_value symbolsPerBeat       $parmList(symbolsPerBeat)
    set_parameter_value errorWidth           $parmList(errorWidth)
}


proc elaborate {} {
    set symbols_per_beat   [ get_parameter_value "symbolsPerBeat" ]
    set bits_per_symbol    [ get_parameter_value "bitsPerSymbol" ]
    set data_width         [ expr $symbols_per_beat * $bits_per_symbol ]
    set channel_width      [ get_parameter_value "inChannelWidth" ]
    set use_packets        [ get_parameter_value "usePackets" ]
    set_parameter_value inUsePackets $use_packets
    set error_width        [ get_parameter_value "errorWidth" ]
    set_parameter_value inErrorWidth $error_width
    set number_output_interfaces [ get_parameter_value "numOutputInterfaces" ]    
    set use_high_order_chbits    [ get_parameter_value "useHighBitsOfChannel" ]
    set output_channel_width   [expr $channel_width - [log2ceil $number_output_interfaces ] ]    

    set in_max_channel     [ expr [expr 2**$channel_width ] -1]
    set out_max_channel        [ expr [expr 2**$output_channel_width ] - 1]
    if {$channel_width == 0} {
        set max_channel 0
    }
    

    # +-----------------------------------
    # | connection point clk
    # |
    add_interface clk clock end
    add_interface_port clk clk clk Input 1

    # +-----------------------------------
    # | connection point reset
    # |

    add_interface "reset" reset end clk
    add_interface_port reset reset_n reset_n Input 1

    # Avalon-ST sink interface
    add_interface "in" "avalon_streaming" "sink" "clk"
    add_interface_port "in" "in_data" "data" "input" $data_width
    add_interface_port "in" "in_valid" "valid" "input" 1
    add_interface_port "in" "in_ready" "ready" "output" 1    

    set_interface_property "in" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "in" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "in" "maxChannel" $in_max_channel
    
    if {$use_packets } {
        add_interface_port "in" "in_startofpacket" "startofpacket" "input" 1
        add_interface_port "in" "in_endofpacket" "endofpacket" "input" 1
        if {$symbols_per_beat >1 } {
            add_interface_port "in" "in_empty" "empty" "input" 1
            set empty_width [ log2ceil $symbols_per_beat ] 
            set_port_property in_empty WIDTH_EXPR $empty_width
        }
    } 

    if {$error_width > 0} {
        add_interface_port "in" "in_error" "error" "input" 1 
        set_port_property in_error WIDTH_EXPR $error_width
    }

    if {$channel_width > 0} {
      add_interface_port "in" "in_channel" "channel" "input" $channel_width
    }

    # Avalon-ST source interfaces
    for {set i 0} {$i < $number_output_interfaces} {incr i} {
        set data "_data"
        set valid "_valid"
        set ready "_ready"
        set sop "_startofpacket"
        set eop "_endofpacket"
        set empty "_empty"
        set error "_error"
        set channel "_channel"

        add_interface "out$i" "avalon_streaming" "source" "clk"
        add_interface_port "out$i" "out$i$data" "data" "output" $data_width
        add_interface_port "out$i" "out$i$valid" "valid" "output" 1
    
        set_interface_property "out$i" "symbolsPerBeat" $symbols_per_beat
        set_interface_property "out$i" "dataBitsPerSymbol" $bits_per_symbol
        set_interface_property "out$i" "maxChannel" $out_max_channel
        add_interface_port "out$i" "out$i$ready" "ready" "input" 1        
        if {$use_packets } {
            add_interface_port "out$i" "out$i$sop" "startofpacket" "output" 1
            add_interface_port "out$i" "out$i$eop" "endofpacket" "output" 1
            if {$symbols_per_beat >1} { 
                add_interface_port "out$i" "out$i$empty" "empty" "output" 1
                set empty_width [ log2ceil $symbols_per_beat ] 
                set_port_property "out$i$empty" WIDTH_EXPR $empty_width
            }
        }
        if {$error_width > 0} {
            add_interface_port "out$i" "out$i$error" "error" "output" 1
            set_port_property "out$i$error" WIDTH_EXPR $error_width
        }

        if {$output_channel_width > 0} {
            add_interface_port "out$i" "out$i$channel" "channel" "output" $output_channel_width
        }
    }

    validate    
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sfo1400787952932/iga1401396936060 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
