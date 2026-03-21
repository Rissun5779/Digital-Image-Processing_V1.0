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


# $Id: //acds/rel/18.1std/ip/pgm/altera_config_debug_agent/altera_config_debug_agent_bridge_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $


# 
# altera_config_debug_agent_bridge "Altera Config Debug Agent Bridge" v100.99.98.97
#  2016.04.03.15:59:28
# 
# 

# 
# request TCL package from ACDS 16.0
# 
package require -exact qsys 16.0


# 
# module altera_config_debug_agent_bridge
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_config_debug_agent_bridge
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera Config Debug Agent Bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate

# 
# file sets
# 
add_fileset synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
set_fileset_property synthesis_fileset TOP_LEVEL altera_config_debug_agent_bridge
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL altera_config_debug_agent_bridge
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure
set_fileset_property vhdl_fileset TOP_LEVEL altera_config_debug_agent_bridge

proc synth_callback_procedure { entity_name } {
    add_fileset_file altera_config_debug_agent_bridge.sv SYSTEM_VERILOG PATH "altera_config_debug_agent_bridge.sv"
}


# 
# parameters
# 
# 
# parameters
# 
add_parameter MFR_CODE INTEGER 0 ""
set_parameter_property MFR_CODE DEFAULT_VALUE 0
set_parameter_property MFR_CODE DISPLAY_NAME MFR_CODE
set_parameter_property MFR_CODE TYPE INTEGER
set_parameter_property MFR_CODE UNITS None
set_parameter_property MFR_CODE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MFR_CODE DESCRIPTION ""
set_parameter_property MFR_CODE HDL_PARAMETER true
add_display_item "AvalonST Debug Endpoint Parameters" MFR_CODE parameter
add_parameter TYPE_CODE INTEGER 0 ""
set_parameter_property TYPE_CODE DEFAULT_VALUE 0
set_parameter_property TYPE_CODE DISPLAY_NAME TYPE_CODE
set_parameter_property TYPE_CODE TYPE INTEGER
set_parameter_property TYPE_CODE UNITS None
set_parameter_property TYPE_CODE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property TYPE_CODE DESCRIPTION ""
set_parameter_property TYPE_CODE HDL_PARAMETER true
add_display_item "AvalonST Debug Endpoint Parameters" TYPE_CODE parameter
add_parameter PREFER_HOST STRING JTAG ""
set_parameter_property PREFER_HOST DEFAULT_VALUE JTAG
set_parameter_property PREFER_HOST DISPLAY_NAME PREFER_HOST
set_parameter_property PREFER_HOST WIDTH ""
set_parameter_property PREFER_HOST TYPE STRING
set_parameter_property PREFER_HOST UNITS None
set_parameter_property PREFER_HOST DESCRIPTION ""
set_parameter_property PREFER_HOST HDL_PARAMETER true
add_display_item "AvalonST Debug Endpoint Parameters" PREFER_HOST parameter
add_parameter USE_STREAM INTEGER 0 ""
set_parameter_property USE_STREAM DEFAULT_VALUE 0
set_parameter_property USE_STREAM DISPLAY_NAME USE_STREAM
set_parameter_property USE_STREAM TYPE INTEGER
set_parameter_property USE_STREAM UNITS None
set_parameter_property USE_STREAM ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USE_STREAM DESCRIPTION ""
set_parameter_property USE_STREAM HDL_PARAMETER true
add_display_item "Config Stream Parameters" USE_STREAM parameter
add_parameter USE_OFFLOAD INTEGER 0 ""
set_parameter_property USE_OFFLOAD DEFAULT_VALUE 0
set_parameter_property USE_OFFLOAD DISPLAY_NAME USE_OFFLOAD
set_parameter_property USE_OFFLOAD TYPE INTEGER
set_parameter_property USE_OFFLOAD UNITS None
set_parameter_property USE_OFFLOAD ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USE_OFFLOAD DESCRIPTION ""
set_parameter_property USE_OFFLOAD HDL_PARAMETER true
add_display_item "Config Stream Parameters" USE_OFFLOAD parameter

add_parameter DATA_WIDTH INTEGER 8
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property DATA_WIDTH DERIVED true
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH ENABLED true
set_parameter_property DATA_WIDTH HDL_PARAMETER true
add_display_item "Internal Parameters" DATA_WIDTH parameter
add_parameter CHANNEL_WIDTH INTEGER 0
set_parameter_property CHANNEL_WIDTH AFFECTS_ELABORATION true
set_parameter_property CHANNEL_WIDTH DERIVED true
set_parameter_property CHANNEL_WIDTH ENABLED true
set_parameter_property CHANNEL_WIDTH TYPE INTEGER
set_parameter_property CHANNEL_WIDTH HDL_PARAMETER true
add_display_item "Internal Parameters" CHANNEL_WIDTH parameter
add_parameter EMPTY_WIDTH INTEGER 0
set_parameter_property EMPTY_WIDTH AFFECTS_ELABORATION true
set_parameter_property EMPTY_WIDTH DERIVED true
set_parameter_property EMPTY_WIDTH ENABLED true
set_parameter_property EMPTY_WIDTH TYPE INTEGER
set_parameter_property EMPTY_WIDTH HDL_PARAMETER true
add_display_item "Internal Parameters" EMPTY_WIDTH parameter

# 
# display items
# 
add_display_item "" Debug GROUP ""
add_display_item "" "AvalonST Debug Endpoint Parameters" GROUP ""
add_display_item "" "Config Stream Parameters" GROUP ""
add_display_item "" "Internal Parameters" GROUP ""

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
# connection point h2t
# 
add_interface h2t avalon_streaming end
set_interface_property h2t associatedClock clk
set_interface_property h2t associatedReset reset
set_interface_property h2t dataBitsPerSymbol 8
set_interface_property h2t errorDescriptor ""
set_interface_property h2t firstSymbolInHighOrderBits true
set_interface_property h2t maxChannel 0
set_interface_property h2t readyLatency 0
set_interface_property h2t ENABLED true
set_interface_property h2t EXPORT_OF ""
set_interface_property h2t PORT_NAME_MAP ""
set_interface_property h2t CMSIS_SVD_VARIABLES ""
set_interface_property h2t SVD_ADDRESS_GROUP ""

add_interface_port h2t h2t_ready ready Output 1
add_interface_port h2t h2t_valid valid Input 1
add_interface_port h2t h2t_data data Input 32
add_interface_port h2t h2t_startofpacket startofpacket Input 1
add_interface_port h2t h2t_endofpacket endofpacket Input 1
add_interface_port h2t h2t_empty empty Input 1
set_port_property h2t_empty termination true
add_interface_port h2t h2t_channel channel Input 1
set_port_property h2t_channel termination true

# 
# connection point t2h
# 
add_interface t2h avalon_streaming start
set_interface_property t2h associatedClock clk
set_interface_property t2h associatedReset reset
set_interface_property t2h dataBitsPerSymbol 8
set_interface_property t2h errorDescriptor ""
set_interface_property t2h firstSymbolInHighOrderBits true
set_interface_property t2h maxChannel 0
set_interface_property t2h readyLatency 0
set_interface_property t2h ENABLED true
set_interface_property t2h EXPORT_OF ""
set_interface_property t2h PORT_NAME_MAP ""
set_interface_property t2h CMSIS_SVD_VARIABLES ""
set_interface_property t2h SVD_ADDRESS_GROUP ""

add_interface_port t2h t2h_ready ready Input 1
add_interface_port t2h t2h_valid valid Output 1
add_interface_port t2h t2h_data data Output 32
add_interface_port t2h t2h_startofpacket startofpacket Output 1
add_interface_port t2h t2h_endofpacket endofpacket Output 1
add_interface_port t2h t2h_empty empty Output 1
set_port_property t2h_empty termination true
add_interface_port t2h t2h_channel channel Output 1
set_port_property t2h_channel termination true

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


# 
# connection point urgent
# 
add_interface urgent avalon_streaming start
set_interface_property urgent associatedClock clk
set_interface_property urgent associatedReset reset
set_interface_property urgent dataBitsPerSymbol 32
set_interface_property urgent errorDescriptor ""
set_interface_property urgent firstSymbolInHighOrderBits true
set_interface_property urgent maxChannel 0
set_interface_property urgent readyLatency 0
set_interface_property urgent ENABLED false
set_interface_property urgent EXPORT_OF ""
set_interface_property urgent PORT_NAME_MAP ""
set_interface_property urgent CMSIS_SVD_VARIABLES ""
set_interface_property urgent SVD_ADDRESS_GROUP ""


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

proc elaborate {} {
    set_parameter_value CHANNEL_WIDTH   4
    set_parameter_value DATA_WIDTH      32
    
    set MFR_CODE            [get_parameter_value MFR_CODE]
    set TYPE_CODE           [get_parameter_value TYPE_CODE]
    set PREFER_HOST         [get_parameter_value PREFER_HOST]
    set USE_STREAM          [get_parameter_value USE_STREAM]
    set USE_OFFLOAD         [get_parameter_value USE_OFFLOAD]
    set data_w              [get_parameter_value DATA_WIDTH]
    set channel_w           [get_parameter_value CHANNEL_WIDTH]
    set_parameter_value EMPTY_WIDTH     [expr {[log2 $data_w] - 3} ]

    if {$channel_w > 0} {
        set_interface_property h2t maxChannel [expr {(1 << $channel_w) - 1} ]
        set_port_property h2t_channel width_expr $channel_w
        set_port_property h2t_channel termination false
        set_interface_property t2h maxChannel [expr {(1 << $channel_w) - 1} ]
        set_port_property t2h_channel width_expr $channel_w
        set_port_property t2h_channel termination false
    }

    if {$data_w > 8} {
        set_port_property h2t_empty width_expr [expr {[log2 $data_w] - 3} ]
        set_port_property h2t_empty termination false
        set_port_property t2h_empty width_expr [expr {[log2 $data_w] - 3} ]
        set_port_property t2h_empty termination false
    }

    if {$USE_STREAM != 0} {
        set_interface_property stream ENABLED true
        add_interface_port stream int_stream_ready ready Input 1
        add_interface_port stream int_stream_valid valid Output 1
        add_interface_port stream int_stream_data data Output 32
        set_interface_property stream_active ENABLED true
        add_interface_port stream_active stream_active active Input 1
    }

    # add in mux and demux
    add_hdl_instance demultiplexer altera_merlin_demultiplexer
    set_instance_parameter_value demultiplexer {ST_DATA_W} {32}
    set_instance_parameter_value demultiplexer {ST_CHANNEL_W} {4}
    set_instance_parameter_value demultiplexer {NUM_OUTPUTS} {4}
    set_instance_parameter_value demultiplexer {VALID_WIDTH} {1}

    add_hdl_instance multiplexer altera_merlin_multiplexer
    set_instance_parameter_value multiplexer {ST_DATA_W} {32}
    set_instance_parameter_value multiplexer {ST_CHANNEL_W} {4}
    set_instance_parameter_value multiplexer {NUM_INPUTS} {4}
    set_instance_parameter_value multiplexer {PIPELINE_ARB} {0}
    set_instance_parameter_value multiplexer {USE_EXTERNAL_ARB} {0}
    set_instance_parameter_value multiplexer {PKT_TRANS_LOCK} {-1}
    set_instance_parameter_value multiplexer {ARBITRATION_SCHEME} {round-robin}
    set_instance_parameter_value multiplexer {ARBITRATION_SHARES} {1}
    set_instance_parameter_value multiplexer {MERLIN_PACKET_FORMAT} {}

    add_hdl_instance avst_adap altera_nd_mailbox_avst_adap 
    set_instance_parameter_value avst_adap {APPEND_STR_INFO} {0}
    set_instance_parameter_value avst_adap {HAS_STREAM} {1}
    set_instance_parameter_value avst_adap {STR_MUX_SELECT} {0}
    set_instance_parameter_value avst_adap {NUM_STR_ENDPOINTS} {1}
    set_instance_parameter_value avst_adap {CHANNEL_WIDTH} {4}
    set_instance_parameter_value avst_adap {DATA_WIDTH} {32}
    set_instance_parameter_value avst_adap {CHANNEL_VALUE_DEC} {1}
    set_instance_parameter_value avst_adap {IN_USE_PACKET} {1}
    set_instance_parameter_value avst_adap {OUT_USE_PACKET} {1}
    set_instance_parameter_value avst_adap {IN_USE_CHANNEL} {0}
    set_instance_parameter_value avst_adap {OUT_USE_CHANNEL} {1}


}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}