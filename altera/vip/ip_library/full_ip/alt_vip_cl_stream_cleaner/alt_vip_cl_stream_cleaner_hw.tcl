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
#-- _hw.tcl compose file for the Stream Cleaner                                                   --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME alt_vip_cl_stream_cleaner
set_module_property DISPLAY_NAME "Avalon-ST Video Stream Cleaner Intel FPGA IP"
set_module_property DESCRIPTION ""

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set_module_property VALIDATION_CALLBACK validation_cb
set_module_property COMPOSITION_CALLBACK composition_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set max_width $vipsuite_max_width
set max_height $vipsuite_max_height

add_bits_per_symbol_parameters
set_parameter_property BITS_PER_SYMBOL HDL_PARAMETER false

add_channels_nb_parameters
set_parameter_property NUMBER_OF_COLOR_PLANES HDL_PARAMETER false
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER false

add_pixels_in_parallel_parameters {1 2 4 8}
set_parameter_property PIXELS_IN_PARALLEL HDL_PARAMETER false

add_max_dim_parameters 32   $max_width   32   $max_height
set_parameter_property MAX_WIDTH  AFFECTS_ELABORATION true
set_parameter_property MAX_WIDTH  HDL_PARAMETER  false
set_parameter_property MAX_HEIGHT AFFECTS_ELABORATION true
set_parameter_property MAX_HEIGHT HDL_PARAMETER  false

add_parameter MIN_WIDTH INTEGER 32
set_parameter_property MIN_WIDTH DISPLAY_NAME "Minimum frame width"
set_parameter_property MIN_WIDTH DESCRIPTION ""
set_parameter_property MIN_WIDTH ALLOWED_RANGES 32:$max_width
set_parameter_property MIN_WIDTH AFFECTS_ELABORATION true
set_parameter_property MIN_WIDTH HDL_PARAMETER false

add_parameter MIN_HEIGHT INTEGER 32
set_parameter_property MIN_HEIGHT DISPLAY_NAME "Minimum frame height"
set_parameter_property MIN_HEIGHT DESCRIPTION ""
set_parameter_property MIN_HEIGHT ALLOWED_RANGES 32:$max_height
set_parameter_property MIN_HEIGHT AFFECTS_ELABORATION true
set_parameter_property MIN_HEIGHT HDL_PARAMETER false

add_parameter TAG_PADDED_FRAMES INTEGER 0
set_parameter_property TAG_PADDED_FRAMES DISPLAY_NAME "Tag cropped/padded frames"
set_parameter_property TAG_PADDED_FRAMES DESCRIPTION ""
set_parameter_property TAG_PADDED_FRAMES ALLOWED_RANGES 0:1
set_parameter_property TAG_PADDED_FRAMES AFFECTS_ELABORATION true
set_parameter_property TAG_PADDED_FRAMES HDL_PARAMETER false
set_parameter_property TAG_PADDED_FRAMES VISIBLE false
set_parameter_property TAG_PADDED_FRAMES DISPLAY_HINT boolean

add_parameter ERROR_DISCARD_COUNT INTEGER 1
set_parameter_property ERROR_DISCARD_COUNT DISPLAY_NAME "Number of frames to discard during/after error"
set_parameter_property ERROR_DISCARD_COUNT DESCRIPTION ""
set_parameter_property ERROR_DISCARD_COUNT ALLOWED_RANGES {1 2 4}
set_parameter_property ERROR_DISCARD_COUNT AFFECTS_ELABORATION true
set_parameter_property ERROR_DISCARD_COUNT HDL_PARAMETER true
set_parameter_property ERROR_DISCARD_COUNT VISIBLE false

add_parameter ENABLE_CONTROL_SLAVE INTEGER 0
set_parameter_property ENABLE_CONTROL_SLAVE DISPLAY_NAME "Enable control slave port"
set_parameter_property ENABLE_CONTROL_SLAVE DESCRIPTION ""
set_parameter_property ENABLE_CONTROL_SLAVE ALLOWED_RANGES 0:1
set_parameter_property ENABLE_CONTROL_SLAVE AFFECTS_ELABORATION true
set_parameter_property ENABLE_CONTROL_SLAVE HDL_PARAMETER false
set_parameter_property ENABLE_CONTROL_SLAVE DISPLAY_HINT boolean

add_parameter EVEN_FRONT_CLIP INTEGER 0
set_parameter_property EVEN_FRONT_CLIP DISPLAY_NAME "Only clip even numbers of pixels from the left side"
set_parameter_property EVEN_FRONT_CLIP DESCRIPTION ""
set_parameter_property EVEN_FRONT_CLIP ALLOWED_RANGES 0:1
set_parameter_property EVEN_FRONT_CLIP AFFECTS_ELABORATION true
set_parameter_property EVEN_FRONT_CLIP HDL_PARAMETER false
set_parameter_property EVEN_FRONT_CLIP DISPLAY_HINT boolean

add_parameter WIDTH_MODULO INTEGER 1
set_parameter_property WIDTH_MODULO DISPLAY_NAME "Width modulo check value"
set_parameter_property WIDTH_MODULO DESCRIPTION ""
set_parameter_property WIDTH_MODULO ALLOWED_RANGES {1 2 4 8 16 32}
set_parameter_property WIDTH_MODULO AFFECTS_ELABORATION true
set_parameter_property WIDTH_MODULO HDL_PARAMETER false

add_parameter REMOVE_4KI INTEGER 0
set_parameter_property REMOVE_4KI DISPLAY_NAME "Remove interlaced fields larger than 1080i"
set_parameter_property REMOVE_4KI DESCRIPTION ""
set_parameter_property REMOVE_4KI ALLOWED_RANGES 0:1
set_parameter_property REMOVE_4KI AFFECTS_ELABORATION true
set_parameter_property REMOVE_4KI HDL_PARAMETER false
set_parameter_property REMOVE_4KI DISPLAY_HINT boolean

add_parameter PIPELINE_READY INTEGER 0
set_parameter_property PIPELINE_READY DISPLAY_NAME "Register Avalon-ST ready signals"
set_parameter_property PIPELINE_READY DESCRIPTION ""
set_parameter_property PIPELINE_READY ALLOWED_RANGES 0:1
set_parameter_property PIPELINE_READY AFFECTS_ELABORATION true
set_parameter_property PIPELINE_READY HDL_PARAMETER false
set_parameter_property PIPELINE_READY DISPLAY_HINT boolean

add_user_packet_support_parameters
set_parameter_property   USER_PACKET_SUPPORT      HDL_PARAMETER             false
set_parameter_property   USER_PACKET_FIFO_DEPTH   HDL_PARAMETER             false
set_parameter_property   USER_PACKET_FIFO_DEPTH   VISIBLE                   false
set_parameter_property   USER_PACKET_SUPPORT      ALLOWED_RANGES {"DISCARD:Discard all user packets received" "PASSTHROUGH:Pass all user packets through to the output"}


proc validation_cb {} {
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set min_width       [get_parameter_value MIN_WIDTH]
    set max_width       [get_parameter_value MAX_WIDTH]
    set min_height      [get_parameter_value MIN_HEIGHT]
    set max_height      [get_parameter_value MAX_HEIGHT]
    set modulo_val      [get_parameter_value WIDTH_MODULO]

    # --------------------------------------------------------------------------------------------------
    # -- Validation                                                                                   --
    # --------------------------------------------------------------------------------------------------
    pip_validation_callback_helper

    if { $max_width < $min_width } {
        send_message Error "The maximum width must be larger than the minimum width"
    }
    if { $max_height < $min_height } {
        send_message Error "The maximum height must be larger than the minimum height"
    }

    if { [expr $min_width % $modulo_val] > 0 } {
        send_message Error "The mimimum width must be an even multiple of the width modulo check value"
    }

    if { [expr $max_width % $modulo_val] > 0 } {
       send_message Error "The maximum width must be an even multiple of the width modulo check value"
    }

    if { [get_parameter_value TAG_PADDED_FRAMES] > 0 } {
      set_parameter_property ERROR_DISCARD_COUNT   VISIBLE  true
    } else {
      set_parameter_property ERROR_DISCARD_COUNT   VISIBLE  false
    }

}

proc composition_cb {} {
    global isVersion acdsVersion vib_vob_removal

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol                [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes         [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set pixels_in_parallel             [get_parameter_value PIXELS_IN_PARALLEL]
    set color_planes_are_in_parallel   [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set min_width                      [get_parameter_value MIN_WIDTH]
    set max_width                      [get_parameter_value MAX_WIDTH]
    set min_height                     [get_parameter_value MIN_HEIGHT]
    set max_height                     [get_parameter_value MAX_HEIGHT]
    set remove_4kI                     [get_parameter_value REMOVE_4KI]
    set pipeline_ready                 [get_parameter_value PIPELINE_READY]
    set width_modulo                   [get_parameter_value WIDTH_MODULO]
    set even_front_clip                [get_parameter_value EVEN_FRONT_CLIP]
    set enable_control_slave           [get_parameter_value ENABLE_CONTROL_SLAVE]
    set user_packet_support            [get_parameter_value USER_PACKET_SUPPORT]
    set tag_broken_frames              [get_parameter_value TAG_PADDED_FRAMES]


    # --------------------------------------------------------------------------------------------------
    # -- Clock/reset bridges                                                                          --
    # --------------------------------------------------------------------------------------------------
    add_instance   av_st_clk_bridge     altera_clock_bridge              $acdsVersion
    add_instance   av_st_reset_bridge   altera_reset_bridge              $acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- sub-components                                                                              --
    # --------------------------------------------------------------------------------------------------
    add_instance   cleaner_core         alt_vip_stream_cleaner_alg_core  $isVersion
    add_instance   scheduler            alt_vip_stream_cleaner_scheduler $isVersion
    add_instance   video_in_cmd         alt_vip_video_input_bridge_cmd   $isVersion

    if {$vib_vob_removal == 0} {
       add_instance   video_in_resp        alt_vip_video_input_bridge_resp     $isVersion

       # Video input bridge parameterization
       set_instance_parameter_value   video_in_resp      PIXELS_IN_PARALLEL            $pixels_in_parallel
       set_instance_parameter_value   video_in_resp      BITS_PER_SYMBOL               $bits_per_symbol
       set_instance_parameter_value   video_in_resp      NUMBER_OF_COLOR_PLANES        $number_of_color_planes
       set_instance_parameter_value   video_in_resp      COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
       set_instance_parameter_value   video_in_resp      DEFAULT_LINE_LENGTH           $max_width
       set_instance_parameter_value   video_in_resp      VIB_MODE                      FULL
       set_instance_parameter_value   video_in_resp      ENABLE_RESOLUTION_CHECK       0
       set_instance_parameter_value   video_in_resp      VIDEO_PROTOCOL_NO             1
       set_instance_parameter_value   video_in_resp      READY_LATENCY_1               1
       set_instance_parameter_value   video_in_resp      PIPELINE_READY                $pipeline_ready
       set_instance_parameter_value   video_in_resp      MULTI_CONTEXT_SUPPORT         0
       set_instance_parameter_value   video_in_resp      SRC_WIDTH                     8
       set_instance_parameter_value   video_in_resp      DST_WIDTH                     8
       set_instance_parameter_value   video_in_resp      CONTEXT_WIDTH                 8
       set_instance_parameter_value   video_in_resp      TASK_WIDTH                    8
       set_instance_parameter_value   video_in_resp      RESP_SRC_ADDRESS              0
       set_instance_parameter_value   video_in_resp      RESP_DST_ADDRESS              0
       set_instance_parameter_value   video_in_resp      DATA_SRC_ADDRESS              0

       set  include_vob               1
    } else {
       set  include_vob               $tag_broken_frames
    }

    if {$include_vob > 0} {
       add_instance   video_out            alt_vip_video_output_bridge         $isVersion

       # Video output bridge parameterization
       set_instance_parameter_value   video_out        BITS_PER_SYMBOL               $bits_per_symbol
       set_instance_parameter_value   video_out        PIXELS_IN_PARALLEL            $pixels_in_parallel
       set_instance_parameter_value   video_out        NUMBER_OF_COLOR_PLANES        $number_of_color_planes
       set_instance_parameter_value   video_out        COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
       set_instance_parameter_value   video_out        READY_LATENCY_1               1
       set_instance_parameter_value   video_out        SOP_PRE_ALIGNED               0
       set_instance_parameter_value   video_out        NO_CONCATENATION              0
       set_instance_parameter_value   video_out        MULTI_CONTEXT_SUPPORT         0
       set_instance_parameter_value   video_out        VIDEO_PROTOCOL_NO             1
       set_instance_parameter_value   video_out        SRC_WIDTH                     8
       set_instance_parameter_value   video_out        DST_WIDTH                     8
       set_instance_parameter_value   video_out        CONTEXT_WIDTH                 8
       set_instance_parameter_value   video_out        TASK_WIDTH                    8
       set_instance_parameter_value   video_out        PIPELINE_READY                $pipeline_ready
       set_instance_parameter_value   video_out        TYPE_11_SUPPORT               [get_parameter_value TAG_PADDED_FRAMES]
    }

    # VIB cmd parameterization
    set_instance_parameter_value    video_in_cmd   BITS_PER_SYMBOL               $bits_per_symbol
    set_instance_parameter_value    video_in_cmd   NUMBER_OF_COLOR_PLANES        $number_of_color_planes
    set_instance_parameter_value    video_in_cmd   COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
    set_instance_parameter_value    video_in_cmd   PIXELS_IN_PARALLEL            $pixels_in_parallel
    set_instance_parameter_value    video_in_cmd   PIPELINE_READY                $pipeline_ready
    set_instance_parameter_value    video_in_cmd   SRC_WIDTH                     8
    set_instance_parameter_value    video_in_cmd   DST_WIDTH                     8
    set_instance_parameter_value    video_in_cmd   CONTEXT_WIDTH                 8
    set_instance_parameter_value    video_in_cmd   TASK_WIDTH                    8
    set_instance_parameter_value    video_in_cmd   DATA_SRC_ADDRESS              0

    # Algorithmic core parameterization
    set_instance_parameter_value   cleaner_core     BITS_PER_SYMBOL               $bits_per_symbol
    set_instance_parameter_value   cleaner_core     NUMBER_OF_COLOR_PLANES        $number_of_color_planes
    set_instance_parameter_value   cleaner_core     COLOR_PLANES_ARE_IN_PARALLEL  $color_planes_are_in_parallel
    set_instance_parameter_value   cleaner_core     PIXELS_IN_PARALLEL            $pixels_in_parallel
    set_instance_parameter_value   cleaner_core     MAX_LINE_LENGTH               $max_width
    set_instance_parameter_value   cleaner_core     PIPELINE_READY                $pipeline_ready
    set_instance_parameter_value   cleaner_core     SRC_WIDTH                     8
    set_instance_parameter_value   cleaner_core     DST_WIDTH                     8
    set_instance_parameter_value   cleaner_core     CONTEXT_WIDTH                 8
    set_instance_parameter_value   cleaner_core     TASK_WIDTH                    8
    set_instance_parameter_value   cleaner_core     DATA_SRC_ADDRESS              0

    # Scheduler parameterization
    set_instance_parameter_value   scheduler        TAG_PADDED_FRAMES             [get_parameter_value TAG_PADDED_FRAMES]
    set_instance_parameter_value   scheduler        ERROR_DISCARD_COUNT           [get_parameter_value ERROR_DISCARD_COUNT]
    set_instance_parameter_value   scheduler        ENABLE_CONTROL_SLAVE          $enable_control_slave
    set_instance_parameter_value   scheduler        EVEN_FRONT_CLIP               $even_front_clip
    set_instance_parameter_value   scheduler        WIDTH_MODULO                  $width_modulo
    set_instance_parameter_value   scheduler        MAX_WIDTH                     $max_width
    set_instance_parameter_value   scheduler        MIN_WIDTH                     $min_width
    set_instance_parameter_value   scheduler        MAX_HEIGHT                    $max_height
    set_instance_parameter_value   scheduler        MIN_HEIGHT                    $min_height
    set_instance_parameter_value   scheduler        PIPELINE_READY                $pipeline_ready
    set_instance_parameter_value   scheduler        REMOVE_4KI                    $remove_4kI
    set_instance_parameter_value   scheduler        USER_PACKET_SUPPORT           $user_packet_support
    set_instance_parameter_value   scheduler        SRC_WIDTH                     8
    set_instance_parameter_value   scheduler        DST_WIDTH                     8
    set_instance_parameter_value   scheduler        CONTEXT_WIDTH                 8
    set_instance_parameter_value   scheduler        TASK_WIDTH                    8

    # --------------------------------------------------------------------------------------------------
    # -- Top-level interfaces                                                                         --
    # --------------------------------------------------------------------------------------------------
    # Top level interfaces :
    add_interface          main_clock   clock         end
    add_interface          main_reset   reset         end
    set_interface_property main_clock   export_of     av_st_clk_bridge.in_clk
    set_interface_property main_reset   export_of     av_st_reset_bridge.in_reset
    set_interface_property main_clock   PORT_NAME_MAP {main_clock in_clk}
    set_interface_property main_reset   PORT_NAME_MAP {main_reset in_reset}

    if {$vib_vob_removal == 0} {
       add_interface           din         avalon_streaming  sink
       set_interface_property  din         export_of         video_in_resp.av_st_vid_din
    } else {
       add_interface           din_data    avalon_streaming  sink
       add_interface           din_aux     avalon_streaming  sink
    }

    if {$include_vob > 0} {
       add_interface           dout        avalon_streaming  source
       set_interface_property  dout        export_of         video_out.av_st_vid_dout
    } else {
       add_interface           dout_data   avalon_streaming  source
       add_interface           dout_aux    avalon_streaming  source
    }


    if { $enable_control_slave } {
        add_interface            control    avalon      slave
        set_interface_property   control    export_of   scheduler.av_mm_control
    }

    # --------------------------------------------------------------------------------------------------
    # -- Connection of sub-components                                                                 --
    # --------------------------------------------------------------------------------------------------
    # Av-ST clock/reset connections
    add_connection   av_st_clk_bridge.out_clk       av_st_reset_bridge.clk
    if {$vib_vob_removal == 0} {
        add_connection   av_st_clk_bridge.out_clk   video_in_resp.main_clock
    }
    if {$include_vob > 0} {
        add_connection   av_st_clk_bridge.out_clk   video_out.main_clock
    }
    add_connection   av_st_clk_bridge.out_clk       video_in_cmd.main_clock
    add_connection   av_st_clk_bridge.out_clk       cleaner_core.main_clock
    add_connection   av_st_clk_bridge.out_clk       scheduler.main_clock
    if {$vib_vob_removal == 0} {
      add_connection   av_st_reset_bridge.out_reset   video_in_resp.main_reset
    }
    if {$include_vob > 0} {
      add_connection   av_st_reset_bridge.out_reset   video_out.main_reset
    }
    add_connection   av_st_reset_bridge.out_reset   video_in_cmd.main_reset
    add_connection   av_st_reset_bridge.out_reset   cleaner_core.main_reset
    add_connection   av_st_reset_bridge.out_reset   scheduler.main_reset

    # Scheduler connections
    add_connection   scheduler.av_st_vib_cmd        video_in_cmd.av_st_cmd
    add_connection   scheduler.av_st_ac_cmd         cleaner_core.av_st_cmd
    if {$vib_vob_removal == 0} {
      add_connection   video_in_resp.av_st_resp       scheduler.av_st_vib_resp
    }
    if {$include_vob > 0} {
      add_connection   scheduler.av_st_vob_cmd        video_out.av_st_cmd
    } else {
      set_interface_property   din_aux    export_of   scheduler.av_st_vib_resp
      set_interface_property   dout_aux   export_of   scheduler.av_st_vob_cmd
    }

    # Data path connections
    if {$vib_vob_removal == 0} {
       add_connection   video_in_resp.av_st_dout       video_in_cmd.av_st_din
    } else {
       set_interface_property   din_data   export_of   video_in_cmd.av_st_din
    }
    if {$include_vob > 0} {
       add_connection   cleaner_core.av_st_dout        video_out.av_st_din
    } else {
       set_interface_property   dout_data  export_of   cleaner_core.av_st_dout
    }
    add_connection   video_in_cmd.av_st_dout        cleaner_core.av_st_din
}
