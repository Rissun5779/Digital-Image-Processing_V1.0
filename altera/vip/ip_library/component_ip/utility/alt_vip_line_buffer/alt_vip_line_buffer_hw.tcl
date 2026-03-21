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
#-- _hw.tcl compose file for the line buffer component                                            --
#-- buffers multiple input lines for algorithmic cores that process images using kernel of pixels --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source   ../../../common_tcl/alt_vip_helper_common.tcl
source   ../../../common_tcl/alt_vip_files_common.tcl
source   ../../../common_tcl/alt_vip_parameters_common.tcl
source   ../../../common_tcl/alt_vip_interfaces_common.tcl

# Common component properties for VIP components
declare_general_component_info

# Component properties
set_module_property  NAME                 alt_vip_line_buffer
set_module_property  DISPLAY_NAME         "Video Line Buffer"
set_module_property  DESCRIPTION          "This block receives lines of video data on its Avalon-ST Message Data sink,
\stores them and outputs kernels of lines through one or more Avalon-ST Message Data sources.
\Operations are controlled through an Avalon-ST Message Command sink"

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
# Validation callback to check legality of parameter set
set_module_property  VALIDATION_CALLBACK  line_buffer_validation_callback

# Elaboration callback to set up the dynamic ports
set_module_property  ELABORATION_CALLBACK line_buffer_elaboration_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files                          ../../..
add_alt_vip_common_event_packet_decode_files          ../../..
add_alt_vip_common_event_packet_encode_files          ../../..
add_alt_vip_common_fifo2_files                        ../../..
add_alt_vip_common_sop_align_files                    ../../..
add_static_sv_file src_hdl/alt_vip_line_buffer_controller.sv
add_static_sv_file src_hdl/alt_vip_line_buffer_mem_block.sv
add_static_sv_file src_hdl/alt_vip_line_buffer_multicaster.sv
add_static_sv_file src_hdl/alt_vip_line_buffer.sv

setup_filesets alt_vip_line_buffer


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_parameter           PIXEL_WIDTH                INTEGER              20
set_parameter_property  PIXEL_WIDTH                DISPLAY_NAME         "Bits per pixel"
set_parameter_property  PIXEL_WIDTH                ALLOWED_RANGES       4:80
set_parameter_property  PIXEL_WIDTH                AFFECTS_GENERATION   true
set_parameter_property  PIXEL_WIDTH                HDL_PARAMETER        true 

add_parameter          SYMBOLS_IN_SEQ              INTEGER              1
set_parameter_property SYMBOLS_IN_SEQ              ALLOWED_RANGES       1:4
set_parameter_property SYMBOLS_IN_SEQ              DISPLAY_NAME         "Number of symbols in sequence" 
set_parameter_property SYMBOLS_IN_SEQ              DESCRIPTION          "Number of beats of Avalon-ST data transmitted in sequence for each pixel (or data unit if not pixel data)"        
set_parameter_property SYMBOLS_IN_SEQ              AFFECTS_ELABORATION  true         
set_parameter_property SYMBOLS_IN_SEQ              HDL_PARAMETER        true 

add_pixels_in_parallel_parameters       {1 2 4 8}

add_parameter           CONVERT_TO_1_PIP           INTEGER              0 
set_parameter_property  CONVERT_TO_1_PIP           ALLOWED_RANGES       0:1
set_parameter_property  CONVERT_TO_1_PIP           DISPLAY_NAME         "Convert to output 1 pixel in parallel"
set_parameter_property  CONVERT_TO_1_PIP           DISPLAY_HINT         boolean
set_parameter_property  CONVERT_TO_1_PIP           HDL_PARAMETER        true
set_parameter_property  CONVERT_TO_1_PIP           AFFECTS_ELABORATION  true
set_parameter_property  CONVERT_TO_1_PIP           DESCRIPTION          "Enables multiple to single pixel in parallel conversion within the line buffer"  

add_max_line_length_parameters   32    $vipsuite_max_width

add_parameter           OUTPUT_PORTS               INTEGER              1 
set_parameter_property  OUTPUT_PORTS               DESCRIPTION          "Number of data outputs"
set_parameter_property  OUTPUT_PORTS               ALLOWED_RANGES       {1 2 3 4 5 6 7 8}
set_parameter_property  OUTPUT_PORTS               DISPLAY_NAME         "Output ports"
set_parameter_property  OUTPUT_PORTS               HDL_PARAMETER        true
set_parameter_property  OUTPUT_PORTS               AFFECTS_ELABORATION  true

add_parameter           MODE                       STRING               LOCKED 
set_parameter_property  MODE                       ALLOWED_RANGES       {LOCKED RATE_MATCHING}
set_parameter_property  MODE                       DISPLAY_NAME         "Mode of operation"
set_parameter_property  MODE                       HDL_PARAMETER        true
set_parameter_property  MODE                       AFFECTS_ELABORATION  true
set_parameter_property  MODE                       DESCRIPTION          "Mode of operation: LOCKED means write and read operations execute in lock step.
\RATE_MATCHING means the read and writes may execute at different rates, with the write able to lag the read and vice versa"

add_parameter           ENABLE_RECEIVE_ONLY_CMD    INTEGER              0 
set_parameter_property  ENABLE_RECEIVE_ONLY_CMD    ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_RECEIVE_ONLY_CMD    DISPLAY_NAME         "Enable receive without shift commands"
set_parameter_property  ENABLE_RECEIVE_ONLY_CMD    DISPLAY_HINT         boolean
set_parameter_property  ENABLE_RECEIVE_ONLY_CMD    HDL_PARAMETER        true
set_parameter_property  ENABLE_RECEIVE_ONLY_CMD    AFFECTS_ELABORATION  false
set_parameter_property  ENABLE_RECEIVE_ONLY_CMD    DESCRIPTION          "Enables the 'Receive Only' and 'Receive and Send' commands in LOCKED mode.
\These commands are always enabled in RATE_MATCHING mode"

add_parameter           TRACK_LINE_LENGTH          INTEGER              1 
set_parameter_property  TRACK_LINE_LENGTH          ALLOWED_RANGES       0:1
set_parameter_property  TRACK_LINE_LENGTH          DISPLAY_NAME         "Enable internal line length tracking"
set_parameter_property  TRACK_LINE_LENGTH          DISPLAY_HINT         boolean
set_parameter_property  TRACK_LINE_LENGTH          HDL_PARAMETER        true
set_parameter_property  TRACK_LINE_LENGTH          AFFECTS_ELABORATION  false
set_parameter_property  TRACK_LINE_LENGTH          DESCRIPTION          "Enabling this feature causes the line buffer to track acitve line lengths internally
\based on the arguments in the NEW_FRAME command, otherwise output line lengths must be supplied with all SEND_LINE commands"

add_parameter           OUTPUT_MUX_SEL             STRING               VARIABLE 
set_parameter_property  OUTPUT_MUX_SEL             ALLOWED_RANGES       {VARIABLE OLD NEW}
set_parameter_property  OUTPUT_MUX_SEL             DISPLAY_NAME         "Output data sent when exectuing a send combined with a shift and/or receive"
set_parameter_property  OUTPUT_MUX_SEL             HDL_PARAMETER        true
set_parameter_property  OUTPUT_MUX_SEL             AFFECTS_ELABORATION  false
set_parameter_property  OUTPUT_MUX_SEL             DESCRIPTION          "When doing a send combined with a receive or shift the user can either select that the kernel after the receive/shift is sent (NEW),
\the kernel before the receive/shift is sent (OLD) or this can be set at runtime using a command argument (VARIABLE)"

add_parameter           OUTPUT_OPTION              STRING               UNPIPELINED 
set_parameter_property  OUTPUT_OPTION              ALLOWED_RANGES       {UNPIPELINED PIPELINED}
set_parameter_property  OUTPUT_OPTION              DISPLAY_NAME         "Output register option"
set_parameter_property  OUTPUT_OPTION              HDL_PARAMETER        false
set_parameter_property  OUTPUT_OPTION              AFFECTS_ELABORATION  true
set_parameter_property  OUTPUT_OPTION              DESCRIPTION          "Selects the registering option used for every output port.
\'Unpipelined' leaves the output Avalon-ST ready signals unpipelined.
\'Pipelined' adds an extra register stage to each output so the Avalon-ST ready signal my be pipelined.
\'Add FIFOs' may be selected if the number of output ports is greater than one.
\This will add a FIFO of the specified size to each output port and also pipeline the Avalon-ST ready signals."

add_parameter           FIFO_SIZE                  INTEGER              4  
set_parameter_property  FIFO_SIZE                  DESCRIPTION          "Size of the output data FIFOs"
set_parameter_property  FIFO_SIZE                  ALLOWED_RANGES       {4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384}
set_parameter_property  FIFO_SIZE                  DISPLAY_NAME         "Output FIFO size"
set_parameter_property  FIFO_SIZE                  HDL_PARAMETER        true
set_parameter_property  FIFO_SIZE                  AFFECTS_ELABORATION  false
set_parameter_property  FIFO_SIZE                  VISIBLE              false

add_parameter           KERNEL_SIZE_0              INTEGER              8  
set_parameter_property  KERNEL_SIZE_0              DESCRIPTION          "Number of lines in the kernel of data output 0"
set_parameter_property  KERNEL_SIZE_0              ALLOWED_RANGES       1:64
set_parameter_property  KERNEL_SIZE_0              DISPLAY_NAME         "Kernel size 0"
set_parameter_property  KERNEL_SIZE_0              HDL_PARAMETER        true
set_parameter_property  KERNEL_SIZE_0              AFFECTS_ELABORATION  true

add_parameter           KERNEL_CENTER_0            INTEGER              3  
set_parameter_property  KERNEL_CENTER_0            DESCRIPTION          "Center line of the kernel for data output 0"
set_parameter_property  KERNEL_CENTER_0            ALLOWED_RANGES       0:64
set_parameter_property  KERNEL_CENTER_0            DISPLAY_NAME         "Kernel center 0"
set_parameter_property  KERNEL_CENTER_0            HDL_PARAMETER        true
set_parameter_property  KERNEL_CENTER_0            AFFECTS_ELABORATION  false

for { set i 1 } { $i < 8} { incr i } {

   add_parameter           KERNEL_SIZE_$i          INTEGER              8  
   set_parameter_property  KERNEL_SIZE_$i          DESCRIPTION          "Number of lines in the kernel of data output $i"
   set_parameter_property  KERNEL_SIZE_$i          ALLOWED_RANGES       1:64
   set_parameter_property  KERNEL_SIZE_$i          DISPLAY_NAME         "Kernel size $i"
   set_parameter_property  KERNEL_SIZE_$i          HDL_PARAMETER        true
   set_parameter_property  KERNEL_SIZE_$i          AFFECTS_ELABORATION  true
   set_parameter_property  KERNEL_SIZE_$i          VISIBLE              false
   
   add_parameter           KERNEL_START_$i         INTEGER              0  
   set_parameter_property  KERNEL_START_$i         DESCRIPTION          "Start line of the kernel for data output $i"
   set_parameter_property  KERNEL_START_$i         ALLOWED_RANGES       0:64
   set_parameter_property  KERNEL_START_$i         DISPLAY_NAME         "Kernel start $i"
   set_parameter_property  KERNEL_START_$i         HDL_PARAMETER        true
   set_parameter_property  KERNEL_START_$i         AFFECTS_ELABORATION  false
   set_parameter_property  KERNEL_START_$i         VISIBLE              false
   
   add_parameter           KERNEL_CENTER_$i        INTEGER              3  
   set_parameter_property  KERNEL_CENTER_$i        DESCRIPTION          "Center line of the kernel for data output $i"
   set_parameter_property  KERNEL_CENTER_$i        ALLOWED_RANGES       0:64
   set_parameter_property  KERNEL_CENTER_$i        DISPLAY_NAME         "Kernel center $i"
   set_parameter_property  KERNEL_CENTER_$i        HDL_PARAMETER        true
   set_parameter_property  KERNEL_CENTER_$i        AFFECTS_ELABORATION  false
   set_parameter_property  KERNEL_CENTER_$i        VISIBLE              false

}

# adds SRC_WIDTH, DST_WIDTH, CONTEXT_WIDTH, TASK_WIDTH
add_av_st_event_parameters

add_parameter              SOURCE_ADDRESS          INTEGER              0  
set_parameter_property     SOURCE_ADDRESS          DESCRIPTION          "Source ID of line buffer on dout interface(s)"
set_parameter_property     SOURCE_ADDRESS          DISPLAY_NAME         "Line buffer Source ID"
set_parameter_property     SOURCE_ADDRESS          HDL_PARAMETER        true
set_parameter_property     SOURCE_ADDRESS          AFFECTS_ELABORATION  true


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Derived parameters                                                                           --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_parameter              ENABLE_FIFOS            INTEGER              0
set_parameter_property     ENABLE_FIFOS            ALLOWED_RANGES       0:1
set_parameter_property     ENABLE_FIFOS            HDL_PARAMETER        true
set_parameter_property     ENABLE_FIFOS            AFFECTS_ELABORATION  false
set_parameter_property     ENABLE_FIFOS            DERIVED              true
set_parameter_property     ENABLE_FIFOS            VISIBLE              false

add_parameter              ENABLE_PIPELINE_REG     INTEGER              0
set_parameter_property     ENABLE_PIPELINE_REG     ALLOWED_RANGES       0:1
set_parameter_property     ENABLE_PIPELINE_REG     HDL_PARAMETER        true
set_parameter_property     ENABLE_PIPELINE_REG     AFFECTS_ELABORATION  false
set_parameter_property     ENABLE_PIPELINE_REG     DERIVED              true
set_parameter_property     ENABLE_PIPELINE_REG     VISIBLE              false

add_device_family_parameters
set_parameter_property  FAMILY                     HDL_PARAMETER        true


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports                                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_main_clock_port


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc line_buffer_validation_callback {} {
   
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set   task_width           [get_parameter_value TASK_WIDTH]
    set   output_option        [get_parameter_value OUTPUT_OPTION]
    set   symbols_in_seq       [get_parameter_value SYMBOLS_IN_SEQ]
    set   pip                  [get_parameter_value PIXELS_IN_PARALLEL]
    set   output_ports         [get_parameter_value OUTPUT_PORTS]
    set   mode_local           [get_parameter_value MODE]
    set   convert_to_1_pip     [get_parameter_value CONVERT_TO_1_PIP]
    set   src_width            [get_parameter_value SRC_WIDTH]
    set   src_id               [get_parameter_value SOURCE_ADDRESS]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    set   src_id_limit         [expr {pow(2, $src_width) - 1}]

    # --------------------------------------------------------------------------------------------------
    # -- Validation                                                                                   --
    # --------------------------------------------------------------------------------------------------
    if {$task_width < 4} {
        send_message   Error "Task ID Width for the command interface must be at least 4 bits"
    }
   
    if { $src_id > $src_id_limit } {
        send_message   Warning  "Source ID is outside the range supported by the specified dout Source ID width"
    }
    if { $src_id < 0 } {
        send_message Warning "Source ID is outside the range supported by the specified dout Source ID width"
    }
   
    if { $pip > 1 } {
        if { $symbols_in_seq > 1 } {
            send_message   Error "Symbols in sequence must be 1 if the number of pixels in parallel is greater than 1"
        }
    }
   
    if { $convert_to_1_pip > 0 } {
        if { $pip > 1 } {
            if { [string compare $mode_local LOCKED] == 0 } {
                send_message   Error "Conversion from multiple pixels in parallel to 1 pixel in parallel is only supported in rate matching mode"
            }
        } else {
            send_message   Error "Conversion from multiple pixels in parallel to 1 pixel in parallel is only supported when pixels in parallel is greater than 1"
        }
    }
   
    for { set i 0 } { $i < $output_ports } { incr i } {
        if { $i > 0 } {
            set   start    [get_parameter_value KERNEL_START_$i]
            set   end      [expr $start + [get_parameter_value KERNEL_SIZE_$i] - 1]
            set   center   [get_parameter_value KERNEL_CENTER_$i]
            if { $center > $end } {
                send_message   Error "The center line for the kernel of output port $i must be between 'Kernel $i start' and ('Kernel $i start' + 'Kernel $i size')"
            }
            if { $center < $start } {
                send_message   Error "The center line for the kernel of output port $i must be between 'Kernel $i start' and ('Kernel $i start' + 'Kernel $i size')"
            }
        }
    }

    # --------------------------------------------------------------------------------------------------
    # -- GUI constraints and setting derived parameters                                               --
    # --------------------------------------------------------------------------------------------------
    if { $output_ports > 1 } {
        set_parameter_property  OUTPUT_OPTION        ALLOWED_RANGES {UNPIPELINED PIPELINED ADD_FIFOS}
    } else {
        set_parameter_property  OUTPUT_OPTION        ALLOWED_RANGES {UNPIPELINED PIPELINED}
    }
    for { set i 1 } { $i < $output_ports } { incr i } {
        set_parameter_property  KERNEL_CENTER_$i  VISIBLE  true
        set_parameter_property  KERNEL_START_$i   VISIBLE  true
        set_parameter_property  KERNEL_SIZE_$i    VISIBLE  true
    }
    for { set i $output_ports } { $i < 8 } { incr i } {
        set_parameter_property  KERNEL_CENTER_$i  VISIBLE  false
        set_parameter_property  KERNEL_START_$i   VISIBLE  false
        set_parameter_property  KERNEL_SIZE_$i    VISIBLE  false
    }

   set_parameter_property     FIFO_SIZE VISIBLE    false
   set_parameter_value        ENABLE_FIFOS         0
   set_parameter_value        ENABLE_PIPELINE_REG  0
   if { [string compare $output_option ADD_FIFOS] == 0 } {
      set_parameter_property  FIFO_SIZE VISIBLE    true
      set_parameter_value     ENABLE_FIFOS         1
   } else {
      if { [string compare $output_option PIPELINED] == 0 } {
         set_parameter_value  ENABLE_PIPELINE_REG  1
      }
   }
   


}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc line_buffer_elaboration_callback {} {

   set   output_ports         [get_parameter_value OUTPUT_PORTS]
   set   output_option        [get_parameter_value OUTPUT_OPTION]
   set   pip                  [get_parameter_value PIXELS_IN_PARALLEL]
   set   pixel_width          [get_parameter_value PIXEL_WIDTH]
   set   src_width            [get_parameter_value SRC_WIDTH]
   set   dst_width            [get_parameter_value DST_WIDTH]
   set   context_width        [get_parameter_value CONTEXT_WIDTH]
   set   task_width           [get_parameter_value TASK_WIDTH]
   set   src_id               [get_parameter_value SOURCE_ADDRESS]

   if {$pip > 1} {
      set   empty_width [clogb2_pure $pip]
      if { [get_parameter_value CONVERT_TO_1_PIP] > 0 } {
         set   pip_out           1
         set   empty_width_out   0
      } else {
         set   pip_out           $pip
         set   empty_width_out   $empty_width
      }
   } else {
      set   empty_width_out      0
      set   pip_out           1
   }
   
   add_av_st_cmd_sink_port    av_st_cmd                  1     $dst_width  $src_width  $task_width $context_width    main_clock  $src_id
   add_av_st_data_sink_port   av_st_din   $pixel_width   $pip  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
   
   set   data_start  0
   for { set i 0 } { $i < $output_ports } { incr i } {
      set   pixel_width_out   [expr [get_parameter_value KERNEL_SIZE_$i] * $pixel_width]
      set   data_width_out    [expr $pixel_width_out * $pip_out]
      set   control_width     [expr $dst_width + $src_width + $task_width + $context_width + 2*$empty_width_out]
      set   data_end          [expr $data_start + $data_width_out + $control_width]
      
      add_interface           av_st_dout_$i  avalon_streaming  start
      set_interface_property  av_st_dout_$i  readyLatency      0
      set_interface_property  av_st_dout_$i  ASSOCIATED_CLOCK  main_clock
      set_interface_property  av_st_dout_$i  ENABLED           true
      
      add_interface_port      av_st_dout_$i  av_st_dout_valid_$i           valid          Output   1
      add_interface_port      av_st_dout_$i  av_st_dout_ready_$i           ready          Input    1
      add_interface_port      av_st_dout_$i  av_st_dout_startofpacket_$i   startofpacket  Output   1
      add_interface_port      av_st_dout_$i  av_st_dout_endofpacket_$i     endofpacket    Output   1
      add_interface_port      av_st_dout_$i  av_st_dout_data_$i data Output [expr $data_width_out + $control_width]
      
      set_port_property       av_st_dout_ready_$i           FRAGMENT_LIST  "av_st_dout_ready@$i"
      set_port_property       av_st_dout_valid_$i           FRAGMENT_LIST  "av_st_dout_valid@$i"
      set_port_property       av_st_dout_startofpacket_$i   FRAGMENT_LIST  "av_st_dout_startofpacket@$i"
      set_port_property       av_st_dout_endofpacket_$i     FRAGMENT_LIST  "av_st_dout_endofpacket@$i"
      set_port_property       av_st_dout_data_$i            FRAGMENT_LIST  "av_st_dout_data@[expr $data_end-1]:$data_start"
      
      set   data_start        $data_end
      
      alt_vip_av_st_message_format::set_message_property           av_st_dout_$i                 PEID              $src_id
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  argument       SYMBOLS_PER_BEAT  $pip_out
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  argument       SYMBOL_WIDTH      $pixel_width_out
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  destination    BASE              0
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  destination    SYMBOL_WIDTH      $dst_width
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  source         BASE              $dst_width
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  source         SYMBOL_WIDTH      $src_width
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  taskid         BASE              [expr $dst_width + $src_width]
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  taskid         SYMBOL_WIDTH      $task_width
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  context        BASE              [expr $dst_width + $src_width + $task_width]
      alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  context        SYMBOL_WIDTH      $context_width
      if { $empty_width_out > 0 } {
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  user           BASE              [expr $dst_width + $src_width + $task_width + $context_width]
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_dout_$i  user           SYMBOL_WIDTH      $empty_width_out
      }
      alt_vip_av_st_message_format::validate_and_create            av_st_dout_$i
   
   }


}

