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
set_module_property  NAME                 alt_vip_crs_422_drop_pad
set_module_property  DISPLAY_NAME         "Chroma resampler 4:2:2 colours per pixel adapter"
set_module_property  DESCRIPTION          "Adds or removes an unused symbol per pixel for 4:2:2 on a variable colour space interface"

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
add_static_sv_file src_hdl/alt_vip_crs_422_drop_pad.sv

setup_filesets alt_vip_crs_422_drop_pad

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

add_parameter           PAD_MODE          INTEGER              0
set_parameter_property  PAD_MODE          DISPLAY_NAME         "Add extra symbol (default is drop extra symbol)"
set_parameter_property  PAD_MODE          ALLOWED_RANGES       0:1
set_parameter_property  PAD_MODE          DISPLAY_HINT         BOOLEAN
set_parameter_property  PAD_MODE          AFFECTS_ELABORATION  true
set_parameter_property  PAD_MODE          HDL_PARAMETER        true

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
   set   pad_mode                [get_parameter_value PAD_MODE]
   if { $pad_mode > 0 } {
      set   symbols_per_pixel_in    2
      set   symbols_per_pixel_out   3
   } else {
      set   symbols_per_pixel_in    3
      set   symbols_per_pixel_out   2
   }
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

