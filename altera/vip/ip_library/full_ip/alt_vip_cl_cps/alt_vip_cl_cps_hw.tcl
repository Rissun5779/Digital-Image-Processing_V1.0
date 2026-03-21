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
#-- _hw.tcl compose file for Component Library Color Pane Sequencer (CPS II)                      --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME alt_vip_cl_cps
set_module_property DISPLAY_NAME "Color Plane Sequencer II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION "The Color Plane Sequencer changes how color planes are transmitted across the Avalon-ST Video interface. It can also combine two streams into one or split/duplicate a stream into two."

# Java helper (GUI widget, transformation of the pattern into an integer mapping list for the output, architectural decision for placement of cpp and pip converters)
set_module_property HELPER_JAR cps_helper.jar

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
set_module_property VALIDATION_CALLBACK cps_validation_callback

# Callback for the composition of this component
set_module_property COMPOSITION_CALLBACK cps_composition_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_bits_per_symbol_parameters

add_parameter            NUMBER_OF_INPUTS                           INTEGER                1
set_parameter_property   NUMBER_OF_INPUTS                           DISPLAY_NAME           "Number of inputs"
set_parameter_property   NUMBER_OF_INPUTS                           DESCRIPTION            "The number of inputs"
set_parameter_property   NUMBER_OF_INPUTS                           ALLOWED_RANGES         {1,2}
set_parameter_property   NUMBER_OF_INPUTS                           HDL_PARAMETER          false
set_parameter_property   NUMBER_OF_INPUTS                           AFFECTS_ELABORATION    true

add_parameter            NUMBER_OF_OUTPUTS                          INTEGER                1
set_parameter_property   NUMBER_OF_OUTPUTS                          DISPLAY_NAME           "Number of outputs"
set_parameter_property   NUMBER_OF_OUTPUTS                          DESCRIPTION            "The number of outputs"
set_parameter_property   NUMBER_OF_OUTPUTS                          ALLOWED_RANGES         {1,2}
set_parameter_property   NUMBER_OF_OUTPUTS                          HDL_PARAMETER          false
set_parameter_property   NUMBER_OF_OUTPUTS                          AFFECTS_ELABORATION    true


foreach io_name {INPUT_0 INPUT_1 OUTPUT_0 OUTPUT_1} {
    add_parameter            $io_name\_FIFO                             INTEGER                0
    set_parameter_property   $io_name\_FIFO                             DISPLAY_NAME           "Fifo size (0=no fifo)"
    set_parameter_property   $io_name\_FIFO                             DESCRIPTION            "Whether a fifo is added to smooth throughput on the given interface"
    set_parameter_property   $io_name\_FIFO                             ALLOWED_RANGES         0:1
    set_parameter_property   $io_name\_FIFO                             HDL_PARAMETER          false
    set_parameter_property   $io_name\_FIFO                             AFFECTS_ELABORATION    true
    set_parameter_property   $io_name\_FIFO                             VISIBLE                false

    add_parameter            $io_name\_FIFO_SIZE                        INTEGER                8
    set_parameter_property   $io_name\_FIFO_SIZE                        DISPLAY_NAME           "Fifo size"
    set_parameter_property   $io_name\_FIFO_SIZE                        DESCRIPTION            "Size of the fifo in beats for the given interface"
    set_parameter_property   $io_name\_FIFO_SIZE                        ALLOWED_RANGES         {2,4,8,16,32,64,128}
    set_parameter_property   $io_name\_FIFO_SIZE                        HDL_PARAMETER          false
    set_parameter_property   $io_name\_FIFO_SIZE                        AFFECTS_ELABORATION    true
    set_parameter_property   $io_name\_FIFO_SIZE                        VISIBLE                false

    add_parameter            $io_name\_NUMBER_OF_COLOR_PLANES           INTEGER                3
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           DISPLAY_NAME           "Number of color planes"
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           DESCRIPTION            "The number of color planes transmitted per pixel"
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           ALLOWED_RANGES         1:4
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           HDL_PARAMETER          false
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           AFFECTS_ELABORATION    true
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           VISIBLE                false

    add_parameter            $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     INTEGER                1
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     DISPLAY_NAME           "Color planes transmitted in parallel"
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     DESCRIPTION            "Whether color planes are transmitted in parallel"
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     ALLOWED_RANGES         0:1
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     DISPLAY_HINT           boolean
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     HDL_PARAMETER          false
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     AFFECTS_ELABORATION    true
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     VISIBLE                false

    add_parameter            $io_name\_PIXELS_IN_PARALLEL               INTEGER                1
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               DISPLAY_NAME           "Number of pixels transmitted in 1 clock cycle"
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               DESCRIPTION            "The number of pixels transmitted every clock cycle."
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               ALLOWED_RANGES         {1 2 4 8}
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               HDL_PARAMETER          false
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               AFFECTS_ELABORATION    true
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               VISIBLE                false

    add_parameter            $io_name\_TWO_PIXELS_PATTERN               INTEGER                0
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               DISPLAY_NAME           "Descriptor pattern spans two pixels"
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               DESCRIPTION            "Whether the descriptor pattern is one or two pixels."
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               ALLOWED_RANGES         0:1
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               DISPLAY_HINT           boolean
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               HDL_PARAMETER          false
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               AFFECTS_ELABORATION    true
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               VISIBLE                false

    add_parameter            $io_name\_PATTERN                          STRING                 "C0,C1,C2"
    set_parameter_property   $io_name\_PATTERN                          DISPLAY_NAME           "Interface pattern"
    set_parameter_property   $io_name\_PATTERN                          DESCRIPTION            "The pattern used for the interface, linking each color plane to a unique symbol"
    set_parameter_property   $io_name\_PATTERN                          HDL_PARAMETER          false
    set_parameter_property   $io_name\_PATTERN                          AFFECTS_ELABORATION    true
    set_parameter_property   $io_name\_PATTERN                          VISIBLE                false
}

add_user_packet_support_parameters PASSTHROUGH 0

foreach in_id {0 1 0 1} out_id {0 0 1 1} {
    add_parameter            USER_PKT_$in_id\_TO_$out_id                INTEGER                [expr ($in_id == $out_id) ? 1 : 0]
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                DISPLAY_NAME           "Propagate user packets from input $in_id"
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                DESCRIPTION            "Whether the user packets received on input %in_id are propagated to output $out_id"
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                ALLOWED_RANGES         0:1
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                DISPLAY_HINT           boolean
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                HDL_PARAMETER          false
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                AFFECTS_ELABORATION    true
    set_parameter_property   USER_PKT_$in_id\_TO_$out_id                VISIBLE                false
}


add_parameter            EXTRA_PIPELINING                           INTEGER                0
set_parameter_property   EXTRA_PIPELINING                           DISPLAY_NAME           "Add extra pipelining registers"
set_parameter_property   EXTRA_PIPELINING                           ALLOWED_RANGES         0:1
set_parameter_property   EXTRA_PIPELINING                           DESCRIPTION            "Selecting this option adds extra pipeline stage registers to the data path"
set_parameter_property   EXTRA_PIPELINING                           HDL_PARAMETER          false
set_parameter_property   EXTRA_PIPELINING                           AFFECTS_ELABORATION    true
set_parameter_property   EXTRA_PIPELINING                           DISPLAY_HINT           boolean

add_parameter            INPUT_VALIDATION                           INTEGER                1
set_parameter_property   INPUT_VALIDATION                           DESCRIPTION            "Whether the rearranger input patterns are valid"
set_parameter_property   INPUT_VALIDATION                           ALLOWED_RANGES         0:1
set_parameter_property   INPUT_VALIDATION                           HDL_PARAMETER          false
set_parameter_property   INPUT_VALIDATION                           DERIVED                false
set_parameter_property   INPUT_VALIDATION                           AFFECTS_VALIDATION     true
set_parameter_property   INPUT_VALIDATION                           AFFECTS_ELABORATION    true
set_parameter_property   INPUT_VALIDATION                           VISIBLE                false

add_parameter            OUTPUT_VALIDATION                          INTEGER                1
set_parameter_property   OUTPUT_VALIDATION                          DESCRIPTION            "Whether the rearranger output patterns are valid"
set_parameter_property   OUTPUT_VALIDATION                          ALLOWED_RANGES         0:1
set_parameter_property   OUTPUT_VALIDATION                          HDL_PARAMETER          false
set_parameter_property   OUTPUT_VALIDATION                          DERIVED                false
set_parameter_property   OUTPUT_VALIDATION                          AFFECTS_VALIDATION     true
set_parameter_property   OUTPUT_VALIDATION                          AFFECTS_ELABORATION    true
set_parameter_property   OUTPUT_VALIDATION                          VISIBLE                false

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------


add_display_item  ""          "General"                                          GROUP
add_display_item  ""          "Interfaces"                                       GROUP

add_display_item  "General"        USER_PACKET_SUPPORT           PARAMETER
add_display_item  "General"        EXTRA_PIPELINING              PARAMETER

add_display_item  "Interfaces"     BITS_PER_SYMBOL               PARAMETER
add_display_item  "Interfaces"     NUMBER_OF_INPUTS              PARAMETER
add_display_item  "Interfaces"     NUMBER_OF_OUTPUTS             PARAMETER
add_display_item  "Interfaces"     "Grid"                        GROUP


set jar_path              "cps_helper.jar"
set widget_name           "io_grid"
add_display_item          "Grid"                $widget_name         PARAMETER
set_display_item_property "Grid"                WIDGET               [list $jar_path $widget_name]
set_display_item_property "Grid"             WIDGET_PARAMETER_MAP {
    NUMBER_OF_INPUTS                        NUMBER_OF_INPUTS
    NUMBER_OF_OUTPUTS                       NUMBER_OF_OUTPUTS
    USER_PACKET_SUPPORT                     USER_PACKET_SUPPORT
    INPUT_0_FIFO                            INPUT_0_FIFO
    INPUT_1_FIFO                            INPUT_1_FIFO
    OUTPUT_0_FIFO                           OUTPUT_0_FIFO
    OUTPUT_1_FIFO                           OUTPUT_1_FIFO
    INPUT_0_FIFO_SIZE                       INPUT_0_FIFO_SIZE
    INPUT_1_FIFO_SIZE                       INPUT_1_FIFO_SIZE
    OUTPUT_0_FIFO_SIZE                      OUTPUT_0_FIFO_SIZE
    OUTPUT_1_FIFO_SIZE                      OUTPUT_1_FIFO_SIZE
    INPUT_0_NUMBER_OF_COLOR_PLANES          INPUT_0_NUMBER_OF_COLOR_PLANES
    INPUT_1_NUMBER_OF_COLOR_PLANES          INPUT_1_NUMBER_OF_COLOR_PLANES
    OUTPUT_0_NUMBER_OF_COLOR_PLANES         OUTPUT_0_NUMBER_OF_COLOR_PLANES
    OUTPUT_1_NUMBER_OF_COLOR_PLANES         OUTPUT_1_NUMBER_OF_COLOR_PLANES
    INPUT_0_COLOR_PLANES_ARE_IN_PARALLEL    INPUT_0_COLOR_PLANES_ARE_IN_PARALLEL
    INPUT_1_COLOR_PLANES_ARE_IN_PARALLEL    INPUT_1_COLOR_PLANES_ARE_IN_PARALLEL
    OUTPUT_0_COLOR_PLANES_ARE_IN_PARALLEL   OUTPUT_0_COLOR_PLANES_ARE_IN_PARALLEL
    OUTPUT_1_COLOR_PLANES_ARE_IN_PARALLEL   OUTPUT_1_COLOR_PLANES_ARE_IN_PARALLEL
    INPUT_0_PIXELS_IN_PARALLEL              INPUT_0_PIXELS_IN_PARALLEL
    INPUT_1_PIXELS_IN_PARALLEL              INPUT_1_PIXELS_IN_PARALLEL
    OUTPUT_0_PIXELS_IN_PARALLEL             OUTPUT_0_PIXELS_IN_PARALLEL
    OUTPUT_1_PIXELS_IN_PARALLEL             OUTPUT_1_PIXELS_IN_PARALLEL
    INPUT_0_TWO_PIXELS_PATTERN              INPUT_0_TWO_PIXELS_PATTERN
    INPUT_1_TWO_PIXELS_PATTERN              INPUT_1_TWO_PIXELS_PATTERN
    OUTPUT_0_TWO_PIXELS_PATTERN             OUTPUT_0_TWO_PIXELS_PATTERN
    OUTPUT_1_TWO_PIXELS_PATTERN             OUTPUT_1_TWO_PIXELS_PATTERN
    INPUT_0_PATTERN                         INPUT_0_PATTERN
    INPUT_1_PATTERN                         INPUT_1_PATTERN
    OUTPUT_0_PATTERN                        OUTPUT_0_PATTERN
    OUTPUT_1_PATTERN                        OUTPUT_1_PATTERN
    USER_PKT_0_TO_0                         USER_PKT_0_TO_0
    USER_PKT_0_TO_1                         USER_PKT_0_TO_1
    USER_PKT_1_TO_0                         USER_PKT_1_TO_0
    USER_PKT_1_TO_1                         USER_PKT_1_TO_1
    INPUT_VALIDATION                        INPUT_VALIDATION
    OUTPUT_VALIDATION                       OUTPUT_VALIDATION
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc cps_validation_callback {} {
    set number_of_inputs                               [get_parameter_value NUMBER_OF_INPUTS]
    set number_of_outputs                              [get_parameter_value NUMBER_OF_OUTPUTS]

    set input_0_pattern                                [get_parameter_value INPUT_0_PATTERN]
    set input_1_pattern                                [get_parameter_value INPUT_1_PATTERN]
    set output_0_pattern                               [get_parameter_value OUTPUT_0_PATTERN]
    set output_1_pattern                               [get_parameter_value OUTPUT_1_PATTERN]

    set input_validation                               [get_parameter_value INPUT_VALIDATION]
    set output_validation                              [get_parameter_value OUTPUT_VALIDATION]

    for {set i 0} {$i < $number_of_inputs} {incr i} {
        set pip                                            [get_parameter_value INPUT_$i\_PIXELS_IN_PARALLEL]
        set planes_in_par                                  [get_parameter_value INPUT_$i\_COLOR_PLANES_ARE_IN_PARALLEL]
        if {($pip > 1) && ($planes_in_par == 0)} {
            send_message Error "Input $i validation failed: color planes must be transmitted in parallel to enable more than 1 pixel in parallel"
        }
    }
    for {set k 0} {$k < $number_of_outputs} {incr k} {
        set pip                                            [get_parameter_value OUTPUT_$k\_PIXELS_IN_PARALLEL]
        set planes_in_par                                  [get_parameter_value OUTPUT_$k\_COLOR_PLANES_ARE_IN_PARALLEL]
        if {($pip > 1) && ($planes_in_par == 0)} {
            send_message Error "Output $k validation failed: color planes must be transmitted in parallel to enable more than 1 pixel in parallel"
        }
    }

    if {$input_validation == 0} {
        if {$number_of_inputs == 1} {
            send_message Error "Input pattern \[$input_0_pattern\] validation failed: pattern is invalid or contains duplicate symbols"
        } else {
            send_message Error "Input patterns \[$input_0_pattern\] and \[$input_1_pattern\] validation failed: patterns are invalid or contain duplicate symbols"
        }
    }

    if {$output_validation == 0} {
        if {$number_of_outputs == 1} {
            send_message Error "Output pattern \[$output_0_pattern\] validation failed: pattern is invalid or contains undefined input symbols"
        } else {
            send_message Error "Output patterns \[$output_0_pattern\] and \[$output_1_pattern\] validation failed: patterns are invalid or contain undefined input symbols"
            if {$number_of_inputs == 1} {
                send_message Info "Input pattern: \[$input_0_pattern\]"
            } else {
                send_message Info "Input patterns: \[$input_0_pattern\], \[$input_1_pattern\]"
            }
        }
    }

    set user_packet_support                            [get_parameter_value USER_PACKET_SUPPORT]
    set propagate_user_packets                         [string equal   $user_packet_support  "PASSTHROUGH"]
    if {$propagate_user_packets} {
        set propagate_count                            0
        for {set i 0} {$i < $number_of_inputs} {incr i} {
            for {set k 0} {$k < $number_of_outputs} {incr k} {
                if {[get_parameter_value USER_PKT_$i\_TO_$k]} {
                    incr propagate_count
                }
            }
        }
        if {$propagate_count == 0} {
            send_message Warning "All user packets will be discarded until an explicit mapping between input(s) and output(s) is selected"
        }
    }
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                        --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc cps_composition_callback {} {
    global isVersion
    global acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol                                [get_parameter_value BITS_PER_SYMBOL]
    set number_of_inputs                               [get_parameter_value NUMBER_OF_INPUTS]
    set number_of_outputs                              [get_parameter_value NUMBER_OF_OUTPUTS]
    foreach io_name {input_0 input_1 output_0 output_1} param_name {INPUT_0 INPUT_1 OUTPUT_0 OUTPUT_1} {
        set $io_name\_fifo                                 [get_parameter_value $param_name\_FIFO]
        set $io_name\_fifo_size                            [get_parameter_value $param_name\_FIFO_SIZE]
        set $io_name\_number_of_color_planes               [get_parameter_value $param_name\_NUMBER_OF_COLOR_PLANES]
        set $io_name\_color_planes_are_in_parallel         [get_parameter_value $param_name\_COLOR_PLANES_ARE_IN_PARALLEL]
        set $io_name\_pixels_in_parallel                   [get_parameter_value $param_name\_PIXELS_IN_PARALLEL]
        set $io_name\_two_pixels_pattern                   [get_parameter_value $param_name\_TWO_PIXELS_PATTERN]
        set $io_name\_pattern                              [get_parameter_value $param_name\_PATTERN]
    }
    set user_packet_support                            [get_parameter_value USER_PACKET_SUPPORT]
    foreach in_id {0 1 0 1} out_id {0 0 1 1} {
        set user_pkt_$in_id\_to_$out_id                    [get_parameter_value USER_PKT_$in_id\_TO_$out_id]
    }
    set extra_pipelining                               [get_parameter_value EXTRA_PIPELINING]

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    set enable_user_packets         [string compare $user_packet_support  "NONE_ALLOWED"]
    set propagate_user_packets      [string equal   $user_packet_support  "PASSTHROUGH"]

    set has_vib_cmd                 $enable_user_packets

    set user_pkt_routing_0_0        [expr $propagate_user_packets && $user_pkt_0_to_0]
    set user_pkt_routing_0_1        [expr ($number_of_outputs == 2) && $propagate_user_packets && $user_pkt_0_to_1]
    set user_pkt_routing_1_0        [expr ($number_of_inputs == 2) && $propagate_user_packets && $user_pkt_1_to_0]
    set user_pkt_routing_1_1        [expr ($number_of_inputs == 2) && ($number_of_outputs == 2) && $propagate_user_packets && $user_pkt_1_to_1]

    set has_duplicator              [expr ($user_pkt_routing_0_0 && $user_pkt_routing_0_1) || ($user_pkt_routing_1_0 && $user_pkt_routing_1_1)]

    set has_user_pkt_mux            [expr $has_duplicator && ($user_pkt_routing_0_0 || $user_pkt_routing_0_1) && ($user_pkt_routing_1_0 || $user_pkt_routing_1_1)]

    set has_scheduler               [expr $has_vib_cmd || ($input_0_two_pixels_pattern != $output_0_two_pixels_pattern) || (($number_of_outputs==2) && ($input_0_two_pixels_pattern != $output_1_two_pixels_pattern))];

    foreach io_name {input_0 input_1 output_0 output_1} {
        set $io_name\_planes_in_par     [expr [set $io_name\_color_planes_are_in_parallel] ? [set $io_name\_number_of_color_planes] : 1]
    }

    # --------------------------------------------------------------------------------------------------
    # -- Java helper call                                                                             --
    # --------------------------------------------------------------------------------------------------
    # Request the output rearranged pattern(s) from the java helper
    set source_params(BITS_PER_SYMBOL)                           $bits_per_symbol
    set source_params(NUMBER_OF_INPUTS)                          $number_of_inputs
    set source_params(NUMBER_OF_OUTPUTS)                         $number_of_outputs
    foreach io_name {input_0 input_1 output_0 output_1} param_name {INPUT_0 INPUT_1 OUTPUT_0 OUTPUT_1} {
        set source_params($param_name\_FIFO)                         [set $io_name\_fifo]
        set source_params($param_name\_FIFO_SIZE)                    [set $io_name\_fifo_size]
        set source_params($param_name\_NUMBER_OF_COLOR_PLANES)       [set $io_name\_number_of_color_planes]
        set source_params($param_name\_COLOR_PLANES_ARE_IN_PARALLEL) [set $io_name\_color_planes_are_in_parallel]
        set source_params($param_name\_PIXELS_IN_PARALLEL)           [set $io_name\_pixels_in_parallel]
        set source_params($param_name\_TWO_PIXELS_PATTERN)           [set $io_name\_two_pixels_pattern]
        set source_params($param_name\_PATTERN)                      [set $io_name\_pattern]
    }
    set source_params(USER_PACKET_SUPPORT)                       $user_packet_support
    foreach in_id {0 1 0 1} out_id {0 0 1 1} {
        set source_params(USER_PKT_$in_id\_TO_$out_id)               [set user_pkt_$in_id\_to_$out_id]
    }


    array set derived_params     [call_helper computeDerivedParams [array get source_params]]


    # --------------------------------------------------------------------------------------------------
    # -- The components to compose                                                                    --
    # --------------------------------------------------------------------------------------------------

    # Clock/reset bridges
    add_instance   av_st_clk_bridge        altera_clock_bridge                $acdsVersion
    add_instance   av_st_reset_bridge      altera_reset_bridge                $acdsVersion

    # Algorithmic core
    add_instance   cps_core                alt_vip_cps_alg_core               $isVersion

    # Optional scheduler
    if {$has_scheduler} {
        add_instance   cps_scheduler           alt_vip_cps_scheduler              $isVersion
    } else {
        # Optional terminator for the response from the second input vib
        if {$number_of_inputs == 2} {
            add_instance   cmd_terminator          alt_vip_message_sink_terminator    $isVersion
        }
        # Optional duplicator for VIB responses from input_0 when there is no sheduler and commands need to be routed to two outputs
        if {$number_of_outputs==2} {
            add_instance   vib_resp_duplicator     alt_vip_packet_duplicator          $isVersion
        }
    }

    # Optional mux for user packets (before the duplicator)
    if ($has_user_pkt_mux) {
       add_instance   user_packet_mux          alt_vip_packet_mux                 $isVersion
    }

    # Optional duplicator for user packets
    if {$has_duplicator} {
        add_instance   user_packet_duplicator  alt_vip_packet_duplicator          $isVersion
    }

    # Input/output FIFOs
    foreach io_name {input_0 input_1 output_0 output_1} {
        if {[set $io_name\_fifo]} {
            add_instance    $io_name\_sc_fifo      altera_avalon_sc_fifo              $acdsVersion
        }
    }

    # Vib response modules for all inputs, optional VIB commands to discard/route user packets
    for {set i 0} {$i < $number_of_inputs} {incr i} {
        add_instance   video_in_resp_$i        alt_vip_video_input_bridge_resp    $isVersion
        if { $has_vib_cmd } {
            add_instance   video_in_cmd_$i         alt_vip_video_input_bridge_cmd     $isVersion
        }
    }

    # Vob modules for all outputs
    for {set k 0} {$k < $number_of_outputs} {incr k} {
        add_instance   video_out_$k            alt_vip_video_output_bridge        $isVersion
    }

    # Cpp converters and pip converters for the I/Os as defined by the Java Helper
    foreach io_name {input_0 input_1 output_0 output_1} {
        if {$derived_params($io_name\_has_shared_pipconv)} {
            add_instance   $io_name\_shared_conv       alt_vip_pip_converter_core         $isVersion
        } elseif {$derived_params($io_name\_has_shared_cppconv)} {
            add_instance   $io_name\_shared_conv       alt_vip_cpp_converter              $isVersion
        }
        if {$derived_params($io_name\_has_alg_pipconv)} {
            add_instance   $io_name\_alg_conv          alt_vip_pip_converter_core         $isVersion
        } elseif {$derived_params($io_name\_has_alg_cppconv)} {
            add_instance   $io_name\_alg_conv          alt_vip_cpp_converter              $isVersion
        }
        if {$derived_params($io_name\_has_user_pkt_pipconv)} {
            add_instance   $io_name\_user_pkt_conv     alt_vip_pip_converter_core         $isVersion
        } elseif {$derived_params($io_name\_has_user_pkt_cppconv)} {
            add_instance   $io_name\_user_pkt_conv     alt_vip_cpp_converter              $isVersion
        }
    }

    # Input demuxes and output muxes for user packets
    if {$user_pkt_routing_0_0 || $user_pkt_routing_0_1} {
        add_instance   input_0_demux           alt_vip_packet_demux               $isVersion
    }
    if {$user_pkt_routing_1_0 || $user_pkt_routing_1_1} {
        add_instance   input_1_demux           alt_vip_packet_demux               $isVersion
    }
    if {$user_pkt_routing_0_0 || $user_pkt_routing_1_0} {
        add_instance   output_0_mux            alt_vip_packet_mux                 $isVersion
    }
    if {$user_pkt_routing_0_1 || $user_pkt_routing_1_1} {
        add_instance   output_1_mux            alt_vip_packet_mux                 $isVersion
    }

    # --------------------------------------------------------------------------------------------------
    # -- Parameterization                                                                             --
    # --------------------------------------------------------------------------------------------------
    # Algorithmic core (pipeline ready compulsory to avoid combinational loops)
    set_instance_parameter_value   cps_core                  BITS_PER_SYMBOL                $bits_per_symbol
    set_instance_parameter_value   cps_core                  NUMBER_OF_INPUTS               $number_of_inputs
    set_instance_parameter_value   cps_core                  NUMBER_OF_OUTPUTS              $number_of_outputs
    set_instance_parameter_value   cps_core                  SRC_WIDTH                      8
    set_instance_parameter_value   cps_core                  DST_WIDTH                      8
    set_instance_parameter_value   cps_core                  CONTEXT_WIDTH                  8
    set_instance_parameter_value   cps_core                  TASK_WIDTH                     8
    set_instance_parameter_value   cps_core                  PIPELINE_READY                 1
    # Skip invalid parameterization if validation fails
    if {($derived_params(input_validation) == 1) && ($derived_params(output_validation) == 1)} {
        foreach io_name {input_0 input_1 output_0 output_1} param_name {INPUT_0 INPUT_1 OUTPUT_0 OUTPUT_1} {
            set_instance_parameter_value   cps_core                  $param_name\_NUMBER_OF_COLOR_PLANES            [set $io_name\_number_of_color_planes]
            set_instance_parameter_value   cps_core                  $param_name\_COLOR_PLANES_ARE_IN_PARALLEL      $derived_params($io_name\_alg_color_planes_are_in_parallel)
            set_instance_parameter_value   cps_core                  $param_name\_PIXELS_IN_PARALLEL                $derived_params($io_name\_alg_pixels_in_parallel)
            set_instance_parameter_value   cps_core                  $param_name\_TWO_PIXELS_PATTERN                [set $io_name\_two_pixels_pattern]
        }
        foreach io_name {output_0 output_1} param_name {OUTPUT_0 OUTPUT_1} {
            set_instance_parameter_value   cps_core                  $param_name\_PATTERN           $derived_params($io_name\_rearranged_pattern)
        }
    }

    # Optional scheduler
    if {$has_scheduler} {
        set_instance_parameter_value   cps_scheduler             NUMBER_OF_INPUTS               $number_of_inputs
        set_instance_parameter_value   cps_scheduler             NUMBER_OF_OUTPUTS              $number_of_outputs
        set_instance_parameter_value   cps_scheduler             OUTPUT_0_WIDTH_MOD             [expr ($output_0_two_pixels_pattern ? 1 : 0) - ($input_0_two_pixels_pattern ? 1 : 0)]
        set_instance_parameter_value   cps_scheduler             OUTPUT_1_WIDTH_MOD             [expr ($output_1_two_pixels_pattern ? 1 : 0) - ($input_0_two_pixels_pattern ? 1 : 0)]
        set_instance_parameter_value   cps_scheduler             LINE_SPLITTING_ALLOWED         0
        set_instance_parameter_value   cps_scheduler             USER_PACKET_SUPPORT            $user_packet_support
        foreach in_id {0 1 0 1} out_id {0 0 1 1} {
            set_instance_parameter_value   cps_scheduler             USER_PKT_$in_id\_TO_$out_id    [set user_pkt_$in_id\_to_$out_id]
        }
        set_instance_parameter_value   cps_scheduler             PIPELINE_READY                 $extra_pipelining
        set_instance_parameter_value   cps_scheduler             SRC_WIDTH                      8
        set_instance_parameter_value   cps_scheduler             DST_WIDTH                      8
        set_instance_parameter_value   cps_scheduler             CONTEXT_WIDTH                  8
        set_instance_parameter_value   cps_scheduler             TASK_WIDTH                     8
    } else {
        # Optional terminator to sink the responses from the second input vib
        if {$number_of_inputs==2} {
            set_instance_parameter_value   cmd_terminator            DATA_WIDTH                     32
            set_instance_parameter_value   cmd_terminator            SRC_WIDTH                      8
            set_instance_parameter_value   cmd_terminator            DST_WIDTH                      8
            set_instance_parameter_value   cmd_terminator            CONTEXT_WIDTH                  8
            set_instance_parameter_value   cmd_terminator            TASK_WIDTH                     8
            set_instance_parameter_value   cmd_terminator            USER_WIDTH                     0
        }
        # Optional duplicator to duplicate the responses from the first input vib to the two output vob
        if {$number_of_outputs==2} {
            set_instance_parameter_value   vib_resp_duplicator       DATA_WIDTH                  32
            set_instance_parameter_value   vib_resp_duplicator       CMD_RESP_INTERFACE          1
            set_instance_parameter_value   vib_resp_duplicator       PIXELS_IN_PARALLEL          1
            set_instance_parameter_value   vib_resp_duplicator       DUPLICATOR_FANOUT           2
            set_instance_parameter_value   vib_resp_duplicator       ALWAYS_DUPLICATE_ALL        1
            set_instance_parameter_value   vib_resp_duplicator       USE_COMMAND                 0
            set_instance_parameter_value   vib_resp_duplicator       DEPTH                       0
            set_instance_parameter_value   vib_resp_duplicator       REGISTER_OUTPUT             1
            set_instance_parameter_value   vib_resp_duplicator       PIPELINE_READY              $extra_pipelining
        }
    }

    # Optional mux for user packets (before the duplicator)
    if ($has_user_pkt_mux) {
        set_instance_parameter_value   user_packet_mux           DATA_WIDTH                     [expr $bits_per_symbol * $derived_params(user_pkt_dup_planes_in_parallel)]
        set_instance_parameter_value   user_packet_mux           PIXELS_IN_PARALLEL             $derived_params(user_pkt_dup_pixels_in_parallel)
        set_instance_parameter_value   user_packet_mux           NUM_INPUTS                     2
        set_instance_parameter_value   user_packet_mux           SRC_WIDTH                      8
        set_instance_parameter_value   user_packet_mux           DST_WIDTH                      8
        set_instance_parameter_value   user_packet_mux           CONTEXT_WIDTH                  8
        set_instance_parameter_value   user_packet_mux           TASK_WIDTH                     8
        set_instance_parameter_value   user_packet_mux           USER_WIDTH                     0
        set_instance_parameter_value   user_packet_mux           REGISTER_OUTPUT                1
        set_instance_parameter_value   user_packet_mux           PIPELINE_READY                 $extra_pipelining
    }

    # Optional duplicator for user packets
    if {$has_duplicator} {
        set_instance_parameter_value   user_packet_duplicator    DATA_WIDTH                  [expr $bits_per_symbol * $derived_params(user_pkt_dup_planes_in_parallel)]
        set_instance_parameter_value   user_packet_duplicator    CMD_RESP_INTERFACE          0
        set_instance_parameter_value   user_packet_duplicator    PIXELS_IN_PARALLEL          $derived_params(user_pkt_dup_pixels_in_parallel)
        set_instance_parameter_value   user_packet_duplicator    DUPLICATOR_FANOUT           2
        set_instance_parameter_value   user_packet_duplicator    ALWAYS_DUPLICATE_ALL        0
        set_instance_parameter_value   user_packet_duplicator    USE_COMMAND                 0
        set_instance_parameter_value   user_packet_duplicator    DEPTH                       0
        set_instance_parameter_value   user_packet_duplicator    REGISTER_OUTPUT             1
        set_instance_parameter_value   user_packet_duplicator    PIPELINE_READY              $extra_pipelining
    }

    # VIB response components
    for {set i 0} {$i < $number_of_inputs} {incr i} {
        set_instance_parameter_value   video_in_resp_$i          BITS_PER_SYMBOL                $bits_per_symbol
        set_instance_parameter_value   video_in_resp_$i          NUMBER_OF_COLOR_PLANES         [set input_$i\_number_of_color_planes]
        set_instance_parameter_value   video_in_resp_$i          COLOR_PLANES_ARE_IN_PARALLEL   [set input_$i\_color_planes_are_in_parallel]
        set_instance_parameter_value   video_in_resp_$i          PIXELS_IN_PARALLEL             [set input_$i\_pixels_in_parallel]
        set_instance_parameter_value   video_in_resp_$i          DEFAULT_LINE_LENGTH            1920
        set_instance_parameter_value   video_in_resp_$i          VIB_MODE                       LITE
        set_instance_parameter_value   video_in_resp_$i          ENABLE_RESOLUTION_CHECK        0
        set_instance_parameter_value   video_in_resp_$i          VIDEO_PROTOCOL_NO              1
        set_instance_parameter_value   video_in_resp_$i          SRC_WIDTH                      8
        set_instance_parameter_value   video_in_resp_$i          DST_WIDTH                      8
        set_instance_parameter_value   video_in_resp_$i          CONTEXT_WIDTH                  8
        set_instance_parameter_value   video_in_resp_$i          TASK_WIDTH                     8
        set_instance_parameter_value   video_in_resp_$i          RESP_SRC_ADDRESS               0
        set_instance_parameter_value   video_in_resp_$i          RESP_DST_ADDRESS               0
        set_instance_parameter_value   video_in_resp_$i          DATA_SRC_ADDRESS               0
        set_instance_parameter_value   video_in_resp_$i          PIPELINE_READY                 [expr $extra_pipelining || (([set $io_name\_fifo] == 0) && ($has_vib_cmd == 0))]
    }

    # VIB command components
    if { $has_vib_cmd } {
        for {set i 0} {$i < $number_of_inputs} {incr i} {
            set_instance_parameter_value   video_in_cmd_$i           BITS_PER_SYMBOL                $bits_per_symbol
            set_instance_parameter_value   video_in_cmd_$i           NUMBER_OF_COLOR_PLANES         [set input_$i\_number_of_color_planes]
            set_instance_parameter_value   video_in_cmd_$i           COLOR_PLANES_ARE_IN_PARALLEL   [set input_$i\_color_planes_are_in_parallel]
            set_instance_parameter_value   video_in_cmd_$i           PIXELS_IN_PARALLEL             [set input_$i\_pixels_in_parallel]
            set_instance_parameter_value   video_in_cmd_$i           SRC_WIDTH                      8
            set_instance_parameter_value   video_in_cmd_$i           DST_WIDTH                      8
            set_instance_parameter_value   video_in_cmd_$i           CONTEXT_WIDTH                  8
            set_instance_parameter_value   video_in_cmd_$i           TASK_WIDTH                     8
            set_instance_parameter_value   video_in_cmd_$i           DATA_SRC_ADDRESS               0
            set_instance_parameter_value   video_in_cmd_$i           PIPELINE_READY                 [expr $extra_pipelining || ([set $io_name\_fifo] == 0)]
        }
    }

    # Input/output FIFOs
    foreach io_name {input_0 input_1 output_0 output_1} {
        if {[set $io_name\_fifo]} {
            set ctrl_width                 [expr 2*int(log([set $io_name\_pixels_in_parallel])/log(2)) + 32]
            set_instance_parameter_value   $io_name\_sc_fifo         BITS_PER_SYMBOL                [expr $bits_per_symbol * [set $io_name\_planes_in_par] * [set $io_name\_pixels_in_parallel] + $ctrl_width]
            set_instance_parameter_value   $io_name\_sc_fifo         SYMBOLS_PER_BEAT               1
            set_instance_parameter_value   $io_name\_sc_fifo         FIFO_DEPTH                     [set $io_name\_fifo_size]
            set_instance_parameter_value   $io_name\_sc_fifo         USE_PACKETS                    1
            set_instance_parameter_value   $io_name\_sc_fifo         CHANNEL_WIDTH                  0
            set_instance_parameter_value   $io_name\_sc_fifo         ERROR_WIDTH                    0
            set_instance_parameter_value   $io_name\_sc_fifo         USE_FILL_LEVEL                 0
            set_instance_parameter_value   $io_name\_sc_fifo         USE_ALMOST_FULL_IF             0
            set_instance_parameter_value   $io_name\_sc_fifo         USE_ALMOST_EMPTY_IF            0
        }
    }
    # VOB components
    for {set k 0} {$k < $number_of_outputs} {incr k} {
        set_instance_parameter_value   video_out_$k              BITS_PER_SYMBOL                $bits_per_symbol
        set_instance_parameter_value   video_out_$k              NUMBER_OF_COLOR_PLANES         [set output_$k\_number_of_color_planes]
        set_instance_parameter_value   video_out_$k              COLOR_PLANES_ARE_IN_PARALLEL   [set output_$k\_color_planes_are_in_parallel]
        set_instance_parameter_value   video_out_$k              PIXELS_IN_PARALLEL             [set output_$k\_pixels_in_parallel]
        set_instance_parameter_value   video_out_$k              VIDEO_PROTOCOL_NO              1
        set_instance_parameter_value   video_out_$k              SRC_WIDTH                      8
        set_instance_parameter_value   video_out_$k              DST_WIDTH                      8
        set_instance_parameter_value   video_out_$k              CONTEXT_WIDTH                  8
        set_instance_parameter_value   video_out_$k              TASK_WIDTH                     8
    }

    foreach io_name {input_0 input_1 output_0 output_1} {
        if {$derived_params($io_name\_has_shared_pipconv)} {
            set_instance_parameter_value   $io_name\_shared_conv         PIXEL_WIDTH                    [expr [set $io_name\_planes_in_par] * $bits_per_symbol]
            set_instance_parameter_value   $io_name\_shared_conv         PIXELS_IN_PARALLEL_IN          $derived_params($io_name\_shared_pipconv_pip_in)
            set_instance_parameter_value   $io_name\_shared_conv         PIXELS_IN_PARALLEL_OUT         $derived_params($io_name\_shared_pipconv_pip_out)
            set_instance_parameter_value   $io_name\_shared_conv         FIFO_DEPTH                     0
            set_instance_parameter_value   $io_name\_shared_conv         SRC_WIDTH                      8
            set_instance_parameter_value   $io_name\_shared_conv         DST_WIDTH                      8
            set_instance_parameter_value   $io_name\_shared_conv         CONTEXT_WIDTH                  8
            set_instance_parameter_value   $io_name\_shared_conv         TASK_WIDTH                     8
            set_instance_parameter_value   $io_name\_shared_conv         PIPELINE_READY                 $extra_pipelining
        } elseif {$derived_params($io_name\_has_shared_cppconv)} {
            set_instance_parameter_value   $io_name\_shared_conv         BITS_PER_SYMBOL                $bits_per_symbol
            set_instance_parameter_value   $io_name\_shared_conv         NUMBER_OF_COLOR_PLANES_IN      $derived_params($io_name\_shared_cppconv_nb_planes_in)
            set_instance_parameter_value   $io_name\_shared_conv         NUMBER_OF_COLOR_PLANES_OUT     $derived_params($io_name\_shared_cppconv_nb_planes_out)
            set_instance_parameter_value   $io_name\_shared_conv         PIXELS_IN_PARALLEL_IN          $derived_params($io_name\_shared_cppconv_pip_in)
            set_instance_parameter_value   $io_name\_shared_conv         PIXELS_IN_PARALLEL_OUT         $derived_params($io_name\_shared_cppconv_pip_out)
            set_instance_parameter_value   $io_name\_shared_conv         SRC_WIDTH                      8
            set_instance_parameter_value   $io_name\_shared_conv         DST_WIDTH                      8
            set_instance_parameter_value   $io_name\_shared_conv         CONTEXT_WIDTH                  8
            set_instance_parameter_value   $io_name\_shared_conv         TASK_WIDTH                     8
            set_instance_parameter_value   $io_name\_shared_conv         PIPELINE_READY                 $extra_pipelining
        }
        if {$derived_params($io_name\_has_alg_pipconv)} {
            set_instance_parameter_value   $io_name\_alg_conv            PIXEL_WIDTH                    [expr [set $io_name\_planes_in_par] * $bits_per_symbol]
            set_instance_parameter_value   $io_name\_alg_conv            PIXELS_IN_PARALLEL_IN          $derived_params($io_name\_alg_pipconv_pip_in)
            set_instance_parameter_value   $io_name\_alg_conv            PIXELS_IN_PARALLEL_OUT         $derived_params($io_name\_alg_pipconv_pip_out)
            set_instance_parameter_value   $io_name\_alg_conv            FIFO_DEPTH                     0
            set_instance_parameter_value   $io_name\_alg_conv            SRC_WIDTH                      8
            set_instance_parameter_value   $io_name\_alg_conv            DST_WIDTH                      8
            set_instance_parameter_value   $io_name\_alg_conv            CONTEXT_WIDTH                  8
            set_instance_parameter_value   $io_name\_alg_conv            TASK_WIDTH                     8
            set_instance_parameter_value   $io_name\_alg_conv            PIPELINE_READY                 $extra_pipelining
        } elseif {$derived_params($io_name\_has_alg_cppconv)} {
            set_instance_parameter_value   $io_name\_alg_conv            BITS_PER_SYMBOL                $bits_per_symbol
            set_instance_parameter_value   $io_name\_alg_conv            NUMBER_OF_COLOR_PLANES_IN      $derived_params($io_name\_alg_cppconv_nb_planes_in)
            set_instance_parameter_value   $io_name\_alg_conv            NUMBER_OF_COLOR_PLANES_OUT     $derived_params($io_name\_alg_cppconv_nb_planes_out)
            set_instance_parameter_value   $io_name\_alg_conv            PIXELS_IN_PARALLEL_IN          $derived_params($io_name\_alg_cppconv_pip_in)
            set_instance_parameter_value   $io_name\_alg_conv            PIXELS_IN_PARALLEL_OUT         $derived_params($io_name\_alg_cppconv_pip_out)
            set_instance_parameter_value   $io_name\_alg_conv            SRC_WIDTH                      8
            set_instance_parameter_value   $io_name\_alg_conv            DST_WIDTH                      8
            set_instance_parameter_value   $io_name\_alg_conv            CONTEXT_WIDTH                  8
            set_instance_parameter_value   $io_name\_alg_conv            TASK_WIDTH                     8
            set_instance_parameter_value   $io_name\_alg_conv            PIPELINE_READY                 $extra_pipelining
        }
        if {$derived_params($io_name\_has_user_pkt_pipconv)} {
            set_instance_parameter_value   $io_name\_user_pkt_conv       PIXEL_WIDTH                    [expr [set $io_name\_planes_in_par] * $bits_per_symbol]
            set_instance_parameter_value   $io_name\_user_pkt_conv       PIXELS_IN_PARALLEL_IN          $derived_params($io_name\_user_pkt_pipconv_pip_in)
            set_instance_parameter_value   $io_name\_user_pkt_conv       PIXELS_IN_PARALLEL_OUT         $derived_params($io_name\_user_pkt_pipconv_pip_out)
            set_instance_parameter_value   $io_name\_user_pkt_conv       FIFO_DEPTH                     0
            set_instance_parameter_value   $io_name\_user_pkt_conv       SRC_WIDTH                      8
            set_instance_parameter_value   $io_name\_user_pkt_conv       DST_WIDTH                      8
            set_instance_parameter_value   $io_name\_user_pkt_conv       CONTEXT_WIDTH                  8
            set_instance_parameter_value   $io_name\_user_pkt_conv       TASK_WIDTH                     8
            set_instance_parameter_value   $io_name\_user_pkt_conv       PIPELINE_READY                 $extra_pipelining

        } elseif {$derived_params($io_name\_has_user_pkt_cppconv)} {
            set_instance_parameter_value   $io_name\_user_pkt_conv       BITS_PER_SYMBOL                $bits_per_symbol
            set_instance_parameter_value   $io_name\_user_pkt_conv       NUMBER_OF_COLOR_PLANES_IN      $derived_params($io_name\_user_pkt_cppconv_nb_planes_in)
            set_instance_parameter_value   $io_name\_user_pkt_conv       NUMBER_OF_COLOR_PLANES_OUT     $derived_params($io_name\_user_pkt_cppconv_nb_planes_out)
            set_instance_parameter_value   $io_name\_user_pkt_conv       PIXELS_IN_PARALLEL_IN          $derived_params($io_name\_user_pkt_cppconv_pip_in)
            set_instance_parameter_value   $io_name\_user_pkt_conv       PIXELS_IN_PARALLEL_OUT         $derived_params($io_name\_user_pkt_cppconv_pip_out)
            set_instance_parameter_value   $io_name\_user_pkt_conv       SRC_WIDTH                      8
            set_instance_parameter_value   $io_name\_user_pkt_conv       DST_WIDTH                      8
            set_instance_parameter_value   $io_name\_user_pkt_conv       CONTEXT_WIDTH                  8
            set_instance_parameter_value   $io_name\_user_pkt_conv       TASK_WIDTH                     8
            set_instance_parameter_value   $io_name\_user_pkt_conv       PIPELINE_READY                 $extra_pipelining
        }
    }

    # Input demuxes muxes for user packets
    for {set i 0} {$i < $number_of_inputs} {incr i} {
        set pkt_routing_to_0           [set user_pkt_routing_$i\_0]
        set pkt_routing_to_1           [set user_pkt_routing_$i\_1]
        if {$pkt_routing_to_0 || $pkt_routing_to_1} {
            if {$derived_params(input_$i\_has_shared_pipconv)} {
                set_instance_parameter_value   input_$i\_demux           DATA_WIDTH                     [expr $bits_per_symbol * [set input_$i\_planes_in_par]]
                set_instance_parameter_value   input_$i\_demux           PIXELS_IN_PARALLEL             $derived_params(input_$i\_shared_pipconv_pip_out)
            } elseif {$derived_params(input_$i\_has_shared_cppconv)} {
                set_instance_parameter_value   input_$i\_demux           DATA_WIDTH                     [expr $bits_per_symbol * $derived_params(input_$i\_shared_cppconv_nb_planes_out)]
                set_instance_parameter_value   input_$i\_demux           PIXELS_IN_PARALLEL             $derived_params(input_$i\_shared_cppconv_pip_out)
            } else {
                set_instance_parameter_value   input_$i\_demux           DATA_WIDTH                     [expr $bits_per_symbol * [set input_$i\_planes_in_par]]
                set_instance_parameter_value   input_$i\_demux           PIXELS_IN_PARALLEL             [set input_$i\_pixels_in_parallel]
            }
            set_instance_parameter_value   input_$i\_demux           NUM_OUTPUTS                    2
            set_instance_parameter_value   input_$i\_demux           CLIP_ADDRESS_BITS              0
            set_instance_parameter_value   input_$i\_demux           SHIFT_ADDRESS_BITS             1
            set_instance_parameter_value   input_$i\_demux           SRC_WIDTH                      8
            set_instance_parameter_value   input_$i\_demux           DST_WIDTH                      8
            set_instance_parameter_value   input_$i\_demux           CONTEXT_WIDTH                  8
            set_instance_parameter_value   input_$i\_demux           TASK_WIDTH                     8
            set_instance_parameter_value   input_$i\_demux           USER_WIDTH                     0
            set_instance_parameter_value   input_$i\_demux           REGISTER_OUTPUT                1
            set_instance_parameter_value   input_$i\_demux           PIPELINE_READY                 $extra_pipelining
        }
    }

    for {set k 0} {$k < $number_of_outputs} {incr k} {
        set pkt_routing_from_0         [set user_pkt_routing_0_$k]
        set pkt_routing_from_1         [set user_pkt_routing_1_$k]
        if {$pkt_routing_from_0 || $pkt_routing_from_1} {
            if {$derived_params(output_$k\_has_shared_pipconv)} {
                set_instance_parameter_value   output_$k\_mux            DATA_WIDTH                     [expr $bits_per_symbol * [set output_$k\_planes_in_par]]
                set_instance_parameter_value   output_$k\_mux            PIXELS_IN_PARALLEL             $derived_params(output_$k\_shared_pipconv_pip_in)
            } elseif {$derived_params(output_$k\_has_shared_cppconv)} {
                set_instance_parameter_value   output_$k\_mux            DATA_WIDTH                     [expr $bits_per_symbol * $derived_params(output_$k\_shared_cppconv_nb_planes_in)]
                set_instance_parameter_value   output_$k\_mux            PIXELS_IN_PARALLEL             $derived_params(input_$i\_shared_cppconv_pip_out)
            } else {
                set_instance_parameter_value   output_$k\_mux            DATA_WIDTH                     [expr $bits_per_symbol * [set output_$k\_planes_in_par]]
                set_instance_parameter_value   output_$k\_mux            PIXELS_IN_PARALLEL             [set output_$k\_pixels_in_parallel]
            }
            set_instance_parameter_value   output_$k\_mux            NUM_INPUTS                     [expr $has_duplicator ? 2 : 1 + $pkt_routing_from_0 + $pkt_routing_from_1]
            set_instance_parameter_value   output_$k\_mux            SRC_WIDTH                      8
            set_instance_parameter_value   output_$k\_mux            DST_WIDTH                      8
            set_instance_parameter_value   output_$k\_mux            CONTEXT_WIDTH                  8
            set_instance_parameter_value   output_$k\_mux            TASK_WIDTH                     8
            set_instance_parameter_value   output_$k\_mux            USER_WIDTH                     0
            set_instance_parameter_value   output_$k\_mux            REGISTER_OUTPUT                1
            set_instance_parameter_value   output_$k\_mux            PIPELINE_READY                 $extra_pipelining
        }
    }


    # --------------------------------------------------------------------------------------------------
    # -- Top-level port mapping
    # --------------------------------------------------------------------------------------------------
    add_interface            main_clock                clock                        end
    add_interface            main_reset                reset                        end

    set_interface_property   main_clock                export_of                    av_st_clk_bridge.in_clk
    set_interface_property   main_reset                export_of                    av_st_reset_bridge.in_reset

    set_interface_property main_clock PORT_NAME_MAP {main_clock in_clk}
    set_interface_property main_reset PORT_NAME_MAP {main_reset in_reset}

    for {set i 0} {$i < $number_of_inputs} {incr i} {
        add_interface            din_$i                    avalon_streaming             sink
        set_interface_property   din_$i                    export_of                    video_in_resp_$i.av_st_vid_din
    }
    for {set k 0} {$k < $number_of_outputs} {incr k} {
        add_interface            dout_$k                   avalon_streaming             source
        set_interface_property   dout_$k                   export_of                    video_out_$k.av_st_vid_dout
    }


    # --------------------------------------------------------------------------------------------------
    # -- Connection of sub-components                                                                 --
    # --------------------------------------------------------------------------------------------------

    # Av-ST Clock/Reset connections :
    add_connection   av_st_clk_bridge.out_clk       av_st_reset_bridge.clk
    add_connection   av_st_clk_bridge.out_clk       cps_core.main_clock
    add_connection   av_st_reset_bridge.out_reset   cps_core.main_reset

    if {$has_scheduler} {
        add_connection   av_st_clk_bridge.out_clk       cps_scheduler.main_clock
        add_connection   av_st_reset_bridge.out_reset   cps_scheduler.main_reset
    } else {
        if {$number_of_inputs==2} {
            add_connection   av_st_clk_bridge.out_clk       cmd_terminator.main_clock
            add_connection   av_st_reset_bridge.out_reset   cmd_terminator.main_reset
        }
        if {$number_of_outputs==2} {
            add_connection   av_st_clk_bridge.out_clk       vib_resp_duplicator.main_clock
            add_connection   av_st_reset_bridge.out_reset   vib_resp_duplicator.main_reset
        }
    }
    if {$has_duplicator} {
        add_connection   av_st_clk_bridge.out_clk       user_packet_duplicator.main_clock
        add_connection   av_st_reset_bridge.out_reset   user_packet_duplicator.main_reset
        if ($has_user_pkt_mux) {
            add_connection   av_st_clk_bridge.out_clk       user_packet_mux.main_clock
            add_connection   av_st_reset_bridge.out_reset   user_packet_mux.main_reset
        }
    }
    foreach io_name {input_0 input_1 output_0 output_1} {
        if {[set $io_name\_fifo]} {
            add_connection   av_st_clk_bridge.out_clk       $io_name\_sc_fifo.clk
            add_connection   av_st_reset_bridge.out_reset   $io_name\_sc_fifo.clk_reset
        }
    }
    for {set i 0} {$i < $number_of_inputs} {incr i} {
        add_connection   av_st_clk_bridge.out_clk       video_in_resp_$i.main_clock
        add_connection   av_st_reset_bridge.out_reset   video_in_resp_$i.main_reset
        if { $has_vib_cmd } {
            add_connection   av_st_clk_bridge.out_clk       video_in_cmd_$i.main_clock
            add_connection   av_st_reset_bridge.out_reset   video_in_cmd_$i.main_reset
        }
    }
    for {set k 0} {$k < $number_of_outputs} {incr k} {
        add_connection   av_st_clk_bridge.out_clk       video_out_$k.main_clock
        add_connection   av_st_reset_bridge.out_reset   video_out_$k.main_reset
    }

    foreach io_name {input_0 input_1 output_0 output_1} {
        if {$derived_params($io_name\_has_shared_pipconv) || $derived_params($io_name\_has_shared_cppconv)} {
            add_connection   av_st_clk_bridge.out_clk       $io_name\_shared_conv.main_clock
            add_connection   av_st_reset_bridge.out_reset   $io_name\_shared_conv.main_reset
        }
        if {$derived_params($io_name\_has_alg_pipconv) || $derived_params($io_name\_has_alg_cppconv)} {
            add_connection   av_st_clk_bridge.out_clk       $io_name\_alg_conv.main_clock
            add_connection   av_st_reset_bridge.out_reset   $io_name\_alg_conv.main_reset
        }
        if {$derived_params($io_name\_has_user_pkt_pipconv) || $derived_params($io_name\_has_user_pkt_cppconv)} {
            add_connection   av_st_clk_bridge.out_clk       $io_name\_user_pkt_conv.main_clock
            add_connection   av_st_reset_bridge.out_reset   $io_name\_user_pkt_conv.main_reset
        }
    }

    if {$user_pkt_routing_0_0 || $user_pkt_routing_0_1} {
        add_connection   av_st_clk_bridge.out_clk       input_0_demux.main_clock
        add_connection   av_st_reset_bridge.out_reset   input_0_demux.main_reset
    }
    if {$user_pkt_routing_1_0 || $user_pkt_routing_1_1} {
        add_connection   av_st_clk_bridge.out_clk       input_1_demux.main_clock
        add_connection   av_st_reset_bridge.out_reset   input_1_demux.main_reset
    }
    if {$user_pkt_routing_0_0 || $user_pkt_routing_1_0} {
        add_connection   av_st_clk_bridge.out_clk       output_0_mux.main_clock
        add_connection   av_st_reset_bridge.out_reset   output_0_mux.main_reset
    }
    if {$user_pkt_routing_0_1 || $user_pkt_routing_1_1} {
        add_connection   av_st_clk_bridge.out_clk       output_1_mux.main_clock
        add_connection   av_st_reset_bridge.out_reset   output_1_mux.main_reset
    }

    # Datapath connections (input side)
    for {set i 0} {$i < $number_of_inputs} {incr i} {
        if { $has_vib_cmd } {
            add_connection   video_in_resp_$i.av_st_dout    video_in_cmd_$i.av_st_din
            set              video_input_port               video_in_cmd_$i.av_st_dout
        } else {
            set              video_input_port               video_in_resp_$i.av_st_dout
        }
        if {[set input_$i\_fifo]} {
            add_connection   $video_input_port              input_$i\_sc_fifo.in
            set              video_input_port               input_$i\_sc_fifo.out
        }
        if {$derived_params(input_$i\_has_shared_pipconv) || $derived_params(input_$i\_has_shared_cppconv)} {
            add_connection   $video_input_port              input_$i\_shared_conv.av_st_din
            set              video_input_port               input_$i\_shared_conv.av_st_dout
        }
        if {[set user_pkt_routing_$i\_0] || [set user_pkt_routing_$i\_1]} {
            add_connection   $video_input_port              input_$i\_demux.av_st_din
            set              video_input_port               input_$i\_demux.av_st_dout_0
            set              user_pkt_input_port            input_$i\_demux.av_st_dout_1
        }
        if {$derived_params(input_$i\_has_alg_pipconv) || $derived_params(input_$i\_has_alg_cppconv)} {
            add_connection   $video_input_port              input_$i\_alg_conv.av_st_din
            set              video_input_port               input_$i\_alg_conv.av_st_dout
        }
        if {$derived_params(input_$i\_has_user_pkt_pipconv) || $derived_params(input_$i\_has_user_pkt_cppconv)} {
            add_connection   $user_pkt_input_port           input_$i\_user_pkt_conv.av_st_din
            set              user_pkt_input_port            input_$i\_user_pkt_conv.av_st_dout
        }

        set    video_input_port_$i       $video_input_port
        if {[set user_pkt_routing_$i\_0] || [set user_pkt_routing_$i\_1]} {
            set              user_pkt_input_port_$i         $user_pkt_input_port
        }
    }


    # Datapath connections (output side)
    for {set k 0} {$k < $number_of_outputs} {incr k} {
        if {[set output_$k\_fifo]} {
            add_connection   output_$k\_sc_fifo.out               video_out_$k.av_st_din
            set              video_output_port                    output_$k\_sc_fifo.in
        } else {
            set              video_output_port                    video_out_$k.av_st_din
        }
        if {$derived_params(output_$k\_has_shared_pipconv) || $derived_params(output_$k\_has_shared_cppconv)} {
            add_connection   output_$k\_shared_conv.av_st_dout    $video_output_port
            set              video_output_port                    output_$k\_shared_conv.av_st_din
        }
        if {[set user_pkt_routing_0_$k] || [set user_pkt_routing_1_$k]} {
            add_connection   output_$k\_mux.av_st_dout            $video_output_port
            set              video_output_port                    output_$k\_mux.av_st_din_0
            set              user_pkt_output_port                 output_$k\_mux.av_st_din_1
        }
        if {$derived_params(output_$k\_has_alg_pipconv) || $derived_params(output_$k\_has_alg_cppconv)} {
            add_connection   output_$k\_alg_conv.av_st_dout       $video_output_port
            set              video_output_port                    output_$k\_alg_conv.av_st_din
        }
        if {$derived_params(output_$k\_has_user_pkt_pipconv) || $derived_params(output_$k\_has_user_pkt_cppconv)} {
            add_connection   output_$k\_user_pkt_conv.av_st_dout  $user_pkt_output_port
            set              user_pkt_output_port                 output_$k\_user_pkt_conv.av_st_din
        }

        set    video_output_port_$k       $video_output_port
        if {[set user_pkt_routing_0_$k] || [set user_pkt_routing_1_$k]} {
            set              user_pkt_output_port_$k              $user_pkt_output_port
        }
    }

    # Algorithmic core connections (skip if validation fails)
    #
    if {($derived_params(input_validation) == 1) && ($derived_params(output_validation) == 1)} {
        for {set i 0} {$i < $number_of_inputs} {incr i} {
            add_connection       [set video_input_port_$i]           cps_core.av_st_din_$i
        }
        for {set k 0} {$k < $number_of_outputs} {incr k} {
            add_connection       cps_core.av_st_dout_$k              [set video_output_port_$k]
        }
    }

    # Optional mux for user packets (before the duplicator)
    if {$has_user_pkt_mux} {
       add_connection    $user_pkt_input_port_0              user_packet_mux.av_st_din_0
       add_connection    $user_pkt_input_port_1              user_packet_mux.av_st_din_1
    }

    # User packet duplicator core connections (or user packet bypass)
    if {$has_duplicator} {
        if {$has_user_pkt_mux} {
            add_connection   user_packet_mux.av_st_dout              user_packet_duplicator.av_st_din
        } else {
            if {$user_pkt_routing_0_0} {
                add_connection   $user_pkt_input_port_0                  user_packet_duplicator.av_st_din
            } else {
                add_connection   $user_pkt_input_port_1                  user_packet_duplicator.av_st_din
            }
        }
        add_connection   user_packet_duplicator.av_st_dout_0     $user_pkt_output_port_0
        add_connection   user_packet_duplicator.av_st_dout_1     $user_pkt_output_port_1
    } else {
        # Setup direct connections between the demuxes (or perhaps cpp/pip converters user_pkt_pipconv/user_pkt_cppconv) and the mux
        if {$user_pkt_routing_0_0} {
            add_connection   $user_pkt_input_port_0                  $user_pkt_output_port_0
            set              user_pkt_output_port_0                  output_0_mux.av_st_din_2
        }
        if {$user_pkt_routing_1_0} {
            add_connection   $user_pkt_input_port_1                  $user_pkt_output_port_0
        }
        if {$user_pkt_routing_0_1} {
            add_connection   $user_pkt_input_port_0                  $user_pkt_output_port_1
            set              user_pkt_output_port_1                  output_1_mux.av_st_din_2
        }
        if {$user_pkt_routing_1_1} {
            add_connection   $user_pkt_input_port_1                  $user_pkt_output_port_1
        }
    }

    # Scheduler command/response connections
    if { $has_scheduler } {
        for {set i 0} {$i < $number_of_inputs} {incr i} {
            add_connection   video_in_resp_$i.av_st_resp             cps_scheduler.av_st_resp_vib_$i
            if {$has_vib_cmd} {
                add_connection   cps_scheduler.av_st_cmd_vib_$i          video_in_cmd_$i.av_st_cmd
            }
        }

        for {set k 0} {$k < $number_of_outputs} {incr k} {
            add_connection   cps_scheduler.av_st_cmd_vob_$k          video_out_$k.av_st_cmd
            if {[set user_pkt_routing_0_$k] || [set user_pkt_routing_1_$k]} {
                add_connection   cps_scheduler.av_st_cmd_mux_$k          output_$k\_mux.av_st_cmd
            }
        }

        if {$has_user_pkt_mux} {
            add_connection   cps_scheduler.av_st_cmd_dup_mux         user_packet_mux.av_st_cmd
        }
    } else {
        # Sink the responses from video_in_resp_1
        if ($number_of_inputs==2) {
            add_connection   video_in_resp_1.av_st_resp              cmd_terminator.av_st_din
        }
        # Direct VIB -> VOB response/command path (through duplicator if there are two output vobs to be driven)
        if ($number_of_outputs==2) {
            add_connection   video_in_resp_0.av_st_resp              vib_resp_duplicator.av_st_din
            add_connection   vib_resp_duplicator.av_st_dout_0        video_out_0.av_st_cmd
            add_connection   vib_resp_duplicator.av_st_dout_1        video_out_1.av_st_cmd
        } else {
            add_connection   video_in_resp_0.av_st_resp              video_out_0.av_st_cmd
        }
    }
}
