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

    
proc add_gpio_inst {core_name} {
    upvar ip_params ip_params
        
    add_instance $core_name altera_gpio

    foreach param_name [array names ip_params] {
        set param_val $ip_params($param_name)

        set_instance_parameter_value $core_name $param_name $param_val
    }
}

proc add_driver_inst {driver_name} {
    upvar ip_params ip_params

    add_instance $driver_name altera_gpio_driver

    foreach param_name [array names ip_params] {
        set param_val $ip_params($param_name)
        
        set_instance_parameter_value $driver_name $param_name $param_val
    }
}


create_system
set_project_property DEVICE_FAMILY $device_family

set core_name $gpio_name
set driver_name driver

add_gpio_inst $core_name
    
foreach interface_name [get_instance_interfaces $core_name] {
    add_interface ${core_name}_${interface_name} conduit end
    set_interface_property ${core_name}_${interface_name} EXPORT_OF ${core_name}.${interface_name}
}

save_system $ed_params(TMP_SYNTH_QSYS_PATH)

create_system
set_project_property DEVICE_FAMILY $device_family
add_gpio_inst $core_name

add_driver_inst $driver_name

foreach interface_name [get_instance_interfaces $driver_name] {
	add_connection ${core_name}.${interface_name}/${driver_name}.${interface_name}
}

save_system $ed_params(TMP_SIM_QSYS_PATH)


