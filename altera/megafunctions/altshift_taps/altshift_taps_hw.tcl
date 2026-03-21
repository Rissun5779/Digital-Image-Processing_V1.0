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


package require -exact qsys 13.1
package require altera_terp
#+-------------------------------------------
#|
#|  source files
#|
#+-------------------------------------------
source make_var_wrapper.tcl


#+--------------------------------------------
#|
#|  module property
#|
#+--------------------------------------------
set_module_property   NAME         "altshift_taps"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "altshift_taps"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "Shift Register (RAM-based) Intel FPGA IP"
set_module_property   EDITABLE      false
set_module_property   GROUP        "Basic Functions/On Chip Memory"
set_module_property   SUPPORTED_DEVICE_FAMILIES   {"Arria 10" "Stratix 10"}
set_module_property   HIDE_FROM_QSYS true
add_documentation_link  "Data Sheet"            http://www.altera.com/literature/ug/ug_shift_register_ram_based.pdf

#+--------------------------------------------
#|
#|  device family info
#|
#+--------------------------------------------
add_parameter           DEVICE_FAMILY    STRING
set_parameter_property  DEVICE_FAMILY    DISPLAY_NAME    "Device family"
set_parameter_property  DEVICE_FAMILY    SYSTEM_INFO     {device_family}
set_parameter_property  DEVICE_FAMILY    VISIBLE         false
set_parameter_property  DEVICE_FAMILY    DESCRIPTION     "Specifies which device family is currently selected."


#+--------------------------------------------
#|
#|  'General' tab
#|
#+--------------------------------------------

#shiftin and shiftout data width#
add_parameter           GUI_WIDTH    		positive        	8
set_parameter_property  GUI_WIDTH    		DISPLAY_NAME    	"How wide should the \"shiftin\" input and the \"shiftout\" output buses be?"  
set_parameter_property  GUI_WIDTH    		DISPLAY_UNITS   	"bits"
set_parameter_property  GUI_WIDTH    		GROUP           	"General"
set_parameter_property  GUI_WIDTH    		AFFECTS_GENERATION	true
set_parameter_property  GUI_WIDTH    		DESCRIPTION			"Specifies the width of \"shiftin\" input and \"shiftout\" output buses."
# from QT, CASE:97352 - set the maximum range
set_parameter_property  GUI_WIDTH			ALLOWED_RANGES		{1:100000}

#number of taps#
add_parameter           GUI_NUMBER_OF_TAPS  positive        	32
set_parameter_property  GUI_NUMBER_OF_TAPS  DISPLAY_NAME    	"How many taps would you like?"  
set_parameter_property  GUI_NUMBER_OF_TAPS  GROUP           	"Taps"
set_parameter_property  GUI_NUMBER_OF_TAPS  AFFECTS_GENERATION	true
set_parameter_property  GUI_NUMBER_OF_TAPS  DESCRIPTION			"Specifies the number of taps."
# from QT, CASE:97352 - set the maximum range
set_parameter_property  GUI_NUMBER_OF_TAPS  ALLOWED_RANGES		{1:100000}

#group taps#
add_parameter           GUI_GROUP_TAPS      boolean         	false
set_parameter_property  GUI_GROUP_TAPS      DISPLAY_NAME    	"Create groups for each tap output"
set_parameter_property  GUI_GROUP_TAPS      GROUP           	"Taps"
set_parameter_property  GUI_GROUP_TAPS    	AFFECTS_GENERATION	true
set_parameter_property  GUI_GROUP_TAPS	    DESCRIPTION			"Groups output taps."

#tap distance#
add_parameter           GUI_TAP_DISTANCE    positive        	8
set_parameter_property  GUI_TAP_DISTANCE    DISPLAY_NAME    	"How wide should the distance between taps be?" 
set_parameter_property  GUI_TAP_DISTANCE    GROUP           	"Taps"
set_parameter_property  GUI_TAP_DISTANCE    AFFECTS_GENERATION	true
set_parameter_property  GUI_TAP_DISTANCE    DESCRIPTION			"Specifies the tap distance. Minimum 3."
# from QT, SPR:374547 - set the maximum range
set_parameter_property  GUI_TAP_DISTANCE    ALLOWED_RANGES		{3:2048}

#clock enable#
add_parameter           GUI_USE_CLKEN  		boolean         	false
set_parameter_property  GUI_USE_CLKEN  		DISPLAY_NAME    	"Create a clock enable port"
set_parameter_property  GUI_USE_CLKEN  		GROUP           	"Port"
set_parameter_property  GUI_USE_CLKEN		AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_CLKEN    	DESCRIPTION			"Clock enable port."

#async clear#
add_parameter           GUI_USE_ACLR   		boolean         	false
set_parameter_property  GUI_USE_ACLR   		DISPLAY_NAME    	"Create an asynchronous clear port"
set_parameter_property  GUI_USE_ACLR   		GROUP           	"Port"
set_parameter_property  GUI_USE_ACLR		AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_ACLR	    	DESCRIPTION		"Asynchronous clear port."

#RAM block type#
add_parameter           GUI_RAM_BLOCK_TYPE	string				"AUTO"
set_parameter_property  GUI_RAM_BLOCK_TYPE	DISPLAY_NAME		"What should the RAM block type be?"
set_parameter_property  GUI_RAM_BLOCK_TYPE  GROUP           	"Resource type"
set_parameter_property  GUI_RAM_BLOCK_TYPE	ALLOWED_RANGES  	{"AUTO"}
set_parameter_property  GUI_RAM_BLOCK_TYPE  AFFECTS_GENERATION	true
set_parameter_property  GUI_RAM_BLOCK_TYPE  DESCRIPTION			"Selects the RAM block type."

#Verification
add_parameter           GUI_TBENCH	boolean				false
set_parameter_property  GUI_TBENCH	DISPLAY_NAME		"TESTING"
set_parameter_property  GUI_TBENCH	VISIBLE  	        false
set_parameter_property  GUI_TBENCH  AFFECTS_GENERATION	true
set_parameter_property  GUI_TBENCH  DESCRIPTION			"TESTING ONLY"



#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------
set_module_property     ELABORATION_CALLBACK    elab

proc    elab {}  {

	# define constant values
	set const_has_mlab {"Arria 10" "Stratix 10" "Arria II GX" "Arria II GZ" "Arria V" "Arria V GZ" "Cyclone V" "Stratix IV" "Stratix V"}
	set const_has_m9k {"Arria II GX" "Arria II GZ" "Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA" "Stratix IV"}
	set const_has_m144k {"Arria II GZ" "Stratix IV"}
	set const_has_m10k {"Arria V" "Cyclone V"}
	set const_has_m20k {"Arria V GZ" "Stratix V" "Arria 10" "Stratix 10"}
	
	#device information#
    set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."

	#ram block type#
	# populate ram block type radio button based on selected device family
	set ram_block_type_range [list]
	# all supported families has "AUTO" type
	lappend ram_block_type_range "AUTO"
	if {[check_device_family_equivalence $device_family $const_has_mlab]} {
		lappend ram_block_type_range "MLAB"
	}
	if {[check_device_family_equivalence $device_family $const_has_m9k]} {
		lappend ram_block_type_range "M9K"
	}
	if {[check_device_family_equivalence $device_family $const_has_m144k]} {
		lappend ram_block_type_range "M144K"
	}
	if {[check_device_family_equivalence $device_family $const_has_m10k]} {
		lappend ram_block_type_range "M10K"
	}
	if {[check_device_family_equivalence $device_family $const_has_m20k]} {
		lappend ram_block_type_range "M20K"
	}
	set_parameter_property  GUI_RAM_BLOCK_TYPE    ALLOWED_RANGES  	$ram_block_type_range

	#+---------- PARAMS ----------+#
    #data width#
    set width    [get_parameter_value   GUI_WIDTH]

	#number of taps#
	set number_of_taps    [get_parameter_value   GUI_NUMBER_OF_TAPS]

	#SPR:361041
	#From QT, gray out clken when MLAB is selected or gray out MLAB if clken is selected
	set use_clken		[get_parameter_value   GUI_USE_CLKEN]
	set ram_block_type	[get_parameter_value   GUI_RAM_BLOCK_TYPE]
	#if {$use_clken && $ram_block_type=="MLAB"} {
	#	send_message    error      "Clock enable is unavailable while using $ram_block_type RAM block type."
	#}

	#+---------- PORTS ----------+#
    #set altshift_taps input interface#
    add_interface       altshift_taps_input    conduit     input

    #set altshift_taps output interface#
    add_interface		altshift_taps_output   conduit     output
    set_interface_assignment	altshift_taps_output		ui.blockdiagram.direction    output

	#aclr# #boolean#
	set use_aclr		[get_parameter_value   GUI_USE_ACLR]
	if  {$use_aclr}   {
        add_interface_port	altshift_taps_input		aclr	aclr	input   1
        }

	#clken# #boolean#
	if  {$use_clken}   {
		add_interface_port	altshift_taps_input		clken   clken	input  1
	}

	#clock# #boolean#
	add_interface_port	altshift_taps_input		clock   clock	input  1

	#shiftin#
	add_interface_port	altshift_taps_input		shiftin   shiftin	input  $width

	#shiftout#
	add_interface_port	altshift_taps_output	shiftout  shiftout	output  $width

	#taps#
	set group_taps		[get_parameter_value   GUI_GROUP_TAPS]
	if  {$group_taps && $number_of_taps>1}   {
		#group taps
		#total taps = $number_of_taps
		#each tap has width of $width
		for {set i 0} {$i<$number_of_taps} {incr i}		{
			set tapname taps$i\x
			add_interface_port	altshift_taps_output		$tapname   $tapname		output  $width
		}
	} else {
		#no group taps
		#taps = number_of_taps * width
		set tap_width [expr $number_of_taps * $width]
		add_interface_port	altshift_taps_output		taps   taps		output  $tap_width
	}
}

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Quartus synth
#|
#+-------------------------------------------------------------------------------------------------------------------------
add_fileset     quartus_synth   QUARTUS_SYNTH       do_quartus_synth

proc do_quartus_sim   {output_name}   {

	send_message    info    "Generating top-level entity $output_name."

	set file_name    ${output_name}.v

	set terp_path   params_to_v.v.terp
	set contents   [params_to_wrapper_data $terp_path $output_name]
	add_fileset_file    $file_name   VERILOG    TEXT    $contents

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Quartus simulation
#|
#+-------------------------------------------------------------------------------------------------------------------------

    set GUI_TBENCH [get_parameter_value	GUI_TBENCH]	 
    
	if {$GUI_TBENCH eq "true"} {
        source "make_var_wrapper_tb.tcl"
        set file_name_tb ${output_name}.vt
        set terp_path_tb params_to_v_tb.v.terp
        set contents_tb [params_to_wrapper_data_tb $terp_path_tb $output_name]
        
        add_fileset_file $file_name_tb VERILOG TEXT $contents_tb
	}
}   

proc do_quartus_synth   {output_name}   {

	send_message    info    "Generating top-level entity $output_name."

	set file_name    ${output_name}.v

	set terp_path   params_to_v.v.terp
	set contents   [params_to_wrapper_data $terp_path $output_name]
	add_fileset_file    $file_name   VERILOG    TEXT    $contents
} 
 
add_fileset     verilog_sim     SIM_VERILOG     do_quartus_sim
add_fileset     vhdl_sim        SIM_VHDL        do_vhdl_sim

proc do_vhdl_sim   {output_name}   {

	set file_name    ${output_name}.vhd

	set terp_path   params_to_vhd.vhd.terp
	set contents   [params_to_wrapper_data $terp_path $output_name]
	add_fileset_file    $file_name   VHDL    TEXT   $contents
 }

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Procedure: params_to_wrapper_data
#|
#|  Purpose: get hw.tcl params into an array and pass to procedure make_var_wrapper
#|
#+-------------------------------------------------------------------------------------------------------------------------

proc    params_to_wrapper_data  {terp_path output_name}  {
 
	# get hw.tcl ip parameters #
	set ports_list                  	[get_interface_ports]
    set params(port_list)           	$ports_list
	set device_family					[get_parameter_value    DEVICE_FAMILY]
	set params(intended_device_family)	\"$device_family\"
	set ram_block_type					[get_parameter_value   GUI_RAM_BLOCK_TYPE]
	set params(lpm_hint)				\"RAM_BLOCK_TYPE=$ram_block_type\"
	set params(lpm_type)				\"altshift_taps\"
	set params(number_of_taps)			[get_parameter_value    GUI_NUMBER_OF_TAPS]
	set params(tap_distance)			[get_parameter_value    GUI_TAP_DISTANCE]
	set params(width)					[get_parameter_value    GUI_WIDTH]

	set terp_fd     [open $terp_path]
	set terp_contents [read $terp_fd]
	close  $terp_fd

	array set params_terp   [make_var_wrapper params]
	set params_terp(output_name)    $output_name

	set contents            [altera_terp    $terp_contents  params_terp]
	return $contents
}

proc    params_to_wrapper_data_tb  {terp_path_tb output_name}  {
 
        # get hw.tcl ip parameters #
        # get hw.tcl ip parameters #
        set ports_list                  	[get_interface_ports]
        set params(port_list)           	$ports_list
        set device_family					[get_parameter_value    DEVICE_FAMILY]
        set params(intended_device_family)	\"$device_family\"
        set ram_block_type					[get_parameter_value   GUI_RAM_BLOCK_TYPE]
        set params(lpm_hint)				\"RAM_BLOCK_TYPE=$ram_block_type\"
        set params(lpm_type)				\"altshift_taps\"
        set params(number_of_taps)			[get_parameter_value    GUI_NUMBER_OF_TAPS]
        set params(tap_distance)			[get_parameter_value    GUI_TAP_DISTANCE]
        set params(width)					[get_parameter_value    GUI_WIDTH]

        set terp_fd_tb     [open $terp_path_tb]
        set terp_contents_tb [read $terp_fd_tb]
        close  $terp_fd_tb

        array set params_terp_tb   [make_var_wrapper_tb params]
        set params_terp_tb(output_name)    $output_name

        set contents_tb            [altera_terp    $terp_contents_tb  params_terp_tb]
        return $contents_tb
}
#+----------------------------------------------------------------------------------------------------------------------------




## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/en_US/pdfs/literature/ug/ug_shift_register_ram_based.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
