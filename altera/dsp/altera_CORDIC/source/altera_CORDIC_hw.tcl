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
package require altera_terp

load_strings altera_CORDIC.properties

source "../../lib/tcl/dspip_common.tcl"

# 
# module altera_fp
# 
set_module_property NAME altera_CORDIC
set_module_property VERSION  18.1
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME ALTERA_CORDIC 
set_module_property DESCRIPTION "A collection of fixed point CORDIC Functions"
set_module_property GROUP "Basic Functions/Arithmetic"
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property VALIDATION_CALLBACK validate_input
set_module_property ELABORATION_CALLBACK elaboration_callback
set_module_property PREFERRED_SIMULATION_LANGUAGE VHDL
set_module_property PARAMETER_UPGRADE_CALLBACK upgrade_callback
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QSYS true



## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1410764818924/eis1410936966508 

add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408


set_module_property SUPPORTED_DEVICE_FAMILIES \
{\
{Arria 10} {Arria V} {Arria V GZ} {Arria II GX} {Arria II GZ} \
{Cyclone 10 LP} {Cyclone V} {Cyclone IV E} {Cyclone IV GX}\
{MAX 10 FPGA}\
{Stratix V} {Stratix IV} {Stratix 10}\
}


#placeholder 
# add_documentation_link "User Guide" http://www.altera.com/literature/ug/ug_altfp_mfug.pdf

# 
# file sets
# 
add_fileset ALTERA_CORDIC_QUARTUS_SYNTH QUARTUS_SYNTH quartus_synth_callback
add_fileset ALTERA_CORDIC_SIM_VERILOG SIM_VERILOG sim_verilog_callback
add_fileset ALTERA_CORDIC_SIM_VHDL SIM_VHDL sim_vhdl_callback

#
# functions list
# the format of the list is 
# [list name cmd_proc validate_proc elaborate_proc]
# cmd_proc should contain the function name and other function specific
# parameters such as exponent and mantissa widths.
# validate_proc will be run at the end of the validation.
# elaborate_proc should add appropriate data inputs; clk, reset and if selected
# enable input will have been added before running this proc.

#prototype set {fp_family(NAME)}   [list DISPLAY_NAME Function_for_cmdPolyEval cmd_generation_function_for_cmdPoly_eval Validation_callback Elaboration_callback ]

set fp_funcs(SINCOS)              [list SINCOS_DISPLAY_NAME         FXPSinCosCordic       sincos_cmd          sincos_valid      sincos_elab               ]
set fp_funcs(ATAN2)               [list ATAN2_DISPLAY_NAME          FXPAtan2Expert        atan2_cmd             atan2_valid      atan2_elab               ]
set fp_funcs(VECTRANSLATE)        [list VECTRANSLATE_DISPLAY_NAME   FXPVecTranslate       vectrans_cmd          vectrans_valid      vectrans_elab               ]
set fp_funcs(VECROTATE)           [list VECROTATE_DISPLAY_NAME      FXPVecRotate          vecrot_cmd          vecrot_valid       vecrot_elab               ]


set ALL_LIST     [list SINCOS ATAN2 VECTRANSLATE VECROTATE]



set {fp_family(ALL)}     [list ALL_GRP      $ALL_LIST   ]







# 
# parameters
# 


#Create a top level list of all the groups

set FUNCTION_GROUP_NAMES {}
foreach name [array names fp_family] {
    set family $fp_family($name)
    lappend FUNCTION_GROUP_NAMES "$name:[get_string [lindex $family 0]]"             
}

add_parameter FUNCTION_FAMILY STRING   "[lindex [array names fp_family] 0]"
set_parameter_property FUNCTION_FAMILY DISPLAY_NAME "Family"
set_parameter_property FUNCTION_FAMILY UNITS None
set_parameter_property FUNCTION_FAMILY ALLOWED_RANGES [lsort $FUNCTION_GROUP_NAMES]
set_parameter_property FUNCTION_FAMILY DESCRIPTION "Choose the floating point function"
set_parameter_property FUNCTION_FAMILY AFFECTS_GENERATION true
set_parameter_property FUNCTION_FAMILY AFFECTS_ELABORATION true
set_parameter_property FUNCTION_FAMILY VISIBLE false
add_display_item Function FUNCTION_FAMILY PARAMETER

add_parameter derivedfunction STRING
set_parameter_property derivedfunction VISIBLE FALSE
set_parameter_property derivedfunction DERIVED TRUE

#For each group of functions populate a parameter 
foreach current_family [array names fp_family] {
    set family $fp_family($current_family)
    set family_operations [lindex $family 1] 
    set ops {}
    foreach op $family_operations {
        set function $fp_funcs($op)
        set default $op
        lappend ops "$op:[get_string [lindex $function 0]]"
    }
    set default [lindex $family_operations 0] 
    set default_display $fp_funcs($default)
    set default_display [lindex $default_display 0]
    set paramname "${current_family}_function"

    add_parameter "$paramname" STRING "[lindex $family_operations 0]"
    set_parameter_property "$paramname" DISPLAY_NAME "Name"
    set_parameter_property "$paramname" VISIBLE true
    set_parameter_property "$paramname" ALLOWED_RANGES $ops
    set_parameter_property "$paramname" AFFECTS_GENERATION true
    set_parameter_property "$paramname" AFFECTS_ELABORATION true
    set_parameter_property "$paramname" AFFECTS_VALIDATION   true
    add_display_item Function $paramname PARAMETER

}

#Create a derived parameter that holds the true required function



add_parameter frequency_target POSITIVE 200 
set_parameter_property frequency_target DISPLAY_NAME "Target"
set_parameter_property frequency_target UNITS Megahertz
set_parameter_property frequency_target DESCRIPTION "Choose the frequency in MHz at which this function is expected to run. This together with the target device family will determine the amount of pipelining."
set_parameter_property frequency_target AFFECTS_GENERATION true

add_parameter latency_target NATURAL 2 
set_parameter_property latency_target DISPLAY_NAME "Target"
set_parameter_property latency_target VISIBLE false
set_parameter_property latency_target UNITS Cycles
set_parameter_property latency_target DESCRIPTION "Choose the required latency"
set_parameter_property latency_target AFFECTS_GENERATION true



add_parameter performance_goal STRING "frequency" 
#set_parameter_property performance_goal DISPLAY_HINT  radio
set_parameter_property performance_goal DISPLAY_NAME "Goal"
set_parameter_property performance_goal UNITS None
set_parameter_property performance_goal ALLOWED_RANGES [list "frequency:[get_string FREQUENCY_REP_NAME]" "latency:[get_string LATENCY_REP_NAME]" "combined:[get_string COMBINED_REP_NAME]"]
set_parameter_property performance_goal DESCRIPTION "Choose the performance target"
set_parameter_property performance_goal AFFECTS_GENERATION true


add_parameter gen_enable boolean false
set_parameter_property gen_enable DISPLAY_NAME "Generate an enable port" 
set_parameter_property gen_enable UNITS None
set_parameter_property gen_enable DESCRIPTION "Choose if the function should have an enable signal."
set_parameter_property gen_enable AFFECTS_GENERATION true


add_parameter report_resources_to_xml boolean 0
set_parameter_property report_resources_to_xml visible false

add_parameter fxpt_in_width POSITIVE 32 
set_parameter_property fxpt_in_width DISPLAY_NAME "Width"
set_parameter_property fxpt_in_width ALLOWED_RANGES 4:64 
set_parameter_property fxpt_in_width UNITS Bits
set_parameter_property fxpt_in_width DESCRIPTION "Choose the width of the fixed point data"
set_parameter_property fxpt_in_width AFFECTS_GENERATION true

add_parameter fxpt_in_fraction INTEGER 10
set_parameter_property fxpt_in_fraction DISPLAY_NAME "Fraction"
set_parameter_property fxpt_in_fraction UNITS Bits
set_parameter_property fxpt_in_fraction DESCRIPTION "Choose the number of fraction bits"
set_parameter_property fxpt_in_fraction AFFECTS_GENERATION true
set_parameter_property fxpt_in_fraction ALLOWED_RANGES "0:64"

add_parameter fxpt_in_sign STRING "1"
set_parameter_property fxpt_in_sign DISPLAY_NAME "Sign"
#set_parameter_property fxpt_in_sign DISPLAY_HINT radio 
set_parameter_property fxpt_in_sign UNITS None
set_parameter_property fxpt_in_sign ALLOWED_RANGES {"1:signed" "0:unsigned" } 
set_parameter_property fxpt_in_sign DESCRIPTION "Choose the signedness of the fixed point data" 
set_parameter_property fxpt_in_sign AFFECTS_GENERATION true

add_parameter fxpt_out_width POSITIVE 32 
set_parameter_property fxpt_out_width DISPLAY_NAME "Width"
set_parameter_property fxpt_out_width ALLOWED_RANGES 4:64
set_parameter_property fxpt_out_width UNITS Bits
set_parameter_property fxpt_out_width DESCRIPTION "Choose the width of the fixed point data"
set_parameter_property fxpt_out_width AFFECTS_GENERATION true

add_parameter fxpt_out_fraction INTEGER 8
set_parameter_property fxpt_out_fraction DISPLAY_NAME "Fraction"
set_parameter_property fxpt_out_fraction UNITS Bits
set_parameter_property fxpt_out_fraction DESCRIPTION "Choose the number of fraction bits"
set_parameter_property fxpt_out_fraction AFFECTS_GENERATION true
set_parameter_property fxpt_out_fraction ALLOWED_RANGES "0:64"

add_parameter fxpt_out_sign STRING "1"
set_parameter_property fxpt_out_sign VISIBLE FALSE
set_parameter_property fxpt_out_sign DERIVED TRUE
set_parameter_property fxpt_out_sign DISPLAY_NAME "Sign"
#set_parameter_property fxpt_out_sign DISPLAY_HINT radio 
set_parameter_property fxpt_out_sign UNITS None
set_parameter_property fxpt_out_sign ALLOWED_RANGES {"1:signed" "0:unsigned" } 
set_parameter_property fxpt_out_sign DESCRIPTION "Choose the signedness of the fixed point data" 
set_parameter_property fxpt_out_sign AFFECTS_GENERATION true

##We need derived versions of these - because often we must limit alpha etc.
add_parameter fxpt_in_width_derived POSITIVE 32 
set_parameter_property fxpt_in_width_derived VISIBLE FALSE
set_parameter_property fxpt_in_width_derived DERIVED TRUE
set_parameter_property fxpt_in_width_derived ENABLED FALSE
set_parameter_property fxpt_in_width_derived DISPLAY_NAME "Width"
set_parameter_property fxpt_in_width_derived UNITS Bits
set_parameter_property fxpt_in_width_derived DESCRIPTION "Choose the width of the fixed point data"
set_parameter_property fxpt_in_width_derived AFFECTS_GENERATION true

add_parameter fxpt_in_fraction_derived INTEGER 0 
set_parameter_property fxpt_in_fraction_derived VISIBLE FALSE
set_parameter_property fxpt_in_fraction_derived DERIVED TRUE
set_parameter_property fxpt_in_fraction_derived ENABLED FALSE
set_parameter_property fxpt_in_fraction_derived DISPLAY_NAME "Fraction"
set_parameter_property fxpt_in_fraction_derived UNITS Bits
set_parameter_property fxpt_in_fraction_derived DESCRIPTION "Choose the number of fraction bits"
set_parameter_property fxpt_in_fraction_derived AFFECTS_GENERATION true

add_parameter fxpt_in_sign_derived STRING "1"
set_parameter_property fxpt_in_sign_derived VISIBLE FALSE
set_parameter_property fxpt_in_sign_derived DERIVED TRUE
set_parameter_property fxpt_in_sign_derived ENABLED FALSE
set_parameter_property fxpt_in_sign_derived DISPLAY_NAME "Sign"
#set_parameter_property fxpt_in_sign_derived DISPLAY_HINT radio 
set_parameter_property fxpt_in_sign_derived UNITS None
set_parameter_property fxpt_in_sign_derived ALLOWED_RANGES {"1:signed" "0:unsigned" } 
set_parameter_property fxpt_in_sign_derived DESCRIPTION "Choose the signedness of the fixed point data" 
set_parameter_property fxpt_in_sign_derived AFFECTS_GENERATION true


add_parameter fxpt_in_2_width_derived POSITIVE 32 
set_parameter_property fxpt_in_2_width_derived VISIBLE FALSE
set_parameter_property fxpt_in_2_width_derived DERIVED TRUE
set_parameter_property fxpt_in_2_width_derived ENABLED FALSE
set_parameter_property fxpt_in_2_width_derived DISPLAY_NAME "Width"
set_parameter_property fxpt_in_2_width_derived UNITS Bits
set_parameter_property fxpt_in_2_width_derived DESCRIPTION "Choose the width of the fixed point data"
set_parameter_property fxpt_in_2_width_derived AFFECTS_GENERATION true

add_parameter fxpt_in_2_fraction_derived INTEGER 0 
set_parameter_property fxpt_in_2_fraction_derived VISIBLE FALSE
set_parameter_property fxpt_in_2_fraction_derived DERIVED TRUE
set_parameter_property fxpt_in_2_fraction_derived ENABLED FALSE
set_parameter_property fxpt_in_2_fraction_derived DISPLAY_NAME "Fraction"
set_parameter_property fxpt_in_2_fraction_derived UNITS Bits
set_parameter_property fxpt_in_2_fraction_derived DESCRIPTION "Choose the number of fraction bits"
set_parameter_property fxpt_in_2_fraction_derived AFFECTS_GENERATION true

add_parameter fxpt_in_2_sign_derived STRING "1"
set_parameter_property fxpt_in_2_sign_derived VISIBLE FALSE
set_parameter_property fxpt_in_2_sign_derived DERIVED TRUE
set_parameter_property fxpt_in_2_sign_derived ENABLED FALSE
set_parameter_property fxpt_in_2_sign_derived DISPLAY_NAME "Sign"
#set_parameter_property fxpt_in_2_sign_derived DISPLAY_HINT radio 
set_parameter_property fxpt_in_2_sign_derived UNITS None
set_parameter_property fxpt_in_2_sign_derived ALLOWED_RANGES {"1:signed" "0:unsigned" } 
set_parameter_property fxpt_in_2_sign_derived DESCRIPTION "Choose the signedness of the fixed point data" 
set_parameter_property fxpt_in_2_sign_derived AFFECTS_GENERATION true



add_parameter fxpt_out_width_derived POSITIVE 32 
set_parameter_property fxpt_out_width_derived VISIBLE FALSE
set_parameter_property fxpt_out_width_derived DERIVED TRUE
set_parameter_property fxpt_out_width_derived ENABLED FALSE
set_parameter_property fxpt_out_width_derived DISPLAY_NAME "Width"
set_parameter_property fxpt_out_width_derived UNITS Bits
set_parameter_property fxpt_out_width_derived DESCRIPTION "Choose the width of the fixed point data"
set_parameter_property fxpt_out_width_derived AFFECTS_GENERATION true

add_parameter fxpt_out_fraction_derived INTEGER 0 
set_parameter_property fxpt_out_fraction_derived VISIBLE FALSE
set_parameter_property fxpt_out_fraction_derived DERIVED TRUE
set_parameter_property fxpt_out_fraction_derived ENABLED FALSE
set_parameter_property fxpt_out_fraction_derived DISPLAY_NAME "Fraction"
set_parameter_property fxpt_out_fraction_derived UNITS Bits
set_parameter_property fxpt_out_fraction_derived DESCRIPTION "Choose the number of fraction bits"
set_parameter_property fxpt_out_fraction_derived AFFECTS_GENERATION true

add_parameter fxpt_out_sign_derived STRING "1"
set_parameter_property fxpt_out_sign_derived VISIBLE FALSE
set_parameter_property fxpt_out_sign_derived DERIVED TRUE
set_parameter_property fxpt_out_sign_derived ENABLED FALSE
set_parameter_property fxpt_out_sign_derived DISPLAY_NAME "Sign"
#set_parameter_property fxpt_out_sign_derived DISPLAY_HINT radio 
set_parameter_property fxpt_out_sign_derived UNITS None
set_parameter_property fxpt_out_sign_derived ALLOWED_RANGES {"1:signed" "0:unsigned" } 
set_parameter_property fxpt_out_sign_derived DESCRIPTION "Choose the signedness of the fixed point data" 
set_parameter_property fxpt_out_sign_derived AFFECTS_GENERATION true


add_parameter fxpt_out_2_width_derived POSITIVE 32 
set_parameter_property fxpt_out_2_width_derived VISIBLE FALSE
set_parameter_property fxpt_out_2_width_derived DERIVED TRUE
set_parameter_property fxpt_out_2_width_derived ENABLED FALSE
set_parameter_property fxpt_out_2_width_derived DISPLAY_NAME "Width"
set_parameter_property fxpt_out_2_width_derived UNITS Bits
set_parameter_property fxpt_out_2_width_derived DESCRIPTION "Choose the width of the fixed point data"
set_parameter_property fxpt_out_2_width_derived AFFECTS_GENERATION true

add_parameter fxpt_out_2_fraction_derived INTEGER 0 
set_parameter_property fxpt_out_2_fraction_derived VISIBLE FALSE
set_parameter_property fxpt_out_2_fraction_derived DERIVED TRUE
set_parameter_property fxpt_out_2_fraction_derived ENABLED FALSE
set_parameter_property fxpt_out_2_fraction_derived DISPLAY_NAME "Fraction"
set_parameter_property fxpt_out_2_fraction_derived UNITS Bits
set_parameter_property fxpt_out_2_fraction_derived DESCRIPTION "Choose the number of fraction bits"
set_parameter_property fxpt_out_2_fraction_derived AFFECTS_GENERATION true

add_parameter fxpt_out_2_sign_derived STRING "1"
set_parameter_property fxpt_out_2_sign_derived VISIBLE FALSE
set_parameter_property fxpt_out_2_sign_derived DERIVED TRUE
set_parameter_property fxpt_out_2_sign_derived ENABLED FALSE
set_parameter_property fxpt_out_2_sign_derived DISPLAY_NAME "Sign"
#set_parameter_property fxpt_out_2_sign_derived DISPLAY_HINT radio 
set_parameter_property fxpt_out_2_sign_derived UNITS None
set_parameter_property fxpt_out_2_sign_derived ALLOWED_RANGES {"1:signed" "0:unsigned" } 
set_parameter_property fxpt_out_2_sign_derived DESCRIPTION "Choose the signedness of the fixed point data" 
set_parameter_property fxpt_out_2_sign_derived AFFECTS_GENERATION true


add_parameter useLUTs boolean false
set_parameter_property useLUTs DISPLAY_NAME "LUT Size Optimization" 
set_parameter_property useLUTs UNITS None
set_parameter_property useLUTs DESCRIPTION "Choose to manually specify how the LUT controlling Sign(Z) is calculated"
set_parameter_property useLUTs AFFECTS_GENERATION true

add_parameter specifyLUTs boolean false
set_parameter_property specifyLUTs DISPLAY_NAME "Manually Specify LUT Size" 
set_parameter_property specifyLUTs UNITS None
set_parameter_property specifyLUTs DESCRIPTION "Choose to manually specify how the LUT controlling Sign(Z) is calculated"
set_parameter_property specifyLUTs AFFECTS_GENERATION true

add_parameter LUTSize INTEGER 6
set_parameter_property LUTSize DISPLAY_NAME "LUT Size"
set_parameter_property LUTSize DESCRIPTION "Choose the number of values of Sign(Z) to be stored per lookup table, 0 uses device based estimates"
set_parameter_property LUTSize AFFECTS_GENERATION true
set_parameter_property LUTSize ALLOWED_RANGES "2:12"

add_parameter SFCompensation boolean false
set_parameter_property SFCompensation DISPLAY_NAME "Scale Factor Compensation" 
set_parameter_property SFCompensation UNITS None
set_parameter_property SFCompensation DESCRIPTION "When enabled scales the output value to remove the scale factor introduced by the CORDIC Method"
set_parameter_property SFCompensation AFFECTS_GENERATION true

add_parameter frequency_feedback INTEGER 0 
set_parameter_property frequency_feedback DERIVED true
set_parameter_property frequency_feedback VISIBLE false
set_parameter_property frequency_feedback AFFECTS_ELABORATION true

add_parameter latency_feedback INTEGER 0 
set_parameter_property latency_feedback DERIVED true
set_parameter_property latency_feedback VISIBLE false
set_parameter_property latency_feedback AFFECTS_ELABORATION true

add_parameter force_elaborate INTEGER 0 
set_parameter_property force_elaborate DERIVED true
set_parameter_property force_elaborate VISIBLE false
set_parameter_property force_elaborate AFFECTS_ELABORATION true




set latency_button_pressed false
set resource_button_pressed false

# 
# display items
# 
add_display_item "" Functionality GROUP
set_display_item_property Functionality DISPLAY_HINT TAB
# add_display_item "" Advanced GROUP
# set_display_item_property Advanced DISPLAY_HINT TAB
add_display_item "" Performance GROUP
set_display_item_property Performance DISPLAY_HINT TAB

add_display_item Functionality Function GROUP
add_display_item Functionality "Fixed Point Data" GROUP
set_display_item_property "Fixed Point Data" VISIBLE false
add_display_item Performance Target GROUP
add_display_item Performance Report GROUP

add_display_item Functionality "Input Data Widths" GROUP
add_display_item "Input Data Widths" X_Y_Label text "X,Y Inputs"
add_display_item "Input Data Widths" fxpt_in_fraction PARAMETER
add_display_item "Input Data Widths" fxpt_in_fraction_derived PARAMETER
add_display_item "Input Data Widths" fxpt_in_width PARAMETER
add_display_item "Input Data Widths" fxpt_in_width_derived PARAMETER
add_display_item "Input Data Widths" fxpt_in_sign PARAMETER
add_display_item "Input Data Widths" fxpt_in_sign_derived PARAMETER
add_display_item "Input Data Widths" Angle_input_label text "Angle Input"
add_display_item "Input Data Widths" fxpt_in_2_fraction_derived PARAMETER
add_display_item "Input Data Widths" fxpt_in_2_width_derived PARAMETER
add_display_item "Input Data Widths" fxpt_in_2_sign_derived PARAMETER
add_display_item Functionality "Output Data Widths" GROUP
add_display_item "Output Data Widths" Alpha_Label text "Angle Output (q)"
add_display_item "Output Data Widths" fxpt_out_fraction_derived PARAMETER
add_display_item "Output Data Widths" fxpt_out_fraction PARAMETER
add_display_item "Output Data Widths" fxpt_out_width_derived PARAMETER
add_display_item "Output Data Widths" fxpt_out_width PARAMETER
add_display_item "Output Data Widths" fxpt_out_sign PARAMETER
add_display_item "Output Data Widths" fxpt_out_sign_derived PARAMETER
add_display_item "Output Data Widths" Mag_Label text "Magnitude Output (r)"
add_display_item "Output Data Widths" fxpt_out_2_fraction_derived PARAMETER
add_display_item "Output Data Widths" fxpt_out_2_width_derived PARAMETER
add_display_item "Output Data Widths" fxpt_out_2_sign_derived PARAMETER

add_display_item Functionality Ports GROUP
add_display_item Functionality "Optimizations" GROUP
add_display_item "Optimizations" useLUTs PARAMETER
add_display_item "Optimizations" specifyLUTs PARAMETER
add_display_item "Optimizations" LUTsize PARAMETER
add_display_item "Optimizations" SFCompensation PARAMETER
add_display_item Function derivedfunction PARAMETER





add_display_item Target performance_goal PARAMETER
add_display_item Target frequency_target PARAMETER
add_display_item Target latency_target PARAMETER



add_display_item Report report_pane TEXT ""
add_display_item Report check_performance_button ACTION latency_button_proc
set_display_item_property check_performance_button DISPLAY_NAME "Check Performance"
set_display_item_property check_performance_button DESCRIPTION "Press button to check if the requested latency is achievable and if so at what frequency"
add_display_item Report RES_TITLE TEXT ""







add_display_item Ports gen_enable PARAMETER

# add_display_item Resources resource_pane TEXT ""
# add_display_item Resources check_resource_usage_button ACTION resource_button_proc
# set_display_item_property check_resource_usage_button DISPLAY_NAME "Check Resource Usage"
# set_display_item_property check_resource_usage_button DESCRIPTION "Press button to check the estimated resource usage for the configuration"

# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
add_interface_port clk clk clk Input 1


# 
# connection point areset
# 
add_interface areset reset end
set_interface_property areset associatedClock clk
set_interface_property areset synchronousEdges DEASSERT
set_interface_property areset ENABLED true
add_interface_port areset areset reset Input 1


# 
# device parameters
# 
add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}

add_parameter selected_device_speedgrade STRING "Unknown"
set_parameter_property selected_device_speedgrade VISIBLE false
set_parameter_property selected_device_speedgrade SYSTEM_INFO {DEVICE_SPEEDGRADE}

#
# status of validation so that cmdPolyEval call can be predicated on this
#
add_parameter validation_failed BOOLEAN false
set_parameter_property validation_failed VISIBLE false
set_parameter_property validation_failed DERIVED true

#####CMDs

proc sincos_cmd {} {
    set args [list]
    lappend args [get_function_option name]
    lappend args [get_parameter_value fxpt_in_width_derived]
    lappend args [get_parameter_value fxpt_in_fraction]
    lappend args [get_parameter_value fxpt_in_sign]
    lappend args [get_parameter_value fxpt_out_fraction]
    return $args
}

proc atan2_cmd {} {
    set args [list]
    lappend args [get_function_option name]
    lappend args [get_parameter_value fxpt_in_width]
    lappend args [get_parameter_value fxpt_in_fraction]
    lappend args [get_parameter_value fxpt_in_sign]
    lappend args [get_parameter_value fxpt_out_fraction]
    if { [get_parameter_value useLUTs] } {
        lappend args 1
    } else {
        lappend args 0
    }
    if { [get_parameter_value specifyLUTs]  && [get_parameter_value useLUTs]} {
        lappend args [get_parameter_value LUTSize]
    } else {
        lappend args 0
    }
    return $args
}

proc vectrans_cmd {} {
    set args [list]
    lappend args [get_function_option name]
    lappend args [get_parameter_value fxpt_in_width]
    lappend args [get_parameter_value fxpt_in_fraction]
    lappend args [get_parameter_value fxpt_in_sign]
    lappend args [get_parameter_value fxpt_out_fraction]
    if { [get_parameter_value SFCompensation] } {
        lappend args 1
    } else {
        lappend args 0
    }    
    return $args
}

proc vecrot_cmd {} {
    set args [list]
    lappend args [get_function_option name]
    lappend args [get_parameter_value fxpt_in_width_derived]
    lappend args [get_parameter_value fxpt_in_fraction]
    lappend args [get_parameter_value fxpt_in_sign]
    lappend args [get_parameter_value fxpt_out_fraction]
    if { [get_parameter_value SFCompensation] } {
        lappend args 1
    } else {
        lappend args 0
    }    
    return $args
}


###Validates
proc validate_input_widths {} {
    set f [get_parameter_value fxpt_in_fraction] 
    set w [get_parameter_value fxpt_in_width] 
    set s [get_parameter_value fxpt_in_sign] 

    if {$f > $w || ($f == $w && $s == 1) } {
        send_message ERROR "Input Width must atleast be large enough to contain both the full fraction size and the sign if chosen"
    }

}

proc sincos_valid {} {
    update_menu
    hide_optionals
    set_display_item_property "Input Data Widths" VISIBLE true
    set_display_item_property "Output Data Widths" VISIBLE true
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property fxpt_in_sign VISIBLE true
    set_parameter_property fxpt_in_fraction VISIBLE true
    set_parameter_property fxpt_in_width_derived VISIBLE true
    set_parameter_value     fxpt_in_width_derived [expr 1 + [get_parameter_value fxpt_in_fraction] + 2*[get_parameter_value fxpt_in_sign]]

    set_parameter_value fxpt_out_sign_derived [get_parameter_value fxpt_in_sign]
    set_parameter_value fxpt_out_width_derived [expr 1 + [get_parameter_value fxpt_in_sign] + [get_parameter_value fxpt_out_fraction]]
    set f_out [get_parameter_value fxpt_out_fraction]
    set f_in [get_parameter_value fxpt_in_fraction] 
    if { [get_parameter_value fxpt_in_sign] } {
        if {$f_out > $f_in }  {
            send_message ERROR "Output fraction is limited to being less than or equal to the input fraction for signed mode"
        }
    }
    set_parameter_property fxpt_out_sign_derived VISIBLE true
    set_parameter_property fxpt_out_width_derived VISIBLE true
    set_parameter_property fxpt_out_fraction VISIBLE true


}

proc atan2_valid {} {
    update_menu
    hide_optionals
    set_display_item_property "Input Data Widths" VISIBLE true
    set_display_item_property "Output Data Widths" VISIBLE true
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property fxpt_in_sign VISIBLE true
    set_parameter_property fxpt_in_fraction VISIBLE true
    set_parameter_property fxpt_in_width VISIBLE true
    set_parameter_property fxpt_out_sign_derived VISIBLE true
    set_parameter_property fxpt_out_fraction VISIBLE true
    set_parameter_property fxpt_out_width_derived VISIBLE true
    set_parameter_value fxpt_out_sign_derived 1
 
    set out_width [expr [get_parameter_value fxpt_out_fraction] + 2]
    if { [get_parameter_value fxpt_in_sign] == 1 } {
        set out_width [expr $out_width + 1]
    }
    set_parameter_value fxpt_out_width_derived $out_width
    set_parameter_property useLUTs VISIBLE true
    if { [get_parameter_value useLUTs] } {
        set_parameter_property specifyLUTs VISIBLE true
    } else {
        set_parameter_property specifyLUTs VISIBLE false
    }
    if { [get_parameter_value specifyLUTs] } {
        set_parameter_property LUTSize VISIBLE TRUE
    }
    validate_input_widths
}
proc vectrans_valid {} {
    update_menu
    hide_optionals
    set_display_item_property "Input Data Widths" VISIBLE true
    set_display_item_property "Output Data Widths" VISIBLE true
    set_display_item_property Mag_Label VISIBLE true
    set_display_item_property Alpha_Label VISIBLE true
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property fxpt_in_sign VISIBLE true
    set_parameter_property fxpt_in_fraction VISIBLE true
    set_parameter_property fxpt_in_width VISIBLE true
    set_parameter_property fxpt_out_sign_derived VISIBLE true
    set_parameter_property fxpt_out_fraction VISIBLE true
    set_parameter_property fxpt_out_width_derived VISIBLE true
    set_parameter_value fxpt_out_sign_derived 1
    set_parameter_property  fxpt_out_2_sign_derived VISIBLE TRUE
    set_parameter_property  fxpt_out_2_fraction_derived VISIBLE TRUE
    set_parameter_property  fxpt_out_2_width_derived VISIBLE TRUE

    set_parameter_value fxpt_out_sign 0

    #derived from cmdPolyEval:5424
    set SFC 0
    if { [get_parameter_value SFCompensation] } {
        set SFC 1
    }
    set w_in [get_parameter_value fxpt_in_width]
    set f_in [get_parameter_value fxpt_in_fraction]
    set s_in [get_parameter_value fxpt_in_sign]
    set f_out [get_parameter_value fxpt_out_fraction]
    set rW [expr 2 + (1-$SFC) + $f_out]
    set MSB [expr ($w_in-$f_in-1-$s_in) + 1 + (1-$SFC)]
    set LSB [expr $MSB -$rW + 1]


    set_parameter_value fxpt_out_2_fraction_derived [expr 0 - $LSB]
    set_parameter_value fxpt_out_2_width_derived $rW
    set_parameter_value fxpt_out_2_sign_derived 0

    set_display_item_property Optimizations VISIBLE true
    set_parameter_property SFCompensation VISIBLE true

    set out_width [expr [get_parameter_value fxpt_out_fraction] + 2]
    if { [get_parameter_value fxpt_in_sign] == 1 } {
        set out_width [expr $out_width + 1]
    }
    set_parameter_value fxpt_out_width_derived $out_width
    validate_input_widths
}

proc vecrot_valid {} {
    update_menu
    hide_optionals
    set_display_item_property "Input Data Widths" VISIBLE true
    set_display_item_property  X_Y_Label VISIBLE true
    set_display_item_property  Angle_input_label VISIBLE true
    set_display_item_property "Output Data Widths" VISIBLE true
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property fxpt_in_sign VISIBLE true
    set_parameter_property fxpt_in_fraction VISIBLE true
    set_parameter_property fxpt_in_width_derived VISIBLE true
    set_parameter_property fxpt_in_2_sign_derived VISIBLE true
    set_parameter_property fxpt_in_2_fraction_derived VISIBLE true
    set_parameter_property fxpt_in_2_width_derived VISIBLE true
    set_parameter_property fxpt_out_sign_derived VISIBLE true
    set_parameter_property fxpt_out_fraction VISIBLE true
    set_parameter_property fxpt_out_width_derived VISIBLE true


    set_parameter_value fxpt_in_width_derived [expr [get_parameter_value fxpt_in_fraction] + 1 + [get_parameter_value fxpt_in_sign]]
    set_parameter_value fxpt_out_sign_derived [get_parameter_value fxpt_in_sign]

    set_display_item_property Optimizations VISIBLE true
    set_parameter_property SFCompensation VISIBLE true

    set out_width [expr [get_parameter_value fxpt_out_fraction] + 3] 
    if { [get_parameter_value SFCompensation] }  {
        set out_width [expr $out_width - 1 ]
    }

    set_parameter_value fxpt_out_width_derived $out_width
    set_parameter_value fxpt_out_sign_derived 1

    set_parameter_value fxpt_in_2_width_derived [expr [get_parameter_value fxpt_in_width_derived] + 1]
    set_parameter_value fxpt_in_2_sign_derived [get_parameter_value fxpt_in_sign]
    set_parameter_value fxpt_in_2_fraction_derived [get_parameter_value fxpt_in_fraction]
}


###Elabs

proc sincos_elab {} {
    set in_width [get_parameter_value fxpt_in_width_derived] 
    set out_width [get_parameter_value fxpt_out_width_derived] 
    if { $in_width > 0 } {
        add_interface_input a $in_width
        add_interface_output c $out_width
        add_interface_output s $out_width
    }
}
proc vectrans_elab {} {
    set in_width [get_parameter_value fxpt_in_width] 
    set out_width [get_parameter_value fxpt_out_width_derived] 
    set out_width_2 [get_parameter_value fxpt_out_2_width_derived] 
    if { $in_width > 0 } {
        add_interface_input x $in_width
        add_interface_input y $in_width
        add_interface_output q $out_width
        add_interface_output r $out_width_2
    }
}
proc vecrot_elab {} {
    set in_width [get_parameter_value fxpt_in_width_derived] 
    set out_width [get_parameter_value fxpt_out_width_derived] 
    set in_width_2 [get_parameter_value fxpt_in_2_width_derived] 
    if { $in_width > 0 } {
        add_interface_input x $in_width
        add_interface_input y $in_width
        add_interface_input a $in_width_2
        add_interface_output xo $out_width
        add_interface_output yo $out_width
    }
}

proc atan2_elab {} {
    set in_width [get_parameter_value fxpt_in_width] 
    set out_width [get_parameter_value fxpt_out_width_derived] 
    if { $in_width > 0 } {
        add_interface_input x $in_width
        add_interface_input y $in_width
        add_interface_output q $out_width
    }
}





proc update_menu {} {
    global fp_family
    foreach non_current_family [lsort [array names fp_family]]  {
        set_parameter_property "${non_current_family}_function" VISIBLE false
    }
    set current_family [get_parameter_value FUNCTION_FAMILY]
    set current_family_param "${current_family}_function"
    set_parameter_property $current_family_param VISIBLE true
    set_parameter_value derivedfunction [get_parameter_value $current_family_param]

}

proc hide_optionals {} {

    set_display_item_property "Input Data Widths" VISIBLE false
    set_display_item_property "Output Data Widths" VISIBLE false
    set_parameter_property  fxpt_in_sign VISIBLE FALSE
    set_parameter_property  fxpt_in_fraction VISIBLE FALSE
    set_parameter_property  fxpt_in_width VISIBLE FALSE
    set_parameter_property  fxpt_out_sign VISIBLE FALSE
    set_parameter_property  fxpt_out_fraction VISIBLE FALSE
    set_parameter_property  fxpt_out_width VISIBLE FALSE
    set_parameter_property  fxpt_in_sign_derived VISIBLE FALSE
    set_parameter_property  fxpt_in_fraction_derived VISIBLE FALSE
    set_parameter_property  fxpt_in_width_derived VISIBLE FALSE
    set_parameter_property  fxpt_in_2_sign_derived VISIBLE FALSE
    set_parameter_property  fxpt_in_2_fraction_derived VISIBLE FALSE
    set_parameter_property  fxpt_in_2_width_derived VISIBLE FALSE
    set_parameter_property  fxpt_out_sign_derived VISIBLE FALSE
    set_parameter_property  fxpt_out_fraction_derived VISIBLE FALSE
    set_parameter_property  fxpt_out_width_derived VISIBLE FALSE
    set_parameter_property  fxpt_out_2_sign_derived VISIBLE FALSE
    set_parameter_property  fxpt_out_2_fraction_derived VISIBLE FALSE
    set_parameter_property  fxpt_out_2_width_derived VISIBLE FALSE
    set_parameter_property  useLUTs VISIBLE FALSE
    set_parameter_property  specifyLUTs VISIBLE FALSE
    set_parameter_property  LUTSize VISIBLE FALSE
    set_parameter_property  SFCompensation VISIBLE FALSE
    set_display_item_property  Alpha_Label VISIBLE FALSE
    set_display_item_property  Mag_Label VISIBLE FALSE
    set_display_item_property  X_Y_Label VISIBLE FALSE
    set_display_item_property  Angle_input_label VISIBLE FALSE


}



proc add_interface_input { name bit_width } {
    add_interface $name conduit end
    set_interface_property $name associatedClock clk
    set_interface_property $name associatedReset areset
    set_interface_property $name ENABLED true
    add_interface_port $name $name $name Input $bit_width 
}

proc add_interface_output { name bit_width } {
    add_interface $name conduit start
    set_interface_assignment $name "ui.blockdiagram.direction" OUTPUT
    set_interface_property $name associatedClock clk
    set_interface_property $name associatedReset ""
    add_interface_port $name $name $name Output $bit_width
}


proc latency_button_proc {} {
    #we need to force elaborate because if the frequency is the same the elaborate callback will
    #not be called, and no information message will be printed.
    set_parameter_value force_elaborate [expr [get_parameter_value force_elaborate] ^ 1]
    set_parameter_value frequency_feedback [find_frequency [get_parameter_value latency_target]] 
    set_latency_button_pressed true
}

proc resource_button_proc {} {
    #we need to force elaborate because if the frequency is the same the elaborate callback will
    #not be called, and no information message will be printed.
    set_parameter_value force_elaborate [expr [get_parameter_value force_elaborate] ^ 1]
    if { [is_goal_frequency] } {
            set_parameter_value frequency_feedback [find_frequency [get_parameter_value latency_target]] 
    }
    set_resource_button_pressed true
}



proc validate_input {} {
    set_parameter_value validation_failed false

    if { [is_goal_frequency] } {
        set_parameter_property frequency_target VISIBLE true
        set_parameter_property latency_target VISIBLE false
    } elseif { [is_goal_latency] } {
        set_parameter_property frequency_target VISIBLE false
        set_parameter_property latency_target VISIBLE true
    } elseif {[is_goal_combined]} {
        set_parameter_property frequency_target VISIBLE true
        set_parameter_property latency_target VISIBLE true
    } elseif { [is_goal_manual_dsps] }  {
        set_parameter_property frequency_target VISIBLE false
        set_parameter_property latency_target VISIBLE false
    }
    [get_function_option validate]

}

proc elaboration_callback {} {
    if { [get_parameter_value gen_enable] } {
        add_interface en conduit end
        set_interface_property en associatedClock clk
        set_interface_property en associatedReset ""
        set_interface_property en ENABLED true
        add_interface_port en en en Input 1
        set_port_property en VHDL_TYPE STD_LOGIC_VECTOR
    }
    set_display_item_property Report VISIBLE true
    set_display_item_property "Register Report" VISIBLE false
    set quartus_dir [get_quartus_rootdir] 
    [get_function_option elaborate]
    if { [get_parameter_property performance_goal VISIBLE] == 1 } { 
        if { [is_goal_frequency] || [is_goal_combined] } {
            if { [get_latency_button_pressed] } {
                set_display_item_property check_performance_button VISIBLE false
                set_display_item_property report_pane VISIBLE true
                if { bool([get_parameter_value validation_failed]) == bool(false) } {
                    set freq [get_parameter_value frequency_target]
                    if { $freq < 2001 } {
                        if { [is_goal_combined] } {
                            set latencyConstraint "true"
                        } else {
                            set latencyConstraint "false"
                        }
                        set output [call_cmdPolyEval "none" $quartus_dir "." "report" $freq "false"]
                        array set report [extract_report $output]
                        if { [is_goal_frequency] } {
                            report_latency [array get report] false 
                        } else {
                            report_combined_target [array get report] false 
                        }
                        if { [is_goal_combined] } {
                            set latencyConstraint "true"
                        } else {
                            set latencyConstraint "false"
                        }
                        set output [call_cmdPolyEval "none" $quartus_dir "." "report" $freq $latencyConstraint]
                        array set report [extract_report $output]
                        report_resources [array get report] false 
                        if { [info exists report(latency)] } {
                            set_parameter_value latency_feedback $report(latency)
                        }
                    } else {
                        set_display_item_property report_pane TEXT "Frequency target must be below 2GHz"
                    }
                } else {
                    set_display_item_property report_pane TEXT "Latency unknown because parameters are invalid"
                }
                set_latency_button_pressed false 
            # } else {                
            #     set_display_item_property check_performance_button VISIBLE true
            #     set_display_item_property report_pane VISIBLE false
            #     hide_resource_estimates
            #     set_display_item_property check_resource_usage_button VISIBLE true
            }
        } elseif { [is_goal_latency]} {

            if { [get_latency_button_pressed] } {
                    set_display_item_property report_pane VISIBLE true
                    set_display_item_property check_performance_button VISIBLE false
                    set frequency_feedback [get_parameter_value frequency_feedback]
                    if {[expr $frequency_feedback > 0]  } {
                        set output [call_cmdPolyEval "none" $quartus_dir "." "report" $frequency_feedback "true"]      
                        array set report [extract_report $output]
                        report_resources [array get report] false 
                        set output [call_cmdPolyEval "none" $quartus_dir "." "report" $frequency_feedback "false"]
                        array set report [extract_report $output]
                        set_display_item_property report_pane TEXT "Estimated frequency on [get_parameter_value selected_device_family] is $frequency_feedback MHz. Closest latency was $report(latency), padding to meet target if necessary"                
                    } else {
                        set output [call_cmdPolyEval "none" $quartus_dir "." "report" 1 "false"]
                        array set report [extract_report $output]
                        set_display_item_property report_pane TEXT "Could not achieve the requested latency. Minimum achievable latency is $report(latency) cycles"
                    }

                    set_latency_button_pressed false 
            } elseif { [get_resource_button_pressed] } {
                set_display_item_property check_resource_usage_button VISIBLE false
                set_display_item_property resource_pane VISIBLE true
                set_display_item_property resource_pane TEXT "Latency unknown because parameters are invalid"
                set_resource_button_pressed false 
            } else {                
                set_display_item_property check_performance_button VISIBLE true
                set_display_item_property report_pane VISIBLE false
                hide_resource_estimates
                set_display_item_property check_resource_usage_button VISIBLE true
                set_display_item_property resource_pane VISIBLE false
            }
        }
    }
}




proc set_latency_button_pressed { val } {
    global latency_button_pressed
    set latency_button_pressed $val
}
proc set_resource_button_pressed { val } {
    global resource_button_pressed
    set resource_button_pressed $val
}


proc get_latency_button_pressed {} {
    global latency_button_pressed
    return $latency_button_pressed
}
proc get_resource_button_pressed {  } {
    global resource_button_pressed
    return $resource_button_pressed
}

proc sim_verilog_callback {entity_name} {
    generate $entity_name verilog
}

proc sim_vhdl_callback {entity_name} {
    generate $entity_name vhdl
}

proc quartus_synth_callback {entity_name} {
    generate $entity_name vhdl
}

proc generate {entity_name lang} {
    set tmp_dir [create_temp_file ""]
    file mkdir $tmp_dir
    set quartus_dir [get_quartus_rootdir] 

    if { [is_goal_latency] } {
        set freq [find_frequency [get_parameter_value latency_target]]
    } else {
        set freq [get_parameter_value frequency_target]
    }

    if { [expr $freq > 0] } {
        if { [is_goal_combined] }  {
            set output [call_cmdPolyEval $entity_name $quartus_dir $tmp_dir "report" $freq "true"] 
            array set report [extract_report $output]
            report_combined_target [array get report] true  
        }
        set output [call_cmdPolyEval $entity_name $quartus_dir $tmp_dir "VHDL" $freq "false"] 
        set hdl_files [glob -nocomplain -tails -directory $tmp_dir *.vhd]

        if { [lsearch $hdl_files "${entity_name}.vhd"] == -1 } {
            send_message ERROR "Could not generate name"
        }

        array set report [extract_report $output]
        if { ![info exists report(latency)] } {
            send_message ERROR "Failed to generate HDL for current parameters"
        }
        if { [get_parameter_value report_resources_to_xml] } {
            write_report_file [array get report] $entity_name $freq
        }
        if { [is_goal_frequency] } {
            report_latency [array get report] true  
        } 
        report_resources [array get report] true 

        set hex_files [glob -nocomplain -tails -directory $tmp_dir *.hex]
        foreach a_file $hex_files {
            add_fileset_file $a_file HEX PATH  $tmp_dir/$a_file
        }
        if { $lang == "vhdl" } {
            add_fileset_file dspba_library_package.vhd VHDL PATH  "$quartus_dir/dspba/backend/Libraries/vhdl/base/dspba_library_package.vhd"
            add_fileset_file dspba_library.vhd VHDL PATH  "$quartus_dir/dspba/backend/Libraries/vhdl/base/dspba_library.vhd"
            add_fileset_file $entity_name.vhd VHDL PATH  $tmp_dir/$entity_name.vhd
        } else {
            set filelocation [create_temp_file ""]
            file mkdir $filelocation
            set input_file [file join $tmp_dir $entity_name.vhd]
            set SIMGEN_PARAMS "--source  $quartus_dir/dspba/backend/Libraries/vhdl/base/dspba_library_package.vhd --source $quartus_dir/dspba/backend/Libraries/vhdl/base/dspba_library.vhd --simgen_parameter=SIMGEN_OBFUSCATE=OFF,CBX_HDL_LANGUAGE=$lang,SIMGEN_RAND_POWERUP_FFS=OFF,SIMGEN_OBFUSCATE=ON,SIMGEN_MAX_TULIP_COUNT=0,CBX_OUTPUT_DIRECTORY=$filelocation"
            set simgen_name [call_simgen $input_file $SIMGEN_PARAMS ]
            set simgen_name [file join $filelocation "[file tail ${simgen_name}].vo"]
            add_fileset_file [file tail $simgen_name] $lang PATH ${simgen_name}
        }
    } else {
    	send_message ERROR "Cannot generate for specified latency"
    }
}



#
# Before calling cmdPolyEval the directory will be changed to tmp_dir, so 
# if you don't want a directory change specify . for tmp_dir
#
# Returns stdout or stderr of cmdPolyEval
#
proc call_cmdPolyEval { entity_name quartus_dir tmp_dir call_type freq constrainLatency} {
    # call cmdPolyEval here
    # All the dash parameters must come before others
    # target is preferred before frequency
    set module_dir [get_module_property MODULE_DIRECTORY]
    set args [list]
    lappend args "-target"
    set device_family [get_parameter_value selected_device_family]
    lappend args [string map {{ } {}} $device_family]
    if { [is_goal_frequency] || [is_goal_latency] || [is_goal_combined] } {
        lappend args "-frequency"
        lappend args $freq      
    }

    lappend args "-name"
    lappend args $entity_name
    lappend args "-noChanValid"
    lappend args "-faithfulRounding"
    if { [get_parameter_value gen_enable] } {
        lappend args "-enable"
    }
    lappend args "-printMachineReadable"

    switch -exact $call_type {
        report {
            lappend args "-noFileGenerate"
            if { $constrainLatency eq "true" } {
                lappend args "-constrainLatency"
                lappend args [get_parameter_value latency_target]
            }
        }
        
        VHDL {
            lappend args "-lang"
            lappend args "VHDL"
            if { [is_goal_latency] || [is_goal_combined] } {
                lappend args "-constrainLatency"
                lappend args [get_parameter_value latency_target]
            }
        }
        
        VERILOG {
            lappend args "-lang"
            lappend args "SYSTEMVERILOG"
            if { [is_goal_latency] || [is_goal_combined] } {
                lappend args "-constrainLatency"
                lappend args [get_parameter_value latency_target]
            }
        }
    }


    if {[get_parameter_value selected_device_speedgrade] != "Unknown" } {
        lappend args "-speedgrade"
        lappend args [get_parameter_value selected_device_speedgrade]
    }
    lappend args {*}[[get_function_option cmd]]


    set path_to_exe "$quartus_dir/dspba/backend"
    set bitness [expr {[is_64bit] ? "64" : "32"}]
    set prev_dir [pwd]
    cd $tmp_dir
    if { [regexp -nocase win $::tcl_platform(os) match] } {
        append path_to_exe "/windows"
        append path_to_exe $bitness
        # need to expand args otherwise all the arguments will be added as a single list item
        set command_line [list "$path_to_exe/cmdPolyEval" {*}$args] 
        } else {
        append path_to_exe "/linux"
        append path_to_exe $bitness
        # bash shell seems to expand the args into multiple arguments eventually, but let's expand, that's the right thng to do 
        set command_line  [list "$module_dir/cmdPolyEval.sh" $path_to_exe {*}$args] 
    }
    send_message INFO $command_line
    if { [ catch { exec {*}$command_line } output error ] } {
        # if there is an error change directory back before erroring as execution stops at error message
        cd $prev_dir
        return "fail"
    } else {
        cd $prev_dir
    }
    return $output
}

#
# Returns the frequency (in MHz) at which the specified latency is achievable.
# If the latency is not achievable, returns zero or a negative number whose 
# absolute value is the nearest achievable latency.
# The function will give up after a certain number of attempts.
# The function binary searches the 1 to 800 MHz range.
#
proc find_frequency { latency } {
    set quartus_dir [get_quartus_rootdir] 
    set freq 400
    set step [expr $freq/2]
    set t0 [clock clicks -millisec]    
    set output [call_cmdPolyEval "none" $quartus_dir "." "report" $freq "false"]
    set t1 [clock clicks -millisec]
    set time_taken [expr (($t1-$t0)/1000.0)]
    if { [expr $time_taken > 10.0] } {
        send_message ERROR "Frequency Target is too low for this parameterization"
        return 0
    } elseif { [expr $time_taken > 1.0] } {
        send_message WARNING "Frequency search for this target may take up to 10 seconds"
    }
    array set report [extract_report $output]
    set attempts 0
    set max_passing_latency [expr -1]
    set max_passing_frequency 0
    while { true } {
            if { ![info exists report(latency)] || $output eq "fail" } {
                set freq [expr int($freq - $step)]
            } else {
                if { [expr $report(latency) > $latency]  } {
                    set freq [expr int($freq - $step)]
                } else {
                    set  max_passing_latency $report(latency)
                    set  max_passing_frequency $freq
                    set freq [expr int($freq + $step)]
                }
            }

        if { [expr $freq < 1] } {
            break
        }
        if { [expr $attempts > 10] } {
            break
        }        
        set output [call_cmdPolyEval "none" $quartus_dir "." "report" $freq "false"]
        array set report [extract_report $output]
        set step [expr ceil($step/2)]
        incr attempts
        set t2 [clock clicks -millisec]
        set sweep_time [expr (($t2-$t1)/1000.0)]
        if {[expr $sweep_time > 20.0] } {
                break
        }
    }
    if { [expr $max_passing_latency <= $latency] && [expr $max_passing_latency  > -1]} {
        if { [is_goal_latency] } {
            send_message INFO "Could achieve $max_passing_latency cycles latency maximum at Frequency $freq MHz, padding with registers to reach requested $latency cycles latency"
        } 
        set freq $max_passing_frequency
    } else {
         if { [expr $max_passing_latency == -1] } {
            send_message ERROR "Could not achieve the requested latency at any frequency."
            set freq "-1"
         } else {
            send_message ERROR "Could not achieve the requested latency. Nearest achievable latency is $max_passing_latency cycles at $max_passing_frequency MHz"
            set freq "-1"
        }
    }
    return $freq
}





proc get_function_option { option } {
    global fp_family
    global fp_funcs
    set current_family [get_parameter_value FUNCTION_FAMILY]
    set paramname "${current_family}_function"
    set current_function [get_parameter_value $paramname]
    set function_options $fp_funcs($current_function)
    switch -exact $option {
        display_name {
            return [lindex $function_options 0]
        }
        name {
            return [lindex $function_options 1]
        }

        cmd {
            return [lindex $function_options 2]
        }

        validate {
            return [lindex $function_options 3]
        }

        elaborate {
            return [lindex $function_options 4]
        }
    }
    return -1
}

#
# Returns an associative array of field values pairs serialised by array get
#
proc extract_report { output } {
    set startToken @@start
    set endToken @@end
    set s [string first $startToken $output] 
    set e [string first $endToken $output]
    set reportBlock [string range $output [expr $s + [string length $startToken]]  [expr $e -1]]
    set reportBlock [string trim $reportBlock]

    #TODO We should error if there is another @@start or @@end

    set kv_list [split $reportBlock "\n"]
    foreach item $kv_list {
        set item [string trim $item]
        if { [string index $item 0] != "@" || [string index $item end] != "@" } {
            send_message WARNING "Internal Warning: Malformed report from cmdPolyEval, missing @ on line $item"
        }

        set kv [split [string map {@ {}} $item]]
        # if { [info exists report([lindex $kv 0])] == 1 } {
        #     send_message WARNING "Internal Warning: Multiple entries for [lindex $kv 0]"
        # }
        set report([lindex $kv 0]) [lindex $kv 1]
    }
    return [array get report]
}

#
# This procedure will report latency if you pass to it the return value of extract_report
#
proc report_latency { r send_msg } {
    array set report $r
    if { [info exists report(latency)] } {
        set msg "Latency on [get_parameter_value selected_device_family] is $report(latency) cycle"
        if { $report(latency) > 1 } {
            append msg "s"
        }
        set level INFO
    } else {
        set level WARNING
        set msg "Cannot Achieve Frequency at any possible latency"
    }

    if { $send_msg } {
        send_message $level $msg 
    } else {
        set_display_item_property report_pane TEXT $msg
    }
}

add_parameter RES_DSP_param integer 0
set_parameter_property RES_DSP_param VISIBLE false
set_parameter_property RES_DSP_param DERIVED true
set_parameter_property RES_DSP_param DISPLAY_NAME "Multiplies"
set_parameter_property RES_DSP_param  AFFECTS_ELABORATION false
set_parameter_property RES_DSP_param  AFFECTS_GENERATION false

add_parameter RES_LUT_param integer 0
set_parameter_property RES_LUT_param VISIBLE false
set_parameter_property RES_LUT_param DERIVED true
set_parameter_property RES_LUT_param DISPLAY_NAME "LUTs"
set_parameter_property RES_LUT_param  AFFECTS_ELABORATION false
set_parameter_property RES_LUT_param  AFFECTS_GENERATION false

add_parameter RES_MBIT_param integer 0
set_parameter_property RES_MBIT_param VISIBLE false
set_parameter_property RES_MBIT_param DERIVED true
set_parameter_property RES_MBIT_param DISPLAY_NAME "Memory Bits"
set_parameter_property RES_MBIT_param  AFFECTS_ELABORATION false
set_parameter_property RES_MBIT_param  AFFECTS_GENERATION false

add_parameter RES_MBLOCK_param integer 0
set_parameter_property RES_MBLOCK_param VISIBLE false
set_parameter_property RES_MBLOCK_param DERIVED true
set_parameter_property RES_MBLOCK_param DISPLAY_NAME "Memory Blocks"
set_parameter_property RES_MBLOCK_param  AFFECTS_ELABORATION false
set_parameter_property RES_MBLOCK_param  AFFECTS_GENERATION false

add_display_item Report RES_DSP_param PARAMETER
add_display_item Report RES_LUT_param PARAMETER
add_display_item Report RES_MBIT_param PARAMETER
add_display_item Report RES_MBLOCK_param PARAMETER



proc report_resources { r send_msg } {
    array set report $r
    set RES_DSP_msg ""
    set RES_LUT_msg ""
    set RES_MBIT_msg ""
    set RES_MBLOCK_msg ""
    if { [info exists report(LUT)] && [info exists report(DSP)] && [info exists report(RAMBits)] && [info exists report(RAMBlockUsage)] } {
        set RES_DSP_msg     "DSP Blocks Used: $report(DSP)"
        set RES_LUT_msg     "LUTs Used: $report(LUT)"
        set RES_MBIT_msg    "Memory Bits Used: $report(RAMBits)"
        set RES_MBLOCK_msg  "Memory Blocks Used: $report(RAMBlockUsage)"
        set level "INFO"
        if { $send_msg } {
            send_message $level $RES_DSP_msg 
            send_message $level $RES_LUT_msg 
            send_message $level $RES_MBIT_msg 
            send_message $level $RES_MBLOCK_msg 
        } else {
            show_resource_estimates
            set_display_item_property RES_TITLE TEXT "Resource Estimates:"
            set_parameter_value RES_DSP_param     $report(DSP)
            set_parameter_value RES_LUT_param     $report(LUT)
            set_parameter_value RES_MBIT_param    $report(RAMBits)
            set_parameter_value RES_MBLOCK_param  $report(RAMBlockUsage)
        }
    } else { 
        set DSP_msg "Unable to estimate resource usage"
        set level WARNING
        if { $send_msg } {
            send_message $level $DSP_msg 
        } else {
            set_display_item_property RES_TITLE TEXT "Unable to estimate Resource Usage"
            hide_resource_estimates
            set_display_item_property RES_TITLE VISIBLE true
        }
    }

}

proc hide_resource_estimates { } {
    set_parameter_property RES_DSP_param VISIBLE false
    set_parameter_property RES_LUT_param VISIBLE false
    set_parameter_property RES_MBIT_param VISIBLE false
    set_parameter_property RES_MBLOCK_param VISIBLE false
    set_display_item_property RES_TITLE VISIBLE false
}

proc show_resource_estimates { } {
    set_parameter_property RES_DSP_param VISIBLE true
    set_parameter_property RES_LUT_param VISIBLE true
    set_parameter_property RES_MBIT_param VISIBLE true
    set_parameter_property RES_MBLOCK_param VISIBLE true
    set_display_item_property RES_TITLE VISIBLE true
}




#
# This procedure will report latency if you pass to it the return value of extract_report
#
proc report_combined_target { r send_msg } {
    array set report $r
    if { [info exists report(latency)] } {
        if { [expr [get_parameter_value latency_target] < $report(latency)] } {
            set msg "Cannot meet target, FMax too high for requested latency, minimum latency is $report(latency)"
            set level ERROR
        } else {
            set msg "Minimum acheivable latency at given frequency is $report(latency) cycles, register padding will occur to meet latency target if necessary"
            set level INFO
        }
    } else {
        set level ERROR
        set msg "Can't meet FMax at any latency"
    }

    if { $send_msg } {
        send_message $level $msg 
    } else {
        set_display_item_property report_pane TEXT $msg
    }
}

# Return 1 if 64 bit, or 0 otherwise
proc is_64bit {} {
    # Only the native tcl interpreter has 'tcl_platform(pointerSize)'
    # In Jacl however 'tcl_platform(machine)' is set to the JVM bitness, not the OS bitness
    if { [catch {set POINTERSIZE $::tcl_platform(pointerSize)} errmsg] } {
        if {[string match "*64" $::tcl_platform(machine)]} {
            set POINTERSIZE 8
        } else {
            set POINTERSIZE 4
        }
    }
    if { $POINTERSIZE == 8 } {
        set is_64bit 1
    } else {
        set is_64bit 0
    }  
    return $is_64bit
}

# Return 1 if performance goal is frequency
proc is_goal_frequency {} {
 return [expr {[get_parameter_value performance_goal] eq "frequency"}]
}
proc is_goal_latency {} {
 return [expr {[get_parameter_value performance_goal] eq "latency"}]
}
proc is_goal_combined {} {
 return [expr {[get_parameter_value performance_goal] eq "combined"}]
}


proc get_quartus_rootdir {} {
    global env 
    set quartus_dir ${env(QUARTUS_ROOTDIR)}
    return $quartus_dir
}


proc write_report_file { r output_name freq} {
    array set report $r
    if {[info exists report(DSP)]} {
        set params(multiplies)     $report(DSP)
    } else {
        set params(multiplies)     "unknown"
    }
    if { [info exists report(LUT)]} {
        set params(luts)     $report(LUT)
    } else {
        set params(luts)     "unknown"
    }
    if {[info exists report(RAMBits)]} {
        set params(mblocks)    $report(RAMBits)
    } else {
        set params(mblocks)     "unknown"
    }
    if {[info exists report(RAMBlockUsage)] } {
        set params(mbits)  $report(RAMBlockUsage)
    }  else {
        set params(mbits)     "unknown"
    }
   if {[info exists report(latency)] } {
        set params(latency)  $report(latency)
    } else {
        set params(latency)     "unknown"
    }
    set params(frequency) $freq
    set template_path "resource_report.txt.terp"  ;# path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it
    set params(output_name) $output_name ;# template params are element of a Tcl array
    set contents [altera_terp $template params] ;# pass parameter array in by reference
    add_fileset_file "${output_name}_report.xml" OTHER TEXT $contents

}   


