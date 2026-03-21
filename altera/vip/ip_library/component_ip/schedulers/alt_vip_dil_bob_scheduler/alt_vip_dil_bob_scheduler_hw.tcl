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


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information for the alt_vip_dil_bob_scheduler module                                     --
# -- This block sources commands and sinks responses from the various components of the DIL to    --
# -- implement the required deinterlacing algorithms.                                             --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

# Common module properties for VIP components 
declare_general_component_info

set_module_property NAME alt_vip_dil_bob_scheduler
set_module_property DISPLAY_NAME "Deinterlacer bob scheduler"
set_module_property DESCRIPTION "Scheduler for the bob deinterlacer core"

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files ../../..

add_static_sv_file src_hdl/alt_vip_dil_bob_scheduler.sv

add_static_misc_file src_hdl/alt_vip_dil_bob_scheduler.ocp

setup_filesets alt_vip_dil_bob_scheduler


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
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_max_line_length_parameters
add_max_field_height_parameters

add_runtime_control_parameters 1

add_av_st_event_parameters

add_parameter FRAME_FOR_FIELD_MODE INTEGER 1 "FRAME_FOR_FIELD_MODE"
set_parameter_property FRAME_FOR_FIELD_MODE DISPLAY_NAME "Frame for field mode (1=enabled)"
set_parameter_property FRAME_FOR_FIELD_MODE AFFECTS_GENERATION false
set_parameter_property FRAME_FOR_FIELD_MODE HDL_PARAMETER true
set_parameter_property FRAME_FOR_FIELD_MODE AFFECTS_ELABORATION true
set_parameter_property FRAME_FOR_FIELD_MODE DERIVED false

add_parameter FIELD_TYPE_TO_DEINTERLACE INTEGER 2 "FIELD_TYPE_TO_DEINTERLACE"
set_parameter_property FIELD_TYPE_TO_DEINTERLACE DISPLAY_NAME "Field type to deinterlace (3=F1, 2=F0)"
set_parameter_property FIELD_TYPE_TO_DEINTERLACE AFFECTS_GENERATION false
set_parameter_property FIELD_TYPE_TO_DEINTERLACE HDL_PARAMETER true
set_parameter_property FIELD_TYPE_TO_DEINTERLACE AFFECTS_ELABORATION true
set_parameter_property FIELD_TYPE_TO_DEINTERLACE DERIVED false


add_parameter SOURCE_ADDRESS INTEGER 0 "Source ID of deinterlacer scheduler on output interface(s)"
set_parameter_property SOURCE_ADDRESS DISPLAY_NAME "Deinterlacer Scheduler ID"
set_parameter_property SOURCE_ADDRESS AFFECTS_GENERATION false
set_parameter_property SOURCE_ADDRESS HDL_PARAMETER true
set_parameter_property SOURCE_ADDRESS AFFECTS_ELABORATION true
set_parameter_property SOURCE_ADDRESS DERIVED false


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
# The main clock and associated reset
add_main_clock_port


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc validation_cb {} {
    runtime_control_validation_callback_helper
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

proc elaboration_cb {} {

    set runtime_control [get_parameter_value RUNTIME_CONTROL]

    set src_width       [get_parameter_value SRC_WIDTH]
    set dst_width       [get_parameter_value DST_WIDTH]
    set context_width   [get_parameter_value CONTEXT_WIDTH]
    set task_width      [get_parameter_value TASK_WIDTH]

    # Eleven static command ports
    # name   elements_per_beat   dst_width   src_width   task_width   context_width    clock    pe_id 
    add_av_st_cmd_source_port cmd0  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_cmd_source_port cmd1  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_cmd_source_port cmd2  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_cmd_source_port cmd3  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_cmd_source_port cmd4  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

    # One static response ports
    add_av_st_resp_sink_port  resp0 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

    if { $runtime_control } {
        #add_av_st_cmd_source_port cmd5 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
        #add_av_st_resp_sink_port  resp1 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
        set num_reg     0
        set addr_width  2 
        add_control_slave_port   av_mm_control   $addr_width   $num_reg   0   1   1   1   main_clock
    }   
}

