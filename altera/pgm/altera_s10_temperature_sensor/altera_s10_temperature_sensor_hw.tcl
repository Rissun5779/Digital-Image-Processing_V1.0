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


# $Id: //acds/rel/18.1std/ip/pgm/altera_s10_temperature_sensor/altera_s10_temperature_sensor_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $


# 
# request TCL package from ACDS 16.0
# 
package require -exact qsys 16.0

# 
# module altera_s10_mailbox_pro_client_lite
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_s10_temperature_sensor
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera S10 Temperature Sensor"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate
set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list

# 
# parameters
# 
# 
# parameters
# 
add_parameter CMD_WIDTH INTEGER 6
set_parameter_property CMD_WIDTH DISPLAY_NAME "Bitmask Width"
set_parameter_property CMD_WIDTH AFFECTS_ELABORATION true
set_parameter_property CMD_WIDTH AFFECTS_GENERATION true
set_parameter_property CMD_WIDTH HDL_PARAMETER true
set_parameter_property CMD_WIDTH VISIBLE true

add_parameter           CLIENT  INTEGER             1
set_parameter_property  CLIENT  DISPLAY_NAME        {CLIENT}
set_parameter_property  CLIENT  AFFECTS_ELABORATION true
set_parameter_property  CLIENT  AFFECTS_GENERATION  true
set_parameter_property  CLIENT  HDL_PARAMETER       false
set_parameter_property  CLIENT  GROUP               "Command 0 Header"
set_parameter_property  CLIENT  DESCRIPTION ""
set_parameter_property  CLIENT  VISIBLE false

add_parameter           ID   INTEGER             0
set_parameter_property  ID   DISPLAY_NAME        {ID}
set_parameter_property  ID   AFFECTS_ELABORATION true
set_parameter_property  ID   AFFECTS_GENERATION  true
set_parameter_property  ID   HDL_PARAMETER       false
set_parameter_property  ID   GROUP               "Command 0 Header"
set_parameter_property  ID   DESCRIPTION ""
set_parameter_property  ID   VISIBLE false

add_parameter           LENGTH    INTEGER             1
set_parameter_property  LENGTH    DISPLAY_NAME        {LENGTH}
set_parameter_property  LENGTH    AFFECTS_ELABORATION true
set_parameter_property  LENGTH    AFFECTS_GENERATION  true
set_parameter_property  LENGTH    HDL_PARAMETER       false
set_parameter_property  LENGTH    GROUP               "Command 0 Header"
set_parameter_property  LENGTH    DESCRIPTION ""
set_parameter_property  LENGTH    VISIBLE false

add_parameter           COMMAND_CODE  INTEGER             25
set_parameter_property  COMMAND_CODE  DISPLAY_NAME        {COMMAND_CODE}
set_parameter_property  COMMAND_CODE  AFFECTS_ELABORATION true
set_parameter_property  COMMAND_CODE  AFFECTS_GENERATION  true
set_parameter_property  COMMAND_CODE  HDL_PARAMETER       false
set_parameter_property  COMMAND_CODE  GROUP               "Command 0 Header"
set_parameter_property  COMMAND_CODE  DESCRIPTION ""
set_parameter_property  COMMAND_CODE  VISIBLE false

# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1

# 
# connection point rsp
# 
add_interface rsp avalon_streaming start
set_interface_property rsp associatedClock clk
set_interface_property rsp associatedReset reset
set_interface_property rsp dataBitsPerSymbol 32
set_interface_property rsp errorDescriptor ""
set_interface_property rsp firstSymbolInHighOrderBits true
set_interface_property rsp maxChannel 0
set_interface_property rsp readyLatency 0
set_interface_property rsp ENABLED true
set_interface_property rsp EXPORT_OF ""
set_interface_property rsp PORT_NAME_MAP ""
set_interface_property rsp CMSIS_SVD_VARIABLES ""
set_interface_property rsp SVD_ADDRESS_GROUP ""

add_interface_port rsp rsp_valid valid Output 1
add_interface_port rsp rsp_data data Output 32
add_interface_port rsp rsp_channel channel Output 4
add_interface_port rsp rsp_startofpacket startofpacket Output 1
add_interface_port rsp rsp_endofpacket endofpacket Output 1

# 
# connection point cmd
# 
add_interface cmd avalon_streaming end
set_interface_property cmd associatedClock clk
set_interface_property cmd associatedReset reset
set_interface_property cmd dataBitsPerSymbol 8
set_interface_property cmd errorDescriptor ""
set_interface_property cmd firstSymbolInHighOrderBits true
set_interface_property cmd readyLatency 0
set_interface_property cmd ENABLED true
set_interface_property cmd EXPORT_OF ""
set_interface_property cmd PORT_NAME_MAP ""
set_interface_property cmd CMSIS_SVD_VARIABLES ""
set_interface_property cmd SVD_ADDRESS_GROUP ""

add_interface_port cmd cmd_valid valid Input 1
add_interface_port cmd cmd_ready ready Output 1

# 
# file sets
# 
add_fileset synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
set_fileset_property synthesis_fileset TOP_LEVEL altera_s10_temperature_sensor 
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL altera_s10_temperature_sensor
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure
set_fileset_property vhdl_fileset TOP_LEVEL altera_s10_temperature_sensor

proc synth_callback_procedure { entity_name } {
    add_fileset_file altera_s10_temperature_sensor.sv SYSTEM_VERILOG PATH "altera_s10_temperature_sensor.sv"
    #add_fileset_file programable_mailbox_client_inst.v VERILOG PATH "programable_mailbox_client_inst.v"
}


proc elaborate {} {
    
    set client  [get_parameter_value CLIENT]
    set id      [get_parameter_value ID]
    set length  [get_parameter_value LENGTH]
    set command_code [get_parameter_value COMMAND_CODE]
    set input_cmd_width     [get_parameter_value CMD_WIDTH]

    set_interface_property cmd dataBitsPerSymbol $input_cmd_width
    add_interface_port cmd cmd_data data Input $input_cmd_width

    # Add in the programable mailbox client
    add_hdl_instance programable_mailbox_client_inst altera_s10_mailbox_pro_client_lite
    set_instance_parameter_value programable_mailbox_client_inst CMD_WIDTH $input_cmd_width
    set_instance_parameter_value programable_mailbox_client_inst CHANNEL_0  $client
    set_instance_parameter_value programable_mailbox_client_inst ID_0   $id
    set_instance_parameter_value programable_mailbox_client_inst LENGTH_0 1
    set_instance_parameter_value programable_mailbox_client_inst COMMAND_CODE_0  $command_code


}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}

proc dec2bin {i {width {}}} {
    #returns the binary representation of $i
    # width determines the length of the returned string (left truncated or added left 0)
    # use of width allows concatenation of bits sub-fields

    set res {}
    if {$i<0} {
        set sign -
        set i [expr {abs($i)}]
    } else {
        set sign {}
    }
    while {$i>0} {
        set res [expr {$i%2}]$res
        set i [expr {$i/2}]
    }
    if {$res eq {}} {set res 0}

    if {$width ne {}} {
        append d [string repeat 0 $width] $res
        set res [string range $d [string length $res] end]
    }
    return $sign$res
}