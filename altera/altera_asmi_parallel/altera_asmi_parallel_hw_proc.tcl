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
# | $Header: //acds/rel/18.1std/ip/altera_asmi_parallel/altera_asmi_parallel_hw_proc.tcl#1 $
# | 
# +-----------------------------------


# +-----------------------------------
# | Set UI Interface during elaboration callback
# +-----------------------------------
proc elaboration {} 	{

	# --- check ini for hidden devices --- #
	set enable_N25Q512		    [get_quartus_ini pgm_allow_n25q512 ENABLED]
	set enable_MT25Q            [get_quartus_ini pgm_allow_mt25q ENABLED]
    set enable_EPCS32		    [get_quartus_ini pgm_allow_epcs32 ENABLED]
	set enable_S25FL127S	    [get_quartus_ini pgm_allow_qspi128 ENABLED]
	set get_spi_list		    [get_parameter_property	EPCS_TYPE	ALLOWED_RANGES]
	set get_width_allow_range   [get_parameter_property	DATA_WIDTH	ALLOWED_RANGES]
	set get_SPI_setting			[get_parameter_value EPCS_TYPE]
    # to remove quad from the list
    if {$get_SPI_setting == "EPCQ4A"} {
        set_parameter_property 	DATA_WIDTH	ALLOWED_RANGES		{"STANDARD" "DUAL"}
    }
    
	if {$enable_MT25Q == 1} {
		lappend get_spi_list	"MT25QL256"
        lappend get_spi_list	"MT25QL512"
        lappend get_spi_list	"MT25QU256"
        lappend get_spi_list	"MT25QU512"
        lappend get_spi_list	"MT25QU01G"
	 }
   
	if {$enable_N25Q512 == 1} {
		lappend get_spi_list	"N25Q512"
	 }
	 
    if {$enable_EPCS32 == 1} {
		lappend get_spi_list	"EPCS32"
	 }
	
	if {$enable_S25FL127S == 1} {
		lappend get_spi_list	"S25FL127S"
	 }
	
	set_parameter_property 	EPCS_TYPE	ALLOWED_RANGES		$get_spi_list	
	# --- update parameters and ports with regards to selected FPGA/flash device --- #
	general_parameters_procedure param_port_settings	
	
}


# +-----------------------------------
# | Validate user selection during validation callback
# +-----------------------------------
proc validation {} 	{

	# --- update parameters and ports with regards to selected FPGA/flash device --- #
	general_parameters_procedure validate_settings
	
}

	
# +-----------------------------------
# | Quartus synth
# +-----------------------------------
proc generate_synth {output_name}	{

	send_message info "generating top-level entity $output_name"
	
	# Create temp files for clearbox parameters and variation file output
    set cbx_param_file	[create_temp_file "parameter_list"]
    set cbx_var_file	[create_temp_file ${output_name}.v]

    #get all parameters and ports
    set parameters_list	[parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
     }
    set ports_list	[ports_transfer]
    if {$ports_list eq ""} {
        send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
     }

    # Generate clearbox parameter file
    set status	[generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
     }

    # Execute clearbox to produce a variation file
    set status	[do_clearbox_gen "altasmi_parallel" $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
     }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.v VERILOG PATH $cbx_var_file
}


# +-----------------------------------
# | Quartus simulation
# +-----------------------------------
proc generate_vhdl_sim {output_name}	{

	# Create temp files for clearbox parameters and variation file output
    set cbx_param_file	[create_temp_file "parameter_list"]
    set cbx_var_file	[create_temp_file ${output_name}.vhd]

    #get all parameters and ports#
    set parameters_list	[parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
     }
    set ports_list	[ports_transfer]
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
    set status	[do_clearbox_gen "altasmi_parallel" $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
     }

     # Add the variation to the fileset
    add_fileset_file ${output_name}.vhd VHDL PATH $cbx_var_file
}


# +-----------------------------------
# | Parameters and ports transfer procedure
# +-----------------------------------
proc parameters_transfer {}   {

    #get all parameters
    set param_list	[get_parameters]
    foreach param   $param_list {
        set  param_arr($param)	[get_parameter_value  $param]
     }
	
	#remove parameters that are for ui setting only
	set gui_param {gui_read_sid gui_read_rdid gui_read_status gui_read_address gui_fast_read gui_read_dummyclk gui_write \
					gui_wren gui_single_write gui_page_write gui_use_eab gui_bulk_erase gui_die_erase gui_sector_erase \
					gui_sector_protect gui_ex4b_addr gui_use_asmiblock}
							
	foreach  delete_item    $gui_param {
         unset  param_arr($delete_item)
     }

    set parameters_list	[array get param_arr]
    return $parameters_list
}

proc ports_transfer {}	{

      set all_ports	[get_interface_ports]
      return $all_ports
}


