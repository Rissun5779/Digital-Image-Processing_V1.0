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
set_module_property   NAME                          alt_vip_dil_algorithm
set_module_property   DISPLAY_NAME                  "Deinterlace algorithmic core"
set_module_property   DESCRIPTION                   "Receives deinterlace commands (on the cmd interface), reads the video data on the bob, weave and motion interfaces and sources deinterlaced video on dout interface"

set_module_property   ELABORATION_CALLBACK          dil_algo_elaboration_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file      src_hdl/alt_vip_dil_algorithm.sv

setup_filesets   alt_vip_dil_algorithm


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
add_bits_per_symbol_parameters
add_channels_nb_parameters
add_is_422_parameters

add_parameter SOURCE_ADDRESS INTEGER 0 "Source ID of deinterlace component on output interface(s)"
set_parameter_property SOURCE_ADDRESS DISPLAY_NAME "Deinterlace ID"
set_parameter_property SOURCE_ADDRESS AFFECTS_GENERATION false
set_parameter_property SOURCE_ADDRESS HDL_PARAMETER true
set_parameter_property SOURCE_ADDRESS AFFECTS_ELABORATION true
set_parameter_property SOURCE_ADDRESS DERIVED false

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
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc dil_algo_elaboration_callback {} {

    set bits_per_symbol              [get_parameter_value BITS_PER_SYMBOL]
    set is_422                       [get_parameter_value IS_422]
    set color_planes_are_in_parallel [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set number_of_color_planes       [get_parameter_value NUMBER_OF_COLOR_PLANES]

    set symbols_in_seq               [expr { $color_planes_are_in_parallel ? 1 : $number_of_color_planes } ] 
    set symbols_in_par               [expr { $color_planes_are_in_parallel ? $number_of_color_planes : 1 } ] 

    set src_width                    [get_parameter_value SRC_WIDTH]
    set dst_width                    [get_parameter_value DST_WIDTH]
    set context_width                [get_parameter_value CONTEXT_WIDTH]
    set task_width                   [get_parameter_value TASK_WIDTH]

    set motion_dwidth                8

    set weave_dwidth                 [expr {$bits_per_symbol * $symbols_in_par}]
    set dout_dwidth                  [expr {$bits_per_symbol * $symbols_in_par}]
    set bob_dwidth                   [expr {2 * $weave_dwidth}]
    
    set src_id                       [get_parameter_value SOURCE_ADDRESS]
    
    add_av_st_cmd_sink_port    cmd                       1 $dst_width $src_width $task_width $context_width main_clock $src_id    
    add_av_st_data_sink_port   din_weave  $weave_dwidth  1 $dst_width $src_width $task_width $context_width 0 main_clock $src_id    
    add_av_st_data_sink_port   din_bob    $bob_dwidth    1 $dst_width $src_width $task_width $context_width 0 main_clock $src_id    
    add_av_st_data_sink_port   din_motion $motion_dwidth 1 $dst_width $src_width $task_width $context_width 0 main_clock $src_id    
    add_av_st_data_source_port dout       $dout_dwidth   1 $dst_width $src_width $task_width $context_width 0 main_clock $src_id
    
}



