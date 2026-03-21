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
# | $Header: //acds/rel/18.1std/ip/pgm/altera_s10_configuration_clock/altera_s10_configuration_clock_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1

# Source files
source ./altera_s10_configuration_clock_hw_proc.tcl

# +-----------------------------------
# | module Internal Oscillator
# +-----------------------------------
set_module_property NAME altera_s10_configuration_clock
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Altera S10 Configuration Clock"
set_module_property DESCRIPTION "Internal Oscillator provides internal clock source for debugging purpose."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DATASHEET_URL "http://www.altera.com/literature/"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true

set supported_device_families_list {"Stratix 10"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list

add_display_item {} "General" GROUP
add_display_item {} "Simulation" GROUP

# +-----------------------------------
# | Parameters - Parameter Settings tab
# +-----------------------------------

add_display_item "General" GUI_INFORMATION TEXT ""

#set internal display string
add_parameter INFORMATION STRING 
set_parameter_property INFORMATION DEFAULT_VALUE "The maximum output frequency is 80MHz"
set_parameter_property INFORMATION AFFECTS_ELABORATION true
set_parameter_property INFORMATION DERIVED true
set_parameter_property INFORMATION VISIBLE false

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false

add_parameter PART_NAME STRING "UNKNOWN"
set_parameter_property PART_NAME DISPLAY_NAME "Device"
set_parameter_property PART_NAME VISIBLE false
set_parameter_property PART_NAME SYSTEM_INFO {DEVICE}
set_parameter_property PART_NAME HDL_PARAMETER false

# parameter for simulation model
add_parameter DEVICE_ID STRING "UNKNOWN"
set_parameter_property DEVICE_ID VISIBLE false
set_parameter_property DEVICE_ID HDL_PARAMETER false
set_parameter_property DEVICE_ID DERIVED true

add_parameter CLOCK_FREQUENCY STRING "UNKNOWN"
set_parameter_property CLOCK_FREQUENCY VISIBLE false
set_parameter_property CLOCK_FREQUENCY HDL_PARAMETER false
set_parameter_property CLOCK_FREQUENCY DERIVED true

#+--------------------------------------------
#|  clearbox auto blackbox flag
#+--------------------------------------------
add_parameter           CBX_AUTO_BLACKBOX   STRING              "ALL"
set_parameter_property  CBX_AUTO_BLACKBOX   DESCRIPTION         "Flag clearbox to blackbox other clearbox components or include them in the output variation file."
set_parameter_property  CBX_AUTO_BLACKBOX   VISIBLE             false
set_parameter_property  CBX_AUTO_BLACKBOX   AFFECTS_GENERATION  true

# +-----------------------------------
# | connection point - output
# +------------------------------------
add_interface clkout clock start
add_interface_port clkout clkout clk Output 1
set_interface_assignment clkout "ui.blockdiagram.direction" OUTPUT
set_interface_property clkout ENABLED true

# +-----------------------------------
# | Fileset Callbacks and Generation
# +----------------------------------- 
set_module_property ELABORATION_CALLBACK elaboration_callback

#+-------------------------------------------------------------------------------------------------------------------------
#|  Quartus synth
#+-------------------------------------------------------------------------------------------------------------------------


add_fileset           quartus_synth  QUARTUS_SYNTH   do_quartus_synth
set_fileset_property  quartus_synth  TOP_LEVEL       altera_s10_configuration_clock


proc do_quartus_synth {output_name} {

	send_message    info    "Generating top-level entity $output_name."

	set get_device_family [get_parameter_value DEVICE_FAMILY]
    set get_device_id [get_parameter_value DEVICE_ID]
	
    add_fileset_file altera_s10_configuration_clock.v VERILOG PATH altera_s10_configuration_clock.v
    add_fileset_file altera_s10_configuration_clock.sdc SDC PATH "altera_s10_configuration_clock.sdc"
}

#+-------------------------------------------------------------------------------------------------------------------------
#|  Quartus simulation 
#+-------------------------------------------------------------------------------------------------------------------------
add_fileset           verilog_sim  SIM_VERILOG     do_quartus_synth
set_fileset_property  verilog_sim  TOP_LEVEL       altera_s10_configuration_clock

add_fileset           vhdl_sim     SIM_VHDL        do_quartus_synth
set_fileset_property  vhdl_sim     TOP_LEVEL       altera_s10_configuration_clock

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/en_US/pdfs/literature/hb/max-10/ug_m10_clkpll.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
