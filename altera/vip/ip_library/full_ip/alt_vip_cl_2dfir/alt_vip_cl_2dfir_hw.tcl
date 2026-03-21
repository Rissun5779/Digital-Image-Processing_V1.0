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
#-- _hw.tcl compose file for Component Library 2D FIR Filter                                      --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source   ../../common_tcl/alt_vip_helper_common.tcl
source   ../../common_tcl/alt_vip_files_common.tcl
source   ../../common_tcl/alt_vip_parameters_common.tcl
source   ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property  NAME           alt_vip_cl_2dfir
set_module_property  DISPLAY_NAME   "2D-FIR II (4K ready) Intel FPGA IP"
set_module_property  DESCRIPTION    "Applies a 2D FIR filter to the incoming video frames"


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
set_module_property  VALIDATION_CALLBACK  validation_cb

# Callback for the composition of this component
set_module_property  COMPOSITION_CALLBACK composition_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set x_max $vipsuite_max_width
set y_max $vipsuite_max_height

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
set_parameter_property  IS_422                        AFFECTS_ELABORATION     true

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
set_parameter_property  H_TAPS                        AFFECTS_ELABORATION     true

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
set_parameter_property  COEFF_FRACTION_BITS           DESCRIPTION             "Number of fraction bits for each vertical coefficient"
set_parameter_property  COEFF_FRACTION_BITS           HDL_PARAMETER           false
set_parameter_property  COEFF_FRACTION_BITS           AFFECTS_ELABORATION     true

add_parameter           MOVE_BINARY_POINT_RIGHT       INTEGER                 0
set_parameter_property  MOVE_BINARY_POINT_RIGHT       DISPLAY_NAME            "Move binary point right"
set_parameter_property  MOVE_BINARY_POINT_RIGHT       ALLOWED_RANGES          -16:16
set_parameter_property  MOVE_BINARY_POINT_RIGHT       DESCRIPTION             "Number of digits to move the binary point to the right after filtering (negative number indicates move to the left)"
set_parameter_property  MOVE_BINARY_POINT_RIGHT       HDL_PARAMETER           false
set_parameter_property  MOVE_BINARY_POINT_RIGHT       AFFECTS_ELABORATION     true

add_parameter           ROUNDING_METHOD               string                  ROUND_HALF_UP
set_parameter_property  ROUNDING_METHOD               DISPLAY_NAME            "Rounding method"
set_parameter_property  ROUNDING_METHOD               ALLOWED_RANGES          {TRUNCATE ROUND_HALF_UP ROUND_HALF_EVEN}
set_parameter_property  ROUNDING_METHOD               DESCRIPTION             "Selects the method used to round the filter output to the final precision"
set_parameter_property  ROUNDING_METHOD               HDL_PARAMETER           false
set_parameter_property  ROUNDING_METHOD               AFFECTS_ELABORATION     true

add_parameter           ENABLE_WIDE_BLUR_SHARPEN      INTEGER                1
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      DISPLAY_NAME           "Blur search range"
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      ALLOWED_RANGES          {1 2 3}
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      DESCRIPTION            "Range of the blur edge detection (in pixels)"
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      HDL_PARAMETER           false
set_parameter_property  ENABLE_WIDE_BLUR_SHARPEN      AFFECTS_ELABORATION     true

add_parameter           DEFAULT_UPPER_BLUR            INTEGER                 15
set_parameter_property  DEFAULT_UPPER_BLUR            DISPLAY_NAME            "Default upper blur limit (per color plane)"
set_parameter_property  DEFAULT_UPPER_BLUR            AFFECTS_ELABORATION     true
set_parameter_property  DEFAULT_UPPER_BLUR            HDL_PARAMETER           false

add_parameter           DEFAULT_LOWER_BLUR            INTEGER                 0
set_parameter_property  DEFAULT_LOWER_BLUR            DISPLAY_NAME            "Default lower blur limit (per color plane)"
set_parameter_property  DEFAULT_LOWER_BLUR            AFFECTS_ELABORATION     true
set_parameter_property  DEFAULT_LOWER_BLUR            HDL_PARAMETER           false

add_parameter           DO_MIRRORING                  INTEGER                 1
set_parameter_property  DO_MIRRORING                  DISPLAY_NAME            "Enable edge data mirroring"
set_parameter_property  DO_MIRRORING                  ALLOWED_RANGES          0:1
set_parameter_property  DO_MIRRORING                  DISPLAY_HINT            boolean
set_parameter_property  DO_MIRRORING                  DESCRIPTION             "Select to enable the mirroring of data in the filter at the image edges. When this feature is not enabled the edge pixel is padded to fill any empty taps"
set_parameter_property  DO_MIRRORING                  HDL_PARAMETER           false
set_parameter_property  DO_MIRRORING                  AFFECTS_ELABORATION     true

add_runtime_control_parameters                        1
set_parameter_property  RUNTIME_CONTROL               HDL_PARAMETER           false
set_parameter_property  LIMITED_READBACK              HDL_PARAMETER           false

add_user_packet_support_parameters                    PASSTHROUGH             0
set_parameter_property  USER_PACKET_SUPPORT           HDL_PARAMETER           false

add_max_dim_parameters  32 $x_max   32 $y_max
set_parameter_property  MAX_WIDTH                     AFFECTS_ELABORATION     true
set_parameter_property  MAX_WIDTH                     HDL_PARAMETER           false
set_parameter_property  MAX_HEIGHT                    AFFECTS_ELABORATION     true
set_parameter_property  MAX_HEIGHT                    HDL_PARAMETER           false

add_parameter           OUTPUT_GUARD_BANDS_ENABLE     INTEGER                 0
set_parameter_property  OUTPUT_GUARD_BANDS_ENABLE     DISPLAY_NAME            "Enable output guard bands"
set_parameter_property  OUTPUT_GUARD_BANDS_ENABLE     ALLOWED_RANGES          0:1
set_parameter_property  OUTPUT_GUARD_BANDS_ENABLE     DISPLAY_HINT            boolean
set_parameter_property  OUTPUT_GUARD_BANDS_ENABLE     DESCRIPTION             "Enable to limit the output values to the specified range"
set_parameter_property  OUTPUT_GUARD_BANDS_ENABLE     HDL_PARAMETER           false
set_parameter_property  OUTPUT_GUARD_BANDS_ENABLE     AFFECTS_ELABORATION     true

add_parameter           OUTPUT_GUARD_BAND_LOWER       INTEGER                 0
set_parameter_property  OUTPUT_GUARD_BAND_LOWER       DISPLAY_NAME            "Lower output guard band"
set_parameter_property  OUTPUT_GUARD_BAND_LOWER       DESCRIPTION             "Lower output guard band"
set_parameter_property  OUTPUT_GUARD_BAND_LOWER       HDL_PARAMETER           false
set_parameter_property  OUTPUT_GUARD_BAND_LOWER       AFFECTS_ELABORATION     true

add_parameter           OUTPUT_GUARD_BAND_UPPER       INTEGER                 255
set_parameter_property  OUTPUT_GUARD_BAND_UPPER       DISPLAY_NAME            "Upper output guard band"
set_parameter_property  OUTPUT_GUARD_BAND_UPPER       DESCRIPTION             "Upper output guard band"
set_parameter_property  OUTPUT_GUARD_BAND_UPPER       HDL_PARAMETER           false
set_parameter_property  OUTPUT_GUARD_BAND_UPPER       AFFECTS_ELABORATION     true

add_parameter           INPUT_GUARD_BANDS_ENABLE      INTEGER                 0
set_parameter_property  INPUT_GUARD_BANDS_ENABLE      DISPLAY_NAME            "Enable input guard bands"
set_parameter_property  INPUT_GUARD_BANDS_ENABLE      ALLOWED_RANGES          0:1
set_parameter_property  INPUT_GUARD_BANDS_ENABLE      DISPLAY_HINT            boolean
set_parameter_property  INPUT_GUARD_BANDS_ENABLE      DESCRIPTION             "Enable to limit the input values to the specified range"
set_parameter_property  INPUT_GUARD_BANDS_ENABLE      HDL_PARAMETER           false
set_parameter_property  INPUT_GUARD_BANDS_ENABLE      AFFECTS_ELABORATION     true

add_parameter           INPUT_GUARD_BAND_LOWER        INTEGER                 0
set_parameter_property  INPUT_GUARD_BAND_LOWER        DISPLAY_NAME            "Lower input guard band"
set_parameter_property  INPUT_GUARD_BAND_LOWER        DESCRIPTION             "Lower input guard band"
set_parameter_property  INPUT_GUARD_BAND_LOWER        HDL_PARAMETER           false
set_parameter_property  INPUT_GUARD_BAND_LOWER        AFFECTS_ELABORATION     true

add_parameter           INPUT_GUARD_BAND_UPPER        INTEGER                 255
set_parameter_property  INPUT_GUARD_BAND_UPPER        DISPLAY_NAME            "Upper input guard band"
set_parameter_property  INPUT_GUARD_BAND_UPPER        DESCRIPTION             "Upper input guard band"
set_parameter_property  INPUT_GUARD_BAND_UPPER        HDL_PARAMETER           false
set_parameter_property  INPUT_GUARD_BAND_UPPER        AFFECTS_ELABORATION     true

add_parameter           EXTRA_PIPELINING              INTEGER                 0
set_parameter_property  EXTRA_PIPELINING              DISPLAY_NAME            "Add extra pipelining registers"
set_parameter_property  EXTRA_PIPELINING              ALLOWED_RANGES          0:1
set_parameter_property  EXTRA_PIPELINING              DISPLAY_HINT            boolean
set_parameter_property  EXTRA_PIPELINING              DESCRIPTION             "Selecting this option adds extra pipeline stage registers to the data path"
set_parameter_property  EXTRA_PIPELINING              HDL_PARAMETER           false
set_parameter_property  EXTRA_PIPELINING              AFFECTS_ELABORATION     true

add_parameter           NO_BLANKING                   INTEGER                 0
set_parameter_property  NO_BLANKING                   DISPLAY_NAME            "Video has no blanking"
set_parameter_property  NO_BLANKING                   ALLOWED_RANGES          0:1
set_parameter_property  NO_BLANKING                   AFFECTS_ELABORATION     true
set_parameter_property  NO_BLANKING                   HDL_PARAMETER           false
set_parameter_property  NO_BLANKING                   DISPLAY_HINT            boolean

add_parameter           FIXED_COEFF_FILE              string                  "<enter file name (including full path)>"
set_parameter_property  FIXED_COEFF_FILE              DISPLAY_NAME            "Fixed coefficients file. Unused if runtime update of coefficients is enabled"
set_parameter_property  FIXED_COEFF_FILE              DESCRIPTION             "Selects the file containing the coefficient data"
set_parameter_property  FIXED_COEFF_FILE              HDL_PARAMETER           false
set_parameter_property  FIXED_COEFF_FILE              AFFECTS_ELABORATION     true

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Derived parameters                                                                           --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_device_family_parameters

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_display_item  "Video Data Format"        NUMBER_OF_COLOR_PLANES        parameter
add_display_item  "Video Data Format"        COLOR_PLANES_ARE_IN_PARALLEL  parameter
add_display_item  "Video Data Format"        PIXELS_IN_PARALLEL            parameter
add_display_item  "Video Data Format"        IS_422                        parameter
add_display_item  "Video Data Format"        MAX_WIDTH                     parameter
add_display_item  "Video Data Format"        MAX_HEIGHT                    parameter

add_display_item  "Input Settings"           BITS_PER_SYMBOL_IN            parameter
add_display_item  "Input Settings"           INPUT_GUARD_BANDS_ENABLE      parameter
add_display_item  "Input Settings"           INPUT_GUARD_BAND_LOWER        parameter
add_display_item  "Input Settings"           INPUT_GUARD_BAND_UPPER        parameter

add_display_item  "Output Settings"          BITS_PER_SYMBOL_OUT           parameter
add_display_item  "Output Settings"          OUTPUT_GUARD_BANDS_ENABLE     parameter
add_display_item  "Output Settings"          OUTPUT_GUARD_BAND_LOWER       parameter
add_display_item  "Output Settings"          OUTPUT_GUARD_BAND_UPPER       parameter

add_display_item  "Algorithm Settings"       ALGORITHM_NAME                parameter
add_display_item  "Algorithm Settings"       DO_MIRRORING                  parameter
add_display_item  "Algorithm Settings"       V_TAPS                        parameter
add_display_item  "Algorithm Settings"       H_TAPS                        parameter
add_display_item  "Algorithm Settings"       V_SYMMETRIC                   parameter
add_display_item  "Algorithm Settings"       H_SYMMETRIC                   parameter
add_display_item  "Algorithm Settings"       DIAG_SYMMETRIC                parameter

add_display_item  "Algorithm Settings"       ENABLE_WIDE_BLUR_SHARPEN      parameter
add_display_item  "Algorithm Settings"       ROUNDING_METHOD               parameter

add_display_item  "Precision Settings"       COEFF_SIGNED                  parameter
add_display_item  "Precision Settings"       COEFF_INTEGER_BITS            parameter
add_display_item  "Precision Settings"       COEFF_FRACTION_BITS           parameter
add_display_item  "Precision Settings"       MOVE_BINARY_POINT_RIGHT       parameter

add_display_item  "Runtime Settings"         RUNTIME_CONTROL               parameter
add_display_item  "Runtime Settings"         FIXED_COEFF_FILE              parameter
add_display_item  "Runtime Settings"         DEFAULT_UPPER_BLUR            parameter
add_display_item  "Runtime Settings"         DEFAULT_LOWER_BLUR            parameter

add_display_item  "Optimisation"             LIMITED_READBACK              parameter
add_display_item  "Optimisation"             USER_PACKET_SUPPORT           parameter
add_display_item  "Optimisation"             EXTRA_PIPELINING              parameter
add_display_item  "Optimisation"             NO_BLANKING                   parameter


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc validation_cb {} {

   if { [get_parameter_value RUNTIME_CONTROL] > 0} {
      set_parameter_property  LIMITED_READBACK  ENABLED  1
   } else {
      set_parameter_property  LIMITED_READBACK  ENABLED  0
   }

   if { [get_parameter_value INPUT_GUARD_BANDS_ENABLE] > 0 } {
      set_parameter_property  INPUT_GUARD_BAND_LOWER  ENABLED  1
      set_parameter_property  INPUT_GUARD_BAND_UPPER  ENABLED  1
   } else {
      set_parameter_property  INPUT_GUARD_BAND_LOWER  ENABLED  0
      set_parameter_property  INPUT_GUARD_BAND_UPPER  ENABLED  0
   }

   if { [get_parameter_value OUTPUT_GUARD_BANDS_ENABLE] > 0 } {
      set_parameter_property  OUTPUT_GUARD_BAND_LOWER    ENABLED  1
      set_parameter_property  OUTPUT_GUARD_BAND_UPPER    ENABLED  1
   } else {
      set_parameter_property  OUTPUT_GUARD_BAND_LOWER    ENABLED  0
      set_parameter_property  OUTPUT_GUARD_BAND_UPPER    ENABLED  0
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
      set_parameter_property  DEFAULT_UPPER_BLUR               ENABLED  1
      set_parameter_property  DEFAULT_LOWER_BLUR               ENABLED  1

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
               set_parameter_property  DIAG_SYMMETRIC          ENABLED  1
            } else {
               set_parameter_property  DIAG_SYMMETRIC          ENABLED  0
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
      set_parameter_property  DEFAULT_LOWER_BLUR               ENABLED  0
      set_parameter_property  DEFAULT_UPPER_BLUR               ENABLED  0

      if { [get_parameter_value RUNTIME_CONTROL] > 0} {
         set_parameter_property  FIXED_COEFF_FILE              ENABLED  0
      } else {

         if { $v_symm > 0 } {
            set   v_taps_symm    [expr $v_taps + 1]
            set   v_taps_symm    [expr $v_taps_symm / 2]
         } else {
            set   v_taps_symm    $v_taps
         }
         if { $h_symm > 0 } {
            set   h_taps_symm    [expr $h_taps + 1]
            set   h_taps_symm    [expr $h_taps_symm / 2]
         } else {
            set   h_taps_symm    $h_taps
         }
         if { $h_symm > 0 } {
            if { $v_symm > 0 } {
               if { $v_taps == $h_taps } {
                  if { [get_parameter_value DIAG_SYMMETRIC] > 0 } {
                     set   update_taps [expr $h_taps_symm - 1]
                     set   update_taps [expr $update_taps * $v_taps_symm]
                     set   update_taps [expr $update_taps / 2]
                     set   update_taps [expr $update_taps + $h_taps_symm]
                  } else {
                     set   update_taps [expr $h_taps_symm * $v_taps_symm]
                  }
               } else {
                  set   update_taps [expr $h_taps_symm * $v_taps_symm]
               }
            } else {
               set   update_taps    [expr $h_taps_symm * $v_taps_symm]
            }
         } else {
            set   update_taps       [expr $h_taps_symm * $v_taps_symm]
         }
         if { $update_taps > 81 } {
            send_message Error "With runtime control disabled the total number of post symmetry taps must not exceed 81"
         }

         set_parameter_property  FIXED_COEFF_FILE              ENABLED  1
      }

   }

}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                        --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc composition_cb {} {
   global acdsVersion
   global isVersion
   global y_max
   global x_max
   global vib_vob_removal

   set   user_mode_string     [get_parameter_value USER_PACKET_SUPPORT]
   set   comp                 [string compare $user_mode_string "PASSTHROUGH"]
   if { $comp == 0 } {
      set   user_mode         2
   } else {
      set   comp                 [string compare $user_mode_string "DISCARD"]
      if { $comp == 0 } {
         set   user_mode         1
      } else {
         set   user_mode         0
      }
   }
   set   runtime_control            [get_parameter_value RUNTIME_CONTROL]
   set   input_gb_enable            [get_parameter_value INPUT_GUARD_BANDS_ENABLE]
   set   output_gb_enable           [get_parameter_value OUTPUT_GUARD_BANDS_ENABLE]
   set   coeff_width                [expr [get_parameter_value COEFF_SIGNED] + [get_parameter_value COEFF_INTEGER_BITS] + [get_parameter_value COEFF_FRACTION_BITS]]
   set   alg_name                   [get_parameter_value ALGORITHM_NAME]
   set   comp                       [string compare $alg_name "STANDARD_FIR"]
   if { $comp != 0 } {
      set   edge_adapt_sharpen      1
      set   bps_out                 [get_parameter_value BITS_PER_SYMBOL_IN]
      set   runtime_load            0
      if {[get_parameter_value ENABLE_WIDE_BLUR_SHARPEN] < 3} {
         set   vtaps                5
      } else {
         set   vtaps                7
      }
   } else {
      set   edge_adapt_sharpen      0
      set   bps_out                 [get_parameter_value BITS_PER_SYMBOL_OUT]
      set   vtaps                   [get_parameter_value V_TAPS]
      set   runtime_load            $runtime_control
   }

   if { [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] == 0 } {
      set   symbols_in_sequence     [get_parameter_value NUMBER_OF_COLOR_PLANES]
      set   pixel_width_out         $bps_out
      set   pixel_width_in          [get_parameter_value BITS_PER_SYMBOL_IN]
   } else {
      set   symbols_in_sequence     1
      set   pixel_width_out         [expr [get_parameter_value NUMBER_OF_COLOR_PLANES] * $bps_out]
      set   pixel_width_in          [expr [get_parameter_value NUMBER_OF_COLOR_PLANES] * [get_parameter_value BITS_PER_SYMBOL_IN]]
   }

   set   v_taps_odd  [expr $vtaps % 2]
   set   htaps       [get_parameter_value H_TAPS]
   set   h_taps_odd  [expr $htaps % 2]
   if { $v_taps_odd > 0 } {
      if { [get_parameter_value V_SYMMETRIC] > 0 } {
         set   vtaps_symm     [expr $vtaps + 1]
         set   vtaps_symm     [expr $vtaps_symm / 2]
         set   v_symm         1
      } else {
         set   v_symm         0
         set   vtaps_symm        $vtaps
      }
   } else {
      set   v_symm            0
      set   vtaps_symm        $vtaps
   }
   if { $h_taps_odd > 0 } {
      if { [get_parameter_value H_SYMMETRIC] > 0 } {
         set   htaps_symm     [expr $htaps + 1]
         set   htaps_symm     [expr $htaps_symm / 2]
         set   h_symm         1
      } else {
         set   h_symm         0
         set   htaps_symm     $htaps
      }
   } else {
      set   h_symm            0
      set   htaps_symm        $htaps
   }
   if { $h_symm > 0 } {
      if { $v_symm > 0 } {
         if { $vtaps == $htaps } {
            if { [get_parameter_value DIAG_SYMMETRIC] > 0 } {
               set   update_taps [expr $htaps_symm - 1]
               set   update_taps [expr $update_taps * $vtaps_symm]
               set   update_taps [expr $update_taps / 2]
               set   update_taps [expr $update_taps + $htaps_symm]
            } else {
               set   update_taps [expr $htaps_symm * $vtaps_symm]
            }
         } else {
            set   update_taps [expr $htaps_symm * $vtaps_symm]
         }
      } else {
         set   update_taps    [expr $htaps_symm * $vtaps_symm]
      }
   } else {
      set   update_taps       [expr $htaps_symm * $vtaps_symm]
   }

   set   default_sr  [get_parameter_value ENABLE_WIDE_BLUR_SHARPEN]
   set   default_sr  [expr $default_sr * 4 + $default_sr]

   #temp hack hack hack
   set   coeff_file        [get_parameter_value FIXED_COEFF_FILE]

   # Components that always exist in all modes
   if {$vib_vob_removal == 0} {
      add_instance   video_in_resp        alt_vip_video_input_bridge_resp  $isVersion
      add_instance   video_out            alt_vip_video_output_bridge      $isVersion
   }
   add_instance   line_buffer          alt_vip_line_buffer              $isVersion
   add_instance   alg_core             alt_vip_fir_alg_core             $isVersion
   add_instance   scheduler            alt_vip_fir_scheduler            $isVersion

   add_instance   av_st_clk_bridge     altera_clock_bridge              $acdsVersion
   add_instance   av_st_reset_bridge   altera_reset_bridge              $acdsVersion

   # Top level interfaces :
   add_interface           main_clock  clock             end
   add_interface           main_reset  reset             end
   set_interface_property  main_clock  PORT_NAME_MAP     {main_clock in_clk}
   set_interface_property  main_reset  PORT_NAME_MAP     {main_reset in_reset}
   set_interface_property  main_clock  export_of         av_st_clk_bridge.in_clk
   set_interface_property  main_reset  export_of         av_st_reset_bridge.in_reset

   if {$vib_vob_removal == 0} {
      add_interface           din         avalon_streaming  sink
      add_interface           dout        avalon_streaming  source
      set_interface_property  din         export_of         video_in_resp.av_st_vid_din
      set_interface_property  dout        export_of         video_out.av_st_vid_dout
   } else {
      add_interface           din_data    avalon_streaming  sink
      add_interface           din_aux     avalon_streaming  sink
      add_interface           dout_data   avalon_streaming  source
      add_interface           dout_aux    avalon_streaming  source
      set_interface_property  din_aux     export_of         scheduler.av_st_resp_vib
      set_interface_property  dout_aux    export_of         scheduler.av_st_cmd_vob
   }

   #parameters for the components that exist in all modes
   if {$vib_vob_removal == 0} {
      set_instance_parameter_value  video_in_resp     VIB_MODE                      FULL
      set_instance_parameter_value  video_in_resp     READY_LATENCY_1               1
      set_instance_parameter_value  video_in_resp     MULTI_CONTEXT_SUPPORT         0
      set_instance_parameter_value  video_in_resp     PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]
      set_instance_parameter_value  video_in_resp     BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL_IN]
      set_instance_parameter_value  video_in_resp     NUMBER_OF_COLOR_PLANES        [get_parameter_value NUMBER_OF_COLOR_PLANES]
      set_instance_parameter_value  video_in_resp     COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  video_in_resp     DEFAULT_LINE_LENGTH           [get_parameter_value MAX_WIDTH]
      set_instance_parameter_value  video_in_resp     PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
      set_instance_parameter_value  video_in_resp     VIDEO_PROTOCOL_NO             1
      set_instance_parameter_value  video_in_resp     MAX_WIDTH                     [get_parameter_value MAX_WIDTH]
      set_instance_parameter_value  video_in_resp     MAX_HEIGHT                    [get_parameter_value MAX_HEIGHT]
      set_instance_parameter_value  video_in_resp     ENABLE_RESOLUTION_CHECK       1
      set_instance_parameter_value  video_in_resp     SRC_WIDTH                     8
      set_instance_parameter_value  video_in_resp     DST_WIDTH                     8
      set_instance_parameter_value  video_in_resp     CONTEXT_WIDTH                 8
      set_instance_parameter_value  video_in_resp     TASK_WIDTH                    8
      set_instance_parameter_value  video_in_resp     RESP_SRC_ADDRESS              0
      set_instance_parameter_value  video_in_resp     RESP_DST_ADDRESS              0
      set_instance_parameter_value  video_in_resp     DATA_SRC_ADDRESS              0

      set_instance_parameter_value  video_out         BITS_PER_SYMBOL               $bps_out
      set_instance_parameter_value  video_out         NUMBER_OF_COLOR_PLANES        [get_parameter_value NUMBER_OF_COLOR_PLANES]
      set_instance_parameter_value  video_out         COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  video_out         PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
      set_instance_parameter_value  video_out         VIDEO_PROTOCOL_NO             1
      set_instance_parameter_value  video_out         READY_LATENCY_1               1
      set_instance_parameter_value  video_out         MULTI_CONTEXT_SUPPORT         0
      set_instance_parameter_value  video_out         SOP_PRE_ALIGNED               1
      set_instance_parameter_value  video_out         NO_CONCATENATION              0
      set_instance_parameter_value  video_out         LOW_LATENCY_COMMAND_MODE      0
      set_instance_parameter_value  video_out         SRC_WIDTH                     8
      set_instance_parameter_value  video_out         DST_WIDTH                     8
      set_instance_parameter_value  video_out         CONTEXT_WIDTH                 8
      set_instance_parameter_value  video_out         TASK_WIDTH                    8
      set_instance_parameter_value  video_out         PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]
   }

   set_instance_parameter_value  line_buffer       PIXEL_WIDTH                   $pixel_width_in
   set_instance_parameter_value  line_buffer       PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
   set_instance_parameter_value  line_buffer       SYMBOLS_IN_SEQ                $symbols_in_sequence
   set_instance_parameter_value  line_buffer       KERNEL_SIZE_0                 $vtaps
   set_instance_parameter_value  line_buffer       KERNEL_CENTER_0               [expr int(floor(($vtaps-1) / 2))]
   set_instance_parameter_value  line_buffer       MAX_LINE_LENGTH               [get_parameter_value MAX_WIDTH]
   set_instance_parameter_value  line_buffer       CONVERT_TO_1_PIP              0
   set_instance_parameter_value  line_buffer       OUTPUT_PORTS                  1
   set_instance_parameter_value  line_buffer       MODE                          LOCKED
   set_instance_parameter_value  line_buffer       OUTPUT_MUX_SEL                NEW
   set_instance_parameter_value  line_buffer       ENABLE_RECEIVE_ONLY_CMD       0
   set_instance_parameter_value  line_buffer       TRACK_LINE_LENGTH             0
   set_instance_parameter_value  line_buffer       FIFO_SIZE                     4
   set_instance_parameter_value  line_buffer       SRC_WIDTH                     8
   set_instance_parameter_value  line_buffer       DST_WIDTH                     8
   set_instance_parameter_value  line_buffer       CONTEXT_WIDTH                 8
   set_instance_parameter_value  line_buffer       TASK_WIDTH                    8
   set_instance_parameter_value  line_buffer       SOURCE_ADDRESS                0
   if {[get_parameter_value EXTRA_PIPELINING] > 0} {
      set_instance_parameter_value  line_buffer    OUTPUT_OPTION           PIPELINED
   } else {
      set_instance_parameter_value  line_buffer    OUTPUT_OPTION           UNPIPELINED
   }

   set_instance_parameter_value  alg_core          NUMBER_OF_COLOR_PLANES        [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set_instance_parameter_value  alg_core          COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set_instance_parameter_value  alg_core          PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
   set_instance_parameter_value  alg_core          BITS_PER_SYMBOL_IN            [get_parameter_value BITS_PER_SYMBOL_IN]
   set_instance_parameter_value  alg_core          BITS_PER_SYMBOL_OUT           [get_parameter_value BITS_PER_SYMBOL_OUT]
   set_instance_parameter_value  alg_core          IS_422                        [get_parameter_value IS_422]
   set_instance_parameter_value  alg_core          ALGORITHM_NAME                [get_parameter_value ALGORITHM_NAME]
   set_instance_parameter_value  alg_core          DO_MIRRORING                  [get_parameter_value DO_MIRRORING]
   set_instance_parameter_value  alg_core          V_TAPS                        [get_parameter_value V_TAPS]
   set_instance_parameter_value  alg_core          H_TAPS                        [get_parameter_value H_TAPS]
   set_instance_parameter_value  alg_core          V_SYMMETRIC                   [get_parameter_value V_SYMMETRIC]
   set_instance_parameter_value  alg_core          H_SYMMETRIC                   [get_parameter_value H_SYMMETRIC]
   set_instance_parameter_value  alg_core          DIAG_SYMMETRIC                [get_parameter_value DIAG_SYMMETRIC]
   set_instance_parameter_value  alg_core          COEFF_SIGNED                  [get_parameter_value COEFF_SIGNED]
   set_instance_parameter_value  alg_core          COEFF_INTEGER_BITS            [get_parameter_value COEFF_INTEGER_BITS]
   set_instance_parameter_value  alg_core          COEFF_FRACTION_BITS           [get_parameter_value COEFF_FRACTION_BITS]
   set_instance_parameter_value  alg_core          MOVE_BINARY_POINT_RIGHT       [get_parameter_value MOVE_BINARY_POINT_RIGHT]
   set_instance_parameter_value  alg_core          ROUNDING_METHOD               [get_parameter_value ROUNDING_METHOD]
   set_instance_parameter_value  alg_core          RUNTIME_CONTROL               [get_parameter_value RUNTIME_CONTROL]
   set_instance_parameter_value  alg_core          ENABLE_WIDE_BLUR_SHARPEN      [get_parameter_value ENABLE_WIDE_BLUR_SHARPEN]
   set_instance_parameter_value  alg_core          LOWER_BLUR_LIM                [get_parameter_value DEFAULT_LOWER_BLUR]
   set_instance_parameter_value  alg_core          UPPER_BLUR_LIM                [get_parameter_value DEFAULT_UPPER_BLUR]
   set_instance_parameter_value  alg_core          FIXED_COEFF_FILE              $coeff_file
   set_instance_parameter_value  alg_core          PRE_ALIGNED_SOP               1
   set_instance_parameter_value  alg_core          SRC_WIDTH                     8
   set_instance_parameter_value  alg_core          DST_WIDTH                     8
   set_instance_parameter_value  alg_core          CONTEXT_WIDTH                 8
   set_instance_parameter_value  alg_core          TASK_WIDTH                    8
   set_instance_parameter_value  alg_core          SOURCE_ID                     0
   set_instance_parameter_value  alg_core          PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]

   set_instance_parameter_value  scheduler         MAX_WIDTH                     [get_parameter_value MAX_WIDTH]
   set_instance_parameter_value  scheduler         MAX_HEIGHT                    [get_parameter_value MAX_HEIGHT]
   set_instance_parameter_value  scheduler         EDGE_ADAPTIVE_SHARPEN         $edge_adapt_sharpen
   set_instance_parameter_value  scheduler         BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL_IN]
   set_instance_parameter_value  scheduler         DEFAULT_SEARCH_RANGE          $default_sr
   set_instance_parameter_value  scheduler         DEFAULT_LOWER_BLUR            [get_parameter_value DEFAULT_LOWER_BLUR]
   set_instance_parameter_value  scheduler         DEFAULT_UPPER_BLUR            [get_parameter_value DEFAULT_UPPER_BLUR]
   set_instance_parameter_value  scheduler         V_TAPS                        $vtaps
   set_instance_parameter_value  scheduler         UPDATE_TAPS                   $update_taps
   set_instance_parameter_value  scheduler         COEFF_WIDTH                   $coeff_width
   set_instance_parameter_value  scheduler         NO_BLANKING                   [get_parameter_value NO_BLANKING]
   set_instance_parameter_value  scheduler         PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]
   set_instance_parameter_value  scheduler         RUNTIME_CONTROL               [get_parameter_value RUNTIME_CONTROL]
   set_instance_parameter_value  scheduler         LIMITED_READBACK              [get_parameter_value LIMITED_READBACK]
   set_instance_parameter_value  scheduler         USER_PACKET_SUPPORT           [get_parameter_value USER_PACKET_SUPPORT]


   #connections that exist in all modes
   add_connection    av_st_clk_bridge.out_clk      av_st_reset_bridge.clk
   add_connection    av_st_clk_bridge.out_clk      line_buffer.main_clock
   add_connection    av_st_clk_bridge.out_clk      alg_core.main_clock
   add_connection    av_st_clk_bridge.out_clk      scheduler.main_clock

   add_connection    av_st_reset_bridge.out_reset  line_buffer.main_reset
   add_connection    av_st_reset_bridge.out_reset  alg_core.main_reset
   add_connection    av_st_reset_bridge.out_reset  scheduler.main_reset

   add_connection    scheduler.av_st_cmd_lb        line_buffer.av_st_cmd
   add_connection    scheduler.av_st_cmd_ac        alg_core.av_st_cmd
   add_connection    alg_core.av_st_resp           scheduler.av_st_resp_ac

   add_connection    line_buffer.av_st_dout_0      alg_core.av_st_din

   if {$vib_vob_removal == 0} {
      add_connection    av_st_clk_bridge.out_clk      video_in_resp.main_clock
      add_connection    av_st_reset_bridge.out_reset  video_in_resp.main_reset
      add_connection    av_st_clk_bridge.out_clk      video_out.main_clock
      add_connection    av_st_reset_bridge.out_reset  video_out.main_reset

      add_connection    scheduler.av_st_cmd_vob       video_out.av_st_cmd
      add_connection    video_in_resp.av_st_resp      scheduler.av_st_resp_vib
   }

   if { $input_gb_enable > 0 } {
      add_instance   in_gb          alt_vip_guard_bands_alg_core     $isVersion

      set_instance_parameter_value  in_gb          BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL_IN]
      set_instance_parameter_value  in_gb          NUMBER_OF_COLOR_PLANES        [get_parameter_value NUMBER_OF_COLOR_PLANES]
      set_instance_parameter_value  in_gb          COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  in_gb          PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
      set_instance_parameter_value  in_gb          IS_422                        [get_parameter_value IS_422]
      set_instance_parameter_value  in_gb          ENABLE_CMD_PORT               0
      set_instance_parameter_value  in_gb          OUTPUT_GUARD_BAND_LOWER_0     [get_parameter_value INPUT_GUARD_BAND_LOWER]
      set_instance_parameter_value  in_gb          OUTPUT_GUARD_BAND_UPPER_0     [get_parameter_value INPUT_GUARD_BAND_UPPER]
      set_instance_parameter_value  in_gb          OUTPUT_GUARD_BAND_LOWER_1     [get_parameter_value INPUT_GUARD_BAND_LOWER]
      set_instance_parameter_value  in_gb          OUTPUT_GUARD_BAND_UPPER_1     [get_parameter_value INPUT_GUARD_BAND_UPPER]
      set_instance_parameter_value  in_gb          OUTPUT_GUARD_BAND_LOWER_2     [get_parameter_value INPUT_GUARD_BAND_LOWER]
      set_instance_parameter_value  in_gb          OUTPUT_GUARD_BAND_UPPER_2     [get_parameter_value INPUT_GUARD_BAND_UPPER]
      set_instance_parameter_value  in_gb          OUTPUT_GUARD_BAND_LOWER_3     [get_parameter_value INPUT_GUARD_BAND_LOWER]
      set_instance_parameter_value  in_gb          OUTPUT_GUARD_BAND_UPPER_3     [get_parameter_value INPUT_GUARD_BAND_UPPER]
      set_instance_parameter_value  in_gb          PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]
      set_instance_parameter_value  in_gb          SOURCE_ID                     0
      set_instance_parameter_value  in_gb          SRC_WIDTH                     8
      set_instance_parameter_value  in_gb          DST_WIDTH                     8
      set_instance_parameter_value  in_gb          CONTEXT_WIDTH                 8
      set_instance_parameter_value  in_gb          TASK_WIDTH                    8
      set_instance_parameter_value  in_gb          SIGNED_INPUT                  0
      set_instance_parameter_value  in_gb          SIGNED_OUTPUT                 0

      add_connection    av_st_clk_bridge.out_clk      in_gb.main_clock
      add_connection    av_st_reset_bridge.out_reset  in_gb.main_reset
   }

   if { $output_gb_enable > 0 } {
      add_instance   out_gb         alt_vip_guard_bands_alg_core     $isVersion

      set_instance_parameter_value  out_gb         BITS_PER_SYMBOL               $bps_out
      set_instance_parameter_value  out_gb         NUMBER_OF_COLOR_PLANES        [get_parameter_value NUMBER_OF_COLOR_PLANES]
      set_instance_parameter_value  out_gb         COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  out_gb         PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
      set_instance_parameter_value  out_gb         IS_422                        [get_parameter_value IS_422]
      set_instance_parameter_value  out_gb         ENABLE_CMD_PORT               0
      set_instance_parameter_value  out_gb         OUTPUT_GUARD_BAND_LOWER_0     [get_parameter_value OUTPUT_GUARD_BAND_LOWER]
      set_instance_parameter_value  out_gb         OUTPUT_GUARD_BAND_UPPER_0     [get_parameter_value OUTPUT_GUARD_BAND_UPPER]
      set_instance_parameter_value  out_gb         OUTPUT_GUARD_BAND_LOWER_1     [get_parameter_value OUTPUT_GUARD_BAND_LOWER]
      set_instance_parameter_value  out_gb         OUTPUT_GUARD_BAND_UPPER_1     [get_parameter_value OUTPUT_GUARD_BAND_UPPER]
      set_instance_parameter_value  out_gb         OUTPUT_GUARD_BAND_LOWER_2     [get_parameter_value OUTPUT_GUARD_BAND_LOWER]
      set_instance_parameter_value  out_gb         OUTPUT_GUARD_BAND_UPPER_2     [get_parameter_value OUTPUT_GUARD_BAND_UPPER]
      set_instance_parameter_value  out_gb         OUTPUT_GUARD_BAND_LOWER_3     [get_parameter_value OUTPUT_GUARD_BAND_LOWER]
      set_instance_parameter_value  out_gb         OUTPUT_GUARD_BAND_UPPER_3     [get_parameter_value OUTPUT_GUARD_BAND_UPPER]
      set_instance_parameter_value  out_gb         PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]
      set_instance_parameter_value  out_gb         SOURCE_ID                     0
      set_instance_parameter_value  out_gb         SRC_WIDTH                     8
      set_instance_parameter_value  out_gb         DST_WIDTH                     8
      set_instance_parameter_value  out_gb         CONTEXT_WIDTH                 8
      set_instance_parameter_value  out_gb         TASK_WIDTH                    8
      set_instance_parameter_value  out_gb         SIGNED_INPUT                  0
      set_instance_parameter_value  out_gb         SIGNED_OUTPUT                 0

      add_connection    av_st_clk_bridge.out_clk      out_gb.main_clock
      add_connection    av_st_reset_bridge.out_reset  out_gb.main_reset

   }

   #adding the command half of the VIB if we need to discard or route user packets
   if { $user_mode > 0 } {

      add_instance   video_in_cmd      alt_vip_video_input_bridge_cmd      $isVersion

      set_instance_parameter_value  video_in_cmd   BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL_IN]
      set_instance_parameter_value  video_in_cmd   NUMBER_OF_COLOR_PLANES        [get_parameter_value NUMBER_OF_COLOR_PLANES]
      set_instance_parameter_value  video_in_cmd   COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  video_in_cmd   PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
      set_instance_parameter_value  video_in_cmd   PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]
      set_instance_parameter_value  video_in_cmd   DATA_SRC_ADDRESS              0
      set_instance_parameter_value  video_in_cmd   SRC_WIDTH                     8
      set_instance_parameter_value  video_in_cmd   DST_WIDTH                     8
      set_instance_parameter_value  video_in_cmd   CONTEXT_WIDTH                 8
      set_instance_parameter_value  video_in_cmd   TASK_WIDTH                    8

      add_connection    av_st_clk_bridge.out_clk      video_in_cmd.main_clock
      add_connection    av_st_reset_bridge.out_reset  video_in_cmd.main_reset

      if {$vib_vob_removal == 0} {
         add_connection    video_in_resp.av_st_dout      video_in_cmd.av_st_din
      } else {
         set_interface_property  din_data    export_of   video_in_cmd.av_st_din
      }

      add_connection    scheduler.av_st_cmd_vib       video_in_cmd.av_st_cmd

      if { $user_mode > 1 } {

         add_instance   input_demux    alt_vip_packet_demux       $isVersion
         add_instance   user_bps_conv  alt_vip_bps_converter      $isVersion
         add_instance   output_mux     alt_vip_packet_mux         $isVersion

         set_instance_parameter_value  input_demux    CMD_RESP_INTERFACE         0
         set_instance_parameter_value  input_demux    DATA_WIDTH                 $pixel_width_in
         set_instance_parameter_value  input_demux    PIXELS_IN_PARALLEL         [get_parameter_value PIXELS_IN_PARALLEL]
         set_instance_parameter_value  input_demux    NUM_OUTPUTS                2
         set_instance_parameter_value  input_demux    CLIP_ADDRESS_BITS          0
         set_instance_parameter_value  input_demux    REGISTER_OUTPUT            1
         set_instance_parameter_value  input_demux    PIPELINE_READY             [get_parameter_value EXTRA_PIPELINING]
         set_instance_parameter_value  input_demux    SRC_WIDTH                  8
         set_instance_parameter_value  input_demux    DST_WIDTH                  8
         set_instance_parameter_value  input_demux    CONTEXT_WIDTH              8
         set_instance_parameter_value  input_demux    TASK_WIDTH                 8
         set_instance_parameter_value  input_demux    USER_WIDTH                 0

         set_instance_parameter_value  user_bps_conv  INPUT_BITS_PER_SYMBOL      [get_parameter_value BITS_PER_SYMBOL_IN]
         set_instance_parameter_value  user_bps_conv  OUTPUT_BITS_PER_SYMBOL     $bps_out
         set_instance_parameter_value  user_bps_conv  NUMBER_OF_COLOR_PLANES     [get_parameter_value NUMBER_OF_COLOR_PLANES]
         set_instance_parameter_value  user_bps_conv  COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
         set_instance_parameter_value  user_bps_conv  PIXELS_IN_PARALLEL         [get_parameter_value PIXELS_IN_PARALLEL]
         set_instance_parameter_value  user_bps_conv  CONVERSION_MODE            "LSB"
         set_instance_parameter_value  user_bps_conv  SRC_WIDTH                  8
         set_instance_parameter_value  user_bps_conv  DST_WIDTH                  8
         set_instance_parameter_value  user_bps_conv  CONTEXT_WIDTH              8
         set_instance_parameter_value  user_bps_conv  TASK_WIDTH                 8

         set_instance_parameter_value  output_mux     CMD_RESP_INTERFACE         0
         set_instance_parameter_value  output_mux     DATA_WIDTH                 $pixel_width_out
         set_instance_parameter_value  output_mux     PIXELS_IN_PARALLEL         [get_parameter_value PIXELS_IN_PARALLEL]
         set_instance_parameter_value  output_mux     NUM_INPUTS                 2
         set_instance_parameter_value  output_mux     REGISTER_OUTPUT            1
         set_instance_parameter_value  output_mux     PIPELINE_READY             [get_parameter_value EXTRA_PIPELINING]
         set_instance_parameter_value  output_mux     SRC_WIDTH                  8
         set_instance_parameter_value  output_mux     DST_WIDTH                  8
         set_instance_parameter_value  output_mux     CONTEXT_WIDTH              8
         set_instance_parameter_value  output_mux     TASK_WIDTH                 8
         set_instance_parameter_value  output_mux     USER_WIDTH                 0

         add_connection    av_st_clk_bridge.out_clk      input_demux.main_clock
         add_connection    av_st_clk_bridge.out_clk      output_mux.main_clock
         add_connection    av_st_clk_bridge.out_clk      user_bps_conv.main_clock

         add_connection    av_st_reset_bridge.out_reset  input_demux.main_reset
         add_connection    av_st_reset_bridge.out_reset  output_mux.main_reset
         add_connection    av_st_reset_bridge.out_reset  user_bps_conv.main_reset

         add_connection    video_in_cmd.av_st_dout       input_demux.av_st_din
         if { $input_gb_enable > 0 } {
            add_connection    input_demux.av_st_dout_0   in_gb.av_st_din
            add_connection    in_gb.av_st_dout           line_buffer.av_st_din
         } else {
            add_connection    input_demux.av_st_dout_0   line_buffer.av_st_din
         }
         if { $output_gb_enable > 0 } {
            add_connection    alg_core.av_st_dout        out_gb.av_st_din
            add_connection    out_gb.av_st_dout          output_mux.av_st_din_0
         } else {
            add_connection    alg_core.av_st_dout        output_mux.av_st_din_0
         }
         add_connection    input_demux.av_st_dout_1      user_bps_conv.av_st_din
         add_connection    user_bps_conv.av_st_dout      output_mux.av_st_din_1

         if {$vib_vob_removal == 0} {
            add_connection    output_mux.av_st_dout      video_out.av_st_din
         } else {
            set_interface_property  dout_data            export_of   output_mux.av_st_dout
         }

         add_connection    scheduler.av_st_cmd_mux       output_mux.av_st_cmd

      } else {

         if { $input_gb_enable > 0 } {
            add_connection    video_in_cmd.av_st_dout    in_gb.av_st_din
            add_connection    in_gb.av_st_dout           line_buffer.av_st_din
         } else {
            add_connection    video_in_cmd.av_st_dout    line_buffer.av_st_din
         }
         if { $output_gb_enable > 0 } {
            add_connection    alg_core.av_st_dout        out_gb.av_st_din
            if {$vib_vob_removal == 0} {
               add_connection    out_gb.av_st_dout       video_out.av_st_din
            } else {
               set_interface_property  dout_data         export_of   out_gb.av_st_dout
            }
         } else {
            if {$vib_vob_removal == 0} {
               add_connection    alg_core.av_st_dout     video_out.av_st_din
            } else {
               set_interface_property  dout_data         export_of   alg_core.av_st_dout
            }
         }

      }

   } else {

      if { $input_gb_enable > 0 } {
         if {$vib_vob_removal == 0} {
            add_connection    video_in_resp.av_st_dout      in_gb.av_st_din
         } else {
            set_interface_property  din_data    export_of   in_gb.av_st_din
         }
         add_connection       in_gb.av_st_dout              line_buffer.av_st_din
      } else {
         if {$vib_vob_removal == 0} {
            add_connection    video_in_resp.av_st_dout      line_buffer.av_st_din
         } else {
            set_interface_property  din_data    export_of   line_buffer.av_st_din
         }
      }
      if { $output_gb_enable > 0 } {
         add_connection    alg_core.av_st_dout              out_gb.av_st_din
         if {$vib_vob_removal == 0} {
            add_connection    out_gb.av_st_dout             video_out.av_st_din
         } else {
            set_interface_property  dout_data    export_of   out_gb.av_st_dout
         }
      } else {
         if {$vib_vob_removal == 0} {
            add_connection    alg_core.av_st_dout           video_out.av_st_din
         } else {
            set_interface_property  dout_data    export_of   alg_core.av_st_dout
         }
      }

   }

   # Optional control slave interfaces and top-level connections
   if { $runtime_control > 0 } {
      add_interface   control    avalon   slave
      set_interface_property   control   export_of   scheduler.av_mm_control

      if { $runtime_load > 0} {
         add_connection    scheduler.av_st_coeff      alg_core.av_st_coeff
      }
   }
}

