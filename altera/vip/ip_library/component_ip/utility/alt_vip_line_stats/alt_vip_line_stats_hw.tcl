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

declare_general_component_info
set_module_property NAME alt_vip_line_stats
set_module_property DISPLAY_NAME "Line Statistics block"
set_module_property ELABORATION_CALLBACK elab_callback

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files  ../../..
add_alt_vip_common_event_packet_encode_files  ../../..
add_static_sv_file src_hdl/alt_vip_line_stats.sv

setup_filesets alt_vip_line_stats

add_parameter PIXEL_WIDTH INTEGER 10
set_parameter_property PIXEL_WIDTH DISPLAY_NAME "Bits per pixel"
set_parameter_property PIXEL_WIDTH ALLOWED_RANGES 4:80
set_parameter_property PIXEL_WIDTH AFFECTS_ELABORATION true
set_parameter_property PIXEL_WIDTH HDL_PARAMETER true

add_parameter PIXELS_IN_PARALLEL INTEGER 1
set_parameter_property PIXELS_IN_PARALLEL DISPLAY_NAME "Pixels in parallel"
set_parameter_property PIXELS_IN_PARALLEL DESCRIPTION ""
set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1 2 4 8}
set_parameter_property PIXELS_IN_PARALLEL AFFECTS_ELABORATION true
set_parameter_property PIXELS_IN_PARALLEL HDL_PARAMETER true

add_parameter PIPELINE_READY INTEGER 0
set_parameter_property PIPELINE_READY DISPLAY_NAME "Register Avalon-ST ready signals"
set_parameter_property PIPELINE_READY DESCRIPTION ""
set_parameter_property PIPELINE_READY ALLOWED_RANGES 0:1
set_parameter_property PIPELINE_READY AFFECTS_ELABORATION false
set_parameter_property PIPELINE_READY HDL_PARAMETER true
set_parameter_property PIPELINE_READY DISPLAY_HINT boolean

add_av_st_event_parameters

add_main_clock_port

proc elab_callback {} {

   set src_width           [get_parameter_value SRC_WIDTH]
   set dst_width           [get_parameter_value DST_WIDTH]
   set context_width       [get_parameter_value CONTEXT_WIDTH]
   set task_width          [get_parameter_value TASK_WIDTH]

   set data_width          [get_parameter_value PIXEL_WIDTH]
   set pixels_in_par       [get_parameter_value PIXELS_IN_PARALLEL]

   add_av_st_data_sink_port   av_st_din            $data_width          $pixels_in_par   $dst_width  $src_width  $task_width $context_width    0  main_clock  0
   add_av_st_data_source_port av_st_dout           $data_width          $pixels_in_par   $dst_width  $src_width  $task_width $context_width    0  main_clock  0
   add_av_st_resp_source_port av_st_resp                                     1           $dst_width  $src_width  $task_width $context_width       main_clock  0

}
