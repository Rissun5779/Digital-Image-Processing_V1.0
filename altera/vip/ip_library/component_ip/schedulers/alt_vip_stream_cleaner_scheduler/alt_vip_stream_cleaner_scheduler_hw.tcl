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
# -- General information for the stream cleaner scheduler component                               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

declare_general_component_info
set_module_property NAME alt_vip_stream_cleaner_scheduler
set_module_property DISPLAY_NAME "Stream cleaner scheduler"

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files  ../../..
add_alt_vip_common_event_packet_encode_files  ../../..
add_alt_vip_common_slave_interface_files      ../../..
add_static_sv_file src_hdl/alt_vip_stream_cleaner_scheduler.sv

add_static_misc_file src_hdl/alt_vip_stream_cleaner_scheduler.ocp

setup_filesets alt_vip_stream_cleaner_scheduler

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set_module_property VALIDATION_CALLBACK  validation_cb

set_module_property ELABORATION_CALLBACK elaboration_cb




# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set x_max  $vipsuite_max_width
set y_max  $vipsuite_max_height

add_parameter TAG_PADDED_FRAMES INTEGER 0
set_parameter_property TAG_PADDED_FRAMES DISPLAY_NAME "Tag cropped/padded frames"
set_parameter_property TAG_PADDED_FRAMES DESCRIPTION ""
set_parameter_property TAG_PADDED_FRAMES ALLOWED_RANGES 0:1
set_parameter_property TAG_PADDED_FRAMES AFFECTS_ELABORATION false
set_parameter_property TAG_PADDED_FRAMES HDL_PARAMETER true
set_parameter_property TAG_PADDED_FRAMES DISPLAY_HINT boolean

add_parameter ERROR_DISCARD_COUNT INTEGER 1
set_parameter_property ERROR_DISCARD_COUNT DISPLAY_NAME "Number of frames to discard during/after error"
set_parameter_property ERROR_DISCARD_COUNT DESCRIPTION ""
set_parameter_property ERROR_DISCARD_COUNT ALLOWED_RANGES {1 2 4}
set_parameter_property ERROR_DISCARD_COUNT AFFECTS_ELABORATION true
set_parameter_property ERROR_DISCARD_COUNT HDL_PARAMETER true

add_parameter ENABLE_CONTROL_SLAVE INTEGER 0
set_parameter_property ENABLE_CONTROL_SLAVE DISPLAY_NAME "Enable control slave port"
set_parameter_property ENABLE_CONTROL_SLAVE DESCRIPTION ""
set_parameter_property ENABLE_CONTROL_SLAVE ALLOWED_RANGES 0:1
set_parameter_property ENABLE_CONTROL_SLAVE AFFECTS_ELABORATION true
set_parameter_property ENABLE_CONTROL_SLAVE HDL_PARAMETER true
set_parameter_property ENABLE_CONTROL_SLAVE DISPLAY_HINT boolean

add_parameter EVEN_FRONT_CLIP INTEGER 0
set_parameter_property EVEN_FRONT_CLIP DISPLAY_NAME "Only clip even numbers of pixels from the left side"
set_parameter_property EVEN_FRONT_CLIP DESCRIPTION ""
set_parameter_property EVEN_FRONT_CLIP ALLOWED_RANGES 0:1
set_parameter_property EVEN_FRONT_CLIP AFFECTS_ELABORATION false
set_parameter_property EVEN_FRONT_CLIP HDL_PARAMETER true
set_parameter_property EVEN_FRONT_CLIP DISPLAY_HINT boolean

add_parameter REMOVE_4KI INTEGER 0
set_parameter_property REMOVE_4KI DISPLAY_NAME "Remove interlaced fields larger than 1080i"
set_parameter_property REMOVE_4KI DESCRIPTION ""
set_parameter_property REMOVE_4KI ALLOWED_RANGES 0:1
set_parameter_property REMOVE_4KI AFFECTS_ELABORATION false
set_parameter_property REMOVE_4KI HDL_PARAMETER true
set_parameter_property REMOVE_4KI DISPLAY_HINT boolean

add_parameter WIDTH_MODULO INTEGER 1
set_parameter_property WIDTH_MODULO DISPLAY_NAME "Width modulo check value"
set_parameter_property WIDTH_MODULO DESCRIPTION ""
set_parameter_property WIDTH_MODULO ALLOWED_RANGES {1 2 4 8 16 32}
set_parameter_property WIDTH_MODULO AFFECTS_ELABORATION true
set_parameter_property WIDTH_MODULO HDL_PARAMETER true

add_parameter MAX_WIDTH INTEGER 1920
set_parameter_property MAX_WIDTH DISPLAY_NAME "Maximum frame width"
set_parameter_property MAX_WIDTH DESCRIPTION ""
set_parameter_property MAX_WIDTH ALLOWED_RANGES 32:$x_max
set_parameter_property MAX_WIDTH AFFECTS_ELABORATION true
set_parameter_property MAX_WIDTH HDL_PARAMETER true

add_parameter MIN_WIDTH INTEGER 32
set_parameter_property MIN_WIDTH DISPLAY_NAME "Minimum frame width"
set_parameter_property MIN_WIDTH DESCRIPTION ""
set_parameter_property MIN_WIDTH ALLOWED_RANGES 32:$x_max
set_parameter_property MIN_WIDTH AFFECTS_ELABORATION true
set_parameter_property MIN_WIDTH HDL_PARAMETER true

add_parameter MAX_HEIGHT INTEGER 1080
set_parameter_property MAX_HEIGHT DISPLAY_NAME "Maximum frame height"
set_parameter_property MAX_HEIGHT DESCRIPTION ""
set_parameter_property MAX_HEIGHT ALLOWED_RANGES 32:$y_max
set_parameter_property MAX_HEIGHT AFFECTS_ELABORATION true
set_parameter_property MAX_HEIGHT HDL_PARAMETER true

add_parameter MIN_HEIGHT INTEGER 32
set_parameter_property MIN_HEIGHT DISPLAY_NAME "Minimum frame height"
set_parameter_property MIN_HEIGHT DESCRIPTION ""
set_parameter_property MIN_HEIGHT ALLOWED_RANGES 32:$y_max
set_parameter_property MIN_HEIGHT AFFECTS_ELABORATION true
set_parameter_property MIN_HEIGHT HDL_PARAMETER true

add_parameter PIPELINE_READY INTEGER 0
set_parameter_property PIPELINE_READY DISPLAY_NAME "Register Avalon-ST ready signals"
set_parameter_property PIPELINE_READY DESCRIPTION ""
set_parameter_property PIPELINE_READY ALLOWED_RANGES 0:1
set_parameter_property PIPELINE_READY AFFECTS_ELABORATION false
set_parameter_property PIPELINE_READY HDL_PARAMETER true
set_parameter_property PIPELINE_READY DISPLAY_HINT boolean

add_user_packet_support_parameters
set_parameter_property   USER_PACKET_FIFO_DEPTH   HDL_PARAMETER             false
set_parameter_property   USER_PACKET_FIFO_DEPTH   VISIBLE                   false
set_parameter_property   USER_PACKET_SUPPORT      ALLOWED_RANGES {"DISCARD:Discard all user packets received" "PASSTHROUGH:Pass all user packets through to the output"}

add_av_st_event_parameters
set_parameter_property TASK_WIDTH ALLOWED_RANGES 2:32

add_parameter VIP2VVP INTEGER 0
set_parameter_property VIP2VVP VISIBLE false
set_parameter_property VIP2VVP ALLOWED_RANGES 0:1
set_parameter_property VIP2VVP AFFECTS_ELABORATION false
set_parameter_property VIP2VVP HDL_PARAMETER true

add_main_clock_port

proc validation_cb {} {
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set min_width       [get_parameter_value MIN_WIDTH]
    set max_width       [get_parameter_value MAX_WIDTH]
    set min_height      [get_parameter_value MIN_HEIGHT]
    set max_height      [get_parameter_value MAX_HEIGHT]
    set modulo_val      [get_parameter_value WIDTH_MODULO]

    # --------------------------------------------------------------------------------------------------
    # -- Validation                                                                                   --
    # --------------------------------------------------------------------------------------------------

    if { $max_width < $min_width } {
        send_message Error "The maximum width must be larger than the minimum width"
    }
    if { $max_height < $min_height } {
        send_message Error "The maximum height must be larger than the minimum height"
    }

    if { [expr $min_width % $modulo_val] > 0 } {
        send_message Error "The mimimum width must be an even multiple of the width modulo check value"
    }

    if { [expr $max_width % $modulo_val] > 0 } {
       send_message Error "The maximum width must be an even multiple of the width modulo check value"
    }
}

proc elaboration_cb {} {
    set src_width           [get_parameter_value SRC_WIDTH]
    set dst_width           [get_parameter_value DST_WIDTH]
    set context_width       [get_parameter_value CONTEXT_WIDTH]
    set task_width          [get_parameter_value TASK_WIDTH]
   
    if { [get_parameter_value ENABLE_CONTROL_SLAVE] > 0 } {
        add_control_slave_port  av_mm_control     4  13       0           1            1              1       main_clock
    }

    add_av_st_cmd_sink_port    av_st_vib_resp    1  $dst_width  $src_width  $task_width $context_width       main_clock  0
    add_av_st_cmd_source_port  av_st_vib_cmd     1  $dst_width  $src_width  $task_width $context_width       main_clock  0
    add_av_st_cmd_source_port  av_st_ac_cmd      1  $dst_width  $src_width  $task_width $context_width       main_clock  0
    add_av_st_cmd_source_port  av_st_vob_cmd     1  $dst_width  $src_width  $task_width $context_width       main_clock  0 
}
