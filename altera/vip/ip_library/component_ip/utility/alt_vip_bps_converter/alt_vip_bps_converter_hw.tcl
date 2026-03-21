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
#-- alt_vip_bps_converter_hw.tcl file for the cpp_converter component                             --
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
set_module_property  NAME                 alt_vip_bps_converter
set_module_property  DISPLAY_NAME         "Bits per Symbol converter"
set_module_property  DESCRIPTION          "Convert Bits per Symbol"


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
add_alt_vip_common_event_packet_decode_files    ../../..
add_alt_vip_common_event_packet_encode_files    ../../..

add_static_sv_file    src_hdl/alt_vip_bps_converter.sv    

setup_filesets alt_vip_bps_converter

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# adds INPUT_/OUTPUT_BITS_PER_SYMBOL
add_in_out_bits_per_symbol_parameters

# adds NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters

# adds PIXELS_IN_PARALLEL
add_pixels_in_parallel_parameters

# adds CONVERSION_MODE
add_conversion_mode_parameters

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

# The main clock and associated reset
add_main_clock_port


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc validation_cb {} {
    # pip > 1 not allowed with color planes in sequence
    pip_validation_callback_helper
    
    # disable MSB/LSB selection when input_bps == output_bps
    conversion_mode_validation_callback_helper
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
    set input_bits_per_symbol         [get_parameter_value INPUT_BITS_PER_SYMBOL]
    set output_bits_per_symbol        [get_parameter_value OUTPUT_BITS_PER_SYMBOL]
    
    set number_of_color_planes        [get_parameter_value NUMBER_OF_COLOR_PLANES]
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
        set input_data_width         [expr $input_bits_per_symbol * $number_of_color_planes]
        set output_data_width        [expr $output_bits_per_symbol * $number_of_color_planes]
    } else {
        set input_data_width         [expr $input_bits_per_symbol]
        set output_data_width        [expr $output_bits_per_symbol]
    }
    
    # --------------------------------------------------------------------------------------------------
    # -- Dynamic ports                                                                                --
    # --------------------------------------------------------------------------------------------------
    add_av_st_data_sink_port   av_st_din    $input_data_width   $pixels_in_parallel   $dst_width  $src_width  $task_width $context_width    0  main_clock  0
    add_av_st_data_source_port av_st_dout   $output_data_width  $pixels_in_parallel   $dst_width  $src_width  $task_width $context_width    0  main_clock  0  
}

