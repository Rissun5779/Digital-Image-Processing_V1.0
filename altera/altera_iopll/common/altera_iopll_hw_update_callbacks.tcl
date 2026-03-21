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



# +=============================================================================================================
# | 
# | Altera IOPLL PARAMETER UPDATE CALLBACKS
# | 
# +=============================================================================================================

# +=============================================================================================================
# | -  The parameter update callback ({parameter_name}_callback) calls the GUI dropdowns update functions 
# |    that depend on that parameter and need to be updated when that particular parameter is changed.
# | -  Any non-derived parameter that needs to be changed by the GUI has a function that updates the dropdown 
# |    or parameter value based on the other GUI parameters: {parameter_name}_update. 
# |  


package provide altera_iopll::update_callbacks 14.0

namespace eval altera_iopll::update_callbacks {
    # When this is used by altera_iopll_common, export the namespace procedures here!
}

# +=============================================================================================================
# | MAIN and INITIALIZATION CALLBACKS

proc ::altera_iopll::update_callbacks::main_callback {context} { 
    # Description:
    #   Technically, this is the parameter update callback of all GUI parameters. 
    #   main_callback first ensures that system info parameters are up to date
    #   Then in calls the individual update callback of the parameter that was
    #   just changed (context).
	# Inputs: context is the name of the paramer that changed. 

    # We can't send messages from update callbacks, so set hp_parameter_update_message
    # to a list of commands which we then execute during validation to print messages. 
    set debug_string "Starting parameter update messages: $context"
    set_parameter_value hp_parameter_update_message \
        [list [list altera_iopll::util::pll_send_message DEBUG $debug_string]]

    # If the main_callback is ever called, then we are not using qsys-scripting
    set_parameter_value hp_qsys_scripting_mode false

    # Make sure that device family and device component match system info parameters.
    if { [catch {::altera_iopll::update_callbacks::gui_device_family_update}]} {
        altera_iopll::util::pll_send_update_message ERROR "-- Error updating device family."
    }
    if { [catch {::altera_iopll::update_callbacks::gui_device_component_update}]} {
        altera_iopll::util::pll_send_update_message ERROR "-- Error updating device component."
    }
    if {[::altera_iopll::update_callbacks::gui_device_speed_grade_update]} {
        if { [catch {::altera_iopll::update_callbacks::gui_device_speed_grade_callback}]} {
            altera_iopll::util::pll_send_update_message ERROR "-- Error updating speed grade."
        }
    }
 
    # If this is just one instance, find the index, and call the parameters callback. 
    if {[regexp {(gui_output_clock_frequency)([0-9]+)} $context full param_string index] \
        || [regexp {(gui_phase_shift)([0-9]+)} $context full param_string index] \
        || [regexp {(gui_phase_shift_deg)([0-9]+)} $context full param_string index] \
        || [regexp {(gui_duty_cycle)([0-9]+)} $context full param_string index]\
        || [regexp {(gui_divide_factor_c)([0-9]+)} $context full param_string index] } { 
        set callback_name [join [list "::altera_iopll::update_callbacks::" $param_string "_callback"] ""]
        if { [catch {eval [$callback_name $index $index]}]} {
            altera_iopll::util::pll_send_update_message ERROR "-- Error in callback for $context"
        }
        # In Stratix10 if user is using LVDS_CLK/LOADEN 0, must update c2 and c3 to match c0 and c1
        set gui_device_family [get_parameter_value gui_device_family]
        if { $gui_device_family == "Stratix 10" } {
            set lvds_ports_en [get_parameter_value gui_en_lvds_ports]
            if { [expr {$lvds_ports_en == "Enable LVDS_CLK/LOADEN 0"}] } {
                altera_iopll::util::pll_send_update_message DEBUG "-- copying C0 and C1 parameters to C2 and C3"
                if { [expr {$index == 0}] } {
                    if { [catch {eval [$callback_name 2 0]}]} {
                    altera_iopll::util::pll_send_update_message ERROR "2- Error in callback for $context: $callback_name"
                    }
                } elseif { [expr {$index == 1}] } {
                    if { [catch {eval [$callback_name 3 1]}]} {
                    altera_iopll::util::pll_send_update_message ERROR "3- Error in callback for $context: $callback_name"
                    }
                }
            } 
        }
    } else {
        # Otherwise, run {parameter_name}_callback. 
        set callback_name [join [list "::altera_iopll::update_callbacks::" $context "_callback"] ""]
        if { [catch {eval [$callback_name]}]} { 
            altera_iopll::util::pll_send_update_message ERROR "-- Error in callback for $context "
        }
    }

    return true
}

proc ::altera_iopll::update_callbacks::initialize_dropdowns { mode } { 
    # Description: 
    #  This callback goes through all ranges that may need to be updated. Three situations:
    #  - IP Upgrade: (UPGRADE)        
    #         Called from the upgrade callback.
    #         We are only able to change the actual value and the hp value during the upgrade callback.
    #         We are not able to change actual allowed ranges or hp allowed ranges 
    #         Set actual & hp values to the legal value closest to the *desired* value
    #         since in previous releases the actual value was not saved correctly. 
    #  - Dropdown initialization: (INITIALIZATION)
    #         Called from the validation callback the first time the qsys file is opened, and during generation.
    #         When validation/generation is called for the first time, the allowed ranges are empty
    #         and the hp values are set to default, so these need to be initialized. 
    #         We are not allowed to change actual values during this qsys stages. 
    #         Set the allowed ranges and hp values to legal values closest to the *actual* values. 
    #  - Qsys scripting validation: (QSYS_SCRIPTING)
    #         If qsys scripting is used, then the update callbacks are not called automatically. 
    #         So the desired values are set, and the actual values are meaningless. 
    #         We are not allowed to change actual values during the validation stage. 
    #         So we just set the hp values and ranges, which we will later use to get the physical values.

    if {$mode eq "UPGRADE"} {
        set update_actual_ranges false
        set update_actual_value true
        set update_hp_ranges false
        set update_hp_value true
        set ignore_desired_value false
    } elseif {$mode eq "QSYS_SCRIPTING"} {
        set update_actual_ranges true
        set update_actual_value false
        set update_hp_ranges true
        set update_hp_value true
        set ignore_desired_value false
    } else {
        set update_actual_ranges true
        set update_actual_value false
        set update_hp_ranges true
        set update_hp_value true
        set ignore_desired_value true
    }
    altera_iopll::util::pll_send_message DEBUG " Initializing dropdown ranges." 
   
    # These dropdowns depend on the number of outclks enabled
    ::altera_iopll::update_callbacks::gui_dps_cntr_update \
                                           $update_actual_ranges $update_actual_value
    ::altera_iopll::update_callbacks::gui_extclkout_source_update \
                                           $update_actual_ranges $update_actual_value 
    ::altera_iopll::update_callbacks::gui_cascade_outclk_index_update \
                                           $update_actual_ranges $update_actual_value 
    ::altera_iopll::update_callbacks::gui_clock_to_compensate_update \
                                           $update_actual_ranges $update_actual_value
 
    if {$mode eq "QSYS_SCRIPTING"} {
        set update_actual_ranges false
    }

    # These dropdowns depend on refclk frequency, family etc. 
    ::altera_iopll::update_callbacks::gui_vco_frequency_update \
                                          $update_actual_ranges $update_actual_value \
                                          $update_hp_ranges $update_hp_value $ignore_desired_value
 
    if { "$mode" != "UPGRADE" } {
        set update_actual_value true
        set update_actual_ranges true
        set ignore_desired_value false
    }

    ::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_first_outclk_to_update] freq \
                                          $update_actual_ranges $update_actual_value \
                                          $update_hp_ranges $update_hp_value $ignore_desired_value

    # Ensure that for irrelevant parameters, range and value match
    # The value doesn't matter, we just need it to be within the ALLOWED_RANGES list.
    if {$update_actual_ranges} {
        ::altera_iopll::update_callbacks::update_unused_ranges
    }

    altera_iopll::util::pll_send_message DEBUG " Done initializing dropdown ranges."
    return true
}

proc ::altera_iopll::update_callbacks::update_unused_ranges {} { 
    # Description: 
    #   Update the ALLOWED_RANGES property of invisible outclks to ensure that they always include
    #   the actual value... The value doesn't matter, but there would be an error if the range doesn't 
    #   include the actual value.  
    # Inputs: none

    # Get all required parameter values
    set all_clks [get_parameter_value hp_number_of_family_allowable_clocks]
    set index [get_parameter_value gui_number_of_clocks]

    # Loop though all unused outclks, and update with 'update_actual_ranges = true'
    while {$index < $all_clks} {
        if {[::altera_iopll::update_callbacks::gui_actual_output_clock_frequency_update $index true] \
                == "TCL_ERROR"} {
		   return TCL_ERROR
	    }
        if {[::altera_iopll::update_callbacks::gui_actual_phase_shift_ps_deg_update $index true] \
                == "TCL_ERROR"} {
		    return TCL_ERROR
	    }
        if {[::altera_iopll::update_callbacks::gui_actual_duty_cycle_update $index true] == "TCL_ERROR"} {
		    return TCL_ERROR
	    }
        incr index
    }  
}

proc ::altera_iopll::update_callbacks::update_all_outclks_in_order { first_index first_param_type \
                                           {update_actual_ranges true} {update_actual_value true} \
                                           {update_hp_ranges true} {update_hp_value true} \
                                           {ignore_desired_value false}} { 
    # Description: 
    #   Update the GUI dropdowns associated with the outclks (frequency phase and duty) in order of priority
    #   First frequencies in order, then phase_shifts in order and then duty cycles in order. 
    # Inputs:  - first index is the index of the first value to be updated 
    #          - first_param_type is the type of the first value ot be updated: phase, duty or frequency
    #          - if update_actual_ranges, change actual ALLOWED RANGES. 
    #          - if update_actual_value, change actual value.
    #          - if update_hp_ranges, change hp ALLOWED RANGES. 
    #          - if update_hp_value, change hp value.
    #          - if ignore_desired_value, find legal values closest to the actual value
    altera_iopll::util::pll_send_update_message DEBUG \
                  " -- Updating all outclk values in order, starting with $first_param_type $first_index"

    # Get all required parameter values
    set num_clks [get_parameter_value gui_number_of_clocks] 

    # If starting with frequency, update all frequencies in order from first_index on  
    if {$first_param_type eq "freq"} {
        while {$first_index < $num_clks} {
            if {[::altera_iopll::update_callbacks::gui_actual_output_clock_frequency_update \
                     $first_index $update_actual_ranges $update_actual_value \
                     $update_hp_ranges $update_hp_value $ignore_desired_value] \
                       == "TCL_ERROR"} {
		        return TCL_ERROR
	        }
            set first_index [altera_iopll::util::get_next_outclk_to_update $first_index]
        }
        set first_index [altera_iopll::util::get_first_outclk_to_update]
    }

    # Next update all phase shifts in order   
    if {($first_param_type eq "phase") || ($first_param_type eq "freq") } {
        while {$first_index < $num_clks} {
            if {[::altera_iopll::update_callbacks::gui_actual_phase_shift_ps_deg_update \
                   $first_index $update_actual_ranges $update_actual_value \
                     $update_hp_ranges $update_hp_value $ignore_desired_value] \
                      == "TCL_ERROR"} { 
		        return TCL_ERROR
	        }
            set first_index [altera_iopll::util::get_next_outclk_to_update $first_index]
        }
        set first_index [altera_iopll::util::get_first_outclk_to_update]
    }

    # Next update all duty cycles in order. 
    while {$first_index < $num_clks} {
        if {[::altera_iopll::update_callbacks::gui_actual_duty_cycle_update \
                 $first_index $update_actual_ranges $update_actual_value \
                     $update_hp_ranges $update_hp_value $ignore_desired_value] \
                      == "TCL_ERROR"} { 
		    return TCL_ERROR
	    }
        set first_index [altera_iopll::util::get_next_outclk_to_update $first_index]
    }
}

# +=============================================================================================================
# | INDIVIDUAL PARAMETER CALLBACKS

proc ::altera_iopll::update_callbacks::gui_number_of_clocks_callback {} { 
    # Description: 
    #   When the number of clocks changes, we need to update any dropdowns listing the available clocks.
    #   We must also update the freq/phase/duty dropdowns, starting with the first clock added if clocks
    #   were added, or the first phase shift, if clocks were removed. 
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_number_of_clocks "

    # Get all required parameter values
    set num_clks [get_parameter_value gui_number_of_clocks]
    set prev_num_clks [get_parameter_value hp_previous_num_clocks]

    # Update the hp_previous number of clocks. We use this to know which outclks we need to update after
    # we change the number of clocks. 
    set_parameter_value hp_previous_num_clocks $num_clks 

    # Update dropdowns that list all available outclks
    ::altera_iopll::update_callbacks::gui_dps_cntr_update
    ::altera_iopll::update_callbacks::gui_extclkout_source_update 
    ::altera_iopll::update_callbacks::gui_cascade_outclk_index_update
    
    if {[::altera_iopll::update_callbacks::gui_clock_to_compensate_update]} {
        # Update frequencies of all clocks, all phases and all duty cycles. 
        ::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_first_outclk_to_update] freq 
    } else {
        # Update frequencies of *new* clocks, all phases, all duty cycles. 
        ::altera_iopll::update_callbacks::update_all_outclks_in_order $prev_num_clks freq 
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_number_of_clocks "
}

proc ::altera_iopll::update_callbacks::gui_device_family_callback {} { 
    # Description: 
    #   If family changes, then pretty much everything else does too.   
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_device_family "
    ::altera_iopll::update_callbacks::gui_device_component_update
    ::altera_iopll::update_callbacks::gui_device_speed_grade_update
    if {[::altera_iopll::update_callbacks::hp_number_of_family_allowable_clocks_update]} {
        ::altera_iopll::update_callbacks::gui_number_of_clocks_update
    }
    ::altera_iopll::update_callbacks::gui_use_NDFB_modes_update
    ::altera_iopll::update_callbacks::gui_vco_frequency_update
    ::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_first_outclk_to_update] freq 
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_device_family "
}

proc ::altera_iopll::update_callbacks::gui_device_component_callback {} {
    # Description: 
    #   If component changes, then speedgrade might... which would mean we need to update
    #   vco frequency, outclk frequencies etc. 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_device_component "
    if {[::altera_iopll::update_callbacks::gui_device_speed_grade_update]} {
        ::altera_iopll::update_callbacks::gui_device_speed_grade_callback
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_device_component "
}

proc ::altera_iopll::update_callbacks::gui_usr_device_speed_grade_callback {} { 
    # Description: 
    #   If the user changes the speed grade dropdown, we need to update device speed grade 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_usr_device_speed_grade "
    if {[::altera_iopll::update_callbacks::gui_device_speed_grade_update]} {
        altera_iopll::util::pll_send_update_message DEBUG "-- calling callback "
        if {[::altera_iopll::update_callbacks::gui_device_speed_grade_callback] == "TCL_ERROR"} {
		    return TCL_ERROR
	    }
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_usr_device_speed_grade "
}

proc ::altera_iopll::update_callbacks::gui_device_speed_grade_callback {} {
    # Description: 
    #   If the device speedgrade changes, then VCO, outclk frequencies might. 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_device_speed_grade "
    if {[::altera_iopll::update_callbacks::gui_vco_frequency_update] == "TCL_ERROR"} {
        return TCL_ERROR
	}
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_first_outclk_to_update] freq] == "TCL_ERROR"} {
	    return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_device_speed_grade "
}

proc ::altera_iopll::update_callbacks::gui_operation_mode_callback {} { 
    # Description: 
    #   If the operation mode changes, then whether we are in NDFB mode might too. 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_operation_mode "
    if {[::altera_iopll::update_callbacks::gui_use_NDFB_modes_update]} {
        if {[::altera_iopll::update_callbacks::gui_use_NDFB_modes_callback] == "TCL_ERROR"} {
		    return TCL_ERROR
	    }
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_operation_mode "
}

proc ::altera_iopll::update_callbacks::gui_use_NDFB_modes_callback {} { 
    # Description: 
    #   If NDFB mode changed, then we need to update all outclks, and the vco. 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_use_NDFB_modes "
    if {[::altera_iopll::update_callbacks::gui_vco_frequency_update] == "TCL_ERROR"} {
	    return TCL_ERROR
    }
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
             [altera_iopll::util::get_first_outclk_to_update] freq ] == "TCL_ERROR"} {
	    return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_use_NDFB_modes "
}

proc ::altera_iopll::update_callbacks::gui_reference_clock_frequency_callback {} { 
    # Description: 
    #   If reference clock frequency changes, make sure it is a reasonable value and then update
    #   VCO and outclks. 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_reference_clock_frequency "
    if {[::altera_iopll::update_callbacks::gui_reference_clock_frequency_update] == "TCL_ERROR"} {
	    return TCL_ERROR
	}
    if {[get_parameter_value gui_fix_vco_frequency] || [get_parameter_value gui_en_adv_params]} {   
        if {[::altera_iopll::update_callbacks::gui_vco_frequency_update] == "TCL_ERROR"} {
		    return TCL_ERROR
	    }
    } 
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
             [altera_iopll::util::get_first_outclk_to_update] freq] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_reference_clock_frequency "
}

proc ::altera_iopll::update_callbacks::gui_fixed_vco_frequency_callback {} { 
    # Description: 
    #   If the desired VCO frequency changes, make sure it is a reaonsable value, update the
    #   VCO dropdown, and if that changes then update outclks too.  
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_fixed_vco_frequency "
    ::altera_iopll::update_callbacks::gui_fixed_vco_frequency_update 
    if {[::altera_iopll::update_callbacks::gui_vco_frequency_update]} {
         ::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_first_outclk_to_update] freq
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_fixed_vco_frequency "
}

proc ::altera_iopll::update_callbacks::gui_fix_vco_frequency_callback {} { 
    # Description: 
    #   If whether or not the VCO is fixed changes... if it is now fixed, then update the VCO dropdown. 
    #   Then update all the outclks. 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_fix_vco_frequency "
    if {[get_parameter_value gui_fix_vco_frequency]} {
        if {[::altera_iopll::update_callbacks::gui_vco_frequency_update] == "TCL_ERROR"} {
		    return TCL_ERROR
    	}
    } 
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
        [altera_iopll::util::get_first_outclk_to_update] freq ] == "TCL_ERROR"} {
	    return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_fix_vco_frequency "
}

proc ::altera_iopll::update_callbacks::gui_vco_frequency_callback {} { 
    # Description: 
    #   If the selected VCO frequency changes, then update all outclk values 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_vco_frequency "
    if {[::altera_iopll::util::set_to_corresponding_fp_value gui_vco_frequency hp_actual_vco_frequency_fp] \
         == "TCL_ERROR"} {
	    return TCL_ERROR
    }
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_first_outclk_to_update] freq ] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_vco_frequency "
}

proc ::altera_iopll::update_callbacks::gui_output_clock_frequency_callback {callback_inst src_inst} { 
    # Description: 
    #   If the desired outclk frequency changes, then update all outclk values starting with that freq 
    # Inputs: callback_inst is the instance of the parameter that changed.  
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_output_clock_frequency_callback "
    if {[::altera_iopll::update_callbacks::gui_output_clock_frequency_update $callback_inst $src_inst] \
          == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order $callback_inst freq ] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_output_clock_frequency_callback "
}

proc ::altera_iopll::update_callbacks::gui_actual_output_clock_frequency_callback {callback_inst src_inst} { 
    # Description: 
    #   If the desired outclk frequency changes, then update all outclk values starting with next freq 
    # Inputs: callback_inst is the instance of the parameter that changed.  
    altera_iopll::util::pll_send_update_message DEBUG \
         "-- in callback gui_actual_output_clock_frequency$callback_inst"
    if {[::altera_iopll::util::set_to_corresponding_fp_value \
               gui_actual_output_clock_frequency$callback_inst \
               hp_actual_output_clock_frequency_fp$callback_inst \
               gui_actual_output_clock_frequency$src_inst \
               hp_actual_output_clock_frequency_fp$src_inst] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_next_outclk_to_update $callback_inst] freq ] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_actual_output_clock_frequency"
}

proc ::altera_iopll::update_callbacks::gui_phase_shift_callback {callback_inst src_inst} { 
    # Description: 
    #   If the desired outclk phase changes, then update all outclk values starting with that phase 
    # Inputs: callback_inst is the instance of the parameter that changed.   
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_phase_shift$callback_inst "
    if {[::altera_iopll::update_callbacks::gui_phase_shift_update $callback_inst $src_inst] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order $callback_inst phase ] \
          == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_phase_shift "
}

proc ::altera_iopll::update_callbacks::gui_phase_shift_deg_callback {callback_inst src_inst} { 
    # Description: 
    #   If the desired outclk phase changes, then update all outclk values starting with that phase 
    # Inputs: callback_inst is the instance of the parameter that changed.  
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_phase_shift_deg$callback_inst "
    if {[::altera_iopll::update_callbacks::gui_phase_shift_deg_update $callback_inst $src_inst] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order $callback_inst phase] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_phase_shift_deg "
}

proc ::altera_iopll::update_callbacks::gui_actual_phase_shift_callback {callback_inst src_inst} { 
    # Description: 
    #   If the selected outclk phase changes, then update all outclk values starting with next phase 
    #   And update the degrees value
    # Inputs: callback_inst is the instance of the parameter that changed.  
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_actual_phase_shift$callback_inst $src_inst"

    # First of all update the helper value...
    if {[::altera_iopll::util::set_to_corresponding_fp_value \
	gui_actual_phase_shift$callback_inst \
	hp_actual_phase_shift_fp$callback_inst \
	gui_actual_phase_shift$src_inst \
	hp_actual_phase_shift_fp$src_inst] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    
    set gui_en_adv_params [get_parameter_value gui_en_adv_params]
    if {!$gui_en_adv_params} {
        if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_next_outclk_to_update $callback_inst] phase] == "TCL_ERROR"} {
	    	return TCL_ERROR
    	}
    }
    # Update the actual value in degrees to match.  
    if {[::altera_iopll::update_callbacks::gui_actual_phase_shift_deg_update $callback_inst $src_inst] \
           == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_actual_phase_shift "
}

proc ::altera_iopll::update_callbacks::gui_actual_phase_shift_deg_callback {callback_inst src_inst} { 
    # Description: 
    #   If the selected outclk phase changes, then update all outclk values starting with next phase 
    #   And update the phase value
    # Inputs: callback_inst is the instance of the parameter that changed.  
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_actual_phase_shift_deg$callback_inst"
    set gui_en_adv_params [get_parameter_value gui_en_adv_params]
    if {!$gui_en_adv_params} {
        if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
               [altera_iopll::util::get_next_outclk_to_update $callback_inst] phase] == "TCL_ERROR"} {
		    return TCL_ERROR
    	}
    }
    # Update the ps value to match
    if {[::altera_iopll::update_callbacks::gui_actual_phase_shift_update $callback_inst $src_inst] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_actual_phase_shift_deg "
}

proc ::altera_iopll::update_callbacks::gui_duty_cycle_callback {callback_inst src_inst} { 
    # Description: 
    #   If the desired duty cycle changes, then make sure the new value is reasonable, then
    #   update the duty cycle dropdowns starting with this instance 
    # Inputs: callback_inst is the instance of the parameter that changed.   
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_duty_cycle$callback_inst"
    if {[::altera_iopll::update_callbacks::gui_duty_cycle_update $callback_inst $src_inst] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order $callback_inst duty ] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_duty_cycle"
}

proc ::altera_iopll::update_callbacks::gui_actual_duty_cycle_callback {callback_inst src_inst} { 
    # Description: 
    #   If the selected duty cycle changes, then
    #   update the duty cycle dropdowns starting with the next instance
    # Inputs: callback_inst is the instance of the parameter that changed.  
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_actual_duty_cycle$callback_inst"

    # First of all update the helper value...
    if {[::altera_iopll::util::set_to_corresponding_fp_value \
               gui_actual_duty_cycle$callback_inst \
               hp_actual_duty_cycle_fp$callback_inst \
               gui_actual_duty_cycle$src_inst \
               hp_actual_duty_cycle_fp$src_inst] == "TCL_ERROR"} {
		return TCL_ERROR
	}

    set gui_en_adv_params [get_parameter_value gui_en_adv_params]
    if {!$gui_en_adv_params} {
        if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
              [altera_iopll::util::get_next_outclk_to_update $callback_inst] duty ] == "TCL_ERROR"} {
	    	return TCL_ERROR
	    }
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_actual_duty_cycle "
}


proc ::altera_iopll::update_callbacks::gui_clock_to_compensate_callback {} { 
    # Description: 
    #   If the clock to compensate changed, then if in NDFB mode we need to update all outclk values.
    #   and also the VCO frequency
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_clock_to_compensate"
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
    if {$gui_use_NDFB_modes} {
        if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
              [altera_iopll::util::get_first_outclk_to_update] freq ] == "TCL_ERROR"} {
	    	return TCL_ERROR
	    }
        if {[::altera_iopll::update_callbacks::gui_vco_frequency_update] == "TCL_ERROR"} {
		    return TCL_ERROR
    	}
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_clock_to_compensate "
}

proc ::altera_iopll::update_callbacks::gui_en_lvds_ports_callback {} { 
    # Description: 
    #   If whether LVDS ports are enabled changes, then we might need to increase the number
    #   of clocks... in which case update all the dropdowns that depend on the number of clocks also. 
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_en_lvds_ports"
    
    # first, copy the parameters of C0 and C1 to C2 and C3
    set_parameter_value gui_output_clock_frequency2 [get_parameter_value gui_output_clock_frequency0]
    set_parameter_value gui_phase_shift2 [get_parameter_value gui_phase_shift0]
    set_parameter_value gui_phase_shift_deg2 [get_parameter_value gui_phase_shift_deg0]
    set_parameter_value gui_duty_cycle2 [get_parameter_value gui_duty_cycle0]

    set_parameter_value gui_output_clock_frequency3 [get_parameter_value gui_output_clock_frequency1]
    set_parameter_value gui_phase_shift3 [get_parameter_value gui_phase_shift1]
    set_parameter_value gui_phase_shift_deg3 [get_parameter_value gui_phase_shift_deg1]
    set_parameter_value gui_duty_cycle3 [get_parameter_value gui_duty_cycle1]

    if {[::altera_iopll::update_callbacks::gui_number_of_clocks_update]} {
        if {[::altera_iopll::update_callbacks::gui_number_of_clocks_callback] == "TCL_ERROR"} {
	    	return TCL_ERROR
    	}
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_en_lvds_ports "
}


proc ::altera_iopll::update_callbacks::gui_en_adv_params_callback {} { 
    # Description: 
    #   If we enable or disable advanced parameters, update all counter values, vco and outclk dropdowns. 
    #   If we disable advanced parameters, update vco frequency, and all outclk dropdowns. 
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_en_adv_params"
    if {[get_parameter_value gui_en_adv_params]} {
        if {[::altera_iopll::update_callbacks::gui_multiply_factor_update true] == "TCL_ERROR"} {
	    	return TCL_ERROR
	    } elseif {[::altera_iopll::update_callbacks::gui_divide_factor_n_update true] == "TCL_ERROR"} {
	    	return TCL_ERROR
	    } elseif {[::altera_iopll::update_callbacks::gui_divide_factor_c_update true] == "TCL_ERROR"} {
		    return TCL_ERROR
	    } elseif {[::altera_iopll::update_callbacks::gui_vco_frequency_update] == "TCL_ERROR"} {
		    return TCL_ERROR
	    }
    } elseif {[get_parameter_value gui_fix_vco_frequency] && ![get_parameter_value gui_use_NDFB_modes]} {
        if {[::altera_iopll::update_callbacks::gui_vco_frequency_update] == "TCL_ERROR"} {
	    	return TCL_ERROR
    	}
    } 
    if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
              [altera_iopll::util::get_first_outclk_to_update] freq] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_en_adv_params "
}

proc ::altera_iopll::update_callbacks::gui_multiply_factor_callback {} { 
    # Description: 
    #   If we change the multiply factor, then make sure it is reasonable then update VCO. 
    #   Then we may need to change the outclk values also
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_multiply_factor"
    if {![get_parameter_value gui_en_adv_params]} {
        return
    }
    if {[::altera_iopll::update_callbacks::gui_multiply_factor_update false] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[::altera_iopll::update_callbacks::gui_vco_frequency_update]} {
        if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
              [altera_iopll::util::get_first_outclk_to_update] freq ] == "TCL_ERROR"} {
		    return TCL_ERROR
    	}
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_multiply_factor "
}

proc ::altera_iopll::update_callbacks::gui_divide_factor_n_callback {} {
    # Description: 
    #   If we change the N counter, then make sure it is reasonable then update VCO. 
    #   Then we may need to change the outclk values also
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_divide_factor_n"
    if {![get_parameter_value gui_en_adv_params]} {
        return
    }
    if {[::altera_iopll::update_callbacks::gui_divide_factor_n_update false] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    if {[::altera_iopll::update_callbacks::gui_vco_frequency_update]} {
        if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
              [altera_iopll::util::get_first_outclk_to_update] freq ] == "TCL_ERROR"} {
		    return TCL_ERROR
    	}
    }
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_divide_factor_n"
}

proc ::altera_iopll::update_callbacks::gui_divide_factor_c_callback {callback_inst src_inst} { 
    # Description: 
    #   If we change the C counter, then make sure it is reasonable.
    #   Update this outclks values. 
    #   If NDFB and this is the counter in the loop, then update VCO and all other values. 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG "-- in callback gui_divide_factor_c$callback_inst"
    if {![get_parameter_value gui_en_adv_params]} {
        return
    }
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
    set gui_clock_to_compensate [get_parameter_value gui_clock_to_compensate]
    if {[::altera_iopll::update_callbacks::gui_divide_factor_c_update false] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    # If we changed the outclk to be compensated, then we need to also update the vco
    if {($gui_clock_to_compensate == $callback_inst) && $gui_use_NDFB_modes} {
        if {[::altera_iopll::update_callbacks::gui_vco_frequency_update] == "TCL_ERROR"} {
	    	return TCL_ERROR
    	}
        if {[::altera_iopll::update_callbacks::update_all_outclks_in_order \
              [altera_iopll::util::get_first_outclk_to_update] freq ] == "TCL_ERROR"} {
	    	return TCL_ERROR
    	}
    } else {
        if {[::altera_iopll::update_callbacks::gui_actual_output_clock_frequency_update $callback_inst] \
             == "TCL_ERROR"} {
		    return TCL_ERROR
	    } elseif {[::altera_iopll::update_callbacks::gui_actual_phase_shift_ps_deg_update $callback_inst] \
             == "TCL_ERROR"} {
		    return TCL_ERROR
	    } elseif {[::altera_iopll::update_callbacks::gui_actual_duty_cycle_update $callback_inst] \
             == "TCL_ERROR"} {
		    return TCL_ERROR
        }
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_divide_factor_c "
}

proc ::altera_iopll::update_callbacks::gui_refclk1_frequency_callback {} {
    # Description: 
    #   If we change the refclk1 frequency, make sure it is a reasonable value. 
    # Inputs: none 
    altera_iopll::util::pll_send_update_message DEBUG " -- in callback gui_refclk1_frequency"
    if {[::altera_iopll::update_callbacks::gui_refclk1_frequency_update] == "TCL_ERROR"} {
		return TCL_ERROR
	}
    altera_iopll::util::pll_send_update_message DEBUG "-- done callback gui_refclk1_frequency "
}


# + ============================================================================================================
# |  UPDATE CALLBACKS : Callbacks that change non-derived parameters. 

proc ::altera_iopll::update_callbacks::gui_device_family_update {} {
	# Description: Updates gui_device_family based on system_info_device_family. Errors out if the family
    #   is invalid. 
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_device_family "

    # Get all required parameter values
    set system_info_device_family [get_parameter_value system_info_device_family]
    set gui_device_family [get_parameter_value gui_device_family]
    set param_value_changed false
	# Send an error if the family is illegal
	if {$system_info_device_family == "" || $system_info_device_family == "Unknown"} {
		altera_iopll::util::pll_send_update_message ERROR \
            "Altera IOPLL requires a device family to be specified."
		return false
	}
	set allowable_families [get_module_property SUPPORTED_DEVICE_FAMILIES]
	if { [lsearch $allowable_families $system_info_device_family] == -1 } {
		altera_iopll::util::pll_send_update_message ERROR \
            "Altera IOPLL only supports the 20nm device family. For 28nm device families, use Altera PLL. \
              For 45nm and previous device families, use ALTPLL."
        return false
	} 

    # Change the GUI device family parameter if required. 
    if {![expr {$gui_device_family eq $system_info_device_family}]} {
        set_parameter_value gui_device_family $system_info_device_family
        set param_value_changed true
    }

    return $param_value_changed
}

proc ::altera_iopll::update_callbacks::gui_device_component_update {} {
	# Description: Updates gui_device_component based on system_info_device_component
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_device_component "

    # Get all required parameter values
    set system_info_device_component [get_parameter_value system_info_device_component]
    set original_device [get_parameter_value gui_device_component]
    set param_value_changed false

    # Change the GUI device component parameter if required. 
    if {![expr {$original_device eq $system_info_device_component}]} {
	    set_parameter_value gui_device_component $system_info_device_component
        set param_value_changed true
    }
    
    return $param_value_changed
}

proc ::altera_iopll::update_callbacks::gui_device_speed_grade_update {} {
	# Description: Updates gui_device_speed_grade based on system_info_device_speed_grade and
    #    gui_usr_device_speed_grade
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_device_speed_grade "

    # Get all required parameter values
    set gui_device_component [get_parameter_value gui_device_component]
    set system_info_device_speed_grade [get_parameter_value system_info_device_speed_grade]
    set gui_usr_device_speed_grade [get_parameter_value gui_usr_device_speed_grade]
    set gui_device_speed_grade [get_parameter_value gui_device_speed_grade]
    set new_speedgrade 1
    set param_value_changed false

	# Update gui_device_speed_grade value - if the system_info_device_speed_grade is set, then
    # we need to use that speedgrade. Otherwise the user gets to choose the speed grade, and we
    # set gui_device_speed_grade to gui_usr_device_speed_grade. 
	if {$gui_device_component == "Unknown" || $gui_device_component == "" || \
        $system_info_device_speed_grade == "Unknown" || \
        $system_info_device_speed_grade == "" } {
		if {!($gui_device_component == "Unknown" || $gui_device_component == "")} {
            # The device component is known but the speedgrade is not.
	    	return false
        } else {
            # The device component is unknown. 
            set new_speedgrade $gui_usr_device_speed_grade
        }
    } else {
        set new_speedgrade $system_info_device_speed_grade
    }

    # Change the GUI device speed grade parameter if required. 
    if {![expr {$new_speedgrade eq $gui_device_speed_grade}]} {
        set_parameter_value gui_device_speed_grade $new_speedgrade
        set param_value_changed true
    }

    return $param_value_changed
}


proc ::altera_iopll::update_callbacks::hp_number_of_family_allowable_clocks_update {} { 
	# Description: Updates hp_number_of_family_allowable_clocks based on the device family, and
    #   the possible number of clocks for that family according to qcl/pll.  
    # Inputs: None
    altera_iopll::util::pll_send_update_message DEBUG "-- in update hp_number_of_family_allowable_clocks"

    # Get all required parameter values
    set gui_device_family             [get_parameter_value gui_device_family]
    set gui_device_speed_grade        [get_parameter_value gui_device_speed_grade]
    set hp_number_of_family_allowable_clocks  [get_parameter_value hp_number_of_family_allowable_clocks]
    set gui_pll_mode                  [get_parameter_value gui_pll_mode]
    set param_value_changed           false
    
    # Update hp_number_of_family_allowable_clocks range based on qcl/pll
	if { [catch {get_legal_physical_parameters_validation \
             -device_family $gui_device_family\
			 -device_speedgrade $gui_device_speed_grade} \
              result] } {
        altera_iopll::util::pll_send_update_message ERROR \
            "Getting legal physical parameters failed for device $gui_device_family and speedgrade \
             $gui_device_speed_grade: $result"
		return false
	}
    array set result_array $result

    # Update hp_number_of_family_allowable_clocks value if required
    set val $result_array(num_clocks)
    if {![expr {$hp_number_of_family_allowable_clocks eq $val}]} {
        set_parameter_value hp_number_of_family_allowable_clocks $val
        set param_value_changed true
    }
 
    # Set the refclk range here to save us from having to call qcl/pll for this again later. 
    set_parameter_property gui_reference_clock_frequency \
               ALLOWED_RANGES "$result_array(refclk_min):$result_array(refclk_max)"
    return $param_value_changed
}


proc ::altera_iopll::update_callbacks::gui_number_of_clocks_update { \
               {update_actual_ranges true} {update_actual_value true}} { 
	# Description: Updates gui_number_of_clocks based on hp_number_of_family_allowable_clocks
    #   and on whether or not the LVDS ports are enabled.
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_number_of_clocks"

    # Get all required parameter values
    set gui_en_lvds_ports [get_parameter_value gui_en_lvds_ports]
    set hp_number_of_family_allowable_clocks [get_parameter_value hp_number_of_family_allowable_clocks]
    set max_clk $hp_number_of_family_allowable_clocks
    set param_value_changed false
    set gui_number_of_clocks [get_parameter_value gui_number_of_clocks]

    # Determine min num clocks - if LVDS ports are enabled, the corresponding outclks must be too.

    set gui_device_family [get_parameter_value gui_device_family]
    if {$gui_en_lvds_ports == "Enable LVDS_CLK/LOADEN 0"} {
	if { $gui_device_family == "Stratix 10" } {
	    # in Stratix 10 hide c2 and c3
	    set min_clk 5
	} else {
	    # Arria 10
	    set min_clk 3
	}
    } elseif {$gui_en_lvds_ports == "Enable LVDS_CLK/LOADEN 0 & 1"} {
        set min_clk 5
    } else {
        set min_clk 1
    }
	set num_clocks_list [list]
    for {set i $min_clk} {$i <= $max_clk } {incr i} {
		lappend num_clocks_list $i
	}

    # Update gui_number_of_clocks ALLOWED_RANGES to ensure min number of clocks are enabled. 
    if {$update_actual_ranges} {
	    set_parameter_property gui_number_of_clocks ALLOWED_RANGES $num_clocks_list
    }
    if {!$update_actual_value} {
        return false
    }
 
    # Update gui_number_of_clocks value if < min
    if {$gui_number_of_clocks < $min_clk} {
    	set_parameter_value gui_number_of_clocks $min_clk
        set param_value_changed true
    } elseif {$gui_number_of_clocks > $max_clk} {
    	set_parameter_value gui_number_of_clocks $max_clk
        set param_value_changed true
    }

    return $param_value_changed
}

proc ::altera_iopll::update_callbacks::gui_extclkout_source_update { \
                   {update_actual_ranges true} {update_actual_value true}} {
	# Description: Updates the dropdowns of extclkout source based on gui_number_of_clocks:
    #   outclks that are not enabled should not be dropdown options. 
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    altera_iopll::util::pll_send_update_message DEBUG " -- in update_gui_extclkout_source"

    # Get all required parameter values
    set gui_extclkout_1_source [get_parameter_value gui_extclkout_1_source]
    set gui_extclkout_0_source [get_parameter_value gui_extclkout_0_source]
    set gui_number_of_clocks [get_parameter_value gui_number_of_clocks]
    set param_value_changed false

    # Create list of enabled outclks
    set extclk_list [list]
    for {set i 0} {$i <= $gui_number_of_clocks - 1} {incr i} {
        lappend extclk_list "C$i"
    } 

    # Update ALLOWED_RANGES to only show enabled outclks
    if {$update_actual_ranges} {
        set_parameter_property gui_extclkout_0_source ALLOWED_RANGES $extclk_list
        set_parameter_property gui_extclkout_1_source ALLOWED_RANGES $extclk_list
    }   
    if {!$update_actual_value} {
        return false
    }

    # Update extclkout_source value if required
    if {[lsearch $extclk_list $gui_extclkout_0_source] == -1 } {
        set_parameter_value gui_extclkout_0_source [lindex $extclk_list 0]
        set param_value_changed true
    }
    if {[lsearch $extclk_list $gui_extclkout_1_source] == -1 } {
        set_parameter_value gui_extclkout_1_source [lindex $extclk_list 0]
        set param_value_changed true
    }
    return $param_value_changed
}


proc ::altera_iopll::update_callbacks::gui_dps_cntr_update { \
                 {update_actual_ranges true} {update_actual_value true}} {
	# Description: Updates the dropdowns gui_dps_cntr based on gui_number_of_clocks:
    #   outclks that are not enabled should not be dropdown options. 
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_dps_cntr"

    # Get all required parameter values
    set gui_number_of_clocks [get_parameter_value gui_number_of_clocks]
    set gui_dps_cntr [get_parameter_value gui_dps_cntr]

    # Create list of enabled outclks
    set all_clocks_list [list]
    for {set i 0} {$i <= $gui_number_of_clocks - 1} {incr i} {
        lappend all_clocks_list "C$i"
    }
    lappend all_clocks_list "All C"
    lappend all_clocks_list "M"

    # Update ALLOWED_RANGES to only show enabled outclks
    if {$update_actual_ranges} {
        set_parameter_property gui_dps_cntr ALLOWED_RANGES $all_clocks_list 
    }
    if {!$update_actual_value} {
        return false
    }

    # Update gui_dps_cntr value if required
    if {[lsearch $all_clocks_list $gui_dps_cntr] == -1 } {
        set_parameter_value gui_dps_cntr [lindex $all_clocks_list 0]
        return true
    }
    return false
}

proc ::altera_iopll::update_callbacks::gui_clock_to_compensate_update { \
                     {update_actual_ranges true} {update_actual_value true}} { 
	# Description: Updates the dropdown gui_clock_to_compensate based on gui_number_of_clocks:
    #   outclks that are not enabled should not be dropdown options. 
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_clock_to_compensate"
    
    # Get all required parameter values
    set gui_number_of_clocks [get_parameter_value gui_number_of_clocks]
    set gui_clock_to_compensate [get_parameter_value gui_clock_to_compensate]

    # Create list of enabled outclks
    set available_clocks_list [list]
    for {set i 0} {$i <= $gui_number_of_clocks - 1} {incr i} {
		lappend available_clocks_list $i
	}

    # Update gui_clock_to_compensate range to only show enabled outclks
    if {$update_actual_ranges} {
        set_parameter_property gui_clock_to_compensate ALLOWED_RANGES $available_clocks_list
    }
    if {!$update_actual_value} {
        return false
    }

    # Update gui_clock_to_compensate value if required
    if {[lsearch $available_clocks_list $gui_clock_to_compensate] == -1 } {
    	set_parameter_value gui_clock_to_compensate [lindex $available_clocks_list 0]
        return true
    } 
    return false
}

proc ::altera_iopll::update_callbacks::gui_cascade_outclk_index_update { \
                 {update_actual_ranges true} {update_actual_value true}} { 
	# Description: Updates the dropdown gui_cascade_outclk_index based on gui_number_of_clocks:
    #   outclks that are not enabled should not be dropdown options. 
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    altera_iopll::util::pll_send_update_message DEBUG " -- in update_gui_cascade_outclk_index"

    # Get all required parameter values
    set gui_number_of_clocks [get_parameter_value gui_number_of_clocks]
    set gui_cascade_outclk_index [get_parameter_value gui_cascade_outclk_index]
    set param_value_changed false

    # Create list of available outclks
    set available_clocks_list [list]
    for {set i 0} {$i <= $gui_number_of_clocks - 1} {incr i} {
        lappend available_clocks_list $i
    }

    # Update gui_cascade_outclk_index range to only show enabled outclks
    if {$update_actual_ranges} {
        set_parameter_property gui_cascade_outclk_index ALLOWED_RANGES $available_clocks_list
    }
    if {!$update_actual_value} {
        return false
    }

    # Update gui_cascade_outclk_index value if required
    if {[lsearch $available_clocks_list $gui_cascade_outclk_index] == -1 } {
        set_parameter_value gui_cascade_outclk_index [lindex $available_clocks_list 0]
        return true
    } 
    return false
}

proc ::altera_iopll::update_callbacks::gui_reference_clock_frequency_update {} { 
	# Description: If the value of gui_reference_clock_frequency is set to something absurd, 
    #   fix it right away to prevent problems ...
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_reference_clock_frequency"
    set new_freq [altera_iopll::util::truncate_frequency \
                      [get_parameter_value gui_reference_clock_frequency]]
    set_parameter_value gui_reference_clock_frequency $new_freq
    return true
}

proc ::altera_iopll::update_callbacks::gui_fixed_vco_frequency_update {} { 
	# Description: If the value of gui_fixed_vco_frequency is set to something absurd, 
    #   fix it right away to prevent problems ...
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_fixed_vco_frequency"
    set new_freq [altera_iopll::util::truncate_frequency \
                      [get_parameter_value gui_fixed_vco_frequency]]
    set_parameter_value gui_fixed_vco_frequency $new_freq
    return true
}

proc ::altera_iopll::update_callbacks::gui_output_clock_frequency_update {callback_inst src_inst} { 
	# Description: If the value of gui_output_clock_frequency is set to something absurd, 
    #   fix it right away to prevent problems ...
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_output_clock_frequency$callback_inst"
    set new_freq [altera_iopll::util::truncate_frequency \
                      [get_parameter_value gui_output_clock_frequency$src_inst]]
    set_parameter_value gui_output_clock_frequency$callback_inst $new_freq
    return true
}

proc ::altera_iopll::update_callbacks::gui_phase_shift_update {callback_inst src_inst} { 
	# Description: If the value of gui_phase_shift is set to something absurd, 
    #   fix it right away to prevent problems ...
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_phase_shift$callback_inst"
    set new_phase [altera_iopll::util::truncate_phase \
                       [get_parameter_value gui_phase_shift$src_inst]]

    set_parameter_value gui_phase_shift$callback_inst $new_phase
    return true
}

proc ::altera_iopll::update_callbacks::gui_actual_phase_shift_update {callback_inst src_inst} { 
	# Description: If the selected ps value changes, change selected deg value also. 
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_actual_phase_shift$callback_inst"

    # if units != ps then we should update this value to match the deg value. 
    if {[altera_iopll::util::phase_shift_unit_is_degrees [get_parameter_value gui_ps_units$src_inst]]} {
	    set ps_list [get_parameter_value gui_actual_phase_shift_range$src_inst]
        set deg_list [get_parameter_value gui_actual_phase_shift_deg_range$src_inst]
    	set current_value [get_parameter_value gui_actual_phase_shift_deg$src_inst] 
        set index [lsearch $deg_list $current_value]
        set new_value [lindex $ps_list $index]
        if {$index > -1} {
            set_parameter_value gui_actual_phase_shift_deg$callback_inst $current_value
            set_parameter_value gui_actual_phase_shift$callback_inst $new_value
        }
        return true
    }
    return false
}

proc ::altera_iopll::update_callbacks::gui_phase_shift_deg_update {callback_inst src_inst} { 
	# Description: If the value of gui_phase_shift_deg is set to something absurd, 
    #   fix it right away to prevent problems ...
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_phase_shift_deg$callback_inst"
    altera_iopll::util::pll_send_update_message DEBUG " -- this is the unit update 1"
    set new_phase [altera_iopll::util::truncate_degrees [get_parameter_value gui_phase_shift_deg$src_inst]]
    set_parameter_value gui_phase_shift_deg$callback_inst $new_phase
    return true
}

proc ::altera_iopll::update_callbacks::gui_actual_phase_shift_deg_update {callback_inst src_inst} { 
	# Description: If the selected ps value changes, change selected deg value also. 
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_actual_phase_shift_deg$callback_inst"
    altera_iopll::util::pll_send_update_message DEBUG " -- this is the unit update 2"

    # if units != deg then we should update this value to match the deg value. 
    if {![altera_iopll::util::phase_shift_unit_is_degrees [get_parameter_value gui_ps_units$src_inst]]} {
	    set ps_list [get_parameter_value gui_actual_phase_shift_range$src_inst]
        set deg_list [get_parameter_value gui_actual_phase_shift_deg_range$src_inst]
        set current_value [get_parameter_value gui_actual_phase_shift$src_inst]
        set index [lsearch $ps_list $current_value ]
        set new_value [lindex $deg_list $index]
        if {$index > -1} {
	        set_parameter_value gui_actual_phase_shift$callback_inst $current_value
            set_parameter_value gui_actual_phase_shift_deg$callback_inst $new_value
        }
        return true
    }
    return false
}

proc ::altera_iopll::update_callbacks::gui_duty_cycle_update {callback_inst src_inst} { 
	# Description: If the value of gui_duty_cycle is set to something absurd, 
    #   fix it right away to prevent problems ...
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_duty_cycle$callback_inst"
    set new_duty [altera_iopll::util::truncate_duty \
                      [get_parameter_value gui_duty_cycle$src_inst]]
    set_parameter_value gui_duty_cycle$callback_inst $new_duty
    return true
}

proc ::altera_iopll::update_callbacks::gui_refclk1_frequency_update {} { 
	# Description: If the value of gui_refclk1_frequency is set to something absurd, 
    #   fix it right away to prevent problems ...
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_refclk1_frequency"
    set new_freq [altera_iopll::util::truncate_frequency \
                      [get_parameter_value gui_refclk1_frequency]]
    set_parameter_value gui_refclk1_frequency $new_freq
    return true
}


proc ::altera_iopll::update_callbacks::gui_use_NDFB_modes_update {} {
	# Description: Update the value of gui_use_NDFB_modes based on gui_operation_mode
    # Inputs: none
    altera_iopll::util::pll_send_update_message DEBUG " -- in update gui_use_NDFB_modes"

    # Get all required parameter values
    set gui_operation_mode [get_parameter_value gui_operation_mode]
    set gui_device_family [get_parameter_value gui_device_family]
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
    set param_value_changed false
    set use_NDFB_modes false
   
    # Use NDFB Mode should only be possible in normal or ss compensation modes. 
    if {!($gui_operation_mode == "normal" || \
          $gui_operation_mode == "source synchronous") && $gui_use_NDFB_modes} {
        set use_NDFB_modes false
        set_parameter_value gui_use_NDFB_modes "false"
        return true
    } elseif {($gui_device_family != "Stratix 10") && $gui_use_NDFB_modes} {
        set use_NDFB_modes false
        #set_parameter_property gui_use_NDFB_modes ALLOWED_RANGES "false"
        set_parameter_value gui_use_NDFB_modes "false"
        return true
    }
    return false
}


proc ::altera_iopll::update_callbacks::gui_vco_frequency_update { \
               {update_actual_ranges true} {update_actual_value true} \
               {update_hp_ranges true} {update_hp_value true} \
               {ignore_desired_value false}} {
	# Description: When the value of gui_reference_clock_frequency changes and the gui_fix_vco_frequency
    #  is selected, we need to calculate the possible vco frequency values to put in the dropdown, and
    #  set gui_vco_frequency to the dropdown value closest to gui_fixed_vco_frequency. 
    #  If in advanced mode, then we need to set the value of gui_vco_frequency based on gui_multiply_factor
    #  and gui_divide_factor_n.
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    #        - if update_hp_ranges, change hp ALLOWED RANGES. 
    #        - if update_hp_value, change hp value.
    #        - if ignore_desired_value, find legal values closest to the actual value
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_vco_frequency"

    # ---- Get all required parameter values
    set gui_en_adv_params [get_parameter_value gui_en_adv_params]
    set gui_device_family [get_parameter_value gui_device_family]
    set gui_device_speed_grade [get_parameter_value gui_device_speed_grade]
    set gui_reference_clock_frequency [get_parameter_value gui_reference_clock_frequency]
    set gui_enable_output_counter_cascading [get_parameter_value gui_enable_output_counter_cascading]
    set gui_fractional_cout [get_parameter_value gui_fractional_cout]
    set gui_multiply_factor [get_parameter_value gui_multiply_factor]
    set gui_divide_factor_n [get_parameter_value gui_divide_factor_n]
    set gui_frac_multiply_factor [get_parameter_value gui_frac_multiply_factor]
    set gui_fixed_vco_frequency [get_parameter_value gui_fixed_vco_frequency]
    set gui_fix_vco_frequency [get_parameter_value gui_fix_vco_frequency]
    set gui_vco_frequency [get_parameter_value gui_vco_frequency]
    set gui_pll_bandwidth_preset [get_parameter_value gui_pll_bandwidth_preset]
    set gui_pll_mode [get_parameter_value gui_pll_mode]
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
    set is_fractional false

    if {$gui_fix_vco_frequency && !$gui_use_NDFB_modes && !$gui_en_adv_params} {
        # If the user wants to specify the VCO frequency, calculate the possible values in qcl/pll
        # for a counter with type 'wire' 
        array set desired_array [list]
        set desired_frequency $gui_fixed_vco_frequency
        if {$ignore_desired_value} {
            set desired_frequency $gui_vco_frequency
        }
        set desired_array(0) [list -type wire -index 0 \
                  -freq $desired_frequency -phase 0.0 \
                  -is_degrees false -duty 50.0]
        set c_array [array get desired_array]
        if {$gui_fixed_vco_frequency > 0} {
            set ref_list [list -family $gui_device_family \
                              -speedgrade $gui_device_speed_grade \
                              -refclk_freq $gui_reference_clock_frequency \
                              -is_fractional $is_fractional \
                              -compensation_mode [get_parameter_value gui_operation_mode] \
                              -is_counter_cascading_enabled $gui_enable_output_counter_cascading \
                              -x $gui_fractional_cout \
                              -validated_counter_values {} \
                              -desired_counter_values [array get desired_array]] 
            if {[catch {::quartus::pll::legality::retrieve_output_clock_frequency_list \
                            $ref_list} result]} {
                altera_iopll::util::pll_send_update_message ERROR  \
                    "Failed to compute legal VCO frequencies: $result"
                return TCL_ERROR
            } 
            array set result_array $result
            set closest_freq $result_array(closest_freq)
            set new_range $result_array(freq)

            # Update the legal range of gui_vco_frequency 
            if {$update_actual_ranges} {
                set_parameter_property gui_vco_frequency ALLOWED_RANGES \
                    [altera_iopll::util::round_freq $new_range]
            }
            if {$update_hp_value} {
                set_parameter_value hp_actual_vco_frequency_fp $closest_freq
            }
            if {$update_hp_ranges} {
                set_parameter_property hp_actual_vco_frequency_fp ALLOWED_RANGES $new_range
            }
            if {!$update_actual_value} {
                return false
            }

            # Set the value of gui_vco_frequency to the closest dropdown value. 
            set new_parameter_value [altera_iopll::util::round_freq $closest_freq]
            if {![expr {$new_parameter_value eq $gui_vco_frequency}]} {
                set_parameter_value gui_vco_frequency $new_parameter_value
                return true
            }
        } 
    } elseif {$gui_en_adv_params} {
        # If in advanced mode or NDFB mode, the user isn't allowed to specify the VCO frequency
        # themselves - set this value based on the multiply and divide parameters. 
        set m [altera_iopll::util::get_multiply_factor]
        set op_mode [get_parameter_value gui_operation_mode]
        if { [catch {get_physical_parameters_for_generation \
				-using_adv_mode $gui_en_adv_params \
				-device_family $gui_device_family \
				-device_speedgrade $gui_device_speed_grade \
                -compensation_mode $op_mode \
				-refclk_freq $gui_reference_clock_frequency \
				-is_fractional $is_fractional \
				-x $gui_fractional_cout \
				-m $m \
				-n $gui_divide_factor_n \
				-k $gui_frac_multiply_factor \
				-bw_preset $gui_pll_bandwidth_preset \
				-is_counter_cascading_enabled $gui_enable_output_counter_cascading \
                 -validated_counter_settings {}} \
	    	result] } {
	    	altera_iopll::util::pll_send_update_message ERROR \
                "Failed in get_physical_parameters_for_generation: $result"
	    	return TCL_ERROR
	    }
        array set result_array $result
        set new_vco $result_array(vco_freq)

        # Update the legal range of gui_vco_frequency 
        if {$update_actual_ranges} {
            set_parameter_property gui_vco_frequency ALLOWED_RANGES [altera_iopll::util::round_freq $new_vco]
        }
        if {$update_hp_ranges} {
            set_parameter_property hp_actual_vco_frequency_fp ALLOWED_RANGES {$new_vco}
        }
        if {$update_hp_value} {
            set_parameter_value hp_actual_vco_frequency_fp $new_vco
        }
        if {!$update_actual_value} {
            return false
        }
        if {![expr {[altera_iopll::util::round_freq $new_vco] eq $gui_vco_frequency}]} {
            set_parameter_value gui_vco_frequency [altera_iopll::util::round_freq $new_vco]
            return true
        }
    } else {
        # Ensure that this is legal even when it is unused.
        if {$update_actual_ranges} { 
            set_parameter_property gui_vco_frequency \
                ALLOWED_RANGES [get_parameter_value gui_vco_frequency] 
        }
        if {$update_hp_ranges} {
            set_parameter_property hp_actual_vco_frequency_fp ALLOWED_RANGES \
                [get_parameter_value hp_actual_vco_frequency_fp] 
        }
    }
    return false
}

proc ::altera_iopll::update_callbacks::gui_multiply_factor_update {set_to_physical_values} {  
	# Description: Set gui_multiply_factor based on the physical parameter values - this is so that
    #   the value is set to the prior value when we switch to using advanced parameters. 
    # Input : if bool set_to_physical_values == true then we will update the multiply factor
    #   to the existing physical value. 
    altera_iopll::util::pll_send_update_message DEBUG \
             "-- in update gui_multiply_factor $set_to_physical_values"
    if {$set_to_physical_values} {
        set m_cnt_hi    [get_parameter_value m_cnt_hi_div]
        set m_cnt_lo    [get_parameter_value m_cnt_lo_div]
        set m_bypass    [get_parameter_value m_cnt_bypass_en]
        set_parameter_value gui_multiply_factor \
              [altera_iopll::util::get_total_cntr_value $m_cnt_hi $m_cnt_lo $m_bypass]
    } else {
        set new_cnt [altera_iopll::util::truncate_counter \
                          [get_parameter_value gui_multiply_factor]]
        set_parameter_value gui_multiply_factor $new_cnt
    }
    return true
}

proc ::altera_iopll::update_callbacks::gui_divide_factor_n_update {set_to_physical_values} {
	# Description: Set gui_divide_factor_n based on the physical parameter values - this is so that
    #   the value is set to the prior value when we switch to using advanced parameters. 
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_divide_factor_n"
    if {$set_to_physical_values} {
        set n_cnt_hi    [get_parameter_value n_cnt_hi_div]
        set n_cnt_lo    [get_parameter_value n_cnt_lo_div]
        set n_bypass    [get_parameter_value n_cnt_bypass_en]
        set_parameter_value gui_divide_factor_n \
            [altera_iopll::util::get_total_cntr_value $n_cnt_hi $n_cnt_lo $n_bypass]
    } else {
        set new_cnt [altera_iopll::util::truncate_counter \
                          [get_parameter_value gui_divide_factor_n]]
        set_parameter_value gui_divide_factor_n $new_cnt
    }
    return true
}

proc ::altera_iopll::update_callbacks::gui_divide_factor_c_update {set_to_physical_values} {
	# Description: Set gui_divide_factor_c based on the physical parameter values - this is so that
    #   the value is set to the prior value when we switch to using advanced parameters. 
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_divide_factor_c"

    set num_clocks  [get_parameter_value gui_number_of_clocks]
    for {set i 0} {$i < $num_clocks} {incr i} {
        if {$set_to_physical_values} {
            set c_cnt_hi    [get_parameter_value c_cnt_hi_div$i]
            set c_cnt_lo    [get_parameter_value c_cnt_lo_div$i]
            set c_bypass    [get_parameter_value c_cnt_bypass_en$i]
            set_parameter_value gui_divide_factor_c$i \
                [altera_iopll::util::get_total_cntr_value $c_cnt_hi $c_cnt_lo $c_bypass]
        } else {
            set new_cnt [altera_iopll::util::truncate_counter \
                          [get_parameter_value gui_divide_factor_c$i]]
            set_parameter_value gui_divide_factor_c$i $new_cnt
        }
    }
    return true
}


proc ::altera_iopll::update_callbacks::gui_actual_output_clock_frequency_update { \
          callback_inst {update_actual_ranges true} {update_actual_value true} \
               {update_hp_ranges true} {update_hp_value true} \
               {ignore_desired_value false}} {
	# Description: Update the gui_actual_outclk_clock_frequency dropdown to legal values. 
    #   This depends on prior outclk frequencies, the reference clock frequency and possibly the vco frequency.
    #   If using advanced parameters, then set the frequency based on the multiply and divide factors.
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    #          - if update_hp_ranges, change hp ALLOWED RANGES. 
    #          - if update_hp_value, change hp value.
    #          - if ignore_desired_value, find legal values closest to the actual value
    altera_iopll::util::pll_send_update_message DEBUG \
           "-- in update gui_actual_output_clock_frequency$callback_inst"
    # Get all required parameter values
    set gui_en_adv_params [get_parameter_value gui_en_adv_params]
    set gui_device_family [get_parameter_value gui_device_family]
    set gui_device_speed_grade [get_parameter_value gui_device_speed_grade]
    set gui_reference_clock_frequency [get_parameter_value gui_reference_clock_frequency]
    set gui_enable_output_counter_cascading [get_parameter_value gui_enable_output_counter_cascading]
    set gui_fractional_cout [get_parameter_value gui_fractional_cout]
    set gui_pll_mode [get_parameter_value gui_pll_mode]
    set gui_number_of_clocks [get_parameter_value gui_number_of_clocks]
    set gui_multiply_factor [get_parameter_value gui_multiply_factor]
    set gui_divide_factor_n [get_parameter_value gui_divide_factor_n]
    set gui_frac_multiply_factor [get_parameter_value gui_frac_multiply_factor]
    set gui_divide_factor_n [get_parameter_value gui_divide_factor_n]
    set is_fractional [altera_iopll::util::is_pll_mode_fractional]

    # If the clock is unused, it doesn't matter what the value is, as long as it matches the ranges. 
    if {$callback_inst >= $gui_number_of_clocks} {
        if {$update_hp_ranges} {
            set_parameter_property hp_actual_output_clock_frequency_fp$callback_inst \
                ALLOWED_RANGES [get_parameter_value hp_actual_output_clock_frequency_fp$callback_inst] 
        }
        return false
    }

    # Get the settings of outclks with higher priority. 
	array set c_cnt_array [altera_iopll::util::make_validated_c_counter_array freq $callback_inst] 
	# Get the current clock's desired values (produce a list for this)
	array set desired_array [altera_iopll::util::make_desired_c_counter_array freq \
                                $callback_inst $ignore_desired_value]

    # Calculate the legal values of gui_vco_frequency using qcl/pll computation code. 
    if {!$gui_en_adv_params} {
	    set ref_list [list 	-family $gui_device_family \
					-speedgrade $gui_device_speed_grade \
					-refclk_freq $gui_reference_clock_frequency \
					-is_fractional $is_fractional  \
					-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
					-is_counter_cascading_enabled \
                         $gui_enable_output_counter_cascading \
					-x $gui_fractional_cout \
					-validated_counter_values [array get c_cnt_array] \
					-desired_counter_values [array get desired_array]]
        if {[catch {::quartus::pll::legality::retrieve_output_clock_frequency_list $ref_list} result]} {
            altera_iopll::util::pll_send_update_message ERROR \
               "Failed to compute output counter $callback_inst frequency dropdown values: $result"
            return TCL_ERROR
        }
        array set result_array $result
        set new_value $result_array(closest_freq)
        set new_range $result_array(freq)	 

    } else { 
        set des_list [array get desired_array]
    	if {$callback_inst != 0} {
	    	set massive_list [array get c_cnt_array]
	        foreach element $des_list {
		    	lappend massive_list $element
		    }
            set des_list $massive_list
      	}
        set m [altera_iopll::util::get_multiply_factor]
        set ref_list [list 	-family $gui_device_family \
					-speedgrade $gui_device_speed_grade \
					-refclk_freq $gui_reference_clock_frequency \
					-is_fractional [altera_iopll::util::is_pll_mode_fractional] \
					-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
					-x $gui_fractional_cout \
                    -m $m \
					-n $gui_divide_factor_n \
					-k $gui_frac_multiply_factor  \
                    -clock_index $callback_inst \
                    -validated_counter_values $des_list ]
      	if {[catch {::quartus::pll::legality::compute_output_counter_frequency $ref_list} result]} {
            altera_iopll::util::pll_send_update_message ERROR \
               "Error while computing output clock frequency : $result"
	    	return TCL_ERROR
	    }
    	array set result_array $result
    	set new_value $result_array(counter_frequency)
        set new_range $new_value
    }

	# Update the ALLOWED_RANGES property to range returned from qcl/pll
    if {$update_actual_ranges} {
        set_parameter_value gui_actual_output_clock_frequency_range$callback_inst \
              [altera_iopll::util::round_freq $new_range]
    }
    if {$update_hp_value} {
	    set_parameter_value hp_actual_output_clock_frequency_fp$callback_inst $new_value
    } 
    if {$update_hp_ranges} {
        set_parameter_property hp_actual_output_clock_frequency_fp$callback_inst \
             ALLOWED_RANGES $new_range
    }
    if {$update_actual_value} {
	    set_parameter_value gui_actual_output_clock_frequency$callback_inst \
                                    [altera_iopll::util::round_freq $new_value]
    }
    return true
}

proc ::altera_iopll::update_callbacks::gui_actual_phase_shift_ps_deg_update { \
         callback_inst {update_actual_ranges true} {update_actual_value true} \
               {update_hp_ranges true} {update_hp_value true} \
               {ignore_desired_value false}} {
	# Description: Update the gui_actual_phase_shift and gui_actual_phase_shift_deg dropdowns to legal values. 
    #   This depends on outclk frequencies, prior phase shifts,  the reference clock frequency 
    #   and possibly the vco frequency.
    #   If using advanced parameters, then set the frequency based on the multiply and divide factors.
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    #          - if update_hp_ranges, change hp ALLOWED RANGES. 
    #          - if update_hp_value, change hp value.
    #          - if ignore_desired_value, find legal values closest to the actual value
    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_actual_phase_shift$callback_inst"

    # Get all required parameter values
    set gui_en_adv_params [get_parameter_value gui_en_adv_params]
    set gui_device_family [get_parameter_value gui_device_family]
    set gui_device_speed_grade [get_parameter_value gui_device_speed_grade]
    set gui_reference_clock_frequency [get_parameter_value gui_reference_clock_frequency]
    set gui_enable_output_counter_cascading [get_parameter_value gui_enable_output_counter_cascading]
    set gui_fractional_cout [get_parameter_value gui_fractional_cout]
    set gui_pll_mode [get_parameter_value gui_pll_mode]
    set gui_number_of_clocks [get_parameter_value gui_number_of_clocks]
    set gui_multiply_factor [get_parameter_value gui_multiply_factor]
    set gui_divide_factor_n [get_parameter_value gui_divide_factor_n]
    set gui_frac_multiply_factor [get_parameter_value gui_frac_multiply_factor]
    set gui_divide_factor_n [get_parameter_value gui_divide_factor_n]

    # If the clock is unused, it doesn't matter what the value is, as long as it matches the ranges. 
    if {$callback_inst >= $gui_number_of_clocks} {
        if {$update_hp_ranges} {
            set_parameter_property hp_actual_phase_shift_fp$callback_inst \
                ALLOWED_RANGES [get_parameter_value hp_actual_phase_shift_fp$callback_inst]
        }
        return false
    }

    # Get the settings of outclks with higher priority.
    array set c_cnt_array [altera_iopll::util::make_validated_c_counter_array phase $callback_inst] 
   
	# Get the current clock's desired values (produce a list for this)
    array set desired_array [altera_iopll::util::make_desired_c_counter_array phase \
                                 $callback_inst $ignore_desired_value]

    # Calculate the legal values of this outclk's frequency using the qcl/pll computation code. 
    if {!$gui_en_adv_params} {
        set ref_list [list  -family $gui_device_family \
					-speedgrade $gui_device_speed_grade \
					-refclk_freq $gui_reference_clock_frequency \
					-is_fractional [altera_iopll::util::is_pll_mode_fractional] \
					-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
					-is_counter_cascading_enabled $gui_enable_output_counter_cascading \
					-x $gui_fractional_cout \
					-validated_counter_values [array get c_cnt_array] \
					-desired_counter_values [array get desired_array]]
        if {[catch {::quartus::pll::legality::retrieve_output_clock_phase_list $ref_list} result]} {
            altera_iopll::util::pll_send_update_message ERROR \
               "Failed to compute output counter $callback_inst phase_shift dropdown values: $result"
            return TCL_ERROR
        }    
    } else {
        set m [altera_iopll::util::get_multiply_factor]
        set ref_list [list 	-family $gui_device_family \
					-speedgrade $gui_device_speed_grade \
					-refclk_freq $gui_reference_clock_frequency \
					-is_fractional [altera_iopll::util::is_pll_mode_fractional] \
					-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
					-x $gui_fractional_cout \
                    -m $m \
					-n $gui_divide_factor_n \
					-k $gui_frac_multiply_factor  \
                    -validated_counter_values [array get c_cnt_array] \
                    -desired_counter_values [array get desired_array] ]
        if {[catch {::quartus::pll::legality::retrieve_output_clock_phase_list_adv $ref_list} result]} {
            altera_iopll::util::pll_send_update_message ERROR \
               "Failed to compute output counter $callback_inst phase_shift dropdown values: $result"
            return TCL_ERROR
        }
    }
    if {$result == "TCL_ERROR"} {
            altera_iopll::util::pll_send_update_message ERROR \
                "Failed to compute output counter $n_clock phase_shift dropdown values"
            return TCL_ERROR
    }
    array set result_array $result
    set new_value_ps $result_array(closest_phase)
    set new_range_ps $result_array(phase)
	set new_range_deg $result_array(phase_deg)
	set index [altera_iopll::util::search_range_with_tolerance $new_range_ps $new_value_ps 8]
    set new_value_deg [lindex $new_range_deg $index]

	# Update the ALLOWED_RANGES property to range from qcl/pll
    if {$update_actual_ranges} {
	    set_parameter_value gui_actual_phase_shift_range$callback_inst \
                    [altera_iopll::util::round_phase $new_range_ps]
	    set_parameter_value gui_actual_phase_shift_deg_range$callback_inst \
                    [altera_iopll::util::round_phase $new_range_deg]
    }
    if {$update_hp_ranges} {
        set_parameter_property hp_actual_phase_shift_fp$callback_inst \
                    ALLOWED_RANGES $new_range_ps
    }
    if {$update_hp_value} {
	    set_parameter_value hp_actual_phase_shift_fp$callback_inst $new_value_ps
    }
    if {$update_actual_value} {
	    set_parameter_value gui_actual_phase_shift$callback_inst \
                    [altera_iopll::util::round_phase $new_value_ps]
	    set_parameter_value gui_actual_phase_shift_deg$callback_inst \
                    [altera_iopll::util::round_phase $new_value_deg]
    }
    return true
}

proc ::altera_iopll::update_callbacks::gui_actual_duty_cycle_update { \
        callback_inst {update_actual_ranges true} {update_actual_value true} \
               {update_hp_ranges true} {update_hp_value true} \
               {ignore_desired_value false}} {
	# Description: Update the gui_actual_duty_cycle dropdown to legal values. 
    #   This depends on prior outclk duty cycles, phase shifts, outclk frequencies as well as
    #    the reference clock frequency and possibly the vco frequency.
    #   If using advanced parameters, then set the frequency based on the multiply and divide factors. 
    # Inputs:- if update_actual_ranges, change ALLOWED RANGES. 
    #        - if update_actual_value, change actual value.
    #          - if update_hp_ranges, change hp ALLOWED RANGES. 
    #          - if update_hp_value, change hp value.
    #          - if ignore_desired_value, find legal values closest to the actual value

    altera_iopll::util::pll_send_update_message DEBUG "-- in update gui_actual_duty_cycle$callback_inst"

    # Get all required parameter values
    set gui_en_adv_params [get_parameter_value gui_en_adv_params]
    set gui_device_family [get_parameter_value gui_device_family]
    set gui_device_speed_grade [get_parameter_value gui_device_speed_grade]
    set gui_reference_clock_frequency [get_parameter_value gui_reference_clock_frequency]
    set gui_enable_output_counter_cascading [get_parameter_value gui_enable_output_counter_cascading]
    set gui_fractional_cout [get_parameter_value gui_fractional_cout]
    set gui_pll_mode [get_parameter_value gui_pll_mode]
    set gui_number_of_clocks [get_parameter_value gui_number_of_clocks]
    set gui_multiply_factor [get_parameter_value gui_multiply_factor]
    set gui_divide_factor_n [get_parameter_value gui_divide_factor_n]
    set gui_frac_multiply_factor [get_parameter_value gui_frac_multiply_factor]
    set gui_divide_factor_n [get_parameter_value gui_divide_factor_n]

    # If the clock is unused, it doesn't matter what the value is, as long as it matches the ranges. 
    if {$callback_inst >= $gui_number_of_clocks} {
        if {$update_hp_ranges} {
            set_parameter_property hp_actual_duty_cycle_fp$callback_inst \
               ALLOWED_RANGES [get_parameter_value hp_actual_duty_cycle_fp$callback_inst]
        }
        return false
    }

    # Get the settings of outclks with higher priority.
    set c_cnt_list [altera_iopll::util::make_validated_c_counter_array duty $callback_inst] 
    array set c_cnt_array $c_cnt_list

	# Get the current clock's desired values (produce a list for this)
    array set desired_array [altera_iopll::util::make_desired_c_counter_array duty \
                                $callback_inst $ignore_desired_value]

    # Calculate the legal phase shifts for this outclks using the qcl/pll computation code. 
    if {!$gui_en_adv_params} {
         set ref_list [list  -family $gui_device_family \
			        -speedgrade $gui_device_speed_grade \
			        -refclk_freq $gui_reference_clock_frequency \
					-is_fractional [altera_iopll::util::is_pll_mode_fractional] \
					-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
					-is_counter_cascading_enabled $gui_enable_output_counter_cascading \
					-x $gui_fractional_cout \
					-validated_counter_values [array get c_cnt_array] \
					-desired_counter_values [array get desired_array]]
        if {[catch {::quartus::pll::legality::retrieve_output_clock_duty_list $ref_list} result]} {
            altera_iopll::util::pll_send_update_message ERROR \
               "Failed to compute output counter $callback_inst duty cycle dropdown values: $result"
		    return TCL_ERROR
	    }   
    } else {
        set m [altera_iopll::util::get_multiply_factor]
        set ref_list [list 	-family $gui_device_family \
					-speedgrade $gui_device_speed_grade \
					-refclk_freq $gui_reference_clock_frequency \
					-is_fractional [altera_iopll::util::is_pll_mode_fractional] \
					-compensation_mode [altera_iopll::util::get_operation_mode_for_computation] \
					-x $gui_fractional_cout \
                    -m $m \
					-n $gui_divide_factor_n \
					-k $gui_frac_multiply_factor  \
                    -validated_counter_values [array get c_cnt_array] \
                    -desired_counter_values [array get desired_array] ]
	    if {[catch {::quartus::pll::legality::retrieve_output_clock_duty_list_adv $ref_list} result]} {
            altera_iopll::util::pll_send_update_message DEBUG \
                "Failed to compute outclk duty cycle options: $result"
	    	return TCL_ERROR
	    }
    }
    if {$result == "TCL_ERROR"} {
            altera_iopll::util::pll_send_update_message DEBUG \
                "Failed to compute outclk duty cycle options"
            return TCL_ERROR
    }
    array set result_array $result
    set new_value $result_array(closest_duty)
    set new_range $result_array(duty)

	# Update the ALLOWED_RANGES property to range from qcl/pll
    if {$update_hp_value} {
	    set_parameter_value hp_actual_duty_cycle_fp$callback_inst $new_value
    }
    if {$update_hp_ranges} {
	    set_parameter_property hp_actual_duty_cycle_fp$callback_inst \
                    ALLOWED_RANGES $new_range
    }
    if {$update_actual_ranges} {
	    set_parameter_value gui_actual_duty_cycle_range$callback_inst \
                    [altera_iopll::util::round_duty $new_range]
    }
    if {$update_actual_value} {
        set_parameter_value gui_actual_duty_cycle$callback_inst \
                    [altera_iopll::util::round_duty $new_value]
    }
    return true
}

   
