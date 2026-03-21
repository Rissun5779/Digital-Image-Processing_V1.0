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
variable MSG
array set MSG {}


#+--------------------------------------------
#|
#|  module property
#|
#+--------------------------------------------
set_module_property   NAME         "lpm_clshift"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "lpm_clshift"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "LPM_CLSHIFT"
set_module_property   EDITABLE      false
set_module_property   GROUP        "Basic Functions/Miscellaneous"
set_module_property   SUPPORTED_DEVICE_FAMILIES   {"Arria 10"}
set_module_property   HIDE_FROM_QSYS true
add_documentation_link  "Data Sheet"            http://www.altera.com/literature/catalogs/lpm.pdf

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
#|  Create tabs: "General", "General 2" and "Optional Inputs"
#|
#+--------------------------------------------
add_display_item "" "General" GROUP tab
add_display_item "" "General 2" GROUP tab
add_display_item "" "Pipeline" GROUP tab


#+--------------------------------------------
#|
#|  General tab
#|
#+--------------------------------------------
# Tap=General, Group=Direction #
add_display_item "General" "Shifting" GROUP

# shift General left or right #
add_parameter           GUI_DIRECTION  		string	        	"Logical (left and right shifts pad with 0's)"
set_parameter_property  GUI_DIRECTION  		DISPLAY_NAME    	"Which type of shifting do you wish to perform?"  
set_parameter_property  GUI_DIRECTION  		GROUP           	"Shifting"
set_parameter_property  GUI_DIRECTION  		ALLOWED_RANGES  	{"Logical (left and right shifts pad with 0's)" "Arithmetic (left shift pads with 0's and right shift pads with the sign bit)" "Rotate"}
set_parameter_property  GUI_DIRECTION  		AFFECTS_GENERATION	true
set_parameter_property  GUI_DIRECTION  		DESCRIPTION			"Specifies type of shifting."
set_parameter_property  GUI_DIRECTION  		DISPLAY_HINT		radio

add_display_item "General" "Operating Mode" GROUP
# shift General left or right #
add_parameter           GUI_OPERATING_MODE  		string	        	"Always shift left"
set_parameter_property  GUI_OPERATING_MODE  		DISPLAY_NAME    	"Which operating mode do you want for the shifter?"  
set_parameter_property  GUI_OPERATING_MODE  		GROUP           	"Operating Mode"
set_parameter_property  GUI_OPERATING_MODE  		ALLOWED_RANGES  	{"Always shift left" "Always shift right" "Create a \'direction\' input to allow me to do both (0 shifts left and 1 shifts right)"}
set_parameter_property  GUI_OPERATING_MODE  		AFFECTS_GENERATION	true
set_parameter_property  GUI_OPERATING_MODE  		DESCRIPTION			"Specifies type of shifting."
set_parameter_property  GUI_OPERATING_MODE  		DISPLAY_HINT		radio

#+--------------------------------------------
#|
#|  General 2 tab
#|
#+--------------------------------------------
# Tap=General 2
# data width/nBit #
set width_range [list 2 3 4 8 16 32 64]
add_parameter           GUI_LPM_WIDTH    		positive        	2
set_parameter_property  GUI_LPM_WIDTH    		DISPLAY_NAME    	"How wide should the \'data\' input and the \'result\' output buses be?"  
set_parameter_property  GUI_LPM_WIDTH    		DISPLAY_UNITS   	"bits"
set_parameter_property  GUI_LPM_WIDTH    		GROUP           	"General 2"
set_parameter_property  GUI_LPM_WIDTH    		AFFECTS_GENERATION	true
set_parameter_property  GUI_LPM_WIDTH           ALLOWED_RANGES      $width_range
set_parameter_property  GUI_LPM_WIDTH    		DESCRIPTION			"Specifies the width of  \'data\' input and the \'result\' output buses."

add_display_item "General 2" "Width of the \'distance\' input" GROUP
add_parameter           GUI_DISTANCE  		string	        	"Automatically calculate the width to allow the maximum possible shifting range"
set_parameter_property  GUI_DISTANCE  		DISPLAY_NAME    	"How should the width of the \'distance\' input be determined?"
set_parameter_property  GUI_DISTANCE  		GROUP           	"Width of the \'distance\' input"
set_parameter_property  GUI_DISTANCE  		ALLOWED_RANGES  	{"Automatically calculate the width to allow the maximum possible shifting range" "Restrict the width of the shifting range"}
set_parameter_property  GUI_DISTANCE  		AFFECTS_GENERATION	true
set_parameter_property  GUI_DISTANCE  		DESCRIPTION			"Enable to specify the width of the \'distance\' input"
set_parameter_property  GUI_DISTANCE  		DISPLAY_HINT		radio

add_parameter           GUI_BIT_WIDTH    positive           1	
set_parameter_property  GUI_BIT_WIDTH    DISPLAY_NAME	"Width of the shifting range "
set_parameter_property  GUI_BIT_WIDTH    DISPLAY_UNITS	"bits"
set_parameter_property  GUI_BIT_WIDTH    GROUP		"Width of the \'distance\' input"
set_parameter_property  GUI_BIT_WIDTH    AFFECTS_GENERATION  true
set_parameter_property  GUI_BIT_WIDTH    ALLOWED_RANGES      [list 1 2 3 4 5 6]
set_parameter_property  GUI_BIT_WIDTH    DESCRIPTION	"Specifies the width of the \'distance\' input"

add_display_item "General 2" "Do you want to generate any optional outputs?<br/>(Available only for logical or aritmetic shifting)" GROUP IMPLEMENTATION_STYLE_1
#set - set to all 1's#
add_parameter           GUI_OVERFLOW	boolean         	false
set_parameter_property  GUI_OVERFLOW	DISPLAY_NAME    	"Overflow"
set_parameter_property  GUI_OVERFLOW	GROUP           	"Do you want to generate any optional outputs?<br/>(Available only for logical or aritmetic shifting)"
set_parameter_property  GUI_OVERFLOW	AFFECTS_GENERATION	true
set_parameter_property  GUI_OVERFLOW	DESCRIPTION			"Generate overflow outputs"

#set - set to value#
add_parameter           GUI_UNDERFLOW		boolean         	false
set_parameter_property  GUI_UNDERFLOW		DISPLAY_NAME    	"Underflow"
set_parameter_property  GUI_UNDERFLOW		GROUP           	"Do you want to generate any optional outputs?<br/>(Available only for logical or aritmetic shifting)"
set_parameter_property  GUI_UNDERFLOW		AFFECTS_GENERATION	true
set_parameter_property  GUI_UNDERFLOW		DESCRIPTION			"Generate underflow outputs"

add_parameter           GUI_PIPELINE  		string	        	"No"
set_parameter_property  GUI_PIPELINE  		DISPLAY_NAME    	"Do you want to pipeline the function?"
set_parameter_property  GUI_PIPELINE  		GROUP           	"Pipeline"
set_parameter_property  GUI_PIPELINE  		ALLOWED_RANGES  	{"No" "Yes I want an output latency (set the latency cycles below)"}
set_parameter_property  GUI_PIPELINE  		AFFECTS_GENERATION	true
set_parameter_property  GUI_PIPELINE  		DESCRIPTION			"set the pipeline function"
set_parameter_property  GUI_PIPELINE  		DISPLAY_HINT		radio


add_display_item "Pipeline" "Latency cycles" GROUP

add_parameter           GUI_CYCLES_VALUE  		string	        	1
set_parameter_property  GUI_CYCLES_VALUE  		DISPLAY_NAME    	"     Cycles"
set_parameter_property  GUI_CYCLES_VALUE  		GROUP           	"Latency cycles"
set_parameter_property  GUI_CYCLES_VALUE  		AFFECTS_GENERATION	true
set_parameter_property  GUI_CYCLES_VALUE  		DESCRIPTION			"Key in the cycle of latency."

add_parameter           GUI_ASYNC_CLR_INPUT		boolean         	false
set_parameter_property  GUI_ASYNC_CLR_INPUT		DISPLAY_NAME    	"Create an asynchronous clear input"
set_parameter_property  GUI_ASYNC_CLR_INPUT		GROUP           	"Latency cycles"
set_parameter_property  GUI_ASYNC_CLR_INPUT		AFFECTS_GENERATION	true
set_parameter_property  GUI_ASYNC_CLR_INPUT		DESCRIPTION			"Set an asynchronous clear input."

add_parameter           GUI_CLK_ENABLE_INPUT		boolean         	false
set_parameter_property  GUI_CLK_ENABLE_INPUT		DISPLAY_NAME    	"Create a clock enable input"
set_parameter_property  GUI_CLK_ENABLE_INPUT		GROUP           	"Latency cycles"
set_parameter_property  GUI_CLK_ENABLE_INPUT		AFFECTS_GENERATION	true
set_parameter_property  GUI_CLK_ENABLE_INPUT		DESCRIPTION			"Set a clock enable input."
#+----------------------------------------------------------------------------------------------------------------------------

#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------
set_module_property     ELABORATION_CALLBACK    elab
proc    get_shifting_range {width} {
	switch -exact "$width" {
		"2" { return [list 1] }
		"3" - "4" {return [list 1 2]}
		"8" {return [list 1 2 3]}
		"16" {return [list 1 2 3 4]}
		"32" {return [list 1 2 3 4 5]}
		"64" {return [list 1 2 3 4 5 6]}
		default {send_message    error  "Invalid width setting, valid settings are 2, 3,8, 16, 32, 64"}
	}
}
proc    get_output_latency {current_bits} {
	switch -exact "$current_bits" {
		"1" { return [list 1] }
		"2" {return [list 1 2]}
		"3" {return [list 1 2 3]}
		"4" {return [list 1 2 3 4]}
		"5" {return [list 1 2 3 4 5]}
		"6" {return [list 1 2 3 4 5 6]}
		default {send_message    error  "Invalid width setting, valid settings are 1, 2, 3, 4, 5, 6"}
	}
}
proc    elab {}  {
	variable MSG
	
    #+---------- device information ----------+#
	set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."
	
	#+---------- error checking ----------+#
	#check on width
	set width    [get_parameter_value   GUI_LPM_WIDTH]
	
	#check on valid shifting range by using width
	set valid_shifting_range [get_shifting_range $width]
	
	#check on shifting range
	set shifting_range_bits [get_parameter_value   GUI_BIT_WIDTH]
	set output_latency [get_parameter_value   GUI_CYCLES_VALUE]
	set distance_type [get_parameter_value GUI_DISTANCE]
	set output_latency_range [get_output_latency $shifting_range_bits]
	if {[string equal $distance_type  "Automatically calculate the width to allow the maximum possible shifting range"]} {
		set output_latency_range  [get_output_latency [lindex $valid_shifting_range [expr [llength $valid_shifting_range] - 1]]]
	}
	# check on shift type
	set shifting_type [get_parameter_value GUI_DIRECTION]
	set str_valid_shifting_range [join $valid_shifting_range ", "]
	set str_output_latency_range [join $output_latency_range ", "]
	
	
	set is_overflow [get_parameter_value GUI_OVERFLOW]
	set is_underflow [get_parameter_value GUI_UNDERFLOW]
	
	set is_output_latency_needed [get_parameter_value GUI_PIPELINE]
	
	set is_aclr_needed [get_parameter_value GUI_ASYNC_CLR_INPUT]
	set is_clken_needed [get_parameter_value GUI_CLK_ENABLE_INPUT]
	
	# Set the Error MSG
	set MSG(INVALID_DATA_WIDTH) "In lpm_clshift megafunction, the value of WIDTH parameter is $width. It should be greater than or equal to 2."
	set MSG(INVALID_OPTIONAL_OUTPUTS) "Optional outputs available only for logical or aritmetic shifting, BUT $shifting_type is selected <BR/> <B>RESOLUTION:</B> 
		1) SELECT Logical or Arithmetic <B>Shifting</B>
		2) UNCHECK Overflow and Underflow option under General 2 -&gt <B>optional outputs</B>
		
		"
	set MSG(INVAlID_SHIFTING_RANGE) "Invalid shifting range, the range should be $str_valid_shifting_range <BR/> <B>RESOLUTION:</B> 
			1) CHANGE the width of the shifting range to $str_valid_shifting_range bits
			2) CHANGE the <B>How should the width of the \'distance\' input be determined?</B> to Automatically calculate the width to allow the maximum possible shifting range</B>
			3) ADJUST the \'data\' input and \'result\' output buses width to larger bits 			
		"
	set MSG(INVAlID_PIPELINE_LATENCY) "In lpm_clshift megafunction, the value of output latency is $output_latency. <BR/> <B>RESOLUTION:</B> 
		1) CHANGE Latency cycles under Pipeline to $str_output_latency_range Cycles
		
		"
	
	#Error message printing start here
	if {$width < 2} {
		send_message error $MSG(INVALID_DATA_WIDTH)
	} 
	if { [string equal $shifting_type "Rotate"] } {
		#if any optional output are check should error out
		if {$is_overflow|| $is_underflow} {
			send_message error $MSG(INVALID_OPTIONAL_OUTPUTS)
		}
	} 
	if { [string equal $distance_type "Restrict the width of the shifting range"] && [lsearch $valid_shifting_range $shifting_range_bits] == -1 } {
		send_message error $MSG(INVAlID_SHIFTING_RANGE)
	} 
	if { [string equal -nocase $is_output_latency_needed "Yes I want an output latency (set the latency cycles below)"] && [lsearch $output_latency_range $output_latency] == -1 } {
		send_message error $MSG(INVAlID_PIPELINE_LATENCY)
	}
	
	#+---------- PORTS ----------+#
	 #set lpm_shiftreg input interface#
    add_interface       lpm_clshift_input    conduit     input

    #set lpm_shiftreg output interface#
    add_interface		lpm_clshift_output   conduit     output
    set_interface_assignment	lpm_clshift_output		ui.blockdiagram.direction    output
	add_interface_port	lpm_clshift_input		data   data	input  $width
	add_interface_port	lpm_clshift_output		result   result	output  $width
	if {[string equal $distance_type "Restrict the width of the shifting range"]} {
		add_interface_port	lpm_clshift_input		distance   distance	input  $shifting_range_bits
	} else {
		add_interface_port	lpm_clshift_input		distance   distance	input  [lindex $valid_shifting_range [expr [llength $valid_shifting_range] - 1]]
	}
	set_port_property distance VHDL_TYPE std_logic_vector
	
	set mode [get_parameter_value   GUI_OPERATING_MODE]
	if {[string equal $mode "Create a \'direction\' input to allow me to do both (0 shifts left and 1 shifts right)"]} {
			add_interface_port	lpm_clshift_input		direction   direction	input  1
	}
	if {$is_overflow} {
		add_interface_port	lpm_clshift_output		overflow   overflow	output  1
	}
	if {$is_underflow} {
		add_interface_port	lpm_clshift_output		underflow   underflow	output  1
	}
	if {[string equal -nocase $is_output_latency_needed "Yes I want an output latency (set the latency cycles below)"]} {
		add_interface_port	lpm_clshift_input		clock   clock	input  1
		if {$is_aclr_needed} {
			add_interface_port	lpm_clshift_input		aclr   aclr	input  1
		}
		if {$is_clken_needed} {
			add_interface_port	lpm_clshift_input		clken   clken	input  1
		}
	}
}

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Quartus synth
#|
#+-------------------------------------------------------------------------------------------------------------------------
add_fileset     quartus_synth   QUARTUS_SYNTH       do_quartus_synth
proc do_quartus_synth   {output_name}   {
	send_message    info    "Generating top-level entity $output_name."
	set file_name    ${output_name}.v
	set terp_path   params_to_v.v.terp
	set contents   [params_to_wrapper_data $terp_path $output_name]
	add_fileset_file    $file_name   VERILOG    TEXT    $contents
}

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Quartus simulation
#|
#+-------------------------------------------------------------------------------------------------------------------------

add_fileset     verilog_sim     SIM_VERILOG     do_quartus_synth
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
	set ports_list					[get_interface_ports]
    set params(port_list)			[lsort -ascii $ports_list]
	set params(width)				[get_parameter_value   GUI_LPM_WIDTH]
	set params(shift_direction)		[get_parameter_value   GUI_DIRECTION]
	set params(operating_mode)		[get_parameter_value   GUI_OPERATING_MODE]
	set params(distance)		    [get_parameter_value   GUI_DISTANCE]
	if {[string equal $params(distance)  "Restrict the width of the shifting range"]} {
		set params(bit_width)		    [get_parameter_value   GUI_BIT_WIDTH]
	} else {
		set valid_shifting_range [get_shifting_range $params(width)]
		set params(bit_width) [lindex $valid_shifting_range [expr [llength $valid_shifting_range] - 1]]
	}
	set params(overflow)	        [get_parameter_value   GUI_OVERFLOW]
	set params(underflow)	        [get_parameter_value   GUI_UNDERFLOW]
	set params(cycles)	            [get_parameter_value   GUI_CYCLES_VALUE]
	set params(async_clear_input)	[get_parameter_value   GUI_ASYNC_CLR_INPUT]
	set params(clock_enable_input)	[get_parameter_value   GUI_CLK_ENABLE_INPUT]
	set params(pipeline)            [get_parameter_value GUI_PIPELINE]
	

	set terp_fd     [open $terp_path]
	set terp_contents [read $terp_fd]
	close  $terp_fd

	array set params_terp   [make_var_wrapper params]
	set params_terp(output_name)    $output_name

	set contents            [altera_terp    $terp_contents  params_terp]
	return $contents
}

#+----------------------------------------------------------------------------------------------------------------------------

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" http://quartushelp.altera.com/14.1/master.htm#mergedProjects/hdl/mega/mega_file_lpm_clshift.htm
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
