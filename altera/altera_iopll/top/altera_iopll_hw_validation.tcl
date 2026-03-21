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


# ===============================================================================================================
# | VALIDATION
# | Validation step deals with setting all parameters
# | (physical and non-physical)
# | The main validation callback is validation_callback
# | During validation callback, the values of parameters with DERIVED=false (parameters the user can change)
# | cannot be set. 
# ===============================================================================================================

proc validation_callback {} {
    # Description:
    #   This is the main validation callback. It runs every time the user changes a 
    #   parameter, after the parameter upgrade callbacks. Validation ensures that 
    #   all then user's settings are within the legal ranges, and sets physical
    #   parameters based on the validated GUI parameters. 
	# Inputs: none
	
    #--------------Step 1: Update the System Parameters and Allowed Ranges ---------------------
    # Unfortunately, changing these does not prompt their update callback to 
    # run, so we update them first thing during validation. 
    ::altera_iopll::update_callbacks::gui_device_family_update
    ::altera_iopll::update_callbacks::gui_device_component_update
    ::altera_iopll::update_callbacks::gui_device_speed_grade_update

	# The ALLOWED_RANGES propery is not saved in the .qsys file, so we need to
    # initialize it appropriately the first time that the gui opens (if it is empty)

    set qsys_mode [get_parameter_value hp_qsys_scripting_mode]
    set vco_dropdown_list [get_parameter_property gui_vco_frequency ALLOWED_RANGES]
    if {[get_parameter_value hp_qsys_scripting_mode]} {
        ::altera_iopll::update_callbacks::initialize_dropdowns "QSYS_SCRIPTING"
    } elseif {[llength $vco_dropdown_list] < 3} {
        ::altera_iopll::update_callbacks::initialize_dropdowns "INITIALIZATION"
    }

    # ----------- Step 2: Send Update Messages -------------------------------------------------
    # HACK: During upgrade callbacks, if Qsys runs into a problem, we are not able to send
    # messages to the qsys message box! To work around this, we keep track of the messages that
    # we *want* to send during the update callbacks, and then actually send them now. 
	foreach message_command [get_parameter_value hp_parameter_update_message] {
        eval $message_command
    }

	#------------- Step 3: Update Visibility ---------------------------------------------------
    # Update the visibility of all parameters, and whether or not they are enabled. 
	set_gui_visibility	

	#------------- Step 4: Validate GUI Parameters ---------------------------------------------
    # Validate all the user's desired values
    # We trust that the update callbacks have set the dropdowns to legal values. 
    # (If not, this is a qcl/pll bug and set_physical_parameter_values will error out)
    if {[gui_reference_clock_frequency_validation] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[gui_dps_num_validation] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[pre_output_counters_validation] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[gui_vco_frequency_validation] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[gui_refclk1_frequency_validation] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[gui_clock_name_string_validation] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[gui_mif_filename_validation] == "TCL_ERROR"} {
		return TCL_ERROR
	}
  
	#------------ Step 5: Set and Validate Physical Parameters  --------------------------------
    # Sethe physical parameters based on the gui parameter values
    set_physical_parameter_values
	
	#------------ Step 6: Update Physical Parameter Table --------------------------------------
	update_table
   
	#------------ Step 7: Warnings and Errors  -------------------------------------------------
    # Most info and warning messages should reside inside of this function
	post_info_and_warning_messages  
}


proc gui_reference_clock_frequency_validation {} {
    # Description:
    #  Get the legal reference clock frequency range from qcl/pll and ensure that the value
    #  of gui_reference_clock_frequency is within that range. 
	# Inputs: none
	
	set device_family [get_parameter_value gui_device_family]
	set speedgrade [get_parameter_value gui_device_speed_grade]
	set refclk_freq [get_parameter_value gui_reference_clock_frequency]

    # Use computation code to get refclk range
	if { [catch {get_legal_physical_parameters_validation -device_family $device_family \
														  -device_speedgrade $speedgrade} result] } {
		altera_iopll::util::pll_send_message DEBUG "Error in get_legal_physical_parameters_validation: $result"
		return TCL_ERROR
	}
	array set result_array $result
	
	# Set the allowable refclk range based on result from computation code.
	set min_refclk_freq $result_array(refclk_min)
	set max_refclk_freq $result_array(refclk_max)
	set_parameter_property gui_reference_clock_frequency ALLOWED_RANGES "$min_refclk_freq:$max_refclk_freq"
	
	if {$refclk_freq < $min_refclk_freq || $refclk_freq > $max_refclk_freq} {
		altera_iopll::util::pll_send_message ERROR \
          "Reference clock frequency $refclk_freq is out of legal range ($min_refclk_freq:$max_refclk_freq)"
		return TCL_ERROR
	}
	return TCL_OK
}

proc gui_dps_num_validation {} {
    # Description:
    #  Get the legal dps range from qcl/pll and ensure that the value of gui_dps_num is within that range. 
	# Inputs: none
	
	set device_family [get_parameter_value gui_device_family]
	set speedgrade [get_parameter_value gui_device_speed_grade]
	set dps_num [get_parameter_value gui_dps_num]

	# Get the legal dps_num range (based on Device Family) from qcl/pll computation code
	if { [catch {get_legal_dps_num_range -device_family $device_family} result] } {
		altera_iopll::util::pll_send_message ERROR "$result"
		return TCL_ERROR
	}
	set_parameter_property gui_dps_num	ALLOWED_RANGES	$result	

    # Ensure user's value is within legal range
    set split_range [split $result ":"]
	set min_num [lindex $split_range 0]
	set max_num [lindex $split_range 1]
	if {$dps_num < $min_num || $dps_num > $max_num} {
		altera_iopll::util::pll_send_message ERROR \
              "Number of Dynamic Phase Shifts $dps_num is out of legal range ($result)"
		return TCL_ERROR
	}
}

proc pre_output_counters_validation {} {
    # Description:
    #   If using advanced mode, check to ensure that the pre-c-counter (M and N) are legal, 
    #   (ensure that the counter values themselves are legal, and that the VCO and PFD frequencies
    #   produced are also legal.  
	# Inputs: none

	set family [get_parameter_value gui_device_family]
	set speedgrade [get_parameter_value gui_device_speed_grade]
	set refclk_freq [get_parameter_value gui_reference_clock_frequency]
	set x [get_parameter_value gui_fractional_cout]
	set is_fractional [altera_iopll::util::is_pll_mode_fractional]	
	set m [get_parameter_value gui_multiply_factor]
	set n [get_parameter_value gui_divide_factor_n]
	set k [get_parameter_value gui_frac_multiply_factor]
    set clock_to_compensate [get_parameter_value gui_clock_to_compensate]
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
    set gui_en_adv_params [get_parameter_value gui_en_adv_params]
    
    if {$gui_en_adv_params} {
    	if {($gui_use_NDFB_modes)} {
    		# C0 is in the feedback loop
            # This is equivalent to m = m*counter_in_the_loop in terms of legality.
            set counter_in_loop [get_parameter_value gui_divide_factor_c$clock_to_compensate]
    		set m [expr {$m * $counter_in_loop}]
    	}

        # Get legal m counter range from qcl/pll and set multiply factor allowed ranges. 
    	set ref_list [list 	-family $family \
                            -type IOPLL \
    						-speedgrade $speedgrade \
    						-is_fractional $is_fractional \
    						-compensation_mode [altera_iopll::util::get_operation_mode_for_computation]]
        if {[catch {::quartus::pll::legality::get_legal_m_cnt_range $ref_list} result]} {
    	    altera_iopll::util::pll_send_message ERROR $result
    		return TCL_ERROR
    	} 
        array set result_array $result
        set min_val $result_array(m_min)
        set max_val $result_array(m_max)
        set_parameter_property gui_multiply_factor ALLOWED_RANGES "$min_val:$max_val"

        # Get legal m counter range from qcl/pll and set divide factor n allowed ranges. 
        if {[catch {::quartus::pll::legality::get_legal_n_cnt_range $ref_list} result]} {
    	    altera_iopll::util::pll_send_message ERROR $result
    		return TCL_ERROR
    	} 
        array set result_array $result
        set min_val $result_array(n_min)
        set max_val $result_array(n_max)
        set_parameter_property gui_divide_factor_n ALLOWED_RANGES "$min_val:$max_val"

        # Call validate_pre_c_counters to ensure that resulting VCO and PFD frequencies are within
        # their legal ranges. 
    	set ref_list [list 	-family $family \
    						-speedgrade $speedgrade \
    						-is_fractional $is_fractional \
    						-m $m \
    						-n $n \
    						-x $x \
    						-k $k \
    						-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
    						-refclk_freq $refclk_freq]
    	if {[catch {::quartus::pll::legality::validate_pre_c_counters $ref_list} result]} {
    	    altera_iopll::util::pll_send_message ERROR $result
    		return TCL_ERROR
    	} 
    }
    return TCL_OK
}

proc gui_vco_frequency_validation {} {
    # Description:
    #  Get the legal VCO range from qcl/pll and ensure that the value
    #  of gui_fixed_vco_frequency is within that range, if it is specified. 
	# Inputs: none
    
	set family [get_parameter_value gui_device_family]
	set speedgrade [get_parameter_value gui_device_speed_grade]
	set type IOPLL
	set is_fractional [altera_iopll::util::is_pll_mode_fractional]
	set fixed_vco_freq [get_parameter_value gui_fixed_vco_frequency]
	set using_adv_mode [get_parameter_value gui_en_adv_params]
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]

    if {$fixed_vco_freq && !$gui_use_NDFB_modes} {
    	# Get legal VCO range from computation code
    	set ref_list [list -family $family \
    						-type $type \
    						-speedgrade $speedgrade \
    						-is_fractional $is_fractional \
    						-compensation_mode [altera_iopll::util::get_operation_mode_for_computation]]         
    	if {[catch {::quartus::pll::legality::get_legal_vco_range $ref_list} result]} {
    		altera_iopll::util::pll_send_message ERROR "Unable to retrieve legal vco range: $result"
    		return TCL_ERROR
    	} 
    	array set result_array $result
    	set vco_min $result_array(vco_min)
    	set vco_max $result_array(vco_max)
    	if {$fixed_vco_freq < $vco_min || $fixed_vco_freq > $vco_max} {
    		altera_iopll::util::pll_send_message ERROR "Desired VCO frequency of $fixed_vco_freq MHz is \
               out of range ($vco_min MHz - $vco_max MHz)"
    		return TCL_ERROR
    	}
    }
	return TCL_OK
}


proc gui_refclk1_frequency_validation {} {
    # Description:
    #  Get the legal secondary reference clock frequency range from qcl/pll and ensure that the value
    #  of gui_refclk1_frequency is within that range, if the secondary reference clock is enabled. 
	# Inputs: none
	
	# Skip validation if the secondary reference clock is not enabled. 
	if { [get_parameter_value gui_refclk_switch] } {
		set refclk_1_freq		[get_parameter_value    gui_refclk1_frequency]
		set refclk				[get_parameter_value    gui_reference_clock_frequency]
		set device_family		[get_parameter_value    gui_device_family]
		set device_speedgrade 	[get_parameter_value    gui_device_speed_grade]
        set is_fractional       [altera_iopll::util::is_pll_mode_fractional]
		set usr_en_adv_mode		[get_parameter_value    gui_en_adv_params]
		set usr_en_counter_casc	[get_parameter_value    gui_enable_output_counter_cascading]
		set x 					[get_parameter_value    gui_fractional_cout]
		set m 					[get_parameter_value    gui_multiply_factor]
		set n 					[get_parameter_value    gui_divide_factor_n]
		set k 					[get_parameter_value    gui_frac_multiply_factor]
		set usr_num_clocks	    [get_parameter_value    gui_number_of_clocks]
		array set c_counters_actual_settings\
                   [altera_iopll::util::make_validated_c_counter_array duty $usr_num_clocks]
		set device_type "IOPLL"

		if {$usr_en_adv_mode} {
			set ref_list [list 	-family $device_family \
						-type $device_type \
						-speedgrade $device_speedgrade \
						-is_fractional $is_fractional \
						-refclk_freq $refclk \
						-refclk1_freq $refclk_1_freq \
						-x $x \
						-m $m \
						-n $n \
						-k $k \
						-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
						-validated_counter_settings [array get c_counters_actual_settings]]
		} else {
			set ref_list [list 	-family $device_family \
						-type $device_type \
						-speedgrade $device_speedgrade \
						-is_fractional $is_fractional \
						-refclk_freq $refclk \
						-refclk1_freq $refclk_1_freq \
						-is_counter_cascading_enabled $usr_en_counter_casc \
						-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
						-validated_counter_settings [array get c_counters_actual_settings]]		
		}

		if {[catch {::quartus::pll::legality::validate_secondary_refclk_frequency $ref_list} result]} {
			altera_iopll::util::pll_send_message ERROR "Validation of secondary reference clock frequency failed: $result"
			return TCL_ERROR
		}
		
	}
	return TCL_OK
}

proc gui_clock_name_string_validation {} {
    # Description:
    #    Ensure that all the outclk names specified by the user are unique
    #    and do not have the character "|" 
	# Inputs: none

	set all_names [list]
	
	# Create a list of all the global clock names assigned by the user.
	set num_clocks [get_parameter_value gui_number_of_clocks]
	for {set i 0} {$i < $num_clocks} {incr i} {
		set current_name [get_parameter_value gui_clock_name_string$i]
        
		# Perform checks for any illegal characters
        if {![regexp {^[A-Z,a-z]+[a-z,A-Z,0-9,_]*$} $current_name] && ($current_name != "")} {
			altera_iopll::util::pll_send_message ERROR "Output clock $i name contains illegal characters"
			return TCL_ERROR
		}
        
		# Don't add it if it's ""
		if {$current_name != ""} {
			lappend all_names $current_name		
		} else {
			altera_iopll::util::pll_send_message warning "No clock name provided for outclk$i. \
                  Backwards compatible clock names will be used. Upgraded clock naming cannot be used \
                  unless a name is provided."
		}
	}
	
	# Now check for uniqueness
	set unique_list [lsort -unique $all_names]
	if {[llength $unique_list] != [llength $all_names]} {
		altera_iopll::util::pll_send_message ERROR "Output clock names must be unique."
		return TCL_ERROR
	}
	return TCL_OK
}

proc gui_mif_filename_validation {} {
    # Description:
    #   If the user wants to create a MIF file and the file name specified already exists, disable
    #   the button and send a warning. 
    #   If the user wants to add a conguration to a MIF file and the file name specified doesn't exist,
    #   disable the button and send a warning. 
	# Inputs: none

    set gui_en_reconf [get_parameter_value gui_en_reconf]
    set gui_mif_gen_options [get_parameter_value gui_mif_gen_options]
    set gui_new_mif_file_path [get_parameter_value gui_new_mif_file_path]
    set gui_existing_mif_file_path [get_parameter_value gui_existing_mif_file_path]
    set gui_device_family [get_parameter_value gui_device_family]
    set mif_file_path [file normalize $gui_new_mif_file_path]
    set file_exists true

    if {$gui_en_reconf  && ($gui_mif_gen_options == "Generate New MIF File")} {
        if {$gui_new_mif_file_path == ""} {
            send_message ERROR "Path to New MIF File ('') is invalid"
            set_display_item_visibility	ENABLED	"Append to MIF File" false
            set file_exists false
        } else {
            set mif_file_path [file normalize $gui_new_mif_file_path]
            set file_exists [file exists $mif_file_path]
            if {$file_exists} {      
                # The user wants to generate a file that already exists. 'Create MIF File' will overwrite it. 
                send_message WARNING "File $mif_file_path currently exists. Either choose a new file name \
                     or select 'Add Configuration to Existing MIF file' to append to this file."
                set_display_item_visibility	ENABLED	"Create MIF File" false
            } else {
                # The user wants to generate a file that doesn't exist. 
                send_message INFO "File $mif_file_path does not yet exist. Click 'Create MIF File' to \
                        create a file containing the current configuration."
                set_display_item_visibility	ENABLED	"Create MIF File" true
            }
        }
    } elseif {$gui_en_reconf && ($gui_mif_gen_options == "Add Configuration to Existing MIF File")} {
        if {$gui_existing_mif_file_path == ""} {
            send_message ERROR "Path to Existing MIF File ('') is invalid"
            set_display_item_visibility	ENABLED	"Append to MIF File" false
            set file_exists false
        } else {
            set mif_file_path [file normalize $gui_existing_mif_file_path]
            set file_exists [file exists $mif_file_path]
            if {$file_exists} {   
                # The user wants to append to an existing file   
                send_message INFO "File $mif_file_path exists. Click 'Append to MIF File' \
                   to append current configuration to the file."
                set_display_item_visibility	ENABLED	"Append to MIF File" true
            } else {
                # The user wants to append to a file that doesn't exist.  This isn't possible. 
                send_message WARNING "File $mif_file_path does not exist. Either enter the name of \
                     an existing file or select 'Generate New MIF File' to create a file at this location."
                set_display_item_visibility	ENABLED	"Append to MIF File" false
            }
        }
    } 

    # If the family is Stratix10 then show a summary of the contents of the MIF file, using
    # the altera_iopll_reconfig packages.  
    if {$file_exists && $gui_device_family == "Stratix 10" && $gui_en_reconf \
         && ($gui_mif_gen_options != "Create MIF file during IP Generation")} {
         set ROM_width 16
         set valid_mif_list [altera_iopll_reconfig::mif_validation::validate_reconfig_mif_file \
                                $mif_file_path $ROM_width]
         set valid_mif [lindex $valid_mif_list 0]
         set_parameter_value mifTable_names [lindex $valid_mif_list 1]
         set_parameter_value mifTable_values [lindex $valid_mif_list 2]
         if {!$valid_mif && ($gui_mif_gen_options == "Add Configuration to Existing MIF File")} {
             send_message WARNING "File $mif_file_path exists but is invalid."
         } 
    } else { 
        set_parameter_value mifTable_names {"The MIF file specified does not yet exist"}
        set_parameter_value mifTable_values {}
    }      

   if {$gui_device_family == "Stratix 10" && $gui_en_reconf 
         && ($gui_mif_gen_options != "Create MIF file during IP Generation")} {
       set_display_item_visibility VISIBLE "mifTable" true
   } else {
       set_display_item_visibility VISIBLE "mifTable" false
   }

}

proc update_table {} {
    # Description:
    #  Update the physical parameter table with the new physical parameter values. 
	# Inputs: none
	set max_instances [get_parameter_value hp_number_of_family_allowable_clocks]
	incr max_instances -1
	set instances "0-$max_instances"
	array set data_array [::altera_pll_physical_parameters::make_phys_param_table_ordered_lists $instances]
	set names $data_array(NAMES)
	set values $data_array(VALUES)
	
	set_parameter_value parameterTable_names $names
	set_parameter_value parameterTable_values $values
}
	
proc post_info_and_warning_messages {} {
    # Description:
    #  Checks for a variety of problems and issues info messages and warnings. 
	# Inputs: none

	set ref_switch [get_parameter_value	gui_refclk_switch]     
	set ref_switch_mode [get_parameter_value gui_switchover_mode]
    set gui_en_adv_params [get_parameter_value gui_en_adv_params]

	# Inform the user whether their requested settings are achievable exactly
	if {[actual_settings_equal_requested_settings] || $gui_en_adv_params} {
		altera_iopll::util::pll_send_message INFO "Able to implement PLL with user settings"
	} else {
		altera_iopll::util::pll_send_message WARNING \
            "Able to implement PLL - Actual settings differ from Requested settings"
	}

    # Warn if we could be using NDFB mode but are not
    set gui_operation_mode [get_parameter_value gui_operation_mode]
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
    set gui_device_family  [get_parameter_value gui_device_family]
	if {[expr {(($gui_operation_mode == "normal") || ($gui_operation_mode == "source synchronous")) \
               && !$gui_use_NDFB_modes && ($gui_device_family == "Stratix 10")}]} {
		altera_iopll::util::pll_send_message WARNING "The compensation mode selected uses extra clock \
            resources. In order to conserve clock resources and to improve precision of timing analysis,\
            select 'Use Nondedicated Feedback Path'"
	}
	
	# Issue a warning if Dynamic Phase Shift ports and Dynamic Reconfiguration are simultaneously enabled
	if { [get_parameter_value gui_en_reconf] && [get_parameter_value gui_en_dps_ports] } {
		altera_iopll::util::pll_send_message WARNING "By enabling access to Dynamic Phase Shift ports, \
            the phase shift capabilities of Dynamic Reconfiguration are disabled."
		altera_iopll::util::pll_send_message WARNING "Dynamic phase shift and dynamic reconfiguration \
           share a common clock source in the IOPLL. With both features enabled, you must connect the \
           same clock to the scanclk on the IOPLL and the mgmt_clk on the Altera PLL Reconfig IP."
	}

    # Inform the user what the DPS increment is. 
    if {[get_parameter_value gui_en_dps_ports]} {
        set vco_freq [get_parameter_value gui_vco_frequency]
        set vco_period [expr {1000000/$vco_freq}]
        set ps_increment [expr {$vco_period / 8}]
        set rounded_ps_increment [altera_iopll::util::round_phase $ps_increment]
        altera_iopll::util::pll_send_message INFO "For this IOPLL's current configuration, performing \
           one dynamic phase shift will result in a phase shift of $rounded_ps_increment picoseconds."
    }

    # Issue a warning if Dynamic Reconfiguration is enabled, and there are phase shifts
    set num_clocks [get_parameter_value gui_number_of_clocks]
    set no_phase_shifts true
	for { set i 0 } {$i < $num_clocks} {incr i} {
        set units_deg [expr {[get_parameter_value gui_ps_units$i] == "degrees"}]
        set curr_phase_not_zero [expr {($units_deg && ([get_parameter_value gui_actual_phase_shift_deg$i] > 0)) \
                            || (!$units_deg && ([get_parameter_value gui_actual_phase_shift$i] != 0)) \
                            || ($units_deg && ([get_parameter_value gui_phase_shift_deg$i] != 0)) \
                            || (!$units_deg && ([get_parameter_value gui_phase_shift$i] != 0))}]     
        if {$curr_phase_not_zero} {
            set no_phase_shifts false
        }
    }
	if { [get_parameter_value gui_en_reconf] && !$no_phase_shifts } {
		altera_iopll::util::pll_send_message ERROR "Performing Dynamic Reconfiguration on an IOPLL with a \
           static phase shift is not recommended, as it will result in unexpected phase relationships \
           after reconfiguration."
	}
	
	# If this PLL is to be used for as the upstream PLL in a PLL-to-PLL cascade, outclk 8
    #  will be used for the cascade connection. Whichever output counter that the user has
    #  indicated should be used for the cascade connection will be copied into counter 8.
	if { [get_parameter_value gui_enable_cascade_out] } {
		set index [get_parameter_value gui_cascade_outclk_index]
		if {$index != 8} {
			altera_iopll::util::pll_send_message INFO "Output clock 8 will be used as the cascading \
               source.  Outclk$index parameters will be copied to/swapped with outclk8."
		}
	}

	# If extswitch is exported, add an info message for clarification
	if {$ref_switch && ($ref_switch_mode == "Manual Switchover") || \
        ($ref_switch_mode == "Automatic Switchover with Manual Override") } {
	       	altera_iopll::util::pll_send_message INFO "In Manual Switchover Mode, the reference clock \
                used toggles between refclk and refclk1 on the rising edge of the extswitch signal."
	}
	
	# Warning messages regarding refclk1 != refclk frequency
	if { [get_parameter_value gui_refclk_switch] } {
		set refclk  [get_parameter_value gui_reference_clock_frequency]
		set refclk1 [get_parameter_value gui_refclk1_frequency]
		set relative_diff [expr abs($refclk1 - $refclk) / $refclk]
		if { $refclk1 != $refclk } {
			altera_iopll::util::pll_send_message WARNING "The second reference clock frequency is \
                different from the primary reference clock. You must run TimeQuest at both frequencies \
                to ensure timing closure."
		}
		# The following warnings come from from section 12.2 of the SV PLL NPP. 
        #  We expect this to be the same for NF IOPLL.
		if {$relative_diff > 0.20} {
			altera_iopll::util::pll_send_message WARNING "The frequency difference between 'refclk' and \
                'refclk1' exceeds 20%: Automatic clock loss detection will not work."
			altera_iopll::util::pll_send_message WARNING "The frequency difference between 'refclk' and \
                'refclk1' exceeds 20%: The 'clkbad' signals are now invalid."
		}
	}
}

proc actual_settings_equal_requested_settings {} {
    # Description:
    #  Warn the user if the actual settings (from the dropdown menus) do not match their desired settings.  
	# Inputs: none
	set equal true
	set num_clocks [get_parameter_value number_of_clocks]
	set adv_mode   [get_parameter_value gui_en_adv_params]
    set gui_vco_frequency [get_parameter_value gui_vco_frequency]
    set gui_fixed_vco_frequency [get_parameter_value gui_fixed_vco_frequency]
    set gui_vco_frequency [get_parameter_value gui_vco_frequency]
    set gui_vco_frequency [get_parameter_value gui_vco_frequency]

	if {$gui_vco_frequency != $gui_fixed_vco_frequency} {
        if {[get_parameter_value gui_fix_vco_frequency] && ![get_parameter_value gui_use_NDFB_modes]} {
		    set equal false
        }
	}
	
	# Check whether actual and desired outclk frequencies, phase and duty cycles are equal
	for {set i 0} {$i < $num_clocks} {incr i} {
		# Check whether actual and desired outclk frequencies are equal
		if {!$adv_mode} { 
            set gui_output_clock_frequency [get_parameter_value gui_output_clock_frequency$i]
            set gui_actual_output_clock_frequency [get_parameter_value gui_actual_output_clock_frequency$i]
			if {$gui_output_clock_frequency != $gui_actual_output_clock_frequency} {
               
				set equal false
				break
			}
		}
		# Check whether actual and desired duty cycles are equal
        set gui_duty_cycle [get_parameter_value gui_duty_cycle$i]
        set gui_actual_duty_cycle [get_parameter_value gui_actual_duty_cycle$i]
		if {$gui_duty_cycle != $gui_actual_duty_cycle} {
			set equal false
			break
		}
		# Check whether actual and desired phase shifts are equal
		set phase_shift_unit [get_parameter_value gui_ps_units$i]
		if {$phase_shift_unit == "ps"} {
            set gui_phase_shift [get_parameter_value gui_phase_shift$i]
            set gui_actual_phase_shift [get_parameter_value gui_actual_phase_shift$i]
			if {$gui_phase_shift != $gui_actual_phase_shift} {
				set equal false
				break
			}
		} else {
            set gui_phase_shift_deg [get_parameter_value gui_phase_shift_deg$i]
            set gui_actual_phase_shift_deg [get_parameter_value gui_actual_phase_shift_deg$i]
			if {$gui_phase_shift_deg != $gui_actual_phase_shift_deg} {
				set equal false
				break
			}
		}
	}
	return $equal
}

#================================================================================================================
# | VISIBILITY
# |
# |  Note: as a rule, everything should be ENABLED unless the condition is family specific
# |  
#================================================================================================================

proc set_gui_visibility {} {
    # Description:
    #   Set the visibility of all parameters. If unset in this function, then the visibility
    #   depends on the default value set in altera_iopll_hw.tcl (generally visible). 
    #   This function also sets whether or not each parameter is enabled.  
	# Inputs: none
	
	# Get required parameters
	set device_family				[get_parameter_value		gui_device_family]
	set usr_operation_mode			[get_parameter_value		gui_operation_mode]
	set usr_is_fractional_mode		[altera_iopll::util::is_pll_mode_fractional]
	set usr_enabled_advanced_params	[get_parameter_value		gui_en_adv_params]
	set usr_n_output_clocks			[get_parameter_value		gui_number_of_clocks]
	set usr_en_dpa_port				[get_parameter_value		gui_en_phout_ports]
	set usr_enabled_extclkout_ports	[get_parameter_value		gui_en_extclkout_ports]
	set usr_en_second_refclk		[get_parameter_value		gui_refclk_switch]
	set usr_en_reconfig				[get_parameter_value		gui_en_reconf]
	set usr_en_dps_for_mif			[get_parameter_value		gui_enable_mif_dps]
	set usr_en_outclk_cascading		[get_parameter_value		gui_enable_output_counter_cascading]
	set usr_en_cascade_pll_out		[get_parameter_value		gui_enable_cascade_out]
	set usr_en_cascade_pll_in		[get_parameter_value		gui_enable_cascade_in]
	set usr_en_output_counter_cascading	[get_parameter_value	gui_enable_output_counter_cascading]
	set usr_fix_vco_freq			[get_parameter_value		gui_fix_vco_frequency]
	set lvds_ports_en               [get_parameter_value        gui_en_lvds_ports]
	set use_NDFB                    [get_parameter_value        gui_use_NDFB_modes]
	set clk_to_comp                 [get_parameter_value        gui_clock_to_compensate]
	set device_component            [get_parameter_value        system_info_device_component]
	set device_speed_grade          [get_parameter_value        system_info_device_speed_grade]
	set gui_en_dps_ports            [get_parameter_value        gui_en_dps_ports]
	set gui_pll_auto_reset          [get_parameter_value        gui_pll_auto_reset]
    set gui_mif_gen_options         [get_parameter_value        gui_mif_gen_options]
    
	# Get the check box for each counter's value for cascading.
	set usr_en_outclk_casc_indv [list ]
	set usr_en_prev_outclk_casc_indv false
	set usr_can_en_outclk_casc_indv [list ]
	set usr_can_en_prev_casc_indv false
	for {set i 0 } {$i < 18} {incr i} {
		if {$usr_en_outclk_cascading} {
			set val 	[get_parameter_value	gui_cascade_counter$i]
			lappend usr_en_outclk_casc_indv			$val
			lappend usr_en_prev_outclk_casc_indv	$val
			lappend usr_can_en_outclk_casc_indv		[expr {$i < ($usr_n_output_clocks - 1)}]
			lappend usr_can_en_prev_casc_indv		[expr {$i < ($usr_n_output_clocks - 1)}]
		} else {
			lappend usr_en_outclk_casc_indv			false
			lappend usr_en_prev_outclk_casc_indv	false
			lappend usr_can_en_outclk_casc_indv		false	
			lappend usr_can_en_prev_casc_indv		false
		}
	}

	# Set visibility of each parameter
	
	#---------------PLL TAB---------------
	# Device Section
	set_parameter_visibility	VISIBLE		gui_pll_mode	false
	set_parameter_visibility VISIBLE gui_device_component  \
        [expr {!($device_component == "Unknown" || $device_component == "")}]
	set_parameter_visibility VISIBLE gui_usr_device_speed_grade \
        [expr {($device_component == "Unknown" || $device_component == "" \
        || $device_speed_grade == "Unknown" || $device_speed_grade == "")}]
	set_parameter_visibility VISIBLE gui_device_speed_grade \
        [expr {!($device_component == "Unknown" || $device_component == "" \
        || $device_speed_grade == "Unknown" || $device_speed_grade == "")}]
	
	# General Section
	set_parameter_visibility VISIBLE gui_fractional_cout \
        [expr {($usr_enabled_advanced_params && $usr_is_fractional_mode)}]
	set_parameter_visibility VISIBLE gui_dsm_out_sel \
        [expr {($usr_enabled_advanced_params && $usr_is_fractional_mode)}]
	
	# Feedback Section 
	set_display_item_visibility	VISIBLE	gui_use_NDFB_modes \
        [expr {($device_family == "Stratix 10") && ($usr_operation_mode == "normal" \
        || $usr_operation_mode == "source synchronous")}]
	set_display_item_visibility	VISIBLE	gui_clock_to_compensate	 \
        [expr {($usr_operation_mode == "normal" || $usr_operation_mode == "source synchronous") \
        && ($device_family == "Stratix 10")}]
	set_display_item_visibility	VISIBLE	gui_feedback_clock	 false
	
	# Output Clocks Section
	set_parameter_visibility VISIBLE gui_multiply_factor 	  $usr_enabled_advanced_params
	set_parameter_visibility VISIBLE gui_divide_factor_n 	  $usr_enabled_advanced_params
	set_parameter_visibility VISIBLE gui_frac_multiply_factor \
        [expr {($usr_enabled_advanced_params && $usr_is_fractional_mode)}]
	set_parameter_visibility VISIBLE gui_fixed_vco_frequency \
        [expr {!$usr_enabled_advanced_params && $usr_fix_vco_freq && !$use_NDFB}]
	set_parameter_visibility ENABLED gui_fixed_vco_frequency \
        [expr {$usr_fix_vco_freq  && !$use_NDFB}]
	set_parameter_visibility VISIBLE gui_vco_frequency	\
        [expr {$usr_enabled_advanced_params || ($usr_fix_vco_freq && !$use_NDFB)}]
	set_parameter_visibility VISIBLE gui_fix_vco_frequency \
        [expr {!$usr_enabled_advanced_params && !$use_NDFB}]
	set_display_item_visibility	VISIBLE	NDFB_warning   [expr {$use_NDFB}]
	set_display_item_visibility	VISIBLE	normal_warning [expr {($usr_operation_mode == "normal") \
         && !$use_NDFB}]
    set_display_item_visibility	VISIBLE	ss_warning \
     	[expr {($usr_operation_mode == "source synchronous") && !$use_NDFB}]
    set_display_item_visibility	VISIBLE	direct_warning	  [expr {($usr_operation_mode == "direct")}]
    set_display_item_visibility	VISIBLE	external_warning  \
        [expr {($usr_operation_mode == "external feedback")}]
    set_display_item_visibility	VISIBLE	zdb_warning	\
        [expr {($usr_operation_mode == "zero delay buffer")}]
    set_display_item_visibility	VISIBLE	lvds_warning [expr {($usr_operation_mode == "lvds")}]
	set_display_item_visibility	VISIBLE	NDFB_phase_warning [expr {$use_NDFB}]
	set_display_item_visibility	VISIBLE	LVDS_port_instruction0 [expr {($lvds_ports_en != "Disabled")}]
	set_display_item_visibility	VISIBLE	LVDS_port_instruction1 [expr {($lvds_ports_en != "Disabled")}]
	set_display_item_visibility	VISIBLE	LVDS_port_instruction2a	 \
        [expr {$lvds_ports_en == "Enable LVDS_CLK/LOADEN 0"}]
	set_display_item_visibility	VISIBLE	LVDS_port_instruction2b	\
        [expr {$lvds_ports_en == "Enable LVDS_CLK/LOADEN 0 & 1"}]
	set_display_item_visibility	VISIBLE	LVDS_port_instruction3	\
        [expr {$lvds_ports_en == "Enable LVDS_CLK/LOADEN 0 & 1"}]
	set_display_item_visibility	VISIBLE	LVDS_port_instruction4 \
 		[expr {$lvds_ports_en == "Enable LVDS_CLK/LOADEN 0 & 1"}]
	set_display_item_visibility	VISIBLE	Bootstrap_counter_7_disabled [expr {$gui_pll_auto_reset}]
    set_display_item_visibility	VISIBLE	"Dynamic Phase Shift (MIF)" [expr {$device_family != "Stratix 10"}]

	#---------------OUTCLK VISIBILITY---------------
	# NOTE: whatever you set in the lower if must also be unset in the upper if
	# for the counters desired by the user
	for { set i 0 } {$i < $usr_n_output_clocks} {incr i} {
	    # If using LVDS_CLK/LOADEN 0, don't allow the user to use outclocks 2 and 3
	    set lvds_skip [expr {$device_family == "Stratix 10"} && {$lvds_ports_en == "Enable LVDS_CLK/LOADEN 0"} && [expr {$i == 2} || {$i == 3}] ]
	    altera_iopll::util::pll_send_message DEBUG "lvds_skip? expr? = $lvds_skip"
	    # Don't display any configuration options if auto reset is enabled (because of the bootstrap fix)
	    set skip [expr {$gui_pll_auto_reset && ($i ==7)}]
		set_display_item_visibility	VISIBLE	outclk$i   \
	    [expr {!$lvds_skip}]
		set_parameter_visibility VISIBLE gui_divide_factor_c$i [expr {$usr_enabled_advanced_params && !$skip}]
		set_parameter_visibility VISIBLE gui_cascade_counter$i \
            [expr {[lindex $usr_can_en_outclk_casc_indv $i] && $usr_enabled_advanced_params && !$skip}]
		set_parameter_visibility VISIBLE gui_output_clock_frequency$i \
            [expr {!($usr_enabled_advanced_params) && !$skip}]
		set_parameter_visibility ENABLED gui_phase_shift$i \
            [expr {!([lindex $usr_can_en_prev_casc_indv $i] && [lindex $usr_en_prev_outclk_casc_indv $i])}]

		set_parameter_visibility VISIBLE gui_phase_shift$i \
            [expr {([get_parameter_value gui_ps_units$i] != "degrees") && !$skip}]

		set_parameter_visibility VISIBLE gui_phase_shift_deg$i \
            [expr {([get_parameter_value gui_ps_units$i] == "degrees") && !$skip}]

		set_parameter_visibility VISIBLE gui_actual_phase_shift$i \
            [expr {([get_parameter_value gui_ps_units$i] != "degrees") && !$skip}]

		set_parameter_visibility VISIBLE gui_actual_phase_shift_range$i \
            [expr {([get_parameter_value gui_ps_units$i] != "degrees") && !$skip}]

		set_parameter_visibility VISIBLE gui_actual_phase_shift_deg$i  \
            [expr {([get_parameter_value gui_ps_units$i] == "degrees") && !$skip}]

		set_parameter_visibility VISIBLE gui_actual_phase_shift_deg_range$i  \
            [expr {([get_parameter_value gui_ps_units$i] == "degrees") && !$skip}]

		set_display_item_visibility	VISIBLE	clock_to_compensate_message$i \
            [expr {$clk_to_comp == $i && ($usr_operation_mode == "normal" \
            || $usr_operation_mode == "source synchronous") && ($device_family == "Stratix 10")}]
		set_parameter_visibility ENABLED gui_duty_cycle$i \
            [expr {!([lindex $usr_can_en_outclk_casc_indv $i] \
            && [lindex $usr_en_outclk_casc_indv $i])}]
       	set_parameter_visibility VISIBLE gui_clock_name_string$i		    	        [expr {!$skip}]
       	set_parameter_visibility VISIBLE gui_actual_output_clock_frequency_range$i      [expr {!$skip}]
       	set_parameter_visibility VISIBLE gui_actual_output_clock_frequency$i            [expr {!$skip}]
       	set_parameter_visibility VISIBLE gui_duty_cycle$i					            [expr {!$skip}]
       	set_parameter_visibility VISIBLE gui_actual_duty_cycle$i				        [expr {!$skip}]
       	set_parameter_visibility VISIBLE gui_actual_duty_cycle_range$i				    [expr {!$skip}]
       	set_parameter_visibility VISIBLE gui_ps_units$i					                [expr {!$skip}]
	}
	for { set i $usr_n_output_clocks } { $i < 18 } {incr i} {
		# Set all parameters to invisibly for unused outclks
		set_display_item_visibility	VISIBLE	outclk$i false
	}

	#-------------SETTINGS TAB----------------

	# Physical Settings
	set_parameter_visibility VISIBLE gui_lock_setting [expr {($device_family == "Stratix 10")}]

	# LVDS Ports
	set_parameter_visibility VISIBLE gui_en_lvds_ports true
    
	# DPA
	# Do not display the entire DPA section for Cyclone V
	set_display_item_visibility	VISIBLE	"DPA Output" [expr {($device_family != "Cyclone V")}]
	set_parameter_visibility VISIBLE gui_phout_division	false
    
	# Clock Switchover
	set_parameter_visibility ENABLED gui_refclk1_frequency $usr_en_second_refclk
    
	# Clock Switchover Ports
	set_display_item_visibility ENABLED	"Clock Switchover Ports" $usr_en_second_refclk
    
	# Input Clock Switchover mode
	set_display_item_visibility	ENABLED	"Input Clock Switchover Mode" $usr_en_second_refclk
    
	# External output clock
	set pll_compensation_mode [get_parameter_value gui_operation_mode]
	set_parameter_visibility ENABLED gui_en_extclkout_ports true
	set_parameter_visibility ENABLED gui_extclkout_0_source	\
       [expr {!($pll_compensation_mode == "external feedback" \
       || $pll_compensation_mode == "zero delay buffer") && $usr_enabled_extclkout_ports}]
	set_parameter_visibility ENABLED gui_extclkout_1_source	$usr_enabled_extclkout_ports
	
	#-----------CASCADING TAB--------------------
    set_parameter_visibility ENABLED gui_enable_cascade_out     	[expr {!($usr_en_cascade_pll_in)}]
	set_parameter_visibility ENABLED gui_cascade_outclk_index   	[expr {!($usr_en_cascade_pll_in)}]
	set_parameter_visibility VISIBLE gui_cascade_outclk_index   	[expr {!($usr_en_cascade_pll_in)}]

    set_parameter_visibility ENABLED gui_enable_cascade_in      	[expr {!($usr_en_cascade_pll_out)}]
	set_parameter_visibility ENABLED gui_pll_cascading_mode	    	[expr {!($usr_en_cascade_pll_out)}]
	set_parameter_visibility VISIBLE gui_pll_cascading_mode	false
	set_parameter_visibility ENABLED gui_enable_output_counter_cascading false	
	set_display_item_visibility	VISIBLE "Output Counter Cascading" false
			        
	#----------DYNAMIC RECONFIGURATION TAB--------
    set_parameter_visibility ENABLED gui_en_dps_ports           [expr {!($usr_en_reconfig)}]
    set_parameter_visibility ENABLED gui_en_reconf              [expr {!($gui_en_dps_ports)}]
	# Mif tab
	set_parameter_visibility ENABLED gui_mif_gen_options        [expr {$usr_en_reconfig}]
    set_parameter_visibility VISIBLE gui_new_mif_file_path  \
       [expr {($gui_mif_gen_options == "Generate New MIF File")}]
    set_parameter_visibility VISIBLE gui_existing_mif_file_path \
       [expr {($gui_mif_gen_options == "Add Configuration to Existing MIF File")}]
    set_parameter_visibility ENABLED gui_new_mif_file_path      [expr {$usr_en_reconfig}]
    set_parameter_visibility ENABLED gui_existing_mif_file_path [expr {$usr_en_reconfig}]
    set_display_item_visibility	VISIBLE gui_mif_config_name     [expr {($device_family == "Stratix 10")}]  
    set_display_item_visibility	ENABLED gui_mif_config_name     [expr {$usr_en_reconfig}]
 
	# DPS mif tab
	set_parameter_visibility ENABLED gui_enable_mif_dps \
       [expr {($usr_en_reconfig && $device_family != "Stratix 10")}]
	set_parameter_visibility ENABLED gui_dps_cntr		[expr {($usr_en_reconfig && $usr_en_dps_for_mif)}]
	set_parameter_visibility ENABLED gui_dps_num		[expr {($usr_en_reconfig && $usr_en_dps_for_mif)}]
	set_parameter_visibility ENABLED gui_dps_dir		[expr {($usr_en_reconfig && $usr_en_dps_for_mif)}]

    # MIF buttons
	set_display_item_visibility	VISIBLE	"Create MIF File" \
       [expr {($gui_mif_gen_options == "Generate New MIF File")}]  
    set_display_item_visibility	VISIBLE	"Append to MIF File" \
       [expr {($gui_mif_gen_options == "Add Configuration to Existing MIF File")}]
}

proc set_display_item_visibility {property param_name value} {
	set_display_item_property	$param_name $property [string is true $value]
}

proc set_parameter_visibility {property param_name value} {
	set_parameter_property	$param_name $property [string is true $value]
}

proc set_parameter_enabled {param_name should_enable} {
	set_parameter_property $param_name ENABLED $should_enable
}

# ===============================================================================================================
# | PHYSICAL PARAMETER VALIDATION
# |  Each of these functions sets a physical parameter based on the corresponing
# |  gui parameters. 
# |
# ===============================================================================================================

proc set_physical_parameter_values {} {
    # Description:
    #   This function sets the values of all the physical IOPLL parameters. These settings depend 
    #   on the corresponding GUI parameters. eg gui_pll_bandwidth_preset -->  pll_bw_sel.
	#   This function now must also set the ENABLED value of the physical parameters if required. 
	# Inputs: none
	# Call each of the physical functions

	::altera_pll_physical_parameters::update_pll_type
	::altera_pll_physical_parameters::update_pll_subtype
	::altera_pll_physical_parameters::update_fractional_vco_multiplier
	::altera_pll_physical_parameters::update_reference_clock_frequency
	::altera_pll_physical_parameters::update_operation_mode
	::altera_pll_physical_parameters::update_number_of_clocks
	::altera_pll_physical_parameters::update_pll_clkin_0_src
	::altera_pll_physical_parameters::update_pll_slf_rst
	::altera_pll_physical_parameters::update_pll_bw_sel
	::altera_pll_physical_parameters::update_clock_names
	::altera_pll_physical_parameters::update_fb_params
	::altera_pll_physical_parameters::update_refclk_switchover_params
	::altera_pll_physical_parameters::update_extclk_cnt_src_params
	::altera_pll_physical_parameters::update_pll_lock_fltr
	
	# Get parameters required by qcl/pll get_physical_parameters_for_generation
	set x [get_parameter_value gui_fractional_cout]
	set device_family [get_parameter_value gui_device_family]
	set speed_grade [get_parameter_value gui_device_speed_grade]
	set bw_preset [get_parameter_value gui_pll_bandwidth_preset]
	array set c_counters_desired_settings {}
	set usr_num_clocks [get_parameter_value number_of_clocks]
	set changed_clock [expr {$usr_num_clocks - 1}]
	set usr_enabled_adv_params [get_parameter_value gui_en_adv_params]
    set clock_to_compensate [get_parameter_value gui_clock_to_compensate]
	
	array set c_counters_desired_settings [altera_iopll::util::make_validated_c_counter_array \
                                              duty $usr_num_clocks]
	set m [get_parameter_value gui_multiply_factor]
	set n [get_parameter_value gui_divide_factor_n]
	set k [get_parameter_value gui_frac_multiply_factor]
	set refclk_value [get_parameter_value gui_reference_clock_frequency]
	set is_fractional false
	set usr_enabled_counter_cascading [get_parameter_value gui_enable_output_counter_cascading]

    # Get the physical parameter using the computation code, based on the final hp (full precision)
    # values calulated during validation and in the update callbacks. 
	if { [catch {get_physical_parameters_for_generation \
				-using_adv_mode $usr_enabled_adv_params \
	 			-device_family $device_family \
	 			-device_speedgrade $speed_grade \
	 			-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
	 			-refclk_freq $refclk_value \
	 			-is_fractional $is_fractional \
	 			-x $x \
	 			-m $m \
	 			-n $n \
	 			-k $k \
	 			-bw_preset $bw_preset \
	 			-is_counter_cascading_enabled $usr_enabled_counter_cascading \
	 			-validated_counter_settings [array get c_counters_desired_settings]} \
	 	result] } {
	 	altera_iopll::util::pll_send_message ERROR "$result"
		altera_iopll::util::pll_send_message DEBUG "Failed in get_physical_parameters_for_generation"
		return TCL_ERROR
	}
	array set result_array $result
	
	# Now set values based on qcl/pll output 
	set_parameter_value pll_bwctrl $result_array(bw)
	set_parameter_value pll_cp_current $result_array(cp)
	set_parameter_value pll_output_clk_frequency \
        "[altera_iopll::util::round_to_atom_precision $result_array(vco_freq)] MHz"
	set_parameter_value pll_fractional_cout $result_array(x)
	set_parameter_value pll_fractional_division $result_array(k)
	
	# M values
	array set m_array $result_array(m)
	set_parameter_value m_cnt_hi_div $m_array(m_high)
	set_parameter_value m_cnt_lo_div $m_array(m_low)
	set_parameter_value m_cnt_bypass_en $m_array(m_bypass_en)
	set_parameter_value m_cnt_odd_div_duty_en $m_array(m_tweak)
	
	# N values
	array set n_array $result_array(n)
	set_parameter_value n_cnt_hi_div $n_array(n_high)
	set_parameter_value n_cnt_lo_div $n_array(n_low)
	set_parameter_value n_cnt_bypass_en $n_array(n_bypass_en)
	set_parameter_value n_cnt_odd_div_duty_en $n_array(n_tweak)
	
	# C values
	set usr_fixed_vco [get_parameter_value gui_fix_vco_frequency]
	set usr_enabled_adv_params [get_parameter_value gui_en_adv_params]
    set gui_use_NDFB [get_parameter_value gui_use_NDFB_modes]

    # If the VCO was specified, or if in NDFB mode, then the values returned in
    # result_array(c) are not in same order as the outclks. 
    # VCO specified:  VCO C0 C1 C2 C3 ... C9
    # NDFB mode (eg C3 in the loop):  C3 C0 C1 C2 C4 C5 ... C9
	if {$usr_fixed_vco && !$usr_enabled_adv_params && !$gui_use_NDFB} {
		set using_fixed_vco true
	} else {
		set using_fixed_vco false
	}
    if {$gui_use_NDFB && ($clock_to_compensate != 0) && !$usr_enabled_adv_params} {
		set NDFB_switch_outclk_index true
	} else {
		set NDFB_switch_outclk_index false
	}
    
	array set c_array $result_array(c)
	foreach {c_index_raw c_param_list} [array get c_array] {
		if {$using_fixed_vco && $c_index_raw == 0} {	
            # If the VC0 is specified, it is at index=0. Skip it. 
		} else {
			set c_index $c_index_raw
			if {$using_fixed_vco} {
                # If VCO frequency is specified, then the index of all other outclks is outclk + 1
				incr c_index -1
			} elseif {$NDFB_switch_outclk_index} {
                # If in NDFB mode, then the first outclk in the c_array is actually clock_to_compensate.
                # The index of all other outclks *lower* than clock to compensate is outclk + 1
                if {$c_index_raw == 0} {
                    set c_index $clock_to_compensate
                } elseif {$c_index_raw <= $clock_to_compensate} {
                    incr c_index -1
                }
            }
			array set c_cnt_array $c_param_list
			set_parameter_value 	c_cnt_hi_div$c_index 			$c_cnt_array(c_high)
			set_parameter_value 	c_cnt_lo_div$c_index 			$c_cnt_array(c_low)
			set_parameter_value 	c_cnt_prst$c_index 				$c_cnt_array(c_prst)
			set_parameter_value 	c_cnt_ph_mux_prst$c_index 		$c_cnt_array(c_ph_mux_tap)
			if { $c_cnt_array(c_using_cascade_src) } {
				set_parameter_value c_cnt_in_src$c_index 			"cscd_clk"
			} else {
				set_parameter_value c_cnt_in_src$c_index 			"c_m_cnt_in_src_ph_mux_clk"
			}
			set_parameter_value 	c_cnt_bypass_en$c_index 		$c_cnt_array(c_bypass_en)
			set_parameter_value 	c_cnt_odd_div_duty_en$c_index 	$c_cnt_array(c_tweak)
		}
	}

	# c values (virtual)
	array set c_array $result_array(c)
	foreach {c_index_raw c_param_list} [array get c_array] {
		if {$using_fixed_vco && $c_index_raw == 0} {
            # If the VC0 is specified, it is at index=0. Skip it. 
		} else {
			set c_index $c_index_raw
			if {$using_fixed_vco} {
                # If VCO frequency is specified, then the index of all other outclks is outclk + 1
				incr c_index -1
			} elseif {$NDFB_switch_outclk_index} {
                # If in NDFB mode, then the first outclk in the c_array is actually clock_to_compensate.
                # The index of all other outclks *lower* than clock to compensate is outclk + 1
                if {$c_index_raw == 0} {
                    set c_index $clock_to_compensate
                } elseif {$c_index_raw <= $clock_to_compensate} {
                    incr c_index -1
                }
            }
			array set c_cnt_array $c_param_list
			if {$c_cnt_array(freq) == 0} {
				set_parameter_value output_clock_frequency$c_index 	"0 ps"
			} else {
				set_parameter_value output_clock_frequency$c_index \
                   	"[altera_iopll::util::round_to_n_decimals_cut $c_cnt_array(freq) 6] MHz"
			}
			
			# ALTERA HACK by akertesz
			# case:235364 -- Constra RBC check results in an IE when the phase shift is negative
			# We need to generate with a positive phase shift instead
			# This is a hack; there should be no arithmetic in the GUI code.
			set phase_shift_temp $c_cnt_array(phase)
			set outclock_period [expr 1e6 / $c_cnt_array(freq)]
			while {$phase_shift_temp < 0} {
				set phase_shift_temp [expr $phase_shift_temp + $outclock_period]
			}
			set_parameter_value phase_shift$c_index \
              	"[altera_iopll::util::round_to_n_decimals_cut $phase_shift_temp 0] ps"
			set_parameter_value duty_cycle$c_index \
                "[altera_iopll::util::round_to_n_decimals_cut $c_cnt_array(duty) 0]"
		}
	}
	
	# Now conditionally enable any parameters as required...
	for {set i 0} {$i < [get_parameter_value hp_number_of_family_allowable_clocks]} {incr i} {
		set_parameter_enabled c_cnt_hi_div$i true
		set_parameter_enabled c_cnt_lo_div$i true
		set_parameter_enabled c_cnt_prst$i true
		set_parameter_enabled c_cnt_ph_mux_prst$i true
		set_parameter_enabled c_cnt_in_src$i true
		set_parameter_enabled c_cnt_bypass_en$i true
		set_parameter_enabled c_cnt_odd_div_duty_en$i true
		set_parameter_enabled output_clock_frequency$i true
		set_parameter_enabled phase_shift$i true
		set_parameter_enabled duty_cycle$i true
		set_parameter_enabled clock_name_$i true
	} 
	for {set i [get_parameter_value hp_number_of_family_allowable_clocks]} {$i < 18} {incr i} {
		set_parameter_enabled c_cnt_hi_div$i false
		set_parameter_enabled c_cnt_lo_div$i false
		set_parameter_enabled c_cnt_prst$i false
		set_parameter_enabled c_cnt_ph_mux_prst$i false
		set_parameter_enabled c_cnt_in_src$i false
		set_parameter_enabled c_cnt_bypass_en$i false
		set_parameter_enabled c_cnt_odd_div_duty_en$i false
		set_parameter_enabled output_clock_frequency$i false
		set_parameter_enabled phase_shift$i false
		set_parameter_enabled duty_cycle$i false	
	}
	
	# PLL Cascading : if enabled, swap selected counter with counter 8, or copy it to counter 8
	set_physical_pll_cascading_settings

	# Set debug parameters. 
    ::altera_pll_physical_parameters::update_debug_params
}

proc ::altera_pll_physical_parameters::update_pll_type {} {
	# Input parameters:
	set device_family [get_parameter_value gui_device_family]
	
	# Work
	if {[altera_iopll::util::using_simple_pll] && $device_family == "Stratix 10"} {
		set pll_type "S10_Simple"
    } elseif {$device_family == "Stratix 10"} {
            set pll_type "S10_Physical"
    } else {
            set pll_type $device_family
    }

	set debug_mode [get_parameter_value gui_debug_mode]
    if {$debug_mode} {
        set pll_type [get_parameter_value gui_pll_type]
    }

	# Set value
	set_parameter_value pll_type $pll_type
}

proc ::altera_pll_physical_parameters::update_pll_subtype {} {
	# Input parameters
	set en_reconf	[get_parameter_value gui_en_reconf]
	set en_dps 		[get_parameter_value gui_en_dps_ports]
	set device_family [get_parameter_value gui_device_family]
	 
	# Work
	if {$en_reconf} {
		set pll_subtype "Reconfigurable"
	} elseif {$en_dps} {
		set pll_subtype "DPS"	
	} else {
		set pll_subtype "General"
	}
	
	# Set value
	set_parameter_value pll_subtype $pll_subtype
}

proc ::altera_pll_physical_parameters::update_fractional_vco_multiplier {} {
	# Set value
	set_parameter_value fractional_vco_multiplier [altera_iopll::util::is_pll_mode_fractional]	
}

proc ::altera_pll_physical_parameters::update_reference_clock_frequency {} {
	# Inputs
	set refclk_value [get_parameter_value gui_reference_clock_frequency]
	
	# Set value
	set_parameter_value reference_clock_frequency "$refclk_value MHz"
}

proc ::altera_pll_physical_parameters::update_operation_mode {} {
	# Inputs  
    set pll_compensation_mode [altera_iopll::util::get_operation_mode_for_computation]
    set device_family [get_parameter_value gui_device_family]
	
	# Work
	switch $pll_compensation_mode {
		"source synchronous" {
			set phys_compensation_mode "source_synchronous"
		}
		"zero delay buffer" {
			set phys_compensation_mode "zdb"
		}
		"external feedback" {
			set phys_compensation_mode "external"
		}
		default {
			set phys_compensation_mode $pll_compensation_mode
		}
	}

	#Set value
	set_parameter_value operation_mode $phys_compensation_mode
}

proc ::altera_pll_physical_parameters::update_number_of_clocks {} {
	# Inputs
	set usr_enabled_counter_cascading [get_parameter_value gui_enable_output_counter_cascading]
	set usr_enabled_adv_params [get_parameter_value gui_en_adv_params]
	set gui_num_clocks [get_parameter_value gui_number_of_clocks]
	set max_family_num_clocks [get_parameter_value hp_number_of_family_allowable_clocks]
	set num_clocks_used_by_cascading 0
	set usr_selected_num_clocks [get_parameter_value number_of_clocks]
		
	# Work
	if {!$usr_enabled_counter_cascading || $usr_enabled_adv_params} {
		# If cascading is *not* enabled, then the number of clocks being used will match the user's selection
		# If the user has enabled advanced parameters, then the number of counters used will be explicit also
		set num_clocks $gui_num_clocks
	} else {
		# If cascading *is* enabled (auto cascading)...
		# determine the number of clocks being used by cascading
		set num_clocks [expr {$usr_selected_num_clocks + $num_clocks_used_by_cascading}]
	}
	
	# Set value
	set_parameter_value number_of_clocks $num_clocks
}

proc ::altera_pll_physical_parameters::update_pll_clkin_0_src {} {
	# Inputs
	set user_set_as_downstream_pll	[get_parameter_value gui_enable_cascade_in]
	set user_set_as_upstream_pll	[get_parameter_value gui_enable_cascade_out]
	set user_cascading_mode 		[get_parameter_value gui_pll_cascading_mode]
	
	# Work
	if {$user_set_as_downstream_pll} {
		switch $user_cascading_mode {
			"adjpllin" {
				set pll_clkin_0_src "adj_pll_clk"
			}
			"cclk" {
				set pll_clkin_0_src "fpll"
			}
		}
	} else {
		set pll_clkin_0_src "clk_0"
	}
	
	# Set value
	set_parameter_value	pll_clkin_0_src $pll_clkin_0_src
	set_parameter_enabled pll_clkin_0_src $user_set_as_downstream_pll
}

proc ::altera_pll_physical_parameters::update_pll_slf_rst {} {
	# Inputs
	set auto_reset_enabled [get_parameter_value gui_pll_auto_reset]

	# Set value
	set_parameter_value pll_slf_rst $auto_reset_enabled	
}

proc ::altera_pll_physical_parameters::update_pll_bw_sel {} {
	# Inputs
    set gui_bw_sel [get_parameter_value gui_pll_bandwidth_preset]
    set device_family [get_parameter_value gui_device_family]	
	# Set value
	if {$device_family == "Stratix 10"} {
    switch $gui_bw_sel {
    	"Low" {
            set bw_mode "low_bw"
    	}
    	"Medium" {
            set bw_mode "mid_bw"
    	}
    	"High" {
            set bw_mode "hi_bw"
        }
    }
      	set_parameter_value pll_bw_sel $bw_mode
    } else {
      	set_parameter_value pll_bw_sel $gui_bw_sel	
    }
}

proc ::altera_pll_physical_parameters::update_pll_lock_fltr {} {
	# Inputs
	set lock_setting [get_parameter_value gui_lock_setting]
	
	# Work
    switch $lock_setting {
    	"Low Lock Time" {
	    	set lock_fltr 100
            set lock_mode "low_lock_time"
    	}
    	"Medium Lock Time" {
    		set lock_fltr 2048
            set lock_mode "mid_lock_time"
    	}
    	"High Lock Time" {
    		set lock_fltr 4095
            set lock_mode "hi_lock_time"
        }
    }

	#Set value
	set_parameter_value pll_lock_fltr_cfg $lock_fltr	
    set_parameter_value lock_mode $lock_mode	
}

proc ::altera_pll_physical_parameters::update_clock_names {} {	
    # Inputs
    set device_family         [get_parameter_value gui_device_family]	
	set number_of_clocks [get_parameter_value number_of_clocks]

	# Work
	if {$device_family == "Stratix 10"} {
    	::altera_iopll::util::set_parameters_equal clock_name_global gui_clock_name_global
    }

	for {set i 0} {$i < $number_of_clocks} {incr i} {
		# Set the boolean "using global clock name parameter"    
		if {$device_family != "Stratix 10"} {
        	::altera_iopll::util::set_parameters_equal clock_name_global_$i gui_clock_name_global
         }  
		# Set the actual clock name
		::altera_iopll::util::set_parameters_equal clock_name_$i gui_clock_name_string$i
	} 
	
	for {set i $number_of_clocks} {$i < 9} {incr i} {
		# Set the rest to false and their clock names to ""
		if {$device_family != "Stratix 10"} {
	    	set_parameter_value clock_name_global_$i false
        }
		set_parameter_value clock_name_$i ""
	}
}
proc ::altera_pll_physical_parameters::update_fb_params {} {
	# Inputs
    set pll_compensation_mode [altera_iopll::util::get_operation_mode_for_computation]
    set gui_clk_to_comp       [get_parameter_value gui_clock_to_compensate]
    set device_family         [get_parameter_value gui_device_family]

	# Get prefix
	set prefix_fbclk_mux1 "pll_fbclk_mux_1_"
	set prefix_fbclk_mux2 "pll_fbclk_mux_2_"
	set prefix_m_cnt_in_src "c_m_cnt_in_src_"
	
	switch $pll_compensation_mode {
		"direct" {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}glb"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}m_cnt"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}ph_mux_clk"
		}
		"normal" {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}glb"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}fb_1"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}ph_mux_clk"		
		}
        "NDFB normal" {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}glb"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}m_cnt"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}fbclk_mcnt"		
		}
		"source synchronous" {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}glb"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}fb_1"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}ph_mux_clk"		
		}
        "NDFB source synchronous" {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}glb"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}m_cnt"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}fbclk_mcnt"		
		}
		"zero delay buffer" {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}zbd"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}fb_1"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}ph_mux_clk"		
		}
		"external feedback" {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}zbd"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}fb_1"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}ph_mux_clk"	
		}
		"lvds" {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}lvds"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}fb_1"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}ph_mux_clk"
		}
		default {
			set_parameter_value pll_fbclk_mux_1 "${prefix_fbclk_mux1}glb"
			set_parameter_value pll_fbclk_mux_2 "${prefix_fbclk_mux2}fb_1"
			set_parameter_value pll_m_cnt_in_src "${prefix_m_cnt_in_src}ph_mux_clk"	
		}
	}	
    
     if {($device_family == "Stratix 10")} {
        if {($pll_compensation_mode == "normal" || $pll_compensation_mode == "source synchronous" \
              || $pll_compensation_mode == "NDFB normal" || \
              $pll_compensation_mode == "NDFB source synchronous")} {
            set_parameter_value clock_to_compensate $gui_clk_to_comp
        } else {
            set_parameter_value clock_to_compensate 0
        }
     } 
}

proc ::altera_pll_physical_parameters::update_refclk_switchover_params {} {	
    # Input parameters
	set refclk_switchover_enabled [get_parameter_value gui_refclk_switch]
	set_parameter_enabled refclk1_frequency $refclk_switchover_enabled
	set_parameter_enabled pll_clk_loss_sw_en $refclk_switchover_enabled
	set_parameter_enabled pll_manu_clk_sw_en $refclk_switchover_enabled
	set_parameter_enabled pll_auto_clk_sw_en $refclk_switchover_enabled
	set_parameter_enabled pll_clkin_1_src $refclk_switchover_enabled
	set_parameter_enabled pll_clk_sw_dly $refclk_switchover_enabled	
	
    # Set values
	# Now set their values- but only bother if they're enabled
	# Enable the refclk switchover parameters conditionally if refclk switchover is enabled
	if {$refclk_switchover_enabled} {
		set_parameter_value pll_clkin_1_src "clk_1"
		set_parameter_value pll_clk_loss_sw_en "true"
		set_parameter_value refclk1_frequency "[get_parameter_value gui_refclk1_frequency] MHz"
		::altera_iopll::util::set_parameters_equal pll_clk_sw_dly gui_switchover_delay
		set refclk_switchover_mode [get_parameter_value gui_switchover_mode]
		switch $refclk_switchover_mode {
			"Manual Switchover" {
				set_parameter_value pll_auto_clk_sw_en "false"
				set_parameter_value pll_manu_clk_sw_en "true"
			}
			"Automatic Switchover" {
				set_parameter_value pll_auto_clk_sw_en "true"
				set_parameter_value pll_manu_clk_sw_en "false"
			}
			"Automatic Switchover with Manual Override" {
				set_parameter_value pll_auto_clk_sw_en "true"
				set_parameter_value pll_manu_clk_sw_en "true"				
			}
			default {
				# We should never hit this error - in ip-generate, it should be caught by the 
                # Qsys's allowed ranges
				altera_iopll::util::pll_send_message ERROR 
                   "Illegal refclk switchover mode $refclk_switchover_mode."
			}
		}	
	} 
		
}

proc ::altera_pll_physical_parameters::update_extclk_cnt_src_params {} {
	# Inputs 
	set extclk_en    [get_parameter_value gui_en_extclkout_ports]
	set extclk_0_src [get_parameter_value gui_extclkout_0_source]
	set extclk_1_src [get_parameter_value gui_extclkout_1_source]

    # Set value
	if { $extclk_en } {
		regexp {([0-9.]+)} $extclk_0_src ext0_src
		regexp {([0-9.]+)} $extclk_1_src ext1_src
		set_parameter_value pll_extclk_0_cnt_src "pll_extclk_cnt_src_c_${ext0_src}_cnt"
		set_parameter_value pll_extclk_1_cnt_src "pll_extclk_cnt_src_c_${ext1_src}_cnt"
	} else {
		set_parameter_value pll_extclk_0_cnt_src "pll_extclk_cnt_src_vss"
		set_parameter_value pll_extclk_1_cnt_src "pll_extclk_cnt_src_vss"
	}
}


proc set_physical_pll_cascading_settings {} {
	# Check if pll cascading OUT is enabled
	if {[get_parameter_value gui_enable_cascade_out]} {
		# Then we need to get the user's selected param
		set counter_to_swap [get_parameter_value gui_cascade_outclk_index]
		#HACK - NF specific!!! ... Is this required for ND??
		if {[get_parameter_value number_of_clocks] == 9} {
			# If 9 counters are used, we must swap (a with b)
			altera_iopll::util::swap_physical_clock $counter_to_swap 8
		} else {
			# If fewer, then we copy (from, to)
			altera_iopll::util::copy_physical_clock	$counter_to_swap 8
		}
	}
}

proc ::altera_pll_physical_parameters::update_debug_params {} {
	set debug_mode [get_parameter_value gui_debug_mode]
    set debug_params [altera_iopll::util::get_debug_parameters]
    set other_hdl_params [altera_iopll::util::get_hdl_parameters]
    set gui_debug_params [altera_iopll::util::get_gui_debug_parameters]
    set all_hdl_params [concat $debug_params $other_hdl_params]

    # Go through each gui_ debug param.
    # If its gui_{param_name} corresponding param exists, assign its value 
    # to it.
    if {$debug_mode} {
        foreach param $gui_debug_params {
            set ext_param_name [regsub "gui_" $param ""]
            set exists [lsearch $all_hdl_params $ext_param_name]
            if {$exists != -1} {
                set param_val [get_parameter_value $param]
                set_parameter_property $ext_param_name ENABLED TRUE
                set_parameter_value $ext_param_name $param_val
            }

        }
    }

    # Enable/disable debug HDL params
    foreach param $debug_params {
        if {$debug_mode} {
            set_parameter_property $param ENABLED TRUE
        } else {
            set_parameter_property $param ENABLED FALSE
        }
    }

}
