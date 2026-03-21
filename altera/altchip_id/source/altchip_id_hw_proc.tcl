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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/altchip_id/source/altchip_id_hw_proc.tcl#1 $
# | 
# +-----------------------------------

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaboration_callback {} {
	
	update_device_type_params elaboration
	update_id_value_string_param
	
}

proc update_device_type_params {flag} {

	set get_device_family [get_parameter_value DEVICE_FAMILY]
	set device_families_list [get_module_property SUPPORTED_DEVICE_FAMILIES]
	
	if {([check_device_family_equivalence $get_device_family $device_families_list] != 1)} {
		send_message error "Altera Unique Chip ID is not supported on $get_device_family device family."
	}
	
}

proc update_id_value_string_param {} {
	
	set required_id_value_str 0
	
	set get_device_family [get_parameter_value DEVICE_FAMILY]
	if {$get_device_family == "MAX 10"} {
		set required_id_value_str 1
	}

	if {$required_id_value_str} {
		set id_value_in_hex_str [format "%x" [get_parameter_value ID_VALUE]]
		set expected_id_value_strlen [expr [get_parameter_property ID_VALUE WIDTH] / 4]
		
		# Convert id_value STD_LOGIC_VECTOR to STRING format
		# We start use string in MAX 10 to avoid mixed VHDL/VERILOG language compilation type mismatched issue in VCS simulator.
		set id_value_in_strlen [string length $id_value_in_hex_str]
		set padding_size [expr $expected_id_value_strlen - $id_value_in_strlen]
		for {set i 0} {$i < $padding_size} {incr i} {
			set id_value_in_hex_str "0$id_value_in_hex_str"
		}
		
		set_parameter_property ID_VALUE_STR HDL_PARAMETER true
		set_parameter_property ID_VALUE_STR ENABLED true
		set_parameter_value ID_VALUE_STR $id_value_in_hex_str
		send_message debug "Convert id_value to string: [get_parameter_value ID_VALUE_STR]"

	} else {

		set_parameter_property ID_VALUE_STR HDL_PARAMETER false
	}
}

# +-----------------------------------
# | Callback function when generating variation file
# +-----------------------------------
proc generate_synth {entityname} {

	send_message info "generating top-level entity $entityname"
	add_fileset_file altchip_id.v VERILOG PATH "altchip_id.v"

}

proc generate_vhdl_sim {entityname} {

	if {1} {
		add_fileset_file mentor/altchip_id.v VERILOG_ENCRYPT PATH "../mentor/source/altchip_id_simulation.v" {MENTOR_SPECIFIC}
	}

	if {1} {
		add_fileset_file cadence/altchip_id.v VERILOG_ENCRYPT PATH "../cadence/source/altchip_id_simulation.v" {CADENCE_SPECIFIC}
	}

	if {1} {
		add_fileset_file synopsys/altchip_id.v VERILOG_ENCRYPT PATH "../synopsys/source/altchip_id_simulation.v" {SYNOPSYS_SPECIFIC}
	}

	if {1} {
		add_fileset_file aldec/altchip_id.v VERILOG_ENCRYPT PATH "../aldec/source/altchip_id_simulation.v" {ALDEC_SPECIFIC}
	}
}

proc generate_verilog_sim {entityname} {

	add_fileset_file altchip_id.v VERILOG PATH "altchip_id_simulation.v"

}
