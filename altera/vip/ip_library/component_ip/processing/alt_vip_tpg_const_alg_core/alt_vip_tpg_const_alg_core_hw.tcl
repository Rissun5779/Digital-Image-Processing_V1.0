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
set_module_property NAME alt_vip_tpg_const_alg_core
set_module_property DISPLAY_NAME "Test Pattern Generator Core (Constant colour)"
set_module_property VALIDATION_CALLBACK tpg_validation_callback
set_module_property ELABORATION_CALLBACK tpg_elaboration_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_tpg_const_alg_core.sv

add_static_misc_file  src_hdl/alt_vip_tpg_const_alg_core.ocp

setup_filesets alt_vip_tpg_const_alg_core

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
	
add_bits_per_symbol_parameters

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL   ALLOWED_RANGES       1:8
 
add_channels_nb_parameters  
set_parameter_property NUMBER_OF_COLOR_PLANES ALLOWED_RANGES 1:3

add_parameter           TPG_CS         STRING               YCbCr_422
set_parameter_property  TPG_CS         DISPLAY_NAME         "Test pattern colour space"
set_parameter_property  TPG_CS         ALLOWED_RANGES       {RGB_444 YCbCr_444 YCbCr_422 YCbCr_420 MONO}
set_parameter_property  TPG_CS         AFFECTS_ELABORATION  false
set_parameter_property  TPG_CS         HDL_PARAMETER        true

add_max_dim_parameters

add_parameter           PIPELINE_READY INTEGER              0
set_parameter_property  PIPELINE_READY DISPLAY_NAME         "Pipeline Av-ST ready signals"
set_parameter_property  PIPELINE_READY ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY HDL_PARAMETER        true

add_av_st_event_parameters

add_parameter           SOURCE_ID      INTEGER              0
set_parameter_property  SOURCE_ID      DISPLAY_NAME         "Output source ID"
set_parameter_property  SOURCE_ID      HDL_PARAMETER        true
set_parameter_property  SOURCE_ID      AFFECTS_ELABORATION  true

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# The main clock and associated reset
add_main_clock_port

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc tpg_elaboration_callback {} {
   set src_id                       [get_parameter_value SOURCE_ID]
   set bps						         [get_parameter_value BITS_PER_SYMBOL]
   set par_mode					      [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   if { $par_mode > 0 } {
      set num_colours					[get_parameter_value NUMBER_OF_COLOR_PLANES]
   } else {
      set num_colours	            1
   }
   set pixels_in_parallel           [get_parameter_value PIXELS_IN_PARALLEL]
   set src_width                    [get_parameter_value SRC_WIDTH]
   set dst_width                    [get_parameter_value DST_WIDTH]
   set context_width                [get_parameter_value CONTEXT_WIDTH]
   set task_width                   [get_parameter_value TASK_WIDTH]

   set data_width                   [expr $bps * $num_colours]

   add_av_st_cmd_sink_port      av_st_cmd   1                                   $dst_width   $src_width   $task_width   $context_width      main_clock   $src_id
   add_av_st_data_source_port   av_st_dout  $data_width   $pixels_in_parallel   $dst_width   $src_width   $task_width   $context_width   0  main_clock   $src_id
}

proc tpg_validation_callback {} {
   set   colour_space   [get_parameter_value TPG_CS]
   set   num_colours    [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   in_par         [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pip            [get_parameter_value PIXELS_IN_PARALLEL]
   if { $pip > 1 } {
      if { $in_par == 0 } {
         send_message Error "Colour planes must be transmitted in parallel for multiple pixels in parallel"
      }
   }
   if {[string compare $colour_space MONO] == 0} {
      if { $num_colours != 1 } {
         send_message Error "The MONO colour space requires 1 colour plane per pixel"
      }
   } else {
      if {[string compare $colour_space RGB_444] == 0} {
         if { $num_colours != 3 } {
            send_message Error "The RGB 444 colour space requires 3 colour planes per pixel"
         }
      } else {
         if {[string compare $colour_space YCbCr_444] == 0} {
            if { $num_colours != 3 } {
               send_message Error "The YCbCr colour space requires 3 colour planes per pixel for 4:4:4 sampling"
            }
         } else {
            if {[string compare $colour_space YCbCr_422] == 0} {
               if { $num_colours < 2 } {
                  send_message Error "The YCbCr colour space requires 2 or 3 colour planes per pixel for 4:2:2 sampling"
               }
            } else {
               if { $num_colours != 3 } {
                  send_message Error "The YCbCr colour space requires 3 colour planes per pixel for 4:2:0 sampling"
               }
               if { $in_par == 0 } {
                  send_message Error "4:2:0 sampling requires colour planes to be transmitted in parallel"
               }
            }
         }
      }
   }
}
