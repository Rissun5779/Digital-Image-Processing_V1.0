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
# -- General information for the gaurd band scheduler module                                                       --
# --                                                                                                        --
# ------------------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property  NAME                    alt_vip_guard_bands_scheduler
set_module_property  DISPLAY_NAME            "Gaurd Band Scheduler"
set_module_property  DESCRIPTION             "Optional scheduler for the Gaurd Band VIP core. Used for user-packet support and min/max updates at run-time"
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
add_static_sv_file                           src_hdl/alt_vip_guard_bands_scheduler.sv
add_static_misc_file                         src_hdl/alt_vip_guard_bands_scheduler.ocp

setup_filesets                               alt_vip_guard_bands_scheduler

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_bits_per_symbol_parameters                        4  20

add_channels_nb_parameters 
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  VISIBLE        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER  false

add_parameter           LOWER_0              INTEGER                 0 
set_parameter_property  LOWER_0              DISPLAY_NAME            "Lower guard band 0"
set_parameter_property  LOWER_0              DESCRIPTION             ""
set_parameter_property  LOWER_0              HDL_PARAMETER           true
set_parameter_property  LOWER_0              AFFECTS_ELABORATION     false

add_parameter           UPPER_0              INTEGER                 255 
set_parameter_property  UPPER_0              DISPLAY_NAME            "Upper guard band 0"
set_parameter_property  UPPER_0              DESCRIPTION             ""
set_parameter_property  UPPER_0              HDL_PARAMETER           true
set_parameter_property  UPPER_0              AFFECTS_ELABORATION     false

add_parameter           LOWER_1              INTEGER                 0 
set_parameter_property  LOWER_1              DISPLAY_NAME            "Lower guard band 0"
set_parameter_property  LOWER_1              DESCRIPTION             ""
set_parameter_property  LOWER_1              HDL_PARAMETER           true
set_parameter_property  LOWER_1              AFFECTS_ELABORATION     false

add_parameter           UPPER_1              INTEGER                 255 
set_parameter_property  UPPER_1              DISPLAY_NAME            "Upper guard band 0"
set_parameter_property  UPPER_1              DESCRIPTION             ""
set_parameter_property  UPPER_1              HDL_PARAMETER           true
set_parameter_property  UPPER_1              AFFECTS_ELABORATION     false

add_parameter           LOWER_2              INTEGER                 0 
set_parameter_property  LOWER_2              DISPLAY_NAME            "Lower guard band 0"
set_parameter_property  LOWER_2              DESCRIPTION             ""
set_parameter_property  LOWER_2              HDL_PARAMETER           true
set_parameter_property  LOWER_2              AFFECTS_ELABORATION     false

add_parameter           UPPER_2              INTEGER                 255 
set_parameter_property  UPPER_2              DISPLAY_NAME            "Upper guard band 0"
set_parameter_property  UPPER_2              DESCRIPTION             ""
set_parameter_property  UPPER_2              HDL_PARAMETER           true
set_parameter_property  UPPER_2              AFFECTS_ELABORATION     false

add_parameter           LOWER_3              INTEGER                 0 
set_parameter_property  LOWER_3              DISPLAY_NAME            "Lower guard band 0"
set_parameter_property  LOWER_3              DESCRIPTION             ""
set_parameter_property  LOWER_3              HDL_PARAMETER           true
set_parameter_property  LOWER_3              AFFECTS_ELABORATION     false

add_parameter           UPPER_3              INTEGER                 255 
set_parameter_property  UPPER_3              DISPLAY_NAME            "Upper guard band 0"
set_parameter_property  UPPER_3              DESCRIPTION             ""
set_parameter_property  UPPER_3              HDL_PARAMETER           true
set_parameter_property  UPPER_3              AFFECTS_ELABORATION     false

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
      set   number_of_colours [get_parameter_value NUMBER_OF_COLOR_PLANES]
      set   num_reg     [expr 2*$number_of_colours + 3]   

      add_control_slave_port     av_mm_control     $addr_width       $num_reg    0           1           1              1  main_clock
      add_av_st_cmd_source_port  av_st_cmd_ac                     1  $dst_width  $src_width  $task_width $context_width    main_clock  0
   }
}
