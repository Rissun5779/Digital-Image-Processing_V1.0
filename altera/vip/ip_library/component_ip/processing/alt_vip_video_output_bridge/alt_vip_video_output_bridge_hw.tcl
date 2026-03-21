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


source   ../../../common_tcl/alt_vip_helper_common.tcl
source   ../../../common_tcl/alt_vip_files_common.tcl
source   ../../../common_tcl/alt_vip_parameters_common.tcl
source   ../../../common_tcl/alt_vip_interfaces_common.tcl

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information for the Video output bridge component                                    --
# -- This block transmits video data received in the Avalon-ST message Video format               --
# -- in response to commands.                                                                     --
# --------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component properties
set_module_property  NAME           alt_vip_video_output_bridge
set_module_property  DISPLAY_NAME   "Video Output Bridge"
set_module_property  DESCRIPTION    "The Video Output Bridge generates an Avalon-ST Video stream"
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
set_module_property  VALIDATION_CALLBACK  validation_cb

# Elaboration callback to set up the dynamic ports
set_module_property  ELABORATION_CALLBACK elaboration_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files                    ../../..
add_alt_vip_common_video_packet_encode          ../../..
add_alt_vip_common_event_packet_decode_files    ../../..
add_alt_vip_common_event_packet_encode_files    ../../..
add_alt_vip_common_message_pipeline_stage_files ../../..
add_alt_vip_common_sop_align_files              ../../..
add_static_sv_file                              src_hdl/alt_vip_video_output_bridge.sv

add_static_misc_file                            src_hdl/alt_vip_video_output_bridge.ocp

setup_filesets                                  alt_vip_video_output_bridge


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_bits_per_symbol_parameters

#adds NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL         ALLOWED_RANGES       {1 2 4 8}

add_parameter           VIDEO_PROTOCOL_NO          INTEGER              1
set_parameter_property  VIDEO_PROTOCOL_NO          ALLOWED_RANGES       {1}
set_parameter_property  VIDEO_PROTOCOL_NO          DISPLAY_HINT         ""
set_parameter_property  VIDEO_PROTOCOL_NO          AFFECTS_ELABORATION  false
set_parameter_property  VIDEO_PROTOCOL_NO          HDL_PARAMETER        true
set_parameter_property  VIDEO_PROTOCOL_NO          DISPLAY_NAME         "Video protocol version"

add_parameter           READY_LATENCY_1            INTEGER              1
set_parameter_property  READY_LATENCY_1            ALLOWED_RANGES       {0 1}
set_parameter_property  READY_LATENCY_1            DISPLAY_HINT         ""
set_parameter_property  READY_LATENCY_1            AFFECTS_ELABORATION  true
set_parameter_property  READY_LATENCY_1            HDL_PARAMETER        true
set_parameter_property  READY_LATENCY_1            DISPLAY_NAME         "Output ready latency"

add_parameter           SOP_PRE_ALIGNED            INTEGER              0
set_parameter_property  SOP_PRE_ALIGNED            DISPLAY_NAME         "Input SOP empty is always 0"
set_parameter_property  SOP_PRE_ALIGNED            ALLOWED_RANGES       0:1
set_parameter_property  SOP_PRE_ALIGNED            DISPLAY_HINT         boolean
set_parameter_property  SOP_PRE_ALIGNED            HDL_PARAMETER        true
set_parameter_property  SOP_PRE_ALIGNED            VISIBLE              true
set_parameter_property  SOP_PRE_ALIGNED            AFFECTS_ELABORATION  false

add_parameter           MULTI_CONTEXT_SUPPORT      INTEGER              0
set_parameter_property  MULTI_CONTEXT_SUPPORT      ALLOWED_RANGES       0:1
set_parameter_property  MULTI_CONTEXT_SUPPORT      DISPLAY_HINT         boolean
set_parameter_property  MULTI_CONTEXT_SUPPORT      AFFECTS_ELABORATION  false
set_parameter_property  MULTI_CONTEXT_SUPPORT      HDL_PARAMETER        true
set_parameter_property  MULTI_CONTEXT_SUPPORT      DISPLAY_NAME         "Enable support for context packets"

add_parameter           TYPE_11_SUPPORT            INTEGER              0
set_parameter_property  TYPE_11_SUPPORT            ALLOWED_RANGES       0:1
set_parameter_property  TYPE_11_SUPPORT            DISPLAY_HINT         boolean
set_parameter_property  TYPE_11_SUPPORT            AFFECTS_ELABORATION  false
set_parameter_property  TYPE_11_SUPPORT            HDL_PARAMETER        true
set_parameter_property  TYPE_11_SUPPORT            DISPLAY_NAME         "Enable support for type 11 packets"

add_parameter           NO_CONCATENATION           INTEGER              0
set_parameter_property  NO_CONCATENATION           ALLOWED_RANGES       0:1
set_parameter_property  NO_CONCATENATION           DISPLAY_HINT         boolean
set_parameter_property  NO_CONCATENATION           AFFECTS_ELABORATION  false
set_parameter_property  NO_CONCATENATION           HDL_PARAMETER        true
set_parameter_property  NO_CONCATENATION           DISPLAY_NAME         "Disable packet concatenation"

add_parameter           PIPELINE_READY             INTEGER              0
set_parameter_property  PIPELINE_READY             ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY             DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY             AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY             HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY             DISPLAY_NAME         "Pipeline Av-ST ready signals"

add_av_st_event_parameters

add_parameter           LOW_LATENCY_COMMAND_MODE   INTEGER              0
set_parameter_property  LOW_LATENCY_COMMAND_MODE   DISPLAY_NAME         "Low latency command mode (for CVI)"
set_parameter_property  LOW_LATENCY_COMMAND_MODE   ALLOWED_RANGES       0:1
set_parameter_property  LOW_LATENCY_COMMAND_MODE   DISPLAY_HINT         boolean
set_parameter_property  LOW_LATENCY_COMMAND_MODE   HDL_PARAMETER        true
set_parameter_property  LOW_LATENCY_COMMAND_MODE   VISIBLE              false


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

proc validation_cb {} {

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set color_planes_are_in_parallel          [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel                    [get_parameter_value PIXELS_IN_PARALLEL]

    # --------------------------------------------------------------------------------------------------
    # -- Validation                                                                                   --
    # --------------------------------------------------------------------------------------------------
    if { $pixels_in_parallel > 1 } {
        if { $color_planes_are_in_parallel == 0 } {
            send_message Error "All colour planes must be in parallel to enable more than 1 pixel in parallel"
        }
    }
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc elaboration_cb {} {

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol         [get_parameter_value BITS_PER_SYMBOL]
    set num_of_colour_planes    [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set are_in_par              [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel      [get_parameter_value PIXELS_IN_PARALLEL]
    set ready_latency           [get_parameter_value READY_LATENCY_1]
    set src_width               [get_parameter_value SRC_WIDTH]
    set dst_width               [get_parameter_value DST_WIDTH]
    set context_width           [get_parameter_value CONTEXT_WIDTH]
    set task_width              [get_parameter_value TASK_WIDTH]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    if { $are_in_par > 0 } {
      set symbols_per_pixel $num_of_colour_planes
    } else {
      set symbols_per_pixel 1
    }

    set data_width              [expr $bits_per_symbol * $symbols_per_pixel]

     # Add the empty signal to the interface ?
    if {$pixels_in_parallel > 1} {
        set use_empty 2
    } else {
        set use_empty 1
    }

    # --------------------------------------------------------------------------------------------------
    # -- Dynamic ports                                                                                --
    # --------------------------------------------------------------------------------------------------
    # Source ID here is zero as the VOB has no Avalon-ST Video sources :
    add_av_st_cmd_sink_port     av_st_cmd       1                 $dst_width           $src_width           $task_width  $context_width  main_clock      0
    add_av_st_data_sink_port    av_st_din       $data_width       $pixels_in_parallel  $dst_width           $src_width   $task_width     $context_width  0  main_clock  0

    add_av_st_video_output_port av_st_vid_dout  $bits_per_symbol  $num_of_colour_planes  $are_in_par  $pixels_in_parallel  main_clock   $ready_latency
}


