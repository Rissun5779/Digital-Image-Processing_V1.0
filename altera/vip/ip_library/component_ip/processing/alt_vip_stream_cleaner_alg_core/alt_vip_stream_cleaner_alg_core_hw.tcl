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
# -- General information for the stream cleaner algorithmic core component                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

# Common module properties for VIP components 
declare_general_component_info
set_module_property NAME alt_vip_stream_cleaner_alg_core
set_module_property DISPLAY_NAME "Stream cleaner Alg core"


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files  ../../..
add_alt_vip_common_event_packet_encode_files  ../../..
add_static_sv_file src_hdl/alt_vip_stream_cleaner_alg_core.sv

add_static_misc_file src_hdl/alt_vip_stream_cleaner_alg_core.ocp

setup_filesets alt_vip_stream_cleaner_alg_core


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
add_channels_nb_parameters
add_bits_per_symbol_parameters

add_parameter           PIXELS_IN_PARALLEL   INTEGER              1
set_parameter_property  PIXELS_IN_PARALLEL   DISPLAY_NAME         "Number of pixels in parallel"
set_parameter_property  PIXELS_IN_PARALLEL   ALLOWED_RANGES       {1,2,4,8}
set_parameter_property  PIXELS_IN_PARALLEL   AFFECTS_ELABORATION  true
set_parameter_property  PIXELS_IN_PARALLEL   HDL_PARAMETER        true

add_parameter           MAX_LINE_LENGTH      INTEGER              1920
set_parameter_property  MAX_LINE_LENGTH      DISPLAY_NAME         "Maximum line length"
set_parameter_property  MAX_LINE_LENGTH      DESCRIPTION          ""
set_parameter_property  MAX_LINE_LENGTH      ALLOWED_RANGES       32:$vipsuite_max_width
set_parameter_property  MAX_LINE_LENGTH      AFFECTS_ELABORATION  true
set_parameter_property  MAX_LINE_LENGTH      HDL_PARAMETER        true

add_parameter           PIPELINE_READY       INTEGER              0
set_parameter_property  PIPELINE_READY       DISPLAY_NAME         "Register Avalon-ST ready signals"
set_parameter_property  PIPELINE_READY       DESCRIPTION          ""
set_parameter_property  PIPELINE_READY       ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY       AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY       HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY       DISPLAY_HINT         boolean

add_parameter           DATA_SRC_ADDRESS     INTEGER              2
set_parameter_property  DATA_SRC_ADDRESS     DISPLAY_NAME         "Source ID"
set_parameter_property  DATA_SRC_ADDRESS     AFFECTS_ELABORATION  true
set_parameter_property  DATA_SRC_ADDRESS     HDL_PARAMETER        true

add_av_st_event_parameters
set_parameter_property  TASK_WIDTH           ALLOWED_RANGES       2:32

add_main_clock_port

proc validation_cb {} {
    # --------------------------------------------------------------------------------------------------
    # -- Validation                                                                                   --
    # --------------------------------------------------------------------------------------------------
    pip_validation_callback_helper
}

proc elaboration_cb {} {
    set src_width           [get_parameter_value SRC_WIDTH]
    set dst_width           [get_parameter_value DST_WIDTH]
    set context_width       [get_parameter_value CONTEXT_WIDTH]
    set task_width          [get_parameter_value TASK_WIDTH]

    set   bits_per_symbol   [get_parameter_value BITS_PER_SYMBOL]
    set   symbols_per_pixel [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set   are_in_par        [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set   pixels_in_par     [get_parameter_value PIXELS_IN_PARALLEL]

    if { $are_in_par > 0 } {
        set   data_width     [expr $bits_per_symbol * $symbols_per_pixel]	
    } else {
        set   data_width     $bits_per_symbol 
    }

    add_av_st_cmd_sink_port    av_st_cmd                                 1               $dst_width  $src_width  $task_width $context_width       main_clock  0
    add_av_st_data_sink_port   av_st_din            $data_width          $pixels_in_par  $dst_width  $src_width  $task_width $context_width    0  main_clock  0
    add_av_st_data_source_port av_st_dout           $data_width          $pixels_in_par  $dst_width  $src_width  $task_width $context_width    0  main_clock  0
}

