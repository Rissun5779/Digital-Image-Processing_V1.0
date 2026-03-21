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



proc sleep {N} {
	after [expr {int($N * 1000)}]
}

proc dec2bin {i} {
    set res {} 
    while {$i>0} {
        set res [expr {$i%2}]$res
        set i [expr {$i/2}]
    }
    if {$res == {}} {set res 0}
    return $res
}



set project_name [lindex $argv 0]
if {$project_name == ""} {
	set project_name "phylite_debug_kit"
}

set num_runs 1 

project_open $project_name

if {[llength get_hardware_names] != 1} {
	post_message -type error "Fatal Error: Expected 1 hardware name but found [llength get_hardware_names]"
	qexit -error
}

set hardware_index 1
set device_index  0
set hardware_name [lindex [get_hardware_names] $hardware_index]
post_message -type info "Found hardware called $hardware_name"
set device_name [lindex [get_device_names -hardware_name $hardware_name] $device_index]
post_message -type info "Using device $device_name"

set rst_index -1
set lock_index -1
set done_index -1

set iss_instances [get_insystem_source_probe_instance_info -hardware_name $hardware_name -device_name $device_name]

foreach inst $iss_instances {
	set index [lindex $inst 0]
	set source_width [lindex $inst 1]
	set probe_width [lindex $inst 2]
	set name [lindex $inst 3]
	post_message -type info "Found ISS called $name ($index) Probe/Source Width: $probe_width/$source_width"
	
	if {[string equal $name "RST"]} {
		set rst_index $index
	} elseif {[string equal $name "LOCK"]} {
		set lock_index $index
	} elseif {[string equal $name "DONE"]} {
		set done_index $index
    }
	
}

if {$rst_index == -1 || $lock_index == -1 || $done_index == -1} {
	post_message -type error "Fatal Error: Expected probe ID not found"
	qexit -error
}

set f [open "board_results.txt" w]

post_message -type info "Starting insystem probes"
start_insystem_source_probe -hardware_name $hardware_name -device_name $device_name

set num_passes 0
for {set run_idx 0} {$run_idx < $num_runs} {incr run_idx} {

	post_message -type info "De-asserting reset_n signal"
	write_source_data -instance_index $rst_index -value 1
	post_message -type info "Asserting reset_n signal"
	write_source_data -instance_index $rst_index -value 0
	post_message -type info "De-asserting reset_n signal"
	write_source_data -instance_index $rst_index -value 1

	set lock [read_probe_data -instance_index $lock_index]

	post_message -type info "Polling on lock signal"
	set time_at_start [clock seconds]
	set timeout 2
	while {!$lock} {
		set time_now [clock seconds]
		if {[expr {$time_now - $time_at_start}] > $timeout} {
			post_message -type error "Timed out polling for lock signal"
			break;
		}
		set lock [read_probe_data -instance_index $lock_index]
	}

    set done [read_probe_data -instance_index $done_index]

	if {$lock} {
		post_message -type info "Polling on done signal"
		set time_at_start [clock seconds]
		set timeout 30

		while {!$done} {
			set time_now [clock seconds]
			if {[expr {$time_now - $time_at_start}] > $timeout} {
				post_message -type error "Timed out polling for done signal"
				break;
			}
			set done [read_probe_data -instance_index $done_index]
		}


	}

	if {$done && $lock} {
		incr num_passes
	}

}

if {$num_passes > 0} {
	post_message -type info "Test PASSED $num_passes/$num_runs times"
} else {
	post_message -type error "Test FAILED"
}
	
end_insystem_source_probe
project_close

