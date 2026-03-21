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

#+--------------------------------------------
#|
#|  Legality Check
#|
#+--------------------------------------------
proc legality_check {} {

	# Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }
  
	# Multiplier configuration
	#+------------------------
	if {$params(signed_mby) eq "true" && $params(operation_mode) eq "m18x18_plus36"} {
		send_message error "For m18x18_plus36 mode, representation format for bottom multiplier's y operand (signed_mby) must be set to \"unsigned\"."
	}
	if {$params(signed_may) eq "false" && $params(ay_scan_in_width) == 19} {
		send_message error "When 'ay' width is 19-bit, the representation format for top multiplier's y operand (signed_may) must be set to \"signed\"."
	}
	if {$params(signed_mby) eq "false" && $params(by_width) == 19} {
		send_message error "When 'by' width is 19-bit, the representation format for bottom multiplier's y operand (signed_mby) must be set to \"signed\"."
	}
	
	if {$params(sub_clock) ne "none" && $params(operation_mode) eq "m27x27"} {
		send_message error "Input 'sub' is not supported in this mode."
	}
	
	if {$params(sub_clock) ne "none" && $params(operation_mode) eq "m18x18_full"} {
		send_message error "Input 'sub' is not supported in this mode."
	} 
	
	#Added for enable_sub
	if {($params(sub_clock) ne "none" || $params(enable_sub) eq "true") && $params(operation_mode) eq "m27x27"} {
		send_message error "Input 'sub' is not supported in this mode."
	}
	
	#Added for enable_sub
	if { ($params(sub_clock) ne "none" || $params(enable_sub) eq "true") && $params(operation_mode) eq "m18x18_full"} {
		send_message error "Input 'sub' is not supported in this mode."
	} 
	
	#Added for enable_sub
	if {$params(sub_clock) ne "none" && $params(enable_sub) eq "false"} {
		send_message error "\"Enable 'sub' port\" must be set to \"Yes\" when \"Register input 'sub' of the multiplier\" is set to \"Clock0/Clock1/Clock2\"."
	}
	
	# Output width check
	if {$params(operation_mode) eq "m18x18_full" && $params(result_a_width) > 37} {
		send_message error "For m18x18_full mode, \"resulta\" output bus width must be less than 38-bit."
	}
	if {$params(operation_mode) eq "m18x18_full" && $params(result_b_width) > 37} {
		send_message error "For m18x18_full mode, \"resultb\" output bus width must be less than 38-bit."
	}

	# Input Cascade
	#+-------------
	
	# Input Scan Chain
	if {$params(ay_use_scan_in) eq "true" || $params(by_use_scan_in) eq "true"} {
		if {$params(operation_mode) eq "m18x18_plus36"} {
			send_message error "'ay' and/or 'by' input cascade is not supported in this mode."
		}
		if {$params(operation_mode) eq "m27x27" && $params(operand_source_may) eq "preadder" } {
			send_message error "When m27x27 mode is used, either Input Cascade or Pre-adder can be used at one time, not both at the same time."
		}
		if {$params(operand_source_may) eq "preadder" && $params(ay_scan_in_width) > 18} {
				send_message error "When both Pre-adder and Input Cascade are enabled, 'scanin' width must be equal to or less than 18-bit. Please specify the valid width under \"Data 'y' Configuration\"."
		}
	}
    if {$params(operation_mode) eq "m27x27" && $params(by_use_scan_in) eq "true"} {
        send_message error "When m27x27 mode is used, input cascade for 'by' input cannot be used and must always be set to 'No'."
    }
	
	# Delay register
	if {($params(delay_scan_out_ay) eq "true" || $params(delay_scan_out_by) eq "true") && ($params(operation_mode) eq "m27x27" || $params(operation_mode) eq "m18x18_plus36")} {
		send_message error "Data 'ay' and 'by' delay registers are not supported in this mode."
	}
	
	if {$params(gui_scanout_enable) eq "false" && $params(delay_scan_out_by) eq "true" } {
		send_message error "\"Enable data by delay register\" must be set to 'No' when \"Enable scanout port\" is set to 'No'."
	
	}
		
	# Scan out port---removed m27x27
	if {$params(gui_scanout_enable) eq "true" && ($params(operation_mode) eq "m18x18_plus36" ) } {
		send_message error "'Scanout' port cannot be used in this mode."
	
	}

	# Pre-adder Configuration
	#+-----------------------
	
	if { ($params(operand_source_may) eq "preadder") && ($params(ay_scan_in_clock) ne $params(az_clock)) } {
			send_message error "When pre-adder is enabled, 'ay' and 'az' input register clock setting under \"Data 'y' Configuration\" and \"Data 'z' Configuration\" must use the same clock setting."
	}
	
	if { ($params(operand_source_mby) eq "preadder") && ($params(by_clock) ne $params(bz_clock)) } {
			send_message error "When pre-adder is enabled, 'by' and 'bz' input register clock setting under \"Data 'y' Configuration\" and \"Data 'z' Configuration\" must use the same clock setting."
	}
	
	if {$params(operation_mode) eq "m18x18_plus36" && $params(operand_source_may) eq "preadder"} {
		send_message error "Pre-adder is not supported in this mode."	
	}
    if {$params(operation_mode) ne "m27x27" && !($params(operation_mode) eq "m18x18_full" &&  $params(by_width) eq 0) } {
        if {$params(operand_source_may) ne $params(operand_source_mby)} {
            send_message error "'ay' and 'by' operand source must use the same setting."	
        }
        if {$params(preadder_subtract_a) ne $params(preadder_subtract_b)} {
            send_message error "Operation for pre-adder a and pre-adder b must be the same."	
        }
    }
	
	if  {$params(preadder_subtract_a) eq "true" && $params(signed_may) ne "true"} {
            send_message error "When pre-adder substration for 'a' is enabled, representation format for top multiplier's y operand must be set to \"signed\"."		
        }

	if  {$params(preadder_subtract_b) eq "true" && $params(signed_mby) ne "true"} {
		send_message error "When pre-adder substration for 'b' is enabled, representation format for bottom multiplier's y operand must be set to \"signed\"."		
	}
	if {$params(operation_mode) ne "m27x27" && $params(operand_source_may) eq "preadder"} {
		if {$params(ay_scan_in_width) > 18} {
			send_message error "The pre-adder supports a maximum of 18-bit (signed/unsigned) input operand for 18x18 style addition. \"'ay' or 'scanin' bus width\" setting under \"Data 'y' Configuration\" must be set to 18 or less."	
		}
		if {$params(az_width) > 18} {
			send_message error "The pre-adder supports a maximum of 18-bit (signed/unsigned) input operand for 18x18 style addition. \"'az' input bus width\" setting under \"Data 'z' Configuration\" must be set to 18 or less."	
		}
		if {$params(by_width) > 18} {
			send_message error "The pre-adder supports a maximum of 18-bit (signed/unsigned) input operand for 18x18 style addition. \"'by' input bus width\" setting under \"Data 'y' Configuration\" must be set to 18 or less."	
		}
		if {$params(bz_width) > 18} {
			send_message error "The pre-adder supports a maximum of 18-bit (signed/unsigned) input operand for 18x18 style addition. \"'bz' input bus width\" setting under \"Data 'z' Configuration\" must be set to 18 or less."	
		}
	}
	if {$params(operation_mode) eq "m27x27" && $params(operand_source_may) eq "preadder"} {
		if {$params(ay_scan_in_width) > 26} {
			send_message error "The pre-adder supports a maximum of 26-bit (signed/unsigned) input operand for 27x27 style addition. \"'ay' or 'scanin' bus width\" setting under \"Data 'y' Configuration\" must be set to 26 or less."	
		}	
		if {$params(az_width) > 26} {
			send_message error "The pre-adder supports a maximum of 26-bit (signed/unsigned) input operand for 27x27 style addition. \"'az' input bus width\" setting under \"Data 'z' Configuration\" must be set to 26 or less."	
		}
	}
	
	#dsp_leg_nd_28b
	if {($params(ay_scan_in_width) < 1 || $params(ay_scan_in_width) > 17) && ($params(operation_mode) ne "m27x27" && $params(operand_source_may) eq "preadder" && $params(signed_may) ne "true") } {
	    send_message error "'ay' or 'scanin' bus width value must be greater equal 1 and smaller equal to 17 if unsigned preadder is used."
	}
	
	#dsp_leg_nd_30b
	if { ($params(by_width) < 1 || $params(by_width) > 17) && ($params(operation_mode) ne "m27x27" && $params(operand_source_mby) eq "preadder" && $params(signed_mby) ne "true" && $params(by_use_scan_in) ne "true") && !($params(operation_mode) eq "m18x18_full" && $params(bx_width) eq 0 && $params(by_width) eq 0) } {
		send_message error "'by' input bus width value must be greater equal 1 and smaller equal to 17 if unsigned preadder is used"
	}
	
	#dsp_leg_nd_31b
	if { ($params(az_width) < 1 || $params(az_width) > 17) && ($params(operation_mode) ne "m27x27" && $params(operand_source_may) eq "preadder" && $params(signed_may) ne "true" ) } {
		send_message error "'az' input bus width value must be greater equal 1 and smaller equal to 17 for unsigned"
	}
	
	#dsp_leg_nd_32b
	if { ($params(bz_width) < 1 || $params(bz_width) > 17) && ($params(operation_mode) ne "m27x27" && $params(operand_source_mby) eq "preadder" && $params(signed_mby) ne "true" )&& !($params(operation_mode) eq "m18x18_full" && $params(bx_width) eq 0 && $params(bz_width) eq 0 ) } {
	    send_message error "bz input bus width value must be greater equal 1 and smaller equal to 17 in 18x18 mode when unsigned preadder is used"
	}
	
	#dsp_leg_nd_63
	if { ($params(operand_source_may) eq "preadder" && $params(operation_mode) eq "m27x27" ) && $params(gui_scanout_enable) eq "true" } {
		send_message error "Specific mode m27x27 does not support scanout when preadder is used"
	}
	
    #dsp_leg_nd_66-Disabled for m27x27
    if {$params(operation_mode) ne "m27x27" && ($params(scan_out_width) ne $params(by_width) && $params(by_use_scan_in) ne "true" && $params(gui_scanout_enable) eq "true" )} {
        send_message error "'scanout' output bus width value must match with 'by' input bus width value when by is driving scanout"
    }
	
	#dsp_leg_nd_82a
	if { ($params(ay_scan_in_clock) eq "none" && $params(delay_scan_out_ay) eq "true" )} {
	    send_message error "Register input 'ay' or input 'scanin' of the multiplier must be set to 'Clock0/Clock1/Clock2' to enable the top scan delay register "
	}
	
	#dsp_leg_nd_82b
	if { ($params(by_clock) eq "none" && $params(delay_scan_out_by) eq "true" )} {
		send_message error "Register input 'by' of the multiplier must be set to 'Clock0/Clock1/Clock2' to enable the bottom scan delay registers"
	}
	
	# Internal Coefficient Configuration
	#+---------------------------------
	if {$params(operation_mode) eq "m18x18_plus36" && $params(operand_source_max) eq "coef"} {
		send_message error "Internal coefficient is not supported in this mode."	
	}	
    if {$params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_plus36" && !($params(operation_mode) eq "m18x18_full" &&  $params(by_width) eq 0) } {
        if {$params(operand_source_max) ne $params(operand_source_mbx)} {
            send_message error "'ax' and 'bx' operand source must use the same setting."	
        }
    }
    if {$params(operation_mode) eq "m27x27"} {
        if {$params(coef_sel_b_clock) ne "none"} {
            send_message error "When m27x27 mode is used, \"Register input 'coefselb' of the multiplier\" must always be set to 'No'."
        }  
        if {$params(coef_b_0) ne 0 || $params(coef_b_1) ne 0 || $params(coef_b_2) ne 0 || $params(coef_b_3) ne 0 || $params(coef_b_4) ne 0 || $params(coef_b_5) ne 0 || $params(coef_b_6) ne 0 || $params(coef_b_7) ne 0} {
            send_message error "When m27x27 mode is used, coef_b_* should not be used and must always be set to 0."
        }
    }
    
	# Accumulator/Output Cascade Configuration
	#+----------------------------------------
	if {$params(use_chainadder) eq "true" && $params(operation_mode) eq "m18x18_full"} {
		send_message error "Output cascade is not supported in this mode."	
	}
	
	if { ($params(load_const_clock) ne "none" || $params(load_const_pipeline_clock) ne "none" )&& $params(operation_mode) eq "m18x18_full"} {
		send_message error "Input 'loadconst' is not supported in this mode."
	}
	
	if {$params(negate_clock) ne "none" && $params(operation_mode) eq "m18x18_full"} {
		send_message error "Input 'negate' is not supported in this mode."
	}
	
	if {$params(gui_chainout_enable) eq "true" && $params(operation_mode) eq "m18x18_full"} {
		send_message error "Output cascade is not supported in this operation mode."	
	}
	#Added for enable_accumulate
	if { $params(enable_accumulate) eq "true" && $params(operation_mode) eq "m18x18_full"} {
		send_message error "Input 'accumulate' is not supported in this mode."
	}
	
	if { ( $params(accumulate_clock) ne "none" || $params(accum_pipeline_clock) ne "none")  && $params(operation_mode) eq "m18x18_full"} {
		send_message error "'Accumulate' is not supported in this mode."
	}
	
	if { $params(enable_accumulate) eq "true" && $params(operation_mode) ne "m18x18_full" && $params(output_clock) eq "none" } {
		send_message error "When the 'accumulate' port is enabled, 'Use output register' must be set to either 'Clock0', 'Clock1' or 'Clock2'."
	}
	
	if { $params(enable_accumulate) eq "false"  && $params(accumulate_clock) ne "none" } {
		send_message error "'Register input accumulate of the accumulator' cannot be set to 'Clock0', 'Clock1' or 'Clock2' when 'Enable accumulate port' is set to 'No'."
	}
	
	#Added for enable_negate
	if { $params(operation_mode) eq "m18x18_full" && ($params(enable_negate) eq "true" || $params(negate_clock) ne "none")} {
		send_message error "Input 'negate' is not supported in this mode."
	}
	
	#Added for enable_negate input register
	if {$params(negate_clock) ne "none" && $params(enable_negate) eq "false"} {
		send_message error "\"Enable 'negate' port\" must be set to \"Yes\" when \"Register input 'negate' of the adder unit\" is set to \"Clock0/Clock1/Clock2\"."
	}
	
	#Added for enale_loadconst
	if { $params(enable_loadconst) eq "true" && $params(operation_mode) eq "m18x18_full"} {
		send_message error "Input 'loadconst' is not supported in this mode."
	}
	#Added for input register loadconst
	if { $params(enable_loadconst) eq "false"  && $params(load_const_clock) ne "none" } {
		send_message error "\"Enable 'loadconst' port\" must be set to \"Yes\" when \"Register input 'loadconst' of the loadconst\" is set to \"Clock0/Clock1/Clock2\"."
	}
	
	#Added for pipeline register loadconst
	if { $params(enable_loadconst) eq "false"  && $params(load_const_pipeline_clock) ne "none"} {
		send_message error "\"Enable 'loadconst' port\" must be set to \"Yes\" when \"Add input pipeline register to the 'loadconst' data signal\" is set to \"Clock0/Clock1/Clock2\"."
	}
	
	#Added for negate_pipeline_clock
	if { $params(enable_negate) eq "false" && $params(negate_pipeline_clock) ne "none" } {
		send_message error "\"Enable 'negate' port\" must be set to \"Yes\" when \"Add input pipeline register to the 'negate' data signal\" is set to \"Clock0/Clock1/Clock2\"."
	}
	
	#Added for sub_pipeline_clock
	if { $params(enable_sub) eq "false" && $params(sub_pipeline_clock) ne "none" } {
		send_message error "\"Enable 'sub' port\" must be set to \"Yes\" when \"Add input pipeline register to the 'sub' data signal\" is set to \"Clock0/Clock1/Clock2\"."
	}
	
	# Clocking Scheme
	#+---------------
	
	# systolic
	if {$params(operation_mode) eq "m18x18_systolic" && $params(output_clock) eq "none"} {
		send_message error "When m18x18_systolic mode is used, 'Use output register' must be set to either 'Clock0', 'Clock1' or 'Clock2'."
	}
	
	# internal coefficient
	if {$params(operand_source_max) eq "coef" && $params(operation_mode) ne "m18x18_plus36"} {
		if {$params(ax_clock) ne "none"} {
			send_message error "When Internal Coefficient is enabled, use \"Register input 'coefsela' of the multiplier\" instead of \"Register input 'ax' of the multiplier\"."
		}
		if {$params(bx_clock) ne "none" && $params(operation_mode) ne "m27x27"} {
			send_message error "When Internal Coefficient is enabled, use \"Register input 'coefselb' of the multiplier\" instead of \"Register input 'bx' of the multiplier\"."
		}
	}
	
	# control signal
	if {$params(sub_clock) ne "none" || $params(negate_clock) ne "none" || $params(accumulate_clock) ne "none" || $params(load_const_clock) ne "none"} {
		if {$params(sub_clock) ne "none" && $params(negate_clock) ne "none"} {
			if {$params(sub_clock) ne $params(negate_clock)} {
				send_message error "Register input 'sub' and 'negate' must have the same clock settings."
			}
		}
		if {$params(sub_clock) ne "none" && $params(accumulate_clock) ne "none"} {
			if {$params(sub_clock) ne $params(accumulate_clock)} {
				send_message error "Register input 'sub' and 'accumulate' must have the same clock settings."
			}
		}
		if {$params(sub_clock) ne "none" && $params(load_const_clock) ne "none"} {
			if {$params(sub_clock) ne $params(load_const_clock)} {
				send_message error "Register input 'sub' and 'loadconst' must have the same clock settings."
			}
		}
		if {$params(negate_clock) ne "none" && $params(accumulate_clock) ne "none"} {
			if {$params(negate_clock) ne $params(accumulate_clock)} {
				send_message error "Register input 'negate' and 'accumulate' must have the same clock settings."
			}
		}
		if {$params(negate_clock) ne "none" && $params(load_const_clock) ne "none"} {
			if {$params(negate_clock) ne $params(load_const_clock)} {
				send_message error "Register input 'negate' and 'loadconst' must have the same clock settings."
			}
		}
		if {$params(accumulate_clock) ne "none" && $params(load_const_clock) ne "none"} {
			if {$params(accumulate_clock) ne $params(load_const_clock)} {
				send_message error "Register input 'accumulate' and 'loadconst' must have the same clock settings."
			}
		}
	}

     if {$params(operation_mode) eq "m18x18_full" || $params(operation_mode) eq "m18x18_sumof2" || $params(operation_mode) eq "m18x18_systolic"} {      
        if {$params(operand_source_may) ne "preadder"} {
            if {$params(az_width) ne 0} {
                send_message error "'az' input bus width needs to be set to '0' for the selected operation mode."
            }
        }
        if {$params(operand_source_mby) ne "preadder"} {
            if {$params(bz_width) ne 0} {
                send_message error "'bz' input bus width needs to be set to '0' for the selected operation mode."
            }
        }
    } 
    
    
    	if {$params(sub_pipeline_clock) ne "none" || $params(negate_pipeline_clock) ne "none" || $params(accum_pipeline_clock) ne "none" || $params(load_const_pipeline_clock) ne "none"} {
		if {$params(sub_pipeline_clock) ne "none" && $params(negate_pipeline_clock) ne "none"} {
			if {$params(sub_pipeline_clock) ne $params(negate_pipeline_clock)} {
				send_message error "Input pipeline register for 'sub' and 'negate' must have the same clock settings."
			}
		}
		if {$params(sub_pipeline_clock) ne "none" && $params(accum_pipeline_clock) ne "none"} {
			if {$params(sub_pipeline_clock) ne $params(accum_pipeline_clock)} {
				send_message error "Input pipeline register for 'sub' and 'accumulate' must have the same clock settings."
			}
		}
		if {$params(sub_pipeline_clock) ne "none" && $params(load_const_pipeline_clock) ne "none"} {
			if {$params(sub_pipeline_clock) ne $params(load_const_pipeline_clock)} {
				send_message error "Input pipeline register for 'sub' and 'loadconst' must have the same clock settings."
			}
		}
		if {$params(negate_pipeline_clock) ne "none" && $params(accum_pipeline_clock) ne "none"} {
			if {$params(negate_pipeline_clock) ne $params(accum_pipeline_clock)} {
				send_message error "Input pipeline register for 'negate' and 'accumulate' must have the same clock settings."
			}
		}
		if {$params(negate_pipeline_clock) ne "none" && $params(load_const_pipeline_clock) ne "none"} {
			if {$params(negate_pipeline_clock) ne $params(load_const_pipeline_clock)} {
				send_message error "Input pipeline register for 'negate' and 'loadconst' must have the same clock settings."
			}
		}
		if {$params(accum_pipeline_clock) ne "none" && $params(load_const_pipeline_clock) ne "none"} {
			if {$params(accum_pipeline_clock) ne $params(load_const_pipeline_clock)} {
				send_message error "Input pipeline register for 'accumulate' and 'loadconst' must have the same clock settings."
			}
		}
	}
    
    
	# Feature: Data input width
	# ----------------
	if {$params(bx_width) ne 18 && $params(operation_mode) eq "m18x18_plus36"} {
		send_message error "'bx_width' value must be 18 bits wide in m18x18_plus36 mode."
	}

	if {$params(by_width) ne 18 && $params(operation_mode) eq "m18x18_plus36" } {
		send_message error "'by_width' value must be 18 bits wide in m18x18_plus36 mode."
	}
	
	# Feature: preadder
	if {$params(operand_source_mby) eq "preadder" && $params(operation_mode) eq "m27x27"} {
		send_message error "Current mode does not support bottom preadder."
	}
	
	if { (($params(operand_source_may) eq "preadder" && $params(operand_source_mby) eq "input") || ( $params(operand_source_may) eq "input" && $params(operand_source_mby) eq "preadder")) && $params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_plus36" && !($params(operation_mode) eq "m18x18_full" &&  $params(by_width) eq 0)  } {
		send_message error "When preadder feature is used, both \"'ay' operand source\" and \"'by' operand source\" must be set to 'preadder'."
	}
	
	if { (( $params(preadder_subtract_a) eq "true" && $params(preadder_subtract_b) eq "false") || ( $params(preadder_subtract_a) eq "false" && $params(preadder_subtract_b) eq "true" )) && $params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_plus36" && !($params(operation_mode) eq "m18x18_full" &&  $params(by_width) eq 0) } {
		send_message error "The preadder operation for both top and bottom preadder must be the same."
	}
	
    if {($params(preadder_subtract_a) eq "true" && $params(operand_source_may) ne "preadder")} {
		send_message error "'Set pre-adder a operation to subtraction' can only be set to 'Yes' if 'ay operand source' is set to 'preadder'."
	}
	
	if { $params(preadder_subtract_b) eq "true" && $params(operand_source_mby) ne "preadder"} {
		send_message error "'Set pre-adder b operation to subtraction' can only be set to 'Yes' if 'by operand source' is set to 'preadder'."
	}
	
	#Feature 7:COEF
	if { $params(operand_source_mbx) eq "coef" && $params(operation_mode) eq "m27x27"} {
		send_message error "Current mode does not support the bottom coefficient feature."
	}
	
	#Feature 9: Delay scan out
	if { $params(by_use_scan_in) eq "false" && $params(delay_scan_out_ay) eq "true" && $params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_plus36"} {
		send_message error " \"Enable data ay delay register\" cannot be set to 'Yes' when \"Enable input cascade for 'by' input\" is set to 'No'."
	}
	
	#Feature 12: Double Accum 
	if { $params(enable_accumulate) eq "false" && $params(enable_double_accum) eq "true" } {
		send_message error "'Enable double accumulator' cannot be set to 'Yes' when 'Enable accumulate port' is set to 'No'."
	}
	
	#Added for Accum pipeline clock
	if { $params(enable_accumulate) eq "false"  && $params(accum_pipeline_clock) ne "none"} {
		send_message error "\"Enable 'accumulate' port\" must be set to \"Yes\" when \"Add input pipeline register to the 'accumulate' data signal\" is set to \"Clock0/Clock1/Clock2\"."
	}
		
	#Feature 18: Input clock
	if { $params(operation_mode) eq "m18x18_plus36" && $params(bx_clock) ne $params(by_clock) } {
		send_message error "For 'bx' and 'by' inputs used in m18x18_plus36 mode, both inputs must either be registered or not registered at the same time. When registered, both inputs must use the same clock source."
	}
	
	
	#m27x27 restriction
	if { $params(operation_mode) eq "m27x27" && ( $params(bx_clock) ne "none" || $params(by_clock) ne "none" || $params(bz_clock) ne "none")} {
		send_message error "The specific mode m27x27 does not support the bottom multiplier (b portion)."
	}
	
	
	#Feature 8: Scan Chain
	if { $params(by_width) ne 0 && $params(by_use_scan_in) eq "true" && $params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_plus36"} {
		send_message error "When \"Enable input cascade for 'by' input\" is set to 'Yes', the \"'by' input bus width\" must be set to 0."
	}
	
	#CHECK PREADDER_SUBTRACT_B NOT SUPPORTED FOR M27X27
	if { $params(operation_mode) eq "m27x27" && $params(preadder_subtract_b) eq "true"} {
		send_message error " Current mode does not support operation for bottom preadder"
	}
	
	
}

#+--------------------------------------------
#|
#|  General Information
#|
#+--------------------------------------------
proc general_info {} {

	# Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }
	
	# Operation mode
	if {$params(operation_mode) eq "m18x18_plus36"} {
		send_message info "Info: The 36-bit operand must be fully filled up for m18x18_plus36 mode."
		send_message info "Info: Connect \[17:0\] from the 36-bit input buses to \'by\'."
		send_message info "Info: Connect \[35:18\] from the 36-bit input buses to \'bx\'."
	}
	#Operation mode m18x18_full
	if {$params(operation_mode) eq "m18x18_full"} {
		send_message info "Info:Param 'result_b_width' value must be greater than 1 and smaller equal to 37 except when using only top multiplier"
	}
	
	# Input Cascade
	if {$params(ay_use_scan_in) eq "true" || $params(by_use_scan_in) eq "true"} {	
		if {$params(operand_source_may) eq "preadder" || $params(operand_source_mby) eq "preadder"} {
				send_message info "Info: When both pre-adder and input cascade are enabled, only 18-bit out of the 19-bit input cascade can be used."
		}
	}
	
	# Pre-adder
	if {$params(operand_source_may) eq "preadder"} {
		send_message info  "Info: Pre-adder supports 18-bit (signed) or 17-bit (unsigned) addition for 18x18 style, and 26-bit addition for 27x27 style."
	}
			
	# Internal Coefficient
	if {$params(operand_source_max) eq "coef"} {
		send_message info "Info: 8 constant coefficients can be stored in MAC internal memory to feed the operand 'x', and they are specified in coef_a_0~7 and coef_b_0~7."
		send_message info "Info: Each constant coefficient can be 18-bit or 27-bit wide for 18x18 style and 27x27 style respectively."
		send_message info "Info: The constant coefficients must be specified as integer."
	}
	
	# Accumulator/Output Cascade
	if {$params(use_chainadder) eq "true"} {
		send_message info "Info: The 'chainin' input port must be sourced from the 'chainout' output port from preceding DSP block."	

		if {$params(operation_mode) ne "m18x18_systolic"} {
			send_message info "Info: When output cascade is enabled, the full 64-bit chain wire must be fully connected."
		}
		
		if {$params(operation_mode) eq "m18x18_systolic"} {
			send_message info "Info: When output cascade is enabled and operation mode is m18x18_systolic, only 44-bit out of the 64-bit chain wire can be used."	
		}
		if {$params(ay_use_scan_in) eq "true"} {
			send_message info "Info: When both input and output cascade are enabled, the 'chainin' and 'scanin' input ports must be sourced from the 'chainout' and 'scanout' output signals from the same preceding DSP block."	
		}
	}
	if {$params(gui_chainout_enable) eq "true"} {
		send_message info "Info: The 'chainout' output port must be connected to the 'chainin' input port of the next DSP block."	
	}
	
	# Clocking Scheme
	if {$params(sub_clock) ne "none" || $params(negate_clock) ne "none" || $params(accumulate_clock) ne "none" || $params(load_const_clock) ne "none"} {
		send_message info "Info: If the control signal (sub,negate,accumulate,loadconst) is tied to a constant value, the corresponding control signal input register must not be used"
	}
	if {$params(sub_pipeline_clock) ne "none" || $params(negate_pipeline_clock) ne "none" || $params(accum_pipeline_clock) ne "none" || $params(load_const_pipeline_clock) ne "none"} {
		send_message info "Info: If the control signal (sub,negate,accumulate,loadconst) is tied to constant value, the corresponding control signal pipeline register must be disabled or their value set to \"NONE\"."
	}
	
	# Check if any register is enable
	set is_one_or_more_regs_used [get_register_usage]
	if {$is_one_or_more_regs_used} {
		send_message info "Clock scheme: Three clock and clock-enable pairs, and two asynchronous clear signals are supported." 
		send_message info "Clock scheme: Three clock signals are connected to a 3-bit 'clk' input port, clk\[2:0\]. clk\[0\] represents clock source 0, clk\[1\] represents clock source 1, and clk\[2\] represents clock source 2."	
		send_message info "Clock scheme: Three clock-enable signals are connected to a 3-bit 'ena' input port, ena\[2:0\]. ena\[0\] represents clock-enable source 0, ena\[1\] represents clock-enable source 1, and ena\[2\] represents clock-enable source 2."
		send_message info "Clock scheme: Two asynchronous clear signals are connected to a 2-bit 'aclr' input port, aclr\[1:0\]. aclr\[0\] represents asynchronous clear source 0, aclr\[1\] represents asynchronous clear source 1."
		send_message info "Clock scheme: Asynchronous clear signals are dedicated: all input registers use aclr\[0\] and all output registers and pipeline registers use aclr\[1\]."
	}
}