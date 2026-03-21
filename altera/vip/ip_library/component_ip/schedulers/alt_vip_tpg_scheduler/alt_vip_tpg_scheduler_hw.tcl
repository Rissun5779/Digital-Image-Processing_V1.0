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
# -- General information for the alt_vip_tpg_scheduler module                                     --
# -- This block sources commands and sinks responses from the various components of the TPG to    --
# -- implement the required test pattern generator functionality                                  --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

# Common module properties for VIP components 
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_tpg_scheduler
set_module_property DISPLAY_NAME "Test Pattern Generator Scheduler"

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_tpg_scheduler.sv

add_static_misc_file src_hdl/alt_vip_tpg_scheduler.ocp

setup_filesets alt_vip_tpg_scheduler

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Add parameters for the data and command Avalon-ST message ports
add_av_st_event_parameters

#Add BITS_PER_SYMBOL parameter
add_bits_per_symbol_parameters

#4k support 
add_pixels_in_parallel_parameters 

# Add MAX_WIDTH and MAX_HEIGHT parameters
add_max_dim_parameters
set_parameter_property MAX_WIDTH DEFAULT_VALUE 640
set_parameter_property MAX_WIDTH ALLOWED_RANGES 32:$vipsuite_max_width
set_parameter_property MAX_WIDTH AFFECTS_ELABORATION true
set_parameter_property MAX_HEIGHT ALLOWED_RANGES 32:$vipsuite_max_height
set_parameter_property MAX_HEIGHT DEFAULT_VALUE 480
set_parameter_property MAX_HEIGHT AFFECTS_ELABORATION true
set_parameter_property MAX_HEIGHT DESCRIPTION "The maximum height of images / video frames, value must be the height of full progressive wave when outputting interlaced data"

# Planes in parallel (1) or sequence (0)
add_parameter 		   COLOR_PLANES_ARE_IN_PARALLEL INTEGER 0
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL DISPLAY_NAME "Color plane configuration"
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL DESCRIPTION "The color planes are arranged in parallel, otherwise in series (sequence)"
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER true
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL AFFECTS_ELABORATION true
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL ALLOWED_RANGES {0:Sequence 1:Parallel}
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL DISPLAY_HINT radio

add_parameter          RUNTIME_CONTROL INTEGER 0
set_parameter_property RUNTIME_CONTROL DISPLAY_NAME "Runtime Control of image size"
set_parameter_property RUNTIME_CONTROL ALLOWED_RANGES 0:1
set_parameter_property RUNTIME_CONTROL DISPLAY_HINT boolean
set_parameter_property RUNTIME_CONTROL HDL_PARAMETER true
set_parameter_property RUNTIME_CONTROL AFFECTS_ELABORATION true

add_parameter          INTERLACING string {prog}
set_parameter_property INTERLACING DISPLAY_NAME "Interlacing"
set_parameter_property INTERLACING ALLOWED_RANGES {{prog:Progressive output} {int_f0:Interlaced output (F0 First)} {int_f1:Interlaced output (F1 First)}}
set_parameter_property INTERLACING DISPLAY_HINT ""
set_parameter_property INTERLACING DESCRIPTION "Output stream is progressive or interlaced with either F0 first or F1 first"
set_parameter_property INTERLACING HDL_PARAMETER true
set_parameter_property INTERLACING AFFECTS_ELABORATION true

# Other format only possible in YCbCr color space mode
add_parameter          OUTPUT_FORMAT string 4.4.4
set_parameter_property OUTPUT_FORMAT DISPLAY_NAME "Output format"
set_parameter_property OUTPUT_FORMAT ALLOWED_RANGES {"4.4.4:4:4:4" "4.2.2:4:2:2" "4.2.0:4:2:0"}
set_parameter_property OUTPUT_FORMAT DISPLAY_HINT ""
set_parameter_property OUTPUT_FORMAT DESCRIPTION "Sampling rate format for the output frames (4:4:4 or 4:2:2 or 4:2:0)"
set_parameter_property OUTPUT_FORMAT HDL_PARAMETER true
set_parameter_property OUTPUT_FORMAT AFFECTS_ELABORATION true

add_parameter          UNIFORM_VALUE_RY INTEGER 16
set_parameter_property UNIFORM_VALUE_RY DISPLAY_NAME "R or Y"
set_parameter_property UNIFORM_VALUE_RY DESCRIPTION "Color bit value for R or Y"
set_parameter_property UNIFORM_VALUE_RY HDL_PARAMETER true
set_parameter_property UNIFORM_VALUE_RY AFFECTS_ELABORATION true

add_parameter          UNIFORM_VALUE_GCB INTEGER 16
set_parameter_property UNIFORM_VALUE_GCB DISPLAY_NAME "G or Cb"
set_parameter_property UNIFORM_VALUE_GCB DESCRIPTION "Color bit value for G or Cb"
set_parameter_property UNIFORM_VALUE_GCB HDL_PARAMETER true
set_parameter_property UNIFORM_VALUE_GCB AFFECTS_ELABORATION true

add_parameter          UNIFORM_VALUE_BCR INTEGER 16
set_parameter_property UNIFORM_VALUE_BCR DISPLAY_NAME "B or Cr"
set_parameter_property UNIFORM_VALUE_BCR DESCRIPTION "Color bit value for B or Cr"
set_parameter_property UNIFORM_VALUE_BCR HDL_PARAMETER true
set_parameter_property UNIFORM_VALUE_BCR AFFECTS_ELABORATION true

add_parameter          PATTERN string {colorbars}
set_parameter_property PATTERN DISPLAY_NAME "Pattern"
set_parameter_property PATTERN ALLOWED_RANGES {{colorbars:Color bars} {uniform:Uniform background} {greyscalebars:Black and White bars} {sdipatho:SDI Pathological}}
set_parameter_property PATTERN DISPLAY_HINT ""
set_parameter_property PATTERN DESCRIPTION "Selects a specific pattern as an output video stream"
set_parameter_property PATTERN HDL_PARAMETER true
set_parameter_property PATTERN AFFECTS_ELABORATION true

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

set_module_property ELABORATION_CALLBACK tpg_sched_elaboration_callback

proc tpg_sched_elaboration_callback {} {

    set src_width       [get_parameter_value SRC_WIDTH]
    set dst_width       [get_parameter_value DST_WIDTH]
    set context_width   [get_parameter_value CONTEXT_WIDTH]
    set task_width      [get_parameter_value TASK_WIDTH]
    set control_exists  [get_parameter_value RUNTIME_CONTROL]
    
    #  scheduler.av_st_cmd_core   	     ->     tpg_core.cmd
    #  scheduler.av_st_cmd_video_out     ->     video_out.cmd
    #  scheduler.av_st_cmd_control_slave ->     tpg_control_slave.cmd
    #  tpg_control_slave.resp            ->     scheduler.av_st_resp_control_slave

    # Static command ports
    #                           name    elements_per_beat   dst_width   src_width   task_width   context_width    clock    pe_id 
    add_av_st_cmd_source_port   av_st_cmd_core          1  $dst_width  $src_width  $task_width  $context_width  main_clock   0
    add_av_st_cmd_source_port   av_st_cmd_video_out     1  $dst_width  $src_width  $task_width  $context_width  main_clock   0
 
	 if { $control_exists > 0 } {
       add_av_st_cmd_source_port   av_st_cmd_control_slave    1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
       add_av_st_resp_sink_port    av_st_resp_control_slave   1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
	 }
}
