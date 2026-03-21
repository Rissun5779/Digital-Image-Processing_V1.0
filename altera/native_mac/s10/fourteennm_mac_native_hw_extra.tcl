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

#+-------------------------------------------
#|
#|  Source Files
#|
#+-------------------------------------------
source "../common/mac_native_common.tcl"

#+--------------------------------------------
#|
#|  Elaboration Callback for Ports setup
#|	Block Symbol view
#|
#+--------------------------------------------
proc interface_ports_and_mapping {} {
    
	# Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }
    
	#input data ports
	if {$params(ay_use_scan_in)} {
		my_set_interface "in" "scanin" $params(ay_scan_in_width) "false" 0
		set_port_property scanin VHDL_TYPE STD_LOGIC_VECTOR	
	} else {
		my_set_interface "in" "ay" $params(ay_scan_in_width) "false" 0
		set_port_property ay VHDL_TYPE STD_LOGIC_VECTOR	
	}
	if {$params(operation_mode) ne "m18x18_plus36" && $params(operand_source_may) eq "preadder"} {
		my_set_interface "in" "az" $params(az_width) "false" 0
		set_port_property az VHDL_TYPE STD_LOGIC_VECTOR
	}
		
	#FOR BZ PORT
	if {( $params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_full_top" && $params(operation_mode) ne "m18x18_plus36") && ($params(operand_source_may) eq "preadder" || $params(operand_source_mby) eq "preadder")} {
		my_set_interface "in" "bz" $params(bz_width) "false" 0	
		set_port_property bz VHDL_TYPE STD_LOGIC_VECTOR
	} 

	if {$params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_full_top"} {
		if {!($params(by_use_scan_in))} {	
			my_set_interface "in" "by" $params(by_width) "false" 0
			set_port_property by VHDL_TYPE STD_LOGIC_VECTOR	
		}
	}
	
	#For coefsela
	if { $params(operation_mode) ne "m18x18_plus36" && ($params(operand_source_max) eq "coef")} {
		my_set_interface "in" "coefsela" 3 "false" 0
	} else {
		if {($params(operand_source_max) ne "coef") } {
			my_set_interface "in" "ax" $params(ax_width) "false" 0
			set_port_property ax VHDL_TYPE STD_LOGIC_VECTOR
		}
	}
	#For coefselb
	if {($params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_plus36" && $params(operation_mode) ne "m18x18_full_top") && ($params(operand_source_mbx) eq "coef" )} {
		my_set_interface "in" "coefselb" 3 "false" 0
	} else {
		if {$params(operation_mode) ne "m27x27" && $params(operation_mode) ne "m18x18_full_top"} {
			my_set_interface "in" "bx" $params(bx_width) "false" 0
			set_port_property bx VHDL_TYPE STD_LOGIC_VECTOR
		}
	}
	

	#changed from use_chainadder to enable_chainin
	if {$params(enable_chainin) eq "true" && ($params(operation_mode) ne "m18x18_full" && $params(operation_mode) ne "m18x18_full_top") } {
		if { $params(operation_mode) ne "m18x18_systolic" } {
			my_set_interface "in" "chainin" 64 "false" 0
		} else {
			my_set_interface "in" "chainin" 44 "false" 0
		}
	}

	if {( $params(operation_mode) ne "m18x18_full" && $params(operation_mode) ne "m18x18_full_top" && $params(operation_mode) ne "m27x27") && $params(enable_sub) eq "true"} {
		my_set_interface "in" "sub" 1 "false" 0	
	}

	if { ( $params(operation_mode) ne "m18x18_full" && $params(operation_mode) ne "m18x18_full_top")  && $params(enable_negate) eq "true" } {
		my_set_interface "in" "negate" 1 "false" 0
		set_port_property negate VHDL_TYPE STD_LOGIC_VECTOR
	}
	
	if {( $params(operation_mode) ne "m18x18_full" && $params(operation_mode) ne "m18x18_full_top")  && $params(enable_loadconst) eq "true"} {
		my_set_interface "in" "loadconst" 1 "false" 0
	}
	
	if {( $params(operation_mode) ne "m18x18_full" && $params(operation_mode) ne "m18x18_full_top")  && $params(enable_accumulate) eq "true"} {
		my_set_interface "in" "accumulate" 1 "false" 0
	}
	# output ports
	my_set_interface "out" "resulta" $params(result_a_width) "false" 0
	set_port_property resulta VHDL_TYPE STD_LOGIC_VECTOR

	if {$params(operation_mode) eq "m18x18_full"&&  $params(result_b_width) ne 0 } {
		my_set_interface "out" "resultb" $params(result_b_width) "false" 0
		set_port_property resultb VHDL_TYPE STD_LOGIC_VECTOR
	}
	if {$params(enable_scanout) eq "true" && $params(operation_mode) ne "m18x18_plus36"} {
		my_set_interface "out" "scanout" $params(scan_out_width) "false" 0
		set_port_property scanout VHDL_TYPE STD_LOGIC_VECTOR
	}
	if {$params(chainout_enable) eq "true"} {
		if { $params(operation_mode) ne "m18x18_systolic" } {
			my_set_interface "out" "chainout" 64 "false" 0	
		} else {
			my_set_interface "out" "chainout" 44 "false" 0
		}
	}
	
	# Clear Ports
	#Enable clock port in  block symbol when clock signal is used
	if {$params(clock0_show) eq "true" || $params(clock1_show) eq "true" || $params(clock2_show) eq "true"} {
		my_set_interface "in" "clk" 3 "false" 0
		my_set_interface "in" "ena" 3 "false" 0
	}

	#For CLR0 and CLR1 Settings
	if {$params(enable_clr0) eq "true"} {
		my_set_interface "in" "clr0" 1 "false" 0
	} 
	if {$params(enable_clr1) eq "true"}  {
		my_set_interface "in" "clr1" 1 "false" 0
	}
	
}



#+--------------------------------------------------------------------
#|
#|  Name:       gen_terp/render_terp
#|
#|  Purpose:    This procedure is called by do_quartus_synth and
#|              do_vhdl_sim. This procedure builds an array that terp
#|              can use to generate the IP variation file and then calls
#|              terp. Both VHDL and Verilog generation use the array.
#|
#|  Parameters: terp_path   -- path to the .terp file
#|              output_name -- name of the output file
#|
#|  Returns:    The contents returned from terp
#|
#+--------------------------------------------------------------------
# The gen_terp portion is replaced by render_terp
proc render_terp {output_name terp_file} {
    
	# Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }
	
	# Create the lists that hold all data for terp
	set all_ports 				[list]		;# store all interface ports
    set module_port_list        [list]      ;# port, direction, width, widthL
    set sub_wire_list           [list]      ;# name, width, widthL
    set wire_list               [list]      ;# dest, src, width, widthL
    set port_map_list           [list]      ;# port, connect, direction, width, widthL
    set ports_not_added_list    [list]      ;# port, connect
    set params_list             [list]      ;# name, str, value
    set inports                 [list]      ;# port, direction, width, widthL
    set outports                [list]      ;# port, direction, width, widthL
	set check_list_param_to_be_excluded [list]     ;# check_list_* param declaration
	set preadder_subtract_param_list	[list]		;#preadder subtract handling
	set delay_scan_out_param_list       [list]    ;#delay_scan_out_ay/by param handling 
	
	#For operand_source_may/mby
	set operand_source_param_list	[list]		;#operand_source_may/mby handling
	
	#For ay/by_use_scan_in
	set scan_in_param_list              [list]  ;#ay/by_use_scan_in param handling
	
	#For signed/unsigned to true/false
	set signed_unsigned_to_true_false_list  [list]  ;#perform parameter value change for operation_mode m18x18_full_top
	#For operation_mode 
	set operation_mode_param_list  [list]  ;#perform parameter value change for signed to true and unsigned to false
	
	#For use_chainadder
	set enable_chainin_to_use_chainadder  [list]  ;#perform parameter value change to use_chainadder
	
	#For enable_double_accum
	set enable_parameter_enable_double_accum  [list]  ;#perform parameter value change for enable_double_acccum
	
	# Split all ports into a list of inports and outports
	# Note: widthL = -3 refer to clr1 and clr0; widthL = -1 refer to clr1; widthL = -2 refers to clr0
    foreach port [get_interface_ports] {
        set width   -1
        set widthL  -1
		
		# Ports with width > 1
		if { $port eq "ay" || $port eq "scanin" } {
			set width  $params(ay_scan_in_width)
			set widthL  0
		}
		if { $port eq "ax" } {
			set width   $params(ax_width)
			set widthL  0
		}
		if { $port eq "az" } {
            set width   $params(az_width)
			set widthL  0
		}
		if { $port eq "bx" } {
			set width   $params(bx_width)
			set widthL  0
		}
		if { $port eq "by" } {
			set width   $params(by_width)
			set widthL  0
		}
		if { $port eq "bz" } {        
			set width   $params(bz_width)
			set widthL  0
		}
		if { $port eq "coefsela" || $port eq "coefselb" || $port eq "ena"} {        
			set width   3
			set widthL  0
		}	

		#Set the clr as input[1:0] clr when CLR[0] and CLR[1] are both enabled
		if { $params(enable_clr0) eq "true" && $params(enable_clr1) eq "true"} {
			if { $port eq "clr0" || $port eq "clr1"} {
				set width  -1
				set widthL -3
			}
			
		#For When only using CLR0
		} elseif { $params(enable_clr0) eq "true" && $params(enable_clr1) eq "false"} {
			if { $port eq "clr0"} {
				set width  -1
				set widthL -1
			}
		#For when only using CLR1
		} elseif { $params(enable_clr1) eq "true" && $params(enable_clr0) eq "false"} {
			if { $port eq "clr1"} {
				set width  -1
				set widthL -2
			}
		#For when set CLR0 as false
		} elseif { $params(enable_clr0) eq "false" && $params(enable_clr1) eq "false" } {
			if { $port eq "clk"} {
				set width   3
				set widthL  0
			}
		}
		if { $port eq "chainin" || $port eq "chainout"} {  
			if { $params(operation_mode) ne "m18x18_systolic" } {
				set width   64
			} else {
				set width   44
			}
			set widthL  0
		}
		if { $port eq "resulta" } {        
			set width   $params(result_a_width)
			set widthL  0
		}
		if { $port eq "resultb" } {        
			set width   $params(result_b_width)
			set widthL  0
			}
		if { $port eq "scanout" } {        
			set width   $params(scan_out_width)
			set widthL  0
		}

        
		# Add to the correct list	 
		if { [get_port_property $port DIRECTION] eq "Input" } {
			lappend inports $port "IN" $width $widthL 
		} elseif { [get_port_property $port DIRECTION] eq "Output" } {
			lappend outports $port "OUT" $width $widthL 
		}	
	}
	
	# Sort the inports and outports and make the module port list
    set inports             [sort_list_skip $inports  4]
    set outports            [sort_list_skip $outports 4]
    set module_port_list    [concat $inports $outports]

    # For each outport, there should be a sub wire of the same width
    set i 0
    foreach {port direction width widthL} $outports {

        lappend sub_wire_list "sub_wire$i" $width $widthL
        incr i
    }

    # Now connect the subwires to the outports in the same order
    set i 0
    foreach {port direction width widthL} $outports {

        lappend wire_list $port "sub_wire$i" $width $widthL
        incr i
    }

	#For CLR0 and CLR1 output generation
	foreach {port direction width widthL} $inports {
		#for CLR0 or CLR1 to print as .clr({clr,1b0})
		if {($port eq "clr0") && $widthL == -3 } {
			lappend port_map_list "clr" "{clr0,clr1}" $direction $width $widthL
			set index [lsearch $all_ports $port]
			set all_ports [lreplace $all_ports $index [expr {$index + 1}]]	
		} elseif {$port eq "clr1" && $widthL == -3 } {
			send_message INFO "Uses both Clear signal"
		} elseif {$port eq "clr1" && $widthL == -2 } {
			lappend port_map_list "clr" "{clr1,1'b0}" $direction $width $widthL
			set index [lsearch $all_ports $port]
			set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
		#When clr0 is false the clr port to be "ground"
		} elseif {$port eq "clr0" && $widthL == -1} {
			lappend port_map_list "clr" "{1'b0,clr0}" $direction $width $widthL
			set index [lsearch $all_ports $port]
			set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
		} elseif {$port eq "clk" && $widthL == 0 && $port ne "clr"} {
		
			lappend port_map_list "clr" "2'b00" $direction $width $widthL 
			lappend port_map_list "clk" "clk" $direction $width $widthL 
			set index [lsearch $all_ports $port]
			set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
		} elseif {$port eq "clr" && $widthL == 0} {
		
			lappend port_map_list "clr" "clr" $direction $width $widthL
			set index [lsearch $all_ports $port]
			set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
		} else {
			
			lappend port_map_list $port $port $direction $width $widthL 
			set index [lsearch $all_ports $port]
			set all_ports [lreplace $all_ports $index [expr {$index + 1}]]	
		}
    }
	
    # Add all of the outports to the port map list and remove them from all ports
    set i 0
    foreach {port direction width widthL} $outports {

        lappend port_map_list $port "sub_wire$i" $direction $width $widthL

        set index [lsearch $all_ports $port]
        set all_ports [lreplace $all_ports $index [expr {$index + 1}]]
        incr i

    }
	
	#Inlcude this inside render_terp proc
	
    # The all ports list is now all ports not used... make it the ports not added list
    set ports_not_added_list [sort_list_skip $all_ports 2]
	
	# Add CHECK_LIST  param that needs to be excluded from printing into the generated output file
	lappend check_list_param_to_be_excluded "all_register_list"
	lappend check_list_param_to_be_excluded "current_mode_support_register"
	lappend check_list_param_to_be_excluded "all_parameter"
	lappend check_list_param_to_be_excluded "current_mode_support_oprstr"
	lappend check_list_param_to_be_excluded "current_mode_support_oprstr_B"
	lappend check_list_param_to_be_excluded "all_operation"
	lappend check_list_param_to_be_excluded "all_operation_b"
	lappend check_list_param_to_be_excluded "current_mode_feature_preadder_may_support_register"
	lappend check_list_param_to_be_excluded "feature_preadder_may_all_register_list "
	lappend check_list_param_to_be_excluded "current_mode_feature_preadder_mby_support_register "
	lappend check_list_param_to_be_excluded "feature_preadder_mby_all_register_list"
	lappend check_list_param_to_be_excluded "feature_accumulate_all_register_list "
	lappend check_list_param_to_be_excluded "current_mode_feature_accumulate_support_register "
	lappend check_list_param_to_be_excluded "feature_loadconst_all_register_list "
	lappend check_list_param_to_be_excluded "current_mode_feature_loadconst_support_register "
	lappend check_list_param_to_be_excluded "feature_negate_all_register_list "
	lappend check_list_param_to_be_excluded "current_mode_feature_negate_support_register"
	lappend check_list_param_to_be_excluded "feature_sub_all_register_list"
	lappend check_list_param_to_be_excluded "current_mode_feature_sub_support_register"
	lappend check_list_param_to_be_excluded "feature_coef_all_register_list "
	lappend check_list_param_to_be_excluded "current_mode_feature_coef_support_register "
	lappend check_list_param_to_be_excluded "feature_coef_mbx_all_register_list "
	lappend check_list_param_to_be_excluded "current_mode_feature_coef_mbx_support_register "

	# Add all of the parameters and their value
    foreach param [get_parameters] {
		set exclude_gui_param "false"
		foreach this_gui_param $check_list_param_to_be_excluded {
			if { $this_gui_param eq $param } {
				set exclude_gui_param "true"
			}
		}

		set gui_only_param [regexp "checklist_*" $param match]
        set all_width [regexp ".*_width" $param match]
		set gui_clock_param_exclude [regexp ".*clock*" $param match]
		set preadder_subtract_param [regexp "preadder_subtract_*" $param match]
		set exclude_param_enable_value [regexp "enable_*" $param match]
		set signed_n_unsigned_value_param [regexp "signed_*" $param match]
		set exclude_param_enable_chainin [regexp "enable_chainin" $param match]
		set exclude_param_enable_double_accum [regexp "enable_double_accum" $param match]
		
		#For operation mode
		set operation_mode_value_param [regexp "operation_mode" $param match]
		
		#For delay_scan_out param
		set delay_scan_out_param [regexp "delay_scan_out*" $param match]
		
		#For ay/by_use_scan_in param
		set scan_in_param [regexp ".*use_scan_in*" $param match]
		
		#For operand_source_may/mby
		set operand_source_param [regexp "operand_source*" $param match]
		
		set type [get_parameter_property $param TYPE]
		set value [get_parameter_value $param]
		#For operation_mode value
		set get_operation_mode_ip [get_parameter_value "operation_mode"]
		
		#For operand_source to control preadder_subtract
		set get_operand_source_preadder_may_for_sub [get_parameter_value "operand_source_may"]
		set get_operand_source_preadder_mby_for_sub [get_parameter_value "operand_source_mby"]

		#Provide all parameter available parameter list based on default value in hwtcl
		if { !$exclude_gui_param && !$gui_only_param && !$gui_clock_param_exclude && !$preadder_subtract_param && !$signed_n_unsigned_value_param && !$exclude_param_enable_double_accum && !$exclude_param_enable_chainin && !$operation_mode_value_param && !$delay_scan_out_param &&!$scan_in_param &&!$operand_source_param && !$exclude_param_enable_value && !($value eq 0 && $all_width) } {
            lappend params_list $param $type $value			
        } 
		
		#Perform parameter value change for preadder subtract as per atom matching value
		if { ($preadder_subtract_param && ($value eq "+")) } {
			lappend preadder_subtract_param_list $param $type "false"
		} elseif { $preadder_subtract_param && (($param eq "preadder_subtract_a") && ($value eq "-") && ($get_operation_mode_ip ne "m18x18_plus36") && ($get_operand_source_preadder_may_for_sub eq "preadder"))} {
			lappend preadder_subtract_param_list $param $type "true"
		} elseif { $preadder_subtract_param && (($param eq "preadder_subtract_b") && ($value eq "-") && (($get_operation_mode_ip ne "m18x18_plus36") && ($get_operation_mode_ip ne "m18x18_full_top") && ($get_operation_mode_ip ne "m27x27")) && ($get_operand_source_preadder_may_for_sub eq "preadder")) } { 
			lappend preadder_subtract_param_list $param $type "true"
		} elseif { $preadder_subtract_param && (($param eq "preadder_subtract_b") && ($value eq "-") && (($get_operation_mode_ip eq "m18x18_plus36")|| ($get_operation_mode_ip eq "m18x18_full_top") || ($get_operation_mode_ip eq "m27x27")))} {
			lappend preadder_subtract_param_list $param $type "false" 
		} elseif { $preadder_subtract_param && (($param eq "preadder_subtract_a") && ($value eq "-") && ($get_operation_mode_ip eq "m18x18_plus36")) } {
			lappend preadder_subtract_param_list $param $type "false" 
		}  elseif { $preadder_subtract_param && (($param eq "preadder_subtract_a") && ($value eq "-") && ($get_operation_mode_ip ne "m18x18_plus36") && ($get_operand_source_preadder_may_for_sub eq "input"))} {
			lappend preadder_subtract_param_list $param $type "false"
		} elseif { $preadder_subtract_param && (($param eq "preadder_subtract_b") && ($value eq "-") && (($get_operation_mode_ip ne "m18x18_plus36") && ($get_operation_mode_ip ne "m18x18_full_top") && ($get_operation_mode_ip ne "m27x27")) && ($get_operand_source_preadder_mby_for_sub eq "input")) } { 
			lappend preadder_subtract_param_list $param $type "false"
		}
		 
	
		#Perform parameter value change for signed/unisgned value as per atom matching value
		if { $signed_n_unsigned_value_param && ($value eq "Unsigned") } {
			lappend signed_unsigned_to_true_false_list $param $type "false"
		} elseif { $signed_n_unsigned_value_param && ($value eq "Signed") } {
			lappend signed_unsigned_to_true_false_list $param $type "true"
		}
		#Perform parameter value change for operation_mode m18x18_full_top
		if { $operation_mode_value_param && ($value eq "m18x18_full_top") } {
			lappend operation_mode_param_list $param $type "m18x18_full"
		} elseif  { $operation_mode_value_param && ($value ne "m18x18_full_top") } {
			lappend operation_mode_param_list $param $type $value
		}

		#For use_chainadder/chainin check based on mode m18x18_full and m18x18_full_top
		if { $exclude_param_enable_chainin && (($get_operation_mode_ip ne "m18x18_full") && ($get_operation_mode_ip ne "m18x18_full_top"))} {
			lappend enable_chainin_to_use_chainadder "use_chainadder" $type $value
		} elseif { $exclude_param_enable_chainin && ($value eq "true") && (($get_operation_mode_ip eq "m18x18_full") || ($get_operation_mode_ip eq "m18x18_full_top"))} {
		    lappend enable_chainin_to_use_chainadder "use_chainadder" $type "false"
		}
		
		#For enable_double_accum check based on mode m18x18_full and m18x18_full_top
		if { $exclude_param_enable_double_accum && (($get_operation_mode_ip ne "m18x18_full") && ($get_operation_mode_ip ne "m18x18_full_top"))} {
			lappend enable_parameter_enable_double_accum "enable_double_accum" $type $value
		} elseif { $exclude_param_enable_double_accum && ($value eq "true") && (($get_operation_mode_ip eq "m18x18_full") || ($get_operation_mode_ip eq "m18x18_full_top"))} {
		    lappend enable_parameter_enable_double_accum "enable_double_accum" $type "false"
		}
		
		#For param delay_scan_out_ay/by
		if { $delay_scan_out_param && ($value eq "false") } {
			lappend delay_scan_out_param_list $param $type $value
		} elseif { $delay_scan_out_param && (($param eq "delay_scan_out_ay") && ($value eq "true") && (($get_operation_mode_ip ne "m18x18_plus36") && ($get_operation_mode_ip ne "m27x27"))) ||(($param eq "delay_scan_out_by") && ($value eq "true") && (($get_operation_mode_ip ne "m18x18_plus36") && ($get_operation_mode_ip ne "m27x27") && ($get_operation_mode_ip ne "m18x18_full_top") )) } {
			lappend delay_scan_out_param_list $param $type $value
		} elseif { $delay_scan_out_param && ($value eq "true") && (($get_operation_mode_ip eq "m18x18_plus36") || ($get_operation_mode_ip eq "m27x27"))} {
			lappend delay_scan_out_param_list $param $type "false" 
		} elseif {$delay_scan_out_param && ($param eq "delay_scan_out_by") && ($value eq "true") && ($get_operation_mode_ip eq "m18x18_full_top") } {
			lappend delay_scan_out_param_list $param $type "false" 
		}
		
		
		#For ay/by_use_scan_in_param_list
		if { $scan_in_param && ($value eq "false") } {
			lappend scan_in_param_list $param $type $value
		} elseif { $scan_in_param && ($param eq "ay_use_scan_in") && ($value eq "true")&& ($get_operation_mode_ip ne "m18x18_plus36")} {
			lappend scan_in_param_list $param $type $value
		} elseif { $scan_in_param && ($param eq "by_use_scan_in") && ($value eq "true")&& (($get_operation_mode_ip ne "m18x18_plus36") && ($get_operation_mode_ip ne "m27x27")&& ($get_operation_mode_ip ne "m18x18_full_top"))} {
			lappend scan_in_param_list $param $type $value 
		} elseif { $scan_in_param && (($param eq "by_use_scan_in") && ($value eq "true") && ($get_operation_mode_ip eq "m18x18_plus36")) || (($param eq "ay_use_scan_in") && ($value eq "true") && ($get_operation_mode_ip eq "m18x18_plus36"))} {
			lappend scan_in_param_list $param $type "false" 
		} elseif { $scan_in_param && (($param eq "by_use_scan_in") && ($value eq "true") && ($get_operation_mode_ip eq "m27x27") || ($get_operation_mode_ip eq "m18x18_full_top")) } {
			lappend scan_in_param_list $param $type "false" 
		}
		
		#For operand_source_may/mby param
		if { $operand_source_param && (($param eq "operand_source_may") || ($param eq "operand_source_mby") ||($param eq "operand_source_max") ||($param eq "operand_source_mbx"))&& ($value eq "input") } {
			lappend operand_source_param_list $param $type $value
		} elseif { $operand_source_param && (($param eq "operand_source_may") && ($value eq "preadder")) && ($get_operation_mode_ip ne "m18x18_plus36")} {
			lappend operand_source_param_list $param $type $value
		} elseif { $operand_source_param && (($param eq "operand_source_max") && ($value eq "coef")) && ($get_operation_mode_ip ne "m18x18_plus36")} {
			lappend operand_source_param_list $param $type $value
		} elseif { $operand_source_param && (($param eq "operand_source_mby") && ($value eq "preadder")) && (($get_operation_mode_ip ne "m18x18_plus36") && ($get_operation_mode_ip ne "m27x27") && ($get_operation_mode_ip ne "m18x18_full_top"))} {
			lappend operand_source_param_list $param $type $value
		} elseif { $operand_source_param && (($param eq "operand_source_mbx") && ($value eq "coef")) && (($get_operation_mode_ip ne "m18x18_plus36") && ($get_operation_mode_ip ne "m27x27") && ($get_operation_mode_ip ne "m18x18_full_top") )} {
			lappend operand_source_param_list $param $type $value
		} elseif { $operand_source_param && (($param eq "operand_source_mby") && ($value eq "preadder")) && (($get_operation_mode_ip eq "m18x18_plus36") || ($get_operation_mode_ip eq "m27x27"))} {
			lappend operand_source_param_list $param $type "input"
		} elseif { $operand_source_param && (($param eq "operand_source_mbx") && ($value eq "coef")) && (($get_operation_mode_ip eq "m18x18_plus36") || ($get_operation_mode_ip eq "m27x27"))} {
			lappend operand_source_param_list $param $type "input"
		} elseif { $operand_source_param && (($param eq "operand_source_may") && ($value eq "preadder") && ($get_operation_mode_ip eq "m18x18_plus36")) || (($param eq "operand_source_mby") && ($value eq "preadder") && ($get_operation_mode_ip eq "m18x18_plus36"))} {
			lappend operand_source_param_list $param $type "input" 
		} elseif { $operand_source_param && (($param eq "operand_source_max") && ($value eq "coef") && ($get_operation_mode_ip eq "m18x18_plus36")) || (($param eq "operand_source_mbx") && ($value eq "coef") && ($get_operation_mode_ip eq "m18x18_plus36"))} {
			lappend operand_source_param_list $param $type "input" 
		} elseif { $operand_source_param && (($param eq "operand_source_mbx") && ($value eq "coef") && ($get_operation_mode_ip eq "m27x27")) || (($param eq "operand_source_mby") && ($value eq "preadder") && ($get_operation_mode_ip eq "m27x27"))} {
			lappend operand_source_param_list $param $type "input" 
		} elseif { $operand_source_param && (($param eq "operand_source_mbx") && ($value eq "coef") && ($get_operation_mode_ip eq "m18x18_full_top")) || (($param eq "operand_source_mby") && ($value eq "preadder") && ($get_operation_mode_ip eq "m18x18_full_top"))} {
			lappend operand_source_param_list $param $type "input" 
		}
    }
	
	# Create the terp array---change params (in render_terp) to params_terp to match # to add the extra parameter under the render terp
    array set params_terp {}
    set params_terp(module_port_list)       $module_port_list
    set params_terp(sub_wire_list)          $sub_wire_list
    set params_terp(wire_list)              $wire_list
    set params_terp(port_map_list)          $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(params_list)            $params_list
    set params_terp(ip_name)                "fourteennm_mac"
	set params_terp(preadder_subtract_param_list) $preadder_subtract_param_list
	set params_terp(enable_chainin_to_use_chainadder) $enable_chainin_to_use_chainadder
	set params_terp(enable_parameter_enable_double_accum) $enable_parameter_enable_double_accum
	
	#For delay_scan_out_ay/by
	set params_terp(delay_scan_out_param_list) $delay_scan_out_param_list
	
	#For ay/by_use_scan_in
	set params_terp(scan_in_param_list) $scan_in_param_list
	
	#For operand_source*
	set params_terp(operand_source_param_list) $operand_source_param_list
	
	#For signed/unisgned
	set params_terp(signed_unsigned_to_true_false_list) $signed_unsigned_to_true_false_list
	
	#For operation mode
	set params_terp(operation_mode_param_list) $operation_mode_param_list
	## get template

    set template_path $terp_file  ;# path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it


    ## add port details to template parameters
    ## note that element must be appended to lists evenly and in-order or else iteration will not work
    ## calculate output_width    

    foreach parameter_name [lsort [get_parameters]] {
        set params_terp($parameter_name) [get_parameter_value $parameter_name]
    }
    set params_terp(interfaces) [get_interfaces] 
    set params_terp(hdl_clocks) [get_hdl_clocks] 
	set params_terp(used_clocks) [get_used_clocks] 
    set params_terp(output_name) $output_name ;# template params are element of a Tcl array

    ## process template with parameters
    set contents [altera_terp $template params_terp] ;# pass parameter array in by reference
    return $contents    
}
