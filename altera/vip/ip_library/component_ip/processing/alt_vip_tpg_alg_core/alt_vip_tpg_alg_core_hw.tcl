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

# ------------------------------------------------------------------------------------------------------------
# --                                                                                                        --
# -- General information for the test pattern generator core module                                         --
# -- This block generates video packets as per the commands issued through the Avalon-ST Message Command    --
# -- interface. The resulting packets are output through a single Avalon-ST Message Data source             --
# --                                                                                                        --
# ------------------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_tpg_alg_core
set_module_property DISPLAY_NAME "Test Pattern Generator Core"
set_module_property DESCRIPTION "Generates video test pattern streams for validation and testing purposes"

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file src_hdl/alt_vip_tpg_alg_core.sv

add_static_misc_file  src_hdl/alt_vip_tpg_alg_core.ocp

setup_filesets alt_vip_tpg_alg_core

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
	
add_parameter DATA_SRC_ADDRESS INTEGER 0
set_parameter_property DATA_SRC_ADDRESS DISPLAY_NAME "dout Source ID"
set_parameter_property DATA_SRC_ADDRESS AFFECTS_GENERATION false
set_parameter_property DATA_SRC_ADDRESS HDL_PARAMETER true

# Add parameters for the data and command Avalon-ST message ports
add_av_st_event_parameters

add_max_dim_parameters 32 $vipsuite_max_width 32 $vipsuite_max_height
set_parameter_property MAX_WIDTH DEFAULT_VALUE 640
set_parameter_property MAX_WIDTH AFFECTS_ELABORATION true
set_parameter_property MAX_HEIGHT DEFAULT_VALUE 480
set_parameter_property MAX_HEIGHT AFFECTS_ELABORATION true
set_parameter_property MAX_HEIGHT DESCRIPTION "The maximum height of images / video frames, value must be the height of full progressive wave when outputting interlaced data"

#Add BITS_PER_PIXEL_PER_COLOR_PLANE parameter -> corresponds to bits per symbol for Avalon-ST
add_bits_per_symbol_parameters

#4k support 
add_pixels_in_parallel_parameters

# Other format only possible in YCbCr color space mode
add_parameter          OUTPUT_FORMAT string 4.4.4
set_parameter_property OUTPUT_FORMAT DISPLAY_NAME "Output format"
set_parameter_property OUTPUT_FORMAT ALLOWED_RANGES {"4.4.4:4:4:4" "4.2.2:4:2:2" "4.2.0:4:2:0"}
set_parameter_property OUTPUT_FORMAT DISPLAY_HINT ""
set_parameter_property OUTPUT_FORMAT DESCRIPTION "Sampling rate format for the output frames (4:4:4 or 4:2:2 or 4:2:0)"
set_parameter_property OUTPUT_FORMAT HDL_PARAMETER true
set_parameter_property OUTPUT_FORMAT AFFECTS_ELABORATION true

add_parameter          COLOR_SPACE string RGB
set_parameter_property COLOR_SPACE DISPLAY_NAME "Colorspace"
set_parameter_property COLOR_SPACE ALLOWED_RANGES {RGB YCbCr}
set_parameter_property COLOR_SPACE DISPLAY_HINT ""
set_parameter_property COLOR_SPACE DESCRIPTION "The color space to use an R'G'B or Y'Cb'Cr"
set_parameter_property COLOR_SPACE HDL_PARAMETER true
set_parameter_property COLOR_SPACE AFFECTS_ELABORATION true

add_parameter          INTERLACING string {prog}
set_parameter_property INTERLACING DISPLAY_NAME "Interlacing"
set_parameter_property INTERLACING ALLOWED_RANGES {{prog:Progressive output} {int_f0:Interlaced output (F0 First)} {int_f1:Interlaced output (F1 First)}}
set_parameter_property INTERLACING DISPLAY_HINT ""
set_parameter_property INTERLACING DESCRIPTION "Output stream is progressive or interlaced with either F0 first or F1 first"
set_parameter_property INTERLACING HDL_PARAMETER true
set_parameter_property INTERLACING AFFECTS_ELABORATION true

add_parameter          PATTERN string {colorbars}
set_parameter_property PATTERN DISPLAY_NAME "Pattern"
set_parameter_property PATTERN ALLOWED_RANGES {{colorbars:Color bars} {uniform:Uniform background} {greyscalebars:Black and White bars} {sdipatho:SDI Pathological}}
set_parameter_property PATTERN DISPLAY_HINT ""
set_parameter_property PATTERN DESCRIPTION "Selects a specific pattern as an output video stream"
set_parameter_property PATTERN HDL_PARAMETER true
set_parameter_property PATTERN AFFECTS_ELABORATION true

add_parameter          UNIFORM_VALUE_RY INTEGER 16
set_parameter_property UNIFORM_VALUE_RY DISPLAY_NAME "R or Y"
set_parameter_property UNIFORM_VALUE_RY DESCRIPTION "Color bit value for R or Y"
set_parameter_property UNIFORM_VALUE_RY HDL_PARAMETER true
set_parameter_property UNIFORM_VALUE_RY AFFECTS_ELABORATION true

add_parameter          UNIFORM_VALUE_GCB INTEGER 16
set_parameter_property UNIFORM_VALUE_GCB DISPLAY_NAME "G or Cb"
set_parameter_property UNIFORM_VALUE_GCB DESCRIPTION "Color bit value for G or Cb"
set_parameter_property UNIFORM_VALUE_GCB HDL_PARAMETER true
set_parameter_property UNIFORM_VALUE_GCB AFFECTS_ELABORATION true

add_parameter          UNIFORM_VALUE_BCR INTEGER 16
set_parameter_property UNIFORM_VALUE_BCR DISPLAY_NAME "B or Cr"
set_parameter_property UNIFORM_VALUE_BCR DESCRIPTION "Color bit value for B or Cr"
set_parameter_property UNIFORM_VALUE_BCR HDL_PARAMETER true
set_parameter_property UNIFORM_VALUE_BCR AFFECTS_ELABORATION true

add_parameter          USE_BACKGROUND_AS_BORDER INTEGER 0
set_parameter_property USE_BACKGROUND_AS_BORDER DISPLAY_NAME "Use background colour as colour for border"
set_parameter_property USE_BACKGROUND_AS_BORDER ALLOWED_RANGES 0:1
set_parameter_property USE_BACKGROUND_AS_BORDER HDL_PARAMETER true

# Planes in parallel (1) or sequence (0)
add_parameter 		   COLOR_PLANES_ARE_IN_PARALLEL INTEGER 0
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL DISPLAY_NAME "Color plane configuration"
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL DESCRIPTION "The color planes are arranged in parallel, otherwise in series (sequence)"
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER true
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL AFFECTS_ELABORATION true
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL ALLOWED_RANGES {0:Sequence 1:Parallel}
set_parameter_property COLOR_PLANES_ARE_IN_PARALLEL DISPLAY_HINT radio

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

set_module_property ELABORATION_CALLBACK tpg_elaboration_callback

proc tpg_elaboration_callback {} {
    set src_id                      [get_parameter_value DATA_SRC_ADDRESS]
	
    #setting up the command port
    set bps						    [get_parameter_value BITS_PER_SYMBOL]
    set par_mode					[get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set output_format			    [get_parameter_value OUTPUT_FORMAT]
    set pixels_in_parallel          [get_parameter_value PIXELS_IN_PARALLEL]
    set src_width                   [get_parameter_value SRC_WIDTH]
    set dst_width                   [get_parameter_value DST_WIDTH]
    set context_width               [get_parameter_value CONTEXT_WIDTH]
    set task_width                  [get_parameter_value TASK_WIDTH]
    set uni                         [string compare [get_parameter_value PATTERN] "uniform"]
   
    # Setting up options to set the uniform values for RGB and YCbCr
    if { $uni == 0 } {
        set_parameter_property UNIFORM_VALUE_RY ENABLED  true
        set_parameter_property UNIFORM_VALUE_GCB ENABLED true
        set_parameter_property UNIFORM_VALUE_BCR ENABLED true
    } else {   
        set_parameter_property UNIFORM_VALUE_RY ENABLED  false
        set_parameter_property UNIFORM_VALUE_GCB ENABLED false
        set_parameter_property UNIFORM_VALUE_BCR ENABLED false
    }
	
    # Setting the max and min range for uniform values (based on BPS value)
    if { $bps > 3 && $bps < 21} { 
        set result [expr {pow(2, $bps)}]
        set max [expr {$result - 1}]
        set i_max [expr {int($max)}]
        set s_max "0:"
        append s_max $i_max
        set_parameter_property UNIFORM_VALUE_RY ALLOWED_RANGES $s_max
        set_parameter_property UNIFORM_VALUE_GCB ALLOWED_RANGES $s_max
        set_parameter_property UNIFORM_VALUE_BCR ALLOWED_RANGES $s_max
    }
   
    # Channels that will be in parallel 
    if { $par_mode > 0 } {
        if { $output_format == "4.2.2" } {
            set channels_in_par 2
        } else {
            set channels_in_par 3
        }
    } else {
        set channels_in_par 1
    }
    
	if { $par_mode > 0 } {
      set symbols_per_pixel $channels_in_par
    } else {
      set symbols_per_pixel 1
    }   
    # Data width is the multiple of symbols in parallel, bits per symbol and pixels in parallel
    #set data_width                  [expr $channels_in_par * $bps * $pixels_in_parallel]
    set data_width                  [expr $bps * $symbols_per_pixel]

    #               name   elements_per_beat   dst_width    src_width    task_width    context_width     clock       pe_id 
    add_av_st_cmd_sink_port   av_st_cmd   1   $dst_width   $src_width   $task_width   $context_width   main_clock   $src_id

    #setting up the data output port
    add_av_st_data_source_port   av_st_dout   $data_width   $pixels_in_parallel   $dst_width   $src_width   $task_width   $context_width   0   main_clock   $src_id
}
