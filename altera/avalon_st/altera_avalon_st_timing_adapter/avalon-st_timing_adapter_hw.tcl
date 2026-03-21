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

set_module_property NAME timing_adapter
set_module_property DISPLAY_NAME "Avalon-ST Timing Adapter"
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
add_fileset quartus_synth QUARTUS_SYNTH generate "Timing Adapter Generation"
add_fileset verilog_simulation SIM_VERILOG generate "Timing Adapter Generation"
add_fileset vhdl_simulation    SIM_VHDL    generate "Timing Adapter Generation"


# +-----------------------------------
# | parameters
# |
add_parameter inChannelWidth      INTEGER 0 ""
set_parameter_property inChannelWidth allowed_ranges {0:512}

add_parameter inMaxChannel        INTEGER 0 ""

add_parameter inBitsPerSymbol     INTEGER 8 ""
set_parameter_property inBitsPerSymbol allowed_ranges {1:4096}

add_parameter inUsePackets        BOOLEAN false ""

add_parameter inUseEmptyPort      STRING "AUTO" 
set_parameter_property inUseEmptyPort allowed_ranges {"NO" "YES" "AUTO"}

add_parameter inUseEmpty          BOOLEAN false ""
set_parameter_property inUseEmpty visible false

add_parameter inSymbolsPerBeat    INTEGER 1 ""
set_parameter_property inSymbolsPerBeat allowed_ranges {1:512}

add_parameter inUseReady          BOOLEAN true ""
add_parameter outUseReady         BOOLEAN true ""

add_parameter inReadyLatency      INTEGER 0 ""
set_parameter_property inReadyLatency allowed_ranges {0:4}

add_parameter outReadyLatency     INTEGER 0 ""
set_parameter_property outReadyLatency allowed_ranges {0:4}

add_parameter inErrorWidth        INTEGER 0 ""
set_parameter_property inErrorWidth allowed_ranges {0:512}

add_parameter inErrorDescriptor   STRING_LIST ""

add_parameter inUseValid          BOOLEAN true ""
add_parameter outUseValid         BOOLEAN true ""



# +-----------------------------------
# | display items, names, and descriptions
# |

set_parameter_property inChannelWidth      DISPLAY_NAME "Channel Signal Width (bits)"
set_parameter_property inMaxChannel        DISPLAY_NAME "Max Channel"
set_parameter_property inBitsPerSymbol     DISPLAY_NAME "Data Bits Per Symbol"
set_parameter_property inUsePackets        DISPLAY_NAME "Include Packet Support"
set_parameter_property inUseEmptyPort      DISPLAY_NAME "Include Empty Signal" 
set_parameter_property inSymbolsPerBeat    DISPLAY_NAME "Data Symbols Per Beat"
set_parameter_property inErrorWidth        DISPLAY_NAME "Error Signal Width (bits)"
set_parameter_property inErrorDescriptor   DISPLAY_NAME "Error Signal Description"

set_parameter_property inUseReady       DISPLAY_NAME "Support Backpressure with the ready signal"
set_parameter_property outUseReady      DISPLAY_NAME "Support Backpressure with the ready signal"
set_parameter_property inReadyLatency   DISPLAY_NAME "Ready Latency"
set_parameter_property outReadyLatency  DISPLAY_NAME "Ready Latency"
set_parameter_property inUseValid       DISPLAY_NAME "Include Valid Signal" 
set_parameter_property outUseValid      DISPLAY_NAME "Includ Valid Signal" 
 
set_parameter_property inChannelWidth      DESCRIPTION "Width of the Channel Signal in bits."
set_parameter_property inMaxChannel        DESCRIPTION "Maximum Channel Number."
set_parameter_property inBitsPerSymbol     DESCRIPTION "Number of bits for each symbol in a transfer."
set_parameter_property inUsePackets        DESCRIPTION "Indicates if packets will be used."
set_parameter_property inUseEmptyPort      DESCRIPTION "Indicates is an empty signal is required." 
set_parameter_property inSymbolsPerBeat    DESCRIPTION "Number of symbols per transfer."
set_parameter_property inErrorWidth        DESCRIPTION "Width of the Error signal output in bits."
set_parameter_property inErrorDescriptor   DESCRIPTION "A list of strings describing errors."

set_parameter_property inUseReady       DESCRIPTION "Indicates if the sink interface requires a ready signal."
set_parameter_property outUseReady      DESCRIPTION "Indicates if the source interface requires a ready signal."
set_parameter_property inReadyLatency   DESCRIPTION "Specifies the ready latency to expect from the source connected to this module's sink interface."
set_parameter_property outReadyLatency  DESCRIPTION "Specifies the ready latency to expect from the sink connected to this module's source interface."
set_parameter_property inUseValid       DESCRIPTION "Indicates if the sink interface requires a valid signal."
set_parameter_property outUseValid      DESCRIPTION "Indicates if the source interface requires a valid signal."


set_parameter_property inUseReady        GROUP "Input Interface Parameters"
set_parameter_property inReadyLatency    GROUP "Input Interface Parameters"
set_parameter_property inUseValid        GROUP "Input Interface Parameters"
set_parameter_property outUseReady       GROUP "Output Interface Parameters"
set_parameter_property outReadyLatency   GROUP "Output Interface Parameters"
set_parameter_property outUseValid       GROUP "Output Interface Parameters"

set_parameter_property inBitsPerSymbol   GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inUsePackets      GROUP "Common to Input and Output Interface Parameters"
add_display_item "Common to Input and Output Interface Parameters" PKTmessage1 TEXT "<html>When packets are supported, the startofpacket, <br>endofpacket, and empty signals are used."
set_parameter_property inUseEmptyPort    GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inSymbolsPerBeat  GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inChannelWidth    GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inMaxChannel      GROUP "Common to Input and Output Interface Parameters"
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


proc validate {} {
    global inBeatsPerCycle
    global outBeatsPerCycle
    set in_use_valid     [ get_parameter_value "inUseValid" ]
    set out_use_valid    [ get_parameter_value "outUseValid" ]
    set channel_width    [ get_parameter_value "inChannelWidth" ]
    source ../AtlanticComponentsShared/AtlanticCommonValidation.tcl
    validate_requiredSignals "in" "Input"
    validate_requiredSignals "out" "Output"
    validate_dataAndEmptyWidths in_data in_empty $inBeatsPerCycle "in" "Input"
    validate_dataAndEmptyWidths out_data out_empty $outBeatsPerCycle "out" "Output"
    if {$in_use_valid} {
        validate_SoP_EoP_Valid_Widths in_startofpacket in_endofpacket in_valid $inBeatsPerCycle "Input"
    }
    if {$out_use_valid} {
        validate_SoP_EoP_Valid_Widths out_startofpacket out_endofpacket out_valid $outBeatsPerCycle "Output"
    }
    if {$channel_width >0} {
        validate_ChannelWidth "in" in_channel $inBeatsPerCycle "Input"
        validate_ChannelWidth "out" out_channel $outBeatsPerCycle "Output"
    }
    validate_ErrorWidth in_error $inBeatsPerCycle "Input" 
    validate_ErrorWidth out_error $outBeatsPerCycle "Output"    
}

proc createVerilogAdapterFile {output_name} {
    set this_dir                 [ get_module_property MODULE_DIRECTORY ]
    set template_file            [ file join $this_dir "avalon-st_timing_adapter.sv.terp" ]        
    set template                 [ read [ open $template_file r ] ]    

    set symbols_per_beat         [ get_parameter_value "inSymbolsPerBeat" ]
    set bits_per_symbol          [ get_parameter_value "inBitsPerSymbol" ]
    set use_empty                [ get_Emptyparameter_value "inUseEmptyPort" ] 
    set deprecatedInUseEmpty     [ get_parameter_value "inUseEmpty"]
    set in_ready_latency         [ get_parameter_value "inReadyLatency" ]
    set out_ready_latency        [ get_parameter_value "outReadyLatency" ]
    set use_packets              [ get_parameter_value "inUsePackets" ]

    set params(output_name)       $output_name
    set params(channelWidth)      [ get_parameter_value "inChannelWidth" ]
    set params(dataWidth)         [ expr $symbols_per_beat * $bits_per_symbol ]
    set params(errorWidth)        [ get_parameter_value "inErrorWidth" ]
    set params(in_use_ready)      [ get_parameter_value "inUseReady" ]
    set params(out_use_ready)     [ get_parameter_value "outUseReady" ]
    set params(in_use_valid)      [ get_parameter_value "inUseValid" ]
    set params(out_use_valid)     [ get_parameter_value "outUseValid" ]
    set params(use_packets)       $use_packets
    set params(in_ready_latency)  $in_ready_latency
    set params(out_ready_latency) $out_ready_latency 

    set comma ","
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
        if {$inPayloadMap == ""} {
            set inPayloadMap "$port"
        } else {
            set inPayloadMap "$inPayloadMap$comma$port"
        }
    }
    set params(inPayloadMap) $inPayloadMap
    set params(inPayloadWidth) $inPayloadWidth

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
        if {$outPayloadMap == ""} {
            set outPayloadMap "$port"
        } else {
            set outPayloadMap "$outPayloadMap$comma$port"
        }
    }
    set params(outPayloadMap) $outPayloadMap
    set params(outPayloadWidth) $outPayloadWidth

    # if {($use_empty == 0) || ($symbols_per_beat==1) || ($use_packets==false)} {
    #     set params(use_empty)   0             
    #     set params(emptyWidth)  0
    # } else {
    #     set params(use_empty)   1
    #     set params(emptyWidth)  [ log2ceil $symbols_per_beat ] 
    #     #Consistent with set to inSymbolsPerBeat below.
    # }

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
 
    set result          [ altera_terp $template params ]
    return $result
}

proc createVerilogFifoFile {output_name} {
    set inPayloadWidth 0
    set inPayloadMap ""
    set comma ","
    set inPorts [ get_interface_ports "in"]
    set in_ready_latency         [ get_parameter_value "inReadyLatency" ]
    set out_ready_latency        [ get_parameter_value "outReadyLatency" ]

    foreach port $inPorts {
        set role [get_port_property $port ROLE]
        if { ($role =="valid") || ($role == "ready") } {
            continue
        }
        set tempWidth [get_port_property $port WIDTH_EXPR]
        set inPayloadWidth  [expr $inPayloadWidth + $tempWidth]
        if {$inPayloadMap == ""} {
            set inPayloadMap "$port"
        } else {
            set inPayloadMap "$inPayloadMap$comma$port"
        }
    }
   
    set fifoDataWidth $inPayloadWidth
    set fifoDepth 8
    set fifoDepthBits 3
    if { $in_ready_latency > 1} {
        set fifoDepth 16
        set fifoDepthBits 4
    }
    set fifoPostFix "_fifo"
    set fifoName "$output_name$fifoPostFix"
    set fifoUseFillLevel true
    
    set this_dir              [ get_module_property MODULE_DIRECTORY ]
    set fifoTemplate_file     [ file join $this_dir "../AtlanticComponentsShared/simpleFifo.sv.terp" ]        
    set fifoTemplate          [ read [ open $fifoTemplate_file r ] ]    
    
    set fifoParams(output_name) $fifoName
    set fifoParams(depth)       $fifoDepth
    set fifoParams(depthBits)   $fifoDepthBits
    set fifoParams(dataWidth)   $inPayloadWidth
    set fifoParams(useFillLevel) $fifoUseFillLevel
    
    set fifoParams(in_use_ready)    true
    set fifoParams(in_use_valid)    true
    set fifoParams(out_use_ready)   true
    set fifoParams(out_use_valid)   true
    set fifoParams(outReadyLatency) 0
    set fifoParams(inReadyLatency)  0    
    set result [ altera_terp $fifoTemplate fifoParams ]
    return $result
}
 

proc generate {output_name} {
    set in_ready_latency         [ get_parameter_value "inReadyLatency" ]
    set out_ready_latency        [ get_parameter_value "outReadyLatency" ]


    set result [createVerilogAdapterFile $output_name]
    set output_file $output_name
    append output_file ".sv"
    add_fileset_file ${output_file} {SYSTEM_VERILOG} TEXT ${result}


    #### IF FIFO NEEDED, GENERATE FIFO RTL
    if { $in_ready_latency > $out_ready_latency } {
        set result [createVerilogFifoFile $output_name]
        set fifoPostFix "_fifo"
        set fifoName "$output_name$fifoPostFix"
        set output_file     $fifoName
        append output_file ".sv"
        add_fileset_file ${output_file} {SYSTEM_VERILOG} TEXT ${result}
    }
 
}

proc upgrade { kind, verion, parameters } {
    source ../AtlanticComponentsShared/AtlanticCommonValidation.tcl
    array set parmList [makeUpgradeList $parameters]

    set_parameter_value inChannelWidth     $parmList(inChannelWidth)
    set_parameter_value inMaxChannel       $parmList(inMaxChannel)
    set_parameter_value inBitsPerSymbol    $parmList(inBitsPerSymbol)
    set_parameter_value inUsePackets       $parmList(inUsePackets)
    set_parameter_value inUseEmptyPort     $parmList(inUseEmptyPort)
    set_parameter_value inUseEmpty         $parmList(inUseEmpty)
    set_parameter_value inSymbolsPerBeat   $parmList(inSymbolsPerBeat)
    set_parameter_value inUseReady         $parmList(inUseReady)
    set_parameter_value outUseReady        $parmList(outUseReady)
    set_parameter_value inReadyLatency     $parmList(inReadyLatency)
    set_parameter_value outReadyLatency    $parmList(outReadyLatency)
    set_parameter_value inErrorWidth       $parmList(inErrorWidth)
    set_parameter_value inErrorDescriptor  $parmList(inErrorDescriptor)
    set_parameter_value inUseValid         $parmList(inUseValid)
    set_parameter_value outUseValid        $parmList(outUseValid)
}


proc elaborate {} {
    #might want to replace this code with a loop    
    source ../AtlanticComponentsShared/AtlanticCommonValidation.tcl
    set symbols_per_beat   [ get_parameter_value "inSymbolsPerBeat" ]
    set bits_per_symbol    [ get_parameter_value "inBitsPerSymbol" ]
    set data_width         [ expr $symbols_per_beat * $bits_per_symbol ]
    set channel_width      [ get_parameter_value "inChannelWidth" ]
    set max_channel        [ get_parameter_value "inMaxChannel" ]
    set use_packets        [ get_parameter_value "inUsePackets" ]
    set in_use_ready       [ get_parameter_value "inUseReady" ]
    set in_use_valid       [ get_parameter_value "inUseValid" ]
    set out_use_valid      [ get_parameter_value "outUseValid" ]
    set out_use_ready      [ get_parameter_value "outUseReady" ]
    set use_empty          [ get_Emptyparameter_value "inUseEmptyPort" ] 
    set deprecatedInUseEmpty [ get_parameter_value "inUseEmpty"]
    set in_ready_latency   [ get_parameter_value "inReadyLatency" ]
    set out_ready_latency  [ get_parameter_value "outReadyLatency" ]
    set error_width        [ get_parameter_value "inErrorWidth" ]
    set error_description  [ get_parameter_value "inErrorDescriptor" ]


    
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
    if {$in_use_valid} {
        add_interface_port "in" "in_valid" "valid" "input" 1
    }
    set_interface_property "in" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "in" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "in" "readyLatency" $in_ready_latency
    set_interface_property "in" "maxChannel" $max_channel
    set_interface_property "in" "errorDescriptor" $error_description

    # Avalon-ST source interface
    add_interface "out" "avalon_streaming" "source" "clk"
    add_interface_port "out" "out_data" "data" "output" $data_width
    if {$out_use_valid} {
        add_interface_port "out" "out_valid" "valid" "output" 1
    }
    set_interface_property "out" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "out" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "out" "readyLatency" $out_ready_latency 
    set_interface_property "out" "maxChannel" $max_channel
    set_interface_property "out" "errorDescriptor" $error_description

    if {$in_use_ready } {
        set_parameter_property inReadyLatency ENABLED true
        add_interface_port "in" "in_ready" "ready" "output" 1
    } else {
        set_parameter_property inReadyLatency ENABLED false
    }

    if {$out_use_ready } {
        set_parameter_property outReadyLatency ENABLED true
        add_interface_port "out" "out_ready" "ready" "input" 1        
    } else {
        set_parameter_property outReadyLatency ENABLED false
    }

    if {$use_packets } {
        set_parameter_property inUseEmptyPort ENABLED true
        add_interface_port "in" "in_startofpacket" "startofpacket" "input" 1
        add_interface_port "in" "in_endofpacket" "endofpacket" "input" 1
        add_interface_port "out" "out_startofpacket" "startofpacket" "output" 1
        add_interface_port "out" "out_endofpacket" "endofpacket" "output" 1

        # if {($use_empty == 1 || $use_empty == 2) && $symbols_per_beat >1 } {
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

    if {$channel_width > 0} {
      add_interface_port "in" "in_channel" "channel" "input" $channel_width
      add_interface_port "out" "out_channel" "channel" "output" $channel_width
    } else {
      #add_interface_port "in" "in_channel" "channel" "input" 1
      #set_port_property  "in_channel" TERMINATION 1
      #set_port_property  "in_channel" TERMINATION_VALUE 0
      #add_interface_port "out" "out_channel" "channel" "output" 1
      #set_port_property  "out_channel" TERMINATION 1
    }
    validate    
}





## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409958828732
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
