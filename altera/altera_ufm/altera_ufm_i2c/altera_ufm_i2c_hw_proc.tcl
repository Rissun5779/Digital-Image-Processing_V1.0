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
# | $Header: //acds/rel/18.1std/ip/altera_ufm/altera_ufm_i2c/altera_ufm_i2c_hw_proc.tcl#1 $
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

# +---------------------------------------
# | Display port according to access mode
# +---------------------------------------
	set set_read_write [get_parameter_value ACCESS_MODE]	
	
	if {$set_read_write == "READ_ONLY"} {
		set_parameter_property WRITE_MODE			ENABLED 	false
		set_parameter_property PAGE_WRITE_SIZE 		ENABLED		false
		set_parameter_property WP_CHECK 			ENABLED		false
		set_parameter_property MEM_PROTECT 			ENABLED		false
		set_parameter_property ERASE_METHOD 		ENABLED		false
		set_parameter_property GUI_MEM_ADD_ERASE0 	ENABLED		false
		set_parameter_property GUI_MEM_ADD_ERASE1 	ENABLED		false
		
		send_message info "Write and erase options can only be used with read and write mode"
	} else {
		set_parameter_property WRITE_MODE			ENABLED 	true
		set_parameter_property PAGE_WRITE_SIZE 		ENABLED		true
		set_parameter_property WP_CHECK 			ENABLED		true
		set_parameter_property ERASE_METHOD 		ENABLED		true
	}

# +--------------------------------------
# | check MSB address (binary)
# +--------------------------------------	
	
	set msb_add [get_parameter_value FIXED_DEVICE_ADD]
	
	foreach num {" " 2 3 4 5 6 7 8 9} {
		if {[string match -nocase "*$num*" $msb_add]}  {
			send_message error "The MSB address value should be binary"
		}
	}
	
	#check length to ensure its 4-bits
	set msb_add_length [string length $msb_add]
	
	if {$msb_add_length > 4} {
		send_message error "The MSB value is more than 4-bits, enter a 4-bits binary address"
	} elseif {$msb_add_length < 4} {
		send_message error "The MSB value is less than 4-bits, enter a 4-bits binary address"
	}


# +--------------------------------------
# | set 'global_reset' port
# +--------------------------------------
	set set_global_reset [get_parameter_value GUI_GLOBAL_CHECK]	
	
	if {$set_global_reset == "true"} {
		add_interface global_reset conduit end
		add_interface_port global_reset global_reset global_reset Input 1
		set_interface_assignment global_reset "ui.blockdiagram.direction" INPUT
		set_interface_property global_reset ENABLED true
		
		set_parameter_value PORT_GLOBAL_RESET "USED"
	} else {
		set_parameter_value PORT_GLOBAL_RESET "PORT_UNUSED"
	}


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
# | set 'wp' port
# +--------------------------------------
	set set_wp [get_parameter_value WP_CHECK]
	
	if {$set_wp == "true" && $set_read_write != "READ_ONLY"} {
		add_interface wp conduit end
		add_interface_port wp wp wp Input 1
		set_interface_assignment wp "ui.blockdiagram.direction" INPUT
		set_interface_property wp ENABLED true
		
		#enable write protect options
		set_parameter_property MEM_PROTECT ENABLED true
	} else {
		set_parameter_property MEM_PROTECT ENABLED false
	}

# +------------------------------------------------
# | Enable page write size according to write mode
# +------------------------------------------------
	set set_write_mode [get_parameter_value WRITE_MODE]
	
	if {$set_write_mode == "PAGE" && $set_read_write != "READ_ONLY"} {
		set_parameter_property PAGE_WRITE_SIZE ENABLED true		
		set_parameter_property ERASE_METHOD ALLOWED_RANGES {"DEV_ADD_111:Device slave address full erase (3 LSBs are 111)" "A2_ERASE:Sector erase triggered by 'a2' bit" "NO_ERASE:No erase"} 
	} elseif {$set_write_mode == "SINGLE_BYTE"} {
		set_parameter_property PAGE_WRITE_SIZE ENABLED false	
		set_parameter_property ERASE_METHOD ALLOWED_RANGES {"DEV_ADD_111:Device slave address full erase (3 LSBs are 111)" "MEM_ADD:Sector erase triggered by byte address" "A2_ERASE:Sector erase triggered by 'a2' bit" "NO_ERASE:No erase"} 
	}

# +------------------------------------------------
# | Enable Sector 0 and Sector 1
# +------------------------------------------------
	set set_erase_method [get_parameter_value ERASE_METHOD]
	
	if {$set_erase_method == "MEM_ADD" && $set_read_write != "READ_ONLY"} {
		set_parameter_property GUI_MEM_ADD_ERASE0 ENABLED true
		set_parameter_property GUI_MEM_ADD_ERASE1 ENABLED true
		
		#check if input is binary
		check_sector_value_type
		
		#check if length is 8-bits and update internal sector 0 and sector 1 value
		#check_sector_value_length
		
		#update internal sectors value according to memory size
		update_internal_sector_value
	
	} else {
		set_parameter_property GUI_MEM_ADD_ERASE0 ENABLED false
		set_parameter_property GUI_MEM_ADD_ERASE1 ENABLED false
	}
	
	#check if "erase method" is compatible with "write configuration"
	if {$set_erase_method == "MEM_ADD" && $set_write_mode == "PAGE"} {
		send_message error "Byte address triggered sector erase cannot be used with single byte write configuration"
		
		set_parameter_property ACCESS_MODE 			ENABLED 	false
		set_parameter_property FIXED_DEVICE_ADD 	ENABLED 	false
		set_parameter_property MEMORY_SIZE 			ENABLED 	false
		set_parameter_property GUI_GLOBAL_CHECK 	ENABLED 	false
		set_parameter_property OSC_CHECK 			ENABLED 	false
		set_parameter_property OSCENA_CHECK 		ENABLED 	false
		set_parameter_property PAGE_WRITE_SIZE		ENABLED		false
		
		set_parameter_property MEM_PROTECT 			ENABLED 	false	
		set_parameter_property WP_CHECK 			ENABLED 	false
		set_parameter_property GUI_MEM_ADD_ERASE0	ENABLED 	false
		set_parameter_property GUI_MEM_ADD_ERASE1	ENABLED 	false
		
		set_parameter_property GUI_MEM_INIT 		ENABLED 	false
		set_parameter_property LPM_FILE 			ENABLED 	false
		set_parameter_property GUI_OSC_FREQUENCY 	ENABLED 	false
		set_parameter_property GUI_ERASE_TIME 		ENABLED 	false
		set_parameter_property GUI_PROGRAM_TIME 	ENABLED 	false
	} else {
		set_parameter_property ACCESS_MODE 			ENABLED 	true
		set_parameter_property FIXED_DEVICE_ADD 	ENABLED 	true
		set_parameter_property MEMORY_SIZE 			ENABLED 	true
		set_parameter_property GUI_GLOBAL_CHECK 	ENABLED 	true
		set_parameter_property OSC_CHECK 			ENABLED 	true
		set_parameter_property OSCENA_CHECK 		ENABLED 	true
		
		set_parameter_property GUI_MEM_INIT 		ENABLED 	true
		set_parameter_property LPM_FILE 			ENABLED 	true
		set_parameter_property GUI_OSC_FREQUENCY 	ENABLED 	true
		set_parameter_property GUI_ERASE_TIME 		ENABLED 	true
		set_parameter_property GUI_PROGRAM_TIME 	ENABLED 	true
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
	if {$set_osc_time == "5.56"} {
		set_parameter_value OSC_FREQUENCY 180000
	} elseif {$set_osc_time == "3.33"} {
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
# Name:     check_sector_value_type
#
# Purpose:  Check if entered value is a binary address
#
# Returns:  n/a
#
#//////////////////////////////////////////////////////////////////////////
proc check_sector_value_type {} {

	set sector_0 [get_parameter_value GUI_MEM_ADD_ERASE0]
	set sector_1 [get_parameter_value GUI_MEM_ADD_ERASE1]

	#Check to ensure value of Sector 0 is binary	
	foreach num {" " 2 3 4 5 6 7 8 9} {
		if {[string match -nocase "*$num*" $sector_0]}  {
			send_message error "The Sector 0 value should be binary"
		}
	}	
	
	#Check to ensure value of Sector 1 is binary	
	foreach num {" " 2 3 4 5 6 7 8 9} {
		if {[string match -nocase "*$num*" $sector_1]}  {
			send_message error "The Sector 1 value should be binary"
		}
	}
	
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     check_sector_value_length
#
# Purpose:  Check if input is more than 8-bits. If so, error message is 
#			generated.
#
# Returns:  n/a
#
#//////////////////////////////////////////////////////////////////////////
proc check_sector_value_length {} {

	set sector_0 [get_parameter_value GUI_MEM_ADD_ERASE0]
	set sector_1 [get_parameter_value GUI_MEM_ADD_ERASE1]

	#check length of Sector 0 (only 8-bits)
	set sector_0_length [string length $sector_0]
	
	if {$sector_0_length > 8} {
		send_message error "The Sector 0 value is more than 8-bits, enter a 8-bits binary address"
	} elseif {$sector_0_length < 8} {
		send_message error "The Sector 0 value is less than 8-bits, enter a 8-bits binary address"
	}
	
	#check length of Sector 1 (only 8-bits)
	set sector_1_length [string length $sector_1]
	
	if {$sector_1_length > 8} {
		send_message error "The Sector 1 value is more than 8-bits, enter a 8-bits binary address"
	} elseif {$sector_1_length < 8} {
		send_message error "The Sector 0 value is less than 8-bits, enter a 8-bits binary address"
	}
	
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     update_internal_sector_value
#
# Purpose:  Check if input is more than 8-bits. If so, error message is 
#			generated.
#
# Returns:  n/a
#
#//////////////////////////////////////////////////////////////////////////
proc update_internal_sector_value {} {

	set memory_size [get_parameter_value MEMORY_SIZE]
	
	foreach param { 0 1 } {
	
		if {$param == 0} {
			set sector [get_parameter_value GUI_MEM_ADD_ERASE0]
			set length [string length $sector]
		} elseif {$param == 1} {
			set sector [get_parameter_value GUI_MEM_ADD_ERASE1]
			set length [string length $sector]
		}

		set count 0	
		if {$memory_size == "1K"} {
			if {$length > 6} {
				set charlist [split $sector ""]	
				send_message info $charlist			
				foreach charset    $charlist	{
					set char($count) $charset 
					incr count				
				}			
				set sector $char([expr {$length-6}])$char([expr {$length-5}])$char([expr {$length-4}])$char([expr {$length-3}])$char([expr {$length-2}])$char([expr {$length-1}])			
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			} elseif {$length < 6} {
				while {$length < 6} {
					set sector 0$sector
					set length [string length $sector]
				}
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			} else {
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			}
		} elseif {$memory_size == "2K"} {
			if {$length > 7} {
				set charlist [split $sector ""]	
				send_message info $charlist			
				foreach charset    $charlist	{
					set char($count) $charset 
					incr count				
				}			
				set sector $char([expr {$length-7}])$char([expr {$length-6}])$char([expr {$length-5}])$char([expr {$length-4}])$char([expr {$length-3}])$char([expr {$length-2}])$char([expr {$length-1}])			
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			} elseif {$length < 7} {
				while {$length < 7} {
					set sector 0$sector
					set length [string length $sector]
				}
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			} else {
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			}
		} elseif {$memory_size == "4K"} {
			if {$length > 8} {
				set charlist [split $sector ""]	
				send_message info $charlist			
				foreach charset    $charlist	{
					set char($count) $charset 
					incr count				
				}			
				set sector $char([expr {$length-8}])$char([expr {$length-7}])$char([expr {$length-6}])$char([expr {$length-5}])$char([expr {$length-4}])$char([expr {$length-3}])$char([expr {$length-2}])$char([expr {$length-1}])			
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			} elseif {$length < 8} {
				while {$length < 8} {
					set sector 0$sector
					set length [string length $sector]
				}
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			} else {
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			}
		} elseif {$memory_size == "8K"} {
			if {$length > 9} {
				set charlist [split $sector ""]	
				send_message info $charlist			
				foreach charset    $charlist	{
					set char($count) $charset 
					incr count				
				}			
				set sector $char([expr {$length-9}])$char([expr {$length-8}])$char([expr {$length-7}])$char([expr {$length-6}])$char([expr {$length-5}])$char([expr {$length-4}])$char([expr {$length-3}])$char([expr {$length-2}])$char([expr {$length-1}])			
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			} elseif {$length < 9} {
				while {$length < 9} {
					set sector 0$sector
					set length [string length $sector]
				}
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			} else {
				if {$param == 0} {
					set_parameter_value MEM_ADD_ERASE0 $sector
				} elseif {$param == 1} {
					set_parameter_value MEM_ADD_ERASE1 $sector
				}
			}
		}
	}
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
		send_message error "altera_ufm_i2c does not support selected device family $get_device_family"
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