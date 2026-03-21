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
# -- General information for the duplicator module                                                --
# -- This block receives Avalon-ST packets and forwards them to up to destinations.               --
# -- It optinonally includes one FIFO per destination to absorb ready latencies downstream.       --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_packet_duplicator
set_module_property DISPLAY_NAME "Packet Duplicator"
set_module_property DESCRIPTION "Forward incoming packets, duplicating them for multiple recipients when requested"

set_module_property VALIDATION_CALLBACK  duplicator_validation_callback
set_module_property ELABORATION_CALLBACK duplicator_elaboration_callback



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_fifo2_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_packet_duplicator.sv

setup_filesets alt_vip_packet_duplicator

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

add_parameter DUPLICATOR_FANOUT INTEGER 2
set_parameter_property DUPLICATOR_FANOUT  ALLOWED_RANGES       1:16
set_parameter_property DUPLICATOR_FANOUT  DISPLAY_NAME         "Number of output ports"
set_parameter_property DUPLICATOR_FANOUT  AFFECTS_ELABORATION  true
set_parameter_property DUPLICATOR_FANOUT  HDL_PARAMETER        true

add_parameter ALWAYS_DUPLICATE_ALL INTEGER 0
set_parameter_property ALWAYS_DUPLICATE_ALL     ALLOWED_RANGES      0:1
set_parameter_property ALWAYS_DUPLICATE_ALL     DISPLAY_NAME        "Always duplicate to all outputs"
set_parameter_property ALWAYS_DUPLICATE_ALL     DISPLAY_HINT        boolean
set_parameter_property ALWAYS_DUPLICATE_ALL     AFFECTS_ELABORATION false
set_parameter_property ALWAYS_DUPLICATE_ALL     HDL_PARAMETER       true

add_parameter USE_COMMAND INTEGER 0
set_parameter_property USE_COMMAND        ALLOWED_RANGES      0:1
set_parameter_property USE_COMMAND        DISPLAY_NAME        "Enable command port to control routing"
set_parameter_property USE_COMMAND        DISPLAY_HINT        boolean
set_parameter_property USE_COMMAND        AFFECTS_ELABORATION true
set_parameter_property USE_COMMAND        HDL_PARAMETER       true

for { set i 0 } { $i < 16} { incr i } {

	add_parameter DST_ID_$i INTEGER 0
	set_parameter_property DST_ID_$i DISPLAY_NAME "Default destination ID for output port $i"
	set_parameter_property DST_ID_$i HDL_PARAMETER true
	set_parameter_property DST_ID_$i AFFECTS_ELABORATION false
	set_parameter_property DST_ID_$i VISIBLE false

}

add_parameter DEPTH INTEGER 4
set_parameter_property DEPTH              ALLOWED_RANGES       {0 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384}
set_parameter_property DEPTH              DISPLAY_NAME         "FIFO depth"
set_parameter_property DEPTH              AFFECTS_ELABORATION  false
set_parameter_property DEPTH              HDL_PARAMETER        true

add_parameter REGISTER_OUTPUT INTEGER 0
set_parameter_property REGISTER_OUTPUT    ALLOWED_RANGES      0:1
set_parameter_property REGISTER_OUTPUT    DISPLAY_NAME        "Register dout interfaces"
set_parameter_property REGISTER_OUTPUT    DISPLAY_HINT        boolean
set_parameter_property REGISTER_OUTPUT    AFFECTS_ELABORATION false
set_parameter_property REGISTER_OUTPUT    HDL_PARAMETER       true

add_parameter PIPELINE_READY INTEGER 0
set_parameter_property PIPELINE_READY     ALLOWED_RANGES      0:1
set_parameter_property PIPELINE_READY     DISPLAY_NAME        "Pipeline dout ready signals"
set_parameter_property PIPELINE_READY     DISPLAY_HINT        boolean
set_parameter_property PIPELINE_READY     AFFECTS_ELABORATION false
set_parameter_property PIPELINE_READY     HDL_PARAMETER       true

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
# -- Validation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc duplicator_validation_callback {} {
   if { [get_parameter_value ALWAYS_DUPLICATE_ALL] == 0 } {
      if { [get_parameter_value DUPLICATOR_FANOUT] > [get_parameter_value DST_WIDTH] } {
        send_message Error "The destination ID width must not be less than the number of duplicator outputs"
      }
   }
   
   set task_width [get_parameter_value TASK_WIDTH]
   if {$task_width < 1} {
      if { [get_parameter_value USE_COMMAND] > 0 } {
         send_message Error "Task ID Width for the command interface must be at least 1 bits"
      }
   }	
   
   set limit [get_parameter_value DST_WIDTH]
   set limit [expr {pow(2, $limit)}]
   set limit [expr {$limit - 1}]
   for { set i 0 } { $i < [get_parameter_value DUPLICATOR_FANOUT]} { incr i } {
      set value [get_parameter_value DST_ID_$i]
      if { $value > $limit } {
         send_message Warning "Destination ID for output port $i is outside the range supported by the specified dout Destiantion ID width"
      }
      if { $value < 0 } {
         send_message Warning "Destination ID for output port $i should not be negative"
      }
      set_parameter_property DST_ID_$i VISIBLE true
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
proc duplicator_elaboration_callback {} {

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

    if { [get_parameter_value USE_COMMAND] > 0 } {
        add_av_st_cmd_sink_port   av_st_cmd   1   $dst_width   $src_width   $task_width   $context_width   main_clock   0
    }
    
    if {$pixels_per_beat > 1} {
       set empty_width [clogb2_pure $pixels_per_beat] 
    } else {
       set empty_width 0
    }
    
    set fanout                      [get_parameter_value DUPLICATOR_FANOUT]
    if { [get_parameter_value CMD_RESP_INTERFACE] > 0 } {
       set user_width          0
       set data_width          32
       #adding the input & output interfaces
       add_av_st_cmd_sink_port           av_st_din              $pixels_per_beat     $dst_width   $src_width   $task_width   $context_width   main_clock   0
       add_av_st_array_cmd_source_port   av_st_dout   $fanout   $pixels_per_beat     $dst_width   $src_width   $task_width   $context_width   main_clock   0
    } else {
       if {$pixels_per_beat > 1} { 
          set user_width          $empty_width
       } else {
          set user_width          [get_parameter_value USER_WIDTH]
       }
       #adding the input & output interfaces
       add_av_st_data_sink_port           av_st_din              $data_width   $pixels_per_beat   $dst_width   $src_width   $task_width   $context_width   $user_width  main_clock   0
       add_av_st_array_data_source_port   av_st_dout   $fanout   $data_width   $pixels_per_beat   $dst_width   $src_width   $task_width   $context_width   $user_width  main_clock   0
    } 
    set total_data_width   [expr $pixels_per_beat * $data_width]
    set total_data_width   [expr $total_data_width + $empty_width]
    set_parameter_value    DATA_WIDTH_INT      $total_data_width     
    set_parameter_value    USER_WIDTH_INT      $user_width    

}
