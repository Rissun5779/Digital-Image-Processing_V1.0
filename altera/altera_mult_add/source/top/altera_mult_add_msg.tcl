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


# (C) 2002-2010 Altera Corporation. All rights reserved.
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

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/altera_mult_add/source/top/altera_mult_add_msg.tcl#1 $
# | 
# +-----------------------------------

# +-----------------------------------
# | 
# | Parameter's value rules check  
# | 
# +-----------------------------------
proc error_check {} {

	set get_device [get_parameter_value selected_device_family]
	set get_number_of_multiplier [get_parameter_value number_of_multipliers]
	set get_width_a [get_parameter_value width_a]
	set get_width_b [get_parameter_value width_b]
	set get_width_c [get_parameter_value width_c]
	set get_input_register_a [get_parameter_value gui_input_register_a]
	set get_input_register_a_clock [get_parameter_value gui_input_register_a_clock]
	set get_input_register_a_aclr [get_parameter_value gui_input_register_a_aclr]
	set get_input_register_b [get_parameter_value gui_input_register_b]
	set get_input_register_b_clock [get_parameter_value gui_input_register_b_clock]
	set get_input_register_b_aclr [get_parameter_value gui_input_register_b_aclr]
	set get_representation_a [get_parameter_value gui_representation_a]
	set get_representation_b [get_parameter_value gui_representation_b]	
	set get_register_signa [get_parameter_value gui_register_signa]
	set get_register_signa_clock [get_parameter_value gui_register_signa_clock]
	set get_register_signa_aclr [get_parameter_value gui_register_signa_aclr]
	set get_register_signb [get_parameter_value gui_register_signb]
	set get_register_signb_clock [get_parameter_value gui_register_signb_clock]
	set get_register_signb_aclr [get_parameter_value gui_register_signb_aclr]	
	set get_coef_register [get_parameter_value gui_coef_register]
	set get_coef_register_clock [get_parameter_value gui_coef_register_clock]
	set get_coef_register_aclr [get_parameter_value gui_coef_register_aclr]
	set get_output_register_clock [get_parameter_value gui_output_register_clock]
	set get_output_register_aclr [get_parameter_value gui_output_register_aclr]
	set get_systolic_delay_clock [get_parameter_value gui_systolic_delay_clock]
	set get_systolic_delay_aclr [get_parameter_value gui_systolic_delay_aclr]
	
	#Added by sukumar-SCLR SUPPORT
	set get_output_register_sclr [get_parameter_value gui_output_register_sclr]
	set get_register_signa_sclr [get_parameter_value gui_register_signa_sclr]
	set get_register_signb_sclr [get_parameter_value gui_register_signb_sclr]
	set get_input_register_a_sclr [get_parameter_value gui_input_register_a_sclr]
	set get_input_register_b_sclr [get_parameter_value gui_input_register_b_sclr]
	set get_coef_register_sclr [get_parameter_value gui_coef_register_sclr]
	set get_systolic_delay_sclr [get_parameter_value gui_systolic_delay_sclr]
	set get_addnsub_multiplier_aclr1 [get_parameter_value gui_addnsub_multiplier_aclr1]
	set get_addnsub_multiplier_aclr3 [get_parameter_value gui_addnsub_multiplier_aclr3]
	set get_scanouta_register_aclr [get_parameter_value gui_scanouta_register_aclr]
	set get_datac_input_register_aclr [get_parameter_value gui_datac_input_register_aclr]
	set get_accum_sload_register_aclr [get_parameter_value gui_accum_sload_register_aclr]
	set get_input_latency_aclr [get_parameter_value gui_input_latency_aclr]
	set get_addnsub_multiplier_sclr1 [get_parameter_value gui_addnsub_multiplier_sclr1]
	set get_addnsub_multiplier_sclr3 [get_parameter_value gui_addnsub_multiplier_sclr3]
	set get_scanouta_register_sclr [get_parameter_value gui_scanouta_register_sclr]
	set get_datac_input_register_sclr [get_parameter_value gui_datac_input_register_sclr]
	set get_accum_sload_register_sclr [get_parameter_value gui_accum_sload_register_sclr]
	set get_input_latency_sclr [get_parameter_value gui_input_latency_sclr]
	
	#Extra mode, adder operation
	set get_multiplier1_direction [get_parameter_value gui_multiplier1_direction]
	set get_multiplier3_direction [get_parameter_value gui_multiplier3_direction]
	set get_use_subnadd [get_parameter_value gui_use_subnadd]
	
	#pipeline register
	set get_pipelining [get_parameter_value gui_pipelining]
	set get_latency [get_parameter_value latency]
	#chainout adder
	set get_chainout_adder [get_parameter_value chainout_adder]
	set get_chainout_adder_direction [get_parameter_value chainout_adder_direction]
	set get_port_negate [get_parameter_value port_negate]
	set get_negate_register [get_parameter_value negate_register]
	set get_negate_aclr [get_parameter_value negate_aclr]
	#Added for sclr support
	set get_negate_sclr [get_parameter_value negate_sclr]
	
	set is_use_multiplier_register [get_parameter_value gui_multiplier_register]
	set is_use_output_register [get_parameter_value gui_output_register]	
	set is_use_accumulator_mode [get_parameter_value accumulator]
	set is_use_systolic_mode [get_parameter_value gui_systolic_delay]
	set is_use_port_addnsub1 [get_parameter_value port_addnsub1]
	set is_use_port_addnsub3 [get_parameter_value port_addnsub3]
	set get_double_accum [get_parameter_value gui_double_accum]
	set get_preadder_mode [get_parameter_value preadder_mode]
	set is_use_register_signa [expr {$get_representation_a eq "VARIABLE" && $get_register_signa eq "true"}]
	set is_use_register_signb [expr {$get_representation_b eq "VARIABLE" && $get_register_signb eq "true"}]
	
	
	# Display error message for non-valid settings
	
	#aclr/sclr condition
	if {($get_output_register_aclr ne "NONE" || $get_addnsub_multiplier_aclr1 ne "NONE" || $get_addnsub_multiplier_aclr3 ne "NONE" || $get_register_signa_aclr ne "NONE" || $get_register_signb_aclr ne "NONE" || $get_input_register_a_aclr ne "NONE" || $get_input_register_b_aclr ne "NONE" || $get_scanouta_register_aclr ne "NONE" || $get_datac_input_register_aclr ne "NONE" || $get_coef_register_aclr ne "NONE" || $get_accum_sload_register_aclr ne "NONE" || $get_negate_aclr ne "NONE" || $get_systolic_delay_aclr ne "NONE" || $get_input_latency_aclr ne "NONE") && ($get_output_register_sclr ne "NONE" || $get_addnsub_multiplier_sclr1 ne "NONE" || $get_addnsub_multiplier_sclr3 ne "NONE" || $get_register_signa_sclr ne "NONE" || $get_register_signb_sclr ne "NONE" || $get_input_register_a_sclr ne "NONE" || $get_input_register_b_sclr ne "NONE" || $get_scanouta_register_sclr ne "NONE" || $get_datac_input_register_sclr ne "NONE" || $get_coef_register_sclr ne "NONE" || $get_accum_sload_register_sclr ne "NONE" || $get_negate_sclr ne "NONE" || $get_systolic_delay_sclr ne "NONE" || $get_input_latency_sclr ne "NONE") } {
		send_message error "Cannot select both aclr and sclr together"
	}
	if {$is_use_accumulator_mode eq "YES" && $is_use_output_register eq "false"} {
		send_message error "Output register must be enabled when Accumulator mode is enabled"
	}
	if {$is_use_systolic_mode eq "true" && $is_use_output_register eq "false"} {
		send_message error "Output register must be enabled when Systolic Delay mode is enabled"
	}
	if {$is_use_port_addnsub1 eq "PORT_USED" && $get_number_of_multiplier < 2} {
		send_message error "Cannot connect port_addnsub1 when NUMBER_OF_MULTIPLIERS parameter has value ${get_number_of_multiplier} -- value must be greater than or equal to 2"
	}
	if {$is_use_port_addnsub3 eq "PORT_USED" && $get_number_of_multiplier < 4} {
		send_message error "Cannot connect port_addnsub3 when NUMBER_OF_MULTIPLIERS parameter has value ${get_number_of_multiplier} -- value must be equal to 4"
	}		
	if {($get_device eq "stratixv" || $get_device eq "Stratix V")  && $get_double_accum eq "true"} {
		send_message error "Double accumulator is not supported for the ${get_device} device family"
	}
	if {$is_use_accumulator_mode ne "YES" && $get_double_accum eq "true"} {
		send_message error "Double accumulator is not supported when Accumulator is not enabled. To use Accumulator, please set ACCUMULATOR parameter to YES"
	}
	if {($get_width_a > 25 || $get_width_b > 25 || $get_width_c > 22) && $get_preadder_mode eq "INPUT"} {
		
		if {$get_width_a > 25} {
			send_message error "A input buses is greater than 25 for PREADDER_MODE=INPUT -- value must be less than 25"
		}
		if {$get_width_b > 25} {
			send_message error "B input buses is greater than 25 for PREADDER_MODE=INPUT -- value must be less than 25"
		}
		if {$get_width_c > 22} {
			send_message error "A input buses is greater than 22 for PREADDER_MODE=INPUT -- value must be less than 22"
		}
	}
	if {$is_use_systolic_mode eq "true" && ($get_number_of_multiplier == 1 || $get_number_of_multiplier == 3)} {
		send_message error "SYSTOLIC_DELAY can only be used when NUMBER_OF_MULTIPLIERS equals to 2 or 4"
	}
	if {$get_input_register_a eq "true" && $is_use_register_signa} {
		if {$get_input_register_a_clock ne $get_register_signa_clock} {
			send_message error "The value of SIGNED_REGISTER_A should have similar values with of INPUT_REGISTER_A0"
		}
		if {$get_input_register_a_aclr ne $get_register_signa_aclr} {
			send_message error "The value of SIGNED_ACLR_A should have similar values with of INPUT_ACLR_A0"
		}
		#Added for sclr support
		if {$get_input_register_a_sclr ne $get_register_signa_sclr} {
			send_message error "The value of SIGNED_SCLR_A should have similar values with of INPUT_SCLR_A0"
		}
	}
	if {$get_input_register_b eq "true" && $is_use_register_signb} {
		if {$get_register_signb_clock ne $get_input_register_a_clock} {
			send_message error "The value of SIGNED_REGISTER_B should have similar values with of INPUT_REGISTER_A0"
		}
		if {$get_register_signb_aclr ne $get_input_register_a_aclr} {
			send_message error "The value of SIGNED_ACLR_B should have similar values with of INPUT_ACLR_A0"
		}
		#Added by sukumar-SCLR SUPPORT
		if {$get_register_signb_sclr ne $get_input_register_a_sclr} {
			send_message error "The value of SIGNED_SCLR_B should have similar values with of INPUT_SCLR_A0"
		}
	}
	if {$get_input_register_b eq "true" && $is_use_register_signb} {
		if {$get_input_register_b_clock ne $get_input_register_a_clock} {
			send_message error "When sign[] port is used, the value of INPUT_REGISTER_B\[0..3\] should have similar values with INPUT_REGISTER_A0"
		}
		if {$get_input_register_b_aclr ne $get_register_signb_aclr} {
			send_message error "When sign[] port is used, The value of INPUT_ACLR_B\[0..3\] should have similar values with of INPUT_ACLR_A0"
		}
		#Added for SCLR-SUPPORT
		if {$get_input_register_b_sclr ne $get_register_signb_sclr} {
			send_message error "When sign[] port is used, The value of INPUT_SCLR_B\[0..3\] should have similar values with of INPUT_SCLR_A0"
		}
	}
#	if {$get_input_register_a eq "true" && $get_coef_register eq "true"} {
#		if {$get_input_register_a_clock ne $get_coef_register_clock} {
#			send_message warning "The value of COEFFSEL\[0..3\]_REGISTER must be set similar to the value of INPUT_REGISTER_A0"
#		}
#		if {$get_input_register_a_aclr ne $get_coef_register_aclr} {
#			send_message warning "The value of COEFFSEL\[0..3\]_ACLR must be set similar to the value of INPUT_ACLR_A0"
#		}
#	}
	if {$is_use_systolic_mode eq "true"} {
		if {$get_output_register_clock ne $get_systolic_delay_clock} {
			send_message error "The value of SYSTOLIC_DELAY\[1, 3\] must be set similar to the value of OUTPUT_REGISTER"
		}
		if {$get_output_register_aclr ne $get_systolic_delay_aclr} {
			send_message error "The value of SYSTOLIC_ACLR\[1, 3\] must be set similar to the value of OUTPUT_ACLR"
		}
		#Added by sukumar-SCLR SUPPORT
		if {$get_output_register_sclr ne $get_systolic_delay_sclr} {
			send_message error "The value of SYSTOLIC_SCLR\[1, 3\] must be set similar to the value of OUTPUT_SCLR"
		}
	}
	
	if {$get_pipelining == 1 && $get_latency < 1} {
		send_message error "The number of latency clock cycles must be greater than 0"
	}
	
	if {$is_use_multiplier_register == "true"} {
		send_message error "The option Register output of the multiplier must be disabled, it's no longer being supported"
		send_message info "Please use the pipelining configuration for extra latency"
	}
	if {$is_use_systolic_mode eq "true" && $get_chainout_adder == "YES"} {
		send_message error "Systolic Delay and Chainout Adder is both enaled.  To use Systolic Delay, please disable Chainout Adder and vice versa"
	}
	if {$get_chainout_adder == "YES" && ($get_chainout_adder_direction == "SUB" || $get_port_negate == "PORT_USED") && ($get_representation_a != "SIGNED" || $get_representation_b != "SIGNED")} {
		send_message error "For Chainout Adder direction with subtraction/negate operation type, the representation format for Multipliers A and B inputs must be set to SIGNED"
	}
	if {$get_use_subnadd eq "true" && ($get_multiplier1_direction ne "VARIABLE" && $get_multiplier3_direction ne "VARIABLE")} {
		send_message error "The option \"use_subnadd\" must be disabled when \"addnsub\" port is unused"
	}
	if {$get_chainout_adder == "NO"} {
		
		send_message info "chainout adder operation type is ignored when chainout adder is disabled"
		
		if {$get_port_negate == "PORT_USED"} {
			send_message error "Cannot use negate input signal when chainout adder is disabled"
		}
		if {$get_negate_register != "UNREGISTERED"} {
			send_message error "Cannot register negate input signal when chainout adder is disabled"
		}
		if {$get_negate_aclr != "NONE"} {
			send_message error "Cannot use negate aclr signal when chainout adder is disabled"
		}
		#Added by sukumar
		if {$get_negate_sclr != "NONE"} {
			send_message error "Cannot use negate sclr signal when chainout adder is disabled"
		}
	} else {
		if {$get_port_negate == "PORT_USED"} {
			send_message info "chainout adder operation type is ignored when negate input signal is enabled"
		}
		if {$get_port_negate != "PORT_USED"} {
			if {$get_negate_register != "UNREGISTERED"} {
				send_message error "Cannot register negate signal when negate input is not used"
			}
		}	
		if {$get_negate_register == "UNREGISTERED"} {
			if {$get_negate_aclr != "NONE"} {
				send_message error "Cannot use negate aclr signal when negate input is not registered"
			}
			#Added for SCLR SUPPORT
			if {$get_negate_sclr != "NONE"} {
				send_message error "Cannot use negate sclr signal when negate input is not registered"
			}
		}
	}
}
