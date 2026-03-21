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


# Common module properties for VIP components 
declare_general_component_info

set_module_property NAME alt_vip_mix_scheduler
set_module_property DISPLAY_NAME "Mixer scheduler"
set_module_property DESCRIPTION "Scheduler for the mixer component"

set_module_property   ELABORATION_CALLBACK            elaboration_callback


add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files ../../..

add_static_sv_file   src_hdl/alt_vip_mix_scheduler.sv

add_static_misc_file src_hdl/alt_vip_mix_scheduler.ocp

setup_filesets alt_vip_mix_scheduler

add_parameter          FRAME_WIDTH               INTEGER                  1920
set_parameter_property FRAME_WIDTH               DISPLAY_NAME             "Maximum frame width"
set_parameter_property FRAME_WIDTH               ALLOWED_RANGES           32:$vipsuite_max_width
set_parameter_property FRAME_WIDTH               DESCRIPTION              "The maximum width of images / video frames"
set_parameter_property FRAME_WIDTH               HDL_PARAMETER            true
set_parameter_property FRAME_WIDTH               AFFECTS_ELABORATION      false

add_parameter          FRAME_HEIGHT              INTEGER                  1080
set_parameter_property FRAME_HEIGHT              DISPLAY_NAME             "Maximum frame height"
set_parameter_property FRAME_HEIGHT              ALLOWED_RANGES           32:$vipsuite_max_height
set_parameter_property FRAME_HEIGHT              DESCRIPTION              "The maximum height of images / video frames"
set_parameter_property FRAME_HEIGHT              HDL_PARAMETER            true
set_parameter_property FRAME_HEIGHT              AFFECTS_ELABORATION      false

add_parameter          NO_OF_INPUTS              INTEGER                  4
set_parameter_property NO_OF_INPUTS              DISPLAY_NAME             "Number of inputs"
set_parameter_property NO_OF_INPUTS              ALLOWED_RANGES           1:20
set_parameter_property NO_OF_INPUTS              DESCRIPTION              "The number of Avalon ST Video inputs to be mixed"
set_parameter_property NO_OF_INPUTS              AFFECTS_ELABORATION      true
set_parameter_property NO_OF_INPUTS              HDL_PARAMETER            true

add_parameter          RUNTIME_CONTROL           INTEGER                  1
set_parameter_property RUNTIME_CONTROL           DISPLAY_NAME             "Enable runtime control of cadence detect"
set_parameter_property RUNTIME_CONTROL           DESCRIPTION              ""
set_parameter_property RUNTIME_CONTROL           ALLOWED_RANGES           0:1
set_parameter_property RUNTIME_CONTROL           AFFECTS_ELABORATION      true
set_parameter_property RUNTIME_CONTROL           HDL_PARAMETER            true
set_parameter_property RUNTIME_CONTROL           DISPLAY_HINT             boolean

add_parameter          UNIFORM_VALUE_RY          INTEGER                  0
set_parameter_property UNIFORM_VALUE_RY          DISPLAY_NAME             "R or Y"
set_parameter_property UNIFORM_VALUE_RY          DESCRIPTION              "Color bit value for R or Y"
set_parameter_property UNIFORM_VALUE_RY          HDL_PARAMETER            true
set_parameter_property UNIFORM_VALUE_RY          AFFECTS_ELABORATION      false

add_parameter          UNIFORM_VALUE_GCB         INTEGER                  128
set_parameter_property UNIFORM_VALUE_GCB         DISPLAY_NAME             "G or Cb"
set_parameter_property UNIFORM_VALUE_GCB         DESCRIPTION              "Color bit value for G or Cb"
set_parameter_property UNIFORM_VALUE_GCB         HDL_PARAMETER            true
set_parameter_property UNIFORM_VALUE_GCB         AFFECTS_ELABORATION      false

add_parameter          UNIFORM_VALUE_BCR         INTEGER                  128
set_parameter_property UNIFORM_VALUE_BCR         DISPLAY_NAME             "B or Cr"
set_parameter_property UNIFORM_VALUE_BCR         DESCRIPTION              "Color bit value for B or Cr"
set_parameter_property UNIFORM_VALUE_BCR         HDL_PARAMETER            true
set_parameter_property UNIFORM_VALUE_BCR         AFFECTS_ELABORATION      false

add_parameter          USER_PACKETS_SUPPORTED    INTEGER                  1
set_parameter_property USER_PACKETS_SUPPORTED    DISPLAY_NAME             "Are user packets supported?"
set_parameter_property USER_PACKETS_SUPPORTED    DESCRIPTION              ""
set_parameter_property USER_PACKETS_SUPPORTED    ALLOWED_RANGES           0:1
set_parameter_property USER_PACKETS_SUPPORTED    AFFECTS_ELABORATION      true
set_parameter_property USER_PACKETS_SUPPORTED    HDL_PARAMETER            true
set_parameter_property USER_PACKETS_SUPPORTED    DISPLAY_HINT             boolean

add_parameter          ALPHA_ENABLE              INTEGER                  0
set_parameter_property ALPHA_ENABLE              DISPLAY_NAME             "Alpha Blending Enable"
set_parameter_property ALPHA_ENABLE              ALLOWED_RANGES           {1,0}
set_parameter_property ALPHA_ENABLE              DESCRIPTION              "Enables Alpha blending"
set_parameter_property ALPHA_ENABLE              HDL_PARAMETER            true
set_parameter_property ALPHA_ENABLE              AFFECTS_ELABORATION      true
set_parameter_property ALPHA_ENABLE              VISIBLE                  false

add_parameter          LAYER_POSITION_ENABLE     INTEGER                  0
set_parameter_property LAYER_POSITION_ENABLE     DISPLAY_NAME             "Layer Position Enable"
set_parameter_property LAYER_POSITION_ENABLE     ALLOWED_RANGES           {1,0}
set_parameter_property LAYER_POSITION_ENABLE     DESCRIPTION              "Enable input layer position mappings"
set_parameter_property LAYER_POSITION_ENABLE     DISPLAY_HINT             boolean
set_parameter_property LAYER_POSITION_ENABLE     HDL_PARAMETER            true
set_parameter_property LAYER_POSITION_ENABLE     AFFECTS_ELABORATION      true
set_parameter_property LAYER_POSITION_ENABLE     VISIBLE                  false

add_parameter          LIMITED_READBACK          INTEGER                  0
set_parameter_property LIMITED_READBACK          DISPLAY_NAME             "Reduced control slave register readback"
set_parameter_property LIMITED_READBACK          DESCRIPTION              ""
set_parameter_property LIMITED_READBACK          ALLOWED_RANGES           0:1
set_parameter_property LIMITED_READBACK          AFFECTS_ELABORATION      false
set_parameter_property LIMITED_READBACK          HDL_PARAMETER            true
set_parameter_property LIMITED_READBACK          DISPLAY_HINT             boolean

add_parameter          LOW_LATENCY_MODE          INTEGER                  0
set_parameter_property LOW_LATENCY_MODE          DISPLAY_NAME             "Synchronise background layer to layer 0"
set_parameter_property LOW_LATENCY_MODE          DESCRIPTION              ""
set_parameter_property LOW_LATENCY_MODE          ALLOWED_RANGES           0:1
set_parameter_property LOW_LATENCY_MODE          AFFECTS_ELABORATION      false
set_parameter_property LOW_LATENCY_MODE          HDL_PARAMETER            true
set_parameter_property LOW_LATENCY_MODE          DISPLAY_HINT             boolean

add_parameter           PIPELINE_READY           INTEGER                  0
set_parameter_property  PIPELINE_READY           DISPLAY_NAME             "Register Avalon-ST ready signals"
set_parameter_property  PIPELINE_READY           ALLOWED_RANGES           0:1
set_parameter_property  PIPELINE_READY           AFFECTS_ELABORATION      true
set_parameter_property  PIPELINE_READY           HDL_PARAMETER            false
set_parameter_property  PIPELINE_READY           DISPLAY_HINT             boolean

add_av_st_event_parameters

# The main clock and associated reset
add_main_clock_port	

proc elaboration_callback {} {

    set src_width               [get_parameter_value SRC_WIDTH              ]
    set dst_width               [get_parameter_value DST_WIDTH              ]
    set context_width           [get_parameter_value CONTEXT_WIDTH          ]
    set task_width              [get_parameter_value TASK_WIDTH             ]
    set control_exists          [get_parameter_value RUNTIME_CONTROL        ]
    set no_of_inputs            [get_parameter_value NO_OF_INPUTS           ]
    set user_packets_supported  [get_parameter_value USER_PACKETS_SUPPORTED ]

    #                         name   elements_per_beat   dst_width   src_width   task_width   context_width    clock    pe_id 
    add_av_st_cmd_source_port cmd_tpg       1           $dst_width  $src_width  $task_width  $context_width  main_clock   0
    add_av_st_cmd_source_port cmd_mix       1           $dst_width  $src_width  $task_width  $context_width  main_clock   0
    add_av_st_cmd_source_port cmd_vob       1           $dst_width  $src_width  $task_width  $context_width  main_clock   0
    add_av_st_cmd_source_port cmd_mux       1           $dst_width  $src_width  $task_width  $context_width  main_clock   0

    # VIB cmd/resp ports
    add_av_st_message_array_output_port cmd_vib   $no_of_inputs 32 1 $dst_width $src_width $task_width $context_width 0 main_clock 0
    add_av_st_message_array_input_port  resp_vib  $no_of_inputs 32 1 $dst_width $src_width $task_width $context_width 0 main_clock 0

    set   num_reg      [expr 8 + ($no_of_inputs * 5)]
    set   addr_width   7 
    if { $control_exists } {
        add_control_slave_port   av_mm_control   $addr_width   $num_reg   0   1   1   1   main_clock
    }
}

