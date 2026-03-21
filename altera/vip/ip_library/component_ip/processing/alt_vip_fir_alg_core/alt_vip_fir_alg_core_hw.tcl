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


source   ../../../common_tcl/alt_vip_helper_common.tcl
source   ../../../common_tcl/alt_vip_files_common.tcl
source   ../../../common_tcl/alt_vip_parameters_common.tcl
source   ../../../common_tcl/alt_vip_interfaces_common.tcl

package require -exact altera_terp 1.0

# Common module properties for VIP components
declare_general_component_info

set_module_property  NAME                 alt_vip_fir_alg_core
set_module_property  DISPLAY_NAME         "FIR Algorithmic Core"
set_module_property  DESCRIPTION          "This block filters a line of data using either a standard 2D FIR Filter or an edge adaptive sharpening filter"
set_module_property  VALIDATION_CALLBACK  fir_alg_core_validation_callback
set_module_property  ELABORATION_CALLBACK fir_alg_core_elaboration_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
add_alt_vip_common_pkg_files                    ../../..
add_alt_vip_common_event_packet_decode_files    ../../..
add_alt_vip_common_event_packet_encode_files    ../../..
add_alt_vip_common_mult_add_files               ../../..
add_alt_vip_common_h_kernel_files               ../../..
add_alt_vip_common_mirror_files                 ../../..
add_alt_vip_common_edge_detect_chain_files      ../../..
add_alt_vip_common_sop_align_files              ../../..
add_alt_vip_common_data_by_line_rearrange_files ../../..
add_alt_vip_common_seq_par_convert_files        ../../..
add_alt_vip_common_round_sat_files              ../../..
add_static_sv_file                              src_hdl/alt_vip_fir_alg_core_symm_add.sv
add_static_sv_file                              src_hdl/alt_vip_fir_alg_core_edge_detect.sv
add_static_sv_file                              src_hdl/alt_vip_fir_alg_core_eas_base.sv
add_static_sv_file                              src_hdl/alt_vip_fir_alg_core_eas.sv
add_static_sv_file                              src_hdl/alt_vip_fir_alg_core_fir_base.sv
add_static_sv_file                              src_hdl/alt_vip_fir_alg_core_fir.sv
add_static_sv_file                              src_hdl/alt_vip_fir_alg_core_controller.sv
add_static_sv_file                              src_hdl/alt_vip_fir_alg_core.sv
add_static_misc_file                            src_hdl/alt_vip_fir_alg_core.ocp
setup_filesets                                  "" generate_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# -------------------------------------------------------------------------------------------------- 

add_channels_nb_parameters 
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER           false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER           false

add_pixels_in_parallel_parameters                     {1 2 4 8}
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER           false

add_parameter           BITS_PER_SYMBOL_IN            INTEGER                 8
set_parameter_property  BITS_PER_SYMBOL_IN            DISPLAY_NAME            "Input bits per pixel per color plane"
set_parameter_property  BITS_PER_SYMBOL_IN            ALLOWED_RANGES          4:20
set_parameter_property  BITS_PER_SYMBOL_IN            DESCRIPTION             "The number of bits used per color plane at the input"
set_parameter_property  BITS_PER_SYMBOL_IN            HDL_PARAMETER           false
set_parameter_property  BITS_PER_SYMBOL_IN            AFFECTS_ELABORATION     true

add_parameter           BITS_PER_SYMBOL_OUT           INTEGER 8
set_parameter_property  BITS_PER_SYMBOL_OUT           DISPLAY_NAME            "Output bits per pixel per color plane"
set_parameter_property  BITS_PER_SYMBOL_OUT           ALLOWED_RANGES          4:20
set_parameter_property  BITS_PER_SYMBOL_OUT           DESCRIPTION             "The number of bits used per color plane at the output"
set_parameter_property  BITS_PER_SYMBOL_OUT           HDL_PARAMETER           false
set_parameter_property  BITS_PER_SYMBOL_OUT           AFFECTS_ELABORATION     true

add_parameter           IS_422                        INTEGER                 0
set_parameter_property  IS_422                        DISPLAY_NAME            "4:2:2 video data"
set_parameter_property  IS_422                        ALLOWED_RANGES          0:1
set_parameter_property  IS_422                        DISPLAY_HINT            boolean
set_parameter_property  IS_422                        DESCRIPTION             "Select for 4:2:2 video input/output"
set_parameter_property  IS_422                        HDL_PARAMETER           false
set_parameter_property  IS_422                        AFFECTS_ELABORATION     false

add_parameter           ALGORITHM_NAME                string                  STANDARD_FIR
set_parameter_property  ALGORITHM_NAME                DISPLAY_NAME            "Filtering Algorithm"
set_parameter_property  ALGORITHM_NAME                ALLOWED_RANGES          {STANDARD_FIR EDGE_ADAPTIVE_SHARPEN}
set_parameter_property  ALGORITHM_NAME                DISPLAY_HINT            ""
set_parameter_property  ALGORITHM_NAME                DESCRIPTION             "Selects the filtering alogithm used"
set_parameter_property  ALGORITHM_NAME                HDL_PARAMETER           false
set_parameter_property  ALGORITHM_NAME                AFFECTS_ELABORATION     true

add_parameter           V_TAPS                        INTEGER                 8
set_parameter_property  V_TAPS                        DISPLAY_NAME            "Vertical filter taps"
set_parameter_property  V_TAPS                        ALLOWED_RANGES          1:16
set_parameter_property  V_TAPS                        DESCRIPTION             "Number of vertical filter taps for the bicubic and polyphase algorithms"
set_parameter_property  V_TAPS                        HDL_PARAMETER           false
set_parameter_property  V_TAPS                        AFFECTS_ELABORATION     true

add_parameter           H_TAPS                        INTEGER                 8
set_parameter_property  H_TAPS                        DISPLAY_NAME            "Horizontal filter taps"
set_parameter_property  H_TAPS                        ALLOWED_RANGES          1:16
set_parameter_property  H_TAPS                        DESCRIPTION             "Number of horizontal filter taps for the bicubic and polyphase algorithms"
set_parameter_property  H_TAPS                        HDL_PARAMETER           false
set_parameter_property  H_TAPS                        AFFECTS_ELABORATION     false

add_parameter           V_SYMMETRIC                   INTEGER                 0
set_parameter_property  V_SYMMETRIC                   DISPLAY_NAME            "Vertically symmetirc coefficients"
set_parameter_property  V_SYMMETRIC                   ALLOWED_RANGES          0:1
set_parameter_property  V_SYMMETRIC                   DISPLAY_HINT            boolean
set_parameter_property  V_SYMMETRIC                   DESCRIPTION             "Enable if the coefficients are vertically symmetric"
set_parameter_property  V_SYMMETRIC                   HDL_PARAMETER           false
set_parameter_property  V_SYMMETRIC                   AFFECTS_ELABORATION     true

add_parameter           H_SYMMETRIC                   INTEGER                 0
set_parameter_property  H_SYMMETRIC                   DISPLAY_NAME            "Horizontally symmetirc coefficients"
set_parameter_property  H_SYMMETRIC                   ALLOWED_RANGES          0:1
set_parameter_property  H_SYMMETRIC                   DISPLAY_HINT            boolean
set_parameter_property  H_SYMMETRIC                   DESCRIPTION             "Enable if the coefficients are horizontally symmetric"
set_parameter_property  H_SYMMETRIC                   HDL_PARAMETER           false
set_parameter_property  H_SYMMETRIC                   AFFECTS_ELABORATION     true

add_parameter           DIAG_SYMMETRIC                INTEGER                 0
set_parameter_property  DIAG_SYMMETRIC                DISPLAY_NAME            "Diagonally symmetirc coefficients"
set_parameter_property  DIAG_SYMMETRIC                ALLOWED_RANGES          0:1
set_parameter_property  DIAG_SYMMETRIC                DISPLAY_HINT            boolean
set_parameter_property  DIAG_SYMMETRIC                DESCRIPTION             "Enable if the coefficients are diagonally symmetric"
set_parameter_property  DIAG_SYMMETRIC                HDL_PARAMETER           false
set_parameter_property  DIAG_SYMMETRIC                AFFECTS_ELABORATION     true

add_parameter           COEFF_SIGNED                  INTEGER                 1
set_parameter_property  COEFF_SIGNED                  DISPLAY_NAME            "Use signed coefficients"
set_parameter_property  COEFF_SIGNED                  ALLOWED_RANGES          0:1
set_parameter_property  COEFF_SIGNED                  DISPLAY_HINT            boolean
set_parameter_property  COEFF_SIGNED                  DESCRIPTION             "Forces the algorithm to use signed coefficient data"
set_parameter_property  COEFF_SIGNED                  HDL_PARAMETER           false
set_parameter_property  COEFF_SIGNED                  AFFECTS_ELABORATION     true

add_parameter           COEFF_INTEGER_BITS            INTEGER                 1
set_parameter_property  COEFF_INTEGER_BITS            DISPLAY_NAME            "Coefficient integer bits"
set_parameter_property  COEFF_INTEGER_BITS            ALLOWED_RANGES          0:16
set_parameter_property  COEFF_INTEGER_BITS            DESCRIPTION             "Number of integer bits for each coefficient"
set_parameter_property  COEFF_INTEGER_BITS            HDL_PARAMETER           false
set_parameter_property  COEFF_INTEGER_BITS            AFFECTS_ELABORATION     true

add_parameter           COEFF_FRACTION_BITS           INTEGER                 7
set_parameter_property  COEFF_FRACTION_BITS           DISPLAY_NAME            "Coefficient fraction bits"
set_parameter_property  COEFF_FRACTION_BITS           ALLOWED_RANGES          0:24
set_parameter_property  COEFF_FRACTION_BITS           DESCRIPTION             "Number of fraction bits for each coefficient"
set_parameter_property  COEFF_FRACTION_BITS           HDL_PARAMETER           false
set_parameter_property  COEFF_FRACTION_BITS           AFFECTS_ELABORATION     true

add_parameter           MOVE_BINARY_POINT_RIGHT       INTEGER                 0
set_parameter_property  MOVE_BINARY_POINT_RIGHT       DISPLAY_NAME            "Move binary point right"
set_parameter_property  MOVE_BINARY_POINT_RIGHT       ALLOWED_RANGES          -16:16
set_parameter_property  MOVE_BINARY_POINT_RIGHT       DESCRIPTION             "Number of digits to move the binary point to the right after filtering (negative number indicates move to the left)"
set_parameter_property  MOVE_BINARY_POINT_RIGHT       HDL_PARAMETER           false
set_parameter_property  MOVE_BINARY_POINT_RIGHT       AFFECTS_ELABORATION     false

add_parameter           ROUNDING_METHOD               string                  ROUND_HALF_UP
set_parameter_property  ROUNDING_METHOD               DISPLAY_NAME            "Rounding method"
set_parameter_property  ROUNDING_METHOD               ALLOWED_RANGES          {TRUNCATE ROUND_HALF_UP ROUND_HALF_EVEN}
set_parameter_property  ROUNDING_METHOD               DESCRIPTION             "Selects the method used to round the filter output to the final precision"
set_parameter_property  ROUNDING_METHOD               HDL_PARAMETER           false
set_parameter_property  ROUNDING_METHOD               AFFECTS_ELABORATION     false

add_parameter           DO_MIRRORING                  INTEGER                 1
set_parameter_property  DO_MIRRORING                  DISPLAY_NAME            "Enable edge data mirroring"
set_parameter_property  DO_MIRRORING                  ALLOWED_RANGES          0:1
set_parameter_property  DO_MIRRORING                  DISPLAY_HINT            boolean
set_parameter_property  DO_MIRRORING                  DESCRIPTION             "Select to enable the mirroring of data in the filter at the image edges. When this feature is not enabled the edge pixel is padded to fill any empty taps"
set_parameter_property  DO_MIRRORING                  HDL_PARAMETER           false
set_parameter_property  DO_MIRRORING                  AFFECTS_ELABORATION     false

add_parameter           RUNTIME_CONTROL               INTEGER                 1
set_parameter_property  RUNTIME_CONTROL               DISPLAY_NAME            "Enable runtime control"
set_parameter_property  RUNTIME_CONTROL               ALLOWED_RANGES          0:1
set_parameter_property  RUNTIME_CONTROL               DISPLAY_HINT            boolean
set_parameter_property  RUNTIME_CONTROL               HDL_PARAMETER           false
set_parameter_property  RUNTIME_CONTROL               AFFECTS_ELABORATION     true

add_parameter           FIXED_COEFF_FILE              string                  "<enter file name (including full path)>"
set_parameter_property  FIXED_COEFF_FILE              DISPLAY_NAME            "Fixed coefficients CSV file. Unused if runtime update of coefficients is enabled"
set_parameter_property  FIXED_COEFF_FILE              DESCRIPTION             "Selects the file containing the coefficient data"
set_parameter_property  FIXED_COEFF_FILE              HDL_PARAMETER           false
set_parameter_property  FIXED_COEFF_FILE              AFFECTS_ELABORATION     false

add_parameter           ENABLE_WIDE_BLUR_SHARPEN      INTEGER                1
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      DISPLAY_NAME           "Blur search range"
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      ALLOWED_RANGES          {1 2 3}
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      DESCRIPTION            "Range of the blur edge detection (in pixels)"
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      HDL_PARAMETER           false
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      AFFECTS_ELABORATION     true

add_parameter           LOWER_BLUR_LIM                INTEGER                 0
set_parameter_property  LOWER_BLUR_LIM                DISPLAY_NAME            "Lower blur threshold"
set_parameter_property  LOWER_BLUR_LIM                DESCRIPTION             "Lower limit on the difference between two pixels to class as a blurred edge (value per color plane)"
set_parameter_property  LOWER_BLUR_LIM                HDL_PARAMETER           false
set_parameter_property  LOWER_BLUR_LIM                AFFECTS_ELABORATION     true

add_parameter           UPPER_BLUR_LIM                INTEGER                 15
set_parameter_property  UPPER_BLUR_LIM                DISPLAY_NAME            "Upper blur threshold"
set_parameter_property  UPPER_BLUR_LIM                DESCRIPTION             "Upper limit on the difference between two pixels to class as a blurred edge (value per color plane)"
set_parameter_property  UPPER_BLUR_LIM                HDL_PARAMETER           false
set_parameter_property  UPPER_BLUR_LIM                AFFECTS_ELABORATION     true

add_parameter           PIPELINE_READY                INTEGER                 0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME            "Pipeline Av-ST ready signals"
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES          0:1
set_parameter_property  PIPELINE_READY                DISPLAY_HINT            boolean
set_parameter_property  PIPELINE_READY                HDL_PARAMETER           false
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION     false

add_parameter           PRE_ALIGNED_SOP               INTEGER                 0
set_parameter_property  PRE_ALIGNED_SOP               DISPLAY_NAME            "Pre-aligned SOP"
set_parameter_property  PRE_ALIGNED_SOP               ALLOWED_RANGES          0:1
set_parameter_property  PRE_ALIGNED_SOP               DISPLAY_HINT            boolean
set_parameter_property  PRE_ALIGNED_SOP               HDL_PARAMETER           false
set_parameter_property  PRE_ALIGNED_SOP               AFFECTS_ELABORATION     false

add_av_st_event_parameters 
set_parameter_property  SRC_WIDTH                     HDL_PARAMETER           false
set_parameter_property  DST_WIDTH                     HDL_PARAMETER           false
set_parameter_property  TASK_WIDTH                    HDL_PARAMETER           false
set_parameter_property  CONTEXT_WIDTH                 HDL_PARAMETER           false

add_parameter           SOURCE_ID                     INTEGER                 0
set_parameter_property  SOURCE_ID                     DISPLAY_NAME            "Output source ID"
set_parameter_property  SOURCE_ID                     HDL_PARAMETER           false
set_parameter_property  SOURCE_ID                     AFFECTS_ELABORATION     true

add_device_family_parameters
set_parameter_property  FAMILY                        HDL_PARAMETER           false

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

proc fir_alg_core_elaboration_callback {} {

   set   alg_name                   [get_parameter_value ALGORITHM_NAME]
   set   comp                       [string compare $alg_name "STANDARD_FIR"]
   if { $comp != 0 } {
      set   edge_adapt_sharpen      1
   } else {
      set   edge_adapt_sharpen      0
   }

   set   src_id                     [get_parameter_value SOURCE_ID]
   set   src_width                  [get_parameter_value SRC_WIDTH]
   set   dst_width                  [get_parameter_value DST_WIDTH]
   set   context_width              [get_parameter_value CONTEXT_WIDTH]
   set   task_width                 [get_parameter_value TASK_WIDTH]
   set   bits_per_symbol_in         [get_parameter_value BITS_PER_SYMBOL_IN]
   set   symbols_per_pixel          [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   are_in_par                 [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pip                        [get_parameter_value PIXELS_IN_PARALLEL]
   if {$edge_adapt_sharpen > 0} {
      if {[get_parameter_value ENABLE_WIDE_BLUR_SHARPEN] < 3} {
         set   v_taps               5
      } else {
         set   v_taps               7
      }
      set   bits_per_symbol_out     [get_parameter_value BITS_PER_SYMBOL_IN]
   } else {
      set   v_taps                  [get_parameter_value V_TAPS]
      set   bits_per_symbol_out     [get_parameter_value BITS_PER_SYMBOL_OUT]
   }
   if {$are_in_par > 0} {
      set   data_width_in           [expr $bits_per_symbol_in * $symbols_per_pixel * $v_taps]
      set   data_width_out          [expr $bits_per_symbol_out * $symbols_per_pixel]
   } else {
      set   data_width_in           [expr $bits_per_symbol_in * $v_taps]
      set   data_width_out          $bits_per_symbol_out
   }
   
   add_av_st_cmd_sink_port    av_st_cmd                     1     $dst_width  $src_width  $task_width $context_width    main_clock  $src_id
   add_av_st_data_sink_port   av_st_din   $data_width_in    $pip  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
   add_av_st_resp_source_port av_st_resp                    1     $dst_width  $src_width  $task_width $context_width    main_clock  $src_id
   add_av_st_data_source_port av_st_dout  $data_width_out   $pip  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
   
   if { $edge_adapt_sharpen == 0 } {
      if { [get_parameter_value RUNTIME_CONTROL] > 0 } {
         set   coeff_signed         [get_parameter_value COEFF_SIGNED]
         set   coeff_int            [get_parameter_value COEFF_INTEGER_BITS]
         set   coeff_frac           [get_parameter_value COEFF_FRACTION_BITS]
         set   coeff_width          [expr $coeff_signed + $coeff_int + $coeff_frac]
         
         add_av_st_data_sink_port   av_st_coeff       $coeff_width   1  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
      }
   }  
   
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameter legality checks (validation callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   

proc fir_alg_core_validation_callback {} {

   set  limit    [get_parameter_value SRC_WIDTH]
   set  limit    [expr {pow(2, $limit)}]
   set  limit    [expr {$limit - 1}]
   set  value    [get_parameter_value SOURCE_ID]
   if { $value > $limit } {
      send_message Warning "Source address is outside the range supported by the specified dout source address width"
   }
   if { $value < 0 } {
      send_message Warning "Source address is outside the range supported by the specified dout source address width"
   }
   
   if { [get_parameter_value TASK_WIDTH] < 2 } {
      send_message Error "The Task ID width for the command port must be at least 2 bits"
   }
   
   if { [get_parameter_value IS_422] > 0 } {
      set num_colours    [get_parameter_value NUMBER_OF_COLOR_PLANES]
      if { $num_colours > 3 } {
         send_message Error "4:2:2 data with more than 3 colour planes per pixel is not supported"
      }
      if { $num_colours < 2 } {
         send_message Error "4:2:2 data with fewer than 2 symbols in parallel is not supported"
      }
   }
   
   if { [get_parameter_value PIXELS_IN_PARALLEL] > 1 } {
      if { [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] == 0 } {
         send_message Error "Colour planes must be transmitted in parallel to enable pixels per clock cycle > 1"
      }
   }
   
   set   alg_name                   [get_parameter_value ALGORITHM_NAME]
   set   comp                       [string compare $alg_name "STANDARD_FIR"]
   if { $comp != 0 } {
      set   edge_adapt_sharpen      1
   } else {
      set   edge_adapt_sharpen      0
   }
   
   if { $edge_adapt_sharpen > 0 } {
   
      set_parameter_property  BITS_PER_SYMBOL_OUT              ENABLED  0
      set_parameter_property  V_TAPS                           ENABLED  0
      set_parameter_property  H_TAPS                           ENABLED  0
      set_parameter_property  V_SYMMETRIC                      ENABLED  0
      set_parameter_property  H_SYMMETRIC                      ENABLED  0
      set_parameter_property  DIAG_SYMMETRIC                   ENABLED  0
      set_parameter_property  COEFF_SIGNED                     ENABLED  0
      set_parameter_property  COEFF_INTEGER_BITS               ENABLED  0
      set_parameter_property  COEFF_FRACTION_BITS              ENABLED  0
      set_parameter_property  MOVE_BINARY_POINT_RIGHT          ENABLED  0
      set_parameter_property  ROUNDING_METHOD                  ENABLED  0
      set_parameter_property  FIXED_COEFF_FILE                 ENABLED  0
      set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN         ENABLED  1
      
      if { [get_parameter_value RUNTIME_CONTROL] > 0} { 
      
         set_parameter_property  LOWER_BLUR_LIM                ENABLED  0
         set_parameter_property  UPPER_BLUR_LIM                ENABLED  0
         
      } else {
      
         set_parameter_property  LOWER_BLUR_LIM                ENABLED  1
         set_parameter_property  UPPER_BLUR_LIM                ENABLED  1
         
         set  limit    [get_parameter_value BITS_PER_SYMBOL_IN]
         set  limit    [expr {pow(2, $limit)}]
         set  limit    [expr {$limit - 1}]
         set  value    [get_parameter_value LOWER_BLUR_LIM]
         if { $value > $limit } {
            send_message Error "The lower blur limit must be within the range supported by the selected value of input bits per symbol"
         }
         if { $value < 0 } {
            send_message Error "The lower blur limit must be greater than or equal to 0"
         }
         set  value    [get_parameter_value UPPER_BLUR_LIM]
         if { $value > $limit } {
            send_message Error "The upper blur limit must be within the range supported by the selected value of input bits per symbol"
         }
         if { $value < 0 } {
            send_message Error "The upper blur limit must be greater than or equal to 0"
         }
         
      }
      
   } else {
   
      set_parameter_property  BITS_PER_SYMBOL_OUT              ENABLED  1
      set_parameter_property  V_TAPS                           ENABLED  1
      set_parameter_property  H_TAPS                           ENABLED  1
      set   v_taps      [get_parameter_value V_TAPS]
      set   v_taps_odd  [expr $v_taps % 2]
      set   h_taps      [get_parameter_value H_TAPS]
      set   h_taps_odd  [expr $h_taps % 2]
      if { $v_taps_odd > 0 } {
         set_parameter_property  V_SYMMETRIC                   ENABLED  1
         set   v_symm            [get_parameter_value V_SYMMETRIC]  
      } else {
         set_parameter_property  V_SYMMETRIC                   ENABLED  0
         set   v_symm            0
      }
      if { $h_taps_odd > 0 } {
         set_parameter_property  H_SYMMETRIC                   ENABLED  1
         set   h_symm            [get_parameter_value H_SYMMETRIC]  
      } else {
         set_parameter_property  H_SYMMETRIC                   ENABLED  0
         set   h_symm            0
      }
      if { $h_symm > 0 } { 
         if { $v_symm > 0 } { 
            if { $h_taps == $v_taps } {
               set_parameter_property  DIAG_SYMMETRIC             ENABLED  1
            } else {
               set_parameter_property  DIAG_SYMMETRIC             ENABLED  0
            }
         } else {
            set_parameter_property  DIAG_SYMMETRIC             ENABLED  0
         }
      } else {
         set_parameter_property  DIAG_SYMMETRIC                ENABLED  0
      }
      set_parameter_property  COEFF_SIGNED                     ENABLED  1
      set_parameter_property  COEFF_INTEGER_BITS               ENABLED  1
      set_parameter_property  COEFF_FRACTION_BITS              ENABLED  1
      set_parameter_property  MOVE_BINARY_POINT_RIGHT          ENABLED  1
      set_parameter_property  ROUNDING_METHOD                  ENABLED  1
      set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN         ENABLED  0
      set_parameter_property  LOWER_BLUR_LIM                   ENABLED  0
      set_parameter_property  UPPER_BLUR_LIM                   ENABLED  0
      
      set   coeff_signed   [get_parameter_value COEFF_SIGNED]
      set   coeff_int      [get_parameter_value COEFF_INTEGER_BITS]
      set   coeff_frac     [get_parameter_value COEFF_FRACTION_BITS]
      set   unsigned_width [expr $coeff_int + $coeff_frac]
      set   total_width    [expr $coeff_signed + $unsigned_width]
      if { $unsigned_width <= 0 } {
         send_message Error "There must be at least one coefficient integer or fraction bit"
      }
      if { $total_width > 32 } {
         send_message Error "The total coefficient width must not exceed 32 bits"
      }
      
      if { $coeff_signed > 0 } {
         set  min_coeff    [expr {pow(2, $unsigned_width)}]
         set  max_coeff    [expr $min_coeff - 1]
         set  min_coeff    [expr 0 - $min_coeff]
      } else {
         set  max_coeff    [expr {pow(2, $unsigned_width)}]
         set  max_coeff    [expr $max_coeff - 1]
         set  min_coeff    0
      }
      
      if { [get_parameter_value RUNTIME_CONTROL] > 0} { 
         set_parameter_property  FIXED_COEFF_FILE              ENABLED  0
      } else {
         set_parameter_property  FIXED_COEFF_FILE              ENABLED  1
         set csv_file_path [get_parameter_value FIXED_COEFF_FILE]
         if {[string compare $csv_file_path ""] == 0 || [string compare $csv_file_path "<enter file name (including full path)>"] == 0} {
             send_message ERROR "Please specify a valid CSV coefficients file (including full path)."
         } else {
             if {![file exists $csv_file_path]} {
                 send_message WARNING "${csv_file_path} could not be opened for reading. No such file."
             }
         }
      }
         
   }

}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Output file generation (generate callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   
set_module_property HELPER_JAR fir_algo_core_helper.jar

proc generate_cb {output_name} {
   set   template_file              "alt_vip_fir_alg_core.sv.terp"
   set   template                   [read [open $template_file r]]
   
   set   alg_name                   [get_parameter_value ALGORITHM_NAME]
   set   comp                       [string compare $alg_name "STANDARD_FIR"]
   if { $comp != 0 } {
      set   edge_adapt_sharpen      1
   } else {
      set   edge_adapt_sharpen      0
   }
   
   set   src_width                  [get_parameter_value SRC_WIDTH]
   set   dst_width                  [get_parameter_value DST_WIDTH]
   set   context_width              [get_parameter_value CONTEXT_WIDTH]
   set   task_width                 [get_parameter_value TASK_WIDTH]
   set   bits_per_symbol_in         [get_parameter_value BITS_PER_SYMBOL_IN]
   set   symbols_per_pixel          [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   are_in_par                 [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pip                        [get_parameter_value PIXELS_IN_PARALLEL]
   if {$pip > 1} {
      set   empty_width             [clogb2_pure $pip]
   } else {
      set   empty_width             0
   }
   if { $edge_adapt_sharpen > 0 } {
      if {[get_parameter_value ENABLE_WIDE_BLUR_SHARPEN] < 3} {
         set   v_taps               5
      } else {
         set   v_taps               7
      }
      set   bits_per_symbol_out     [get_parameter_value BITS_PER_SYMBOL_IN]
   } else {
      set   v_taps                  [get_parameter_value V_TAPS]
      set   bits_per_symbol_out     [get_parameter_value BITS_PER_SYMBOL_OUT]
   }
   if {$are_in_par > 0} {
      set   data_width_in           [expr $bits_per_symbol_in * $symbols_per_pixel * $v_taps * $pip]
      set   data_width_out          [expr $bits_per_symbol_out * $symbols_per_pixel * $pip]
   } else {
      set   data_width_in           [expr $bits_per_symbol_in * $v_taps * $pip]
      set   data_width_out          [expr $bits_per_symbol_out * $pip]
   }

    set  cmd_data_width             [expr 32 + $src_width + $dst_width + $context_width + $task_width]
    set  din_data_width             [expr $data_width_in + $src_width + $dst_width + $context_width + $task_width + 2*$empty_width]
    set  dout_data_width            [expr $data_width_out + $src_width + $dst_width + $context_width + $task_width + 2*$empty_width]
    
    if { $edge_adapt_sharpen == 0 } {
      if { [get_parameter_value RUNTIME_CONTROL] > 0 } {
         set   runtime_load         1
         set   coeff_signed         [get_parameter_value COEFF_SIGNED]
         set   coeff_int            [get_parameter_value COEFF_INTEGER_BITS]
         set   coeff_frac           [get_parameter_value COEFF_FRACTION_BITS]
         set   coeff_data_width     [expr $coeff_signed + $coeff_int + $coeff_frac + $src_width + $dst_width + $context_width + $task_width]
      } else {
         set   coeff_data_width     1
         set   runtime_load         0
      }
   } else {
      set   coeff_data_width        1
      set   runtime_load            0
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

   set raw_round_name [ get_parameter_value ROUNDING_METHOD ]
   set round_name [format "%s%s%s" "\"" $raw_round_name "\""]
   
   #Collect parameter values for Terp
   set   params(output_name)               $output_name
   set   params(pip)                       [get_parameter_value PIXELS_IN_PARALLEL]
   set   params(sop_aligned)               [get_parameter_value PRE_ALIGNED_SOP]
   set   params(num_colours)               [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   params(colours_are_in_par)        [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   params(bits_per_symbol_in)        [get_parameter_value BITS_PER_SYMBOL_IN]
   set   params(is_422)                    [get_parameter_value IS_422]
   set   params(bits_per_symbol_out)       [get_parameter_value BITS_PER_SYMBOL_OUT]
   set   params(move_binary_point_right)   [get_parameter_value MOVE_BINARY_POINT_RIGHT]
   set   params(round_name)                $round_name
   set   params(edge_adapt_sharpen)        $edge_adapt_sharpen
   set   params(do_mirroring)              [get_parameter_value DO_MIRRORING]
   set   params(wide_blur_sharpen)         [get_parameter_value ENABLE_WIDE_BLUR_SHARPEN]
   set   params(runtime_control)           [get_parameter_value RUNTIME_CONTROL]
   set   params(upper_blur_lim)            [get_parameter_value UPPER_BLUR_LIM]
   set   params(lower_blur_lim)            [get_parameter_value LOWER_BLUR_LIM]
   set   params(h_taps)                    [get_parameter_value H_TAPS]
   set   params(v_taps)                    [get_parameter_value V_TAPS]
   set   params(coeff_signed)              [get_parameter_value COEFF_SIGNED]
   set   params(coeff_int_bits)            [get_parameter_value COEFF_INTEGER_BITS]
   set   params(coeff_frac_bits)           [get_parameter_value COEFF_FRACTION_BITS]
   set   params(v_symm)                    [get_parameter_value V_SYMMETRIC]
   set   params(h_symm)                    [get_parameter_value H_SYMMETRIC]
   set   params(d_symm)                    [get_parameter_value DIAG_SYMMETRIC]
   set   params(src_width)                 [get_parameter_value SRC_WIDTH]
   set   params(dst_width)                 [get_parameter_value DST_WIDTH]
   set   params(context_width)             [get_parameter_value CONTEXT_WIDTH]
   set   params(task_width)                [get_parameter_value TASK_WIDTH]
   set   params(src_id)                    [get_parameter_value SOURCE_ID]
   set   params(cyclone_style)             $cyclone_style
   set   params(v_series_style)            $v_style
   set   params(pipeline)                  [get_parameter_value PIPELINE_READY]
   set   params(cmd_data_width)            $cmd_data_width
   set   params(din_data_width)            $din_data_width
   set   params(dout_data_width)           $dout_data_width
   set   params(coeff_data_width)          $coeff_data_width
   set   params(load_at_runtime)           $runtime_load
   
   if { $runtime_load == 0 } {
      if { $edge_adapt_sharpen == 0 } {
      
         # Call java helper to parse the coefficients from the CSV file
         set   coeff_gen_params(FIXED_COEFF_FILE)       [get_parameter_value FIXED_COEFF_FILE]
         set   coeff_gen_params(H_TAPS)                 [get_parameter_value H_TAPS]
         set   coeff_gen_params(V_TAPS)                 [get_parameter_value V_TAPS]
         set   coeff_gen_params(COEFF_SIGNED)           [get_parameter_value COEFF_SIGNED]
         set   coeff_gen_params(COEFF_INTEGER_BITS)     [get_parameter_value COEFF_INTEGER_BITS]
         set   coeff_gen_params(COEFF_FRACTION_BITS)    [get_parameter_value COEFF_FRACTION_BITS]
         set   coeff_gen_params(V_SYMMETRIC)            [get_parameter_value V_SYMMETRIC]
         set   coeff_gen_params(H_SYMMETRIC)            [get_parameter_value H_SYMMETRIC]
         set   coeff_gen_params(DIAG_SYMMETRIC)         [get_parameter_value DIAG_SYMMETRIC]
         array set derived_params  [call_helper generateCoeffs  [array get coeff_gen_params]]

         for { set i 0 } { $i < 81 } { incr i } {
            set   params(coeff_$i)            $derived_params(COEFF_$i)
         }
         
         if {[info exists derived_params(MSG_INFO)]} {
            send_message INFO $derived_params(MSG_INFO)
         }
         if {[info exists derived_params(MSG_WARNING)]} {
            send_message WARNING $derived_params(MSG_WARNING)
         }
         if {[info exists derived_params(MSG_ERROR)]} {
            send_message ERROR $derived_params(MSG_ERROR)
         }
      } else {
         for { set i 0 } { $i < 81 } { incr i } {
            set   params(coeff_$i)            0
         }
      }
   } else {
      for { set i 0 } { $i < 81 } { incr i } {
         set   params(coeff_$i)            0
      }
   }
   
   set  result                             [altera_terp $template params]
   set  filename                           ${output_name}.sv
   
   add_fileset_file $filename   SYSTEM_VERILOG TEXT  $result

}
