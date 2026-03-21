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


package require -exact qsys 16.0

set alt_mem_if_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/alt_mem_if/alt_mem_if_tcl_packages"
if {[lsearch -exact $auto_path $alt_mem_if_tcl_libs_dir] == -1} {
    lappend auto_path $alt_mem_if_tcl_libs_dir
}

package require alt_mem_if::util::messaging
package require alt_mem_if::util::iptclgen
package require alt_mem_if::util::hwtcl_utils

namespace import ::alt_mem_if::util::messaging::*

set_module_property NAME altera_crcerror_verify2
set_module_property VERSION 18.1
set_module_property internal false
set_module_property HIDE_FROM_QSYS true
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "CRC Error Verify Intel FPGA IP"
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property DESCRIPTION "Altera CRC Error Verify provides CRC error verification module for Stratix IV and Arria II."
set_module_property DATASHEET_URL ""

set_module_property EDITABLE true

set supported_device_families_list {"Stratix IV" "Arria II GZ" "Arria II GX"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list

proc check_sim_ini {}   {
    if [get_quartus_ini enable_int_sim ENABLED] {
        return true
    }
    
    return false
}

set_module_property ELABORATION_CALLBACK elaboration_callback

add_fileset sim_vhdl SIM_VHDL generate_vhdl_sim
add_fileset sim_verilog SIM_VERILOG generate_verilog_sim
add_fileset quartus_synth QUARTUS_SYNTH generate_synth

set top_level_module_name "altera_crcerror_verify_top"
set_fileset_property SIM_VHDL TOP_LEVEL $top_level_module_name
set_fileset_property sim_verilog TOP_LEVEL $top_level_module_name
set_fileset_property quartus_synth TOP_LEVEL $top_level_module_name

add_parameter device_family STRING
set_parameter_property device_family VISIBLE false
set_parameter_property device_family ALLOWED_RANGES $supported_device_families_list
set_parameter_property device_family SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property device_family AFFECTS_GENERATION true

add_parameter part_name STRING "UNKNOWN"
set_parameter_property part_name VISIBLE false
set_parameter_property part_name SYSTEM_INFO {DEVICE}

add_parameter dev_category STRING
set_parameter_property dev_category VISIBLE false
set_parameter_property dev_category AFFECTS_GENERATION true
set_parameter_property dev_category DERIVED true

add_parameter ed_cycle_time_div256 Integer
set_parameter_property ed_cycle_time_div256 DEFAULT_VALUE 160
set_parameter_property ed_cycle_time_div256 VISIBLE false
set_parameter_property ed_cycle_time_div256 ALLOWED_RANGES {21 31 35 60 63 83 111 160}
set_parameter_property ed_cycle_time_div256 AFFECTS_GENERATION true
set_parameter_property ed_cycle_time_div256 HDL_PARAMETER true
set_parameter_property ed_cycle_time_div256 DERIVED true

add_parameter in_clk_frequency Integer
set_parameter_property in_clk_frequency DEFAULT_VALUE 50
set_parameter_property in_clk_frequency ALLOWED_RANGES {10:50}
set_parameter_property in_clk_frequency DISPLAY_NAME "Input clock frequency"
set_parameter_property in_clk_frequency UNITS Megahertz
set_parameter_property in_clk_frequency AFFECTS_GENERATION true
set_parameter_property in_clk_frequency HDL_PARAMETER true
set_parameter_property in_clk_frequency DESCRIPTION "Specifies the frequency of CRC Error Verification block input clock, must be withing 10-50 MHz range."

add_parameter error_check_frequency_divisor Integer
set_parameter_property error_check_frequency_divisor DEFAULT_VALUE 2
set_parameter_property error_check_frequency_divisor ALLOWED_RANGES {2 4 8 16 32 64 128 256}
set_parameter_property error_check_frequency_divisor DISPLAY_NAME "CRC error check clock divisor"
set_parameter_property error_check_frequency_divisor UNITS None
set_parameter_property error_check_frequency_divisor AFFECTS_GENERATION true
set_parameter_property error_check_frequency_divisor HDL_PARAMETER true
set_parameter_property error_check_frequency_divisor DESCRIPTION "Specifies the the divide value of the internal clock, which determines the frequency of the CRC. Should match the Quartus Prime CRC settings."

add_display_item "" "Options" GROUP 
add_display_item "Options" en_debug_ports PARAMETER
add_display_item "Options" change_pin_assignment PARAMETER
add_display_item "Options" crc_error_pin_name PARAMETER
add_display_item "Options" crc_error_pin_location PARAMETER

add_parameter en_debug_ports boolean false
set_parameter_property en_debug_ports DISPLAY_NAME "Enable EMR debug ports"
set_parameter_property en_debug_ports AFFECTS_GENERATION true
set_parameter_property en_debug_ports DESCRIPTION "Enable EMR debug ports to show raw EMR data"

add_parameter change_pin_assignment boolean true
set_parameter_property change_pin_assignment DISPLAY_NAME "Generate CRC_ERROR pin assignment script"
set_parameter_property change_pin_assignment AFFECTS_GENERATION true
set_parameter_property change_pin_assignment DESCRIPTION "Generates manually run script to replace original CRCERROR pin connection with EDCRC Error Verification block crc_error pin."

add_parameter crc_error_pin_name STRING ""
set_parameter_property crc_error_pin_name DISPLAY_NAME "Top level crc_error signal pin name"
set_parameter_property crc_error_pin_name UNITS None
set_parameter_property crc_error_pin_name AFFECTS_GENERATION true
set_parameter_property crc_error_pin_name DESCRIPTION "Specify here the name of top level pin that will be connected to crc_error signal, for example crc_error_final."

add_parameter crc_error_pin_location STRING ""
set_parameter_property crc_error_pin_location DISPLAY_NAME "CRC_ERROR pin location"
set_parameter_property crc_error_pin_location UNITS None
set_parameter_property crc_error_pin_location AFFECTS_GENERATION true
set_parameter_property crc_error_pin_location DESCRIPTION "Specify here the original CRCERROR pin location to be used for script generation, for example N24."

proc elaboration_callback {} {

	set generate_script [get_parameter_value change_pin_assignment]	
	set_parameter_property crc_error_pin_location VISIBLE $generate_script
	set_parameter_property crc_error_pin_name VISIBLE $generate_script
    
    set dev_cat [check_device_category]
    set_parameter_value dev_category $dev_cat
    
	set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 10240 -entity altera_crcerror_verify_top\n"
                        "set_instance_assignment -name MESSAGE_DISABLE 332060 -entity altera_crcerror_verify_top" }
    
    if {[get_parameter_value en_debug_ports]} {
        add_interface crcerror_debug conduit end err_verify_in_clk
        add_interface_port crcerror_debug crcerror_raw crcerror_raw output 1
        add_interface_port crcerror_debug emr_reg_raw emr_reg_raw output 46
        add_interface_port crcerror_debug emr_valid emr_valid output 1
        set_interface_assignment crcerror_debug "ui.blockdiagram.direction" OUTPUT
    }
}

proc check_device_category {} {

    set get_device_part     [get_parameter_value part_name]

    if {[string toupper $get_device_part] == "UNKNOWN"} {
        send_message error "Must assign a valid Device for altera_crcerror_verify."
    }
    
    if [regexp EP4SGX(70|110) $get_device_part ] {
        set_parameter_value    ed_cycle_time_div256    31
        return "DEVICE_CATEGORY_1"
        
    } elseif [regexp EP(4SGX180|4SGX230|4SE230|4S40G2|4S100G2|2AGZ225) $get_device_part ] {              
        set_parameter_value    ed_cycle_time_div256    63
        return "DEVICE_CATEGORY_2"
    
    } elseif [regexp EP(4SE360|2AGZ300|2AGZ350) $get_device_part ] {         
        set_parameter_value    ed_cycle_time_div256    83
        return "DEVICE_CATEGORY_3"
    
    } elseif [regexp EP4S(GX530|E530|40G5|100G3|100G4|100G5) $get_device_part ] {        
        set_parameter_value    ed_cycle_time_div256    111
        return "DEVICE_CATEGORY_4"
    
    } elseif [regexp EP4SGX(290|360) $get_device_part ] {    
        set_parameter_value    ed_cycle_time_div256    83
        if [regexp {NF45} $get_device_part ] {
            return "DEVICE_CATEGORY_4"
        } else {
            return "DEVICE_CATEGORY_3"
        }
    
    } elseif [regexp EP4SE820 $get_device_part ] {         
        set_parameter_value    ed_cycle_time_div256    160
        return "DEVICE_CATEGORY_5"
    
    } elseif [regexp EP2AGX(45|65) $get_device_part ] {         
        set_parameter_value    ed_cycle_time_div256    21
        return "DEVICE_CATEGORY_6"
    
    } elseif [regexp EP2AGX(95|125) $get_device_part ] {         
        set_parameter_value    ed_cycle_time_div256    35
        return "DEVICE_CATEGORY_7"
    
    } else {
        set_parameter_value    ed_cycle_time_div256    60
        return "DEVICE_CATEGORY_8"
    }
}


proc generate_synth {name} {

	send_message info "Preparing to generate synthesis fileset for $name"
    
    set ifdef_params_list [list]
    
    set dev_cat [get_parameter_value    dev_category]
    lappend ifdef_params_list $dev_cat

	generate_verilog_fileset $name $ifdef_params_list

	set qdir $::env(QUARTUS_ROOTDIR)
	set tmp_dir [create_temp_file {}]		
	set src_dir "${qdir}/../ip/altera/altera_crcerror_verify"
		
	set file_list "crcerror_verify_constraints.sdc"
	foreach sdc_file [alt_mem_if::util::iptclgen::parse_tcl_params $name $src_dir $tmp_dir [list $file_list] $ifdef_params_list] {
		set file_name [file tail $sdc_file]
		send_message info "Adding $file_name"
		add_fileset_file $file_name SDC PATH $sdc_file
	}
	
	if {[string compare -nocase [get_parameter_value change_pin_assignment] "true"] == 0} {
		set gen_file_name [generate_drive_strengths_assignment $name $src_dir $tmp_dir ]
		add_fileset_file [file tail $gen_file_name] OTHER PATH $gen_file_name

		foreach tcl_file [generate_pin_assignment_script $name $src_dir $tmp_dir ] {
			set file_name [ string map "crcerror_verify $name" [file tail $tcl_file] ]
			send_message info "Adding $file_name"
			add_fileset_file $file_name OTHER PATH $tcl_file
		}	

		print_generation_done_message $name		
	}
}

proc generate_vhdl_sim {name} {
	send_message info "Preparing to generate simulation fileset for $name"

	set ifdef_params_list [list]
	
    if [check_sim_ini] {
        lappend ifdef_params_list "SIMULATION"
    } else {
        set dev_cat [get_parameter_value    dev_category]
        lappend ifdef_params_list $dev_cat
    }
	
	generate_verilog_fileset $name $ifdef_params_list
}

proc generate_verilog_sim {name} {

	send_message info "Preparing to generate simulation fileset for $name"

	set ifdef_params_list [list]
	
    if [check_sim_ini] {
        lappend ifdef_params_list "SIMULATION"
    } else {
        set dev_cat [get_parameter_value    dev_category]
        lappend ifdef_params_list $dev_cat
    }
	
	generate_verilog_fileset $name $ifdef_params_list
}

proc generate_verilog_fileset {name ifdef_params} {

	set ifdef_source_list [list \
		altera_crcerror_verify_top.sv \
		crcerror_verify_core.sv \
        crcerror_edcrc_framelut.sv \
	]

	foreach file_name $ifdef_source_list {
        set generated_file [alt_mem_if::util::iptclgen::generate_outfile_name $file_name $ifdef_params]
		send_message info "Adding $generated_file as $file_name"
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name] PATH $generated_file
	}

	set source_list [list \
		crcerror_read_emr.sv \
		crcerror_edcrc_cache.sv \
        crcerror_edcrc_counter.sv \
        crcerror_edcrc_ctrlfsm.sv \
        crcerror_edcrc_genflp.sv \
        crcerror_edcrc_reqackfsm.sv \
        crcerror_edcrc_sfctrl.sv \
        
	]

	foreach file_name $source_list {
		send_message info "Adding $file_name"
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name] PATH $file_name
	}	
}

proc generate_drive_strengths_assignment {core_name src_dir dest_dir} {

	set dest_file_name [file join $dest_dir "${core_name}_drive_strengths.xml"]
	
	set top_crcerror_pin_name [get_parameter_value crc_error_pin_name]	

	file copy [file join $src_dir "crcerror_drive_strengths.xml.dat"] $dest_file_name
	alt_mem_if::util::iptclgen::sub_strings_params  $dest_file_name $dest_file_name \
				[list TOP_CRCERROR_PIN $top_crcerror_pin_name]

	return $dest_file_name
}

proc generate_pin_assignment_script {core_name src_dir dest_dir} {

	send_message info "Generating ${core_name}_pin_assignments.tcl"

	set file_list "crcerror_verify_pin_assignments.tcl"

	set ifdef_params_list [ list "IPTCL_FAKE" ]

	set top_crcerror_pin_name [get_parameter_value crc_error_pin_name]	
	set crcerror_pin_location [get_parameter_value crc_error_pin_location]	
	set keys_params_list [list TOP_CRCERROR_PIN $top_crcerror_pin_name \
						  CRCERROR_PIN_LOCATION "PIN_${crcerror_pin_location}"]
	
	set script_file_list [alt_mem_if::util::iptclgen::parse_tcl_params $core_name $src_dir $dest_dir [list $file_list] $ifdef_params_list]
	
	foreach sfile $script_file_list {
		alt_mem_if::util::iptclgen::sub_strings_params $sfile $sfile $keys_params_list
	}
	
	return $script_file_list
}


proc print_generation_done_message { outputname } {
		send_message "info" ""
		send_message "info" "CRCERROR Verify Component Generation is Complete"
		send_message "info" "*****************************"
		send_message "info" ""
		send_message "info" "Remember to run the ${outputname}_pin_assignments.tcl"
		send_message "info" "script before project compilation"
		send_message "info" ""
		send_message "info" "*****************************"
		send_message "info" ""
}



add_interface err_verify_in_clk clock sink
add_interface_port err_verify_in_clk err_verify_in_clk clk input 1

add_interface reset reset sink err_verify_in_clk
add_interface_port reset reset reset input 1

add_interface crcerror_core conduit end err_verify_in_clk
add_interface_port crcerror_core crc_error crc_error output 1
add_interface_port crcerror_core emr_real_seu emr_real_seu output 46
set_interface_assignment crcerror_core "ui.blockdiagram.direction" OUTPUT
