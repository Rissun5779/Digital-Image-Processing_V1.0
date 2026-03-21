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
    set port_list   $params(port_list)
	set width $params(width)				
	set shift_direction $params(shift_direction)	
	set operating_mode $params(operating_mode)	
	set distance $params(distance)	    
	set bit_width $params(bit_width)	
	set overflow $params(overflow)        
	set underflow $params(underflow)        
	set cycles $params(cycles)            
	set async_clear_input $params(async_clear_input)	
	set clock_enable_input $params(clock_enable_input)
	set pipeline $params(pipeline)
	
	#---------------------------------------------------------------------------------
    # loop through port_list and add to list module_port_list #
	#---------------------------------------------------------------------------------
    set module_port_list [list ]
	set special_ports [list "direction"]
    set width [expr {$width-1}]
	set bit_width [expr {$bit_width-1}]

    foreach port $port_list {
		switch -exact $port {
			"data" { 
				lappend module_port_list [list $port "IN" $width -1] 
			}
			"direction" {lappend module_port_list [list $port "IN" -1 -1]}
			"distance" { 
			   lappend module_port_list [list $port "IN" $bit_width -1]
			}
			"clock" -
			"clken" -
			"aclr" { lappend module_port_list [list $port "IN" -1 -1] }
			"result" { lappend module_port_list [list $port "OUT" $width -1] }
			"overflow" - 
			"underflow" { lappend module_port_list [list $port "OUT" -1 -1] }
		}
    }

    #---------------------------------------------------------------------------------
    # add all output wire connection to sub_wire_list #
	# sub_wire_list {name width} #
	#---------------------------------------------------------------------------------
    set sub_wire_list [list ]
	set wire_list [list]
	set counter 0
	if {![string equal $operating_mode "Create a \'direction\' input to allow me to do both (0 shifts left and 1 shifts right)"]} {
		#lappend sub_wire_list sub_wire$counter -1
		if {[string equal $operating_mode "Always shift left"]} {
			lappend wire_list sub_wire$counter "1'h0"  -1
		} elseif {[string equal $operating_mode "Always shift right"]} {
			lappend wire_list sub_wire$counter "1'h1"  -1
		}
		incr counter
	}
	if {$overflow} {
		lappend sub_wire_list sub_wire$counter -1
		lappend wire_list "overflow"	sub_wire$counter  -1
		incr counter
	}
	lappend sub_wire_list sub_wire$counter $width
	lappend wire_list "result"	sub_wire$counter  $width
	incr counter
	if {$underflow} {
		lappend sub_wire_list sub_wire$counter -1
		lappend wire_list "underflow"	sub_wire$counter  -1
		incr counter
	}
	
	#---------------------------------------------------------------------------------
    # add all added ports to port_map_list #
	#---------------------------------------------------------------------------------
    set port_map_list [list ]
	set counter 0
	set isset_special_port 0
    foreach port $port_list {
		switch -exact $port {
			"data" { 
				lappend port_map_list $port $port "IN" $width 
				if {$isset_special_port == 0 } { 
					foreach port $special_ports {
						switch -exact $port {
							"direction" {
								if {[string equal $operating_mode "Create a \'direction\' input to allow me to do both (0 shifts left and 1 shifts right)"]} {
									lappend port_map_list $port $port "IN" -1 
								} else {
									lappend port_map_list $port sub_wire$counter "IN" -1
									incr counter
								}
							}
						}
					}
					set isset_special_port 1
				}
			}
			"distance" { 
				lappend port_map_list $port $port "IN" $bit_width 
			} 
			"clock" -
			"clken" -
			"aclr" { lappend port_map_list $port $port "IN" -1 }
			
			"result" { 
				lappend port_map_list $port sub_wire$counter "OUT" $width
				incr counter
			}
			"overflow" - "underflow" { 
				lappend port_map_list $port sub_wire$counter "OUT" -1
				incr counter
			}
		}
    }
	

    #---------------------------------------------------------------------------------
    # get a list of all ports not added #
	#---------------------------------------------------------------------------------
    set ports_list_all  [list "data" "distance" "direction" "clock" "clken" "aclr" "result" "overflow" "underflow"]
    set ports_not_added_list_temp [list ]
    foreach port $port_list {
        set used_port_set($port)  1
    }
    foreach port $ports_list_all {
        if {![info exists used_port_set($port)]}    {
		    if {[lsearch $special_ports $port] == -1} {
				 lappend ports_not_added_list_temp  $port
			}
           
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
        lappend params_list [list "lpm_pipeline" "NATURAL" "$cycles"]
    }
	set direction [lindex [split $shift_direction] 0]
	lappend params_list [list "lpm_shifttype" "STRING" "\"[string toupper $direction]\""]
    lappend params_list [list "lpm_type" "STRING" "\"LPM_CLSHIFT\""] 
    lappend params_list  [list "lpm_width" "NATURAL" [expr {$width + 1}]]
	lappend params_list  [list "lpm_widthdist" "NATURAL" [expr {$bit_width + 1}]]

    #---------------------------------------------------------------------------------------
    # add all terp params to array params_terp #
    set params_terp(module_port_list)   $module_port_list
    set params_terp(sub_wire_list)      $sub_wire_list
    set params_terp(wire_list)          $wire_list
    set params_terp(port_map_list)      $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(params_list)        $params_list
    set params_terp(ip_name)            "lpm_clshift"

    return [array get params_terp]
}


