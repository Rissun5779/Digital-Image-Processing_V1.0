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


# $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_multiplexer/altera_nd_mailbox_mutiplexer_top/altera_mailbox_mutiplexer_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# _hw.tcl file for id_mapper_sys
package require -exact qsys 14.0

set_module_property DESCRIPTION ""
set_module_property NAME altera_mailbox_mutiplexer
set_module_property VERSION  18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera Mailbox Multiplexing"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property COMPOSITION_CALLBACK compose
set_module_property opaque_address_map false
set_module_property GROUP "Basic Functions/Configuration and Programming"
set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list

add_display_item "" "Stream Endpoint Information Table" "group" "table"

add_parameter ENDPOINT_INDEX STRING_LIST ep_0
set_parameter_property ENDPOINT_INDEX DISPLAY_NAME {ENDPOINT_INDEX}
set_parameter_property ENDPOINT_INDEX AFFECTS_ELABORATION true
set_parameter_property ENDPOINT_INDEX AFFECTS_GENERATION true
set_parameter_property ENDPOINT_INDEX HDL_PARAMETER false
set_parameter_property ENDPOINT_INDEX GROUP "Stream Endpoint Information Table"
set_parameter_property ENDPOINT_INDEX DESCRIPTION {List of endpoint that have stream interface}

add_parameter HAS_STREAM INTEGER_LIST 1
set_parameter_property HAS_STREAM DISPLAY_NAME {HAS_STREAM}
set_parameter_property HAS_STREAM AFFECTS_ELABORATION true
set_parameter_property HAS_STREAM AFFECTS_GENERATION true
set_parameter_property HAS_STREAM HDL_PARAMETER false
set_parameter_property HAS_STREAM GROUP "Stream Endpoint Information Table"
set_parameter_property HAS_STREAM DESCRIPTION {List of endpoint that have stream interface}

add_parameter CLIENT_ID INTEGER_LIST 14
set_parameter_property CLIENT_ID DISPLAY_NAME {CLIENT_ID}
set_parameter_property CLIENT_ID AFFECTS_ELABORATION true
set_parameter_property CLIENT_ID AFFECTS_GENERATION true
set_parameter_property CLIENT_ID HDL_PARAMETER false
set_parameter_property CLIENT_ID GROUP "Stream Endpoint Information Table"
set_parameter_property CLIENT_ID DESCRIPTION {List of endpoint that have stream interface}

add_parameter STR_MUX_SELECT STRING_LIST  2'b00
set_parameter_property STR_MUX_SELECT DISPLAY_NAME {STR_MUX_SELECT}
set_parameter_property STR_MUX_SELECT AFFECTS_ELABORATION true
set_parameter_property STR_MUX_SELECT AFFECTS_GENERATION true
set_parameter_property STR_MUX_SELECT HDL_PARAMETER false
set_parameter_property STR_MUX_SELECT GROUP "Stream Endpoint Information Table"
set_parameter_property STR_MUX_SELECT DESCRIPTION {The value assigned for multiplexer select}

add_parameter NUM_STR_ENDPOINTS INTEGER 1 ""
set_parameter_property NUM_STR_ENDPOINTS DEFAULT_VALUE 1
set_parameter_property NUM_STR_ENDPOINTS DISPLAY_NAME {NUM_STR_ENDPOINTS}
set_parameter_property NUM_STR_ENDPOINTS TYPE INTEGER
set_parameter_property NUM_STR_ENDPOINTS UNITS None
set_parameter_property NUM_STR_ENDPOINTS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property NUM_STR_ENDPOINTS DESCRIPTION ""
set_parameter_property NUM_STR_ENDPOINTS HDL_PARAMETER false

add_parameter USE_MEMORY_BLOCKS INTEGER 1 ""
set_parameter_property USE_MEMORY_BLOCKS DEFAULT_VALUE 1
set_parameter_property USE_MEMORY_BLOCKS DISPLAY_NAME USE_MEMORY_BLOCKS
set_parameter_property USE_MEMORY_BLOCKS TYPE INTEGER
set_parameter_property USE_MEMORY_BLOCKS UNITS None
set_parameter_property USE_MEMORY_BLOCKS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USE_MEMORY_BLOCKS DESCRIPTION ""
set_parameter_property USE_MEMORY_BLOCKS HDL_PARAMETER true

add_parameter ADDR_W INTEGER 4 ""
set_parameter_property ADDR_W DEFAULT_VALUE 4
set_parameter_property ADDR_W DISPLAY_NAME ADDR_W
set_parameter_property ADDR_W TYPE INTEGER
set_parameter_property ADDR_W UNITS None
set_parameter_property ADDR_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDR_W DESCRIPTION ""
set_parameter_property ADDR_W HDL_PARAMETER true

add_parameter ST_DATA_W INTEGER 32 ""
set_parameter_property ST_DATA_W DEFAULT_VALUE 32
set_parameter_property ST_DATA_W DISPLAY_NAME ST_DATA_W
set_parameter_property ST_DATA_W TYPE INTEGER
set_parameter_property ST_DATA_W UNITS None
set_parameter_property ST_DATA_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ST_DATA_W DESCRIPTION ""
set_parameter_property ST_DATA_W HDL_PARAMETER true

add_parameter DEPTH INTEGER 16 ""
set_parameter_property DEPTH DEFAULT_VALUE 16
set_parameter_property DEPTH DISPLAY_NAME DEPTH
set_parameter_property DEPTH TYPE INTEGER
set_parameter_property DEPTH UNITS None
set_parameter_property DEPTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DEPTH DESCRIPTION ""
set_parameter_property DEPTH HDL_PARAMETER true

add_parameter ID_W INTEGER 4 ""
set_parameter_property ID_W DEFAULT_VALUE 4
set_parameter_property ID_W DISPLAY_NAME ID_W
set_parameter_property ID_W TYPE INTEGER
set_parameter_property ID_W UNITS None
set_parameter_property ID_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ID_W DESCRIPTION ""
set_parameter_property ID_W HDL_PARAMETER true

add_parameter NUM_ENDPOINTS INTEGER 1 ""
set_parameter_property NUM_ENDPOINTS DEFAULT_VALUE 1
set_parameter_property NUM_ENDPOINTS DISPLAY_NAME NUM_ENDPOINTS
set_parameter_property NUM_ENDPOINTS TYPE INTEGER
set_parameter_property NUM_ENDPOINTS UNITS None
set_parameter_property NUM_ENDPOINTS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property NUM_ENDPOINTS DESCRIPTION ""
set_parameter_property NUM_ENDPOINTS HDL_PARAMETER true

proc compose { } {
    set use_memory_blocks   [get_parameter_value USE_MEMORY_BLOCKS]
    set addr_w              [get_parameter_value ADDR_W]
    set st_data_w           [get_parameter_value ST_DATA_W]
    set depth               [get_parameter_value DEPTH]
    set id_w                [get_parameter_value ID_W]
    set num_endpoints       [get_parameter_value NUM_ENDPOINTS]
    set num_str_endpoints       [get_parameter_value NUM_STR_ENDPOINTS]
    set has_stream_list     [get_parameter_value HAS_STREAM ]
    set clientid_list     [get_parameter_value CLIENT_ID ]
    set str_mux_select_list [get_parameter_value STR_MUX_SELECT ]

    # Instances and instance parameters
    # (disabled instances are intentionally culled)
    add_instance clk_bri altera_clock_bridge 18.1
    set_instance_parameter_value clk_bri {EXPLICIT_CLOCK_RATE} {0.0}
    set_instance_parameter_value clk_bri {NUM_CLOCK_OUTPUTS} {1}

    add_instance reset_bri altera_reset_bridge 18.1
    set_instance_parameter_value reset_bri {ACTIVE_LOW_RESET} {0}
    set_instance_parameter_value reset_bri {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset_bri {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset_bri {USE_RESET_REQUEST} {0}

    #add_instance demux altera_merlin_demultiplexer 18.1
    #set_instance_parameter_value demux {ST_DATA_W} $st_data_w
    #set_instance_parameter_value demux {ST_CHANNEL_W} $num_endpoints
    #set_instance_parameter_value demux {NUM_OUTPUTS} $num_endpoints
    #set_instance_parameter_value demux {VALID_WIDTH} {1}
    #set_instance_parameter_value demux {MERLIN_PACKET_FORMAT} {}
    
    add_instance demux altera_nd_hiconnect_demux 18.1
    set_instance_parameter_value demux {ST_DATA_W} $st_data_w
    set_instance_parameter_value demux {ST_CHANNEL_W} $num_endpoints
    set_instance_parameter_value demux {NUM_OUTPUTS} $num_endpoints
    set_instance_parameter_value demux {USE_READY} {1}
    set_instance_parameter_value demux {SELECT_AS_CHANNEL} {1}
    set_instance_parameter_value demux {MERLIN_PACKET_FORMAT} {}

    


    add_instance mux altera_merlin_multiplexer 18.1
    # plus 1 for has_stream bit 
    set_instance_parameter_value mux {ST_DATA_W} $st_data_w
    set_instance_parameter_value mux {ST_CHANNEL_W} $num_endpoints
    set_instance_parameter_value mux {NUM_INPUTS} $num_endpoints
    set_instance_parameter_value mux {PIPELINE_ARB} {1}
    set_instance_parameter_value mux {USE_EXTERNAL_ARB} {0}
    set_instance_parameter_value mux {PKT_TRANS_LOCK} {-1}
    set_instance_parameter_value mux {ARBITRATION_SCHEME} {round-robin}
    set_instance_parameter_value mux {ARBITRATION_SHARES} {1}
    set_instance_parameter_value mux {MERLIN_PACKET_FORMAT} {}

    add_instance nd_mailbox_id_remapper_0 altera_nd_mailbox_id_remapper 18.1
    set_instance_parameter_value nd_mailbox_id_remapper_0 {USE_MEMORY_BLOCKS} $use_memory_blocks
    set_instance_parameter_value nd_mailbox_id_remapper_0 {ADDR_W} $addr_w
    set_instance_parameter_value nd_mailbox_id_remapper_0 {ST_DATA_W} $st_data_w
    set_instance_parameter_value nd_mailbox_id_remapper_0 {IN_ST_DATA_W} $st_data_w
    set_instance_parameter_value nd_mailbox_id_remapper_0 {DEPTH} $depth
    set_instance_parameter_value nd_mailbox_id_remapper_0 {ID_W} $id_w
    set_instance_parameter_value nd_mailbox_id_remapper_0 {NUM_ENDPOINTS} $num_endpoints
    set_instance_parameter_value nd_mailbox_id_remapper_0 {NUM_STR_ENDPOINTS} $num_str_endpoints
    

    for {set i 0} {$i < $num_endpoints} {incr i} {
        set has_stream     [lindex $has_stream_list $i]
        set str_mux_select [lindex $str_mux_select_list $i]
        set client_id      [lindex $clientid_list $i]
        # When there is some streaming endpoint, append these information for ID mapper
        if {$num_str_endpoints == 0} {
            set append_str_info 0
        } else {
            set append_str_info 1
        }
        
        add_instance avst_adap_in_$i altera_nd_mailbox_avst_adap 18.1
        set_instance_parameter_value avst_adap_in_$i {CHANNEL_WIDTH} $num_endpoints
        set_instance_parameter_value avst_adap_in_$i {CHANNEL_VALUE_DEC} [expr $i + 1]
        set_instance_parameter_value avst_adap_in_$i {IN_USE_PACKET} {1}
        set_instance_parameter_value avst_adap_in_$i {OUT_USE_PACKET} {1}
        set_instance_parameter_value avst_adap_in_$i {IN_USE_CHANNEL} {0}
        set_instance_parameter_value avst_adap_in_$i {OUT_USE_CHANNEL} {1}
        set_instance_parameter_value avst_adap_in_$i {HAS_STREAM} $has_stream
        set_instance_parameter_value avst_adap_in_$i {CLIENT_ID} $client_id
        set_instance_parameter_value avst_adap_in_$i {OVERWRITE_CLIENT_ID} {1}
        set_instance_parameter_value avst_adap_in_$i {STR_MUX_SELECT} $str_mux_select
        set_instance_parameter_value avst_adap_in_$i {APPEND_STR_INFO} $append_str_info
        set_instance_parameter_value avst_adap_in_$i {HAS_STREAM} $has_stream
        set_instance_parameter_value avst_adap_in_$i {NUM_STR_ENDPOINTS} $num_str_endpoints
    
        add_instance avst_adap_out_$i altera_nd_mailbox_avst_adap 18.1
        set_instance_parameter_value avst_adap_out_$i {CHANNEL_WIDTH} $num_endpoints
        set_instance_parameter_value avst_adap_out_$i {CHANNEL_VALUE_DEC} [expr $i + 1]
        set_instance_parameter_value avst_adap_out_$i {IN_USE_PACKET} {1}
        set_instance_parameter_value avst_adap_out_$i {OUT_USE_PACKET} {1}
        set_instance_parameter_value avst_adap_out_$i {IN_USE_CHANNEL} {0}
        set_instance_parameter_value avst_adap_out_$i {OUT_USE_CHANNEL} {0}
        set_instance_parameter_value avst_adap_out_$i {HAS_STREAM} 0
        set_instance_parameter_value avst_adap_out_$i {OVERWRITE_CLIENT_ID} {0}
        set_instance_parameter_value avst_adap_out_$i {STR_MUX_SELECT} "1'b0"
        set_instance_parameter_value avst_adap_out_$i {NUM_STR_ENDPOINTS} $num_str_endpoints

        # connections and connection parameters
        add_connection avst_adap_in_$i.out mux.sink$i avalon_streaming
        add_connection demux.src$i avst_adap_out_$i.in avalon_streaming
        add_connection clk_bri.out_clk avst_adap_in_$i.clk clock
        add_connection clk_bri.out_clk avst_adap_out_$i.clk clock
        add_connection reset_bri.out_reset avst_adap_in_$i.reset reset
        add_connection reset_bri.out_reset avst_adap_out_$i.reset reset

        add_interface cmd_in$i avalon_streaming sink
        set_interface_property cmd_in$i EXPORT_OF avst_adap_in_$i.in
        add_interface rsp_out$i avalon_streaming source
        set_interface_property rsp_out$i EXPORT_OF avst_adap_out_$i.out
    }

    add_connection clk_bri.out_clk mux.clk clock
    add_connection clk_bri.out_clk demux.clk clock
    add_connection clk_bri.out_clk reset_bri.clk clock
    add_connection reset_bri.out_reset mux.clk_reset reset
    add_connection reset_bri.out_reset demux.reset reset
    add_connection nd_mailbox_id_remapper_0.rsp_out demux.sink avalon_streaming
    add_connection mux.src nd_mailbox_id_remapper_0.cmd_in avalon_streaming
    add_connection clk_bri.out_clk nd_mailbox_id_remapper_0.clk clock
    add_connection reset_bri.out_reset nd_mailbox_id_remapper_0.reset reset


    # exported interfaces
    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk_bri.in_clk
    add_interface cmd_out avalon_streaming source
    set_interface_property cmd_out EXPORT_OF nd_mailbox_id_remapper_0.cmd_out
    add_interface reset reset sink
    set_interface_property reset EXPORT_OF reset_bri.in_reset
    add_interface rsp_in avalon_streaming sink
    set_interface_property rsp_in EXPORT_OF nd_mailbox_id_remapper_0.rsp_in

    #if {$num_str_endpoints != 0} {
    #    add_interface stream_id_decode avalon_streaming end
    #    add_interface mux_sel_decoded avalon_streaming start
    #    set_interface_property stream_id_decode EXPORT_OF nd_mailbox_id_remapper_0.stream_id_decode
    #    set_interface_property mux_sel_decoded EXPORT_OF nd_mailbox_id_remapper_0.mux_sel_decoded
    #}
}