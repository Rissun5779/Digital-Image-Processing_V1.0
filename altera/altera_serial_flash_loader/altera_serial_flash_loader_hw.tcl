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
# | $Header: //acds/rel/18.1std/ip/altera_serial_flash_loader/altera_serial_flash_loader_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1
package require -exact altera_terp 1.0

# Source files
source altera_serial_flash_loader_hw_proc.tcl


# +-----------------------------------
# | module Serial Flash Loader
# +-----------------------------------
set_module_property NAME 							altera_serial_flash_loader
set_module_property VERSION 						18.1
set_module_property DISPLAY_NAME 					"Serial Flash Loader Intel FPGA IP"
set_module_property DESCRIPTION 					"The Altera Serial Flash Loader megafunction provides a bridge that allows \
														in-system JTAG programming method for serial configuration devices."
set_module_property GROUP 							"Basic Functions/Configuration and Programming"
set_module_property INTERNAL 						false
set_module_property AUTHOR 							"Altera Corporation"
set_module_property DATASHEET_URL 					"http://www.altera.com/literature/an/an370.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE	true
set_module_property EDITABLE 						false

set_module_property     ELABORATION_CALLBACK        elaboration

add_display_item "" "General" GROUP tab


# +-----------------------------------
# | Device Family Info
# +-----------------------------------

set supported_device_families_list {"Arria 10" "Arria II GX" "Arria II GZ" "Arria V" "Arria V GZ" \
									"Cyclone 10 LP" "Cyclone IV E" "Cyclone IV GX" "Cyclone V" \
									"Stratix IV" "Stratix V"}
									
proc check_device_ini {device_families_list}     {

    set enable_max10    [get_quartus_ini enable_max10_active_serial ENABLED]
    
    if {$enable_max10 == 1} {
        lappend device_families_list    "MAX 10"
     } 
    return $device_families_list
}

set device_list    [check_device_ini $supported_device_families_list]
set_module_property SUPPORTED_DEVICE_FAMILIES    $device_list									
									
add_parameter 			INTENDED_DEVICE_FAMILY	STRING
set_parameter_property	INTENDED_DEVICE_FAMILY	VISIBLE			false
set_parameter_property	INTENDED_DEVICE_FAMILY	SYSTEM_INFO		{DEVICE_FAMILY}
set_parameter_property	INTENDED_DEVICE_FAMILY	HDL_PARAMETER 	true


# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------

# Share ASMI selection
add_parameter 			gui_shared_access		BOOLEAN 				0
set_parameter_property	gui_shared_access		DISPLAY_NAME			"Share ASMI interface with your design"
set_parameter_property  gui_shared_access   	DESCRIPTION        		"Check to enable shared access"
set_parameter_property  gui_shared_access		AFFECTS_GENERATION		true
add_display_item		"General"				gui_shared_access		parameter
set_parameter_update_callback	gui_shared_access	update_shared_access

# Enhanced SFL selection
add_parameter 			ENHANCED_MODE			BOOLEAN 				1
set_parameter_property	ENHANCED_MODE			DISPLAY_NAME			"Use enhanced mode SFL"
set_parameter_property  ENHANCED_MODE   		DESCRIPTION        		"Check to enable enhanced SFL support"
set_parameter_property  ENHANCED_MODE			AFFECTS_GENERATION		true
set_parameter_property	ENHANCED_MODE			HDL_PARAMETER			true
add_display_item		"General"				ENHANCED_MODE			parameter
set_parameter_update_callback	ENHANCED_MODE	update_ui_parameters


# --- Convert to IP parameter list --- #
# Parameter for shared access 
add_parameter			ENABLE_SHARED_ACCESS	STRING					"OFF"
set_parameter_property	ENABLE_SHARED_ACCESS	VISIBLE					false
set_parameter_property	ENABLE_SHARED_ACCESS	ENABLED					true
set_parameter_property	ENABLE_SHARED_ACCESS	HDL_PARAMETER			true
set_parameter_property	ENABLE_SHARED_ACCESS	DERIVED					true

# Parameter for quad spi support
add_parameter			ENABLE_QUAD_SPI_SUPPORT	BOOLEAN					0
set_parameter_property	ENABLE_QUAD_SPI_SUPPORT	VISIBLE					false
set_parameter_property	ENABLE_QUAD_SPI_SUPPORT	ENABLED					true
set_parameter_property	ENABLE_QUAD_SPI_SUPPORT	HDL_PARAMETER			true
set_parameter_property	ENABLE_QUAD_SPI_SUPPORT	DERIVED					true

# Parameter for ncso width
add_parameter			NCSO_WIDTH				INTEGER					1
set_parameter_property	NCSO_WIDTH				VISIBLE					false
set_parameter_property	NCSO_WIDTH				ENABLED					true
set_parameter_property	NCSO_WIDTH				HDL_PARAMETER			true
set_parameter_property	NCSO_WIDTH				DERIVED					true
set_parameter_property	NCSO_WIDTH				ALLOWED_RANGES			{1 3}



# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_verilog SIM_VERILOG generate_synth
add_fileset sim_vhdl SIM_VHDL generate_synth

set_fileset_property quartus_synth TOP_LEVEL altera_serial_flash_loader
set_fileset_property sim_verilog TOP_LEVEL altera_serial_flash_loader
set_fileset_property sim_vhdl TOP_LEVEL altera_serial_flash_loader

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1410805299012/mwh1410805285096
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
