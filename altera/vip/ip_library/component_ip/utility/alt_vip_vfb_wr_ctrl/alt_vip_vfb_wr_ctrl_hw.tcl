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
# -- General information for the alt_vip_vfb_wr_ctrl module                                       --
# -- This block sequences commands to the packet transfer block to write a frame, under the       --
# -- higher level control of the sync controller.  Data is passed through.                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_vfb_wr_ctrl
set_module_property DISPLAY_NAME "Frame Buffer Write Controller"
set_module_property Description  "Controls write side of frame buffer"

set_module_property ELABORATION_CALLBACK wr_ctrl_elaboration_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_vfb_wr_ctrl.sv

add_static_misc_file src_hdl/alt_vip_vfb_wr_ctrl.ocp

setup_filesets alt_vip_vfb_wr_ctrl

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

add_parameter           MAX_SYMBOLS_IN_ANC_PACKET   INTEGER             10
set_parameter_property  MAX_SYMBOLS_IN_ANC_PACKET   DISPLAY_NAME        "Maximum symbols ancillary packet"
set_parameter_property  MAX_SYMBOLS_IN_ANC_PACKET   ALLOWED_RANGES      1:16384
set_parameter_property  MAX_SYMBOLS_IN_ANC_PACKET   DESCRIPTION         "Maximum number of symbols in each ancillary packets"
set_parameter_property  MAX_SYMBOLS_IN_ANC_PACKET   HDL_PARAMETER       true
set_parameter_property  MAX_SYMBOLS_IN_ANC_PACKET   AFFECTS_ELABORATION false

add_parameter           PRIORITIZE_FMAX        INTEGER             0
set_parameter_property  PRIORITIZE_FMAX        DISPLAY_NAME        "Prioritize Fmax"
set_parameter_property  PRIORITIZE_FMAX        ALLOWED_RANGES      0:1
set_parameter_property  PRIORITIZE_FMAX        DESCRIPTION         "Enable padding of pixels up to 32 bits to increase Fmax at the cost of increased DDR bandwidth"
set_parameter_property  PRIORITIZE_FMAX        HDL_PARAMETER       true
set_parameter_property  PRIORITIZE_FMAX        AFFECTS_ELABORATION true

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
#localparam DOUT_DATA_WIDTH                  = PRIORITIZE_FMAX ? 32 * PIXELS_IN_PARALLEL : DATA_WIDTH;

proc wr_ctrl_elaboration_callback {} {
    set bits_per_symbol                 [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes          [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set color_planes_are_in_parallel    [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pixels_in_parallel              [get_parameter_value PIXELS_IN_PARALLEL]
    set prioritize_fmax                 [get_parameter_value PRIORITIZE_FMAX]

    if {$color_planes_are_in_parallel} {
        set data_width_sink          [expr $bits_per_symbol * $number_of_color_planes]
        set data_width_source        [expr $prioritize_fmax ? 32 : $bits_per_symbol * $number_of_color_planes]
        #send_message info "WR_CTRL_HW.TCL : data_width with prioritize_fmax == $prioritize_fmax is [expr $prioritize_fmax ? 32 : $bits_per_symbol * $number_of_color_planes]"
    } else {
        set data_width_sink          [expr $bits_per_symbol]
        set data_width_source        [expr $bits_per_symbol]
    }

    set src_width           [get_parameter_value SRC_WIDTH]
    set dst_width           [get_parameter_value DST_WIDTH]
    set context_width       [get_parameter_value CONTEXT_WIDTH]
    set task_width          [get_parameter_value TASK_WIDTH]

    # vib interface: data input, resp input and cmd output
    add_av_st_data_sink_port   vib_data  $data_width_sink  $pixels_in_parallel  $dst_width  $src_width  $task_width  $context_width  0  main_clock  0
    add_av_st_cmd_source_port  vib_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_resp_sink_port   vib_resp 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0

    # packet transfer interface: data output and cmd output
    add_av_st_cmd_source_port  pkt_wr_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_data_source_port pkt_wr_data  $data_width_source  $pixels_in_parallel  $dst_width  $src_width  $task_width  $context_width  0  main_clock  0

    # sync controller interface: resp output and cmd input
    add_av_st_cmd_sink_port    sync_cmd  1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
    add_av_st_resp_source_port sync_resp 1  $dst_width  $src_width  $task_width  $context_width  main_clock  0
}
