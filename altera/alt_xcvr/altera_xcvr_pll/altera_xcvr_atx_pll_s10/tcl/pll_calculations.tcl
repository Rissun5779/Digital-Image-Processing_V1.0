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


## \file pll_calculations.tcl 

package provide altera_xcvr_atx_pll_s10::pll_calculations 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::gui::messages
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common

namespace eval ::altera_xcvr_atx_pll_s10::pll_calculations:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*
 	namespace import ::alt_xcvr::ip_tcl::messages::*

   namespace export \
      legality_check_auto \
      legality_check_manual \
      legality_check_fract \
      legality_check_feedback_auto \
	  set_calc_constants \
     
   global m_counter_list
   global n_counter_list
   global l_counter_list
   global l_cascade_counter_list
   
   global max_pfd
   global min_pfd
   global max_vco
   global min_vco
   global max_ref
   global min_ref
   global f_max_x1
   global f_min_tank_0
   global f_max_tank_0
   global f_min_tank_1
   global f_max_tank_1
   global f_min_tank_2
   global f_max_tank_2

   #variable m_counter_list_fract
   #convert range lists to standard TCL lists
   proc ::altera_xcvr_atx_pll_s10::pll_calculations::scrub_list_values { my_list } {
     set new_list {}
     set my_list_len [llength $my_list]
     for {set list_index 0} {$list_index < $my_list_len} { incr list_index } {
       set this_value [lindex $my_list $list_index]
       if [ regexp {:} $this_value ] then {
         regsub -all ":" $this_value " " temp_list
         set start_value [lindex $temp_list 0]
         set end_value [lindex $temp_list 1]
         for {set index $start_value} {$index <= $end_value} { incr index } {
           lappend new_list $index
         }
       } else {
         lappend new_list $this_value
       }
     }
     return $new_list
   }

}

proc get_m_counter_list {} { 
	global m_counter_list
	return $m_counter_list
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::set_calc_constants { f_max_pfd f_min_pfd f_max_vco f_min_vco f_max_ref f_min_ref f_max_x1 f_max_tank_0 f_min_tank_0 f_max_tank_1 f_min_tank_1 f_max_tank_2 f_min_tank_2 m_list n_list l_list l_cascade_list} {
   global max_pfd
   global min_pfd
   global max_vco
   global min_vco
   global max_ref
   global min_ref
   global max_x1
   global min_tank_0
   global max_tank_0
   global min_tank_1
   global max_tank_1
   global min_tank_2
   global max_tank_2
   global m_counter_list
   global n_counter_list
   global l_counter_list
   global l_cascade_counter_list

   set max_pfd    $f_max_pfd
   set min_pfd    $f_min_pfd
   set max_vco    $f_max_vco
   set min_vco    $f_min_vco
   set max_ref    $f_max_ref
   set min_ref    $f_min_ref   
   set max_x1     $f_max_x1
   set min_tank_0 $f_min_tank_0
   set max_tank_0 $f_max_tank_0
   set min_tank_1 $f_min_tank_1
   set max_tank_1 $f_max_tank_1
   set min_tank_2 $f_min_tank_2
   set max_tank_2 $f_max_tank_2
   set m_counter_list $m_list
   set n_counter_list $n_list
   set l_counter_list $l_list
   set l_cascade_counter_list $l_cascade_list
}

##
# function returns a dictionary where the possible combinations of reference clock frequencies and counter settings are listed for a given output frequency
# @param[in] f_out - desired pll output frequency
# @param[in] l_enable - if l counter is enabled calculations are made for GX o.w for GT rates
# @return dictionary ---> {status good/bad} {"X.Y" {{param_name1 param_value1} {param_name2 param_value2}...}} {status good/bad} {"Z.T" {{param_name1 param_value1} {param_name2 param_value2}...}}... 
proc ::altera_xcvr_atx_pll_s10::pll_calculations::legality_check_auto { f_out l_enable cascade_enable device_revision find_ref ref_clk } {
   global l_cascade_counter_list
   global l_counter_list
   global n_counter_list
   global m_counter_list
   #set max_pfd $f_max_pfd
   if { $ref_clk == 0 } {
      set find_ref 0
   }
   set temp_l_list [expr { $l_enable ? $l_counter_list : { 1 } }]
   set ret [find_values $ref_clk $f_out $find_ref $temp_l_list $m_counter_list $n_counter_list $l_cascade_counter_list $cascade_enable $device_revision]
   return $ret
}
##
# if a valid combination is found, return the combination of counter settings for the match
# # function returns a dictionary where a combination of reference clock frequency and counter settings are listed for a given output frequency
# @param[in] f_out - desired pll output frequency
# @param[in] f_ref - desired ref clock frequency
# @return dictionary ---> {status good/bad} {"X.Y" {{param_name1 param_value1} {param_name2 param_value2}...}} {status good/bad} {"Z.T" {{param_name1 param_value1} {param_name2 param_value2}...}}... 
proc ::altera_xcvr_atx_pll_s10::pll_calculations::legality_check_fract { f_out f_ref cascade_enable device_revision} {
   global l_cascade_counter_list
   global l_counter_list
   global n_counter_list
   global m_counter_list
   set ref_clk 0
   set find_ref 0

   set ret [find_fractional_counter_values $f_ref $f_out $l_counter_list $m_counter_list $n_counter_list $l_cascade_counter_list $cascade_enable $device_revision] 
   return $ret
}

##
# function returns a dictionary where the output frequency and other pll settings are listed for a given reference clock frequency and counter settings
# @param[in] f_ref - pll reference clock frequency
# @param[in] l_value - l counter for the pll
# @param[in] m_value - m counter for the pll
# @param[in] n_value - n counter for the pll
# @return dictionary ---> {status good/bad} {config {{param_name1 param_value1} {param_name2 param_value2}...}}  
proc ::altera_xcvr_atx_pll_s10::pll_calculations::legality_check_manual { is_fractional f_ref l_value m_value n_value k_value l_cascade_value l_cascade_predivider cascade_enable device_revision} {
   set ret [verify_counter_settings_with_reference_clock $is_fractional $f_ref $l_value $m_value $n_value $k_value $l_cascade_value $cascade_enable $device_revision $l_cascade_predivider]
   return $ret
}

##
# function returns a dictionary where the possible combinations of reference clock frequencies and counter settings are listed for a given output frequency
# @param[in] f_out - desired pll output frequency
# @param[in] f_fb - desired pll feedback frequency
# @param[in] enable_fb_comp - whether unknown external feedback or feedback compensation bonding mode
# @return dictionary ---> {status good/bad} {"X.Y" {{param_name1 param_value1} {param_name2 param_value2}...}} {status good/bad} {"Z.T" {{param_name1 param_value1} {param_name2 param_value2}...}}... 
proc ::altera_xcvr_atx_pll_s10::pll_calculations::legality_check_feedback_auto { f_out f_fb enable_fb_comp l_counter_list l_cascade_counter_list l_cascade_value cascade_enable device_revision} {
   global n_counter_list
   
   set modified_n_counter_list $n_counter_list
   if { $enable_fb_comp } {
      set modified_n_counter_list {1}
      ip_message info "Setting N counter to 1 in feedback compensation bonding mode"
   }
   # else use the full N-counter list

   set ret [find_external_feedback_mode_values $f_out $f_fb $modified_n_counter_list $l_counter_list $l_cascade_counter_list $l_cascade_value $cascade_enable $device_revision]
   return $ret
}

#-----------------------------------------
# INTERNAL FUNCTIONS NOT EXPORTED
#-----------------------------------------

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_max_pfd {} { 
    global max_pfd
	return $max_pfd 
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_min_pfd {} { 
	global min_pfd
	return $min_pfd
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_min_vco {} { 
	global min_vco
	return $min_vco
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_max_vco {} { 
	global max_vco
	return $max_vco
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_min_ref {} { 
    global min_ref
	return $min_ref
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_max_ref {} { 
    global max_ref
	return $max_ref
}


proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_max_x1  {} { 
	global max_x1
	return $max_x1
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_min_tank_0 {} { 
	global min_tank_0
	return $min_tank_0
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_max_tank_0 {} { 
	global max_tank_0
	return $max_tank_0
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_min_tank_1 {} { 
	global min_tank_1
	return $min_tank_1
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_max_tank_1 {} { 
	global max_tank_1
	return $max_tank_1
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_min_tank_2 {} { 
	global min_tank_2
	return $min_tank_2
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_max_tank_2 {} { 
	global max_tank_2
	return $max_tank_2
}

# The proc has three use cases:
#
# 1) find_values $f_ref $f_out 0 $l_counter_list $m_counter_list $n_counter_list 
#
# --> The above case is the classic requirement for the HSSI PLL IP

# The following two use cases are likely not required for now but are available for possible future support
#
# In this use case $f_ref is ignored.  Instead all available reference clocks with their associated l, m, and n counters will be provided
#
# 2) find_values $f_ref $f_out 1 $l_counter_list $m_counter_list $n_counter_list 
#
# Given $f_ref and $f_out loop through all values of counters and provide those settings that fulfill this frequency relationship
#
# For the first two use cases it is assumed that the counter lists being passed in are fully populated with all possible values of the counters
# This next use case will instead assume that only a single value of counter is being passed in ... the idea is that if you provide an $f_out
# and a specific set of counter values you want to check whether an f_ref can be found.

proc ::altera_xcvr_atx_pll_s10::pll_calculations::find_values { f_ref f_out find_ref l_counter_list m_counter_list n_counter_list l_cascade_counter_list cascade_enable device_revision} {
    
	# initialize return status as bad. don't forget to update the status to good once proper settings find
	dict set ret status bad

	if { $cascade_enable } {
		set l_counter_list_to_use_for_calcs $l_cascade_counter_list
	} else {
		set l_counter_list_to_use_for_calcs $l_counter_list
	}
    
	foreach l $l_counter_list_to_use_for_calcs {
	if { $cascade_enable } {
		set vco_divider [::altera_xcvr_atx_pll_s10::pll_calculations::get_vco_divider $l $f_out $device_revision]
		set f_vco [expr $f_out * $l * $vco_divider]
	} else {
		set f_vco [expr $f_out * $l]
		set vco_divider 1
	}
        #ip_message info ":::altera_xcvr_atx_pll_s10::pll_calculations::find_values f_vco $f_vco max [get_f_max_vco] min [get_f_min_vco]"
		if {$f_vco >= [get_f_min_vco] && $f_vco <= [get_f_max_vco]} {
			foreach m $m_counter_list {
				set f_pfd_calc [expr $f_vco / ($m * 2)]
                #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::find_values f_pfd_calc $f_pfd_calc max [get_f_max_pfd] min [get_f_min_pfd]"
				if {$f_pfd_calc >= [get_f_min_pfd] && $f_pfd_calc <= [get_f_max_pfd]} {
					foreach n $n_counter_list {
						set f_ref_calc [expr $f_pfd_calc * $n]
                        #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::find_values f_ref_calc $f_ref_calc max [get_f_max_ref] min [get_f_min_ref]"
						if {$f_ref_calc <= [get_f_max_ref] && $f_ref_calc >= [get_f_min_ref]} {
							if {($find_ref == 1 && $f_ref_calc == $f_ref) || $find_ref == 0} {								
                                dict set ret status good
								set refclk [expr $f_ref_calc/1000000]
                                set refclk [format "%.6f" $refclk];# 6 fractional digits, \open: is it ok for hdl parameters? 
								set refclk_str "$refclk"
                                if { ![dict exists $ret $refclk_str] } {
								   dict set ret $refclk_str m $m
                                   dict set ret $refclk_str effective_m $m
								   dict set ret $refclk_str n $n
								   if { $cascade_enable } {
								      dict set ret $refclk_str l_cascade $l
								      dict set ret $refclk_str l 1
								      dict set ret $refclk_str l_cascade_predivider $vco_divider
									  #puts "(cascade) Setting l_cascade: '[dict get $ret $refclk_str l_cascade]'"
									  #puts "(cascade) Setting l: '[dict get $ret $refclk_str l]'"
								   } else {
								      dict set ret $refclk_str l $l
								      dict set ret $refclk_str l_cascade 1
								      dict set ret $refclk_str l_cascade_predivider $vco_divider
									  #puts "(non-cascade) Setting l_cascade: '[dict get $ret $refclk_str l_cascade]'"
									  #puts "(non-cascade) Setting l: '[dict get $ret $refclk_str l]'"
									}
								   dict set ret $refclk_str k 1
                                   set tank_sel [get_tank_sel [get_f_vco $f_out $l]]  
                                   dict set ret $refclk_str tank_sel $tank_sel
                                   dict set ret $refclk_str tank_band [get_tank_band [get_f_vco $f_out $l] [get_f_min_tank $tank_sel] [get_f_increment_tank $tank_sel]]
                                   #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::find_values single-freq(1/0): $find_ref fref: $f_ref_calc n: $n  l: $l  m: $m"
                                   #puts "fref: '$refclk' f_out: '$f_out' n: $n  l: $l  m: $m"
                                } else {
                                   # If refclk repeats with different counter settings ignore it, as the first setting found will be optimal
                                   #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::find_values refclk already exists"
                                }
							}							
						}
					}
				}
			}
		}
	}
	return $ret
}


proc ::altera_xcvr_atx_pll_s10::pll_calculations::find_fractional_counter_values { f_ref f_out l_counter_list m_counter_list n_counter_list l_cascade_counter_list cascade_enable device_revision} {

	dict set ret status bad
	set target_found 0
	regsub -all ":" $l_cascade_counter_list " " l_cascade_counter_list 
	regsub -all ":" $l_counter_list " " l_counter_list 
	regsub -all ":" $n_counter_list " " n_counter_list 

	if { $cascade_enable } {
		set l_counter_list_to_use_for_calcs $l_cascade_counter_list
	} else {
		set l_counter_list_to_use_for_calcs $l_counter_list
	}

	foreach l $l_counter_list_to_use_for_calcs {
		if { $cascade_enable } {
			set vco_divider [::altera_xcvr_atx_pll_s10::pll_calculations::get_vco_divider $l $f_out $device_revision]
			set f_vco [expr $f_out * $l * $vco_divider]
		} else {
			set f_vco [expr $f_out * $l]
			set vco_divider 1
		}
		set f_min_vco [get_f_min_vco]
		set f_max_vco [get_f_max_vco]

        #puts "f min vco is $f_min_vco"
        #puts "f max vco is $f_max_vco"
        	
        #puts "f max pfd is "
		#puts [get_f_max_pfd]
        #puts "f min pfd is "
		#puts [get_f_min_pfd]

        #puts "f max ref is "
		#puts [get_f_max_ref]
        #puts "f min ref is "
		#puts [get_f_min_ref]

		#puts "l: '$l'"
		#puts "f_out: '$f_out'"
		#puts "f_vco: '$f_vco'"

		if {$f_vco >= [get_f_min_vco] && $f_vco <= [get_f_max_vco]} {
			#puts "--> Cond 1"
			foreach n $n_counter_list {
				#puts "--> Cond 1"
				set f_pfd_calc [expr $f_ref / $n]
				if {$f_pfd_calc <= [get_f_max_pfd] && $f_pfd_calc >= [get_f_min_pfd]} {
					#puts "--> Cond 2"
					set m_value [find_m_for_fractional $l $n $f_out $f_ref]
						set m $m_value
						# We want to determine the worst case f_pfd in fractional mode.  In fractional the value of M will dither between -3 and +4 from the set value.
						# This dithering could cause the instantaneous frequency out of the M counter (on the PFD side) to exceed the f_max_pfd in fractional mode.
						# The f_max_pfd in fractional mode is actually tuned to not exceed the Fmax of the DSM ... since the DSM is actually clocked by the output of the
						# M counter this is all a common frequency.  i.e. Fpfd is the frequency out of the M counter and the frequency in to the DSM engine.  
						# We want to insure that the selection of M counter does not violate the Fmax in of the DSM.
            			set f_vco_calc [expr $f_pfd_calc * 2 * $m_value]
						set lowest_frac_m [expr $m - 3]
			            set twice_lowest_frac_m [expr $lowest_frac_m * 2]
			            set highest_frac_pfd_freq [expr $f_vco_calc / $twice_lowest_frac_m  ]
						if {$m > 0 && $highest_frac_pfd_freq <= [get_f_max_pfd] } {
							set k [find_fractional $l $n $m $f_out $f_ref]
							if {$k > 0} {
								set frac [expr (($k/4294967296)*100)]
								#puts "FOUND refclk: '$f_ref' Fout: '$f_out' n: $n  l: $l  m: $m  k: $k";

						        set f_ref_calc [expr $f_pfd_calc * $n]

                                dict set ret status good
								set refclk [expr $f_ref_calc/1000000]
                                set refclk [format "%.6f" $refclk];# 6 fractional digits, \open: is it ok for hdl parameters? 
								set refclk_str "$refclk"

                                if { ![dict exists $ret $refclk_str] } {
								    dict set ret $refclk_str m $m
                                    dict set ret $refclk_str effective_m $m
								    dict set ret $refclk_str n $n
								    if { $cascade_enable } {
								       dict set ret $refclk_str l_cascade $l
								       dict set ret $refclk_str l 1
								       dict set ret $refclk_str l_cascade_predivider $vco_divider
							            } else {
								    dict set ret $refclk_str l $l
								       dict set ret $refclk_str l_cascade 1
								       dict set ret $refclk_str l_cascade_predivider $vco_divider
							            }
								    dict set ret $refclk_str k $k

                                    set tank_sel [get_tank_sel [get_f_vco $f_out $l]]  
                                    dict set ret $refclk_str tank_sel $tank_sel
                                    dict set ret $refclk_str tank_band [get_tank_band [get_f_vco $f_out $l] [get_f_min_tank $tank_sel] [get_f_increment_tank $tank_sel]]
								} else {
								
                                }								
								set target_found 1
								return $ret;
							} else {
								#puts "--> NOTE: k value = 0"
							}
						} else {
							#puts "--> NOTE: m value = 0"
						}
				} else {
					#puts "Failed Conditional 2"
				}
			}
		} else {
			#puts "Failed conditional 1"
		}
	}
	if {$target_found < 1} {
		#puts "FAILED refclk: '$f_ref' Fout: '$f_out'"
	}

	#puts "fractional m is $m_counter_list"
	#puts "fractional n is $n_counter_list"
	#puts "fractional l is $l_counter_list"

	return $ret;
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::find_m_for_fractional { l_counter n_counter out_freq refclk } {

	#puts "************************************************"

	set rhs_base [expr 2 * $refclk];

	set fixed_compare [expr $l_counter * $n_counter * $out_freq];

	set not_done 0;
	set iteration 1;
	set return_value 0

	set m_counter_list [get_m_counter_list] 
	set m_counter_list_len [llength $m_counter_list]
	for {set index 0} {$index < $m_counter_list_len} { incr index } {

		set m_counter [lindex $m_counter_list $index]
		
		if {$index < [expr $m_counter_list_len -1]} {
			set next_index [expr $index + 1]
		} else {
			set next_index $index
		}
		set m_counter_next [lindex $m_counter_list $next_index]

		set rhs [expr $rhs_base * $m_counter]
		set rhs_plus_one [expr $rhs_base * $m_counter_next]

		#puts "m value: '$m_counter'"
		#puts "fixed_compare: '$fixed_compare'"
		#puts "rhs: '$rhs'"
		#puts "rhs_plus_one: '$rhs_plus_one'"

# Some notes: This code will be dependent on the ordering of the m_counter list.  If it is ordered low to high the conditional will need to be set appropriately.

		if { $m_counter > $m_counter_next } {
			if {$fixed_compare < $rhs && $fixed_compare >= $rhs_plus_one} {
				set return_value $m_counter_next
			}
		} else {
			if {$fixed_compare >= $rhs && $fixed_compare < $rhs_plus_one} {
				set return_value $m_counter
			}
		}
	}
	return $return_value;
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::find_fractional { l_counter n_counter m_counter out_freq refclk } {

	set multiplier 4294967296
	set two_to_thirty_one 2147483648

	set fractional_value [expr ((($out_freq * $n_counter * $l_counter * $two_to_thirty_one)/$refclk) - ($m_counter * $multiplier))]

	set raw_min_fractional_value [ip_get "parameter.atx_pll_min_fractional_percentage.value"]
	set raw_max_fractional_value [ip_get "parameter.atx_pll_max_fractional_percentage.value"]

	set min_fractional_percent [expr $raw_min_fractional_value/100.0]
	set max_fractional_percent [expr $raw_max_fractional_value/100.0]

	set min_fractional_value [expr $min_fractional_percent * 4294967296]
	set max_fractional_value [expr $max_fractional_percent * 4294967296]

	if {$fractional_value < $min_fractional_value} {
		set not_done 0
	} elseif {$fractional_value > $max_fractional_value} {
		set not_done 0
	} else {
		set not_done 1
	}

	if {$not_done < 1} {
		return 0
	} else {
        set fractional_value [expr round(floor($fractional_value))]
        # puts "fractional_value=$fractional_value"
		return $fractional_value
	}
}

# TODO Are manual calculations similar for fractional and integer mode ?
# This proc will be used to return the Fout produced when the user specifies Fref and the counter values
proc ::altera_xcvr_atx_pll_s10::pll_calculations::verify_counter_settings_with_reference_clock { is_fractional f_ref l_value m_value n_value k_value l_cascade_value cascade_enable device_revision l_cascade_predivider} {
	# initialize return status as bad. don't forget to update the status to good once proper settings find
	dict set ret status bad
        #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::verify_counter_settings_with_reference_clock f_ref $f_ref max [get_f_max_ref] min [get_f_min_ref]"
    
    set f_min_ref [get_f_min_ref]
    set f_max_ref [get_f_max_ref]
    set f_min_pfd [get_f_min_pfd]
    set f_max_pfd [get_f_max_pfd]
    set f_min_vco [get_f_min_vco]
    set f_max_vco [get_f_max_vco]

	set multiplier 4294967296
	set two_to_thirty_one 2147483648

	set min_fractional_value [expr .05 * 4294967296]
	set max_fractional_value [expr .95 * 4294967296]

    #puts "fmin=$f_min_ref"
    #puts "fmax=$f_max_ref"
    #puts "f_min_pfd=$f_min_pfd"
    #puts "f_max_pfd=$f_max_pfd"
    #puts "f_min_vco=$f_min_vco"
    #puts "f_max_vco=$f_max_vco"

    if { $cascade_enable } {
       set l_counter_value_to_use_for_calcs $l_cascade_value
    } else {
       set l_counter_value_to_use_for_calcs $l_value
    }
    if { $is_fractional } {
        if {$f_ref >= [get_f_min_ref] && $f_ref <= [get_f_max_ref]} {
            set f_pfd_calc [expr $f_ref / $n_value]
            #puts "f_pfd_calc=$f_pfd_calc"
			# See discussion above regarding the dithering of M in fractional for the reasons behind the next few lines (search file for 'dithering')
            set f_vco_calc [expr $f_pfd_calc * 2 * $m_value]
			set lowest_frac_m [expr $m_value - 3]
			set twice_lowest_frac_m [expr $lowest_frac_m * 2]
			set highest_frac_pfd_freq [expr $f_vco_calc / $twice_lowest_frac_m  ]
			#puts "highest_frac_pfd_freq: '$highest_frac_pfd_freq'"
            if {$f_pfd_calc >= [get_f_min_pfd] && $f_pfd_calc <= [get_f_max_pfd] && $highest_frac_pfd_freq <= [get_f_max_pfd]} {
                set temp_out_freq [expr $f_vco_calc/$l_value]
                #puts "fvco calc = $f_vco_calc"
                #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::verify_counter_settings_with_reference_clock f_vco_calc $f_vco_calc max [get_f_max_vco] min [get_f_min_vco]"
				set min_vco [get_f_min_vco]
				set max_vco [get_f_max_vco]
				#puts "--> $min_vco: '$min_vco'"
				#puts "--> $max_vco: '$max_vco'"
				#puts "--> $f_vco_calc: '$f_vco_calc'"
                if {$f_vco_calc >= [get_f_min_vco] && $f_vco_calc <= [get_f_max_vco]} {
                    dict set ret status good				
    				if { $cascade_enable } {
#						set vco_divider [::altera_xcvr_atx_pll_s10::pll_calculations::get_vco_divider $l_counter_value_to_use_for_calcs $temp_out_freq $device_revision]
                        ::altera_xcvr_atx_pll_s10::pll_calculations::verify_l_cascade_predivider $device_revision $l_counter_value_to_use_for_calcs $f_vco_calc $l_cascade_predivider 

						set vco_divider $l_cascade_predivider
                    	set out_freq [expr (($k_value + ($m_value * $multiplier)) * $f_ref) /  ($l_counter_value_to_use_for_calcs * $vco_divider * $n_value * $two_to_thirty_one)]
					} else {
                    	set out_freq [expr (($k_value + ($m_value * $multiplier)) * $f_ref) /  ($l_counter_value_to_use_for_calcs * $n_value * $two_to_thirty_one)]
					}
	                #set fractional_value [expr ((($out_freq * $n_counter * $l_counter * $two_to_thirty_one)/$refclk) - ($m_counter * $multiplier))]


                    set out_freq_MHz [expr $out_freq/1000000]
                    set out_freq_MHz [format "%.6f" $out_freq_MHz];# 6 fractional digits, \open: is it ok for hdl parameters?
                    dict set ret config out_freq "$out_freq_MHz MHz"
                    set tank_sel [get_tank_sel [get_f_vco $out_freq $l_counter_value_to_use_for_calcs]]
                    dict set ret config tank_sel $tank_sel 
                    dict set ret config tank_band [get_tank_band [get_f_vco $out_freq $l_counter_value_to_use_for_calcs] [get_f_min_tank $tank_sel] [get_f_increment_tank $tank_sel]]
                    #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::verify_counter_settings_with_reference_clock out: $out_freq MHz"				
                }
            }
        }
        return $ret
    } else {
        if {$f_ref >= [get_f_min_ref] && $f_ref <= [get_f_max_ref]} {
            set f_pfd_calc [expr $f_ref / $n_value]
            #puts "f_pfd_calc=$f_pfd_calc"
            if {$f_pfd_calc >= [get_f_min_pfd] && $f_pfd_calc <= [get_f_max_pfd]} {
                set f_vco_calc [expr $f_pfd_calc * 2 * $m_value]
                set temp_out_freq [expr $f_vco_calc/$l_value]
                #puts "fvco calc = $f_vco_calc"
                #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::verify_counter_settings_with_reference_clock f_vco_calc $f_vco_calc max [get_f_max_vco] min [get_f_min_vco]"
				set min_vco [get_f_min_vco]
				set max_vco [get_f_max_vco]
				#puts "--> $min_vco: '$min_vco'"
				#puts "--> $max_vco: '$max_vco'"
				#puts "--> $f_vco_calc: '$f_vco_calc'"
                if {$f_vco_calc >= [get_f_min_vco] && $f_vco_calc <= [get_f_max_vco]} {
                    dict set ret status good				
    				if { $cascade_enable } {
#						set vco_divider [::altera_xcvr_atx_pll_s10::pll_calculations::get_vco_divider $l_counter_value_to_use_for_calcs $temp_out_freq $device_revision]
                        ::altera_xcvr_atx_pll_s10::pll_calculations::verify_l_cascade_predivider $device_revision $l_counter_value_to_use_for_calcs $f_vco_calc $l_cascade_predivider 
						set vco_divider $l_cascade_predivider
                    	set out_freq [expr $f_vco_calc/($l_counter_value_to_use_for_calcs * $vco_divider)]
					} else {
                    	set out_freq [expr $f_vco_calc/$l_counter_value_to_use_for_calcs]
					}
                    set out_freq_MHz [expr $out_freq/1000000]
                    set out_freq_MHz [format "%.6f" $out_freq_MHz];# 6 fractional digits, \open: is it ok for hdl parameters?
                    dict set ret config out_freq "$out_freq_MHz MHz"
                    #puts "Found out freq: '$out_freq_MHz MHz'"
                    set tank_sel [get_tank_sel [get_f_vco $out_freq $l_counter_value_to_use_for_calcs]]
                    dict set ret config tank_sel $tank_sel 
                    dict set ret config tank_band [get_tank_band [get_f_vco $out_freq $l_counter_value_to_use_for_calcs] [get_f_min_tank $tank_sel] [get_f_increment_tank $tank_sel]]
                    #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::verify_counter_settings_with_reference_clock out: $out_freq MHz"				
                }
            }
        }
        return $ret
    }
}

# This proc returns in the same way as find_values proc, except this one is used for external feedback clock modes hence uses a different algorithm
# n counter list input is determined by the caller based on feedback modes 
proc ::altera_xcvr_atx_pll_s10::pll_calculations::find_external_feedback_mode_values { f_out f_fb n_counter_list l_counter_list l_cascade_counter_list l_cascade_value cascade_enable device_revision} {
   #global l_counter_list

   # initialize return status as bad. don't forget to update the status to good once proper settings find
   dict set ret status bad

   # Going to select the first legal l value found 
   set l_value 0
   set n_value 0

   foreach l $l_counter_list {
      if {$l_value == 0} {
         set f_vco [expr $f_out * $l]
         if {$f_vco >= [get_f_min_vco] && $f_vco <= [get_f_max_vco]} {
            set l_value $l
         }
      }
   }

   if {$l_value != 0} {#when a proper l value found, continue
      foreach n $n_counter_list {
         set f_ref_calc [expr $f_fb * $n]
         if {$f_ref_calc <= [get_f_max_pfd] && $f_ref_calc >= [get_f_min_pfd]} {
            set m_calc [expr ($f_out * $l_value) / ($f_fb * 2) ]
            set n_value $n
            #puts "$f_ref_calc n: $n_value  l: $l_value  m: $m_calc";
            dict set ret status good
            set refclk [expr $f_ref_calc/1000000]
            set refclk [format "%.6f" $refclk];# 6 fractional digits, \open: is it ok for hdl parameters? 
            set refclk_str "$refclk"
            if { ![dict exists $ret $refclk_str] } {
               #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::find_external_feedback_mode_values:: In external feedback clock mode(s), value of M counter is irrelevant, setting it to 10"
#               dict set ret $refclk_str m 10
               dict set ret $refclk_str m $m_calc 
               dict set ret $refclk_str effective_m $m_calc
               dict set ret $refclk_str n $n_value
               dict set ret $refclk_str l $l_value
               # Since we don't make use of the l_cascade in feedback bonding mode just set this to 1 as a placeholder
               dict set ret $refclk_str l_cascade 1
	       dict set ret $refclk_str l_cascade_predivider 1
               dict set ret $refclk_str k 1
               set tank_sel [get_tank_sel [get_f_vco $f_out $l_value]]  
               dict set ret $refclk_str tank_sel $tank_sel
               dict set ret $refclk_str tank_band [get_tank_band [get_f_vco $f_out $l_value] [get_f_min_tank $tank_sel] [get_f_increment_tank $tank_sel]]
               #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::find_values single-freq(1/0): $find_ref fref: $f_ref_calc n: $n  l: $l  m: $m"
            } else {
               # If refclk repeats with different counter settings ignore it, as the first setting found will be optimal
               #ip_message info "::altera_xcvr_atx_pll_s10::pll_calculations::find_values refclk already exists"
            }
         }
      }
   }


   return $ret
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_vco { f_out l } {
	set f_vco [expr $f_out * $l]
	return $f_vco
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_tank_sel { vco_freq } { 
	set tank_sel "lctank0"
	if {$vco_freq < [get_f_max_tank_0]} {
		set tank_sel "lctank0"
	} elseif {$vco_freq >= [get_f_max_tank_0] && $vco_freq < [get_f_max_tank_1]} {
		set tank_sel "lctank1"
	} elseif {$vco_freq >= [get_f_max_tank_1] && $vco_freq <= [get_f_max_tank_2]} {
		set tank_sel "lctank2"
	}
	return $tank_sel
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_min_tank { tank_sel } {
	set f_min_tank 0
	if {$tank_sel == "lctank0"} {
		set f_min_tank [get_f_min_tank_0]
	} elseif {$tank_sel == "lctank1"} {
		set f_min_tank [get_f_min_tank_1]
	} elseif {$tank_sel == "lctank2"} {
		set f_min_tank [get_f_min_tank_2]
	}
	return $f_min_tank
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_f_increment_tank { tank_sel } {
	set f_increment_tank 0
	if {$tank_sel == "lctank0"} {
		set f_increment_tank [expr ([get_f_max_tank_0] - [get_f_min_tank_0]) / 7]
	} elseif {$tank_sel == "lctank1"} {
		set f_increment_tank [expr ([get_f_max_tank_1] - [get_f_min_tank_1]) / 7]
	} elseif {$tank_sel == "lctank2"} {
		set f_increment_tank [expr ([get_f_max_tank_2] - [get_f_min_tank_2]) / 7]
	}
	return $f_increment_tank
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_tank_band { vco_freq f_min_tank f_increment_tank } {
	set tank_band "lc_band0"
	if {$vco_freq < ($f_min_tank + $f_increment_tank)} {
		set tank_band "lc_band0"
	} elseif {$vco_freq >= ($f_min_tank + $f_increment_tank) && $vco_freq < ($f_min_tank + ($f_increment_tank * 2))} {
		set tank_band "lc_band1"
	} elseif {$vco_freq >= ($f_min_tank + $f_increment_tank) && $vco_freq < ($f_min_tank + ($f_increment_tank * 3))} {
		set tank_band "lc_band2"
	} elseif {$vco_freq >= ($f_min_tank + $f_increment_tank) && $vco_freq < ($f_min_tank + ($f_increment_tank * 4))} {
		set tank_band "lc_band3"
	} elseif {$vco_freq >= ($f_min_tank + $f_increment_tank) && $vco_freq < ($f_min_tank + ($f_increment_tank * 5))} {
		set tank_band "lc_band4"
	} elseif {$vco_freq >= ($f_min_tank + $f_increment_tank) && $vco_freq < ($f_min_tank + ($f_increment_tank * 6))} {
		set tank_band "lc_band5"
	} elseif {$vco_freq >= ($f_min_tank + $f_increment_tank) && $vco_freq < ($f_min_tank + ($f_increment_tank * 7))} {
		set tank_band "lc_band6"
	}
	return $tank_band
}

## \open l_counter enable currently is used as a parameter in GUI? 
proc ::altera_xcvr_atx_pll_s10::pll_calculations::l_counter_enable_rule { f_out } {
	set return_value "TRUE"
	if {$f_out > [get_f_min_vco]} {
		set return_value "FALSE"
	}
	return $return_value
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_vco_divider { l out_freq device_revision } {
	set vco_divider 1
#	set rbc_predivider [::ct1_atx_pll::parameters::validate_atx_pll_fpll_refclk_selection 1 1 $device_revision $l $out_freq "hssi_cascade" "basic_tx"]
	set rbc_predivider [::ct1_atx_pll::parameters::getValue_atx_pll_fpll_refclk_selection $device_revision $l $out_freq "hssi_cascade" "basic_tx"]
# Hack warning!  Need to get the just below working ... just getting sleepy
    if { $rbc_predivider == "select_div_by_2" } {
		set vco_divider 2
    }
	return $vco_divider
}

proc ::altera_xcvr_atx_pll_s10::pll_calculations::verify_l_cascade_predivider { device_revision l_cascade_counter vco_freq l_cascade_predivider } {
    regsub -nocase -all {\m(\D)} $vco_freq "" vco_freq
	set out_freq [expr ($vco_freq / $l_cascade_counter)]
	#puts "vco_freq: '$vco_freq'  out_freq: '$vco_freq' l_counter: '$l_cascade_counter'"
#    set legal_values [::ct1_atx_pll::parameters::validate_atx_pll_fpll_refclk_selection 0 0 $device_revision $l_cascade_counter $out_freq "hssi_cascade" "basic_tx"]
    set legal_values [::ct1_atx_pll::parameters::getValue_atx_pll_fpll_refclk_selection $device_revision $l_cascade_counter $out_freq "hssi_cascade" "basic_tx"]
    if {$legal_values == "select_vco_output"} {
	   set gui_legal_val 1
    } else {
	   set gui_legal_val 2
    }

	#puts "set l_predivide: $l_cascade_predivider"
	#puts "determined predivider: $gui_legal_val"
#    auto_invalid_value_message error "l_cascade_predivider" $l_cascade_predivider $gui_legal_val { device_revision l_cascade_counter out_freq prot_mode_fnl set_l_cascade_predivider select_manual_config}
    auto_invalid_value_message error "l_cascade_predivider" $l_cascade_predivider $gui_legal_val { }
    ::altera_xcvr_atx_pll_s10::parameters::manual_value_out_of_range_message error "l_cascade_predivider" $l_cascade_predivider $gui_legal_val 
}

## \open find out the mapped hdl parameter
## \Case:151184 hardcode hclk_divide to "10" for m_value= 40/50
#proc ::altera_xcvr_atx_pll_s10::pll_calculations::get_hclk_divide { m_value } {
#	set hclk_divide "0"
#	if {$m_value == 40 || $m_value == 50} {
#		set hclk_divide "10" 
#	} else	{
#		set hclk_divide "1" 
#	}
#	return $hclk_divide
#}

# \open will be updated eventually
# caliberation_mode = "CAL_OFF"
# lc_mode = "LCCMU_NORMAL"
# lc_atb = "ATB_SELECTDISABLE"
# cp_compensation_enable = "TRUE"
# cp_current_setting = "0" --> Should modify this to be an enum in the atom map
# cp_testmode = "CP_NORMAL"
# cp_lf_3rd_pole_freq = "LF_3RD_POLE_SETTING0"
# cp_lf_4rd_pole_freq = "LF_4RD_POLE_SETTING0"
# cp_lf_order = "LF_2ND_ORDER"
# lf_resistance = "0" --> Should modify this to be an enum in the atom map
# lf_ripplecap = "LF_RIPPLE_CAP"
# d2a_voltage = "D2A_DISABLE"
# dsm_mode = "DSM_MODE_INTEGER"
# dsm_out_sel = "PLL_DSM_DISABLE"
# dsm_ecn_bypass = "FALSE"
# dsm_ecn_test_en = "FALSE"
# fb_select = "???" --> Set by UI
# iqclk_mux_sel = "POWER_DOWN"
# vco_bypass_enable = "FALSE"
# l_counter --> Set by rule
# l_counter_enable --> Set by rule
# cascadeclk_test = "CASCADETEST_OFF"
# hclk_divide --> Set by rule
# m_counter --> Set by rule
# ref_clk_div --> Set by rule
# tank_sel --> Set by rule
# tank_band --> Set by rule
# tank_voltage_coarse = "VREG_SETTING_COARSE1"
# tank voltage_fine = "VREG_SETTING3"
# output_regulator_supply = "VREG1V_SETTING1"
# overrange_voltage = "OVER_SETTING3"
# underrange_voltage = "UNDER_SETTING3"
# vreg0_output = "VCCDREG_NOMINAL"
# vreg1_output = "VCCDREG_NOMINAL"
# bw_sel --> Set by UI
# cgb_div --> Set by UI
# is_cascaded_pll --> Perhaps set by UI
# pma_width --> Set by UI
# output_clock_frequency --> Set by UI
# prot_mode --> Set by UI
# reference_clock_frequency --> Set by UI
# silicon_rev --> Set by UI
# speed_grade --> Set by UI
# use_default_base_address = "??"
# user_base_address = "??"

 
