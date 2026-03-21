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
# -- General information for the scaler kernel creator component                                  --
# -- This block calculates the kernel center lines required to produce each output line in an     --
# -- upscaled or downscaled image, as well as bilinear errors or bicubic/polyphase phase numbers  --
# -- where required                                                                               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

set_module_property NAME alt_vip_scaler_kernel_creator
set_module_property DISPLAY_NAME "Scaler Kernel Creator"
set_module_property DESCRIPTION "This block calculates the kernel center lines required to produce each output line in an
\upscaled or downscaled image, as well as bilinear errors or bicubic/polyphase phase numbers where required"

set_module_property ELABORATION_CALLBACK kc_elaboration_callback
set_module_property VALIDATION_CALLBACK kc_validation_callback


# +-----------------------------------

# +-----------------------------------
# | files

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_scaler_kernel_creator_step.sv
add_static_sv_file src_hdl/alt_vip_scaler_kernel_creator_div.sv
add_static_sv_file src_hdl/alt_vip_scaler_kernel_creator_nn.sv
add_static_sv_file src_hdl/alt_vip_scaler_kernel_creator_non_nn.sv
add_static_sv_file src_hdl/alt_vip_scaler_kernel_creator.sv
add_static_misc_file src_hdl/alt_vip_scaler_kernel_creator.ocp

setup_filesets alt_vip_scaler_kernel_creator

# +-----------------------------------

# +-----------------------------------
# | parameters

set   x_min 32
set   x_max $vipsuite_max_width
set   y_min 32
set   y_max $vipsuite_max_height

add_parameter ALGORITHM string POLYPHASE
set_parameter_property ALGORITHM DISPLAY_NAME "Scaling algorithm"
set_parameter_property ALGORITHM ALLOWED_RANGES {NEAREST_NEIGHBOUR BILINEAR BICUBIC POLYPHASE EDGE_ADAPT}
set_parameter_property ALGORITHM DISPLAY_HINT ""
set_parameter_property ALGORITHM DESCRIPTION "Selects the scaling alogithm used"
set_parameter_property ALGORITHM HDL_PARAMETER true
set_parameter_property ALGORITHM AFFECTS_ELABORATION false

add_parameter PARTIAL_LINE_SCALING INTEGER 0
set_parameter_property PARTIAL_LINE_SCALING DISPLAY_NAME "Include partial line scaling support"
set_parameter_property PARTIAL_LINE_SCALING ALLOWED_RANGES 0:1
set_parameter_property PARTIAL_LINE_SCALING DISPLAY_HINT boolean
set_parameter_property PARTIAL_LINE_SCALING DESCRIPTION "Select to include hardware to generate Scaler Algorithmic Core arguments for partial line scaling"
set_parameter_property PARTIAL_LINE_SCALING HDL_PARAMETER true
set_parameter_property PARTIAL_LINE_SCALING AFFECTS_ELABORATION false

add_parameter IS_422 INTEGER 0
set_parameter_property IS_422 DISPLAY_NAME "Generate partial line arguments for 4:2:2 data"
set_parameter_property IS_422 ALLOWED_RANGES 0:1
set_parameter_property IS_422 DISPLAY_HINT boolean
set_parameter_property IS_422 DESCRIPTION "Select to generate partial line scaling arguments for 4:2:2 data"
set_parameter_property IS_422 HDL_PARAMETER true
set_parameter_property IS_422 AFFECTS_ELABORATION false

add_parameter FRAC_BITS_H INTEGER 8
set_parameter_property FRAC_BITS_H DISPLAY_NAME "Divider fractional bits for vertical operations"
set_parameter_property FRAC_BITS_H ALLOWED_RANGES 1:32
set_parameter_property FRAC_BITS_H DISPLAY_HINT ""
set_parameter_property FRAC_BITS_H DESCRIPTION "Selects the number of fractional bits calculated by the fixed point divider for the vertical scaling operations"
set_parameter_property FRAC_BITS_H HDL_PARAMETER true
set_parameter_property FRAC_BITS_H AFFECTS_ELABORATION true

add_parameter FRAC_BITS_W INTEGER 8
set_parameter_property FRAC_BITS_W DISPLAY_NAME "Divider fractional bits for horizontal operations"
set_parameter_property FRAC_BITS_W ALLOWED_RANGES 1:32
set_parameter_property FRAC_BITS_W DISPLAY_HINT ""
set_parameter_property FRAC_BITS_W DESCRIPTION "Selects the number of fractional bits calculated by the fixed point divider for the horizontal scaling operations"
set_parameter_property FRAC_BITS_W HDL_PARAMETER true
set_parameter_property FRAC_BITS_W AFFECTS_ELABORATION true

add_parameter FIXED_SIZE INTEGER 0
set_parameter_property FIXED_SIZE DISPLAY_NAME "Used fixed resolutions"
set_parameter_property FIXED_SIZE ALLOWED_RANGES 0:1
set_parameter_property FIXED_SIZE DISPLAY_HINT boolean
set_parameter_property FIXED_SIZE DESCRIPTION "Select if the output resolution is fixed (maximum dimensions used as fixed dimensions)"
set_parameter_property FIXED_SIZE HDL_PARAMETER true
set_parameter_property FIXED_SIZE AFFECTS_ELABORATION false

add_max_in_dim_parameters  $x_min   $x_max   $y_min   $y_max
set_parameter_property MAX_IN_WIDTH DESCRIPTION "Maximum width of input frame"
set_parameter_property MAX_IN_HEIGHT DESCRIPTION "Maximum height of input frame"
add_max_out_dim_parameters $x_min   $x_max   $y_min   $y_max
set_parameter_property MAX_OUT_WIDTH DESCRIPTION "Maximum width of output frame (or constant width if fixed resolutions option is selected)"
set_parameter_property MAX_OUT_HEIGHT DESCRIPTION "Maximum height of output frame (or constant height if fixed resolutions option is selected)"

add_parameter EXTRA_PIPELINE_REG INTEGER 0
set_parameter_property EXTRA_PIPELINE_REG DISPLAY_NAME "Register Response interface"
set_parameter_property EXTRA_PIPELINE_REG ALLOWED_RANGES 0:1
set_parameter_property EXTRA_PIPELINE_REG DISPLAY_HINT boolean
set_parameter_property EXTRA_PIPELINE_REG DESCRIPTION "Select to add an additonal register stage to the Response interface"
set_parameter_property EXTRA_PIPELINE_REG HDL_PARAMETER true
set_parameter_property EXTRA_PIPELINE_REG AFFECTS_ELABORATION false

add_av_st_event_parameters

add_parameter RESP_SRC_ADDR INTEGER 0
set_parameter_property RESP_SRC_ADDR DISPLAY_NAME "Avalon-ST Event response source address"
set_parameter_property RESP_SRC_ADDR DESCRIPTION "Source address for the kernel creator on the Avalon-ST Event Response interface"
set_parameter_property RESP_SRC_ADDR DISPLAY_HINT ""
set_parameter_property RESP_SRC_ADDR HDL_PARAMETER true
set_parameter_property RESP_SRC_ADDR AFFECTS_ELABORATION true

# +-----------------------------------

# +-----------------------------------
# | connections

# | connection point clock_reset

add_main_clock_port

# -- Dynamic Ports (elaboration callback) --

proc kc_elaboration_callback {} {

   set src_id                       [get_parameter_value RESP_SRC_ADDR]

    #setting up the command port
    set src_width                   [get_parameter_value SRC_WIDTH]
    set dst_width                   [get_parameter_value DST_WIDTH]
    set context_width               [get_parameter_value CONTEXT_WIDTH]
    set task_width                  [get_parameter_value TASK_WIDTH]
    add_av_st_cmd_sink_port     av_st_cmd   1   $dst_width   $src_width   $task_width   $context_width   main_clock    $src_id

    #setting up the response port
    add_av_st_resp_source_port  av_st_resp   1   $dst_width   $src_width   $task_width   $context_width   main_clock    $src_id

}

proc kc_validation_callback {} {

    set limit [get_parameter_value SRC_WIDTH]
    set limit [expr {pow(2, $limit)}]
    set limit [expr {$limit - 1}]
    set value [get_parameter_value RESP_SRC_ADDR]
    if { $value > $limit } {
          send_message Warning "Source address is outside the range supported by the specified response source address width"
    }
    if { $value < 0 } {
          send_message Warning "Source address is outside the range supported by the specified response source address width"
    }

    if { [get_parameter_value TASK_WIDTH] < 1 } {
          send_message Error "The Task ID width for the command and response port must be at least 1 bit"
    }

}
