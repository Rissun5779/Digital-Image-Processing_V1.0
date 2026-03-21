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


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information for the Mixer II algorithmic component.                                  --
# -- This block mixes a number of inputs using alpha values to give transparency.                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

# Common module properties for VIP components 
declare_general_component_info

# Component specific properties
set_module_property   NAME                  alt_vip_mix_alg_core
set_module_property   DISPLAY_NAME          "Mixer algorithmic core"
set_module_property   DESCRIPTION           "Receives mix commands (on the cmd interface), sources mixed video on dout interface"


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
set_module_property   ELABORATION_CALLBACK  elaboration_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
add_alt_vip_common_pkg_files                    ../../..
add_alt_vip_common_event_packet_decode_files    ../../..
add_alt_vip_common_event_packet_encode_files    ../../..
add_alt_vip_common_sop_align_files              ../../..
add_alt_vip_common_mult_add_files               ../../..
add_alt_vip_common_message_pipeline_stage_files ../../..

add_static_sv_file              src_hdl/alt_vip_mix_alg_core_pkg.sv
add_static_sv_file              src_hdl/alt_vip_mix_alg_core_align.sv
add_static_sv_file              src_hdl/alt_vip_mix_alg_core_blend.sv
add_static_sv_file              src_hdl/alt_vip_mix_alg_core_switch.sv
add_static_sv_file              src_hdl/alt_vip_mix_alg_core.sv

add_static_misc_file            src_hdl/alt_vip_mix_alg_core_align.ocp
add_static_misc_file            src_hdl/alt_vip_mix_alg_core_blend.ocp
add_static_misc_file            src_hdl/alt_vip_mix_alg_core_switch.ocp
add_static_misc_file            src_hdl/alt_vip_mix_alg_core.ocp

setup_filesets  alt_vip_mix_alg_core


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

set max_inputs 20

# Adds BITS_PER_SYMBOL
add_bits_per_symbol_parameters

# Adds NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters

# Adds MAX_WIDTH and MAX_HEIGHT
add_max_dim_parameters 32 $vipsuite_max_width 32 $vipsuite_max_height
set_parameter_property MAX_WIDTH                 DEFAULT_VALUE            1920
set_parameter_property MAX_WIDTH                 ENABLED                  true
set_parameter_property MAX_WIDTH                 AFFECTS_ELABORATION      true

set_parameter_property MAX_HEIGHT                DEFAULT_VALUE            1080
set_parameter_property MAX_HEIGHT                ENABLED                  true
set_parameter_property MAX_HEIGHT                AFFECTS_ELABORATION      true

add_parameter          NO_OF_INPUTS              INTEGER                  4
set_parameter_property NO_OF_INPUTS              DISPLAY_NAME             "Number of inputs"
set_parameter_property NO_OF_INPUTS              ALLOWED_RANGES           1:$max_inputs
set_parameter_property NO_OF_INPUTS              DESCRIPTION              "The number of Avalon ST Video inputs to be mixed"
set_parameter_property NO_OF_INPUTS              AFFECTS_ELABORATION      true
set_parameter_property NO_OF_INPUTS              HDL_PARAMETER            true

add_parameter          PIXELS_IN_PARALLEL        INTEGER                  1
set_parameter_property PIXELS_IN_PARALLEL        DISPLAY_NAME             PIXELS_IN_PARALLEL
set_parameter_property PIXELS_IN_PARALLEL        ALLOWED_RANGES           {1,2,4,8}
set_parameter_property PIXELS_IN_PARALLEL        AFFECTS_GENERATION       true
set_parameter_property PIXELS_IN_PARALLEL        HDL_PARAMETER            true
set_parameter_property PIXELS_IN_PARALLEL        DISPLAY_NAME             "Number of pixels in parallel"

add_parameter          ALPHA_ENABLE              INTEGER             0
set_parameter_property ALPHA_ENABLE              DISPLAY_NAME        "Alpha Blending Enable"
set_parameter_property ALPHA_ENABLE              ALLOWED_RANGES      {1,0}
set_parameter_property ALPHA_ENABLE              DESCRIPTION         "Enables Alpha blending"
set_parameter_property ALPHA_ENABLE              HDL_PARAMETER       true
set_parameter_property ALPHA_ENABLE              AFFECTS_ELABORATION true
set_parameter_property ALPHA_ENABLE              VISIBLE             false

add_parameter          LAYER_POSITION_ENABLE     INTEGER             0
set_parameter_property LAYER_POSITION_ENABLE     DISPLAY_NAME        "Layer Position Enable"
set_parameter_property LAYER_POSITION_ENABLE     ALLOWED_RANGES      {1,0}
set_parameter_property LAYER_POSITION_ENABLE     DESCRIPTION         "Enable input layer position mappings"
set_parameter_property LAYER_POSITION_ENABLE     DISPLAY_HINT        boolean
set_parameter_property LAYER_POSITION_ENABLE     HDL_PARAMETER       true
set_parameter_property LAYER_POSITION_ENABLE     AFFECTS_ELABORATION true
set_parameter_property LAYER_POSITION_ENABLE     VISIBLE             false

add_parameter          DATA_SRC_ADDRESS          INTEGER                  2
set_parameter_property DATA_SRC_ADDRESS          DISPLAY_NAME             "Source ID"
set_parameter_property DATA_SRC_ADDRESS          AFFECTS_ELABORATION      true
set_parameter_property DATA_SRC_ADDRESS          HDL_PARAMETER            true

add_parameter          PIPELINE_READY            INTEGER                  0
set_parameter_property PIPELINE_READY            DISPLAY_NAME             "Pipeline dout ready"
set_parameter_property PIPELINE_READY            ALLOWED_RANGES           0:1
set_parameter_property PIPELINE_READY            DISPLAY_HINT             BOOLEAN
set_parameter_property PIPELINE_READY            AFFECTS_ELABORATION      false
set_parameter_property PIPELINE_READY            HDL_PARAMETER            true

add_parameter          DATA_PIPELINE_STAGES      INTEGER                0
set_parameter_property DATA_PIPELINE_STAGES      DISPLAY_NAME           "Add extra register stages to data pipeline"
set_parameter_property DATA_PIPELINE_STAGES      DESCRIPTION            "Add extra register stages in the data pipeline to improve timing. Add one register stage every Nth data stage; 0 to disable."
set_parameter_property DATA_PIPELINE_STAGES      ALLOWED_RANGES         0:$max_inputs
set_parameter_property DATA_PIPELINE_STAGES      AFFECTS_ELABORATION    true
set_parameter_property DATA_PIPELINE_STAGES      HDL_PARAMETER          true
set_parameter_property DATA_PIPELINE_STAGES      DISPLAY_HINT           boolean

for { set input 0 } { $input < $max_inputs } { incr input } {

    add_parameter            ALPHA_STREAM_ENABLE${input}       INTEGER                0
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       DISPLAY_NAME           "    Input${input} alpha channel"
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       ALLOWED_RANGES         0:1
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       DISPLAY_HINT           boolean
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       AFFECTS_ELABORATION    true
    set_parameter_property   ALPHA_STREAM_ENABLE${input}       HDL_PARAMETER          true
}

# Adds Avalon-ST message parameters (SRC_WIDTH, DST_WIDTH, CONTEXT_WIDTH, TASK_WIDTH)
add_av_st_event_parameters 


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
#clock
add_main_clock_port


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic Ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
proc elaboration_cb {} {
    set no_of_inputs           [get_parameter_value NO_OF_INPUTS                     ]
    set bits_per_symbol        [get_parameter_value BITS_PER_SYMBOL                  ]
    set are_in_par             [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL     ]
    set number_of_color_planes [get_parameter_value NUMBER_OF_COLOR_PLANES           ]
    set pixels_per_beat        [get_parameter_value PIXELS_IN_PARALLEL               ]

    set src_width              [get_parameter_value SRC_WIDTH                        ]
    set dst_width              [get_parameter_value DST_WIDTH                        ]
    set context_width          [get_parameter_value CONTEXT_WIDTH                    ]
    set task_width             [get_parameter_value TASK_WIDTH                       ]

    set src_address            [get_parameter_value DATA_SRC_ADDRESS                 ]

    set empty_width_int        [clogb2_pure [expr $pixels_per_beat]                  ] 
    set empty_width            [expr $pixels_per_beat > 1 ? $empty_width_int : 0     ]

    set user_width_int         [clogb2_pure [expr $pixels_per_beat]                  ] 
    set user_width             [expr $pixels_per_beat > 1 ? $user_width_int : 0      ]

    set number_of_color_planes_plus_alpha [expr $number_of_color_planes + 1]

    set din_data_width        [expr $bits_per_symbol * $number_of_color_planes_plus_alpha                    ]
    set dout_data_width       [expr $bits_per_symbol * $number_of_color_planes                               ]

    add_av_st_cmd_sink_port        av_st_cmd                      1                                 $dst_width $src_width $task_width $context_width    main_clock $src_address

    add_av_st_array_data_sink_port av_st_din        $no_of_inputs $din_data_width  $pixels_per_beat $dst_width $src_width $task_width $context_width 0  main_clock $src_address
    add_av_st_data_sink_port       av_st_background               $dout_data_width $pixels_per_beat $dst_width $src_width $task_width $context_width 0  main_clock $src_address
    add_av_st_data_source_port     av_st_dout                     $dout_data_width $pixels_per_beat $dst_width $src_width $task_width $context_width 0  main_clock $src_address
}
