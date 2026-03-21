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



package provide alt_xcvr::ip_tcl::ip_interfaces 18.1 

package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::ip_tcl::ip_module

namespace eval ::alt_xcvr::ip_tcl::ip_interfaces:: {
  namespace export \
    add_fragment_prefix \
    create_fragmented_index_list \
	create_fragmented_index_list_from_list \
    expand_fragmented_index_list \
    create_expanded_index_list \
	create_expanded_index_list_from_list \
    convert_list_to_map \
    partial_interface_message \
    create_fragmented_conduit \
	create_fragmented_range_conduit \
    create_fragmented_interface \
	create_fragmented_interface_from_list
}

proc ::alt_xcvr::ip_tcl::ip_interfaces::add_fragment_prefix { frag_list prefix } {
  regsub -all {[0-9]+} $frag_list "${prefix}@&" frag_list
  return $frag_list
}

proc ::alt_xcvr::ip_tcl::ip_interfaces::add_fragment_range_prefix { frag_list prefix } {
  set ret_val {}
  foreach frag $frag_list {
	lappend ret_val "${prefix}@${frag}"	
  }  
  return $ret_val
}

##
# Creates a list of port indexes which can later be used for port fragmentation
#
# @param total_width - The total width of the interface
# @param group_width - The width of each group to be mapped. There may be multiple groups
#                     within the total width that need to be mapped. For example, the original
#                     port may have a width of 128 bits and the mapped port may be 16 bits but
#                     it maps 8 bits each from 2 groups of 16 (i.e. bits [7:0] and bits [23:16]. The group
#                     width in this case would be 16.
# @param words - The number of "groups" if referring to group width. In the aforementioned example
#                 the value of this parameter would be 2.
# @param width - The width of the data from each group to be used for the mapped port. In the aforementioned
#                 example the value of this parameter would be 8.
# @param offset - The starting offset within the "group" from which to pull "width" bits of data for each
#               "word". In the aforementioned example this value would be 0. If however the 8 mentioned bits
#               from each group came from bits [8:1] and [24:17] the value would be 1.
# @param list_select - "used" indicates you would like the procedure to return a list of port indexes needed
#               for the mapped interface as specified by the parameters given. "unused" will return a list of
#               all the port indexes EXCEPT the ones needed. In other words, it's the ports outside the used
#               set.
proc ::alt_xcvr::ip_tcl::ip_interfaces::create_fragmented_index_list { total_width group_width words width offset {list_select "used"} {add_offset 0} } {
  set used_list {}
  set unused_list {}

  set x 0
  set index 0  

  while {$index < $total_width} {    
    for {set y 0} {$y < $group_width && $index < $total_width} {incr y} {
      if {$x < $words && $y >= $offset && $y < [expr $offset + $width] } {
        set used_list [linsert $used_list 0 [expr $index + $add_offset]]
      } else {
        set unused_list [linsert $unused_list 0 [expr $index + $add_offset]]
      }
      incr index
    }
    incr x
  }

  set retval [expr { $list_select == "used" ? $used_list : $unused_list }]
  return $retval
}

##
# Creates a list of port indexes which can later be used for port fragmentation
#
# @param total_width - The total width of the interface
# @bit_indexes - List of bit indexes that are mapped to the port
# @param list_select - "used" indicates you would like the procedure to return a list of port indexes needed
#               for the mapped interface as specified by the parameters given. "unused" will return a list of
#               all the port indexes EXCEPT the ones needed. In other words, it's the ports outside the used
#               set.
proc ::alt_xcvr::ip_tcl::ip_interfaces::create_fragmented_index_list_from_list { total_width bit_indexes {list_select "used"} {add_offset 0} } {
  set used_list {}
  set unused_list {}

  set used_dict {}
      
 foreach index_pair $bit_indexes {
	set temp [split $index_pair ":"]	
	set bit_end [lindex $temp 0]
	set bit_begin [expr { ([llength $temp] == 1) ? $bit_end : [lindex $temp 1] }]
	
	for {set y $bit_begin} {$y <= $bit_end} {incr y} {
		dict set used_dict $y 1
	}
 }

  set index 0  
  while {$index < $total_width} {    
	if [dict exists $used_dict $index] {
		set used_list [linsert $used_list 0 [expr $index + $add_offset]]
	} else {
        set unused_list [linsert $unused_list 0 [expr $index + $add_offset]]
    }
    incr index
  }

  set retval [expr { $list_select == "used" ? $used_list : $unused_list }]
  return $retval
}

proc ::alt_xcvr::ip_tcl::ip_interfaces::expand_fragmented_index_list { channels total_width index_list } {
  set new_list {}

  for {set c [expr $channels - 1]} {$c > 0} {set c [expr $c - 1]} {
    set add_val [expr $c * $total_width]
    foreach index $index_list {
      lappend new_list [expr $index + $add_val]
    }
  }
  set new_list [concat $new_list $index_list]

  return $new_list
}

proc ::alt_xcvr::ip_tcl::ip_interfaces::create_expanded_index_list { channels total_width group_width words width offset {list_select "default"} } {
  set retval [create_fragmented_index_list $total_width $group_width $words $width $offset $list_select]
  set retval [expand_fragmented_index_list $channels $total_width $retval]
  return $retval
}

proc ::alt_xcvr::ip_tcl::ip_interfaces::create_expanded_index_list_from_list { channels total_width bit_indexes {list_select "default"} } {
  set retval [create_fragmented_index_list_from_list $total_width $bit_indexes $list_select]
  set retval [expand_fragmented_index_list $channels $total_width $retval]
  return $retval
}


proc ::alt_xcvr::ip_tcl::ip_interfaces::convert_list_to_map { index_list } {
  set map {}

  set upper_index [lindex $index_list 0]
  set lower_index $upper_index
  for {set x 1} {$x < [llength $index_list]} {incr x} {
    set item [lindex $index_list $x]
    set expect [expr $lower_index - 1]
    if {$item != $expect} {
      set str [expr {$upper_index == $lower_index ? $upper_index : "${upper_index}:${lower_index}" }]
      lappend map $str
      set upper_index $item
    }
    set lower_index $item
  }
  set str [expr {$upper_index == $lower_index ? $upper_index : "${upper_index}:${lower_index}" }]
  lappend map $str

  return $map
}


##
# Issues a message indicating which bits within an interface "pname" are used for a signal named "if_pname".
proc ::alt_xcvr::ip_tcl::ip_interfaces::partial_interface_message { if_pname pname total_width used_width used_map unused_map } {
  set message "$if_pname: For each ${total_width} bit word "
  # Used bits
  if {[llength $used_map] > 0} {
    set used_map [string map {" " ","} $used_map]
    set message "${message} the $used_width active data bits are ${pname}\[${used_map}\];" 
  }
  # Unused bits
  if {[llength $unused_map] > 0} {
    set unused_map [string map {" " ","} $unused_map]
    set message "${message} unused data bits are ${pname}\[${unused_map}\]."
  }
  ::alt_xcvr::ip_tcl::messages::ip_message info $message
}


##
# Depending on the parameters, creates a conduit interface whose port maps to fragments (subsets) of signals
# of an RTL port.
# @param condition - If the condition is true, a conduit interface (named "pname") will be created and it's port will map to
#                    signls within the specified RTL port specified by "src_port"
#                    If the condition is false, a message will be issued to indicate what the mapping would be for the interface
#                    if the condition were met.
# @param pname - The name of the interface and associated port to create.
# @param src_port - The name of the RTL port to which the interface port "pname" will be mapped.
# @param direction - The direction of the interface ("input" or "output"). Also used to establish which side of the block
#                   diagram the port will be displayed on in the GUI.
# @param channels - The number of channels in the interface. A bus may contain multiple channels worth of data. Essentially this
#                   acts as a loop iterator.
# @param total_width - The total width of a single channel's signals on the RTL "src_port".
# @param group_width - Each "total_width" may be broken up into sub groups for each channel. For example,
#                     the total width of the src_port may be 128 bits, with 32 bits corresponding to
#                     each of 4 data words within the 128 bits.
# @param words - The total number of words to be mapped. For example, if the src_port contains 4 words worth of data,
#                 this parameter would have a value of 1-4 indicating how many of the 4 words need to be mapped.
# @param width - How many bits of each word will be used for the new interface. For example, if the src_port contains
#               4 words of 32-bits each then the "width" would have a value of 1-32.
# @param offset - The starting index within each word to begin mapping bits. For example, if the offset is 1 and the width is 8,
#                 bits [8:1] from each group would be mapped to the interface.
# @param used - Optional. If "used", the interface will contain all of the bits specified by the aforementioned parameters.
#               If "unused", the interface will contain everything outside the set of used bits.
# @param add_offset - Optional. If specified, the indices created for the mapping will have the specified value added to them.
proc ::alt_xcvr::ip_tcl::ip_interfaces::create_fragmented_interface { condition pname src_port direction channels total_width group_width words width offset { used "used" } { add_offset 0 } { role default } { group 0 } } {
    # Obtain the list of indexes into the RTL port that will map to the IP port
    set used_list [create_fragmented_index_list $total_width $group_width $words $width $offset $used $add_offset]
    # If the condition is met, we create an interface and map the ports to the appropriate portions of the RTL port
    if {$condition} {
      set used_list [expand_fragmented_index_list $channels $total_width $used_list]
	  if {$group} {
		create_fragmented_range_conduit $pname $src_port [convert_list_to_map $used_list] $direction $direction $role		
	  } else {		
		create_fragmented_conduit $pname [add_fragment_prefix $used_list $src_port] $direction $direction $role
	  }      
    } else {
      # If the condition is not met we simply issue a message
      # Subtract the offset from the issued message list if provided
      set used_list [subst [regsub -all {[0-9]+} $used_list {[expr & - $add_offset]}]]
      partial_interface_message $pname $src_port $total_width [expr {$words * $width}] [convert_list_to_map $used_list] {}
    }
}

##
# Depending on the parameters, creates a conduit interface whose port maps to fragments (subsets) of signals
# of an RTL port based on the bit_indexes passed into the procedure
#
# @param condition - If the condition is true, a conduit interface (named "pname") will be created and it's port will map to
#                    signls within the specified RTL port specified by "src_port"
#                    If the condition is false, a message will be issued to indicate what the mapping would be for the interface
#                    if the condition were met.
# @param pname - The name of the interface and associated port to create.
# @param src_port - The name of the RTL port to which the interface port "pname" will be mapped.
# @param direction - The direction of the interface ("input" or "output"). Also used to establish which side of the block
#                   diagram the port will be displayed on in the GUI.
# @param channels - The number of channels in the interface. A bus may contain multiple channels worth of data. Essentially this
#                   acts as a loop iterator.
# @param total_width - The total width of a single channel's signals on the RTL "src_port".
# @param words - The total number of words to be mapped. For example, if the src_port contains 4 words worth of data,
#                 this parameter would have a value of 1-4 indicating how many of the 4 words need to be mapped.
# @param width - How many bits of each word will be used for the new interface. For example, if the src_port contains
#               4 words of 32-bits each then the "width" would have a value of 1-32.
# @bit_indexes - A list that contains bit indexes of the src_port that are mapped to the interface
# @param used - Optional. If "used", the interface will contain all of the bits specified by the aforementioned parameters.
#               If "unused", the interface will contain everything outside the set of used bits.
# @param add_offset - Optional. If specified, the indices created for the mapping will have the specified value added to them.
proc ::alt_xcvr::ip_tcl::ip_interfaces::create_fragmented_interface_from_list { condition pname src_port direction channels total_width bit_indexes words width { used "used" } { add_offset 0 } { role default } } {    
    # If the condition is met, we create an interface and map the ports to the appropriate portions of the RTL port
    if {$condition} {
	  # Obtain the list of indexes into the RTL port that will map to the IP port
	  set used_list [create_fragmented_index_list_from_list $total_width $bit_indexes $used $add_offset]
	  set used_list [expand_fragmented_index_list $channels $total_width $used_list]	  	  
      create_fragmented_range_conduit $pname $src_port [convert_list_to_map $used_list] $direction $direction $role
    } else {
      # If the condition is not met we simply issue a message
	  partial_interface_message $pname $src_port $total_width [expr {$words * $width}] $bit_indexes {}
    }
}

proc ::alt_xcvr::ip_tcl::ip_interfaces::create_fragmented_conduit { pname fragment_list direction {ui_direction default} {role default}} {	
  ::alt_xcvr::ip_tcl::ip_module::ip_add "interface.${pname}" conduit end
  ::alt_xcvr::ip_tcl::ip_module::ip_add "port.${pname}.${pname}" $pname
  ::alt_xcvr::ip_tcl::ip_module::ip_set "port.${pname}.direction" $direction
  ::alt_xcvr::ip_tcl::ip_module::ip_set "port.${pname}.width_expr" [llength $fragment_list]  
  ::alt_xcvr::ip_tcl::ip_module::ip_set "port.${pname}.fragment_list" $fragment_list
  if {$ui_direction != "default" } {
    ::alt_xcvr::ip_tcl::ip_module::ip_set "interface.${pname}.assignment" [list "ui.blockdiagram.direction" $ui_direction]
  }
  if {$role != "default" } {
    ::alt_xcvr::ip_tcl::ip_module::ip_set "port.${pname}.role" $role
  }
}

proc ::alt_xcvr::ip_tcl::ip_interfaces::create_fragmented_range_conduit { pname src_port fragment_list direction {ui_direction default} {role default}} {	
  ::alt_xcvr::ip_tcl::ip_module::ip_add "interface.${pname}" conduit end
  ::alt_xcvr::ip_tcl::ip_module::ip_add "port.${pname}.${pname}" $pname
  ::alt_xcvr::ip_tcl::ip_module::ip_set "port.${pname}.direction" $direction
  ::alt_xcvr::ip_tcl::ip_module::ip_set "port.${pname}.width_expr" [get_fragment_width $fragment_list]  
  ::alt_xcvr::ip_tcl::ip_module::ip_set "port.${pname}.fragment_list" [add_fragment_range_prefix $fragment_list $src_port]
  if {$ui_direction != "default" } {
    ::alt_xcvr::ip_tcl::ip_module::ip_set "interface.${pname}.assignment" [list "ui.blockdiagram.direction" $ui_direction]
  }
  if {$role != "default" } {
    ::alt_xcvr::ip_tcl::ip_module::ip_set "port.${pname}.role" $role
  }
}

proc ::alt_xcvr::ip_tcl::ip_interfaces::get_fragment_width { fragment_list } {		
	set len 0
	if { [string match "*:*" $fragment_list] } {
		foreach frag $fragment_list {
			set temp [split $frag ":"]			
			if { [string match "*:*" $frag] } {				
				set len [expr $len + [lindex $temp 0] - [lindex $temp 1] + 1]			
			} else {
				incr len
			}			
		}	
	} else {
		set len [llength $fragment_list]
	}
	return $len
}



