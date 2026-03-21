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


package require -exact qsys 14.0

#+-------------------------------------------
#|
#|  Source Files
#|
#+-------------------------------------------
source "../common/mac_native_common.tcl"

#+--------------------------------------------
#|
#|  Elaboration Callback for Ports setup
#|
#+--------------------------------------------
proc interface_ports_and_mapping {} {
    
	# Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }
    
		 if {$params(operation_mode) eq "m18x18_full"} {
			#Top mult setting
			#================
			if {$params(operand_source_max) eq "coef"} {  
				set_parameter_property ax_width ALLOWED_RANGES  0
			}
			if {$params(operand_source_max) ne "coef"} {
				set_parameter_property ax_width ALLOWED_RANGES 1:18 
			}
			
			if {$params(operand_source_may) eq "preadder"} {
				set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:18 
				set_parameter_property az_width ALLOWED_RANGES  1:18    
			}
			if {$params(operand_source_may) ne "preadder"} {
				if {$params(signed_may) eq "true"} {
					set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:19 
				}
				if {$params(signed_may) ne "true"} { 
					set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:18
				}
				set_parameter_property az_width ALLOWED_RANGES  0:18 
			}  
			
			#Allow only top mult to be used, leaving bottom mult unuse.
			#===========================================================
			if { $params(bx_width) eq 0 || $params(by_width) eq 0 || $params(result_b_width) eq 0 } {
				set_parameter_property bz_width ALLOWED_RANGES   0:18
				if { $params(result_b_width) eq 0 } {
					set_parameter_property bx_width ALLOWED_RANGES  0
					set_parameter_property by_width ALLOWED_RANGES  0
				} elseif { $params(bx_width) eq 0 } {
					if {$params(operand_source_mbx) eq "coef"} {
						set_parameter_property by_width ALLOWED_RANGES  0:18
						set_parameter_property result_b_width ALLOWED_RANGES  0:37
					} else {
						set_parameter_property by_width ALLOWED_RANGES  0
						set_parameter_property result_b_width ALLOWED_RANGES  0
					}
				} elseif { $params(by_width) eq 0 } {
					if { $params(by_use_scan_in) eq "false" } {
						set_parameter_property bx_width ALLOWED_RANGES  0
						set_parameter_property result_b_width ALLOWED_RANGES  0
					} else { #bottom mult could still be used
						set_parameter_property bx_width ALLOWED_RANGES  0:18
						set_parameter_property result_b_width ALLOWED_RANGES  0:37
					}
				} 
			} else {
			
			    set_parameter_property result_b_width ALLOWED_RANGES  1:37
				
				if {$params(operand_source_mbx) eq "coef"} {  
					set_parameter_property bx_width ALLOWED_RANGES  0
				}
				if {$params(operand_source_mbx) ne "coef"} {
					set_parameter_property bx_width ALLOWED_RANGES 1:18 
				}
				if {$params(operand_source_mby) eq "preadder"} {
					set_parameter_property bz_width ALLOWED_RANGES  1:18
					if { $params(by_use_scan_in) eq "true" } {
						set_parameter_property by_width ALLOWED_RANGES 0:18  
					} else {
						set_parameter_property by_width ALLOWED_RANGES 1:18
					}
					    
				}
				if {$params(operand_source_mby) ne "preadder"} {
					set_parameter_property bz_width ALLOWED_RANGES   0:18
					if {$params(signed_mby) eq "true"} {
						if { $params(by_use_scan_in) eq "true" } {
							set_parameter_property by_width ALLOWED_RANGES 0:19 
						} else {
							set_parameter_property by_width ALLOWED_RANGES 1:19
						}						
					}
					if {$params(signed_mby) ne "true"} {
						if { $params(by_use_scan_in) eq "true" } {
							set_parameter_property by_width ALLOWED_RANGES 0:18
						} else {
							set_parameter_property by_width ALLOWED_RANGES 1:18
						}
					}
				}
			}					
	}
	
    if { $params(operation_mode) eq "m18x18_sumof2" || $params(operation_mode) eq "m18x18_systolic"} { 
		set_parameter_property result_b_width ALLOWED_RANGES  0
		
        if {$params(operand_source_max) eq "coef"} {  
            set_parameter_property ax_width ALLOWED_RANGES  0
        }
        if {$params(operand_source_max) ne "coef"} {
            set_parameter_property ax_width ALLOWED_RANGES 1:18 
        }
        
        if {$params(operand_source_may) eq "preadder"} {
            set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:18 
            set_parameter_property az_width ALLOWED_RANGES  1:18    
        }
        if {$params(operand_source_may) ne "preadder"} {
            if {$params(signed_may) eq "true"} {
                set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:19 
            }
            if {$params(signed_may) ne "true"} { 
                set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:18
            }
            set_parameter_property az_width ALLOWED_RANGES  0:18
        }    
        if {$params(operand_source_mbx) eq "coef"} {  
            set_parameter_property bx_width ALLOWED_RANGES  0
        }
        if {$params(operand_source_mbx) ne "coef"} {
            set_parameter_property bx_width ALLOWED_RANGES 1:18 
        }
        if {$params(operand_source_mby) eq "preadder"} {
            set_parameter_property bz_width ALLOWED_RANGES  1:18 
			if { $params(by_use_scan_in) eq "true" } {
				set_parameter_property by_width ALLOWED_RANGES 0:18
			} else {
				set_parameter_property by_width ALLOWED_RANGES 1:18 
			}
               
        }
        if {$params(operand_source_mby) ne "preadder"} {
			set_parameter_property bz_width ALLOWED_RANGES  0:18
            if {$params(signed_mby) eq "true"} {
                if { $params(by_use_scan_in) eq "true" } {
					set_parameter_property by_width ALLOWED_RANGES 0:19
				} else {
					set_parameter_property by_width ALLOWED_RANGES 1:19 
				}
            }
            if {$params(signed_mby) ne "true"} { 
                if { $params(by_use_scan_in) eq "true" } {
					set_parameter_property by_width ALLOWED_RANGES 0:18
				} else {
					set_parameter_property by_width ALLOWED_RANGES 1:18 
				}
            }
            #bz_width checked using error message
        }
    }
    if {$params(operation_mode) eq "m27x27"} {   
        set_parameter_property by_width ALLOWED_RANGES  0 
        set_parameter_property bx_width ALLOWED_RANGES  0
        set_parameter_property bz_width ALLOWED_RANGES  0
	    set_parameter_property result_b_width ALLOWED_RANGES  0
        if {$params(operand_source_max) eq "coef"} {  
            set_parameter_property ax_width ALLOWED_RANGES  0
        }
        if {$params(operand_source_max) ne "coef"} {
            set_parameter_property ax_width ALLOWED_RANGES 1:27 
        }       
        if {$params(operand_source_may) eq "preadder"} {
            set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:26 
            set_parameter_property az_width ALLOWED_RANGES 1:26    
        }
        if {$params(operand_source_may) ne "preadder"} {
            set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:27      
            set_parameter_property az_width ALLOWED_RANGES 0
        }    
    }
    if {$params(operation_mode) eq "m18x18_plus36"} {   
        if {$params(signed_may) eq "true"} { 
            set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:19
        }
        if {$params(signed_may) ne "true"} { 
            set_parameter_property ay_scan_in_width ALLOWED_RANGES 1:18
        }
        if {$params(signed_mby) ne "true"} { 
            set_parameter_property by_width ALLOWED_RANGES 1:18
        }  
        set_parameter_property ax_width ALLOWED_RANGES  1:18
        set_parameter_property az_width ALLOWED_RANGES  0  
        set_parameter_property bx_width ALLOWED_RANGES  1:18
        set_parameter_property bz_width ALLOWED_RANGES  0
	    set_parameter_property result_b_width ALLOWED_RANGES  0		
      
    }
    
	#input data ports
	
	if {$params(ay_use_scan_in) eq "true"} {
		my_set_interface "in" "scanin" $params(ay_scan_in_width) "false" 0
		set_port_property scanin VHDL_TYPE STD_LOGIC_VECTOR	
	} else {
		my_set_interface "in" "ay" $params(ay_scan_in_width) "false" 0
		set_port_property ay VHDL_TYPE STD_LOGIC_VECTOR	
	}
	if {$params(operand_source_may) eq "preadder"} {
		my_set_interface "in" "az" $params(az_width) "false" 0
		set_port_property az VHDL_TYPE STD_LOGIC_VECTOR	
	}
	
	if {$params(operation_mode) ne "m27x27" && !( $params(operation_mode) eq "m18x18_full" &&  $params(by_width) eq 0 )} {
		if {$params(by_use_scan_in) eq "false"} {	
			my_set_interface "in" "by" $params(by_width) "false" 0
			set_port_property by VHDL_TYPE STD_LOGIC_VECTOR	
		}
	}
	if {$params(operand_source_mby) eq "preadder" && $params(operation_mode) ne "m27x27"} {
		my_set_interface "in" "bz" $params(bz_width) "false" 0
		set_port_property bz VHDL_TYPE STD_LOGIC_VECTOR
	}
	if {$params(operand_source_max) eq "coef"} {
		my_set_interface "in" "coefsela" 3 "false" 0
	} else {
		my_set_interface "in" "ax" $params(ax_width) "false" 0
		set_port_property ax VHDL_TYPE STD_LOGIC_VECTOR	
	}
	if {$params(operand_source_mbx) eq "coef" && $params(operation_mode) ne "m27x27"} {
		my_set_interface "in" "coefselb" 3 "false" 0
	} else {
		if {$params(operation_mode) ne "m27x27" && !( $params(operation_mode) eq "m18x18_full" &&  $params(bx_width) eq 0 ) } {
			my_set_interface "in" "bx" $params(bx_width) "false" 0
			set_port_property bx VHDL_TYPE STD_LOGIC_VECTOR
		}
	}
	if {$params(use_chainadder) eq "true"} {
			my_set_interface "in" "chainin" 64 "false" 0
	}	
	
	#if { ($params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_full" ) } {
		#my_set_interface "in" "sub" 1 "false" 0
	
	#}
	
	#enable_sub check 
	if {$params(enable_sub) eq "true" } {
		my_set_interface  "in" "sub" 1 "false" 0
	}
	
	#enable_negate check
	if {$params(enable_negate) eq "true" } {
		my_set_interface "in" "negate" 1 "false" 0
	}
	
	#enbale_loadconst check
	if {$params(operation_mode) ne "m18x18_full" && $params(enable_loadconst) eq "true"} {
		my_set_interface "in" "loadconst" 1 "false" 0
	}
	
	#enable_accumulate check
	if {$params(enable_accumulate) eq "true"} {
		my_set_interface "in" "accumulate" 1 "false" 0
	#	set_port_property accumulate VHDL_TYPE STD_LOGIC_VECTOR	
	}
	
	# output ports
	my_set_interface "out" "resulta" $params(result_a_width) "false" 0
	set_port_property resulta VHDL_TYPE STD_LOGIC_VECTOR
		
	if {$params(operation_mode) eq "m18x18_full"  &&  $params(result_b_width) ne 0 } {
		my_set_interface "out" "resultb" $params(result_b_width) "false" 0
		set_port_property resultb VHDL_TYPE STD_LOGIC_VECTOR
	}
	if {$params(gui_scanout_enable) eq "true"} {
		my_set_interface "out" "scanout" $params(scan_out_width) "false" 0
		set_port_property scanout VHDL_TYPE STD_LOGIC_VECTOR
	}
	if {$params(gui_chainout_enable) eq "true"} {
			my_set_interface "out" "chainout" 64 "false" 0	
	}
	
	#+--------------------------------------------	
	#clk, ena, and aclr signals require additional handling (manually removed from port.csv)
	#+--------------------------------------------	
	# Check if any register is enable before add the reg control signals to the interface
	set is_one_or_more_regs_used [get_register_usage]

	# All registers shared the same clk, ena and aclr signal.
    	# At any time if one or more register is used, all the 3 reg control signals need to be set.
	if {$is_one_or_more_regs_used} {		
		my_set_interface "in" "clk" 3 "false" 0
		my_set_interface "in" "ena" 3 "false" 0
		my_set_interface "in" "aclr" 2 "false" 0
	}
}

#+--------------------------------------------------------------------
#|
#|  Name:       gen_terp
#|
#|  Purpose:    This procedure is called by do_quartus_synth and
#|              do_vhdl_sim. This procedure builds an array that terp
#|              can use to generate the IP variation file and then calls
#|              terp. Both VHDL and Verilog generation use the array.
#|
#|  Parameters: terp_path   -- path to the .terp file
#|              output_name -- name of the output file
#|
#|  Returns:    The contents returned from terp
#|
#+--------------------------------------------------------------------
proc gen_terp {terp_path output_name} {
    # Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }

    # Create the lists that hold all data for terp
	set all_ports 				[list]		;# store all interface ports
    set module_port_list        [list]      ;# port, direction, width, widthL
    set sub_wire_list           [list]      ;# name, width, widthL
    set wire_list               [list]      ;# dest, src, width, widthL
    set port_map_list           [list]      ;# port, connect, direction, width, widthL
    set ports_not_added_list    [list]      ;# port, connect
    set params_list             [list]      ;# name, str, value
    set inports                 [list]      ;# port, direction, width, widthL
    set outports                [list]      ;# port, direction, width, widthL
	set gui_param_to_be_excluded [list]     ;# param_name
	
	# Split all ports into a list of inports and outports
    foreach port [get_interface_ports] {
        set width   -1
        set widthL  -1
		
		# Ports with width > 1
		if { $port eq "ay" || $port eq "scanin" } {
			set width   $params(ay_scan_in_width)
			set widthL  0
		}
		if { $port eq "ax" } {
			set width   $params(ax_width)
			set widthL  0
		}
		if { $port eq "az" } {
            set width   $params(az_width)
			set widthL  0
		}
		if { $port eq "bx" } {
			set width   $params(bx_width)
			set widthL  0
		}
		if { $port eq "by" } {
			set width   $params(by_width)
			set widthL  0
		}
		if { $port eq "bz" } {        
			set width   $params(bz_width)
			set widthL  0
		}		
		if { $port eq "coefsela" || $port eq "coefselb" || $port eq "clk" || $port eq "ena"} {        
			set width   3
			set widthL  0
		}	
		if { $port eq "aclr"} {        
			set width   2
			set widthL  0
		}
		if { $port eq "chainin" || $port eq "chainout"} {  
			set width   64
			set widthL  0
		}
		if { $port eq "resulta" } {        
			set width   $params(result_a_width)
			set widthL  0
		}
		if { $port eq "resultb" } {        
			set width   $params(result_b_width)
			set widthL  0
			}
		if { $port eq "scanout" } {        
			set width   $params(scan_out_width)
			set widthL  0
		}

        
		# Add to the correct list	 
		if { [get_port_property $port DIRECTION] eq "Input" } {
			lappend inports $port "IN" $width $widthL
		} elseif { [get_port_property $port DIRECTION] eq "Output" } {
			lappend outports $port "OUT" $width $widthL
		}	
	}
	
    # Sort the inports and outports and make the module port list
    set inports             [sort_list_skip $inports  4]
    set outports            [sort_list_skip $outports 4]
    set module_port_list    [concat $inports $outports]


    # For each outport, there should be a sub wire of the same width
    set i 0
    foreach {port direction width widthL} $outports {

        lappend sub_wire_list "sub_wire$i" $width $widthL
        incr i
    }

    
    # Now connect the subwires to the outports in the same order
    set i 0
    foreach {port direction width widthL} $outports {

        lappend wire_list $port "sub_wire$i" $width $widthL
        incr i
    }

    # Add all of the inports to the port map list and remove them from all ports
    foreach {port direction width widthL} $inports {

        lappend port_map_list $port $port $direction $width $widthL

        set index [lsearch $all_ports $port]
        set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
    
    }


    # Add all of the outports to the port map list and remove them from all ports
    set i 0
    foreach {port direction width widthL} $outports {

        lappend port_map_list $port "sub_wire$i" $direction $width $widthL

        set index [lsearch $all_ports $port]
        set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
        incr i

    }

    # The all ports list is now all ports not used... make it the ports not added list
    set ports_not_added_list [sort_list_skip $all_ports 2]
	
	# Add GUI param that needs to be excluded from printing into the generated output file
	lappend gui_param_to_be_excluded "enable_sub"
	lappend gui_param_to_be_excluded "enable_negate"
	lappend gui_param_to_be_excluded "enable_accumulate"
	lappend gui_param_to_be_excluded "enable_loadconst"
	
	# Add all of the parameters and their value
    foreach param [get_parameters] {
		set exclude_gui_param "false"
		foreach this_gui_param $gui_param_to_be_excluded {
			if { $this_gui_param eq $param } {
				set exclude_gui_param "true"
			}
		}
		set gui_only_param [regexp "gui*" $param match]
        set all_width [regexp ".*_width" $param match]
		set type [get_parameter_property $param TYPE]
		set value [get_parameter_value $param]
		if {!$exclude_gui_param && !$gui_only_param && !($value eq 0 && $all_width )} {
            lappend params_list $param $type $value                
        }
    }
 
    # Create the terp array
    array set params_terp {}
    set params_terp(module_port_list)       $module_port_list
    set params_terp(sub_wire_list)          $sub_wire_list
    set params_terp(wire_list)              $wire_list
    set params_terp(port_map_list)          $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(params_list)            $params_list
    set params_terp(output_name)            $output_name
    set params_terp(ip_name)                "twentynm_mac"


    # Read in the terp data
    set terp_fd [open $terp_path]
    set terp_contents [read $terp_fd]
    close $terp_fd

    # Return the terp contents
    return [altera_terp $terp_contents params_terp]
}

#+--------------------------------------------------------------------
#|
#|  Name:       get_register_usage
#|
#|  Purpose:    This procedure will check the status of register usage
#|
#|
#|  Returns:    The true if one or more registers are enabled
#|
#+--------------------------------------------------------------------
proc get_register_usage {} {
	set result 0 ;#false
	foreach p [get_parameters] {
		# Get all the 'clock' parameters' value	
		if {[regexp -nocase "clock.*" $p]} { 
			set clock_params [get_parameter_value $p]
			# Check if any register is enabled
			if {$clock_params ne "none"} {		
				set result 1 ;#true
			}
		}
    }
	
	return $result
}