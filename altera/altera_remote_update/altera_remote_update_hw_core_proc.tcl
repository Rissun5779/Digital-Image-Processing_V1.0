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
# | $Header: //acds/rel/18.1std/ip/altera_remote_update/altera_remote_update_hw_core_proc.tcl#1 $
# | 
# +-----------------------------------


#//////////////////////////////////////////////////////////////////////////
#
# Name:     update_device_type_params
#
# Purpose:  Check compatibility of device family
#
# Returns:  n/a
#
#//////////////////////////////////////////////////////////////////////////
proc update_device_type_params { get_device_family } {
	
	set supported_families [list \
		"Arria II GZ" \
		"Arria V" \
		"Arria V GZ" \
		"Cyclone IV E" \
        "Cyclone 10 LP" \
		"Cyclone V" \
		"Arria 10" \
		"Arria II GX" \
		"Cyclone IV GX" \
		"Stratix V" \
		"Stratix IV" \
	]
	
	if {[lsearch $supported_families $get_device_family] == -1} {
		send_message error "altera_remote_update does not support selected device family $get_device_family"
	}
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     check_arria10_device_is_not_unknown
#
# Purpose:  For arria 10, different device part (ES, E2 and Production) has different
#			source files. So it nees a specific device part.
#
# Returns:  n/a
#
#//////////////////////////////////////////////////////////////////////////
proc check_arria10_device_is_not_unknown {} {
	
	set get_device_part     [get_parameter_value DEVICE]
	
	if {[string toupper $get_device_part] == "UNKNOWN"} {
		send_message error "Must assign a valid Device for altera_remote_update."
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

#//////////////////////////////////////////////////////////////////////////
#
# Name:     check_arria10_except_nf5es
#
# Purpose:  Check if the device is Arria10 except NF5 ES or other family 
#
#
# Returns:  String (boolean) -- true if Arria10 , otherwise false for NF5ES device
#
#//////////////////////////////////////////////////////////////////////////
#+----------------------------------------------------------------------------------------------------------------------------
#|  Check if the family is Arria 10 - but not NF5ES 
#+----------------------------------------------------------------------------------------------------------------------------
proc check_arria10_except_nf5es {} {
    # Read the device part if NF5 ES or not
    set get_device_family   [get_parameter_value DEVICE_FAMILY]
    set get_device_part     [get_parameter_value DEVICE]
    # Find 10AX115 at front and ES at the end of device part NAME
    if { $get_device_family eq "Arria 10"} {
        if [regexp (^10AX115).*(ES$) $get_device_part ] {
            return 0
        } else {
            return 1
        }
    } else {
        return 0
    }
}
