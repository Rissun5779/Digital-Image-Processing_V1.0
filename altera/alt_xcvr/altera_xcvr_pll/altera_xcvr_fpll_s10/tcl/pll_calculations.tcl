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

package provide altera_xcvr_cmu_fpll_s10::pll_calculations 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::gui::messages
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common

namespace eval ::altera_xcvr_cmu_fpll_s10::pll_calculations:: {
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
  global c_counter_list 

  global max_pfd
  global min_pfd
  global max_vco
  global min_vco
  global max_ref
  global min_ref
  global f_max_x1

}

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::set_calc_constants { f_max_pfd f_min_pfd f_max_vco f_min_vco f_max_ref f_min_ref m_list n_list l_list c_list} {
  global max_pfd
  global min_pfd
  global max_vco
  global min_vco
  global max_ref
  global min_ref
  global m_counter_list
  global n_counter_list
  global l_counter_list
  global c_counter_list

  set max_pfd    $f_max_pfd
  set min_pfd    $f_min_pfd
  set max_vco    $f_max_vco
  set min_vco    $f_min_vco
  set max_ref    $f_max_ref 
  set min_ref    $f_min_ref
  set m_counter_list $m_list
  set n_counter_list $n_list
  set l_counter_list $l_list
  set c_counter_list $c_list
}


##
# function returns a dictionary where the possible combinations of reference clock frequencies and counter settings are listed for a given output frequency
# @param[in] f_out - desired pll output frequency
# @param[in] l_enable - if l counter is enabled calculations are made for GX o.w for GT rates
# @return dictionary ---> {status good/bad} {"X.Y" {{param_name1 param_value1} {param_name2 param_value2}...}} {status good/bad} {"Z.T" {{param_name1 param_value1} {param_name2 param_value2}...}}... 
proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::legality_check_auto {f_out l_enable mode device_revision set_prot_mode} {
  global l_counter_list
  global c_counter_list
  global n_counter_list
  global m_counter_list
  global c_counter_list
  
  #set max_pfd $f_max_pfd
  set ref_clk 0
  set find_ref 0
  
  if {$mode != 2} {;# core and cascade mode 
    set ret [find_values $ref_clk $f_out $find_ref $c_counter_list $m_counter_list $n_counter_list $mode $device_revision $set_prot_mode]
  } else {;# XCVR mode 
    set temp_l_list [expr { $l_enable ? $l_counter_list : { 1 } }]
    set ret [find_values $ref_clk $f_out $find_ref $temp_l_list $m_counter_list $n_counter_list $mode $device_revision $set_prot_mode]
  }
  return $ret
}
##
# if a valid combination is found, return the combination of counter settings for the match
# # function returns a dictionary where a combination of reference clock frequency and counter settings are listed for a given output frequency
# @param[in] f_out - desired pll output frequency
# @param[in] f_ref - desired ref clock frequency
# @return dictionary ---> {status good/bad} {"X.Y" {{param_name1 param_value1} {param_name2 param_value2}...}} {status good/bad} {"Z.T" {{param_name1 param_value1} {param_name2 param_value2}...}}... 
proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::legality_check_fract { f_out f_ref mode device_revision } {
  global l_counter_list
  global n_counter_list
  global m_counter_list
  global c_counter_list
  set ref_clk 0
  set find_ref 0
  
  #debug 
  if {$mode !=2} {;# core and cascade mode 
    set ret [find_fractional_counter_values $f_ref $f_out $c_counter_list $m_counter_list $n_counter_list $mode $device_revision]

  } else {;# XCVR mode 
    set ret [find_fractional_counter_values $f_ref $f_out $l_counter_list $m_counter_list $n_counter_list $mode $device_revision] 
  }
  return $ret
}

##
# function returns a dictionary where the output frequency and other pll settings are listed for a given reference clock frequency and counter settings
# @param[in] f_ref - pll reference clock frequency
# @param[in] l_value - l counter for the pll
# @param[in] m_value - m counter for the pll
# @param[in] n_value - n counter for the pll
# @return dictionary ---> {status good/bad} {config {{param_name1 param_value1} {param_name2 param_value2}...}}  
proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::legality_check_manual { is_fractional f_ref l_value m_value n_value k_value } {
   set ret [verify_counter_settings_with_reference_clock $is_fractional $f_ref $l_value $m_value $n_value $k_value]
   return $ret
}

#-----------------------------------------
# INTERNAL FUNCTIONS NOT EXPORTED
#-----------------------------------------

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_f_max_pfd {} { 
  global max_pfd
	return $max_pfd 
}

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_f_min_pfd {} { 
	global min_pfd
	return $min_pfd
}

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_f_min_vco {} { 
	global min_vco
	return $min_vco
}

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_f_max_vco {} { 
	global max_vco
	return $max_vco
}

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_f_min_ref {} { 
  global min_ref
	return $min_ref
}

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_f_max_ref {} { 
  global max_ref
	return $max_ref
}


proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_f_max_x1  {} { 
	global max_x1
	return $max_x1
}

# This procedure calculates the phase mux prst and prst values based on the phase shift 
proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::compute_phase_shift { f_out initial_phase phase_units f_vco } {
  
  dict set ret prst 300
  dict set ret ph_mux_prst 300

  if { $phase_units == "degrees" } {
    # compute the number of vco cycles in requested initial phase 
    set vco_cycles [format "%.4f" [expr {($f_vco/$f_out)*($initial_phase/360)}]]
  } else {
    set vco_cycles [format "%.4f" [expr {$initial_phase*$f_vco/1000000}]]
  }

  set vco_cycles_int [expr round($vco_cycles)]
  set vco_period [format "%.4f" [expr 1000000/$f_vco]]

  set actual_phase_shift [format "%.4f" [expr $vco_cycles_int*$vco_period]]
  set prst_value [expr $vco_cycles_int / 4]
  set ph_mux_prst_value [expr $vco_cycles_int % 4]
  
  #puts "vco is $f_vco, out is $f_out\n"
  #puts "vco cycles int is $vco_cycles_int\n"
  #puts "vco cycles is $vco_cycles\n"
  #puts "actual phase shift is $actual_phase_shift\n"

  dict set ret actual_phase_ps $actual_phase_shift
  dict set ret prst $prst_value
  dict set ret ph_mux_prst $ph_mux_prst_value
  
  return $ret
} 


# The proc has three use cases:
#
# 1) find_values $f_ref $f_out 0 $l_or_c_counter_list $m_counter_list $n_counter_list 
#
# --> The above case is the classic requirement for the HSSI PLL IP

# The following two use cases are likely not required for now but are available for possible future support
#
# In this use case $f_ref is ignored.  Instead all available reference clocks with their associated l, m, and n counters will be provided
#
# 2) find_values $f_ref $f_out 1 $l_or_c_counter_list $m_counter_list $n_counter_list 
#
# Given $f_ref and $f_out loop through all values of counters and provide those settings that fulfill this frequency relationship
#
# For the first two use cases it is assumed that the counter lists being passed in are fully populated with all possible values of the counters
# This next use case will instead assume that only a single value of counter is being passed in ... the idea is that if you provide an $f_out
# and a specific set of counter values you want to check whether an f_ref can be found.

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::find_values { f_ref f_out find_ref l_or_c_counter_list m_counter_list n_counter_list mode device_revision set_prot_mode } {
  # Enables these messages to check for VCO, PFD min and max values 
  #ip_message warning "VCO Max is [get_f_max_vco]"
  #ip_message warning "VCO Min is [get_f_min_vco]"
  #ip_message warning "PFD Max is [get_f_max_pfd]"
  #ip_message warning "PFD Min is [get_f_min_pfd]"
  
	# initialize return status as bad. don't forget to update the status to good once proper settings find
	dict set ret status bad
  
  foreach cntr $l_or_c_counter_list {
    #/2 divider in the loop and another /2 divider before the C counters 
    if {$mode !=2} {;# core and cascade mode 
		  set f_vco [expr $f_out * 4 * $cntr]
    } else {;# XCVR mode 
		  set f_vco [expr $f_out * 2 * $cntr]
    }
    #ip_message info ":::altera_xcvr_cmu_fpll_s10::pll_calculations::find_values f_vco $f_vco max [get_f_max_vco] min [get_f_min_vco]"
		
    if {$f_vco >= [get_f_min_vco] && $f_vco <= [get_f_max_vco]} {
		  foreach m $m_counter_list {
				set f_pfd_calc [expr $f_vco / ($m * 2)]
        #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::find_values f_pfd_calc $f_pfd_calc max [get_f_max_pfd] min [get_f_min_pfd]"
				if {$f_pfd_calc >= [get_f_min_pfd] && $f_pfd_calc <= [get_f_max_pfd]} {
					foreach n $n_counter_list {
						set f_ref_calc [expr $f_pfd_calc * $n]
            #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::find_values f_ref_calc $f_ref_calc max [get_f_max_ref] min [get_f_min_ref]"
						if {$f_ref_calc <= [get_f_max_ref] && $f_ref_calc >= [get_f_min_ref]} {
              if {($find_ref == 1 && $f_ref_calc == $f_ref) || $find_ref == 0} {								
                dict set ret status good
						  	set refclk [expr $f_ref_calc/1000000]
                set refclk [format "%.6f" $refclk];# 6 fractional digits, \open: is it ok for hdl parameters? 
						  	set refclk_str "$refclk"
                if { ![dict exists $ret $refclk_str] } {
						  	  dict set ret $refclk_str vco [format "%.2f" [expr $f_vco/1000000]]
						  	  dict set ret $refclk_str pfd [format "%.2f" [expr $f_pfd_calc/1000000]]
						  	  dict set ret $refclk_str m $m
						  		dict set ret $refclk_str n $n
                  if {$mode != 2} {;# set c counter in core and cascade mode
						  		  dict set ret $refclk_str l 1
						  		  dict set ret $refclk_str c $cntr
                  } else { ;# set l counter in XCVR mode
						  		  dict set ret $refclk_str l $cntr
								  if { $set_prot_mode == 1 || $set_prot_mode == 2 || $set_prot_mode == 3 } {
                                                                  # We are forcing the C counter to be set to 5 in order to generate a 500MHz signal out of the C0 counter
                                                                  # PCIE Fvco should be 10GHz
						#			  puts "Setting value of c to '5'"
						  		      dict set ret $refclk_str c 5
							          } else {
						  		      dict set ret $refclk_str c 1
							          }
                  }
						  		dict set ret $refclk_str k 1
                  #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::find_values single-freq(1/0): $find_ref fref: $f_ref_calc n: $n  l: $l  m: $m"
                } else {
                  # If refclk repeats with different counter settings ignore it, as the first setting found will be optimal
                  #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::find_values refclk already exists"
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


proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::find_fractional_counter_values { f_ref f_out l_or_c_counter_list m_counter_list n_counter_list mode device_revision} {
  # Enables these messages to check for VCO, PFD min and max values 
  #ip_message warning "VCO Max is [get_f_max_vco]"
  #ip_message warning "VCO Min is [get_f_min_vco]"
  #ip_message warning "PFD Max is [get_f_max_pfd]"
  #ip_message warning "PFD Min is [get_f_min_pfd]"

	dict set ret status bad
	set target_found 0
	
  foreach cntr $l_or_c_counter_list {
    if {$mode !=2} {;# core and cascade mode 
		  set f_vco [expr $f_out * 4 * $cntr]
          set effective_l_or_c [expr 4 * $cntr]
    } else {;# XCVR mode 
		  set f_vco [expr $f_out * 2 * $cntr]
          set effective_l_or_c [expr 2 * $cntr]      
    }
        #ip_message warning "VCO freq in fractional mode is [expr $f_vco/1000000] MHz"
		set f_min_vco [get_f_min_vco]
		set f_max_vco [get_f_max_vco]

        #ip_message warning "VCO min is [expr $f_min_vco/1000000] MHz and VCO max is [expr $f_max_vco/1000000] MHz"
		if {$f_vco >= [get_f_min_vco] && $f_vco <= [get_f_max_vco]} {
			#puts "--> Cond 1"
			foreach n $n_counter_list {
				#puts "--> Cond 1"
				set f_pfd_calc [expr $f_ref / $n]
                #ip_message warning "PFD freq is [expr $f_pfd_calc/1000000] MHz"

				if {$f_pfd_calc <= [get_f_max_pfd] && $f_pfd_calc >= [get_f_min_pfd]} {
                    # pass the effective l or c counter value for calculations, that way we can keep one procedure for find_m_for_fractional
					set m_value [find_m_for_fractional $effective_l_or_c $n $f_out $f_ref]
                    #ip_message warning "M is $m_value"

					set m $m_value
					if {$m > 0} {
					    set k [find_fractional $effective_l_or_c $n $m $f_out $f_ref]
						if {$k > 0} {
						  set frac [expr (($k/4294967296)*100)]
						  #puts "FOUND refclk: '$f_ref' Fout: '$f_out' n: $n  l: $l  m: $m  k: $k";
						  set f_ref_calc [expr $f_pfd_calc * $n]
              dict set ret status good
							set refclk [expr $f_ref_calc/1000000]
              set refclk [format "%.6f" $refclk];# 6 fractional digits, \open: is it ok for hdl parameters? 
							set refclk_str "$refclk"

              if { ![dict exists $ret $refclk_str] } {
							  dict set ret $refclk_str vco [format "%.2f" [expr $f_vco/1000000]]
							  dict set ret $refclk_str pfd [format "%.2f" [expr $f_pfd_calc/1000000]]
							  dict set ret $refclk_str m $m
								dict set ret $refclk_str n $n
                if {$mode != 2} {;# set c counter in core and cascade mode
								  dict set ret $refclk_str c $cntr 
								  dict set ret $refclk_str l 1                  
                } else {
								  dict set ret $refclk_str l $cntr
								  dict set ret $refclk_str c 2
                }

								dict set ret $refclk_str k $k

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

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::find_m_for_fractional { effective_l_or_c n_counter out_freq refclk } {
  
  global m_counter_list 
	#puts "************************************************"

	set rhs_base [expr 2 * $refclk];
  
  set fixed_compare [expr $effective_l_or_c * $n_counter * $out_freq];
  #ip_message warning "Fixed compare is [expr $fixed_compare/1000000] MHz"

	set not_done 0
	set iteration 1
	set return_value 0

  #ip_message warning "M counter list is $m_counter_list"
	set m_counter_list_len [llength $m_counter_list]
  #ip_message warning "M counter len is $m_counter_list_len"
	for {set index 0} {$index < $m_counter_list_len} { incr index } {

		set m_counter [lindex $m_counter_list $index]
		
		if {$index < [expr $m_counter_list_len -1]} {
			set next_index [expr $index + 1]
		} else {
			set next_index $index
		}
		set m_counter_next [lindex $m_counter_list $next_index]
    #ip_message warning "M counter next is $m_counter_next"
		set rhs [expr $rhs_base * $m_counter]
    #ip_message warning "RHS is [expr $rhs/1000000] MHz"


		set rhs_plus_one [expr $rhs_base * $m_counter_next]
    #ip_message warning "RHS plus one is [expr $rhs_plus_one/1000000] MHz"


		#puts "m value: '$m_counter'"
		#puts "fixed_compare: '$fixed_compare'"
		#puts "rhs: '$rhs'"
		#puts "rhs_plus_one: '$rhs_plus_one'"
    if { $m_counter > $m_counter_next } {
			if {$fixed_compare < $rhs && $fixed_compare >= $rhs_plus_one} {
				set return_value $m_counter_next
        #ip_message warning "return value of m1 is $return_value"
			}
		} else {
			if {$fixed_compare >= $rhs && $fixed_compare < $rhs_plus_one} {
				set return_value $m_counter
        #ip_message warning "return value of m2 is $return_value"
			}
		}

	}
	return $return_value
}

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::find_fractional { effective_l_or_c n_counter m_counter out_freq refclk } {

	set multiplier 4294967296
	set two_to_thirty_one 2147483648
  
	set fractional_value [expr ((($out_freq * $n_counter * $effective_l_or_c * $two_to_thirty_one)/$refclk) - ($m_counter * $multiplier))]

  # getting min and max values from a procedure. Eventually these need to be turned into RBCs 
	#set min_fractional_value [expr .05 * 4294967296]
	#set max_fractional_value [expr .95 * 4294967296]
  set min_fractional_value [get_k_counter_limits "min"]
  set max_fractional_value [get_k_counter_limits "max"]

		if {$fractional_value < $min_fractional_value} {
			set not_done 0
		} elseif {$fractional_value > $max_fractional_value} {
			set not_done 0
		} else {
			set not_done 1
		}

	if {$not_done < 1} {
    ip_message error "Violating K limits for auto mode. The most common occurence of this error is when refclk and output frequency combination can be synthesized in integer mode and user has selected fractional mode."
		return 0
	} else {
    set fractional_value [expr round(floor($fractional_value))]
    # puts "fractional_value=$fractional_value"
		return $fractional_value
	}
}

# TODO Are manual calculations similar for fractional and integer mode ?
# This proc will be used to return the Fout produced when the user specifies Fref and the counter values
proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::verify_counter_settings_with_reference_clock { is_fractional f_ref l_value m_value n_value k_value } {
	# initialize return status as bad. don't forget to update the status to good once proper settings find
	dict set ret status bad
        #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::verify_counter_settings_with_reference_clock f_ref $f_ref max [get_f_max_ref] min [get_f_min_ref]"
    
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

    if { $is_fractional } {
        if {$f_ref >= [get_f_min_ref] && $f_ref <= [get_f_max_ref]} {
            set f_pfd_calc [expr $f_ref / $n_value]
            #puts "f_pfd_calc=$f_pfd_calc"
            if {$f_pfd_calc >= [get_f_min_pfd] && $f_pfd_calc <= [get_f_max_pfd]} {
                set f_vco_calc [expr $f_pfd_calc * 2 * $m_value]
                #puts "fvco calc = $f_vco_calc"
                #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::verify_counter_settings_with_reference_clock f_vco_calc $f_vco_calc max [get_f_max_vco] min [get_f_min_vco]"
                if {$f_vco_calc >= [get_f_min_vco] && $f_vco_calc <= [get_f_max_vco]} {
                    dict set ret status good				
                    #set out_freq [expr $f_vco_calc/$l_value]
                    set out_freq [expr (($k_value + ($m_value * $multiplier)) * $f_ref) /  ($l_value * $n_value * $two_to_thirty_one)]
	                #set fractional_value [expr ((($out_freq * $n_counter * $l_counter * $two_to_thirty_one)/$refclk) - ($m_counter * $multiplier))]


                    set out_freq_MHz [expr $out_freq/1000000]
                    set out_freq_MHz [format "%.6f" $out_freq_MHz];# 6 fractional digits, \open: is it ok for hdl parameters?
                    dict set ret config out_freq "$out_freq_MHz MHz"
                    set tank_sel [get_tank_sel [get_f_vco $out_freq $l_value]]
                    dict set ret config tank_sel $tank_sel 
                    dict set ret config tank_band [get_tank_band [get_f_vco $out_freq $l_value] [get_f_min_tank $tank_sel] [get_f_increment_tank $tank_sel]]
                    #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::verify_counter_settings_with_reference_clock out: $out_freq MHz"				
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
                #puts "fvco calc = $f_vco_calc"
                #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::verify_counter_settings_with_reference_clock f_vco_calc $f_vco_calc max [get_f_max_vco] min [get_f_min_vco]"
                if {$f_vco_calc >= [get_f_min_vco] && $f_vco_calc <= [get_f_max_vco]} {
                    dict set ret status good				
                    set out_freq [expr $f_vco_calc/$l_value]
                    set out_freq_MHz [expr $out_freq/1000000]
                    set out_freq_MHz [format "%.6f" $out_freq_MHz];# 6 fractional digits, \open: is it ok for hdl parameters?
                    dict set ret config out_freq "$out_freq_MHz MHz"
                    set tank_sel [get_tank_sel [get_f_vco $out_freq $l_value]]
                    dict set ret config tank_sel $tank_sel 
                    dict set ret config tank_band [get_tank_band [get_f_vco $out_freq $l_value] [get_f_min_tank $tank_sel] [get_f_increment_tank $tank_sel]]
                    #ip_message info "::altera_xcvr_cmu_fpll_s10::pll_calculations::verify_counter_settings_with_reference_clock out: $out_freq MHz"				
                }
            }
        }
        return $ret
    }
}

proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_f_vco { f_out l } {
	set f_vco [expr $f_out * $l]
	return $f_vco
}

# Need to be converted to RBC 
proc ::altera_xcvr_cmu_fpll_s10::pll_calculations::get_k_counter_limits { limit_type } {
  
  if {$limit_type == "min"} {
    set limit_value [expr round(.01 * 4294967296)]
  } elseif {$limit_type == "max"} {
    set limit_value [expr round(.99 * 4294967296)]
  } else {
    ip_message error "call to get_k_counter_limits did not specify limit type. Valid values are min and max."  
  }
  return $limit_value

} 

