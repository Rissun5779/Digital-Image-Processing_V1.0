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
set_module_property NAME alt_vip_pip_converter_core
set_module_property DISPLAY_NAME "Pixels in parallel converter core"
set_module_property ELABORATION_CALLBACK pip_elab_callback

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files  ../../..
add_alt_vip_common_event_packet_encode_files  ../../..
add_alt_vip_common_fifo2_files  ../../..
add_static_sv_file src_hdl/alt_vip_pip_converter_core.sv

setup_filesets alt_vip_pip_converter_core

add_parameter PIXEL_WIDTH INTEGER 10
set_parameter_property PIXEL_WIDTH DISPLAY_NAME "Bits per pixel"
set_parameter_property PIXEL_WIDTH ALLOWED_RANGES 4:1024
set_parameter_property PIXEL_WIDTH AFFECTS_ELABORATION true
set_parameter_property PIXEL_WIDTH HDL_PARAMETER true

add_parameter PIXELS_IN_PARALLEL_IN INTEGER 1
set_parameter_property PIXELS_IN_PARALLEL_IN DISPLAY_NAME "Input pixels in parallel"
set_parameter_property PIXELS_IN_PARALLEL_IN DESCRIPTION ""
set_parameter_property PIXELS_IN_PARALLEL_IN ALLOWED_RANGES {1 2 4 8}
set_parameter_property PIXELS_IN_PARALLEL_IN AFFECTS_ELABORATION true
set_parameter_property PIXELS_IN_PARALLEL_IN HDL_PARAMETER true

add_parameter PIXELS_IN_PARALLEL_OUT INTEGER 1
set_parameter_property PIXELS_IN_PARALLEL_OUT DISPLAY_NAME "Output pixels in parallel"
set_parameter_property PIXELS_IN_PARALLEL_OUT DESCRIPTION ""
set_parameter_property PIXELS_IN_PARALLEL_OUT ALLOWED_RANGES {1 2 4 8}
set_parameter_property PIXELS_IN_PARALLEL_OUT AFFECTS_ELABORATION true
set_parameter_property PIXELS_IN_PARALLEL_OUT HDL_PARAMETER true

add_parameter FIFO_DEPTH INTEGER 16
set_parameter_property FIFO_DEPTH DISPLAY_NAME "FIFO depth"
set_parameter_property FIFO_DEPTH DESCRIPTION ""
set_parameter_property FIFO_DEPTH ALLOWED_RANGES {0 16 32 64 128 256 512 1024 2048 4096 8192 16384}
set_parameter_property FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property FIFO_DEPTH HDL_PARAMETER false

add_parameter PIPELINE_READY INTEGER 0
set_parameter_property PIPELINE_READY DISPLAY_NAME "Register Avalon-ST ready signals"
set_parameter_property PIPELINE_READY DESCRIPTION ""
set_parameter_property PIPELINE_READY ALLOWED_RANGES 0:1
set_parameter_property PIPELINE_READY AFFECTS_ELABORATION false
set_parameter_property PIPELINE_READY HDL_PARAMETER true
set_parameter_property PIPELINE_READY DISPLAY_HINT boolean

add_av_st_event_parameters

add_parameter INPUT_FIFO_DEPTH INTEGER 0
set_parameter_property INPUT_FIFO_DEPTH DERIVED true
set_parameter_property INPUT_FIFO_DEPTH VISIBLE false
set_parameter_property INPUT_FIFO_DEPTH HDL_PARAMETER true

add_parameter OUTPUT_FIFO_DEPTH INTEGER 0
set_parameter_property OUTPUT_FIFO_DEPTH DERIVED true
set_parameter_property OUTPUT_FIFO_DEPTH VISIBLE false
set_parameter_property OUTPUT_FIFO_DEPTH HDL_PARAMETER true

add_main_clock_port

proc pip_elab_callback {} {

   set src_width           [get_parameter_value SRC_WIDTH]
   set dst_width           [get_parameter_value DST_WIDTH]
   set context_width       [get_parameter_value CONTEXT_WIDTH]
   set task_width          [get_parameter_value TASK_WIDTH]

   set data_width          [get_parameter_value PIXEL_WIDTH]
   set pixels_in_par_in    [get_parameter_value PIXELS_IN_PARALLEL_IN]
   set pixels_in_par_out   [get_parameter_value PIXELS_IN_PARALLEL_OUT]
   set fifo_depth          [get_parameter_value FIFO_DEPTH]

   add_av_st_data_sink_port   av_st_din            $data_width          $pixels_in_par_in   $dst_width  $src_width  $task_width $context_width    0  main_clock  0
   add_av_st_data_source_port av_st_dout           $data_width          $pixels_in_par_out  $dst_width  $src_width  $task_width $context_width    0  main_clock  0
   
   if { $pixels_in_par_in > $pixels_in_par_out } {
      set_parameter_value   INPUT_FIFO_DEPTH   $fifo_depth
      set_parameter_value   OUTPUT_FIFO_DEPTH  0
   } else {
      set_parameter_value   INPUT_FIFO_DEPTH   0
      set_parameter_value   OUTPUT_FIFO_DEPTH  $fifo_depth
   }

}
