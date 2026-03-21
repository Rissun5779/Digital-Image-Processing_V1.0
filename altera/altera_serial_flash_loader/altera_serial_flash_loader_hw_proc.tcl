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
# | $Header: //acds/rel/18.1std/ip/altera_serial_flash_loader/altera_serial_flash_loader_hw_proc.tcl#1 $
# | 
# +-----------------------------------


# +-----------------------------------
# | Callback procedure for parameters
# +-----------------------------------
proc update_ui_parameters {arg} 	{
	general_parameters_procedure ui_settings
}


# --- Shared asmi settings --- #
proc update_shared_access {arg} 	{
	set shared_access [get_parameter_value gui_shared_access]
	
	if { $shared_access eq "true" } {
		set_parameter_value ENABLE_SHARED_ACCESS "ON"
	} else {
		set_parameter_value ENABLE_SHARED_ACCESS "OFF"
	}
}


# +-----------------------------------
# | Set UI Interface during elaboration callback
# +-----------------------------------
proc elaboration {}		{
	# --- update ports in block diagram with regards to parameter changes --- #
	general_parameters_procedure port_settings
}


# +-----------------------------------
# | Callback function when generating variation file
# +-----------------------------------
proc generate_synth {entityname} {

	send_message info "generating top-level entity $entityname"
    
    # --- update ports in top level file via terp with regards to parameter changes --- #
    general_parameters_procedure rtl_file_gen
}

proc general_parameters_procedure {flag}	{

	# --- list of supported devices --- #
	set advanced_fpga_family_list	{"Arria 10" "Arria V" "Arria V GZ" "Cyclone V" "Stratix V"}
	set multiple_ncs_family_list	{"Arria 10"}

	# --- variables --- #
	set get_device_setting		[get_parameter_value INTENDED_DEVICE_FAMILY]
	set is_shared_access		[get_parameter_value gui_shared_access]
	set is_enhanced_mode		[get_parameter_value ENHANCED_MODE]

	# --- checking for information --- #
	set is_advanced_fpga_family			"false"
	set is_multiple_ncs_family			"false"
	set is_single_advanced_fpga_family	"false"
	set ncso_width						1
    set bool_shared_access				"false"
    set bool_advanced_shared_access		"false"
	
	# --- check device family support --- #
	if {[check_device_family_equivalence $get_device_setting $advanced_fpga_family_list]} {
		set is_advanced_fpga_family	"true"
	}

	if {[check_device_family_equivalence $get_device_setting $multiple_ncs_family_list]} {
		set is_multiple_ncs_family	"true"
	}

	if {[check_device_family_equivalence $get_device_setting "MAX 10"]} {
		set is_single_advanced_fpga_family	"true"
	}
    
    if {$is_shared_access eq "true"} {
        if {$is_advanced_fpga_family eq "true"} {
            set bool_shared_access				"false"
            set bool_advanced_shared_access		"true"
        } else {
            set bool_shared_access				"true"
            set bool_advanced_shared_access		"false"
        }
    }
    
    # +-----------------------------------
	# --- update ports in top level file via terp with regards to parameter changes --- #
	# +-----------------------------------
	if {$flag eq "rtl_file_gen"} {
    
        set this_dir      [ get_module_property MODULE_DIRECTORY ]
        set template_file [ file join $this_dir "altera_serial_flash_loader.v.terp" ]
        set template    [ read [ open $template_file r ] ]
    
        set params(is_shared_access) $is_shared_access
        set params(bool_shared_access) $bool_shared_access
        set params(bool_advanced_shared_access) $bool_advanced_shared_access
        set result          [ altera_terp $template params ]
    
        set output_file     [ create_temp_file altera_serial_flash_loader.v ]
        set output_handle   [ open $output_file w ]
    
        puts $output_handle $result
        close $output_handle
        
        add_fileset_file altera_serial_flash_loader.v VERILOG PATH ${output_file}
        
	} else {
    
        # --- Setting IP parameters --- #
        # nsco width parameter
        if {$is_multiple_ncs_family eq "true"}	{
            set ncso_width	3
        } else {
            set ncso_width	1
        }
        set_parameter_value NCSO_WIDTH $ncso_width

        # shared access parameter
        if { $is_shared_access eq "true" } {
            set_parameter_value ENABLE_SHARED_ACCESS "ON"
        } else {
            set_parameter_value ENABLE_SHARED_ACCESS "OFF"
        }
        
        # enable quad spi support parameter
        if {$is_advanced_fpga_family eq "true"} {
            set_parameter_value	ENABLE_QUAD_SPI_SUPPORT	1
        } else {
            set_parameter_value	ENABLE_QUAD_SPI_SUPPORT	0
        }
        
        if {($is_advanced_fpga_family eq "true") || ($is_single_advanced_fpga_family eq "true")} {
            set_parameter_property	ENHANCED_MODE	ENABLED	false
        } else {
            set_parameter_property	ENHANCED_MODE	ENABLED true
        }
    
        # +-----------------------------------
        # --- update ui settings for parameters with regards to device family --- #
        # +-----------------------------------
        if {$flag eq "ui_settings"} {
            if {($is_advanced_fpga_family eq "true") || ($is_single_advanced_fpga_family eq "true")} {
                set_parameter_value		ENHANCED_MODE	1
            } 
        }
        
        # +-----------------------------------
        # --- update ports in block diagram with regards to parameter changes --- #
        # +-----------------------------------
        if {$flag eq "port_settings"} {
        
            # --- input ports --- #
            my_add_interface_port	"in"	"dclk_in"				"dclkin"				1				$is_shared_access
            my_add_interface_port	"in"	"ncso_in"				"scein"					$ncso_width		$is_shared_access
            my_add_interface_port	"in"	"asdo_in"				"sdoin"					1				$bool_shared_access
            my_add_interface_port	"in"	"data_in"				"data_in"				4				$bool_advanced_shared_access
            my_add_interface_port	"in"	"data_oe"				"data_oe"				4				$bool_advanced_shared_access
            my_add_interface_port	"in"	"noe_in"				"noe"					1				"true"
            my_add_interface_port	"in"	"asmi_access_granted"	"asmi_access_granted"	1				$is_shared_access

            # --- output ports --- #
            my_add_interface_port	"out"	"data0_out"				"data0out"				1				$bool_shared_access
            my_add_interface_port	"out"	"data_out"				"data_out"				4				$bool_advanced_shared_access
            my_add_interface_port	"out"	"asmi_access_request"	"asmi_access_request"	1				$is_shared_access
        }
	} 
}

# +-----------------------------------
# | Procedure for ports creation
# +-----------------------------------
proc my_add_interface_port {port_type megafunction_port_name module_port_name port_width port_gen} {
	
	if {$port_gen eq "true"} {
		if {$port_type eq "in"} {
			add_interface $megafunction_port_name conduit end
			add_interface_port $megafunction_port_name $megafunction_port_name $module_port_name Input $port_width
		} elseif {$port_type eq "out"} {
			add_interface $megafunction_port_name conduit start
			set_interface_assignment $megafunction_port_name "ui.blockdiagram.direction" OUTPUT
			add_interface_port $megafunction_port_name $megafunction_port_name $module_port_name Output $port_width
		} else {
			send_message error "Illegal port type"
		}
	}
}

