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


#
# Clock manager parameters & PLL solver.   
#
# This file is included into altera_hps_hw.tcl for hps.xml generation, 
# as well as logical view clkmgr_hw.tcl for device tree generation.
#
# Author: chang@altera.com
#

source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util pll_model.tcl]
source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util math.tcl]

#
# Global variables
#

#
# Clock sources for all muxes in clock manager. Each pair of element is a list of 
# parameter for selected clock source's frequency, and it's display name.
#
# These lists must be named as <clock_source_parameter>_names, where 
# <clock_source_parameter> is the name of the parameter where the lists will be used
# as it's range.
#
# The order of the clock sources will also determine the register value for the muxes. 
#
set periph_pll_source_names 	{ { eosc1_clk_hz "EOSC1 clock" } { eosc2_clk_hz "EOSC2 clock" } { F2SCLK_PERIPHCLK_FREQ "FPGA-to-HPS peripheral reference clock" } } 
set sdmmc_clk_source_names 	{ { F2SCLK_PERIPHCLK_FREQ "FPGA-to-HPS peripheral reference clock" } { main_nand_sdmmc_clk_hz "Main NAND SDMMC clock" } { periph_nand_sdmmc_clk_hz "Peripheral NAND SDMMC clock" } }
set nand_clk_source_names 	{ { F2SCLK_PERIPHCLK_FREQ "FPGA-to-HPS peripheral reference clock" } { main_nand_sdmmc_clk_hz "Main NAND SDMMC clock" } { periph_nand_sdmmc_clk_hz "Peripheral NAND SDMMC clock" } }
set qspi_clk_source_names 	{ { F2SCLK_PERIPHCLK_FREQ "FPGA-to-HPS peripheral reference clock" } { main_qspi_clk_hz "Main QSPI clock" } { periph_qspi_clk_hz "Peripheral QSPI clock" } }
set l4_mp_sp_clk_source_names 	{ { main_clk_hz "Main clock" } { periph_base_clk_hz "Peripheral base clock" } }
set l4_mp_clk_source_names	$l4_mp_sp_clk_source_names
set l4_sp_clk_source_names	$l4_mp_sp_clk_source_names

set main_pll_tab			"Main PLL"
set main_pll_param_group		"Main PLL Parameters (Manual Override)"
set main_pll_param_auto_group		"Main PLL Parameters"
set main_pll_internal_clk_group		"Main PLL Internal Clocks"
set main_pll_output_clk_group		"Main PLL Output Clocks - Achieved Frequencies"
set periph_pll_tab			"Peripheral PLL"
set periph_pll_param_group		"Peripheral PLL Parameters (Manual Override)"
set periph_pll_param_auto_group		"Peripheral PLL Parameters"
set periph_pll_internal_clk_group	"Peripheral PLL Internal Clocks"
set periph_pll_internal_div_group	"Peripheral PLL Internal Clock Dividers (Manual Override)"
set periph_pll_internal_div_auto_group	"Peripheral PLL Internal Clock Dividers"
set periph_pll_output_clk_group		"Peripheral PLL Output Clocks - Achieved Frequencies"
set misc_tab		"Miscellaneous"


proc warn_msg { msg } {
	if { [ get_parameter_value show_warning_as_error_msg ] } {
		send_message ERROR $msg
	} else {
		send_message WARNING $msg
	}
}

proc debug_msg { msg } {
	if { [ get_parameter_value show_debug_info_as_warning_msg ] } {
		send_message WARNING $msg
	} else {
		send_message DEBUG $msg
	}
}

proc get_parameter_name_list { the_list } {
	set new_list {}
	
	for { set i 0 } { $i < [ llength $the_list ] } { incr i } {
		set element [ lindex [ lindex $the_list $i ] 0 ]
		lappend new_list $element
	}
	
	return $new_list
}

proc get_parameter_display_name_list { the_list } {
	set new_list {}
	
	for { set i 0 } { $i < [ llength $the_list ] } { incr i } {
		set element [ lindex [ lindex $the_list $i ] 1 ]
		lappend new_list $element
	}
	
	return $new_list
}

#
# Prepend "$i:" to each list element so that the list can be used 
# as range, for dropdown combo box each element are rendered as
# dropdown selections and only the index value is stored in sopcinfo.
#
proc create_indexed_list { the_list } {
	set new_list {}
	
	for { set i 0 } { $i < [ llength $the_list ] } { incr i } {
		set element [ lindex $the_list $i ]
		lappend new_list "$i:$element"
	}
	
	return $new_list
}


proc get_selected_clock_source { clock_source_param } { 
	if { ! [ get_parameter_property $clock_source_param enabled ] } {
		return 0
	}
	
	set clock_source_param_range_var	${clock_source_param}_names
	global ${clock_source_param_range_var}
	set clock_sources	[ set $clock_source_param_range_var ]
	
	set index 	[ get_parameter_value $clock_source_param ]
	return		[ lindex [ lindex $clock_sources $index ] 0 ]
}

#
# The dropdown combo boxes only store the index, so we'll need to
# extract and compare with the expected clock source name.
#
# Returns: 0 if clock source is not selected, or if the clock source
#          parameter is disabled.
#
#          1 if the clock source is being selected
#
proc is_clock_source_selected { clock_source_param expected_clock_source } { 
	set clock_source	[ get_selected_clock_source $clock_source_param ]
	return [ expr { $clock_source == $expected_clock_source } ]
}

proc validate_clocks { } {
	
	refresh_parameter_ui
	validate_f2h_interfaces_usage
	validate_h2f_interfaces_usage
	
	if { [ is_device_pll_info_valid ] == 0 } {
		return
        }

	refresh_parameter_range
	calculate_clocks

	set configure_advanced_parameters [ get_parameter_value configure_advanced_parameters ]
	
	if { [ string is false $configure_advanced_parameters ] } {
		validate_desired_clock_frequencies
		solve_main_pll
		solve_peripheral_pll
		calculate_clocks
	}
	compare_desired_vs_actual_clocks
}

proc refresh_parameter_ui { } {
	
	# Refresh advanced parameters
	set show_advanced_parameters [ get_parameter_value show_advanced_parameters ]
	set_parameter_property configure_advanced_parameters VISIBLE $show_advanced_parameters
	
	set_parameter_value device_pll_info_auto [ get_device_pll_info ]
	
	set customize_device_pll_info [ get_parameter_value customize_device_pll_info ]
	set_parameter_property device_pll_info_manual enabled $customize_device_pll_info
	
	# Clock sources tab
	set_parameter_property S2FCLK_USER0CLK_FREQ enabled [ get_parameter_value S2FCLK_USER0CLK_Enable ]
	set_parameter_property S2FCLK_USER1CLK_FREQ enabled [ get_parameter_value S2FCLK_USER1CLK_Enable ]
	set_parameter_property S2FCLK_USER2CLK_FREQ enabled [ get_parameter_value S2FCLK_USER2CLK_Enable ]
	
	set_parameter_property configure_advanced_parameters enabled true
	if { [ get_parameter_value configure_advanced_parameters ] } {
		set enable_desired_clock_frequency_parameters 1
		set enable_advanced_parameters 1
	} else {
		set enable_desired_clock_frequency_parameters 1
		set enable_advanced_parameters 0
	}
	
	# Clock outputs tab
#	
#	foreach clock_mux { periph_pll l4_mp_clk l4_sp_clk } {
#		set_parameter_property "${clock_mux}_source" enabled true
#	}
	
	set flash_periph_clock_muxes { { sdmmc SDIO } { nand NAND } { qspi QSPI } } 
	foreach flash_periph_clock_mux $flash_periph_clock_muxes {
		
		set hw_param [ lindex $flash_periph_clock_mux 1 ]
		set sw_param [ lindex $flash_periph_clock_mux 0 ]
		
		if { [ get_parameter_value "${hw_param}_PinMuxing" ] != "Unused" } {
			set peripheral_enabled 1
		} else {
			set peripheral_enabled 0
		}
		
		# Enable/disable flash controller input clock muxes dropdown
		set_parameter_property "${sw_param}_clk_source" enabled $peripheral_enabled
	}

	
	set_parameter_property use_default_mpu_clk enabled $enable_desired_clock_frequency_parameters
	
	set enable_desired_mpu_clk false
	if { $enable_desired_clock_frequency_parameters } {
		if { [ get_parameter_value use_default_mpu_clk ] } {
			set enable_desired_mpu_clk false
		} else {
			set enable_desired_mpu_clk true
		}
	}
	set_parameter_property desired_mpu_clk_mhz enabled $enable_desired_mpu_clk 
	set_parameter_property desired_mpu_clk_hz enabled $enable_desired_mpu_clk 

	set non_periph_clocks { l3_mp_clk_div l3_sp_clk_div dbg_at_clk_div dbg_clk_div dbg_trace_clk_div }
	foreach non_periph_clock $non_periph_clocks {
		set_parameter_property $non_periph_clock enabled $enable_desired_clock_frequency_parameters
	}
	
	set non_periph_clocks { l4_mp l4_sp cfg }
	foreach non_periph_clock $non_periph_clocks {
		set_parameter_property "desired_${non_periph_clock}_clk_mhz" enabled $enable_desired_clock_frequency_parameters
		set_parameter_property "desired_${non_periph_clock}_clk_hz" enabled $enable_desired_clock_frequency_parameters
	}
	
	set flash_periph_clocks { { sdmmc SDIO } { nand NAND } { qspi QSPI } }
	foreach flash_periph_clock $flash_periph_clocks {
		set hw_param [ lindex $flash_periph_clock 1 ]
		set sw_param [ lindex $flash_periph_clock 0 ]
		
		if { [ get_parameter_value "${hw_param}_PinMuxing" ] != "Unused" } {
			set peripheral_enabled 1
		} else {
			set peripheral_enabled 0
		}		

		set is_using_f2h_periph_ref_clk	[ is_clock_source_selected "${sw_param}_clk_source" F2SCLK_PERIPHCLK_FREQ ]
		set enable		[ expr $enable_desired_clock_frequency_parameters && $peripheral_enabled && ! $is_using_f2h_periph_ref_clk ]
		set_parameter_property "desired_${sw_param}_clk_mhz" enabled $enable
		set_parameter_property "desired_${sw_param}_clk_hz" enabled $enable
	}
	
	set periph_clocks { { emac0 { EMAC0 } } { emac1 { EMAC1 } } { usb_mp { USB0 USB1 } } { spi_m { SPIM0 SPIM1 } } { can0 { CAN0 } } { can1 { CAN1 } } }
	foreach periph_clock $periph_clocks {
		
		set sw_param [ lindex $periph_clock 0 ]
		set peripheral_enabled 0
		
		foreach hw_param [ lindex $periph_clock 1 ] {
        		if { [ get_parameter_value "${hw_param}_PinMuxing" ] != "Unused" } {
        			set peripheral_enabled 1
        		}		
		}
		set enable		[ expr $enable_desired_clock_frequency_parameters && $peripheral_enabled ]
		set_parameter_property "desired_${sw_param}_clk_mhz" enabled $enable
		set_parameter_property "desired_${sw_param}_clk_hz" enabled $enable
	}
	
	set gpio_enabled [ string is true [ get_parameter_value GPIO_Pin_Used_DERIVED ] ]
	set gpio_enable [ expr $enable_desired_clock_frequency_parameters && $gpio_enabled ]
	set_parameter_property desired_gpio_db_clk_hz enabled $gpio_enable
	
	set show_advanced_tabs $show_advanced_parameters
	
	if { [ get_parameter_value configure_advanced_parameters ] } {
		set show_advanced_tabs 1
		set show_auto_pll_parameters 1
		set show_manual_pll_parameters 1
	} else {
		set show_auto_pll_parameters 1
		set show_manual_pll_parameters 0
	}
	
	global main_pll_tab
	global periph_pll_tab
	global misc_tab

	set_display_item_property $main_pll_tab VISIBLE $show_advanced_tabs
	set_display_item_property $periph_pll_tab VISIBLE $show_advanced_tabs
	set_display_item_property $misc_tab VISIBLE $show_advanced_tabs

	global main_pll_param_group
	global main_pll_param_auto_group
	global periph_pll_param_group
	global periph_pll_param_auto_group
	global periph_pll_internal_div_group
	global periph_pll_internal_div_auto_group
	
	set_display_item_property $main_pll_param_group VISIBLE $show_manual_pll_parameters 
	set_display_item_property $main_pll_param_auto_group VISIBLE $show_auto_pll_parameters 
	set_display_item_property $periph_pll_param_group VISIBLE $show_manual_pll_parameters 
	set_display_item_property $periph_pll_param_auto_group VISIBLE $show_auto_pll_parameters
	set_display_item_property $periph_pll_internal_div_group VISIBLE $show_manual_pll_parameters 
	set_display_item_property $periph_pll_internal_div_auto_group VISIBLE $show_auto_pll_parameters
	
	# PLL parameter tabs
	set params [ list \
		main_pll_m main_pll_n main_pll_c3 main_pll_c4 main_pll_c5 \
		periph_pll_m periph_pll_n periph_pll_c0 periph_pll_c1 periph_pll_c2 periph_pll_c3 periph_pll_c4 periph_pll_c5 \
		usb_mp_clk_div spi_m_clk_div can0_clk_div can1_clk_div gpio_db_clk_div \
		l4_mp_clk_div l4_sp_clk_div \
	]
	
	foreach param $params {
		set_parameter_property $param enabled $enable_advanced_parameters 
	}
	
}

proc refresh_parameter_range { } {
	#
	# Update input clock source allowed ranges
	#
	set_parameter_property eosc1_clk_mhz ALLOWED_RANGES [ list 10.0:50.0 ]
	set_parameter_property eosc2_clk_mhz ALLOWED_RANGES [ list 10.0:50.0 ]
	
	#
	# Update main PLL desired clock frequency ranges
	#
        set pll_info [ get_customizable_device_pll_info ]
	set main_pll_vco_range [ lindex $pll_info 0 ]
        set main_pll_info [ lindex $pll_info 2 ]
        
	set max_mpu_clk_hz [ lindex $main_pll_info 0 ]
	set max_main_clk_hz [ lindex $main_pll_info 1 ]
	set max_dbg_base_clk_hz [ lindex $main_pll_info 2 ]
	set max_mpu_clk_mhz [ expr double($max_mpu_clk_hz) / 1000000 ]
	set max_dbg_base_clk_mhz [ expr double($max_dbg_base_clk_hz) /1000000 ]
	
	set_parameter_value default_mpu_clk_mhz $max_mpu_clk_mhz
	
	set eosc1_clk_mhz [ get_parameter_value eosc1_clk_mhz ]
	if { [ get_parameter_value use_default_mpu_clk ] } {
		set default_or_desired_mpu_clk_mhz [ get_parameter_value default_mpu_clk_mhz ]
	} else {
		set default_or_desired_mpu_clk_mhz [ get_parameter_value desired_mpu_clk_mhz ]
	}

	# Calculate main_pll c0,c1,c2 internal registers based on max mpu,main,debug clocks.
	# Users can never override these values as they are fixed per speedgrade, this
	# guarantees that we can support non-linear VCO vs mpu/main/debug clock relationship
	# i.e. AV I3 speedgrade has lower VCO than AV C4   
	set default_or_desired_mpu_clk_hz [ expr round($default_or_desired_mpu_clk_mhz * 1000000) ]
	set main_pll_vco_max_hz [ lindex $main_pll_vco_range 1 ]
	set vco_to_mpu_clk_ratio [ expr double($main_pll_vco_max_hz) / $default_or_desired_mpu_clk_hz ]
	# c0 must be >= 0, as such vco/mpu_clk must be >= 1, the only case when vco/mpu_clk <0
	# is when desired mpu_clk>vco, when this happens, we'll limit to mpu_clk=vco
	if { $vco_to_mpu_clk_ratio >= 1 } {
        	# Must round down to avoid actual VCO ($c0_internal * $mpu_clk) exceeds max VCO
        	set c0_internal [ expr round(floor($vco_to_mpu_clk_ratio)) - 1 ]
	} else {
		# limit to mpu_clk=vco
		set c0_internal 0
	}
	set main_pll_vco_actual_hz [ expr $default_or_desired_mpu_clk_hz * ($c0_internal + 1) ]
	
	# Must round up to make (actual VCO / $c1_internal) and (actual VCO / $c2_internal)
	# yield $main_clk and $dbg_base_clk as close as $max_main_clk and $max_dbg_base_clk 
	set c1_internal [ expr round(ceil(double($main_pll_vco_actual_hz) / $max_main_clk_hz)) - 1]
	set c2_internal [ expr round(ceil(double($main_pll_vco_actual_hz) / $max_dbg_base_clk_hz)) - 1]
	
	set_parameter_value main_pll_c0_internal $c0_internal 
	set_parameter_value main_pll_c1_internal $c1_internal
	set_parameter_value main_pll_c2_internal $c2_internal
	
	set c1_to_c0_ratio [ expr double($c1_internal + 1) / ($c0_internal + 1) ]
	set c2_to_c0_ratio [ expr double($c2_internal + 1) / ($c0_internal + 1) ]
	set main_clk_mhz [ expr $default_or_desired_mpu_clk_mhz / $c1_to_c0_ratio ]
	set l3_mp_clk_mhz [ expr $main_clk_mhz / pow(2,[ get_parameter_value l3_mp_clk_div ]) ]
	if { [ get_parameter_value dbctrl_stayosc1 ] } {
		set dbg_base_clk_mhz $eosc1_clk_mhz
	} else {
		set dbg_base_clk_mhz [ expr $default_or_desired_mpu_clk_mhz / $c2_to_c0_ratio ]
	}
	set dbg_at_clk_mhz [ expr $dbg_base_clk_mhz / pow(2,[ get_parameter_value dbg_at_clk_div ]) ]
	
	if { [ get_parameter_value use_default_mpu_clk ] } {
		set desired_mpu_clk_mhz_range {}
	} else {
		set desired_mpu_clk_mhz_range [ list $eosc1_clk_mhz:$max_mpu_clk_mhz ]
	}
	
	# CASE:205631 ensure l3_mp_clk dividers do not produce l3_mp_clk which exceeds 200 MHz
	set l3_mp_clk_div_integer_range [ calculate_valid_integer_dividers $main_clk_mhz 200.0 {0 1} ]
       	set l3_mp_clk_div_range [ calculate_divider_frequency_range $main_clk_mhz $l3_mp_clk_div_integer_range ]
	set l3_sp_clk_div_integer_range [ calculate_valid_integer_dividers $l3_mp_clk_mhz 100.0 {0 1} ]
       	set l3_sp_clk_div_range [ calculate_divider_frequency_range $l3_mp_clk_mhz $l3_sp_clk_div_integer_range ]
	
	# CASE:205631 ensure dbg_at_clk dividers do not produce dbg_at_clk which either exceeds 
	# 1/4 mpu_clk or 200.0, whichever is lower.
	set mpu_clk_mhz_div_4 [ expr $default_or_desired_mpu_clk_mhz / 4 ]
	if { $mpu_clk_mhz_div_4 >= 200.0 } {
		set dbg_at_clk_div_integer_range [ calculate_valid_integer_dividers $dbg_base_clk_mhz 200.0 {0 1 2} ]
	} else {
		set dbg_at_clk_div_integer_range [ calculate_valid_integer_dividers $dbg_base_clk_mhz $mpu_clk_mhz_div_4 {0 1 2} ]
	}

	# CASE:205631 if dbg_at_clk_div_integer_range is empty (rare, corner case), 
	# it means all dividers will cause dbg_at_clk to exceed 1/4 mpu_clk,
	# in other words, the following constraint cannot be met:
	#
	#    desired_mpu_clk >= dbg_base_clk
	#
	# For proper handling we need to first look at dbctrl_stayosc1 and
	# use_default_mpu_clk values.
	#
	# CASE A: 
	#
	#    1. dbctrl_stayosc1=false && use_default_mpu_clk=false
	#       a. dbg_base_clk defaults to 300-400 MHz, depending on speedgrade
	#       b. Desired MPU clock must NOT be lower than 300-400 MHz (dbg_base_clk)
	#          depending on speedgrade
	#       c. Since user desired_mpu_clk allows a minimum of eosc1_clk, we need
	#          to tell users to increase desired_mpu_clk to minimum 300-400 MHz. 
	#
	# CASE B: device_pll_info.txt has inappropriate default values
	#    
	#    1. dbctrl_stayosc1=false && use_default_mpu_clk=true
	#       a. dbg_base_clk defaults to 300-400 MHz, depending on speedgrade
	#       b. default_mpu_clk default to 600-1050 MHz, depending on speedgrade
	#       c. device_pll_info.txt should always contain optimal settings, such 
	#          that all speedgrades MUST satisfy default_mpu_clk >= dbg_base_clk.
	#       d. if device_pll_info.txt is incorrectly configured, there is nothing
	#          users can do, we can only say it's an embarrassing internal error.
	#
	# CASE C: these actually don't cause any errors, but they are included
	#         here for completeness of all possible configurations
	#
	#    1. dbctrl_stayosc1=true && use_default_mpu_clk=false
	#       a. dbg_base_clk bypassed to eosc1_clk
	#       b. desired_mpu_clk has minimum of eosc1_clk hence user cannot specify
	#          desired_mpu_clk lower than eosc1_clk
	#       c. no error condition as this is always met: desired_mpu_clk >= dbg_base_clk 
	#    2. dbctrl_stayosc1_true && use_default_mpu_clk=true
	#       a. dbg_base_clk bypassed to eosc1_clk
	#       b. default_mpu_clk SHOULD NEVER be lower than eosc1_clk absolute
	#          minimum 10.0 MHz, unless if there's typo in device_pll_info.txt
	#
	if { [ llength $dbg_at_clk_div_integer_range ] > 0 } {
        	set dbg_at_clk_div_range [ calculate_divider_frequency_range $dbg_base_clk_mhz $dbg_at_clk_div_integer_range ]
        	set dbg_clk_div_range [ calculate_divider_frequency_range $dbg_at_clk_mhz {1 2} ]
	} else {
		set dbg_at_clk_div_range {}
		set dbg_clk_div_range {}

		set dbg_at_clk_div_display_name [ get_parameter_display_string dbg_at_clk_div ]
		set default_mpu_clk_mhz_display_name [ get_parameter_display_string default_mpu_clk_mhz ]
		set desired_mpu_clk_mhz_display_name [ get_parameter_display_string desired_mpu_clk_mhz ]
		set dbctrl_stayosc1_display_name [ get_parameter_display_string dbctrl_stayosc1 ]

		if { [ get_parameter_value dbctrl_stayosc1 ] } {
			# CASE C - we will only reach here if it's an Altera-internal error
			if { [ get_parameter_value use_default_mpu_clk ] } {
				# dbg_base_clk_mhz is bypassed to eosc1_clk
				send_message ERROR "$dbg_at_clk_div_display_name is out of range, verify device PLL info $default_mpu_clk_mhz_display_name is greater than $dbg_base_clk_mhz MHz"
			} else {
				# Should never reach here
			}
		} else {
			if { [ get_parameter_value use_default_mpu_clk ] } {
				# CASE B - we will only reach here if it's an Altera-internal error
				send_message ERROR "$dbg_at_clk_div_display_name is out of range, verify device PLL info $default_mpu_clk_mhz_display_name is greater than $max_dbg_base_clk_mhz MHz"			
			} else {
				# CASE A - we are more likely to reach here due to user error (desired_mpu_clk)
				send_message ERROR "$dbg_at_clk_div_display_name is out of range, consider enabling $dbctrl_stayosc1_display_name or set $desired_mpu_clk_mhz_display_name to greater than $max_dbg_base_clk_mhz MHz"			
			}
		}
		
	}
	set dbg_trace_clk_div_range [ calculate_divider_frequency_range $dbg_base_clk_mhz {0 1 2 3 4} ]
	
	set_parameter_property desired_mpu_clk_mhz ALLOWED_RANGES $desired_mpu_clk_mhz_range
	set_parameter_property l3_mp_clk_div ALLOWED_RANGES $l3_mp_clk_div_range
	set_parameter_property l3_sp_clk_div ALLOWED_RANGES $l3_sp_clk_div_range
	set_parameter_property dbg_at_clk_div ALLOWED_RANGES $dbg_at_clk_div_range
	set_parameter_property dbg_clk_div ALLOWED_RANGES $dbg_clk_div_range
	set_parameter_property dbg_trace_clk_div ALLOWED_RANGES $dbg_trace_clk_div_range

	set_parameter_property desired_cfg_clk_mhz ALLOWED_RANGES [ list 1:125.0 ]
	

	
	#
	# Update peripheral PLL desired clock frequency ranges
	#
	# CASE:32113 since RMII not support, EMAC0/EMAC1 can only use RGMII/GMII
	# which both require 250 MHz.  
	set_parameter_property desired_emac0_clk_mhz ALLOWED_RANGES [ list 250.0:250.0 ]
	set_parameter_property desired_emac1_clk_mhz ALLOWED_RANGES [ list 250.0:250.0 ]
	
	# TODO: set periph_base_clk range
	set usb0_enabled [ expr [ string compare [ get_parameter_value "USB0_PinMuxing" ] "Unused" ] != 0 ]
	set usb1_enabled [ expr [ string compare [ get_parameter_value "USB1_PinMuxing" ] "Unused" ] != 0 ]
	if { $usb0_enabled || $usb1_enabled } {
		set desired_usb_mp_clk_mhz_range [ list 0.0:200.0 ]
	} else {
		set desired_usb_mp_clk_mhz_range {}
	}
	
	set spim0_enabled [ expr [ string compare [ get_parameter_value "SPIM0_PinMuxing" ] "Unused" ] != 0 ]
	set spim1_enabled [ expr [ string compare [ get_parameter_value "SPIM1_PinMuxing" ] "Unused" ] != 0 ]
	if { $spim0_enabled || $spim1_enabled } {
		# TODO: is this only valid when SPIM is enabled?
		set desired_spi_m_clk_mhz_range [ list 0.0:240.0 ]
	} else {
		set desired_spi_m_clk_mhz_range {}
	}
	
	set can0_enabled [ expr [ string compare [ get_parameter_value "CAN0_PinMuxing" ] "Unused" ] != 0 ]
	if { $can0_enabled } {
		set desired_can0_clk_mhz_range [ list 0.0:100.0 ]
	} else {
		set desired_can0_clk_mhz_range {}
	}
	
	set can1_enabled [ expr [ string compare [ get_parameter_value "CAN1_PinMuxing" ] "Unused" ] != 0 ]
	if { $can1_enabled } {
		set desired_can1_clk_mhz_range [ list 0.0:100.0 ]
	} else {
		set desired_can1_clk_mhz_range {}
	}
	
	set_parameter_property desired_usb_mp_clk_mhz ALLOWED_RANGES $desired_usb_mp_clk_mhz_range
	set_parameter_property desired_spi_m_clk_mhz ALLOWED_RANGES $desired_spi_m_clk_mhz_range
	set_parameter_property desired_can0_clk_mhz ALLOWED_RANGES $desired_can0_clk_mhz_range
	set_parameter_property desired_can1_clk_mhz ALLOWED_RANGES $desired_can1_clk_mhz_range

	set gpio_enabled [ string is true [ get_parameter_value GPIO_Pin_Used_DERIVED ] ]
	if { $gpio_enabled } {
		set desired_gpio_clk_hz_range [ list 1:32000 ]
	} else {
		set desired_gpio_clk_hz_range {}
	}
	set_parameter_property desired_gpio_db_clk_hz ALLOWED_RANGES $desired_gpio_clk_hz_range  
	
	if { [ get_parameter_value S2FCLK_USER1CLK_Enable ] } {
		set S2FCLK_USER1CLK_FREQ_RANGE [ list 1:100.0 ]
	} else {
		set S2FCLK_USER1CLK_FREQ_RANGE {}
	}
	set_parameter_property S2FCLK_USER1CLK_FREQ ALLOWED_RANGES $S2FCLK_USER1CLK_FREQ_RANGE 
	
	
	#
	# Update muxed desired clock frequency ranges
	#
	
	if { [ is_clock_source_selected l4_mp_clk_source main_clk_hz ] } {
		set desired_l4_mp_clk_mhz_range [ list [ expr $eosc1_clk_mhz / 16 ]:100.0 ]
	} else {
		set desired_l4_mp_clk_mhz_range [ list 0:100.0 ]
	}

	if { [ is_clock_source_selected l4_sp_clk_source main_clk_hz ] } {
		set desired_l4_sp_clk_mhz_range [ list [ expr $eosc1_clk_mhz / 16 ]:100.0 ]
	} else {
		set desired_l4_sp_clk_mhz_range [ list 0:100.0 ]
	}
	
	set_parameter_property desired_l4_mp_clk_mhz ALLOWED_RANGES $desired_l4_mp_clk_mhz_range
	set_parameter_property desired_l4_sp_clk_mhz ALLOWED_RANGES $desired_l4_sp_clk_mhz_range

	# CASE:207344 sdmmc maximum up to 200.0 MHz.
	if { [ is_clock_source_selected sdmmc_clk_source main_nand_sdmmc_clk_hz ] } {
		set desired_sdmmc_clk_mhz_range [ list $eosc1_clk_mhz:200.0 ]
	} elseif { [ is_clock_source_selected sdmmc_clk_source periph_nand_sdmmc_clk_hz ] } {
		set desired_sdmmc_clk_mhz_range [ list 0.0:200.0 ]		
	} elseif { [ is_clock_source_selected sdmmc_clk_source F2SCLK_PERIPHCLK_FREQ ] } {
		# If SDMMC set to f2s_periph_ref_clk, do not set allowed ranges 
		# as f2s_periph_ref_clk already sets the allowed ranges 
		set desired_sdmmc_clk_mhz_range {}
	} else {
		# If SDMMC disabled, do not set allowed ranges
		set desired_sdmmc_clk_mhz_range {}
	}
	
	if { [ is_clock_source_selected nand_clk_source main_nand_sdmmc_clk_hz ] } {
		set desired_nand_clk_mhz_range [ list $eosc1_clk_mhz:250.0 ]
	} elseif { [ is_clock_source_selected nand_clk_source periph_nand_sdmmc_clk_hz ] } {
		set desired_nand_clk_mhz_range [ list 0.0:250.0 ]		
	} elseif { [ is_clock_source_selected nand_clk_source F2SCLK_PERIPHCLK_FREQ ] } {
		# If NAND set to f2s_periph_ref_clk, do not set allowed ranges 
		# as f2s_periph_ref_clk already sets the allowed ranges		
		set desired_nand_clk_mhz_range {}
	} else {
		# If NAND disabled, do not set allowed ranges
		set desired_nand_clk_mhz_range {}
	}

	if { [ is_clock_source_selected qspi_clk_source main_qspi_clk_hz ] } {
		set desired_qspi_clk_mhz_range [ list 0.0:432.0 ]
	} elseif { [ is_clock_source_selected qspi_clk_source periph_qspi_clk_hz ] } {
		set desired_qspi_clk_mhz_range [ list 0.0:432.0 ]
	} elseif { [ is_clock_source_selected qspi_clk_source F2SCLK_PERIPHCLK_FREQ ] } {
		# If QSPI set to f2s_periph_ref_clk, do not set allowed ranges 
		# as f2s_periph_ref_clk already sets the allowed ranges		
		set desired_qspi_clk_mhz_range {}
	} else {
		# If QSPI disabled, do not set allowed ranges
		set desired_qspi_clk_mhz_range {}
	}
	
	set_parameter_property desired_sdmmc_clk_mhz ALLOWED_RANGES $desired_sdmmc_clk_mhz_range
	set_parameter_property desired_nand_clk_mhz ALLOWED_RANGES $desired_nand_clk_mhz_range
	set_parameter_property desired_qspi_clk_mhz ALLOWED_RANGES $desired_qspi_clk_mhz_range

}

#
# Warn if f2h_periph_ref_clk is enabled but not used as clock source.
# Error out if f2h_periph_ref_clk is disabled but is used as clock source.
#
proc validate_f2h_interfaces_usage { } {

	# F2SCLK_SDRAMCLK_FREQ_MHZ & F2SCLK_PERIPHCLK_FREQ_MHZ parameters are
	# bound to system info, however their values are 0 when the clock
	# clock interfaces are unconnected.
	#
	# When they are unconnected, we should not check F2SCLK_SDRAMCLK_FREQ_MHZ 
	# & F2SCLK_PERIPHCLK_FREQ_MHZ ranges, and instead let the user deal with
	# clock interfaces which are enabled yet unconnected.
	# 
	# Once these clock interfaces are connected, the system info will return 
	# non-zero value, that is when we check to see if they are within allowed
	# ranges.

	 
	set name [ get_module_property NAME ]
	set f2s_sdram_ref_clk_display_string "<b>FPGA-to-HPS SDRAM reference clock ($name.f2h_sdram_ref_clock)</b>"
	set f2s_periph_ref_clk_display_string "<b>FPGA-to-HPS peripheral reference clock ($name.f2h_periph_ref_clock)</b>"
	
	if { [ get_parameter_value F2SCLK_SDRAMCLK_Enable ] } {
		set F2SCLK_SDRAMCLK_FREQ [ get_parameter_value F2SCLK_SDRAMCLK_FREQ ]
		set F2SCLK_SDRAMCLK_FREQ_MHZ [ expr double($F2SCLK_SDRAMCLK_FREQ) / 1000000 ] 
		if { $F2SCLK_SDRAMCLK_FREQ_MHZ > 0 } {
			if { $F2SCLK_SDRAMCLK_FREQ_MHZ < 10 || $F2SCLK_SDRAMCLK_FREQ_MHZ > 50 } {
				send_message ERROR "$f2s_sdram_ref_clk_display_string connected to clock output $F2SCLK_SDRAMCLK_FREQ_MHZ MHz is out of range: 10.0-50.0 MHz"
			}
		}
	}

	if { [ get_parameter_value F2SCLK_PERIPHCLK_Enable ] } {
		set F2SCLK_PERIPHCLK_FREQ [ get_parameter_value F2SCLK_PERIPHCLK_FREQ ]
		set F2SCLK_PERIPHCLK_FREQ_MHZ [ expr double($F2SCLK_PERIPHCLK_FREQ) / 1000000 ] 
		if { $F2SCLK_PERIPHCLK_FREQ_MHZ > 0 } {
			if { $F2SCLK_PERIPHCLK_FREQ_MHZ < 10 || $F2SCLK_PERIPHCLK_FREQ_MHZ > 50 } {
				send_message ERROR "$f2s_periph_ref_clk_display_string connected to clock output $F2SCLK_PERIPHCLK_FREQ_MHZ MHz is out of range: 10.0-50.0 MHz"
			}
		} 
	}
	
	set clock_source_names { periph_pll_source sdmmc_clk_source nand_clk_source qspi_clk_source }
	
	if { [ get_parameter_value F2SCLK_PERIPHCLK_Enable ] } {
		set is_f2h_periph_ref_clk_selected 0
		foreach clock_source_name $clock_source_names {
			if { [ is_clock_source_selected $clock_source_name F2SCLK_PERIPHCLK_FREQ ] } {
				incr is_f2h_periph_ref_clk_selected
			}
		}
		if { $is_f2h_periph_ref_clk_selected == 0 } {
			warn_msg "$f2s_periph_ref_clk_display_string is enabled but it is not used as peripheral PLL, SDMMC, NAND, or QSPI clock sources."
		} else {
			# CASE:205947 any clocks derived from f2h_periph_ref_clk will not work unless FPGA is in user mode
			send_message INFO "Peripheral PLL, SDMMC, NAND, or QSPI clock sources set to $f2s_periph_ref_clk_display_string will only be functional after FPGA has been configured."
		}
	} else {
		foreach clock_source_name $clock_source_names {
			if { [ is_clock_source_selected $clock_source_name F2SCLK_PERIPHCLK_FREQ ] } {
				set clock_source_display_name [ get_parameter_display_string $clock_source_names ]
				send_message ERROR "$f2s_periph_ref_clk_display_string is not enabled and cannot be used as $clock_source_display_name."
			}
		}
	}
}


proc validate_h2f_interfaces_usage { } {
	# cfg_clk and s2f_user0_clk are both derived from main pll c5, the only difference
	# is that cfg_clk is always used while s2f_user0_clk may or may not be enabled/used.
	# Hence we will let user specify desired_cfg_clk_mhz, then use that as desired
	# s2f_user0_clk (S2FCLK_USER0_CLK_FREQ) as well.
	set desired_cfg_clk_mhz [ get_parameter_value desired_cfg_clk_mhz ]
	set_parameter_value S2FCLK_USER0CLK_FREQ $desired_cfg_clk_mhz
	if { [ get_parameter_value S2FCLK_USER0CLK_Enable] } {
		# Be carefuly not to overclock s2f_user0_clk when desired_cfg_clk_mhz 
		# exceeds 100.0 MHz
		if { $desired_cfg_clk_mhz > 100.0 } {
			set desired_cfg_clk_mhz_name [ get_parameter_display_string desired_cfg_clk_mhz ]
			send_message ERROR "$desired_cfg_clk_mhz_name cannot exceed 100.0 MHz when HPS-to-FPGA user 0 clock is enabled."
		}
	}
}


proc calculate_clocks { } {

	global mhz_to_hz_map
	
	foreach mhz_to_hz_entry $mhz_to_hz_map {
		set param1 [ lindex $mhz_to_hz_entry 0 ]
		set param2 [ lindex $mhz_to_hz_entry 1 ]
		set_parameter_value $param2 [ expr [ get_parameter_value $param1 ] * 1000000 ]
	}

	global periph_pll_source_names
	global sdmmc_clk_source_names
	global nand_clk_source_names
	global qspi_clk_source_names
	global l4_mp_sp_clk_source_names

	# There are 2 sets of parameters, user and auto-calculated PLL parameters.
	# Use the desired one depending on which mode we're using 
	if { [ get_parameter_value configure_advanced_parameters ] } {
		set mode {}
	} else {
		set mode _auto
	}
	
	
	################################################################################
	# Calculate main_pll_vco_hz
	set eosc1_clk_hz 		[ get_parameter_value eosc1_clk_hz ]
	set main_pll_ref_clk_hz 	$eosc1_clk_hz

	set main_pll_m 			[ get_parameter_value main_pll_m ]
	set main_pll_n			[ get_parameter_value main_pll_n ]
	set main_pll_vco_hz 		[ expr $main_pll_ref_clk_hz * ($main_pll_m + 1) / ($main_pll_n + 1) ]
	set_parameter_value main_pll_vco_hz 	$main_pll_vco_hz
	
	set main_pll_m_auto 		[ get_parameter_value main_pll_m_auto ]
	set main_pll_n_auto		[ get_parameter_value main_pll_n_auto ]
	set main_pll_vco_auto_hz 	[ expr $main_pll_ref_clk_hz * ($main_pll_m_auto + 1) / ($main_pll_n_auto + 1) ]
	set_parameter_value main_pll_vco_auto_hz	$main_pll_vco_auto_hz
	
	# Select VCO calculated either automatically or manually  
	set main_pll_vco_manual_or_auto_hz	[ set main_pll_vco${mode}_hz ]
	
	# Calculate output clocks derived from main_pll_vco_hz
	set main_pll_mpu_base_clk_hz		[ expr $main_pll_vco_manual_or_auto_hz / ([ get_parameter_value main_pll_c0_internal$mode ] + 1) ]
	set main_pll_main_clk_hz		[ expr $main_pll_vco_manual_or_auto_hz / ([ get_parameter_value main_pll_c1_internal$mode ] + 1) ]
	if { [ get_parameter_value dbctrl_stayosc1 ] } {
		set main_pll_dbg_base_clk_hz		$eosc1_clk_hz
	} else {
		set main_pll_dbg_base_clk_hz		[ expr $main_pll_vco_manual_or_auto_hz / ([ get_parameter_value main_pll_c2_internal$mode ] + 1) ]
	}
	set main_pll_cfg_h2f_user0_clk_hz	[ expr $main_pll_vco_manual_or_auto_hz / ([ get_parameter_value main_pll_c5$mode ] + 1) ]
	set_parameter_value mpu_base_clk_hz	$main_pll_mpu_base_clk_hz  
	set_parameter_value main_clk_hz 	$main_pll_main_clk_hz
	set_parameter_value dbg_base_clk_hz 	$main_pll_dbg_base_clk_hz
	set_parameter_value main_qspi_clk_hz	[ expr $main_pll_vco_manual_or_auto_hz / ([ get_parameter_value main_pll_c3$mode ] + 1) ]
	set_parameter_value main_nand_sdmmc_clk_hz	[ expr $main_pll_vco_manual_or_auto_hz / ([ get_parameter_value main_pll_c4$mode ] + 1) ]  
	set_parameter_value cfg_h2f_user0_clk_hz	$main_pll_cfg_h2f_user0_clk_hz

	# Calculate output clocks derived from main_pll_mpu_base_clk_hz
	set_parameter_value mpu_periph_clk_hz	[ expr $main_pll_mpu_base_clk_hz / 4 ]
	set_parameter_value mpu_l2_ram_clk_hz	[ expr $main_pll_mpu_base_clk_hz / 2 ]
	set_parameter_value mpu_clk_hz		$main_pll_mpu_base_clk_hz
	
	# Calculate output clocks derived from main_pll_main_clk_hz
	set main_pll_l3_mp_clk_div	[ expr pow(2,[ get_parameter_value l3_mp_clk_div ]) ]
	set main_pll_l3_sp_clk_div	[ expr pow(2,[ get_parameter_value l3_sp_clk_div ]) ]
#	set_parameter_value l3_main_clk_hz $main_pll_main_clk_hz
#	set_parameter_value l4_main_clk_hz $main_pll_main_clk_hz
	set_parameter_value l3_mp_clk_hz	[ expr $main_pll_main_clk_hz / $main_pll_l3_mp_clk_div ]
	set_parameter_value l3_sp_clk_hz	[ expr $main_pll_main_clk_hz / $main_pll_l3_mp_clk_div / $main_pll_l3_sp_clk_div ]
	
	# Calculate output clocks derived from main_pll_dbg_base_clk
	set main_pll_dbg_at_clk_div		[ expr pow(2,[ get_parameter_value dbg_at_clk_div ]) ]
	set main_pll_dbg_clk_div		[ expr pow(2,[ get_parameter_value dbg_clk_div ]) ]
	set main_pll_dbg_trace_clk_div 		[ expr pow(2,[ get_parameter_value dbg_trace_clk_div ]) ]
	set_parameter_value dbg_at_clk_hz	[ expr $main_pll_dbg_base_clk_hz / $main_pll_dbg_at_clk_div ]
	set_parameter_value dbg_clk_hz		[ expr $main_pll_dbg_base_clk_hz / $main_pll_dbg_at_clk_div / $main_pll_dbg_clk_div ]
	set_parameter_value dbg_trace_clk_hz	[ expr $main_pll_dbg_base_clk_hz / $main_pll_dbg_trace_clk_div ]
	set_parameter_value dbg_timer_clk_hz	$main_pll_dbg_base_clk_hz
	
	# Calculate output clocks derived from main_pll_cfg_h2f_user0_clk
	set_parameter_value cfg_clk_hz		$main_pll_cfg_h2f_user0_clk_hz
	set_parameter_value h2f_user0_clk_hz	$main_pll_cfg_h2f_user0_clk_hz
	
	
	################################################################################
	# Calculate periph_pll_vco_hz
	set periph_pll_source_name	[ lindex [ get_parameter_name_list $periph_pll_source_names ] [ get_parameter_value periph_pll_source ] ]
	set periph_pll_ref_clk_hz 	[ get_parameter_value ${periph_pll_source_name} ]

	set periph_pll_m 		[ get_parameter_value periph_pll_m ]
	set periph_pll_n 		[ get_parameter_value periph_pll_n ]
	set periph_pll_vco_hz 		[ expr $periph_pll_ref_clk_hz * ($periph_pll_m + 1) / ($periph_pll_n + 1) ]
	set_parameter_value periph_pll_vco_hz 	$periph_pll_vco_hz
	
	set periph_pll_m_auto 		[ get_parameter_value periph_pll_m_auto ]
	set periph_pll_n_auto 		[ get_parameter_value periph_pll_n_auto ]
	set periph_pll_vco_auto_hz 		[ expr $periph_pll_ref_clk_hz * ($periph_pll_m_auto + 1) / ($periph_pll_n_auto + 1) ]
	set_parameter_value periph_pll_vco_auto_hz 	$periph_pll_vco_auto_hz
	
	# Select VCO calculated either automatically or manually  
	set periph_pll_vco_manual_or_auto_hz	[ set periph_pll_vco${mode}_hz ]
	
	# Calculate output clocks derived from periph_pll_vco_hz
	set periph_pll_periph_base_clk_hz 		[ expr $periph_pll_vco_manual_or_auto_hz / ([ get_parameter_value periph_pll_c4$mode ] + 1) ]
	set_parameter_value emac0_clk_hz		[ expr $periph_pll_vco_manual_or_auto_hz / ([ get_parameter_value periph_pll_c0$mode ] + 1) ]  
	set_parameter_value emac1_clk_hz		[ expr $periph_pll_vco_manual_or_auto_hz / ([ get_parameter_value periph_pll_c1$mode ] + 1) ]  
	set_parameter_value periph_qspi_clk_hz		[ expr $periph_pll_vco_manual_or_auto_hz / ([ get_parameter_value periph_pll_c2$mode ] + 1) ]  
	set_parameter_value periph_nand_sdmmc_clk_hz	[ expr $periph_pll_vco_manual_or_auto_hz / ([ get_parameter_value periph_pll_c3$mode ] + 1) ]
	set_parameter_value periph_base_clk_hz 		$periph_pll_periph_base_clk_hz
	set_parameter_value h2f_user1_clk_hz		[ expr $periph_pll_vco_manual_or_auto_hz / ([ get_parameter_value periph_pll_c5$mode ] + 1) ]  
	
	# Calculate output clocks derived from periph_pll_periph_base_clk_hz
	set_parameter_value usb_mp_clk_hz	[ expr $periph_pll_periph_base_clk_hz / [ expr pow(2,[ get_parameter_value usb_mp_clk_div$mode ]) ] ]
#	set_parameter_value scan_manager_clk_hz	[ expr $periph_pll_periph_base_clk_hz / [ expr pow(2,[ get_parameter_value scan_manager_clk_div$mode ]) ] ]
	set_parameter_value spi_m_clk_hz	[ expr $periph_pll_periph_base_clk_hz / [ expr pow(2,[ get_parameter_value spi_m_clk_div$mode ]) ] ]
	set_parameter_value can0_clk_hz		[ expr $periph_pll_periph_base_clk_hz / [ expr pow(2,[ get_parameter_value can0_clk_div$mode ]) ] ]
	set_parameter_value can1_clk_hz		[ expr $periph_pll_periph_base_clk_hz / [ expr pow(2,[ get_parameter_value can1_clk_div$mode ]) ] ]
	set_parameter_value gpio_db_clk_hz	[ expr $periph_pll_periph_base_clk_hz / ([ get_parameter_value gpio_db_clk_div$mode ] + 1) ]

	################################################################################
	# Calculate SDMMC, NAND, QSPI, L4 MP, L4 SP clocks
	set sdmmc_clk_source_name 	[ lindex [ get_parameter_name_list $sdmmc_clk_source_names ] [ get_parameter_value sdmmc_clk_source ] ]
	set nand_clk_source_name 	[ lindex [ get_parameter_name_list $nand_clk_source_names ] [ get_parameter_value nand_clk_source ] ]
	set qspi_clk_source_name	[ lindex [ get_parameter_name_list $qspi_clk_source_names ] [ get_parameter_value qspi_clk_source ] ]
	set l4_mp_clk_source_name	[ lindex [ get_parameter_name_list $l4_mp_sp_clk_source_names ] [ get_parameter_value l4_mp_clk_source ] ]
	set l4_sp_clk_source_name	[ lindex [ get_parameter_name_list $l4_mp_sp_clk_source_names ] [ get_parameter_value l4_sp_clk_source ] ]

	set nand_x_clk_hz			[ get_parameter_value ${nand_clk_source_name} ]
	
	set_parameter_value sdmmc_clk_hz	[ get_parameter_value ${sdmmc_clk_source_name} ]
	set_parameter_value nand_x_clk_hz	$nand_x_clk_hz
	set_parameter_value nand_clk_hz		[ expr $nand_x_clk_hz / 4 ]
	set_parameter_value qspi_clk_hz		[ get_parameter_value ${qspi_clk_source_name} ]
	set_parameter_value l4_mp_clk_hz	[ expr [ get_parameter_value ${l4_mp_clk_source_name} ] / [ expr pow(2,[ get_parameter_value l4_mp_clk_div$mode ]) ] ]
	set_parameter_value l4_sp_clk_hz	[ expr [ get_parameter_value ${l4_sp_clk_source_name} ] / [ expr pow(2,[ get_parameter_value l4_sp_clk_div$mode ]) ] ]
	
	global hz_to_mhz_map
	
	foreach hz_to_mhz_entry $hz_to_mhz_map {
		set param1 [ lindex $hz_to_mhz_entry 0 ]
		set param2 [ lindex $hz_to_mhz_entry 1 ]
		set value [ get_parameter_value $param1 ]
		# convert to double before dividing to preserve precision
		set_parameter_value $param2 [ expr double($value) / 1000000 ]
	}
}

proc add_parameter2 { group name display_name type value { unit None } { derived false } { range { } } } {
    add_parameter $name $type
    if { $derived } {
    	# Do not set default value if it's derived
    } else {
    	set_parameter_property $name DEFAULT_VALUE $value
    }
    set_parameter_property $name DISPLAY_NAME $display_name
    set_parameter_property $name TYPE $type
    set_parameter_property $name UNITS $unit
    if { [ llength $range] > 0 } {	
	    set_parameter_property $name ALLOWED_RANGES $range
    }
    #	set_parameter_property $name DESCRIPTION ""
    #	set_parameter_property $name AFFECTS_GENERATION false
    set_parameter_property $name DERIVED $derived
    add_display_item $group $name PARAMETER
}

proc get_parameter_display_string { name } {
	set display_name [ get_parameter_property $name DISPLAY_NAME ]
	set display_string "<b>\"$display_name\" ($name)</b>"
	return $display_string
}

#
# Adds a pair of parameters, where one is always derived from the other.
# 
# This is mostly used to convert user input in MHz to Hz for calculation,
# then convert results in Hz back to MHz for display. 
# 
# The idea is to encapsulate the data adaption, however Qsys Tcl scripting
# doesn't allow a very fine grained, per parameter change event handling, 
# hence we'll need to separate the calculation (model) from the association
# (controller).
#
# Actual data adaption are implementation specific, for this reason we 
# track them using a map. Adaptor implementation should iterate over this
# map to perform the specific adaptations.
#
proc add_adaptable_parameter { adapt group name display_name value { derived false } { range { } } } {
	
	# $adapt list contains the adaptation rule as follows: 
	#
	# 0: the name of a list used for storing this pair of parameters
	# 1: data type of original parameter 
	# 2: unit of original parameter
	# 3: suffix for original parameter's name
	# 4: data type of derived parameter 
	# 5: unit of derived parameter
	# 6: suffix for derived parameter's name
	# 7: parameter to display, 0=original, 1=derived. 
	#    0 as default, the unselected one is always hidden.
	
	set type_map_ref [ lindex $adapt 0 ]
	
	set from_type 	[ lindex $adapt 1 ]
	set from_unit 	[ lindex $adapt 2 ]
	set from_suffix [ lindex $adapt 3 ]
	
	if { [ string length $from_suffix ] > 0 } {
		set from_name ${name}_${from_suffix}
	} else {
		set from_name $name	
	}
		
	set to_type 	[ lindex $adapt 4 ]
	set to_unit 	[ lindex $adapt 5 ]
	set to_suffix 	[ lindex $adapt 6 ]
	
	if { [ string length $to_suffix ] > 0 } {
		set to_name ${name}_${to_suffix}
	} else {
		set to_name $name	
	}

	upvar $type_map_ref type_map
	lappend type_map [ list $from_name $to_name ]

	set from_display_name	$from_name
	set from_visible	true
	set to_display_name	$to_name
	set to_visible		true

	if { [ lindex $adapt 7 ] == 0 } {
		set from_display_name	$display_name
		set to_visible		false
	}

	if { [ lindex $adapt 7 ] == 1 } {
		set from_visible	false
		set to_display_name	$display_name
	}
	
	add_parameter2 $group $from_name $from_display_name $from_type $value $from_unit $derived $range
	set_parameter_property $from_name VISIBLE $from_visible

	add_parameter2 $group $to_name $to_display_name $to_type $value $to_unit true
	set_parameter_property $to_name VISIBLE $to_visible
}


proc add_clock_tab { parent_tab } {
	
	global mhz_to_hz_map
	set input_mhz_to_hz_map 		[ list mhz_to_hz_map float MEGAHERTZ mhz integer HERTZ hz 0 ]
	set input_mhz_compat_to_hz_map 		[ list mhz_to_hz_map float MEGAHERTZ "" integer HERTZ HZ 0 ]

	global hz_to_mhz_map
	set hz_to_display_mhz_map 		[ list hz_to_mhz_map integer HERTZ hz float MEGAHERTZ mhz 1 ]
	set hz_compat_to_display_mhz_map 	[ list hz_to_mhz_map integer HERTZ "" float MEGAHERTZ MHZ 1 ]
	
	################################################################################
	# Advanced settings
	################################################################################
	
#	set advanced_settings_group "Advanced Settings"
#	add_display_item $parent_tab $advanced_settings_group GROUP
#	set_display_item_property $advanced_settings_group VISIBLE false
	
	add_parameter2 $parent_tab show_advanced_parameters "Show Clock Manager advanced parameters" boolean false
	set_parameter_property show_advanced_parameters VISIBLE false
	
	add_parameter2 $parent_tab configure_advanced_parameters "Configure Clock Manager advanced parameters manually" boolean false
	
	add_parameter2 $parent_tab device_pll_info_auto "Device PLL info (auto)" string "" None true
	set_parameter_property device_pll_info_auto VISIBLE false
	set_parameter_property device_pll_info_auto DISPLAY_HINT GROW

	add_parameter2 $parent_tab customize_device_pll_info "Customize device PLL info" boolean false
	set_parameter_property customize_device_pll_info VISIBLE false
		
	add_parameter2 $parent_tab device_pll_info_manual "Device PLL info (custom)" string "" None false
	set_parameter_property device_pll_info_manual VISIBLE false
	set_parameter_property device_pll_info_manual DISPLAY_HINT GROW
	set_parameter_property device_pll_info_manual DEFAULT_VALUE "{320000000 1600000000} {320000000 1000000000} {800000000 400000000 400000000}"
	
	### FOR TESTING PURPOSE ONLY ###
	# qsys-generate and qsys-script do not print debug messages to STDOUT,
	# use this parameter to workaround the issue.
	add_parameter2 $parent_tab show_debug_info_as_warning_msg "Show debug information as warning messages" boolean false
	set_parameter_property show_debug_info_as_warning_msg VISIBLE false
	### FOR TESTING PURPOSE ONLY ###
	add_parameter2 $parent_tab show_warning_as_error_msg "Show clock setting issues as error messages" boolean false
	set_parameter_property show_warning_as_error_msg VISIBLE false
	
	################################################################################
	# Clock source and interface tab
	################################################################################

	set clock_source_tab 	"Input Clocks"
	set clock_source_external_group		"External Clock Sources"
	set clock_source_internal_mux_group	"Clock Sources"
	set clock_source_f2h_group		"FPGA-to-HPS PLL Reference Clocks"
	set clock_source_h2f_group 		"HPS-to-FPGA User Clocks"
	add_display_item $parent_tab $clock_source_tab  GROUP TAB
	
	#
	# External clocks group
	#
	add_display_item $clock_source_tab $clock_source_external_group  GROUP
	add_adaptable_parameter $input_mhz_to_hz_map $clock_source_external_group eosc1_clk "EOSC1 clock frequency" 25
	add_adaptable_parameter $input_mhz_to_hz_map $clock_source_external_group eosc2_clk "EOSC2 clock frequency" 25
	
	#
	# FPGA-to-HPS clocks group
	#
	add_display_item $clock_source_tab $clock_source_f2h_group  GROUP
	add_parameter2 $clock_source_f2h_group F2SCLK_SDRAMCLK_Enable "Enable FPGA-to-HPS SDRAM PLL reference clock" boolean false
	add_parameter2 $clock_source_f2h_group F2SCLK_PERIPHCLK_Enable "Enable FPGA-to-HPS peripheral PLL reference clock" boolean false
	# TODO: rename these to F2SCLK_*CLK_FREQ_HZ so that we can have consistent *_HZ/*_MHZ parameter name suffix
	add_adaptable_parameter $hz_compat_to_display_mhz_map $clock_source_f2h_group F2SCLK_SDRAMCLK_FREQ "FPGA-to-HPS SDRAM PLL reference clock frequency" 0
	add_adaptable_parameter $hz_compat_to_display_mhz_map $clock_source_f2h_group F2SCLK_PERIPHCLK_FREQ "FPGA-to-HPS peripheral PLL reference clock frequency" 0
	set_parameter_property F2SCLK_SDRAMCLK_FREQ SYSTEM_INFO { CLOCK_RATE f2h_sdram_ref_clock }
	set_parameter_property F2SCLK_PERIPHCLK_FREQ SYSTEM_INFO { CLOCK_RATE f2h_periph_ref_clock }

	
	################################################################################
	# Output clocks tab
	################################################################################
	
	set clock_output_tab 	"Output Clocks"
	set clock_output_main_pll_group 	"Main PLL Output Clocks - Desired Frequencies"
	set clock_output_periph_pll_group 	"Peripheral PLL Output Clocks - Desired Frequencies"
	add_display_item $parent_tab $clock_output_tab GROUP TAB

	#
	# Clock sources group
	#
	global periph_pll_source_names
	global sdmmc_clk_source_names
	global nand_clk_source_names
	global qspi_clk_source_names
	global l4_mp_sp_clk_source_names
	# peripheral PLL reference clock source
	add_display_item $clock_output_tab $clock_source_internal_mux_group  GROUP
	set periph_pll_sources [ create_indexed_list [ get_parameter_display_name_list $periph_pll_source_names ] ]
	add_parameter2 $clock_source_internal_mux_group periph_pll_source "Peripheral PLL reference clock source" integer 0 None false $periph_pll_sources
	# SDMMC & NAND clock sources
	set sdmmc_clk_sources [ create_indexed_list [ get_parameter_display_name_list $sdmmc_clk_source_names ]	]
	add_parameter2 $clock_source_internal_mux_group sdmmc_clk_source "SDMMC clock source" integer 2 None false $sdmmc_clk_sources
	set nand_clk_sources [ create_indexed_list [ get_parameter_display_name_list $nand_clk_source_names ]	]
	add_parameter2 $clock_source_internal_mux_group nand_clk_source "NAND clock source" integer 2 None false $nand_clk_sources
	# QSPI clock sources
	set qspi_clk_sources [ create_indexed_list [ get_parameter_display_name_list $qspi_clk_source_names ] ] 
	add_parameter2 $clock_source_internal_mux_group qspi_clk_source "QSPI clock source" integer 1 None false $qspi_clk_sources
	# L4 MP SP clock sources
	set l4_mp_sp_clk_sources [ create_indexed_list [ get_parameter_display_name_list $l4_mp_sp_clk_source_names ] ]
	add_parameter2 $clock_source_internal_mux_group l4_mp_clk_source "L4 MP clock source" integer 1 None false $l4_mp_sp_clk_sources
	add_parameter2 $clock_source_internal_mux_group l4_sp_clk_source "L4 SP clock source" integer 1 None false $l4_mp_sp_clk_sources
	
	#
	# Main PLL output clocks group
	#
	add_display_item $clock_output_tab $clock_output_main_pll_group GROUP
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_main_pll_group default_mpu_clk "Default MPU clock frequency" 800 true
	# Desired main PLL output clock frequencies
	add_parameter2 $clock_output_main_pll_group use_default_mpu_clk "Use default MPU clock frequency" boolean false
	# Default to use default MPU clock frequent, this ensures 
	# that everytime a new speedgrade is selected, we will
	# always use the max MPU clock allowed for that speedgrade.
	set_parameter_property use_default_mpu_clk DEFAULT_VALUE true
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_main_pll_group desired_mpu_clk "MPU clock frequency" 800
	add_parameter2 $clock_output_main_pll_group l3_mp_clk_div "L3 MP clock frequency" integer 1 MEGAHERTZ false { 0 1 } 
	add_parameter2 $clock_output_main_pll_group l3_sp_clk_div "L3 SP clock frequency" integer 1 MEGAHERTZ false { 0 1 } 
	add_parameter2 $clock_output_main_pll_group dbctrl_stayosc1 "Debug clocks stay on EOSC1 clock" boolean true
	set_parameter_property dbctrl_stayosc1 VISIBLE false
	add_parameter2 $clock_output_main_pll_group dbg_at_clk_div "Debug AT clock frequency" integer 0 MEGAHERTZ false { 0 1 2 }
	add_parameter2 $clock_output_main_pll_group dbg_clk_div "Debug clock frequency" integer 1 MEGAHERTZ false { 1 2 }
	# CASE:201052 initialize dbg_trace_clk_div allowed_ranges to avoid weird validation error
	add_parameter2 $clock_output_main_pll_group dbg_trace_clk_div "Debug trace clock frequency" integer 0 MEGAHERTZ false { 0 1 2 3 4 }
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_main_pll_group desired_l4_mp_clk "L4 MP clock frequency" 100
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_main_pll_group desired_l4_sp_clk "L4 SP clock frequency" 100
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_main_pll_group desired_cfg_clk "Configuration/HPS-to-FPGA user 0 clock frequency" 100
	set_parameter_property desired_cfg_clk_mhz DESCRIPTION "The desired clock frequency for configuration and HPS-to-FPGA user 0 clock.<br><br>When HPS-to-FPGA user 0 clock is disabled, this only applies to configuration clock with an allowed range of 0-125 MHz.<br><br>When HPS-to-FPGA user 0 clock is enabled, this applies to both configuration and HPS-to-FPGA user 0 clock with an allowed range of 0-100 MHz."
	
	#
	# Peripheral PLL output clocks group
	#
	add_display_item $clock_output_tab $clock_output_periph_pll_group GROUP
	# Desired peripheral PLL output clock frequencies
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_sdmmc_clk "SDMMC clock frequency" 200
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_nand_clk "NAND clock frequency" 12.5
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_qspi_clk "QSPI clock frequency" 400
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_emac0_clk "EMAC0 clock frequency" 250
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_emac1_clk "EMAC1 clock frequency" 250
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_usb_mp_clk "USB clock frequency" 200
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_spi_m_clk "SPI clock frequency" 200
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_can0_clk "CAN0 clock frequency" 100
	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_can1_clk "CAN1 clock frequency" 100
#	add_adaptable_parameter $input_mhz_to_hz_map $clock_output_periph_pll_group desired_gpio_db_clk "GPIO debounce clock frequency" 0.032
	add_parameter2 $clock_output_periph_pll_group desired_gpio_db_clk_hz "GPIO debounce clock frequency" integer 32000 HERTZ
	
	#
	# HPS-to-FPGA clocks group
	#
	add_display_item $clock_output_tab $clock_source_h2f_group GROUP
	add_parameter2 $clock_source_h2f_group S2FCLK_USER0CLK_Enable "Enable HPS-to-FPGA user 0 clock" boolean false
	add_parameter2 $clock_source_h2f_group S2FCLK_USER1CLK_Enable "Enable HPS-to-FPGA user 1 clock" boolean false
	add_parameter2 $clock_source_h2f_group S2FCLK_USER2CLK_Enable "Enable HPS-to-FPGA user 2 clock" boolean false

	add_adaptable_parameter $input_mhz_compat_to_hz_map $clock_source_h2f_group S2FCLK_USER0CLK_FREQ "HPS-to-FPGA user 0 clock frequency" 100 true
	add_adaptable_parameter $input_mhz_compat_to_hz_map $clock_source_h2f_group S2FCLK_USER1CLK_FREQ "HPS-to-FPGA user 1 clock frequency" 100
	add_adaptable_parameter $input_mhz_compat_to_hz_map $clock_source_h2f_group S2FCLK_USER2CLK_FREQ "HPS-to-FPGA user 2 clock frequency" 100
	set_parameter_property S2FCLK_USER2CLK_FREQ visible false
	
	set_parameter_property S2FCLK_USER0CLK_FREQ DESCRIPTION "HPS-to-FPGA user 0 clock frequency is derived from Configuration/HPS-to-FPGA user 0 clock frequency."
	
	add_parameter2 $clock_source_h2f_group S2FCLK_USER2CLK "HPS-to-FPGA user 2 clock frequency"  integer 5:100 Megahertz false 
	################################################################################
	# Main PLL tab
	################################################################################

	global main_pll_tab
	global main_pll_param_group
	global main_pll_param_auto_group
	global main_pll_internal_clk_group
	global main_pll_output_clk_group
	add_display_item $parent_tab $main_pll_tab GROUP TAB

	add_display_item $main_pll_tab $main_pll_param_auto_group GROUP
	add_parameter2 $main_pll_param_auto_group main_pll_m_auto "Main PLL M multiplier" integer 63 None true { 0:4095 }
	add_parameter2 $main_pll_param_auto_group main_pll_n_auto "Main PLL N divider" integer 0 None true { 0:63 }
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_param_auto_group main_pll_vco_auto "Main PLL VCO clock frequency" 0 true
	add_parameter2 $main_pll_param_auto_group main_pll_c0_internal_auto "Main PLL C0 counter (internal)" integer 0 None true { 0:511 }
	add_parameter2 $main_pll_param_auto_group main_pll_c1_internal_auto "Main PLL C1 counter (internal)" integer 0 None true { 0:511 }
	add_parameter2 $main_pll_param_auto_group main_pll_c2_internal_auto "Main PLL C2 counter (internal)" integer 0 None true { 0:511 }
	add_parameter2 $main_pll_param_auto_group main_pll_c3_auto "Main PLL C3 counter" integer 3 None true { 0:511 }
	add_parameter2 $main_pll_param_auto_group main_pll_c4_auto "Main PLL C4 counter" integer 3 None true { 0:511 }
	add_parameter2 $main_pll_param_auto_group main_pll_c5_auto "Main PLL C5 counter" integer 15 None true { 0:511 }
	
	# Main PLL parameters group
	add_display_item $main_pll_tab $main_pll_param_group GROUP
	add_parameter2 $main_pll_param_group main_pll_m "Main PLL M multiplier" integer 63 None false { 0:4095 }
	add_parameter2 $main_pll_param_group main_pll_n "Main PLL N divider" integer 0 None false { 0:63 }
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_param_group main_pll_vco "Main PLL VCO clock frequency" 0 true
	# Main PLL c0, c1, c2 have fixed values, we'll set them everytime we solve the PLLs 
	add_parameter2 $main_pll_param_group main_pll_c0_internal "Main PLL C0 counter (internal)" integer 0 None true
	add_parameter2 $main_pll_param_group main_pll_c1_internal "Main PLL C1 counter (internal)" integer 0 None true
	add_parameter2 $main_pll_param_group main_pll_c2_internal "Main PLL C2 counter (internal)" integer 0 None true
	add_parameter2 $main_pll_param_group main_pll_c3 "Main PLL C3 counter" integer 3 None false { 0:511 }
	add_parameter2 $main_pll_param_group main_pll_c4 "Main PLL C4 counter" integer 3 None false { 0:511 }
	add_parameter2 $main_pll_param_group main_pll_c5 "Main PLL C5 counter" integer 15 None false { 0:511 }

	# Main PLL internal clocks group
	# Clock parameters, in Hz, derived for calculation only.
	add_display_item $main_pll_tab $main_pll_internal_clk_group GROUP
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_internal_clk_group mpu_base_clk "MPU base clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_internal_clk_group main_clk "Main clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_internal_clk_group dbg_base_clk "Debug base clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_internal_clk_group main_qspi_clk "Main QSPI clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_internal_clk_group main_nand_sdmmc_clk "Main NAND SDMMC clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_internal_clk_group cfg_h2f_user0_clk "Configuration/HPS-to-FPGA user 0 clock frequency" 0 true
	
	# Main PLL output clocks group
	add_display_item $main_pll_tab $main_pll_output_clk_group GROUP
	# Clocks derived from main pll output clock mpu_base_clk
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group mpu_periph_clk "MPU peripheral clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group mpu_l2_ram_clk "MPU L2 RAM clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group mpu_clk "MPU clock frequency" 0 true

	# Clocks derived from main pll output clock main_clk
#	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group l4_main_clk "L4 main clock frequency" 0 true
#	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group l3_main_clk "L3 main clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group l3_mp_clk "L3 MP clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group l3_sp_clk "L3 SP clock frequency" 0 true

	# Clocks derived from main pll output clock dbg_timer_clk
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group dbg_at_clk "Debug AT clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group dbg_clk "Debug clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group dbg_trace_clk "Debug trace clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group dbg_timer_clk "Debug timer clock frequency" 0 true

	# Clocks derived from main pll output clock cfg_h2f_user0_clk
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group cfg_clk "Configuration clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $main_pll_output_clk_group h2f_user0_clk "HPS-to-FPGA user 0 clock frequency" 0 true


	################################################################################
	# Peripheral PLL tab
	################################################################################

	global periph_pll_tab
	global periph_pll_param_group
	global periph_pll_param_auto_group
	global periph_pll_internal_clk_group
	global periph_pll_internal_div_group
	global periph_pll_internal_div_auto_group
	global periph_pll_output_clk_group

	add_display_item $parent_tab $periph_pll_tab GROUP TAB
	
	add_display_item $periph_pll_tab $periph_pll_param_auto_group GROUP
	add_parameter2 $periph_pll_param_auto_group periph_pll_m_auto "Peripheral PLL M multiplier" integer 79 None true { 0:4095 }
	add_parameter2 $periph_pll_param_auto_group periph_pll_n_auto "Peripheral PLL N divider" integer 1 None true { 0:63 }
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_param_auto_group periph_pll_vco_auto "Peripheral PLL VCO clock frequency" 0 true
	add_parameter2 $periph_pll_param_auto_group periph_pll_c0_auto "Peripheral PLL C0 counter" integer 3 None true { 0:511 }
	add_parameter2 $periph_pll_param_auto_group periph_pll_c1_auto "Peripheral PLL C1 counter" integer 3 None true { 0:511 }
	add_parameter2 $periph_pll_param_auto_group periph_pll_c2_auto "Peripheral PLL C2 counter" integer 1 None true { 0:511 }
	add_parameter2 $periph_pll_param_auto_group periph_pll_c3_auto "Peripheral PLL C3 counter" integer 19 None true { 0:511 }
	add_parameter2 $periph_pll_param_auto_group periph_pll_c4_auto "Peripheral PLL C4 counter" integer 4 None true { 0:511 }
	add_parameter2 $periph_pll_param_auto_group periph_pll_c5_auto "Peripheral PLL C5 counter" integer 9 None true { 0:511 }

	# Peripheral PLL parameters group
	add_display_item $periph_pll_tab $periph_pll_param_group GROUP
	add_parameter2 $periph_pll_param_group periph_pll_m "Peripheral PLL M multiplier" integer 79 None false { 0:4095 }
	add_parameter2 $periph_pll_param_group periph_pll_n "Peripheral PLL N divider" integer 1 None false { 0:63 }
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_param_group periph_pll_vco "Peripheral PLL VCO clock frequency" 0 true
	add_parameter2 $periph_pll_param_group periph_pll_c0 "Peripheral PLL C0 counter" integer 3 None false { 0:511 }
	add_parameter2 $periph_pll_param_group periph_pll_c1 "Peripheral PLL C1 counter" integer 3 None false { 0:511 }
	add_parameter2 $periph_pll_param_group periph_pll_c2 "Peripheral PLL C2 counter" integer 1 None false { 0:511 }
	add_parameter2 $periph_pll_param_group periph_pll_c3 "Peripheral PLL C3 counter" integer 19 None false { 0:511 }
	add_parameter2 $periph_pll_param_group periph_pll_c4 "Peripheral PLL C4 counter" integer 4 None false { 0:511 }
	add_parameter2 $periph_pll_param_group periph_pll_c5 "Peripheral PLL C5 counter" integer 9 None false { 0:511 }
	
	# Peripheral PLL internal clocks group
	add_display_item $periph_pll_tab $periph_pll_internal_clk_group GROUP
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_internal_clk_group periph_qspi_clk "Peripheral QSPI clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_internal_clk_group periph_nand_sdmmc_clk "Peripheral NAND SDMMC clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_internal_clk_group periph_base_clk "Peripheral base clock frequency" 0 true
	
	add_display_item $periph_pll_tab $periph_pll_internal_div_auto_group GROUP
	add_parameter2 $periph_pll_internal_div_auto_group usb_mp_clk_div_auto "USB MP clock divider" integer 0 None true { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
#        add_parameter2 $periph_pll_internal_div_auto_group scan_manager_clk_div_auto "Scan Manager clock divider" integer 0 None true { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $periph_pll_internal_div_auto_group spi_m_clk_div_auto "SPI M clock divider" integer 0 None true { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $periph_pll_internal_div_auto_group can0_clk_div_auto "CAN0 clock divider" integer 1 None true { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $periph_pll_internal_div_auto_group can1_clk_div_auto "CAN1 clock divider" integer 1 None true { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $periph_pll_internal_div_auto_group gpio_db_clk_div_auto "GPIO debounce clock divider" integer 6249 None true { 1:16777215 }
	# add_parameter2 intentionally disallow initializing derived parameters, workaround it here. 
	set_parameter_property gpio_db_clk_div_auto DEFAULT_VALUE 1
	
	add_display_item $periph_pll_tab $periph_pll_internal_div_group GROUP
	# Clocks derived from peripheral PLL output clock periph_base_clk
	add_parameter2 $periph_pll_internal_div_group usb_mp_clk_div "USB MP clock divider" integer 0 None false { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
#        add_parameter2 $periph_pll_internal_div_group scan_manager_clk_div "Scan Manager clock divider" integer 0 None false { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $periph_pll_internal_div_group spi_m_clk_div "SPI M clock divider" integer 0 None false { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $periph_pll_internal_div_group can0_clk_div "CAN0 clock divider" integer 1 None false { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $periph_pll_internal_div_group can1_clk_div "CAN1 clock divider" integer 1 None false { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $periph_pll_internal_div_group gpio_db_clk_div "GPIO debounce clock divider" integer 6249 None false { 1:16777215 }
	
	# Peripheral PLL output clocks group
	add_display_item $periph_pll_tab $periph_pll_output_clk_group GROUP
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group emac0_clk "EMAC0 clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group emac1_clk "EMAC1 clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group h2f_user1_clk "HPS-to-FPGA user 1 clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group usb_mp_clk "USB MP clock frequency" 0 true
#	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group scan_manager_clk "Scan Manager clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group spi_m_clk "SPI M clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group can0_clk "CAN0 clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group can1_clk "CAN1 clock frequency" 0 true
#	add_adaptable_parameter $hz_to_display_mhz_map $periph_pll_output_clk_group gpio_db_clk "GPIO debounce clock frequency" 0 true
	add_parameter2 $periph_pll_output_clk_group gpio_db_clk_hz "GPIO debounce clock frequency" integer 0 HERTZ true
	
	################################################################################
	# Miscellaneous tab
	################################################################################
	
	global misc_tab

	add_display_item $parent_tab $misc_tab GROUP TAB
	# L4 MP/SP clock derived from main_clk, periph_base_clk
	add_parameter2 $misc_tab l4_mp_clk_div "L4 MP clock divider" integer 1 None false { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
	add_parameter2 $misc_tab l4_sp_clk_div "L4 SP clock divider" integer 1 None false { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }	
        add_parameter2 $misc_tab l4_mp_clk_div_auto "L4 MP clock divider" integer 1 None true { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }
        add_parameter2 $misc_tab l4_sp_clk_div_auto "L4 SP clock divider" integer 1 None true { "0:Divide 1 " "1:Divide 2 " "2:Divide 4 " "3:Divide 8 " "4:Divide 16 " }	
	add_adaptable_parameter $hz_to_display_mhz_map $misc_tab sdmmc_clk "SDMMC clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $misc_tab nand_x_clk "NAND X clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $misc_tab nand_clk "NAND clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $misc_tab qspi_clk "QSPI clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $misc_tab l4_mp_clk "L4 MP clock frequency" 0 true
	add_adaptable_parameter $hz_to_display_mhz_map $misc_tab l4_sp_clk "L4 SP clock frequency" 0 true
}

proc clocks_logicalview_dtg {} {
	add_instance eosc1 hps_virt_clk
	set_instance_parameter_value eosc1 clockFrequency [get_parameter_value eosc1_clk_hz]

	add_instance eosc2 hps_virt_clk
	set_instance_parameter_value eosc2 clockFrequency [get_parameter_value eosc2_clk_hz]

	add_instance f2s_periph_ref_clk hps_virt_clk
	set_instance_parameter_value f2s_periph_ref_clk clockFrequency [get_parameter_value F2SCLK_PERIPHCLK_FREQ]

	add_instance f2s_sdram_ref_clk hps_virt_clk
	set_instance_parameter_value f2s_sdram_ref_clk clockFrequency [get_parameter_value F2SCLK_SDRAMCLK_FREQ]

}

proc solve_main_pll { } {

	set main_pll [ ::pll_model::create ]
	
	set eosc1_clk_hz [ get_parameter_value eosc1_clk_hz ]
	::pll_model::set_parameter_value $main_pll refclk $eosc1_clk_hz

	set pll_info [ get_customizable_device_pll_info ]
	set main_pll_vco_range [ lindex $pll_info 0 ]
	::pll_model::set_parameter_property $main_pll vcoclk range $main_pll_vco_range
	
	# Use pre-calculated c0,c1,c2 internal register values
	set c0_internal [ get_parameter_value main_pll_c0_internal ]
	set c1_internal [ get_parameter_value main_pll_c1_internal ] 
	set c2_internal [ get_parameter_value main_pll_c2_internal ]
	
	::pll_model::set_parameter_property $main_pll c0 range [ list $c0_internal $c0_internal ]
	::pll_model::set_parameter_property $main_pll c1 range [ list $c1_internal $c1_internal ]
	::pll_model::set_parameter_property $main_pll c2 range [ list $c2_internal $c2_internal ]
	
	if { [ get_parameter_value use_default_mpu_clk ] } {
		set default_or_desired_mpu_clk_hz [ get_parameter_value default_mpu_clk_hz ]	
	} else {
		set default_or_desired_mpu_clk_hz [ get_parameter_value desired_mpu_clk_hz ]
	}
	
	::pll_model::set_parameter_value $main_pll desired_outclk0 $default_or_desired_mpu_clk_hz

	
	# calculate c1 divs
	set c1_to_c0_ratio [ expr (double($c1_internal) + 1) / (double($c0_internal) + 1) ]
	set desired_outclk1 [ expr round($default_or_desired_mpu_clk_hz / $c1_to_c0_ratio) ]
	::pll_model::set_parameter_value $main_pll desired_outclk1 $desired_outclk1
	set actual_outclk1 [ ::pll_model::get_parameter_value $main_pll actual_outclk1 ]

	if { [ is_clock_source_selected l4_mp_clk_source main_clk_hz ] } {
		set l4_mp_clk_div_range { 1 2 4 8 16 } 
		set l4_mp_clk_div_index [ calculate_divider $actual_outclk1 [ get_parameter_value desired_l4_mp_clk_hz ] $l4_mp_clk_div_range ]
		set l4_mp_clk_div [ lindex $l4_mp_clk_div_range $l4_mp_clk_div_index ]
		set_parameter_value l4_mp_clk_div_auto $l4_mp_clk_div_index
	}
	
	if { [ is_clock_source_selected l4_sp_clk_source main_clk_hz ] } {
		set l4_sp_clk_div_range { 1 2 4 8 16 }
		set l4_sp_clk_div_index [ calculate_divider $actual_outclk1 [ get_parameter_value desired_l4_sp_clk_hz ] $l4_sp_clk_div_range  ]
		set l4_sp_clk_div [ lindex $l4_sp_clk_div_range $l4_sp_clk_div_index ]
		set_parameter_value l4_sp_clk_div_auto $l4_sp_clk_div_index
	}

	
	# calculate c2 divs
	set c2_to_c0_ratio [ expr (double($c2_internal) + 1) / (double($c0_internal) + 1) ]
	set desired_outclk2 [ expr round($default_or_desired_mpu_clk_hz / $c2_to_c0_ratio) ]
	::pll_model::set_parameter_value $main_pll desired_outclk2 $desired_outclk2
	set actual_outclk2 [ ::pll_model::get_parameter_value $main_pll actual_outclk2 ]

	
	# calculate c3
	set qspi_enabled [ expr [ string compare [ get_parameter_value "QSPI_PinMuxing" ] "Unused" ] != 0 ]
	if { $qspi_enabled } {
		if { [ is_clock_source_selected qspi_clk_source main_qspi_clk_hz ] } {
			set desired_qspi_clk_hz [ get_parameter_value desired_qspi_clk_hz ]
			::pll_model::set_parameter_value $main_pll desired_outclk3 $desired_qspi_clk_hz
		}
	}

	
		
	# calculate c4
	set sdmmc_clk_source ""
	set nand_clk_source ""
	set is_sdmmc_clk_source_main_nand_sdmmc_clk 0
	set is_nand_clk_source_main_nand_sdmmc_clk 0
	
	set sdmmc_enabled [ expr [ string compare [ get_parameter_value "SDIO_PinMuxing" ] "Unused" ] != 0 ]
	if { $sdmmc_enabled } {
		set sdmmc_clk_source [ get_selected_clock_source sdmmc_clk_source ]
		set is_sdmmc_clk_source_main_nand_sdmmc_clk [ string equal $sdmmc_clk_source main_nand_sdmmc_clk_hz ]		
	}

	set nand_enabled [ expr [ string compare [ get_parameter_value "NAND_PinMuxing" ] "Unused" ] != 0 ]
	if { $nand_enabled } {
		set nand_clk_source [ get_selected_clock_source nand_clk_source ]
		set is_nand_clk_source_main_nand_sdmmc_clk [ string equal $nand_clk_source main_nand_sdmmc_clk_hz ]
	}
	
	if { $is_sdmmc_clk_source_main_nand_sdmmc_clk || $is_nand_clk_source_main_nand_sdmmc_clk } {
		if { $is_sdmmc_clk_source_main_nand_sdmmc_clk } {
			set desired_sdmmc_nand_clk_hz [ get_parameter_value desired_sdmmc_clk_hz ]
		} else {
			set desired_sdmmc_nand_clk_hz [ get_parameter_value desired_nand_clk_hz ]
		}
		::pll_model::set_parameter_value $main_pll desired_outclk4 $desired_sdmmc_nand_clk_hz
	}

	
	# calculate c5
	# c5 derived cfg_clk and s2f_user0_clk, however cfg_clk is always required
	# while s2f_user0_clk is optional, so we'll calculate c5 based on cfg_clk 
	# instead. Also to note that cfg_clk has a bigger range (eosc1_clk:125.0 MHz)
	# than s2f_user0_clk (eosc1_clk:100 MHz) so we should try to solve cfg_clk 
	# first such that if cfg_clk can be achieved, s2f_user0_clk should be 
	# achievable too.
	
	set desired_cfg_clk_hz [ get_parameter_value desired_cfg_clk_hz ]
	::pll_model::set_parameter_value $main_pll desired_outclk5 $desired_cfg_clk_hz 

	set pll_m [ ::pll_model::get_parameter_value $main_pll m ]
	set pll_n [ ::pll_model::get_parameter_value $main_pll n ]
	set_parameter_value main_pll_m_auto $pll_m
	set_parameter_value main_pll_n_auto $pll_n
	set_parameter_value main_pll_c0_internal_auto [ ::pll_model::get_parameter_value $main_pll c0 ]
	set_parameter_value main_pll_c1_internal_auto [ ::pll_model::get_parameter_value $main_pll c1 ]
	set_parameter_value main_pll_c2_internal_auto [ ::pll_model::get_parameter_value $main_pll c2 ]
	set_parameter_value main_pll_c3_auto [ ::pll_model::get_parameter_value $main_pll c3 ]
	set_parameter_value main_pll_c4_auto [ ::pll_model::get_parameter_value $main_pll c4 ]
	set_parameter_value main_pll_c5_auto [ ::pll_model::get_parameter_value $main_pll c5 ]
	
	send_message info "HPS Main PLL counter settings: n = $pll_n  m = $pll_m"
	
	dump_pll main_pll $main_pll
}

proc get_periph_pll_ref_clk_hz { } {
	global periph_pll_source_names 
	set periph_pll_source_name	[ lindex [ get_parameter_name_list $periph_pll_source_names ] [ get_parameter_value periph_pll_source ] ]
	return [ get_parameter_value ${periph_pll_source_name} ]
}

# If parameter is not within allowed range, we can choose to 
# disable user validation message.
proc is_within_allowed_ranges { param } {
	
	set type [ get_parameter_property $param TYPE ]
	set value [ get_parameter_value $param ]
	set is_integer_type [ string equal -nocase $type INTEGER ]
	set is_float_type [ string equal -nocase $type FLOAT ]
	set is_supported_type [ expr $is_integer_type || $is_float_type ]
	
	if { ! $is_supported_type } {
		send_message ERROR "Unsupported $param type $type"
		return 0
	}
	
	set allowed_ranges [ get_parameter_property $param ALLOWED_RANGES ]
	
	if { [ llength $allowed_ranges ] == 0 } {
		# No range specified, assume value is valid
		return 1
	} elseif { [ llength $allowed_ranges ] == 1 } {
		set allowed_range [ lindex $allowed_ranges 0 ]
		set is_range_format [ regexp {^([0-9.]+):([0-9.]+)$} $allowed_range m min max ]
		if { $is_range_format } {
			return [ expr $value >= $min && $value <= $max ]
		} else {
			return [ expr $value == $allowed_range ]
		}
	} else {
		foreach allowed_range $allowed_ranges {
			set is_range_format [ regexp {^([0-9.]+):([0-9.]+)$} $allowed_range m index label ]
			if { $is_range_format } {
				if { $value == $index } {
					return 1
				}
			} else {
				if { $value == $allowed_range } {
					return 1
				}
			}
		}
		return 0
	}	
}

proc solve_peripheral_pll { } {
	
	set periph_pll [ ::pll_model::create ]

	set periph_pll_ref_clk_hz 	[ get_periph_pll_ref_clk_hz ]

	set usb0_enabled [ expr [ string compare [ get_parameter_value "USB0_PinMuxing" ] "Unused" ] != 0 ]
	set usb1_enabled [ expr [ string compare [ get_parameter_value "USB1_PinMuxing" ] "Unused" ] != 0 ]
	set spim0_enabled [ expr [ string compare [ get_parameter_value "SPIM0_PinMuxing" ] "Unused" ] != 0 ]
	set spim1_enabled [ expr [ string compare [ get_parameter_value "SPIM1_PinMuxing" ] "Unused" ] != 0 ]
	set can0_enabled [ expr [ string compare [ get_parameter_value "CAN0_PinMuxing" ] "Unused" ] != 0 ]
	set can1_enabled [ expr [ string compare [ get_parameter_value "CAN1_PinMuxing" ] "Unused" ] != 0 ]
	set gpio_enabled [ string is true [ get_parameter_value GPIO_Pin_Used_DERIVED ] ]		
	
	# Don't solve peripheral PLL if it's input reference clock source
	# frequency cannot be determined yet, i.e. still unconnected or 
	# currently exported. Validation should report that all clocks 
	# derived from peripheral PLL cannot be determined as well.
	if { $periph_pll_ref_clk_hz > 0 } {
	
	::pll_model::set_parameter_value $periph_pll refclk $periph_pll_ref_clk_hz

	set pll_info [ get_customizable_device_pll_info ]
	set periph_pll_vco_range [ lindex $pll_info 1 ]
	::pll_model::set_parameter_property $periph_pll vcoclk range $periph_pll_vco_range
	
	set emac0_enabled [ expr [ string compare [ get_parameter_value "EMAC0_PinMuxing" ] "Unused" ] != 0 ]
	if { $emac0_enabled } {
		set desired_emac0_clk_hz [ get_parameter_value desired_emac0_clk_hz ]
		::pll_model::set_parameter_value $periph_pll desired_outclk0 $desired_emac0_clk_hz
	}
	
	set emac1_enabled [ expr [ string compare [ get_parameter_value "EMAC1_PinMuxing" ] "Unused" ] != 0 ]
	if { $emac1_enabled } {
		set desired_emac1_clk_hz [ get_parameter_value desired_emac1_clk_hz ]
		::pll_model::set_parameter_value $periph_pll desired_outclk1 $desired_emac1_clk_hz
	}
	
	set qspi_enabled [ expr [ string compare [ get_parameter_value "QSPI_PinMuxing" ] "Unused" ] != 0 ]
	if { $qspi_enabled } {
		if { [ is_clock_source_selected qspi_clk_source periph_qspi_clk_hz ] } {
			set desired_qspi_clk_hz [ get_parameter_value desired_qspi_clk_hz ]
			::pll_model::set_parameter_value $periph_pll desired_outclk2 $desired_qspi_clk_hz
		}
	}
	
	set sdmmc_clk_source ""
	set nand_clk_source ""
	set is_sdmmc_clk_source_periph_nand_sdmmc_clk 0
	set is_nand_clk_source_periph_nand_sdmmc_clk 0
	
	set sdmmc_enabled [ expr [ string compare [ get_parameter_value "SDIO_PinMuxing" ] "Unused" ] != 0 ]
	if { $sdmmc_enabled } {
		set sdmmc_clk_source [ get_selected_clock_source sdmmc_clk_source ]
		set is_sdmmc_clk_source_periph_nand_sdmmc_clk [ string equal $sdmmc_clk_source periph_nand_sdmmc_clk_hz ]		
	}

	set nand_enabled [ expr [ string compare [ get_parameter_value "NAND_PinMuxing" ] "Unused" ] != 0 ]
	if { $nand_enabled } {
		set nand_clk_source [ get_selected_clock_source nand_clk_source ]
		set is_nand_clk_source_periph_nand_sdmmc_clk [ string equal $nand_clk_source periph_nand_sdmmc_clk_hz ]
	}
	

	if { $is_sdmmc_clk_source_periph_nand_sdmmc_clk || $is_nand_clk_source_periph_nand_sdmmc_clk } {
		if { $is_sdmmc_clk_source_periph_nand_sdmmc_clk } {
			set desired_sdmmc_nand_clk_hz [ get_parameter_value desired_sdmmc_clk_hz ]
		} else {
			set desired_sdmmc_nand_clk_hz [ get_parameter_value desired_nand_clk_hz ]
		}
		::pll_model::set_parameter_value $periph_pll desired_outclk3 $desired_sdmmc_nand_clk_hz
	}
	
	#
	# Intentionally omit desired_gpio_db_clk_hz when we're computing
	# periph_pll_c4 output clock as it uses 24-bit divider instead of a handful 
	# of fixed dividers like other output clocks derived from periph_pll_c4, 
	# this makes the math solving periph_pll_c4 alot easier, at the price of 
	# not being able to achieve desired_gpio_db_clk_hz accurately which in most
	# cases should be fine.
	#
	# And once we've determined periph_pll_c4 output clock then we'll try 
	# our best to achieve desired_gpio_db_clk_hz. 
	#
	set periph_pll_c4_output_clks {}
	
	if { [ is_clock_source_selected l4_mp_clk_source periph_base_clk_hz ] } {
		lappend periph_pll_c4_output_clks desired_l4_mp_clk_hz
	}
	if { [ is_clock_source_selected l4_sp_clk_source periph_base_clk_hz ] } {
		lappend periph_pll_c4_output_clks desired_l4_sp_clk_hz
	}
	
	if { $usb0_enabled || $usb1_enabled } {
		lappend periph_pll_c4_output_clks desired_usb_mp_clk_hz	
	}
	
	if { $spim0_enabled || $spim1_enabled } {
		lappend periph_pll_c4_output_clks desired_spi_m_clk_hz
	}
	
	if { $can0_enabled } {
		lappend periph_pll_c4_output_clks desired_can0_clk_hz	
	}
	
	if { $can1_enabled } {
		lappend periph_pll_c4_output_clks desired_can1_clk_hz
	}
	
	set periph_pll_c4_output_clks_hz {}
	foreach periph_pll_c4_output_clk $periph_pll_c4_output_clks {
		lappend periph_pll_c4_output_clks_hz [ get_parameter_value $periph_pll_c4_output_clk ]
	}

	if { [ llength $periph_pll_c4_output_clks_hz ] > 0 } {
		set periph_pll_c4_output_clks_lcm [ get_lcm $periph_pll_c4_output_clks_hz ] 
		::pll_model::set_parameter_value $periph_pll desired_outclk4 $periph_pll_c4_output_clks_lcm
	} elseif { $gpio_enabled } {
		# Very very rare scenario:
		# gpio might still be enabled although it is not used for constraining c4
		# because we made a conscious discussion to exclude it in the first place
		# to make the math easier but at the price of creating this trouble now.
		# When this happens we need to constrain c4 differently, instead of using
		# calculating LCM of the desired output clocks derived from c4, we'll set
		# it to the maximum frequency allowed.
	
		set desired_gpio_db_clk_hz [ get_parameter_value desired_gpio_db_clk_hz ]
		if { $desired_gpio_db_clk_hz > 0 } {
			::pll_model::set_parameter_value $periph_pll desired_outclk4 200000000
		}
	} else {
		# No peripherals enabled? This is very rare but still possible,
	}
	
	if { [ string is true [ get_parameter_value S2FCLK_USER1CLK_Enable ] ] } {
		set desired_freq [ get_parameter_value S2FCLK_USER1CLK_FREQ_HZ ]
		set desired_s2f_user1clk_freq_hz [ get_parameter_value S2FCLK_USER1CLK_FREQ_HZ ]
		::pll_model::set_parameter_value $periph_pll desired_outclk5 $desired_s2f_user1clk_freq_hz
	}
	
	}
	
	# 
	# Now that we've applied all c0-c5 desired clock frequencies as constraints
	# to the PLL model, the PLL model should be solved. 
	#
	# First we will read out the PLL m, n, c0-c5 parameters, then we'll use the  
	# actual c4 output clocks to determine the divider values 
	#
	
	set pll_m [ ::pll_model::get_parameter_value $periph_pll m ]
	set pll_n [ ::pll_model::get_parameter_value $periph_pll n ]

	set_parameter_value periph_pll_m_auto $pll_m
	set_parameter_value periph_pll_n_auto $pll_n
	set_parameter_value periph_pll_c0_auto [ ::pll_model::get_parameter_value $periph_pll c0 ]
	set_parameter_value periph_pll_c1_auto [ ::pll_model::get_parameter_value $periph_pll c1 ]
	set_parameter_value periph_pll_c2_auto [ ::pll_model::get_parameter_value $periph_pll c2 ]
	set_parameter_value periph_pll_c3_auto [ ::pll_model::get_parameter_value $periph_pll c3 ]
	set_parameter_value periph_pll_c4_auto [ ::pll_model::get_parameter_value $periph_pll c4 ]
	set_parameter_value periph_pll_c5_auto [ ::pll_model::get_parameter_value $periph_pll c5 ]
	
	set actual_outclk4 [ ::pll_model::get_parameter_value $periph_pll desired_outclk4 ]
	
	if { [ is_clock_source_selected l4_mp_clk_source periph_base_clk_hz ] } {
		set l4_mp_clk_div_range { 1 2 4 8 16 } 
		set l4_mp_clk_div_index [ calculate_divider $actual_outclk4 [ get_parameter_value desired_l4_mp_clk_hz ] $l4_mp_clk_div_range ]
		set l4_mp_clk_div [ lindex $l4_mp_clk_div_range $l4_mp_clk_div_index ] 
		set_parameter_value l4_mp_clk_div_auto $l4_mp_clk_div_index
	}

	if { [ is_clock_source_selected l4_sp_clk_source periph_base_clk_hz ] } {
		set l4_sp_clk_div_range { 1 2 4 8 16 } 
		set l4_sp_clk_div_index [ calculate_divider $actual_outclk4 [ get_parameter_value desired_l4_sp_clk_hz ] $l4_sp_clk_div_range ]
		set l4_sp_clk_div [ lindex $l4_sp_clk_div_range $l4_sp_clk_div_index ] 
		set_parameter_value l4_sp_clk_div_auto $l4_sp_clk_div_index
	}

	set usb_mp_clk_div_range { 1 2 4 8 16 }
	set spi_m_clk_div_range { 1 2 4 8 16 }
	set can0_clk_div_range { 1 2 4 8 16 }
	set can1_clk_div_range { 1 2 4 8 16 }
	
	# Default divider values when peripherals are not enabled.
	# Default to largest values as the peripherals aren't
	# suppose to work.
	set usb_mp_clk_div_index 4
	set spi_m_clk_div_index 4
	set can0_clk_div_index 4
	set can1_clk_div_index 4
	set gpio_db_clk_div 16777215

	# Calculate dividers 
	if { $usb0_enabled || $usb1_enabled } {
		set usb_mp_clk_div_index [ calculate_divider $actual_outclk4 [ get_parameter_value desired_usb_mp_clk_hz ] $usb_mp_clk_div_range ]
	}
		
	if { $spim0_enabled || $spim1_enabled } {
		set spi_m_clk_div_index [ calculate_divider $actual_outclk4 [ get_parameter_value desired_spi_m_clk_hz ] $spi_m_clk_div_range ]
	}
								
	if { $can0_enabled } {
		set can0_clk_div_index [ calculate_divider $actual_outclk4 [ get_parameter_value desired_can0_clk_hz ] $can0_clk_div_range ]
	}
		
	if { $can1_enabled } {
		set can1_clk_div_index [ calculate_divider $actual_outclk4 [ get_parameter_value desired_can1_clk_hz ] $can1_clk_div_range ]
	}

	if { $gpio_enabled } {
    		set desired_gpio_db_clk_hz [ get_parameter_value desired_gpio_db_clk_hz ]
    		
    		if { $desired_gpio_db_clk_hz > 0 } {
    			set gpio_db_clk_div [ expr round(double($actual_outclk4) / $desired_gpio_db_clk_hz) - 1 ]
    			# ensure gpio_db_clk_div is always within the allowed range
    			if { $gpio_db_clk_div < 1 } {
    				set gpio_db_clk_div 1
    			}
    			if { $gpio_db_clk_div > 16777215 } {
    				set gpio_db_clk_div 16777215 
    			}
    		}
	}

	# Update auto-calculated divider  
	set_parameter_value usb_mp_clk_div_auto $usb_mp_clk_div_index
	set_parameter_value spi_m_clk_div_auto $spi_m_clk_div_index
	set_parameter_value can0_clk_div_auto $can0_clk_div_index
	set_parameter_value can1_clk_div_auto $can1_clk_div_index
	set_parameter_value gpio_db_clk_div_auto $gpio_db_clk_div
	
	send_message info "HPS peripherial PLL counter settings: n = $pll_n  m = $pll_m"
	
	dump_pll periph_pll $periph_pll
}

proc round_log2 { num } {
	return [ expr round(log($num) / log(2)) ]
}

# hw.tcl float type parameters have 6 decimal places while Tcl
# floating point is inherently double precision, this proc
# converts double precision values to single precision value
# so that we can compare them with hw.tcl float in a more
# precise manner.
proc format_6f { value } {
	# truncate digits after 6th decimal places using ceil(int) after a multiplication
	set value_6f [ expr int($value * 1000000) ]
	# re-adjust the decimal point
	return [ expr double($value_6f) / 1000000 ]
}

# given 2 numbers and a list of dividers, return the log2
# value of the divider closets to the division result
#
# range must be sorted
proc calculate_divider { num denom range } {
	
	# no result
	if { [ llength $range ] == 0 } {
		return
	}
	
	# only one result
	if { [ llength $range ] == 1 } {
		return [ round_log2 [ lindex $range 0 ] ]
	}

	# cast numerator to double to ensure result of 
	# division is double
	set result [ expr double($num) / $denom ]
	
	# check to see if it's smaller than the range we have
	set smallest [ lindex $range 0 ]
	if { $result <= $smallest } {
		return [ round_log2 $smallest ]
	}

	# or is it somewhere in between the ranges we have?  
	for { set i 0 } { $i < [ expr [ llength $range ] - 1 ] } { incr i } {
		set smaller [ lindex $range $i ]
		set bigger [ lindex $range [ expr $i + 1 ] ]
		if { $result > $smaller && $result <= $bigger } {
			set distance_to_smaller [ expr $result - $smaller ]
			set distance_to_bigger [ expr $bigger - $result ]
			if { $distance_to_smaller < $distance_to_bigger } {
				return [ round_log2 $smaller ]
			} else {
				return [ round_log2 $bigger ]
			}
		}
	}
	
	# if we reach here it means it's beyond (bigger) than the range we have
	set max [ expr [ llength $range ] - 1 ]
	set biggest [ lindex $range $max ]
	return [ round_log2 $biggest ]
}

# Calculate a list of integer dividers which divides the specified 
# base frequency such that it does not exceed the maximum allowed.
proc calculate_valid_integer_dividers { base_freq max_freq dividers } {
	set valid_dividers {}
	foreach divider $dividers {
		if { [ expr $base_freq / pow(2,$divider) <= $max_freq ] } {
			lappend valid_dividers $divider
		}
	}
	return $valid_dividers
}

proc calculate_divider_frequency_range { freq divider_ranges } {
	set ranges {}
	
	foreach divider $divider_ranges {
		set divider_value [ expr pow(2,$divider) ]
		# convert to double precision for division but 
		# truncate to 6 decimal places (single precision)
		# to be compatible with hw.tcl float parameter  
		set divided_freq [ format_6f [ expr double($freq) / $divider_value ] ]
		set range $divider:$divided_freq
		lappend ranges $range
	}
	return $ranges
}

proc dump_pll { pll_name pll } {

	set show_advanced_parameters [ get_parameter_value show_advanced_parameters ]
	if { [ string is false $show_advanced_parameters ] } {
		return
	}
	
	set vco_range [ ::pll_model::get_parameter_property $pll vcoclk range ] 
	debug_msg "$pll_name: vco_range=$vco_range"
	
	set vco_ranges_info [ ::pll_model::calculate_vco_ranges $pll ]
	set vco_range_overlap [ lindex $vco_ranges_info 0 ]
	set vco_ranges_overlapped [ lindex $vco_ranges_info 1 ]
	set vco_ranges_c0_c5 [ lindex $vco_ranges_info 2 ]

	for { set i 0 } { $i < [ llength $vco_ranges_c0_c5 ] } { incr i } {
		set vco_range_ci [ lindex $vco_ranges_c0_c5 $i ]
		debug_msg "$pll_name: vco_range_c$i=$vco_range_ci"
	}
	debug_msg "$pll_name: vco_range_overlap=$vco_range_overlap"
	debug_msg "$pll_name: vco_ranges_overlapped=$vco_ranges_overlapped"

	foreach param [ list refclk m n vcoclk ] {
		set $param [ ::pll_model::get_parameter_value $pll $param ] 
	}
	debug_msg "$pll_name: refclk=$refclk, m=$m, n=$n, vcoclk=$vcoclk"
	
	
	for { set i 0 } { $i < 6 } { incr i } {
		set ci [ ::pll_model::get_parameter_value $pll c$i ]
		set desired_outclki [ ::pll_model::get_parameter_value $pll desired_outclk$i ]
		set actual_outclki [ ::pll_model::get_parameter_value $pll actual_outclk$i ]
		debug_msg "$pll_name: desired_outclk$i=$desired_outclki, actual_outclk$i=$actual_outclki, c$i=$ci"
	}
}

proc validate_desired_clock_frequencies { } {
	
	# validate SDMMC (main PLL c4) & NAND (peripheral PLL c3) clock relationship
	set sdmmc_clk_source ""
	set nand_clk_source ""
	
	set sdmmc_enabled [ expr [ string compare [ get_parameter_value "SDIO_PinMuxing" ] "Unused" ] != 0 ]
	if { $sdmmc_enabled } {
		set sdmmc_clk_source [ get_selected_clock_source sdmmc_clk_source ]
	}

	set nand_enabled [ expr [ string compare [ get_parameter_value "NAND_PinMuxing" ] "Unused" ] != 0 ]
	if { $nand_enabled } {
		set nand_clk_source [ get_selected_clock_source nand_clk_source ]
	}

	if { $sdmmc_enabled && $nand_enabled } {
		
		set desired_sdmmc_clk_hz [ get_parameter_value desired_sdmmc_clk_hz ]
		set desired_nand_clk_hz [ get_parameter_value desired_nand_clk_hz ]
		
		if { $sdmmc_clk_source == $nand_clk_source } {
			if { $desired_sdmmc_clk_hz != $desired_nand_clk_hz } {
				set sdmmc_clk_source_name [ get_parameter_display_string sdmmc_clk_source ]
				set nand_clk_source_name [ get_parameter_display_string nand_clk_source ]
				set sdmmc_clk_mhz_name [ get_parameter_display_string desired_sdmmc_clk_mhz ]
				set nand_clk_mhz_name [ get_parameter_display_string desired_nand_clk_mhz ]
				send_message ERROR "$sdmmc_clk_mhz_name and $nand_clk_mhz_name must be equal as both $sdmmc_clk_source_name and $nand_clk_source_name are set to the same clock source"
			}
		}
	}
	
}

proc assert_desired_vs_actual_clocks { clock clock_freq_unknown mismatches_var unknowns_var } {
	
	upvar $mismatches_var mismatches
	upvar $unknowns_var unknowns
	
	set clk $clock
		if { [ llength $clk ] == 1 } {
			set desired_hz desired_${clk}_hz
			set desired_mhz desired_${clk}_mhz
			set actual_hz ${clk}_hz
			set actual_mhz ${clk}_mhz
		} elseif { [ llength $clk ] == 4 } {
			set desired_hz [ lindex $clk 0 ]
			set desired_mhz [ lindex $clk 1 ]
			set actual_hz [ lindex $clk 2 ]
			set actual_mhz [ lindex $clk 3 ]
		}

	set desired_mhz_name [ get_parameter_display_string $desired_mhz ]
	set actual_mhz_name [ get_parameter_display_string $actual_mhz ]

	if { $clock_freq_unknown } {
		if { [ get_parameter_value show_advanced_parameters ] } {
			warn_msg "$desired_mhz_name requested [ get_parameter_value $desired_mhz ] MHz, but actual clock frequency cannot be determined ($actual_mhz_name)"
		} else {
			warn_msg "$desired_mhz_name requested [ get_parameter_value $desired_mhz ] MHz, but actual clock frequency cannot be determined"				
		}
		incr unknowns
	} else {
		if { [ is_within_allowed_ranges $desired_mhz ] } {
        		if { [ get_parameter_value $desired_hz ] != [ get_parameter_value $actual_hz ] } {
        			if { [ get_parameter_value show_advanced_parameters ] } {
        				warn_msg "$desired_mhz_name requested [ get_parameter_value $desired_mhz ] MHz, but only achieved [ get_parameter_value $actual_mhz ] MHz ($actual_mhz_name)"
        			} else {
        				warn_msg "$desired_mhz_name requested [ get_parameter_value $desired_mhz ] MHz, but only achieved [ get_parameter_value $actual_mhz ] MHz"				
        			}
        			incr mismatches
        		}
		} else {
			# If the desired clock frequency is out of range, chances are
			# we won't be able to meet the specified clock frequency. 
			# Instead of us saying it's not achievable, we'll let Qsys
			# validation kick-in so that the desired clock frequency can
			# be fixed.
		}
	}
}

proc compare_desired_vs_actual_clocks { } {

	set mismatches 0
	# Number of clocks that cannot be determined as peripheral PLL 
	# input reference clock is set to f2s_periph_ref_clk which is
	# either unconnected or exported.
	set unknowns 0
	
	if { [ get_periph_pll_ref_clk_hz ] == 0 } {
		set param_display_string [ get_parameter_display_string periph_pll_source ]
		global periph_pll_source_names
		set periph_pll_source_display_name	[ lindex [ get_parameter_display_name_list $periph_pll_source_names ] [ get_parameter_value periph_pll_source ] ]
		warn_msg "$param_display_string $periph_pll_source_display_name frequency cannot be determined."
		set periph_pll_ref_clk_unknown 1
	} else {
		set periph_pll_ref_clk_unknown 0
	}
	
	if { [ get_parameter_value F2SCLK_PERIPHCLK_FREQ ] == 0 } {
		set f2h_periph_ref_clk_unknown 1
	} else {
		set f2h_periph_ref_clk_unknown 0
	}
	
	if { [ get_parameter_value use_default_mpu_clk ] } {
		assert_desired_vs_actual_clocks [ list default_mpu_clk_hz default_mpu_clk_mhz mpu_clk_hz mpu_clk_mhz ] 0 mismatches unknowns
	} else {
		assert_desired_vs_actual_clocks mpu_clk 0 mismatches unknowns
	}

	foreach clk [ list l3_mp_clk l3_sp_clk dbg_at_clk dbg_clk dbg_trace_clk ] {
		set param_desired_mhz ${clk}_div
		set param_actual_mhz ${clk}_mhz
		
		set divider_value [ get_parameter_value ${param_desired_mhz} ]
		set divider_ranges [ get_parameter_property ${param_desired_mhz} ALLOWED_RANGES ]
		set desired_mhz 0.0
		foreach divider_range $divider_ranges {
			set is_range [ regexp {^(.+):(.+)$} $divider_range match value display_name ]
			if { $is_range } {
				if { $value == $divider_value } {
					set desired_mhz $display_name
				}
			}
		}
		set actual_mhz [ get_parameter_value ${param_actual_mhz} ]
		
		if { $desired_mhz != $actual_mhz } {
			set desired_mhz_name [ get_parameter_display_string $param_desired_mhz ]
			set actual_mhz_name [ get_parameter_display_string $param_actual_mhz ]
			if { [ get_parameter_value show_advanced_parameters ] } {
				warn_msg "$desired_mhz_name requested $desired_mhz MHz, but only achieved $actual_mhz MHz ($actual_mhz_name)"
			} else {
				warn_msg "$desired_mhz_name requested $desired_mhz MHz, but only achieved $actual_mhz MHz"				
			}
			incr mismatches
		}
	}
	
	set l4_mp_clk_unknown [ expr [ is_clock_source_selected l4_mp_clk_source periph_base_clk_hz ] && $periph_pll_ref_clk_unknown ]
	assert_desired_vs_actual_clocks l4_mp_clk $l4_mp_clk_unknown mismatches unknowns
	
	set l4_sp_clk_unknown [ expr [ is_clock_source_selected l4_sp_clk_source periph_base_clk_hz ] && $periph_pll_ref_clk_unknown ]
	assert_desired_vs_actual_clocks l4_sp_clk $l4_sp_clk_unknown mismatches unknowns 
	
	assert_desired_vs_actual_clocks cfg_clk 0 mismatches unknowns 
	
	set sdmmc_enabled [ expr [ string compare [ get_parameter_value "SDIO_PinMuxing" ] "Unused" ] != 0 ]
	if { $sdmmc_enabled } {
		if { [ is_clock_source_selected sdmmc_clk_source F2SCLK_PERIPHCLK_FREQ ] } {
			set sdmmc_clk_unknown $f2h_periph_ref_clk_unknown
		} elseif { [ is_clock_source_selected sdmmc_clk_source periph_nand_sdmmc_clk_hz ] } {
			set sdmmc_clk_unknown $periph_pll_ref_clk_unknown
		} else {
			set sdmmc_clk_unknown 0
		}
		assert_desired_vs_actual_clocks sdmmc_clk $sdmmc_clk_unknown mismatches unknowns
	}

	set nand_enabled [ expr [ string compare [ get_parameter_value "NAND_PinMuxing" ] "Unused" ] != 0 ]
	if { $nand_enabled } {
		if { [ is_clock_source_selected nand_clk_source F2SCLK_PERIPHCLK_FREQ ] } {
			set nand_clk_unknown $f2h_periph_ref_clk_unknown
		} elseif { [ is_clock_source_selected nand_clk_source periph_nand_sdmmc_clk_hz ] } {
			set nand_clk_unknown $periph_pll_ref_clk_unknown
		} else {
			set nand_clk_unknown 0
		}
		# desired_nand_clk_mhz should really be desired_nand_x_clk_mhz
		# but it's too late to change it now, workaround this mismatch
		# for now.
		assert_desired_vs_actual_clocks [ list desired_nand_clk_hz desired_nand_clk_mhz nand_x_clk_hz nand_x_clk_mhz ] $nand_clk_unknown mismatches unknowns
	}
	
	set qspi_enabled [ expr [ string compare [ get_parameter_value "QSPI_PinMuxing" ] "Unused" ] != 0 ]
	if { $qspi_enabled } {
		if { [ is_clock_source_selected qspi_clk_source F2SCLK_PERIPHCLK_FREQ ] } {
			set qspi_clk_unknown $f2h_periph_ref_clk_unknown
		} elseif { [ is_clock_source_selected qspi_clk_source periph_qspi_clk_hz ] } {
			set qspi_clk_unknown $periph_pll_ref_clk_unknown
		} else {
			set qspi_clk_unknown 0
		}
		assert_desired_vs_actual_clocks qspi_clk $qspi_clk_unknown mismatches unknowns
	}

	set emac0_enabled [ expr [ string compare [ get_parameter_value "EMAC0_PinMuxing" ] "Unused" ] != 0 ]
	if { $emac0_enabled } {
		assert_desired_vs_actual_clocks emac0_clk $periph_pll_ref_clk_unknown mismatches unknowns 
	}
	
	set emac1_enabled [ expr [ string compare [ get_parameter_value "EMAC1_PinMuxing" ] "Unused" ] != 0 ]
	if { $emac1_enabled } {
		assert_desired_vs_actual_clocks emac1_clk $periph_pll_ref_clk_unknown mismatches unknowns 
	}

	set usb0_enabled [ expr [ string compare [ get_parameter_value "USB0_PinMuxing" ] "Unused" ] != 0 ]
	set usb1_enabled [ expr [ string compare [ get_parameter_value "USB1_PinMuxing" ] "Unused" ] != 0 ]
	if { $usb0_enabled || $usb1_enabled } {
		assert_desired_vs_actual_clocks usb_mp_clk $periph_pll_ref_clk_unknown mismatches unknowns 
	}

	set spim0_enabled [ expr [ string compare [ get_parameter_value "SPIM0_PinMuxing" ] "Unused" ] != 0 ]
	set spim1_enabled [ expr [ string compare [ get_parameter_value "SPIM1_PinMuxing" ] "Unused" ] != 0 ]
	if { $spim0_enabled || $spim1_enabled } {
		assert_desired_vs_actual_clocks spi_m_clk $periph_pll_ref_clk_unknown mismatches unknowns 
	}

	set can0_enabled [ expr [ string compare [ get_parameter_value "CAN0_PinMuxing" ] "Unused" ] != 0 ]
	if { $can0_enabled } {
		assert_desired_vs_actual_clocks can0_clk $periph_pll_ref_clk_unknown mismatches unknowns 
	}
	
	set can1_enabled [ expr [ string compare [ get_parameter_value "CAN1_PinMuxing" ] "Unused" ] != 0 ]
	if { $can1_enabled } {
		assert_desired_vs_actual_clocks can1_clk $periph_pll_ref_clk_unknown mismatches unknowns 
	}

	if { [ string is true [ get_parameter_value S2FCLK_USER1CLK_Enable ] ] } {
		assert_desired_vs_actual_clocks [ list S2FCLK_USER1CLK_FREQ_HZ S2FCLK_USER1CLK_FREQ h2f_user1_clk_hz h2f_user1_clk_mhz ] $periph_pll_ref_clk_unknown mismatches unknowns 
	}

	# GPIO is the only exception where we report mismatches in Hz instead of MHz

	set gpio_enabled [ string is true [ get_parameter_value GPIO_Pin_Used_DERIVED ] ]
	if { $gpio_enabled } {
        	set desired_hz desired_gpio_db_clk_hz
        	set actual_hz gpio_db_clk_hz
        	set desired_hz_name [ get_parameter_display_string $desired_hz ]
        	set actual_hz_name [ get_parameter_display_string $actual_hz ]
        
		if { $periph_pll_ref_clk_unknown } {
			if { [ get_parameter_value show_advanced_parameters ] } {
				warn_msg "$desired_hz_name requested [ get_parameter_value $desired_hz ] Hz, but actual clock frequency cannot be determined ($actual_hz_name)"
			} else {
				warn_msg "$desired_hz_name requested [ get_parameter_value $desired_hz ] Hz, but actual clock frequency cannot be determined"
			}
			incr unknowns
		} else { 
        	if { [ get_parameter_value $desired_hz ] != [ get_parameter_value $actual_hz ] } {
			if { [ is_within_allowed_ranges $desired_hz ] } {
                		if { [ get_parameter_value show_advanced_parameters ] } {
                			warn_msg "$desired_hz_name requested [ get_parameter_value $desired_hz ] Hz, but only achieved [ get_parameter_value $actual_hz ] Hz ($actual_hz_name)"
                		} else {
                			warn_msg "$desired_hz_name requested [ get_parameter_value $desired_hz ] Hz, but only achieved [ get_parameter_value $actual_hz ] Hz"
                		}
                		incr mismatches
			}
        	}
		}
	}
	
	if { $mismatches > 0 } {
		set configure_advanced_parameters [ get_parameter_value configure_advanced_parameters ]
		if { [ string is false $configure_advanced_parameters ] } {
			warn_msg "1 or more output clock frequencies cannot be achieved precisely, consider revising desired output clock frequencies."
		} else {
			warn_msg "1 or more output clock frequencies cannot be achieved precisely, consider revising desired output clock frequencies or Clock Manager advanced parameters."
		}
	}
	
	if { $unknowns > 0 } {
		warn_msg "1 or more output clock frequencies derived from peripheral PLL cannot be determined."		
	}
}

#
# Selecting unsupported device would return empty device pll info, 
# thereby breaking all clock manager PLL advanced parameter
# calculations, use proc tells us whether the selected device
# has valid clock manager PLL info.
#
proc is_device_pll_info_valid { } {
	if { [ get_customizable_device_pll_info ] == {} } {
		return 0
	} else {
		return 1
	}
}

# Allow customizing PLL info for testing purpose
proc get_customizable_device_pll_info { } {
	if { [ get_parameter_value customize_device_pll_info ] } {
		return [ get_parameter_value device_pll_info_manual ]
	} else {
		return [ get_device_pll_info ]
	}
}

proc get_device_pll_info { } {

	set device [ get_parameter_value device_name ]

	array set device_pll_info {} 
	set device_pll_info_file [ file join $::env(QUARTUS_ROOTDIR) .. ip altera hps altera_hps device_pll_info.txt ]
	
	set fp [ open $device_pll_info_file ]
	set content [ read $fp ]
	close $fp
	
	
	foreach line [ split $content "\n" ] {
		set is_comment [ regexp {^[\s\t]*#} $line match ]
		if { $is_comment } {
			# Ignore comments
		} else {
			set is_pll_info [ regexp {^[\s\t]*[^\s\t]+.*$} $line match ]
			if { $is_pll_info } {
				set device_name [ lindex $line 0 ]
				set device_info [ lindex $line 1 ]
				set device_pll_info($device_name) $device_info
				
				
			}
		}
	}
	

	foreach device_regexp [ array names device_pll_info ] {
		set matched [ regexp "^$device_regexp$" $device match ]
		if { $matched } {
			return $device_pll_info($device_regexp)
		}
	}
	send_message warning "We can't determine max VCO"
	# If we reach here it means that we can't determine max VCO for 
	# a device which matches the regexp. 
	
	# We should not reach here, but it can happen if new speedgrades
	# are being added without updating this Tcl proc.
	return {}
}
