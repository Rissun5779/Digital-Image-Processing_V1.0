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




# +-----------------------------------
# | Module Parameters
# |

proc add_module_parametersRSDESIGN {} {
add_parameter RSDESIGN INTEGER 0
set_parameter_property RSDESIGN DISPLAY_NAME "Reed-Solomon core"
set_parameter_property RSDESIGN DESCRIPTION "Choose your design"
set_parameter_property RSDESIGN ALLOWED_RANGES {0:Custom 1:Fracturable\ 100G\ Ethernet}
set_parameter_property RSDESIGN GROUP "Reed-Solomon"
}

proc add_module_parametersRS {} {
add_parameter RS string "Decoder"
set_parameter_property RS DISPLAY_NAME "Reed-Solomon module"
set_parameter_property RS DESCRIPTION "Encoder or Decoder"
set_parameter_property RS ALLOWED_RANGES {"Encoder" "Decoder"}
set_parameter_property RS GROUP "Reed-Solomon"
}

proc add_module_parametersCHANNEL {} {
add_parameter CHANNEL INTEGER 1
set_parameter_property CHANNEL DISPLAY_NAME "Number of channels"
set_parameter_property CHANNEL ENABLED true
set_parameter_property CHANNEL DESCRIPTION "Number of channels."
set_parameter_property CHANNEL HDL_PARAMETER true
set_parameter_property CHANNEL GROUP "Parameters"
}

proc add_module_parametersFRACMODES {} {
add_parameter ONE_CHANNEL INTEGER 1
set_parameter_property ONE_CHANNEL DISPLAY_NAME "1 x 100G Ethernet"
set_parameter_property ONE_CHANNEL DISPLAY_HINT boolean
set_parameter_property ONE_CHANNEL ENABLED false
set_parameter_property ONE_CHANNEL DESCRIPTION "A single independent 100G channels with parallelism 4p."
set_parameter_property ONE_CHANNEL HDL_PARAMETER false
set_parameter_property ONE_CHANNEL GROUP "Parameters"

add_parameter TWO_CHANNELS INTEGER 1
set_parameter_property TWO_CHANNELS DISPLAY_NAME "2 x 50G Ethernet"
set_parameter_property TWO_CHANNELS DISPLAY_HINT boolean
set_parameter_property TWO_CHANNELS DESCRIPTION "Two independent 50G channels with parallelism 2p."
set_parameter_property TWO_CHANNELS HDL_PARAMETER false
set_parameter_property TWO_CHANNELS GROUP "Parameters"

add_parameter FOUR_CHANNELS INTEGER 1
set_parameter_property FOUR_CHANNELS DISPLAY_NAME "4 x 25G Ethernet"
set_parameter_property FOUR_CHANNELS DISPLAY_HINT boolean
set_parameter_property FOUR_CHANNELS DESCRIPTION "Four independent 25G channels with parallelism p."
set_parameter_property FOUR_CHANNELS HDL_PARAMETER false
set_parameter_property FOUR_CHANNELS GROUP "Parameters"
}


proc add_module_parametersN {} {
add_parameter N INTEGER 255
set_parameter_property N DISPLAY_NAME "Number of symbols per codeword"
set_parameter_property N ENABLED true
set_parameter_property N DESCRIPTION "Number of symbols per codeword."
set_parameter_property N HDL_PARAMETER true
set_parameter_property N GROUP "Parameters"
}
proc add_module_parametersM {} {
add_parameter  BITSPERSYMBOL INTEGER 8
set_parameter_property BITSPERSYMBOL DISPLAY_NAME "Number of bits per symbol"
set_parameter_property BITSPERSYMBOL ENABLED true
set_parameter_property BITSPERSYMBOL DESCRIPTION "Total number of bits per symbol."
set_parameter_property BITSPERSYMBOL HDL_PARAMETER true
set_parameter_property BITSPERSYMBOL GROUP "Parameters"
}

proc add_module_parametersK {} {
add_parameter K INTEGER 239
set_parameter_property K DISPLAY_NAME "Number of data symbols per codeword"
set_parameter_property K ENABLED true
set_parameter_property K DESCRIPTION "Number of data symbols per codeword."
set_parameter_property K GROUP "Parameters"
}

proc add_module_parametersCHECK {} {
add_parameter CHECK INTEGER 16
set_parameter_property CHECK DISPLAY_NAME "Number of parity symbols per codeword"
set_parameter_property CHECK ENABLED true
set_parameter_property CHECK DESCRIPTION "Number of parity symbols per codeword."
set_parameter_property CHECK VISIBLE false
set_parameter_property CHECK HDL_PARAMETER true
set_parameter_property CHECK GROUP "Parameters"
}

proc add_module_parametersIRRPOL {} {
add_parameter IRRPOL INTEGER 285 
set_parameter_property IRRPOL DISPLAY_NAME "Field polynomial"
set_parameter_property IRRPOL ENABLED true
set_parameter_property IRRPOL DESCRIPTION "Specifies the field primitive polynomial."
set_parameter_property IRRPOL HDL_PARAMETER true
set_parameter_property IRRPOL GROUP "Parameters"
}

proc add_module_parametersPAR {} {
add_parameter PAR INTEGER 3 
set_parameter_property PAR DISPLAY_NAME "Parallelism"
set_parameter_property PAR ENABLED true
set_parameter_property PAR DESCRIPTION "Specifies the parallelism order."
set_parameter_property PAR HDL_PARAMETER true
set_parameter_property PAR GROUP "Parameters"
}

proc add_module_parametersBMSPEED {} {
add_parameter BMSPEED INTEGER 4 
set_parameter_property BMSPEED DISPLAY_NAME "Latency"
set_parameter_property BMSPEED ENABLED true
set_parameter_property BMSPEED DESCRIPTION "Latency of the core. Larger latency may result in higher resource count and larger Fmax"
set_parameter_property BMSPEED HDL_PARAMETER true
set_parameter_property BMSPEED GROUP "Parameters"
}

proc add_module_parametersUSERAM {} {
add_parameter USERAM INTEGER 1 
set_parameter_property USERAM DISPLAY_NAME "Favor ROM usage"
set_parameter_property USERAM ENABLED true
set_parameter_property USERAM DESCRIPTION "This option allows the user to trade memory ALMs for M20Ks. It is particularly effective when the parallelism is large."
set_parameter_property USERAM HDL_PARAMETER true
set_parameter_property USERAM ALLOWED_RANGES {0:No 1:Yes}
set_parameter_property USERAM GROUP "Parameters"

add_parameter USETRUEDUALRAM INTEGER 1 
set_parameter_property USETRUEDUALRAM DISPLAY_NAME "Use true dual port"
set_parameter_property USETRUEDUALRAM ENABLED true
set_parameter_property USETRUEDUALRAM DESCRIPTION "M20K are instantiated as true dual port RAMs"
set_parameter_property USETRUEDUALRAM HDL_PARAMETER true
#set_parameter_property USETRUEDUALRAM DISPLAY_HINT boolean
set_parameter_property USETRUEDUALRAM ALLOWED_RANGES {0:No 1:Yes}
set_parameter_property USETRUEDUALRAM GROUP "Parameters"

add_parameter USEECCFORRAM INTEGER 0 
set_parameter_property USEECCFORRAM DISPLAY_NAME "Refresh ROM content"
set_parameter_property USEECCFORRAM ENABLED true
set_parameter_property USEECCFORRAM DESCRIPTION "Content of the ROMs are continuously rewritten"
set_parameter_property USEECCFORRAM HDL_PARAMETER true
#set_parameter_property USEECCFORRAM DISPLAY_HINT boolean
set_parameter_property USEECCFORRAM ALLOWED_RANGES {0:No 1:Yes}
set_parameter_property USEECCFORRAM GROUP "Parameters"
}

proc add_module_parametersUSEBKP {} {
add_parameter USE_BKP INTEGER 0 
set_parameter_property USE_BKP DISPLAY_NAME "Backpressure"
set_parameter_property USE_BKP ENABLED true
set_parameter_property USE_BKP DESCRIPTION "use the out_ready signal to assert when the source is ready"
set_parameter_property USE_BKP HDL_PARAMETER true
set_parameter_property USE_BKP ALLOWED_RANGES {0:No 1:Yes}
set_parameter_property USE_BKP GROUP "Parameters"
}

proc add_module_parametersUSEBYPASS {} {
add_parameter USE_BYPASS INTEGER 0 
set_parameter_property USE_BYPASS DISPLAY_NAME "Allow by-pass mode"
set_parameter_property USE_BYPASS ENABLED true
set_parameter_property USE_BYPASS DESCRIPTION "User can specify for each codeword if it will be output without correction and only error dectection"
set_parameter_property USE_BYPASS HDL_PARAMETER true
set_parameter_property USE_BYPASS ALLOWED_RANGES {0:No 1:Yes}
set_parameter_property USE_BYPASS GROUP "Parameters"

add_parameter USE_SYNC INTEGER 0 
set_parameter_property USE_SYNC DISPLAY_NAME "Use sync in signal"
set_parameter_property USE_SYNC ENABLED true
set_parameter_property USE_SYNC DESCRIPTION "User can start a new codeword at any time by asserting the in_sop signal "
set_parameter_property USE_SYNC HDL_PARAMETER true
set_parameter_property USE_SYNC ALLOWED_RANGES {0:No 1:Yes}
set_parameter_property USE_SYNC GROUP "Parameters"
}

proc add_module_parametersDECODEROUTPUT {} {

add_parameter USE_SOPEOP INTEGER 1 
set_parameter_property USE_SOPEOP DISPLAY_NAME "Start and end of packet"
set_parameter_property USE_SOPEOP DISPLAY_HINT boolean
set_parameter_property USE_SOPEOP DESCRIPTION "Decoder returns start-of-packet and end-of-packet signals"
set_parameter_property USE_SOPEOP HDL_PARAMETER false
set_parameter_property USE_SOPEOP GROUP "Decoder output signal options"

add_parameter USE_DECFAIL INTEGER 1 
set_parameter_property USE_DECFAIL DISPLAY_NAME "Decoding failure"
set_parameter_property USE_DECFAIL DISPLAY_HINT boolean
set_parameter_property USE_DECFAIL DESCRIPTION "Decoder returns an error if the decoding fails (valid at eop)"
set_parameter_property USE_DECFAIL HDL_PARAMETER false
set_parameter_property USE_DECFAIL GROUP "Decoder output signal options"

add_parameter USE_NBERROR INTEGER 1 
set_parameter_property USE_NBERROR DISPLAY_NAME "Error symbol count"
set_parameter_property USE_NBERROR DISPLAY_HINT boolean
set_parameter_property USE_NBERROR DESCRIPTION "Decoder returns the number of erroneous symbols per codeword (valid when decoding is succesful)"
set_parameter_property USE_NBERROR HDL_PARAMETER false
set_parameter_property USE_NBERROR GROUP "Decoder output signal options"

add_parameter USE_ERRORVALUE INTEGER 0 
set_parameter_property USE_ERRORVALUE DISPLAY_NAME "Error symbol values"
set_parameter_property USE_ERRORVALUE DISPLAY_HINT boolean
set_parameter_property USE_ERRORVALUE DESCRIPTION "Decoder returns the erroneous symbols"
set_parameter_property USE_ERRORVALUE HDL_PARAMETER false
set_parameter_property USE_ERRORVALUE GROUP "Decoder output signal options"



}

# ---------------------------------------------------------

proc add_module_parametersDEC {} {
    add_module_parametersM
    add_module_parametersCHANNEL
    add_module_parametersN
    add_module_parametersCHECK
    add_module_parametersIRRPOL
    add_module_parametersPAR
    add_module_parametersBMSPEED
    add_module_parametersUSERAM
    add_module_parametersUSEBKP
    add_module_parametersUSEBYPASS
    add_module_parametersDECODEROUTPUT
}

proc add_module_parametersDEC_FRAC421 {} {
    add_module_parametersFRACMODES
    add_module_parametersPAR
    add_module_parametersBMSPEED
    add_module_parametersUSERAM
    add_module_parametersUSEBKP
    add_module_parametersDECODEROUTPUT
}

proc add_module_parametersENC {} {
    add_module_parametersM
    add_module_parametersN
    add_module_parametersCHECK
    add_module_parametersIRRPOL
    add_module_parametersPAR
    add_module_parametersUSEBKP
}


proc add_module_parametersTOP {} {
    add_module_parametersRSDESIGN
    add_module_parametersRS
    add_module_parametersCHANNEL
    add_module_parametersFRACMODES
    add_module_parametersM
    add_module_parametersN
    add_module_parametersK
    add_module_parametersIRRPOL
    add_module_parametersPAR
    add_module_parametersBMSPEED
    add_module_parametersUSERAM
    add_module_parametersUSEBKP
    add_module_parametersUSEBYPASS
    add_module_parametersDECODEROUTPUT
}

# |
# +-----------------------------------

# +-----------------------------------
# | Parameter allowed values
# |

proc validateTOP {} {
    set rs_design           [ get_parameter_value RSDESIGN ]
    set rs                  [ get_parameter_value RS ]
    set n                   [ get_parameter_value N ]
    set channel             [ get_parameter_value CHANNEL ]
    set k                   [ get_parameter_value K ]
    set par                 [ get_parameter_value PAR ]
    set bitspersymbol       [ get_parameter_value BITSPERSYMBOL ]
    set bm_speed            [ get_parameter_value BMSPEED]
    set useram              [ get_parameter_value USERAM]
    set use_bypass          [ get_parameter_value USE_BYPASS]
    set use_sync            [ get_parameter_value USE_SYNC]

    set use_advanced_param  1
    
    if {$channel==1} {set multiple_channel 0} else {set multiple_channel 1}
    set check   [expr $n-$k]
    
    # Validate value for CHANNEL 
    set valid_channel_list [list ]
    set_parameter_property CHANNEL ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10}
    if {$rs=="Encoder" || $rs_design==1} {
        set_parameter_property CHANNEL VISIBLE false
    } else {
        set_parameter_property CHANNEL VISIBLE true
    }

    # Validate value for BITPERSYMBOL 
    set_parameter_property BITSPERSYMBOL ALLOWED_RANGES {3 4 5 6 7 8 9 10 11 12}
    if {$rs_design==1} {
        set_parameter_property BITSPERSYMBOL VISIBLE false
    } else {
        set_parameter_property BITSPERSYMBOL VISIBLE true
    }
    
    
    # Validate value for CHECK
    set min_k 2
    set max_k [expr $n-2]
    if { $k<$min_k || $k>$max_k } {
         send_message error "Number of data symbols per codeword is out of range \{$min_k-$max_k\}"
    }
    # Validate value for IRRPOLY
    set_parameter_property IRRPOL ALLOWED_RANGES [get_irrpol_allowed_range $bitspersymbol]
    if {$rs_design==1} {
        set_parameter_property IRRPOL VISIBLE false
    } else {
        set_parameter_property IRRPOL VISIBLE true
    }
    
    # Validate value for N
    set min_default_N [expr $check+1 ] 
    set max_default_N [expr int(pow(2,$bitspersymbol))-1] 
    if { $n<$min_default_N || $n>$max_default_N } {
        send_message error "Number of symbols per codeword is out of range \{$min_default_N-$max_default_N \}"
    }
    if {$rs_design==1} {
        set_parameter_property N VISIBLE false
        set_parameter_property K VISIBLE false
    } else {
        set_parameter_property N VISIBLE true
        set_parameter_property K VISIBLE true
    }
    
    # Validate value for PAR
    set valid_par_list [list]
    if {$rs=="Encoder"} {
        set ini_par 2    
        for {set i $ini_par} {$i < [expr ($n>>1)+1]} {incr i 1} {
            lappend valid_par_list $i
        }
    } else {
        set ini_par 2
        for {set i $ini_par} {$i < [expr $n+1]} {incr i 1} {
            if {$rs=="Decoder"} {
                if {[expr 2*$channel]<= [expr int($n/$i)]} {lappend valid_par_list $i}
            } else {
                lappend valid_par_list $i;
            }
        }
    }    
        
    if {[llength $valid_par_list] == 0} {
        set_parameter_property PAR ALLOWED_RANGES [list [ get_parameter_value PAR ]]
        send_message error "The core cannot generate the current parametrization (pick another codeword length or number of channels)"
    } else {
        set_parameter_property PAR ALLOWED_RANGES $valid_par_list   
    }
    if {$rs_design==1} {
        set_parameter_property PAR VISIBLE false
    } else {
        set_parameter_property PAR VISIBLE true
    }
    
    # Validate value for BMSPEED
    if {$multiple_channel || $use_bypass} {
        set syndrome_time [expr $n/$par + 3 + $use_bypass + 1]
    } else {
        set syndrome_time [expr $n/$par + 3]
    }
    set omega_time    4
    set latency_bm1 [expr $syndrome_time + (1*$check)*$channel             + $multiple_channel*$channel+8]
    set latency_bm2 [expr $syndrome_time + (2*$check)*$channel             + $multiple_channel*$channel+8]
    set latency_bm4 [expr $syndrome_time + (4*$check+$omega_time)*$channel + $multiple_channel*$channel+8]
    set latency_bm6 [expr $syndrome_time + (6*$check+$omega_time)*$channel + $multiple_channel*$channel+8]
    
    if {$rs=="Decoder"} {
        set_parameter_property BMSPEED VISIBLE true

        if {[expr int($n/$par)]<(6/2)} {
            set bmspeed_valid_list [list 1:$latency_bm1\ clock\ cycles 2:$latency_bm2\ clock\ cycles 4:$latency_bm4\ clock\ cycles]
        } else {
            set bmspeed_valid_list [list 1:$latency_bm1\ clock\ cycles 2:$latency_bm2\ clock\ cycles 4:$latency_bm4\ clock\ cycles 6:$latency_bm6\ clock\ cycles]
        }    

    } else {
        set_parameter_property BMSPEED VISIBLE false
        set bmspeed_valid_list [list $bm_speed]
    }
    set_parameter_property BMSPEED ALLOWED_RANGES $bmspeed_valid_list
  
    # Validate value for USERAM
    if {$rs=="Encoder"} {
        set_parameter_property USERAM VISIBLE false
    } else {
        set_parameter_property USERAM VISIBLE true
    }

    set_parameter_property USEECCFORRAM VISIBLE false
    set_parameter_property USETRUEDUALRAM VISIBLE false
    if {$use_advanced_param} {
        if {$rs=="Encoder"} {
            set_parameter_property USEECCFORRAM VISIBLE false
            set_parameter_property USETRUEDUALRAM VISIBLE false
        } else {
            if {$useram==1} {
                set_parameter_property USEECCFORRAM VISIBLE true
                set_parameter_property USETRUEDUALRAM VISIBLE true
            } else {
                set_parameter_property USEECCFORRAM VISIBLE false
                set_parameter_property USETRUEDUALRAM VISIBLE false
            }
        }
    }
    
    # Validate value for USE_BYPASS
    if {$rs=="Encoder" || $rs_design==1} {
        set_parameter_property USE_BYPASS VISIBLE false
    } else {
        set_parameter_property USE_BYPASS VISIBLE true
    }

    # Validate value for USE_SYNC
    if {$rs=="Encoder" || $rs_design==1 || $use_bypass==1 || $multiple_channel==1} {
        set_parameter_property USE_SYNC VISIBLE false
    } else {
        set_parameter_property USE_SYNC VISIBLE true
    }
    
    # Validate value for DECODER OUTPUT
    if {$rs=="Encoder"} {
        set_parameter_property USE_DECFAIL VISIBLE false
        set_parameter_property USE_NBERROR VISIBLE false
        set_parameter_property USE_SOPEOP VISIBLE false
        set_parameter_property USE_ERRORVALUE VISIBLE false
    } else {
        set_parameter_property USE_NBERROR VISIBLE true
        set_parameter_property USE_SOPEOP VISIBLE true
        set_parameter_property USE_ERRORVALUE VISIBLE true

        if { $par>192 } {
            set_parameter_property USE_DECFAIL VISIBLE false
        } else {
            set_parameter_property USE_DECFAIL VISIBLE true
        }
    }
    if {$rs=="Encoder" || $rs_design==1} {
        set_parameter_property USE_ERRORVALUE VISIBLE false
    } else {
        set_parameter_property USE_ERRORVALUE VISIBLE true
    }
    
    # Validate value for FRACTURABLE Design
    if {$rs_design==1} {
        set_parameter_property FOUR_CHANNELS VISIBLE true
        set_parameter_property TWO_CHANNELS VISIBLE true
        set_parameter_property ONE_CHANNEL VISIBLE true
    } else {
        set_parameter_property FOUR_CHANNELS VISIBLE false
        set_parameter_property TWO_CHANNELS VISIBLE false
        set_parameter_property ONE_CHANNEL VISIBLE false
    }
    if {[ get_parameter_value ONE_CHANNEL ]==0 & [ get_parameter_value TWO_CHANNELS ]==0} {
        send_message warning "Only one mode is selected"
    }
    
    
}

# |
# +-----------------------------------
proc get_irrpol_allowed_range {bits_per_symbol} {
    
    set irrpol [ list \
                        null \
                        null \
                        null \
                        [ list 11 13 ] \
                        [ list 19 25 ] \
                        [ list 37 41 47 55 59 61 ] \
                        [ list 67 91 97 103 109 115 ] \
                        [ list 131 137 143 145 157 167 171 185 191 193 203 211 213 229 239 241 247 253 ] \
                        [ list 285 299 301 333 351 355 357 361 369 391 397 425 451 463 487 501 ] \
                        [ list 529 539 545 557 563 601 607 617 623 631 637 647 661 675 677 687 695 701 719  721 731 757 761 787 \
                              789 799 803 817 827 847 859 865 875 877 883 895 901 911 949  953 967 971 973 981 985 995 1001 1019 ] \
                        [ list 1033 1051 1063 1069 1125 1135 1153 1163 1221 1239 1255 1267 1279 1293 1305 1315 1329 1341 1347 1367 1387 \
                              1413 1423 1431 1441 1479 1509 1527 1531 1555  1557 1573 1591 1603 1615 1627 1657 1663 1673 1717 1729 1747 1759 \
                              1789 1815 1821 1825 1849 1863 1869  1877 1881 1891 1917 1933 1939 1969 2011 2035 2041 ] \
                        [ list 2053 2071 2091 2093 3005 3017 4073 ] \
                        [ list 4179 5017 6005 7057 8049 8137 ] \
                    ]
    return [lindex $irrpol $bits_per_symbol]

    
}


proc add_filesets {top_level} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset"
        if {[string length $top_level]>0} {
            set_fileset_property $fileset TOP_LEVEL $top_level
        }
    }
}

proc generate_quartus_synth {entity} {
    generate QUARTUS_SYNTH $entity
}

proc generate_sim_verilog {entity} {
    generate SIM_VERILOG $entity
}

proc generate_sim_vhdl {entity} {
    generate SIM_VHDL $entity
}

proc get_file_list { {directories  "."} {pattern "*.*"} {exceptions ""}} {

    set files [list ]
    foreach dir $directories {
        foreach pat $pattern {
            set lib_files [glob -nocomplain -tail -directory $dir $pat]
            foreach lib_file $lib_files {
                set add_this_file 1
                foreach exception_pat $exceptions {
                    set add_this_file [expr $add_this_file * (1-[string match $exception_pat $lib_file ])]
                }
                if {$add_this_file==1} {lappend files "$dir/$lib_file"}
            } 
        } 
      }
      return $files
}


proc add_file_list {type file_list {sim_encrypt 0} {simulator_list ""}} {
    # entity is the name of the top level entity
    # name is the name of the wrapped rtl component (i.e rsx_decoder)
    # send_message warning "simencrypt is $sim_encrypt"
    
    if {$type =="QUARTUS_SYNTH"} {
    
        foreach thatfile $file_list {
            switch -glob $thatfile {
               *.vhd    { set language VHDL}
               *.v      { set language VERILOG}
               *.sv     { set language SYSTEM_VERILOG}
               default  { set language OTHER}
            }
            add_fileset_file [file tail $thatfile] $language PATH $thatfile
        }
    
    } else {

        if {$simulator_list == ""} {
            set simulator_list [get_simulator_list]
        }

        if {$sim_encrypt} {
            set encrypt "_ENCRYPT"
        } else {
            set encrypt ""
        }

        foreach thatfile $file_list {
            switch -glob $thatfile {
               *.vhd    { set language VHDL${encrypt}}
               *.v      { set language VERILOG}
               *.sv     { set language SYSTEM_VERILOG${encrypt}}
               default  { set language OTHER}
            }

            set added 0
            if {$sim_encrypt} {
                foreach simulator $simulator_list {
                    set sim [lindex $simulator 0]
                    set supported [lindex $simulator 1]
                    if {$supported} {
                        set specific "[string toupper $sim]_SPECIFIC"
                        add_fileset_file $sim/[file tail $thatfile] $language PATH $sim/$thatfile $specific
                        set added 1
                    }
                }
            }
            if {! $added} {
                add_fileset_file [file tail $thatfile] $language PATH $thatfile
            }
        }

    }

}

proc add_encrypted_file {type filename {path "."} {simulator_list ""}} {
    if {$simulator_list == ""} {
        set simulator_list [get_simulator_list]
    }
    set is_ocp [string equal [file extension $filename] ".ocp"]
    if {$type == "QUARTUS_SYNTH"} {
        if {$is_ocp} {
            add_fileset_file $filename OTHER PATH $path/$filename
        } else {
            add_fileset_file $filename SYSTEM_VERILOG PATH $path/$filename
        }
    } else {
        if {$is_ocp} {
            return
        }
        set added 0
        foreach simulator $simulator_list {
            set sim [lindex $simulator 0]
            set supported [lindex $simulator 1]
            if {$supported} {
                set specific "[string toupper $sim]_SPECIFIC"
                add_fileset_file $sim/[file tail $filename]  SYSTEM_VERILOG_ENCRYPT PATH $path/$sim/$filename $specific
                set added 1
            }
        }
        if {! $added} {
            add_fileset_file [file tail $filename] SYSTEM_VERILOG PATH $path/$filename
        }
    }
}

proc find_encoder_generator_matrix {} {
    
    set list_of_generated_files [list ]

    set m                   [ get_parameter_value BITSPERSYMBOL ]   
    set check               [ get_parameter_value CHECK ]
    set irrpol              [ get_parameter_value IRRPOL ]
    set n                   [ get_parameter_value N ]
    set par                 [ get_parameter_value PAR ]

    set k              [expr $n - $check]
    set t              [expr $check>>1]
    set max_n          [expr (1<<$m)-1]
    
    
    
    # Initialisation of vectors
    set AlphaToThePower                 [list ]
    for {set ii 0} {$ii < [expr $max_n+1]} {incr ii} {
        lappend AlphaToThePower 1
    }

    for {set ii 0} {$ii < [expr $check+1]} {incr ii} {
        lappend generator_temp  0
    }
    set generator_make                 $generator_temp
    set generator_polynomial           $generator_temp
    
    # Initialisation of matrices
    set generator_matrix                      [list ]
    set generator_vectors                     [list ]
    for {set ii 0} {$ii < [expr $k]} {incr ii} {
        set ini_list                   [list ]  
        for {set jj 0} {$jj < [expr $n]} {incr jj} {
            lappend ini_list 0
            if {$jj==$check-1} {lappend generator_vectors $ini_list}
        }
        lappend generator_matrix  $ini_list
    }
    
    
    lset AlphaToThePower       0 1
    for {set ii 1} {$ii < [expr $max_n+1]} {incr ii} {
        set prevAlphato             [lindex $AlphaToThePower [expr $ii-1]]
        if {($prevAlphato>>($m-1))==1} {
            set newAlphato              [expr {($prevAlphato<<1) ^  $irrpol  }]
        } else {
            set newAlphato              [expr ($prevAlphato<<1) ]
        } 
        lset AlphaToThePower      $ii                $newAlphato
    }

    
    lset generator_make 0 2
    lset generator_make 1 3
    lset generator_make 2 1
    set current_root   2
    for {set ii 3} {$ii < [expr $check+1] } {incr ii} {
        # a a^2 a^3 a^4....
        set current_root [GFmult $current_root 2 $m $irrpol]
        lset generator_temp 0 0
        for {set jj 1} {$jj < [expr $ii+1]} {incr jj} {
            lset generator_temp $jj [lindex $generator_make [expr $jj-1]]
        }        
        
        for {set jj 0} {$jj < [expr $ii+1]} {incr jj} {
            lset generator_make $jj [expr {[GFmult [expr [lindex $generator_make $jj]] $current_root $m $irrpol] ^ [lindex $generator_temp $jj] }]
        } 
    }


    # test creating the matrix using generator polynomial
    set list_temp [lindex $generator_matrix 0]
    for {set ii 0} {$ii < $check+1} {incr ii} {
        lset list_temp $ii [lindex $generator_make [expr $check-$ii] ]
    }

    lset generator_matrix 0 $list_temp
    set list_prev [lindex $generator_matrix 0]
    set list_temp $list_prev
    for {set ii 1} {$ii < $k} {incr ii} {
        lset list_temp 0 [lindex $list_prev [expr $n-1]]
        for {set jj 1} {$jj < $n} {incr jj} {lset list_temp $jj [lindex $list_prev [expr $jj-1]] }
        set list_prev $list_temp
        lset generator_matrix $ii $list_temp
    }

    
    
    # BACK SUBSTITUTION
    for {set kk 0} {$kk < $check} {incr kk} {
        set list_temp [lindex $generator_vectors [expr $k-1]]
        
        lset list_temp $kk   [lindex [lindex $generator_matrix [expr $k-1]] [expr $k+$kk]]
        lset generator_vectors [expr $k-1] $list_temp
    
        for {set ii [expr $k-2]} {[expr $ii+1] > 0} {set ii [expr $ii-1]} {
            set cwd_i  [lindex $generator_matrix $ii]  
            
            
            set acc 0
            for {set jj [expr $ii+1]} {$jj < $k} {incr jj} {
                set acc [expr {$acc ^ [GFmult [lindex $cwd_i $jj]  [lindex [lindex $generator_vectors $jj] $kk]   $m $irrpol] }]
            }
            set acc [expr {$acc ^ [lindex $cwd_i [expr $k+$kk]]}]
    
            set list_temp [lindex $generator_vectors $ii]
            lset list_temp $kk $acc
            lset generator_vectors $ii $list_temp
        }
    }
    return $generator_vectors
}    


proc GFmult {a b m irrpol} {

    set expand 0
    for {set ii 0} {$ii<$m} {incr ii} {
        if {($b & (1<<$ii))!=0} {set expand [expr {$expand ^($a<<$ii)}]}
    }

    for {set ii 0} {$ii<$m-1} {incr ii} {
        if { [expr {($expand>> (2*$m-2-$ii)) & 1}]!=0} {set expand [expr {$expand ^($irrpol<<($m-2-$ii))}]}
    }

    return $expand
}



proc clog2 {nb} {

    set x [expr $nb-1]
    set l 1
    
    if {$nb<2} {
        return 0
    }
    
    for {set ii 1} {$ii<33} {incr ii} {
        if {$x>1} {
            set x [expr $x/2]
            
            incr l
        } else {
            break
        }
    }
    return $l
}


