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


package provide ip_migrate 1.0

namespace eval ::ip_migrate {
	namespace export do_port_mappings
	
	variable port_mappings [dict create]
}

# Internal helper that scrub lines in CSV file.
proc scrub_csv {line} {
	# Excel does strange things with quotes
	if {[string index $line 0] == {"}} {
		set line [string range $line 1 end]
	}
	if {[string index $line end] == {"}} {
		set line [string range $line 0 end-1]
	}
	set line [regsub -all {""} $line {"}]
	return $line
}

proc ::ip_migrate::do_port_mappings {map_file_name} {
	variable port_mappings
	if {[dict size $port_mappings] == 0} {
		set csv_file [open $map_file_name "r"]
		set contents [split [read $csv_file] "\n"]
		close $csv_file
		
		# Parse migration map file
		set column_headings [dict create]
		set port_mapping [dict create]
		for {set row 0} {$row < [llength $contents]} {incr row} {
			set line [split [lindex $contents $row] ","]
			if {$row == 0} {
				for {set col 0} {$col < [llength $line]} {incr col} {
					dict set column_headings [lindex $line $col] $col
				}
			} else {
				set interface [scrub_csv [lindex $line [dict get $column_headings "INTERFACE"]]]
				set old_port_name [scrub_csv [lindex $line [dict get $column_headings "OLD_PORT_NAME"]]]
				set new_port_name [scrub_csv [lindex $line [dict get $column_headings "NEW_PORT_NAME"]]]
				
				if {![dict exists $port_mappings $interface]} {
					dict set port_mappings $interface OLD_PORTS [list]
					dict set port_mappings $interface NEW_PORTS [list]
				}
				dict set port_mappings $interface OLD_PORTS [linsert [dict get $port_mappings $interface OLD_PORTS] end $old_port_name]
				dict set port_mappings $interface NEW_PORTS [linsert [dict get $port_mappings $interface NEW_PORTS] end $new_port_name]
			}
		}
	}
	set interfaces [lsort [get_interfaces]]
	foreach interface [dict keys $port_mappings] {
		if {[lsearch -sorted $interfaces $interface] >= 0} {
			set old_ports [dict get $port_mappings $interface OLD_PORTS]
			set new_ports [dict get $port_mappings $interface NEW_PORTS]
			set port_name_map [list]
			for {set i 0} {$i < [llength $old_ports]} {incr i} {
				set port_name_map [linsert $port_name_map end [lindex $new_ports $i]]
				set port_name_map [linsert $port_name_map end [lindex $old_ports $i]]
			}
			set_interface_property $interface PORT_NAME_MAP [join $port_name_map " "]
		}
	}
}
