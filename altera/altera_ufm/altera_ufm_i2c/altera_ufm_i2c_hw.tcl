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
# | $Header: //acds/rel/18.1std/ip/altera_ufm/altera_ufm_i2c/altera_ufm_i2c_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1

# Source files
source altera_ufm_i2c_hw_proc.tcl

# +-----------------------------------
# | module UFM I2C
# +-----------------------------------
set_module_property NAME altera_ufm_i2c
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "User Flash Memory for I2C Interface Protocol Intel FPGA IP"
set_module_property DESCRIPTION "The Altera User Flash Memory for I2C Interface Protocol megafunction implements the user \
									non-volatile memory for MAX II/Max V devices using the I2C interface protocol."
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
add_display_item "General" "Access Mode" GROUP
add_display_item "General" " " GROUP
add_display_item "General" "Port Settings" GROUP
add_display_item "" "Write and Erase" GROUP tab
add_display_item "Write and Erase" "Write Options" GROUP
add_display_item "Write and Erase" "Erase Method" GROUP
add_display_item "" "Initialization and Simulation" GROUP tab
add_display_item "Initialization and Simulation" "Memory content initialization" GROUP
add_display_item "Initialization and Simulation" "Simulation only options" GROUP


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
add_display_item "Access Mode" ACCESS_MODE parameter

#set MSB address (binary)
add_parameter FIXED_DEVICE_ADD STRING 
set_parameter_property FIXED_DEVICE_ADD DEFAULT_VALUE "1010"
set_parameter_property FIXED_DEVICE_ADD DISPLAY_NAME "Device address MSB (binary)"
set_parameter_property FIXED_DEVICE_ADD DESCRIPTION "Select 4-bit address that specifies the 4 MSBs of the device address."
set_parameter_property FIXED_DEVICE_ADD TYPE STRING
set_parameter_property FIXED_DEVICE_ADD AFFECTS_GENERATION true
set_parameter_property FIXED_DEVICE_ADD AFFECTS_ELABORATION true
add_display_item " " FIXED_DEVICE_ADD parameter

#set memory size
add_parameter MEMORY_SIZE STRING
set_parameter_property MEMORY_SIZE DEFAULT_VALUE "4K"
set_parameter_property MEMORY_SIZE DISPLAY_NAME "Memory size"
set_parameter_property MEMORY_SIZE DESCRIPTION "Specifies the memory size. Values are 1K, 2K, and 4K. If omitted, the default is 4K"
set_parameter_property MEMORY_SIZE TYPE STRING
set_parameter_property MEMORY_SIZE AFFECTS_GENERATION true
set_parameter_property MEMORY_SIZE AFFECTS_ELABORATION true
set_parameter_property MEMORY_SIZE ALLOWED_RANGES {"1K" "2K" "4K" "8K"}
add_display_item " " MEMORY_SIZE parameter  

# *~*~* set GUI global_reset *~*~*
add_parameter GUI_GLOBAL_CHECK boolean 
set_parameter_property GUI_GLOBAL_CHECK DEFAULT_VALUE 0
set_parameter_property GUI_GLOBAL_CHECK DISPLAY_NAME "Use 'global_reset' input port"
set_parameter_property GUI_GLOBAL_CHECK DESCRIPTION "Turn on this option to enable global reset input port."
set_parameter_property GUI_GLOBAL_CHECK AFFECTS_ELABORATION true
add_display_item "Port Settings" GUI_GLOBAL_CHECK parameter

#set internal global_reset value
add_parameter PORT_GLOBAL_RESET STRING 
set_parameter_property PORT_GLOBAL_RESET DEFAULT_VALUE "PORT_UNUSED"
set_parameter_property PORT_GLOBAL_RESET TYPE STRING
set_parameter_property PORT_GLOBAL_RESET AFFECTS_GENERATION true
set_parameter_property PORT_GLOBAL_RESET AFFECTS_ELABORATION true
set_parameter_property PORT_GLOBAL_RESET DERIVED true
set_parameter_property PORT_GLOBAL_RESET VISIBLE false

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

# +-----------------------------------
# | Parameters - Write and Erase tab
# +-----------------------------------

#set write mode
add_parameter WRITE_MODE STRING 
set_parameter_property WRITE_MODE DEFAULT_VALUE "SINGLE_BYTE"
set_parameter_property WRITE_MODE DISPLAY_NAME "Write Configuration"
set_parameter_property WRITE_MODE DESCRIPTION "Specify the write configuration for the I2C protocol." 
set_parameter_property WRITE_MODE TYPE STRING
set_parameter_property WRITE_MODE DISPLAY_HINT "radio"
set_parameter_property WRITE_MODE ALLOWED_RANGES {"SINGLE_BYTE:Single byte write" "PAGE:Page write"} 
set_parameter_property WRITE_MODE AFFECTS_GENERATION true
set_parameter_property WRITE_MODE AFFECTS_ELABORATION true
add_display_item "Write Options" WRITE_MODE parameter

# set page write size
add_parameter PAGE_WRITE_SIZE INTEGER 
set_parameter_property PAGE_WRITE_SIZE DEFAULT_VALUE 16
set_parameter_property PAGE_WRITE_SIZE DISPLAY_NAME "Page write size"
set_parameter_property PAGE_WRITE_SIZE DESCRIPTION "The current option is only set at 16 bytes"
set_parameter_property PAGE_WRITE_SIZE TYPE INTEGER
set_parameter_property PAGE_WRITE_SIZE ALLOWED_RANGES {16}
set_parameter_property PAGE_WRITE_SIZE AFFECTS_GENERATION true
set_parameter_property PAGE_WRITE_SIZE AFFECTS_ELABORATION true
add_display_item "Write Options" PAGE_WRITE_SIZE parameter

#set 'wp' input port
add_parameter WP_CHECK boolean 
set_parameter_property WP_CHECK DEFAULT_VALUE 0
set_parameter_property WP_CHECK DISPLAY_NAME "Use 'wp' write protect input port"
set_parameter_property WP_CHECK DESCRIPTION "Select this option to use the write protect input port, and define how the write protect is applied; write protect the full memory or only the upper half of the memory."
set_parameter_property WP_CHECK AFFECTS_GENERATION true
set_parameter_property WP_CHECK AFFECTS_ELABORATION true
add_display_item "Write Options" WP_CHECK parameter

#set write protect applies to
add_parameter MEM_PROTECT STRING 
set_parameter_property MEM_PROTECT DEFAULT_VALUE "FULL"
set_parameter_property MEM_PROTECT DISPLAY_NAME "Write Protect Options"
set_parameter_property MEM_PROTECT DESCRIPTION "Select this option to use the write protect input port, and define how the write protect is applied; write protect the full memory or only the upper half of the memory." 
set_parameter_property MEM_PROTECT TYPE STRING
set_parameter_property MEM_PROTECT DISPLAY_HINT "radio"
set_parameter_property MEM_PROTECT ALLOWED_RANGES {"FULL:Write protect applies to full memory" "UPPER_HALF:Write protect applies only to upper half of memory"} 
set_parameter_property MEM_PROTECT ENABLED false
set_parameter_property MEM_PROTECT AFFECTS_GENERATION true
set_parameter_property MEM_PROTECT AFFECTS_ELABORATION true
add_display_item "Write Options" MEM_PROTECT parameter

#set erase method
add_parameter ERASE_METHOD STRING 
set_parameter_property ERASE_METHOD DEFAULT_VALUE "MEM_ADD"
set_parameter_property ERASE_METHOD DISPLAY_NAME "Erase Method"
set_parameter_property ERASE_METHOD DESCRIPTION "Select the erase method. Options are full erase, sector erase, and no erase. If you select the Sector Erase Triggered by Byte Address option, enter the binary address for sectors 0 and 1. Note that the Sector Erase Triggered by Byte Address option is only available if Single byte write is selected as the write configuration." 
set_parameter_property ERASE_METHOD TYPE STRING
set_parameter_property ERASE_METHOD DISPLAY_HINT "radio"
set_parameter_property ERASE_METHOD ALLOWED_RANGES {"DEV_ADD_111:Device slave address full erase (3 LSBs are 111)" "MEM_ADD:Sector erase triggered by byte address" "A2_ERASE:Sector erase triggered by 'a2' bit" "NO_ERASE:No erase"} 
set_parameter_property ERASE_METHOD AFFECTS_GENERATION true
set_parameter_property ERASE_METHOD AFFECTS_ELABORATION true
add_display_item "Erase Method" ERASE_METHOD parameter

#*~*~* set Sector 0 MSB *~*~*
add_parameter GUI_MEM_ADD_ERASE0 STRING
set_parameter_property GUI_MEM_ADD_ERASE0 DEFAULT_VALUE "00000000"
set_parameter_property GUI_MEM_ADD_ERASE0 DISPLAY_NAME "Sector 0: trigger erase when writing to binary address (MSB always '0')"
set_parameter_property GUI_MEM_ADD_ERASE0 DESCRIPTION "If the ERASE_METHOD parameter has a value of MEM_ADD, the MEM_ADD_ERASE0 parameter must specify the 8-bit memory address that erases sector 0 of the UFM block"
set_parameter_property GUI_MEM_ADD_ERASE0 TYPE STRING
set_parameter_property GUI_MEM_ADD_ERASE0 ENABLED false
set_parameter_property GUI_MEM_ADD_ERASE0 AFFECTS_ELABORATION true
add_display_item "Erase Method" GUI_MEM_ADD_ERASE0 parameter

#set internal Sector 0 value
add_parameter MEM_ADD_ERASE0 STRING 
set_parameter_property MEM_ADD_ERASE0 DEFAULT_VALUE "UNUSED"
set_parameter_property MEM_ADD_ERASE0 TYPE STRING
set_parameter_property MEM_ADD_ERASE0 AFFECTS_GENERATION true
set_parameter_property MEM_ADD_ERASE0 AFFECTS_ELABORATION true
set_parameter_property MEM_ADD_ERASE0 DERIVED true
set_parameter_property MEM_ADD_ERASE0 VISIBLE false

#*~*~* set Sector 1 MSB *~*~*
add_parameter GUI_MEM_ADD_ERASE1 STRING 
set_parameter_property GUI_MEM_ADD_ERASE1 DEFAULT_VALUE "01000000"
set_parameter_property GUI_MEM_ADD_ERASE1 DISPLAY_NAME "Sector 1: trigger erase when writing to binary address (MSB always '1')"
set_parameter_property GUI_MEM_ADD_ERASE1 DESCRIPTION "If the ERASE_METHOD parameter has a value of MEM_ADD, the MEM_ADD_ERASE1 parameter must specify the 8-bit memory address that erases sector 1 of the UFM block"
set_parameter_property GUI_MEM_ADD_ERASE1 TYPE STRING
set_parameter_property GUI_MEM_ADD_ERASE1 ENABLED false
set_parameter_property GUI_MEM_ADD_ERASE1 AFFECTS_ELABORATION true
add_display_item "Erase Method" GUI_MEM_ADD_ERASE1 parameter

#set internal Sector 1 value
add_parameter MEM_ADD_ERASE1 STRING 
set_parameter_property MEM_ADD_ERASE1 DEFAULT_VALUE "UNUSED"
set_parameter_property MEM_ADD_ERASE1 TYPE STRING
set_parameter_property MEM_ADD_ERASE1 AFFECTS_GENERATION true
set_parameter_property MEM_ADD_ERASE1 AFFECTS_ELABORATION true
set_parameter_property MEM_ADD_ERASE1 DERIVED true
set_parameter_property MEM_ADD_ERASE1 VISIBLE false

# +------------------------------------------------
# | Parameters - Initialization and Simulation tab
# +------------------------------------------------

#set memory content initialization
add_parameter GUI_MEM_INIT STRING  
set_parameter_property GUI_MEM_INIT DEFAULT_VALUE "Initialize blank memory"
set_parameter_property GUI_MEM_INIT DISPLAY_NAME "Memory content initialization"
set_parameter_property GUI_MEM_INIT TYPE STRING
set_parameter_property GUI_MEM_INIT DISPLAY_HINT "radio"
set_parameter_property GUI_MEM_INIT ALLOWED_RANGES {"Initialize blank memory" "Initialize from hex or mif file"} 
set_parameter_property GUI_MEM_INIT DESCRIPTION "Select Initialize blank memory if you do not want to specify any initialization file. Select Initialize from hex or mif file to specify the initialization file. Type the file name or browse for the required file."
set_parameter_property GUI_MEM_INIT AFFECTS_ELABORATION true
add_display_item "Memory content initialization" GUI_MEM_INIT parameter

#set memory content initialization
add_parameter LPM_FILE STRING 
set_parameter_property LPM_FILE DEFAULT_VALUE ""
set_parameter_property LPM_FILE DISPLAY_NAME "File name"
set_parameter_property LPM_FILE TYPE STRING
set_parameter_property LPM_FILE DISPLAY_HINT "file"
set_parameter_property LPM_FILE DESCRIPTION "Select Initialize blank memory if you do not want to specify any initialization file. Select Initialize from hex or mif file to specify the initialization file. Type the file name or browse for the required file."
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

# +------------------------------------------------
# | Parameters - Hidden
# +------------------------------------------------

# Set AUTO_CLOCK_ENABLE_RECOGNITION
add_parameter AUTO_CLOCK_ENABLE_RECOGNITION STRING 
set_parameter_property  AUTO_CLOCK_ENABLE_RECOGNITION DEFAULT_VALUE "OFF"
set_parameter_property  AUTO_CLOCK_ENABLE_RECOGNITION TYPE STRING
set_parameter_property  AUTO_CLOCK_ENABLE_RECOGNITION AFFECTS_GENERATION true
set_parameter_property  AUTO_CLOCK_ENABLE_RECOGNITION VISIBLE false


# +-----------------------------------
# | static connection point - input
# +-----------------------------------
add_interface a0 conduit end
add_interface_port a0 a0 a0 Input 1
set_interface_assignment a0 "ui.blockdiagram.direction" INPUT
set_interface_property a0 ENABLED true

add_interface a1 conduit end
add_interface_port a1 a1 a1 Input 1
set_interface_assignment a1 "ui.blockdiagram.direction" INPUT
set_interface_property a1 ENABLED true

add_interface a2 conduit end
add_interface_port a2 a2 a2 Input 1
set_interface_assignment a2 "ui.blockdiagram.direction" INPUT
set_interface_property a2 ENABLED true


# +-----------------------------------
# | static connection point - output
# +----------------------------------- 
add_interface scl conduit start
add_interface_port scl scl scl bidir 1
set_interface_assignment scl "ui.blockdiagram.direction" OUTPUT
set_interface_property scl ENABLED true

add_interface sda conduit start
add_interface_port sda sda sda bidir 1
set_interface_assignment sda "ui.blockdiagram.direction" OUTPUT
set_interface_property sda ENABLED true


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
    set status      [do_clearbox_gen altufm_i2c $cbx_param_file $cbx_var_file]
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
    set status      [do_clearbox_gen altufm_i2c $cbx_param_file $cbx_var_file]
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
