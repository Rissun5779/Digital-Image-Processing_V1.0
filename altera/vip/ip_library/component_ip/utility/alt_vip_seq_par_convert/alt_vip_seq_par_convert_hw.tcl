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
set_module_property NAME alt_vip_seq_par_convert
set_module_property DISPLAY_NAME "Symbols in sequence/parallel converter"
set_module_property ELABORATION_CALLBACK seq_par_elab_callback

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files  ../../..
add_alt_vip_common_event_packet_encode_files  ../../..
add_alt_vip_common_seq_par_convert_files      ../../..
add_static_sv_file src_hdl/alt_vip_seq_par_convert.sv

setup_filesets alt_vip_seq_par_convert

add_bits_per_symbol_parameters                        4  20

add_channels_nb_parameters 
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  VISIBLE              false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false

add_parameter           SEQUENCE_IN                   INTEGER              0
set_parameter_property  SEQUENCE_IN                   DISPLAY_NAME         "Input symbols in sequence"
set_parameter_property  SEQUENCE_IN                   DESCRIPTION          ""
set_parameter_property  SEQUENCE_IN                   ALLOWED_RANGES       0:1
set_parameter_property  SEQUENCE_IN                   AFFECTS_ELABORATION  true
set_parameter_property  SEQUENCE_IN                   HDL_PARAMETER        true
set_parameter_property  SEQUENCE_IN                   DISPLAY_HINT         boolean

add_parameter           NUM_KERNEL_LINES              INTEGER              1
set_parameter_property  NUM_KERNEL_LINES              DISPLAY_NAME         "Number of kernel lines (for use with line buffers)"
set_parameter_property  NUM_KERNEL_LINES              DESCRIPTION          ""
set_parameter_property  NUM_KERNEL_LINES              ALLOWED_RANGES       1:32
set_parameter_property  NUM_KERNEL_LINES              AFFECTS_ELABORATION  true
set_parameter_property  NUM_KERNEL_LINES              HDL_PARAMETER        true

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Register Avalon-ST ready signals"
set_parameter_property  PIPELINE_READY                DESCRIPTION          ""
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean

add_av_st_event_parameters

add_main_clock_port

proc seq_par_elab_callback {} {

   set   src_width         [get_parameter_value SRC_WIDTH]
   set   dst_width         [get_parameter_value DST_WIDTH]
   set   context_width     [get_parameter_value CONTEXT_WIDTH]
   set   task_width        [get_parameter_value TASK_WIDTH]

   set   num_colours       [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   bps               [get_parameter_value BITS_PER_SYMBOL]
   set   num_lines         [get_parameter_value NUM_KERNEL_LINES]
   if { [get_parameter_value SEQUENCE_IN] > 0 } {
      set data_width_in    [expr $bps * $num_lines]
      set data_width_out   [expr $bps * $num_colours * $num_lines]
   } else {
      set data_width_out   [expr $bps * $num_lines]
      set data_width_in    [expr $bps * $num_colours * $num_lines]
   }

   add_av_st_data_sink_port   av_st_din            $data_width_in          1  $dst_width  $src_width  $task_width $context_width    0  main_clock  0
   add_av_st_data_source_port av_st_dout           $data_width_out         1  $dst_width  $src_width  $task_width $context_width    0  main_clock  0
}
