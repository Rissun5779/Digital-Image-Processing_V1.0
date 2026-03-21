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
#-- _hw.tcl compose file for the Component Library Scaler (Scaler 2)                              --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property  NAME                 alt_vip_cl_scl
set_module_property  DISPLAY_NAME         "Scaler II (4K Ready) Intel FPGA IP"
set_module_property  DESCRIPTION          "The Scaler II up-scales or down-scales video fields using nearest neighbour, biliner, bicubic, polyphase or edge adaptive algorithms."

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set_module_property  VALIDATION_CALLBACK      scl_validation_callback
set_module_property  COMPOSITION_CALLBACK     scl_composition_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set   x_min 32
set   y_min 32
set   x_max $vipsuite_max_width
set   y_max $vipsuite_max_height

add_parameter           SYMBOLS_IN_SEQ       INTEGER              1
set_parameter_property  SYMBOLS_IN_SEQ       DISPLAY_NAME         "Symbols in sequence"
set_parameter_property  SYMBOLS_IN_SEQ       ALLOWED_RANGES       1:4
set_parameter_property  SYMBOLS_IN_SEQ       DESCRIPTION          "Number of Avalon-ST symbols (colour planes) in sequence"
set_parameter_property  SYMBOLS_IN_SEQ       HDL_PARAMETER        false
set_parameter_property  SYMBOLS_IN_SEQ       AFFECTS_ELABORATION  true

add_parameter           SYMBOLS_IN_PAR       INTEGER              2
set_parameter_property  SYMBOLS_IN_PAR       DISPLAY_NAME         "Symbols in parallel"
set_parameter_property  SYMBOLS_IN_PAR       ALLOWED_RANGES       1:4
set_parameter_property  SYMBOLS_IN_PAR       DESCRIPTION          "Number of Avalon-ST symbols (colour planes) in parallel"
set_parameter_property  SYMBOLS_IN_PAR       HDL_PARAMETER        false
set_parameter_property  SYMBOLS_IN_PAR       AFFECTS_ELABORATION  true

add_parameter           BITS_PER_SYMBOL      INTEGER              10
set_parameter_property  BITS_PER_SYMBOL      DISPLAY_NAME         "Bits per symbol"
set_parameter_property  BITS_PER_SYMBOL      ALLOWED_RANGES       4:20
set_parameter_property  BITS_PER_SYMBOL      DESCRIPTION          "The number of bits per Avalon-ST symbol (colour plane)"
set_parameter_property  BITS_PER_SYMBOL      HDL_PARAMETER        false
set_parameter_property  BITS_PER_SYMBOL      AFFECTS_ELABORATION  true

add_parameter           PIXELS_IN_PARALLEL   INTEGER              1
set_parameter_property  PIXELS_IN_PARALLEL   DISPLAY_NAME         PIXELS_IN_PARALLEL
set_parameter_property  PIXELS_IN_PARALLEL   ALLOWED_RANGES       {1 2 4 8}
set_parameter_property  PIXELS_IN_PARALLEL   HDL_PARAMETER        false
set_parameter_property  PIXELS_IN_PARALLEL   DISPLAY_NAME         "Number of pixels in parallel"
set_parameter_property  PIXELS_IN_PARALLEL   AFFECTS_ELABORATION  true

add_parameter           EXTRA_PIPELINING     INTEGER              0
set_parameter_property  EXTRA_PIPELINING     DISPLAY_NAME         "Add extra pipelining registers"
set_parameter_property  EXTRA_PIPELINING     ALLOWED_RANGES       0:1
set_parameter_property  EXTRA_PIPELINING     DISPLAY_HINT         boolean
set_parameter_property  EXTRA_PIPELINING     DESCRIPTION          "Selecting this option adds extra pipeline stage registers to the data path"
set_parameter_property  EXTRA_PIPELINING     HDL_PARAMETER        false
set_parameter_property  EXTRA_PIPELINING     AFFECTS_ELABORATION  true

add_parameter           IS_422               INTEGER              1
set_parameter_property  IS_422               DISPLAY_NAME         "4:2:2 video data"
set_parameter_property  IS_422               ALLOWED_RANGES       0:1
set_parameter_property  IS_422               DISPLAY_HINT         boolean
set_parameter_property  IS_422               DESCRIPTION          "Select for 4:2:2 video input/output"
set_parameter_property  IS_422               HDL_PARAMETER        false
set_parameter_property  IS_422               AFFECTS_ELABORATION  true

add_parameter           NO_BLANKING          INTEGER              0
set_parameter_property  NO_BLANKING          DISPLAY_NAME         "No blanking in video"
set_parameter_property  NO_BLANKING          ALLOWED_RANGES       0:1
set_parameter_property  NO_BLANKING          DISPLAY_HINT         boolean
set_parameter_property  NO_BLANKING          DESCRIPTION          "Optimises the scaler's line buffer flush/fill cycle for input video with no blanking (i.e. no significant gaps between sucessive frame packets)"
set_parameter_property  NO_BLANKING          HDL_PARAMETER        false
set_parameter_property  NO_BLANKING          AFFECTS_ELABORATION  true

add_max_in_dim_parameters  $x_min   $x_max   $y_min   $y_max
set_parameter_property  MAX_IN_WIDTH         DEFAULT_VALUE        1920
set_parameter_property  MAX_IN_WIDTH         AFFECTS_ELABORATION  true
set_parameter_property  MAX_IN_WIDTH         HDL_PARAMETER        false
set_parameter_property  MAX_IN_HEIGHT        DEFAULT_VALUE        1080
set_parameter_property  MAX_IN_HEIGHT        AFFECTS_ELABORATION  true
set_parameter_property  MAX_IN_HEIGHT        HDL_PARAMETER        false

add_max_out_dim_parameters  $x_min   $x_max   $y_min   $y_max
set_parameter_property  MAX_OUT_WIDTH        DEFAULT_VALUE        1920
set_parameter_property  MAX_OUT_WIDTH        AFFECTS_ELABORATION  true
set_parameter_property  MAX_OUT_WIDTH        HDL_PARAMETER        false
set_parameter_property  MAX_OUT_HEIGHT       DEFAULT_VALUE        1080
set_parameter_property  MAX_OUT_HEIGHT       AFFECTS_ELABORATION  true
set_parameter_property  MAX_OUT_HEIGHT       HDL_PARAMETER        false

add_parameter           RUNTIME_CONTROL      INTEGER              1
set_parameter_property  RUNTIME_CONTROL      DISPLAY_NAME         "Enable runtime control of output frame size and edge/blur thresholds"
set_parameter_property  RUNTIME_CONTROL      ALLOWED_RANGES       0:1
set_parameter_property  RUNTIME_CONTROL      DISPLAY_HINT         boolean
set_parameter_property  RUNTIME_CONTROL      DESCRIPTION          "Allows the output frame dimensions and edge thresholds to be altered through the Control (Avalon-MM Slave) port. If this option is not selected the output dimensions are fixed to the maximum values and edge value is fixed to its default value"
set_parameter_property  RUNTIME_CONTROL      HDL_PARAMETER        false
set_parameter_property  RUNTIME_CONTROL      AFFECTS_ELABORATION  true

add_parameter           ALGORITHM_NAME       STRING               POLYPHASE
set_parameter_property  ALGORITHM_NAME       DISPLAY_NAME         "Scaling algorithm"
set_parameter_property  ALGORITHM_NAME       ALLOWED_RANGES       {NEAREST_NEIGHBOUR BILINEAR BICUBIC POLYPHASE EDGE_ADAPT}
set_parameter_property  ALGORITHM_NAME       DISPLAY_HINT         ""
set_parameter_property  ALGORITHM_NAME       DESCRIPTION          "Selects the scaling algorithm used"
set_parameter_property  ALGORITHM_NAME       HDL_PARAMETER        false
set_parameter_property  ALGORITHM_NAME       AFFECTS_ELABORATION  true

add_parameter           DEFAULT_EDGE_THRESH  INTEGER              7
set_parameter_property  DEFAULT_EDGE_THRESH  DISPLAY_NAME         "Default edge threshold"
set_parameter_property  DEFAULT_EDGE_THRESH  DESCRIPTION          "Default edge threshold when comparing two pixels (per color plane) for edge adaptive scaling. Can be updated at runtime if runtime control is enabled"
set_parameter_property  DEFAULT_EDGE_THRESH  AFFECTS_ELABORATION  true
set_parameter_property  DEFAULT_EDGE_THRESH  HDL_PARAMETER        false

add_parameter           ARE_IDENTICAL        INTEGER              0
set_parameter_property  ARE_IDENTICAL        DISPLAY_NAME         "Share horizontal and vertical coefficients"
set_parameter_property  ARE_IDENTICAL        ALLOWED_RANGES       0:1
set_parameter_property  ARE_IDENTICAL        DISPLAY_HINT         boolean
set_parameter_property  ARE_IDENTICAL        DESCRIPTION          "Forces the bicubic and polyphase algorithms to use the same horizontal and vertical scaling coefficients"
set_parameter_property  ARE_IDENTICAL        HDL_PARAMETER        false
set_parameter_property  ARE_IDENTICAL        AFFECTS_ELABORATION  true

add_parameter           V_TAPS               INTEGER              8
set_parameter_property  V_TAPS               DISPLAY_NAME         "Vertical filter taps"
set_parameter_property  V_TAPS               ALLOWED_RANGES       4:64
set_parameter_property  V_TAPS               DESCRIPTION          "Number of vertical filter taps for the bicubic and polyphase algorithms"
set_parameter_property  V_TAPS               HDL_PARAMETER        false
set_parameter_property  V_TAPS               AFFECTS_ELABORATION  true

add_parameter           V_PHASES             INTEGER              16
set_parameter_property  V_PHASES             DISPLAY_NAME         "Vertical filter phases"
set_parameter_property  V_PHASES             ALLOWED_RANGES       {1 2 4 8 16 32 64 128 256}
set_parameter_property  V_PHASES             DESCRIPTION          "Number of vertical filter phases for the bicubic and polyphase algorithms"
set_parameter_property  V_PHASES             HDL_PARAMETER        false
set_parameter_property  V_PHASES             AFFECTS_ELABORATION  true

add_parameter           H_TAPS               INTEGER              8
set_parameter_property  H_TAPS               DISPLAY_NAME         "Horizontal filter taps"
set_parameter_property  H_TAPS               ALLOWED_RANGES       4:64
set_parameter_property  H_TAPS               DESCRIPTION          "Number of horizontal filter taps for the bicubic and polyphase algorithms"
set_parameter_property  H_TAPS               HDL_PARAMETER        false
set_parameter_property  H_TAPS               AFFECTS_ELABORATION  true

add_parameter           H_PHASES             INTEGER              16
set_parameter_property  H_PHASES             DISPLAY_NAME         "Horizontal filter phases"
set_parameter_property  H_PHASES             ALLOWED_RANGES       {1 2 4 8 16 32 64 128 256}
set_parameter_property  H_PHASES             DESCRIPTION          "Number of horizontal filter phases for the bicubic and polyphase algorithms"
set_parameter_property  H_PHASES             HDL_PARAMETER        false
set_parameter_property  H_PHASES             AFFECTS_ELABORATION  true

add_parameter           V_SIGNED             INTEGER              1
set_parameter_property  V_SIGNED             DISPLAY_NAME         "Vertical coefficients signed"
set_parameter_property  V_SIGNED             ALLOWED_RANGES       0:1
set_parameter_property  V_SIGNED             DISPLAY_HINT         boolean
set_parameter_property  V_SIGNED             DESCRIPTION          "Forces the algorithm to use signed coefficient data"
set_parameter_property  V_SIGNED             HDL_PARAMETER        false
set_parameter_property  V_SIGNED             AFFECTS_ELABORATION  true

add_parameter           V_INTEGER_BITS       INTEGER              1
set_parameter_property  V_INTEGER_BITS       DISPLAY_NAME         "Vertical coefficient integer bits"
set_parameter_property  V_INTEGER_BITS       ALLOWED_RANGES       1:32
set_parameter_property  V_INTEGER_BITS       DESCRIPTION          "Number of integer bits for each vertical coefficient"
set_parameter_property  V_INTEGER_BITS       HDL_PARAMETER        false
set_parameter_property  V_INTEGER_BITS       AFFECTS_ELABORATION  true

add_parameter           V_FRACTION_BITS      INTEGER              7
set_parameter_property  V_FRACTION_BITS      DISPLAY_NAME         "Vertical coefficient fraction bits"
set_parameter_property  V_FRACTION_BITS      ALLOWED_RANGES       1:32
set_parameter_property  V_FRACTION_BITS      DESCRIPTION          "Number of fraction bits for each vertical coefficient"
set_parameter_property  V_FRACTION_BITS      HDL_PARAMETER        false
set_parameter_property  V_FRACTION_BITS      AFFECTS_ELABORATION  true

add_parameter           H_SIGNED             INTEGER              1
set_parameter_property  H_SIGNED             DISPLAY_NAME         "Horizontal coefficients signed"
set_parameter_property  H_SIGNED             ALLOWED_RANGES       0:1
set_parameter_property  H_SIGNED             DISPLAY_HINT         boolean
set_parameter_property  H_SIGNED             DESCRIPTION          "Forces the algorithm to use signed coefficient data"
set_parameter_property  H_SIGNED             HDL_PARAMETER        false
set_parameter_property  H_SIGNED             AFFECTS_ELABORATION  true

add_parameter           H_INTEGER_BITS       INTEGER              1
set_parameter_property  H_INTEGER_BITS       DISPLAY_NAME         "Horizontal coefficient integer bits"
set_parameter_property  H_INTEGER_BITS       ALLOWED_RANGES       1:32
set_parameter_property  H_INTEGER_BITS       DESCRIPTION          "Number of integer bits for each horizontal coefficient"
set_parameter_property  H_INTEGER_BITS       HDL_PARAMETER        false
set_parameter_property  H_INTEGER_BITS       AFFECTS_ELABORATION  true

add_parameter           H_FRACTION_BITS      INTEGER              7
set_parameter_property  H_FRACTION_BITS      DISPLAY_NAME         "Horizontal coefficient fraction bits"
set_parameter_property  H_FRACTION_BITS      ALLOWED_RANGES       1:32
set_parameter_property  H_FRACTION_BITS      DESCRIPTION          "Number of fraction bits for each horizontal coefficient"
set_parameter_property  H_FRACTION_BITS      HDL_PARAMETER        false
set_parameter_property  H_FRACTION_BITS      AFFECTS_ELABORATION  true

add_parameter           PRESERVE_BITS        INTEGER              0
set_parameter_property  PRESERVE_BITS        DISPLAY_NAME         "Fractional bits preserved"
set_parameter_property  PRESERVE_BITS        ALLOWED_RANGES       0:32
set_parameter_property  PRESERVE_BITS        DESCRIPTION          "Number of fractional bits to preserve between horizontal and vertical filtering (bicubic/polyphase only)"
set_parameter_property  PRESERVE_BITS        HDL_PARAMETER        false
set_parameter_property  PRESERVE_BITS        AFFECTS_ELABORATION  true

add_parameter           LOAD_AT_RUNTIME      INTEGER              0
set_parameter_property  LOAD_AT_RUNTIME      DISPLAY_NAME         "Load scaler coefficients at runtime"
set_parameter_property  LOAD_AT_RUNTIME      ALLOWED_RANGES       0:1
set_parameter_property  LOAD_AT_RUNTIME      DISPLAY_HINT         boolean
set_parameter_property  LOAD_AT_RUNTIME      DESCRIPTION          "Allows the scaler coefficients for the polyphase algorithms to be updated at runtime"
set_parameter_property  LOAD_AT_RUNTIME      HDL_PARAMETER        false
set_parameter_property  LOAD_AT_RUNTIME      AFFECTS_ELABORATION  true

add_parameter           V_BANKS              INTEGER              1
set_parameter_property  V_BANKS              DISPLAY_NAME         "Vertical coefficient banks"
set_parameter_property  V_BANKS              ALLOWED_RANGES       1:32
set_parameter_property  V_BANKS              DESCRIPTION          "Number of banks of vertical filter coefficients for the polyphase algorithms"
set_parameter_property  V_BANKS              HDL_PARAMETER        false
set_parameter_property  V_BANKS              AFFECTS_ELABORATION  true

add_parameter           V_FUNCTION           STRING               LANCZOS_2
set_parameter_property  V_FUNCTION           DISPLAY_NAME         "Vertical coefficient function"
set_parameter_property  V_FUNCTION           ALLOWED_RANGES       {LANCZOS_2 LANCZOS_3 CUSTOM}
set_parameter_property  V_FUNCTION           DESCRIPTION          "Selects the function used to generate the vertical scaling coefficients"
set_parameter_property  V_FUNCTION           HDL_PARAMETER        false
set_parameter_property  V_FUNCTION           AFFECTS_ELABORATION  true

add_parameter           V_COEFF_FILE         STRING               "<enter file name (including full path)>"
set_parameter_property  V_COEFF_FILE         DISPLAY_NAME         "Vertical coefficients file"
set_parameter_property  V_COEFF_FILE         DESCRIPTION          "Selects the file containing the vertical coefficient data"
set_parameter_property  V_COEFF_FILE         HDL_PARAMETER        false
set_parameter_property  V_COEFF_FILE         AFFECTS_ELABORATION  true

add_parameter           H_BANKS              INTEGER              1
set_parameter_property  H_BANKS              DISPLAY_NAME         "Horizontal coefficient banks"
set_parameter_property  H_BANKS              ALLOWED_RANGES       1:32
set_parameter_property  H_BANKS              DESCRIPTION          "Number of banks of horizontal filter coefficients for the polyphase algorithms"
set_parameter_property  H_BANKS              HDL_PARAMETER        false
set_parameter_property  H_BANKS              AFFECTS_ELABORATION  true

add_parameter           H_FUNCTION           STRING               LANCZOS_2
set_parameter_property  H_FUNCTION           DISPLAY_NAME         "Horizontal coefficient function"
set_parameter_property  H_FUNCTION           ALLOWED_RANGES       {LANCZOS_2 LANCZOS_3 CUSTOM}
set_parameter_property  H_FUNCTION           DESCRIPTION          "Selects the function used to generate the horizontal scaling coefficients"
set_parameter_property  H_FUNCTION           HDL_PARAMETER        false
set_parameter_property  H_FUNCTION           AFFECTS_ELABORATION  true

add_parameter           H_COEFF_FILE         STRING               "<enter file name (including full path)>"
set_parameter_property  H_COEFF_FILE         DISPLAY_NAME         "Horizontal coefficients file"
set_parameter_property  H_COEFF_FILE         DESCRIPTION          "Selects the file containing the horizontal coefficient data"
set_parameter_property  H_COEFF_FILE         HDL_PARAMETER        false
set_parameter_property  H_COEFF_FILE         AFFECTS_ELABORATION  true

add_user_packet_support_parameters
set_parameter_property  USER_PACKET_FIFO_DEPTH   HDL_PARAMETER    false
set_parameter_property  USER_PACKET_SUPPORT      HDL_PARAMETER    false
set_parameter_property  USER_PACKET_FIFO_DEPTH   VISIBLE          false

add_parameter           LIMITED_READBACK     INTEGER              0
set_parameter_property  LIMITED_READBACK     DISPLAY_NAME         "Reduced control slave register readback"
set_parameter_property  LIMITED_READBACK     DESCRIPTION          ""
set_parameter_property  LIMITED_READBACK     ALLOWED_RANGES       0:1
set_parameter_property  LIMITED_READBACK     AFFECTS_ELABORATION  true
set_parameter_property  LIMITED_READBACK     HDL_PARAMETER        false
set_parameter_property  LIMITED_READBACK     DISPLAY_HINT         boolean

#just here for software model evaluation purposes. No hardware support
add_parameter           IS_420               INTEGER              0
set_parameter_property  IS_420               HDL_PARAMETER        false
set_parameter_property  IS_420               AFFECTS_ELABORATION  false
set_parameter_property  IS_420               VISIBLE              false

#legacy parameters - no longer supported
add_parameter           ALWAYS_DOWNSCALE     INTEGER              0
set_parameter_property  ALWAYS_DOWNSCALE     HDL_PARAMETER        false
set_parameter_property  ALWAYS_DOWNSCALE     AFFECTS_ELABORATION  false
set_parameter_property  ALWAYS_DOWNSCALE     VISIBLE              false

add_parameter           DEFAULT_UPPER_BLUR   INTEGER              0
set_parameter_property  DEFAULT_UPPER_BLUR   AFFECTS_ELABORATION  false
set_parameter_property  DEFAULT_UPPER_BLUR   HDL_PARAMETER        false
set_parameter_property  DEFAULT_UPPER_BLUR   VISIBLE              false

add_parameter           DEFAULT_LOWER_BLUR   INTEGER              0
set_parameter_property  DEFAULT_LOWER_BLUR   AFFECTS_ELABORATION  false
set_parameter_property  DEFAULT_LOWER_BLUR   HDL_PARAMETER        false
set_parameter_property  DEFAULT_LOWER_BLUR   VISIBLE              false

add_parameter           ENABLE_FIR           INTEGER              0
set_parameter_property  ENABLE_FIR           HDL_PARAMETER        false
set_parameter_property  ENABLE_FIR           AFFECTS_ELABORATION  false
set_parameter_property  ENABLE_FIR           VISIBLE              false

add_parameter           V_SYMMETRIC          INTEGER              0
set_parameter_property  V_SYMMETRIC          HDL_PARAMETER        false
set_parameter_property  V_SYMMETRIC          AFFECTS_ELABORATION  false
set_parameter_property  V_SYMMETRIC          VISIBLE              false

add_parameter           H_SYMMETRIC          INTEGER              0
set_parameter_property  H_SYMMETRIC          HDL_PARAMETER        false
set_parameter_property  H_SYMMETRIC          AFFECTS_ELABORATION  false
set_parameter_property  H_SYMMETRIC          VISIBLE              false


add_device_family_parameters


add_display_item  "Video Data Format"        PIXELS_IN_PARALLEL   parameter
add_display_item  "Video Data Format"        BITS_PER_SYMBOL      parameter
add_display_item  "Video Data Format"        SYMBOLS_IN_PAR       parameter
add_display_item  "Video Data Format"        SYMBOLS_IN_SEQ       parameter
add_display_item  "Video Data Format"        RUNTIME_CONTROL      parameter
add_display_item  "Video Data Format"        MAX_IN_WIDTH         parameter
add_display_item  "Video Data Format"        MAX_IN_HEIGHT        parameter
add_display_item  "Video Data Format"        MAX_OUT_WIDTH        parameter
add_display_item  "Video Data Format"        MAX_OUT_HEIGHT       parameter
add_display_item  "Video Data Format"        IS_422               parameter
add_display_item  "Video Data Format"        NO_BLANKING          parameter

add_display_item  "Algorithm Settings"       ALGORITHM_NAME       parameter
add_display_item  "Algorithm Settings"       ARE_IDENTICAL        parameter
add_display_item  "Algorithm Settings"       V_TAPS               parameter
add_display_item  "Algorithm Settings"       V_PHASES             parameter
add_display_item  "Algorithm Settings"       H_TAPS               parameter
add_display_item  "Algorithm Settings"       H_PHASES             parameter
add_display_item  "Algorithm Settings"       DEFAULT_EDGE_THRESH  parameter

add_display_item  "Precision Settings"       V_SIGNED             parameter
add_display_item  "Precision Settings"       V_INTEGER_BITS       parameter
add_display_item  "Precision Settings"       V_FRACTION_BITS      parameter
add_display_item  "Precision Settings"       H_SIGNED             parameter
add_display_item  "Precision Settings"       H_INTEGER_BITS       parameter
add_display_item  "Precision Settings"       H_FRACTION_BITS      parameter
add_display_item  "Precision Settings"       PRESERVE_BITS        parameter

add_display_item  "Coefficient Settings"     LOAD_AT_RUNTIME      parameter
add_display_item  "Coefficient Settings"     V_BANKS              parameter
add_display_item  "Coefficient Settings"     V_FUNCTION           parameter
add_display_item  "Coefficient Settings"     V_COEFF_FILE         parameter
add_display_item  "Coefficient Settings"     H_BANKS              parameter
add_display_item  "Coefficient Settings"     H_FUNCTION           parameter
add_display_item  "Coefficient Settings"     H_COEFF_FILE         parameter

add_display_item  "Optimisation"             EXTRA_PIPELINING     parameter
add_display_item  "Optimisation"             LIMITED_READBACK     parameter
add_display_item  "Optimisation"             USER_PACKET_SUPPORT  parameter



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc scl_validation_callback {} {
   set   symbols_in_seq [get_parameter_value SYMBOLS_IN_SEQ]
   set   symbols_in_par [get_parameter_value SYMBOLS_IN_PAR]
   set   is_422         [get_parameter_value IS_422]

   if { [get_parameter_value NO_BLANKING] > 0 } {
      set   comp  [get_parameter_value USER_PACKET_SUPPORT]
      set   match [string compare   $comp PASSTHROUGH]
      if { $match == 0 } {
         send_message error   "User packet pass through cannot be supported for video with no blanking"
      }
   }

   if { $is_422 > 0 } {
      set   num_colours    [expr $symbols_in_par * $symbols_in_seq]
      if { $num_colours == 1 } {
         send_message error   "There must be at least 2 color planes in sequence or parallel for the 4:2:2 data configuration"
      }
      set   width_modulo   [get_parameter_value MAX_IN_WIDTH]
      set   width_modulo   [expr $width_modulo % 2]
      if { $width_modulo > 0 } {
         send_message error   "For 4:2:2 data the maximum input frame width must be a multiple of 2"
      }
      set   width_modulo   [get_parameter_value MAX_OUT_WIDTH]
      set   width_modulo   [expr $width_modulo % 2]
      if { $width_modulo > 0 } {
         send_message error   "For 4:2:2 data the maximum output frame width must be a multiple of 2"
      }
   }

   if { $symbols_in_seq > 1 } {
      if { $symbols_in_par > 1 } {
         send_message error   "The symbols for each pixel must be transmitted either entirely in sequence or entirely in parallel"
      }
   }

   if { [get_parameter_value ARE_IDENTICAL] > 0 } {
      send_message info    "Vertical coefficient parameters (number of phases, precison parameters, etc.) will be used for the shared coefficients"
      set   algorithm_name [get_parameter_value ALGORITHM_NAME ]
      set   comp           [string compare $algorithm_name "POLYPHASE"]
      if { $comp != 0 } {
         set   comp        [string compare $algorithm_name "EDGE_ADAPT"]
      }
      if { $comp == 0 } {
         if { [get_parameter_value LOAD_AT_RUNTIME] > 0 } {
            set   coeff_width [expr [get_parameter_value V_FRACTION_BITS] + [get_parameter_value V_INTEGER_BITS] + [get_parameter_value V_SIGNED] ]
            if { $coeff_width > 32 } {
               send_message error   "Total vertical coefficient width (fraction bits + integer bits + optional sign bit) must not exceed 32 bits with runtime loaded coefficients"
            }
         }
      }
   } else {
      set   algorithm_name [get_parameter_value ALGORITHM_NAME ]
      set   comp           [string compare $algorithm_name "POLYPHASE"]
      if { $comp != 0 } {
         set   comp        [string compare $algorithm_name "EDGE_ADAPT"]
      }
      if { $comp == 0 } {
         if { [get_parameter_value LOAD_AT_RUNTIME] > 0 } {
            set   v_coeff_width  [expr [get_parameter_value V_FRACTION_BITS] + [get_parameter_value V_INTEGER_BITS] + [get_parameter_value V_SIGNED] ]
            if { $v_coeff_width > 32 } {
               send_message error   "Total vertical coefficient width (fraction bits + integer bits + optional sign bit) must not exceed 32 bits with runtime loaded coefficients"
            }
            set   h_coeff_width  [expr [get_parameter_value H_FRACTION_BITS] + [get_parameter_value H_INTEGER_BITS] + [get_parameter_value H_SIGNED] ]
            if { $h_coeff_width > 32 } {
               send_message error   "Total horizontal coefficient width (fraction bits + integer bits + optional sign bit) must not exceed 32 bits with runtime loaded coefficients"
            }
         }
      }
   }

   set   comp  [string compare $algorithm_name "EDGE_ADAPT"]
   if { $comp == 0 } {
      if { [get_parameter_value LOAD_AT_RUNTIME] == 0 } {
         send_message error   "Only runtime loading of coefficients is currently supported for Edge Adaptive mode"
      }
   }

   set   limit [get_parameter_value BITS_PER_SYMBOL]
   set   limit [expr {pow(2, $limit)}]
   set   limit [expr {$limit - 1}]
   set   value [get_parameter_value DEFAULT_EDGE_THRESH]
   if { $value > $limit } {
      send_message Warning "Default edge threshold is outside the range supported by the specified bits per symbol"
   }
   if { $value < 0 } {
      send_message Warning "Default edge threshold must be a positive integer"
   }
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                        --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc scl_composition_callback {} {
   global isVersion
   global acdsVersion
   global vib_vob_removal

   set_parameter_property  H_TAPS               ENABLED  false
   set_parameter_property  V_TAPS               ENABLED  false
   set_parameter_property  H_PHASES             ENABLED  false
   set_parameter_property  V_PHASES             ENABLED  false
   set_parameter_property  ARE_IDENTICAL        ENABLED  false
   set_parameter_property  V_SIGNED             ENABLED  false
   set_parameter_property  V_INTEGER_BITS       ENABLED  false
   set_parameter_property  V_FRACTION_BITS      ENABLED  false
   set_parameter_property  H_SIGNED             ENABLED  false
   set_parameter_property  H_INTEGER_BITS       ENABLED  false
   set_parameter_property  H_FRACTION_BITS      ENABLED  false
   set_parameter_property  PRESERVE_BITS        ENABLED  false
   set_parameter_property  LOAD_AT_RUNTIME      ENABLED  false
   set_parameter_property  V_BANKS              ENABLED  false
   set_parameter_property  V_FUNCTION           ENABLED  false
   set_parameter_property  V_COEFF_FILE         ENABLED  false
   set_parameter_property  H_BANKS              ENABLED  false
   set_parameter_property  H_FUNCTION           ENABLED  false
   set_parameter_property  H_COEFF_FILE         ENABLED  false
   set_parameter_property  DEFAULT_EDGE_THRESH  ENABLED  false
   set_parameter_property  NO_BLANKING          ENABLED  true
   set_parameter_property  LIMITED_READBACK     ENABLED  false

   set   v_signed       0
   set   h_signed       0
   set   v_integer_bits 0
   set   h_integer_bits 0
   set   h_frac_bits    1
   set   runtime_load   0
   set   h_banks        1
   set   v_banks        1
   set   v_taps         1
   set   h_taps         1
   set   h_phases       1
   set   frac_bits_h    1
   set   frac_bits_w    1
   set   kc_alg_name    "BILINEAR"
   set   algorithm_name [get_parameter_value ALGORITHM_NAME ]
   set   comp           [string compare $algorithm_name "NEAREST_NEIGHBOUR"]

   if { [get_parameter_value RUNTIME_CONTROL] > 0 } {
      set_parameter_property  LIMITED_READBACK     ENABLED  true
      set   fixed_size  0
   } else {
      set   fixed_size  1
   }

   #enabling, disabline and safe-defaulting parameters that depend on the scaling mode
   if { $comp != 0 } {
      # not nearest neighbour mode
      set_parameter_property  V_FRACTION_BITS ENABLED    true
      set   kc_alg_name       $algorithm_name
      set   comp  [string compare $algorithm_name "BILINEAR"]
      if { $comp == 0 } {
         #bilinear mode
         set_parameter_property  H_FRACTION_BITS ENABLED true
         set   h_frac_bits       [get_parameter_value H_FRACTION_BITS ]
         set   v_taps            2
         set   h_taps            2
         set   frac_bits_h       [get_parameter_value V_FRACTION_BITS]
         set   frac_bits_w       [get_parameter_value H_FRACTION_BITS]
      } else {
         #bicubic/polyphase/edge-adapt
         set_parameter_property  ARE_IDENTICAL  ENABLED     true
         set_parameter_property  V_PHASES       ENABLED     true
         set_parameter_property  PRESERVE_BITS  ENABLED     true
         if { [get_parameter_value ARE_IDENTICAL] > 0 } {
            set   frac_bits_w [clogb2_pure [get_parameter_value V_PHASES] ]
            set   h_phases    [get_parameter_value V_PHASES]
            set   h_frac_bits [get_parameter_value V_FRACTION_BITS ]
         } else {
            set_parameter_property  H_PHASES ENABLED        true
            set_parameter_property  H_FRACTION_BITS ENABLED true
            set   h_frac_bits       [get_parameter_value H_FRACTION_BITS ]
            set   frac_bits_w       [clogb2_pure [get_parameter_value H_PHASES] ]
            set   h_phases          [get_parameter_value H_PHASES]
         }
         set   v_signed       1
         set   h_signed       1
         set   v_integer_bits 1
         set   h_integer_bits 1
         set   frac_bits_h    [clogb2_pure [get_parameter_value V_PHASES] ]
         set   comp           [string compare $algorithm_name "BICUBIC"]
         if { $comp == 0 } {
            #bicubic
            set   v_taps   4
            set   h_taps   4
         } else {
            set   comp  [string compare $algorithm_name "EDGE_ADAPT"]
            if { $comp == 0 } {
               set_parameter_property  DEFAULT_EDGE_THRESH ENABLED   true
            }
            set_parameter_property  LOAD_AT_RUNTIME ENABLED    true
            set_parameter_property  V_TAPS ENABLED             true
            set   v_taps            [get_parameter_value V_TAPS]
            set   h_taps            $v_taps
            if { [get_parameter_value LOAD_AT_RUNTIME] > 0 } {
               set_parameter_property  LIMITED_READBACK     ENABLED  true
               set_parameter_property  V_SIGNED             ENABLED  true
               set_parameter_property  V_INTEGER_BITS       ENABLED  true
               set_parameter_property  V_BANKS              ENABLED  true
               set   v_signed          [get_parameter_value V_SIGNED]
               set   v_integer_bits    [get_parameter_value V_INTEGER_BITS]
               set   h_signed          $v_signed
               set   h_integer_bits    $v_integer_bits
               set   runtime_load      1
               set   v_banks           [get_parameter_value V_BANKS]
               if { [get_parameter_value ARE_IDENTICAL] > 0 } {
                  set   h_banks        $v_banks
               }
            } else {
               set_parameter_property  V_FUNCTION ENABLED         true
               set   match             [string compare [get_parameter_value V_FUNCTION] CUSTOM]
               if { $match == 0 } {
                  set_parameter_property  V_COEFF_FILE ENABLED    true
                  set_parameter_property  V_SIGNED ENABLED        true
                  set_parameter_property  V_INTEGER_BITS ENABLED  true
                  set   v_signed          [get_parameter_value V_SIGNED]
                  set   v_integer_bits    [get_parameter_value V_INTEGER_BITS]
                  set   h_signed          $v_signed
                  set   h_integer_bits    $v_integer_bits
               }
            }
            if { [get_parameter_value ARE_IDENTICAL] == 0 } {
               set_parameter_property     H_TAPS ENABLED          true
               set h_taps [get_parameter_value H_TAPS]
               if { [get_parameter_value LOAD_AT_RUNTIME] > 0 } {
                  set_parameter_property  H_BANKS ENABLED         true
                  set_parameter_property  H_SIGNED ENABLED        true
                  set_parameter_property  H_INTEGER_BITS ENABLED  true
                  set   h_banks           [get_parameter_value H_BANKS]
                  set   h_signed          [get_parameter_value H_SIGNED]
                  set   h_integer_bits    [get_parameter_value H_INTEGER_BITS]
               } else {
                  set_parameter_property     H_FUNCTION ENABLED      true
                  set match [string compare [get_parameter_value H_FUNCTION] CUSTOM]
                  if { $match == 0 } {
                     set_parameter_property  H_COEFF_FILE ENABLED    true
                     set_parameter_property  H_SIGNED ENABLED        true
                     set_parameter_property  H_INTEGER_BITS ENABLED  true
                     set   h_signed          [get_parameter_value H_SIGNED]
                     set   h_integer_bits    [get_parameter_value H_INTEGER_BITS]
                  }
               }
            }
         }
      }
   }

   set   v_coeff_width  1
   set   h_coeff_width  1
   if { [get_parameter_value ARE_IDENTICAL] > 0 } {
      set   algorithm_name [get_parameter_value ALGORITHM_NAME ]
      set   comp           [string compare $algorithm_name "POLYPHASE"]
      if { $comp != 0 } {
         set   comp        [string compare $algorithm_name "EDGE_ADAPT"]
      }
      if { $comp == 0 } {
         if { [get_parameter_value LOAD_AT_RUNTIME] > 0 } {
            set   v_coeff_width  [expr [get_parameter_value V_FRACTION_BITS] + [get_parameter_value V_INTEGER_BITS] + [get_parameter_value V_SIGNED] ]
            set   h_coeff_width  $v_coeff_width
         }
      }
   } else {
      set   algorithm_name [get_parameter_value ALGORITHM_NAME ]
      set   comp           [string compare $algorithm_name "POLYPHASE"]
      if { $comp != 0 } {
         set   comp        [string compare $algorithm_name "EDGE_ADAPT"]
      }
      if { $comp == 0 } {
         if { [get_parameter_value LOAD_AT_RUNTIME] > 0 } {
            set   v_coeff_width  [expr [get_parameter_value V_FRACTION_BITS] + [get_parameter_value V_INTEGER_BITS] + [get_parameter_value V_SIGNED] ]
            set   h_coeff_width  [expr [get_parameter_value H_FRACTION_BITS] + [get_parameter_value H_INTEGER_BITS] + [get_parameter_value H_SIGNED] ]
         }
      }
   }

   if { [get_parameter_value SYMBOLS_IN_SEQ] > 1 } {
      set   colours_in_par 0
      if { [get_parameter_value IS_422] > 0 } {
         set   is_422_in_seq  1
      } else {
         set   is_422_in_seq  0
      }
   } else {
      set   colours_in_par 1
      set   is_422_in_seq  0
   }
   set   number_of_colours    [expr { [get_parameter_value SYMBOLS_IN_SEQ] * [get_parameter_value SYMBOLS_IN_PAR] } ]
   set   bits_per_symbol      [get_parameter_value BITS_PER_SYMBOL]
   set   num_par_symbols      [get_parameter_value SYMBOLS_IN_PAR]
   set   pixel_width          [ expr $bits_per_symbol * $num_par_symbols ]
   set   pip                  [get_parameter_value PIXELS_IN_PARALLEL]
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

   set   comp        [string compare $algorithm_name "BILINEAR"]
   if { $comp == 0 } {
      set   preserve_bits        [get_parameter_value V_FRACTION_BITS]
   } else {
      set   preserve_bits        [get_parameter_value PRESERVE_BITS]
      if { $preserve_bits > [get_parameter_value V_FRACTION_BITS] } {
         set   preserve_bits     [get_parameter_value V_FRACTION_BITS]
      }
   }

   if { $pip == 1 } {
      set   sep_cores      0
   } else {
      set   sep_cores      1
   }

   # Components that always exist in all modes
   if {$vib_vob_removal == 0} {
      add_instance   video_in_resp     alt_vip_video_input_bridge_resp  $isVersion
      add_instance   video_out         alt_vip_video_output_bridge      $isVersion
   }
   add_instance   line_buffer          alt_vip_line_buffer              $isVersion
   add_instance   scheduler            alt_vip_scaler_scheduler         $isVersion
   add_instance   kernel_creator       alt_vip_scaler_kernel_creator    $isVersion
   add_instance   av_st_clk_bridge     altera_clock_bridge              $acdsVersion
   add_instance   av_st_reset_bridge   altera_reset_bridge              $acdsVersion

    # Top level interfaces :
   add_interface          main_clock   clock         end
   add_interface          main_reset   reset         end
   set_interface_property main_clock   export_of     av_st_clk_bridge.in_clk
   set_interface_property main_reset   export_of     av_st_reset_bridge.in_reset
   set_interface_property main_clock   PORT_NAME_MAP {main_clock in_clk}
   set_interface_property main_reset   PORT_NAME_MAP {main_reset in_reset}

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
      set_instance_parameter_value  video_in_resp     BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
      set_instance_parameter_value  video_in_resp     NUMBER_OF_COLOR_PLANES        $number_of_colours
      set_instance_parameter_value  video_in_resp     COLOR_PLANES_ARE_IN_PARALLEL  $colours_in_par
      set_instance_parameter_value  video_in_resp     DEFAULT_LINE_LENGTH           [get_parameter_value MAX_IN_WIDTH]
      set_instance_parameter_value  video_in_resp     PIXELS_IN_PARALLEL            $pip
      set_instance_parameter_value  video_in_resp     VIDEO_PROTOCOL_NO             1
      set_instance_parameter_value  video_in_resp     MAX_WIDTH                     [get_parameter_value MAX_IN_WIDTH]
      set_instance_parameter_value  video_in_resp     MAX_HEIGHT                    [get_parameter_value MAX_IN_HEIGHT]
      set_instance_parameter_value  video_in_resp     ENABLE_RESOLUTION_CHECK       1
      set_instance_parameter_value  video_in_resp     SRC_WIDTH                     8
      set_instance_parameter_value  video_in_resp     DST_WIDTH                     8
      set_instance_parameter_value  video_in_resp     CONTEXT_WIDTH                 8
      set_instance_parameter_value  video_in_resp     TASK_WIDTH                    8
      set_instance_parameter_value  video_in_resp     RESP_SRC_ADDRESS              0
      set_instance_parameter_value  video_in_resp     RESP_DST_ADDRESS              0
      set_instance_parameter_value  video_in_resp     DATA_SRC_ADDRESS              0

      set_instance_parameter_value  video_out         BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
      set_instance_parameter_value  video_out         NUMBER_OF_COLOR_PLANES        $number_of_colours
      set_instance_parameter_value  video_out         COLOR_PLANES_ARE_IN_PARALLEL  $colours_in_par
      set_instance_parameter_value  video_out         PIXELS_IN_PARALLEL            $pip
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

   set_instance_parameter_value  line_buffer       PIXEL_WIDTH                      $pixel_width
   set_instance_parameter_value  line_buffer       PIXELS_IN_PARALLEL               $pip
   set_instance_parameter_value  line_buffer       CONVERT_TO_1_PIP                 0
   set_instance_parameter_value  line_buffer       SYMBOLS_IN_SEQ                   [get_parameter_value SYMBOLS_IN_SEQ]
   set_instance_parameter_value  line_buffer       MAX_LINE_LENGTH                  [get_parameter_value MAX_IN_WIDTH]
   set_instance_parameter_value  line_buffer       OUTPUT_PORTS                     1
   set_instance_parameter_value  line_buffer       MODE                             RATE_MATCHING
   set_instance_parameter_value  line_buffer       ENABLE_RECEIVE_ONLY_CMD          0
   set_instance_parameter_value  line_buffer       TRACK_LINE_LENGTH                1
   set_instance_parameter_value  line_buffer       OUTPUT_MUX_SEL                   OLD
   if {[get_parameter_value EXTRA_PIPELINING] > 0} {
      set_instance_parameter_value  line_buffer    OUTPUT_OPTION                    PIPELINED
   } else {
      set_instance_parameter_value  line_buffer    OUTPUT_OPTION                    UNPIPELINED
   }
   set_instance_parameter_value  line_buffer       FIFO_SIZE                        4
   set_instance_parameter_value  line_buffer       KERNEL_SIZE_0                    $v_taps
   set_instance_parameter_value  line_buffer       KERNEL_CENTER_0                  [expr int(floor(($v_taps-1) / 2))]
   set_instance_parameter_value  line_buffer       SRC_WIDTH                        8
   set_instance_parameter_value  line_buffer       DST_WIDTH                        8
   set_instance_parameter_value  line_buffer       CONTEXT_WIDTH                    8
   set_instance_parameter_value  line_buffer       TASK_WIDTH                       8
   set_instance_parameter_value  line_buffer       SOURCE_ADDRESS                   0

   set_instance_parameter_value  scheduler         ALGORITHM                     [get_parameter_value ALGORITHM_NAME]
   set_instance_parameter_value  scheduler         SEPARATE_V_H_CORE             $sep_cores
   set_instance_parameter_value  scheduler         DEFAULT_EDGE_THRESH           [get_parameter_value DEFAULT_EDGE_THRESH]
   set_instance_parameter_value  scheduler         MAX_IN_WIDTH                  [get_parameter_value MAX_IN_WIDTH]
   set_instance_parameter_value  scheduler         MAX_IN_HEIGHT                 [get_parameter_value MAX_IN_HEIGHT]
   set_instance_parameter_value  scheduler         MAX_OUT_HEIGHT                [get_parameter_value MAX_OUT_HEIGHT]
   set_instance_parameter_value  scheduler         MAX_OUT_WIDTH                 [get_parameter_value MAX_OUT_WIDTH]
   set_instance_parameter_value  scheduler         RUNTIME_CONTROL               [get_parameter_value RUNTIME_CONTROL]
   set_instance_parameter_value  scheduler         LOAD_AT_RUNTIME               $runtime_load
   set_instance_parameter_value  scheduler         H_BANKS                       $h_banks
   set_instance_parameter_value  scheduler         V_BANKS                       $v_banks
   set_instance_parameter_value  scheduler         H_PHASE_BITS                  $frac_bits_w
   set_instance_parameter_value  scheduler         V_PHASE_BITS                  $frac_bits_h
   set_instance_parameter_value  scheduler         V_TAPS                        $v_taps
   set_instance_parameter_value  scheduler         H_TAPS                        $h_taps
   set_instance_parameter_value  scheduler         NO_BLANKING                   [get_parameter_value NO_BLANKING]
   set_instance_parameter_value  scheduler         USER_PACKET_SUPPORT           [get_parameter_value USER_PACKET_SUPPORT]
   set_instance_parameter_value  scheduler         PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]
   set_instance_parameter_value  scheduler         ARE_IDENTICAL                 [get_parameter_value ARE_IDENTICAL]
   set_instance_parameter_value  scheduler         H_COEFF_WIDTH                 $h_coeff_width
   set_instance_parameter_value  scheduler         V_COEFF_WIDTH                 $v_coeff_width
   set_instance_parameter_value  scheduler         LIMITED_READBACK              [get_parameter_value LIMITED_READBACK]

   set_instance_parameter_value  kernel_creator    ALGORITHM                     $kc_alg_name
   set_instance_parameter_value  kernel_creator    PARTIAL_LINE_SCALING          0
   set_instance_parameter_value  kernel_creator    FRAC_BITS_H                   $frac_bits_h
   set_instance_parameter_value  kernel_creator    FRAC_BITS_W                   $frac_bits_w
   set_instance_parameter_value  kernel_creator    FIXED_SIZE                    $fixed_size
   set_instance_parameter_value  kernel_creator    MAX_IN_HEIGHT                 [get_parameter_value MAX_IN_HEIGHT]
   set_instance_parameter_value  kernel_creator    MAX_OUT_HEIGHT                [get_parameter_value MAX_OUT_HEIGHT]
   set_instance_parameter_value  kernel_creator    MAX_IN_WIDTH                  [get_parameter_value MAX_IN_WIDTH]
   set_instance_parameter_value  kernel_creator    MAX_OUT_WIDTH                 [get_parameter_value MAX_OUT_WIDTH]
   set_instance_parameter_value  kernel_creator    SRC_WIDTH                     8
   set_instance_parameter_value  kernel_creator    DST_WIDTH                     8
   set_instance_parameter_value  kernel_creator    CONTEXT_WIDTH                 8
   set_instance_parameter_value  kernel_creator    TASK_WIDTH                    8
   set_instance_parameter_value  kernel_creator    EXTRA_PIPELINE_REG            [get_parameter_value EXTRA_PIPELINING]
   set_instance_parameter_value  kernel_creator    IS_422                        [get_parameter_value IS_422]

   #connections that exist in all modes
   add_connection    av_st_clk_bridge.out_clk         av_st_reset_bridge.clk
   if {$vib_vob_removal == 0} {
      add_connection    av_st_clk_bridge.out_clk      video_in_resp.main_clock
      add_connection    av_st_clk_bridge.out_clk      video_out.main_clock
   }
   add_connection    av_st_clk_bridge.out_clk         line_buffer.main_clock
   add_connection    av_st_clk_bridge.out_clk         scheduler.main_clock
   add_connection    av_st_clk_bridge.out_clk         kernel_creator.main_clock
   if {$vib_vob_removal == 0} {
      add_connection    av_st_reset_bridge.out_reset  video_in_resp.main_reset
      add_connection    av_st_reset_bridge.out_reset  video_out.main_reset
   }
   add_connection    av_st_reset_bridge.out_reset     line_buffer.main_reset
   add_connection    av_st_reset_bridge.out_reset     scheduler.main_reset
   add_connection    av_st_reset_bridge.out_reset     kernel_creator.main_reset
   add_connection    scheduler.av_st_cmd_lb           line_buffer.av_st_cmd
   add_connection    scheduler.av_st_cmd_kc           kernel_creator.av_st_cmd
   if {$vib_vob_removal == 0} {
      add_connection    scheduler.av_st_cmd_vob       video_out.av_st_cmd
      add_connection    video_in_resp.av_st_resp      scheduler.av_st_resp_vib
   }
   add_connection    kernel_creator.av_st_resp        scheduler.av_st_resp_kc

   #adding the command half of the VIB if we need to discard or route user packets
   if { $user_mode > 0 } {

      add_instance   video_in_cmd      alt_vip_video_input_bridge_cmd      $isVersion

      set_instance_parameter_value  video_in_cmd      BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
      set_instance_parameter_value  video_in_cmd      NUMBER_OF_COLOR_PLANES        $number_of_colours
      set_instance_parameter_value  video_in_cmd      COLOR_PLANES_ARE_IN_PARALLEL  $colours_in_par
      set_instance_parameter_value  video_in_cmd      PIXELS_IN_PARALLEL            $pip
      set_instance_parameter_value  video_in_cmd      PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]
      set_instance_parameter_value  video_in_cmd      DATA_SRC_ADDRESS              0
      set_instance_parameter_value  video_in_cmd      SRC_WIDTH                     8
      set_instance_parameter_value  video_in_cmd      DST_WIDTH                     8
      set_instance_parameter_value  video_in_cmd      CONTEXT_WIDTH                 8
      set_instance_parameter_value  video_in_cmd      TASK_WIDTH                    8

      add_connection    av_st_clk_bridge.out_clk      video_in_cmd.main_clock
      add_connection    av_st_reset_bridge.out_reset  video_in_cmd.main_reset
      add_connection    scheduler.av_st_cmd_vib       video_in_cmd.av_st_cmd

      if {$vib_vob_removal == 0} {
         add_connection    video_in_resp.av_st_dout      video_in_cmd.av_st_din
      } else {
         set_interface_property  din_data    export_of   video_in_cmd.av_st_din
      }

   }

   #setting up the input routing depending on the user packet mode
   if { $user_mode > 1 } {
      #but we do need a demx if we have to pass through user packets

      add_instance   input_demux    alt_vip_packet_demux          $isVersion

      set_instance_parameter_value  input_demux    CMD_RESP_INTERFACE      0
      set_instance_parameter_value  input_demux    DATA_WIDTH              $pixel_width
      set_instance_parameter_value  input_demux    PIXELS_IN_PARALLEL      $pip
      set_instance_parameter_value  input_demux    NUM_OUTPUTS             2
      set_instance_parameter_value  input_demux    CLIP_ADDRESS_BITS       0
      set_instance_parameter_value  input_demux    REGISTER_OUTPUT         1
      set_instance_parameter_value  input_demux    PIPELINE_READY          [get_parameter_value EXTRA_PIPELINING]
      set_instance_parameter_value  input_demux    SRC_WIDTH               8
      set_instance_parameter_value  input_demux    DST_WIDTH               8
      set_instance_parameter_value  input_demux    CONTEXT_WIDTH           8
      set_instance_parameter_value  input_demux    TASK_WIDTH              8
      set_instance_parameter_value  input_demux    USER_WIDTH              0

      add_connection    av_st_clk_bridge.out_clk      input_demux.main_clock
      add_connection    av_st_reset_bridge.out_reset  input_demux.main_reset

      add_connection    video_in_cmd.av_st_dout       input_demux.av_st_din
      add_connection    input_demux.av_st_dout_0      line_buffer.av_st_din

   } else {

      if { $user_mode > 0 } {
         add_connection    video_in_cmd.av_st_dout    line_buffer.av_st_din
      } else {
         if {$vib_vob_removal == 0} {
            add_connection video_in_resp.av_st_dout   line_buffer.av_st_din
         } else {
            set_interface_property  din_data    export_of   line_buffer.av_st_din
         }
      }

   }

   if { $sep_cores > 0 } {

      set   bps_in      [get_parameter_value BITS_PER_SYMBOL]
      set   comp  [string compare $algorithm_name "NEAREST_NEIGHBOUR"]
      if { $comp != 0 } {
         set   v_frac   [get_parameter_value V_FRACTION_BITS]
         set   comp  [string compare $algorithm_name "BILINEAR"]
         if { $comp == 0 } {
            set   bps_in   [expr $bps_in + 1 + $v_frac]
         } else {
            set   bps_in   [expr $bps_in + $v_signed + $v_integer_bits + $preserve_bits]
         }
      }

      add_instance      h_scaler_core        alt_vip_horiz_scaler_alg_core          $isVersion

      set_instance_parameter_value  h_scaler_core     NUMBER_OF_COLOR_PLANES        $number_of_colours
      set_instance_parameter_value  h_scaler_core     BITS_PER_SYMBOL_IN            $bps_in
      set_instance_parameter_value  h_scaler_core     BITS_PER_SYMBOL_OUT           [get_parameter_value BITS_PER_SYMBOL]
      set_instance_parameter_value  h_scaler_core     PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
      set_instance_parameter_value  h_scaler_core     IS_422                        [get_parameter_value IS_422]
      set_instance_parameter_value  h_scaler_core     MAX_IN_WIDTH                  [get_parameter_value MAX_IN_WIDTH]
      set_instance_parameter_value  h_scaler_core     MAX_OUT_WIDTH                 [get_parameter_value MAX_OUT_WIDTH]
      set_instance_parameter_value  h_scaler_core     MAX_IN_HEIGHT                 [get_parameter_value MAX_IN_HEIGHT]
      set_instance_parameter_value  h_scaler_core     MAX_OUT_HEIGHT                [get_parameter_value MAX_OUT_HEIGHT]
      set_instance_parameter_value  h_scaler_core     ALGORITHM_NAME                [get_parameter_value ALGORITHM_NAME]
      set_instance_parameter_value  h_scaler_core     H_TAPS                        $h_taps
      set_instance_parameter_value  h_scaler_core     LOAD_AT_RUNTIME               $runtime_load
      set_instance_parameter_value  h_scaler_core     H_PHASES                      $h_phases
      set_instance_parameter_value  h_scaler_core     H_SIGNED                      $h_signed
      set_instance_parameter_value  h_scaler_core     H_INTEGER_BITS                $h_integer_bits
      set_instance_parameter_value  h_scaler_core     H_FRACTION_BITS               $h_frac_bits
      set_instance_parameter_value  h_scaler_core     IN_SIGNED                     $v_signed
      set_instance_parameter_value  h_scaler_core     IN_FRACTION_BITS              $preserve_bits
      set_instance_parameter_value  h_scaler_core     H_FUNCTION                    [get_parameter_value H_FUNCTION]
      set_instance_parameter_value  h_scaler_core     H_BANKS                       $h_banks
      set_instance_parameter_value  h_scaler_core     H_COEFF_FILE                  [get_parameter_value H_COEFF_FILE]
      set_instance_parameter_value  h_scaler_core     PRE_ALIGNED_SOP               1
      set_instance_parameter_value  h_scaler_core     SRC_WIDTH                     8
      set_instance_parameter_value  h_scaler_core     DST_WIDTH                     8
      set_instance_parameter_value  h_scaler_core     CONTEXT_WIDTH                 8
      set_instance_parameter_value  h_scaler_core     TASK_WIDTH                    8
      set_instance_parameter_value  h_scaler_core     PIPELINE_READY                1
      set_instance_parameter_value  h_scaler_core     SOURCE_ID                     0

      add_connection    av_st_clk_bridge.out_clk         h_scaler_core.main_clock
      add_connection    av_st_reset_bridge.out_reset     h_scaler_core.main_reset

      add_connection    scheduler.av_st_cmd_ac_0         h_scaler_core.av_st_cmd
      add_connection    h_scaler_core.av_st_resp         scheduler.av_st_resp_ac

      set   comp  [string compare $algorithm_name "NEAREST_NEIGHBOUR"]
      if { $comp != 0 } {

         add_instance      v_scaler_core        alt_vip_vert_scaler_alg_core          $isVersion

         set_instance_parameter_value  v_scaler_core     NUMBER_OF_COLOR_PLANES        $number_of_colours
         set_instance_parameter_value  v_scaler_core     BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
         set_instance_parameter_value  v_scaler_core     IS_422                        [get_parameter_value IS_422]
         set_instance_parameter_value  v_scaler_core     PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]
         set_instance_parameter_value  v_scaler_core     ALGORITHM_NAME                [get_parameter_value ALGORITHM_NAME]
         set_instance_parameter_value  v_scaler_core     V_TAPS                        $v_taps
         set_instance_parameter_value  v_scaler_core     LOAD_AT_RUNTIME               $runtime_load
         set_instance_parameter_value  v_scaler_core     V_PHASES                      [get_parameter_value V_PHASES]
         set_instance_parameter_value  v_scaler_core     V_SIGNED                      $v_signed
         set_instance_parameter_value  v_scaler_core     V_INTEGER_BITS                $v_integer_bits
         set_instance_parameter_value  v_scaler_core     V_FRACTION_BITS               [get_parameter_value V_FRACTION_BITS]
         set_instance_parameter_value  v_scaler_core     PRESERVE_FRACTION_BITS        $preserve_bits
         set_instance_parameter_value  v_scaler_core     V_FUNCTION                    [get_parameter_value V_FUNCTION]
         set_instance_parameter_value  v_scaler_core     V_BANKS                       $v_banks
         set_instance_parameter_value  v_scaler_core     V_COEFF_FILE                  [get_parameter_value V_COEFF_FILE]
         set_instance_parameter_value  v_scaler_core     SRC_WIDTH                     8
         set_instance_parameter_value  v_scaler_core     DST_WIDTH                     8
         set_instance_parameter_value  v_scaler_core     CONTEXT_WIDTH                 8
         set_instance_parameter_value  v_scaler_core     TASK_WIDTH                    8
         set_instance_parameter_value  v_scaler_core     PIPELINE_READY                1
         set_instance_parameter_value  v_scaler_core     SOURCE_ID                     0

         add_connection    av_st_clk_bridge.out_clk      v_scaler_core.main_clock
         add_connection    av_st_reset_bridge.out_reset  v_scaler_core.main_reset

         add_connection    scheduler.av_st_cmd_ac_1      v_scaler_core.av_st_cmd
         add_connection    line_buffer.av_st_dout_0      v_scaler_core.av_st_din
         add_connection    v_scaler_core.av_st_dout      h_scaler_core.av_st_din

      } else {

         add_connection    line_buffer.av_st_dout_0      h_scaler_core.av_st_din

      }

   } else {

      set   kernel_bits          [ expr {$bits_per_symbol + $v_signed + $v_integer_bits + $preserve_bits} ]

      add_instance      scaler_core          alt_vip_scaler_alg_core          $isVersion

      set_instance_parameter_value  scaler_core       NUMBER_OF_COLOR_PLANES        $number_of_colours
      if { $is_422_in_seq > 0 } {
         set_instance_parameter_value  scaler_core    COLOR_PLANES_ARE_IN_PARALLEL  1
      } else {
         set_instance_parameter_value  scaler_core    COLOR_PLANES_ARE_IN_PARALLEL  $colours_in_par
      }
      set_instance_parameter_value  scaler_core       BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
      set_instance_parameter_value  scaler_core       IS_422                        [get_parameter_value IS_422]
      set_instance_parameter_value  scaler_core       MAX_IN_WIDTH                  [get_parameter_value MAX_IN_WIDTH]
      set_instance_parameter_value  scaler_core       MAX_OUT_WIDTH                 [get_parameter_value MAX_OUT_WIDTH]
      set_instance_parameter_value  scaler_core       RUNTIME_CONTROL               [get_parameter_value RUNTIME_CONTROL]
      set_instance_parameter_value  scaler_core       ALGORITHM_NAME                [get_parameter_value ALGORITHM_NAME]
      set_instance_parameter_value  scaler_core       PARTIAL_LINE_SCALING          0
      set_instance_parameter_value  scaler_core       LEFT_MIRROR                   1
      set_instance_parameter_value  scaler_core       RIGHT_MIRROR                  1
      set_instance_parameter_value  scaler_core       V_TAPS                        $v_taps
      set_instance_parameter_value  scaler_core       H_TAPS                        $h_taps
      set_instance_parameter_value  scaler_core       ARE_IDENTICAL                 [get_parameter_value ARE_IDENTICAL]
      set_instance_parameter_value  scaler_core       LOAD_AT_RUNTIME               $runtime_load
      set_instance_parameter_value  scaler_core       V_PHASES                      [get_parameter_value V_PHASES]
      set_instance_parameter_value  scaler_core       H_PHASES                      $h_phases
      set_instance_parameter_value  scaler_core       V_SIGNED                      $v_signed
      set_instance_parameter_value  scaler_core       V_INTEGER_BITS                $v_integer_bits
      set_instance_parameter_value  scaler_core       V_FRACTION_BITS               [get_parameter_value V_FRACTION_BITS]
      set_instance_parameter_value  scaler_core       H_SIGNED                      $h_signed
      set_instance_parameter_value  scaler_core       H_INTEGER_BITS                $h_integer_bits
      set_instance_parameter_value  scaler_core       H_FRACTION_BITS               $h_frac_bits
      set_instance_parameter_value  scaler_core       H_KERNEL_BITS                 $kernel_bits
      set_instance_parameter_value  scaler_core       V_FUNCTION                    [get_parameter_value V_FUNCTION]
      set_instance_parameter_value  scaler_core       V_BANKS                       $v_banks
      set_instance_parameter_value  scaler_core       V_COEFF_FILE                  [get_parameter_value V_COEFF_FILE]
      set_instance_parameter_value  scaler_core       H_FUNCTION                    [get_parameter_value H_FUNCTION]
      set_instance_parameter_value  scaler_core       H_BANKS                       $h_banks
      set_instance_parameter_value  scaler_core       H_COEFF_FILE                  [get_parameter_value H_COEFF_FILE]
      set_instance_parameter_value  scaler_core       SRC_WIDTH                     8
      set_instance_parameter_value  scaler_core       DST_WIDTH                     8
      set_instance_parameter_value  scaler_core       CONTEXT_WIDTH                 8
      set_instance_parameter_value  scaler_core       TASK_WIDTH                    8
      set_instance_parameter_value  scaler_core       EXTRA_PIPELINE_REG            1
      set_instance_parameter_value  scaler_core       SHIFTED_MIRROR                0
      set_instance_parameter_value  scaler_core       DOUT_SRC_ADDRESS              0

      add_connection    av_st_clk_bridge.out_clk         scaler_core.main_clock
      add_connection    av_st_reset_bridge.out_reset     scaler_core.main_reset

      add_connection    scheduler.av_st_cmd_ac_0         scaler_core.av_st_cmd
      add_connection    scaler_core.av_st_resp           scheduler.av_st_resp_ac

      if { $is_422_in_seq > 0 } {

         add_instance      seq_to_par           alt_vip_seq_par_convert         $isVersion
         add_instance      par_to_seq           alt_vip_seq_par_convert         $isVersion


         set_instance_parameter_value  seq_to_par     NUMBER_OF_COLOR_PLANES        $number_of_colours
         set_instance_parameter_value  seq_to_par     BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
         set_instance_parameter_value  seq_to_par     NUM_KERNEL_LINES              $v_taps
         set_instance_parameter_value  seq_to_par     SEQUENCE_IN                   1
         set_instance_parameter_value  seq_to_par     SRC_WIDTH                     8
         set_instance_parameter_value  seq_to_par     DST_WIDTH                     8
         set_instance_parameter_value  seq_to_par     CONTEXT_WIDTH                 8
         set_instance_parameter_value  seq_to_par     TASK_WIDTH                    8
         set_instance_parameter_value  seq_to_par     PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]

         set_instance_parameter_value  par_to_seq     NUMBER_OF_COLOR_PLANES        $number_of_colours
         set_instance_parameter_value  par_to_seq     BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
         set_instance_parameter_value  par_to_seq     NUM_KERNEL_LINES              1
         set_instance_parameter_value  par_to_seq     SEQUENCE_IN                   0
         set_instance_parameter_value  par_to_seq     SRC_WIDTH                     8
         set_instance_parameter_value  par_to_seq     DST_WIDTH                     8
         set_instance_parameter_value  par_to_seq     CONTEXT_WIDTH                 8
         set_instance_parameter_value  par_to_seq     TASK_WIDTH                    8
         set_instance_parameter_value  par_to_seq     PIPELINE_READY                [get_parameter_value EXTRA_PIPELINING]

         add_connection    av_st_clk_bridge.out_clk         seq_to_par.main_clock
         add_connection    av_st_reset_bridge.out_reset     seq_to_par.main_reset
         add_connection    av_st_clk_bridge.out_clk         par_to_seq.main_clock
         add_connection    av_st_reset_bridge.out_reset     par_to_seq.main_reset

         add_connection    line_buffer.av_st_dout_0         seq_to_par.av_st_din
         add_connection    seq_to_par.av_st_dout            scaler_core.av_st_din
         add_connection    scaler_core.av_st_dout           par_to_seq.av_st_din

      } else {

         add_connection    line_buffer.av_st_dout_0         scaler_core.av_st_din

      }

   }

   #setting up the output routing depending on the user packet mode
   if { $user_mode > 1 } {

      add_instance   output_mux     alt_vip_packet_mux   $isVersion

      set_instance_parameter_value  output_mux     CMD_RESP_INTERFACE      0
      set_instance_parameter_value  output_mux     NUM_INPUTS              2
      set_instance_parameter_value  output_mux     DATA_WIDTH              $pixel_width
      set_instance_parameter_value  output_mux     PIXELS_IN_PARALLEL      $pip
      set_instance_parameter_value  output_mux     REGISTER_OUTPUT         1
      set_instance_parameter_value  output_mux     PIPELINE_READY          [get_parameter_value EXTRA_PIPELINING]
      set_instance_parameter_value  output_mux     SRC_WIDTH               8
      set_instance_parameter_value  output_mux     DST_WIDTH               8
      set_instance_parameter_value  output_mux     CONTEXT_WIDTH           8
      set_instance_parameter_value  output_mux     TASK_WIDTH              8
      set_instance_parameter_value  output_mux     USER_WIDTH              0


      add_connection    av_st_clk_bridge.out_clk         output_mux.main_clock
      add_connection    av_st_reset_bridge.out_reset     output_mux.main_reset
      if { $sep_cores > 0 } {
         add_connection h_scaler_core.av_st_dout         output_mux.av_st_din_0
      } else {
         if { $is_422_in_seq > 0 } {
            add_connection par_to_seq.av_st_dout         output_mux.av_st_din_0
         } else {
            add_connection scaler_core.av_st_dout        output_mux.av_st_din_0
         }
      }
      add_connection    input_demux.av_st_dout_1         output_mux.av_st_din_1
      if {$vib_vob_removal == 0} {
         add_connection    output_mux.av_st_dout         video_out.av_st_din
      } else {
         set_interface_property  dout_data   export_of   output_mux.av_st_dout
      }
      add_connection    scheduler.av_st_cmd_pm           output_mux.av_st_cmd

   } else {
      #no muxing required
      if {$vib_vob_removal == 0} {
         if { $sep_cores > 0 } {
            add_connection h_scaler_core.av_st_dout      video_out.av_st_din
         } else {
            if { $is_422_in_seq > 0 } {
               add_connection par_to_seq.av_st_dout      video_out.av_st_din
            } else {
               add_connection scaler_core.av_st_dout     video_out.av_st_din
            }
         }
      } else {
         if { $sep_cores > 0 } {
            set_interface_property  dout_data   export_of   h_scaler_core.av_st_dout
         } else {
            if { $is_422_in_seq > 0 } {
               set_interface_property  dout_data   export_of   par_to_seq.av_st_dout
            } else {
               set_interface_property  dout_data   export_of   scaler_core.av_st_dout
            }
         }
      }
   }

   if { $runtime_load > 0 } {
      if { $sep_cores > 0 } {
         add_connection    scheduler.av_st_coeff_0         h_scaler_core.av_st_coeff
         add_connection    scheduler.av_st_coeff_1         v_scaler_core.av_st_coeff
      } else {
         add_connection    scheduler.av_st_coeff_0         scaler_core.av_st_coeff
      }
   }

   if { ($runtime_load > 0) || ([get_parameter_value RUNTIME_CONTROL] > 0) } {
      add_interface           control  avalon      slave
      set_interface_property  control  export_of   scheduler.av_mm_control
   }

}
