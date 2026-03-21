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

set_module_property NAME multiplexer
set_module_property DISPLAY_NAME "Avalon-ST Multiplexer"
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
add_fileset quartus_synth QUARTUS_SYNTH generate "Multiplexer Generation"
add_fileset quartus_synth SIM_VERILOG generate "Multiplexer Generation"
add_fileset vhdl_sim      SIM_VHDL    generate "Multiplexer Generation"

# +-----------------------------------
# | parameters
# |
add_parameter outChannelWidth      INTEGER 1 ""
set_parameter_property outChannelWidth allowed_ranges {0:31}

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

add_parameter numInputInterfaces    INTEGER 2 ""
set_parameter_property numInputInterfaces allowed_ranges {2:16}

add_parameter schedulingSize        INTEGER 2 ""
set_parameter_property schedulingSize allowed_ranges {1:512}

add_parameter packetScheduling      BOOLEAN false
add_parameter useHighBitsOfChannel  BOOLEAN true

add_parameter symbolsPerBeat        INTEGER 4 ""
set_parameter_property symbolsPerBeat allowed_ranges {1:512}

add_parameter errorWidth            INTEGER 0 ""
set_parameter_property errorWidth allowed_ranges {0:16}
add_parameter inErrorWidth          INTEGER 0 ""
set_parameter_property inErrorWidth DERIVED true
set_parameter_property inErrorWidth VISIBLE false


# +-----------------------------------
# | display items, names, and descriptions
# |
set_parameter_property numInputInterfaces DISPLAY_NAME "Number of Input Ports"
set_parameter_property schedulingSize         DISPLAY_NAME "Scheduling Size (Cycles)"
set_parameter_property packetScheduling   DISPLAY_NAME "Use Packet Scheduling"
set_parameter_property useHighBitsOfChannel   DISPLAY_NAME "Use high bits to indicate source port"

set_parameter_property bitsPerSymbol    DISPLAY_NAME "Data Bits Per Symbol"
set_parameter_property symbolsPerBeat   DISPLAY_NAME "Data Symbols Per Beat"
set_parameter_property usePackets        DISPLAY_NAME "Include Packet Support"
set_parameter_property outChannelWidth      DISPLAY_NAME "Channel Signal Width (bits)"
set_parameter_property errorWidth        DISPLAY_NAME "Error Signal Width (bits)"

set_parameter_property numInputInterfaces DESCRIPTION "Number of input interfaces"
set_parameter_property schedulingSize         DESCRIPTION "Scheduling Size (Cycles)"
set_parameter_property packetScheduling   DESCRIPTION "Use Packet Scheduling"
set_parameter_property useHighBitsOfChannel   DESCRIPTION "Use high bits to indicate source port"
set_parameter_property bitsPerSymbol         DESCRIPTION "Number of bits for each symbol in a transfer." 
set_parameter_property symbolsPerBeat        DESCRIPTION "Number of symbols per transfer."
set_parameter_property usePackets             DESCRIPTION "Indicates if packets will be used."
set_parameter_property outChannelWidth           DESCRIPTION "Width of the Channel Signal in bits."
set_parameter_property errorWidth             DESCRIPTION "Width of the Error signal output in bits."

set_parameter_property numInputInterfaces GROUP "Functional Parameters"
set_parameter_property schedulingSize          GROUP "Functional Parameters"
set_parameter_property packetScheduling    GROUP "Functional Parameters"
set_parameter_property useHighBitsOfChannel    GROUP "Functional Parameters"
add_display_item "Functional Parameters" HCHmessage1 TEXT "<html>When selected, the high order bits of the output channel<br>signal indicate the input interface the data came from,<br>and the low order bits are those from the input interface's<br>channel signal.<br>When not selected, the low order bits indicate the input<br>interface, and the high order bits are passed through<br>from the input."
set_parameter_property bitsPerSymbol    GROUP "Input Interface"
set_parameter_property symbolsPerBeat   GROUP "Input Interface"
set_parameter_property usePackets        GROUP "Input Interface"
add_display_item "Input Interface" PKTmessage1 TEXT "<html>When packets are supported, the startofpacket, <br>endofpacket, and empty signals are used."
set_parameter_property outChannelWidth      GROUP "Input Interface"
set_parameter_property errorWidth        GROUP "Input Interface"


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

proc validate_muxOutChannelWidth {iface channelPort beatsPerCycle ifaceUserString} {
    global maxNumberSymbols
    set channelWidth [ get_parameter_value "outChannelWidth" ]
    set maxChannel [ get_interface_property $iface "maxChannel" ]

    if {$maxChannel >0 } {
        set neededChannelBits [ log2ceil [expr $maxChannel + 1] ]
        if {$channelWidth>0} {
            set channelBits [ get_port_property $channelPort WIDTH_EXPR ]
        } else {
            set channelBits 0
        }
        if { $neededChannelBits > $channelBits} {
            send_message error "$ifaceUserString Interface Channel Width($channelBits) is not sufficiently large to represent Input Interface Maximum Channel Number($maxChannel)"
        }  

        if { $channelBits % $beatsPerCycle != 0 } {
            send_message error "$ifaceUserString interface channel port width($channelBits) is not a multiple of beats per cycle($beatsPerCycle)."
        }
    }
}

proc validate_muxInChannelWidth {iface channelPort beatsPerCycle ifaceUserString} {
    global maxNumberSymbols
    set channelWidth [ get_port_property $channelPort WIDTH_EXPR ]
    set maxChannel [ get_interface_property $iface "maxChannel" ]

    if {$maxChannel >0 } {
        set neededChannelBits [ log2ceil [expr $maxChannel + 1] ]
        if {$channelWidth>0} {
            set channelBits [ get_port_property $channelPort WIDTH_EXPR ]
        } else {
            set channelBits 0
        }
        if { $neededChannelBits > $channelBits} {
            send_message error "$ifaceUserString Interface Channel Width($channelBits) is not sufficiently large to represent Input Interface Maximum Channel Number($maxChannel)"
        }  

        if { $channelBits % $beatsPerCycle != 0 } {
            send_message error "$ifaceUserString interface channel port width($channelBits) is not a multiple of beats per cycle($beatsPerCycle)."
        }
    }
}

proc validate {} {
    global inBeatsPerCycle
    global outBeatsPerCycle
    set channel_width    [get_parameter_value "outChannelWidth" ]
    set symbols_per_beat [get_parameter_value "symbolsPerBeat" ]
    set number_input_interfaces [ get_parameter_value "numInputInterfaces" ]
    set data "_data"
    set valid "_valid"
    set ready "_ready"
    set sop "_startofpacket"
    set eop "_endofpacket"
    set empty "_empty"
    set error "_error"
    set channel "_channel"

    source ../AtlanticComponentsShared/AtlanticCommonValidation.tcl
    set neededChannelBits [log2ceil $number_input_interfaces]
    if {$channel_width < $neededChannelBits} {
        send_message error "Output interface Channel Width($channel_width) is not wide enough to represent the number of input interfaces($number_input_interfaces)."
    }
    ##Validate Output Interfaces
    validate_requiredSignals "out" "Output"
    validate_dataAndEmptyWidths out_data out_empty $outBeatsPerCycle "out" "Output"
    validate_SoP_EoP_Valid_Widths out_startofpacket out_endofpacket out_valid $outBeatsPerCycle "Output"
    validate_muxOutChannelWidth "out" out_channel $outBeatsPerCycle "Output"
    validate_ErrorWidth out_error $outBeatsPerCycle "Output" 

    ##Validate Input Interfaces
    set num_inputs              [ get_parameter_value "numInputInterfaces" ]
    set channel_width           [ get_parameter_value "outChannelWidth" ]
    set input_channel_width     [expr $channel_width - [log2ceil $num_inputs ] ]
    for {set i 0} {$i < $number_input_interfaces} {incr i} {
        validate_requiredSignals "in$i" "Input"
        validate_dataAndEmptyWidths "in$i$data" "in$i$empty" $inBeatsPerCycle "in$i" "Input$i"
        validate_SoP_EoP_Valid_Widths "in$i$sop" "in$i$eop" "in$i$valid" $inBeatsPerCycle "Input$i"
        if {$input_channel_width >0} {
            validate_muxInChannelWidth "in$i" "in$i$channel" $inBeatsPerCycle "Input$i"
        }
        validate_ErrorWidth "in$i$error" $inBeatsPerCycle "Input$i"    
    }
}

proc createVerilogFile {output_name} {
    set this_dir                [ get_module_property MODULE_DIRECTORY ]
    set template_file           [ file join $this_dir "avalon-st_multiplexer.sv.terp" ]        
    set template                [ read [ open $template_file r ] ]    

    set symbols_per_beat        [ get_parameter_value "symbolsPerBeat" ]
    set bits_per_symbol         [ get_parameter_value "bitsPerSymbol" ]
    set use_empty               [ get_Emptyparameter_value "inUseEmptyPort" ]
    set use_high_order_chbits   [ get_parameter_value "useHighBitsOfChannel" ]
    set channel_width           [ get_parameter_value "outChannelWidth" ]
    set num_inputs              [ get_parameter_value "numInputInterfaces" ]
    set input_channel_width     [expr $channel_width - [log2ceil $num_inputs ] ]
    set selectBits              "0:0"
    set selectWidth             [log2ceil $num_inputs ]
    set use_packet_scheduling   [ get_parameter_value "packetScheduling" ]
    set schedulingSize          [ get_parameter_value "schedulingSize" ]
    set schedulingSizeInBits    [ log2ceil $schedulingSize ] 
    set use_packets             [ get_parameter_value "usePackets" ]

    set colon ":"
    set minus1 "-1"
    set zero "0"
    set selectBits "$selectWidth$minus1$colon$zero"
    
    set channelSelectBits $selectBits
    
    if {$use_high_order_chbits} {        
        set channelSelectBits "$channel_width$minus1$colon$input_channel_width"
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
    set params(numInputs)         $num_inputs
    set params(inChWidth)         $input_channel_width
    set params(selectBits)        $selectBits
    set params(channelSelectBits) $channelSelectBits
    set params(selectWidth)       $selectWidth
    set params(use_packet_scheduling) $use_packet_scheduling
    set params(schedulingSizeInBits) $schedulingSizeInBits
    set params(schedulingSize) $schedulingSize

    set comma ","
    set colon ":"
    set outPayloadWidth 0
    set outPayloadMap ""
    set outPorts [ get_interface_ports "out"]

    foreach port $outPorts {
        set role [get_port_property $port ROLE]
        if { ($role =="valid") || ($role == "ready") } {
            continue
        }
        set tempWidth [get_port_property $port WIDTH_EXPR]
        set outPayloadWidth  [expr $outPayloadWidth + $tempWidth]
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
        if {$outPayloadMap == ""} {
            set outPayloadMap "$port"
        } else {
            set outPayloadMap "$outPayloadMap$comma$port"
        }
    }
    set params(outPayloadMap) $outPayloadMap

    set params(inPayloadMap) [list]
    for {set i 0} {$i < $num_inputs} {incr i} {
        set inPorts [ get_interface_ports "in$i"]
        set tempStr ""
        set thisWidth 0
        foreach port $inPorts {
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
        lappend params(inPayloadMap) $tempStr
        if {$i == 0} {
            set params(inPayloadWidth) $thisWidth
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

    set_parameter_value outChannelWidth      $parmList(outChannelWidth)
    set_parameter_value bitsPerSymbol        $parmList(bitsPerSymbol)
    set_parameter_value usePackets           $parmList(usePackets)
    set_parameter_value numInputInterfaces   $parmList(numInputInterfaces)
    set_parameter_value schedulingSize       $parmList(schedulingSize)
    set_parameter_value packetScheduling     $parmList(packetScheduling)
    set_parameter_value useHighBitsOfChannel $parmList(useHighBitsOfChannel)
    set_parameter_value symbolsPerBeat       $parmList(symbolsPerBeat)
    set_parameter_value errorWidth           $parmList(errorWidth)
}


proc elaborate {} {
    set symbols_per_beat        [ get_parameter_value "symbolsPerBeat" ]
    set bits_per_symbol         [ get_parameter_value "bitsPerSymbol" ]
    set data_width              [ expr $symbols_per_beat * $bits_per_symbol ]
    set channel_width           [ get_parameter_value "outChannelWidth" ]
    set use_packets             [ get_parameter_value "usePackets" ]
    set_parameter_value inUsePackets $use_packets
    set use_packet_scheduling   [ get_parameter_value "packetScheduling" ]
    set error_width             [ get_parameter_value "errorWidth" ]
    set_parameter_value inErrorWidth $error_width
    set number_input_interfaces [ get_parameter_value "numInputInterfaces" ]    
    set use_high_order_chbits   [ get_parameter_value "useHighBitsOfChannel" ]


    set out_max_channel       [ expr [expr 2**$channel_width ] -1]

    set input_channel_width   [ expr $channel_width - [log2ceil $number_input_interfaces ] ]    
    set in_max_channel        [ expr [expr 2**$input_channel_width ] - 1]
   
    if {$use_packet_scheduling} {
        set_parameter_property schedulingSize ENABLED false
        if {$use_packets == false} {
            send_message error "Must use packets for packet scheduling"
        }
    } else {
        set_parameter_property schedulingSize ENABLED true
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

    # Avalon-ST source interface
    add_interface "out" "avalon_streaming" "source" "clk"
    add_interface_port "out" "out_data" "data" "output" $data_width
    add_interface_port "out" "out_valid" "valid" "output" 1
    add_interface_port "out" "out_ready" "ready" "input" 1    

    set_interface_property "out" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "out" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "out" "maxChannel" $out_max_channel
    
    if {$use_packets } {
        add_interface_port "out" "out_startofpacket" "startofpacket" "output" 1
        add_interface_port "out" "out_endofpacket" "endofpacket" "output" 1
        if {$symbols_per_beat >1 } {
            add_interface_port "out" "out_empty" "empty" "output" 1
            set empty_width [ log2ceil $symbols_per_beat ] 
            set_port_property out_empty WIDTH_EXPR $empty_width
        }
    } 

    if {$error_width > 0} {
        add_interface_port "out" "out_error" "error" "output" 1 
        set_port_property out_error WIDTH_EXPR $error_width
    }

    if {$channel_width > 0} {
      add_interface_port "out" "out_channel" "channel" "output" $channel_width
    }

    # Avalon-ST sink interfaces
    for {set i 0} {$i < $number_input_interfaces} {incr i} {
        set data "_data"
        set valid "_valid"
        set ready "_ready"
        set sop "_startofpacket"
        set eop "_endofpacket"
        set empty "_empty"
        set error "_error"
        set channel "_channel"

        add_interface "in$i" "avalon_streaming" "sink" "clk"
        add_interface_port "in$i" "in$i$data" "data" "input" $data_width
        add_interface_port "in$i" "in$i$valid" "valid" "input" 1
    
        set_interface_property "in$i" "symbolsPerBeat" $symbols_per_beat
        set_interface_property "in$i" "dataBitsPerSymbol" $bits_per_symbol
        set_interface_property "in$i" "maxChannel" $in_max_channel
        add_interface_port "in$i" "in$i$ready" "ready" "output" 1        
        if {$use_packets } {
            add_interface_port "in$i" "in$i$sop" "startofpacket" "input" 1
            add_interface_port "in$i" "in$i$eop" "endofpacket" "input" 1
            if {$symbols_per_beat >1} { 
                add_interface_port "in$i" "in$i$empty" "empty" "input" 1
                set empty_width [ log2ceil $symbols_per_beat ] 
                set_port_property "in$i$empty" WIDTH_EXPR $empty_width
            }
        }
        if {$error_width > 0} {
            add_interface_port "in$i" "in$i$error" "error" "input" 1
            set_port_property "in$i$error" WIDTH_EXPR $error_width
        }

        if {$input_channel_width > 0} {
            add_interface_port "in$i" "in$i$channel" "channel" "input" $input_channel_width
        }
    }

    validate    
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sfo1400787952932/iga1401396936060 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
