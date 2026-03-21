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
add_parameter           ENABLE_0   INTEGER        1
set_parameter_property  ENABLE_0   DISPLAY_HINT    boolean
set_parameter_property  ENABLE_0   VISIBLE        true
set_parameter_property  ENABLE_0   DISPLAY_NAME   "Use Predefined Command - ID: 0"
set_parameter_property  ENABLE_0   DESCRIPTION    ""
set_parameter_property  ENABLE_0   HDL_PARAMETER  false
set_parameter_property  ENABLE_0   GROUP           "ID0"

add_parameter           CHANNEL_0   INTEGER             1
set_parameter_property  CHANNEL_0   DISPLAY_NAME        {CLIENT}
set_parameter_property  CHANNEL_0   AFFECTS_ELABORATION true
set_parameter_property  CHANNEL_0   AFFECTS_GENERATION  true
set_parameter_property  CHANNEL_0   HDL_PARAMETER       false
set_parameter_property  CHANNEL_0   GROUP               "Command 0 Header"
set_parameter_property  CHANNEL_0   DESCRIPTION ""

add_parameter           ID_0   INTEGER             0
set_parameter_property  ID_0   DISPLAY_NAME        {ID}
set_parameter_property  ID_0   AFFECTS_ELABORATION true
set_parameter_property  ID_0   AFFECTS_GENERATION  true
set_parameter_property  ID_0   HDL_PARAMETER       false
set_parameter_property  ID_0   GROUP               "Command 0 Header"
set_parameter_property  ID_0   DESCRIPTION ""

add_parameter           LENGTH_0    INTEGER             1
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
