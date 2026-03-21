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


# ---------------------------------------------------------------------------------------------------
# --                                                                                               --
# -- _hw.tcl compose file for the reader/writer                                                    --
# --                                                                                               --
# ---------------------------------------------------------------------------------------------------

source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information for the Frame Buffer component                                           --
# -- ...                                                                                          --
# --------------------------------------------------------------------------------------------------
# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME vfb_writer_reader
set_module_property DISPLAY_NAME "Video Writer Reader"
set_module_property DESCRIPTION "Test component for the Frame Buffer."

set_module_property HIDE_FROM_QSYS true
set_module_property  INTERNAL      true
set_module_property opaque_address_map false

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
# Callback for the composition of this component
set_module_property COMPOSITION_CALLBACK vfbrw_composition_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
# data layout parameters
add_bits_per_symbol_parameters

# add NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters

add_parameter           PIXELS_IN_PARALLEL          INTEGER             1
set_parameter_property  PIXELS_IN_PARALLEL          DISPLAY_NAME        "Pixels in parallel"
set_parameter_property  PIXELS_IN_PARALLEL          ALLOWED_RANGES      {1 2 4 8}
set_parameter_property  PIXELS_IN_PARALLEL          DESCRIPTION         "The number of pixels received every clock cycle."
set_parameter_property  PIXELS_IN_PARALLEL          HDL_PARAMETER       false
set_parameter_property  PIXELS_IN_PARALLEL          AFFECTS_ELABORATION true

add_parameter           DROP_FRAMES                 INTEGER             0
set_parameter_property  DROP_FRAMES                 DISPLAY_NAME        "Frame dropping"
set_parameter_property  DROP_FRAMES                 ALLOWED_RANGES      0:1
set_parameter_property  DROP_FRAMES                 DISPLAY_HINT        boolean
set_parameter_property  DROP_FRAMES                 DESCRIPTION         "Enable dropping of frames"
set_parameter_property  DROP_FRAMES                 HDL_PARAMETER       false
set_parameter_property  DROP_FRAMES                 AFFECTS_ELABORATION true

add_parameter           DROP_INVALID_FIELDS         INTEGER             0
set_parameter_property  DROP_INVALID_FIELDS         DISPLAY_NAME        "Drop invalid frames"
set_parameter_property  DROP_INVALID_FIELDS         ALLOWED_RANGES      0:1
set_parameter_property  DROP_INVALID_FIELDS         DISPLAY_HINT        boolean
set_parameter_property  DROP_INVALID_FIELDS         DESCRIPTION         "Enable dropping of frames with invalid dimensions"
set_parameter_property  DROP_INVALID_FIELDS         HDL_PARAMETER       false
set_parameter_property  DROP_INVALID_FIELDS         AFFECTS_ELABORATION true

add_parameter           REPEAT_FRAMES               INTEGER             0
set_parameter_property  REPEAT_FRAMES               DISPLAY_NAME        "Frame repeating"
set_parameter_property  REPEAT_FRAMES               ALLOWED_RANGES      0:1
set_parameter_property  REPEAT_FRAMES               DISPLAY_HINT        boolean
set_parameter_property  REPEAT_FRAMES               DESCRIPTION         "Enable repetition of frames"
set_parameter_property  REPEAT_FRAMES               HDL_PARAMETER       false
set_parameter_property  REPEAT_FRAMES               AFFECTS_ELABORATION true

###########################################
## composition

proc vfbrw_composition_cb { } {
    global isVersion acdsVersion

    set bits_per_symbol                 [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes          [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set color_planes_are_in_parallel    [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel              [get_parameter_value PIXELS_IN_PARALLEL]
    set drop_frames                     [get_parameter_value DROP_FRAMES]
    set drop_invalid_fields             [get_parameter_value DROP_INVALID_FIELDS]
    set repeat_frames                   [get_parameter_value REPEAT_FRAMES]

    # --------------------------------------------------------------------------------------------------
    # -- Clocks/reset                                                                                 --
    # --------------------------------------------------------------------------------------------------
    add_instance                     vid_clk_in     clock_source                     $acdsVersion
    set_instance_parameter_value     vid_clk_in     clockFrequency                   245000000.0
    set_instance_parameter_value     vid_clk_in     clockFrequencyKnown              1
    set_instance_parameter_value     vid_clk_in     resetSynchronousEdges            DEASSERT

    add_instance                     mem_clk_in     clock_source                     $acdsVersion
    set_instance_parameter_value     mem_clk_in     clockFrequency                   250000000.0
    set_instance_parameter_value     mem_clk_in     clockFrequencyKnown              1
    set_instance_parameter_value     mem_clk_in     resetSynchronousEdges            DEASSERT

    # --------------------------------------------------------------------------------------------------
    # -- Writer and reader components                                                                 --
    # --------------------------------------------------------------------------------------------------
    add_instance                     vfb_writer     alt_vip_cl_vfb                   $isVersion
    set_instance_parameter_value     vfb_writer     BITS_PER_SYMBOL                  $bits_per_symbol
    set_instance_parameter_value     vfb_writer     NUMBER_OF_COLOR_PLANES           $number_of_color_planes
    set_instance_parameter_value     vfb_writer     COLOR_PLANES_ARE_IN_PARALLEL     $color_planes_are_in_parallel
    set_instance_parameter_value     vfb_writer     PIXELS_IN_PARALLEL               $pixels_in_parallel
    set_instance_parameter_value     vfb_writer     READY_LATENCY                    1
    set_instance_parameter_value     vfb_writer     MAX_WIDTH                        2720
    set_instance_parameter_value     vfb_writer     MAX_HEIGHT                       768
    set_instance_parameter_value     vfb_writer     CLOCKS_ARE_SEPARATE              1
    set_instance_parameter_value     vfb_writer     MEM_PORT_WIDTH                   256
    set_instance_parameter_value     vfb_writer     MEM_BASE_ADDR                    4096
    set_instance_parameter_value     vfb_writer     USE_BUFFER_OFFSET                0
    set_instance_parameter_value     vfb_writer     MEM_BUFFER_OFFSET                16777216
    set_instance_parameter_value     vfb_writer     BURST_ALIGNMENT                  1
    set_instance_parameter_value     vfb_writer     WRITE_FIFO_DEPTH                 64
    set_instance_parameter_value     vfb_writer     WRITE_BURST_TARGET               32
    set_instance_parameter_value     vfb_writer     READ_FIFO_DEPTH                  64
    set_instance_parameter_value     vfb_writer     READ_BURST_TARGET                32
    set_instance_parameter_value     vfb_writer     WRITER_RUNTIME_CONTROL           1
    set_instance_parameter_value     vfb_writer     READER_RUNTIME_CONTROL           0
    set_instance_parameter_value     vfb_writer     IS_FRAME_WRITER                  1
    set_instance_parameter_value     vfb_writer     IS_FRAME_READER                  0
    set_instance_parameter_value     vfb_writer     DROP_FRAMES                      $drop_frames
    set_instance_parameter_value     vfb_writer     REPEAT_FRAMES                    $repeat_frames
    set_instance_parameter_value     vfb_writer     INTERLACED_SUPPORT               0
    set_instance_parameter_value     vfb_writer     CONTROLLED_DROP_REPEAT           0
    set_instance_parameter_value     vfb_writer     DROP_INVALID_FIELDS              $drop_invalid_fields
    set_instance_parameter_value     vfb_writer     MULTI_FRAME_DELAY                10
    set_instance_parameter_value     vfb_writer     IS_SYNC_MASTER                   0
    set_instance_parameter_value     vfb_writer     IS_SYNC_SLAVE                    0
    set_instance_parameter_value     vfb_writer     USER_PACKETS_MAX_STORAGE         0
    set_instance_parameter_value     vfb_writer     MAX_SYMBOLS_PER_PACKET           40
    set_instance_parameter_value     vfb_writer     TEST_INIT                        0

    add_instance                     vfb_reader     alt_vip_cl_vfb                   $isVersion
    set_instance_parameter_value     vfb_reader     BITS_PER_SYMBOL                  $bits_per_symbol
    set_instance_parameter_value     vfb_reader     NUMBER_OF_COLOR_PLANES           $number_of_color_planes
    set_instance_parameter_value     vfb_reader     COLOR_PLANES_ARE_IN_PARALLEL     $color_planes_are_in_parallel
    set_instance_parameter_value     vfb_reader     PIXELS_IN_PARALLEL               $pixels_in_parallel
    set_instance_parameter_value     vfb_reader     READY_LATENCY                    1
    set_instance_parameter_value     vfb_reader     MAX_WIDTH                        2720
    set_instance_parameter_value     vfb_reader     MAX_HEIGHT                       768
    set_instance_parameter_value     vfb_reader     CLOCKS_ARE_SEPARATE              1
    set_instance_parameter_value     vfb_reader     MEM_PORT_WIDTH                   256
    set_instance_parameter_value     vfb_reader     MEM_BASE_ADDR                    4096
    set_instance_parameter_value     vfb_reader     USE_BUFFER_OFFSET                0
    set_instance_parameter_value     vfb_reader     MEM_BUFFER_OFFSET                16777216
    set_instance_parameter_value     vfb_reader     BURST_ALIGNMENT                  1
    set_instance_parameter_value     vfb_reader     WRITE_FIFO_DEPTH                 64
    set_instance_parameter_value     vfb_reader     WRITE_BURST_TARGET               32
    set_instance_parameter_value     vfb_reader     READ_FIFO_DEPTH                  64
    set_instance_parameter_value     vfb_reader     READ_BURST_TARGET                32
    set_instance_parameter_value     vfb_reader     WRITER_RUNTIME_CONTROL           0
    set_instance_parameter_value     vfb_reader     READER_RUNTIME_CONTROL           1
    set_instance_parameter_value     vfb_reader     IS_FRAME_WRITER                  0
    set_instance_parameter_value     vfb_reader     IS_FRAME_READER                  1
    set_instance_parameter_value     vfb_reader     DROP_FRAMES                      $drop_frames
    set_instance_parameter_value     vfb_reader     REPEAT_FRAMES                    $repeat_frames
    set_instance_parameter_value     vfb_reader     INTERLACED_SUPPORT               0
    set_instance_parameter_value     vfb_reader     CONTROLLED_DROP_REPEAT           0
    set_instance_parameter_value     vfb_reader     DROP_INVALID_FIELDS              $drop_invalid_fields
    set_instance_parameter_value     vfb_reader     MULTI_FRAME_DELAY                1
    set_instance_parameter_value     vfb_reader     IS_SYNC_MASTER                   0
    set_instance_parameter_value     vfb_reader     IS_SYNC_SLAVE                    0
    set_instance_parameter_value     vfb_reader     USER_PACKETS_MAX_STORAGE         0
    set_instance_parameter_value     vfb_reader     MAX_SYMBOLS_PER_PACKET           40
    set_instance_parameter_value     vfb_reader     TEST_INIT                        0

    # --------------------------------------------------------------------------------------------------
    # -- Top-level interfaces                                                                         --
    # --------------------------------------------------------------------------------------------------
    add_interface    mem_clock              clock              sink
    add_interface    mem_reset              reset              sink
    add_interface    main_clock             clock              sink
    add_interface    main_reset             reset              sink

    add_interface    wr_control             avalon             slave
    add_interface    wr_control_interrupt   interrupt          sender
    add_interface    rd_control             avalon             slave
    add_interface    rd_control_interrupt   interrupt          sender

    add_interface    mem_master_wr          avalon             master
    add_interface    mem_master_rd          avalon             master

    add_interface    din                    avalon_streaming   sink
    add_interface    dout                   avalon_streaming   source

    set_interface_property    mem_clock             EXPORT_OF    mem_clk_in.clk_in
    set_interface_property    mem_reset             EXPORT_OF    mem_clk_in.clk_in_reset
    set_interface_property    main_clock            EXPORT_OF    vid_clk_in.clk_in
    set_interface_property    main_reset            EXPORT_OF    vid_clk_in.clk_in_reset

    set_interface_property    wr_control            EXPORT_OF    vfb_writer.control
    set_interface_property    wr_control_interrupt  EXPORT_OF    vfb_writer.control_interrupt
    set_interface_property    rd_control            EXPORT_OF    vfb_reader.control
    set_interface_property    rd_control_interrupt  EXPORT_OF    vfb_reader.control_interrupt

    set_interface_property    mem_master_wr         EXPORT_OF    vfb_writer.mem_master_wr
    set_interface_property    mem_master_rd         EXPORT_OF    vfb_reader.mem_master_rd

    set_interface_property    din                   EXPORT_OF    vfb_writer.din
    set_interface_property    dout                  EXPORT_OF    vfb_reader.dout



    # --------------------------------------------------------------------------------------------------
    # -- Internal connections                                                                         --
    # --------------------------------------------------------------------------------------------------
    add_connection vid_clk_in.clk vfb_reader.main_clock clock
    add_connection vid_clk_in.clk vfb_writer.main_clock clock

    add_connection vid_clk_in.clk_reset vfb_reader.main_reset reset
    add_connection vid_clk_in.clk_reset vfb_writer.main_reset reset

    add_connection mem_clk_in.clk vfb_reader.mem_clock clock
    add_connection mem_clk_in.clk vfb_writer.mem_clock clock

    add_connection mem_clk_in.clk_reset vfb_reader.mem_reset reset
    add_connection mem_clk_in.clk_reset vfb_writer.mem_reset reset


}
