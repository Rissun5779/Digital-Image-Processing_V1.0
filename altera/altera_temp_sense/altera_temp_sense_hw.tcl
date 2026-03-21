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
# | $Header: //acds/rel/18.1std/ip/altera_temp_sense/altera_temp_sense_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1

# Source files
source altera_temp_sense_hw_proc.tcl
source clearbox.tcl

# +-----------------------------------
# | module Temperature Sensor
# +-----------------------------------
set_module_property NAME altera_temp_sense
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Temperature Sensor Intel FPGA IP"
set_module_property DESCRIPTION "The Altera Temperature Sensor megafunction configures the temperature sensing diode (TSD) \
									block to utilize the temperature measurement feature in the FPGA."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_alttemp_sense.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true

set_module_property ELABORATION_CALLBACK elaboration_callback

add_display_item "" "General Options" GROUP tab


# +-----------------------------------
# | device family info
# +-----------------------------------
set supported_device_families_list {"Arria V" "Arria V GZ" "Stratix IV" "Stratix V" "Arria 10"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list
add_parameter 			DEVICE_FAMILY 	STRING
set_parameter_property 	DEVICE_FAMILY 	VISIBLE 	false
set_parameter_property 	DEVICE_FAMILY 	SYSTEM_INFO {DEVICE_FAMILY}


#+--------------------------------------------
#|  clearbox auto blackbox flag
#+--------------------------------------------
add_parameter           CBX_AUTO_BLACKBOX   STRING              "ALL"
set_parameter_property  CBX_AUTO_BLACKBOX   DESCRIPTION         "Flag clearbox to blackbox other clearbox components or \
																	include them in the output variation file."
set_parameter_property  CBX_AUTO_BLACKBOX   VISIBLE             false
set_parameter_property  CBX_AUTO_BLACKBOX   AFFECTS_GENERATION  true


# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------
#set input frequency
add_parameter CLK_FREQUENCY FLOAT 
set_parameter_property CLK_FREQUENCY DEFAULT_VALUE "1.0"
set_parameter_property CLK_FREQUENCY DISPLAY_NAME "What is the input frequency? "
set_parameter_property CLK_FREQUENCY DESCRIPTION "Specifies the input frequency of the clk signal. The input frequency value is type string, and the value must be less than or equal to the clock divider value"
set_parameter_property CLK_FREQUENCY TYPE FLOAT
set_parameter_property CLK_FREQUENCY UNITS MEGAHERTZ
set_parameter_property CLK_FREQUENCY ALLOWED_RANGES 1.0:80.0
set_parameter_property CLK_FREQUENCY AFFECTS_ELABORATION true
set_parameter_property CLK_FREQUENCY AFFECTS_GENERATION true
add_display_item "General Options" CLK_FREQUENCY parameter

#set clock divider value
add_parameter CLOCK_DIVIDER_VALUE INTEGER
set_parameter_property CLOCK_DIVIDER_VALUE DEFAULT_VALUE 40
set_parameter_property CLOCK_DIVIDER_VALUE DISPLAY_NAME "What is the clock divider value?"
set_parameter_property CLOCK_DIVIDER_VALUE DESCRIPTION "Specifies the clock divider value. The megafunction divides the clock frequency value with the clock divider value before feeding the ADC. This option is only enabled when the clk signal frequency is more than 1 MHz"
set_parameter_property CLOCK_DIVIDER_VALUE TYPE INTEGER
set_parameter_property CLOCK_DIVIDER_VALUE AFFECTS_GENERATION true
set_parameter_property CLOCK_DIVIDER_VALUE AFFECTS_ELABORATION true
set_parameter_property CLOCK_DIVIDER_VALUE ALLOWED_RANGES {40 80}
set_parameter_property CLOCK_DIVIDER_VALUE ENABLED false
add_display_item "General Options" CLOCK_DIVIDER_VALUE parameter

# enable clock divicer (internal)
add_parameter CLOCK_DIVIDER_ENABLE STRING 
set_parameter_property CLOCK_DIVIDER_ENABLE DEFAULT_VALUE "off"
set_parameter_property CLOCK_DIVIDER_ENABLE TYPE STRING
set_parameter_property CLOCK_DIVIDER_ENABLE AFFECTS_GENERATION true
set_parameter_property CLOCK_DIVIDER_ENABLE AFFECTS_ELABORATION true
set_parameter_property CLOCK_DIVIDER_ENABLE DERIVED true
set_parameter_property CLOCK_DIVIDER_ENABLE VISIBLE false

# add 'ce' input port
add_parameter CE_CHECK boolean 
set_parameter_property CE_CHECK DEFAULT_VALUE 0
set_parameter_property CE_CHECK DISPLAY_NAME "Create a clock enable port"
set_parameter_property CE_CHECK DESCRIPTION "Specifies whether to turn on the asynchronous clock enable (ce) port."
set_parameter_property CE_CHECK AFFECTS_GENERATION true
set_parameter_property CE_CHECK AFFECTS_ELABORATION true
add_display_item "General Options" CE_CHECK parameter


# add 'clr' input port
add_parameter CLR_CHECK boolean 
set_parameter_property CLR_CHECK DEFAULT_VALUE 0
set_parameter_property CLR_CHECK DISPLAY_NAME "Create an asynchronous clear port"
set_parameter_property CLR_CHECK DESCRIPTION "Specifies whether to turn on the asynchronous clear (clr) port."
set_parameter_property CLR_CHECK AFFECTS_GENERATION true
set_parameter_property CLR_CHECK AFFECTS_ELABORATION true
add_display_item "General Options" CLR_CHECK parameter

# +------------------------------------------------
# | Parameters - Hidden
# +------------------------------------------------

# Set NUMBER_OF_SAMPLES
add_parameter NUMBER_OF_SAMPLES INTEGER 
set_parameter_property  NUMBER_OF_SAMPLES DEFAULT_VALUE 128
set_parameter_property  NUMBER_OF_SAMPLES TYPE INTEGER
set_parameter_property  NUMBER_OF_SAMPLES AFFECTS_GENERATION true
set_parameter_property  NUMBER_OF_SAMPLES VISIBLE false

# Set POI_CAL_TEMPERATURE
add_parameter POI_CAL_TEMPERATURE INTEGER 
set_parameter_property  POI_CAL_TEMPERATURE DEFAULT_VALUE 85
set_parameter_property  POI_CAL_TEMPERATURE TYPE INTEGER
set_parameter_property  POI_CAL_TEMPERATURE AFFECTS_GENERATION true
set_parameter_property  POI_CAL_TEMPERATURE VISIBLE false

# Set SIM_TSDCALO
add_parameter SIM_TSDCALO INTEGER 
set_parameter_property  SIM_TSDCALO DEFAULT_VALUE 0
set_parameter_property  SIM_TSDCALO TYPE INTEGER
set_parameter_property  SIM_TSDCALO AFFECTS_GENERATION true
set_parameter_property  SIM_TSDCALO VISIBLE false

# Set USE_WYS
add_parameter USE_WYS STRING 
set_parameter_property  USE_WYS DEFAULT_VALUE "on"
set_parameter_property  USE_WYS TYPE STRING
set_parameter_property  USE_WYS AFFECTS_GENERATION true
set_parameter_property  USE_WYS VISIBLE false

# Set USER_OFFSET_ENABLE
add_parameter USER_OFFSET_ENABLE STRING 
set_parameter_property  USER_OFFSET_ENABLE DEFAULT_VALUE "off"
set_parameter_property  USER_OFFSET_ENABLE TYPE STRING
set_parameter_property  USER_OFFSET_ENABLE AFFECTS_GENERATION true
set_parameter_property  USER_OFFSET_ENABLE VISIBLE false


add_display_item	"General Options"		"spacer1"			TEXT	""
add_display_item	"General Options"		"note_text"			TEXT	\
	"<html><font color=\"blue\"><b>Notes: Arria 10 uses internal clock of 1MHz</b></font></html>"
add_display_item	"General Options"		"info_note"			TEXT	\
	"<html><font color=\"blue\"><b>- all parameters are not applicable for Arria 10</b></font></html>"

# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
add_fileset quartus_synth   QUARTUS_SYNTH   do_quartus_synth

# Add dummy simulation file for SIM_VERILOG and SIM_VHDL
add_fileset simulation_fileset SIM_VERILOG sim_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL altera_temp_sense
add_fileset vhdl_fileset SIM_VHDL sim_callback_procedure
set_fileset_property vhdl_fileset TOP_LEVEL altera_temp_sense

proc sim_callback_procedure { entity_name } {
    add_fileset_file altera_temp_sense.v VERILOG PATH "altera_temp_sense_sim.v"
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1412131558004/eis1412131658598
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
