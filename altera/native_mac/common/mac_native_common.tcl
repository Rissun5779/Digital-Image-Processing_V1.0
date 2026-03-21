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
package require altera_terp

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
proc my_set_interface {port_type port_name port_width terminate_flag termination_value} {
	
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