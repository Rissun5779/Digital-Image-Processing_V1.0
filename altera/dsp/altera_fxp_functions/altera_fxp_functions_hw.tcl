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

# Important notes
# The way that DSDK handles complex data types is to create a pair of signals in the generated VHDL,
# prefixed by the input or output block name and with a _real or _imag suffix. 
# For real-valued inputs and outputs there is no prefix or suffix. 
# In the DSDK designs built by this module the input and output blocks are named "in" and "out", thus 
# a function's result output is "result" if real and the pair "out_result_real" and "out_result_imag"
# if complex. 

load_strings altera_fxp_functions.properties

source "../lib/tcl/dspip_common.tcl"

# 
# module altera_fxp_functions
# 
set_module_property NAME altera_fxp_functions
set_module_property VERSION  18.1
set_module_property INTERNAL false
set_module_property AUTHOR [get_string AUTHOR]
set_module_property DISPLAY_NAME ALTERA_FXP_FUNCTIONS 
set_module_property DESCRIPTION [get_string DESCRIPTION]
set_module_property GROUP [get_string GROUP]
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property VALIDATION_CALLBACK validate_input
set_module_property ELABORATION_CALLBACK elaboration_callback
set_module_property PREFERRED_SIMULATION_LANGUAGE VHDL
set_module_property PARAMETER_UPGRADE_CALLBACK upgrade_callback
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QSYS true

set_module_property SUPPORTED_DEVICE_FAMILIES \
{\
{Stratix 10}\
}

## Add documentation links for user guide and/or release notes
add_documentation_link "Release Notes" [get_string RELEASE_NOTES]
add_documentation_link "User Guide" [get_string USER_GUIDE]

# 
# file sets
# 
add_fileset ALTERA_FXP_QUARTUS_SYNTH  QUARTUS_SYNTH  generate_quartus_synth_callback
add_fileset ALTERA_FXP_SIM_VERILOG    SIM_VERILOG    generate_sim_verilog_callback
add_fileset ALTERA_FXP_SIM_VHDL       SIM_VHDL       generate_sim_vhdl_callback
add_fileset ALTERA_FXP_EXAMPLE_DESIGN EXAMPLE_DESIGN generate_example_design_callback

#
# functions list
# the format of the list is 
# [list name cmd_proc validate_proc elaborate_proc]
# cmd_proc should contain the function name and other function specific parameters 
# validate_proc will be run at the end of the validation.
# elaborate_proc should add appropriate data inputs; configurable inputs and outpus as well as 
# clk, reset and if selected enable input will have been added before running this proc.

set funcs(ADD)  [list ADD_DISPLAY_NAME  add_validate  dummy_elaborate add_generate  add_stimulus  ]     
set funcs(MUL)  [list MUL_DISPLAY_NAME  mul_validate  dummy_elaborate mul_generate  mul_stimulus  ]     
set funcs(DIV)  [list DIV_DISPLAY_NAME  div_validate  dummy_elaborate div_generate  div_stimulus  ]     
set funcs(SQRT) [list SQRT_DISPLAY_NAME sqrt_validate dummy_elaborate sqrt_generate sqrt_stimumus ]     
set funcs(SIMPLE_COUNTER)   [list SIMPLE_COUNTER_DISPLAY_NAME   simple_counter_validate   dummy_elaborate \
                                      simple_counter_generate   simple_counter_stimulus]     
set funcs(LOADABLE_COUNTER) [list LOADABLE_COUNTER_DISPLAY_NAME loadable_counter_validate dummy_elaborate \
                                      loadable_counter_generate loadable_counter_stimulus]     

set ALL_LIST     [list ADD MUL DIV SQRT SIMPLE_COUNTER LOADABLE_COUNTER]

set {fn_family(ALL)} [list ALL_GRP $ALL_LIST]

set optional_parameter_names [list]
set interface_names [list]
set complex_format 0

# names of interfaces for which formats must be generated via a DSDK call, and those which have just had
# their output formats generated.
set generated_output_formats_needed [list]
set newly_generated_output_formats  [list]

set prev_optimal_output_format 0
set optimal_output_format_controlling_parameter_names [list]

#########################################################################################################
# low-level helper procedures

proc get_quartus_rootdir {} {
    global env 
    set quartus_dir ${env(QUARTUS_ROOTDIR)}
    return $quartus_dir
}

#########################################################################################################
# Parameter management helper procedures

proc set_parameter_value_if_changed { paramName newValue } {
    if { $newValue != [get_parameter_value $paramName] } {
        set_parameter_value $paramName $newValue
    }
}

proc show_parameters { parameterNames } {
    foreach paramName $parameterNames {
       set_parameter_property $paramName VISIBLE true
    }
}

proc hide_parameters { parameterNames } {
    foreach paramName $parameterNames {
       set_parameter_property $paramName VISIBLE false
    }
}

proc add_boolean_option_parameters { paramNames defaultValue } {
    global optional_parameter_names
    foreach paramName $paramNames {
        lappend optional_parameter_names $paramName
        add_parameter $paramName BOOLEAN $defaultValue
        set_parameter_property $paramName DISPLAY_NAME [get_string "[string toupper $paramName]_DISPLAY_NAME"]
        set_parameter_property $paramName UNITS None
        set_parameter_property $paramName DESCRIPTION  [get_string "[string toupper $paramName]_DESCRIPTION"]
        set_parameter_property $paramName AFFECTS_GENERATION true
    }
}

# The parameter configuration is in <name> <type> <default value> triples
proc add_integer_option_parameters { paramConfiguration {units None} } {
    global optional_parameter_names
    set step 0
    foreach paramConfigurationElement $paramConfiguration {
        if { $step == 0 } {
            set paramName $paramConfigurationElement
            set step 1
        } elseif { $step == 1 } {
            set paramType $paramConfigurationElement
            set step 2
        } else {
            set defaultValue $paramConfigurationElement
            lappend optional_parameter_names $paramName
            add_parameter $paramName $paramType $defaultValue
            set_parameter_property $paramName DISPLAY_NAME [get_string "[string toupper $paramName]_DISPLAY_NAME"]
            set_parameter_property $paramName UNITS $units
            set_parameter_property $paramName DESCRIPTION  [get_string "[string toupper $paramName]_DESCRIPTION"]
            set_parameter_property $paramName AFFECTS_GENERATION true
            set step 0
        }
    }
}

# The root name of a set of parameters does not have a suffix like _caption, _fraction, _sign
# or _width_derived, _fraction_derived, _sign_derived.

proc get_parameter_root_name { parameterName } {
   return [string map { _derived "" _width "" _fraction "" _sign "" _caption ""} ${parameterName}]
}

# "direction" is ignored by this procedure; retained in the parameter list for consistency with other procedures

proc add_interface_count_parameters { direction paramNames minValue maxValue defaultValue } {
    global optional_parameter_names
    foreach paramName $paramNames {
        lappend optional_parameter_names $paramName
        add_parameter ${paramName} POSITIVE $defaultValue
        set_parameter_property ${paramName} DISPLAY_NAME [get_string [string toupper $paramName]_DISPLAY_NAME]
        set_parameter_property ${paramName} UNITS        [get_string [string toupper $paramName]_UNITS]
        set_parameter_property ${paramName} DESCRIPTION  [get_string [string toupper $paramName]_DESCRIPTION]
        set_parameter_property ${paramName} ALLOWED_RANGES "${minValue}:${maxValue}"
        set_parameter_property ${paramName} AFFECTS_GENERATION true
    }
}

proc add_fxp_interface_parameters { direction interfaceNames minWidth maxWidth \
                                    defaultWidth defaultFraction {defaultSign 1} } {
    global optional_parameter_names
    global interface_names
    global optimal_output_format_controlling_parameter_names

    if { $defaultSign == "unsigned" } { 
        set defaultSign 0
    } elseif { $defaultSign == "signed" } {
        set defaultSign 1
    }

    foreach interfaceName $interfaceNames {

        set paramNamePrefix ${interfaceName}_fxp_${direction}

        lappend interface_names $interfaceName
        lappend optional_parameter_names ${paramNamePrefix}_width ${paramNamePrefix}_width_derived \
                                         ${paramNamePrefix}_fraction ${paramNamePrefix}_fraction_derived \
                                         ${paramNamePrefix}_sign  ${paramNamePrefix}_sign_derived 
        if { $direction == "in" } {
            lappend optimal_output_format_controlling_parameter_names \
                    ${paramNamePrefix}_width_derived ${paramNamePrefix}_fraction_derived \
                    ${paramNamePrefix}_sign_derived 
        }

        add_parameter ${paramNamePrefix}_width POSITIVE $defaultWidth
        set_parameter_property ${paramNamePrefix}_width DISPLAY_NAME [get_string FXP_WIDTH_DISPLAY_NAME]
        set_parameter_property ${paramNamePrefix}_width UNITS        [get_string FXP_WIDTH_UNITS]
        set_parameter_property ${paramNamePrefix}_width DESCRIPTION  [get_string FXP_WIDTH_DESCRIPTION]
        set_parameter_property ${paramNamePrefix}_width ALLOWED_RANGES "${minWidth}:${maxWidth}"
        set_parameter_property ${paramNamePrefix}_width AFFECTS_GENERATION true

        add_parameter ${paramNamePrefix}_sign STRING $defaultSign
        set_parameter_property ${paramNamePrefix}_sign DISPLAY_NAME   [get_string FXP_SIGNED_DISPLAY_NAME]
        set_parameter_property ${paramNamePrefix}_sign UNITS          None
        set_parameter_property ${paramNamePrefix}_sign DESCRIPTION    [get_string FXP_SIGNED_DESCRIPTION] 
        set_parameter_property ${paramNamePrefix}_sign ALLOWED_RANGES [list "1:[get_string SIGNED_REP_NAME]" "0:[get_string UNSIGNED_REP_NAME]" ]
        set_parameter_property ${paramNamePrefix}_sign AFFECTS_GENERATION true

        add_parameter ${paramNamePrefix}_fraction INTEGER $defaultFraction
        set_parameter_property ${paramNamePrefix}_fraction DISPLAY_NAME [get_string FXP_FRACTION_DISPLAY_NAME]
        set_parameter_property ${paramNamePrefix}_fraction UNITS        [get_string FXP_FRACTION_UNITS]
        set_parameter_property ${paramNamePrefix}_fraction DESCRIPTION  [get_string FXP_FRACTION_DESCRIPTION]
        set_parameter_property ${paramNamePrefix}_fraction ALLOWED_RANGES "0:${maxWidth}"
        set_parameter_property ${paramNamePrefix}_fraction AFFECTS_GENERATION true

        add_parameter ${paramNamePrefix}_fraction_derived STRING "initialization default"
        set_parameter_property ${paramNamePrefix}_fraction_derived DERIVED TRUE
        set_parameter_property ${paramNamePrefix}_fraction_derived ENABLED FALSE
        set_parameter_property ${paramNamePrefix}_fraction_derived DISPLAY_NAME [get_string FXP_FRACTION_DISPLAY_NAME]
        set_parameter_property ${paramNamePrefix}_fraction_derived UNITS        [get_string FXP_FRACTION_UNITS]
        set_parameter_property ${paramNamePrefix}_fraction_derived DESCRIPTION  [get_string FXP_FRACTION_DESCRIPTION]
        set_parameter_property ${paramNamePrefix}_fraction_derived AFFECTS_GENERATION  true

        add_parameter ${paramNamePrefix}_width_derived STRING "initialization default"
        set_parameter_property ${paramNamePrefix}_width_derived DERIVED TRUE
        set_parameter_property ${paramNamePrefix}_width_derived ENABLED FALSE
        set_parameter_property ${paramNamePrefix}_width_derived DISPLAY_NAME [get_string FXP_WIDTH_DISPLAY_NAME]
        set_parameter_property ${paramNamePrefix}_width_derived UNITS        [get_string FXP_WIDTH_UNITS]
        set_parameter_property ${paramNamePrefix}_width_derived DESCRIPTION  [get_string FXP_WIDTH_DESCRIPTION]
        set_parameter_property ${paramNamePrefix}_width_derived AFFECTS_GENERATION  true

        add_parameter ${paramNamePrefix}_sign_derived STRING "initialization default"
        set_parameter_property ${paramNamePrefix}_sign_derived DERIVED TRUE
        set_parameter_property ${paramNamePrefix}_sign_derived ENABLED FALSE
        set_parameter_property ${paramNamePrefix}_sign_derived DISPLAY_NAME   [get_string FXP_SIGNED_DISPLAY_NAME]
        set_parameter_property ${paramNamePrefix}_sign_derived UNITS          None
        set_parameter_property ${paramNamePrefix}_sign_derived DESCRIPTION    [get_string FXP_SIGNED_DESCRIPTION] 
        set_parameter_property ${paramNamePrefix}_sign_derived AFFECTS_GENERATION  true
    }
}

proc add_int_interface_parameters { direction interfaceNames minWidth maxWidth defaultWidth {defaultSign 1} } {
    add_fxp_interface_parameters $direction $interfaceNames $minWidth $maxWidth $defaultWidth 0 $defaultSign
}

proc derive_fxp_interface_parameter_values { sourceDirection      sourceInterfaceName \
                                             destinationDirection destinationInterfaceName } {
    foreach element { width fraction sign } {
        set_parameter_value ${destinationInterfaceName}_fxp_${destinationDirection}_${element}_derived \
            [get_parameter_value ${sourceInterfaceName}_fxp_${sourceDirection}_${element}]
    }
}
proc propagate_parameter_values_to_derived { paramNames } {
    foreach paramName $paramNames {
puts "propagating $paramName to derived"
        set_parameter_value ${paramName}_derived [get_parameter_value $paramName]
    }
}

proc add_internal_state_parameters { parameterNames parameterType defaultValue } {
    foreach paramName $parameterNames {
        add_parameter $paramName $parameterType $defaultValue 
        set_parameter_property $paramName DERIVED true
        set_parameter_property $paramName VISIBLE false
    }
}

proc get_boolean_parameter_string { paramName } {
    if { [get_parameter_value $paramName] } {
        return "true"
    } else {
        return "false"
    }
}

proc is_boolean_parameter_visible_and_chosen { paramName } {
    return [expr [get_parameter_value $paramName] && [get_parameter_property $paramName VISIBLE]]
}

# get_fxp_format_from_parameters returns a list of sign width and fraction suitable for use by 
# the DSP IP recipe "wire" method.
# get_int_format_from_parameters does the same for integer data 
# They share a common sub-routine get_numeric_format_from_parameters

proc get_numeric_format_from_parameters { interfaceType interfaceName direction { suffix "" } } {
    if { $suffix != "" } {
        set suffix _${suffix}
    }
    set result [list]
    if { [is_complex_format] } {
        lappend result "complex"
    }
    if { [get_parameter_value ${interfaceName}_fxp_${direction}_sign${suffix}] == 1 } {
       lappend result "signed"
    } else {
       lappend result "unsigned"
    }
    lappend result [get_parameter_value ${interfaceName}_fxp_${direction}_width${suffix}] 
    if { $interfaceType == "int" } {
        lappend result "0"
    } else {
        lappend result [get_parameter_value ${interfaceName}_fxp_${direction}_fraction${suffix}]
    }
    return $result
}

proc get_fxp_format_from_parameters { interfaceName direction { suffix "" } } {
    return [get_numeric_format_from_parameters fxp $interfaceName $direction $suffix] 
}

proc get_int_format_from_parameters { interfaceName direction { suffix "" } } {
    return [get_numeric_format_from_parameters int $interfaceName $direction $suffix]
}

##########################################################################################################
# Display item management helpers
# Note that interface captions have a clarifying "components" suffix when a complex data format is selected
# The complex_format parameter cannot be referenced in set_fxp_interface_display_caption as this proc 
# is used at global level during initialisation. 

proc add_button { group buttonName callbackProc } {
    add_display_item $group $buttonName ACTION $callbackProc
    set_display_item_property $buttonName DISPLAY_NAME [get_string [string toupper $buttonName]_DISPLAY_NAME]
    set_display_item_property $buttonName DESCRIPTION  [get_string [string toupper $buttonName]_DESCRIPTION]
}

proc set_fxp_interface_display_caption { direction interfaceName } {
    global complex_format
    if { [string length $interfaceName] > 1 } {
        set title "[string totitle ${interfaceName}]"
    } elseif { $direction == "out" } {
        set title "Output [string totitle ${interfaceName}]" 
    } else {
        set title "Input [string totitle ${interfaceName}]" 
    }
    if { $complex_format } {
        set title "${title} (${direction}_${interfaceName}_real, ${direction}_${interfaceName}_imag)"
    }
    set_display_item_property ${interfaceName}_fxp_${direction}_caption TEXT $title
}

proc add_fxp_interface_display_caption { group direction interfaceName } {
    add_display_item $group ${interfaceName}_fxp_${direction}_caption TEXT ""
    set_fxp_interface_display_caption $direction $interfaceName
}

# A set of format parameters share a caption, the visibility of which can be used to determine whether
# the associated parameters are active. 

proc set_parameter_caption_visible { parameterName newValue } {
   set_display_item_property [get_parameter_root_name $parameterName]_caption VISIBLE $newValue
}

proc is_parameter_caption_visible { parameterName } {
   return [expr {[get_display_item_property  [get_parameter_root_name $parameterName]_caption VISIBLE] != 0}]
}

proc add_fxp_interface_displays { group direction interfaceNames } {
    foreach interfaceName $interfaceNames {
        add_fxp_interface_display_caption $group $direction $interfaceName
        add_display_item $group ${interfaceName}_fxp_${direction}_width PARAMETER
        add_display_item $group ${interfaceName}_fxp_${direction}_fraction PARAMETER
        add_display_item $group ${interfaceName}_fxp_${direction}_sign PARAMETER
        add_display_item $group ${interfaceName}_fxp_${direction}_width_derived PARAMETER
        add_display_item $group ${interfaceName}_fxp_${direction}_fraction_derived PARAMETER
        add_display_item $group ${interfaceName}_fxp_${direction}_sign_derived PARAMETER
    }
}

proc add_int_interface_displays { group direction interfaceNames } {
    foreach interfaceName $interfaceNames {
        add_fxp_interface_display_caption $group $direction $interfaceName
        add_display_item $group ${interfaceName}_fxp_${direction}_width PARAMETER
        add_display_item $group ${interfaceName}_fxp_${direction}_sign PARAMETER
        add_display_item $group ${interfaceName}_fxp_${direction}_width_derived PARAMETER
        add_display_item $group ${interfaceName}_fxp_${direction}_sign_derived PARAMETER
    }
}

proc add_boolean_option_displays { group optionNames } { 
    foreach optionName $optionNames {
        add_display_item $group $optionName PARAMETER
    }
}

proc add_integer_option_displays { group optionNames } { 
    foreach optionName $optionNames {
        add_display_item $group $optionName PARAMETER
    }
}

# if not derived, the parameter values are also pushed to the derived parameters
# aspects of the format are width, fraction, and sign
proc show_fxp_format_parameters { baseNames direction aspectNames suffix } {
    if { $suffix != "" } {
        set suffix _$suffix
    }
    foreach baseName $baseNames {
        set aspectParameterNames         [list]
        set suffixedAspectParameterNames [list]
        foreach aspectName $aspectNames {
            lappend aspectParameterNames ${baseName}_fxp_${direction}_${aspectName}
            lappend suffixedAspectParameterNames ${baseName}_fxp_${direction}_${aspectName}${suffix}
        }
        if { $suffix != "_derived" } {
            propagate_parameter_values_to_derived $aspectParameterNames
        }
        set_fxp_interface_display_caption $direction $baseName
        set_parameter_caption_visible ${baseName}_fxp_${direction}_caption TRUE
        show_parameters $suffixedAspectParameterNames
    }
}

proc show_fxp_input_format_parameters { inputNames {suffix ""} } {
    show_fxp_format_parameters $inputNames in { sign width fraction } $suffix    
}

proc show_fxp_output_format_parameters { outputNames {suffix ""} } {
    show_fxp_format_parameters $outputNames out { sign width fraction } $suffix    
}

proc show_int_input_format_parameters { inputNames {suffix ""} } {
    show_fxp_format_parameters $inputNames in { sign width } $suffix    
}

proc show_int_output_format_parameters { outputNames {suffix ""} } {
    show_fxp_format_parameters $outputNames out { sign width } $suffix    
}

proc show_unsigned_input_format_parameters { inputNames {suffix ""} } {
    show_fxp_format_parameters $inputNames in { width } $suffix    
    foreach inputName $inputNames {
        set_parameter_value ${inputName}_fxp_in_sign_derived 0 
    }
}

proc show_unsigned_output_format_parameters { outputNames {suffix ""} } {
    show_fxp_format_parameters $outputNames out { width } $suffix    
    foreach outputName $outputNames {
        set_parameter_value ${outputName}_fxp_out_sign_derived 0 
    }
}

##########################################################################################################
# Define parameters, display, and UI callbacks 
# 

# behaviour parameters
add_parameter defer_output_format_calc BOOLEAN false
set_parameter_property defer_output_format_calc VISIBLE false


#Create a top level list of all the groups
set FUNCTION_GROUP_NAMES {}
foreach name [array names fn_family] {
    set family $fn_family($name)
    lappend FUNCTION_GROUP_NAMES "$name:[get_string [lindex $family 0]]"             
}

add_parameter FUNCTION_FAMILY STRING   "[lindex [array names fn_family] 0]"
set_parameter_property FUNCTION_FAMILY DISPLAY_NAME [get_string FUNCTION_FAMILY_DISPLAY_NAME]
set_parameter_property FUNCTION_FAMILY UNITS None
set_parameter_property FUNCTION_FAMILY ALLOWED_RANGES [lsort $FUNCTION_GROUP_NAMES]
set_parameter_property FUNCTION_FAMILY DESCRIPTION [get_string FUNCTION_FAMILY_DESCRIPTION] 
set_parameter_property FUNCTION_FAMILY AFFECTS_GENERATION true
set_parameter_property FUNCTION_FAMILY AFFECTS_ELABORATION true
set_parameter_property FUNCTION_FAMILY VISIBLE false
add_display_item Function FUNCTION_FAMILY PARAMETER

add_parameter derivedfunction STRING
set_parameter_property derivedfunction VISIBLE FALSE
set_parameter_property derivedfunction DERIVED TRUE
lappend optimal_output_format_controlling_parameter_names derivedFunction

#For each group of functions populate a parameter 
foreach current_family [array names fn_family] {
    set family $fn_family($current_family)
    set family_operations [lindex $family 1] 
    set ops {}
    foreach op $family_operations {
        set function $funcs($op)
        set default $op
        lappend ops "$op:[get_string [lindex $function 0]]"
    }
    set default [lindex $family_operations 0] 
    set default_display $funcs($default)
    set default_display [lindex $default_display 0]
    set paramname "${current_family}_function"

    add_parameter "$paramname" STRING "[lindex $family_operations 0]"
    set_parameter_property "$paramname" DISPLAY_NAME [get_string "[string toupper ${paramname}]_DISPLAY_NAME"]
    set_parameter_property "$paramname" DESCRIPTION  [get_string "[string toupper ${paramname}]_DESCRIPTION"]
    set_parameter_property "$paramname" VISIBLE true
    set_parameter_property "$paramname" ALLOWED_RANGES $ops
    set_parameter_property "$paramname" AFFECTS_GENERATION  true
    set_parameter_property "$paramname" AFFECTS_ELABORATION true
    set_parameter_property "$paramname" AFFECTS_VALIDATION  true
    add_display_item Function $paramname PARAMETER
}

add_parameter frequency_target POSITIVE 200 
set_parameter_property frequency_target DISPLAY_NAME [get_string FREQUENCY_TARGET_DISPLAY_NAME]
set_parameter_property frequency_target UNITS        [get_string FREQUENCY_TARGET_UNITS]
set_parameter_property frequency_target DESCRIPTION  [get_string FREQUENCY_TARGET_DESCRIPTION]
set_parameter_property frequency_target ALLOWED_RANGES 20:2000
set_parameter_property frequency_target AFFECTS_GENERATION true

add_parameter latency_target NATURAL 2 
set_parameter_property latency_target DISPLAY_NAME [get_string LATENCY_TARGET_DISPLAY_NAME]
set_parameter_property latency_target VISIBLE false
set_parameter_property latency_target UNITS        [get_string LATENCY_TARGET_UNITS]
set_parameter_property latency_target DESCRIPTION  [get_string LATENCY_TARGET_DESCRIPTION]
set_parameter_property latency_target AFFECTS_GENERATION true

add_parameter performance_goal STRING "frequency" 
set_parameter_property performance_goal DISPLAY_NAME [get_string PERFORMANCE_GOAL_DISPLAY_NAME]
set_parameter_property performance_goal UNITS None
set_parameter_property performance_goal ALLOWED_RANGES [list "frequency:[get_string FREQUENCY_REP_NAME]" "latency:[get_string LATENCY_REP_NAME]" "combined:[get_string COMBINED_REP_NAME]"]
set_parameter_property performance_goal DESCRIPTION [get_string PERFORMANCE_GOAL_DESCRIPTION]
set_parameter_property performance_goal AFFECTS_GENERATION true

add_parameter common_sign STRING 1
set_parameter_property common_sign DISPLAY_NAME   [get_string FXP_SIGNED_DISPLAY_NAME]
set_parameter_property common_sign DESCRIPTION    [get_string FXP_SIGNED_DESCRIPTION] 
set_parameter_property common_sign ALLOWED_RANGES [list "1:[get_string SIGNED_REP_NAME]" "0:[get_string UNSIGNED_REP_NAME]" ]
set_parameter_property common_sign AFFECTS_GENERATION true
lappend optional_parameter_names common_sign

add_boolean_option_parameters { complex_format complex_karatsuba   } false
add_boolean_option_parameters { optimal_output_format              } false
add_boolean_option_parameters { gen_enable                         } false
add_boolean_option_parameters { add_no_growth  force_mult_in_logic } false

add_parameter report_resources_to_xml boolean 0
set_parameter_property report_resources_to_xml visible false

add_interface_count_parameters in { num_inputs } 1 8 2

lappend optimal_output_format_controlling_parameter_names \
        optimal_output_format complex_format add_no_growth num_inputs

# Interface Configuration for computational cores
# numbers at end: min width, max width, default width, default fraction bits
# Input interface parameters are automatically added to the list of parameters which
# affect the optimal output format
add_fxp_interface_parameters in { a b c d e f g h } 4 64 32 0
add_fxp_interface_parameters in { radical numerator denominator } 4 32 32 0
add_fxp_interface_parameters out { result } 4 64 32 0

# Values & interface configuration for state-machine cores
add_integer_option_parameters { initial_value INTEGER  0  \
                                step_value    INTEGER  1 \
                                limit_value   INTEGER  65536 }
add_int_interface_parameters in { initial step limit } 4 64 32 unsigned
add_int_interface_parameters out { value } 4 64 32 unsigned

lappend optimal_output_format_controlling_parameter_names \
        initial_value step_value limit_value

# The following parameters serve only to hold internal state
add_internal_state_parameters { frequency_feedback latency_feedback force_elaborate } INTEGER 0
set_parameter_property force_elaborate AFFECTS_ELABORATION true

set performance_button_pressed false
set resource_button_pressed false
set output_width_button_pressed false

# 
# display items
# 
add_display_item "" Functionality GROUP
set_display_item_property Functionality DISPLAY_HINT TAB

add_display_item "" Performance GROUP
set_display_item_property Performance DISPLAY_HINT TAB


add_display_item Functionality "Function" GROUP
add_display_item Function derivedfunction PARAMETER
add_display_item Function common_sign     PARAMETER
add_boolean_option_displays Function { complex_format complex_karatsuba } 

add_display_item Functionality "Counter Setup" GROUP
add_integer_option_displays "Counter Setup" { initial_value step_value limit_value }
 
add_display_item Functionality "Input Data Widths" GROUP
add_display_item "Input Data Widths" num_inputs PARAMETER
add_fxp_interface_displays "Input Data Widths" in { a b c d e f g h radical numerator denominator }
add_int_interface_displays "Input Data Widths" in { initial step limit }

add_display_item Functionality "Output Data Widths" GROUP
add_boolean_option_displays "Output Data Widths" { optimal_output_format } 
add_fxp_interface_displays "Output Data Widths" out { result }
add_int_interface_displays "Output Data Widths" out { value }
add_button "Output Data Widths" check_output_width_button output_width_button_proc

add_display_item Functionality "Options" GROUP
add_boolean_option_displays Options { force_mult_in_logic add_no_growth gen_enable } 

add_display_item Performance "Target" GROUP
add_display_item Target performance_goal PARAMETER
add_display_item Target frequency_target PARAMETER
add_display_item Target latency_target   PARAMETER

add_display_item Performance "Report" GROUP
add_display_item Report report_pane TEXT ""
add_button Report check_performance_button performance_button_proc
add_display_item Report RES_TITLE TEXT ""

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

add_parameter selected_device_part STRING "Unknown"
set_parameter_property selected_device_part VISIBLE false
set_parameter_property selected_device_part SYSTEM_INFO {DEVICE}

add_parameter selected_device_speedgrade STRING "Unknown"
set_parameter_property selected_device_speedgrade VISIBLE false
set_parameter_property selected_device_speedgrade SYSTEM_INFO {DEVICE_SPEEDGRADE}

#
# status of validation so that estimation and/or generation can be predicated on this
#
add_parameter validation_failed BOOLEAN false
set_parameter_property validation_failed VISIBLE false
set_parameter_property validation_failed DERIVED true

##########################################################################################################
# UI mechanics

# Return 1 if performance goal is frequency, latency, or combined
proc is_goal_frequency {} {
    return [expr {[get_parameter_value performance_goal] eq "frequency"}]
}
proc is_goal_latency {} {
    return [expr {[get_parameter_value performance_goal] eq "latency"}]
}
proc is_goal_combined {} {
    return [expr {[get_parameter_value performance_goal] eq "combined"}]
}

proc is_complex_format {} {
    return [is_boolean_parameter_visible_and_chosen complex_format]
}

proc has_global_enable {} {
    return [is_boolean_parameter_visible_and_chosen gen_enable]
}

# button callback procedures need to force elaborate because if no UI changes have been made the
# the elaborate callback would not otherwise be called

proc performance_button_proc {} {
    #we need to force elaborate because if the frequency is the same the elaborate callback will
    #not be called, and no information message will be printed.
    set_parameter_value force_elaborate [expr [get_parameter_value force_elaborate] ^ 1]
    if { [is_goal_latency] || [is_goal_combined] } {
        set_parameter_value frequency_feedback [find_frequency [get_parameter_value latency_target]] 
    } else {
        set_parameter_value frequency_feedback [get_parameter_value frequency_target]
    }
    set_performance_button_pressed true
}

proc resource_button_proc {} {
    set_parameter_value force_elaborate [expr [get_parameter_value force_elaborate] ^ 1]
    if { [is_goal_frequency] } {
            set_parameter_value frequency_feedback [find_frequency [get_parameter_value latency_target]] 
    }
    set_resource_button_pressed true
}

proc output_width_button_proc {} {
    set_parameter_value force_elaborate [expr [get_parameter_value force_elaborate] ^ 1]
    set_output_width_button_pressed true
}

proc set_performance_button_pressed { val } {
    global performance_button_pressed
    set performance_button_pressed $val
}
proc get_performance_button_pressed { } {
    global performance_button_pressed
    return $performance_button_pressed
}

proc set_resource_button_pressed { val } {
    global resource_button_pressed
    set resource_button_pressed $val
}
proc get_resource_button_pressed { } {
    global resource_button_pressed
    return $resource_button_pressed
}

proc set_output_width_button_pressed { val } {
    global output_width_button_pressed
    set output_width_button_pressed $val
}
proc get_output_width_button_pressed { } {
    global output_width_button_pressed
    return $output_width_button_pressed
}

##########################################################################################################

proc get_function_option { option } {
    global fn_family
    global funcs
    set current_family [get_parameter_value FUNCTION_FAMILY]
    set paramname "${current_family}_function"
    set current_function [get_parameter_value $paramname]
    set function_options $funcs($current_function)
    switch -exact $option {
        display_name {
            return [lindex $function_options 0]
        }
        validate {
            return [lindex $function_options 1]
        }
        elaborate {
            return [lindex $function_options 2]
        }
        generate {
            return [lindex $function_options 3]
        }
        stimulus {
            return [lindex $function_options 4]
        }
    }
    return -1
}

##########################################################################################################
# Fixed-point logic emulation - to support generation of ATB stimulus files

# Note that Tcl's rand() function has an effective 31-bit resolution and returns a value in the
# range (0,1). Thus following the Tcl man page, to get random numbers in an integer range, we
# use first_value + round(floor(rand() * (first_value - last_value + 1)))
# e.g. to get integers from 0 to 32767 inclusive and with equal probability, 
#    0 + round(floor(rand() * 32768))
proc int_rand { first_value last_value } {
    return [expr $first_value + round(floor(rand() * ($last_value - $first_value + 1)))]
}

# fxp_random { type value }
# Generates a random value of the specified type (specification as returned by 
# get_fxp_format_from_parameters). 
# Since the value is always an integer, there is no need to take the position of the
# fixed point (if any) into account. 

proc fxp_random { type_info } {
    if { "complex" == [lindex $type_info 0] } {
        set sign  [lindex $type_info 1]
        set width [lindex $type_info 2]
    } else {
        set sign  [lindex $type_info 0]
        set width [lindex $type_info 1]
    }
    if { $sign == "signed" } {
        set first_value [expr -round(pow(2,$width-1))]
        set last_value  [expr round(pow(2,$width-1))-1]
    } else {
        set first_value 0
        set last_value  [expr round(pow(2,$width))-1]
    }
    if { "complex" == [lindex $type_info 0] } {
        return { [int_rand $first_value $last_value] [int_rand $first_value $last_value] }
    } else {
        return [int_rand $first_value $last_value]
    }
}

# All of the emulation functions take as parameters a list of operands and the desired result type.
# Each operand is itself a list containing a type specification and either a scalar value or in
# the case of complex-valued data a list containing the real and imaginary components of the value. 
# The return value is one of
#    "invalid" if one of the operands had a value of "invalid", the operation does not have a valid
#        result, or the result would overflow the specified result data type.
#    an integer value for signed and unsigned result data types
#    a list containing two integer values, if the result data type is complex
#
# NB not all cases are covered by these functions, just the ones needed to generate stiumulus data
# for the logic cores as presently specified. 

proc fxp_operands_valid { operands } {
    foreach operand $operands {
        set operand_type  [lindex $operand 0]
        set operand_value [lindex $operand 1]
        if { "invalid" == $operand_value } {
            return false
        }
        if { "complex" == $operand_type } {
            if { ("invalid" == [lindex $operand_value 0]) || ("invalid" == [lindex $operand_value 1]) } {
                return false
            }
        }
    }
    return true
}

# returns true if value can be represented in the data type's width (taking sign into account), 
# otherwise false

proc fxp_bounds_check { data_type value } {
    if { "invalid" == $value } {
        return false
    } elseif { "complex" == [lindex $data_type 0] } {
        set simple_data_type [lreplace $data_type 0 0]
        if { [fxp_bounds_check $simple_data_type [lindex $value 0] && \
             [fxp_bounds_check $simple_data_type [lindex $value 1] } {
            return true
        } else {
            return false
        }
    } else { ;# not complex
        set width [lindex $data_type 1]
        if { "signed" == [lindex $data_type 0] } {
            set min_value [expr -pow(2,$width-1)]
            set max_value [expr pow(2,$width-1)-1]
        } else {
            set min_value 0
            set max_value [expr pow(2,$width)-1]
        }
        if { ($value < $min_value) || ($value > $max_value) } {
            return false
        } else {
            return true
        }  
    }
}

# Given a fixed-point operand and a target type, coerce the operand value to the new type,
# setting the value element to "invalid" if it overflows. The return value is just the numeric part
# of the value. 
# All that this function really does is to shift the value left or right based on the change in the
# number of fractional bits. 
# Complex values having an imaginary part are still considered to be valid when coercing to a simple
# type. 
# If the "truncate_on_overflow" option is specified, overflow is handled by truncating the output
# value to the specified width rather than returning "invalid"

proc fxp_coerce_type { operand result_type { options {} } } {
    set operand_value    [lindex $operand 1]
    set operand_type     [lindex $operand 0]
    set result_must_be_signed false
    if { "complex" != [lindex $operand_type 0] } {
        set operand_is_complex false
    } else {
        set operand_is_complex true
        set operand_type [lreplace $operand_type 0 0]
    }
    set operand_sign     [lindex $operand_type 0]
    set operand_width    [lindex $operand_type 1]
    set operand_fraction [lindex $operand_type 2]
    if { "complex" != [lindex $result_type 0] } {
        set result_is_complex false
        set simple_result_type $result_type
    } else {
        set result_is_complex true
        set simple_result_type [lreplace $result_type 0 0]
    }
    set result_sign     [lindex $simple_result_type 0]
    set result_width    [lindex $simple_result_type 1]
    set result_fraction [lindex $simple_result_type 2]
    set result_value    $operand_value
    if { $result_value != "invalid" } {
        if { $operand_is_complex } {
            set result_value_real [lindex $result_value 0]
            set result_value_imag [lindex $result_value 1]
        } else {
            set result_value_real $result_value
            set result_value_imag 0
        }
        if { $result_fraction >= $operand_fraction } {
            set result_value_real [expr $result_value_real * round(pow(2,$result_fraction - $operand_fraction))]
            set result_value_imag [expr $result_value_imag * round(pow(2,$result_fraction - $operand_fraction))]
        } else {
            set result_value_real [expr $result_value_real / round(pow(2,$operand_fraction - $result_fraction))]
            set result_value_imag [expr $result_value_imag / round(pow(2,$operand_fraction - $result_fraction))]
        }
        if { $result_is_complex } {
            set result_value [list $result_value_real $result_value_imag]
            if { ($result_value_real < 0) || ($result_value_imag < 0) } {
                set result_must_be_signed true
            }
        } else {
            set result_value $result_value_real
            if { $result_value < 0 } {
                set result_must_be_signed true
            }
        }
    }
    if { ![fxp_bounds_check $result_type $result_value] } {
        if { ("unsigned" == $result_sign) && $result_must_be_signed } {
            set result_value "invalid"
        } elseif { [lsearch $options "truncate_on_overflow"] == -1 } {
            set result_value "invalid"
        } else {
            set unsigned_upper_bound [expr round(pow(2,$result_width))]
            set signed_upper_bound   [expr round(pow(2,$result_width-1))]
            if { $result_is_complex } {
                set result_value_real [expr $result_value_real % $unsigned_upper_bound]
                set result_value_imag [expr $result_value_imag % $unsigned_upper_bound]
                if { ("signed" == $result_sign) && ($result_value_real >= $signed_upper_bound) } {
                    set result_value_real [expr $result_value_real - $unsigned_upper_bound]
                }
                if { ("signed" == $result_sign) && ($result_value_imag > $signed_upper_bound) } {
                    set result_value_imag [expr $result_value_imag - $unsigned_upper_bound]
                }
                set result_value [list $result_value_real $result_value_imag]
            } else {
                set result_value [expr $result_value % $unsigned_upper_bound]
                if { ("signed" == $result_sign) && ($result_value > $signed_upper_bound) } {
                    set result_value [expr $result_value - $unsigned_upper_bound]
                }
            }
        }
    }
    return $result_value
}

# Note: does not presently cater for complex-valued operands
proc fxp_add { operands result_type } {
    if { ![fxp_operands_valid $operands] } {
        return "invalid"
    } else {
        set is_first_operand 1
        foreach operand $operands {
            set operand_value [lindex $operand 1]
            set operand_type  [lindex $operand 0]
            set operand_sign     [lindex $operand_type 0]
            set operand_width    [lindex $operand_type 1]
            set operand_fraction [lindex $operand_type 2]
            if { $is_first_operand == 1 } {
                set is_first_operand 0
                set out_sign      $operand_sign
                set out_width     $operand_width
                set out_fraction  $operand_fraction
                set out_value     $operand_value
            } else {
                set prev_out_fraction $out_fraction
                if { "signed" == $operand_sign } {
                    set out_sign "signed"
                }
                set out_fraction  [expr max($out_fraction, $operand_fraction)]
                set non_frac_bits [expr max($out_width - $out_fraction, $operand_width - $operand_fraction)]
                set out_width     [expr $non_frac_bits + $out_fraction]
                set shifted_out_value     [expr $out_value * round(pow(2,$out_fraction - $prev_out_fraction))]
                set shifted_operand_value [expr $operand_value * round(pow(2,$out_fraction - $operand_fraction))]
                set out_value     [expr $shifted_out_value + $shifted_operand_value]
            }
        }
        return [fxp_coerce_type [list [list $out_sign $out_width $out_fraction ] $out_value ] $result_type ]
    } 
}

# multiplication doubles the output width; therefore if the user-specified output width is
# less than the sum of the input widths the majority of possible input values will result in 
# overflow. Therefore the fxp_mult function also models fixed-point overflow, providing a 
# numeric result rather than "invalid". 
proc fxp_mult { operands result_type } {
    if { ![fxp_operands_valid $operands] } {
        return "invalid"
    } else {
        set is_first_operand 1
        foreach operand $operands {
            set operand_value [lindex $operand 1]
            set operand_type  [lindex $operand 0]
            if { "complex" != [lindex $operand_type 0] } {
                set operand_is_complex false
                set simple_operand_type $operand_type
            } else {
                set operand_is_complex true
                set simple_operand_type [lreplace $operand_type 0 0] ;# drop complex specifier
            }
            set operand_sign     [lindex $simple_operand_type 0]
            set operand_width    [lindex $simple_operand_type 1]
            set operand_fraction [lindex $simple_operand_type 2]
            if { $is_first_operand == 1 } {
                set is_first_operand 0
                set out_is_complex $operand_is_complex
                set out_sign       $operand_sign
                set out_width      $operand_width
                set out_fraction   $operand_fraction
                set out_value      $operand_value
            } else {
                set prev_out_fraction $out_fraction
                if { "signed" == $operand_sign } {
                    set out_sign "signed"
                }
                set out_width     [expr $out_width + $operand_width]
                set out_fraction  [expr $out_fraction + $operand_fraction]
                if { (!$operand_is_complex) && (!$out_is_complex) } {
                    set out_value [expr $out_value * $operand_value]
                } elseif { !$operand_is_complex } {
                    set out_value { [expr $operand_value * [lindex $out_value 0]] \
                                    [expr $operand_value * [lindex $out_value 1]] }
                } elseif { !$out_is_complex } {
                    set out_value { [expr $out_value * [lindex $operand_value 0]] \
                                    [expr $out_value * [lindex $operand_value 1]] }
                    set out_is_complex true
                } else {
                    set out_width [expr $out_width + 1]   ;#growth due to add
                    set out_real  [expr ([lindex $out_value 0] * [lindex $operand_value 0]) - \
                                        ([lindex $out_value 1] * [lindex $operand_value 1])]
                    set out_imag  [expr ([lindex $out_value 0] * [lindex $operand_value 1]) + \
                                        ([lindex $out_value 1] * [lindex $operand_value 0])]
                    set out_value [list $out_real $out_imag]
                }
            }
        }
        if { $out_is_complex } {
            return [fxp_coerce_type [list [list "complex" $out_sign $out_width $out_fraction] $out_value] \
                   $result_type [list "truncate_on_overflow"] ]
        } else {
            return [fxp_coerce_type [list [list $out_sign $out_width $out_fraction] $out_value] \
                   $result_type [list "truncate_on_overflow"] ]
        }
    } 
}

proc fxp_div { operands result_type } {
    if { ![fxp_operands_valid $operands] } {
        return "invalid"
    } else {
        set numerator   [lindex $operands 0]
        set numerator_value [lindex $numerator 1]
        set numerator_type  [lindex $numerator 0]
        set numerator_sign     [lindex $numerator_type 0]
        set numerator_width    [lindex $numerator_type 1]
        set numerator_fraction [lindex $numerator_type 2]
        set denominator [lindex $operands 1]
        set denominator_value [lindex $denominator 1]
        set denominator_type  [lindex $denominator 0]
        set denominator_sign     [lindex $denominator_type 0]
        set denominator_width    [lindex $denominator_type 1]
        set denominator_fraction [lindex $denominator_type 2]

        if { $denominator_value == 0 } { 
            return "invalid"
        } else {
            if { ("signed" == $numerator_sign) || ("signed" == $denominator_sign) } {
                set out_sign "signed"
                set out_width [expr $numerator_width + $denominator_width + 1]
            } else {
                set out_sign "unsigned"    
                set out_width [expr $numerator_width + $denominator_width]
            }
            set out_fraction [expr $numerator_fraction + ($denominator_width - $denominator_fraction)]
            set shifted_numerator_value [expr $numerator_value * round(pow(2,$out_fraction - $numerator_fraction))]
            set out_value    [expr $shifted_numerator_value / $denominator_value]
            return [fxp_coerce_type [list [list $out_sign $out_width $out_fraction] $out_value] $result_type]
        }
    } 
}

# The sqrt core has the same output type as its input - so we don't try to second-guess the type here
proc fxp_sqrt { operands result_type } {
    if { ![fxp_operands_valid $operands] } {
        return "invalid"
    } else {
        set operand [lindex $operands 0]
        set operand_value [lindex $operand 1]
        set operand_type  [lindex $operand 0]
        set operand_sign     [lindex $operand_type 0]
        set operand_width    [lindex $operand_type 1]
        set operand_fraction [lindex $operand_type 2]
        if { $operand_value < 0 } {
            return "invalid"
        } else {
            set shifted_operand_value [expr $operand_value * round(pow(2,$operand_fraction))]
            set out_value [expr round(sqrt($shifted_operand_value))]
            return [fxp_coerce_type [list [list $operand_sign $operand_width $operand_fraction] $out_value] \
                                    $result_type]
        }
    } 
}

##########################################################################################################
# Stimulus file writer support functions
#
# The data_type parameter to write_stimulus_record and pad_stimulus_file is as returned from 
# get_fxp_format_from_parameters.
# write_stimulus_record takes an open file handle and a list of type-value mappings for the stimulus data.
# The type is a list, and the value is either a single number or (in the case of complex-valued data)
# a list containing two numeric values. 
# For data types other than complex, if two numeric values are present in the type-value mapping the
# second value is ignored.
# Data wider than 32 bits are broken into 32 bit wide chunks, least significant chunk first.  
# 32-bit chunks are stored as signed integers that will result in the desired bit pattern, narrower 
# chunks are stored as unsigned integers. 
#
# In general the flow of a stimulus file generator is
#    pad the "out" file with dummy values for each cycle of latency 
#    for each requested cycle
#        find a random set of inputs that will result in a known-valid output
#        write the input values to the stimulus input file
#        write the expected output value to the stimulus output file
# This flow is provided by the fxp_function_stimulus procedure which takes the name of a Tcl function
# that emulates the logic behaviour, together with the names of its inputs and outputs.
# Where the emulator indicates that the inputs do not result in a known-good output, they are not
# included in the stimulus file as the goal of the test is to confirm that, given valid input, the 
# logic produces valid output. 

proc write_stimulus_item { stim_fileID value width } {
    set max32bit       [expr round(pow(2,32))-1]
    set maxSigned32bit [expr round(pow(2,31))-1]
    set workingValue   $value
    if { $value < 0 } {
        set workingValue [expr -($value + 1)]
    }
    for { set bitOffset 0 } { $bitOffset < $width } { incr bitOffset 32 } {
        set chunkWidth   [expr $width - $bitOffset]
        set chunk        [expr $workingValue % ($max32bit + 1)]
        set workingValue [expr round(floor($workingValue / ($max32bit + 1)))]
        if { $value < 0 } {
            set chunk [expr $chunk ^ $max32bit]
        }
        if { $chunk > $maxSigned32bit } {
            set chunk [expr $chunk - $max32bit - 1]
        }
        if { ($chunkWidth < 32) && ($chunk < 0) } {  ;# stimulus reader expects an unsigned value
puts -nonewline $chunk
            set chunk [expr $chunk & round(pow(2,$chunkWidth)-1)]
puts " now $chunk"
        }
        puts -nonewline $stim_fileID "${chunk}\t"
    }
}

proc write_stimulus_record { stim_fileID types_and_values } {
    foreach type_and_value $types_and_values {
        set typeInfo  [lindex $type_and_value 0]
        if { "complex" != [lindex $typeInfo 0] } {
            write_stimulus_item $stim_fileID [lindex $type_and_value 1] [lindex $typeInfo 1]
        } else {
            set complex_value [lindex $type_and_value 1]
            write_stimulus_item $stim_fileID [lindex $complex_value 0] [lindex $typeInfo 2]
            write_stimulus_item $stim_fileID [lindex $complex_value 1] [lindex $typeInfo 2]
        }
    }
    puts $stim_fileID ""
}

proc pad_stimulus_file { stim_fileID data_type cycles } {
    for { set cycle 0 } { $cycle < $cycles } { incr cycle } {
        if { "complex" != [lindex $data_type 0] } {
            write_stimulus_record $stim_fileID [list [list $data_type 0]]
        } else {
            write_stimulus_record $stim_fileID [list [list $data_type [list 0 0]]]
        }
    }
}

proc fxp_function_stimulus { stim_in_fileID stim_out_fileID cycles latency \
                             fxp_function_emulator input_names output_name } {
    set inputTypes [list]
    foreach inputName $input_names {
        lappend inputTypes [get_fxp_format_from_parameters ${inputName} in derived]
    }
    set resultType [get_int_format_from_parameters ${output_name} out derived]
    pad_stimulus_file $stim_out_fileID $resultType $latency
    set cycle 0
    while { $cycle < $cycles } {
        set operands [list]
        foreach inputType $inputTypes {
            lappend operands [list $inputType [fxp_random $inputType]]
        }
        set expectedResult [$fxp_function_emulator $operands $resultType]
        if { $expectedResult != "invalid" } {
            write_stimulus_record $stim_in_fileID  $operands
            write_stimulus_record $stim_out_fileID [list [list $resultType $expectedResult]]
            incr cycle
        }
    }
}

##########################################################################################################
# Counter logic emulation for generation of stimulus files
#
# a counter's state is modeled as a list containing, in order: 
#   configured width, 
#   configured initial, step, and limit values, 
#   current value, and
#   effective initial, step, and limit values

proc counter_create { width initial_value step_value limit_value } {
    return [list $width \
                 $initial_value $step_value $limit_value \
                 $initial_value \
                 $initial_value $step_value $limit_value]
}

proc get_counter_value { counter } {
    return [lindex $counter 4]
}

# Simulates a single cycle of an idealised counter, i.e. one which can have a positive or negative
# step. Real IP cores are more limited in their behaviour.
# New initial step, limit, and limit values are loaded when the control signals include "sload" 
# and are specified as name-value pairs which are optional arguments
# e.g. set counter [counter_update $counter { en sload } { new_initial 0 } { new_step 1 } { new_limit 16384 }
# The optional "new value" parameters are only used if the asserted control signals include "sload" 
proc counter_update { counter { asserted_control_signals {}} args } {
    set width                   [lindex $counter 0]
    set initial_value           [lindex $counter 1]
    set step_value              [lindex $counter 2]
    set limit_value             [lindex $counter 3]
    set current_value           [lindex $counter 4]
    set effective_initial_value [lindex $counter 5]
    set effecive_step_value     [lindex $counter 6]
    set effective_limit_value   [lindex $counter 7]
    if { [lsearch $asserted_control_signals "rst"] >= 0] } {
        return [counter_create $initial_value $step_value $limit_value]
    } elseif { [lsearch $asserted_control_signals "en"] >= 0] } {
        if { [lsearch $asserted_control_signals "sload"] } {
            foreach arg $args {
                set arg_name  [lindex arg 0]
                set arg_value [lindex arg 1]
                if { ($arg_name == "new_initial") || ($arg_name == "new_initial_value") } {
                    set effective_initial_value $arg_value
                    set current_value           $arg_value
                } elseif { ($arg_name == "new_step") || ($arg_name == "new_step_value") } {
                    set effective_step_value $arg_value
                } elseif { ($arg_name == "new_limit") || ($arg_name == "new_limit_value") } {
                    set effective_limit_value $arg_value
                }
            }
        } else {
            set current_value [expr $current_value + $effective_step_value]
            if { $effective_step_value > 0 } {
                if { $current_value >= $effective_limit_value } {
                    $current_value = $effective_initial_value
                }
            } elseif { $effective_step_value < 0 } {
                if { $current_value <= $effective_limit_value } {
                    $current_value = $effective_initial_value
                }
            }        
        }
    }
    return [list $width \
                 $initial_value $step_value $limit_value \
                 $current_value \
                 $effective_initial_value $effective_step_value $effective_limit_value]
}

##########################################################################################################
# Per-function validation, generation, and stimulus writer procedures
# The show_family_filtered_parameters helper only shows parameters that are relevant to the currently
# delected device family.

proc show_family_filtered_parameters { parameterNames } {
    set deviceFamily [get_parameter_value selected_device_family]
    list filteredParameterNames;
    foreach paramName $parameterNames {
       if { $paramName == "force_mult_in_logic" } {
           if { ($deviceFamily == "Stratix IV") || ($deviceFamily == "Stratix V") } {
               lappend filteredParameterNames $paramName
           }
       } else {
           lappend filteredParameterNames $paramName
       }
    }
    show_parameters $filteredParameterNames
}

# Return the "derived" suffix if optimal output format has been specified by the user. 
proc select_output_format_parameter_suffix {} {
    if { [get_parameter_value optimal_output_format] } {
        return "derived"
    } else {
        return ""
    }
}

proc add_validate {} {
    set numInputs [get_parameter_value num_inputs]
    show_family_filtered_parameters      { optimal_output_format }
    show_fxp_input_format_parameters     [lrange { a b c d e f g h } 0 [expr $numInputs-1]]
    show_fxp_output_format_parameters    { result } [select_output_format_parameter_suffix]
    show_family_filtered_parameters      { gen_enable performance_goal num_inputs add_no_growth }
    validate_fxp_input_format_parameters [lrange { a b c d e f g h } 0 [expr $numInputs-1]]
}

proc mul_validate {} {
    show_family_filtered_parameters      { optimal_output_format }
    show_fxp_input_format_parameters     { a b }
    show_fxp_output_format_parameters    { result } [select_output_format_parameter_suffix]
    show_family_filtered_parameters      { gen_enable complex_format performance_goal force_mult_in_logic }
    if { [is_complex_format] } {
        show_family_filtered_parameters { complex_karatsuba add_no_growth }
    }
    validate_fxp_input_format_parameters { a b }
}

# The divider block requires both operands to have the same sign, therefore the sign is derived from the
# global sign option
proc div_validate {} {
    show_family_filtered_parameters      { common_sign optimal_output_format }
    show_fxp_input_format_parameters     { numerator denominator } 
    show_fxp_output_format_parameters    { result } [select_output_format_parameter_suffix]
    show_family_filtered_parameters      { gen_enable performance_goal }
    validate_fxp_input_format_parameters { numerator denominator } [get_parameter_value common_sign]
    foreach baseName { numerator_fxp_in denominator_fxp_in result_fxp_out } {
        set_parameter_property ${baseName}_sign VISIBLE false
        set_parameter_value    ${baseName}_sign_derived [get_parameter_value common_sign]
    }
}

# The output type of sqrtBlock is the same as the input type. In future it could be coerced via a 
# cast block.  
proc sqrt_validate {} {
    derive_fxp_interface_parameter_values in radical out result 
    show_fxp_input_format_parameters     { radical }
    show_fxp_output_format_parameters    { result } derived
    show_family_filtered_parameters      { gen_enable performance_goal }
    validate_fxp_input_format_parameters { radical }
}

# Counter setup validation: 
#   difference between initial and limit must be a multiple of the step  
# The option can be "zero_step_ok" if it is acceptable for the step to be zero (e.g. loadable counter),
# or "natural_values_only" if initial, step, and value cannot be negative (e.g. simple counter)
proc validate_counter_setup { {option ""} } {
    set initial_value  [get_parameter_value initial_value]
    set step_value     [get_parameter_value step_value]
    set limit_value    [get_parameter_value limit_value]
    if { $option == "natural_values_only" } {
        foreach paramName {initial_value step_value limit_value} {
            if { [get_parameter_value $paramName] < 0 } {
                send_message ERROR "[get_string [string toupper $paramName]_DISPLAY_NAME] cannot be negative"
            }
        }
    }
    if { $step_value == 0 } {
        if { $option != "zero_step_ok" } {
            send_message ERROR "Counter step cannot be zero"
        }
    } else {
        set step_multiple  [expr ($limit_value - $initial_value) / $step_value]
        set step_remainder [expr ($limit_value - $initial_value) % $step_value]
        if { ($step_multiple <= 0) || ($step_remainder != 0) } {
            send_message ERROR "Difference between counter limit and initial value must be a multiple of the chosen step value"
        }
    }
}

proc simple_counter_validate {} {
    set initial_value  [get_parameter_value initial_value]
    set limit_value    [get_parameter_value limit_value]
    show_int_output_format_parameters { value } [select_output_format_parameter_suffix]
    show_family_filtered_parameters   { performance_goal initial_value step_value limit_value }
#TODO    #set_parameter_value value_fxp_out_sign_derived [expr $initial_value < 0) || ($limit_value < 0)]
    validate_counter_setup natural_values_only
}

proc loadable_counter_validate {} {
    show_int_input_format_parameters { initial step limit }
    show_int_output_format_parameters { value } [select_output_format_parameter_suffix]
    show_family_filtered_parameters   { performance_goal initial_value step_value limit_value }
    validate_counter_setup zero_step_ok
}

proc add_generate { recipe } {
    set numInputs [get_parameter_value num_inputs]
    set inputNames [lrange { a b c d e f g h } 0 [expr $numInputs-1]]
    $recipe add_signal_in_group  in  $inputNames
    $recipe add_signal_out_group out {result}
    $recipe add_block           adder addBlock 
    $recipe set_block_parameter adder addNoGrowth [get_boolean_parameter_string add_no_growth]
    if { ![get_parameter_value optimal_output_format] } {
        $recipe set_block_parameter adder addType [get_fxp_format_from_parameters result out]
    }
    set index 0
    foreach inputName $inputNames {
        $recipe wire [get_fxp_format_from_parameters ${inputName} in derived] [list in.${inputName}] \
                     [list adder.${index}]
        incr index
    }
    $recipe wire {auto} {adder.primWireOut} {out.result}
}

proc mul_generate { recipe } {
    $recipe add_signal_in_group  in  {a b}
    $recipe add_signal_out_group out {result}
    $recipe add_block           multiplier multBlock 
    $recipe set_block_parameter multiplier multLogic [get_boolean_parameter_string force_mult_in_logic]
    if { [is_complex_format] } {
        if { [get_parameter_value complex_karatsuba] } {
            $recipe set_parameter synthComplexMultKaratsuba true
        }
        $recipe set_block_parameter multiplier multLogic   [get_boolean_parameter_string force_mult_in_logic]
        $recipe set_block_parameter multiplier addNoGrowth [get_boolean_parameter_string add_no_growth]
    } 
    if { ![get_parameter_value optimal_output_format] } {
        $recipe set_block_parameter multiplier multType [get_fxp_format_from_parameters result out]
    }
    $recipe wire [get_fxp_format_from_parameters a in derived] {in.a} {multiplier.0}
    $recipe wire [get_fxp_format_from_parameters b in derived] {in.b} {multiplier.1}
    $recipe wire {auto} {multiplier.primWireOut} {out.result}
}

proc div_generate { recipe } {
    $recipe add_signal_in_group  in  {numerator denominator}
    $recipe add_signal_out_group out {result}
    $recipe add_block           divider divideBlock
    if { ![get_parameter_value optimal_output_format] } {
        $recipe set_block_parameter divider divideType [get_fxp_format_from_parameters result out]
    }
    $recipe wire [get_fxp_format_from_parameters numerator   in derived] {in.numerator}   {divider.0}
    $recipe wire [get_fxp_format_from_parameters denominator in derived] {in.denominator} {divider.1}
    $recipe wire {auto} {divider.primWireOut} {out.result}
}

proc sqrt_generate { recipe } {
    $recipe add_signal_in_group  in  {radical}
    $recipe add_signal_out_group out {result}
    $recipe add_block           sqrt sqrtBlock 
    $recipe wire [get_fxp_format_from_parameters radical in derived] {in.radical} {sqrt.0}
    if { [get_parameter_value optimal_output_format] } {
        $recipe wire {auto} {sqrt.primWireOut} {out.result}
    } else {
        $recipe wire [get_fxp_format_from_parameters result out derived] {sqrt.primWireOut} {out.result}
    }   
}

proc simple_counter_generate { recipe } {
    $recipe add_signal_in_group  in  {en}
    $recipe add_signal_out_group out {value}
    $recipe add_block           counter counterBlock 
    $recipe set_block_parameter counter counterInitial [get_parameter_value initial_value]
    $recipe set_block_parameter counter counterStep    [get_parameter_value step_value]
    $recipe set_block_parameter counter counterLimit   [get_parameter_value limit_value]
    $recipe wire {unsigned 1 0} {in.en} {counter.portEnable}
    if { [get_parameter_value optimal_output_format] } {
        $recipe wire {auto} {counter.primWireOut} {out.value}
    } else {
        $recipe wire [get_int_format_from_parameters value out derived] {counter.primWireOut} {out.value}
    }
}

proc loadable_counter_generate { recipe } {
    $recipe add_signal_in_group  in  {sload en}
    $recipe add_signal_out_group out {value}
    $recipe add_block           counter ldCounterBlock 
    $recipe set_block_parameter counter ldCounterInitial [get_parameter_value initial_value]
    $recipe set_block_parameter counter ldCounterStep    [get_parameter_value step_value]
    $recipe set_block_parameter counter ldCounterLimit   [get_parameter_value limit_value]
    $recipe wire {unsigned 1 0} {in.en}    {counter.ldCounterPortEnable}
    $recipe wire {unsigned 1 0} {in.sload} {counter.ldCounterPortLoad}
    $recipe wire [get_int_format_from_parameters initial in derived] {in.initial} {counter.ldCounterPortInitial}
    $recipe wire [get_int_format_from_parameters step    in derived] {in.step}    {counter.ldCounterPortStep}
    $recipe wire [get_int_format_from_parameters limit   in derived] {in.limit}   {counter.ldCounterPortLimit}
    if { [get_parameter_value optimal_output_format] } {
        $recipe wire {auto} {counter.primWireOut} {out.value}
    } else {
        $recipe wire [get_int_format_from_parameters value out derived] {counter.primWireOut} {out.value}
    }
}

# Stimulus writers take a pair of open file handles as parameter, together with the latency of the logic
# and number of cycles that will be simulated. 
# Stimulus writers must account for the latency of the logic by padding the output stimulus file (i.e. 
# expected results) with one dummy record for each cycle of latency.

proc add_stimulus { stim_in_fileID stim_out_fileID cycles latency } {
    set numInputs [get_parameter_value num_inputs]
    set inputNames [lrange { a b c d e f g h } 0 [expr $numInputs-1]]
    fxp_function_stimulus $stim_in_fileID $stim_out_fileID $cycles $latency \
                          fxp_add $inputNames result
}

proc mul_stimulus { stim_in_fileID stim_out_fileID cycles latency } {
    fxp_function_stimulus $stim_in_fileID $stim_out_fileID $cycles $latency \
                          fxp_mult { a b } result
}

proc div_stimulus { stim_in_fileID stim_out_fileID cycles latency } {
    fxp_function_stimulus $stim_in_fileID $stim_out_fileID $cycles $latency \
                          fxp_div { numerator denominator } result
}

proc sqrt_stimulus { stim_in_fileID stim_out_fileID cycles latency } {
    fxp_function_stimulus $stim_in_fileID $stim_out_fileID $cycles $latency \
                          fxp_sqrt { radical } result
}

# This simulation will enable the counter 80% of the time, and reset it once
proc simple_counter_stimulus { stim_in_fileID stim_out_fileID cycles latency } {
    set control_signal_data_type { unsigned 1 0 }
    set counter_data_type [get_int_format_from_parameters value out derived]
    set width [lindex $counter_data_type 1]
    pad_stimulus_file $stim_out_fileID $counter_data_type $latency
    set counter [counter_create $width [get_parameter_value initial_value] \
                                       [get_parameter_value step_value] \
                                       [get_parameter_value limit_value]]
    set reset_cycle [int_rand 1 $cycles]
    for { set cycle 0 } { $cycle < $cycles } {incr $cycle} {
        set control_signals [list]
        set rst_signal 0
        set en_signal  0
        if { $cycle == $reset_cycle } {
            lappend control_signals "rst"
            set rst_signal 1 
        }
        if { [int_rand 0 99] < 80 } {
            lappend control_signals "en"
            set en_signal 1 
        }
        set counter [counter_update $counter $control_signals]
        write_stimulus_record $stim_in_fileID { { $control_signal_data_type $rst_signal } \
                                                { $control_signal_data_type $en_signal } }
        write_stimulus_record $stim_out_fileID { { $counter_data_type [get_counter_value $counter] } }
    }
}

# The loadable counter stimulus file includes one counter reset, an 80% enable duty cycle,
# and 5 load operations in the course of the simulation run
proc loadable_counter_stimulus { stim_in_fileID stim_out_fileID cycles latency } {
    set control_signal_data_type { unsigned 1 0 }
    set initial_data_type [get_int_format_from_parameters initial in derived]
    set step_data_type    [get_int_format_from_parameters step    in derived]
    set limit_data_type   [get_int_format_from_parameters limit   in derived]
    set counter_data_type [get_int_format_from_parameters value  out derived]
    set width [lindex $counter_data_type 1]
    pad_stimulus_file $stim_out_fileID $counter_data_type $latency
    set counter [counter_create $width $initial_value $step_value $limit_value]
    set reset_cycle [int_rand 1 $cycles]
    set absolute_limit   [expr round(pow(2,$width)-1)]
    set loadable_initial 0
    set loadable_step    1
    set loadable_limit   $absolute_limit
    for { set cycle 0 } { $cycle < $cycles } {incr $cycle} {
        set control_signals [list]
        if { $cycle == $reset_cycle } {
            lappend control_signals "rst"
        }
        if { [int_rand 0 99] < 80 } {
            lappend control_signals "en"
        }
        if { [int rand 0 $cycles] < 5 } {
            lappend control_signals "sload"
            set loadable_initial [int_rand 0 [expr round($absolute_limit / 2)]]
            set loadable_step    [int_rand 1 [expr 1 + round($absolute_limit / 100)]]
            set loadable_limit   [int_rand [expr $loadable_initial + 1] $absolute_limit]]
            if { [int rand 0 1] == 1 } {
                set loadable_step [expr -($loadable_step)]
                set temp             $loadable_limit
                set loadable_limit   $loadable_initial
                set loadable_initial $temp
            }
        }
        set counter [counter_update $counter $control_signals \
                                    {"new_initial" $loadable_initial} \
                                    {"new_step"    $loadable_step} \
                                    {"new_limit"   $loadable_limit}]
        write_stimulus_record $stim_in_fileID { { $control_signal_data_type $rst_signal } \
                                                { $control_signal_data_type $en_signal } \ 
                                                { $initial_data_type $loadable_initial } \ 
                                                { $step_data_type    $loadable_step } \ 
                                                { $limit_data_type   $loadable_limit } } 
        write_stimulus_record $stim_out_fileID { { $counter_data_type [get_counter_value $counter] } }
    }

}

##########################################################################################################
# VALIDATION
# Note that update_menu and hide_optional_parameters have already been called before this validation call, 
# therefore the validation procedure must simply make the relevant parameters visible again. 


proc validate_input {} {
puts "validate"
    global complex_format
    set_parameter_value validation_failed false
    set complex_format [is_complex_format]

    if { [is_goal_frequency] } {
        set_parameter_property frequency_target VISIBLE true
        set_parameter_property latency_target VISIBLE false
    } elseif { [is_goal_latency] } {
        set_parameter_property frequency_target VISIBLE false
        set_parameter_property latency_target VISIBLE true
    } elseif {[is_goal_combined]} {
        set_parameter_property frequency_target VISIBLE true
        set_parameter_property latency_target VISIBLE true
    }
    update_menu
    hide_optional_parameters
    [get_function_option validate]
}

# Validation helpers

proc update_menu {} {
    global fn_family
    foreach non_current_family [lsort [array names fn_family]]  {
        set_parameter_property "${non_current_family}_function" VISIBLE false
    }
    set current_family [get_parameter_value FUNCTION_FAMILY]
    set current_family_param "${current_family}_function"
    set_parameter_property $current_family_param VISIBLE true
    set_parameter_value derivedfunction [get_parameter_value $current_family_param]

}

proc hide_optional_groups {} {
    set_display_item_property "Counter Setup" VISIBLE false
    set_display_item_property "Input Data Widths" VISIBLE false
    set_display_item_property "Output Data Widths" VISIBLE false
    set_display_item_property "Options" VISIBLE false
}

# Also hides the parameter captions where present

proc hide_optional_parameters {} {
    global optional_parameter_names
    foreach optionalParameterName $optional_parameter_names {
        set_parameter_caption_visible $optionalParameterName FALSE
        set_parameter_property $optionalParameterName VISIBLE FALSE
    }
}

proc validate_fxp_input_format_parameters { interfaceNames { signOverride "N" } } {
    foreach interfaceName $interfaceNames {
        set f [get_parameter_value ${interfaceName}_fxp_in_fraction] 
        set w [get_parameter_value ${interfaceName}_fxp_in_width] 
        if { ($signOverride == 0) || ($signOverride == 1) } {
            set s $signOverride
        } else {
           set s [get_parameter_value ${interfaceName}_fxp_in_sign] 
        }
        if {$f > $w || ($f == $w && $s == 1) } {
            send_message ERROR "Input width must at least be large enough to contain both the full fraction size and the sign if chosen"
        }
    }
}

##########################################################################################################
# ELABORATION
# Elaboration is based on visibility of interface parameter widths (normal or derived), therefore 
# per-block elaboration is generally not required and the dummy elaboration function can be specified 
# for such blocks. 

proc dummy_elaborate {} {
}

# interfaceRootName should be of the form ${interfaceName}_fxp_${direction}
# The interface is considered to be active if its caption is visible. 
# Width is always taken from the derived width parameter, and is doubled for complex data types

array set prev_elaborated_interface_widths [list]

proc elaborate_active_interface { interfaceName } {
    global optional_parameter_names
    global prev_elaborated_interface_widths
    set widthParameterName "${interfaceName}_fxp_in_width_derived"
    if { [lsearch $optional_parameter_names $widthParameterName] != -1 } {
        if { [is_parameter_caption_visible $widthParameterName] } {
            set bit_width [get_parameter_value $widthParameterName]
            add_interface $interfaceName conduit end
            set_interface_property $interfaceName associatedClock clk
            set_interface_property $interfaceName associatedReset areset
            set_interface_property $interfaceName ENABLED true
            if { [string is digit $bit_width] } {
                if { [is_complex_format] } {
                    add_interface_port $interfaceName in_${interfaceName}_real real Input $bit_width
                    add_interface_port $interfaceName in_${interfaceName}_imag imag Input $bit_width
                } else {
                    add_interface_port $interfaceName $interfaceName $interfaceName Input $bit_width
                }
            }
        }
    } else {
        set widthParameterName "${interfaceName}_fxp_out_width_derived"
        if { [is_parameter_caption_visible $widthParameterName] } {
            set bit_width [get_parameter_value $widthParameterName]
puts "$widthParameterName width $bit_width"
            add_interface $interfaceName conduit start
            set_interface_assignment $interfaceName "ui.blockdiagram.direction" OUTPUT
            set_interface_property $interfaceName associatedClock clk
            set_interface_property $interfaceName associatedReset ""
            set_interface_property $interfaceName ENABLED true
            if { ![string is digit $bit_width] } {
                set bit_width $prev_elaborated_interface_widths($interfaceName)
            }
            if { [is_complex_format] } {
                add_interface_port $interfaceName out_${interfaceName}_real real Output $bit_width
                add_interface_port $interfaceName out_${interfaceName}_imag imag Output $bit_width
            } else {
                add_interface_port $interfaceName $interfaceName $interfaceName Output $bit_width
puts "width is now [get_port_property $interfaceName WIDTH_VALUE]"
            }
            set prev_elaborated_interface_widths($interfaceName) $bit_width
        }
    }
}    

# If an elaboration call results in derived output formats being set, this will trigger another 
# elaboration callback straight away. In this case the new format(s) must be set on the relevant outputs,
# but nothing else has changed and no further elaboration steps are taken. 
# Setting parameter values during elaboration will itself trigger elaboration, therefore parameters are
# only set if their values have changed.
# Furthermore: elaboration triggers are more than just UI changes - elaboration is also called during
# pre-generation steps. During these steps it is vital that the interfaces are fully defined - thus the
# forced DSDK call when widths are invalid and no UI change has occurred. 

array set optimal_output_controlling_parameter_values [list]

proc save_optimal_output_format_controlling_parameter_values { } {
    global optimal_output_format_controlling_parameter_names
    global optimal_output_format_controlling_parameter_values
    array unset optimal_output_format_controlling_parameter_values
    foreach paramName $optimal_output_format_controlling_parameter_names {
        set optimal_output_format_controlling_parameter_values($paramName) \
                  [get_parameter_value $paramName]
    }
}

proc optimal_output_format_controlling_parameter_values_changed { } {
    global optimal_output_format_controlling_parameter_names
    global optimal_output_format_controlling_parameter_values
    if { [array size optimal_output_format_controlling_parameter_values] == 0 } {
        return true
    } else {
        foreach paramName $optimal_output_format_controlling_parameter_names {
            if { $optimal_output_format_controlling_parameter_values($paramName) != \
                 [get_parameter_value $paramName] } {
puts "$paramName has changed"
                return true
            }
        }
    }
    return false
}

proc is_output_format_defined { } {
    global generated_output_formats_needed
    foreach baseOutputName $generated_output_formats_needed {
        if { ![string is digit [get_parameter_value ${baseOutputName}_fxp_out_width_derived]] } {
            return false
        }
    }
    return true
}

set elaboration_has_just_invalidated_output_format false

proc elaboration_callback {} {
puts "elab"
    global optional_parameter_names
    global interface_names
    global prev_optimal_output_format
    global generated_output_formats_needed
    global newly_generated_output_formats
    global elaboration_has_just_invalidated_output_format
    set optimal_output_format_invalid [optimal_output_format_controlling_parameter_values_changed]
    if { $elaboration_has_just_invalidated_output_format && ![get_output_width_button_pressed] } {
        # then it may have triggered an elaboration call, but we don't want to do anything
        set elaboration_has_just_invalidated_output_format false
    } elseif { [llength $newly_generated_output_formats] > 0 } { 
        # elab is only being called because output format parameters were updated by call_dsdk
        set newly_generated_output_formats [list]
    } else {
        set freq [get_parameter_value frequency_target]
        set force_dsdk_call false
        if { !(   [get_parameter_property optimal_output_format VISIBLE] 
               && [get_parameter_value optimal_output_format]) } {
            set generated_output_formats_needed [list]
            set_display_item_property check_output_width_button VISIBLE false
        } else {
            set_display_item_property check_output_width_button VISIBLE \
                                            [get_parameter_value defer_output_format_calc]
            if { [get_output_width_button_pressed] || ![get_parameter_value defer_output_format_calc]} {
                set generated_output_formats_needed { result value }
                    set_output_width_button_pressed false
                    set force_dsdk_call true
            } elseif { $optimal_output_format_invalid } {
                set generated_output_formats_needed { result value }
                foreach baseOutputName $generated_output_formats_needed {
puts "setting $baseOutputName invalid"
                    set_parameter_value_if_changed ${baseOutputName}_fxp_out_width_derived \
                        "pending width or performance check"
                    set_parameter_value_if_changed ${baseOutputName}_fxp_out_fraction_derived ""
                    set_parameter_value_if_changed ${baseOutputName}_fxp_out_sign_derived     ""
                }
                if { (!$prev_optimal_output_format) } {
                    set force_dsdk_call true
                } else {
                    set elaboration_has_just_invalidated_output_format true
                }
            } else { 
                # no UI change (so elab is probably being called prior to generation), 
                # so force DSDK call if any widths are not yet determined 
puts "no UI change"
                foreach baseOutputName { result value } {
                    if { ![string is digit [get_parameter_value ${baseOutputName}_fxp_out_width_derived]] } {
                        set force_dsdk_call true
                    }
                }
            }
        }
        set prev_optimal_output_format [get_parameter_value optimal_output_format]
        set_display_item_property Report VISIBLE true
        set_display_item_property "Register Report" VISIBLE false
        set quartus_dir [get_quartus_rootdir] 
        [get_function_option elaborate]

        if { [get_parameter_property performance_goal VISIBLE] } { 
            if { [get_performance_button_pressed] } {
                set_display_item_property check_performance_button VISIBLE false
                set_display_item_property report_pane VISIBLE true
                if { bool([get_parameter_value validation_failed]) == bool(true) } {
                    set_display_item_property report_pane TEXT "Latency unknown because parameters are invalid"
                } elseif { [is_goal_frequency] } {
                    array set report [call_dsdk "none" "." "report" $freq]
                    report_latency [array get report] false 
                    report_resources [array get report] false 
                    if { [info exists report(latency)] } {
                        set_parameter_value latency_feedback $report(latency)
                    }
                } elseif { [is_goal_latency] } {
                    set frequency_feedback [get_parameter_value frequency_feedback]
                    if {[expr $frequency_feedback > 0]  } {
                         array set report [call_dsdk "none" "." "latency_constrained_report" $frequency_feedback]      
                         report_resources [array get report] false 
                         array set report [call_dsdk "none" "." "report" $frequency_feedback]
                         set_display_item_property report_pane TEXT "Estimated frequency on [get_parameter_value selected_device_family] is $frequency_feedback MHz. Closest latency was $report(latency), padding to meet target if necessary"                
                     } else {
                         array set report [call_dsdk "none" "." "report" 1]
                         set_display_item_property report_pane TEXT "Could not achieve the requested latency. Minimum #achievable latency is $report(latency) cycles"
                     }
                } elseif { [is_goal_combined] } {
                    array set report [call_dsdk "none" "." "report" $freq]
                    report_combined_target [array get report] false 
                    array set report [call_dsdk "none" "." "latency_constrained_report" $freq]
                    report_resources [array get report] false 
                    if { [info exists report(latency)] } {
                        set_parameter_value latency_feedback $report(latency)
                    }
                }
                set_performance_button_pressed false 
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
        if { $force_dsdk_call && ([array size report] == 0) } {
            array set report [call_dsdk "none" "." "report" $freq]
        }
    }
    if { [has_global_enable] } {
        add_interface en conduit end
        set_interface_property en associatedClock clk
        set_interface_property en associatedReset ""
        set_interface_property en ENABLED true
        add_interface_port en en en Input 1
        set_port_property en VHDL_TYPE STD_LOGIC_VECTOR
    }
    foreach interfaceName $interface_names {
        elaborate_active_interface $interfaceName
    }
    if { ![is_output_format_defined] } {
puts "sending warning"
        send_message WARNING "Core cannot be generated until output width is known"
    }
    save_optimal_output_format_controlling_parameter_values
}


##########################################################################################################
# GENERATION

proc generate_quartus_synth_callback {entity_name} {
    generate $entity_name vhdl
}

proc generate_sim_verilog_callback {entity_name} {
    generate $entity_name verilog sim
}

proc generate_sim_vhdl_callback {entity_name} {
    generate $entity_name vhdl sim
}

proc generate_example_design_callback {entity_name} {
    generate $entity_name vhdl example_design
}


proc generate {entity_name lang {option "none"} } {

    set quartus_dir [get_quartus_rootdir] 
    set tmp_dir [create_temp_file ""]
    file mkdir $tmp_dir

    if { [is_goal_latency] } {
        set freq [find_frequency [get_parameter_value latency_target]]
    } else {
        set freq [get_parameter_value frequency_target]
    }

    if { [expr $freq > 0] } {
        if { [is_goal_combined] }  {
            array set report [call_dsdk $entity_name $tmp_dir "latency_constrained_report" $freq] 
            report_combined_target [array get report] true  
        }
        if { $option == "example_design" } {
            array set report [call_dsdk $entity_name $tmp_dir "VHDL" $freq "generateATB" ] 
            set stim_in_file_name  [file join $tmp_dir "${entity_name}_in_rsrvd_fix.stm"]
            set stim_out_file_name [file join $tmp_dir "${entity_name}_out_rsrvd_fix.stm"]
            set stim_in_fileID  [open $stim_in_file_name  "w"]
            set stim_out_fileID [open $stim_out_file_name "w"]
            set simulation_cycles 5000
            [get_function_option stimulus] $stim_in_fileID $stim_out_fileID $simulation_cycles $report(latency)
            close $stim_in_fileID
            close $stim_out_fileID
        } else {
            array set report [call_dsdk $entity_name $tmp_dir "VHDL" $freq] 
        }
        set hdl_files [glob -nocomplain -tails -directory $tmp_dir *.vhd]
        if { [info exists report(ERROR)] } {
            send_message ERROR $report(ERROR)
        } elseif { [lsearch $hdl_files "${entity_name}.vhd"] == -1 } {
            send_message ERROR "Could not generate ${entity_name}.vhd"
        } elseif { ![info exists report(latency)] } {
            send_message ERROR "Failed to generate HDL for current parameters"
        } else {
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
            set input_file_paths [list [file join $tmp_dir ${entity_name}.vhd]]
            if { ($option == "example_design") } {
                foreach suffix { _atb.do _fpc.do _stm.vhd _atb.vhd _atb.wav.do } {
                    lappend input_file_paths [file join $tmp_dir ${entity_name}${suffix}]
                }
                lappend input_file_paths $stim_in_file_name $stim_out_file_name
            }
            if { $lang == "vhdl" } {
                add_fileset_file dspba_library_package.vhd VHDL \
                    PATH "${quartus_dir}/dspba/backend/Libraries/vhdl/base/dspba_library_package.vhd"
                add_fileset_file dspba_library.vhd VHDL \
                    PATH "${quartus_dir}/dspba/backend/Libraries/vhdl/base/dspba_library.vhd"
                foreach input_file_path $input_file_paths {
                    if { [file extension $input_file_path] == ".vhd" } {
                        add_fileset_file [file tail $input_file_path] VHDL PATH $input_file_path
                    } else {
                        add_fileset_file [file tail $input_file_path] OTHER PATH $input_file_path
                    }
                }
            } else {
                set filelocation [create_temp_file ""]
                file mkdir $filelocation
                set SIMGEN_PARAMS "--source  ${quartus_dir}/dspba/backend/Libraries/vhdl/base/dspba_library_package.vhd --source ${quartus_dir}/dspba/backend/Libraries/vhdl/base/dspba_library.vhd --simgen_parameter=SIMGEN_OBFUSCATE=OFF,CBX_HDL_LANGUAGE=$lang,SIMGEN_RAND_POWERUP_FFS=OFF,SIMGEN_OBFUSCATE=ON,SIMGEN_MAX_TULIP_COUNT=0,CBX_OUTPUT_DIRECTORY=$filelocation"
                set simgen_name [call_simgen {*}$input_file_paths $SIMGEN_PARAMS ]
                set simgen_name [file join $filelocation "[file tail ${simgen_name}].vo"]
                add_fileset_file [file tail $simgen_name] $lang PATH ${simgen_name}
            }
        }
    } else {
    	send_message ERROR "Cannot generate for specified latency"
    }
}


##########################################################################################################
# COMMON DSDK WRAPPER OPERATIONS

proc load_dsdk_wrapper { quartus_dir } {
    if { [regexp -nocase win $::tcl_platform(os) match] } {
        set os windows
    } else {
        set os linux
    }
    set bitness [expr {[is_64bit] ? "64" : "32"}]
    set path_to_lib "${quartus_dir}/dspba/backend/${os}${bitness}/libdspip_recipes.so"
# TODO: check that library exists before attempting to load
    #load /data/mahonman/dspqsh/work/ip/aion/src/Debug64/libdspip_recipes.so
    load $path_to_lib
}

# output type can be one of report, latency_constrained_report, VHDL, or VERILOG
# returns a flattened array of resource and performance results.
# On error the return value will be a single-element array error => <message>
# If NOT generating HDL, the DSDK-defined output widths are updated once the DSDK has
# generated a model (when called from a GENERATE callback, the hw.tcl code is not allowed
# to update parameter values).

proc call_dsdk { entity_name tmp_dir output_type freq { option none } } {
    global generated_output_formats_needed
    global newly_generated_output_formats
    set quartus_dir [get_quartus_rootdir] 
    load_dsdk_wrapper $quartus_dir

    DSPIPModelRecipe recipe $entity_name
    recipe set_verbosity 1
    recipe set_parameter synthDeviceFamily     [get_parameter_value selected_device_family]
    recipe set_parameter synthClockName        clk
    recipe set_parameter synthResetName        rst
    if { [has_global_enable] } {
        recipe set_parameter synthEnableName   en
    }
    if {[get_parameter_value selected_device_part] != "Unknown" } {
        recipe set_parameter synthDevicePart [get_parameter_value selected_device_part]
    } 
    if {[get_parameter_value selected_device_speedgrade] != "Unknown" } {
        recipe set_parameter synthDeviceSpeedGrade "-[get_parameter_value selected_device_speedgrade]"
    } else {
        set message "Please specify a [get_parameter_value selected_device_family] part or speed grade"
        return [list ERROR "Please specify a [get_parameter_value selected_device_family] part or speed grade"]
    }

    if { $output_type == "report" } {
        recipe set_parameter synthOutputMode synthOutputInternalRoot
    } elseif { $output_type == "latency_constrained_report" } {
        recipe set_parameter synthOutputMode             synthOutputInternalRoot
        recipe set_parameter synthLatencyConstraintMode  synthLatencyConstraintLE
        recipe set_parameter synthLatencyConstraintValue [get_parameter_value latency_target]
    } else {
        recipe set_parameter synthOutputMode synthOutputHDLRoot
        if { $option == "generateATB" } {
            recipe set_parameter synthGenerateATB true
            recipe set_parameter synthATBGPIOMismatch synthATBModeError
            recipe set_parameter synthATBExportDeviceOutput true
        }
        if { [is_goal_latency] || [is_goal_combined] } {
            recipe set_parameter synthLatencyConstraintMode  synthLatencyConstraintLE
            recipe set_parameter synthLatencyConstraintValue [get_parameter_value latency_target]
        }
    }
    if { [is_goal_frequency] || [is_goal_latency] || [is_goal_combined] } {
        recipe set_parameter synthClockFreq $freq
    }

    [get_function_option generate] recipe

    if { $output_type == "VERILOG" } {
       set lang "SYSTEMVERILOG"
    } else {
       set lang "VHDL"
    }

    set post_generation_state [recipe generate $tmp_dir $lang ]

    if { $post_generation_state != "generated" } {
        return [list ERROR "DSDK generation failed" ]
    } else {
        set newly_generated_output_formats [list]
        foreach baseOutputName $generated_output_formats_needed {
            set output_format [recipe get_output_type out.${baseOutputName}]
            if { $output_format != "" } { 
                lappend newly_generated_output_formats $baseOutputName
                set results($baseOutputName) $output_format
                set format_element_list [split $output_format " "]
                if { [lindex $format_element_list 0] == "complex" } {
                    set format_element_list [lreplace $format_element_list 0 0]
                }
                if { ($output_type == "report") || ($output_type == "latency_constrained_report") } {
                    if { [lindex $format_element_list 0] == "signed" } {
                        set_parameter_value_if_changed ${baseOutputName}_fxp_out_sign_derived 1
                    } else {
                        set_parameter_value_if_changed ${baseOutputName}_fxp_out_sign_derived 0
                    }
                    set_parameter_value_if_changed \
                        ${baseOutputName}_fxp_out_width_derived    [lindex $format_element_list 1]
                    set_parameter_value_if_changed \
                        ${baseOutputName}_fxp_out_fraction_derived [lindex $format_element_list 2]
                }
            }
        }
        set generated_output_formats_needed [list]

        foreach result { DSP LUT RAMBlocks RAMBits } {
            set results($result) [recipe get_resource $result]
        }
        foreach result { frequency latency } {
            set results($result) [recipe get_performance $result]
        }
        return [array get results]
    }
}

#
# Returns the frequency (in MHz) at which the specified latency is achievable.
# If the latency is not achievable, returns zero or a negative number whose 
# absolute value is the nearest achievable latency.
# The function will give up after a certain number of attempts.
# The function binary searches the 1 to 800 MHz range.
#
proc find_frequency { latency } {
    set freq 400
    set step [expr $freq/2]
    set t0 [clock clicks -millisec]    
    array set report [call_dsdk "none" "." "report" $freq]
    set t1 [clock clicks -millisec]
    set time_taken [expr (($t1-$t0)/1000.0)]
    if { [expr $time_taken > 10.0] } {
        send_message ERROR "Frequency Target is too low for this parameterization"
        return 0
    } elseif { [expr $time_taken > 1.0] } {
        send_message WARNING "Frequency search for this target may take up to 10 seconds"
    }
    set attempts 0
    set max_passing_latency [expr -1]
    set max_passing_frequency 0
    while { true } {
        if { ![info exists report(latency)] } {
            set freq [expr int($freq - $step)]
        } elseif { [expr $report(latency)] > $latency } {
            set freq [expr int($freq - $step)]
        } else {
            set  max_passing_latency $report(latency)
            set  max_passing_frequency $freq
            set freq [expr int($freq + $step)]
        }
        if { [expr $freq < 1] || [expr $attempts > 10] } {
            break
        }
        array set report [call_dsdk "none" "." "report" $freq]
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

##########################################################################################################
# REPORTING

#
# This procedure will report latency if you pass to it the output of a successful DSPIP recipe generation
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
        set msg "Cannot achieve specified frequency at any possible latency"
    }
    if { $send_msg } {
        send_message $level $msg 
    } else {
        set_display_item_property report_pane TEXT $msg
    }
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

add_parameter RES_DSP_param integer 0
set_parameter_property RES_DSP_param VISIBLE false
set_parameter_property RES_DSP_param DERIVED true
set_parameter_property RES_DSP_param DISPLAY_NAME "DSP Blocks"
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
    if { [info exists report(LUT)] && [info exists report(DSP)] && [info exists report(RAMBits)] && [info exists report(RAMBlocks)] } {
        set RES_DSP_msg     "DSP Blocks Used: $report(DSP)"
        set RES_LUT_msg     "LUTs Used: $report(LUT)"
        set RES_MBIT_msg    "Memory Bits Used: $report(RAMBits)"
        set RES_MBLOCK_msg  "Memory Blocks Used: $report(RAMBlocks)"
        set level "INFO"
        if { $send_msg } {
            send_message $level $RES_DSP_msg 
            send_message $level $RES_LUT_msg 
            send_message $level $RES_MBIT_msg 
            send_message $level $RES_MBLOCK_msg 
        } else {
            show_resource_estimates
            set_display_item_property RES_TITLE TEXT "Resource usage estimates:"
            set_parameter_value RES_DSP_param     $report(DSP)
            set_parameter_value RES_LUT_param     $report(LUT)
            set_parameter_value RES_MBIT_param    $report(RAMBits)
            set_parameter_value RES_MBLOCK_param  $report(RAMBlocks)
        }
    } else { 
        set DSP_msg "Resource usage estimates are not available"
        set level WARNING
        if { $send_msg } {
            send_message $level $DSP_msg 
        } else {
            set_display_item_property RES_TITLE TEXT "Resource usage estimates are not available"
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
    if {[info exists report(RAMBlocks)] } {
        set params(mbits)  $report(RAMBlocks)
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


