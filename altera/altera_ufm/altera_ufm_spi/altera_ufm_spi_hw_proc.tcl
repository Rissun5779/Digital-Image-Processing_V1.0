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
# | $Header: //acds/rel/18.1std/ip/altera_ufm/altera_ufm_spi/altera_ufm_spi_hw_proc.tcl#1 $
# | 
# +-----------------------------------

#//////////////////////////////////////////////////////////////////////////
#
# Name:     elaboration_callback
#
# Purpose:  Update device parameters and port settings
#
#//////////////////////////////////////////////////////////////////////////
proc elaboration_callback {} {

# +--------------------------------------
# | set 'osc' port
# +--------------------------------------
	set set_osc [get_parameter_value OSC_CHECK]	
	
	if {$set_osc == "true"} {
		add_interface osc conduit start
		add_interface_port osc osc osc Output 1
		set_interface_assignment osc "ui.blockdiagram.direction" OUTPUT
		set_interface_property osc ENABLED true
	} 

# +--------------------------------------
# | set 'oscena' port
# +--------------------------------------
	set set_oscena [get_parameter_value OSCENA_CHECK]
	
	if {$set_oscena == "true"} {
		add_interface oscena conduit end
		add_interface_port oscena oscena oscena Input 1
		set_interface_assignment oscena "ui.blockdiagram.direction" INPUT
		set_interface_property oscena ENABLED true
	}

# +--------------------------------------
# | Enable/Disable .hex/.mif input
# +--------------------------------------
	set set_mem_file [get_parameter_value GUI_MEM_INIT]
	
	if {$set_mem_file == "Initialize from hex or mif file"} {
		set_parameter_property LPM_FILE ENABLED true
	} else {
        set_parameter_property LPM_FILE ENABLED false
    }
	
# +--------------------------------------
# | convert oscillator frequency to time
# +--------------------------------------
	set set_osc_time [get_parameter_value GUI_OSC_FREQUENCY]
	
	if {$set_osc_time == 5.56} {
		set_parameter_value OSC_FREQUENCY 180000
	} elseif {$set_osc_time == 3.33} {
        set_parameter_value OSC_FREQUENCY 300000
    } else {
		set_parameter_value OSC_FREQUENCY 0
	}
	
# +--------------------------------------
# | convert erase time to picoseconds
# +--------------------------------------
	set set_erase_time [get_parameter_value GUI_ERASE_TIME]
	set_parameter_value ERASE_TIME [expr $set_erase_time*1000]
	
# +--------------------------------------
# | convert program time to picoseconds
# +--------------------------------------
	set set_program_time [get_parameter_value GUI_PROGRAM_TIME]
	set_parameter_value PROGRAM_TIME [expr $set_program_time*1000]
	
	update_device_type_params 
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

	set get_device_family [get_parameter_value DEVICE_FAMILY]
	
	if {!($get_device_family == "MAX V" || $get_device_family == "MAX II")} {
		send_message error "altera_ufm_spi does not support selected device family $get_device_family"
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
		set cbx_exec  [file join "$::env(QUARTUS_ROOTDIR)" "bin64" "clearbox"]
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