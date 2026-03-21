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
# -- General information for the clipper scheduler module                                                       --
# --                                                                                                        --
# ------------------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_clipper_scheduler
set_module_property DISPLAY_NAME "Clipper Scheduler"
set_module_property DESCRIPTION "Scheduler for the Clipper"


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files ../../..

add_static_sv_file src_hdl/alt_vip_clipper_scheduler.sv

add_static_misc_file src_hdl/alt_vip_clipper_scheduler.ocp

setup_filesets alt_vip_clipper_scheduler


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

set x_max $vipsuite_max_width
set y_max $vipsuite_max_height

# Add MAX_IN_WIDTH and MAX_IN_HEIGHT parameters
add_max_in_dim_parameters 32 $x_max 32 $y_max

add_parameter          RECTANGLE_MODE INTEGER 1
set_parameter_property RECTANGLE_MODE DISPLAY_NAME "Rectangle Mode"
set_parameter_property RECTANGLE_MODE ALLOWED_RANGES 0:1
set_parameter_property RECTANGLE_MODE DISPLAY_HINT boolean
set_parameter_property RECTANGLE_MODE DESCRIPTION "Offsets mode will clip a portion of the image based on how large each offset is from the edge of the input image. Rectangle mode will clip an image of width * height dimensions from the starting left and right offset."
set_parameter_property RECTANGLE_MODE HDL_PARAMETER true
set_parameter_property RECTANGLE_MODE AFFECTS_ELABORATION true

add_parameter          LEFT_OFFSET INTEGER 0
set_parameter_property LEFT_OFFSET DISPLAY_NAME "Left Offset"
set_parameter_property LEFT_OFFSET ALLOWED_RANGES 0:$x_max
set_parameter_property LEFT_OFFSET DESCRIPTION "The number of pixels to the left edge of the clipping surface"
set_parameter_property LEFT_OFFSET HDL_PARAMETER true
set_parameter_property LEFT_OFFSET AFFECTS_ELABORATION true

add_parameter          RIGHT_OFFSET INTEGER 0
set_parameter_property RIGHT_OFFSET DISPLAY_NAME "Right Offset"
set_parameter_property RIGHT_OFFSET ALLOWED_RANGES 0:$x_max
set_parameter_property RIGHT_OFFSET DESCRIPTION "The number of pixels to the right edge of the clipping surface"
set_parameter_property RIGHT_OFFSET HDL_PARAMETER true
set_parameter_property RIGHT_OFFSET AFFECTS_ELABORATION true

add_parameter          TOP_OFFSET INTEGER 0
set_parameter_property TOP_OFFSET DISPLAY_NAME "Top Offset"
set_parameter_property TOP_OFFSET ALLOWED_RANGES 0:$y_max
set_parameter_property TOP_OFFSET DESCRIPTION "The number of pixels to the top edge of the clipping surface"
set_parameter_property TOP_OFFSET HDL_PARAMETER true
set_parameter_property TOP_OFFSET AFFECTS_ELABORATION true

add_parameter          BOTTOM_OFFSET INTEGER 0
set_parameter_property BOTTOM_OFFSET DISPLAY_NAME "Bottom Offset"
set_parameter_property BOTTOM_OFFSET ALLOWED_RANGES 0:$y_max
set_parameter_property BOTTOM_OFFSET DESCRIPTION "The number of pixels to the bottom edge of the clipping surface"
set_parameter_property BOTTOM_OFFSET HDL_PARAMETER true
set_parameter_property BOTTOM_OFFSET AFFECTS_ELABORATION true

add_parameter          OUT_WIDTH INTEGER 1920 
set_parameter_property OUT_WIDTH DISPLAY_NAME "Output Picture Width"
set_parameter_property OUT_WIDTH ALLOWED_RANGES 32:$x_max
set_parameter_property OUT_WIDTH DESCRIPTION "In rectangle mode, defines the width of the output picture"
set_parameter_property OUT_WIDTH HDL_PARAMETER true
set_parameter_property OUT_WIDTH AFFECTS_ELABORATION true

add_parameter          OUT_HEIGHT INTEGER 1080
set_parameter_property OUT_HEIGHT DISPLAY_NAME "Output Picture Height"
set_parameter_property OUT_HEIGHT ALLOWED_RANGES 32:$y_max
set_parameter_property OUT_HEIGHT DESCRIPTION "In rectangle mode, defines the height of the output picture"
set_parameter_property OUT_HEIGHT HDL_PARAMETER true
set_parameter_property OUT_HEIGHT AFFECTS_ELABORATION true

add_user_packet_support_parameters PASSTHROUGH
set_parameter_property   USER_PACKET_FIFO_DEPTH   VISIBLE  false
set_parameter_property   USER_PACKET_FIFO_DEPTH   ENABLED  false
set_parameter_property   USER_PACKET_FIFO_DEPTH   HDL_PARAMETER  false

add_parameter           PIPELINE_READY INTEGER              0
set_parameter_property  PIPELINE_READY ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY DISPLAY_NAME         "Pipeline Av-ST ready signals"

# adds RUNTIME_CONTROL and LIMITED_READBACK
add_runtime_control_parameters 1


add_av_st_event_parameters


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_main_clock_port



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc validation_cb {} {
   set max_in_width   [get_parameter_value MAX_IN_WIDTH]
   set max_in_height  [get_parameter_value MAX_IN_HEIGHT]
   set left_offset    [get_parameter_value LEFT_OFFSET]
   set top_offset     [get_parameter_value TOP_OFFSET]
   set rectangle_mode [get_parameter_value RECTANGLE_MODE]

   runtime_control_validation_callback_helper

   if {$max_in_width < $left_offset} {
      send_message error "left offset ($left_offset) should not be larger than the maximum input width ($max_in_width)"
   }
   if {$max_in_height < $top_offset} {
      send_message error "top offset ($top_offset) should not be larger than the maximum input height ($max_in_height)"
   }
   
   if { $rectangle_mode == 0 } {
      # Offsets mode
      set right_offset       [get_parameter_value RIGHT_OFFSET]
      set bottom_offset      [get_parameter_value BOTTOM_OFFSET]

      set offset_sum_width   [expr {$left_offset + $right_offset + 32}]
      set offset_sum_height  [expr {$top_offset + $bottom_offset + 32}]

      if {$max_in_width < $offset_sum_width} {
         send_message error "left_offset($left_offset) + right_offset($right_offset) + 32(min picture width) should not be larger than the maximum input frame width ($max_in_width)"
      }
      if {$max_in_height < $offset_sum_height} {
         send_message error "top_offset($top_offset) + bottom_offset($bottom_offset) + 32(min picture width) should not be larger than the maximum input frame height ($max_in_height)"
      }
   } else {
      # Rectangle mode
      set out_width          [get_parameter_value OUT_WIDTH]
      set out_height         [get_parameter_value OUT_HEIGHT]

      set offset_sum_width   [expr {$left_offset + $out_width}]
      set offset_sum_height  [expr {$top_offset + $out_height}]

      if {$max_in_width < $offset_sum_width} {
         send_message error "left_offset($left_offset) + out_width($out_width) should not be larger than the maximum input frame width ($max_in_width)"
      }
      if {$max_in_height < $offset_sum_height} {
         send_message error "top_offset($top_offset) + out_height($out_height) should not be larger than the maximum input frame height ($max_in_height)"
      }
   }
}




# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc elaboration_cb {} {

   set control_exists [get_parameter_value RUNTIME_CONTROL]
   set user_packet_support [get_parameter_value USER_PACKET_SUPPORT]
   set num_reg     7
   set addr_width  3 
   
   add_av_st_cmd_source_port   av_st_cmd_vib       1   8   8   8   8   main_clock   0
   add_av_st_cmd_source_port   av_st_cmd_alg_core  1   8   8   8   8   main_clock   0
   add_av_st_cmd_source_port   av_st_cmd_vob       1   8   8   8   8   main_clock   0
   add_av_st_resp_sink_port    av_st_resp_vib      1   8   8   8   8   main_clock   0
   
   set cmp_user_support [string compare $user_packet_support "PASSTHROUGH"]
   if { $cmp_user_support == 0 } {
       add_av_st_cmd_source_port   av_st_cmd_mux       1   8   8   8   8   main_clock   0
   }

   if { $control_exists > 0 } {
      add_control_slave_port   av_mm_control   $addr_width   $num_reg   0   1   1   1   main_clock
   }
}
