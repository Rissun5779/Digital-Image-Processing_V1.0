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
# -- General information for the alt_vip_dil_weave_scheduler module                                     --
# -- This block sources commands and sinks responses from the various components of the DIL to    --
# -- implement the required deinterlacing algorithms.                                             --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

# Common module properties for VIP components 
declare_general_component_info

set_module_property NAME alt_vip_dil_weave_scheduler
set_module_property DISPLAY_NAME "Deinterlacer scheduler"
set_module_property DESCRIPTION "Scheduler for the deinterlacer core"


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files ../../..

add_static_sv_file src_hdl/alt_vip_dil_weave_scheduler.sv

add_static_misc_file src_hdl/alt_vip_dil_weave_scheduler.ocp

setup_filesets alt_vip_dil_weave_scheduler


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Elaboration callback to set up the dynamic ports
set_module_property  ELABORATION_CALLBACK elaboration_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------


add_max_line_length_parameters

add_max_field_height_parameters

add_parameter BUFFER0_BASE INTEGER 0
set_parameter_property BUFFER0_BASE DISPLAY_NAME "Base address of buffer 0"
set_parameter_property BUFFER0_BASE DISPLAY_HINT hexadecimal
set_parameter_property BUFFER0_BASE DESCRIPTION "The first buffer used to store incoming fields"
set_parameter_property BUFFER0_BASE HDL_PARAMETER true
set_parameter_property BUFFER0_BASE ENABLED true

add_parameter BUFFER1_BASE INTEGER 0
set_parameter_property BUFFER1_BASE DISPLAY_NAME "Base address of buffer 1"
set_parameter_property BUFFER1_BASE DISPLAY_HINT hexadecimal
set_parameter_property BUFFER1_BASE DESCRIPTION "The second buffer used to store incoming fields"
set_parameter_property BUFFER1_BASE HDL_PARAMETER true
set_parameter_property BUFFER1_BASE ENABLED true

add_parameter LINE_OFFSET_BYTES INTEGER 160
set_parameter_property LINE_OFFSET_BYTES DISPLAY_NAME "The length (in bytes) of a line of pixels stored in memory"
set_parameter_property LINE_OFFSET_BYTES DESCRIPTION ""
set_parameter_property LINE_OFFSET_BYTES DISPLAY_HINT hexadecimal
set_parameter_property LINE_OFFSET_BYTES HDL_PARAMETER true

add_runtime_control_parameters 0

add_parameter SOURCE_ADDRESS INTEGER 0 "Source ID of deinterlacer scheduler on output interface(s)"
set_parameter_property SOURCE_ADDRESS DISPLAY_NAME "Deinterlacer Scheduler ID"
set_parameter_property SOURCE_ADDRESS AFFECTS_GENERATION false
set_parameter_property SOURCE_ADDRESS HDL_PARAMETER true
set_parameter_property SOURCE_ADDRESS AFFECTS_ELABORATION true
set_parameter_property SOURCE_ADDRESS DERIVED false

add_av_st_event_parameters


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

