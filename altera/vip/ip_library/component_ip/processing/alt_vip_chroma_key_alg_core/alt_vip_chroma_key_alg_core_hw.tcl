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
# -- General information for the Deinterlacer II algorithmic component (HQ MA quality)            --
# -- This block interpolates the bob pixel (low-angle EDI) and merges with the weave pixel        --
# -- depending on the  motion value                                                               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

# Common module properties for VIP components 
declare_general_component_info

# Component specific properties
set_module_property   NAME                  alt_vip_chroma_key_alg_core
set_module_property   DISPLAY_NAME          "chroma key algorithmic core"
set_module_property   DESCRIPTION           "Sets Alpha value on top channel to predetermined number based upon channels 2 to 0 matching the key"

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
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_fifo2_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file    src_hdl/alt_vip_chroma_key_alg_core.sv

setup_filesets alt_vip_chroma_key_alg_core


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

# adds BITS_PER_SYMBOL
add_bits_per_symbol_parameters

# adds NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters

# adds PIXELS_IN_PARALLEL
add_pixels_in_parallel_parameters
set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES 1

# adds MAX_WIDTH and MAX_HEIGHT
add_max_dim_parameters

# adds IS_422
add_is_422_parameters

add_av_st_event_parameters 

add_parameter SOURCE_ADDRESS INTEGER 0 "Source ID of chromaer component on output interface(s)"
set_parameter_property SOURCE_ADDRESS DISPLAY_NAME "chroma ID"
set_parameter_property SOURCE_ADDRESS AFFECTS_GENERATION false
set_parameter_property SOURCE_ADDRESS HDL_PARAMETER true
set_parameter_property SOURCE_ADDRESS AFFECTS_ELABORATION true
set_parameter_property SOURCE_ADDRESS DERIVED false

add_parameter  DEFAULT_ALPHA_VALUE  INTEGER 0 "Alpha value to be applied when input colors do not match key values"             
set_parameter_property DEFAULT_ALPHA_VALUE DISPLAY_NAME "Default Alpha value"
set_parameter_property DEFAULT_ALPHA_VALUE AFFECTS_GENERATION true
set_parameter_property DEFAULT_ALPHA_VALUE HDL_PARAMETER true
set_parameter_property DEFAULT_ALPHA_VALUE AFFECTS_ELABORATION true
set_parameter_property DEFAULT_ALPHA_VALUE DERIVED false


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
#clock
add_main_clock_port

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports  elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
proc elaboration_cb {} {

    set bits_per_symbol        [get_parameter_value BITS_PER_SYMBOL]
    set are_in_par             [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set symbols_per_pixel      [get_parameter_value NUMBER_OF_COLOR_PLANES]

    set src_width              [get_parameter_value SRC_WIDTH]
    set dst_width              [get_parameter_value DST_WIDTH]
    set context_width          [get_parameter_value CONTEXT_WIDTH]
    set task_width             [get_parameter_value TASK_WIDTH]

    set dwidth                 [expr {$symbols_per_pixel * ($are_in_par ? $bits_per_symbol : 1)}]
    
    set src_id                 [get_parameter_value SOURCE_ADDRESS]

    add_av_st_cmd_sink_port    av_st_cmd                            1   $dst_width   $src_width   $task_width   $context_width        main_clock   $src_id
    
    add_av_st_data_sink_port   av_st_din          $dwidth           1   $dst_width   $src_width   $task_width  $context_width   0   main_clock  $src_id
    add_av_st_data_source_port av_st_dout         $dwidth           1   $dst_width   $src_width   $task_width  $context_width   0   main_clock  $src_id
    add_av_st_data_source_port av_st_alpha_dout   $bits_per_symbol  1   $dst_width   $src_width   $task_width  $context_width   0   main_clock  $src_id
    
}
