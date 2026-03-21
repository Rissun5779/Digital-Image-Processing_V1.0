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
#   $Header: //acds/rel/18.1std/ip/altera_hps/altera_hps_arria_10/util/pin_mux_db.tcl#1 $
#
#   Description: hw.tcl API for accessing HPS pin muxing data.
#                   The pin mux is generated externaly..
#
#   Author: Alberto Cid
#   Date:   2013.12.03
#
###############################################################################


package require altera_hwtcl_qtcl

source ../util/locations.tcl

namespace eval ::pin_mux_db {
    # TODO: put procedures in a package and package require it
    source "$::env(QUARTUS_ROOTDIR)/../ip/altera/altera_hps/altera_hps_arria_10/util/procedures.tcl"

    variable cache_base_device
    variable cache_base_device_result
        
    proc verify_soc_device {device} {
        if {[string match   "10AS*" $device ]} { 
            return 1
        } else {
            return 0
        }
    }

    
    proc verify_base_device {device} {
        variable cache_base_device
        variable cache_base_device_result

        if { ![info exists cache_base_device] } {
            set cache_base_device "foo"
        }
        if { ![info exists cache_base_device_result ] } {
            set cache_base_device "foo"
        } else {
			if {[string match   "*wrong*" $cache_base_device_result ]} {
				set cache_base_device "foo"
			}		
		}
        if { [string compare -nocase $cache_base_device $device] == 0  } {
            #send_message info "SANTI 00: use cache device $cache_base_device $device"
        } else { 
            #send_message info "SANTI 01: set device $cache_base_device $device"
            set cache_base_device $device
            set quartus_script_path "$::env(QUARTUS_ROOTDIR)/../ip/altera/altera_hps/altera_hps_arria_10/util/quartus_pin_mux_db_part_query.tcl"
            set result [lindex [run_quartus_tcl_command "advanced_device:source ${quartus_script_path};get_bace_device $device"] 0]
            set cache_base_device_result $result
			

        }
        
        return $cache_base_device_result
    }
    
    proc get_speed_grade {device} {
        set quartus_script_path "$::env(QUARTUS_ROOTDIR)/../ip/altera/altera_hps/altera_hps_arria_10/util/quartus_pin_mux_db_part_query.tcl"
        set speed_grade [lindex [run_quartus_tcl_command "advanced_device:source ${quartus_script_path};get_speed_grade $device"] 0]
        return $speed_grade
    }
    
    proc get_pin_to_ball_name_table {device} {
        set base_device [verify_base_device $device]
        
        array set pad_to_ball_name {}
        
        set location_map [locations::get_pad_to_pkg_map ]
        foreach {pad_id ball_name } $location_map {
            set pad_name "PAD_${pad_id}"
            set pad_to_ball_name($pad_name) $ball_name
        }
        
        array set pin_to_ball_name {}
        set csv_file [get_pinmux_csv]
        csv_foreach_row $csv_file cols {  
            
            get_csv_data $cols $base_device index pad_name valid_pins pin_name send_error
            # Work with pad name and pin name    
            set ball_name $pad_to_ball_name($pad_name)
            
            set pin_name [string map { "HPS_DIRECT_SHARED_" ""  } $pin_name]
            set pin_name [string map { "HPS_DEDICATED_"     "D_"} $pin_name]
            
            set pin_to_ball_name($pin_name) $ball_name
        }
        return [ array get pin_to_ball_name ]
    }

    proc get_pinmux_csv {} {
        set csv_file [file join $::env(QUARTUS_ROOTDIR) .. ip altera altera_hps altera_hps_arria_10 hps "pinmux.csv"]
        return $csv_file
    }
    proc load_pin_mux_table {device} {
        set base_device [verify_base_device $device]
        set send_error false
        set csv_file [get_pinmux_csv]
        csv_foreach_row $csv_file cols {  
            
            get_csv_data $cols $base_device index pad_name valid_pins pin_name send_error
            
            set peripheral_ports($pad_name) $valid_pins 
        }
        if { $send_error } {
            send_message debug "Unsupported device $base_device"
            send_message error "Unsupported device $device"
        }
        
        return [ array get peripheral_ports ]
    }
    proc load_gpio_index_table {device} {
        set base_device [verify_base_device $device]    
        set csv_file [get_pinmux_csv]
        csv_foreach_row $csv_file cols {  
            
            get_csv_data $cols $base_device index pad_name valid_pins pin_name send_error
            
            set gpio_locations($index) $pad_name    
        }
        return [ array get gpio_locations ]
    }
    
    proc load_pad_to_index_table {device} {
        set base_device [verify_base_device $device]    
        set csv_file [get_pinmux_csv]
        csv_foreach_row $csv_file cols {  
            
            get_csv_data $cols $base_device index pad_name valid_pins pin_name send_error
            
            set pad_to_index($pad_name) $index
        }
        return [ array get pad_to_index ]
    }
    
    proc load_pad_to_pin_name {device} {
        set base_device [verify_base_device $device]

        set csv_file [get_pinmux_csv]
        csv_foreach_row $csv_file cols {  
            
            get_csv_data $cols $base_device index pad_name valid_pins pin_name send_error
            
            set pad_to_pin($pad_name) $pin_name
        }

        return [ array get pad_to_pin ]
    }
    
    
    proc get_csv_data {cols base_device index_ref pad_name_ref valid_pins_ref pin_name_ref send_error_ref} {
        upvar 1 $index_ref      index
        upvar 1 $pad_name_ref   pad_name
        upvar 1 $valid_pins_ref valid_pins
        upvar 1 $pin_name_ref   pin_name
        upvar 1 $send_error_ref send_error
        
        set send_error false
        
        set index        [string trim [lindex $cols 0]]
        set pad_name_nf1 [string trim [lindex $cols 1]]
        set pad_name_nf2 [string trim [lindex $cols 2]]
        set pad_name_nf3 [string trim [lindex $cols 3]]
        set pad_name_nf4 [string trim [lindex $cols 4]]
        set valid_pins   [string trim [lindex $cols 5]]
        set pin_name     [string trim [lindex $cols 6]]
            
        if { $base_device == "NIGHTFURY4" || $base_device == "NIGHTFURY4ES" } {
            set pad_name $pad_name_nf4
        } elseif { $base_device == "NIGHTFURY3" } {
            set pad_name $pad_name_nf3
        } elseif { $base_device == "NIGHTFURY2" } {
            set pad_name $pad_name_nf2
        } elseif { $base_device == "NIGHTFURY1" } {
            set pad_name $pad_name_nf1
        } else {
            set pad_name $pad_name_nf4
            set send_error true
        }
    }
    
}
