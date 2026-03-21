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
    set radix       $params(radix)
    set eq_port_num $params(eq_port_num)
    set lpm_width   $params(lpm_width)
    set eq_port_num_list    $params(eq_port_num_list)
    set lpm_decodes $params(lpm_decodes)
    set lpm_pipeline $params(lpm_pipeline)
    set latency     $params(latency)

    #---------------------------------------------------------------------------------
    # loop through eq ports list and add to list eq_port_list #
    set eq_port_list    [list ]
    set eq_port_new_list    [list ]
    foreach num $eq_port_num_list   {
        if {$radix} {
            set num_hex [format %0x $num]
            lappend eq_port_list "eq$num_hex"
            lappend eq_port_new_list "$num_hex"
        } else {
            lappend eq_port_list   "eq$num"
            lappend eq_port_new_list    "$num"  
        }
    }
    set eq_port_list [lsort -ascii $eq_port_list]
    set eq_port_new_list  [lsort -ascii $eq_port_new_list]

    # loop through port_list and add to list module_port_list #
    set module_port_list [list ]
    set data_width [expr {$lpm_width-1}]
    foreach port $port_list {
        if {$port eq "data"} {
            lappend module_port_list $port "IN" $data_width
        } elseif {$port eq "eq"} {
            foreach eq_port $eq_port_list {
                lappend module_port_list $eq_port "OUT" -1
            }
        } else {
            lappend module_port_list $port "IN" -1
        }
    }

    # add all output wire connectin to wire_list and sub_wire_list #
    set wire_list [list ]
    set sub_wire_list [list ]
    set lpm_decodes_index [expr {$lpm_decodes-1}]
    if {$eq_port_num>0} {
        for {set i $eq_port_num} {$i >=1} {incr i -1} {
            set ii     [expr {$i-1}]
            set port_num [lindex $eq_port_new_list $ii]
            if {$radix} {
                set port_num  [expr 0x$port_num]
            }
            lappend wire_list "sub_wire$i"  "sub_wire0"  $port_num -1
        }
        for {set i 0} {$i <$eq_port_num} {incr i} {
            set ii      [expr {$i+1}]
            set port_num [lindex $eq_port_new_list $i]
            lappend wire_list "eq$port_num" "sub_wire$ii" -1 -1
        }
        lappend sub_wire_list "sub_wire0" $lpm_decodes_index
        for {set i 1} {$i <=$eq_port_num} {incr i} {
            lappend sub_wire_list "sub_wire$i"  -1
        }
     }
    # add all added ports to port_map_list #
    set port_map_list [list ]
    foreach port $port_list {
        if {$port eq "eq"}   {
            lappend port_map_list $port "sub_wire0" "OUT" $lpm_decodes_index
        } elseif {$port eq "data"} {
            lappend port_map_list $port $port "IN" $data_width
        } else {
            lappend port_map_list $port $port "IN" -1
        }
    }

    #-----------------------------------------------------------------------------------
    # get a list of all ports not added #
    set ports_list_all  [list "aclr" "clock" "clken" "data" "eq" "enable"]
    set ports_not_added_list_temp [list]
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
    #-------------------------------------------------------------------------------------------
    # add all params value to params_list #
    set params_list [list "lpm_decodes" "NATURAL" "$lpm_decodes"]
    if {$lpm_pipeline && $latency} {
        lappend params_list "lpm_pipeline" "NATURAL" "$lpm_pipeline"
    }
    lappend params_list "lpm_type" "STRING" "\"LPM_DECODE\"" 
    lappend params_list  "lpm_width" "NATURAL" "$lpm_width"

    #---------------------------------------------------------------------------------------
    # add all terp params to array params_terp #
    set params_terp(module_port_list)   $module_port_list
    set params_terp(sub_wire_list)      $sub_wire_list
    set params_terp(wire_list)          $wire_list
    set params_terp(port_map_list)      $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(params_list)        $params_list
    set params_terp(ip_name)            "lpm_decode"

    return [array get params_terp]
}


