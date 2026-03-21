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


set_module_property NAME            altera_emr_unloader2
set_module_property VERSION         18.1
set_module_property DISPLAY_NAME    "Error Message Register Unloader Intel FPGA IP"
set_module_property GROUP           "Basic Functions/Configuration and Programming"
set_module_property INTERNAL        false
set_module_property AUTHOR          "Altera Corporation"
set_module_property DESCRIPTION     "Altera Error Message Register Unloader provides parallel interface for EMR."

add_documentation_link "User Guide" http://www.altera.com/literature/ug/ug_emr_unloader.pdf

set supported_device_families_list {"Stratix IV" "Arria II GZ" "Arria II GX" "Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "Arria 10"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list


set_module_property COMPOSITION_CALLBACK composition_callback



add_parameter device_family STRING
set_parameter_property device_family SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property device_family AFFECTS_GENERATION true
set_parameter_property device_family VISIBLE false

add_parameter part_name STRING
set_parameter_property part_name SYSTEM_INFO {DEVICE}
set_parameter_property part_name VISIBLE false

add_parameter part_speedgrade STRING
set_parameter_property part_speedgrade SYSTEM_INFO {DEVICE_SPEEDGRADE}
set_parameter_property part_speedgrade VISIBLE false

add_parameter skip_crcerror_verify boolean false
set_parameter_property skip_crcerror_verify DESCRIPTION "Hidden option to skip mandatory altera_crc_error_verify instantiation for Stratix IV and Arria II only"
set_parameter_property skip_crcerror_verify VISIBLE false

add_parameter error_delay_cycles Integer 0
set_parameter_property error_delay_cycles ALLOWED_RANGES {0:7}
set_parameter_property error_delay_cycles DISPLAY_NAME "CRC error reporting delay"
set_parameter_property error_delay_cycles DESCRIPTION "Specifies how many CRC error computation cycle-time units to delay when a CRC error is detected. INI is required to apply non-zero delay"
set_parameter_property error_delay_cycles UNITS Cycles
set_parameter_property error_delay_cycles VISIBLE false



add_parameter error_clock_divisor Integer 2
set_parameter_property error_clock_divisor DISPLAY_NAME "CRC error check clock divisor"
set_parameter_property error_clock_divisor DESCRIPTION "Specifies the divide value of the internal clock, which determines the frequency of the CRC. Should match the Quartus Prime CRC settings."
set_parameter_property error_clock_divisor UNITS None

add_parameter enable_virtual_jtag Integer 0
set_parameter_property enable_virtual_jtag DISPLAY_HINT BOOLEAN
set_parameter_property enable_virtual_jtag DISPLAY_NAME "Enable Virtual JTAG CRC error injection"
set_parameter_property enable_virtual_jtag DESCRIPTION "Enables Virtual JTAG CRC error injection."

add_display_item "" "Input Clock Specification" GROUP 
add_display_item "Input Clock Specification" clock_from_int_oscillator PARAMETER
add_display_item "Input Clock Specification" clock_frequency PARAMETER

add_parameter clock_from_int_oscillator Integer 0
set_parameter_property clock_from_int_oscillator DISPLAY_HINT BOOLEAN
set_parameter_property clock_from_int_oscillator DISPLAY_NAME "Input clock is driven from Internal Oscillator"
set_parameter_property clock_from_int_oscillator DESCRIPTION "Specifies that core input clock will be provided from internal oscillator."
set_parameter_property clock_from_int_oscillator AFFECTS_GENERATION true

add_parameter clock_frequency Integer 50
set_parameter_property clock_frequency DISPLAY_NAME "Input clock frequency"
set_parameter_property clock_frequency DESCRIPTION "Specifies the frequency of Altera EMR Unloader core input clock."
set_parameter_property clock_frequency UNITS Megahertz
set_parameter_property clock_frequency AFFECTS_GENERATION true

add_display_item "" "Error Detection CRC Verification Options" GROUP 
add_display_item "Error Detection CRC Verification Options" crcerror_clk_frequency PARAMETER
add_display_item "Error Detection CRC Verification Options" en_debug_ports PARAMETER

add_parameter crcerror_clk_frequency Integer 50
set_parameter_property crcerror_clk_frequency DISPLAY_NAME "CRC Error Verify input clock frequency"
set_parameter_property crcerror_clk_frequency DESCRIPTION "Specifies the frequency of ALTERA_CRCERROR_VERIFY block input clock, must be withing 10-50 MHz range."
set_parameter_property crcerror_clk_frequency UNITS Megahertz
set_parameter_property crcerror_clk_frequency AFFECTS_GENERATION true

add_parameter en_debug_ports boolean false
set_parameter_property en_debug_ports DISPLAY_NAME "Enable EMR debug ports"
set_parameter_property en_debug_ports DESCRIPTION "Enable EMR debug ports to show raw EMR data"
set_parameter_property en_debug_ports AFFECTS_GENERATION true

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

proc use_crcerror_verify_core {} {
    if { [is_32bits_crc] || [get_parameter_value skip_crcerror_verify] } {
        return false
    } else {
        return true
    }
}

proc set_20nm_div_range {} {
    set get_device_part     [get_parameter_value part_name]
    set get_device_speedgrade     [get_parameter_value part_speedgrade]

    if {[string toupper $get_device_part] == "UNKNOWN"} {
        send_message error "Must assign a valid Device for altera_emr_unloader."
    }
    
    if { [expr {$get_device_speedgrade == "1"}] } {
        set_parameter_property error_clock_divisor ALLOWED_RANGES {1 2 4}
        
    } else {  
        set_parameter_property error_clock_divisor ALLOWED_RANGES {2 4}
    }
}

proc composition_callback {} {

    set use_32bits_crc [is_32bits_crc]  
    set use_crcblock_wrapper [use_crcerror_verify_core] 
    set use_int_osc [get_parameter_value clock_from_int_oscillator]
    set crcerror_clk_freq_val [get_parameter_value crcerror_clk_frequency]
    set clk_div_val [get_parameter_value error_clock_divisor]
    set enable_debug_ports [get_parameter_value en_debug_ports]
    set enable_ed_fullchip_ports [get_parameter_value endof_ed_fullchip_interface]
    
    set_parameter_property clock_from_int_oscillator VISIBLE $use_32bits_crc
    
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
    
    set_display_item_property "Error Detection CRC Verification Options" VISIBLE $use_crcblock_wrapper
    set_parameter_property crcerror_clk_frequency VISIBLE $use_crcblock_wrapper
    set_parameter_property en_debug_ports VISIBLE $use_crcblock_wrapper
    
    set_display_item_property "Interface Options" VISIBLE $use_32bits_crc
    set_parameter_property endof_ed_fullchip_interface VISIBLE $use_32bits_crc
	
    
    
	add_instance emr_unloader_component altera_emr_unloader_core2
	set_instance_parameter emr_unloader_component use_external_crcblock_core $use_crcblock_wrapper
	set_instance_parameter emr_unloader_component enable_virtual_jtag [get_parameter_value enable_virtual_jtag]
	set_instance_parameter emr_unloader_component clock_frequency [get_parameter_value clock_frequency]
    
	if { $use_crcblock_wrapper } {
		set_instance_parameter emr_unloader_component clock_cp_frequency $crcerror_clk_freq_val
	} else {
		set_instance_parameter emr_unloader_component error_clock_divisor $clk_div_val
		set_instance_parameter emr_unloader_component error_delay_cycles [get_parameter_value error_delay_cycles]
		set_instance_parameter emr_unloader_component clock_from_int_oscillator $use_int_osc
		set_instance_parameter emr_unloader_component endof_ed_fullchip_interface $enable_ed_fullchip_ports
	}
	
	add_interface clock clock sink
	set_interface_property clock export_of emr_unloader_component.clock
	set_interface_property clock PORT_NAME_MAP {clk clk}
     
	add_interface           reset reset sink
	set_interface_property  reset export_of emr_unloader_component.reset
	set_interface_property  reset PORT_NAME_MAP {reset reset}
    
    
	if { $use_crcblock_wrapper } {
        add_instance block_wrapper altera_crcerror_verify2

		set_instance_parameter block_wrapper in_clk_frequency $crcerror_clk_freq_val
		set_instance_parameter block_wrapper error_check_frequency_divisor $clk_div_val
        set_instance_parameter block_wrapper en_debug_ports $enable_debug_ports
		set_instance_parameter block_wrapper change_pin_assignment false

		add_interface crcerror_clk clock sink
		set_interface_property  crcerror_clk export_of block_wrapper.err_verify_in_clk
		set_interface_property  crcerror_clk PORT_NAME_MAP {crcerror_clk err_verify_in_clk}
	   
		add_interface           crcerror_reset reset sink
		set_interface_property  crcerror_reset export_of block_wrapper.reset
		set_interface_property  crcerror_reset PORT_NAME_MAP {crcerror_reset reset}
        
		add_interface crcerror_pin conduit end 
		set_interface_property crcerror_pin export_of emr_unloader_component.crcerror_pin
		set_interface_property crcerror_pin PORT_NAME_MAP {crcerror_pin crcerror_pin}
	    
		add_connection emr_unloader_component.crcerror_core block_wrapper.crcerror_core conduit crcerror_core_connection_point
        
        if { $enable_debug_ports } {
            add_interface crcerror_debug conduit end 
            set_interface_property crcerror_debug export_of block_wrapper.crcerror_debug
            set_interface_property crcerror_debug PORT_NAME_MAP {crcerror_debug crcerror_raw crcerror_emr_debug emr_reg_raw crcerror_emr_valid_debug emr_valid}
        }
        
	} else {
        add_interface crcerror_pin conduit end 
        set_interface_property crcerror_pin export_of emr_unloader_component.crcerror_pin
        set_interface_property crcerror_pin PORT_NAME_MAP {crcerror_pin crcerror_pin}

		if { $use_32bits_crc && $enable_ed_fullchip_ports } {
			add_interface crcerror_endoffullchip conduit end 
			set_interface_property crcerror_endoffullchip export_of emr_unloader_component.crcerror_endoffullchip
			set_interface_property crcerror_endoffullchip PORT_NAME_MAP {crcerror_endoffullchip crcerror_endoffullchip}
		}
	}

	add_interface crcerror conduit end 
	set_interface_property crcerror export_of emr_unloader_component.crcerror
	set_interface_property crcerror PORT_NAME_MAP {crcerror_core crcerror_core}

	add_interface emr_read conduit end
	set_interface_property emr_read export_of emr_unloader_component.emr_read
	set_interface_property emr_read PORT_NAME_MAP {emr_read emr_read}

	add_interface avst_emr_src avalon_streaming start
	set_interface_property avst_emr_src export_of emr_unloader_component.avst_emr_src
	set_interface_property avst_emr_src PORT_NAME_MAP {emr emr emr_valid emr_valid emr_error emr_error}
}





add_documentation_link "User Guide" "https://documentation.altera.com/#/link/esc1417461530107/esc1417477325834"
add_documentation_link "Release Notes" "https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408"
