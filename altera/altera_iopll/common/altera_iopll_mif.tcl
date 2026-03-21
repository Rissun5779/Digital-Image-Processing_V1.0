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


package provide altera_iopll::mif 14.0


################################################################################
###                          TCL NAMESPACE                                   ###
################################################################################

namespace eval ::altera_iopll::mif:: {
   # Namespace Variables
   
   
   # Import functions into namespace

   # Export functions
}

################################################################################
###                          TCL PROCEDURES                                  ###
################################################################################

# + ----------
# + Conversion to binary
# + ---------
proc ::altera_iopll::mif::int_to_n_bits	{integer n} {
	set old_bits [int_to_bits $integer]
    set new_bits $old_bits
    set len [string length $new_bits]
    set zero "0"

    while {$len < $n} {
        # Pad MSBs with 0
        set new_bits $zero$new_bits
        set len [string length $new_bits]
    }

    return $new_bits
}

proc ::altera_iopll::mif::int_to_bits {integer} {
    set bits ""
    set temp $integer

    while {$temp > 0} {
        set new_bit [expr $temp % 2]
        set bits $new_bit$bits
        set temp [expr $temp/2]
    }

    return $bits
}

# + ----------
# + Conversion of boolean to integer
# + ---------
proc ::altera_iopll::mif::bool_to_int {boolean} {
	if {$boolean} {
		return 1
	} else  {
		return 0
	}
}

# + ----------
# + Conversion of 256 to 0
# + ---------
proc ::altera_iopll::mif::conv_256_to_0 {int} {
	if {$int == 256} {
		return 0
	} else  {
		return $int
	}
}

#get line for mif mife
proc ::altera_iopll::mif::get_line_for_mif {addr data comment} {
	set padded_data	[pad_to_32 $data]
	if {$comment == ""} {
		set padded_comment ""
	} else {
		set padded_comment "-- $comment"
	}
	set return_line "$addr : $padded_data;        $padded_comment"
	return $return_line
}

#must be 32 bits
proc ::altera_iopll::mif::pad_to_32 {data} {
	set length [string length $data]
	set n_zeros [expr {(32 - $length)}]
	set padded_data [string repeat "0" $n_zeros]$data
	return $padded_data
}

