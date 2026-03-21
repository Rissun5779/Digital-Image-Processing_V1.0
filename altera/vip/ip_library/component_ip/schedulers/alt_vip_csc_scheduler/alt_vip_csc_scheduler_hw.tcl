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

# ------------------------------------------------------------------------------------------------------------
# --                                                                                                        --
# -- General information for the CSC scheduler module                                                       --
# --                                                                                                        --
# ------------------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property  NAME                    alt_vip_csc_scheduler
set_module_property  DISPLAY_NAME            "CSC Scheduler"
set_module_property  DESCRIPTION             "Optional scheduler for the CSC. Used for user-packet support and coefficient updates at run-time"
set_module_property  ELABORATION_CALLBACK    elaboration_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files                 ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files     ../../..
add_static_sv_file                           src_hdl/alt_vip_csc_scheduler.sv
add_static_misc_file                         src_hdl/alt_vip_csc_scheduler.ocp

setup_filesets                               alt_vip_csc_scheduler

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_parameter           COEFF_WIDTH          INTEGER                 9 
set_parameter_property  COEFF_WIDTH          DISPLAY_NAME            "Coefficient width"
set_parameter_property  COEFF_WIDTH          DESCRIPTION             "Specifies the number of bits for the fixed point type used to represent the coefficients."
set_parameter_property  COEFF_WIDTH          ALLOWED_RANGES          0:32
set_parameter_property  COEFF_WIDTH          HDL_PARAMETER           true
set_parameter_property  COEFF_WIDTH          AFFECTS_ELABORATION     true

add_parameter           PIPELINE_READY       INTEGER                 1 
set_parameter_property  PIPELINE_READY       DISPLAY_NAME            "Pipeline ready"
set_parameter_property  PIPELINE_READY       DESCRIPTION             "Adds an extra stage of pipelining to the Av-ST Ready signals"
set_parameter_property  PIPELINE_READY       ALLOWED_RANGES          0:1
set_parameter_property  PIPELINE_READY       AFFECTS_ELABORATION     false
set_parameter_property  PIPELINE_READY       HDL_PARAMETER           true
set_parameter_property  PIPELINE_READY       DISPLAY_HINT            boolean

# adds USER_PACKET_SUPPORT but not USER_PACKET_FIFO_DEPTH
add_user_packet_support_parameters           PASSTHROUGH             0

# adds RUNTIME_CONTROL and LIMITED_READBACK
add_runtime_control_parameters               1

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

proc elaboration_cb {} {

   set   user_packet_support     [get_parameter_value USER_PACKET_SUPPORT]
   set   runtime_control         [get_parameter_value RUNTIME_CONTROL]
   set   src_width               8
   set   dst_width               8
   set   context_width           8
   set   task_width              8

   set   user_packet_passthrough [ expr [string equal $user_packet_support "PASSTHROUGH"] ]
   set   user_packet_enabled     [ expr ![string equal $user_packet_support "NONE_ALLOWED"] ]

   add_av_st_resp_sink_port      av_st_resp_vib      1   $dst_width   $src_width   $task_width   $context_width   main_clock   0
   add_av_st_cmd_source_port     av_st_cmd_vob       1   $dst_width   $src_width   $task_width   $context_width   main_clock   0
   if { $user_packet_enabled } {
      add_av_st_cmd_source_port  av_st_cmd_vib       1   $dst_width   $src_width   $task_width   $context_width   main_clock   0
   }
   if { $user_packet_passthrough}  {
      add_av_st_cmd_source_port  av_st_cmd_mux       1   $dst_width   $src_width   $task_width   $context_width   main_clock   0
   }

   if { $runtime_control } {
      set   addr_width  4
      set   num_reg     16    
      set   coeff_width [get_parameter_value COEFF_WIDTH]

      add_control_slave_port     av_mm_control     $addr_width       $num_reg    0           1           1              1  main_clock
      add_av_st_resp_sink_port   av_st_resp_ac                    1  $dst_width  $src_width  $task_width $context_width    main_clock  0
      add_av_st_data_source_port av_st_coeff       $coeff_width   1  $dst_width  $src_width  $task_width $context_width 0  main_clock  0
      add_av_st_cmd_source_port  av_st_cmd_ac                     1  $dst_width  $src_width  $task_width $context_width    main_clock  0
   }
}
