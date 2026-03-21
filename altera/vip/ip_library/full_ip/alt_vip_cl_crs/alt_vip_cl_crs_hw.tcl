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
#-- _hw.tcl compose file for the Component Library CRS (CRS II)                                   --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property  NAME           alt_vip_cl_crs
set_module_property  DISPLAY_NAME   "Chroma Resampler II (4K Ready) Intel FPGA IP"
set_module_property  DESCRIPTION    ""


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set_module_property  VALIDATION_CALLBACK  validation_cb
set_module_property  COMPOSITION_CALLBACK composition_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
set max_width $vipsuite_max_width
set max_height $vipsuite_max_height

add_parameter           SHOW_HIDDEN_FEATURES          INTEGER              1
set_parameter_property  SHOW_HIDDEN_FEATURES          ALLOWED_RANGES       0:1
set_parameter_property  SHOW_HIDDEN_FEATURES          AFFECTS_ELABORATION  true
set_parameter_property  SHOW_HIDDEN_FEATURES          HDL_PARAMETER        false
set_parameter_property  SHOW_HIDDEN_FEATURES          VISIBLE              false
set_parameter_property  SHOW_HIDDEN_FEATURES          ALLOWED_RANGES       0:1
set_parameter_property  SHOW_HIDDEN_FEATURES          DISPLAY_HINT         BOOLEAN

add_bits_per_symbol_parameters
set_parameter_property  BITS_PER_SYMBOL               HDL_PARAMETER        false

add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES        VISIBLE              false
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER        false

add_parameter           PIP_IN                        INTEGER              1
set_parameter_property  PIP_IN                        DISPLAY_NAME         "Input pixels in parallel"
set_parameter_property  PIP_IN                        DESCRIPTION          ""
set_parameter_property  PIP_IN                        ALLOWED_RANGES       {1 2 4 8}
set_parameter_property  PIP_IN                        AFFECTS_ELABORATION  true
set_parameter_property  PIP_IN                        HDL_PARAMETER false

add_parameter           PIP_OUT                       INTEGER              1
set_parameter_property  PIP_OUT                       DISPLAY_NAME         "Output pixels in parallel"
set_parameter_property  PIP_OUT                       DESCRIPTION          ""
set_parameter_property  PIP_OUT                       ALLOWED_RANGES       {1 2 4 8}
set_parameter_property  PIP_OUT                       AFFECTS_ELABORATION  true
set_parameter_property  PIP_OUT                       HDL_PARAMETER        false

add_max_dim_parameters  32 $max_width  32 $max_height
set_parameter_property  MAX_WIDTH                     AFFECTS_ELABORATION  true
set_parameter_property  MAX_WIDTH                     HDL_PARAMETER        false
set_parameter_property  MAX_HEIGHT                    AFFECTS_ELABORATION  true
set_parameter_property  MAX_HEIGHT                    HDL_PARAMETER        false

add_parameter           HORIZ_ALGORITHM               STRING               BILINEAR
set_parameter_property  HORIZ_ALGORITHM               DISPLAY_NAME         "Horizontal resampling algorithm"
set_parameter_property  HORIZ_ALGORITHM               ALLOWED_RANGES       {NEAREST_NEIGHBOUR BILINEAR FILTERED}
set_parameter_property  HORIZ_ALGORITHM               AFFECTS_ELABORATION  true
set_parameter_property  HORIZ_ALGORITHM               HDL_PARAMETER        false

add_parameter           HORIZ_CO_SITING               STRING               LEFT
set_parameter_property  HORIZ_CO_SITING               DISPLAY_NAME         "Horzontal chroma siting"
set_parameter_property  HORIZ_CO_SITING               ALLOWED_RANGES       {LEFT CENTRE}
set_parameter_property  HORIZ_CO_SITING               AFFECTS_ELABORATION  true
set_parameter_property  HORIZ_CO_SITING               HDL_PARAMETER        false

add_parameter           HORIZ_ENABLE_LUMA_ADAPT       INTEGER              0
set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT       DISPLAY_NAME         "Enable horizontal luma adaptive resampling"
set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT       ALLOWED_RANGES       0:1
set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT       DISPLAY_HINT         BOOLEAN
set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT       AFFECTS_ELABORATION  true
set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT       HDL_PARAMETER        false

add_parameter           VERT_ALGORITHM                STRING               BILINEAR
set_parameter_property  VERT_ALGORITHM                DISPLAY_NAME         "Vertical resampling algorithm"
set_parameter_property  VERT_ALGORITHM                ALLOWED_RANGES       {NEAREST_NEIGHBOUR BILINEAR FILTERED}
set_parameter_property  VERT_ALGORITHM                AFFECTS_ELABORATION  true
set_parameter_property  VERT_ALGORITHM                HDL_PARAMETER        false
set_parameter_property  VERT_ALGORITHM                VISIBLE              false

add_parameter           VERT_CO_SITING                STRING               TOP
set_parameter_property  VERT_CO_SITING                DISPLAY_NAME         "Vertical chroma siting"
set_parameter_property  VERT_CO_SITING                ALLOWED_RANGES       {TOP CENTRE}
set_parameter_property  VERT_CO_SITING                AFFECTS_ELABORATION  true
set_parameter_property  VERT_CO_SITING                HDL_PARAMETER        false
set_parameter_property  VERT_CO_SITING                VISIBLE              false

add_parameter           VERT_ENABLE_LUMA_ADAPT        INTEGER              0
set_parameter_property  VERT_ENABLE_LUMA_ADAPT        DISPLAY_NAME         "Enable vertical luma adaptive resampling"
set_parameter_property  VERT_ENABLE_LUMA_ADAPT        ALLOWED_RANGES       0:1
set_parameter_property  VERT_ENABLE_LUMA_ADAPT        DISPLAY_HINT         BOOLEAN
set_parameter_property  VERT_ENABLE_LUMA_ADAPT        AFFECTS_ELABORATION  true
set_parameter_property  VERT_ENABLE_LUMA_ADAPT        HDL_PARAMETER        false
set_parameter_property  VERT_ENABLE_LUMA_ADAPT        VISIBLE              false

add_parameter           VARIABLE_SIDE                 STRING               NEITHER
set_parameter_property  VARIABLE_SIDE                 DISPLAY_NAME         "Variable 3 colour interface"
set_parameter_property  VARIABLE_SIDE                 ALLOWED_RANGES       {NEITHER INPUT OUTPUT}
set_parameter_property  VARIABLE_SIDE                 AFFECTS_ELABORATION  true
set_parameter_property  VARIABLE_SIDE                 HDL_PARAMETER        false

add_parameter           ENABLE_444_IN                 INTEGER              0
set_parameter_property  ENABLE_444_IN                 DISPLAY_NAME         "Enable 4:4:4 input"
set_parameter_property  ENABLE_444_IN                 DESCRIPTION          ""
set_parameter_property  ENABLE_444_IN                 ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_444_IN                 AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_444_IN                 HDL_PARAMETER        false
set_parameter_property  ENABLE_444_IN                 DISPLAY_HINT         boolean

add_parameter           ENABLE_422_IN                 INTEGER              1
set_parameter_property  ENABLE_422_IN                 DISPLAY_NAME         "Enable 4:2:2 input"
set_parameter_property  ENABLE_422_IN                 DESCRIPTION          ""
set_parameter_property  ENABLE_422_IN                 ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_422_IN                 AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_422_IN                 HDL_PARAMETER        false
set_parameter_property  ENABLE_422_IN                 DISPLAY_HINT         boolean

add_parameter           ENABLE_420_IN                 INTEGER              0
set_parameter_property  ENABLE_420_IN                 DISPLAY_NAME         "Enable 4:2:0 input"
set_parameter_property  ENABLE_420_IN                 DESCRIPTION          ""
set_parameter_property  ENABLE_420_IN                 ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_420_IN                 AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_420_IN                 HDL_PARAMETER        false
set_parameter_property  ENABLE_420_IN                 DISPLAY_HINT         boolean

add_parameter           ENABLE_444_OUT                INTEGER              1
set_parameter_property  ENABLE_444_OUT                DISPLAY_NAME         "Enable 4:4:4 output"
set_parameter_property  ENABLE_444_OUT                DESCRIPTION          ""
set_parameter_property  ENABLE_444_OUT                ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_444_OUT                AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_444_OUT                HDL_PARAMETER        false
set_parameter_property  ENABLE_444_OUT                DISPLAY_HINT         boolean

add_parameter           ENABLE_422_OUT                INTEGER              0
set_parameter_property  ENABLE_422_OUT                DISPLAY_NAME         "Enable 4:2:2 output"
set_parameter_property  ENABLE_422_OUT                DESCRIPTION          ""
set_parameter_property  ENABLE_422_OUT                ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_422_OUT                AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_422_OUT                HDL_PARAMETER        false
set_parameter_property  ENABLE_422_OUT                DISPLAY_HINT         boolean

add_parameter           ENABLE_420_OUT                INTEGER              0
set_parameter_property  ENABLE_420_OUT                DISPLAY_NAME         "Enable 4:2:0 output"
set_parameter_property  ENABLE_420_OUT                DESCRIPTION          ""
set_parameter_property  ENABLE_420_OUT                ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_420_OUT                AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_420_OUT                HDL_PARAMETER        false
set_parameter_property  ENABLE_420_OUT                DISPLAY_HINT         boolean

add_user_packet_support_parameters
set_parameter_property  USER_PACKET_FIFO_DEPTH        HDL_PARAMETER        false
set_parameter_property  USER_PACKET_SUPPORT           HDL_PARAMETER        false
set_parameter_property  USER_PACKET_FIFO_DEPTH        VISIBLE              false

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Add extra pipelining registers"
set_parameter_property  PIPELINE_READY                DESCRIPTION          ""
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION  true
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        false
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean

add_parameter           LIMITED_READBACK              INTEGER              0
set_parameter_property  LIMITED_READBACK              DISPLAY_NAME         "Reduced control slave register readback"
set_parameter_property  LIMITED_READBACK              DESCRIPTION          ""
set_parameter_property  LIMITED_READBACK              ALLOWED_RANGES       0:1
set_parameter_property  LIMITED_READBACK              AFFECTS_ELABORATION  true
set_parameter_property  LIMITED_READBACK              HDL_PARAMETER        false
set_parameter_property  LIMITED_READBACK              DISPLAY_HINT         boolean

add_display_item        "General"                     HORIZ_ALGORITHM                  parameter
add_display_item        "General"                     HORIZ_CO_SITING                  parameter
add_display_item        "General"                     HORIZ_ENABLE_LUMA_ADAPT          parameter
add_display_item        "General"                     VERT_ALGORITHM                   parameter
add_display_item        "General"                     VERT_CO_SITING                   parameter
add_display_item        "General"                     VERT_ENABLE_LUMA_ADAPT           parameter
add_display_item        "General"                     MAX_WIDTH                        parameter
add_display_item        "General"                     MAX_HEIGHT                       parameter
add_display_item        "General"                     USER_PACKET_SUPPORT              parameter
add_display_item        "General"                     PIPELINE_READY                   parameter
add_display_item        "General"                     LIMITED_READBACK                 parameter

add_display_item        "Interface setup"             COLOR_PLANES_ARE_IN_PARALLEL     parameter
add_display_item        "Interface setup"             BITS_PER_SYMBOL                  parameter
add_display_item        "Interface setup"             PIP_IN                           parameter
add_display_item        "Interface setup"             PIP_OUT                          parameter
add_display_item        "Interface setup"             PIXELS_IN_PARALLEL               parameter
add_display_item        "Interface setup"             VARIABLE_SIDE                    parameter

add_display_item        "Input format"                ENABLE_444_IN                    parameter
add_display_item        "Input format"                ENABLE_422_IN                    parameter
add_display_item        "Input format"                ENABLE_420_IN                    parameter

add_display_item        "Output format"               ENABLE_444_OUT                   parameter
add_display_item        "Output format"               ENABLE_422_OUT                   parameter
add_display_item        "Output format"               ENABLE_420_OUT                   parameter

proc validation_cb {} {

   set  show_hidden       [get_parameter_value SHOW_HIDDEN_FEATURES]

   if { $show_hidden > 0 } {

      set_parameter_property  ENABLE_420_IN           VISIBLE              true
      set_parameter_property  ENABLE_420_OUT          VISIBLE              true
      set_parameter_property  VARIABLE_SIDE           VISIBLE              true
      set_parameter_property  PIP_IN                  VISIBLE              true
      set_parameter_property  PIP_OUT                 VISIBLE              true
      set_parameter_property  PIXELS_IN_PARALLEL      VISIBLE              false
      set_parameter_property  LIMITED_READBACK        VISIBLE              true
      set_parameter_property  VERT_ALGORITHM          VISIBLE              true
      set_parameter_property  VERT_CO_SITING          VISIBLE              true
      set_parameter_property  VERT_ENABLE_LUMA_ADAPT  VISIBLE              true

      set   enable_420_in                       [get_parameter_value ENABLE_420_IN]
      set   enable_420_out                      [get_parameter_value ENABLE_420_OUT]
      set   enable_444_in                       [get_parameter_value ENABLE_444_IN]
      set   enable_422_in                       [get_parameter_value ENABLE_422_IN]
      set   enable_444_out                      [get_parameter_value ENABLE_444_OUT]
      set   enable_422_out                      [get_parameter_value ENABLE_422_OUT]
      set   modes_in                            [expr $enable_444_in + $enable_422_in + $enable_420_in]
      set   modes_out                           [expr $enable_420_out + $enable_422_out + $enable_444_out]
      set   pip_in                              [get_parameter_value PIP_IN]
      set   pip_out                             [get_parameter_value PIP_OUT]
      set   colours_in_par                      [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]

      set   comp                                [get_parameter_value VARIABLE_SIDE]
      set   match                               [string compare $comp INPUT]
      if { $match == 0 } {
         set   input_variable                   1
      } else {
         set   input_variable                   0
      }
      set   match                               [string compare $comp OUTPUT]
      if { $match == 0 } {
         set   output_variable                  1
      } else {
         set   output_variable                  0
      }

      if { $modes_in == 0 } {
         send_message Error "You must select at least one input format"
      }

      if { $modes_out == 0 } {
         send_message Error "You must select at least one output format"
      }

      if { $modes_in == 1 } {
         if { $modes_out == 1 } {
            if { $enable_422_in > 0 } {
               if { $enable_422_out > 0 } {
                  send_message Error "The Chroma Resampler II does not support fixed 4:2:2->4:2:2 conversion"
               }
            } else {
               if { $enable_444_in > 0 } {
                  if { $enable_444_out > 0 } {
                     send_message Error "The Chroma Resampler II does not support fixed 4:4:4->4:4:4 conversion"
                  }
               }
            }
         }
      }

      if { $input_variable == 0 } {
         if { $modes_in > 1 } {
            send_message Error "Variable 3 colour interface must be set to INPUT to enable more than one input format"
         }
         if { $enable_420_in > 0 } {
            send_message Error "Variable 3 colour interface must be set to INPUT to enable 4:2:0 input format"
         }
      }

      if { $output_variable == 0 } {
         if { $modes_out > 1 } {
            send_message Error "Variable 3 colour interface must be set to OUTPUT to enable more than one output format"
         }
         if { $enable_420_out > 0 } {
            send_message Error "Variable 3 colour interface must be set to OUTPUT to enable 4:2:0 output format"
         }
      }

      if { $input_variable == 1 } {
         if { $pip_in != $pip_out } {
            if { [expr $pip_in * 2] != $pip_out } {
               send_message Error "With a variable input interface the number of pixels in parallel out must be the same as or double the number of pixels in parallel in"
            }
         }
      } else {
         if { $output_variable == 1 } {
            if { $pip_in != $pip_out } {
               if { [expr $pip_out * 2] != $pip_in } {
                  send_message Error "With a variable output interface the number of pixels in parallel in must be the same as or double the number of pixels in parallel out"
               }
            }
         } else {
            if { $pip_in != $pip_out } {
               send_message Error "With neither interface set to variable the number of pixels in parallel in must be the same as the number of pixels in parallel out"
            }
         }
      }

      if { $colours_in_par == 0 } {
         if { $pip_in > 1 } {
            send_message Error "Input pixels in parallel > 1 is not supported for colour planes in sequence"
         }
         if { $pip_out > 1 } {
            send_message Error "Output pixels in parallel > 1 is not supported for colour planes in sequence"
         }
         if { $enable_420_in > 0 } {
            send_message Error "4:2:0 input is not supported for colour planes in sequence"
         }
         if { $enable_420_out > 0 } {
            send_message Error "4:2:0 output is not supported for colour planes in sequence"
         }
      }

      set   comp                                [get_parameter_value VERT_ALGORITHM]
      set   match                               [string compare $comp FILTERED]
      if { $match == 0 } {
         set_parameter_property  VERT_CO_SITING             ENABLED   true
         if { $enable_420_in > 0 } {
            set_parameter_property  VERT_ENABLE_LUMA_ADAPT  ENABLED   true
         } else {
            set_parameter_property  VERT_ENABLE_LUMA_ADAPT  ENABLED   false
         }
      } else {
         set_parameter_property  VERT_CO_SITING             ENABLED   false
         set_parameter_property  VERT_ENABLE_LUMA_ADAPT     ENABLED   false
      }

      set   comp                                [get_parameter_value HORIZ_ALGORITHM]
      set   match                               [string compare $comp FILTERED]
      if { $match == 0 } {
         set_parameter_property  HORIZ_CO_SITING             ENABLED   true
         if { $enable_444_out > 0 } {
            if { [expr $enable_422_in + $enable_420_in] > 0 } {
               set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT  ENABLED   true
            } else {
               set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT  ENABLED   false
            }
         } else {
            set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT  ENABLED   false
         }
      } else {
         set_parameter_property  HORIZ_CO_SITING             ENABLED   false
         set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT     ENABLED   false
      }

   } else {

      set_parameter_property  ENABLE_420_IN           VISIBLE              false
      set_parameter_property  ENABLE_420_OUT          VISIBLE              false
      set_parameter_property  VARIABLE_SIDE           VISIBLE              false
      set_parameter_property  PIP_IN                  VISIBLE              false
      set_parameter_property  PIP_OUT                 VISIBLE              false
      set_parameter_property  PIXELS_IN_PARALLEL      VISIBLE              true
      set_parameter_property  LIMITED_READBACK        VISIBLE              false
      set_parameter_property  VERT_ALGORITHM          VISIBLE              false
      set_parameter_property  VERT_CO_SITING          VISIBLE              false
      set_parameter_property  VERT_ENABLE_LUMA_ADAPT  VISIBLE              false

      set   enable_444_in                       [get_parameter_value ENABLE_444_IN]
      set   enable_422_in                       [get_parameter_value ENABLE_422_IN]
      set   enable_444_out                      [get_parameter_value ENABLE_444_OUT]
      set   enable_422_out                      [get_parameter_value ENABLE_422_OUT]
      set   pip                                 [get_parameter_value PIXELS_IN_PARALLEL]
      set   colours_in_par                      [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]

      if { $enable_444_in > 0 } {
         if { $enable_422_in > 0 } {
            send_message Error "Input format can be either 4:4:4 or 4:2:2, but not both"
         }
         if { $enable_444_out > 0 } {
            if { $enable_422_out > 0 } {
               send_message Error "Output format can be either 4:4:4 or 4:2:2, but not both"
            }
         }
         if { $enable_422_out == 0 } {
            send_message Error "For an input format of 4:4:4, the output format must be set to 4:2:2"
         }
      } else {
         if { $enable_422_in > 0 } {
            if { $enable_422_out > 0 } {
               if { $enable_444_out > 0 } {
                  send_message Error "Output format can be either 4:4:4 or 4:2:2, but not both"
               }
            }
            if { $enable_444_out == 0 } {
               send_message Error "For an input format of 4:2:2, the output format must be set to 4:2:2"
            }
         } else {
            send_message Error "You must select either 4:4:4 or 4:2:2 for the input format"
         }
      }

      if { $colours_in_par == 0 } {
         if { $pip > 1 } {
            send_message Error "Pixels in parallel > 1 is not supported for colour planes in sequence"
         }
      }

      set   comp                                [get_parameter_value HORIZ_ALGORITHM]
      set   match                               [string compare $comp FILTERED]
      if { $match == 0 } {
         set_parameter_property  HORIZ_CO_SITING             ENABLED   true
         if { $enable_444_out > 0 } {
            set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT  ENABLED   true
         } else {
            set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT  ENABLED   false
         }
      } else {
         set_parameter_property  HORIZ_CO_SITING             ENABLED   false
         set_parameter_property  HORIZ_ENABLE_LUMA_ADAPT     ENABLED   false
      }

   }

}

proc composition_cb {} {
   global isVersion acdsVersion vib_vob_removal

   set  show_hidden       [get_parameter_value SHOW_HIDDEN_FEATURES]
   if { $show_hidden > 0 } {
      set   enable_420_in                       [get_parameter_value ENABLE_420_IN]
      set   enable_420_out                      [get_parameter_value ENABLE_420_OUT]
      set   comp                                [get_parameter_value VARIABLE_SIDE]
      set   match                               [string compare $comp INPUT]
      if { $match == 0 } {
         set   variable_input                   1
      } else {
         set   variable_input                   0
      }
      set   match                               [string compare $comp OUTPUT]
      if { $match == 0 } {
         set   variable_output                  1
      } else {
         set   variable_output                  0
      }
      set   pip_in                              [get_parameter_value PIP_IN]
      set   pip_out                             [get_parameter_value PIP_OUT]
   } else {
      set   enable_420_in                       0
      set   enable_420_out                      0
      set   variable_input                      0
      set   variable_output                     0
      set   pip_in                              [get_parameter_value PIXELS_IN_PARALLEL]
      set   pip_out                             [get_parameter_value PIXELS_IN_PARALLEL]
   }
   set   enable_444_in                       [get_parameter_value ENABLE_444_IN]
   set   enable_422_in                       [get_parameter_value ENABLE_422_IN]
   set   enable_444_out                      [get_parameter_value ENABLE_444_OUT]
   set   enable_422_out                      [get_parameter_value ENABLE_422_OUT]
   set   modes_in                            [expr $enable_444_in + $enable_422_in + $enable_420_in]
   set   modes_out                           [expr $enable_420_out + $enable_422_out + $enable_444_out]

   if { $variable_input > 0 } {
      set   input_colours                    3
      if { $enable_444_out > 0 } {
         set   output_colours                3
      } else {
         set   output_colours                2
      }
   } else {
      if { $variable_output > 0 } {
         set   output_colours                3
         if { $enable_444_in > 0 } {
            set   input_colours                 3
         } else {
            set   input_colours                 2
         }
      } else {
         if { $enable_444_in > 0 } {
            set   input_colours                 3
         } else {
            set   input_colours                 2
         }
         if { $enable_444_out > 0 } {
            set   output_colours                3
         } else {
            set   output_colours                2
         }
      }
   }
   set   enable_420                          [expr $enable_420_in + $enable_420_out]
   set   comp                                [get_parameter_value USER_PACKET_SUPPORT]
   set   match                               [string compare   $comp PASSTHROUGH]
   if { $match == 0 } {
      set   enable_user                      1
   } else {
      set   enable_user                      0
   }
   set   match                               [string compare   $comp DISCARD]
   if { $match == 0 } {
      set   enable_discard                   1
   } else {
      set   enable_discard                   0
   }
   set   complex_mode                        0
   set   enable_vib_cmd                      0
   set   enable_lb_cmd                       0
   set   enable_mm_cmd                       0
   set   enable_om_cmd                       0
   set   control_exists                      0
   if { $modes_in > 1 } {
      set   complex_mode                     1
      set   enable_vib_cmd                   1
      set   control_exists                   1
   }
   if { $modes_out > 1 } {
      set   complex_mode                     1
      set   enable_vib_cmd                   1
      set   control_exists                   1
   }
   if { $enable_user > 0 } {
      set   complex_mode                     1
      set   enable_vib_cmd                   1
   }
   if { $enable_discard > 0 } {
      set   complex_mode                     1
      set   enable_vib_cmd                   1
   }
   if {  $enable_420 > 0 } {
      set   complex_mode                     1
      set   enable_lb_cmd                    1
   }
   if { $variable_output > 0 } {
      set   enable_444_or_user               [expr $enable_444_out + $enable_user]
      set   enable_444_or_user_or_422        [expr $enable_444_or_user + $enable_422_out]
      set   enable_om_cmd                    [expr $enable_444_or_user_or_422 * $enable_420_out]
      if { $enable_422_in > 0 } {
         if { $enable_444_or_user_or_422 > 1 } {
            set   enable_mm_cmd              1
         }
      } else {
         set   enable_mm_cmd                 [expr $enable_444_or_user * $enable_422_out]
      }
   } else {
      if { $variable_input > 0 } {
         set   enable_444_or_user               [expr $enable_444_in + $enable_user]
         if { $enable_422_out > 0 } {
            set   enable_444_or_user_or_422     [expr $enable_444_or_user + $enable_422_in]
            if { $enable_444_or_user_or_422 > 1 } {
               set   enable_mm_cmd              1
            }
            set   enable_om_cmd                 [expr $enable_444_or_user_or_422 * $enable_420_in]
         } else {
            set   enable_om_cmd                 $enable_444_or_user
            set   enable_mm_cmd                 [expr $enable_420_in * $enable_422_in]
         }
      } else {
         if { $enable_user > 0 } {
            set   enable_mm_cmd                 1
         }
      }
   }

   # --------------------------------------------------------------------------------------------------
   # -- Clock/reset bridges                                                                          --
   # --------------------------------------------------------------------------------------------------
   add_instance      av_st_clk_bridge              altera_clock_bridge        $acdsVersion
   add_instance      av_st_reset_bridge            altera_reset_bridge        $acdsVersion

   # --------------------------------------------------------------------------------------------------
   # -- sub-components                                                                              --
   # --------------------------------------------------------------------------------------------------

   if {$vib_vob_removal == 0} {
      add_instance   video_in_resp        alt_vip_video_input_bridge_resp  $isVersion
      add_instance   video_out            alt_vip_video_output_bridge      $isVersion

      set_instance_parameter_value  video_in_resp     VIB_MODE                      FULL
      set_instance_parameter_value  video_in_resp     ENABLE_RESOLUTION_CHECK       $enable_420
      set_instance_parameter_value  video_in_resp     READY_LATENCY_1               1
      set_instance_parameter_value  video_in_resp     MULTI_CONTEXT_SUPPORT         0
      set_instance_parameter_value  video_in_resp     PIPELINE_READY                [get_parameter_value PIPELINE_READY]
      set_instance_parameter_value  video_in_resp     BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
      set_instance_parameter_value  video_in_resp     NUMBER_OF_COLOR_PLANES        $input_colours
      set_instance_parameter_value  video_in_resp     COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  video_in_resp     DEFAULT_LINE_LENGTH           [get_parameter_value MAX_WIDTH]
      set_instance_parameter_value  video_in_resp     PIXELS_IN_PARALLEL            $pip_in
      set_instance_parameter_value  video_in_resp     VIDEO_PROTOCOL_NO             1
      set_instance_parameter_value  video_in_resp     MAX_WIDTH                     [get_parameter_value MAX_WIDTH]
      set_instance_parameter_value  video_in_resp     MAX_HEIGHT                    [get_parameter_value MAX_HEIGHT]
      set_instance_parameter_value  video_in_resp     SRC_WIDTH                     8
      set_instance_parameter_value  video_in_resp     DST_WIDTH                     8
      set_instance_parameter_value  video_in_resp     CONTEXT_WIDTH                 8
      set_instance_parameter_value  video_in_resp     TASK_WIDTH                    8
      set_instance_parameter_value  video_in_resp     RESP_SRC_ADDRESS              0
      set_instance_parameter_value  video_in_resp     RESP_DST_ADDRESS              0
      set_instance_parameter_value  video_in_resp     DATA_SRC_ADDRESS              0

      set_instance_parameter_value  video_out         SOP_PRE_ALIGNED               0
      set_instance_parameter_value  video_out         NO_CONCATENATION              0
      set_instance_parameter_value  video_out         BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
      set_instance_parameter_value  video_out         NUMBER_OF_COLOR_PLANES        $output_colours
      set_instance_parameter_value  video_out         COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  video_out         PIXELS_IN_PARALLEL            $pip_out
      set_instance_parameter_value  video_out         VIDEO_PROTOCOL_NO             1
      set_instance_parameter_value  video_out         READY_LATENCY_1               1
      set_instance_parameter_value  video_out         MULTI_CONTEXT_SUPPORT         0
      set_instance_parameter_value  video_out         LOW_LATENCY_COMMAND_MODE      0
      set_instance_parameter_value  video_out         SRC_WIDTH                     8
      set_instance_parameter_value  video_out         DST_WIDTH                     8
      set_instance_parameter_value  video_out         CONTEXT_WIDTH                 8
      set_instance_parameter_value  video_out         TASK_WIDTH                    8
      set_instance_parameter_value  video_out         PIPELINE_READY                [get_parameter_value PIPELINE_READY]
   }

   # the actual crs core
   if { $variable_input > 0 } {
      # variable input side modes

      if { $enable_422_out > 0 } {
         # variable to 422 conversion
         add_instance   inst_crs_int   alt_vip_cl_crs_var_to_422  $isVersion
         set_instance_parameter_value  inst_crs_int   VERT_ENABLE_LUMA_ADAPT  [get_parameter_value VERT_ENABLE_LUMA_ADAPT]
      } else {
         # variable to 444 conversion
         add_instance   inst_crs_int   alt_vip_cl_crs_var_to_444  $isVersion
         set_instance_parameter_value  inst_crs_int   VERT_ENABLE_LUMA_ADAPT  [get_parameter_value VERT_ENABLE_LUMA_ADAPT]
         set_instance_parameter_value  inst_crs_int   HORIZ_ENABLE_LUMA_ADAPT [get_parameter_value HORIZ_ENABLE_LUMA_ADAPT]
      }

      set_instance_parameter_value  inst_crs_int   ENABLE_422                    [get_parameter_value ENABLE_422_IN]
      set_instance_parameter_value  inst_crs_int   ENABLE_444                    [get_parameter_value ENABLE_444_IN]
      set_instance_parameter_value  inst_crs_int   ENABLE_420                    [get_parameter_value ENABLE_420_IN]

   } else {

      if { $variable_output > 0 } {
         # variable output side modes

         if { $enable_422_in > 0 } {
            # 422 to variable conversion
            add_instance   inst_crs_int   alt_vip_cl_crs_422_to_var  $isVersion
            set_instance_parameter_value  inst_crs_int   HORIZ_ENABLE_LUMA_ADAPT [get_parameter_value HORIZ_ENABLE_LUMA_ADAPT]
         } else {
            # 444 to variable conversion
            add_instance   inst_crs_int   alt_vip_cl_crs_444_to_var  $isVersion
         }

         set_instance_parameter_value  inst_crs_int   ENABLE_422                    [get_parameter_value ENABLE_422_OUT]
         set_instance_parameter_value  inst_crs_int   ENABLE_444                    [get_parameter_value ENABLE_444_OUT]
         set_instance_parameter_value  inst_crs_int   ENABLE_420                    [get_parameter_value ENABLE_420_OUT]

      } else {

         # simple conversion modes (422->444 or vice versa)
         if { $enable_422_out > 0 } {
            # 444 to 422 conversion
            add_instance   inst_crs_int   alt_vip_cl_crs_var_to_422  $isVersion
         } else {
            # 422 to 444 conversion
            add_instance   inst_crs_int   alt_vip_cl_crs_422_to_var  $isVersion
            set_instance_parameter_value  inst_crs_int   HORIZ_ENABLE_LUMA_ADAPT [get_parameter_value HORIZ_ENABLE_LUMA_ADAPT]
         }

         set_instance_parameter_value  inst_crs_int   ENABLE_422                    0
         set_instance_parameter_value  inst_crs_int   ENABLE_444                    1
         set_instance_parameter_value  inst_crs_int   ENABLE_420                    0

      }

   }

   set_instance_parameter_value  inst_crs_int   VERT_ALGORITHM                [get_parameter_value VERT_ALGORITHM]
   set_instance_parameter_value  inst_crs_int   VERT_CO_SITING                [get_parameter_value VERT_CO_SITING]
   set_instance_parameter_value  inst_crs_int   HORIZ_ALGORITHM               [get_parameter_value HORIZ_ALGORITHM]
   set_instance_parameter_value  inst_crs_int   HORIZ_CO_SITING               [get_parameter_value HORIZ_CO_SITING]
   set_instance_parameter_value  inst_crs_int   BITS_PER_SYMBOL               [get_parameter_value BITS_PER_SYMBOL]
   set_instance_parameter_value  inst_crs_int   COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set_instance_parameter_value  inst_crs_int   PIP_IN                        $pip_in
   set_instance_parameter_value  inst_crs_int   PIP_OUT                       $pip_out
   set_instance_parameter_value  inst_crs_int   PIPELINE_READY                [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  inst_crs_int   MAX_HEIGHT                    [get_parameter_value MAX_HEIGHT]
   set_instance_parameter_value  inst_crs_int   MAX_WIDTH                     [get_parameter_value MAX_WIDTH]
   set_instance_parameter_value  inst_crs_int   USER_PACKET_SUPPORT           [get_parameter_value USER_PACKET_SUPPORT]

   if { $complex_mode > 0 } {

      # in any complex mode we need a scheduler
      add_instance   scheduler   alt_vip_crs_scheduler   $isVersion

      set_instance_parameter_value  scheduler      ENABLE_422_IN                 [get_parameter_value ENABLE_422_IN]
      set_instance_parameter_value  scheduler      ENABLE_444_IN                 [get_parameter_value ENABLE_444_IN]
      set_instance_parameter_value  scheduler      ENABLE_420_IN                 [get_parameter_value ENABLE_420_IN]
      set_instance_parameter_value  scheduler      ENABLE_422_OUT                [get_parameter_value ENABLE_422_OUT]
      set_instance_parameter_value  scheduler      ENABLE_444_OUT                [get_parameter_value ENABLE_444_OUT]
      set_instance_parameter_value  scheduler      ENABLE_420_OUT                [get_parameter_value ENABLE_420_OUT]
      set_instance_parameter_value  scheduler      ALGORITHM                     [get_parameter_value VERT_ALGORITHM]
      set_instance_parameter_value  scheduler      PIPELINE_READY                [get_parameter_value PIPELINE_READY]
      set_instance_parameter_value  scheduler      USER_PACKET_SUPPORT           [get_parameter_value USER_PACKET_SUPPORT]
      set_instance_parameter_value  scheduler      LIMITED_READBACK              [get_parameter_value LIMITED_READBACK]
      set_instance_parameter_value  scheduler      VARIABLE_SIDE                 [get_parameter_value VARIABLE_SIDE]
      set_instance_parameter_value  scheduler      CO_SITING                     [get_parameter_value VERT_CO_SITING]

   }

   # --------------------------------------------------------------------------------------------------
   # -- connections                                                                                  --
   # --------------------------------------------------------------------------------------------------

   add_connection    av_st_clk_bridge.out_clk      av_st_reset_bridge.clk
   add_connection    av_st_clk_bridge.out_clk      inst_crs_int.main_clock
   add_connection    av_st_reset_bridge.out_reset  inst_crs_int.main_reset

   if {$vib_vob_removal == 0} {
      add_connection    av_st_clk_bridge.out_clk      video_in_resp.main_clock
      add_connection    av_st_reset_bridge.out_reset  video_in_resp.main_reset
      add_connection    av_st_clk_bridge.out_clk      video_out.main_clock
      add_connection    av_st_reset_bridge.out_reset  video_out.main_reset
      add_connection    video_in_resp.av_st_dout      inst_crs_int.av_st_din
      add_connection    inst_crs_int.av_st_dout       video_out.av_st_din
   }

   if { $complex_mode > 0 } {

      add_connection    av_st_clk_bridge.out_clk      scheduler.main_clock
      add_connection    av_st_reset_bridge.out_reset  scheduler.main_reset

      if { $enable_vib_cmd > 0 } {
         add_connection    scheduler.av_st_cmd_vib                inst_crs_int.av_st_vib_cmd
      }
      if { $enable_lb_cmd > 0 } {
         add_connection    scheduler.av_st_cmd_line_buffer        inst_crs_int.av_st_lb_cmd
         add_connection    scheduler.av_st_cmd_vert_resample      inst_crs_int.av_st_vert_cmd
      }
      if { $enable_om_cmd > 0 } {
         add_connection    scheduler.av_st_cmd_output_mux         inst_crs_int.av_st_om_cmd
      }
      if { $enable_mm_cmd > 0 } {
         add_connection    scheduler.av_st_cmd_middle_mux         inst_crs_int.av_st_mm_cmd
      }
      if {$vib_vob_removal == 0} {
         add_connection       video_in_resp.av_st_resp               scheduler.av_st_resp_vib
         add_connection       scheduler.av_st_cmd_vob                video_out.av_st_cmd
      }

   } else {
      if {$vib_vob_removal == 0} {
         add_connection video_in_resp.av_st_resp      video_out.av_st_cmd
      }
   }

   # --------------------------------------------------------------------------------------------------
   # -- top level interface                                                                          --
   # --------------------------------------------------------------------------------------------------

   add_interface           main_clock  clock             end
   add_interface           main_reset  reset             end
   set_interface_property  main_clock  PORT_NAME_MAP     {main_clock in_clk}
   set_interface_property  main_reset  PORT_NAME_MAP     {main_reset in_reset}
   set_interface_property  main_clock     export_of      av_st_clk_bridge.in_clk
   set_interface_property  main_reset     export_of      av_st_reset_bridge.in_reset

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
      set_interface_property  din_data    export_of         inst_crs_int.av_st_din
      set_interface_property  dout_data   export_of         inst_crs_int.av_st_dout
      if { $complex_mode > 0 } {
         set_interface_property  din_aux     export_of         scheduler.av_st_resp_vib
         set_interface_property  dout_aux    export_of         scheduler.av_st_cmd_vob
      }
    }

   if { $control_exists > 0 } {
      add_interface           control  avalon      slave
      set_interface_property  control  export_of   scheduler.av_mm_control
   }

}
