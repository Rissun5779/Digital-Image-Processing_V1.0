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
#-- _hw.tcl compose file for the Pixels in Parallel Adapter                                   --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property  NAME           alt_vip_cl_pip_conv
set_module_property  DISPLAY_NAME   "Pixels in Parallel Convertor Intel FPGA IP"
set_module_property  DESCRIPTION    ""

# Hide the pip converter from Qsys for now.
set_module_property HIDE_FROM_QUARTUS true
set_module_property HIDE_FROM_QSYS true
set_module_property INTERNAL $internalComponents

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set_module_property  COMPOSITION_CALLBACK composition_cb
set_module_property  VALIDATION_CALLBACK   validation_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set   max_width   $vipsuite_max_width
set   max_height  $vipsuite_max_height

add_bits_per_symbol_parameters
add_channels_nb_parameters

set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  ALLOWED_RANGES {1}
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  VISIBLE        false

add_parameter           PIXELS_IN_PARALLEL_IN                        INTEGER              1
set_parameter_property  PIXELS_IN_PARALLEL_IN                        DISPLAY_NAME         "Input pixels in parallel"
set_parameter_property  PIXELS_IN_PARALLEL_IN                        DESCRIPTION          "The number of input pixels in parallel"
set_parameter_property  PIXELS_IN_PARALLEL_IN                        ALLOWED_RANGES       {1 2 4 8}
set_parameter_property  PIXELS_IN_PARALLEL_IN                        AFFECTS_ELABORATION  true
set_parameter_property  PIXELS_IN_PARALLEL_IN                        HDL_PARAMETER        true
set_parameter_property  PIXELS_IN_PARALLEL_IN                        VISIBLE              true
set_parameter_property  PIXELS_IN_PARALLEL_IN                        ENABLED              true

add_parameter           PIXELS_IN_PARALLEL_OUT                       INTEGER              1
set_parameter_property  PIXELS_IN_PARALLEL_OUT                       DISPLAY_NAME         "Output pixels in parallel"
set_parameter_property  PIXELS_IN_PARALLEL_OUT                       ALLOWED_RANGES       {1 2 4 8}
set_parameter_property  PIXELS_IN_PARALLEL_OUT                       DESCRIPTION          "The number of output pixels in parallel"
set_parameter_property  PIXELS_IN_PARALLEL_OUT                       HDL_PARAMETER        true
set_parameter_property  PIXELS_IN_PARALLEL_OUT                       AFFECTS_ELABORATION  true
set_parameter_property  PIXELS_IN_PARALLEL_OUT                       VISIBLE              true
set_parameter_property  PIXELS_IN_PARALLEL_OUT                       ENABLED              true

add_parameter           FIFO_DEPTH                                   INTEGER              16
set_parameter_property  FIFO_DEPTH                                   DISPLAY_NAME         "FIFO depth"
set_parameter_property  FIFO_DEPTH                                   ALLOWED_RANGES       {0 16 32 64 256 512 1024 2048 4096 8192 16384}
set_parameter_property  FIFO_DEPTH                                   DESCRIPTION          "Add a FIFO to smooth out burstiness and reduce backpressure"
set_parameter_property  FIFO_DEPTH                                   HDL_PARAMETER        true
set_parameter_property  FIFO_DEPTH                                   AFFECTS_ELABORATION  true
set_parameter_property  FIFO_DEPTH                                   VISIBLE              true
set_parameter_property  FIFO_DEPTH                                   ENABLED              true

add_max_dim_parameters  32 $max_width  32 $max_height
set_parameter_property  MAX_WIDTH                                    AFFECTS_ELABORATION  true
set_parameter_property  MAX_WIDTH                                    HDL_PARAMETER        false
set_parameter_property  MAX_HEIGHT                                   AFFECTS_ELABORATION  true
set_parameter_property  MAX_HEIGHT                                   HDL_PARAMETER        false

set_parameter_property  MAX_WIDTH                                    VISIBLE              false
set_parameter_property  MAX_HEIGHT                                   VISIBLE              false


add_user_packet_support_parameters
set_parameter_property  USER_PACKET_SUPPORT ALLOWED_RANGES {"PASSTHROUGH:Pass all user packets through to the output"}
set_parameter_property  USER_PACKET_FIFO_DEPTH                       HDL_PARAMETER        false
set_parameter_property  USER_PACKET_SUPPORT                          HDL_PARAMETER        false
set_parameter_property  USER_PACKET_FIFO_DEPTH                       VISIBLE              false

add_display_item        "Interface setup"                            BITS_PER_SYMBOL                  parameter
add_display_item        "Interface setup"                            PIXELS_IN_PARALLEL_IN            parameter
add_display_item        "Interface setup"                            PIXELS_IN_PARALLEL_OUT           parameter

proc validation_cb {} {
      set   colours_in_par                      [get_parameter_value NUMBER_OF_COLOR_PLANES]

        if {$colours_in_par > 4} {
            send_message error "Number of color planes ($colours_in_par) must be no greater than 4"
        }

}

proc composition_cb {} {
   global isVersion acdsVersion
   global max_width
   global max_height

   set pixels_in_parallel_in      [get_parameter_value PIXELS_IN_PARALLEL_IN]
   set pixels_in_parallel_out     [get_parameter_value PIXELS_IN_PARALLEL_OUT]
   set bits_per_symbol            [get_parameter_value BITS_PER_SYMBOL]
   set number_of_colors           [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set colors_in_par              [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set fifo_depth                 [get_parameter_value FIFO_DEPTH]

   add_instance                   pip_conv       alt_vip_pip_converter_core    $isVersion

   set_instance_parameter_value   pip_conv       PIXEL_WIDTH                   [expr $bits_per_symbol * $number_of_colors]
   set_instance_parameter_value   pip_conv       PIXELS_IN_PARALLEL_IN         $pixels_in_parallel_in
   set_instance_parameter_value   pip_conv       PIXELS_IN_PARALLEL_OUT        $pixels_in_parallel_out
   set_instance_parameter_value   pip_conv       FIFO_DEPTH                    $fifo_depth
   set_instance_parameter_value   pip_conv       PIPELINE_READY                1
   set_instance_parameter_value   pip_conv       SRC_WIDTH                     8
   set_instance_parameter_value   pip_conv       DST_WIDTH                     8
   set_instance_parameter_value   pip_conv       CONTEXT_WIDTH                 8
   set_instance_parameter_value   pip_conv       TASK_WIDTH                    8

   # --------------------------------------------------------------------------------------------------
   # -- Clock/reset bridges                                                                          --
   # --------------------------------------------------------------------------------------------------
   add_instance      av_st_clk_bridge              altera_clock_bridge        $acdsVersion
   add_instance      av_st_reset_bridge            altera_reset_bridge        $acdsVersion

   # --------------------------------------------------------------------------------------------------
   # -- sub-components                                                                              --
   # --------------------------------------------------------------------------------------------------

   add_instance   video_in_resp        alt_vip_video_input_bridge_resp  $isVersion
   add_instance   video_out            alt_vip_video_output_bridge      $isVersion

   set_instance_parameter_value  video_in_resp     VIB_MODE                      LITE
   set_instance_parameter_value  video_in_resp     ENABLE_RESOLUTION_CHECK       0
   set_instance_parameter_value  video_in_resp     READY_LATENCY_1               1
   set_instance_parameter_value  video_in_resp     MULTI_CONTEXT_SUPPORT         0
   set_instance_parameter_value  video_in_resp     PIPELINE_READY                1
   set_instance_parameter_value  video_in_resp     BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
   set_instance_parameter_value  video_in_resp     NUMBER_OF_COLOR_PLANES        $number_of_colors
   set_instance_parameter_value  video_in_resp     COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set_instance_parameter_value  video_in_resp     DEFAULT_LINE_LENGTH           1920
   set_instance_parameter_value  video_in_resp     PIXELS_IN_PARALLEL            $pixels_in_parallel_in
   set_instance_parameter_value  video_in_resp     VIDEO_PROTOCOL_NO             1
   set_instance_parameter_value  video_in_resp     MAX_WIDTH                     $max_width
   set_instance_parameter_value  video_in_resp     MAX_HEIGHT                    $max_height
   set_instance_parameter_value  video_in_resp     SRC_WIDTH                     8
   set_instance_parameter_value  video_in_resp     DST_WIDTH                     8
   set_instance_parameter_value  video_in_resp     CONTEXT_WIDTH                 8
   set_instance_parameter_value  video_in_resp     TASK_WIDTH                    8
   set_instance_parameter_value  video_in_resp     RESP_SRC_ADDRESS              0
   set_instance_parameter_value  video_in_resp     RESP_DST_ADDRESS              0
   set_instance_parameter_value  video_in_resp     DATA_SRC_ADDRESS              0

   set_instance_parameter_value  video_out         BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
   set_instance_parameter_value  video_out         NUMBER_OF_COLOR_PLANES        $number_of_colors
   set_instance_parameter_value  video_out         COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set_instance_parameter_value  video_out         PIXELS_IN_PARALLEL            $pixels_in_parallel_out
   set_instance_parameter_value  video_out         VIDEO_PROTOCOL_NO             1
   set_instance_parameter_value  video_out         READY_LATENCY_1               1
   set_instance_parameter_value  video_out         MULTI_CONTEXT_SUPPORT         0
   set_instance_parameter_value  video_out         LOW_LATENCY_COMMAND_MODE      0
   set_instance_parameter_value  video_out         NO_CONCATENATION              1
   set_instance_parameter_value  video_out         SOP_PRE_ALIGNED               1
   set_instance_parameter_value  video_out         SRC_WIDTH                     8
   set_instance_parameter_value  video_out         DST_WIDTH                     8
   set_instance_parameter_value  video_out         CONTEXT_WIDTH                 8
   set_instance_parameter_value  video_out         TASK_WIDTH                    8


   # --------------------------------------------------------------------------------------------------
   # -- connections                                                                                  --
   # --------------------------------------------------------------------------------------------------

   add_connection    av_st_clk_bridge.out_clk      av_st_reset_bridge.clk

   add_connection    av_st_clk_bridge.out_clk      video_in_resp.main_clock
   add_connection    av_st_reset_bridge.out_reset  video_in_resp.main_reset

   add_connection    av_st_clk_bridge.out_clk      video_out.main_clock
   add_connection    av_st_reset_bridge.out_reset  video_out.main_reset

   add_connection    av_st_clk_bridge.out_clk      pip_conv.main_clock
   add_connection    av_st_reset_bridge.out_reset  pip_conv.main_reset

   add_connection    video_in_resp.av_st_resp      video_out.av_st_cmd

   add_connection    video_in_resp.av_st_dout      pip_conv.av_st_din
   add_connection    pip_conv.av_st_dout           video_out.av_st_din

   # --------------------------------------------------------------------------------------------------
   # -- top level interface                                                                          --
   # --------------------------------------------------------------------------------------------------

   add_interface           main_clock  clock             end
   add_interface           main_reset  reset             end
   add_interface           din         avalon_streaming  sink
   add_interface           dout        avalon_streaming  source

   set_interface_property  main_clock  PORT_NAME_MAP     {main_clock in_clk}
   set_interface_property  main_reset  PORT_NAME_MAP     {main_reset in_reset}

   set_interface_property  main_clock     export_of      av_st_clk_bridge.in_clk
   set_interface_property  main_reset     export_of      av_st_reset_bridge.in_reset

   set_interface_property  din            export_of      video_in_resp.av_st_vid_din
   set_interface_property  dout           export_of      video_out.av_st_vid_dout


}
