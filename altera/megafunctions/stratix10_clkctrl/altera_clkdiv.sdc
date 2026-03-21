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


#__ACDS_USER_COMMENT__####################################################################
#__ACDS_USER_COMMENT__
#__ACDS_USER_COMMENT__ THIS IS AN AUTO-GENERATED FILE!
#__ACDS_USER_COMMENT__ -------------------------------
#__ACDS_USER_COMMENT__ Note: all changes to this file will be overwritten when the core is regenerated
#__ACDS_USER_COMMENT__
#__ACDS_USER_COMMENT__ FILE DESCRIPTION
#__ACDS_USER_COMMENT__ ----------------
#__ACDS_USER_COMMENT__ This file contains the timing constraints for the clock divider
#__ACDS_USER_COMMENT__

set script_dir [file dirname [info script]]

#__ACDS_USER_COMMENT__ Set global parameters
source "$script_dir/altera_clkdiv_parameters.tcl"

#__ACDS_USER_COMMENT__ Load the design package in order to retrieve a list of clock divider instances
load_package design

#__ACDS_USER_COMMENT__ Required for proper clock constraints
derive_clock_uncertainty

#__ACDS_USER_COMMENT__ Returns a list of clock divider instances
proc get_instances {} {

	#__ACDS_USER_COMMENT__ Retrieve a list of clock divider instances
	set core $::GLOBAL_altera_clkdiv_core
	set instances [design::get_instances -entity $core]

	#__ACDS_USER_COMMENT__ No clock divider instances were detected
	if {[ llength $instances ] == 0} {
		post_message -type error "The clock divider SDC script was unable to detect any instances of core < $core >"
	}
	
	#__ACDS_USER_COMMENT__ Append "|clkdiv_inst|" to each instance name
	for {set inst_i 0} {$inst_i < [llength $instances]} {incr inst_i} {
		set full_inst [lindex $instances $inst_i]
		append full_inst "|clkdiv_inst|"
		lset instances $inst_i $full_inst
	}
	
	return $instances
}

#__ACDS_USER_COMMENT__ Constrain the outputs of all clock divider instances
foreach inst [get_instances] {

	#__ACDS_USER_COMMENT__ Constrain output clocks
	for {set outclk 0} {$outclk < $::GLOBAL_altera_clkdiv_out_clocks} {incr outclk} {

		#__ACDS_USER_COMMENT__ Compute frequency ratio relative to the input clock
		set divisor [expr {2 ** $outclk}]
		
		#__ACDS_USER_COMMENT__ Derive input clock port
		set source [get_pins "${inst}inclk"]
		
		#__ACDS_USER_COMMENT__ Derive output clock port
		set target [get_pins "${inst}clock_div${divisor}"]

		#__ACDS_USER_COMMENT__ Constrain current clock using parameters above
		create_generated_clock -add \
			-name "clock_div${divisor}" \
			-source $source \
			-divide_by $divisor \
			$target
	}
}
