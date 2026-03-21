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
set_module_property   NAME         "lpm_shiftreg"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "lpm_shiftreg"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "LPM_SHIFTREG"
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
#|  Creates 2 tabs: "General" and "Optional Inputs"
#|
#+--------------------------------------------
add_display_item "" "General" GROUP tab
add_display_item "" "Optional Inputs" GROUP tab


#+--------------------------------------------
#|
#|  General tab
#|
#+--------------------------------------------
# Tap=General, Group=Width #
add_display_item "General" "Width" GROUP

# data width/nBit #
add_parameter           GUI_WIDTH    		positive        	8
set_parameter_property  GUI_WIDTH    		DISPLAY_NAME    	"How wide should the \'q\' output bus be?"  
set_parameter_property  GUI_WIDTH    		DISPLAY_UNITS   	"bits"
set_parameter_property  GUI_WIDTH    		GROUP           	"Width"
set_parameter_property  GUI_WIDTH    		AFFECTS_GENERATION	true
set_parameter_property  GUI_WIDTH    		DESCRIPTION			"Specifies the width of \'q\' output bus."


# Tap=General, Group=Direction #
add_display_item "General" "Direction" GROUP

# shift direction left or right #
add_parameter           GUI_DIRECTION  		string	        	"Left"
set_parameter_property  GUI_DIRECTION  		DISPLAY_NAME    	"Which direction do you want the registers to shift?"  
set_parameter_property  GUI_DIRECTION  		GROUP           	"Direction"
set_parameter_property  GUI_DIRECTION  		ALLOWED_RANGES  	{"Left" "Right"}
set_parameter_property  GUI_DIRECTION  		AFFECTS_GENERATION	true
set_parameter_property  GUI_DIRECTION  		DESCRIPTION			"Specifies shift direction."
set_parameter_property  GUI_DIRECTION  		DISPLAY_HINT		radio


# Tap=General, Group=Which outputs do you want (select at least one)? #
add_display_item "General" "Which outputs do you want (select at least one)?" GROUP

# Outputs #
# data output #
add_parameter           GUI_USE_DATA_OUTPUT    boolean         		true
set_parameter_property  GUI_USE_DATA_OUTPUT    DISPLAY_NAME    		"Data output"
set_parameter_property  GUI_USE_DATA_OUTPUT    GROUP           		"Which outputs do you want (select at least one)?"
set_parameter_property  GUI_USE_DATA_OUTPUT    AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_DATA_OUTPUT	   DESCRIPTION			"Creates data output."

# serial shift data output #
add_parameter           GUI_USE_SERIAL_OUTPUT  boolean         		false
set_parameter_property  GUI_USE_SERIAL_OUTPUT  DISPLAY_NAME    		"Serial shift data output"
set_parameter_property  GUI_USE_SERIAL_OUTPUT  GROUP           		"Which outputs do you want (select at least one)?"
set_parameter_property  GUI_USE_SERIAL_OUTPUT  AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_SERIAL_OUTPUT  DESCRIPTION			"Creates serial shift data output."


# Tap=General, Group=Do you want any optional inputs? #
add_display_item "General" "Do you want any optional inputs?" GROUP

#Optional Inputs#
#clock enable input#
add_parameter           GUI_USE_CLKEN_INPUT     boolean         	false
set_parameter_property  GUI_USE_CLKEN_INPUT     DISPLAY_NAME    	"Clock enable input"
set_parameter_property  GUI_USE_CLKEN_INPUT     GROUP           	"Do you want any optional inputs?"
set_parameter_property  GUI_USE_CLKEN_INPUT    	AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_CLKEN_INPUT	    DESCRIPTION			"Creates clock enable input."
#serial shift data input#
add_parameter           GUI_USE_SERIAL_INPUT    boolean         	true
set_parameter_property  GUI_USE_SERIAL_INPUT    DISPLAY_NAME    	"Serial shift data input"
set_parameter_property  GUI_USE_SERIAL_INPUT    GROUP           	"Do you want any optional inputs?"
set_parameter_property  GUI_USE_SERIAL_INPUT    AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_SERIAL_INPUT	DESCRIPTION			"Creates serial shift data input."
#parallel data input#
add_parameter           GUI_USE_PARALLEL_INPUT  boolean         	false
set_parameter_property  GUI_USE_PARALLEL_INPUT  DISPLAY_NAME    	"Parallel data input (load)"
set_parameter_property  GUI_USE_PARALLEL_INPUT  GROUP           	"Do you want any optional inputs?"
set_parameter_property  GUI_USE_PARALLEL_INPUT  AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_PARALLEL_INPUT	DESCRIPTION			"Creates parallel data input."


#+--------------------------------------------
#|
#|  Optional Inputs tab
#|
#+--------------------------------------------
# Tap=Optional Inputs, Group=Do you want any optional synchronous inputs? #
add_display_item "Optional Inputs" "Synchronous inputs" GROUP

#Optional Synchronous Inputs#
#clear#
add_display_item "Synchronous inputs" IMPLEMENTATION_STYLE_1    TEXT   "<html>Do you want any optional synchronous inputs?<\html>"
add_parameter           GUI_USE_SCLR_INPUT		boolean         	false
set_parameter_property  GUI_USE_SCLR_INPUT		DISPLAY_NAME    	"Clear"
set_parameter_property  GUI_USE_SCLR_INPUT		GROUP           	"Synchronous inputs"
set_parameter_property  GUI_USE_SCLR_INPUT		AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_SCLR_INPUT		DESCRIPTION			"Creates synchronous clear input."

#set - set to all 1's#
add_parameter           GUI_USE_SSET_INPUT_1s	boolean         	false
set_parameter_property  GUI_USE_SSET_INPUT_1s	DISPLAY_NAME    	"Set - set to all 1's"
set_parameter_property  GUI_USE_SSET_INPUT_1s	GROUP           	"Synchronous inputs"
set_parameter_property  GUI_USE_SSET_INPUT_1s	AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_SSET_INPUT_1s	DESCRIPTION			"Creates synchronous set input, with value all 1's."

#set - set to value#
add_parameter           GUI_USE_SSET_INPUT		boolean         	false
set_parameter_property  GUI_USE_SSET_INPUT		DISPLAY_NAME    	"Set - set to value"
set_parameter_property  GUI_USE_SSET_INPUT		GROUP           	"Synchronous inputs"
set_parameter_property  GUI_USE_SSET_INPUT		AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_SSET_INPUT		DESCRIPTION			"Creates synchronous set input, and set to specific value."

#value, for set to value#
add_parameter           GUI_SSET_VALUE  		string	        	0
set_parameter_property  GUI_SSET_VALUE  		DISPLAY_NAME    	"     value"
set_parameter_property  GUI_SSET_VALUE  		GROUP           	"Synchronous inputs"
set_parameter_property  GUI_SSET_VALUE  		AFFECTS_GENERATION	true
set_parameter_property  GUI_SSET_VALUE  		DESCRIPTION			"Key in specific synchronous set value."


# Tap=Optional Inputs, Group=Do you want any optional asynchronous inputs? #
add_display_item "Optional Inputs" "Asynchronous inputs" GROUP

#Optional Asynchronous Inputs#
#clear#
add_display_item "Asynchronous inputs" IMPLEMENTATION_STYLE_2    TEXT   "<html>Do you want any optional asynchronous inputs?<\html>"
add_parameter           GUI_USE_ACLR_INPUT		boolean         	false
set_parameter_property  GUI_USE_ACLR_INPUT		DISPLAY_NAME    	"Clear"
set_parameter_property  GUI_USE_ACLR_INPUT		GROUP           	"Asynchronous inputs"
set_parameter_property  GUI_USE_ACLR_INPUT		AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_ACLR_INPUT		DESCRIPTION			"Creates asynchronous clear input."

#set - set to all 1's#
add_parameter           GUI_USE_ASET_INPUT_1s	boolean         	false
set_parameter_property  GUI_USE_ASET_INPUT_1s	DISPLAY_NAME    	"Set - set to all 1's"
set_parameter_property  GUI_USE_ASET_INPUT_1s	GROUP           	"Asynchronous inputs"
set_parameter_property  GUI_USE_ASET_INPUT_1s	AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_ASET_INPUT_1s	DESCRIPTION			"Creates asynchronous set input, with value all 1's."

#set - set to value#
add_parameter           GUI_USE_ASET_INPUT		boolean         	false
set_parameter_property  GUI_USE_ASET_INPUT		DISPLAY_NAME    	"Set - set to value"
set_parameter_property  GUI_USE_ASET_INPUT		GROUP           	"Asynchronous inputs"
set_parameter_property  GUI_USE_ASET_INPUT		AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_ASET_INPUT		DESCRIPTION			"Creates asynchronous set input, and set to specific value."

#value, for set to value#
add_parameter           GUI_ASET_VALUE  		string	        	0
set_parameter_property  GUI_ASET_VALUE  		DISPLAY_NAME    	"     value"
set_parameter_property  GUI_ASET_VALUE  		GROUP           	"Asynchronous inputs"
set_parameter_property  GUI_ASET_VALUE  		AFFECTS_GENERATION	true
set_parameter_property  GUI_ASET_VALUE  		DESCRIPTION			"Key in specific asynchronous set value."


#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------
set_module_property     ELABORATION_CALLBACK    elab

proc    elab {}  {

	#device information#
    set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."

	#+---------- PARAMS ----------+#
	#error if both data output and serial data output NOT checked
	set use_data_output    [get_parameter_value   GUI_USE_DATA_OUTPUT]
	set use_serial_output    [get_parameter_value   GUI_USE_SERIAL_OUTPUT]
	if {!$use_data_output && !$use_serial_output} {
		send_message    error      "Select at least one output, data output or serial shift data output."
	}

	#error if both serial shift data input and parallel data input (load) NOT checked
	set use_serial_input    [get_parameter_value   GUI_USE_SERIAL_INPUT]
	set use_parallel_input    [get_parameter_value   GUI_USE_PARALLEL_INPUT]
	if {!$use_serial_input && !$use_parallel_input} {
		send_message    error      "Select at least one data input, serial shift data input or parallel data input (load)."
	}

	#error if both sync set to all 1's and sync set to value checked
	set use_sset_input_1s    [get_parameter_value   GUI_USE_SSET_INPUT_1s]
	set use_sset_input    [get_parameter_value   GUI_USE_SSET_INPUT]
	if {$use_sset_input_1s && $use_sset_input} {
		send_message    error      "Select only one synchronous set input, either set to all 1's or set to value."
	}

	#error if both async set to all 1's and async set to value checked
	set use_aset_input_1s    [get_parameter_value   GUI_USE_ASET_INPUT_1s]
	set use_aset_input    [get_parameter_value   GUI_USE_ASET_INPUT]
	if {$use_aset_input_1s && $use_aset_input} {
		send_message    error      "Select only one asynchronous set input, either set to all 1's or set to value."
	}

	#error if sync set to value has value < 0
	set sset_value    [get_parameter_value   GUI_SSET_VALUE]
	if {$use_sset_input && $sset_value < 0} {
		send_message    error      "Illegal synchronous set value: $sset_value"
	}

	#error if async set to value has value < 0
	set aset_value    [get_parameter_value   GUI_ASET_VALUE]
	if {$use_aset_input && $aset_value < 0} {
		send_message    error      "Illegal asynchronous set value: $aset_value"
	}

	#+---------- PORTS ----------+#
    #set lpm_shiftreg input interface#
    add_interface       lpm_shiftreg_input    conduit     input

    #set lpm_shiftreg output interface#
    add_interface		lpm_shiftreg_output   conduit     output
    set_interface_assignment	lpm_shiftreg_output		ui.blockdiagram.direction    output

	###Inputs###
	#clock#
	add_interface_port	lpm_shiftreg_input		clock   clock	input  1

	#clken#
	set use_clken_input    [get_parameter_value   GUI_USE_CLKEN_INPUT]
	if {$use_clken_input} {
		add_interface_port	lpm_shiftreg_input		enable   enable	input  1
	}

	#serial shift data input#
	if {$use_serial_input} {
		add_interface_port	lpm_shiftreg_input		shiftin   shiftin	input  1
	}

	#parallel shift data input and load#
	set width    [get_parameter_value   GUI_WIDTH]
	if {$use_parallel_input && $width>0} {
		add_interface_port	lpm_shiftreg_input		load   load	input  1
		add_interface_port	lpm_shiftreg_input		data   data	input  $width
	}

	#sync clear#
	set use_sclr_input    [get_parameter_value   GUI_USE_SCLR_INPUT]
	if {$use_sclr_input} {
		add_interface_port	lpm_shiftreg_input		sclr   sclr	input  1
	}

	#sync set#
	if {$use_sset_input_1s || $use_sset_input} {
		add_interface_port	lpm_shiftreg_input		sset   sset	input  1
	}

	#async clear#
	set use_aclr_input    [get_parameter_value   GUI_USE_ACLR_INPUT]
	if {$use_aclr_input} {
		add_interface_port	lpm_shiftreg_input		aclr   aclr	input  1
	}

	#async set#
	if {$use_aset_input_1s || $use_aset_input} {
		add_interface_port	lpm_shiftreg_input		aset   aset	input  1
	}

	###Outputs###
	#q output#
	if {$use_data_output && $width>0} {
		add_interface_port	lpm_shiftreg_output		q   q	output  $width
	}

	#shiftout output#
	if {$use_serial_output} {
		add_interface_port	lpm_shiftreg_output		shiftout   shiftout	output  1
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
	set params(width)				[get_parameter_value   GUI_WIDTH]
	set params(use_clken_input)		[get_parameter_value    GUI_USE_CLKEN_INPUT]
	set params(shift_direction)		[get_parameter_value   GUI_DIRECTION]
	set params(use_sclr_input)		[get_parameter_value   GUI_USE_SCLR_INPUT]
	set params(use_aclr_input)		[get_parameter_value   GUI_USE_ACLR_INPUT]
	set params(use_data_output)		[get_parameter_value   GUI_USE_DATA_OUTPUT]
	set params(use_serial_output)	[get_parameter_value   GUI_USE_SERIAL_OUTPUT]
	set params(use_serial_input)	[get_parameter_value   GUI_USE_SERIAL_INPUT]
	set params(use_parallel_input)	[get_parameter_value   GUI_USE_PARALLEL_INPUT]
	set params(use_sset_input_1s)	[get_parameter_value   GUI_USE_SSET_INPUT_1s]
	set params(use_sset_input)		[get_parameter_value   GUI_USE_SSET_INPUT]
	set params(use_aset_input_1s)	[get_parameter_value   GUI_USE_ASET_INPUT_1s]
	set params(use_aset_input)		[get_parameter_value   GUI_USE_ASET_INPUT]
	set params(sset_value)			[get_parameter_value   GUI_SSET_VALUE]
	set params(aset_value)			[get_parameter_value   GUI_ASET_VALUE]

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
add_documentation_link "User Guide" https://documentation.altera.com/#/link//mwh1411016588444
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
