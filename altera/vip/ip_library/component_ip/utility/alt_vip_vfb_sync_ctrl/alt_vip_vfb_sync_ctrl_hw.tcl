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
# -- General information for the alt_vip_vfb_sync_ctrl module                                     --
# -- This block sequences frames for reading and writing by the wr_ctrl and rd_ctrl blocks        --
# -- and tracks buffer contents.                                                                  --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_vfb_sync_ctrl
set_module_property DISPLAY_NAME "Frame Buffer Sync Controller"
set_module_property Description  "Controls frame buffer read and write sequencing"

set_module_property ELABORATION_CALLBACK sync_ctrl_elaboration_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_vfb_sync_ctrl.sv

add_static_misc_file src_hdl/alt_vip_vfb_sync_ctrl.ocp

setup_filesets alt_vip_vfb_sync_ctrl

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Add parameters for the Avalon-ST message ports
add_av_st_event_parameters

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

add_max_dim_parameters

add_parameter           NUM_BUFFERS                 INTEGER             3
set_parameter_property  NUM_BUFFERS                 DISPLAY_NAME        "Number of frame buffers"
set_parameter_property  NUM_BUFFERS                 DESCRIPTION         "Total number of frame buffers required"
set_parameter_property  NUM_BUFFERS                 HDL_PARAMETER       true
set_parameter_property  NUM_BUFFERS                 AFFECTS_ELABORATION false

add_parameter           WRITER_RUNTIME_CONTROL      INTEGER             0
set_parameter_property  WRITER_RUNTIME_CONTROL      DISPLAY_NAME        "Run-time writer control"
set_parameter_property  WRITER_RUNTIME_CONTROL      ALLOWED_RANGES      0:1
set_parameter_property  WRITER_RUNTIME_CONTROL      DISPLAY_HINT        boolean
set_parameter_property  WRITER_RUNTIME_CONTROL      DESCRIPTION         "Enable run-time control of writer"
set_parameter_property  WRITER_RUNTIME_CONTROL      HDL_PARAMETER       true
set_parameter_property  WRITER_RUNTIME_CONTROL      ENABLED             true
set_parameter_property  WRITER_RUNTIME_CONTROL      AFFECTS_ELABORATION true

add_parameter           READER_RUNTIME_CONTROL      INTEGER             0
set_parameter_property  READER_RUNTIME_CONTROL      DISPLAY_NAME        "Run-time reader control"
set_parameter_property  READER_RUNTIME_CONTROL      ALLOWED_RANGES      0:1
set_parameter_property  READER_RUNTIME_CONTROL      DISPLAY_HINT        boolean
set_parameter_property  READER_RUNTIME_CONTROL      DESCRIPTION         "Enable run-time control of reader"
set_parameter_property  READER_RUNTIME_CONTROL      HDL_PARAMETER       true
set_parameter_property  READER_RUNTIME_CONTROL      ENABLED             true
set_parameter_property  READER_RUNTIME_CONTROL      AFFECTS_ELABORATION true

add_parameter           IS_FRAME_WRITER             INTEGER             0
set_parameter_property  IS_FRAME_WRITER             DISPLAY_NAME        "Module is Frame Writer"
set_parameter_property  IS_FRAME_WRITER             ALLOWED_RANGES      0:1
set_parameter_property  IS_FRAME_WRITER             DISPLAY_HINT        boolean
set_parameter_property  IS_FRAME_WRITER             DESCRIPTION         "Enable Frame Writer mode"
set_parameter_property  IS_FRAME_WRITER             HDL_PARAMETER       true
set_parameter_property  IS_FRAME_WRITER             ENABLED             true
set_parameter_property  IS_FRAME_WRITER             AFFECTS_ELABORATION true

add_parameter           IS_FRAME_READER             INTEGER             0
set_parameter_property  IS_FRAME_READER             DISPLAY_NAME        "Module is Frame Reader"
set_parameter_property  IS_FRAME_READER             ALLOWED_RANGES      0:1
set_parameter_property  IS_FRAME_READER             DISPLAY_HINT        boolean
set_parameter_property  IS_FRAME_READER             DESCRIPTION         "Enable Frame Reader mode"
set_parameter_property  IS_FRAME_READER             HDL_PARAMETER       true
set_parameter_property  IS_FRAME_READER             ENABLED             true
set_parameter_property  IS_FRAME_READER             AFFECTS_ELABORATION true

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

add_parameter           MULTI_FRAME_DELAY           INTEGER             1
set_parameter_property  MULTI_FRAME_DELAY           DISPLAY_NAME        "Delay length (frames)"
set_parameter_property  MULTI_FRAME_DELAY           ALLOWED_RANGES      1:2047
set_parameter_property  MULTI_FRAME_DELAY           DESCRIPTION         "Length of delay (not available with drop or repeat)"
set_parameter_property  MULTI_FRAME_DELAY           HDL_PARAMETER       true
set_parameter_property  MULTI_FRAME_DELAY           AFFECTS_ELABORATION true
set_parameter_property  MULTI_FRAME_DELAY           ENABLED             true

add_parameter           MEM_BASE_ADDR               INTEGER             0
set_parameter_property  MEM_BASE_ADDR               DISPLAY_NAME        "Frame Buffer base address"
set_parameter_property  MEM_BASE_ADDR               DESCRIPTION         "The base address for the frame buffer on Avalon-MM memory master port"
set_parameter_property  MEM_BASE_ADDR               HDL_PARAMETER       true
set_parameter_property  MEM_BASE_ADDR               AFFECTS_ELABORATION true
set_parameter_property  MEM_BASE_ADDR               VISIBLE             false
 
add_user_packets_mem_storage_parameters
set_parameter_property  USER_PACKETS_MAX_STORAGE    DISPLAY_NAME        "Maximum ancillary packets per frame"
set_parameter_property  MAX_SYMBOLS_PER_PACKET      DISPLAY_NAME        "Maximum length ancillary packet in symbols"

add_parameter           INTERLACED_SUPPORT          INTEGER             1
set_parameter_property  INTERLACED_SUPPORT          DISPLAY_NAME        "Interlace support"
set_parameter_property  INTERLACED_SUPPORT          ALLOWED_RANGES      0:1
set_parameter_property  INTERLACED_SUPPORT          DISPLAY_HINT        boolean
set_parameter_property  INTERLACED_SUPPORT          DESCRIPTION         "Enable controlled drop/repeat of frames when input is interlaced"
set_parameter_property  INTERLACED_SUPPORT          HDL_PARAMETER       true
set_parameter_property  INTERLACED_SUPPORT          ENABLED             true
set_parameter_property  INTERLACED_SUPPORT          AFFECTS_ELABORATION true

add_parameter           CONTROLLED_DROP_REPEAT      INTEGER             0
set_parameter_property  CONTROLLED_DROP_REPEAT      DISPLAY_NAME        "Locked rate support"
set_parameter_property  CONTROLLED_DROP_REPEAT      ALLOWED_RANGES      0:1
set_parameter_property  CONTROLLED_DROP_REPEAT      DISPLAY_HINT        boolean
set_parameter_property  CONTROLLED_DROP_REPEAT      DESCRIPTION         "Enable locked input/output rate support"
set_parameter_property  CONTROLLED_DROP_REPEAT      HDL_PARAMETER       true
set_parameter_property  CONTROLLED_DROP_REPEAT      ENABLED             true
set_parameter_property  CONTROLLED_DROP_REPEAT      AFFECTS_ELABORATION true

add_parameter           DROP_INVALID_FIELDS         INTEGER             1
set_parameter_property  DROP_INVALID_FIELDS         DISPLAY_NAME        "Drop invalid frames"
set_parameter_property  DROP_INVALID_FIELDS         ALLOWED_RANGES      0:1
set_parameter_property  DROP_INVALID_FIELDS         DISPLAY_HINT        boolean
set_parameter_property  DROP_INVALID_FIELDS         DESCRIPTION         "Enable dropping of frames with invalid dimensions"
set_parameter_property  DROP_INVALID_FIELDS         HDL_PARAMETER       true
set_parameter_property  DROP_INVALID_FIELDS         ENABLED             true
set_parameter_property  DROP_INVALID_FIELDS         AFFECTS_ELABORATION true

add_parameter           IS_SYNC_MASTER              INTEGER             0
set_parameter_property  IS_SYNC_MASTER              DISPLAY_NAME        "Sync master"
set_parameter_property  IS_SYNC_MASTER              ALLOWED_RANGES      0:1
set_parameter_property  IS_SYNC_MASTER              DISPLAY_HINT        boolean
set_parameter_property  IS_SYNC_MASTER              DESCRIPTION         "Enable sync master mode"
set_parameter_property  IS_SYNC_MASTER              HDL_PARAMETER       true
set_parameter_property  IS_SYNC_MASTER              ENABLED             true
set_parameter_property  IS_SYNC_MASTER              AFFECTS_ELABORATION true

add_parameter           IS_SYNC_SLAVE               INTEGER             0
set_parameter_property  IS_SYNC_SLAVE               DISPLAY_NAME        "Sync slave"
set_parameter_property  IS_SYNC_SLAVE               ALLOWED_RANGES      0:1
set_parameter_property  IS_SYNC_SLAVE               DISPLAY_HINT        boolean
set_parameter_property  IS_SYNC_SLAVE               DESCRIPTION         "Enable sync slave mode"
set_parameter_property  IS_SYNC_SLAVE               HDL_PARAMETER       true
set_parameter_property  IS_SYNC_SLAVE               ENABLED             true
set_parameter_property  IS_SYNC_SLAVE               AFFECTS_ELABORATION true

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
proc sync_ctrl_validation_callback {} {
    # handle reader_control and writer_control settings
    set rd_ctrl [get_parameter_value READER_RUNTIME_CONTROL]
    set wr_ctrl [get_parameter_value WRITER_RUNTIME_CONTROL]
    if {$rd_ctrl && $wr_ctrl} {
        send_message error "Reader control and writer control cannot both be enabled"
    }

    set is_frame_writer     [get_parameter_value IS_FRAME_WRITER]
    set is_frame_reader     [get_parameter_value IS_FRAME_READER]
    if {$rd_ctrl && $is_frame_writer} {
        send_message error "Cannot enable Reader control when Frame Writer mode is active"
    }
    if {$wr_ctrl && $is_frame_reader} {
        send_message error "Cannot enable Writer control when Frame Reader mode is active"
    }

# fixme: more

}

proc sync_ctrl_elaboration_callback {} {
    set src_width           [get_parameter_value SRC_WIDTH]
    set dst_width           [get_parameter_value DST_WIDTH]
    set context_width       [get_parameter_value CONTEXT_WIDTH]
    set task_width          [get_parameter_value TASK_WIDTH]
    set is_frame_writer     [get_parameter_value IS_FRAME_WRITER]
    set is_frame_reader     [get_parameter_value IS_FRAME_READER]

    # read side interfaces
    if {$is_frame_writer == 0} {
        # cmd output, resp input
        add_av_st_cmd_source_port  rd_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
        add_av_st_resp_sink_port   rd_resp 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

        # optional reader_control interface
        set rd_ctrl         [get_parameter_value READER_RUNTIME_CONTROL]
        if {$rd_ctrl} {
            set ctrl_depth        16
            set ctrl_addr_width   4
           # add_slave_port reader_control 32 $ctrl_addr_width $ctrl_depth $is_frame_reader 2 1 main_clock
            add_control_slave_port reader_control $ctrl_addr_width $ctrl_depth $is_frame_reader 2 1 1 main_clock
        }

    }

    # write side interfaces
    if {$is_frame_reader == 0} {
        # cmd output, resp input
        add_av_st_cmd_source_port  wr_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
        add_av_st_resp_sink_port   wr_resp 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

        # optional writer_control interface
        set wr_ctrl         [get_parameter_value WRITER_RUNTIME_CONTROL]
        set locked_rate     [get_parameter_value CONTROLLED_DROP_REPEAT]
        if {$wr_ctrl} {
            set ctrl_depth        16
            set ctrl_addr_width   4

            #add_slave_port writer_control 32 $ctrl_addr_width $ctrl_depth $is_frame_writer 2 1 main_clock
            add_control_slave_port writer_control $ctrl_addr_width $ctrl_depth $is_frame_writer 2 1 1 main_clock
        }
    }

    # optional sync master sync_m

    # optional sync slave sync_s

}
