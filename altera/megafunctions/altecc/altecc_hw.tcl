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
set_module_property   NAME         "altecc"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "altecc"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "ALTECC"
set_module_property   DESCRIPTION  "The ALTERA_ECC megafunction allows you to encoding or decoding input by using Hamming Coding Scheme"
set_module_property   EDITABLE      false
set_module_property   GROUP        "Basic Functions/Miscellaneous"
set supported_device_families_list {"Arria 10" "Stratix 10"}
set_module_property	  SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list
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
#|  clearbox auto blackbox flag
#|
#+--------------------------------------------
add_parameter           CBX_AUTO_BLACKBOX   STRING              "ALL"
set_parameter_property  CBX_AUTO_BLACKBOX   DESCRIPTION         "Flag clearbox to blackbox other clearbox components or include them in the output variation file."
set_parameter_property  CBX_AUTO_BLACKBOX   VISIBLE             false
set_parameter_property  CBX_AUTO_BLACKBOX   AFFECTS_GENERATION  true


#+--------------------------------------------
#|
#|  'Module' tab
#|
#+--------------------------------------------

#encoder or decoder#
add_parameter           MODULE_TYPE   	string         	"ALTECC_ENCODER"
set_parameter_property  MODULE_TYPE   	DISPLAY_NAME   	"How do you want to configure this module?\n"
set_parameter_property  MODULE_TYPE   	ALLOWED_RANGES 	{"ALTECC_ENCODER:Configure as an ECC encoder (Data port will function as data word input)" "ALTECC_DECODER:Configure as an ECC decoder (Data port will function as code word input)"}
set_parameter_property  MODULE_TYPE   	GROUP          	"Module"
set_parameter_property  MODULE_TYPE   	DISPLAY_HINT   	radio
set_parameter_property  MODULE_TYPE   	AFFECTS_GENERATION   true
set_parameter_property  MODULE_TYPE   	DESCRIPTION    	"Specifies the module type (Range of allowed values: ALTECC_ENCODER, ALTECC_DECODER)."

#input data word input#
add_parameter           WIDTH_DATAWORD    positive        	64
set_parameter_property  WIDTH_DATAWORD    DISPLAY_NAME		"How wide should the dataword be?"
set_parameter_property  WIDTH_DATAWORD    DISPLAY_UNITS		"bits"
set_parameter_property  WIDTH_DATAWORD    GROUP				"Module"
set_parameter_property  WIDTH_DATAWORD    AFFECTS_GENERATION   true
set_parameter_property  WIDTH_DATAWORD    DESCRIPTION		"Specifies the A input buses (Number of allowed values: 12, 29, 32, 64)."

#input code word input#
add_parameter           WIDTH_CODEWORD    positive			72
set_parameter_property  WIDTH_CODEWORD    DISPLAY_NAME		"How wide should the codeword be?"
set_parameter_property  WIDTH_CODEWORD    DISPLAY_UNITS		"bits"
set_parameter_property  WIDTH_CODEWORD    GROUP				"Module"
set_parameter_property  WIDTH_CODEWORD    AFFECTS_GENERATION	true
set_parameter_property  WIDTH_CODEWORD    DESCRIPTION		"Specifies the B input buses (Number of allowed values: 18, 36, 39, 72)."

#syn_e port#
add_parameter           GUI_USE_SYN_E    boolean         false
set_parameter_property  GUI_USE_SYN_E    DISPLAY_NAME    "Create a \'syn_e\' port"
set_parameter_property  GUI_USE_SYN_E    GROUP           "Module"
set_parameter_property  GUI_USE_SYN_E   DESCRIPTION     "Select to add the syn_e port, only for ALTECC_DECODER."

#+--------------------------------------------
#|
#|  'Pipelining' tab
#|
#+--------------------------------------------

#pipeline#
add_parameter           LPM_PIPELINE    	natural         0
set_parameter_property  LPM_PIPELINE    	DISPLAY_NAME    "Output latency"
set_parameter_property  LPM_PIPELINE    	GROUP           "Pipelining"
set_parameter_property  LPM_PIPELINE    	DISPLAY_UNITS   "clock cycles"
set_parameter_property  LPM_PIPELINE    	AFFECTS_GENERATION   true
set_parameter_property  LPM_PIPELINE    	DESCRIPTION      "Specifies the output latency of pipeline."

#aclr port#
add_parameter           GUI_USE_ACLR    boolean         false
set_parameter_property  GUI_USE_ACLR    DISPLAY_NAME    "Create an 'aclr' asynchronous clear port"
set_parameter_property  GUI_USE_ACLR    GROUP           "Pipelining"
set_parameter_property  GUI_USE_ACLR    DESCRIPTION     "Select to add the asynchronous clear port."

#clken port#
add_parameter           GUI_USE_CLKEN   boolean         false
set_parameter_property  GUI_USE_CLKEN   DISPLAY_NAME    "Create a 'clocken' clock enable clock"
set_parameter_property  GUI_USE_CLKEN   GROUP           "Pipelining"
set_parameter_property  GUI_USE_CLKEN   DESCRIPTION     "Select to add the clock enable port."


#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------

set_module_property     ELABORATION_CALLBACK        elab


proc   elab {}   {


    ##device information#
    set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    	COMPONENT_INFO      "Targeting device family: $device_family."

    #get data width#
    set dataword_width  [get_parameter_value    WIDTH_DATAWORD]
    set codeword_width  [get_parameter_value    WIDTH_CODEWORD]
	
	set module_type 	[get_parameter_value	MODULE_TYPE]
	set use_syn_e		[get_parameter_value	GUI_USE_SYN_E]
	if {$module_type eq "ALTECC_ENCODER"} {		
		#set input interface#
		add_interface       data    	conduit       	input
		add_interface_port  data    	data    		data    		input    	$dataword_width
		
		#set output interface#
		add_interface       q    	conduit      	output
		add_interface_port  q    	q  				q    			output    	$codeword_width
		set_interface_assignment    q     ui.blockdiagram.direction    output	
		
		if {$use_syn_e}  {
            send_message    error   "\'syn_e\' port is only available with ECC decoder."
        }
		
		if {$dataword_width eq "12"} {
			send_message    info   "\'Codeword\' width should be 18 bits when \'Dataword\' width is 12 bits."
			if {$codeword_width ne "18"} {
				send_message    error   "Please change \'Codeword\' width to 18 bits."
			}
		} elseif {$dataword_width eq "29"} {
			send_message    info   "\'Codeword\' width should be 36 bits when \'Dataword\' width is 29 bits."
			if {$codeword_width ne "36"} {
				send_message    error   "Please change \'OCodeword\' width to 36 bits."
			}
		} elseif {$dataword_width eq "32"} {
			send_message    info   "\'Codeword\' width should be 39 bits when \'Dataword\' width is 32 bits."
			if {$codeword_width ne "39"} {
				send_message    error   "Please change \'Codeword\' width to 39 bits."
			}
		} elseif {$dataword_width eq "64"} {
			send_message    info   "\'Codeword\' width should be 72 bits when \'Dataword\' width is 64 bits."
			if {$codeword_width ne "72"} {
				send_message    error   "Please change \'Codeword\' width to 72 bits."
			}
		} else {
			send_message    error   "\'Dataword\' width 12, 29, 32, and 64 bits are supported."
		}
	
	} elseif {$module_type eq "ALTECC_DECODER"} {		
		#set input interface#
		add_interface       data    	conduit       	input
		add_interface_port  data    	data    		data    		input    	$codeword_width
		
		#set output interface#
		add_interface       q    	conduit      	output
		add_interface_port  q    	q  				q    			output  	$dataword_width
		set_interface_assignment    q     ui.blockdiagram.direction    output
		
		add_interface       err_corrected    	conduit      	output
		add_interface_port  err_corrected   	err_corrected   err_corrected   output    	1
		set_interface_assignment    err_corrected     ui.blockdiagram.direction    output
		
		add_interface       err_detected    	conduit      	output
		add_interface_port  err_detected   	err_detected   	err_detected   	output    	1
		set_interface_assignment    err_detected     ui.blockdiagram.direction    output
		
		add_interface       err_fatal    	conduit      	output
		add_interface_port  err_fatal   	err_fatal   	err_fatal   	output    	1
		set_interface_assignment    err_fatal     ui.blockdiagram.direction    output
		
		if {$use_syn_e}  {
			add_interface       syn_e    	conduit      	output
            add_interface_port  syn_e   	syn_e   		syn_e   	output    	1
			set_interface_assignment    syn_e     ui.blockdiagram.direction    output			
        }
		
		if {$codeword_width eq "18"} {
			send_message    info   "\'Dataword\' width should be 12 bits when \'Codeword\' width is 18 bits."
			if {$dataword_width ne "12"} {
				send_message    error   "Please change \'Dataword\' width to 12 bits."
			}
		} elseif {$codeword_width eq "36"} {
			send_message    info   "\'Dataword\' width should be 29 bits when \'Codeword\' width is 36 bits."
			if {$dataword_width ne "29"} {
				send_message    error   "Please change \'Dataword\' width to 29 bits."
			}
		} elseif {$codeword_width eq "39"} {
			send_message    info   "\'Dataword\' width should be 32 bits when \'Codeword\' width is 39 bits."
			if {$dataword_width ne "32"} {
				send_message    error   "Please change \'Dataword\' width to 32 bits."
			}
		} elseif {$codeword_width eq "72"} {
			send_message    info   "\'Dataword\' width should be 64 bits when \'Codeword\' width is 72 bits."
			if {$dataword_width ne "64"} {
				send_message    error   "Please change \'Dataword\' width to 64 bits."
			}
		} else {
			send_message    error   "\'Codeword\' width 18, 36, 39, and 72 bits are supported."
		}
	}

    #optional ports: aclr, clocken#
    set latency    [get_parameter_value  LPM_PIPELINE]
    set use_aclr    [get_parameter_value  GUI_USE_ACLR]
    set use_clocken     [get_parameter_value  GUI_USE_CLKEN]
    if {$latency}   {
		add_interface       clock    	conduit       	input
        add_interface_port  clock   	clock     		clock    		input    	1
        if {$use_aclr}  {
            add_interface       aclr    	conduit       	input
			add_interface_port  aclr   	aclr   			aclr   	input    	1
        }
        if {$use_clocken}  {
            add_interface       clocken    	conduit       	input
			add_interface_port  clocken    	clocken    			clocken    	input    	1
        }
     }  else  {
        if {$use_aclr} {
            send_message    error   "\'aclr\' port is unavailable with 0 pipeline latency."
        }
        if {$use_clocken} {
            send_message    error   "\'clocken\' port is unavailable with 0 pipeline latency."
        }
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
    set ip_name     [get_parameter_value	MODULE_TYPE]
    set status      [do_clearbox_gen $ip_name $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
     }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.v VERILOG PATH $cbx_var_file
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
    set ip_name     [get_parameter_value	MODULE_TYPE]
    set status      [do_clearbox_gen $ip_name $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
     }


     # Add the variation to the fileset
    add_fileset_file ${output_name}.vhd VHDL PATH $cbx_var_file

}           

#+----------------------------------------------------------------------------------------------------------------------------
#|
#|  Parameters and ports transfer procedure
#|
#+----------------------------------------------------------------------------------------------------------------------------

proc parameters_transfer {}   {

     #get all parameters#
     set param_list   [get_parameters]
     foreach param   $param_list    {
        set  param_arr($param)    [get_parameter_value  $param]
     }

     foreach  delete_item    {GUI_USE_ACLR  GUI_USE_CLKEN}        {
         unset  param_arr($delete_item)
     }

     set parameters_list     [array get param_arr]
     return $parameters_list
}

proc ports_transfer {}   {

      set all_ports [get_interface_ports]
      return $all_ports
}


#+----------------------------------------------------------------------------------------------------------------------------
#|
#|   process generate_clearbox_parameter_file and do_clearbox_gen
#|   file clearbox.tcl
#|
#+-----------------------------------------------------------------------------------------------------------------------------



## Add documentation links for user guide and/or release notes
add_documentation_link "Data Sheet" http://www.altera.com/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sam1395330298052/sam1395329715902 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
