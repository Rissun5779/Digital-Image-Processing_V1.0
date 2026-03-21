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
#-- _hw.tcl compose file for Component Library Interlacer (Interlacer 2)                          --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source   ../../common_tcl/alt_vip_helper_common.tcl
source   ../../common_tcl/alt_vip_files_common.tcl
source   ../../common_tcl/alt_vip_parameters_common.tcl
source   ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME         alt_vip_cl_interlacer
set_module_property DISPLAY_NAME "Interlacer II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION  "The Interlacer II interlaces progressive frames to create a stream of alternating F0 and F1 fields."

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Callback for the composition of this component
set_module_property  COMPOSITION_CALLBACK interlacer_composition_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set x_max $vipsuite_max_width
set y_max $vipsuite_max_height

add_bits_per_symbol_parameters
set_parameter_property  BITS_PER_SYMBOL               HDL_PARAMETER        false

add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER        false

add_max_dim_parameters  32 $x_max   32 $y_max
set_parameter_property  MAX_WIDTH                     VISIBLE              false
set_parameter_property  MAX_WIDTH                     AFFECTS_ELABORATION  false
set_parameter_property  MAX_WIDTH                     HDL_PARAMETER        false
set_parameter_property  MAX_HEIGHT                    ENABLED              true
set_parameter_property  MAX_HEIGHT                    AFFECTS_ELABORATION  true
set_parameter_property  MAX_HEIGHT                    HDL_PARAMETER        false

add_parameter           INTERLACE_PASSTHROUGH         INTEGER              1
set_parameter_property  INTERLACE_PASSTHROUGH         DISPLAY_NAME         "Enable interlace passthrough"
set_parameter_property  INTERLACE_PASSTHROUGH         ALLOWED_RANGES       0:1
set_parameter_property  INTERLACE_PASSTHROUGH         DISPLAY_HINT         boolean
set_parameter_property  INTERLACE_PASSTHROUGH         DESCRIPTION          "Enables passthrough of interlaced data received at the input, otherwise interlaced input is discarded. If runtime control is enabled this parameter sets the default value used at startup, but may be overridden via the control interface to enable/disable interlace passthrough as required."
set_parameter_property  INTERLACE_PASSTHROUGH         HDL_PARAMETER        false
set_parameter_property  INTERLACE_PASSTHROUGH         AFFECTS_ELABORATION  true

add_parameter           SEND_F1_FIRST                 INTEGER              1
set_parameter_property  SEND_F1_FIRST                 DISPLAY_NAME         "Send F1 first"
set_parameter_property  SEND_F1_FIRST                 ALLOWED_RANGES       0:1
set_parameter_property  SEND_F1_FIRST                 DISPLAY_HINT         boolean
set_parameter_property  SEND_F1_FIRST                 DESCRIPTION          "Controls whether F0 or F1 is sent first when interlacing a progressive input. If runtime control is enabled this parameter sets the default value used at startup, but may be overridden via the control interface to allow F0 or F1 to be send first as required."
set_parameter_property  SEND_F1_FIRST                 HDL_PARAMETER        false
set_parameter_property  SEND_F1_FIRST                 AFFECTS_ELABORATION  true

add_parameter           CTRL_OVERRIDE                 INTEGER              1
set_parameter_property  CTRL_OVERRIDE                 DISPLAY_NAME         "Enable control packet override"
set_parameter_property  CTRL_OVERRIDE                 ALLOWED_RANGES       0:1
set_parameter_property  CTRL_OVERRIDE                 DISPLAY_HINT         boolean
set_parameter_property  CTRL_OVERRIDE                 DESCRIPTION          "Enabling this feature allows the input control packet to override the default selection of F0 or F1 for the next output field if the control packet states that the input progressive frame was created by deinterlacing an F0 or F1 field earlier in the pipeline. If runtime control is enabled this parameter sets the default value used at startup, but may be overridden via the control interface to enable/disable control packet override as required."
set_parameter_property  CTRL_OVERRIDE                 HDL_PARAMETER        false
set_parameter_property  CTRL_OVERRIDE                 AFFECTS_ELABORATION  true

add_parameter           EXTRA_PIPELINING              INTEGER              0
set_parameter_property  EXTRA_PIPELINING              DISPLAY_NAME         "Add extra pipelining registers"
set_parameter_property  EXTRA_PIPELINING              ALLOWED_RANGES       0:1
set_parameter_property  EXTRA_PIPELINING              DESCRIPTION          "Selecting this option adds extra pipeline stage registers to the data path"
set_parameter_property  EXTRA_PIPELINING              HDL_PARAMETER        false
set_parameter_property  EXTRA_PIPELINING              AFFECTS_ELABORATION  true
set_parameter_property  EXTRA_PIPELINING              DISPLAY_HINT         boolean

add_runtime_control_parameters 1
set_parameter_property  RUNTIME_CONTROL               HDL_PARAMETER        false
set_parameter_property  LIMITED_READBACK              HDL_PARAMETER        false


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_display_item  "Video Data Format"     MAX_HEIGHT                    parameter
add_display_item  "Video Data Format"     BITS_PER_SYMBOL               parameter
add_display_item  "Video Data Format"     NUMBER_OF_COLOR_PLANES        parameter
add_display_item  "Video Data Format"     PIXELS_IN_PARALLEL            parameter
add_display_item  "Video Data Format"     COLOR_PLANES_ARE_IN_PARALLEL  parameter

add_display_item  "Interlacing Options"   INTERLACE_PASSTHROUGH         parameter
add_display_item  "Interlacing Options"   SEND_F1_FIRST                 parameter
add_display_item  "Interlacing Options"   CTRL_OVERRIDE                 parameter
add_display_item  "Interlacing Options"   RUNTIME_CONTROL               parameter

add_display_item  "Optimisation"          EXTRA_PIPELINING              parameter
add_display_item  "Optimisation"          LIMITED_READBACK              parameter

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                        --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc interlacer_composition_callback {} {
    global isVersion acdsVersion
    global x_max
    global vib_vob_removal

    # Parameters:
    set bits_per_symbol     [get_parameter_value BITS_PER_SYMBOL]
    set number_of_colors    [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set colors_in_par       [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel  [get_parameter_value PIXELS_IN_PARALLEL]
    set max_in_height       [get_parameter_value MAX_HEIGHT]
    set limited_readback    [get_parameter_value LIMITED_READBACK]
    set pipeline_ready      [get_parameter_value EXTRA_PIPELINING]
    set runtime_control     [get_parameter_value RUNTIME_CONTROL]

    # The chain of components to compose :
    add_instance   av_st_clk_bridge     altera_clock_bridge              $acdsVersion
    add_instance   av_st_reset_bridge   altera_reset_bridge              $acdsVersion

    add_instance   video_in_cmd         alt_vip_video_input_bridge_cmd   $isVersion
    add_instance   scheduler            alt_vip_interlacer_scheduler     $isVersion

    if {$vib_vob_removal == 0} {
        add_instance   video_in_resp    alt_vip_video_input_bridge_resp  $isVersion
        add_instance   video_out        alt_vip_video_output_bridge      $isVersion

       # VIB resp parameterization
       set_instance_parameter_value  video_in_resp     BITS_PER_SYMBOL               $bits_per_symbol
       set_instance_parameter_value  video_in_resp     NUMBER_OF_COLOR_PLANES        $number_of_colors
       set_instance_parameter_value  video_in_resp     COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
       set_instance_parameter_value  video_in_resp     PIXELS_IN_PARALLEL            $pixels_in_parallel
       set_instance_parameter_value  video_in_resp     MAX_WIDTH                     $x_max
       set_instance_parameter_value  video_in_resp     MAX_HEIGHT                    $max_in_height
       set_instance_parameter_value  video_in_resp     DEFAULT_LINE_LENGTH           1920
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
       set_instance_parameter_value   video_out        SOP_PRE_ALIGNED               0
       set_instance_parameter_value   video_out        NO_CONCATENATION              0
       set_instance_parameter_value   video_out        VIDEO_PROTOCOL_NO             1
       set_instance_parameter_value   video_out        SRC_WIDTH                     8
       set_instance_parameter_value   video_out        DST_WIDTH                     8
       set_instance_parameter_value   video_out        CONTEXT_WIDTH                 8
       set_instance_parameter_value   video_out        TASK_WIDTH                    8
       set_instance_parameter_value   video_out        PIPELINE_READY                $pipeline_ready

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

    # Scheduler parameterization
    set_instance_parameter_value   scheduler        MAX_HEIGHT                    $max_in_height
    set_instance_parameter_value   scheduler        RUNTIME_CONTROL               $runtime_control
    set_instance_parameter_value   scheduler        PIPELINE_READY                $pipeline_ready
    set_instance_parameter_value   scheduler        LIMITED_READBACK              $limited_readback
    set_instance_parameter_value   scheduler        INTERLACE_PASSTHROUGH         [get_parameter_value INTERLACE_PASSTHROUGH]
    set_instance_parameter_value   scheduler        SEND_F1_FIRST                 [get_parameter_value SEND_F1_FIRST]
    set_instance_parameter_value   scheduler        CTRL_OVERRIDE                 [get_parameter_value CTRL_OVERRIDE]

    # Top level interfaces :
    add_interface          main_clock   clock         end
    add_interface          main_reset   reset         end
    set_interface_property main_clock   export_of     av_st_clk_bridge.in_clk
    set_interface_property main_reset   export_of     av_st_reset_bridge.in_reset
    set_interface_property main_clock   PORT_NAME_MAP {main_clock in_clk}
    set_interface_property main_reset   PORT_NAME_MAP {main_reset in_reset}

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
      set_interface_property  din_data    export_of         video_in_cmd.av_st_din
      set_interface_property  dout_data   export_of         video_in_cmd.av_st_dout
      set_interface_property  din_aux     export_of         scheduler.av_st_resp_vib
      set_interface_property  dout_aux    export_of         scheduler.av_st_cmd_vob
    }

    # Av-ST Clock connections :
    add_connection   av_st_clk_bridge.out_clk   av_st_reset_bridge.clk
    add_connection   av_st_clk_bridge.out_clk   video_in_cmd.main_clock
    add_connection   av_st_clk_bridge.out_clk   scheduler.main_clock

    # Av-ST Reset connections :
    add_connection   av_st_reset_bridge.out_reset   video_in_cmd.main_reset
    add_connection   av_st_reset_bridge.out_reset   scheduler.main_reset

    add_connection   scheduler.av_st_cmd_vib        video_in_cmd.av_st_cmd

    if {$vib_vob_removal == 0} {
       add_connection   av_st_clk_bridge.out_clk       video_in_resp.main_clock
       add_connection   av_st_clk_bridge.out_clk       video_out.main_clock
       add_connection   av_st_reset_bridge.out_reset   video_in_resp.main_reset
       add_connection   av_st_reset_bridge.out_reset   video_out.main_reset

       add_connection   video_in_resp.av_st_dout       video_in_cmd.av_st_din
       add_connection   video_in_resp.av_st_resp       scheduler.av_st_resp_vib
       add_connection   scheduler.av_st_cmd_vob        video_out.av_st_cmd
       add_connection   video_in_cmd.av_st_dout        video_out.av_st_din
    }

    # Optional runtime control interface and connections
    if {$runtime_control > 0 } {
        # Top level interface :
        add_interface   control    avalon   slave
        set_interface_property   control   export_of   scheduler.av_mm_control
    }
}


