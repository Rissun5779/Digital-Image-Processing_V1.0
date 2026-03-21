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


source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP components
declare_general_component_info

#General Info
set_module_property NAME alt_vip_cvi_core
set_module_property DISPLAY_NAME "alt_vip_cvi_core"
set_module_property DESCRIPTION ""

# Files
add_alt_vip_common_pkg_files ../..
add_alt_vip_common_event_packet_encode_files ../..
add_alt_vip_common_fifo_files ../..
add_alt_vip_common_sync_files ../..
add_static_sv_file src_hdl/alt_vip_cvi_register_addresses.sv
add_static_sv_file src_hdl/alt_vip_cvi_core.sv
add_static_sv_file src_hdl/alt_vip_cvi_av_st_output.sv
add_static_sv_file src_hdl/alt_vip_cvi_control.sv
add_static_sv_file src_hdl/alt_vip_cvi_embedded_sync_extractor.sv
add_static_sv_file src_hdl/alt_vip_cvi_resolution_detection.sv
add_static_sv_file src_hdl/alt_vip_cvi_sample_counter.v
add_static_sv_file src_hdl/alt_vip_cvi_sync_conditioner.sv
add_static_sv_file src_hdl/alt_vip_cvi_sync_polarity_convertor.v
add_static_sv_file src_hdl/alt_vip_cvi_write_buffer_fifo.sv
add_static_sv_file src_hdl/alt_vip_cvi_sync_align.sv
add_static_sv_file src_hdl/alt_vip_cvi_pixel_deprication.sv

add_static_misc_file  src_hdl/alt_vip_cvi_core.ocp
add_static_sdc_file alt_vip_cvi_core.sdc .

setup_filesets alt_vip_cvi_core

#Properties

add_parameter USE_EMBEDDED_SYNCS INTEGER 0
set_parameter_property USE_EMBEDDED_SYNCS DISPLAY_NAME "Sync signals"
set_parameter_property USE_EMBEDDED_SYNCS ALLOWED_RANGES {"1:Embedded in video" "0:On separate wires"}
set_parameter_property USE_EMBEDDED_SYNCS HDL_PARAMETER true
set_parameter_property USE_EMBEDDED_SYNCS DISPLAY_HINT radio
set_parameter_property USE_EMBEDDED_SYNCS DESCRIPTION "Extract sync signals that are embedded in the video data, otherwise use separate sync signals."

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
set_parameter_property STD_WIDTH DESCRIPTION "Sets the width in bits of the vid_std bus."

add_parameter BPS INTEGER 8
set_parameter_property BPS DISPLAY_NAME "Bits per pixel per color plane"
set_parameter_property BPS ALLOWED_RANGES 4:20
set_parameter_property BPS HDL_PARAMETER true
set_parameter_property BPS DISPLAY_UNITS "bits"
set_parameter_property BPS DESCRIPTION "The number of bits used per pixel, per color plane."

add_parameter GENERATE_ANC INTEGER 0
set_parameter_property GENERATE_ANC DISPLAY_NAME "Extract ancillary packets"
set_parameter_property GENERATE_ANC ALLOWED_RANGES 0:1
set_parameter_property GENERATE_ANC HDL_PARAMETER true
set_parameter_property GENERATE_ANC DISPLAY_HINT boolean
set_parameter_property GENERATE_ANC DESCRIPTION "Enable the extraction of ancillary packets."

add_parameter GENERATE_VID_F INTEGER 0
set_parameter_property GENERATE_VID_F DISPLAY_NAME "Extract field signal"
set_parameter_property GENERATE_VID_F ALLOWED_RANGES 0:1
set_parameter_property GENERATE_VID_F HDL_PARAMETER true
set_parameter_property GENERATE_VID_F DISPLAY_HINT boolean
set_parameter_property GENERATE_VID_F DESCRIPTION "Enable the extraction of the field signal from the position of the v sync (use with DVI)"

add_parameter CLOCKS_ARE_SAME INTEGER 0
set_parameter_property CLOCKS_ARE_SAME DISPLAY_NAME "Video in and out use the same clock"
set_parameter_property CLOCKS_ARE_SAME ALLOWED_RANGES 0:1
set_parameter_property CLOCKS_ARE_SAME HDL_PARAMETER true
set_parameter_property CLOCKS_ARE_SAME DISPLAY_HINT boolean
set_parameter_property CLOCKS_ARE_SAME DESCRIPTION "Turn on if the video clock and the system clock are the same."

add_parameter NUMBER_OF_COLOUR_PLANES INTEGER 3
set_parameter_property NUMBER_OF_COLOUR_PLANES DISPLAY_NAME "Number of color planes"
set_parameter_property NUMBER_OF_COLOUR_PLANES ALLOWED_RANGES 1:4
set_parameter_property NUMBER_OF_COLOUR_PLANES HDL_PARAMETER true
set_parameter_property NUMBER_OF_COLOUR_PLANES DESCRIPTION "The number of color planes per pixel."

add_parameter COLOUR_PLANES_ARE_IN_PARALLEL INTEGER 1
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DISPLAY_NAME "Color plane transmission format"
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL ALLOWED_RANGES {0:Sequence 1:Parallel}
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER true
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DISPLAY_HINT radio
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DESCRIPTION "The color planes are arranged in parallel, otherwise in sequence."

add_parameter PIXELS_IN_PARALLEL INTEGER 1
set_parameter_property PIXELS_IN_PARALLEL DISPLAY_NAME "Number of pixels in parallel"
set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1,2,4,8}
set_parameter_property PIXELS_IN_PARALLEL HDL_PARAMETER true
set_parameter_property PIXELS_IN_PARALLEL DESCRIPTION "The number of color planes per pixel."

add_parameter FIFO_DEPTH INTEGER 2048
set_parameter_property FIFO_DEPTH DISPLAY_NAME "Pixel FIFO size"
set_parameter_property FIFO_DEPTH ALLOWED_RANGES 32,64,128,256,512,1024,2048,4096,8192
set_parameter_property FIFO_DEPTH HDL_PARAMETER true
set_parameter_property FIFO_DEPTH DISPLAY_UNITS "pixels"
set_parameter_property FIFO_DEPTH DESCRIPTION "The depth of the FIFO that is used for clock crossing and back-pressure absorbing."

add_parameter FAMILY string "Cyclone IV"
set_parameter_property FAMILY DISPLAY_NAME "Device family selected"
set_parameter_property FAMILY DESCRIPTION "Current device family selected"
set_parameter_property FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property FAMILY VISIBLE false
set_parameter_property FAMILY HDL_PARAMETER true

add_parameter INTERLACED INTEGER 0
set_parameter_property INTERLACED DISPLAY_NAME "Interlaced or progressive"
set_parameter_property INTERLACED ALLOWED_RANGES {0:Progressive 1:Interlaced}
set_parameter_property INTERLACED HDL_PARAMETER true
set_parameter_property INTERLACED DISPLAY_HINT radio
set_parameter_property INTERLACED DESCRIPTION "Before the video format has been detected it defaults to interlaced or progressive."

add_parameter H_ACTIVE_PIXELS INTEGER 1920
set_parameter_property H_ACTIVE_PIXELS DISPLAY_NAME "Width"
set_parameter_property H_ACTIVE_PIXELS ALLOWED_RANGES 32:65535
set_parameter_property H_ACTIVE_PIXELS HDL_PARAMETER true
set_parameter_property H_ACTIVE_PIXELS DISPLAY_UNITS "pixels"
set_parameter_property H_ACTIVE_PIXELS DESCRIPTION "Before the video format has been detected it defaults to this width."

add_parameter V_ACTIVE_LINES_F0 INTEGER 1080
set_parameter_property V_ACTIVE_LINES_F0 DISPLAY_NAME "Height - frame/field 0"
set_parameter_property V_ACTIVE_LINES_F0 ALLOWED_RANGES 32:65535
set_parameter_property V_ACTIVE_LINES_F0 HDL_PARAMETER true
set_parameter_property V_ACTIVE_LINES_F0 DISPLAY_UNITS "pixels"
set_parameter_property V_ACTIVE_LINES_F0 DESCRIPTION "Before the video format has been detected it defaults to this height."

add_parameter V_ACTIVE_LINES_F1 INTEGER 480
set_parameter_property V_ACTIVE_LINES_F1 DISPLAY_NAME "Height - field 1"
set_parameter_property V_ACTIVE_LINES_F1 ALLOWED_RANGES 32:65535
set_parameter_property V_ACTIVE_LINES_F1 HDL_PARAMETER true
set_parameter_property V_ACTIVE_LINES_F1 DISPLAY_UNITS "pixels"
set_parameter_property V_ACTIVE_LINES_F1 DESCRIPTION "Before the video format has been detected it defaults to this height."

add_parameter SYNC_TO INTEGER 0
set_parameter_property SYNC_TO DISPLAY_NAME "Field order"
set_parameter_property SYNC_TO ALLOWED_RANGES {"0:Field 0 first" "1:Field 1 first" "2:Any field first"}
set_parameter_property SYNC_TO HDL_PARAMETER true
set_parameter_property SYNC_TO DESCRIPTION "The field that is output first when syncing to a new video input."

add_parameter MATCH_CTRLDATA_PKT_CLIP_BASIC INTEGER 0
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC DISPLAY_NAME "Enable matching data packet to control by clipping"
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC ALLOWED_RANGES 0:1
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC HDL_PARAMETER true
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC DISPLAY_HINT boolean
set_parameter_property MATCH_CTRLDATA_PKT_CLIP_BASIC DESCRIPTION "Enable clipping of input's width and height to match the values specified in control packet. Padding not supported."

add_parameter MATCH_CTRLDATA_PKT_PAD_ADV INTEGER 0
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV DISPLAY_NAME "Enable matching data packet to control by padding"
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV ALLOWED_RANGES 0:1
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV HDL_PARAMETER true
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV DISPLAY_HINT boolean
set_parameter_property MATCH_CTRLDATA_PKT_PAD_ADV DESCRIPTION "Enable padding of input's width and height with a dummy data to match the values specified in control packet. Works only when clipping is enabled. Warning: Input frames might get dropped in the process."

add_parameter OVERFLOW_HANDLING INTEGER 0
set_parameter_property OVERFLOW_HANDLING DISPLAY_NAME "Overflow handling"
set_parameter_property OVERFLOW_HANDLING ALLOWED_RANGES 0:1
set_parameter_property OVERFLOW_HANDLING HDL_PARAMETER true
set_parameter_property OVERFLOW_HANDLING DISPLAY_HINT boolean
set_parameter_property OVERFLOW_HANDLING DESCRIPTION "Enable to finish frames with dummy data after overflow instead of immediate closure of data packet. Warning: Input frames might get dropped in the process."

add_parameter USE_CHANNEL INTEGER 0
set_parameter_property USE_CHANNEL DISPLAY_NAME "Include the channel signal"
set_parameter_property USE_CHANNEL ALLOWED_RANGES 0:1
set_parameter_property USE_CHANNEL HDL_PARAMETER true
set_parameter_property USE_CHANNEL DISPLAY_HINT boolean
set_parameter_property USE_CHANNEL DESCRIPTION "Allows time division multiplexing of video streams."

add_parameter CHANNEL_WIDTH INTEGER 1
set_parameter_property CHANNEL_WIDTH DISPLAY_NAME "Width of channel signal"
set_parameter_property CHANNEL_WIDTH ALLOWED_RANGES 1:2
set_parameter_property CHANNEL_WIDTH HDL_PARAMETER true
set_parameter_property CHANNEL_WIDTH DISPLAY_UNITS "bits"
set_parameter_property CHANNEL_WIDTH DESCRIPTION "Sets the width in bits of the channel signal."

add_parameter ANC_DEPTH INTEGER 1
set_parameter_property ANC_DEPTH DISPLAY_NAME "Depth of the ancilliary memory"
set_parameter_property ANC_DEPTH ALLOWED_RANGES 0:256
set_parameter_property ANC_DEPTH HDL_PARAMETER true
set_parameter_property ANC_DEPTH DISPLAY_UNITS "words"
set_parameter_property ANC_DEPTH DESCRIPTION "The depth of the memory used to store ancillary packets."

add_parameter USE_CONTROL INTEGER 0
set_parameter_property USE_CONTROL DISPLAY_NAME "Use control port"
set_parameter_property USE_CONTROL ALLOWED_RANGES 0:1
set_parameter_property USE_CONTROL HDL_PARAMETER true
set_parameter_property USE_CONTROL DISPLAY_HINT boolean
set_parameter_property USE_CONTROL DESCRIPTION "Enable the Avalon-MM slave port that can be used for control."

add_parameter ACCEPT_COLOURS_IN_SEQ INTEGER 0
set_parameter_property ACCEPT_COLOURS_IN_SEQ DISPLAY_NAME "Allow color planes in sequence input"
set_parameter_property ACCEPT_COLOURS_IN_SEQ ALLOWED_RANGES 0:1
set_parameter_property ACCEPT_COLOURS_IN_SEQ HDL_PARAMETER false
set_parameter_property ACCEPT_COLOURS_IN_SEQ DISPLAY_HINT boolean
set_parameter_property ACCEPT_COLOURS_IN_SEQ AFFECTS_ELABORATION true
set_parameter_property ACCEPT_COLOURS_IN_SEQ DESCRIPTION "Include the vid_hd_sdn input signal that enables input of sequential or parallel color plane arrangements."

add_parameter SEND_LINES INTEGER 0
set_parameter_property SEND_LINES DISPLAY_NAME "Send line packets"
set_parameter_property SEND_LINES ALLOWED_RANGES 0:1
set_parameter_property SEND_LINES HDL_PARAMETER true
set_parameter_property SEND_LINES DISPLAY_HINT boolean
set_parameter_property SEND_LINES DESCRIPTION "Send line packets (type 12) instead of frame packets (type 0)."

add_parameter EXTRACT_TOTAL_RESOLUTION INTEGER 1
set_parameter_property EXTRACT_TOTAL_RESOLUTION DISPLAY_NAME "Extract the total resolution"
set_parameter_property EXTRACT_TOTAL_RESOLUTION ALLOWED_RANGES 0:1
set_parameter_property EXTRACT_TOTAL_RESOLUTION HDL_PARAMETER true
set_parameter_property EXTRACT_TOTAL_RESOLUTION DISPLAY_HINT boolean
set_parameter_property EXTRACT_TOTAL_RESOLUTION DESCRIPTION "Extract the total resolution from the video stream."

add_parameter USE_HDMI_DEPRICATION INTEGER 0
set_parameter_property USE_HDMI_DEPRICATION DISPLAY_NAME "Enable HDMI Deprication"
set_parameter_property USE_HDMI_DEPRICATION ALLOWED_RANGES 0:1
set_parameter_property USE_HDMI_DEPRICATION HDL_PARAMETER true
set_parameter_property USE_HDMI_DEPRICATION DISPLAY_HINT boolean
set_parameter_property USE_HDMI_DEPRICATION DESCRIPTION "Enable a block that will remove duplicate pixels for low rate resolutions. Only 2 Pixels in parallel with duplication factor of 0/2 currently supported"

add_interface       main_clock   clock       end
add_interface       main_reset   reset       end       main_clock

add_interface_port  main_clock   is_clk      clk          Input    1
add_interface_port  main_reset   rst         reset        Input    1

#the elaboration callback
set_module_property ELABORATION_CALLBACK cvi_elaboration_callback

proc cvi_elaboration_callback {} {
    set anc_depth [get_parameter_value ANC_DEPTH]
    set anc_width [clogb2_pure [expr $anc_depth + 15]]

    if { $anc_width < 5 } {
        set anc_width 5
    }

    # Control Port
    add_interface control avalon slave main_clock
    set_interface_property control addressAlignment DYNAMIC
    #set_interface_property control addressSpan 8
    set_interface_property control isMemoryDevice 0
    set_interface_property control readWaitTime 0
    set_interface_property control readLatency 2
    set_interface_property control writeWaitTime 0
    #associate control status_update_irq
    add_interface_port control av_address address input $anc_width
    add_interface_port control av_read read input 1
    add_interface_port control av_readdata readdata output 32
    add_interface_port control av_write write input 1
    add_interface_port control av_writedata writedata input 32
    add_interface_port control av_byteenable byteenable input 4
    add_interface_port control av_waitrequest waitrequest output 1

    # interrupt port
    add_interface status_update_irq interrupt end main_clock
    add_interface_port status_update_irq status_update_int irq output 1
    set_interface_property status_update_irq associatedAddressablePoint control

    set use_control [get_parameter_value USE_CONTROL]
    if { $use_control == 0 } {
        set_port_property av_write TERMINATION true
        set_port_property av_write TERMINATION_VALUE 0
        set_port_property av_read TERMINATION true
        set_port_property av_read TERMINATION_VALUE 0
        set_port_property av_address TERMINATION true
        set_port_property av_address TERMINATION_VALUE 0
        set_port_property av_readdata TERMINATION true
        set_port_property av_writedata TERMINATION true
        set_port_property av_writedata TERMINATION_VALUE 0
        set_port_property av_byteenable TERMINATION true
        set_port_property av_byteenable TERMINATION_VALUE 0
        set_port_property av_waitrequest TERMINATION true

        set_port_property status_update_int TERMINATION true
    }

    # Avalon streaming input port
    set color_planes_are_in_parallel [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
    set number_of_color_planes [get_parameter_value NUMBER_OF_COLOUR_PLANES]
    set bps [get_parameter_value BPS]
    set pixels_in_parallel [get_parameter_value PIXELS_IN_PARALLEL]
    set empty_width [expr {($pixels_in_parallel > 1) ? [clogb2_pure $pixels_in_parallel] : 0}]
    set channel_width [get_parameter_value CHANNEL_WIDTH]
    if { $color_planes_are_in_parallel == 0 } {
        set symbols_per_beat 1
        set data_width $bps
    } else {
        set symbols_per_beat $number_of_color_planes
        set data_width [expr ($bps * $number_of_color_planes * $pixels_in_parallel)]
    }
    set output_data_width [expr $data_width + 1 + 2*$empty_width]
    set match_ctrldata_pkt_clip_basic [get_parameter_value MATCH_CTRLDATA_PKT_CLIP_BASIC]
    set match_ctrldata_pkt_pad_adv [get_parameter_value MATCH_CTRLDATA_PKT_PAD_ADV]
    set overflow_handling [get_parameter_value OVERFLOW_HANDLING]
    set use_channel [get_parameter_value USE_CHANNEL]
    set accept_colours_in_seq [get_parameter_value ACCEPT_COLOURS_IN_SEQ]
    set extract_total_resolution [get_parameter_value EXTRACT_TOTAL_RESOLUTION]

    add_interface dout avalon_streaming start main_clock
    set_interface_property dout dataBitsPerSymbol $output_data_width
    set_interface_property dout symbolsPerBeat 1
    set_interface_property dout readyLatency 0
    add_interface_port dout av_st_dout_data data output $output_data_width
    add_interface_port dout av_st_dout_valid valid output 1
    add_interface_port dout av_st_dout_ready ready input 1
    add_interface_port dout av_st_dout_startofpacket startofpacket output 1
    add_interface_port dout av_st_dout_endofpacket endofpacket output 1
    add_interface_port dout av_st_dout_channel channel output $channel_width
    if { $use_channel == 0 } {
        set_port_property av_st_dout_channel TERMINATION true
    }

    add_interface cmd avalon_streaming start main_clock
    set_interface_property cmd dataBitsPerSymbol 33
    set_interface_property cmd symbolsPerBeat 1
    set_interface_property cmd readyLatency 0
    add_interface_port cmd av_st_cmd_data data output 33
    add_interface_port cmd av_st_cmd_valid valid output 1
    add_interface_port cmd av_st_cmd_ready ready input 1
    add_interface_port cmd av_st_cmd_startofpacket startofpacket output 1
    add_interface_port cmd av_st_cmd_endofpacket endofpacket output 1

    # Video signals - SOPC Builder needs to treat these as asynchronous signals
    set use_std [get_parameter_value USE_STD]
    set std_width [get_parameter_value STD_WIDTH]

    add_interface clocked_video conduit end
    add_interface_port clocked_video vid_clk vid_clk input 1
    add_interface_port clocked_video vid_data vid_data input $data_width
    add_interface_port clocked_video vid_de vid_de input $pixels_in_parallel
    add_interface_port clocked_video vid_datavalid vid_datavalid input 1
    add_interface_port clocked_video vid_locked vid_locked input 1
    add_interface_port clocked_video vid_channel vid_channel input $channel_width
    if { $use_channel == 0 } {
        set_port_property vid_channel TERMINATION true
        set_port_property vid_channel TERMINATION_VALUE 0
    }

    add_interface_port clocked_video vid_f vid_f input $pixels_in_parallel
    add_interface_port clocked_video vid_v_sync vid_v_sync input $pixels_in_parallel
    add_interface_port clocked_video vid_h_sync vid_h_sync input $pixels_in_parallel
    add_interface_port clocked_video vid_hd_sdn vid_hd_sdn input 1
    if { $color_planes_are_in_parallel == 1 } {
        if { $accept_colours_in_seq == 0 } {
            set_port_property vid_hd_sdn TERMINATION true
            set_port_property vid_hd_sdn TERMINATION_VALUE 1
        }
    } else {
        set_port_property vid_hd_sdn TERMINATION true
        set_port_property vid_hd_sdn TERMINATION_VALUE 0
    }
    add_interface_port clocked_video vid_std vid_std input $std_width
    if { $use_std == 0 } {
        set_port_property vid_std TERMINATION       true
        set_port_property vid_std TERMINATION_VALUE 0
    }
    add_interface_port clocked_video vid_color_encoding vid_color_encoding input 8
    add_interface_port clocked_video vid_bit_width vid_bit_width input 8
    add_interface_port clocked_video vid_total_sample_count vid_total_sample_count input 16
    add_interface_port clocked_video vid_total_line_count vid_total_line_count input 16
    if { $extract_total_resolution == 1} {
        set_port_property vid_total_sample_count TERMINATION true
        set_port_property vid_total_sample_count TERMINATION_VALUE 0
        set_port_property vid_total_line_count TERMINATION true
        set_port_property vid_total_line_count TERMINATION_VALUE 0
    }

    add_interface_port clocked_video sof sof output 1
    add_interface_port clocked_video sof_locked sof_locked output 1
    add_interface_port clocked_video refclk_div refclk_div output 1
    
    add_interface_port clocked_video clipping clipping output 1
    add_interface_port clocked_video padding padding output 1
    add_interface_port clocked_video overflow overflow output 1
    add_interface_port clocked_video vid_hdmi_duplication vid_hdmi_duplication input 4

    set use_hdmi_deprication [get_parameter_value USE_HDMI_DEPRICATION]
    if { $use_hdmi_deprication == 0} {
        set_port_property vid_hdmi_duplication TERMINATION       true
        set_port_property vid_hdmi_duplication TERMINATION_VALUE 0
    }    
    
}

