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
# | $Header: //acds/rel/18.1std/ip/pgm/altera_arria10_chip_id/altera_arria10_chip_id_hw_proc.tcl#1 $
# | 
# +-----------------------------------

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaboration_callback {} {
	
	update_device_type_params elaboration
	
}

proc update_device_type_params {flag} {

	set get_device_family [get_parameter_value DEVICE_FAMILY]
	set device_families_list [get_module_property SUPPORTED_DEVICE_FAMILIES]
	
	if {([check_device_family_equivalence $get_device_family $device_families_list] != 1)} {
		send_message error "Altera Arria10 Unique Chip ID is not supported on $get_device_family device family."
	}
	
}

# +-----------------------------------
# | Callback function when generating variation file
# +-----------------------------------
proc generate_synth {entityname} {

	send_message info "generating top-level entity $entityname"
	add_fileset_file altera_arria10_chip_id.v VERILOG PATH "altera_arria10_chip_id.v"
	add_fileset_file altera_chip_id_a10.sv SYSTEM_VERILOG PATH "altera_chip_id_a10.sv"

}

proc sim_callback_procedure { entity_name } {
    add_fileset_file altera_arria10_chip_id.v VERILOG PATH "altera_arria10_chip_id_sim.v"
}
