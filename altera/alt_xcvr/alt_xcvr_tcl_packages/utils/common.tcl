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


package provide alt_xcvr::utils::common 18.1

namespace eval ::alt_xcvr::utils::common:: {
  namespace export \
    get_data_rate_in_mbps \
    get_freq_in_mhz \
    is_string_numeric \
    get_numeric_string_size \
    map_allowed_range \
    get_mapped_allowed_range_value \
    hex_to_bin \
    dec_to_bin \
    bin_to_dec \
    wsplit \
    clogb2 \
    convert_list_to_csv_string \
    csv2list \
    parse_csv_file_to_list \
    parse_series10_style_register_map \
    parse_stratix10_style_register_map

    # global for symbolic mapping of ALLOWED_RANGES
    variable allowed_range_symbolic_map
    array set allowed_range_symbolic_map {}
}

###
# Verify that the data rate string is properly formatted with value and units
proc ::alt_xcvr::utils::common::validate_data_rate_string {data_rate_str} {
  # Extract value and units
  regexp {([0-9.]+)} $data_rate_str value 
  regexp -nocase {([a-z]+)} $data_rate_str unit

  if {![info exist value] || ![info exist unit]} {
    return 0
  }

  if { [string compare -nocase $unit "Mbps" ] != 0 } {
    if { [string compare -nocase $unit "Gbps"] != 0 } {
      return 0
    }
  }

  return 1
}

proc ::alt_xcvr::utils::common::get_data_rate_in_mbps {data_rate_str} {
  set unit "Mbps"
  #convert data rate from string with unit to integer Mbps
  regexp {([0-9.]+)} $data_rate_str value 
  regexp -nocase {([a-z]+)} $data_rate_str unit
  #send_message info "Data rate of '$data_rate_str' is '$value' '$unit'"
        
  if { [ string compare -nocase $unit "Gbps" ] == 0 } {
    set value [expr {$value * 1000}]
  }
  regsub {[.]0+$} $value {} value ;# strip off ".0"
  return $value
}

# +--------------------------------------------------------------------------------
# | Convert the frequemcy string to a floating-point value in MHz
# |
proc ::alt_xcvr::utils::common::get_freq_in_mhz {freq_str} {
	regexp {([0-9]+\.?[0-9]*)} $freq_str value 
	regexp -nocase {([a-z]+)} $freq_str unit
	#send_message info "Frequency of '$freq_str' is '$value' '$unit'"

	if { [ string compare -nocase $unit "GHz" ] == 0 } {
		set value [expr {$value * 1000} ]
	}
	regsub {[.]0+$} $value {} value	;# strip off ".0"
	return $value
}


# +--------------------------------------------------------------
# | Tests a string to determine if it is a legal format for the specified radix
proc ::alt_xcvr::utils::common::is_string_numeric {in_str {radix "dec"} } {
  
  if {$radix == "bin"} {
    set regex "(\[01\])"
  } elseif {$radix == "dec"} {
    set regex "(\[^0-9])"
  } elseif {$radix == "hex"} {
    set regex "(\[^0-9a-fA-F\])"
  } else {
    return 0
  }

  if {[regexp $regex $in_str match] == 1} {
    return 0
  } else {
    return 1
  }
}


proc ::alt_xcvr::utils::common::get_numeric_string_size { in_str {radix "dec"} } {
  if {$radix == "bin"} {
    return [string length $in_str]
  } elseif {$radix == "dec"} {
    return [string length [dec_to_bin $in_str]]
  } elseif {$radix == "hex"} {
    return [string length [hex_to_bin $in_str]]
  }
  return -1
}


proc ::alt_xcvr::utils::common::hex_to_bin { val } {
  set bin [string map {
    0 0000 1 0001 2 0010 3 0011 4 0100 5 0101 6 0110 7 0111
    8 1000 9 1001
    a 1010 b 1011 c 1100 d 1101 e 1110 f 1111
    A 1010 B 1011 C 1100 D 1101 e 1110 f 1111
  } [string tolower $val]]
  regsub {^0+} $bin "" bin
  return $bin
}


proc ::alt_xcvr::utils::common::dec_to_bin { val } {
  string map {
    +0 0 +1 1 +2 10 +3 11 +4 100 +5 101 +6 110 +7 111
    0 000 1 001 2 010 3 011 4 100 5 101 6 110 7 111
  } [format +%o $val]
}


proc ::alt_xcvr::utils::common::bin_to_dec { val } {
  set dec 0
  for {set x 0} {$x < [string length $val]} {incr x} {
    set bit [string range $val $x $x]
    set dec [expr {($dec << 1) | $bit}]
  }
  
  return $dec
}

# +-----------------------------------
# | procedure to split a string based on substrings 
# | Inputs 
# |   $str - the string that needs to be split
# |   $sep - substring separator 
# |   usage - wsplit "example_string_set" "string"
# | Returns 
# |   returns a list of strings 
# |   eg. for the use case above, the return list would be {example set}
proc ::alt_xcvr::utils::common::wsplit {str sep} {
  set split_str [split [string map [list $sep \0] $str] \0]
  return $split_str
}

# +-----------------------------------
# | Map legal values in allowed range to fixed symbolic values
# | 
# | Inputs:
# |   $gui_param_name - symbolic parameter used for GUI display map
# |     Symbols are normal values like "8", or "16", or "32.5 MHz".
# |     At most one symbol will be mapped for any given parameter,
# |     typically because the default value or the last value entered
# |     by the user is no longer valid.
# |     If the current value of a parameter is legal, there will be
# |     no entries in the symbolic map array.
# |     The legal value set is given in the $legal_values parameter
# |   $legal_values   - list of currently legal real values
# | 
# | Returns:
# |   nothing, but does the following:
# |   - sets ALLOWED_RANGE for named parameter
# |   - saves mapping in global array for retrieval using [get_mapped_allowed_range_value gui_param]
# |   # $allowed_range - list that maps symbolic values to legal values for GUI selection
proc ::alt_xcvr::utils::common::map_allowed_range { gui_param_name legal_values {map_value "NO_MAP_VALUE"} {should_sanitize true}} {
  variable allowed_range_symbolic_map
  array set local_map {}
  
  set current_symbol [get_parameter_value $gui_param_name]
  # check for legacy code symbolic value of "u@<val>"
  if {[ regexp {@(.*)} $current_symbol matchresult val ]} {
    set current_value $val
  } else {
    set current_value $current_symbol
  }

  # Strip out all unsafe characters
  regsub -all {[^-A-Za-z_0-9 ]+} $current_value {.} current_value
  # ... and from legal values list
  if {$should_sanitize} {
	set sanitized_legal [list]
	foreach val $legal_values {
		regsub -all {[^-A-Za-z_0-9 ]+} $val {.} val
		lappend sanitized_legal $val
	}
  } else {
	set sanitized_legal $legal_values
	regsub -all {\"} $map_value {} map_value
  }

  # if current value doesn't exist in legal value set, switch to first legal value
  set legal_value [lindex $sanitized_legal 0]
  if {[lsearch -exact $sanitized_legal $current_value ] < 0 } {
    # record remapped symbol-value pair
    # If caller specified a mapping, use it
    if { $map_value != "NO_MAP_VALUE" } {
      if {[lsearch -exact $sanitized_legal $map_value] >= 0} {
        set legal_value $map_value
      }
    }
    set local_map($current_symbol) $legal_value
  } else {
    set legal_value $current_value  ;# current value is in legal set
  }

  # map legal values to symbols, making sure to re-use current symbol
  set allowed_range [list]
  foreach val $sanitized_legal {
    # when at assigned matching legal value, create symbol mapping if needed
    if {$val == $legal_value && $val != $current_symbol} {
      lappend allowed_range "${current_symbol}:$val"
    } else {
      # add legal value without symbolic encoding
      lappend allowed_range "$val"
    }
  }
  
  set_parameter_property $gui_param_name ALLOWED_RANGES $allowed_range

  # clear global ALLOWED_RANGES symbolic mapping, to prepare for new mapping
  set allowed_range_symbolic_map($gui_param_name) [array get local_map]
  #common_log "$gui_param_name ALLOWED_RANGES is $allowed_range, set:sym_map to $allowed_range_symbolic_map($gui_param_name)"

  #return $allowed_range
}

# +---------------------------------------------------------
# | Lookup real value from symbolically mapped legal values
# | 
# | Inputs:
# | 	$gui_param_name - symbolic parameter used for GUI display map
# |			Symbols are normal values like "8", or "16", or "32.5 MHz".
# |			In some legacy uses, a symbol may have the form "u@<val>",
# |			in which case the "u@" is ignored to get the last user-selected
# |			value.
# | 
# | Returns:
# | 	$val - real value corresponding to current symbolic value, or "unknown"
# |			In most cases, the current value is the real value, unless
# |			the symbol mapping array contains a mapping, or the real
# |			value is of the form "u@<val>".
proc ::alt_xcvr::utils::common::get_mapped_allowed_range_value { gui_param_name } {
	# get symbolic mapping for named GUI parameter
	variable allowed_range_symbolic_map
	set sym [get_parameter_value $gui_param_name]
	set sym_is_mapped 0

	# check if a symbolic mapping exists
	if {[info exists allowed_range_symbolic_map($gui_param_name) ] } {
		array set local_map $allowed_range_symbolic_map($gui_param_name)
		#send_message info "use:sym_map for $gui_param_name is '$allowed_range_symbolic_map($gui_param_name)'"

		# get mapped value for current symbol, if it exists
		if {[info exists local_map($sym) ] } {
			set val $local_map($sym)
			set sym_is_mapped 1
		}
	}

	# check for legacy "u@<val>" form.  Otherwise, use value as-is
	if {$sym_is_mapped == 0} {
		if {[ regexp {@(.*)} $sym matchresult val ]} {
			#send_message info "${gui_param_name}: recovered value '$val' from symbol"
		} else {
			set val $sym
		}
	}

	return $val
}


###
# intersect - Accepts any number of lists and returns the intersection of all provided lists.
#
# @param - args - Any number of lists.
proc ::alt_xcvr::utils::common::intersect args {
   set res {}
     foreach element [lindex $args 0] {
       set found 1
       foreach list [lrange $args 1 end] {
           if {[lsearch -exact $list $element] < 0} {
              set found 0; break
           }
       }
       if {$found} {lappend res $element}
    }
    set res
 } ;

##
# this function is copied from constra generated utils.tcl package
proc ::alt_xcvr::utils::common::split_range { value } {
   set range_list [split $value ":"]

   set min_cur [lindex $range_list 0]
   if { [llength $range_list] > 1 } {
      set max_cur [lindex $range_list 1]
   } else {
      set max_cur $min_cur
   }

   return [list $min_cur $max_cur]
}

##
# this function is copied from constra generated utils.tcl package
proc ::alt_xcvr::utils::common::union { values } {
   if { [llength $values] > 1 } {
      set union_list {}

      set values_size [llength $values]
      for {set i 0} {$i < $values_size} {incr i} {
         if { ![info exists visited_list($i)] } {
            set visited_list($i) {}

            set range_list [split_range [lindex $values $i]]
            set min_cur [lindex $range_list 0]
            set max_cur [lindex $range_list 1]

            for {set j 1} {$j < $values_size} {incr j} {
               if { ![info exists visited_list($j)] } {
                  set range_list [split_range [lindex $values $j]]
                  set min_next [lindex $range_list 0]
                  set max_next [lindex $range_list 1]	

                  if [expr { ($min_next <= $max_cur + 1) && ($min_cur <= $max_next + 1)}] {
                     set visited_list($j) {}

                     if { $min_cur > $min_next } {
                       set min_cur $min_next
                     }
                     if { $max_cur < $max_next } {
                       set max_cur $max_next
                     }
                  }
               }
            }

            set update_value 1
            for {set j 0} {$j < [llength $union_list]} {incr j} {
               set range_list [split_range [lindex $union_list $j]]
               set min_next [lindex $range_list 0]
               set max_next [lindex $range_list 1]

               if [expr { ($min_next <= $max_cur + 1) && ($min_cur <= $max_next + 1)}] {
                  set update_value 0

                  if { $min_cur > $min_next } {
                     set min_cur $min_next
                     set update_value 1
                  }
                  if { $max_cur < $max_next } {
                     set max_cur $max_next
                     set update_value 1
                  }

                  if { $update_value } {
                     set update_value 0
                     lset union_list $j "${min_cur}:${max_cur}"
                  }
               }
            }

            if { $update_value } {	
               if { $max_cur == $min_cur } {
                  lappend union_list $min_cur
               } else {
                  lappend union_list "${min_cur}:${max_cur}"
               }
            }
         }
      }
   } else {
      set union_list $values
   }

   return $union_list
}

##
# this function is copied from constra generated utils.tcl package
proc ::alt_xcvr::utils::common::compare_inside { legal_range_values constraint_values } {
   set new_list {}
   set constraint_values [union $constraint_values]

   foreach value $legal_range_values {
      set range_list [split_range $value]
      set min [lindex $range_list 0]
      set max [lindex $range_list 1]

      foreach c_value $constraint_values {
         set min_cur $min
         set max_cur $max

         set range_list [split_range $c_value]
         set c_min [lindex $range_list 0]
         set c_max [lindex $range_list 1]

         if [expr { ($max_cur >= $c_min) && ($min_cur <= $c_max)}] {
            if [expr {$min_cur < $c_min}] {
               set min_cur $c_min
            }
            if [expr {$max_cur > $c_max}] {
               set max_cur $c_max
            }
            if { $min_cur == $max_cur } {
               lappend new_list [list $min_cur]
            } else {
               lappend new_list [list ${min_cur}:${max_cur}]
            }
         }
      }
   }

   set new_list [union $new_list]
   return $new_list
}

proc ::alt_xcvr::utils::common::clogb2 { input_num } {
  for {set retval 0} {$input_num > 0} {incr retval} {
    set input_num [expr {$input_num >> 1}]
  }
  if {$retval == 0} {
    set retval 1
  }
   
  return $retval
}

###
# Convert a list to a comma seperated string of values.
#
# @param t_list - The list of values to convert to a string
# @param t_count - The number of values in the list
#
# @return - A string of comma seperated values. The leftmost value represents index
#           0 within the list.
#
proc ::alt_xcvr::utils::common::convert_list_to_csv_string {t_list t_count} {
  set t_string [lindex $t_list 0]
  for {set x 1} {$x < $t_count} {incr x} {
    set this_string [lindex $t_list $x]
    set t_string "${t_string},${this_string}"
  }

  return $t_string
}


###
# Convert a CSV string to a list of values
#
# @param str - The CSV string to parse
# @param sepChar - The separator character "," by default
#
# @return - A list containing the values of each field from the CSV string
proc ::alt_xcvr::utils::common::csv2list {str {sepChar ,}} {
  regsub -all {(\A\"|\"\Z)} $str \0 str
  set str [string map [list $sepChar\"\"\" $sepChar\0\" \
                            \"\"\"$sepChar \"\0$sepChar \
                            $sepChar\"\"$sepChar $sepChar$sepChar \
                            \"\" \" \" \0 ] $str]
  set end 0
  while {[regexp -indices -start $end {(\0)[^\0]*(\0)} $str \
          -> start end]} {
    set start [lindex $start 0]
    set end   [lindex $end 0]
    set range [string range $str $start $end]
    set first [string first $sepChar $range]
    if {$first >= 0} {
      set str [string replace $str $start $end \
        [string map [list $sepChar \1] $range]]
    }
    incr end
  }
  set str [string map [list $sepChar \0 \1 $sepChar \0 {} ] $str]
  return [split $str \0]
}


proc ::alt_xcvr::utils::common::parse_csv_file_to_list { filename } {
  set this_list {}
  set fid [open $filename "r"]

  while { ![eof $fid] } {
    set line [gets $fid]
    set line [string trim $line]
    set csvline [csv2list $line]
    lappend this_list $csvline
  }

  return $this_list
  close $fid
}


###
# Parse Series 10 style DPRIO register map CSV files into a dictionary structure.
#
# @param filename The path to a CSV register map file to parse
#
# @return If processing is successful this proc will return a dictionary containing
#         the information from the register map file.The structure of the dictionary
#         is as follows:
#         param_name->param_value0->offset0->bit_offset0->bit_value
#                                          ->bit_offset1->bit_value
#                                          ->bit_offset2->bit_value
#                                 ->offset1->bit_offset0->bit_value
#                   ->param_value1->offset0->bit_offset0->bit_value
#                                 ->offset1->bit_offset0->bit_value
#         param_name->param_value0-> .....
#
proc ::alt_xcvr::utils::common::parse_series10_style_register_map { filename {replace_x 1}} {
  set data [dict create]
  set fields [dict create]
  set nf_prefixes [dict create]
  
  dict set fields offset header "DPRIO Offset(hex)"
  dict set fields bit_offset header "DPRIO Bit Offset"
  dict set fields attrib header "Attribute Name"
  dict set fields attrib_value header "Attribute Encoding"
  dict set fields bit_value header "DPRIO Encoding"
  dict set fields block header "Block"
  
  # A list of replacement prefixes
  dict set nf_prefixes hssi_pma_channel_pll cdr_pll
  dict set nf_prefixes hssi_pma_tx_cgb pma_cgb
  dict set nf_prefixes hssi_pma_adaptation pma_adapt
  dict set nf_prefixes hssi_pma_ pma_
  dict set nf_prefixes twentynm_hssi_ hssi_
  dict set nf_prefixes twentynm_ ""

  # Parse CSV to list
  set ldata [parse_csv_file_to_list $filename]
  # Grab header fields and locate field indices
  set headers [lindex $ldata 0]
  for {set x 0} {$x < [llength $headers]} {incr x} {
    set field [string trim [lindex $headers $x]] 
    set headers [lreplace $headers $x $x $field]
  }
  
  # Find indices for all fields and store. Return if a required field is not found
  dict for {key value} $fields {
    #puts "Searching headers for $key [dict get $fields $key header]"
    set index [lsearch $headers [dict get $fields $key header]]
    if {$index == -1} {
      return -1
    } else {
      dict set fields $key index $index
      dict set fields $key value ""
    }
  }

  #puts "$fields"

  for {set x 1} {$x < [llength $ldata]} {incr x} {
    set line [lindex $ldata $x]
    #puts $line
    dict for {key value} $fields {
      set value [lindex $line [dict get $fields $key index]]
      if {$value != ""} {
        # Perform block prefix substitution
        if {$key == "block"} {
          dict for {old_prefix new_prefix} $nf_prefixes {
            set value [string map [list $old_prefix $new_prefix] $value]
          }
        }
        dict set fields $key value $value
      }
    }

    set attrib [dict get $fields attrib value]
    set attrib_value [dict get $fields attrib_value value]
    if {$attrib != "RESERVED" && $attrib_value != ""} {
      set param_name "[dict get $fields block value]_${attrib}"
      set offset [dict get $fields offset value]
      set bit_offset [dict get $fields bit_offset value]
      set bit_value [dict get $fields bit_value value]
      if { $replace_x } {
        #Replace 'x' with '0'
        set bit_value [string map {x 1} $bit_value]
      }
      if { $bit_value == "DIRECT MAPPED" } {
        set bit_value [regsub {.*(\[.*\])} $attrib_value "\\1"]
        set attrib_value "DIRECT MAPPED"
      }
      dict set data $param_name $attrib_value $offset $bit_offset $bit_value
    }
  }

  #puts $data
  return $data
}


###
# Parse Stratix 10 style DPRIO register map CSV files into a dictionary structure.
#
# @param filename The path to a CSV register map file to parse
#
# @return If processing is successful this proc will return a dictionary containing
#         the information from the register map file.The structure of the dictionary
#         is as follows:
#         param_name->param_value0->offset0->bit_offset0->bit_value
#                                          ->bit_offset1->bit_value
#                                          ->bit_offset2->bit_value
#                                 ->offset1->bit_offset0->bit_value
#                   ->param_value1->offset0->bit_offset0->bit_value
#                                 ->offset1->bit_offset0->bit_value
#         param_name->param_value0-> .....
#
proc ::alt_xcvr::utils::common::parse_stratix10_style_register_map { filename } {
  set data [dict create]
  set fields [dict create]
  set nd_prefixes [dict create]
  
  dict set fields offset header "DPRIO Offset(hex)\\\[9:0\\\]"
  dict set fields bit_offset header "DPRIO Bit Offset"
  dict set fields attrib header "Attribute Name"
  dict set fields attrib_value header "Attribute Encoding"
  dict set fields bit_value header "DPRIO Encoding"
  dict set fields block header "Block"
  dict set fields attrib_bit_offset header "Attribute Bit Offset"
  
  # A list of replacement prefixes
  dict set nd_prefixes hssi_pma_cdr_pll       cdr_pll
  dict set nd_prefixes hssi_pma_cdr_refclk_select_mux pma_cdr_refclk
  dict set nd_prefixes hssi_cr_pma_tx_buf     pma_tx_buf
  dict set nd_prefixes hssi_cr_pma_rx_buf     pma_rx_buf
  dict set nd_prefixes hssi_pma_tx_cgb        pma_cgb
  dict set nd_prefixes hssi_cr_pma_tx_ser     pma_tx_ser
  dict set nd_prefixes hssi_cr_pma_rx_deser   pma_rx_deser
  dict set nd_prefixes hssi_cr_pma_rx_dfe     pma_rx_dfe
  dict set nd_prefixes hssi_pma_rx_odi        pma_rx_odi
  dict set nd_prefixes hssi_pma_rx_sd         pma_rx_sd
  dict set nd_prefixes hssi_pma_adaptation    pma_adapt
  dict set nd_prefixes hssi_pma_              pma_
  dict set nd_prefixes fourteennm_hssi_       hssi_
  dict set nd_prefixes fourteennm_            ""
  dict set nd_prefixes hssi_cr_pma_lc_pll     atx_pll
  dict set nd_prefixes hssi_cr_refclk_divider hssi_refclk_divider

  # Parse CSV to list
  set ldata [parse_csv_file_to_list $filename]

  # Grab header fields from register map and locate field indices
  set headers [lindex $ldata 0]
  for {set x 0} {$x < [llength $headers]} {incr x} {
    set field [string trim [lindex $headers $x]] 
    set headers [lreplace $headers $x $x $field]
  }

  # Find indices for all fields and store. Return if a required field is not found
  dict for {key value} $fields {
    set index [lsearch $headers [dict get $fields $key header]]
    if {$index == -1} {
      return -1
    } else {
      dict set fields $key index $index
      dict set fields $key value ""
    }
  }

  # Parsing the CSV lines
  for {set x 1} {$x < [llength $ldata]} {incr x} {
    set line [lindex $ldata $x]
    dict for {key value} $fields {
      set value [lindex $line [dict get $fields $key index]]
      if {$value != ""} {
        # Perform block prefix substitution
        if {$key == "block"} {
          dict for {old_prefix new_prefix} $nd_prefixes {
            set value [string map [list $old_prefix $new_prefix] $value]
          }
        }
        dict set fields $key value $value
      }
    }

    set attrib [dict get $fields attrib value]
    set attrib_value [dict get $fields attrib_value value]
    if {$attrib != "RESERVED" && $attrib_value != ""} {
      set param_name "[dict get $fields block value]_${attrib}"
      set offset [dict get $fields offset value]
      set bit_offset [dict get $fields bit_offset value]
      set full_bit_value [dict get $fields bit_value value]
      set attrib_bit_offset [dict get $fields attrib_bit_offset value]

      if { $full_bit_value == "DIRECT MAPPED" } {
        set full_bit_value $attrib_bit_offset
        set attrib_value "DIRECT MAPPED"
        set bit_value $full_bit_value
      } else {

        # Extract the attribute bit offset and calculate the bit value width
        set attrib_bit_offset [string trim $attrib_bit_offset "\[\]"]
        set attrib_offsets [split_range $attrib_bit_offset]
        set attrib_msb [lindex $attrib_offsets 0]
        set attrib_lsb [lindex $attrib_offsets 1]
        set attrib_width [expr {$attrib_msb - $attrib_lsb + 1}]

        # Copy the attribute bit values from the full bit value and create new bit value
        set full_bit_value [string range $full_bit_value 3 [expr [string length $full_bit_value] - 1]]
        set width_full_bit_value [string length $full_bit_value]
        if {$width_full_bit_value > 1} {
          set attrib_bit_value [string range $full_bit_value [expr {$width_full_bit_value - $attrib_msb - 1}] [expr {$width_full_bit_value - $attrib_lsb - 1}]]
        } else {
          set attrib_bit_value $full_bit_value
        }

        set bit_value ""
        append bit_value $attrib_width "'b" $attrib_bit_value
      }

      dict set data $param_name $attrib_value $offset $bit_offset $bit_value
    }
  }

  #puts $data
  return $data
}
