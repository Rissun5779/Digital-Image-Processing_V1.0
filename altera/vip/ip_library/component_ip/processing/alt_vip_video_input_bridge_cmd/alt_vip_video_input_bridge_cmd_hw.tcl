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

# Component specific properties
set_module_property DESCRIPTION ""
set_module_property NAME alt_vip_video_input_bridge_cmd
set_module_property DISPLAY_NAME "Command Input Bridge"

set_module_property VALIDATION_CALLBACK cib_validation_callback
set_module_property ELABORATION_CALLBACK cib_elaboration_callback

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_video_input_bridge_cmd.sv

setup_filesets alt_vip_video_input_bridge_cmd

add_bits_per_symbol_parameters

add_channels_nb_parameters

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL      ALLOWED_RANGES       {1 2 4 8}

add_parameter           PIPELINE_READY          INTEGER              0
set_parameter_property  PIPELINE_READY          ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY          DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY          AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY          HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY          DISPLAY_NAME         "Pipeline Av-ST ready signals"

add_parameter           DATA_SRC_ADDRESS        INTEGER              0
set_parameter_property  DATA_SRC_ADDRESS        AFFECTS_ELABORATION  true
set_parameter_property  DATA_SRC_ADDRESS        HDL_PARAMETER        true
set_parameter_property  DATA_SRC_ADDRESS        DISPLAY_NAME         "Dout source ID"

add_av_st_event_parameters

add_main_clock_port

proc cib_elaboration_callback {} {

   set   bits_per_symbol      [get_parameter_value BITS_PER_SYMBOL]
   set   num_of_colour_planes [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   are_in_par           [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pixels_in_parallel   [get_parameter_value PIXELS_IN_PARALLEL]

   if { $are_in_par > 0 } {
      set   symbols_per_pixel $num_of_colour_planes
   } else {
      set   symbols_per_pixel 1
   }

   set   data_src_address     [get_parameter_value DATA_SRC_ADDRESS]
   set   src_width            [get_parameter_value SRC_WIDTH]
   set   dst_width            [get_parameter_value DST_WIDTH]
   set   context_width        [get_parameter_value CONTEXT_WIDTH]
   set   task_width           [get_parameter_value TASK_WIDTH]
   set   data_width           [expr $bits_per_symbol * $symbols_per_pixel]

   add_av_st_cmd_sink_port    av_st_cmd                        1                    $dst_width           $src_width  $task_width    $context_width    main_clock  $data_src_address
   add_av_st_data_sink_port   av_st_din      $data_width       $pixels_in_parallel  $dst_width           $src_width  $task_width    $context_width 0  main_clock  $data_src_address
   add_av_st_data_source_port av_st_dout     $data_width       $pixels_in_parallel  $dst_width           $src_width  $task_width    $context_width 0  main_clock  $data_src_address
}

proc cib_validation_callback {} {
   if { [get_parameter_value PIXELS_IN_PARALLEL] > 1 } {
      if { [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] == 0 } {
         send_message Error "All colour planes must be in parallel to enable more than 1 pixel in parallel"
      }
   }
   if { [get_parameter_value TASK_WIDTH] == 0 } {
      send_message Error "Task width must be greater than 0"
   }
}
