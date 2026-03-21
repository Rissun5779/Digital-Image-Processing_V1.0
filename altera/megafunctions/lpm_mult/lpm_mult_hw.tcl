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


package require -exact qsys 14.0


#+-------------------------------------------
#|
#|  Source Files
#|
#+-------------------------------------------
source "csv_ui_loader.tcl"
source "lpm_mult_extra.tcl"


#+--------------------------------------------
#|
#|  Module Property
#|
#+--------------------------------------------
set_module_property     NAME                    "lpm_mult"
set_module_property     AUTHOR                  "Altera Corporation"
set_module_property     VERSION                 18.1
set_module_property     DISPLAY_NAME            "LPM_MULT Intel FPGA IP"
set_module_property     DESCRIPTION             "Multiplier for two input data values and produces a product as an output."
set_module_property     GROUP                   "Basic Functions/Arithmetic"
set_module_property     EDITABLE                false
set_module_property     ELABORATION_CALLBACK    elab
set_module_property   	SUPPORTED_DEVICE_FAMILIES   {"Arria 10" "Stratix 10"}
set_module_property   	HIDE_FROM_QSYS true

#Created for IP-UPGRADE for new parameter in hw_tcl
set_module_property PARAMETER_UPGRADE_CALLBACK parameter_upgrade_callback


#+--------------------------------------------
#|
#|  Filesets
#|
#+--------------------------------------------
add_fileset quartus_synth   QUARTUS_SYNTH   do_quartus_synth
add_fileset verilog_sim     SIM_VERILOG     do_quartus_synth
add_fileset vhdl_sim        SIM_VHDL        do_vhdl_sim


#+--------------------------------------------
#|
#|  Interfaces
#|
#+--------------------------------------------
add_interface               mult_input      conduit                     input
add_interface               mult_output     conduit                     output
set_interface_assignment    mult_input      ui.blockdiagram.direction   input
set_interface_assignment    mult_output     ui.blockdiagram.direction   output


#+--------------------------------------------
#|
#|  Load the parameters and ui from CSV files
#|
#+--------------------------------------------
load_parameters "parameters.csv"
load_layout     "layout.csv"

# Set the width allowed ranges property
set one_to_256 [list]
set one_to_512 [list]

#Added for 0 bits in width_b
set zero_to_256 [list]

for {set i 1} {$i <= 256} {incr i} { lappend one_to_256 $i }
for {set i 1} {$i <= 512} {incr i} { lappend one_to_512 $i }
for {set i 0} {$i <= 256} {incr i} { lappend zero_to_256 $i} 
set_parameter_property GUI_WIDTH_A ALLOWED_RANGES $one_to_256
#set_parameter_property GUI_WIDTH_B ALLOWED_RANGES $one_to_256
set_parameter_property GUI_WIDTH_P ALLOWED_RANGES $one_to_512
set_parameter_property GUI_WIDTH_B ALLOWED_RANGES $zero_to_256

# ACLR and SCLR selection
set_parameter_property GUI_CLEAR_TYPE ALLOWED_RANGES  {"NONE" "ACLR" "SCLR"}

#+--------------------------------------------
#|
#|  Elaboration Callback
#|
#+--------------------------------------------
proc elab {} {
    # Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }
    
    
    #+---------- UPDATE PAGE 1 ----------+#
    set params(GUI_RESULT_WIDTH)            [get_result_width]
    set_parameter_value GUI_RESULT_WIDTH    [get_result_width]
    
    if { $params(GUI_AUTO_SIZE_RESULT) } {
        send_message INFO "GUI_WIDTH_P will be ignored... The result width can't be set if it is automatically calculated."
    }
    
    if { !$params(GUI_USE_MULT) } {
        send_message INFO "GUI_WIDTH_B will be ignored... The width b parameter is only used when multiplying dataa and datab."
    }
    
    
    #+---------- UPDATE PAGE 2 ----------+#
    if { !$params(GUI_USE_MULT) } {
        send_message INFO "GUI_CONSTANT_B will be ignored... Con only set the constant B port value when not using a squaring function."
        send_message INFO "GUI_IMPLEMENTATION will be ignored... Implementation parameter only available when not using a squaring function."

        if { $params(GUI_B_IS_CONSTANT) } {
            send_message ERROR "B can't be constant when using the square function."
        }
        
        #Altsquare is not supported for sclr
        if { $params(GUI_CLEAR_TYPE) eq "SCLR"} {
                send_message ERROR "Cannot perform squaring operation when using synchronous clear signal"
        }
        
    }
    
    if { $params(GUI_USE_MULT) && !$params(GUI_B_IS_CONSTANT) } {
        send_message INFO "GUI_CONSTANT_B will be ignored... Con only set the constant B port value if the B port is constant."
    }
	#Added for width_b zero restrict
	if { $params(GUI_USE_MULT) == 0 && $params(GUI_WIDTH_B) ne "0" } {
	    send_message ERROR "Datab width need to be changed to 0 when using squaring operation"
	}
    
    if { $params(GUI_CONSTANT_B) ne "" } {
        if { $params(GUI_SIGNED_MULT) == 0 && $params(GUI_CONSTANT_B) < 0 } {
            send_message ERROR "Can't use a negative datab\[\] constant value in an unsigned multiplication"
        }
        if {$params(GUI_USE_MULT)!= 0 && $params(GUI_WIDTH_B) != 0 && $params(GUI_B_IS_CONSTANT) != 0} {
			if { [nBitNecessary $params(GUI_CONSTANT_B) $params(GUI_SIGNED_MULT)] > $params(GUI_WIDTH_B) } {
				send_message ERROR "datab\[\] constant value is too large to fit in the specified datab\[\] port"
			}
		}
    }
	
	#Added Leaglity to set constant b value to "0" when using squaring operation
	if { ($params(GUI_USE_MULT) == 0 && $params(GUI_WIDTH_B) == 0 && $params(GUI_CONSTANT_B) > 0) && ($params(GUI_B_IS_CONSTANT) == 1 || $params(GUI_B_IS_CONSTANT) == 0)} {
	    send_message ERROR "Data b input value need to be set to \"0\" when using squaring operation and datab width is equals to \"0\" "
	}
	if { $params(GUI_USE_MULT) == 1 && $params(GUI_WIDTH_B) == 0} {
	    send_message ERROR "Datab width need to be set more than \"0\" when using Multiply 'dataa' input by 'datab' input"
	}
	
	#Error flag when 1-bit signed multiplication used
	if { ($params(GUI_WIDTH_A) == "1" || $params(GUI_WIDTH_B) == "1") && $params(GUI_SIGNED_MULT) == "1" } {
		send_message ERROR "The Data Port Widths selection need to be set more than '1' when using 'Signed' for Multiplication type"
	}
    
    #+---------- UPDATE PAGE 3 ----------+#
	
    if { !$params(GUI_PIPELINE) } {
        send_message INFO "GUI_LATENCY will be ignored... Can only set the number of clock cycles when using pipelining."
        
        if { $params(GUI_CLEAR_TYPE) ne "NONE" } {
            send_message ERROR "Pipeline need to be enabled when using 'Synchronous' or 'asynchronous' clear signal."
        }
        
        if { $params(GUI_CLKEN) } {
            send_message ERROR "Can't use 'clock enabled' without using pipelining."
        }	
    }
    
    #Logic Elemenent cannot be used with sclr
    if { $params(GUI_IMPLEMENTATION) eq "2" && $params(GUI_CLEAR_TYPE) eq "SCLR"} {
        send_message ERROR "Logic elements cannnot be used for Synchronous clear type signal"
    }
	#Default Implementation cannot be used with sclr
	if { $params(GUI_IMPLEMENTATION) eq "0" && $params(GUI_CLEAR_TYPE) eq "SCLR"} {
	    send_message ERROR "'Use the default implentation' cannot be used for Synchronous clear type signal"
	}
    
    if { !$params(GUI_USE_MULT) } {
        send_message INFO "GUI_OPTIMIZE will be ignored... Optimization parameter only available when not using a squaring function."
    }
    
    #+---------- SETUP PORTS ----------+#

    # Ports that are always open
    add_interface_port  mult_input  dataa   dataa   input   $params(GUI_WIDTH_A)
    set_port_property               dataa   VHDL_TYPE       STD_LOGIC_VECTOR

    add_interface_port  mult_output result  result  output  $params(GUI_RESULT_WIDTH)
    set_port_property               result  VHDL_TYPE       STD_LOGIC_VECTOR

    # datab port
    if { $params(GUI_USE_MULT) && !$params(GUI_B_IS_CONSTANT) } {
        add_interface_port  mult_input  datab   datab   input   $params(GUI_WIDTH_B)
        set_port_property               datab   VHDL_TYPE       STD_LOGIC_VECTOR
    }

    # clock port
    if { $params(GUI_PIPELINE) } {
        add_interface_port mult_input clock clock input 1
    }

    #ACLR port
    if { $params(GUI_PIPELINE) && $params(GUI_CLEAR_TYPE) eq "ACLR" } {
        add_interface_port mult_input aclr aclr input 1
    }
    
    #SCLR port
    if { $params(GUI_PIPELINE) && $params(GUI_CLEAR_TYPE) eq "SCLR" } {
        add_interface_port mult_input sclr sclr input 1
    }
    
        
    # clken / ena port
    if { $params(GUI_PIPELINE) && $params(GUI_CLKEN) } {
        if { $params(GUI_USE_MULT) == 1 } {
            add_interface_port mult_input  clken   clken   input   1
        } else {
            add_interface_port mult_input  ena     ena     input   1
        }
    }
	
	#Info messages: Show range of supported values for datab constant value
	if { $params(GUI_B_IS_CONSTANT) == "1"} {
	    #FOR UNSIGNED
        if { $params(GUI_SIGNED_MULT) == "0" } {
			send_message INFO "The supported value for 'Constant B' ranges from 0~2147483647"
			send_message INFO "If user enter a value beyond the range of 0~2147483647, an auto-corrected value will be displayed"
		}
        #FOR SIGNED
		if { $params(GUI_SIGNED_MULT) == "1" } {
		    send_message INFO "The supported value for 'Constant B' ranges from -2147483648~2147483647"
            send_message INFO "If user enter a value beyond the range of -2147483648~2147483647, an auto-corrected value will be displayed"
		}
	}
	
}


#+--------------------------------------------
#|
#|  IP UPGRADE
#|
#+--------------------------------------------
 proc parameter_upgrade_callback {ip_core_type version parameters} {
	set GUI_CLEAR_TYPE "NONE"
	set GUI_USE_MULT "0"
	set GUI_WIDTH_B "0"
	foreach { name value } $parameters {
		send_message INFO "PARAMETER WITH PREVIOUS VALUE -->$name $value $parameters"
		if { $name == "GUI_ACLR" } {
			set GUI_ACLR $value
			send_message INFO "Show OLD_PARAMETER WITH VALUE-->$name=$value"
			if {$GUI_ACLR == "true"} {
				set_parameter_value GUI_CLEAR_TYPE "ACLR"
				send_message INFO "GUI_CLEAR_TYPE -->ACLR"
			} elseif {$GUI_ACLR == "false"} {
				set_parameter_value GUI_CLEAR_TYPE "NONE"
				send_message INFO "GUI_CLEAR_TYPE -->NONE"
			#} else {
				#set_parameter_value GUI_CLEAR_TYPE "SCLR"
				#send_message INFO "GUI_CLEAR_TYPE -->SCLR"
			}
		} elseif {$name == "GUI_WIDTH_B"} {
			if { ([get_parameter_value GUI_USE_MULT] == 0)} {
				set_parameter_value GUI_WIDTH_B "0"
				send_message INFO "GUI_WIDTH_B-->0"
			} else {
				set_parameter_value $name $value
				send_message INFO "GUI_WIDTH_B default_value-->$name $value"
			}
		} else {
			set_parameter_value $name $value
			send_message INFO "SHOW OTHER PARAMETER: $name=$value"
		}
	}
}


#+--------------------------------------------
#|
#|  Quartus Synthesis / Verilog Simulation
#|
#+--------------------------------------------
proc do_quartus_synth {output_name} {
    set file_name ${output_name}.v
    set terp_path lpm_mult.v.terp
    set contents [gen_terp $terp_path $output_name]
    add_fileset_file $file_name VERILOG TEXT $contents
}


#+--------------------------------------------
#|
#|  VHDL Simulation
#|
#+--------------------------------------------
proc do_vhdl_sim {output_name} {
    set file_name ${output_name}.vhd
    set terp_path lpm_mult.vhd.terp
    set contents [gen_terp $terp_path $output_name]
    add_fileset_file $file_name VHDL TEXT $contents
}

## Add documentation links for user guide and/or release notes
add_documentation_link "Data Sheet" http://www.altera.com/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "User Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "User Guide For Stratix 10"  https://documentation.altera.com/#/link/kly1436148709581/kly1439175970736
add_documentation_link "Release Notes" https://www.intel.com/content/www/us/en/programmable/documentation/ktw1517822281214.html
