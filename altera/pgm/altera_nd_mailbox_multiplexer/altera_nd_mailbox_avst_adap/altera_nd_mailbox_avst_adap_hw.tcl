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



# $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_multiplexer/altera_nd_mailbox_avst_adap/altera_nd_mailbox_avst_adap_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# 
# altera_nd_mailbox_avst_adap "Altera Mailbox AVST adapt" v1.0
#  2015.10.11.15:54:58
# Write fixed value to channel at output, set some default values
# 

# 
# request TCL package from ACDS 16.0
# 
package require -exact qsys 16.0


# 
# module altera_nd_mailbox_avst_adap
# 
set_module_property DESCRIPTION "Write fixed value to channel at output, set some default values"
set_module_property NAME altera_nd_mailbox_avst_adap
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera Mailbox AVST adapt"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate

set_module_property GROUP "Basic Functions/Configuration and Programming"
set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_nd_mailbox_avst_adap
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file altera_nd_mailbox_avst_adap.sv VERILOG PATH altera_nd_mailbox_avst_adap.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_nd_mailbox_avst_adap
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file altera_nd_mailbox_avst_adap.sv VERILOG PATH altera_nd_mailbox_avst_adap.sv


# 
# parameters
# 
add_parameter APPEND_STR_INFO INTEGER 0
set_parameter_property APPEND_STR_INFO DISPLAY_NAME {APPEND_STR_INFO}
set_parameter_property APPEND_STR_INFO AFFECTS_ELABORATION true
set_parameter_property APPEND_STR_INFO AFFECTS_GENERATION true
set_parameter_property APPEND_STR_INFO HDL_PARAMETER true
set_parameter_property APPEND_STR_INFO GROUP "Stream Endpoint Information"
set_parameter_property APPEND_STR_INFO DESCRIPTION {Append streaming client Information into the packet}

add_parameter HAS_STREAM INTEGER 1
set_parameter_property HAS_STREAM DISPLAY_NAME {HAS_STREAM}
set_parameter_property HAS_STREAM AFFECTS_ELABORATION true
set_parameter_property HAS_STREAM AFFECTS_GENERATION true
set_parameter_property HAS_STREAM HDL_PARAMETER true
set_parameter_property HAS_STREAM GROUP "Stream Endpoint Information"
set_parameter_property HAS_STREAM DESCRIPTION {List of endpoint that have stream interface}

add_parameter CLIENT_ID INTEGER 14
set_parameter_property CLIENT_ID DISPLAY_NAME {CLIENT_ID}
set_parameter_property CLIENT_ID AFFECTS_ELABORATION true
set_parameter_property CLIENT_ID AFFECTS_GENERATION true
set_parameter_property CLIENT_ID HDL_PARAMETER true
set_parameter_property CLIENT_ID GROUP "Stream Endpoint Information"
set_parameter_property CLIENT_ID DESCRIPTION {List of endpoint that have stream interface}

add_parameter STR_MUX_SELECT STD_LOGIC_VECTOR 
set_parameter_property STR_MUX_SELECT DISPLAY_NAME {STR_MUX_SELECT}
set_parameter_property STR_MUX_SELECT AFFECTS_ELABORATION true
set_parameter_property STR_MUX_SELECT AFFECTS_GENERATION true
set_parameter_property STR_MUX_SELECT HDL_PARAMETER true
set_parameter_property STR_MUX_SELECT GROUP "Stream Endpoint Information"
set_parameter_property STR_MUX_SELECT WIDTH 16
set_parameter_property STR_MUX_SELECT DESCRIPTION {The value assigned for multiplexer select}

add_parameter NUM_STR_ENDPOINTS INTEGER 1 ""
set_parameter_property NUM_STR_ENDPOINTS DEFAULT_VALUE 1
set_parameter_property NUM_STR_ENDPOINTS DISPLAY_NAME {NUM_STR_ENDPOINTS}
set_parameter_property NUM_STR_ENDPOINTS TYPE INTEGER
set_parameter_property NUM_STR_ENDPOINTS UNITS None
set_parameter_property NUM_STR_ENDPOINTS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property NUM_STR_ENDPOINTS DESCRIPTION ""
set_parameter_property NUM_STR_ENDPOINTS GROUP "Stream Endpoint Information"
set_parameter_property NUM_STR_ENDPOINTS HDL_PARAMETER true

add_parameter CHANNEL_WIDTH INTEGER 1 ""
set_parameter_property CHANNEL_WIDTH DEFAULT_VALUE 1
set_parameter_property CHANNEL_WIDTH DISPLAY_NAME CHANNEL_WIDTH
set_parameter_property CHANNEL_WIDTH TYPE INTEGER
set_parameter_property CHANNEL_WIDTH UNITS None
set_parameter_property CHANNEL_WIDTH ALLOWED_RANGES 0:16
set_parameter_property CHANNEL_WIDTH DESCRIPTION ""
set_parameter_property CHANNEL_WIDTH HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 1 ""
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH DESCRIPTION ""
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_parameter OUT_DATA_WIDTH INTEGER 1 ""
set_parameter_property OUT_DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property OUT_DATA_WIDTH DISPLAY_NAME OUT_DATA_WIDTH
set_parameter_property OUT_DATA_WIDTH TYPE INTEGER
set_parameter_property OUT_DATA_WIDTH UNITS None
set_parameter_property OUT_DATA_WIDTH DESCRIPTION ""
set_parameter_property OUT_DATA_WIDTH DERIVED true
set_parameter_property OUT_DATA_WIDTH HDL_PARAMETER true


add_parameter CHANNEL_VALUE_DEC INTEGER 1 ""
set_parameter_property CHANNEL_VALUE_DEC DEFAULT_VALUE 1
set_parameter_property CHANNEL_VALUE_DEC DISPLAY_NAME CHANNEL_VALUE_DEC
set_parameter_property CHANNEL_VALUE_DEC TYPE INTEGER
set_parameter_property CHANNEL_VALUE_DEC UNITS None
set_parameter_property CHANNEL_VALUE_DEC ALLOWED_RANGES -2147483648:2147483647
set_parameter_property CHANNEL_VALUE_DEC DESCRIPTION ""
set_parameter_property CHANNEL_VALUE_DEC HDL_PARAMETER true

add_parameter CHANNEL_VALUE_ONEHOT STD_LOGIC_VECTOR  
set_parameter_property CHANNEL_VALUE_ONEHOT DISPLAY_NAME CHANNEL_VALUE_ONEHOT
set_parameter_property CHANNEL_VALUE_ONEHOT TYPE STD_LOGIC_VECTOR   
set_parameter_property CHANNEL_VALUE_ONEHOT UNITS None
set_parameter_property CHANNEL_VALUE_ONEHOT DESCRIPTION ""
set_parameter_property CHANNEL_VALUE_ONEHOT HDL_PARAMETER true
set_parameter_property CHANNEL_VALUE_ONEHOT DERIVED true
set_parameter_property CHANNEL_VALUE_ONEHOT WIDTH 16

add_parameter IN_USE_PACKET INTEGER 1 ""
set_parameter_property IN_USE_PACKET DEFAULT_VALUE 1
set_parameter_property IN_USE_PACKET DISPLAY_NAME IN_USE_PACKET
set_parameter_property IN_USE_PACKET TYPE INTEGER
set_parameter_property IN_USE_PACKET UNITS None
set_parameter_property IN_USE_PACKET ALLOWED_RANGES -2147483648:2147483647
set_parameter_property IN_USE_PACKET DESCRIPTION ""
set_parameter_property IN_USE_PACKET HDL_PARAMETER true

add_parameter OUT_USE_PACKET INTEGER 1 ""
set_parameter_property OUT_USE_PACKET DEFAULT_VALUE 1
set_parameter_property OUT_USE_PACKET DISPLAY_NAME OUT_USE_PACKET
set_parameter_property OUT_USE_PACKET TYPE INTEGER
set_parameter_property OUT_USE_PACKET UNITS None
set_parameter_property OUT_USE_PACKET ALLOWED_RANGES -2147483648:2147483647
set_parameter_property OUT_USE_PACKET DESCRIPTION ""
set_parameter_property OUT_USE_PACKET HDL_PARAMETER true

add_parameter IN_USE_CHANNEL INTEGER 1 ""
set_parameter_property IN_USE_CHANNEL DEFAULT_VALUE 1
set_parameter_property IN_USE_CHANNEL DISPLAY_NAME IN_USE_CHANNEL
set_parameter_property IN_USE_CHANNEL TYPE INTEGER
set_parameter_property IN_USE_CHANNEL UNITS None
set_parameter_property IN_USE_CHANNEL ALLOWED_RANGES -2147483648:2147483647
set_parameter_property IN_USE_CHANNEL DESCRIPTION ""
set_parameter_property IN_USE_CHANNEL HDL_PARAMETER true

add_parameter OUT_USE_CHANNEL INTEGER 1 ""
set_parameter_property OUT_USE_CHANNEL DEFAULT_VALUE 1
set_parameter_property OUT_USE_CHANNEL DISPLAY_NAME OUT_USE_CHANNEL
set_parameter_property OUT_USE_CHANNEL TYPE INTEGER
set_parameter_property OUT_USE_CHANNEL UNITS None
set_parameter_property OUT_USE_CHANNEL ALLOWED_RANGES -2147483648:2147483647
set_parameter_property OUT_USE_CHANNEL DESCRIPTION ""
set_parameter_property OUT_USE_CHANNEL HDL_PARAMETER true

add_parameter OVERWRITE_CLIENT_ID INTEGER 0 ""
set_parameter_property OVERWRITE_CLIENT_ID DEFAULT_VALUE 0
set_parameter_property OVERWRITE_CLIENT_ID DISPLAY_NAME OVERWRITE_CLIENT_ID
set_parameter_property OVERWRITE_CLIENT_ID TYPE INTEGER
set_parameter_property OVERWRITE_CLIENT_ID UNITS None
set_parameter_property OVERWRITE_CLIENT_ID ALLOWED_RANGES 0:1
set_parameter_property OVERWRITE_CLIENT_ID DESCRIPTION ""
set_parameter_property OVERWRITE_CLIENT_ID HDL_PARAMETER true

# 
# display items
# 


# 
# connection point in
# 
add_interface in avalon_streaming end
set_interface_property in associatedClock clk
set_interface_property in associatedReset reset
set_interface_property in dataBitsPerSymbol 32
set_interface_property in errorDescriptor ""
set_interface_property in firstSymbolInHighOrderBits true
set_interface_property in maxChannel 0
set_interface_property in readyLatency 0
set_interface_property in ENABLED true
set_interface_property in EXPORT_OF ""
set_interface_property in PORT_NAME_MAP ""
set_interface_property in CMSIS_SVD_VARIABLES ""
set_interface_property in SVD_ADDRESS_GROUP ""

#add_interface_port in in_data data Input 32
add_interface_port in in_ready ready Output 1
add_interface_port in in_valid valid Input 1

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
# connection point out
# 
add_interface out avalon_streaming start
set_interface_property out associatedClock clk
set_interface_property out associatedReset reset
set_interface_property out dataBitsPerSymbol 32
set_interface_property out errorDescriptor ""
set_interface_property out firstSymbolInHighOrderBits true
set_interface_property out maxChannel 0
set_interface_property out readyLatency 0
set_interface_property out ENABLED true
set_interface_property out EXPORT_OF ""
set_interface_property out PORT_NAME_MAP ""
set_interface_property out CMSIS_SVD_VARIABLES ""
set_interface_property out SVD_ADDRESS_GROUP ""

add_interface_port out out_ready ready Input 1
add_interface_port out out_valid valid Output 1
#add_interface_port out out_data data Output 32

proc elaborate {} {
    set append_str_info      [get_parameter_value "APPEND_STR_INFO"]
    set num_str_endpoints    [get_parameter_value "NUM_STR_ENDPOINTS"]
    set in_channel_width     [ get_parameter_value "CHANNEL_WIDTH" ]
    set data_width           [ get_parameter_value "DATA_WIDTH" ]
    set channel_value_dec    [ get_parameter_value "CHANNEL_VALUE_DEC" ]
    set in_use_packets       [ get_parameter_value "IN_USE_PACKET" ]
    set out_use_packets      [ get_parameter_value "OUT_USE_PACKET" ]
    set channel_value_onehot [dec2bin $channel_value_dec $in_channel_width]
    #set the value to fixed channel
    set_parameter_value CHANNEL_VALUE_ONEHOT $channel_value_onehot
    send_message info  "channel_value_onehot: ($channel_value_onehot)"        

    set in_use_channel       [get_parameter_value "IN_USE_CHANNEL"]
    set out_use_channel      [get_parameter_value "OUT_USE_CHANNEL"]
    # turn off channel if do not use
    #if { $in_use_channel == 1 } {
    #    add_interface_port in in_channel channel Input $in_channel_width
    #}
    add_interface_port in in_channel channel Input $in_channel_width
    add_interface_port out out_channel channel Output $in_channel_width
    if { $in_use_channel == 0 } {
        set_port_property in_channel TERMINATION true
    } 
    if { $out_use_channel == 0 } {
        set_port_property out_channel TERMINATION true  
    }
    
    add_interface_port in in_sop startofpacket  Input 1
    add_interface_port in in_eop endofpacket    Input 1
    # turn off packet signals if do not use
    if { $in_use_packets == 0 } {
        set_port_property in_sop TERMINATION true
        set_port_property in_eop TERMINATION true
    } 
    add_interface_port out out_sop startofpacket Output 1
    add_interface_port out out_eop endofpacket Output 1
    if { $out_use_packets == 0 } {
        set_port_property out_sop TERMINATION true
        set_port_property out_eop TERMINATION true
    }
    # Set data width
    set_interface_property in dataBitsPerSymbol $data_width
    add_interface_port in in_data data Input    $data_width
    if {$append_str_info == 1} {
        # plus 1 for HAS_STREAM bit 
        set_parameter_value OUT_DATA_WIDTH $data_width
        set_interface_property out dataBitsPerSymbol $data_width
        add_interface_port out out_data data Output $data_width
    } else {
        set_parameter_value OUT_DATA_WIDTH $data_width
        set_interface_property out dataBitsPerSymbol $data_width
        add_interface_port out out_data data Output $data_width
    }


}

proc dec2bin {i {width {}}} {
    set res {1}
    for {set j 1} {$j < $i} {incr j} {
        append res 0
    }

    if {$width != {}} {
        append d [string repeat 0 $width] $res
        set res [string range $d [string length $res] end]
    }
    return $width'b$res
}