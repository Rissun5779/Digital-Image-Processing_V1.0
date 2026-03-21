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
# --                                                                                              --
# -- _hw.tcl compose file for Test Pattern Generator II (TPG II)                                  --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
source   ../../common_tcl/alt_vip_helper_common.tcl
source   ../../common_tcl/alt_vip_files_common.tcl
source   ../../common_tcl/alt_vip_parameters_common.tcl
source   ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IPdeclare_general_module_info
declare_general_module_info
set_module_property NAME alt_vip_cl_tpg
set_module_property DISPLAY_NAME "Test Pattern Generator II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION "The Test Pattern Generator generates video fields with various patterns according to the specifications of the Avalon-ST Video protocol."

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Upgrade callback to support change of parameters
set_module_property  PARAMETER_UPGRADE_CALLBACK    upgrade_cb

# Validation callback to check legality of parameter set
set_module_property  VALIDATION_CALLBACK           validation_cb

# Callback for the composition of this component
set_module_property  COMPOSITION_CALLBACK          composition_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set   x_max    $vipsuite_max_width
set   y_max    $vipsuite_max_height

# Adds BITS_PER_SYMBOL
add_bits_per_symbol_parameters
set_parameter_property  BITS_PER_SYMBOL                  HDL_PARAMETER           false

# Adds COLOR_PLANES_ARE_IN_PARALLEL, NUMBER_OF_COLOR_PLANES is disabled and hidden since it is determined by the OUTPUT_FORMAT
add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES           HDL_PARAMETER           false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL     HDL_PARAMETER           false
set_parameter_property  NUMBER_OF_COLOR_PLANES           VISIBLE                 false

# Adds PIXELS_IN_PARALLEL
add_pixels_in_parallel_parameters

# Adds MAX_WIDTH/MAX_HEIGHT
add_max_dim_parameters  32 $x_max   32 $y_max
set_parameter_property  MAX_WIDTH                        AFFECTS_ELABORATION     true
set_parameter_property  MAX_HEIGHT                       AFFECTS_ELABORATION     true
set_parameter_property  MAX_HEIGHT                       DESCRIPTION             "The maximum height of images / video frames, value must be the height of full progressive wave when outputting interlaced data"
set_parameter_property  MAX_WIDTH                        HDL_PARAMETER           false
set_parameter_property  MAX_HEIGHT                       HDL_PARAMETER           false

add_runtime_control_parameters   1
set_parameter_property  RUNTIME_CONTROL                  HDL_PARAMETER           false
set_parameter_property  LIMITED_READBACK                 HDL_PARAMETER           false

# Other format only possible in YCbCr color space mode
add_parameter           OUTPUT_FORMAT                    STRING                  4.4.4
set_parameter_property  OUTPUT_FORMAT                    DISPLAY_NAME            "Output format"
set_parameter_property  OUTPUT_FORMAT                    ALLOWED_RANGES          {"4.4.4:4:4:4" "4.2.2:4:2:2" "4.2.0:4:2:0" "VAR:Variable" "MONO:Monochrome"}
set_parameter_property  OUTPUT_FORMAT                    DISPLAY_HINT            ""
set_parameter_property  OUTPUT_FORMAT                    DESCRIPTION             "Output subsampling format"
set_parameter_property  OUTPUT_FORMAT                    HDL_PARAMETER           false
set_parameter_property  OUTPUT_FORMAT                    AFFECTS_ELABORATION     true

add_parameter           INTERLACING                      STRING                  PROGRESSIVE
set_parameter_property  INTERLACING                      DISPLAY_NAME            "Default Interlacing"
set_parameter_property  INTERLACING                      ALLOWED_RANGES          {{PROGRESSIVE:Progressive output} {F0_FIRST:Interlaced output (F0 First)} {F1_FIRST:Interlaced output (F1 First)}}
set_parameter_property  INTERLACING                      DISPLAY_HINT            ""
set_parameter_property  INTERLACING                      DESCRIPTION             "Output stream is progressive or interlaced with either F0 first or F1 first"
set_parameter_property  INTERLACING                      HDL_PARAMETER           false
set_parameter_property  INTERLACING                      AFFECTS_ELABORATION     true

add_parameter           UNIFORM_VALUE_RY                 INTEGER                 16
set_parameter_property  UNIFORM_VALUE_RY                 DISPLAY_NAME            "UniformR or Y"
set_parameter_property  UNIFORM_VALUE_RY                 DESCRIPTION             "Color bit value for R or Y"
set_parameter_property  UNIFORM_VALUE_RY                 HDL_PARAMETER           false
set_parameter_property  UNIFORM_VALUE_RY                 AFFECTS_ELABORATION     true

add_parameter           UNIFORM_VALUE_GCB                INTEGER                 16
set_parameter_property  UNIFORM_VALUE_GCB                DISPLAY_NAME            "Uniform G or Cb"
set_parameter_property  UNIFORM_VALUE_GCB                DESCRIPTION             "Color bit value for G or Cb"
set_parameter_property  UNIFORM_VALUE_GCB                HDL_PARAMETER           false
set_parameter_property  UNIFORM_VALUE_GCB                AFFECTS_ELABORATION     true

add_parameter           UNIFORM_VALUE_BCR                INTEGER                 16
set_parameter_property  UNIFORM_VALUE_BCR                DISPLAY_NAME            "Uniform B or Cr"
set_parameter_property  UNIFORM_VALUE_BCR                DESCRIPTION             "Color bit value for B or Cr"
set_parameter_property  UNIFORM_VALUE_BCR                HDL_PARAMETER           false
set_parameter_property  UNIFORM_VALUE_BCR                AFFECTS_ELABORATION     true

add_parameter           DEFAULT_BOARDER                  INTEGER                 1
set_parameter_property  DEFAULT_BOARDER                  DISPLAY_NAME            "Enable border for bar patterns"
set_parameter_property  DEFAULT_BOARDER                  ALLOWED_RANGES          0:1
set_parameter_property  DEFAULT_BOARDER                  DISPLAY_HINT            boolean
set_parameter_property  DEFAULT_BOARDER                  HDL_PARAMETER           false
set_parameter_property  DEFAULT_BOARDER                  AFFECTS_ELABORATION     true

add_parameter           NUM_CORES                        INTEGER                 1
set_parameter_property  NUM_CORES                        DISPLAY_NAME            "Number of test patterns"
set_parameter_property  NUM_CORES                        ALLOWED_RANGES          {1 2 3 4 5 6 7 8}
set_parameter_property  NUM_CORES                        HDL_PARAMETER           false
set_parameter_property  NUM_CORES                        AFFECTS_ELABORATION     true

add_parameter           PIPELINE_READY                   INTEGER                 0
set_parameter_property  PIPELINE_READY                   DISPLAY_NAME            "Pipeline dout ready"
set_parameter_property  PIPELINE_READY                   ALLOWED_RANGES          0:1
set_parameter_property  PIPELINE_READY                   DISPLAY_HINT            boolean
set_parameter_property  PIPELINE_READY                   HDL_PARAMETER           false
set_parameter_property  PIPELINE_READY                   AFFECTS_ELABORATION     true

for {set i 0} {$i < 8} {incr i} {
   add_parameter           PATTERN_$i                    STRING                  colorbars
   set_parameter_property  PATTERN_$i                    DISPLAY_NAME            "Pattern"
   set_parameter_property  PATTERN_$i                    ALLOWED_RANGES          {{colorbars:Color bars} {greybars:Greyscale bars} {greyscalebars:Black and White bars}  {uniform:Uniform background} {sdipatho:SDI Pathological}}
   set_parameter_property  PATTERN_$i                    HDL_PARAMETER           false
   set_parameter_property  PATTERN_$i                    AFFECTS_ELABORATION     true

   add_parameter           COLOR_SPACE_$i                STRING                  RGB_444
   set_parameter_property  COLOR_SPACE_$i                DISPLAY_NAME            "Subsampling & Colorspace"
   set_parameter_property  COLOR_SPACE_$i                ALLOWED_RANGES          {"RGB_444:RGB" "YCbCr_444:YCbCr 4:4:4" "YCbCr_422:YCbCr 4:2:2" "YCbCr_420:YCbCr 4:2:0" "MONO:Monochrome"}
   set_parameter_property  COLOR_SPACE_$i                HDL_PARAMETER           false
   set_parameter_property  COLOR_SPACE_$i                AFFECTS_ELABORATION     true
}


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

#add_display_item "Test Pattern Generator Options" RUNTIME_CONTROL parameter
add_display_item  "Interface Configuration"  BITS_PER_SYMBOL parameter
add_display_item  "Interface Configuration"  PIXELS_IN_PARALLEL parameter
add_display_item  "Interface Configuration"  COLOR_PLANES_ARE_IN_PARALLEL parameter
add_display_item  "Interface Configuration"  OUTPUT_FORMAT parameter

add_display_item  "Shared Configuration"   MAX_WIDTH parameter
add_display_item  "Shared Configuration"   MAX_HEIGHT parameter
add_display_item  "Shared Configuration"   INTERLACING parameter
add_display_item  "Shared Configuration"   RUNTIME_CONTROL parameter
add_display_item  "Shared Configuration"   LIMITED_READBACK parameter
add_display_item  "Shared Configuration"   PIPELINE_READY parameter

add_display_item  "Pattern Configuration"  DEFAULT_BOARDER parameter
add_display_item  "Pattern Configuration"  TEXT text "Uniform values"
add_display_item  "Pattern Configuration"  UNIFORM_VALUE_RY parameter
add_display_item  "Pattern Configuration"  UNIFORM_VALUE_GCB parameter
add_display_item  "Pattern Configuration"  UNIFORM_VALUE_BCR parameter
add_display_item  "Pattern Configuration"  NUM_CORES parameter

for {set i 0} {$i < 8} {incr i} {
   add_display_item  "Pattern Configuration"  TEXT_$i text "Test pattern $i"
   add_display_item  "Pattern Configuration"  PATTERN_$i parameter
   add_display_item  "Pattern Configuration"  COLOR_SPACE_$i parameter
}



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Upgrade callback                                                                             --
# -- ACDS version upgrade/downgrade                                                               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc upgrade_cb {ip_core_type version parameters} {

   set local_cs "RGB"
   set local_ss "444"

   foreach { name value } $parameters {

      switch $name {

         INTERLACING {
            if { $value == "prog" } {
               set_parameter_value  INTERLACING   "PROGRESSIVE"
            } else {
               if { $value == "int_f0" } {
                  set_parameter_value  INTERLACING   "F0_FIRST"
               } else {
                  set_parameter_value  INTERLACING   "F1_FIRST"
               }
            }
         }
         PATTERN {
            set_parameter_value  PATTERN_0  $value
         }
         COLOR_SPACE {
            set   local_cs $value
         }
         OUTPUT_FORMAT {
            set_parameter_value  OUTPUT_FORMAT  $value
            set   local_ss $value
         }  
         AUTO_DEVICE_FAMILY {
            # Do nothing, AUTO_DEVICE_FAMILY removed
         } 
         AUTO_MAIN_CLOCK_CLOCK_RATE {
            # Do nothing, AUTO_MAIN_CLOCK_CLOCK_RATE removed
         } 
         AUTO_MAIN_CLOCK_RESET_DOMAIN {
            # Do nothing, AUTO_MAIN_CLOCK_RESET_DOMAIN removed
         } 
         AUTO_MAIN_CLOCK_CLOCK_DOMAIN {
            # Do nothing, AUTO_MAIN_CLOCK_CLOCK_DOMAIN removed
         } 
         default                {
            set_parameter_value  $name $value
         }

      }

   }
   
   if { $local_cs == "RGB" } {
      set_parameter_value  COLOR_SPACE_0  "RGB_444"
   } else {
      if { $local_ss == "4.4.4" } {
         set_parameter_value  COLOR_SPACE_0  "YCbCr_444"
      } else {
         set_parameter_value  COLOR_SPACE_0  "YCbCr_422"
      }
   }

}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc validation_cb {} {

   set   runtime_control   [get_parameter_value RUNTIME_CONTROL]
   set   max_width         [get_parameter_value MAX_WIDTH]
   set   max_height        [get_parameter_value MAX_HEIGHT]
   set   interlacing       [get_parameter_value INTERLACING]
   set   is_interlacedf0   [string equal $interlacing "F0_FIRST"]
   set   is_interlacedf1   [string equal $interlacing "F1_FIRST"]    
   set   output_format     [get_parameter_value OUTPUT_FORMAT]
   set   odd_width         [expr {$max_width % 2}]
   set   odd_height        [expr {$max_height % 2}]
   set   num_cores         [get_parameter_value NUM_CORES]
   set   bits_per_symbol   [get_parameter_value BITS_PER_SYMBOL]
   set   in_par            [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]

   if { $in_par == 0 } {
      if { ($output_format == "VAR") || ($output_format == "4.2.0") } {      
         send_message error "Color planes in sequence is not supported for either variable or 4:2:0 output formats"
      }
   }

   if { $runtime_control == 0 } {
      if { $output_format == "VAR" } {
          send_message error "Variable output format is only available with runtime control enabled"
      } else {
         if { ($output_format == "4.2.0") || ($output_format == "4.2.2") } {
            if { $odd_width > 0 } {
               send_message error "Odd image widths are not supported in 4:2:2 and 4:2:0 modes"
            }
         }
         if { $output_format == "4.2.0" } {
            if { $odd_height > 0 } {
               send_message error "Odd image heights are not supported in 4:2:0 mode"
            }
            if { ($is_interlacedf1 > 0) || ($is_interlacedf0 > 0) } {
               send_message error "Interlaced output is not supported in 4:2:0 mode"
            }
         }
      }
      if { $num_cores > 1 } {
         send_message error "Number of TPG cores must be set to 1 if runtime control is not enabled"
      }
      set_parameter_property  LIMITED_READBACK  ENABLED  false
   } else {
      set_parameter_property  LIMITED_READBACK  ENABLED  true
      set   potential_issue   0
      set   has_422           0
      set   has_420           0
      if  { $output_format == "4.2.0" } {
         set   has_420        1
      }
      if  { $output_format == "4.2.2" } {
         set   has_422        1
      }
      if { $output_format == "VAR" } {
         for {set i 0} {$i < $num_cores} {incr i} {
            set   local_format   [get_parameter_value COLOR_SPACE_$i] 
            if { $local_format == "YCbCr_422" } {
               set   has_422        1
            }
            if { $local_format == "YCbCr_420" } {
               set   has_420        1
            }
         }
      }
      if { ($has_420 > 0) || ($has_422 > 0) } {
         if { $odd_width > 0 } {
            set   potential_issue   1
         }
      }
      if { $has_420 > 0 } {
         if { $odd_height > 0 } {
            set   potential_issue   1
         }
         if { ($is_interlacedf1 > 0) || ($is_interlacedf0 > 0) } {
            set   potential_issue   1
         }
      }
      if { $potential_issue > 0 } {
         send_message info "Image width, height and interlaced behaviour currently default to values not supported by the 4:2:0 and/or 4:2:2 test patterns (see user guide for details)"
      }
   }

   set   has_bars    0
   set   has_const   0
   for {set i 0} {$i < 8} {incr i} {
      if { $i < $num_cores } {
         set_parameter_property  PATTERN_$i        ENABLED  true
         set_parameter_property  COLOR_SPACE_$i    ENABLED  true
         set   local_pattern  [get_parameter_value PATTERN_$i]
         set   local_format   [get_parameter_value COLOR_SPACE_$i]
         if { $local_pattern == "colorbars" } {
            set   has_bars    1
         }
         if { $local_pattern == "uniform" } {
            set   has_const   1
         }
         if { $output_format == "MONO" } {
            if { $local_format != "MONO" } {
               send_message error "Patter $i: if Monochrome is selected for the output format then all test patterns must use the Monochrome color space"
            }
            if { $local_pattern == "colorbars" } {
               send_message error "Patter $i: The colorbars patten is not supported for Monochrome"
            }
            if { $local_pattern == "sdipatho" } {
               send_message error "Patter $i: The SDI Pathological patten is not supported for Monochrome"
            }
         }
         if { $output_format == "4.4.4" } {
            if { ($local_format != "RGB_444") && ($local_format != "YCbCr_444") } {
               send_message error "Patter $i: if 4:4:4 is selected for the output format then all test patterns must use a 4:4:4 color space"
            }
         }
         if { $output_format == "4.2.2" } {
            if { $local_format != "YCbCr_422" } {
               send_message error "Patter $i: if 4:2:2 is selected for the output format then all test patterns must use a 4:2:2 color space"
            }
         }
         if { $output_format == "4.2.0" } {
            if { $local_format != "YCbCr_420" } {
               send_message error "Patter $i: if 4:2:0 is selected for the output format then all test patterns must use a 4:2:0 color space"
            }
         }
         if { $output_format == "VAR" } {
            if { $local_format == "MONO" } {
               send_message error "Patter $i: The Monochrome color space is not supported in the variable output format mode"
            }
         } 
      } else {
         set_parameter_property  PATTERN_$i        ENABLED  false
         set_parameter_property  COLOR_SPACE_$i    ENABLED  false
      }
   }

   if { $has_bars > 0 } {
      set_parameter_property  DEFAULT_BOARDER   ENABLED  true
      set   pip   [get_parameter_value PIXELS_IN_PARALLEL]
      set   new_min_size   [expr $pip * 8]
      if { $new_min_size > $max_width } {
         send_message error "With color bars enabled and $pip pixels in parallel the minimum supported width is $new_min_size"
      }
   } else {
      set_parameter_property  DEFAULT_BOARDER   ENABLED  false
   }

   if { $has_const > 0 } {
      set_parameter_property  UNIFORM_VALUE_RY  ENABLED  true
      set_parameter_property  UNIFORM_VALUE_GCB ENABLED  true
      set_parameter_property  UNIFORM_VALUE_BCR ENABLED  true
      set   max   [expr {pow(2, $bits_per_symbol)}]
      set   max   [expr $max - 1]
      set   ry    [get_parameter_value UNIFORM_VALUE_RY]
      if { $ry > $max } {
         send_message error "Uniform R / Y value out of range 0 to $max"
      } 
      set   gcb    [get_parameter_value UNIFORM_VALUE_GCB]
      if { $gcb > $max } {
         send_message error "Uniform G / Cb value out of range 0 to $max"
      }
      set   bcr    [get_parameter_value UNIFORM_VALUE_BCR]
      if { $bcr > $max } {
         send_message error "Uniform B / Cr value out of range 0 to $max"
      }
   } else {
      set_parameter_property  UNIFORM_VALUE_RY  ENABLED  false
      set_parameter_property  UNIFORM_VALUE_GCB ENABLED  false
      set_parameter_property  UNIFORM_VALUE_BCR ENABLED  false
   }

}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                         --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc composition_cb {} {
   global   isVersion   acdsVersion

   set   bps                  [get_parameter_value BITS_PER_SYMBOL]
   set   par_mode             [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pixels_in_parallel   [get_parameter_value PIXELS_IN_PARALLEL]
   set   output_format        [get_parameter_value OUTPUT_FORMAT] 
   set   max_width            [get_parameter_value MAX_WIDTH]
   set   max_height           [get_parameter_value MAX_HEIGHT]
   set   interlacing          [get_parameter_value INTERLACING]
   set   uniform_value_ry     [get_parameter_value UNIFORM_VALUE_RY]
   set   uniform_value_gcb    [get_parameter_value UNIFORM_VALUE_GCB]
   set   uniform_value_bcr    [get_parameter_value UNIFORM_VALUE_BCR]
   set   runtime_control      [get_parameter_value RUNTIME_CONTROL]
   set   num_cores            [get_parameter_value NUM_CORES]
   set   pipeline             [get_parameter_value PIPELINE_READY]
   set   limited_readback     [get_parameter_value LIMITED_READBACK]

   # Channels that will be in parallel
   if { $output_format == "4.2.2" } {
      set   num_colours          2
   } else {
      if { $output_format == "MONO" } {
         set   num_colours       1
      } else {
         set   num_colours       3
      }
   }
   if { $par_mode > 0 } {
      set   channels_in_par      $num_colours
   } else {
      set   channels_in_par      1
   }
   send_message   info  "The output interface will have $num_colours colours per pixel"

   # The chain of components to compose :
   add_instance   av_st_clk_bridge     altera_clock_bridge           $acdsVersion
   add_instance   av_st_reset_bridge   altera_reset_bridge           $acdsVersion
   add_instance   video_out            alt_vip_video_output_bridge   $isVersion
   add_instance   scheduler            alt_vip_tpg_multi_scheduler   $isVersion
   if { $num_cores > 1 } {
      add_instance   mux               alt_vip_packet_mux            $isVersion
      add_instance   demux             alt_vip_packet_demux          $isVersion
   }
   for {set i 0} {$i < $num_cores} {incr i} {
      set   local_pattern  [get_parameter_value PATTERN_$i]
      if { $local_pattern == "uniform" } {
         add_instance   core_$i        alt_vip_tpg_const_alg_core    $isVersion
      } else {
         if { $local_pattern == "sdipatho" } {
            add_instance   core_$i     alt_vip_tpg_sdi_alg_core      $isVersion
         } else {
            add_instance   core_$i     alt_vip_tpg_bars_alg_core     $isVersion
         }
      }
   }

   # TPG core parameterization
   for {set i 0} {$i < $num_cores} {incr i} {
      set_instance_parameter_value  core_$i        BITS_PER_SYMBOL                  $bps
      set_instance_parameter_value  core_$i        COLOR_PLANES_ARE_IN_PARALLEL     $par_mode
      set_instance_parameter_value  core_$i        NUMBER_OF_COLOR_PLANES           $num_colours
      set_instance_parameter_value  core_$i        PIXELS_IN_PARALLEL               $pixels_in_parallel
      set_instance_parameter_value  core_$i        MAX_HEIGHT                       $max_height
      set_instance_parameter_value  core_$i        MAX_WIDTH                        $max_width
      set_instance_parameter_value  core_$i        TPG_CS                           [get_parameter_value COLOR_SPACE_$i]
      set_instance_parameter_value  core_$i        SRC_WIDTH                        8
      set_instance_parameter_value  core_$i        DST_WIDTH                        8
      set_instance_parameter_value  core_$i        CONTEXT_WIDTH                    8
      set_instance_parameter_value  core_$i        TASK_WIDTH                       8
      set_instance_parameter_value  core_$i        SOURCE_ID                        0
      set_instance_parameter_value  core_$i        PIPELINE_READY                   $pipeline

      set local_pattern [get_parameter_value PATTERN_$i]
      if { $local_pattern == "colorbars" } {
         set_instance_parameter_value  core_$i     PATTERN                          COLOUR_BARS
      } else {
         if { $local_pattern == "greybars" } {
            set_instance_parameter_value  core_$i  PATTERN                          GREYSCALE_BARS               
         } else {
            if { $local_pattern == "greyscalebars" } {
               set_instance_parameter_value  core_$i  PATTERN                       BW_BARS  
            }
         }
      }
   }

   # Vob parameterization
   set_instance_parameter_value  video_out   BITS_PER_SYMBOL                  $bps       
   set_instance_parameter_value  video_out   COLOR_PLANES_ARE_IN_PARALLEL     $par_mode
   set_instance_parameter_value  video_out   NUMBER_OF_COLOR_PLANES           $num_colours
   set_instance_parameter_value  video_out   PIXELS_IN_PARALLEL               $pixels_in_parallel
   set_instance_parameter_value  video_out   VIDEO_PROTOCOL_NO                1
   set_instance_parameter_value  video_out   READY_LATENCY_1                  1
   set_instance_parameter_value  video_out   SOP_PRE_ALIGNED                  1
   set_instance_parameter_value  video_out   MULTI_CONTEXT_SUPPORT            0
   set_instance_parameter_value  video_out   TYPE_11_SUPPORT                  0
   set_instance_parameter_value  video_out   NO_CONCATENATION                 0
   set_instance_parameter_value  video_out   LOW_LATENCY_COMMAND_MODE         0
   set_instance_parameter_value  video_out   PIPELINE_READY                   $pipeline
   set_instance_parameter_value  video_out   SRC_WIDTH                        8
   set_instance_parameter_value  video_out   DST_WIDTH                        8
   set_instance_parameter_value  video_out   CONTEXT_WIDTH                    8
   set_instance_parameter_value  video_out   TASK_WIDTH                       8

   # Scheduler parameterization
   set_instance_parameter_value  scheduler   BITS_PER_SYMBOL                  $bps
   set_instance_parameter_value  scheduler   PIXELS_IN_PARALLEL               $pixels_in_parallel
   set_instance_parameter_value  scheduler   MAX_HEIGHT                       $max_height
   set_instance_parameter_value  scheduler   MAX_WIDTH                        $max_width
   set_instance_parameter_value  scheduler   RUNTIME_CONTROL                  $runtime_control
   set_instance_parameter_value  scheduler   LIMITED_READBACK                 $limited_readback
   set_instance_parameter_value  scheduler   PIPELINE_READY                   $pipeline
   set_instance_parameter_value  scheduler   DEFAULT_BOARDER                  [get_parameter_value DEFAULT_BOARDER]
   set_instance_parameter_value  scheduler   NUM_CORES                        $num_cores
   set_instance_parameter_value  scheduler   DEFAULT_INTERLACE                $interlacing
   set_instance_parameter_value  scheduler   DEFAULT_R_Y                      $uniform_value_ry
   set_instance_parameter_value  scheduler   DEFAULT_G_CB                     $uniform_value_gcb
   set_instance_parameter_value  scheduler   DEFAULT_B_CR                     $uniform_value_bcr
   for {set i 0} {$i < $num_cores} {incr i} {
      set local_pattern [get_parameter_value PATTERN_$i]
      if { $local_pattern == "uniform" } {
         set_instance_parameter_value  scheduler   CORE_TYPE_$i               1
      } else {
         if { $local_pattern == "sdipatho" } {
            set_instance_parameter_value  scheduler   CORE_TYPE_$i            2
         } else {
            set_instance_parameter_value  scheduler   CORE_TYPE_$i            0
         }
      }
      if { ($output_format == "4.4.4") || ($output_format == "MONO") } {
         set_instance_parameter_value  scheduler   CORE_SUBSAMP_$i            0
      } else { 
         if { $output_format == "4.2.2" } {
            set_instance_parameter_value  scheduler   CORE_SUBSAMP_$i         1
         } else {
            if { $output_format == "4.2.0" } {
               set_instance_parameter_value  scheduler   CORE_SUBSAMP_$i      2
            } else {
               set   local_format   [get_parameter_value COLOR_SPACE_$i]
               if { ($local_format == "RGB_444") || ($local_format == "YCbCr_444") } {
                  set_instance_parameter_value  scheduler   CORE_SUBSAMP_$i      0
               } else {
                  if { $local_format == "YCbCr_422" } {
                     set_instance_parameter_value  scheduler   CORE_SUBSAMP_$i   1
                  } else {
                     set_instance_parameter_value  scheduler   CORE_SUBSAMP_$i   2
                  }
               }
            }
         }
      }
   }

   if { $num_cores > 1 } {
      
      set_instance_parameter_value  demux    CMD_RESP_INTERFACE            1
      set_instance_parameter_value  demux    DATA_WIDTH                    32
      set_instance_parameter_value  demux    PIXELS_IN_PARALLEL            1
      set_instance_parameter_value  demux    NUM_OUTPUTS                   $num_cores
      set_instance_parameter_value  demux    CLIP_ADDRESS_BITS             0
      set_instance_parameter_value  demux    SHIFT_ADDRESS_BITS            0
      set_instance_parameter_value  demux    REGISTER_OUTPUT               1
      set_instance_parameter_value  demux    SRC_WIDTH                     8
      set_instance_parameter_value  demux    DST_WIDTH                     8
      set_instance_parameter_value  demux    CONTEXT_WIDTH                 8
      set_instance_parameter_value  demux    TASK_WIDTH                    8
      set_instance_parameter_value  demux    USER_WIDTH                    0
      set_instance_parameter_value  demux    PIPELINE_READY                $pipeline

      set_instance_parameter_value   mux     DATA_WIDTH                    [expr $channels_in_par * $bps]
      set_instance_parameter_value   mux     PIXELS_IN_PARALLEL            $pixels_in_parallel
      set_instance_parameter_value   mux     NUM_INPUTS                    $num_cores
      set_instance_parameter_value   mux     SRC_WIDTH                     8
      set_instance_parameter_value   mux     DST_WIDTH                     8
      set_instance_parameter_value   mux     CONTEXT_WIDTH                 8
      set_instance_parameter_value   mux     TASK_WIDTH                    8
      set_instance_parameter_value   mux     USER_WIDTH                    0
      set_instance_parameter_value   mux     PIPELINE_READY                $pipeline

   }


   # --------------------------------------------------------------------------------------------------
   # --                                                                                              --
   # -- Top-level interfaces                                                                         --
   # --                                                                                              --
   # --------------------------------------------------------------------------------------------------
   add_interface           main_clock     clock             end
   add_interface           main_reset     reset             end
   add_interface           dout           avalon_streaming  source

   set_interface_property  main_clock     export_of         av_st_clk_bridge.in_clk
   set_interface_property  main_reset     export_of         av_st_reset_bridge.in_reset
   set_interface_property  dout           export_of         video_out.av_st_vid_dout

   set_interface_property  main_clock     PORT_NAME_MAP     {main_clock in_clk}
   set_interface_property  main_reset     PORT_NAME_MAP     {main_reset in_reset}

   if { $runtime_control > 0 } {
      add_interface           control  avalon      slave
      set_interface_property  control  export_of   scheduler.av_mm_control
   }


   # --------------------------------------------------------------------------------------------------
   # --                                                                                              --
   # -- Connection of sub-components                                                                 --
   # --                                                                                              --
   # --------------------------------------------------------------------------------------------------

   # Av-ST Clock connections :
   add_connection   av_st_clk_bridge.out_clk       av_st_reset_bridge.clk
   add_connection   av_st_clk_bridge.out_clk       video_out.main_clock
   add_connection   av_st_clk_bridge.out_clk       scheduler.main_clock
   
   # Av-ST Reset connections :
   add_connection   av_st_reset_bridge.out_reset   video_out.main_reset
   add_connection   av_st_reset_bridge.out_reset   scheduler.main_reset

   for {set i 0} {$i < $num_cores} {incr i} {
      add_connection   av_st_reset_bridge.out_reset   core_$i\.main_reset
      add_connection   av_st_clk_bridge.out_clk       core_$i\.main_clock
   }
   
   add_connection   scheduler.av_st_cmd_vob     video_out.av_st_cmd
   
   if { $num_cores > 1 } {
      for {set i 0} {$i < $num_cores} {incr i} {
         add_connection   core_$i\.av_st_dout         mux.av_st_din_$i
         add_connection   demux.av_st_dout_$i         core_$i\.av_st_cmd
      }
      add_connection   mux.av_st_dout                 video_out.av_st_din
      add_connection   scheduler.av_st_cmd_ac         demux.av_st_din
      add_connection   scheduler.av_st_cmd_mux        mux.av_st_cmd
      
      add_connection   av_st_clk_bridge.out_clk       mux.main_clock
      add_connection   av_st_reset_bridge.out_reset   mux.main_reset
      add_connection   av_st_clk_bridge.out_clk       demux.main_clock
      add_connection   av_st_reset_bridge.out_reset   demux.main_reset
      
   } else {
      add_connection   core_0.av_st_dout              video_out.av_st_din
      add_connection   scheduler.av_st_cmd_ac         core_0.av_st_cmd
   }

}

