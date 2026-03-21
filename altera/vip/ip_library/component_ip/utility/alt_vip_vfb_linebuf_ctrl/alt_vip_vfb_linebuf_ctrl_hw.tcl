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

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information for the alt_vip_vfb_linebuf_ctrl module                                     --
# -- This block sequences frames for reading and writing by the wr_ctrl and rd_ctrl blocks        --
# -- and tracks buffer contents.                                                                  --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_vfb_linebuf_ctrl
set_module_property DISPLAY_NAME "Line-based Frame Buffer Controller"
set_module_property Description  "Controls frame buffer read and write sequencing"

set_module_property ELABORATION_CALLBACK linebuf_ctrl_elaboration_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_vfb_linebuf_ctrl.sv

add_static_misc_file src_hdl/alt_vip_vfb_linebuf_ctrl.ocp

setup_filesets alt_vip_vfb_linebuf_ctrl

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Add parameters for the Avalon-ST message ports
add_av_st_event_parameters

add_bits_per_symbol_parameters
add_channels_nb_parameters
add_pixels_in_parallel_parameters
add_max_dim_parameters

add_parameter           FRAME_BUFFER_LENGTH         INTEGER             0
set_parameter_property  FRAME_BUFFER_LENGTH         DISPLAY_NAME        "Offset between frames"
set_parameter_property  FRAME_BUFFER_LENGTH         DESCRIPTION         "Offset between start of frame buffers in memory in bytes"
set_parameter_property  FRAME_BUFFER_LENGTH         HDL_PARAMETER       true
set_parameter_property  FRAME_BUFFER_LENGTH         AFFECTS_ELABORATION false

add_parameter           ANC_BUFFER_LENGTH           INTEGER             0
set_parameter_property  ANC_BUFFER_LENGTH           DISPLAY_NAME        "Offset between ancillary packet buffers"
set_parameter_property  ANC_BUFFER_LENGTH           DESCRIPTION         "Offset between start of ancillary packet buffers in memory in bytes"
set_parameter_property  ANC_BUFFER_LENGTH           HDL_PARAMETER       true
set_parameter_property  ANC_BUFFER_LENGTH           AFFECTS_ELABORATION false

add_parameter           DROP_FRAMES                 INTEGER             1
set_parameter_property  DROP_FRAMES                 DISPLAY_NAME        "Frame dropping"
set_parameter_property  DROP_FRAMES                 ALLOWED_RANGES      0:1
set_parameter_property  DROP_FRAMES                 DISPLAY_HINT        boolean
set_parameter_property  DROP_FRAMES                 DESCRIPTION         "Enable dropping of frames"
set_parameter_property  DROP_FRAMES                 HDL_PARAMETER       true
set_parameter_property  DROP_FRAMES                 ENABLED             true
set_parameter_property  DROP_FRAMES                 AFFECTS_ELABORATION true

add_parameter           REPEAT_FRAMES               INTEGER             1
set_parameter_property  REPEAT_FRAMES               DISPLAY_NAME        "Frame repeating"
set_parameter_property  REPEAT_FRAMES               ALLOWED_RANGES      0:1
set_parameter_property  REPEAT_FRAMES               DISPLAY_HINT        boolean
set_parameter_property  REPEAT_FRAMES               DESCRIPTION         "Enable repetition of frames"
set_parameter_property  REPEAT_FRAMES               HDL_PARAMETER       true
set_parameter_property  REPEAT_FRAMES               ENABLED             true
set_parameter_property  REPEAT_FRAMES               AFFECTS_ELABORATION true

add_parameter           DROP_REPEAT_USER            INTEGER             0
set_parameter_property  DROP_REPEAT_USER            DISPLAY_NAME        "Drop/repeat user packets"
set_parameter_property  DROP_REPEAT_USER            ALLOWED_RANGES      0:1
set_parameter_property  DROP_REPEAT_USER            DISPLAY_HINT        boolean
set_parameter_property  DROP_REPEAT_USER            DESCRIPTION         "Enable dropping and repeating of user packets when associated frames are dropped/repeated"
set_parameter_property  DROP_REPEAT_USER            HDL_PARAMETER       true
set_parameter_property  DROP_REPEAT_USER            AFFECTS_ELABORATION true

add_parameter           MEM_BASE_ADDR               INTEGER             0
set_parameter_property  MEM_BASE_ADDR               DISPLAY_NAME        "Frame Buffer base address"
set_parameter_property  MEM_BASE_ADDR               DESCRIPTION         "The base address for the frame buffer on Avalon-MM memory master port"
set_parameter_property  MEM_BASE_ADDR               HDL_PARAMETER       true
set_parameter_property  MEM_BASE_ADDR               AFFECTS_ELABORATION true
set_parameter_property  MEM_BASE_ADDR               VISIBLE             false
 
add_user_packets_mem_storage_parameters
set_parameter_property  USER_PACKETS_MAX_STORAGE    DISPLAY_NAME        "Maximum ancillary packets per frame"
set_parameter_property  MAX_SYMBOLS_PER_PACKET      DISPLAY_NAME        "Maximum length ancillary packet in symbols"


add_parameter           DROP_INVALID_FIELDS         INTEGER             1
set_parameter_property  DROP_INVALID_FIELDS         DISPLAY_NAME        "Drop invalid frames"
set_parameter_property  DROP_INVALID_FIELDS         ALLOWED_RANGES      0:1
set_parameter_property  DROP_INVALID_FIELDS         DISPLAY_HINT        boolean
set_parameter_property  DROP_INVALID_FIELDS         DESCRIPTION         "Enable dropping of frames with invalid dimensions"
set_parameter_property  DROP_INVALID_FIELDS         HDL_PARAMETER       true
set_parameter_property  DROP_INVALID_FIELDS         ENABLED             true
set_parameter_property  DROP_INVALID_FIELDS         AFFECTS_ELABORATION true


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
proc linebuf_ctrl_validation_callback {} {
   
#todo
}

# Line based buffer always has write side control only
proc linebuf_ctrl_elaboration_callback {} {
    set src_width           [get_parameter_value SRC_WIDTH]
    set dst_width           [get_parameter_value DST_WIDTH]
    set context_width       [get_parameter_value CONTEXT_WIDTH]
    set task_width          [get_parameter_value TASK_WIDTH]

    set bits_per_symbol                 [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes          [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set color_planes_are_in_parallel    [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel              [get_parameter_value PIXELS_IN_PARALLEL]

    if {$color_planes_are_in_parallel} {
        set data_width          [expr $bits_per_symbol * $number_of_color_planes]
    } else {
        set data_width          [expr $bits_per_symbol]
    }

    # writer_control interface
    set ctrl_depth        16
    set ctrl_addr_width   4

    #add_slave_port writer_control 32 $ctrl_addr_width $ctrl_depth $is_frame_writer 2 1 main_clock
    add_control_slave_port writer_control $ctrl_addr_width $ctrl_depth 0 2 1 1 main_clock

    # vib interface: data input, resp input and cmd output
    add_av_st_cmd_source_port  vib_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_resp_sink_port   vib_resp 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    
    # Line statistics block response interface :
    add_av_st_resp_sink_port   line_stats_resp 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

    # packet transfer interface: data output and cmd output and resp input
    add_av_st_cmd_source_port  pkt_wr_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_resp_sink_port   pkt_wr_resp 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

    # packet transfer interface: data input and cmd output
    add_av_st_cmd_source_port  pkt_rd_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

    # vob interface: data output & cmd output
    add_av_st_cmd_source_port  vob_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

}