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


package provide altera_xcvr_cdr_pll_s10::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common

# The following packages contain parameter data
package require alt_xcvr::utils::reconfiguration_stratix10
package require altera_xcvr_cdr_pll_s10::parameters
package require altera_xcvr_cdr_pll_s10::parameters::data
package require ct1_xcvr_native::parameters
package require ct1_cdr_pll::parameters

# Define the parameters namespace for cdr_pll_s10
namespace eval ::altera_xcvr_cdr_pll_s10::parameters:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*
    namespace import ::alt_xcvr::ip_tcl::messages::*
    
    
    namespace export \
	            declare_parameters \
	            validate \
	            compute_cmu_pll_settings \
	            compute_cdr_pll_settings
    
    variable package_name
    variable display_items
    variable generation_display_items
    variable device_parameters
    variable usr_parameters
    variable tcl_parameters
    variable ip_set_parameters
    variable atom_parameters
    
    set package_name "altera_xcvr_cdr_pll_s10::parameters"
    set display_items [altera_xcvr_cdr_pll_s10::parameters::data::get_variable "display_items"]
    set generation_display_items [altera_xcvr_cdr_pll_s10::parameters::data::get_variable "generation_display_items"]
    
    set device_parameters [altera_xcvr_cdr_pll_s10::parameters::data::get_variable "device_parameters"]
    set tcl_parameters    [altera_xcvr_cdr_pll_s10::parameters::data::get_variable "tcl_parameters"]
    set usr_parameters    [altera_xcvr_cdr_pll_s10::parameters::data::get_variable "usr_parameters"]
    set ip_set_parameters [altera_xcvr_cdr_pll_s10::parameters::data::get_variable "ip_set_parameters"]
    set atom_parameters   [altera_xcvr_cdr_pll_s10::parameters::data::get_variable "atom_parameters"]
    
}

#-----------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------
# Utility procedures 
#-----------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

# Convert range lists to standard TCL lists
proc ::altera_xcvr_cdr_pll_s10::parameters::scrub_list_values { my_list } {

  set new_list {}
  set my_list_len [llength $my_list]

  for {set list_index 0} {$list_index < $my_list_len} { incr list_index } {
	  
    set this_value [lindex $my_list $list_index]

	  if [ regexp {:} $this_value ] then {
	    regsub -all ":" $this_value " " temp_list
	    set start_value [lindex $temp_list 0]
	    set end_value   [lindex $temp_list 1]
	    for {set index $start_value} {$index <= $end_value} { incr index } {
	      lappend new_list $index
	    }
	  } else {
	    lappend new_list $this_value
	  }
  }
  return $new_list
}

# Omit units (Hz) and return the integer converted value
proc ::altera_xcvr_cdr_pll_s10::parameters::omit_units { freq } { 
  regsub -nocase -all {[a-z]*} $freq {} temp
  #return [expr (wide($temp))]
  return $temp
}

# Convert units from mega (10^6) to base (10^0)
proc ::altera_xcvr_cdr_pll_s10::parameters::mega_to_base { val } { 
    #replace anything not a number or DOT character (to account for doubles)
    regsub -nocase -all {\m(\D)} $val "" temp
    set temp [expr {wide(double($temp) * 1000000)}]
    return $temp
}

# Convert freq specified in hz to mhz and return the integer converted value
proc ::altera_xcvr_cdr_pll_s10::parameters::freq_hz_to_mhz { freq } { 
    regsub -nocase -all {\D} $freq "" temp
    set temp [expr {double($temp) / 1000000}]
    return $temp
}

# Use mega_to_base to convert a given parameter in-place. This is used as a callback
proc ::altera_xcvr_cdr_pll_s10::parameters::convert_mhz_to_hz { PROP_NAME PROP_VALUE } {
    set temp [mega_to_base $PROP_VALUE]
    ip_set "parameter.${PROP_NAME}.value" "$temp"
}

# Use mega_to_base to convert a given parameter in-place. This is used as a callback
proc ::altera_xcvr_cdr_pll_s10::parameters::convert_mbps_to_bps { PROP_NAME PROP_VALUE } {
    set temp [mega_to_base $PROP_VALUE]
    ip_set "parameter.${PROP_NAME}.value" "$temp"
}

# Use these functions to print messages in this IP
proc ::altera_xcvr_cdr_pll_s10::parameters::debug_print_list { list_name my_list } {
    set i 0
    foreach j $my_list {
      set pname [lindex $j 0]
      puts "$list_name $i is $pname\n"
      incr i
    }
}

proc ::altera_xcvr_cdr_pll_s10::parameters::debug_print_string { string_name } {
  puts "$string_name\n"
}

#-----------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------
# IP TCL procedures 
#-----------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
# Parameter declaration callback
# Called by the module elaboration callback ::module::declare_module
#-----------------------------------------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::declare_parameters { {device_family "Stratix 10"} } {
    variable display_items
    variable generation_display_items
    variable device_parameters
    variable tcl_parameters
    variable usr_parameters
    variable ip_set_parameters
    variable atom_parameters
    
    # Which parameters are included in reconfig reports is parameter dependent
    ip_add_user_property_type M_RCFG_REPORT integer
    
    # declare_parameters 0 : disable multi-profile support
    # declare_parameters 1 : enable multi-profile support
    ::alt_xcvr::utils::reconfiguration_stratix10::declare_parameters 1

    ip_set "parameter.rcfg_file_prefix.DEFAULT_VALUE" "altera_xcvr_cdr_pll_s10"
    
    ip_declare_parameters [::ct1_cdr_pll::parameters::get_parameters]
    
    # Mark HDL parameters
    set ct1_cdr_pll_parameters [ip_get_matching_parameters [dict set criteria M_IP_CORE ct1_cdr_pll]]
    set mif_exclude [dict create cdr_pll_uc_ro_cal 1 \
                                 cdr_pll_ltd_ltr_micro_controller_select 1 \
                                 cdr_pll_loopback_mode 1 \
                                 cdr_pll_reverse_serial_loopback 1 \
                                 cdr_pll_diag_loopback_enable 1]
    
    foreach param $ct1_cdr_pll_parameters {

	    if {[ip_get "parameter.${param}.M_IS_STATIC_HDL_PARAMETER"] == "false"} {
	      ip_set "parameter.${param}.HDL_PARAMETER" 1
	      if {[dict exist $mif_exclude $param] != 1} {
		    ip_set "parameter.${param}.M_RCFG_REPORT" 1
	      }
	    }

	    ip_set "parameter.${param}.M_AUTOSET"  "true"
	    ip_set "parameter.${param}.M_AUTOWARN" "true"

    }
    
    ip_declare_parameters $tcl_parameters
    ip_declare_parameters $usr_parameters
    ip_declare_parameters $device_parameters
    ip_declare_parameters $ip_set_parameters
    ip_declare_parameters $atom_parameters
    
    ip_declare_display_items $display_items
    
    # 1: Enable the reconfiguration display items 
    ::alt_xcvr::utils::reconfiguration_stratix10::declare_display_items "" tab 1
    ip_declare_display_items $generation_display_items
    
    ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
    ip_set "parameter.device_family.DEFAULT_VALUE" $device_family

    # Initialize revision
    ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
    ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE  

    # Initialize part number
    ip_set "parameter.device.SYSTEM_INFO" DEVICE

    # Grab Quartus INI's
    ip_set "parameter.tcl_enable_advanced_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_cdr_pll_10_advanced ENABLED]
    ip_set "parameter.tcl_enable_debug_options.DEFAULT_VALUE"    [get_quartus_ini altera_xcvr_cdr_pll_10_debug ENABLED]

}

#-----------------------------------------------------------------------------------------------------------------------
# Parameter validation callback
# Called by the module elaboration callback ::module::elaborate
#-----------------------------------------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::validate {} {

  #TODO: remove this message when the IP is mature
  ip_message info "This is the S10 re-write of the CMU PLL IP. Remove this message when the IP is stable" 

  # TODO: this is message valid? 
  ip_message info "Please note that the Stratix 10 Transceiver CMU PLL does not support feedback compensation bonding or xN/x6 clock line usage (bonded or non-bonded modes)."
  
  # Validate all parameters with validation callbacks 
  ip_validate_parameters 

  ip_validate_display_items

}


#----------------------------------------------------------------------------------------------------------------------
# Compute the legal refclk and counter settings for CMU PLL given the user output_clock_frequency	
#  (eq.1) calc_vco = (refclk/ncnt) * mcnt * lpfd
#  (eq.2) output_clock_frequency = calc_vco / lpfd
#  (eq.3) pfd fb_clk = output_clock_frequency / m_cnt
#  (eq.4) refclk/ncnt = pfd fb_clk
#
#  1) Given output_clock_frequency, get vco frequency for each lpfd values and check that the vco frequency is within 
#     f_max_vco and f_min_vco using (eq.2)
#  2) For each legal output_clock_frequency and lpfd pair, calculate the legal m_cnt, n_cnt and refclk using (eq.3) 
#     and (eq.4). Check fb_clk against pfd_f_min and pfd_f_max and refclk against f_min_ref and f_max_ref
#  3) Store the legal set of vco, lpfd, m_cnt, n_cnt, refclk and l_pd_counter in the return dict. 
#     For CMU mode, l_pd is not used and set to 1
#----------------------------------------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::compute_cmu_pll_settings {device_revision \
                                                                      output_clock_frequency_Mhz \
                                                                      tcl_tx_pll_prot_mode \
                                                                      tcl_prot_mode \
                                                                      tcl_support_mode \
                                                                      cdr_pll_f_max_pfd cdr_pll_f_min_pfd \
                                                                      cdr_pll_f_max_vco cdr_pll_f_min_vco \
                                                                      cdr_pll_f_max_ref cdr_pll_f_min_ref \
                                                                      usr_bw_sel} {

  set index 0
  set ret [dict create]
  
  set output_clock_frequency_hz [::altera_xcvr_cdr_pll_s10::parameters::mega_to_base $output_clock_frequency_Mhz]
  
	set prot_mode        $tcl_prot_mode
	set tx_pll_prot_mode $tcl_tx_pll_prot_mode

	#Get counters for CMU mode
	set lpd_counter  [scrub_list_values [::ct1_xcvr_native::parameters::getValue_cdr_pll_lpd_counter  $device_revision "false" \
                                                                                                    $output_clock_frequency_hz  $prot_mode \
                                                                                                    $tcl_support_mode $tx_pll_prot_mode ]]

	set lpfd_counter [scrub_list_values [::ct1_xcvr_native::parameters::getValue_cdr_pll_lpfd_counter $device_revision "false" \
                                                                                                    $lpd_counter \
                                                                                                    $output_clock_frequency_hz  $prot_mode \
                                                                                                    $tcl_support_mode $tx_pll_prot_mode ]]

  set ref_clk_div  [scrub_list_values [::ct1_xcvr_native::parameters::getValue_cdr_pll_n_counter    $device_revision "false" \
                                                                                                    $prot_mode \
                                                                                                    $tx_pll_prot_mode ]]

	set m_counter    [scrub_list_values [::ct1_xcvr_native::parameters::getValue_cdr_pll_mcnt_div     $device_revision "false" \
                                                                                                    $prot_mode \
                                                                                                    $tx_pll_prot_mode]]
  
  set valid_lcnt 0
  set valid_mcnt 0
  set valid_ncnt 0
  
  # Get the min/max frequencies for the vco
  # The vco max/min are returned in terms of datarates, where frequency = datarate/2
  set f_max_vco_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_max_vco  $device_revision $output_clock_frequency_hz \
                                                                                 $prot_mode $tx_pll_prot_mode ] 

  set f_min_vco_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_min_vco  $device_revision $output_clock_frequency_hz \
                                                                                 $prot_mode $tx_pll_prot_mode ] 
  set f_max_vco_mhz [ freq_hz_to_mhz $f_max_vco_hz ]
  set f_min_vco_mhz [ freq_hz_to_mhz $f_min_vco_hz ]
  
  # Get the min/max frequencies for the pfd
  set f_max_pfd_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_max_pfd  $device_revision $usr_bw_sel ] 
  set f_min_pfd_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_min_pfd  $device_revision ] 
  set f_max_pfd_mhz [ freq_hz_to_mhz $f_max_pfd_hz ] 
  set f_min_pfd_mhz [ freq_hz_to_mhz $f_min_pfd_hz ]
  
  # Get the min/max frequencies for the refclk 
  set f_max_ref_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_max_ref  $device_revision ] 
  set f_min_ref_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_min_ref  $device_revision ] 
  set f_max_ref_mhz [ freq_hz_to_mhz $f_max_ref_hz ] 
  set f_min_ref_mhz [ freq_hz_to_mhz $f_min_ref_hz ]

  # Generate a dictionary of legal refclk values and their corresponding l, m, and n counters
  # Generate Error messages for invalid output frequencies by tracking if any valid l,m,n combinations exist
	foreach lpfd $lpfd_counter {

	  set calc_fvco [expr {$output_clock_frequency_Mhz * $lpfd}] 
	  if { ($calc_fvco >= $f_min_vco_mhz) && ($calc_fvco <= $f_max_vco_mhz) } {
		  incr valid_lcnt
      
      foreach mcnt $m_counter {
		    set calc_fbclk [expr {double($output_clock_frequency_Mhz) / $mcnt}]   
		    if { ($calc_fbclk >= $f_min_pfd_mhz) && ($calc_fbclk <= $f_max_pfd_mhz) } {
			    incr valid_mcnt
          
          foreach ncnt $ref_clk_div {
			      set calc_refclk [expr {$calc_fbclk * $ncnt}]
			      if { ($calc_refclk >= $f_min_ref_mhz) && ($calc_refclk <= $f_max_ref_mhz) } { 
		          incr valid_ncnt		    

              set refclk [format "%.6f" $calc_refclk];
				      set refclk_str "$refclk"
				      dict set ret $index refclk $refclk_str
				      dict set ret $index m $mcnt
				      dict set ret $index n $ncnt
				      dict set ret $index lpfd $lpfd
				      dict set ret $index fvco $calc_fvco
				      dict set ret $index lpd $lpd_counter
				      incr index
			      }
			    }
		    }
		  }                    
	  } 
	}

  if { $valid_lcnt == 0 } { 
    ip_message error "The Selected Output Frequency violates VCO min/max constraints" 
  } elseif { $valid_mcnt == 0 } { 
    ip_message error "The Selected Output Frequency violates PFD min/max constraints" 
  } elseif { $valid_ncnt == 0 } { 
    ip_message error "The Selected Output Frequency violates REFCLK min/max constraints" 
  } 
  
  return $ret   
}

#----------------------------------------------------------------------------------------------------------------------
# Computations for CDR mode 
# This procedure is needed only by the native phy validate_l_pll_settings procedure
# TODO: move this to native_phy parameters.tcl and resolve other dependecies such as
#       "mega_to_base" and "freq_hz_to_mhz"
#----------------------------------------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::compute_cdr_pll_settings {device_revision \
                                                                      output_clock_frequency_Mhz \
                                                                      pll_type \
                                                                      pcie_mode \
                                                                      cdr_pll_f_max_pfd cdr_pll_f_min_pfd \
                                                                      cdr_pll_f_max_vco cdr_pll_f_min_vco \
                                                                      cdr_pll_f_max_ref cdr_pll_f_min_ref \
                                                                      usr_bw_sel} {

  set index 0
  set ret [dict create]
  
  set output_clock_frequency_hz [::altera_xcvr_cdr_pll_s10::parameters::mega_to_base $output_clock_frequency_Mhz]
                                                                        
  if {[string compare $pcie_mode "non_pcie" ] == 0 } { 
    set prot_mode "basic_rx"
    set tx_pll_prot_mode "txpll_unused"
  } else {
    set prot_mode $pcie_mode
    set tx_pll_prot_mode "txpll_unused"
  }
  
  #Get counters for CDR mode
  set pd_l_counter  [scrub_list_values [::ct1_xcvr_native::parameters::getValue_cdr_pll_lpd_counter $device_revision "false" \
                                                                                                    $output_clock_frequency_hz $prot_mode \
                                                                                                    "user_mode" $tx_pll_prot_mode]]

  set ref_clk_div   [scrub_list_values [::ct1_xcvr_native::parameters::getValue_cdr_pll_n_counter   $device_revision "false" \
                                                                                                    $prot_mode $tx_pll_prot_mode]]

  set m_counter     [scrub_list_values [::ct1_xcvr_native::parameters::getValue_cdr_pll_mcnt_div    $device_revision "false" \
                                                                                                    $prot_mode $tx_pll_prot_mode]]

  # Get the min/max frequencies for the vco
  # The vco max/min are returned in terms of datarates, where frequency = datarate/2
  set f_max_vco_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_max_vco  $device_revision $output_clock_frequency_hz \
                                                                                 $prot_mode $tx_pll_prot_mode ] 

  set f_min_vco_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_min_vco  $device_revision $output_clock_frequency_hz \
                                                                                 $prot_mode $tx_pll_prot_mode ] 
  set f_max_vco_mhz [ freq_hz_to_mhz $f_max_vco_hz ]
  set f_min_vco_mhz [ freq_hz_to_mhz $f_min_vco_hz ]
  
  # Get the min/max frequencies for the pfd
  set f_max_pfd_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_max_pfd  $device_revision $usr_bw_sel ] 
  set f_min_pfd_hz  [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_min_pfd  $device_revision ] 
  set f_max_pfd_mhz [ freq_hz_to_mhz $f_max_pfd_hz ] 
  set f_min_pfd_mhz [ freq_hz_to_mhz $f_min_pfd_hz ]
  
  # Get the min/max frequencies for the refclk 
  set f_max_ref_hz [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_max_ref  $device_revision ] 
  set f_min_ref_hz [ ::ct1_xcvr_native::parameters::getValue_cdr_pll_f_min_ref  $device_revision ] 
  set f_max_ref_mhz [ freq_hz_to_mhz $f_max_ref_hz ] 
  set f_min_ref_mhz [ freq_hz_to_mhz $f_min_ref_hz ]
  
  
  foreach lpd $pd_l_counter {
      
    set calc_fvco [expr {$output_clock_frequency_Mhz * $lpd}] 
      
	  if { ($calc_fvco >= $f_min_vco_mhz) && ($calc_fvco <= $f_max_vco_mhz) } {
  
      set pfd_l_counter [scrub_list_values [::ct1_xcvr_native::parameters::getValue_cdr_pll_lpfd_counter $device_revision "false" \
                                                                                                         $lpd \
                                                                                                         $output_clock_frequency_hz $prot_mode \
                                                                                                         "user_mode" $tx_pll_prot_mode ]]
  		
      foreach lpfd $pfd_l_counter {
  			set calc_outclk_pfd [expr {double($calc_fvco)/$lpfd}]
  			
        foreach mcnt $m_counter {
  			  set calc_fbclk [expr {double($calc_outclk_pfd) / $mcnt}]    
  
	  	    if { ($calc_fbclk >= $f_min_pfd_mhz) && ($calc_fbclk <= $f_max_pfd_mhz) } {
  				  
            foreach ncnt $ref_clk_div {
  				    set calc_refclk [expr {$calc_fbclk * $ncnt}]
  				    
	  		      if { ($calc_refclk >= $f_min_ref_mhz) && ($calc_refclk <= $f_max_ref_mhz) } { 
  					    
                set refclk [format "%.6f" $calc_refclk];
  					    set refclk_str "$refclk"
  					    
                dict set ret $index refclk $refclk_str
  					    dict set ret $index m $mcnt
  					    dict set ret $index n $ncnt
  					    dict set ret $index lpfd $lpfd
  					    dict set ret $index lpd $lpd
  					    dict set ret $index fvco $calc_fvco

                incr index
  				    }   
  				  }         
  			  }
  			}
  		}       
    }
  }   

  return $ret   

}


#----------------------------------------------------------------------------------------
# TODO: what does set_auto_message_level do?
#----------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::set_message_level { usr_message_level } {

  ::alt_xcvr::ip_tcl::messages::set_auto_message_level $usr_message_level 

}

#----------------------------------------------------------------------------------------
# This callback sets the legal ranges of the user reference clock frequency 
# It is responsible for populating "usr_reference_clock_frequency" in the GUI
#----------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::set_reference_clock_frequency {device_revision \
                                                                           usr_output_clock_frequency \
                                                                           tcl_tx_pll_prot_mode tcl_prot_mode tcl_support_mode \
                                                                           cdr_pll_f_max_pfd cdr_pll_f_min_pfd \
                                                                           cdr_pll_f_max_vco cdr_pll_f_min_vco \
                                                                           cdr_pll_f_max_ref cdr_pll_f_min_ref \
                                                                           usr_bw_sel } {

  set list_of_valid_refclks ""
  
  # $result contains a dictionary of all legal refclk values and their corresponding m/n/l counters 
  # that are determined based on the usr_output_clock_frequency
	set result [compute_cmu_pll_settings $device_revision $usr_output_clock_frequency \
                                       $tcl_tx_pll_prot_mode $tcl_prot_mode $tcl_support_mode \
                                       $cdr_pll_f_max_pfd $cdr_pll_f_min_pfd \
                                       $cdr_pll_f_max_vco $cdr_pll_f_min_vco \
                                       $cdr_pll_f_max_ref $cdr_pll_f_min_ref \
                                       $usr_bw_sel]

	set ret_length [llength [dict keys $result] ]
  
  # Extract all of the refclk values (all legal values given the current output frequency)
	if {$ret_length!=0} {
	  for {set x 0} {$x<$ret_length} {incr x} {
	    set item   [dict get $result $x]
	    set refclk [dict get $item refclk]

	    lappend valid_refclk "$refclk"
	    set list_of_valid_refclks [lsort -real -unique -index 0 $valid_refclk] 
	  }
    ip_set "parameter.usr_reference_clock_frequency.ALLOWED_RANGES" $list_of_valid_refclks
	} else {
    ip_set "parameter.usr_reference_clock_frequency.ALLOWED_RANGES" "N/A"
  } 

 

}

#----------------------------------------------------------------------------------------
# Convert the floating point representation of the clock frequency deteremined by 
#  "usr_reference_clock_frequency" into a string representation needed by the 
#  atom
#  TODO: change this to use mapping with M_MAP_CALLBACK
#----------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::set_tcl_reference_clock_frequency {usr_reference_clock_frequency } {
  
  #convert to 6 digit precision for string comparisons
  set ref_clock_formatted [format "%.6f" $usr_reference_clock_frequency]
  set ref_clock_formatted "$ref_clock_formatted MHz"

  set ref_clock_hz [ mega_to_base $ref_clock_formatted ]
  ip_set "parameter.tcl_reference_clock_frequency.value" "$ref_clock_hz"
    
}   

#----------------------------------------------------------------------------------------
# Convert the floating point representation of the clock frequency deteremined by 
#  "usr_output_clock_frequency" into a string representation needed by the 
#  atom
#  TODO: change this to use mapping with M_MAP_CALLBACK
#----------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::set_tcl_output_clock_frequency {usr_output_clock_frequency } {
  
  #convert to 6 digit precision for string comparisons
  set out_clock_formatted [format "%.6f" $usr_output_clock_frequency]
  set out_clock_formatted "$out_clock_formatted MHz"
  
  set out_clock_hz [ mega_to_base $out_clock_formatted ]
  ip_set "parameter.tcl_output_clock_frequency.value" "$out_clock_hz"

}

#----------------------------------------------------------------------------------------
# Validation of the Output Frequency happens implicitly during the calculation of the 
#  counters. See set_tcl_counters
#----------------------------------------------------------------------------------------
proc ::altera_xcvr_cdr_pll_s10::parameters::validate_output_clock_frequency {usr_output_clock_frequency cdr_pll_f_max_cmu_out_freq } {

  #TODO: figure out how to use the parameter cdr_pll_f_max_cmu_out_freq to set the output frequency limit 
  # It is currently not resolved correctly
  set f_max_cmu_out 5300

  if { $usr_output_clock_frequency > $f_max_cmu_out } {
    ip_message error "The Selected Output Frequency Violates the Maximum Output Frequency Capability ($f_max_cmu_out MHz) of this IP"
  }

}


proc ::altera_xcvr_cdr_pll_s10::parameters::set_tcl_counters {device_revision \
                                                              usr_reference_clock_frequency \
                                                              usr_output_clock_frequency \
                                                              tcl_tx_pll_prot_mode tcl_prot_mode tcl_support_mode \
                                                              cdr_pll_f_max_pfd cdr_pll_f_min_pfd \
                                                              cdr_pll_f_max_vco cdr_pll_f_min_vco \
                                                              cdr_pll_f_max_ref cdr_pll_f_min_ref \
                                                              usr_bw_sel } {

  # Empty list 
  ip_set "parameter.tcl_counters.value" ""
  
  #convert to 6 digit precision for string comparisons
  set out_clk_formatted [format "%.6f" $usr_output_clock_frequency]
  set ref_clk_formatted [format "%.6f" $usr_reference_clock_frequency]

	set result [compute_cmu_pll_settings $device_revision $out_clk_formatted \
                                       $tcl_tx_pll_prot_mode $tcl_prot_mode $tcl_support_mode \
                                       $cdr_pll_f_max_pfd $cdr_pll_f_min_pfd \
                                       $cdr_pll_f_max_vco $cdr_pll_f_min_vco \
                                       $cdr_pll_f_max_ref $cdr_pll_f_min_ref \
                                       $usr_bw_sel]

	 set ret_length_pre [llength [dict keys $result]]
	 set ret_length     [expr {$ret_length_pre - 1}] 

	
	 for {set x $ret_length} {$x>0} {incr x -1} {

	   set this_item           [dict get $result $x]
	   dict set temp refclk    [dict get $this_item refclk]
	   dict set temp m_cnt     [dict get $this_item m]
	   dict set temp n_cnt     [dict get $this_item n]
	   dict set temp lpfd_cnt  [dict get $this_item lpfd]
	   dict set temp lpd_cnt   [dict get $this_item lpd]
	   dict set temp fvco      [dict get $this_item fvco]
	   
	   set curr_freq [dict get $temp refclk]
	   if {[string compare $ref_clk_formatted $curr_freq] == 0} {
	     ip_set "parameter.tcl_counters.value"     $temp
	   }
	 }

}

# VCO bypass for the CDR pll has been updated to a single atom parameter named cdr_pll_vco_bypass
# The setting of counter values based on vco_bypass is no longer needed
proc ::altera_xcvr_cdr_pll_s10::parameters::set_m_cnt { tcl_counters } {

  if { [dict exists $tcl_counters m_cnt] } {
    ip_set "parameter.tcl_mcounter.value" [dict get $tcl_counters m_cnt]
  }

}

proc ::altera_xcvr_cdr_pll_s10::parameters::set_n_cnt { tcl_counters } {
  
  if { [dict exists $tcl_counters n_cnt] } {
    ip_set "parameter.tcl_ncounter.value" [dict get $tcl_counters n_cnt]
  }

}

# When lpfd_counter is set to 10, it indicates a VCO bypass mode 
# TODO: determine if the bypass value is 10
proc ::altera_xcvr_cdr_pll_s10::parameters::set_lpfd_cnt { tcl_counters } {

  if { [dict exists $tcl_counters lpfd_cnt] } {
    ip_set "parameter.tcl_pfd_lcounter.value" [dict get $tcl_counters lpfd_cnt]
  }

}

proc ::altera_xcvr_cdr_pll_s10::parameters::set_lpd_cnt { tcl_counters } {
  
  if { [dict exists $tcl_counters lpd_cnt ] } { 
    ip_set "parameter.tcl_pd_lcounter.value" [dict get $tcl_counters lpd_cnt]
  }

}

proc ::altera_xcvr_cdr_pll_s10::parameters::set_vco_freq {tcl_counters} {
  set temp_size [dict size $tcl_counters]
  
  if { $temp_size==0 } {
  } else {
    set freq [dict get $tcl_counters fvco]    
    set freq_hz [ mega_to_base $freq ]
    ip_set "parameter.tcl_vco_freq.value" "$freq_hz"
  }

}

proc ::altera_xcvr_cdr_pll_s10::parameters::set_datarate { usr_output_clock_frequency } {

  if {[string is double $usr_output_clock_frequency]} {
    set datarate [expr {$usr_output_clock_frequency * 2}] 
    set datarate_bps [ mega_to_base $datarate ]
    ip_set "parameter.tcl_datarate.value" "$datarate_bps" 
  }

}

proc ::altera_xcvr_cdr_pll_s10::parameters::set_device_revision { base_device device } {
  
  set temp_device_revision [::ct1_xcvr_native::parameters::get_base_device_user_string $base_device]

  if {$temp_device_revision != "NOVAL"} {
	  ip_set "parameter.device_revision.value" "$temp_device_revision"
  } else {
	  ip_message error "The current selected device \"$device\" is invalid, please select a valid device to generate the IP."
  }

}

#TODO: check correct decoding of user input
proc ::altera_xcvr_cdr_pll_s10::parameters::set_bw_sel { usr_bw_sel tcl_bw_sel } {

    set temp "mid_bw"
  
    if { [string compare -nocase $usr_bw_sel low]==0 } {
        ip_message warning "A bandwidth selection of Low is no longer available.  The bandwidth selection will be mapped to Medium for IP generation"
        set temp "mid_bw"
    } elseif { [string compare -nocase $usr_bw_sel medium]==0 } {
      set temp "mid_bw"
    } elseif { [string compare -nocase $usr_bw_sel high]==0 } {
      set temp "high_bw"
    } else {
      set temp "mid_bw"
    }
    
    ip_set "parameter.tcl_bw_sel.value" $temp    

}   

proc ::::altera_xcvr_cdr_pll_s10::parameters::set_refclk_index {usr_refclk_cnt} {
  
  set index 0

  for {set N 1} {$N < $usr_refclk_cnt} {incr N} {
	  lappend index $N
   }
   
   ip_set "parameter.usr_refclk_index.ALLOWED_RANGES" $index
}

proc ::altera_xcvr_cdr_pll_s10::parameters::set_tx_pll_prot_mode { tcl_primary_use usr_tx_pll_prot_mode} {

  if { [string compare -nocase $tcl_primary_use "cmu"]==0 } {

	  if { [string compare -nocase $usr_tx_pll_prot_mode "Basic"]==0 } {
	    ip_set "parameter.tcl_tx_pll_prot_mode.value" "txpll_enable"
	  } elseif { [string compare -nocase $usr_tx_pll_prot_mode "PCIE"]==0 } {
	    ip_set "parameter.tcl_tx_pll_prot_mode.value" "txpll_enable_pcie"
	  } else {
	    ip_message error "::altera_xcvr_cdr_pll_s10::parameters::validate_tx_pll_prot_mode: Unknown protocol mode: $usr_tx_pll_prot_mode"
	  }

  } elseif { [string compare -nocase $tcl_primary_use "cdr"]==0 } {
    ip_set "parameter.tcl_tx_pll_prot_mode.value" "txpll_unused"
  } else {
    ip_message error "::altera_xcvr_cdr_pll_s10::parameters::validate_tx_pll_prot_mode: Unknown primary use value: $tcl_primary_use"
  }

}   

proc ::altera_xcvr_cdr_pll_s10::parameters::set_embedded_debug_warning { rcfg_enable set_capability_reg_enable set_csr_soft_logic_enable rcfg_jtag_enable } {

    set lcl_embedded_debug_enable [expr $set_capability_reg_enable || $set_csr_soft_logic_enable]
  
    if { $rcfg_enable && ($lcl_embedded_debug_enable || $rcfg_jtag_enable)} {
	   
      ip_message warning "Merging with a TX-only channel is not supported if any optional reconfiguration logic or ADME is enabled."
    
    }
}

proc ::altera_xcvr_cdr_pll_s10::parameters::set_support_mode { PROP_NAME PROP_VALUE usr_support_mode usr_enable_vco_bypass } {
  
  if { $usr_enable_vco_bypass } {
    ip_set "parameter.tcl_support_mode.value" "engineering_mode"
  } else {
    ip_set "parameter.tcl_support_mode.value" $usr_support_mode
  }
  
  if { [string compare $PROP_VALUE "engineering_mode"] == 0 } {
	  ip_message warning "Engineering support mode has been selected. Engineering mode is for internal use only. 
                        Altera does not officially support or guarantee IP configurations for this mode."
  }
  
}

# This dummy validation callback explictly sets the mapped value of cdr_pll_pma_width
# TODO: determine if this parameter needs to be derived
proc ::altera_xcvr_cdr_pll_s10::parameters::set_pma_width { tcl_pma_width } {
  
  ip_set "parameter.tcl_pma_width.value" 8

}

# This callback is a temporary hack until IC design provides a working validation callback for the speedgrade
# There needs to be a dependence between speed grade and voltage setting that should be resolved based on RBCs
proc ::altera_xcvr_cdr_pll_s10::parameters::set_speed_grade { device } {

  set operating_temperature [::alt_xcvr::utils::device::get_s10_operating_temperature $device]
  set temp_pma_speed_grade  [::alt_xcvr::utils::device::get_s10_pma_speedgrade $device]

  ip_message info "For the selected device($device), transceiver PLL speed grade is $temp_pma_speed_grade."

  set temp_pma_speed_grade "${operating_temperature}${temp_pma_speed_grade}"

  ip_set "parameter.tcl_speed_grade.value" $temp_pma_speed_grade
}

# This callback is a placeholder for future expansion of analog mode settings for the CDR PLL
proc ::altera_xcvr_cdr_pll_s10::parameters::set_analog_mode { usr_analog_mode } {

  ip_set "parameter.tcl_analog_mode.value" $usr_analog_mode

}

# This callback maps the analog voltage setting to the power mode setting of the CDR PLL
proc ::altera_xcvr_cdr_pll_s10::parameters::set_power_mode { usr_analog_voltage } {

	  if       { [string compare -nocase $usr_analog_voltage "1_1V"]==0 } {
	    ip_set "parameter.tcl_power_mode.value" "high_perf"
    } elseif { [string compare -nocase $usr_analog_voltage "1_0V"]==0 } {
	    ip_set "parameter.tcl_power_mode.value" "mid_power"
    } elseif { [string compare -nocase $usr_analog_voltage "0_9V"]==0 } {
	    ip_set "parameter.tcl_power_mode.value" "low_power"
    } else {
      ip_message error "The value of usr_analog_voltage cannot be decoded by this IP"
    }
}

# Hide the 0_9V option from the CDR PLL GUI except when advanced options are enabled via quartus.ini
proc ::altera_xcvr_cdr_pll_s10::parameters::update_analog_voltage { PROP_VALUE tcl_enable_advanced_options } {
   if { $tcl_enable_advanced_options || $PROP_VALUE == "0_9V" } {
     ip_set "parameter.usr_analog_voltage.ALLOWED_RANGES" { "1_1V" "1_0V" "0_9V" }
   } else {
     ip_set "parameter.usr_analog_voltage.ALLOWED_RANGES" { "1_1V" "1_0V" }
   }

}


proc ::altera_xcvr_cdr_pll_s10::parameters::set_display_voltage { } {

    set message "<html><font color=\"blue\">Note - </font>All PLLs and Native PHY instances in a given tile must be configured with the same supply voltage </html>"
    ip_set "display_item.display_voltage.text" $message
}

proc ::altera_xcvr_cdr_pll_s10::parameters::set_primary_use { tcl_primary_use } {

	ip_set "parameter.tcl_primary_use.value" "cmu"

}



# cdr_pll_prot_mode is used for CDR mode only. It is always set to "unused" in the CMU context of this IP
proc ::altera_xcvr_cdr_pll_s10::parameters::set_prot_mode   { tcl_prot_mode } {

	ip_set "parameter.tcl_prot_mode.value" "unused" 

}

#dummy validation callback to suppress RBC auto resolution - do not remove as long as atom parameter exists
proc ::altera_xcvr_cdr_pll_s10::parameters::validate_cdr_pll_loopback_mode { cdr_pll_loopback_mode } {

}

#dummy validation callback to suppress RBC auto resolution - do not remove as long as atom parameter exists
proc ::altera_xcvr_cdr_pll_s10::parameters::validate_cdr_pll_diag_loopback_enable { cdr_pll_diag_loopback_enable } {

}

#dummy validation callback to suppress RBC auto resolution - do not remove as long as atom parameter exists
proc ::altera_xcvr_cdr_pll_s10::parameters::validate_cdr_pll_reverse_serial_loopback { cdr_pll_reverse_serial_loopback } {

}

#dummy validation callback to suppress RBC auto resolution - do not remove as long as atom parameter exists
proc ::altera_xcvr_cdr_pll_s10::parameters::validate_cdr_pll_requires_gt_capable_channel { cdr_pll_requires_gt_capable_channel } {

}

#dummy validation callback to suppress auto-generated validation callback - do not remove as long as atom parameter exists
proc ::altera_xcvr_cdr_pll_s10::parameters::validate_cdr_pll_initial_settings { cdr_pll_initial_settings } {

}

# Set calibration_en to user setting in advanced mode and enable it otherwise
proc ::altera_xcvr_cdr_pll_s10::parameters::validate_calibration_en { usr_calibration_en tcl_enable_advanced_options } {
  set value [expr { $tcl_enable_advanced_options ? ($usr_calibration_en == 1 ? "enable" : "disable") : "enable"}]
  ip_set "parameter.calibration_en.value" $value
}

