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
    # get params from params_arr #
    set port_list   [lsort $params(port_list)]
	set bit_width $params(bit_width)	       
	set cycles $params(cycles)            
	set async_clear_input $params(async_clear_input)	
	set clk_enable_input $params(clk_enable_input)
	set pipeline $params(pipeline)
	set q_width $params(q_width)
	set remainder_width $params(remainder_width)
	
	for {set i 0} {$i < [llength $port_list]} {incr i} {
		if {[lindex $port_list $i] eq "radical"} {
			set port_list [lreplace $port_list $i $i "q"]
		} elseif {[lindex $port_list $i] eq "q"} {
			set port_list [lreplace $port_list $i $i "radical"]
		}
	}
	
	#---------------------------------------------------------------------------------
    # loop through port_list and add to list module_port_list #
	#---------------------------------------------------------------------------------
    set module_port_list [list ]
	set special_ports [list]
    set width [expr {$bit_width-1}]
	set q_width [expr {$q_width-1}]
	set remainder_width [expr {$remainder_width-1}]


    foreach port $port_list {
		switch -exact $port {
			"radical" { 
				lappend module_port_list [list $port "IN" $width -1] 
			}
			"q" {lappend module_port_list [list $port "OUT" $q_width -1]}
			"remainder" {lappend module_port_list [list $port "OUT" $remainder_width -1]}
			"clk" { lappend module_port_list [list "clk" "IN" -1 -1] }
			"ena" { lappend module_port_list [list "ena" "IN" -1 -1] }
			"aclr" { lappend module_port_list [list $port "IN" -1 -1] }
		}
    }

    #---------------------------------------------------------------------------------
    # add all output wire connection to sub_wire_list #
	# sub_wire_list {name width} #
	#---------------------------------------------------------------------------------
    set sub_wire_list [list ]
	set wire_list [list]
	set counter 0


	lappend sub_wire_list sub_wire$counter $q_width
	lappend wire_list "q"	sub_wire$counter  $q_width
	incr counter

	lappend sub_wire_list sub_wire$counter $remainder_width
	lappend wire_list "remainder"	sub_wire$counter  $remainder_width
	incr counter
	
	#---------------------------------------------------------------------------------
    # add all added ports to port_map_list #
	#---------------------------------------------------------------------------------
    set port_map_list [list ]
	set counter 0
	set isset_special_port 0
    foreach port $port_list {
		switch -exact $port {
			"radical" { 
				lappend port_map_list $port $port "IN" $width
			}
			"q" { 
				lappend port_map_list $port  sub_wire$counter "OUT" $q_width
				incr counter
			}
			"remainder" {
				lappend port_map_list $port sub_wire$counter "OUT" $remainder_width
				incr counter
			}
			"clk" { lappend port_map_list "clk" "clk" "IN" -1 }
			"ena" {lappend port_map_list "ena" "ena" "IN" -1 }
			"aclr" { lappend port_map_list $port $port "IN" -1 }
		}
    }
	

    #---------------------------------------------------------------------------------
    # get a list of all ports not added #
	#---------------------------------------------------------------------------------
    set ports_list_all  [list "radical" "q" "remainder" "clk" "ena" "aclr"]
    set ports_not_added_list_temp [list ]
    foreach port $port_list {
        set used_port_set($port)  1
    }
    foreach port $ports_list_all {
        if {![info exists used_port_set($port)]}    {
		    lappend ports_not_added_list_temp  $port
        }
    }
    set ports_not_added_list_temp     [lsort -ascii $ports_not_added_list_temp]
    set ports_not_added_list    [list ]
    set connection ""
    foreach port $ports_not_added_list_temp {
        lappend ports_not_added_list $port $connection
    }
    #---------------------------------------------------------------------------------
    # add all params value to params_list #
	#---------------------------------------------------------------------------------
    set params_list [list]
    if {$pipeline eq "Yes I want an output latency (set the latency cycles below)"} {
        lappend params_list [list "pipeline" "NATURAL" "$cycles"]
    } else {
		lappend params_list [list "pipeline" "NATURAL" 0]
	}
	
	lappend params_list  [list "q_port_width" "NATURAL" [expr {$q_width + 1}]]
	lappend params_list  [list "r_port_width" "NATURAL" [expr {$remainder_width + 1}]]
    lappend params_list  [list "width" "NATURAL" [expr {$width + 1}]]
	 

    #---------------------------------------------------------------------------------------
    # add all terp params to array params_terp #
    set params_terp(module_port_list)   $module_port_list
    set params_terp(sub_wire_list)      $sub_wire_list
    set params_terp(wire_list)          $wire_list
    set params_terp(port_map_list)      $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(params_list)        $params_list
    set params_terp(ip_name)            "altsqrt"

    return [array get params_terp]
}


