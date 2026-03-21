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


# --------------------------------------------------------------------------------------------------
#--                                                                                               --
#-- _hw.tcl compose file for Component Library Color Space Converter (Color Space Converter II)   --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info

# Module properties
set_module_property  NAME             alt_vip_cl_csc
set_module_property  DISPLAY_NAME     "Color Space Converter II (4K Ready) Intel FPGA IP"
set_module_property  DESCRIPTION      "The CSC converts between color spaces using either predefined settings or user specified coefficients."

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Upgrade callback
set_module_property  PARAMETER_UPGRADE_CALLBACK  upgrade_cb

# Validation callback to check legality of parameter set
set_module_property  VALIDATION_CALLBACK         validation_cb

# Callback for the composition of this component
set_module_property  COMPOSITION_CALLBACK        composition_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_in_out_bits_per_symbol_parameters
set_parameter_property  INPUT_BITS_PER_SYMBOL        HDL_PARAMETER         false
set_parameter_property  OUTPUT_BITS_PER_SYMBOL       HDL_PARAMETER         false

add_channels_nb_parameters {3}
set_parameter_property  NUMBER_OF_COLOR_PLANES       DEFAULT_VALUE         3
set_parameter_property  NUMBER_OF_COLOR_PLANES       ENABLED               false
set_parameter_property  NUMBER_OF_COLOR_PLANES       VISIBLE               false
set_parameter_property  NUMBER_OF_COLOR_PLANES       HDL_PARAMETER         false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER         false

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL           HDL_PARAMETER         false


# Desired floating point values for the coefficients / summand
foreach name {A B C S} {
    foreach id {0 1 2} {
        add_parameter           REQ_FCOEFF_$name$id          FLOAT                 0.0
        #(set VISIBLE to false although these parameters will still be visible from the Java helper widget)
        set_parameter_property  REQ_FCOEFF_$name$id          VISIBLE               false
    }
}
# Default to identity matrix
foreach name {A B C} id {0 1 2} {
    set_parameter_property  REQ_FCOEFF_$name$id          DEFAULT_VALUE         1.0
}

add_parameter           INPUT_DATA_TYPE_SIGNED       INTEGER               0
set_parameter_property  INPUT_DATA_TYPE_SIGNED       DISPLAY_NAME          "Signed"
set_parameter_property  INPUT_DATA_TYPE_SIGNED       DESCRIPTION           "Specifies whether the input is unsigned or signed 2s complement."
set_parameter_property  INPUT_DATA_TYPE_SIGNED       ALLOWED_RANGES        0:1
set_parameter_property  INPUT_DATA_TYPE_SIGNED       DISPLAY_HINT          BOOLEAN
set_parameter_property  INPUT_DATA_TYPE_SIGNED       HDL_PARAMETER         false
set_parameter_property  INPUT_DATA_TYPE_SIGNED       AFFECTS_ELABORATION   true
set_parameter_property  INPUT_DATA_TYPE_SIGNED       VISIBLE               false

add_parameter           INPUT_DATA_TYPE_GUARD_BAND   INTEGER               0
set_parameter_property  INPUT_DATA_TYPE_GUARD_BAND   DISPLAY_NAME          "Guard bands"
set_parameter_property  INPUT_DATA_TYPE_GUARD_BAND   DESCRIPTION           "Enables using a defined input range"
set_parameter_property  INPUT_DATA_TYPE_GUARD_BAND   ALLOWED_RANGES        0:1
set_parameter_property  INPUT_DATA_TYPE_GUARD_BAND   DISPLAY_HINT          BOOLEAN
set_parameter_property  INPUT_DATA_TYPE_GUARD_BAND   HDL_PARAMETER         false
set_parameter_property  INPUT_DATA_TYPE_GUARD_BAND   AFFECTS_ELABORATION   true

add_parameter           INPUT_DATA_TYPE_MIN          INTEGER               0
set_parameter_property  INPUT_DATA_TYPE_MIN          DISPLAY_NAME          "Min"
set_parameter_property  INPUT_DATA_TYPE_MIN          DESCRIPTION           "Specifies the input range minimum value."
set_parameter_property  INPUT_DATA_TYPE_MIN          ALLOWED_RANGES        0:1048575
set_parameter_property  INPUT_DATA_TYPE_MIN          HDL_PARAMETER         false
set_parameter_property  INPUT_DATA_TYPE_MIN          AFFECTS_ELABORATION   true

add_parameter           INPUT_DATA_TYPE_MAX          INTEGER               255
set_parameter_property  INPUT_DATA_TYPE_MAX          DISPLAY_NAME          "Max"
set_parameter_property  INPUT_DATA_TYPE_MAX          DESCRIPTION           "Specifies the input range maximum value."
set_parameter_property  INPUT_DATA_TYPE_MAX          ALLOWED_RANGES        0:1048575
set_parameter_property  INPUT_DATA_TYPE_MAX          HDL_PARAMETER         false
set_parameter_property  INPUT_DATA_TYPE_MAX          AFFECTS_ELABORATION   true

add_parameter           OUTPUT_DATA_TYPE_SIGNED      INTEGER               0
set_parameter_property  OUTPUT_DATA_TYPE_SIGNED      DISPLAY_NAME          "Signed"
set_parameter_property  OUTPUT_DATA_TYPE_SIGNED      DESCRIPTION           "Specify whether the output is unsigned or signed 2s complement."
set_parameter_property  OUTPUT_DATA_TYPE_SIGNED      ALLOWED_RANGES        0:1
set_parameter_property  OUTPUT_DATA_TYPE_SIGNED      DISPLAY_HINT          BOOLEAN
set_parameter_property  OUTPUT_DATA_TYPE_SIGNED      HDL_PARAMETER         false
set_parameter_property  OUTPUT_DATA_TYPE_SIGNED      AFFECTS_ELABORATION   true
set_parameter_property  OUTPUT_DATA_TYPE_SIGNED      VISIBLE               false

add_parameter           OUTPUT_DATA_TYPE_GUARD_BAND  INTEGER               0
set_parameter_property  OUTPUT_DATA_TYPE_GUARD_BAND  DISPLAY_NAME          "Guard bands"
set_parameter_property  OUTPUT_DATA_TYPE_GUARD_BAND  DESCRIPTION           "Turn on to enable a defined output range."
set_parameter_property  OUTPUT_DATA_TYPE_GUARD_BAND  ALLOWED_RANGES        0:1
set_parameter_property  OUTPUT_DATA_TYPE_GUARD_BAND  DISPLAY_HINT          BOOLEAN
set_parameter_property  OUTPUT_DATA_TYPE_GUARD_BAND  HDL_PARAMETER         false
set_parameter_property  OUTPUT_DATA_TYPE_GUARD_BAND  AFFECTS_ELABORATION   true

add_parameter           OUTPUT_DATA_TYPE_MIN         INTEGER               0
set_parameter_property  OUTPUT_DATA_TYPE_MIN         DISPLAY_NAME          "Min"
set_parameter_property  OUTPUT_DATA_TYPE_MIN         DESCRIPTION           "Specifies the output range minimum value."
set_parameter_property  OUTPUT_DATA_TYPE_MIN         ALLOWED_RANGES        0:1048575
set_parameter_property  OUTPUT_DATA_TYPE_MIN         HDL_PARAMETER         false
set_parameter_property  OUTPUT_DATA_TYPE_MIN         AFFECTS_ELABORATION   true

add_parameter           OUTPUT_DATA_TYPE_MAX         INTEGER               255
set_parameter_property  OUTPUT_DATA_TYPE_MAX         DISPLAY_NAME          "Max"
set_parameter_property  OUTPUT_DATA_TYPE_MAX         DESCRIPTION           "Specifies the output range maximum value."
set_parameter_property  OUTPUT_DATA_TYPE_MAX         ALLOWED_RANGES        0:1048575
set_parameter_property  OUTPUT_DATA_TYPE_MAX         HDL_PARAMETER         false
set_parameter_property  OUTPUT_DATA_TYPE_MAX         AFFECTS_ELABORATION   true

add_parameter           COEFFICIENT_SIGNED           INTEGER               1
set_parameter_property  COEFFICIENT_SIGNED           DISPLAY_NAME          "Signed"
set_parameter_property  COEFFICIENT_SIGNED           DESCRIPTION           "Turn on to set the fixed point type used to store the constant coefficients as having a sign bit."
set_parameter_property  COEFFICIENT_SIGNED           ALLOWED_RANGES        0:1
set_parameter_property  COEFFICIENT_SIGNED           DISPLAY_HINT          BOOLEAN
set_parameter_property  COEFFICIENT_SIGNED           HDL_PARAMETER         false
set_parameter_property  COEFFICIENT_SIGNED           AFFECTS_ELABORATION   true

add_parameter           COEFFICIENT_INT_BITS         INTEGER               1
set_parameter_property  COEFFICIENT_INT_BITS         DISPLAY_NAME          "Integer bits"
set_parameter_property  COEFFICIENT_INT_BITS         DESCRIPTION           "Specifies the number of integer bits for the fixed point type used to store the constant coefficients."
set_parameter_property  COEFFICIENT_INT_BITS         ALLOWED_RANGES        0:16
set_parameter_property  COEFFICIENT_INT_BITS         HDL_PARAMETER         false
set_parameter_property  COEFFICIENT_INT_BITS         AFFECTS_ELABORATION   true

add_parameter           SUMMAND_SIGNED               INTEGER               0
set_parameter_property  SUMMAND_SIGNED               DISPLAY_NAME          "Signed"
set_parameter_property  SUMMAND_SIGNED               DESCRIPTION           "Turn on to set the fixed point type used to store the constant summands as having a sign bit."
set_parameter_property  SUMMAND_SIGNED               ALLOWED_RANGES        0:1
set_parameter_property  SUMMAND_SIGNED               DISPLAY_HINT          BOOLEAN
set_parameter_property  SUMMAND_SIGNED               HDL_PARAMETER         false
set_parameter_property  SUMMAND_SIGNED               AFFECTS_ELABORATION   true

add_parameter           SUMMAND_INT_BITS             INTEGER               10
set_parameter_property  SUMMAND_INT_BITS             DISPLAY_NAME          "Integer bits"
set_parameter_property  SUMMAND_INT_BITS             DESCRIPTION           "Specifies the number of integer bits for the fixed point type used to store the constant summands."
set_parameter_property  SUMMAND_INT_BITS             ALLOWED_RANGES        0:22
set_parameter_property  SUMMAND_INT_BITS             HDL_PARAMETER         false
set_parameter_property  SUMMAND_INT_BITS             AFFECTS_ELABORATION   true

add_parameter           COEF_SUM_FRACTION_BITS       INTEGER               8
set_parameter_property  COEF_SUM_FRACTION_BITS       DISPLAY_NAME          "Coefficient and summand fractional bits"
set_parameter_property  COEF_SUM_FRACTION_BITS       DESCRIPTION           "Specifies the number of fraction bits for the fixed point type used to store the coefficients and summands."
set_parameter_property  COEF_SUM_FRACTION_BITS       ALLOWED_RANGES        0:31
set_parameter_property  COEF_SUM_FRACTION_BITS       HDL_PARAMETER         false
set_parameter_property  COEF_SUM_FRACTION_BITS       AFFECTS_ELABORATION   true

add_parameter           MOVE_BINARY_POINT_RIGHT      INTEGER               0
set_parameter_property  MOVE_BINARY_POINT_RIGHT      DISPLAY_NAME          "Move binary point right"
set_parameter_property  MOVE_BINARY_POINT_RIGHT      DESCRIPTION           "Specify the number of places to move the binary point."
set_parameter_property  MOVE_BINARY_POINT_RIGHT      ALLOWED_RANGES        -16:16
set_parameter_property  MOVE_BINARY_POINT_RIGHT      HDL_PARAMETER         false
set_parameter_property  MOVE_BINARY_POINT_RIGHT      AFFECTS_ELABORATION   true

add_parameter           REMOVE_FRACTION_METHOD       INTEGER               1
set_parameter_property  REMOVE_FRACTION_METHOD       DISPLAY_NAME          "Remove fraction bit by"
set_parameter_property  REMOVE_FRACTION_METHOD       DESCRIPTION           "Specifies the rounding method used to remove fraction bits"
set_parameter_property  REMOVE_FRACTION_METHOD       ALLOWED_RANGES        {"1:Round values - Half up" "2:Round values - Half even" "3:Truncate values to integer"}
set_parameter_property  REMOVE_FRACTION_METHOD       HDL_PARAMETER         false
set_parameter_property  REMOVE_FRACTION_METHOD       AFFECTS_ELABORATION   true

add_parameter           SIGN_TO_UNSIGN_METHOD        INTEGER               0
set_parameter_property  SIGN_TO_UNSIGN_METHOD        DISPLAY_NAME          "Convert from signed to unsigned by"
set_parameter_property  SIGN_TO_UNSIGN_METHOD        DESCRIPTION           "Specifies the method used to convert output results to unsigned values"
set_parameter_property  SIGN_TO_UNSIGN_METHOD        ALLOWED_RANGES        {"0:Saturating to minimum value at stage 4" "1:Replacing negative with absolute values"}
set_parameter_property  SIGN_TO_UNSIGN_METHOD        HDL_PARAMETER         false
set_parameter_property  SIGN_TO_UNSIGN_METHOD        AFFECTS_ELABORATION   true
set_parameter_property  SIGN_TO_UNSIGN_METHOD        VISIBLE               false

add_parameter           PIPELINE_DATA_OUTPUT         INTEGER               1
set_parameter_property  PIPELINE_DATA_OUTPUT         DISPLAY_NAME          "Add extra pipelining registers"
set_parameter_property  PIPELINE_DATA_OUTPUT         DESCRIPTION           "Selecting this option adds extra pipeline stage registers to the data path"
set_parameter_property  PIPELINE_DATA_OUTPUT         ALLOWED_RANGES        0:1
set_parameter_property  PIPELINE_DATA_OUTPUT         DISPLAY_HINT          boolean
set_parameter_property  PIPELINE_DATA_OUTPUT         HDL_PARAMETER         false
set_parameter_property  PIPELINE_DATA_OUTPUT         AFFECTS_ELABORATION   true

add_user_packet_support_parameters PASSTHROUGH 0
add_conversion_mode_parameters
set_parameter_property  USER_PACKET_SUPPORT          HDL_PARAMETER         false
set_parameter_property  CONVERSION_MODE              HDL_PARAMETER         false

add_runtime_control_parameters 1
set_parameter_property  RUNTIME_CONTROL              DESCRIPTION           "Allows to dynamically change coefficent values at run-time"
set_parameter_property  RUNTIME_CONTROL              HDL_PARAMETER         false
set_parameter_property  LIMITED_READBACK             HDL_PARAMETER         false



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Derived parameters                                                                           --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_device_family_parameters

set debug_gui false;

foreach name {A B C S} {
    foreach id {0 1 2} {
        add_parameter           COEFFICIENT_$name$id         INTEGER
        set_parameter_property  COEFFICIENT_$name$id         DISPLAY_NAME          "COEFFICIENT_$name$id"
        set_parameter_property  COEFFICIENT_$name$id         ALLOWED_RANGES        -2147483648:2147483647
        set_parameter_property  COEFFICIENT_$name$id         HDL_PARAMETER         false
        set_parameter_property  COEFFICIENT_$name$id         AFFECTS_ELABORATION   true
        set_parameter_property  COEFFICIENT_$name$id         DERIVED               true
        set_parameter_property  COEFFICIENT_$name$id         VISIBLE               $debug_gui
    }
}

# These are GUI only parameters. Tolerate an exception to the rule that all parameters are uppercase
foreach name {output_s1 output_s2} {
    add_parameter           min_$name                FLOAT
    set_parameter_property  min_$name                DISPLAY_NAME          "min_$name"
    set_parameter_property  min_$name                DERIVED               true
    set_parameter_property  min_$name                VISIBLE               $debug_gui
    add_parameter           max_$name                FLOAT
    set_parameter_property  max_$name                DISPLAY_NAME          "max_$name"
    set_parameter_property  max_$name                DERIVED               true
    set_parameter_property  max_$name                VISIBLE               $debug_gui
}
foreach name {output_s3 output_s4} {
    add_parameter           min_$name                INTEGER
    set_parameter_property  min_$name                DISPLAY_NAME          "min_$name"
    set_parameter_property  min_$name                DERIVED               true
    set_parameter_property  min_$name                VISIBLE               $debug_gui
    add_parameter           max_$name                INTEGER
    set_parameter_property  max_$name                DISPLAY_NAME          "max_$name"
    set_parameter_property  max_$name                DERIVED               true
    set_parameter_property  max_$name                VISIBLE               $debug_gui
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set_module_property HELPER_JAR csc_helper.jar

# --------------------------------------------------------------------------------------------------
# -- Structure the two tabs                                                                       --
# --------------------------------------------------------------------------------------------------

# "General" and "Operands" tabs
add_display_item  ""          "General"                                          GROUP     tab
add_display_item  ""          "Operands"                                         GROUP     tab

add_display_item  "General"   "Video Data Format"                                GROUP
add_display_item  "General"   "Input Data Type"                                  GROUP
add_display_item  "General"   "Output Data Type"                                 GROUP
add_display_item  "General"   "User Packet Support"                              GROUP
add_display_item  "General"   "Run-time Control"                                 GROUP

add_display_item  "Operands"   "Properties"                                      GROUP
add_display_item  "Operands"   "Coefficients and Summand Table"                  GROUP
add_display_item  "Operands"   "Table"                                           GROUP
add_display_item  "Operands"   "Result to output data type conversion procedure" GROUP

# --------------------------------------------------------------------------------------------------
# -- General tab content                                                                          --
# --------------------------------------------------------------------------------------------------
add_display_item  "Video Data Format"        MAX_IN_WIDTH                  PARAMETER
add_display_item  "Video Data Format"        MAX_IN_HEIGHT                 PARAMETER
add_display_item  "Video Data Format"        NUMBER_OF_COLOR_PLANES        PARAMETER
add_display_item  "Video Data Format"        COLOR_PLANES_ARE_IN_PARALLEL  PARAMETER
add_display_item  "Video Data Format"        PIXELS_IN_PARALLEL            PARAMETER

add_display_item  "Input Data Type"          INPUT_BITS_PER_SYMBOL         PARAMETER
add_display_item  "Input Data Type"          INPUT_DATA_TYPE_SIGNED        PARAMETER
add_display_item  "Input Data Type"          INPUT_DATA_TYPE_GUARD_BAND    PARAMETER
add_display_item  "Input Data Type"          INPUT_DATA_TYPE_MAX           PARAMETER
add_display_item  "Input Data Type"          INPUT_DATA_TYPE_MIN           PARAMETER

add_display_item  "Output Data Type"         OUTPUT_BITS_PER_SYMBOL        PARAMETER
add_display_item  "Output Data Type"         OUTPUT_DATA_TYPE_SIGNED       PARAMETER
add_display_item  "Output Data Type"         OUTPUT_DATA_TYPE_GUARD_BAND   PARAMETER
add_display_item  "Output Data Type"         OUTPUT_DATA_TYPE_MAX          PARAMETER
add_display_item  "Output Data Type"         OUTPUT_DATA_TYPE_MIN          PARAMETER

add_display_item  "User Packet Support"      USER_PACKET_SUPPORT           PARAMETER
add_display_item  "User Packet Support"      CONVERSION_MODE               PARAMETER

add_display_item  "Run-time Control"         RUNTIME_CONTROL               PARAMETER
add_display_item  "Run-time Control"         LIMITED_READBACK              PARAMETER
add_display_item  "Run-time Control"         PIPELINE_DATA_OUTPUT          PARAMETER

# --------------------------------------------------------------------------------------------------
# -- Operand tab content                                                                          --
# --------------------------------------------------------------------------------------------------

add_display_item  "Properties"               COEF_SUM_FRACTION_BITS        PARAMETER
add_display_item  "Properties" "Coefficients Precision"                          GROUP
add_display_item  "Properties" "Summand Precision"                               GROUP

# Debug only
foreach name {A B C} {
    foreach id {0 1 2} {
        add_display_item  "Coefficients Precision"   COEFFICIENT_$name$id          PARAMETER
    }
}
add_display_item  "Coefficients Precision"   COEFFICIENT_SIGNED            PARAMETER
add_display_item  "Coefficients Precision"   COEFFICIENT_INT_BITS          PARAMETER

add_display_item  "Coefficients Precision"   coeff_prec_l1                 TEXT         "The total coefficient length is N bits"

# Debug only
foreach id {0 1 2} {
    add_display_item  "Summand Precision"         COEFFICIENT_S$id            PARAMETER
}
add_display_item  "Summand Precision"         SUMMAND_SIGNED               PARAMETER
add_display_item  "Summand Precision"         SUMMAND_INT_BITS             PARAMETER

add_display_item  "Summand Precision"         summand_prec_l1              TEXT         "The total summand length is N bits"


add_display_item  "Coefficients and Summand Table"   coeff_desc_l1         TEXT         "din and dout refer to the input and output channels respectively."
add_display_item  "Coefficients and Summand Table"   coeff_desc_l4         TEXT         "dout_0 = (A0 * din_0) + (B0 * din_1)+ (C0 * din_2) + S0"
add_display_item  "Coefficients and Summand Table"   coeff_desc_l5         TEXT         "dout_1 = (A1 * din_0) + (B1 * din_1)+ (C1 * din_2) + S1"
add_display_item  "Coefficients and Summand Table"   coeff_desc_l6         TEXT         "dout_2 = (A2 * din_0) + (B2 * din_1)+ (C2 * din_2) + S2"
add_display_item  "Coefficients and Summand Table"   coeff_desc_l2         TEXT         "(din_# and dout_# are sent in order #=0,1,2.)"


add_display_item  "Result to output data type conversion procedure"   conv_desc_l1               TEXT        "1) Result scaling: The results are in the range X to Y (to 2 decimal places)"
add_display_item  "Result to output data type conversion procedure"   conv_desc_l2               TEXT        "The results have ? fractional bits."
add_display_item  "Result to output data type conversion procedure"   MOVE_BINARY_POINT_RIGHT    PARAMETER
add_display_item  "Result to output data type conversion procedure"   conv_desc_l3               TEXT        "The scaled results have ? fractional bits."
add_display_item  "Result to output data type conversion procedure"   conv_desc_l4               TEXT        "2) Integer conversion: The scaled results are in the range X' to Y' (to 2 decimal places)"
add_display_item  "Result to output data type conversion procedure"   REMOVE_FRACTION_METHOD     PARAMETER
add_display_item  "Result to output data type conversion procedure"   conv_desc_l5               TEXT        "3) Sign conversion: The scaled integer results are in the range X'' to Y'' "
add_display_item  "Result to output data type conversion procedure"   conv_desc_l6               TEXT        "The selected output data type is ?"
add_display_item  "Result to output data type conversion procedure"   SIGN_TO_UNSIGN_METHOD      PARAMETER
add_display_item  "Result to output data type conversion procedure"   conv_desc_l7               TEXT        "4) Range saturation: The scaled, integer, sign handled results are in the range X''' to Y'''"
add_display_item  "Result to output data type conversion procedure"   conv_desc_l8               TEXT        "The selected output data type has a range of ? to ?"
add_display_item  "Result to output data type conversion procedure"   conv_desc_l9               TEXT        "The results will be saturated to the minimum and maximum values of the output data type"

#Debug only
foreach name {output_s1 output_s2 output_s3 output_s4} {
    add_display_item  "Result to output data type conversion procedure"   min_$name                     PARAMETER
    add_display_item  "Result to output data type conversion procedure"   max_$name                     PARAMETER
}


# The Table GUI element is handled by the java helper
set jar_path              "csc_helper.jar"
set widget_name           "coeff_summands_table"
add_display_item          "Table"             $widget_name         PARAMETER
set_display_item_property "Table"             WIDGET               [list $jar_path $widget_name]

set_display_item_property "Table"             WIDGET_PARAMETER_MAP {
    INPUT_BITS_PER_SYMBOL     INPUT_BITS_PER_SYMBOL
    INPUT_DATA_TYPE_SIGNED    INPUT_DATA_TYPE_SIGNED
    OUTPUT_DATA_TYPE_SIGNED   OUTPUT_DATA_TYPE_SIGNED
    REQ_FCOEFF_A0             REQ_FCOEFF_A0
    REQ_FCOEFF_B0             REQ_FCOEFF_B0
    REQ_FCOEFF_C0             REQ_FCOEFF_C0
    REQ_FCOEFF_S0             REQ_FCOEFF_S0
    REQ_FCOEFF_A1             REQ_FCOEFF_A1
    REQ_FCOEFF_B1             REQ_FCOEFF_B1
    REQ_FCOEFF_C1             REQ_FCOEFF_C1
    REQ_FCOEFF_S1             REQ_FCOEFF_S1
    REQ_FCOEFF_A2             REQ_FCOEFF_A2
    REQ_FCOEFF_B2             REQ_FCOEFF_B2
    REQ_FCOEFF_C2             REQ_FCOEFF_C2
    REQ_FCOEFF_S2             REQ_FCOEFF_S2
    COEFFICIENT_SIGNED        COEFFICIENT_SIGNED
    COEFFICIENT_INT_BITS      COEFFICIENT_INT_BITS
    SUMMAND_SIGNED            SUMMAND_SIGNED
    SUMMAND_INT_BITS          SUMMAND_INT_BITS
    COEF_SUM_FRACTION_BITS    COEF_SUM_FRACTION_BITS
    MOVE_BINARY_POINT_RIGHT   MOVE_BINARY_POINT_RIGHT
    REMOVE_FRACTION_METHOD    REMOVE_FRACTION_METHOD
    SIGN_TO_UNSIGN_METHOD     SIGN_TO_UNSIGN_METHOD
    COEFFICIENT_A0            COEFFICIENT_A0
    COEFFICIENT_B0            COEFFICIENT_B0
    COEFFICIENT_C0            COEFFICIENT_C0
    COEFFICIENT_S0            COEFFICIENT_S0
    COEFFICIENT_A1            COEFFICIENT_A1
    COEFFICIENT_B1            COEFFICIENT_B1
    COEFFICIENT_C1            COEFFICIENT_C1
    COEFFICIENT_S1            COEFFICIENT_S1
    COEFFICIENT_A2            COEFFICIENT_A2
    COEFFICIENT_B2            COEFFICIENT_B2
    COEFFICIENT_C2            COEFFICIENT_C2
    COEFFICIENT_S2            COEFFICIENT_S2
    min_output_s1             min_output_s1
    max_output_s1             max_output_s1
    min_output_s2             min_output_s2
    max_output_s2             max_output_s2
    min_output_s3             min_output_s3
    max_output_s3             max_output_s3
    min_output_s4             min_output_s4
    max_output_s4             max_output_s4
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Upgrade callback                                                                             --
# -- ACDS version upgrade/downgrade                                                               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc upgrade_cb {ip_core_type version parameters} {
    foreach { name value } $parameters {
        switch -regexp -- $name {
            MAX_IN_WIDTH           {
                # Do nothing, MAX_IN_WIDTH removed
            }
            MAX_IN_HEIGHT          {
                # Do nothing, MAX_IN_HEIGHT removed
            }
            BITS_PER_SYMBOL        {
                # Do nothing, BITS_PER_SYMBOL removed
            }
            SRC_WIDTH              {
                # Do nothing, SRC_WIDTH removed
            }
            DST_WIDTH              {
                # Do nothing, DST_WIDTH removed
            }
            CONTEXT_WIDTH          {
                # Do nothing, CONTEXT_WIDTH removed
            }
            TASK_WIDTH             {
                # Do nothing, TASK_WIDTH removed
            }
            DATA_SRC_WIDTH         {
                # Do nothing, DATA_SRC_WIDTH removed
            }
            DATA_SRC_ADDRESS         {
                # Do nothing, DATA_SRC_ADDRESS removed
            }
            COLOR_MODEL_CONVERSION {
                # Do nothing, COLOR_MODEL_CONVERSION removed
            }
            COEFFICIENT_([ABCS][012])     {
                # Do nothing, redefined as derived parameters
            }
            min_output {
                # Do nothing, redefined as derived parameters
            }
            max_output {
                # Do nothing, redefined as derived parameters
            }
            min_output_s([123]) {
                # Do nothing, redefined as derived parameters
            }
            max_output_s([123]) {
                # Do nothing, redefined as derived parameters
            }
            AUTO_.* {
                # Do nothing, qsys auto-generated parameters
            }
            coeff([ABCS][012])     {
                set    new_param_name     "REQ_FCOEFF_"
                append new_param_name     [string range $name 5 6]
                set_parameter_value $new_param_name     $value
            }
            default                {
                set_parameter_value $name $value
            }
        }
    }
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc validation_cb {} {
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set input_bits_per_symbol            [get_parameter_value INPUT_BITS_PER_SYMBOL]
    set input_data_type_signed           0
    set input_data_type_guard_band       [get_parameter_value INPUT_DATA_TYPE_GUARD_BAND]
    set input_data_type_min              [get_parameter_value INPUT_DATA_TYPE_MIN]
    set input_data_type_max              [get_parameter_value INPUT_DATA_TYPE_MAX]
    set output_bits_per_symbol           [get_parameter_value OUTPUT_BITS_PER_SYMBOL]
    set output_data_type_signed          0
    set output_data_type_guard_band      [get_parameter_value OUTPUT_DATA_TYPE_GUARD_BAND]
    set output_data_type_min             [get_parameter_value OUTPUT_DATA_TYPE_MIN]
    set output_data_type_max             [get_parameter_value OUTPUT_DATA_TYPE_MAX]
    set coefficient_signed               [get_parameter_value COEFFICIENT_SIGNED]
    set coefficient_int_bits             [get_parameter_value COEFFICIENT_INT_BITS]
    set summand_signed                   [get_parameter_value SUMMAND_SIGNED]
    set summand_int_bits                 [get_parameter_value SUMMAND_INT_BITS]
    set frac_bits                        [get_parameter_value COEF_SUM_FRACTION_BITS]
    set move_binary_point_right          [get_parameter_value MOVE_BINARY_POINT_RIGHT]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameter
    # --------------------------------------------------------------------------------------------------
    if {$input_data_type_signed} {
        set input_min_limit  [expr {- pow(2, $input_bits_per_symbol - 1)}]
        set input_max_limit  [expr {pow(2, $input_bits_per_symbol - 1) - 1}]
    } else {
        set input_min_limit  0
        set input_max_limit  [expr {pow(2, $input_bits_per_symbol) - 1}]
    }
    if {$output_data_type_signed} {
        set output_min_limit [expr {- pow(2, $output_bits_per_symbol - 1)}]
        set output_max_limit [expr {pow(2, $output_bits_per_symbol - 1) - 1}]
    } else {
        set output_min_limit 0
        set output_max_limit [expr {pow(2, $output_bits_per_symbol) - 1}]
    }
    set out_min           $output_min_limit
    set out_max           $output_max_limit
    if {$output_data_type_guard_band == 1} {
        set out_min           [max $output_min_limit $output_data_type_min]
        set out_max           [min $output_max_limit $output_data_type_max]
    }
    set diff                             [expr $output_bits_per_symbol - $input_bits_per_symbol]
    set new_frac_bits                    [max [expr {$frac_bits - $move_binary_point_right}] 0]
    set coeff_val_bits                   [expr $coefficient_int_bits + $frac_bits]
    set sum_val_bits                     [expr $summand_int_bits + $frac_bits]
    set coeff_bits                       [expr $coefficient_signed + $coeff_val_bits]
    set sum_bits                         [expr $summand_signed + $sum_val_bits]
    set signed_processing                [expr $input_data_type_signed || $coefficient_signed || $summand_signed]


    # initial results range before stage 1
    set min_val_s1                       [get_parameter_value min_output_s1]
    set max_val_s1                       [get_parameter_value max_output_s1]

    # range after stage 1
    set min_val_s2                       [get_parameter_value min_output_s2]
    set max_val_s2                       [get_parameter_value max_output_s2]

    # range after stage 2
    set min_val_s3                       [get_parameter_value min_output_s3]
    set max_val_s3                       [get_parameter_value max_output_s3]

    # range after stage 3
    set min_val_s4                       [get_parameter_value min_output_s4]
    set max_val_s4                       [get_parameter_value max_output_s4]


    # --------------------------------------------------------------------------------------------------
    # -- Validation                                                                                   --
    # --------------------------------------------------------------------------------------------------

    # Use common validation features for common parameters
    pip_validation_callback_helper
    conversion_mode_validation_callback_helper
    runtime_control_validation_callback_helper

    # Gray out uneditable parameters
    set_parameter_property  INPUT_DATA_TYPE_MIN          ENABLED               [expr $input_data_type_guard_band == 1]
    set_parameter_property  INPUT_DATA_TYPE_MAX          ENABLED               [expr $input_data_type_guard_band == 1]
    set_parameter_property  OUTPUT_DATA_TYPE_MIN         ENABLED               [expr $output_data_type_guard_band == 1]
    set_parameter_property  OUTPUT_DATA_TYPE_MAX         ENABLED               [expr $output_data_type_guard_band == 1]
    set_parameter_property  REMOVE_FRACTION_METHOD       ENABLED               [expr $new_frac_bits > 0]
    if { [expr $signed_processing == 1] && [expr $output_data_type_signed == 0] } {
        set_parameter_property  SIGN_TO_UNSIGN_METHOD        ENABLED               true
    } else {
        set_parameter_property  SIGN_TO_UNSIGN_METHOD        ENABLED               false
    }

    # Checking user-specified guard bands if enabled
    if { [expr $input_data_type_guard_band == 1] && [expr $input_data_type_min < $input_min_limit] } {
        send_message Warning "Input guard band minimum value $input_data_type_min is not within the input range \[$input_min_limit:$input_max_limit\]"
    }
    if { [expr $input_data_type_guard_band == 1] && [expr $input_max_limit < $input_data_type_max] } {
        send_message Warning "Input guard band maximum value $input_data_type_max is not within the input range \[$input_min_limit:$input_max_limit\]"
    }
    if { [expr $input_data_type_guard_band == 1] && [expr $input_data_type_min > $input_data_type_max] } {
        send_message Error "Input guard band maximum value $input_data_type_max is smaller than the input guard band minimum value $input_data_type_min"
    }
    if { [expr $output_data_type_guard_band == 1] && [expr $output_data_type_min < $output_min_limit] } {
        send_message Warning "Output guard band minimum value $output_data_type_min is not within the output range \[$output_min_limit:$output_max_limit\]"
    }
    if { [expr $output_data_type_guard_band == 1] && [expr $output_max_limit < $output_data_type_max] } {
        send_message Warning "Output guard band maximum value $output_data_type_max is not within the output range \[$output_min_limit:$output_max_limit\]"
    }
    if { [expr $output_data_type_guard_band == 1] && [expr $output_data_type_min > $output_data_type_max] } {
        send_message Error "Output guard band maximum value $output_data_type_max is smaller than the output guard band minimum value $output_data_type_min"
    }

    # Information messages
    if { [expr $diff != 0] && [expr $diff != $move_binary_point_right] } {
        send_message Info "Predefined conversions are invalid when input and output bit depths differ. Consider including a results' binary point shift right by $diff place(s)."
    }

    if { [expr $coeff_val_bits > 31] } {
        send_message Error "Total coefficient size (sign bit excluded) cannot excess 31 bits"
    }
    if { [expr $sum_val_bits > 31] } {
        send_message Error "Total summand size (sign bit excluded) cannot excess 31 bits"
    }

    set_display_item_property   coeff_prec_l1             TEXT        "The total coefficient length (sign bit included) is $coeff_bits bits."
    set_display_item_property   summand_prec_l1           TEXT        "The total summand length (sign bit included) is $sum_bits bits."


    # Result to Output Data Type Conversion (update GUI text)

    # Intended format is:
    # "1) Result scaling: The results are in the range X to Y (to 2 decimal places)"
    # "The results have ? fractional bits."
    # "The scaled results have ? fractional bits."
    # "2) Integer conversion: The scaled results are in the range X' to Y' (to 2 decimal places)"
    # "3) Sign conversion: The scaled integer results are in the range X'' to Y'' "
    # "The selected output data type is ?"
    # "4) Range saturation: The scaled, integer, sign handled results are in the range X''' to Y'''"
    # "The selected output data type has a range of ? to ?"
    # "The results will be saturated to the minimum and maximum values of the output data type"
    set_display_item_property   conv_desc_l1              TEXT "1) Result scaling: The results are in the range $min_val_s1 to $max_val_s1 (to 2 decimal places)"
    set_display_item_property   conv_desc_l2              TEXT "The results have $frac_bits fractional bits."
    set_display_item_property   conv_desc_l3              TEXT "The scaled results have $new_frac_bits fractional bits."
    set_display_item_property   conv_desc_l4              TEXT "2) The scaled results are in the range $min_val_s2 to $max_val_s2 (to 2 decimal places)"
    set_display_item_property   conv_desc_l5              TEXT "3) Sign conversion: The scaled integer results are in the range $min_val_s3 to $max_val_s3"
    if {$output_data_type_signed == 1} {
        set_display_item_property   conv_desc_l6          TEXT "The selected output data type is signed"
    } else {
        set_display_item_property   conv_desc_l6          TEXT "The selected output data type is unsigned"
    }
    set_display_item_property   conv_desc_l7              TEXT "4) Range saturation: The scaled, integer, sign handled results are in the range $min_val_s4 to $max_val_s4"

    if {$output_data_type_guard_band == 1} {
        set_display_item_property   conv_desc_l8          TEXT "The selected output data type has a range of $out_min to $out_max"
    } else {
        set_display_item_property   conv_desc_l8          TEXT "No range constraints selected for output data type. Using $out_min to $out_max"
    }
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                        --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc composition_cb {} {
    global isVersion
    global acdsVersion
    global vib_vob_removal

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set input_bits_per_symbol                [get_parameter_value INPUT_BITS_PER_SYMBOL]
    set output_bits_per_symbol               [get_parameter_value OUTPUT_BITS_PER_SYMBOL]
    set number_of_color_planes               3
    set color_planes_are_in_parallel         [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel                   [get_parameter_value PIXELS_IN_PARALLEL]
    set input_data_type_signed               0
    set input_data_type_guard_band           [get_parameter_value INPUT_DATA_TYPE_GUARD_BAND]
    set input_data_type_min                  [get_parameter_value INPUT_DATA_TYPE_MIN]
    set input_data_type_max                  [get_parameter_value INPUT_DATA_TYPE_MAX]
    set output_data_type_signed              0
    set output_data_type_guard_band          [get_parameter_value OUTPUT_DATA_TYPE_GUARD_BAND]
    set output_data_type_min                 [get_parameter_value OUTPUT_DATA_TYPE_MIN]
    set output_data_type_max                 [get_parameter_value OUTPUT_DATA_TYPE_MAX]
    set coefficient_signed                   [get_parameter_value COEFFICIENT_SIGNED]
    set coefficient_int_bits                 [get_parameter_value COEFFICIENT_INT_BITS]
    set summand_signed                       [get_parameter_value SUMMAND_SIGNED]
    set summand_int_bits                     [get_parameter_value SUMMAND_INT_BITS]
    set coef_sum_fraction_bits               [get_parameter_value COEF_SUM_FRACTION_BITS]
    set move_binary_point_right              [get_parameter_value MOVE_BINARY_POINT_RIGHT]
    set remove_fraction_method               [get_parameter_value REMOVE_FRACTION_METHOD]
    set sign_to_unsign_method                [get_parameter_value SIGN_TO_UNSIGN_METHOD]

    set pipeline_data_output                 [get_parameter_value PIPELINE_DATA_OUTPUT]
    set user_packet_support                  [get_parameter_value USER_PACKET_SUPPORT]
    set conversion_mode                      [get_parameter_value CONVERSION_MODE]
    set runtime_control                      [get_parameter_value RUNTIME_CONTROL]
    set limited_readback                     [get_parameter_value LIMITED_READBACK]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    set symb_per_pixel           [expr {$color_planes_are_in_parallel > 0} ? $number_of_color_planes : 1]
    set bits_per_pixel_in        [expr $input_bits_per_symbol * $symb_per_pixel ]
    set bits_per_pixel_out       [expr $output_bits_per_symbol * $symb_per_pixel ]
    set video_data_width_in      [expr $bits_per_pixel_in * $pixels_in_parallel]
    set video_data_width_out     [expr $bits_per_pixel_out * $pixels_in_parallel]
    set user_packet_passthrough  [expr [string equal $user_packet_support "PASSTHROUGH"]]
    set user_packet_enabled      [expr ![string equal $user_packet_support "NONE_ALLOWED"]]
    set scheduler_enabled        [expr {$user_packet_enabled || $runtime_control}]
    set coeff_width              [max [expr $summand_signed+$summand_int_bits+$coef_sum_fraction_bits] [expr $coefficient_signed+$coefficient_int_bits+$coef_sum_fraction_bits] ]
    if { $remove_fraction_method == 1 } {
        set rounding_method   ROUND_HALF_UP
    } else {
       if { $remove_fraction_method == 2 } {
          set rounding_method   ROUND_HALF_EVEN
       } else {
          set rounding_method   TRUNCATE
       }
    }

    # --------------------------------------------------------------------------------------------------
    # -- Java helper call                                                                             --
    # --------------------------------------------------------------------------------------------------
    # Derived parameters set in the edit stage are not persistent. Request the coefficients from the helper once again
    set source_params(INPUT_BITS_PER_SYMBOL)       $input_bits_per_symbol
    set source_params(INPUT_DATA_TYPE_SIGNED)      $input_data_type_signed
    set source_params(OUTPUT_DATA_TYPE_SIGNED)     $output_data_type_signed
    foreach name {A B C S} {
        foreach id {0 1 2} {
            set source_params(REQ_FCOEFF_$name$id)               [get_parameter_value REQ_FCOEFF_$name$id]
        }
    }
    set source_params(COEFFICIENT_SIGNED)          $coefficient_signed
    set source_params(COEFFICIENT_INT_BITS)        $coefficient_int_bits
    set source_params(SUMMAND_SIGNED)              $summand_signed
    set source_params(SUMMAND_INT_BITS)            $summand_int_bits
    set source_params(COEF_SUM_FRACTION_BITS)      $coef_sum_fraction_bits
    set source_params(MOVE_BINARY_POINT_RIGHT)     $move_binary_point_right
    set source_params(REMOVE_FRACTION_METHOD)      $remove_fraction_method
    set source_params(SIGN_TO_UNSIGN_METHOD)       $sign_to_unsign_method

    array set derived_params     [call_helper computeDerivedParams [array get source_params]]


    # The chain of components to compose :
    add_instance   av_st_clk_bridge     altera_clock_bridge                $acdsVersion
    add_instance   av_st_reset_bridge   altera_reset_bridge                $acdsVersion

    add_instance   csc_core             alt_vip_csc_alg_core               $isVersion

    if {$vib_vob_removal == 0} {
        add_instance   video_out            alt_vip_video_output_bridge        $isVersion
        add_instance   video_in_resp        alt_vip_video_input_bridge_resp    $isVersion
    }

    if { $user_packet_enabled } {
        add_instance   video_in_cmd        alt_vip_video_input_bridge_cmd      $isVersion
    }
    if { $scheduler_enabled } {
        add_instance   scheduler            alt_vip_csc_scheduler              $isVersion
    }
    if { $user_packet_passthrough } {
        add_instance   user_packet_demux    alt_vip_packet_demux               $isVersion
        add_instance   bps_converter        alt_vip_bps_converter              $isVersion
        add_instance   user_packet_mux      alt_vip_packet_mux                 $isVersion
    }
    if { $input_data_type_guard_band } {
        add_instance   guard_band_in        alt_vip_guard_bands_alg_core       $isVersion
    }
    if { $output_data_type_guard_band } {
        add_instance   guard_band_out       alt_vip_guard_bands_alg_core       $isVersion
    }

    if {$vib_vob_removal == 0} {
       # Vib response parameterization
       set_instance_parameter_value   video_in_resp       BITS_PER_SYMBOL                $input_bits_per_symbol
       set_instance_parameter_value   video_in_resp       NUMBER_OF_COLOR_PLANES         $number_of_color_planes
       set_instance_parameter_value   video_in_resp       COLOR_PLANES_ARE_IN_PARALLEL   $color_planes_are_in_parallel
       set_instance_parameter_value   video_in_resp       PIXELS_IN_PARALLEL             $pixels_in_parallel
       set_instance_parameter_value   video_in_resp       DEFAULT_LINE_LENGTH            1920
       set_instance_parameter_value   video_in_resp       VIB_MODE                       LITE
       set_instance_parameter_value   video_in_resp       ENABLE_RESOLUTION_CHECK        0
       set_instance_parameter_value   video_in_resp       VIDEO_PROTOCOL_NO              1
       set_instance_parameter_value   video_in_resp       SRC_WIDTH                      8
       set_instance_parameter_value   video_in_resp       DST_WIDTH                      8
       set_instance_parameter_value   video_in_resp       CONTEXT_WIDTH                  8
       set_instance_parameter_value   video_in_resp       TASK_WIDTH                     8
       set_instance_parameter_value   video_in_resp       RESP_SRC_ADDRESS               0
       set_instance_parameter_value   video_in_resp       RESP_DST_ADDRESS               0
       set_instance_parameter_value   video_in_resp       DATA_SRC_ADDRESS               0
       set_instance_parameter_value   video_in_resp       PIPELINE_READY                 $pipeline_data_output
       set_instance_parameter_value   video_in_resp       MULTI_CONTEXT_SUPPORT          0
       set_instance_parameter_value   video_in_resp       READY_LATENCY_1                1

       # VOB parameterization
       set_instance_parameter_value   video_out           BITS_PER_SYMBOL                $output_bits_per_symbol
       set_instance_parameter_value   video_out           NUMBER_OF_COLOR_PLANES         $number_of_color_planes
       set_instance_parameter_value   video_out           COLOR_PLANES_ARE_IN_PARALLEL   $color_planes_are_in_parallel
       set_instance_parameter_value   video_out           PIXELS_IN_PARALLEL             $pixels_in_parallel
       set_instance_parameter_value   video_out           VIDEO_PROTOCOL_NO              1
       set_instance_parameter_value   video_out           SRC_WIDTH                      8
       set_instance_parameter_value   video_out           DST_WIDTH                      8
       set_instance_parameter_value   video_out           CONTEXT_WIDTH                  8
       set_instance_parameter_value   video_out           TASK_WIDTH                     8
       set_instance_parameter_value   video_out           SOP_PRE_ALIGNED                1
       set_instance_parameter_value   video_out           NO_CONCATENATION               1
       set_instance_parameter_value   video_out           LOW_LATENCY_COMMAND_MODE       0
       set_instance_parameter_value   video_out           MULTI_CONTEXT_SUPPORT          0
       set_instance_parameter_value   video_out           PIPELINE_READY                 $pipeline_data_output
    }

    # Vib command parameterization
    if { $user_packet_enabled } {
        set_instance_parameter_value   video_in_cmd        BITS_PER_SYMBOL                $input_bits_per_symbol
        set_instance_parameter_value   video_in_cmd        NUMBER_OF_COLOR_PLANES         $number_of_color_planes
        set_instance_parameter_value   video_in_cmd        COLOR_PLANES_ARE_IN_PARALLEL   $color_planes_are_in_parallel
        set_instance_parameter_value   video_in_cmd        PIXELS_IN_PARALLEL             $pixels_in_parallel
        set_instance_parameter_value   video_in_cmd        SRC_WIDTH                      8
        set_instance_parameter_value   video_in_cmd        DST_WIDTH                      8
        set_instance_parameter_value   video_in_cmd        CONTEXT_WIDTH                  8
        set_instance_parameter_value   video_in_cmd        TASK_WIDTH                     8
        set_instance_parameter_value   video_in_cmd        DATA_SRC_ADDRESS               0
        set_instance_parameter_value   video_in_cmd        PIPELINE_READY                 $pipeline_data_output
    }

    if { $input_data_type_guard_band } {
        set_instance_parameter_value   guard_band_in       BITS_PER_SYMBOL                $input_bits_per_symbol
        set_instance_parameter_value   guard_band_in       NUMBER_OF_COLOR_PLANES         3
        set_instance_parameter_value   guard_band_in       COLOR_PLANES_ARE_IN_PARALLEL   $color_planes_are_in_parallel
        set_instance_parameter_value   guard_band_in       PIXELS_IN_PARALLEL             $pixels_in_parallel
        set_instance_parameter_value   guard_band_in       IS_422                         0
        set_instance_parameter_value   guard_band_in       ENABLE_CMD_PORT                0
        set_instance_parameter_value   guard_band_in       PIPELINE_READY                 $pipeline_data_output
        set_instance_parameter_value   guard_band_in       SRC_WIDTH                      8
        set_instance_parameter_value   guard_band_in       DST_WIDTH                      8
        set_instance_parameter_value   guard_band_in       CONTEXT_WIDTH                  8
        set_instance_parameter_value   guard_band_in       TASK_WIDTH                     8
        set_instance_parameter_value   guard_band_in       SOURCE_ID                      0
        for { set i 0 } { $i < 3} { incr i } {
           set_instance_parameter_value   guard_band_in    OUTPUT_GUARD_BAND_LOWER_$i     $input_data_type_min
           set_instance_parameter_value   guard_band_in    OUTPUT_GUARD_BAND_UPPER_$i     $input_data_type_max
        }
        set_instance_parameter_value   guard_band_in       SIGNED_INPUT                   0
        set_instance_parameter_value   guard_band_in       SIGNED_OUTPUT                  0
    }

    # CSC algorithmic core parameterization
    set_instance_parameter_value   csc_core            COLOR_PLANES_ARE_IN_PARALLEL   $color_planes_are_in_parallel
    set_instance_parameter_value   csc_core            PIXELS_IN_PARALLEL             $pixels_in_parallel
    set_instance_parameter_value   csc_core            BITS_PER_SYMBOL_IN             $input_bits_per_symbol
    set_instance_parameter_value   csc_core            BITS_PER_SYMBOL_OUT            $output_bits_per_symbol
    set_instance_parameter_value   csc_core            MOVE_BINARY_POINT_RIGHT        $move_binary_point_right
    set_instance_parameter_value   csc_core            ROUNDING_METHOD                $rounding_method
    foreach name {A B C S} {
        foreach id {0 1 2} {
            set_instance_parameter_value   csc_core            COEFFICIENT_$name$id           $derived_params(COEFFICIENT_$name$id)
        }
    }
    set_instance_parameter_value   csc_core            COEFF_SIGNED                   $coefficient_signed
    set_instance_parameter_value   csc_core            COEFF_INTEGER_BITS             $coefficient_int_bits
    set_instance_parameter_value   csc_core            COEFF_FRACTION_BITS            $coef_sum_fraction_bits
    set_instance_parameter_value   csc_core            SUMMAND_SIGNED                 $summand_signed
    set_instance_parameter_value   csc_core            SUMMAND_INTEGER_BITS           $summand_int_bits
    set_instance_parameter_value   csc_core            SUMMAND_FRACTION_BITS          $coef_sum_fraction_bits
    set_instance_parameter_value   csc_core            RUNTIME_CONTROL                $runtime_control
    set_instance_parameter_value   csc_core            PIPELINE_READY                 $pipeline_data_output
    set_instance_parameter_value   csc_core            SRC_WIDTH                      8
    set_instance_parameter_value   csc_core            DST_WIDTH                      8
    set_instance_parameter_value   csc_core            CONTEXT_WIDTH                  8
    set_instance_parameter_value   csc_core            TASK_WIDTH                     8
    set_instance_parameter_value   csc_core            SOURCE_ID                      0

    if { $output_data_type_guard_band } {
        set_instance_parameter_value   guard_band_out      BITS_PER_SYMBOL                $output_bits_per_symbol
        set_instance_parameter_value   guard_band_out      NUMBER_OF_COLOR_PLANES         3
        set_instance_parameter_value   guard_band_out      COLOR_PLANES_ARE_IN_PARALLEL   $color_planes_are_in_parallel
        set_instance_parameter_value   guard_band_out      PIXELS_IN_PARALLEL             $pixels_in_parallel
        set_instance_parameter_value   guard_band_out      IS_422                         0
        set_instance_parameter_value   guard_band_out      ENABLE_CMD_PORT                0
        set_instance_parameter_value   guard_band_out      PIPELINE_READY                 $pipeline_data_output
        set_instance_parameter_value   guard_band_out      SRC_WIDTH                      8
        set_instance_parameter_value   guard_band_out      DST_WIDTH                      8
        set_instance_parameter_value   guard_band_out      CONTEXT_WIDTH                  8
        set_instance_parameter_value   guard_band_out      TASK_WIDTH                     8
        set_instance_parameter_value   guard_band_out      SOURCE_ID                      0
        for { set i 0 } { $i < 3} { incr i } {
           set_instance_parameter_value   guard_band_out   OUTPUT_GUARD_BAND_LOWER_$i     $output_data_type_min
           set_instance_parameter_value   guard_band_out   OUTPUT_GUARD_BAND_UPPER_$i     $output_data_type_max
        }
        set_instance_parameter_value   guard_band_out      SIGNED_INPUT                   0
        set_instance_parameter_value   guard_band_out      SIGNED_OUTPUT                  0
    }

    if { $user_packet_passthrough } {
        # Packet demux parameterization
        set_instance_parameter_value   user_packet_demux   DATA_WIDTH                     $bits_per_pixel_in
        set_instance_parameter_value   user_packet_demux   PIXELS_IN_PARALLEL             $pixels_in_parallel
        set_instance_parameter_value   user_packet_demux   NUM_OUTPUTS                    2
        set_instance_parameter_value   user_packet_demux   CLIP_ADDRESS_BITS              0
        set_instance_parameter_value   user_packet_demux   REGISTER_OUTPUT                1
        set_instance_parameter_value   user_packet_demux   SRC_WIDTH                      8
        set_instance_parameter_value   user_packet_demux   DST_WIDTH                      8
        set_instance_parameter_value   user_packet_demux   CONTEXT_WIDTH                  8
        set_instance_parameter_value   user_packet_demux   TASK_WIDTH                     8
        set_instance_parameter_value   user_packet_demux   USER_WIDTH                     0
        set_instance_parameter_value   user_packet_demux   PIPELINE_READY                 1

        # Packet mux parameterization
        set_instance_parameter_value   user_packet_mux     DATA_WIDTH                     $bits_per_pixel_out
        set_instance_parameter_value   user_packet_mux     PIXELS_IN_PARALLEL             $pixels_in_parallel
        set_instance_parameter_value   user_packet_mux     NUM_INPUTS                     2
        set_instance_parameter_value   user_packet_mux     SRC_WIDTH                      8
        set_instance_parameter_value   user_packet_mux     DST_WIDTH                      8
        set_instance_parameter_value   user_packet_mux     CONTEXT_WIDTH                  8
        set_instance_parameter_value   user_packet_mux     TASK_WIDTH                     8
        set_instance_parameter_value   user_packet_mux     USER_WIDTH                     0
        set_instance_parameter_value   user_packet_mux     PIPELINE_READY                 1

        # Bps converter parameterization
        set_instance_parameter_value   bps_converter       INPUT_BITS_PER_SYMBOL         $input_bits_per_symbol
        set_instance_parameter_value   bps_converter       OUTPUT_BITS_PER_SYMBOL        $output_bits_per_symbol
        set_instance_parameter_value   bps_converter       NUMBER_OF_COLOR_PLANES        $number_of_color_planes
        set_instance_parameter_value   bps_converter       COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
        set_instance_parameter_value   bps_converter       PIXELS_IN_PARALLEL            $pixels_in_parallel
        set_instance_parameter_value   bps_converter       CONVERSION_MODE               $conversion_mode
        set_instance_parameter_value   bps_converter       SRC_WIDTH                     8
        set_instance_parameter_value   bps_converter       DST_WIDTH                     8
        set_instance_parameter_value   bps_converter       CONTEXT_WIDTH                 8
        set_instance_parameter_value   bps_converter       TASK_WIDTH                    8
    }

    # Scheduler parameterization
    if { $scheduler_enabled } {
        set_instance_parameter_value   scheduler            COEFF_WIDTH                   $coeff_width
        set_instance_parameter_value   scheduler            USER_PACKET_SUPPORT           $user_packet_support
        set_instance_parameter_value   scheduler            RUNTIME_CONTROL               $runtime_control
        set_instance_parameter_value   scheduler            LIMITED_READBACK              $limited_readback
        set_instance_parameter_value   scheduler            PIPELINE_READY                $pipeline_data_output

    }

    # --------------------------------------------------------------------------------------------------
    # -- Top-level interfaces                                                                         --
    # --------------------------------------------------------------------------------------------------
    add_interface            main_clock                clock                        end
    add_interface            main_reset                reset                        end
    set_interface_property   main_clock                export_of                    av_st_clk_bridge.in_clk
    set_interface_property   main_reset                export_of                    av_st_reset_bridge.in_reset
    set_interface_property   main_clock PORT_NAME_MAP  {main_clock in_clk}
    set_interface_property   main_reset PORT_NAME_MAP  {main_reset in_reset}

    if {$vib_vob_removal == 0} {
       add_interface           din         avalon_streaming  sink
       add_interface           dout        avalon_streaming  source
       set_interface_property  din         export_of         video_in_resp.av_st_vid_din
       set_interface_property  dout        export_of         video_out.av_st_vid_dout
    } else {
       add_interface           din_data    avalon_streaming  sink
       add_interface           dout_data   avalon_streaming  source
       if { $scheduler_enabled > 0 } {
          add_interface           din_aux     avalon_streaming  sink
          add_interface           dout_aux    avalon_streaming  source
          set_interface_property  din_aux     export_of         scheduler.av_st_resp_vib
          set_interface_property  dout_aux    export_of         scheduler.av_st_cmd_vob
       }
    }

    # Top-level runtime control interface
    if {$runtime_control} {
        add_interface                  control    avalon      slave
        set_interface_property         control    export_of   scheduler.av_mm_control
    }


    # --------------------------------------------------------------------------------------------------
    # -- Connection of sub-components                                                                 --
    # --------------------------------------------------------------------------------------------------

    # Av-ST Clock/Reset connections :
    add_connection   av_st_clk_bridge.out_clk       av_st_reset_bridge.clk
    add_connection   av_st_clk_bridge.out_clk       csc_core.main_clock
    add_connection   av_st_reset_bridge.out_reset   csc_core.main_reset
    if {$vib_vob_removal == 0} {
       add_connection   av_st_clk_bridge.out_clk       video_in_resp.main_clock
       add_connection   av_st_reset_bridge.out_reset   video_in_resp.main_reset
       add_connection   av_st_clk_bridge.out_clk       video_out.main_clock
       add_connection   av_st_reset_bridge.out_reset   video_out.main_reset
    }
    if { $user_packet_enabled } {
        add_connection   av_st_clk_bridge.out_clk       video_in_cmd.main_clock
        add_connection   av_st_reset_bridge.out_reset   video_in_cmd.main_reset
    }
    if { $user_packet_passthrough } {
        add_connection   av_st_clk_bridge.out_clk       user_packet_demux.main_clock
        add_connection   av_st_reset_bridge.out_reset   user_packet_demux.main_reset
        add_connection   av_st_clk_bridge.out_clk       bps_converter.main_clock
        add_connection   av_st_reset_bridge.out_reset   bps_converter.main_reset
        add_connection   av_st_clk_bridge.out_clk       user_packet_mux.main_clock
        add_connection   av_st_reset_bridge.out_reset   user_packet_mux.main_reset
    }
    if { $scheduler_enabled } {
        add_connection   av_st_clk_bridge.out_clk       scheduler.main_clock
        add_connection   av_st_reset_bridge.out_reset   scheduler.main_reset
    }
    if { $input_data_type_guard_band } {
        add_connection   av_st_clk_bridge.out_clk       guard_band_in.main_clock
        add_connection   av_st_reset_bridge.out_reset   guard_band_in.main_reset
    }
    if { $output_data_type_guard_band } {
        add_connection   av_st_clk_bridge.out_clk       guard_band_out.main_clock
        add_connection   av_st_reset_bridge.out_reset   guard_band_out.main_reset
    }

    # Datapath connections (input side)
    if { $user_packet_passthrough } {
        if {$vib_vob_removal == 0} {
           add_connection   video_in_resp.av_st_dout           video_in_cmd.av_st_din
        } else {
           set_interface_property  din_data     export_of      video_in_cmd.av_st_din
        }
        add_connection   video_in_cmd.av_st_dout               user_packet_demux.av_st_din
        if { $input_data_type_guard_band } {
           add_connection   user_packet_demux.av_st_dout_0     guard_band_in.av_st_din
           add_connection   guard_band_in.av_st_dout           csc_core.av_st_din
        } else {
           add_connection   user_packet_demux.av_st_dout_0     csc_core.av_st_din
        }
    } elseif { $user_packet_enabled } {
        if {$vib_vob_removal == 0} {
            add_connection   video_in_resp.av_st_dout          video_in_cmd.av_st_din
        } else {
            set_interface_property  din_data     export_of     video_in_cmd.av_st_din
        }
        if { $input_data_type_guard_band } {
           add_connection   video_in_cmd.av_st_dout            guard_band_in.av_st_din
           add_connection   guard_band_in.av_st_dout           csc_core.av_st_din
        } else {
           add_connection   video_in_cmd.av_st_dout            csc_core.av_st_din
        }
    } else {
        if { $input_data_type_guard_band } {
           if {$vib_vob_removal == 0} {
               add_connection   video_in_resp.av_st_dout          guard_band_in.av_st_din
           } else {
               set_interface_property  din_data     export_of     guard_band_in.av_st_din
           }
           add_connection   guard_band_in.av_st_dout              csc_core.av_st_din
        } else {
           if {$vib_vob_removal == 0} {
               add_connection   video_in_resp.av_st_dout          csc_core.av_st_din
           } else {
               set_interface_property  din_data     export_of     csc_core.av_st_din
           }
        }
    }

    # Datapath connections (output side)
    if { $user_packet_passthrough } {
        if { $output_data_type_guard_band } {
           add_connection   csc_core.av_st_dout                guard_band_out.av_st_din
           add_connection   guard_band_out.av_st_dout          user_packet_mux.av_st_din_0
        } else {
           add_connection   csc_core.av_st_dout                user_packet_mux.av_st_din_0
        }
        if {$vib_vob_removal == 0} {
            add_connection   user_packet_mux.av_st_dout        video_out.av_st_din
        } else {
            set_interface_property  dout_data    export_of     user_packet_mux.av_st_dout
        }
    } else {
        if { $output_data_type_guard_band } {
           add_connection   csc_core.av_st_dout                guard_band_out.av_st_din
           if {$vib_vob_removal == 0} {
              add_connection   guard_band_out.av_st_dout       video_out.av_st_din
           } else {
              set_interface_property  dout_data    export_of   guard_band_out.av_st_dout
           }
        } else {
           if {$vib_vob_removal == 0} {
              add_connection   csc_core.av_st_dout             video_out.av_st_din
           } else {
              set_interface_property  dout_data    export_of   csc_core.av_st_dout
           }
        }
    }

    # Datapath connections (user packet bypass with bps converter)
    if { $user_packet_passthrough } {
        add_connection   user_packet_demux.av_st_dout_1        bps_converter.av_st_din
        add_connection   bps_converter.av_st_dout              user_packet_mux.av_st_din_1
    }

    # Scheduler command/response connections
    if { $scheduler_enabled } {
        if {$vib_vob_removal == 0} {
           add_connection   video_in_resp.av_st_resp              scheduler.av_st_resp_vib
           add_connection   scheduler.av_st_cmd_vob               video_out.av_st_cmd
        }
        if { $user_packet_enabled } {
            add_connection   scheduler.av_st_cmd_vib           video_in_cmd.av_st_cmd
        }
        if { $user_packet_passthrough } {
            add_connection   scheduler.av_st_cmd_mux           user_packet_mux.av_st_cmd
        }
        # Run-time loading of coefficients
        if { $runtime_control } {
            add_connection   scheduler.av_st_cmd_ac            csc_core.av_st_cmd
            add_connection   scheduler.av_st_coeff             csc_core.av_st_coeff
            add_connection   csc_core.av_st_resp               scheduler.av_st_resp_ac
        }
    } else {
        if { $vib_vob_removal == 0 } {
           # Direct VIB -> VOB response/command
           add_connection   video_in_resp.av_st_resp              video_out.av_st_cmd
        }
    }

}


