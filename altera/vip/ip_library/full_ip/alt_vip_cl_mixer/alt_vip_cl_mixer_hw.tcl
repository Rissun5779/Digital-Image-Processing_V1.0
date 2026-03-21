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
# -- _hw.tcl compose file for Component Library Mixer (Mixer 2)                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info

set_module_property NAME                  alt_vip_cl_mixer
set_module_property DISPLAY_NAME          "Mixer II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION           "The Mixer II integrates a test pattern generator, which outputs either a continual color bar or uniform test pattern at the required frame resolution."


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

set_module_property PARAMETER_UPGRADE_CALLBACK  upgrade_callback
set_module_property VALIDATION_CALLBACK         validation_callback
set_module_property COMPOSITION_CALLBACK        composition_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

set x_max $vipsuite_max_width
set y_max $vipsuite_max_height

set max_inputs 20

#-- Add BITS_PER_SYMBOL parameter
add_bits_per_symbol_parameters

#-- Add NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL parameters
add_channels_nb_parameters

set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL  DEFAULT_VALUE          1
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL  ALLOWED_RANGES         1:1
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL  DESCRIPTION            "The mixer only supports color planes transmitted in parallel"
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL  VISIBLE                false
set_parameter_property   NUMBER_OF_COLOR_PLANES        VISIBLE                false

#-- Add PIXELS_IN_PARALLEL parameter
add_pixels_in_parallel_parameters

add_parameter            NO_OF_INPUTS                  INTEGER                4
set_parameter_property   NO_OF_INPUTS                  DISPLAY_NAME           "Number of inputs"
set_parameter_property   NO_OF_INPUTS                  ALLOWED_RANGES         1:$max_inputs
set_parameter_property   NO_OF_INPUTS                  DESCRIPTION            "The number of Avalon ST Video inputs to be mixed"
set_parameter_property   NO_OF_INPUTS                  AFFECTS_ELABORATION    true

# Add MAX_WIDTH and MAX_HEIGHT
add_max_dim_parameters   32 $x_max 32 $y_max
set_parameter_property   MAX_WIDTH                     DISPLAY_NAME           "Maximum output frame width"
set_parameter_property   MAX_WIDTH                     DESCRIPTION            "Maximum output frame width and default background width"
set_parameter_property   MAX_WIDTH                     AFFECTS_ELABORATION    true

set_parameter_property   MAX_HEIGHT                    DISPLAY_NAME           "Maximum output frame height"
set_parameter_property   MAX_HEIGHT                    DESCRIPTION            "Maximum output frame height and default background height"
set_parameter_property   MAX_HEIGHT                    AFFECTS_ELABORATION true

for { set input 0 } { $input < $max_inputs } { incr input } {

    add_parameter            ALPHA_STREAM_ENABLE${input}       INTEGER                0
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       DISPLAY_NAME           "    Input${input} alpha channel"
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       DESCRIPTION            "Enable an alpha channel for each pixel."
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       ALLOWED_RANGES         0:1
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       DISPLAY_HINT           boolean
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       AFFECTS_ELABORATION    true
}

#-- Add IS_422 parameter
add_is_422_parameters

add_parameter            COLOR_SPACE                   STRING                 "RGB"
set_parameter_property   COLOR_SPACE                   DISPLAY_NAME           "Colorspace (used for background layer)"
set_parameter_property   COLOR_SPACE                   DESCRIPTION            "The color space to use for the background layer, either R'G'B or Y'Cb'Cr"
set_parameter_property   COLOR_SPACE                   ALLOWED_RANGES         {RGB YCbCr}
set_parameter_property   COLOR_SPACE                   DISPLAY_HINT           radio
set_parameter_property   COLOR_SPACE                   AFFECTS_ELABORATION    true

add_parameter            PATTERN                       STRING                 "colorbars"
set_parameter_property   PATTERN                       DISPLAY_NAME           "Pattern"
set_parameter_property   PATTERN                       DESCRIPTION            "Selects either uniform color or color bars for the background layer"
set_parameter_property   PATTERN                       ALLOWED_RANGES         {{colorbars:Color bars} {uniform:Uniform background}}
set_parameter_property   PATTERN                       DISPLAY_HINT           ""
set_parameter_property   PATTERN                       AFFECTS_ELABORATION    true

add_parameter            UNIFORM_VALUE_RY              INTEGER                0
set_parameter_property   UNIFORM_VALUE_RY              DISPLAY_NAME           "R or Y"
set_parameter_property   UNIFORM_VALUE_RY              DESCRIPTION            "Default color bit value for R or Y"
set_parameter_property   UNIFORM_VALUE_RY              ALLOWED_RANGES         0:1048575
set_parameter_property   UNIFORM_VALUE_RY              AFFECTS_ELABORATION    true

add_parameter            UNIFORM_VALUE_GCB             INTEGER                0
set_parameter_property   UNIFORM_VALUE_GCB             DISPLAY_NAME           "G or Cb"
set_parameter_property   UNIFORM_VALUE_GCB             DESCRIPTION            "Default color bit value for G or Cb"
set_parameter_property   UNIFORM_VALUE_GCB             ALLOWED_RANGES         0:1048575
set_parameter_property   UNIFORM_VALUE_GCB             AFFECTS_ELABORATION    true

add_parameter            UNIFORM_VALUE_BCR             INTEGER                0
set_parameter_property   UNIFORM_VALUE_BCR             DISPLAY_NAME           "B or Cr"
set_parameter_property   UNIFORM_VALUE_BCR             DESCRIPTION            "Default color bit value for B or Cr"
set_parameter_property   UNIFORM_VALUE_BCR             ALLOWED_RANGES         0:1048575
set_parameter_property   UNIFORM_VALUE_BCR             AFFECTS_ELABORATION    true

add_parameter            ALPHA_ENABLE                  INTEGER                0
set_parameter_property   ALPHA_ENABLE                  DISPLAY_NAME           "Alpha Blending Enable (all layers)"
set_parameter_property   ALPHA_ENABLE                  DESCRIPTION            "Enables the layers to be Alpha blended under register control"
set_parameter_property   ALPHA_ENABLE                  ALLOWED_RANGES         0:1
set_parameter_property   ALPHA_ENABLE                  DISPLAY_HINT           boolean
set_parameter_property   ALPHA_ENABLE                  AFFECTS_ELABORATION    true

add_parameter            LAYER_POSITION_ENABLE         INTEGER                0
set_parameter_property   LAYER_POSITION_ENABLE         DISPLAY_NAME           "Layer Position Enable"
set_parameter_property   LAYER_POSITION_ENABLE         DESCRIPTION            "Enable input layer position mappings"
set_parameter_property   LAYER_POSITION_ENABLE         ALLOWED_RANGES         0:1
set_parameter_property   LAYER_POSITION_ENABLE         DISPLAY_HINT           boolean
set_parameter_property   LAYER_POSITION_ENABLE         AFFECTS_ELABORATION    true

add_parameter            PIPELINE_READY                INTEGER                0
set_parameter_property   PIPELINE_READY                DISPLAY_NAME           "Register Avalon-ST ready signals"
set_parameter_property   PIPELINE_READY                DESCRIPTION            "Register Avalon-ST ready signals to improve timing"
set_parameter_property   PIPELINE_READY                ALLOWED_RANGES         0:1
set_parameter_property   PIPELINE_READY                DISPLAY_HINT           boolean
set_parameter_property   PIPELINE_READY                AFFECTS_ELABORATION    true

add_parameter            LIMITED_READBACK              INTEGER                0
set_parameter_property   LIMITED_READBACK              DISPLAY_NAME           "Reduced control register readback"
set_parameter_property   LIMITED_READBACK              DESCRIPTION            "Disable read back on control register other than control, status and interrupt."
set_parameter_property   LIMITED_READBACK              ALLOWED_RANGES         0:1
set_parameter_property   LIMITED_READBACK              DISPLAY_HINT           boolean
set_parameter_property   LIMITED_READBACK              AFFECTS_ELABORATION    true
set_parameter_property   LIMITED_READBACK              HDL_PARAMETER          true

add_parameter            LOW_LATENCY_MODE              INTEGER                0
set_parameter_property   LOW_LATENCY_MODE              DISPLAY_NAME           "Synchronise background to layer 0"
set_parameter_property   LOW_LATENCY_MODE              DESCRIPTION            "Without this mode the TPG is used for the background layer and is free running. With this mode enabled background is synchronised to layer 0."
set_parameter_property   LOW_LATENCY_MODE              ALLOWED_RANGES         0:1
set_parameter_property   LOW_LATENCY_MODE              AFFECTS_ELABORATION    true
set_parameter_property   LOW_LATENCY_MODE              HDL_PARAMETER          true
set_parameter_property   LOW_LATENCY_MODE              DISPLAY_HINT           boolean

add_parameter            DATA_PIPELINE_STAGES          INTEGER                0
set_parameter_property   DATA_PIPELINE_STAGES          DISPLAY_NAME           "Add extra register stages to data pipeline"
set_parameter_property   DATA_PIPELINE_STAGES          DESCRIPTION            "Add extra register stages in the data pipeline to improve timing. Add one register stage every Nth data stage; 0 to disable. There are as many data stages as there are inputs."
set_parameter_property   DATA_PIPELINE_STAGES          ALLOWED_RANGES         0:$max_inputs
set_parameter_property   DATA_PIPELINE_STAGES          AFFECTS_ELABORATION    true
set_parameter_property   DATA_PIPELINE_STAGES          HDL_PARAMETER          true

# Allow user packet support level to be defined
# Adds USER_PACKET_SUPPORT and USER_PACKET_FIFO_DEPTH 
#
# USER_PACKET_FIFO_DEPTH isn't required for the mixer as a FIFO would be redundant
# given the way the user packets are handled.
#
add_user_packet_support_parameters   "DISCARD"               1
set_parameter_property               USER_PACKET_FIFO_DEPTH  VISIBLE false

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

add_display_item "Behavior"                       LOW_LATENCY_MODE             parameter
add_display_item "Behavior"                       LAYER_POSITION_ENABLE        parameter

add_display_item "Input Configuration"            NO_OF_INPUTS                 parameter
add_display_item "Input Configuration"            ALPHA_ENABLE                 parameter
add_display_item "Input Configuration"            TEXT                         text "Alpha channel for each input:"

for { set input 0 } { $input < $max_inputs } { incr input } {
    add_display_item "Input Configuration"        ALPHA_STREAM_ENABLE${input}     parameter
}

add_display_item "Background Test Pattern Layer"  PATTERN                      parameter
add_display_item "Background Test Pattern Layer"  TEXT                         text "Uniform values (if uniform background pattern selected)"
add_display_item "Background Test Pattern Layer"  UNIFORM_VALUE_RY             parameter
add_display_item "Background Test Pattern Layer"  UNIFORM_VALUE_GCB            parameter
add_display_item "Background Test Pattern Layer"  UNIFORM_VALUE_BCR            parameter

add_display_item "Video Data Format"              MAX_WIDTH                    parameter
add_display_item "Video Data Format"              MAX_HEIGHT                   parameter
add_display_item "Video Data Format"              BITS_PER_SYMBOL              parameter
add_display_item "Video Data Format"              PIXELS_IN_PARALLEL           parameter
add_display_item "Video Data Format"              COLOR_SPACE                  parameter
add_display_item "Video Data Format"              IS_422                       parameter

add_display_item "Optimisation"                   PIPELINE_READY               parameter
add_display_item "Optimisation"                   LIMITED_READBACK             parameter
add_display_item "Optimisation"                   TEXT                         text ""
add_display_item "Optimisation"                   TEXT                         text ""
add_display_item "Optimisation"                   DATA_PIPELINE_STAGES         parameter
add_display_item "Optimisation"                   TEXT                         text ""
add_display_item "Optimisation"                   USER_PACKET_SUPPORT          parameter

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Upgrade callback                                                                             --
# -- ACDS version upgrade/downgrade                                                               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc upgrade_callback {ip_core_type version parameters} {

    foreach { name value } $parameters {

        switch $name {

            ALPHA_BIT_PER_PIXEL {
                # Do nothing, ALPHA_BIT_PER_PIXEL removed
            } 
            ALPHA_MODE {
                # Do nothing, ALPHA_MODE removed
            } 
            ALPHA_STREAMS_ENABLE {
                # Enable all of the alpha stream inputs
                set max_inputs 20
                for { set input 0 } { $input < $max_inputs } { incr input } {
                    if { $value > 0 } {
                        set_parameter_value ALPHA_STREAM_ENABLE${input} 1
                    } else {
                        set_parameter_value ALPHA_STREAM_ENABLE${input} 0
                    }
                }
            } 
            NUMBER_OF_COLOR_PLANES {
                # Do nothing, NUMER_OF_COLOR_PLANES removed
            } 
            RUNTIME_CONTROL {
                # Do nothing, RUNTIME_CONTROL removed
            }
            OUTPUT_FORMAT {
                # Don't pass on but need to know if 4.2.2
                if { [string equal $value "4.2.2"] != 0 } {
                    set_parameter_value IS_422 1
                } else {
                    set_parameter_value IS_422 0
                }
            }

            default                {
                set_parameter_value $name $value
            }
        }
    }
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

proc validation_callback {} {
 
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set width		            [get_parameter_value MAX_WIDTH                                         ]
    set height		            [get_parameter_value MAX_HEIGHT                                        ]
    set color_space             [get_parameter_value COLOR_SPACE                                       ]
    set is_422                  [get_parameter_value IS_422                                            ]
    set user_packet_support     [get_parameter_value USER_PACKET_SUPPORT                               ]
    set pattern                 [get_parameter_value PATTERN                                           ]
    set low_latency_mode        [get_parameter_value LOW_LATENCY_MODE                                  ]
    set data_pipeline_stages    [get_parameter_value DATA_PIPELINE_STAGES                              ]
    set alpha_enable            [get_parameter_value ALPHA_ENABLE                                      ]
    set no_of_inputs            [get_parameter_value NO_OF_INPUTS                                      ]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    set odd_height                      [expr {$height % 2}]
    set odd_width                       [expr {$width % 2}]
    set is_rgb                          [string equal $color_space "RGB"]
    set user_packets_propagated         [string equal $user_packet_support "PASSTHROUGH"]
    set uniform_tpg_background          [string equal $pattern "uniform"]

    # --------------------------------------------------------------------------------------------------
    # -- Validation                                                                                   --
    # --------------------------------------------------------------------------------------------------
    pip_validation_callback_helper
    user_packet_support_validation_callback_helper

    if { $is_rgb != 0 } {
        if { $odd_width == 1 && $is_422 == 1 } {
            send_message error "4:2:2 mode does not allow odd maximum widths"
        }
    }

    # --------------------------------------------------------------------------------------------------
    # -- GUI constraints                                                                             --
    # --------------------------------------------------------------------------------------------------

    #-- 4:2:2 subsampling only works for the YCbCr colorspace
    if { $is_rgb } {
        set_parameter_property IS_422  ENABLED false
    } else {
        set_parameter_property IS_422  ENABLED true
    }
        
    #-- Settings for the TPG
    if { $uniform_tpg_background } {
         set_parameter_property UNIFORM_VALUE_RY  ENABLED true
         set_parameter_property UNIFORM_VALUE_GCB ENABLED true
         set_parameter_property UNIFORM_VALUE_BCR ENABLED true
    } else {
         set_parameter_property UNIFORM_VALUE_RY  ENABLED false
         set_parameter_property UNIFORM_VALUE_GCB ENABLED false
         set_parameter_property UNIFORM_VALUE_BCR ENABLED false
    }

    #-- Layer positions are only appropriate with more than one input.
    if { $no_of_inputs > 1 } {
        set_parameter_property LAYER_POSITION_ENABLE ENABLED true
    } else {
        set_parameter_property LAYER_POSITION_ENABLE ENABLED false
    }

    set max_inputs 20
    for { set input 0 } { $input < $max_inputs } { incr input } {
        if { $no_of_inputs > $input } {
            set_parameter_property ALPHA_STREAM_ENABLE${input} ENABLED true
        } else {
            set_parameter_property ALPHA_STREAM_ENABLE${input} ENABLED false
        }
    }

    send_message warning "The MixerII register map changed in version 16.0. Please refer to the VIP User Guide for details."
}

proc composition_callback {} {

    global isVersion acdsVersion vib_vob_removal

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol         [get_parameter_value BITS_PER_SYMBOL             ]
    set colours_in_par          [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel      [get_parameter_value PIXELS_IN_PARALLEL          ]
    set no_of_inputs            [get_parameter_value NO_OF_INPUTS                ]
    set alpha_enable            [get_parameter_value ALPHA_ENABLE                ]
    set layer_position_enable   [get_parameter_value LAYER_POSITION_ENABLE       ]
    set max_height              [get_parameter_value MAX_HEIGHT                  ]
    set max_width               [get_parameter_value MAX_WIDTH                   ]
    set color_space             [get_parameter_value COLOR_SPACE                 ]
    set uniform_value_ry        [get_parameter_value UNIFORM_VALUE_RY            ]
    set uniform_value_gcb       [get_parameter_value UNIFORM_VALUE_GCB           ]
    set uniform_value_bcr       [get_parameter_value UNIFORM_VALUE_BCR           ]
    set pattern	                [get_parameter_value PATTERN                     ]
    set is_422                  [get_parameter_value IS_422                      ]
    set user_packet_support     [get_parameter_value USER_PACKET_SUPPORT         ]
    set pipeline_ready          [get_parameter_value PIPELINE_READY              ]
    set limited_readback        [get_parameter_value LIMITED_READBACK            ]
    set low_latency_mode        [get_parameter_value LOW_LATENCY_MODE            ]
    set data_pipeline_stages    [get_parameter_value DATA_PIPELINE_STAGES        ]

    set max_inputs 20
    for { set input 0 } { $input < $max_inputs } { incr input } {
        #if { $alpha_enable > 0 } {
            set alpha_streams_enable(${input}) [get_parameter_value ALPHA_STREAM_ENABLE${input} ]
        #} else {
            #set alpha_streams_enable(${input}) 0
        #}
    }

    # --------------------------------------------------------------------------------------------------
    # -- Constants                                                                                    --
    # --------------------------------------------------------------------------------------------------
    set src_width              8
    set dst_width              8
    set context_width          8
    set task_width             8
    set user_width             0

    # --------------------------------------------------------------------------------------------------
    # -- Derived and disabled parameters                                                              --
    # --------------------------------------------------------------------------------------------------
    set is_rgb                          [string equal $color_space "RGB"]
    set user_packets_propagated         [string equal $user_packet_support "PASSTHROUGH"]
    set uniform_tpg_background          [string equal $pattern "uniform"]

    # Overwrite is_422 with RGB colorspace
    if { $is_rgb != 0 } {
        set is_422 0
    }

    if { $is_422 } {
        set tpg_output_format "4.2.2"
    } else {
        set tpg_output_format "4.4.4"
    }

    #-- Work out how many color planes we need given 444/422 and RGB/YCbCr.
    if { $is_rgb != 0 } {
        set implied_number_of_color_planes 3
    } else {
        if { $is_422 } {
            set implied_number_of_color_planes 2
        }  else {
            set implied_number_of_color_planes 3
        }
    }

    if { $colours_in_par == 1 } {
       set number_of_color_planes $implied_number_of_color_planes
    } else {
       set number_of_color_planes 1
    }

    #-- There's an extra color plane for alpha
    set number_of_color_planes_plus_alpha [ expr $number_of_color_planes + 1 ]

    if {$uniform_tpg_background != 0} {
        set use_background_as_border 1
    } else {
        set use_background_as_border 0        
    }

    for { set input 0 } { $input < $max_inputs } { incr input } {

        if { $alpha_streams_enable(${input}) > 0 } {
            set number_of_color_planes_in(${input}) $number_of_color_planes_plus_alpha
            set video_data_width_in(${input})       [ expr $bits_per_symbol * $number_of_color_planes_plus_alpha ]
        } else {
            set number_of_color_planes_in(${input}) $number_of_color_planes
            set video_data_width_in(${input})       [ expr $bits_per_symbol * $number_of_color_planes ]
        }
    }
    set video_data_width_out    [ expr $bits_per_symbol * $number_of_color_planes ]

    set user_packet_mux_inputs  [ expr $no_of_inputs + 1 ]
   
    # --------------------------------------------------------------------------------------------------
    # -- Clock/reset bridges                                                                          --
    # --------------------------------------------------------------------------------------------------
    add_instance       av_st_clk_bridge          altera_clock_bridge             $acdsVersion
    add_instance       av_st_reset_bridge        altera_reset_bridge             $acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- sub-components                                                                              --
    # --------------------------------------------------------------------------------------------------
    for { set i 0 } { $i < $no_of_inputs } { incr i } {
        if {$vib_vob_removal == 0} {
            add_instance       vib_resp${i}          alt_vip_video_input_bridge_resp  $isVersion
        }
        add_instance       vib_cmd${i}               alt_vip_video_input_bridge_cmd   $isVersion
        if {$user_packets_propagated} {
            add_instance   user_demux${i}            alt_vip_packet_demux             $isVersion
            if {$alpha_streams_enable($i)} {
                add_instance   cpp_converter${i}     alt_vip_cpp_converter            $isVersion
            }
        }
        add_instance       alpha_merge${i}           alt_vip_mixer_alpha_merge   $isVersion
    }
    add_instance       tpg                       alt_vip_tpg_alg_core            $isVersion
    add_instance       mixer_core                alt_vip_mix_alg_core            $isVersion
    if {$vib_vob_removal == 0} {
       add_instance    vob                       alt_vip_video_output_bridge     $isVersion
    }
    add_instance       scheduler                 alt_vip_mix_scheduler           $isVersion

    if {$user_packets_propagated} {
        add_instance       user_mux              alt_vip_packet_mux              $isVersion
    } else {
        add_instance       cmd_mux_term          alt_vip_message_sink_terminator $isVersion
    }

    # Video input bridges + demux parameterization
    for { set i 0 } { $i < $no_of_inputs } { incr i } {
        if {$vib_vob_removal == 0} {
           set_instance_parameter_value   vib_resp${i}      VIB_MODE                      FULL   
           set_instance_parameter_value   vib_resp${i}      BITS_PER_SYMBOL               $bits_per_symbol
           set_instance_parameter_value   vib_resp${i}      COLOR_PLANES_ARE_IN_PARALLEL  1
           set_instance_parameter_value   vib_resp${i}      NUMBER_OF_COLOR_PLANES        $number_of_color_planes_in(${i})
           set_instance_parameter_value   vib_resp${i}      DEFAULT_LINE_LENGTH           $max_width 
           set_instance_parameter_value   vib_resp${i}      MAX_WIDTH                     $max_width 
           set_instance_parameter_value   vib_resp${i}      MAX_HEIGHT                    $max_height 
           set_instance_parameter_value   vib_resp${i}      PIXELS_IN_PARALLEL            $pixels_in_parallel
           set_instance_parameter_value   vib_resp${i}      PIPELINE_READY                $pipeline_ready
           set_instance_parameter_value   vib_resp${i}      READY_LATENCY_1               1
           set_instance_parameter_value   vib_resp${i}      MULTI_CONTEXT_SUPPORT         0
           set_instance_parameter_value   vib_resp${i}      VIDEO_PROTOCOL_NO             1
           set_instance_parameter_value   vib_resp${i}      ENABLE_RESOLUTION_CHECK       1
           set_instance_parameter_value   vib_resp${i}      SRC_WIDTH                     8
           set_instance_parameter_value   vib_resp${i}      DST_WIDTH                     8
           set_instance_parameter_value   vib_resp${i}      CONTEXT_WIDTH                 8
           set_instance_parameter_value   vib_resp${i}      TASK_WIDTH                    8
           set_instance_parameter_value   vib_resp${i}      RESP_SRC_ADDRESS              0
           set_instance_parameter_value   vib_resp${i}      RESP_DST_ADDRESS              0
           set_instance_parameter_value   vib_resp${i}      DATA_SRC_ADDRESS              0
        }
   
        set_instance_parameter_value   vib_cmd${i}      BITS_PER_SYMBOL               $bits_per_symbol
        set_instance_parameter_value   vib_cmd${i}      COLOR_PLANES_ARE_IN_PARALLEL  1
        set_instance_parameter_value   vib_cmd${i}      NUMBER_OF_COLOR_PLANES        $number_of_color_planes_in(${i})
        set_instance_parameter_value   vib_cmd${i}      PIXELS_IN_PARALLEL            $pixels_in_parallel
        set_instance_parameter_value   vib_cmd${i}      PIPELINE_READY                $pipeline_ready
        set_instance_parameter_value   vib_cmd${i}      SRC_WIDTH                     8
        set_instance_parameter_value   vib_cmd${i}      DST_WIDTH                     8
        set_instance_parameter_value   vib_cmd${i}      CONTEXT_WIDTH                 8
        set_instance_parameter_value   vib_cmd${i}      TASK_WIDTH                    8
        set_instance_parameter_value   vib_cmd${i}      DATA_SRC_ADDRESS              0

        set_instance_parameter_value   alpha_merge${i}  BITS_PER_SYMBOL               $bits_per_symbol
        set_instance_parameter_value   alpha_merge${i}  COLOR_PLANES_ARE_IN_PARALLEL  1
        set_instance_parameter_value   alpha_merge${i}  NUMBER_OF_COLOR_PLANES_IN     $number_of_color_planes_in(${i})
        set_instance_parameter_value   alpha_merge${i}  NUMBER_OF_COLOR_PLANES_OUT    $number_of_color_planes_plus_alpha
        set_instance_parameter_value   alpha_merge${i}  PIXELS_IN_PARALLEL            $pixels_in_parallel
        set_instance_parameter_value   alpha_merge${i}  SRC_WIDTH                     8
        set_instance_parameter_value   alpha_merge${i}  DST_WIDTH                     8
        set_instance_parameter_value   alpha_merge${i}  CONTEXT_WIDTH                 8
        set_instance_parameter_value   alpha_merge${i}  TASK_WIDTH                    8

        if {$user_packets_propagated} {
            set_instance_parameter_value   user_demux${i}   SRC_WIDTH                     $src_width
            set_instance_parameter_value   user_demux${i}   DST_WIDTH                     $dst_width
            set_instance_parameter_value   user_demux${i}   CONTEXT_WIDTH                 $context_width
            set_instance_parameter_value   user_demux${i}   TASK_WIDTH                    $task_width
            set_instance_parameter_value   user_demux${i}   USER_WIDTH                    $user_width
            set_instance_parameter_value   user_demux${i}   NUM_OUTPUTS                   2
            set_instance_parameter_value   user_demux${i}   CLIP_ADDRESS_BITS             0
            set_instance_parameter_value   user_demux${i}   REGISTER_OUTPUT               1
            set_instance_parameter_value   user_demux${i}   DATA_WIDTH                    $video_data_width_in(${i})
            set_instance_parameter_value   user_demux${i}   PIXELS_IN_PARALLEL            $pixels_in_parallel
            if {$alpha_streams_enable($i)} {
                set_instance_parameter_value   cpp_converter${i} BITS_PER_SYMBOL              $bits_per_symbol
                set_instance_parameter_value   cpp_converter${i} NUMBER_OF_COLOR_PLANES_IN    $number_of_color_planes_in(${i})
                set_instance_parameter_value   cpp_converter${i} NUMBER_OF_COLOR_PLANES_OUT   $number_of_color_planes
                set_instance_parameter_value   cpp_converter${i} PIXELS_IN_PARALLEL_IN        $pixels_in_parallel
                set_instance_parameter_value   cpp_converter${i} PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
                set_instance_parameter_value   cpp_converter${i} PIPELINE_READY               $pipeline_ready
                set_instance_parameter_value   cpp_converter${i} SRC_WIDTH                    $src_width
                set_instance_parameter_value   cpp_converter${i} DST_WIDTH                    $dst_width
                set_instance_parameter_value   cpp_converter${i} CONTEXT_WIDTH                $context_width
                set_instance_parameter_value   cpp_converter${i} TASK_WIDTH                   $task_width
            }
        }
    }

    # User packet mux parameterization if required, if not, use a terminator for the scheduler command port.
    if {$user_packets_propagated} {
        set_instance_parameter_value   user_mux         SRC_WIDTH                     $src_width
        set_instance_parameter_value   user_mux         DST_WIDTH                     $dst_width
        set_instance_parameter_value   user_mux         CONTEXT_WIDTH                 $context_width
        set_instance_parameter_value   user_mux         TASK_WIDTH                    $task_width
        set_instance_parameter_value   user_mux         NUM_INPUTS                    $user_packet_mux_inputs
        set_instance_parameter_value   user_mux         USER_WIDTH                    $user_width
        set_instance_parameter_value   user_mux         DATA_WIDTH                    $video_data_width_out
        set_instance_parameter_value   user_mux         PIXELS_IN_PARALLEL            $pixels_in_parallel
    } else {
        set_instance_parameter_value   cmd_mux_term     DATA_WIDTH                    32
        set_instance_parameter_value   cmd_mux_term     USER_WIDTH                    0
    }

    if {$vib_vob_removal == 0} {
       # Vob parameterization
       set_instance_parameter_value   vob              BITS_PER_SYMBOL               $bits_per_symbol   
       set_instance_parameter_value   vob              COLOR_PLANES_ARE_IN_PARALLEL  1
       set_instance_parameter_value   vob              NUMBER_OF_COLOR_PLANES        $number_of_color_planes
       set_instance_parameter_value   vob              PIXELS_IN_PARALLEL            $pixels_in_parallel
       set_instance_parameter_value   vob              VIDEO_PROTOCOL_NO             1
       set_instance_parameter_value   vob              SRC_WIDTH                     8
       set_instance_parameter_value   vob              DST_WIDTH                     8
       set_instance_parameter_value   vob              CONTEXT_WIDTH                 8
       set_instance_parameter_value   vob              TASK_WIDTH                    8
       set_instance_parameter_value   vob              SOP_PRE_ALIGNED               0 
       set_instance_parameter_value   vob              NO_CONCATENATION              0
       set_instance_parameter_value   vob              LOW_LATENCY_COMMAND_MODE      0
       set_instance_parameter_value   vob              MULTI_CONTEXT_SUPPORT         0
       set_instance_parameter_value   vob              PIPELINE_READY                $pipeline_ready
    }

    # Tpg parameterization
    set_instance_parameter_value   tpg              BITS_PER_SYMBOL               $bits_per_symbol   
    set_instance_parameter_value   tpg              COLOR_PLANES_ARE_IN_PARALLEL  1
    set_instance_parameter_value   tpg              COLOR_SPACE                   $color_space
    set_instance_parameter_value   tpg              OUTPUT_FORMAT                 $tpg_output_format
    set_instance_parameter_value   tpg              MAX_HEIGHT                    $max_height
    set_instance_parameter_value   tpg              MAX_WIDTH                     $max_width
    set_instance_parameter_value   tpg              PIXELS_IN_PARALLEL            $pixels_in_parallel
    set_instance_parameter_value   tpg              PATTERN                       $pattern
    set_instance_parameter_value   tpg              UNIFORM_VALUE_RY              $uniform_value_ry 
    set_instance_parameter_value   tpg              UNIFORM_VALUE_GCB             $uniform_value_gcb
    set_instance_parameter_value   tpg              UNIFORM_VALUE_BCR             $uniform_value_bcr
    set_instance_parameter_value   tpg              USE_BACKGROUND_AS_BORDER      $use_background_as_border 
	
    # Mixer algorithmic core parameterization
    set_instance_parameter_value   mixer_core       BITS_PER_SYMBOL               $bits_per_symbol   
    set_instance_parameter_value   mixer_core       NO_OF_INPUTS                  $no_of_inputs
    set_instance_parameter_value   mixer_core       COLOR_PLANES_ARE_IN_PARALLEL  1
    set_instance_parameter_value   mixer_core       NUMBER_OF_COLOR_PLANES        $number_of_color_planes
    set_instance_parameter_value   mixer_core       PIXELS_IN_PARALLEL            $pixels_in_parallel
    set_instance_parameter_value   mixer_core       MAX_WIDTH                     $max_width
    set_instance_parameter_value   mixer_core       MAX_HEIGHT                    $max_height
    set_instance_parameter_value   mixer_core       ALPHA_ENABLE                  $alpha_enable
    set_instance_parameter_value   mixer_core       LAYER_POSITION_ENABLE         $layer_position_enable
    set_instance_parameter_value   mixer_core       PIPELINE_READY                $pipeline_ready
    set_instance_parameter_value   mixer_core       DATA_PIPELINE_STAGES          $data_pipeline_stages

    for { set input 0 } { $input < $max_inputs } { incr input } {
        set_instance_parameter_value   mixer_core       ALPHA_STREAM_ENABLE${input} $alpha_streams_enable($input)
    }

    # Scheduler parameterization
    set_instance_parameter_value   scheduler        RUNTIME_CONTROL               1
    set_instance_parameter_value   scheduler        NO_OF_INPUTS                  $no_of_inputs
    set_instance_parameter_value   scheduler        USER_PACKETS_SUPPORTED        $user_packets_propagated
    set_instance_parameter_value   scheduler        ALPHA_ENABLE                  $alpha_enable
    set_instance_parameter_value   scheduler        LAYER_POSITION_ENABLE         $layer_position_enable
    set_instance_parameter_value   scheduler        FRAME_WIDTH                   $max_width
    set_instance_parameter_value   scheduler        FRAME_HEIGHT                  $max_height
    set_instance_parameter_value   scheduler        UNIFORM_VALUE_RY              $uniform_value_ry 
    set_instance_parameter_value   scheduler        UNIFORM_VALUE_GCB             $uniform_value_gcb
    set_instance_parameter_value   scheduler        UNIFORM_VALUE_BCR             $uniform_value_bcr
    set_instance_parameter_value   scheduler        PIPELINE_READY                $pipeline_ready
    set_instance_parameter_value   scheduler        LIMITED_READBACK              $limited_readback
    set_instance_parameter_value   scheduler        LOW_LATENCY_MODE              $low_latency_mode

    # --------------------------------------------------------------------------------------------------
    # -- Top-level interfaces                                                                         --
    # --------------------------------------------------------------------------------------------------
    add_interface            main_clock              clock                       end
    add_interface            main_reset              reset                       end
    set_interface_property   main_clock              export_of                   av_st_clk_bridge.in_clk
    set_interface_property   main_reset              export_of                   av_st_reset_bridge.in_reset

    if {$vib_vob_removal == 0} {
       for { set i 0 } { $i < $no_of_inputs } { incr i } {
           add_interface            din${i}             avalon_streaming            sink
           set_interface_property   din${i}             export_of                   vib_resp${i}.av_st_vid_din 
       }
       add_interface            dout                    avalon_streaming            source
       set_interface_property   dout                    export_of                   vob.av_st_vid_dout
    } else {
       for { set i 0 } { $i < $no_of_inputs } { incr i } {
           add_interface            din_data${i}        avalon_streaming            sink
           add_interface            din_aux${i}         avalon_streaming            sink
           set_interface_property   din_data${i}        export_of                   vib_cmd${i}.av_st_din 
           set_interface_property   din_aux${i}         export_of                   scheduler.resp_vib_${i}
       }
       add_interface            dout_data               avalon_streaming            source
       add_interface            dout_aux                avalon_streaming            source
       set_interface_property   dout_aux                export_of                   scheduler.cmd_vob
       if {$user_packets_propagated} {
           set_interface_property   dout_data           export_of                   user_mux.av_st_dout
       } else {
           set_interface_property   dout_data           export_of                   mixer_core.av_st_dout 
       }
       
    }

    add_interface            control                 avalon                      slave
    set_interface_property   control                 export_of                   scheduler.av_mm_control


    # --------------------------------------------------------------------------------------------------
    # -- Connection of sub-components                                                                 --
    # --------------------------------------------------------------------------------------------------
    # Av-ST clock/reset connections
    add_connection   av_st_clk_bridge.out_clk           av_st_reset_bridge.clk

    for { set i 0 } { $i < $no_of_inputs } { incr i } {
        if {$vib_vob_removal == 0} {
           add_connection   av_st_clk_bridge.out_clk           vib_resp${i}.main_clock
           add_connection   av_st_reset_bridge.out_reset       vib_resp${i}.main_reset
        }
        add_connection   av_st_clk_bridge.out_clk           vib_cmd${i}.main_clock
        add_connection   av_st_reset_bridge.out_reset       vib_cmd${i}.main_reset
        if {$user_packets_propagated} {
            add_connection   av_st_clk_bridge.out_clk           user_demux${i}.main_clock
            add_connection   av_st_reset_bridge.out_reset       user_demux${i}.main_reset
            if {$alpha_streams_enable($i)} {
                add_connection   av_st_clk_bridge.out_clk           cpp_converter${i}.main_clock
                add_connection   av_st_reset_bridge.out_reset       cpp_converter${i}.main_reset
            }
        }
        add_connection   av_st_clk_bridge.out_clk           alpha_merge${i}.main_clock
        add_connection   av_st_reset_bridge.out_reset       alpha_merge${i}.main_reset
    }

    add_connection   av_st_clk_bridge.out_clk           tpg.main_clock
    add_connection   av_st_reset_bridge.out_reset       tpg.main_reset

    add_connection   av_st_clk_bridge.out_clk           mixer_core.main_clock
    add_connection   av_st_reset_bridge.out_reset       mixer_core.main_reset
    
    if {$user_packets_propagated} {
        add_connection   av_st_clk_bridge.out_clk       user_mux.main_clock
        add_connection   av_st_reset_bridge.out_reset   user_mux.main_reset

        add_connection   scheduler.cmd_mux              user_mux.av_st_cmd
    } else {
        add_connection   av_st_clk_bridge.out_clk       cmd_mux_term.main_clock
        add_connection   av_st_reset_bridge.out_reset   cmd_mux_term.main_reset

        add_connection   scheduler.cmd_mux              cmd_mux_term.av_st_din
    }
      
    if {$vib_vob_removal == 0} {
        add_connection   av_st_clk_bridge.out_clk       vob.main_clock
        add_connection   av_st_reset_bridge.out_reset   vob.main_reset
    }

    add_connection   av_st_clk_bridge.out_clk           scheduler.main_clock
    add_connection   av_st_reset_bridge.out_reset       scheduler.main_reset

    # Scheduler connections
    add_connection   scheduler.cmd_tpg                  tpg.av_st_cmd 
    add_connection   scheduler.cmd_mix                  mixer_core.av_st_cmd
    if {$vib_vob_removal == 0} { 
        add_connection   scheduler.cmd_vob              vob.av_st_cmd 
    }
    for { set i 0 } { $i < $no_of_inputs } { incr i } {
        if {$vib_vob_removal == 0} {
           add_connection        vib_resp${i}.av_st_resp      scheduler.resp_vib_${i}
        }
        add_connection           scheduler.cmd_vib_${i}       vib_cmd${i}.av_st_cmd 
    }

    # Data path connections
    add_connection   tpg.av_st_dout                     mixer_core.av_st_background
    for { set i 0 } { $i < $no_of_inputs } { incr i } {
        if {$vib_vob_removal == 0} {
            add_connection   vib_resp${i}.av_st_dout      vib_cmd${i}.av_st_din
        }
        if {$user_packets_propagated} {
            set i_plus_1 [expr $i + 1]
            add_connection   vib_cmd${i}.av_st_dout       user_demux${i}.av_st_din
            #add_connection   user_demux${i}.av_st_dout_0  mixer_core.av_st_din_${i}
            add_connection   user_demux${i}.av_st_dout_0  alpha_merge${i}.av_st_din
            add_connection   alpha_merge${i}.av_st_dout     mixer_core.av_st_din_${i}
            if {$alpha_streams_enable($i)} {
                add_connection           user_demux${i}.av_st_dout_1  cpp_converter${i}.av_st_din
                add_connection           cpp_converter${i}.av_st_dout user_mux.av_st_din_${i_plus_1}
            } else {
                add_connection           user_demux${i}.av_st_dout_1  user_mux.av_st_din_${i_plus_1}
            }
        } else {
            add_connection   vib_cmd${i}.av_st_dout         alpha_merge${i}.av_st_din
            add_connection   alpha_merge${i}.av_st_dout     mixer_core.av_st_din_${i}
        }
    }

    if {$user_packets_propagated} {
        add_connection   mixer_core.av_st_dout              user_mux.av_st_din_0
        if {$vib_vob_removal == 0} {
            add_connection   user_mux.av_st_dout            vob.av_st_din
        }
    } else {
        if {$vib_vob_removal == 0} {
            add_connection   mixer_core.av_st_dout          vob.av_st_din
        }
    }
}
