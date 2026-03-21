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
# | $Header: //acds/rel/18.1std/ip/altera_fault_injection/altera_fault_injection_hw_proc.tcl#1 $
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
    
	set export_pr_pins [expr ![get_parameter_value INSTANTIATE_PR_BLOCK]]
    
	# add pr interface if not auto-instantiate PR block
	add_interface pr_ready conduit end
	add_interface_port pr_ready pr_ready pr_ready Input 1
	set_interface_property pr_ready ENABLED $export_pr_pins
    
	add_interface pr_done conduit end
	add_interface_port pr_done pr_done pr_done Input 1
	set_interface_property pr_done ENABLED $export_pr_pins
    
	add_interface pr_error conduit end
	add_interface_port pr_error pr_error pr_error Input 1
	set_interface_property pr_error ENABLED $export_pr_pins
    
	add_interface pr_ext_request conduit end
	add_interface_port pr_ext_request pr_ext_request pr_ext_request Input 1
	set_interface_property pr_ext_request ENABLED $export_pr_pins
    
	add_interface pr_request conduit start
	add_interface_port pr_request pr_request pr_request Output 1
	set_interface_property pr_request ENABLED $export_pr_pins
    
	add_interface pr_clk conduit start
	add_interface_port pr_clk pr_clk pr_clk Output 1
	set_interface_property pr_clk ENABLED $export_pr_pins
    
	add_interface pr_data conduit start
	add_interface_port pr_data pr_data pr_data Output DATA_REG_WIDTH
	set_interface_property pr_data ENABLED $export_pr_pins
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
	
	set supported_device_families_list {"Arria 10" "Arria V" "Arria V GZ" "Cyclone V" "Stratix V"}

	set emr_width 67
	set data_reg_width 16
	
	if {![check_device_family_equivalence $get_device_family $supported_device_families_list]} {
		send_message error "altera_fault_injection does not support selected device family $get_device_family"
	}	

	if {[check_device_family_equivalence $get_device_family "Arria 10"]} {
		set emr_width 119
		set data_reg_width 32
	} else {
		set emr_width 67
		set data_reg_width 16
	}
    
    add_interface_port		avst_emr_snk emr_data data INPUT	$emr_width
    set_interface_property	avst_emr_snk dataBitsPerSymbol		$emr_width
    
    set_parameter_value     EMR_WIDTH   $emr_width
    set_parameter_value     DATA_REG_WIDTH   $data_reg_width
}
	
# +-----------------------------------
# | Callback function when generating variation file
# +-----------------------------------
proc generate_synth {entityname} {

	send_message info "generating top-level entity $entityname"
	add_fileset_file altera_fault_injection.vhd VHDL PATH "altera_fault_injection.vhd"

}