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

# ------------------------------------------------------------------------------------------------------------
# --                                                                                                        --
# -- General information for the interlacer scheduler module                                                       --
# --                                                                                                        --
# ------------------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_interlacer_scheduler
set_module_property DISPLAY_NAME "Interlacer Scheduler"
set_module_property DESCRIPTION "Scheduler for the interlacer"

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files ../../..

add_static_sv_file src_hdl/alt_vip_interlacer_scheduler.sv

add_static_misc_file src_hdl/alt_vip_interlacer_scheduler.ocp

setup_filesets alt_vip_interlacer_scheduler

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Elaboration callback to set up the dynamic ports
set_module_property  ELABORATION_CALLBACK elaboration_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_parameter          INTERLACE_PASSTHROUGH INTEGER 1
set_parameter_property INTERLACE_PASSTHROUGH DISPLAY_NAME "Enable interlace passthrough"
set_parameter_property INTERLACE_PASSTHROUGH ALLOWED_RANGES 0:1
set_parameter_property INTERLACE_PASSTHROUGH DISPLAY_HINT boolean
set_parameter_property INTERLACE_PASSTHROUGH DESCRIPTION "Enables passthrough of interlaced data received at the input, otherwise interlaced input is discarded. If runtime control is enabled this parameter sets the default value used at startup, but may be overridden via the control interface to enable/disable interlace passthrough as required."
set_parameter_property INTERLACE_PASSTHROUGH HDL_PARAMETER true
set_parameter_property INTERLACE_PASSTHROUGH AFFECTS_ELABORATION false

add_parameter          SEND_F1_FIRST INTEGER 1
set_parameter_property SEND_F1_FIRST DISPLAY_NAME "Send F1 first"
set_parameter_property SEND_F1_FIRST ALLOWED_RANGES 0:1
set_parameter_property SEND_F1_FIRST DISPLAY_HINT boolean
set_parameter_property SEND_F1_FIRST DESCRIPTION "Controls whether F0 or F1 is sent first when interlacing a progressive input. If runtime control is enabled this parameter sets the default value used at startup, but may be overridden via the control interface to allow F0 or F1 to be send first as required."
set_parameter_property SEND_F1_FIRST HDL_PARAMETER true
set_parameter_property SEND_F1_FIRST AFFECTS_ELABORATION false

add_parameter          CTRL_OVERRIDE INTEGER 1
set_parameter_property CTRL_OVERRIDE DISPLAY_NAME "Enable control packet override"
set_parameter_property CTRL_OVERRIDE ALLOWED_RANGES 0:1
set_parameter_property CTRL_OVERRIDE DISPLAY_HINT boolean
set_parameter_property CTRL_OVERRIDE DESCRIPTION "Enabling this feature allows the input control packet to override the default selection of F0 or F1 for the next output field if the control packet states that the input progressive frame was created by deinterlacing an F0 or F1 field earlier in the pipeline. If runtime control is enabled this parameter sets the default value used at startup, but may be overridden via the control interface to enable/disable control packet override as required."
set_parameter_property CTRL_OVERRIDE HDL_PARAMETER true
set_parameter_property CTRL_OVERRIDE AFFECTS_ELABORATION false

add_parameter          MAX_HEIGHT INTEGER 1080
set_parameter_property MAX_HEIGHT DISPLAY_NAME "Maximum Picture Height"
set_parameter_property MAX_HEIGHT ALLOWED_RANGES 32:$vipsuite_max_height
set_parameter_property MAX_HEIGHT DESCRIPTION "Defines the maximum number of lines per progressive frame at the input"
set_parameter_property MAX_HEIGHT HDL_PARAMETER true
set_parameter_property MAX_HEIGHT AFFECTS_ELABORATION false

add_parameter           PIPELINE_READY INTEGER              0
set_parameter_property  PIPELINE_READY ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY DISPLAY_NAME         "Pipeline Av-ST ready signals"

# adds RUNTIME_CONTROL and LIMITED_READBACK
add_runtime_control_parameters 1

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

   set control_exists [get_parameter_value RUNTIME_CONTROL]
   set num_reg     4
   set addr_width  2 
   
   add_av_st_resp_sink_port    av_st_resp_vib      1   8   8   8   8   main_clock   0
   add_av_st_cmd_source_port   av_st_cmd_vib       1   8   8   8   8   main_clock   0
   add_av_st_cmd_source_port   av_st_cmd_vob       1   8   8   8   8   main_clock   0

   if { $control_exists > 0 } {
      add_control_slave_port   av_mm_control   $addr_width   $num_reg   0   1   1   1   main_clock
   }
}
