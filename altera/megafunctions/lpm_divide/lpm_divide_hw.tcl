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
set_module_property   NAME         "lpm_divide"
set_module_property   AUTHOR       "Altera    Corporation"
set_module_property   DESCRIPTION  "lpm_divide"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "LPM_DIVIDE"
set_module_property   EDITABLE      false
set_module_property   GROUP        "Basic Functions/Arithmetic"
set_module_property   SUPPORTED_DEVICE_FAMILIES   {"Arria 10" "Stratix 10"}
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
#|  Creates 2 tabs: "General" and "General1"
#|
#+--------------------------------------------
add_display_item "" "General" GROUP tab
add_display_item "" "General1" GROUP tab

#+--------------------------------------------
#|
#|  General tab
#|
#+--------------------------------------------
# Tap=General, Group=Width #

# data width/nBit #
add_parameter           GUI_LPM_WIDTHn    		positive        	8
set_parameter_property  GUI_LPM_WIDTHn    		ALLOWED_RANGES		1:256
set_parameter_property  GUI_LPM_WIDTHn    		DISPLAY_NAME    	"How wide should the \'numerator\' input bus be?"  
set_parameter_property  GUI_LPM_WIDTHn    		DISPLAY_UNITS   	"bits"
set_parameter_property  GUI_LPM_WIDTHn    		GROUP           	"General"
set_parameter_property  GUI_LPM_WIDTHn    		AFFECTS_GENERATION	true
set_parameter_property  GUI_LPM_WIDTHn    		DESCRIPTION			"Specifies the width of \'numerator\' input bus."

add_parameter           GUI_LPM_WIDTHd    		positive        	8
set_parameter_property  GUI_LPM_WIDTHd    		ALLOWED_RANGES		1:256
set_parameter_property  GUI_LPM_WIDTHd    		DISPLAY_NAME    	"How wide should the \'denominator\' input bus be?"  
set_parameter_property  GUI_LPM_WIDTHd    		DISPLAY_UNITS   	"bits"
set_parameter_property  GUI_LPM_WIDTHd    		GROUP           	"General"
set_parameter_property  GUI_LPM_WIDTHd    		AFFECTS_GENERATION	true
set_parameter_property  GUI_LPM_WIDTHd    		DESCRIPTION			"Specifies the width of \'denominator\' input bus."


# Tap=General, Group=Numerator Representation #
add_display_item "General" "Numerator Representation" GROUP

add_parameter           GUI_LPM_nREPRESENTATION  		string	        	"Unsigned"
set_parameter_property  GUI_LPM_nREPRESENTATION  		DISPLAY_NAME    	"Numerator Representation"  
set_parameter_property  GUI_LPM_nREPRESENTATION  		GROUP           	"General"
set_parameter_property  GUI_LPM_nREPRESENTATION  		ALLOWED_RANGES  	{"Unsigned" "Signed"}
set_parameter_property  GUI_LPM_nREPRESENTATION  		AFFECTS_GENERATION	true
set_parameter_property  GUI_LPM_nREPRESENTATION  		DESCRIPTION			"Specifies the numerator representation, Unsigned or Signed (Two's complement)."
set_parameter_property  GUI_LPM_nREPRESENTATION  		DISPLAY_HINT		radio

# Tap=General, Group=Denominator Representation #
add_display_item "General" "Denominator Representation" GROUP
add_parameter           GUI_LPM_dREPRESENTATION  		string	        	"Unsigned"
set_parameter_property  GUI_LPM_dREPRESENTATION  		DISPLAY_NAME    	"Denominator Representation"  
set_parameter_property  GUI_LPM_dREPRESENTATION  		GROUP           	"General"
set_parameter_property  GUI_LPM_dREPRESENTATION  		ALLOWED_RANGES  	{"Unsigned" "Signed"}
set_parameter_property  GUI_LPM_dREPRESENTATION  		AFFECTS_GENERATION	true
set_parameter_property  GUI_LPM_dREPRESENTATION  		DESCRIPTION			"Specifies the denominator representation, Unsigned or Signed (Two's complement)."
set_parameter_property  GUI_LPM_dREPRESENTATION  		DISPLAY_HINT		radio

add_display_item "General1" "Pipelining" GROUP
#pipeline#
add_parameter           GUI_LPM_PIPELINE    natural        	0
set_parameter_property  GUI_LPM_PIPELINE    DISPLAY_NAME    "Output latency"
set_parameter_property  GUI_LPM_PIPELINE    GROUP           "Pipelining"
set_parameter_property  GUI_LPM_PIPELINE    DISPLAY_UNITS   "clock cycles"
set_parameter_property  GUI_LPM_PIPELINE    AFFECTS_GENERATION   true
set_parameter_property  GUI_LPM_PIPELINE    DESCRIPTION      "Specifies the output latency of pipeline (Range of allowed values: 0 - 11 or 0 - 14, deponds on implementation style)."

#aclr port#
add_parameter           GUI_USE_ACLR    boolean         false
set_parameter_property  GUI_USE_ACLR    DISPLAY_NAME    "Create an asynchronous Clear input?"
set_parameter_property  GUI_USE_ACLR    GROUP           "Pipelining"
set_parameter_property  GUI_USE_ACLR    DESCRIPTION     "Select to add the asynchronous clear port."

#clken port#
add_parameter           GUI_USE_CLKEN   boolean         false
set_parameter_property  GUI_USE_CLKEN   DISPLAY_NAME    "Create a Clock Enable input?"
set_parameter_property  GUI_USE_CLKEN   GROUP           "Pipelining"
set_parameter_property  GUI_USE_CLKEN   DESCRIPTION     "Select to add the clock enable port."

add_display_item "General1" "Optimization" GROUP
add_parameter           GUI_MAXIMIZE_SPEED  		string	        	"Default Optimization"
set_parameter_property  GUI_MAXIMIZE_SPEED  		DISPLAY_NAME    	"Which do you wish to optimize?"  
set_parameter_property  GUI_MAXIMIZE_SPEED  		GROUP           	"Optimization"
set_parameter_property  GUI_MAXIMIZE_SPEED  		ALLOWED_RANGES  	{"Default Optimization" "Area" "Speed"}
set_parameter_property  GUI_MAXIMIZE_SPEED  		AFFECTS_GENERATION	true
set_parameter_property  GUI_MAXIMIZE_SPEED  		DESCRIPTION			"Optimize the LPM_DIVIDE funtion with default Optimization Technique logic, area or speed"
set_parameter_property  GUI_MAXIMIZE_SPEED  		DISPLAY_HINT		radio

add_display_item "General1" "Remainder" GROUP
add_parameter           GUI_LPM_REMAINDERPOSITIVE  		string	        	"Yes"
set_parameter_property  GUI_LPM_REMAINDERPOSITIVE  		DISPLAY_NAME    	"Always return a positive remainder?"  
set_parameter_property  GUI_LPM_REMAINDERPOSITIVE  		GROUP           	"Remainder"
set_parameter_property  GUI_LPM_REMAINDERPOSITIVE 		ALLOWED_RANGES  	{"Yes" "No"}
set_parameter_property  GUI_LPM_REMAINDERPOSITIVE  		AFFECTS_GENERATION	true
set_parameter_property  GUI_LPM_REMAINDERPOSITIVE  		DESCRIPTION			"In order to reduce area and improve speed, Altera recomends setting this parameter to YES in operations where the remainder must be positive or where the remainder is unimportant."
set_parameter_property  GUI_LPM_REMAINDERPOSITIVE  		DISPLAY_HINT		radio

#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------
set_module_property     ELABORATION_CALLBACK    elab

proc    elab {}  {

    # Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }

	#device information#
    send_message    COMPONENT_INFO        "Targeting device family: ${params(DEVICE_FAMILY)}."


	#+---------- PARAMS ----------+#
	if {$params(GUI_LPM_PIPELINE) != 0 && ($params(GUI_LPM_PIPELINE) > $params(GUI_LPM_WIDTHn))} {
			send_message error "The value for the number of pipeline stages must be less than or equal to numerator bit width (${params(GUI_LPM_WIDTHn)})"
	}


	#+---------- PORTS ----------+#
    #set lpm_divide input interface#
    add_interface       lpm_divide_input    conduit     input

    #set lpm_divide output interface#
    add_interface		lpm_divide_output   conduit     output
    set_interface_assignment	lpm_divide_output		ui.blockdiagram.direction    output 
	
	#numer
	add_interface_port	lpm_divide_input numer numer input $params(GUI_LPM_WIDTHn)
	#quotient
	add_interface_port	lpm_divide_output quotient quotient output $params(GUI_LPM_WIDTHn)
	
	#denom
	add_interface_port	lpm_divide_input denom denom input $params(GUI_LPM_WIDTHd)
	#remain
	add_interface_port	lpm_divide_output remain remain	output $params(GUI_LPM_WIDTHd)
	
	if {$params(GUI_LPM_PIPELINE) != 0} {
		add_interface_port lpm_divide_input clock clock input 1
	}
	if {$params(GUI_USE_ACLR)} {
	
		if {$params(GUI_LPM_PIPELINE) != 0} {	
			add_interface_port lpm_divide_input aclr aclr input 1
		} else {
			send_message error "Can't use 'asynchronous clear' without using pipelining."
		}
	}
	if {$params(GUI_USE_CLKEN)} {
	
		if {$params(GUI_LPM_PIPELINE) != 0} {	
			add_interface_port lpm_divide_input clken clken input 1
		} else {
			send_message error "Can't use 'clock enabled' without using pipelining."
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
	set ports_list						[get_interface_ports]
    set params(port_list)				[lsort -ascii $ports_list]
	set params(lpm_widthn)				[get_parameter_value   GUI_LPM_WIDTHn]
	set params(lpm_widthd)				[get_parameter_value   GUI_LPM_WIDTHd]
	set params(lpm_nrepresentation)		[get_parameter_value   GUI_LPM_nREPRESENTATION]
	set params(lpm_drepresentation)		[get_parameter_value   GUI_LPM_dREPRESENTATION]
	set params(lpm_pipeline)			[get_parameter_value   GUI_LPM_PIPELINE]
	set params(use_aclr_input)			[get_parameter_value   GUI_USE_ACLR]
	set params(use_clken_input)			[get_parameter_value   GUI_USE_CLKEN]
	set params(maximize_speed)			[get_parameter_value   GUI_MAXIMIZE_SPEED]
	set params(lpm_remainderpositive)	[get_parameter_value   GUI_LPM_REMAINDERPOSITIVE]

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
add_documentation_link "User Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
