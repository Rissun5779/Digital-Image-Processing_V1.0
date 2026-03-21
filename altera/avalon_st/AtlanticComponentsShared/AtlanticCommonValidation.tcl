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


proc prepend {s_var txt} {
  upvar 1 $s_var s
    set s "${txt}${s}"
}

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

proc makeUpgradeList {parameters} {
    set i 0
    set key ""
    set value ""
    array set parmList []

    foreach list $parameters {
        if {$i == 0} {
            set key $list
            set i 1
        } elseif {$i == 1} {            
            set value $list
            set parmList($key) $value
            set i 0
        }       
    }

    return [array get parmList]
}

proc get_Emptyparameter_value {port} {
    set emptySetting [get_parameter_value $port]
    switch -- $emptySetting {
        "NO" {
            return 0
        }
        "YES" {
            return 1
        }
        "AUTO" {
            return 2
        }
        default {
            #illegal value on purpose to fail validation
            return 3
        }
    }
}


proc validate_requiredSignals {ifaceName ifaceUserString} {
    set ports [ get_interface_ports $ifaceName ]
    set sop "_startofpacket"
    set eop "_endofpacket"
    set empty "_empty"
    prepend sop $ifaceName
    prepend eop $ifaceName
    prepend empty $ifaceName

    if { [ lsearch $ports $sop ]   != -1 ||
         [ lsearch $ports $eop ]   != -1 ||
         [ lsearch $ports $empty ] != -1} {
        if { [ lsearch $ports $sop ] == -1} {
            send_message error "No startofpacket port found on $ifaceUserString Interface in the presence of endofpacket or empty port."
        } 
        if { [ lsearch $ports $eop ] == -1} {
            send_message error "No endofpacket port found on $ifaceUserString Interface in the presence of startofpacket or empty port."
        }
    }         
}

proc validate_dataWidth {symbolsPerBeat dataBitsPerSymbol dataWidth ifaceUserString} {
    global maxNumberSymbols
    if {$symbolsPerBeat == 0 } {
        send_message error "Symbols Per Beat must be non-zero."
    } elseif {$dataBitsPerSymbol == 0 } {
        send_message error "Data Bits Per Symbol must be non-zero."
    } else { 
        set divisor [ expr {$dataBitsPerSymbol * $symbolsPerBeat} ]
        set numSymbols [ expr {$dataWidth / $divisor} ]
        if { $dataWidth % $divisor != 0 } {
            send_message error "Bit width of data port for $ifaceUserString interface ($dataWidth) is less than bits per symbol($dataBitsPerSymbol) * symbols per beat($symbolsPerBeat)."
        }
        if { $numSymbols > $maxNumberSymbols } {
            send_message error "Number of symbols on $ifaceUserString interface per transfer is larger than maximum number of symbols ($maxNumberSymbols)."
        } 
    }
}

proc validate_emptyWidth {symbolsPerBeat dataBitsPerSymbol dataWidth use_empty use_packets emptyPort beatsPerCycle deprecatedUseEmpty} {
    global maxNumberSymbols
    if {$symbolsPerBeat == 0 } {
        send_message error "Symbols Per Beat must be non-zero."
    } elseif {$dataBitsPerSymbol == 0 } {
        send_message error "Data Bits Per Symbol must be non-zero."
    } else { 
        set divisor [ expr {$dataBitsPerSymbol * $symbolsPerBeat} ]
        set numSymbols [ expr {$dataWidth / $divisor} ]

        if {$use_packets} {
            if {($use_empty == 2)} {
                if {($symbolsPerBeat >1) || (($symbolsPerBeat==1) && $deprecatedUseEmpty)} {             
                    set emptyWidth [ get_port_property $emptyPort WIDTH_EXPR ]
                    if {$numSymbols!=1} { #multiple beats per cycle
                        set expectedEmptyWidth [ log2ceil [expr [expr $numSymbols-1] * $beatsPerCycle] ]
                    } else {
                        set expectedEmptyWidth [ log2ceil $symbolsPerBeat ]
                    }       
                    
                    if { $emptyWidth != $expectedEmptyWidth } {
                        send_message error "Bit width of empty port on $ifaceUserString interface($emptyWidth) does not match expected width ($expectedEmptyWidth)."
                    }                 
                }
            } elseif {$use_empty==1} {
                set emptyWidth [ get_port_property $emptyPort WIDTH_EXPR ]
                if {$numSymbols!=1} { #multiple beats per cycle
                    set expectedEmptyWidth [ log2ceil [expr [expr $numSymbols-1] * $beatsPerCycle] ]
                } else {
                    set expectedEmptyWidth [ log2ceil $symbolsPerBeat ]
                }       
                
                if { $emptyWidth != $expectedEmptyWidth } {
                    send_message error "Bit width of empty port on $ifaceUserString interface($emptyWidth) does not match expected width ($expectedEmptyWidth)."
                }                 
            }
        } 
    }    
}

proc validate_dataAndEmptyWidths {dataPort emptyPort beatsPerCycle ifaceName ifaceUserString} {    
    set use_empty            [ get_Emptyparameter_value "inUseEmptyPort" ]
    set use_packets          [ get_parameter_value "inUsePackets" ]
    set dataWidth            [ get_port_property $dataPort WIDTH_EXPR ]
    set dataBitsPerSymbol    [ get_interface_property "$ifaceName" "dataBitsPerSymbol" ]
    set symbolsPerBeat       [ get_interface_property "$ifaceName" "symbolsPerBeat" ]
    set deprecatedInUseEmpty [ get_parameter_value "inUseEmpty"]

    validate_dataWidth $symbolsPerBeat $dataBitsPerSymbol $dataWidth $ifaceUserString
    validate_emptyWidth $symbolsPerBeat $dataBitsPerSymbol $dataWidth $use_empty $use_packets $emptyPort $beatsPerCycle $deprecatedInUseEmpty
    # if {$symbolsPerBeat == 0 } {
    #     send_message error "Symbols Per Beat must be non-zero."
    # } elseif {$dataBitsPerSymbol == 0 } {
    #     send_message error "Data Bits Per Symbol must be non-zero."
    # } else { 
    #     set divisor [ expr {$dataBitsPerSymbol * $symbolsPerBeat} ]
    #     set numSymbols [ expr {$dataWidth / $divisor} ]
    #     if { $dataWidth % $divisor != 0 } {
    #         send_message error "Bit width of data port for $ifaceUserString interface ($dataWidth) is less than bits per symbol($dataBitsPerSymbol) * symbols per beat($symbolsPerBeat)."
    #     }
    #     if { $numSymbols > $maxNumberSymbols } {
    #         send_message error "Number of symbols on $ifaceUserString interface per transfer is larger than maximum number of symbols ($maxNumberSymbols)."
    #     } 

    #     if { $use_empty !=0 && $use_packets && ($symbolsPerBeat >1)} {
    #         set emptyWidth [ get_port_property $emptyPort WIDTH_EXPR ]
    #         if {$numSymbols!=1} { #multiple beats per cycle
    #             set expectedEmptyWidth [ log2ceil [expr [expr $numSymbols-1] * $beatsPerCycle] ]
    #         } else {
    #             set expectedEmptyWidth [ log2ceil $symbolsPerBeat ]
    #         }       

    #         if { $emptyWidth != $expectedEmptyWidth } {
    #             send_message error "Bit width of empty port on $ifaceUserString interface($emptyWidth) does not match expected width ($expectedEmptyWidth)."
    #         } 
    #     }    
    # }
}


proc validate_SoP_EoP_Valid_Widths {sopPort eopPort validPort beatsPerCycle ifaceUserString} {
    set use_packets [ get_parameter_value "inUsePackets" ]
    if {$use_packets} {
        set sopWidth [get_port_property $sopPort WIDTH_EXPR ]
        set eopWidth [get_port_property $eopPort WIDTH_EXPR ]
        set validWidth [get_port_property $validPort WIDTH_EXPR ]
        if { $sopWidth != $beatsPerCycle } {
            send_message error "$ifaceUserString interface start of packet port width($sopWidth) does not equal beats per cycle ($beatsPerCycle)."
        }
        if { $eopWidth != $beatsPerCycle } {
            send_message error "$ifaceUserString interface end of packet port width($eopWidth) does not equal beats per cycle ($beatsPerCycle)."
        }
        if { $validWidth != $beatsPerCycle } {
            send_message error "$ifaceUserString interface valid port width($validWidth) does not equal beats per cycle ($beatsPerCycle)."
        }
    }
}

proc validate_ChannelWidth {iface channelPort beatsPerCycle ifaceUserString} {
    global maxNumberSymbols
    set channelWidth [ get_parameter_value "inChannelWidth" ]
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



proc validate_ErrorWidth {errorPort beatsPerCycle ifaceUserString} {
    global maxNumberSymbols
    set error_width [ get_parameter_value "inErrorWidth" ]

    if {$error_width > 0} {
        set portErrorWidth [ get_port_property $errorPort WIDTH_EXPR]
        if { $portErrorWidth % $beatsPerCycle != 0 } {
            send_message error "$ifaceUserString interface error port width($portErrorWidth) is not a multiple of beats per cycle($beatsPerCycle)."
        }
    }    
}
