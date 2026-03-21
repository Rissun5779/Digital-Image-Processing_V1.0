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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/pgm/altera_s10_configuration_clock/altera_s10_configuration_clock_hw_proc.tcl#1 $
# | 
# +-----------------------------------

# Regular expression to parse device name. Only applicable for device family that support DEVICE_ID parameter.
# parameter #1 - family_code
# parameter #2 - device_code
array set device_name_pattern {
	"MAX 10"     "^(10M)(\\d+)"
}


# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaboration_callback {} {
	update_enable_port
	update_device_type_params
	update_display_message
	update_clock_frequency_option
}
proc update_enable_port {} {
	set get_device_family [get_parameter_value DEVICE_FAMILY]
	# +-----------------------------------
	# | connection point - input
	# +-----------------------------------
	if { $get_device_family ne "Stratix 10" } {
		add_interface oscena conduit end
		add_interface_port oscena oscena oscena Input 1
		set_interface_assignment oscena "ui.blockdiagram.direction" INPUT
		set_interface_property oscena ENABLED true
	}
}

proc update_clock_frequency_option {} {

	set get_device_family [get_parameter_value DEVICE_FAMILY]
	set get_device_id [get_parameter_value DEVICE_ID]
	
	# set get_clock_freq_1 [get_parameter_value CLOCK_FREQUENCY_1]
	# set get_clock_freq_2 [get_parameter_value CLOCK_FREQUENCY_2]

	# set_parameter_property CLOCK_FREQUENCY_1 VISIBLE false
	# set_parameter_property CLOCK_FREQUENCY_1 ENABLED false
	# set_parameter_property CLOCK_FREQUENCY_2 VISIBLE false
	# set_parameter_property CLOCK_FREQUENCY_2 ENABLED false
	# set_parameter_value CLOCK_FREQUENCY "UNKNOWN"
	
	# if { $get_device_family == "MAX 10" } {
	# 	set_parameter_property CLOCK_FREQUENCY HDL_PARAMETER true
	# 	if { $get_device_id != "UNKNOWN" } {
	# 		if { $get_device_id == "40" || $get_device_id == "50" } {
	# 			set_parameter_property CLOCK_FREQUENCY_2 VISIBLE true
	# 			set_parameter_property CLOCK_FREQUENCY_2 ENABLED true
	# 			set_parameter_value CLOCK_FREQUENCY $get_clock_freq_2
	# 		} else {
	# 			set_parameter_property CLOCK_FREQUENCY_1 VISIBLE true
	# 			set_parameter_property CLOCK_FREQUENCY_1 ENABLED true
	# 			set_parameter_value CLOCK_FREQUENCY $get_clock_freq_1
	# 		}
	# 	} else {
	# 		set_parameter_property CLOCK_FREQUENCY_1 VISIBLE true
	# 	}
	# } else {
	# 	set_parameter_property CLOCK_FREQUENCY HDL_PARAMETER false
	# }

	# send_message debug "CLOCK_FREQUENCY = [get_parameter_value CLOCK_FREQUENCY]"	
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     update_display_message
#
# Purpose:  Update display message based on selected device family
#
# Returns:  n/a
#
#//////////////////////////////////////////////////////////////////////////
proc update_display_message {} {

	set get_device_family [get_parameter_value DEVICE_FAMILY]
	set get_device_id [get_parameter_value DEVICE_ID]
	
	if { $get_device_family == "MAX 10" } {
		set info "The output frequency for 10M02, 10M04, 10M08, 10M16, and 10M25 devices is 55~116MHz <br>"
		set info "${info}The output frequency for 10M40, and 10M50 devices is 35~77MHz <br>"

		if { $get_device_id == "UNKNOWN" } {
			set info "${info}<br><b>User does not specify the Device, the default clock frequency of simulation model is 116MHz.<br>"
			set info "${info}User is recommended to specific a valid Device because MAX 10 supports different clock frequency for different device.</b>"
		}
		
		set_parameter_value INFORMATION $info

	} elseif {($get_device_family == "Cyclone III") || ($get_device_family == "Cyclone III LS") || ($get_device_family == "Cyclone IV E") || ($get_device_family == "Cyclone IV GX")} {
		set_parameter_value INFORMATION "The maximum output frequency is 80MHz"
	
	} elseif {($get_device_family == "Stratix 10")} {
		set info "If the design uses internal oscilator then the configuration clock output runs between 170MHz and 230MHz.<br>"
		set info "${info}If external clock is used (connect to OSC_CLK_1) then the configuration clock runs at 250Mhz.<br>"
		set_parameter_value INFORMATION $info 
	
	} else {
		set_parameter_value INFORMATION "The maximum output frequency is 100MHz"
	}

	set gui_information [get_parameter_value INFORMATION]
	set gui_information "<html><table border=\"0\" width=\"100%\"><tr><td valign=\"top\"><font size=3>$gui_information</td></tr></table></html>"
	set_display_item_property GUI_INFORMATION TEXT $gui_information
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     update_device_type_params
#
# Purpose:  Check compatibility of device family
#
# Returns:  n/a
#
#//////////////////////////////////////////////////////////////////////////
proc update_device_type_params {} {
	
	global device_name_pattern
	
	set get_device_family [get_parameter_value DEVICE_FAMILY]
	set get_device [string toupper [get_parameter_value PART_NAME]]
	
	set device_families_list [get_module_property SUPPORTED_DEVICE_FAMILIES]
	if {([check_device_family_equivalence $get_device_family $device_families_list] != 1)} {
		send_message error "altera_int_osc does not support selected device family $get_device_family"
	}	

	# Setup device spefic derived parameter
	set_parameter_value DEVICE_ID "UNKNOWN"
	if {[info exists device_name_pattern($get_device_family)]} {
		set_parameter_property DEVICE_FAMILY HDL_PARAMETER true
		set_parameter_property DEVICE_ID HDL_PARAMETER true
		
		if { [string toupper $get_device] != "UNKNOWN" } {
			set pattern $device_name_pattern($get_device_family)
			if {[regexp $pattern $get_device match selected_family_code selected_device_code]} {
				set_parameter_value DEVICE_ID $selected_device_code
				send_message debug "DEVICE_ID = [get_parameter_value DEVICE_ID]"
			} else {
				# report error
				send_message error "Illegal device name format - $get_device."
			}
		}
	} else {
		if { $get_device_family == "Stratix 10" } {
			set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
			set_parameter_property DEVICE_ID HDL_PARAMETER false
		}
	}
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     do_clearbox_gen
#
# Purpose:  Does a system call to clearbox, passing the given parameter
#           file and outputing the variation file to the given file.
#
# Params:   ip_name -- name of the ip clearbox will use to generate
#           param_file -- file with all of the clearbox parameters
#           var_file -- file to output the variation file to
#
# Returns:  String (boolean) -- true if successful, otherwise returns error message
#
#//////////////////////////////////////////////////////////////////////////
proc do_clearbox_gen {ip_name param_file var_file} {

    # Split var_file into directory and filename
    set var_dir [file dirname $var_file]
    set var_filename  [file tail $var_file]     

    # Get the path to the clearbox executable
    if { "$::tcl_platform(platform)" == "windows" } {
		set cbx_exec  [file join "$::env(QUARTUS_ROOTDIR)" "bin64" "clearbox.exe"]
		set cbx_exec [file attributes $cbx_exec -shortname]
	} else {
		set cbx_exec  [file join "$::env(QUARTUS_ROOTDIR)" "bin" "clearbox"]
	}

    # Create the clearbox command as a list of arguments
    set cbx_cmd [ list $cbx_exec $ip_name -f $param_file CBX_FILE="${var_filename}" CBX_OUTPUT_DIRECTORY="${var_dir}" ]

    # Execute clearbox
    set status [catch {exec $cbx_cmd} err]

    # Parse stdout for indications of success
    if { [string compare -nocase -length 16 "output file name" $err] == 0 } {
        return true
    } else {
        return $err
    }
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     generate_clearbox_parameter_file
#
# Purpose:  Generates a parameter file that clearbox will use for generation
#
# Params:   param_file -- parameter file to place all ports and parameters
#           parameter_list -- list of all parameters
#           port_list -- list of all ports
#
# Returns:  String (boolean) -- true if successful, otherwise false
#
#//////////////////////////////////////////////////////////////////////////
proc generate_clearbox_parameter_file {param_file parameters_list ports_list }   {

    # Open the file for writting
     set path $param_file
     if {[catch {open $path w} fid ] }    {
         send_message  error  "Failed to open $path for writing: $fid"
         return false
     } else {

        # Output all the parameters to the file in the form <PARAM_NAME>="<VALUE>"
        foreach  {parameter value}   $parameters_list    {
            puts $fid  [format "%s=\"%s\"" $parameter $value]
        }

        #output ports to the file
        foreach port $ports_list {
            puts $fid $port
        }

        # Close the file pointer
        close $fid

        # Return successfully
        return true
    }
} 

