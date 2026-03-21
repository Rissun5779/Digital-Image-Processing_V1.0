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

set_module_property DESCRIPTION "Altera Signal Tap Agent"
set_module_property NAME altera_signaltap_agent
set_module_property VERSION 18.1
set_module_property SUPPORTED_DEVICE_FAMILIES {{ALL}}
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Basic Functions/Simulation; Debug and Verification/Debug and Performance"
set_module_property DISPLAY_NAME "Altera SignalTap II Agent"
set_module_property EDITABLE false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property INTERNAL true
set_module_property elaboration_callback do_elaboration

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH QUARTUS_SYNTH
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sld_signaltap

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
add_parameter sld_node_info INTEGER 1076736
set_parameter_property sld_node_info DEFAULT_VALUE 1076736
set_parameter_property sld_node_info UNITS None
set_parameter_property sld_node_info DESCRIPTION "Parameter to specify the SLD node type"
set_parameter_property sld_node_info HDL_PARAMETER true

# SLD_SECTION_ID 
add_parameter SLD_SECTION_ID STRING "hdl_signaltap_0"
set_parameter_property SLD_SECTION_ID DEFAULT_VALUE "hdl_signaltap_0"
set_parameter_property SLD_SECTION_ID DESCRIPTION "Section ID used for interface assignments"
set_parameter_property SLD_SECTION_ID HDL_PARAMETER true

# Data Port Width
add_parameter sld_data_bits INTEGER 1 "Data Input Port Width"
set_parameter_property sld_data_bits DEFAULT_VALUE 1
set_parameter_property sld_data_bits DISPLAY_NAME "Data Input Port Width"
set_parameter_property sld_data_bits UNITS None
set_parameter_property sld_data_bits DESCRIPTION "Integer Data Input Port Width"
set_parameter_property sld_data_bits HDL_PARAMETER true

# Trigger Port Width
add_parameter sld_trigger_bits INTEGER 1 "Trigger Input Port Width"
set_parameter_property sld_trigger_bits DEFAULT_VALUE 1
set_parameter_property sld_trigger_bits DISPLAY_NAME "Trigger Input Port Width"
set_parameter_property sld_trigger_bits UNITS None
set_parameter_property sld_trigger_bits DESCRIPTION "Integer Trigger Input Port Width"
set_parameter_property sld_trigger_bits HDL_PARAMETER true

# CRC bits 
add_parameter sld_node_crc_bits INTEGER 32
set_parameter_property sld_node_crc_bits DEFAULT_VALUE 32
set_parameter_property sld_node_crc_bits UNITS None
set_parameter_property sld_node_crc_bits DESCRIPTION "Parameter to specify the number of CRC bits"
set_parameter_property sld_node_crc_bits HDL_PARAMETER true

# SLD CRC HI 
add_parameter sld_node_crc_hiword INTEGER 12345
set_parameter_property sld_node_crc_hiword DEFAULT_VALUE 12345
set_parameter_property sld_node_crc_hiword UNITS None
set_parameter_property sld_node_crc_hiword DESCRIPTION "Parameter to specify the CRC upper 16 bits"
set_parameter_property sld_node_crc_hiword HDL_PARAMETER true

# SLD CRC LO 
add_parameter sld_node_crc_loword INTEGER 19899
set_parameter_property sld_node_crc_loword DEFAULT_VALUE 19899
set_parameter_property sld_node_crc_loword UNITS None
set_parameter_property sld_node_crc_loword DESCRIPTION "Parameter to specify the CRC lower 16 bits"
set_parameter_property sld_node_crc_loword HDL_PARAMETER true

# SLD INCREMENTAL ROUTING 
add_parameter sld_incremental_routing INTEGER 0
set_parameter_property sld_incremental_routing DEFAULT_VALUE 0
set_parameter_property sld_incremental_routing DISPLAY_HINT "boolean"
set_parameter_property sld_incremental_routing DESCRIPTION "Indicate whether incremental CRC register is used"
set_parameter_property sld_incremental_routing HDL_PARAMETER true

# Sample Depth
add_parameter sld_sample_depth INTEGER  "Sample Depth"
set_parameter_property sld_sample_depth DEFAULT_VALUE 128
set_parameter_property sld_sample_depth DISPLAY_NAME "Sample Depth"
set_parameter_property sld_sample_depth ALLOWED_RANGES { 0:0 64:64 128:128 256:256 512:512 1024:1K 2048:2K 4096:4K 8192:8K 16384:16K 32768:32K 65536:64K 131072:128K}
set_parameter_property sld_sample_depth UNITS None
set_parameter_property sld_sample_depth DESCRIPTION "Integer number of samples to collect"
set_parameter_property sld_sample_depth HDL_PARAMETER true

# Segment Size
add_parameter sld_segment_size Integer 0
set_parameter_property sld_segment_size DEFAULT_VALUE 0
set_parameter_property sld_segment_size DESCRIPTION "Segment Sample Size"
set_parameter_property sld_segment_size HDL_PARAMETER true

# HDL RAM TYPE
add_parameter sld_ram_block_type STRING "AUTO" "RAM type"
set_parameter_property sld_ram_block_type DEFAULT_VALUE "AUTO"
set_parameter_property sld_ram_block_type DESCRIPTION "RAM type to use for samples collected"
set_parameter_property sld_ram_block_type HDL_PARAMETER true

# SLD STATE BITS
add_parameter sld_state_bits Integer 4
set_parameter_property sld_state_bits DEFAULT_VALUE 4
set_parameter_property sld_state_bits DESCRIPTION "Bits necessary to store state"
set_parameter_property sld_state_bits HDL_PARAMETER true

# SLD BUFFER FULL STOP
add_parameter sld_buffer_full_stop INTEGER 0
set_parameter_property sld_buffer_full_stop DEFAULT_VALUE 0
set_parameter_property sld_buffer_full_stop DISPLAY_HINT "boolean"
set_parameter_property sld_buffer_full_stop DESCRIPTION "If set to 1, once last segment full auto stops acquisition"
set_parameter_property sld_buffer_full_stop HDL_PARAMETER true

# Trigger Conditions
add_parameter sld_trigger_level INTEGER 1 "Trigger Conditions"
set_parameter_property sld_trigger_level DEFAULT_VALUE 1
set_parameter_property sld_trigger_level ALLOWED_RANGES { 1 2 3 4 5 6 7 8 9 10 }
set_parameter_property sld_trigger_level UNITS None
set_parameter_property sld_trigger_level DESCRIPTION "Number of Trigger Conditions or \"Levels\" to use"
set_parameter_property sld_trigger_level HDL_PARAMETER true

# Trigger In Enabled
add_parameter sld_trigger_in_enabled INTEGER 0 "Trigger In"
set_parameter_property sld_trigger_in_enabled DEFAULT_VALUE 0
set_parameter_property sld_trigger_in_enabled DISPLAY_HINT "boolean"
set_parameter_property sld_trigger_in_enabled DESCRIPTION "Enable the Trigger In feature and create a port for it"
set_parameter_property sld_trigger_in_enabled HDL_PARAMETER true

# HPS Trigger In Enabled
add_parameter sld_hps_trigger_in_enabled INTEGER 0 "HPS Trigger In"
set_parameter_property sld_hps_trigger_in_enabled DEFAULT_VALUE 0
set_parameter_property sld_hps_trigger_in_enabled DISPLAY_HINT "boolean"
set_parameter_property sld_hps_trigger_in_enabled DESCRIPTION "Indicate whether to generate the trigger_in logic from HPS.  Generate if it is 1; not, otherwise."
set_parameter_property sld_hps_trigger_in_enabled HDL_PARAMETER true

# HPS Trigger Out Enabled
add_parameter sld_hps_trigger_out_enabled INTEGER 0 "Trigger Out"
set_parameter_property sld_hps_trigger_out_enabled DEFAULT_VALUE 0
set_parameter_property sld_hps_trigger_out_enabled DISPLAY_HINT "boolean"
set_parameter_property sld_hps_trigger_out_enabled DESCRIPTION "Indicate whether to generate the trigger_out logic driving HPS.  Generate if it is 1; not, otherwise."
set_parameter_property sld_hps_trigger_out_enabled HDL_PARAMETER true

# SLD_HPS_EVENT_ENABLED
add_parameter sld_hps_event_enabled INTEGER 0 "HPS Events Enabled"
set_parameter_property sld_hps_event_enabled DEFAULT_VALUE 0
set_parameter_property sld_hps_event_enabled DISPLAY_HINT "boolean"
set_parameter_property sld_hps_event_enabled DESCRIPTION "Indicate whether to generate the event logic driving HPS.  Generate if it is 1; not, otherwise."
set_parameter_property sld_hps_event_enabled HDL_PARAMETER true

# SLD_HPS_EVENT_ID
add_parameter sld_hps_event_id INTEGER 0 "Trigger Conditions"
set_parameter_property sld_hps_event_id DEFAULT_VALUE 0
set_parameter_property sld_hps_event_id DESCRIPTION "Specifies the event line index, if event logic is created driving HPS."
set_parameter_property sld_hps_event_id HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_ENTITY
add_parameter sld_advanced_trigger_entity STRING "basic"
set_parameter_property sld_advanced_trigger_entity DEFAULT_VALUE "basic"
set_parameter_property sld_advanced_trigger_entity HDL_PARAMETER true

# SLD_TRIGGER_LEVEL_PIPELINE
add_parameter sld_trigger_level_pipeline INTEGER 1 "SLD_TRIGGER_LEVEL_PIPELINE"
set_parameter_property sld_trigger_level_pipeline DEFAULT_VALUE 1
set_parameter_property sld_trigger_level_pipeline HDL_PARAMETER true

# SLD_ENABLE_ADVANCED_TRIGGER
add_parameter sld_enable_advanced_trigger INTEGER 0
set_parameter_property sld_enable_advanced_trigger DEFAULT_VALUE 0
set_parameter_property sld_enable_advanced_trigger DISPLAY_HINT "boolean"
set_parameter_property sld_enable_advanced_trigger DESCRIPTION "Parameter to disable Advanced Triggers"
set_parameter_property sld_enable_advanced_trigger HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_1
add_parameter sld_advanced_trigger_1 STRING "NONE"
set_parameter_property sld_advanced_trigger_1 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_1 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_2
add_parameter sld_advanced_trigger_2 STRING "NONE"
set_parameter_property sld_advanced_trigger_2 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_2 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_3
add_parameter sld_advanced_trigger_3 STRING "NONE"
set_parameter_property sld_advanced_trigger_3 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_3 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_4
add_parameter sld_advanced_trigger_4 STRING "NONE"
set_parameter_property sld_advanced_trigger_4 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_4 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_5
add_parameter sld_advanced_trigger_5 STRING "NONE"
set_parameter_property sld_advanced_trigger_5 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_5 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_6
add_parameter sld_advanced_trigger_6 STRING "NONE"
set_parameter_property sld_advanced_trigger_6 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_6 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_7
add_parameter sld_advanced_trigger_7 STRING "NONE"
set_parameter_property sld_advanced_trigger_7 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_7 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_8
add_parameter sld_advanced_trigger_8 STRING "NONE"
set_parameter_property sld_advanced_trigger_8 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_8 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_9
add_parameter sld_advanced_trigger_9 STRING "NONE"
set_parameter_property sld_advanced_trigger_9 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_9 HDL_PARAMETER true

# SLD_ADVANCED_TRIGGER_10
add_parameter sld_advanced_trigger_10 STRING "NONE"
set_parameter_property sld_advanced_trigger_10 DEFAULT_VALUE "NONE"
set_parameter_property sld_advanced_trigger_10 HDL_PARAMETER true

# SLD_INVERSION_MASK_LENGTH
add_parameter sld_inversion_mask_length INTEGER 1 "sld_inversion_mask_length"
set_parameter_property sld_inversion_mask_length DEFAULT_VALUE 1
set_parameter_property sld_inversion_mask_length HDL_PARAMETER true

# SLD_INVERSION_MASK
add_parameter sld_inversion_mask STD_LOGIC_VECTOR "0"
set_parameter_property sld_inversion_mask DEFAULT_VALUE "0"
set_parameter_property sld_inversion_mask WIDTH sld_inversion_mask_length
set_parameter_property sld_inversion_mask HDL_PARAMETER true

# SLD_POWER_UP_TRIGGER
add_parameter sld_power_up_trigger INTEGER 0 "SLD Power Up Trigger"
set_parameter_property sld_power_up_trigger DEFAULT_VALUE 0
set_parameter_property sld_power_up_trigger DISPLAY_HINT "boolean"
set_parameter_property sld_power_up_trigger HDL_PARAMETER true

# SLD_STATE_FLOW_MGR_ENTITY
add_parameter sld_state_flow_mgr_entity STRING "state_flow_mgr_entity.vhd"
set_parameter_property sld_state_flow_mgr_entity DEFAULT_VALUE "state_flow_mgr_entity.vhd"
set_parameter_property sld_state_flow_mgr_entity HDL_PARAMETER true

# SLD_STATE_FLOW_USE_GENERATED
add_parameter sld_state_flow_use_generated INTEGER 0 "SLD_STATE_FLOW_USE_GENERATED"
set_parameter_property sld_state_flow_use_generated DEFAULT_VALUE 0
set_parameter_property sld_state_flow_use_generated DISPLAY_HINT "boolean"
set_parameter_property sld_state_flow_use_generated HDL_PARAMETER true

# SLD_CURRENT_RESOURCE_WIDTH
add_parameter sld_current_resource_width INTEGER 0 "sld_current_resource_width"
set_parameter_property sld_current_resource_width DEFAULT_VALUE 0
set_parameter_property sld_current_resource_width HDL_PARAMETER true

# SLD_ATTRIBUTE_MEM_MODE
add_parameter sld_attribute_mem_mode STRING "OFF"
set_parameter_property sld_attribute_mem_mode DEFAULT_VALUE "OFF"
set_parameter_property sld_attribute_mem_mode HDL_PARAMETER true

# SLD_STORAGE_QUALIFIER_BITS
add_parameter sld_storage_qualifier_bits INTEGER 1 "sld_storage_qualifier_bits"
set_parameter_property sld_storage_qualifier_bits DEFAULT_VALUE 1
set_parameter_property sld_storage_qualifier_bits HDL_PARAMETER true

# SLD_STORAGE_QUALIFIER_GAP_RECORD
add_parameter sld_storage_qualifier_gap_record INTEGER 0 "sld_storage_qualifier_gap_record"
set_parameter_property sld_storage_qualifier_gap_record DEFAULT_VALUE 0
set_parameter_property sld_storage_qualifier_gap_record DISPLAY_HINT "boolean"
set_parameter_property sld_storage_qualifier_gap_record HDL_PARAMETER true

# SLD_STORAGE_QUALIFIER_MODE
add_parameter sld_storage_qualifier_mode STRING "OFF"
set_parameter_property sld_storage_qualifier_mode DEFAULT_VALUE "OFF"
set_parameter_property sld_storage_qualifier_mode HDL_PARAMETER true

# SLD_STORAGE_QUALIFIER_ENABLE_ADVANCED_CONDITION
add_parameter sld_storage_qualifier_enable_advanced_condition INTEGER 0 "sld_storage_qualifier_enable_advanced_condition"
set_parameter_property sld_storage_qualifier_enable_advanced_condition DEFAULT_VALUE 0
set_parameter_property sld_storage_qualifier_enable_advanced_condition DISPLAY_HINT "boolean"
set_parameter_property sld_storage_qualifier_enable_advanced_condition HDL_PARAMETER true

# SLD_STORAGE_QUALIFIER_INVERSION_MASK_LENGTH
add_parameter sld_storage_qualifier_inversion_mask_length INTEGER 0 "sld_storage_qualifier_inversion_mask_length"
set_parameter_property sld_storage_qualifier_inversion_mask_length DEFAULT_VALUE 0
set_parameter_property sld_storage_qualifier_inversion_mask_length HDL_PARAMETER true

# SLD_STORAGE_QUALIFIER_ADVANCED_CONDITION_ENTITY
add_parameter sld_storage_qualifier_advanced_condition_entity STRING "basic"
set_parameter_property sld_storage_qualifier_advanced_condition_entity DEFAULT_VALUE "basic"
set_parameter_property sld_storage_qualifier_advanced_condition_entity HDL_PARAMETER true

# SLD_STORAGE_QUALIFIER_PIPELINE
add_parameter sld_storage_qualifier_pipeline INTEGER 0 "sld_storage_qualifier_pipeline"
set_parameter_property sld_storage_qualifier_pipeline DEFAULT_VALUE 0
set_parameter_property sld_storage_qualifier_pipeline HDL_PARAMETER true

# SLD_TRIGGER_PIPELINE
add_parameter sld_trigger_pipeline INTEGER 0 "sld_trigger_pipeline"
set_parameter_property sld_trigger_pipeline DEFAULT_VALUE 0
set_parameter_property sld_trigger_pipeline HDL_PARAMETER true

# SLD_RAM_PIPELINE
add_parameter sld_ram_pipeline INTEGER 0 "sld_ram_pipeline"
set_parameter_property sld_ram_pipeline DEFAULT_VALUE 0
set_parameter_property sld_ram_pipeline HDL_PARAMETER true

# SLD_COUNTER_PIPELINE
add_parameter sld_counter_pipeline INTEGER 0 "sld_counter_pipeline"
set_parameter_property sld_counter_pipeline DEFAULT_VALUE 0
set_parameter_property sld_counter_pipeline HDL_PARAMETER true

# SLD_USE_JTAG_SIGNAL_ADAPTER
# Do not use jtag adapter to add sld jtag endpoint because legacy sld port interface is connected in the fabric directly.
# This parameter value is not overriden by software
add_parameter sld_use_jtag_signal_adapter INTEGER 0 "sld_use_jtag_signal_adapter"
set_parameter_property sld_use_jtag_signal_adapter DEFAULT_VALUE 0
set_parameter_property sld_use_jtag_signal_adapter HDL_PARAMETER true

# SLD_CREATE_MONITOR_INTERFACE
# Create monitor interface assignment such that synthesizer can discover this interface and make tapping connections.
# This parameter value is not overriden by software
add_parameter sld_create_monitor_interface INTEGER 1 "sld_create_monitor_interface"
set_parameter_property sld_create_monitor_interface DEFAULT_VALUE 1
set_parameter_property sld_create_monitor_interface HDL_PARAMETER true

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
	
	set signaltap_ir_width 10

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
	add_interface_port node jtag_state_e1dr jtag_state_e1dr Input 1
	add_interface_port node jtag_state_udr  jtag_state_udr  Input 1
	add_interface_port node jtag_state_uir  jtag_state_uir  Input 1
	### SIGNALS NOT USED BY SIGNALTAP ###
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
	### SIGNALS NOT USED BY SIGNALTAP ###
	
	# Clock Interface
	add_interface clock clock Input
	set_interface_property clock ENABLED true
	add_interface_port clock raw_tck clk Input 1
	set_interface_property node associatedClock clock
	
	# These interfaces have been intentionally left out to avoid unconnected interface error / warning from Qsys.
	# The ports involved will be exported and connected by the INTERFACE assignment mechanism in HDD.
	#	-> Trigger In
	#	-> Trigger Out
	#	-> Storage Enable
	#	-> Acquisition Clock
	#	-> Acquisition Storage Qualifier In
	#	-> Acquisition Data In
	#	-> Acquisition Trigger In
}
