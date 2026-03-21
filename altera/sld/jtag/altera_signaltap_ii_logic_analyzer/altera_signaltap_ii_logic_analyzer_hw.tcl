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
# module altera_signaltap_ii_logic_analyzer
# 
set_module_property DESCRIPTION "Altera Signal Tap Logic Analyzer"
set_module_property NAME altera_signaltap_ii_logic_analyzer
set_module_property VERSION 18.1
set_module_property SUPPORTED_DEVICE_FAMILIES {{ALL}}
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Basic Functions/Simulation; Debug and Verification/Debug and Performance"
set_module_property DISPLAY_NAME "Altera SignalTap II Logic Analyzer"
set_module_property EDITABLE false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property elaboration_callback do_elaboration

#
# documentation
#
add_documentation_link "Design Debugging Using the Signal Tap Logic Analyzer" "http://www.altera.com/literature/hb/qts/qts_qii53009.pdf"
add_documentation_link "sld_signaltap Megafunction Online Help" "http://quartushelp.altera.com/14.0/mergedProjects/hdl/mega/mega_file_sld_signaltap.htm?GSA_pos=43&WT.oss_r=1&WT.oss=signaltap"

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH QUARTUS_SYNTH
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sld_signaltap

proc QUARTUS_SYNTH {output_name} {
	return
}

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL sld_signaltap
add_fileset_file sld_signaltap.vhd VHDL PATH "sld_signaltap_sim.vhd"

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL sld_signaltap
add_fileset_file sld_signaltap.v VERILOG PATH "sld_signaltap_sim.v"

#
# parameters
# 

# Device Family
add_parameter device_family string ""
set_parameter_property device_family system_info_type device_family
set_parameter_property device_family VISIBLE false

# Data Port Width
add_parameter sld_data_bits INTEGER 1 "Data Input Port Width \[1..4096\]"
set_parameter_property sld_data_bits DEFAULT_VALUE 1
set_parameter_property sld_data_bits ALLOWED_RANGES { 1:4096 }
set_parameter_property sld_data_bits DISPLAY_NAME "Data Input Port Width \[1..4096\]"
set_parameter_property sld_data_bits UNITS None
set_parameter_property sld_data_bits DESCRIPTION "Integer Data Input Port Width ranging from 1 to 4096"
set_parameter_property sld_data_bits HDL_PARAMETER true

# Sample Depth
add_parameter sld_sample_depth INTEGER  "Sample Depth"
set_parameter_property sld_sample_depth DEFAULT_VALUE 128
set_parameter_property sld_sample_depth DISPLAY_NAME "Sample Depth"
set_parameter_property sld_sample_depth ALLOWED_RANGES { 0:0 64:64 128:128 256:256 512:512 1024:1K 2048:2K 4096:4K 8192:8K 16384:16K 32768:32K 65536:64K 131072:128K}
set_parameter_property sld_sample_depth UNITS None
set_parameter_property sld_sample_depth DESCRIPTION "Integer number of samples to collect"
set_parameter_property sld_sample_depth HDL_PARAMETER true
set_parameter_update_callback sld_sample_depth sample_depth_callback

# GUI RAM TYPE
add_parameter gui_ram_type STRING "AUTO"
set_parameter_property gui_ram_type DEFAULT_VALUE "AUTO"
set_parameter_property gui_ram_type ALLOWED_RANGES { "AUTO" "M20K/M10K/M9K" "MLAB/LUTRAM" "M144K" }
set_parameter_property gui_ram_type DISPLAY_NAME "RAM type"
set_parameter_property gui_ram_type UNITS None
set_parameter_property gui_ram_type DESCRIPTION "RAM type to use for samples collected"
set_parameter_property gui_ram_type HDL_PARAMETER false

# HDL RAM TYPE
add_parameter sld_ram_block_type STRING "AUTO" "RAM type"
set_parameter_property sld_ram_block_type DEFAULT_VALUE "AUTO"
set_parameter_property sld_ram_block_type VISIBLE false
set_parameter_property sld_ram_block_type DESCRIPTION "RAM type to use for samples collected"
set_parameter_property sld_ram_block_type HDL_PARAMETER true
set_parameter_property sld_ram_block_type DERIVED true

# Add Data Display Item
add_display_item "Data" sld_data_bits PARAMETER
add_display_item "Data" sld_sample_depth PARAMETER
add_display_item "Data" gui_ram_type PARAMETER

# GUI Segmented Acquisition
add_parameter gui_use_segmented BOOLEAN false
set_parameter_property gui_use_segmented DEFAULT_VALUE false
set_parameter_property gui_use_segmented DISPLAY_NAME "Segmented"
set_parameter_property gui_use_segmented UNITS None
set_parameter_property gui_use_segmented DESCRIPTION "Select this to enable Segmented Acquisition"
set_parameter_property gui_use_segmented HDL_PARAMETER false

# GUI Number of Segments
add_parameter gui_num_segments STRING "2"
set_parameter_property gui_num_segments DEFAULT_VALUE "2"
set_parameter_property gui_num_segments ALLOWED_RANGES { "2" "4" "8" "16" "32" "64" "128" }
set_parameter_property gui_num_segments DISPLAY_NAME "Number of Segments"
set_parameter_property gui_num_segments UNITS None
set_parameter_property gui_num_segments DESCRIPTION "Number of Segments to use with Segmented Acquisition"
set_parameter_property gui_num_segments HDL_PARAMETER false

# GUI Samples Per Segment
add_parameter gui_sample_per_segment STRING ""
set_parameter_property gui_sample_per_segment DEFAULT_VALUE ""
set_parameter_property gui_sample_per_segment DISPLAY_NAME "Samples per Segment"
set_parameter_property gui_sample_per_segment UNITS None
set_parameter_property gui_sample_per_segment DESCRIPTION "Number of Samples per Segment used with Segmented Acquisition"
set_parameter_property gui_sample_per_segment HDL_PARAMETER false
set_parameter_property gui_sample_per_segment DERIVED true

# HDL Segment Size
add_parameter sld_segment_size Integer 0
set_parameter_property sld_segment_size DEFAULT_VALUE 0
set_parameter_property sld_segment_size VISIBLE false
set_parameter_property sld_segment_size DESCRIPTION "Segment Sample Size"
set_parameter_property sld_segment_size HDL_PARAMETER true
set_parameter_property sld_segment_size DERIVED true

# Add Segment Display Item
add_display_item "Segmented Acquisition" gui_use_segmented PARAMETER
add_display_item "Segmented Acquisition" gui_num_segments PARAMETER
add_display_item "Segmented Acquisition" gui_sample_per_segment PARAMETER

# GUI Storage Qualifier
add_parameter gui_sq STRING "Continuous" "Storage Qualifier"
set_parameter_property gui_sq DEFAULT_VALUE "Continuous"
set_parameter_property gui_sq ALLOWED_RANGES { "Continuous" "Input port" }
set_parameter_property gui_sq DISPLAY_NAME "Storage Qualifier"
set_parameter_property gui_sq UNITS None
set_parameter_property gui_sq DESCRIPTION "Storage Qualifier setting to use with Signal Tap"
set_parameter_property gui_sq HDL_PARAMETER false

# HDL Storage Qualifier
add_parameter sld_storage_qualifier_mode STRING "OFF"
set_parameter_property sld_storage_qualifier_mode DEFAULT_VALUE "OFF"
set_parameter_property sld_storage_qualifier_mode VISIBLE false
set_parameter_property sld_storage_qualifier_mode DESCRIPTION "Storage Qualifier setting to use with Signal Tap"
set_parameter_property sld_storage_qualifier_mode HDL_PARAMETER true
set_parameter_property sld_storage_qualifier_mode DERIVED true

# Record Data Discontinuities
add_parameter sld_storage_qualifier_gap_record INTEGER 0
set_parameter_property sld_storage_qualifier_gap_record DEFAULT_VALUE 0
set_parameter_property sld_storage_qualifier_gap_record DISPLAY_HINT "boolean"
set_parameter_property sld_storage_qualifier_gap_record DISPLAY_NAME "Record data discontinuities"
set_parameter_property sld_storage_qualifier_gap_record UNITS None
set_parameter_property sld_storage_qualifier_gap_record DESCRIPTION "Enable to Record data discontinuities when using Storage Qualified acquisition"
set_parameter_property sld_storage_qualifier_gap_record HDL_PARAMETER true

# Add Storage Qualifier Display Item
add_display_item "Storage Qualifier" gui_sq PARAMETER
add_display_item "Storage Qualifier" sld_storage_qualifier_gap_record PARAMETER

# Trigger Port Width
add_parameter sld_trigger_bits INTEGER 1 "Trigger Input Port Width \[1..4096\]"
set_parameter_property sld_trigger_bits DEFAULT_VALUE 1
set_parameter_property sld_trigger_bits ALLOWED_RANGES { 1:4096 }
set_parameter_property sld_trigger_bits DISPLAY_NAME "Trigger Input Port Width \[1..4096\]"
set_parameter_property sld_trigger_bits UNITS None
set_parameter_property sld_trigger_bits DESCRIPTION "Integer Trigger Input Port Width ranging from 1 to 4096"
set_parameter_property sld_trigger_bits HDL_PARAMETER true

# Trigger Conditions
add_parameter sld_trigger_level INTEGER 1 "Trigger Conditions"
set_parameter_property sld_trigger_level DEFAULT_VALUE 1
set_parameter_property sld_trigger_level ALLOWED_RANGES { 1 2 3 4 5 6 7 8 9 10 }
set_parameter_property sld_trigger_level DISPLAY_NAME "Trigger Conditions"
set_parameter_property sld_trigger_level UNITS None
set_parameter_property sld_trigger_level DESCRIPTION "Number of Trigger Conditions or \"Levels\" to use"
set_parameter_property sld_trigger_level HDL_PARAMETER true

# Trigger In
add_parameter sld_trigger_in_enabled INTEGER 0 "Trigger In"
set_parameter_property sld_trigger_in_enabled DEFAULT_VALUE 0
set_parameter_property sld_trigger_in_enabled DISPLAY_HINT "boolean"
set_parameter_property sld_trigger_in_enabled DISPLAY_NAME "Trigger In"
set_parameter_property sld_trigger_in_enabled UNITS None
set_parameter_property sld_trigger_in_enabled DESCRIPTION "Enable the Trigger In feature and create a port for it"
set_parameter_property sld_trigger_in_enabled HDL_PARAMETER true

# Trigger Out
add_parameter gui_trigger_out_enabled BOOLEAN false "Trigger Out"
set_parameter_property gui_trigger_out_enabled DEFAULT_VALUE false
set_parameter_property gui_trigger_out_enabled DISPLAY_NAME "Trigger Out"
set_parameter_property gui_trigger_out_enabled UNITS None
set_parameter_property gui_trigger_out_enabled DESCRIPTION "Enable the Trigger Out feature and create a port for it"
set_parameter_property gui_trigger_out_enabled HDL_PARAMETER false

# Add Trigger Display Item
add_display_item "Trigger" adv_hint_text TEXT "<html>If you require the Advanced Triggers feature, please create an instance in the Signal Tap Logic Analyzer tool.<br>"
add_display_item "Trigger" sld_trigger_bits PARAMETER
add_display_item "Trigger" sld_trigger_level PARAMETER
add_display_item "Trigger" sld_trigger_in_enabled PARAMETER
add_display_item "Trigger" gui_trigger_out_enabled PARAMETER

# Add Advanced Trigger Parameter
add_parameter sld_enable_advanced_trigger INTEGER 0
set_parameter_property sld_enable_advanced_trigger DEFAULT_VALUE 0
set_parameter_property sld_enable_advanced_trigger DISPLAY_HINT "boolean"
set_parameter_property sld_enable_advanced_trigger VISIBLE false
set_parameter_property sld_enable_advanced_trigger UNITS None
set_parameter_property sld_enable_advanced_trigger DESCRIPTION "Parameter to disable Advanced Triggers"
set_parameter_property sld_enable_advanced_trigger HDL_PARAMETER true

# Add Trigger Level Pipeline Parameter
add_parameter sld_trigger_level_pipeline INTEGER 1
set_parameter_property sld_trigger_level_pipeline DEFAULT_VALUE 1
set_parameter_property sld_trigger_level_pipeline VISIBLE false
set_parameter_property sld_trigger_level_pipeline UNITS None
set_parameter_property sld_trigger_level_pipeline DESCRIPTION "Parameter to specify trigger pipelining"
set_parameter_property sld_trigger_level_pipeline HDL_PARAMETER true

# Add Pipeline Factor
add_parameter sld_pipeline_factor INTEGER 0 "Pipeline Factor"
set_parameter_property sld_pipeline_factor DEFAULT_VALUE 0
set_parameter_property sld_pipeline_factor ALLOWED_RANGES {0 1 2 3 4 5 }
set_parameter_property sld_pipeline_factor DISPLAY_NAME "Pipeline Factor"
set_parameter_property sld_pipeline_factor UNITS None
set_parameter_property sld_pipeline_factor DESCRIPTION "Level of Pipelining used to potentially increase Fmax"
set_parameter_update_callback sld_pipeline_factor pipeline_factor_callback

# Add Pipeline Display Item
add_display_item "Pipelining" adv_hint_text TEXT "<html>Level of pipelining added to potentially increase Fmax<br>"
add_display_item "Pipelining" sld_pipeline_factor PARAMETER

# Add Trigger Pipeline Parameter
add_parameter sld_trigger_pipeline INTEGER 0 
set_parameter_property sld_trigger_pipeline DEFAULT_VALUE 0
set_parameter_property sld_trigger_pipeline VISIBLE false
set_parameter_property sld_trigger_pipeline UNITS None
set_parameter_property sld_trigger_pipeline DESCRIPTION "Parameter to specify trigger-level pipelining"
set_parameter_property sld_trigger_pipeline HDL_PARAMETER true

# Add RAM Pipeline Parameter
add_parameter sld_ram_pipeline INTEGER 0 
set_parameter_property sld_ram_pipeline DEFAULT_VALUE 0
set_parameter_property sld_ram_pipeline VISIBLE false
set_parameter_property sld_ram_pipeline UNITS None
set_parameter_property sld_ram_pipeline DESCRIPTION "Parameter to specify RAM pipelining"
set_parameter_property sld_ram_pipeline HDL_PARAMETER true

# Add Counter Pipeline Parameter
add_parameter sld_counter_pipeline INTEGER 0 
set_parameter_property sld_counter_pipeline DEFAULT_VALUE 0
set_parameter_property sld_counter_pipeline VISIBLE false
set_parameter_property sld_counter_pipeline UNITS None
set_parameter_property sld_counter_pipeline DESCRIPTION "Parameter to specify buffer manager pipelining"
set_parameter_property sld_counter_pipeline HDL_PARAMETER true

# Add SLD NODE INFO Parameter
add_parameter sld_node_info INTEGER 806383104
set_parameter_property sld_node_info DEFAULT_VALUE 806383104
set_parameter_property sld_node_info VISIBLE false
set_parameter_property sld_node_info UNITS None
set_parameter_property sld_node_info DESCRIPTION "Parameter to specify the SLD node type"
set_parameter_property sld_node_info HDL_PARAMETER true

# Add INCREMENTAL ROUTING Parameter -- we need the CRC ROM to be used for STP in the HDL
add_parameter sld_incremental_routing INTEGER 0
set_parameter_property sld_incremental_routing DEFAULT_VALUE 0
set_parameter_property sld_incremental_routing VISIBLE false
set_parameter_property sld_incremental_routing UNITS None
set_parameter_property sld_incremental_routing DESCRIPTION "Parameter to specify whether to use the internal CRC ROM (0), or the CRC input port (1)"
set_parameter_property sld_incremental_routing HDL_PARAMETER true

# Add CRC bits Parameter
add_parameter sld_node_crc_bits INTEGER 32
set_parameter_property sld_node_crc_bits DEFAULT_VALUE 32
set_parameter_property sld_node_crc_bits VISIBLE false
set_parameter_property sld_node_crc_bits UNITS None
set_parameter_property sld_node_crc_bits DESCRIPTION "Parameter to specify the number of CRC bits"
set_parameter_property sld_node_crc_bits HDL_PARAMETER true

# Add SLD CRC HI Parameter
add_parameter sld_node_crc_hiword INTEGER 12345
set_parameter_property sld_node_crc_hiword DEFAULT_VALUE 12345
set_parameter_property sld_node_crc_hiword VISIBLE false
set_parameter_property sld_node_crc_hiword UNITS None
set_parameter_property sld_node_crc_hiword DESCRIPTION "Parameter to specify the CRC upper 16 bits"
set_parameter_property sld_node_crc_hiword HDL_PARAMETER true
set_parameter_property sld_node_crc_hiword DERIVED true
set_parameter_property sld_node_crc_hiword AFFECTS_GENERATION false
set_parameter_property sld_node_crc_hiword AFFECTS_ELABORATION false
set_parameter_property sld_node_crc_hiword AFFECTS_VALIDATION false

# Add SLD CRC LO Parameter
add_parameter sld_node_crc_loword INTEGER 19899
set_parameter_property sld_node_crc_loword DEFAULT_VALUE 19899
set_parameter_property sld_node_crc_loword VISIBLE false
set_parameter_property sld_node_crc_loword UNITS None
set_parameter_property sld_node_crc_loword DESCRIPTION "Parameter to specify the CRC lower 16 bits"
set_parameter_property sld_node_crc_loword HDL_PARAMETER true
set_parameter_property sld_node_crc_loword DERIVED true
set_parameter_property sld_node_crc_loword AFFECTS_GENERATION false
set_parameter_property sld_node_crc_loword AFFECTS_ELABORATION false
set_parameter_property sld_node_crc_loword AFFECTS_VALIDATION false

proc get_segment_list { sample_depth } {
	set ret_val { }
	set cur_num 2
	
	while { $cur_num <= $sample_depth } {
		lappend ret_val $cur_num
		set cur_num [ expr { $cur_num*2 } ]
	}
	
	return $ret_val
}

proc sample_depth_callback { param } {
	set sample_depth [get_parameter_value sld_sample_depth]
	set new_num_segments [get_parameter_value gui_num_segments]
	
	if { $sample_depth > 0 } {
		while { $new_num_segments > $sample_depth } {
			set new_num_segments [expr {$new_num_segments/2}]
		}
	} else {
		set new_num_segments 2
	}
	
	set_parameter_value gui_num_segments $new_num_segments
}

proc pipeline_factor_callback { param } {
	set pipeline_factor [get_parameter_value sld_pipeline_factor]
	
	if { $pipeline_factor > 0 } {
		set_parameter_value sld_trigger_pipeline 2
		set_parameter_value sld_ram_pipeline $pipeline_factor
		set_parameter_value sld_counter_pipeline 1
	} else {
		set_parameter_value sld_trigger_pipeline 0
		set_parameter_value sld_ram_pipeline 0
		set_parameter_value sld_counter_pipeline 0
	}
	
}

proc generate_random_sixteen_bit_num { } {
	return [expr {int(rand()*65535)}]
}

proc do_elaboration {} {
	# State variables
	set sample_depth [get_parameter_value sld_sample_depth]
	set use_sq [expr {[string equal [get_parameter_value gui_sq] "Input port"] && ($sample_depth > 0)}]
	set use_segment [expr {[get_parameter_value gui_use_segmented] && ($sample_depth > 0)}]
	set num_segments [get_parameter_value gui_num_segments]
	set samples_per_segment [expr {$sample_depth/$num_segments}]
	
	### GUI Controls ###
	set_parameter_property gui_num_segments ENABLED [expr {$use_segment && (!$use_sq)}]
	set_parameter_property gui_sample_per_segment ENABLED [expr {$use_segment && (!$use_sq)}]
	set_parameter_property gui_use_segmented ENABLED [expr {($sample_depth > 0) && (!$use_sq)}]
	set_parameter_property gui_num_segments ALLOWED_RANGES [get_segment_list $sample_depth]
	
	# No storage qualifier with segmented acquisition
	set_parameter_property gui_sq ENABLED [expr {(!$use_segment) && ($sample_depth > 0)}]
	set_parameter_property sld_storage_qualifier_gap_record ENABLED [expr {(!$use_segment) && ($use_sq)}]
	
	
	### Derived Parameters ###	
	if {$use_segment} {
		set_parameter_value gui_sample_per_segment $samples_per_segment
	} else {
		set_parameter_value gui_sample_per_segment ""
	}
	
	# Set Random CRC values
	set_parameter_value sld_node_crc_loword [generate_random_sixteen_bit_num]
	set_parameter_value sld_node_crc_hiword [generate_random_sixteen_bit_num]
		
	# sld_ram_block_type
	set selected_ram_string [get_parameter_value gui_ram_type]
	if { [string equal $selected_ram_string "AUTO"] } {
		set_parameter_value sld_ram_block_type "AUTO"
	} elseif { [string equal $selected_ram_string "M20K/M10K/M9K"] } {
		set_parameter_value sld_ram_block_type "M9K"
	} elseif { [string equal $selected_ram_string "MLAB/LUTRAM"] } {
		set_parameter_value sld_ram_block_type "LUTRAM"
	} elseif { [string equal $selected_ram_string "M144K"] } {
		set_parameter_value sld_ram_block_type "M144K"
	}

	# Tap Interface
	add_interface tap conduit end
	if {[get_parameter_property gui_use_segmented ENABLED] && [get_parameter_value gui_use_segmented]} {
		set_parameter_value sld_segment_size $samples_per_segment
		set_parameter_property sld_segment_size HDL_PARAMETER true
	} else {
		set_parameter_property sld_segment_size HDL_PARAMETER false
	}
	add_interface_port tap acq_data_in acq_data_in Input [get_parameter_value sld_data_bits]
	add_interface_port tap acq_trigger_in acq_trigger_in Input [get_parameter_value sld_trigger_bits]
	set_port_property acq_data_in VHDL_TYPE std_logic_vector
	set_port_property acq_trigger_in VHDL_TYPE std_logic_vector
	
	# Trigger In Interface
	if {[get_parameter_value sld_trigger_in_enabled]} {
		add_interface trigger_in conduit end
		add_interface_port trigger_in trigger_in trigger_in Input 1
	}
	# Trigger Out Interface
	if {[get_parameter_value gui_trigger_out_enabled]} {
		add_interface trigger_out conduit end
		add_interface_port trigger_out trigger_out trigger_out Output 1
	}
	
	# Storage Enable Interface
	if {[get_parameter_property gui_sq ENABLED] && $use_sq} {
		add_interface storage_qualifier conduit end
		add_interface_port storage_qualifier storage_enable storage_enable Input 1
		set_parameter_value sld_storage_qualifier_mode "PORT"
		set_parameter_property sld_storage_qualifier_gap_record HDL_PARAMETER true
	} else {
		set_parameter_value sld_storage_qualifier_mode "OFF"
		set_parameter_property sld_storage_qualifier_gap_record HDL_PARAMETER false
	}

	
	# Acquisition Clock Interface
	add_interface acq_clk clock Input
	set_interface_property acq_clk ENABLED true
	add_interface_port acq_clk acq_clk clk Input 1
	set_interface_property tap associatedClock acq_clk
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1410385117325/mwh1410384469524
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
