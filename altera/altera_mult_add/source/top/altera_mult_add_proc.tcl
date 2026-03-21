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


# (C) 2002-2010 Altera Corporation. All rights reserved.
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
# | $Header: //acds/rel/18.1std/ip/altera_mult_add/source/top/altera_mult_add_proc.tcl#1 $
# | 
# +-----------------------------------
package require -exact qsys 14.0
package require altera_terp

# +-----------------------------------
# | 
# | This function checks on clocks or aclr usage
# | Return true if the clock or aclr signal is used
# +-----------------------------------
proc is_use_dedicated_clock_or_aclr {if_reg_use reg_signal signal_type} {
	
	set get_if_reg_use [get_parameter_value $if_reg_use]
	set get_reg_signal [get_parameter_value $reg_signal]
	
	if {$get_if_reg_use == 1 || $get_if_reg_use eq "true" || $get_if_reg_use eq "CLOCK0" || $get_if_reg_use eq "CLOCK1" || $get_if_reg_use eq "CLOCK2" || $get_if_reg_use eq "CLOCK3" || $get_if_reg_use eq "ACLR0" || $get_if_reg_use eq "ACLR1" || $get_if_reg_use eq "ACLR2" || $get_if_reg_use eq "ACLR3"} {
		set result [expr {($get_reg_signal == $signal_type)? "true" : "false"}]
	} else {
		set result "false"
	}

	return $result
}


#Added by sukumar-SCLR SUPPORT
proc is_use_dedicated_clock_or_sclr {if_reg_use reg_signal signal_type} {
	
	set get_if_reg_use [get_parameter_value $if_reg_use]
	set get_reg_signal [get_parameter_value $reg_signal]
	
	if {$get_if_reg_use == 1 || $get_if_reg_use eq "true" || $get_if_reg_use eq "CLOCK0" || $get_if_reg_use eq "CLOCK1" || $get_if_reg_use eq "CLOCK2" || $get_if_reg_use eq "CLOCK3" || $get_if_reg_use eq "SCLR0" || $get_if_reg_use eq "SCLR1" || $get_if_reg_use eq "SCLR2" || $get_if_reg_use eq "SCLR3"} {
		set result [expr {($get_reg_signal == $signal_type)? "true" : "false"}]
	} else {
		set result "false"
	}

	return $result
}


# +----------------------------------------------
# | 
# | Function to add port interface
# | 	port_type (range): "in", "out", "clock"
# |		port_name: "<string>"
# | 	port_width : <integer>
# | 	terminate_flag : "true", "false"
# | 	termination_value : <integer>
# | 
# +----------------------------------------------
proc my_add_interface_port {port_type port_name port_width terminate_flag termination_value} {
	
	if {$port_type eq "in" || $port_type eq "clk"} {
		add_interface $port_name conduit input
		add_interface_port $port_name $port_name $port_name Input $port_width
	} elseif {$port_type eq "out"} {
		add_interface $port_name conduit output
		set_interface_assignment $port_name "ui.blockdiagram.direction" OUTPUT
		add_interface_port $port_name $port_name $port_name Output $port_width
#	} elseif {$port_type eq "clk"} {
#		add_interface $port_name clock end
#		add_interface_port $port_name $port_name clk Input $port_width
	} else {
		send_message error "Illegal port type"
	}
	
	if {$terminate_flag eq "true"} {
		set_port_property $port_name TERMINATION true
		set_port_property $port_name TERMINATION_VALUE $termination_value
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
    set input_merge_wire_list   [dict create]      ;# dest, src, dest_width, dest_widthL, src_width, src_widthL
    set port_map_list           [list]      ;# port, connect, direction, width, widthL
    set ports_not_added_list    [list]      ;# port, connect
    set params_list             [list]      ;# name, str, value
    set inports                 [list]      ;# port, direction, width, widthL
    set outports                [list]      ;# port, direction, width, widthL
    
	# Create a list of all ports and their default connection           
	set all_ports {		
		"accum_sload"				"1'b0"
        "aclr0"						"1'b0"
		"aclr1"						"1'b0"
        "aclr2"						"1'b0"
        "aclr3"						"1'b0"
		"sclr0"						"1'b0"
		"sclr1"						"1'b0"
		"sclr2"						"1'b0"
		"sclr3"						"1'b0"
        "addnsub1"					"1'b1"
        "addnsub1_round"			"1'b0"
        "addnsub3"					"1'b1"
		"addnsub3_round"			"1'b0"
        "chainin"					"1'b0"
        "chainout_round"			"1'b0"
        "chainout_saturate"			"1'b0"
        "clock0"					"1'b1"
        "clock1"					"1'b1"
        "clock2"					"1'b1"
        "clock3"					"1'b1"
        "coefsel0"					"\{3\{1\'b0\}\}"
        "coefsel1"					"\{3\{1\'b0\}\}"
        "coefsel2"					"\{3\{1\'b0\}\}"
        "coefsel3"					"\{3\{1\'b0\}\}"
        "ena0"						"1'b1"
        "ena1"						"1'b1"
        "ena2"						"1'b1"
        "ena3"						"1'b1"
        "mult01_round"				"1'b0"
        "mult01_saturation"			"1'b0"
        "mult23_round"				"1'b0"
        "mult23_saturation"			"1'b0"
        "negate"					"1'b0"
        "output_round"				"1'b0"
        "output_saturate"			"1'b0"
        "rotate"					"1'b0"
        "shift_right"				"1'b0"
        "signa"						"1'b0"
        "signb"						"1'b0"
        "sload_accum"				"1'b0"
        "zero_chainout"				"1'b0"
        "zero_loopback"				"1'b0"
        "chainout_sat_overflow"		""
        "mult0_is_saturated"		""
        "mult1_is_saturated"		""
        "mult2_is_saturated"		""
        "mult3_is_saturated"		""
		"overflow"					""
        "result"					""
        "scanouta"					""
        "scanoutb"					""
	}
	lappend all_ports  "dataa"		"\{[expr {$params(width_a)*$params(number_of_multipliers)}]\{1\'b0\}\}"
	lappend all_ports  "datab"		"\{[expr {$params(width_b)*$params(number_of_multipliers)}]\{1\'b0\}\}"
	lappend all_ports  "datac" 		"\{[expr {$params(width_c)*$params(number_of_multipliers)}]\{1\'b0\}\}"
	lappend all_ports  "scanina"	"\{$params(width_a)\{1\'b0\}\}"
 	lappend all_ports  "scaninb"	"\{$params(width_b)\{1\'b0\}\}" 
 	lappend all_ports  "sourcea"	"\{$params(number_of_multipliers)\{1\'b0\}\}"
  	lappend all_ports  "sourceb"	"\{$params(number_of_multipliers)\{1\'b0\}\}"
		
	# Split all ports into a list of inports and outports
    foreach port [get_interface_ports] {
        set width   -1
        set widthL  -1
		
			# Ports with a width
			if { $port eq "sourcea" || $port eq "sourceb" } {
				set width   $params(number_of_multipliers)
				set widthL  0
			}
			if { $port eq "scanoutb" } {
				set width   $params(width_b)
				set widthL  0
			}
			if { $port eq "result" } {
				set width   $params(width_result)
				set widthL  0
			}
			if { $port eq "scanina" || $port eq "scanouta" } {
				set width   $params(width_a)
				set widthL  0
			}
			if { $port eq "coefsel0" || $port eq "coefsel1" || $port eq "coefsel2" || $port eq "coefsel3"} {
				set width   3
				set widthL  0
			}
			if { $port eq "chainin" } {        
				set width   $params(width_result)
				set widthL  0
			}		
			
            # Data input for UI entries
			if { $port eq "dataa_0" || $port eq "dataa_1" || $port eq "dataa_2" || $port eq "dataa_3" } {
				set width  $params(width_a)
				set widthL 0
			}
			if { $port eq "datab_0" || $port eq "datab_1" || $port eq "datab_2" || $port eq "datab_3" } {
				set width  $params(width_b)
				set widthL 0
			}
			if { $port eq "datac_0" || $port eq "datac_1" || $port eq "datac_2" || $port eq "datac_3" } {
				set width  $params(width_c)
				set widthL 0
			}
            
            # Data input for test entries
			if { $port eq "dataa" } {
				set width  [expr {$params(width_a) * $params(number_of_multipliers)}]
				set widthL 0
			}
			if { $port eq "datab"} {
				set width  [expr {$params(width_b) * $params(number_of_multipliers)}]
				set widthL 0
			}
			if { $port eq "datac" } {
				set width  [expr {$params(width_c) * $params(number_of_multipliers)}]
				set widthL 0
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
        if {![check_merge_input $port]} {
            lappend port_map_list $port $port $direction $width $widthL
    
            
        } else {
            # extract base name
            set port [regsub {_.*} $port ""]
            
            # Record the first one is enough
            if {![dict exist $input_merge_wire_list $port]} {
                dict set input_merge_wire_list $port base_port $port
                dict set input_merge_wire_list $port base_port_wire "wire_$port"
                dict set input_merge_wire_list $port width $width
                dict set input_merge_wire_list $port direction $direction
                dict set input_merge_wire_list $port count $params(number_of_multipliers)
            }
        }
        
        set index [lsearch $all_ports $port]
        if {$index != -1} {
            set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
        }
    }
    
    # Peform input that require merge for map list. Case:258228
    dict for {base_port info} $input_merge_wire_list {
        set widthL 0
        
        dict with info {
            set base_port_wire $base_port_wire
            set direction $direction
            set width $width
        }
        
        lappend port_map_list $base_port $base_port_wire $direction $width $widthL
    
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

	
	# Add all of the parameters and their value
    foreach param [get_parameters] {
		set gui_only_param [regexp "gui*" $param match]
		set type [get_parameter_property $param TYPE]
		set value [get_parameter_value $param]
		if {!$gui_only_param && $param ne "reg_autovec_sim"} {
			lappend params_list $param $type $value
		}
	}
 
    # Create the terp array
    array set params_terp {}
    set params_terp(module_port_list)       $module_port_list
    set params_terp(sub_wire_list)          $sub_wire_list
    set params_terp(wire_list)              $wire_list
    set params_terp(input_merge_wire_list)        $input_merge_wire_list
    set params_terp(port_map_list)          $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(params_list)            $params_list
    set params_terp(output_name)            $output_name
    set params_terp(ip_name)                "altera_mult_add"


    # Read in the terp data
    set terp_fd [open $terp_path]
    set terp_contents [read $terp_fd]
    close $terp_fd

    # Return the terp contents
    return [altera_terp $terp_contents params_terp]
}

#+--------------------------------------------------------------------
#|
#|  Name:       sort_list_skip
#|
#|  Purpose:    Sorts a give list using the tcl command [lsort -ascii]
#|              but skips over a given number of elements.
#|
#|  Parameters: lst  -- the list to sort
#|              skip -- the number of elements to skip over
#|
#|  Returns:    The newly sorted list
#|
#+--------------------------------------------------------------------
proc sort_list_skip {lst skip} {

    # The list that will be sorted
    set sorted [list]

    # Go through and grab all of the elements to sort by
    set size [llength $lst]
    for {set i 0} {$i < $size} {incr i $skip} {
        lappend sorted [lindex $lst $i]
    }

    # Sort the list only containing the elements to sort by
    set sorted [lsort -ascii $sorted]

    # Now inject the info that was skipped over in the order of the sorted list
    for {set i 0} {$i < $size} {incr i $skip} {
        set name    [lindex $sorted $i]
        set index   [lsearch $lst $name]

        for {set j 1} {$j < $skip} {incr j} {
            set sorted [linsert $sorted [expr {$i+$j}] [lindex $lst [expr {$index+$j}]]]
        }
    }

    # Return the sorted list
    return $sorted
}

#+--------------------------------------------------------------------
#|
#|  Name:       check_merge_input
#|
#|  Purpose:    Check the name to see it is the input port that require to be merged
#|
#|  Parameters: port  -- Name of the input port
#|
#|  Returns:    1 if is port that require merging
#|
#+--------------------------------------------------------------------
proc check_merge_input {port} {
    set fragment_port_list [expr {$port eq "dataa_0" || $port eq "dataa_1" || $port eq "dataa_2" || $port eq "dataa_3" || 
			$port eq "datab_0" || $port eq "datab_1" || $port eq "datab_2" || $port eq "datab_3" ||
			$port eq "datac_0" || $port eq "datac_1" || $port eq "datac_2" || $port eq "datac_3" }]
            
    return $fragment_port_list
}