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

proc make_var_wrapper_tb {params_ref} {

    upvar $params_ref   params

    #---------------------------------------------------------------------------------
    # loop through port_list and add to list module_port_list #
	# module_port_list {{port direction width value} {port direction width value} ...}#
	# add all ports to port_map_list #
	# port_map_list {name_l name_r direction width} #
	#---------------------------------------------------------------------------------
	set module_port_list [list]
	set port_map_list [list]
        set top_width [expr {$params(width)-1}]
	set all_taps_top_width [expr {$params(number_of_taps)*$params(width)-1}]
        set ports_1  {"clken" "aclr"}
	set single_tap 1
	set taps_added_once 0

    foreach port $params(port_list) {
        if {$port eq "clock"} {
			lappend module_port_list $port "IN" -1 -1
			lappend module_input_port_list $port "IN" -1 -1
			lappend module_input_port_only_list $port
			lappend port_map_list $port $port
            lappend port_map_input_list $port $port
		} elseif {$port eq "shiftin"} {
            lappend module_port_list $port "IN" $top_width -1
            lappend module_input_port_list $port "IN" $top_width -1
			lappend module_input_port_only_list $port
			lappend port_map_list $port $port
            lappend port_map_input_list $port $port
		} elseif {$port eq "aclr"} {
            lappend module_port_list $port "IN" -1 -1
            lappend module_input_port_list $port "IN" -1  -1
			lappend module_input_port_only_list $port
			lappend port_map_list $port $port
            lappend port_map_input_list $port $port
		} elseif {$port eq "clken"} {
            lappend module_port_list $port "IN" -1  -1
            lappend module_input_port_list $port "IN" -1  -1
			lappend module_input_port_only_list $port
			lappend port_map_list $port $port
            lappend port_map_input_list $port $port
		} elseif {$port eq "shiftout"} {
            lappend module_port_list $port "OUT" $top_width -1
            lappend module_output_port_list $port "OUT" $top_width -1
			lappend port_map_list $port "shiftout"
            lappend port_map_output_list $port $port
        } elseif {$port eq "taps"} {
			set single_tap 1
            lappend module_port_list $port "OUT" $all_taps_top_width -1
            lappend module_output_port_list $port "OUT" $all_taps_top_width -1
			lappend port_map_list $port "taps"
            lappend port_map_output_list $port $port
		# } elseif { [regexp -- {^taps[0-9]+x$} $port] } {
		# 	set single_tap 0
		# 	lappend module_port_list $port "OUT" $top_width -1
		# 	lappend module_output_port_list $port "OUT" $top_width -1
		# 	if {!$taps_added_once} {
		# 		#for port_map_list, only 1 'taps' added
		# 		lappend port_map_list "taps" "sub_wire1" "OUT" $all_taps_top_width
		# 		set taps_added_once 1
		# 	}
        }
    }
	# sort $module_port_list by name and store into $module_port_list
	# set module_port_list     [lsort -ascii -index 0 $module_port_list]

	#---------------------------------------------------------------------------------
    # add aclr and clken to tri_port_list #
	# tri_port_list {num port width} #
	#---------------------------------------------------------------------------------
	set tri_port_list [list]
	set range_list_1 {"aclr" "clken"}
	foreach port $params(port_list) {
		if {[lsearch $range_list_1 $port]>=0} {
			lappend tri_port_list 1 $port -1
		}
	}

	#---------------------------------------------------------------------------------
    # add all output wire connection to sub_wire_list_verilog for Verilog #
	# sub_wire_list_verilog {name width} #
	#---------------------------------------------------------------------------------
    set sub_wire_list_verilog [list ]
	lappend sub_wire_list_verilog "sub_wire0" $top_width
	lappend sub_wire_list_verilog "sub_wire1" $all_taps_top_width
	
	#---------------------------------------------------------------------------------
    # add all output wire connection to sub_wire_list_vhdl for VHDL #
	# sub_wire_list_vhdl {{name width_H width_L} {name width_H width_L} ... }#
	#---------------------------------------------------------------------------------
    set sub_wire_list_vhdl [list ]
	lappend sub_wire_list_vhdl [list sub_wire0 $top_width 0]
	lappend sub_wire_list_vhdl [list sub_wire1 $all_taps_top_width 0]
	# more sub_wire_list_vhdl at below code

	#---------------------------------------------------------------------------------
    # add all output wire connection to wire_list #
	# wire_list {name_l width_l_H width_l_L name_r width_r_H width_r_L} #
	# NOTE: wire connection for group taps is complicated and unnecessary
	# NOTE: can be simplified in future, direct connect top level module ports to altshift_taps ports
	# NOTE: for now, matching previous QT implementation for benchmarking purpose
	#---------------------------------------------------------------------------------
	set wire_list [list]
	lappend wire_list "shiftout"	$top_width 	0  	"sub_wire0"  $top_width 	0
	if {$single_tap} {
		# no group taps, or group taps but width=1
		lappend wire_list "taps"	$all_taps_top_width	0  "sub_wire1"  $all_taps_top_width	0
	} else {
		# group taps

		##########################################
		# set the constant number of start_subwire,
		# which is = number of output ports (shiftout and taps)
		set start_subwire 2
		##########################################

		# first tap and last tap uses the original subwire, while intermediate taps use additional subwires
		# so, total number of subwires needed for each tap, is (number of taps-2)+number of taps
		set end_subwire [expr {$params(number_of_taps)-2+$params(number_of_taps)+$start_subwire-1}]

		#####################
		# sub_wires section and taps section #
		# handle taps section first, but append at the end of wire_list
		# first to create tapsname_list, consists of taps0x, taps1x, taps2x ...
		set tapsname_list [list]
		foreach port $params(port_list) {
			if { [regexp -- {^taps[0-9]+x$} $port] } {
				lappend tapsname_list $port
			}
		}
		# ascii sort tapsname_list
		# taps0x, taps10x, taps11x, taps12x ...
		# set tapsname_list     [lsort -ascii -index 0 $tapsname_list]
		# loop tapsname_list, create taps_list
		# at the same time, create connecting sub_wires
		# wire_list {name_l width_l_H width_l_L name_r width_r_H width_r_L} #
		# taps_list format is same as wire_list, append to wire_list later
		# connect_wires_list format is same as wire list, append to wire_list later
		set taps_list [list]
		set connect_wires_list [list]
		set counter 0
		set start_tap 0
		set end_tap [expr {$params(number_of_taps)-1}]
		foreach tapname $tapsname_list {
			# $tapname=taps0x -> $index=0x
			regsub -all {^taps} $tapname "" index
			# $index=0x -> $index=0
			regsub -all {x} $index "" index
			if {$index==$start_tap} {
				# start tap, index=0
				set wire_name_r sub_wire$start_subwire
				set wire_range_r_H $top_width
				set wire_range_r_L 0
				# create taps wire
				lappend taps_list [list $tapname $top_width 0 $wire_name_r $wire_range_r_H $wire_range_r_L]
				set k [expr $start_subwire-1]
				set sub_wire_name_r sub_wire$k
				# only create 1 layer of sub_wire, for start tap
				lappend connect_wires_list [list $wire_name_r $wire_range_r_H $wire_range_r_L $sub_wire_name_r $wire_range_r_H $wire_range_r_L]
				lappend sub_wire_list_vhdl [list $wire_name_r $wire_range_r_H $wire_range_r_L]
			} else {
				incr counter
				# i 3, 5, 7, 9 ...
				set i [expr {($counter*2)+$start_subwire-1}]
				set wire_name_r sub_wire$i
				set wire_range_r_L [expr {$index*($top_width+1)}]
				set wire_range_r_H [expr $wire_range_r_L+$top_width]
				# create taps wire
				# eg. wire [87:0] taps10x = sub_wire3[967:880];
				lappend taps_list [list $tapname $top_width 0 $wire_name_r $wire_range_r_H $wire_range_r_L]
				set j [expr $i+1]
				set sub_wire_name_r sub_wire$j
				set k [expr $start_subwire-1]
				set fixed_sub_wire_name sub_wire$k
				if {$counter!=$end_tap} {
					# Not last tap
					# create 1st layer of sub_wire
					# eg. wire [967:880] sub_wire3 = sub_wire4[967:880];
					lappend connect_wires_list [list $wire_name_r $wire_range_r_H $wire_range_r_L $sub_wire_name_r $wire_range_r_H $wire_range_r_L]
					lappend sub_wire_list_vhdl [list $wire_name_r $wire_range_r_H $wire_range_r_L]
					# create 2nd layer of sub_wire
					# eg. wire [967:880] sub_wire4 = sub_wire1[967:880];
					lappend connect_wires_list [list $sub_wire_name_r $wire_range_r_H $wire_range_r_L $fixed_sub_wire_name $wire_range_r_H $wire_range_r_L]
					lappend sub_wire_list_vhdl [list $sub_wire_name_r $wire_range_r_H $wire_range_r_L]
				} else {
					# last tap
					# only create 1 layer of sub_wire, for last tap
					# eg. wire [879:792] sub_wire33 = sub_wire1[879:792];
					lappend connect_wires_list [list $wire_name_r $wire_range_r_H $wire_range_r_L $fixed_sub_wire_name $wire_range_r_H $wire_range_r_L]
					lappend sub_wire_list_vhdl [list $wire_name_r $wire_range_r_H $wire_range_r_L]
				}
			}
		}

		#sort connect_wires_list, loop it and append to wire_list
		set connect_wires_list     [lsort -dictionary -decreasing -index 0 $connect_wires_list]
		foreach {sub_connect_wires_list} $connect_wires_list {
			foreach {name_l width_l_H width_l_L name_r width_r_H width_r_L} $sub_connect_wires_list {
				lappend wire_list $name_l $width_l_H $width_l_L $name_r $width_r_H $width_r_L
			}
		}
		#loop taps_list and append to wire_list
		foreach {sub_taps_list} $taps_list {
			foreach {name_l width_l_H width_l_L name_r width_r_H width_r_L} $sub_taps_list {
				lappend wire_list $name_l $width_l_H $width_l_L $name_r $width_r_H $width_r_L
			}
		}
	}
	# sort $sub_wire_list_vhdl by name and store into $sub_wire_list_vhdl
	set sub_wire_list_vhdl     [lsort -dictionary -index 0 $sub_wire_list_vhdl]

    #---------------------------------------------------------------------------------
    # get a list of all ports not added into ports_not_added_list #
	# ports_not_added_list {port connection} #
	#---------------------------------------------------------------------------------
	set ports_not_added_list    [list]
    set ports_list_all  [list "aclr" "clken"]
    set ports_not_added_list_temp [list]
    foreach port $params(port_list) {
        set used_port_set($port)  1
    }
    foreach port $ports_list_all {
        if {![info exists used_port_set($port)]}    {
            lappend ports_not_added_list_temp  $port
        }
    }
    # set ports_not_added_list_temp     [lsort -ascii $ports_not_added_list_temp]
    set connection ""
    foreach port $ports_not_added_list_temp {
        lappend ports_not_added_list $port $connection
    }

    #---------------------------------------------------------------------------------
    # add all params value to params_list #
	# params_list {name str value} #
	#---------------------------------------------------------------------------------
    set params_list [list]
	lappend	params_list	"number_of_taps"			"$params(number_of_taps)"
	lappend	params_list	"tap_distance"				"$params(tap_distance)"
	lappend	params_list	"width"						"$params(width)"

    #---------------------------------------------------------------------------------
    # add all terp params to array params_terp #
	#---------------------------------------------------------------------------------
    
    set params_terp_tb(module_port_list)			    $module_port_list
    set params_terp_tb(module_input_port_list)		    $module_input_port_list
    set params_terp_tb(module_input_port_only_list)		$module_input_port_only_list
    set params_terp_tb(module_output_port_list)		    $module_output_port_list
    set params_terp_tb(port_map_input_list)			    $port_map_input_list
    set params_terp_tb(port_map_output_list)		    $port_map_output_list
	set params_terp_tb(tri_port_list)				    $tri_port_list
    set params_terp_tb(sub_wire_list_verilog)		    $sub_wire_list_verilog
	set params_terp_tb(sub_wire_list_vhdl)			    $sub_wire_list_vhdl
    set params_terp_tb(wire_list)					    $wire_list
    set params_terp_tb(port_map_list)				    $port_map_list
    set params_terp_tb(ports_not_added_list)		    $ports_not_added_list
    set params_terp_tb(params_list)				        $params_list
    set params_terp_tb(ip_name)					        "altshift_taps"
    return [array get params_terp_tb]
}


