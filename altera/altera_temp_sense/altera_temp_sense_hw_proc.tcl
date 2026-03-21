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
# | $Header: //acds/rel/18.1std/ip/altera_temp_sense/altera_temp_sense_hw_proc.tcl#1 $
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

	# --- check ini for generating Arria 10 via cbx flow --- #
	set enable_a10_cbx	[get_quartus_ini cbx_allow_a10 ENABLED]

# +---------------------------------------
# | Set default port according to device
# +---------------------------------------
	set get_device_family [get_parameter_value DEVICE_FAMILY]
	set set_ce [get_parameter_value CE_CHECK]
	set set_clr [get_parameter_value CLR_CHECK]
	
	if {$get_device_family == "Arria 10"} {
		set bool_20nm_dev	"true"
		set bool_legacy_dev	"false"
		set bool_set_ce		"false"
		set bool_set_clr	"false"
		
		if {$enable_a10_cbx == 1} {
			set bool_en_clk	"true"
			
			# allow dummy clk port for Arria 10 due to clearbox issue
			send_message    info    "clk port is not in used since Arria 10 uses internal clock (1MHz)"
		
		} else {
			set bool_en_clk	"false"
			set_fileset_property quartus_synth TOP_LEVEL altera_temp_sense
		}
		
	} else {
		set bool_20nm_dev	"false"
		set bool_legacy_dev	"true"
		set bool_en_clk	"true"
		
		if {$set_ce == "true"} {
			set bool_set_ce	"true"
		} else {
			set bool_set_ce	"false"
		}
		
		if {$set_clr == "true"} {
			set bool_set_clr	"true"
		} else {
			set bool_set_clr	"false"
		}
	}
	
	# fix input
	my_add_interface_port	"in"	"corectl"		1 	$bool_20nm_dev
	my_add_interface_port	"in"	"reset"			1	$bool_20nm_dev
	my_add_interface_port	"clk"	"clk"			1	$bool_en_clk
	
	# fix output
	my_add_interface_port	"out"	"tempout"		10	$bool_20nm_dev
	my_add_interface_port	"out"	"eoc"			1	$bool_20nm_dev
	my_add_interface_port	"out"	"tsdcalo"		8	$bool_legacy_dev
	my_add_interface_port	"out"	"tsdcaldone"	1	$bool_legacy_dev
		
	# variable input
	my_add_interface_port	"in"	"ce"		1 	$bool_set_ce	
	my_add_interface_port	"reset"	"clr"		1	$bool_set_clr		


# +---------------------------------------
# | Set UI according to device
# +---------------------------------------
	if {$get_device_family == "Arria 10"} {
		set_parameter_property	CLK_FREQUENCY			ENABLED		false
		set_parameter_property	CLOCK_DIVIDER_VALUE		ENABLED		false
		set_parameter_property	CLOCK_DIVIDER_ENABLE	ENABLED		false
		set_parameter_property	CE_CHECK				ENABLED		false
		set_parameter_property	CLR_CHECK				ENABLED		false
		
		set_display_item_property	"note_text"	VISIBLE	true
		set_display_item_property	"info_note"	VISIBLE	true
		
	} else {
		set_parameter_property	CLK_FREQUENCY			ENABLED	true
		set_parameter_property	CLOCK_DIVIDER_VALUE		ENABLED	true
		set_parameter_property	CLOCK_DIVIDER_ENABLE	ENABLED	true
		set_parameter_property	CE_CHECK				ENABLED	true
		set_parameter_property	CLR_CHECK				ENABLED	true		

		set_display_item_property	"note_text"	VISIBLE	false
		set_display_item_property	"info_note"	VISIBLE	false
	}

# +----------------------------------------------
# | Check clock frequency/clock divider < 1MHz
# +----------------------------------------------
	set get_clk_frequency [get_parameter_value CLK_FREQUENCY]
	set get_clk_divider	[get_parameter_value CLOCK_DIVIDER_VALUE]
	
	if {$get_clk_frequency > $get_clk_divider} {
		send_message error "Clock frequency/clock divider value should be less than or equals to 1MHz"
	}
	
# +---------------------------------------
# | Enable clock divider option
# +---------------------------------------
	set input_freq [get_parameter_value CLK_FREQUENCY]	
	
	if {$input_freq > 1.0} {
		set_parameter_property CLOCK_DIVIDER_VALUE ENABLED true
		set_parameter_value CLOCK_DIVIDER_ENABLE "on"
	} else {
		set_parameter_property CLOCK_DIVIDER_VALUE ENABLED false
		set_parameter_value CLOCK_DIVIDER_ENABLE "off"
	}
}


#//////////////////////////////////////////////////////////////////////////
#
# Name:     my_add_interface_port
#
# Purpose:  Procedure for ports creation
#
#//////////////////////////////////////////////////////////////////////////
proc my_add_interface_port {port_type port_name port_width port_gen} {
	
	if {$port_gen eq "true"} {
		if {$port_type eq "in"} {
			add_interface $port_name conduit end
			add_interface_port $port_name $port_name $port_name Input $port_width
		} elseif {$port_type eq "out"} {
			add_interface $port_name conduit start
			set_interface_assignment $port_name "ui.blockdiagram.direction" OUTPUT
			add_interface_port $port_name $port_name $port_name Output $port_width
		} elseif {$port_type eq "clk"} {
			add_interface $port_name clock end
			add_interface_port $port_name $port_name clk Input $port_width
		} elseif {$port_type eq "reset"} {
			add_interface $port_name reset end
			add_interface_port $port_name $port_name reset Input $port_width
			set_interface_property $port_name associatedClock clk
		} else {
			send_message error "Illegal port type"
		}
	}
}


#//////////////////////////////////////////////////////////////////////////
#
# Name:     do_quartus_synth
#
# Purpose:  Procedure for Quartus synth
#
#//////////////////////////////////////////////////////////////////////////
proc do_quartus_synth {output_name} {

	send_message    info    "Generating top-level entity $output_name."
	
	# --- check ini for generating Arria 10 via cbx flow --- #
	set enable_a10_cbx	[get_quartus_ini cbx_allow_a10 ENABLED]
	set get_device_family [get_parameter_value DEVICE_FAMILY]

	if {($enable_a10_cbx == 0) && ($get_device_family eq "Arria 10")} {
		add_fileset_file altera_temp_sense.v VERILOG PATH "altera_temp_sense.v"
		add_fileset_file altera_temp_sense.sdc SDC PATH "altera_temp_sense.sdc"
		
	} else {
# +---------------------------------------
# | cbx flow
# +---------------------------------------
		# Create temp files for clearbox parameters and variation file output
		set cbx_param_file   [create_temp_file "parameter_list"]
		set cbx_var_file     [create_temp_file ${output_name}.v]

		#get all parameters and ports#
		set parameters_list   [parameters_transfer]
		if {$parameters_list eq ""} {
			send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
			return
		 }
		set ports_list     [ports_transfer]
		if {$ports_list eq ""}  {
			send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
		 }

		# Generate clearbox parameter file
		set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
		if {$status eq "false"} {
			send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
			return
		 }

		# Execute clearbox to produce a variation file
		set status      [do_clearbox_gen alttemp_sense $cbx_param_file $cbx_var_file]
		if {$status eq "false"} {
			send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
			return
		 }

		# Add the variation to the fileset
		add_fileset_file ${output_name}.v VERILOG PATH $cbx_var_file
	}
}


#//////////////////////////////////////////////////////////////////////////
#
# Name:     do_vhdl_sim
#
# Purpose:  Procedure for Quartus simulation
#
#//////////////////////////////////////////////////////////////////////////
proc do_vhdl_sim {output_name} {

	# --- check ini for generating Arria 10 via cbx flow --- #
	set enable_a10_cbx	[get_quartus_ini cbx_allow_a10 ENABLED]
	set get_device_family [get_parameter_value DEVICE_FAMILY]
	
    send_message    info    "Generating top-level entity $output_name."

	if {($enable_a10_cbx == 0) && ($get_device_family eq "Arria 10")} {
		# simulation is not supported for current devices
	} else {
# +---------------------------------------
# | cbx flow
# +---------------------------------------
		# Create temp files for clearbox parameters and variation file output
		set cbx_param_file   [create_temp_file "parameter_list"]
		set cbx_var_file     [create_temp_file ${output_name}.vhd]

		#get all parameters and ports#
		set parameters_list   [parameters_transfer]
		if {$parameters_list eq ""} {
			send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
			return
		 }
		set ports_list     [ports_transfer]
		if {$ports_list eq ""}  {
			send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
		 }

		# Generate clearbox parameter file
		set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
		if {$status eq "false"} {
			send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
			return
		 }

		# Execute clearbox to produce a variation file
		set status      [do_clearbox_gen alttemp_sense $cbx_param_file $cbx_var_file]
		if {$status eq "false"} {
			send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
			return
		 }

		 # Add the variation to the fileset
		add_fileset_file ${output_name}.vhd VHDL PATH $cbx_var_file
	}
}


#//////////////////////////////////////////////////////////////////////////
#
# Name:     parameters_transfer, ports_transfer
#
# Purpose:  Procedure for Parameters and ports transfer
#
#//////////////////////////////////////////////////////////////////////////
proc parameters_transfer {}   {

     #get all parameters#
     set param_list   [get_parameters]
     foreach param   $param_list    {
        set  param_arr($param)    [get_parameter_value  $param]
     }

     set parameters_list     [array get param_arr]
     return $parameters_list
}

proc ports_transfer {}   {

      set all_ports [get_interface_ports]
      return $all_ports
}
