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


#set alt_mem_if_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/alt_mem_if/alt_mem_if_tcl_packages"
#if {[lsearch -exact $auto_path $alt_mem_if_tcl_libs_dir] == -1} {
#	lappend auto_path $alt_mem_if_tcl_libs_dir
#}

#source pll_reconfig_util.tcl
#source ../../../sopc_builder_ip/altera_avalon_mega_common/ipcc_wrap_split.tcl
#source ../../../sopc_builder_ip/altera_avalon_mega_common/sopc_mwizc.tcl
#source ../../../altera_xcvr_generic/alt_xcvr_common.tcl
package require quartus::qcl_pll 
package require quartus::advanced_pll_legality 
#package require alt_mem_if::util::messaging
#package require alt_mem_if::util::iptclgen
#package require alt_mem_if::util::hwtcl_utils
#namespace import ::alt_mem_if::util::messaging::*

##########################################
# CLOCKING MODE
##########################################

add_parameter gui_clocking_mode BOOLEAN false
set_parameter_property gui_clocking_mode DISPLAY_NAME "Clocking mode"
set_parameter_property gui_clocking_mode DISPLAY_HINT radio
set_parameter_property gui_clocking_mode AFFECTS_ELABORATION true
set_parameter_property gui_clocking_mode AFFECTS_GENERATION true
set_parameter_property gui_clocking_mode ALLOWED_RANGES {"false:Standard clocking mode" "true:Advanced clocking mode"}
set_parameter_property gui_clocking_mode IS_HDL_PARAMETER false
add_display_item "User Interface" gui_clocking_mode PARAMETER
set_parameter_property gui_clocking_mode DESCRIPTION "<b>Standard clocking mode:</b><br> Generates an output clock at the transmit user interface to be used for user logic clocking. On the receive user interface, an output clock is provided. See User Guide for more details.<br><br>
<b>Advanced clocking mode:</b><br> Allows for a clock to be provided as an input to the transmit user interface. On the receive user interface, an output clock is provided. See User Guide for more details.<br><br> 
"
set_parameter_property gui_clocking_mode VISIBLE true


##########################################
# USER/INTERFACE CLOCK FREQUENCY
##########################################

add_parameter gui_user_input INTEGER 0
set_parameter_property gui_user_input DISPLAY_NAME "User input"
set_parameter_property gui_user_input DISPLAY_HINT radio
set_parameter_property gui_user_input AFFECTS_ELABORATION true
set_parameter_property gui_user_input ALLOWED_RANGES {"0:User clock frequency" "1:Transceiver data rate"}
set_parameter_property gui_user_input IS_HDL_PARAMETER false
add_display_item "User Interface" gui_user_input PARAMETER
set_parameter_property gui_user_input DESCRIPTION "<b>Transceiver data rate:</b><br> Users have to provide required transceiver data rate in order to derive the user clock frequency.<br><br>
<b>User clock frequency:</b><br> Users have to provide required user clock frequency in order to derive the transceiver data rate.<br><br> 
"
set_parameter_property gui_user_input VISIBLE true
#add_parameter gui_user_clock_frequency STRING "138.525478 MHz"
add_parameter gui_user_clock_frequency STRING "146.484375"
set_parameter_property gui_user_clock_frequency DISPLAY_NAME "User clock frequency required"
set_parameter_property gui_user_clock_frequency DISPLAY_UNITS "MHz"
set_parameter_property gui_user_clock_frequency DISPLAY_HINT "user_clock_frequency"
set_parameter_property gui_user_clock_frequency AFFECTS_ELABORATION true
set_parameter_property gui_user_clock_frequency AFFECTS_GENERATION true
set_parameter_property gui_user_clock_frequency IS_HDL_PARAMETER false
add_display_item "User Interface" gui_user_clock_frequency PARAMETER
set_parameter_property gui_user_clock_frequency DESCRIPTION "The user specifies the frequency desired for the user clock input or output for the transmit and receive user interface (dependent on clocking mode selected: output for Standard Clocking Mode, input for Advanced Clocking Mode). This frequency in turn determines the required transceiver data rate to support the calculated transmit and receive bandwidths"
set_display_item_property gui_user_clock_frequency DISPLAY_HINT "columns:11"


#add_parameter gui_actual_user_clock_frequency STRING "138.525477 MHz"
add_parameter gui_actual_user_clock_frequency STRING "146.484375"
set_parameter_property gui_actual_user_clock_frequency DISPLAY_NAME "User clock frequency output"
set_parameter_property gui_actual_user_clock_frequency DISPLAY_UNITS "MHz"
set_parameter_property gui_actual_user_clock_frequency DISPLAY_HINT "user_clock_frequency"
set_parameter_property gui_actual_user_clock_frequency ENABLED true
#set_parameter_property gui_actual_user_clock_frequency AFFECTS_ELABORATION true
set_parameter_property gui_actual_user_clock_frequency AFFECTS_GENERATION true
set_parameter_property gui_actual_user_clock_frequency IS_HDL_PARAMETER false
#set_parameter_property gui_actual_user_clock_frequency VISIBLE false
set_parameter_property gui_actual_user_clock_frequency DERIVED true
add_display_item "User Interface" gui_actual_user_clock_frequency PARAMETER
set_parameter_property gui_actual_user_clock_frequency DESCRIPTION "Specifies the actual user clock frequency at the clock output(s) for either Standard or Advanced Clocking Modes."
set_display_item_property gui_actual_user_clock_frequency DISPLAY_HINT "columns:11"

add_parameter gui_interface_clock_frequency STRING "N.A."
set_parameter_property gui_interface_clock_frequency DISPLAY_NAME "Interface clock frequency"
set_parameter_property gui_interface_clock_frequency DISPLAY_UNITS "MHz"
set_parameter_property gui_interface_clock_frequency ENABLED false
set_parameter_property gui_interface_clock_frequency AFFECTS_GENERATION true
set_parameter_property gui_interface_clock_frequency IS_HDL_PARAMETER false
set_parameter_property gui_interface_clock_frequency VISIBLE false
set_parameter_property gui_interface_clock_frequency DERIVED true
set_parameter_property gui_interface_clock_frequency DESCRIPTION "Specifies the actual frequency of the transceiver clock output that drives the interface clock"
#set_display_item_property gui_interface_clock_frequency DISPLAY_HINT "columns:11"


#add_parameter user_clock_frequency STRING "138.52 MHz"
add_parameter user_clock_frequency STRING "146.48 MHz"
set_parameter_property user_clock_frequency VISIBLE false
set_parameter_property user_clock_frequency DERIVED true
set_parameter_property user_clock_frequency AFFECTS_GENERATION true
set_parameter_property user_clock_frequency IS_HDL_PARAMETER true

#add_parameter interface_clock_frequency STRING "138.52 MHz"
add_parameter interface_clock_frequency STRING "146.48 MHz"
set_parameter_property interface_clock_frequency VISIBLE false
set_parameter_property interface_clock_frequency DERIVED true
set_parameter_property interface_clock_frequency AFFECTS_GENERATION true
set_parameter_property interface_clock_frequency IS_HDL_PARAMETER false




##########################################
# CORE CLOCK FREQUENCY
##########################################
#add_parameter gui_coreclkin_frequency STRING "153.92 MHz"
add_parameter gui_coreclkin_frequency STRING "205.078125 MHz"
#set_parameter_property gui_coreclkin_frequency DISPLAY_NAME "Desired Core Clockin Frequency"
#set_parameter_property gui_coreclkin_frequency DISPLAY_UNITS "MHz"
set_parameter_property gui_coreclkin_frequency DISPLAY_HINT "coreclkin_frequency"
#set_parameter_property gui_coreclkin_frequency ENABLED true
#set_parameter_property gui_actual_coreclkin_frequency AFFECTS_ELABORATION false
set_parameter_property gui_coreclkin_frequency AFFECTS_GENERATION true
set_parameter_property gui_coreclkin_frequency IS_HDL_PARAMETER false
set_parameter_property gui_coreclkin_frequency DERIVED true
set_parameter_property gui_coreclkin_frequency VISIBLE false
add_display_item "User Interface" gui_coreclkin_frequency PARAMETER
set_parameter_property gui_coreclkin_frequency DESCRIPTION "Specifies the frequency of the core clock at Interlaken PHY IP interface. The value is automatically calculated."


#add_parameter gui_actual_coreclkin_frequency STRING "184.700635 MHz"
add_parameter gui_actual_coreclkin_frequency STRING "205.078125"
set_parameter_property gui_actual_coreclkin_frequency DISPLAY_NAME "Core clock frequency"
set_parameter_property gui_actual_coreclkin_frequency DISPLAY_UNITS "MHz"
set_parameter_property gui_actual_coreclkin_frequency DISPLAY_HINT "coreclkin_frequency"
set_parameter_property gui_actual_coreclkin_frequency ENABLED false
#set_parameter_property gui_actual_coreclkin_frequency AFFECTS_ELABORATION false
set_parameter_property gui_actual_coreclkin_frequency AFFECTS_GENERATION true
set_parameter_property gui_actual_coreclkin_frequency IS_HDL_PARAMETER false
set_parameter_property gui_actual_coreclkin_frequency VISIBLE false
set_parameter_property gui_actual_coreclkin_frequency DERIVED true
add_display_item "User Interface" gui_actual_coreclkin_frequency PARAMETER
set_parameter_property gui_actual_coreclkin_frequency DESCRIPTION "Specifies the frequency of the core clock at Interlaken PHY IP interface. The value is automatically calculated."
#set_display_item_property gui_actual_coreclkin_frequency DISPLAY_HINT "columns:11"

#add_parameter coreclkin_frequency STRING "153.92 MHz"
add_parameter coreclkin_frequency STRING "205.078 MHz"
set_parameter_property coreclkin_frequency VISIBLE false
set_parameter_property coreclkin_frequency IS_HDL_PARAMETER true
set_parameter_property coreclkin_frequency DERIVED true

##########################################
# fpLL REFERENCE CLOCK FREQUENCY
##########################################
add_parameter gui_reference_clock_frequency STRING "257.8125 MHz"
set_parameter_property gui_reference_clock_frequency DISPLAY_NAME "IOPLL reference clock frequency"
set_parameter_property gui_reference_clock_frequency DISPLAY_UNITS "MHz"
set_parameter_property gui_reference_clock_frequency DISPLAY_HINT "Fractional PLL reference_clock_frequency"
set_parameter_property gui_reference_clock_frequency ENABLED true
set_parameter_property gui_reference_clock_frequency AFFECTS_ELABORATION true
set_parameter_property gui_reference_clock_frequency VISIBLE false
set_parameter_property gui_reference_clock_frequency AFFECTS_GENERATION true
set_parameter_property gui_reference_clock_frequency IS_HDL_PARAMETER false
set_parameter_property gui_reference_clock_frequency DERIVED true
add_display_item "User Interface" gui_reference_clock_frequency PARAMETER
set_parameter_property gui_reference_clock_frequency DESCRIPTION "Specifies the IOPLL reference clock frequency"
#set_display_item_property gui_reference_clock_frequency DISPLAY_HINT "columns:11"

add_parameter int_reference_clock_frequency STRING "257.8125 MHz"
set_parameter_property int_reference_clock_frequency DISPLAY_NAME "IOPLL reference clock frequency"
set_parameter_property int_reference_clock_frequency DISPLAY_UNITS "MHz"
set_parameter_property int_reference_clock_frequency DISPLAY_HINT "Fractional PLL reference_clock_frequency"
set_parameter_property int_reference_clock_frequency ENABLED false
set_parameter_property int_reference_clock_frequency AFFECTS_ELABORATION true
set_parameter_property int_reference_clock_frequency VISIBLE false
set_parameter_property int_reference_clock_frequency AFFECTS_GENERATION true
set_parameter_property int_reference_clock_frequency IS_HDL_PARAMETER false
set_parameter_property int_reference_clock_frequency DERIVED true
set_parameter_property int_reference_clock_frequency DESCRIPTION "Specifies the IOPLL reference clock frequency"


add_parameter reference_clock_frequency STRING "257.8125 MHz"
set_parameter_property reference_clock_frequency ENABLED true
set_parameter_property reference_clock_frequency VISIBLE false
set_parameter_property reference_clock_frequency IS_HDL_PARAMETER true
set_parameter_property reference_clock_frequency DERIVED true


add_parameter pll_ref_freq STRING "PARAM_UNMAPPED"
set_parameter_property pll_ref_freq DERIVED true
set_parameter_property pll_ref_freq VISIBLE false
set_parameter_property pll_ref_freq IS_HDL_PARAMETER true
set_parameter_property pll_ref_freq DERIVED true


##########################################
# INPUT/OUTPUT LANE DATA RATES
##########################################

set_parameter_property gui_xcvr_data_rate DISPLAY_NAME "Transceiver data rate"
set_parameter_property gui_xcvr_data_rate DISPLAY_UNITS "Gbps"
set_parameter_property gui_xcvr_data_rate AFFECTS_ELABORATION true
set_parameter_property gui_xcvr_data_rate AFFECTS_GENERATION true
set_parameter_property gui_xcvr_data_rate IS_HDL_PARAMETER false
add_display_item "User Interface" gui_xcvr_data_rate PARAMETER
set_display_item_property gui_xcvr_data_rate DISPLAY_HINT "columns:11"

set_parameter_property lane_rate_parameter DISPLAY_NAME "Transceiver data rate"
set_parameter_property lane_rate_parameter DISPLAY_UNITS "Gbps"
#set_parameter_property lane_rate_parameter AFFECTS_GENERATION false
set_parameter_property lane_rate_parameter ENABLED false
set_parameter_property lane_rate_parameter IS_HDL_PARAMETER false
set_parameter_property lane_rate_parameter DERIVED true
add_display_item "User Interface" lane_rate_parameter PARAMETER
set_display_item_property lane_rate_parameter DISPLAY_HINT "columns:11"

# HDL ACTUAL LANE DATA RATE 
add_parameter data_rate STRING "10312.5 Mbps"
set_parameter_property data_rate DERIVED true
set_parameter_property data_rate VISIBLE false
set_parameter_property data_rate IS_HDL_PARAMETER true

##########################################
# AGGREGATE DATA RATES
##########################################

add_parameter gui_aggregate_data_rate STRING ""
set_parameter_property gui_aggregate_data_rate DISPLAY_NAME "Aggregate user bandwidth"
set_parameter_property gui_aggregate_data_rate DISPLAY_HINT "Aggregate user data rate"
set_parameter_property gui_aggregate_data_rate DISPLAY_UNITS "Gbps"
set_parameter_property gui_aggregate_data_rate IS_HDL_PARAMETER false
set_parameter_property gui_aggregate_data_rate DERIVED true
add_display_item "User Interface" gui_aggregate_data_rate PARAMETER
set_parameter_property gui_aggregate_data_rate DESCRIPTION "This value is derived by multiplying the number of lanes and user interface data rate."
set_display_item_property gui_aggregate_data_rate DISPLAY_HINT "columns:11"

proc find_valid_fpll_clocks { } {
    
    # calculate the desired frequencies
    set device  [get_parameter_value system_family]
    set cmode [get_parameter_value gui_clocking_mode]
    set user_input [get_parameter_value gui_user_input]
    if { $cmode == "false" }  {
      if {$user_input == 1} {
          set ucf [format %.6f [expr [get_parameter_value gui_xcvr_data_rate]*1000/1.1/64]]
      } else {
          set ucf [get_parameter_value gui_user_clock_frequency]
      }		  
    }

    if {$device== "Arria 10"} {
        set_parameter_value enable_seventeeng true
        set rcf [format %.4f [expr {double($ucf*1.1)}] ]
        set ccf [format %.4f  [expr {double ($rcf)}] ]
        set rcf_2 [format %.6f [expr {double($ucf*1.1)}] ]
        set ccf_2 [format %.6f  [expr {double ($rcf_2)}] ]
    } else {
      set_parameter_value enable_seventeeng false
      set rcf [format %f [expr $ucf*1.76]]
      set ccf [format %.4f  [expr {double ($ucf*1.4)}] ]
    }
    #send_message INFO "rcf=$rcf"
    set_parameter_value gui_reference_clock_frequency "$rcf"
    if {$device== "Arria 10"} {
        # have %.6f precision for IOPLL refclk to be able to generate exactly desired user clock
        set_parameter_value int_reference_clock_frequency "$rcf_2"
        set_parameter_value gui_coreclkin_frequency "$ccf_2"
    } else {
        set_parameter_value int_reference_clock_frequency "$rcf"
        set_parameter_value gui_coreclkin_frequency "$ccf"
        #send_message INFO "ccf=$ccf"
    }
    
    # map the clocks for validate procedure
    set_parameter_value gui_output_clock_frequency0 "$ucf"
    set_parameter_value gui_output_clock_frequency1 "$ccf"
    #set_parameter_value gui_output_clock_frequency0 "154.53"
    #set_parameter_value gui_output_clock_frequency1 "$ccf"
    
    # call the validate procedure
    if { ($device == "StratixV") || ($device == "Stratix V") || ($device == "Arria V GZ")  } { 
      validate_clocks
    } else {
      send_message INFO "Please chose a supported device - $device"
    }
    return $rcf
}


proc validate_clocks {} {
    global generic_total
    global generic_total_time
    global phys_params_list
    set r_total 0
    set start_v_total [clock clicks -milliseconds]
    
   # Enable or disable parameters based on the number of output clocks
   # validation_param_visibility
    set en_locked 1 
    set en_reconf 0 
    set en_refclk_switch 0 
    set en_pll_cascade_out 0 
    set en_pll_cascade_in 0 
    set refclk_switchover_mode "Automatic Switchover" 
    set en_refclk_clkbad 0
    set en_dps 0 
    set en_phout 0 
    set en_adv 0
    set use_non_generic_pll [expr {$en_dps||$en_reconf||$en_refclk_switch||$en_adv||$en_pll_cascade_out||$en_pll_cascade_in||$en_phout}]

    # I cant find this parameter in the qm
    set pll_fractional_cout 32 
    set third_order_divide [expr {pow(2, $pll_fractional_cout)}]
 
    # Set the number of clocks based on device family
    #set device [get_parameter_value device_family]
    #if {$device == "Stratix V" || $device == "Arria V GZ"} {
    #    common_map_allowed_range gui_number_of_clocks {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18}
    #} elseif {$device == "Arria V"} {
    #    common_map_allowed_range gui_number_of_clocks {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18}
    #} elseif {$device == "Cyclone V"} {
    #    common_map_allowed_range gui_number_of_clocks {1 2 3 4 5 6 7 8 9}	
    #}
    #set the derived number_of_clocks parameter
    set num_clocks 2 
    #set_parameter_value number_of_clocks $num_clocks

    #if {$use_non_generic_pll} {
    #    common_map_allowed_range gui_operation_mode {"direct" "external feedback" "normal" "source synchronous" "zero delay buffer" "lvds"}
    #} else {
    #    if {$device == "Stratix V" || $device == "Arria V GZ"} {
    #        common_map_allowed_range gui_operation_mode {"direct" "external feedback" "normal" "source synchronous" "zero delay buffer" "lvds"}
    #    } elseif {$device == "Arria V"} {
    #        common_map_allowed_range gui_operation_mode {"direct" "external feedback" "normal" "source synchronous" "zero delay buffer" "lvds"}
    #    } elseif {$device == "Cyclone V"} {
    #        common_map_allowed_range gui_operation_mode {"direct" "external feedback" "normal" "source synchronous" "zero delay buffer" "lvds"}
    #    }
    #}
    #set the derived operation_mode parameter
    set op_mode "normal" 
    #set_parameter_value operation_mode $op_mode
    
    # Get the current value of parameters we care about
    set device  [get_parameter_value system_family]
#set device "Stratix V" 
    set speed [get_parameter_value speedgrade] 
    #send_message INFO "device=$device" 
    #send_message INFO "sg=$speed" 
    set device_part [get_reference_list_items "device_part" [list $device $speed]]    
    set num_count 2 
    set pll_type "fPLL" 
    #set check_refclk [precision_check [::alt_xcvr::utils::common::get_freq_in_mhz  [get_parameter_value reference_clock_frequency]]]
    set check_refclk [precision_check [get_parameter_value gui_reference_clock_frequency] ]
        #set check_refclk1 [precision_check [get_parameter_value gui_refclk1_frequency]]
    set ref_clk $check_refclk
        #set ref_clk1 $check_refclk1
    set rbc_ref_clk "[get_parameter_value gui_reference_clock_frequency] MHz"
    #set_parameter_value reference_clock_frequency "$ref_clk MHz"
    #send_message INFO "ref_clk = $ref_clk MHz"
    #send_message INFO "rbc_ref_clk = $rbc_ref_clk"
    set channel_spacing "0.0 kHz" 
    set fractional_vco_multiplier "true"
    if { $fractional_vco_multiplier == "true"} {
        set_parameter_value fractional_vco_multiplier 1
    } else {
        set_parameter_value fractional_vco_multiplier 0
    }
    
	# check to see if the given N counter will result in an invalid PFD
	if {$en_adv} {
		set div_n [get_parameter_value gui_divide_factor_n]
		set pfd [expr {$ref_clk / $div_n}]
		if {$pfd < 5 || $pfd > 325} {
			send_message error "The specified configuration causes Phase Frequency Detector (PFD) to go beyond the limit (5 MHz to 325 MHz)"
		}
	}
	
        set MAX_OUTPUT_CLOCKS 18
    for { set i 0 } {$i < $MAX_OUTPUT_CLOCKS} {incr i} {
        if {$i < $num_count} {
            
            # Check the value in RBC
            set rbc_outclk_freq($i) "[get_parameter_value gui_output_clock_frequency$i] MHz"
            set rbc_outclk_duty($i) [get_parameter_value gui_duty_cycle$i]
            
            set_parameter_value output_clock_frequency$i "[common_get_mapped_allowed_range_value gui_actual_output_clock_frequency$i]"			
            set_parameter_value duty_cycle$i [get_parameter_value gui_duty_cycle$i]
            
            #send_message INFO "gui_aocf_$i = $output_clock_frequency"
            
            # Make sure the values pass into the rbc never exceed 6 precision
            #Here, send either the entered frequency to the RBC code, or calculate
            #the frequency using mult/div factors
            if {$en_adv} {
                set div_c [get_parameter_value gui_divide_factor_c$i]
				set vco_freq [compute_vco_frequency]
				set check_value($i) [expr {$vco_freq / $div_c}]                            
            } else {
                set check_value($i) [get_parameter_value gui_output_clock_frequency$i]
            }
            #_dprint 1 "freq$i = $check_value($i)"
	    #send_message INFO "freq$i = $check_value($i)"
            set check_val($i) [precision_check $check_value($i)]
            set rbc_outclk_freq_val($i) "$check_val($i) MHz"
            #Set the phase val always in ps, but first convert from degrees if user enters ps in degs
            set ps_units [get_parameter_value gui_ps_units$i]
            if {$ps_units == "degrees"} {
                set phase_in_deg [get_parameter_value gui_phase_shift_deg$i]
                set phase_in_ps [degrees_to_ps $phase_in_deg $check_val($i)]
                set rbc_outclk_phase($i) "$phase_in_ps ps"
                #setting the actual phases
                set phase_in_deg [common_get_mapped_allowed_range_value gui_actual_phase_shift$i]
                set phase_in_deg [list $phase_in_deg]
                set phase_in_ps [degrees_to_ps $phase_in_deg $check_val($i)]
                set_parameter_value phase_shift$i $phase_in_ps
                set ps [get_parameter_value phase_shift0]
                
            } else {
                set rbc_outclk_phase($i) "[get_parameter_value gui_phase_shift$i] ps"
                set ps_with_units [common_get_mapped_allowed_range_value gui_actual_phase_shift$i]
                regexp {([0-9.]+)} $ps_with_units phase_value 
                set_parameter_value phase_shift$i $phase_value
            }

            #_dprint 1 "phase$i = $rbc_outclk_phase($i)"
            
 
        } else {

            # Check the value in RBC
            set rbc_outclk_freq($i) "0 MHz"
            set rbc_outclk_phase($i) "0 ps"
            set rbc_outclk_duty($i) 50
            
            # Set the value in the HDL
            set_parameter_value output_clock_frequency$i "0 MHz"
            set_parameter_value phase_shift$i "0 ps"
            set_parameter_value duty_cycle$i 50
            
            # Make sure the values pass into the rbc never exceed 6 precision
            set rbc_outclk_freq_val($i) "0 MHz"
        }
    }

    
    
    ##################################################
    # Get the reference clock frequency legal values
    ##################################################
    set reference_list [list $device_part $fractional_vco_multiplier $pll_type $channel_spacing]
    set result [my_set_rbc_check REFERENCE_CLOCK_FREQUENCY $reference_list]
#return -1
    #strip off {{ and }} from RBC
    regsub {([\{]+)} $result {} result
    regsub {([\}]+)} $result {} result
    #split each refclk freq returned
    set compare_range_min [lindex [split $result "MHz.."] 0]
    set compare_range_max [lindex [split $result "MHz.."] 6]
    # send_message info "The legal reference clock frequency is $result"	
    if { $ref_clk < $compare_range_min || $ref_clk > $compare_range_max} {
        send_message error "$ref_clk MHz is illegal reference clock frequency"
    }
        #############################################
        #Validate refclk switchover if enabled #####
        ############################################# 
        #refclk_switchover_elaboration_validation "validation" $device
        #if {$en_refclk_switch} {
        #  if { $ref_clk1 < $compare_range_min || $ref_clk1 > $compare_range_max} {
        #        send_message error "Clock 'refclk1' has an illegal reference clock frequency of: $ref_clk1 MHz"
        #     }
        #}
    ##################################################
    # Get the output clock frequency legal values
    ##################################################
    ## Check the legality for desired output clock frequency
    for { set i 0 } {$i < $MAX_OUTPUT_CLOCKS} {incr i} {
        for { set k 0 } {$k < $i} {incr k} {
            if {$k != $i} {
	        #if {$k < $num_count} {
                    lappend outclks($i) [get_parameter_value output_clock_frequency$k]
		#} else {
		#    lappend outclks($i) "0 MHz" 
		#}
            }
        }
        for { set j [expr $k +1] } {$j < $MAX_OUTPUT_CLOCKS} {incr j} {
            lappend outclks($i) "0 MHz"
        }

        if {$i < $num_count} {
#send_message INFO "At location-1: i=$i $device_part ref_clk=$ref_clk rbc_outclk_freq=$rbc_outclk_freq_val($i) vco=$fractional_vco_multiplier ch_spc=$channel_spacing pll=$pll_type outclks=$outclks($i)"
            set return_array [get_advanced_pll_legality_solved_legal_pll_values $device_part $ref_clk $rbc_outclk_freq_val($i) $fractional_vco_multiplier $channel_spacing $pll_type $outclks($i)]
            #_dprint 1 "ret = $return_array"
	    #send_message INFO "ret = $return_array"
            set outclk_list { }
            if {[string match -nocase "*error*" $return_array]} {
                #Set the return_array to empty signifying no valid frequencies returned
                set return_array "{}"
                send_message error "Please specify correct output frequencies."
                return -1
            } else {
                #extract frequency
                foreach freq $return_array {
                    regexp {([0-9.]+)} $freq value 
                    lappend outclk_list $value
                }
	    }
            set sorted_outclks [lsort -real $outclk_list]
            foreach f $sorted_outclks {
                lappend outclk_str($i) "$f MHz"
            }
            
            #Prompt error message when frequency is illegal and return 'N/A' as result
            if ![info exist outclk_str($i)] {
                set outclk_str($i) "N/A"
                send_message error "Please specify correct output frequencies."
                return -1
            }		

            if {$outclk_str($i) != "N/A"} {
            ##pass the rbc returned value to the ALLOWED_RANGES for output clock frequency
	        common_map_allowed_range gui_actual_output_clock_frequency$i $return_array
		map_allowed_range_local $return_array $i
                set user_pll_refclk_freq [common_get_mapped_allowed_range_value gui_actual_output_clock_frequency$i]
                set_parameter_value output_clock_frequency$i $user_pll_refclk_freq
            } else {
                common_map_allowed_range gui_actual_output_clock_frequency$i "N/A"	
                set user_pll_refclk_freq [common_get_mapped_allowed_range_value gui_actual_output_clock_frequency$i]
                set_parameter_value output_clock_frequency$i "0 MHz"
            }
        } elseif {$i == $num_count} {
            # Recompute frequencies using the actual frequencies
            for { set val 0 } {$val < $num_count} {incr val} {
                for { set cal 0 } {$cal < $MAX_OUTPUT_CLOCKS} {incr cal} {
                    if {$cal != $val} {
                        lappend recalculate($val) [get_parameter_value output_clock_frequency$cal]
                    }
                }
                set return_array [get_advanced_pll_legality_solved_legal_pll_values $device_part $ref_clk [get_parameter_value output_clock_frequency$val] $fractional_vco_multiplier $channel_spacing $pll_type $recalculate($val)]
                #extract frequency
                set outclk_list {}
                foreach freq $return_array {
                    regexp {([0-9.]+)} $freq value 
                    lappend outclk_list $value
                }
                set sorted_outclks [lsort -real $outclk_list]
                foreach f $sorted_outclks {
                    lappend outclk_str($val) "$f MHz"
                }
            
                #Prompt error message when frequency is illegal and return 'N/A' as result
                if ![info exist outclk_str($val)] {
                    set outclk_str($val) "N/A"
                    send_message error "Please specify correct output frequencies."
                    return -1
                }

                if {$outclk_str($val) != "N/A"} {
                ##pass the rbc returned value to the ALLOWED_RANGES for output clock frequency
                    common_map_allowed_range gui_actual_output_clock_frequency$val $return_array 
                    map_allowed_range_local $return_array $val
		    set user_pll_refclk_freq [common_get_mapped_allowed_range_value gui_actual_output_clock_frequency$val]
                    set_parameter_value output_clock_frequency$val $user_pll_refclk_freq
                } else {
                    common_map_allowed_range gui_actual_output_clock_frequency$val "N/A"	
                    set user_pll_refclk_freq [common_get_mapped_allowed_range_value gui_actual_output_clock_frequency$val]
                    set_parameter_value output_clock_frequency$val "0 MHz"
                }
            }
            #for { set another_val $num_count} {$another_val < 18} {incr another_val} {
            #    common_map_allowed_range gui_actual_output_clock_frequency$another_val [common_get_mapped_allowed_range_value gui_actual_output_clock_frequency$another_val]
            #}
        } else {
            # must make sure any string parameter that will receive an allowed range when enabled, also has one at start-up
            # common_map_allowed_range gui_actual_output_clock_frequency$i [common_get_mapped_allowed_range_value gui_actual_output_clock_frequency$i]
        }
        
    }
     #setting color coded warning message indicating desired vs actual PLL settings
    set_warning_label
    
    set end_v_total [clock clicks -milliseconds]
    set r_total [expr {$end_v_total - $start_v_total}]
    #_dprint 1  "generic_total = $generic_total"
    #_dprint 1  "generic_total_time = $generic_total_time"
    #_dprint 1  "total validation time = $r_total"


}


proc map_allowed_range_local {element_array index } {

    set local_list [list]
    foreach val $element_array {
      lappend local_list $val
    }
    

    set cmode [get_parameter_value gui_clocking_mode]
    if {$index == 0 } {
        if { $cmode == "true" }  {
          #set_parameter_property gui_interface_clock_frequency ALLOWED_RANGES $local_list
	  #set_parameter_value gui_interface_clock_frequency [lindex $local_list 0]
	} else {
          #set_parameter_property gui_actual_user_clock_frequency ALLOWED_RANGES $local_list
	  set local_val [::alt_xcvr::utils::common::get_freq_in_mhz [lindex $local_list 0] ]
	  set_parameter_value gui_actual_user_clock_frequency "$local_val"
	}
    } elseif {$index == 1} {
        #set_parameter_property gui_actual_coreclkin_frequency ALLOWED_RANGES $local_list
	set local_val [::alt_xcvr::utils::common::get_freq_in_mhz [lindex $local_list 0] ]
	set_parameter_value gui_actual_coreclkin_frequency "$local_val"
    }

}


proc set_warning_label {} {

    set num_clocks 2
    #accumulate the differencees over all clocks to see if either
    #can't be implemented
    set diff 0
    set i 0
    #for { set i 0 } {$i < $num_clocks} {incr i} {
        
        set en_adv 0
        set output_freq_actual_noMHz [get_parameter_value output_clock_frequency$i]
        regsub {([ MHz]+)} $output_freq_actual_noMHz {} output_freq_actual_noMHz
        if {$en_adv} {
            set user_mult [get_parameter_value gui_multiply_factor]
			set user_div_n [get_parameter_value gui_divide_factor_n]
            set user_div_c [get_parameter_value gui_divide_factor_c$i]
			set user_div [expr {$user_div_n * $user_div_c}]
            set user_frac [get_parameter_value gui_frac_multiply_factor]
            set actual_mult [get_parameter_value gui_actual_multiply_factor$i]
            set actual_div [get_parameter_value gui_actual_divide_factor$i]
            set actual_frac [get_parameter_value gui_actual_frac_multiply_factor$i]
            set diff [expr {$diff + abs($user_mult-$actual_mult)}]
            set diff [expr {$diff + abs($user_div-$actual_div)}]
            set diff [expr {$diff + abs($user_frac-$actual_frac)}]
        } else {
            set output_freq_user_noMHz [get_parameter_value gui_output_clock_frequency$i]
            regsub {([ MHz]+)} $output_freq_user_noMHz {} output_freq_user_noMHz 
            set diff [expr {$diff + abs($output_freq_user_noMHz-$output_freq_actual_noMHz)}]
        }

        #set phase_shift_actual_nops [get_parameter_value phase_shift$i]
        #regsub {([ ps]+)} $phase_shift_actual_nops {} phase_shift_actual_nops 
        #set ps_units [get_parameter_value gui_ps_units$i]
        #if {$ps_units == "ps"} {
        #    set phase_shift_user_nops [get_parameter_value gui_phase_shift$i]
        #    regsub {([ ps]+)} $phase_shift_user_nops {} phase_shift_user_nops 
        #    set diff [expr {$diff + abs($phase_shift_user_nops -$phase_shift_actual_nops )}]
        #} else {
        #    set phase_shift_user_deg [get_parameter_value gui_phase_shift_deg$i]
        #    regsub {([ ps]+)} $phase_shift_user_deg {} phase_shift_user_deg
        #    set phase_shift_user_deg_to_ps [degrees_to_ps $phase_shift_user_deg $output_freq_actual_noMHz]
        #    regsub {([ ps]+)} $phase_shift_user_deg_to_ps {} phase_shift_user_deg_to_ps
        #    set diff [expr {$diff + abs($phase_shift_user_deg_to_ps-$phase_shift_actual_nops )}]
        #}


    #}
    if {$diff > 0} {
        send_message warning "Actual User Clock differs from requested"
	send_message INFO "Changing the resolution of the desired user clock may derive the requested clock to the expected value"
    } else {
        #send_message info "Able to implement PLL with user settings"
    }

}
proc copy_actual_values {} {
    
    set num_clocks [get_parameter_value gui_number_of_clocks]
    for { set i 0 } {$i < $num_clocks} {incr i} {
        #getting all the actual values
        set output_freq_actual_noMHz [get_parameter_value output_clock_frequency$i]
        regsub {([ MHz]+)} $output_freq_actual_noMHz {} output_freq_actual_noMHz
        set phase_shift_actual_nops [get_parameter_value phase_shift$i]
        regsub {([ ps]+)} $phase_shift_actual_nops {} phase_shift_actual_nops 

        #get the phase shift in degrees
        set phase_shift_actual_deg [lindex [ps_to_degrees $phase_shift_actual_nops $output_freq_actual_noMHz] 0]
        regsub {([ deg]+)} $phase_shift_actual_deg {} phase_shift_actual_deg

        set_parameter_value gui_output_clock_frequency$i $output_freq_actual_noMHz
        
        set_parameter_value gui_phase_shift$i $phase_shift_actual_nops
        set_parameter_value gui_phase_shift_deg$i $phase_shift_actual_deg
            set phase_shift_user_deg [get_parameter_value gui_phase_shift_deg$i]
        # _dprint 1 "user = $phase_shift_user_deg\n"
        
    }
}


proc my_terminate_port { port_name termination_value direction } {
	ipcc_set_port_termination $port_name $termination_value $direction

}

proc get_advanced_pll_legality_solved_legal_pll_values {device_part ref_clk rbc_outclk_freq fractional_vco_multiplier channel_spacing pll_type outclks} {
	set solved_freqs [list]
	set result_out [list]
	set return_array [list]
	lappend param_args $device_part
	lappend param_args "$ref_clk MHz"
	lappend param_args $rbc_outclk_freq
	lappend param_args "0 ps"
	lappend param_args 50
	lappend param_args $fractional_vco_multiplier
	lappend param_args $pll_type
	lappend param_args $channel_spacing
	for {set solved_clock_index 0} {$solved_clock_index < [llength $outclks]} {incr solved_clock_index} {
		set solved_freq [lindex $outclks $solved_clock_index]
		lappend param_args "$solved_freq"
		lappend param_args "0 ps"
		lappend param_args 50
	}

  	#output clock frequency rules
	# send_message INFO "param_args = $param_args"
	set result_out [my_set_rbc_check OUTPUT_CLOCK_FREQUENCY $param_args]
	#strip off {{ and }} from RBC
	regsub {([\{]+)} $result_out {} result_out
	regsub {([\}]+)} $result_out {} result_out
	#split each refclk freq returned
	set return_array [split $result_out |]

	return $return_array
}

proc precision_check {params} {
	set output_0 [lindex [split $params .] 0]
	set output_1 [lindex [split $params .] 1]
	if {[string length $output_1] > 6} {
		set first_val [expr $params - $output_0]
		set second_val [expr {int([expr $first_val * 1000000])}]
		set third_val [expr $second_val/1000000.0]
		set forth_val [expr $output_0 + $third_val]
	} else {
		set forth_val $params
	}
   # _dprint 1 $forth_val 
	return $forth_val
}

proc get_advanced_pll_legality_solved_legal_phase_values {device_part ref_clk rbc_outclk_freq fractional_vco_multiplier channel_spacing pll_type outclks phase rbc_outclk_phase} {
	set solved_freqs [list]
	set result_out [list]
	set return_array [list]
	lappend phase_args $device_part
	lappend phase_args "$ref_clk MHz"
	lappend phase_args $rbc_outclk_freq
	lappend phase_args $rbc_outclk_phase
	lappend phase_args 50
	lappend phase_args $fractional_vco_multiplier
	lappend phase_args $pll_type
	lappend phase_args $channel_spacing
	set width [llength $outclks]

	for {set solved_clock_index 0} {$solved_clock_index < [llength $outclks]} {incr solved_clock_index} {
		set solved_freq [lindex $outclks $solved_clock_index]
		set solved_phase [lindex $phase $solved_clock_index]
		lappend phase_args "$solved_freq"
		lappend phase_args $solved_phase
		lappend phase_args 50
	}

  	#output clock frequency rules
	set result_out [my_set_rbc_check PHASE_SHIFT $phase_args]
	#strip off {{ and }} from RBC
	regsub {([\{]+)} $result_out {} result_out
	regsub {([\}]+)} $result_out {} result_out
	#split each refclk freq returned
	set return_array [split $result_out |]
	return $return_array
}

proc degrees_to_ps {phase_array freq} {
    
    set return_phase_array [list]
    foreach phase_val $phase_array {
        regexp {([-0-9.]+)} $phase_val phase_value 
        regexp {([-0-9.]+)} $freq freq_value 
        #convert negative phase shift to positive phase shift
        if {$phase_value < 0} {
            set phase_value [expr {360 - abs($phase_value)}]
        }
        set phase_in_ps [expr {$phase_value /(360*$freq_value)}]
        #convert to ps
        set phase_in_ps [expr {$phase_in_ps * 1000000.0}]
        set phase_in_ps [expr {round($phase_in_ps)}]
        lappend return_phase_array $phase_in_ps
    }
    return $return_phase_array

}
proc ps_to_degrees {phase_array freq} {
    set return_phase_array [list]
    foreach phase_val $phase_array {
        regexp {([-0-9.]+)} $phase_val phase_value 
        regexp {([-0-9.]+)} $freq freq_value 
        set phase_in_deg [expr {$phase_value*360.0*$freq_value}]
        set phase_in_deg [expr {round($phase_in_deg/1000000.0)}]
        set phase_in_deg [expr {$phase_in_deg%360}]
        set phase_in_deg "$phase_in_deg deg"
        lappend return_phase_array $phase_in_deg
    }
    return $return_phase_array


}
proc is_legal_range {value} {
    
}


proc get_reference_list_items { item values } {

    set device [lindex $values 0]

    if { $item == "speed" } {  


       set speed 0
       if {($device == "Stratix V") || ($device == "Arria 10")} {
            common_map_allowed_range gui_device_speed_grade {"1" "2" "3" "4"}	
            send_message INFO "Please check Arria 10 speed grade"
            set speed [common_get_mapped_allowed_range_value gui_device_speed_grade]
        } elseif {$device == "Arria V"} {
            common_map_allowed_range gui_device_speed_grade {"3_H3" "3_H4" "4_H4" "5_H3" "5_H4" "6_H6"}	
            set speed [common_get_mapped_allowed_range_value gui_device_speed_grade]
        } elseif {$device == "Arria V GZ"} {
            common_map_allowed_range gui_device_speed_grade {"3" "4"}
            set speed [common_get_mapped_allowed_range_value gui_device_speed_grade]
        } elseif {$device == "Cyclone V"} {
            common_map_allowed_range gui_device_speed_grade {"6" "7" "8"}	
            set speed [common_get_mapped_allowed_range_value gui_device_speed_grade]
        }
        
        return $speed
    } elseif {$item == "device_part"} {
       set device_part "None"
       set speed [lindex $values 1]
       if { ($device == "Arria 10") } {
         set device_part "nightfury5_f1932bc2"
       } elseif {! ($device == "StratixV" || $device == "Stratix V" || $device == "Arria V" || $device == "ArriaV" || $device == "CycloneV" || $device == "Cyclone V" || $device == "Arria V GZ")} {
            send_message error "Altera PLL only supports the Stratix V, Arria V and Cyclone V device family. For other device families, use ALTPLL or Avalon ALTPLL."
        } elseif {$speed == "1"} {
            set device_part "5SGXEB6R1F43C1"
        } elseif {$speed == "2"} {
            set device_part "5SGXEA7H2F35C2ES"
        } elseif {$speed == "3"} {
            set device_part "5SGXEA7H2F35C3ES"
        } elseif {$speed == "4"} {
            set device_part "5SGXEA7H3F35C4ES"
        } elseif {$speed == "3_H3"} {
            set device_part "5AGTFD7H3F35I3"
        } elseif {$speed == "3_H4"} {
            set device_part "5AGXFB7H4F35I3"
        } elseif {$speed == "4_H4"} {
            set device_part "5AGXFB3H4F35C4"
        } elseif {$speed == "5_H3"} {
            set device_part "5AGTFD7H3F35I5"
        } elseif {$speed == "5_H4"} {
            set device_part "5AGXFB3H4F35C5"
        } elseif {$speed == "6_H6"} {
            set device_part "5AGXFB3H6F35C6"
        } elseif {$speed == "6"} {
            set device_part "5CGTFD6F27C5ES"
        } elseif {$speed == "7"} {
            set device_part "5CGXBC7C6U19C7"
        } elseif {$speed == "8"} {
            set device_part "5CGXBC7C7F23C8"
        }
        return $device_part
    } elseif {$item == "pll_type"} {
        set pll_type "fPLL"
        return $pll_type
        
    } elseif {$item == "channel_spacing"} {
       if { [get_parameter_value gui_pll_mode] == "Fractional-N PLL"} {
            set channel_spacing [get_parameter_value gui_channel_spacing]
            set channel_spacing "$channel_spacing kHz"
        } else {
            set channel_spacing "0.0 MHz"
        }
        return $channel_spacing
    } elseif {$item == "fractional_vco_multiplier"} {
       if { [get_parameter_value gui_pll_mode] == "Fractional-N PLL"} {
            set fractional_vco_multiplier "true"
        } else {
            set fractional_vco_multiplier "false"
        }
        return $fractional_vco_multiplier 
    }
}

set generic_total 0
set generic_total_time 0

proc my_set_rbc_check { rule_name reference_list } {
    set r_total 0
    global generic_total
    global generic_total_time
    set start_v_total [clock clicks -milliseconds]
    #_dprint 1 "rule = $rule_name\n $reference_list"
    #send_message INFO "rule = $rule_name\n $reference_list"
    #return -1
	set result [::quartus::advanced_pll_legality::get_advanced_pll_legality_legal_values -flow_type MEGAWIZARD -configuration_name GENERIC_PLL -rule_name $rule_name -param_args $reference_list]
    set end_v_total [clock clicks -milliseconds]
    #_dprint 1 "return = $result"
    #send_message INFO "return = $result"
    set generic_total [incr generic_total]
    set r_total [expr {$end_v_total - $start_v_total}]
    set generic_total_time [expr {$generic_total_time + $r_total}]
    #_dprint 1  "total rbc time = $r_total"
    return $result
    
}

add_display_item "User Interface" disp_note text ""
