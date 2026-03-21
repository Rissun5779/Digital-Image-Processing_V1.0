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
package require altera_terp

#+-------------------------------------------
#|
#|  Source Files
#|
#+-------------------------------------------
source "clearbox.tcl"
source "csv_ui_loader.tcl"

#+--------------------------------------------
#|
#|  Module Property
#|
#+--------------------------------------------
set_module_property     NAME                    "altclkctrl"
set_module_property     AUTHOR                  "Intel Corporation"
set_module_property     VERSION                 18.1
set_module_property     DISPLAY_NAME            "ALTCLKCTRL Intel FPGA IP"
set_module_property     DATASHEET_URL           "http://www.altera.com/literature/ug/ug_altclock.pdf"
set_module_property     EDITABLE                false
set_module_property     ELABORATION_CALLBACK    elab
set_module_property     GROUP                   "Basic Functions/Clocks; PLLs and Resets"
set_module_property     HIDE_FROM_QSYS          true

set supported_device_families_list      {"Arria 10" "Cyclone 10 LP" "Arria II GX" "Arria II GZ" "Arria V" "Arria V GZ" "Cyclone IV E" "Cyclone IV GX" "Cyclone V" "Stratix IV" "Stratix V" "MAX 10 FPGA"}
set_module_property     SUPPORTED_DEVICE_FAMILIES   $supported_device_families_list


#+--------------------------------------------
#|
#|  Load the ui from CSV files
#|
#+--------------------------------------------
load_parameters "parameters.csv"
load_layout     "layout.csv"


#+--------------------------------------------
#|
#|  Elaboration callback
#|
#+--------------------------------------------
proc  elab  {}  {

    ##device information#
    set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."

    #add input and output interface#
    add_interface   altclkctrl_input   conduit     input
    add_interface   altclkctrl_output  conduit     output
    set_interface_assignment    altclkctrl_input   ui.blockdiagram.direction   input
    set_interface_assignment    altclkctrl_output  ui.blockdiagram.direction   output

    # get all parameter values#
    set params_list      [get_parameters]
    foreach param  $params_list {
        set param_temp  [string tolower $param]
        set $param_temp [get_parameter_value  $param]
    }
    
    #--------------------------------- DEVICE FAMILY EVALUATION ------------------------------------------#
    if {[check_device_family_equivalence $device_family {"Arria 10"}]} {  ;# Arria 10
        set_parameter_property  CLOCK_TYPE  ALLOWED_RANGES  {"0: Auto" "1: For global clock" "2: For regional clock" "5: For periphery clock" "6: For large periphery clock"}
        set_parameter_property  ENA_REGISTER_MODE   VISIBLE TRUE
    } elseif {[check_device_family_equivalence $device_family {"Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA" "Cyclone 10 LP"}]} {
        set_parameter_property  CLOCK_TYPE  ALLOWED_RANGES  {"1: For global clock" "4: For external path"}
        set_parameter_property  ENA_REGISTER_MODE   VISIBLE FALSE
    } else {
        set_parameter_property  CLOCK_TYPE  ALLOWED_RANGES  {"0: Auto" "1: For global clock" "2: For regional clock" "3: For dual regional clock" "4: For external path" "5: For periphery clock"}
        set_parameter_property  ENA_REGISTER_MODE   VISIBLE TRUE
    }

    #-------------------------------- CLOCK TYPE EVALUATION -----------------------------------------------#
    # ena register mode change based on clock type
    set_parameter_property  ENA_REGISTER_MODE   ALLOWED_RANGES  {"1: Falling edge of input clock" "2: Double register with input clock" "0: Not registered"}
    if {$clock_type ==1 || $clock_type ==0} {   ;# number of clocks based on clock type
        set_parameter_property  NUMBER_OF_CLOCKS    ALLOWED_RANGES  {1 2 3 4}
        if {$clock_type ==0} {  ;# Auto
            send_message    component_info   "Selecting AUTO allows the compiler to pick the best clock buffer to use, while other values restrict usage to only the given clock buffer."
        } else {    ;# global clock
            send_message    component_info  "Global clock network allows a clock signal to reach all parts of the chip with the same amount of skew. Input port \'clkselect\' can be used to switch between four clock inputs."
        }
    } else {
        set_parameter_property  NUMBER_OF_CLOCKS    ALLOWED_RANGES  {1}
        if {$clock_type==5} {   ;# use ena unavailable while clock mode: periphery clock
            if {$gui_use_ena} {
                send_message    error   "Create \'ena\' port is unavailable while using \'periphery clock\' type."
            }
            send_message    component_info  "Periphery clock network allows a clock signal to reach a region aligned with the source interface tile, and half the chip horizontally. Only one clock input is accepted."
        } elseif {$clock_type==4} {   ;# external path
            send_message    component_info  "External clock buffer represents the clock path from the outputs of the PLL to the dedicated clock output pins. Only one clock input is accepted."
            set_parameter_property  ENA_REGISTER_MODE   ALLOWED_RANGES  {"1: Falling edge of input clock" "0: Not registered"}
        } elseif {$clock_type==3} {     ;# dual regional
            send_message    component_info  "Regional clock network allows a clock signal to reach half of the chip by using two regional clocks to drive two quadrants. Only one clock input is accepted."
        } elseif {$clock_type==2} {     ;# regional
            send_message    component_info  "Regional clock network allows a clock signal to reach a quadrant of the chip. Only one clock input is accepted."
        } elseif {$clock_type==6} {     ;# large periphery
			if {$gui_use_ena} {
                send_message    error   "Create \'ena\' port is unavailable while using \'large periphery clock\' type."
            }
            send_message    component_info  "Large periphery clock network allows a clock signal to reach a region covering four interface tiles vertically, and half the chip horizontally. Only one clock input is accepted."
        }
    }

    # use glitch-free switch unavailable when one clock
    if {$number_of_clocks==1} {
        if {$use_glitch_free_switch_over_implementation} {
            send_message    error   "Implement a glitch-free switchover is unavailable while using one clock input."
        }
    }
    # specify the ena port mode when ena port created
    if {[get_parameter_property ENA_REGISTER_MODE VISIBLE]} {
        if {$gui_use_ena} {
            set_parameter_property  ENA_REGISTER_MODE   ENABLED TRUE
        } else {
            set_parameter_property  ENA_REGISTER_MODE   ENABLED FALSE
            send_message    component_info  "The register mode of port \'ena\' is unavailable while \'ena\' port not added. "
        }
    }
    
    #------------------------------------- PORTS (INCLK/CLKSELECT/ENA/OUTCLK) ------------------------------------------#
    add_interface_port  altclkctrl_output  outclk  outclk  output  1
    switch  -exact --  $number_of_clocks {
        1   {
                add_interface_port  altclkctrl_input    inclk   inclk   input   1   
        }
        2   {
                add_interface_port  altclkctrl_input    inclk1x inclk1x input   1
                add_interface_port  altclkctrl_input    inclk0x inclk0x input   1
                add_interface_port  altclkctrl_input    clkselect   clkselect   input   1
        }
        3   {
                add_interface_port  altclkctrl_input    inclk2x inclk2x input   1
                add_interface_port  altclkctrl_input    inclk1x inclk1x input   1
                add_interface_port  altclkctrl_input    inclk0x inclk0x input   1
                add_interface_port  altclkctrl_input    clkselect   clkselect   input   2
        }
        4   {
                add_interface_port  altclkctrl_input    inclk3x inclk3x input   1
                add_interface_port  altclkctrl_input    inclk2x inclk2x input   1
                add_interface_port  altclkctrl_input    inclk1x inclk1x input   1
                add_interface_port  altclkctrl_input    inclk0x inclk0x input   1
                add_interface_port  altclkctrl_input    clkselect   clkselect   input   2
        }
    }
    if {$gui_use_ena} {
        add_interface_port  altclkctrl_input    ena ena input   1
    }

    #------------------------------------ CHECK PARAMETER RANGE: ENA_REGISTER_MODE/CLOCK_TYPE -----------------------------------------#
    if {[get_parameter_property ENA_REGISTER_MODE   VISIBLE] && [get_parameter_property ENA_REGISTER_MODE ENABLED]} {
        set param_list  {CLOCK_TYPE ENA_REGISTER_MODE}
    } else {
        set param_list  {CLOCK_TYPE}
    }
    set state  [check_allowed_ranges    param_list]
    if {$state}  {
        send_message    error   "Failed in checking parameters($param_list) allowed ranges."
    }
    return 0

}

#+------------------------------------------------------------------
#|
#|  check_allowed_ranges  
#|
#+------------------------------------------------------------------
proc    check_allowed_ranges    {param_list_ref } {
    upvar $param_list_ref   param_list

    foreach param   $param_list {
        set param_value     [get_parameter_value    $param]
        set param_range     [get_parameter_property $param  ALLOWED_RANGES]
        set find    0
        foreach parameter   $param_range    {
            set temp_param  [string index $parameter 0]
            if {$temp_param==$param_value} {
                set find    1
            }
        }
        if {$find==0} {
            send_message    error   "The parameter($param) value ($param_value) is out of range!"
        }
    }
    return 0
}

#+------------------------------------------------------------------
#|
#|  Quartus synth
#|
#+------------------------------------------------------------------

add_fileset     quartus_synth       QUARTUS_SYNTH       do_quartus_synth
add_fileset     verilog_sim         SIM_VERILOG         do_quartus_synth
proc do_quartus_synth {output_name} {

    send_message    info    "Generating top-level entity $output_name."

    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file  [create_temp_file "parameter_list"]
    set cbx_var_file    [create_temp_file ${output_name}_sub.v]

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

    # pass variation file to terp to add clearbox wrapper
    set contents  [gen_wrapper_module verilog  $cbx_var_file $output_name]
    if {$contents eq ""} {
        send_message error "Failure in proc gen_wrapper_module, stopping synthesis fileset generation!"
        return
     }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.v  VERILOG TEXT $contents
}

#+-------------------------------------------------------------------------------------
#|
#|  Quartus simulation 
#|
#+-------------------------------------------------------------------------------------
add_fileset     vhdl_sim        SIM_VHDL        do_vhdl_sim

proc do_vhdl_sim {output_name} {
 
    send_message    info    "Generating top-level entity $output_name."

    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file  [create_temp_file "parameter_list"]
    set cbx_var_file    [create_temp_file ${output_name}_sub.vhd]

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

    # pass variation file to terp to add clearbox wrapper
    set contents  [gen_wrapper_module vhdl  $cbx_var_file $output_name]
    if {$contents eq ""} {
        send_message error "Failure in proc gen_wrapper_module, stopping synthesis fileset generation!"
        return
     }

    # Add the variation file to the fileset
    add_fileset_file ${output_name}.vhd  VHDL TEXT $contents

}           

#+-------------------------------------------------------------------------------------------
#|
#|  Parameters and ports transfer procedure
#|
#+-------------------------------------------------------------------------------------------
proc parameters_transfer {}   {

    #get all parameters#
    set device_family   [get_parameter_value   DEVICE_FAMILY]
    set param_list   [get_parameters]
    foreach param   $param_list    {
        set  param_arr($param)    [get_parameter_value  $param]
    }

    # set ena register mode
    set ena_mode_mapping    {
        0   "none"
        1   "falling edge"
        2   "double register"
    }
    if {[get_parameter_property ENA_REGISTER_MODE VISIBLE]} {
        if {[get_parameter_property  ENA_REGISTER_MODE ENABLED]} {
            foreach {type value} $ena_mode_mapping  {
                if {$param_arr(ENA_REGISTER_MODE) == $type} {
                    set param_arr(ENA_REGISTER_MODE)    $value
                }
            }
		} elseif {$param_arr(CLOCK_TYPE)==5 || $param_arr(CLOCK_TYPE)==6 } {
			# for pclk and large pclk, ena_register_mode can only be always enabled
			unset param_arr(ENA_REGISTER_MODE)
        } else {
            # always enabled is conveyed when the parameter value is unset
            unset param_arr(ENA_REGISTER_MODE)
        }
    } elseif {$param_arr(CLOCK_TYPE)==1} {
        set param_arr(ENA_REGISTER_MODE)    "falling edge"
    } elseif {[check_device_family_equivalence $device_family {"Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA" "Cyclone 10 LP"}] && $param_arr(CLOCK_TYPE)==4} {
        set param_arr(ENA_REGISTER_MODE)    "double register"
    } else {
        set param_arr(ENA_REGISTER_MODE)    "none"
    }
    # set clock type parameter
    set clock_type_mapping  {
        0   "AUTO"
        1   "Global Clock"
        2   "Regional Clock"
        3   "Dual-Regional Clock"
        4   "External Clock Output"
        5   "Periphery clock"
        6   "Large Periphery Clock"
    }
    foreach {type value}    $clock_type_mapping {
        if {$param_arr(CLOCK_TYPE) == $type} {
            set param_arr(clock_type)   $value
        }
    }
    # set use glitch free switch
    if {$param_arr(USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION)} {
        set param_arr(USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION)   "ON"
    } else {
        set param_arr(USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION)   "OFF"
    }

    # delete non-clearbox gui parameters
    foreach  delete_item    {GUI_USE_ENA NUMBER_OF_CLOCKS CLOCK_TYPE}        {
        unset  param_arr($delete_item)
    }

    # return translated cbx parameters
    set parameters_list     [array get param_arr]
    return $parameters_list
}

proc ports_transfer {}   {

    set ret_ports  {"ena" "inclk" "outclk"}
    set num_of_clocks   [get_parameter_value    NUMBER_OF_CLOCKS]
    if {$num_of_clocks==2} {
        lappend ret_ports   "clkselect" "inclk"
    } elseif {$num_of_clocks==3} {
        lappend ret_ports   "clkselect" "inclk" "inclk"
    } elseif {$num_of_clocks==4} {
        lappend ret_ports   "clkselect" "inclk" "inclk"
    }

    set ret_ports  [lsort -ascii $ret_ports]
    return $ret_ports
}


#+---------------------------------------------------------------------------------
#|
#|   add clearbox wrapper in the variation file
#|
#+---------------------------------------------------------------------------------
proc  gen_wrapper_module     {language var_file output_name}  {
    
    if {$language eq "verilog"}   {
        set terp_path    params_to_v.v.terp
    } else {
        set terp_path   params_to_vhd.vhd.terp
    }
    set terp_fd     [open   $terp_path]
    set terp_contents   [read $terp_fd]
    close $terp_fd

    # set ports_list and ports_tri_list #
    set ports_list   [list   ]
    set ports_tri_list  [list   ]
    set use_ena     [get_parameter_value    GUI_USE_ENA]
    set num_clock   [get_parameter_value    NUMBER_OF_CLOCKS]

    if {$use_ena} {
        lappend ports_tri_list  "ena"   1   -1
        lappend ports_list  "ena"   "IN"    -1  1
    }
    switch  -exact --  $num_clock {
        1   {
                lappend ports_list  "inclk" "IN"    -1  -1
        }
        2   {
                lappend ports_list  "clkselect" "IN"    -1  0
                lappend ports_list  "inclk0x"   "IN"    -1  -1
                lappend ports_list "inclk1x"    "IN"    -1  -1
                lappend ports_tri_list  "clkselect"   0   -1
        }
        3   {
                lappend ports_list  "clkselect" "IN"    1   0
                lappend ports_list  "inclk0x"   "IN"    -1  -1
                lappend ports_list  "inclk1x"   "IN"    -1  -1
                lappend ports_list  "inclk2x"   "IN"    -1  -1
                lappend ports_tri_list  "clkselect"   0   1
        }
        4   {
                lappend ports_list  "clkselect" "IN"    1   0
                lappend ports_list  "inclk0x"   "IN"    -1  -1
                lappend ports_list  "inclk1x"   "IN"    -1  -1
                lappend ports_list  "inclk2x"   "IN"    -1  -1
                lappend ports_list  "inclk3x"   "IN"    -1  -1
                lappend ports_tri_list  "clkselect"   0   1
        }
    }
    lappend ports_list  "outclk"   "OUT"   -1    -1

    # set wire_list and port_map_list
    set wire_num   0
    set wire_list   [list   ]
    set sub_wire_list   [list   ]
    set port_map_list   [list   ]
    lappend wire_list   "sub_wire$wire_num"   "none"    -1
    lappend wire_list   "outclk"              "sub_wire$wire_num"   -1
    lappend sub_wire_list   "sub_wire$wire_num" -1  -1
    incr wire_num
    # for port clkselect
    switch   -exact  --  $num_clock {
        1   {
            # No clkselect when num_clock is 1
        }
        2   {
            lappend wire_list   "sub_wire$wire_num"   "clkselect"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1   -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num"     "\{sub_wire[expr $wire_num+1], sub_wire[expr $wire_num-1]\}"    1
            lappend sub_wire_list   "sub_wire$wire_num" -1   1
            lappend port_map_list   "clkselect" "sub_wire$wire_num"
            incr wire_num
            lappend wire_list   "sub_wire$wire_num"   "1'h0"    0
            lappend sub_wire_list   "sub_wire$wire_num" 1   0
            incr wire_num
        }
        3   -
        4   {
            lappend port_map_list   "clkselect" "clkselect"
        }
    }
    # for port ena
    if {$use_ena} {
        lappend port_map_list   "ena" "ena"  
    } else {
        lappend wire_list   "sub_wire$wire_num"   "1'h1"  -1
        lappend sub_wire_list   "sub_wire$wire_num" -1  -1
        lappend port_map_list   "ena" "sub_wire$wire_num"
        incr wire_num
    }
    # for port inclk
    switch   -exact  --  $num_clock {
        1   {
            lappend wire_list   "sub_wire$wire_num"   "inclk"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "\{sub_wire[expr $wire_num+1], sub_wire[expr $wire_num-1]\}"    3
            lappend sub_wire_list   "sub_wire$wire_num" -1  3
            lappend port_map_list   "inclk"   "sub_wire$wire_num"
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "3'h0"  2
            lappend sub_wire_list   "sub_wire$wire_num" 1  2
            incr wire_num
        }
        2   {
            lappend wire_list   "sub_wire$wire_num"   "inclk0x" -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num"     "\{sub_wire[expr $wire_num+2], sub_wire[expr $wire_num+1], sub_wire[expr $wire_num-1]\}"    3
            lappend sub_wire_list   "sub_wire$wire_num" -1  3
            lappend port_map_list   "inclk" "sub_wire$wire_num"
            incr wire_num
            lappend wire_list   "sub_wire$wire_num"   "inclk1x"  -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num"   "2'h0"  1
            lappend sub_wire_list   "sub_wire$wire_num" 1  1
        }
        3   {
            lappend wire_list   "sub_wire$wire_num" "inclk0x"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "\{sub_wire[expr $wire_num+3], sub_wire[expr $wire_num+2], sub_wire[expr $wire_num+1], sub_wire[expr $wire_num-1]\}"    3
            lappend sub_wire_list   "sub_wire$wire_num" -1  3
            lappend port_map_list   "inclk" "sub_wire$wire_num"
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "inclk1x"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "inclk2x"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "1'h0"  0
            lappend sub_wire_list   "sub_wire$wire_num" 1  0
            incr wire_num
        }
        4   {
            lappend wire_list   "sub_wire$wire_num" "inclk0x"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "\{sub_wire[expr $wire_num+3], sub_wire[expr $wire_num+2], sub_wire[expr $wire_num+1], sub_wire[expr $wire_num-1]\}"    3
            lappend sub_wire_list   "sub_wire$wire_num" -1  3
            lappend port_map_list   "inclk" "sub_wire$wire_num"
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "inclk1x"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num   
            lappend wire_list   "sub_wire$wire_num" "inclk2x"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
            lappend wire_list   "sub_wire$wire_num" "inclk3x"   -1
            lappend sub_wire_list   "sub_wire$wire_num" -1  -1
            incr wire_num
        }
    }
    # for port outclk
    lappend port_map_list   "outclk"    "sub_wire0"

    set params_terp(ports_list)     $ports_list
    set params_terp(ports_tri_list) $ports_tri_list
    set params_terp(module_name)    ${output_name}_sub
    set params_terp(output_name)    $output_name
    set params_terp(wire_list)      $wire_list
    set params_terp(sub_wire_list)  $sub_wire_list
    set params_terp(port_map_list)  $port_map_list
	set params_terp(num_clock)		$num_clock
    set contents    [altera_terp    $terp_contents  params_terp]

    # open and read clearbox generated submodule variation file
    set fid_cbx [open $var_file r]
    set cbx_content   [read $fid_cbx]
    close $fid_cbx

    #return  both submodule and topmodule contents
    set contents [concat $cbx_content $contents]

    return $contents
}

#+---------------------------------------------------------------------------------
#|
#|   get_module_name
#|
#+---------------------------------------------------------------------------------
proc    get_module_name {var_file_ref}  {

    set fid [open $var_file_ref r]
    set file_content   [read $fid]
    set file_lines  [split $file_content "\n"]
    close $fid

    set module_name ""
    foreach line    $file_lines {
        set file_data   [split $line]
        set module_id   [lsearch -exact $file_data  "module"]
        if {$module_id >=0} {
            set module_name [lindex $file_data [expr {$module_id+2}]]
            break;
        }
    }
    return $module_name
}
#+---------------------------------------------------------------------------------
#|
#|   process generate_clearbox_parameter_file and do_clearbox_gen
#|   file clearbox.tcl
#|
#+---------------------------------------------------------------------------------


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_altclock.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697740509
