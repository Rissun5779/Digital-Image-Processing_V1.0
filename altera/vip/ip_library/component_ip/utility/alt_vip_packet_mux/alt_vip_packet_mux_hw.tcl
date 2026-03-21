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
# -- General information for the packet_mux module                                                --
# -- This block sinks Avalon-ST packets from up to 21 independent sources, reading one of them,   --
# -- whilst holding off the other(s) if necessary.                                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_packet_mux
set_module_property DISPLAY_NAME "Packet Mux"
set_module_property Description  "Mux up to 21 incoming streams of Avalon-ST packets"

set_module_property ELABORATION_CALLBACK mux_elaboration_callback
set_module_property VALIDATION_CALLBACK mux_validation_callback



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_packet_mux.sv

setup_filesets alt_vip_packet_mux

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_parameter CMD_RESP_INTERFACE INTEGER 0
set_parameter_property CMD_RESP_INTERFACE ALLOWED_RANGES      0:1
set_parameter_property CMD_RESP_INTERFACE DISPLAY_NAME        "Command/Response interface"
set_parameter_property CMD_RESP_INTERFACE DISPLAY_HINT        boolean
set_parameter_property CMD_RESP_INTERFACE AFFECTS_ELABORATION true
set_parameter_property CMD_RESP_INTERFACE HDL_PARAMETER       false

add_data_width_parameters  
set_parameter_property DATA_WIDTH HDL_PARAMETER false

add_parameter PIXELS_IN_PARALLEL INTEGER 1
set_parameter_property PIXELS_IN_PARALLEL DISPLAY_NAME "Number of pixels/arguments in parallel"
set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1,2,4,8}
set_parameter_property PIXELS_IN_PARALLEL AFFECTS_GENERATION true
set_parameter_property PIXELS_IN_PARALLEL HDL_PARAMETER false

add_parameter NUM_INPUTS INTEGER 2
set_parameter_property NUM_INPUTS DISPLAY_NAME "Number of inputs"
set_parameter_property NUM_INPUTS ALLOWED_RANGES 2:21
set_parameter_property NUM_INPUTS AFFECTS_ELABORATION  true
set_parameter_property NUM_INPUTS HDL_PARAMETER true

add_parameter REGISTER_OUTPUT INTEGER 0
set_parameter_property REGISTER_OUTPUT DISPLAY_NAME "Register dout"
set_parameter_property REGISTER_OUTPUT ALLOWED_RANGES 0:1
set_parameter_property REGISTER_OUTPUT DISPLAY_HINT boolean
set_parameter_property REGISTER_OUTPUT HDL_PARAMETER true

add_parameter PIPELINE_READY INTEGER 0
set_parameter_property PIPELINE_READY DISPLAY_NAME "Pipeline dout ready"
set_parameter_property PIPELINE_READY ALLOWED_RANGES 0:1
set_parameter_property PIPELINE_READY DISPLAY_HINT boolean
set_parameter_property PIPELINE_READY HDL_PARAMETER true

add_parameter NAME string "undefined"
set_parameter_property NAME     DISPLAY_NAME        "Name"
set_parameter_property NAME     DISPLAY_HINT        string
set_parameter_property NAME     AFFECTS_ELABORATION false
set_parameter_property NAME     HDL_PARAMETER       true

# Add parameters for the data and command Avalon-ST message ports
add_av_st_event_parameters

add_av_st_event_user_width_parameters
set_parameter_property USER_WIDTH HDL_PARAMETER false

add_parameter DATA_WIDTH_INT INTEGER 20
set_parameter_property DATA_WIDTH_INT HDL_PARAMETER true
set_parameter_property DATA_WIDTH_INT DERIVED true
set_parameter_property DATA_WIDTH_INT VISIBLE false

add_parameter USER_WIDTH_INT INTEGER 0
set_parameter_property USER_WIDTH_INT HDL_PARAMETER true
set_parameter_property USER_WIDTH_INT DERIVED true
set_parameter_property USER_WIDTH_INT VISIBLE false

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
proc mux_elaboration_callback {} {

   if { [get_parameter_value CMD_RESP_INTERFACE] > 0 } {
       set_parameter_property DATA_WIDTH ENABLED false
    } else {
       set_parameter_property DATA_WIDTH ENABLED true
    }

    set pixels_per_beat     [get_parameter_value PIXELS_IN_PARALLEL]
    set data_width          [get_parameter_value DATA_WIDTH]
    set src_width           [get_parameter_value SRC_WIDTH]
    set dst_width           [get_parameter_value DST_WIDTH]
    set context_width       [get_parameter_value CONTEXT_WIDTH]
    set task_width          [get_parameter_value TASK_WIDTH]
    
    if {$pixels_per_beat > 1} {
       set empty_width [clogb2_pure $pixels_per_beat] 
    } else {
       set empty_width 0
    }

    if { [get_parameter_value CMD_RESP_INTERFACE] > 0 } {
       set user_width          0
       set data_width          32
    } else {
       if {$pixels_per_beat > 1} { 
          set user_width          $empty_width
       } else {
          set user_width          [get_parameter_value USER_WIDTH]
       }
    } 
    set total_data_width   [expr $pixels_per_beat * $data_width]
    set total_data_width   [expr $total_data_width + $empty_width]
    set_parameter_value    DATA_WIDTH_INT      $total_data_width     
    set_parameter_value    USER_WIDTH_INT      $user_width  

    #add the command port
    add_av_st_cmd_sink_port   av_st_cmd   1   $dst_width   $src_width   $task_width   $context_width   main_clock   0

    set num_inputs          [get_parameter_value NUM_INPUTS]

    #data input & output interfaces
    if { [get_parameter_value CMD_RESP_INTERFACE] > 0 } {
       add_av_st_array_cmd_sink_port  av_st_din    $num_inputs   $pixels_per_beat   $dst_width   $src_width   $task_width   $context_width   main_clock   0
       add_av_st_cmd_source_port      av_st_dout                 $pixels_per_beat   $dst_width   $src_width   $task_width   $context_width   main_clock   0
    } else {
       add_av_st_array_data_sink_port av_st_din    $num_inputs   $data_width   $pixels_per_beat   $dst_width   $src_width   $task_width   $context_width   $user_width    main_clock   0
       add_av_st_data_source_port     av_st_dout                 $data_width   $pixels_per_beat   $dst_width   $src_width   $task_width   $context_width   $user_width    main_clock   0
    }

}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Checking parameters (validation callback)                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc mux_validation_callback {} {
   #command port must have an Event ID width of at least 1 bit
   if { [get_parameter_value TASK_WIDTH] < 1 } {
      send_message Error "The Task ID width for the command port must be at least 1 bit"
   }
   if { [get_parameter_value CMD_RESP_INTERFACE] > 0 } {
      if { [get_parameter_value USER_WIDTH] > 0 } {
         send_message Error "The User field is not supported for Command/Response interfaces. User width must be 0"
      }
   }
   if { [get_parameter_value PIXELS_IN_PARALLEL] > 1 } {
      if { [get_parameter_value USER_WIDTH] > 0 } {
         send_message Error "The User field is not supported for data interfaces with multiple pixels in parallel. User width must be 0"
      }
   }
}
