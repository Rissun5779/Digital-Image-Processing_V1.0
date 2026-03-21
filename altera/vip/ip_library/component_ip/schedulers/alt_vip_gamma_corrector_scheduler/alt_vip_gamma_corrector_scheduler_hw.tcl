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


source   ../../../common_tcl/alt_vip_helper_common.tcl
source   ../../../common_tcl/alt_vip_files_common.tcl
source   ../../../common_tcl/alt_vip_parameters_common.tcl
source   ../../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP components 
declare_general_component_info

set_module_property  NAME                 alt_vip_gamma_corrector_scheduler
set_module_property  DISPLAY_NAME         "Gamma Corrector Scheduler"
set_module_property  ELABORATION_CALLBACK elaboration_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

add_alt_vip_common_pkg_files                 ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files     ../../..

add_static_sv_file   src_hdl/alt_vip_gamma_corrector_scheduler.sv
add_static_misc_file src_hdl/alt_vip_gamma_corrector_scheduler.ocp

setup_filesets alt_vip_gamma_corrector_scheduler

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# -------------------------------------------------------------------------------------------------- 

add_in_out_bits_per_symbol_parameters                 4  16

add_channels_nb_parameters 
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  VISIBLE              false

add_parameter           ENABLE_TWO_BANKS              INTEGER              0
set_parameter_property  ENABLE_TWO_BANKS              DISPLAY_NAME         "Enable 2 banks of LUT coefficients"
set_parameter_property  ENABLE_TWO_BANKS              ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_TWO_BANKS              DISPLAY_HINT         boolean
set_parameter_property  ENABLE_TWO_BANKS              HDL_PARAMETER        true
set_parameter_property  ENABLE_TWO_BANKS              AFFECTS_ELABORATION  true

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Pipeline Av-ST ready signals"
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION  false

add_runtime_control_parameters                        1

add_user_packet_support_parameters
set_parameter_property  USER_PACKET_FIFO_DEPTH        HDL_PARAMETER        false
set_parameter_property  USER_PACKET_FIFO_DEPTH        VISIBLE              false

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_main_clock_port

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc elaboration_callback {} {

   set   control_exists       [get_parameter_value RUNTIME_CONTROL]
   set   comp                 [get_parameter_value USER_PACKET_SUPPORT]
   set   match                [string compare   $comp PASSTHROUGH]
   if { $match == 0 } {
      set   user_pass         1
      set   use_vib_cmd       1
   } else {
      set   user_pass         0
      set   match             [string compare   $comp DISCARD]
      if { $match == 0 } {
         set   use_vib_cmd    1
      } else {
         set   use_vib_cmd    0
      }
   }
   
   add_av_st_resp_sink_port    av_st_resp_vib      1   8   8   8   8   main_clock   0
   if { $use_vib_cmd > 0 } {
      add_av_st_cmd_source_port   av_st_cmd_vib    1   8   8   8   8   main_clock   0
   }
   if { $user_pass > 0 } {
      add_av_st_cmd_source_port   av_st_cmd_mux    1   8   8   8   8   main_clock   0
   } 
   add_av_st_cmd_source_port   av_st_cmd_vob       1   8   8   8   8   main_clock   0

   if { $control_exists > 0 } {

      set   mem_size_per_colour  1
      set   in_bps               [get_parameter_value INPUT_BITS_PER_SYMBOL]
      set   out_bps              [get_parameter_value OUTPUT_BITS_PER_SYMBOL]
      set   num_colours          [get_parameter_value NUMBER_OF_COLOR_PLANES]
      for { set i 0 } { $i < $in_bps } { incr i } {  
         set   mem_size_per_colour  [expr 2 * $mem_size_per_colour]
      }
      if { [get_parameter_value ENABLE_TWO_BANKS] > 0 } {
         set   coeff_addr_space   [expr 2 * $mem_size_per_colour * $num_colours]
      } else {
         set   coeff_addr_space   [expr $mem_size_per_colour * $num_colours]
      }
      set   coeff_addr_width  [clogb2_pure $coeff_addr_space]
      set   coeff_data_width  [expr $out_bps + $coeff_addr_width]
      set   num_reg           [expr 6 + $mem_size_per_colour]
      set   addr_width        [clogb2_pure $num_reg] 

      add_av_st_resp_sink_port    av_st_resp_ac       1   8   8   8   8   main_clock   0
      add_av_st_cmd_source_port   av_st_cmd_ac        1   8   8   8   8   main_clock   0
      add_av_st_data_source_port  av_st_coeff_ac $coeff_data_width 1        8  8  8  8  0  main_clock   0
      add_control_slave_port      av_mm_control  $addr_width       $num_reg 0  1  1  1     main_clock
   }
    
}
