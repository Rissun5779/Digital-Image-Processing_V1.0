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


###############################################################################
#
#   $Header: //acds/rel/18.1std/ip/altera_hps/altera_hps_arria_10/util/locations.tcl#1 $
#
#		Description: hw.tcl API for accessing HPS atom locations.
#                    Uses the Quartus Tcl bridge to query information
#                    and caches it in variables.
#
#		Author: Michael Tozaki, and some ipdates by ACID
#		Date:   2012.07.31
#
###############################################################################

package require altera_hwtcl_qtcl

namespace eval locations {
	source [file join $::env(QUARTUS_ROOTDIR) .. ip altera altera_hps altera_hps_arria_10 util procedures.tcl]

	variable part
	variable hps_io
	variable fpga_cache
	variable pad_to_pkg_cache

	proc load {part_value} {
		
		variable part
		variable hps_io
		variable fpga_cache
		variable pad_to_pkg_cache
		
		# if part changes, clear the cache		
		if {[info exists part]} {
			if { $part != $part_value } {
				send_message debug "HPS: Part change detected. $part -> $part_value Clearing the location cache"
				if {[info exists hps_io]} {
					unset hps_io
				}
				if {[info exists fpga_cache]} {
					unset fpga_cache
				}
				if {[info exists pad_to_pkg_cache]} {
					unset pad_to_pkg_cache
				}
			}
		} else {
			if {[info exists hps_io]} {
				unset hps_io
			}
			if {[info exists fpga_cache]} {
				unset fpga_cache
			}
			if {[info exists pad_to_pkg_cache]} {
				unset pad_to_pkg_cache
			}
		}
		
		variable part $part_value
	}


	proc query_quartus_for_pad_to_pkg_map {part} {
		set quartus_script_path [file join $::env(QUARTUS_ROOTDIR) .. ip altera altera_hps altera_hps_arria_10 util quartus_locations_query.tcl]
		set cmd "advanced_device:source ${quartus_script_path};get_pad_to_pin_name $part "
		set pad_to_pkg_map [ fix_degug_messages_crap $cmd ]
		return $pad_to_pkg_map
	}
	proc get_pad_to_pkg_map { } {
		set cached 0
		variable pad_to_pkg_cache
		if {[info exists pad_to_pkg_cache ]} {
			set pad_to_pkg $pad_to_pkg_cache
			set cached 1
		}

		if {!$cached} {
			variable part

			set pad_to_pkg [query_quartus_for_pad_to_pkg_map $part ]
			# cache result
			set pad_to_pkg_cache $pad_to_pkg
		}
		return $pad_to_pkg
	}

	proc query_quartus_for_location {part atom_name peripheral_index} {
		set quartus_script_path [file join $::env(QUARTUS_ROOTDIR) .. ip altera altera_hps altera_hps_arria_10 util quartus_locations_query.tcl]
		set cmd "advanced_device:source ${quartus_script_path};get_peripheral_location $part $atom_name $peripheral_index"
		set pad_data [ fix_degug_messages_crap $cmd ]
		return $pad_data
	}

	proc fix_degug_messages_crap {cmd} {
		set quartus_data [run_quartus_tcl_command $cmd]
		if { [string match   "msg_tcl_post_message*" $quartus_data ] } {
			set last_item [regexp {\{([a-zA-Z0-9_ ]+)\}$} $quartus_data match real_name ] 
			set cmd_data $real_name
		} else {
			set cmd_data [lindex $quartus_data  0]
		}
		
		return $cmd_data	
	}

	proc get_hps_io_peripheral_location {peripheral_name} {
		set cached 0
		variable hps_io
		if {[info exists hps_io($peripheral_name)]} {
			set location $hps_io($peripheral_name)
			set cached 1
		}

		if {!$cached} {
			variable part
			set atom_name [hps_io_peripheral_to_generic_atom_name $peripheral_name]
			
			set peripheral_index 0
			if {[is_peripheral_one_of_many $peripheral_name]} {
				set peripheral_index [get_peripheral_index $peripheral_name]
			}
			
			set location [query_quartus_for_location $part $atom_name $peripheral_index]
			
			# cache result
			set hps_io($peripheral_name) $location
		}
		return $location
	}


	proc query_quartus_for_pinmux_data {part } {
		set quartus_script_path [file join $::env(QUARTUS_ROOTDIR) .. ip altera altera_hps altera_hps_arria_10 util quartus_locations_query.tcl]
		set cmd "advanced_device:source ${quartus_script_path};get_pinmux_data $part"
		set pinmux_data [ fix_degug_messages_crap $cmd ]
		return $pinmux_data
	}
	proc get_pinmux_data { } {
		variable part
		set pinmux_data [query_quartus_for_pinmux_data $part ]
		return $pinmux_data
	}

	proc get_fpga_location {peripheral_name atom_name} {
		variable part
		if {![info exists part]} {
			return ""
		}
		
		set cached 0
		variable fpga_cache
		if {[info exists fpga_cache($peripheral_name)]} {
			set location $fpga_cache($peripheral_name)
			set cached 1
			if { [string first "wrong" $location ] != -1  } {
				set cached 0
			}
		}

		if {!$cached} {
			set peripheral_index 0
			if {[is_peripheral_one_of_many $peripheral_name]} {
				set peripheral_index [get_peripheral_index $peripheral_name]
			}
			
			set location [query_quartus_for_location $part $atom_name $peripheral_index]
			# cache result
			set fpga_cache($peripheral_name) $location
		}
		return $location
	}
}
