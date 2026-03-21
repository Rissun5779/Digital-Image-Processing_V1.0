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

set_module_property DESCRIPTION "Altera Logic Analyzer Interface Agent"
set_module_property NAME altera_logic_analyzer_interface_agent
set_module_property VERSION 18.1
set_module_property SUPPORTED_DEVICE_FAMILIES {{ALL}}
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Basic Functions/Simulation; Debug and Verification/Debug and Performance"
set_module_property DISPLAY_NAME "Altera Logic Analyzer Interface Agent"
set_module_property EDITABLE false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property INTERNAL true
set_module_property elaboration_callback do_elaboration

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH QUARTUS_SYNTH
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sld_multitap

proc QUARTUS_SYNTH {output_name} {
	return
}

#
# parameters
#

# Device Family
add_parameter device_family string ""
set_parameter_property device_family system_info_type device_family

# SLD NODE INFO 
add_parameter sld_node_info INTEGER 3698176
set_parameter_property sld_node_info DEFAULT_VALUE 3698176
set_parameter_property sld_node_info UNITS None
set_parameter_property sld_node_info DESCRIPTION "Parameter to specify the SLD node type"
set_parameter_property sld_node_info HDL_PARAMETER true

# SLD_SECTION_ID 
add_parameter SLD_SECTION_ID STRING "auto_lai_0"
set_parameter_property SLD_SECTION_ID DEFAULT_VALUE "auto_lai_0"
set_parameter_property SLD_SECTION_ID DESCRIPTION "Section ID used for interface assignments"
set_parameter_property SLD_SECTION_ID HDL_PARAMETER true

# SLD_NODE_CRC
add_parameter SLD_NODE_CRC INTEGER 41394
set_parameter_property SLD_NODE_CRC DEFAULT_VALUE 41394
set_parameter_property SLD_NODE_CRC DESCRIPTION "Parameter to specify the CRC"
set_parameter_property SLD_NODE_CRC HDL_PARAMETER true

# SLD_BANK_WIDTH
add_parameter SLD_BANK_WIDTH INTEGER 8
set_parameter_property SLD_BANK_WIDTH DEFAULT_VALUE 8
set_parameter_property SLD_BANK_WIDTH DESCRIPTION "Width of each bank."
set_parameter_property SLD_BANK_WIDTH HDL_PARAMETER true

# SLD_BANK_SIZE
add_parameter SLD_BANK_SIZE INTEGER 2
set_parameter_property SLD_BANK_SIZE DEFAULT_VALUE 2
set_parameter_property SLD_BANK_SIZE DESCRIPTION "Number of banks."
set_parameter_property SLD_BANK_SIZE HDL_PARAMETER true

# SLD_BANK_SEL_WIDTH
add_parameter SLD_BANK_SEL_WIDTH INTEGER 1
set_parameter_property SLD_BANK_SEL_WIDTH DEFAULT_VALUE 1
set_parameter_property SLD_BANK_SEL_WIDTH DESCRIPTION "Width of the selection port of the bank mux."
set_parameter_property SLD_BANK_SEL_WIDTH HDL_PARAMETER true

# SLD_POWER_UP_STATE
add_parameter SLD_POWER_UP_STATE INTEGER 0
set_parameter_property SLD_POWER_UP_STATE DEFAULT_VALUE 0
set_parameter_property SLD_POWER_UP_STATE DESCRIPTION "Power-up state of the output pins: 0 - tri-stated; 1 - bank 0"
set_parameter_property SLD_POWER_UP_STATE HDL_PARAMETER true

# SLD_ACQ_MODE
add_parameter SLD_ACQ_MODE INTEGER 0
set_parameter_property SLD_ACQ_MODE DEFAULT_VALUE 0
set_parameter_property SLD_ACQ_MODE DISPLAY_HINT "boolean"
set_parameter_property SLD_ACQ_MODE DESCRIPTION "Acquisition mode: 0 - combinational; 1 - latched"
set_parameter_property SLD_ACQ_MODE HDL_PARAMETER true

# PREFER_HOST 
add_parameter PREFER_HOST STRING ""
set_parameter_property PREFER_HOST DEFAULT_VALUE ""
set_parameter_property PREFER_HOST DESCRIPTION "Used to tell which type of host to connect to first"
set_parameter_property PREFER_HOST HDL_PARAMETER false

# INSTANCE 
add_parameter INSTANCE INTEGER -1
set_parameter_property INSTANCE DEFAULT_VALUE -1
set_parameter_property INSTANCE DESCRIPTION "Parameter to specify the instance"
set_parameter_property INSTANCE HDL_PARAMETER false

proc do_elaboration {} {
	
	set signaltap_ir_width 3

	# Node Interface
	add_interface node conduit end
	add_interface_port node ir_in ir_in Input $signaltap_ir_width
	set_port_property ir_in VHDL_TYPE std_logic_vector
	add_interface_port node ir_out ir_out Output $signaltap_ir_width
	set_port_property ir_out VHDL_TYPE std_logic_vector
	add_interface_port node tdo tdo Output 1
	add_interface_port node tdi tdi Input 1
	add_interface_port node clr clr Input 1
	add_interface_port node usr1 usr1 Input 1
	add_interface_port node ena ena Input 1
	add_interface_port node jtag_state_cdr  jtag_state_cdr  Input 1
	add_interface_port node jtag_state_sdr  jtag_state_sdr  Input 1
	add_interface_port node jtag_state_udr  jtag_state_udr  Input 1

	### SIGNALS NOT USED BY LAI ###
    add_interface_port node jtag_state_uir  jtag_state_uir  Input 1
    add_interface_port node jtag_state_e1dr jtag_state_e1dr Input 1
	add_interface_port node jtag_state_tlr  jtag_state_tlr  Input 1
	add_interface_port node jtag_state_rti  jtag_state_rti  Input 1
	add_interface_port node jtag_state_sdrs jtag_state_sdrs Input 1
	add_interface_port node jtag_state_pdr  jtag_state_pdr  Input 1
	add_interface_port node jtag_state_e2dr jtag_state_e2dr Input 1
	add_interface_port node jtag_state_sirs jtag_state_sirs Input 1
	add_interface_port node jtag_state_cir  jtag_state_cir  Input 1
	add_interface_port node jtag_state_sir  jtag_state_sir	Input 1
	add_interface_port node jtag_state_e1ir jtag_state_e1ir Input 1
	add_interface_port node jtag_state_pir  jtag_state_pir  Input 1
	add_interface_port node jtag_state_e2ir jtag_state_e2ir Input 1
	add_interface_port node tms             tms             Input 1
	add_interface_port node clrn            clrn            Input 1
	add_interface_port node irq             irq             Output 1
	### SIGNALS NOT USED BY LAI ###
	
	# Clock Interface
	add_interface clock clock Input
	set_interface_property clock ENABLED true
	add_interface_port clock raw_tck clk Input 1
	set_interface_property node associatedClock clock
	
	# These interfaces have been intentionally left out to avoid unconnected interface error / warning from Qsys.
	# The ports involved will be exported and connected by the INTERFACE assignment mechanism in HDD.
	#	-> acq_clk
	#	-> acq_input
	#	-> acq_clk_input
	#	-> acq_output
}
