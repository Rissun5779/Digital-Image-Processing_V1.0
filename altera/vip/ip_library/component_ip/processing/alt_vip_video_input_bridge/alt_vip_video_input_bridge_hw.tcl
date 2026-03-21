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
#-- _hw.tcl compose file for Component Library alt_vip_video_input_bridge                         --
#-- Compose alt_vip_video_input_bridge_resp and alt_vip_video_input_bridge_cmd                    --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl

# Common component properties for VIP components
declare_general_component_info

# Component properties
set_module_property NAME alt_vip_video_input_bridge
set_module_property DISPLAY_NAME "Video Input Bridge"
set_module_property DESCRIPTION "The Video input bridge processes input packets to send responses to the scheduler. Image packetss can be broken into line packets"

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
set_module_property VALIDATION_CALLBACK vib_validation_callback

# Composition callback to put the components together
set_module_property COMPOSITION_CALLBACK vib_composition_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_bits_per_symbol_parameters
set_parameter_property  BITS_PER_SYMBOL               HDL_PARAMETER        false

add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false

add_pixels_in_parallel_parameters $vipsuite_allowed_pip_ranges
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER        false

add_parameter           DEFAULT_LINE_LENGTH     INTEGER              1920
set_parameter_property  DEFAULT_LINE_LENGTH     ALLOWED_RANGES       20:$vipsuite_max_width
set_parameter_property  DEFAULT_LINE_LENGTH     HDL_PARAMETER        false
set_parameter_property  DEFAULT_LINE_LENGTH     AFFECTS_ELABORATION  true
set_parameter_property  DEFAULT_LINE_LENGTH     DISPLAY_NAME         "Default line length"

add_parameter           VIB_MODE                STRING               LEGACY
set_parameter_property  VIB_MODE                ALLOWED_RANGES       {LEGACY FULL LITE}
set_parameter_property  VIB_MODE                AFFECTS_ELABORATION  true
set_parameter_property  VIB_MODE                HDL_PARAMETER        false
set_parameter_property  VIB_MODE                DISPLAY_NAME         "Mode"

add_parameter           VIDEO_PROTOCOL_NO       INTEGER              1
set_parameter_property  VIDEO_PROTOCOL_NO       ALLOWED_RANGES       {1}
set_parameter_property  VIDEO_PROTOCOL_NO       AFFECTS_ELABORATION  true
set_parameter_property  VIDEO_PROTOCOL_NO       HDL_PARAMETER        false
set_parameter_property  VIDEO_PROTOCOL_NO       DISPLAY_NAME         "Video protocol version"

add_parameter           READY_LATENCY_1         INTEGER              1
set_parameter_property  READY_LATENCY_1         ALLOWED_RANGES       {0 1}
set_parameter_property  READY_LATENCY_1         DISPLAY_HINT         ""
set_parameter_property  READY_LATENCY_1         AFFECTS_ELABORATION  true
set_parameter_property  READY_LATENCY_1         HDL_PARAMETER        false
set_parameter_property  READY_LATENCY_1         DISPLAY_NAME         "Input ready latency"

add_parameter           MAX_WIDTH               INTEGER              1920
set_parameter_property  MAX_WIDTH               ALLOWED_RANGES       32:$vipsuite_max_width
set_parameter_property  MAX_WIDTH               HDL_PARAMETER        false
set_parameter_property  MAX_WIDTH               AFFECTS_ELABORATION  true
set_parameter_property  MAX_WIDTH               DISPLAY_NAME         "Maximum line length"

add_parameter           MAX_HEIGHT              INTEGER              1080
set_parameter_property  MAX_HEIGHT              ALLOWED_RANGES       32:$vipsuite_max_height
set_parameter_property  MAX_HEIGHT              HDL_PARAMETER        false
set_parameter_property  MAX_HEIGHT              AFFECTS_ELABORATION  true
set_parameter_property  MAX_HEIGHT              DISPLAY_NAME         "Maximum frame/field height"

add_parameter           ENABLE_RESOLUTION_CHECK INTEGER              0
set_parameter_property  ENABLE_RESOLUTION_CHECK ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_RESOLUTION_CHECK DISPLAY_HINT         boolean
set_parameter_property  ENABLE_RESOLUTION_CHECK AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_RESOLUTION_CHECK HDL_PARAMETER        false
set_parameter_property  ENABLE_RESOLUTION_CHECK DISPLAY_NAME         "Enable input control packet resolution checks"

add_parameter           MULTI_CONTEXT_SUPPORT   INTEGER              0
set_parameter_property  MULTI_CONTEXT_SUPPORT   ALLOWED_RANGES       0:1
set_parameter_property  MULTI_CONTEXT_SUPPORT   DISPLAY_HINT         boolean
set_parameter_property  MULTI_CONTEXT_SUPPORT   AFFECTS_ELABORATION  true
set_parameter_property  MULTI_CONTEXT_SUPPORT   HDL_PARAMETER        false
set_parameter_property  MULTI_CONTEXT_SUPPORT   DISPLAY_NAME         "Enable support for context packets"

add_parameter           PIPELINE_READY          INTEGER              0
set_parameter_property  PIPELINE_READY          ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY          DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY          AFFECTS_ELABORATION  true
set_parameter_property  PIPELINE_READY          HDL_PARAMETER        false
set_parameter_property  PIPELINE_READY          DISPLAY_NAME         "Pipeline Av-ST ready signals"

add_parameter           RESP_SRC_ADDRESS        INTEGER              0
set_parameter_property  RESP_SRC_ADDRESS        AFFECTS_ELABORATION  true
set_parameter_property  RESP_SRC_ADDRESS        HDL_PARAMETER        false
set_parameter_property  RESP_SRC_ADDRESS        DISPLAY_NAME         "Response source ID"

add_parameter           RESP_DST_ADDRESS        INTEGER              0
set_parameter_property  RESP_DST_ADDRESS        AFFECTS_ELABORATION  true
set_parameter_property  RESP_DST_ADDRESS        HDL_PARAMETER        false
set_parameter_property  RESP_DST_ADDRESS        DISPLAY_NAME         "Default response destination ID"

add_parameter           DATA_SRC_ADDRESS        INTEGER              0
set_parameter_property  DATA_SRC_ADDRESS        AFFECTS_ELABORATION  true
set_parameter_property  DATA_SRC_ADDRESS        HDL_PARAMETER        false
set_parameter_property  DATA_SRC_ADDRESS        DISPLAY_NAME         "Dout source ID"

add_av_st_event_parameters
set_parameter_property  SRC_WIDTH               HDL_PARAMETER        false
set_parameter_property  DST_WIDTH               HDL_PARAMETER        false
set_parameter_property  CONTEXT_WIDTH           HDL_PARAMETER        false
set_parameter_property  TASK_WIDTH              HDL_PARAMETER        false


proc vib_validation_callback {} {
    set color_planes_are_in_parallel          [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel                    [get_parameter_value PIXELS_IN_PARALLEL]
    set task_width                            [get_parameter_value TASK_WIDTH]

    if { $pixels_in_parallel > 1 } {
        if { $color_planes_are_in_parallel == 0 } {
            send_message Error "All colour planes must be in parallel to enable more than 1 pixel in parallel"
        }
    }
    if { $task_width == 0 } {
        send_message Error "Task width must be greater than 0"
    }
}


proc vib_composition_callback {} {

    global isVersion acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set   bits_per_symbol                     [get_parameter_value BITS_PER_SYMBOL]
    set   number_of_color_planes              [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set   color_planes_are_in_parallel        [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set   pixels_in_parallel                  [get_parameter_value PIXELS_IN_PARALLEL]
    set   default_line_length                 [get_parameter_value DEFAULT_LINE_LENGTH]
    set   vib_mode                            [get_parameter_value VIB_MODE]
    set   video_protocol_no                   [get_parameter_value VIDEO_PROTOCOL_NO]
    set   ready_latency_1                     [get_parameter_value READY_LATENCY_1]
    set   multi_context_support               [get_parameter_value MULTI_CONTEXT_SUPPORT]
    set   max_width                           [get_parameter_value MAX_WIDTH]
    set   max_height                          [get_parameter_value MAX_HEIGHT]
    set   enable_resolution_check             [get_parameter_value ENABLE_RESOLUTION_CHECK]
    set   pipeline_ready                      [get_parameter_value PIPELINE_READY]
    set   resp_src_address                    [get_parameter_value RESP_SRC_ADDRESS]
    set   resp_dst_address                    [get_parameter_value RESP_DST_ADDRESS]
    set   data_src_address                    [get_parameter_value DATA_SRC_ADDRESS]
    set   src_width                           [get_parameter_value SRC_WIDTH]
    set   dst_width                           [get_parameter_value DST_WIDTH]
    set   context_width                       [get_parameter_value CONTEXT_WIDTH]
    set   task_width                          [get_parameter_value TASK_WIDTH]

    # --------------------------------------------------------------------------------------------------
    # -- Clock/reset bridges                                                                          --
    # --------------------------------------------------------------------------------------------------
    add_instance            clk_bridge              altera_clock_bridge              $acdsVersion
    add_instance            reset_bridge            altera_reset_bridge              $acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- sub-components                                                                              --
    # --------------------------------------------------------------------------------------------------
    add_instance            vid_front               alt_vip_video_input_bridge_resp  $isVersion
    add_instance            vid_back                alt_vip_video_input_bridge_cmd   $isVersion

    # Video input bridge front-end parameterization
    set_instance_parameter_value  vid_front   BITS_PER_SYMBOL               $bits_per_symbol
    set_instance_parameter_value  vid_front   NUMBER_OF_COLOR_PLANES        $number_of_color_planes
    set_instance_parameter_value  vid_front   COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
    set_instance_parameter_value  vid_front   PIXELS_IN_PARALLEL            $pixels_in_parallel
    set_instance_parameter_value  vid_front   DEFAULT_LINE_LENGTH           $default_line_length
    set_instance_parameter_value  vid_front   VIB_MODE                      $vib_mode
    set_instance_parameter_value  vid_front   VIDEO_PROTOCOL_NO             $video_protocol_no
    set_instance_parameter_value  vid_front   READY_LATENCY_1               $ready_latency_1
    set_instance_parameter_value  vid_front   MULTI_CONTEXT_SUPPORT         $multi_context_support
    set_instance_parameter_value  vid_front   MAX_WIDTH                     $max_width
    set_instance_parameter_value  vid_front   MAX_HEIGHT                    $max_height
    set_instance_parameter_value  vid_front   ENABLE_RESOLUTION_CHECK       $enable_resolution_check
    set_instance_parameter_value  vid_front   PIPELINE_READY                0
    set_instance_parameter_value  vid_front   RESP_SRC_ADDRESS              $resp_src_address
    set_instance_parameter_value  vid_front   RESP_DST_ADDRESS              $resp_dst_address
    set_instance_parameter_value  vid_front   DATA_SRC_ADDRESS              $data_src_address
    set_instance_parameter_value  vid_front   SRC_WIDTH                     $src_width
    set_instance_parameter_value  vid_front   DST_WIDTH                     $dst_width
    set_instance_parameter_value  vid_front   CONTEXT_WIDTH                 $context_width
    set_instance_parameter_value  vid_front   TASK_WIDTH                    $task_width
   
    # Video input bridge back-end parameterization
    set_instance_parameter_value  vid_back    BITS_PER_SYMBOL               $bits_per_symbol
    set_instance_parameter_value  vid_back    NUMBER_OF_COLOR_PLANES        $number_of_color_planes
    set_instance_parameter_value  vid_back    COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
    set_instance_parameter_value  vid_back    PIXELS_IN_PARALLEL            $pixels_in_parallel
    set_instance_parameter_value  vid_back    PIPELINE_READY                $pipeline_ready
    set_instance_parameter_value  vid_back    DATA_SRC_ADDRESS              $data_src_address
    set_instance_parameter_value  vid_back    SRC_WIDTH                     $src_width
    set_instance_parameter_value  vid_back    DST_WIDTH                     $dst_width
    set_instance_parameter_value  vid_back    CONTEXT_WIDTH                 $context_width
    set_instance_parameter_value  vid_back    TASK_WIDTH                    $task_width

    # --------------------------------------------------------------------------------------------------
    # -- Top-level interfaces                                                                         --
    # --------------------------------------------------------------------------------------------------
    add_interface           main_clock              clock                            end
    add_interface           main_reset              reset                            end
    add_interface           av_st_vid_din           avalon_streaming                 sink
    add_interface           av_st_cmd               avalon_streaming                 sink
    add_interface           av_st_resp              avalon_streaming                 source
    add_interface           av_st_dout              avalon_streaming                 source

    set_interface_property  main_clock              export_of                        clk_bridge.in_clk
    set_interface_property  main_reset              export_of                        reset_bridge.in_reset
    set_interface_property  av_st_vid_din           export_of                        vid_front.av_st_vid_din
    set_interface_property  av_st_cmd               export_of                        vid_back.av_st_cmd
    set_interface_property  av_st_resp              export_of                        vid_front.av_st_resp
    set_interface_property  av_st_dout              export_of                        vid_back.av_st_dout

    # --------------------------------------------------------------------------------------------------
    # -- Connection of sub-components                                                                 --
    # --------------------------------------------------------------------------------------------------
    # Av-ST clock/reset connections
    add_connection          clk_bridge.out_clk      reset_bridge.clk
    add_connection          clk_bridge.out_clk      vid_front.main_clock
    add_connection          clk_bridge.out_clk      vid_back.main_clock
    add_connection          reset_bridge.out_reset  vid_front.main_reset
    add_connection          reset_bridge.out_reset  vid_back.main_reset
    
   
    # Data path connections
    add_connection          vid_front.av_st_dout    vid_back.av_st_din
   
}
