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


# This file has several functions to run in every reg test run. Is a mix of unitest with butld validation.
#
# Author: Alberto Cid
#


proc run_self_tests {} {
	
	set run_checks    [get_parameter_value RUN_INTERNAL_BUILD_CHECKS]
	
	if {$run_checks} {
		send_message warning "Internal test Enabled. This will be too slow. Disable them."
		
		set device [get_device]
		
		run_pin_mux_consistency $device
	}
}



proc run_pin_mux_consistency {device} {
	
	set csv_file [::pin_mux_db::get_pinmux_csv]
	
	array set hard_coded_pinmux_data {}
	
	set base_device [::pin_mux_db::verify_base_device $device]
	
	send_message info  "This is a $base_device" 
	csv_foreach_row $csv_file cols {  
		
		set pad_name_nf1 [string trim [lindex $cols 1]]
		set pad_name_nf2 [string trim [lindex $cols 2]]
		set pad_name_nf3 [string trim [lindex $cols 3]]
		set pad_name_nf4 [string trim [lindex $cols 4]]
		set pinmux_info  [string trim [lindex $cols 5]]
		#set pin_name     [string trim [lindex $cols 5]]
		
		if { $base_device == "NIGHTFURY4" || $base_device == "NIGHTFURY4ES"} {
			set pad_name $pad_name_nf4
		} elseif { $base_device == "NIGHTFURY3" } {
			set pad_name $pad_name_nf3
		} elseif { $base_device == "NIGHTFURY2" } {
			set pad_name $pad_name_nf2
		} elseif { $base_device == "NIGHTFURY1" } {
			set pad_name $pad_name_nf1
		} else {
			set pad_name $pad_name_nf4
		}
		set hard_coded_pinmux_data($pad_name) $pinmux_info
	}


	set raw_pinmux_data [locations::get_pinmux_data]
	
	set look_for_peri_list [list "EMAC"  "SPIS"  "SPIM" "USB" "UART" "NAND" "SDMMC" "QSPI" "GPIO"]
	
	foreach {pad_id pinmux_line } $raw_pinmux_data {
	
		if { $pinmux_line != "DDR"} {
			set pad_name "PAD_$pad_id"
			
			if {[info exists hard_coded_pinmux_data($pad_name)]} {
				
				set hard_data $hard_coded_pinmux_data($pad_name)
			
				send_message info  "$hard_data == $pinmux_line"
				
				set quartus_pin "INVALID_GPIO"
				set found 0
				foreach peri_data $pinmux_line {
					set peri_type 	[ lindex $peri_data 1 ]
					
					foreach look_for_per $look_for_peri_list {
						if { $peri_type == $look_for_per } {
							set found 1
							#GPIO2:IO13
							#{15 GPIO 1 IO 22 bidir}
							set instance_index [ lindex $peri_data 2 ]
							set port_name      [ lindex $peri_data 3 ]
							set bus_index      [ lindex $peri_data 4 ]
							
							# Ugly hack
							if { $peri_type == "SDMMC" && $port_name == "DATA" } {
								set port_name "D"
							}
							
							set quartus_pin "${peri_type}${instance_index}:${port_name}${bus_index}"
							
							if {[lsearch $hard_data $quartus_pin] == -1} {
								send_message error  "ERROR: Pad $quartus_pin missing in $hard_data"
							} else {
								send_message info " $quartus_pin for pad $pad_name in quartus databace  found in $hard_data"
							}
						}
					}
				}
				
				if {!$found} {
					send_message error  "ERROR: no GPIO was found in $pinmux_line for pad $pad_name in quartus databace"
				}
			} else {
				send_message error  "ERROR: Pad from pin mux databace not found in pinmux.csv: $pad_id $pinmux_line"
			}
		}
	}
}
