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


#+---------------------------------------------------------------------------------------
#|
#| Name: make_var_wrapper
#|
#| Purpose: get ip parameters from hw.tcl file and transfer to terp params
#|
#| Return: ip specific vhd and verilog parameters array to pass to terp file
#|
#+----------------------------------------------------------------------------------------

proc make_var_wrapper {params_ref} {

    upvar $params_ref   params

    #---------------------------------------------------------------------------------
    # loop through port_list
	# construct input_module_port_list and output_module_port_list separately, then add into module_port_list
	# module_port_list {{port direction width value} {port direction width value} ...}#
	# add all ports to port_map_list #
	# construct input_port_map_list and output_port_map_list separately, then add into port_map_list
	# port_map_list {name_l name_r direction width} #
	# all ports: "clock" "q" "shiftout" "enable" "shiftin" "data" "load" "sclr" "sset" "aclr" "aset"
	#---------------------------------------------------------------------------------
	set module_port_list [list]
	set input_module_port_list [list]
	set output_module_port_list [list]
	set port_map_list [list]
	set input_port_map_list [list]
	set output_port_map_list [list]
    set top_width [expr {$params(width)-1}]
	set counter 0

    foreach port $params(port_list) {
        if {$port eq "clock"} {
			lappend input_module_port_list [list $port "IN" -1 -1]
			lappend input_port_map_list [list $port $port "IN" -1]
		} elseif {$port eq "enable"} {
            lappend input_module_port_list [list $port "IN" -1 -1]
			lappend input_port_map_list [list $port $port "IN" -1]
		} elseif {$port eq "shiftin"} {
            lappend input_module_port_list [list $port "IN" -1 -1]
			lappend input_port_map_list [list $port $port "IN" -1]
		} elseif {$port eq "data"} {
            lappend input_module_port_list [list $port "IN" $top_width -1]
			lappend input_port_map_list [list $port $port "IN" $top_width]
		} elseif {$port eq "load"} {
            lappend input_module_port_list [list $port "IN" -1 -1]
			lappend input_port_map_list [list $port $port "IN" -1]
		} elseif {$port eq "sclr"} {
            lappend input_module_port_list [list $port "IN" -1 -1]
			lappend input_port_map_list [list $port $port "IN" -1]
		} elseif {$port eq "sset"} {
            lappend input_module_port_list [list $port "IN" -1 -1]
			lappend input_port_map_list [list $port $port "IN" -1]
		} elseif {$port eq "aclr"} {
            lappend input_module_port_list [list $port "IN" -1 -1]
			lappend input_port_map_list [list $port $port "IN" -1]
		} elseif {$port eq "aset"} {
            lappend input_module_port_list [list $port "IN" -1 -1]
			lappend input_port_map_list [list $port $port "IN" -1]
		} elseif {$port eq "q"} {
            lappend output_module_port_list [list $port "OUT" $top_width -1]
			lappend output_port_map_list [list $port sub_wire$counter "OUT" $top_width]
			incr counter
		} elseif {$port eq "shiftout"} {
            lappend output_module_port_list [list $port "OUT" -1 -1]
			lappend output_port_map_list [list $port sub_wire$counter "OUT" -1]
			incr counter
        }
    }
	# add input_module_port_list to module_port_list
	foreach {input_module_port} $input_module_port_list {
		lappend module_port_list $input_module_port
	}
	# add output_module_port_list to module_port_list
	foreach {output_module_port} $output_module_port_list {
		lappend module_port_list $output_module_port
	}
	# add input_port_map_list to port_map_list
	foreach {input_port_map} $input_port_map_list {
		foreach {name_l name_r direction width} $input_port_map {
			lappend port_map_list $name_l $name_r $direction $width
		}
	}
	# add output_port_map_list to port_map_list
	foreach {output_port_map} $output_port_map_list {
		foreach {name_l name_r direction width} $output_port_map {
			lappend port_map_list $name_l $name_r $direction $width
		}
	}

	#---------------------------------------------------------------------------------
    # add all output wire connection to sub_wire_list #
	# sub_wire_list {name width} #
	#---------------------------------------------------------------------------------
    set sub_wire_list [list ]
	set counter 0
	if {$params(use_data_output)} {
		lappend sub_wire_list sub_wire$counter $top_width
		incr counter
	}
	if {$params(use_serial_output)} {
		lappend sub_wire_list sub_wire$counter -1
		incr counter
	}

	#---------------------------------------------------------------------------------
    # add all output wire connection to wire_list #
	# wire_list {name_l name_r width} #
	#---------------------------------------------------------------------------------
	set wire_list [list]
	set counter 0
	if {$params(use_data_output)} {
		lappend wire_list "q"	sub_wire$counter  $top_width
		incr counter
	}
	if {$params(use_serial_output)} {
		lappend wire_list "shiftout"	sub_wire$counter  -1
		incr counter
	}

    #---------------------------------------------------------------------------------
    # get a list of all ports not added into ports_not_added_list #
	# ports_not_added_list {port connection} #
	#---------------------------------------------------------------------------------
	set ports_not_added_list    [list]
    set ports_list_all  [list "q" "shiftout" "enable" "shiftin" "data" "load" "sclr" "sset" "aclr" "aset"]
    set ports_not_added_list_temp [list]
    foreach port $params(port_list) {
        set used_port_set($port)  1
    }
    foreach port $ports_list_all {
        if {![info exists used_port_set($port)]}    {
            lappend ports_not_added_list_temp  $port
        }
    }
    set ports_not_added_list_temp     [lsort -ascii $ports_not_added_list_temp]
    set connection ""
    foreach port $ports_not_added_list_temp {
        lappend ports_not_added_list $port $connection
    }

    #---------------------------------------------------------------------------------
    # add all params value to params_list #
	# params_list {name str value} #
	#---------------------------------------------------------------------------------
    set params_list [list]
	lappend	params_list			[list "lpm_type"		"STRING"	"\"LPM_SHIFTREG\""]
	lappend	params_list			[list "lpm_width"		"NATURAL"	"$params(width)"]
	if {$params(shift_direction) == "Right"} {
		lappend	params_list		[list "lpm_direction"		"STRING"	"\"RIGHT\""]
	} else {
		lappend	params_list		[list "lpm_direction"		"STRING"	"\"LEFT\""]
	}
	if {$params(use_sset_input)} {
		lappend	params_list		[list "lpm_svalue"			"STRING"	"\"$params(sset_value)\""]
	}
	if {$params(use_aset_input)} {
		lappend	params_list		[list "lpm_avalue"			"STRING"	"\"$params(aset_value)\""]
	}
	# sort $params_list by name and store into $params_list
	set params_list     [lsort -ascii -index 0 $params_list]

    #---------------------------------------------------------------------------------
    # add all terp params to array params_terp #
	#---------------------------------------------------------------------------------
    set params_terp(module_port_list)			$module_port_list
    set params_terp(sub_wire_list)				$sub_wire_list
    set params_terp(wire_list)					$wire_list
    set params_terp(port_map_list)				$port_map_list
    set params_terp(ports_not_added_list)		$ports_not_added_list
    set params_terp(params_list)				$params_list
    set params_terp(ip_name)					"lpm_shiftreg"

    return [array get params_terp]
}


