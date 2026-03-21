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
# | $Header: //acds/rel/18.1std/ip/altera_asmi_parallel/altera_asmi_parallel_ui_settings.tcl#1 $
# | 
# +-----------------------------------


# +-----------------------------------
# | General procedures to check supported parameters
# +-----------------------------------
proc general_parameters_procedure {flag} 	{

	# --- list of supported operations --- #
	# list of QSPI - Quad/Dual data width, read_dummy_clk 
	set QSPI_list {"EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ256" "EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024" \
					"EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G" "N25Q512" "S25FL127S"}
	
	# devices that supported QSPI - Quad/Dual data width, asmi_dataout, asmi_sdoin, asmi_dataoe
	set supported_QSPI_devices_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V"}
	
	# devices that supported simulation
	set supported_sim_devices_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "MAX 10"}
	
	# QSPI that supported for 4-byte addressing - en4b_addr, ex4b_addr
	set supported_4byte_addr {"EPCQ256" "EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G" "N25Q512"}
	
	# QSPI that supported for fast read operation - fast_read
	set supported_fast_read {"EPCS16" "EPCS32" "EPCS64" "EPCS128" "EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ256" "EPCQ512" \
							"EPCQL256" "EPCQL512" "EPCQL1024" "EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G" "N25Q512" "S25FL127S"}
	
	# QSPI that supported for read device ID operation - read_rdid, read_didout
	set supported_read_rdid {"EPCS16" "EPCS32" "EPCS64" "EPCS128" "EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ256" "EPCQ512" \
							"EPCQL256" "EPCQL512" "EPCQL1024" "EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G" "N25Q512" "S25FL127S"}
	
	# QSPI that supported for read silicon ID operation - read_sid, epcs id
	set supported_read_sid 	{"EPCS1" "EPCS4" "EPCS16" "EPCS64"}
	
	# QSPI that supported for dual die - die_erase
	set supported_stack_die	{"EPCQL512" "EPCQL1024" "MT25QU01G" "N25Q512"}
	
	# Spansion device
	set spansion_list	{"S25FL127S"}
    
    # Windbond device
	set windbond_list	{"EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A"}

	# --- list of variables --- #
	set get_device_setting		[get_parameter_value DEVICE_FAMILY]
	set get_SPI_setting			[get_parameter_value EPCS_TYPE]
	set bulk_erase_setting 		[get_parameter_value gui_bulk_erase]
	set data_width_setting 		[get_parameter_value DATA_WIDTH]
	set die_erase_setting 		[get_parameter_value gui_die_erase]
	set ex4b_addr_setting 		[get_parameter_value gui_ex4b_addr]
	set fast_read_setting 		[get_parameter_value gui_fast_read]
	set page_size_setting 		[get_parameter_value PAGE_SIZE]
	set page_write_setting 		[get_parameter_value gui_page_write]
	set read_dummyclk_setting 	[get_parameter_value gui_read_dummyclk]
	set read_address_setting 	[get_parameter_value gui_read_address]
	set read_rdid_setting 		[get_parameter_value gui_read_rdid]
	set read_sid_setting 		[get_parameter_value gui_read_sid]
	set read_status_setting 	[get_parameter_value gui_read_status]
	set sector_erase_setting	[get_parameter_value gui_sector_erase]
	set sector_protect_setting 	[get_parameter_value gui_sector_protect]
	set single_write_setting 	[get_parameter_value gui_single_write]
	set use_asmiblock_setting 	[get_parameter_value gui_use_asmiblock]
	set use_eab_setting 		[get_parameter_value gui_use_eab]
	set wren_setting 			[get_parameter_value gui_wren]
	set write_setting 			[get_parameter_value gui_write]
	set sim_setting 			[get_parameter_value ENABLE_SIM]

	# --- checking for information --- #
	set is_qspi					"false"
	set is_qspi_devices_list	"false"
	set is_sim_devices_list		"false"
	set is_multi_flash_support	"false"
	set is_4byte_addr_support	"false"
	set is_fast_read_support	"false"
	set is_read_rdid_support	"false"
	set is_read_sid_support		"false"
	set is_stack_die			"false"
	set is_spansion				"false"
    	set is_windbond		    	"false"
    
	# check whether is QSPI devices
	foreach re_spi   $QSPI_list {
		if {$re_spi eq $get_SPI_setting} { 
			set is_qspi		"true"
			break;
		 }
	 }
	
	# check whether devices supporting QSPI
	if {[check_device_family_equivalence $get_device_setting $supported_QSPI_devices_list]} {
		set is_qspi_devices_list	"true"
	 }
	
	# check whether devices supporting simulation
	if {[check_device_family_equivalence $get_device_setting $supported_sim_devices_list]} {
		set is_sim_devices_list	"true"
	 }
	
	# check whether devices supporting multiple flash - only for Arria 10
	if {[check_device_family_equivalence $get_device_setting "Arria 10"]} {
		set is_multi_flash_support	"true"
	 }
	
	# check whether SPI device support 4-byte addressing
	foreach re_spi   $supported_4byte_addr {
		if {$re_spi eq $get_SPI_setting} {
			set is_4byte_addr_support	"true"
			break;
		 }
	 }
		
	# check whether SPI device support fast read
	foreach re_spi   $supported_fast_read {
		if {$re_spi eq $get_SPI_setting} {
			set is_fast_read_support	"true"
			break;
		 }
	 }

	# check whether SPI device support read device id
	foreach re_spi   $supported_read_rdid {
		if {$re_spi eq $get_SPI_setting} {
			set is_read_rdid_support	"true"
			break;
		 }
	 }	
		 
	# check whether SPI device support read silicon id
	foreach re_spi   $supported_read_sid {
		if {$re_spi eq $get_SPI_setting} {
			set is_read_sid_support		"true"
			break;
		 }
	 }
		 
	# check whether SPI is stacked die
	foreach re_spi   $supported_stack_die {
		if {$re_spi eq $get_SPI_setting} {
			set is_stack_die	"true"
			break;
		 }
	 }
	
	# check whether is Spansion devices
	foreach re_spi   $spansion_list {
		if {$re_spi eq $get_SPI_setting} {
			set is_spansion	"true"
			break;
		 }
	 }
	
    # check whether is Windbond devices
	foreach re_spi   $windbond_list {
		if {$re_spi eq $get_SPI_setting} {
			set is_windbond	"true"
			break;
		 }
	 }
     
	# +-----------------------------------
	# --- ELABORATION CALLBACK --- #
	# --- update parameters with regards to selected device --- #
	# --- update ports in block diagram with regards to parameter changes --- #
	# +-----------------------------------
	if {$flag eq "param_port_settings"} {
	
		# --- READ_SID --- #
		if {$is_read_sid_support eq "true"} {
			set_parameter_property	gui_read_sid	ENABLED		true
		 } else {
			set_parameter_property	gui_read_sid	ENABLED		false
		 }
		
		# --- READ_RDID --- #
		if {$is_read_rdid_support eq "true"} {
			set_parameter_property	gui_read_rdid	ENABLED		true
		 } else {
			set_parameter_property	gui_read_rdid	ENABLED		false
		 }
		
		# --- FAST_READ, DATA_WIDTH, READ_DUMMYCLK --- #
		if {$is_fast_read_support eq "true"} {
			set_parameter_property	gui_fast_read	ENABLED		true
			
			if {$is_qspi eq "true" && $is_spansion eq "false" && $is_windbond eq "false"} {
				set_parameter_property	gui_read_dummyclk	ENABLED		true
			 } else {
				set_parameter_property	gui_read_dummyclk	ENABLED		false
			 }
			
			if {$is_qspi_devices_list eq "true" && $is_qspi eq "true"} {
				set_parameter_property	DATA_WIDTH	ENABLED		true
			 } else {
				set_parameter_property	DATA_WIDTH	ENABLED		false
			 }
			 
		 } else {
			set_parameter_property	gui_fast_read		ENABLED		false
			set_parameter_property	DATA_WIDTH			ENABLED		false
			set_parameter_property	gui_read_dummyclk	ENABLED		false
		 }
		
		# --- EX4B_ADDR --- #
		if {$is_4byte_addr_support eq "true"} {
			set_parameter_property	gui_ex4b_addr		ENABLED		true
		 } else {
			set_parameter_property	gui_ex4b_addr		ENABLED		false
		 }
		
		# --- ENABLE_SIM --- #
		if {$is_sim_devices_list eq "true"} {
			set_parameter_property	ENABLE_SIM	ENABLED		true
		} else {
			set_parameter_property	ENABLE_SIM	ENABLED		false
		}
		
		# --- stack die specific operation  --- #
		if {$is_spansion eq "true"} {
			set_parameter_property	gui_die_erase	ENABLED		false
			set_parameter_property	gui_bulk_erase	ENABLED		false
		} elseif {$is_stack_die eq "true"} {
			set_parameter_property	gui_die_erase	ENABLED		true
			set_parameter_property	gui_bulk_erase	ENABLED		false
		 } else {
			set_parameter_property	gui_die_erase	ENABLED		false
			set_parameter_property	gui_bulk_erase	ENABLED		true
		 }
		
		# --- SECTOR_PROTECT  --- #
		if {$is_spansion eq "true"} {
			set_parameter_property	gui_sector_protect	ENABLED		false
		 } else {
			set_parameter_property	gui_sector_protect	ENABLED		true
		 }

		# --- check for port settings --- #
		if {$fast_read_setting eq "true" } {
			set_parameter_value 	PORT_FAST_READ 		"PORT_USED"
			set bool_check_read			"false"
			set bool_check_fast_read	"true" 
		 } else {
			set_parameter_value 	PORT_FAST_READ 		"PORT_UNUSED"
			set bool_check_read			"true"
			set bool_check_fast_read	"false"
		 }
		
		if {$is_4byte_addr_support eq "true"} {
			set_parameter_value PORT_EN4B_ADDR "PORT_USED"
			set addr_width	32
			set bool_check_en4b_addr	"true"
		 } else {
			set_parameter_value PORT_EN4B_ADDR "PORT_UNUSED"
			set addr_width	24
			set bool_check_en4b_addr	"false"
		 }
		
		if {$read_status_setting eq "true" } {
			set_parameter_value PORT_READ_STATUS "PORT_USED"
			set bool_check_read_status	"true" 
		 } else {
			set_parameter_value PORT_READ_STATUS "PORT_UNUSED"
			set bool_check_read_status	"false"
		 }
		
		if {$write_setting eq "true" } {
			set_parameter_value PORT_WRITE 			"PORT_USED"
			set_parameter_value PORT_ILLEGAL_WRITE 	"PORT_USED"
			set bool_check_write	"true" 
		 } else {
			set_parameter_value PORT_WRITE 			"PORT_UNUSED"
			set_parameter_value PORT_ILLEGAL_WRITE 	"PORT_UNUSED"
			set bool_check_write	"false"
		 }
		
		if {$write_setting eq "true" || $sector_protect_setting eq "true" } {
			set bool_check_datain			"true" 
		 } else {
			set bool_check_datain			"false"
		 }
		 
		if {$sector_protect_setting eq "true" } {
			set_parameter_value PORT_SECTOR_PROTECT "PORT_USED"
			set bool_check_sector_protect	"true" 
		 } else {
			set_parameter_value PORT_SECTOR_PROTECT "PORT_UNUSED"
			set bool_check_sector_protect	"false"
		 }
		
		if { $page_write_setting  eq "true" } {
			set_parameter_value PORT_SHIFT_BYTES 	"PORT_USED"
			set bool_check_shift_byte	"true"
		 } else {
			set_parameter_value PORT_SHIFT_BYTES 	"PORT_UNUSED"
			set bool_check_shift_byte	"false"
		 }
		
		if { $sector_erase_setting eq "true" } {
			set_parameter_value PORT_SECTOR_ERASE "PORT_USED"
			set bool_check_sector_erase	"true"
		 } else {
			set_parameter_value PORT_SECTOR_ERASE "PORT_UNUSED"
			set bool_check_sector_erase	"false"
		 }
		 
		if { $bulk_erase_setting eq "true" } {
			set_parameter_value PORT_BULK_ERASE "PORT_USED"
			set bool_check_bulk_erase	"true"
		 } else {
			set_parameter_value PORT_BULK_ERASE "PORT_UNUSED"
			set bool_check_bulk_erase	"false"
		 }
		 
		if { $die_erase_setting eq "true" }	{
			set_parameter_value PORT_DIE_ERASE "PORT_USED"
 			set bool_check_die_erase	"true"
		 } else {
			set_parameter_value PORT_DIE_ERASE "PORT_UNUSED"
			set bool_check_die_erase	"false"
		 }
		
		if {$bulk_erase_setting eq "true" || $die_erase_setting eq "true" || $sector_erase_setting eq "true" } {
			set_parameter_value PORT_ILLEGAL_ERASE "PORT_USED"
 			set bool_check_illegal_erase	"true" 
		 } else {
			set_parameter_value PORT_ILLEGAL_ERASE "PORT_UNUSED"
			set bool_check_illegal_erase	"false"
		 }
		
		if { $wren_setting eq "true" || $is_4byte_addr_support eq "true"} {
			set_parameter_value PORT_WREN "PORT_USED"
			set bool_check_wren	"true"
		 } else {
			set_parameter_value PORT_WREN "PORT_UNUSED"
			set bool_check_wren	"false"
		 }
		 
		if { $read_sid_setting eq "true" } {
			set_parameter_value PORT_READ_SID "PORT_USED"
			set bool_check_read_sid	"true"
		 } else {
			set_parameter_value PORT_READ_SID "PORT_UNUSED"
			set bool_check_read_sid	"false"
		 }
		
		if { $read_rdid_setting eq "true" } {
			set_parameter_value PORT_READ_RDID "PORT_USED"
			set_parameter_value PORT_RDID_OUT "PORT_USED"
			set bool_check_read_rdid	"true"
		 } else {
			set_parameter_value PORT_READ_RDID "PORT_UNUSED"
			set_parameter_value PORT_RDID_OUT "PORT_UNUSED"
			set bool_check_read_rdid	"false"
		 }
		
		if { $ex4b_addr_setting eq "true" } {
			set_parameter_value PORT_EX4B_ADDR "PORT_USED"
			set bool_check_ex4b_addr	"true"
		 } else {
			set_parameter_value PORT_EX4B_ADDR "PORT_UNUSED"
			set bool_check_ex4b_addr	"false"
		 }
		
		if { $read_dummyclk_setting eq "true" } {
			set_parameter_value PORT_READ_DUMMYCLK "PORT_USED"
			set bool_check_read_dummyclk	"true"
		 } else {
			set_parameter_value PORT_READ_DUMMYCLK "PORT_UNUSED"
			set bool_check_read_dummyclk	"false"
		 }
		 
		if { $use_asmiblock_setting eq "true" } {
			set_parameter_value USE_ASMIBLOCK 	"OFF"
			set bool_check_use_asmiblock	"true"
		 } else {
			set_parameter_value USE_ASMIBLOCK 	"ON"
			set bool_check_use_asmiblock	"false"
		 }
		
		if { $use_eab_setting eq "true" } {
			set_parameter_value USE_EAB 	"OFF"
		 } else {
			set_parameter_value USE_EAB 	"ON"
		 }
		
		if { $is_qspi_devices_list  eq "true" } {
			set width	4
		 } else {
			set width	1
		 }
		
		if { $is_multi_flash_support  eq "true" } {
			set sce_width	3
		 } else {
			set sce_width	1
		 }
		
		if { $read_address_setting eq "true" } {
			set_parameter_value PORT_READ_ADDRESS "PORT_USED"
			set bool_check_read_address	"true"
		 } else {
			set_parameter_value PORT_READ_ADDRESS "PORT_UNUSED"
			set bool_check_read_address	"false"
		 }
		
		# --- input ports --- #
		my_add_interface_port	"clk"	"clkin"				1			"true"
		my_add_interface_port	"in"	"read"				1			$bool_check_read
		my_add_interface_port	"in"	"fast_read"			1 			$bool_check_fast_read 
		my_add_interface_port	"in"	"rden"				1 			"true"
		my_add_interface_port	"in"	"addr"				$addr_width "true"
		my_add_interface_port	"in"	"read_sid"			1			$bool_check_read_sid
		my_add_interface_port	"in"	"read_status"		1 			$bool_check_read_status
		my_add_interface_port	"in"	"write"				1			$bool_check_write
		my_add_interface_port	"in"	"datain"			8			$bool_check_datain
		my_add_interface_port	"in"	"shift_bytes"		1			$bool_check_shift_byte
		my_add_interface_port	"in"	"sector_protect"	1			$bool_check_sector_protect
		my_add_interface_port	"in"	"sector_erase"		1			$bool_check_sector_erase
		my_add_interface_port	"in"	"bulk_erase"		1			$bool_check_bulk_erase
		my_add_interface_port	"in"	"die_erase"			1			$bool_check_die_erase
		my_add_interface_port	"in"	"wren"				1			$bool_check_wren
		my_add_interface_port	"in"	"read_rdid"			1			$bool_check_read_rdid
		my_add_interface_port	"in"	"en4b_addr"			1			$bool_check_en4b_addr
		my_add_interface_port	"in"	"ex4b_addr"			1			$bool_check_ex4b_addr
		my_add_interface_port	"reset"	"reset"				1			"true"
		my_add_interface_port	"in"	"read_dummyclk"		1			$bool_check_read_dummyclk
		my_add_interface_port	"in"	"asmi_dataout"		$width		$bool_check_use_asmiblock
		my_add_interface_port	"in"	"sce"				$sce_width	$is_multi_flash_support
		
		# --- output ports --- #
		my_add_interface_port	"out"	"dataout"		8			"true"
		my_add_interface_port	"out"	"busy"			1			"true"
		my_add_interface_port	"out"	"data_valid"	1			"true"
		my_add_interface_port	"out"	"epcs_id"		8			$bool_check_read_sid
		my_add_interface_port	"out"	"status_out"	8 			$bool_check_read_status
		my_add_interface_port	"out"	"illegal_write"	1 			$bool_check_write
		my_add_interface_port	"out"	"illegal_erase"	1 			$bool_check_illegal_erase
		my_add_interface_port	"out"	"read_address"	$addr_width $read_address_setting
		my_add_interface_port	"out"	"rdid_out"		8			$bool_check_read_rdid
		my_add_interface_port	"out"	"asmi_dclk"		1 			$bool_check_use_asmiblock
		my_add_interface_port	"out"	"asmi_scein"	$sce_width	$bool_check_use_asmiblock
		my_add_interface_port	"out"	"asmi_sdoin"	$width 		$bool_check_use_asmiblock
		my_add_interface_port	"out"	"asmi_dataoe"	$width 		$bool_check_use_asmiblock
	 }
	
	# +-----------------------------------
	# --- VALIDATION CALLBACK --- #
	# +-----------------------------------
	if {$flag eq "validate_settings"} {
		
		# --- READ_SID --- #
		if {$is_read_sid_support eq "false" && $read_sid_setting eq "true"} {
			send_message error "$get_SPI_setting does not support 'read_sid' operation"
		 } 
		
		# --- READ_RDID --- #
		if {$is_read_rdid_support eq "false" && $read_rdid_setting eq "true"} {
			send_message error "$get_SPI_setting does not support 'read_rdid' operation"
		 } 
		
		# --- FAST_READ, DATA_WIDTH, READ_DUMMYCLK --- #
		if {$is_fast_read_support eq "false" && $fast_read_setting eq "true"} {
			send_message error "$get_SPI_setting does not support 'fast_read' operation"
		 } 
		
		if {$is_spansion eq "true" && $data_width_setting eq "DUAL"} {
			send_message error "$get_SPI_setting only supported for STANDARD and QUAD data width"
		 } elseif {$is_qspi eq "false" && $data_width_setting ne "STANDARD"} {
			send_message error "$get_SPI_setting only supported for STANDARD data width"
		 } elseif {$is_qspi_devices_list eq "false" && $data_width_setting ne "STANDARD"} {
			send_message error "$get_device_setting only supported for STANDARD data width"
		 } elseif {$fast_read_setting eq "false" && $data_width_setting ne "STANDARD"} {
			send_message error "Turn on 'fast_read' port to enable $data_width_setting data width"
		 }
		
		if {$is_qspi eq "false" && $read_dummyclk_setting eq "true"} {
			send_message error "$get_SPI_setting does not support read device dummy clock operation"
		 } elseif {$is_spansion eq "true" && $read_dummyclk_setting eq "true"} {
			send_message error "$get_SPI_setting does not support read device dummy clock operation"
		 } elseif {$fast_read_setting eq "false" && $read_dummyclk_setting eq "true"} {
			send_message error "Turn on 'fast_read' port to enable read device dummy clock operation"
		 }
		
		# --- WRITE, WREN, SHIFT_BYTES, EAB --- #
		if {$wren_setting eq "true" || $single_write_setting eq "true" || $page_write_setting eq "true"} {
			if {$write_setting eq "false"} {
				send_message error "Turn on 'write' port to enable write operation"
			 }
		 }
		
		# --- stack die specific operation  --- #
		if {$is_stack_die eq "false" && $die_erase_setting eq "true"} {
			send_message error "$get_SPI_setting does not support 'die_erase' operation"
		 } elseif {$is_stack_die eq "true" && $bulk_erase_setting eq "true"} {
			send_message error "$get_SPI_setting does not support 'bulk_erase' operation"
		 }		
		 
		# --- EX4B_ADDR --- #
		if {$is_4byte_addr_support eq "false" && $ex4b_addr_setting eq "true"} {
			send_message error "$get_SPI_setting does not support 'ex4b_addr' operation"
		 } 
		 
		# --- ENABLE_SIM --- #
		if {$is_sim_devices_list eq "false" && $sim_setting eq "true"} {
			send_message error "$get_device_setting does not support enable_sim parameter"
		 } 
		
		# --- SECTOR_PROTECT --- #
		if {$is_spansion eq "true" && $sector_protect_setting eq "true"} {
			send_message error "$get_device_setting does not support 'sector_protect' operation"
		 } 
		
		# --- BULK_ERASE --- #
		if {$is_spansion eq "true" && $bulk_erase_setting eq "true"} {
			send_message error "$get_device_setting does not support 'bulk_erase' operation"
		 } 
	 }
}


# +-----------------------------------
# | Procedure for ports creation
# +-----------------------------------
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
			set_interface_property $port_name associatedClock clkin
		} else {
			send_message error "Illegal port type"
		}
	}
}


# +-----------------------------------
# | Callback procedure for parameters
# +-----------------------------------
proc update_page_size {arg} 	{
	
	set single_write_setting [get_parameter_value gui_single_write]
	set page_write_setting [get_parameter_value gui_page_write]
	
	if { $single_write_setting eq "true" } {
		set_parameter_property	gui_page_write	ENABLED	false
		set_parameter_property	gui_use_eab		ENABLED	false
     } else {
        set_parameter_property	gui_page_write	ENABLED	true
		set_parameter_property	gui_use_eab		ENABLED	true
     }
	
	if { $page_write_setting eq "true" } {
		set_parameter_property	gui_single_write	ENABLED	false
		set_parameter_property	PAGE_SIZE			ENABLED	true
     } else {
        set_parameter_property	gui_single_write	ENABLED	true
		set_parameter_property	PAGE_SIZE			ENABLED	false
		
		set_parameter_value PAGE_SIZE 			1
     }
}
