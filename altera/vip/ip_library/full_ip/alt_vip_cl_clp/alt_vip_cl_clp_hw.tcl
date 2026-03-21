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
#-- _hw.tcl compose file for Component Library Clipper (Clipper 2)                                  --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME alt_vip_cl_clp
set_module_property DISPLAY_NAME "Clipper II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION "The Clipper II clips a specified portion from an input video field."

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
set_module_property VALIDATION_CALLBACK clp_validation_callback

# Callback for the composition of this component
set_module_property COMPOSITION_CALLBACK clp_composition_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set x_max     $vipsuite_max_width
set y_max     $vipsuite_max_height

add_bits_per_symbol_parameters

add_channels_nb_parameters

add_pixels_in_parallel_parameters

add_max_in_dim_parameters 32 $x_max 32 $y_max
set_parameter_property MAX_IN_WIDTH   ENABLED             true
set_parameter_property MAX_IN_WIDTH   AFFECTS_ELABORATION true
set_parameter_property MAX_IN_HEIGHT  ENABLED             true
set_parameter_property MAX_IN_HEIGHT  AFFECTS_ELABORATION true

add_parameter           CLIPPING_METHOD      STRING               OFFSETS
set_parameter_property  CLIPPING_METHOD      DISPLAY_NAME         "Clipping method"
set_parameter_property  CLIPPING_METHOD      ALLOWED_RANGES       {OFFSETS RECTANGLE}
set_parameter_property  CLIPPING_METHOD      DISPLAY_HINT         ""
set_parameter_property  CLIPPING_METHOD      DESCRIPTION          "Offsets mode will clip a portion of the image based on how large each offset is from the edge of the input image. Rectangle mode will clip an image of width * height dimensions from the starting left and right offset."
set_parameter_property  CLIPPING_METHOD      HDL_PARAMETER        true
set_parameter_property  CLIPPING_METHOD      AFFECTS_ELABORATION  true

add_parameter           LEFT_OFFSET          INTEGER              0
set_parameter_property  LEFT_OFFSET          DISPLAY_NAME         "Left Offset"
set_parameter_property  LEFT_OFFSET          ALLOWED_RANGES       0:$x_max
set_parameter_property  LEFT_OFFSET          DESCRIPTION          "The number of pixels to the left edge of the clipping surface"
set_parameter_property  LEFT_OFFSET          HDL_PARAMETER        true
set_parameter_property  LEFT_OFFSET          AFFECTS_ELABORATION  true

add_parameter           RIGHT_OFFSET         INTEGER              0
set_parameter_property  RIGHT_OFFSET         DISPLAY_NAME         "Right Offset"
set_parameter_property  RIGHT_OFFSET         ALLOWED_RANGES       0:$x_max
set_parameter_property  RIGHT_OFFSET         DESCRIPTION          "The number of pixels from the right edge of the image to the right edge of the clipping surface"
set_parameter_property  RIGHT_OFFSET         HDL_PARAMETER        true
set_parameter_property  RIGHT_OFFSET         AFFECTS_ELABORATION  true
set_parameter_property  RIGHT_OFFSET         ENABLED              true

add_parameter           TOP_OFFSET           INTEGER              0
set_parameter_property  TOP_OFFSET           DISPLAY_NAME         "Top Offset"
set_parameter_property  TOP_OFFSET           ALLOWED_RANGES       0:$y_max
set_parameter_property  TOP_OFFSET           DESCRIPTION          "The number of pixels to the top edge of the clipping surface"
set_parameter_property  TOP_OFFSET           HDL_PARAMETER        true
set_parameter_property  TOP_OFFSET           AFFECTS_ELABORATION  true

add_parameter           BOTTOM_OFFSET        INTEGER              0
set_parameter_property  BOTTOM_OFFSET        DISPLAY_NAME         "Bottom Offset"
set_parameter_property  BOTTOM_OFFSET        ALLOWED_RANGES       0:$y_max
set_parameter_property  BOTTOM_OFFSET        DESCRIPTION          "The number of pixels from the bottom edge of the image to the bottom edge of the clipping surface"
set_parameter_property  BOTTOM_OFFSET        HDL_PARAMETER        true
set_parameter_property  BOTTOM_OFFSET        AFFECTS_ELABORATION  true
set_parameter_property  BOTTOM_OFFSET        ENABLED              true

add_parameter           RECTANGLE_WIDTH      INTEGER              32
set_parameter_property  RECTANGLE_WIDTH      DISPLAY_NAME         "Width"
set_parameter_property  RECTANGLE_WIDTH      ALLOWED_RANGES       32:$x_max
set_parameter_property  RECTANGLE_WIDTH      DESCRIPTION          "The width of the output image."
set_parameter_property  RECTANGLE_WIDTH      HDL_PARAMETER        true
set_parameter_property  RECTANGLE_WIDTH      AFFECTS_ELABORATION  true
set_parameter_property  RECTANGLE_WIDTH      ENABLED              false

add_parameter           RECTANGLE_HEIGHT     INTEGER              32
set_parameter_property  RECTANGLE_HEIGHT     DISPLAY_NAME         "Height"
set_parameter_property  RECTANGLE_HEIGHT     ALLOWED_RANGES       32:$y_max
set_parameter_property  RECTANGLE_HEIGHT     DESCRIPTION          "The height of the output image."
set_parameter_property  RECTANGLE_HEIGHT     HDL_PARAMETER        true
set_parameter_property  RECTANGLE_HEIGHT     AFFECTS_ELABORATION  true
set_parameter_property  RECTANGLE_HEIGHT     ENABLED              false

add_parameter           EXTRA_PIPELINING     INTEGER              0
set_parameter_property  EXTRA_PIPELINING     DISPLAY_NAME         "Add extra pipelining registers"
set_parameter_property  EXTRA_PIPELINING     ALLOWED_RANGES       0:1
set_parameter_property  EXTRA_PIPELINING     DESCRIPTION          "Selecting this option adds extra pipeline stage registers to the data path"
set_parameter_property  EXTRA_PIPELINING     HDL_PARAMETER        false
set_parameter_property  EXTRA_PIPELINING     AFFECTS_ELABORATION  true
set_parameter_property  EXTRA_PIPELINING     DISPLAY_HINT         boolean

add_user_packet_support_parameters
set_parameter_property  USER_PACKET_FIFO_DEPTH  VISIBLE           false
set_parameter_property  USER_PACKET_FIFO_DEPTH  ENABLED           false
set_parameter_property  USER_PACKET_FIFO_DEPTH  HDL_PARAMETER     false

add_runtime_control_parameters 1

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Derived parameters                                                                           --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_device_family_parameters


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_display_item  "Video Data Format"   MAX_IN_WIDTH                   parameter
add_display_item  "Video Data Format"   MAX_IN_HEIGHT                  parameter
add_display_item  "Video Data Format"   BITS_PER_SYMBOL                parameter
add_display_item  "Video Data Format"   NUMBER_OF_COLOR_PLANES         parameter
add_display_item  "Video Data Format"   PIXELS_IN_PARALLEL             parameter
add_display_item  "Video Data Format"   COLOR_PLANES_ARE_IN_PARALLEL   parameter

add_display_item  "Clipping Options"    RUNTIME_CONTROL                parameter
add_display_item  "Clipping Options"    CLIPPING_METHOD                parameter
add_display_item  "Clipping Options"    LEFT_OFFSET                    parameter
add_display_item  "Clipping Options"    TOP_OFFSET                     parameter
add_display_item  "Clipping Options"    RIGHT_OFFSET                   parameter
add_display_item  "Clipping Options"    BOTTOM_OFFSET                  parameter
add_display_item  "Clipping Options"    RECTANGLE_WIDTH                parameter
add_display_item  "Clipping Options"    RECTANGLE_HEIGHT               parameter

add_display_item  "Optimisation"        EXTRA_PIPELINING               parameter
add_display_item  "Optimisation"        LIMITED_READBACK               parameter
add_display_item  "Optimisation"        USER_PACKET_SUPPORT            parameter


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc clp_validation_callback {} {

    set max_in_width          [get_parameter_value MAX_IN_WIDTH]
    set max_in_height         [get_parameter_value MAX_IN_HEIGHT]
    set left_offset           [get_parameter_value LEFT_OFFSET]
    set top_offset            [get_parameter_value TOP_OFFSET]

    # Must use cp in parallel with pip>1
    pip_validation_callback_helper

    # Enable/disable the limited readback parameter
    runtime_control_validation_callback_helper

    if {$max_in_width < $left_offset} {
        send_message error "left offset ($left_offset) should not be larger than the maximum input width ($max_in_width)"
    }
    if {$max_in_height < $top_offset} {
        send_message error "top offset ($top_offset) should not be larger than the maximum input height ($max_in_height)"
    }

    # Swap between RECTANGLE_WIDTH/RECTANGLE_HEIGHT and RIGHT_OFFSET/BOTTOM_OFFSET
    # Validate values against max_width/max_height
    set cmp [string compare [get_parameter_value CLIPPING_METHOD] "RECTANGLE"]
    if { $cmp == 0 } {
        # Rectangle mode
        set_parameter_property RECTANGLE_WIDTH   ENABLED  true
        set_parameter_property RECTANGLE_HEIGHT  ENABLED  true
        set_parameter_property RIGHT_OFFSET      ENABLED  false
        set_parameter_property BOTTOM_OFFSET     ENABLED  false

        set rectangle_width       [get_parameter_value RECTANGLE_WIDTH]
        set rectangle_height      [get_parameter_value RECTANGLE_HEIGHT]

        set offset_sum_width      [expr {$left_offset + $rectangle_width}]
        set offset_sum_height     [expr {$top_offset + $rectangle_height}]

        if {$max_in_width < $offset_sum_width} {
            send_message error "left_offset($left_offset) + rectangle_width($rectangle_width) should not be larger than the maximum input frame width ($max_in_width)"
        }
        if {$max_in_height < $offset_sum_height} {
            send_message error "top_offset($top_offset) + rectangle_height($rectangle_height) should not be larger than the maximum input frame height ($max_in_height)"
        }
    } else {
        # Offsets mode
        set_parameter_property RECTANGLE_WIDTH   ENABLED  false
        set_parameter_property RECTANGLE_HEIGHT  ENABLED  false
        set_parameter_property RIGHT_OFFSET      ENABLED  true
        set_parameter_property BOTTOM_OFFSET     ENABLED  true

        set right_offset          [get_parameter_value RIGHT_OFFSET]
        set bottom_offset         [get_parameter_value BOTTOM_OFFSET]

        set offset_sum_width      [expr {$left_offset + $right_offset + 32}]
        set offset_sum_height     [expr {$top_offset + $bottom_offset + 32}]

        if {$max_in_width < $offset_sum_width} {
            send_message error "left_offset($left_offset) + right_offset($right_offset) + 32(min picture width) should not be larger than the maximum input frame width ($max_in_width)"
        }
        if {$max_in_height < $offset_sum_height} {
            send_message error "top_offset($top_offset) + bottom_offset($bottom_offset) + 32(min picture width) should not be larger than the maximum input frame height ($max_in_height)"
        }
    }
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                        --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc clp_composition_callback {} {
    global isVersion acdsVersion vib_vob_removal

    # Parameters:
    set bits_per_symbol     [get_parameter_value BITS_PER_SYMBOL]
    set number_of_colors    [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set colors_in_par       [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel  [get_parameter_value PIXELS_IN_PARALLEL]
    set max_in_width        [get_parameter_value MAX_IN_WIDTH]
    set max_in_height       [get_parameter_value MAX_IN_HEIGHT]
    set left_offset         [get_parameter_value LEFT_OFFSET]
    set top_offset          [get_parameter_value TOP_OFFSET]
    set right_offset        [get_parameter_value RIGHT_OFFSET]
    set bottom_offset       [get_parameter_value BOTTOM_OFFSET]
    set rectangle_width     [get_parameter_value RECTANGLE_WIDTH]
    set rectangle_height    [get_parameter_value RECTANGLE_HEIGHT]
    set limited_readback    [get_parameter_value LIMITED_READBACK]
    set pipeline_ready      [get_parameter_value EXTRA_PIPELINING]
    set user_packet_support [get_parameter_value USER_PACKET_SUPPORT]
    set runtime_control     [get_parameter_value RUNTIME_CONTROL]


    # Derived parameters
    set video_data_width [ expr $bits_per_symbol * [ expr $colors_in_par > 0 ? $number_of_colors : 1]]

    # Clipping method selection
    set cmp [string compare [get_parameter_value CLIPPING_METHOD] "RECTANGLE"]
    if { $cmp == 0 } {
        # Rectangle mode
        set width_param   $rectangle_width
        set height_param  $rectangle_height
        set rectangle_mode 1
    } else {
        # Offsets mode
        set width_param   $right_offset
        set height_param  $bottom_offset
        set rectangle_mode 0
    }

    # User packet support
    set cmp_user_support   [string compare $user_packet_support "PASSTHROUGH"]
    if { $cmp_user_support == 0 } {
        set user_packet_passthrough 1
    } else {
        set user_packet_passthrough 0
    }

    # The chain of components to compose :
    add_instance   av_st_clk_bridge     altera_clock_bridge              $acdsVersion
    add_instance   av_st_reset_bridge   altera_reset_bridge              $acdsVersion

    if {$vib_vob_removal == 0} {
       add_instance   video_in_resp        alt_vip_video_input_bridge_resp  $isVersion
       add_instance   video_out            alt_vip_video_output_bridge      $isVersion
    }

    add_instance   video_in_cmd         alt_vip_video_input_bridge_cmd   $isVersion
    add_instance   clipper_core         alt_vip_clipper_alg_core         $isVersion
    add_instance   scheduler            alt_vip_clipper_scheduler        $isVersion

    ## Optional packet bypass path
    if { $user_packet_passthrough } {
        add_instance   user_packet_demux    alt_vip_packet_demux             $isVersion
        add_instance   user_packet_mux      alt_vip_packet_mux               $isVersion
    }

    if {$vib_vob_removal == 0} {
       # VIB resp parameterization
       set_instance_parameter_value  video_in_resp     BITS_PER_SYMBOL               $bits_per_symbol
       set_instance_parameter_value  video_in_resp     NUMBER_OF_COLOR_PLANES        $number_of_colors
       set_instance_parameter_value  video_in_resp     COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
       set_instance_parameter_value  video_in_resp     PIXELS_IN_PARALLEL            $pixels_in_parallel
       set_instance_parameter_value  video_in_resp     MAX_WIDTH                     $max_in_width
       set_instance_parameter_value  video_in_resp     MAX_HEIGHT                    $max_in_height
       set_instance_parameter_value  video_in_resp     DEFAULT_LINE_LENGTH           $max_in_width
       set_instance_parameter_value  video_in_resp     VIB_MODE                      FULL
       set_instance_parameter_value  video_in_resp     READY_LATENCY_1               1
       set_instance_parameter_value  video_in_resp     MULTI_CONTEXT_SUPPORT         0
       set_instance_parameter_value  video_in_resp     VIDEO_PROTOCOL_NO             1
       set_instance_parameter_value  video_in_resp     ENABLE_RESOLUTION_CHECK       1
       set_instance_parameter_value  video_in_resp     PIPELINE_READY                $pipeline_ready
       set_instance_parameter_value  video_in_resp     SRC_WIDTH                     8
       set_instance_parameter_value  video_in_resp     DST_WIDTH                     8
       set_instance_parameter_value  video_in_resp     CONTEXT_WIDTH                 8
       set_instance_parameter_value  video_in_resp     TASK_WIDTH                    8
       set_instance_parameter_value  video_in_resp     RESP_SRC_ADDRESS              0
       set_instance_parameter_value  video_in_resp     RESP_DST_ADDRESS              0
       set_instance_parameter_value  video_in_resp     DATA_SRC_ADDRESS              0

       # Vob parameterization
       set_instance_parameter_value   video_out        BITS_PER_SYMBOL               $bits_per_symbol
       set_instance_parameter_value   video_out        NUMBER_OF_COLOR_PLANES        $number_of_colors
       set_instance_parameter_value   video_out        COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
       set_instance_parameter_value   video_out        PIXELS_IN_PARALLEL            $pixels_in_parallel
       set_instance_parameter_value   video_out        PIPELINE_READY                $pipeline_ready
       set_instance_parameter_value   video_out        SOP_PRE_ALIGNED               0
       set_instance_parameter_value   video_out        MULTI_CONTEXT_SUPPORT         0
       set_instance_parameter_value   video_out        NO_CONCATENATION              0
       set_instance_parameter_value   video_out        LOW_LATENCY_COMMAND_MODE      0
       set_instance_parameter_value   video_out        READY_LATENCY_1               1
       set_instance_parameter_value   video_out        VIDEO_PROTOCOL_NO             1
       set_instance_parameter_value   video_out        SRC_WIDTH                     8
       set_instance_parameter_value   video_out        DST_WIDTH                     8
       set_instance_parameter_value   video_out        CONTEXT_WIDTH                 8
       set_instance_parameter_value   video_out        TASK_WIDTH                    8
    }

    # VIB cmd parameterization
    set_instance_parameter_value  video_in_cmd      BITS_PER_SYMBOL               $bits_per_symbol
    set_instance_parameter_value  video_in_cmd      NUMBER_OF_COLOR_PLANES        $number_of_colors
    set_instance_parameter_value  video_in_cmd      COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
    set_instance_parameter_value  video_in_cmd      PIXELS_IN_PARALLEL            $pixels_in_parallel
    set_instance_parameter_value  video_in_cmd      PIPELINE_READY                $pipeline_ready
    set_instance_parameter_value  video_in_cmd      SRC_WIDTH                     8
    set_instance_parameter_value  video_in_cmd      DST_WIDTH                     8
    set_instance_parameter_value  video_in_cmd      CONTEXT_WIDTH                 8
    set_instance_parameter_value  video_in_cmd      TASK_WIDTH                    8
    set_instance_parameter_value  video_in_cmd      DATA_SRC_ADDRESS              0

    # Clipper algorithmic core parameterization
    set_instance_parameter_value   clipper_core     BITS_PER_SYMBOL               $bits_per_symbol
    set_instance_parameter_value   clipper_core     NUMBER_OF_COLOR_PLANES        $number_of_colors
    set_instance_parameter_value   clipper_core     COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
    set_instance_parameter_value   clipper_core     PIXELS_IN_PARALLEL            $pixels_in_parallel
    set_instance_parameter_value   clipper_core     PIPELINE_DATA_OUTPUT          $pipeline_ready
    set_instance_parameter_value   clipper_core     MAX_IN_WIDTH                  $max_in_width
    set_instance_parameter_value   clipper_core     MAX_IN_HEIGHT                 $max_in_height
    set_instance_parameter_value   clipper_core     LEFT_OFFSET                   $width_param
    set_instance_parameter_value   clipper_core     RIGHT_OFFSET                  $height_param
    set_instance_parameter_value   clipper_core     SRC_WIDTH                     8
    set_instance_parameter_value   clipper_core     DST_WIDTH                     8
    set_instance_parameter_value   clipper_core     CONTEXT_WIDTH                 8
    set_instance_parameter_value   clipper_core     TASK_WIDTH                    8

    # Scheduler parameterization
    set_instance_parameter_value   scheduler        MAX_IN_WIDTH                  $max_in_width
    set_instance_parameter_value   scheduler        MAX_IN_HEIGHT                 $max_in_height
    set_instance_parameter_value   scheduler        RUNTIME_CONTROL               $runtime_control
    set_instance_parameter_value   scheduler        RECTANGLE_MODE                $rectangle_mode
    set_instance_parameter_value   scheduler        LEFT_OFFSET                   $left_offset
    set_instance_parameter_value   scheduler        TOP_OFFSET                    $top_offset
    set_instance_parameter_value   scheduler        RIGHT_OFFSET                  $right_offset
    set_instance_parameter_value   scheduler        BOTTOM_OFFSET                 $bottom_offset
    set_instance_parameter_value   scheduler        OUT_WIDTH                     $rectangle_width
    set_instance_parameter_value   scheduler        OUT_HEIGHT                    $rectangle_height
    set_instance_parameter_value   scheduler        PIPELINE_READY                1
    set_instance_parameter_value   scheduler        LIMITED_READBACK              $limited_readback
    set_instance_parameter_value   scheduler        USER_PACKET_SUPPORT           $user_packet_support


    # Mux/demux parameterization
    if { $user_packet_passthrough } {
        # Packet demux parameterization
        set_instance_parameter_value   user_packet_demux   DATA_WIDTH                    $video_data_width
        set_instance_parameter_value   user_packet_demux   PIXELS_IN_PARALLEL            $pixels_in_parallel
        set_instance_parameter_value   user_packet_demux   NUM_OUTPUTS                   2
        set_instance_parameter_value   user_packet_demux   CLIP_ADDRESS_BITS             0
        set_instance_parameter_value   user_packet_demux   REGISTER_OUTPUT               1
        set_instance_parameter_value   user_packet_demux   PIPELINE_READY                $pipeline_ready
        set_instance_parameter_value   user_packet_demux   SRC_WIDTH                     8
        set_instance_parameter_value   user_packet_demux   DST_WIDTH                     8
        set_instance_parameter_value   user_packet_demux   CONTEXT_WIDTH                 8
        set_instance_parameter_value   user_packet_demux   TASK_WIDTH                    8
        set_instance_parameter_value   user_packet_demux   USER_WIDTH                    0

        # Packet mux parameterization
        set_instance_parameter_value   user_packet_mux     DATA_WIDTH                    $video_data_width
        set_instance_parameter_value   user_packet_mux     PIXELS_IN_PARALLEL            $pixels_in_parallel
        set_instance_parameter_value   user_packet_mux     REGISTER_OUTPUT               1
        set_instance_parameter_value   user_packet_mux     PIPELINE_READY                $pipeline_ready
        set_instance_parameter_value   user_packet_mux     NUM_INPUTS                    2
        set_instance_parameter_value   user_packet_mux     SRC_WIDTH                     8
        set_instance_parameter_value   user_packet_mux     DST_WIDTH                     8
        set_instance_parameter_value   user_packet_mux     CONTEXT_WIDTH                 8
        set_instance_parameter_value   user_packet_mux     TASK_WIDTH                    8
        set_instance_parameter_value   user_packet_mux     USER_WIDTH                    0
    }


    # Top level interfaces :
    add_interface            main_clock   clock         end
    add_interface            main_reset   reset         end
    set_interface_property   main_clock   export_of     av_st_clk_bridge.in_clk
    set_interface_property   main_reset   export_of     av_st_reset_bridge.in_reset
    set_interface_property   main_clock   PORT_NAME_MAP {main_clock in_clk}
    set_interface_property   main_reset   PORT_NAME_MAP {main_reset in_reset}

    if {$vib_vob_removal == 0} {
       add_interface           din         avalon_streaming  sink
       add_interface           dout        avalon_streaming  source
       set_interface_property  din         export_of         video_in_resp.av_st_vid_din
       set_interface_property  dout        export_of         video_out.av_st_vid_dout
    } else {
       add_interface           din_data    avalon_streaming  sink
       add_interface           din_aux     avalon_streaming  sink
       add_interface           dout_data   avalon_streaming  source
       add_interface           dout_aux    avalon_streaming  source
       set_interface_property  din_aux     export_of         scheduler.av_st_resp_vib
       set_interface_property  dout_aux    export_of         scheduler.av_st_cmd_vob
    }

    # Av-ST Clock connections :
    add_connection   av_st_clk_bridge.out_clk   av_st_reset_bridge.clk
    add_connection   av_st_clk_bridge.out_clk   video_in_cmd.main_clock
    add_connection   av_st_clk_bridge.out_clk   clipper_core.main_clock
    add_connection   av_st_clk_bridge.out_clk   scheduler.main_clock

    # Av-ST Reset connections :
    add_connection   av_st_reset_bridge.out_reset   video_in_cmd.main_reset
    add_connection   av_st_reset_bridge.out_reset   clipper_core.main_reset
    add_connection   av_st_reset_bridge.out_reset   scheduler.main_reset

    # Scheduler/command connections
    add_connection   scheduler.av_st_cmd_vib        video_in_cmd.av_st_cmd
    add_connection   scheduler.av_st_cmd_alg_core   clipper_core.av_st_cmd

    if {$vib_vob_removal == 0} {
       add_connection    av_st_clk_bridge.out_clk      video_in_resp.main_clock
       add_connection    av_st_reset_bridge.out_reset  video_in_resp.main_reset
       add_connection    av_st_clk_bridge.out_clk      video_out.main_clock
       add_connection    av_st_reset_bridge.out_reset  video_out.main_reset

       add_connection    scheduler.av_st_cmd_vob       video_out.av_st_cmd
       add_connection    video_in_resp.av_st_resp      scheduler.av_st_resp_vib
       add_connection    video_in_resp.av_st_dout      video_in_cmd.av_st_din
    } else {
       set_interface_property  din_data    export_of   video_in_cmd.av_st_din
    }

    # Multiplexer & de-multiplexer connections if we need to bypass user packets, otherwise tie the alg_core directly to VIB and VOB
    if { $user_packet_passthrough } {
        # Clock and reset connections
        add_connection   av_st_clk_bridge.out_clk   user_packet_demux.main_clock
        add_connection   av_st_clk_bridge.out_clk   user_packet_mux.main_clock
        add_connection   av_st_reset_bridge.out_reset   user_packet_demux.main_reset
        add_connection   av_st_reset_bridge.out_reset   user_packet_mux.main_reset

        # VIB -> demux -> alg_core
        add_connection   video_in_cmd.av_st_dout          user_packet_demux.av_st_din
        add_connection   user_packet_demux.av_st_dout_0   clipper_core.av_st_din

        # Mux command
        add_connection   scheduler.av_st_cmd_mux          user_packet_mux.av_st_cmd

        # alg_core -> mux -> VOB
        add_connection   clipper_core.av_st_dout          user_packet_mux.av_st_din_0
        if {$vib_vob_removal == 0} {
            add_connection   user_packet_mux.av_st_dout       video_out.av_st_din
        } else {
            set_interface_property  dout_data   export_of     user_packet_mux.av_st_dout
        }

        # User packet bypass
        add_connection   user_packet_demux.av_st_dout_1   user_packet_mux.av_st_din_1
    } else {
        # Direct datapath connections VIB -> alg_core -> VOB
        add_connection   video_in_cmd.av_st_dout          clipper_core.av_st_din
        if {$vib_vob_removal == 0} {
            add_connection   clipper_core.av_st_dout          video_out.av_st_din
        } else {
            set_interface_property  dout_data   export_of     clipper_core.av_st_dout
        }
    }

    # Optional runtime control interface and connections
    if {$runtime_control > 0 } {
        # Top level interface :
        add_interface   control    avalon   slave
        set_interface_property   control   export_of   scheduler.av_mm_control
    }
}


