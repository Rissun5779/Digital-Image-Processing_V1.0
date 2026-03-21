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
# | $Header: //acds/rel/18.1std/ip/altera_asmi_parallel/altera_asmi_parallel_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1

# Source files
source altera_asmi_parallel_hw_proc.tcl
source altera_asmi_parallel_ui_settings.tcl
source clearbox.tcl


# +-----------------------------------
# | module ALTASMI_PARALLEL
# +-----------------------------------
set_module_property NAME 							altera_asmi_parallel
set_module_property AUTHOR 							"Altera Corporation"
set_module_property DATASHEET_URL 					"http://www.altera.com/literature/ug/ug_altasmi_parallel.pdf"
set_module_property DESCRIPTION 					"The Altera ASMI Parallel megafunction provides access to erasable \
														programmable configurable serial (EPCS) and quad-serial configuration \
														(EPCQ) devices through parallel data input and output ports."
set_module_property DISPLAY_NAME 					"ASMI Parallel Intel FPGA IP"
set_module_property EDITABLE 						false
set_module_property VERSION 						18.1
set_module_property GROUP 							"Basic Functions/Configuration and Programming"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE	true
set_module_property INTERNAL 						false

set_module_property     ELABORATION_CALLBACK	elaboration
set_module_property     VALIDATION_CALLBACK		validation

add_display_item "" "General" GROUP tab
add_display_item "" "Simulation" GROUP tab

# +-----------------------------------
# | device family info
# +-----------------------------------
set all_supported_device_families_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "Stratix IV" \
											"Cyclone IV GX" "Cyclone IV E" "Cyclone III GL" "Arria II GZ" "Arria II GX" "Cyclone 10 LP"}
									
proc check_device_ini {device_families_list}     {

    set enable_max10    [get_quartus_ini enable_max10_active_serial ENABLED]
    
    if {$enable_max10 == 1} {
        lappend device_families_list    "MAX 10"
     } 
    return $device_families_list
}

set device_list    [check_device_ini $all_supported_device_families_list]
set_module_property SUPPORTED_DEVICE_FAMILIES    $device_list

add_parameter 			DEVICE_FAMILY 	STRING
set_parameter_property 	DEVICE_FAMILY 	SYSTEM_INFO 	{DEVICE_FAMILY}
set_parameter_property 	DEVICE_FAMILY 	VISIBLE 		false

add_parameter 			INTENDED_DEVICE_FAMILY 	STRING
set_parameter_property 	INTENDED_DEVICE_FAMILY 	SYSTEM_INFO 	{DEVICE_FAMILY}
set_parameter_property 	INTENDED_DEVICE_FAMILY 	VISIBLE 		false


# +-----------------------------------
# | clearbox auto blackbox flag
# +-----------------------------------
add_parameter           CBX_AUTO_BLACKBOX   STRING              "ALL"
set_parameter_property  CBX_AUTO_BLACKBOX   DESCRIPTION         "Flag clearbox to blackbox other clearbox components or \
																	include them in the output variation file."
set_parameter_property  CBX_AUTO_BLACKBOX   AFFECTS_GENERATION  true
set_parameter_property  CBX_AUTO_BLACKBOX   VISIBLE             false


# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------
# check elaboration procedure for hidden devices
set all_supported_SPI_list {"EPCS1" "EPCS4" "EPCS16" "EPCS64" "EPCS128" "EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ256" \
							"EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024" "EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A"}

# --- Parameters for HDL parameters generation --- #
# SPI device selection
add_parameter           EPCS_TYPE	STRING				"EPCS4"
set_parameter_property	EPCS_TYPE	DISPLAY_NAME		"Configuration device type"
set_parameter_property 	EPCS_TYPE	ALLOWED_RANGES		$all_supported_SPI_list
set_parameter_property  EPCS_TYPE   DESCRIPTION        	"Select targeted EPCS/EPCQ devices"
set_parameter_property  EPCS_TYPE	AFFECTS_GENERATION	true
add_display_item		"General"	EPCS_TYPE			parameter

add_display_item 		"General" 	"Read Operation" 	GROUP

# Enable Read Silicon ID operation
add_parameter 			gui_read_sid		BOOLEAN 			0
set_parameter_property	gui_read_sid		DISPLAY_NAME		"Use 'read_sid' port"
set_parameter_property  gui_read_sid   		DESCRIPTION        	"Check to enable Read Silicon ID operation"
set_parameter_property  gui_read_sid		AFFECTS_GENERATION	true
add_display_item		"Read Operation"	gui_read_sid		parameter

# Enable Read Device ID operation
add_parameter 			gui_read_rdid		BOOLEAN 			0
set_parameter_property	gui_read_rdid		DISPLAY_NAME		"Use 'read_rdid' and rdid_out' ports"
set_parameter_property  gui_read_rdid   	DESCRIPTION        	"Check to enable Read Device Identification operation"
set_parameter_property  gui_read_rdid		AFFECTS_GENERATION	true
add_display_item		"Read Operation"	gui_read_rdid		parameter

# Enable Read Status operation
add_parameter 			gui_read_status		BOOLEAN 			0
set_parameter_property	gui_read_status		DISPLAY_NAME		"Use 'read_status' port"
set_parameter_property  gui_read_status   	DESCRIPTION        	"Check to enable Read Status operation"
set_parameter_property  gui_read_status		AFFECTS_GENERATION	true
add_display_item		"Read Operation"	gui_read_status		parameter

# Enable Read Address operation
add_parameter           gui_read_address	BOOLEAN 			0
set_parameter_property	gui_read_address	DISPLAY_NAME		"Use 'read_address' port"
set_parameter_property  gui_read_address   	DESCRIPTION        	"Check to read the address of output data"
set_parameter_property  gui_read_address	AFFECTS_GENERATION	true
add_display_item		"Read Operation"	gui_read_address	parameter

# Enable Fast Read operation
add_parameter           gui_fast_read		BOOLEAN 			0
set_parameter_property	gui_fast_read		DISPLAY_NAME		"Use 'fast_read' port"
set_parameter_property  gui_fast_read   	DESCRIPTION        	"Check to enable Fast Read operation"
set_parameter_property  gui_fast_read		AFFECTS_GENERATION	true
add_display_item		"Read Operation"	gui_fast_read		parameter

# Data width
add_parameter           DATA_WIDTH			STRING				"STANDARD"
set_parameter_property	DATA_WIDTH			DISPLAY_NAME		"Choose I/O mode"
set_parameter_property 	DATA_WIDTH			ALLOWED_RANGES		{"STANDARD" "DUAL" "QUAD"}
set_parameter_property  DATA_WIDTH			DESCRIPTION         "Select extended data width when Fast Read operation is enabled"
set_parameter_property  DATA_WIDTH			AFFECTS_GENERATION	true
add_display_item		"Read Operation"	DATA_WIDTH			parameter

# Enable Read Device Dummy Clock operation
add_parameter           gui_read_dummyclk	BOOLEAN 			0
set_parameter_property	gui_read_dummyclk	DISPLAY_NAME		"Read device dummy clock"
set_parameter_property  gui_read_dummyclk   DESCRIPTION        	"Check to allow dummy clock value retrieve from NVCR/VCR for Fast Read operation"
set_parameter_property  gui_read_dummyclk	AFFECTS_GENERATION	true
add_display_item		"Read Operation"	gui_read_dummyclk	parameter

add_display_item 		"General" 	"Write Operation" 	GROUP

# Enable Write operation 
add_parameter 			gui_write			BOOLEAN 			0
set_parameter_property	gui_write			DISPLAY_NAME		"Enable write operation"
set_parameter_property  gui_write   		DESCRIPTION        	"Check to enable Write Bytes operation"
set_parameter_property  gui_write			AFFECTS_GENERATION	true
add_display_item		"Write Operation"	gui_write			parameter

# Enable Write Enable operation
add_parameter           gui_wren			BOOLEAN 			0
set_parameter_property	gui_wren			DISPLAY_NAME		"Use 'wren' port"
set_parameter_property  gui_wren   			DESCRIPTION        	"Check to enable Write Enable operation"
set_parameter_property  gui_wren			AFFECTS_GENERATION	true
add_display_item		"Write Operation"	gui_wren			parameter

# Single byte write
add_parameter           gui_single_write	BOOLEAN 			0
set_parameter_property	gui_single_write	DISPLAY_NAME		"Single byte write"
set_parameter_property  gui_single_write   	DESCRIPTION        	"Check for single byte write operation"
set_parameter_property  gui_single_write	AFFECTS_GENERATION	true
add_display_item		"Write Operation"	gui_single_write	parameter
set_parameter_update_callback	gui_single_write	update_page_size

# Page write
add_parameter           gui_page_write		BOOLEAN 			0
set_parameter_property	gui_page_write		DISPLAY_NAME		"Page write"
set_parameter_property  gui_page_write   	DESCRIPTION        	"Check for page write operation"
set_parameter_property  gui_page_write		AFFECTS_GENERATION	true
add_display_item		"Write Operation"	gui_page_write		parameter
set_parameter_update_callback	gui_page_write	update_page_size

# Page size
add_parameter           PAGE_SIZE			INTEGER				1
set_parameter_property	PAGE_SIZE			DISPLAY_NAME		"'page write' size"
set_parameter_property 	PAGE_SIZE			ALLOWED_RANGES		{1:256}
set_parameter_property  PAGE_SIZE   		DESCRIPTION         "Select the size of page when WRITE operation is enabled"
set_parameter_property  PAGE_SIZE			AFFECTS_GENERATION	true
add_display_item		"Write Operation"	PAGE_SIZE			parameter
set_parameter_update_callback	PAGE_SIZE	update_page_size

# Use EAB
add_parameter           gui_use_eab			BOOLEAN 			0
set_parameter_property	gui_use_eab			DISPLAY_NAME		"Store 'page write' data in logic elements"
set_parameter_property  gui_use_eab   		DESCRIPTION     	""
set_parameter_property  gui_use_eab			AFFECTS_GENERATION	true
add_display_item		"Write Operation"	gui_use_eab			parameter

add_display_item 		"General" 	"Erase Operation" 	GROUP

# Enable Bulk Erase operation
add_parameter           gui_bulk_erase		BOOLEAN 			0
set_parameter_property	gui_bulk_erase		DISPLAY_NAME		"Use 'bulk_erase' port"
set_parameter_property  gui_bulk_erase   	DESCRIPTION     	"Check to enable Erase Bulk operation"
set_parameter_property  gui_bulk_erase		AFFECTS_GENERATION	true
add_display_item		"Erase Operation"	gui_bulk_erase		parameter

# Enable Die Erase operation
add_parameter           gui_die_erase		BOOLEAN 			0
set_parameter_property	gui_die_erase		DISPLAY_NAME		"Use 'die_erase' port"
set_parameter_property  gui_die_erase   	DESCRIPTION     	"Check to enable Erase Die operation"
set_parameter_property  gui_die_erase		AFFECTS_GENERATION	true
add_display_item		"Erase Operation"	gui_die_erase		parameter

# Enable Sector Erase operation
add_parameter           gui_sector_erase	BOOLEAN 			0
set_parameter_property	gui_sector_erase	DISPLAY_NAME		"Use 'sector_erase' port"
set_parameter_property  gui_sector_erase   	DESCRIPTION     	"Check to enable Erase Sector operation"
set_parameter_property  gui_sector_erase	AFFECTS_GENERATION	true
add_display_item		"Erase Operation"	gui_sector_erase		parameter

add_display_item 		"General" 	"Miscellaneous Operation" 	GROUP

# Enable Sector Protect operation
add_parameter           gui_sector_protect			BOOLEAN 			0
set_parameter_property	gui_sector_protect			DISPLAY_NAME		"Use 'sector_protect' port"
set_parameter_property  gui_sector_protect   		DESCRIPTION     	"Check to allow operation to set protection sector of SPI device"
set_parameter_property  gui_sector_protect			AFFECTS_GENERATION	true
add_display_item		"Miscellaneous Operation"	gui_sector_protect	parameter

# Enable Exit 4-byte Addressing operation
add_parameter           gui_ex4b_addr				BOOLEAN 			0
set_parameter_property	gui_ex4b_addr				DISPLAY_NAME		"Use 'ex4b_addr' port"
set_parameter_property  gui_ex4b_addr   			DESCRIPTION     	"Check to enable 4BYTEADDREX operation"
set_parameter_property  gui_ex4b_addr				AFFECTS_GENERATION	true
add_display_item		"Miscellaneous Operation"	gui_ex4b_addr		parameter

# use asmiblock 
add_parameter           gui_use_asmiblock				BOOLEAN 			0
set_parameter_property	gui_use_asmiblock				DISPLAY_NAME		"Disable dedicated Active Serial interface"
set_parameter_property 	gui_use_asmiblock 				DESCRIPTION 		"Check to route ASMIBLOCK signals to top level of design"
set_parameter_property  gui_use_asmiblock				AFFECTS_GENERATION	true
add_display_item		"Miscellaneous Operation"	gui_use_asmiblock		parameter

# --- Hidden HDL Port/Parameter List --- #
# Port for bulk erase
add_parameter           PORT_BULK_ERASE	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_BULK_ERASE	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_BULK_ERASE	AFFECTS_ELABORATION	false
set_parameter_property  PORT_BULK_ERASE	AFFECTS_GENERATION	true
set_parameter_property 	PORT_BULK_ERASE VISIBLE 			false
set_parameter_property 	PORT_BULK_ERASE DERIVED 			true

# Port for die erase
add_parameter           PORT_DIE_ERASE	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_DIE_ERASE	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_DIE_ERASE	AFFECTS_ELABORATION	false
set_parameter_property  PORT_DIE_ERASE	AFFECTS_GENERATION	true
set_parameter_property 	PORT_DIE_ERASE 	VISIBLE 			false
set_parameter_property 	PORT_DIE_ERASE	DERIVED 			true

# Port for enable 4-byte addressing
add_parameter           PORT_EN4B_ADDR	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_EN4B_ADDR	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_EN4B_ADDR	AFFECTS_ELABORATION	false
set_parameter_property  PORT_EN4B_ADDR	AFFECTS_GENERATION	true
set_parameter_property 	PORT_EN4B_ADDR 	VISIBLE 			false
set_parameter_property 	PORT_EN4B_ADDR	DERIVED 			true

# Port for exit 4-byte addressing
add_parameter           PORT_EX4B_ADDR	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_EX4B_ADDR	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_EX4B_ADDR	AFFECTS_ELABORATION	false
set_parameter_property  PORT_EX4B_ADDR	AFFECTS_GENERATION	true
set_parameter_property 	PORT_EX4B_ADDR 	VISIBLE 			false
set_parameter_property 	PORT_EX4B_ADDR	DERIVED 			true

# Port for fast read
add_parameter           PORT_FAST_READ	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_FAST_READ	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_FAST_READ	AFFECTS_ELABORATION	false
set_parameter_property  PORT_FAST_READ	AFFECTS_GENERATION	true
set_parameter_property 	PORT_FAST_READ 	VISIBLE 			false
set_parameter_property 	PORT_FAST_READ	DERIVED 			true

# Port for illegal erase
add_parameter           PORT_ILLEGAL_ERASE	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_ILLEGAL_ERASE	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_ILLEGAL_ERASE	AFFECTS_ELABORATION	false
set_parameter_property  PORT_ILLEGAL_ERASE	AFFECTS_GENERATION	true
set_parameter_property 	PORT_ILLEGAL_ERASE 	VISIBLE 			false
set_parameter_property 	PORT_ILLEGAL_ERASE	DERIVED 			true

# Port for illegal write
add_parameter           PORT_ILLEGAL_WRITE	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_ILLEGAL_WRITE	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_ILLEGAL_WRITE	AFFECTS_ELABORATION	false
set_parameter_property  PORT_ILLEGAL_WRITE	AFFECTS_GENERATION	true
set_parameter_property 	PORT_ILLEGAL_WRITE 	VISIBLE 			false
set_parameter_property 	PORT_ILLEGAL_WRITE	DERIVED 			true

# Port for read Device ID output
add_parameter           PORT_RDID_OUT	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_RDID_OUT	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_RDID_OUT	AFFECTS_ELABORATION	false
set_parameter_property  PORT_RDID_OUT	AFFECTS_GENERATION	true
set_parameter_property 	PORT_RDID_OUT 	VISIBLE 			false
set_parameter_property 	PORT_RDID_OUT	DERIVED 			true

# Port for read address
add_parameter           PORT_READ_ADDRESS	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_READ_ADDRESS	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_READ_ADDRESS	AFFECTS_ELABORATION	false
set_parameter_property  PORT_READ_ADDRESS	AFFECTS_GENERATION	true
set_parameter_property 	PORT_READ_ADDRESS 	VISIBLE 			false
set_parameter_property 	PORT_READ_ADDRESS	DERIVED 			true

# Port for read device dummy clock
add_parameter           PORT_READ_DUMMYCLK	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_READ_DUMMYCLK	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_READ_DUMMYCLK	AFFECTS_ELABORATION	false
set_parameter_property  PORT_READ_DUMMYCLK	AFFECTS_GENERATION	true
set_parameter_property 	PORT_READ_DUMMYCLK 	VISIBLE 			false
set_parameter_property 	PORT_READ_DUMMYCLK	DERIVED 			true

# Port for read Device ID
add_parameter           PORT_READ_RDID	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_READ_RDID	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_READ_RDID	AFFECTS_ELABORATION	false
set_parameter_property  PORT_READ_RDID	AFFECTS_GENERATION	true
set_parameter_property 	PORT_READ_RDID 	VISIBLE 			false
set_parameter_property 	PORT_READ_RDID	DERIVED 			true

# Port for reading Silicon ID
add_parameter           PORT_READ_SID	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_READ_SID	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_READ_SID	AFFECTS_ELABORATION	false
set_parameter_property  PORT_READ_SID	AFFECTS_GENERATION	true
set_parameter_property 	PORT_READ_SID 	VISIBLE 			false
set_parameter_property 	PORT_READ_SID	DERIVED 			true

# Port for reading status
add_parameter           PORT_READ_STATUS	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_READ_STATUS	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_READ_STATUS	AFFECTS_ELABORATION	false
set_parameter_property  PORT_READ_STATUS	AFFECTS_GENERATION	true
set_parameter_property 	PORT_READ_STATUS 	VISIBLE 			false
set_parameter_property 	PORT_READ_STATUS	DERIVED 			true

# Port for sector erase
add_parameter           PORT_SECTOR_ERASE	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_SECTOR_ERASE	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_SECTOR_ERASE	AFFECTS_ELABORATION	false
set_parameter_property  PORT_SECTOR_ERASE	AFFECTS_GENERATION	true
set_parameter_property 	PORT_SECTOR_ERASE 	VISIBLE 			false
set_parameter_property 	PORT_SECTOR_ERASE	DERIVED 			true

# Port for sector protect
add_parameter           PORT_SECTOR_PROTECT	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_SECTOR_PROTECT	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_SECTOR_PROTECT	AFFECTS_ELABORATION	false
set_parameter_property  PORT_SECTOR_PROTECT	AFFECTS_GENERATION	true
set_parameter_property 	PORT_SECTOR_PROTECT VISIBLE 			false
set_parameter_property 	PORT_SECTOR_PROTECT	DERIVED 			true

# Port for shift bytes
add_parameter           PORT_SHIFT_BYTES	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_SHIFT_BYTES	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_SHIFT_BYTES	AFFECTS_ELABORATION	false
set_parameter_property  PORT_SHIFT_BYTES	AFFECTS_GENERATION	true
set_parameter_property 	PORT_SHIFT_BYTES 	VISIBLE 			false
set_parameter_property 	PORT_SHIFT_BYTES	DERIVED 			true

# Port for write enable
add_parameter           PORT_WREN	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_WREN	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_WREN	AFFECTS_ELABORATION	false
set_parameter_property  PORT_WREN	AFFECTS_GENERATION	true
set_parameter_property 	PORT_WREN 	VISIBLE 			false
set_parameter_property 	PORT_WREN	DERIVED 			true

# Port for write 
add_parameter           PORT_WRITE	STRING				"PORT_UNUSED"
set_parameter_property 	PORT_WRITE	ALLOWED_RANGES		{"PORT_UNUSED" "PORT_USED"}
set_parameter_property  PORT_WRITE	AFFECTS_ELABORATION	false
set_parameter_property  PORT_WRITE	AFFECTS_GENERATION	true
set_parameter_property 	PORT_WRITE	VISIBLE 			false
set_parameter_property 	PORT_WRITE	DERIVED 			true

# write dummy clock value
add_parameter           WRITE_DUMMY_CLK	INTEGER				0
set_parameter_property 	WRITE_DUMMY_CLK	ALLOWED_RANGES		{0:15}
set_parameter_property  WRITE_DUMMY_CLK	AFFECTS_ELABORATION	false
set_parameter_property  WRITE_DUMMY_CLK	AFFECTS_GENERATION	true
set_parameter_property 	WRITE_DUMMY_CLK VISIBLE 			false

# use EAB 
add_parameter           USE_EAB		STRING				"ON"
set_parameter_property 	USE_EAB		ALLOWED_RANGES		{"ON" "OFF"}
set_parameter_property  USE_EAB		AFFECTS_ELABORATION	false
set_parameter_property  USE_EAB		AFFECTS_GENERATION	true
set_parameter_property 	USE_EAB		VISIBLE 			false
set_parameter_property 	USE_EAB		DERIVED 			true

# use asmiblock 
add_parameter           USE_ASMIBLOCK	STRING				"ON"
set_parameter_property 	USE_ASMIBLOCK	ALLOWED_RANGES		{"ON" "OFF"}
set_parameter_property  USE_ASMIBLOCK	AFFECTS_ELABORATION	false
set_parameter_property  USE_ASMIBLOCK	AFFECTS_GENERATION	true
set_parameter_property 	USE_ASMIBLOCK	VISIBLE 			false
set_parameter_property 	USE_ASMIBLOCK	DERIVED 			true

# flash has reset pin 
add_parameter           FLASH_RSTPIN	STRING				"FALSE"
set_parameter_property 	FLASH_RSTPIN	ALLOWED_RANGES		{"TRUE" "FALSE"}
set_parameter_property  FLASH_RSTPIN	AFFECTS_GENERATION	true
set_parameter_property 	FLASH_RSTPIN	VISIBLE 			false

# +-----------------------------------
# | Parameters - Simulation tab
# +-----------------------------------
# enable_sim
add_parameter           ENABLE_SIM	BOOLEAN 			0
set_parameter_property	ENABLE_SIM	DISPLAY_NAME		"Enable simulation"
set_parameter_property 	ENABLE_SIM 	DESCRIPTION 		"Check to enable simulation for Active Serial pins"
set_parameter_property  ENABLE_SIM	AFFECTS_GENERATION	true
add_display_item		"Simulation"	ENABLE_SIM		parameter

# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_vhdl SIM_VHDL generate_vhdl_sim
add_fileset sim_verilog SIM_VERILOG generate_synth

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sam1412044647169/sam1412044455033
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
