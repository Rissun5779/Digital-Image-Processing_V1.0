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


package require -exact qsys 16.0
package require altera_terp

set_module_property NAME                        "stratix10_clkctrl"
set_module_property DISPLAY_NAME                "Stratix 10 Clock Control"
set_module_property EDITABLE                    false
set_module_property VERSION                     18.1
set_module_property AUTHOR                      "Altera Corporation"
set_module_property GROUP                       "Basic Functions/Clocks; PLLs and Resets"
set_module_property HIDE_FROM_QSYS              true
set_module_property SUPPORTED_DEVICE_FAMILIES   {"Stratix 10"}
set_module_property DESCRIPTION                 "<html>Allows signals to use the clock network in the device.</html>"
set_module_property ELABORATION_CALLBACK        elab
set_module_property PARAMETER_UPGRADE_CALLBACK  parameter_upgrade_callback


set migration_supported_versions {13.0 13.1 14.0 14.1 15.0 15.1 16.0, 16.1, 17.0, 17.1}
set migration_supported_families {"Arria 10" "Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "MAX 10 FPGA" "Cyclone IV E" "Cyclone IV GX" "Stratix IV"}
set migration_upgrade_list {}
foreach iver $migration_supported_versions {
    foreach ifam $migration_supported_families {
        lappend migration_upgrade_list "altclkctrl"
        lappend migration_upgrade_list $iver
        lappend migration_upgrade_list $ifam
    }
}
set_module_property UPGRADEABLE_FROM $migration_upgrade_list

proc def_gui {} {

    add_display_item "Stratix 10 Clock Control" "Clock Input Muxing" GROUP
    add_display_item "Clock Input Muxing" "Description 1" TEXT "<html>Number of Clock Inputs \
implements soft dynamic switchover logic which can be optionally<br>made glitch free using additional soft logic.</html>"
    add_display_item "Clock Input Muxing" NUM_CLOCKS PARAMETER
    add_parameter NUM_CLOCKS INTEGER 1
    set_parameter_property NUM_CLOCKS DISPLAY_NAME "Number of Clock Inputs"

    add_display_item "Clock Input Muxing" GLITCH_FREE_SWITCHOVER PARAMETER
    add_parameter GLITCH_FREE_SWITCHOVER BOOLEAN FALSE
    set_parameter_property GLITCH_FREE_SWITCHOVER DISPLAY_NAME "Ensure glitch free clock switchover"
    
    
    add_display_item "Stratix 10 Clock Control" "Clock Gating" GROUP
    
    add_display_item "Clock Gating" "Description 2" TEXT "<html>Allow gating of clocks at the falling edge of the enable or unregistered.\
    The unregistered<br>mode is only supported by the Distributed Sector Level Gates.</html>"
    add_display_item "Clock Gating" ENABLE PARAMETER
    add_parameter ENABLE BOOLEAN FALSE
    set_parameter_property ENABLE DISPLAY_NAME "Clock Enable"

    add_display_item "Clock Gating" ENABLE_TYPE PARAMETER
    add_parameter ENABLE_TYPE INTEGER 2
    set_parameter_property ENABLE_TYPE DISPLAY_NAME "Clock Enable Type"

    add_display_item "Clock Gating" ENABLE_REGISTER_TYPE PARAMETER
    add_parameter ENABLE_REGISTER_TYPE INTEGER 1
    set_parameter_property ENABLE_REGISTER_TYPE DISPLAY_NAME "Enable Register Mode"

    
    add_display_item "Stratix 10 Clock Control" "Clock Output Division" GROUP

    add_display_item "Clock Output Division" "Description 3" TEXT "<html>Allows signals to be divided by 1x, 2x and 4x and then enter the clock network.</html>"

    add_display_item "Clock Output Division" CLOCK_DIVIDER PARAMETER
    add_parameter CLOCK_DIVIDER BOOLEAN FALSE
    set_parameter_property CLOCK_DIVIDER DISPLAY_NAME "Clock Divider"
    
    add_display_item "Clock Output Division" CLOCK_DIVIDER_OUTPUTS PARAMETER
    add_parameter CLOCK_DIVIDER_OUTPUTS INTEGER 1
    set_parameter_property CLOCK_DIVIDER_OUTPUTS DISPLAY_NAME "Clock Divider Output Ports"
}

proc parameter_upgrade_callback {ip_core_type version parameters} {
    send_message INFO "ip: $ip_core_type version: $version"
    set_interface_upgrade_map {altclkctrl_input clkctrl_input altclkctrl_output clkctrl_output}
    foreach { name value } $parameters {
        switch -exact -- $name {
            NUMBER_OF_CLOCKS {
                send_message INFO "Set number of clocks to $value"
                if {$value == 3} {
                    set_parameter_value NUM_CLOCKS 4
                } else {
                    set_parameter_value NUM_CLOCKS $value
                }
            }
            USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION {
                send_message INFO "Enabling glitch free switchover"
                set_parameter_value GLITCH_FREE_SWITCHOVER $value
            }
            GUI_USE_ENA {
                send_message INFO "IP will have a clock enable"
                set_parameter_value ENABLE $value
                set_parameter_value ENABLE_TYPE 2
            }
            DEVICE_FAMILY {
                # Only supports Stratix 10. Nothing to convert
            }
            ENA_REGISTER_MODE {
                switch -exact -- $value {
                    1 {
                        send_message INFO "Clock enable register set to falling edge mode"
                        set_parameter_value ENABLE_REGISTER_TYPE 1
                    }
                    2 {
                        send_message ERROR "Stratix 10 does not support double registered mode for the clock enable"
                        send_message ERROR "Please choose either falling edge or no registered mode"
                    }
                    0 {
                        send_message INFO "Clock enable register set to no register mode"
                        set_parameter_value ENABLE_REGISTER_TYPE 2
                    }
                    default {
                        send_message ERROR "Unrecognized value for parameter ENA_REGISTER_MODE"
                    }
                }
            }
            CLOCK_TYPE {
                # Ignore clock type parameter because Stratix 10 does not have any clock types.
            }
            default {
                send_message ERROR "Unrecognized parameter $name with value $value"
            }
        }
    }
}

proc elab {}  {
    add_interface   clkctrl_input   conduit     input
    add_interface   clkctrl_output  conduit     output
    set_interface_assignment    clkctrl_input   ui.blockdiagram.direction   input
    set_interface_assignment    clkctrl_output  ui.blockdiagram.direction   output

    set_parameter_property  NUM_CLOCKS    ALLOWED_RANGES  {1 2 4}
    set_parameter_property ENABLE_TYPE ALLOWED_RANGES {"1: Root Level" "2: Distributed Sector Level"}
    set_parameter_property ENABLE_REGISTER_TYPE ALLOWED_RANGES {"1: Falling Edge" "2: No Register"}
    set_parameter_property CLOCK_DIVIDER_OUTPUTS ALLOWED_RANGES {"1: Divide 1x" "2: Divide 1x and 2x" "3: Divide 1x, 2x and 4x"}

    set clock_enable [get_parameter_value ENABLE]
    set clock_divide [get_parameter_value CLOCK_DIVIDER]
    set num_clocks [get_parameter_value NUM_CLOCKS]
    set glitch_free [get_parameter_value GLITCH_FREE_SWITCHOVER]

    set_parameter_property ENABLE ENABLED true
    set_parameter_property ENABLE_TYPE ENABLED false
    set_parameter_property ENABLE_REGISTER_TYPE ENABLED false
    set_parameter_property CLOCK_DIVIDER ENABLED true
    set_parameter_property CLOCK_DIVIDER_OUTPUTS ENABLED false

    if {$num_clocks > 1} {
        set_parameter_property GLITCH_FREE_SWITCHOVER ENABLED true
    } else {
        set_parameter_property GLITCH_FREE_SWITCHOVER ENABLED false
    }

    if { $clock_enable } {
        set_parameter_property CLOCK_DIVIDER ENABLED false
        set_parameter_property ENABLE_TYPE ENABLED true
        set_parameter_property ENABLE_REGISTER_TYPE ENABLED true
        send_message INFO "Clock Division has been disabled. Uncheck clock gating in the 'Clocks and Gating' tab to access Clock Division."
        add_interface_port  clkctrl_input    ena   ena   input   1

        set enable_type [get_parameter_value ENABLE_TYPE]
        set enable_register_type [get_parameter_value ENABLE_REGISTER_TYPE]
        if {$enable_type == 1 && $enable_register_type == 2} {
            send_message ERROR "No register mode is incompatible with Root Level Gate. Change to Sector Level Gate or choose Falling Edge enable mode"
        }
    } elseif { $clock_divide } {
        set_parameter_property ENABLE ENABLED false
        set_parameter_property CLOCK_DIVIDER ENABLED true
        set_parameter_property CLOCK_DIVIDER_OUTPUTS ENABLED true
        send_message INFO "Clock Gating has been disabled. Uncheck Clock Division in the 'Clock Output Division' tab to access it again."
    }

    if { $clock_divide } {
        set num_outputs [get_parameter_value CLOCK_DIVIDER_OUTPUTS]
        switch -exact -- $num_outputs {
            1   {
                    add_interface_port clkctrl_output clock_div1x clock_div1x output 1
            }
            2   {
                    add_interface_port clkctrl_output clock_div1x clock_div1x output 1
                    add_interface_port clkctrl_output clock_div2x clock_div2x output 1
            }
            3   {
                    add_interface_port clkctrl_output clock_div1x clock_div1x output 1
                    add_interface_port clkctrl_output clock_div2x clock_div2x output 1
                    add_interface_port clkctrl_output clock_div4x clock_div4x output 1
            }
        }
    } else {
        add_interface_port clkctrl_output outclk outclk output 1
    }

    switch  -exact --  $num_clocks {
        1   {
                add_interface_port  clkctrl_input    inclk   inclk   input   1   
        }
        2   {
                add_interface_port  clkctrl_input    inclk0x   inclk0x   input   1
                add_interface_port  clkctrl_input    inclk1x   inclk1x   input   1
                add_interface_port  clkctrl_input    clkselect clkselect input   1
        }
        4   {
                add_interface_port  clkctrl_input    inclk0x   inclk0x   input   1
                add_interface_port  clkctrl_input    inclk1x   inclk1x   input   1
                add_interface_port  clkctrl_input    inclk2x   inclk2x   input   1
                add_interface_port  clkctrl_input    inclk3x   inclk3x   input   1
                add_interface_port  clkctrl_input    clkselect clkselect input   2
        }
    }
}

###############################################################################################
#
# Code generation                                                                             
#
###############################################################################################
add_fileset     quartus_synth       QUARTUS_SYNTH       do_quartus_synth
add_fileset     verilog_sim         SIM_VERILOG         do_verilog_sim
add_fileset     vhdl_sim            SIM_VHDL            do_vhdl_sim

proc do_quartus_synth {output_name} {
    # Description:
    #   Generates the Verilog and SDC files 
    # Inputs:
    #    - output_name : Module name 

    # Name of RTL file
    set hdl_name "$output_name.v"
    set clock_divide [get_parameter_value CLOCK_DIVIDER]

    # Generate the RTL module
    set contents [gen_module 1 0 $output_name]
    add_fileset_file $hdl_name VERILOG TEXT $contents

    # Generate the clock divider SDC if necessary
    if {$clock_divide} {
        generate_sdc_related_files $output_name
    }
}

proc do_verilog_sim { output_name } {
    set contents [gen_module 1 1 $output_name]
    add_fileset_file ${output_name}.v  VERILOG TEXT $contents
}

proc gen_module { verilog for_simulation output_name } {
    send_message    info    "Generating top-level entity $output_name."

    set num_clocks [get_parameter_value NUM_CLOCKS]
    set clock_enable [get_parameter_value ENABLE]
    set enable_register_type [get_parameter_value ENABLE_REGISTER_TYPE]
    set clock_divide [get_parameter_value CLOCK_DIVIDER]
    set contents {}
    set input_ports [get_interface_ports clkctrl_input]
    set output_ports [get_interface_ports clkctrl_output]
    set enable_type [get_parameter_value ENABLE_TYPE]

    set ports_list {}
    set wire_list {}
    foreach port $input_ports {
        set dir "IN"
        if {$verilog} {
            set dir "input"
        }
        set width [get_port_property $port WIDTH_VALUE]
        lappend ports_list $port $dir $width
    }
    foreach port $output_ports {
        set dir "OUT"
        if {$verilog} {
            set dir "output"
        }
        set width [get_port_property $port WIDTH_VALUE]
        lappend ports_list $port $dir $width
    }

    if { !($clock_enable || $clock_divide || $for_simulation) } {
        set params_terp(global_primitive) true
    } else {
        set params_terp(global_primitive) false
    }

    lappend wire_list "inclk_muxout" "wire" 0

    if {[get_parameter_value GLITCH_FREE_SWITCHOVER] && $num_clocks > 1} {
        set params_terp(glitch_free) true   
    } else {
        set params_terp(glitch_free) false
    }

    set params_terp(ports_list)             $ports_list
    set params_terp(wire_list)              $wire_list
    set params_terp(output_name)            $output_name
    set params_terp(clock_enable)           $clock_enable
    set params_terp(enable_register_type)   $enable_register_type
    set params_terp(clock_divide)           $clock_divide
    set params_terp(num_clocks)             $num_clocks
    set params_terp(enable_type)            $enable_type

    set contents {}
    if { $verilog } {
        set terp_fd     [open   "clocks_v.v.terp"]
        set terp_contents   [read $terp_fd]
        set contents    [altera_terp    $terp_contents  params_terp]
        send_message INFO "Verilog entity generation was successful"
    } else {
        set terp_fd [open "clocks_vhd.vhd.terp"]
        set terp_contents [read $terp_fd]
        set contents [altera_terp $terp_contents params_terp]
        send_message INFO "VHDL entity generation was successful"
    }

    return $contents
}

proc do_vhdl_sim { output_name } {
    set contents [gen_module 1 1 $output_name]
    add_fileset_file ${output_name}.vo  VERILOG TEXT $contents
}

proc generate_sdc_related_files {output_name} {
    # Description:
    #   Generates SDC-related files 
    # Inputs:
    #    - output_name : Module name 

    # Name and location of parameters file
    set param_name "${output_name}_parameters.tcl"
    set param_location [create_temp_file $param_name]

    # Number of output clocks
    set out_clocks [get_parameter_value CLOCK_DIVIDER_OUTPUTS]
    
    # Generate parameters file
    if {[ catch {open $param_location w} fid ]} {
        send_message ERROR "Clock Divider SDC Generation: Couldn't open file '$param_location' for writing: $fid"
    } else {
        # Write clock divider parameters
        puts $fid "# Clock Divider Parameters"
        puts $fid ""
        puts $fid "# The clock divider parameters are statically defined in this file at generation time!"
        puts $fid "# To ensure timing constraints and timing reports are correct, when you make any changes"
        puts $fid "# to the clock divider component using Qsys, apply those changes to the clock divider" 
        puts $fid "# parameters in this file"
        puts $fid ""
        puts $fid "set ::GLOBAL_${output_name}_core $output_name"
        puts $fid ""
        puts $fid "set ::GLOBAL_${output_name}_out_clocks $out_clocks"
        
        close $fid

        add_fileset_file $param_name OTHER PATH $param_location
    }
    
    parse_tcl_params $output_name "altera_clkdiv.sdc"
}

proc parse_tcl_params {output_name input_name} {
    # Description:
    #   Replaces all occurances of "altera_clkdiv" with the name of the module
    #   Called by generate_sdc_related_files
    #
    # Inputs : 
    #    - output_name : Module name
    #    - input_name  : Name of file to be parsed

    # Name and location of SDC file
    set sdc_name [string map "altera_clkdiv ${output_name}" $input_name]
    set sdc_location [create_temp_file [string map "altera_clkdiv ${output_name}_temp" $input_name]]
    
    if {[catch {open $sdc_location w} outfile]} {
        send_message ERROR "Clock Divider SDC Generation: Couldn't open file '$sdc_location' for writing: $outfile"
    } else {
        if {[catch {open $input_name r} infile]} {
            send_message ERROR "parse_tcl_params{}: Couldn't open file '$input_name' for writing: $infile"
            close $outfile
        } else {
            # Replace all occurances of "altera_clkdiv" with the name of the module
            while {[gets $infile line] != -1} {
                puts $outfile [string map "altera_clkdiv $output_name" $line]
            }

            close $infile
            close $outfile

            add_fileset_file $sdc_name SDC PATH $sdc_location
        }
    }
}

def_gui
