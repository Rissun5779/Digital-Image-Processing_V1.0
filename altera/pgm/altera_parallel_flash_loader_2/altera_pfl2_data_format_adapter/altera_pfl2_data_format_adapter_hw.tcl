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

set_module_property NAME altera_pfl2_data_format_adapter
set_module_property DISPLAY_NAME "Avalon-ST Data Format Adapter PFL"
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Basic Functions/Bridges and Adaptors/Streaming"
set_module_property INTERNAL true

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
add_fileset quartus_synth QUARTUS_SYNTH generate "Data Format Adapter Generation"
add_fileset verilog_simulation SIM_VERILOG generate "Data Format Adapter Generation"
add_fileset vhdl_simulation    SIM_VHDL    generate "Data Format Adapter Generation"

# +-----------------------------------
# | parameters
# |
add_parameter inChannelWidth      INTEGER 0 ""
set_parameter_property inChannelWidth allowed_ranges {0:31}

add_parameter inMaxChannel        INTEGER 0 ""
add_parameter inBitsPerSymbol     INTEGER 8 ""
set_parameter_property inBitsPerSymbol allowed_ranges {1:4096}

add_parameter inUsePackets        BOOLEAN false ""

add_parameter endianess     STRING "Big Endian" 
set_parameter_property endianess allowed_ranges {"Big Endian" "Little Endian"}

add_parameter inUseEmptyPort      STRING "AUTO" 
set_parameter_property inUseEmptyPort allowed_ranges {"NO" "YES" "AUTO"}

add_parameter inUseEmpty          BOOLEAN false ""
set_parameter_property inUseEmpty visible false

add_parameter outUseEmptyPort     STRING "AUTO" 
set_parameter_property outUseEmptyPort allowed_ranges {"NO" "YES" "AUTO"}

add_parameter outUseEmpty         BOOLEAN false ""
set_parameter_property outUseEmpty visible false

add_parameter inSymbolsPerBeat    INTEGER 1 ""
set_parameter_property inSymbolsPerBeat allowed_ranges {1:32}

add_parameter outSymbolsPerBeat   INTEGER 1 ""
set_parameter_property outSymbolsPerBeat allowed_ranges {1:32}

add_parameter inReadyLatency      INTEGER 0 ""
set_parameter_property inReadyLatency allowed_ranges {0:4}

add_parameter inErrorWidth        INTEGER 0 ""
set_parameter_property inErrorWidth allowed_ranges {0:512}

add_parameter inErrorDescriptor   STRING_LIST ""


# +-----------------------------------
# | display items, names, and descriptions
# |

set_parameter_property inChannelWidth    DISPLAY_NAME "Channel Signal Width (bits)"
set_parameter_property inMaxChannel      DISPLAY_NAME "Max Channel"
set_parameter_property inBitsPerSymbol   DISPLAY_NAME "Data Bits Per Symbol"
set_parameter_property inUsePackets      DISPLAY_NAME "Include Packet Support"
set_parameter_property endianess     	 DISPLAY_NAME "Endianess"
set_parameter_property inUseEmptyPort    DISPLAY_NAME "Include Empty Signal" 
set_parameter_property outUseEmptyPort   DISPLAY_NAME "Include Empty Signal" 
set_parameter_property inSymbolsPerBeat  DISPLAY_NAME "Data Symbols Per Beat"
set_parameter_property outSymbolsPerBeat DISPLAY_NAME "Data Symbols Per Beat"
set_parameter_property inReadyLatency    DISPLAY_NAME "Ready Latency"
set_parameter_property inErrorWidth      DISPLAY_NAME "Error Signal Width (bits)"
set_parameter_property inErrorDescriptor DISPLAY_NAME "Error Signal Description"

set_parameter_property inChannelWidth    DESCRIPTION "Width of the Input Channel Signal in bits."
set_parameter_property inMaxChannel      DESCRIPTION "Maximum Input Channel Number."
set_parameter_property inBitsPerSymbol   DESCRIPTION "Number of bits for each symbol in a transfer."
set_parameter_property inUsePackets      DESCRIPTION "Indicates if packets will be used."
set_parameter_property endianess	 DESCRIPTION "Indicates the data arrangement"
set_parameter_property inUseEmptyPort    DESCRIPTION "Indicates is an empty signal is required." 
set_parameter_property outUseEmptyPort   DESCRIPTION "Indicates is an empty signal is required." 
set_parameter_property inSymbolsPerBeat  DESCRIPTION "Number of symbols per transfer."
set_parameter_property outSymbolsPerBeat DESCRIPTION "Number of symbols per transfer."
set_parameter_property inReadyLatency    DESCRIPTION "Specifies the ready latency to expect from the sink connected to this module's source interface."
set_parameter_property inErrorWidth      DESCRIPTION "Width of the Error signal output in bits."
set_parameter_property inErrorDescriptor DESCRIPTION "A list of strings describing errors."

set_parameter_property inSymbolsPerBeat  GROUP "Input Interface Parameters"
set_parameter_property inUseEmptyPort    GROUP "Input Interface Parameters"

set_parameter_property outSymbolsPerBeat GROUP "Output Interface Parameters"
set_parameter_property outUseEmptyPort   GROUP "Output Interface Parameters"

set_parameter_property inBitsPerSymbol   GROUP "Common to Input and Output Interface Parameters"
set_parameter_property endianess   GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inUsePackets      GROUP "Common to Input and Output Interface Parameters"
add_display_item "Common to Input and Output Interface Parameters" PKTmessage1 TEXT "<html>When packets are supported, the startofpacket, <br>endofpacket, and empty signals are used.<br>"
set_parameter_property inChannelWidth    GROUP "Common to Input and Output Interface Parameters"
set_parameter_property inMaxChannel      GROUP "Common to Input and Output Interface Parameters"
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


proc validate_Valid_Width {validPort beatsPerCycle ifaceUserString} {
    set validWidth [get_port_property $validPort WIDTH_EXPR ]
    if { $validWidth != $beatsPerCycle } {
        send_message error "$ifaceUserString interface valid port width($validWidth) does not equal beats per cycle ($beatsPerCycle)."
    }
}

proc validateReadyLatency {in_symbolsPerBeat out_symbolsPerBeat} {
    set doesSymbolAdaptation [expr $in_symbolsPerBeat != $out_symbolsPerBeat]
    set readyLatency        [ get_parameter_value "inReadyLatency" ]
    if {$doesSymbolAdaptation && ($readyLatency >0)} {
        send_message error "Unsupported adaptation: Ready Latency($readyLatency) cannot be non-zero when performing symbol adaptation (Input interface symbols per beat doesn't equal output symbols per beat)."
    }
}

proc validatePacketConfiguration {} {
    set use_packets        [ get_parameter_value "inUsePackets" ]
    set in_symbolsPerBeat  [ get_parameter_value "inSymbolsPerBeat" ]
    set out_symbolsPerBeat [ get_parameter_value "outSymbolsPerBeat" ]

    if {$use_packets} {
        if { ($in_symbolsPerBeat ==0) | ($out_symbolsPerBeat ==0)} {
            send_message error "Both Input and Output Symbols Per beat cannot be equal to 0."
            return
        }
        if {$in_symbolsPerBeat < $out_symbolsPerBeat} {
            if {[expr $out_symbolsPerBeat % $in_symbolsPerBeat] != 0 } {
                send_message error "Output symbols per beat:($out_symbolsPerBeat) not multiple of input symbols per beat:($in_symbolsPerBeat).\n Input interface symbols per beat is less than output symbols per beat. In this case, output symbols per beat must be an even multiple of input symbols per beat."
            }
        } else {
            if {[expr $in_symbolsPerBeat % $out_symbolsPerBeat] != 0 } {
                send_message error "Input symbols per beat:($in_symbolsPerBeat) not multiple of output symbols per beat:($out_symbolsPerBeat).\n Output interface symbols per beat is less than input symbols per beat. In this case, input symbols per beat must be an even multiple of output symbols per beat."
            }
        }

        set spbMisMatch true
        if { $in_symbolsPerBeat == $out_symbolsPerBeat } {
            set spbMisMatch false
        } 
        #set spbMisMatch [expr $in_symbolsPerBeat == $out_symbolsPerBeat ]        
        set in_use_empty          [ get_Emptyparameter_value "inUseEmptyPort" ] 
        set out_use_empty         [ get_Emptyparameter_value "outUseEmptyPort" ] 
   
        if {(($in_use_empty != 0) && ($out_use_empty==0) && ($out_symbolsPerBeat >1))} {
            if { $spbMisMatch } {
                send_message error "Unsupported adaptation: The input interface uses the empty signal. However, the output interface is not using the empty signal."
            } else {
                send_message warning "The symbols per beat on input interface($in_symbolsPerBeat) and the output interface($out_symbolsPerBeat) match,\n but the input interface is using the empty signal, while the output interface is not using the empty signal.\n Empty signal data may be lost between the input and the output interface (across this adapter)."
            }            
        }
        
        set narrowToWide [expr $in_symbolsPerBeat < $out_symbolsPerBeat]
        if { $narrowToWide && !$out_use_empty } {
            send_message error "The output interface has no empty signal, but this adapter has been configured to adapt a narrow input interface\n symbols per beat($in_symbolsPerBeat) to a wide output interface symbols per beat($out_symbolsPerBeat)."
        }
    }
}

proc validate {} {
    global inBeatsPerCycle
    global outBeatsPerCycle
    source ./AtlanticCommonValidation.tcl
    
    set channel_width         [ get_parameter_value "inChannelWidth" ]
    set use_packets           [ get_parameter_value "inUsePackets" ]
    set in_dataWidth          [ get_port_property in_data WIDTH_EXPR ]
    set in_use_empty          [ get_Emptyparameter_value "inUseEmptyPort" ] 
    set deprecatedInUseEmpty  [ get_parameter_value "inUseEmpty"]
    set out_dataWidth         [ get_port_property out_data WIDTH_EXPR ]
    set out_use_empty         [ get_Emptyparameter_value "outUseEmptyPort" ] 
    set deprecatedOutUseEmpty [ get_parameter_value "outUseEmpty"]
    set in_symbolsPerBeat     [ get_parameter_value "inSymbolsPerBeat" ]
    set out_symbolsPerBeat    [ get_parameter_value "outSymbolsPerBeat" ]
    set dataBitsPerSymbol     [ get_parameter_value "inBitsPerSymbol" ]



  
    validatePacketConfiguration
    
    validate_requiredSignals "in" "Input"
    validate_requiredSignals "out" "Output"

    validate_dataWidth $in_symbolsPerBeat $dataBitsPerSymbol $in_dataWidth "Input"
    validate_emptyWidth $in_symbolsPerBeat $dataBitsPerSymbol $in_dataWidth $in_use_empty $use_packets in_empty $inBeatsPerCycle $deprecatedInUseEmpty

    validate_dataWidth $out_symbolsPerBeat $dataBitsPerSymbol $out_dataWidth "Output"
    validate_emptyWidth $out_symbolsPerBeat $dataBitsPerSymbol $out_dataWidth $out_use_empty $use_packets out_empty $outBeatsPerCycle $deprecatedOutUseEmpty

    if {$use_packets} {
        validate_SoP_EoP_Valid_Widths in_startofpacket in_endofpacket in_valid $inBeatsPerCycle "Input"
        validate_SoP_EoP_Valid_Widths out_startofpacket out_endofpacket out_valid $outBeatsPerCycle "Output"
    } else {
        validate_Valid_Width in_valid $inBeatsPerCycle "Input"
        validate_Valid_Width out_valid $outBeatsPerCycle "Output"
    }
    if {$channel_width >0} {
        validate_ChannelWidth "in" in_channel $inBeatsPerCycle "Input"
        validate_ChannelWidth "out" out_channel $outBeatsPerCycle "Output"
    }
    validate_ErrorWidth in_error $inBeatsPerCycle "Input" 
    validate_ErrorWidth out_error $outBeatsPerCycle "Output"    
    validateReadyLatency $in_symbolsPerBeat $out_symbolsPerBeat
}

proc getMaxState {inSymbolsPerBeat outSymbolsPerBeat} {
    set decOutSymbolsPerBeat [expr $outSymbolsPerBeat -1]
    set decInSymbolsPerBeat [expr $inSymbolsPerBeat -1]

    set x $decOutSymbolsPerBeat
    if {$decInSymbolsPerBeat > $x} {
        set x  $decInSymbolsPerBeat
    }
    if { $x < 1 } {
        set x 1
    }
    return $x;
}

proc getWideToNarrowStates {inSymbolsPerBeat outSymbolsPerBeat inBitsPerSymbol} {
    set retString ""
    set hasData {}
    set maxState [getMaxState $inSymbolsPerBeat $outSymbolsPerBeat]
		set endianess        [ get_parameter_value "endianess" ]
    for {set mem 0} {$mem <= $maxState} {incr mem} {
        lappend hasData false
    }

    set lastDataDest [expr $outSymbolsPerBeat-1]
    set dataSource {}
    set stopLimit [expr 2 * [expr $lastDataDest +1] ]
    for {set dest 0} {$dest < $stopLimit} {incr dest} {
        lappend dataSource ""
    }

    set indata 0
    
    for {set state 0} {$state <= $maxState} {incr state} {
        append retString "         ${state} : begin\n"
        set stopLimit [expr 2 * [expr $lastDataDest +1] ]
        for {set dest 0} {$dest < $stopLimit} {incr dest} {
            lset dataSource $dest ""
        }
        set enoughDataForNextOutput true
        
        #Determine the Data Source
        set indataTmp $indata
        set stopLimit [expr 2 * [expr $lastDataDest + 1] ]
        for {set dest 0} {$dest < $stopLimit} {incr dest} {
            lset dataSource $dest ""
            set usedMem false
            set filled false
            set decMaxState [expr $maxState - 1]
            for {set mem 0} {$mem <= $decMaxState} {incr mem} {
                set hasDataElem [lindex $hasData $mem]
                if {$hasDataElem==true} {
                    lset dataSource $dest "mem_readdata${mem}"
                    set usedMem true
                    lset hasData $mem false
                    set filled true
                    [break]
                }
            }
            if {$usedMem==false} {
                if {$indataTmp < $inSymbolsPerBeat} {
					if {$endianess == "Little Endian"} {
						set little_endian [expr $inSymbolsPerBeat - $indata - 1]
					} else {
						set little_endian [expr $indata]
					 }
                       
                    lset dataSource $dest "a_data${little_endian}"
                    if {$dest <= $lastDataDest} {
                        incr indata
                    }
                    incr indataTmp
                    set filled true;
                }
            }
            if {$filled==false} {
                set enoughDataForNextOutput false
            }
        }
        
        for {set out 0} {$out < $outSymbolsPerBeat} {incr out} {
            set outsymbol [expr [expr $outSymbolsPerBeat - $out] - 1]
		if {$endianess == "Little Endian"} {
			set right [expr $inBitsPerSymbol * $out]
			} else {
			set right [expr $inBitsPerSymbol * $outsymbol]
			}
            set left [expr [expr $right + $inBitsPerSymbol] -1]
            set dataSourceElem [lindex $dataSource $out]            
            append retString "            b_data\[${left}:${right}\] = ${dataSourceElem};\n"
        }
        
        set writeEnables {}
        for {set i 0} {$i <= $maxState} {incr i} {
            lappend writeEnables 0
        }

        if {$enoughDataForNextOutput == false} {
            set mem 0
            set indataTmp1 $indata
            while {$indataTmp1 < $inSymbolsPerBeat} {
                append retString "            mem_writedata${mem} = a_data${indataTmp1};\n"
                lset writeEnables $mem 1
                lset hasData $mem true
                
                incr indataTmp1
                incr mem
            }
            set indata 0
        }
        if {$state == 0} {
            append retString "            b_startofpacket = a_startofpacket;\n"
        } else {
            append retString "            b_startofpacket = 0;\n"
        }
        append retString "            if (out_ready || ~out_valid) begin\n"
        if {$enoughDataForNextOutput == false} {
            append retString "            a_ready = 1;\n";
        }
        append retString "               if (a_valid) begin\n";
        append retString "                  b_valid = 1;\n";
        if {$state == $maxState} {
            append retString "                  new_state = 0;\n";                                  
        } else {
            append retString "                  new_state = state+1'b1;\n";                                 
        }
        for {set mem 0} {$mem <= $maxState} {incr mem} {
            set writeEnablesElem [lindex $writeEnables $mem]
            if {$writeEnablesElem == 1} {
                append retString "                  mem_write${mem} = 1;\n"
            }
        }
        set stateTimesOutSym [expr $state * $outSymbolsPerBeat]
        set stateTimesOutSymModInSym [expr $stateTimesOutSym % $inSymbolsPerBeat]
        set used [expr $stateTimesOutSymModInSym + $outSymbolsPerBeat]
        set remaining [expr $inSymbolsPerBeat - $used]
        append retString "                     if (a_endofpacket && (a_empty >= ${remaining}) ) begin\n"
        append retString "                        new_state = 0;\n"
        append retString "                        b_empty = a_empty - ${remaining};\n"
        append retString "                        b_endofpacket = 1;\n"
        append retString "                        a_ready = 1;\n"
        append retString "                     end\n"
        append retString "                  end\n"                
        append retString "               end\n"
        append retString "            end\n"
        set indata [expr $indata % $inSymbolsPerBeat]
    }
    return $retString
}


proc getNarrowToWideStates {inSymbolsPerBeat outSymbolsPerBeat inBitsPerSymbol} {
    set retString ""
    set hasData {}
    set maxState [getMaxState $inSymbolsPerBeat $outSymbolsPerBeat]
    set endianess        [ get_parameter_value "endianess" ]
    for {set mem 0} {$mem <= $maxState} {incr mem} {
        lappend hasData false
    }
    
    set lastDataDest [expr [expr $maxState + $outSymbolsPerBeat] -1]
    set dataSource {}
    for {set dest 0} {$dest <= $lastDataDest} {incr dest} {
        lappend dataSource ""
    }
    
    for {set state 0} {$state <= $maxState} {incr state} {
        append retString "         ${state} : begin\n"
        for {set dest 0} {$dest <= $lastDataDest} {incr dest} {
            lset dataSource $dest ""
        }
        set outputFilledByMemoryAlone true
        set enoughDataForOutput true
        set indata 0
        
        #Determine the Data Source
        for {set dest 0} {$dest <= $lastDataDest} {incr dest} {
            lset dataSource $dest ""
            set usedMem false
            set filled false
            set decMaxState [expr $maxState - 1]
            for {set mem 0} {$mem <= $decMaxState} {incr mem} {
                set hasDataElem [lindex $hasData $mem]
                if {$hasDataElem ==true} {
                    lset dataSource $dest "mem_readdata${mem}"
                    set usedMem true
                    lset hasData $mem false
                    set filled true
                    [break]
                }
            }
            if {$usedMem==false} {
                if {$dest < $outSymbolsPerBeat} {
                    set outputFilledByMemoryAlone false
                }
                if {($outputFilledByMemoryAlone==false) || ($dest <= $outSymbolsPerBeat)} {
                    if {$indata < $inSymbolsPerBeat} {
						  if {$endianess == "Little Endian"} {
							set little_endian [expr $inSymbolsPerBeat - $indata - 1]
						  } else {
							set little_endian [expr $indata]
						  }
                        lset dataSource $dest "a_data${little_endian}"
                        incr indata
                        set filled true
                    }
                }
            }
            if {($dest < $outSymbolsPerBeat) && ($filled == false)} {
                set enoughDataForOutput false
            }
        }
        
        if {$enoughDataForOutput==true} {
            set writeEnables {}
            for {set i 0} {$i <= $maxState} {incr i} {
                lappend writeEnables 0
            }
            
            set dest 0
            for {set out 0} {$out < $outSymbolsPerBeat} {incr out} {
                set outsymbol [expr [expr $outSymbolsPerBeat - $out] - 1]
				if {$endianess == "Little Endian"} {
					set right [expr $inBitsPerSymbol * $out]
				} else {
					set right [expr $inBitsPerSymbol * $outsymbol]
				}
				set left [expr [expr $right + $inBitsPerSymbol] -1]
                set dataSourceElem [lindex $dataSource $out]
                append retString "            b_data\[${left}:${right}\] = ${dataSourceElem};\n"
                incr dest
            }
            for {set mem 0} {$mem <= $maxState} {incr mem} {
                set dataSourceElem [lindex $dataSource $dest]
                if {($dest <= $lastDataDest) && ($dataSourceElem != "")} {
                    #TODO: Don't read from memory & write back to the same memory.
                    append retString "            mem_writedata${mem} = ${dataSourceElem};\n"
                    lset writeEnables $mem 1
                    lset hasData $mem true
                }
                incr dest
            }
            append retString "            if (out_ready || ~out_valid) begin\n"
            if {$outputFilledByMemoryAlone==false} {
                append retString "               a_ready = 1;\n"
                append retString "               if (a_valid) \n"
            }
            
            append retString "               begin\n"
            if {$state == $maxState} {
                append retString "                  new_state = 0;\n"                                 
            } else {
                append retString "                  new_state = state+1'b1;\n"                                        
            }
            append retString "                  b_valid = 1;\n"
            for {set mem 0} {$mem <= $maxState} {incr mem} {
                set writeEnablesElem [lindex $writeEnables $mem]
                if {$writeEnablesElem == 1} {
                    append retString "                  mem_write${mem} = 1;\n"
                }
                incr dest
            }
            append retString "               end\n"
            append retString "            end\n"
            
        } else {
            if {$outputFilledByMemoryAlone ==false} {
                set indata 0
                for {set mem 0} {$mem <= $maxState} {incr mem} {
                    set dest $mem
                    set dataSourceElem [lindex $dataSource $dest]
                    if {$dataSourceElem !=""} {
                        append retString "            mem_writedata${mem} = ${dataSourceElem};\n"
                        lset hasData $mem true
                    }
                }
                
                append retString "            a_ready = 1;\n"
                append retString "            if (a_valid) begin\n"
                if {$state == $maxState} {
                    append retString "               new_state = 0;\n"                                    
                } else {
                    append retString "               new_state = state+1'b1;\n"                                    
                }
                set indata 0
                for {set mem 0} {$mem <= $maxState} {incr mem} {
                    set dest $mem
                    set dataSourceElem [lindex $dataSource $dest]
                    if {$dataSourceElem !=""} {
                        append retString "               mem_write${mem} = 1;\n"
                        lset hasData $mem true
                        incr indata
                    }
                }
            }
            append retString "            end\n";
        }
        append retString  "         end\n";                  
    }
    return $retString
}


proc getNarrowToWideWithPacketsStates {inSymbolsPerBeat outSymbolsPerBeat inBitsPerSymbol} {
    set retString ""
    set decOutSymbolsPerBeat [expr $outSymbolsPerBeat -1]
    set decInSymbolsPerBeat [expr $inSymbolsPerBeat -1]

    set empty $outSymbolsPerBeat
    set maxState [getMaxState $inSymbolsPerBeat $outSymbolsPerBeat]
    set endianess        [ get_parameter_value "endianess" ]
    set hasData {}

    for {set mem 0} {$mem <= $maxState} {incr mem} {
        lappend hasData false
    }

    set lastDataDest [expr $maxState + $decOutSymbolsPerBeat]
    set dataSource {}
    for {set dest 0} {$dest <= $lastDataDest} {incr dest} {
        lappend dataSource ""
    }

    for {set state 0} {$state <= $maxState} {incr state} {

        set empty $outSymbolsPerBeat
        append retString "         ${state} : begin\n"
        for {set dest 0} {$dest <= $lastDataDest} {incr dest} {
            lset dataSource $dest ""
        }
        set outputFilledByMemoryAlone true
        set enoughDataForOutput true
        set indata 0

        #Determine the Data Source
        for {set dest 0} {$dest <= $lastDataDest} {incr dest} { 
            lset dataSource $dest ""
            set usedMem false
            set filled false
            set decMaxState [expr $maxState - 1]
            for {set mem  0} {$mem <= $decMaxState} {incr mem} {
                set checkHasData [lindex $hasData $mem]
                if {$checkHasData == true} {
                    lset dataSource $dest "mem_readdata${mem}"
                    set usedMem true
                    lset hasData $mem false
                    set filled true
                    [break]
                }
            }
            if {$usedMem == false} {
                if {$dest < $outSymbolsPerBeat} {
                    set outputFilledByMemoryAlone false
                }
                if {($outputFilledByMemoryAlone==false) || ($dest <= $outSymbolsPerBeat)} {
                    if {$indata < $inSymbolsPerBeat} {
                         if {$endianess == "Little Endian"} {
							set little_endian [expr $inSymbolsPerBeat - $indata - 1]
						  } else {
							set little_endian [expr $indata]
						  }
                        lset dataSource $dest "a_data${little_endian}"
                        incr indata
                        set filled true
                    }
                }
            }
            if {($dest < $outSymbolsPerBeat) && ($filled==false)} {
                set enoughDataForOutput false
            }
        }

        set writeEnables {}
        for {set i 0} {$i <= $maxState} {incr i} {
            lappend writeEnables 0
        }

        set writeSop false; 
        if {$enoughDataForOutput==true} {            
            set dest 0
            for {set out 0} {$out < $outSymbolsPerBeat} {incr out} {
                set outsymbol [expr [expr $outSymbolsPerBeat - $out] - 1]
                if {$endianess == "Little Endian"} {
					set right [expr $inBitsPerSymbol * $out]
				} else {
					set right [expr $inBitsPerSymbol * $outsymbol]
				}
                set left [expr [expr $right + $inBitsPerSymbol] -1]
                set dataSourceElem [lindex $dataSource $out]
                append retString "               b_data\[${left}:${right}\] = ${dataSourceElem};\n"
                incr dest
                set empty [expr $empty -1]
            }
            for {set mem 0} {$mem <= $maxState} {incr mem} {
                set dataSourceElem [lindex $dataSource $dest]
                if {($dest <= $lastDataDest) && ($dataSourceElem != "")} {
                    #TODO: Don't read from memory & write back to the same memory.
                    append retString "               mem_writedata${mem} = ${dataSourceElem};\n"
                    lset writeEnables $mem 1
                    lset hasData $mem true
                }
                incr dest
            }
            if {$empty < 0} {
                set empty [expr $empty + $outSymbolsPerBeat]
            }
        } else {
            set indata 0
            for {set mem 0} {$mem <= $maxState} {incr mem} {
                set dest $mem
                set dataSourceElem [lindex $dataSource $dest]
                if {$dataSourceElem != ""} {
                    append retString "               mem_writedata${mem} = ${dataSourceElem};\n"
                    if {($mem == 0) && ($dataSourceElem == "a_data0")} {
                        set writeSop true
                    }
                    if {$mem < $outSymbolsPerBeat} {
                         set outsymbol [expr [expr $outSymbolsPerBeat - $mem] - 1]
                        set right [expr $inBitsPerSymbol * $outsymbol]
                        set left [expr [expr $right + $inBitsPerSymbol] -1]
                        append retString "               b_data\[${left}:${right}\] = ${dataSourceElem};\n"
                        set empty [expr $empty - 1]
                    }
                    lset writeEnables $mem 1
                    lset hasData $mem true
                }
            }
        }

        if {$empty < 0} {
            set empty 0
        }
        append retString "               if (out_ready || ~out_valid) begin\n"
        append retString "                  a_ready = 1;\n"
        append retString "                  if (a_valid) \n"
        append retString "                  begin\n"
        if {$state == $maxState} {
            append retString "                     new_state = 0;\n"                                      
        } else {
            append retString "                     new_state = state+1'b1;\n"                                      
        }
        if {$enoughDataForOutput == true} {
            append retString "                     b_valid = 1;\n"
        } else {
            for {set mem 0} {$mem <= $maxState} {incr mem} {
                set writeEnablesElem [lindex $writeEnables $mem]
                if {$writeEnablesElem == 1} {
                    append retString "                     mem_write${mem} = 1;\n"
                }
            }
            if {$writeSop==true} {
                append retString "                     sop_mem_writeenable = 1;\n"
            }
            
        }
        append retString "                     if (a_endofpacket) begin\n"
        append retString "                        b_empty = a_empty+${empty};\n"
        append retString "                        b_valid = 1;\n"
        if {$state == 0} {
            append retString "                        b_startofpacket = a_startofpacket;\n"
        }
        append retString "                        new_state = 0;\n"                                       
        append retString "                     end\n"
        append retString "                  end\n"
        append retString "               end\n"
        append retString "            end\n"
    }

    return $retString
}

proc createSRAMVerilogFile {name dataWidth depth numReadPorts clrOnRST} {
    set this_dir [ get_module_property MODULE_DIRECTORY ]
    #set addrWidth [log2ceil [expr $depth -1]]
    set addrWidth [log2ceil $depth]
    set sramTemplate_file [ file join $this_dir "./lookaheadmultiportmemory.sv.terp" ] 
    set sramTemplate      [ read [ open $sramTemplate_file r ] ]    
    
    set sramParams(memName) $name
    set sramParams(dataWidth) $dataWidth
    set sramParams(addrWidth) $addrWidth
    set sramParams(numReadPorts) $numReadPorts
    set sramParams(depth) $depth
    set sramParams(clrOnRST) $clrOnRST
        
    set sramResult     [ altera_terp $sramTemplate sramParams ]
    return $sramResult
}

proc makeSRAM {name dataWidth depth numReadPorts clrOnRST} {
        #Generate SRAM
    set sramResult [createSRAMVerilogFile $name $dataWidth $depth $numReadPorts $clrOnRST]
    set sramOutputFile $name
    append sramOutputFile ".sv"
    add_fileset_file ${sramOutputFile} {SYSTEM_VERILOG} TEXT ${sramResult}
}

proc createVerilogAdapterFile {output_name} {
    set this_dir [ get_module_property MODULE_DIRECTORY ]
    set template_file [ file join $this_dir "altera_pfl2_data_format_adapter.sv.terp" ]        
    set template    [ read [ open $template_file r ] ]

    set in_symbols_per_beat    [ get_parameter_value "inSymbolsPerBeat" ]
    set out_symbols_per_beat   [ get_parameter_value "outSymbolsPerBeat" ]
    set in_use_empty           [ get_Emptyparameter_value "inUseEmptyPort" ]
    set deprecatedInUseEmpty   [ get_parameter_value "inUseEmpty"]
    set out_use_empty          [ get_Emptyparameter_value "outUseEmptyPort" ]
    set deprecatedOutUseEmpty  [ get_parameter_value "outUseEmpty"]
    set bits_per_symbol        [ get_parameter_value "inBitsPerSymbol" ]
    set use_packets            [ get_parameter_value "inUsePackets" ]
    set max_channel            [ get_parameter_value "inMaxChannel" ]
    set error_width            [ get_parameter_value "inErrorWidth" ]


    set params(output_name)      $output_name
    set params(channelWidth)     [ get_parameter_value "inChannelWidth" ]
    set params(maxChannel)       $max_channel
    set params(symbolWidth)      [ get_parameter_value "inBitsPerSymbol" ]
    set params(inSymbolsPerBeat)  $in_symbols_per_beat
    set params(outSymbolsPerBeat) $out_symbols_per_beat
    set params(inDataWidth)      [ expr $in_symbols_per_beat * $bits_per_symbol ]
    set params(outDataWidth)     [ expr $out_symbols_per_beat * $bits_per_symbol ]
    set params(inErrorWidth)     $error_width
    set params(outErrorWidth)    $error_width
    set params(usePackets)       $use_packets

    set decInSymbolsPerBeat [expr $in_symbols_per_beat - 1]
    set decOutSymbolsPerBeat [expr $out_symbols_per_beat - 1]

    set maxState [getMaxState $in_symbols_per_beat $out_symbols_per_beat]
    set params(maxState) $maxState
    set params(stateWidth) [log2ceil [expr $maxState + 1]]

    if {($in_use_empty == 2)} {
        if {($use_packets && $in_symbols_per_beat >1) || ($use_packets && ($in_symbols_per_beat==1) && $deprecatedInUseEmpty)} {
            set params(hasInEmpty)  true
            set params(inEmptyWidth)  [ log2ceil [get_parameter_value "inSymbolsPerBeat" ]]
        } else {
            set params(hasInEmpty)  false
            set params(inEmptyWidth)  0
        }
    } elseif {$use_packets && ($in_use_empty==1)} {
        set params(hasInEmpty)  true 
        set params(inEmptyWidth)  [ log2ceil [get_parameter_value "inSymbolsPerBeat" ]]     
    } else {
        set params(hasInEmpty)  false
        set params(inEmptyWidth)  0
    }

    if {($out_use_empty == 2)} {
        if {($use_packets && $out_symbols_per_beat >1) || ($use_packets && ($out_symbols_per_beat==1) && $deprecatedOutUseEmpty)} {
            set params(hasOutEmpty) true 
            set params(outEmptyWidth)  [ log2ceil [get_parameter_value "outSymbolsPerBeat" ]]
        } else {
            set params(hasOutEmpty) false
            set params(outEmptyWidth)  0
        }
    } elseif {$use_packets && ($out_use_empty==1)} {
        set params(hasOutEmpty)  true
        set params(outEmptyWidth)  [ log2ceil [get_parameter_value "outSymbolsPerBeat" ]]     
    } else {
        set params(hasOutEmpty)  false
        set params(outEmptyWidth)  0
    }

    set num_mem_symbols [expr $out_symbols_per_beat - 1 ]
    if { $in_symbols_per_beat > $out_symbols_per_beat} {
        set num_mem_symbols [expr $in_symbols_per_beat - 1 ]
    }
    set output_data_width [expr $out_symbols_per_beat * $bits_per_symbol ]
    if {$num_mem_symbols == 0} {
        set num_mem_symbols 1
    }
    set params(numMemSymbols) $num_mem_symbols

    set stateString ""
    if {$in_symbols_per_beat < $out_symbols_per_beat} {
        if {$use_packets} {
            set stateString [getNarrowToWideWithPacketsStates $in_symbols_per_beat $out_symbols_per_beat $bits_per_symbol]
        } else {
            set stateString [getNarrowToWideStates $in_symbols_per_beat $out_symbols_per_beat $bits_per_symbol]
        }
    } else {
        set stateString [getWideToNarrowStates $in_symbols_per_beat $out_symbols_per_beat $bits_per_symbol]
    }
    set params(stateString) $stateString

    set result          [ altera_terp $template params ]
    return $result
}

proc generate {output_name} {
    set result [createVerilogAdapterFile $output_name]
    set output_file     $output_name
    append output_file ".sv"

    add_fileset_file ${output_file} {SYSTEM_VERILOG} TEXT ${result}

    #### GENERATE LOOKAHEAD MEMORIES  
    set in_symbols_per_beat    [ get_parameter_value "inSymbolsPerBeat" ]
    set out_symbols_per_beat   [ get_parameter_value "outSymbolsPerBeat" ]
    set maxState [getMaxState $in_symbols_per_beat $out_symbols_per_beat]
    set max_channel            [ get_parameter_value "inMaxChannel" ]
    set bits_per_symbol        [ get_parameter_value "inBitsPerSymbol" ]
    set error_width            [ get_parameter_value "inErrorWidth" ]
    set use_packets            [ get_parameter_value "inUsePackets" ]

    if {$in_symbols_per_beat != $out_symbols_per_beat} {

        set stateRamName "${output_name}_state_ram"
        set stateRamDataWidth [ log2ceil [expr $maxState + 1] ]
        set stateDepth [expr $max_channel + 1]
        set stateNumReadPorts 1
        set stateClrOnRST 1
        makeSRAM $stateRamName $stateRamDataWidth $stateDepth $stateNumReadPorts $stateClrOnRST

        set dataRamName "${output_name}_data_ram"
        set dataRamDataWidth $bits_per_symbol
        set dataDepth [expr $max_channel + 1]
        set dataNumReadPorts 1
        set dataClrOnRST 0
        makeSRAM $dataRamName $dataRamDataWidth $dataDepth $dataNumReadPorts $dataClrOnRST
    }

    if {$use_packets && ($in_symbols_per_beat < $out_symbols_per_beat)} {
        set sopRamName "${output_name}_sop_ram"
        set sopRamDataWidth 1
        set sopDepth [expr $max_channel + 1]
        set sopNumReadPorts 1
        set sopClrOnRST 0
        makeSRAM $sopRamName $sopRamDataWidth $sopDepth $sopNumReadPorts $sopClrOnRST
    }

    if {($error_width > 0) && ($in_symbols_per_beat < $out_symbols_per_beat)} {
        set errorRamName "${output_name}_error_ram"
        set errorRamDataWidth $error_width
        set errorDepth [expr $max_channel + 1]
        set errorNumReadPorts 1
        set errorClrOnRST 0
        makeSRAM $errorRamName $errorRamDataWidth $errorDepth $errorNumReadPorts $errorClrOnRST
    }

}

proc upgrade { kind, verion, parameters } {
    source ./AtlanticCommonValidation.tcl
    array set parmList [makeUpgradeList $parameters]

    set_parameter_value inChannelWidth     $parmList(inChannelWidth)
    set_parameter_value inMaxChannel       $parmList(inMaxChannel)
    set_parameter_value inBitsPerSymbol    $parmList(inBitsPerSymbol)
    set_parameter_value inUsePackets       $parmList(inUsePackets)
    set_parameter_value inUseEmptyPort     $parmList(inUseEmptyPort)
    set_parameter_value inUseEmpty         $parmList(inUseEmpty)
    set_parameter_value outUseEmptyPort    $parmList(outUseEmptyPort)
    set_parameter_value outUseEmpty        $parmList(outUseEmpty)
    set_parameter_value inSymbolsPerBeat   $parmList(inSymbolsPerBeat)
    set_parameter_value outSymbolsPerBeat  $parmList(outSymbolsPerBeat)
    set_parameter_value inReadyLatency     $parmList(inReadyLatency)
    set_parameter_value inErrorWidth       $parmList(inErrorWidth)
    set_parameter_value inErrorDescriptor  $parmList(inErrorDescriptor)
}


proc elaborate {} {
    source ./AtlanticCommonValidation.tcl
    set in_symbols_per_beat   [ get_parameter_value "inSymbolsPerBeat" ]
    set out_symbols_per_beat  [ get_parameter_value "outSymbolsPerBeat" ]
    set bits_per_symbol       [ get_parameter_value "inBitsPerSymbol" ]
    set in_data_width         [ expr $in_symbols_per_beat * $bits_per_symbol ]
    set out_data_width        [ expr $out_symbols_per_beat * $bits_per_symbol ]

    set channel_width      [ get_parameter_value "inChannelWidth" ]
    set max_channel        [ get_parameter_value "inMaxChannel" ]
    set use_packets        [ get_parameter_value "inUsePackets" ]
    set in_use_empty           [ get_Emptyparameter_value "inUseEmptyPort" ]
    set deprecatedInUseEmpty   [ get_parameter_value "inUseEmpty"]
    set out_use_empty          [ get_Emptyparameter_value "outUseEmptyPort" ]
    set deprecatedOutUseEmpty  [ get_parameter_value "outUseEmpty"]
    set ready_latency      [ get_parameter_value "inReadyLatency" ]
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
    add_interface_port "in" "in_data" "data" "input" $in_data_width
    add_interface_port "in" "in_valid" "valid" "input" 1
    add_interface_port "in" "in_ready" "ready" "output" 1
    set_interface_property "in" "symbolsPerBeat" $in_symbols_per_beat
    set_interface_property "in" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "in" "readyLatency" $ready_latency
    set_interface_property "in" "maxChannel" $max_channel
    set_interface_property "in" "errorDescriptor" $error_description

    # Avalon-ST source interface
    add_interface "out" "avalon_streaming" "source" "clk"
    add_interface_port "out" "out_data" "data" "output" $out_data_width
    add_interface_port "out" "out_valid" "valid" "output" 1
    add_interface_port "out" "out_ready" "ready" "input" 1
    set_interface_property "out" "symbolsPerBeat" $out_symbols_per_beat
    set_interface_property "out" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "out" "readyLatency" $ready_latency 
    set_interface_property "out" "maxChannel" $max_channel
    set_interface_property "out" "errorDescriptor" $error_description
    
    if {$use_packets } {
        set_parameter_property inUseEmptyPort ENABLED true
        set_parameter_property outUseEmptyPort ENABLED true
        add_interface_port "in" "in_startofpacket" "startofpacket" "input" 1
        add_interface_port "in" "in_endofpacket" "endofpacket" "input" 1
        add_interface_port "out" "out_startofpacket" "startofpacket" "output" 1
        add_interface_port "out" "out_endofpacket" "endofpacket" "output" 1

        if {($in_use_empty == 2)} {
            if {($in_symbols_per_beat >1) || (($in_symbols_per_beat==1) && $deprecatedInUseEmpty)} {
                add_interface_port "in" "in_empty" "empty" "input" 1
                set in_empty_width [ log2ceil $in_symbols_per_beat ] 
                set_port_property in_empty WIDTH_EXPR $in_empty_width
            } 
        } elseif {$in_use_empty==1} {
            add_interface_port "in" "in_empty" "empty" "input" 1
            set in_empty_width [ log2ceil $in_symbols_per_beat ] 
            set_port_property in_empty WIDTH_EXPR $in_empty_width
        }        

        if {($out_use_empty == 2)} {
            if {($out_symbols_per_beat >1) || (($out_symbols_per_beat==1) && $deprecatedOutUseEmpty)} {
                add_interface_port "out" "out_empty" "empty" "output" 1
                set out_empty_width [ log2ceil $out_symbols_per_beat ] 
                set_port_property out_empty WIDTH_EXPR $out_empty_width
            } 
        } elseif {$out_use_empty==1} {
            add_interface_port "out" "out_empty" "empty" "output" 1
            set out_empty_width [ log2ceil $out_symbols_per_beat ] 
            set_port_property out_empty WIDTH_EXPR $out_empty_width
        }        

    } else {
        set_parameter_property inUseEmptyPort ENABLED false
        set_parameter_property outUseEmptyPort ENABLED false
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
    } 

    validate    
}



## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409958828732
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
