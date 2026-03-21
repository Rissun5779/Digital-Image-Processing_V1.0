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
#-- _hw.tcl compose file for Component Library Gamma Corrector                                    --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source   ../../common_tcl/alt_vip_helper_common.tcl
source   ../../common_tcl/alt_vip_files_common.tcl
source   ../../common_tcl/alt_vip_parameters_common.tcl
source   ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info
set_module_property NAME         alt_vip_cl_gamma_corrector
set_module_property DISPLAY_NAME "Gamma Corrector II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION  ""

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Callback for the composition of this component
set_module_property  COMPOSITION_CALLBACK gamma_composition_callback
set_module_property  VALIDATION_CALLBACK  gamma_validation_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_in_out_bits_per_symbol_parameters                 4  16
set_parameter_property  INPUT_BITS_PER_SYMBOL         HDL_PARAMETER        false
set_parameter_property  OUTPUT_BITS_PER_SYMBOL        HDL_PARAMETER        false

add_channels_nb_parameters
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false

add_pixels_in_parallel_parameters
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER        false

add_parameter           ENABLE_TWO_BANKS              INTEGER              0
set_parameter_property  ENABLE_TWO_BANKS              DISPLAY_NAME         "Enable 2 banks of LUT coefficients"
set_parameter_property  ENABLE_TWO_BANKS              ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_TWO_BANKS              DISPLAY_HINT         boolean
set_parameter_property  ENABLE_TWO_BANKS              HDL_PARAMETER        false
set_parameter_property  ENABLE_TWO_BANKS              AFFECTS_ELABORATION  true

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
set_parameter_property  RUNTIME_CONTROL               VISIBLE              false
set_parameter_property  LIMITED_READBACK              HDL_PARAMETER        false

add_user_packet_support_parameters
add_conversion_mode_parameters
set_parameter_property  CONVERSION_MODE               HDL_PARAMETER        false
set_parameter_property  USER_PACKET_FIFO_DEPTH        HDL_PARAMETER        false
set_parameter_property  USER_PACKET_SUPPORT           HDL_PARAMETER        false
set_parameter_property  USER_PACKET_FIFO_DEPTH        VISIBLE              false


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_display_item  "Video Data Format"     INPUT_BITS_PER_SYMBOL         parameter
add_display_item  "Video Data Format"     OUTPUT_BITS_PER_SYMBOL        parameter
add_display_item  "Video Data Format"     NUMBER_OF_COLOR_PLANES        parameter
add_display_item  "Video Data Format"     PIXELS_IN_PARALLEL            parameter
add_display_item  "Video Data Format"     COLOR_PLANES_ARE_IN_PARALLEL  parameter

add_display_item  "LUT properties"        RUNTIME_CONTROL               parameter
add_display_item  "LUT properties"        ENABLE_TWO_BANKS              parameter

add_display_item  "Optimisation"          USER_PACKET_SUPPORT           parameter
add_display_item  "Optimisation"          CONVERSION_MODE               parameter
add_display_item  "Optimisation"          EXTRA_PIPELINING              parameter
add_display_item  "Optimisation"          LIMITED_READBACK              parameter

proc gamma_validation_callback {} {
   pip_validation_callback_helper
   conversion_mode_validation_callback_helper
   runtime_control_validation_callback_helper
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                        --
# -- Chaining the components, wiring up the clocks and exposing external interfaces               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc gamma_composition_callback {} {
   global   isVersion   acdsVersion vib_vob_removal
   global   vipsuite_max_width
   global   vipsuite_max_height

   # Parameters:
   set   in_bits_per_symbol   [get_parameter_value INPUT_BITS_PER_SYMBOL]
   set   out_bits_per_symbol  [get_parameter_value OUTPUT_BITS_PER_SYMBOL]
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

   add_instance   gamma_core           alt_vip_gamma_corrector_alg_core    $isVersion

   if {$vib_vob_removal == 0} {
      add_instance   video_in_resp        alt_vip_video_input_bridge_resp     $isVersion
      add_instance   video_out            alt_vip_video_output_bridge         $isVersion

      # VIB resp parameterization
      set_instance_parameter_value     video_in_resp     BITS_PER_SYMBOL               $in_bits_per_symbol
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
      set_instance_parameter_value     video_out         BITS_PER_SYMBOL               $out_bits_per_symbol
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
   set_instance_parameter_value     gamma_core        INPUT_BITS_PER_SYMBOL         $in_bits_per_symbol
   set_instance_parameter_value     gamma_core        OUTPUT_BITS_PER_SYMBOL        $out_bits_per_symbol
   set_instance_parameter_value     gamma_core        NUMBER_OF_COLOR_PLANES        $number_of_colors
   set_instance_parameter_value     gamma_core        COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
   set_instance_parameter_value     gamma_core        PIXELS_IN_PARALLEL            $pixels_in_parallel
   set_instance_parameter_value     gamma_core        RUNTIME_CONTROL               $runtime_control
   set_instance_parameter_value     gamma_core        ENABLE_TWO_BANKS              [get_parameter_value ENABLE_TWO_BANKS]
   set_instance_parameter_value     gamma_core        PIPELINE_READY                $pipeline_ready
   set_instance_parameter_value     gamma_core        SRC_WIDTH                     8
   set_instance_parameter_value     gamma_core        DST_WIDTH                     8
   set_instance_parameter_value     gamma_core        CONTEXT_WIDTH                 8
   set_instance_parameter_value     gamma_core        TASK_WIDTH                    8
   set_instance_parameter_value     gamma_core        SOURCE_ID                     0



   if { $use_scheduler > 0 } {

      add_instance   scheduler            alt_vip_gamma_corrector_scheduler   $isVersion

      # Scheduler parameterization
      set_instance_parameter_value     scheduler      INPUT_BITS_PER_SYMBOL         $in_bits_per_symbol
      set_instance_parameter_value     scheduler      OUTPUT_BITS_PER_SYMBOL        $out_bits_per_symbol
      set_instance_parameter_value     scheduler      NUMBER_OF_COLOR_PLANES        $number_of_colors
      set_instance_parameter_value     scheduler      ENABLE_TWO_BANKS              [get_parameter_value ENABLE_TWO_BANKS]
      set_instance_parameter_value     scheduler      RUNTIME_CONTROL               $runtime_control
      set_instance_parameter_value     scheduler      PIPELINE_READY                $pipeline_ready
      set_instance_parameter_value     scheduler      LIMITED_READBACK              $limited_readback
      set_instance_parameter_value     scheduler      USER_PACKET_SUPPORT           [get_parameter_value USER_PACKET_SUPPORT]

   }

   if { $use_vib_cmd > 0 } {

      add_instance   video_in_cmd   alt_vip_video_input_bridge_cmd   $isVersion

      # VIB cmd parameterization
       set_instance_parameter_value    video_in_cmd   BITS_PER_SYMBOL               $in_bits_per_symbol
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

      if { $colors_in_par > 0 } {
         set   data_width_in  [expr $in_bits_per_symbol * $number_of_colors]
         set   data_width_out [expr $out_bits_per_symbol * $number_of_colors]
      } else {
         set   data_width_in  $in_bits_per_symbol
         set   data_width_out $out_bits_per_symbol
      }

      add_instance   user_demux     alt_vip_packet_demux    $isVersion
      add_instance   bps_converter  alt_vip_bps_converter   $isVersion
      add_instance   user_mux       alt_vip_packet_mux      $isVersion

      set_instance_parameter_value     user_demux     DATA_WIDTH                    $data_width_in
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

      set_instance_parameter_value     user_mux       DATA_WIDTH                    $data_width_out
      set_instance_parameter_value     user_mux       PIXELS_IN_PARALLEL            $pixels_in_parallel
      set_instance_parameter_value     user_mux       NUM_INPUTS                    2
      set_instance_parameter_value     user_mux       SRC_WIDTH                     8
      set_instance_parameter_value     user_mux       DST_WIDTH                     8
      set_instance_parameter_value     user_mux       CONTEXT_WIDTH                 8
      set_instance_parameter_value     user_mux       TASK_WIDTH                    8
      set_instance_parameter_value     user_mux       USER_WIDTH                    0
      set_instance_parameter_value     user_mux       PIPELINE_READY                $pipeline_ready

      set_instance_parameter_value     bps_converter       INPUT_BITS_PER_SYMBOL         $in_bits_per_symbol
      set_instance_parameter_value     bps_converter       OUTPUT_BITS_PER_SYMBOL        $out_bits_per_symbol
      set_instance_parameter_value     bps_converter       NUMBER_OF_COLOR_PLANES        $number_of_colors
      set_instance_parameter_value     bps_converter       COLOR_PLANES_ARE_IN_PARALLEL  $colors_in_par
      set_instance_parameter_value     bps_converter       PIXELS_IN_PARALLEL            $pixels_in_parallel
      set_instance_parameter_value     bps_converter       CONVERSION_MODE               [get_parameter_value CONVERSION_MODE]
      set_instance_parameter_value     bps_converter       SRC_WIDTH                     8
      set_instance_parameter_value     bps_converter       DST_WIDTH                     8
      set_instance_parameter_value     bps_converter       CONTEXT_WIDTH                 8
      set_instance_parameter_value     bps_converter       TASK_WIDTH                    8

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
      add_interface           din_data    avalon_streaming  sink
      add_interface           din_aux     avalon_streaming  sink
      add_interface           dout_data   avalon_streaming  source
      add_interface           dout_aux    avalon_streaming  source
   }

   # Av-ST Clock connections :
   add_connection   av_st_clk_bridge.out_clk       av_st_reset_bridge.clk
   add_connection   av_st_clk_bridge.out_clk       gamma_core.main_clock
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
      add_connection   av_st_clk_bridge.out_clk    bps_converter.main_clock
   }

   # Av-ST Reset connections :
   add_connection   av_st_reset_bridge.out_reset      gamma_core.main_reset
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
      add_connection   av_st_reset_bridge.out_reset   bps_converter.main_reset
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
         add_connection       user_demux.av_st_dout_0       gamma_core.av_st_din
      } else {
         add_connection       video_in_cmd.av_st_dout       gamma_core.av_st_din
      }
   } else {
      if { $user_pass > 0 } {
         if {$vib_vob_removal == 0} {
            add_connection       video_in_resp.av_st_dout   user_demux.av_st_din
         } else {
            set_interface_property  din_data    export_of   user_demux.av_st_din
         }
         add_connection       user_demux.av_st_dout_0       gamma_core.av_st_din
      } else {
         if {$vib_vob_removal == 0} {
            add_connection       video_in_resp.av_st_dout   gamma_core.av_st_din
         } else {
            set_interface_property  din_data    export_of   gamma_core.av_st_din
         }
      }
   }
   if { $user_pass > 0 } {
      add_connection          gamma_core.av_st_dout            user_mux.av_st_din_0
      add_connection          user_demux.av_st_dout_1          bps_converter.av_st_din
      add_connection          bps_converter.av_st_dout         user_mux.av_st_din_1
      if {$vib_vob_removal == 0} {
         add_connection          user_mux.av_st_dout        video_out.av_st_din
      } else  {
         set_interface_property  dout_data   export_of      user_mux.av_st_dout
      }
   } else {
      if {$vib_vob_removal == 0} {
         add_connection          gamma_core.av_st_dout      video_out.av_st_din
      } else  {
         set_interface_property  dout_data   export_of      gamma_core.av_st_dout
      }
   }

   # Scheduler/command connections
   if { $use_scheduler > 0 } {
      if {$vib_vob_removal == 0} {
         add_connection             scheduler.av_st_cmd_vob       video_out.av_st_cmd
         add_connection             video_in_resp.av_st_resp      scheduler.av_st_resp_vib
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

      add_connection          gamma_core.av_st_resp         scheduler.av_st_resp_ac
      add_connection          scheduler.av_st_cmd_ac        gamma_core.av_st_cmd
      add_connection          scheduler.av_st_coeff_ac      gamma_core.av_st_coeff

   }
}



