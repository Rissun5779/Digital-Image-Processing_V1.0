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


package provide pll_model 1.0

namespace eval ::pll_model {
	
	source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util math.tcl]
	
	namespace export create
	variable model
	variable id
	variable param_index
	
	array set model {}
	set id -1
	set i -1
	
	foreach param [ list m n c0 c1 c2 c3 c4 c5 refclk vcoclk \
	 		desired_outclk0 desired_outclk1 desired_outclk2 desired_outclk3 desired_outclk4 desired_outclk5 \
			actual_outclk0 actual_outclk1 actual_outclk2 actual_outclk3 actual_outclk4 actual_outclk5 ] {
		set param_index($param) [ incr i ]
	}
}

proc ::pll_model::create {} {
	variable model
	variable id

	set token "model[incr id]"

	# initialize default values for a new PLL model
	# TODO: should these values matches default upon reset?
	set m { 1 { 0 4095 } }
	set n { 64 { 0 63 } }
	set c0 { 512 { 0 511 } }
	set c1 { 512 { 0 511 } }
	set c2 { 512 { 0 511 } }
	set c3 { 512 { 0 511 } }
	set c4 { 512 { 0 511 } }
	set c5 { 512 { 0 511 } }
	set refclk { 1 {} }
	set vcoclk { 1 { 1 1 } }
	set desired_outclk0 { 1 {} }
	set desired_outclk1 { 1 {} }
	set desired_outclk2 { 1 {} }
	set desired_outclk3 { 1 {} }
	set desired_outclk4 { 1 {} }
	set desired_outclk5 { 1 {} }
	set actual_outclk0 { 0 {} }
	set actual_outclk1 { 0 {} }
	set actual_outclk2 { 0 {} }
	set actual_outclk3 { 0 {} }
	set actual_outclk4 { 0 {} }
	set actual_outclk5 { 0 {} }
	
	lappend new_model $m
	lappend new_model $n
	lappend new_model $c0
	lappend new_model $c1
	lappend new_model $c2
	lappend new_model $c3
	lappend new_model $c4
	lappend new_model $c5
	lappend new_model $refclk
	lappend new_model $vcoclk
	lappend new_model $desired_outclk0
	lappend new_model $desired_outclk1
	lappend new_model $desired_outclk2
	lappend new_model $desired_outclk3
	lappend new_model $desired_outclk4
	lappend new_model $desired_outclk5
	lappend new_model $actual_outclk0
	lappend new_model $actual_outclk1
	lappend new_model $actual_outclk2
	lappend new_model $actual_outclk3
	lappend new_model $actual_outclk4
	lappend new_model $actual_outclk5
	
	set model($token) $new_model

	# ensure default parameters are sane
	::pll_model::validate $token
	
	return $token
}

proc ::pll_model::get_parameter_descriptor { token param } {
	variable model
	variable param_index
	set m $model($token)
	set index $param_index($param)
	return [ lindex $m $index ]
}

proc ::pll_model::set_parameter_descriptor { token param values } {
	variable model
	variable param_index
	set m $model($token)
	set index $param_index($param)
	lset m $index $values
	set model($token) $m
}

proc ::pll_model::get_parameter_property { token param property } {
	set param [ ::pll_model::get_parameter_descriptor $token $param]
	if { $property == "value" } {
		return [ lindex $param 0 ]
	}
	if { $property == "range" } {
		return [ lindex $param 1 ]
	}
}

proc ::pll_model::set_parameter_property { token param property value } {

	set desc [ ::pll_model::get_parameter_descriptor $token $param ]
	if { $property == "value" } {
		set old_value [ lindex $desc 0 ]
		if { $old_value != $value } {
			lset desc 0 $value
		}
	}
	if { $property == "range" } {
		set old_value [ lindex $desc 1 ]
		if { $old_value != $value } {
			lset desc 1 $value
		}
	}
	::pll_model::set_parameter_descriptor $token $param $desc
	::pll_model::validate $token
}

proc ::pll_model::get_parameter_value { token param } {
	return [ ::pll_model::get_parameter_property $token $param value ] 
}

proc ::pll_model::set_parameter_value { token param value } {
	set old_value [ ::pll_model::get_parameter_value $token $param ]
	if { $old_value != $value } {
		set range [ ::pll_model::get_parameter_property $token $param range ]
		# validate parameter's range
		if { $range != {} } {
			set min [ lindex $range 0 ]
			set max [ lindex $range 1 ]
			if { $value < $min } {
				return
			}
			if { $value > $max } {
				return
			}
		}
		::pll_model::set_parameter_property $token $param value $value
	}
}


proc ::pll_model::validate_parameter { token param } {
	set range [ ::pll_model::get_parameter_property $token $param range ]
	# validate parameter's range
	if { $range != {} } {
		set min [ lindex $range 0 ]
		set max [ lindex $range 1 ]
		set value [ ::pll_model::get_parameter_value $token $param ]
		if { $value < $min } {
			::pll_model::set_parameter_value $token $param $min 
		}
		if { $value > $max } {
			::pll_model::set_parameter_value $token $param $max
		}
	}
}

proc ::pll_model::validate_parameters { token } {
	variable param_index
	foreach param [ array names param_index ] {
		::pll_model::validate_parameter $token $param	
	}
}

proc ::pll_model::calculate_vco_ranges { token } {
	
	set vcoclk_range [ ::pll_model::get_parameter_property $token vcoclk range ]
	
	set vcoclk_min [ lindex $vcoclk_range 0 ]
	set vcoclk_max [ lindex $vcoclk_range 1 ]
	
	set vco_ranges {}
	
	# Compute VCO range which can be used to derive c0-c5 output clocks 
	# individually as if each of them are mutually exclusive (i.e. only  
	# one enabled at a time)
	
	for { set i 0 } { $i < 6 } { incr i } {
		set desired_outclk [ ::pll_model::get_parameter_value $token desired_outclk$i ]
		
		# assume desired_outclk=1 Hz means that the clock is unused
		# TODO: change the assumption to use invalid value like 0 Hz?
		if { $desired_outclk == 1 } {
			lappend vco_ranges [ list $vcoclk_min $vcoclk_max ]
		} else {
        		set c_range [ ::pll_model::get_parameter_property $token c$i range ]
			
			# Adjust c-counter from 0-based to 1-based to ease calculation
        		set c_min [ expr [ lindex $c_range 0 ] + 1 ]
        		set c_max [ expr [ lindex $c_range 1 ] + 1 ]
        		
        		if { $desired_outclk <  [ expr $vcoclk_min / $c_min ] } {
				# cap $desired_vcoclk_min at $vcoclk_min 
				# when $desired_outclk * $c_min < $vcoclk_min 
        			set desired_vcoclk_min $vcoclk_min
        		} elseif { $desired_outclk > [ expr $vcoclk_max / $c_min ] } {
				# cap $desired_vcoclk_min at $vcoclk_max 
				# when $desired_outclk * $c_min > $vcoclk_max 
        			set desired_vcoclk_min $vcoclk_max
        		} else {
				set desired_vcoclk_min [ expr $desired_outclk * $c_min]
        		}
        
			if { $desired_outclk <  [ expr $vcoclk_min / $c_max ] } {
				# cap $desired_vcoclk_max at $vcoclk_min 
				# when $desired_outclk * $c_max < $vcoclk_min 
				set desired_vcoclk_max $vcoclk_min
			} elseif { $desired_outclk > [ expr $vcoclk_max / $c_max ] } {
				# cap $desired_vcoclk_max at $vcoclk_max 
				# when $desired_outclk * $c_max > $vcoclk_max 
				set desired_vcoclk_max $vcoclk_max
			} else {
				set desired_vcoclk_max [ expr $desired_outclk * $c_max ]
			}
        		
        		lappend vco_ranges [ list $desired_vcoclk_min $desired_vcoclk_max ]
		}
	}
	
	# Try to determine if there is a common range of VCO which 
	# is a subset of every c0-c5 output ranges, if not, find the
	# closests/best one.
	set overlap_range [ calculate_overlap_ranges $vco_ranges ]
	lappend overlap_range $vco_ranges
	return $overlap_range
	
}


proc get_overlap_range { range1 range2 } {

	set range1_min [ lindex $range1 0 ]
	set range1_max [ lindex $range1 1 ]

	set range2_min [ lindex $range2 0 ]
	set range2_max [ lindex $range2 1 ]

	if { $range1_min > $range2_min } {
		set min $range1_min
	} else {
		set min $range2_min
	}

	if { $range1_max < $range2_max } {
		set max $range1_max
	} else {
		set max $range2_max
	}

	if { $min <= $max } {
		return [ list $min $max ]
	} else {
		return [ list ]
	}
}

proc get_overlap_ranges { ranges } {

	set range_count [ llength $ranges ]

	if { $range_count == 0 } {
		return [ list ]
	}

	set range [ lindex $ranges 0 ]

	if { $range_count == 1 } {
		return $range
	}

	for { set i 1 } { $i < $range_count } { incr i } {
		set range_i [ lindex $ranges $i ]
		set range [ get_overlap_range $range $range_i ]
		if { [ llength $range ] == 0 } {
			break
		}
	}

	return $range
}

# Given a list of ranges, compute an overlap range
# and the index of ranges which the overlap range
# is a subset of.
#
# Example:
#
# Given: {{10 20} {30 40} {15 35}}
# 
# Overlap range 1: {15 20} for {{10 20} {15 35}}
# Overlap range 2: {30 35} for {{30 40} {15 35}}
#
# Result: {{30 35} {0 2}} where {1 2} refers to 
# ranges where the overlap occured.
#
# An assumption here is that if there are multiple
# overlaps, the one with highest upperbound is 
# preferred
#
proc calculate_overlap_ranges { ranges } {

	set range_count [ llength $ranges ]

	if { $range_count == 0 } {
		return [ list ]
	}

	if { $range_count == 1 } {
		return [ list [ lindex $ranges 0 ] {0} ]
	}


	if { $range_count == 2 } {
		set common_range [ get_overlap_ranges $ranges ]
		
		# Return the common range if found, otherwise
		# return the range with higher upperbound
		if { [ llength $common_range ] == 2 } {
			return [ list $common_range {0 1} ]
		} else {
			set range1 [ lindex $ranges 0 ]
			set range1_upperbound [ lindex $range1 1 ]
			set range2 [ lindex $ranges 1 ]
			set range2_upperbound [ lindex $range2 1 ]
			if { $range1_upperbound > $range2_upperbound } {
				return [ list $range1 {0} ]
			} else {
				return [ list $range2 {1} ]
			}
		}
	}


	# If there's 3 or more ranges, things get alot more complicated :-)

	# First we'll try to determine if there's a common range for all
	# ranges
	set common_range [ get_overlap_ranges $ranges ]
	if { [ llength $common_range ] == 2 } {
#		puts "Found best range"
		set indices [ list ]
		for { set i 0 } { $i < [ llength $ranges ] } { incr i } {
			lappend indices $i
		}
		return [ list $common_range $indices ]
	}

	# If not, we'll try to determine common range(s) for a subset
	# of ranges, where we iterate from subset with a number of 
	# (n-1) to 2 ranges, and that' where we'll use a lookup table
	# to facilitate this.
	set lut [ index_lut $range_count ]
	for { set n [ expr $range_count - 1 ] } { $n >= 2 } { set n [ expr $n - 1 ] } {
		set subsets [ lindex $lut $n ]

		# Each subset may have a common range, so we need to pick the best
		set best_subset_common_range [ list ]
		set best_subset_common_range_indices [ list ]
		
		foreach subset $subsets {
			# Extract a subset of ranges
			set subset_ranges [ list ]
			foreach index $subset {
				lappend subset_ranges [ lindex $ranges $index ]
			}

			set subset_common_range [ get_overlap_ranges $subset_ranges ]
			if { [ llength $subset_common_range ] == 2 } {
				if { [ llength $best_subset_common_range ] == 2 } {
					# compare to see if the new subset common range has 
					# bigger upperbound, if yes then that's our best subset common range
					set subset_common_range_upperbound [ lindex $subset_common_range 1 ]
					set best_subset_common_range_upperbound [ lindex $best_subset_common_range 1 ]
					if { $subset_common_range_upperbound > $best_subset_common_range_upperbound } {
						set best_subset_common_range $subset_common_range
						set best_subset_common_range_indices $subset
					}
				} else {
					# use as baseline if this is the first subset common range
					set best_subset_common_range $subset_common_range
					set best_subset_common_range_indices $subset
				}
			} 
		}

		# If we can determine the best common range for the current subset,
		# return it, otherwise we will need to try a different subset
		if { [ llength $best_subset_common_range ] == 2 } {
#			puts "Found something in between"
			return [ list $best_subset_common_range $best_subset_common_range_indices ]
		}

	}


	# If all ranges do not overlap with each other at all (rare)
	# assume the range with highest upperbound for now.
	set best_range [ lindex $ranges 0 ]
	set best_range_index 0
	for { set i 1 } { $i < $range_count } { incr i } {
		set next_range [ lindex $ranges $i ]
		set next_range_upperbound [ lindex $next_range 1 ]
		set best_range_upperbound [ lindex $best_range 1 ]
		if { $next_range_upperbound > $best_range_upperbound } {
			set best_range $next_range
			set best_range_index $i
		}
	}

#	puts "Found worst range"
	return [ list $best_range [ list $best_range_index ] ]
}

# Given a decimal number, return a list of numbers
# presenting the bits set   
proc dec2index { num } {
	set power 0
	set index [ list ]
	while { [ expr pow(2,$power) ] <= $num } {
		if { [ expr $num & int(pow(2,$power)) ] } {
			lappend index $power
		}
		incr power
	}
	return $index
}

# Build a lookup table for calculating sublists of n-elements.
# Example, a lookup table for sublist of 3 elements is
# {{}} {0 1 2} {{0 1} {0 2} {1 2}} {{0 1 2}}.
proc index_lut { bits } {

	for { set n 0 } { $n <= $bits } { incr n } {
		lappend lut [ list ]
	}

	set max [ expr int(pow(2, $bits)) ]
	for { set n 0 } { $n < $max } { incr n } {
		set indices [ dec2index $n ]
		set indices_count [ llength $indices ]
		set bucket [ lindex $lut $indices_count ]
		lappend bucket $indices
		lset lut $indices_count $bucket
	}
	return $lut
}

proc ::pll_model::update_derived_parameters { token } {

	set refclk [ ::pll_model::get_parameter_value $token refclk ]
	
	# calculate VCO range
	set best_vcoclk [ ::pll_model::calculate_vco_ranges $token ]
	set best_vcoclk_range [ lindex $best_vcoclk 0 ] 
	set vcoclk_range [ ::pll_model::get_parameter_property $token vcoclk range ]
	set vcoclk_min [ lindex $vcoclk_range 0 ]
	set vcoclk_max [ lindex $vcoclk_range 1 ]
	
	# try to set VCO to maximum
	set best_vcoclk_max [ lindex $best_vcoclk_range 1 ]
	# round to the closets integer multiple, although this might cause
	# m to exceed permitted range, we will check this againsts
	# the permitted range later on
	set m [ expr int(round(double($best_vcoclk_max) / $refclk)) - 1 ]

	# minimum m value, intentionally round up (ceil()) to avoid undesired round down (round())
	# causing VCO to be lower than the permitted lowerbound
	set m_min [ expr int(ceil(double($vcoclk_min) / $refclk)) - 1 ]
	# maximum m value, intentionally round down (floor()) to avoid undesired round up (round())
	# causing VCO to be higher than the permitted upperbound
	set m_max [ expr int(floor(double($vcoclk_max) / $refclk)) - 1 ]

	if { $m > $m_max } {
		set m $m_max
	}
	
	if { $m < $m_min } {
		set m $m_min
	}
	
	set n 0
	
	::pll_model::set_parameter_value $token m $m 
	::pll_model::set_parameter_value $token n $n
	
	# use actual VCO
	set m [ expr [ ::pll_model::get_parameter_value $token m ] + 1 ]
	set n [ expr [ ::pll_model::get_parameter_value $token n ] + 1 ]
	
	# convert to double to increase precision
	set vcoclk [ expr double($refclk) * $m / $n ]
	::pll_model::set_parameter_value $token vcoclk [ expr round($vcoclk) ]
	
	
	for { set i 0 } { $i < 6 } { incr i } {
		set desired_outclk [ ::pll_model::get_parameter_value $token desired_outclk$i ]
		
		# TODO: temporarily removed ceil()
		# Must always round up c$i with ceil() before round() to prevent 
		# undesired round down, thereby causing actual_outclk$i to
		# exceed desired_outclk$i especially if desired_outclk$i is the max
		# allowed frequency
		set desired_c [ expr round($vcoclk / $desired_outclk) - 1 ]
		
		# Ensure desired_c is always within permitted range, i.e. 0-511
		# this allows c0-c5 output clock frequencies to be "clipped" 
		# at min/max clock frequencies which is important if we want to
		# achieve the minimum possible clock frequency when one of the
		# c0-c5 output clocks is unused. 
		set c_range [ ::pll_model::get_parameter_property $token c$i range ]
		set c_min [ lindex $c_range 0 ]
		set c_max [ lindex $c_range 1 ]
		
		if { $desired_c < $c_min } {
			set desired_c $c_min
		}
		if { $desired_c > $c_max } {
			set desired_c $c_max
		}
		
		::pll_model::set_parameter_value $token c$i $desired_c
		
		set actual_c [ ::pll_model::get_parameter_value $token c$i ]
		set actual_outclk [ expr round($vcoclk / ($actual_c + 1)) ]
		::pll_model::set_parameter_value $token actual_outclk$i $actual_outclk
	}
}


proc ::pll_model::validate { token } {
	::pll_model::validate_parameters $token
	::pll_model::update_derived_parameters $token
}

# emulate lset which supports setting elements within sublists
proc lset {list_var indices value} {
	upvar 1 $list_var thelist
	if { [ llength $indices ] == 1 } { 
		set index $indices
		set thelist [lreplace $thelist $index $index $value]
	} else {
		set index [ lindex $indices 0 ] 
		set sublist_indices [ lreplace $indices 0 0 ] 
		set sublist [ lindex $thelist $index ]
		set sublist_lset [ lset sublist $sublist_indices $value ]
		set thelist [ lreplace $thelist $index $index $sublist_lset ]
	}
	return $thelist
}
