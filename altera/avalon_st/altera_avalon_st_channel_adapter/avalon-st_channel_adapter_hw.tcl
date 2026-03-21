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

set_module_property NAME channel_adapter 
set_module_property DISPLAY_NAME "Avalon-ST Channel Adapter"
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
add_fileset quartus_synth QUARTUS_SYNTH generate "Channel Adapter Generation"
add_fileset verilog_simulation SIM_VERILOG generate "Channel Adapter Generation"
add_fileset vhdl_simulation    SIM_VHDL    generate "Channel Adapter Generation"

# +-----------------------------------
# | parameters
# |
add_parameter inChannelWidth     INTEGER 0 ""
set_parameter_property inChannelWidth allowed_ranges {0:512}

add_parameter inMaxChannel       INTEGER 0 ""

add_parameter outChannelWidth    INTEGER 0 ""
set_parameter_property outChannelWidth allowed_ranges {0:512}

add_parameter outMaxChannel      INTEGER 0 ""

add_parameter inBitsPerSymbol    INTEGER 8 ""
set_parameter_property inBitsPerSymbol allowed_ranges {1:4096}

add_parameter inUsePackets       BOOLEAN false ""

add_parameter inUseEmptyPort     STRING "AUTO" 
set_parameter_property inUseEmptyPort allowed_ranges {"NO" "YES" "AUTO"}

add_parameter inUseEmpty         BOOLEAN false ""
set_parameter_property inUseEmpty visible false

add_parameter inSymbolsPerBeat   INTEGER 1 ""
set_parameter_property inSymbolsPerBeat allowed_ranges {1:512}

add_parameter inUseReady         BOOLEAN true ""

add_parameter inReadyLatency     INTEGER 0 ""
set_parameter_property inReadyLatency allowed_ranges {0:4}

add_parameter inErrorWidth       INTEGER 0 ""
set_parameter_property inErrorWidth allowed_ranges {0:512}

add_parameter inErrorDescriptor  STRING_LIST ""


# +-----------------------------------
# | display items, names, and descriptions
# |

set_parameter_property inChannelWidth   DISPLAY_NAME "Channel Signal Width (bits)"
set_parameter_property inMaxChannel     DISPLAY_NAME "Max Channel"
set_parameter_property outChannelWidth  DISPLAY_NAME "Channel Signal Width (bits)"
set_parameter_property outMaxChannel    DISPLAY_NAME "Max Channel"
set_parameter_property inBitsPerSymbol  DISPLAY_NAME "Data Bits Per Symbol"
set_parameter_property inUsePackets     DISPLAY_NAME "Include Packet Support"
set_parameter_property inUseEmptyPort   DISPLAY_NAME "Include Empty Signal" 

set_parameter_property inSymbolsPerBeat  DISPLAY_NAME "Data Symbols Per Beat"
set_parameter_property inUseReady        DISPLAY_NAME "Support Backpressure with the ready signal"
set_parameter_property inReadyLatency    DISPLAY_NAME "Ready Latency"
set_parameter_property inErrorWidth      DISPLAY_NAME "Error Signal Width (bits)"
set_parameter_property inErrorDescriptor DISPLAY_NAME "Error Signal Description"

set_parameter_property inChannelWidth    DESCRIPTION "Width of the Input Channel Signal in bits."
set_parameter_property inMaxChannel      DESCRIPTION "Maximum Input Channel Number."
set_parameter_property outChannelWidth   DESCRIPTION "Width of the Output Channel Signal in bits."
set_parameter_property outMaxChannel     DESCRIPTION "Maximum Output Channel Number."
set_parameter_property inBitsPerSymbol   DESCRIPTION "Number of bits for each symbol in a transfer."
set_parameter_property inUsePackets      DESCRIPTION "Indicates if packets will be used."
set_parameter_property inUseEmptyPort    DESCRIPTION "Indicates is an empty signal is required." 
set_parameter_property inSymbolsPerBeat  DESCRIPTION "Number of symbols per transfer."
set_parameter_property inUseReady        DESCRIPTION "Indicates if a ready signal is required."
set_parameter_property inReadyLatency    DESCRIPTION "Specifies the ready latency to expect from the sink connected to this module's source interface."
set_parameter_property inErrorWidth      DESCRIPTION "Width of the Error signal output in bits."
set_parameter_property inErrorDescriptor DESCRIPTION "A list of strings describing errors."

set_parameter_property inChannelWidth    GROUP "Input Interface Parameters" 
set_parameter_property inMaxChannel      GROUP "Input Interface Parameters" 
set_parameter_property outChannelWidth   GROUP "Output Interface Parameters"
set_parameter_property outMaxChannel     GROUP "Output Interface Parameters"
set_parameter_property inBitsPerSymbol   GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inUsePackets      GROUP "Common to Input and Output Interface Parameters"
add_display_item "Common to Input and Output Interface Parameters" PKTmessage1 TEXT "<html>When packets are supported, the startofpacket, <br>endofpacket, and empty signals are used."
set_parameter_property inUseEmptyPort    GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inSymbolsPerBeat  GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inUseReady        GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inReadyLatency    GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inErrorWidth      GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inErrorDescriptor GROUP "Common to Input and Output Interface Parameters"

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

proc validate_channelWidths {} {
    set in_channel_width     [ get_parameter_value "inChannelWidth" ]
    if {$in_channel_width >0} {
        set inChannelBits [ get_port_property in_channel WIDTH_EXPR ]
        set maxChannelIn [ get_interface_property "in" "maxChannel" ]
        set neededChannelInBits [ log2ceil [expr $maxChannelIn + 1] ]
    
        if { $neededChannelInBits > $inChannelBits} {
            send_message error "Input Interface Channel Width($inChannelBits) is not sufficiently large to represent Input Interface Maximum Channel Number($maxChannelIn)"
        }
    }
    
    set out_channel_width     [ get_parameter_value "outChannelWidth" ]
    if {$out_channel_width >0} {
        set outChannelBits [ get_port_property out_channel WIDTH_EXPR ]    
        set maxChannelOut [ get_interface_property "out" "maxChannel" ]
        set neededChannelOutBits [ log2ceil [expr $maxChannelOut + 1] ]  
        if { $neededChannelOutBits > $outChannelBits} {
            send_message error "Output Interface Channel Width($outChannelBits) is not sufficiently large to represent Output Interface Maximum Channel Number($maxChannelOut)"        
        }
    }
}

proc validate {} {
    global inBeatsPerCycle
    global outBeatsPerCycle
    source ../AtlanticComponentsShared/AtlanticCommonValidation.tcl
    validate_channelWidths     
    validate_requiredSignals "in" "Input"
    validate_requiredSignals "out" "Output"
    validate_dataAndEmptyWidths in_data in_empty $inBeatsPerCycle "in" "Input"
    validate_dataAndEmptyWidths out_data out_empty $outBeatsPerCycle "out" "Output"
    validate_SoP_EoP_Valid_Widths in_startofpacket in_endofpacket in_valid $inBeatsPerCycle "Input"
    validate_SoP_EoP_Valid_Widths out_startofpacket out_endofpacket out_valid $outBeatsPerCycle "Output"
    validate_ErrorWidth in_error $inBeatsPerCycle "Input"
    validate_ErrorWidth out_error $outBeatsPerCycle "Output"
}

proc createVerilogFile {output_name} {
    set this_dir [ get_module_property MODULE_DIRECTORY ]
    set template_file [ file join $this_dir "avalon-st_channel_adapter.sv.terp" ]        
    set template    [ read [ open $template_file r ] ]

    set symbols_per_beat     [ get_parameter_value "inSymbolsPerBeat" ]
    set bits_per_symbol      [ get_parameter_value "inBitsPerSymbol" ]
    set use_empty            [ get_Emptyparameter_value "inUseEmptyPort" ] 
    set deprecatedInUseEmpty [ get_parameter_value "inUseEmpty"]
    set use_packets          [ get_parameter_value "inUsePackets" ]

    set params(output_name)      $output_name
    set params(inChannelWidth)   [ get_parameter_value "inChannelWidth" ]
    set params(inMaxChannel)     [ get_parameter_value "inMaxChannel" ]
    set params(outChannelWidth)  [ get_parameter_value "outChannelWidth" ]
    set params(outMaxChannel)    [ get_parameter_value "outMaxChannel" ]
    set params(dataWidth)        [ expr $symbols_per_beat * $bits_per_symbol ]
    set params(errorWidth)       [ get_parameter_value "inErrorWidth" ]
    set params(use_ready)        [ get_parameter_value "inUseReady" ]
    set params(use_packets)      $use_packets    


    if {($use_empty == 2)} {
        if {($use_packets && $symbols_per_beat >1) || ($use_packets && ($symbols_per_beat==1) && $deprecatedInUseEmpty)} {
            set params(use_empty)   1 
            set params(emptyWidth)  [ log2ceil [get_parameter_value "inSymbolsPerBeat" ]]
        } else {
            set params(use_empty)   0
            set params(emptyWidth)  0
        }
    } elseif {$use_packets && ($use_empty==1)} {
        set params(use_empty)   1 
        set params(emptyWidth)  [ log2ceil [get_parameter_value "inSymbolsPerBeat" ]]     
    } else {
            set params(use_empty)   0
            set params(emptyWidth)  0
    }
    
    # if {($use_empty == 1) || (($use_empty == 2) && ($symbols_per_beat>1))} {
    #     set params(use_empty)   1 
    #     set params(emptyWidth)  [ log2ceil [get_parameter_value "inSymbolsPerBeat" ]]
    #     #Consistent with set to inSymbolsPerBeat below.
    # } else {
    #     set params(use_empty)   0             
    #     set params(emptyWidth)  0
    # } 

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

    set_parameter_value inChannelWidth     $parmList(inChannelWidth)
    set_parameter_value inMaxChannel       $parmList(inMaxChannel)
    set_parameter_value outChannelWidth    $parmList(outChannelWidth)
    set_parameter_value outMaxChannel      $parmList(outMaxChannel)
    set_parameter_value inBitsPerSymbol    $parmList(inBitsPerSymbol)
    set_parameter_value inUsePackets       $parmList(inUsePackets)
    set_parameter_value inUseEmptyPort     $parmList(inUseEmptyPort)
    set_parameter_value inUseEmpty         $parmList(inUseEmpty)
    set_parameter_value inSymbolsPerBeat   $parmList(inSymbolsPerBeat)
    set_parameter_value inUseReady         $parmList(inUseReady)
    set_parameter_value inReadyLatency     $parmList(inReadyLatency)
    set_parameter_value inErrorWidth       $parmList(inErrorWidth)
    set_parameter_value inErrorDescriptor  $parmList(inErrorDescriptor)
}

proc elaborate {} {
    source ../AtlanticComponentsShared/AtlanticCommonValidation.tcl
    set symbols_per_beat     [ get_parameter_value "inSymbolsPerBeat" ]
    set bits_per_symbol      [ get_parameter_value "inBitsPerSymbol" ]
    set data_width           [ expr $symbols_per_beat * $bits_per_symbol ]
    set in_channel_width     [ get_parameter_value "inChannelWidth" ]
    set in_max_channel       [ get_parameter_value "inMaxChannel" ]
    set out_channel_width    [ get_parameter_value "outChannelWidth" ]
    set out_max_channel      [ get_parameter_value "outMaxChannel" ]
    set use_packets          [ get_parameter_value "inUsePackets" ]
    set use_empty            [ get_Emptyparameter_value "inUseEmptyPort" ] 
    set deprecatedInUseEmpty [ get_parameter_value "inUseEmpty"]
    set use_ready            [ get_parameter_value "inUseReady" ]
    set ready_latency        [ get_parameter_value "inReadyLatency" ]
    set error_width          [ get_parameter_value "inErrorWidth" ]
    set error_description    [ get_parameter_value "inErrorDescriptor" ]


    
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
    set_interface_property "in" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "in" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "in" "readyLatency" $ready_latency
    set_interface_property "in" "maxChannel" $in_max_channel
    set_interface_property "in" "errorDescriptor" $error_description

    # Avalon-ST source interface
    add_interface "out" "avalon_streaming" "source" "clk"
    add_interface_port "out" "out_data" "data" "output" $data_width
    add_interface_port "out" "out_valid" "valid" "output" 1
    set_interface_property "out" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "out" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "out" "readyLatency" $ready_latency 
    set_interface_property "out" "maxChannel" $out_max_channel
    set_interface_property "out" "errorDescriptor" $error_description

    if {$use_ready } {
        set_parameter_property inReadyLatency ENABLED true
        add_interface_port "in" "in_ready" "ready" "output" 1
        add_interface_port "out" "out_ready" "ready" "input" 1
    } else {
        set_parameter_property inReadyLatency ENABLED false
    }
 
    if {$use_packets } {
        set_parameter_property inUseEmptyPort ENABLED true
        add_interface_port "in" "in_startofpacket" "startofpacket" "input" 1
        add_interface_port "in" "in_endofpacket" "endofpacket" "input" 1
        add_interface_port "out" "out_startofpacket" "startofpacket" "output" 1
        add_interface_port "out" "out_endofpacket" "endofpacket" "output" 1
        
        # if {$use_empty == 1 || (($use_empty == 2) && ($symbols_per_beat>1)) } { #"YES" and "AUTO" for backwards compatibility with old jar version of this IP, 
        #                                            # which said use empty if symbols/beat is greater than 1 in AUTO mode.
        #     add_interface_port "in" "in_empty" "empty" "input" 1
        #     add_interface_port "out" "out_empty" "empty" "output" 1
        #     set empty_width [ log2ceil $symbols_per_beat ] 
        #     set_port_property in_empty WIDTH_EXPR $empty_width
        #     set_port_property out_empty WIDTH_EXPR $empty_width
        # }

        if {($use_empty == 2)} {
            if {($symbols_per_beat >1) || (($symbols_per_beat==1) && $deprecatedInUseEmpty)} {
                add_interface_port "in" "in_empty" "empty" "input" 1
                add_interface_port "out" "out_empty" "empty" "output" 1
                set empty_width [ log2ceil $symbols_per_beat ] 
                set_port_property in_empty WIDTH_EXPR $empty_width
                set_port_property out_empty WIDTH_EXPR $empty_width
            } 
        } elseif {$use_empty==1} {
            add_interface_port "in" "in_empty" "empty" "input" 1
            add_interface_port "out" "out_empty" "empty" "output" 1
            set empty_width [ log2ceil $symbols_per_beat ] 
            set_port_property in_empty WIDTH_EXPR $empty_width
            set_port_property out_empty WIDTH_EXPR $empty_width
        }        
    } else {
        set_parameter_property inUseEmptyPort ENABLED false
    }

    if {$error_width > 0} {
        add_interface_port "in" "in_error" "error" "input" 1 
        set_port_property in_error WIDTH_EXPR $error_width
        add_interface_port "out" "out_error" "error" "output" 1
        set_port_property out_error WIDTH_EXPR $error_width
    }

    if {$in_channel_width > 0} {
      add_interface_port "in" "in_channel" "channel" "input" $in_channel_width
    } 

    # else {
    #   add_interface_port "in" "in_channel" "channel" "input" 1
    #   set_port_property  "in_channel" TERMINATION 1
    #   set_port_property  "in_channel" TERMINATION_VALUE 0
    # }

    if {$out_channel_width > 0} {
      add_interface_port "out" "out_channel" "channel" "output" $out_channel_width
    } 

    # else {
    #   add_interface_port "out" "out_channel" "channel" "output" 1
    #   set_port_property  "out_channel" TERMINATION 1
    # }
    
    validate    
}





## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409958828732
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
