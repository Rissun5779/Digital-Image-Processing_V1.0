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


#Select the master service type and check for available service paths.
set service_paths [get_service_paths master]
#Set the master service path.
set master_service_path [lindex $service_paths 0]
#Open the master service.
set claimed_path [claim_service master $master_service_path mylib]

puts "\n############################################################################\n"

puts "Startup Complete\n"

set num_ports [master_read_8 $claimed_path 0x00 1] 

puts "Setup GUI\n"

#Create GUI (dash)
variable dash [add_service dashboard hmcc_ex_design_dashboard "HMCC_Example_Design" "Tools/HMCC_Example_Design"]
#Allow Overwriting GUI
dashboard_set_property $dash self developmentMode true
dashboard_set_property $dash self visible true
dashboard_set_property $dash self itemsPerRow 1

#Create Group for Row 0
dashboard_add $dash led_group_0 group self
dashboard_set_property $dash led_group_0 itemsPerRow 1
dashboard_set_property $dash led_group_0 title "Board LEDs"

dashboard_add $dash led_0_3 led led_group_0
dashboard_add $dash led_0_2 led led_group_0
dashboard_add $dash led_0_1 led led_group_0
dashboard_add $dash led_0_0 led led_group_0

dashboard_set_property $dash led_0_3 color red_off
dashboard_set_property $dash led_0_2 color green_off
dashboard_set_property $dash led_0_1 color green_off
dashboard_set_property $dash led_0_0 color red_off

dashboard_set_property $dash led_0_3 text "Heartbeat"
dashboard_set_property $dash led_0_2 text "HMC Link Init Complete"
dashboard_set_property $dash led_0_1 text "Test Passed"
dashboard_set_property $dash led_0_0 text "Test Failed"

#Create Group for Row 1
dashboard_add $dash led_group_1 group self
dashboard_set_property $dash led_group_1 itemsPerRow 1
dashboard_set_property $dash led_group_1 title "Init Status"

dashboard_add $dash led_1_3 led led_group_1
dashboard_add $dash led_1_2 led led_group_1
dashboard_add $dash led_1_1 led led_group_1
dashboard_add $dash led_1_0 led led_group_1

dashboard_set_property $dash led_1_3 color green_off
dashboard_set_property $dash led_1_2 color green_off
dashboard_set_property $dash led_1_1 color green_off
dashboard_set_property $dash led_1_0 color green_off

dashboard_set_property $dash led_1_3 text "I2C Clock Generators Set"
dashboard_set_property $dash led_1_2 text "PLL/XCVR Recalibration"
dashboard_set_property $dash led_1_1 text "I2C HMC Config"
dashboard_set_property $dash led_1_0 text "HMC Link Init Complete"

#Create Group for Row 2
dashboard_add $dash led_group_2 group self
dashboard_set_property $dash led_group_2 itemsPerRow 4
dashboard_set_property $dash led_group_2 title "Request Generator Status"

if {$num_ports > 3} {
    dashboard_add $dash led_2_3 led led_group_2
    dashboard_set_property $dash led_2_3 color green_off
    dashboard_set_property $dash led_2_3 text "Port 3"
}

if {$num_ports > 2} {
    dashboard_add $dash led_2_2 led led_group_2
    dashboard_set_property $dash led_2_2 color green_off
    dashboard_set_property $dash led_2_2 text "Port 2"
}

if {$num_ports > 1} {
    dashboard_add $dash led_2_1 led led_group_2
    dashboard_set_property $dash led_2_1 color green_off
    dashboard_set_property $dash led_2_1 text "Port 1"
}

dashboard_add $dash led_2_0 led led_group_2
dashboard_set_property $dash led_2_0 color green_off
dashboard_set_property $dash led_2_0 text "Port 0"

#Create Group for Row 3
dashboard_add $dash led_group_3 group self
dashboard_set_property $dash led_group_3 itemsPerRow 4
dashboard_set_property $dash led_group_3 title "Response Checker Status"

if {$num_ports > 3} {
    dashboard_add $dash led_3_3 led led_group_3
    dashboard_set_property $dash led_3_3 color green_off
    dashboard_set_property $dash led_3_3 text "Port 3"
}

if {$num_ports > 2} {
    dashboard_add $dash led_3_2 led led_group_3
    dashboard_set_property $dash led_3_2 color green_off
    dashboard_set_property $dash led_3_2 text "Port 2"
}

if {$num_ports > 1} {
    dashboard_add $dash led_3_1 led led_group_3
    dashboard_set_property $dash led_3_1 color green_off
    dashboard_set_property $dash led_3_1 text "Port 1"
}

dashboard_add $dash led_3_0 led led_group_3
dashboard_set_property $dash led_3_0 color green_off
dashboard_set_property $dash led_3_0 text "Port 0"

#Create Group for Row 4
dashboard_add $dash test_ctrl_group group self
dashboard_set_property $dash test_ctrl_group itemsPerRow 2
dashboard_set_property $dash test_ctrl_group title "Test Control"

#Create button in Row 5
proc reset {claimed_path dash} {
	master_write_8 $claimed_path 0x0 0x0
}

dashboard_add $dash reset_button button test_ctrl_group
dashboard_set_property $dash reset_button onClick [list reset $claimed_path $dash]
dashboard_set_property $dash reset_button text "Re-Test"

#Create monitor and setup callback to update the GUI at 20 Hz
puts "Setup Monitor"

set monitor_0 [lindex [get_service_paths monitor] 0]
set claimed_monitor_0 [claim_service monitor $monitor_0 mylib]

monitor_add_range $claimed_monitor_0 $master_service_path 0x1 3
monitor_set_interval $claimed_monitor_0 50

proc monitor_board_leds_data_to_GUI {dash monitor master_service_path num_ports address bytes} {
	set data [monitor_read_data $monitor $master_service_path $address $bytes]
	#Heartbeat
	if {[lindex $data 0] & 0x08} {
		dashboard_set_property $dash led_0_3 color red
	} else {
		dashboard_set_property $dash led_0_3 color red_off
	}
    #HMC Link Init Complete
	if {[lindex $data 0] & 0x04} {
		dashboard_set_property $dash led_0_2 color green
	} else {
		dashboard_set_property $dash led_0_2 color green_off
	}
	#Test Passed
	if {[lindex $data 0] & 0x02} {
		dashboard_set_property $dash led_0_1 color green
	} else {
		dashboard_set_property $dash led_0_1 color green_off
	}
    #Test Failed
	if {[lindex $data 0] & 0x01} {
		dashboard_set_property $dash led_0_0 color red
	} else {
		dashboard_set_property $dash led_0_0 color red_off
	}

#INIT
    #I2C Clock Generators Set
	if {[lindex $data 1] & 0x01} {
		dashboard_set_property $dash led_1_3 color green
	} else {
		dashboard_set_property $dash led_1_3 color green_off
	}
	#PLL/XCVR Recalibration
	if {[lindex $data 1] & 0x02} {
		dashboard_set_property $dash led_1_2 color green
	} else {
		dashboard_set_property $dash led_1_2 color green_off
	}
	#I2C HMC Config
	if {[lindex $data 1] & 0x04} {
		dashboard_set_property $dash led_1_1 color green
	} else {
		dashboard_set_property $dash led_1_1 color green_off
	}
	#HMC Link Init Complete
	if {[lindex $data 1] & 0x08} {
		dashboard_set_property $dash led_1_0 color green
	} else {
		dashboard_set_property $dash led_1_0 color green_off
	}
    
#Req and Res
	
	if {[lindex $data 2] & 0x01} {
		dashboard_set_property $dash led_2_0 color green
	} else {
		dashboard_set_property $dash led_2_0 color green_off
	}
	
	if {[lindex $data 2] & 0x02} {
		dashboard_set_property $dash led_3_0 color green
	} else {
		dashboard_set_property $dash led_3_0 color green_off
    }
	
    
	if {$num_ports > 1} {
        if {[lindex $data 2] & 0x04} {
            dashboard_set_property $dash led_2_1 color green
        } else {
            dashboard_set_property $dash led_2_1 color green_off
        }

        if {[lindex $data 2] & 0x08} {
            dashboard_set_property $dash led_3_1 color green
        } else {
            dashboard_set_property $dash led_3_1 color green_off
        }
    }
    if {$num_ports > 2} {
        if {[lindex $data 2] & 0x10} {
            dashboard_set_property $dash led_2_2 color green
        } else {
            dashboard_set_property $dash led_2_2 color green_off
        }
        
        if {[lindex $data 2] & 0x20} {
            dashboard_set_property $dash led_3_2 color green
        } else {
            dashboard_set_property $dash led_3_2 color green_off
        }
    }
    if {$num_ports > 3} {
        if {[lindex $data 2] & 0x40} {
            dashboard_set_property $dash led_2_3 color green
        } else {
            dashboard_set_property $dash led_2_3 color green_off
        }
        
        if {[lindex $data 2] & 0x80} {
            dashboard_set_property $dash led_3_3 color green
        } else {
            dashboard_set_property $dash led_3_3 color green_off
        }
    }
}

set callback_0 [list monitor_board_leds_data_to_GUI $dash $claimed_monitor_0 $master_service_path $num_ports 0x1 3]
monitor_set_callback $claimed_monitor_0 $callback_0

monitor_set_enabled $claimed_monitor_0 1