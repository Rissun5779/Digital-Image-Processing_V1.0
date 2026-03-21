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


package require -exact altera_terp 1.0

source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl

# ------------------------------------------------------------------------------------------------------------
# --                                                                                                        --
# -- General information for the CPS algorithmic core module                                                --
# -- This block sinks Avalon-ST Message Data packets from one or two sources, rearrange/duplicate/crop      --
# -- color planes as requested to output to one or two sinks                                                --
# ------------------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_cps_alg_core
set_module_property DISPLAY_NAME "CPS Algorithmic Core"
set_module_property DESCRIPTION "Forward/merge incoming packets, rearranging/cropping/duplicating color planes for one or two outputs"

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
set_module_property  VALIDATION_CALLBACK  validation_cb

# Elaboration callback to set up the dynamic ports
set_module_property  ELABORATION_CALLBACK elaboration_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_seq_par_convert_files ../../..
add_static_sv_file src_hdl/alt_vip_cps_alg_core.sv
add_static_sv_file src_hdl/alt_vip_cps_alg_core_packer.sv
add_static_sv_file src_hdl/alt_vip_cps_alg_core_unpacker.sv
add_static_sv_file src_hdl/alt_vip_cps_alg_core_wiring.sv

add_static_misc_file src_hdl/alt_vip_cps_alg_core.ocp

setup_filesets "" generation_cb


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
set_parameter_property   NUMBER_OF_INPUTS                           AFFECTS_ELABORATION    true
set_parameter_property   NUMBER_OF_INPUTS                           HDL_PARAMETER          true

add_parameter            NUMBER_OF_OUTPUTS                          INTEGER                1
set_parameter_property   NUMBER_OF_OUTPUTS                          DISPLAY_NAME           "Number of outputs"
set_parameter_property   NUMBER_OF_OUTPUTS                          DESCRIPTION            "The number of outputs"
set_parameter_property   NUMBER_OF_OUTPUTS                          ALLOWED_RANGES         {1,2}  
set_parameter_property   NUMBER_OF_OUTPUTS                          AFFECTS_ELABORATION    true
set_parameter_property   NUMBER_OF_OUTPUTS                          HDL_PARAMETER          true


foreach io_name {INPUT_0 INPUT_1 OUTPUT_0 OUTPUT_1} {
    add_parameter            $io_name\_NUMBER_OF_COLOR_PLANES           INTEGER                3
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           DISPLAY_NAME           "Number of color planes"
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           DESCRIPTION            "The number of color planes transmitted"
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           ALLOWED_RANGES         1:4
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           HDL_PARAMETER          true
    set_parameter_property   $io_name\_NUMBER_OF_COLOR_PLANES           AFFECTS_ELABORATION    true

    add_parameter            $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     INTEGER                1
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     DISPLAY_NAME           "Color planes transmitted in parallel"
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     DESCRIPTION            "Whether color planes are transmitted in parallel"
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     ALLOWED_RANGES         0:1
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     DISPLAY_HINT           boolean
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     HDL_PARAMETER          true
    set_parameter_property   $io_name\_COLOR_PLANES_ARE_IN_PARALLEL     AFFECTS_ELABORATION    true

    add_parameter            $io_name\_PIXELS_IN_PARALLEL               INTEGER                 1
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               DISPLAY_NAME            "Number of pixels transmitted in 1 clock cycle"
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               DESCRIPTION             "The number of pixels transmitted every clock cycle."
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               ALLOWED_RANGES          {1 2 4 8}
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               HDL_PARAMETER           true
    set_parameter_property   $io_name\_PIXELS_IN_PARALLEL               AFFECTS_ELABORATION     true

    add_parameter            $io_name\_TWO_PIXELS_PATTERN               INTEGER                 0
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               DISPLAY_NAME            "Descriptor pattern spans two pixels"
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               DESCRIPTION             "Whether the descriptor pattern is one or two pixels."
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               ALLOWED_RANGES          0:1
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               DISPLAY_HINT            boolean
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               HDL_PARAMETER           true
    set_parameter_property   $io_name\_TWO_PIXELS_PATTERN               AFFECTS_ELABORATION     true
}

foreach io_name {OUTPUT_0 OUTPUT_1} {
    add_parameter            $io_name\_PATTERN                          INTEGER_LIST            
    set_parameter_property   $io_name\_PATTERN                          DISPLAY_NAME            "Output pattern"
    set_parameter_property   $io_name\_PATTERN                          DESCRIPTION             "The pattern used for the output, linking each output symbol to a corresponding input symbol"
    set_parameter_property   $io_name\_PATTERN                          HDL_PARAMETER           false
    set_parameter_property   $io_name\_PATTERN                          AFFECTS_ELABORATION     false
    set_parameter_property   $io_name\_PATTERN                          AFFECTS_GENERATION      true
}

add_parameter            PIPELINE_READY                             INTEGER                0
set_parameter_property   PIPELINE_READY                             ALLOWED_RANGES         0:1
set_parameter_property   PIPELINE_READY                             DISPLAY_NAME           "Pipeline dout ready signals"
set_parameter_property   PIPELINE_READY                             DISPLAY_HINT           boolean
set_parameter_property   PIPELINE_READY                             AFFECTS_ELABORATION    false
set_parameter_property   PIPELINE_READY                             HDL_PARAMETER          true

add_parameter            NUMBER_ROUTING_ENGINES                     INTEGER
set_parameter_property   NUMBER_ROUTING_ENGINES                     DERIVED                true
set_parameter_property   NUMBER_ROUTING_ENGINES                     HDL_PARAMETER          true


# Add parameters for the data and command Avalon-ST message ports
add_av_st_event_parameters


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                                             --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc validation_cb {} {
    set   number_of_inputs        [get_parameter_value NUMBER_OF_INPUTS]
    set   number_of_outputs       [get_parameter_value NUMBER_OF_OUTPUTS]

    set    number_routing_engines_in_0                     0
    set    number_routing_engines_in_1                     0
    set    number_of_symbols_in_combined_input_pattern     0
    for {set in 0} {$in < $number_of_inputs} {incr in} {
        set color_planes_are_in_parallel    [get_parameter_value INPUT_$in\_COLOR_PLANES_ARE_IN_PARALLEL]
        set pixels_in_parallel              [get_parameter_value INPUT_$in\_PIXELS_IN_PARALLEL]
        set number_of_color_planes          [get_parameter_value INPUT_$in\_NUMBER_OF_COLOR_PLANES]
        set two_pixels_pattern              [get_parameter_value INPUT_$in\_TWO_PIXELS_PATTERN]
        if { $pixels_in_parallel > 1 && $color_planes_are_in_parallel == 0 } {
            send_message error   "Color planes must be transmitted in parallel to enable more than 1 pixel in parallel (input $in)"
        }
        incr     number_of_symbols_in_combined_input_pattern    [expr $number_of_color_planes * ($two_pixels_pattern ? 2 : 1)]
        
        set      number_routing_engines_in_$in           [expr ($pixels_in_parallel > 1) ? [expr $pixels_in_parallel / ($two_pixels_pattern ? 2 : 1)] : 1]
    }
 
    set    number_routing_engines_out_0                     0
    set    number_routing_engines_out_1                     0
    for {set out 0} {$out < $number_of_outputs} {incr out} {
        set color_planes_are_in_parallel    [get_parameter_value OUTPUT_$out\_COLOR_PLANES_ARE_IN_PARALLEL]
        set pixels_in_parallel              [get_parameter_value OUTPUT_$out\_PIXELS_IN_PARALLEL]
        set number_of_color_planes          [get_parameter_value OUTPUT_$out\_NUMBER_OF_COLOR_PLANES]
        set two_pixels_pattern              [get_parameter_value OUTPUT_$out\_TWO_PIXELS_PATTERN]
        set output_pattern                  [get_parameter_value OUTPUT_$out\_PATTERN]

        if { $pixels_in_parallel > 1 && $color_planes_are_in_parallel == 0 } {
            send_message error   "Color planes must be transmitted in parallel to enable more than 1 pixel in parallel (output $out)"
        }

        set number_of_symbols_in_output_pattern                [expr $number_of_color_planes * ($two_pixels_pattern ? 2 : 1)]
        set output_pattern_length                              [llength $output_pattern]
        
        if { $number_of_symbols_in_output_pattern != $output_pattern_length } {
            send_message error   "The output pattern length does not match with the expected number of symbols (length($output_pattern) == $output_pattern_length is different from $number_of_symbols_in_output_pattern)"
        } else {
            for {set i 0} {$i < $output_pattern_length} {incr i} {
                set    elem          [lindex   $output_pattern    $i]
                set    max           [expr     $number_of_symbols_in_combined_input_pattern - 1]
                if { ($elem < 0) || ($elem > $max) } {
                    send_message error   "Output pattern element $elem selected for output_$out\[$i\] is not in the range \[0,$max\]"
                }
            }
        }

        set      number_routing_engines_out_$out           [expr ($pixels_in_parallel > 1) ? [expr $pixels_in_parallel / ($two_pixels_pattern ? 2 : 1)] : 1]
    }
    
    if { ($number_of_inputs > 1) && ($number_routing_engines_in_0 != $number_routing_engines_in_1) } {
        send_message error   "Mismatch between the two inputs, pixels_in_parallel values and two_pixels_pattern values are not compatible"
    }
    if { ($number_routing_engines_in_0 != $number_routing_engines_out_0) ||
         ( ($number_of_outputs > 1) && ($number_routing_engines_in_0 != $number_routing_engines_out_1) ) } {
        send_message error   "Mismatch between inputs and output, pixels_in_parallel values and two_pixels_pattern values are not compatible"
    }

    set_parameter_value          NUMBER_ROUTING_ENGINES        $number_routing_engines_in_0
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
proc elaboration_cb {} {

    # Derive parameter
    set pixels_in_parallel        [get_parameter_value INPUT_0_PIXELS_IN_PARALLEL]
    set two_pixels_pattern        [get_parameter_value INPUT_0_TWO_PIXELS_PATTERN]

    set_parameter_value          NUMBER_ROUTING_ENGINES        [expr ($pixels_in_parallel > 1) ? [expr $pixels_in_parallel / ($two_pixels_pattern ? 2 : 1)] : 1]

    # Adding the input interfaces
    set   bits_per_symbol         [get_parameter_value BITS_PER_SYMBOL]
    set   number_of_inputs        [get_parameter_value NUMBER_OF_INPUTS]
    set   number_of_outputs       [get_parameter_value NUMBER_OF_OUTPUTS]
    
    set   src_width               [get_parameter_value SRC_WIDTH]
    set   dst_width               [get_parameter_value DST_WIDTH]
    set   context_width           [get_parameter_value CONTEXT_WIDTH]
    set   task_width              [get_parameter_value TASK_WIDTH]
    
    for {set in 0} {$in < $number_of_inputs} {incr in} {
        set color_planes_are_in_parallel    [get_parameter_value INPUT_$in\_COLOR_PLANES_ARE_IN_PARALLEL]
        set pixels_in_parallel              [get_parameter_value INPUT_$in\_PIXELS_IN_PARALLEL]
        set number_of_color_planes          [get_parameter_value INPUT_$in\_NUMBER_OF_COLOR_PLANES]
        
        set  data_width                     [expr ($color_planes_are_in_parallel > 0) ? [expr $bits_per_symbol * $number_of_color_planes] : $bits_per_symbol]

        add_av_st_data_sink_port            av_st_din_$in   $data_width  $pixels_in_parallel  $dst_width  $src_width  $task_width $context_width 0  main_clock  0

    }

    for {set out 0} {$out < $number_of_outputs} {incr out} {
        set color_planes_are_in_parallel    [get_parameter_value OUTPUT_$out\_COLOR_PLANES_ARE_IN_PARALLEL]
        set pixels_in_parallel              [get_parameter_value OUTPUT_$out\_PIXELS_IN_PARALLEL]
        set number_of_color_planes          [get_parameter_value OUTPUT_$out\_NUMBER_OF_COLOR_PLANES]
        
        set  data_width                     [expr ($color_planes_are_in_parallel > 0) ? [expr $bits_per_symbol * $number_of_color_planes] : $bits_per_symbol]

        add_av_st_data_source_port          av_st_dout_$out   $data_width  $pixels_in_parallel  $dst_width  $src_width  $task_width $context_width 0  main_clock  0
    }    
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Generation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc generation_cb {output_name} {

    set   number_of_inputs        [get_parameter_value NUMBER_OF_INPUTS]
    set   number_of_outputs       [get_parameter_value NUMBER_OF_OUTPUTS]
    
    set template_file "alt_vip_cps_alg_core_wrap.sv.terp"
    set template    [ read [ open $template_file r ] ]

    # Collect parameter values to Terp the wrapper (just a trick to get parameter arrays into the SV code)
    set output_0_list               [get_parameter_value    OUTPUT_0_PATTERN]
    set output_0_pattern_size       [llength $output_0_list]
    set output_0_pattern            [concat "'{"  [join $output_0_list ","]  "}"]
    
    if {$number_of_outputs > 1} {
        set output_1_list               [get_parameter_value    OUTPUT_1_PATTERN]
        set output_1_pattern_size       [llength $output_1_list]
        set output_1_pattern            [concat "'{"  [join $output_1_list ","]  "}"]
    } else {
        set output_1_pattern_size       1
        set output_1_pattern            "'{0}"
    }
    
    set params(output_name)              $output_name
    set params(output_0_pattern_size)    $output_0_pattern_size
    set params(output_0_pattern)         $output_0_pattern
    set params(output_1_pattern_size)    $output_1_pattern_size
    set params(output_1_pattern)         $output_1_pattern

    set result          [ altera_terp $template params ]
    set filename        ${output_name}.sv
    
    add_fileset_file  $filename  SYSTEM_VERILOG TEXT $result
}

