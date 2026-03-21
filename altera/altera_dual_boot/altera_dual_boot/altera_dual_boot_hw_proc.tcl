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
# | $Header: //acds/rel/18.1std/ip/altera_dual_boot/altera_dual_boot/altera_dual_boot_hw_proc.tcl#1 $
# | 
# +-----------------------------------

#//////////////////////////////////////////////////////////////////////////
#
# Name:     elaboration_callback
#
# Purpose:  Update device parameters and port settings
#
#//////////////////////////////////////////////////////////////////////////
proc elaboration_callback {} {

	update_device_type_params
	setup_clock_cycle
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     update_device_type_params
#
# Purpose:  Check compatibility of device family
#
# Returns:  n/a
#
#//////////////////////////////////////////////////////////////////////////
proc update_device_type_params {} {

	set get_device_family [get_parameter_value INTENDED_DEVICE_FAMILY]
	
	if {!($get_device_family == "MAX 10")} {
		send_message error "altera_dual_boot does not support selected device family $get_device_family"
	}
	
}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     setup_clock_cycle
#
# Purpose:  Dynamic adjust parameters based on clock
#
#//////////////////////////////////////////////////////////////////////////
	
proc setup_clock_cycle {}	{
	set clock_frequency_mhz [get_parameter_value CLOCK_FREQUENCY]
	set config_cycle [expr (ceil(350*(pow(10,-9)) * ($clock_frequency_mhz * pow(10,6))))]
	set reset_cycle [expr (ceil(500*(pow(10,-9)) * ($clock_frequency_mhz * pow(10,6))))]
	set_parameter_value CONFIG_CYCLE $config_cycle
	send_message debug "CONFIG_CYCLE = [get_parameter_value CONFIG_CYCLE]"
	set_parameter_value RESET_TIMER_CYCLE $reset_cycle
	send_message debug "RESET_TIMER_CYCLE = [get_parameter_value RESET_TIMER_CYCLE]"
}

# +-----------------------------------
# | Callback function when generating variation file
# +-----------------------------------
proc generate_synth {entityname} {

	send_message info "generating top-level entity $entityname"
	add_fileset_file altera_dual_boot.v VERILOG PATH "altera_dual_boot.v"
	add_fileset_file ../rtl/alt_dual_boot_avmm.v VERILOG PATH "../rtl/alt_dual_boot_avmm.v"
	add_fileset_file ../rtl/alt_dual_boot.v VERILOG PATH "../rtl/alt_dual_boot.v"
}

proc generate_verilog_sim {entityname} {

	add_fileset_file altera_dual_boot.v VERILOG PATH "altera_dual_boot.v"
	add_fileset_file ../rtl/alt_dual_boot_avmm.v VERILOG PATH "../rtl/alt_dual_boot_avmm.v"
	add_fileset_file ../rtl/alt_dual_boot.v VERILOG PATH "../rtl/alt_dual_boot.v"
}

proc generate_vhdl_sim {entityname} {

	if {1} {
		generate_vendor_encrypt_fileset_file mentor
	}
	if {1} {
		generate_vendor_encrypt_fileset_file aldec
	}
	if {1} {
		generate_vendor_encrypt_fileset_file cadence
	}
	if {1} {
		generate_vendor_encrypt_fileset_file synopsys
	}
}

proc generate_vendor_encrypt_fileset_file { vendor } {

	set vendor_uppercase "[ string toupper $vendor ]"
	
	add_fileset_file ${vendor}/altera_dual_boot.v VERILOG_ENCRYPT PATH "${vendor}/altera_dual_boot.v" "${vendor_uppercase}_SPECIFIC"
	add_fileset_file ${vendor}/alt_dual_boot_avmm.v VERILOG_ENCRYPT PATH "../rtl/${vendor}/alt_dual_boot_avmm.v" "${vendor_uppercase}_SPECIFIC"
	add_fileset_file ${vendor}/alt_dual_boot.v VERILOG_ENCRYPT PATH "../rtl/${vendor}/alt_dual_boot.v" "${vendor_uppercase}_SPECIFIC"
}
