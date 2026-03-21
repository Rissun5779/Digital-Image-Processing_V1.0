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


# --------------------------------------------------------------------------------------------------
# --                                                                                               --
# -- _hw.tcl compose file for Frame Buffer
# --                                                                                               --
# ---------------------------------------------------------------------------------------------------

source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information for the Frame Buffer component                                           --
# -- ...                                                                                          --
# --------------------------------------------------------------------------------------------------
# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME alt_vip_cl_vfb
set_module_property DISPLAY_NAME "Frame Buffer II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION "The Frame Buffer."

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
# Callback for the composition of this component
set_module_property VALIDATION_CALLBACK  vfb_validation_callback
set_module_property COMPOSITION_CALLBACK vfb_composition_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
# data layout parameters
add_bits_per_symbol_parameters

# add NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters
add_pixels_in_parallel_parameters


add_parameter           READY_LATENCY               INTEGER             1
set_parameter_property  READY_LATENCY               DISPLAY_NAME        "Ready latency"
set_parameter_property  READY_LATENCY               ALLOWED_RANGES      1
set_parameter_property  READY_LATENCY               DESCRIPTION         "Input and output data interface ready latency"
set_parameter_property  READY_LATENCY               IS_HDL_PARAMETER    true
set_parameter_property  READY_LATENCY               ENABLED             false
set_parameter_property  READY_LATENCY               VISIBLE             false
set_parameter_property  READY_LATENCY               AFFECTS_ELABORATION true

add_max_dim_parameters
set_parameter_property  MAX_WIDTH                   DEFAULT_VALUE       1920
set_parameter_property  MAX_WIDTH                   AFFECTS_ELABORATION true
set_parameter_property  MAX_HEIGHT                  DEFAULT_VALUE       1080
set_parameter_property  MAX_HEIGHT                  AFFECTS_ELABORATION true

# memory interface parameters
add_common_masters_parameters

add_parameter           MEM_BASE_ADDR               INTEGER             0
set_parameter_property  MEM_BASE_ADDR               DISPLAY_NAME        "Frame buffer memory base address"
set_parameter_property  MEM_BASE_ADDR               DISPLAY_HINT        hexadecimal
set_parameter_property  MEM_BASE_ADDR               DESCRIPTION         "The base address for the frame buffer in memory"
set_parameter_property  MEM_BASE_ADDR               HDL_PARAMETER       true
set_parameter_property  MEM_BASE_ADDR               AFFECTS_ELABORATION true

#JMH After 4kp60 low utilisation issues, this parameter was introduced.
add_parameter           USE_BUFFER_OFFSET           INTEGER             1
set_parameter_property  USE_BUFFER_OFFSET           DISPLAY_NAME        "Enable use of fixed inter-buffer offset"
set_parameter_property  USE_BUFFER_OFFSET           ALLOWED_RANGES      0:1
set_parameter_property  USE_BUFFER_OFFSET           DISPLAY_HINT        boolean
set_parameter_property  USE_BUFFER_OFFSET           DESCRIPTION         "Allows the individual buffers to be spread out in memory, to facilitate use of DDR banks to speed-up accesses"
set_parameter_property  USE_BUFFER_OFFSET           HDL_PARAMETER       false
set_parameter_property  USE_BUFFER_OFFSET           AFFECTS_ELABORATION true
set_parameter_property  USE_BUFFER_OFFSET           ENABLED             true
set_parameter_property  USE_BUFFER_OFFSET           DEFAULT_VALUE       false

add_parameter           MEM_BUFFER_OFFSET           INTEGER             16777216
set_parameter_property  MEM_BUFFER_OFFSET           DISPLAY_NAME        "Inter-buffer offset"
set_parameter_property  MEM_BUFFER_OFFSET           DISPLAY_HINT        hexadecimal
set_parameter_property  MEM_BUFFER_OFFSET           DESCRIPTION         "If enabled, buffers shall be spaced in memory according to this parameter. Offset must be greater than the size of an individual frame buffer."
set_parameter_property  MEM_BUFFER_OFFSET           HDL_PARAMETER       false
set_parameter_property  MEM_BUFFER_OFFSET           AFFECTS_ELABORATION true

# memory data access parameters
add_burst_align_parameters

add_bursting_master_parameters WRITE Write
add_bursting_master_parameters READ Read

# runtime control parameters
add_parameter           WRITER_RUNTIME_CONTROL      INTEGER             0
set_parameter_property  WRITER_RUNTIME_CONTROL      DISPLAY_NAME        "Run-time writer control"
set_parameter_property  WRITER_RUNTIME_CONTROL      ALLOWED_RANGES      0:1
set_parameter_property  WRITER_RUNTIME_CONTROL      DISPLAY_HINT        boolean
set_parameter_property  WRITER_RUNTIME_CONTROL      DESCRIPTION         "Enable run-time control of write side"
set_parameter_property  WRITER_RUNTIME_CONTROL      HDL_PARAMETER       true
set_parameter_property  WRITER_RUNTIME_CONTROL      AFFECTS_ELABORATION true

add_parameter           READER_RUNTIME_CONTROL      INTEGER             0
set_parameter_property  READER_RUNTIME_CONTROL      DISPLAY_NAME        "Run-time reader control"
set_parameter_property  READER_RUNTIME_CONTROL      ALLOWED_RANGES      0:1
set_parameter_property  READER_RUNTIME_CONTROL      DISPLAY_HINT        boolean
set_parameter_property  READER_RUNTIME_CONTROL      DESCRIPTION         "Enable run-time control of read side"
set_parameter_property  READER_RUNTIME_CONTROL      HDL_PARAMETER       true
set_parameter_property  READER_RUNTIME_CONTROL      AFFECTS_ELABORATION true

# core configuration
add_parameter           IS_FRAME_WRITER             INTEGER             0
set_parameter_property  IS_FRAME_WRITER             DISPLAY_NAME        "Module is Frame Writer only"
set_parameter_property  IS_FRAME_WRITER             ALLOWED_RANGES      0:1
set_parameter_property  IS_FRAME_WRITER             DISPLAY_HINT        boolean
set_parameter_property  IS_FRAME_WRITER             DESCRIPTION         "Enable Frame Writer mode"
set_parameter_property  IS_FRAME_WRITER             HDL_PARAMETER       true
set_parameter_property  IS_FRAME_WRITER             ENABLED             true
set_parameter_property  IS_FRAME_WRITER             VISIBLE             true
set_parameter_property  IS_FRAME_WRITER             AFFECTS_ELABORATION true

add_parameter           IS_FRAME_READER             INTEGER             0
set_parameter_property  IS_FRAME_READER             DISPLAY_NAME        "Module is Frame Reader only"
set_parameter_property  IS_FRAME_READER             ALLOWED_RANGES      0:1
set_parameter_property  IS_FRAME_READER             DISPLAY_HINT        boolean
set_parameter_property  IS_FRAME_READER             DESCRIPTION         "Enable Frame Reader mode"
set_parameter_property  IS_FRAME_READER             HDL_PARAMETER       true
set_parameter_property  IS_FRAME_READER             ENABLED             true
set_parameter_property  IS_FRAME_READER             VISIBLE             true
set_parameter_property  IS_FRAME_READER             AFFECTS_ELABORATION true

add_parameter           DROP_FRAMES                 INTEGER             0
set_parameter_property  DROP_FRAMES                 DISPLAY_NAME        "Frame dropping"
set_parameter_property  DROP_FRAMES                 ALLOWED_RANGES      0:1
set_parameter_property  DROP_FRAMES                 DISPLAY_HINT        boolean
set_parameter_property  DROP_FRAMES                 DESCRIPTION         "Enable dropping of frames"
set_parameter_property  DROP_FRAMES                 HDL_PARAMETER       true
set_parameter_property  DROP_FRAMES                 AFFECTS_ELABORATION true

add_parameter           REPEAT_FRAMES               INTEGER             0
set_parameter_property  REPEAT_FRAMES               DISPLAY_NAME        "Frame repeating"
set_parameter_property  REPEAT_FRAMES               ALLOWED_RANGES      0:1
set_parameter_property  REPEAT_FRAMES               DISPLAY_HINT        boolean
set_parameter_property  REPEAT_FRAMES               DESCRIPTION         "Enable repetition of frames"
set_parameter_property  REPEAT_FRAMES               HDL_PARAMETER       true
set_parameter_property  REPEAT_FRAMES               AFFECTS_ELABORATION true

add_parameter           DROP_REPEAT_USER            INTEGER             0
set_parameter_property  DROP_REPEAT_USER            DISPLAY_NAME        "Drop/repeat user packets"
set_parameter_property  DROP_REPEAT_USER            ALLOWED_RANGES      0:1
set_parameter_property  DROP_REPEAT_USER            DISPLAY_HINT        boolean
set_parameter_property  DROP_REPEAT_USER            DESCRIPTION         "Enable dropping and repeating of user packets when associated frames are dropped/repeated"
set_parameter_property  DROP_REPEAT_USER            HDL_PARAMETER       true
set_parameter_property  DROP_REPEAT_USER            AFFECTS_ELABORATION true

add_parameter           INTERLACED_SUPPORT          INTEGER             0
set_parameter_property  INTERLACED_SUPPORT          DISPLAY_NAME        "Interlace support"
set_parameter_property  INTERLACED_SUPPORT          ALLOWED_RANGES      0:1
set_parameter_property  INTERLACED_SUPPORT          DISPLAY_HINT        boolean
set_parameter_property  INTERLACED_SUPPORT          DESCRIPTION         "Enable controlled drop/repeat of frames when input is interlaced"
set_parameter_property  INTERLACED_SUPPORT          HDL_PARAMETER       true
set_parameter_property  INTERLACED_SUPPORT          AFFECTS_ELABORATION true

add_parameter           CONTROLLED_DROP_REPEAT      INTEGER             0
set_parameter_property  CONTROLLED_DROP_REPEAT      DISPLAY_NAME        "Locked rate support"
set_parameter_property  CONTROLLED_DROP_REPEAT      ALLOWED_RANGES      0:1
set_parameter_property  CONTROLLED_DROP_REPEAT      DISPLAY_HINT        boolean
set_parameter_property  CONTROLLED_DROP_REPEAT      DESCRIPTION         "Enable locked input/output rate support (in locked mode a constant drop/repeat pattern is used based upon relative frame rates)"
set_parameter_property  CONTROLLED_DROP_REPEAT      HDL_PARAMETER       true
set_parameter_property  CONTROLLED_DROP_REPEAT      AFFECTS_ELABORATION true

add_parameter           DROP_INVALID_FIELDS         INTEGER             0
set_parameter_property  DROP_INVALID_FIELDS         DISPLAY_NAME        "Drop invalid frames"
set_parameter_property  DROP_INVALID_FIELDS         ALLOWED_RANGES      0:1
set_parameter_property  DROP_INVALID_FIELDS         DISPLAY_HINT        boolean
set_parameter_property  DROP_INVALID_FIELDS         DESCRIPTION         "Enable dropping of frames with invalid dimensions"
set_parameter_property  DROP_INVALID_FIELDS         HDL_PARAMETER       true
set_parameter_property  DROP_INVALID_FIELDS         AFFECTS_ELABORATION true

add_parameter           MULTI_FRAME_DELAY           INTEGER             1
set_parameter_property  MULTI_FRAME_DELAY           DISPLAY_NAME        "Delay length (frames)"
set_parameter_property  MULTI_FRAME_DELAY           ALLOWED_RANGES      1:2047
set_parameter_property  MULTI_FRAME_DELAY           DESCRIPTION         "Maximum supported delay length in frames"
set_parameter_property  MULTI_FRAME_DELAY           HDL_PARAMETER       true
set_parameter_property  MULTI_FRAME_DELAY           AFFECTS_ELABORATION true
set_parameter_property  MULTI_FRAME_DELAY           ENABLED             true
set_parameter_property  MULTI_FRAME_DELAY           VISIBLE             true

add_parameter           IS_SYNC_MASTER              INTEGER             0
set_parameter_property  IS_SYNC_MASTER              DISPLAY_NAME        "Sync master"
set_parameter_property  IS_SYNC_MASTER              ALLOWED_RANGES      0:1
set_parameter_property  IS_SYNC_MASTER              DISPLAY_HINT        boolean
set_parameter_property  IS_SYNC_MASTER              DESCRIPTION         "Enable sync master mode"
set_parameter_property  IS_SYNC_MASTER              HDL_PARAMETER       true
set_parameter_property  IS_SYNC_MASTER              ENABLED             false
set_parameter_property  IS_SYNC_MASTER              VISIBLE             false
set_parameter_property  IS_SYNC_MASTER              AFFECTS_ELABORATION true

add_parameter           IS_SYNC_SLAVE               INTEGER             0
set_parameter_property  IS_SYNC_SLAVE               DISPLAY_NAME        "Sync slave"
set_parameter_property  IS_SYNC_SLAVE               ALLOWED_RANGES      0:1
set_parameter_property  IS_SYNC_SLAVE               DISPLAY_HINT        boolean
set_parameter_property  IS_SYNC_SLAVE               DESCRIPTION         "Enable sync slave mode"
set_parameter_property  IS_SYNC_SLAVE               HDL_PARAMETER       true
set_parameter_property  IS_SYNC_SLAVE               ENABLED             false
set_parameter_property  IS_SYNC_SLAVE               VISIBLE             false
set_parameter_property  IS_SYNC_SLAVE               AFFECTS_ELABORATION true

add_parameter           LINE_BASED_BUFFERING        INTEGER             0
set_parameter_property  LINE_BASED_BUFFERING        DISPLAY_NAME        "Line based buffering"
set_parameter_property  LINE_BASED_BUFFERING        ALLOWED_RANGES      0:1
set_parameter_property  LINE_BASED_BUFFERING        DISPLAY_HINT        boolean
set_parameter_property  LINE_BASED_BUFFERING        DESCRIPTION         "Enable buffering based upon lines, not frames"
set_parameter_property  LINE_BASED_BUFFERING        HDL_PARAMETER       true
set_parameter_property  LINE_BASED_BUFFERING        ENABLED             true
set_parameter_property  LINE_BASED_BUFFERING        VISIBLE             false
set_parameter_property  LINE_BASED_BUFFERING        AFFECTS_ELABORATION true

add_parameter           PRIORITIZE_FMAX        INTEGER             0
set_parameter_property  PRIORITIZE_FMAX        DISPLAY_NAME        "Prioritize Fmax over memory bandwidth"
set_parameter_property  PRIORITIZE_FMAX        ALLOWED_RANGES      0:1
set_parameter_property  PRIORITIZE_FMAX        DISPLAY_HINT        boolean
set_parameter_property  PRIORITIZE_FMAX        DESCRIPTION         "Enable padding of pixels up to 32 bits to increase Fmax at the cost of increased DDR bandwidth"
set_parameter_property  PRIORITIZE_FMAX        HDL_PARAMETER       true
set_parameter_property  PRIORITIZE_FMAX        ENABLED             true
set_parameter_property  PRIORITIZE_FMAX        VISIBLE             true
set_parameter_property  PRIORITIZE_FMAX        AFFECTS_ELABORATION true

add_user_packets_mem_storage_parameters
set_parameter_property  USER_PACKETS_MAX_STORAGE    DISPLAY_NAME        "Maximum ancillary packets per frame"
set_parameter_property  USER_PACKETS_MAX_STORAGE    AFFECTS_ELABORATION true
set_parameter_property  USER_PACKETS_MAX_STORAGE    ENABLED             true

set_parameter_property  MAX_SYMBOLS_PER_PACKET      DISPLAY_NAME        "Maximum length ancillary packet in symbols"
set_parameter_property  MAX_SYMBOLS_PER_PACKET      AFFECTS_ELABORATION true

# TEST_INIT parameter used only during simulation - no connections or effect in synthesis
add_parameter           TEST_INIT                   INTEGER             0
set_parameter_property  TEST_INIT                   HDL_PARAMETER       false
set_parameter_property  TEST_INIT                   ENABLED             false
set_parameter_property  TEST_INIT                   VISIBLE             false
set_parameter_property  TEST_INIT                   AFFECTS_ELABORATION false

# --------------------------------------------------------------------------------------------------
# --                                                                                      --
# -- Derived parameters                                                                   --
# --                                                                                      --
# --------------------------------------------------------------------------------------------------
add_parameter           ANC_BUFFER_LENGTH           INTEGER             0
set_parameter_property  ANC_BUFFER_LENGTH           DESCRIPTION         "The max length (in bytes) of one ancillary packet stored in memory"
set_parameter_property  ANC_BUFFER_LENGTH           VISIBLE             false
set_parameter_property  ANC_BUFFER_LENGTH           HDL_PARAMETER       false
set_parameter_property  ANC_BUFFER_LENGTH           DERIVED             true

add_parameter           ACTUAL_MAX_SYM_ANC_PACKET   INTEGER             0
set_parameter_property  ACTUAL_MAX_SYM_ANC_PACKET   DESCRIPTION         "Actual maximum number of symbols supported per anc packet"
set_parameter_property  ACTUAL_MAX_SYM_ANC_PACKET   VISIBLE             false
set_parameter_property  ACTUAL_MAX_SYM_ANC_PACKET   HDL_PARAMETER       false
set_parameter_property  ACTUAL_MAX_SYM_ANC_PACKET   DERIVED             true

add_parameter           FRAME_BUFFER_LENGTH         INTEGER             0
set_parameter_property  FRAME_BUFFER_LENGTH         DESCRIPTION         "The length (in bytes) of one frame stored in memory"
set_parameter_property  FRAME_BUFFER_LENGTH         VISIBLE             false
set_parameter_property  FRAME_BUFFER_LENGTH         HDL_PARAMETER       false
set_parameter_property  FRAME_BUFFER_LENGTH         DERIVED             true

add_parameter           NUM_BUFFERS                 INTEGER             0
set_parameter_property  NUM_BUFFERS                 DESCRIPTION         "Number of frames buffered"
set_parameter_property  NUM_BUFFERS                 VISIBLE             false
set_parameter_property  NUM_BUFFERS                 HDL_PARAMETER       true
set_parameter_property  NUM_BUFFERS                 DERIVED             true


add_device_family_parameters

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_display_item   "Video Data Format"      MAX_WIDTH                       parameter
add_display_item   "Video Data Format"      MAX_HEIGHT                      parameter
add_display_item   "Video Data Format"      BITS_PER_SYMBOL                 parameter
add_display_item   "Video Data Format"      NUMBER_OF_COLOR_PLANES          parameter
add_display_item   "Video Data Format"      COLOR_PLANES_ARE_IN_PARALLEL    parameter
add_display_item   "Video Data Format"      PIXELS_IN_PARALLEL              parameter
add_display_item   "Video Data Format"      INTERLACED_SUPPORT              parameter
add_display_item   "Video Data Format"      READY_LATENCY                   parameter

add_display_item   "Memory"                 CLOCKS_ARE_SEPARATE             parameter
add_display_item   "Memory"                 MEM_PORT_WIDTH                  parameter
add_display_item   "Memory"                 WRITE_FIFO_DEPTH                parameter
add_display_item   "Memory"                 WRITE_BURST_TARGET              parameter
add_display_item   "Memory"                 READ_FIFO_DEPTH                 parameter
add_display_item   "Memory"                 READ_BURST_TARGET               parameter
add_display_item   "Memory"                 BURST_ALIGNMENT                 parameter
add_display_item   "Memory"                 USER_PACKETS_MAX_STORAGE        parameter
add_display_item   "Memory"                 MAX_SYMBOLS_PER_PACKET          parameter
add_display_item   "Memory"                 MEM_BASE_ADDR                   parameter
add_display_item   "Memory"                 USE_BUFFER_OFFSET               parameter
add_display_item   "Memory"                 MEM_BUFFER_OFFSET               parameter

add_display_item   "Optimization"           PRIORITIZE_FMAX                 parameter

add_display_item   "Frame Configuration"    IS_FRAME_READER                 parameter
add_display_item   "Frame Configuration"    		IS_FRAME_WRITER                 parameter
add_display_item   "Frame Configuration"    		DROP_FRAMES                     parameter
add_display_item   "Frame Configuration"    		REPEAT_FRAMES                   parameter
add_display_item   "Frame Configuration"    		MULTI_FRAME_DELAY               parameter
add_display_item   "Frame Configuration"    		CONTROLLED_DROP_REPEAT          parameter
add_display_item   "Frame Configuration"    		DROP_INVALID_FIELDS             parameter
add_display_item   "Frame Configuration"   		DROP_REPEAT_USER                parameter
add_display_item   "Frame Configuration"          LINE_BASED_BUFFERING            parameter

add_display_item   "Control"                WRITER_RUNTIME_CONTROL          parameter
add_display_item   "Control"                READER_RUNTIME_CONTROL          parameter
add_display_item   "Control"                IS_SYNC_MASTER                  parameter
add_display_item   "Control"                IS_SYNC_SLAVE                   parameter

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- The validation callback                                                                      --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc vfb_validation_callback {} {

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set number_of_color_planes          [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set color_planes_are_in_parallel    [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel              [get_parameter_value PIXELS_IN_PARALLEL]
    set rd_ctrl                         [get_parameter_value READER_RUNTIME_CONTROL]
    set wr_ctrl                         [get_parameter_value WRITER_RUNTIME_CONTROL]
    set drop_frames                     [get_parameter_value DROP_FRAMES]
    set repeat_frames                   [get_parameter_value REPEAT_FRAMES]
    set drop_repeat_user                [get_parameter_value DROP_REPEAT_USER]
    set multi_frame_delay               [get_parameter_value MULTI_FRAME_DELAY]
    set drop_invalid_fields             [get_parameter_value DROP_INVALID_FIELDS]
    set bits_per_symbol                 [get_parameter_value BITS_PER_SYMBOL]
    set max_width                       [get_parameter_value MAX_WIDTH]
    set max_height                      [get_parameter_value MAX_HEIGHT]
    set mem_port_width                  [get_parameter_value MEM_PORT_WIDTH]
    set burst_alignment                 [get_parameter_value BURST_ALIGNMENT]
    set read_burst_target               [get_parameter_value READ_BURST_TARGET]
    set interlaced_support              [get_parameter_value INTERLACED_SUPPORT]
    set is_frame_reader                 [get_parameter_value IS_FRAME_READER]
    set is_frame_writer                 [get_parameter_value IS_FRAME_WRITER]
    set num_anc_packets                 [get_parameter_value USER_PACKETS_MAX_STORAGE]
    set anc_packet_sym                  [get_parameter_value MAX_SYMBOLS_PER_PACKET]
    set mem_base_addr                   [get_parameter_value MEM_BASE_ADDR]
    set controlled_drop_repeat          [get_parameter_value CONTROLLED_DROP_REPEAT]
    set use_buffer_offset               [get_parameter_value USE_BUFFER_OFFSET]
    set mem_buffer_offset               [get_parameter_value MEM_BUFFER_OFFSET]
    set prioritize_fmax                 [get_parameter_value PRIORITIZE_FMAX]
    set line_based_buffering            [get_parameter_value LINE_BASED_BUFFERING]

    set symbols_per_beat                [expr $pixels_in_parallel * $number_of_color_planes]



    if { !$color_planes_are_in_parallel && $pixels_in_parallel > 1 } {
        send_message error "If color planes are sequential, then pixels in parallel must be 1"
    }

    # handle reader_control and writer_control settings
    if {$rd_ctrl && $wr_ctrl} {
        send_message error "Cannot enable both reader control and writer control"
    }
    # decide on number of frames to buffer
    if {($drop_frames || $repeat_frames || $is_frame_reader || $is_frame_writer)} {
        set num_buffers         [expr $multi_frame_delay+2]
    } else {
        set num_buffers         [expr $multi_frame_delay+1]
    }
    set_parameter_value         NUM_BUFFERS    $num_buffers

    if {$drop_invalid_fields && !$drop_frames} {
        send_message error "Frame dropping must be enabled to drop invalid frames"
    }

    if {($drop_frames || $repeat_frames)} {
        set_parameter_property  DROP_REPEAT_USER   ENABLED    true
    } else {
        set_parameter_property  DROP_REPEAT_USER   ENABLED    false
    }

    # work out storage per video frame
    # packet transfer packs data fully within a packet (frame), but need to round up mem usage to full memory words/bursts
    set bits_per_frame          [expr $number_of_color_planes * $bits_per_symbol * $max_width * $max_height]
    # if pixels are in parallel then empty count is written to memory per AvST word, which must be accounted for
    if {$color_planes_are_in_parallel && $pixels_in_parallel > 1} {
        # get max number of AvST words and add on empty pixel count for each word
        incr bits_per_frame     [expr ((($max_width*$max_height) + $pixels_in_parallel-1)/$pixels_in_parallel) * 2 * [clogb2_pure $pixels_in_parallel]]
    }
    set burst_length            [expr $mem_port_width*$read_burst_target]
    if {$burst_alignment} {
        # align frames to burst boundary
        set bytes_per_frame     [expr (($bits_per_frame + ($burst_length-1)) / $burst_length) * ($burst_length / 8)]
    } else {
        # align frames to memory word boundary only
        set bytes_per_frame     [expr (($bits_per_frame + ($mem_port_width-1)) / $mem_port_width) * ($mem_port_width / 8)]
    }

    if {$interlaced_support && ($max_height % 2)} {
        send_message error "Frame height must be even when interlaced mode is enabled"
    }

    # frame reader/writer
    if {!$rd_ctrl && $is_frame_reader} {
        send_message error "Run-time Reader Control must be enabled with Frame Reader mode"
    }
    if {!$wr_ctrl && $is_frame_writer} {
        send_message error "Run-time Writer Control must be enabled with Frame Writer mode"
    }
    if {$is_frame_reader && $is_frame_writer} {
        send_message error "Cannot enable both Frame Reader and Frame Writer modes"
    }
    if {$is_frame_reader || $is_frame_writer} {
        if {$controlled_drop_repeat} {
            send_message error "Cannot enable locked rate with Frame Reader or Frame Writer modes"
        }
        if {$interlaced_support} {
            send_message error "Cannot enable interlaced mode with Frame Reader or Frame Writer modes"
        }
    }

    # calculate ancillary packet store size
    # ancillary data packets must be an integer multiple of (PIXELS_IN_PARALLEL * NUMBER_OF_COLOR_PLANES), so round up
    set real_anc_packet_max_sym [expr (($anc_packet_sym + $symbols_per_beat-1) / $symbols_per_beat) * $symbols_per_beat];
    set_parameter_value         ACTUAL_MAX_SYM_ANC_PACKET    $real_anc_packet_max_sym
    set anc_packet_bits         [expr $bits_per_symbol * $real_anc_packet_max_sym];
    # if pixels are in parallel then empty count is included per word, which must be accounted for
    if {$color_planes_are_in_parallel && $pixels_in_parallel > 1} {
        # get max number of AvST words and add on empty pixel count for each word
        incr anc_packet_bits    [expr ($real_anc_packet_max_sym/$symbols_per_beat) * 2 * [clogb2_pure $pixels_in_parallel]]
    }
    if {$burst_alignment} {
        # align each packet start to burst boundary
        set anc_packet_bytes    [expr (($anc_packet_bits + ($burst_length-1)) / $burst_length) * ($burst_length / 8)]
    } else {
        # align each packet start to memory word boundary only
        set anc_packet_bytes    [expr (($anc_packet_bits + ($mem_port_width-1)) / $mem_port_width) * ($mem_port_width / 8)]
    }
    set_parameter_value         ANC_BUFFER_LENGTH   $anc_packet_bytes

    # calculate overall buffer dimensions
    if {$use_buffer_offset} {
        # fixed offset between frame buffers
        set_parameter_property  MEM_BUFFER_OFFSET   ENABLED    true
        set_parameter_value     FRAME_BUFFER_LENGTH $mem_buffer_offset
        set total_frame_buffer_size [expr ($mem_buffer_offset + ($num_anc_packets * $anc_packet_bytes)) * $num_buffers]
        if {$bytes_per_frame > $mem_buffer_offset} {
            send_message error "Fixed memory buffer offset must be greater than the size of an individual frame buffer (0x[format {%08x} [expr $bytes_per_frame]])"
        }
    } else {
        # minimum offset between frame buffers
        set_parameter_property  MEM_BUFFER_OFFSET   ENABLED    false
        set_parameter_value     FRAME_BUFFER_LENGTH $bytes_per_frame
        set total_frame_buffer_size [expr ($bytes_per_frame + ($num_anc_packets * $anc_packet_bytes)) * $num_buffers]
    }
    send_message info "Buffer $num_buffers frames, storage required is [expr ($total_frame_buffer_size+1023)/1024] kB (0x[format {%08x} $mem_base_addr] to 0x[format {%08x} [expr $mem_base_addr+$total_frame_buffer_size]])"

    if {$controlled_drop_repeat && (!$drop_frames || !$repeat_frames || !$wr_ctrl)} {
        send_message error "Frame Dropping, Frame Repeating and Run-time Writer Control must be enabled when Locked Rate Support is enabled"
    }

    if {$line_based_buffering && ($rd_ctrl || $wr_ctrl) } {
    	send_message info "Line buffer mode always has a control interface.  Reader or writer runtime control options are ignored."
    }

    set data_width    [expr $bits_per_symbol * $number_of_color_planes]

    if { $prioritize_fmax && $data_width == 32 } {
        send_message error "No scope for Fmax prioritization with current configuration.  Fmax is already optimal."
    }

    if { $prioritize_fmax && $bits_per_symbol == 8 } {
        send_message error "No scope for Fmax prioritization with current configuration.  Fmax is already optimal."
    }

    if { $prioritize_fmax && $bits_per_symbol == 16 } {
        send_message error "No scope for Fmax prioritization with current configuration.  Fmax is already optimal."
    }

    if { $prioritize_fmax && $data_width > 32 } {
        send_message error "Fmax prioritization unsupported with current configuration.  De-select Fmax Prioritization or reduce Bits Per Symbol or Number of Color Planes."
    }


}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- The composition callback                                                                     --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc vfb_composition_callback {} {

    # --------------------------------------------------------------------------------------------------
    # -- DTS assignments (for embedded SW flows)                                                      --
    # --------------------------------------------------------------------------------------------------
    # Don't change the parameter names without informing the embedded sw team making linux drivers
    set_module_assignment embeddedsw.dts.vendor          "altr"
    set_module_assignment embeddedsw.dts.group           "vip"
    set_module_assignment embeddedsw.dts.name            "vip"
    set_module_assignment embeddedsw.dts.compatible      "altr,vip-frame-buffer-2.0"

    set_module_assignment     embeddedsw.dts.params.altr,bits-per-symbol      [get_parameter_value  BITS_PER_SYMBOL]
    set_module_assignment     embeddedsw.dts.params.altr,max-width            [get_parameter_value  MAX_WIDTH]
    set_module_assignment     embeddedsw.dts.params.altr,max-height           [get_parameter_value  MAX_HEIGHT]
    set_module_assignment     embeddedsw.dts.params.altr,mem-port-width       [get_parameter_value  MEM_PORT_WIDTH]

    # --------------------------------------------------------------------------------------------------
    # -- Call the composition helpers                                                                 --
    # --------------------------------------------------------------------------------------------------
    vfb_composition_callback_instantiation
    vfb_composition_callback_connections
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Instantiation of sub-components                                                              --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc vfb_composition_callback_instantiation {} {
    global isVersion acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set max_width                       [get_parameter_value MAX_WIDTH]
    set max_height                      [get_parameter_value MAX_HEIGHT]
    set bits_per_symbol                 [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes          [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set color_planes_are_in_parallel    [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel              [get_parameter_value PIXELS_IN_PARALLEL]
    set ready_latency                   [get_parameter_value READY_LATENCY]
    set clocks_are_separate             [get_parameter_value CLOCKS_ARE_SEPARATE]
    set mem_port_width                  [get_parameter_value MEM_PORT_WIDTH]
    set write_fifo_depth                [get_parameter_value WRITE_FIFO_DEPTH]
    set write_burst_target              [get_parameter_value WRITE_BURST_TARGET]
    set read_fifo_depth                 [get_parameter_value READ_FIFO_DEPTH]
    set read_burst_target               [get_parameter_value READ_BURST_TARGET]
    set is_frame_reader                 [get_parameter_value IS_FRAME_READER]
    set is_frame_writer                 [get_parameter_value IS_FRAME_WRITER]
    set drop_frames                     [get_parameter_value DROP_FRAMES]
    set repeat_frames                   [get_parameter_value REPEAT_FRAMES]
    set drop_repeat_user                [get_parameter_value DROP_REPEAT_USER]
    set multi_frame_delay               [get_parameter_value MULTI_FRAME_DELAY]
    set interlaced_support              [get_parameter_value INTERLACED_SUPPORT]
    set controlled_drop_repeat          [get_parameter_value CONTROLLED_DROP_REPEAT]
    set drop_invalid_fields             [get_parameter_value DROP_INVALID_FIELDS]
    set is_sync_master                  [get_parameter_value IS_SYNC_MASTER]
    set is_sync_slave                   [get_parameter_value IS_SYNC_SLAVE]
    set writer_runtime_control          [get_parameter_value WRITER_RUNTIME_CONTROL]
    set reader_runtime_control          [get_parameter_value READER_RUNTIME_CONTROL]
    set anc_buffer_length               [get_parameter_value ANC_BUFFER_LENGTH]
    set frame_buffer_length             [get_parameter_value FRAME_BUFFER_LENGTH]
    set num_buffers                     [get_parameter_value NUM_BUFFERS]
    set user_packets_max_storage        [get_parameter_value USER_PACKETS_MAX_STORAGE]
    set max_symbols_per_packet          [get_parameter_value ACTUAL_MAX_SYM_ANC_PACKET]
    set mem_base_addr                   [get_parameter_value MEM_BASE_ADDR]
    set line_based_buffering            [get_parameter_value LINE_BASED_BUFFERING]
    set prioritize_fmax                 [get_parameter_value PRIORITIZE_FMAX]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    if {$color_planes_are_in_parallel} {
        set data_width                  [expr $bits_per_symbol * $number_of_color_planes]
        set symbols_in_seq              1
        set pkt_trans_width             [expr $prioritize_fmax ? 32 : $data_width]

    } else {
        set symbols_in_seq              $number_of_color_planes
        set pkt_trans_width             $bits_per_symbol
    }




    if {$line_based_buffering} {
	    set pkt_trans_max_len  [expr $max_width]
	} else {

	    # set up pkt transfer buffers for whichever is longer: video line or max anc pkt length
	    if {$user_packets_max_storage == 0 || (($max_height * $max_width) > $max_symbols_per_packet/$number_of_color_planes)} {
	        set pkt_trans_max_len           [expr $max_height * $max_width]
	    } else {
	        set pkt_trans_max_len           [expr $max_symbols_per_packet/$number_of_color_planes]
	    }

	}

    # calculate packet transfer buffer ratios from fifo depth and burst target parameters (and round up)
    set write_buffer_ratio              [expr ($write_fifo_depth+$write_burst_target-1)/$write_burst_target]
    set read_buffer_ratio               [expr ($read_fifo_depth+$read_burst_target-1)/$read_burst_target]


    # --------------------------------------------------------------------------------------------------
    # -- Constants                                                                                    --
    # --------------------------------------------------------------------------------------------------
    set src_width                       8
    set dst_width                       8
    set task_width                      8
    set context_width                   8
    set user_width                      0

    # --------------------------------------------------------------------------------------------------
    # -- Clocks/reset                                                                                 --
    # --------------------------------------------------------------------------------------------------
    add_instance                    av_st_clk_bridge    altera_clock_bridge             $acdsVersion
    add_instance                    av_st_reset_bridge  altera_reset_bridge             $acdsVersion

    if {$clocks_are_separate} {
        add_instance                av_mm_clk_bridge    altera_clock_bridge             $acdsVersion
        add_instance                av_mm_reset_bridge  altera_reset_bridge             $acdsVersion
    }

    # --------------------------------------------------------------------------------------------------
    # -- Main components                                                                              --
    # --------------------------------------------------------------------------------------------------

    if ($line_based_buffering) {

		    add_instance                    linebuf_ctrl   alt_vip_vfb_linebuf_ctrl               $isVersion
		    set_instance_parameter_value    linebuf_ctrl   MAX_WIDTH                           $max_width
		    set_instance_parameter_value    linebuf_ctrl   MAX_HEIGHT                          $max_height
	        set_instance_parameter_value    linebuf_ctrl   NUMBER_OF_COLOR_PLANES              $number_of_color_planes
	        set_instance_parameter_value    linebuf_ctrl   BITS_PER_SYMBOL                     $bits_per_symbol
	        set_instance_parameter_value    linebuf_ctrl   PIXELS_IN_PARALLEL                  $pixels_in_parallel
	        set_instance_parameter_value    linebuf_ctrl   ANC_BUFFER_LENGTH                   $anc_buffer_length
		    set_instance_parameter_value    linebuf_ctrl   FRAME_BUFFER_LENGTH                 $frame_buffer_length
		    set_instance_parameter_value    linebuf_ctrl   MEM_BASE_ADDR                       $mem_base_addr
		    set_instance_parameter_value    linebuf_ctrl   USER_PACKETS_MAX_STORAGE            $user_packets_max_storage
		    set_instance_parameter_value    linebuf_ctrl   MAX_SYMBOLS_PER_PACKET              $max_symbols_per_packet
		    set_instance_parameter_value    linebuf_ctrl   DROP_INVALID_FIELDS                 $drop_invalid_fields
		    set_instance_parameter_value    linebuf_ctrl   SRC_WIDTH                           $src_width
		    set_instance_parameter_value    linebuf_ctrl   DST_WIDTH                           $dst_width
		    set_instance_parameter_value    linebuf_ctrl   CONTEXT_WIDTH                       $context_width
		    set_instance_parameter_value    linebuf_ctrl   TASK_WIDTH                          $task_width


	        # Video input bridge
	        add_instance                    video_in    alt_vip_video_input_bridge          $isVersion
	        set_instance_parameter_value    video_in    BITS_PER_SYMBOL                     $bits_per_symbol
	        set_instance_parameter_value    video_in    COLOR_PLANES_ARE_IN_PARALLEL        $color_planes_are_in_parallel
	        set_instance_parameter_value    video_in    NUMBER_OF_COLOR_PLANES              $number_of_color_planes
	        set_instance_parameter_value    video_in    DEFAULT_LINE_LENGTH                 $max_width
	        set_instance_parameter_value    video_in    PIXELS_IN_PARALLEL                  $pixels_in_parallel
	        set_instance_parameter_value    video_in    READY_LATENCY_1                     $ready_latency
	        set_instance_parameter_value    video_in    VIB_MODE                            FULL
	        set_instance_parameter_value    video_in    ENABLE_RESOLUTION_CHECK             0
	        set_instance_parameter_value    video_in    MULTI_CONTEXT_SUPPORT               0
	        set_instance_parameter_value    video_in    SRC_WIDTH                           $src_width
	        set_instance_parameter_value    video_in    DST_WIDTH                           $dst_width
	        set_instance_parameter_value    video_in    TASK_WIDTH                          $task_width
	        set_instance_parameter_value    video_in    CONTEXT_WIDTH                       $context_width


	        add_instance                    sop_realign    alt_vip_pip_sop_realign   $isVersion
	        set_instance_parameter_value    sop_realign    PIXEL_WIDTH               $data_width
	        set_instance_parameter_value    sop_realign    PIXELS_IN_PARALLEL        $pixels_in_parallel
	        set_instance_parameter_value    sop_realign    PIPELINE_READY            0


	        add_instance                    line_stats     alt_vip_line_stats        $isVersion
	        set_instance_parameter_value    line_stats     PIXEL_WIDTH               $data_width
	        set_instance_parameter_value    line_stats     PIXELS_IN_PARALLEL        $pixels_in_parallel
	        set_instance_parameter_value    line_stats     PIPELINE_READY            0


	        # Packet transfer WR
	        add_instance                    pkt_trans_wr   alt_vip_packet_transfer             $isVersion
	        set_instance_parameter_value    pkt_trans_wr   CLOCKS_ARE_SEPARATE                 $clocks_are_separate
	        set_instance_parameter_value    pkt_trans_wr   DATA_WIDTH                          $pkt_trans_width
	        set_instance_parameter_value    pkt_trans_wr   ELEMENTS_IN_PARALLEL                $pixels_in_parallel
	        set_instance_parameter_value    pkt_trans_wr   SYMBOLS_IN_SEQ                      $symbols_in_seq
	        set_instance_parameter_value    pkt_trans_wr   MEM_PORT_WIDTH                      $mem_port_width
	        set_instance_parameter_value    pkt_trans_wr   MEM_ADDR_WIDTH                      32
	        set_instance_parameter_value    pkt_trans_wr   WRITE_HAS_PRIORITY                  1
	        set_instance_parameter_value    pkt_trans_wr   SRC_WIDTH                           $src_width
	        set_instance_parameter_value    pkt_trans_wr   DST_WIDTH                           $dst_width
	        set_instance_parameter_value    pkt_trans_wr   TASK_WIDTH                          $task_width
	        set_instance_parameter_value    pkt_trans_wr   CONTEXT_WIDTH                       $context_width
	        set_instance_parameter_value    pkt_trans_wr   WRITE_ENABLE                        1
	        set_instance_parameter_value    pkt_trans_wr   SUPPORT_BEATS_OVERFLOW_PRETECTION   0
	        set_instance_parameter_value    pkt_trans_wr   ENABLE_MANY_COMMAND_WRITE           0
	        set_instance_parameter_value    pkt_trans_wr   ENABLE_PERIOD_MODE_WRITE            0
	        set_instance_parameter_value    pkt_trans_wr   ENABLE_MM_OUTPUT_REGISTER           1
	        set_instance_parameter_value    pkt_trans_wr   MAX_PACKET_SIZE_WRITE               $pkt_trans_max_len
	        set_instance_parameter_value    pkt_trans_wr   MAX_PACKET_NUM_WRITE                1
	        set_instance_parameter_value    pkt_trans_wr   USE_RESPONSE_WRITE                  1
	        set_instance_parameter_value    pkt_trans_wr   RESPONSE_DETINATION_ID_WRITE        0
	        set_instance_parameter_value    pkt_trans_wr   RESPONSE_SOURCE_ID_WRITE            0
	        set_instance_parameter_value    pkt_trans_wr   PIPELINE_READY_WRITE                0
	        set_instance_parameter_value    pkt_trans_wr   COMB_OUTPUT_WRITE                   0
	        set_instance_parameter_value    pkt_trans_wr   MAX_CONTEXT_NUMBER_WRITE            1
	        set_instance_parameter_value    pkt_trans_wr   CONTEXT_BUFFER_RATIO_WRITE          $write_buffer_ratio
	        set_instance_parameter_value    pkt_trans_wr   BURST_TARGET_WRITE                  $write_burst_target
	        set_instance_parameter_value    pkt_trans_wr   READ_ENABLE                         0

	        # Packet transfer RD
	        add_instance                    pkt_trans_rd   alt_vip_packet_transfer             $isVersion
	        set_instance_parameter_value    pkt_trans_rd   CLOCKS_ARE_SEPARATE                 $clocks_are_separate
	        set_instance_parameter_value    pkt_trans_rd   DATA_WIDTH                          $pkt_trans_width
	        set_instance_parameter_value    pkt_trans_rd   ELEMENTS_IN_PARALLEL                $pixels_in_parallel
	        set_instance_parameter_value    pkt_trans_rd   SYMBOLS_IN_SEQ                      $symbols_in_seq
	        set_instance_parameter_value    pkt_trans_rd   MEM_PORT_WIDTH                      $mem_port_width
	        set_instance_parameter_value    pkt_trans_rd   MEM_ADDR_WIDTH                      32
	        set_instance_parameter_value    pkt_trans_rd   WRITE_HAS_PRIORITY                  1
	        set_instance_parameter_value    pkt_trans_rd   SRC_WIDTH                           $src_width
	        set_instance_parameter_value    pkt_trans_rd   DST_WIDTH                           $dst_width
	        set_instance_parameter_value    pkt_trans_rd   TASK_WIDTH                          $task_width
	        set_instance_parameter_value    pkt_trans_rd   CONTEXT_WIDTH                       $context_width
	        set_instance_parameter_value    pkt_trans_rd   WRITE_ENABLE                        0
	        set_instance_parameter_value    pkt_trans_rd   READ_ENABLE                         1
	        set_instance_parameter_value    pkt_trans_rd   ENABLE_MANY_COMMAND_READ            0
	        set_instance_parameter_value    pkt_trans_rd   ENABLE_PERIOD_MODE_READ             0
	        set_instance_parameter_value    pkt_trans_rd   MAX_PACKET_SIZE_READ                $pkt_trans_max_len
	        set_instance_parameter_value    pkt_trans_rd   PREFETCH_THRESHOLD_READ             0
	        set_instance_parameter_value    pkt_trans_rd   ENABLE_COMMAND_BUFFER_READ          1
	        set_instance_parameter_value    pkt_trans_rd   MAX_CONTEXT_NUMBER_READ             1
	        set_instance_parameter_value    pkt_trans_rd   CONTEXT_BUFFER_RATIO_READ           $read_buffer_ratio
	        set_instance_parameter_value    pkt_trans_rd   LOGIC_ONLY_SCFIFO_READ              0
	        set_instance_parameter_value    pkt_trans_rd   OUTPUT_MSG_QUEUE_DEPTH_READ         2
	        set_instance_parameter_value    pkt_trans_rd   MM_MSG_QUEUE_DEPTH_READ             4
	        set_instance_parameter_value    pkt_trans_rd   PIPELINE_READY_READ                 1
	        set_instance_parameter_value    pkt_trans_rd   COMB_OUTPUT_READ                    0
	        set_instance_parameter_value    pkt_trans_rd   BURST_TARGET_READ                   $read_burst_target
	        set_instance_parameter_value    pkt_trans_rd   DOUT_MAX_DESTINATION_ID_NUM_READ    1
	        set_instance_parameter_value    pkt_trans_rd   DOUT_SOURCE_ID_READ                 1

	        # Video output bridge
	        add_instance                    video_out   alt_vip_video_output_bridge         $isVersion
	        set_instance_parameter_value    video_out   BITS_PER_SYMBOL                     $bits_per_symbol
	        set_instance_parameter_value    video_out   COLOR_PLANES_ARE_IN_PARALLEL        $color_planes_are_in_parallel
	        set_instance_parameter_value    video_out   NUMBER_OF_COLOR_PLANES              $number_of_color_planes
	        set_instance_parameter_value    video_out   PIXELS_IN_PARALLEL                  $pixels_in_parallel
	        set_instance_parameter_value    video_out   READY_LATENCY_1                     $ready_latency
	        set_instance_parameter_value    video_out   SOP_PRE_ALIGNED                     1
	        set_instance_parameter_value    video_out   MULTI_CONTEXT_SUPPORT               0
	        set_instance_parameter_value    video_out   NO_CONCATENATION                    0
	        set_instance_parameter_value    video_out   SRC_WIDTH                           $src_width
	        set_instance_parameter_value    video_out   DST_WIDTH                           $dst_width
	        set_instance_parameter_value    video_out   TASK_WIDTH                          $task_width
	        set_instance_parameter_value    video_out   CONTEXT_WIDTH                       $context_width

    } else {

	    # input/write side
	    if {!$is_frame_reader} {
	        # Video input bridge
	        add_instance                    video_in    alt_vip_video_input_bridge          $isVersion
	        set_instance_parameter_value    video_in    BITS_PER_SYMBOL                     $bits_per_symbol
	        set_instance_parameter_value    video_in    COLOR_PLANES_ARE_IN_PARALLEL        $color_planes_are_in_parallel
	        set_instance_parameter_value    video_in    NUMBER_OF_COLOR_PLANES              $number_of_color_planes
	        set_instance_parameter_value    video_in    DEFAULT_LINE_LENGTH                 $max_width
	        set_instance_parameter_value    video_in    PIXELS_IN_PARALLEL                  $pixels_in_parallel
	        set_instance_parameter_value    video_in    READY_LATENCY_1                     $ready_latency
	        set_instance_parameter_value    video_in    VIB_MODE                            LITE
	        set_instance_parameter_value    video_in    ENABLE_RESOLUTION_CHECK             0
	        set_instance_parameter_value    video_in    MULTI_CONTEXT_SUPPORT               0
	        set_instance_parameter_value    video_in    SRC_WIDTH                           $src_width
	        set_instance_parameter_value    video_in    DST_WIDTH                           $dst_width
	        set_instance_parameter_value    video_in    TASK_WIDTH                          $task_width
	        set_instance_parameter_value    video_in    CONTEXT_WIDTH                       $context_width

	        # Write Controller
	        add_instance                    wr_ctrl     alt_vip_vfb_wr_ctrl                 $isVersion
	        set_instance_parameter_value    wr_ctrl     MAX_WIDTH                           $max_width
	        set_instance_parameter_value    wr_ctrl     MAX_HEIGHT                          $max_height
	        set_instance_parameter_value    wr_ctrl     COLOR_PLANES_ARE_IN_PARALLEL        $color_planes_are_in_parallel
	        set_instance_parameter_value    wr_ctrl     NUMBER_OF_COLOR_PLANES              $number_of_color_planes
	        set_instance_parameter_value    wr_ctrl     BITS_PER_SYMBOL                     $bits_per_symbol
	        set_instance_parameter_value    wr_ctrl     PIXELS_IN_PARALLEL                  $pixels_in_parallel
	        set_instance_parameter_value    wr_ctrl     MAX_SYMBOLS_IN_ANC_PACKET           $max_symbols_per_packet
	        set_instance_parameter_value    wr_ctrl     SRC_WIDTH                           $src_width
	        set_instance_parameter_value    wr_ctrl     DST_WIDTH                           $dst_width
	        set_instance_parameter_value    wr_ctrl     CONTEXT_WIDTH                       $context_width
	        set_instance_parameter_value    wr_ctrl     TASK_WIDTH                          $task_width
	        set_instance_parameter_value    wr_ctrl     PRIORITIZE_FMAX                      $prioritize_fmax

	        # Packet transfer WR
	        add_instance                    pkt_trans_wr   alt_vip_packet_transfer             $isVersion
	        set_instance_parameter_value    pkt_trans_wr   CLOCKS_ARE_SEPARATE                 $clocks_are_separate
	        set_instance_parameter_value    pkt_trans_wr   DATA_WIDTH                          $pkt_trans_width
	        set_instance_parameter_value    pkt_trans_wr   ELEMENTS_IN_PARALLEL                $pixels_in_parallel
	        set_instance_parameter_value    pkt_trans_wr   SYMBOLS_IN_SEQ                      $symbols_in_seq
	        set_instance_parameter_value    pkt_trans_wr   MEM_PORT_WIDTH                      $mem_port_width
	        set_instance_parameter_value    pkt_trans_wr   MEM_ADDR_WIDTH                      32
	        set_instance_parameter_value    pkt_trans_wr   WRITE_HAS_PRIORITY                  1
	        set_instance_parameter_value    pkt_trans_wr   SRC_WIDTH                           $src_width
	        set_instance_parameter_value    pkt_trans_wr   DST_WIDTH                           $dst_width
	        set_instance_parameter_value    pkt_trans_wr   TASK_WIDTH                          $task_width
	        set_instance_parameter_value    pkt_trans_wr   CONTEXT_WIDTH                       $context_width
	        set_instance_parameter_value    pkt_trans_wr   WRITE_ENABLE                        1
	        set_instance_parameter_value    pkt_trans_wr   SUPPORT_BEATS_OVERFLOW_PRETECTION   0
	        set_instance_parameter_value    pkt_trans_wr   ENABLE_MANY_COMMAND_WRITE           0
	        set_instance_parameter_value    pkt_trans_wr   ENABLE_PERIOD_MODE_WRITE            0
	        set_instance_parameter_value    pkt_trans_wr   ENABLE_MM_OUTPUT_REGISTER           1
	        set_instance_parameter_value    pkt_trans_wr   MAX_PACKET_SIZE_WRITE               $pkt_trans_max_len
	        set_instance_parameter_value    pkt_trans_wr   MAX_PACKET_NUM_WRITE                1
	        set_instance_parameter_value    pkt_trans_wr   USE_RESPONSE_WRITE                  0
	        set_instance_parameter_value    pkt_trans_wr   RESPONSE_DETINATION_ID_WRITE        0
	        set_instance_parameter_value    pkt_trans_wr   RESPONSE_SOURCE_ID_WRITE            0
	        set_instance_parameter_value    pkt_trans_wr   PIPELINE_READY_WRITE                0
	        set_instance_parameter_value    pkt_trans_wr   COMB_OUTPUT_WRITE                   0
	        set_instance_parameter_value    pkt_trans_wr   MAX_CONTEXT_NUMBER_WRITE            1
	        set_instance_parameter_value    pkt_trans_wr   CONTEXT_BUFFER_RATIO_WRITE          $write_buffer_ratio
	        set_instance_parameter_value    pkt_trans_wr   BURST_TARGET_WRITE                  $write_burst_target
	        set_instance_parameter_value    pkt_trans_wr   READ_ENABLE                         0
	    }

	    # output/read side
	    if {!$is_frame_writer} {
	        # Read Controller
	        add_instance                    rd_ctrl     alt_vip_vfb_rd_ctrl                 $isVersion
	        set_instance_parameter_value    rd_ctrl     COLOR_PLANES_ARE_IN_PARALLEL        $color_planes_are_in_parallel
	        set_instance_parameter_value    rd_ctrl     NUMBER_OF_COLOR_PLANES              $number_of_color_planes
	        set_instance_parameter_value    rd_ctrl     BITS_PER_SYMBOL                     $bits_per_symbol
	        set_instance_parameter_value    rd_ctrl     PIXELS_IN_PARALLEL                  $pixels_in_parallel
	        set_instance_parameter_value    rd_ctrl     SRC_WIDTH                           $src_width
	        set_instance_parameter_value    rd_ctrl     DST_WIDTH                           $dst_width
	        set_instance_parameter_value    rd_ctrl     CONTEXT_WIDTH                       $context_width
	        set_instance_parameter_value    rd_ctrl     TASK_WIDTH                          $task_width
	        set_instance_parameter_value    rd_ctrl     PRIORITIZE_FMAX                     $prioritize_fmax

	        # Video output bridge
	        add_instance                    video_out   alt_vip_video_output_bridge         $isVersion
	        set_instance_parameter_value    video_out   BITS_PER_SYMBOL                     $bits_per_symbol
	        set_instance_parameter_value    video_out   COLOR_PLANES_ARE_IN_PARALLEL        $color_planes_are_in_parallel
	        set_instance_parameter_value    video_out   NUMBER_OF_COLOR_PLANES              $number_of_color_planes
	        set_instance_parameter_value    video_out   PIXELS_IN_PARALLEL                  $pixels_in_parallel
	        set_instance_parameter_value    video_out   READY_LATENCY_1                     $ready_latency
	        set_instance_parameter_value    video_out   SOP_PRE_ALIGNED                     1
	        set_instance_parameter_value    video_out   MULTI_CONTEXT_SUPPORT               0
	        set_instance_parameter_value    video_out   NO_CONCATENATION                    1
	        set_instance_parameter_value    video_out   SRC_WIDTH                           $src_width
	        set_instance_parameter_value    video_out   DST_WIDTH                           $dst_width
	        set_instance_parameter_value    video_out   TASK_WIDTH                          $task_width
	        set_instance_parameter_value    video_out   CONTEXT_WIDTH                       $context_width

	        # Packet transfer RD
	        add_instance                    pkt_trans_rd   alt_vip_packet_transfer             $isVersion
	        set_instance_parameter_value    pkt_trans_rd   CLOCKS_ARE_SEPARATE                 $clocks_are_separate
	        set_instance_parameter_value    pkt_trans_rd   DATA_WIDTH                          $pkt_trans_width
	        set_instance_parameter_value    pkt_trans_rd   ELEMENTS_IN_PARALLEL                $pixels_in_parallel
	        set_instance_parameter_value    pkt_trans_rd   SYMBOLS_IN_SEQ                      $symbols_in_seq
	        set_instance_parameter_value    pkt_trans_rd   MEM_PORT_WIDTH                      $mem_port_width
	        set_instance_parameter_value    pkt_trans_rd   MEM_ADDR_WIDTH                      32
	        set_instance_parameter_value    pkt_trans_rd   WRITE_HAS_PRIORITY                  1
	        set_instance_parameter_value    pkt_trans_rd   SRC_WIDTH                           $src_width
	        set_instance_parameter_value    pkt_trans_rd   DST_WIDTH                           $dst_width
	        set_instance_parameter_value    pkt_trans_rd   TASK_WIDTH                          $task_width
	        set_instance_parameter_value    pkt_trans_rd   CONTEXT_WIDTH                       $context_width
	        set_instance_parameter_value    pkt_trans_rd   WRITE_ENABLE                        0
	        set_instance_parameter_value    pkt_trans_rd   READ_ENABLE                         1
	        set_instance_parameter_value    pkt_trans_rd   ENABLE_MANY_COMMAND_READ            0
	        set_instance_parameter_value    pkt_trans_rd   ENABLE_PERIOD_MODE_READ             0
	        set_instance_parameter_value    pkt_trans_rd   MAX_PACKET_SIZE_READ                $pkt_trans_max_len
	        set_instance_parameter_value    pkt_trans_rd   PREFETCH_THRESHOLD_READ             0
	        set_instance_parameter_value    pkt_trans_rd   ENABLE_COMMAND_BUFFER_READ          1
	        set_instance_parameter_value    pkt_trans_rd   MAX_CONTEXT_NUMBER_READ             1
	        set_instance_parameter_value    pkt_trans_rd   CONTEXT_BUFFER_RATIO_READ           $read_buffer_ratio
	        set_instance_parameter_value    pkt_trans_rd   LOGIC_ONLY_SCFIFO_READ              0
	        set_instance_parameter_value    pkt_trans_rd   OUTPUT_MSG_QUEUE_DEPTH_READ         2
	        set_instance_parameter_value    pkt_trans_rd   MM_MSG_QUEUE_DEPTH_READ             4
	        set_instance_parameter_value    pkt_trans_rd   PIPELINE_READY_READ                 1
	        set_instance_parameter_value    pkt_trans_rd   COMB_OUTPUT_READ                    0
	        set_instance_parameter_value    pkt_trans_rd   BURST_TARGET_READ                   $read_burst_target
	        set_instance_parameter_value    pkt_trans_rd   DOUT_MAX_DESTINATION_ID_NUM_READ    1
	        set_instance_parameter_value    pkt_trans_rd   DOUT_SOURCE_ID_READ                 1
	    }

	    # Sync controller
	    add_instance                    sync_ctrl   alt_vip_vfb_sync_ctrl               $isVersion
	    set_instance_parameter_value    sync_ctrl   MAX_WIDTH                           $max_width
	    set_instance_parameter_value    sync_ctrl   MAX_HEIGHT                          $max_height
	    set_instance_parameter_value    sync_ctrl   ANC_BUFFER_LENGTH                   $anc_buffer_length
	    set_instance_parameter_value    sync_ctrl   FRAME_BUFFER_LENGTH                 $frame_buffer_length
	    set_instance_parameter_value    sync_ctrl   NUM_BUFFERS                         $num_buffers
	    set_instance_parameter_value    sync_ctrl   WRITER_RUNTIME_CONTROL              $writer_runtime_control
	    set_instance_parameter_value    sync_ctrl   READER_RUNTIME_CONTROL              $reader_runtime_control
	    set_instance_parameter_value    sync_ctrl   DROP_FRAMES                         $drop_frames
	    set_instance_parameter_value    sync_ctrl   REPEAT_FRAMES                       $repeat_frames
	    set_instance_parameter_value    sync_ctrl   DROP_REPEAT_USER                    $drop_repeat_user
	    set_instance_parameter_value    sync_ctrl   MULTI_FRAME_DELAY                   $multi_frame_delay
	    set_instance_parameter_value    sync_ctrl   MEM_BASE_ADDR                       $mem_base_addr
	    set_instance_parameter_value    sync_ctrl   USER_PACKETS_MAX_STORAGE            $user_packets_max_storage
	    set_instance_parameter_value    sync_ctrl   MAX_SYMBOLS_PER_PACKET              $max_symbols_per_packet
	    set_instance_parameter_value    sync_ctrl   INTERLACED_SUPPORT                  $interlaced_support
	    set_instance_parameter_value    sync_ctrl   CONTROLLED_DROP_REPEAT              $controlled_drop_repeat
	    set_instance_parameter_value    sync_ctrl   DROP_INVALID_FIELDS                 $drop_invalid_fields
	    set_instance_parameter_value    sync_ctrl   IS_FRAME_WRITER                     $is_frame_writer
	    set_instance_parameter_value    sync_ctrl   IS_FRAME_READER                     $is_frame_reader
	    set_instance_parameter_value    sync_ctrl   IS_SYNC_MASTER                      $is_sync_master
	    set_instance_parameter_value    sync_ctrl   IS_SYNC_SLAVE                       $is_sync_slave
	    set_instance_parameter_value    sync_ctrl   SRC_WIDTH                           $src_width
	    set_instance_parameter_value    sync_ctrl   DST_WIDTH                           $dst_width
	    set_instance_parameter_value    sync_ctrl   CONTEXT_WIDTH                       $context_width
	    set_instance_parameter_value    sync_ctrl   TASK_WIDTH                          $task_width

	}
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Connection of sub-components                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc vfb_composition_callback_connections {} {

    set clocks_are_separate         [get_parameter_value CLOCKS_ARE_SEPARATE]
    set is_frame_reader             [get_parameter_value IS_FRAME_READER]
    set is_frame_writer             [get_parameter_value IS_FRAME_WRITER]
    set is_sync_master              [get_parameter_value IS_SYNC_MASTER]
    set is_sync_slave               [get_parameter_value IS_SYNC_SLAVE]
    set writer_runtime_control      [get_parameter_value WRITER_RUNTIME_CONTROL]
    set reader_runtime_control      [get_parameter_value READER_RUNTIME_CONTROL]
    set is_line_based_buffering     [get_parameter_value LINE_BASED_BUFFERING]

    # --------------------------------------------------------------------------------------------------
    # -- External interfaces                                                                          --
    # --------------------------------------------------------------------------------------------------
    add_interface                   main_clock          clock               end
    set_interface_property          main_clock          export_of           av_st_clk_bridge.in_clk
    set_interface_property          main_clock          PORT_NAME_MAP       {main_clock in_clk}

    add_interface                   main_reset          reset               end
    set_interface_property          main_reset          export_of           av_st_reset_bridge.in_reset
    set_interface_property          main_reset          PORT_NAME_MAP       {main_reset in_reset}

    if {$clocks_are_separate} {
        add_interface               mem_clock           clock               end
        set_interface_property      mem_clock           export_of           av_mm_clk_bridge.in_clk
        set_interface_property      mem_clock           PORT_NAME_MAP       {mem_clock in_clk}

        add_interface               mem_reset           reset               end
        set_interface_property      mem_reset           export_of           av_mm_reset_bridge.in_reset
        set_interface_property      mem_reset           PORT_NAME_MAP       {mem_reset in_reset}
    }

    if {!$is_frame_reader} {
        add_interface               din                 avalon_streaming    sink
        set_interface_property      din                 export_of           video_in.av_st_vid_din

        add_interface               mem_master_wr       avalon              master
        set_interface_property      mem_master_wr       export_of           pkt_trans_wr.av_mm_master
    }

    if {!$is_frame_writer} {
        add_interface               dout                avalon_streaming    source
        set_interface_property      dout                export_of           video_out.av_st_vid_dout

        add_interface               mem_master_rd       avalon              master
        set_interface_property      mem_master_rd       export_of           pkt_trans_rd.av_mm_master
    }

    if {$is_frame_writer && !$is_line_based_buffering} {
        add_interface               control_interrupt   interrupt           sender
        set_interface_property      control_interrupt   export_of           sync_ctrl.writer_control_interrupt
    }

    if {$is_frame_reader && !$is_line_based_buffering} {
        add_interface               control_interrupt   interrupt           sender
        set_interface_property      control_interrupt   export_of           sync_ctrl.reader_control_interrupt
    }


    if {$writer_runtime_control && !$is_line_based_buffering} {
        add_interface               control             avalon              slave
        set_interface_property      control             export_of           sync_ctrl.writer_control
    }

    if {$reader_runtime_control && !$is_line_based_buffering} {
        add_interface               control             avalon              slave
        set_interface_property      control             export_of           sync_ctrl.reader_control
    }

    if {$is_line_based_buffering} {
#todo copied these from above, not linking, dont know why
        #add_interface               control_interrupt   interrupt           sender
        #set_interface_property      control_interrupt   export_of           linebuf_ctrl.writer_control_interrupt
        add_interface               control             avalon              slave
        set_interface_property      control             export_of           linebuf_ctrl.writer_control
    }

#    if {$is_sync_master} {
#    }
#
#    if {$is_sync_slave} {
#    }

    # --------------------------------------------------------------------------------------------------
    # -- Connecting clocks and resets                                                                 --
    # --------------------------------------------------------------------------------------------------
    # AvST clock, reset
    add_connection                  av_st_clk_bridge.out_clk            av_st_reset_bridge.clk

    if {$is_line_based_buffering} {
        add_connection              av_st_clk_bridge.out_clk            video_in.main_clock
        add_connection              av_st_reset_bridge.out_reset        video_in.main_reset
        add_connection              av_st_clk_bridge.out_clk            sop_realign.main_clock
        add_connection              av_st_reset_bridge.out_reset        sop_realign.main_reset
        add_connection              av_st_clk_bridge.out_clk            line_stats.main_clock
        add_connection              av_st_reset_bridge.out_reset        line_stats.main_reset
        add_connection              av_st_clk_bridge.out_clk            linebuf_ctrl.main_clock
        add_connection              av_st_reset_bridge.out_reset        linebuf_ctrl.main_reset
        add_connection              av_st_clk_bridge.out_clk            pkt_trans_wr.av_st_clock
        add_connection              av_st_reset_bridge.out_reset        pkt_trans_wr.av_st_reset
        add_connection              av_st_clk_bridge.out_clk            video_out.main_clock
        add_connection              av_st_reset_bridge.out_reset        video_out.main_reset
        add_connection              av_st_clk_bridge.out_clk            pkt_trans_rd.av_st_clock
        add_connection              av_st_reset_bridge.out_reset        pkt_trans_rd.av_st_reset

        add_connection              av_mm_clk_bridge.out_clk            av_mm_reset_bridge.clk
        add_connection          	av_mm_clk_bridge.out_clk            pkt_trans_wr.av_mm_clock
        add_connection          	av_mm_reset_bridge.out_reset        pkt_trans_wr.av_mm_reset
        add_connection          	av_mm_clk_bridge.out_clk            pkt_trans_rd.av_mm_clock
        add_connection          	av_mm_reset_bridge.out_reset        pkt_trans_rd.av_mm_reset
	 } else {

	    if {!$is_frame_reader} {
	        add_connection              av_st_clk_bridge.out_clk            video_in.main_clock
	        add_connection              av_st_reset_bridge.out_reset        video_in.main_reset
	        add_connection              av_st_clk_bridge.out_clk            wr_ctrl.main_clock
	        add_connection              av_st_reset_bridge.out_reset        wr_ctrl.main_reset
	        add_connection              av_st_clk_bridge.out_clk            pkt_trans_wr.av_st_clock
	        add_connection              av_st_reset_bridge.out_reset        pkt_trans_wr.av_st_reset
	    }

	    if {!$is_frame_writer} {
	        add_connection              av_st_clk_bridge.out_clk            rd_ctrl.main_clock
	        add_connection              av_st_reset_bridge.out_reset        rd_ctrl.main_reset
	        add_connection              av_st_clk_bridge.out_clk            video_out.main_clock
	        add_connection              av_st_reset_bridge.out_reset        video_out.main_reset
	        add_connection              av_st_clk_bridge.out_clk            pkt_trans_rd.av_st_clock
	        add_connection              av_st_reset_bridge.out_reset        pkt_trans_rd.av_st_reset
	    }

	    add_connection                  av_st_clk_bridge.out_clk            sync_ctrl.main_clock
	    add_connection                  av_st_reset_bridge.out_reset        sync_ctrl.main_reset

	    # AvMM clock, reset
	    if ($clocks_are_separate) {
	        add_connection              av_mm_clk_bridge.out_clk            av_mm_reset_bridge.clk

	        if {!$is_frame_reader} {
	            add_connection          av_mm_clk_bridge.out_clk            pkt_trans_wr.av_mm_clock
	            add_connection          av_mm_reset_bridge.out_reset        pkt_trans_wr.av_mm_reset
	        }
	        if {!$is_frame_writer} {
	            add_connection          av_mm_clk_bridge.out_clk            pkt_trans_rd.av_mm_clock
	            add_connection          av_mm_reset_bridge.out_reset        pkt_trans_rd.av_mm_reset
	        }
	    }
	}
    # --------------------------------------------------------------------------------------------------
    # -- Interblocks connections                                                                      --
    # --------------------------------------------------------------------------------------------------
    if {$is_line_based_buffering} {
	        add_connection              video_in.av_st_dout                 sop_realign.av_st_din
	        add_connection              sop_realign.av_st_dout              line_stats.av_st_din
	        add_connection              line_stats.av_st_dout               pkt_trans_wr.av_st_din

	        add_connection              video_in.av_st_resp                 linebuf_ctrl.vib_resp

	        add_connection              linebuf_ctrl.vib_cmd                video_in.av_st_cmd
	        add_connection              linebuf_ctrl.pkt_wr_cmd             pkt_trans_wr.av_st_cmd
	        add_connection              linebuf_ctrl.vob_cmd                video_out.av_st_cmd
	        add_connection              linebuf_ctrl.pkt_rd_cmd             pkt_trans_rd.av_st_cmd

	        add_connection              pkt_trans_wr.av_st_resp             linebuf_ctrl.pkt_wr_resp

	        add_connection              pkt_trans_rd.av_st_dout             video_out.av_st_din

	        add_connection              line_stats.av_st_resp               linebuf_ctrl.line_stats_resp

    } else {
    	if {!$is_frame_reader} {
	        add_connection              video_in.av_st_dout                 wr_ctrl.vib_data
	        add_connection              video_in.av_st_resp                 wr_ctrl.vib_resp
	        add_connection              wr_ctrl.vib_cmd                     video_in.av_st_cmd
	        add_connection              wr_ctrl.pkt_wr_cmd                  pkt_trans_wr.av_st_cmd
	        add_connection              wr_ctrl.pkt_wr_data                 pkt_trans_wr.av_st_din
	        add_connection              wr_ctrl.sync_resp                   sync_ctrl.wr_resp
	        add_connection              sync_ctrl.wr_cmd                    wr_ctrl.sync_cmd
	    }

	    if {!$is_frame_writer} {
	        add_connection              rd_ctrl.vob_data                    video_out.av_st_din
	        add_connection              rd_ctrl.vob_cmd                     video_out.av_st_cmd
	        add_connection              rd_ctrl.pkt_rd_cmd                  pkt_trans_rd.av_st_cmd
	        add_connection              pkt_trans_rd.av_st_dout             rd_ctrl.pkt_rd_data
	        add_connection              rd_ctrl.sync_resp                   sync_ctrl.rd_resp
	        add_connection              sync_ctrl.rd_cmd                    rd_ctrl.sync_cmd
	    }
	}


}


