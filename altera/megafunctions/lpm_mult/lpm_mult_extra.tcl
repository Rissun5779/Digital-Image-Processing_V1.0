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


#+--------------------------------------------------------------------
#|
#|  Name:       get_result_width
#|
#|  Purpose:    Returns the width of the result port. If the width is to
#|              be automatically calculated, this procedure will handle it.
#|
#|  Parameters: None
#|
#|  Returns:    The true width of the result port
#|
#+--------------------------------------------------------------------
proc get_result_width {} {
    # Get all the necessary IP parameters
    set use_mult            [get_parameter_value GUI_USE_MULT]
    set width_a             [get_parameter_value GUI_WIDTH_A]
    set width_b             [get_parameter_value GUI_WIDTH_B]
    set width_p             [get_parameter_value GUI_WIDTH_P]
    set auto_size_result    [get_parameter_value GUI_AUTO_SIZE_RESULT]
    
    # Calculate the width if needed, or return the user selected width
    if { $auto_size_result } {
        if { $use_mult } {
            return [expr { $width_a + $width_b }]
        } else {
            return [expr { $width_a + $width_a }]
        }
    } else {
        return $width_p
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
    
    # This portion added to differentiate set of parameter generetated for lpm_mult and altsquare
    # sclr is not supportted in altsquare due to MGL_DFFE an CBX_PADD
    # To be removed after altsquare supported with sclr feature
    set params(ip_name)                [expr { $params(GUI_USE_MULT) ? "lpm_mult" : "altsquare" }]
    
    #LPM_MULT supported parameter list generation
    if {$params(ip_name) == "lpm_mult"} {
        # Create a list of all ports and their default connection
        set all_ports {
        "aclr"      "1'b0"
        "sclr"      "1'b0"
        "dataa"     "1'b0"
        "result"    "1'b0"
        }
    
    } else {
        #ALTSQUARE supported parameter list generation(NO SCLR)
        set all_ports {
        "aclr"      "1'b0"
        "dataa"     "1'b0"
        "result"    "1'b0"
        }

    }
    
    if { $params(GUI_USE_MULT) } {
        lappend all_ports "clock"   "1'b0"
        lappend all_ports "datab"   "1'b0"
        lappend all_ports "sum"     "1'b0"
        lappend all_ports "clken"   "1'b1"
    } else {
        lappend all_ports "clock"   "1'b1"
        lappend all_ports "ena"     "1'b1"
    }

    # Create the lists that hold all data for terp
    set module_port_list        [list]      ;# port, direction, width, widthL
    set sub_wire_list           [list]      ;# name, width, widthL, constant
    set wire_list               [list]      ;# dest, src, width, widthL
    set port_map_list           [list]      ;# port, connect, direction, width, widthL
    set ports_not_added_list    [list]      ;# port, connect
    set params_list             [list]      ;# name, str, value
    set bit_vectors             [list]      ;# name, width, widthL, constant
    set inports                 [list]      ;# port, direction, width, widthL
    set outports                [list]      ;# port, direction, width, widthL


    # Split all ports into a list of inports and outports
    foreach port [get_interface_ports] {

        set width   -1
        set widthL  -1

        # Port dataa
        if { $port eq "dataa" } {
            set width   $params(GUI_WIDTH_A)
            set widthL  0
        }
        
        # Port datab
        if { $port eq "datab" } {
            set width   $params(GUI_WIDTH_B)
            set widthL  0
        }
        
        # Port result
        if { $port eq "result" } {
            set width   $params(GUI_RESULT_WIDTH)
            set widthL  0
        }

        # Add to the correct list
        if { [get_port_property $port DIRECTION] eq "Input" } {
            lappend inports $port "IN" $width $widthL
        } elseif { [get_port_property $port DIRECTION] eq "Output" } {
            lappend outports $port "OUT" $width $widthL
        }
    }
    # If B_IS_CONSTANT, datab needs to be created 
    set check_datab_port 0
    if { $params(GUI_USE_MULT) && $params(GUI_B_IS_CONSTANT) } {
        lappend inports "datab" "IN" $params(GUI_WIDTH_B) 0
        # Flag that a datab port has been added
        incr check_datab_port
	}
	
    # Sort the inports and outports and make the module port list
    set inports             [sort_list_skip $inports  4]    ;# Sort Inports
    set outports            [sort_list_skip $outports 4]    ;# Sort Outports
    set module_port_list    [concat $inports $outports]     ;# Inports in front of Outports


    # If B_IS_CONSTANT, then some additional setup needs to be done
    set b_is_const 0
    if { $params(GUI_USE_MULT) && $params(GUI_B_IS_CONSTANT) } {
        # Remove datab from the module port list
        set index [lsearch $module_port_list "datab"]
        set module_port_list [lreplace $module_port_list $index $index+3]

        # Add the constant subwire
        set const [convert_dec_to_hex $params(GUI_CONSTANT_B) $params(GUI_WIDTH_B)]
        lappend sub_wire_list "sub_wire0" $params(GUI_WIDTH_B) 0 "$params(GUI_WIDTH_B)'h$const"

        # Add a bit vector
        set const [convert_dec_to_bin $params(GUI_CONSTANT_B) $params(GUI_WIDTH_B)]
        lappend bit_vectors "sub_wire0" $params(GUI_WIDTH_B) 0 "$const"
        
        # Flag that a subwire has been added
        incr b_is_const
    }


    # For each outport, there should be a sub wire of the same width
    set i $b_is_const
    foreach {port direction width widthL} $outports {
        lappend sub_wire_list "sub_wire$i" $width $widthL {}
        incr i
    }

    
    # Now connect the subwires to the outports in the same order
    set i $b_is_const
    foreach {port direction width widthL} $outports {
        lappend wire_list $port "sub_wire$i" $width $widthL
        incr i
    }


    # Add all of the inports to the port map list and remove them from all ports
    set i 0
    foreach {port direction width widthL} $inports {
        set connect $port
        set port_name $port

        # Altsquare rename dataa component port to data
        if { $port eq "dataa" && !$params(GUI_USE_MULT) } {
            set port_name "data"
        }

        # Datab is connected to a subwire if constant
        if { $port eq "datab" && $params(GUI_USE_MULT) && $params(GUI_B_IS_CONSTANT) } {
            set connect "sub_wire$i"
            incr i
        }

        # Add to the port map list
        lappend port_map_list $port_name $connect $direction $width $widthL

        # Remove from all ports
        set index [lsearch $all_ports $port]
        set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
    }


    # Add all of the outports to the port map list and remove them from all ports
    foreach {port direction width widthL} $outports {
        # Add to the port map list
        lappend port_map_list $port "sub_wire$i" $direction $width $widthL
        incr i

        # Remove from all ports
        set index [lsearch $all_ports $port]
        set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
    }


    # The all ports list is now all ports not used... make it the ports not added list
    set ports_not_added_list [sort_list_skip $all_ports 2]

    
    # Parameter list for lpm_mult module
    if { $params(GUI_USE_MULT) } {
        
        # Construct the lpm_hint string
        set hint [list]

        if { $params(GUI_B_IS_CONSTANT) } {
            lappend hint "INPUT_B_IS_CONSTANT=YES"
        }
        
        switch $params(GUI_IMPLEMENTATION) {
            "0" {}
            "1" { lappend hint "DEDICATED_MULTIPLIER_CIRCUITRY=YES" }
            "2" { lappend hint "DEDICATED_MULTIPLIER_CIRCUITRY=NO"  }
        }

        switch $params(GUI_OPTIMIZE) {
            "0" { lappend hint "MAXIMIZE_SPEED=5" }
            "1" { lappend hint "MAXIMIZE_SPEED=9" }
            "2" { lappend hint "MAXIMIZE_SPEED=1" }
        }

        # Add the parameters if they are needed
        lappend params_list lpm_hint             STRING  [join $hint ","]
        lappend params_list lpm_representation   STRING  [expr { $params(GUI_SIGNED_MULT) ? "SIGNED" : "UNSIGNED" }]
        lappend params_list lpm_type             STRING  "LPM_MULT"
        lappend params_list lpm_widtha           NATURAL $params(GUI_WIDTH_A)
        lappend params_list lpm_widthb           NATURAL $params(GUI_WIDTH_B)
        lappend params_list lpm_widthp           NATURAL $params(GUI_RESULT_WIDTH)
        if { $params(GUI_PIPELINE) } {
            lappend params_list lpm_pipeline     NATURAL $params(GUI_LATENCY)
        }

    # Parameter list for altsquare module
    } else {

        lappend params_list data_width           NATURAL $params(GUI_WIDTH_A)
        lappend params_list lpm_type             STRING  "ALTSQUARE"
        lappend params_list representation       STRING  [expr { $params(GUI_SIGNED_MULT) ? "SIGNED" : "UNSIGNED" }]
        lappend params_list result_width         NATURAL $params(GUI_RESULT_WIDTH)
        lappend params_list pipeline             NATURAL [expr { $params(GUI_PIPELINE) ? $params(GUI_LATENCY) : 0 }]
        if { !$params(GUI_AUTO_SIZE_RESULT) } {
            lappend params_list result_alignment STRING  "MSB"
        }
    }
    

    # Create the terp array
    array set params_terp {}
    set params_terp(module_port_list)       $module_port_list
    set params_terp(sub_wire_list)          $sub_wire_list
    set params_terp(bit_vectors)            $bit_vectors
    set params_terp(wire_list)              $wire_list
    set params_terp(port_map_list)          $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(output_name)            $output_name
    set params_terp(params_list)            [sort_list_skip $params_list 3]
    set params_terp(ip_name)                [expr { $params(GUI_USE_MULT) ? "lpm_mult" : "altsquare" }]


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
#|  Name:       nBitNecessary
#|
#|  Purpose:    Returns the number of bit needed to represent the number
#|              given. Ported directly from legacy IP.
#|
#|  Parameters: v           -- the number to count the number of needed bits
#|              SignedValue -- if v is a signed value
#|
#|  Returns:    The number of bits needed to represent v
#|
#+--------------------------------------------------------------------
proc nBitNecessary {v SignedValue} {
    set n 0                     ;# The number of bits it takes to represent v
    if {$SignedValue == 1} {
        incr n                  ;# Add a bit for signed numbers
    }
    if {$v < 0} {
        set v [expr {~$v}]      ;# Bitwise NOT if v is negative
    }
    while { $v != 0 } {         ;# Count the number of bits in v
        set v [expr {$v / 2}]   ;# Half the number
        incr n                  ;# Add a bit
    }
    return $n                   ;# Return the number of bits
}


#+--------------------------------------------------------------------
#|
#|  Name:       convert_dec_to_bin
#|
#|  Purpose:    Converts the input decimal number to binary.
#|
#|  Parameters: dec  -- Decimal number to convert
#|              bits -- The number of bits the output binary will have
#|
#|  Returns:    Binary representation of the input decimal
#|
#+--------------------------------------------------------------------
proc convert_dec_to_bin { dec bits } {
    # Build the binary number by grabing each bit of dec starting with the LSB
    set bin_number ""
    for {set i 0} {$i < $bits} {incr i} {
        set digit [expr { $dec & 1 }]           ;# Grab the LSB
        set bin_number "${digit}${bin_number}"  ;# Add the LSB to the binary number
        set dec [expr { $dec >> 1 }]            ;# Signed shift dec so next iteration is the next bit
    }
    
    # Return the binary number
    return $bin_number
}


#+--------------------------------------------------------------------
#|
#|  Name:       convert_dec_to_hex
#|
#|  Purpose:    Converts the input decimal number to hexadecimal.
#|
#|  Parameters: dec  -- Decimal number to convert
#|              bits -- The number of bits the output hexadecimal will have
#|
#|  Returns:    Hexadecimal representation of the input decimal
#|
#+--------------------------------------------------------------------
proc convert_dec_to_hex { dec bits } {
    # Map every 4 bits in binary to a hex digit
    set map {   "0000" "0"  "0001" "1"
                "0010" "2"  "0011" "3"
                "0100" "4"  "0101" "5"
                "0110" "6"  "0111" "7"
                "1000" "8"  "1001" "9"
                "1010" "a"  "1011" "b"
                "1100" "c"  "1101" "d"
                "1110" "e"  "1111" "f"  }
    
    set bits [expr { int(ceil($bits/4.0)) * 4 }]    ;# Round bits up to next factor of 4
    set bin [convert_dec_to_bin $dec $bits]         ;# Convert the decimal to binary
    return [string map $map $bin]                   ;# Map the binary to hex
}

