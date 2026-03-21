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
package require altera_terp

source "fourteennm_mac_native_hw_extra.tcl"

# source "../lib/tcl/avalon_streaming_util.tcl"
# source "../lib/tcl/dspip_common.tcl"
#load_strings FPDSP.properties
source "../common/mac_native_common.tcl"

# |
# +-----------------------------------

# +-----------------------------------
# | module altera_cic
# |
set_module_property NAME "altera_s10_native_fixed_point_dsp"
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION "18.1"
set_module_property INTERNAL false
set_module_property GROUP "DSP/Primitive DSP"
set_module_property DISPLAY_NAME "Stratix 10 Native Fixed Point DSP"
set_module_property DESCRIPTION "The NATIVE_DSP megafunction allows you to implement the primitive variable precision DSP block"
#set_module_property DATASHEET_URL [get_string DATASHEET_URL]
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elab
set_module_property VALIDATION_CALLBACK validate
set_module_property SUPPORTED_DEVICE_FAMILIES {
    {Stratix 10}

}
#Created for IP-UPGRADE for new parameter in hw_tcl
set_module_property PARAMETER_UPGRADE_CALLBACK parameter_upgrade_callback

#add_fileset ALTFP_DSP_QUARTUS_SYNTH QUARTUS_SYNTH quartus_synth_callback
#add_fileset ALTFP_DSP_QUARTUS_SYNTH SIM_VERILOG generate_sim_verilog
#add_fileset ALTFP_DSP_QUARTUS_SYNTH SIM_VHDL generate_sim_vhdl

#Added new fileset
add_fileset quartus_synth   QUARTUS_SYNTH   quartus_synth_callback
add_fileset verilog_sim     SIM_VERILOG     generate_sim_verilog
add_fileset vhdl_sim        SIM_VHDL        generate_sim_vhdl


# |
# +-----------------------------------

# +-----------------------------------
# | Main Interface
# |
add_display_item "" "General" GROUP tab
add_display_item "" "Coeffient Configuration" GROUP tab
	
add_display_item "General" "Operation Mode" GROUP
add_parameter operation_mode string "m18x18_full"
set_parameter_property operation_mode DISPLAY_NAME "Select the Operation Mode"
set_parameter_property operation_mode UNITS None
set_parameter_property operation_mode DESCRIPTION "Set the mode that the DSP operates, the modes are demonstrated in the diagram below"
set_parameter_property operation_mode ALLOWED_RANGES [list "m18x18_full:M18x18_full" "m18x18_full_top:M18x18_full_top" "m18x18_sumof2:M18x18_sumof2" "m18x18_plus36:M18x18_plus36" "m18x18_systolic:M18x18_Systolic" "m27x27:M27x27"]
set_parameter_property operation_mode AFFECTS_GENERATION true
add_display_item "Operation Mode" operation_mode parameter
	
# Parameter SIGNED_MAX
add_display_item "General" "Multiplier Configuration" GROUP
add_parameter signed_max string "Unsigned"
set_parameter_property signed_max DISPLAY_NAME "Representation format for AX input bus"
set_parameter_property signed_max UNITS None
set_parameter_property signed_max DESCRIPTION "Specifies the representation format"
set_parameter_property signed_max ALLOWED_RANGES [list "Unsigned" "Signed"]
set_parameter_property signed_max AFFECTS_GENERATION true
add_display_item "Multiplier Configuration" signed_max parameter

# Parameter SIGNED_MAY
add_display_item "General" "Multiplier Configuration" GROUP
add_parameter signed_may string "Unsigned"
set_parameter_property signed_may DISPLAY_NAME "Representation format for AY/AZ input buses"
set_parameter_property signed_may UNITS None
set_parameter_property signed_may DESCRIPTION "Specifies the representation format"
set_parameter_property signed_may ALLOWED_RANGES [list "Unsigned" "Signed"]
set_parameter_property signed_may AFFECTS_GENERATION true
add_display_item "Multiplier Configuration" signed_may parameter
	
# Parameter SIGNED_MBX
add_display_item "General" "Multiplier Configuration" GROUP
add_parameter signed_mbx string "Unsigned"
set_parameter_property signed_mbx DISPLAY_NAME "Representation format for BX input bus"
set_parameter_property signed_mbx UNITS None
set_parameter_property signed_mbx DESCRIPTION "Specifies the representation format"
set_parameter_property signed_mbx ALLOWED_RANGES [list "Unsigned" "Signed"]
set_parameter_property signed_mbx AFFECTS_GENERATION true
add_display_item "Multiplier Configuration" signed_mbx parameter

# Parameter SIGNED_MBY
add_display_item "General" "Multiplier Configuration" GROUP
add_parameter signed_mby string "Unsigned"
set_parameter_property signed_mby DISPLAY_NAME "Representation format for BY/BZ input buses"
set_parameter_property signed_mby UNITS None
set_parameter_property signed_mby DESCRIPTION "Specifies the representation format"
set_parameter_property signed_mby ALLOWED_RANGES [list "Unsigned" "Signed"]
set_parameter_property signed_mby AFFECTS_GENERATION true
add_display_item "Multiplier Configuration" signed_mby parameter

# Parameter CLEAR_TYPE
add_display_item "General" "Clear Signal Setting" GROUP
add_parameter clear_type string "none"
set_parameter_property clear_type DISPLAY_NAME "Type of clear signal"
set_parameter_property clear_type UNITS None
set_parameter_property clear_type DESCRIPTION "Specifies the type of CLEAR signals for all the registers"
set_parameter_property clear_type	ALLOWED_RANGES [list "none" "aclr" "sclr"]
set_parameter_property clear_type AFFECTS_GENERATION true
add_display_item "Clear Signal Setting" clear_type parameter
	
# Parameter AX_WIDTH
add_display_item "General" "Port Width Setting" Group
add_parameter ax_width INTEGER
set_parameter_property ax_width DEFAULT_VALUE 18
set_parameter_property ax_width DISPLAY_NAME "How wide should AX input bus be?"
set_parameter_property ax_width UNITS BITS
set_parameter_property ax_width DISPLAY_HINT ""
set_parameter_property ax_width AFFECTS_GENERATION true
set_parameter_property ax_width HDL_PARAMETER false
set_parameter_property ax_width DESCRIPTION "Specifies the AX input bus"
add_display_item "Port Width Setting" ax_width parameter

# Parameter BX_WIDTH
add_display_item "General" "Port Width Setting" Group
add_parameter bx_width INTEGER
set_parameter_property bx_width DEFAULT_VALUE 18
set_parameter_property bx_width DISPLAY_NAME "How wide should BX input bus be?"
set_parameter_property bx_width UNITS BITS
set_parameter_property bx_width DISPLAY_HINT ""
set_parameter_property bx_width AFFECTS_GENERATION true
set_parameter_property bx_width HDL_PARAMETER false
set_parameter_property bx_width DESCRIPTION "Specifies the BX input bus"
add_display_item "Port Width Setting" bx_width parameter
	
# Parameter ay_scan_in_width
add_display_item "General" "Port Width Setting" Group
add_parameter ay_scan_in_width INTEGER
set_parameter_property ay_scan_in_width DEFAULT_VALUE 18
set_parameter_property ay_scan_in_width DISPLAY_NAME "How wide should AY input bus be?"
set_parameter_property ay_scan_in_width UNITS BITS
set_parameter_property ay_scan_in_width DISPLAY_HINT ""
set_parameter_property ay_scan_in_width AFFECTS_GENERATION true
set_parameter_property ay_scan_in_width HDL_PARAMETER false
set_parameter_property ay_scan_in_width DESCRIPTION "Specifies the AY input bus"
add_display_item "Port Width Setting" ay_scan_in_width parameter

# Parameter BY_WIDTH
add_display_item "General" "Port Width Setting" Group
add_parameter by_width INTEGER
set_parameter_property by_width DEFAULT_VALUE 18
set_parameter_property by_width DISPLAY_NAME "How wide should BY input bus be?"
set_parameter_property by_width UNITS BITS
set_parameter_property by_width DISPLAY_HINT ""
set_parameter_property by_width AFFECTS_GENERATION true
set_parameter_property by_width HDL_PARAMETER false
set_parameter_property by_width DESCRIPTION "Specifies the BY input bus"
add_display_item "Port Width Setting" by_width parameter
	
# Parameter AZ_WIDTH
add_display_item "General" "Port Width Setting" Group
add_parameter az_width INTEGER
set_parameter_property az_width DEFAULT_VALUE 0
set_parameter_property az_width DISPLAY_NAME "How wide should AZ input bus be?"
set_parameter_property az_width UNITS BITS
set_parameter_property az_width DISPLAY_HINT ""
set_parameter_property az_width AFFECTS_GENERATION true
set_parameter_property az_width HDL_PARAMETER false
set_parameter_property az_width DESCRIPTION "Specifies the AZ input bus"
add_display_item "Port Width Setting" az_width parameter

# Parameter BZ_WIDTH
add_display_item "General" "Port Width Setting" Group
add_parameter bz_width INTEGER
set_parameter_property bz_width DEFAULT_VALUE 0
set_parameter_property bz_width DISPLAY_NAME "How wide should BZ input bus be?"
set_parameter_property bz_width UNITS BITS
set_parameter_property bz_width DISPLAY_HINT ""
set_parameter_property bz_width AFFECTS_GENERATION true
set_parameter_property bz_width HDL_PARAMETER false
set_parameter_property bz_width DESCRIPTION "Specifies the BZ input bus"
add_display_item "Port Width Setting" bz_width parameter

# Parameter RESULT_A_WIDTH
add_display_item "General" "Port Width Setting" Group
add_parameter result_a_width INTEGER
set_parameter_property result_a_width DEFAULT_VALUE 37
set_parameter_property result_a_width DISPLAY_NAME "How wide should result A width?"
set_parameter_property result_a_width UNITS BITS
set_parameter_property result_a_width DISPLAY_HINT ""
set_parameter_property result_a_width AFFECTS_GENERATION true
set_parameter_property result_a_width HDL_PARAMETER false
set_parameter_property result_a_width DESCRIPTION "Specifies the result A width"
add_display_item "Port Width Setting" result_a_width parameter
	
# Parameter RESULT_B_WIDTH
add_display_item "General" "Port Width Setting" Group
add_parameter result_b_width INTEGER
set_parameter_property result_b_width DEFAULT_VALUE 37
set_parameter_property result_b_width DISPLAY_NAME "How wide should result B width?"
set_parameter_property result_b_width UNITS BITS
set_parameter_property result_b_width DISPLAY_HINT ""
set_parameter_property result_b_width AFFECTS_GENERATION true
set_parameter_property result_b_width HDL_PARAMETER false
set_parameter_property result_b_width DESCRIPTION "Specifies the result B width"
add_display_item "Port Width Setting" result_b_width parameter

# Parameter SCAN_OUT_WIDTH
add_display_item "General" "Port Width Setting" Group
add_parameter scan_out_width INTEGER
set_parameter_property scan_out_width DEFAULT_VALUE 18
set_parameter_property scan_out_width DISPLAY_NAME "How wide should result scanout width?"
set_parameter_property scan_out_width UNITS BITS
set_parameter_property scan_out_width DISPLAY_HINT ""
set_parameter_property scan_out_width AFFECTS_GENERATION true
set_parameter_property scan_out_width HDL_PARAMETER false
set_parameter_property scan_out_width DESCRIPTION "Specifies the scanout width"
add_display_item "Port Width Setting" scan_out_width parameter
	
# Parameter LOAD_CONST_VALUE
add_display_item "Coeffient Configuration" "Load Const Setting" Group
add_parameter load_const_value INTEGER
set_parameter_property load_const_value DEFAULT_VALUE 0
set_parameter_property load_const_value DISPLAY_NAME "What is the value for loadconst?"
set_parameter_property load_const_value DISPLAY_HINT ""
set_parameter_property load_const_value AFFECTS_GENERATION true
set_parameter_property load_const_value HDL_PARAMETER false
set_parameter_property load_const_value DESCRIPTION "Specifies the loadconst value (2^)"
add_display_item "Load Const Setting" load_const_value parameter
	
 for { set j 0} {$j < 8} {incr j} {
 add_display_item "Coeffient Configuration" "Coefficient A Storage Configuration" GROUP tab
	 add_parameter coef_a_${j} INTEGER 0
	 set_parameter_property coef_a_${j} DEFAULT_VALUE 0
	 set_parameter_property coef_a_${j} DISPLAY_NAME "Coef_a_$j"
	 set_parameter_property coef_a_${j} UNITS None
	 set_parameter_property coef_a_${j} AFFECTS_GENERATION true
	 set_parameter_property coef_a_${j} HDL_PARAMETER false
	 set_parameter_property coef_a_${j} DESCRIPTION "Specifies the integer value of constant coefficient a"
	 add_display_item "Coefficient A Storage Configuration" coef_a_${j} parameter
 }
 for { set k 0} {$k < 8} {incr k} {
 add_display_item "Coeffient Configuration" "Coefficient B Storage Configuration" GROUP tab
	 add_parameter coef_b_${k} INTEGER 0
	 set_parameter_property coef_b_${k} DEFAULT_VALUE 0
	 set_parameter_property coef_b_${k} DISPLAY_NAME "Coef_b_$k"
	 set_parameter_property coef_b_${k} UNITS None
	 set_parameter_property coef_b_${k} AFFECTS_GENERATION true
	 set_parameter_property coef_b_${k} HDL_PARAMETER false
	 set_parameter_property coef_b_${k} DESCRIPTION "Specifies the integer value of constant coefficient b"
	 add_display_item "Coefficient B Storage Configuration" coef_b_${k} parameter
 }

#+--------------------------------------------
#|
#|  IP UPGRADE
#|
#+--------------------------------------------
 proc parameter_upgrade_callback {ip_core_type version parameters} { 
    set preadder_subtract_a "false"
	set preadder_subtract_b "false"
	set enable_scanout "false"
	set enable_chainin "false"
	set signed_max "Unsigned"
	set signed_mbx "Unsigned"
	set signed_may "Unsigned"
	set signed_mby "Unsigned"
	
	foreach { name value} $parameters {
		if { $name == "preadder_subtract_a"} {
			set preadder_subtract_a $value
			if {$preadder_subtract_a == "true"} {
				set_parameter_value preadder_subtract_a "-"
			} elseif { $preadder_subtract_a == "false"} {
				set_parameter_value preadder_subtract_a "+"
			}
		} elseif { $name == "preadder_subtract_b"} {
			set preadder_subtract_b $value
			if {$preadder_subtract_b == "true"} {
				set_parameter_value preadder_subtract_b "-"
			} elseif { $preadder_subtract_b == "false"} {
				set_parameter_value preadder_subtract_b "+"
			}
		} elseif { $name == "scanout_enable" } {
			set scanout_enable $value
			if {$scanout_enable == "false" } {
				set_parameter_value enable_scanout "false"
			} elseif { $scanout_enable == "true" } {
				set_parameter_value enable_scanout "true"
			}
		} elseif { $name == "use_chainadder" } {
			set use_chainadder $value
			if { $use_chainadder == "false" } {
				set_parameter_value enable_chainin "false"
			} elseif { $use_chainadder == "true" } {
				set_parameter_value enable_chainin "true"
			}
		} elseif { $name == "signed_max" } {
			set signed_max $value
			if { $signed_max == "false" } {
				set_parameter_value signed_max "Unsigned"
			} elseif { $signed_max == "true" } {
				set_parameter_value signed_max "Signed"
			}
		} elseif { $name == "signed_mbx" } {
			set signed_mbx $value
			if { $signed_mbx == "false" } {
				set_parameter_value signed_mbx "Unsigned"
			} elseif { $signed_mbx == "true" } {
				set_parameter_value signed_mbx "Signed"
			}
		} elseif { $name == "signed_may" } {
			set signed_may $value
			if { $signed_may == "false" } {
				set_parameter_value signed_may "Unsigned"
			} elseif { $signed_may == "true" } {
				set_parameter_value signed_may "Signed"
			}
		} elseif { $name == "signed_mby" } {
			set signed_mby $value 
			if { $signed_mby == "false" } {
				set_parameter_value signed_mby "Unsigned"
			} elseif { $signed_mby == "true" } {
				set_parameter_value signed_mby "Signed"
			}
		} else {
			set_parameter_value $name $value
			send_message INFO "show other parameter:$name = $value"
		}
	}	
}
	
add_display_item "General" "DSP Block View" GROUP
add_display_item "DSP Block View" widget_group group tab
add_display_item widget_group arria_widget parameter
set jar_path [file join $env(QUARTUS_ROOTDIR) .. ip altera native_mac s10 com.altera.s10.nativeip.ui.jar]
set widget_name "dsp_stratix10"
set_display_item_property widget_group WIDGET [list $jar_path $widget_name]


# Parameters For Clocks
# General Clocks available for most of the mode and features
proc get_clocks {} {
    return  [list ay_scan_in_clock  output_clock by_clock input_pipeline_clock second_pipeline_clock input_systolic_clock]
}
#Set of clocks that actually show up in the HDL
proc get_hdl_clocks {} {
    return  [list  ax_clock ay_scan_in_clock az_clock output_clock  bx_clock accumulate_clock accum_pipeline_clock bz_clock by_clock  coef_sel_a_clock coef_sel_b_clock sub_clock negate_clock accum_2nd_pipeline_clock load_const_clock load_const_pipeline_clock load_const_2nd_pipeline_clock input_pipeline_clock second_pipeline_clock input_systolic_clock]
}

# The available parameter 
proc get_parameters_list {} {
	return [list operation_mode operand_source_max operand_source_may operand_source_mbx operand_source_mby preadder_subtract_a preadder_subtract_b ay_use_scan_in by_use_scan_in delay_scan_out_ay delay_scan_out_by enable_chainin enable_double_accum chainout_enable enable_scanout enable_accumulate enable_sub enable_negate enable_loadconst enable_clr0 enable_clr1 enable_clkena0 enable_clkena1 enable_clkena2 accumulate_clock load_const_clock negate_clock sub_clock ay_scan_in_clock az_clock ax_clock coef_sel_a_clock by_clock bx_clock bz_clock coef_sel_b_clock input_systolic_clock input_pipeline_clock second_pipeline_clock accum_pipeline_clock accum_2nd_pipeline_clock load_const_pipeline_clock load_const_2nd_pipeline_clock output_clock]
}

# Available clock for OPERAND_SOURCE_MAY
proc feature_clocks_preadder_may {} {
	return [list az_clock]
}
# Available clock for OPERAND_SOURCE_MBY
proc feature_clocks_preadder_mby {} {
	return [list bz_clock]
}
# Available clock for ENABLE_ACCUMULATE
proc feature_clocks_accumulate {} {
	return [list accumulate_clock accum_pipeline_clock accum_2nd_pipeline_clock]
}
# Available clock for ENABLE_LOADCONST
proc feature_clocks_loadconst {} {
	return [list load_const_clock load_const_pipeline_clock load_const_2nd_pipeline_clock]
}
# Available clock for ENABLE_NEGATE
proc feature_clocks_negate {} {
	return [list negate_clock]
}
# Available clock for ENABLE_SUB
proc feature_clocks_sub {} {
	return [list sub_clock]
}
# Available clock for OPERAND_SOURCE_MAX
proc feature_clocks_coef {} {
	return [list coef_sel_a_clock]
}

# Available clock for OPERAND_SOURCE_MAX INPUT
proc feature_clocks_input_max {} {
	return [list ax_clock ]
}

# Available clock for OPERAND_SOURCE_MBX INPUT
proc feature_clocks_input_mbx {} {
	return [list bx_clock ]
}

# Available clock for OPERAND_SOURCE_MBX
proc feature_clocks_coef_mbx {} {
	return [list  coef_sel_b_clock]
}

# Clock register available based on supported mode.
proc get_used_clocks {} {
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
		return  [list ay_scan_in_clock output_clock input_pipeline_clock second_pipeline_clock  by_clock ]
   } elseif { [string equal [get_parameter_value operation_mode] "m18x18_full_top"] } {
		return [list ay_scan_in_clock output_clock input_pipeline_clock second_pipeline_clock]
   } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		return  [list ay_scan_in_clock output_clock by_clock input_pipeline_clock second_pipeline_clock]
   } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
		return [list ay_scan_in_clock output_clock by_clock input_pipeline_clock second_pipeline_clock]
   } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		return  [list ay_scan_in_clock  output_clock by_clock  input_pipeline_clock second_pipeline_clock input_systolic_clock]
  } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
		return  [list ay_scan_in_clock output_clock input_pipeline_clock second_pipeline_clock]
   } else {
		return  [list ay_scan_in_clock output_clock by_clock ]
	}
       
}


# To show clock based on supported feature and mode
# Shows available clock for OPERAND_SOURCE_MAY
proc get_used_clocks_supported_feature_preadder_may {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
		#Support Preadder feature for OPERAND_SOURCE_MAY
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			return [list az_clock]
		} 
	} elseif { [string equal [get_parameter_value operation_mode] "m18x18_full_top"] } {
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			return [list az_clock]
		} 
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Preadder feature for OPERAND_SOURCE_MAY
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			return [list az_clock]
		}
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Preadder feature for OPERAND_SOURCE_MAY
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			return [list az_clock]
		} 
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
		#Support Preadder feature for OPERAND_SOURCE_MAY
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			return [list az_clock]
		}
    }    
}

# Shows available clock for OPERAND_SOURCE_MBY
proc get_used_clocks_supported_feature_preadder_mby {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
		#Support Preadder feature for OPERAND_SOURCE_MBY
		if { [string equal [get_parameter_value operand_source_mby] "preadder"] } {
			return [list bz_clock]
		} 
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Preadder feature for OPERAND_SOURCE_MBY
		if { [string equal [get_parameter_value operand_source_mby] "preadder"] } {
			return [list bz_clock]
		}
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Preadder feature for OPERAND_SOURCE_MBY
		if { [string equal [get_parameter_value operand_source_mby] "preadder"] } {
			return [list bz_clock]
		} 
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
    }    
}

# Shows available clock for OPERAND_SOURCE_MAX
proc get_used_clocks_supported_feature_coef {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
		#Support Coef feature for OPERAND_SOURCE_MAX 
		if { [string equal [get_parameter_value operand_source_max] "coef"] } {
			return [list coef_sel_a_clock]
		}
	} elseif { [string equal [get_parameter_value operation_mode] "m18x18_full_top"] } {
		if { [string equal [get_parameter_value operand_source_max] "coef"] } {
			return [list coef_sel_a_clock]
		}
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Coef feature for OPERAND_SOURCE_MAX 
		if { [string equal [get_parameter_value operand_source_max] "coef"] } {
			return [list coef_sel_a_clock]
		}
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Coef feature for OPERAND_SOURCE_MAX 
		if { [string equal [get_parameter_value operand_source_max] "coef"] } {
			return [list coef_sel_a_clock]
		}
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
		#Support Coef feature for OPERAND_SOURCE_MAX 
		if { [string equal [get_parameter_value operand_source_max] "coef"] } {
			return [list coef_sel_a_clock]
		} 
    }    
}

# Shows available clock for OPERAND_SOURCE_MAX
proc get_used_clocks_supported_feature_input_max {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
   		#Support Input feature for OPERAND_SOURCE_MAX
		if { [string equal [get_parameter_value operand_source_max] "input"] } {
			return [list ax_clock]
		}
	} elseif { [string equal [get_parameter_value operation_mode] "m18x18_full_top"] } {
		if { [string equal [get_parameter_value operand_source_max] "input"] } {
			return [list ax_clock]
		}
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Input feature for OPERAND_SOURCE_MAX
		if { [string equal [get_parameter_value operand_source_max] "input"] } {
			return [list ax_clock]
		}
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
			return [list ax_clock]
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Input feature for OPERAND_SOURCE_MAX
		if { [string equal [get_parameter_value operand_source_max] "input"] } {
			return [list ax_clock]
		}
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
		#Support Input feature for OPERAND_SOURCE_MAX
		if { [string equal [get_parameter_value operand_source_max] "input"] } {
			return [list ax_clock]
		} 
    }    
}

# Shows available clock for OPERAND_SOURCE_MBX
proc get_used_clocks_supported_feature_input_mbx {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
   		#Support Input feature for OPERAND_SOURCE_MBX
		if { [string equal [get_parameter_value operand_source_mbx] "input"] } {
			return [list bx_clock]
		}
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Input feature for OPERAND_SOURCE_MBX
		if { [string equal [get_parameter_value operand_source_mbx] "input"] } {
			return [list bx_clock]
		}
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
			return [list bx_clock]
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Input feature for OPERAND_SOURCE_MBX
		if { [string equal [get_parameter_value operand_source_mbx] "input"] } {
			return [list bx_clock]
		}
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
    }    
}


# Shows available clock for OPERAND_SOURCE_MBX
proc get_used_clocks_supported_feature_coef_mbx {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
		#Support Coef feature for OPERAND_SOURCE_MBX 
		if { [string equal [get_parameter_value operand_source_mbx] "coef"] } {
			return [list coef_sel_b_clock]
		}
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Coef feature for OPERAND_SOURCE_MBX 
		if { [string equal [get_parameter_value operand_source_mbx] "coef"] } {
			return [list coef_sel_b_clock]
		}
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
		#return [list bx_clock]
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Coef feature for OPERAND_SOURCE_MBX 
		if { [string equal [get_parameter_value operand_source_mbx] "coef"] } {
			return [list coef_sel_b_clock]
		}
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
    }    
}

# Shows available clock for ENABLE_ACCUMULATE
proc get_used_clocks_supported_feature_accumulate {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Accumulate Feature
		if { [get_parameter_value enable_accumulate] } {
			return [list accumulate_clock accum_pipeline_clock accum_2nd_pipeline_clock]
		} 
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
		#Support Accumulate Feature
        if { [get_parameter_value enable_accumulate] } {
				return [list accumulate_clock accum_pipeline_clock accum_2nd_pipeline_clock]
		} 
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Accumulate Feature
        if { [get_parameter_value enable_accumulate] } {
				return [list accumulate_clock accum_pipeline_clock accum_2nd_pipeline_clock]
		} 
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
		#Support Accumulate Feature
		if { [get_parameter_value enable_accumulate] } {
				return [list accumulate_clock accum_pipeline_clock accum_2nd_pipeline_clock]
		} 
    }    
}

# Shows available clock for ENABLE_LOADCONST
proc get_used_clocks_supported_feature_loadconst {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Accumulate Feature
		if { [get_parameter_value enable_loadconst] } {
			return [list load_const_clock load_const_pipeline_clock load_const_2nd_pipeline_clock]
		} 
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
		#Support Accumulate Feature
        if { [get_parameter_value enable_loadconst] } {
			return [list load_const_clock load_const_pipeline_clock load_const_2nd_pipeline_clock]
		} 
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Accumulate Feature
        if { [get_parameter_value enable_loadconst] } {
			return [list load_const_clock load_const_pipeline_clock load_const_2nd_pipeline_clock]
		} 
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
		#Support Accumulate Feature
		if { [get_parameter_value enable_loadconst] } {
			return [list load_const_clock load_const_pipeline_clock load_const_2nd_pipeline_clock]
		} 
    }    
}

# Shows available clock for ENABLE_NEGATE
proc get_used_clocks_supported_feature_negate {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Accumulate Feature
		if { [get_parameter_value enable_negate] } {
			return [list negate_clock]
		} 
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
		#Support Accumulate Feature
        if { [get_parameter_value enable_negate] } {
			return [list negate_clock]
		} 
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Accumulate Feature
        if { [get_parameter_value enable_negate] } {
			return [list negate_clock]
		} 
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
		#Support Accumulate Feature
		if { [get_parameter_value enable_negate] } {
			return [list negate_clock]
		} 
    }    
}

# Shows available clock for ENABLE_SUB
proc get_used_clocks_supported_feature_sub {} {
	#Covers MODE:m18x18_full
   if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
	#Covers MODE:m18x18_sumof2
	} elseif  { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		#Support Accumulate Feature
		if { [get_parameter_value enable_sub] } {
			return [list sub_clock]
		} 
	#Covers MODE:m18x18_plus36	
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_plus36"] } {
		#Support Accumulate Feature
        if { [get_parameter_value enable_sub] } {
			return [list sub_clock]
		} 
	#Covers MODE:m18x18_systolic		
    } elseif  { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		#Support Accumulate Feature
        if { [get_parameter_value enable_sub] } {
			return [list sub_clock]
		} 
	#Covers MODE:m27x27
    } elseif  { [string equal [get_parameter_value operation_mode] "m27x27"] } {
	
    }    
}

# For PREADDER_SUBTRACT_A
proc get_used_opr_str {} {
	if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			return [list preadder_subtract_a]
		}
	} elseif { [string equal [get_parameter_value operation_mode] "m18x18_full_top"] } {
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			return [list preadder_subtract_a]
		}
	} elseif { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			 return [list preadder_subtract_a]
		}
	} elseif { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			 return [list preadder_subtract_a]
		}
	} elseif { [string equal [get_parameter_value operation_mode] "m27x27"] } {
		if { [string equal [get_parameter_value operand_source_may] "preadder"] } {
			 return [list preadder_subtract_a]
		}
	}
}

# For PREADDER_SUBTRACT_B
proc get_used_opr_str_B {} {
	if { [string equal [get_parameter_value operation_mode] "m18x18_full"] } {
		if { [string equal [get_parameter_value operand_source_mby] "preadder"] } {
			return [list preadder_subtract_b]
		}
	} elseif { [string equal [get_parameter_value operation_mode] "m18x18_sumof2"] } {
		if { [string equal [get_parameter_value operand_source_mby] "preadder"] } {
			return [list preadder_subtract_b]
		}
	} elseif { [string equal [get_parameter_value operation_mode] "m18x18_systolic"] } {
		if { [string equal [get_parameter_value operand_source_mby] "preadder"] } {
			return [list preadder_subtract_b]
		}
	} 
}

#For preadder selection
proc preadder_input {} {
	return [ list operand_source_may operand_source_mby]
}

#For Coefficient selection
proc coef_input {} {
	return [ list operand_source_max operand_source_mbx]
}

#For settings with boolean false settings
proc boolean_false {} {
	return [ list   ay_use_scan_in by_use_scan_in delay_scan_out_ay delay_scan_out_by enable_chainin enable_double_accum chainout_enable enable_scanout enable_accumulate enable_sub enable_negate enable_loadconst enable_clkena0 enable_clkena1 enable_clkena2 clock1_show clock2_show enable_clr0 enable_clr1]
}
#For settings with boolean true settings
proc boolean_true {} {
	return [ list  clock0_show]
}
#For operation settings
proc operation_input {} {
	return [list preadder_subtract_a]
}

#For operation settings
proc operation_input_b {} {
	return [list  preadder_subtract_b]
}

#For Preadder/input settings
foreach sup_param [preadder_input] {
	 add_parameter $sup_param string input
	 set_parameter_property $sup_param VISIBLE false
} 
#For Coef/Input settings
foreach sup_param [coef_input] {
	 add_parameter $sup_param string input
	 set_parameter_property $sup_param VISIBLE false
} 
#For boolean false settings
foreach sup_param [boolean_false] {
	 add_parameter $sup_param string false
	 set_parameter_property $sup_param VISIBLE false
} 
#For boolean true settings
foreach sup_param [boolean_true] {
	 add_parameter $sup_param string true
	 set_parameter_property $sup_param VISIBLE false
} 
#For operation settings
foreach sup_param [operation_input] {
	 add_parameter $sup_param string "+"
	 set_parameter_property $sup_param VISIBLE false
} 

#For operation settings
foreach sup_param [operation_input_b] {
	 add_parameter $sup_param string "+"
	 set_parameter_property $sup_param VISIBLE false
} 
# For common clocks		
foreach clock [get_clocks] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}  

#For operand_source_may
foreach clock [feature_clocks_preadder_may] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
} 

#For operand_source_mby
foreach clock [feature_clocks_preadder_mby] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
} 

#For enable_accumulate
foreach clock [feature_clocks_accumulate] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}
	
#For enable_loadconst
foreach clock [feature_clocks_loadconst] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}

#For enable_negate
foreach clock [feature_clocks_negate] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}

#For enable_sub
foreach clock [feature_clocks_sub] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}
#For operand_source_max
foreach clock [feature_clocks_coef] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}
	
#For operand_source_max
foreach clock [feature_clocks_input_max] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}

# For operand_source_mbx
foreach clock [feature_clocks_coef_mbx] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}

# For operand_source_mbx
foreach clock [feature_clocks_input_mbx] {
	add_parameter $clock string "0"
	set_parameter_property $clock VISIBLE false
}
# For hdl_clock
foreach clock [get_hdl_clocks] {
	add_parameter "${clock}_derived" string "0"
	set_parameter_property "${clock}_derived" VISIBLE false
	set_parameter_property "${clock}_derived" derived true
}

# All avaliable register parameters view - For java widget pass in
add_parameter checklist_all_register_list string "0"
set_parameter_property checklist_all_register_list VISIBLE false
set_parameter_property checklist_all_register_list derived true

# Supported register parameter in current mode and features - For java widget pass in
add_parameter checklist_current_mode_support_register string "0"
set_parameter_property checklist_current_mode_support_register VISIBLE false
set_parameter_property checklist_current_mode_support_register derived true

# All avaliable parameter include register - For java widget pass in
add_parameter checklist_all_parameter string "0"
set_parameter_property checklist_all_parameter VISIBLE false
set_parameter_property checklist_all_parameter derived true

# Supported register parameter in current mode and features for PREADDER_SUBTRACT_A/B - For java widget pass in
add_parameter checklist_current_mode_support_oprstr string "0"
set_parameter_property checklist_current_mode_support_oprstr VISIBLE false
set_parameter_property checklist_current_mode_support_oprstr derived true

# Supported register parameter in current mode and features for PREADDER_SUBTRACT_A/B - For java widget pass in
add_parameter checklist_current_mode_support_oprstr_B string "0"
set_parameter_property checklist_current_mode_support_oprstr_B VISIBLE false
set_parameter_property checklist_current_mode_support_oprstr_B derived true

# Supported register parameter in current mode and features - For java widget pass in
add_parameter checklist_all_operation string "0"
set_parameter_property checklist_all_operation VISIBLE false
set_parameter_property checklist_all_operation derived true

# Supported register parameter in current mode and features - For java widget pass in
add_parameter checklist_all_operation_b string "0"
set_parameter_property checklist_all_operation_b VISIBLE false
set_parameter_property checklist_all_operation_b derived true

# Supported register parameter in current mode and features for OPERAND_SOURCE_MAY - For java widget pass in
add_parameter checklist_current_mode_feature_preadder_may_support_register string "0"
set_parameter_property checklist_current_mode_feature_preadder_may_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_preadder_may_support_register derived true

# All avaliable register parameters view for OPERAND_SOURCE_MAY- For java widget pass in
add_parameter checklist_feature_preadder_may_all_register_list string "0"
set_parameter_property checklist_feature_preadder_may_all_register_list VISIBLE false
set_parameter_property checklist_feature_preadder_may_all_register_list derived true

# Supported register parameter in current mode and features for OPERAND_SOURCE_MBY- For java widget pass in
add_parameter checklist_current_mode_feature_preadder_mby_support_register string "0"
set_parameter_property checklist_current_mode_feature_preadder_mby_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_preadder_mby_support_register derived true

# All avaliable register parameters view for OPERAND_SOURCE_MBY- For java widget pass in
add_parameter checklist_feature_preadder_mby_all_register_list string "0"
set_parameter_property checklist_feature_preadder_mby_all_register_list VISIBLE false
set_parameter_property checklist_feature_preadder_mby_all_register_list derived true

# All avaliable register parameters view for ENABLE_ACCUMULATE- For java widget pass in
add_parameter checklist_feature_accumulate_all_register_list string "0"
set_parameter_property checklist_feature_accumulate_all_register_list VISIBLE false
set_parameter_property checklist_feature_accumulate_all_register_list derived true

# Supported register parameter in current mode and features for ENABLE_ACCUMULATE- For java widget pass in
add_parameter checklist_current_mode_feature_accumulate_support_register string "0"
set_parameter_property checklist_current_mode_feature_accumulate_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_accumulate_support_register derived true

# All avaliable register parameters view for ENABLE_LOADCONST- For java widget pass in
add_parameter checklist_feature_loadconst_all_register_list string "0"
set_parameter_property checklist_feature_loadconst_all_register_list VISIBLE false
set_parameter_property checklist_feature_loadconst_all_register_list derived true

# Supported register parameter in current mode and features for ENABLE_LOADCONST - For java widget pass in
add_parameter checklist_current_mode_feature_loadconst_support_register string "0"
set_parameter_property checklist_current_mode_feature_loadconst_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_loadconst_support_register derived true

# All avaliable register parameters view for ENABLE_NEGATE - For java widget pass in
add_parameter checklist_feature_negate_all_register_list string "0"
set_parameter_property checklist_feature_negate_all_register_list VISIBLE false
set_parameter_property checklist_feature_negate_all_register_list derived true

# Supported register parameter in current mode and features for ENABLE_NEGATE - For java widget pass in 
add_parameter checklist_current_mode_feature_negate_support_register string "0"
set_parameter_property checklist_current_mode_feature_negate_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_negate_support_register derived true

# All avaliable register parameters view for ENABLE_SUB - For java widget pass in
add_parameter checklist_feature_sub_all_register_list string "0"
set_parameter_property checklist_feature_sub_all_register_list VISIBLE false
set_parameter_property checklist_feature_sub_all_register_list derived true

# Supported register parameter in current mode and features for ENABLE_SUB - For java widget pass in
add_parameter checklist_current_mode_feature_sub_support_register string "0"
set_parameter_property checklist_current_mode_feature_sub_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_sub_support_register derived true

# All avaliable register parameters view for OPERAND_SOURCE_MAX - For java widget pass in
add_parameter checklist_feature_coef_all_register_list string "0"
set_parameter_property checklist_feature_coef_all_register_list VISIBLE false
set_parameter_property checklist_feature_coef_all_register_list derived true

	
# All avaliable register parameters view for OPERAND_SOURCE_MAX - For java widget pass in
add_parameter checklist_feature_input_max_all_register_list string "0"
set_parameter_property checklist_feature_input_max_all_register_list VISIBLE false
set_parameter_property checklist_feature_input_max_all_register_list derived true

# All avaliable register parameters view for OPERAND_SOURCE_MAX - For java widget pass in
add_parameter checklist_feature_input_mbx_all_register_list string "0"
set_parameter_property checklist_feature_input_mbx_all_register_list VISIBLE false
set_parameter_property checklist_feature_input_mbx_all_register_list derived true

# Supported register parameter in current mode and features for OPERAND_SOURCE_MAX - For java widget pass in 
add_parameter checklist_current_mode_feature_coef_support_register string "0"
set_parameter_property checklist_current_mode_feature_coef_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_coef_support_register derived true

# All avaliable register parameters view for OPERAND_SOURCE_MBX- For java widget pass in
add_parameter checklist_feature_coef_mbx_all_register_list string "0"
set_parameter_property checklist_feature_coef_mbx_all_register_list VISIBLE false
set_parameter_property checklist_feature_coef_mbx_all_register_list derived true

# Supported register parameter in current mode and OPERAND_SOURCE_MBX features - For java widget pass in
add_parameter checklist_current_mode_feature_coef_mbx_support_register string "0"
set_parameter_property checklist_current_mode_feature_coef_mbx_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_coef_mbx_support_register derived true

# test
# Supported register parameter in current mode and features for OPERAND_SOURCE_MAX - For java widget pass in 
add_parameter checklist_current_mode_feature_input_max_support_register string "0"
set_parameter_property checklist_current_mode_feature_input_max_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_input_max_support_register derived true

# Supported register parameter in current mode and features for OPERAND_SOURCE_MAX - For java widget pass in 
add_parameter checklist_current_mode_feature_input_mbx_support_register string "0"
set_parameter_property checklist_current_mode_feature_input_mbx_support_register VISIBLE false
set_parameter_property checklist_current_mode_feature_input_mbx_support_register derived true

set_display_item_property widget_group WIDGET_PARAMETER_MAP  {
			operation_mode   operation_mode
            VIEW  VIEW
			checklist_all_register_list	checklist_all_register_list
			checklist_current_mode_support_register        checklist_current_mode_support_register
			checklist_all_parameter	checklist_all_parameter
            ax_clock             ax_clock
            ay_scan_in_clock             ay_scan_in_clock
            az_clock             az_clock
            output_clock             output_clock
            accumulate_clock             accumulate_clock
            accum_pipeline_clock             accum_pipeline_clock
			bx_clock   bx_clock
			bz_clock   bz_clock
			by_clock   by_clock
			coef_sel_a_clock   coef_sel_a_clock
			coef_sel_b_clock   coef_sel_b_clock
			sub_clock     sub_clock
			negate_clock   negate_clock
			accum_2nd_pipeline_clock   accum_2nd_pipeline_clock
			load_const_clock   load_const_clock
			load_const_pipeline_clock  load_const_pipeline_clock
			load_const_2nd_pipeline_clock   load_const_2nd_pipeline_clock
			input_pipeline_clock   input_pipeline_clock
			second_pipeline_clock  second_pipeline_clock
			input_systolic_clock   input_systolic_clock
			ax_width    ax_width
			ay_scan_in_width   ay_scan_in_width
			az_width    az_width
			bx_width  bx_width
			by_width  by_width
			bz_width   bz_width
			operand_source_max   operand_source_max
			operand_source_may   operand_source_may
			operand_source_mbx   operand_source_mbx
			operand_source_mby   operand_source_mby
			signed_max    signed_max
			signed_may    signed_may
			signed_mbx    signed_mbx
			signed_mby    signed_mby
			preadder_subtract_a    preadder_subtract_a
			preadder_subtract_b    preadder_subtract_b
			ay_use_scan_in      ay_use_scan_in
			by_use_scan_in      by_use_scan_in
			delay_scan_out_ay   delay_scan_out_ay
			enable_chainin    enable_chainin
			delay_scan_out_by   delay_scan_out_by
			enable_double_accum    enable_double_accum
			load_const_value     load_const_value
			coef_a_0    coef_a_0
			coef_a_1    coef_a_1
			coef_a_2    coef_a_2
			coef_a_3    coef_a_3
			coef_a_4    coef_a_4
			coef_a_5    coef_a_5
			coef_a_6    coef_a_6
			coef_a_7    coef_a_7
			coef_b_0    coef_b_0
			coef_b_1    coef_b_1
			coef_b_2    coef_b_2
			coef_b_3    coef_b_3
			coef_b_4    coef_b_4
			coef_b_5    coef_b_5
			coef_b_6    coef_b_6
			coef_b_7    coef_b_7
			scan_out_width   scan_out_width
			result_a_width   result_a_width
			result_b_width   result_b_width
			chainout_enable  chainout_enable
			clear_type   clear_type
			enable_scanout   enable_scanout
			enable_accumulate   enable_accumulate
			enable_sub    enable_sub
			enable_negate   enable_negate
			chain_mux       chain_mux
			enable_loadconst   enable_loadconst
			enable_bx       enable_bx
			enable_by       enable_by
			enable_bz       enable_bz
			enable_result	enable_result
			enable_clr0     enable_clr0
			enable_clr1     enable_clr1
			enable_clkena0  enable_clkena0
			enable_clkena1  enable_clkena1
			enable_clkena2  enable_clkena2
			checklist_current_mode_support_oprstr		checklist_current_mode_support_oprstr
			checklist_current_mode_support_oprstr_B   checklist_current_mode_support_oprstr_B
			checklist_all_operation 		checklist_all_operation
			clock0_show			clock0_show
			clock1_show			clock1_show
			clock2_show			clock2_show
			checklist_current_mode_feature_preadder_may_support_register     checklist_current_mode_feature_preadder_may_support_register
			checklist_feature_preadder_may_all_register_list    checklist_feature_preadder_may_all_register_list
			checklist_current_mode_feature_preadder_mby_support_register     checklist_current_mode_feature_preadder_mby_support_register
			checklist_feature_preadder_mby_all_register_list    checklist_feature_preadder_mby_all_register_list
			checklist_feature_accumulate_all_register_list	 checklist_feature_accumulate_all_register_list
			checklist_current_mode_feature_accumulate_support_register  checklist_current_mode_feature_accumulate_support_register
			checklist_feature_loadconst_all_register_list	 checklist_feature_loadconst_all_register_list
			checklist_current_mode_feature_loadconst_support_register  checklist_current_mode_feature_loadconst_support_register
			checklist_feature_negate_all_register_list	 checklist_feature_negate_all_register_list
			checklist_current_mode_feature_negate_support_register  checklist_current_mode_feature_negate_support_register
			checklist_feature_sub_all_register_list	 checklist_feature_sub_all_register_list
			checklist_current_mode_feature_sub_support_register  checklist_current_mode_feature_sub_support_register
			checklist_feature_coef_all_register_list	checklist_feature_coef_all_register_list
			checklist_current_mode_feature_coef_support_register  checklist_current_mode_feature_coef_support_register
			checklist_feature_coef_mbx_all_register_list	 checklist_feature_coef_mbx_all_register_list
			checklist_current_mode_feature_coef_mbx_support_register  checklist_current_mode_feature_coef_mbx_support_register
			checklist_all_operation_b	checklist_all_operation_b
			checklist_feature_input_max_all_register_list   checklist_feature_input_max_all_register_list
			checklist_current_mode_feature_input_max_support_register  checklist_current_mode_feature_input_max_support_register
			checklist_feature_input_mbx_all_register_list   checklist_feature_input_mbx_all_register_list
			checklist_current_mode_feature_input_mbx_support_register  checklist_current_mode_feature_input_mbx_support_register
}       


proc add_filesets {} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset" 
    }
}

proc get_simulator_list {} {
    return { \
             {mentor   0   } \ #0
             {aldec    0    } \ #0
             {synopsys 0 } \ #0
             {cadence  0  } \ #0
           }
}

# | 
# +-----------------------------------



proc add_interface_input { name bit_width } {
    add_interface $name conduit end
    set_interface_property $name associatedClock clk
    set_interface_property $name associatedReset areset
    set_interface_property $name ENABLED true
    add_interface_port $name $name $name Input $bit_width 
}

proc add_interface_output { name bit_width } {
    add_interface $name conduit start
    set_interface_assignment $name "ui.blockdiagram.direction" OUTPUT
    set_interface_property $name associatedClock clk
    set_interface_property $name associatedReset ""
    add_interface_port $name $name $name Output $bit_width
}


proc elab {} {
	#get_supported_param 
	interface_ports_and_mapping
	
	# To construct information for Widget
	set_parameter_value checklist_all_register_list  [join [get_clocks] ","]
    set_parameter_value checklist_current_mode_support_register [join [get_used_clocks] ","]
	set_parameter_value checklist_all_parameter [join [get_parameters_list] ","]
	set_parameter_value checklist_current_mode_support_oprstr [join [get_used_opr_str] ","]
	set_parameter_value checklist_all_operation  [join [operation_input] ","]
	set_parameter_value checklist_all_operation_b  [join [operation_input_b] ","]
	set_parameter_value checklist_current_mode_support_oprstr_B [join [get_used_opr_str_B] ","]
	
	# For Parameter Preadder_MAY
	set_parameter_value checklist_feature_preadder_may_all_register_list  [join [feature_clocks_preadder_may] ","]
	set_parameter_value checklist_current_mode_feature_preadder_may_support_register [join [get_used_clocks_supported_feature_preadder_may] ","]
	# For Parameter Preadder_MBY
	set_parameter_value checklist_feature_preadder_mby_all_register_list  [join [feature_clocks_preadder_mby] ","]
	set_parameter_value checklist_current_mode_feature_preadder_mby_support_register [join [get_used_clocks_supported_feature_preadder_mby] ","]
	# For Parameter ACCUMULATE
	set_parameter_value checklist_feature_accumulate_all_register_list  [join [feature_clocks_accumulate] ","]
	set_parameter_value checklist_current_mode_feature_accumulate_support_register [join [get_used_clocks_supported_feature_accumulate] ","]
	# For Parameter LOADCONST
	set_parameter_value checklist_feature_loadconst_all_register_list  [join [feature_clocks_loadconst] ","]
	set_parameter_value checklist_current_mode_feature_loadconst_support_register [join [get_used_clocks_supported_feature_loadconst] ","]
	# For Parameter NEGATE
	set_parameter_value checklist_feature_negate_all_register_list  [join [feature_clocks_negate] ","]
	set_parameter_value checklist_current_mode_feature_negate_support_register [join [get_used_clocks_supported_feature_negate] ","]
	#For Parameter SUB
	set_parameter_value checklist_feature_sub_all_register_list  [join [feature_clocks_sub] ","]
	set_parameter_value checklist_current_mode_feature_sub_support_register [join [get_used_clocks_supported_feature_sub] ","]
	#For Parameter COEF
	set_parameter_value checklist_feature_coef_all_register_list  [join [feature_clocks_coef] ","]
	set_parameter_value checklist_current_mode_feature_coef_support_register [join [get_used_clocks_supported_feature_coef] ","]
	#For Parameter COEF_MBX
	set_parameter_value checklist_feature_coef_mbx_all_register_list  [join [feature_clocks_coef_mbx] ","]
	set_parameter_value checklist_current_mode_feature_coef_mbx_support_register [join [get_used_clocks_supported_feature_coef_mbx] ","]
	#For Parameter INPUT_MAX
	set_parameter_value checklist_feature_input_max_all_register_list  [join [feature_clocks_input_max] ","]
	set_parameter_value checklist_current_mode_feature_input_max_support_register [join [get_used_clocks_supported_feature_input_max] ","]
	#For Parameter INPUT_MBX
	set_parameter_value checklist_feature_input_mbx_all_register_list  [join [feature_clocks_input_mbx] ","]
	set_parameter_value checklist_current_mode_feature_input_mbx_support_register [join [get_used_clocks_supported_feature_input_mbx] ","]
	
}

proc quartus_synth_callback {output_name} {  
    set type synth

    set filename ${output_name}.sv ;# dependent on what Qsys gives us as the output name
    set terp_file "dsp_block.sv.template"
    set top_level_contents [render_terp $output_name $terp_file]
    add_fileset_file $filename SYSTEM_VERILOG TEXT $top_level_contents TOP_LEVEL_FILE

}

proc add_filesets {} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset" 
    }
}

proc generate_sim_verilog {output_name} {
    set type synth
	
	send_message info "Verilog:generating top-level entity $output_name"
	set terp_file "dsp_block.sv.template"
	set filename ${output_name}.v ;# dependent on what Qsys gives us as the output name
    set top_level_contents [render_terp $output_name $terp_file]
	add_fileset_file $filename SYSTEM_VERILOG TEXT $top_level_contents TOP_LEVEL_FILE
}
#For VHDL Output generation
proc generate_sim_vhdl {output_name} {
    set type synth
	
	send_message info "VHDL:generating top-level entity $output_name"
    set filename ${output_name}.vhd ;# dependent on what Qsys gives us as the output name
	set terp_file "dsp_block.vhd.template"
    set top_level_contents [render_terp $output_name $terp_file]
	add_fileset_file $filename VHDL TEXT $top_level_contents TOP_LEVEL_FILE

}

#Error message List
proc validate {} {
	#LEGALITY UPDATE AS REVIEWED - 15/03/16
	#dsp_leg_nd_hwtcl_23
	if { ([get_parameter_value ax_width] < 1 || [get_parameter_value ax_width] > 18) && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operand_source_max] == "input" } {
		send_message ERROR "AX input bus width should be greater than or equal 1 and smaller equal to 18 in the selected mode"
	}
	#dsp_leg_nd_hwtcl_24
	if { ([get_parameter_value bx_width] < 1 || [get_parameter_value bx_width] > 18) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_full_top") && [get_parameter_value operand_source_mbx] == "input" } {
		send_message ERROR "BX input bus width should be greater than or equal 1 and smaller equal to 18 in the selected mode"
	}
	#dsp_leg_nd_hwtcl_27
	if { ([get_parameter_value ay_scan_in_width] < 1 || [get_parameter_value ay_scan_in_width] > 19) && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operand_source_may] == "input" && [get_parameter_value signed_may] == "Unsigned" } {
		send_message ERROR "When 'ay' width is 19-bit, the representation format for top multiplier's operand (signed_may) must be set 'Signed'"
	}
	#dsp_leg_nd_hwtcl_28a
	if { ([get_parameter_value ay_scan_in_width] < 1 || [get_parameter_value ay_scan_in_width] > 18) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36") && (([get_parameter_value operand_source_may] == "input" && [get_parameter_value signed_may] == "Unsigned") || ( [get_parameter_value operand_source_may] == "preadder" && [get_parameter_value signed_may] == "Signed" )) } {
		send_message ERROR "The pre-adder supports a maximum of 18-bit (unsigned) input operand for 18x18 style addition. 'ay' or 'scanin' bus width setting under 'Data 'y' configuration must be set to 18 or less."
	}
	#dsp_leg_nd_hwtcl_28b
	if { ([get_parameter_value ay_scan_in_width] < 1 || [get_parameter_value ay_scan_in_width] > 17) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36") && [get_parameter_value operand_source_may] == "preadder" && [get_parameter_value signed_may] == "Unsigned" } {
		send_message ERROR "ay' or 'scanin' bus width value must be in the range of 1-17 bit if unsigned preadder is used"
	}
	#dsp_leg_nd_hwtcl_29
	if { ([get_parameter_value by_width] < 1 || [get_parameter_value by_width] > 19) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_full_top")  && [get_parameter_value operand_source_mby] == "input" && [get_parameter_value signed_mby] == "Unsigned" && [get_parameter_value by_use_scan_in] == "false"} {
		send_message ERROR "'by' input bus width value must be in the range of 1-19 bit if the (signed_mby) set to 'Signed'"
	}
	#dsp_leg_nd_hwtcl_30a
	if { ([get_parameter_value by_width] < 1 || [get_parameter_value by_width] > 18) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36") && (([get_parameter_value operand_source_mby] == "input" && [get_parameter_value signed_mby] == "Unsigned" ) || ([get_parameter_value operand_source_mby] == "preadder" && [get_parameter_value signed_mby] == "Signed" )) && [get_parameter_value by_use_scan_in] == "false" && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		send_message ERROR "The Pre-adder supports a maximum of 18-bit (signed/unisgned) input operand for 18x18 style addition. 'by' input bus width setting under Data 'y' configuration must be set to 18 or less."
	}
	#dsp_leg_nd_hwtcl_30b
	if { ([get_parameter_value by_width] < 1 || [get_parameter_value by_width] > 17) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top" ) && [get_parameter_value operand_source_mby] == "preadder" && [get_parameter_value signed_mby] == "Unsigned" && [get_parameter_value by_use_scan_in] == "false" } {
		send_message ERROR "'by' input bus width value must be in the range of 1-17 bit if unsigned preadder is used"
	}
	#dsp_leg_nd_hwtcl_31a
	if { ([get_parameter_value az_width] < 1 || [get_parameter_value az_width] > 18) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36") && [get_parameter_value operand_source_may] == "preadder" && [get_parameter_value signed_may] == "Signed" } {
		send_message ERROR "'az_width' value must be in the range of 1-18 bit when using signed"
	}
	#dsp_leg_nd_hwtcl_31b
	if {([get_parameter_value az_width] < 1 || [get_parameter_value az_width] > 17) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36") && [get_parameter_value operand_source_may] == "preadder" && [get_parameter_value signed_may] == "Unsigned" } {
		send_message ERROR "'az_width' value must be in the range of 1-17 bit when using unsigned"
	}
	#dsp_leg_nd_hwtcl_32a
	if { ([get_parameter_value bz_width] < 1 || [get_parameter_value bz_width] > 18) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top" ) && [get_parameter_value operand_source_mby] == "preadder" && [get_parameter_value signed_mby] == "Signed" } {
		send_message ERROR "'bz_width' value must be in the range of 1-18 when signed preadder is used."
	}
	#dsp_leg_nd_hwtcl_32b
	if { ([get_parameter_value bz_width] < 1 || [get_parameter_value bz_width] > 17) && ([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top" ) && [get_parameter_value operand_source_mby] == "preadder" && [get_parameter_value signed_mby] == "Unsigned" } {
		send_message ERROR "'bz_width' value must be in the range of 1-17 when using unsigned preadder"
	}
	#dsp_leg_nd_34
	if { [get_parameter_value bx_width] != 18 && [get_parameter_value operation_mode] == "m18x18_plus36" } {
		send_message ERROR "bx_width must be set as 18 when using m18x18_plus36 mode"
	}
	#dsp_leg_nd_35
	if { [get_parameter_value by_width] != 18 && [get_parameter_value operation_mode] == "m18x18_plus36" } {
		send_message ERROR "by_width must be set as 18 when using m18x18_plus36 mode"
	}
	#dsp_leg_nd__hwtcl_37
	if { ([get_parameter_value ax_width] < 1 || [get_parameter_value ax_width] > 27) && [get_parameter_value operation_mode] == "m27x27" && [get_parameter_value operand_source_max] == "input" } {
		send_message ERROR "'ax_width' must be set in the range of 1-27 when using m27x27"
	}
	#dsp_leg_nd_hwtcl_38
	if { ([get_parameter_value ay_scan_in_width] < 1 || [get_parameter_value ay_scan_in_width] > 27) && [get_parameter_value operation_mode] == "m27x27" && [get_parameter_value operand_source_may] == "input" } {
		send_message ERROR "'ay_scan_in_width' value must be in the range of 1-27 bit if preadder is not used"
	}
	#dsp_leg_nd_hwtcl_39
	if { ([get_parameter_value ay_scan_in_width] < 1 || [get_parameter_value ay_scan_in_width] > 26) && [get_parameter_value operation_mode] == "m27x27" && [get_parameter_value operand_source_may] == "preadder" } {
		send_message ERROR "ay_scan_in_width' value must be in the range of 1-26 when preadder used in m27x27"
	}
	#dsp_leg_nd_hwtcl_40
	if { ([get_parameter_value az_width] < 1 || [get_parameter_value az_width] > 26) && [get_parameter_value operation_mode] == "m27x27" && [get_parameter_value operand_source_may] == "preadder" } {
		send_message ERROR "'az_width' value must be in the range of 1-26 when using m27x27 mode"
	}
	#dsp_leg_nd_hwtcl_41
	if { ([get_parameter_value bx_width] != 0 || [get_parameter_value by_width] != 0 || [get_parameter_value bz_width] != 0) && [get_parameter_value operation_mode] == "m27x27" } {
		send_message ERROR "'bx_width','by_width' and 'bz_width' must set to 0 when using m27x27 mode"
	}
	#dsp_leg_nd_hwtcl_128
	if { ([get_parameter_value bx_width] != 0 || [get_parameter_value by_width] != 0 || [get_parameter_value bz_width] != 0) && [get_parameter_value operation_mode] == "m18x18_full_top" } {
		send_message ERROR "'bx_width','by_width' and 'bz_width' must set to 0 when using m18x18_full_top mode"
	}
	
	#@sukumar new legality testing
	#dsp_leg_nd_hwtcl_130
	if { ([get_parameter_value bx_width] == 0 && [get_parameter_value by_width] == 0 && [get_parameter_value result_b_width] == 0) && [get_parameter_value operation_mode] == "m18x18_full" } {
		send_message ERROR "Please change to Mode m18x18_full_top if only top level is used "
	}
	
	#dsp_leg_nd_hwtcl_16
	if { ([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic" || [get_parameter_value operation_mode] == "m27x27" || [get_parameter_value operation_mode] == "m18x18_full_top") && [get_parameter_value operand_source_may] == "input" && [get_parameter_value az_width] != 0 } {
		send_message ERROR "'az' input bus width needs to be set '0' when preadder is not used"
	}
	#dsp_leg_nd_hwtcl_17
	if { ([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic") && [get_parameter_value operand_source_mby] == "input" && [get_parameter_value bz_width] != 0 } {
		send_message ERROR "'bz' input bus width needs to be set '0' when preadder is not used"
	}
	#dsp_leg_nd_hwtcl_1
	if { ([get_parameter_value result_a_width] <= 1 || [get_parameter_value result_a_width] > 64 ) && ( [get_parameter_value operation_mode] == "m27x27" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic" || [get_parameter_value operation_mode] == "m18x18_plus36") } {
		send_message ERROR "'result_a_width' must be in the range of 1-64 in modes other than m18x18_full"
	}
	#dsp_leg_nd_hwtcl_2
	if { ([get_parameter_value result_a_width] <=1 || [get_parameter_value result_a_width] > 37 ) && ([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_full_top") } {
		send_message ERROR "Result_a_width must be in the range of 1-37 when using m18x18_full and m18x18_full_top mode"
	}
	#dsp_leg_nd_hwtcl_47
	if { [get_parameter_value result_b_width] != 0 && [get_parameter_value operation_mode] != "m18x18_full"} {
		send_message ERROR "result_b_width is not supported in other than m18x18_full mode"
	}
	#dsp_leg_nd_hwtcl_3
	if { ([get_parameter_value result_b_width] <= 1 || [get_parameter_value result_b_width] > 37 ) && [get_parameter_value result_b_width] != 0 && [get_parameter_value operation_mode] == "m18x18_full" } {
		send_message ERROR "'result_b_width' must be in the range of 1-37"
	}
	#dsp_leg_nd_49
	if { [get_parameter_value signed_mby] != "Unsigned" && [get_parameter_value operation_mode] == "m18x18_plus36" } {
		send_message ERROR "Current mode only supports unsigned representation for by input ports"
	}

	#dsp_leg_nd_hwtcl_50a1
	if { ([get_parameter_value enable_sub] == "true") && ((([get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic" || [get_parameter_value operation_mode] == "m18x18_plus36") && ( [get_parameter_value signed_max] == "Unsigned" || [get_parameter_value signed_may] == "Unsigned" || [get_parameter_value signed_mbx] == "Unsigned" || ([get_parameter_value signed_mby] == "Unsigned" && [get_parameter_value operation_mode] != "m18x18_plus36"))))} {
		send_message ERROR "When 'sub' is used, all the operand need to be set to signed"
	}
	#dsp_leg_nd_hwtcl_50a2
	if { ([get_parameter_value enable_negate] == "true") && ((([get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic" || [get_parameter_value operation_mode] == "m18x18_plus36") && ( [get_parameter_value signed_max] == "Unsigned" || [get_parameter_value signed_may] == "Unsigned" || [get_parameter_value signed_mbx] == "Unsigned" || ([get_parameter_value signed_mby] == "Unsigned" && [get_parameter_value operation_mode] != "m18x18_plus36"))) || ([get_parameter_value operation_mode] == "m27x27" && ([get_parameter_value signed_max] == "Unsigned" || [get_parameter_value signed_may] == "Unsigned" )))} {
		send_message ERROR "When 'negate' is used, all the operand need to be set to signed"
	}
	#dsp_leg_nd_hwtcl_52a
	if { (([get_parameter_value operand_source_may] == "preadder" && [get_parameter_value operand_source_mby] == "input") || ([get_parameter_value operand_source_may] == "input" && [get_parameter_value operand_source_mby] == "preadder" )) && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		send_message ERROR "When preadder feature is used, both 'operand_source_may' and 'operand_source_mby' must be set to preadder"
	}
	
	#dsp_leg_nd_hwtcl_53 --disbaled sukumar test as below
	#if { ([get_parameter_value preadder_subtract_a] != [get_parameter_value preadder_subtract_b]) && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		#send_message ERROR "The preadder operation for both 'top preadder' and 'bottom preadder' must be the same"
	#}
	
	#dsp_leg_nd_hwtcl_53 -- test --PASS
	if { ([get_parameter_value operand_source_may] == "preadder" && [get_parameter_value operand_source_mby] == "preadder") && ([get_parameter_value preadder_subtract_b] != [get_parameter_value preadder_subtract_a] )&& [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		send_message ERROR "The preadder operation for both 'top preadder' and 'bottom preadder' must be the same"
	}

	#dsp_leg_nd_hwtcl_54  --disabled sukumar test as below
	#if { ([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic" || [get_parameter_value operation_mode] == "m27x27" || [get_parameter_value operation_mode] == "m18x18_full_top" ) && ([get_parameter_value preadder_subtract_a] == "-" && [get_parameter_value signed_may] == "Unsigned") ||([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic") && ([get_parameter_value preadder_subtract_b] == "-" && [get_parameter_value signed_mby] == "Unsigned") } {
		#send_message ERROR "Signed representation need to be used when using preadder subtraction"
	#}
	
	#dsp_leg_nd_hwtcl_54   --test
	if { ([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic" || [get_parameter_value operation_mode] == "m27x27" || [get_parameter_value operation_mode] == "m18x18_full_top" ) && ([get_parameter_value operand_source_may] == "preadder" && [get_parameter_value preadder_subtract_a] == "-" && [get_parameter_value signed_may] == "Unsigned") ||([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic") && ([get_parameter_value operand_source_mby] == "preadder" && [get_parameter_value preadder_subtract_b] == "-" && [get_parameter_value signed_mby] == "Unsigned") } {
		send_message ERROR "Signed representation need to be used when using preadder subtraction"
	}
	
	#dsp_leg_nd_hwtcl_55 --- sukumar test 
	#if { ([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic" || [get_parameter_value operation_mode] == "m27x27" || [get_parameter_value operation_mode] == "m18x18_full_top" ) && [get_parameter_value preadder_subtract_a] == "-" && [get_parameter_value operand_source_may] != "preadder" } {
		#send_message ERROR "Preadder_subtract_a can only be supported when preadder is used"
	#}
	
	#dsp_leg_nd_hwtcl_56 --- sukumar test
	#if { ([get_parameter_value operation_mode] == "m18x18_full" || [get_parameter_value operation_mode] == "m18x18_sumof2" || [get_parameter_value operation_mode] == "m18x18_systolic" || [get_parameter_value operation_mode] == "m18x18_full" ) && [get_parameter_value preadder_subtract_b] == "-" && [get_parameter_value operand_source_mby] != "preadder" } {
		#send_message ERROR "Preadder_subtract_b can only be supported when preadder is used"
	#}
	
	#dsp_leg_nd_hwtcl_59a
	if { (([get_parameter_value operand_source_max] == "coef" && [get_parameter_value operand_source_mbx] == "input") || ([get_parameter_value operand_source_max] == "input" && [get_parameter_value operand_source_mbx] == "coef" )) && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top"} {
		send_message ERROR "When Coeffcient is used, both param 'operand_source_max' or 'operand_source_mbx' must be set to COEF"
	}
	
	#dsp_leg_nd_hwtcl_62
	if { [get_parameter_value ay_use_scan_in] == "true" && [get_parameter_value operand_source_may] == "preadder" && [get_parameter_value operation_mode] == "m27x27" } {
		send_message ERROR "Mode m27x27 does not support 'ay_use_scan_in' when preadder is used"
	}
	#dsp_leg_nd_hwtcl_63
	if { [get_parameter_value enable_scanout] == "true" && [get_parameter_value operand_source_may] == "preadder" && [get_parameter_value operation_mode] == "m27x27" } {
		send_message ERROR "Mode m27x27 does not support scanout when preadder is used"
	}
	#dsp_leg_nd_hwtcl_4
	if { [get_parameter_value scan_out_width] != [get_parameter_value ay_scan_in_width] && [get_parameter_value enable_scanout] == "true" && [get_parameter_value operation_mode] != "m18x18_plus36" && (([get_parameter_value by_use_scan_in] == "true" && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_full_top") || ([get_parameter_value by_use_scan_in]  == "false" && [get_parameter_value operation_mode] == "m27x27")) } {
		send_message ERROR "'scan_out_width' value must match with 'ay_scan_in_width' when scanout is enabled"
	}
	#dsp_leg_nd_hwtcl_66 
	if { [get_parameter_value scan_out_width] != [get_parameter_value by_width] && [get_parameter_value enable_scanout] == "true" && [get_parameter_value by_use_scan_in] == "false" && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top"} {
		send_message ERROR "'Scanout' output bus width value must match with 'by' input bus width value when by is driving scanout"
	}
	#dsp_leg_nd_hwtcl_67
	if { [get_parameter_value by_width] != 0 && [get_parameter_value by_use_scan_in] == "true" && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top"  } {
		send_message ERROR "When BY uses scan chain, 'by_width' must be set to 0"
	}
	#dsp_leg_nd_hwtcl_81
	if { [get_parameter_value by_use_scan_in] == "false" && [get_parameter_value delay_scan_out_ay] == "true" && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top"} {
		send_message ERROR "delay_scan_out_ay must not be enabled when by_scan_in is not enabled"
	}
	#dsp_leg_nd_hwtcl_82
	if { [get_parameter_value enable_scanout] == "false" && [get_parameter_value delay_scan_out_by] == "true" && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36"  && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		send_message ERROR "delay_scan_out_by need to be disabled when scanout is not used"
	}
	#dsp_leg_nd_hwtcl_82a
	if { [get_parameter_value ay_scan_in_clock] == "none" && [get_parameter_value delay_scan_out_ay] == "true" && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36"} {
		send_message ERROR "AY input register must be used to enable the top delay register"
	}
	#dsp_leg_nd_hwtcl_82b
	if { [get_parameter_value by_clock] == "none" && [get_parameter_value delay_scan_out_by] == "true" && [get_parameter_value operation_mode] != "m27x27" && [get_parameter_value operation_mode] != "m18x18_plus36" && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		send_message ERROR "BY input register must be used to enable the bottom delay register"
	}
	#dsp_leg_nd_hwtcl_96
	if { [get_parameter_value enable_accumulate] == "false" && [get_parameter_value enable_double_accum] == "true" && [get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top"} {
		send_message ERROR "Enable double accumulator cannot be enabled when Enable accumulate port is not enabled"
	}
	#dsp_leg_nd_98
	if { [get_parameter_value load_const_value] < 0 || [get_parameter_value load_const_value] > 63 } {
		send_message ERROR "Load_const_value only accepts value range from 0 to 63"
	}
	#dsp_leg_nd_hwtcl_101 
	if { ([get_parameter_value enable_clr0] == "true" || [get_parameter_value enable_clr1] == "true") && [get_parameter_value clear_type] == "none" } {
		send_message ERROR "clear_type must not be set to None when any of the clr port is enabled"
	}
	#dsp_leg_nd_hwtcl_102 
	if { ([get_parameter_value enable_clr0] == "false" && [get_parameter_value enable_clr1] == "false") && [get_parameter_value clear_type] != "none" } {
		send_message ERROR "clear_type must set to None when any of the clr port is not enabled"
	}
	
	#dsp_leg_nd_hwtcl_104a
	if { [get_parameter_value enable_clr0] == "true" && ([get_parameter_value operation_mode] == "m18x18_full" && [get_parameter_value ay_scan_in_clock] == "none" && ([get_parameter_value az_clock] == "none" || [get_parameter_value operand_source_may] == "input") && ([get_parameter_value coef_sel_a_clock] == "none" || [get_parameter_value operand_source_max] == "input") && ([get_parameter_value ax_clock] == "none" || [get_parameter_value operand_source_max] == "coef" ) && [get_parameter_value by_clock] == "none" && ([get_parameter_value bz_clock] == "none" || [get_parameter_value operand_source_mby] == "input") && ([get_parameter_value bx_clock] == "none" || [get_parameter_value operand_source_mbx] == "coef")&& ([get_parameter_value coef_sel_b_clock] == "none" || [get_parameter_value operand_source_mbx] == "input")) } {
		send_message ERROR "M18x18_FULL:Input clock need to be enabled when CLR0"
	}
	
	#Added for additional clear signals for enable_clr0
	#dsp_leg_nd_hwtcl_104a1 --- disabled
	#if { [get_parameter_value enable_clr0] == "false" && [get_parameter_value operation_mode] == "m18x18_full" && ([get_parameter_value ay_scan_in_clock] != "none" || ([get_parameter_value az_clock] != "none" && [get_parameter_value operand_source_may] != "input") || ([get_parameter_value coef_sel_a_clock] != "none" && [get_parameter_value operand_source_max] != "input") || ([get_parameter_value ax_clock] != "none" && [get_parameter_value operand_source_max] == "input") || [get_parameter_value by_clock] != "none" || ([get_parameter_value bz_clock] != "none" && [get_parameter_value operand_source_mby] != "input") || ([get_parameter_value bx_clock] != "none" && [get_parameter_value operand_source_mbx] == "input") || ([get_parameter_value coef_sel_b_clock] != "none" && [get_parameter_value operand_source_mbx] != "input")) } {
		#send_message ERROR "M18x18_FULL:When CLR0 is not used the input clocks need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104a2
	if { [get_parameter_value enable_clr0] == "true" && ([get_parameter_value operation_mode] == "m18x18_full_top" && [get_parameter_value ay_scan_in_clock] == "none" && ([get_parameter_value az_clock] == "none" || [get_parameter_value operand_source_may] == "input") && ([get_parameter_value coef_sel_a_clock] == "none" || [get_parameter_value operand_source_max] == "input") && ([get_parameter_value ax_clock] == "none" || [get_parameter_value operand_source_max] == "coef")) } {
		send_message ERROR "M18x18_FULL_TOP:Input clock need to be enabled when CLR0 is used"
	}
	#dsp_leg_nd_hwtcl_104a3 --- disabled
	#if { [get_parameter_value enable_clr0] == "false" && [get_parameter_value operation_mode] == "m18x18_full_top" && ([get_parameter_value ay_scan_in_clock] != "none" || ([get_parameter_value az_clock] != "none" && [get_parameter_value operand_source_may] != "input") || ([get_parameter_value coef_sel_a_clock] != "none" && [get_parameter_value operand_source_max] != "input") || ([get_parameter_value ax_clock] != "none" && [get_parameter_value operand_source_max] == "input")) } {
		#send_message ERROR "M18x18_FULL_TOP:When CLR0 is not used the input clocks need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104a4
	if { [get_parameter_value enable_clr0] == "true" && ([get_parameter_value operation_mode] == "m18x18_sumof2" && [get_parameter_value ay_scan_in_clock] == "none" && ([get_parameter_value az_clock] == "none" || [get_parameter_value operand_source_may] == "input") && ([get_parameter_value coef_sel_a_clock] == "none" || [get_parameter_value operand_source_max] == "input") && ([get_parameter_value ax_clock] == "none" || [get_parameter_value operand_source_max] == "coef") && [get_parameter_value by_clock] == "none" && ([get_parameter_value bz_clock] == "none" || [get_parameter_value operand_source_mby] == "input") && ([get_parameter_value bx_clock] == "none" || [get_parameter_value operand_source_mbx] == "coef") && ([get_parameter_value coef_sel_b_clock] == "none" || [get_parameter_value operand_source_mbx] == "input") && ([get_parameter_value negate_clock] == "none" || [get_parameter_value enable_negate] == "false") && ([get_parameter_value sub_clock] == "none" || [get_parameter_value enable_sub] == "false") && ([get_parameter_value accumulate_clock] == "none" || [get_parameter_value enable_accumulate] == "false") && ([get_parameter_value load_const_clock] == "none" || [get_parameter_value enable_loadconst] == "false"))} {
		send_message ERROR "M18x18_sumof2:Input clock need to be enabled when CLR0 is used"
	}
	#dsp_leg_nd_hwtcl_104a5 --- disabled
	#if { [get_parameter_value enable_clr0] == "false" && [get_parameter_value operation_mode] == "m18x18_sumof2" && ([get_parameter_value ay_scan_in_clock] != "none" || ([get_parameter_value az_clock] != "none" && [get_parameter_value operand_source_may] != "input") || ([get_parameter_value coef_sel_a_clock] != "none" && [get_parameter_value operand_source_max] != "input") || ([get_parameter_value ax_clock] != "none" && [get_parameter_value operand_source_max] == "input") || [get_parameter_value by_clock] != "none" || ([get_parameter_value bz_clock] != "none" && [get_parameter_value operand_source_mby] != "input") || ([get_parameter_value bx_clock] != "none" && [get_parameter_value operand_source_mbx] == "input")|| ([get_parameter_value coef_sel_b_clock] != "none" && [get_parameter_value operand_source_mbx] != "input") || ([get_parameter_value negate_clock] != "none" && [get_parameter_value enable_negate] != "false") || ([get_parameter_value sub_clock] != "none" && [get_parameter_value enable_sub] != "false") || ([get_parameter_value accumulate_clock] != "none" && [get_parameter_value enable_accumulate] != "false") || ([get_parameter_value load_const_clock] != "none" && [get_parameter_value enable_loadconst] != "false"))} {
		#send_message ERROR "M18x18_sumof2:When CLR0 is not used the input clocks need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104a6
	if {[get_parameter_value enable_clr0] == "true" && ([get_parameter_value operation_mode] == "m18x18_plus36" && [get_parameter_value ax_clock] == "none" && [get_parameter_value by_clock] == "none" && [get_parameter_value bx_clock] == "none" && [get_parameter_value ay_scan_in_clock] ==  "none" && ([get_parameter_value negate_clock] == "none" || [get_parameter_value enable_negate] == "false") && ([get_parameter_value sub_clock] == "none" || [get_parameter_value enable_sub] == "false") && ([get_parameter_value accumulate_clock] == "none" || [get_parameter_value enable_accumulate] == "false") && ([get_parameter_value load_const_clock] == "none" || [get_parameter_value enable_loadconst] == "false"))} {
		send_message ERROR "M18x18_plus36:Input clock need to be enabled when CLR0 is used"
	}
	#dsp_leg_nd_hwtcl_104a7 --- disabled
	#if {[get_parameter_value enable_clr0] == "false" && [get_parameter_value operation_mode] == "m18x18_plus36" && ([get_parameter_value ax_clock] != "none" || [get_parameter_value by_clock] != "none" || [get_parameter_value bx_clock] != "none" || [get_parameter_value ay_scan_in_clock] !=  "none" || ([get_parameter_value negate_clock] != "none" && [get_parameter_value enable_negate] != "false") || ([get_parameter_value sub_clock] != "none" && [get_parameter_value enable_sub] != "false") || ([get_parameter_value accumulate_clock] != "none" && [get_parameter_value enable_accumulate] != "false") || ([get_parameter_value load_const_clock] != "none" && [get_parameter_value enable_loadconst] != "false"))} {
		#send_message ERROR "M18x18_plus36:When CLR0 is not used the input clocks need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104a8
	if { [get_parameter_value enable_clr0] == "true" && ([get_parameter_value operation_mode] == "m18x18_systolic" && [get_parameter_value ay_scan_in_clock] == "none" && ([get_parameter_value az_clock] == "none" || [get_parameter_value operand_source_may] == "input") && ([get_parameter_value coef_sel_a_clock] == "none" || [get_parameter_value operand_source_max] == "input") && ([get_parameter_value ax_clock] == "none" || [get_parameter_value operand_source_max] == "coef") && [get_parameter_value by_clock] == "none" && ([get_parameter_value bz_clock] == "none" || [get_parameter_value operand_source_mby] == "input") && ([get_parameter_value bx_clock] == "none" || [get_parameter_value operand_source_mbx] == "coef") && ([get_parameter_value coef_sel_b_clock] == "none" || [get_parameter_value operand_source_mbx] == "input") && ([get_parameter_value negate_clock] == "none" || [get_parameter_value enable_negate] == "false") && ([get_parameter_value sub_clock] == "none" || [get_parameter_value enable_sub] == "false") && ([get_parameter_value accumulate_clock] == "none" || [get_parameter_value enable_accumulate] == "false") && ([get_parameter_value load_const_clock] == "none" || [get_parameter_value enable_loadconst] == "false"))} {
		send_message ERROR "M18x18_systolic:Input clock need to be enabled when CLR0 is used"
	}
	#dsp_leg_nd_hwtcl_104a9 --- disabled
	#if { [get_parameter_value enable_clr0] == "false" && [get_parameter_value operation_mode] == "m18x18_systolic" && ([get_parameter_value ay_scan_in_clock] != "none" || ([get_parameter_value az_clock] != "none" && [get_parameter_value operand_source_may] != "input") || ([get_parameter_value coef_sel_a_clock] != "none" && [get_parameter_value operand_source_max] != "input") || ([get_parameter_value ax_clock] != "none" && [get_parameter_value operand_source_max] == "input") || [get_parameter_value by_clock] != "none" || ([get_parameter_value bz_clock] != "none" && [get_parameter_value operand_source_mby] != "input") || ([get_parameter_value bx_clock] != "none" && [get_parameter_value operand_source_mbx] == "input") || ([get_parameter_value coef_sel_b_clock] != "none" && [get_parameter_value operand_source_mbx] != "input") || ([get_parameter_value negate_clock] != "none" && [get_parameter_value enable_negate] != "false") || ([get_parameter_value sub_clock] != "none" && [get_parameter_value enable_sub] != "false") || ([get_parameter_value accumulate_clock] != "none" && [get_parameter_value enable_accumulate] != "false") || ([get_parameter_value load_const_clock] != "none" && [get_parameter_value enable_loadconst] != "false"))} {
		#send_message ERROR "M18x18_systolic:When CLR0 is not used the input clocks need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104a10
	if { [get_parameter_value enable_clr0] == "true" && ([get_parameter_value operation_mode] == "m27x27" && [get_parameter_value ay_scan_in_clock] == "none" && ([get_parameter_value az_clock] == "none" || [get_parameter_value operand_source_may] == "input") && ([get_parameter_value coef_sel_a_clock] == "none" || [get_parameter_value operand_source_max] == "input") && ([get_parameter_value ax_clock] == "none" || [get_parameter_value operand_source_max] == "coef") && ([get_parameter_value negate_clock] == "none" || [get_parameter_value enable_negate] == "false") && ([get_parameter_value accumulate_clock] == "none" || [get_parameter_value enable_accumulate] == "false") && ([get_parameter_value load_const_clock] == "none" || [get_parameter_value enable_loadconst] == "false")) } {
		send_message ERROR "M27x27:Input clock need to be enabled when CLR0 is used"
	}
	#dsp_leg_nd_hwtcl_104a11 --- disabled
	#if { [get_parameter_value enable_clr0] == "false" && [get_parameter_value operation_mode] == "m27x27" && ([get_parameter_value ay_scan_in_clock] != "none" || ([get_parameter_value az_clock] != "none" && [get_parameter_value operand_source_may] != "input") || ([get_parameter_value coef_sel_a_clock] != "none" && [get_parameter_value operand_source_max] != "input") || ([get_parameter_value ax_clock] != "none" && [get_parameter_value operand_source_max] == "input") || ([get_parameter_value negate_clock] != "none" && [get_parameter_value enable_negate] != "false") || ([get_parameter_value accumulate_clock] != "none" && [get_parameter_value enable_accumulate] != "false") || ([get_parameter_value load_const_clock] != "none" && [get_parameter_value enable_loadconst] != "false")) } {
		#send_message ERROR "M27x27:When CLR0 is not used the input clocks need to be set to None"
	#}
	
	#Added for additional clear signals for enable_clr1
	#dsp_leg_nd_hwtcl_104b
	if {[get_parameter_value enable_clr1] == "true" && ([get_parameter_value operation_mode] == "m18x18_full" && [get_parameter_value  input_pipeline_clock] == "none" && [get_parameter_value second_pipeline_clock] == "none" && [get_parameter_value output_clock] == "none") } {
		send_message ERROR "m18x18_full:Output or pipeline clock need to be enabled when CLR1 is used"
	}
	
	#dsp_leg_nd_hwtcl_104b1
	#if {[get_parameter_value enable_clr1] == "false" && [get_parameter_value operation_mode] == "m18x18_full" && ([get_parameter_value  input_pipeline_clock] != "none" || [get_parameter_value second_pipeline_clock] != "none" || [get_parameter_value output_clock] != "none") } {
		#send_message ERROR "m18x18_full:When CLR1 is not used Output or pipeline clock need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104b2
	if {[get_parameter_value enable_clr1] == "true" && ([get_parameter_value operation_mode] == "m18x18_full_top" && [get_parameter_value  input_pipeline_clock] == "none" && [get_parameter_value second_pipeline_clock] == "none" && [get_parameter_value output_clock] == "none") } {
		send_message ERROR "m18x18_full_top:Output or pipeline clock need to be enabled when CLR1 is used"
	}
	#dsp_leg_nd_hwtcl_104b3
	#if {[get_parameter_value enable_clr1] == "false" && [get_parameter_value operation_mode] == "m18x18_full_top" && ([get_parameter_value  input_pipeline_clock] != "none" || [get_parameter_value second_pipeline_clock] != "none" || [get_parameter_value output_clock] != "none") } {
		#send_message ERROR "m18x18_full_top:When CLR1 is not used Output or pipeline clock need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104b4
	if { [get_parameter_value enable_clr1] == "true" && ([get_parameter_value operation_mode] == "m18x18_sumof2" && [get_parameter_value input_pipeline_clock] == "none" && [get_parameter_value second_pipeline_clock] == "none" && ([get_parameter_value accum_pipeline_clock] == "none" && [get_parameter_value accum_2nd_pipeline_clock] == "none" || [get_parameter_value enable_accumulate] == "false") && ([get_parameter_value load_const_pipeline_clock] == "none" && [get_parameter_value load_const_2nd_pipeline_clock] == "none" || [get_parameter_value enable_loadconst] == "false") && [get_parameter_value output_clock] == "none") } {
		send_message ERROR "m18x18_sumod2:Output or pipeline clock need to be enabled when CLR1 is used"
	}
	#dsp_leg_nd_hwtcl_104b5
	#if { [get_parameter_value enable_clr1] == "false" && [get_parameter_value operation_mode] == "m18x18_sumof2" && ([get_parameter_value input_pipeline_clock] != "none" || [get_parameter_value second_pipeline_clock] != "none" || [get_parameter_value output_clock] != "none") } {
		#send_message ERROR "m18x18_sumof2:When CLR1 is not used Output or pipeline clock need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104b6
	if { [get_parameter_value enable_clr1] == "true" && ([get_parameter_value operation_mode] == "m18x18_plus36" && [get_parameter_value input_pipeline_clock] == "none" && [get_parameter_value second_pipeline_clock] == "none" && ([get_parameter_value accum_pipeline_clock] == "none" && [get_parameter_value accum_2nd_pipeline_clock] == "none" || [get_parameter_value enable_accumulate] == "false") && ([get_parameter_value load_const_pipeline_clock] == "none" && [get_parameter_value load_const_2nd_pipeline_clock] == "none" || [get_parameter_value enable_loadconst] == "false") && [get_parameter_value output_clock] == "none") } {
		send_message ERROR "m18x18_plus36:Output or pipeline clock need to be enabled when CLR1 is used"
	}
	#dsp_leg_nd_hwtcl_104b7
	#if { [get_parameter_value enable_clr1] == "false" && [get_parameter_value operation_mode] == "m18x18_plus36" && ([get_parameter_value input_pipeline_clock] != "none" || [get_parameter_value second_pipeline_clock] != "none" || [get_parameter_value output_clock] != "none") } {
		#send_message ERROR "m18x18_plus36:When CLR1 is not used Output or pipeline clock need to be set to None"
	#}
	#dsp_leg_nd_hwtcl_104b8
	if { [get_parameter_value enable_clr1] == "true" && ([get_parameter_value operation_mode] == "m18x18_systolic" && [get_parameter_value input_pipeline_clock] == "none" && [get_parameter_value second_pipeline_clock] == "none" && [get_parameter_value input_systolic_clock] == "none" && ([get_parameter_value accum_pipeline_clock] == "none" && [get_parameter_value accum_2nd_pipeline_clock] == "none" || [get_parameter_value enable_accumulate] == "false") && ([get_parameter_value load_const_pipeline_clock] == "none" && [get_parameter_value load_const_2nd_pipeline_clock] == "none" || [get_parameter_value enable_loadconst] == "false") && [get_parameter_value output_clock] == "none") } {
		send_message ERROR "m18x18_systolic:Output or pipeline clock need to be enabled when CLR1 is used"
	} 
	#dsp_leg_nd_hwtcl_104b9
	#if { [get_parameter_value enable_clr1] == "false" && [get_parameter_value operation_mode] == "m18x18_systolic" && ([get_parameter_value input_pipeline_clock] != "none" || [get_parameter_value second_pipeline_clock] != "none" || [get_parameter_value input_systolic_clock] != "none" || [get_parameter_value output_clock] != "none") } {
		#send_message ERROR "m18x18_systolic:When CLR1 is not used Output or pipeline clock need to be set to None"
	#} 
	#dsp_leg_nd_hwtcl_104b10
	if { [get_parameter_value enable_clr1] == "true" && ([get_parameter_value operation_mode] == "m27x27" && [get_parameter_value input_pipeline_clock] == "none" && [get_parameter_value second_pipeline_clock] == "none" && ([get_parameter_value accum_pipeline_clock] == "none" && [get_parameter_value accum_2nd_pipeline_clock] == "none" || [get_parameter_value enable_accumulate] == "false") && ([get_parameter_value load_const_pipeline_clock] == "none" && [get_parameter_value load_const_2nd_pipeline_clock] == "none" || [get_parameter_value enable_loadconst] == "false") && [get_parameter_value output_clock] == "none") } {
		send_message ERROR "m27x27:Output or pipeline clock need to be enabled when CLR1 is used"
	}
	#dsp_leg_nd_hwtcl_104b11
	#if { [get_parameter_value enable_clr1] == "false" && [get_parameter_value operation_mode] == "m27x27" && ([get_parameter_value input_pipeline_clock] != "none" || [get_parameter_value second_pipeline_clock] != "none" || [get_parameter_value output_clock] != "none") } {
		#send_message ERROR "m27x27:When CLR1 is not used Output or pipeline clock need to be set to None"
	#}
	
	
	#dsp_leg_nd_hwtcl_111a
	if { (([get_parameter_value enable_loadconst] == "true" && [get_parameter_value load_const_clock] != "none") && ((( [get_parameter_value enable_accumulate] == "true" && [get_parameter_value accumulate_clock] != "none") && [get_parameter_value accumulate_clock] != [get_parameter_value load_const_clock]) || (([get_parameter_value enable_negate] == "true" && [get_parameter_value negate_clock] != "none") && [get_parameter_value negate_clock] != [get_parameter_value load_const_clock]) ||(([get_parameter_value operation_mode] != "m27x27" && ( [get_parameter_value enable_sub] == "true" && [get_parameter_value sub_clock] != "none")) && [get_parameter_value sub_clock] != [get_parameter_value load_const_clock]))) && [get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		send_message ERROR "When registered, param 'load_const_clock', 'accumulate_clock', 'negate_clock' and 'sub_clock' must share the same clock source but each can be individually bypassed"
	}
	
	#dsp_leg_nd_hwtcl_111b
	if { (([get_parameter_value enable_accumulate] == "true" && [get_parameter_value accumulate_clock] != "none") && ((([get_parameter_value enable_negate] == "true" && [get_parameter_value negate_clock] != "none") && [get_parameter_value negate_clock] != [get_parameter_value accumulate_clock]) || (([get_parameter_value operation_mode] != "m27x27" && ( [get_parameter_value enable_sub] == "true" && [get_parameter_value sub_clock] != "none")) && [get_parameter_value sub_clock] != [get_parameter_value accumulate_clock] ))) && [get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top"} {
		send_message ERROR "When registered, param 'accumulate_clock', 'negate_clock' and 'sub_clock' must share the same clock source but each can be individually bypassed."
	}
	
	#dsp_leg_nd_hwtcl_111c
	if { (([get_parameter_value enable_negate] == "true" && [get_parameter_value negate_clock] != "none") && (([get_parameter_value operation_mode] != "m27x27" && [get_parameter_value enable_sub] == "true" && [get_parameter_value sub_clock] != "none") && [get_parameter_value sub_clock] != [get_parameter_value negate_clock])) && [get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		send_message ERROR "When registered, param 'negate_clock' and 'sub_clock' must share the same clock source but each can be individually bypassed."
	}
	
	#dsp_leg_nd_120
	if { [get_parameter_value operation_mode] == "m18x18_plus36" && [get_parameter_value bx_clock] != [get_parameter_value by_clock] } {
		send_message ERROR "When using mode m18x18_plus36, the bx_clock and by_clock must use the same clock source"
	}
	#dsp_leg_nd_hwtcl_12
	if { ([get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top") && (([get_parameter_value enable_loadconst] == "true" && [get_parameter_value load_const_pipeline_clock] != "none" ||[get_parameter_value enable_accumulate] == "true" && [get_parameter_value accum_pipeline_clock] != "none") && [get_parameter_value input_pipeline_clock] == "none") } {
		send_message ERROR "Control signal pipeline registers can only be enabled when input pipeline is enabled"
	}

	#dsp_leg_nd_hwtcl_13
	if { ([get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top" ) && ([get_parameter_value input_pipeline_clock] != "none" && (( [get_parameter_value enable_loadconst] == "true" && [get_parameter_value load_const_pipeline_clock] != "none") && [get_parameter_value input_pipeline_clock] != [get_parameter_value load_const_pipeline_clock]) || ([get_parameter_value enable_accumulate] == "true" && [get_parameter_value accum_pipeline_clock] != "none") && [get_parameter_value input_pipeline_clock] != [get_parameter_value accum_pipeline_clock])} {
		send_message ERROR "When load_const_pipeline_clock or accum_pipeline_clock source is used they need to be same as input_pipeline_clock"
	}
	
	#dsp_leg_nd_hwtcl_14
	if { ([get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top" ) && ([get_parameter_value second_pipeline_clock] == "none" && (([get_parameter_value enable_loadconst] == "true" && [get_parameter_value load_const_2nd_pipeline_clock] != "none" )|| ([get_parameter_value enable_accumulate] == "true" && [get_parameter_value accum_2nd_pipeline_clock] != "none"))) } {
		send_message ERROR "Control signal 2nd pipeline registers can only be enabled when 2nd input pipeline register is enabled"
	}
	
	#dsp_leg_nd_hwtcl_15
	if { ([get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top" ) && ([get_parameter_value second_pipeline_clock] != "none" && (( [get_parameter_value enable_loadconst] == "true" && [get_parameter_value load_const_2nd_pipeline_clock] != "none") && [get_parameter_value second_pipeline_clock] != [get_parameter_value load_const_2nd_pipeline_clock]) || ([get_parameter_value enable_accumulate] == "true" && [get_parameter_value accum_2nd_pipeline_clock] != "none") && [get_parameter_value second_pipeline_clock] != [get_parameter_value accum_2nd_pipeline_clock])} {
		send_message ERROR "When load_const_2nd_pipeline_clock or accum_2nd_pipeline_clock source is used they need to be same as second_pipeline_clock"
	}
	
	#dsp_leg_nd_121
	if { [get_parameter_value operation_mode] == "m18x18_systolic" && [get_parameter_value second_pipeline_clock] != "none" && [get_parameter_value second_pipeline_clock] != [get_parameter_value input_systolic_clock] } {
		send_message ERROR "When systolic mode is used, 'second_pipeline_clock' and 'input_systolic_clock' must share the same clock source when second pipeline register is used"
	}
	#dsp_leg_nd_124
	if { [get_parameter_value operation_mode] == "m18x18_systolic" && [get_parameter_value input_systolic_clock] == "none" } {
		send_message ERROR "'input_systolic_clock' should not be 'NONE' when m18x18_systolic mode is used" 
	}
	#dsp_leg_nd_125
	if { [get_parameter_value operation_mode] == "m18x18_systolic" && [get_parameter_value output_clock] == "none" } {
		send_message ERROR "'output_clock' should not be 'NONE' when m18x18_systolic mode is used" 
	}
	#dsp_leg_nd_hwtcl_126
	if { ([get_parameter_value enable_accumulate] == "true") && [get_parameter_value output_clock] == "none" && [get_parameter_value operation_mode] != "m18x18_full" && [get_parameter_value operation_mode] != "m18x18_full_top" } {
		send_message ERROR  "Accumulation feature require parameter 'output_clock' to set to other value than 'NONE'"
	}
	#dsp_leg_nd_hwtcl_127
	if { [get_parameter_value operation_mode] == "m18x18_plus36" && ( [get_parameter_value az_width] != "0" || [get_parameter_value bz_width] != "0") } {
		send_message ERROR "az_width and bz_width need to be set to '0' when using mode m18x18_plus36"
	}
	
	#dsp_leg_nd_hwtcl_5
	if { [get_parameter_value enable_clkena0] == "true" && [get_parameter_value clock0_show] == "false" } {
		send_message ERROR "Clock enable0 can only be used when the register uses Clock 0"
	}
	
	#dsp_leg_nd_hwtcl_21
	if { [get_parameter_value enable_clkena1] == "true" && [get_parameter_value clock1_show] == "false" } {
		send_message ERROR "Clock enable1 can only be used when the register uses Clock 1"
	}
	
	#dsp_leg_nd_hwtcl_25
	if { [get_parameter_value enable_clkena2] == "true" && [get_parameter_value clock2_show] == "false" } {
		send_message ERROR "Clock enable2 can only be used when the register uses Clock 2"
	}
	
	
	#for m18x18_top
	set operation [get_parameter_value operation_mode]
	set list_m18x18_full_m18x18_sumof2_m18x18_systolic [ list m18x18_full m18x18_sumof2 m18x18_systolic]
	#E1--PASS
	set list_of_signed_mode [list m18x18_plus36]
	
	#E24--PASS
    set list_m18x18_systolic [list m18x18_systolic]

	#List of Info Messages
	if { ([lsearch -nocase $list_of_signed_mode  $operation  ] != -1) } {
		send_message INFO "The 36-bit operand must be fully filled up for m18x18_plus36 mode"
		send_message INFO "Connect 17:0 from the 36-bit input buses to 'by'"
		send_message INFO "Connect 35:18 from the 36-bit input buses to bx"
	}
		
	# if { ([get_parameter_value ay_use_scan_in] || [get_parameter_value by_use_scan_in])} {
		# if { ([get_parameter_value operand_source_may] || [get_parameter_value operand_source_mby]) } {
			# send_message INFO "When both pre-adder and input cascade are enabled, only 18-bit out of the 19-bit input cascade can be used."
		# }
	# }
	#disabled for testing operand_source_may value to be changed to preadder
	# if { [get_parameter_value operand_source_may]} {
		# send_message INFO "Info:Pre-adder supports 18-bit (signed) or 17-bit (unsigned) addition for 18x18 style, and 26-bit addition for 27x27 style."
	# }
	# if { [get_parameter_value operand_source_max] } {
		# send_message INFO "Info:8 Constant Coefficients can be stired in MAC internal memory to feed the operand x and they are specified in coef_a_0-7 and coef_b_0-7"
		# send_message INFO "Info:Each constant coefficient can be 18-bit or 27-bit wide for 18x18 style and 27x27 style respectively."
		# send_message INFO "Info:The constant coefficient must be specified as integer"
	# }
	#changed from use_chainin to enable_chainadder
	if {[get_parameter_value enable_chainin] } {
		send_message INFO "Info:The 'chainin' input port must be sources from the 'chainout' output port from preceding DSP Block"
		if { !([lsearch -nocase $list_m18x18_systolic  $operation  ] != -1) } {
			send_message INFO "Info: When Output cascade is enabled, the full 64-bit chain wire must be fully connected."
		}
		if { ([lsearch -nocase $list_m18x18_systolic  $operation  ] != -1) } {
			send_message INFO "Info:When output cascade is enabled and operation mode is m18x18_systolic, only 44-bit out of the 64-bit chain wire can be used."
		}
		if { ([get_parameter_value ay_use_scan_in]) } {
			send_message INFO "Info: When both input and output cascade are enabled, the 'chainin' and 'scanin' input ports must be sourced from the 'chainout' and 'scanout' output signals from the same preceding DSP block."
		} 
	}
	#clocking Scheme
	if { ([get_parameter_value accum_pipeline_clock] ne "None") || ([get_parameter_value negate_clock] ne "None") || ([get_parameter_value accumulate_clock] ne "None") || ([get_parameter_value load_const_clock] ne "None") } {
		send_message INFO "If the control signal (sub,negate,accumulate, loadconst) is tied to a constant value, the corresponding control signal input register must not be used."
	}
	if { ([get_parameter_value accum_pipeline_clock] ne "None") || ([get_parameter_value load_const_pipeline_clock] ne "None") } {
		send_message INFO "Info: If the control signal (sub,negate,accumulate,loadconst) is tied to constant value, the corresponding control signal pipeline register must not be used "
	}
	#Systolic
	if { ([lsearch -nocase $list_m18x18_systolic  $operation  ] != -1) && ([get_parameter_value input_systolic_clock] ne "None") && [get_parameter_value input_systolic_clock] ne [get_parameter_value output_clock] } {
		send_message INFO: "When m18x18_systolic mode is used, input systolic register and output register should be sourced by the same clock source in order to achieve the correct systolic behaviour."
	}
		
	
	# Set the clock values as shown in UI to output file
	foreach cur_clock [get_hdl_clocks] {	
		if { [lsearch -nocase [get_used_clocks]  $cur_clock  ] != -1 } {
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_input_max]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_input_mbx]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_preadder_may]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_preadder_mby]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_coef]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_coef_mbx]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_accumulate]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_loadconst]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_negate]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} elseif { [lsearch -nocase [get_used_clocks_supported_feature_sub]  $cur_clock  ] != -1 } { 
			set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
		} else {
			set_parameter_value "${cur_clock}_derived" "none"
		}
	}
		
}

## Add documentation links for user guide and/or release notes
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
