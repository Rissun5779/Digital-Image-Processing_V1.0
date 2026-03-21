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


package require -exact qsys 14.0

# 
# module altera_in_system_sources_probes
# 
set_module_property DESCRIPTION "In-system sources & probes debugging megafunction.  The In-System Sources and Probes megafunction is
available for all Altera device families supported by the Quartus Prime software."
set_module_property NAME altera_in_system_sources_probes
set_module_property VERSION 18.1
set_module_property SUPPORTED_DEVICE_FAMILIES {{ALL}}
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Basic Functions/Simulation; Debug and Verification/Debug and Performance"
set_module_property DISPLAY_NAME "Altera In-System Sources & Probes"
set_module_property EDITABLE false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property elaboration_callback do_elaboration
set_module_assignment embeddedsw.dts.vendor "altr"
set_module_assignment embeddedsw.dts.name "debug"
set_module_assignment embeddedsw.dts.group "ignore"

#
# documentation
#
add_documentation_link "Quartus II Handbook Volume 3: Verification" "https://www.altera.com/en_US/pdfs/literature/hb/qts/qts_qii5v3.pdf"
add_documentation_link "altsource_probe Megafunction Online Help" "https://documentation.altera.com/#/link/mwh1410385117325/mwh1410384945607"

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altsource_probe_top
add_fileset_file altsource_probe_top.v VERILOG PATH altsource_probe_top.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL altsource_probe
add_fileset_file altsource_probe.vhd VHDL PATH "altsource_probe_sim.vhd"

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altsource_probe
add_fileset_file altsource_probe.v VERILOG PATH "altsource_probe_sim.v"

#
# parameters
#

# Device Family
add_parameter device_family string ""
set_parameter_property device_family system_info_type device_family
set_parameter_property device_family VISIBLE false

# GUI Automatic Instance Index Assignment
add_parameter gui_use_auto_index BOOLEAN true "Automatically Assign Instance Index?"
set_parameter_property gui_use_auto_index DEFAULT_VALUE true
set_parameter_property gui_use_auto_index DISPLAY_NAME "Automatic Instance Index Assignment"
set_parameter_property gui_use_auto_index UNITS None
set_parameter_property gui_use_auto_index DESCRIPTION "Select if you want to automatically assign an instance index"
set_parameter_property gui_use_auto_index HDL_PARAMETER false

# HDL Automatic Instance Index Assignment
add_parameter sld_auto_instance_index STRING "YES" "HDL Parameter for automatically assigning the instance index"
set_parameter_property sld_auto_instance_index DEFAULT_VALUE "YES"
set_parameter_property sld_auto_instance_index DESCRIPTION "HDL Parameter for automatically assigning the instance index"
set_parameter_property sld_auto_instance_index VISIBLE false
set_parameter_property sld_auto_instance_index HDL_PARAMETER true
set_parameter_property sld_auto_instance_index DERIVED true

# Instance Index
add_parameter sld_instance_index INTEGER 0 "Manually Assign an Instance Index"
set_parameter_property sld_instance_index DEFAULT_VALUE 0
set_parameter_property sld_instance_index DISPLAY_NAME "Instance Index"
set_parameter_property sld_instance_index UNITS None
set_parameter_property sld_instance_index DESCRIPTION "Integer instance index property"
set_parameter_property sld_instance_index HDL_PARAMETER true

# Instance ID (optional)
add_parameter instance_id STRING "NONE" "Set an 'Instance ID' for this instance (optional)"
set_parameter_property instance_id DEFAULT_VALUE "NONE"
set_parameter_property instance_id DISPLAY_NAME "The 'Instance ID' of this instance (optional)"
set_parameter_property instance_id UNITS None
set_parameter_property instance_id DESCRIPTION "Enter a 4-character long string to uniquely identify this index"
set_parameter_property instance_id HDL_PARAMETER true

# Add Instance Index Display Item
add_display_item "Instance Info" gui_use_auto_index PARAMETER
add_display_item "Instance Info" sld_instance_index PARAMETER
add_display_item "Instance Info" instance_id PARAMETER

# Probe Port Width
add_parameter probe_width INTEGER 1 "How many bits wide should the probe port be \[0..512\]?"
set_parameter_property probe_width DEFAULT_VALUE 1
set_parameter_property probe_width DISPLAY_NAME "Probe Port Width \[0..512\]"
set_parameter_property probe_width UNITS None
set_parameter_property probe_width DESCRIPTION "Integer bit-width of the probe port"
set_parameter_property probe_width HDL_PARAMETER true

# Add Probe Parameters Display Item
add_display_item "Probe Parameters" probe_width PARAMETER

# Source Port Width
add_parameter source_width INTEGER 1 "How many bits wide should the source port be \[0..512\]?"
set_parameter_property source_width DEFAULT_VALUE 1
set_parameter_property source_width DISPLAY_NAME "Source Port Width \[0..512\]"
set_parameter_property source_width UNITS None
set_parameter_property source_width DESCRIPTION "Integer bit-width of the source port"
set_parameter_property source_width HDL_PARAMETER true

# Source Port Initial Value
add_parameter source_initial_value STRING "0" "Set a hexadecimal initial value for the Source Port"
set_parameter_property source_initial_value DEFAULT_VALUE "0"
set_parameter_property source_initial_value DISPLAY_NAME "Hexadecimal initial value for the Source Port"
set_parameter_property source_initial_value UNITS None
set_parameter_property source_initial_value DESCRIPTION "Set a hexadecimal initial value for the Source Port matching the width of the Source Port Width parameter"
set_parameter_property source_initial_value HDL_PARAMETER true

# Create Source Clock
add_parameter create_source_clock BOOLEAN false "Use Source Clock"
set_parameter_property create_source_clock DEFAULT_VALUE false
set_parameter_property create_source_clock DISPLAY_NAME "Use Source Clock"
set_parameter_property create_source_clock UNITS None
set_parameter_property create_source_clock DESCRIPTION "Write data to the source port synchronously to the source clock.<br>Each bit in the source port will utilize two additional registers<br>to protect the data transfer from the JTAG clock domain to the<br>source clock domain against metastable events."
set_parameter_property create_source_clock HDL_PARAMETER false

# Create Source Clock Enable
add_parameter create_source_clock_enable BOOLEAN false "Use Source Clock Enable"
set_parameter_property create_source_clock_enable DEFAULT_VALUE false
set_parameter_property create_source_clock_enable DISPLAY_NAME "Use Source Clock Enable"
set_parameter_property create_source_clock_enable UNITS None
set_parameter_property create_source_clock_enable DESCRIPTION "Create an enable signal for the registered source port."
set_parameter_property create_source_clock_enable HDL_PARAMETER false

# Add Source Parameters Display Item
add_display_item "Source Parameters" source_width PARAMETER
add_display_item "Source Parameters" source_initial_value PARAMETER
add_display_item "Source Parameters" create_source_clock PARAMETER
add_display_item "Source Parameters" create_source_clock_enable PARAMETER

# HDL Metastability Parameter
add_parameter enable_metastability STRING "NO"
set_parameter_property enable_metastability DEFAULT_VALUE "NO"
set_parameter_property enable_metastability DESCRIPTION "Metastability parameter must be set when using source_clk"
set_parameter_property enable_metastability VISIBLE false
set_parameter_property enable_metastability HDL_PARAMETER true
set_parameter_property enable_metastability DERIVED true


proc do_elaboration {} {
	# Global variables
	set source_used [expr {[get_parameter_value source_width] > 0}]
	set probe_used [expr {[get_parameter_value probe_width] > 0}]

	# Error checking
	if {[string length [get_parameter_value instance_id]] > 4} {
		send_message ERROR "The value given for 'Instance ID' is too long, it can only be 4 characters long or less."
	}
	
	if {([get_parameter_value source_width] < 0) || ([get_parameter_value source_width] > 512)} {
		send_message ERROR "The value given for 'Source Port Width' must be in the range of 0-512"
	}
	
	if {([get_parameter_value probe_width] < 0) || ([get_parameter_value probe_width] > 512)} {
		send_message ERROR "The value given for 'Probe Port Width' must be in the range of 0-512"
	}
	
	if {$source_used} {
		if {[regexp {^[A-Fa-f0-9]+$} [get_parameter_value source_initial_value] matched]} {
			set max_val [expr {pow(2,[get_parameter_value source_width]) - 1}]
			set initial_val [expr 0x[get_parameter_value source_initial_value]]
			
			if {$initial_val > $max_val} {
				send_message ERROR "The value given for 'Source Port Initial Value' is too big, it must match the bit-width of the source port"
			}
		} else {
			send_message ERROR "The value given for 'Source Port Initial Value' must be a hexadecimal string containing only characters a-f,A-F,0-9"
		}
	}
	
	# GUI Controls
	set_display_item_property create_source_clock ENABLED $source_used
	set_display_item_property create_source_clock_enable ENABLED [expr {$source_used && ([get_parameter_value create_source_clock])}]
	set_display_item_property source_initial_value ENABLED $source_used
	set_parameter_property source_initial_value HDL_PARAMETER $source_used
	
	set_display_item_property sld_instance_index ENABLED [expr {![get_parameter_value gui_use_auto_index]}]
	
	if {[get_parameter_value gui_use_auto_index]} {
		set_parameter_value sld_auto_instance_index "YES"
	} else {
		set_parameter_value sld_auto_instance_index "NO"
	}

	# sources interface
	set_parameter_value enable_metastability "NO"
	if {$source_used} {
		set source_ena_created false
	
		add_interface sources conduit end
		add_interface_port sources source source Output [get_parameter_value source_width]
		set_port_property source VHDL_TYPE std_logic_vector
		
		# source_clk interface
		if {[get_parameter_value create_source_clock]} {
			add_interface source_clk clock Input
			set_parameter_value enable_metastability "YES"
			set_interface_property source_clk clockRate 0
			set_interface_property source_clk ENABLED true
			add_interface_port source_clk source_clk clk Input 1
			set_interface_property sources associatedClock source_clk
			# source_ena port on sources interface
			if {[get_parameter_value create_source_clock_enable]} {
				add_interface_port sources source_ena source_ena Input 1
				set source_ena_created true
			}
		}
		
		if {!$source_ena_created} {
			add_interface_port sources source_ena source_ena Input 1
			set_port_property source_ena TERMINATION true
			set_port_property source_ena TERMINATION_VALUE 1
		}
	}
	
	# probes interface
	if {$probe_used} {
		add_interface probes conduit end
		add_interface_port probes probe probe Input [get_parameter_value probe_width]
		set_port_property probe VHDL_TYPE std_logic_vector
	}
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1410385117325/mwh1410384945607
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
