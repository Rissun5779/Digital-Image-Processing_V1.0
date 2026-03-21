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

load_strings altera_fp.properties

source "../../lib/tcl/dspip_common.tcl"

# 
# module altera_fp
# 
set_module_property NAME altera_fp_functions
set_module_property VERSION  18.1
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME ALTERA_FP_FUNCTIONS 
set_module_property DESCRIPTION "A collection of floating point functions"
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


set_module_property SUPPORTED_DEVICE_FAMILIES \
{\
{Arria 10} {Arria V} {Arria V GZ} {Arria II GX} {Arria II GZ} \
{Cyclone 10 LP} {Cyclone V} {Cyclone IV E} {Cyclone IV GX}\
{MAX 10 FPGA}\
{Stratix V} {Stratix IV} {Stratix 10}\
}


#placeholder 


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1410764818924/eis1410936966508 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408

# 
# file sets
# 
add_fileset ALTFP_FP_QUARTUS_SYNTH QUARTUS_SYNTH quartus_synth_callback
add_fileset ALTFP_FP_SIM_VERILOG SIM_VERILOG sim_verilog_callback
add_fileset ALTFP_FP_SIM_VHDL SIM_VHDL sim_vhdl_callback

#
# functions list
# the format of the list is 
# [list name cmd_proc validate_proc elaborate_proc]
# cmd_proc should contain the function name and other function specific
# parameters such as exponent and mantissa widths.
# validate_proc will be run at the end of the validation.
# elaborate_proc should add appropriate data inputs; clk, reset and if selected
# enable input will have been added before running this proc.





set ARITH_LIST   [list ADD SUB ADDSUB MUL DIV INV ABS SCALARPRODUCT MULT_ACC ACC MULT_ADD COMP_MULT]
set TRIG_LIST    [list SIN COS TAN ARCSIN ARCCOS ARCTAN ARCTAN2]
set EXP_LOG_LIST [list EXPE EXP2 EXP10 LOGE LOG2 LOG10 LOG1PX POWR ]
set ROOTS_LIST   [list SQRT INV_SQRT CBRT HYPOT]
set COMPARE_LIST [list MIN MAX LT LE EQ NEQ GT GE]
set CONVERT_LIST [list FXP_FP FP_FXP FP_FP]
set ALL_LIST     [concat $ARITH_LIST $TRIG_LIST $EXP_LOG_LIST $ROOTS_LIST $COMPARE_LIST $CONVERT_LIST]

set HARD_FP_FUNCTIONS [list ADD SUB MUL EXP SCALARPRODUCT SIN COS ACC MULT_ACC MULT_ADD EXPE LOGE]

set DIRECT_DSP_FUNCTIONS [list ADD SUB MUL MULT_ADD]
set {fp_family(ALL)}     [list ALL_GRP      $ALL_LIST   ]
set {fp_family(ARITH)}   [list ARITH_GRP    $ARITH_LIST   ]
set {fp_family(TRIG)}    [list TRIG_GRP     $TRIG_LIST    ]
set {fp_family(EXP_LOG)} [list EXP_LOG_GRP  $EXP_LOG_LIST ]
set {fp_family(ROOTS)}   [list ROOTS_GRP    $ROOTS_LIST   ]
set {fp_family(COMPARE)} [list COMPARE_GRP  $COMPARE_LIST ]
set {fp_family(CONVERT)} [list CONVERT_GRP  $CONVERT_LIST ]

#prototype set {fp_family(NAME)}   [list DISPLAY_NAME Function_for_cmdPolyEval cmd_generation_function_for_cmdPoly_eval Validation_callback Elaboration_callback ]

set fp_funcs(ADD)               [list ADD_DISPLAY_NAME         FPAdd                op_exp_man          default_arith_validate      default_elaborate               ]
set fp_funcs(SUB)               [list SUB_DISPLAY_NAME         FPSub                op_exp_man          default_arith_validate      default_elaborate               ]
set fp_funcs(ADDSUB)            [list ADDSUB_DISPLAY_NAME      ""                   addsub_cmd          addsub_validate             addsub_elaborate                ]
set fp_funcs(MUL)               [list MUL_DISPLAY_NAME         FPMul                op_exp_man          default_arith_validate      default_elaborate               ]
set fp_funcs(DIV)               [list DIV_DISPLAY_NAME         ""                   divide_cmd          divide_validate             default_elaborate               ]
set fp_funcs(INV)               [list INV_DISPLAY_NAME         FPInverse            op_exp_man          divide_validate             one_each_same_width_elaborate   ]
set fp_funcs(ABS)               [list ABS_DISPLAY_NAME         FPAbs                op_exp_man          abs_validate                one_each_same_width_elaborate   ]
set fp_funcs(SCALARPRODUCT)     [list SCALARPROD_DISPLAY_NAME  FPDotProductIEEE  scalarprod_args     scalarprod_validate         scalarprod_elaborate               ]
set fp_funcs(MULT_ACC)          [list MULT_ACC_DISPLAY_NAME    FPMultAcc            op_exp_man          mult_acc_validate           macc_elaborate               ]
set fp_funcs(ACC)               [list ACC_DISPLAY_NAME         FPAccHard            op_exp_man          mult_acc_validate           acc_elaborate               ]
set fp_funcs(MULT_ADD)          [list MULT_ADD_DISPLAY_NAME    FPMultAdd            op_exp_man          default_arith_validate      three_in_one_out               ]
set fp_funcs(COMP_MULT)          [list COMP_MULT_DISPLAY_NAME    FPComplexMul       op_exp_man          compmult_validate      compmult_elaborate               ]

    
set fp_funcs(MIN)               [list MIN_DISPLAY_NAME      FPMin        op_exp_man          min_max_validate        default_elaborate               ]
set fp_funcs(MAX)               [list MAX_DISPLAY_NAME      FPMax        op_exp_man          min_max_validate        default_elaborate               ]
set fp_funcs(LT)                [list LT_DISPLAY_NAME       ""           compare_cmd         compare_validate        two_in_single_bit_out_elaborate ]
set fp_funcs(LE)                [list LE_DISPLAY_NAME       ""           compare_cmd         compare_validate        two_in_single_bit_out_elaborate ]
set fp_funcs(EQ)                [list EQ_DISPLAY_NAME       ""           compare_cmd         compare_validate        two_in_single_bit_out_elaborate ]
set fp_funcs(NEQ)               [list NEQ_DISPLAY_NAME      ""           compare_cmd         compare_validate        two_in_single_bit_out_elaborate ]
set fp_funcs(GT)                [list GT_DISPLAY_NAME       ""           compare_cmd         compare_validate        two_in_single_bit_out_elaborate ]
set fp_funcs(GE)                [list GE_DISPLAY_NAME       ""           compare_cmd         compare_validate        two_in_single_bit_out_elaborate ]
    
set fp_funcs(SQRT)              [list SQRT_DISPLAY_NAME     FPSqrt       op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(INV_SQRT)          [list INV_SQRT_DISPLAY_NAME FPRecipSqrt  op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(CBRT)              [list CBRT_DISPLAY_NAME     FPCbrt       op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(HYPOT)             [list HYPOT_DISPLAY_NAME    FPHypot3d    op_exp_man       default_validate            three_in_one_out   ]


set fp_funcs(EXPE)              [list EXPE_DISPLAY_NAME     FPExp        op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(EXP2)              [list EXP2_DISPLAY_NAME     FPExp2       op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(LDEXP)             [list LDEXP_DISPLAY_NAME    FPLdExp      ldexp_cmd           ldexp_validate          ldexp_elaborate                 ]
set fp_funcs(EXP10)             [list EXP10_DISPLAY_NAME    FPExp10      op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(LOGE)              [list LOGE_DISPLAY_NAME     FPLn         op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(LOG2)              [list LOG2_DISPLAY_NAME     FPLog2       op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(LOG10)             [list LOG10_DISPLAY_NAME    FPLog10      op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(LOG1PX)            [list LOG1PX_DISPLAY_NAME   FPLn1px      op_exp_man          default_validate        one_each_same_width_elaborate   ]
set fp_funcs(POWR)              [list POWR_DISPLAY_NAME     FPPowr       op_exp_man          default_validate        two_in_one_out_elaborate        ]
    
set fp_funcs(SIN)               [list SIN_DISPLAY_NAME      "Sin"           trig_cmd            trig_validate           one_each_same_width_elaborate   ]
set fp_funcs(COS)               [list COS_DISPLAY_NAME      "Cos"           trig_cmd            trig_validate           one_each_same_width_elaborate   ]
set fp_funcs(TAN)               [list TAN_DISPLAY_NAME      "Tan"           trig_cmd            trig_validate           one_each_same_width_elaborate   ]
set fp_funcs(ARCSIN)            [list ASIN_DISPLAY_NAME     "Arcsin"           trig_cmd            trig_validate           one_each_same_width_elaborate   ]
set fp_funcs(ARCCOS)            [list ACOS_DISPLAY_NAME     "Arccos"           trig_cmd            trig_validate           one_each_same_width_elaborate   ]
set fp_funcs(ARCTAN)            [list ATAN_DISPLAY_NAME     "Arctan"           trig_cmd            trig_validate           one_each_same_width_elaborate   ]
set fp_funcs(ARCTAN2)           [list ATAN2_DISPLAY_NAME    "FPArctan2"  op_exp_man          default_validate        two_in_one_out_elaborate        ]
    
set fp_funcs(FXP_FP)            [list FXP_FP_DISPLAY_NAME   ""           convert_cmd         convert_validate        convert_elaborate               ]
set fp_funcs(FP_FXP)            [list FP_FXP_DISPLAY_NAME   ""           convert_cmd         convert_validate        convert_elaborate               ]
set fp_funcs(FP_FP)             [list FP_FP_DISPLAY_NAME    ""           convert_fp_cmd      convert_fp_validate     convert_fp_elaborate            ]




add_display_item "Register Report" widget_group group tab
add_display_item widget_group arria_widget parameter
set jar_path [file join $env(QUARTUS_ROOTDIR) .. ip altera dsp altera_fp_functions source com.altera.dsp.fp.ui.jar]
set widget_name "arria_dsp"
set_display_item_property widget_group WIDGET [list $jar_path $widget_name]

set_display_item_property widget_group WIDGET_PARAMETER_MAP {
    FUNCTION_FAMILY  FUNCTION_FAMILY
    ARITH_FUNCTION   ARITH_FUNCTION   
    TRIG_FUNCTION    TRIG_FUNCTION 
    EXP_LOG_FUNCTION EXP_LOG_FUNCTION   
    ROOTS_FUNCTION   ROOTS_FUNCTION   
    COMPARE_FUNCTION COMPARE_FUNCTION   
    CONVERT_FUNCTION CONVERT_FUNCTION   
    ALL_FUNCTION     ALL_FUNCTION 
    forceRegisters   forceRegisters
}



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
add_display_item Function FUNCTION_FAMILY PARAMETER


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
    add_display_item Function $paramname PARAMETER

}
#Create a derived parameter that holds the true required function

add_parameter derivedfunction STRING
set_parameter_property derivedfunction VISIBLE FALSE
set_parameter_property derivedfunction DERIVED TRUE
set fp_format_range [list "single:[get_string SINGLE_REP_NAME]" "double:[get_string DOUBLE_REP_NAME]" "custom:[get_string CUSTOM_REP_NAME]"]
add_parameter fp_format STRING "single" 
#set_parameter_property fp_format DISPLAY_HINT radio
set_parameter_property fp_format DISPLAY_NAME "Format"
set_parameter_property fp_format UNITS None
set_parameter_property fp_format ALLOWED_RANGES $fp_format_range
set_parameter_property fp_format DESCRIPTION "Choose the floating point format"
set_parameter_property fp_format AFFECTS_GENERATION true

add_parameter fp_exp POSITIVE 8 
set_parameter_property fp_exp DISPLAY_NAME "Exponent"
set_parameter_property fp_exp ALLOWED_RANGES 5:11 
set_parameter_property fp_exp UNITS Bits
set_parameter_property fp_exp DESCRIPTION "Choose the width of the input exponent in bits"
set_parameter_property fp_exp AFFECTS_GENERATION true

add_parameter fp_exp_derived POSITIVE 8
set_parameter_property fp_exp_derived DERIVED true
set_parameter_property fp_exp_derived VISIBLE false
set_parameter_property fp_exp_derived AFFECTS_GENERATION true

add_parameter fp_man POSITIVE 23 
set_parameter_property fp_man DISPLAY_NAME "Mantissa"
set_parameter_property fp_man ALLOWED_RANGES 10:52 
set_parameter_property fp_man UNITS Bits
set_parameter_property fp_man DESCRIPTION "Choose the width of the input mantissa in bits"
set_parameter_property fp_man AFFECTS_GENERATION true

add_parameter fp_man_derived POSITIVE 8 
set_parameter_property fp_man_derived DERIVED true
set_parameter_property fp_man_derived VISIBLE false
set_parameter_property fp_man_derived AFFECTS_GENERATION true

add_parameter exponent_width POSITIVE 23 
set_parameter_property exponent_width DISPLAY_NAME "Exponent Width"
set_parameter_property exponent_width ALLOWED_RANGES 1:128
set_parameter_property exponent_width UNITS Bits
set_parameter_property exponent_width DESCRIPTION "Choose the width exponent that scales the floating point value"
set_parameter_property exponent_width AFFECTS_GENERATION true


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


# add_parameter max_passing_latency NATURAL 2 
# set_parameter_property max_passing_latency DISPLAY_NAME "Target"
# set_parameter_property max_passing_latency VISIBLE false
# set_parameter_property max_passing_latency UNITS Cycles
# set_parameter_property max_passing_latency DESCRIPTION "Choose the required latency"
# set_parameter_property max_passing_latency AFFECTS_GENERATION true



add_parameter performance_goal STRING "frequency" 
#set_parameter_property performance_goal DISPLAY_HINT  radio
set_parameter_property performance_goal DISPLAY_NAME "Goal"
set_parameter_property performance_goal UNITS None
set_parameter_property performance_goal ALLOWED_RANGES [list "frequency:[get_string FREQUENCY_REP_NAME]" "latency:[get_string LATENCY_REP_NAME]" "combined:[get_string COMBINED_REP_NAME]"]
set_parameter_property performance_goal DESCRIPTION "Choose the performance target"
set_parameter_property performance_goal AFFECTS_GENERATION true

add_parameter rounding_mode STRING "nearest with tie breaking away from zero" 
set_parameter_property rounding_mode DISPLAY_NAME "Mode"
set_parameter_property rounding_mode VISIBLE false
set_parameter_property rounding_mode UNITS None
set_parameter_property rounding_mode ALLOWED_RANGES {"nearest with tie breaking away from zero" "toward zero"}
set_parameter_property rounding_mode DESCRIPTION "Choose the desired rounding mode"
set_parameter_property rounding_mode AFFECTS_GENERATION true

add_parameter rounding_mode_derived STRING "nearest with tie breaking away from zero" 
set_parameter_property rounding_mode_derived DISPLAY_NAME "Mode"
set_parameter_property rounding_mode_derived DERIVED true 
set_parameter_property rounding_mode_derived VISIBLE false
set_parameter_property rounding_mode_derived DESCRIPTION "The rounding mode"
set_parameter_property rounding_mode_derived AFFECTS_GENERATION true

add_parameter use_rounding_mode boolean true
set_parameter_property use_rounding_mode DERIVED true
set_parameter_property use_rounding_mode VISIBLE false
set_parameter_property use_rounding_mode AFFECTS_ELABORATION true

add_parameter faithful_rounding boolean false
set_parameter_property faithful_rounding DISPLAY_NAME "Relax rounding to round up or down to reduce resource usage" 
set_parameter_property faithful_rounding UNITS None
set_parameter_property faithful_rounding DESCRIPTION "Choose if the nearest rounding mode should be relaxed to faithful rounding, where the result may be rounded up or down, to reduce resource usage"
set_parameter_property faithful_rounding AFFECTS_GENERATION true

add_parameter gen_enable boolean false
set_parameter_property gen_enable DISPLAY_NAME "Generate an enable port" 
set_parameter_property gen_enable UNITS None
set_parameter_property gen_enable DESCRIPTION "Choose if the function should have an enable signal."
set_parameter_property gen_enable AFFECTS_GENERATION true


add_parameter divide_type STRING "0"
set_parameter_property divide_type DISPLAY_NAME "Method"
set_parameter_property divide_type UNITS None
set_parameter_property divide_type VISIBLE false
set_parameter_property divide_type ALLOWED_RANGES [list "0:[get_string DIV_0_NAME]" "1:[get_string DIV_1_NAME]"]
set_parameter_property divide_type DESCRIPTION "Choose the type of the comparator" 
set_parameter_property divide_type AFFECTS_GENERATION true

add_parameter select_signal_enable boolean false
set_parameter_property select_signal_enable DISPLAY_NAME "Use Select Signal" 
set_parameter_property select_signal_enable UNITS None
set_parameter_property select_signal_enable DESCRIPTION "Choose if the function should have an select signal, deselect if the function should not (will generate both outputs)."
set_parameter_property select_signal_enable AFFECTS_GENERATION true


add_parameter scale_by_pi boolean 0
set_parameter_property scale_by_pi DISPLAY_NAME "Represent angle as multiple of Pi"
set_parameter_property scale_by_pi UNITS None
set_parameter_property scale_by_pi VISIBLE false
set_parameter_property scale_by_pi DESCRIPTION "Choose to represent angles as multiples of pi" 
set_parameter_property scale_by_pi AFFECTS_GENERATION true

add_parameter number_of_inputs integer 2
set_parameter_property number_of_inputs DISPLAY_NAME "Input Vector Dimension"
set_parameter_property number_of_inputs UNITS None
set_parameter_property number_of_inputs VISIBLE false
set_parameter_property number_of_inputs DESCRIPTION "Choose the number of values on each input" 
set_parameter_property number_of_inputs AFFECTS_GENERATION true




add_parameter trig_no_range_reduction boolean 0
set_parameter_property trig_no_range_reduction DISPLAY_NAME "Inputs are within range -2pi to +2pi"
set_parameter_property trig_no_range_reduction UNITS None
set_parameter_property trig_no_range_reduction VISIBLE false
set_parameter_property trig_no_range_reduction DESCRIPTION "This is an efficient option which disables range reduction for Hard Floating Point" 
set_parameter_property trig_no_range_reduction AFFECTS_GENERATION true


add_parameter report_resources_to_xml boolean 0
set_parameter_property report_resources_to_xml visible false

add_parameter fxpt_width POSITIVE 32 
set_parameter_property fxpt_width DISPLAY_NAME "Width"
set_parameter_property fxpt_width ALLOWED_RANGES 16:128 
set_parameter_property fxpt_width UNITS Bits
set_parameter_property fxpt_width DESCRIPTION "Choose the width of the fixed point data"
set_parameter_property fxpt_width AFFECTS_GENERATION true

add_parameter fxpt_fraction INTEGER 0 
set_parameter_property fxpt_fraction DISPLAY_NAME "Fraction"
set_parameter_property fxpt_fraction UNITS Bits
set_parameter_property fxpt_fraction DESCRIPTION "Choose the number of fraction bits"
set_parameter_property fxpt_fraction AFFECTS_GENERATION true
set_parameter_property fxpt_fraction ALLOWED_RANGES "-128:128"


add_parameter fxpt_sign STRING "1"
set_parameter_property fxpt_sign DISPLAY_NAME "Sign"
#set_parameter_property fxpt_sign DISPLAY_HINT radio 
set_parameter_property fxpt_sign UNITS None
set_parameter_property fxpt_sign ALLOWED_RANGES {"1:signed" "0:unsigned" } 
set_parameter_property fxpt_sign DESCRIPTION "Choose the signedness of the fixed point data" 
set_parameter_property fxpt_sign AFFECTS_GENERATION true


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


add_parameter fp_out_format STRING "single" 
#set_parameter_property fp_out_format DISPLAY_HINT radio
set_parameter_property fp_out_format DISPLAY_NAME "Output Format"
set_parameter_property fp_out_format UNITS None
set_parameter_property fp_out_format ALLOWED_RANGES $fp_format_range
set_parameter_property fp_out_format DESCRIPTION "Choose the floating point format for the output"
set_parameter_property fp_out_format AFFECTS_GENERATION true


add_parameter fp_out_exp POSITIVE 8 
set_parameter_property fp_out_exp DISPLAY_NAME "Output Exponent"
set_parameter_property fp_out_exp UNITS Bits
set_parameter_property fp_out_exp DESCRIPTION "Choose the width of the output exponent in bits"
set_parameter_property fp_out_exp AFFECTS_GENERATION true

add_parameter fp_out_exp_derived POSITIVE 8
set_parameter_property fp_out_exp_derived DERIVED true
set_parameter_property fp_out_exp_derived VISIBLE false
set_parameter_property fp_out_exp_derived AFFECTS_GENERATION true

add_parameter fp_out_man POSITIVE 23 
set_parameter_property fp_out_man DISPLAY_NAME "Output Mantissa"
set_parameter_property fp_out_man UNITS Bits
set_parameter_property fp_out_man DESCRIPTION "Choose the width of the output mantissa in bits"
set_parameter_property fp_out_man AFFECTS_GENERATION true

add_parameter fp_out_man_derived POSITIVE 8 
set_parameter_property fp_out_man_derived DERIVED true
set_parameter_property fp_out_man_derived VISIBLE false
set_parameter_property fp_out_man_derived AFFECTS_GENERATION true


add_parameter fp_in_format STRING "single" 
#set_parameter_property fp_in_format DISPLAY_HINT radio
set_parameter_property fp_in_format DISPLAY_NAME "Input Format"
set_parameter_property fp_in_format UNITS None
set_parameter_property fp_in_format ALLOWED_RANGES $fp_format_range
set_parameter_property fp_in_format DESCRIPTION "Choose the floating point format for the input"
set_parameter_property fp_in_format AFFECTS_GENERATION true


add_parameter fp_in_exp POSITIVE 8 
set_parameter_property fp_in_exp DISPLAY_NAME "Input Exponent"
set_parameter_property fp_in_exp UNITS Bits
set_parameter_property fp_in_exp DESCRIPTION "Choose the width of the input exponent in bits"
set_parameter_property fp_in_exp AFFECTS_GENERATION true

add_parameter fp_in_exp_derived POSITIVE 8
set_parameter_property fp_in_exp_derived DERIVED true
set_parameter_property fp_in_exp_derived VISIBLE false
set_parameter_property fp_in_exp_derived AFFECTS_GENERATION true

add_parameter fp_in_man POSITIVE 23 
set_parameter_property fp_in_man DISPLAY_NAME "Input Mantissa"
set_parameter_property fp_in_man UNITS Bits
set_parameter_property fp_in_man DESCRIPTION "Choose the width of the input mantissa in bits"
set_parameter_property fp_in_man AFFECTS_GENERATION true

add_parameter fp_in_man_derived POSITIVE 8 
set_parameter_property fp_in_man_derived DERIVED true
set_parameter_property fp_in_man_derived VISIBLE false
set_parameter_property fp_in_man_derived AFFECTS_GENERATION true



add_parameter enable_hard_fp boolean true
set_parameter_property enable_hard_fp VISIBLE false
set_parameter_property enable_hard_fp AFFECTS_GENERATION true
set_parameter_property enable_hard_fp DISPLAY_NAME [get_string HARD_FP_REP_NAME]


add_parameter manual_dsp_planning boolean true
set_parameter_property manual_dsp_planning VISIBLE false
set_parameter_property manual_dsp_planning AFFECTS_GENERATION true
set_parameter_property manual_dsp_planning DISPLAY_NAME [get_string HARD_FP_REP_NAME]


add_parameter forceRegisters String "1111"
set_parameter_property forceRegisters VISIBLE false
set_parameter_property forceRegisters AFFECTS_GENERATION true











set latency_button_pressed false
set resource_button_pressed false

# 
# display items
# 
add_display_item Function select_signal_enable PARAMETER

add_display_item "" Functionality GROUP
set_display_item_property Functionality DISPLAY_HINT TAB
# add_display_item "" Advanced GROUP
# set_display_item_property Advanced DISPLAY_HINT TAB
add_display_item "" Performance GROUP
set_display_item_property Performance DISPLAY_HINT TAB

add_display_item Functionality Function GROUP
add_display_item Functionality "Floating Point Data" GROUP
add_display_item Functionality "Fixed Point Data" GROUP
set_display_item_property "Fixed Point Data" VISIBLE false
add_display_item Performance Target GROUP
add_display_item Performance Report GROUP
add_display_item Performance "Register Report" GROUP

add_display_item Functionality Rounding GROUP
add_display_item Functionality Algorithm GROUP
add_display_item Functionality "Data Widths" GROUP
add_display_item Functionality Ports GROUP

add_display_item Function derivedfunction PARAMETER
add_display_item Function convert_type PARAMETER

add_display_item "Floating Point Data" fp_format PARAMETER
add_display_item "Floating Point Data" fp_exp PARAMETER
add_display_item "Floating Point Data" fp_man PARAMETER
add_display_item "Floating Point Data" fp_in_format PARAMETER
add_display_item "Floating Point Data" fp_in_exp PARAMETER
add_display_item "Floating Point Data" fp_in_man PARAMETER
add_display_item "Floating Point Data" fp_out_format PARAMETER
add_display_item "Floating Point Data" fp_out_exp PARAMETER
add_display_item "Floating Point Data" fp_out_man PARAMETER
add_display_item "Floating Point Data" exponent_width PARAMETER
add_display_item "Floating Point Data" number_of_inputs PARAMETER


add_display_item Function scale_by_pi PARAMETER
add_display_item Function trig_no_range_reduction PARAMETER

add_display_item "Fixed Point Data" fxpt_width PARAMETER
add_display_item "Fixed Point Data" fxpt_fraction PARAMETER
add_display_item "Fixed Point Data" fxpt_sign PARAMETER

add_display_item Target enable_hard_fp PARAMETER


add_display_item Target performance_goal PARAMETER
add_display_item Target frequency_target PARAMETER
add_display_item Target latency_target PARAMETER



add_display_item Report report_pane TEXT ""
add_display_item Report check_performance_button ACTION latency_button_proc
set_display_item_property check_performance_button DISPLAY_NAME "Check Performance"
set_display_item_property check_performance_button DESCRIPTION "Press button to check if the requested latency is achievable and if so at what frequency"
add_display_item Report RES_TITLE TEXT ""



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



add_display_item Rounding rounding_mode PARAMETER
add_display_item Rounding rounding_mode_derived PARAMETER
add_display_item Rounding faithful_rounding PARAMETER
add_display_item Algorithm divide_type PARAMETER



add_display_item Ports gen_enable PARAMETER

# add_display_item Resources resource_pane TEXT ""
# add_display_item Resources check_resource_usage_button ACTION resource_button_proc
# set_display_item_property check_resource_usage_button DISPLAY_NAME "Check Resource Usage"
# set_display_item_property check_resource_usage_button DESCRIPTION "Press button to check the estimated resource usage for the configuration"
add_display_item Report RES_DSP_param PARAMETER
add_display_item Report RES_LUT_param PARAMETER
add_display_item Report RES_MBIT_param PARAMETER
add_display_item Report RES_MBLOCK_param PARAMETER

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

set rounding_mode_prompt "Select a rounding mode on the Advanced tab"

proc has_hard_fp {}  {
    global fp_family
    global fp_funcs
    global HARD_FP_FUNCTIONS
    set current_family [get_parameter_value FUNCTION_FAMILY]
    set paramname "${current_family}_function"
    set current_function [get_parameter_value $paramname]

    if { ([lsearch $HARD_FP_FUNCTIONS $current_function]!= -1)  
        && ([get_parameter_value selected_device_family] eq "Stratix 10" || [get_parameter_value selected_device_family] eq "Arria 10")
        && [get_parameter_value fp_format] eq "single" } {
            set require_range_reduction [list SIN COS]
            #If trig functions they have to have range reduction to be hard FP
            if {  ([lsearch $require_range_reduction $current_function]!= -1)  && ![get_parameter_value trig_no_range_reduction] } { 
                return false
            }
        return true
    } else {
        return false
    }
}

proc has_dsp_planner {} {
    global fp_family
    global fp_funcs
    global HARD_FP_FUNCTIONS
    global DIRECT_DSP_FUNCTIONS
    set current_family [get_parameter_value FUNCTION_FAMILY]
    set paramname "${current_family}_function"
    set current_function [get_parameter_value $paramname]

    if { [has_hard_fp] } {
        if { ([lsearch $DIRECT_DSP_FUNCTIONS $current_function]!= -1)  } {
            return true
        }
    } 
    return false
}


proc show_dsp_planner {} {
    set_parameter_property performance_goal ALLOWED_RANGES [list "frequency:[get_string FREQUENCY_REP_NAME]" "latency:[get_string LATENCY_REP_NAME]" "combined:[get_string COMBINED_REP_NAME]" "manual:[get_string MANUAL_DSPS_NAME]"]

}
proc disable_dsp_planner {} {
    set_parameter_property performance_goal ALLOWED_RANGES [list "frequency:[get_string FREQUENCY_REP_NAME]" "latency:[get_string LATENCY_REP_NAME]" "combined:[get_string COMBINED_REP_NAME]"]
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
    set_parameter_property number_of_inputs VISIBLE false
    set_parameter_property scale_by_pi VISIBLE false
    set_parameter_property trig_no_range_reduction VISIBLE false
    set_parameter_property exponent_width VISIBLE false
    set_parameter_property divide_type VISIBLE false
    set_parameter_property rounding_mode VISIBLE false 
    set_display_item_property faithful_rounding VISIBLE false
    set_parameter_property rounding_mode_derived VISIBLE false 
    set_parameter_value use_rounding_mode false
    set_display_item_property "Fixed Point Data" VISIBLE false
    set_parameter_property fp_out_format VISIBLE false
    set_parameter_property fp_out_exp VISIBLE false
    set_parameter_property fp_out_man VISIBLE false
    set_parameter_property fp_in_format VISIBLE false
    set_parameter_property fp_in_exp VISIBLE false
    set_parameter_property fp_in_man VISIBLE false
    set_parameter_property select_signal_enable VISIBLE false


}

proc default_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
}
proc ldexp_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property exponent_width VISIBLE true
}

proc default_arith_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property rounding_mode VISIBLE false 
    set_display_item_property Rounding VISIBLE true
    set_parameter_value use_rounding_mode true
    set_display_item_property faithful_rounding VISIBLE true
    set_parameter_property rounding_mode_derived VISIBLE true 
    set_parameter_value rounding_mode_derived "nearest with tie breaking to even" 
}
proc compmult_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    # set_parameter_property rounding_mode VISIBLE false 
    # set_parameter_property rounding_mode_derived VISIBLE true 
}

proc scalarprod_validate {} {
    update_menu
    hide_optionals
    set_parameter_property number_of_inputs VISIBLE true
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property rounding_mode VISIBLE false 
    set_display_item_property Rounding VISIBLE true
    set_parameter_value use_rounding_mode true
    set_display_item_property faithful_rounding VISIBLE true
    set_parameter_property rounding_mode_derived VISIBLE true 
    set_parameter_value rounding_mode_derived "nearest with tie breaking to even" 
}

proc mult_acc_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    if { [get_parameter_value fp_format] ne "single" } {
        send_message ERROR "Muliply Accumulate supports single floating point only"
    }
    if { ![has_hard_fp] } {
        send_message ERROR "Muliply Accumulate supports Arria 10 and newer devices only"
    }
    if { [get_parameter_value enable_hard_fp] eq 0 } {
        send_message ERROR "Muliply Accumulate requires hard floating point blocks"
    }

}

proc addsub_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property rounding_mode VISIBLE false 
    set_display_item_property Rounding VISIBLE true
    set_parameter_value use_rounding_mode true
    set_display_item_property faithful_rounding VISIBLE true
    set_parameter_property rounding_mode_derived VISIBLE true 
    set_parameter_property select_signal_enable VISIBLE true 
    set_parameter_value rounding_mode_derived "nearest with tie breaking to even" 
}


proc abs_validate {} {
    update_menu
    hide_optionals
    set_display_item_property Rounding VISIBLE false
    set_parameter_property performance_goal VISIBLE false
    set_parameter_property frequency_target VISIBLE false
    set_parameter_property latency_target VISIBLE false
    set_display_item_property report_pane VISIBLE true
    show_resource_estimates
    set_display_item_property check_performance_button VISIBLE false
    set_display_item_property report_pane TEXT "Latency on [get_parameter_value selected_device_family] is 0 cycles at all frequencies"
}

proc min_max_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    set_display_item_property Rounding VISIBLE false
}

proc compare_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    set_display_item_property Rounding VISIBLE false
}
proc trig_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property scale_by_pi VISIBLE true
    set_display_item_property Rounding VISIBLE false
    if {  ([get_function_option name] eq "Sin" || [get_function_option name] eq "Cos")} {
        set_parameter_property trig_no_range_reduction VISIBLE TRUE
        if { [get_parameter_value trig_no_range_reduction] && [get_parameter_value scale_by_pi] } {
            send_message ERROR "Cannot scale by Pi and disable range reduction together"
        }
        if { ![has_hard_fp] && [get_parameter_value trig_no_range_reduction] } {
            send_message INFO "This disables range reduction for newer devices, older devices will not benefit from this constraint"
        }
        if { [get_parameter_value fp_format] ne "single" && [get_parameter_value trig_no_range_reduction] } {
            send_message ERROR "Disabling Range reduction supports single floating point only"
        }
        if { [get_parameter_value enable_hard_fp] eq 0 && [get_parameter_value trig_no_range_reduction] } {
            send_message ERROR "Disabling range reduction supports single floating point only"
        }
    }
}



proc divide_validate {} {
    update_menu
    hide_optionals

    set_parameter_value use_rounding_mode true
    set_display_item_property faithful_rounding VISIBLE true
    set_parameter_property rounding_mode_derived VISIBLE true 
    set_parameter_value rounding_mode_derived "nearest with tie breaking to even" 


    set_parameter_property performance_goal VISIBLE true

    set fp_fmt [get_parameter_value fp_format]
    if {$fp_fmt == "double" } {
    set_parameter_property divide_type VISIBLE true
    } else {
    set_parameter_property divide_type VISIBLE false
    }
}


proc convert_fp_validate {} {
    update_menu
    hide_optionals
    set_parameter_property fp_format VISIBLE false
    set_parameter_property fp_exp VISIBLE false
    set_parameter_property fp_man VISIBLE false
    set_parameter_property performance_goal VISIBLE true
    set_parameter_property fp_out_format VISIBLE true
    global rounding_mode_prompt
    set fp_fmt [get_parameter_value fp_out_format]
    switch -exact $fp_fmt {
        single {
            set_parameter_value fp_out_man_derived 23
            set_parameter_value fp_out_exp_derived 8
            set_parameter_property fp_out_man VISIBLE false
            set_parameter_property fp_out_exp VISIBLE false
        }

        double {
            set_parameter_value fp_out_man_derived 52
            set_parameter_value fp_out_exp_derived 11
            set_parameter_property fp_out_man VISIBLE false
            set_parameter_property fp_out_exp VISIBLE false
        }

        custom {
            set_parameter_value fp_out_man_derived [get_parameter_value fp_out_man]
            set_parameter_value fp_out_exp_derived [get_parameter_value fp_out_exp] 
            set_parameter_property fp_out_man VISIBLE true
            set_parameter_property fp_out_exp VISIBLE true
        }
    }
    set_parameter_property fp_in_format VISIBLE true
    global rounding_mode_prompt
    set fp_fmt [get_parameter_value fp_in_format]
    switch -exact $fp_fmt {
        single {
            set_parameter_value fp_in_man_derived 23
            set_parameter_value fp_in_exp_derived 8
            set_parameter_property fp_in_man VISIBLE false
            set_parameter_property fp_in_exp VISIBLE false
        }

        double {
            set_parameter_value fp_in_man_derived 52
            set_parameter_value fp_in_exp_derived 11
            set_parameter_property fp_in_man VISIBLE false
            set_parameter_property fp_in_exp VISIBLE false
        }

        custom {
            set_parameter_value fp_in_man_derived [get_parameter_value fp_in_man]
            set_parameter_value fp_in_exp_derived [get_parameter_value fp_in_exp] 
            set_parameter_property fp_in_man VISIBLE true
            set_parameter_property fp_in_exp VISIBLE true
        }
    }

}

proc convert_validate {} {
    update_menu
    hide_optionals
    set_parameter_property performance_goal VISIBLE true
    set_display_item_property "Fixed Point Data" VISIBLE true
    global fl_to_fx
    global rounding_mode_prompt
    if { [get_parameter_value derivedfunction] eq "FP_FXP" } {
        # set_display_item_property Rounding VISIBLE true
        # send_message INFO $rounding_mode_prompt
        # set_parameter_property rounding_mode VISIBLE true
            set_parameter_property fp_man VISIBLE true
            set_parameter_property fp_exp VISIBLE true
        set_parameter_value rounding_mode_derived [get_parameter_value rounding_mode]
    } else {
        set_display_item_property Rounding VISIBLE false
    }

    # the fraction bits could be negative and also larger than the fxpt_width   
    # but let's not do it in this release 
    set fx_w [get_parameter_value fxpt_width]
    # set_parameter_property fxpt_fraction ALLOWED_RANGES "0:$fx_w"
    set frac [get_parameter_value fxpt_fraction]
    if { $frac > $fx_w || $frac < 0 } {
        set_parameter_value validation_failed true
    }
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

#
# Two input one output, same bit width 
# 
proc default_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_input b $bit_width
        add_interface_output q $bit_width
    }
}

proc addsub_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_input b $bit_width
        add_interface_output q $bit_width
        if { [get_parameter_value select_signal_enable] } {
            add_interface_input opSel 1
        } else {
            add_interface_output s $bit_width
        }
    }

}
proc compmult_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_input b $bit_width
        add_interface_input c $bit_width
        add_interface_input d $bit_width
        add_interface_output q $bit_width
        add_interface_output r $bit_width
    }

}
#
# One input one output, same bit width
#
proc one_each_same_width_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_output q $bit_width
    }
}
proc three_in_one_out {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_input b $bit_width
        add_interface_input c $bit_width
        add_interface_output q $bit_width
    }
}
proc acc_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_output q $bit_width
    }
     add_interface_input acc 1
}
proc macc_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_input b $bit_width
        add_interface_output q $bit_width
    }
     add_interface_input acc 1
}
proc scalarprod_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        for {set i 0} {$i < [get_parameter_value number_of_inputs]} {incr i} {        
            add_interface_input "a$i" $bit_width
            add_interface_input "b$i" $bit_width
        }
        add_interface_output q $bit_width
    }
}
proc two_in_one_out_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_input b $bit_width
        add_interface_output q $bit_width
    }
}

proc ldexp_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    set exponent_width [get_parameter_value exponent_width]
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_input b $bit_width
        add_interface_input c $exponent_width
        add_interface_output q $bit_width
    }
}

#
# Two inputs of bit width, one single bit output
#
proc two_in_single_bit_out_elaborate {} {
    set bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    if { $bit_width > 0 } {
        add_interface_input a $bit_width
        add_interface_input b $bit_width
        add_interface_output q 1 
        set_port_property q VHDL_TYPE STD_LOGIC_VECTOR
    }
}

proc convert_elaborate {} {
    set type [get_parameter_value derivedfunction]
    set fl_bit_width [expr {[get_parameter_value fp_exp_derived] + [get_parameter_value fp_man_derived] + 1}]  
    set fx_bit_width [get_parameter_value fxpt_width]
    global fl_to_fx 
    if { $fx_bit_width > 0 &&  $fx_bit_width > 0} {
        if { [expr {$type eq "FXP_FP"}] } {
            add_interface_input a $fx_bit_width
            add_interface_output q $fl_bit_width
        } elseif { [expr {$type eq "FP_FXP"}] } {
            add_interface_input a $fl_bit_width
            add_interface_output q $fx_bit_width
        }
    }
}

proc convert_fp_elaborate {} {
    set type [get_parameter_value derivedfunction]
    set fl_in_bit_width [expr {[get_parameter_value fp_in_exp_derived] + [get_parameter_value fp_in_man_derived] + 1}]  
    set fl_out_bit_width [expr {[get_parameter_value fp_out_exp_derived] + [get_parameter_value fp_out_man_derived] + 1}] 
    if { $fl_in_bit_width > 0 &&  $fl_out_bit_width > 0} {
        add_interface_input a $fl_in_bit_width
        add_interface_output q $fl_out_bit_width
    }
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
    # if { [is_goal_frequency] } {
    #     set freq [get_parameter_value frequency_target]
    # } else {
    #     set freq [find_frequency [get_parameter_value latency_target]]
    # }
    # if { [expr $freq > 0] } {
    #     set output [call_cmdPolyEval $entity_name $quartus_dir $tmp_dir "report" $freq] 
    #     array set report [extract_report $output]
    #     report_latency [array get report] true  
    # } else {
    #     set_display_item_property resource_pane TEXT "Could not achieve the requested latency.\n \n Nearest achievable latency is  cycles, please modify to gain resource estimates."
    # }
    # set_display_item_property resource_pane VISIBLE true
    set_resource_button_pressed true
}



proc validate_input {} {
    set_parameter_value validation_failed false

    set man [get_parameter_value fp_man]
    set exp [get_parameter_value fp_exp]
    set width [get_parameter_value fxpt_width]
    if { $man < 1 || $exp < 1 || $width < 1 } {
        set_parameter_value validation_failed true
    }

    set fp_fmt [get_parameter_value fp_format]
    switch -exact $fp_fmt {
        single {
            set_parameter_value fp_man_derived 23
            set_parameter_value fp_exp_derived 8
            set_parameter_property fp_man VISIBLE false
            set_parameter_property fp_exp VISIBLE false
        }

        double {
            set_parameter_value fp_man_derived 52
            set_parameter_value fp_exp_derived 11
            set_parameter_property fp_man VISIBLE false
            set_parameter_property fp_exp VISIBLE false
        }

        custom {
            set_parameter_value fp_man_derived [get_parameter_value fp_man]
            set_parameter_value fp_exp_derived [get_parameter_value fp_exp] 
            set_parameter_property fp_man VISIBLE true
            set_parameter_property fp_exp VISIBLE true
        }
    }

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

    if { [has_hard_fp]   } {
        set_parameter_property enable_hard_fp VISIBLE true
        if { [has_dsp_planner] && [get_parameter_value enable_hard_fp]} {
            show_dsp_planner
        } else {
            disable_dsp_planner
        }
    } else {
        set_parameter_property enable_hard_fp VISIBLE false
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
        } elseif { [is_goal_manual_dsps] } {
           set_display_item_property check_performance_button VISIBLE false
           set_display_item_property report_pane VISIBLE false
           set_display_item_property Report VISIBLE false
           set_display_item_property "Register Report" VISIBLE true
           hide_resource_estimates
           set FR [get_parameter_value forceRegisters] 
           send_message INFO "Register Values: $FR"
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



proc upgrade_callback {ip_core_type version old_parameters} {

    if { [compare_versions $version "14.1"] == -1 } {
        send_message INFO "Core: $ip_core_type Version: $version with $old_parameters"
        global fp_family
        set_parameter_value performance_goal "combined"
        set new_parameters [get_parameters ]
        foreach { name value } $old_parameters {
            if { $name eq "fp_function"} { 
                if { $value eq "Compare"} {
                    set_parameter_value FUNCTION_FAMILY "COMPARE"
                } elseif {$value eq "Convert" } {
                    set_parameter_value FUNCTION_FAMILY "CONVERT"
                } else {
                    foreach current_family [array names fp_family] {
                        if { [string compare -nocase $current_family "All"] == 0 } {
                            set family $fp_family($current_family)
                            set family_operations [lindex $family 1]
                            foreach FUNCTION_ID $family_operations {
                                global fp_funcs
                                set func $fp_funcs($FUNCTION_ID)
                                if { $value eq [get_string [lindex $func 0]] } {
                                    send_message INFO  "$value matched [get_string [lindex $func 0]]"
                                    set_parameter_value FUNCTION_FAMILY $current_family
                                    set_parameter_value "${current_family}_function" $FUNCTION_ID
                                }
                            }
                        }
                    }
                }
            } elseif { $name eq "compare_type" } {
                    set_parameter_value COMPARE_FUNCTION "$value"
            } elseif { $name eq "convert_type" } {
                if { $value  eq "Fixed to Floating" } {
                    set_parameter_value CONVERT_FUNCTION "FXP_FP"
                } else {
                    set_parameter_value CONVERT_FUNCTION "FP_FXP"
                }
            } else {
                if { [lsearch $new_parameters $name] != -1 } {
                    set_parameter_value $name $value
                }
            }
        }
    } else { ;# For non 14.0->14.1 upgrade flows 
        foreach { name value } $old_parameters {
            set_parameter_value $name $value
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
    } elseif { [is_goal_manual_dsps] } {
        lappend args "-forceRegisters"
        lappend args [get_parameter_value forceRegisters]    
    }

    lappend args "-name"
    lappend args $entity_name
    lappend args "-noChanValid"
    if { [get_parameter_value gen_enable] } {
        lappend args "-enable"
    }
    if { [get_parameter_value enable_hard_fp] } {
        lappend args "-enableHardFP"
        lappend args "1"
    } else {
        lappend args "-enableHardFP"
        lappend args "0"
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


    if { [get_parameter_value use_rounding_mode] } {
        if { [is_rounding_to_nearest] } {
            if { [get_parameter_value faithful_rounding] } {
                lappend args "-faithfulRounding"
            } else {
                lappend args "-correctRounding"
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

proc op_exp_man {} {
    set args [list]
    lappend args [get_function_option name]
    lappend args [get_parameter_value fp_exp_derived]
    lappend args [get_parameter_value fp_man_derived]
    return $args
}
proc scalarprod_args {} {
    set args [list]
    lappend args [get_function_option name]
    lappend args [get_parameter_value fp_exp_derived]
    lappend args [get_parameter_value fp_man_derived]
    lappend args [get_parameter_value number_of_inputs]
    return $args
}

proc ldexp_cmd {} {
    set args [list]
    lappend args [get_function_option name]
    lappend args [get_parameter_value fp_exp_derived]
    lappend args [get_parameter_value fp_man_derived]
    lappend args [get_parameter_value exponent_width]
    return $args
}

proc trig_cmd {} {
    set args [list]
    set cmd ""
    append cmd "FP"
    append cmd [get_function_option name]
    if {([has_hard_fp]) && [get_parameter_value trig_no_range_reduction] && [get_parameter_property trig_no_range_reduction VISIBLE] } {
        append cmd "XNoRR"
    } else {
        if { [get_parameter_value scale_by_pi]  } {
            append cmd "Pi"
            set X_Functions  [list Sin Cos Tan Cot]
            if { [lsearch $X_Functions [get_function_option name]] != -1 } {
                append cmd "X"
            }
        } else {
            append cmd "X"
        }
    }

    lappend args $cmd
    lappend args [get_parameter_value fp_exp_derived]
    lappend args [get_parameter_value fp_man_derived]
    return $args
}

proc addsub_cmd {} {
    set args [list]
    if { ![get_parameter_value select_signal_enable] } {
        lappend args "FPFusedAddSub"
    } else {
        lappend args "FPAddSub"
    }
    lappend args [get_parameter_value fp_exp_derived]
    lappend args [get_parameter_value fp_man_derived]
    return $args
}



proc compare_cmd {} {
    set args [list]
    lappend args FPCompare
    lappend args [get_parameter_value fp_exp_derived]
    lappend args [get_parameter_value fp_man_derived]
    switch -exact [get_parameter_value derivedfunction] {
        LT {
            lappend args -2 
        }

        LE {
            lappend args -1
        }

        EQ {
            lappend args 0 
        }
        GE {
            lappend args 1
        }

        GT {
            lappend args 2 
        }
        NEQ {
            lappend args 3 
        }
    }
    return $args
}

proc divide_cmd {} {
    set args [list ]
    lappend args FPDiv
    lappend args [get_parameter_value fp_exp_derived]
    lappend args [get_parameter_value fp_man_derived]
    set fp_fmt [get_parameter_value fp_format]
    if {$fp_fmt == "double" } {
        lappend args [get_parameter_value divide_type]
    } else {
        lappend args 0
    }
    return $args
}

proc convert_fp_cmd {} { 
        set args [list]
        lappend args "FPToFP" 
        lappend args [get_parameter_value fp_in_exp_derived]
        lappend args [get_parameter_value fp_in_man_derived]
        lappend args [get_parameter_value fp_out_exp_derived]
        lappend args [get_parameter_value fp_out_man_derived]
        return $args
}


proc convert_cmd {} {
    set type [get_parameter_value derivedfunction]
    set args [list]
    if { [expr {$type eq "FXP_FP"}] } {
        lappend args "FXPToFP" 
        lappend args [get_parameter_value fxpt_width]
        lappend args [get_parameter_value fxpt_fraction]
        lappend args [get_parameter_value fxpt_sign]
        lappend args [get_parameter_value fp_exp_derived]
        lappend args [get_parameter_value fp_man_derived]
    } elseif { [expr {$type eq "FP_FXP"}] } {
        lappend args "FPToFXP"
        lappend args [get_parameter_value fp_exp_derived]
        lappend args [get_parameter_value fp_man_derived]
        lappend args [get_parameter_value fxpt_width]
        lappend args [get_parameter_value fxpt_fraction]
        lappend args [get_parameter_value fxpt_sign]
        # append args " "
        # append args [expr {[is_rounding_to_nearest] ? 1 : 0}]
    }
    return $args

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

proc is_goal_manual_dsps {} {
 return [expr {[get_parameter_value performance_goal] eq "manual"}]
}

proc is_rounding_to_nearest {} {
    return [regexp nearest [get_parameter_value rounding_mode_derived] match]
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
        set params(mblocks)    $report(RAMBlockUsage)
    } else {
        set params(mblocks)     "unknown"
    }
    if {[info exists report(RAMBlockUsage)] } {
        set params(mbits)  $report(RAMBits)
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

