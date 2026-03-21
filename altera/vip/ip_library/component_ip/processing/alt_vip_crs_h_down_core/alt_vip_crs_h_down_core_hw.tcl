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


# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property  NAME                 alt_vip_crs_h_down_core
set_module_property  DISPLAY_NAME         "Chroma resampler core: 4:4:4 to 4:2:2"
set_module_property  DESCRIPTION          "Downsamples 4:4:4 video lines to 4:2:2"

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
add_alt_vip_common_h_kernel_files               ../../..
add_alt_vip_common_round_sat_files              ../../..
add_alt_vip_common_sop_align_files              ../../..
add_static_sv_file src_hdl/alt_vip_crs_h_down_core.sv
add_static_sv_file src_hdl/alt_vip_crs_h_down_core_nn.sv
add_static_sv_file src_hdl/alt_vip_crs_h_down_core_bl.sv
add_static_sv_file src_hdl/alt_vip_crs_h_down_core_ft.sv

add_static_misc_file src_hdl/alt_vip_crs_h_down_core.ocp

setup_filesets alt_vip_crs_h_down_core

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_channels_nb_parameters
add_bits_per_symbol_parameters

set_parameter_property  NUMBER_OF_COLOR_PLANES  VISIBLE        false
set_parameter_property  NUMBER_OF_COLOR_PLANES  HDL_PARAMETER  false

add_pixels_in_parallel_parameters       {1 2 4 8}

add_parameter           ALGORITHM   STRING               BILINEAR
set_parameter_property  ALGORITHM   DISPLAY_NAME         "Resampling algorithm"
set_parameter_property  ALGORITHM   ALLOWED_RANGES       {NEAREST_NEIGHBOUR BILINEAR FILTERED} 
set_parameter_property  ALGORITHM   AFFECTS_ELABORATION  false
set_parameter_property  ALGORITHM   HDL_PARAMETER        true

add_parameter           CO_SITING   STRING               LEFT
set_parameter_property  CO_SITING   DISPLAY_NAME         "Vertical chroma siting"
set_parameter_property  CO_SITING   ALLOWED_RANGES       {LEFT CENTRE} 
set_parameter_property  CO_SITING   AFFECTS_ELABORATION  true
set_parameter_property  CO_SITING   HDL_PARAMETER        true

add_parameter           PIPELINE_READY    INTEGER              0
set_parameter_property  PIPELINE_READY    DISPLAY_NAME         "Pipeline data output ready"
set_parameter_property  PIPELINE_READY    ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY    DISPLAY_HINT         BOOLEAN
set_parameter_property  PIPELINE_READY    AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY    HDL_PARAMETER        true

add_av_st_event_parameters

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
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc validation_cb {} {
   pip_validation_callback_helper
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc elaboration_cb {} {
   
   set   bits_per_symbol         [get_parameter_value BITS_PER_SYMBOL]
   set   symbols_per_pixel_in    3
   set   symbols_per_pixel_out   2
   set   are_in_par              [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pixels_per_beat         [get_parameter_value PIXELS_IN_PARALLEL]
   set   src_width               [get_parameter_value SRC_WIDTH]
   set   dst_width               [get_parameter_value DST_WIDTH]
   set   context_width           [get_parameter_value CONTEXT_WIDTH]
   set   task_width              [get_parameter_value TASK_WIDTH]
   
   if { $are_in_par > 0 } {
      set   dwidth_in   [expr $bits_per_symbol * $symbols_per_pixel_in]
      set   dwidth_out  [expr $bits_per_symbol * $symbols_per_pixel_out]	
   } else {
      set   dwidth_in   $bits_per_symbol 
      set   dwidth_out  $bits_per_symbol
   }
    
   add_av_st_data_sink_port      av_st_din   $dwidth_in  $pixels_per_beat  $dst_width  $src_width  $task_width $context_width 0  main_clock  0
   add_av_st_data_source_port    av_st_dout  $dwidth_out $pixels_per_beat  $dst_width  $src_width  $task_width $context_width 0  main_clock  0
}

