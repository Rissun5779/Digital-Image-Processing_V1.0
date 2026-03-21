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


package require -exact qsys 13.1
package require altera_terp


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


    # Create a list of all ports and their default connection
    set all_ports {
        "clock"     ""
        "q"         ""
        "eq"        ""
        "cout"      ""
        "cin"       "1'b1"
        "clk_en"    "1'b1"
        "cnt_en"    "1'b1"
        "updown"    "1'b1"
        "sclr"      "1'b0"
        "sload"     "1'b0"
        "sset"      "1'b0"
        "aclr"      "1'b0"
        "aload"     "1'b0"
        "aset"      "1'b0"
        "data"      "1'b0"
    }
    
    if {$params(GUI_WIDTH) != 1} {
        set all_ports [lreplace $all_ports end end "\{$params(GUI_WIDTH)\{1'b0\}\}"]
    }
 

    # Create the lists that hold all data for terp
    set module_port_list        [list]      ;# port, direction, width, widthL
    set sub_wire_list           [list]      ;# name, width, widthL
    set wire_list               [list]      ;# dest, src, width, widthL
    set port_map_list           [list]      ;# port, connect, direction, width, widthL
    set ports_not_added_list    [list]      ;# port, connect
    set params_list             [list]      ;# name, str, value
    set inports                 [list]      ;# port, direction, width, widthL
    set outports                [list]      ;# port, direction, width, widthL


    # Split all ports into a list of inports and outports
    foreach port [get_interface_ports] {
        set width   -1
        set widthL  -1

        # Ports with a width
        if { $port eq "data" || $port eq "q" } {
            set width   $params(GUI_WIDTH)
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


    # Add all of the parameters needed and their value
    if { ($params(GUI_ASET_ALL1) == 0) && ($params(GUI_ASET)) } {
        lappend params_list lpm_avalue STRING $params(GUI_AVALUE)
    }

    if { $params(GUI_DIRECTION) == 0 } {
        lappend params_list lpm_direction STRING "UP"
    } elseif { $params(GUI_DIRECTION) == 1 } {
        lappend params_list lpm_direction STRING "DOWN"
    } else {
        lappend params_list lpm_direction STRING "UNUSED"
    }

    if { $params(GUI_MODULUS_COUNTER) == 1 } {
        lappend params_list lpm_modulus NATURAL $params(GUI_MODULUS_VALUE)
    }

    if { $params(GUI_DIRECTION) == 2 } {
        lappend params_list lpm_port_updown STRING "PORT_USED"
    } else {
        lappend params_list lpm_port_updown STRING "PORT_UNUSED"
    }

    if { ($params(GUI_SSET_ALL1) == 0) && ($params(GUI_SSET)) } {
        lappend params_list lpm_svalue STRING $params(GUI_SVALUE) 
    }

    lappend params_list lpm_type STRING "LPM_COUNTER"

    lappend params_list lpm_width NATURAL $params(GUI_WIDTH)


    # Create the terp array
    array set params_terp {}
    set params_terp(module_port_list)       $module_port_list
    set params_terp(sub_wire_list)          $sub_wire_list
    set params_terp(wire_list)              $wire_list
    set params_terp(port_map_list)          $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(params_list)            $params_list
    set params_terp(output_name)            $output_name
    set params_terp(ip_name)                "lpm_counter"


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
#|  Name:       mwizc_global_str2int
#|
#|  Purpose:    Port function from legacy IP. Converts a string to a number
#|              or returns 0 if the string is not an int. Note: TCL treats
#|              ints and strings as the same, so the 'conversion' doesn't exist.
#|
#|  Parameters: str -- string to 'convert'
#|
#|  Returns:    The given string 'converted' to an int
#|
#+--------------------------------------------------------------------
proc mwizc_global_str2int {str} {
    if { ![string is integer $str] } {
        return 0
    } else {
        return $str
    }
}
