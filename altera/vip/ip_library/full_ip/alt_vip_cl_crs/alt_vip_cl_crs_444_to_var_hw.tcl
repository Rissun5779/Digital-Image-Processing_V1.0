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


source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property  NAME           alt_vip_cl_crs_444_to_var
set_module_property  DISPLAY_NAME   "Chroma Resampler (4:4:4 to variable)"
set_module_property  DESCRIPTION    ""
set_module_property  INTERNAL       true

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set_module_property  VALIDATION_CALLBACK  validation_cb
set_module_property  COMPOSITION_CALLBACK composition_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set max_width $vipsuite_max_width
set max_height $vipsuite_max_height

add_bits_per_symbol_parameters
set_parameter_property  BITS_PER_SYMBOL               HDL_PARAMETER        false

add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES        VISIBLE              false
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false

add_parameter           PIP_IN                        INTEGER              2
set_parameter_property  PIP_IN                        DISPLAY_NAME         "Input pixels in parallel"
set_parameter_property  PIP_IN                        DESCRIPTION          ""
set_parameter_property  PIP_IN                        ALLOWED_RANGES       {1 2 4 8}
set_parameter_property  PIP_IN                        AFFECTS_ELABORATION  true
set_parameter_property  PIP_IN                        HDL_PARAMETER false

add_parameter           PIP_OUT                       INTEGER              2
set_parameter_property  PIP_OUT                       DISPLAY_NAME         "Output pixels in parallel"
set_parameter_property  PIP_OUT                       DESCRIPTION          ""
set_parameter_property  PIP_OUT                       ALLOWED_RANGES       {1 2 4 8}
set_parameter_property  PIP_OUT                       AFFECTS_ELABORATION  true
set_parameter_property  PIP_OUT                       HDL_PARAMETER        false

add_max_dim_parameters  32 $max_width  32 $max_height
set_parameter_property  MAX_WIDTH                     AFFECTS_ELABORATION  true
set_parameter_property  MAX_WIDTH                     HDL_PARAMETER        false
set_parameter_property  MAX_HEIGHT                    AFFECTS_ELABORATION  true
set_parameter_property  MAX_HEIGHT                    HDL_PARAMETER        false

add_parameter           HORIZ_ALGORITHM               STRING               BILINEAR
set_parameter_property  HORIZ_ALGORITHM               DISPLAY_NAME         "Horizontal resampling algorithm"
set_parameter_property  HORIZ_ALGORITHM               ALLOWED_RANGES       {NEAREST_NEIGHBOUR BILINEAR FILTERED} 
set_parameter_property  HORIZ_ALGORITHM               AFFECTS_ELABORATION  true
set_parameter_property  HORIZ_ALGORITHM               HDL_PARAMETER        false

add_parameter           HORIZ_CO_SITING               STRING               LEFT
set_parameter_property  HORIZ_CO_SITING               DISPLAY_NAME         "Horzontal chroma siting"
set_parameter_property  HORIZ_CO_SITING               ALLOWED_RANGES       {LEFT CENTRE} 
set_parameter_property  HORIZ_CO_SITING               AFFECTS_ELABORATION  true
set_parameter_property  HORIZ_CO_SITING               HDL_PARAMETER        false

add_parameter           VERT_ALGORITHM                STRING               BILINEAR
set_parameter_property  VERT_ALGORITHM                DISPLAY_NAME         "Vertical resampling algorithm"
set_parameter_property  VERT_ALGORITHM                ALLOWED_RANGES       {NEAREST_NEIGHBOUR BILINEAR FILTERED} 
set_parameter_property  VERT_ALGORITHM                AFFECTS_ELABORATION  true
set_parameter_property  VERT_ALGORITHM                HDL_PARAMETER        false

add_parameter           VERT_CO_SITING                STRING               TOP
set_parameter_property  VERT_CO_SITING                DISPLAY_NAME         "Vertical chroma siting"
set_parameter_property  VERT_CO_SITING                ALLOWED_RANGES       {TOP CENTRE} 
set_parameter_property  VERT_CO_SITING                AFFECTS_ELABORATION  true
set_parameter_property  VERT_CO_SITING                HDL_PARAMETER        false

add_parameter           ENABLE_444                    INTEGER              1
set_parameter_property  ENABLE_444                    DISPLAY_NAME         "Enable 4:4:4 output"
set_parameter_property  ENABLE_444                    DESCRIPTION          ""
set_parameter_property  ENABLE_444                    ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_444                    AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_444                    HDL_PARAMETER        false
set_parameter_property  ENABLE_444                    DISPLAY_HINT         boolean

add_parameter           ENABLE_422                    INTEGER              1
set_parameter_property  ENABLE_422                    DISPLAY_NAME         "Enable 4:2:2 output"
set_parameter_property  ENABLE_422                    DESCRIPTION          ""
set_parameter_property  ENABLE_422                    ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_422                    AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_422                    HDL_PARAMETER        false
set_parameter_property  ENABLE_422                    DISPLAY_HINT         boolean

add_parameter           ENABLE_420                    INTEGER              1
set_parameter_property  ENABLE_420                    DISPLAY_NAME         "Enable 4:2:0 output"
set_parameter_property  ENABLE_420                    DESCRIPTION          ""
set_parameter_property  ENABLE_420                    ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_420                    AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_420                    HDL_PARAMETER        false
set_parameter_property  ENABLE_420                    DISPLAY_HINT         boolean

add_user_packet_support_parameters
set_parameter_property  USER_PACKET_FIFO_DEPTH        HDL_PARAMETER        false
set_parameter_property  USER_PACKET_SUPPORT           HDL_PARAMETER        false
set_parameter_property  USER_PACKET_FIFO_DEPTH        VISIBLE              false

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Register Avalon-ST ready signals"
set_parameter_property  PIPELINE_READY                DESCRIPTION          ""
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION  true
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        false
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean

proc validation_cb {} {
    
}

proc composition_cb {} {
   global isVersion acdsVersion
   
   # --------------------------------------------------------------------------------------------------
   # -- Parameters                                                                                   --
   # --------------------------------------------------------------------------------------------------
   set   bits_per_symbol                     [get_parameter_value BITS_PER_SYMBOL]
   set   pixels_in_parallel_in               [get_parameter_value PIP_IN]
   set   pixels_in_parallel_out              [get_parameter_value PIP_OUT]
   if { $pixels_in_parallel_in == 1 } {
      set   pixels_in_parallel_middle        2
   } else {
      set   pixels_in_parallel_middle        $pixels_in_parallel_in
   }
   set   color_planes_are_in_parallel        [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   max_width                           [get_parameter_value MAX_WIDTH]
   set   max_height                          [get_parameter_value MAX_HEIGHT]
   set   pipeline_ready                      [get_parameter_value PIPELINE_READY]
   
   set   comp                                [get_parameter_value USER_PACKET_SUPPORT]
   set   match                               [string compare   $comp PASSTHROUGH]
   if { $match == 0 } {
      set   enable_user                      1
   } else {
      set   enable_user                      0
   }
   set   match                               [string compare   $comp DISCARD]
   if { $match == 0 } {
      set   enable_discard                   1
   } else {
      set   enable_discard                   0
   }
   set   enable_444                          [get_parameter_value ENABLE_444]
   set   enable_422                          [get_parameter_value ENABLE_422]
   set   enable_420                          [get_parameter_value ENABLE_420]
   
   set   enable_444_or_user                  [expr $enable_444 + $enable_user]
   set   enable_422_and_420                  [expr $enable_422 * $enable_420]
   set   enable_444_or_user_or_422_and_420   [expr $enable_444_or_user + $enable_422_and_420]
   set   enable_vib_cmd                      [expr $enable_444_or_user_or_422_and_420 + $enable_discard]
   set   enable_444_or_user_and_422          [expr $enable_444_or_user * $enable_422]
   set   enable_444_or_user_or_422           [expr $enable_444_or_user + $enable_422]
   set   enable_444_or_user_or_422_and_420   [expr $enable_444_or_user_or_422 * $enable_420]
   
   if { $color_planes_are_in_parallel > 0 } {
      set   input_data_width                 [expr $bits_per_symbol * 3]
      set   middle_data_width                [expr $bits_per_symbol * 2]
   } else {
      set   input_data_width                 $bits_per_symbol
      set   middle_data_width                $bits_per_symbol
   }
   
   set   algo_name                           [get_parameter_value VERT_ALGORITHM]
   if { [string compare $algo_name NEAREST_NEIGHBOUR] == 0 } {
      set   num_lines    2
   } else {
      set   algo_name                           [get_parameter_value VERT_ALGORITHM]
      if { [string compare $algo_name BILINEAR] == 0 } {
         set   num_lines    3
      } else {
         set   siting                           [get_parameter_value VERT_CO_SITING]
         if { [string compare $siting TOP] == 0 } {
            set   num_lines    8
         } else {
            set   num_lines    7
         }
      }
   } 
   
   # --------------------------------------------------------------------------------------------------
   # -- Clock/reset bridges                                                                          --
   # --------------------------------------------------------------------------------------------------
   add_instance      av_st_clk_bridge              altera_clock_bridge        $acdsVersion
   add_instance      av_st_reset_bridge            altera_reset_bridge        $acdsVersion
   
   add_connection    av_st_clk_bridge.out_clk      av_st_reset_bridge.clk
   
   add_interface           main_clock     clock                end
   add_interface           main_reset     reset                end
   add_interface           av_st_din      avalon_streaming     sink
   add_interface           av_st_dout     avalon_streaming     source
   
   set_interface_property  main_clock     export_of            av_st_clk_bridge.in_clk
   set_interface_property  main_reset     export_of            av_st_reset_bridge.in_reset
   
   # --------------------------------------------------------------------------------------------------
   # -- sub-components                                                                              --
   # --------------------------------------------------------------------------------------------------
   
   if { $enable_vib_cmd > 0 } {
      add_instance   video_in_cmd         alt_vip_video_input_bridge_cmd   $isVersion
      
      set_instance_parameter_value  video_in_cmd      BITS_PER_SYMBOL               $bits_per_symbol
      set_instance_parameter_value  video_in_cmd      NUMBER_OF_COLOR_PLANES        3
      set_instance_parameter_value  video_in_cmd      COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
      set_instance_parameter_value  video_in_cmd      PIXELS_IN_PARALLEL            $pixels_in_parallel_in
      set_instance_parameter_value  video_in_cmd      PIPELINE_READY                $pipeline_ready
      set_instance_parameter_value  video_in_cmd      SRC_WIDTH                     8
      set_instance_parameter_value  video_in_cmd      DST_WIDTH                     8
      set_instance_parameter_value  video_in_cmd      CONTEXT_WIDTH                 8
      set_instance_parameter_value  video_in_cmd      TASK_WIDTH                    8
      set_instance_parameter_value  video_in_cmd      DATA_SRC_ADDRESS              0
      
      add_connection    av_st_clk_bridge.out_clk         video_in_cmd.main_clock
      add_connection    av_st_reset_bridge.out_reset     video_in_cmd.main_reset
      
      add_interface           av_st_vib_cmd  avalon_streaming     sink
      
      set_interface_property  av_st_din            export_of      video_in_cmd.av_st_din
      set_interface_property  av_st_vib_cmd        export_of      video_in_cmd.av_st_cmd
   }
   
   if { $enable_444_or_user > 0 } {
      add_instance   input_demux       alt_vip_packet_demux             $isVersion
      
      set_instance_parameter_value   input_demux   DATA_WIDTH                    $input_data_width
      set_instance_parameter_value   input_demux   PIXELS_IN_PARALLEL            $pixels_in_parallel_in
      set_instance_parameter_value   input_demux   NUM_OUTPUTS                   2
      set_instance_parameter_value   input_demux   CLIP_ADDRESS_BITS             0
      set_instance_parameter_value   input_demux   SHIFT_ADDRESS_BITS            1
      set_instance_parameter_value   input_demux   REGISTER_OUTPUT               1
      set_instance_parameter_value   input_demux   SRC_WIDTH                     8
      set_instance_parameter_value   input_demux   DST_WIDTH                     8
      set_instance_parameter_value   input_demux   CONTEXT_WIDTH                 8
      set_instance_parameter_value   input_demux   TASK_WIDTH                    8
      set_instance_parameter_value   input_demux   USER_WIDTH                    0
      set_instance_parameter_value   input_demux   PIPELINE_READY                $pipeline_ready
      
      add_connection    av_st_clk_bridge.out_clk         input_demux.main_clock
      add_connection    av_st_reset_bridge.out_reset     input_demux.main_reset
      
      if { $enable_vib_cmd > 0 } {
         add_connection    video_in_cmd.av_st_dout       input_demux.av_st_din
      } else {
         set_interface_property  av_st_din   export_of   input_demux.av_st_din
      }  
   }
   
   add_instance      horiz_downsample  alt_vip_crs_h_down_core          $isVersion
   
   set_instance_parameter_value  horiz_downsample  BITS_PER_SYMBOL               $bits_per_symbol
   set_instance_parameter_value  horiz_downsample  ALGORITHM                     [get_parameter_value HORIZ_ALGORITHM]
   set_instance_parameter_value  horiz_downsample  CO_SITING                     [get_parameter_value HORIZ_CO_SITING]
   set_instance_parameter_value  horiz_downsample  COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
   set_instance_parameter_value  horiz_downsample  PIXELS_IN_PARALLEL            $pixels_in_parallel_in
   set_instance_parameter_value  horiz_downsample  PIPELINE_READY                $pipeline_ready
   set_instance_parameter_value  horiz_downsample  SRC_WIDTH                     8
   set_instance_parameter_value  horiz_downsample  DST_WIDTH                     8
   set_instance_parameter_value  horiz_downsample  CONTEXT_WIDTH                 8
   set_instance_parameter_value  horiz_downsample  TASK_WIDTH                    8
   
   add_connection    av_st_clk_bridge.out_clk         horiz_downsample.main_clock
   add_connection    av_st_reset_bridge.out_reset     horiz_downsample.main_reset
   
   if { $enable_444_or_user > 0 } {
      add_connection    input_demux.av_st_dout_0         horiz_downsample.av_st_din
   } else {
      if { $enable_vib_cmd > 0 } {
         add_connection    video_in_cmd.av_st_dout       horiz_downsample.av_st_din
      } else {
         set_interface_property  av_st_din   export_of   horiz_downsample.av_st_din
      }
   }
   
   if { $enable_422_and_420 > 0 } {
      add_instance   middle_demux      alt_vip_packet_demux             $isVersion
      
      set_instance_parameter_value   middle_demux     DATA_WIDTH                    $middle_data_width
      set_instance_parameter_value   middle_demux     PIXELS_IN_PARALLEL            $pixels_in_parallel_in
      set_instance_parameter_value   middle_demux     NUM_OUTPUTS                   2
      set_instance_parameter_value   middle_demux     CLIP_ADDRESS_BITS             0
      set_instance_parameter_value   middle_demux     REGISTER_OUTPUT               1
      set_instance_parameter_value   middle_demux     SRC_WIDTH                     8
      set_instance_parameter_value   middle_demux     DST_WIDTH                     8
      set_instance_parameter_value   middle_demux     CONTEXT_WIDTH                 8
      set_instance_parameter_value   middle_demux     TASK_WIDTH                    8
      set_instance_parameter_value   middle_demux     USER_WIDTH                    0
      set_instance_parameter_value   middle_demux     PIPELINE_READY                $pipeline_ready
      
      add_connection    av_st_clk_bridge.out_clk         middle_demux.main_clock
      add_connection    av_st_reset_bridge.out_reset     middle_demux.main_reset
      
      add_connection    horiz_downsample.av_st_dout      middle_demux.av_st_din
   }
   
   if { $enable_422 > 0 } {
      add_instance   pad_422           alt_vip_crs_422_drop_pad         $isVersion
      
      set_instance_parameter_value  pad_422     PAD_MODE                      1
      set_instance_parameter_value  pad_422     BITS_PER_SYMBOL               $bits_per_symbol
      set_instance_parameter_value  pad_422     COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
      set_instance_parameter_value  pad_422     PIXELS_IN_PARALLEL            $pixels_in_parallel_in
      set_instance_parameter_value  pad_422     SRC_WIDTH                     8
      set_instance_parameter_value  pad_422     DST_WIDTH                     8
      set_instance_parameter_value  pad_422     CONTEXT_WIDTH                 8
      set_instance_parameter_value  pad_422     TASK_WIDTH                    8
      
      add_connection    av_st_clk_bridge.out_clk         pad_422.main_clock
      add_connection    av_st_reset_bridge.out_reset     pad_422.main_reset
      
      if { $enable_422_and_420 > 0 } {
         add_connection    middle_demux.av_st_dout_1     pad_422.av_st_din
      } else {
         add_connection    horiz_downsample.av_st_dout   pad_422.av_st_din
      }
   }
   
   if { $enable_420 > 0 } {
      add_instance   line_buffer       alt_vip_line_buffer              $isVersion
      add_instance   pip_420_in        alt_vip_pip_converter_core       $isVersion
      add_instance   vert_downsample   alt_vip_crs_v_down_core          $isVersion
      add_instance   pip_420_out       alt_vip_pip_converter_core       $isVersion
      
      set_instance_parameter_value  line_buffer    PIXEL_WIDTH             $middle_data_width
      set_instance_parameter_value  line_buffer    PIXELS_IN_PARALLEL      $pixels_in_parallel_in
      set_instance_parameter_value  line_buffer    CONVERT_TO_1_PIP        0
      set_instance_parameter_value  line_buffer    SYMBOLS_IN_SEQ          1
      set_instance_parameter_value  line_buffer    MAX_LINE_LENGTH         [get_parameter_value MAX_WIDTH]
      set_instance_parameter_value  line_buffer    OUTPUT_PORTS            1
      set_instance_parameter_value  line_buffer    MODE                    LOCKED
      set_instance_parameter_value  line_buffer    ENABLE_RECEIVE_ONLY_CMD 0
      set_instance_parameter_value  line_buffer    TRACK_LINE_LENGTH       0
      set_instance_parameter_value  line_buffer    OUTPUT_MUX_SEL          NEW
      if { $pipeline_ready > 0 } {
         set_instance_parameter_value  line_buffer OUTPUT_OPTION           PIPELINED
      } else {
         set_instance_parameter_value  line_buffer OUTPUT_OPTION           UNPIPELINED
      }
      set_instance_parameter_value  line_buffer    FIFO_SIZE               4
      set_instance_parameter_value  line_buffer    KERNEL_SIZE_0           $num_lines
      set_instance_parameter_value  line_buffer    KERNEL_CENTER_0         [expr int(floor($num_lines / 2))]
      set_instance_parameter_value  line_buffer    SRC_WIDTH               8
      set_instance_parameter_value  line_buffer    DST_WIDTH               8
      set_instance_parameter_value  line_buffer    CONTEXT_WIDTH           8
      set_instance_parameter_value  line_buffer    TASK_WIDTH              8
      set_instance_parameter_value  line_buffer    SOURCE_ADDRESS          0

      set_instance_parameter_value  pip_420_in  PIXEL_WIDTH                [expr $middle_data_width * $num_lines]
      set_instance_parameter_value  pip_420_in  PIXELS_IN_PARALLEL_IN      $pixels_in_parallel_in
      set_instance_parameter_value  pip_420_in  PIXELS_IN_PARALLEL_OUT     $pixels_in_parallel_middle
      set_instance_parameter_value  pip_420_in  FIFO_DEPTH                 0
      set_instance_parameter_value  pip_420_in  PIPELINE_READY             $pipeline_ready
      set_instance_parameter_value  pip_420_in  SRC_WIDTH                  8
      set_instance_parameter_value  pip_420_in  DST_WIDTH                  8
      set_instance_parameter_value  pip_420_in  CONTEXT_WIDTH              8
      set_instance_parameter_value  pip_420_in  TASK_WIDTH                 8
      
      set_instance_parameter_value  vert_downsample   BITS_PER_SYMBOL      $bits_per_symbol
      set_instance_parameter_value  vert_downsample   ALGORITHM            [get_parameter_value VERT_ALGORITHM]
      set_instance_parameter_value  vert_downsample   CO_SITING            [get_parameter_value VERT_CO_SITING]
      set_instance_parameter_value  vert_downsample   PIXELS_IN_PARALLEL   $pixels_in_parallel_middle
      set_instance_parameter_value  vert_downsample   PIPELINE_READY       $pipeline_ready
      set_instance_parameter_value  vert_downsample   SRC_WIDTH            8
      set_instance_parameter_value  vert_downsample   DST_WIDTH            8
      set_instance_parameter_value  vert_downsample   CONTEXT_WIDTH        8
      set_instance_parameter_value  vert_downsample   TASK_WIDTH           8
      set_instance_parameter_value  vert_downsample   SOURCE_ID            0
      
      set_instance_parameter_value  pip_420_out PIXEL_WIDTH                $input_data_width
      set_instance_parameter_value  pip_420_out PIXELS_IN_PARALLEL_IN      [expr $pixels_in_parallel_middle / 2] 
      set_instance_parameter_value  pip_420_out PIXELS_IN_PARALLEL_OUT     $pixels_in_parallel_out
      set_instance_parameter_value  pip_420_out FIFO_DEPTH                 0
      set_instance_parameter_value  pip_420_out PIPELINE_READY             $pipeline_ready
      set_instance_parameter_value  pip_420_out SRC_WIDTH                  8
      set_instance_parameter_value  pip_420_out DST_WIDTH                  8
      set_instance_parameter_value  pip_420_out CONTEXT_WIDTH              8
      set_instance_parameter_value  pip_420_out TASK_WIDTH                 8
      
      add_interface           av_st_lb_cmd   avalon_streaming     sink
      add_interface           av_st_vert_cmd avalon_streaming     sink
      
      set_interface_property  av_st_lb_cmd            export_of      line_buffer.av_st_cmd
      set_interface_property  av_st_vert_cmd          export_of      vert_downsample.av_st_cmd
      
      add_connection    av_st_clk_bridge.out_clk         line_buffer.main_clock
      add_connection    av_st_reset_bridge.out_reset     line_buffer.main_reset
      add_connection    av_st_clk_bridge.out_clk         vert_downsample.main_clock
      add_connection    av_st_reset_bridge.out_reset     vert_downsample.main_reset
      add_connection    av_st_clk_bridge.out_clk         pip_420_out.main_clock
      add_connection    av_st_reset_bridge.out_reset     pip_420_out.main_reset
      add_connection    av_st_clk_bridge.out_clk         pip_420_in.main_clock
      add_connection    av_st_reset_bridge.out_reset     pip_420_in.main_reset
      
      if { $enable_422_and_420 > 0 } {
         add_connection middle_demux.av_st_dout_0     line_buffer.av_st_din
      } else {
         add_connection horiz_downsample.av_st_dout   line_buffer.av_st_din
      }
      add_connection    line_buffer.av_st_dout_0      pip_420_in.av_st_din      
      add_connection    pip_420_in.av_st_dout         vert_downsample.av_st_din
      add_connection    vert_downsample.av_st_dout    pip_420_out.av_st_din
   }
   
   if { $enable_444_or_user_and_422 > 0 } {
      add_instance   middle_mux        alt_vip_packet_mux               $isVersion
      
      set_instance_parameter_value   middle_mux    DATA_WIDTH                    $input_data_width
      set_instance_parameter_value   middle_mux    PIXELS_IN_PARALLEL            $pixels_in_parallel_in
      set_instance_parameter_value   middle_mux    NUM_INPUTS                    2
      set_instance_parameter_value   middle_mux    SRC_WIDTH                     8
      set_instance_parameter_value   middle_mux    DST_WIDTH                     8
      set_instance_parameter_value   middle_mux    CONTEXT_WIDTH                 8
      set_instance_parameter_value   middle_mux    TASK_WIDTH                    8
      set_instance_parameter_value   middle_mux    USER_WIDTH                    0
      set_instance_parameter_value   middle_mux    PIPELINE_READY                $pipeline_ready
      
      add_connection    av_st_clk_bridge.out_clk         middle_mux.main_clock
      add_connection    av_st_reset_bridge.out_reset     middle_mux.main_reset
      
      add_interface           av_st_mm_cmd   avalon_streaming     sink
      
      set_interface_property  av_st_mm_cmd            export_of      middle_mux.av_st_cmd
      
      add_connection    pad_422.av_st_dout               middle_mux.av_st_din_0
      add_connection    input_demux.av_st_dout_1         middle_mux.av_st_din_1
   }
   
   if { $enable_444_or_user_or_422 > 0 } {
      add_instance   pip_other         alt_vip_pip_converter_core       $isVersion
      
      set_instance_parameter_value  pip_other     PIXEL_WIDTH                   $input_data_width
      set_instance_parameter_value  pip_other     PIXELS_IN_PARALLEL_IN         $pixels_in_parallel_in 
      set_instance_parameter_value  pip_other     PIXELS_IN_PARALLEL_OUT        $pixels_in_parallel_out
      set_instance_parameter_value  pip_other     FIFO_DEPTH                    0
      set_instance_parameter_value  pip_other     PIPELINE_READY                $pipeline_ready
      set_instance_parameter_value  pip_other     SRC_WIDTH                     8
      set_instance_parameter_value  pip_other     DST_WIDTH                     8
      set_instance_parameter_value  pip_other     CONTEXT_WIDTH                 8
      set_instance_parameter_value  pip_other     TASK_WIDTH                    8
      
      add_connection    av_st_clk_bridge.out_clk         pip_other.main_clock
      add_connection    av_st_reset_bridge.out_reset     pip_other.main_reset
      
      if { $enable_444_or_user > 0 } {
         if { $enable_422 > 0 } {
            add_connection middle_mux.av_st_dout            pip_other.av_st_din
         } else {
            add_connection input_demux.av_st_dout_1         pip_other.av_st_din
         }
      } else {
         add_connection    pad_422.av_st_dout               pip_other.av_st_din
      }
   }
   
   if { $enable_444_or_user_or_422_and_420 > 0 } {
      add_instance   output_mux        alt_vip_packet_mux               $isVersion
      
      set_instance_parameter_value   output_mux    DATA_WIDTH                    $input_data_width
      set_instance_parameter_value   output_mux    PIXELS_IN_PARALLEL            $pixels_in_parallel_out
      set_instance_parameter_value   output_mux    NUM_INPUTS                    2
      set_instance_parameter_value   output_mux    SRC_WIDTH                     8
      set_instance_parameter_value   output_mux    DST_WIDTH                     8
      set_instance_parameter_value   output_mux    CONTEXT_WIDTH                 8
      set_instance_parameter_value   output_mux    TASK_WIDTH                    8
      set_instance_parameter_value   output_mux    USER_WIDTH                    0
      set_instance_parameter_value   output_mux    PIPELINE_READY                $pipeline_ready
      
      add_connection    av_st_clk_bridge.out_clk         output_mux.main_clock
      add_connection    av_st_reset_bridge.out_reset     output_mux.main_reset
      
      add_interface           av_st_om_cmd            avalon_streaming  sink
      
      set_interface_property  av_st_om_cmd            export_of         output_mux.av_st_cmd
      set_interface_property  av_st_dout              export_of         output_mux.av_st_dout
      
      add_connection    pip_420_out.av_st_dout           output_mux.av_st_din_0           
      add_connection    pip_other.av_st_dout             output_mux.av_st_din_1           
   } else {
      if { $enable_420 } {
         set_interface_property  av_st_dout  export_of   pip_420_out.av_st_dout
      } else {
         set_interface_property  av_st_dout  export_of   pip_other.av_st_dout
      }
   }
   
   

}
