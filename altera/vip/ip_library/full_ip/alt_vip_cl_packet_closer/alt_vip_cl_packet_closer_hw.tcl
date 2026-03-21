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
#-- _hw.tcl compose file for the Component Library Switch (Switch II)                             --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info

# -- General Info --
set_module_property NAME alt_vip_cl_packet_closer
set_module_property DISPLAY_NAME "Packet Timeout Controller Intel FPGA IP"
set_module_property DESCRIPTION ""
set_module_property HIDE_FROM_QUARTUS true
set_module_property INTERNAL $internalComponents

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set_module_property VALIDATION_CALLBACK validation_cb
set_module_property ELABORATION_CALLBACK elaboration_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_alt_vip_common_pkg_files                             ../..
add_alt_vip_common_latency_1_to_latency_0                ../..
add_alt_vip_common_latency_0_to_latency_1                ../..
add_alt_vip_common_slave_interface_files                 ../..
add_static_sv_file src_hdl/alt_vip_cl_packet_closer.sv

setup_filesets alt_vip_cl_packet_closer

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_bits_per_symbol_parameters

# adds NUMBER_OF_COLOR_PLANES, COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters

# adds PIXELS_IN_PARALLEL
add_pixels_in_parallel_parameters

add_runtime_control_parameters   1

add_parameter MAX_TIMEOUT INTEGER 100000
set_parameter_property MAX_TIMEOUT DISPLAY_NAME "Maximum timeout count"
set_parameter_property MAX_TIMEOUT ALLOWED_RANGES 32:2147483647
set_parameter_property MAX_TIMEOUT DESCRIPTION ""
set_parameter_property MAX_TIMEOUT AFFECTS_ELABORATION false
set_parameter_property MAX_TIMEOUT HDL_PARAMETER true

add_parameter END_VIDEO_ONLY INTEGER 0
set_parameter_property END_VIDEO_ONLY DISPLAY_NAME "Timeout video packets only"
set_parameter_property END_VIDEO_ONLY ALLOWED_RANGES 0:1
set_parameter_property END_VIDEO_ONLY DISPLAY_HINT boolean
set_parameter_property END_VIDEO_ONLY DESCRIPTION ""
set_parameter_property END_VIDEO_ONLY AFFECTS_ELABORATION false
set_parameter_property END_VIDEO_ONLY HDL_PARAMETER true

add_parameter READY_LATENCY INTEGER 1
set_parameter_property READY_LATENCY VISIBLE false
set_parameter_property READY_LATENCY DISPLAY_NAME "Ready Latency"
set_parameter_property READY_LATENCY ALLOWED_RANGES {0,1}
set_parameter_property READY_LATENCY DESCRIPTION "The latency of the core's Avalon ST Video Ready signal"
set_parameter_property READY_LATENCY AFFECTS_ELABORATION true
set_parameter_property READY_LATENCY HDL_PARAMETER true

# -- Static Ports --
add_main_clock_port


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Handling cross-dependencies between parameters (error/warning messages and dynamic GUI       --
# -- behaviour                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc validation_cb {} {
    # Parameters validation
    pip_validation_callback_helper
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc elaboration_cb {} {

    # Avalon streaming source(s)
    set ready_latency                  [get_parameter_value READY_LATENCY]
    set bits_per_sym                   [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes         [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set color_planes_are_in_parallel   [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set number_of_pixels_in_parallel   [get_parameter_value PIXELS_IN_PARALLEL]

    add_av_st_video_input_port  din   $bits_per_sym  $number_of_color_planes  $color_planes_are_in_parallel  $number_of_pixels_in_parallel  main_clock   $ready_latency
    add_av_st_video_output_port dout  $bits_per_sym  $number_of_color_planes  $color_planes_are_in_parallel  $number_of_pixels_in_parallel  main_clock   $ready_latency

    if { [get_parameter_value RUNTIME_CONTROL] > 0 } {
      add_control_slave_port   control   3   6   1   1   1   1   main_clock
   }

}

