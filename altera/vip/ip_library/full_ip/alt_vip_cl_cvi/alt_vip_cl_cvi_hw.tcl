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
#--                                                                                               --
#-- _hw.tcl compose file for Clocked Video Input II                                               --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME alt_vip_cl_cvi
set_module_property DISPLAY_NAME "Clocked Video Input II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION "The Clocked Video Input II converts standard video formats such as BT656 and VGA to Avalon-ST Video."

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_parameter BPS INTEGER 8
set_parameter_property BPS DISPLAY_NAME "Bits per pixel per color plane"
set_parameter_property BPS ALLOWED_RANGES 4:20
set_parameter_property BPS HDL_PARAMETER true
set_parameter_property BPS DISPLAY_UNITS "bits"
set_parameter_property BPS AFFECTS_ELABORATION true
set_parameter_property BPS AFFECTS_GENERATION true
set_parameter_property BPS DESCRIPTION "The number of bits used per pixel, per color plane."

add_parameter NUMBER_OF_COLOUR_PLANES INTEGER 3
set_parameter_property NUMBER_OF_COLOUR_PLANES DISPLAY_NAME "Number of color planes"
set_parameter_property NUMBER_OF_COLOUR_PLANES ALLOWED_RANGES 1:4
set_parameter_property NUMBER_OF_COLOUR_PLANES HDL_PARAMETER true
set_parameter_property NUMBER_OF_COLOUR_PLANES AFFECTS_ELABORATION true
set_parameter_property NUMBER_OF_COLOUR_PLANES AFFECTS_GENERATION true
set_parameter_property NUMBER_OF_COLOUR_PLANES DESCRIPTION "The number of color planes per pixel."

add_parameter COLOUR_PLANES_ARE_IN_PARALLEL INTEGER 1
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DISPLAY_NAME "Color plane transmission format"
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL ALLOWED_RANGES {0:Sequence 1:Parallel}
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER true
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DISPLAY_HINT radio
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL AFFECTS_ELABORATION true
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL AFFECTS_GENERATION true
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DESCRIPTION "The color planes are arranged in parallel, otherwise in sequence."

add_pixels_in_parallel_parameters

add_parameter SYNC_TO INTEGER 0
set_parameter_property SYNC_TO DISPLAY_NAME "Field order"
set_parameter_property SYNC_TO ALLOWED_RANGES {"0:Field 0 first" "1:Field 1 first" "2:Any field first"}
set_parameter_property SYNC_TO HDL_PARAMETER true
set_parameter_property SYNC_TO AFFECTS_ELABORATION true
set_parameter_property SYNC_TO AFFECTS_GENERATION true
set_parameter_property SYNC_TO DESCRIPTION "The field that is output first when syncing to a new video input."

add_parameter NO_OF_CHANNELS INTEGER 1
set_parameter_property NO_OF_CHANNELS DISPLAY_NAME "Number of channels"
set_parameter_property NO_OF_CHANNELS ALLOWED_RANGES 1,2,4
set_parameter_property NO_OF_CHANNELS HDL_PARAMETER false
set_parameter_property NO_OF_CHANNELS AFFECTS_ELABORATION true
set_parameter_property NO_OF_CHANNELS AFFECTS_GENERATION true
set_parameter_property NO_OF_CHANNELS VISIBLE false
set_parameter_property NO_OF_CHANNELS DESCRIPTION "The number of video streams that can be time division multiplexed through the Clocked Video Input."

add_parameter MATCH_CTRLDATA_PKT_CLIP_BASIC INTEGER 0
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC DISPLAY_NAME "Enable matching data packet to control by clipping"
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC ALLOWED_RANGES 0:1
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC HDL_PARAMETER true
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC AFFECTS_ELABORATION true
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC AFFECTS_GENERATION true
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC DISPLAY_HINT boolean
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC DESCRIPTION "Enable clipping of input's width and height to match the values specified in control packet. Padding not supported."

add_parameter MATCH_CTRLDATA_PKT_PAD_ADV INTEGER 0
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV DISPLAY_NAME "Enable matching data packet to control by padding"
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV ALLOWED_RANGES 0:1
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV HDL_PARAMETER true
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV AFFECTS_ELABORATION true
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV AFFECTS_GENERATION true
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV DISPLAY_HINT boolean
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV DESCRIPTION "Enable padding of input's width and height with a dummy data to match the values specified in control packet. Works only when clipping is enabled. Warning: Input frames might get dropped in the process."

add_parameter OVERFLOW_HANDLING INTEGER 0
set_parameter_property OVERFLOW_HANDLING DISPLAY_NAME "Overflow handling"
set_parameter_property OVERFLOW_HANDLING ALLOWED_RANGES 0:1
set_parameter_property OVERFLOW_HANDLING HDL_PARAMETER true
set_parameter_property OVERFLOW_HANDLING AFFECTS_ELABORATION true
set_parameter_property OVERFLOW_HANDLING AFFECTS_GENERATION true
set_parameter_property OVERFLOW_HANDLING DISPLAY_HINT boolean
set_parameter_property OVERFLOW_HANDLING DESCRIPTION "Enable to finish frames with dummy data after overflow instead of immediate closure of data packet. Warning: Input frames might get dropped in the process."

add_display_item "Avalon-ST-Video Image Data Format" BPS parameter
add_display_item "Avalon-ST-Video Image Data Format" NUMBER_OF_COLOUR_PLANES parameter
add_display_item "Avalon-ST-Video Image Data Format" COLOUR_PLANES_ARE_IN_PARALLEL parameter
add_display_item "Avalon-ST-Video Image Data Format" PIXELS_IN_PARALLEL parameter
add_display_item "Avalon-ST-Video Image Data Format" SYNC_TO parameter
add_display_item "Avalon-ST-Video Image Data Format" NO_OF_CHANNELS parameter
add_display_item "Avalon-ST-Video Image Data Format" MATCH_CTRLDATA_PKT_CLIP_BASIC parameter
add_display_item "Avalon-ST-Video Image Data Format" MATCH_CTRLDATA_PKT_PAD_ADV parameter
add_display_item "Avalon-ST-Video Image Data Format" OVERFLOW_HANDLING parameter

add_parameter USE_EMBEDDED_SYNCS INTEGER 0
set_parameter_property USE_EMBEDDED_SYNCS DISPLAY_NAME "Sync signals"
set_parameter_property USE_EMBEDDED_SYNCS ALLOWED_RANGES {"1:Embedded in video" "0:On separate wires"}
set_parameter_property USE_EMBEDDED_SYNCS HDL_PARAMETER true
set_parameter_property USE_EMBEDDED_SYNCS DISPLAY_HINT radio
set_parameter_property USE_EMBEDDED_SYNCS AFFECTS_ELABORATION true
set_parameter_property USE_EMBEDDED_SYNCS AFFECTS_GENERATION true
set_parameter_property USE_EMBEDDED_SYNCS DESCRIPTION "Extract sync signals that are embedded in the video data, otherwise use separate sync signals."

add_parameter USE_HDMI_DEPRICATION INTEGER 0
set_parameter_property USE_HDMI_DEPRICATION DISPLAY_NAME "Enable HDMI Duplicate Pixel Removal"
set_parameter_property USE_HDMI_DEPRICATION ALLOWED_RANGES {"0:No duplicate pixel removal" "1:Remove duplicate pixels"}
set_parameter_property USE_HDMI_DEPRICATION HDL_PARAMETER true
set_parameter_property USE_HDMI_DEPRICATION DISPLAY_HINT boolean
set_parameter_property USE_HDMI_DEPRICATION AFFECTS_ELABORATION true
set_parameter_property USE_HDMI_DEPRICATION AFFECTS_GENERATION true
set_parameter_property USE_HDMI_DEPRICATION DESCRIPTION "Enable a block that will remove duplicate pixels for low rate resolutions. Only 2 Pixels in parallel with duplication factor of 0/2 currently supported"

add_parameter ACCEPT_COLOURS_IN_SEQ INTEGER 0
set_parameter_property ACCEPT_COLOURS_IN_SEQ DISPLAY_NAME "Allow color planes in sequence input"
set_parameter_property ACCEPT_COLOURS_IN_SEQ ALLOWED_RANGES 0:1
set_parameter_property ACCEPT_COLOURS_IN_SEQ HDL_PARAMETER false
set_parameter_property ACCEPT_COLOURS_IN_SEQ DISPLAY_HINT boolean
set_parameter_property ACCEPT_COLOURS_IN_SEQ AFFECTS_ELABORATION true
set_parameter_property ACCEPT_COLOURS_IN_SEQ AFFECTS_GENERATION true
set_parameter_property ACCEPT_COLOURS_IN_SEQ DESCRIPTION "Include the vid_hd_sdn input signal that enables input of sequential or parallel color plane arrangements."

add_parameter GENERATE_VID_F INTEGER 0
set_parameter_property GENERATE_VID_F DISPLAY_NAME "Extract field signal"
set_parameter_property GENERATE_VID_F ALLOWED_RANGES 0:1
set_parameter_property GENERATE_VID_F HDL_PARAMETER true
set_parameter_property GENERATE_VID_F DISPLAY_HINT boolean
set_parameter_property GENERATE_VID_F AFFECTS_ELABORATION true
set_parameter_property GENERATE_VID_F AFFECTS_GENERATION true
set_parameter_property GENERATE_VID_F DESCRIPTION "Enable the extraction of the field signal from the position of the v sync (use with DVI)"

add_parameter USE_STD INTEGER 0
set_parameter_property USE_STD DISPLAY_NAME "Use vid_std bus"
set_parameter_property USE_STD ALLOWED_RANGES 0:1
set_parameter_property USE_STD HDL_PARAMETER true
set_parameter_property USE_STD AFFECTS_ELABORATION true
set_parameter_property USE_STD AFFECTS_GENERATION true
set_parameter_property USE_STD DISPLAY_HINT boolean
set_parameter_property USE_STD DESCRIPTION "Include the vid_std input bus which allows the current standard to be read from the register map."

add_parameter STD_WIDTH INTEGER 1
set_parameter_property STD_WIDTH DISPLAY_NAME "Width of vid_std bus"
set_parameter_property STD_WIDTH ALLOWED_RANGES 1:16
set_parameter_property STD_WIDTH HDL_PARAMETER true
set_parameter_property STD_WIDTH DISPLAY_UNITS "bits"
set_parameter_property STD_WIDTH AFFECTS_ELABORATION true
set_parameter_property STD_WIDTH AFFECTS_GENERATION true
set_parameter_property STD_WIDTH DESCRIPTION "Sets the width in bits of the vid_std bus."

add_parameter GENERATE_ANC INTEGER 0
set_parameter_property GENERATE_ANC DISPLAY_NAME "Extract ancillary packets"
set_parameter_property GENERATE_ANC ALLOWED_RANGES 0:1
set_parameter_property GENERATE_ANC HDL_PARAMETER true
set_parameter_property GENERATE_ANC DISPLAY_HINT boolean
set_parameter_property GENERATE_ANC AFFECTS_ELABORATION true
set_parameter_property GENERATE_ANC AFFECTS_GENERATION true
set_parameter_property GENERATE_ANC DESCRIPTION "Enable the extraction of ancillary packets."

add_parameter ANC_DEPTH INTEGER 1
set_parameter_property ANC_DEPTH DISPLAY_NAME "Depth of the ancilliary memory"
set_parameter_property ANC_DEPTH ALLOWED_RANGES 0:4096
set_parameter_property ANC_DEPTH HDL_PARAMETER true
set_parameter_property ANC_DEPTH DISPLAY_UNITS "words"
set_parameter_property ANC_DEPTH AFFECTS_ELABORATION true
set_parameter_property ANC_DEPTH AFFECTS_GENERATION true
set_parameter_property ANC_DEPTH DESCRIPTION "The depth of the memory used to store ancillary packets."

add_parameter EXTRACT_TOTAL_RESOLUTION INTEGER 1
set_parameter_property EXTRACT_TOTAL_RESOLUTION DISPLAY_NAME "Extract the total resolution"
set_parameter_property EXTRACT_TOTAL_RESOLUTION ALLOWED_RANGES 0:1
set_parameter_property EXTRACT_TOTAL_RESOLUTION HDL_PARAMETER true
set_parameter_property EXTRACT_TOTAL_RESOLUTION DISPLAY_HINT boolean
set_parameter_property EXTRACT_TOTAL_RESOLUTION AFFECTS_ELABORATION true
set_parameter_property EXTRACT_TOTAL_RESOLUTION AFFECTS_GENERATION true
set_parameter_property EXTRACT_TOTAL_RESOLUTION DESCRIPTION "Extract the total resolution from the video stream."

add_display_item "Clocked Video Parameters" USE_EMBEDDED_SYNCS parameter
add_display_item "Clocked Video Parameters" ACCEPT_COLOURS_IN_SEQ parameter
add_display_item "Clocked Video Parameters" GENERATE_VID_F parameter
add_display_item "Clocked Video Parameters" USE_STD parameter
add_display_item "Clocked Video Parameters" STD_WIDTH parameter
add_display_item "Clocked Video Parameters" GENERATE_ANC parameter
add_display_item "Clocked Video Parameters" ANC_DEPTH parameter
add_display_item "Clocked Video Parameters" EXTRACT_TOTAL_RESOLUTION parameter
add_display_item "Clocked Video Parameters" USE_HDMI_DEPRICATION parameter

add_parameter INTERLACED INTEGER 0
set_parameter_property INTERLACED DISPLAY_NAME "Interlaced or progressive"
set_parameter_property INTERLACED ALLOWED_RANGES {0:Progressive 1:Interlaced}
set_parameter_property INTERLACED HDL_PARAMETER true
set_parameter_property INTERLACED DISPLAY_HINT radio
set_parameter_property INTERLACED AFFECTS_ELABORATION true
set_parameter_property INTERLACED AFFECTS_GENERATION true
set_parameter_property INTERLACED DESCRIPTION "Before the video format has been detected it defaults to interlaced or progressive."

add_parameter H_ACTIVE_PIXELS_F0 INTEGER 1920
set_parameter_property H_ACTIVE_PIXELS_F0 DISPLAY_NAME "Width"
set_parameter_property H_ACTIVE_PIXELS_F0 ALLOWED_RANGES 32:8192
set_parameter_property H_ACTIVE_PIXELS_F0 HDL_PARAMETER true
set_parameter_property H_ACTIVE_PIXELS_F0 DISPLAY_UNITS "pixels"
set_parameter_property H_ACTIVE_PIXELS_F0 AFFECTS_ELABORATION true
set_parameter_property H_ACTIVE_PIXELS_F0 AFFECTS_GENERATION true
set_parameter_property H_ACTIVE_PIXELS_F0 DESCRIPTION "Before the video format has been detected it defaults to this width."

add_parameter V_ACTIVE_LINES_F0 INTEGER 1080
set_parameter_property V_ACTIVE_LINES_F0 DISPLAY_NAME "Height - frame/field 0"
set_parameter_property V_ACTIVE_LINES_F0 ALLOWED_RANGES 32:8192
set_parameter_property V_ACTIVE_LINES_F0 HDL_PARAMETER true
set_parameter_property V_ACTIVE_LINES_F0 DISPLAY_UNITS "pixels"
set_parameter_property V_ACTIVE_LINES_F0 AFFECTS_ELABORATION true
set_parameter_property V_ACTIVE_LINES_F0 AFFECTS_GENERATION true
set_parameter_property V_ACTIVE_LINES_F0 DESCRIPTION "Before the video format has been detected it defaults to this height."

add_parameter V_ACTIVE_LINES_F1 INTEGER 480
set_parameter_property V_ACTIVE_LINES_F1 DISPLAY_NAME "Height - field 1"
set_parameter_property V_ACTIVE_LINES_F1 ALLOWED_RANGES 32:4096
set_parameter_property V_ACTIVE_LINES_F1 HDL_PARAMETER true
set_parameter_property V_ACTIVE_LINES_F1 DISPLAY_UNITS "pixels"
set_parameter_property V_ACTIVE_LINES_F1 AFFECTS_ELABORATION true
set_parameter_property V_ACTIVE_LINES_F1 AFFECTS_GENERATION true
set_parameter_property V_ACTIVE_LINES_F1 DESCRIPTION "Before the video format has been detected it defaults to this height."

add_display_item "Avalon-ST-Video Initial Control Packet" INTERLACED parameter
add_display_item "Avalon-ST-Video Initial Control Packet" H_ACTIVE_PIXELS_F0 parameter
add_display_item "Avalon-ST-Video Initial Control Packet" V_ACTIVE_LINES_F0 parameter
add_display_item "Avalon-ST-Video Initial Control Packet" V_ACTIVE_LINES_F1 parameter

add_parameter FIFO_DEPTH INTEGER 2048
set_parameter_property FIFO_DEPTH DISPLAY_NAME "Pixel FIFO size"
set_parameter_property FIFO_DEPTH ALLOWED_RANGES 32,64,128,256,512,1024,2048,4096,8192
set_parameter_property FIFO_DEPTH HDL_PARAMETER true
set_parameter_property FIFO_DEPTH DISPLAY_UNITS "pixels"
set_parameter_property FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property FIFO_DEPTH AFFECTS_GENERATION true
set_parameter_property FIFO_DEPTH DESCRIPTION "The depth of the FIFO that is used for clock crossing and back-pressure absorbing."

add_parameter CLOCKS_ARE_SAME INTEGER 0
set_parameter_property CLOCKS_ARE_SAME DISPLAY_NAME "Video in and out use the same clock"
set_parameter_property CLOCKS_ARE_SAME ALLOWED_RANGES 0:1
set_parameter_property CLOCKS_ARE_SAME HDL_PARAMETER true
set_parameter_property CLOCKS_ARE_SAME DISPLAY_HINT boolean
set_parameter_property CLOCKS_ARE_SAME AFFECTS_ELABORATION true
set_parameter_property CLOCKS_ARE_SAME AFFECTS_GENERATION true
set_parameter_property CLOCKS_ARE_SAME DESCRIPTION "Turn on if the video clock and the system clock are the same."

add_parameter USE_CONTROL INTEGER 0
set_parameter_property USE_CONTROL DISPLAY_NAME "Use control port"
set_parameter_property USE_CONTROL ALLOWED_RANGES 0:1
set_parameter_property USE_CONTROL HDL_PARAMETER true
set_parameter_property USE_CONTROL DISPLAY_HINT boolean
set_parameter_property USE_CONTROL AFFECTS_ELABORATION true
set_parameter_property USE_CONTROL AFFECTS_GENERATION true
set_parameter_property USE_CONTROL DESCRIPTION "Enable the Avalon-MM slave port that can be used for control."


add_display_item "General Parameters" FIFO_DEPTH parameter
add_display_item "General Parameters" CLOCKS_ARE_SAME parameter
add_display_item "General Parameters" USE_CONTROL parameter


set_module_property VALIDATION_CALLBACK cvi_validation_callback

proc cvi_validation_callback {} {
    set use_embedded_syncs [get_parameter_value USE_EMBEDDED_SYNCS]
    if { $use_embedded_syncs == 1} {
        set_parameter_property NUMBER_OF_COLOUR_PLANES ALLOWED_RANGES 2
        set_parameter_property BPS ALLOWED_RANGES 8,10
		set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES 1
        set_parameter_property GENERATE_VID_F ENABLED false
        set_parameter_property GENERATE_ANC ENABLED true
        set_parameter_property ANC_DEPTH ENABLED true
        set_parameter_property USE_HDMI_DEPRICATION ENABLED false
    } else {
        set_parameter_property NUMBER_OF_COLOUR_PLANES ALLOWED_RANGES 1:4
        set_parameter_property BPS ALLOWED_RANGES 4:20
		set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1,2,4,8}
        set_parameter_property GENERATE_VID_F ENABLED true
        set_parameter_property GENERATE_ANC ENABLED false
        set_parameter_property ANC_DEPTH ENABLED false
        set_parameter_property USE_HDMI_DEPRICATION ENABLED true
    }

    set interlaced [get_parameter_value INTERLACED]
    if { $interlaced == 0} {
        set_parameter_property V_ACTIVE_LINES_F1 ENABLED false
    } else {
        set_parameter_property V_ACTIVE_LINES_F1 ENABLED true
    }

    set colour_planes_are_in_parallel [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
    if { $colour_planes_are_in_parallel == 1 } {
        set_parameter_property ACCEPT_COLOURS_IN_SEQ ENABLED true

		set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC ENABLED true
		set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV ENABLED true
		set_parameter_property OVERFLOW_HANDLING ENABLED true
    } else {
        set_parameter_property ACCEPT_COLOURS_IN_SEQ ENABLED false

		set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC ENABLED false
		set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV ENABLED false
		set_parameter_property OVERFLOW_HANDLING ENABLED false
    }

    set match_ctrldata_pkt_clip_basic_t [get_parameter_value MATCH_CTRLDATA_PKT_CLIP_BASIC]
    if { $match_ctrldata_pkt_clip_basic_t == 1 } {
        set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV ENABLED true
    } else {
        set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV ENABLED false
    }

    set use_std_temp [get_parameter_value USE_STD]
    if { $use_std_temp == 1 } {
        set_parameter_property STD_WIDTH ENABLED true
    } else {
        set_parameter_property STD_WIDTH ENABLED false
    }
}

set_module_property COMPOSITION_CALLBACK cvi_composition_callback

proc cvi_composition_callback {} {
    global isVersion acdsVersion

    set no_of_channels [get_parameter_value NO_OF_CHANNELS]
    if { $no_of_channels == 4 } {
        set channel_width 2
    } else {
        set channel_width 1
    }
    if { $no_of_channels == 1 } {
        set use_channel 0
    } else {
        set use_channel 1
    }
    set fifo_depth [get_parameter_value FIFO_DEPTH]
    set pow_2_fifo_depth [expr pow(2, [clogb2_pure $fifo_depth])]
    set pixels_in_parallel [get_parameter_value PIXELS_IN_PARALLEL]

    set match_ctrldata_pkt_clip_basic [get_parameter_value MATCH_CTRLDATA_PKT_CLIP_BASIC]
    if { $match_ctrldata_pkt_clip_basic == 0 } {
        set match_ctrldata_pkt_pad_adv 0
    } else {
        set match_ctrldata_pkt_pad_adv [get_parameter_value MATCH_CTRLDATA_PKT_PAD_ADV]
    }

    set use_std [get_parameter_value USE_STD]
    if { $use_std == 0 } {
        set std_width 1
    } else {
        set std_width [get_parameter_value STD_WIDTH]
    }

    # The chain of components to compose :
    add_instance cvi_core alt_vip_cvi_core $isVersion

    add_instance video_out alt_vip_video_output_bridge $isVersion

    set_instance_parameter_value   video_out   VIDEO_PROTOCOL_NO             1
    set_instance_parameter_value   video_out   SRC_WIDTH                     0
    set_instance_parameter_value   video_out   DST_WIDTH                     0
    set_instance_parameter_value   video_out   CONTEXT_WIDTH                 0
    set_instance_parameter_value   video_out   TASK_WIDTH                    1

    add_instance   av_st_clk_bridge     altera_clock_bridge            $acdsVersion
    add_instance   av_st_reset_bridge   altera_reset_bridge            $acdsVersion

    add_connection   av_st_clk_bridge.out_clk               cvi_core.main_clock
    add_connection   av_st_clk_bridge.out_clk               video_out.main_clock
    add_connection   av_st_clk_bridge.out_clk               av_st_reset_bridge.clk

    add_connection   av_st_reset_bridge.out_reset   cvi_core.main_reset
    add_connection   av_st_reset_bridge.out_reset   video_out.main_reset

    add_interface   main_clock          clock               end
    set_interface_property   main_clock         export_of   av_st_clk_bridge.in_clk

    add_interface   main_reset          reset               end
    set_interface_property   main_reset         export_of   av_st_reset_bridge.in_reset

    add_interface   dout_0                avalon_streaming    source
    set_interface_property   dout_0               export_of   video_out.av_st_vid_dout

    add_interface   clocked_video       conduit             sink
    set_interface_property   clocked_video      export_of   cvi_core.clocked_video


    set_instance_parameter_value    cvi_core    USE_EMBEDDED_SYNCS              [get_parameter_value USE_EMBEDDED_SYNCS]
    set_instance_parameter_value    cvi_core    USE_STD                         $use_std
    set_instance_parameter_value    cvi_core    STD_WIDTH                       $std_width
    set_instance_parameter_value    cvi_core    BPS                             [get_parameter_value BPS]
    set_instance_parameter_value    cvi_core    GENERATE_ANC                    [get_parameter_value GENERATE_ANC]
    set_instance_parameter_value    cvi_core    GENERATE_VID_F                  [get_parameter_value GENERATE_VID_F]
    set_instance_parameter_value    cvi_core    CLOCKS_ARE_SAME                 [get_parameter_value CLOCKS_ARE_SAME]
    set_instance_parameter_value    cvi_core    NUMBER_OF_COLOUR_PLANES         [get_parameter_value NUMBER_OF_COLOUR_PLANES]
    set_instance_parameter_value    cvi_core    COLOUR_PLANES_ARE_IN_PARALLEL   [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
    set_instance_parameter_value    cvi_core    PIXELS_IN_PARALLEL              $pixels_in_parallel
    set_instance_parameter_value    cvi_core    FIFO_DEPTH                      $pow_2_fifo_depth
    set_instance_parameter_value    cvi_core    INTERLACED                      [get_parameter_value INTERLACED]
    set_instance_parameter_value    cvi_core    H_ACTIVE_PIXELS                 [get_parameter_value H_ACTIVE_PIXELS_F0]
    set_instance_parameter_value    cvi_core    V_ACTIVE_LINES_F0               [get_parameter_value V_ACTIVE_LINES_F0]
    set_instance_parameter_value    cvi_core    V_ACTIVE_LINES_F1               [get_parameter_value V_ACTIVE_LINES_F1]
    set_instance_parameter_value    cvi_core    SYNC_TO                         [get_parameter_value SYNC_TO]
    set_instance_parameter_value    cvi_core    MATCH_CTRLDATA_PKT_CLIP_BASIC   $match_ctrldata_pkt_clip_basic
    set_instance_parameter_value    cvi_core    MATCH_CTRLDATA_PKT_PAD_ADV      $match_ctrldata_pkt_pad_adv
    set_instance_parameter_value    cvi_core    OVERFLOW_HANDLING               [get_parameter_value OVERFLOW_HANDLING]
    set_instance_parameter_value    cvi_core    ANC_DEPTH                       [get_parameter_value ANC_DEPTH]
    set_instance_parameter_value    cvi_core    USE_CHANNEL                     $use_channel
    set_instance_parameter_value    cvi_core    CHANNEL_WIDTH                   $channel_width
    set_instance_parameter_value    cvi_core    USE_CONTROL                     [get_parameter_value USE_CONTROL]
    set_instance_parameter_value    cvi_core    ACCEPT_COLOURS_IN_SEQ           [get_parameter_value ACCEPT_COLOURS_IN_SEQ]
    set_instance_parameter_value    cvi_core    EXTRACT_TOTAL_RESOLUTION        [get_parameter_value EXTRACT_TOTAL_RESOLUTION]
    set_instance_parameter_value    cvi_core    USE_HDMI_DEPRICATION            [get_parameter_value USE_HDMI_DEPRICATION]

    set_instance_parameter_value    video_out   BITS_PER_SYMBOL                 [get_parameter_value BPS]
    set_instance_parameter_value    video_out   NUMBER_OF_COLOR_PLANES          [get_parameter_value NUMBER_OF_COLOUR_PLANES]
    set_instance_parameter_value    video_out   COLOR_PLANES_ARE_IN_PARALLEL    [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
    set_instance_parameter_value    video_out   PIXELS_IN_PARALLEL              $pixels_in_parallel
    set_instance_parameter_value    video_out   LOW_LATENCY_COMMAND_MODE        1
    set_instance_parameter_value    video_out   SOP_PRE_ALIGNED                 1
    set_instance_parameter_value    video_out   NO_CONCATENATION                0


#    if { $pixels_in_parallel > 1 } {
#        set_instance_parameter_value    cvi_core    SEND_LINES 1
#        set_instance_parameter_value    video_out   SEND_LINES 1
#    } else {
        set_instance_parameter_value    cvi_core    SEND_LINES 0
#        set_instance_parameter_value    video_out   SEND_LINES 0
#    }

    add_connection   cvi_core.dout  video_out.av_st_din
    add_connection   cvi_core.cmd   video_out.av_st_cmd

    set use_control [get_parameter_value USE_CONTROL]
    if { $use_control } {
        add_interface   control             avalon              slave
        set_interface_property   control            export_of   cvi_core.control

        add_interface   status_update_irq   interrupt           end
        set_interface_property   status_update_irq  export_of   cvi_core.status_update_irq
    }
}

