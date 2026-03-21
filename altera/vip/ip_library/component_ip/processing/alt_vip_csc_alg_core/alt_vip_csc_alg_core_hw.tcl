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

# ------------------------------------------------------------------------------------------------------------
# --                                                                                                        --
# -- General information for the CSC algorithmic core module                                            --
# -- This block sinks Avalon-ST Message Data packets from a single source and crops data from the start     --
# -- and/or end of the packet as per the commands issued through the Avalon-ST Message Command interface.   --
# -- The resulting packets are output through a single Avalon-ST Message Data source                        --
# --                                                                                                        --
# ------------------------------------------------------------------------------------------------------------

# Common module properties for VIP components
declare_general_component_info

# Component specific properties
set_module_property  NAME                    alt_vip_csc_alg_core
set_module_property  DISPLAY_NAME            "CSC Algorithmic Core"
set_module_property  DESCRIPTION             "Converts between color spaces"
set_module_property  VALIDATION_CALLBACK     validation_callback
set_module_property  ELABORATION_CALLBACK    elaboration_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_alt_vip_common_pkg_files                 ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_round_sat_files           ../../..
add_alt_vip_common_mult_add_files            ../../..
add_static_sv_file                           src_hdl/alt_vip_csc_alg_core.sv
add_static_misc_file                         src_hdl/alt_vip_csc_alg_core.ocp
setup_filesets                               "" generate_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

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

# adds NUMBER_OF_COLOR_PLANES and COLOR_PLANES_ARE_IN_PARALLEL, disable NUMBER_OF_COLOR_PLANES
add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES       DEFAULT_VALUE         3
set_parameter_property  NUMBER_OF_COLOR_PLANES       ENABLED               false
set_parameter_property  NUMBER_OF_COLOR_PLANES       VISIBLE               false
set_parameter_property  NUMBER_OF_COLOR_PLANES       HDL_PARAMETER         false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER         false

# adds PIXELS_IN_PARALLEL
add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER         false

add_parameter           MOVE_BINARY_POINT_RIGHT      INTEGER               0 
set_parameter_property  MOVE_BINARY_POINT_RIGHT      DISPLAY_NAME          "Move binary point right"
set_parameter_property  MOVE_BINARY_POINT_RIGHT      DESCRIPTION           "Specify the number of places to move the binary point."
set_parameter_property  MOVE_BINARY_POINT_RIGHT      ALLOWED_RANGES        -16:16
set_parameter_property  MOVE_BINARY_POINT_RIGHT      AFFECTS_ELABORATION   false 
set_parameter_property  MOVE_BINARY_POINT_RIGHT      HDL_PARAMETER         false

add_parameter           ROUNDING_METHOD               string                  ROUND_HALF_UP
set_parameter_property  ROUNDING_METHOD               DISPLAY_NAME            "Rounding method"
set_parameter_property  ROUNDING_METHOD               ALLOWED_RANGES          {TRUNCATE ROUND_HALF_UP ROUND_HALF_EVEN}
set_parameter_property  ROUNDING_METHOD               DESCRIPTION             "Selects the method used to round the filter output to the final precision"
set_parameter_property  ROUNDING_METHOD               HDL_PARAMETER           false
set_parameter_property  ROUNDING_METHOD               AFFECTS_ELABORATION     false

add_parameter           RUNTIME_CONTROL               INTEGER                 1
set_parameter_property  RUNTIME_CONTROL               DISPLAY_NAME            "Enable runtime control"
set_parameter_property  RUNTIME_CONTROL               ALLOWED_RANGES          0:1
set_parameter_property  RUNTIME_CONTROL               DISPLAY_HINT            boolean
set_parameter_property  RUNTIME_CONTROL               HDL_PARAMETER           false
set_parameter_property  RUNTIME_CONTROL               AFFECTS_ELABORATION     true

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

add_parameter           SUMMAND_SIGNED                INTEGER                 1
set_parameter_property  SUMMAND_SIGNED                DISPLAY_NAME            "Use signed summands"
set_parameter_property  SUMMAND_SIGNED                ALLOWED_RANGES          0:1
set_parameter_property  SUMMAND_SIGNED                DISPLAY_HINT            boolean
set_parameter_property  SUMMAND_SIGNED                DESCRIPTION             "Forces the algorithm to use signed summand data"
set_parameter_property  SUMMAND_SIGNED                HDL_PARAMETER           false
set_parameter_property  SUMMAND_SIGNED                AFFECTS_ELABORATION     true

add_parameter           SUMMAND_INTEGER_BITS          INTEGER                 1
set_parameter_property  SUMMAND_INTEGER_BITS          DISPLAY_NAME            "Summand integer bits"
set_parameter_property  SUMMAND_INTEGER_BITS          ALLOWED_RANGES          0:20
set_parameter_property  SUMMAND_INTEGER_BITS          DESCRIPTION             "Number of integer bits for each summand"
set_parameter_property  SUMMAND_INTEGER_BITS          HDL_PARAMETER           false
set_parameter_property  SUMMAND_INTEGER_BITS          AFFECTS_ELABORATION     true

add_parameter           SUMMAND_FRACTION_BITS         INTEGER                 7
set_parameter_property  SUMMAND_FRACTION_BITS         DISPLAY_NAME            "Summand fraction bits"
set_parameter_property  SUMMAND_FRACTION_BITS         ALLOWED_RANGES          0:24
set_parameter_property  SUMMAND_FRACTION_BITS         DESCRIPTION             "Number of fraction bits for each summand"
set_parameter_property  SUMMAND_FRACTION_BITS         HDL_PARAMETER           false
set_parameter_property  SUMMAND_FRACTION_BITS         AFFECTS_ELABORATION     true

foreach name {A B C} {
   foreach id {0 1 2} {
      add_parameter           COEFFICIENT_$name$id    INTEGER                 0 
      set_parameter_property  COEFFICIENT_$name$id    DISPLAY_NAME            "$name$id coefficient"
      set_parameter_property  COEFFICIENT_$name$id    DESCRIPTION             "The coefficient $name$id"
      set_parameter_property  COEFFICIENT_$name$id    ALLOWED_RANGES          -2147483648:2147483647
      set_parameter_property  COEFFICIENT_$name$id    AFFECTS_ELABORATION     false
      set_parameter_property  COEFFICIENT_$name$id    HDL_PARAMETER           false
   }
}

foreach id {0 1 2} {
   add_parameter              COEFFICIENT_S$id        INTEGER                 0
   set_parameter_property     COEFFICIENT_S$id        DISPLAY_NAME            "S$id summand"
   set_parameter_property     COEFFICIENT_S$id        DESCRIPTION             "The summand S$id"
   set_parameter_property     COEFFICIENT_S$id        ALLOWED_RANGES          -2147483648:2147483647
   set_parameter_property     COEFFICIENT_S$id        AFFECTS_ELABORATION     false
   set_parameter_property     COEFFICIENT_S$id        HDL_PARAMETER           false
}

# adds SRC_WIDTH, DST_WIDTH, CONTEXT_WIDTH, TASK_WIDTH
add_av_st_event_parameters
set_parameter_property  DST_WIDTH                     HDL_PARAMETER           false
set_parameter_property  SRC_WIDTH                     HDL_PARAMETER           false
set_parameter_property  TASK_WIDTH                    HDL_PARAMETER           false
set_parameter_property  CONTEXT_WIDTH                 HDL_PARAMETER           false

add_parameter           SOURCE_ID                     INTEGER                 0
set_parameter_property  SOURCE_ID                     DISPLAY_NAME            "Output source ID"
set_parameter_property  SOURCE_ID                     HDL_PARAMETER           false
set_parameter_property  SOURCE_ID                     AFFECTS_ELABORATION     true

add_parameter           PIPELINE_READY                INTEGER                 0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME            "Pipeline Av-ST ready signals"
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES          0:1
set_parameter_property  PIPELINE_READY                DISPLAY_HINT            boolean
set_parameter_property  PIPELINE_READY                HDL_PARAMETER           false
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION     false

add_device_family_parameters
set_parameter_property  FAMILY                        HDL_PARAMETER           false

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

   set   src_id                     [get_parameter_value SOURCE_ID]
   set   src_width                  [get_parameter_value SRC_WIDTH]
   set   dst_width                  [get_parameter_value DST_WIDTH]
   set   context_width              [get_parameter_value CONTEXT_WIDTH]
   set   task_width                 [get_parameter_value TASK_WIDTH]
   set   bits_per_symbol_in         [get_parameter_value BITS_PER_SYMBOL_IN]
   set   bits_per_symbol_out        [get_parameter_value BITS_PER_SYMBOL_OUT]
   set   symbols_per_pixel          3
   set   are_in_par                 [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pip                        [get_parameter_value PIXELS_IN_PARALLEL]
   if {$are_in_par > 0} {
      set   data_width_in           [expr $bits_per_symbol_in * $symbols_per_pixel]
      set   data_width_out          [expr $bits_per_symbol_out * $symbols_per_pixel]
   } else {
      set   data_width_in           $bits_per_symbol_in
      set   data_width_out          $bits_per_symbol_out
   }
   
   add_av_st_data_sink_port   av_st_din   $data_width_in    $pip  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
   add_av_st_data_source_port av_st_dout  $data_width_out   $pip  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id

   if { [get_parameter_value RUNTIME_CONTROL] > 0 } {
      set   coeff_signed         [get_parameter_value COEFF_SIGNED]
      set   coeff_int            [get_parameter_value COEFF_INTEGER_BITS]
      set   coeff_frac           [get_parameter_value COEFF_FRACTION_BITS]
      set   sum_signed           [get_parameter_value SUMMAND_SIGNED]
      set   sum_int              [get_parameter_value SUMMAND_INTEGER_BITS]
      set   sum_frac             [get_parameter_value SUMMAND_FRACTION_BITS]
            
      set   coeff_width          [expr $coeff_signed + $coeff_int + $coeff_frac]
      set   sum_width            [expr $sum_signed + $sum_int + $sum_frac]
      if { $coeff_width < $sum_width } {
         set   coeff_width   $sum_width
      }
      
      add_av_st_cmd_sink_port    av_st_cmd                        1  $dst_width  $src_width  $task_width $context_width    main_clock  $src_id
      add_av_st_resp_source_port av_st_resp                       1  $dst_width  $src_width  $task_width $context_width    main_clock  $src_id
      add_av_st_data_sink_port   av_st_coeff       $coeff_width   1  $dst_width  $src_width  $task_width $context_width 0  main_clock  $src_id
   }
   
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Output file generation (generate callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   
proc generate_cb {output_name} {
   set   template_file              "alt_vip_csc_alg_core.sv.terp"
   set   template                   [read [open $template_file r]]
   
   set   src_width                  [get_parameter_value SRC_WIDTH]
   set   dst_width                  [get_parameter_value DST_WIDTH]
   set   context_width              [get_parameter_value CONTEXT_WIDTH]
   set   task_width                 [get_parameter_value TASK_WIDTH]
   set   bits_per_symbol_in         [get_parameter_value BITS_PER_SYMBOL_IN]
   set   bits_per_symbol_out        [get_parameter_value BITS_PER_SYMBOL_OUT]
   set   symbols_per_pixel          3
   set   are_in_par                 [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pip                        [get_parameter_value PIXELS_IN_PARALLEL]
   if {$pip > 1} {
      set   empty_width             [clogb2_pure $pip]
   } else {
      set   empty_width             0
   }
   if {$are_in_par > 0} {
      set   data_width_in           [expr $bits_per_symbol_in * $symbols_per_pixel * $pip]
      set   data_width_out          [expr $bits_per_symbol_out * $symbols_per_pixel * $pip]
   } else {
      set   data_width_in           [expr $bits_per_symbol_in * $pip]
      set   data_width_out          [expr $bits_per_symbol_out * $pip]
   }
   
   set   coeff_signed         [get_parameter_value COEFF_SIGNED]
   set   coeff_int            [get_parameter_value COEFF_INTEGER_BITS]
   set   coeff_frac           [get_parameter_value COEFF_FRACTION_BITS]
   set   sum_signed           [get_parameter_value SUMMAND_SIGNED]
   set   sum_int              [get_parameter_value SUMMAND_INTEGER_BITS]
   set   sum_frac             [get_parameter_value SUMMAND_FRACTION_BITS]
         
   set   coeff_width          [expr $coeff_signed + $coeff_int + $coeff_frac]
   set   sum_width            [expr $sum_signed + $sum_int + $sum_frac]
   if { $coeff_width < $sum_width } {
      set   coeff_width   $sum_width
   }

   set  cmd_data_width              [expr 32 + $src_width + $dst_width + $context_width + $task_width]
   set  coeff_data_width            [expr $coeff_width + $src_width + $dst_width + $context_width + $task_width]
   set  din_data_width              [expr $data_width_in + $src_width + $dst_width + $context_width + $task_width + 2*$empty_width]
   set  dout_data_width             [expr $data_width_out + $src_width + $dst_width + $context_width + $task_width + 2*$empty_width]

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
   set   params(colours_are_in_par)        [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   params(bits_per_symbol_in)        [get_parameter_value BITS_PER_SYMBOL_IN]
   set   params(bits_per_symbol_out)       [get_parameter_value BITS_PER_SYMBOL_OUT]
   set   params(move_binary_point_right)   [get_parameter_value MOVE_BINARY_POINT_RIGHT]
   set   params(round_name)                $round_name
   set   params(runtime_control)           [get_parameter_value RUNTIME_CONTROL]
   set   params(coeff_signed)              [get_parameter_value COEFF_SIGNED]
   set   params(coeff_int_bits)            [get_parameter_value COEFF_INTEGER_BITS]
   set   params(coeff_frac_bits)           [get_parameter_value COEFF_FRACTION_BITS]
   set   params(sum_signed)                [get_parameter_value SUMMAND_SIGNED]
   set   params(sum_int_bits)              [get_parameter_value SUMMAND_INTEGER_BITS]
   set   params(sum_frac_bits)             [get_parameter_value SUMMAND_FRACTION_BITS]
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
   
   foreach id {0 1 2} {
      foreach name {A B C} { 
         set   params(coeff_$id$name)    [get_parameter_value COEFFICIENT_$name$id]
      }
      set   params(summand_$id)          [get_parameter_value COEFFICIENT_S$id]
   }
   
   set  result                             [altera_terp $template params]
   set  filename                           ${output_name}.sv
   
   add_fileset_file $filename   SYSTEM_VERILOG TEXT  $result

}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameter legality checks (validation callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   

proc validation_callback {} {

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
   
   if { [get_parameter_value TASK_WIDTH] < 1 } {
      send_message Error "The Task ID width for the command port must be at least 2 bits"
   }
   
   if { [get_parameter_value PIXELS_IN_PARALLEL] > 1 } {
      if { [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] == 0 } {
         send_message Error "Colour planes must be transmitted in parallel to enable pixels per clock cycle > 1"
      }
   }
   
   set   coeff_signed         [get_parameter_value COEFF_SIGNED]
   set   coeff_int            [get_parameter_value COEFF_INTEGER_BITS]
   set   coeff_frac           [get_parameter_value COEFF_FRACTION_BITS]
   set   sum_signed           [get_parameter_value SUMMAND_SIGNED]
   set   sum_int              [get_parameter_value SUMMAND_INTEGER_BITS]
   set   sum_frac             [get_parameter_value SUMMAND_FRACTION_BITS]
         
   
   set   coeff_width          [expr $coeff_int + $coeff_frac]
   set   sum_width            [expr $sum_int + $sum_frac]
   if { $sum_width == 0 } {
      send_message Error "The total summand width must be greater than 0"
   }
   if { $coeff_width == 0 } {
      send_message Error "The total coeff width must be greater than 0"
   }
   set   coeff_width          [expr $coeff_signed + $coeff_int + $coeff_frac]
   set   sum_width            [expr $sum_signed + $sum_int + $sum_frac]
   if { $sum_width > 32 } {
      send_message Error "The total summand width must not exceed 32 bits"
   }
   if { $coeff_width > 32 } {
      send_message Error "The total coeff width must not exceed 32 bits"
   }

   set   unsigned_width [expr $coeff_int + $coeff_frac]
   if { $coeff_signed > 0 } {
      set  min_coeff    [expr {pow(2, $unsigned_width)}]
      set  max_coeff    [expr $min_coeff - 1]
      set  min_coeff    [expr 0 - $min_coeff]
   } else {
      set  max_coeff    [expr {pow(2, $unsigned_width)}]
      set  max_coeff    [expr $max_coeff - 1]
      set  min_coeff    0
   }
   foreach name {A B C} {
      foreach id {0 1 2} {
         set coeff_val  [get_parameter_value COEFFICIENT_$name$id]
         if { $coeff_val < $min_coeff } {
            send_message Error "Value of $name$id coefficient must not be less than the minimum coefficient value ($min_coeff)"
         }
         if { $coeff_val > $max_coeff } {
            send_message Error "Value of $name$id coefficient must not be greater than the maximum coefficient value ($max_coeff)"
         }
      }
   }

   set   unsigned_width [expr $sum_int + $sum_frac]
   if { $sum_signed > 0 } {
      set  min_coeff    [expr {pow(2, $unsigned_width)}]
      set  max_coeff    [expr $min_coeff - 1]
      set  min_coeff    [expr 0 - $min_coeff]
   } else {
      set  max_coeff    [expr {pow(2, $unsigned_width)}]
      set  max_coeff    [expr $max_coeff - 1]
      set  min_coeff    0
   }
   foreach id {0 1 2} {
      set sum_val  [get_parameter_value COEFFICIENT_S$id]
      if { $sum_val < $min_coeff } {
         send_message Error "Value of S$id summand must not be less than the minimum coefficient value ($min_coeff)"
      }
      if { $sum_val > $max_coeff } {
         send_message Error "Value of S$id summand must not be greater than the maximum coefficient value ($max_coeff)"
      }
   }
   

}

