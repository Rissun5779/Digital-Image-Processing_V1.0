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

declare_general_component_info
set_module_property  NAME                 alt_vip_fir_scheduler
set_module_property  DISPLAY_NAME         "FIR Scheduler"
set_module_property  ELABORATION_CALLBACK fir_elaboration_callback
set_module_property  VALIDATION_CALLBACK  fir_validation_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

add_alt_vip_common_pkg_files                       ../../..
add_alt_vip_common_event_packet_decode_files       ../../..
add_alt_vip_common_event_packet_encode_files       ../../..
add_alt_vip_common_slave_interface_files           ../../..
add_static_sv_file src_hdl/alt_vip_fir_scheduler.sv

add_static_misc_file src_hdl/alt_vip_fir_scheduler.ocp

setup_filesets alt_vip_fir_scheduler

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# -------------------------------------------------------------------------------------------------- 
set   x_max $vipsuite_max_width
set   y_max $vipsuite_max_height

add_max_dim_parameters  32 $x_max   32 $y_max
set_parameter_property  MAX_WIDTH               AFFECTS_ELABORATION  false
set_parameter_property  MAX_HEIGHT              AFFECTS_ELABORATION  false

add_bits_per_symbol_parameters
set_parameter_property  BITS_PER_SYMBOL         AFFECTS_ELABORATION  false

add_parameter           EDGE_ADAPTIVE_SHARPEN   INTEGER              1
set_parameter_property  EDGE_ADAPTIVE_SHARPEN   DISPLAY_NAME         "Use edge adaptive sharpen mode"
set_parameter_property  EDGE_ADAPTIVE_SHARPEN   ALLOWED_RANGES       0:1
set_parameter_property  EDGE_ADAPTIVE_SHARPEN   AFFECTS_ELABORATION  true
set_parameter_property  EDGE_ADAPTIVE_SHARPEN   HDL_PARAMETER        true
set_parameter_property  EDGE_ADAPTIVE_SHARPEN   DISPLAY_HINT         boolean

add_parameter           DEFAULT_SEARCH_RANGE    INTEGER              15
set_parameter_property  DEFAULT_SEARCH_RANGE    DISPLAY_NAME         "Default search range enable value"
set_parameter_property  DEFAULT_SEARCH_RANGE    ALLOWED_RANGES       0:15
set_parameter_property  DEFAULT_SEARCH_RANGE    AFFECTS_ELABORATION  false
set_parameter_property  DEFAULT_SEARCH_RANGE    HDL_PARAMETER        true

add_parameter           DEFAULT_UPPER_BLUR      INTEGER              15
set_parameter_property  DEFAULT_UPPER_BLUR      DISPLAY_NAME         "Default upper blur limit (per color plane)"
set_parameter_property  DEFAULT_UPPER_BLUR      AFFECTS_ELABORATION  false
set_parameter_property  DEFAULT_UPPER_BLUR      HDL_PARAMETER        true

add_parameter           DEFAULT_LOWER_BLUR      INTEGER              0
set_parameter_property  DEFAULT_LOWER_BLUR      DISPLAY_NAME         "Default lower blur limit (per color plane)"
set_parameter_property  DEFAULT_LOWER_BLUR      AFFECTS_ELABORATION  false
set_parameter_property  DEFAULT_LOWER_BLUR      HDL_PARAMETER        true

add_parameter           V_TAPS                  INTEGER              3
set_parameter_property  V_TAPS                  DISPLAY_NAME         "Vertical taps"
set_parameter_property  V_TAPS                  ALLOWED_RANGES       1:16
set_parameter_property  V_TAPS                  AFFECTS_ELABORATION  false
set_parameter_property  V_TAPS                  HDL_PARAMETER        true

add_parameter           UPDATE_TAPS             INTEGER              9
set_parameter_property  UPDATE_TAPS             DISPLAY_NAME         "Length of coefficient packet from runtime update"
set_parameter_property  UPDATE_TAPS             ALLOWED_RANGES       1:257
set_parameter_property  UPDATE_TAPS             AFFECTS_ELABORATION  true
set_parameter_property  UPDATE_TAPS             HDL_PARAMETER        true

add_parameter           COEFF_WIDTH             INTEGER              9
set_parameter_property  COEFF_WIDTH             DISPLAY_NAME         "Width of coefficient data"
set_parameter_property  COEFF_WIDTH             ALLOWED_RANGES       1:32
set_parameter_property  COEFF_WIDTH             AFFECTS_ELABORATION  true
set_parameter_property  COEFF_WIDTH             HDL_PARAMETER        true

add_parameter           NO_BLANKING             INTEGER              0
set_parameter_property  NO_BLANKING             DISPLAY_NAME         "Video has no blanking"
set_parameter_property  NO_BLANKING             ALLOWED_RANGES       0:1
set_parameter_property  NO_BLANKING             AFFECTS_ELABORATION  false
set_parameter_property  NO_BLANKING             HDL_PARAMETER        true
set_parameter_property  NO_BLANKING             DISPLAY_HINT         boolean

add_parameter           PIPELINE_READY          INTEGER              0
set_parameter_property  PIPELINE_READY          DISPLAY_NAME         "Pipeline command interfaces"
set_parameter_property  PIPELINE_READY          ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY          AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY          HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY          DISPLAY_HINT         boolean

add_runtime_control_parameters                  1

add_user_packet_support_parameters              PASSTHROUGH          0

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameter legality checks (validation callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   

proc fir_validation_callback {} {

   if { [get_parameter_value EDGE_ADAPTIVE_SHARPEN] > 0 } {
   
      set  limit    [get_parameter_value BITS_PER_SYMBOL]
      set  limit    [expr {pow(2, $limit)}]
      set  limit    [expr {$limit - 1}]
      set  value    [get_parameter_value DEFAULT_LOWER_BLUR]
      if { $value > $limit } {
         send_message Error "The lower blur limit must be within the range supported by the selected value of input bits per symbol"
      }
      if { $value < 0 } {
         send_message Error "The lower blur limit must be greater than or equal to 0"
      }
      set  value    [get_parameter_value DEFAULT_UPPER_BLUR]
      if { $value > $limit } {
         send_message Error "The upper blur limit must be within the range supported by the selected value of input bits per symbol"
      }
      if { $value < 0 } {
         send_message Error "The upper blur limit must be greater than or equal to 0"
      }
   
   }

   if { [get_parameter_value NO_BLANKING] > 0 } {
      set   comp  [get_parameter_value USER_PACKET_SUPPORT]
      set   match [string compare   $comp PASSTHROUGH]
      if { $match == 0 } {
         send_message error   "User packet pass through cannot be supported for video with no blanking"
      }
   }

}

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

proc fir_elaboration_callback {} {

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
   
   add_av_st_resp_sink_port         av_st_resp_vib    1  8  8  8  8  main_clock   0
   add_av_st_resp_sink_port         av_st_resp_ac     1  8  8  8  8  main_clock   0
   if { $use_vib_cmd > 0 } {
      add_av_st_cmd_source_port     av_st_cmd_vib     1  8  8  8  8  main_clock   0
   }
   add_av_st_cmd_source_port        av_st_cmd_lb      1  8  8  8  8  main_clock   0
   add_av_st_cmd_source_port        av_st_cmd_ac      1  8  8  8  8  main_clock   0
   if { $user_pass > 0 } {
      add_av_st_cmd_source_port     av_st_cmd_mux     1  8  8  8  8  main_clock   0
   } 
   add_av_st_cmd_source_port        av_st_cmd_vob     1  8  8  8  8  main_clock   0

   if { $control_exists > 0 } {

      set   addr_width        9
      set   coeff_data_width  [get_parameter_value COEFF_WIDTH]
      if { [get_parameter_value EDGE_ADAPTIVE_SHARPEN] > 0 } {
      
         set   num_reg        7
         
      } else {
      
         set   num_reg        [expr 7 + [get_parameter_value UPDATE_TAPS]]
         
         add_av_st_data_source_port av_st_coeff       $coeff_data_width 1  8  8  8  8  0  main_clock  0
         
      }

      add_control_slave_port     av_mm_control  $addr_width       $num_reg 0  1  1  1     main_clock
   }

}
