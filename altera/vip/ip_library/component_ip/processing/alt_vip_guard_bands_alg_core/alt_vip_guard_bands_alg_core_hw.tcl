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
set_module_property NAME alt_vip_guard_bands_alg_core
set_module_property DISPLAY_NAME "Guard bands core"
set_module_property DESCRIPTION ""

set_module_property VALIDATION_CALLBACK  gb_validation_callback
set_module_property ELABORATION_CALLBACK gb_elaboration_callback



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file   src_hdl/alt_vip_guard_bands_alg_core.sv
add_static_misc_file src_hdl/alt_vip_guard_bands_alg_core.ocp

setup_filesets alt_vip_guard_bands_alg_core

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_bits_per_symbol_parameters                        4  20

add_channels_nb_parameters 

add_pixels_in_parallel_parameters                     {1 2 4 8}

add_parameter           IS_422                        INTEGER              0
set_parameter_property  IS_422                        ALLOWED_RANGES       0:1
set_parameter_property  IS_422                        DISPLAY_NAME         "4:2:2 data"
set_parameter_property  IS_422                        DISPLAY_HINT         boolean
set_parameter_property  IS_422                        AFFECTS_ELABORATION  false
set_parameter_property  IS_422                        HDL_PARAMETER        true

add_parameter           SIGNED_INPUT                  INTEGER              0
set_parameter_property  SIGNED_INPUT                  ALLOWED_RANGES       0:1
set_parameter_property  SIGNED_INPUT                  DISPLAY_NAME         "Signed input data"
set_parameter_property  SIGNED_INPUT                  DISPLAY_HINT         boolean
set_parameter_property  SIGNED_INPUT                  AFFECTS_ELABORATION  false
set_parameter_property  SIGNED_INPUT                  HDL_PARAMETER        true

add_parameter           SIGNED_OUTPUT                 INTEGER              0
set_parameter_property  SIGNED_OUTPUT                 ALLOWED_RANGES       0:1
set_parameter_property  SIGNED_OUTPUT                 DISPLAY_NAME         "Signed output data"
set_parameter_property  SIGNED_OUTPUT                 DISPLAY_HINT         boolean
set_parameter_property  SIGNED_OUTPUT                 AFFECTS_ELABORATION  false
set_parameter_property  SIGNED_OUTPUT                 HDL_PARAMETER        true

add_parameter           ENABLE_CMD_PORT               INTEGER              0
set_parameter_property  ENABLE_CMD_PORT               ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_CMD_PORT               DISPLAY_NAME         "Enable command port to control guard bands"
set_parameter_property  ENABLE_CMD_PORT               DISPLAY_HINT         boolean
set_parameter_property  ENABLE_CMD_PORT               AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_CMD_PORT               HDL_PARAMETER        true

for { set i 0 } { $i < 4} { incr i } {

   add_parameter           OUTPUT_GUARD_BAND_LOWER_$i    INTEGER              0
   set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i    DISPLAY_NAME         "Lower guard band for colour $i"
   set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i    HDL_PARAMETER        true
   set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i    AFFECTS_ELABORATION  false
   
   add_parameter           OUTPUT_GUARD_BAND_UPPER_$i    INTEGER              255
   set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i    DISPLAY_NAME         "Upper guard band for colour $i"
   set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i    HDL_PARAMETER        true
   set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i    AFFECTS_ELABORATION  false

}

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Pipeline dout ready signals"
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        true

# Add parameters for the data and command Avalon-ST message ports
add_av_st_event_parameters

add_parameter           SOURCE_ID                     INTEGER              0
set_parameter_property  SOURCE_ID                     DISPLAY_NAME         "Output source ID"
set_parameter_property  SOURCE_ID                     HDL_PARAMETER        true
set_parameter_property  SOURCE_ID                     AFFECTS_ELABORATION  true


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc gb_validation_callback {} {
  
   set   task_width  [get_parameter_value TASK_WIDTH]
   if {$task_width < 2} {
      if { [get_parameter_value ENABLE_CMD_PORT] > 0 } {
         send_message Error "Task ID Width for the command interface must be at least 2 bits"
      }
   }	
   
   set   num_colours [get_parameter_value NUMBER_OF_COLOR_PLANES]
   if { [get_parameter_value IS_422] > 0 } {
      if { $num_colours > 3 } {
         send_message Error "In 4:2:2 mode the maximum number of colour planes is 3"
      }
      if { $num_colours < 2 } {
         send_message Error "In 4:2:2 mode there must be a mimimum of 2 colour planes"
      }
      set   num_colours [expr $num_colours + 1]
   }
   
   set limit [get_parameter_value BITS_PER_SYMBOL]
   set limit [expr {pow(2, $limit)}]
   set limit [expr {$limit - 1}]
   for { set i 0 } { $i < 4} { incr i } {
      if { $i <  $num_colours } {
         set   lower_value [get_parameter_value OUTPUT_GUARD_BAND_LOWER_$i]
         set   upper_value [get_parameter_value OUTPUT_GUARD_BAND_UPPER_$i]
         if { $upper_value > $limit } {
            send_message Error "Upper guard band value for colour $i is outside of the range supported by the current bits per symbol"
         }
         if { $lower_value >= $upper_value } {
            send_message Error "Lower guard band value for colour $i must be less than the upper guard band value"
         }
         set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i VISIBLE  true
         set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i VISIBLE  true
      } else {
         set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i VISIBLE  false
         set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i VISIBLE  false
      }
   }
}



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
proc gb_elaboration_callback {} {

   if { [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] == 1 } {
      set   are_in_par        1
   } else {
      set   are_in_par        0
   }
   set   bps                  [get_parameter_value BITS_PER_SYMBOL]
   set   num_colours          [get_parameter_value NUMBER_OF_COLOR_PLANES]
   if { $are_in_par } {
      set   data_width        [expr $bps * $num_colours]
      set   pip               [get_parameter_value PIXELS_IN_PARALLEL]
   } else {
      set   data_width        $bps
      set   pip               1 
   }

   set   src_width            [get_parameter_value SRC_WIDTH]
   set   dst_width            [get_parameter_value DST_WIDTH]
   set   context_width        [get_parameter_value CONTEXT_WIDTH]
   set   task_width           [get_parameter_value TASK_WIDTH]
   set   src_id               [get_parameter_value SOURCE_ID]

   if { [get_parameter_value ENABLE_CMD_PORT] > 0 } {
      add_av_st_cmd_sink_port av_st_cmd                     1     $dst_width   $src_width   $task_width  $context_width       main_clock  $src_id
   }

   add_av_st_data_sink_port   av_st_din      $data_width    $pip  $dst_width   $src_width   $task_width  $context_width   0   main_clock  $src_id
   add_av_st_data_source_port av_st_dout     $data_width    $pip  $dst_width   $src_width   $task_width  $context_width   0   main_clock  $src_id

}
