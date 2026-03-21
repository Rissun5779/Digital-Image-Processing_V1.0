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


# TEST COMMON 
# necessary functions for testing tcl code

package provide altera_iopll::test 14.0

################################################################################
###                          TCL NAMESPACE                                   ###
################################################################################

namespace eval ::altera_iopll::test:: {
   # Namespace Variables
   variable parameter_array
   array set paramter_array [list]
   set parameter_array(A) [list VALUE oho ALLOWED_RANGES {0 1 2}]
   # Import functions into namespace

   # Export functions
   namespace export set_parameter_value
   namespace export get_parameter_value
   namespace export get_parameter_property
   namespace export set_parameter_property
   namespace export pll_send_message
}

proc altera_iopll::test::set_parameter_value {parameter_name parameter_value} {
	variable parameter_array
	if { [info exists parameter_array($parameter_name)]} {
		array set parameter_data $parameter_array($parameter_name)		
		set parameter_data(VALUE) $parameter_value
		set parameter_array($parameter_name) [array get parameter_data]
	} else {
		set parameter_array($parameter_name) [list VALUE $parameter_value]
	}
}

proc altera_iopll::test::get_parameter_value {parameter_name} {
	variable parameter_array
	if { [info exists parameter_array($parameter_name)]} {
		array set parameter_data $parameter_array($parameter_name)
		return $parameter_data(VALUE)
	} else {
		error "param $parameter_name doesn't exist!"
	}
}

proc altera_iopll::test::set_parameter_property {parameter_name parameter_property property_value} {
	variable parameter_array
	if { [info exists parameter_array($parameter_name)]} {
		array set parameter_data $parameter_array($parameter_name)		
		set parameter_data($parameter_property) $property_value
		set parameter_array($parameter_name) [array get parameter_data]
	} else {
		set parameter_array($parameter_name) [list $parameter_property $property_value]
	}
}

proc altera_iopll::test::get_parameter_property {parameter_name parameter_property} {
	variable parameter_array
	if { [info exists parameter_array($parameter_name)]} {
		array set parameter_data $parameter_array($parameter_name)
		return $parameter_data($parameter_property)
	} else {
		error "param $parameter_name doesn't exist!"
	}
}

proc altera_iopll::test::pll_send_message {type message} {
	puts "$type: $message"
}
