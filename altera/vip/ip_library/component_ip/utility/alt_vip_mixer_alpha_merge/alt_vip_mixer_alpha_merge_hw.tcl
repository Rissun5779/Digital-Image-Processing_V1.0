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


#---------------------------------------------------------------------------------------------------
#--                                                                                               --
#-- alt_vip_mixer_alpha_merge_hw.tcl file for the cpp_converter component                             --
#-- This block restructures color planes packets                                                  --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl

# Common component properties for VIP components
declare_general_component_info

# Component properties
set_module_property  NAME                 alt_vip_mixer_alpha_merge
set_module_property  DISPLAY_NAME         "Adds an alpha channel (if required) to a video stream."
set_module_property  DESCRIPTION          "Adds an alpha channel (if required) to a video stream."


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

add_static_sv_file    src_hdl/alt_vip_mixer_alpha_merge.sv    

setup_filesets alt_vip_mixer_alpha_merge

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# adds INPUT_/OUTPUT_BITS_PER_SYMBOL
add_bits_per_symbol_parameters

# adds NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL
#add_channels_nb_parameters
# NUMBER_OF_COLOR_PLANES (with default 1-4 range) and boolean COLOR_PLANES_ARE_IN_PARALLEL parameters,
add_parameter            NUMBER_OF_COLOR_PLANES_IN       INTEGER                2
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN       DISPLAY_NAME           "Number of color planes"
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN       ALLOWED_RANGES         1:4
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN       DESCRIPTION            "The number of color planes received"
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN       HDL_PARAMETER          true
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN       AFFECTS_ELABORATION    true

add_parameter            NUMBER_OF_COLOR_PLANES_OUT      INTEGER                2
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT      DISPLAY_NAME           "Number of color planes"
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT      ALLOWED_RANGES         1:4
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT      DESCRIPTION            "The number of color planes transmitted"
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT      HDL_PARAMETER          true
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT      AFFECTS_ELABORATION    true

add_parameter COLOR_PLANES_ARE_IN_PARALLEL INTEGER 1
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    DISPLAY_NAME           "Color planes transmitted in parallel"
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    ALLOWED_RANGES         0:1
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    DISPLAY_HINT           boolean
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    DESCRIPTION            "Whether color planes are transmitted in parallel"
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    HDL_PARAMETER          true
set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    AFFECTS_ELABORATION    true


# adds PIXELS_IN_PARALLEL
add_pixels_in_parallel_parameters

# adds SRC_WIDTH, DST_WIDTH, CONTEXT_WIDTH, TASK_WIDTH
add_av_st_event_parameters


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Derived parameters (optional, if any)                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# adds FAMILY (derived from qsys)
# add_device_family_parameters               --- always last, not used by .xml/.xsd and SystemC because device is selected by a different mechanism (to be investigated) ---

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_main_clock_port


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc validation_cb {} {
    # pip > 1 not allowed with color planes in sequence
    pip_validation_callback_helper
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Elaboration callback                                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc elaboration_cb {} {
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol               [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes_in     [get_parameter_value NUMBER_OF_COLOR_PLANES_IN]
    set number_of_color_planes_out    [get_parameter_value NUMBER_OF_COLOR_PLANES_OUT]
    set color_planes_are_in_parallel  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel            [get_parameter_value PIXELS_IN_PARALLEL]
    
    set src_width                     [get_parameter_value SRC_WIDTH]
    set dst_width                     [get_parameter_value DST_WIDTH]
    set context_width                 [get_parameter_value CONTEXT_WIDTH]
    set task_width                    [get_parameter_value TASK_WIDTH]
    
    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    if {$color_planes_are_in_parallel} {
        set input_data_width         [expr $bits_per_symbol * $number_of_color_planes_in]
        set output_data_width        [expr $bits_per_symbol * $number_of_color_planes_out]
    } else {
        set input_data_width         [expr $bits_per_symbol]
        set output_data_width        [expr $bits_per_symbol]
    }
    
    # --------------------------------------------------------------------------------------------------
    # -- Dynamic ports                                                                                --
    # --------------------------------------------------------------------------------------------------
    add_av_st_data_sink_port   av_st_din    $input_data_width   $pixels_in_parallel   $dst_width  $src_width  $task_width $context_width    0  main_clock  0
    add_av_st_data_source_port av_st_dout   $output_data_width  $pixels_in_parallel   $dst_width  $src_width  $task_width $context_width    0  main_clock  0  
}

