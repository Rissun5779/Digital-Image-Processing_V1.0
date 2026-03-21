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
set_module_property   NAME         "lpm_decode"
set_module_property   AUTHOR       "Altera Corporation"
set_module_property   DESCRIPTION  "lpm_decode"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "LPM_DECODE"
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
#|  'General' tab
#|
#+--------------------------------------------
set width_range [list]
for {set i 1}   {$i<=8} {incr i}    {
    lappend width_range $i
}
#input data width#
add_parameter           GUI_LPM_WIDTH    positive           4	
set_parameter_property  GUI_LPM_WIDTH    DISPLAY_NAME	"How wide should the 'data' input bus be? "
set_parameter_property  GUI_LPM_WIDTH    DISPLAY_UNITS	"bits"
set_parameter_property  GUI_LPM_WIDTH    GROUP		"General"
set_parameter_property  GUI_LPM_WIDTH    AFFECTS_GENERATION  true
set_parameter_property  GUI_LPM_WIDTH    ALLOWED_RANGES      $width_range
set_parameter_property  GUI_LPM_WIDTH    DESCRIPTION	"Specifies the width of input buses (Range of allowed values: 1 - 8)."


#+--------------------------------------------
#|
#|  'Optional port' Tab
#|
#+--------------------------------------------

add_parameter           GUI_USE_ENABLE      boolean         false
set_parameter_property  GUI_USE_ENABLE      DISPLAY_NAME    "Create an Enable input?"
set_parameter_property  GUI_USE_ENABLE      GROUP           "General"

#+--------------------------------------------
#|
#|  'eq' output Tab
#|
#+--------------------------------------------
#grouping#
add_display_item   "Which 'eq' outputs would you like to decode?"  "Decode table"  GROUP TABLE
add_display_item   "Which 'eq' outputs would you like to decode?"  "<< Add all"    ACTION "add_all"
add_display_item   "Which 'eq' outputs would you like to decode?"  ">> Remove all" ACTION "remove_all"
add_display_item   "Which 'eq' outputs would you like to decode?"  GUI_RADIX        PARAMETER


#lpm decode#
set decode_list         [list ]
set decode_default_list [list]
for {set j 0}   {$j<=15}  {incr j}    {
    lappend     decode_list         $j
}
for {set i 0}   {$i<=255}   {incr i}    {
    lappend     decode_default_list "No"
}

add_parameter               TEXT                string_list         $decode_list
set_parameter_property      TEXT                DERIVED             true
set_parameter_property      TEXT                DISPLAY_NAME        "\'eq\' ports"
add_parameter               GUI_LPM_DECODES_VALUE   string_list         $decode_default_list 
set_parameter_property      GUI_LPM_DECODES_VALUE   DISPLAY_NAME        "(Select one or more)"
set_parameter_property      GUI_LPM_DECODES_VALUE   ALLOWED_RANGES      {"No" "Yes"}
add_display_item            "Decode table"      TEXT    PARAMETER
add_display_item            "Decode table"      GUI_LPM_DECODES_VALUE   PARAMETER
set_display_item_property   TEXT                DISPLAY_HINT        fixed_size
set_display_item_property   GUI_LPM_DECODES_VALUE   DISPLAY_HINT        fixed_size


#radix change#
add_parameter           GUI_RADIX    integer         0
set_parameter_property  GUI_RADIX    DISPLAY_NAME    "Radix"
set_parameter_property  GUI_RADIX    ALLOWED_RANGES  {"0:Decimal" "1:Hex"}
set_parameter_property  GUI_RADIX    DISPLAY_HINT    radio 
set_parameter_property  GUI_RADIX    AFFECTS_GENERATION  true

#radix change procedure#
proc add_all {} {
    set_parameter_value GUI_LPM_DECODES_VALUE [string repeat "Yes " 256]
}
proc remove_all {} {
    set_parameter_value GUI_LPM_DECODES_VALUE  [string repeat "No " 256]
}

#lpm decodes#
add_parameter           LPM_DECODES     integer     16
set_parameter_property  LPM_DECODES     VISIBLE     false
set_parameter_property  LPM_DECODES     DERIVED     true
set_parameter_property  LPM_DECODES     AFFECTS_GENERATION  true

#eq ports num#
add_parameter           EQ_PORT_NUM     integer     0
set_parameter_property  EQ_PORT_NUM     VISIBLE     false
set_parameter_property  EQ_PORT_NUM     DERIVED     true
set_parameter_property  EQ_PORT_NUM     AFFECTS_GENERATION  true

add_parameter           EQ_PORT_NUM_LIST    integer_list    
set_parameter_property  EQ_PORT_NUM_LIST    VISIBLE false
set_parameter_property  EQ_PORT_NUM_LIST    DERIVED true
set_parameter_property  EQ_PORT_NUM_LIST    AFFECTS_GENERATION  true


#+--------------------------------------------
#|
#|  'Pipelining' tab
#|
#+--------------------------------------------
#pipeline#
add_parameter           GUI_LATENCY    integer         0
set_parameter_property  GUI_LATENCY    DISPLAY_NAME    "Output latency"
set_parameter_property  GUI_LATENCY    GROUP           "Do you want to pipeline the function?"
set_parameter_property  GUI_LATENCY    ALLOWED_RANGES  {"0:No" "1:Yes"}
set_parameter_property  GUI_LATENCY    DISPLAY_HINT    radio

#output latency#
add_parameter           GUI_LPM_PIPELINE    positive        1
set_parameter_property  GUI_LPM_PIPELINE    DISPLAY_NAME    "I want an output latency of "    
set_parameter_property  GUI_LPM_PIPELINE    GROUP           "Do you want to pipeline the function?"
set_parameter_property  GUI_LPM_PIPELINE    DISPLAY_UNITS   "clock cycles"
set_parameter_property  GUI_LPM_PIPELINE    AFFECTS_GENERATION  true


#aclr port#
add_parameter           GUI_USE_ACLR    boolean         false
set_parameter_property  GUI_USE_ACLR    DISPLAY_NAME    "Create an asynchronous Clear input?"
set_parameter_property  GUI_USE_ACLR    GROUP           "Do you want to pipeline the function?"
set_parameter_property  GUI_USE_ACLR    DESCRIPTION     "Select to add the asynchronous clear port."

#clken port#
add_parameter           GUI_USE_CLKEN   boolean         false
set_parameter_property  GUI_USE_CLKEN   DISPLAY_NAME    "Create a Clock Enable input?"
set_parameter_property  GUI_USE_CLKEN   GROUP           "Do you want to pipeline the function?"
set_parameter_property  GUI_USE_CLKEN   DESCRIPTION     "Select to add the clock enable port."


#ports list#
add_parameter           PORT_LIST    string_list
set_parameter_property  PORT_LIST    VISIBLE        false
set_parameter_property  PORT_LIST    DERIVED        true
set_parameter_property  PORT_LIST    AFFECTS_GENERATION  true

#+----------------------------------------------------------------------------------------------------------------------
#|
#|  Elaboration callback
#|
#+-----------------------------------------------------------------------------------------------------------------------
set_module_property     ELABORATION_CALLBACK    elab

proc    elab {}  {

    ##device information#
    set device_family   [get_parameter_value   DEVICE_FAMILY]
        send_message    COMPONENT_INFO        "Targeting device family: $device_family."

    #lpm width#
    set lpm_width    [get_parameter_value   GUI_LPM_WIDTH]
    if {$lpm_width<1 ||$lpm_width>8}    {
        send_message    error      "Number of bits must be in the range 1 to 8!"
        set max_eq_ports    1
    }   else    {
        set max_eq_ports     [expr   {pow(2,$lpm_width)-1}]
    }

    #set input interface#
    add_interface       decode_input    conduit     input
    add_interface_port  decode_input    data        data  input   $lpm_width

    #set output interface#
    add_interface       decode_output   conduit     output
    set_interface_assignment   decode_output         ui.blockdiagram.direction    output

    #radix change#
    set eq_port_hex     [list ]
    set eq_port_dec     [list ]
    for {set i 0}   {$i<=$max_eq_ports}  {incr i}    {
        lappend     eq_port_dec     $i
        lappend     eq_port_hex     [string toupper [format %0X $i]]
    }
    #add eq output ports#
    set eq_ports_list   [get_parameter_value    GUI_LPM_DECODES_VALUE]
    set radix_value     [get_parameter_value    GUI_RADIX]
    set eq_port_num     0
    set eq_port_num_list    [list ]
    if {$radix_value}   {
        set_parameter_value     TEXT    $eq_port_hex
        for {set i 0}   {$i<=$max_eq_ports}  {incr i}    {
            if {[lindex $eq_ports_list $i] eq "Yes"}    {
                set value_hex    [string toupper [format %0X $i]]
                add_interface_port  decode_output   eq$value_hex    eq$value_hex   output  1
                incr    eq_port_num
                lappend eq_port_num_list    $i
            }
        }
    } else  {
        set_parameter_value     TEXT    $eq_port_dec
        for {set i 0}   {$i<=$max_eq_ports}  {incr i}    {
            if {[lindex $eq_ports_list $i] eq "Yes"}    {
                add_interface_port  decode_output   eq$i    eq$i   output  1
                incr    eq_port_num
                lappend eq_port_num_list    $i
            }
        }
    }
    set eq_port_num_list    [lsort $eq_port_num_list]
    set_parameter_value     EQ_PORT_NUM     $eq_port_num
    set_parameter_value     EQ_PORT_NUM_LIST    $eq_port_num_list
    set_parameter_value     LPM_DECODES     [expr   {$max_eq_ports+1}]

    #get ports list#
    set port_list   [list]
    lappend port_list data
    if {$eq_port_num}   {
        lappend port_list "eq"
    }

    #optional ports#
    #enable#
    set add_enable      [get_parameter_value  GUI_USE_ENABLE]
    if  {$add_enable}   {
        add_interface_port  decode_input    enable  enable input  1
        lappend port_list enable
    }

    #clock#
    set add_clock       [get_parameter_value  GUI_LATENCY]
    if  {$add_clock}    {
        add_interface_port  decode_input    clock   clk   input    1
        lappend port_list clock

        #aclr#
        set add_aclr       [get_parameter_value  GUI_USE_ACLR]
        if  {$add_aclr}    {
            add_interface_port  decode_input    aclr    aclr  input  1
            lappend port_list aclr
        }
        #clken#
        set add_clken      [get_parameter_value  GUI_USE_CLKEN]
        if  {$add_clken}   {
            add_interface_port  decode_input    clken   clken  input  1
            lappend port_list clken
        }
     } else {
        set lpm_pipeline    [get_parameter_value    GUI_LPM_PIPELINE]
        set use_aclr        [get_parameter_value    GUI_USE_ACLR]
        set use_clken       [get_parameter_value    GUI_USE_CLKEN]
        if {$lpm_pipeline!=1} {
            send_message    error   "Cann't choose clock cycles while not using pipeline function. Please reset to default:1."
        }
        if {$use_aclr} {
            send_message    error   "Cann't create asynchronous clear input while not using pipeline function."
        }
        if {$use_clken} {
            send_message    error   "Cann't create clken input while not using pipeline function."
        }
     }
     set port_list  [lsort -ascii $port_list]
     set_parameter_value    PORT_LIST   $port_list

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
        set params(port_list)   [get_parameter_value    PORT_LIST]
        set params(radix)       [get_parameter_value    GUI_RADIX]
        set params(eq_port_num) [get_parameter_value    EQ_PORT_NUM]
        set params(lpm_width)   [get_parameter_value    GUI_LPM_WIDTH]
        set params(lpm_decodes) [get_parameter_value    LPM_DECODES]
        set params(latency)     [get_parameter_value    GUI_LATENCY]
        set params(eq_port_num_list)    [get_parameter_value    EQ_PORT_NUM_LIST]
        set params(lpm_pipeline)        [get_parameter_value    GUI_LPM_PIPELINE]

        set terp_fd     [open $terp_path]
        set terp_contents [read $terp_fd]
        close  $terp_fd

        array set params_terp   [make_var_wrapper params]
        set params_terp(output_name)    $output_name

        array set params_terp     [fix_hex_capital    params_terp]

        set contents            [altera_terp    $terp_contents  params_terp]
        return $contents
}
#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Procedure: fix_hex_capital
#|
#|  Purpose: called in procedure params_to_wrapper_data to fix ports name heximal issue.
#|
#+-------------------------------------------------------------------------------------------------------------------------

proc    fix_hex_capital     {params_ref}    {

        upvar $params_ref   params
        set module_port_list_temp    $params(module_port_list)
        set wire_list_temp           $params(wire_list)
        set module_port_list        [list ]
        set wire_list               [list ]
    
        foreach str   $module_port_list_temp  {
            if {[string match -nocase "eq*" $str]} {
                 set value   [string range [string toupper $str] 2 end]
                 lappend module_port_list eq$value
            } else {
                 lappend module_port_list $str
            }
        }
        foreach str   $wire_list_temp  {
            if {[string match -nocase "eq*" $str]} {
                 set value   [string range [string toupper $str] 2 end]
                 lappend wire_list eq$value
            } else {
                 lappend wire_list $str
            }
        }
        set params_terp(module_port_list)   $module_port_list
        set params_terp(sub_wire_list)      $params(sub_wire_list)
        set params_terp(wire_list)          $wire_list
        set params_terp(port_map_list)      $params(port_map_list)
        set params_terp(ports_not_added_list)   $params(ports_not_added_list)
        set params_terp(params_list)        $params(params_list)
        set params_terp(ip_name)            $params(ip_name)

        return [array get params_terp]
}

#+----------------------------------------------------------------------------------------------------------------------------



## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" http://quartushelp.altera.com/14.1/master.htm#mergedProjects/hdl/mega/mega_file_lpm_decode.htm
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
