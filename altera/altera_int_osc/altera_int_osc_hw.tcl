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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/altera_int_osc/altera_int_osc_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1

# Source files
source ./altera_int_osc_hw_proc.tcl

# +-----------------------------------
# | module Internal Oscillator
# +-----------------------------------
set_module_property NAME altera_int_osc
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Internal Oscillator"
set_module_property DESCRIPTION "Internal Oscillator provides internal clock source for debugging purpose."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DATASHEET_URL "http://www.altera.com/literature/"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true

set supported_device_families_list {"Stratix V" "MAX 10" "Arria V GZ" "Arria V" "Arria II GX" "Arria 10" "Cyclone V" "Cyclone IV GX" "Cyclone IV E" "Cyclone 10 LP"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list

add_display_item {} "General" GROUP
add_display_item {} "Simulation" GROUP

# +-----------------------------------
# | Parameters - Parameter Settings tab
# +-----------------------------------

add_display_item "General" GUI_INFORMATION TEXT ""

#set internal display string
add_parameter INFORMATION STRING 
set_parameter_property INFORMATION DEFAULT_VALUE "The maximum output frequency is 80MHz"
set_parameter_property INFORMATION AFFECTS_ELABORATION true
set_parameter_property INFORMATION DERIVED true
set_parameter_property INFORMATION VISIBLE false

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false

add_parameter PART_NAME STRING "UNKNOWN"
set_parameter_property PART_NAME DISPLAY_NAME "Device"
set_parameter_property PART_NAME VISIBLE false
set_parameter_property PART_NAME SYSTEM_INFO {DEVICE}

# parameter for simulation model
add_parameter DEVICE_ID STRING "UNKNOWN"
set_parameter_property DEVICE_ID VISIBLE false
set_parameter_property DEVICE_ID HDL_PARAMETER false
set_parameter_property DEVICE_ID DERIVED true

add_parameter CLOCK_FREQUENCY_1 STRING "116"
set_parameter_property CLOCK_FREQUENCY_1 DISPLAY_NAME "Clock Frequency"
set_parameter_property CLOCK_FREQUENCY_1 ALLOWED_RANGES {"55" "116"}
set_parameter_property CLOCK_FREQUENCY_1 UNITS Megahertz
set_parameter_property CLOCK_FREQUENCY_1 DISPLAY_HINT ""
set_parameter_property CLOCK_FREQUENCY_1 VISIBLE false
set_parameter_property CLOCK_FREQUENCY_1 ENABLED false
set_parameter_property CLOCK_FREQUENCY_1 HDL_PARAMETER false
add_display_item "Simulation" CLOCK_FREQUENCY_1 parameter

add_parameter CLOCK_FREQUENCY_2 STRING "77"
set_parameter_property CLOCK_FREQUENCY_2 DISPLAY_NAME "Clock Frequency"
set_parameter_property CLOCK_FREQUENCY_2 ALLOWED_RANGES {"35" "77"}
set_parameter_property CLOCK_FREQUENCY_2 UNITS Megahertz
set_parameter_property CLOCK_FREQUENCY_2 DISPLAY_HINT ""
set_parameter_property CLOCK_FREQUENCY_2 VISIBLE false
set_parameter_property CLOCK_FREQUENCY_2 ENABLED false
set_parameter_property CLOCK_FREQUENCY_2 HDL_PARAMETER false
add_display_item "Simulation" CLOCK_FREQUENCY_2 parameter

add_parameter CLOCK_FREQUENCY STRING "UNKNOWN"
set_parameter_property CLOCK_FREQUENCY VISIBLE false
set_parameter_property CLOCK_FREQUENCY HDL_PARAMETER false
set_parameter_property CLOCK_FREQUENCY DERIVED true

#+--------------------------------------------
#|  clearbox auto blackbox flag
#+--------------------------------------------
add_parameter           CBX_AUTO_BLACKBOX   STRING              "ALL"
set_parameter_property  CBX_AUTO_BLACKBOX   DESCRIPTION         "Flag clearbox to blackbox other clearbox components or include them in the output variation file."
set_parameter_property  CBX_AUTO_BLACKBOX   VISIBLE             false
set_parameter_property  CBX_AUTO_BLACKBOX   AFFECTS_GENERATION  true

# +-----------------------------------
# | connection point - input
# +-----------------------------------
add_interface oscena conduit end
add_interface_port oscena oscena oscena Input 1
set_interface_assignment oscena "ui.blockdiagram.direction" INPUT
set_interface_property oscena ENABLED true

# +-----------------------------------
# | connection point - output
# +------------------------------------
add_interface clkout clock start
add_interface_port clkout clkout clk Output 1
set_interface_assignment clkout "ui.blockdiagram.direction" OUTPUT
set_interface_property clkout ENABLED true

# +-----------------------------------
# | Fileset Callbacks and Generation
# +----------------------------------- 
set_module_property ELABORATION_CALLBACK elaboration_callback

#+-------------------------------------------------------------------------------------------------------------------------
#|  Quartus synth
#+-------------------------------------------------------------------------------------------------------------------------


add_fileset           quartus_synth  QUARTUS_SYNTH   do_quartus_synth
set_fileset_property  quartus_synth  TOP_LEVEL       altera_int_osc

proc do_quartus_synth {output_name} {

	send_message    info    "Generating top-level entity $output_name."

	set get_device_family [get_parameter_value DEVICE_FAMILY]
    set get_device_id [get_parameter_value DEVICE_ID]
	
	if { $get_device_family == "MAX 10" } {
		add_fileset_file altera_int_osc.v VERILOG PATH altera_int_osc.v
		
		if { $get_device_id == "40" || $get_device_id == "50" } {
			add_fileset_file altera_int_osc.sdc SDC PATH "altera_int_osc_max10_77.sdc"
        } else {
			add_fileset_file altera_int_osc.sdc SDC PATH "altera_int_osc_max10_116.sdc"
        }
        
	} else {
		# Old families. Generated from CBX.
		do_quartus_synth_cbx altera_int_osc
		
		if { $get_device_family == "Arria 10" } {
			add_fileset_file altera_int_osc.sdc SDC PATH "altera_int_osc.sdc"
		}
	}
}

proc do_quartus_synth_cbx {output_name} {

    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file   [create_temp_file "parameter_list"]
    set cbx_var_file     [create_temp_file ${output_name}.v]

    #get all parameters and ports#
    set parameters_list   [parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
     }
    set ports_list     [ports_transfer]
    if {$ports_list eq ""}  {
        send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
     }

    # Generate clearbox parameter file
    set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
     }

    # Execute clearbox to produce a variation file
    set status      [do_clearbox_gen altint_osc $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
     }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.v VERILOG PATH $cbx_var_file
}

#+-------------------------------------------------------------------------------------------------------------------------
#|  Quartus simulation 
#+-------------------------------------------------------------------------------------------------------------------------
add_fileset           verilog_sim  SIM_VERILOG     do_quartus_synth
set_fileset_property  verilog_sim  TOP_LEVEL       altera_int_osc

add_fileset           vhdl_sim     SIM_VHDL        do_vhdl_sim
set_fileset_property  vhdl_sim     TOP_LEVEL       altera_int_osc

proc do_vhdl_sim {output_name} {

	set get_device_family [get_parameter_value DEVICE_FAMILY]

	if { $get_device_family == "MAX 10" } {
		do_vhdl_sim_encrypt_file altera_int_osc

	} else {
		# Old families. Generated from CBX.
		do_vhdl_sim_cbx altera_int_osc
	}
}

proc do_vhdl_sim_encrypt_file {output_name} {

	if {1} {
		generate_vendor_encrypt_fileset_file mentor
	}
	if {1} {
		generate_vendor_encrypt_fileset_file aldec
	}
	if {1} {
		generate_vendor_encrypt_fileset_file cadence
	}
	if {1} {
		generate_vendor_encrypt_fileset_file synopsys
	}
}

proc generate_vendor_encrypt_fileset_file { vendor } {

	set vendor_uppercase "[ string toupper $vendor ]"
	add_fileset_file ${vendor}/altera_int_osc.v		VERILOG_ENCRYPT PATH "${vendor}/altera_int_osc.v"	"${vendor_uppercase}_SPECIFIC"
}

proc do_vhdl_sim_cbx {output_name} {
 
    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file   [create_temp_file "parameter_list"]
    set cbx_var_file     [create_temp_file ${output_name}.vhd]

    #get all parameters and ports#
    set parameters_list   [parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
     }
    set ports_list     [ports_transfer]
    if {$ports_list eq ""}  {
        send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
     }

    # Generate clearbox parameter file
    set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
     }

    # Execute clearbox to produce a variation file
    set status      [do_clearbox_gen altint_osc $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
     }


     # Add the variation to the fileset
    add_fileset_file ${output_name}.vhd VHDL PATH $cbx_var_file

}           

#+----------------------------------------------------------------------------------------------------------------------------
#|  Parameters and ports transfer procedure
#+----------------------------------------------------------------------------------------------------------------------------

proc parameters_transfer {}   {

     #get all parameters#
     set param_list   [get_parameters]
     foreach param   $param_list    {
        set  param_arr($param)    [get_parameter_value  $param]
     }

     set parameters_list     [array get param_arr]
     return $parameters_list
}

proc ports_transfer {}   {

      set all_ports [get_interface_ports]
      return $all_ports
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/en_US/pdfs/literature/hb/max-10/ug_m10_clkpll.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
