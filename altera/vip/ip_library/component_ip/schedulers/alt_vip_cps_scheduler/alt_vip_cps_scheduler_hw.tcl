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


source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl

# ------------------------------------------------------------------------------------------------------------
# --                                                                                                        --
# -- General information for the CPS scheduler module                                                       --
# -- This block routes user packet around the algorithmic cores and discards extra line packets when        --
# -- the input mismatch                                                                                     --
# ------------------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_cps_scheduler
set_module_property DISPLAY_NAME "CPS Scheduler"
set_module_property DESCRIPTION "Schedule the routing of packets in the cps core"


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
set_module_property  VALIDATION_CALLBACK  validation_cb

# Elaboration callback to set up the dynamic ports
set_module_property  ELABORATION_CALLBACK elaboration_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_cps_scheduler.sv
add_static_sv_file src_hdl/alt_vip_cps_scheduler_core.sv

add_static_misc_file src_hdl/alt_vip_cps_scheduler.ocp

setup_filesets alt_vip_cps_scheduler

add_parameter            NUMBER_OF_INPUTS                           INTEGER                1
set_parameter_property   NUMBER_OF_INPUTS                           DISPLAY_NAME           "Number of inputs"
set_parameter_property   NUMBER_OF_INPUTS                           DESCRIPTION            "The number of inputs"
set_parameter_property   NUMBER_OF_INPUTS                           ALLOWED_RANGES         {1,2}  
set_parameter_property   NUMBER_OF_INPUTS                           AFFECTS_ELABORATION    true
set_parameter_property   NUMBER_OF_INPUTS                           HDL_PARAMETER          true

add_parameter            NUMBER_OF_OUTPUTS                          INTEGER                1
set_parameter_property   NUMBER_OF_OUTPUTS                          DISPLAY_NAME           "Number of outputs"
set_parameter_property   NUMBER_OF_OUTPUTS                          DESCRIPTION            "The number of outputs"
set_parameter_property   NUMBER_OF_OUTPUTS                          ALLOWED_RANGES         {1,2}  
set_parameter_property   NUMBER_OF_OUTPUTS                          AFFECTS_ELABORATION    true
set_parameter_property   NUMBER_OF_OUTPUTS                          HDL_PARAMETER          true

foreach io_name {OUTPUT_0 OUTPUT_1} {
    add_parameter            $io_name\_WIDTH_MOD                        INTEGER                 0
    set_parameter_property   $io_name\_WIDTH_MOD                        DISPLAY_NAME            "Control packet width modification"
    set_parameter_property   $io_name\_WIDTH_MOD                        DESCRIPTION             "Whether the control packet width received on input 0 should be divided or multiplied by 2 for this output"
    set_parameter_property   $io_name\_WIDTH_MOD                        ALLOWED_RANGES          -1:1
    set_parameter_property   $io_name\_WIDTH_MOD                        HDL_PARAMETER           true
    set_parameter_property   $io_name\_WIDTH_MOD                        AFFECTS_ELABORATION     false
}    

add_parameter            LINE_SPLITTING_ALLOWED                     INTEGER                0
set_parameter_property   LINE_SPLITTING_ALLOWED                     ALLOWED_RANGES         0:1
set_parameter_property   LINE_SPLITTING_ALLOWED                     DISPLAY_NAME           "Line packets allowed"
set_parameter_property   LINE_SPLITTING_ALLOWED                     DESCRIPTION            "Whether the scheduler supports routing of line packets that do not have the eop flag set"
set_parameter_property   LINE_SPLITTING_ALLOWED                     DISPLAY_HINT           boolean
set_parameter_property   LINE_SPLITTING_ALLOWED                     AFFECTS_ELABORATION    true
set_parameter_property   LINE_SPLITTING_ALLOWED                     HDL_PARAMETER          true


add_user_packet_support_parameters  PASSTHROUGH  0

foreach in_id {0 1 0 1} out_id {0 0 1 1} {
    add_parameter            USER_PKT_$in_id\_TO_$out_id                INTEGER                 [expr ($in_id == $out_id) ? 1 : 0]
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                DISPLAY_NAME            "Propagate user packets from input $in_id"
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                DESCRIPTION             "Whether the user packets received on input %in_id are propagated to output $out_id"
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                ALLOWED_RANGES          0:1
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                DISPLAY_HINT            boolean
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                HDL_PARAMETER           true
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                AFFECTS_ELABORATION     true
}    

add_parameter            PIPELINE_READY                             INTEGER                0
set_parameter_property   PIPELINE_READY                             ALLOWED_RANGES         0:1
set_parameter_property   PIPELINE_READY                             DISPLAY_NAME           "Pipeline dout ready signals"
set_parameter_property   PIPELINE_READY                             DISPLAY_HINT           boolean
set_parameter_property   PIPELINE_READY                             AFFECTS_ELABORATION    false
set_parameter_property   PIPELINE_READY                             HDL_PARAMETER          true

# Add parameters for the data and command Avalon-ST command/response ports
add_av_st_event_parameters


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                                             --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc validation_cb {} {
    set number_of_inputs            [get_parameter_value NUMBER_OF_INPUTS]
    set number_of_outputs           [get_parameter_value NUMBER_OF_OUTPUTS]
    set user_packet_support         [get_parameter_value USER_PACKET_SUPPORT]
    
    set propagate_user_packets      [string equal   $user_packet_support  "PASSTHROUGH"]
    
    if {!$propagate_user_packets} {
        foreach in_id {0 1 0 1} out_id {0 0 1 1} {
            set_parameter_property   USER_PKT_$in_id\_TO_$out_id                ENABLED          false
        }
    } else {
        foreach in_id {0 1 0 1} out_id {0 0 1 1} {
            set_parameter_property   USER_PKT_$in_id\_TO_$out_id                ENABLED          [expr {($in_id < $number_of_inputs) && ($out_id < $number_of_outputs)}]
        }
        foreach out_id {0 1} {
            set_parameter_property   OUTPUT_$out_id\_WIDTH_MOD                  ENABLED          [expr {$out_id < $number_of_outputs}]
        }
    }
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
# The main clock and associated reset
add_main_clock_port


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc elaboration_cb {} {
    
    set number_of_inputs            [get_parameter_value NUMBER_OF_INPUTS]
    set number_of_outputs           [get_parameter_value NUMBER_OF_OUTPUTS]
    set user_packet_support         [get_parameter_value USER_PACKET_SUPPORT]
    set line_splitting_allowed      [get_parameter_value LINE_SPLITTING_ALLOWED]
    foreach in_id {0 1 0 1} out_id {0 0 1 1} {
        set user_pkt_$in_id\_to_$out_id              [get_parameter_value USER_PKT_$in_id\_TO_$out_id]
    }

    set src_width                   [get_parameter_value SRC_WIDTH]
    set dst_width                   [get_parameter_value DST_WIDTH]
    set context_width               [get_parameter_value CONTEXT_WIDTH]
    set task_width                  [get_parameter_value TASK_WIDTH]
    

    set propagate_user_packets      [string equal   $user_packet_support  "PASSTHROUGH"]
    set discard_user_packets        [string equal   $user_packet_support  "DISCARD"]
    set enable_user_packets         [string compare $user_packet_support  "NONE_ALLOWED"]
    
    # Use a vib_cmd  to discard/route user packets or to discard lines when there are two or more inputs and line_splitting is allowed
    set has_vib_cmd                 [expr $enable_user_packets || (($number_of_inputs > 1) && $line_splitting_allowed)]

    # Figure out if a packet mux will be needed before the duplicator
    set has_user_pkt_mux            [expr ($number_of_inputs == 2) && ($number_of_outputs == 2) && $propagate_user_packets && (($user_pkt_0_to_0 + $user_pkt_0_to_1 + $user_pkt_1_to_0 + $user_pkt_1_to_1) >= 3)]
   
    # Set up command/response port to the input modules (the demux(es)/duplicator are only indirectly controlled through the dst_id set by the VIB command modules)
    for {set k 0} {$k < $number_of_inputs} {incr k} {

        add_av_st_resp_sink_port    av_st_resp_vib_$k             1   $src_width   $dst_width   $task_width   $context_width   main_clock   0

        if {$has_vib_cmd} {
            add_av_st_cmd_source_port   av_st_cmd_vib_$k              1   $src_width   $dst_width   $task_width   $context_width   main_clock   0
        }
    }
    
    if {$has_user_pkt_mux} {
        add_av_st_cmd_source_port   av_st_cmd_dup_mux             1   $src_width   $dst_width   $task_width   $context_width   main_clock   0
    }
    
    # Set up command/response port to the output modules
    for {set k 0} {$k < $number_of_outputs} {incr k} {

        add_av_st_cmd_source_port   av_st_cmd_vob_$k              1   $src_width   $dst_width   $task_width   $context_width   main_clock   0
        if {$number_of_inputs == 1} {
            set receives_user_packets          [set user_pkt_0_to_$k]
        } else {
            set receives_user_packets          [expr [set user_pkt_0_to_$k] || [set user_pkt_1_to_$k]]
        }
        if {$propagate_user_packets && $receives_user_packets} {
            add_av_st_cmd_source_port   av_st_cmd_mux_$k              1   $src_width   $dst_width   $task_width   $context_width   main_clock   0
        }
    }    
}
