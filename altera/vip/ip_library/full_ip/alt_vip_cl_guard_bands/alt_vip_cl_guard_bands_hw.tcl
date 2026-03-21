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
#-- _hw.tcl compose file for Component Library Guard Bands                                    --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source   ../../common_tcl/alt_vip_helper_common.tcl
source   ../../common_tcl/alt_vip_files_common.tcl
source   ../../common_tcl/alt_vip_parameters_common.tcl
source   ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME         alt_vip_cl_guard_bands
set_module_property DISPLAY_NAME "Configurable Guard Bands (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION  ""

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Callback for the composition of this component
set_module_property  COMPOSITION_CALLBACK gb_composition_callback
set_module_property  VALIDATION_CALLBACK gb_validation_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_bits_per_symbol_parameters
set_parameter_property  BITS_PER_SYMBOL               HDL_PARAMETER        false

add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER        false

add_parameter           IS_422                        INTEGER              0
set_parameter_property  IS_422                        ALLOWED_RANGES       0:1
set_parameter_property  IS_422                        DISPLAY_NAME         "4:2:2 data"
set_parameter_property  IS_422                        DISPLAY_HINT         boolean
set_parameter_property  IS_422                        AFFECTS_ELABORATION  true
set_parameter_property  IS_422                        HDL_PARAMETER        false

add_parameter           SIGNED_INPUT                  INTEGER              0
set_parameter_property  SIGNED_INPUT                  ALLOWED_RANGES       0:1
set_parameter_property  SIGNED_INPUT                  DISPLAY_NAME         "Signed input data"
set_parameter_property  SIGNED_INPUT                  DISPLAY_HINT         boolean
set_parameter_property  SIGNED_INPUT                  AFFECTS_ELABORATION  true
set_parameter_property  SIGNED_INPUT                  HDL_PARAMETER        false

add_parameter           SIGNED_OUTPUT                 INTEGER              0
set_parameter_property  SIGNED_OUTPUT                 ALLOWED_RANGES       0:1
set_parameter_property  SIGNED_OUTPUT                 DISPLAY_NAME         "Signed output data"
set_parameter_property  SIGNED_OUTPUT                 DISPLAY_HINT         boolean
set_parameter_property  SIGNED_OUTPUT                 AFFECTS_ELABORATION  true
set_parameter_property  SIGNED_OUTPUT                 HDL_PARAMETER        false

for { set i 0 } { $i < 4} { incr i } {

   add_parameter           OUTPUT_GUARD_BAND_LOWER_$i    INTEGER              0
   set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i    DISPLAY_NAME         "Lower guard band for colour $i"
   set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i    HDL_PARAMETER        false
   set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i    AFFECTS_ELABORATION  true

   add_parameter           OUTPUT_GUARD_BAND_UPPER_$i    INTEGER              255
   set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i    DISPLAY_NAME         "Upper guard band for colour $i"
   set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i    HDL_PARAMETER        false
   set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i    AFFECTS_ELABORATION  true

}


add_parameter           EXTRA_PIPELINING              INTEGER              0
set_parameter_property  EXTRA_PIPELINING              DISPLAY_NAME         "Add extra pipelining registers"
set_parameter_property  EXTRA_PIPELINING              ALLOWED_RANGES       0:1
set_parameter_property  EXTRA_PIPELINING              DESCRIPTION          "Selecting this option adds extra pipeline stage registers to the data path"
set_parameter_property  EXTRA_PIPELINING              HDL_PARAMETER        false
set_parameter_property  EXTRA_PIPELINING              AFFECTS_ELABORATION  true
set_parameter_property  EXTRA_PIPELINING              DISPLAY_HINT         boolean

add_runtime_control_parameters                        1
set_parameter_property  RUNTIME_CONTROL               HDL_PARAMETER        false
set_parameter_property  RUNTIME_CONTROL               DEFAULT_VALUE        1
set_parameter_property  RUNTIME_CONTROL               VISIBLE              true
set_parameter_property  LIMITED_READBACK              HDL_PARAMETER        false

add_user_packet_support_parameters
set_parameter_property  USER_PACKET_FIFO_DEPTH        HDL_PARAMETER        false
set_parameter_property  USER_PACKET_SUPPORT           HDL_PARAMETER        false
set_parameter_property  USER_PACKET_FIFO_DEPTH        VISIBLE              false


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_display_item  "Video Data Format"     BITS_PER_SYMBOL               parameter
add_display_item  "Video Data Format"     NUMBER_OF_COLOR_PLANES        parameter
add_display_item  "Video Data Format"     PIXELS_IN_PARALLEL            parameter
add_display_item  "Video Data Format"     COLOR_PLANES_ARE_IN_PARALLEL  parameter
add_display_item  "Video Data Format"     IS_422                        parameter
add_display_item  "Video Data Format"     SIGNED_INPUT                  parameter
add_display_item  "Video Data Format"     SIGNED_OUTPUT                 parameter

add_display_item  "Guard Bands"           RUNTIME_CONTROL               parameter
for { set i 0 } { $i < 4} { incr i } {
   add_display_item  "Guard Bands"        OUTPUT_GUARD_BAND_LOWER_$i    parameter
   add_display_item  "Guard Bands"        OUTPUT_GUARD_BAND_UPPER_$i    parameter
}

add_display_item  "Optimisation"          USER_PACKET_SUPPORT           parameter
add_display_item  "Optimisation"          EXTRA_PIPELINING              parameter
add_display_item  "Optimisation"          LIMITED_READBACK              parameter

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc gb_validation_callback {} {

   set   num_colours     [get_parameter_value NUMBER_OF_COLOR_PLANES]
   for { set i 0 } { $i < 4} { incr i } {
      if { $i <  $num_colours } {
         set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i ENABLED  true
         set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i ENABLED  true
      } else {
         set_parameter_property  OUTPUT_GUARD_BAND_LOWER_$i ENABLED  false
         set_parameter_property  OUTPUT_GUARD_BAND_UPPER_$i ENABLED  false
      }
   }

   if { [get_parameter_value SIGNED_INPUT] > 0 } {
      if { [get_parameter_value SIGNED_OUTPUT] > 0 } {
         send_message Error "Either the input or output data must be unsigned"
      }
   }
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                        --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc gb_composition_callback {} {
   global   isVersion   acdsVersion vib_vob_removal
   global   vipsuite_max_width
   global   vipsuite_max_height

   # Parameters:
   set   bits_per_symbol      [get_parameter_value BITS_PER_SYMBOL]
   set   number_of_colors     [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   colors_in_par        [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   pixels_in_parallel   [get_parameter_value PIXELS_IN_PARALLEL]
   set   limited_readback     [get_parameter_value LIMITED_READBACK]
   set   pipeline_ready       [get_parameter_value EXTRA_PIPELINING]
   set   runtime_control      [get_parameter_value RUNTIME_CONTROL]
   set   use_scheduler        $runtime_control

   set   comp                 [get_parameter_value USER_PACKET_SUPPORT]
   set   match                [string compare   $comp PASSTHROUGH]
   if { $match == 0 } {
      set   user_pass         1
      set   use_vib_cmd       1
      set   use_scheduler     1
   } else {
      set   user_pass         0
      set   match             [string compare   $comp DISCARD]
      if { $match == 0 } {
         set   use_vib_cmd    1
         set   use_scheduler  1
      } else {
         set   use_vib_cmd    0
      }
   }

   # The chain of components to compose :
   add_instance   av_st_clk_bridge     altera_clock_bridge                 $acdsVersion
   add_instance   av_st_reset_bridge   altera_reset_bridge                 $acdsVersion


   add_instance   guard_core           alt_vip_guard_bands_alg_core        $isVersion

   if {$vib_vob_removal == 0} {
      add_instance   video_in_resp        alt_vip_video_input_bridge_resp     $isVersion
      add_instance   video_out            alt_vip_video_output_bridge         $isVersion

      # VIB resp parameterization
      set_instance_parameter_value     video_in_resp     BITS_PER_SYMBOL               $bits_per_symbol
      set_instance_parameter_value     video_in_resp     NUMBER_OF_COLOR_PLANES        $number_of_colors
      set_instance_parameter_value     video_in_resp     COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
      set_instance_parameter_value     video_in_resp     PIXELS_IN_PARALLEL            $pixels_in_parallel
      set_instance_parameter_value     video_in_resp     MAX_WIDTH                     $vipsuite_max_width
      set_instance_parameter_value     video_in_resp     MAX_HEIGHT                    $vipsuite_max_height
      set_instance_parameter_value     video_in_resp     DEFAULT_LINE_LENGTH           1920
      set_instance_parameter_value     video_in_resp     VIB_MODE                      LITE
      set_instance_parameter_value     video_in_resp     READY_LATENCY_1               1
      set_instance_parameter_value     video_in_resp     MULTI_CONTEXT_SUPPORT         0
      set_instance_parameter_value     video_in_resp     VIDEO_PROTOCOL_NO             1
      set_instance_parameter_value     video_in_resp     ENABLE_RESOLUTION_CHECK       0
      set_instance_parameter_value     video_in_resp     PIPELINE_READY                $pipeline_ready
      set_instance_parameter_value     video_in_resp     SRC_WIDTH                     8
      set_instance_parameter_value     video_in_resp     DST_WIDTH                     8
      set_instance_parameter_value     video_in_resp     CONTEXT_WIDTH                 8
      set_instance_parameter_value     video_in_resp     TASK_WIDTH                    8
      set_instance_parameter_value     video_in_resp     RESP_SRC_ADDRESS              0
      set_instance_parameter_value     video_in_resp     RESP_DST_ADDRESS              0
      set_instance_parameter_value     video_in_resp     DATA_SRC_ADDRESS              0

       # Vob parameterization
      set_instance_parameter_value     video_out         BITS_PER_SYMBOL               $bits_per_symbol
      set_instance_parameter_value     video_out         NUMBER_OF_COLOR_PLANES        $number_of_colors
      set_instance_parameter_value     video_out         COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
      set_instance_parameter_value     video_out         PIXELS_IN_PARALLEL            $pixels_in_parallel
      set_instance_parameter_value     video_out         SOP_PRE_ALIGNED               1
      set_instance_parameter_value     video_out         NO_CONCATENATION              1
      set_instance_parameter_value     video_out         VIDEO_PROTOCOL_NO             1
      set_instance_parameter_value     video_out         SRC_WIDTH                     8
      set_instance_parameter_value     video_out         DST_WIDTH                     8
      set_instance_parameter_value     video_out         CONTEXT_WIDTH                 8
      set_instance_parameter_value     video_out         TASK_WIDTH                    8
      set_instance_parameter_value     video_out         PIPELINE_READY                $pipeline_ready
   }

   #alg core parameterisation
   set_instance_parameter_value     guard_core        BITS_PER_SYMBOL               $bits_per_symbol
   set_instance_parameter_value     guard_core        NUMBER_OF_COLOR_PLANES        $number_of_colors
   set_instance_parameter_value     guard_core        COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
   set_instance_parameter_value     guard_core        PIXELS_IN_PARALLEL            $pixels_in_parallel
   set_instance_parameter_value     guard_core        IS_422                        [get_parameter_value IS_422]
   set_instance_parameter_value     guard_core        SIGNED_INPUT                  [get_parameter_value SIGNED_INPUT]
   set_instance_parameter_value     guard_core        SIGNED_OUTPUT                 [get_parameter_value SIGNED_OUTPUT]
   set_instance_parameter_value     guard_core        ENABLE_CMD_PORT               $runtime_control
   for { set i 0 } { $i < 4} { incr i } {
       set_instance_parameter_value guard_core        OUTPUT_GUARD_BAND_LOWER_$i    [get_parameter_value OUTPUT_GUARD_BAND_LOWER_$i]
       set_instance_parameter_value guard_core        OUTPUT_GUARD_BAND_UPPER_$i    [get_parameter_value OUTPUT_GUARD_BAND_UPPER_$i]
   }
   set_instance_parameter_value     guard_core        PIPELINE_READY                $pipeline_ready
   set_instance_parameter_value     guard_core        SRC_WIDTH                     8
   set_instance_parameter_value     guard_core        DST_WIDTH                     8
   set_instance_parameter_value     guard_core        CONTEXT_WIDTH                 8
   set_instance_parameter_value     guard_core        TASK_WIDTH                    8
   set_instance_parameter_value     guard_core        SOURCE_ID                     0

   if { $use_scheduler > 0 } {

      set   cp_md    $number_of_colors
      set   is_422   [get_parameter_value IS_422]
      if { $is_422 > 0 } {
         set cp_md   [expr $number_of_colors + 1]
      }

      add_instance   scheduler            alt_vip_guard_bands_scheduler             $isVersion

      # Scheduler parameterization
      set_instance_parameter_value     scheduler      BITS_PER_SYMBOL               $bits_per_symbol
      set_instance_parameter_value     scheduler      NUMBER_OF_COLOR_PLANES        $cp_md
      for { set i 0 } { $i < 4} { incr i } {
         set_instance_parameter_value  scheduler      LOWER_$i                      [get_parameter_value OUTPUT_GUARD_BAND_LOWER_$i]
         set_instance_parameter_value  scheduler      UPPER_$i                      [get_parameter_value OUTPUT_GUARD_BAND_UPPER_$i]
      }
      set_instance_parameter_value     scheduler      RUNTIME_CONTROL               $runtime_control
      set_instance_parameter_value     scheduler      PIPELINE_READY                $pipeline_ready
      set_instance_parameter_value     scheduler      LIMITED_READBACK              $limited_readback
      set_instance_parameter_value     scheduler      USER_PACKET_SUPPORT           [get_parameter_value USER_PACKET_SUPPORT]

   }

   if { $use_vib_cmd > 0 } {

      add_instance   video_in_cmd   alt_vip_video_input_bridge_cmd   $isVersion

      # VIB cmd parameterization
       set_instance_parameter_value    video_in_cmd   BITS_PER_SYMBOL               $bits_per_symbol
       set_instance_parameter_value    video_in_cmd   NUMBER_OF_COLOR_PLANES        $number_of_colors
       set_instance_parameter_value    video_in_cmd   COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
       set_instance_parameter_value    video_in_cmd   PIXELS_IN_PARALLEL            $pixels_in_parallel
       set_instance_parameter_value    video_in_cmd   PIPELINE_READY                $pipeline_ready
       set_instance_parameter_value    video_in_cmd   SRC_WIDTH                     8
       set_instance_parameter_value    video_in_cmd   DST_WIDTH                     8
       set_instance_parameter_value    video_in_cmd   CONTEXT_WIDTH                 8
       set_instance_parameter_value    video_in_cmd   TASK_WIDTH                    8
       set_instance_parameter_value    video_in_cmd   DATA_SRC_ADDRESS              0

   }

   if { $user_pass > 0 } {

      set      bps         [get_parameter_value BITS_PER_SYMBOL]
      set      in_par      [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      if { $in_par > 0 } {
         set   num_cols    [get_parameter_value NUMBER_OF_COLOR_PLANES]
         set   data_width  [expr $bps * $num_cols]
      } else {
         set   data_width  $bps
      }

      add_instance   user_demux  alt_vip_packet_demux $isVersion
      add_instance   user_mux    alt_vip_packet_mux   $isVersion

      set_instance_parameter_value     user_demux     DATA_WIDTH                    $data_width
      set_instance_parameter_value     user_demux     PIXELS_IN_PARALLEL            $pixels_in_parallel
      set_instance_parameter_value     user_demux     NUM_OUTPUTS                   2
      set_instance_parameter_value     user_demux     CLIP_ADDRESS_BITS             0
      set_instance_parameter_value     user_demux     SHIFT_ADDRESS_BITS            0
      set_instance_parameter_value     user_demux     REGISTER_OUTPUT               1
      set_instance_parameter_value     user_demux     SRC_WIDTH                     8
      set_instance_parameter_value     user_demux     DST_WIDTH                     8
      set_instance_parameter_value     user_demux     CONTEXT_WIDTH                 8
      set_instance_parameter_value     user_demux     TASK_WIDTH                    8
      set_instance_parameter_value     user_demux     USER_WIDTH                    0
      set_instance_parameter_value     user_demux     PIPELINE_READY                $pipeline_ready

      set_instance_parameter_value     user_mux       DATA_WIDTH                    $data_width
      set_instance_parameter_value     user_mux       PIXELS_IN_PARALLEL            $pixels_in_parallel
      set_instance_parameter_value     user_mux       NUM_INPUTS                    2
      set_instance_parameter_value     user_mux       SRC_WIDTH                     8
      set_instance_parameter_value     user_mux       DST_WIDTH                     8
      set_instance_parameter_value     user_mux       CONTEXT_WIDTH                 8
      set_instance_parameter_value     user_mux       TASK_WIDTH                    8
      set_instance_parameter_value     user_mux       USER_WIDTH                    0
      set_instance_parameter_value     user_mux       PIPELINE_READY                $pipeline_ready

   }

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
      if { $use_scheduler > 0 } {
         add_interface           din_aux     avalon_streaming  sink
         add_interface           dout_aux    avalon_streaming  source
      }
      add_interface           din_data    avalon_streaming  sink
      add_interface           dout_data   avalon_streaming  source
   }

   # Av-ST Clock connections :
   add_connection   av_st_clk_bridge.out_clk       av_st_reset_bridge.clk
   add_connection   av_st_clk_bridge.out_clk       guard_core.main_clock
   if {$vib_vob_removal == 0} {
      add_connection   av_st_clk_bridge.out_clk       video_in_resp.main_clock
      add_connection   av_st_clk_bridge.out_clk       video_out.main_clock
   }
   if { $use_scheduler > 0 } {
      add_connection   av_st_clk_bridge.out_clk    scheduler.main_clock
   }
   if { $use_vib_cmd > 0 } {
      add_connection   av_st_clk_bridge.out_clk    video_in_cmd.main_clock
   }
   if { $user_pass > 0 } {
      add_connection   av_st_clk_bridge.out_clk    user_demux.main_clock
      add_connection   av_st_clk_bridge.out_clk    user_mux.main_clock
   }

   # Av-ST Reset connections :
   add_connection   av_st_reset_bridge.out_reset      guard_core.main_reset
   if {$vib_vob_removal == 0} {
      add_connection   av_st_reset_bridge.out_reset      video_in_resp.main_reset
      add_connection   av_st_reset_bridge.out_reset      video_out.main_reset
   }
   if { $use_scheduler > 0 } {
      add_connection   av_st_reset_bridge.out_reset   scheduler.main_reset
   }
   if { $use_vib_cmd > 0 } {
      add_connection   av_st_reset_bridge.out_reset   video_in_cmd.main_reset
   }
   if { $user_pass > 0 } {
      add_connection   av_st_reset_bridge.out_reset   user_demux.main_reset
      add_connection   av_st_reset_bridge.out_reset   user_mux.main_reset
   }

   # datapath connections
   if { $use_vib_cmd > 0 } {
      if {$vib_vob_removal == 0} {
         add_connection          video_in_resp.av_st_dout   video_in_cmd.av_st_din
      } else {
         set_interface_property  din_data    export_of      video_in_cmd.av_st_din
      }
      if { $user_pass > 0 } {
         add_connection       video_in_cmd.av_st_dout       user_demux.av_st_din
         add_connection       user_demux.av_st_dout_0       guard_core.av_st_din
      } else {
         add_connection       video_in_cmd.av_st_dout       guard_core.av_st_din
      }
   } else {
      if { $user_pass > 0 } {
         if {$vib_vob_removal == 0} {
            add_connection          video_in_resp.av_st_dout   user_demux.av_st_din
         } else {
            set_interface_property  din_data    export_of      user_demux.av_st_din
         }
         add_connection       user_demux.av_st_dout_0          guard_core.av_st_din
      } else {
         if {$vib_vob_removal == 0} {
            add_connection          video_in_resp.av_st_dout   guard_core.av_st_din
         } else {
            set_interface_property  din_data    export_of      guard_core.av_st_din
         }
      }
   }
   if { $user_pass > 0 } {
      add_connection          guard_core.av_st_dout         user_mux.av_st_din_0
      add_connection          user_demux.av_st_dout_1       user_mux.av_st_din_1
      if {$vib_vob_removal == 0} {
         add_connection          user_mux.av_st_dout        video_out.av_st_din
      } else {
         set_interface_property  dout_data   export_of      user_mux.av_st_dout
      }
   } else {
      if {$vib_vob_removal == 0} {
         add_connection          guard_core.av_st_dout      video_out.av_st_din
      } else {
         set_interface_property  dout_data   export_of      guard_core.av_st_dout
      }
   }

   # Scheduler/command connections
   if { $use_scheduler > 0 } {
       if {$vib_vob_removal == 0} {
         add_connection             video_in_resp.av_st_resp      scheduler.av_st_resp_vib
         add_connection             scheduler.av_st_cmd_vob       video_out.av_st_cmd
      } else {
         set_interface_property  din_aux     export_of         scheduler.av_st_resp_vib
         set_interface_property  dout_aux    export_of         scheduler.av_st_cmd_vob
      }
      if { $use_vib_cmd > 0 } {
         add_connection          scheduler.av_st_cmd_vib       video_in_cmd.av_st_cmd
      }
      if { $user_pass > 0 } {
         add_connection          scheduler.av_st_cmd_mux       user_mux.av_st_cmd
      }
   } else {
      if {$vib_vob_removal == 0} {
         add_connection             video_in_resp.av_st_resp      video_out.av_st_cmd
      }
   }

   # Optional runtime control interface and connections
   if {$runtime_control > 0 } {

      # Top level interface :
      add_interface           control  avalon      slave
      set_interface_property  control  export_of   scheduler.av_mm_control

      add_connection          scheduler.av_st_cmd_ac        guard_core.av_st_cmd

   }
}




