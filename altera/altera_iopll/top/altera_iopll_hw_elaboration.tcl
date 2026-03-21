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


# +=========================================================================================================
# | ELABORATION STAGE
# |
# | The elaboration stage sets up the ports and interfaces of the module. 

proc elaboration_callback {} {
	# Description: 
	#   Enables the dynamic (ie conditional) interfaces of the module
	# Inputs: none
	
	# Interfaces/ports are "unadded" every time elaboration is called
	#   this allows us to add them conditionally depending on parameters 
	#   set in the validation callback
	enable_interfaces_and_ports
}

proc enable_interface_and_ports { interface should_enable {instances ""} } {
	# Description: 
	#   Enables a particular interface and corresponding ports
	# Inputs: 
    #  - interface :  name of interface
    #  - should_enable : bool - whether or not to enable
    #  - instances: eg. 0-4 for outclk0 - outclk4
	if { $should_enable } {
		altera_pll_interfaces::add_dynamic_interface $interface $instances 
		altera_pll_interfaces::add_dynamic_ports $interface $instances 
	}	
}

proc enable_interfaces_and_ports {} {
	# Description: 
	#   Enables the dynamic (ie conditional) interfaces of the module
    #   Calls enable_interface_and_ports for each interface.
	# Inputs: none

	set usr_operation_mode			[get_parameter_value		gui_operation_mode]
	set usr_enabled_locked_port		[get_parameter_value		gui_use_locked]
	set usr_enabled_reconfig		[get_parameter_value		gui_en_reconf]
	set usr_enabled_dps_ports		[get_parameter_value		gui_en_dps_ports]
	set usr_enabled_phout_ports		[get_parameter_value		gui_en_phout_ports]
	set usr_enabled_extclkout_ports	[get_parameter_value		gui_en_extclkout_ports]
	set usr_enabled_lvds_ports		[get_parameter_value		gui_en_lvds_ports]
	set usr_enabled_refclk_switch	[get_parameter_value		gui_refclk_switch]
	set usr_refclk_switchover_mode	[get_parameter_value		gui_switchover_mode]
	set usr_enabled_active_clk		[get_parameter_value		gui_active_clk]
	set usr_enabled_clkbad			[get_parameter_value		gui_clk_bad]
	set usr_num_clocks				[get_parameter_value		gui_number_of_clocks]
	set usr_enabled_cascade_out		[get_parameter_value		gui_enable_cascade_out]
	set usr_enabled_cascade_in		[get_parameter_value		gui_enable_cascade_in]
	set usr_cascade_in_mode			[get_parameter_value		gui_pll_cascading_mode]
    set usr_enabled_refclk          [expr {!$usr_enabled_cascade_in}]
	set device_family				[get_parameter_value		gui_device_family]
	set gui_pll_auto_reset          [get_parameter_value        gui_pll_auto_reset]
	
	# General Ports
	enable_interface_and_ports refclk $usr_enabled_refclk	
	enable_interface_and_ports fbclk [expr {($usr_operation_mode == "external feedback")}]	
	enable_interface_and_ports fboutclk	[expr {($usr_operation_mode == "external feedback")}]
	enable_interface_and_ports zdbfbclk	[expr {($usr_operation_mode == "zero delay buffer")}]
	enable_interface_and_ports locked $usr_enabled_locked_port
	                           
	# Reconfig Ports            
	enable_interface_and_ports reconfig_to_pll $usr_enabled_reconfig
	enable_interface_and_ports reconfig_from_pll $usr_enabled_reconfig
	                           
	# DPS Ports                
	# Add scanclk only if dps or reconfig
	enable_interface_and_ports scanclk [expr {(!$usr_enabled_reconfig && $usr_enabled_dps_ports)}] 
	enable_interface_and_ports phase_en	$usr_enabled_dps_ports
	enable_interface_and_ports updn	$usr_enabled_dps_ports
	enable_interface_and_ports cntsel $usr_enabled_dps_ports
	enable_interface_and_ports phase_done $usr_enabled_dps_ports
	enable_interface_and_ports num_phase_shifts	$usr_enabled_dps_ports
	#Note that cntsel port is 5 bits in 28nm, it is maintained as 5 for nf for backwards compatibility. 
	#but only cntsel[3:0] are passed to the IOPLL.
	
	#PHOUT Ports
	enable_interface_and_ports phout $usr_enabled_phout_ports
	
	#Extclkout Ports
	enable_interface_and_ports extclk_out $usr_enabled_extclkout_ports
       	if {($usr_operation_mode == "external feedback" \
           || $usr_operation_mode == "zero delay buffer") \
           && $usr_enabled_extclkout_ports && ($device_family == "Stratix 10")} {
		set_port_property extclk_out WIDTH_EXPR 1
	}

	#LVDS Ports
	enable_interface_and_ports lvds_clk [expr {($usr_enabled_lvds_ports != "Disabled")}]
	enable_interface_and_ports loaden [expr {($usr_enabled_lvds_ports != "Disabled")}]

	# Refclk Switchover Ports		
	enable_interface_and_ports refclk1 $usr_enabled_refclk_switch
	enable_interface_and_ports extswitch [expr {($usr_enabled_refclk_switch && \
                 ($usr_refclk_switchover_mode == "Manual Switchover" \
                 || $usr_refclk_switchover_mode == "Automatic Switchover with Manual Override"))}]
	enable_interface_and_ports activeclk [expr {($usr_enabled_refclk_switch && $usr_enabled_active_clk)}]
	enable_interface_and_ports clkbad [expr {($usr_enabled_refclk_switch && $usr_enabled_clkbad)}]
	enable_interface_and_ports cclk	[expr {$usr_enabled_cascade_in && ($usr_cascade_in_mode == "cclk")}]
	
	# Outclk ports
	set max_outclk_to_add [expr {$usr_num_clocks - 1}] 
	set min_outclk_to_add 0 
    if {$usr_enabled_lvds_ports == "Enable LVDS_CLK/LOADEN 0"} {
	if { $device_family == "Stratix 10" } {
	    # in Stratix 10 hide c2 and c3
	    set min_outclk_to_add 4
	} else {
	    # Arria 10
	    set min_outclk_to_add 2
	}
    } elseif {$usr_enabled_lvds_ports == "Enable LVDS_CLK/LOADEN 0 & 1"} {
        set min_outclk_to_add 4
    }

	# Case:225478 -- provide a clock rate on input/output clocks - useful in QSYS systems. 
	for {set i $min_outclk_to_add} {$i < $usr_num_clocks} {incr i} {
		if {!($gui_pll_auto_reset && ($i ==7))} {
			enable_interface_and_ports 			outclk$i   		true
			set user_selected_gui_value [get_parameter_value gui_actual_output_clock_frequency$i]
			set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
			set_interface_property outclk$i clockRateKnown true
			set_interface_property outclk$i clockRate $user_selected_gui_value_hz
		}
	}
    if { $usr_enabled_refclk } {
        set user_selected_gui_value [get_parameter_value gui_reference_clock_frequency]
        set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
        set_interface_property refclk clockRate $user_selected_gui_value_hz
    }
    if { $usr_enabled_cascade_in && ($usr_cascade_in_mode == "adjpllin")} {
     	enable_interface_and_ports 			adjpllin		    true
        set user_selected_gui_value [get_parameter_value gui_reference_clock_frequency]
        set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
        set_interface_property adjpllin clockRate $user_selected_gui_value_hz
    }
    if { $usr_enabled_cascade_out } {
    	enable_interface_and_ports			cascade_out				$usr_enabled_cascade_out
		set_port_property					cascade_out				WIDTH_EXPR	1
        set user_selected_cascade_out_src [get_parameter_value gui_cascade_outclk_index]
        set user_selected_gui_value [get_parameter_value \
                                     gui_actual_output_clock_frequency$user_selected_cascade_out_src]
        set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
        set_interface_property cascade_out clockRate $user_selected_gui_value_hz
    }
}

proc set_interface_enabled {param_name value} {
	set_interface_property	$param_name ENABLED [string is true $value]
}
