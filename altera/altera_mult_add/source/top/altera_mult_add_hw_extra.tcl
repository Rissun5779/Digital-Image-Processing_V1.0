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
# | $Header: //acds/rel/18.1std/ip/altera_mult_add/source/top/altera_mult_add_hw_extra.tcl#1 $
# | 
# +-----------------------------------
set WIZARD_NAME "altera_mult_add"
package require -exact qsys 14.0
package require altera_terp

# This source file not needed 
# For details refer to https://sw-wiki.altera.com/twiki/bin/view/Software/IPComponentsInVerilog
#source ../../../sopc_builder_ip/altera_avalon_mega_common/ipcc_wrap_split.tcl
#source ../../../sopc_builder_ip/altera_avalon_mega_common/sopc_mwizc.tcl
#source ../../../altera_xcvr_generic/alt_xcvr_common.tcl

source altera_mult_add_proc.tcl
source altera_mult_add_ui_rules.tcl
source altera_mult_add_msg.tcl
# +-----------------------------------
#
# | Elaboration callback
# | 
# | 
# +-----------------------------------
proc elaboration_callback {} {
	
	#declare ports and mappings for elaboration callback
	interface_ports_and_mapping elaboration
	
	#common code function to declare interface ports from mapping data
#	ipcc_elaboration_declarations
	
}

# +-----------------------------------
# |
# | Declare dynamic interfaces and ports
# | flag == elaboration means real interfaces and ports must be declared
# |	flag == mapping_only declares no interfaces or ports, and returns the mapping data
# |			to map from HDL ports to interfaces
# +-----------------------------------
proc interface_ports_and_mapping { flag } {
	
	#ipcc_init_mappings $flag

	#declare constant
	set NUMBER_OF_MULT 4
	set NUMBER_OF_CLOCK_ACLR_SIGNAL 4
	
	#Added for sclr support
	set NUMBER_OF_CLOCK_SCLR_SIGNAL 4
	
	# +------------------------------------------------------------------------------------------------
	# | 
	# | Retrieve parameter value
	# | 
	# +------------------------------------------------------------------------------------------------
	set get_number_of_multiplier [get_parameter_value number_of_multipliers]
	set get_width_a [get_parameter_value width_a]
	set get_width_b [get_parameter_value width_b]
	set get_width_c [get_parameter_value width_c]
	set get_width_chainin [get_parameter_value width_chainin]
	set get_width_result [get_parameter_value width_result]
	set is_use_associated_clock_enable [get_parameter_value gui_associated_clock_enable]
	set get_device [get_parameter_value selected_device_family]
		
	set get_representation_a [get_parameter_value gui_representation_a]
	set get_register_signa [get_parameter_value gui_register_signa]
	set get_register_signa_clock [get_parameter_value gui_register_signa_clock]
	set get_register_signa_aclr [get_parameter_value gui_register_signa_aclr]
	
	set get_representation_b [get_parameter_value gui_representation_b]
	set get_register_signb [get_parameter_value gui_register_signb]
	set get_register_signb_clock [get_parameter_value gui_register_signb_clock]
	set get_register_signb_aclr [get_parameter_value gui_register_signb_aclr]
	
	set get_output_register [get_parameter_value gui_output_register]
	set get_output_register_clock [get_parameter_value gui_output_register_clock]
	set get_output_register_aclr [get_parameter_value gui_output_register_aclr]
	
	#Added by sukumar-SCLR SUPPORT
	set get_output_register_sclr [get_parameter_value gui_output_register_sclr]
	set get_addnsub_multiplier_sclr1 [get_parameter_value gui_addnsub_multiplier_sclr1]
	set get_addnsub_multiplier_sclr3 [get_parameter_value gui_addnsub_multiplier_sclr3]
	set get_register_signa_sclr [get_parameter_value gui_register_signa_sclr]
	set get_register_signb_sclr [get_parameter_value gui_register_signb_sclr]
	set get_input_register_a_sclr [get_parameter_value gui_input_register_a_sclr]
	set get_input_register_b_sclr [get_parameter_value gui_input_register_b_sclr]
	set get_scanouta_register_sclr [get_parameter_value gui_scanouta_register_sclr]
	set get_multiplier_reg_sclr [get_parameter_value gui_multiplier_register_sclr]
	set get_datac_input_register_sclr [get_parameter_value gui_datac_input_register_sclr]
	set get_coef_register_sclr [get_parameter_value gui_coef_register_sclr]
	set get_accum_sload_register_sclr [get_parameter_value gui_accum_sload_register_sclr]
	set get_systolic_delay_sclr [get_parameter_value gui_systolic_delay_sclr]
	
	set get_multiplier1_direction [get_parameter_value gui_multiplier1_direction]
	set get_addnsub_multiplier_register1 [get_parameter_value gui_addnsub_multiplier_register1]
	set get_addnsub_multiplier_register1_clock [get_parameter_value gui_addnsub_multiplier_register1_clock]
	set get_addnsub_multiplier_aclr1 [get_parameter_value gui_addnsub_multiplier_aclr1]
	set get_multiplier_a_input [get_parameter_value gui_multiplier_a_input]
	set get_scanouta_register [get_parameter_value gui_scanouta_register]
	set get_scanouta_register_clock [get_parameter_value gui_scanouta_register_clock]
	set get_scanouta_register_aclr [get_parameter_value gui_scanouta_register_aclr]
	
	set get_multiplier3_direction [get_parameter_value gui_multiplier3_direction]
	set get_addnsub_multiplier_register3 [get_parameter_value gui_addnsub_multiplier_register3]
	set get_addnsub_multiplier_register3_clock [get_parameter_value gui_addnsub_multiplier_register3_clock]
	set get_addnsub_multiplier_aclr3 [get_parameter_value gui_addnsub_multiplier_aclr3]
	set get_multiplier_b_input [get_parameter_value gui_multiplier_b_input]
	
	set get_use_subnadd [get_parameter_value gui_use_subnadd]
	
	set get_input_register_a [get_parameter_value gui_input_register_a]
	set get_input_register_a_clock [get_parameter_value gui_input_register_a_clock]
	set get_input_register_a_aclr [get_parameter_value gui_input_register_a_aclr]

	set get_input_register_b [get_parameter_value gui_input_register_b]
	set get_input_register_b_clock [get_parameter_value gui_input_register_b_clock]
	set get_input_register_b_aclr [get_parameter_value gui_input_register_b_aclr]
	
	set get_multiplier_reg [get_parameter_value gui_multiplier_register]
	set get_multiplier_reg_clock [get_parameter_value gui_multiplier_register_clock]
	set get_multiplier_reg_aclr [get_parameter_value gui_multiplier_register_aclr]
	
	set get_preadder_mode [get_parameter_value preadder_mode]
	set get_preadder_direction [get_parameter_value gui_preadder_direction]
	set get_coef_register [get_parameter_value gui_coef_register]
	set get_coef_register_clock [get_parameter_value gui_coef_register_clock]
	set get_coef_register_aclr [get_parameter_value gui_coef_register_aclr]
	set get_datac_input_register [get_parameter_value gui_datac_input_register]
	set get_datac_input_register_clock [get_parameter_value gui_datac_input_register_clock]
	set get_datac_input_register_aclr [get_parameter_value gui_datac_input_register_aclr]
	
	set get_accumulator [get_parameter_value accumulator]
	set get_ena_preload_const [get_parameter_value gui_ena_preload_const]
	set get_accumulate_port_select [get_parameter_value gui_accumulate_port_select]
	set get_accum_sload_register_clock [get_parameter_value gui_accum_sload_register_clock]
	set get_accum_sload_register_aclr [get_parameter_value gui_accum_sload_register_aclr]
	set get_double_accum [get_parameter_value gui_double_accum]

	set get_systolic_delay [get_parameter_value gui_systolic_delay]
	set get_systolic_delay_clock [get_parameter_value gui_systolic_delay_clock]
	set get_systolic_delay_aclr [get_parameter_value gui_systolic_delay_aclr]
	
	#chainout adder
	set get_chainout_adder [get_parameter_value chainout_adder]
	set get_chainout_adder_direction [get_parameter_value chainout_adder_direction]
	set get_port_negate [get_parameter_value port_negate]
	set get_negate_register [get_parameter_value negate_register]
	set get_negate_aclr [get_parameter_value negate_aclr]
	#Added for SCLR SUPPORT
	set get_negate_sclr [get_parameter_value negate_sclr]
	
	#pipelining
	set get_pipelining [get_parameter_value gui_pipelining]
	set get_input_latency_clock [get_parameter_value gui_input_latency_clock]
	set get_input_latency_aclr [get_parameter_value gui_input_latency_aclr]
	
	#Added for sclr support
	set get_input_latency_sclr [get_parameter_value gui_input_latency_sclr]
	
	#infernal use parameters
	set get_reg_autovec_sim [get_parameter_value reg_autovec_sim]
	
	# +------------------------------------------------------------------------------------------------
	# | 
	# | Parameter value validation (feature usage checking)
	# | 
	# +------------------------------------------------------------------------------------------------
	#check feature usage
	set is_use_dataa_scan_chain [expr {$get_number_of_multiplier > 1 && $get_multiplier_a_input eq "Scan chain input"}]
	set is_use_multiplier1_addnsub [expr {$get_number_of_multiplier > 1 && $get_multiplier1_direction eq "VARIABLE"}]
	set is_use_multiplier3_addnsub [expr {$get_number_of_multiplier == 4 && $get_multiplier3_direction eq "VARIABLE"}]
	set is_use_systolic [expr {($get_number_of_multiplier == 4 || $get_number_of_multiplier == 2) && $get_systolic_delay eq "true"}]
	
	#check register usage
	set is_use_register_signa [expr {$get_representation_a eq "VARIABLE" && $get_register_signa eq "true"}]
	set is_use_register_signb [expr {$get_representation_b eq "VARIABLE" && $get_register_signb eq "true"}]
	set is_use_addnsub_multiplier_register1 [expr {$is_use_multiplier1_addnsub && $get_addnsub_multiplier_register1 eq "true"}]
	set is_use_addnsub_multiplier_register3 [expr {$is_use_multiplier3_addnsub && $get_addnsub_multiplier_register3 eq "true"}]
	set is_use_coef_register [expr {($get_preadder_mode eq "CONSTANT" || $get_preadder_mode eq "COEF") && $get_coef_register eq "true"}]
	set is_use_datac_input_register [expr {$get_preadder_mode eq "INPUT" && $get_datac_input_register eq "true"}]
	set is_use_accum_sload_register [expr {$get_accumulator eq "YES" && $get_ena_preload_const eq "true"}]
	
	for { set i 0 } {$i < $NUMBER_OF_CLOCK_ACLR_SIGNAL} {incr i} {
		
		#clock signal usage checking
		set is_signa_reg_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_register_signa" "gui_register_signa_clock" "CLOCK${i}"]
		set is_signb_reg_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_register_signb" "gui_register_signb_clock" "CLOCK${i}"]
		set is_output_reg_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_output_register" "gui_output_register_clock" "CLOCK${i}"]
		set is_addnsub_multiplier_register1_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_addnsub_multiplier_register1" "gui_addnsub_multiplier_register1_clock" "CLOCK${i}"]
		set is_addnsub_multiplier_register3_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_addnsub_multiplier_register3" "gui_addnsub_multiplier_register3_clock" "CLOCK${i}"]
		set is_input_reg_a_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_input_register_a" "gui_input_register_a_clock" "CLOCK${i}"]
		set is_input_reg_b_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_input_register_b" "gui_input_register_b_clock" "CLOCK${i}"]
		set is_multiplier_reg_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_multiplier_register" "gui_multiplier_register_clock" "CLOCK${i}"]
		set is_scanouta_reg_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_scanouta_register" "gui_scanouta_register_clock" "CLOCK${i}"]
		set is_coef_register_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_coef_register" "gui_coef_register_clock" "CLOCK${i}"]
		set is_datac_input_register_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_datac_input_register" "gui_datac_input_register_clock" "CLOCK${i}"]
		set is_accum_sload_register_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_accum_sload_register" "gui_accum_sload_register_clock" "CLOCK${i}"]
		set is_systolic_delay_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_systolic_delay" "gui_systolic_delay_clock" "CLOCK${i}"]
		set is_input_latency_use_clock($i) [is_use_dedicated_clock_or_aclr "gui_pipelining" "gui_input_latency_clock" "CLOCK${i}"]
		set is_negate_use_clock($i) [is_use_dedicated_clock_or_aclr "negate_register" "negate_register" "CLOCK${i}"]	
	
		#aclr signal usage checking
		set is_signa_reg_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_register_signa" "gui_register_signa_aclr" "ACLR${i}"]
		set is_signb_reg_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_register_signb" "gui_register_signb_aclr" "ACLR${i}"]
		set is_output_reg_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_output_register" "gui_output_register_aclr" "ACLR${i}"]
		set is_addnsub_multiplier_register1_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_addnsub_multiplier_register1" "gui_addnsub_multiplier_aclr1" "ACLR${i}"]
		set is_addnsub_multiplier_register3_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_addnsub_multiplier_register3" "gui_addnsub_multiplier_aclr3" "ACLR${i}"]
		set is_input_reg_a_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_input_register_a" "gui_input_register_a_aclr" "ACLR${i}"]
		set is_input_reg_b_use_aclr($i)  [is_use_dedicated_clock_or_aclr "gui_input_register_b" "gui_input_register_b_aclr" "ACLR${i}"]
		set is_multiplier_reg_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_multiplier_register" "gui_multiplier_register_aclr" "ACLR${i}"]
		set is_scanouta_reg_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_scanouta_register" "gui_scanouta_register_aclr" "ACLR${i}"]
		set is_coef_register_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_coef_register" "gui_coef_register_aclr" "ACLR${i}"]
		set is_datac_input_register_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_datac_input_register" "gui_datac_input_register_aclr" "ACLR${i}"]
		set is_accum_sload_register_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_accum_sload_register" "gui_accum_sload_register_aclr" "ACLR${i}"]
		set is_systolic_delay_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_systolic_delay" "gui_systolic_delay_aclr" "ACLR${i}"]
		set is_input_latency_use_aclr($i) [is_use_dedicated_clock_or_aclr "gui_pipelining" "gui_input_latency_aclr" "ACLR${i}"]
		set is_negate_use_aclr($i) [is_use_dedicated_clock_or_aclr "negate_aclr" "negate_aclr" "ACLR${i}"]
		
		#Added by sukumar-SCLR support
		#set is_signa_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_register_signa" "gui_register_signa_sclr" "SCLR${i}"]
		#set is_signb_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_register_signb" "gui_register_signb_sclr" "SCLR${i}"]
		#set is_output_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_output_register" "gui_output_register_sclr" "SCLR${i}"]
		#set is_addnsub_multiplier_register1_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_addnsub_multiplier_register1" "gui_addnsub_multiplier_sclr1" "SCLR${i}"]
		#set is_addnsub_multiplier_register3_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_addnsub_multiplier_register3" "gui_addnsub_multiplier_sclr3" "SCLR${i}"]
		#set is_input_reg_a_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_input_register_a" "gui_input_register_a_sclr" "SCLR${i}"]
		#set is_input_reg_b_use_sclr($i)  [is_use_dedicated_clock_or_sclr "gui_input_register_b" "gui_input_register_b_sclr" "SCLR${i}"]
		#set is_multiplier_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_multiplier_register" "gui_multiplier_register_sclr" "SCLR${i}"]
		#set is_scanouta_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_scanouta_register" "gui_scanouta_register_sclr" "SCLR${i}"]
		#set is_coef_register_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_coef_register" "gui_coef_register_sclr" "SCLR${i}"]
		#set is_datac_input_register_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_datac_input_register" "gui_datac_input_register_sclr" "SCLR${i}"]
		#set is_accum_sload_register_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_accum_sload_register" "gui_accum_sload_register_sclr" "SCLR${i}"]
		#set is_systolic_delay_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_systolic_delay" "gui_systolic_delay_sclr" "SCLR${i}"]
		#set is_input_latency_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_pipelining" "gui_input_latency_sclr" "SCLR${i}"]
		#set is_negate_use_sclr($i) [is_use_dedicated_clock_or_sclr "negate_sclr" "negate_sclr" "SCLR${i}"
		
		
		
		#clock usage expr
		set is_use_clock$i [expr {$is_signa_reg_use_clock($i) || $is_signb_reg_use_clock($i) || 
							 $is_output_reg_use_clock($i) || 
							 $is_addnsub_multiplier_register1_use_clock($i) || $is_addnsub_multiplier_register3_use_clock($i) || 
							 $is_input_reg_a_use_clock($i) || $is_input_reg_b_use_clock($i) || 
							 $is_multiplier_reg_use_clock($i) || 
							 $is_scanouta_reg_use_clock($i) ||
							 $is_coef_register_use_clock($i) ||
							 $is_datac_input_register_use_clock($i) ||
							 $is_accum_sload_register_use_clock($i) ||
							 $is_systolic_delay_use_clock($i) ||
							 $is_input_latency_use_clock($i) ||
							 $is_negate_use_clock($i)}]
		#aclr usage expr
		set is_use_aclr$i [expr {$is_signa_reg_use_aclr($i) || $is_signb_reg_use_aclr($i) || 
							$is_output_reg_use_aclr($i) || 
							$is_addnsub_multiplier_register1_use_aclr($i) || $is_addnsub_multiplier_register3_use_aclr($i) || 
							$is_input_reg_a_use_aclr($i) || $is_input_reg_b_use_aclr($i) || 
							$is_multiplier_reg_use_aclr($i) ||
							$is_scanouta_reg_use_aclr($i) ||
							$is_coef_register_use_aclr($i) ||
							$is_datac_input_register_use_aclr($i) ||
							$is_accum_sload_register_use_aclr($i) ||
							$is_systolic_delay_use_aclr($i) ||
							$is_input_latency_use_aclr($i) ||
							$is_negate_use_aclr($i)}]
	}

	#Added for SCLR SUPPORT-UPDATED
	for { set i 0 } {$i < $NUMBER_OF_CLOCK_SCLR_SIGNAL} {incr i} {
	
		#clock signal usage checking
		set is_signa_reg_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_register_signa" "gui_register_signa_clock" "CLOCK${i}"]
		set is_signb_reg_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_register_signb" "gui_register_signb_clock" "CLOCK${i}"]
		set is_output_reg_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_output_register" "gui_output_register_clock" "CLOCK${i}"]
		set is_addnsub_multiplier_register1_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_addnsub_multiplier_register1" "gui_addnsub_multiplier_register1_clock" "CLOCK${i}"]
		set is_addnsub_multiplier_register3_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_addnsub_multiplier_register3" "gui_addnsub_multiplier_register3_clock" "CLOCK${i}"]
		set is_input_reg_a_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_input_register_a" "gui_input_register_a_clock" "CLOCK${i}"]
		set is_input_reg_b_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_input_register_b" "gui_input_register_b_clock" "CLOCK${i}"]
		set is_multiplier_reg_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_multiplier_register" "gui_multiplier_register_clock" "CLOCK${i}"]
		set is_scanouta_reg_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_scanouta_register" "gui_scanouta_register_clock" "CLOCK${i}"]
		set is_coef_register_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_coef_register" "gui_coef_register_clock" "CLOCK${i}"]
		set is_datac_input_register_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_datac_input_register" "gui_datac_input_register_clock" "CLOCK${i}"]
		set is_accum_sload_register_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_accum_sload_register" "gui_accum_sload_register_clock" "CLOCK${i}"]
		set is_systolic_delay_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_systolic_delay" "gui_systolic_delay_clock" "CLOCK${i}"]
		set is_input_latency_use_clock($i) [is_use_dedicated_clock_or_sclr "gui_pipelining" "gui_input_latency_clock" "CLOCK${i}"]
		set is_negate_use_clock($i) [is_use_dedicated_clock_or_sclr "negate_register" "negate_register" "CLOCK${i}"]	
	
		#sclr signal usage checking		
		#Added by sukumar-SCLR support
		set is_signa_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_register_signa" "gui_register_signa_sclr" "SCLR${i}"]
		set is_signb_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_register_signb" "gui_register_signb_sclr" "SCLR${i}"]
		set is_output_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_output_register" "gui_output_register_sclr" "SCLR${i}"]
		set is_addnsub_multiplier_register1_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_addnsub_multiplier_register1" "gui_addnsub_multiplier_sclr1" "SCLR${i}"]
		set is_addnsub_multiplier_register3_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_addnsub_multiplier_register3" "gui_addnsub_multiplier_sclr3" "SCLR${i}"]
		set is_input_reg_a_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_input_register_a" "gui_input_register_a_sclr" "SCLR${i}"]
		set is_input_reg_b_use_sclr($i)  [is_use_dedicated_clock_or_sclr "gui_input_register_b" "gui_input_register_b_sclr" "SCLR${i}"]
		set is_multiplier_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_multiplier_register" "gui_multiplier_register_sclr" "SCLR${i}"]
		set is_scanouta_reg_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_scanouta_register" "gui_scanouta_register_sclr" "SCLR${i}"]
		set is_coef_register_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_coef_register" "gui_coef_register_sclr" "SCLR${i}"]
		set is_datac_input_register_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_datac_input_register" "gui_datac_input_register_sclr" "SCLR${i}"]
		set is_accum_sload_register_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_accum_sload_register" "gui_accum_sload_register_sclr" "SCLR${i}"]
		set is_systolic_delay_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_systolic_delay" "gui_systolic_delay_sclr" "SCLR${i}"]
		set is_input_latency_use_sclr($i) [is_use_dedicated_clock_or_sclr "gui_pipelining" "gui_input_latency_sclr" "SCLR${i}"]
		set is_negate_use_sclr($i) [is_use_dedicated_clock_or_sclr "negate_sclr" "negate_sclr" "SCLR${i}"]		
		
		
		#clock usage expr
		set is_use_clock$i [expr {$is_signa_reg_use_clock($i) || $is_signb_reg_use_clock($i) || 
							 $is_output_reg_use_clock($i) || 
							 $is_addnsub_multiplier_register1_use_clock($i) || $is_addnsub_multiplier_register3_use_clock($i) || 
							 $is_input_reg_a_use_clock($i) || $is_input_reg_b_use_clock($i) || 
							 $is_multiplier_reg_use_clock($i) || 
							 $is_scanouta_reg_use_clock($i) ||
							 $is_coef_register_use_clock($i) ||
							 $is_datac_input_register_use_clock($i) ||
							 $is_accum_sload_register_use_clock($i) ||
							 $is_systolic_delay_use_clock($i) ||
							 $is_input_latency_use_clock($i) ||
							 $is_negate_use_clock($i)}]
		#sclr usage expr
		set is_use_sclr$i [expr {$is_signa_reg_use_sclr($i) || $is_signb_reg_use_sclr($i) || 
							$is_output_reg_use_sclr($i) || 
							$is_addnsub_multiplier_register1_use_sclr($i) || $is_addnsub_multiplier_register3_use_sclr($i) || 
							$is_input_reg_a_use_sclr($i) || $is_input_reg_b_use_sclr($i) || 
							$is_multiplier_reg_use_sclr($i) ||
							$is_scanouta_reg_use_sclr($i) ||
							$is_coef_register_use_sclr($i) ||
							$is_datac_input_register_use_sclr($i) ||
							$is_accum_sload_register_use_sclr($i) ||
							$is_systolic_delay_use_sclr($i) ||
							$is_input_latency_use_sclr($i) ||
							$is_negate_use_sclr($i)}]
	}



		
    if {$flag eq "elaboration"} {

		# +------------------------------------------------------------------------------------------------
		# | 
		# | Port mapping
		# | Note: modifying interfaces which have already been created is faster than constantly 
		# |		  creating interfaces during elaboration callback
		# +------------------------------------------------------------------------------------------------
		
		#result port
		my_add_interface_port "out" "result" $get_width_result "false" 0
		
		#For ip-generate mt test validation & verification flow only as mmdl doesn't recognize dataa_0, dataa_1 and etc
		if {$get_reg_autovec_sim eq "true"} {
			if {!$is_use_dataa_scan_chain} {
				my_add_interface_port "in" "dataa" [expr {$get_width_a * $get_number_of_multiplier}] "false" 0
			}
		} else {
		#dataa
			if {!$is_use_dataa_scan_chain} {	
				for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {
					set multiplier_number [expr {${i} + 1}]
					set MSB [expr {(${get_width_a} * ${multiplier_number}) - 1}]
					set LSB [expr {${get_width_a} * (${multiplier_number} - 1)}]

					my_add_interface_port "in" "dataa_${i}" $get_width_a "false" 0
				}
			}
		}
		
	
		
		#For ip-generate mt test validation & verification flow only as mmdl doesn't recognize datab_0, datab_1 and etc
		if {$get_reg_autovec_sim eq "true"} {		
			if {$get_preadder_mode ne "CONSTANT"} {
				my_add_interface_port "in" "datab" [expr {$get_width_b * $get_number_of_multiplier}] "false" 0
			}
		} else {
		#datab
			if {$get_preadder_mode ne "CONSTANT"} {
				for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {
					set multiplier_number [expr {${i} + 1}]
					set MSB [expr {(${get_width_b} * ${multiplier_number}) - 1}]
					set LSB [expr {${get_width_b} * (${multiplier_number} - 1)}]

					my_add_interface_port "in" "datab_${i}" $get_width_b "false" 0
				}
			}
		}
		
		#signa port
		if {$get_representation_a eq "VARIABLE"} {
			my_add_interface_port "in" "signa" 1 "false" 0
		}
		
		#signb por
		if {$get_representation_b eq "VARIABLE"} {
			my_add_interface_port "in" "signb" 1 "false" 0
		}
		
		#addnsub1 port
		if {$is_use_multiplier1_addnsub} {
			my_add_interface_port "in" "addnsub1" 1 "false" 0
		}
		
		#addnsub3 port
		if {$is_use_multiplier3_addnsub} {
			my_add_interface_port "in" "addnsub3" 1 "false" 0
		}
		
		#clock0
		if {$is_use_clock0} {
			my_add_interface_port "clk" "clock0" 1 "false" 0
		}
		#clock1
		if {$is_use_clock1} {
			my_add_interface_port "clk" "clock1" 1 "false" 0
		}
		
		#clock2
		if {$is_use_clock2} {
			my_add_interface_port "clk" "clock2" 1 "false" 0
		}

		#clock3
		if {$is_use_clock3} {
			my_add_interface_port "clk" "clock3" 1 "false" 0
		}
		#clock enable 'ena0'
		if {$is_use_clock0 && $is_use_associated_clock_enable eq "true"} {
			my_add_interface_port "in" "ena0" 1 "false" 0
		}
		#clock enable 'ena1'
		if {$is_use_clock1 && $is_use_associated_clock_enable eq "true"} {
			my_add_interface_port "in" "ena1" 1 "false" 0
		}
		#clock enable 'ena2'
		if {$is_use_clock2 && $is_use_associated_clock_enable eq "true"} {
			my_add_interface_port "in" "ena2" 1 "false" 0
		}
		#clock enable 'ena3'
		if {$is_use_clock3 && $is_use_associated_clock_enable eq "true"} {
			my_add_interface_port "in" "ena3" 1 "false" 0
		}
		
		#aclr0
		if {$is_use_aclr0} {
			my_add_interface_port "in" "aclr0" 1 "false" 0
		}
		#aclr1
		if {$is_use_aclr1} {
			my_add_interface_port "in" "aclr1" 1 "false" 0
		}

		#aclr2
		if {$is_use_aclr2} {
			my_add_interface_port "in" "aclr2" 1 "false" 0
		}
		
		#aclr3
		if {$is_use_aclr3} {
			my_add_interface_port "in" "aclr3" 1 "false" 0
		}
		
		#Added for-SCLR SUPPORT
				
		#sclr0
		if {$is_use_sclr0} {
			my_add_interface_port "in" "sclr0" 1 "false" 0
		}
		#sclr1
		if {$is_use_sclr1} {
			my_add_interface_port "in" "sclr1" 1 "false" 0
		}

		#sclr2
		if {$is_use_sclr2} {
			my_add_interface_port "in" "sclr2" 1 "false" 0
		}
		
		#sclr3
		if {$is_use_sclr3} {
			my_add_interface_port "in" "sclr3" 1 "false" 0
		}
		
		#scan chain input
		if {$is_use_dataa_scan_chain} {
			my_add_interface_port "in" "scanina" $get_width_a "false" 0
			my_add_interface_port "out" "scanouta" $get_width_a "false" 0
		}
		
		#preadder
		for { set i 0 } {$i < $NUMBER_OF_MULT} {incr i} {
		}
		if {$get_preadder_mode eq "COEF" || $get_preadder_mode eq "CONSTANT"} {
			for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {	
				my_add_interface_port "in" "coefsel$i" 3 "false" 0
			}
		}
		#For ip-generate mt test validation & verification flow only as mmdl doesn't recognize dataa_0, dataa_1 and etc
		if {$get_reg_autovec_sim eq "true"} {			
			if {$get_preadder_mode eq "INPUT"} {			
				my_add_interface_port "in" "datac" [expr {$get_width_c * $get_number_of_multiplier}] "false" 0
			}
		} else {
		#datac
			if {$get_preadder_mode eq "INPUT"} {			
				for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {
					set multiplier_number [expr {${i} + 1}]
					set MSB [expr {(${get_width_c} * ${multiplier_number}) - 1}]
					set LSB [expr {${get_width_c} * (${multiplier_number} - 1)}]

					my_add_interface_port "in" "datac_${i}" $get_width_c "false" 0
				}
			}
		}
		
		#accumulator/preload
		if {$is_use_accum_sload_register} {
			if {$get_accumulate_port_select == 0} {
				my_add_interface_port "in" "accum_sload" 1 "false" 0
			}
			if {$get_accumulate_port_select == 1} {
				my_add_interface_port "in" "sload_accum" 1 "false" 0
			}
		}
		#systolic delay
		if {$is_use_systolic || $get_chainout_adder eq "YES"} {
			my_add_interface_port "in" "chainin" $get_width_result "false" 0
		}
		
		#chainout adder
		if {$get_port_negate eq "PORT_USED"} {
			my_add_interface_port "in" "negate" 1 "false" 0
		}

		# +------------------------------------------------------------------------------------------------
		# | 
		# | Parameter mapping
		# | 
		# +------------------------------------------------------------------------------------------------

		#multiplier A & B representation
		if {$get_representation_a eq "VARIABLE"} {
			set_parameter_value representation_a "UNSIGNED"
			set_parameter_value port_signa "PORT_USED"
		} else {
			set_parameter_value representation_a $get_representation_a
			set_parameter_value port_signa "PORT_UNUSED"
		}

		if {$get_representation_b eq "VARIABLE"} {
			set_parameter_value representation_b "UNSIGNED"
			set_parameter_value port_signb "PORT_USED"
		} else {
			set_parameter_value representation_b $get_representation_b
			set_parameter_value port_signb "PORT_UNUSED"
		}
		
		#Signed register settings
		if {$is_use_register_signa} {
			set_parameter_value signed_register_a $get_register_signa_clock
		} else {
			set_parameter_value signed_register_a "UNREGISTERED"
		}
		if {$is_use_register_signa && $get_register_signa_aclr ne "NONE"} {
			set_parameter_value signed_aclr_a  $get_register_signa_aclr
		} else {
			set_parameter_value signed_aclr_a  "NONE"
		}
		#Added for SCLR SUPPORT
		if {$is_use_register_signa && $get_register_signa_sclr ne "NONE"} {
			set_parameter_value signed_sclr_a  $get_register_signa_sclr
		} else {
			set_parameter_value signed_sclr_a  "NONE"
		}
		
		if {$is_use_register_signb} {
			set_parameter_value signed_register_b $get_register_signb_clock
		} else {
			set_parameter_value signed_register_b "UNREGISTERED"
		}
		if {$is_use_register_signb && $get_register_signb_aclr ne "NONE"} {
			set_parameter_value signed_aclr_b  $get_register_signb_aclr
		} else {
			set_parameter_value signed_aclr_b  "NONE"
		}
		
		#Added for SCLR SUPPORT
		if {$is_use_register_signb && $get_register_signb_sclr ne "NONE"} {
			set_parameter_value signed_sclr_b  $get_register_signb_sclr
		} else {
			set_parameter_value signed_sclr_b  "NONE"
		}
		
		#output register
		if {$get_output_register eq "true"} {
			set_parameter_value output_register $get_output_register_clock
		} else {
			set_parameter_value output_register "UNREGISTERED"
			set_parameter_value output_aclr "NONE"
			set_parameter_value output_sclr "NONE"
		}
		if {$get_output_register eq "true" && $get_output_register_aclr ne "NONE"} {
			set_parameter_value output_aclr $get_output_register_aclr
		} else {
			set_parameter_value output_aclr "NONE"
		}
		
		#Added for sclr support
		if {$get_output_register eq "true" && $get_output_register_sclr ne "NONE"} {
			set_parameter_value output_sclr $get_output_register_sclr
		} else {
			set_parameter_value output_sclr "NONE"
		}
		
		#addnsub multipliers conf
		if {$is_use_multiplier1_addnsub} {
			set_parameter_value multiplier1_direction "ADD"
			set_parameter_value port_addnsub1 "PORT_USED"
		} else {
			set_parameter_value multiplier1_direction $get_multiplier1_direction
			set_parameter_value port_addnsub1 "PORT_UNUSED"
		}
		if {$is_use_multiplier3_addnsub} {
			set_parameter_value multiplier3_direction "ADD"
			set_parameter_value port_addnsub3 "PORT_USED"
		} else {
			set_parameter_value multiplier3_direction $get_multiplier3_direction
			set_parameter_value port_addnsub3 "PORT_UNUSED"
		}
		if {$get_use_subnadd eq "true"} {
			set_parameter_value use_subnadd "YES"
		} else {
			set_parameter_value use_subnadd "NO"
		}
		
		if {$is_use_addnsub_multiplier_register1} {
			set_parameter_value addnsub_multiplier_register1 $get_addnsub_multiplier_register1_clock
		} else {
			set_parameter_value addnsub_multiplier_register1 "UNREGISTERED"
			set_parameter_value addnsub_multiplier_aclr1 "NONE"
			#Added sclr support
			set_parameter_value addnsub_multiplier_sclr1 "NONE"
		}
		if {$is_use_addnsub_multiplier_register3} {
			set_parameter_value addnsub_multiplier_register3 $get_addnsub_multiplier_register3_clock
		} else {
			set_parameter_value addnsub_multiplier_register3 "UNREGISTERED"
			set_parameter_value addnsub_multiplier_aclr3 "NONE"
			#Added by sukumar-SCLR SUPPORT
			set_parameter_value addnsub_multiplier_sclr3 "NONE"
		}
		if {$is_use_addnsub_multiplier_register1 && $get_addnsub_multiplier_aclr1 ne "NONE"} {
			set_parameter_value addnsub_multiplier_aclr1 $get_addnsub_multiplier_aclr1
		}
		#Added by sukumar-SCLR SUPPORT
		if {$is_use_addnsub_multiplier_register1 && $get_addnsub_multiplier_sclr1 ne "NONE"} {
			set_parameter_value addnsub_multiplier_sclr1 $get_addnsub_multiplier_sclr1
		}
		if {$is_use_addnsub_multiplier_register3 && $get_addnsub_multiplier_aclr3 ne "NONE"} {
			set_parameter_value addnsub_multiplier_aclr3 $get_addnsub_multiplier_aclr3
		}
		#Added by sukumar-SCLR SUPPORT
		if {$is_use_addnsub_multiplier_register3 && $get_addnsub_multiplier_sclr3 ne "NONE"} {
			set_parameter_value addnsub_multiplier_sclr3 $get_addnsub_multiplier_sclr3
		}
	
		#input register settings
		for { set i 0 } {$i < $NUMBER_OF_MULT} {incr i} {
		
			#reset parameter value to default value before parameter mapping
			set_parameter_value input_register_a$i "UNREGISTERED"
			set_parameter_value input_register_b$i "UNREGISTERED"			
			set_parameter_value input_aclr_a$i "NONE"
			set_parameter_value input_aclr_b$i "NONE"
			#sclr support
			set_parameter_value input_sclr_a$i "NONE"
			set_parameter_value input_sclr_b$i "NONE"	
		}
		
		for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {	
			if {$get_input_register_a eq "true"} {
				set_parameter_value input_register_a$i  $get_input_register_a_clock
			}
			if {$get_input_register_b eq "true"} {
				set_parameter_value input_register_b$i  $get_input_register_b_clock			
			}
			if {$get_input_register_a eq "true" && $get_input_register_a_aclr ne "NONE"} {
				set_parameter_value input_aclr_a$i  $get_input_register_a_aclr
			}
			if {$get_input_register_b eq "true" && $get_input_register_b_aclr ne "NONE"} {
				set_parameter_value input_aclr_b$i  $get_input_register_b_aclr
			}
			#sclr support
			if {$get_input_register_a eq "true" && $get_input_register_a_sclr ne "NONE"} {
				set_parameter_value input_sclr_a$i  $get_input_register_a_sclr
			}
			if {$get_input_register_b eq "true" && $get_input_register_b_sclr ne "NONE"} {
				set_parameter_value input_sclr_b$i  $get_input_register_b_sclr
			}
			
		}
		
		#multiplier register settings
		for { set i 0 } {$i < $NUMBER_OF_MULT} {incr i} {
		
			#reset parameter value to default value before parameter mapping
			set_parameter_value multiplier_register$i "UNREGISTERED"
			set_parameter_value multiplier_aclr$i "NONE"
			set_parameter_value multiplier_sclr$i "NONE"
		}
		
		for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {	
			if {$get_multiplier_reg eq "true"} {
				set_parameter_value multiplier_register$i  $get_multiplier_reg_clock
			}
			if {$get_multiplier_reg eq "true" && $get_multiplier_reg_aclr ne "NONE"} {
				set_parameter_value multiplier_aclr$i  $get_multiplier_reg_aclr
			}
			#Added by sukumar-SCLR SUPPORT
			if {$get_multiplier_reg eq "true" && $get_multiplier_reg_sclr ne "NONE"} {
				set_parameter_value multiplier_sclr$i  $get_multiplier_reg_sclr
			}
		}
		
		#multiplier input settings
		for { set i 0 } {$i < $NUMBER_OF_MULT} {incr i} {
			#reset parameter value to default value before parameter mapping
			set_parameter_value input_source_a$i "DATAA"
		}
		if {$is_use_dataa_scan_chain} {
			for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {	
				set_parameter_value input_source_a$i "SCANA"
			}
		}
		if {$get_number_of_multiplier > 1 && $get_scanouta_register eq "true" && $get_multiplier_a_input eq "Scan chain input"} {
			set_parameter_value scanouta_register $get_scanouta_register_clock
		} else {
			set_parameter_value scanouta_register "UNREGISTERED"
			set_parameter_value scanouta_aclr "NONE"
			set_parameter_value scanouta_sclr "NONE"
		}
		if {$get_number_of_multiplier > 1 && $get_scanouta_register eq "true" && $get_scanouta_register_aclr ne "NONE"} {
			set_parameter_value scanouta_aclr $get_scanouta_register_aclr
		}
		#Added for SCLR SUPPORT
		if {$get_number_of_multiplier > 1 && $get_scanouta_register eq "true" && $get_scanouta_register_sclr ne "NONE"} {
			set_parameter_value scanouta_sclr $get_scanouta_register_sclr
		}
		
		#Preadder, coef register & datac input register	
		for { set i 0 } {$i < $NUMBER_OF_MULT} {incr i} {
			set_parameter_value coefsel${i}_register "UNREGISTERED"
			set_parameter_value coefsel${i}_aclr "NONE"
			set_parameter_value coefsel${i}_sclr "NONE"
			set_parameter_value input_register_c$i "UNREGISTERED"
			set_parameter_value input_aclr_c$i "NONE"
			set_parameter_value input_sclr_c$i "NONE"
			set_parameter_value preadder_direction_$i "ADD"
		}
		for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {	
			if {$is_use_coef_register} {
				set_parameter_value coefsel${i}_register  $get_coef_register_clock
			}
			if {$is_use_coef_register && $get_coef_register_aclr ne "NONE"} {
				set_parameter_value coefsel${i}_aclr  $get_coef_register_aclr
			}
			#Added for SCLR SUPPORT
			if {$is_use_coef_register && $get_coef_register_sclr ne "NONE"} {
				set_parameter_value coefsel${i}_sclr  $get_coef_register_sclr
			}
			if {$is_use_datac_input_register} {
				set_parameter_value input_register_c$i $get_datac_input_register_clock
			}
			if {$is_use_datac_input_register && $get_datac_input_register_aclr ne "NONE"} {
				set_parameter_value input_aclr_c$i  $get_datac_input_register_aclr
			}
			#Added for SCLR SUPPORT
			if {$is_use_datac_input_register && $get_datac_input_register_sclr ne "NONE"} {
				set_parameter_value input_sclr_c$i  $get_datac_input_register_sclr
			}
			if {$get_preadder_mode ne "SIMPLE"} {
				set_parameter_value preadder_direction_$i $get_preadder_direction
			}
		}

		#Accumulator/Preload
		if {$is_use_accum_sload_register} {
			set_parameter_value accum_sload_register $get_accum_sload_register_clock
			set_parameter_value accum_sload_aclr $get_accum_sload_register_aclr
			#Added for sclr support
			set_parameter_value accum_sload_sclr $get_accum_sload_register_sclr
		} else {
			set_parameter_value accum_sload_register "UNREGISTERED"
			set_parameter_value accum_sload_aclr "NONE"
			#Added for sclr support
			set_parameter_value accum_sload_sclr "NONE"
		}
		if {$get_accumulator eq "YES" && $get_double_accum eq "true"} {
			set_parameter_value double_accum "YES"
		} else {
			set_parameter_value double_accum "NO"
		}
		if {$is_use_accum_sload_register && $get_accumulate_port_select == 1} {
			set_parameter_value use_sload_accum_port "YES"
		} else {
			set_parameter_value use_sload_accum_port "NO"
		}

		#Systolic/Chain Adder
		if {$is_use_systolic || $get_chainout_adder eq "YES"} {
			set_parameter_value width_chainin $get_width_result
		} else {
			set_parameter_value width_chainin 1
		}
		if {$is_use_systolic} {
			set_parameter_value systolic_delay1 $get_systolic_delay_clock
			set_parameter_value systolic_aclr1 $get_systolic_delay_aclr
			set_parameter_value systolic_delay3 $get_systolic_delay_clock 
			set_parameter_value systolic_aclr3 $get_systolic_delay_aclr
			#Added for SCLR SUPPORT
			set_parameter_value systolic_sclr1 $get_systolic_delay_sclr
			set_parameter_value systolic_sclr3 $get_systolic_delay_sclr
		} else {
			set_parameter_value systolic_delay1 "UNREGISTERED"
			set_parameter_value systolic_aclr1 "NONE"
			set_parameter_value systolic_delay3 "UNREGISTERED"
			set_parameter_value systolic_aclr3 "NONE"
			#Added for SCLR SUPPORT
			set_parameter_value systolic_sclr1 "NONE"
			set_parameter_value systolic_sclr3 "NONE"
		}
		
		#Pipelining
		for { set i 0 } {$i < $NUMBER_OF_MULT} {incr i} {
		
			#reset parameter value to default value before parameter mapping
			set_parameter_value input_a${i}_latency_clock "UNREGISTERED"
			set_parameter_value input_b${i}_latency_clock "UNREGISTERED"
			set_parameter_value input_c${i}_latency_clock "UNREGISTERED"
			set_parameter_value coefsel${i}_latency_clock "UNREGISTERED"
			set_parameter_value input_a${i}_latency_aclr "NONE"
			set_parameter_value input_b${i}_latency_aclr "NONE"
			set_parameter_value input_c${i}_latency_aclr "NONE"
			set_parameter_value coefsel${i}_latency_aclr "NONE"
			#sclr support
			set_parameter_value input_a${i}_latency_sclr "NONE"
			set_parameter_value input_b${i}_latency_sclr "NONE"
			set_parameter_value input_c${i}_latency_sclr "NONE"
			set_parameter_value coefsel${i}_latency_sclr "NONE"
			
		}
		for { set i 0 } {$i < $get_number_of_multiplier} {incr i} {	
			if {$get_pipelining == 1 } {
				
				set_parameter_value input_a${i}_latency_clock  $get_input_latency_clock
				set_parameter_value input_a${i}_latency_aclr $get_input_latency_aclr
				
				set_parameter_value input_b${i}_latency_clock  $get_input_latency_clock
				set_parameter_value input_b${i}_latency_aclr $get_input_latency_aclr
				#Added for SCLR SUPPORT
				set_parameter_value input_a${i}_latency_sclr $get_input_latency_sclr
				set_parameter_value input_b${i}_latency_sclr $get_input_latency_sclr
			}
			if {$get_pipelining == 1 && $get_preadder_mode eq "INPUT"} {
				
				set_parameter_value input_c${i}_latency_clock  $get_input_latency_clock
				set_parameter_value input_c${i}_latency_aclr $get_input_latency_aclr
				#Added for SCLR SUPPORT
				set_parameter_value input_c${i}_latency_sclr $get_input_latency_sclr
			}
			if {$get_pipelining == 1 && ($get_preadder_mode eq "CONSTANT" || $get_preadder_mode eq "COEF")} {
				
				set_parameter_value coefsel${i}_latency_clock  $get_input_latency_clock
				set_parameter_value coefsel${i}_latency_aclr $get_input_latency_aclr
				#Added by sukumar
				set_parameter_value coefsel${i}_latency_sclr $get_input_latency_sclr

			}
		}
		
		if {$get_pipelining == 1 && $get_representation_a eq "VARIABLE"} {
			set_parameter_value signed_latency_clock_a $get_input_latency_clock
			set_parameter_value signed_latency_aclr_a  $get_input_latency_aclr
			#Added for SCLR SUPPORT
			set_parameter_value signed_latency_sclr_a  $get_input_latency_sclr
		} else {
			set_parameter_value signed_latency_clock_a "UNREGISTERED"
			set_parameter_value signed_latency_aclr_a  "NONE"
			#Added for SCLR SUPPORT
			set_parameter_value signed_latency_sclr_a  "NONE"
		}
		if {$get_pipelining == 1 && $get_representation_b eq "VARIABLE"} {
			set_parameter_value signed_latency_clock_b $get_input_latency_clock
			set_parameter_value signed_latency_aclr_b  $get_input_latency_aclr
			#Added for SCLR SUPPORT
			set_parameter_value signed_latency_sclr_b  $get_input_latency_sclr
		} else {
			set_parameter_value signed_latency_clock_b "UNREGISTERED"
			set_parameter_value signed_latency_aclr_b  "NONE"
			#Added for SCLR SUPPORT
			set_parameter_value signed_latency_sclr_b  "NONE"
		}
			
		if {$get_pipelining == 1 && $is_use_multiplier1_addnsub} {
			set_parameter_value addnsub_multiplier_latency_clock1 $get_input_latency_clock
			set_parameter_value addnsub_multiplier_latency_aclr1 $get_input_latency_aclr
			#Added for SCLR SUPPORT
			set_parameter_value addnsub_multiplier_latency_sclr1 $get_input_latency_sclr
		} else {
			set_parameter_value addnsub_multiplier_latency_clock1 "UNREGISTERED"
			set_parameter_value addnsub_multiplier_latency_aclr1 "NONE"
			#Added for SCLR SUPPORT
			set_parameter_value addnsub_multiplier_latency_sclr1 "NONE"
		}
		if {$get_pipelining == 1 && $is_use_multiplier3_addnsub} {
			set_parameter_value addnsub_multiplier_latency_clock3 $get_input_latency_clock
			set_parameter_value addnsub_multiplier_latency_aclr3 $get_input_latency_aclr
			#Added for SCLR SUPPORT
			set_parameter_value addnsub_multiplier_latency_sclr3 $get_input_latency_sclr
		} else {
			set_parameter_value addnsub_multiplier_latency_clock3 "UNREGISTERED"
			set_parameter_value addnsub_multiplier_latency_aclr3 "NONE"
			#Added for SCLR SUPPORT
			set_parameter_value addnsub_multiplier_latency_sclr3 "NONE"
		}
		if {$get_pipelining == 1 && $is_use_accum_sload_register} {
			set_parameter_value accum_sload_latency_clock $get_input_latency_clock
			set_parameter_value accum_sload_latency_aclr $get_input_latency_aclr
			#Added for SCLR SUPPORT
			set_parameter_value accum_sload_latency_sclr $get_input_latency_sclr
		} else {
			set_parameter_value accum_sload_latency_clock "UNREGISTERED"
			set_parameter_value accum_sload_latency_aclr "NONE"
			#Added for SCLR SUPPORT
			set_parameter_value accum_sload_latency_sclr "NONE"
		}
		if {$get_pipelining == 1 && $get_port_negate eq "PORT_USED"} {
			set_parameter_value negate_latency_clock $get_input_latency_clock
			set_parameter_value negate_latency_aclr $get_input_latency_aclr
			#Added for SCLR SUPPORT
			set_parameter_value negate_latency_sclr $get_input_latency_sclr
		} else {
			set_parameter_value negate_latency_clock "UNREGISTERED"
			set_parameter_value negate_latency_aclr "NONE"
			#Added for SCLR SUPPORT
			set_parameter_value negate_latency_sclr "NONE"
		}
	}
}

# +-----------------------------------
# | 
# | The validation callback
# |
# +-----------------------------------
proc validation_callback {} {

	# User interface's rules and visibility
	validation_param_visibility
	# Legality and error check
	error_check

}

#+--------------------------------------------
#|
#|  Quartus Synthesis / Verilog Simulation
#|
#+--------------------------------------------
proc generate_synth {output_name} {

	send_message info "generating top-level entity $output_name"
	
    set file_name ${output_name}.v
    set terp_path altera_mult_add.v.terp
    set contents [gen_terp $terp_path $output_name]
    add_fileset_file $file_name VERILOG TEXT $contents

}

#+--------------------------------------------
#|
#|  VHDL Simulation
#|
#+--------------------------------------------
proc do_vhdl_sim {output_name} {

 	send_message info "generating top-level entity $output_name"
	
	set file_name ${output_name}.vhd
    set terp_path altera_mult_add.vhd.terp
    set contents [gen_terp $terp_path $output_name]
    add_fileset_file $file_name VHDL TEXT $contents
}

# +-----------------------------------
# |
# | Fileset Callbacks
# |
# +----------------------------------- 
set_module_property 	ELABORATION_CALLBACK	elaboration_callback
set_module_property 	VALIDATION_CALLBACK		validation_callback

#add the component hdl definition
add_fileset quartus_synth 	QUARTUS_SYNTH 	generate_synth
add_fileset verilog_sim     SIM_VERILOG     generate_synth
add_fileset vhdl_sim        SIM_VHDL        do_vhdl_sim

