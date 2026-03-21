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
set_module_property   NAME         "altmult_complex"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "altmult_complex"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "ALTMULT_COMPLEX Intel FPGA IP"
set_module_property   DESCRIPTION  "The ALTERA_MULT_COMPLEX megafunction allows you to implement a multiplier-complex"
set_module_property   EDITABLE      false
set_module_property   GROUP        "Basic Functions/Arithmetic"
set supported_device_families_list {"Arria 10" "Stratix 10"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list
set_module_property   HIDE_FROM_QSYS true

#Created for IP-UPGRADE for new parameter in hw_tcl
set_module_property PARAMETER_UPGRADE_CALLBACK parameter_upgrade_callback

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
#|  'General' tab
#|
#+--------------------------------------------

#input data A#
add_parameter           WIDTH_A    positive        	18
set_parameter_property  WIDTH_A    DISPLAY_NAME		"How wide should the A input buses be?"
set_parameter_property  WIDTH_A    DISPLAY_UNITS	"bits"
set_parameter_property  WIDTH_A    GROUP		"General"
set_parameter_property  WIDTH_A    AFFECTS_GENERATION   true
set_parameter_property  WIDTH_A    DESCRIPTION		"Specifies the A input buses (Range of allowed values: 1 - 256)."

#input data B#
add_parameter           WIDTH_B    positive		18
set_parameter_property  WIDTH_B    DISPLAY_NAME		"How wide should the B input buses be?"
set_parameter_property  WIDTH_B    DISPLAY_UNITS	"bits"
set_parameter_property  WIDTH_B    GROUP		"General"
set_parameter_property  WIDTH_B    AFFECTS_GENERATION	true
set_parameter_property  WIDTH_B    DESCRIPTION		"Specifies the B input buses (Range of allowed values: 1 - 256)."

#output width#
add_parameter           WIDTH_RESULT   positive		36
set_parameter_property  WIDTH_RESULT   DISPLAY_NAME	"How wide should the \'result\' output bus be?"
set_parameter_property  WIDTH_RESULT   DISPLAY_UNITS	"bits"
set_parameter_property  WIDTH_RESULT   GROUP		"General"
set_parameter_property  WIDTH_RESULT   AFFECTS_GENERATION true
set_parameter_property  WIDTH_RESULT   DESCRIPTION	"Specifies the resultant output buses (Range of allowed values: 1 - 256)."

#+--------------------------------------------
#|
#|  "Input Representation" tab
#|
#+--------------------------------------------

#input rep A#
add_parameter           REPRESENTATION_A   integer         1
set_parameter_property  REPRESENTATION_A   DISPLAY_NAME    "What is the representation format for A inputs?"
set_parameter_property  REPRESENTATION_A   ALLOWED_RANGES  {"1:Signed" "0:Unsigned"}
set_parameter_property  REPRESENTATION_A   GROUP           "Input Representation"
set_parameter_property  REPRESENTATION_A   AFFECTS_GENERATION   true
set_parameter_property  REPRESENTATION_A   DESCRIPTION      "Specifies the representation of A input buses (Range of allowed values: Unsigned, Signed)."

#input rep B#
add_parameter           REPRESENTATION_B   integer         1
set_parameter_property  REPRESENTATION_B   DISPLAY_NAME    "What is the representation format for B inputs?"
set_parameter_property  REPRESENTATION_B   ALLOWED_RANGES  {"1:Signed" "0:Unsigned"}
set_parameter_property  REPRESENTATION_B   GROUP           "Input Representation"
set_parameter_property  REPRESENTATION_B   AFFECTS_GENERATION   true
set_parameter_property  REPRESENTATION_B   DESCRIPTION      "Specifies the representation of B input buses (Range of allowed values: Unsigned, Signed)."

#+--------------------------------------------
#|
#|  'Complex Multiplier Option' Tab
#|
#+--------------------------------------------

add_parameter           GUI_DYNAMIC_COMPLEX    boolean         false
set_parameter_property  GUI_DYNAMIC_COMPLEX    DISPLAY_NAME    "Dynamic Complex Mode"
set_parameter_property  GUI_DYNAMIC_COMPLEX    GROUP           "Complex Multiplier Option"


#+--------------------------------------------
#|
#|  'Implementation Style' Tab
#|
#+--------------------------------------------

add_display_item        "Implementation Style" IMPLEMENTATION_STYLE_1    TEXT   "<html>Based on the availability of device resources, a complex multiplier can use a Conventional or a Canonical style of implementation. <br>These implementation styles result in different resource and/or performance trade-offs.<\html>"
add_parameter           IMPLEMENTATION_STYLE   string         "AUTO"
set_parameter_property  IMPLEMENTATION_STYLE   DISPLAY_NAME   "Which implementation style should be used?"
set_parameter_property  IMPLEMENTATION_STYLE   ALLOWED_RANGES {"AUTO:Automatically select a style for best trade-off for the current settings." "CANONICAL:Canonical. (Minimize the number of simple multipliers)" "CONVENTIONAL:Conventional. (Minimize the use of logic cells)"}
set_parameter_property  IMPLEMENTATION_STYLE   GROUP          "Implementation Style"
set_parameter_property  IMPLEMENTATION_STYLE   DISPLAY_HINT   radio
set_parameter_property  IMPLEMENTATION_STYLE   AFFECTS_GENERATION   true
set_parameter_property  IMPLEMENTATION_STYLE   DESCRIPTION    "Specifies the implementation style (Range of allowed values: Auto, Conventional, Canonical)."

#+--------------------------------------------
#|
#|  'Pipelining' tab
#|
#+--------------------------------------------

#pipeline#
add_parameter           PIPELINE    natural         4
set_parameter_property  PIPELINE    DISPLAY_NAME    "Output latency"
set_parameter_property  PIPELINE    GROUP           "Pipelining"
set_parameter_property  PIPELINE    DISPLAY_UNITS   "clock cycles"
set_parameter_property  PIPELINE    AFFECTS_GENERATION   true
set_parameter_property  PIPELINE    DESCRIPTION      "Specifies the output latency of pipeline (Range of allowed values: 0 - 11 or 0 - 14, deponds on implementation style)."

#aclr and sclr port#
add_parameter           GUI_CLEAR_TYPE   string          "NONE"
set_parameter_property  GUI_CLEAR_TYPE 	 ALLOWED_RANGES  {"NONE" "ACLR" "SCLR"}
set_parameter_property  GUI_CLEAR_TYPE   DISPLAY_NAME    "Clear Signal Type"
set_parameter_property  GUI_CLEAR_TYPE   GROUP           "Pipelining"
set_parameter_property  GUI_CLEAR_TYPE   DESCRIPTION     "Select to add the clear port."

#clken port#
add_parameter           GUI_USE_CLKEN   boolean         false
set_parameter_property  GUI_USE_CLKEN   DISPLAY_NAME    "Create a Clock Enable input?"
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
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."


    #test representation#
    set representation_a    [get_parameter_value    REPRESENTATION_A]
    set representation_b    [get_parameter_value    REPRESENTATION_B]
    if {$representation_a!=0 && $representation_a!=1} {
        send_message    error       "The representation_a value is out of range (0:Unsigned,1:Signed)"
    }
    if {$representation_b!=0 && $representation_b!=1} {
        send_message    error       "The representation_b value is out of range (0:Unsigned,1:Signed)"
    }

    #get data width#
    set data_a_width    [get_parameter_value    WIDTH_A]
    set data_b_width    [get_parameter_value    WIDTH_B]
    set result_width    [get_parameter_value    WIDTH_RESULT]


    #set input interface#
    add_interface       complex_input    conduit       input
    add_interface_port  complex_input    dataa_real    dataa_real    input    $data_a_width
    add_interface_port  complex_input    dataa_imag    dataa_imag    input    $data_a_width
    add_interface_port  complex_input    datab_real    datab_real    input    $data_b_width
    add_interface_port  complex_input    datab_imag    datab_imag    input    $data_b_width

    #set output interface#
    add_interface       complex_output    conduit      output
    add_interface_port  complex_output    result_real  result_real    output    $result_width
    add_interface_port  complex_output    result_imag  result_imag    output    $result_width
    set_interface_assignment    complex_output         ui.blockdiagram.direction    output


    #data width range list#
    set width_list_256  [list ]
    for {set i 1} {$i <=256} {incr i}      {
        lappend   width_list_256 $i
    }
    set width_list_18  [list ]
    for {set i 1} {$i <=18} {incr i}      {
        lappend   width_list_18 $i
    }
    set width_list_36  [list ]
    for {set i 1} {$i <=36} {incr i}      {
        lappend   width_list_36 $i
    }
	#WIDTH_RESULT:width range
	#Change value i from 1 to 2 as width_result need at least 2 bit as minimum and 1 -bit is not possible
	set result_width_list_256  [list ]
    for {set i 2} {$i <=256} {incr i}      {
        lappend   result_width_list_256 $i
    }
    set result_width_list_18  [list ]
    for {set i 2} {$i <=18} {incr i}      {
        lappend   result_width_list_18 $i
    }
    set result_width_list_36  [list ]
    for {set i 2} {$i <=36} {incr i}      {
        lappend   result_width_list_36 $i
    }

    #dynamic complex#
    set dynamic_complex      [get_parameter_value   GUI_DYNAMIC_COMPLEX]
    if {[check_device_family_equivalence $device_family {"Stratix V" "Arria V GZ"}]}  {
        if {$dynamic_complex}  {
            add_interface_port   complex_input   complex    complex    input    1
            #data width change when complex port is added#
            send_message    COMPONENT_INFO  "The maximum data input width is 18 when the complex port is added with $device_family device family."
            send_message    COMPONENT_INFO  "The maximum data output width is 36 when the complex port is added with $device_family device family."
            if {$data_a_width >18}  {
                send_message    error   "The data input A width is out of range (Range of allowed values: 1 - 18)."
            } else  {
                set_parameter_property  WIDTH_A      ALLOWED_RANGES  $width_list_18
            }
            if {$data_b_width>18}   {
                send_message    error   "The data input B width is out of range (Range of allowed values: 1 - 18)."
            } else  {
                set_parameter_property  WIDTH_B      ALLOWED_RANGES  $width_list_18
            }
            if {$result_width>36}   {
                send_message    error   "The data output width is out of range (Range of allowed values: 1 - 36)."
            } else  {
                set_parameter_property  WIDTH_RESULT ALLOWED_RANGES  $result_width_list_36
            }
            set pipeline_latency    [get_parameter_value    PIPELINE]
            if {$pipeline_latency<2}  {
                send_message    error   "When the complex port is added, the pipeline latency must be greater than 1."
            }
            if {$data_a_width<3}   {
                send_message    error   "when the complex port is added, the input data width must be greater than 2."
            }
            if {$data_b_width<3} {
                send_message    error   "when the complex port is added, the input data width must be greater than 2."
            }
            if {$result_width<6}    {
                send_message    error   "when the complex port is added, the output data width must be greater than 6."
            }
       } else  {
            set_parameter_property  WIDTH_A      ALLOWED_RANGES  $width_list_256
            set_parameter_property  WIDTH_B      ALLOWED_RANGES  $width_list_256
            set_parameter_property  WIDTH_RESULT ALLOWED_RANGES  $result_width_list_256
        }
    } else  {
        set_parameter_property  WIDTH_A      ALLOWED_RANGES  $width_list_256
        set_parameter_property  WIDTH_B      ALLOWED_RANGES  $width_list_256
        set_parameter_property  WIDTH_RESULT ALLOWED_RANGES  $result_width_list_256
        if {$dynamic_complex} {
            send_message    error   "\"Dynamic Complex Mode\" is unavailable while using the $device_family device family."
        }
    }


    #latency range lists$
    set latency_list_11  [list ]
    for {set i 0} {$i <=11}  {incr i}   {
        lappend    latency_list_11       $i
     }
    set latency_list_14  [list ]
    for {set i 0} {$i <=14}  {incr i}   {
        lappend    latency_list_14       $i
     }

    #Only: AUTO#
    set auto_device_family  {"Cyclone V" "Arria 10" "Arria V" "Arria II GX" "Arria II GZ" "Stratix III" "Stratix IV" "Stratix V" "Arria V GZ" "Stratix 10"}
    if {[check_device_family_equivalence $device_family $auto_device_family]}  {
        set imp_style   [get_parameter_value    IMPLEMENTATION_STYLE]
        if {$imp_style eq "CANONICAL"} {
            send_message    error       "\"Canonical Implementation Style\" is unavailable while using the $device_family device family."
        } elseif {$imp_style eq "CONVENTIONAL" } {
            send_message     error     "\"Conventional Implementation Style\" is unavailable while using the $device_family device family."
        }
	set pipeline_latency	  [get_parameter_value	  PIPELINE]
        if {$pipeline_latency>11}   {
        	send_message    error   "The pipeline latency is out of range (Range of allowed values: 0 - 11)."
        } else {
        	set_parameter_property    PIPELINE    ALLOWED_RANGES    $latency_list_11
        }
    } else  {
        #other implementation styles#
        set imp_style  [get_parameter_value  IMPLEMENTATION_STYLE]
        if {$imp_style eq "CANONICAL"}      {
            if {($data_a_width >=18 )||($data_b_width >=18)}   {
                send_message    ERROR    "\"Canonical\" implementation style is unavailable with input data width equal or larger than 18."
            }
            set_parameter_property    PIPELINE    ALLOWED_RANGES    $latency_list_14
        } elseif {$imp_style eq "CONVENTIONAL"}    {
            if {($data_a_width >=18 )||($data_b_width >=18)}   {
                send_message    ERROR    "\"Conventional\" implementation style is unavailable with input data width equal or larger than 18."
            } else {
                set pipeline_latency     [get_parameter_value   PIPELINE]
                if {$pipeline_latency>11}   {
                    send_message    error   "The pipeline latency is out of range (Range of allowed values: 0 - 11)."
                } else {
                    set_parameter_property    PIPELINE    ALLOWED_RANGES    $latency_list_11
                }
            }
        } else  {
            set_parameter_property    PIPELINE    ALLOWED_RANGES    $latency_list_11
        }
    }

    #rep_A, rep_B: signed#
    set signed_device_family    {"Cyclone V" "Arria 10" "Arria V" "Stratix V" "Arria V GZ" "Stratix 10"}
    if {[check_device_family_equivalence $device_family $signed_device_family]}  {
        set rep_a   [get_parameter_value  REPRESENTATION_A]
        set rep_b   [get_parameter_value  REPRESENTATION_B]
        if {$rep_a ==0} {
            send_message     error   "\"Unsigned Input A Representation\" is unavailable while using the $device_family device family."
        }
        if {$rep_b ==0} {
            send_message     error   "\"Unsigned Input B Representation\" is unavailable while using the $device_family device family."
        }

    }
    #optional ports: aclr, ena#
    set latency    [get_parameter_value  PIPELINE]
    set use_ena     [get_parameter_value  GUI_USE_CLKEN]
	#New parameter for clear type signal#
	set get_clear_type [get_parameter_value GUI_CLEAR_TYPE]
    if {$latency}   {
        add_interface_port    complex_input   clock     clk    input    1
		#Asynchorouns Clear signal#
		if {$get_clear_type eq "ACLR"} {
			add_interface_port complex_input aclr aclr input 1
		}
		#For synchronous clear signal#
		if {$get_clear_type eq "SCLR"} {
			add_interface_port complex_input sclr sclr input 1
		}
        if {$use_ena}  {
            add_interface_port    complex_input    ena    ena    input    1
        }
     }  else  {
		#For asynchronous clear signal#
		if {$get_clear_type eq "ACLR"} {
			send_message error "\'aclr\' port is unavailable with 0 pipeline latency."
		}
		#For synchorous clear signal#
		if {$get_clear_type eq "SCLR"} {
			send_message error "\'sclr\' port is unavailable with 0 pipeline latency."
		}
        if {$use_ena} {
            send_message    error   "\'ena\' port is unavailable with 0 pipeline latency."
        }
     }
	 
	#Error flag when 1-bit signed multiplication used
	if { ($data_a_width == "1" || $data_b_width == "1") && ($representation_a == "1" || $representation_b == "1")} {
	    send_message error "The Data Port Widths selection need to be set more than '1' when using 'Signed' for Input Representation"
	}
	
    #Error flag when using CLEAR_TYPE= 'SCLR' with more than '3' pipeline register
    if { ($get_clear_type == "SCLR" && $pipeline_latency > 3 && ($data_a_width != "18" || $data_b_width != "18"))} {
        send_message error "More than '3' output latency is not supported when using 'SCLR' for Clear Signal Type with selected dataa and datab width "
    }
}

#+--------------------------------------------
#|
#|  IP_UPGRADE
#|
#+--------------------------------------------
proc parameter_upgrade_callback {ip_core_type version parameters} {
	set GUI_CLEAR_TYPE "NONE"
	foreach { name value } $parameters {
		send_message INFO "PARAMETER WITH PREVIOUS VALUE -->$name $value $parameters"
		if { $name == "GUI_USE_ACLR" } {
			set GUI_USE_ACLR $value
			send_message INFO "Show OLD_PARAMETER WITH VALUE -->$name=$value"
			if { $GUI_USE_ACLR == "true"} {
				set_parameter_value GUI_CLEAR_TYPE "ACLR"
				send_message INFO "GUI_CLEAR_TYPE -->ACLR"
			} elseif {$GUI_USE_ACLR == "false"} {
				set_parameter_value GUI_CLEAR_TYPE "NONE"
				send_message INFO "GUI_CLEAR_TYPE --> NONE"
		    }
		} else {
			set_parameter_value $name $value
			send_message INFO "SHOW OTHER PARAMETER:$name=$value"
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
    set ip_name     [get_module_property    NAME]
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
    set ip_name     [get_module_property    NAME]
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

     #set conditional parameter values#
     set device_family_list  {"Cyclone V" "Arria 10" "Arria V" "Stratix V" "Arria V GZ" "Stratix 10"}
     if {[check_device_family_equivalence $param_arr(DEVICE_FAMILY) $device_family_list]}  {
         set param_arr(REPRESENTATION_A) "SIGNED"
         set param_arr(REPRESENTATION_B) "SIGNED"
     } else  {
         if {$param_arr(REPRESENTATION_A)}     {
             set param_arr(REPRESENTATION_A)  "SIGNED"
         } else   {
             set param_arr(REPRESENTATION_A)    "UNSIGNED"
         }
         if {$param_arr(REPRESENTATION_B)}     {
             set param_arr(REPRESENTATION_B)    "SIGNED"
         } else   {
             set param_arr(REPRESENTATION_B)    "UNSIGNED"
         }
    }
    set device_family_list  {"Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA"}
    if {![check_device_family_equivalence $param_arr(DEVICE_FAMILY) $device_family_list]} {
         set param_arr(IMPLEMENTATION_STYLE) "AUTO"
    }
     #For clear signal#
     foreach  delete_item    {GUI_CLEAR_TYPE  GUI_USE_CLKEN GUI_DYNAMIC_COMPLEX }        {
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
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sam1395331401937/sam1395329571445
add_documentation_link "User Guide For Stratix 10"  https://documentation.altera.com/#/link/kly1436148709581/kly1439175970736
add_documentation_link "Release Notes" https://www.intel.com/content/www/us/en/programmable/documentation/ktw1517822281214.html
