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
# | $Header: //acds/rel/18.1std/ip/altera_ufm/altera_ufm_parallel/altera_ufm_parallel_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1

# Source files
source altera_ufm_parallel_hw_proc.tcl

# +-----------------------------------
# | module UFM Parallel
# +-----------------------------------
set_module_property NAME altera_ufm_parallel
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "User Flash Memory for Parallel Interface Protocol Intel FPGA IP"
set_module_property DESCRIPTION "The Altera User Flash Memory for Parallel Interface Protocol megafunction implements user \
									non-volatile memory for MAX II/Max V devices using the parallel interface protocol."
set_module_property GROUP "Basic Functions/On Chip Memory"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_alt_ufm.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true


set supported_device_families_list {"MAX V" "MAX II"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list

add_display_item "" "General" GROUP tab
add_display_item "General" "Access mode" GROUP
add_display_item "General" "Port Settings" GROUP
add_display_item "General" "Memory content initialization" GROUP
add_display_item "General" "Simulation only options" GROUP


# +-----------------------------------
# | Device family
# +-----------------------------------
add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}


#+--------------------------------------------
#|  clearbox auto blackbox flag
#+--------------------------------------------
add_parameter           CBX_AUTO_BLACKBOX   STRING              "ALL"
set_parameter_property  CBX_AUTO_BLACKBOX   DESCRIPTION         "Flag clearbox to blackbox other clearbox components or include them in the output variation file."
set_parameter_property  CBX_AUTO_BLACKBOX   VISIBLE             false
set_parameter_property  CBX_AUTO_BLACKBOX   AFFECTS_GENERATION  true


# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------

#set access mode
add_parameter ACCESS_MODE STRING 
set_parameter_property ACCESS_MODE DEFAULT_VALUE "READ_WRITE"
set_parameter_property ACCESS_MODE DISPLAY_NAME "Access mode"
set_parameter_property ACCESS_MODE DESCRIPTION "Choose the access mode option to configure the UFM to the required mode of operation" 
set_parameter_property ACCESS_MODE TYPE STRING
set_parameter_property ACCESS_MODE DISPLAY_HINT "radio"
set_parameter_property ACCESS_MODE ALLOWED_RANGES {"READ_WRITE:Read and Write" "READ_ONLY:Read only"} 
set_parameter_property ACCESS_MODE AFFECTS_GENERATION true
set_parameter_property ACCESS_MODE AFFECTS_ELABORATION true
add_display_item "Access mode" ACCESS_MODE parameter

#set address width
add_parameter WIDTH_ADDRESS INTEGER
set_parameter_property WIDTH_ADDRESS DEFAULT_VALUE 9
set_parameter_property WIDTH_ADDRESS DISPLAY_NAME "'addr' width"
set_parameter_property WIDTH_ADDRESS DESCRIPTION "Specifies the width for the addr bus."
set_parameter_property WIDTH_ADDRESS TYPE INTEGER
set_parameter_property WIDTH_ADDRESS UNITS BITS
set_parameter_property WIDTH_ADDRESS AFFECTS_GENERATION true
set_parameter_property WIDTH_ADDRESS AFFECTS_ELABORATION true
set_parameter_property WIDTH_ADDRESS ALLOWED_RANGES {3 4 5 6 7 8 9}
add_display_item "Port Settings" WIDTH_ADDRESS parameter

#set datain width
add_parameter WIDTH_DATA INTEGER
set_parameter_property WIDTH_DATA DEFAULT_VALUE 16
set_parameter_property WIDTH_DATA DISPLAY_NAME "'datain' width"
set_parameter_property WIDTH_DATA DESCRIPTION "Specifies the width for the data bus."
set_parameter_property WIDTH_DATA TYPE INTEGER
set_parameter_property WIDTH_DATA UNITS BITS
set_parameter_property WIDTH_DATA AFFECTS_GENERATION true
set_parameter_property WIDTH_DATA AFFECTS_ELABORATION true
set_parameter_property WIDTH_DATA ALLOWED_RANGES {3 4 5 6 7 8 9 10 11 12 13 14 15 16}
add_display_item "Port Settings" WIDTH_DATA parameter  

# add 'osc' output port
add_parameter OSC_CHECK boolean 
set_parameter_property OSC_CHECK DEFAULT_VALUE 1
set_parameter_property OSC_CHECK DISPLAY_NAME "Use 'osc' output port"
set_parameter_property OSC_CHECK DESCRIPTION "Turn on this option to route the oscillator frequency to an external oscillator port."
set_parameter_property OSC_CHECK AFFECTS_GENERATION true
set_parameter_property OSC_CHECK AFFECTS_ELABORATION true
add_display_item "Port Settings" OSC_CHECK parameter

# add 'oscena' input port
add_parameter OSCENA_CHECK boolean 
set_parameter_property OSCENA_CHECK DEFAULT_VALUE 0
set_parameter_property OSCENA_CHECK DISPLAY_NAME "Use 'oscena' input port"
set_parameter_property OSCENA_CHECK DESCRIPTION "Turn on this option to enable the oscillator enable port."
set_parameter_property OSCENA_CHECK AFFECTS_GENERATION true
set_parameter_property OSCENA_CHECK AFFECTS_ELABORATION true
add_display_item "Port Settings" OSCENA_CHECK parameter

#set memory content initialization
add_parameter GUI_MEM_INIT STRING  
set_parameter_property GUI_MEM_INIT DEFAULT_VALUE "Initialize blank memory"
set_parameter_property GUI_MEM_INIT DISPLAY_NAME "Memory content initialization"
set_parameter_property GUI_MEM_INIT DESCRIPTION "Select Initialize blank memory if you do not want to specify any initialization file. Select Initialize from hex or mif file to specify the initialization file. Type the file name or browse for the required file."
set_parameter_property GUI_MEM_INIT TYPE STRING
set_parameter_property GUI_MEM_INIT DISPLAY_HINT "radio"
set_parameter_property GUI_MEM_INIT ALLOWED_RANGES {"Initialize blank memory" "Initialize from hex or mif file"} 
set_parameter_property GUI_MEM_INIT AFFECTS_ELABORATION true
add_display_item "Memory content initialization" GUI_MEM_INIT parameter

#set lpm file
add_parameter LPM_FILE STRING 
set_parameter_property LPM_FILE DEFAULT_VALUE ""
set_parameter_property LPM_FILE DISPLAY_NAME "File name"
set_parameter_property LPM_FILE DESCRIPTION "Select Initialize blank memory if you do not want to specify any initialization file. Select Initialize from hex or mif file to specify the initialization file. Type the file name or browse for the required file."
set_parameter_property LPM_FILE TYPE STRING
set_parameter_property LPM_FILE DISPLAY_HINT "file"
set_parameter_property LPM_FILE AFFECTS_GENERATION true
set_parameter_property LPM_FILE AFFECTS_ELABORATION true
add_display_item "Memory content initialization" LPM_FILE parameter

#select oscillator frequency
add_parameter GUI_OSC_FREQUENCY FLOAT
set_parameter_property GUI_OSC_FREQUENCY DEFAULT_VALUE 5.56
set_parameter_property GUI_OSC_FREQUENCY DISPLAY_NAME "Oscillator frequency"
set_parameter_property GUI_OSC_FREQUENCY DESCRIPTION "Specify the oscillator frequency for the user flash memory. This parameter is used for simulation purposes only."
set_parameter_property GUI_OSC_FREQUENCY TYPE FLOAT
set_parameter_property GUI_OSC_FREQUENCY UNITS MEGAHERTZ
set_parameter_property GUI_OSC_FREQUENCY AFFECTS_ELABORATION true
set_parameter_property GUI_OSC_FREQUENCY ALLOWED_RANGES {5.56 3.33}
add_display_item "Simulation only options" GUI_OSC_FREQUENCY parameter

#set internal oscillator frequency
add_parameter OSC_FREQUENCY INTEGER 
set_parameter_property OSC_FREQUENCY DEFAULT_VALUE 0
set_parameter_property OSC_FREQUENCY TYPE INTEGER
set_parameter_property OSC_FREQUENCY AFFECTS_GENERATION true
set_parameter_property OSC_FREQUENCY AFFECTS_ELABORATION true
set_parameter_property OSC_FREQUENCY DERIVED true
set_parameter_property OSC_FREQUENCY VISIBLE false

# *~*~* set GUI erase time *~*~*
#allowed range taken from http://www.altera.com/literature/ug/ug_alt_ufm.pdf
add_parameter GUI_ERASE_TIME INTEGER 
set_parameter_property GUI_ERASE_TIME DEFAULT_VALUE 500000
set_parameter_property GUI_ERASE_TIME DISPLAY_NAME "Erase time"
set_parameter_property GUI_ERASE_TIME DESCRIPTION "Specify the erase time in unit of ns."
set_parameter_property GUI_ERASE_TIME TYPE INTEGER
set_parameter_property GUI_ERASE_TIME UNITS NANOSECONDS
set_parameter_property GUI_ERASE_TIME ALLOWED_RANGES 1600:999999
set_parameter_property GUI_ERASE_TIME AFFECTS_ELABORATION true
add_display_item "Simulation only options" GUI_ERASE_TIME parameter

#set internal erase time
add_parameter ERASE_TIME INTEGER 
set_parameter_property ERASE_TIME DEFAULT_VALUE 500000000
set_parameter_property ERASE_TIME TYPE INTEGER
set_parameter_property ERASE_TIME AFFECTS_GENERATION true
set_parameter_property ERASE_TIME AFFECTS_ELABORATION true
set_parameter_property ERASE_TIME DERIVED true
set_parameter_property ERASE_TIME VISIBLE false

# *~*~* set GUI program time *~*~*
#allowed range taken from http://www.altera.com/literature/ug/ug_alt_ufm.pdf
add_parameter GUI_PROGRAM_TIME INTEGER 
set_parameter_property GUI_PROGRAM_TIME DEFAULT_VALUE 1600
set_parameter_property GUI_PROGRAM_TIME DISPLAY_NAME "Program time"
set_parameter_property GUI_PROGRAM_TIME DESCRIPTION "Specify the program time in unit ns."
set_parameter_property GUI_PROGRAM_TIME TYPE INTEGER
set_parameter_property GUI_PROGRAM_TIME UNITS NANOSECONDS
set_parameter_property GUI_PROGRAM_TIME ALLOWED_RANGES 1600:100000
set_parameter_property GUI_PROGRAM_TIME AFFECTS_ELABORATION true
add_display_item "Simulation only options" GUI_PROGRAM_TIME parameter

#set internal program time
add_parameter PROGRAM_TIME INTEGER 
set_parameter_property PROGRAM_TIME DEFAULT_VALUE 1600000
set_parameter_property PROGRAM_TIME TYPE INTEGER
set_parameter_property PROGRAM_TIME AFFECTS_GENERATION true
set_parameter_property PROGRAM_TIME AFFECTS_ELABORATION true
set_parameter_property PROGRAM_TIME DERIVED true
set_parameter_property PROGRAM_TIME VISIBLE false

# Set WIDTH_UFM_ADDRESS
add_parameter WIDTH_UFM_ADDRESS INTEGER 
set_parameter_property WIDTH_UFM_ADDRESS DEFAULT_VALUE 9
set_parameter_property WIDTH_UFM_ADDRESS TYPE INTEGER
set_parameter_property WIDTH_UFM_ADDRESS AFFECTS_GENERATION true
set_parameter_property WIDTH_UFM_ADDRESS VISIBLE false


# +-----------------------------------
# | static connection point - input
# +-----------------------------------
add_interface addr conduit end
#address port width set in elaboration callback
set_interface_assignment addr "ui.blockdiagram.direction" INPUT
set_interface_property addr ENABLED true

add_interface nread conduit end
add_interface_port nread nread nread Input 1
set_interface_assignment nread "ui.blockdiagram.direction" INPUT
set_interface_property nread ENABLED true


# +-----------------------------------
# | static connection point - output
# +----------------------------------- 
add_interface dataout conduit start
#dataout port width set in elaboration callback
set_interface_assignment dataout "ui.blockdiagram.direction" OUTPUT
set_interface_property dataout ENABLED true

add_interface nbusy conduit start
add_interface_port nbusy nbusy nbusy Output 1
set_interface_assignment nbusy "ui.blockdiagram.direction" OUTPUT
set_interface_property nbusy ENABLED true

add_interface data_valid conduit start
add_interface_port data_valid data_valid data_valid Output 1
set_interface_assignment data_valid "ui.blockdiagram.direction" OUTPUT
set_interface_property data_valid ENABLED true


# +-----------------------------------
# | Fileset Callbacks and Generation
# +----------------------------------- 
set_module_property ELABORATION_CALLBACK elaboration_callback

#+-------------------------------------------------------------------------------------------------------------------------
#|  Quartus synth
#+-------------------------------------------------------------------------------------------------------------------------

add_fileset    quartus_synth        QUARTUS_SYNTH        do_quartus_synth

proc do_quartus_synth {output_name} {

    send_message    info    "Generating top-level entity $output_name."

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
    set status      [do_clearbox_gen altufm_parallel $cbx_param_file $cbx_var_file]
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
add_fileset verilog_sim     SIM_VERILOG     do_quartus_synth
add_fileset vhdl_sim        SIM_VHDL        do_vhdl_sim


proc do_vhdl_sim {output_name} {
 
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
    set status      [do_clearbox_gen altufm_parallel $cbx_param_file $cbx_var_file]
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
	
	 set lpm_file [get_parameter_value LPM_FILE]
	 if {$lpm_file == ""} {
		unset param_arr(LPM_FILE)
	 } else {
        # Case:254157 - Change "\" to "/" in file path to adopt windows file path
        regsub -all {\\} $lpm_file {/} lpm_file
        set  param_arr(LPM_FILE) $lpm_file
     }

     set parameters_list     [array get param_arr]
     return $parameters_list
}

proc ports_transfer {}   {

      set all_ports [get_interface_ports]
      return $all_ports
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/vgo1395753117436/vgo1395811844282
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
