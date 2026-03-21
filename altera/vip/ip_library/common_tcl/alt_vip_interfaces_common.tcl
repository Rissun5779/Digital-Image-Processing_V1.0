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


package require -exact qsys 16.1

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Port declarations for the most common port types used by VIP components and Megacores        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set common_tcl_dir [file dirname [info script]]
set alt_vip_av_st_video_format_file [file join $common_tcl_dir "alt_vip_av_st_video_format.tcl"]
set alt_vip_av_st_message_format_file [file join $common_tcl_dir "alt_vip_av_st_message_format.tcl"]
source $alt_vip_av_st_video_format_file
source $alt_vip_av_st_message_format_file
package require alt_vip_av_st_video_format 1.0
package require alt_vip_av_st_message_format 1.0

# add_main_clock_port
# Add the main_clock interface and the main_reset interface to the component
# output: Create two top-level interfaces: main_clock and main_reset with
#         associated wires clock and reset (rather than main_clock and main_reset)
proc add_main_clock_port {} {
    add_interface       main_clock   clock       end
    add_interface       main_reset   reset       end       main_clock

    add_interface_port  main_clock   clock       clk       Input    1
    add_interface_port  main_reset   reset       reset     Input    1
}

# add_clock_port {string}
# Add a clock interface and reset interface to the component
# \param     name, a name;
#            using an empty name to create interfaces and wires without a prefix is not allowed
#            consider using add_main_clock_port if you have wires that are simply named "clock"
#            and "reset"
# output: Create two top-level interfaces: ${name}_clock and ${name}_reset with
#         associated wires ${name}_clock and ${name}_reset
#         if name already contains a _clock suffix, it is removed before names are determined
proc add_clock_port {name} {
    regsub -all {_clock} ${name} {} if_base_name
    add_interface        ${if_base_name}_clock   clock                    end
    add_interface        ${if_base_name}_reset   reset                    end      ${if_base_name}_clock
    add_interface_port   ${if_base_name}_clock   ${if_base_name}_clock    clk      Input  1
    add_interface_port   ${if_base_name}_reset   ${if_base_name}_reset    reset    Input  1
}





# add_av_st_input_port
# Add an Avalon-ST Input port to the component, see specialized functions below for a shortened call
# \param     clock,               clock interface associated with the Avalon-ST interface
# \param     input_name,          name of the Avalon-ST interface (din by default)
# \param     bits_per_symbol,     number of bits per symbols
# \param     symbols_per_beat,    number of symbols per beat (clock cycle)
# \param     packets_transfer,    whether sop and eop signals are used, use packets_transfer == 2 to also
#                                 include an empty signal when symbols_per_beat > 1
# \param     ready_latency,       the ready latency, use -1 to omit the ready signal
# \param     channel_width,       the width of the channel signal
# \param     use_valid,           use 0 to omit the valid signal

proc add_av_st_input_port { clock   input_name   bits_per_symbol   symbols_per_beat   {packets_transfer 2}
                            {ready_latency 0}   {channel_width 0}   {use_valid 1}   {error_desc ""} {pixels_per_beat 1}} {

    set data_width [expr $bits_per_symbol * $symbols_per_beat * $pixels_per_beat ]

    add_interface            $input_name     avalon_streaming     sink    $clock

    set_interface_property   $input_name     dataBitsPerSymbol    $bits_per_symbol
    set_interface_property   $input_name     symbolsPerBeat       [expr $symbols_per_beat * $pixels_per_beat]
    set_interface_property   $input_name     errorDescriptor      $error_desc
    set_interface_property   $input_name     firstSymbolInHighOrderBits true

    add_interface_port       $input_name     ${input_name}_data   data    input    $data_width

    if { $use_valid != 0} {
        add_interface_port $input_name ${input_name}_valid valid input 1
    }

    if { $packets_transfer != 0 } {
        add_interface_port $input_name ${input_name}_startofpacket startofpacket input 1
        add_interface_port $input_name ${input_name}_endofpacket endofpacket input 1

        if { $packets_transfer != 1  && $pixels_per_beat > 1} {
            # Use channel_width to detect Av-St-Msg, which requires TWO empty buses :
            if {$channel_width != 0} {
                add_interface_port $input_name ${input_name}_sop_empty empty input [clogb2_pure [expr $pixels_per_beat]]
                add_interface_port $input_name ${input_name}_eop_empty empty input [clogb2_pure [expr $pixels_per_beat]]
            # Av-St just requires ONE empty bus, but width must indicate number of empty SYMBOLS :
            } else {
                add_interface_port $input_name ${input_name}_empty empty input [clogb2_pure [expr $symbols_per_beat * $pixels_per_beat]]
            }
        }
    }

    if { $ready_latency != -1 } {
        set_interface_property $input_name readyLatency $ready_latency
        add_interface_port $input_name ${input_name}_ready    ready    output  1
    }

    if { $channel_width != 0 } {
        add_interface_port $input_name ${input_name}_channel  channel  input   $channel_width
    }
    #if {$channel_width == 32} {
    #    set_interface_property   $input_name     maxChannel           2147483647
    #} else {
    #    set_interface_property   $input_name     maxChannel           [expr [power 2 $channel_width] - 1]
    #}
    set_interface_property   $input_name     maxChannel           0


    if { [string compare $error_desc ""] } {
        set error_width [ llength [split $error_desc ,] ]
        add_interface_port $input_name ${input_name}_error    error    input   $error_width
        set_interface_property $input_name errorDescriptor $error_desc
    }
}

# add_av_st_output_port
# Add an Avalon-ST Output port to the component, see specialized functions below for a shortened call
# \param     clock,               clock associated with the Avalon-ST interface
# \param     output_name,         name of the Avalon-ST interface
# \param     bits_per_symbol,     number of bits per symbols
# \param     symbols_per_beat,    number of symbols per beat (clock cycle)
# \param     packets_transfer,    whether sop and eop signals are used, use packets_transfer == 2 to
#                                 include the empty signal (if symbols_per_beat > 1)
# \param     ready_latency,       the ready latency, use -1 to omit the ready signal
# \param     channel_width,       the width of the channel signal
# \param     use_valid,           use 0 to omit the valid signal
proc add_av_st_output_port { clock   output_name   bits_per_symbol   symbols_per_beat   {packets_transfer 2}
                             {ready_latency 0}   {channel_width 0}   {use_valid 1}   {error_desc ""}  {pixels_per_beat 1}} {

    set data_width [expr $bits_per_symbol * $symbols_per_beat * $pixels_per_beat ]

    add_interface            $output_name    avalon_streaming     source  $clock

    set_interface_property   $output_name    dataBitsPerSymbol    $bits_per_symbol
    set_interface_property   $output_name    symbolsPerBeat       [expr $symbols_per_beat * $pixels_per_beat]
    set_interface_property   $output_name    errorDescriptor      $error_desc
    set_interface_property   $output_name    firstSymbolInHighOrderBits true

    add_interface_port       $output_name    ${output_name}_data  data    output   $data_width

    if { $use_valid != 0} {
        add_interface_port $output_name ${output_name}_valid valid output 1
    }

    if { $packets_transfer != 0 } {
        add_interface_port $output_name ${output_name}_startofpacket  startofpacket output  1
        add_interface_port $output_name ${output_name}_endofpacket    endofpacket   output  1
        if { $packets_transfer != 1 && $pixels_per_beat > 1} {
            # Use channel_width to detect Av-St-Msg, which requires TWO empty buses :
            if {$channel_width != 0} {
                add_interface_port $output_name ${output_name}_sop_empty empty    output  [clogb2_pure [expr $pixels_per_beat]]
                add_interface_port $output_name ${output_name}_eop_empty empty    output  [clogb2_pure [expr $pixels_per_beat]]
            # Av-St just requires ONE empty bus, but width must indicate number of empty SYMBOLS :
            } else {
                add_interface_port $output_name ${output_name}_empty empty    output  [clogb2_pure [expr $symbols_per_beat * $pixels_per_beat]]
            }
        }
    }

    if { $ready_latency != -1 } {
        set_interface_property $output_name readyLatency $ready_latency
        add_interface_port $output_name  ${output_name}_ready    ready    input   1
    }

    if { $channel_width != 0 } {
        add_interface_port $output_name  ${output_name}_channel  channel  output  $channel_width
    }
    #if {$channel_width == 32} {
    #    set_interface_property   $output_name    maxChannel           2147483647
    #} else {
    #    set_interface_property   $output_name    maxChannel           [expr [power 2 $channel_width] - 1]
    #}
    set_interface_property   $output_name    maxChannel           0

    if { [string compare $error_desc ""] } {
        set error_width [ llength [split $error_desc ,] ]
        add_interface_port $output_name  ${output_name}_error    error    output  $error_width
        set_interface_property $output_name errorDescriptor $error_desc
    }
}


# add_av_st_vid_input_port
# \param     input_name,          name of the Avalon-ST interface (din recommended)
# \param     bits_per_symbol,     number of bits per symbols
# \param     symbols_per_beat,    number of symbols per beat (clock cycle)
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# Add an Avalon-ST Video Input port to the component
proc add_av_st_vid_input_port {input_name   bits_per_symbol   symbols_per_beat  {clock main_clock}} {
    add_av_st_input_port   $clock   $input_name   $bits_per_symbol   $symbols_per_beat   1   1
}


# add_av_st2_vid_input_port
# \param     input_name,          name of the Avalon-ST2 interface (din recommended)
# \param     bits_per_symbol,     number of bits per symbols
# \param     symbols_per_beat,    number of symbols per beat (clock cycle)
# \param     pixels_per_beat,     number of pixels per beat (clock cycle)
# \param     clock,               clock associated with the Avalon-ST2 interface (main_clock by default)
# \param     packets_transfer,    set to > 1 to enable the empty signal on the interface
# \param     ready latency        defaults to 1
# Add an Avalon-ST Video Input port to the component
proc add_av_st2_vid_input_port {input_name   bits_per_symbol   symbols_per_beat   pixels_per_beat   {clock main_clock} {packets_transfer 1} {ready_latency 1} } {
    add_av_st_input_port   $clock   $input_name   $bits_per_symbol   $symbols_per_beat   $packets_transfer   $ready_latency  0   1   ""   $pixels_per_beat
}

# add_av_st_video_input_port (v3, with interface properties)
# \param     input_name,                       name of the Avalon-ST Video interface (din recommended)
# \param     bits_per_symbol,                  number of bits per color samples
# \param     number_of_color_planes,           number of color planes per pixel
# \param     color_planes_are_in_parallel,     whether color_planes are transmitted in parallel or in sequence
# \param     pixels_in_parallel,               pixels_in_parallel (pixels_in_parallel > 1 enables the empty port, if color_planes_are_in_parallel==0 then pixels cannot be transmitted in parallel)
# \param     clock,                            clock associated with the Avalon-ST Video interface (main_clock by default)
# \param     ready latency                     defaults to 1
# Add an Avalon-ST Video Input port to the component
proc add_av_st_video_input_port {input_name   bits_per_symbol   number_of_color_planes   color_planes_are_in_parallel   pixels_in_parallel {clock main_clock} {ready_latency 1} } {
    set symbols_in_parallel    [expr ($color_planes_are_in_parallel) ? $number_of_color_planes : 1]
    set packets_transfer       [expr ($pixels_in_parallel > 1) ? 2 : 1]

    add_av_st_input_port   $clock   $input_name   $bits_per_symbol  $symbols_in_parallel  $packets_transfer  $ready_latency  0   1   ""   $pixels_in_parallel

    alt_vip_av_st_video_format::set_packet_property  $input_name  NUMBER_OF_COLOR_PLANES         $number_of_color_planes
    alt_vip_av_st_video_format::set_packet_property  $input_name  COLOR_PLANES_ARE_IN_PARALLEL   $color_planes_are_in_parallel
    alt_vip_av_st_video_format::set_packet_property  $input_name  PIXELS_IN_PARALLEL             $pixels_in_parallel
    alt_vip_av_st_video_format::validate             $input_name
}

# add_av_st_vid_output_port
# \param     output_name,         name of the Avalon-ST interface (dout recommend)
# \param     bits_per_symbol,     number of bits per symbols
# \param     symbols_per_beat,    number of symbols per beat (clock cycle)
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# Add an Avalon-ST Video Output port to the component
proc add_av_st_vid_output_port {output_name   bits_per_symbol   symbols_per_beat   {clock main_clock}} {
    add_av_st_output_port   $clock   $output_name   $bits_per_symbol   $symbols_per_beat   1   1
}


# add_av_st2_vid_output_port
# \param     output_name,         name of the Avalon-ST2 interface (dout recommend)
# \param     bits_per_symbol,     number of bits per symbols
# \param     symbols_per_beat,    number of symbols per beat (clock cycle)
# \param     pixels_per_beat,     number of pixels per beat (clock cycle)
# \param     clock,               clock associated with the Avalon-ST2 interface (main_clock by default)
# \param     packets_transfer,    set to > 1 to enable the empty signal on the interface
# \param     ready latency        defaults to 1
# Add an Avalon-ST2 Video Output port to the component
proc add_av_st2_vid_output_port {output_name   bits_per_symbol   symbols_per_beat   pixels_per_beat   {clock main_clock} {packets_transfer 1} {ready_latency 1} } {
    add_av_st_output_port   $clock   $output_name   $bits_per_symbol   $symbols_per_beat   $packets_transfer   $ready_latency   0   1   ""   $pixels_per_beat
}

# add_av_st_video_output_port (v3, with interface properties)
# \param     output_name,                      name of the Avalon-ST Video interface (dout recommended)
# \param     bits_per_symbol,                  number of bits per color samples
# \param     number_of_color_planes,           number of color_planes per pixel
# \param     color_planes_are_in_parallel,     whether color_planes are transmitted in parallel or in sequence
# \param     pixels_in_parallel,               pixels_in_parallel (pixels_in_parallel > 1 enables the empty port, if color_planes_are_in_parallel==0 then pixels cannot be transmitted in parallel)
# \param     clock,                            clock associated with the Avalon-ST Video interface (main_clock by default)
# \param     ready latency                     defaults to 1
# Add an Avalon-ST Video Input port to the component
proc add_av_st_video_output_port {output_name   bits_per_symbol   number_of_color_planes   color_planes_are_in_parallel   pixels_in_parallel {clock main_clock} {ready_latency 1} } {
    set symbols_in_parallel    [expr ($color_planes_are_in_parallel) ? $number_of_color_planes : 1]
    set packets_transfer       [expr ($pixels_in_parallel > 1) ? 2 : 1]

    add_av_st_output_port   $clock   $output_name   $bits_per_symbol   $symbols_in_parallel  $packets_transfer   $ready_latency  0   1   ""   $pixels_in_parallel

    alt_vip_av_st_video_format::set_packet_property  $output_name  NUMBER_OF_COLOR_PLANES         $number_of_color_planes
    alt_vip_av_st_video_format::set_packet_property  $output_name  COLOR_PLANES_ARE_IN_PARALLEL   $color_planes_are_in_parallel
    alt_vip_av_st_video_format::set_packet_property  $output_name  PIXELS_IN_PARALLEL             $pixels_in_parallel
    alt_vip_av_st_video_format::validate             $output_name
}

# add_av_st_message_input_port
# Add a VIP Avalon-ST Message Input port to the component
# \param     input_name,          name of the Avalon-ST Message interface
# \param     bits_per_element,    number of bits per argument/pixel
# \param     elements_per_beat,   number of arguments/pixels per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     user_width,          width of the user field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_message_input_port {input_name   bits_per_element   elements_per_beat   dst_width   src_width   task_width   context_width   user_width {clock main_clock} {pe_id 0}} {
    if {$elements_per_beat > 1} {
       set empty_width [clogb2_pure $elements_per_beat]
    } else {
       set empty_width 0
    }
    set input_data_width [expr ($bits_per_element * $elements_per_beat) + $empty_width + $dst_width + $src_width + $task_width + $context_width + $user_width]
    add_interface $input_name avalon_streaming end $clock
    set_interface_property $input_name errorDescriptor ""
    set_interface_property $input_name readyLatency 0
    set_interface_property $input_name ENABLED true

    add_interface_port $input_name ${input_name}_valid           valid         Input  1
    add_interface_port $input_name ${input_name}_startofpacket   startofpacket Input  1
    add_interface_port $input_name ${input_name}_endofpacket     endofpacket   Input  1
    add_interface_port $input_name ${input_name}_data            data          Input  $input_data_width
    add_interface_port $input_name ${input_name}_ready           ready         Output 1

    alt_vip_av_st_message_format::set_message_property          $input_name                  PEID             $pe_id

    alt_vip_av_st_message_format::set_message_subfield_property $input_name argument         SYMBOLS_PER_BEAT $elements_per_beat
    alt_vip_av_st_message_format::set_message_subfield_property $input_name argument         SYMBOL_WIDTH     $bits_per_element

    alt_vip_av_st_message_format::set_message_subfield_property $input_name destination      BASE            0
    alt_vip_av_st_message_format::set_message_subfield_property $input_name destination      SYMBOL_WIDTH    $dst_width

    alt_vip_av_st_message_format::set_message_subfield_property $input_name source           BASE            $dst_width
    alt_vip_av_st_message_format::set_message_subfield_property $input_name source           SYMBOL_WIDTH    $src_width

    alt_vip_av_st_message_format::set_message_subfield_property $input_name taskid           BASE            [expr $dst_width + $src_width]
    alt_vip_av_st_message_format::set_message_subfield_property $input_name taskid           SYMBOL_WIDTH    $task_width

    alt_vip_av_st_message_format::set_message_subfield_property $input_name context          BASE            [expr $dst_width + $src_width + $task_width]
    alt_vip_av_st_message_format::set_message_subfield_property $input_name context          SYMBOL_WIDTH    $context_width

    alt_vip_av_st_message_format::set_message_subfield_property $input_name user             BASE            [expr $dst_width + $src_width + $task_width + $context_width]
    alt_vip_av_st_message_format::set_message_subfield_property $input_name user             SYMBOL_WIDTH    $user_width

    alt_vip_av_st_message_format::validate_and_create $input_name
}

# add_av_st_message_array_input_port
# Add a VIP Avalon-ST Message Input port to the component
# \param     input_name,          name of the Avalon-ST Message interface
# \param     array_size           number of ports in the array
# \param     bits_per_element,    number of bits per argument/pixel
# \param     elements_per_beat,   number of arguments/pixels per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     user_width,          width of the user field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_message_array_input_port {input_name   array_size   bits_per_element   elements_per_beat   dst_width   src_width   task_width   context_width   user_width {clock main_clock} {pe_id 0}} {
    if {$elements_per_beat > 1} {
       set empty_width [clogb2_pure $elements_per_beat]
    } else {
       set empty_width 0
    }
    set input_data_width [expr ($bits_per_element * $elements_per_beat) + $empty_width + $dst_width + $src_width + $task_width + $context_width + $user_width]

    for { set i 0 } { $i < $array_size } { incr i } {
       add_interface ${input_name}_$i avalon_streaming end $clock
       set_interface_property ${input_name}_$i errorDescriptor ""
       set_interface_property ${input_name}_$i readyLatency 0
       set_interface_property ${input_name}_$i ENABLED true

       add_interface_port ${input_name}_$i ${input_name}_valid_$i           valid         Input  1
       add_interface_port ${input_name}_$i ${input_name}_startofpacket_$i   startofpacket Input  1
       add_interface_port ${input_name}_$i ${input_name}_endofpacket_$i     endofpacket   Input  1
       add_interface_port ${input_name}_$i ${input_name}_data_$i            data          Input  $input_data_width
       add_interface_port ${input_name}_$i ${input_name}_ready_$i           ready         Output 1

       set_port_property ${input_name}_ready_$i         FRAGMENT_LIST "${input_name}_ready@$i"
       set_port_property ${input_name}_valid_$i         FRAGMENT_LIST "${input_name}_valid@$i"
       set_port_property ${input_name}_startofpacket_$i FRAGMENT_LIST "${input_name}_startofpacket@$i"
       set_port_property ${input_name}_endofpacket_$i   FRAGMENT_LIST "${input_name}_endofpacket@$i"
       set_port_property ${input_name}_data_$i          FRAGMENT_LIST "${input_name}_data@[expr ($i+1)*($input_data_width) - 1]:[expr $i*($input_data_width)]"

       alt_vip_av_st_message_format::set_message_property          ${input_name}_$i                  PEID             $pe_id

       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i argument         SYMBOLS_PER_BEAT $elements_per_beat
       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i argument         SYMBOL_WIDTH     $bits_per_element

       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i destination      BASE            0
       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i destination      SYMBOL_WIDTH    $dst_width

       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i source           BASE            $dst_width
       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i source           SYMBOL_WIDTH    $src_width

       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i taskid           BASE            [expr $dst_width + $src_width]
       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i taskid           SYMBOL_WIDTH    $task_width

       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i context          BASE            [expr $dst_width + $src_width + $task_width]
       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i context          SYMBOL_WIDTH    $context_width

       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i user             BASE            [expr $dst_width + $src_width + $task_width + $context_width]
       alt_vip_av_st_message_format::set_message_subfield_property ${input_name}_$i user             SYMBOL_WIDTH    $user_width

       alt_vip_av_st_message_format::validate_and_create ${input_name}_$i
    }
}

# add_av_st_message_output_port
# Add a VIP Avalon-ST Message Output port to the component
# \param     output_name,          name of the Avalon-ST Message interface
# \param     bits_per_element,    number of bits per argument/pixel
# \param     elements_per_beat,   number of arguments/pixels per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     user_width,          width of the user field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_message_output_port {output_name   bits_per_element   elements_per_beat   dst_width   src_width   task_width   context_width   user_width {clock main_clock} {pe_id 0}} {
    if {$elements_per_beat > 1} {
       set empty_width [clogb2_pure $elements_per_beat]
    } else {
       set empty_width 0
    }
    set output_data_width [expr ($bits_per_element * $elements_per_beat) + $empty_width + $dst_width + $src_width + $task_width + $context_width + $user_width]
    add_interface $output_name avalon_streaming start $clock
    set_interface_property $output_name errorDescriptor ""
    set_interface_property $output_name readyLatency 0
    set_interface_property $output_name ENABLED true

    add_interface_port $output_name ${output_name}_valid           valid         Output 1
    add_interface_port $output_name ${output_name}_startofpacket   startofpacket Output 1
    add_interface_port $output_name ${output_name}_endofpacket     endofpacket   Output 1
    add_interface_port $output_name ${output_name}_data            data          Output $output_data_width
    add_interface_port $output_name ${output_name}_ready           ready         Input  1

    alt_vip_av_st_message_format::set_message_property          $output_name PEID             $pe_id

    alt_vip_av_st_message_format::set_message_subfield_property $output_name argument         SYMBOLS_PER_BEAT $elements_per_beat
    alt_vip_av_st_message_format::set_message_subfield_property $output_name argument         SYMBOL_WIDTH     $bits_per_element

    alt_vip_av_st_message_format::set_message_subfield_property $output_name destination      BASE            0
    alt_vip_av_st_message_format::set_message_subfield_property $output_name destination      SYMBOL_WIDTH    $dst_width

    alt_vip_av_st_message_format::set_message_subfield_property $output_name source           BASE            $dst_width
    alt_vip_av_st_message_format::set_message_subfield_property $output_name source           SYMBOL_WIDTH    $src_width

    alt_vip_av_st_message_format::set_message_subfield_property $output_name taskid           BASE            [expr $dst_width + $src_width]
    alt_vip_av_st_message_format::set_message_subfield_property $output_name taskid           SYMBOL_WIDTH    $task_width

    alt_vip_av_st_message_format::set_message_subfield_property $output_name context          BASE            [expr $dst_width + $src_width + $task_width]
    alt_vip_av_st_message_format::set_message_subfield_property $output_name context          SYMBOL_WIDTH    $context_width

    alt_vip_av_st_message_format::set_message_subfield_property $output_name user             BASE            [expr $dst_width + $src_width + $task_width + $context_width]
    alt_vip_av_st_message_format::set_message_subfield_property $output_name user             SYMBOL_WIDTH    $user_width

    alt_vip_av_st_message_format::validate_and_create $output_name
}

# add_av_st_message_array_output_port
# Add a VIP Avalon-ST Message Output port to the component
# \param     output_name,          name of the Avalon-ST Message interface
# \param     array_size           number of ports in the array
# \param     bits_per_element,    number of bits per argument/pixel
# \param     elements_per_beat,   number of arguments/pixels per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     user_width,          width of the user field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_message_array_output_port {output_name   array_size   bits_per_element   elements_per_beat   dst_width   src_width   task_width   context_width   user_width {clock main_clock} {pe_id 0}} {
    if {$elements_per_beat > 1} {
       set empty_width [clogb2_pure $elements_per_beat]
    } else {
       set empty_width 0
    }
    set output_data_width [expr ($bits_per_element * $elements_per_beat) + $empty_width + $dst_width + $src_width + $task_width + $context_width + $user_width]

    for { set i 0 } { $i < $array_size } { incr i } {
       add_interface ${output_name}_$i avalon_streaming start $clock
       set_interface_property ${output_name}_$i errorDescriptor ""
       set_interface_property ${output_name}_$i readyLatency 0
       set_interface_property ${output_name}_$i ENABLED true

       add_interface_port ${output_name}_$i ${output_name}_valid_$i           valid         Output  1
       add_interface_port ${output_name}_$i ${output_name}_startofpacket_$i   startofpacket Output  1
       add_interface_port ${output_name}_$i ${output_name}_endofpacket_$i     endofpacket   Output  1
       add_interface_port ${output_name}_$i ${output_name}_data_$i            data          Output  $output_data_width
       add_interface_port ${output_name}_$i ${output_name}_ready_$i           ready         Input   1

       set_port_property ${output_name}_ready_$i         FRAGMENT_LIST "${output_name}_ready@$i"
       set_port_property ${output_name}_valid_$i         FRAGMENT_LIST "${output_name}_valid@$i"
       set_port_property ${output_name}_startofpacket_$i FRAGMENT_LIST "${output_name}_startofpacket@$i"
       set_port_property ${output_name}_endofpacket_$i   FRAGMENT_LIST "${output_name}_endofpacket@$i"
       set_port_property ${output_name}_data_$i          FRAGMENT_LIST "${output_name}_data@[expr ($i+1)*($output_data_width) - 1]:[expr $i*($output_data_width)]"

       alt_vip_av_st_message_format::set_message_property          ${output_name}_$i PEID             $pe_id

       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i argument         SYMBOLS_PER_BEAT $elements_per_beat
       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i argument         SYMBOL_WIDTH     $bits_per_element

       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i destination      BASE            0
       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i destination      SYMBOL_WIDTH    $dst_width

       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i source           BASE            $dst_width
       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i source           SYMBOL_WIDTH    $src_width

       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i taskid           BASE            [expr $dst_width + $src_width]
       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i taskid           SYMBOL_WIDTH    $task_width

       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i context          BASE            [expr $dst_width + $src_width + $task_width]
       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i context          SYMBOL_WIDTH    $context_width

       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i user             BASE            [expr $dst_width + $src_width + $task_width + $context_width]
       alt_vip_av_st_message_format::set_message_subfield_property ${output_name}_$i user             SYMBOL_WIDTH    $user_width

       alt_vip_av_st_message_format::validate_and_create ${output_name}_$i
    }
}

# add_av_st_data_source_port
# Add an VIP Avalon-ST Message Data Output port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     bits_per_element,    number of bits per pixel
# \param     elements_per_beat,   number of pixels per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     user_width,          width of the user id field - overridden if elements_per_beat > 1
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_data_source_port   {name   bits_per_element   elements_per_beat   dst_width   src_width   task_width   context_width   {user_width 0}   {clock main_clock} {pe_id 0}} {
    if {$elements_per_beat > 1} {
       set user_width_internal [clogb2_pure $elements_per_beat]
    } else {
       set user_width_internal $user_width
    }
    add_av_st_message_output_port   $name   $bits_per_element   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   $user_width_internal    $clock   $pe_id
}

# add_av_st_array_data_source_port
# Add an VIP Avalon-ST Message Data Output port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     array_size           number of ports in the array
# \param     bits_per_element,    number of bits per pixel
# \param     elements_per_beat,   number of pixels per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     user_width,          width of the user id field - overridden if elements_per_beat > 1
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_array_data_source_port   {name   array_size   bits_per_element   elements_per_beat   dst_width   src_width   task_width   context_width   {user_width 0}   {clock main_clock} {pe_id 0}} {
    if {$elements_per_beat > 1} {
       set user_width_internal [clogb2_pure $elements_per_beat]
    } else {
       set user_width_internal $user_width
    }
    add_av_st_message_array_output_port   $name   $array_size   $bits_per_element   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   $user_width_internal    $clock   $pe_id
}

# add_av_st_data_sink_port
# Add an VIP Avalon-ST Message Data Input port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     bits_per_element,    number of bits per pixel
# \param     elements_per_beat,   number of pixels per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     user_width,          width of the user id field - overridden if elements_per_beat > 1
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_data_sink_port   {name   bits_per_element   elements_per_beat   dst_width   src_width   task_width   context_width   {user_width 0}   {clock main_clock} {pe_id 0}} {
    if {$elements_per_beat > 1} {
       set user_width_internal [clogb2_pure $elements_per_beat]
    } else {
       set user_width_internal $user_width
    }
    add_av_st_message_input_port   $name   $bits_per_element   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   $user_width_internal  $clock   $pe_id
}

# add_av_st_array_data_sink_port
# Add an VIP Avalon-ST Message Data Input port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     array_size           number of ports in the array
# \param     bits_per_element,    number of bits per pixel
# \param     elements_per_beat,   number of pixels per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     user_width,          width of the user id field - overridden if elements_per_beat > 1
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_array_data_sink_port   {name   array_size   bits_per_element   elements_per_beat   dst_width   src_width   task_width   context_width   {user_width 0}   {clock main_clock} {pe_id 0}} {
    if {$elements_per_beat > 1} {
       set user_width_internal [clogb2_pure $elements_per_beat]
    } else {
       set user_width_internal $user_width
    }
    add_av_st_message_array_input_port   $name   $array_size   $bits_per_element   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   $user_width_internal  $clock   $pe_id
}

# add_av_st_cmd_source_port
# Add an VIP Avalon-ST Message Command Output port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     elements_per_beat,   number of arguments per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_cmd_source_port   {name   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} {
    add_av_st_message_output_port   $name   32   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   0  $clock   $pe_id
}

# add_av_st_array_cmd_source_port
# Add an VIP Avalon-ST Message Command Output port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     array_size           number of ports in the array
# \param     elements_per_beat,   number of arguments per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_array_cmd_source_port   {name   array_size   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} {
    add_av_st_message_array_output_port   $name   $array_size   32   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   0  $clock   $pe_id
}

# add_av_st_cmd_sink_port
# Add an VIP Avalon-ST Message Command Input port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     elements_per_beat,   number of arguments per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_cmd_sink_port     {name   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} {
    add_av_st_message_input_port   $name   32   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   0  $clock   $pe_id
}

# add_av_st_array_cmd_sink_port
# Add an VIP Avalon-ST Message Command Input port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     array_size           number of ports in the array
# \param     elements_per_beat,   number of arguments per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_array_cmd_sink_port     {name   array_size   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} {
    add_av_st_message_array_input_port   $name   $array_size   32   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   0  $clock   $pe_id
}

# add_av_st_resp_source_port
# Add an VIP Avalon-ST Message Response Output port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     elements_per_beat,   number of arguments per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_resp_source_port  {name   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} {
    add_av_st_message_output_port   $name   32   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   0  $clock   $pe_id
}

# add_av_st_array_resp_source_port
# Add an VIP Avalon-ST Message Response Output port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     array_size           number of ports in the array
# \param     elements_per_beat,   number of arguments per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_array_resp_source_port  {name   array_size   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} {
    add_av_st_message_array_output_port   $name   $array_size   32   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   0  $clock   $pe_id
}

# add_av_st_resp_sink_port
# Add an VIP Avalon-ST Message Response Input port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     elements_per_beat,   number of arguments per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_resp_sink_port    {name   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} {
    add_av_st_message_input_port   $name   32   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   0  $clock   $pe_id
}

# add_av_st_array_resp_sink_port
# Add an VIP Avalon-ST Message Response Input port to the component
# \param     name,                name of the Avalon-ST Message interface
# \param     array_size           number of ports in the array
# \param     elements_per_beat,   number of arguments per beat (clock cycle)
# \param     dst_width,           width of the destination id field
# \param     src_width,           width of the source id field
# \param     task_width,          width of the task id field
# \param     context_width,       width of the context id field
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
# \param     pe_id,               unique id assigned to each component
proc add_av_st_array_resp_sink_port    {name   array_size   elements_per_beat   dst_width   src_width   task_width   context_width   {clock main_clock} {pe_id 0}} {
    add_av_st_message_array_input_port   $name   $array_size   32   $elements_per_beat   $dst_width   $src_width   $task_width   $context_width   0  $clock   $pe_id
}

# add_av_st_distiller_input_port
# Add a VIP Distill Avalon-ST debug Input port to the component (ready latency 0, sop/eop, no channel)
# \param     input_name,          name of the Avalon-ST interface
# \param     distiller_width,     width of the Avalon-ST interface
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
proc add_av_st_distiller_input_port {input_name distiller_width {clock main_clock}} {
    add_av_st_input_port   $clock   $input_name   $distiller_width   1   1   0
}

# add_av_st_distiller_output_port
# Add a VIP Distill Avalon-ST output port to the component (64-bit data port, ready latency 0, sop/eop, no channel)
# \param     output_name,         name of the Avalon-ST interface
# \param     distiller_width,     width of the Avalon-ST interface
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
proc add_av_st_distiller_output_port {output_name distiller_width {clock main_clock}} {
    add_av_st_output_port   $clock   $output_name   $distiller_width   1   1   0
}





# add_debug_interface
# Add a VIP Avalon-ST debug Input port and Output port to the component
# (8-bit Avalon-ST sink and usually 8-bit source, ready latency 0, sop/eop, 2 channels in both directions)
# \param     debug_name,          base name of the debug interfaces (1 av-st input and one av-st output)
# \param     output_width,        data port of the Avalon-ST output ${debug_name}_out
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
proc add_debug_interface {debug_name output_width {clock main_clock}} {
    add_av_st_input_port    $clock   ${debug_name}_in    8               1    1   0   1
    add_av_st_output_port   $clock   ${debug_name}_out   $output_width   1    1   0   1
    set_interface_property  ${debug_name}_in             maxChannel      1
    set_interface_property  ${debug_name}_out            maxChannel      1

    # Assign a few parameters to debug input (critical to be picked up as a trace)
    set_interface_assignment ${debug_name}_in   debug.mfrCode                 0x6E
    set_interface_assignment ${debug_name}_in   debug.typeCode                0x75
    set_interface_assignment ${debug_name}_in   debug.associatedDownstream    ${debug_name}_in
}




# add_timestamp_input_port
# Add a VIP Timestamp Input port to the component (Avalon-ST without valid/ready wires)
# \param     input_name,          name of the Avalon-ST timestamp interface
# \param     timestamp_width,     number of bits in a timestamp value
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
proc add_timestamp_input_port  { input_name    timestamp_width    {clock main_clock}} {
    add_av_st_input_port   $clock   $input_name    $timestamp_width   1   0   -1   0   0
}

# add_timestamp_output_port
# Add a VIP Timestamp Output port to the component (Avalon-ST without valid/ready wires)
# \param     output_name,         name of the Avalon-ST timestamp interface
# \param     timestamp_width,     number of bits in a timestamp value
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
proc add_timestamp_output_port { output_name   timestamp_width    {clock main_clock}} {
    add_av_st_output_port  $clock   $output_name   $timestamp_width   1   0   -1   0   0
}



# add_controller_port
# A simple non-bursting read, write or read/write master
# \param     timestamp_width,     number of bits in a timestamp value
# \param     output_name,         name of the Avalon-ST Event interface
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)

proc add_controller_port {master_name port_width addr_width {clock main_clock} {can_read 1} {with_pipeline 0} {can_write 1}} {
    add_interface           $master_name     avalon        master     $clock

    set_interface_property  $master_name     adaptsTo                     ""
    set_interface_property  $master_name     burstOnBurstBoundariesOnly   false
    set_interface_property  $master_name     linewrapBursts               false
    set_interface_property  $master_name     doStreamReads                false
    set_interface_property  $master_name     doStreamWrites               false

    add_interface_port      $master_name     ${master_name}_address      address        Output   $addr_width
    add_interface_port      $master_name     ${master_name}_waitrequest  waitrequest    Input    1
    if {$can_write != 0} {
        add_interface_port      $master_name     ${master_name}_write          write          Output   1
        add_interface_port      $master_name     ${master_name}_writedata      writedata      Output   $port_width
    }
    if {$can_read != 0} {
        add_interface_port      $master_name     ${master_name}_read           read           Output   1
        add_interface_port      $master_name     ${master_name}_readdata       readdata       Input    $port_width
    }
    if {$with_pipeline != 0} {
        add_interface_port      $master_name     ${master_name}_readdatavalid  readdatavalid  Input    1
    }
}



# add_bursting_write_master_port
# TODO
proc add_bursting_write_master_port {master_name mem_port_width burst_target burst_align {clock main_clock}} {
    add_interface $master_name     avalon    master     $clock

    set_interface_property $master_name burstOnBurstBoundariesOnly $burst_align
    set_interface_property $master_name doStreamReads false
    set_interface_property $master_name doStreamWrites false
    set_interface_property $master_name linewrapBursts false

    add_interface_port $master_name ${master_name}_address address Output 32
    add_interface_port $master_name ${master_name}_write write Output 1
    add_interface_port $master_name ${master_name}_burstcount burstcount Output [clogb2 $burst_target]
    add_interface_port $master_name ${master_name}_writedata writedata Output $mem_port_width
    add_interface_port $master_name ${master_name}_waitrequest waitrequest Input 1
}

# add_write_master_port
# TODO
proc add_write_master_port {master_name mem_port_width {clock main_clock}} {
    add_interface $master_name     avalon    master     $clock

    ##set_interface_property $master_name burstOnBurstBoundariesOnly $burst_align
    set_interface_property $master_name doStreamReads false
    set_interface_property $master_name doStreamWrites false
    set_interface_property $master_name linewrapBursts false

    add_interface_port $master_name ${master_name}_address address Output 32
    add_interface_port $master_name ${master_name}_write write Output 1
    ##add_interface_port $master_name ${master_name}_burstcount burstcount Output [clogb2 $burst_target]
    add_interface_port $master_name ${master_name}_writedata writedata Output $mem_port_width
    add_interface_port $master_name ${master_name}_waitrequest waitrequest Input 1
}

# add_bursting_read_master_port
# TODO
proc add_bursting_read_master_port {master_name mem_port_width burst_target burst_align {clock main_clock}} {
    add_interface $master_name avalon master $clock

    set_interface_property $master_name burstOnBurstBoundariesOnly $burst_align
    set_interface_property $master_name doStreamReads false
    set_interface_property $master_name doStreamWrites false
    set_interface_property $master_name linewrapBursts false

    add_interface_port $master_name ${master_name}_address address Output 32
    add_interface_port $master_name ${master_name}_read read Output 1
    add_interface_port $master_name ${master_name}_burstcount burstcount Output [clogb2 $burst_target]
    add_interface_port $master_name ${master_name}_readdata readdata Input $mem_port_width
    add_interface_port $master_name ${master_name}_readdatavalid readdatavalid Input 1
    add_interface_port $master_name ${master_name}_waitrequest waitrequest Input 1
}



# add_av_mm_master_port
# add an Avalon write/read/write-read port to the component
# \param     master_name		  name of the Avalon-MM master interface
# \param     enable_write		  0 or 1, if 1 enable the write function for the MM Master port
# \param     enable_read		  0 or 1, if 1 enable the read function for the MM Master port
# \param     mem_port_width		  width of the data port
# \param     byteenable_width	  width of the byteenable port
# \param     burst_target	      Burst size of targeted, in words
# \param     burst_align		  0 or 1, if 1 the burst is used on the burst boundaries only
# \param     clock,               clock associated with the Avalon-MM interface (main_clock by default)
# \param     addr_width           address port width
proc add_av_mm_master_port {master_name enable_write enable_read mem_port_width byteenable_width burst_target burst_align {clock main_clock} {addr_width 32}} {
	add_interface $master_name avalon master $clock

	set_interface_property $master_name burstOnBurstBoundariesOnly $burst_align
        set_interface_property $master_name doStreamReads false
        set_interface_property $master_name doStreamWrites false
        set_interface_property $master_name linewrapBursts false

	add_interface_port $master_name ${master_name}_address address Output $addr_width
	add_interface_port $master_name ${master_name}_burstcount burstcount Output [clogb2 $burst_target]
	add_interface_port $master_name ${master_name}_waitrequest waitrequest Input 1

	if {$enable_write > 0} {
		add_interface_port $master_name ${master_name}_write write Output 1
		add_interface_port $master_name ${master_name}_writedata writedata Output $mem_port_width
		add_interface_port $master_name ${master_name}_byteenable byteenable output $byteenable_width
	}

	if {$enable_read > 0} {
		add_interface_port $master_name ${master_name}_read read Output 1
		add_interface_port $master_name ${master_name}_readdata readdata Input $mem_port_width
		add_interface_port $master_name ${master_name}_readdatavalid readdatavalid Input 1
	}
}

# add_av_mm_slave_port
# add a bursting Avalon slave port to the component
# \param     slave_name		  name of the Avalon-MM slave interface
# \param     enable_write         0 or 1, if 1 enable the write function for the MM slave port
# \param     enable_read          0 or 1, if 1 enable the read function for the MM slave port
# \param     mem_port_width       width of the data port
# \param     byteenable_width	  width of the byteenable port
# \param     burst_target	  Burst size of targeted, in words
# \param     burst_align          0 or 1, if 1 the burst is used on the burst boundaries only
# \param     max_pending_reads    maximum number of pending read transactions
# \param     clock,               clock associated with the Avalon-MM interface (main_clock by default)
# \param     addr_width           address port width
proc add_av_mm_slave_port {slave_name enable_write enable_read mem_port_width byteenable_width burst_target burst_align max_pending_reads {clock main_clock} {addr_width 32}} {
	add_interface $slave_name avalon slave $clock

	set_interface_property $slave_name burstOnBurstBoundariesOnly $burst_align
        set_interface_property $slave_name linewrapBursts false
        set_interface_property $slave_name maximumPendingReadTransactions $max_pending_reads

	add_interface_port $slave_name ${slave_name}_address address Input $addr_width
	add_interface_port $slave_name ${slave_name}_burstcount burstcount Input [clogb2 $burst_target]
	add_interface_port $slave_name ${slave_name}_waitrequest waitrequest Output 1

	if {$enable_write > 0} {
		add_interface_port $slave_name ${slave_name}_write write Input 1
		add_interface_port $slave_name ${slave_name}_writedata writedata Input $mem_port_width
		add_interface_port $slave_name ${slave_name}_byteenable byteenable Input $byteenable_width
	}

	if {$enable_read > 0} {
		add_interface_port $slave_name ${slave_name}_read read Input 1
		add_interface_port $slave_name ${slave_name}_readdata readdata Output $mem_port_width
		add_interface_port $slave_name ${slave_name}_readdatavalid readdatavalid Output 1
	}
}

# add_slave_port
# Add a slave port to the component, the recommended name for the slave interface of a VIP core is "control"
# \param     control_name,        name of the Avalon-MM slave interface (typically, "control")
# \param     width,               width of the data port
# \param     depth,               addressable depth (in words) of the slave interface, determine the width of the address port
# \param     has_interrupt,       use 1 to create an additional ${control_name}_interrupt interface linked with this slave interface;
#                                 the interrupt signal is named ${control_name}_irq
# \param     read_latency,        the read latency, note that we do not use writeWaitTime/readWaitTime
# \param     use_wait_req,        whether wait_request is used
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
proc add_slave_port {control_name port_width addr_width depth {has_interrupt 0} {read_latency 1} {use_wait_req 0} {clock main_clock}} {

    add_interface $control_name avalon slave $clock

    set_interface_property $control_name addressAlignment NATIVE
    set_interface_property $control_name addressSpan $depth
    set_interface_property $control_name bridgesToMaster ""
    set_interface_property $control_name burstOnBurstBoundariesOnly false
    set_interface_property $control_name holdTime 0
    set_interface_property $control_name isMemoryDevice false
    set_interface_property $control_name isNonVolatileStorage false
    set_interface_property $control_name linewrapBursts false
    set_interface_property $control_name maximumPendingReadTransactions 0
    set_interface_property $control_name minimumUninterruptedRunLength 1
    set_interface_property $control_name printableDevice false
    set_interface_property $control_name readWaitTime 0
    set_interface_property $control_name setupTime 0
    set_interface_property $control_name timingUnits Cycles
    set_interface_property $control_name writeWaitTime 0
    set_interface_property $control_name readLatency $read_latency

    add_interface_port $control_name ${control_name}_address address Input $addr_width
    add_interface_port $control_name ${control_name}_write write Input 1
    add_interface_port $control_name ${control_name}_writedata writedata Input $port_width
    add_interface_port $control_name ${control_name}_read read Input 1
    add_interface_port $control_name ${control_name}_readdata readdata Output $port_width

    if {$use_wait_req} {
        add_interface_port $control_name ${control_name}_waitrequest waitrequest Output 1
    }

    if {$has_interrupt} {
        add_interface ${control_name}_interrupt interrupt sender $clock
        set_interface_property ${control_name}_interrupt associatedAddressablePoint $control_name
        add_interface_port ${control_name}_interrupt ${control_name}_irq irq Output 1
    }
}

# add_control_slave_port
# Add a slave port to the component, the recommended name for the slave interface of a VIP core is "control"
# \param     control_name,        name of the Avalon-MM slave interface (typically, "control")
# \param     addr_width           width of the address signal
# \param     depth,               addressable depth (in words) of the slave interface, determine the width of the address port
# \param     has_interrupt,       use 1 to create an additional ${control_name}_interrupt interface linked with this slave interface;
#                                 the interrupt signal is named ${control_name}_irq
# \param     read_latency,        the read latency (if readdatavalid is not used), note that we do not use writeWaitTime/readWaitTime
# \param     use_rdata_valid      whether readdata_valid is used
# \param     use_wait_req,        whether wait_request is used
# \param     clock,               clock associated with the Avalon-ST interface (main_clock by default)
proc add_control_slave_port {control_name addr_width depth {has_interrupt 0} {read_latency 1} {use_wait_req 0} {use_rdata_valid 0} {clock main_clock}} {

    add_interface $control_name avalon slave $clock

    set_interface_property $control_name addressAlignment DYNAMIC
    set_interface_property $control_name addressSpan $depth
    set_interface_property $control_name bridgesToMaster ""
    set_interface_property $control_name burstOnBurstBoundariesOnly false
    set_interface_property $control_name holdTime 0
    set_interface_property $control_name isMemoryDevice false
    set_interface_property $control_name isNonVolatileStorage false
    set_interface_property $control_name linewrapBursts false
    set_interface_property $control_name minimumUninterruptedRunLength 1
    set_interface_property $control_name printableDevice false
    set_interface_property $control_name readWaitTime 0
    set_interface_property $control_name setupTime 0
    set_interface_property $control_name timingUnits Cycles
    set_interface_property $control_name writeWaitTime 0

    add_interface_port $control_name ${control_name}_address address Input $addr_width
    add_interface_port $control_name ${control_name}_byteenable byteenable Input 4
    add_interface_port $control_name ${control_name}_write write Input 1
    add_interface_port $control_name ${control_name}_writedata writedata Input 32
    add_interface_port $control_name ${control_name}_read read Input 1
    add_interface_port $control_name ${control_name}_readdata readdata Output 32

    if {$use_rdata_valid} {
        add_interface_port $control_name ${control_name}_readdatavalid readdatavalid Output 1
        set_interface_property $control_name readLatency 0
        set_interface_property $control_name maximumPendingReadTransactions 2
    } else {
        set_interface_property $control_name readLatency $read_latency
        set_interface_property $control_name maximumPendingReadTransactions 0
    }

    if {$use_wait_req} {
        add_interface_port $control_name ${control_name}_waitrequest waitrequest Output 1
    }

    if {$has_interrupt} {
        add_interface ${control_name}_interrupt interrupt sender $clock
        set_interface_property ${control_name}_interrupt associatedAddressablePoint $control_name
        add_interface_port ${control_name}_interrupt ${control_name}_irq irq Output 1
    }
}
