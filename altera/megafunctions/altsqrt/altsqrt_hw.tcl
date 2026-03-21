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
set_module_property   NAME         "altsqrt"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "altsqrt"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "ALTSQRT"
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
#|  Create tabs: "General", "General 2" and "Optional Inputs"
#|
#+--------------------------------------------
add_display_item "" "General" GROUP tab


#+--------------------------------------------
#|
#|  General tab
#|
#+--------------------------------------------
# shift General left or right #
add_display_item "General" "configure the \'radical\' input buses" GROUP
add_parameter           GUI_BIT_WIDTH    integer         8	
set_parameter_property  GUI_BIT_WIDTH    DISPLAY_NAME	"How wide should the \'radical\' input buses be?  "
set_parameter_property  GUI_BIT_WIDTH    DISPLAY_UNITS	"bits"
set_parameter_property  GUI_BIT_WIDTH    GROUP		"configure the \'radical\' input buses"
set_parameter_property  GUI_BIT_WIDTH    AFFECTS_GENERATION  true
set_parameter_property  GUI_BIT_WIDTH    ALLOWED_RANGES      {1:256}
set_parameter_property  GUI_BIT_WIDTH    DESCRIPTION	"Specifies the width of the \'radical\' input buses"

add_display_item "General" "Pipeline" GROUP
add_parameter           GUI_PIPELINE  		string	        	"No"
set_parameter_property  GUI_PIPELINE  		DISPLAY_NAME    	"Do you want to pipeline the function?"
set_parameter_property  GUI_PIPELINE  		GROUP           	"Pipeline"
set_parameter_property  GUI_PIPELINE  		ALLOWED_RANGES  	{"No" "Yes I want an output latency (set the latency cycles below)"}
set_parameter_property  GUI_PIPELINE  		AFFECTS_GENERATION	true
set_parameter_property  GUI_PIPELINE  		DESCRIPTION			"set the pipeline function"
set_parameter_property  GUI_PIPELINE  		DISPLAY_HINT		radio

add_display_item "General" "Latency cycles" GROUP

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
set_parameter_property  GUI_CLK_ENABLE_INPUT		DISPLAY_NAME    	"Create a clk enable input"
set_parameter_property  GUI_CLK_ENABLE_INPUT		GROUP           	"Latency cycles"
set_parameter_property  GUI_CLK_ENABLE_INPUT		AFFECTS_GENERATION	true
set_parameter_property  GUI_CLK_ENABLE_INPUT		DESCRIPTION			"Set a clk enable input."
#+----------------------------------------------------------------------------------------------------------------------------

#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------
set_module_property     ELABORATION_CALLBACK    elab
proc    get_q_width {width} {
	set max_decimal 0
	set q_width 1
	
	for {set i 0} {$i < $width} {incr i} {
		set max_decimal [expr {$max_decimal + pow(2, $i)}]
	}
	set sqrt_max_decimal [expr sqrt($max_decimal)]
	#set sqrt_max_decimal [expr floor($sqrt_max_decimal)]
	set res_sqrt_max_decimal [expr {$sqrt_max_decimal / 2}]
	while {$res_sqrt_max_decimal > 1} {
		incr q_width
		set res_sqrt_max_decimal [expr {$res_sqrt_max_decimal / 2}]
	}
	return $q_width
	#set remainder_witdh [expr {$q_witdh + 1}]
}

proc get_remainder_witdh {width} {
	return [expr {[get_q_width $width] + 1}]
}
proc    elab {}  {
	variable MSG
	
    #+---------- device information ----------+#
	set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."
	set width [get_parameter_value   GUI_BIT_WIDTH]
	set is_output_latency_needed [get_parameter_value GUI_PIPELINE]
	
	set is_aclr_needed [get_parameter_value GUI_ASYNC_CLR_INPUT]
	set is_ena_needed [get_parameter_value GUI_CLK_ENABLE_INPUT]
	
	set output_latency [get_parameter_value   GUI_CYCLES_VALUE]
	# Set the Error MSG
	set MSG(INVAlID_PIPELINE_LATENCY) "In altsqrt megafunction, the value of output latency cannot be $output_latency. <BR/> <B>RESOLUTION:</B> 
		1) CHANGE Latency cycles to integer type
		2) CHANGE Latency cycles to greater than 0
		
		"
	#Error message printing start here
	if { [string equal -nocase $is_output_latency_needed "Yes I want an output latency (set the latency cycles below)"] && (![string is integer $output_latency]  || $output_latency <= 0) } {
		send_message error $MSG(INVAlID_PIPELINE_LATENCY)
	}
	#+---------- PORTS ----------+#
	#set lpm_shiftreg input interface#
    add_interface       altsqrt_input    conduit     input
    #set lpm_shiftreg output interface#
    add_interface		altsqrt_output   conduit     output
	set_interface_assignment	altsqrt_output		ui.blockdiagram.direction    output
	
	
	set max_decimal 0
	set q_width [get_q_width $width]
	set remainder_width [expr {$q_width + 1}]
	
	add_interface_port	altsqrt_input		radical   radical	input  $width
	add_interface_port	altsqrt_output		q   q	output  $q_width
	add_interface_port	altsqrt_output		remainder   remainder	output  $remainder_width
	if {[string equal -nocase $is_output_latency_needed "Yes I want an output latency (set the latency cycles below)"]} {
		add_interface_port	altsqrt_input		clk   clk	input  1
		if {$is_aclr_needed} {
			add_interface_port	altsqrt_input		aclr   aclr	input  1
		}
		if {$is_ena_needed} {
			add_interface_port	altsqrt_input		ena   ena	input  1
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
	set params(bit_width)		    [get_parameter_value   GUI_BIT_WIDTH]
	set params(cycles)	            [get_parameter_value   GUI_CYCLES_VALUE]
	set params(async_clear_input)	[get_parameter_value   GUI_ASYNC_CLR_INPUT]
	set params(clk_enable_input)	[get_parameter_value   GUI_CLK_ENABLE_INPUT]
	set params(pipeline)            [get_parameter_value GUI_PIPELINE]
	set params(q_width) [get_q_width $params(bit_width)]
	set params(remainder_width) [expr {$params(q_width) + 1}]

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
add_documentation_link "Data Sheet" http://www.altera.com/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "User Guide" https://documentation.altera.com/#/link//sam1395329597887/sam1395331471570
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
