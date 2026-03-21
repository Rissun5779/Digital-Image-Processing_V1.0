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


# $Id: //acds/rel/18.1std/ip/pgm/altera_s10_mailbox_programmable_client/altera_s10_mailbox_programmable_client_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $


# 
# altera_s10_mailbox_programmable_client "Altera Config Debug Agent Bridge" v100.99.98.97
#  2016.04.03.15:59:28
# 
# 

# 
# request TCL package from ACDS 16.0
# 
package require -exact qsys 16.0
package require -exact altera_terp 1.0
# 
# module altera_s10_mailbox_programmable_client
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_s10_mailbox_programmable_client
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera S10 Mailbox Client Programmable"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list

# 
# parameters
# 
# 
# parameters
# 
add_parameter IDLE_TIME INTEGER 1
set_parameter_property IDLE_TIME DISPLAY_NAME "The number of idle cylcles between each run in continous mode"
set_parameter_property IDLE_TIME AFFECTS_ELABORATION true
set_parameter_property IDLE_TIME AFFECTS_GENERATION false
set_parameter_property IDLE_TIME HDL_PARAMETER true
set_parameter_property IDLE_TIME ALLOWED_RANGES "1:32000"

add_parameter DEBUG INTEGER 0
set_parameter_property DEBUG DISPLAY_NAME "Debug Simulation"
set_parameter_property DEBUG AFFECTS_ELABORATION true
set_parameter_property DEBUG AFFECTS_GENERATION true
set_parameter_property DEBUG HDL_PARAMETER false
set_parameter_property DEBUG VISIBLE true
set_parameter_property DEBUG DISPLAY_HINT "boolean"

add_parameter HAS_URGENT INTEGER 0
set_parameter_property HAS_URGENT ALLOWED_RANGES {0 1}
set_parameter_property HAS_URGENT AFFECTS_ELABORATION true
set_parameter_property HAS_URGENT AFFECTS_GENERATION false
set_parameter_property HAS_URGENT HDL_PARAMETER true
set_parameter_property HAS_URGENT VISIBLE false

add_parameter HAS_STREAM INTEGER 0
set_parameter_property HAS_STREAM ALLOWED_RANGES {0 1}
set_parameter_property HAS_STREAM AFFECTS_ELABORATION true
set_parameter_property HAS_STREAM AFFECTS_GENERATION false
set_parameter_property HAS_STREAM HDL_PARAMETER true
set_parameter_property HAS_STREAM VISIBLE false

add_parameter HAS_OFFLOAD INTEGER 0 ""
set_parameter_property HAS_OFFLOAD DEFAULT_VALUE 0
set_parameter_property HAS_OFFLOAD DISPLAY_NAME HAS_OFFLOAD
set_parameter_property HAS_OFFLOAD TYPE INTEGER
set_parameter_property HAS_OFFLOAD UNITS None
set_parameter_property HAS_OFFLOAD ALLOWED_RANGES {0 1}
set_parameter_property HAS_OFFLOAD DESCRIPTION ""
set_parameter_property HAS_OFFLOAD HDL_PARAMETER true
set_parameter_property HAS_OFFLOAD VISIBLE false

add_display_item "Config Stream Parameters" HAS_STREAM parameter
add_display_item "Config Stream Parameters" HAS_URGENT parameter
add_display_item "Config Stream Parameters" HAS_OFFLOAD parameter

add_parameter CMD_INFO STRING "" 0
set_parameter_property CMD_INFO UNITS None
set_parameter_property CMD_INFO AFFECTS_ELABORATION true
set_parameter_property CMD_INFO AFFECTS_GENERATION true
set_parameter_property CMD_INFO VISIBLE false
set_parameter_property CMD_INFO DERIVED true
add_parameter LENGTH_INFO STRING "" 0
set_parameter_property LENGTH_INFO UNITS None
set_parameter_property LENGTH_INFO AFFECTS_ELABORATION true
set_parameter_property LENGTH_INFO AFFECTS_GENERATION true
set_parameter_property LENGTH_INFO VISIBLE false
set_parameter_property LENGTH_INFO DERIVED true


# add in parameters for perdefined commands
source altera_s10_mailbox_programmable_client_ui.tcl

# 
# display items
# 
add_display_item "" "AvalonST Debug Endpoint Parameters" GROUP ""
add_display_item "" "Config Stream Parameters" GROUP ""
add_display_item "" "Internal Parameters" GROUP ""
#*-*-*-**-*-*-**-*-*-*
# Commands Tab
#*-*-*-**-*-*-**-*-*-*
add_display_item "" "Commands" GROUP TAB
add_display_item "Commands" "ID0" GROUP TAB
add_display_item "ID0" "Command 0 Header" GROUP 
add_display_item "ID0" "Command 0 Argument" GROUP 
add_display_item "Commands" "ID1" GROUP TAB
add_display_item "ID1" "Command 1 Header" GROUP 
add_display_item "ID1" "Command 1 Argument" GROUP 
add_display_item "Commands" "ID2" GROUP TAB
add_display_item "ID2" "Command 2 Header" GROUP 
add_display_item "ID2" "Command 2 Argument" GROUP 
add_display_item "Commands" "ID3" GROUP TAB
add_display_item "ID3" "Command 3 Header" GROUP 
add_display_item "ID3" "Command 3 Argument" GROUP 
add_display_item "Commands" "ID4" GROUP TAB
add_display_item "ID4" "Command 4 Header" GROUP 
add_display_item "ID4" "Command 4 Argument" GROUP 
add_display_item "Commands" "ID5" GROUP TAB
add_display_item "ID5" "Command 5 Header" GROUP 
add_display_item "ID5" "Command 5 Argument" GROUP 
add_display_item "Commands" "ID6" GROUP TAB
add_display_item "ID6" "Command 6 Header" GROUP 
add_display_item "ID6" "Command 6 Argument" GROUP 
add_display_item "Commands" "ID7" GROUP TAB
add_display_item "ID7" "Command 7 Header" GROUP 
add_display_item "ID7" "Command 7 Argument" GROUP 
add_display_item "Commands" "ID8" GROUP TAB
add_display_item "ID8" "Command 8 Header" GROUP 
add_display_item "ID8" "Command 8 Argument" GROUP 
add_display_item "Commands" "ID9" GROUP TAB
add_display_item "ID9" "Command 9 Header" GROUP 
add_display_item "ID9" "Command 9 Argument" GROUP 
add_display_item "Commands" "ID10" GROUP TAB
add_display_item "ID10" "Command 10 Header" GROUP 
add_display_item "ID10" "Command 10 Argument" GROUP 
add_display_item "Commands" "ID11" GROUP TAB
add_display_item "ID11" "Command 11 Header" GROUP 
add_display_item "ID11" "Command 11 Argument" GROUP 
add_display_item "Commands" "ID12" GROUP TAB
add_display_item "ID12" "Command 12 Header" GROUP 
add_display_item "ID12" "Command 12 Argument" GROUP 
add_display_item "Commands" "ID13" GROUP TAB
add_display_item "ID13" "Command 13 Header" GROUP 
add_display_item "ID13" "Command 13 Argument" GROUP 
add_display_item "Commands" "ID14" GROUP TAB
add_display_item "ID14" "Command 14 Header" GROUP 
add_display_item "ID14" "Command 14 Argument" GROUP 
add_display_item "Commands" "ID15" GROUP TAB
add_display_item "ID15" "Command 15 Header" GROUP 
add_display_item "ID15" "Command 15 Argument" GROUP 

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
# connection point command
# 
add_interface start conduit start
set_interface_property start associatedClock clk
set_interface_property start associatedReset reset

add_interface_port start start start Input 1

add_interface busy conduit busy
set_interface_property busy associatedClock clk
set_interface_property busy associatedReset reset

add_interface_port busy busy busy Output 1


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

add_interface_port rsp rsp_ready ready Input 1
add_interface_port rsp rsp_valid valid Output 1
add_interface_port rsp rsp_data data Output 32
add_interface_port rsp rsp_channel channel Output 4
add_interface_port rsp rsp_startofpacket startofpacket Output 1
add_interface_port rsp rsp_endofpacket endofpacket Output 1

# 
# connection point urgent
# 
add_interface urgent avalon_streaming start
set_interface_property urgent dataBitsPerSymbol 32
set_interface_property urgent associatedClock clk
set_interface_property urgent associatedReset reset
set_interface_property urgent ENABLED false

# 
# connection point stream
# 
add_interface stream avalon_streaming start
set_interface_property stream associatedClock clk
set_interface_property stream associatedReset reset
set_interface_property stream dataBitsPerSymbol 32
set_interface_property stream errorDescriptor ""
set_interface_property stream firstSymbolInHighOrderBits true
set_interface_property stream maxChannel 0
set_interface_property stream readyLatency 0
set_interface_property stream ENABLED false
set_interface_property stream EXPORT_OF ""
set_interface_property stream PORT_NAME_MAP ""
set_interface_property stream CMSIS_SVD_VARIABLES ""
set_interface_property stream SVD_ADDRESS_GROUP ""


# 
# connection point stream_active
# 
add_interface stream_active conduit end
set_interface_property stream_active associatedClock clk
set_interface_property stream_active associatedReset reset
set_interface_property stream_active ENABLED false
set_interface_property stream_active EXPORT_OF ""
set_interface_property stream_active PORT_NAME_MAP ""
set_interface_property stream_active CMSIS_SVD_VARIABLES ""
set_interface_property stream_active SVD_ADDRESS_GROUP ""

# 
# file sets
# 
add_fileset my_synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
add_fileset my_synthesis_fileset SIM_VERILOG synth_callback_procedure
add_fileset my_synthesis_fileset SIM_VHDL synth_callback_procedure

proc synth_callback_procedure { entity_name } {

    set this_dir      [ get_module_property MODULE_DIRECTORY ]
    set template_file [ file join $this_dir "altera_s10_mailbox_programmable_client.sv.terp" ]


    set template_fh [ open $template_file r ]
    set template    [ read $template_fh ]
    close $template_fh


    #set params(pkt_addr_h)    [ get_parameter_value PKT_ADDR_H ]

    set params(output_name) $entity_name

    set params(cmd_info)    [ get_parameter_value CMD_INFO ]
    set params(length_info) [ get_parameter_value LENGTH_INFO ]
    set params(debug)       [ get_parameter_value DEBUG ]

    set result          [ altera_terp $template params ]
    set output_file     [ create_temp_file ${entity_name}.sv ]
    set output_handle   [ open $output_file w ]

    puts $output_handle $result
    close $output_handle

    add_fileset_file ${entity_name}.sv SYSTEM_VERILOG PATH ${output_file}

}     


proc validate {} {
    set enable_list ""
    set channel_list ""
    set length_list ""
    set header_list ""
    set cmd_arg_list ""
    for {set i 0} {$i < 16} {incr i} {
        #set enable_$i  [ get_parameter_value ENABLE_$i ]
        lappend enable_list     [ get_parameter_value ENABLE_$i ]
        lappend channel_list    [ get_parameter_value CHANNEL_$i ]
        lappend length_list     [ get_parameter_value LENGTH_$i ]
        lappend cmd_arg_list    [ get_parameter_value cmd_arg_$i]
        set channel($i)          [dec2bin [ get_parameter_value CHANNEL_$i] 4]
        set length($i)           [dec2bin [ get_parameter_value LENGTH_$i]  11]
        set id($i)               [dec2bin $i 4]
        set command_code($i)     [dec2bin [get_parameter_value COMMAND_CODE_$i] 11]
        set cmd_arg($i)          [ get_parameter_value cmd_arg_$i]
        append header($i) $channel($i) $id($i) 0 $length($i) 0 $command_code($i)
        
        set_parameter_value HEADER_$i $header($i)
    }
    
    set cmd_info ""
    set length_info ""
    set cmd_info_each ""
    for {set i 0} {$i < 16} {incr i} {
        if {[lindex $enable_list $i] == 1} {
            set length_value [get_parameter_value LENGTH_$i]
            if { ! [ string equal "" $length_info ] } {
                set length_info "$length_info $length_value"
            } else {
                set length_info $length_value
            }

            foreach arg $cmd_arg($i) {
                lappend arg_list($i) $arg
            }

            if {[lindex $length_list $i] == 0} {
                set cmd_info_each $header($i)
            } else {
                #set cmd_info_each "$header($i) $cmd_arg($i)"
                set cmd_info_each "$header($i) $arg_list($i)"
            }
            if { ! [ string equal "" $cmd_info ] } {
                set cmd_info "$cmd_info,$cmd_info_each"
            } else {
                set cmd_info $cmd_info_each
            }
            # Checking the length and number of augrments, should be same
            if {[lindex $length_list $i] != [llength $cmd_arg($i)]} {
                send_message {error} "Command ID $i: length value and number of arugments is not same"
            }

        }

    }

    set edited_cmd_info ""
    set cmd_list    [ split $cmd_info , ]
    set num_command     [llength $cmd_list]
    for {set k 0} {$k < $num_command} {incr k} {
        set this_cmd_length [lindex $length_info $k]
        set this_cmd_info   [lindex $cmd_list $k]
        set this_cmd_detail [ split $this_cmd_info ]
        set numb_words_in_this_cmd [llength $this_cmd_detail]

        send_message {info} "this_cmd_info: $this_cmd_info"
        send_message {info} "this_cmd_length: $this_cmd_length"
        send_message {info} "this_cmd_detail: $this_cmd_detail"
        
        if  {$this_cmd_length == 0} {
            lappend edited_cmd_info 34'b11[lindex $this_cmd_detail 0]
        } else {
            for {set l 0} {$l < $numb_words_in_this_cmd} {incr l} {
                # Some case not all a 8 bytes, make it fix 8 bytes
                set arg_length [string length [lindex $this_cmd_detail $l]]
                set zeropad ""
                if {$l != 0} {
                    if {$arg_length <= 8} {
                        for {set m 0} {$m < [expr 8 - $arg_length]} {incr m} {
                            append zeropad "0"
                        }
                    } else {
                        send_message {error} "Command ID $l: arugment [lindex $this_cmd_detail $l] has length more than 8 bytes (32bits)"
                    }
                }
                # add sop and eop infomration to each word
                if {$l == 0} {
                    lappend edited_cmd_info 34'b10[lindex $this_cmd_detail $l]
                } elseif {$l == [expr $numb_words_in_this_cmd - 1]} {
                    lappend edited_cmd_info 34'h1$zeropad[lindex $this_cmd_detail $l]
                } else {
                    lappend edited_cmd_info 34'h0$zeropad[lindex $this_cmd_detail $l]
                }
            }
        }
        #send_message {info} "zeropad: $zeropad"
    }
    set_parameter_value CMD_INFO $edited_cmd_info
    set_parameter_value LENGTH_INFO $length_info
    #set each_command_info    [ split $command_info  ]


    
    send_message {info} "num_command: $num_command"
    send_message {info} "edited_cmd_info: $edited_cmd_info"
    send_message {info} "edited_cmd_info: [llength $edited_cmd_info]"
    #send_message {info} "each_command_info: [llength $each_command_info]"

    #set test [dec2bin 3 12]
    #send_message {info} "test: $test"
    send_message {info} "cmd_info: $cmd_info"
    send_message {info} "length_info: $length_info"
    #send_message {info} "header_0: $header(0)"
    #send_message {info} "length_0: $length(0)"

    send_message {info} "enable_list: $enable_list"
    #send_message {info} "channel_list: $channel_list"
    #send_message {info} "length_list: $length_list"
    #send_message {info} "cmd_arg_list: $cmd_arg_list"
}

proc elaborate {} {
    #add_parameter           ENABLE_0   BOOLEAN        false
    #add_parameter           CHANNEL_0   INTEGER             1
    #add_parameter           LENGTH_0    INTEGER             0
    #add_parameter           COMMAND_CODE_0  INTEGER             0
    #add_parameter           CMD_ARG_0   INTEGER_LIST        0
    
    set enable_0  [get_parameter_value ENABLE_0]
    set channel_0 [get_parameter_value CHANNEL_0]
    set length_0  [get_parameter_value LENGTH_0]
    set command_code_0 [get_parameter_value COMMAND_CODE_0]
    set cmd_arg_0 [get_parameter_value CMD_ARG_0]
    set debug [get_parameter_value DEBUG]

    send_message {info} "cmd_arg_0: $cmd_arg_0"

    set HAS_STREAM          [get_parameter_value HAS_STREAM]
    set HAS_URGENT          [get_parameter_value HAS_URGENT]
    set HAS_OFFLOAD         [get_parameter_value HAS_OFFLOAD]


    if {$HAS_STREAM != 0} {
        set_interface_property stream ENABLED true
        add_interface_port stream int_stream_ready ready Input 1
        add_interface_port stream int_stream_valid valid Output 1
        add_interface_port stream int_stream_data data Output 32
        set_interface_property stream_active ENABLED true
        add_interface_port stream_active stream_active active Input 1
    }

    if {$HAS_URGENT != 0} {
        set_interface_property urgent ENABLED true
        add_interface_port  urgent urgent_ready ready Input 1
        add_interface_port  urgent urgent_valid valid Output 1
        add_interface_port  urgent urgent_data data Output 32
    }
    if {$debug == 0} {
        set_interface_property stream_active ENABLED false
        set_interface_property urgent ENABLED false
        # add the config stream endpoint instance
        add_hdl_instance config_stream_ep altera_config_stream_endpoint 
        set_instance_parameter_value config_stream_ep HAS_URGENT 0
        set_instance_parameter_value config_stream_ep HAS_STREAM 0
    } else {
        # 
        # connection point command
        # 
        add_interface command avalon_streaming start
        set_interface_property command associatedClock clk
        set_interface_property command associatedReset reset
        set_interface_property command dataBitsPerSymbol 32
        set_interface_property command errorDescriptor ""
        set_interface_property command firstSymbolInHighOrderBits true
        set_interface_property command maxChannel 0
        set_interface_property command readyLatency 0
        set_interface_property command ENABLED true
        set_interface_property command EXPORT_OF ""
        set_interface_property command PORT_NAME_MAP ""
        set_interface_property command CMSIS_SVD_VARIABLES ""
        set_interface_property command SVD_ADDRESS_GROUP ""
        
        add_interface_port command command_ready ready Input 1
        add_interface_port command command_valid valid Output 1
        add_interface_port command command_data data Output 32
        add_interface_port command command_startofpacket startofpacket Output 1
        add_interface_port command command_endofpacket endofpacket Output 1
        
        
        # 
        # connection point response
        # 
        add_interface response avalon_streaming end
        set_interface_property response associatedClock clk
        set_interface_property response associatedReset reset
        set_interface_property response dataBitsPerSymbol 32
        set_interface_property response errorDescriptor ""
        set_interface_property response firstSymbolInHighOrderBits true
        set_interface_property response maxChannel 0
        set_interface_property response readyLatency 0
        set_interface_property response ENABLED true
        set_interface_property response EXPORT_OF ""
        set_interface_property response PORT_NAME_MAP ""
        set_interface_property response CMSIS_SVD_VARIABLES ""
        set_interface_property response SVD_ADDRESS_GROUP ""
        
        add_interface_port response response_ready ready Output 1
        add_interface_port response response_valid valid Input 1
        add_interface_port response response_data data Input 32
        add_interface_port response response_startofpacket startofpacket Input 1
        add_interface_port response response_endofpacket endofpacket Input 1
    }   


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