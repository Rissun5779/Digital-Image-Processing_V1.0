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


# ====================================================================================================
# | UPGRADE
# | Callback function when verifying whether a given parameter is
# | valid on this release.  It will handle the conversion of an old
# | parameter to a newly mapped parameter to make sure the backward
# | compatibility is still valid
# ====================================================================================================

proc parameter_upgrade_callback {ip_core_type version parameters} {
    # Description: Go through each parameter on an IP from a previous release, and set the
    # parameters of the new release appropriately. 
    # Inputs: ip_core_type is the IP name (altera_iopll)
    #         version is the relase number of the IP being  upgraded
    #         parameters is an array of all the old IP's parameters {{param_name0 param_value0} ...} 

	altera_iopll::util::pll_send_message DEBUG "ip: $ip_core_type v: $version p: $parameters"
	
	set new_parameters [get_parameters]
	set enabled_a_cascade_counter false
	set enabled_adv_params	false

	foreach { name value } $parameters {
		altera_iopll::util::pll_send_message DEBUG "$name, $value"
		switch -regexp $name {	      
			{gui_actual_output_clock_frequency([0-9]?[0-9])} {
				# Strip off the MHz 
				regexp {([0-9]?[0-9])} $name match index
				if {[regexp {([0-9]*\.*[0-9]*) MHz} $value match number]} {
					if {$number == 0} {
						set_parameter_value $name 0.0
					} else {
						set_parameter_value	$name $number
					}
				} else {
					set_parameter_value $name $value
				}
			}
			
			{gui_actual_phase_shift([0-9]?[0-9])} {
				# Strip of the ps / deg 
				regexp {([0-9]?[0-9])} $name match index
				if {[regexp {([0-9]*\.*[0-9]*) ps} $value match number]} {
					altera_iopll::util::pll_send_message DEBUG "  $name $number"
					if {$number == 0} {
						set_parameter_value $name 0.0
					} else {
						set_parameter_value	$name $number
					}
				} elseif {[regexp {([0-9]*\.*[0-9]*) deg} $value match number]} {
					altera_iopll::util::pll_send_message DEBUG "  $name $number"

					# Case:204363 -- make sure the unit is in degrees 
					set unit [get_parameter_value gui_ps_units$index]
					if {$unit == "degrees"} {					
						if {$number == 0} {
							set_parameter_value	gui_actual_phase_shift_deg$index 0.0
						} else {
							set_parameter_value	gui_actual_phase_shift_deg$index $number
						}
					}
				} else {
					if {$value == 0} {
						set_parameter_value $name 0.0
					} else {
						set_parameter_value $name $value
					}
				}
			}

			{gui_actual_phase_shift_deg([0-9]?[0-9])} {
				regexp {([0-9]?[0-9])} $name match index
			}	

			{gui_actual_duty_cycle([0-9]?[0-9])} {
				set saw_actual_duty_cycle true
				regexp {([0-9]?[0-9])} $name match index
				if {[regexp {([0-9]*(.)*[0-9]*) MHz} $value match number]} {
					set_parameter_value	$name $number
				} else {
					set_parameter_value $name $value
				}
			}				
			
			{gui_output_clock_frequency([0-9]?[0-9])} {
				regexp {([0-9]?[0-9])} $name match index
				set_parameter_value $name $value
			}
			
			{gui_phase_shift([0-9]?[0-9])} {
				regexp {([0-9]?[0-9])} $name match index
				if {[regexp {(-*[0-9]*)\.*([0-9]*)} $value match number_pre number_post]} {
					if {$number_post == ""} {
						set number "$number_pre.0"
					} else {
						set number "$number_pre.$number_post"
					}
					set_parameter_value	$name $number
				} else {    		
					set_parameter_value $name $value
				}
			}	

			{gui_phase_shift_deg([0-9]?[0-9])} {
				regexp {([0-9]?[0-9])} $name match index			
				set_parameter_value $name $value
			}	

			{gui_duty_cycle([0-9]?[0-9])} {
				regexp {([0-9]?[0-9])} $name match index
				if {[regexp {([0-9]*)\.*([0-9]*)} $value match number_pre number_post]} {
					if {$number_post == ""} {
						set number "$number_pre.0"
					} else {
						set number "$number_pre.$number_post"
					}
					set_parameter_value	$name $number
				} else {			
					set_parameter_value $name $value
				}							
			}				
		
			"number_of_clocks" {
				set_parameter_value gui_number_of_clocks $value	
			}
			
			"operation_mode" {
                if {$value == "source_synchronous"} {
                    set value "source synchronous"
                }
				set_parameter_value gui_operation_mode $value
			}
			
			"gui_pll_auto_reset" {
				# Changed to boolean as of 14.0
				if {$value == "Off"} {
					set_parameter_value $name	false
				} elseif {$value == "On"} {
					set_parameter_value $name true
				} else {
					set_parameter_value $name [get_parameter_property $name DEFAULT_VALUE]
				}
			}	
			
            "hp_device_family" {
                #Might get changed right away in family update callback
				set_parameter_value gui_device_family	$value
			}

			"device_family" {
				# Changed name as of 14.0
				set_parameter_value	system_info_device_family	$value
			}

			"system_info_device_speed_grade" {
                set_parameter_value system_info_device_speed_grade $value
            }

			"device" {
				# Changed name as of 14.0
				set_parameter_value	system_info_device_component	$value
			}
			
			"gui_pll_cascading_mode" {
				# Changed values as of 14.0
				switch $value {
					"Create an adjpllin signal to connect with an upstream PLL" {
						set_parameter_value $name "adjpllin"
					}
					"Create a cclk signal to connect with an upstream PLL" {
						set_parameter_value $name "cclk"
					}
					"cclk" -
					"adjpllin" {
						set_parameter_value $name $value
					}
					default {
						set_parameter_value $name [get_parameter_property $name DEFAULT_VALUE]
					}
				}
			}

			"device_speed_grade" {
				set_parameter_value	gui_device_speed_grade	$value
                set_parameter_value system_info_device_speed_grade $value
			}
			
			"gui_multiply_factor0" {
				set_parameter_value	gui_multiply_factor $value
			}
			
			"gui_frac_multiply_factor0" {
				set_parameter_value	gui_frac_multiply_factor $value
			}
			
			{gui_divide_factor([0-9]?[0-9])} {
				regexp {gui_divide_factor([0-9]?[0-9])} $name match number
				set_parameter_value	gui_divide_factor_c$number	$value
			}
			
			"debug_print_output" -
			"debug_use_rbc_taf_method" -
			"gui_channel_spacing" - 
			"gui_auto_validate" {
				# Parameters no longer exist - do nothing
			}
			
			"gui_en_adv_params" {
				if {$value} {
					set enabled_adv_params true
				}
				set_parameter_value $name $value
			}
			
			{gui_cascade_counter([0-9]?[0-9])} {
				if { $value } {
					set enabled_a_cascade_counter true
				}
				set_parameter_value $name $value
			}
			
			"gui_pll_bandwidth_preset" {
				if {$value == "Auto"} {
					set_parameter_value $name	"Low"
				} else {
					set_parameter_value	$name	$value
				}
			}
            
            "gui_en_lvds_ports" {
				if {$value == "false"} {
					set_parameter_value $name "Disabled"
				} elseif {$value == "true"} {
					set_parameter_value $name "Enable LVDS_CLK/LOADEN 0"
                } else {
                    set_parameter_value	$name	$value
                }			
			}

            "gui_mif_generate" {
                if {$value == "false"} {
                    set_parameter_value gui_mif_gen_options "Generate New MIF File"
                } else {
                    set_parameter_value gui_mif_gen_options "Create MIF file during IP Generation"
                }      
            }
			
			default {   
				if {[lsearch $new_parameters $name] != -1} {
					# The parameter has not been changed
					set_parameter_value	$name	$value
				}
			}  
		}
	}

    # In previous releases, the *actual* values were not saved - they were set to the default values
    # and then computed based on the desired values during validation. 
    # Set actual values to the legal values closest to their desired equivalents.
    
    ::altera_iopll::update_callbacks::gui_device_family_update
    ::altera_iopll::update_callbacks::gui_device_component_update
    ::altera_iopll::update_callbacks::gui_device_speed_grade_update

    ::altera_iopll::update_callbacks::initialize_dropdowns "UPGRADE"
	
	# Now deal with the new parameters that don't have an analog in the old megawiz
	
	# Add the actual duty cycle parameters if necessary
	if {$version < 14.0} {
		for {set i 0} {$i < 18} {incr i} {
		    ::altera_iopll::util::set_parameters_equal \
                  gui_actual_duty_cycle$i gui_duty_cycle$i
		}
	}
	
	# gui_enable_output_counter_cascading
	if {$enabled_a_cascade_counter && $enabled_adv_params} {
		set_parameter_value gui_enable_output_counter_cascading true
	}
	
	# gui_clock_name/clock name global
	if {[lsearch $parameters "gui_clock_name_string0"] == -1} {
		#if the parameter does NOT EXIST
		for {set i 0} {$i < 18} {incr i} {
			set_parameter_value gui_clock_name_string$i ""
		}
	}

    # Assume that the IOPLL was not made using qsys-scripting
    set_parameter_value hp_qsys_scripting_mode false
}
