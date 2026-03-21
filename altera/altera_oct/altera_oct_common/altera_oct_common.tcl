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


# (C) 2002-2012 Altera Corporation. All rights reserved.
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

# package: altera_oct::common
#
# Provides common functions for interacting with _hw.tcl API
#
package provide altera_oct::common 0.1

package require altera_emif::util::hwtcl_utils

################################################################################
###                          TCL INCLUDES                                   ###
################################################################################

################################################################################
###                          TCL NAMESPACE                                   ###
################################################################################
namespace eval ::altera_oct::common:: {
   # Namespace Variables
   
   # Import functions into namespace

   # Export functions
   namespace export safe_string_compare
   namespace export add_oct_parameters
   namespace export validate
   namespace export elaborate
   namespace export set_oct_interface   
   namespace export add_all_files_in_dir
   # Package variables
}

################################################################################
###                          TCL PROCEDURES                                  ###
################################################################################
proc ::altera_oct::common::safe_string_compare { string_1 string_2 } {
	set ret_val [expr {[string compare -nocase $string_1 $string_2] == 0}]
	return $ret_val
}

# proc: ::altera_oct::common::add_all_files_in_dir
#
# Recursively finds and adds all files to fileset
# The output mirrors the input directory
# 
# NOTE: If you'd like things to be under a top directory
# set out_dir to an actual value, otherwise out_dir can be ""
#
# parameters: 
# 		dir - absolute directory to find files in
#		out_dir - relative directory to put files in for the output
#
# returns: nothing
#
proc ::altera_oct::common::add_all_files_in_dir { dir out_dir } {
	# Find all files under dir
	set files [glob -nocomplain -directory $dir *]
	foreach item $files {
		if { [file isfile $item] == 1 } {
			set filename [file tail $item]
			add_fileset_file $out_dir/$filename OTHER PATH $item
		} else {
			set dirname [file tail $item]
			set chain_dirname "${out_dir}/${dirname}"
			add_all_files_in_dir $item $chain_dirname
		}
	}
}

proc ::altera_oct::common::generate_vhdl_sim {encrypted_files} {
	set rtl_only 0
	set encrypted 1   

	set non_encryp_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 1]

	# Return Verilog/SV files that have an encrypted counterpart
	set file_paths $encrypted_files

	foreach file_path $file_paths {
		set tmp [file split $file_path]
		set file_name [lindex $tmp end]

		# Return the normal verilog file for dual language simulators
		add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only 0] PATH $file_path $non_encryp_simulators

		# Return the mentor tagged files
		add_fileset_file [file join mentor $file_name] [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join mentor $file_path] {MENTOR_SPECIFIC}
	} 
}

proc ::altera_oct::common::add_oct_parameters { is_driver is_top } {

	if {$is_top == "true"} {
		set has_hdl_parameters "false"
	} else {
		set has_hdl_parameters "true"
	}
	
	# +-----------------------------------
	# | GUI Parameters
	# | 
	add_parameter OCT_CAL_NUM INTEGER 1
	set_parameter_property OCT_CAL_NUM DEFAULT_VALUE 1
	set_parameter_property OCT_CAL_NUM DISPLAY_NAME "Number of OCT blocks"
	set_parameter_property OCT_CAL_NUM ALLOWED_RANGES {1:12}
	set_parameter_property OCT_CAL_NUM AFFECTS_GENERATION true
	set_parameter_property OCT_CAL_NUM DESCRIPTION "Specifies the number of OCT blocks to be generated"
	set_parameter_property OCT_CAL_NUM HDL_PARAMETER $has_hdl_parameters
	add_display_item "General" OCT_CAL_NUM parameter
	
	add_parameter ENABLE_MIGRATABLE_PORT_NAMES BOOLEAN "false"
	set_parameter_property ENABLE_MIGRATABLE_PORT_NAMES DEFAULT_VALUE "false"
	set_parameter_property ENABLE_MIGRATABLE_PORT_NAMES DISPLAY_NAME "Use backwards-compatible port names"
	set_parameter_property ENABLE_MIGRATABLE_PORT_NAMES AFFECTS_GENERATION true
	set_parameter_property ENABLE_MIGRATABLE_PORT_NAMES DESCRIPTION "Check this to use legacy top-level names compatible with ALTOCTX"
	set_parameter_property ENABLE_MIGRATABLE_PORT_NAMES HDL_PARAMETER false
	add_display_item "General" ENABLE_MIGRATABLE_PORT_NAMES parameter

	add_parameter OCT_MODE STRING "Power-up"
	set_parameter_property OCT_MODE DISPLAY_NAME "OCT mode"
	set_parameter_property OCT_MODE DEFAULT_VALUE "Power-up"
	set_parameter_property OCT_MODE ALLOWED_RANGES {"Power-up" "User"}
	set_parameter_property OCT_MODE AFFECTS_GENERATION true
	set_parameter_property OCT_MODE DESCRIPTION "Specifies whether OCT will be user-controlled or not"
	set_parameter_property OCT_MODE HDL_PARAMETER false
	set_parameter_property OCT_MODE VISIBLE true
	set_parameter_property OCT_MODE ENABLED true
	add_display_item "OCT Configuration" OCT_MODE parameter
	
	set oct_size 12

	for { set i 0 } { $i < ${oct_size} } {incr i } {
		add_parameter OCT_CAL_MODE_$i STRING "Single"
		set_parameter_property OCT_CAL_MODE_$i DEFAULT_VALUE "Single"
		set_parameter_property OCT_CAL_MODE_$i DISPLAY_NAME "OCT block $i calibration mode"
		set_parameter_property OCT_CAL_MODE_$i ALLOWED_RANGES {"Single" "Double" "POD"}
		set_parameter_property OCT_CAL_MODE_$i AFFECTS_GENERATION true
		set_parameter_property OCT_CAL_MODE_$i DESCRIPTION "Specifies the calibration mode for the oct"
		set_parameter_property OCT_CAL_MODE_$i HDL_PARAMETER false
		set_parameter_property OCT_CAL_MODE_$i VISIBLE false
		add_display_item "OCT Configuration" OCT_CAL_MODE_$i parameter
		
		# +-----------------------------------
		# | non-GUI Parameters
		# | 
		add_parameter OCT_CAL_MODE_DER_$i STRING ""
		set_parameter_property OCT_CAL_MODE_DER_$i DEFAULT_VALUE "A_OCT_CAL_MODE_SINGLE"
		set_parameter_property OCT_CAL_MODE_DER_$i ALLOWED_RANGES {"A_OCT_CAL_MODE_SINGLE" "A_OCT_CAL_MODE_DOUBLE" "A_OCT_CAL_MODE_POD" "A_OCT_CAL_MODE_AUTO"}
		set_parameter_property OCT_CAL_MODE_DER_$i AFFECTS_GENERATION true
        if {$is_driver == "true"} {
			set_parameter_property OCT_CAL_MODE_DER_$i HDL_PARAMETER false
        } else {
			set_parameter_property OCT_CAL_MODE_DER_$i HDL_PARAMETER $has_hdl_parameters
		}
		set_parameter_property OCT_CAL_MODE_DER_$i VISIBLE false
		set_parameter_property OCT_CAL_MODE_DER_$i DERIVED true
		
		# | 
		# +-----------------------------------
	}

	add_parameter GUI_OCT_CLKBUF_MODE STRING "Off"
	set_parameter_property GUI_OCT_CLKBUF_MODE DISPLAY_NAME "Clock buffer mode"
	set_parameter_property GUI_OCT_CLKBUF_MODE DEFAULT_VALUE "Off"
	set_parameter_property GUI_OCT_CLKBUF_MODE ALLOWED_RANGES {"On" "Off"}
	set_parameter_property GUI_OCT_CLKBUF_MODE AFFECTS_GENERATION true
	set_parameter_property GUI_OCT_CLKBUF_MODE DESCRIPTION "Enables the clock buffer to drive the OCT in user-mode"
	set_parameter_property GUI_OCT_CLKBUF_MODE HDL_PARAMETER false
	set_parameter_property GUI_OCT_CLKBUF_MODE VISIBLE false
	set_parameter_property GUI_OCT_CLKBUF_MODE ENABLED true
	add_display_item "OCT clock buffer mode" GUI_OCT_CLKBUF_MODE parameter
	

	# +-----------------------------------
	# | non-GUI Parameters
	# | 

	add_parameter OCT_USER_MODE STRING ""
	set_parameter_property OCT_USER_MODE DEFAULT_VALUE "A_OCT_USER_OCT_OFF"
	set_parameter_property OCT_USER_MODE ALLOWED_RANGES {"A_OCT_USER_OCT_OFF" "A_OCT_USER_OCT_ON"}
	set_parameter_property OCT_USER_MODE AFFECTS_GENERATION true
	set_parameter_property OCT_USER_MODE HDL_PARAMETER $has_hdl_parameters
	set_parameter_property OCT_USER_MODE VISIBLE false
	set_parameter_property OCT_USER_MODE DERIVED true

	add_parameter OCT_CKBUF_MODE STRING ""
	set_parameter_property OCT_CKBUF_MODE DEFAULT_VALUE "false"
	set_parameter_property OCT_CKBUF_MODE ALLOWED_RANGES {"true" "false"}
	set_parameter_property OCT_CKBUF_MODE AFFECTS_GENERATION true
	set_parameter_property OCT_CKBUF_MODE HDL_PARAMETER $has_hdl_parameters
	set_parameter_property OCT_CKBUF_MODE VISIBLE false
	set_parameter_property OCT_CKBUF_MODE DERIVED true

	
	# | 
	# +-----------------------------------
}

proc ::altera_oct::common::validate {} {
	set oct_mode [get_parameter_value OCT_MODE]
	set oct_size [get_parameter_value OCT_CAL_NUM]
	
	for { set i 0 } { $i < 12 } {incr i } {
		if { $i < ${oct_size} } {
			set_parameter_property OCT_CAL_MODE_$i VISIBLE true
			set oct_cal_mode [get_parameter_value OCT_CAL_MODE_$i]
			
			if {$oct_cal_mode == "Single"} {
				set_parameter_value OCT_CAL_MODE_DER_$i "A_OCT_CAL_MODE_SINGLE"
			} elseif {$oct_cal_mode == "Double"} {
				set_parameter_value OCT_CAL_MODE_DER_$i "A_OCT_CAL_MODE_DOUBLE"
			} elseif {$oct_cal_mode == "POD"} {
				set_parameter_value OCT_CAL_MODE_DER_$i "A_OCT_CAL_MODE_POD"
			}
		} else {
			set_parameter_property OCT_CAL_MODE_$i VISIBLE false
		}
	}

	set_parameter_value OCT_CKBUF_MODE "false"
	if {[safe_string_compare $oct_mode "User"]} {
		#set_parameter_property GUI_OCT_CLKBUF_MODE VISIBLE true
		set_parameter_value OCT_USER_MODE "A_OCT_USER_OCT_ON"
		set oct_clk_mode [get_parameter_value GUI_OCT_CLKBUF_MODE]
		if {[safe_string_compare $oct_clk_mode "On"]} {
			set_parameter_value OCT_CKBUF_MODE "true"
		} else {
			set_parameter_value OCT_CKBUF_MODE "false"
		}
	} else {
		set_parameter_value OCT_USER_MODE "A_OCT_USER_OCT_OFF"
	}
}

proc ::altera_oct::common::elaborate { is_driver } {
	set_oct_interface $is_driver
}

proc ::altera_oct::common::set_oct_interface { is_driver } {
	set oct_size [get_parameter_value OCT_CAL_NUM]
	set oct_mode [get_parameter_value OCT_MODE]

	if { $oct_size > 12 } {
		set oct_size 12
	}

	add_interface rzqin conduit end
	add_interface clock conduit end
	add_interface reset conduit end
	add_interface calibration_request conduit end
	add_interface calibration_shift_busy conduit end
	add_interface calibration_busy conduit end

	set_interface_property rzqin ENABLED true
	if {[safe_string_compare $oct_mode "User"]} {
		set_interface_property clock ENABLED true
		set_interface_property reset ENABLED true
		set_interface_property calibration_request ENABLED true
		set_interface_property calibration_shift_busy ENABLED true
		set_interface_property calibration_busy ENABLED true
	} else {
		set_interface_property clock ENABLED false
		set_interface_property reset ENABLED false
		set_interface_property calibration_request ENABLED false
		set_interface_property calibration_shift_busy ENABLED false
		set_interface_property calibration_busy ENABLED false
	}

	if {$is_driver == "true"} {
		add_interface_port rzqin rzqin export Output $oct_size
		add_interface_port clock clock export Output 1
		add_interface_port reset reset export Output 1
		add_interface_port calibration_request calibration_request export Output $oct_size
		add_interface_port calibration_shift_busy calibration_shift_busy export Input $oct_size
		set_port_property calibration_shift_busy VHDL_TYPE std_logic_vector
		add_interface_port calibration_busy calibration_busy export Input $oct_size
		set_port_property calibration_busy VHDL_TYPE std_logic_vector
	} else {
		add_interface_port rzqin rzqin export Input $oct_size
		add_interface_port clock clock export Input 1
		add_interface_port reset reset export Input 1
		add_interface_port calibration_request calibration_request export Input $oct_size
		add_interface_port calibration_shift_busy calibration_shift_busy export Output $oct_size
		set_port_property calibration_shift_busy VHDL_TYPE std_logic_vector
		add_interface_port calibration_busy calibration_busy export Output $oct_size
		set_port_property calibration_busy VHDL_TYPE std_logic_vector
		for { set i 0 } { $i < 12 } {incr i } {
			set series_interface "oct_${i}_series_termination_control"
			add_interface $series_interface conduit end
			add_interface_port $series_interface $series_interface export Output 16
			set_port_property $series_interface VHDL_TYPE std_logic_vector

			set parallel_interface "oct_${i}_parallel_termination_control"
			add_interface $parallel_interface conduit end
			add_interface_port $parallel_interface $parallel_interface export Output 16
			set_port_property $parallel_interface VHDL_TYPE std_logic_vector

			if {$i < $oct_size} {
				set_interface_property $series_interface ENABLED true
				set_interface_property $parallel_interface ENABLED true
			} else {
				set_interface_property $series_interface ENABLED false
				set_interface_property $parallel_interface ENABLED false
			}
		}
	}
}
