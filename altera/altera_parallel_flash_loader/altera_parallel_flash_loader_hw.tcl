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
# | $Header: //acds/rel/18.1std/ip/altera_parallel_flash_loader/altera_parallel_flash_loader_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1
package require -exact altera_terp 1.0

# Source files
source altera_parallel_flash_loader_hw_proc.tcl
source altera_parallel_flash_loader_ui_settings.tcl
source altera_parallel_flash_loader_csv_reader.tcl


# +-----------------------------------
# | module Serial Flash Loader
# +-----------------------------------
set_module_property NAME 							altera_parallel_flash_loader
set_module_property VERSION 						18.1
set_module_property DISPLAY_NAME 					"Parallel Flash Loader Intel FPGA IP"
set_module_property DESCRIPTION 					"The Altera Parallel Flash Loader megafunction provides an in-system JTAG \
														programming method for Common Flash Interface (CFI) flash, quad Serial \
														Peripheral Interface(SPI) flash, or NAND flash memory devices, and allow \
														FPGA configuration from the flash memory devices."
set_module_property GROUP 							"Basic Functions/Configuration and Programming"
set_module_property INTERNAL 						false
set_module_property AUTHOR 							"Altera Corporation"
set_module_property DATASHEET_URL 					"http://www.altera.com/literature/ug/ug_pfl.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE	true
set_module_property EDITABLE 						false

set_module_property     ELABORATION_CALLBACK        elaboration


# +-----------------------------------
# | Device Family Info
# +-----------------------------------

set supported_device_families_list {"Arria 10" \
									"Arria II GX" \
									"Arria II GZ" \
									"Arria V" \
									"Arria V GZ" \
                                    "Cyclone 10 LP" \
									"Cyclone IV E" \
									"Cyclone IV GX" \
									"Cyclone V" \
									"Max 10" \
									"Max II" \
									"Max V" \
									"Stratix IV" \
									"Stratix V"}

set_module_property SUPPORTED_DEVICE_FAMILIES	$supported_device_families_list


# +-----------------------------------
# | Tabs
# +-----------------------------------
add_display_item "" "General" GROUP tab
add_display_item "" "Flash Interface Setting" GROUP tab
add_display_item "" "Flash Programming" GROUP tab
add_display_item "" "FPGA Configuration" GROUP tab


# +-----------------------------------
# | Parameters 
# +-----------------------------------
create_parameters	"altera_parallel_flash_loader_parameters.csv"

# --- NAND flash interface text --- #
add_display_item	"Flash Interface Setting"	"spacer0"			TEXT	""
add_display_item	"Flash Interface Setting"	"nrb_label1"		TEXT	""
add_display_item	"Flash Interface Setting"	"nrb_label2"		TEXT	""
add_display_item	"Flash Interface Setting"	"ecc_info_text"		TEXT	""

# --- FPGA Configuration text --- #
add_display_item	"FPGA Configuration"		"spacer1"			TEXT	""
add_display_item	"FPGA Configuration"		"note_text"			TEXT	"Note:"
add_display_item	"FPGA Configuration"		"dclk_note"			TEXT	"- Configuration DCLK frequency is 100.0 MHz. All FPGAs being configured must support this frequency"
add_display_item	"FPGA Configuration"		"fpp_note"			TEXT	"- The selected configuration scheme is only supported in Stratix V, Arria V, Cyclone V, Arria 10 device family"

set_parameter_allowed_ranges


# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_verilog SIM_VERILOG generate_synth
add_fileset sim_vhdl SIM_VHDL generate_synth

set_fileset_property quartus_synth TOP_LEVEL altera_parallel_flash_loader
set_fileset_property sim_verilog TOP_LEVEL altera_parallel_flash_loader
set_fileset_property sim_vhdl TOP_LEVEL altera_parallel_flash_loader

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sss1411439280066/sss1411450059290
