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

set_module_property DESCRIPTION ""
set_module_property NAME altera_nd_mailbox_urgent_multiplexer
set_module_property VERSION  18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Altera Mailbox Urgent Packet Multiplexer"
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

add_parameter PIPELINE_ARB INTEGER 1 ""
set_parameter_property PIPELINE_ARB DEFAULT_VALUE 1
set_parameter_property PIPELINE_ARB DISPLAY_NAME PIPELINE_ARB
set_parameter_property PIPELINE_ARB TYPE INTEGER
set_parameter_property PIPELINE_ARB UNITS None
set_parameter_property PIPELINE_ARB ALLOWED_RANGES 0:1
set_parameter_property PIPELINE_ARB DESCRIPTION ""
set_parameter_property PIPELINE_ARB HDL_PARAMETER true
add_parameter NUM_ENDPOINTS INTEGER 1 ""
set_parameter_property NUM_ENDPOINTS DEFAULT_VALUE 1
set_parameter_property NUM_ENDPOINTS DISPLAY_NAME NUM_ENDPOINTS
set_parameter_property NUM_ENDPOINTS TYPE INTEGER
set_parameter_property NUM_ENDPOINTS UNITS None
set_parameter_property NUM_ENDPOINTS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property NUM_ENDPOINTS DESCRIPTION ""
set_parameter_property NUM_ENDPOINTS HDL_PARAMETER true

proc compose { } {
    # Instances and instance parameters
    # (disabled instances are intentionally culled)
    set num_endpoints       [get_parameter_value NUM_ENDPOINTS]
    set pipeline_arb        [get_parameter_value PIPELINE_ARB]

    add_instance reset_bridge altera_reset_bridge 18.1
    set_instance_parameter_value reset_bridge {ACTIVE_LOW_RESET} {0}
    set_instance_parameter_value reset_bridge {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset_bridge {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset_bridge {USE_RESET_REQUEST} {0}

    add_instance clk_bridge altera_clock_bridge 18.1
    set_instance_parameter_value clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
    set_instance_parameter_value clk_bridge {NUM_CLOCK_OUTPUTS} {1}

    # These are input adapters
    for {set i 0} {$i < $num_endpoints} {incr i} {
        add_instance urg_pck_avst_adap_$i altera_nd_mailbox_avst_adap 18.1
        set_instance_parameter_value urg_pck_avst_adap_$i {CHANNEL_WIDTH} $num_endpoints
        set_instance_parameter_value urg_pck_avst_adap_$i {CHANNEL_VALUE_DEC} [expr $i + 1]
        set_instance_parameter_value urg_pck_avst_adap_$i {IN_USE_PACKET} {0}
        set_instance_parameter_value urg_pck_avst_adap_$i {OUT_USE_PACKET} {1}
        set_instance_parameter_value urg_pck_avst_adap_$i {IN_USE_CHANNEL} {0}
        set_instance_parameter_value urg_pck_avst_adap_$i {OUT_USE_CHANNEL} {1}
    }

    add_instance urg_multiplexer altera_merlin_multiplexer 18.1
    set_instance_parameter_value urg_multiplexer {ST_DATA_W} {32}
    set_instance_parameter_value urg_multiplexer {ST_CHANNEL_W} $num_endpoints
    set_instance_parameter_value urg_multiplexer {NUM_INPUTS} $num_endpoints
    set_instance_parameter_value urg_multiplexer {PIPELINE_ARB} $pipeline_arb
    set_instance_parameter_value urg_multiplexer {USE_EXTERNAL_ARB} {0}
    set_instance_parameter_value urg_multiplexer {PKT_TRANS_LOCK} {-1}
    set_instance_parameter_value urg_multiplexer {ARBITRATION_SCHEME} {round-robin}
    set_instance_parameter_value urg_multiplexer {ARBITRATION_SHARES} {1}
    set_instance_parameter_value urg_multiplexer {MERLIN_PACKET_FORMAT} {}

    # This adapter is at the output of the mux, just clear the channel port as the urgent does not need channel
    add_instance urg_pck_avst_adap_out altera_nd_mailbox_avst_adap 18.1
    set_instance_parameter_value urg_pck_avst_adap_out {CHANNEL_WIDTH} $num_endpoints
    set_instance_parameter_value urg_pck_avst_adap_out {CHANNEL_VALUE_DEC} $num_endpoints
    set_instance_parameter_value urg_pck_avst_adap_out {IN_USE_PACKET} {1}
    set_instance_parameter_value urg_pck_avst_adap_out {OUT_USE_PACKET} {1}
    set_instance_parameter_value urg_pck_avst_adap_out {IN_USE_CHANNEL} {1}
    set_instance_parameter_value urg_pck_avst_adap_out {OUT_USE_CHANNEL} {0}

    
    # connections and connection parameters
    add_connection clk_bridge.out_clk reset_bridge.clk clock
    add_connection clk_bridge.out_clk urg_multiplexer.clk clock
    add_connection clk_bridge.out_clk urg_pck_avst_adap_out.clk clock
    add_connection reset_bridge.out_reset urg_multiplexer.clk_reset reset
    add_connection reset_bridge.out_reset urg_pck_avst_adap_out.reset reset

    # connect output of the mux to the adapter first, input urgent packet to the driver has no channel
    add_connection urg_multiplexer.src urg_pck_avst_adap_out.in avalon_streaming

    for {set i 0} {$i < $num_endpoints} {incr i} {
        add_connection clk_bridge.out_clk urg_pck_avst_adap_$i.clk clock
        add_connection reset_bridge.out_reset urg_pck_avst_adap_$i.reset reset
        add_connection urg_pck_avst_adap_$i.out urg_multiplexer.sink$i avalon_streaming

        # exported interfaces
        add_interface urg_in$i avalon_streaming sink
        set_interface_property urg_in$i EXPORT_OF urg_pck_avst_adap_$i.in
    }

    # exported interfaces
    add_interface urg_out_int avalon_streaming source
    set_interface_property urg_out_int EXPORT_OF urg_pck_avst_adap_out.out

    add_interface reset reset sink
    set_interface_property reset EXPORT_OF reset_bridge.in_reset
    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk_bridge.in_clk
}
