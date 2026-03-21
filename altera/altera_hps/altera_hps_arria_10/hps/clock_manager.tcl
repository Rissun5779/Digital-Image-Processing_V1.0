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


#
# Clock manager parameters & PLL solver.   
#
# This file is included into altera_hps_hw.tcl for hps.xml generation, 
# as well as logical view clkmgr_hw.tcl for device tree generation.
#
# Author: Alberto Cid
#

#source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util pll_model.tcl]
#source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util math.tcl]


## Global stuff
proc unused_counter {} {
    return 900
}

proc add_adaptable_parameter { adapt group name display_name value { derived false } { range { } } } {
    
    # $adapt list contains the adaptation rule as follows: 
    #
    # 0: the name of a list used for storing this pair of parameters
    # 1: data type of original parameter 
    # 2: unit of original parameter
    # 3: suffix for original parameter's name
    # 4: data type of derived parameter 
    # 5: unit of derived parameter
    # 6: suffix for derived parameter's name
    # 7: parameter to display, 0=original, 1=derived. 
    #    0 as default, the unselected one is always hidden.
    
    set type_map_ref [ lindex $adapt 0 ]
    
    set from_type   [ lindex $adapt 1 ]
    set from_unit   [ lindex $adapt 2 ]
    set from_suffix [ lindex $adapt 3 ]
    
    if { [ string length $from_suffix ] > 0 } {
        set from_name ${name}_${from_suffix}
    } else {
        set from_name $name 
    }
        
    set to_type     [ lindex $adapt 4 ]
    set to_unit     [ lindex $adapt 5 ]
    set to_suffix   [ lindex $adapt 6 ]
    
    if { [ string length $to_suffix ] > 0 } {
        set to_name ${name}_${to_suffix}
    } else {
        set to_name $name   
    }

    upvar $type_map_ref type_map
    lappend type_map [ list $from_name $to_name ]

    set from_display_name   $from_name
    set from_visible    true
    set to_display_name $to_name
    set to_visible      true

    if { [ lindex $adapt 7 ] == 0 } {
        set from_display_name   $display_name
        set to_visible      false
    }

    if { [ lindex $adapt 7 ] == 1 } {
        set from_visible    false
        set to_display_name $display_name
    }
    
    add_parameter2 $group $from_name $from_display_name $from_type $value $from_unit $derived $range
    set_parameter_property $from_name VISIBLE $from_visible

    add_parameter2 $group $to_name $to_display_name $to_type $value $to_unit true
    set_parameter_property $to_name VISIBLE $to_visible
}


proc add_parameter2 { group name display_name type value { unit None } { derived false } { range { } } } {
    add_parameter $name $type
    if { $derived } {
        # Do not set default value if it's derived
    } else {
        set_parameter_property $name DEFAULT_VALUE $value
    }
    set_parameter_property $name DISPLAY_NAME $display_name
    set_parameter_property $name TYPE $type
    set_parameter_property $name UNITS $unit
    if { [ llength $range] > 0 } {  
        set_parameter_property $name ALLOWED_RANGES $range
    }
    #   set_parameter_property $name DESCRIPTION ""
    #   set_parameter_property $name AFFECTS_GENERATION false
    set_parameter_property $name DERIVED $derived
    add_display_item $group $name PARAMETER
}

proc validate_clocks { } {
    
    refresh_parameter_ui
    
    
    #Make sure the EMAC is using the correct clocks
    set use_mpu_clk [get_parameter_value USE_DEFAULT_MPU_CLK]
    if { $use_mpu_clk } {
        set requested_mpu_freq [get_parameter_value CUSTOM_MPU_CLK ]
        
        set default_mpu_freq [get_mpu_freq max_vco_freq l3_main_free_clk_max_freq cv_freq]
        
        if { $requested_mpu_freq > $default_mpu_freq} {
            send_message error "Overclocking not supported. Cannot set MPU frequency to $requested_mpu_freq MHz. It exceeds the maximum operating speed of $default_mpu_freq MHz supported by this part."
        }
    }

}

proc refresh_parameter_ui { } {
    
}

proc get_mpu_freq { max_vco_freq_ref l3_main_free_clk_max_freq_ref cv_freq_ref} {
    upvar 1 $max_vco_freq_ref max_vco_freq
    upvar 1 $l3_main_free_clk_max_freq_ref l3_main_free_clk_max_freq
    upvar 1 $cv_freq_ref cv_freq
    
    set device           [get_device]
    #send_message debug "Got device: ${device}"

    set recomended_mpu_freq       800
    set max_vco_freq             1600 
    set l3_main_free_clk_max_freq 400
    set cv_freq                    30
    
    set speed_grade [::pin_mux_db::get_speed_grade $device ]
    set mpu_vssl [get_parameter_value MPU_CLK_VCCL]
    if {[ regexp {^10A.+E[S2]$} $device match ]  } {
        set engineering_sample 1
    } else {
        set engineering_sample 0
    }

    # case 429029 Allow -2S ordering codes with "HZ" Suffix to run HPS at 1.5GHz
    # hard coded list only for 16.1.2. 
    if {[ regexp {HZ$} $device match ] && $speed_grade == 2 } {
        set recomended_mpu_freq      1500
        set max_vco_freq             3000 
        set l3_main_free_clk_max_freq 500
        set cv_freq                   100
        
        return $recomended_mpu_freq
    }

    #send_message debug "MATCH ES=$engineering_sample  speed grade=$speed_grade "
    ########### ES & ES2 ##########################
    if {$engineering_sample && $speed_grade == 1  } {
        
        if {$mpu_vssl == 0} {
            set recomended_mpu_freq      1200
            set max_vco_freq             2400 
            set l3_main_free_clk_max_freq 400
            set cv_freq                    60 
        } else {
            set recomended_mpu_freq      1500
            set max_vco_freq             3000 
            set l3_main_free_clk_max_freq 500
            set cv_freq                   100
        }
    } elseif {$engineering_sample && $speed_grade == 2 } {
        set recomended_mpu_freq          1200
        set max_vco_freq                 2400 
        set l3_main_free_clk_max_freq     400
        set cv_freq                        60
    } elseif {$engineering_sample && $speed_grade == 3 } {
        set recomended_mpu_freq           800
        set max_vco_freq                 1600 
        set l3_main_free_clk_max_freq     400
        set cv_freq                        30
    ########### Production ##########################
    } elseif {!$engineering_sample && $speed_grade == 1 } {
        if {$mpu_vssl == 0} {
            set recomended_mpu_freq      1000
            set max_vco_freq             2000 
            set l3_main_free_clk_max_freq 400
            set cv_freq                    60        
        } else {
            set recomended_mpu_freq      1500
            set max_vco_freq             3000 
            set l3_main_free_clk_max_freq 500
            set cv_freq                   100
        }
    } elseif {!$engineering_sample && $speed_grade == 2} {
        if {$mpu_vssl == 0} {
            set recomended_mpu_freq      1000
            set max_vco_freq             2000 
            set l3_main_free_clk_max_freq 400
        } else {
            set recomended_mpu_freq      1200
            set max_vco_freq             2400 
            set l3_main_free_clk_max_freq 400
        }
        set cv_freq                        60
    } elseif {!$engineering_sample && $speed_grade == 3} {
        if {$mpu_vssl == 0} {
            set recomended_mpu_freq       800
            set max_vco_freq             1600 
            set l3_main_free_clk_max_freq 400
        } else {
            set recomended_mpu_freq      1000
            set max_vco_freq             2000 
            set l3_main_free_clk_max_freq 400
        }
        set cv_freq                        30
    } else {
        send_message error "Unsupported device ${device} (this is a bug) $speed_grade $engineering_sample"
    }
    #send_message debug "Cloks: MPU=$recomended_mpu_freq VCO=$max_vco_freq l3=$l3_main_free_clk_max_freq"
    return $recomended_mpu_freq
}

proc update_hps_to_fpga_clock_frequency_parameters {} {
    
    set ini_string            [get_parameter_value quartus_ini_hps_ip_enable_a10_advanced_options]
    set advanced_options      [ expr { [string compare $ini_string "true" ] == 0 } ]    
    
    set_parameter_property DISABLE_PERI_PLL           visible $advanced_options
    set_parameter_property OVERIDE_PERI_PLL           visible $advanced_options
    set_parameter_property PERI_PLL_AUTO_VCO_FREQ     visible $advanced_options
    set_parameter_property PERI_PLL_MANUAL_VCO_FREQ   visible $advanced_options
    set_parameter_property CLK_NOC_SOURCE             visible $advanced_options
    set_parameter_property CLK_MPU_SOURCE             visible $advanced_options
    set_parameter_property EMAC_PTP_REF_CLK           visible $advanced_options
    set_parameter_property SDMMC_REF_CLK              visible $advanced_options
    set_parameter_property GPIO_REF_CLK               visible $advanced_options
    #set_parameter_property HMC_PLL_REF_CLK           visible $advanced_options
    set_parameter_property INTERNAL_OSCILLATOR_ENABLE visible $advanced_options
    
    set u0 [get_parameter_value H2F_USER0_CLK_Enable]
    set u1 [get_parameter_value H2F_USER1_CLK_Enable]

    for { set i 0 } { $i < 2 } { incr i } {
        set_parameter_property "H2F_USER${i}_CLK_FREQ" enabled [expr "\$u${i}"]

        if { [string compare true [expr "\$u${i}"] ] == 0 } {
            fpga_interfaces::set_interface_property "h2f_user${i}_clock" clockRateKnown true
            fpga_interfaces::set_interface_property "h2f_user${i}_clock" clockRate [expr [get_parameter_value "H2F_USER${i}_CLK_FREQ"] * 1000000 ]
        }
    }
    set use_mpu_clk [get_parameter_value USE_DEFAULT_MPU_CLK]
    set default_mpu_freq [get_mpu_freq max_vco_freq l3_main_free_clk_max_freq cv_freq]
    
    validate_l3_noc_clk $l3_main_free_clk_max_freq
    
    set_parameter_property CUSTOM_MPU_CLK enabled $use_mpu_clk
    set_parameter_value DEFAULT_MPU_CLK  $default_mpu_freq
    
    set use_f2h_clk [get_parameter_value F2H_FREE_CLK_Enable]
    set_parameter_property F2H_FREE_CLK_FREQ enabled $use_f2h_clk
    
    if { $use_mpu_clk } {
        set requested_mpu_freq [get_parameter_value CUSTOM_MPU_CLK ]
    } else {
        set requested_mpu_freq $default_mpu_freq
    }
    
    set clk_source [list [EOSC1_VCO]  ]
    if {$use_f2h_clk} {
        lappend clk_source [F2S_VCO]
    } 
    
    if {$advanced_options} {
        lappend clk_source [CB_VCO]
    }

    set_parameter_property        CLK_MAIN_PLL_SOURCE2  allowed_ranges   $clk_source
    set_parameter_property        CLK_PERI_PLL_SOURCE2  allowed_ranges   $clk_source
    
    set main_pll_clock_source [get_parameter_value CLK_MAIN_PLL_SOURCE2 ]
    
    if { [string first $main_pll_clock_source [EOSC1_VCO]] != -1 } {
        set pll_input_freq [get_parameter_value eosc1_clk_mhz ]
    } elseif {[string first $main_pll_clock_source [F2S_VCO]] != -1  } {
        set pll_input_freq [get_parameter_value F2H_FREE_CLK_FREQ ]
    } elseif {[string first $main_pll_clock_source [CB_VCO]] != -1   } {
        set pll_input_freq [get_parameter_value INTERNAL_OSCILLATOR_ENABLE ]
        #set pll_input_freq $cv_freq
        send_message warning "input clock for main PLL: $main_pll_clock_source of $cv_freq has bad jitter and migth not be precise"
    } else {
        set pll_input_freq 10
        send_message error "Unsupported input clock for main PLL: $main_pll_clock_source (this is a bug)"
    }
    
    pll_calculate_values $pll_input_freq  $requested_mpu_freq $use_f2h_clk $advanced_options 

}



proc validate_l3_noc_clk { l3_main_free_clk_max_freq } {
    
    set l3_clk [get_parameter_value L3_MAIN_FREE_CLK]
    
    if { $l3_clk != $l3_main_free_clk_max_freq } {
        send_message info "HPS NOC (L3 clock) is set to $l3_clk MHz When the Max Speed for this part is $l3_main_free_clk_max_freq MHz."
    }
    
}

proc pin_mux_feature_is_enabled { pin_mux_parm } {
    if {[get_parameter_value $pin_mux_parm] == [UNUSED_MUX_VALUE] } {
        set is_enabled 0
    } else {
        set is_enabled 1
    }
    return $is_enabled
}
proc pll_calculate_values { input_freq requested_mpu_freq   use_f2h_clk advanced_options } {
    
    set default_mpu_freq [get_mpu_freq VCO_max l3_main_free_clk_max_freq cv_freq]
    
    # The MPU speed sets the main PLL VCO
    set m_c_0 [ expr { ceil (($VCO_max / $requested_mpu_freq) -1) } ]
    set main_pll_vco [ expr { $requested_mpu_freq * ($m_c_0 + 1) } ]
    
    pll_calculate_single_values $main_pll_vco $input_freq $m_c_0 $requested_mpu_freq m n computed_out_freq

    set msg_c0 [ format_pll_message "MPU base (C0)" $requested_mpu_freq $computed_out_freq $m_c_0 "Main PLL"]
    #send_message info "Main PLL: m=$m n=$n VCO=$main_pll_vco MHz"
    set_parameter_value MAINPLLGRP_VCO_DENOM $n
    set_parameter_value MAINPLLGRP_VCO_NUMER $m
    set_parameter_value MAINPLLGRP_MPU_CNT   $m_c_0

    ## Now that we have the main_pll_vco, generate the posible values:
    ## type the clock and get the aproximation.
    set l3_clk [get_parameter_value L3_MAIN_FREE_CLK]
    set m_c_l3 [ expr { ceil (($main_pll_vco / $l3_clk) -1) } ]
    set l3_computed [ expr { $main_pll_vco / ($m_c_l3 + 1)}]

    set msg_c1 [ format_pll_message "NOC base (C1) set by L3 Clock" $l3_clk $l3_computed $m_c_l3 "Main PLL"]
    set_parameter_value MAINPLLGRP_NOC_CNT   $m_c_l3
    
    #####
    set l3_med_clk [ expr { $l3_main_free_clk_max_freq / 2 }]
    set l3_slow_clk [ expr { $l3_main_free_clk_max_freq / 4 }]
    
    set list_for_l4_sys [list]
    foreach { div  index} [ list 2 0 4 1] {
        set div_freq [ expr { $l3_computed / $div } ]
        if { $l3_slow_clk >= $div_freq } {
            lappend list_for_l4_sys "$index:$div_freq"
        }
    }
    set_parameter_property  L4_SYS_FREE_CLK allowed_ranges $list_for_l4_sys

    set list_for_l4_fast [list]
    set list_for_l4_med  [list]
    set list_for_l4_slow [list]
    foreach { div index } [ list 1 0 2 1 4 2 8 3 ] {
        set div_freq [ expr { $l3_computed / $div } ]
        if { $l3_main_free_clk_max_freq >= $div_freq } {
            lappend list_for_l4_fast "$index:$div_freq"
        }
        if { $l3_med_clk >= $div_freq } {
            lappend list_for_l4_med "$index:$div_freq"
        }
        if { $l3_slow_clk >= $div_freq } {
            lappend list_for_l4_slow "$index:$div_freq"
        }
    }
    set_parameter_property  NOCDIV_L4MAINCLK allowed_ranges $list_for_l4_fast
    set_parameter_property  NOCDIV_L4MPCLK   allowed_ranges $list_for_l4_med
    set_parameter_property  NOCDIV_L4SPCLK   allowed_ranges $list_for_l4_slow
    set_parameter_property  NOCDIV_CS_ATCLK  allowed_ranges $list_for_l4_fast
    
    foreach { div index } [ list 1 0 2 1 4 2 8 3 ] {
    if {[get_parameter_value NOCDIV_CS_ATCLK ] == $index } {
            set cs_div $div
        }
    }   
    set cs_clk [ expr { $l3_computed / $cs_div } ]
    set list_for_cs_pdbg [list]
    foreach { div index } [ list 1 0 4 1 ] {
        set div_freq [ expr { $cs_clk / $div } ]
        if { $l3_slow_clk >= $div_freq } {
            lappend list_for_cs_pdbg "$index:$div_freq"
        }
    }
    set_parameter_property  NOCDIV_CS_PDBGCLK allowed_ranges $list_for_cs_pdbg
    
    set list_for_cs_trace [list]
    foreach { div index } [ list 1 0 2 1 4 2 8 3  ] {
        set div_freq [ expr { $cs_clk / $div } ]
        if { $l3_main_free_clk_max_freq >= $div_freq } {
            lappend list_for_cs_trace "$index:$div_freq"
        }
    }
    set_parameter_property  NOCDIV_CS_TRACECLK allowed_ranges $list_for_cs_trace
    
    ###################################################################################
    set pll_gpio_hz [ expr { [get_parameter_value GPIO_REF_CLK ] * 1000000 }  ]
    #send_message debug "pll_gpio_hz ${pll_gpio_hz}"
    set gpio_base_freq [ get_parameter_value HPS_DIV_GPIO_FREQ ]

    set gpio_counter [ expr { $pll_gpio_hz / $gpio_base_freq }  ]
    set_parameter_value  CONFIG_HPS_DIV_GPIO  $gpio_counter
    send_message debug "gpio_counter ${gpio_counter}"
    
    ###################################################################################
    # Check if we need to use the 2nd PLL.
    set_parameter_value PERPLLGRP_NOC_CNT [unused_counter]
    set_parameter_value PERPLLGRP_MPU_CNT [unused_counter]
    if {  [get_parameter_value DISABLE_PERI_PLL] } {
        ## In this case
        send_message debug "Peripherial  PLL  DISABLED"
        set_parameter_value PERPLLGRP_VCO_DENOM 64
        set_parameter_value PERPLLGRP_VCO_NUMER 4096

        set clk_source [list  [MAIN_PLL]  ]
        set peri_pll_vco $main_pll_vco
        
        set_parameter_property PERI_PLL_MANUAL_VCO_FREQ enabled false
        set_parameter_property OVERIDE_PERI_PLL         enabled false
        set_parameter_property PERI_PLL_AUTO_VCO_FREQ   enabled false
        
        set msg_per "<tr><td>Peripherial PLL is disabled</td><td></td><td></td><td></td></tr>"
    } else {
    
        #TODO let user overide VCO???
        set_parameter_property OVERIDE_PERI_PLL enabled true
        set_parameter_property PERI_PLL_AUTO_VCO_FREQ enabled true
        send_message debug "Peripherial  PLL  ENABLED"
        set peripherial_pll_freq [compute_freq_for_periferial_pll $VCO_max]
        set_parameter_value PERI_PLL_AUTO_VCO_FREQ  [ expr $peripherial_pll_freq * 2 ]
        set overide_peri_vco [get_parameter_value OVERIDE_PERI_PLL]
        set_parameter_property PERI_PLL_MANUAL_VCO_FREQ enabled $overide_peri_vco
        if {$overide_peri_vco} {
            set peripherial_pll_freq [ expr [get_parameter_value PERI_PLL_MANUAL_VCO_FREQ] / 2 ]
        }
        
        set emac_c   [ expr { ceil(($VCO_max/$peripherial_pll_freq) -1) } ]
        set peri_pll_vco [ expr {  $peripherial_pll_freq *($emac_c+1)        } ]
        
        set peri_pll_clock_source [get_parameter_value CLK_PERI_PLL_SOURCE2 ]
        
        if { [string first $peri_pll_clock_source [EOSC1_VCO] ]  != -1   } {
            set peri_input_freq [get_parameter_value eosc1_clk_mhz ]
        } elseif {[string first $peri_pll_clock_source [F2S_VCO] ]  != -1 } {
            set peri_input_freq [get_parameter_value F2H_FREE_CLK_FREQ ]
        } elseif {[string first $peri_pll_clock_source [CB_VCO] ]  != -1  } {
            set peri_input_freq $cv_freq
            send_message warning "input clock for Peripherial PLL: $peri_pll_clock_source of $cv_freq has bad jitter and migth not be precise"
        } else {
            set peri_input_freq 10
            send_message error "Unsupported input clock for Peripherial PLL: $peri_pll_clock_source (this is a bug)"
        }
        pll_calculate_single_values $peri_pll_vco  $peri_input_freq $emac_c $peripherial_pll_freq m_phery n_phery computed_out_freq_phery
        #send_message info "Peripherial PLL: m=$m_phery n=$n_phery VCO=$peri_pll_vco "
        set msg_per "<tr><td>Peripherial PLL</td><td>M Counter=[format {%0.0f} $m_phery ] </td><td>N Counter=$n_phery </td><td>VCO = $peri_pll_vco MHz</td></tr>"
        
        set_parameter_value PERPLLGRP_VCO_DENOM $n_phery
        set_parameter_value PERPLLGRP_VCO_NUMER $m_phery
        
        set clk_source [list  [MAIN_PLL] [PERI_PLL]  ]
    }
    if {$use_f2h_clk} {
        lappend clk_source [F2S_FREE]
    }

    if {$advanced_options} {
        lappend clk_source  [EOSC1]
        lappend clk_source  [CB]
    }


    foreach parm_name  {CLK_S2F_USER0_SOURCE CLK_S2F_USER1_SOURCE  CLK_HMC_PLL_SOURCE 
                        CLK_SDMMC_SOURCE     CLK_EMAC_PTP_SOURCE   CLK_GPIO_SOURCE
                        CLK_EMACA_SOURCE     CLK_EMACB_SOURCE      CLK_NOC_SOURCE
                        CLK_MPU_SOURCE     } {
        set_parameter_property   $parm_name  allowed_ranges   $clk_source
    }
    
    set sdmmc_ena [ pin_mux_feature_is_enabled SDMMC_PinMuxing ]
    set_parameter_property CLK_SDMMC_SOURCE enabled $sdmmc_ena
    
    set u0_ena [get_parameter_value H2F_USER0_CLK_Enable]
    set_parameter_property CLK_S2F_USER0_SOURCE enabled $u0_ena
    
    set u1_ena [get_parameter_value H2F_USER1_CLK_Enable]
    set_parameter_property CLK_S2F_USER1_SOURCE enabled $u1_ena
    
    set ddr_ena [get_parameter_value EMIF_CONDUIT_Enable]   
    set_parameter_property CLK_HMC_PLL_SOURCE enabled $ddr_ena
    set_parameter_property HMC_PLL_REF_CLK    enabled $ddr_ena
    
    emac_clock_sources emaca_clk emacb_clk emaca_ena emacb_ena any_emac_ena
    set_parameter_property CLK_EMACA_SOURCE    enabled $any_emac_ena
    set_parameter_property CLK_EMACB_SOURCE    enabled $any_emac_ena
    set_parameter_property CLK_EMAC_PTP_SOURCE enabled $any_emac_ena

    
    set msg ""
    set msg "$msg <tr><td><b>Feature (Pll Counter)</b></td><td><b>Requested Frequency</b></td><td><b>Actual Frequency</b></td><td><b>PLL C counter</b></td><td><b>Source PLL</b></td></tr> $msg_c0 $msg_c1"
    set no_msg ""
    compute_clock_sources "EMAC mux A (C2)" CLK_EMACA_SOURCE   $emaca_clk    MAINPLLGRP_EMACA_CNT PERPLLGRP_EMACA_CNT $main_pll_vco $peri_pll_vco $emaca_ena msg
    compute_clock_sources "EMAC mux B (C3)" CLK_EMACB_SOURCE   $emacb_clk    MAINPLLGRP_EMACB_CNT PERPLLGRP_EMACB_CNT $main_pll_vco $peri_pll_vco $emacb_ena msg
    ## emac PTP is always 100MHz
    compute_clock_sources "EMAC PTP   (C4)" CLK_EMAC_PTP_SOURCE  EMAC_PTP_REF_CLK   MAINPLLGRP_EMAC_PTP_CNT    PERPLLGRP_EMAC_PTP_CNT    $main_pll_vco $peri_pll_vco $any_emac_ena msg
    #TODO where are these speeds? do we ask the users?
    compute_clock_sources "GPIO clk   (C5)" CLK_GPIO_SOURCE      GPIO_REF_CLK       MAINPLLGRP_GPIO_DB_CNT     PERPLLGRP_GPIO_DB_CNT     $main_pll_vco $peri_pll_vco 1 msg
    compute_clock_sources "SDMMC clk  (C6)" CLK_SDMMC_SOURCE     SDMMC_REF_CLK      MAINPLLGRP_SDMMC_CNT       PERPLLGRP_SDMMC_CNT       $main_pll_vco $peri_pll_vco $sdmmc_ena msg
    
    ## Now computeh the PLL counter value and anotate them.
    compute_clock_sources "User 0 clk (C7)" CLK_S2F_USER0_SOURCE H2F_USER0_CLK_FREQ MAINPLLGRP_S2F_USER0_CNT   PERPLLGRP_S2F_USER0_CNT   $main_pll_vco $peri_pll_vco $u0_ena  msg
    compute_clock_sources "User 1 clk (C8)" CLK_S2F_USER1_SOURCE H2F_USER1_CLK_FREQ MAINPLLGRP_S2F_USER1_CNT   PERPLLGRP_S2F_USER1_CNT   $main_pll_vco $peri_pll_vco $u1_ena  msg
    #compute_clock_sources "HMC clk    (C9)" CLK_HMC_PLL_SOURCE   HMC_PLL_REF_CLK    MAINPLLGRP_HMC_PLL_REF_CNT PERPLLGRP_HMC_PLL_REF_CNT $main_pll_vco $peri_pll_vco $ddr_ena no_msg
    compute_unused_pll_counter MAINPLLGRP_HMC_PLL_REF_CNT
    compute_unused_pll_counter PERPLLGRP_HMC_PLL_REF_CNT
    compute_unused_pll_counter MAINPLLGRP_PERIPH_REF_CNT

    ##########################################
    set html_main "<html><table border=\"0\" width=\"100%\"><font size=3>$msg</table><b><center>Actual Frequency = VCO / (PLL C counter + 1)</center></b></html>"
    set_display_item_property MAIN_PLL_REPORT TEXT $html_main

    set msg "<tr><td>Main PLL</td><td>M Counter=[ format {%0.0f} $m ]</td><td>N Counter=$n</td><td>VCO = $main_pll_vco MHz</td></tr> $msg_per"
    set html_all "<html><table border=\"0\" width=\"100%\"><font size=3>$msg</table></html>"
    set_display_item_property ALL_PLL_REPORT TEXT $html_all
    
    
}

proc compute_unused_pll_counter { pll_cnt_param } {
    # Use this instead of proc compute_clock_sources if the counter is not used.
    set_parameter_value $pll_cnt_param [unused_counter]
}

proc emac_clock_sources { emaca_clk_ref emacb_clk_ref  emaca_ena_ref emacb_ena_ref any_emac_ena_ref} {  
    upvar 1 $emaca_clk_ref emaca_clk
    upvar 1 $emacb_clk_ref emacb_clk

    upvar 1 $emaca_ena_ref emaca_ena
    upvar 1 $emacb_ena_ref emacb_ena
    upvar 1 $any_emac_ena_ref any_emac_ena
    
    #emaca_clk is for 250
    set emaca_clk 250
    #emacb_clk is for  50
    set emacb_clk  50
    set emaca_ena 0
    set emacb_ena 0

    set any_emac_ena 0
    
    # EMAC0_CLK EMAC0_PinMuxing EMAC0_Mode
    for {set i 0} {$i < 3} {incr i} {
        set emac_clk   [ get_parameter_value EMAC${i}_CLK]  
        set emac_ena   [ pin_mux_feature_is_enabled EMAC${i}_PinMuxing ] 
        set emac_mode  [ get_parameter_value EMAC${i}_Mode ]  
        
        set_parameter_property EMAC${i}_CLK enabled $emac_ena
        
        if {$emac_ena} {

            if { $emac_mode == "RMII" || $emac_mode ==  "RMII_with_I2C"  || $emac_mode ==  "RMII_with_MDIO" } {
                set is_rmii 1
            } else {
                set is_rmii 0
            }

            if {$emac_clk == 250} {
                set_parameter_value EMAC${i}SEL [MUXA]
                set emaca_ena 1
                if {$is_rmii} {
                    send_message warning "EMAC${i} is in MII/RMII mode but has a 250MHz clock. 50MHz Clock is recommended"
                }
            } else {
                set_parameter_value EMAC${i}SEL [MUXB]
                set emacb_ena 1
                if {!$is_rmii} {
                    send_message warning "EMAC${i} is in GMII/RGMII mode but has a 50MHz clock. 250MHz Clock is recommended"
                }
            }
        }

        if {$emac_ena} {
            set any_emac_ena 1
        }
    }
}

proc compute_freq_for_periferial_pll { max_vco_freq } {

    if { $max_vco_freq > 2000 } {
        return 1000
    }

    if { [get_parameter_value EMAC0_CLK] == 250 || [ get_parameter_value EMAC1_CLK] == 250 || [get_parameter_value EMAC2_CLK] == 250 } {
        set reference_freq 500
    } else {
        set reference_freq 800
    }       
    return $reference_freq
}

proc compute_clock_sources { feature_name clk_source_parm clk_freq_parm mainpllgrp_parm peripllgrp_parm main_pll_vco peri_pll_vco is_used msg_ref } {
    upvar 1 $msg_ref msg
    
    if {!$is_used} {
        send_message debug "$msg $feature_name is disabled"
        set_parameter_value $mainpllgrp_parm [unused_counter]
        set_parameter_value $peripllgrp_parm [unused_counter]   
        set msg "$msg <tr><td>${feature_name} (disabled)</td><td> </td><td> </td><td> </td><td></td></tr>"
        return
    }
    
    set clk_source [get_parameter_value $clk_source_parm]
    set bypass_pll 0
    set vco [unused_counter]
    ## Check clock sources  

    if { [string first $clk_source [MAIN_PLL]] != -1  }  {
        set vco $main_pll_vco
    } elseif {[string first $clk_source [PERI_PLL]] != -1  } {
        set vco $peri_pll_vco
    } elseif { [string first $clk_source [EOSC1]] != -1  || [string first $clk_source [F2S_FREE]] != -1  || [string first $clk_source [CB]] != -1  } {
        set bypass_pll 1
        send_message warning "$feature_name is bypasing the PLL and using a fixed clock source!"
    } else {
        set bypass_pll 1
        send_message error "Invalid clock source $clk_source for $feature_name"
    }
    
    
    if {!$bypass_pll} {
        # Get settings for PLL counter
        if {[string is integer -strict $clk_freq_parm]} {
            set user_clk $clk_freq_parm
        } else {
            set user_clk [get_parameter_value $clk_freq_parm]
        }
        
        set c_counter [ expr { ceil (($vco / $user_clk) -1) } ]
        set user1_computed [ expr { $vco / ($c_counter + 1)}]

    }

    if {[string first $clk_source [MAIN_PLL]] != -1  } {
        set_parameter_value $mainpllgrp_parm $c_counter
        set_parameter_value $peripllgrp_parm [unused_counter]
        set pll_used "Main PLL"
    } elseif { [string first $clk_source [PERI_PLL]] != -1 } {
        set_parameter_value $mainpllgrp_parm [unused_counter]
        set_parameter_value $peripllgrp_parm $c_counter
        set pll_used "Perphery PLL"
    }   else {
        set_parameter_value $mainpllgrp_parm [unused_counter]
        set_parameter_value $peripllgrp_parm [unused_counter]
        set pll_used "PLL Bypassed"
    }       

    if {!$bypass_pll} {
        set m1 [ format_pll_message $feature_name $user_clk $user1_computed $c_counter $pll_used]
        set msg "$msg $m1"
    } else {
        set msg "$msg <tr><td>${feature_name} (disabled)</td><td> </td><td> </td><td> </td><td></td></tr>"
    }

}

proc format_pll_message { feature_name user_clk user1_computed c_counter pll_used } {
    set a0 ""
    set a1 ""
    if { $user_clk != $user1_computed} {
        set a0 "<font color=\"red\">"
        set a1 "</font>"
        send_message warning "Cannot meet requested frequency of $user_clk MHz for ${feature_name}. We can acheive $user1_computed MHz (PLL counter set to $c_counter )"
    }

    set msg "<tr><td>${feature_name}</td><td align=\"right\">${user_clk} MHz</td><td align=\"right\">${a0}[format {%0.3f} $user1_computed] MHz${a1}</td><td align=\"right\">[format {%0.0f} $c_counter ]</td><td>$pll_used</td></tr>"

    return $msg
}


proc pll_calculate_single_values { vco input_freq c out_freq m_ref n_ref computed_out_freq_ref} {
    upvar 1 $m_ref m
    upvar 1 $n_ref n
    upvar 1 $computed_out_freq_ref computed_out_freq
    
    set not_found_settings 1
    set computed_out_freq   -1

    set presition_vec [list]
    
    for {set n 1} {$n <= 32} {incr n} {
        pll_compute $n $vco $input_freq $c m computed_out_freq
        
        if { $computed_out_freq == $out_freq } {
            set not_found_settings 0
            break
        }
        
        set diference [  expr { abs($computed_out_freq - $out_freq ) } ]
        #send_message info "Not exact match found:computed_out_freq $computed_out_freq  out_freq $out_freq n = $n"
        
        lappend presition_vec $diference
    }
    
    if {$not_found_settings} {
        
        set n 1
        set i 1
        set smallest_diff 9999999
        foreach diference $presition_vec {
            if { $diference < $smallest_diff } {
                #send_message info "Not exact match found: diference $diference $i"
                set smallest_diff $diference
                set n $i
                pll_compute $n $vco $input_freq $c m computed_out_freq
            }
            incr i 
        }
    }
    
    # fix the rounding issue 
    set diferential [ expr {  abs( $out_freq - $computed_out_freq) }]
    if { $diferential < 0.0000000001 } {
        #send_message info "HPS: diferential $diferential "
        set computed_out_freq $out_freq
    }
    
}

proc pll_compute { n vco  input_freq c m_ref computed_out_freq_ref} {
    upvar 1 $m_ref m
    upvar 1 $computed_out_freq_ref computed_out_freq

    set m [ expr { ceil (((($n + 1) * $vco )/ $input_freq) -1 )}]
    set computed_out_freq [ expr { ( $input_freq * ($m + 1)) / (($n + 1)*($c + 1))} ]
}


proc add_clock_tab { parent_tab } {

    global mhz_to_hz_map
    set input_mhz_to_hz_map         [ list mhz_to_hz_map float MEGAHERTZ mhz integer HERTZ hz 0 ]
    set input_mhz_compat_to_hz_map  [ list mhz_to_hz_map float MEGAHERTZ "" integer HERTZ HZ 0 ]

    global hz_to_mhz_map
    set hz_to_display_mhz_map        [ list hz_to_mhz_map integer HERTZ hz float MEGAHERTZ mhz 1 ]
    set hz_compat_to_display_mhz_map [ list hz_to_mhz_map integer HERTZ "" float MEGAHERTZ MHZ 1 ]
    
    ################################################################################
    # Clock source and interface tab
    ################################################################################
    set clock_source_tab                "Input Clocks"
    set clock_source_external_group     "External Clock Source"
    set clock_source_internal_mux_group "Clock Sources"
    set clock_source_f2h_group          "FPGA-to-HPS Clocks Source"
    add_display_item $parent_tab $clock_source_tab  GROUP TAB
    #
    # External clocks group
    #
    add_display_item $clock_source_tab $clock_source_external_group  GROUP
    add_adaptable_parameter $input_mhz_to_hz_map $clock_source_external_group eosc1_clk "EOSC clock frequency" 25 false 10:50
    set_parameter_property   eosc1_clk_mhz        description "Sets the External OSCillator clock frequency connected to the dedicated HPS input clock pin"


    add_parameter2 $clock_source_external_group INTERNAL_OSCILLATOR_ENABLE "Internal oscillator clock frequency" integer 60 Megahertz false {1:1000}
    set_parameter_property INTERNAL_OSCILLATOR_ENABLE description  "Enable the Internal oscillator "
    set_parameter_property INTERNAL_OSCILLATOR_ENABLE visible false
    #
    # FPGA-to-HPS clocks group
    #
    add_display_item $clock_source_tab $clock_source_f2h_group  GROUP
    add_parameter2 $clock_source_f2h_group F2H_FREE_CLK_Enable "Enable FPGA-to-HPS free clock" boolean false
    set_parameter_property  F2H_FREE_CLK_Enable description  "Enables the HPS PLL and clock network to be driven clock sources from the FPGA fabric instead of the dedicated HPS input clock pin."

    # TODO: rename these to F2SCLK_*CLK_FREQ_HZ so that we can have consistent *_HZ/*_MHZ parameter name suffix
    ##add_adaptable_parameter $hz_compat_to_display_mhz_map $clock_source_f2h_group F2H_FREE_CLK_FREQ "FPGA-to-HPS reference free clock frequency" 25 true 10:150
    add_parameter2 $clock_source_f2h_group F2H_FREE_CLK_FREQ "FPGA-to-HPS clock frequency" integer 200 Megahertz false {10:1500}
    set_parameter_property  F2H_FREE_CLK_FREQ description  "Clock frequency of the clock coming from the FPGA"
    #set_parameter_property  F2H_FREE_CLK_FREQ SYSTEM_INFO { CLOCK_RATE f2h_periph_ref_clock }

    #############
    set group_name "FPGA Interface Clocks"
    add_display_item $clock_source_tab $group_name "group" ""

    foreach interface {
        f2h_axi_clock           h2f_axi_clock           h2f_lw_axi_clock
        f2h_sdram0_clock        f2h_sdram1_clock        f2h_sdram2_clock
        f2h_sdram3_clock        f2h_sdram4_clock        f2h_sdram5_clock
        h2f_cti_clock           h2f_tpiu_clock_in       h2f_debug_apb_clock
    } {
        set parameter "[string toupper ${interface}]_FREQ"
        add_parameter          $parameter integer 100 ""
        set_parameter_property $parameter display_name  "${interface} clock frequency"
        set_parameter_property $parameter system_info_type "CLOCK_RATE"
        set_parameter_property $parameter system_info_arg $interface
        set_parameter_property $parameter visible false
        set_parameter_property $parameter group $group_name
        set_parameter_property $parameter description "If this peripheral pin multiplexing is configured to route to FPGA fabric, use this field to specify the clock frequency"
    }

    set peripherals [list_peripheral_names]

    set group_name "Peripheral FPGA Clocks"
    add_display_item $clock_source_tab $group_name "group" ""

    # Add parameter explicitly for cross-emac ptp since it doesn't belong to a single peripheral
    set parameter [form_peripheral_fpga_input_clock_frequency_parameter emac_ptp_ref_clock]
    add_parameter          $parameter integer 100 ""
    set_parameter_property $parameter display_name  "EMAC emac_ptp_ref_clock clock frequency"
    set_parameter_property $parameter group $group_name
    set_parameter_property $parameter system_info_type "CLOCK_RATE"
    set_parameter_property $parameter system_info_arg emac_ptp_ref_clock
    set_parameter_property $parameter visible false

    foreach peripheral $peripherals {
        set clocks [get_peripheral_fpga_input_clocks $peripheral]
        foreach clock $clocks {
            set parameter [form_peripheral_fpga_input_clock_frequency_parameter $clock]
            add_parameter          $parameter integer 100 ""
            set_parameter_property $parameter display_name  "${peripheral} ${clock} input clock frequency"
            set_parameter_property $parameter group $group_name
            set_parameter_property $parameter system_info_type "CLOCK_RATE"
            set_parameter_property $parameter system_info_arg $clock
            set_parameter_property $parameter visible false
            set_parameter_property $parameter description "If this peripheral pin multiplexing is configured to route to FPGA fabric, use this field to specify the ${peripheral} ${clock} clock frequency"
        }

        set clocks [get_peripheral_fpga_output_clocks $peripheral]
        foreach clock $clocks {
            set parameter [form_peripheral_fpga_output_clock_frequency_parameter $clock]
            
            if { [string match "*emac?_md*" $clock] } {
                add_parameter          $parameter float 2.5 ""
                set_parameter_property $parameter allowed_ranges {0:100}
                set_parameter_property $parameter description "If this peripheral pin multiplexing is configured to route to FPGA fabric, use this field to specify the ${peripheral} ${clock} (Management MDIO Serial Interface) clock frequency"
            } else {
                add_parameter          $parameter integer 100 ""
                set_parameter_property $parameter allowed_ranges {1:1000}
                set_parameter_property $parameter description "If this peripheral pin multiplexing is configured to route to FPGA fabric, use this field to specify the ${peripheral} ${clock} clock frequency"
            }
            set_parameter_property $parameter display_name  "${peripheral} ${clock} clock frequency"
            set_parameter_property $parameter group $group_name
            set_parameter_property $parameter units Megahertz
            
        }
    }

    ################################################################################
    # Output clocks tab
    ################################################################################
    
    set clock_output_tab    "Internal Clocks and Output Clocks"
    set clock_output_user_clks_group    "HPS to FPGA User Clocks"
    add_display_item $parent_tab $clock_output_tab GROUP TAB

    set clock_output_main_pll_group     "Main PLL Output Clocks - Desired Frequencies" 
    add_display_item $clock_output_tab $clock_output_main_pll_group GROUP
        
    add_parameter2 $clock_output_main_pll_group DEFAULT_MPU_CLK "Default MPU clock frequency" integer 800 Megahertz true
    set_parameter_property  DEFAULT_MPU_CLK description "Indicates the clock frequency the HPS can run on this device."

    add_parameter2 $clock_output_main_pll_group MPU_CLK_VCCL "VCCL_HPS Value" integer 0 none false { "0:0.9V" "1:0.95V" }
    set_parameter_property  MPU_CLK_VCCL description "This Indicates the VCCL_HPS (HPS Voltage) for this speed grade. For the fastest speed grade (-1), connect the VCCL_HPS to a 0.95V power supply to get the highest MPU clock frequency. This value must match the VCCL_HPS value in the Quartus Voltage configuration settings."

    add_parameter2 $clock_output_main_pll_group USE_DEFAULT_MPU_CLK "Override default MPU clock frequency" boolean false
    set_parameter_property  USE_DEFAULT_MPU_CLK description "Enables the option to use a custom frequency to run the MPU"
    
    add_parameter2 $clock_output_main_pll_group CUSTOM_MPU_CLK  "Custom MPU clock frequency"  integer 800 Megahertz false {10:1500}
    set_parameter_property  CUSTOM_MPU_CLK description "Custom MPU clock frequency"
    
    add_display_item $clock_output_tab $clock_output_user_clks_group   "group" ""
    #### Group => User Clocks ####
    add_parameter           H2F_USER0_CLK_Enable boolean false ""
    set_parameter_property  H2F_USER0_CLK_Enable display_name "Enable HPS-to-FPGA User0 clock"
    set_parameter_property  H2F_USER0_CLK_Enable group $clock_output_user_clks_group
    set_parameter_property  H2F_USER0_CLK_Enable description "Drives the HPS main PLL user 0 clock to the FPGA fabric"

    add_parameter2 $clock_output_user_clks_group H2F_USER0_CLK_FREQ "H2F user0 clock frequency" integer 400 Megahertz false {10:400}
    set_parameter_property  H2F_USER0_CLK_FREQ description "Specifies the expected frequency for the HPS to FPGA user 0 clock"

    add_parameter           H2F_USER1_CLK_Enable boolean false ""
    set_parameter_property  H2F_USER1_CLK_Enable display_name "Enable HPS-to-FPGA User1 clock"
    set_parameter_property  H2F_USER1_CLK_Enable group $clock_output_user_clks_group
    set_parameter_property  H2F_USER1_CLK_Enable description "Drives the HPS peripheral PLL user 1 clock to the FPGA fabric"

    add_parameter2 $clock_output_user_clks_group H2F_USER1_CLK_FREQ "H2F user1 clock frequency" integer 400 Megahertz false {10:400}
    set_parameter_property  H2F_USER1_CLK_FREQ description "Specifies the expected frequency for the HPS to FPGA user 1 clock"

    add_parameter2 $clock_output_user_clks_group HMC_PLL_REF_CLK  "HMC clock reference"  integer 800 Megahertz false {10:800}
    set_parameter_property        HMC_PLL_REF_CLK  description "Reference Clock for the EMIF PLL"
    set_parameter_property        HMC_PLL_REF_CLK  visible  false 

    add_parameter2 $clock_output_user_clks_group EMAC_PTP_REF_CLK  "EMAC PTP clock reference"  integer 100 Megahertz false {50:200}
    set_parameter_property        EMAC_PTP_REF_CLK  description "Timestamp PTP clock reference for all EMACs"
    set_parameter_property        EMAC_PTP_REF_CLK  visible false
    
    add_parameter2 $clock_output_user_clks_group SDMMC_REF_CLK  "SDMMC clock reference"  integer 200 Megahertz false {50:200}
    set_parameter_property        SDMMC_REF_CLK  description "Clock reference for Secure Digital/Multimedia Card (SD/MMC)"
    set_parameter_property        SDMMC_REF_CLK  visible false
    
    add_parameter2 $clock_output_user_clks_group GPIO_REF_CLK  "GPIO Debounce clock "     integer 4 Megahertz false {1:200}
    set_parameter_property        GPIO_REF_CLK  description "General-purpose I/O (GPIO) Debounce clock "
    set_parameter_property        GPIO_REF_CLK  visible false
    
    # NOC
    set clock_output_noc_group  "HPS Periferial Clocks - Desired Frequencies" 
    add_display_item $clock_output_tab $clock_output_noc_group GROUP
    
    add_parameter2 $clock_output_noc_group L3_MAIN_FREE_CLK  "L3 clock frequency"  integer 400 Megahertz false {10:500}
    set_parameter_property        L3_MAIN_FREE_CLK  description "Interconnect L3 Main Switch Clock. This Clock configures the source clock that all the L4 and Core Sight clocks will be divided. It is also referred as the NOC clock."

    add_parameter2 $clock_output_noc_group L4_SYS_FREE_CLK  "L4 free clock frequency"  integer 1:100 Megahertz false 
    set_parameter_property        L4_SYS_FREE_CLK  description "Interconnect L4 System Clock.   Always free running"
    
    add_parameter2 $clock_output_noc_group NOCDIV_L4MAINCLK "L4 main clock frequency"  integer 0:400 Megahertz false 
    set_parameter_property        NOCDIV_L4MAINCLK  description "Interconnect L4 main clock for fast peripherals including DMA, SPIM, SPIS and TCM"
    
    add_parameter2 $clock_output_noc_group NOCDIV_L4MPCLK  "L4 peripheral clock frequency"  integer 1:200 Megahertz false 
    set_parameter_property        NOCDIV_L4MPCLK  description "Interconnect L4 Peripheral clock."

    add_parameter2 $clock_output_noc_group NOCDIV_L4SPCLK  "L4 peripheral slow clock frequency"  integer 2:100 Megahertz false 
    set_parameter_property        NOCDIV_L4SPCLK  description "Interconnect L4 Slow Peripheral clock. "

    add_parameter2 $clock_output_noc_group NOCDIV_CS_ATCLK   "CoreSight clock frequency"  integer 0:400 Megahertz false 
    set_parameter_property        NOCDIV_CS_ATCLK  description "CoreSight Trace clock and Debug time stamp clock"

    add_parameter2 $clock_output_noc_group NOCDIV_CS_PDBGCLK  "CoreSight bus clock frequency"  integer 1:50 Megahertz false 
    set_parameter_property        NOCDIV_CS_PDBGCLK  description "CoreSight Bus clock (derived from CoreSight  clock frequency)"

    add_parameter2 $clock_output_noc_group NOCDIV_CS_TRACECLK "CoreSight trace IO clock"  integer 0:400 Megahertz false 
    set_parameter_property        NOCDIV_CS_TRACECLK  description "CoreSight Trace IO Clock (derived from CoreSight  clock frequency)"


    add_parameter2 $clock_output_noc_group HPS_DIV_GPIO_FREQ "Frequency for GPIO debouncer"  integer 125 hertz false [ list 125 1250 2500 3750 5000 6250 7500 8750  10000 11250 12500 13750  15000 16250 17500 18750 20000 21250 22500 23750 25000 26250 27500 28750 30000 32000 ]
    set_parameter_property                 HPS_DIV_GPIO_FREQ description "General-purpose I/O (GPIO) debouncer clock frequency"

    add_parameter2 $clock_output_noc_group CONFIG_HPS_DIV_GPIO "Counter for GPIO debouncer"  integer 32000 none true {1:65535}
    set_parameter_property                 CONFIG_HPS_DIV_GPIO  visible false
    
    #
    # Main PLL output clocks group
    #
    foreach i [list 0 1 2 ] {
        set EMAC_CLK "EMAC${i}_CLK"
        add_parameter2 $clock_output_noc_group $EMAC_CLK  "EMAC $i clock frequency"  integer 250 Megahertz false [list 50 250]
        set_parameter_property        $EMAC_CLK  description "Ethernet Media Access Control $i clock frequency"
    
    }
    
    set perip_group     "Peripherial PLL"
    add_display_item $clock_output_tab $perip_group   "group" ""
    add_parameter2 $perip_group DISABLE_PERI_PLL "Disable peripherial PLL" boolean false
    set_parameter_property        DISABLE_PERI_PLL  description "By default the peripheral HPS PLL will be enabled, if all desired frequencies can be achieved with the main PLL, the peripheral PLL can be disabled."

    add_parameter2 $perip_group OVERIDE_PERI_PLL "Override peripherial PLL VCO frequency" boolean false
    add_parameter2 $perip_group PERI_PLL_MANUAL_VCO_FREQ "Manual peripherial PLL VCO frequency" integer 2000 none false {320:3000}
    add_parameter2 $perip_group PERI_PLL_AUTO_VCO_FREQ "Sugested peripherial PLL VCO frequency" integer  320 none true {320:3000}

    set clock_sources_group     "Clock Sources"
    add_display_item $clock_output_tab $clock_sources_group   "group" ""
        
    add_parameter2 $clock_sources_group CLK_MAIN_PLL_SOURCE2 "Main PLL reference clock source" integer [EOSC1_VCO]
    set_parameter_property        CLK_MAIN_PLL_SOURCE2  allowed_ranges   [list [EOSC1_VCO] [F2S_VCO] ]
    set_parameter_property        CLK_MAIN_PLL_SOURCE2  description "Main PLL reference clock source"
    
    add_parameter2 $clock_sources_group CLK_PERI_PLL_SOURCE2 "Peripheral PLL reference clock source" integer [EOSC1_VCO]
    set_parameter_property        CLK_PERI_PLL_SOURCE2  allowed_ranges   [list [EOSC1_VCO] [F2S_VCO]  ]
    set_parameter_property        CLK_PERI_PLL_SOURCE2  description "Peripheral PLL reference clock source"
    
    add_parameter2 $clock_sources_group CLK_MPU_SOURCE "MPU clock source" integer [MAIN_PLL]
    set_parameter_property        CLK_MPU_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_MPU_SOURCE  visible false
    set_parameter_property        CLK_MPU_SOURCE  description "Selects the source for the MPU Clock"

    add_parameter2 $clock_sources_group CLK_MPU_CNT "MPU clock divider" integer 0
    set_parameter_property        CLK_MPU_CNT  visible false
    set_parameter_property        CLK_MPU_SOURCE  description "Divides the VCO/2 frequency by the value+1"
    
    add_parameter2 $clock_sources_group CLK_NOC_SOURCE "NOC clock source" integer [MAIN_PLL]
    set_parameter_property        CLK_NOC_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_NOC_SOURCE  visible false
    set_parameter_property        CLK_NOC_SOURCE  description "Selects the source for the NOC clock"

    add_parameter2 $clock_sources_group CLK_NOC_CNT "NOC clock Divider" integer 0
    set_parameter_property        CLK_NOC_CNT  visible false
    set_parameter_property        CLK_NOC_CNT  description "Divides the VCO frequency by the value+1"
    
    add_parameter2 $clock_sources_group CLK_S2F_USER0_SOURCE "H2F User0 CLK" integer [MAIN_PLL]
    set_parameter_property        CLK_S2F_USER0_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_S2F_USER0_SOURCE  description "Selects the source for the HPS to FPGA clock user 0"
    
    add_parameter2 $clock_sources_group CLK_S2F_USER1_SOURCE "H2F User1 CLK" integer [MAIN_PLL]
    set_parameter_property        CLK_S2F_USER1_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_S2F_USER1_SOURCE  description "Selects the source for the HPS to FPGA clock user 1"
    
    add_parameter2 $clock_sources_group CLK_HMC_PLL_SOURCE "DDR pll (hmc) clock source" integer [MAIN_PLL]
    set_parameter_property        CLK_HMC_PLL_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_HMC_PLL_SOURCE  description "DDR pll (Hard Memory Controller- External Memory interface) clock source. This is an Internal conection Betwen the HPS and the DDR Interface."
    set_parameter_property        CLK_HMC_PLL_SOURCE  visible false
    
    add_parameter2 $clock_sources_group CLK_EMAC_PTP_SOURCE "EMAC ptp clock source" integer [PERI_PLL]
    set_parameter_property        CLK_EMAC_PTP_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    #set_parameter_property        CLK_EMAC_PTP_SOURCE  visible false
    set_parameter_property        CLK_EMAC_PTP_SOURCE  description "Ethernet MAC Precision Time Protocol (PTP) clock source"
    
    add_parameter2 $clock_sources_group CLK_GPIO_SOURCE "GPIO clock source" integer [PERI_PLL]
    set_parameter_property        CLK_GPIO_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_GPIO_SOURCE  description "General-purpose I/O (GPIO) Debounce clock Source"
    
    add_parameter2 $clock_sources_group CLK_SDMMC_SOURCE "SDMMC clock source" integer [MAIN_PLL]
    set_parameter_property        CLK_SDMMC_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_SDMMC_SOURCE  description "Secure Digital/Multimedia Card (SD/MMC) controller clock source. Note that there is a Divide by 4 before this clock reaches the SDMMC. The SDMMC clock frequency Linux will report is a divide by 4 from this frequency."
    
    add_parameter2 $clock_sources_group CLK_EMACA_SOURCE "EMAC mux a (250Mhz) clock source" integer [PERI_PLL]
    set_parameter_property        CLK_EMACA_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_EMACA_SOURCE  description "Ethernet MAC mux a (250Mhz) clock source"
    
    add_parameter2 $clock_sources_group CLK_EMACB_SOURCE "EMAC mux b  (50Mhz) clock source" integer [PERI_PLL]
    set_parameter_property        CLK_EMACB_SOURCE  allowed_ranges   [list  [MAIN_PLL] [PERI_PLL] ]
    set_parameter_property        CLK_EMACB_SOURCE  description "Ethernet MAC  mux b  (50Mhz) clock source"
    
    add_parameter2 $clock_sources_group EMAC0SEL "EMAC0 clock source" integer [MUXA] none true
    set_parameter_property        EMAC0SEL  allowed_ranges   [list [MUXA] [MUXB] ]
    set_parameter_property        EMAC0SEL  visible false
    
    add_parameter2 $clock_sources_group EMAC1SEL "EMAC1 clock source" integer [MUXA] none true
    set_parameter_property        EMAC1SEL  allowed_ranges   [list [MUXA] [MUXB] ]
    set_parameter_property        EMAC1SEL  visible false

    add_parameter2 $clock_sources_group EMAC2SEL "EMAC2 clock source" integer [MUXA] none true
    set_parameter_property        EMAC2SEL  allowed_ranges   [list [MUXA] [MUXB] ]
    set_parameter_property        EMAC2SEL  visible false


    set pll_report_group    "PLL report"
    add_display_item $clock_output_tab $pll_report_group   "group" ""
    add_display_item $pll_report_group ALL_PLL_REPORT  TEXT ""
    add_display_item $pll_report_group MAIN_PLL_REPORT TEXT ""

    set clock_advanced_group    "Alvenced PLL settings"
    add_display_item $clock_output_tab $clock_advanced_group   "group" ""

    add_parameter2 $clock_advanced_group MAINPLLGRP_VCO_DENOM       "Main PLL N counter" integer 64 none true {0:63}
    set_parameter_property               MAINPLLGRP_VCO_DENOM        visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_VCO_NUMER       "Main PLL M counter" integer 4096 none true {0:4095}
    set_parameter_property               MAINPLLGRP_VCO_NUMER        visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_MPU_CNT         "Main PLL MPU counter (C0)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_MPU_CNT          visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_NOC_CNT         "Main PLL NOC counter (C1)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_NOC_CNT          visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_EMACA_CNT       "Main PLL EMAC A counter (C2)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_EMACA_CNT        visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_EMACB_CNT       "Main PLL EMAC B counter (C3)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_EMACB_CNT        visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_EMAC_PTP_CNT    "Main PLL EMAC PTP Timestamp (C4)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_EMAC_PTP_CNT     visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_GPIO_DB_CNT     "Main PLL FPGA (GPIO Debounce clock) Reference (C5)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_GPIO_DB_CNT      visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_SDMMC_CNT       "Main PLL SDMMC Reference (C6)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_SDMMC_CNT        visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_S2F_USER0_CNT   "Main PLL FPGA User0 (C7)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_S2F_USER0_CNT    visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_S2F_USER1_CNT   "Main PLL FPGA User1 (C8)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_S2F_USER1_CNT    visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_HMC_PLL_REF_CNT "Main PLL HMC IO PLL (C9)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_HMC_PLL_REF_CNT  visible false
    add_parameter2 $clock_advanced_group MAINPLLGRP_PERIPH_REF_CNT  "Main PLL clock for Peripherial PLL (C15)" integer [unused_counter] none true {0:2047}
    set_parameter_property               MAINPLLGRP_PERIPH_REF_CNT   visible false

    add_parameter2 $clock_advanced_group PERPLLGRP_VCO_DENOM       "Peripherial PLL N counter" integer 64 none true {0:63}
    set_parameter_property               PERPLLGRP_VCO_DENOM        visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_VCO_NUMER       "Peripherial PLL M counter" integer 4096 none true {0:4095}
    set_parameter_property               PERPLLGRP_VCO_NUMER        visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_MPU_CNT         "Peripherial PLL MPU counter (C0)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_MPU_CNT          visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_NOC_CNT         "Peripherial PLL NOC counter (C1)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_NOC_CNT          visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_EMACA_CNT       "Peripherial PLL EMAC A counter (C2)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_EMACA_CNT        visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_EMACB_CNT       "Peripherial PLL EMAC B counter (C3)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_EMACB_CNT        visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_EMAC_PTP_CNT    "Peripherial PLL EMAC PTP Timestamp (C4)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_EMAC_PTP_CNT     visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_GPIO_DB_CNT     "Peripherial PLL FPGA (GPIO Debounce clock) Reference (C5)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_GPIO_DB_CNT      visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_SDMMC_CNT       "Peripherial PLL SDMMC Reference (C6)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_SDMMC_CNT        visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_S2F_USER0_CNT   "Peripherial PLL FPGA User0 (C7)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_S2F_USER0_CNT    visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_S2F_USER1_CNT   "Peripherial PLL FPGA User1 (C8)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_S2F_USER1_CNT    visible false
    add_parameter2 $clock_advanced_group PERPLLGRP_HMC_PLL_REF_CNT "Peripherial PLL HMC IO PLL (C9)" integer [unused_counter] none true {0:2047}
    set_parameter_property               PERPLLGRP_HMC_PLL_REF_CNT  visible false
    
    
    ################################################################################
    # Retets tab
    ################################################################################
    
    set resets_tab  "Resets"
    set resets_group "Reset Signals"
    add_display_item $parent_tab $resets_tab GROUP TAB
    add_display_item $resets_tab $resets_group  GROUP
    #### Group => Reset ####
    add_parameter           H2F_PENDING_RST_Enable boolean false ""
    set_parameter_property  H2F_PENDING_RST_Enable display_name "Enable HPS warm reset handshake signals"
    set_parameter_property  H2F_PENDING_RST_Enable group $resets_group
    set_parameter_property  H2F_PENDING_RST_Enable description "Enables an additional pair of reset handshake signals allowing soft logic to notify the HPS when it is safe to initiate a warm reset in the FPGA fabric."

    add_parameter           H2F_COLD_RST_Enable boolean false ""
    set_parameter_property  H2F_COLD_RST_Enable display_name "Enable HPS-to-FPGA cold reset output"
    set_parameter_property  H2F_COLD_RST_Enable group $resets_group
    set_parameter_property  H2F_COLD_RST_Enable description "Enables the HPS cold reset output interface to the FPGA fabric"

    add_parameter           F2H_DBG_RST_Enable boolean false ""
    set_parameter_property  F2H_DBG_RST_Enable display_name "Enable FPGA-to-HPS debug reset request"
    set_parameter_property  F2H_DBG_RST_Enable group $resets_group
    set_parameter_property  F2H_DBG_RST_Enable description "Enables the HPS debug reset request interface to the FPGA fabric"

    add_parameter           F2H_WARM_RST_Enable boolean false ""
    set_parameter_property  F2H_WARM_RST_Enable display_name "Enable FPGA-to-HPS warm reset request"
    set_parameter_property  F2H_WARM_RST_Enable group $resets_group
    set_parameter_property  F2H_WARM_RST_Enable description "Enables the warm reset request interface to the HPS"

    add_parameter           F2H_COLD_RST_Enable boolean false ""
    set_parameter_property  F2H_COLD_RST_Enable display_name "Enable FPGA-to-HPS cold reset request"
    set_parameter_property  F2H_COLD_RST_Enable group $resets_group
    set_parameter_property  F2H_COLD_RST_Enable description "Enables the cold reset request interface to the HPS"

    #set resets_group "PLL Debug"
    #add_display_item $resets_tab $resets_group  GROUP

    add_parameter            TESTIOCTRL_MAINCLKSEL  integer 8
    set_parameter_property   TESTIOCTRL_MAINCLKSEL  allowed_ranges {"0:C0 (MPU) & C8 (User 1 Clk)" "1:C1 (NOC)" "2:C2 (EMAC Mux A)" "3:C3 (EMAC Mux B)" "4:C4 (EMAC PTP)" "5:C5 (GPIO DB)" "6:C6 (SDMMC)" "7:C7 (User 1 Clk)" "8:Disabled (VSS)"}
    set_parameter_property   TESTIOCTRL_MAINCLKSEL  display_name   "Main PLL to PLL_CLK0 & PLL_CLK1"
    set_parameter_property   TESTIOCTRL_MAINCLKSEL  group          $resets_group
    set_parameter_property   TESTIOCTRL_MAINCLKSEL  description    "unsupported debug feature"
    set_parameter_property   TESTIOCTRL_MAINCLKSEL  enabled        false
    set_parameter_property   TESTIOCTRL_MAINCLKSEL  visible        false
    
    add_parameter            TESTIOCTRL_PERICLKSEL  integer 8
    set_parameter_property   TESTIOCTRL_PERICLKSEL  allowed_ranges {"0:C0 (MPU) & C8 (User 1 Clk)" "1:C1 (NOC)" "2:C2 (EMAC Mux A)" "3:C3 (EMAC Mux B)" "4:C4 (EMAC PTP)" "5:C5 (GPIO DB)" "6:C6 (SDMMC)" "7:C7 (User 1 Clk)" "8:Disabled (VSS)"}
    set_parameter_property   TESTIOCTRL_PERICLKSEL  display_name   "Peripherial PLL to PLL_CLK2 and PLL_CLK3"
    set_parameter_property   TESTIOCTRL_PERICLKSEL  group          $resets_group
    set_parameter_property   TESTIOCTRL_PERICLKSEL  description    "unsupported debug feature"
    set_parameter_property   TESTIOCTRL_PERICLKSEL  enabled        false
    set_parameter_property   TESTIOCTRL_PERICLKSEL  visible        false
    
    add_parameter            TESTIOCTRL_DEBUGCLKSEL integer 16
    set_parameter_property   TESTIOCTRL_DEBUGCLKSEL allowed_ranges {"0:Main PLL OUTRESETACK0" "1:Main PLL OUTRESETACK3" "2:Main PLL OUTRESETACK7" "3:Main PLL OUTRESETACK11" "4:Main PLL OUTRESETACK15" "5:Main PLL FBSLIP" "6:Main PLL RFSLIP" "7:Main PLL Lock"\
                                                                     "8:Peripherial PLL OUTRESETACK0" "9:Peripherial PLL OUTRESETACK3" "10:Peripherial PLL OUTRESETACK7" "11:Peripherial PLL OUTRESETACK11" "12:Peripherial PLL OUTRESETACK15" "13:Peripherial PLL FBSLIP" "14:Peripherial PLL RFSLIP" "15:Peripherial PLL Lock" \
                                                                    "16:Disabled (VSS)"}
    set_parameter_property   TESTIOCTRL_DEBUGCLKSEL display_name   "Peripherial or MAIN PLL to PLL_CLK4"
    set_parameter_property   TESTIOCTRL_DEBUGCLKSEL group          $resets_group
    set_parameter_property   TESTIOCTRL_DEBUGCLKSEL description    "unsupported debug feature"
    set_parameter_property   TESTIOCTRL_DEBUGCLKSEL enabled        false
    set_parameter_property   TESTIOCTRL_DEBUGCLKSEL visible        false
    
}

################################################
 # Logical View - TER
 # This section is duplicated from Asimov to get device tree generation working.  Eosc2 was removed since it's not needed in Baum.
################################################
proc clocks_logicalview_dtg {} {
    add_instance eosc1 hps_virt_clk
    add_instance cb_intosc_hs_div2_clk hps_virt_clk
    add_instance cb_intosc_ls_clk hps_virt_clk
    add_instance f2s_free_clk hps_virt_clk
    set_instance_parameter_value eosc1 clockFrequency [expr {[get_parameter_value eosc1_clk_mhz] * 1000000}]
    set_instance_parameter_value cb_intosc_ls_clk clockFrequency [expr {[get_parameter_value INTERNAL_OSCILLATOR_ENABLE] * 1000000}]
    set_instance_parameter_value f2s_free_clk clockFrequency [expr {[get_parameter_value F2H_FREE_CLK_FREQ] * 1000000}]

    #Alberto sent an FPGA clock name: F2H_FREE_CLK_FREQ

    #add_instance f2s_periph_ref_clk hps_virt_clk
    #set_instance_parameter_value f2s_periph_ref_clk clockFrequency [get_parameter_value F2SCLK_PERIPHCLK_FREQ]

    #add_instance f2s_sdram_ref_clk hps_virt_clk
    #set_instance_parameter_value f2s_sdram_ref_clk clockFrequency [get_parameter_value F2SCLK_SDRAMCLK_FREQ]
}


