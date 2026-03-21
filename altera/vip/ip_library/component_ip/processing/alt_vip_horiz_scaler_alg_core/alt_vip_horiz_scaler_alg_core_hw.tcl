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

source   ../../../common_tcl/alt_vip_helper_common.tcl
source   ../../../common_tcl/alt_vip_files_common.tcl
source   ../../../common_tcl/alt_vip_parameters_common.tcl
source   ../../../common_tcl/alt_vip_interfaces_common.tcl

declare_general_component_info

set_module_property  NAME                 alt_vip_horiz_scaler_alg_core
set_module_property  DISPLAY_NAME         "Horizontal Scaler Algorithmic Core"
set_module_property  DESCRIPTION          "This block scales a line of video data using bilinear, bicubic or polyphase algorithms according
\to a scaling ratio defined through the Avalon-ST Message Command port"

set_module_property  VALIDATION_CALLBACK  horiz_scl_alg_core_validation_callback
set_module_property  ELABORATION_CALLBACK horiz_scl_alg_core_elaboration_callback
set_module_property  HELPER_JAR           horiz_scl_algo_core_helper.jar

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

add_alt_vip_common_pkg_files                    ../../..
add_alt_vip_common_event_packet_decode_files    ../../..
add_alt_vip_common_event_packet_encode_files    ../../..
add_alt_vip_common_mult_add_files               ../../..
add_alt_vip_common_mirror_files                 ../../..
add_alt_vip_common_round_sat_files              ../../..
add_alt_vip_common_pip_bunch_files              ../../..
add_alt_vip_common_pip_merge_files              ../../..
add_alt_vip_common_sop_align_files              ../../..
add_alt_vip_common_h_kernel_files               ../../..
add_alt_vip_common_rotate_mux_files             ../../..
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core_out_furtle.sv
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core_realign_in.sv
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core_realign_out.sv
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core_step_line.sv
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core_step_coeff.sv
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core_kernel.sv
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core_ed.sv
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core_control.sv
add_static_sv_file                              src_hdl/alt_vip_horiz_scaler_alg_core.sv

add_static_misc_file                            src_hdl/alt_vip_horiz_scaler_alg_core.ocp

setup_filesets "" generate_cb

# | parameters
add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  VISIBLE              false

add_parameter           BITS_PER_SYMBOL_IN            INTEGER                 8
set_parameter_property  BITS_PER_SYMBOL_IN            DISPLAY_NAME            "Input bits per pixel per color plane"
set_parameter_property  BITS_PER_SYMBOL_IN            ALLOWED_RANGES          4:52
set_parameter_property  BITS_PER_SYMBOL_IN            DESCRIPTION             "The number of bits used per color plane at the input"
set_parameter_property  BITS_PER_SYMBOL_IN            HDL_PARAMETER           false
set_parameter_property  BITS_PER_SYMBOL_IN            AFFECTS_ELABORATION     true

add_parameter           BITS_PER_SYMBOL_OUT           INTEGER 8
set_parameter_property  BITS_PER_SYMBOL_OUT           DISPLAY_NAME            "Output bits per pixel per color plane"
set_parameter_property  BITS_PER_SYMBOL_OUT           ALLOWED_RANGES          4:20
set_parameter_property  BITS_PER_SYMBOL_OUT           DESCRIPTION             "The number of bits used per color plane at the output"
set_parameter_property  BITS_PER_SYMBOL_OUT           HDL_PARAMETER           false
set_parameter_property  BITS_PER_SYMBOL_OUT           AFFECTS_ELABORATION     true


add_pixels_in_parallel_parameters                     {2 4 8}
set_parameter_property  PIXELS_IN_PARALLEL            DEFAULT_VALUE        2
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER        false

add_parameter           IS_422                        INTEGER              1
set_parameter_property  IS_422                        DISPLAY_NAME         "4:2:2 video data"
set_parameter_property  IS_422                        ALLOWED_RANGES       0:1
set_parameter_property  IS_422                        DISPLAY_HINT         boolean
set_parameter_property  IS_422                        DESCRIPTION          "Select for 4:2:2 video input/output"
set_parameter_property  IS_422                        HDL_PARAMETER        false
set_parameter_property  IS_422                        AFFECTS_ELABORATION  false

add_max_in_dim_parameters  
set_parameter_property  MAX_IN_WIDTH                  HDL_PARAMETER        false
set_parameter_property  MAX_IN_WIDTH                  ALLOWED_RANGES       32:$vipsuite_max_width
#jon:
set_parameter_property  MAX_IN_HEIGHT                 ALLOWED_RANGES       32:$vipsuite_max_height 
set_parameter_property  MAX_IN_HEIGHT                 VISIBLE              false
set_parameter_property  MAX_IN_HEIGHT                 HDL_PARAMETER        false

add_max_out_dim_parameters
set_parameter_property MAX_OUT_WIDTH                  HDL_PARAMETER        false
set_parameter_property MAX_OUT_WIDTH                  ALLOWED_RANGES       32:$vipsuite_max_width
#jon:
set_parameter_property MAX_OUT_HEIGHT                 ALLOWED_RANGES       32:$vipsuite_max_height 
set_parameter_property MAX_OUT_HEIGHT                 VISIBLE              false
set_parameter_property MAX_OUT_HEIGHT                 HDL_PARAMETER        false

add_parameter           ALGORITHM_NAME                string               POLYPHASE
set_parameter_property  ALGORITHM_NAME                DISPLAY_NAME         "Scaling algorithm"
set_parameter_property  ALGORITHM_NAME                ALLOWED_RANGES       {NEAREST_NEIGHBOUR BILINEAR BICUBIC POLYPHASE EDGE_ADAPT}
set_parameter_property  ALGORITHM_NAME                DISPLAY_HINT         ""
set_parameter_property  ALGORITHM_NAME                DESCRIPTION          "Selects the scaling alogithm used"
set_parameter_property  ALGORITHM_NAME                HDL_PARAMETER        false
set_parameter_property  ALGORITHM_NAME                AFFECTS_ELABORATION  true

add_parameter           LOAD_AT_RUNTIME               INTEGER              0
set_parameter_property  LOAD_AT_RUNTIME               DISPLAY_NAME         "Load scaler coefficients at runtime"
set_parameter_property  LOAD_AT_RUNTIME               ALLOWED_RANGES       0:1
set_parameter_property  LOAD_AT_RUNTIME               DISPLAY_HINT         boolean
set_parameter_property  LOAD_AT_RUNTIME               DESCRIPTION          "Allows the scaler coefficients for the bicubic and polyphase algorithms to be updated at runtime"
set_parameter_property  LOAD_AT_RUNTIME               HDL_PARAMETER        false
set_parameter_property  LOAD_AT_RUNTIME               AFFECTS_ELABORATION  true

add_parameter           H_TAPS                        INTEGER              8
set_parameter_property  H_TAPS                        DISPLAY_NAME         "Horizontal filter taps"
set_parameter_property  H_TAPS                        ALLOWED_RANGES       1:64
set_parameter_property  H_TAPS                        DESCRIPTION          "Number of horizontal filter taps for the bicubic and polyphase algorithms"
set_parameter_property  H_TAPS                        HDL_PARAMETER        false
set_parameter_property  H_TAPS                        AFFECTS_ELABORATION  false

add_parameter           H_PHASES                      INTEGER              16
set_parameter_property  H_PHASES                      DISPLAY_NAME         "Horizontal filter phases"
set_parameter_property  H_PHASES                      ALLOWED_RANGES       1:256
set_parameter_property  H_PHASES                      DESCRIPTION          "Number of horizontal filter phases for the bicubic and polyphase algorithms"
set_parameter_property  H_PHASES                      HDL_PARAMETER        false
set_parameter_property  H_PHASES                      AFFECTS_ELABORATION  false

add_parameter           H_SIGNED                      INTEGER              1
set_parameter_property  H_SIGNED                      DISPLAY_NAME         "Horizontal coefficients signed"
set_parameter_property  H_SIGNED                      ALLOWED_RANGES       0:1
set_parameter_property  H_SIGNED                      DISPLAY_HINT         boolean
set_parameter_property  H_SIGNED                      DESCRIPTION          "Forces the algorithm to use signed coefficient data"
set_parameter_property  H_SIGNED                      HDL_PARAMETER        false
set_parameter_property  H_SIGNED                      AFFECTS_ELABORATION  true

add_parameter           H_INTEGER_BITS                INTEGER              1
set_parameter_property  H_INTEGER_BITS                DISPLAY_NAME         "Horizontal coefficient integer bits"
set_parameter_property  H_INTEGER_BITS                ALLOWED_RANGES       0:32
set_parameter_property  H_INTEGER_BITS                DESCRIPTION          "Number of integer bits for each horizontal coefficient"
set_parameter_property  H_INTEGER_BITS                HDL_PARAMETER        false
set_parameter_property  H_INTEGER_BITS                AFFECTS_ELABORATION  true

add_parameter           H_FRACTION_BITS               INTEGER              7
set_parameter_property  H_FRACTION_BITS               DISPLAY_NAME         "Horizontal coefficient fraction bits"
set_parameter_property  H_FRACTION_BITS               ALLOWED_RANGES       1:32
set_parameter_property  H_FRACTION_BITS               DESCRIPTION          "Number of fraction bits for each horizontal coefficient"
set_parameter_property  H_FRACTION_BITS               HDL_PARAMETER        false
set_parameter_property  H_FRACTION_BITS               AFFECTS_ELABORATION  true

add_parameter           IN_SIGNED                     INTEGER              1
set_parameter_property  IN_SIGNED                     DISPLAY_NAME         "Signed input data"
set_parameter_property  IN_SIGNED                     ALLOWED_RANGES       0:1
set_parameter_property  IN_SIGNED                     DISPLAY_HINT         boolean
set_parameter_property  IN_SIGNED                     DESCRIPTION          "Forces the algorithm to treat the input data as signed"
set_parameter_property  IN_SIGNED                     HDL_PARAMETER        false
set_parameter_property  IN_SIGNED                     AFFECTS_ELABORATION  false

add_parameter           IN_FRACTION_BITS              INTEGER              7
set_parameter_property  IN_FRACTION_BITS              DISPLAY_NAME         "Input data fraction bits"
set_parameter_property  IN_FRACTION_BITS              ALLOWED_RANGES       0:32
set_parameter_property  IN_FRACTION_BITS              DESCRIPTION          "Number of fraction bits in the input data"
set_parameter_property  IN_FRACTION_BITS              HDL_PARAMETER        false
set_parameter_property  IN_FRACTION_BITS              AFFECTS_ELABORATION  false

add_parameter           H_FUNCTION                    string               LANCZOS_2
set_parameter_property  H_FUNCTION                    DISPLAY_NAME         "Horizontal coefficient function"
set_parameter_property  H_FUNCTION                    ALLOWED_RANGES       {LANCZOS_2 LANCZOS_3 CUSTOM}
set_parameter_property  H_FUNCTION                    DISPLAY_HINT         ""
set_parameter_property  H_FUNCTION                    DESCRIPTION          "Selects the function used to generate the horizontal scaling coefficients"
set_parameter_property  H_FUNCTION                    HDL_PARAMETER        false
set_parameter_property  H_FUNCTION                    AFFECTS_ELABORATION  true

add_parameter           H_BANKS                       INTEGER              1
set_parameter_property  H_BANKS                       DISPLAY_NAME         "Horizontal coefficient banks"
set_parameter_property  H_BANKS                       ALLOWED_RANGES       1:32
set_parameter_property  H_BANKS                       DESCRIPTION          "Number of banks of horizontal filter coefficients for the bicubic and polyphase algorithms"
set_parameter_property  H_BANKS                       HDL_PARAMETER        false
set_parameter_property  H_BANKS                       AFFECTS_ELABORATION  false

add_parameter           H_COEFF_FILE                  string               "<enter file name (including full path)>"
set_parameter_property  H_COEFF_FILE                  DISPLAY_NAME         "Horizontal coefficients file"
set_parameter_property  H_COEFF_FILE                  DESCRIPTION          "Selects the file containing the coefficient data"
set_parameter_property  H_COEFF_FILE                  HDL_PARAMETER        false
set_parameter_property  H_COEFF_FILE                  AFFECTS_ELABORATION  true

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Pipeline Av-ST ready signals"
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY                DESCRIPTION          "Adds an extra register stage to the Data output interface"
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        false

add_parameter           PRE_ALIGNED_SOP               INTEGER              0
set_parameter_property  PRE_ALIGNED_SOP               DISPLAY_NAME         "Pre-aligned SOP"
set_parameter_property  PRE_ALIGNED_SOP               ALLOWED_RANGES       0:1
set_parameter_property  PRE_ALIGNED_SOP               DISPLAY_HINT         boolean
set_parameter_property  PRE_ALIGNED_SOP               HDL_PARAMETER        false
set_parameter_property  PRE_ALIGNED_SOP               AFFECTS_ELABORATION  false

add_av_st_event_parameters
set_parameter_property  SRC_WIDTH                     HDL_PARAMETER        false
set_parameter_property  DST_WIDTH                     HDL_PARAMETER        false
set_parameter_property  CONTEXT_WIDTH                 HDL_PARAMETER        false
set_parameter_property  TASK_WIDTH                    HDL_PARAMETER        false

add_parameter           SOURCE_ID                     INTEGER              0
set_parameter_property  SOURCE_ID                     DISPLAY_NAME         "Source address for Data output interface"
set_parameter_property  SOURCE_ID                     HDL_PARAMETER        false

add_device_family_parameters
set_parameter_property  FAMILY                        HDL_PARAMETER        false

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports (clock & reset)                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   

add_main_clock_port

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic Ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc horiz_scl_alg_core_elaboration_callback {} {

   set   src_id                  [get_parameter_value SOURCE_ID]
   set   src_width               [get_parameter_value SRC_WIDTH]
   set   dst_width               [get_parameter_value DST_WIDTH]
   set   context_width           [get_parameter_value CONTEXT_WIDTH]
   set   task_width              [get_parameter_value TASK_WIDTH]
   set   bps_in                  [get_parameter_value BITS_PER_SYMBOL_IN]
   set   bps_out                 [get_parameter_value BITS_PER_SYMBOL_OUT]
   set   symbols_per_pixel       [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   pip                     [get_parameter_value PIXELS_IN_PARALLEL]
   set   algo_name               [get_parameter_value ALGORITHM_NAME]
   set   din_width               [expr $bps_in * $symbols_per_pixel]
   set   dout_width              [expr $bps_out * $symbols_per_pixel]
   
   add_av_st_cmd_sink_port       av_st_cmd               1     $dst_width  $src_width  $task_width $context_width    main_clock  $src_id
   add_av_st_resp_source_port    av_st_resp              1     $dst_width  $src_width  $task_width $context_width    main_clock  $src_id
   add_av_st_data_sink_port      av_st_din   $din_width  $pip  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
   add_av_st_data_source_port    av_st_dout  $dout_width $pip  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
   
   set   use_coeff               [get_parameter_value LOAD_AT_RUNTIME]
   if { $use_coeff > 0 } {
      set   use_coeff            [get_parameter_value ALGORITHM_NAME]
      if { [string compare $use_coeff POLYPHASE] == 0 || [string compare $use_coeff EDGE_ADAPT] == 0 } {
         set   use_coeff         1
      } else {
         set   use_coeff         0
      }
      if { $use_coeff > 0 } {
         set   h_signed             [get_parameter_value H_SIGNED]
         set   h_int                [get_parameter_value H_INTEGER_BITS]
         set   h_frac               [get_parameter_value H_FRACTION_BITS]

         set   coeff_width          [expr $h_signed + $h_int + $h_frac]
         add_av_st_data_sink_port   av_st_coeff $coeff_width   1  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
      }
   }

}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameter legality checks (validation callback)                                              --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   

proc horiz_scl_alg_core_validation_callback {} {

   set   limit    [get_parameter_value SRC_WIDTH]
   set   limit    [expr {pow(2, $limit)}]
   set   limit    [expr {$limit - 1}]
   set   value    [get_parameter_value SOURCE_ID]
   if { $value > $limit } {
      send_message Warning "Source address is outside the range supported by the specified dout source address width"
   }
   if { $value < 0 } {
      send_message Warning "Source address is outside the range supported by the specified dout source address width"
   }
   
   if { [get_parameter_value TASK_WIDTH] < 1 } {
      send_message Error "The Task ID width for the command port must be at least 1 bit"
   }
   
   set   runtime_load   [get_parameter_value LOAD_AT_RUNTIME]
   set   algo_name      [get_parameter_value ALGORITHM_NAME]
   set   h_function     [get_parameter_value H_FUNCTION]
   set   comp           [string compare $algo_name "EDGE_ADAPT"]
   if { $comp == 0 } {
      if { $runtime_load == 0 } {
         send_message error   "Only runtime loading of coefficients is currently supported for Edge Adaptive mode"
      }
   }
   
   if { $runtime_load == 0 && [string compare $algo_name POLYPHASE] == 0 } {
      if {[string compare $h_function CUSTOM] == 0} {
         #check for csv file
         set csh_file_path [get_parameter_value H_COEFF_FILE]
         if {[string compare $csh_file_path ""] == 0 || [string compare $csh_file_path "<enter file name (including full path)>"] == 0} {
            send_message ERROR "Please specify a valid horizontal coefficients file (including full path)."
         } else {
            if {![file exists $csh_file_path]} {
               send_message WARNING "${csh_file_path} could not be opened for reading. No such file."
            }
         }
      } else {
         if { [get_parameter_value H_SIGNED] == 0 } {
            send_message ERROR "Lanczos coefficients (horizontal) require the sign bit to be enabled."
         }
         if { [get_parameter_value H_INTEGER_BITS] != 1 } {
            send_message ERROR "Lanczos coefficients (horizontal) require 1 integer bit."
         }
      }
   
      set   h_coeff_width  [expr [get_parameter_value H_FRACTION_BITS] + [get_parameter_value H_INTEGER_BITS] + [get_parameter_value H_SIGNED] ]
      if { $h_coeff_width > 16 } {
         send_message error   "Total horizontal coefficient width (fraction bits + integer bits + optional sign bit) must not exceed 16 bits with fixed coefficients"
      }
   }
   
   if { $runtime_load == 1 && [string compare $algo_name POLYPHASE] == 0 } {
      set   h_coeff_width  [expr [get_parameter_value H_FRACTION_BITS] + [get_parameter_value H_INTEGER_BITS] + [get_parameter_value H_SIGNED] ]
      if { $h_coeff_width > 32 } {
         send_message error   "Total horizontal coefficient width (fraction bits + integer bits + optional sign bit) must not exceed 32 bits"
      }
   }
   
   # we only go up to 8 fraction bits for bilinear
   if { [string compare $algo_name BILINEAR] == 0 } {
      if { [get_parameter_value H_FRACTION_BITS] > 8 } {
         send_message ERROR "In Bilinear mode the value of horizontal fraction bits is limited to 8 or less"
      }
   }

   if { [string compare $algo_name NEAREST_NEIGHBOUR] == 0 } {
      if {[get_parameter_value BITS_PER_SYMBOL_IN] != [get_parameter_value BITS_PER_SYMBOL_OUT]} {
         send_message ERROR "In Nearest Neighbour mode the input and output bits per symbol must be the same"
      }
   }

   if { [get_parameter_value IS_422] > 0 } {
      if { [get_parameter_value NUMBER_OF_COLOR_PLANES] < 2 } {
         send_message error   "There must be at least 2 colors per pixel in 422 mode"
      }
   }

}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Output file generation (generate callback)                                                   --
# --                                                                                              --
# -------------------------------------------------------------------------------------------------- 

proc generate_cb {output_name} {
   set   template_file        "alt_vip_horiz_scaler_alg_core.v.terp"
   set   template             [ read [ open $template_file r ] ]
   
   set   coeff_file_name      "${output_name}_coeff.mif"
   set   coeff_file_formatted [format "%s%s%s" "\"" ${coeff_file_name} "\""]
   
   set   alg_name             [ get_parameter_value ALGORITHM_NAME ]
   if { [string compare $alg_name POLYPHASE] != 0 && [string compare $alg_name EDGE_ADAPT] != 0 } {
      set   load_at_runtime   0
   } else {
      set   load_at_runtime   [get_parameter_value LOAD_AT_RUNTIME]
   }
   set   h_signed                [get_parameter_value H_SIGNED]
   set   h_int                   [get_parameter_value H_INTEGER_BITS]
   set   h_frac                  [get_parameter_value H_FRACTION_BITS]
   set   pip                     [get_parameter_value PIXELS_IN_PARALLEL]
   if {$pip > 1} {
      set   empty_width             [clogb2_pure $pip]
   } else {
      set   empty_width             0
   }
   set   din_width            [expr [get_parameter_value BITS_PER_SYMBOL_IN] * [get_parameter_value NUMBER_OF_COLOR_PLANES] * $pip]
   set   dout_width           [expr [get_parameter_value BITS_PER_SYMBOL_OUT] * [get_parameter_value NUMBER_OF_COLOR_PLANES] * $pip]
   set   raw_alg_name         $alg_name
   set   alg_name             [format "%s%s%s" "\"" $alg_name "\""]   
   
   set   cmd_data_width       [expr 32 + [get_parameter_value SRC_WIDTH] + [get_parameter_value DST_WIDTH] + [get_parameter_value CONTEXT_WIDTH] + [get_parameter_value TASK_WIDTH] ]
   set   din_data_width       [expr $din_width + [get_parameter_value SRC_WIDTH] + [get_parameter_value DST_WIDTH] + [get_parameter_value CONTEXT_WIDTH] + [get_parameter_value TASK_WIDTH] + 2*$empty_width]
   set   dout_data_width      [expr $dout_width + [get_parameter_value SRC_WIDTH] + [get_parameter_value DST_WIDTH] + [get_parameter_value CONTEXT_WIDTH] + [get_parameter_value TASK_WIDTH] + 2*$empty_width]
   set   coeff_width          [expr [get_parameter_value H_SIGNED] + [get_parameter_value H_INTEGER_BITS] + [get_parameter_value H_FRACTION_BITS] ]
   if { $load_at_runtime < 1 } {
      set   coeff_data_width  1
   } else {
      set   coeff_data_width  [expr $coeff_width + [get_parameter_value SRC_WIDTH] + [get_parameter_value DST_WIDTH] + [get_parameter_value CONTEXT_WIDTH] + [get_parameter_value TASK_WIDTH]]
   }
   
   set family [get_parameter_value FAMILY]
   set cyclone_style 0
   set v_style 0
   set check [string match "*Cyclone*" $family]
   if { $check == 1 } {
      set check [string match "*Cyclone V*" $family]
      if { $check == 0 } {
         set cyclone_style 1
      } else {
         set v_style 1
      }
   } else {
      set check [string match "*Arria V*" $family]
      if { $check == 1 } {
         set v_style 1
      } else {
         set check [string match "*Stratix V*" $family]
         if { $check == 1 } {
            set v_style 1
         } else {
            set check [string match "*Arria 10*" $family]
            if { $check == 1 } {
               set v_style 1
            } else {
               set check [string match "*Stratix 10*" $family]
               if { $check == 1 } {
                  set v_style 1
               }
            }
         }
      }
   }
   
   #Collect parameter values for Terp
   set params(output_name)          $output_name
   set params(num_colours)          [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set params(bits_per_symbol_in)   [get_parameter_value BITS_PER_SYMBOL_IN]
   set params(bits_per_symbol_out)  [get_parameter_value BITS_PER_SYMBOL_OUT]
   set params(pip)                  [get_parameter_value PIXELS_IN_PARALLEL]
   set params(is_422)               [get_parameter_value IS_422]
   set params(max_in_width)         [get_parameter_value MAX_IN_WIDTH]
   set params(max_out_width)        [get_parameter_value MAX_OUT_WIDTH]
   set params(algorithm)            $alg_name
   set params(raw_algorithm_name)   $raw_alg_name
   set params(h_taps)               [get_parameter_value H_TAPS]
   set params(h_phases)             [get_parameter_value H_PHASES]
   set params(h_signed)             [get_parameter_value H_SIGNED]
   set params(h_int_bits)           [get_parameter_value H_INTEGER_BITS]
   set params(h_frac_bits)          [get_parameter_value H_FRACTION_BITS]
   set params(in_signed)            [get_parameter_value IN_SIGNED]
   set params(in_frac_bits)         [get_parameter_value IN_FRACTION_BITS]
   set params(load_at_runtime)      $load_at_runtime
   set params(h_banks)              [get_parameter_value H_BANKS]
   set params(src_width)            [get_parameter_value SRC_WIDTH]
   set params(dst_width)            [get_parameter_value DST_WIDTH]
   set params(context_width)        [get_parameter_value CONTEXT_WIDTH]
   set params(task_width)           [get_parameter_value TASK_WIDTH]
   set params(src_id)               [get_parameter_value SOURCE_ID]
   set params(coeff_file)           $coeff_file_formatted
   set params(cyclone_style)        $cyclone_style
   set params(v_series_style)       $v_style
   set params(pipeline)             [get_parameter_value PIPELINE_READY]
   set params(pre_aligned)          [get_parameter_value PRE_ALIGNED_SOP]
   set params(cmd_data_width)       $cmd_data_width
   set params(din_data_width)       $din_data_width
   set params(dout_data_width)      $dout_data_width
   set params(coeff_data_width)     $coeff_data_width
   
   set   result                     [altera_terp $template params]
   set   filename                   ${output_name}.v
   
   add_fileset_file                 $filename   VERILOG  TEXT  $result
   
   set   algo_name      [get_parameter_value ALGORITHM_NAME]
   set   runtime_load   [get_parameter_value LOAD_AT_RUNTIME]
   
   # compile time loading
   if { $runtime_load == 0 } {
      if { [string compare $algo_name POLYPHASE] == 0 || [string compare $algo_name BICUBIC] == 0 } {
         set source_params(H_BANKS)                [get_parameter_value H_BANKS]
         set source_params(ALGO_NAME)              $algo_name
         set source_params(H_FUNCTION)             [get_parameter_value H_FUNCTION]
         set source_params(H_PHASES)               [get_parameter_value H_PHASES]
         set source_params(H_TAPS)                 [get_parameter_value H_TAPS]
         set source_params(H_SIGNED)               [get_parameter_value H_SIGNED]
         set source_params(H_INTEGER_BITS)         [get_parameter_value H_INTEGER_BITS]
         set source_params(H_FRACTION_BITS)        [get_parameter_value H_FRACTION_BITS]
         set source_params(H_COEFF_FILE)           [get_parameter_value H_COEFF_FILE]
         
         set   coeff_mif_content    [call_helper generateCoeff [array get source_params]]
         
         add_fileset_file  src_hdl/${coeff_file_name} MIF   TEXT  ${coeff_mif_content}
      }
   }
}
