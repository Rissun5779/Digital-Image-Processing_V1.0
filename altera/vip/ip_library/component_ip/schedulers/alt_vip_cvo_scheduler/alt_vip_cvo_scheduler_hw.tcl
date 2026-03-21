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


# --------------------------------------------------------------------------------------------------
#--                                                                                               --
#-- _hw.tcl compose file for the alt_vip_cvo_scheduler component                                  --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP components 
declare_general_component_info

# Component properties
set_module_property NAME alt_vip_cvo_scheduler
set_module_property DISPLAY_NAME "CVO scheduler"
set_module_property DESCRIPTION "Scheduler for the CVO component"


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set_module_property   ELABORATION_CALLBACK            elaboration_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..

add_static_sv_file src_hdl/alt_vip_cvo_scheduler.sv

add_static_misc_file src_hdl/alt_vip_cvo_scheduler.ocp

setup_filesets alt_vip_cvo_scheduler


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

add_av_st_event_parameters

add_parameter USE_CONTROL integer 0
set_parameter_property USE_CONTROL DISPLAY_NAME "Use control port"
set_parameter_property USE_CONTROL ALLOWED_RANGES 0:1
set_parameter_property USE_CONTROL HDL_PARAMETER true
set_parameter_property USE_CONTROL DISPLAY_HINT boolean
set_parameter_property USE_CONTROL DESCRIPTION "Enable the Avalon-MM slave port that can be used for control."


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
proc elaboration_callback {} {
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set src_width                   [get_parameter_value SRC_WIDTH]
    set dst_width                   [get_parameter_value DST_WIDTH]
    set context_width               [get_parameter_value CONTEXT_WIDTH]
    set task_width                  [get_parameter_value TASK_WIDTH]

    set use_control                 [get_parameter_value USE_CONTROL]               

    # --------------------------------------------------------------------------------------------------
    # -- Dynamic ports                                                                                --
    # --------------------------------------------------------------------------------------------------
    #add_av_st_cmd_source_port   {name   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} 
    add_av_st_cmd_source_port   cmd_vib           1   $dst_width   $src_width   $task_width   $context_width   main_clock   2
    add_av_st_cmd_source_port   cmd_mark          1   $dst_width   $src_width   $task_width   $context_width   main_clock   2
    add_av_st_cmd_source_port   cmd_mode_banks    1   $dst_width   $src_width   $task_width   $context_width   main_clock   2

    add_av_st_resp_sink_port   resp_vib             1   $dst_width   $src_width   $task_width   $context_width   main_clock   2
    add_av_st_resp_sink_port   resp_mode_banks      1   $dst_width   $src_width   $task_width   $context_width   main_clock   2

    if { $use_control == 1 } {
        add_av_st_cmd_source_port  cmd_control_slave    1   $dst_width   $src_width   $task_width   $context_width   main_clock   2
        add_av_st_resp_sink_port   resp_control_slave   1   $dst_width   $src_width   $task_width   $context_width   main_clock   2
    }
}
