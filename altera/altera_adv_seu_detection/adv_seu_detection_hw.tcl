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


set alt_mem_if_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/alt_mem_if/alt_mem_if_tcl_packages"
if {[lsearch -exact $auto_path $alt_mem_if_tcl_libs_dir] == -1} {
	lappend auto_path $alt_mem_if_tcl_libs_dir
}


package require -exact qsys 12.0

package require alt_mem_if::util::messaging
package require alt_mem_if::util::iptclgen
package require alt_mem_if::util::hwtcl_utils

namespace import ::alt_mem_if::util::messaging::*

set_module_property NAME altera_adv_seu_detection
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Advanced SEU Detection Intel FPGA IP"
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Altera Advanced SEU Detection provides features on error detection cyclical redundancy check \
									(EDCRC) and mitigating the impact of single event upset (SEU) on configuration RAM (CRAM) \
									array."
add_documentation_link "User Guide" http://www.altera.com/literature/ug/ug_altadvseu.pdf

set supported_device_families_list {"Stratix IV" "Arria II GZ" "Arria II GX" "Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "Arria 10"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list

add_fileset sim_vhdl SIM_VHDL generate_vhdl_sim
add_fileset sim_verilog SIM_VERILOG generate_verilog_sim
add_fileset quartus_synth QUARTUS_SYNTH generate_synth

proc generate_verilog_fileset {name sim} {

	if { [get_parameter_value use_memory_interface] } {

        set family [get_parameter_value device_family]
    
        if { [expr {$family == "Arria 10"}] } {
    		generate_fileset_int_proc2 $name $sim
        } else {	
    		generate_fileset_int_proc $name $sim
        }

	} else {
		generate_fileset_ext_proc $name $sim
	}
}

proc generate_fileset_int_proc2 {name sim} {
	set file_source_list {"altera_adv_seu_detection_proc2_int.v"}

	foreach file_name $file_source_list {
		send_message info "Adding $file_name"
		add_encrypt_file  $file_name  $file_name  $sim
	}
}

proc generate_fileset_int_proc {name sim} {
	set file_source_list {"altera_adv_seu_detection_proc_int.v"}

	set ifdef_params_list [list]
	if { [is_ht_supported] } {
		lappend ifdef_params_list "REGION_TAG"
	}	 

	foreach file_name $file_source_list {
		set generated_file [alt_mem_if::util::iptclgen::generate_outfile_name $file_name $ifdef_params_list]
		send_message info "Adding $generated_file as $file_name"
		add_encrypt_file  $file_name  $generated_file  $sim
	}
}

proc generate_fileset_ext_proc {name sim} {
	set file_source_list {"altera_adv_seu_detection_proc_ext.v"}

	foreach file_name $file_source_list {
		send_message info "Adding $file_name"
		add_encrypt_file  $file_name  $file_name  $sim
	}
}

proc add_encrypt_file {file_name source_file sim} {
	if { $sim } {
		if { 1 } {
			add_fileset_file mentor/${file_name}  [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 1 1]  PATH  "mentor/${source_file}"   {MENTOR_SPECIFIC}
		}
		if { 1 } {
			add_fileset_file synopsys/${file_name}  [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 1 1]  PATH  "synopsys/${source_file}"   {SYNOPSYS_SPECIFIC}
		}
		if { 1 } {
			add_fileset_file cadence/${file_name}  [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 1 1]  PATH  "cadence/${source_file}"   {CADENCE_SPECIFIC}
		}
		if { 1 } {
			add_fileset_file aldec/${file_name}  [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 1 1]  PATH  "aldec/${source_file}"   {ALDEC_SPECIFIC}
		}
	} else {
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 1 0] PATH $source_file
	}
}

proc generate_vhdl_sim {name} {
	_dprint 1 "Preparing to generate VHDL simulation fileset for $name"

	generate_verilog_fileset $name true
}

proc generate_verilog_sim {name} {
	_dprint 1 "Preparing to generate verilog simulation fileset for $name"

	generate_verilog_fileset $name true
}

proc generate_synth {name} {
	_dprint 1 "Preparing to generate verilog synthesis fileset for $name"

	generate_verilog_fileset $name false
}


add_parameter device_family STRING
set_parameter_property device_family VISIBLE false
set_parameter_property device_family SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property device_family ALLOWED_RANGES $supported_device_families_list
set_parameter_property device_family AFFECTS_GENERATION true

add_parameter emr_reg_width Integer
set_parameter_property emr_reg_width VISIBLE false
set_parameter_property emr_reg_width AFFECTS_GENERATION true
set_parameter_property emr_reg_width HDL_PARAMETER true
set_parameter_property emr_reg_width DERIVED true

add_parameter emr_data_width Integer
set_parameter_property emr_data_width VISIBLE false
set_parameter_property emr_data_width AFFECTS_GENERATION true
set_parameter_property emr_data_width DERIVED true
set_parameter_property emr_data_width HDL_PARAMETER true


add_parameter cache_depth Integer
set_parameter_property cache_depth DEFAULT_VALUE 8
set_parameter_property cache_depth ALLOWED_RANGES {2 4 8 16 32 64}
set_parameter_property cache_depth DISPLAY_NAME "CRC error cache depth"
set_parameter_property cache_depth HDL_PARAMETER true
set_parameter_property cache_depth DESCRIPTION "Specifies how many non-critical CRC error can be ignored."

add_parameter regions_mask_width Integer 1
set_parameter_property regions_mask_width DISPLAY_NAME "Largest ASD region ID used"
set_parameter_property regions_mask_width ALLOWED_RANGES {0:255}
set_parameter_property regions_mask_width AFFECTS_GENERATION true
set_parameter_property regions_mask_width DESCRIPTION "Specifies the largest ASD region ID used in design. Used to specify width of the SEU affected regions mask."

add_parameter enable_virtual_jtag Integer 0
set_parameter_property enable_virtual_jtag DISPLAY_HINT BOOLEAN
set_parameter_property enable_virtual_jtag VISIBLE false
set_parameter_property enable_virtual_jtag DISPLAY_NAME "Enable usage of ASD cache Probe interfaces"
set_parameter_property enable_virtual_jtag HDL_PARAMETER true
set_parameter_property enable_virtual_jtag DESCRIPTION "Enable usage of ASD cache Probe interfaces"

add_display_item "" "Sensitivity Data Access" GROUP 
add_display_item "Sensitivity Data Access" use_memory_interface PARAMETER
add_display_item "Sensitivity Data Access" mem_addr_width PARAMETER
add_display_item "Sensitivity Data Access" start_address PARAMETER

add_parameter use_memory_interface boolean true
set_parameter_property use_memory_interface DISPLAY_NAME "Use on-chip sensitivity processing"
set_parameter_property use_memory_interface AFFECTS_GENERATION true
set_parameter_property use_memory_interface AFFECTS_ELABORATION true
set_parameter_property use_memory_interface DESCRIPTION "Enables using external memory interface to access Sensitivity Data and perform SEU location lookup by the FPGA."

add_parameter mem_addr_width Integer
set_parameter_property mem_addr_width DEFAULT_VALUE 32
set_parameter_property mem_addr_width AFFECTS_GENERATION true
set_parameter_property mem_addr_width DISPLAY_NAME "Memory interface address width"
set_parameter_property mem_addr_width UNITS Bits
set_parameter_property mem_addr_width AFFECTS_GENERATION true
set_parameter_property mem_addr_width DESCRIPTION "Specifies width of the address bus connected to the external memory interface."

add_parameter start_address Integer
set_parameter_property start_address DEFAULT_VALUE 0
set_parameter_property start_address AFFECTS_GENERATION true
set_parameter_property start_address DISPLAY_NAME "Sensitivity Data start address"
set_parameter_property start_address AFFECTS_GENERATION true
set_parameter_property start_address DISPLAY_HINT hexadecimal
set_parameter_property start_address DESCRIPTION "Specifies a constant offset to be added to all addresses generated by the external memory interface."

proc get_cache_fill_level_width {} {
    set cache_depth [get_parameter_value cache_depth]
	set width 0
	while {$cache_depth>0} {
		incr width
		set cache_depth [expr {$cache_depth >> 1}];
	}
	
	return $width;
}	

proc is_ht_supported {} {

    set family [get_parameter_value device_family]
    
    if { [expr {$family == "Stratix IV"}] ||
		 [expr {$family == "Arria II GZ"}] ||
		 [expr {$family == "Arria II GX"}]
    } {
	 return false
    }	
    
    return true
}

proc crc_parameter_validation {} {
    set family [get_parameter_value device_family]
    
    if { [expr {$family == "Stratix IV"}] ||
		 [expr {$family == "Arria II GZ"}] ||
		 [expr {$family == "Arria II GX"}]
    } {
	    set alt_adv_seu_detection_crc_data_width 30
	    set alt_adv_seu_detection_crc_reg_width 46
    } elseif { [expr {$family == "Stratix V"}] ||
		       [expr {$family == "Arria V GZ"}] ||
		       [expr {$family == "Arria V"}] ||
		       [expr {$family == "Cyclone V"}]
    } {
    	set alt_adv_seu_detection_crc_data_width 35
	    set alt_adv_seu_detection_crc_reg_width 67
    } else {	
    	set alt_adv_seu_detection_crc_data_width 78
	    set alt_adv_seu_detection_crc_reg_width 119
    }

	set_parameter_value emr_data_width $alt_adv_seu_detection_crc_data_width
	set_parameter_value emr_reg_width $alt_adv_seu_detection_crc_reg_width
}

set_module_property ELABORATION_CALLBACK core_elaborate

proc core_elaborate {} {
	_dprint 1 "Running IP Elaboration"
	
	crc_parameter_validation

	set use_ext_memory [get_parameter_value use_memory_interface]
	set_parameter_property mem_addr_width VISIBLE $use_ext_memory
	set_parameter_property mem_addr_width HDL_PARAMETER $use_ext_memory
	set_parameter_property start_address VISIBLE $use_ext_memory
	set_parameter_property start_address HDL_PARAMETER $use_ext_memory

	if { $use_ext_memory } {
		set_parameter_property regions_mask_width VISIBLE [is_ht_supported]
	} else {
		set_parameter_property regions_mask_width VISIBLE false
	}

	add_interface avst_emr_snk avalon_streaming end
	set_interface_property avst_emr_snk associatedClock clock
	set_interface_property avst_emr_snk associatedReset reset
	set_interface_property avst_emr_snk dataBitsPerSymbol [get_parameter_value emr_reg_width]
	set_interface_property avst_emr_snk errorDescriptor ""
	set_interface_property avst_emr_snk firstSymbolInHighOrderBits true
	set_interface_property avst_emr_snk maxChannel 0
	set_interface_property avst_emr_snk readyLatency 0

	add_interface_port avst_emr_snk emr data Input [get_parameter_value emr_reg_width]
	add_interface_port avst_emr_snk emr_valid valid Input 1
	add_interface_port avst_emr_snk emr_error error Input 1

	set qip_assignments {"set_instance_assignment -name MESSAGE_DISABLE 332060 -entity asd_cache"}
	
	if { $use_ext_memory } {
		set_parameter_property regions_mask_width HDL_PARAMETER [is_ht_supported]

		set alt_adv_seu_detection_mem_data_width 32
		
		set top_level_module_name "altera_adv_seu_detection_proc_int"
		set_fileset_property sim_verilog TOP_LEVEL $top_level_module_name
		set_fileset_property SIM_VHDL TOP_LEVEL $top_level_module_name
		set_fileset_property quartus_synth TOP_LEVEL $top_level_module_name
		

		add_interface asd_sp_master avalon start
		set_interface_property asd_sp_master addressUnits SYMBOLS
		set_interface_property asd_sp_master associatedClock clock
		set_interface_property asd_sp_master associatedReset reset
		set_interface_property asd_sp_master bitsPerSymbol 8
		set_interface_property asd_sp_master burstOnBurstBoundariesOnly false
		set_interface_property asd_sp_master burstcountUnits WORDS
		set_interface_property asd_sp_master doStreamReads false
		set_interface_property asd_sp_master doStreamWrites false
		set_interface_property asd_sp_master holdTime 0
		set_interface_property asd_sp_master linewrapBursts false
		set_interface_property asd_sp_master maximumPendingReadTransactions 0
		set_interface_property asd_sp_master readLatency 0
		set_interface_property asd_sp_master readWaitTime 1
		set_interface_property asd_sp_master setupTime 0
		set_interface_property asd_sp_master timingUnits Cycles

		add_interface_port asd_sp_master mem_addr address Output mem_addr_width
		add_interface_port asd_sp_master mem_rd read Output 1
		add_interface_port asd_sp_master mem_bytesel byteenable Output 4
		add_interface_port asd_sp_master mem_wait waitrequest Input 1
		add_interface_port asd_sp_master mem_data readdata Input 32
		add_interface_port asd_sp_master mem_datavalid readdatavalid Input 1
		set_interface_assignment asd_sp_master "ui.blockdiagram.direction" OUTPUT

		add_interface errors conduit end
		set_interface_property errors associatedClock clock
		set_interface_property errors associatedReset reset

		add_interface_port errors critical_error critical_error Output 1
		add_interface_port errors noncritical_error noncritical_error Output 1
		if { [is_ht_supported] } {
			add_interface_port errors regions_report regions_report output [get_parameter_value regions_mask_width]
		}
		add_interface_port errors critical_clear critical_clear Input 1
		add_interface_port errors busy busy Output 1
		set_interface_assignment errors "ui.blockdiagram.direction" OUTPUT

		append qip_assignments " " {"set_instance_assignment -name MESSAGE_DISABLE 13410 -to mem_addr[0]"}
		append qip_assignments " " {"set_instance_assignment -name MESSAGE_DISABLE 13410 -to mem_addr[1]"}

		append qip_assignments " " {"set_instance_assignment -name MESSAGE_DISABLE 16068 -entity asd_core_controller"}
		append qip_assignments " " {"set_instance_assignment -name MESSAGE_DISABLE 16069 -entity asd_core_controller"}
	} else {
		set_parameter_property regions_mask_width HDL_PARAMETER false

		set top_level_module_name "altera_adv_seu_detection_proc_ext"
		set_fileset_property sim_verilog TOP_LEVEL $top_level_module_name
		set_fileset_property SIM_VHDL TOP_LEVEL $top_level_module_name
		set_fileset_property quartus_synth TOP_LEVEL $top_level_module_name


		add_interface avst_cache_src avalon_streaming start
		set_interface_property avst_cache_src associatedClock clock
		set_interface_property avst_cache_src associatedReset reset
		set_interface_property avst_cache_src dataBitsPerSymbol [get_parameter_value emr_data_width]
		set_interface_property avst_cache_src errorDescriptor "cache_overflow"
		set_interface_property avst_cache_src firstSymbolInHighOrderBits true
		set_interface_property avst_cache_src maxChannel 0
		set_interface_property avst_cache_src readyLatency 0
	
		add_interface_port avst_cache_src cache_data data Output [get_parameter_value emr_data_width]
		add_interface_port avst_cache_src cache_valid valid Output 1
		add_interface_port avst_cache_src cache_ready ready Input 1
		add_interface_port avst_cache_src cache_error error Output 1
		set_interface_assignment avst_cache_src "ui.blockdiagram.direction" OUTPUT

		add_interface cache_fill_level conduit end
		set_interface_property cache_fill_level associatedClock clock
		add_interface_port cache_fill_level cache_fill_level cache_fill_level output [get_cache_fill_level_width]
		set_interface_assignment cache_fill_level "ui.blockdiagram.direction" OUTPUT

		add_interface errors conduit end
		set_interface_property errors associatedClock clock
		set_interface_property errors associatedReset reset
		add_interface_port errors critical_error critical_error Output 1
		add_interface_port errors critical_clear critical_clear Input 1
		set_interface_assignment errors "ui.blockdiagram.direction" OUTPUT
	}
	
	set_qip_strings $qip_assignments
}

add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1

add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
                                                  
add_interface_port reset reset reset Input 1

add_interface cache_comparison_off conduit end
set_interface_property cache_comparison_off associatedClock clock
set_interface_property cache_comparison_off associatedReset reset
set_interface_property cache_comparison_off ENABLED true

add_interface_port cache_comparison_off cache_comparison_off cache_comparison_off Input 1









add_documentation_link "User Guide" "https://documentation.altera.com/#/link/sss1424671189302/sss1424671317650"
add_documentation_link "Release Notes" "https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408"
