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
# module altera_virtual_jtag
# 
set_module_property DESCRIPTION "Virtual JTAG Interface (VJI) megafunction. This megafunction provides access to the PLD source through the JTAG interface.
The Quartus Prime software or JTAG control host identifies each instance of this megafunction by a unique index. Each megafunction instance
functions in a flow that resembles the JTAG operation of a device. The logic that uses this interface must maintain the continuity of
the JTAG chain on behalf the PLD device when this instance becomes active."
set_module_property NAME altera_virtual_jtag
set_module_property VERSION 18.1
set_module_property SUPPORTED_DEVICE_FAMILIES {{ALL}}
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Basic Functions/Simulation; Debug and Verification/Debug and Performance"
set_module_property DISPLAY_NAME "Altera Virtual JTAG"
set_module_property EDITABLE false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property elaboration_callback do_elaboration

#
# documentation
#
add_documentation_link "Altera Virtual JTAG (altera_virtual_jtag) IP Core User Guide" "http://www.altera.com/literature/ug/ug_virtualjtag.pdf"

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH QUARTUS_SYNTH
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sld_virtual_jtag

proc QUARTUS_SYNTH {output_name} {
	return
}

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL sld_virtual_jtag
add_fileset_file sld_virtual_jtag.vhd VHDL PATH "sld_virtual_jtag_sim.vhd"

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL sld_virtual_jtag
add_fileset_file sld_virtual_jtag.v VERILOG PATH "sld_virtual_jtag_sim.v"

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

# Add Instance Index Display Item
add_display_item "Instance Index" gui_use_auto_index PARAMETER
add_display_item "Instance Index" sld_instance_index PARAMETER

# Instruction Register Width
add_parameter sld_ir_width INTEGER 1 "How many bits wide should the instruction register be \[1..24\]?"
set_parameter_property sld_ir_width DEFAULT_VALUE 1
set_parameter_property sld_ir_width ALLOWED_RANGES { 1:24 }
set_parameter_property sld_ir_width DISPLAY_NAME "Instruction Register Width \[1..24\]"
set_parameter_property sld_ir_width UNITS None
set_parameter_property sld_ir_width DESCRIPTION "Integer bit-width of the instruction register"
set_parameter_property sld_ir_width HDL_PARAMETER true

# Create primitive JTAG state signal ports
add_parameter CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS BOOLEAN false ""
set_parameter_property CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS DEFAULT_VALUE false
set_parameter_property CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS DISPLAY_NAME "Create primitive JTAG state signal ports"
set_parameter_property CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS UNITS None
set_parameter_property CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS DESCRIPTION "Select if you want to expose additional primitive JTAG state signal ports"
# If true, connect all the ports from the sld_virtual_jtag module to the wrapper
set_parameter_property CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS HDL_PARAMETER false

# Add Parameters Display Item
add_display_item "Parameters" sld_ir_width PARAMETER
add_display_item "Parameters" CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS PARAMETER

proc do_elaboration {} {
	# GUI controls / validation
	set_display_item_property sld_instance_index ENABLED [expr {![get_parameter_value gui_use_auto_index]}]
	
	if {[get_parameter_value gui_use_auto_index]} {
		set_parameter_value sld_auto_instance_index "YES"
	} else {
		set_parameter_value sld_auto_instance_index "NO"
	}
	
	# interface jtag
	add_interface jtag conduit end	
	
	# high-level jtag signals
	set_interface_property jtag associatedClock tck
	add_interface_port jtag tdi tdi Output 1
	add_interface_port jtag tdo tdo Input 1	
	add_interface_port jtag ir_in ir_in Output [get_parameter_value sld_ir_width]
	add_interface_port jtag ir_out ir_out Input [get_parameter_value sld_ir_width]
	set_port_property ir_in VHDL_TYPE std_logic_vector
	set_port_property ir_out VHDL_TYPE std_logic_vector
	add_interface_port jtag virtual_state_cdr  virtual_state_cdr  Output 1
	add_interface_port jtag virtual_state_sdr  virtual_state_sdr  Output 1
	add_interface_port jtag virtual_state_e1dr virtual_state_e1dr Output 1
	add_interface_port jtag virtual_state_pdr  virtual_state_pdr  Output 1
	add_interface_port jtag virtual_state_e2dr virtual_state_e2dr Output 1
	add_interface_port jtag virtual_state_udr  virtual_state_udr  Output 1
	add_interface_port jtag virtual_state_cir  virtual_state_cir  Output 1
	add_interface_port jtag virtual_state_uir  virtual_state_uir  Output 1
	
	# primitive jtag state signal ports
	if {[get_parameter_value CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS]} {
	
		add_interface_port jtag tms tms Output 1
		add_interface_port jtag jtag_state_tlr  jtag_state_tlr   Output 1
		add_interface_port jtag jtag_state_rti  jtag_state_rti   Output 1
		add_interface_port jtag jtag_state_sdrs jtag_state_sdrs  Output 1
		add_interface_port jtag jtag_state_cdr  jtag_state_cdr   Output 1
		add_interface_port jtag jtag_state_sdr  jtag_state_sdr   Output 1
		add_interface_port jtag jtag_state_e1dr jtag_state_e1dr  Output 1
		add_interface_port jtag jtag_state_pdr  jtag_state_pdr   Output 1
		add_interface_port jtag jtag_state_e2dr jtag_state_e2dr  Output 1
		add_interface_port jtag jtag_state_udr  jtag_state_udr   Output 1
		add_interface_port jtag jtag_state_sirs jtag_state_sirs  Output 1
		add_interface_port jtag jtag_state_cir  jtag_state_cir   Output 1
		add_interface_port jtag jtag_state_sir  jtag_state_sir   Output 1
		add_interface_port jtag jtag_state_e1ir jtag_state_e1ir  Output 1
		add_interface_port jtag jtag_state_pir  jtag_state_pir   Output 1
		add_interface_port jtag jtag_state_e2ir jtag_state_e2ir  Output 1
		add_interface_port jtag jtag_state_uir  jtag_state_uir   Output 1
	}

	# interface tck
	add_interface tck clock Output
	set_interface_property tck clockRate 0
	set_interface_property tck ENABLED true
	add_interface_port tck tck clk Output 1
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/bhc1411109490717/bhc1411109292871
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
