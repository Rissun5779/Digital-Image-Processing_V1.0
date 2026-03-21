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


# ---------------------------------------------------------------------------------------------------
# --                                                                                               --
# -- General information for the packet transfer component                                         --
# -- This block works between Avalon-ST messages and the Avalon-MM interfaces. It contains both    --
# -- the write (to MM) and read (from MM) function. Data is merged and buffered in internal        --
# -- storage to form full MM burst, contexts are support.                                          --
# --                                                                                               --
# ---------------------------------------------------------------------------------------------------  


# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property    NAME alt_vip_packet_transfer
set_module_property    DISPLAY_NAME "Packet Transfer"

set_module_property    ELABORATION_CALLBACK packet_transfer_elaboration_callback
set_module_property    VALIDATION_CALLBACK packet_transfer_validation_callback



# +-----------------------------------
# | files
# | 
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_common_dc_mixed_widths_fifo_files ../../..
add_alt_vip_common_fifo2_files ../../..
add_alt_vip_common_delay_files ../../..
add_alt_vip_common_clock_crossing_bridge_grey_files ../../..

add_static_sv_file src_hdl/alt_vip_packet_transfer_pack_proc.sv
add_static_sv_file src_hdl/alt_vip_packet_transfer_twofold_ram.sv
add_static_sv_file src_hdl/alt_vip_packet_transfer_twofold_ram_reversed.sv
add_static_sv_file src_hdl/alt_vip_packet_transfer_read_proc.sv
add_static_sv_file src_hdl/alt_vip_packet_transfer_write_proc.sv
add_static_sv_file src_hdl/alt_vip_packet_transfer.sv

add_static_sdc_file alt_vip_packet_transfer.sdc .

setup_filesets alt_vip_packet_transfer


# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 

add_device_family_parameters
set_parameter_property    FAMILY    HDL_PARAMETER         true

add_data_width_parameters

add_parameter SYMBOLS_IN_SEQ INTEGER 1
set_parameter_property    SYMBOLS_IN_SEQ         ALLOWED_RANGES       1:4
set_parameter_property    SYMBOLS_IN_SEQ         DISPLAY_NAME         "Number of symbols in sequence" 
set_parameter_property    SYMBOLS_IN_SEQ         DESCRIPTION          "Number of beats of Avalon-ST data transmitted in sequence for each pixel (or data unit if not pixel data)"        
set_parameter_property    SYMBOLS_IN_SEQ         AFFECTS_ELABORATION  true         
set_parameter_property    SYMBOLS_IN_SEQ         HDL_PARAMETER        true 

add_parameter ELEMENTS_IN_PARALLEL INTEGER 1
set_parameter_property    ELEMENTS_IN_PARALLEL   DISPLAY_NAME            "Number of elememts transmitted in 1 clock cycle"
set_parameter_property    ELEMENTS_IN_PARALLEL   ALLOWED_RANGES          {1 2 4 8}
set_parameter_property    ELEMENTS_IN_PARALLEL   DESCRIPTION             "The number of elements transmitted every clock cycle."
set_parameter_property    ELEMENTS_IN_PARALLEL   HDL_PARAMETER           true
set_parameter_property    ELEMENTS_IN_PARALLEL   AFFECTS_ELABORATION     true

# parameter for MM Interface
add_parameter MEM_ADDR_WIDTH INTEGER 32
set_parameter_property    MEM_ADDR_WIDTH    DISPLAY_NAME          "Avalon-MM master(s) local ports address width"
set_parameter_property    MEM_ADDR_WIDTH    ALLOWED_RANGES        0:64
set_parameter_property    MEM_ADDR_WIDTH    HDL_PARAMETER         true
set_parameter_property    MEM_ADDR_WIDTH    AFFECTS_ELABORATION   true

add_common_masters_parameters

# Not a HDL parameter
add_burst_align_parameters
set_parameter_property   BURST_ALIGNMENT    AFFECTS_ELABORATION       true
set_parameter_property   BURST_ALIGNMENT    HDL_PARAMETER             false

add_parameter WRITE_HAS_PRIORITY INTEGER 1
set_parameter_property    WRITE_HAS_PRIORITY     DISPLAY_NAME          "Write has priority"
set_parameter_property    WRITE_HAS_PRIORITY     ALLOWED_RANGES        0:1
set_parameter_property    WRITE_HAS_PRIORITY     DISPLAY_HINT          boolean
set_parameter_property    WRITE_HAS_PRIORITY     HDL_PARAMETER         true
set_parameter_property    WRITE_HAS_PRIORITY     AFFECTS_ELABORATION   false


# parameters for write side
add_parameter WRITE_ENABLE INTEGER 1
set_parameter_property    WRITE_ENABLE     DISPLAY_NAME          "Enable write"
set_parameter_property    WRITE_ENABLE     ALLOWED_RANGES        0:1
set_parameter_property    WRITE_ENABLE     DISPLAY_HINT          boolean
set_parameter_property    WRITE_ENABLE     HDL_PARAMETER         true
set_parameter_property    WRITE_ENABLE     AFFECTS_ELABORATION   true

add_parameter USE_RESPONSE_WRITE INTEGER 0
set_parameter_property    USE_RESPONSE_WRITE     DISPLAY_NAME          "Enable Response port"
set_parameter_property    USE_RESPONSE_WRITE     ALLOWED_RANGES        0:1
set_parameter_property    USE_RESPONSE_WRITE     DISPLAY_HINT          boolean
set_parameter_property    USE_RESPONSE_WRITE     HDL_PARAMETER         true
set_parameter_property    USE_RESPONSE_WRITE     AFFECTS_ELABORATION   true

add_parameter ENABLE_MANY_COMMAND_WRITE INTEGER 0
set_parameter_property    ENABLE_MANY_COMMAND_WRITE     DISPLAY_NAME          "Enable Many Command support"
set_parameter_property    ENABLE_MANY_COMMAND_WRITE     ALLOWED_RANGES        0:1
set_parameter_property    ENABLE_MANY_COMMAND_WRITE     DISPLAY_HINT          boolean
set_parameter_property    ENABLE_MANY_COMMAND_WRITE     HDL_PARAMETER         true
set_parameter_property    ENABLE_MANY_COMMAND_WRITE     AFFECTS_ELABORATION   false

add_parameter ENABLE_PERIOD_MODE_WRITE INTEGER 0
set_parameter_property    ENABLE_PERIOD_MODE_WRITE     DISPLAY_NAME          "Enable Period Mode"
set_parameter_property    ENABLE_PERIOD_MODE_WRITE     ALLOWED_RANGES        0:1
set_parameter_property    ENABLE_PERIOD_MODE_WRITE     DISPLAY_HINT          boolean
set_parameter_property    ENABLE_PERIOD_MODE_WRITE     HDL_PARAMETER         true
set_parameter_property    ENABLE_PERIOD_MODE_WRITE     AFFECTS_ELABORATION   false

add_parameter SUPPORT_BEATS_OVERFLOW_PRETECTION INTEGER 1
set_parameter_property    SUPPORT_BEATS_OVERFLOW_PRETECTION     DISPLAY_NAME          "Enable Overflow pretection for maximum packet size"
set_parameter_property    SUPPORT_BEATS_OVERFLOW_PRETECTION     ALLOWED_RANGES        0:1
set_parameter_property    SUPPORT_BEATS_OVERFLOW_PRETECTION     DISPLAY_HINT          boolean
set_parameter_property    SUPPORT_BEATS_OVERFLOW_PRETECTION     HDL_PARAMETER         true
set_parameter_property    SUPPORT_BEATS_OVERFLOW_PRETECTION     AFFECTS_ELABORATION   false

add_parameter ENABLE_MM_OUTPUT_REGISTER INTEGER 0
set_parameter_property    ENABLE_MM_OUTPUT_REGISTER     DISPLAY_NAME          "Add an extra register on the MM interface"
set_parameter_property    ENABLE_MM_OUTPUT_REGISTER     ALLOWED_RANGES        0:1
set_parameter_property    ENABLE_MM_OUTPUT_REGISTER     DISPLAY_HINT          boolean
set_parameter_property    ENABLE_MM_OUTPUT_REGISTER     HDL_PARAMETER         true
set_parameter_property    ENABLE_MM_OUTPUT_REGISTER     AFFECTS_ELABORATION   false


add_parameter MAX_PACKET_SIZE_WRITE INTEGER $vipsuite_max_width
set_parameter_property    MAX_PACKET_SIZE_WRITE    DISPLAY_NAME          "Maximum supported packet size"
set_parameter_property    MAX_PACKET_SIZE_WRITE    ALLOWED_RANGES        1:268435456
set_parameter_property    MAX_PACKET_SIZE_WRITE    HDL_PARAMETER         true
set_parameter_property    MAX_PACKET_SIZE_WRITE    AFFECTS_ELABORATION   false

add_parameter MAX_PACKET_NUM_WRITE INTEGER 16
set_parameter_property    MAX_PACKET_NUM_WRITE    DISPLAY_NAME          "Maximum supported packet number"
set_parameter_property    MAX_PACKET_NUM_WRITE    ALLOWED_RANGES        1:65535
set_parameter_property    MAX_PACKET_NUM_WRITE    HDL_PARAMETER         true
set_parameter_property    MAX_PACKET_NUM_WRITE    AFFECTS_ELABORATION   false

add_parameter MAX_CONTEXT_NUMBER_WRITE INTEGER 1
set_parameter_property    MAX_CONTEXT_NUMBER_WRITE    DISPLAY_NAME          "Context number (affect resource)"
set_parameter_property    MAX_CONTEXT_NUMBER_WRITE    ALLOWED_RANGES        {1 2 4 8 16 32 64 128 256 512}
set_parameter_property    MAX_CONTEXT_NUMBER_WRITE    HDL_PARAMETER         true
set_parameter_property    MAX_CONTEXT_NUMBER_WRITE    AFFECTS_ELABORATION   false

add_packet_transfer_master_parameters WRITE "Write master"

add_parameter COMB_OUTPUT_WRITE INTEGER 0
set_parameter_property    COMB_OUTPUT_WRITE     DISPLAY_NAME          "Use combination output for the response port"
set_parameter_property    COMB_OUTPUT_WRITE     ALLOWED_RANGES        0:1
set_parameter_property    COMB_OUTPUT_WRITE     DISPLAY_HINT          boolean
set_parameter_property    COMB_OUTPUT_WRITE     HDL_PARAMETER         true
set_parameter_property    COMB_OUTPUT_WRITE     AFFECTS_ELABORATION   false

add_parameter PIPELINE_READY_WRITE INTEGER 0
set_parameter_property    PIPELINE_READY_WRITE     DISPLAY_NAME          "Pipeline the ready signal in the response port"
set_parameter_property    PIPELINE_READY_WRITE     ALLOWED_RANGES        0:1
set_parameter_property    PIPELINE_READY_WRITE     DISPLAY_HINT          boolean
set_parameter_property    PIPELINE_READY_WRITE     HDL_PARAMETER         true
set_parameter_property    PIPELINE_READY_WRITE     AFFECTS_ELABORATION   false

add_parameter RESPONSE_DETINATION_ID_WRITE INTEGER 0
set_parameter_property    RESPONSE_DETINATION_ID_WRITE    DISPLAY_NAME          "Destination ID for response port"
set_parameter_property    RESPONSE_DETINATION_ID_WRITE    ALLOWED_RANGES        0:65535
set_parameter_property    RESPONSE_DETINATION_ID_WRITE    HDL_PARAMETER         true
set_parameter_property    RESPONSE_DETINATION_ID_WRITE    AFFECTS_ELABORATION   false

add_parameter RESPONSE_SOURCE_ID_WRITE INTEGER 0
set_parameter_property    RESPONSE_SOURCE_ID_WRITE    DISPLAY_NAME          "Source ID for response port"
set_parameter_property    RESPONSE_SOURCE_ID_WRITE    ALLOWED_RANGES        0:65535
set_parameter_property    RESPONSE_SOURCE_ID_WRITE    HDL_PARAMETER         true
set_parameter_property    RESPONSE_SOURCE_ID_WRITE    AFFECTS_ELABORATION   false

# Not a HDL parameter
add_parameter ENABLE_ADV_SETTING_WRITE INTEGER 0
set_parameter_property    ENABLE_ADV_SETTING_WRITE     DISPLAY_NAME          "Show advanced settings"
set_parameter_property    ENABLE_ADV_SETTING_WRITE     ALLOWED_RANGES        0:1
set_parameter_property    ENABLE_ADV_SETTING_WRITE     DISPLAY_HINT          boolean
set_parameter_property    ENABLE_ADV_SETTING_WRITE     HDL_PARAMETER         false
set_parameter_property    ENABLE_ADV_SETTING_WRITE     AFFECTS_ELABORATION   false




# parameters for read side
add_parameter READ_ENABLE INTEGER 0
set_parameter_property    READ_ENABLE     DISPLAY_NAME          "Enable read"
set_parameter_property    READ_ENABLE     ALLOWED_RANGES        0:1
set_parameter_property    READ_ENABLE     DISPLAY_HINT          boolean
set_parameter_property    READ_ENABLE     HDL_PARAMETER         true
set_parameter_property    READ_ENABLE     AFFECTS_ELABORATION   true

add_parameter ENABLE_MANY_COMMAND_READ INTEGER 0
set_parameter_property    ENABLE_MANY_COMMAND_READ     DISPLAY_NAME          "Enable Many Command support"
set_parameter_property    ENABLE_MANY_COMMAND_READ     ALLOWED_RANGES        0:1
set_parameter_property    ENABLE_MANY_COMMAND_READ     DISPLAY_HINT          boolean
set_parameter_property    ENABLE_MANY_COMMAND_READ     HDL_PARAMETER         true
set_parameter_property    ENABLE_MANY_COMMAND_READ     AFFECTS_ELABORATION   false

add_parameter ENABLE_PERIOD_MODE_READ INTEGER 0
set_parameter_property    ENABLE_PERIOD_MODE_READ     DISPLAY_NAME          "Enable Period Mode"
set_parameter_property    ENABLE_PERIOD_MODE_READ     ALLOWED_RANGES        0:1
set_parameter_property    ENABLE_PERIOD_MODE_READ     DISPLAY_HINT          boolean
set_parameter_property    ENABLE_PERIOD_MODE_READ     HDL_PARAMETER         true
set_parameter_property    ENABLE_PERIOD_MODE_READ     AFFECTS_ELABORATION   false

add_parameter ENABLE_COMMAND_BUFFER_READ INTEGER 0
set_parameter_property    ENABLE_COMMAND_BUFFER_READ    DISPLAY_NAME          "Buffer the command before it is executed"
set_parameter_property    ENABLE_COMMAND_BUFFER_READ     ALLOWED_RANGES        0:1
set_parameter_property    ENABLE_COMMAND_BUFFER_READ     DISPLAY_HINT          boolean
set_parameter_property    ENABLE_COMMAND_BUFFER_READ     HDL_PARAMETER         true
set_parameter_property    ENABLE_COMMAND_BUFFER_READ     AFFECTS_ELABORATION   false


add_parameter MAX_PACKET_SIZE_READ INTEGER $vipsuite_max_width
set_parameter_property    MAX_PACKET_SIZE_READ    DISPLAY_NAME          "Maximum supported packet size"
set_parameter_property    MAX_PACKET_SIZE_READ    ALLOWED_RANGES        1:268435456
set_parameter_property    MAX_PACKET_SIZE_READ    HDL_PARAMETER         true
set_parameter_property    MAX_PACKET_SIZE_READ    AFFECTS_ELABORATION   false

add_parameter PREFETCH_THRESHOLD_READ INTEGER 1
set_parameter_property    PREFETCH_THRESHOLD_READ    DISPLAY_NAME          "Prefetch threshold"
set_parameter_property    PREFETCH_THRESHOLD_READ    ALLOWED_RANGES        {0:No_Prefetch 1:One_Full_Burst 2:Half_Burst 4:Quarter_Burst}
set_parameter_property    PREFETCH_THRESHOLD_READ    HDL_PARAMETER         true
set_parameter_property    PREFETCH_THRESHOLD_READ    AFFECTS_ELABORATION   false

add_parameter MAX_CONTEXT_NUMBER_READ INTEGER 1
set_parameter_property    MAX_CONTEXT_NUMBER_READ    DISPLAY_NAME          "Context number (affect resource)"
set_parameter_property    MAX_CONTEXT_NUMBER_READ    ALLOWED_RANGES        {1 2 4 8 16 32 64 128 256 512}
set_parameter_property    MAX_CONTEXT_NUMBER_READ    HDL_PARAMETER         true
set_parameter_property    MAX_CONTEXT_NUMBER_READ    AFFECTS_ELABORATION   false

add_packet_transfer_master_parameters READ "Read master"


add_parameter OUTPUT_MSG_QUEUE_DEPTH_READ INTEGER 4
set_parameter_property    OUTPUT_MSG_QUEUE_DEPTH_READ    DISPLAY_NAME          "FIFO depth for streaming output messages"
set_parameter_property    OUTPUT_MSG_QUEUE_DEPTH_READ    ALLOWED_RANGES        {2 4 8 16 32 64 128 256}
set_parameter_property    OUTPUT_MSG_QUEUE_DEPTH_READ    HDL_PARAMETER         true
set_parameter_property    OUTPUT_MSG_QUEUE_DEPTH_READ    AFFECTS_ELABORATION   false

add_parameter MM_MSG_QUEUE_DEPTH_READ INTEGER 8
set_parameter_property    MM_MSG_QUEUE_DEPTH_READ    DISPLAY_NAME          "FIFO depth for memory map read messages"
set_parameter_property    MM_MSG_QUEUE_DEPTH_READ    ALLOWED_RANGES        {2 4 8 16 32 64 128 256}
set_parameter_property    MM_MSG_QUEUE_DEPTH_READ    HDL_PARAMETER         true
set_parameter_property    MM_MSG_QUEUE_DEPTH_READ    AFFECTS_ELABORATION   false

add_parameter LOGIC_ONLY_SCFIFO_READ INTEGER 1
set_parameter_property    LOGIC_ONLY_SCFIFO_READ     DISPLAY_NAME          "Use logic element for FIFOs when possible"
set_parameter_property    LOGIC_ONLY_SCFIFO_READ     ALLOWED_RANGES        0:1
set_parameter_property    LOGIC_ONLY_SCFIFO_READ     DISPLAY_HINT          boolean
set_parameter_property    LOGIC_ONLY_SCFIFO_READ     HDL_PARAMETER         true
set_parameter_property    LOGIC_ONLY_SCFIFO_READ     AFFECTS_ELABORATION   false

add_parameter PIPELINE_READY_READ INTEGER 0
set_parameter_property    PIPELINE_READY_READ    DISPLAY_NAME          "Pipeline the ready signal for dout"
set_parameter_property    PIPELINE_READY_READ     ALLOWED_RANGES        0:1
set_parameter_property    PIPELINE_READY_READ     DISPLAY_HINT          boolean
set_parameter_property    PIPELINE_READY_READ     HDL_PARAMETER         true
set_parameter_property    PIPELINE_READY_READ     AFFECTS_ELABORATION   false

add_parameter COMB_OUTPUT_READ INTEGER 0
set_parameter_property    COMB_OUTPUT_READ    DISPLAY_NAME          "Use combination output for dout (reduce fmax)"
set_parameter_property    COMB_OUTPUT_READ     ALLOWED_RANGES        0:1
set_parameter_property    COMB_OUTPUT_READ     DISPLAY_HINT          boolean
set_parameter_property    COMB_OUTPUT_READ     HDL_PARAMETER         true
set_parameter_property    COMB_OUTPUT_READ     AFFECTS_ELABORATION   false

add_parameter DOUT_MAX_DESTINATION_ID_NUM_READ INTEGER 32
set_parameter_property    DOUT_MAX_DESTINATION_ID_NUM_READ    DISPLAY_NAME          "Maximum supported Destination ID"
set_parameter_property    DOUT_MAX_DESTINATION_ID_NUM_READ    ALLOWED_RANGES        1:65535
set_parameter_property    DOUT_MAX_DESTINATION_ID_NUM_READ    HDL_PARAMETER         true
set_parameter_property    DOUT_MAX_DESTINATION_ID_NUM_READ    AFFECTS_ELABORATION   false

add_parameter DOUT_SOURCE_ID_READ INTEGER 0
set_parameter_property    DOUT_SOURCE_ID_READ    DISPLAY_NAME          "Source ID for Packet Transfer Read size"
set_parameter_property    DOUT_SOURCE_ID_READ    ALLOWED_RANGES        0:65535
set_parameter_property    DOUT_SOURCE_ID_READ    HDL_PARAMETER         true
set_parameter_property    DOUT_SOURCE_ID_READ    AFFECTS_ELABORATION   false

# Not a HDL parameter
add_parameter ENABLE_ADV_SETTING_READ INTEGER 0
set_parameter_property    ENABLE_ADV_SETTING_READ     DISPLAY_NAME          "Show advanced settings"
set_parameter_property    ENABLE_ADV_SETTING_READ     ALLOWED_RANGES        0:1
set_parameter_property    ENABLE_ADV_SETTING_READ     DISPLAY_HINT          boolean
set_parameter_property    ENABLE_ADV_SETTING_READ     HDL_PARAMETER         false
set_parameter_property    ENABLE_ADV_SETTING_READ     AFFECTS_ELABORATION   false


add_av_st_event_parameters

# | 
# +-----------------------------------


# +-----------------------------------
# | display items
# | 
add_display_item  "Video Data Format"    DATA_WIDTH           parameter
add_display_item  "Video Data Format"    SYMBOLS_IN_SEQ           parameter
add_display_item  "Video Data Format"    COLOR_PLANES_ARE_IN_PARALLEL           parameter
add_display_item  "Video Data Format"    ELEMENTS_IN_PARALLEL                   parameter
add_display_item  "Video Data Format"       SRC_WIDTH         parameter
add_display_item  "Video Data Format"       DST_WIDTH         parameter
add_display_item  "Video Data Format"       CONTEXT_WIDTH         parameter
add_display_item  "Video Data Format"       TASK_WIDTH         parameter

add_display_item  "MM Interface"         MEM_PORT_WIDTH       parameter
add_display_item  "MM Interface"         MEM_ADDR_WIDTH       parameter
add_display_item  "MM Interface"         BURST_ALIGNMENT      parameter
add_display_item  "MM Interface"         WRITE_HAS_PRIORITY       parameter
add_display_item  "MM Interface"         CLOCKS_ARE_SEPARATE       parameter


add_display_item  "Write Side Parameter"       WRITE_ENABLE         parameter
add_display_item  "Write Side Parameter"       MAX_CONTEXT_NUMBER_WRITE         parameter
add_display_item  "Write Side Parameter"       CONTEXT_BUFFER_RATIO_WRITE         parameter
add_display_item  "Write Side Parameter"       BURST_TARGET_WRITE         parameter
add_display_item  "Write Side Parameter"       MAX_PACKET_SIZE_WRITE         parameter
add_display_item  "Write Side Parameter"       MAX_PACKET_NUM_WRITE         parameter
add_display_item  "Write Side Parameter"       ENABLE_ADV_SETTING_WRITE         parameter
add_display_item  "Write Side Parameter"       SUPPORT_BEATS_OVERFLOW_PRETECTION         parameter
add_display_item  "Write Side Parameter"       ENABLE_MANY_COMMAND_WRITE         parameter
add_display_item  "Write Side Parameter"       ENABLE_PERIOD_MODE_WRITE         parameter
add_display_item  "Write Side Parameter"       ENABLE_MM_OUTPUT_REGISTER         parameter
add_display_item  "Write Side Parameter"       USE_RESPONSE_WRITE         parameter
add_display_item  "Write Side Parameter"       RESPONSE_DETINATION_ID_WRITE         parameter
add_display_item  "Write Side Parameter"       RESPONSE_SOURCE_ID_WRITE         parameter
add_display_item  "Write Side Parameter"       PIPELINE_READY_WRITE         parameter
add_display_item  "Write Side Parameter"       COMB_OUTPUT_WRITE         parameter


add_display_item  "Read Side Parameter"       READ_ENABLE         parameter
add_display_item  "Read Side Parameter"       MAX_CONTEXT_NUMBER_READ         parameter
add_display_item  "Read Side Parameter"       CONTEXT_BUFFER_RATIO_READ         parameter
add_display_item  "Read Side Parameter"       BURST_TARGET_READ         parameter
add_display_item  "Read Side Parameter"       MAX_PACKET_SIZE_READ         parameter
add_display_item  "Read Side Parameter"       PREFETCH_THRESHOLD_READ         parameter
add_display_item  "Read Side Parameter"       ENABLE_ADV_SETTING_READ         parameter
add_display_item  "Read Side Parameter"       ENABLE_MANY_COMMAND_READ         parameter
add_display_item  "Read Side Parameter"       ENABLE_PERIOD_MODE_READ         parameter
add_display_item  "Read Side Parameter"       ENABLE_COMMAND_BUFFER_READ         parameter
add_display_item  "Read Side Parameter"       COMB_OUTPUT_READ         parameter
add_display_item  "Read Side Parameter"       PIPELINE_READY_READ         parameter
add_display_item  "Read Side Parameter"       LOGIC_ONLY_SCFIFO_READ         parameter
add_display_item  "Read Side Parameter"       MAX_DESTINATION_ID_NUM_READ         parameter
add_display_item  "Read Side Parameter"       SOURCE_ID_READ         parameter
add_display_item  "Read Side Parameter"       OUTPUT_MSG_QUEUE_DEPTH_READ         parameter
add_display_item  "Read Side Parameter"       MM_MSG_QUEUE_DEPTH_READ         parameter
# | 
# +-----------------------------------




# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# The internal clock (and associated reset)
add_clock_port av_st_clock
# --                                                                                              --
# --------------------------------------------------------------------------------------------------



proc packet_transfer_elaboration_callback {} {
  set write_enabled        [get_parameter_value WRITE_ENABLE]
  set read_enabled         [get_parameter_value READ_ENABLE]
  set write_response_enabled        [get_parameter_value USE_RESPONSE_WRITE]
  set elements_in_parallel [get_parameter_value ELEMENTS_IN_PARALLEL]
  
  if {$write_enabled > 0 && $read_enabled > 0} {
    set both_enabled 1
  } else {
    set both_enabled 0
  }
  
  if {[get_parameter CLOCKS_ARE_SEPARATE] == 1} {
    add_clock_port av_mm_clock
  }

  set st_data_width [get_parameter_value DATA_WIDTH]

  set d_src_width                  [get_parameter_value SRC_WIDTH]
  set d_dst_width                  [get_parameter_value DST_WIDTH]
  set d_context_width              [get_parameter_value CONTEXT_WIDTH]
  set d_task_width                 [get_parameter_value TASK_WIDTH]
  set d_control_width              [expr $d_src_width + $d_dst_width + $d_context_width + $d_task_width]
  
  set mem_width             [get_parameter_value MEM_PORT_WIDTH] 
  set burst_align           [get_parameter_value BURST_ALIGNMENT]
  
  if {$write_enabled > 0} {
    if {$read_enabled > 0 && [get_parameter_value BURST_TARGET_READ] > [get_parameter_value BURST_TARGET_WRITE]} {
      set mem_butst_size     [get_parameter_value BURST_TARGET_READ]
    } else {
      set mem_butst_size     [get_parameter_value BURST_TARGET_WRITE]
    }
  } else {
    set mem_butst_size       [get_parameter_value BURST_TARGET_READ]
  }
  
  add_av_st_cmd_sink_port   av_st_cmd   1   $d_dst_width   $d_src_width   $d_task_width   $d_context_width   av_st_clock   0
  
  if {$write_enabled > 0} {
    add_av_st_data_sink_port   av_st_din   $st_data_width   $elements_in_parallel   $d_dst_width   $d_src_width   $d_task_width   $d_context_width   0    av_st_clock   0
    if {$write_response_enabled > 0} {
      add_av_st_resp_source_port   av_st_resp   1   $d_dst_width   $d_src_width   $d_task_width   $d_context_width   av_st_clock   0
    }
  }
  
  if {$read_enabled > 0} {
    add_av_st_data_source_port   av_st_dout   $st_data_width   $elements_in_parallel   $d_dst_width   $d_src_width   $d_task_width   $d_context_width   0    av_st_clock   0
  }
  
  if {[get_parameter CLOCKS_ARE_SEPARATE] == 1} {
    add_av_mm_master_port av_mm_master $write_enabled $read_enabled $mem_width [expr $mem_width/8] $mem_butst_size $burst_align av_mm_clock
  } else {
    add_av_mm_master_port av_mm_master $write_enabled $read_enabled $mem_width [expr $mem_width/8] $mem_butst_size $burst_align av_st_clock
  }
  
}


proc packet_transfer_validation_callback {} {
  set write_enabled       [get_parameter_value WRITE_ENABLE]
  set read_enabled        [get_parameter_value READ_ENABLE]
  set ctxt_num_write      [get_parameter_value MAX_CONTEXT_NUMBER_WRITE]
  set ctxt_num_read       [get_parameter_value MAX_CONTEXT_NUMBER_READ]
  
  set cmany_enabled_write [get_parameter_value ENABLE_MANY_COMMAND_WRITE]
  set cmany_enabled_read  [get_parameter_value ENABLE_MANY_COMMAND_READ]
  set period_mode_enabled_write [get_parameter_value ENABLE_PERIOD_MODE_WRITE]
  set period_mode_enabled_read  [get_parameter_value ENABLE_PERIOD_MODE_READ]
  
  set data_width           [get_parameter_value DATA_WIDTH]
  set elements_in_parallel [get_parameter_value ELEMENTS_IN_PARALLEL]
  set symbols_in_seq       [get_parameter_value SYMBOLS_IN_SEQ] 
  set mem_width            [get_parameter_value MEM_PORT_WIDTH] 

  set total_data_width     [expr $elements_in_parallel * $data_width]
  
  if {$write_enabled == 0 && $read_enabled == 0} {
    send_message error "Write and Read cannot be disabled at the same time."
  }
  
  if {$symbols_in_seq > 1 && $elements_in_parallel > 1} {
    send_message error "Multiple elements in parallel is supported only when all emelemts are transmitted in parallel"
  }
  
  if {$elements_in_parallel > 1 && ($cmany_enabled_write > 0 || $period_mode_enabled_write > 0 || $cmany_enabled_read > 0 || $period_mode_enabled_read > 0)} {
    send_message error "Multiple elements in parallel is not supported for many command mode nor period mode"
  }


  if {[expr $total_data_width * 3 / 4] > $mem_width} {
    send_message error "Input width ($total_data_width) is too wide for this MM width ($mem_width) setup."
  }

  if {($total_data_width == 4 && $mem_width > 128) || ($total_data_width <= 8 && $mem_width > 256) || ($total_data_width < 16 && $mem_width > 512)} {
    send_message error "Maximum MEM width ($mem_width) to Data width ($total_data_width) ratio is 32. Please reduce the MEM width."
  }

  
  if ($write_enabled) {
  
    if {$ctxt_num_write >= 64 && $period_mode_enabled_write == 0} {
      send_message warning "WRITE: Large context number ($ctxt_num_write) will reduce fmax, consider enabling Period Mode when applicable"
    }
    
    if {$cmany_enabled_write && [get_parameter_value MAX_CONTEXT_NUMBER_WRITE] < 2} {
      send_message error "WRITE: Many Command can only be enabled when Maximum Context Number is greater than 1"
    }
    
    if {$cmany_enabled_write == 0 && $period_mode_enabled_write} {
      send_message error "WRITE: Period Mode can only be enabled when Many Command is enabled"
    }
  
    set_parameter_property    MAX_CONTEXT_NUMBER_WRITE      ENABLED    true
    set_parameter_property    CONTEXT_BUFFER_RATIO_WRITE    ENABLED    true
    set_parameter_property    BURST_TARGET_WRITE            ENABLED    true
    set_parameter_property    MAX_PACKET_SIZE_WRITE         ENABLED    true
    set_parameter_property    MAX_PACKET_NUM_WRITE          ENABLED    true
    set_parameter_property    ENABLE_ADV_SETTING_WRITE      ENABLED    true
    set_parameter_property    USE_RESPONSE_WRITE            ENABLED    true
  } else {
    set_parameter_property    MAX_CONTEXT_NUMBER_WRITE      ENABLED    false
    set_parameter_property    CONTEXT_BUFFER_RATIO_WRITE    ENABLED    false
    set_parameter_property    BURST_TARGET_WRITE            ENABLED    false
    set_parameter_property    MAX_PACKET_SIZE_WRITE         ENABLED    false
    set_parameter_property    MAX_PACKET_NUM_WRITE          ENABLED    false
    set_parameter_property    ENABLE_ADV_SETTING_WRITE      ENABLED    false
    set_parameter_property    USE_RESPONSE_WRITE            ENABLED    false
  }
  
  if {$write_enabled && [get_parameter_value ENABLE_ADV_SETTING_WRITE]} {
    set_parameter_property    SUPPORT_BEATS_OVERFLOW_PRETECTION    VISIBLE    true
    set_parameter_property    ENABLE_MANY_COMMAND_WRITE     VISIBLE    true
    set_parameter_property    ENABLE_PERIOD_MODE_WRITE      VISIBLE    true
    set_parameter_property    ENABLE_MM_OUTPUT_REGISTER     VISIBLE    true
  } else {
    set_parameter_property    SUPPORT_BEATS_OVERFLOW_PRETECTION    VISIBLE    false
    set_parameter_property    ENABLE_MANY_COMMAND_WRITE     VISIBLE    false
    set_parameter_property    ENABLE_PERIOD_MODE_WRITE      VISIBLE    false
    set_parameter_property    ENABLE_MM_OUTPUT_REGISTER     VISIBLE    false
  }
  
  if {$write_enabled && [get_parameter_value USE_RESPONSE_WRITE]} {
    set_parameter_property    RESPONSE_DETINATION_ID_WRITE  VISIBLE    true
    set_parameter_property    RESPONSE_SOURCE_ID_WRITE      VISIBLE    true
    set_parameter_property    PIPELINE_READY_WRITE          VISIBLE    true
    set_parameter_property    COMB_OUTPUT_WRITE             VISIBLE    true
  } else {
    set_parameter_property    RESPONSE_DETINATION_ID_WRITE  VISIBLE    false
    set_parameter_property    RESPONSE_SOURCE_ID_WRITE      VISIBLE    false
    set_parameter_property    PIPELINE_READY_WRITE          VISIBLE    false
    set_parameter_property    COMB_OUTPUT_WRITE             VISIBLE    false
  }
  
  
  if ($read_enabled) {
  
    if {$ctxt_num_read >= 64 && $period_mode_enabled_read == 0} {
      send_message warning "READ: Large context number ($ctxt_num_read) will reduce fmax, consider enabling Period Mode when applicable"
    }
    
    if {$cmany_enabled_read && [get_parameter_value MAX_CONTEXT_NUMBER_READ] < 2} {
      send_message error "READ: Many Command can only be enabled when Maximum Context Number is greater than 1"
    }
    
    if {$cmany_enabled_read == 0&& $period_mode_enabled_read} {
      send_message error "READ: Period Mode can only be enabled when Many Command is enabled"
    }
  
    set_parameter_property    MAX_CONTEXT_NUMBER_READ      ENABLED    true
    set_parameter_property    CONTEXT_BUFFER_RATIO_READ    ENABLED    true
    set_parameter_property    BURST_TARGET_READ            ENABLED    true
    set_parameter_property    MAX_PACKET_SIZE_READ         ENABLED    true
    set_parameter_property    PREFETCH_THRESHOLD_READ      ENABLED    true
    set_parameter_property    ENABLE_ADV_SETTING_READ      ENABLED    true

  } else {
    set_parameter_property    MAX_CONTEXT_NUMBER_READ      ENABLED    false
    set_parameter_property    CONTEXT_BUFFER_RATIO_READ    ENABLED    false
    set_parameter_property    BURST_TARGET_READ            ENABLED    false
    set_parameter_property    MAX_PACKET_SIZE_READ         ENABLED    false
    set_parameter_property    PREFETCH_THRESHOLD_READ      ENABLED    false
    set_parameter_property    ENABLE_ADV_SETTING_READ      ENABLED    false
  }
  
  if {$read_enabled && [get_parameter_value ENABLE_ADV_SETTING_READ]} {
    set_parameter_property    ENABLE_MANY_COMMAND_READ     VISIBLE    true
    set_parameter_property    ENABLE_PERIOD_MODE_READ      VISIBLE    true
    set_parameter_property    ENABLE_COMMAND_BUFFER_READ   VISIBLE    true
    set_parameter_property    COMB_OUTPUT_READ             VISIBLE    true
    set_parameter_property    PIPELINE_READY_READ          VISIBLE    true
    set_parameter_property    LOGIC_ONLY_SCFIFO_READ       VISIBLE    true
    set_parameter_property    DOUT_MAX_DESTINATION_ID_NUM_READ  VISIBLE    true
    set_parameter_property    DOUT_SOURCE_ID_READ          VISIBLE    true
    set_parameter_property    OUTPUT_MSG_QUEUE_DEPTH_READ  VISIBLE    true
    set_parameter_property    MM_MSG_QUEUE_DEPTH_READ      VISIBLE    true
  } else {
    set_parameter_property    ENABLE_MANY_COMMAND_READ     VISIBLE    false
    set_parameter_property    ENABLE_PERIOD_MODE_READ      VISIBLE    false
    set_parameter_property    ENABLE_COMMAND_BUFFER_READ   VISIBLE    false
    set_parameter_property    COMB_OUTPUT_READ             VISIBLE    false
    set_parameter_property    PIPELINE_READY_READ          VISIBLE    false
    set_parameter_property    LOGIC_ONLY_SCFIFO_READ       VISIBLE    false
    set_parameter_property    DOUT_MAX_DESTINATION_ID_NUM_READ  VISIBLE    false
    set_parameter_property    DOUT_SOURCE_ID_READ          VISIBLE    false
    set_parameter_property    OUTPUT_MSG_QUEUE_DEPTH_READ  VISIBLE    false
    set_parameter_property    MM_MSG_QUEUE_DEPTH_READ      VISIBLE    false
  }
  
  
}





