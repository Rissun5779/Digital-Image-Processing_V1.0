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


package require -exact qsys 16.0
package require -exact altera_terp 1.0

package require alt_mem_if::util::messaging
package require alt_mem_if::util::iptclgen
package require alt_mem_if::util::hwtcl_utils

namespace import ::alt_mem_if::util::messaging::*

set_module_property NAME            altera_emr_unloader_core2
set_module_property VERSION         18.1
set_module_property INTERNAL        true
set_module_property AUTHOR          "Altera Corporation"
set_module_property DISPLAY_NAME    "Altera EMR Unloader Core"
set_module_property DESCRIPTION     "Altera EMR Unloader core component"
set_module_property GROUP           "Configuration & Programming"
set_module_property EDITABLE        true

add_documentation_link "User Guide" http://www.altera.com/literature/ug/ug_emr_unloader.pdf

set supported_device_families_list {"Stratix IV" "Arria II GZ" "Arria II GX" "Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "Arria 10"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list


set_module_property ELABORATION_CALLBACK elaboration_callback


add_fileset sim_vhdl        SIM_VHDL        generate_vhdl_sim
add_fileset sim_verilog     SIM_VERILOG     generate_verilog_sim
add_fileset quartus_synth   QUARTUS_SYNTH   generate_synth

set top_level_module_name "altera_emr_unloader"
set_fileset_property SIM_VHDL       TOP_LEVEL $top_level_module_name
set_fileset_property sim_verilog    TOP_LEVEL $top_level_module_name
set_fileset_property quartus_synth  TOP_LEVEL $top_level_module_name



add_parameter device_family STRING
set_parameter_property device_family SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property device_family AFFECTS_GENERATION true
set_parameter_property device_family HDL_PARAMETER true
set_parameter_property device_family VISIBLE false

add_parameter part_speedgrade STRING
set_parameter_property part_speedgrade SYSTEM_INFO {DEVICE_SPEEDGRADE}
set_parameter_property part_speedgrade VISIBLE false

add_parameter emr_reg_width Integer
set_parameter_property emr_reg_width AFFECTS_GENERATION true
set_parameter_property emr_reg_width HDL_PARAMETER true
set_parameter_property emr_reg_width DERIVED true
set_parameter_property emr_reg_width VISIBLE false

add_parameter use_external_crcblock_core boolean false
set_parameter_property use_external_crcblock_core DISPLAY_NAME "Use crcblock core interface"
set_parameter_property use_external_crcblock_core DESCRIPTION "Specifies that Altera EMR Unloader core should use separately instantiated crcblock_atom."
set_parameter_property use_external_crcblock_core AFFECTS_GENERATION true
set_parameter_property use_external_crcblock_core VISIBLE false

add_parameter clock_cp_frequency Integer 50
set_parameter_property clock_cp_frequency DISPLAY_NAME "Frequency of crcblock core interface"
set_parameter_property clock_cp_frequency DESCRIPTION "Specifies the frequency of external crcblock core interface."
set_parameter_property clock_cp_frequency UNITS Megahertz
set_parameter_property clock_cp_frequency AFFECTS_GENERATION true

add_parameter error_clock_divisor Integer 2
set_parameter_property error_clock_divisor DISPLAY_NAME "CRC error check clock divisor"
set_parameter_property error_clock_divisor DESCRIPTION "Specifies the divide value of the internal clock, which determines the frequency of the CRC. Should match the Quartus Prime CRC settings."
set_parameter_property error_clock_divisor UNITS None

add_parameter error_delay_cycles Integer 0
set_parameter_property error_delay_cycles DISPLAY_NAME "CRC error reporting delay"
set_parameter_property error_delay_cycles DESCRIPTION "Specifies how many CRC error computation cycle-time units to delay when a CRC error is detected. INI is required to apply non-zero delay"
set_parameter_property error_delay_cycles UNITS Cycles

add_parameter enable_virtual_jtag Integer 0
set_parameter_property enable_virtual_jtag DISPLAY_HINT BOOLEAN
set_parameter_property enable_virtual_jtag DISPLAY_NAME "Enable Virtual JTAG CRC error injection"
set_parameter_property enable_virtual_jtag DESCRIPTION "Enables Virtual JTAG CRC error injection."
set_parameter_property enable_virtual_jtag HDL_PARAMETER true


add_display_item "" "Input Clock Specification" GROUP 
add_display_item "Input Clock Specification" clock_from_int_oscillator PARAMETER
add_display_item "Input Clock Specification" clock_frequency PARAMETER

add_parameter clock_from_int_oscillator Integer 0
set_parameter_property clock_from_int_oscillator DISPLAY_HINT BOOLEAN
set_parameter_property clock_from_int_oscillator DISPLAY_NAME "Input clock is driven from Internal Oscillator"
set_parameter_property clock_from_int_oscillator DESCRIPTION "Specifies that core input clock will be provided from internal oscillator."
set_parameter_property clock_from_int_oscillator AFFECTS_GENERATION true

add_parameter clock_frequency Integer 50
set_parameter_property clock_frequency DISPLAY_NAME "Frequency"
set_parameter_property clock_frequency DESCRIPTION "Specifies the frequency of Altera EMR Unloader core input clock."
set_parameter_property clock_frequency UNITS Megahertz
set_parameter_property clock_frequency AFFECTS_GENERATION true
set_parameter_property clock_frequency HDL_PARAMETER true


add_display_item "" "Interface Options" GROUP 
add_display_item "Interface Options" endof_ed_fullchip_interface PARAMETER

add_parameter endof_ed_fullchip_interface Integer 0
set_parameter_property endof_ed_fullchip_interface DISPLAY_HINT BOOLEAN
set_parameter_property endof_ed_fullchip_interface DISPLAY_NAME "Completion of full chip Error Detection cycle"
set_parameter_property endof_ed_fullchip_interface DESCRIPTION "An optional signal that is asserted at the end of the each full chip Error Detection cycle."
set_parameter_property endof_ed_fullchip_interface AFFECTS_GENERATION true


proc dev_fam_type {} {
    set family [get_parameter_value device_family]
    
    if { [expr {$family == "Arria 10"}] } {
        return "20nm"
    } elseif { [expr {$family == "Stratix V"}] || [expr {$family == "Arria V GZ"}] ||
                [expr {$family == "Arria V"}] || [expr {$family == "Cyclone V"}] } {
        return "28nm"
    } else {
        return "pre_28nm"
    }
}

proc is_32bits_crc {} {
    if { [expr {[dev_fam_type] == "pre_28nm"}] } {
        return false
    } else {
        return true
    }	
}

proc use_second_pulse {} {
    if { [expr {[dev_fam_type] == "20nm"}] } {
        return true
    } else {
        return false
    }	
}

proc set_emr_reg_width {} {
    if { [expr {[dev_fam_type] == "20nm"}] } {
        set_parameter_value emr_reg_width 119
        
    } elseif { [expr {[dev_fam_type] == "28nm"}] } {
        set_parameter_value emr_reg_width 67
        
    } else {
        set_parameter_value emr_reg_width 46
    }	
}

proc set_20nm_div_range {} {
    set get_device_speedgrade     [get_parameter_value part_speedgrade]

    if { [expr {$get_device_speedgrade == "1"}] } {
        set_parameter_property error_clock_divisor ALLOWED_RANGES {1 2 4}
        
    } else {  
        set_parameter_property error_clock_divisor ALLOWED_RANGES {2 4}
    }
}


proc elaboration_callback {} {
    set use_32bits_crc [is_32bits_crc]  
    set use_external_crcblock [get_parameter_value use_external_crcblock_core]
    set use_internal_crcblock [expr {$use_external_crcblock == "false"}]
    set use_int_osc [get_parameter_value clock_from_int_oscillator]
    
    set_emr_reg_width
    
    if { $use_32bits_crc} {
        set_parameter_property error_delay_cycles ALLOWED_RANGES {0:63}
        
        if { [expr {[dev_fam_type] == "28nm"}] } {
            set_parameter_property error_clock_divisor ALLOWED_RANGES {1 2 4 8 16 32 64 128 256}
        } else {
            set_20nm_div_range
        }        
        
        set_parameter_property clock_frequency VISIBLE [expr {$use_int_osc == 0}]
        
	} else {
        set_parameter_property error_delay_cycles ALLOWED_RANGES {0:7}
		set_parameter_property error_clock_divisor ALLOWED_RANGES {2 4 8 16 32 64 128 256}     
        set_parameter_property clock_frequency VISIBLE true 
        
	} 
    
    set_parameter_property error_clock_divisor VISIBLE $use_internal_crcblock
	set_parameter_property error_clock_divisor HDL_PARAMETER $use_internal_crcblock
    
	set_parameter_property error_delay_cycles HDL_PARAMETER $use_internal_crcblock
    
	set_parameter_property clock_from_int_oscillator VISIBLE $use_internal_crcblock
	set_parameter_property clock_from_int_oscillator HDL_PARAMETER $use_internal_crcblock

	set_parameter_property clock_cp_frequency VISIBLE $use_external_crcblock
	set_parameter_property clock_cp_frequency HDL_PARAMETER $use_external_crcblock
    
    set_display_item_property "Interface Options" VISIBLE $use_32bits_crc
    set_parameter_property endof_ed_fullchip_interface VISIBLE $use_32bits_crc

	add_interface avst_emr_src avalon_streaming start
	set_interface_property avst_emr_src associatedClock clock
	set_interface_property avst_emr_src associatedReset reset
	set_interface_property avst_emr_src dataBitsPerSymbol [get_parameter_value emr_reg_width]
	set_interface_property avst_emr_src errorDescriptor ""
	set_interface_property avst_emr_src firstSymbolInHighOrderBits true
	set_interface_property avst_emr_src maxChannel 0
	set_interface_property avst_emr_src readyLatency 0
	set_interface_property avst_emr_src ENABLED true
	set_interface_property avst_emr_src EXPORT_OF ""
	set_interface_property avst_emr_src PORT_NAME_MAP ""
	set_interface_property avst_emr_src SVD_ADDRESS_GROUP ""
	
	add_interface_port avst_emr_src emr data Output [get_parameter_value emr_reg_width]
	add_interface_port avst_emr_src emr_valid valid Output 1
	add_interface_port avst_emr_src emr_error error Output 1

	add_interface crcerror conduit end
	set_interface_property crcerror associatedClock clock
	set_interface_property crcerror associatedReset reset
	add_interface_port crcerror crcerror_core crcerror_core output 1
	set_interface_assignment crcerror "ui.blockdiagram.direction" OUTPUT
    
    add_interface crcerror_pin conduit end
    add_interface_port crcerror_pin crcerror_pin crcerror_pin output 1
    set_interface_assignment crcerror_pin "ui.blockdiagram.direction" OUTPUT

	if { $use_external_crcblock } {        
		add_interface crcerror_core conduit end
		add_interface_port crcerror_core crcerror_emr_cp emr_real_seu input 46
		add_interface_port crcerror_core crcerror_cp crc_error input 1

	} else {
		if { $use_32bits_crc && [get_parameter_value endof_ed_fullchip_interface] } {
			add_interface crcerror_endoffullchip conduit end
			add_interface_port crcerror_endoffullchip crcerror_endoffullchip crcerror_endoffullchip output 1
			set_interface_assignment crcerror_endoffullchip "ui.blockdiagram.direction" OUTPUT
		} 
	}

	if { [use_second_pulse] } {
        set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 332060 -entity altera_emr_unloader\n"
                          "set_instance_assignment -name MESSAGE_DISABLE 332060 -to reset\n"
                          "set_instance_assignment -name MESSAGE_DISABLE 332060 -to emr_read\n"
                          "set_instance_assignment -name MESSAGE_DISABLE 13004 -entity altera_emr_unloader\n"
                          "set_instance_assignment -name MESSAGE_DISABLE 13310 -entity altera_emr_unloader" }
                          
	} else {
        set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 332060 -entity altera_emr_unloader" }
	}
}

proc generate_synth {name} {
	_dprint 1 "Preparing to generate verilog synthesis fileset for $name"

	set ifdef_params_list [list]
	if {[string compare -nocase [get_parameter_value use_external_crcblock_core] "true"] == 0} {
		lappend ifdef_params_list "CORE_INTERFACE"
	}
	
	generate_verilog_fileset $name $ifdef_params_list
    
}

proc generate_vhdl_sim {name} {
	_dprint 1 "Preparing to generate verilog simulation fileset for $name"

	set ifdef_params_list [list]
	if {[string compare -nocase [get_parameter_value use_external_crcblock_core] "true"] == 0} {
		lappend ifdef_params_list "CORE_INTERFACE"
	}
	
	generate_verilog_fileset $name $ifdef_params_list
}

proc generate_verilog_sim {name} {
	_dprint 1 "Preparing to generate verilog simulation fileset for $name"

	set ifdef_params_list [list]
	if {[string compare -nocase [get_parameter_value use_external_crcblock_core] "true"] == 0} {
		lappend ifdef_params_list "CORE_INTERFACE"
	}
	
	generate_verilog_fileset $name $ifdef_params_list
}

proc generate_verilog_fileset {name ifdef_params} {

	set ifdef_source_list [list]
	set source_list [list]

	if { [use_second_pulse] } {
		lappend source_list "altera_emr_unloader2.v"
		lappend source_list "emr_unloader_define.iv"
	} else {
		lappend ifdef_source_list "altera_emr_unloader.v"
	}

	foreach file_name $ifdef_source_list {
		set generated_file [alt_mem_if::util::iptclgen::generate_outfile_name $file_name $ifdef_params]
		send_message info "Adding $generated_file as $file_name"
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name] PATH $generated_file
	}

	foreach file_name $source_list {
		send_message info "Adding $file_name"
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name] PATH $file_name
	}	
}



add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
add_interface_port clock clk clk Input 1

add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
add_interface_port reset reset reset Input 1

add_interface emr_read conduit end
set_interface_property emr_read associatedClock clock
set_interface_property emr_read associatedReset reset
add_interface_port emr_read emr_read emr_read Input 1
