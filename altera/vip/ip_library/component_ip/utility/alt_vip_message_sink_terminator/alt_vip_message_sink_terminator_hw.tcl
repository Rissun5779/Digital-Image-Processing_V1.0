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

set_module_property NAME alt_vip_message_sink_terminator
set_module_property DISPLAY_NAME "Avalon-ST Message sink terminator"
set_module_property ELABORATION_CALLBACK sink_elaboration_callback

add_static_sv_file src_hdl/alt_vip_message_sink_terminator.sv

setup_filesets alt_vip_message_sink_terminator

add_data_width_parameters
add_av_st_event_parameters
add_av_st_event_user_width_parameters

add_main_clock_port

proc sink_elaboration_callback {} {

  set dst_w                       [get_parameter_value DST_WIDTH]
  set src_w                       [get_parameter_value SRC_WIDTH]
  set task_w                      [get_parameter_value TASK_WIDTH]
  set ctxt_w                      [get_parameter_value CONTEXT_WIDTH]
  set user_w                      [get_parameter_value USER_WIDTH]
  
  set data_width                  [get_parameter_value DATA_WIDTH]
  
  add_av_st_data_sink_port   av_st_din   $data_width  1  $dst_w   $src_w   $task_w   $ctxt_w  $user_w  main_clock

}






