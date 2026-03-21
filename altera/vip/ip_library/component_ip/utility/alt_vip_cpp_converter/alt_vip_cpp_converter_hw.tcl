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
#-- alt_vip_cpp_converter_hw.tcl file for the cpp_converter component                             --
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
set_module_property  NAME                 alt_vip_cpp_converter
set_module_property  DISPLAY_NAME         "Color Planes per Pixel converter"
set_module_property  DESCRIPTION          "Restructure color planes packets"


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
# set_module_property  VALIDATION_CALLBACK  validation_cb

# Elaboration callback to set up the dynamic ports
set_module_property  ELABORATION_CALLBACK elaboration_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files                    ../../..		
add_alt_vip_common_event_packet_decode_files    ../../..
add_alt_vip_common_event_packet_encode_files    ../../..
add_alt_vip_common_fifo2_files                  ../../..

add_static_sv_file    src_hdl/alt_vip_cpp_converter.sv

setup_filesets alt_vip_cpp_converter

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# adds BITS_PER_SYMBOL
add_bits_per_symbol_parameters

# adds NUMBER_OF_COLOR_PLANES_IN/_OUT
add_parameter            NUMBER_OF_COLOR_PLANES_IN           INTEGER                3 
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN           DISPLAY_NAME           "Number of input color planes"
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN           ALLOWED_RANGES         1:4
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN           DESCRIPTION            "The number of input color planes received"
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN           HDL_PARAMETER          true
set_parameter_property   NUMBER_OF_COLOR_PLANES_IN           AFFECTS_ELABORATION    true

add_parameter            NUMBER_OF_COLOR_PLANES_OUT           INTEGER                3 
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT           DISPLAY_NAME           "Number of output color planes"
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT           ALLOWED_RANGES         1:4
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT           DESCRIPTION            "The number of output color planes transmitted"
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT           HDL_PARAMETER          true
set_parameter_property   NUMBER_OF_COLOR_PLANES_OUT           AFFECTS_ELABORATION    true


# adds PIXELS_IN_PARALLEL_IN/_OUT
add_in_out_pixels_in_parallel_parameters {1 2 4 8}

# adds PIPELINE_READY
add_pipeline_ready_parameters

# adds SRC_WIDTH, DST_WIDTH, CONTEXT_WIDTH, TASK_WIDTH
add_av_st_event_parameters

# adds USER_WIDTH
# add_av_st_event_user_width_parameters

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

# The main clock and associated reset
add_main_clock_port


proc elaboration_cb {} {
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol               [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes_in     [get_parameter_value NUMBER_OF_COLOR_PLANES_IN]
    set number_of_color_planes_out    [get_parameter_value NUMBER_OF_COLOR_PLANES_OUT]
    set pixels_in_parallel_in         [get_parameter_value PIXELS_IN_PARALLEL_IN]
    set pixels_in_parallel_out        [get_parameter_value PIXELS_IN_PARALLEL_OUT]
    
    set src_width                     [get_parameter_value SRC_WIDTH]
    set dst_width                     [get_parameter_value DST_WIDTH]
    set context_width                 [get_parameter_value CONTEXT_WIDTH]
    set task_width                    [get_parameter_value TASK_WIDTH]
#    set source_id                    [get_parameter_value SOURCE_ID]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    set  din_width           [expr $bits_per_symbol * $number_of_color_planes_in]
    set  dout_width          [expr $bits_per_symbol * $number_of_color_planes_out]
    
    set  num_values_in       [expr $pixels_in_parallel_in]
    set  num_values_out      [expr $pixels_in_parallel_out]


    # --------------------------------------------------------------------------------------------------
    # -- Dynamic ports                                                                                --
    # --------------------------------------------------------------------------------------------------
    add_av_st_data_sink_port   av_st_din    $din_width   $num_values_in   $dst_width  $src_width  $task_width $context_width    0  main_clock  0
    add_av_st_data_source_port av_st_dout   $dout_width  $num_values_out  $dst_width  $src_width  $task_width $context_width    0  main_clock  0
   
}

