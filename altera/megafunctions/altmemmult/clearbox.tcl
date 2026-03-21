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
    set dir_name [quartus_bindir::quartus_bindir ]
    set cbx_exec [file join "$dir_name" "clearbox"]

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

