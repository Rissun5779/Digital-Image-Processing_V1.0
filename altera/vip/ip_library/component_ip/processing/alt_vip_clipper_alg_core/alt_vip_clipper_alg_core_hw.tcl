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


# ------------------------------------------------------------------------------------------------------------
# --                                                                                                        --
# -- _hw.tcl file for the clipper algorithmic core module                                                   --
# -- This block sinks Avalon-ST Message Data packets from a single source and crops data from the start     --
# -- and/or end of the packet as per the commands issued through the Avalon-ST Message Command interface.   --
# -- The resulting packets are output through a single Avalon-ST Message Data source                        --
# --                                                                                                        --
# ------------------------------------------------------------------------------------------------------------
source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl


# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property  NAME                 alt_vip_clipper_alg_core
set_module_property  DISPLAY_NAME         "Clipper Algorithmic Core"
set_module_property  DESCRIPTION          "Removes pixels from the start and/or end of video lines"

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
add_static_sv_file src_hdl/alt_vip_clipper_alg_core.sv

add_static_misc_file  src_hdl/alt_vip_clipper_alg_core.ocp

setup_filesets alt_vip_clipper_alg_core

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set x_max $vipsuite_max_width

add_channels_nb_parameters
add_bits_per_symbol_parameters

add_pixels_in_parallel_parameters       {1 2 4 8}

add_max_in_dim_parameters
set_parameter_property  MAX_IN_WIDTH         ALLOWED_RANGES       32:$x_max
set_parameter_property  MAX_IN_HEIGHT        VISIBLE              false
set_parameter_property  MAX_IN_HEIGHT        HDL_PARAMETER        false

add_parameter           DATA_SRC_ADDRESS     INTEGER              2
set_parameter_property  DATA_SRC_ADDRESS     DISPLAY_NAME         "Source ID"
set_parameter_property  DATA_SRC_ADDRESS     AFFECTS_ELABORATION  true
set_parameter_property  DATA_SRC_ADDRESS     HDL_PARAMETER        true

add_parameter           PIPELINE_DATA_OUTPUT INTEGER              0
set_parameter_property  PIPELINE_DATA_OUTPUT DISPLAY_NAME         "Pipeline data output ready"
set_parameter_property  PIPELINE_DATA_OUTPUT ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_DATA_OUTPUT DISPLAY_HINT         BOOLEAN
set_parameter_property  PIPELINE_DATA_OUTPUT AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_DATA_OUTPUT HDL_PARAMETER        true

add_parameter           LEFT_OFFSET          INTEGER              0
set_parameter_property  LEFT_OFFSET          HDL_PARAMETER        false
set_parameter_property  LEFT_OFFSET          AFFECTS_ELABORATION  false
set_parameter_property  LEFT_OFFSET          VISIBLE              false

add_parameter           RIGHT_OFFSET         INTEGER              0
set_parameter_property  RIGHT_OFFSET         HDL_PARAMETER        false
set_parameter_property  RIGHT_OFFSET         AFFECTS_ELABORATION  false
set_parameter_property  RIGHT_OFFSET         VISIBLE              false

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
   
   set   bits_per_symbol   [get_parameter_value BITS_PER_SYMBOL]
   set   symbols_per_pixel [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   are_in_par        [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pixels_per_beat   [get_parameter_value PIXELS_IN_PARALLEL]
   set   src_width         [get_parameter_value SRC_WIDTH]
   set   dst_width         [get_parameter_value DST_WIDTH]
   set   context_width     [get_parameter_value CONTEXT_WIDTH]
   set   task_width        [get_parameter_value TASK_WIDTH]
   set   src_id            [get_parameter_value DATA_SRC_ADDRESS]
   
   if { $are_in_par > 0 } {
      set   dwidth   [expr $bits_per_symbol * $symbols_per_pixel]	
   } else {
      set   dwidth   $bits_per_symbol 
   }
   
   add_av_st_cmd_sink_port       av_st_cmd            1                 $dst_width  $src_width  $task_width $context_width    main_clock  $src_id    
   add_av_st_data_sink_port      av_st_din   $dwidth  $pixels_per_beat  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
   add_av_st_data_source_port    av_st_dout  $dwidth  $pixels_per_beat  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
}

