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


package require -exact qsys 15.0


proc safe_string_compare { string_1 string_2 } {
	set ret_val [expr {[string compare -nocase $string_1 $string_2] == 0}]
	return $ret_val
}


create_system
set_project_property DEVICE_FAMILY $device_family


set core_name $oct_name
set driver_name driver

add_instance $core_name altera_oct

foreach param_name [array names ip_params] {
	set param_val $ip_params($param_name)

	set_instance_parameter_value $core_name $param_name $param_val
}

foreach interface_name [get_instance_interfaces $core_name] {
	add_interface ${core_name}_${interface_name} conduit end
	set_interface_property ${core_name}_${interface_name} EXPORT_OF ${core_name}.${interface_name}
}

foreach param_name [array names ip_params] {
	if {[safe_string_compare $param_name "OCT_CAL_NUM"]} {
		set size $ip_params($param_name)
		
		for { set i 0 } { $i < ${size} } {incr i } {		
			add_instance mybuffer_${i} altera_gpio
			
			set_instance_parameter_value mybuffer_${i} PIN_TYPE "output"
			set_instance_parameter_value mybuffer_${i} gui_io_reg_mode "none"
			set_instance_parameter_value mybuffer_${i} gui_hr_logic "false"
			set_instance_parameter_value mybuffer_${i} gui_diff_buff "false"
			set_instance_parameter_value mybuffer_${i} gui_separate_io_clks "false"
			set_instance_parameter_value mybuffer_${i} SIZE 48
			set_instance_parameter_value mybuffer_${i} gui_enable_termination_ports "true"
			
			add_interface ex_din_${i} conduit end
			set_interface_property ex_din_${i} EXPORT_OF mybuffer_${i}.\din
			add_interface ex_pad_${i} conduit end
			set_interface_property ex_pad_${i} EXPORT_OF mybuffer_${i}.pad_out
			
			remove_interface ${core_name}_oct_${i}_series_termination_control
			add_connection ${core_name}.oct_${i}_series_termination_control/mybuffer_${i}.\seriesterminationcontrol
			remove_interface ${core_name}_oct_${i}_parallel_termination_control
			add_connection ${core_name}.oct_${i}_parallel_termination_control/mybuffer_${i}.\parallelterminationcontrol
		}
	}
}

save_system $ed_params(TMP_SYNTH_QSYS_PATH)

create_system
set_project_property DEVICE_FAMILY $device_family
add_instance $core_name altera_oct

foreach param_name [array names ip_params] {
	set param_val $ip_params($param_name)

	set_instance_parameter_value $core_name $param_name $param_val
}

foreach param_name [array names ip_params] {
	if {[safe_string_compare $param_name "OCT_CAL_NUM"]} {
		set size $ip_params($param_name)
		
		for { set i 0 } { $i < ${size} } {incr i } {		
			add_instance mybuffer_${i} altera_gpio
			
			set_instance_parameter_value mybuffer_${i} PIN_TYPE "output"
			set_instance_parameter_value mybuffer_${i} gui_io_reg_mode "none"
			set_instance_parameter_value mybuffer_${i} gui_hr_logic "false"
			set_instance_parameter_value mybuffer_${i} gui_diff_buff "false"
			set_instance_parameter_value mybuffer_${i} gui_separate_io_clks "false"
			set_instance_parameter_value mybuffer_${i} SIZE 48
			set_instance_parameter_value mybuffer_${i} gui_enable_termination_ports "true"
			
			add_interface ex_din_${i} conduit end
			set_interface_property ex_din_${i} EXPORT_OF mybuffer_${i}.\din
			add_interface ex_pad_${i} conduit end
			set_interface_property ex_pad_${i} EXPORT_OF mybuffer_${i}.pad_out
			
			add_connection ${core_name}.oct_${i}_series_termination_control/mybuffer_${i}.\seriesterminationcontrol
			add_connection ${core_name}.oct_${i}_parallel_termination_control/mybuffer_${i}.\parallelterminationcontrol
		}
	}
}   
    
add_instance $driver_name altera_oct_driver

foreach param_name [get_instance_parameters $driver_name] {
    if {[info exists ip_params($param_name)]} {
        set_instance_parameter_value $driver_name $param_name $ip_params($param_name)
    }
}

foreach interface_name [get_instance_interfaces $driver_name] {
	add_connection ${core_name}.${interface_name}/${driver_name}.${interface_name}
}

save_system $ed_params(TMP_SIM_QSYS_PATH)


