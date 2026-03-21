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
# --                                                                                              --
# -- _hw.tcl file for the alt_vip_video_input_bridge_resp component                               --
# -- This block receives video data and generates responses and video output                      --
# -- data in Avalon-ST message Video format.                                                      --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl

# Common component properties for VIP components
declare_general_component_info

# Component properties
set_module_property NAME alt_vip_video_input_bridge_resp
set_module_property DISPLAY_NAME "Video Input Bridge (resp only)"
set_module_property DESCRIPTION ""
if {$vib_vob_removal > 0} {
   set_module_property     INTERNAL                         false
   set_module_property     HIDE_FROM_QUARTUS                false
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
set_module_property VALIDATION_CALLBACK vib_resp_validation_callback

# Elaboration callback to set up the dynamic ports
set_module_property ELABORATION_CALLBACK vib_resp_elaboration_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_video_packet_decode ../../..
add_static_sv_file src_hdl/alt_vip_video_input_bridge_resp.sv

setup_filesets alt_vip_video_input_bridge_resp

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
# add BITS_PER_SYMBOL
add_bits_per_symbol_parameters

# add NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL      ALLOWED_RANGES       $vipsuite_allowed_pip_ranges

add_parameter           DEFAULT_LINE_LENGTH     INTEGER              1920
set_parameter_property  DEFAULT_LINE_LENGTH     ALLOWED_RANGES       32:$vipsuite_max_width
set_parameter_property  DEFAULT_LINE_LENGTH     HDL_PARAMETER        true
set_parameter_property  DEFAULT_LINE_LENGTH     AFFECTS_ELABORATION  false
set_parameter_property  DEFAULT_LINE_LENGTH     DISPLAY_NAME         "Default line length"

add_parameter           VIB_MODE                STRING               LEGACY
set_parameter_property  VIB_MODE                ALLOWED_RANGES       {LEGACY FULL LITE}
set_parameter_property  VIB_MODE                AFFECTS_ELABORATION  true
set_parameter_property  VIB_MODE                HDL_PARAMETER        true
set_parameter_property  VIB_MODE                DISPLAY_NAME         "Mode"

add_parameter           VIDEO_PROTOCOL_NO       INTEGER              1
set_parameter_property  VIDEO_PROTOCOL_NO       ALLOWED_RANGES       {1}
set_parameter_property  VIDEO_PROTOCOL_NO       AFFECTS_ELABORATION  false
set_parameter_property  VIDEO_PROTOCOL_NO       HDL_PARAMETER        true
set_parameter_property  VIDEO_PROTOCOL_NO       DISPLAY_NAME         "Video protocol version"

add_parameter           READY_LATENCY_1         INTEGER              1
set_parameter_property  READY_LATENCY_1         ALLOWED_RANGES       {0 1}
set_parameter_property  READY_LATENCY_1         DISPLAY_HINT         ""
set_parameter_property  READY_LATENCY_1         AFFECTS_ELABORATION  true
set_parameter_property  READY_LATENCY_1         HDL_PARAMETER        true
set_parameter_property  READY_LATENCY_1         DISPLAY_NAME         "Input ready latency"

add_parameter           MAX_WIDTH               INTEGER              1920
set_parameter_property  MAX_WIDTH               ALLOWED_RANGES       32:$vipsuite_max_width
set_parameter_property  MAX_WIDTH               HDL_PARAMETER        true
set_parameter_property  MAX_WIDTH               AFFECTS_ELABORATION  false
set_parameter_property  MAX_WIDTH               DISPLAY_NAME         "Maximum line length"

add_parameter           MAX_HEIGHT              INTEGER              1080
set_parameter_property  MAX_HEIGHT              ALLOWED_RANGES       32:$vipsuite_max_height
set_parameter_property  MAX_HEIGHT              HDL_PARAMETER        true
set_parameter_property  MAX_HEIGHT              AFFECTS_ELABORATION  false
set_parameter_property  MAX_HEIGHT              DISPLAY_NAME         "Maximum frame/field height"

add_parameter           ENABLE_RESOLUTION_CHECK INTEGER              0
set_parameter_property  ENABLE_RESOLUTION_CHECK ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_RESOLUTION_CHECK DISPLAY_HINT         boolean
set_parameter_property  ENABLE_RESOLUTION_CHECK AFFECTS_ELABORATION  false
set_parameter_property  ENABLE_RESOLUTION_CHECK HDL_PARAMETER        true
set_parameter_property  ENABLE_RESOLUTION_CHECK DISPLAY_NAME         "Enable input control packet resolution checks"

add_parameter           MULTI_CONTEXT_SUPPORT   INTEGER              0
set_parameter_property  MULTI_CONTEXT_SUPPORT   ALLOWED_RANGES       0:1
set_parameter_property  MULTI_CONTEXT_SUPPORT   DISPLAY_HINT         boolean
set_parameter_property  MULTI_CONTEXT_SUPPORT   AFFECTS_ELABORATION  false
set_parameter_property  MULTI_CONTEXT_SUPPORT   HDL_PARAMETER        true
set_parameter_property  MULTI_CONTEXT_SUPPORT   DISPLAY_NAME         "Enable support for context packets"

add_parameter           PIPELINE_READY          INTEGER              0
set_parameter_property  PIPELINE_READY          ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY          DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY          AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY          HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY          DISPLAY_NAME         "Pipeline Av-ST ready signals"

add_parameter           RESP_SRC_ADDRESS        INTEGER              0
set_parameter_property  RESP_SRC_ADDRESS        AFFECTS_ELABORATION  true
set_parameter_property  RESP_SRC_ADDRESS        HDL_PARAMETER        true
set_parameter_property  RESP_SRC_ADDRESS        DISPLAY_NAME         "Response source ID"

add_parameter           RESP_DST_ADDRESS        INTEGER              0
set_parameter_property  RESP_DST_ADDRESS        AFFECTS_ELABORATION  true
set_parameter_property  RESP_DST_ADDRESS        HDL_PARAMETER        true
set_parameter_property  RESP_DST_ADDRESS        DISPLAY_NAME         "Default response destination ID"

add_parameter           DATA_SRC_ADDRESS        INTEGER              0
set_parameter_property  DATA_SRC_ADDRESS        AFFECTS_ELABORATION  true
set_parameter_property  DATA_SRC_ADDRESS        HDL_PARAMETER        true
set_parameter_property  DATA_SRC_ADDRESS        DISPLAY_NAME         "Dout source ID"

# add SRC_WIDTH, DST_WIDTH, CONTEXT_WIDTH, TASK_WIDTH
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
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc vib_resp_validation_callback {} {
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


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc vib_resp_elaboration_callback {} {

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set   bits_per_symbol      [get_parameter_value BITS_PER_SYMBOL]
    set   num_of_colour_planes [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set   are_in_par           [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set   pixels_in_parallel   [get_parameter_value PIXELS_IN_PARALLEL]
    set   resp_src_address     [get_parameter_value RESP_SRC_ADDRESS]
    set   resp_dst_address     [get_parameter_value RESP_DST_ADDRESS]
    set   data_src_address     [get_parameter_value DATA_SRC_ADDRESS]
    set   ready_latency        [get_parameter_value READY_LATENCY_1]
    set   src_width            [get_parameter_value SRC_WIDTH]
    set   dst_width            [get_parameter_value DST_WIDTH]
    set   context_width        [get_parameter_value CONTEXT_WIDTH]
    set   task_width           [get_parameter_value TASK_WIDTH]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    if { $are_in_par > 0 } {
        set   data_width           [expr $bits_per_symbol * $num_of_colour_planes]
    } else {
        set   data_width           $bits_per_symbol
    }

    # --------------------------------------------------------------------------------------------------
    # -- Dynamic ports                                                                                --
    # --------------------------------------------------------------------------------------------------
    add_av_st_video_input_port av_st_vid_din  $bits_per_symbol  $num_of_colour_planes  $are_in_par  $pixels_in_parallel  main_clock   $ready_latency
    add_av_st_resp_source_port av_st_resp                       1                        $dst_width  $src_width  $task_width $context_width     main_clock  $resp_src_address
    add_av_st_data_source_port av_st_dout     $data_width       $pixels_in_parallel      $dst_width  $src_width  $task_width $context_width  0  main_clock  $data_src_address
}

