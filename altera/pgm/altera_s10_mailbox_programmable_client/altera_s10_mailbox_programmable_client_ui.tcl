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


#--------------------------------------------------------
#--------------------------------------------------------
add_parameter           ENABLE_0   INTEGER        0
set_parameter_property  ENABLE_0   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_0   VISIBLE        true
set_parameter_property  ENABLE_0   DISPLAY_NAME   "Use Predefined Command 0"
set_parameter_property  ENABLE_0   DESCRIPTION    ""
set_parameter_property  ENABLE_0   HDL_PARAMETER  false
set_parameter_property  ENABLE_0   GROUP           "ID0"

add_parameter           CHANNEL_0   INTEGER             1
set_parameter_property  CHANNEL_0   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_0   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_0   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_0   HDL_PARAMETER       false
set_parameter_property  CHANNEL_0   GROUP               "Command 0 Header"
set_parameter_property  CHANNEL_0   DESCRIPTION ""

add_parameter           LENGTH_0    INTEGER             0
set_parameter_property  LENGTH_0    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_0    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_0    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_0    HDL_PARAMETER       false
set_parameter_property  LENGTH_0    GROUP               "Command 0 Header"
set_parameter_property  LENGTH_0    DESCRIPTION ""

add_parameter           COMMAND_CODE_0  INTEGER             0
set_parameter_property  COMMAND_CODE_0  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_0  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_0  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_0  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_0  GROUP               "Command 0 Header"
set_parameter_property  COMMAND_CODE_0  DESCRIPTION ""

add_parameter HEADER_0 STRING "" 0
set_parameter_property HEADER_0 UNITS None
set_parameter_property HEADER_0 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_0 AFFECTS_ELABORATION true
set_parameter_property HEADER_0 AFFECTS_GENERATION true
set_parameter_property HEADER_0 VISIBLE true
set_parameter_property HEADER_0 GROUP               "Command 0 Header"
set_parameter_property HEADER_0 DERIVED true


#add_parameter           CMD_ARG_0   STRING_LIST        0
add_parameter           CMD_ARG_0   STRING_LIST        0
set_parameter_property  CMD_ARG_0   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_0   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_0   DESCRIPTION         ""
set_parameter_property  CMD_ARG_0   GROUP               "Command 0 Argument"
set_parameter_property  CMD_ARG_0   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_0   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_1   INTEGER        0
set_parameter_property  ENABLE_1   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_1   VISIBLE        true
set_parameter_property  ENABLE_1   DISPLAY_NAME   "Use Predefined Command 1"
set_parameter_property  ENABLE_1   DESCRIPTION    ""
set_parameter_property  ENABLE_1   HDL_PARAMETER  false
set_parameter_property  ENABLE_1   GROUP           "ID1"

add_parameter           CHANNEL_1   INTEGER             0
set_parameter_property  CHANNEL_1   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_1   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_1   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_1   HDL_PARAMETER       false
set_parameter_property  CHANNEL_1   GROUP               "Command 1 Header"
set_parameter_property  CHANNEL_1   DESCRIPTION ""

add_parameter           LENGTH_1    INTEGER             0
set_parameter_property  LENGTH_1    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_1    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_1    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_1    HDL_PARAMETER       false
set_parameter_property  LENGTH_1    GROUP               "Command 1 Header"
set_parameter_property  LENGTH_1    DESCRIPTION ""

add_parameter           COMMAND_CODE_1  INTEGER             0
set_parameter_property  COMMAND_CODE_1  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_1  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_1  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_1  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_1  GROUP               "Command 1 Header"
set_parameter_property  COMMAND_CODE_1  DESCRIPTION ""

add_parameter HEADER_1 STRING "" 0
set_parameter_property HEADER_1 UNITS None
set_parameter_property HEADER_1 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_1 AFFECTS_ELABORATION true
set_parameter_property HEADER_1 AFFECTS_GENERATION true
set_parameter_property HEADER_1 VISIBLE true
set_parameter_property HEADER_1 GROUP               "Command 1 Header"
set_parameter_property HEADER_1 DERIVED true

add_parameter           CMD_ARG_1   STRING_LIST        0
set_parameter_property  CMD_ARG_1   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_1   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_1   DESCRIPTION         ""
set_parameter_property  CMD_ARG_1   GROUP               "Command 1 Argument"
set_parameter_property  CMD_ARG_1   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_1   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_2   INTEGER        0
set_parameter_property  ENABLE_2   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_2   VISIBLE        true
set_parameter_property  ENABLE_2   DISPLAY_NAME   "Use Predefined Command 2"
set_parameter_property  ENABLE_2   DESCRIPTION    ""
set_parameter_property  ENABLE_2   HDL_PARAMETER  false
set_parameter_property  ENABLE_2   GROUP           "ID2"

add_parameter           CHANNEL_2   INTEGER             0
set_parameter_property  CHANNEL_2   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_2   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_2   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_2   HDL_PARAMETER       false
set_parameter_property  CHANNEL_2   GROUP               "Command 2 Header"
set_parameter_property  CHANNEL_2   DESCRIPTION ""

add_parameter           LENGTH_2    INTEGER             0
set_parameter_property  LENGTH_2    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_2    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_2    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_2    HDL_PARAMETER       false
set_parameter_property  LENGTH_2    GROUP               "Command 2 Header"
set_parameter_property  LENGTH_2    DESCRIPTION ""

add_parameter           COMMAND_CODE_2  INTEGER             0
set_parameter_property  COMMAND_CODE_2  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_2  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_2  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_2  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_2  GROUP               "Command 2 Header"
set_parameter_property  COMMAND_CODE_2  DESCRIPTION ""
add_parameter HEADER_2 STRING "" 0
set_parameter_property HEADER_2 UNITS None
set_parameter_property HEADER_2 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_2 AFFECTS_ELABORATION true
set_parameter_property HEADER_2 AFFECTS_GENERATION true
set_parameter_property HEADER_2 VISIBLE true
set_parameter_property HEADER_2 GROUP               "Command 2 Header"
set_parameter_property HEADER_2 DERIVED true

add_parameter           CMD_ARG_2   STRING_LIST        0
set_parameter_property  CMD_ARG_2   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_2   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_2   DESCRIPTION         ""
set_parameter_property  CMD_ARG_2   GROUP               "Command 2 Argument"
set_parameter_property  CMD_ARG_2   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_2   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_3   INTEGER        0
set_parameter_property  ENABLE_3   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_3   VISIBLE        true
set_parameter_property  ENABLE_3   DISPLAY_NAME   "Use Predefined Command 3"
set_parameter_property  ENABLE_3   DESCRIPTION    ""
set_parameter_property  ENABLE_3   HDL_PARAMETER  false
set_parameter_property  ENABLE_3   GROUP           "ID3"

add_parameter           CHANNEL_3   INTEGER             0
set_parameter_property  CHANNEL_3   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_3   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_3   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_3   HDL_PARAMETER       false
set_parameter_property  CHANNEL_3   GROUP               "Command 3 Header"
set_parameter_property  CHANNEL_3   DESCRIPTION ""

add_parameter           LENGTH_3    INTEGER             0
set_parameter_property  LENGTH_3    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_3    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_3    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_3    HDL_PARAMETER       false
set_parameter_property  LENGTH_3    GROUP               "Command 3 Header"
set_parameter_property  LENGTH_3    DESCRIPTION ""

add_parameter           COMMAND_CODE_3  INTEGER             0
set_parameter_property  COMMAND_CODE_3  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_3  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_3  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_3  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_3  GROUP               "Command 3 Header"
set_parameter_property  COMMAND_CODE_3  DESCRIPTION ""

add_parameter HEADER_3 STRING "" 0
set_parameter_property HEADER_3 UNITS None
set_parameter_property HEADER_3 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_3 AFFECTS_ELABORATION true
set_parameter_property HEADER_3 AFFECTS_GENERATION true
set_parameter_property HEADER_3 VISIBLE true
set_parameter_property HEADER_3 GROUP               "Command 3 Header"
set_parameter_property HEADER_3 DERIVED true

add_parameter           CMD_ARG_3   STRING_LIST        0
set_parameter_property  CMD_ARG_3   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_3   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_3   DESCRIPTION         ""
set_parameter_property  CMD_ARG_3   GROUP               "Command 3 Argument"
set_parameter_property  CMD_ARG_3   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_3   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_4   INTEGER        0
set_parameter_property  ENABLE_4   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_4   VISIBLE        true
set_parameter_property  ENABLE_4   DISPLAY_NAME   "Use Predefined Command 4"
set_parameter_property  ENABLE_4   DESCRIPTION    ""
set_parameter_property  ENABLE_4   HDL_PARAMETER  false
set_parameter_property  ENABLE_4   GROUP           "ID4"

add_parameter           CHANNEL_4   INTEGER             0
set_parameter_property  CHANNEL_4   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_4   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_4   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_4   HDL_PARAMETER       false
set_parameter_property  CHANNEL_4   GROUP               "Command 4 Header"
set_parameter_property  CHANNEL_4   DESCRIPTION ""

add_parameter           LENGTH_4    INTEGER             0
set_parameter_property  LENGTH_4    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_4    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_4    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_4    HDL_PARAMETER       false
set_parameter_property  LENGTH_4    GROUP               "Command 4 Header"
set_parameter_property  LENGTH_4    DESCRIPTION ""

add_parameter           COMMAND_CODE_4  INTEGER             0
set_parameter_property  COMMAND_CODE_4  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_4  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_4  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_4  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_4  GROUP               "Command 4 Header"
set_parameter_property  COMMAND_CODE_4  DESCRIPTION ""

add_parameter 		   HEADER_4 STRING "" 0
set_parameter_property HEADER_4 UNITS None
set_parameter_property HEADER_4 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_4 AFFECTS_ELABORATION true
set_parameter_property HEADER_4 AFFECTS_GENERATION true
set_parameter_property HEADER_4 VISIBLE true
set_parameter_property HEADER_4 GROUP               "Command 4 Header"
set_parameter_property HEADER_4 DERIVED true

add_parameter           CMD_ARG_4   STRING_LIST        0
set_parameter_property  CMD_ARG_4   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_4   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_4   DESCRIPTION         ""
set_parameter_property  CMD_ARG_4   GROUP               "Command 4 Argument"
set_parameter_property  CMD_ARG_4   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_4   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_5   INTEGER        0
set_parameter_property  ENABLE_5   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_5   VISIBLE        true
set_parameter_property  ENABLE_5   DISPLAY_NAME   "Use Predefined Command 5"
set_parameter_property  ENABLE_5   DESCRIPTION    ""
set_parameter_property  ENABLE_5   HDL_PARAMETER  false
set_parameter_property  ENABLE_5   GROUP           "ID5"

add_parameter           CHANNEL_5   INTEGER             0
set_parameter_property  CHANNEL_5   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_5   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_5   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_5   HDL_PARAMETER       false
set_parameter_property  CHANNEL_5   GROUP               "Command 5 Header"
set_parameter_property  CHANNEL_5   DESCRIPTION ""

add_parameter           LENGTH_5    INTEGER             0
set_parameter_property  LENGTH_5    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_5    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_5    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_5    HDL_PARAMETER       false
set_parameter_property  LENGTH_5    GROUP               "Command 5 Header"
set_parameter_property  LENGTH_5    DESCRIPTION ""

add_parameter           COMMAND_CODE_5  INTEGER             0
set_parameter_property  COMMAND_CODE_5  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_5  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_5  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_5  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_5  GROUP               "Command 5 Header"
set_parameter_property  COMMAND_CODE_5  DESCRIPTION ""

add_parameter 		   HEADER_5 STRING "" 0
set_parameter_property HEADER_5 UNITS None
set_parameter_property HEADER_5 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_5 AFFECTS_ELABORATION true
set_parameter_property HEADER_5 AFFECTS_GENERATION true
set_parameter_property HEADER_5 VISIBLE true
set_parameter_property HEADER_5 GROUP               "Command 5 Header"
set_parameter_property HEADER_5 DERIVED true

add_parameter           CMD_ARG_5   STRING_LIST        0
set_parameter_property  CMD_ARG_5   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_5   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_5   DESCRIPTION         ""
set_parameter_property  CMD_ARG_5   GROUP               "Command 5 Argument"
set_parameter_property  CMD_ARG_5   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_5   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_6   INTEGER        0
set_parameter_property  ENABLE_6   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_6   VISIBLE        true
set_parameter_property  ENABLE_6   DISPLAY_NAME   "Use Predefined Command 6"
set_parameter_property  ENABLE_6   DESCRIPTION    ""
set_parameter_property  ENABLE_6   HDL_PARAMETER  false
set_parameter_property  ENABLE_6   GROUP           "ID6"

add_parameter           CHANNEL_6   INTEGER             0
set_parameter_property  CHANNEL_6   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_6   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_6   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_6   HDL_PARAMETER       false
set_parameter_property  CHANNEL_6   GROUP               "Command 6 Header"
set_parameter_property  CHANNEL_6   DESCRIPTION ""

add_parameter           LENGTH_6    INTEGER             0
set_parameter_property  LENGTH_6    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_6    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_6    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_6    HDL_PARAMETER       false
set_parameter_property  LENGTH_6    GROUP               "Command 6 Header"
set_parameter_property  LENGTH_6    DESCRIPTION ""

add_parameter           COMMAND_CODE_6  INTEGER             0
set_parameter_property  COMMAND_CODE_6  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_6  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_6  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_6  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_6  GROUP               "Command 6 Header"
set_parameter_property  COMMAND_CODE_6  DESCRIPTION ""

add_parameter           CMD_ARG_6   STRING_LIST        0
set_parameter_property  CMD_ARG_6   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_6   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_6   DESCRIPTION         ""
set_parameter_property  CMD_ARG_6   GROUP               "Command 6 Argument"
set_parameter_property  CMD_ARG_6   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_6   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_7   INTEGER        0
set_parameter_property  ENABLE_7   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_7   VISIBLE        true
set_parameter_property  ENABLE_7   DISPLAY_NAME   "Use Predefined Command 7"
set_parameter_property  ENABLE_7   DESCRIPTION    ""
set_parameter_property  ENABLE_7   HDL_PARAMETER  false
set_parameter_property  ENABLE_7   GROUP           "ID7"

add_parameter           CHANNEL_7   INTEGER             0
set_parameter_property  CHANNEL_7   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_7   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_7   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_7   HDL_PARAMETER       false
set_parameter_property  CHANNEL_7   GROUP               "Command 7 Header"
set_parameter_property  CHANNEL_7   DESCRIPTION ""

add_parameter           LENGTH_7    INTEGER             0
set_parameter_property  LENGTH_7    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_7    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_7    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_7    HDL_PARAMETER       false
set_parameter_property  LENGTH_7    GROUP               "Command 7 Header"
set_parameter_property  LENGTH_7    DESCRIPTION ""

add_parameter           COMMAND_CODE_7  INTEGER             0
set_parameter_property  COMMAND_CODE_7  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_7  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_7  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_7  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_7  GROUP               "Command 7 Header"
set_parameter_property  COMMAND_CODE_7  DESCRIPTION ""

add_parameter           CMD_ARG_7   STRING_LIST        0
set_parameter_property  CMD_ARG_7   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_7   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_7   DESCRIPTION         ""
set_parameter_property  CMD_ARG_7   GROUP               "Command 7 Argument"
set_parameter_property  CMD_ARG_7   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_7   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_8   INTEGER        0
set_parameter_property  ENABLE_8   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_8   VISIBLE        true
set_parameter_property  ENABLE_8   DISPLAY_NAME   "Use Predefined Command 8"
set_parameter_property  ENABLE_8   DESCRIPTION    ""
set_parameter_property  ENABLE_8   HDL_PARAMETER  false
set_parameter_property  ENABLE_8   GROUP           "ID8"

add_parameter           CHANNEL_8   INTEGER             0
set_parameter_property  CHANNEL_8   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_8   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_8   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_8   HDL_PARAMETER       false
set_parameter_property  CHANNEL_8   GROUP               "Command 8 Header"
set_parameter_property  CHANNEL_8   DESCRIPTION ""

add_parameter           LENGTH_8    INTEGER             0
set_parameter_property  LENGTH_8    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_8    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_8    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_8    HDL_PARAMETER       false
set_parameter_property  LENGTH_8    GROUP               "Command 8 Header"
set_parameter_property  LENGTH_8    DESCRIPTION ""

add_parameter           COMMAND_CODE_8  INTEGER             0
set_parameter_property  COMMAND_CODE_8  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_8  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_8  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_8  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_8  GROUP               "Command 8 Header"
set_parameter_property  COMMAND_CODE_8  DESCRIPTION ""

add_parameter           CMD_ARG_8   STRING_LIST        0
set_parameter_property  CMD_ARG_8   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_8   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_8   DESCRIPTION         ""
set_parameter_property  CMD_ARG_8   GROUP               "Command 8 Argument"
set_parameter_property  CMD_ARG_8   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_8   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_9   INTEGER        0
set_parameter_property  ENABLE_9   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_9   VISIBLE        true
set_parameter_property  ENABLE_9   DISPLAY_NAME   "Use Predefined Command 9"
set_parameter_property  ENABLE_9   DESCRIPTION    ""
set_parameter_property  ENABLE_9   HDL_PARAMETER  false
set_parameter_property  ENABLE_9   GROUP           "ID9"

add_parameter           CHANNEL_9   INTEGER             0
set_parameter_property  CHANNEL_9   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_9   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_9   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_9   HDL_PARAMETER       false
set_parameter_property  CHANNEL_9   GROUP               "Command 9 Header"
set_parameter_property  CHANNEL_9   DESCRIPTION ""

add_parameter           LENGTH_9    INTEGER             0
set_parameter_property  LENGTH_9    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_9    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_9    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_9    HDL_PARAMETER       false
set_parameter_property  LENGTH_9    GROUP               "Command 9 Header"
set_parameter_property  LENGTH_9    DESCRIPTION ""

add_parameter           COMMAND_CODE_9  INTEGER             0
set_parameter_property  COMMAND_CODE_9  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_9  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_9  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_9  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_9  GROUP               "Command 9 Header"
set_parameter_property  COMMAND_CODE_9  DESCRIPTION ""

add_parameter           CMD_ARG_9   STRING_LIST        0
set_parameter_property  CMD_ARG_9   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_9   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_9   DESCRIPTION         ""
set_parameter_property  CMD_ARG_9   GROUP               "Command 9 Argument"
set_parameter_property  CMD_ARG_9   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_9   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_10   INTEGER        0
set_parameter_property  ENABLE_10   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_10   VISIBLE        true
set_parameter_property  ENABLE_10   DISPLAY_NAME   "Use Predefined Command 10"
set_parameter_property  ENABLE_10   DESCRIPTION    ""
set_parameter_property  ENABLE_10   HDL_PARAMETER  false
set_parameter_property  ENABLE_10   GROUP           "ID10"

add_parameter           CHANNEL_10   INTEGER             0
set_parameter_property  CHANNEL_10   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_10   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_10   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_10   HDL_PARAMETER       false
set_parameter_property  CHANNEL_10   GROUP               "Command 10 Header"
set_parameter_property  CHANNEL_10   DESCRIPTION ""

add_parameter           LENGTH_10    INTEGER             0
set_parameter_property  LENGTH_10    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_10    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_10    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_10    HDL_PARAMETER       false
set_parameter_property  LENGTH_10    GROUP               "Command 10 Header"
set_parameter_property  LENGTH_10    DESCRIPTION ""

add_parameter           COMMAND_CODE_10  INTEGER             0
set_parameter_property  COMMAND_CODE_10  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_10  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_10  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_10  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_10  GROUP               "Command 10 Header"
set_parameter_property  COMMAND_CODE_10  DESCRIPTION ""

add_parameter           CMD_ARG_10   STRING_LIST        0
set_parameter_property  CMD_ARG_10   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_10   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_10   DESCRIPTION         ""
set_parameter_property  CMD_ARG_10   GROUP               "Command 10 Argument"
set_parameter_property  CMD_ARG_10   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_10   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_11   INTEGER        0
set_parameter_property  ENABLE_11   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_11   VISIBLE        true
set_parameter_property  ENABLE_11   DISPLAY_NAME   "Use Predefined Command 11"
set_parameter_property  ENABLE_11   DESCRIPTION    ""
set_parameter_property  ENABLE_11   HDL_PARAMETER  false
set_parameter_property  ENABLE_11   GROUP           "ID11"

add_parameter           CHANNEL_11   INTEGER             0
set_parameter_property  CHANNEL_11   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_11   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_11   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_11   HDL_PARAMETER       false
set_parameter_property  CHANNEL_11   GROUP               "Command 11 Header"
set_parameter_property  CHANNEL_11   DESCRIPTION ""

add_parameter           LENGTH_11    INTEGER             0
set_parameter_property  LENGTH_11    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_11    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_11    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_11    HDL_PARAMETER       false
set_parameter_property  LENGTH_11    GROUP               "Command 11 Header"
set_parameter_property  LENGTH_11    DESCRIPTION ""

add_parameter           COMMAND_CODE_11  INTEGER             0
set_parameter_property  COMMAND_CODE_11  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_11  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_11  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_11  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_11  GROUP               "Command 11 Header"
set_parameter_property  COMMAND_CODE_11  DESCRIPTION ""

add_parameter           CMD_ARG_11   STRING_LIST        0
set_parameter_property  CMD_ARG_11   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_11   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_11   DESCRIPTION         ""
set_parameter_property  CMD_ARG_11   GROUP               "Command 11 Argument"
set_parameter_property  CMD_ARG_11   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_11   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_12   INTEGER        0
set_parameter_property  ENABLE_12   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_12   VISIBLE        true
set_parameter_property  ENABLE_12   DISPLAY_NAME   "Use Predefined Command 12"
set_parameter_property  ENABLE_12   DESCRIPTION    ""
set_parameter_property  ENABLE_12   HDL_PARAMETER  false
set_parameter_property  ENABLE_12   GROUP           "ID12"

add_parameter           CHANNEL_12   INTEGER             0
set_parameter_property  CHANNEL_12   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_12   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_12   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_12   HDL_PARAMETER       false
set_parameter_property  CHANNEL_12   GROUP               "Command 12 Header"
set_parameter_property  CHANNEL_12   DESCRIPTION ""

add_parameter           LENGTH_12    INTEGER             0
set_parameter_property  LENGTH_12    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_12    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_12    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_12    HDL_PARAMETER       false
set_parameter_property  LENGTH_12    GROUP               "Command 12 Header"
set_parameter_property  LENGTH_12    DESCRIPTION ""

add_parameter           COMMAND_CODE_12  INTEGER             0
set_parameter_property  COMMAND_CODE_12  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_12  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_12  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_12  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_12  GROUP               "Command 12 Header"
set_parameter_property  COMMAND_CODE_12  DESCRIPTION ""

add_parameter           CMD_ARG_12   STRING_LIST        0
set_parameter_property  CMD_ARG_12   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_12   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_12   DESCRIPTION         ""
set_parameter_property  CMD_ARG_12   GROUP               "Command 12 Argument"
set_parameter_property  CMD_ARG_12   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_12   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_13   INTEGER        0
set_parameter_property  ENABLE_13   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_13   VISIBLE        true
set_parameter_property  ENABLE_13   DISPLAY_NAME   "Use Predefined Command 13"
set_parameter_property  ENABLE_13   DESCRIPTION    ""
set_parameter_property  ENABLE_13   HDL_PARAMETER  false
set_parameter_property  ENABLE_13   GROUP           "ID13"

add_parameter           CHANNEL_13   INTEGER             0
set_parameter_property  CHANNEL_13   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_13   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_13   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_13   HDL_PARAMETER       false
set_parameter_property  CHANNEL_13   GROUP               "Command 13 Header"
set_parameter_property  CHANNEL_13   DESCRIPTION ""

add_parameter           LENGTH_13    INTEGER             0
set_parameter_property  LENGTH_13    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_13    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_13    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_13    HDL_PARAMETER       false
set_parameter_property  LENGTH_13    GROUP               "Command 13 Header"
set_parameter_property  LENGTH_13    DESCRIPTION ""

add_parameter           COMMAND_CODE_13  INTEGER             0
set_parameter_property  COMMAND_CODE_13  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_13  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_13  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_13  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_13  GROUP               "Command 13 Header"
set_parameter_property  COMMAND_CODE_13  DESCRIPTION ""

add_parameter           CMD_ARG_13   STRING_LIST        0
set_parameter_property  CMD_ARG_13   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_13   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_13   DESCRIPTION         ""
set_parameter_property  CMD_ARG_13   GROUP               "Command 13 Argument"
set_parameter_property  CMD_ARG_13   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_13   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_14   INTEGER        0
set_parameter_property  ENABLE_14   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_14   VISIBLE        true
set_parameter_property  ENABLE_14   DISPLAY_NAME   "Use Predefined Command 14"
set_parameter_property  ENABLE_14   DESCRIPTION    ""
set_parameter_property  ENABLE_14   HDL_PARAMETER  false
set_parameter_property  ENABLE_14   GROUP           "ID14"

add_parameter           CHANNEL_14   INTEGER             0
set_parameter_property  CHANNEL_14   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_14   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_14   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_14   HDL_PARAMETER       false
set_parameter_property  CHANNEL_14   GROUP               "Command 14 Header"
set_parameter_property  CHANNEL_14   DESCRIPTION ""

add_parameter           LENGTH_14    INTEGER             0
set_parameter_property  LENGTH_14    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_14    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_14    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_14    HDL_PARAMETER       false
set_parameter_property  LENGTH_14    GROUP               "Command 14 Header"
set_parameter_property  LENGTH_14    DESCRIPTION ""

add_parameter           COMMAND_CODE_14  INTEGER             0
set_parameter_property  COMMAND_CODE_14  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_14  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_14  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_14  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_14  GROUP               "Command 14 Header"
set_parameter_property  COMMAND_CODE_14  DESCRIPTION ""

add_parameter           CMD_ARG_14   STRING_LIST        0
set_parameter_property  CMD_ARG_14   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_14   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_14   DESCRIPTION         ""
set_parameter_property  CMD_ARG_14   GROUP               "Command 14 Argument"
set_parameter_property  CMD_ARG_14   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_14   AFFECTS_ELABORATION true
#--------------------------------------------------------
add_parameter           ENABLE_15   INTEGER        0
set_parameter_property  ENABLE_15   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_15   VISIBLE        true
set_parameter_property  ENABLE_15   DISPLAY_NAME   "Use Predefined Command 15"
set_parameter_property  ENABLE_15   DESCRIPTION    ""
set_parameter_property  ENABLE_15   HDL_PARAMETER  false
set_parameter_property  ENABLE_15   GROUP           "ID15"

add_parameter           CHANNEL_15   INTEGER             0
set_parameter_property  CHANNEL_15   DISPLAY_NAME        {CHANNEL}
set_parameter_property  CHANNEL_15   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_15   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_15   HDL_PARAMETER       false
set_parameter_property  CHANNEL_15   GROUP               "Command 15 Header"
set_parameter_property  CHANNEL_15   DESCRIPTION ""

add_parameter           LENGTH_15    INTEGER             0
set_parameter_property  LENGTH_15    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH_15    AFFECTS_ELABORATION true
set_parameter_property  LENGTH_15    AFFECTS_GENERATION  true
set_parameter_property  LENGTH_15    HDL_PARAMETER       false
set_parameter_property  LENGTH_15    GROUP               "Command 15 Header"
set_parameter_property  LENGTH_15    DESCRIPTION ""

add_parameter           COMMAND_CODE_15  INTEGER             0
set_parameter_property  COMMAND_CODE_15  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE_15  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE_15  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE_15  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE_15  GROUP               "Command 15 Header"
set_parameter_property  COMMAND_CODE_15  DESCRIPTION ""

add_parameter           CMD_ARG_15   STRING_LIST        0
set_parameter_property  CMD_ARG_15   DISPLAY_NAME        "CMD_ARG"
set_parameter_property  CMD_ARG_15   DISPLAY_HINT        hexadecimal
set_parameter_property  CMD_ARG_15   DESCRIPTION         ""
set_parameter_property  CMD_ARG_15   GROUP               "Command 15 Argument"
set_parameter_property  CMD_ARG_15   HDL_PARAMETER       false
set_parameter_property  CMD_ARG_15   AFFECTS_ELABORATION true
#--------------------------------------------------------
#--------------------------------------------------------
#--------------------------------------------------------
add_parameter 		   HEADER_6 STRING "" 0
set_parameter_property HEADER_6 UNITS None
set_parameter_property HEADER_6 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_6 AFFECTS_ELABORATION true
set_parameter_property HEADER_6 AFFECTS_GENERATION true
set_parameter_property HEADER_6 VISIBLE true
set_parameter_property HEADER_6 GROUP               "Command 6 Header"
set_parameter_property HEADER_6 DERIVED true
add_parameter 		   HEADER_7 STRING "" 0
set_parameter_property HEADER_7 UNITS None
set_parameter_property HEADER_7 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_7 AFFECTS_ELABORATION true
set_parameter_property HEADER_7 AFFECTS_GENERATION true
set_parameter_property HEADER_7 VISIBLE true
set_parameter_property HEADER_7 GROUP               "Command 7 Header"
set_parameter_property HEADER_7 DERIVED true
add_parameter 		   HEADER_8 STRING "" 0
set_parameter_property HEADER_8 UNITS None
set_parameter_property HEADER_8 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_8 AFFECTS_ELABORATION true
set_parameter_property HEADER_8 AFFECTS_GENERATION true
set_parameter_property HEADER_8 VISIBLE true
set_parameter_property HEADER_8 GROUP               "Command 8 Header"
set_parameter_property HEADER_8 DERIVED true
add_parameter 		   HEADER_9 STRING "" 0
set_parameter_property HEADER_9 UNITS None
set_parameter_property HEADER_9 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_9 AFFECTS_ELABORATION true
set_parameter_property HEADER_9 AFFECTS_GENERATION true
set_parameter_property HEADER_9 VISIBLE true
set_parameter_property HEADER_9 GROUP               "Command 9 Header"
set_parameter_property HEADER_9 DERIVED true
add_parameter 		   HEADER_10 STRING "" 0
set_parameter_property HEADER_10 UNITS None
set_parameter_property HEADER_10 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_10 AFFECTS_ELABORATION true
set_parameter_property HEADER_10 AFFECTS_GENERATION true
set_parameter_property HEADER_10 VISIBLE true
set_parameter_property HEADER_10 GROUP               "Command 10 Header"
set_parameter_property HEADER_10 DERIVED true
add_parameter 		   HEADER_11 STRING "" 0
set_parameter_property HEADER_11 UNITS None
set_parameter_property HEADER_11 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_11 AFFECTS_ELABORATION true
set_parameter_property HEADER_11 AFFECTS_GENERATION true
set_parameter_property HEADER_11 VISIBLE true
set_parameter_property HEADER_11 GROUP               "Command 11 Header"
set_parameter_property HEADER_11 DERIVED true
add_parameter 		   HEADER_12 STRING "" 0
set_parameter_property HEADER_12 UNITS None
set_parameter_property HEADER_12 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_12 AFFECTS_ELABORATION true
set_parameter_property HEADER_12 AFFECTS_GENERATION true
set_parameter_property HEADER_12 VISIBLE true
set_parameter_property HEADER_12 GROUP               "Command 12 Header"
set_parameter_property HEADER_12 DERIVED true
add_parameter 		   HEADER_13 STRING "" 0
set_parameter_property HEADER_13 UNITS None
set_parameter_property HEADER_13 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_13 AFFECTS_ELABORATION true
set_parameter_property HEADER_13 AFFECTS_GENERATION true
set_parameter_property HEADER_13 VISIBLE true
set_parameter_property HEADER_13 GROUP               "Command 13 Header"
set_parameter_property HEADER_13 DERIVED true
add_parameter 		   HEADER_14 STRING "" 0
set_parameter_property HEADER_14 UNITS None
set_parameter_property HEADER_14 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_14 AFFECTS_ELABORATION true
set_parameter_property HEADER_14 AFFECTS_GENERATION true
set_parameter_property HEADER_14 VISIBLE true
set_parameter_property HEADER_14 GROUP               "Command 14 Header"
set_parameter_property HEADER_14 DERIVED true
add_parameter 		   HEADER_15 STRING "" 0
set_parameter_property HEADER_15 UNITS None
set_parameter_property HEADER_15 DISPLAY_NAME        {HEADER VALUE}
set_parameter_property HEADER_15 AFFECTS_ELABORATION true
set_parameter_property HEADER_15 AFFECTS_GENERATION true
set_parameter_property HEADER_15 VISIBLE true
set_parameter_property HEADER_15 GROUP               "Command 15 Header"
set_parameter_property HEADER_15 DERIVED true