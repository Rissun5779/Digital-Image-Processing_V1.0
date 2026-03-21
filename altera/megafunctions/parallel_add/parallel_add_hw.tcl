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
set_module_property   NAME         "parallel_add"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "parallel_add"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "PARALLEL_ADD"
set_module_property   EDITABLE      false
set_module_property   GROUP        "Basic Functions/Arithmetic"
set_module_property   SUPPORTED_DEVICE_FAMILIES   {"Arria 10"}
set_module_property   HIDE_FROM_QSYS true

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
#|  Creates 2 tabs: "General" and "General2"
#|
#+--------------------------------------------
add_display_item "" "General" GROUP tab
add_display_item "" "General2" GROUP tab


#+--------------------------------------------
#|
#|  General tab
#|
#+--------------------------------------------
# Tap=General, Group=Data #
add_display_item "General" "Data" GROUP

# data input width #
add_parameter           GUI_WIDTH    		positive        	8
set_parameter_property  GUI_WIDTH    		DISPLAY_NAME    	"How wide is the \'data\' input?"  
set_parameter_property  GUI_WIDTH    		DISPLAY_UNITS   	"bits"
set_parameter_property  GUI_WIDTH    		GROUP           	"Data"
set_parameter_property  GUI_WIDTH    		AFFECTS_GENERATION	true
set_parameter_property  GUI_WIDTH    		DESCRIPTION			"Specifies the width of \'data\' input."

# numbers of add #
add_parameter           GUI_SIZE    		positive        	8
set_parameter_property  GUI_SIZE    		DISPLAY_NAME    	"How many numbers will you be adding?"  
set_parameter_property  GUI_SIZE    		GROUP           	"Data"
set_parameter_property  GUI_SIZE    		AFFECTS_GENERATION	true
set_parameter_property  GUI_SIZE    		DESCRIPTION			"Specifies the numbers you will be adding."

# data input representation #
add_parameter           GUI_REPRESENTATION  string	        	"UNSIGNED"
set_parameter_property  GUI_REPRESENTATION  DISPLAY_NAME    	"Is the input signed or unsigned?"  
set_parameter_property  GUI_REPRESENTATION  GROUP           	"Data"
set_parameter_property  GUI_REPRESENTATION	ALLOWED_RANGES  	{"UNSIGNED" "SIGNED"}
set_parameter_property  GUI_REPRESENTATION	AFFECTS_GENERATION	true
set_parameter_property  GUI_REPRESENTATION	DESCRIPTION			"Specifies input's representation, signed or unsigned."

# Tap=General, Group=Result output #
add_display_item "General" "More options" GROUP

add_display_item "More options" IMPLEMENTATION_STYLE_1    TEXT   "<html>You can add a relative shift between consecutive input words.<\html>"
add_display_item "More options" IMPLEMENTATION_STYLE_2    TEXT   "<html>This can be used to add shifted partial products when implementing multipliers.<\html>"
add_display_item "More options" IMPLEMENTATION_STYLE_3    TEXT   "<html>The relative shift in bits must be uniform and less than the data width.<\html>"

# shift #
add_parameter           GUI_SHIFT		  	natural	        	0
set_parameter_property  GUI_SHIFT		  	DISPLAY_NAME    	"What is the relative shift of the data vectors?"
set_parameter_property  GUI_SHIFT		 	DISPLAY_UNITS   	"bits"
set_parameter_property  GUI_SHIFT		  	GROUP           	"More options"
set_parameter_property  GUI_SHIFT		  	AFFECTS_GENERATION	true
set_parameter_property  GUI_SHIFT		  	DESCRIPTION			"Key in the relative shift of data vectors."

add_display_item "More options" IMPLEMENTATION_STYLE_5    TEXT   "<html><\html>"
add_display_item "More options" IMPLEMENTATION_STYLE_6    TEXT   "<html>The most significant word can be subtracted rather than added.<\html>"

# add or subtract #
add_parameter           GUI_MSW_SUBTRACT	string	         	"Add"
set_parameter_property  GUI_MSW_SUBTRACT	DISPLAY_NAME    	"What operation should be performed on the most significant input word?"
set_parameter_property  GUI_MSW_SUBTRACT	GROUP           	"More options"
set_parameter_property  GUI_MSW_SUBTRACT	ALLOWED_RANGES  	{"Add" "Sub"}
set_parameter_property  GUI_MSW_SUBTRACT	AFFECTS_GENERATION	true
set_parameter_property  GUI_MSW_SUBTRACT	DISPLAY_HINT		radio
set_parameter_property  GUI_MSW_SUBTRACT	DESCRIPTION			"Selection to pipeline the function."

# Tap=General, Group=Result output #
add_display_item "General" "Result output" GROUP

# result output width #
add_parameter           GUI_CALCULATE    	string	        	"Automatically calculate the width"
set_parameter_property  GUI_CALCULATE    	DISPLAY_NAME    	"How wide is the \'result\' output?"  
set_parameter_property  GUI_CALCULATE		ALLOWED_RANGES  	{"Automatically calculate the width" "Restrict the width to"}
set_parameter_property  GUI_CALCULATE    	GROUP           	"Result output"
set_parameter_property  GUI_CALCULATE    	AFFECTS_GENERATION	true
set_parameter_property  GUI_CALCULATE		DISPLAY_HINT		radio
set_parameter_property  GUI_CALCULATE    	DESCRIPTION			"Automatically calculate the width of the result[] output port."

# user select result output width value #
add_parameter           GUI_WIDTHR_VALUE  	positive        	11
set_parameter_property  GUI_WIDTHR_VALUE  	DISPLAY_NAME    	""
set_parameter_property  GUI_WIDTHR_VALUE 	DISPLAY_UNITS   	"bits"
set_parameter_property  GUI_WIDTHR_VALUE  	GROUP           	"Result output"
set_parameter_property  GUI_WIDTHR_VALUE  	AFFECTS_GENERATION	true
set_parameter_property  GUI_WIDTHR_VALUE  	DESCRIPTION			"Specifies the width of result[] output port."

# calculated effective result output width #
# derived param #
add_parameter           WIDTHR    			positive        	11
set_parameter_property  WIDTHR    			DISPLAY_NAME    	"Effective \'result\' width"  
set_parameter_property  WIDTHR    			DISPLAY_UNITS   	"bits"
set_parameter_property  WIDTHR    			GROUP           	"Result output"
set_parameter_property  WIDTHR    			AFFECTS_GENERATION	true
set_parameter_property  WIDTHR    			DERIVED				true
set_parameter_property  WIDTHR				VISIBLE				true
set_parameter_property  WIDTHR    			DESCRIPTION			"Displays the result width if the user sets it or it is automatically calculated."


#+--------------------------------------------
#|
#|  General2 tab
#|
#+--------------------------------------------
# Tap=General2, Group=Pipeline #
add_display_item "General2" "Pipeline" GROUP

# latency #
add_parameter           GUI_USE_LATENCY		string	         	"No"
set_parameter_property  GUI_USE_LATENCY		DISPLAY_NAME    	"Do you want to pipeline the function?"
set_parameter_property  GUI_USE_LATENCY		GROUP           	"Pipeline"
set_parameter_property  GUI_USE_LATENCY		ALLOWED_RANGES  	{"No" "Yes I want output latency of"}
set_parameter_property  GUI_USE_LATENCY		AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_LATENCY		DISPLAY_HINT		radio
set_parameter_property  GUI_USE_LATENCY		DESCRIPTION			"Selection to pipeline the function."

# set latency #
add_parameter           GUI_PIPELINE	  	natural	        	1
set_parameter_property  GUI_PIPELINE	  	DISPLAY_NAME    	""
set_parameter_property  GUI_PIPELINE	 	DISPLAY_UNITS   	"clock cycles"
set_parameter_property  GUI_PIPELINE	  	GROUP           	"Pipeline"
set_parameter_property  GUI_PIPELINE	  	AFFECTS_GENERATION	true
set_parameter_property  GUI_PIPELINE	  	DESCRIPTION			"Key in number of clock cycles for latency."

# clken #
add_parameter           GUI_CLKEN		    boolean         	false
set_parameter_property  GUI_CLKEN		    DISPLAY_NAME    	"Create a \'clken\' clock enable port"
set_parameter_property  GUI_CLKEN		    GROUP           	"Pipeline"
set_parameter_property  GUI_CLKEN		    AFFECTS_GENERATION	true
set_parameter_property  GUI_CLKEN			DESCRIPTION			"Creates clock enable port."

# aclr #
add_parameter           GUI_ACLR		    boolean         	false
set_parameter_property  GUI_ACLR		    DISPLAY_NAME    	"Create a \'aclr\' asynchronous clear port"
set_parameter_property  GUI_ACLR		    GROUP           	"Pipeline"
set_parameter_property  GUI_ACLR		    AFFECTS_GENERATION	true
set_parameter_property  GUI_ACLR			DESCRIPTION			"Creates asynchronous clear port."


#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------
set_module_property     ELABORATION_CALLBACK    elab

proc    elab {}  {

	# constant values for range checking #
	# GUI_SIZE valid range 2-128
	set const_parallel_add_max_size 128
	set const_parallel_add_min_size 2

	# device information #
	set device_family   [get_parameter_value   DEVICE_FAMILY]
	send_message    COMPONENT_INFO        "Targeting device family: $device_family."

	#+---------- PARAMS ----------+#
	# set range of pipeline, 1 to 9999
	set pipeline	[get_parameter_value   GUI_PIPELINE]
	if {$pipeline>9999} {
		send_message    error      "Maximum 9999 clock cycles for output latency."
	}

	# Set range of GUI_SHIFT, limits by GUI_WIDTH
	set width	[get_parameter_value   GUI_WIDTH]
	set shift	[get_parameter_value   GUI_SHIFT]
	set max_shift [expr $width-1]
	set_parameter_property  GUI_SHIFT	 ALLOWED_RANGES   0:$max_shift

	# GUI_SIZE valid range 2-128, upper limit 128
	set size    [get_parameter_value   GUI_SIZE]
	if {$size > $const_parallel_add_max_size} {
		send_message    error      "Maximum numbers to add is $const_parallel_add_max_size."
	}
	
	# GUI_SIZE valid range 2-128, lower limit 2
	if {$size<$const_parallel_add_min_size} {
		send_message    error      "There must be at least $const_parallel_add_min_size numbers to add."
	}

	# Auto calculate widthr or restrict to specific value
	set auto_cal    	[get_parameter_value   GUI_CALCULATE]
	set widthr_value    [get_parameter_value   GUI_WIDTHR_VALUE]
	if {$auto_cal == "Automatically calculate the width"} {
		# Calculate effective WIDTHR value and display it
		set ceilinglog2 [ceil_log2 $size]
		set optimal_widthr [expr $width + ($size-1)*$shift + $ceilinglog2]
		set_parameter_value  WIDTHR    $optimal_widthr
	} else {
		# Restrict the effective widthr to value
		set_parameter_value  WIDTHR    $widthr_value
	}

	# If unsigned representation, then subtract option not available
	set representation	[get_parameter_value   GUI_REPRESENTATION]
	set msw_subtract	[get_parameter_value   GUI_MSW_SUBTRACT]
	if {$representation == "UNSIGNED" &&
		$msw_subtract == "Sub"} {
		send_message    error      "Subtract operation unavailable for UNSIGNED input representation."
	}

	# Error if use GUI_USE_LATENCY and GUI_PIPELINE<1
	set use_latency	[get_parameter_value   GUI_USE_LATENCY]
	if {$use_latency == "Yes I want output latency of" &&
		$pipeline<1} {
		send_message    error      "Output latency must be greater than 0 clock cycle."
	}

	# If no specify latency, then no clken/aclr 
	set use_clken	[get_parameter_value   GUI_CLKEN]
	if {$use_latency == "No" &&
		$use_clken} {
		send_message    error      "Please select to pipeline the function if \'clken\' port is needed."
	}
	set use_aclr	[get_parameter_value   GUI_ACLR]
	if {$use_latency == "No" &&
		$use_aclr} {
		send_message    error      "Please select to pipeline the function if \'aclr\' port is needed."
	}


	#+---------- PORTS ----------+#
    #set parallel_add input interface#
    add_interface       parallel_add_input    conduit     input

    #set parallel_add output interface#
    add_interface		parallel_add_output   conduit     output
    set_interface_assignment	parallel_add_output		ui.blockdiagram.direction    output

	###Inputs###
	#data0x data1x data2x ...#
	#number of input data = $size = GUI_SIZE
	#data width = $width = GUI_WIDTH
	for {set i 0} {$i<$size} {incr i}		{
		set dataname data$i\x
		add_interface_port	parallel_add_input		$dataname   $dataname	input  $width
	}

	#clock exist only if pipeline is selected#
	#clken/aclr is available for selection, only if pipeline is selected#
	if {$use_latency == "Yes I want output latency of"} {
		add_interface_port	parallel_add_input		clock   clock	input  1
		
		if {$use_clken} {
			add_interface_port	parallel_add_input		clken   clken	input  1
		}
		if {$use_aclr} {
			add_interface_port	parallel_add_input		aclr   	aclr	input  1
		}
	}

	###Outputs###
	#result output#
	set effective_widthr    [get_parameter_value   WIDTHR]
	add_interface_port	parallel_add_output		result   result	output  $effective_widthr
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
	set params(device_family)		[get_parameter_value   DEVICE_FAMILY]
	set params(width)				[get_parameter_value   GUI_WIDTH]
	set params(size)				[get_parameter_value   GUI_SIZE]
	set params(data_rep)			[get_parameter_value   GUI_REPRESENTATION]
	set params(use_latency)			[get_parameter_value   GUI_USE_LATENCY]
	set params(pipeline)			[get_parameter_value   GUI_PIPELINE]
	set params(clken)				[get_parameter_value   GUI_CLKEN]
	set params(aclr)				[get_parameter_value   GUI_ACLR]
	set params(shift)				[get_parameter_value   GUI_SHIFT]
	set params(msw_subtract)		[get_parameter_value   GUI_MSW_SUBTRACT]
	set params(auto_cal)			[get_parameter_value   GUI_CALCULATE]
	set params(widthr_value)		[get_parameter_value   GUI_WIDTHR_VALUE]
	set params(effective_widthr)	[get_parameter_value   WIDTHR]

	set terp_fd     [open $terp_path]
	set terp_contents [read $terp_fd]
	close  $terp_fd

	array set params_terp   [make_var_wrapper params]
	set params_terp(output_name)    $output_name

	set contents            [altera_terp    $terp_contents  params_terp]
	return $contents
}


#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  To calculate ceiling log2 for positive integer
#|  This will compute ceil(log2(n))
#|
#+-------------------------------------------------------------------------------------------------------------------------

proc ceil_log2 {n} {
	set result 0
	set seeker 1
	# for all interations seeker = 2^result
	for {} {$seeker<$n} {incr result} {
		set seeker [expr {$seeker<<1}]
	}
	return $result
}

#+----------------------------------------------------------------------------------------------------------------------------




## Add documentation links for user guide and/or release notes
add_documentation_link "Data Sheet" http://www.altera.com/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "User Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
