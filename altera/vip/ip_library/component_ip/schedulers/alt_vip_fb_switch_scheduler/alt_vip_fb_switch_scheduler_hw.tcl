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

declare_general_component_info
set_module_property NAME alt_vip_fb_switch_scheduler
set_module_property DISPLAY_NAME "Frame Buffer Shuffle Scheduer"
set_module_property ELABORATION_CALLBACK fbs_elab_callback

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files  ../../..
add_alt_vip_common_event_packet_encode_files  ../../..
add_static_sv_file src_hdl/alt_vip_fb_switch_scheduler_vib_sm.sv
add_static_sv_file src_hdl/alt_vip_fb_switch_scheduler_vob_sm.sv
add_static_sv_file src_hdl/alt_vip_fb_switch_scheduler_top_sm.sv
add_static_sv_file src_hdl/alt_vip_fb_switch_scheduler.sv

setup_filesets alt_vip_fb_switch_scheduler

add_parameter PIPELINE_READY INTEGER 0
set_parameter_property PIPELINE_READY DISPLAY_NAME "Register Avalon-ST ready signals"
set_parameter_property PIPELINE_READY DESCRIPTION ""
set_parameter_property PIPELINE_READY ALLOWED_RANGES 0:1
set_parameter_property PIPELINE_READY AFFECTS_ELABORATION false
set_parameter_property PIPELINE_READY HDL_PARAMETER true
set_parameter_property PIPELINE_READY DISPLAY_HINT boolean

add_main_clock_port

proc fbs_elab_callback {} {

   add_control_slave_port     av_mm_control           3  6  0  1  1  1  main_clock
   
   add_av_st_cmd_sink_port    av_st_in_vib_resp       1  8  8  8  8     main_clock  0
   add_av_st_cmd_sink_port    av_st_other_vib_resp    1  8  8  8  8     main_clock  0
   add_av_st_cmd_sink_port    av_st_fb_vib_resp       1  8  8  8  8     main_clock  0
   
   add_av_st_cmd_source_port  av_st_in_vib_cmd        1  8  8  8  8     main_clock  0
   add_av_st_cmd_source_port  av_st_other_vib_cmd     1  8  8  8  8     main_clock  0
   add_av_st_cmd_source_port  av_st_fb_vib_cmd        1  8  8  8  8     main_clock  0
   add_av_st_cmd_source_port  av_st_other_vob_cmd     1  8  8  8  8     main_clock  0
   add_av_st_cmd_source_port  av_st_fb_vob_cmd        1  8  8  8  8     main_clock  0
   add_av_st_cmd_source_port  av_st_out_vob_cmd       1  8  8  8  8     main_clock  0
   add_av_st_cmd_source_port  av_st_other_pm_cmd      1  8  8  8  8     main_clock  0
   add_av_st_cmd_source_port  av_st_fb_pm_cmd         1  8  8  8  8     main_clock  0
   add_av_st_cmd_source_port  av_st_out_pm_cmd        1  8  8  8  8     main_clock  0

}
