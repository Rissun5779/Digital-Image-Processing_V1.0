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
# | $Header: //acds/rel/18.1std/ip/altera_fault_injection/altera_fault_injection_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1

# Source files
source altera_fault_injection_hw_proc.tcl

# +-----------------------------------
# | module Fault Injection
# +-----------------------------------
set_module_property NAME altera_fault_injection
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Fault Injection Intel FPGA IP"
set_module_property DESCRIPTION "Altera Fault Injection enable customers to perform SEFI characterization in-house, scale FIT \
									rates according to SEFI characterization and optimize design to reduce effect of SEU."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
#set_module_property DATASHEET_URL ""
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true


set supported_device_families_list {"Arria 10" "Arria V" "Arria V GZ" "Cyclone V" "Stratix V"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list

# +-----------------------------------
# | Device family
# +-----------------------------------
add_parameter INTENDED_DEVICE_FAMILY STRING
set_parameter_property INTENDED_DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE false
set_parameter_property INTENDED_DEVICE_FAMILY HDL_PARAMETER true
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}

# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------

# add 'share internal oscillator' 

# covert to IP parameter - 'share internal oscillator' 
add_parameter ENABLE_INTOSC_SHARE STRING 
set_parameter_property ENABLE_INTOSC_SHARE DEFAULT_VALUE "YES"
set_parameter_property ENABLE_INTOSC_SHARE VISIBLE false
set_parameter_property ENABLE_INTOSC_SHARE ENABLED false
set_parameter_property ENABLE_INTOSC_SHARE HDL_PARAMETER true
set_parameter_property ENABLE_INTOSC_SHARE DERIVED true

add_parameter EMR_WIDTH INTEGER 67
set_parameter_property EMR_WIDTH VISIBLE false
set_parameter_property EMR_WIDTH HDL_PARAMETER true
set_parameter_property EMR_WIDTH DERIVED true

# covert to IP parameter - 'share prblock' 
add_parameter INSTANTIATE_PR_BLOCK BOOLEAN true 
set_parameter_property INSTANTIATE_PR_BLOCK DISPLAY_NAME "Auto-instantiate PR block"
set_parameter_property INSTANTIATE_PR_BLOCK DESCRIPTION "Set this to true (default) to have the PR block automatically instantiated within this IP. If you wish to share the PR block, set this to false; do instantiate the PR block on your own, and connect the relevant signals to this IP."
set_parameter_property INSTANTIATE_PR_BLOCK HDL_PARAMETER true
set_parameter_property INSTANTIATE_PR_BLOCK AFFECTS_GENERATION true
set_parameter_property INSTANTIATE_PR_BLOCK AFFECTS_ELABORATION true

add_parameter DATA_REG_WIDTH INTEGER 16
set_parameter_property DATA_REG_WIDTH VISIBLE false
set_parameter_property DATA_REG_WIDTH HDL_PARAMETER true
set_parameter_property DATA_REG_WIDTH AFFECTS_GENERATION true
set_parameter_property DATA_REG_WIDTH AFFECTS_ELABORATION true
set_parameter_property DATA_REG_WIDTH DERIVED true

# +-----------------------------------
# | static connection point - output
# +----------------------------------- 
add_interface crcerror_pin conduit start
set_interface_property crcerror_pin ENABLED true
set_interface_assignment crcerror_pin "ui.blockdiagram.direction" INPUT
add_interface_port crcerror_pin crcerror_pin crcerror_pin INPUT 1

add_interface avst_emr_snk avalon_streaming end
set_interface_property avst_emr_snk export_of altera_fault_injection.avst_emr_snk
add_interface_port avst_emr_snk emr_valid valid INPUT 1
set_interface_property avst_emr_snk associatedClock intosc
set_interface_property avst_emr_snk associatedReset reset
set_interface_property avst_emr_snk errorDescriptor ""
set_interface_property avst_emr_snk firstSymbolInHighOrderBits true
set_interface_property avst_emr_snk maxChannel 0
set_interface_property avst_emr_snk readyLatency 0

add_interface reset reset end
add_interface_port reset reset reset INPUT 1
set_interface_property reset synchronousEdges none

add_interface error_injected conduit start
add_interface_port error_injected error_injected error_injected Output 1
set_interface_assignment error_injected "ui.blockdiagram.direction" OUTPUT
set_interface_property error_injected ENABLED true

add_interface error_scrubbed conduit start
add_interface_port error_scrubbed error_scrubbed error_scrubbed Output 1
set_interface_assignment error_scrubbed "ui.blockdiagram.direction" OUTPUT
set_interface_property error_scrubbed ENABLED true

add_interface intosc clock start
add_interface_port intosc intosc clk Output 1
set_interface_assignment intosc "ui.blockdiagram.direction" OUTPUT
set_interface_property intosc ENABLED true
set_interface_property intosc clockRate 100000000
set_interface_property intosc clockRateKnown true
# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
set_module_property ELABORATION_CALLBACK elaboration_callback

# +-----------------------------------
# | Fileset Generation
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_verilog SIM_VERILOG generate_synth
add_fileset sim_vhdl SIM_VHDL generate_synth

set_fileset_property quartus_synth TOP_LEVEL altera_fault_injection
set_fileset_property sim_verilog TOP_LEVEL altera_fault_injection
set_fileset_property sim_vhdl TOP_LEVEL altera_fault_injection

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/esc1428515496663/esc1428515747926
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
