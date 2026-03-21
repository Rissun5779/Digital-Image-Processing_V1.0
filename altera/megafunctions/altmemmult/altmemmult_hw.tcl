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
package require quartus_bindir

#+-------------------------------------------
#|
#|  source files
#|
#+-------------------------------------------
source  clearbox.tcl


#+--------------------------------------------
#|
#|  module property
#|
#+--------------------------------------------
set_module_property   NAME         "altmemmult"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "altmemmult"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "ALTMEMMULT Intel FPGA IP"
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
#|  Creates 1 tab: "General"
#|
#+--------------------------------------------
add_display_item "" "General" GROUP tab


#+--------------------------------------------
#|
#|  'General' tab
#|
#+--------------------------------------------
# Tap=General, Group=Data in #
add_display_item "General" "Data in" GROUP

# data_in width #
set data_width_range [list]
for {set i 2}   {$i<=8}  {incr i}    {
    lappend     data_width_range         $i
}
lappend     data_width_range         16
lappend     data_width_range         24
lappend     data_width_range         32
add_parameter           WIDTH_D 	positive        	8
set_parameter_property  WIDTH_D 	DISPLAY_NAME    	"How wide should the \'data_in\' input bus be?"  
set_parameter_property  WIDTH_D 	DISPLAY_UNITS   	"bits"
set_parameter_property  WIDTH_D 	GROUP           	"Data in"
set_parameter_property  WIDTH_D 	ALLOWED_RANGES		$data_width_range
set_parameter_property  WIDTH_D 	AFFECTS_GENERATION	true
set_parameter_property  WIDTH_D 	DESCRIPTION			"Specifies the width of \'data_in\' input bus."

# data_in represetation, signed or unsigned #
add_parameter           DATA_REPRESENTATION		string	        	"SIGNED"
set_parameter_property  DATA_REPRESENTATION		DISPLAY_NAME    	"What is the representation of \'data_in\'?"  
set_parameter_property  DATA_REPRESENTATION		GROUP           	"Data in"
set_parameter_property  DATA_REPRESENTATION		ALLOWED_RANGES  	{"SIGNED" "UNSIGNED"}
set_parameter_property  DATA_REPRESENTATION		AFFECTS_GENERATION	true
set_parameter_property  DATA_REPRESENTATION		DESCRIPTION			"Specifies representation of \'data_in\', signed or unsigned."


# Tap=General, Group=Coefficient #
add_display_item "General" "Coefficient" GROUP

# coeff width #
set coeff_width_range [list]
for {set i 2}   {$i<=8}  {incr i}    {
    lappend     coeff_width_range         $i
}
lappend     coeff_width_range         16
lappend     coeff_width_range         24
add_parameter           WIDTH_C		positive        	8
set_parameter_property  WIDTH_C		DISPLAY_NAME    	"How wide should the coefficient be?"  
set_parameter_property  WIDTH_C		DISPLAY_UNITS   	"bits"
set_parameter_property  WIDTH_C		GROUP           	"Coefficient"
set_parameter_property  WIDTH_C 	ALLOWED_RANGES		$coeff_width_range
set_parameter_property  WIDTH_C		AFFECTS_GENERATION	true
set_parameter_property  WIDTH_C		DESCRIPTION			"Specifies the width of coefficient."

# coeff represetation, signed or unsigned #
add_parameter           COEFF_REPRESENTATION  	string	        	"SIGNED"
set_parameter_property  COEFF_REPRESENTATION  	DISPLAY_NAME    	"What is the representation of the coefficient?"  
set_parameter_property  COEFF_REPRESENTATION  	GROUP           	"Coefficient"
set_parameter_property  COEFF_REPRESENTATION  	ALLOWED_RANGES  	{"SIGNED" "UNSIGNED"}
set_parameter_property  COEFF_REPRESENTATION  	AFFECTS_GENERATION	true
set_parameter_property  COEFF_REPRESENTATION  	DESCRIPTION			"Specifies representation of the coefficient, signed or unsigned."

add_parameter           COEFFICIENT0	integer	        	2
set_parameter_property  COEFFICIENT0	DISPLAY_NAME    	"What is the value of the initial coefficient?"  
set_parameter_property  COEFFICIENT0	GROUP           	"Coefficient"
set_parameter_property  COEFFICIENT0	AFFECTS_GENERATION	true
set_parameter_property  COEFFICIENT0	DESCRIPTION			"Specifies the value of the initial coefficient."


# Tap=General, Group=Ports #
add_display_item "General" "Ports" GROUP

# coeff loading ports, coeff_in (follow coeff width), sload_coeff, load_done #
add_parameter           GUI_USE_COEFF_LOAD    boolean         		false
set_parameter_property  GUI_USE_COEFF_LOAD    DISPLAY_NAME    		"Create ports to allow loading coefficients"
set_parameter_property  GUI_USE_COEFF_LOAD    GROUP           		"Ports"
set_parameter_property  GUI_USE_COEFF_LOAD    AFFECTS_GENERATION	true
set_parameter_property  GUI_USE_COEFF_LOAD	  DESCRIPTION			"Creates coefficients loading ports."

# sync clear #
add_parameter           GUI_USE_SCLR	boolean					false
set_parameter_property  GUI_USE_SCLR    DISPLAY_NAME			"Create a synchronous clear input"
set_parameter_property  GUI_USE_SCLR    GROUP					"Ports"
set_parameter_property  GUI_USE_SCLR    AFFECTS_GENERATION		true
set_parameter_property  GUI_USE_SCLR	DESCRIPTION				"Creates synchronous clear input port."


# Tap=General, Group=Resource type #
add_display_item "General" "Resource type" GROUP

# RAM block type #
add_parameter           RAM_BLOCK_TYPE		string				"AUTO"
set_parameter_property  RAM_BLOCK_TYPE		DISPLAY_NAME		"What should the RAM block type be?"
set_parameter_property  RAM_BLOCK_TYPE  	GROUP           	"Resource type"
set_parameter_property  RAM_BLOCK_TYPE		ALLOWED_RANGES  	{"AUTO"}
set_parameter_property  RAM_BLOCK_TYPE  	AFFECTS_GENERATION	true
set_parameter_property  RAM_BLOCK_TYPE		DESCRIPTION			"Selects the RAM block type."


add_display_item "General" TEXT_STYLE			TEXT   "<html> <\html>"
add_display_item "General" LATENCY_TEXT_STYLE	TEXT   "<html>The megafunction will output the result 1 clock cycles after receiving input.<\html>"
add_display_item "General" PIPELINE_TEXT_STYLE	TEXT   "<html>The megafunction can accept a new input 1 clock cycles after accepting the previous one.<\html>"


#+--------------------------------------------
#|
#|  Invisible params for clearbox
#|
#+--------------------------------------------
add_parameter           CBX_AUTO_BLACKBOX   STRING              "ALL"
set_parameter_property  CBX_AUTO_BLACKBOX   DESCRIPTION         "Flag clearbox to blackbox other clearbox components or include them in the output variation file."
set_parameter_property  CBX_AUTO_BLACKBOX   VISIBLE             false
set_parameter_property  CBX_AUTO_BLACKBOX   AFFECTS_GENERATION  true

add_parameter			MAX_CLOCK_CYCLES_PER_RESULT		positive			1
set_parameter_property  MAX_CLOCK_CYCLES_PER_RESULT		DESCRIPTION			"Maximum clock cycles per result."
set_parameter_property  MAX_CLOCK_CYCLES_PER_RESULT		VISIBLE				false
set_parameter_property  MAX_CLOCK_CYCLES_PER_RESULT		AFFECTS_GENERATION  true
set_parameter_property  MAX_CLOCK_CYCLES_PER_RESULT		DERIVED				true

add_parameter			TOTAL_LATENCY		positive			1
set_parameter_property  TOTAL_LATENCY		DESCRIPTION			"Total latency."
set_parameter_property  TOTAL_LATENCY		VISIBLE				false
set_parameter_property  TOTAL_LATENCY		AFFECTS_GENERATION  true
set_parameter_property  TOTAL_LATENCY		DERIVED				true

add_parameter			WIDTH_R		positive			1
set_parameter_property  WIDTH_R		DESCRIPTION			"Summation of data_in width and coefficient width."
set_parameter_property  WIDTH_R		VISIBLE				false
set_parameter_property  WIDTH_R		AFFECTS_GENERATION  true
set_parameter_property  WIDTH_R		DERIVED				true


#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------

set_module_property     ELABORATION_CALLBACK        elab

proc   elab {}   {

	# define constant values
	set const_has_mlab {"Arria 10" "Arria II GX" "Arria II GZ" "Arria V" "Arria V GZ" "Cyclone V" "Stratix IV" "Stratix V"}
	set const_has_m9k {"Arria II GX" "Arria II GZ" "Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA" "Stratix IV"}
	set const_has_m10k {"Arria V" "Cyclone V"}
	set const_has_m20k {"Arria V GZ" "Stratix V" "Arria 10"}
	set const_width_max 512

	# device information #
    set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."

	#+---------- UI DISPLAY ----------+#
	# ram block type #
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
	if {[check_device_family_equivalence $device_family $const_has_m10k]} {
		lappend ram_block_type_range "M10K"
	}
	if {[check_device_family_equivalence $device_family $const_has_m20k]} {
		lappend ram_block_type_range "M20K"
	}
	set_parameter_property  RAM_BLOCK_TYPE    ALLOWED_RANGES  	$ram_block_type_range

	set width_d				[get_parameter_value   WIDTH_D]
	set width_c				[get_parameter_value   WIDTH_C]
	set ram_block_type		[get_parameter_value   RAM_BLOCK_TYPE]
	set use_coeeff_load		[get_parameter_value   GUI_USE_COEFF_LOAD]

	# check for latency #
	set bool_internal_latency	1
	# mimic cbx function cbx_altmemmult.cpp, altmemmult_calc_coeff
	set latency [altmemmult_calc_coeff $width_d $width_c $device_family $ram_block_type $ram_block_type_range $bool_internal_latency $use_coeeff_load]

	# check for pipeline / num_of_partial_products
	set bool_internal_latency	0
	# mimic cbx function cbx_altmemmult.cpp, altmemmult_calc_coeff
	set pipeline [altmemmult_calc_coeff $width_d $width_c $device_family $ram_block_type $ram_block_type_range $bool_internal_latency $use_coeeff_load]

	set_display_item_property	LATENCY_TEXT_STYLE	TEXT	"<html>The megafunction will output the result $latency clock cycles after receiving input.<\html>"
	set_display_item_property	PIPELINE_TEXT_STYLE	TEXT	"<html>The megafunction can accept a new input $pipeline clock cycles after accepting the previous one.<\html>"

	#+---------- PARAMS ----------+#
	# data_in width
	if {$width_d>$const_width_max} {
		send_message    error      "Width of data_in must be less than $const_width_max."
	}

	# coeff width
	if {$width_c>$const_width_max} {
		# %s width must be greater than 1 or less than %1
		send_message    error      "Width of coefficient must be less than $const_width_max."
	}

	# define range of COEFFICIENT0, based on WIDTH_C value and COEFF_REPRESENTATION
	set coeff_rep		[get_parameter_value  COEFF_REPRESENTATION]
	if {$coeff_rep == "SIGNED"} {
		set max_value [expr {1<<($width_c-1)}]
		set min_value [expr -{$max_value}]
		set_parameter_property  COEFFICIENT0	ALLOWED_RANGES	$min_value:$max_value
	} else {
		set max_value [expr {1<<$width_c}]
		set_parameter_property  COEFFICIENT0	ALLOWED_RANGES	0:$max_value
	}

	# set values into invisible params
	set	width_d_plus_width_c [expr $width_d+$width_c]
	set_parameter_value  MAX_CLOCK_CYCLES_PER_RESULT	$pipeline
	set_parameter_value  TOTAL_LATENCY					$latency
	set_parameter_value  WIDTH_R						$width_d_plus_width_c

	#+---------- PORTS ----------+#
    # set altmemmult input interface#
    add_interface       altmemmult_input    conduit     input

    # set altshift_taps output interface#
    add_interface		altmemmult_output   conduit     output
    set_interface_assignment	altmemmult_output		ui.blockdiagram.direction    output

	# inputs #
	# clock #
	add_interface_port	altmemmult_input	clock   clock	input  1

	# data_in #
	add_interface_port	altmemmult_input	data_in   data_in	input  $width_d

	# sclr #
	set use_sclr		[get_parameter_value   GUI_USE_SCLR]
	if {$use_sclr} {
		add_interface_port	altmemmult_input	sclr   sclr	input  1
	}

	# outputs #
	# result #
	add_interface_port	altmemmult_output	result   result		output  $width_d_plus_width_c

	# both inputs and output #
	if {$use_coeeff_load} {
		# coeff_in #
		add_interface_port	altmemmult_input	coeff_in   coeff_in		input  $width_c
		# sload_coeff #
		add_interface_port	altmemmult_input	sload_coeff   sload_coeff	input  1
		# load_done #
		add_interface_port	altmemmult_output	load_done   load_done		output  1
	}

	if {$pipeline>1} {
		# sload_data #
		add_interface_port	altmemmult_input	sload_data   sload_data	input  1
		# result_valid #
		add_interface_port	altmemmult_output	result_valid   result_valid		output  1
	}
}


#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Quartus synth
#|
#+-------------------------------------------------------------------------------------------------------------------------

add_fileset    quartus_synth        QUARTUS_SYNTH        do_quartus_synth

proc do_quartus_synth {output_name} {

    send_message    info    "Generating top-level entity $output_name."

    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file   [create_temp_file "parameter_list"]
    set cbx_var_file     [create_temp_file ${output_name}.v]
    set cbx_hex_file     [create_temp_file ${output_name}.hex]

    #get all parameters and ports#
    set parameters_list   [parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
    }

    set ports_list     [get_interface_ports]
    if {$ports_list eq ""}  {
        send_message error "Failure in getting interface ports, stopping synthesis fileset generation!"
    }

    # Generate clearbox parameter file
    set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
    }

    # Execute clearbox to produce a variation file
    set ip_name     [get_module_property    NAME]
    set status      [do_clearbox_gen $ip_name $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
    }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.v VERILOG PATH $cbx_var_file
    add_fileset_file ${output_name}.hex HEX PATH $cbx_hex_file

}

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Quartus simulation 
#|
#+-------------------------------------------------------------------------------------------------------------------------
add_fileset verilog_sim     SIM_VERILOG     do_quartus_synth
add_fileset vhdl_sim        SIM_VHDL        do_vhdl_sim


proc do_vhdl_sim {output_name} {
 
    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file   [create_temp_file "parameter_list"]
    set cbx_var_file     [create_temp_file ${output_name}.vhd]
    set cbx_hex_file     [create_temp_file ${output_name}.hex]

    #get all parameters and ports#
    set parameters_list   [parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
    }

    set ports_list     [get_interface_ports]
    if {$ports_list eq ""}  {
        send_message error "Failure in getting interface ports, stopping synthesis fileset generation!"
    }

    # Generate clearbox parameter file
    set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
    }

    # Execute clearbox to produce a variation file
    set ip_name     [get_module_property    NAME]
    set status      [do_clearbox_gen $ip_name $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
    }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.vhd VHDL PATH $cbx_var_file
    add_fileset_file ${output_name}.hex HEX PATH $cbx_hex_file

}           

#+----------------------------------------------------------------------------------------------------------------------------
#|
#|  Parameters and ports transfer procedure
#|
#+----------------------------------------------------------------------------------------------------------------------------

proc parameters_transfer {}   {

	set device_family   [get_parameter_value   DEVICE_FAMILY]

	# get all parameters #
	set params(CBX_AUTO_BLACKBOX)			[get_parameter_value  CBX_AUTO_BLACKBOX]
	set params(COEFF_REPRESENTATION)		[get_parameter_value  COEFF_REPRESENTATION]
	set params(COEFFICIENT0)				[get_parameter_value  COEFFICIENT0]
	set params(DATA_REPRESENTATION)			[get_parameter_value  DATA_REPRESENTATION]
	set params(DEVICE_FAMILY)				$device_family
	set params(MAX_CLOCK_CYCLES_PER_RESULT)	[get_parameter_value  MAX_CLOCK_CYCLES_PER_RESULT]
	set params(RAM_BLOCK_TYPE)				[get_parameter_value  RAM_BLOCK_TYPE]
	set params(TOTAL_LATENCY)				[get_parameter_value  TOTAL_LATENCY]
	set params(WIDTH_C)						[get_parameter_value  WIDTH_C]
	set params(WIDTH_D)						[get_parameter_value  WIDTH_D]
	set params(WIDTH_R)						[get_parameter_value  WIDTH_R]

    set parameters_list     [array get params]
    return $parameters_list
}


#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  To calculate latency and pipeline, mimic CBX function
#|
#+-------------------------------------------------------------------------------------------------------------------------

proc altmemmult_calc_coeff { width_d width_c device_family ram_block_type ram_block_type_range bool_internal_latency coeff_in_is_used } {

	set internal_latency 0
	set num_of_partial_products 0
	set ram_block_addr_width 0
	set num_of_ram_blocks 0

	# used for searching the location having best combination
	set best_location 0

	# initialize the array variables; without this the calculation will fail.
	# make them maximum or make them to produce maximum
	# calculated results if they are not used
	set width_d_plus_width_c [expr $width_d+$width_c]
	array set addr_width {
		0	1
		1	1
		2	1
		3	1
		4	1
		5	1
		6	1
		7	1
	}
	array set ram_data_width_per_block {
		0	9
		1	9
		2	9
		3	9
		4	9
		5	9
		6	9
		7	9
	}
	set partial_products_needed(0) $width_d_plus_width_c
	set partial_products_needed(1) $width_d_plus_width_c
	set partial_products_needed(2) $width_d_plus_width_c
	set partial_products_needed(3) $width_d_plus_width_c
	set partial_products_needed(4) $width_d_plus_width_c
	set partial_products_needed(5) $width_d_plus_width_c
	set partial_products_needed(6) $width_d_plus_width_c
	set partial_products_needed(7) $width_d_plus_width_c
	set ram_blocks_needed(0) $width_d_plus_width_c
	set ram_blocks_needed(1) $width_d_plus_width_c
	set ram_blocks_needed(2) $width_d_plus_width_c
	set ram_blocks_needed(3) $width_d_plus_width_c
	set ram_blocks_needed(4) $width_d_plus_width_c
	set ram_blocks_needed(5) $width_d_plus_width_c
	set ram_blocks_needed(6) $width_d_plus_width_c
	set ram_blocks_needed(7) $width_d_plus_width_c

	# change format, easier to do checking later
	foreach ram_block $ram_block_type_range {
        set family_has_ram_block_type($ram_block)  1
    }

	# Trying to decide the best RAM blocks and partial product configuration from the
	# choosen RAM type
	if {!$coeff_in_is_used} {
		if { ([string equal $ram_block_type "AUTO"] || [string equal $ram_block_type "MLAB"]) \
			&& [info exists family_has_ram_block_type(MLAB)] } {
			# QT code: ... && device_info.family_has_lutram
			for {set i 0} {$i<7} {incr i} {
				set addr_width($i) [expr 8-$i]
				set ram_data_width_per_block($i) 10
			}
		} elseif { [info exists family_has_ram_block_type(M9K)] } {
			# QT code: device_info.family_has_m8k
			for {set i 0} {$i<7} {incr i} {
				set addr_width($i) [expr 8-$i]
				set ram_data_width_per_block($i) 36
			}
			set addr_width(7) 9
			set ram_data_width_per_block(6) 18
		} elseif { [info exists family_has_ram_block_type(M20K)] } {
			# QT code: device_info.family_has_m20k
			for {set i 0} {$i<7} {incr i} {
				set addr_width($i) [expr 8-$i]
				set ram_data_width_per_block($i) 40
			}
			set addr_width(7) 9
			set ram_data_width_per_block(7) 20
		} elseif { [info exists family_has_ram_block_type(M10K)] } {
			# QT code: device_info.family_has_m10k
			for {set i 0} {$i<6} {incr i} {
				set addr_width($i) [expr 7-$i]
				set ram_data_width_per_block($i) 40
			}
			set addr_width(6) 8
			set ram_data_width_per_block(6) 20
		}
	} else {
		# COEFF_IN port is used. This is loadable coefficient. Reserve RAM block to allow updating of new coefficient.
		if { ([string equal $ram_block_type "AUTO"] || [string equal $ram_block_type "MLAB"]) \
			&& [info exists family_has_ram_block_type(MLAB)] } {
			# QT code: ... && device_info.family_has_lutram
			for {set i 0} {$i<6} {incr i} {
				set addr_width($i) [expr 7-$i]
				set ram_data_width_per_block($i) 10
			}
		} elseif { [info exists family_has_ram_block_type(M9K)] } {
			# QT code: device_info.family_has_m8k
			for {set i 0} {$i<6} {incr i} {
				set addr_width($i) [expr 7-$i]
				set ram_data_width_per_block($i) 36
			}
			set addr_width(6) 8
			set ram_data_width_per_block(6) 18
		} elseif { [info exists family_has_ram_block_type(M20K)] } {
			# QT code: device_info.family_has_m20k
			for {set i 0} {$i<7} {incr i} {
				set addr_width($i) [expr 8-$i]
				set ram_data_width_per_block($i) 40
			}
			set addr_width(7) 9
			set ram_data_width_per_block(7) 20
		} elseif { [info exists family_has_ram_block_type(M10K)] } {
			# QT code: device_info.family_has_m10k
			for {set i 0} {$i<6} {incr i} {
				set addr_width($i) [expr 7-$i]
				set ram_data_width_per_block($i) 40
			}
			set addr_width(6) 8
			set ram_data_width_per_block(6) 20
		}
	}

	set best_location 0
	for {set i 0} {$i<8} {incr i} {
		if {$addr_width($i) != 1} {
			set float_value [expr double($width_d)/double($addr_width($i))]
			set partial_products_needed($i) [expr int(ceil($float_value))]
			set float_value [expr double($width_c)+double($addr_width($i))]
			set float_value [expr $float_value/double($ram_data_width_per_block($i))]
			set ram_blocks_needed($i) [expr int(ceil($float_value))]
		}
		if {$ram_blocks_needed($i) == $ram_blocks_needed($best_location)} {
			if {$partial_products_needed($i) < $partial_products_needed($best_location)} {
				set best_location $i
			}
		} elseif {$partial_products_needed($i) == $partial_products_needed($best_location)} {
			if {$ram_blocks_needed($i) < $ram_blocks_needed($best_location)} {
				set best_location $i
			}
		} elseif {$ram_blocks_needed($i) < $ram_blocks_needed($best_location)} {
			set best_location $i
		}
	}

	set ram_block_addr_width $addr_width($best_location)
	set num_of_partial_products $partial_products_needed($best_location)
	set num_of_ram_blocks $ram_blocks_needed($best_location)

	# Figure out the internal_latency needed
	if {$width_d <= $ram_block_addr_width && $num_of_partial_products == 1} {
		set ceillog2 [ceil_log2 $num_of_partial_products]
		set internal_latency [expr int(2+$ceillog2)]
	} else {
		set internal_latency [expr int(3+$num_of_partial_products)]
	}

	# return result
	if {$bool_internal_latency} {
		# return latency
		return $internal_latency
	} else {
		# return pipeline or num_of_partial_products
		return $num_of_partial_products
	}
}

# This will compute ceil(log2(n)) #
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
#|
#|   process generate_clearbox_parameter_file and do_clearbox_gen
#|   file clearbox.tcl
#|
#+-----------------------------------------------------------------------------------------------------------------------------



## Add documentation links for user guide and/or release notes
add_documentation_link "Data Sheet" http://www.altera.com/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sam1395331197196/sam1395329539091
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
