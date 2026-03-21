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
source "../../lib/tcl/dspip_common.tcl"

proc add_module_parametersGUI {} {
    add_parameter viterbi_type string "Parallel"
    set_parameter_property viterbi_type DISPLAY_NAME "Viterbi Architecture"
    set_parameter_property viterbi_type DESCRIPTION "Type of architecture"
    set_parameter_property viterbi_type DISPLAY_HINT radio
    set_parameter_property viterbi_type ALLOWED_RANGES {"Hybrid" "Parallel"}
    set_parameter_property viterbi_type HDL_PARAMETER true
    set_parameter_property viterbi_type GROUP "Architecture"

    # =========  Options ===========#

    add_parameter ISBER INTEGER 0
    set_parameter_property ISBER DISPLAY_NAME "BER"
    set_parameter_property ISBER DESCRIPTION "Evaluation of the BER"
    set_parameter_property ISBER DISPLAY_HINT boolean
    set_parameter_property ISBER GROUP "Parameters"

    add_parameter NODESYNC INTEGER 0
    set_parameter_property NODESYNC DISPLAY_NAME "Node Sync"
    set_parameter_property NODESYNC DESCRIPTION "When input bits order is not known, Node synchronization option allows you to rotate the inputs until the decoder is in synchronization (lower BER)."
    set_parameter_property NODESYNC DISPLAY_HINT boolean
    set_parameter_property NODESYNC GROUP "Parameters"

    # =========  Optimisations ===========#

    add_parameter parallel_optimization STRING "None"
    set_parameter_property parallel_optimization DISPLAY_NAME "Optimizations"
    set_parameter_property parallel_optimization DESCRIPTION "Type of optimization: None, Continuous or Block."
    # set_parameter_property parallel_optimization DISPLAY_HINT radio
    set_parameter_property parallel_optimization ALLOWED_RANGES {"None" "Continuous" "Block"}
    set_parameter_property parallel_optimization HDL_PARAMETER true
    set_parameter_property parallel_optimization GROUP "Optimizations"

    add_parameter BSF INTEGER 1
    set_parameter_property BSF DISPLAY_NAME "Best state finder"
    set_parameter_property BSF DESCRIPTION "Best state metric is found for every trellis step."
    set_parameter_property BSF DISPLAY_HINT boolean
    set_parameter_property BSF GROUP "Optimizations"

    add_parameter BSFDISPLAY INTEGER 0
    set_parameter_property BSFDISPLAY DISPLAY_NAME "Best state finder"
    set_parameter_property BSFDISPLAY DESCRIPTION "Best state metric is found for every trellis step."
    set_parameter_property BSFDISPLAY DISPLAY_HINT boolean
    set_parameter_property BSFDISPLAY DERIVED true
    set_parameter_property BSFDISPLAY VISIBLE false
    set_parameter_property BSFDISPLAY GROUP "Optimizations"
    # =========  Code sets ===========#

    add_parameter ISOCTAL STRING "Decimal"
    set_parameter_property ISOCTAL DISPLAY_NAME "Polynomial base"
    set_parameter_property ISOCTAL DESCRIPTION "Decimal or octal base representation for the generator polynomials."
    set_parameter_property ISOCTAL ALLOWED_RANGES {"Decimal" "Octal"}
    set_parameter_property ISOCTAL GROUP "Code sets"

    add_parameter n STRING "4"
    set_parameter_property n VISIBLE false
    set_parameter_property n HDL_PARAMETER true

    add_parameter ncodes Integer 1
    set_parameter_property ncodes VISIBLE false
    set_parameter_property ncodes HDL_PARAMETER true

    add_parameter L STRING "3"
    set_parameter_property L VISIBLE false
    set_parameter_property L HDL_PARAMETER true

    add_parameter dec_mode STRING "V"
    set_parameter_property dec_mode VISIBLE false
    set_parameter_property dec_mode HDL_PARAMETER true

    add_parameter ga STRING "7"
    set_parameter_property ga VISIBLE false
    set_parameter_property ga HDL_PARAMETER true

    add_parameter gb STRING "6"
    set_parameter_property gb VISIBLE false
    set_parameter_property gb HDL_PARAMETER true

    add_parameter gc STRING "5"
    set_parameter_property gc VISIBLE false
    set_parameter_property gc HDL_PARAMETER true

    add_parameter gd STRING "4"
    set_parameter_property gd VISIBLE false
    set_parameter_property gd HDL_PARAMETER true

    add_parameter ge STRING "0"
    set_parameter_property ge VISIBLE false
    set_parameter_property ge HDL_PARAMETER true

    add_parameter gf STRING "0"
    set_parameter_property gf VISIBLE false
    set_parameter_property gf HDL_PARAMETER true

    add_parameter gg STRING "0"
    set_parameter_property gg VISIBLE false
    set_parameter_property gg HDL_PARAMETER true



    # =========  Parameters ===========#
    add_parameter acs_units INTEGER 1
    set_parameter_property acs_units DISPLAY_NAME "ACS Units"
    set_parameter_property acs_units DESCRIPTION "Increasing the number of ACS units, increases parallelism thus reducing the latency and improving throughput."
    set_parameter_property acs_units HDL_PARAMETER true
    set_parameter_property acs_units GROUP "Parameters"

    add_parameter v INTEGER 21
    set_parameter_property v DISPLAY_NAME "Traceback"
    set_parameter_property v DESCRIPTION "Number of stages in the trellis that are traced back to obtain a decoded bit."
    set_parameter_property v HDL_PARAMETER true
    set_parameter_property v GROUP "Parameters"

    add_parameter softbits INTEGER 3
    set_parameter_property softbits DISPLAY_NAME "Number of Soft Bits"
    set_parameter_property softbits DESCRIPTION "Number of soft decision bits per symbol. "
    set_parameter_property softbits HDL_PARAMETER true
    set_parameter_property softbits GROUP "Parameters"

    
    # =========  Calculator ===========#
    add_parameter FMAX FLOAT 150
    set_parameter_property FMAX DISPLAY_NAME "Frequency"
    set_parameter_property FMAX UNITS Megahertz
    set_parameter_property FMAX DESCRIPTION "Frequency input to the throughput calculator. Has no impact on the core performance."
    set_parameter_property FMAX GROUP "Throughput Calculator"

    add_parameter TROUGH FLOAT 1
    set_parameter_property TROUGH DISPLAY_NAME "Throughput"
    set_parameter_property TROUGH UNITS MegabitsPerSecond
    set_parameter_property TROUGH DESCRIPTION "Decoder throughput"
    set_parameter_property TROUGH DERIVED true
    set_parameter_property TROUGH GROUP "Throughput Calculator"

    add_parameter LATINCYC FLOAT 3
    set_parameter_property LATINCYC DISPLAY_NAME "Latency"
    set_parameter_property LATINCYC UNITS Cycles
    set_parameter_property LATINCYC DESCRIPTION "Calculated latency in number of clock cycles."
    set_parameter_property LATINCYC DERIVED true
    set_parameter_property LATINCYC GROUP "Throughput Calculator"

    add_parameter LATINS FLOAT 3
    set_parameter_property LATINS DISPLAY_NAME "Latency"
    set_parameter_property LATINS UNITS Microseconds
    set_parameter_property LATINS DESCRIPTION "Calculated latency in microseconds."
    set_parameter_property LATINS DERIVED true
    set_parameter_property LATINS GROUP "Throughput Calculator"




}


proc add_module_parametersHDL {} {

    add_parameter rr_size INTEGER 1
    set_parameter_property rr_size HDL_PARAMETER true
    set_parameter_property rr_size VISIBLE false
    set_parameter_property rr_size DERIVED true
    set_parameter_property rr_size GROUP "HDL"
    
    add_parameter n_max INTEGER 1
    set_parameter_property n_max HDL_PARAMETER true
    set_parameter_property n_max VISIBLE false
    set_parameter_property n_max DERIVED true
    set_parameter_property n_max GROUP "HDL"    
    
    add_parameter log2_n_max INTEGER 1
    set_parameter_property log2_n_max HDL_PARAMETER true
    set_parameter_property log2_n_max VISIBLE false
    set_parameter_property log2_n_max DERIVED true
    set_parameter_property log2_n_max GROUP "HDL" 
    
    add_parameter bmgwide INTEGER 1
    set_parameter_property bmgwide DESCRIPTION "The precision of the state metric accumulator."
    set_parameter_property bmgwide HDL_PARAMETER true
    set_parameter_property bmgwide VISIBLE true
    set_parameter_property bmgwide DERIVED true
    set_parameter_property bmgwide GROUP "Parameters" 
    
    add_parameter numerr_size INTEGER 1
    set_parameter_property numerr_size HDL_PARAMETER true
    set_parameter_property numerr_size VISIBLE false
    set_parameter_property numerr_size DERIVED true
    set_parameter_property numerr_size GROUP "HDL" 
    

    add_parameter constraint_length_m_1 INTEGER 1
    set_parameter_property constraint_length_m_1 HDL_PARAMETER true
    set_parameter_property constraint_length_m_1 VISIBLE false
    set_parameter_property constraint_length_m_1 DERIVED true
    set_parameter_property constraint_length_m_1 GROUP "HDL"
    
    add_parameter vlog_wide INTEGER 1
    set_parameter_property vlog_wide HDL_PARAMETER true
    set_parameter_property vlog_wide VISIBLE false
    set_parameter_property vlog_wide DERIVED true
    set_parameter_property vlog_wide GROUP "HDL"
    
    add_parameter sel_code_size INTEGER 1
    set_parameter_property sel_code_size HDL_PARAMETER true
    set_parameter_property sel_code_size VISIBLE false
    set_parameter_property sel_code_size DERIVED true
    set_parameter_property sel_code_size GROUP "HDL"

    add_parameter ber string "used"
    set_parameter_property ber ALLOWED_RANGES {"used" "unused"}
    set_parameter_property ber HDL_PARAMETER true
    set_parameter_property ber VISIBLE false
    set_parameter_property ber DERIVED true
    set_parameter_property ber GROUP "HDL"

    add_parameter node_sync string "used"
    set_parameter_property node_sync ALLOWED_RANGES {"used" "unused"}
    set_parameter_property node_sync HDL_PARAMETER true
    set_parameter_property node_sync VISIBLE false
    set_parameter_property node_sync DERIVED true
    set_parameter_property node_sync GROUP "HDL"


    add_parameter best_state_finder string "used"
    set_parameter_property best_state_finder ALLOWED_RANGES {"used" "unused"}
    set_parameter_property best_state_finder HDL_PARAMETER true
    set_parameter_property best_state_finder VISIBLE false
    set_parameter_property best_state_finder DERIVED true
    set_parameter_property best_state_finder GROUP "HDL"
    
    add_parameter use_altera_syncram integer 0
    set_parameter_property use_altera_syncram HDL_PARAMETER true
    set_parameter_property use_altera_syncram VISIBLE false
    set_parameter_property use_altera_syncram DERIVED true
    set_parameter_property use_altera_syncram GROUP "HDL"
    
}


proc add_module_parametersTOP {} {
    add_module_parametersGUI  
    add_module_parametersHDL
}



# |
# +-----------------------------------

# +-----------------------------------
# | Parameter allowed values
# |





proc validateTOP {} {
    set viterbi                  [ get_parameter_value viterbi_type ]
    set isber                    [ get_parameter_value ISBER ]
    set opti                     [ get_parameter_value parallel_optimization ]
    set traceback                [ get_parameter_value v ]
    set isoctal                  [ get_parameter_value ISOCTAL ]
    set n                        [ get_parameter_value n]
    set mode                     [ get_parameter_value dec_mode]
    set acs_units                [ get_parameter_value acs_units]
    set fmax                     [ get_parameter_value FMAX]
    set soft                     [ get_parameter_value softbits ] 
    set bsf                      [ get_parameter_value BSF ]    
    set nodesync                 [ get_parameter_value NODESYNC ]
    set valid_polynomials        [list]

    set n_outofrange 0
    set ncodes [get_parameter_value ncodes]



    set arch [get_parameter_value viterbi_type]
    set array_names [list n L dec_mode ga gb gc gd ge gf gg]
    set i 0

    foreach name $array_names {
        set value [get_parameter_value $name]
        set code($name) [split $value _ ]
    }


   set all_codes  [list $code(ga) $code(gb) $code(gc) $code(gd) $code(ge) $code(gf) $code(gg)]
    # send_message info $all_codes
    set invalid 0
    set mode_error 0
    for {set i 0} {$i < $ncodes} {incr i} {
            set l 1
            set n 1
            set n [lindex $code(n) $i]
            set l [lindex $code(L) $i]
            set dec_mode [lindex $code(dec_mode) $i]
            if { $dec_mode == "T"  && $n != 2 } {
                set mode_error 1
            } 
            set min [expr 2**($l-1)]
            set max [expr 2**$l]
            for {set j 0} {$j < $n} {incr j} {
                set poly [lindex $all_codes  $j $i]
                if { $poly < $min  || $poly > $max } {
                    incr invalid
                } 
            }
    }
    set n_list [list]
    for {set i 0} {$i < $ncodes} {incr i} {
        set n [lindex $code(n) $i]
        set dec_mode [lindex $code(dec_mode) $i]
        if { $dec_mode == "T"} {
            lappend n_list [expr 2*$n]
        } else {
            lappend n_list $n
        }
    }
    set_parameter_value n_max [lindex [lsort -decreasing -integer $n_list] 0]
    set n_max [get_parameter_value n_max]
    #set_parameter_value constraint_length_m_1 [expr [lindex [lsort -decreasing -integer [lrange $code(L) 0 [expr $ncodes-1]]] 0] -1]
    set lmin [lindex [lsort -increasing -integer [lrange $code(L) 0 [expr $ncodes-1]]] 0]
    set lmax [lindex [lsort -decreasing -integer [lrange $code(L) 0 [expr $ncodes-1]]] 0]
    if {$arch == "Hybrid" && $lmax < 5} {
                set lmax 5
                
    }
    set_parameter_value constraint_length_m_1 [expr $lmax-1]
    if { $invalid == 1 } {
        send_message ERROR "There is an invalid polynomial set in the table, check the tooltips on the table for help"
    } elseif { $invalid > 1 } {
        send_message ERROR "There are $invalid invalid polynomials set in the table, check the tooltips on the table for help"
    }
    if { $mode_error == 1} {
        send_message ERROR "In TCM Mode the Number of Coded bits (n) is limited to 2"
    }

    # set parameters [list N L dec_mode]
    # foreach var $parameters {
    #     set conjoined [join [lrange $code($var) 0 [expr $ncodes-1]] "_"]
    #      set_parameter_value $var $conjoined
    # }

    #  set parameters [list  ga gb gc gd ge gf gg]

    # foreach var $parameters {
    #     set conjoined [join [lrange $code($var) 0 [expr $n_max-1]] "_"]
    #      set_parameter_value $var $conjoined
    # }





    if {$isber==0} {
        set_parameter_property NODESYNC ENABLED false
    } else {
        set_parameter_property NODESYNC ENABLED true
    }

    if {[string equal $viterbi "Parallel"]} {   
        set_parameter_property parallel_optimization ENABLED true
        if {[string equal $opti "None"]} {
            set_parameter_property BSF ENABLED true
            set_parameter_property BSF VISIBLE true
            set bsf           [ get_parameter_value BSF ]
            set_parameter_property BSFDISPLAY VISIBLE false
        } else {
            set_parameter_property BSF ENABLED false
            set_parameter_property BSF VISIBLE false
            set_parameter_property BSFDISPLAY VISIBLE true
            set bsf           0
        }
        set_parameter_property acs_units ENABLED false
    } else {
        set_parameter_property parallel_optimization ENABLED false
        set_parameter_property BSF ENABLED false
        set_parameter_property BSF VISIBLE false
        set_parameter_property BSFDISPLAY VISIBLE true
        set bsf           0
        set_parameter_property acs_units ENABLED true
    }
    
    
    

    if {[string equal $viterbi "Parallel"] && [string equal $opti "Block"]} {
        if {$traceback<8 || $traceback>3700} {send_message error "Traceback length ($traceback) must be between 8 and 3700 in block parallel mode."}
        send_message note "traceback length should superior or equal to the block length" 
    } else {
        if {$traceback<8 || $traceback>150} {send_message error "Traceback length ($traceback) must be between 8 and 150."}
    }




    set_parameter_property softbits ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16}





    

    #========  set value of hdl parameters =========#
    
    # set_parameter_value n_max $n
    set_parameter_value rr_size [expr $soft*$n_max]
    set_parameter_value log2_n_max [ expr int(ceil(log($n_max) / log(2))) ]
    
    if {$ncodes==1} {
        set_parameter_value sel_code_size 1
    } else {
        set_parameter_value sel_code_size [ expr int(ceil(log($ncodes) / log(2))) ]
    }

    if {$isber==1} {
        set_parameter_value ber "used"
    } else {
        set_parameter_value ber "unused"
    }
    if {$bsf==1} {
        set_parameter_value best_state_finder "used"
    } else {
        set_parameter_value best_state_finder "unused"
    }
    if {$nodesync==1} {
        set_parameter_value node_sync "used"
    } else {
        set_parameter_value node_sync "unused"
    }


     
    set thr   [expr (2**$soft-2)*$n_max*($lmin+1)]
    if {$n_max<4} {
        set bmgmin [expr $soft+5]
    } else {
        if {$n_max < 6} {
            set bmgmin [expr $soft+6]
        } else {
            set bmgmin [expr $soft+6]
        }
    } 
    set continue 1
    for {set bmg $soft} {$bmg < 24} {incr bmg} {
        if {$continue ==1} {
            set i [expr 2**($bmg-1) - 6]
            if {$i>$thr} {
                if {$bmg>$bmgmin} {
                    set_parameter_value bmgwide $bmg
                } else {
                    set_parameter_value bmgwide $bmgmin
                }
                set continue 0
            }
        }
    }
    

    set_parameter_value vlog_wide [ expr int(ceil(log($traceback+17) / log(2))) ]

    set_parameter_value numerr_size 8
    

    if {$lmax>5} {set cstrlength [expr $lmax - 1]} else {set cstrlength 4}


    if {$fmax>0} {
        if {[string equal $viterbi "Parallel"]} {  
            set Z 1
            if {$traceback>=0} {
                set_parameter_value LATINCYC [expr  4*$traceback + 6]
            } else {
                set_parameter_value LATINCYC 0
            }
        } else {
            set log2cc [expr $cstrlength - 1 - int(ceil(log($acs_units)/log(2)))]
            if {$log2cc > 3} {set Z [expr 2**$log2cc]} else {set Z 10}

            set log2cc [expr $cstrlength - 1 - int(log($acs_units)/log(2))]
            if {$log2cc > 3} {set A [expr 2**$log2cc]} else {set A 10}

            if {$traceback>=0} {
                set_parameter_value LATINCYC [expr  $traceback*$A]
            } else {
                set_parameter_value LATINCYC 0
            }
        }
        set_parameter_value TROUGH [expr  $fmax/$Z]
        set_parameter_value LATINS [expr  [get_parameter_value LATINCYC]/$fmax]
    } else {
        send_message error "Frequency ($fmax) must be positive."
        set_parameter_value TROUGH 0
        set_parameter_value LATINS 0
        set_parameter_value LATINCYC 0
    }



    if {$l>5} {set cstrlength [expr $l - 1]} else {set cstrlength 4}

            set log2cc [expr $cstrlength - 1 - int(ceil(log($acs_units)/log(2)))]
            if {$log2cc > 3} {set Z [expr 2**$log2cc]} else {set Z 10}
            set log2cc [expr $cstrlength - 1 - int(log($acs_units)/log(2))]
            if {$log2cc > 3} {set A [expr 2**$log2cc]} else {set A 10}

    set device [get_parameter_value selected_device_family]
    if {[string match *10*  $device]  && $device ne "MAX 10" && $device ne "Cyclone 10 LP"} {
        set_parameter_value use_altera_syncram 1
    } else {
        set_parameter_value use_altera_syncram 0
    }
    
}



# |
# +-----------------------------------


proc add_filesets {top_level} {
    foreach fileset {quartus_synth sim_vhdl sim_verilog } {
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

proc get_simulator_list {} {
    return { \
             {mentor   0   } \
             {aldec    0    } \
             {synopsys 0 } \
             {cadence  0  } \
           }
}

proc add_top_level_file {type entity name } {
    if {[string equal -nocase $type "SIM_VERILOG"]} {
        set ext ".v"
        set language "VERILOG"
    } else {
        set ext  ".vhd"
        set language "VHDL"
    }
    set list_of_port [list sel_code state_node_sync]

    add_RAM_ini_file  $entity 
    
    set extra_param [list [list ini_filename ${entity}_ini.hex STRING quoted]]

    set wrapper_file_content [altera_hdl_wrapper::generate_wrapper $entity $name $language $extra_param "" $list_of_port]
    add_fileset_file "${entity}${ext}" $language TEXT $wrapper_file_content
    
}

proc add_file_list {type file_list {sim_encrypt 0} {simulator_list ""}} {

    if {$type =="QUARTUS_SYNTH"} {
    
        foreach thatfile $file_list {
            switch -glob $thatfile {
               *.vhd { set language VHDL}
               *.v   { set language VERILOG}
               *.sv  { set language SYSTEM}
               *.ocp { set language OTHER}
            }
            add_fileset_file ./src/[file tail $thatfile] $language PATH $thatfile
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

                    set sim_file [file dirname $thatfile]/$sim/[file tail $thatfile]
                    set supported [file exists $sim_file]

                    if {$supported} {
                        set specific "[string toupper $sim]_SPECIFIC"
                        add_fileset_file ./src/$sim/[file tail $thatfile] $language PATH $sim_file  $specific
                        set added 1
                    }
                }
            }
            if {! $added} {
                add_fileset_file ./src/[file tail $thatfile] $language PATH $thatfile
            }
        }


    }

}

proc add_RAM_ini_file {entity} {

    set L                [get_parameter_value L]
    set v                [ get_parameter_value v ]
    set par_opt          [ get_parameter_value parallel_optimization ]
    set vlog_wide        [ get_parameter_value vlog_wide ]
    
    if {$par_opt=="None"} {
        set RAMlength [expr 1<< int(ceil(log(4*($v+17))/ log(2)))]
    }
    if {$par_opt=="Continuous"} {
        set RAMlength [expr 4*$v]
    }
    if {$par_opt=="Block"} {
        set RAMlength [expr 1<< int(ceil(log($vlog_wide)/ log(2)))]
    }

    set Llist [split $L "_" ]
    set Lmax  0
    foreach element $Llist {
        if {$element>$Lmax} {
            set Lmax  $element
        }
    }
    
    set wordsize   [expr 1<<($Lmax-1)]

  
    set hexa_charPerWord              [expr {($wordsize - 1) / 4 + 1}]
  
    set list_of_zeros [list]
    for {set ii 0} {$ii < $RAMlength} {incr ii} {
        lappend list_of_zeros [format "%0[expr $hexa_charPerWord]X"  0]
    }
    set text [convert_hexa_to_HEX $list_of_zeros]
    add_fileset_file "./src/${entity}_ini.hex" HEX TEXT $text


}


proc convert_hexa_to_HEX {hexa_list} {
    # this function convert a list of hexadecimal number into a
    # Intel HEX format list used in ROM initialisation
    # 
    
    set HEX_list [list ]
    set length [llength $hexa_list]
    set HexacharPerWord     [llength [regexp -all -inline . [lindex $hexa_list 0]]]

    
    if {$HexacharPerWord%2!=0} {
        set append_char 0 
        incr HexacharPerWord
    } else {
        set append_char ""
    }
    
    
    for {set ii 0} {$ii<$length} {incr ii} {
        #
        set nb_byte [format %02X [expr $HexacharPerWord>>1] ]
        
        set address [format %04X [expr $ii] ] 
        set record_type "00"
        set data $append_char[lindex $hexa_list $ii]
        set crc [format %02X [ihex_crc  [regexp -all -inline .. $nb_byte$address$record_type$data]] ] 
        append HEX_list ":${nb_byte}${address}${record_type}${data}${crc}\n"
    
    }
    append HEX_list ":00000001FF"

    return $HEX_list

}


proc ihex_crc {bytes} {
    # Calculate Intel-hex CRC for list of bytes
    set sum 0
    foreach b $bytes {
        incr sum 0x$b
    }
    set sum [expr {(1 + ~$sum) & 0xFF}] ;# bcb
    return $sum
}




proc upgrade_callback {ip_core_type version old_parameters} {
    set polynomials [list ga_display gb_display gc_display gd_display ge_display gf_display gg_display]
    set removed_parameters [list AUTO_CLK_CLOCK_RATE]
    if { [compare_versions $version "15.0"] == -1 } {
        foreach { name value } $old_parameters {
            if { $name eq "mode" } {
                if { $value eq "Viterbi" } {
                set_parameter_value dec_mode "V"
            } else {
                set_parameter_value dec_mode "T"
            }
            } elseif { [ lsearch $polynomials $name ] != -1} {
                set new_name [string range $name 0 1]
                set new_value [string trimleft $value s]
                set_parameter_value $new_name $new_value
            } elseif { [ lsearch $removed_parameters $name ] != -1} {
            } else {
                set_parameter_value $name $value
            }
        }
        set_parameter_value ncodes 1
    } else { ;# For non 14.0->14.1 upgrade flows 
        foreach { name value } $old_parameters {
            set_parameter_value $name $value
        }
    # }
}
