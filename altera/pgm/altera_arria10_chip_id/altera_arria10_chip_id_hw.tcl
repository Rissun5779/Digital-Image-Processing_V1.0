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
# | $Header: //acds/rel/18.1std/ip/pgm/altera_arria10_chip_id/altera_arria10_chip_id_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 12.1

# Source files
source altera_arria10_chip_id_hw_proc.tcl

# +-----------------------------------
# | module Unique Chip ID
# +-----------------------------------
set_module_property NAME altera_arria10_chip_id
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Unique Chip ID Intel Arria 10 FPGA IP"
set_module_property DESCRIPTION "The Altera Unique Chip ID megafunction provides feature to acquire the unique chip ID of FPGA."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/altchipid.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false

add_display_item "" "General" GROUP tab

# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------
add_display_item "General" "Information" TEXT "Maximum frequency of clkin signal is 30MHz"

set all_supported_device_families_list {"Arria 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES  		$all_supported_device_families_list

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false


# +-----------------------------------
# | UI Interface
# +-----------------------------------
#clkin port
set CLKIN_INTERFACE "clkin"
add_interface $CLKIN_INTERFACE clock end
add_interface_port $CLKIN_INTERFACE $CLKIN_INTERFACE clk Input 1

#reset port
set RESET_INTERFACE "reset"
add_interface $RESET_INTERFACE reset end
set_interface_property $RESET_INTERFACE associatedClock clkin
add_interface_port $RESET_INTERFACE $RESET_INTERFACE reset Input 1

#output port - data_valid, chip_id
add_interface output avalon_streaming start
set_interface_property output associatedClock clkin
add_interface_port output "data_valid" valid Output 1
add_interface_port output "chip_id" data Output 64

set_module_property ELABORATION_CALLBACK elaboration_callback

# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
set_fileset_property quartus_synth TOP_LEVEL altera_arria10_chip_id

#simulation
add_fileset sim_vhdl SIM_VHDL sim_callback_procedure
set_fileset_property sim_vhdl TOP_LEVEL altera_arria10_chip_id

add_fileset sim_verilog SIM_VERILOG sim_callback_procedure
set_fileset_property sim_verilog TOP_LEVEL altera_arria10_chip_id

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sam1412052977775/sam1412052870886
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
