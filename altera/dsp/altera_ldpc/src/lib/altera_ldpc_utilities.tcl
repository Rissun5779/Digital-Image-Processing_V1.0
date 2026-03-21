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

proc add_module_parametersMODULE {} {
add_parameter MODULE string "Encoder"
set_parameter_property MODULE DISPLAY_NAME "Low Density Parity Check code module"
set_parameter_property MODULE DESCRIPTION "Encoder or Decoder"
}

proc add_module_parametersLDPC_TYPE {} {
add_parameter LDPC_TYPE string "DVB"
set_parameter_property LDPC_TYPE DISPLAY_NAME "Standard"
set_parameter_property LDPC_TYPE DESCRIPTION "Family of the LDPC code"
set_parameter_property LDPC_TYPE ALLOWED_RANGES {"DOCSIS:DOCSIS 3.1" "DVB:DVB-S2" "NASA:NASA GSFC-STD-9100" "WiMedia:WiMedia 1.5"}
}

proc add_module_parametersRATE {} {
add_parameter RATE INTEGER 0
set_parameter_property RATE DISPLAY_NAME "Coding rate"
set_parameter_property RATE DESCRIPTION "Coding rate"
set_parameter_property RATE HDL_PARAMETER true
}

proc add_module_parametersCHANNEL {} {
add_parameter CHANNEL INTEGER 1 
set_parameter_property CHANNEL DISPLAY_NAME "Number of channels"
set_parameter_property CHANNEL DESCRIPTION "Number of channels"
set_parameter_property CHANNEL HDL_PARAMETER true
set_parameter_property CHANNEL VISIBLE false
}

proc add_module_parametersNSTRING {} {
add_parameter N STRING "0"
set_parameter_property N DISPLAY_NAME "Codeword length"
set_parameter_property N DESCRIPTION "Number of bits per codeword"
set_parameter_property N HDL_PARAMETER true
}

proc add_module_parametersN {} {
add_parameter N INTEGER 0
set_parameter_property N DISPLAY_NAME "Codeword length"
set_parameter_property N DESCRIPTION "Number of bits per codeword"
set_parameter_property N HDL_PARAMETER true
}

proc add_module_parametersNBITE {} {
add_parameter NB_ITE INTEGER 10
set_parameter_property NB_ITE DISPLAY_NAME "Number of decoding iterations"
set_parameter_property NB_ITE DESCRIPTION "Number of decoding iterations"
set_parameter_property NB_ITE HDL_PARAMETER true
set_parameter_property NB_ITE GROUP "Options"
}

proc add_module_parametersNBCHECKGROUP {} {
add_parameter NBCHECKGROUP INTEGER 90
set_parameter_property NBCHECKGROUP DESCRIPTION "Number of check node groups"
set_parameter_property NBCHECKGROUP VISIBLE false
set_parameter_property NBCHECKGROUP HDL_PARAMETER true
}

proc add_module_parametersNBVARGROUP {} {
add_parameter NBVARGROUP INTEGER 90
set_parameter_property NBVARGROUP DESCRIPTION "Number of variable node groups"
set_parameter_property NBVARGROUP VISIBLE false
set_parameter_property NBVARGROUP HDL_PARAMETER true
}

proc add_module_parametersM {} {
add_parameter BITSPERSYMBOL INTEGER 1
set_parameter_property BITSPERSYMBOL DISPLAY_NAME "Number of bits per input symbol"
set_parameter_property BITSPERSYMBOL DESCRIPTION "Number of bits per input symbol"
set_parameter_property BITSPERSYMBOL HDL_PARAMETER true
}
proc add_module_parametersLLRPERSYMBOL {} {
add_parameter LLRPERSYMBOL INTEGER 2
set_parameter_property LLRPERSYMBOL DISPLAY_NAME "Number of LLRs per input symbol"
set_parameter_property LLRPERSYMBOL DESCRIPTION "Number of LLRs per input symbol"
set_parameter_property LLRPERSYMBOL HDL_PARAMETER true
}

proc add_module_parametersSOFT {} {
add_parameter SOFTBITS INTEGER 3
set_parameter_property SOFTBITS DISPLAY_NAME "Number of soft bits per input LLR"
set_parameter_property SOFTBITS DESCRIPTION "Number of soft bits of the Input LLR"
set_parameter_property SOFTBITS HDL_PARAMETER true
}

proc add_module_parametersPAR {} {
add_parameter PAR INTEGER 2
set_parameter_property PAR DISPLAY_NAME "Parallelism"
set_parameter_property PAR DESCRIPTION "Level of parallelism of the decoder"
set_parameter_property PAR HDL_PARAMETER true
set_parameter_property PAR GROUP "Options"
}

proc add_module_parametersSOFTMSA {} {
add_parameter S INTEGER 4
set_parameter_property S DISPLAY_NAME "Width of the decoder variables"
set_parameter_property S DESCRIPTION "Number of soft bits of the decoder variables"
set_parameter_property S HDL_PARAMETER true
set_parameter_property S GROUP "Options"
}

proc add_module_parametersATT {} {
add_parameter ATTENUATION INTEGER 1
set_parameter_property ATTENUATION DISPLAY_NAME "MSA attenuation factor"
set_parameter_property ATTENUATION DESCRIPTION "Attenuation factor applied during the min-sum algorithm"
set_parameter_property ATTENUATION GROUP "Options"
set_parameter_property ATTENUATION HDL_PARAMETER true
}

proc add_module_parametersTRANSMITPARITY {} {
add_parameter TRANSMIT_PARITY INTEGER 0
set_parameter_property TRANSMIT_PARITY DISPLAY_NAME "Output parity-check bits"
set_parameter_property TRANSMIT_PARITY DESCRIPTION "Select whether to output parity-check bits"
set_parameter_property TRANSMIT_PARITY HDL_PARAMETER true
set_parameter_property TRANSMIT_PARITY GROUP "Options"
set_parameter_property TRANSMIT_PARITY ALLOWED_RANGES {0:No 1:Yes}
}

proc add_module_parametersISLAYERED {} {
add_parameter ISLAYERED INTEGER 1
set_parameter_property ISLAYERED DISPLAY_NAME "Use Layered decoding"
set_parameter_property ISLAYERED DESCRIPTION "with Layered decoding, LLRs are updated after each layer usually resulting in faster convergence"
set_parameter_property ISLAYERED ALLOWED_RANGES {0:No 1:Yes}
set_parameter_property ISLAYERED GROUP "Options"
}


proc add_module_parametersISFULLSTREAMING {} {
add_parameter ISFULLSTREAMING INTEGER 1
set_parameter_property ISFULLSTREAMING DISPLAY_NAME "Full-streaming architecture"
set_parameter_property ISFULLSTREAMING DESCRIPTION "Select whether to have an architecture allowing full-streaming"
set_parameter_property ISFULLSTREAMING GROUP "Options"
set_parameter_property ISFULLSTREAMING ALLOWED_RANGES {0:No 1:Yes}
}

proc add_module_parametersISVARRATE {} {
add_parameter ISVARRATE INTEGER 0
set_parameter_property ISVARRATE DISPLAY_NAME "Variable code rate"
set_parameter_property ISVARRATE DESCRIPTION "Variable code rate"
set_parameter_property ISVARRATE GROUP "Options"
set_parameter_property ISVARRATE ALLOWED_RANGES {0:No 1:Yes}
}

proc add_module_parametersISVARRATE_HDL {} {
add_parameter ISVARRATE INTEGER 0
set_parameter_property ISVARRATE DISPLAY_NAME "Variable code rate"
set_parameter_property ISVARRATE DESCRIPTION "Variable code rate"
set_parameter_property ISVARRATE GROUP "Options"
set_parameter_property ISVARRATE ALLOWED_RANGES {0:No 1:Yes}
set_parameter_property ISVARRATE HDL_PARAMETER true
}

proc add_module_parametersKSTRING {} {
add_parameter K STRING "0"
set_parameter_property K DISPLAY_NAME "Data-word length"
set_parameter_property K DESCRIPTION "Length of the data word"
set_parameter_property K ENABLED false
}

proc add_module_parametersEXTRALATENCY {} {
add_parameter EXTRALATENCY INTEGER 0
set_parameter_property EXTRALATENCY DISPLAY_NAME "Extra pipelining stages"
set_parameter_property EXTRALATENCY DESCRIPTION "Insert extra pipelining stages in order to increase Fmax. May reduce the throughput"
set_parameter_property EXTRALATENCY ALLOWED_RANGES {0:+\ 0 1:+\ 1 2:+\ 2 3:+\ 3 4:+\ 4}
set_parameter_property EXTRALATENCY GROUP "Throughput calculator"
set_parameter_property EXTRALATENCY HDL_PARAMETER true
}

proc add_module_parametersTHROUGHPUT {} {
add_parameter LAYER FLOAT 10
set_parameter_property LAYER DISPLAY_NAME "Average number of decoded layers"
set_parameter_property LAYER DESCRIPTION "Average number of decoded layers"
set_parameter_property LAYER HDL_PARAMETER false
set_parameter_property LAYER GROUP "Throughput calculator"

add_parameter CODE INTEGER 0
set_parameter_property CODE DISPLAY_NAME "Compute throughput for code rate"
set_parameter_property CODE DESCRIPTION "Compute throughput for code rate"
set_parameter_property CODE HDL_PARAMETER false
set_parameter_property CODE GROUP "Throughput calculator"

add_parameter THROUGHPUT FLOAT 0
set_parameter_property THROUGHPUT DISPLAY_NAME "Throughput / Fmax"
set_parameter_property THROUGHPUT DESCRIPTION "Lenght of the data word"
set_parameter_property THROUGHPUT HDL_PARAMETER false
set_parameter_property THROUGHPUT DERIVED true
set_parameter_property THROUGHPUT ENABLED false
set_parameter_property THROUGHPUT GROUP "Throughput calculator"
}


proc add_module_parametersENC {} {
    add_module_parametersLDPC_TYPE
    add_module_parametersCHANNEL
    add_module_parametersM
    add_module_parametersN
    add_module_parametersNBCHECKGROUP
    add_module_parametersNBVARGROUP
}

proc add_module_parametersDEC {} {
    add_module_parametersCHANNEL
    add_module_parametersM
    add_module_parametersN
    add_module_parametersNBCHECKGROUP
    add_module_parametersNBVARGROUP
    add_module_parametersSOFT
    add_module_parametersPAR
    add_module_parametersNBITE
    add_module_parametersLDPC_TYPE
    add_module_parametersTRANSMITPARITY
    add_module_parametersATT
    add_module_parametersSOFTMSA
    add_module_parametersISFULLSTREAMING
    add_module_parametersISLAYERED
    add_module_parametersISVARRATE
    add_module_parametersEXTRALATENCY
}

proc add_module_parametersTOP {} {
    add_module_parametersLDPC_TYPE
    add_module_parametersMODULE
    add_module_parametersCHANNEL
    add_module_parametersNSTRING
    add_module_parametersKSTRING
    add_module_parametersRATE
    add_module_parametersNBCHECKGROUP
    add_module_parametersNBVARGROUP
    add_module_parametersM
    add_module_parametersLLRPERSYMBOL
    add_module_parametersSOFT
    add_module_parametersNBITE
    add_module_parametersPAR
    add_module_parametersSOFTMSA
    add_module_parametersATT
    add_module_parametersISFULLSTREAMING
    add_module_parametersISLAYERED
    add_module_parametersTRANSMITPARITY
    add_module_parametersISVARRATE
    add_module_parametersEXTRALATENCY
    add_module_parametersTHROUGHPUT
}


# |
# +-----------------------------------

# +-----------------------------------
# | Parameter allowed values
# |

proc validateTOP {} {
    set module      [ get_parameter_value MODULE ]
    set ldpc_type   [ get_parameter_value LDPC_TYPE ]
    set n_string    [ get_parameter_value N ]
    set k_string    [ get_parameter_value K ]
    set lps         [ get_parameter_value LLRPERSYMBOL ]
    set softbits    [ get_parameter_value SOFTBITS ]
    set islayered   [ get_parameter_value ISLAYERED ]
    set softbits_msa  [ get_parameter_value S ]
    set rate_string [ get_parameter_value RATE ]
    set isvarrate   [ get_parameter_value ISVARRATE ]
    
    
    set max_n_nb 100
    set max_rate_nb 100
    
    set_parameter_property N               ENABLED true
    set_parameter_property N               VISIBLE true
    set_parameter_property K               VISIBLE true
    set_parameter_property RATE            ENABLED true
    set_parameter_property RATE            VISIBLE true
    set_parameter_property ISVARRATE       VISIBLE false
    
    
   
    if {[string equal $ldpc_type "DOCSIS"]} {
        set_parameter_property MODULE ALLOWED_RANGES {"Encoder:Decoder" "Decoder:Decoder"} 
        set_parameter_property MODULE ENABLED false
        set isencoder 0
    }
    if {[string equal $ldpc_type "DVB"]} {
        set_parameter_property MODULE ALLOWED_RANGES {"Encoder:Decoder" "Decoder:Encoder"} 
        set_parameter_property MODULE ENABLED false
        set isencoder 1
    }
    if {[string equal $ldpc_type "NASA"]} {
        set_parameter_property MODULE ALLOWED_RANGES {"Encoder:Encoder" "Decoder:Decoder"} 
        set_parameter_property MODULE ENABLED true
        set isencoder [string equal $module "Encoder"]
    }
    if {[string equal $ldpc_type "WiMedia"]} {
        set_parameter_property MODULE ALLOWED_RANGES {"Encoder:Encoder" "Decoder:Decoder"}
        set_parameter_property MODULE ENABLED true
        set isencoder [string equal $module "Encoder"]
    }


    
    if {$isencoder} {
        set_parameter_property TRANSMIT_PARITY VISIBLE false
        set_parameter_property ISLAYERED       VISIBLE false
        set_parameter_property PAR             VISIBLE false
        set_parameter_property SOFTBITS        VISIBLE false
        set_parameter_property NB_ITE          VISIBLE false
        set_parameter_property S               VISIBLE false
        set_parameter_property ATTENUATION     VISIBLE false
        set_parameter_property LLRPERSYMBOL    VISIBLE false
        set_parameter_property BITSPERSYMBOL   VISIBLE true
        set_parameter_property ISFULLSTREAMING VISIBLE false
        
        set_parameter_property EXTRALATENCY    VISIBLE false
        set_parameter_property CODE            VISIBLE false
        set_parameter_property LAYER           VISIBLE false
        set_parameter_property THROUGHPUT      VISIBLE false

        
        set list_valid [list 1 [ get_parameter_value PAR ]]
        set_parameter_property PAR ALLOWED_RANGES $list_valid 
        
        set list_valid [list 1 [ get_parameter_value LLRPERSYMBOL ]]
        set_parameter_property LLRPERSYMBOL ALLOWED_RANGES $list_valid 
        
        set list_valid [list 1 [ get_parameter_value S ]]
        set_parameter_property S ALLOWED_RANGES $list_valid 
        
        set list_valid [list 1 [ get_parameter_value SOFTBITS ]]
        set_parameter_property SOFTBITS ALLOWED_RANGES $list_valid 
        
        set list_valid [list 1 [ get_parameter_value NB_ITE ]]
        set_parameter_property NB_ITE ALLOWED_RANGES $list_valid 
        
        set list_valid [list 1 [ get_parameter_value ATTENUATION ]]
        set_parameter_property ATTENUATION ALLOWED_RANGES $list_valid 
        
    } else {
        set_parameter_property BITSPERSYMBOL   VISIBLE false
        set_parameter_property TRANSMIT_PARITY VISIBLE true
        set_parameter_property ISLAYERED       VISIBLE true
        set_parameter_property PAR             VISIBLE true
        set_parameter_property SOFTBITS        VISIBLE true
        set_parameter_property S               VISIBLE true
        set_parameter_property NB_ITE          VISIBLE true
        set_parameter_property ATTENUATION     VISIBLE true
        set_parameter_property LLRPERSYMBOL    VISIBLE true
        set_parameter_property ISFULLSTREAMING VISIBLE false
        
        set_parameter_property EXTRALATENCY    VISIBLE false
        set_parameter_property CODE            VISIBLE false
        set_parameter_property LAYER           VISIBLE false
        set_parameter_property THROUGHPUT      VISIBLE false
        
        set list_valid [list 1 [ get_parameter_value BITSPERSYMBOL ]]
        set_parameter_property BITSPERSYMBOL ALLOWED_RANGES $list_valid 
        
        # Validate value for SOFTBITS
        set list_valid_soft [list ]
        for {set i 2} {$i < 17} {incr i} {
            lappend list_valid_soft $i
        }
        set_parameter_property SOFTBITS ALLOWED_RANGES $list_valid_soft
        set list_valid_soft_msa [list ]
        for {set i $softbits} {$i < 17} {incr i} {
            lappend list_valid_soft_msa $i
        }
        set_parameter_property S ALLOWED_RANGES $list_valid_soft_msa
        
        # Validate value for NB_ITE
        set list_valid_ite [list ]
        for {set i 1} {$i < 101} {incr i} {
            lappend list_valid_ite $i
        }
        set_parameter_property NB_ITE ALLOWED_RANGES $list_valid_ite  
        
        # Validate value for ATTENUATION 
        set att_list_s [list "1:1" "2:0.875" "3:0.75" "4:0.625" "5:0.5" "6:0.375" "7:0.25"]
        set att_list [list 1 0.875 0.75 0.625 0.5 0.375 0.25]
        set list_valid_att [list ]
        set soft_factor [expr 2**($softbits_msa-1-1)]
        set notinthelist 0;
        for {set i 0} {$i < 7} {incr i} {
            set val 0;
            if {[expr [lindex $att_list $i]*$soft_factor]==[expr floor([lindex $att_list $i]*$soft_factor)]} {
                lappend list_valid_att "[lindex $att_list_s $i]"
                set val 1;
            }
            if {$i==[expr [get_parameter_value ATTENUATION ]-1] && $val==0} {set notinthelist 1}
        }

        if {$notinthelist==1} {
            send_message error "Choose a valid attenuation factor"
            lappend list_valid_att "[get_parameter_value ATTENUATION ]:Attenuation"
        }
        set_parameter_property ATTENUATION ALLOWED_RANGES $list_valid_att
        
    }
    
    # Validate value for CODE
    set list_valid_code [ get_parameter_value CODE ]
    
    
    
    
    if {[string equal $ldpc_type "DVB"]} { 
        # Validate value for N
        set list_valid_n [list "0:64800" "1:16200"]
        set max_n_nb 1
        
        # Validate value for K
        set matrix_number    [get_DVB_matrixnumber $n_string $rate_string]
        get_DVB_parameters nbcheckgroup nbvargroup n $matrix_number
        set list_valid_k [list [ get_parameter_value K ]:[expr 360*$nbvargroup]]
        
        # Validate value for RATE
        if {$n_string==0} {
            set list_valid_rate [list "0:1/4" "1:1/3" "2:2/5" "3:1/2" "4:3/5" "5:2/3" "6:3/4" "7:4/5" "8:5/6" "9:8/9" "10:9/10"]
            set max_rate_nb 10
        } else {
            set list_valid_rate [list "0:1/4" "1:1/3" "2:2/5" "3:1/2" "4:3/5" "5:2/3" "6:3/4" "7:4/5" "8:5/6" "9:8/9"]  
            set max_rate_nb 9
        }
        
        # Validate value for BITSPERSYMBOL
        set_parameter_property BITSPERSYMBOL ALLOWED_RANGES  {1 2 3 4 5 6 8 9 10 12 15  18 20 24 30} 
        
    }

    if {[string equal $ldpc_type "NASA"]} {
        # Validate value for N
        set list_valid_n [list "0:8176" "1:8160"]
        set max_n_nb 1
        # Validate value for K
        set k_table [list 7154 7136]
        set list_valid_k [list "[ get_parameter_value K ]:[lindex $k_table [ get_parameter_value N ]]"]
        
        # Validate value for RATE
        set_parameter_property RATE ENABLED false
        set list_valid_rate [list [ get_parameter_value RATE ]:7/8\ ]
        # Validate value for PAR
        set list_valid_par [list ]
        for {set i [expr 1]} {$i < 101} {incr i 1} {
            lappend list_valid_par $i
        }
        set_parameter_property PAR ALLOWED_RANGES $list_valid_par    
        
        if {$isencoder} {
            # Validate value for BITSPERSYMBOL
            set_parameter_property BITSPERSYMBOL ALLOWED_RANGES  {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40}
        } else {
            # Validate value for BITSPERSYMBOL
            set_parameter_property LLRPERSYMBOL ALLOWED_RANGES  {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40}         
        }
    }
    
    
    if {[string equal $ldpc_type "WiMedia"]} {
    
        set_parameter_property ISVARRATE       VISIBLE true
        
        # Validate value for N
        set list_valid_n [list "0:1320" "1:1200"]
        set max_n_nb 1
        
        # Validate value for K
        get_Wimedia_parameters nbcheckgroup nbvargroup n_code $n_string $rate_string $isencoder
        set list_valid_k [list [ get_parameter_value K ]:[expr 1200-30*($nbcheckgroup-4)]]
        
        # Validate value for RATE
        set list_valid_rate [list "0:0.8" "1:0.75" "2:0.625" "3:0.5"] 
        set max_rate_nb 3

        if {$isvarrate==1} {
            set list_valid_rate [list "[ get_parameter_value RATE ]:Variable Rate option chosen"]
            set list_valid_k [list "[ get_parameter_value K ]   :Variable Rate option chosen"] 
            send_message warning "The Variable rate option is selected in the options"
            
            set_parameter_property RATE ALLOWED_RANGES $list_valid_rate
            set_parameter_property RATE ENABLED false
            set max_rate_nb $rate_string
        }
    
    
        if {$isencoder} {

            # Validate value for BITSPERSYMBOL
            set_parameter_property BITSPERSYMBOL ALLOWED_RANGES  {1 2 3 5 6  10 15 30 } 
            
        } else {
            
            # Validate value for BITSPERSYMBOL
            set_parameter_property LLRPERSYMBOL ALLOWED_RANGES  {2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40} 
            
            # Validate value for PAR
            set_parameter_property PAR ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10} 

            set_parameter_property ISLAYERED VISIBLE false
        }

    }

    if {[string equal $ldpc_type "DOCSIS"]} {
        set_parameter_property RATE VISIBLE false
        set_parameter_property N VISIBLE false
        set_parameter_property N ENABLED false
        set_parameter_property K VISIBLE false
        set_parameter_property ISLAYERED VISIBLE false
        
        set_parameter_property EXTRALATENCY    VISIBLE true
        set_parameter_property CODE            VISIBLE true
        set_parameter_property LAYER           VISIBLE true
        set_parameter_property THROUGHPUT      VISIBLE true
        
        
        set list_valid_rate  [list 0:89\% 1:85\% 2:75\%]
        set list_n           [list 16200 5940 1120]
        set list_Z           [list 360 180 56]
        
        # Validate value for RATE
        set_parameter_property RATE    ALLOWED_RANGES  $list_valid_rate

        if {$rate_string<=$max_rate_nb} {
            # Validate value for N
            set n_display_value [lindex $list_n $rate_string]
        
            set Z180 180
            set valid_lps [list]
            # Validate value for BITSPERSYMBOL
            set list_valid_lps    [list ]
            for {set ii 1} {$ii<40} {incr ii} {
                if {$Z180%$ii==0} {
                    lappend list_valid_lps $ii
                    lappend valid_lps $ii 1
                }  else {
                    lappend valid_lps $ii 0
                }
            }

            # Validate value for PAR
            set list_valid_par    [list $lps]
            for {set ii 2} {$ii*$lps<40} {incr ii} {
                if {$Z180%($ii*$lps)==0} {lappend list_valid_par [expr $ii*$lps]}
            }
        } else {
            set list_valid_par    [list ]
            set list_valid_lps    [list ]
            set n_display_value    [list ]
        }
        
        set list_valid_n "[ get_parameter_value N ]:$n_display_value"
        set list_valid_k "[ get_parameter_value K ]:0"
        set_parameter_property LLRPERSYMBOL ALLOWED_RANGES  $list_valid_lps
        set_parameter_property PAR          ALLOWED_RANGES  $list_valid_par
        
        # Throughput
        set rate_list [list 89 85 75]
        set base_latency [list 19 19 14]
        set code    [ get_parameter_value CODE ]
        set layer   [ get_parameter_value LAYER ]
        set extra   [ get_parameter_value EXTRALATENCY ]
        set n     [lindex $list_n $code]
        set z     [lindex $list_Z $code]
        set par   [ get_parameter_value PAR ]
        set lat   [lindex $base_latency $code]
        set rate   [lindex $rate_list $code]
        
        set t_in  [expr double($n)/$lps]
        set t_dec [expr $layer*(double($z)/$par + $lat + $extra)]
        set ratio [expr double($t_in)/$t_dec]     

        
        if {$ratio>1} {
            set thr  [expr double($rate*$lps)/100]
            send_message info "The Throughput is maximum for the code with rate $rate\%"

            set ratio_p1 [expr double($t_in)/($t_dec+$layer)] 
            if {$ratio_p1>1} {set p1 1} else {set p1 0}

            if {$extra !=4 && $p1==1} {
                send_message info "Consider adding some pipelining stages in order to increase Fmax"
            }
        } else {
            set thr  [expr $ratio*double($rate*$lps)/100]

            set ratio_m1 [expr double($t_in)/($t_dec-$extra*$layer)] 
            if {$ratio_m1>1} {set m1 1} else {set m1 0}

            if {$extra !=0 && $m1==1} {
                send_message warning "The maximum Throughput/Fmax ratio is [expr double($rate*$lps)/100] for this code rate and can be achieved by increasing paralellism and/or reducing the number of extra pipelining stages"
            } else {
                send_message warning "The maximum Throughput/Fmax ratio is [expr double($rate*$lps)/100] for this code rate and can be achieved by increasing paralellism"
            }       
        }
        set_parameter_value THROUGHPUT [format "%.2f" $thr] 
        # Validate value for CODE
        set list_valid_code $list_valid_rate
            
    }
    
    # throw error message for wrong rate
    if {$rate_string>$max_rate_nb} {    
        lappend list_valid_rate "$rate_string:Rate"
        send_message error "Choose a valid rate"
    }
    set_parameter_property RATE ALLOWED_RANGES $list_valid_rate
    set_parameter_property CODE ALLOWED_RANGES  $list_valid_code 

    if {$n_string>$max_n_nb} {
        lappend list_valid_n "$n_string:N"
        send_message error "Choose a valid codeword length"
    }
    set_parameter_property N ALLOWED_RANGES $list_valid_n
    
    
    set_parameter_property K ALLOWED_RANGES $list_valid_k
    
    # Validate value for CHANNEL
    set_parameter_property CHANNEL ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16}  
    
}

# |
# +---------------------------------------------------

proc get_DVB_matrixnumber {n rate} {
    return [expr $rate+$n*11]
}


proc get_DVB_parameters {nbcheckgroupVar nbvargroupVar nVar number} {

    upvar  $nbcheckgroupVar   nbcheckgroup
    upvar  $nbvargroupVar     nbvargroup
    upvar  $nVar              n 
    
        set qlist [ list 135 120 108 90 72  60  45  36  30  20  18  36 30 27 25 18 15 12 10 8  5 ]
        set plist [ list  45 60  72  90 108 120 135 144 150 160 162 9  15 18 20 27 30 33 35 37 40 ]
        set nbcheckgroup [lindex $qlist $number]
        set nbvargroup [lindex $plist $number]
        if {$number<11} {set n 64800} else {set n 16200}
}

proc get_DOCSIS_parameters {nbcheckgroupVar nbvargroupVar nVar number} {

    upvar  $nbcheckgroupVar   nbcheckgroup
    upvar  $nbvargroupVar     nbvargroup
    upvar  $nVar              n
    
    set qlist [ list 45 33 20 ]    
    set nbvargroup [lindex $qlist $number]
    set nbcheckgroup 5 
    set nlist     [list 16200 5940 1120]
    set n [lindex $nlist $number] 
}

proc get_Wimedia_parameters {nbcheckgroupVar nbvargroupVar nVar n_number rate_number isencoder} {

    upvar  $nbcheckgroupVar   nbcheckgroup
    upvar  $nbvargroupVar     nbvargroup
    upvar  $nVar              n 
    set qlist [ list 12 14 19 24 ]   
    set plist [ list 32 30 25 20 ] 
    if {$isencoder} {
        set nbvargroup [lindex $plist $rate_number]
    } else {
        set nbvargroup 44
    }
    set nbcheckgroup [lindex $qlist $rate_number]
    if {$n_number==0} {set n 1320} else {set n 1200}

}


proc get_NASA_parameters {nbcheckgroupVar nbvargroupVar nVar n_number isencoder} {

    upvar  $nbcheckgroupVar   nbcheckgroup
    upvar  $nbvargroupVar     nbvargroup
    upvar  $nVar             n
    
    set nbcheckgroup 2
    set nbvargroup   [expr 16 - 2* $isencoder]
    if {$n_number==0} {set n 8176} else {set n 8160}
}


# |
# +---------------------------------------------------


proc add_filesets {top_level} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset"
        set_fileset_property $fileset TOP_LEVEL $top_level
    }
}

proc generate_quartus_synth {entity} {
    generate synth $entity
}

proc generate_sim_verilog {entity} {
    generate sim $entity
}

proc generate_sim_vhdl {entity} {
    generate sim $entity
}


proc add_encrypted_file {type filename {path "."} {simulator_list ""}} {
    if {$simulator_list == ""} {
        set simulator_list [get_simulator_list]
    }
    set is_ocp [string equal [file extension $filename] ".ocp"]
    if {$type == "sim"} {
        if {$is_ocp} {
            return
        }
        set add_clear_file 0
        foreach simulator $simulator_list {
            set sim [lindex $simulator 0]
            set supported [lindex $simulator 1]
            if {$supported} {
                set specific "[string toupper $sim]_SPECIFIC"
                add_fileset_file $sim/$filename SYSTEM_VERILOG_ENCRYPT PATH $path/$sim/$filename $specific
            } else {
                set add_clear_file 1
            }
        }
        if {$add_clear_file} {
            add_fileset_file $filename SYSTEM_VERILOG PATH $path/$filename
        }
    } else {
        if {$is_ocp} {
            add_fileset_file $filename OTHER PATH $path/$filename
        } else {
            add_fileset_file $filename SYSTEM_VERILOG PATH $path/$filename
        }
    }
}
