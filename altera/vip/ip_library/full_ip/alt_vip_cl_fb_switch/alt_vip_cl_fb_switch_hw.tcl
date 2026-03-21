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
#-- _hw.tcl compose file for Component Library FB switch                                          --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

declare_general_module_info
set_module_property     NAME                          alt_vip_cl_fb_switch
set_module_property     DISPLAY_NAME                  "Frame Buffer Shuffle Intel FPGA IP"
set_module_property     DESCRIPTION                   "Allows the ordering of a frame buffer an another VIP core to be swapped at runtime"

set_module_property HIDE_FROM_QSYS true
set_module_property INTERNAL       true

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set_module_property     VALIDATION_CALLBACK           fbs_valid_callback
set_module_property     COMPOSITION_CALLBACK          fbs_comp_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_bits_per_symbol_parameters

add_channels_nb_parameters

add_pixels_in_parallel_parameters

set_parameter_property  BITS_PER_SYMBOL               HDL_PARAMETER        false
set_parameter_property  NUMBER_OF_COLOR_PLANES        HDL_PARAMETER        false
set_parameter_property  COLOR_PLANES_ARE_IN_PARALLEL  HDL_PARAMETER        false
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER        false

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Register Avalon-ST ready signals"
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION  true
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        false
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean


proc fbs_comp_callback {} {
   global isVersion
   global acdsVersion
   global vib_vob_removal

   set   pixels_in_par  [get_parameter_value PIXELS_IN_PARALLEL]
   set   bps            [get_parameter_value BITS_PER_SYMBOL]
   set   num_symbols    [get_parameter_value NUMBER_OF_COLOR_PLANES]

   if { [get_parameter_value  COLOR_PLANES_ARE_IN_PARALLEL] > 0 } {
      set   data_width  [expr $num_symbols * $bps]
   } else {
      set   data_width  $bps
   }

   if {$vib_vob_removal == 0} {
       add_instance   in_vib_resp       alt_vip_video_input_bridge_resp  $isVersion
       add_instance   other_vib_resp    alt_vip_video_input_bridge_resp  $isVersion
       add_instance   fb_vib_resp       alt_vip_video_input_bridge_resp  $isVersion

       add_instance   other_vob         alt_vip_video_output_bridge      $isVersion
       add_instance   fb_vob            alt_vip_video_output_bridge      $isVersion
       add_instance   out_vob           alt_vip_video_output_bridge      $isVersion
   }

    add_instance   in_vib_cmd           alt_vip_video_input_bridge_cmd   $isVersion
    add_instance   other_vib_cmd        alt_vip_video_input_bridge_cmd   $isVersion
    add_instance   fb_vib_cmd           alt_vip_video_input_bridge_cmd   $isVersion

    add_instance   in_demux             alt_vip_packet_demux             $isVersion
    add_instance   other_demux          alt_vip_packet_demux             $isVersion
    add_instance   fb_demux             alt_vip_packet_demux             $isVersion

    add_instance   other_mux            alt_vip_packet_mux               $isVersion
    add_instance   fb_mux               alt_vip_packet_mux               $isVersion
    add_instance   out_mux              alt_vip_packet_mux               $isVersion

   add_instance   scheduler            alt_vip_fb_switch_scheduler      $isVersion
   add_instance   clk_bridge           altera_clock_bridge              $acdsVersion
   add_instance   reset_bridge         altera_reset_bridge              $acdsVersion

   # Top level interfaces :
   add_interface  main_clock  clock             end
   add_interface  main_reset  reset             end
   add_interface  control     avalon            slave
   set_interface_property     main_clock        export_of      clk_bridge.in_clk
   set_interface_property     main_reset        export_of      reset_bridge.in_reset
   set_interface_property     control           export_of      scheduler.av_mm_control

   set_interface_property     main_clock        PORT_NAME_MAP  {main_clock in_clk}
   set_interface_property     main_reset        PORT_NAME_MAP  {main_reset in_reset}

   if {$vib_vob_removal == 0} {
      add_interface  main_din    avalon_streaming  sink
      add_interface  other_dout  avalon_streaming  source
      add_interface  other_din   avalon_streaming  sink
      add_interface  fb_dout     avalon_streaming  source
      add_interface  fb_din      avalon_streaming  sink
      add_interface  main_dout   avalon_streaming  source

      set_interface_property     main_din          export_of      in_vib_resp.av_st_vid_din
      set_interface_property     other_dout        export_of      other_vob.av_st_vid_dout
      set_interface_property     other_din         export_of      other_vib_resp.av_st_vid_din
      set_interface_property     fb_dout           export_of      fb_vob.av_st_vid_dout
      set_interface_property     fb_din            export_of      fb_vib_resp.av_st_vid_din
      set_interface_property     main_dout         export_of      out_vob.av_st_vid_dout
   } else {
      add_interface  main_din_data     avalon_streaming  sink
      add_interface  main_din_aux      avalon_streaming  sink
      add_interface  other_dout_data   avalon_streaming  source
      add_interface  other_dout_aux    avalon_streaming  source
      add_interface  other_din_data    avalon_streaming  sink
      add_interface  other_din_aux     avalon_streaming  sink
      add_interface  fb_dout_data      avalon_streaming  source
      add_interface  fb_dout_aux       avalon_streaming  source
      add_interface  fb_din_data       avalon_streaming  sink
      add_interface  fb_din_aux        avalon_streaming  sink
      add_interface  main_dout_data    avalon_streaming  source
      add_interface  main_dout_aux     avalon_streaming  source
   }

   if {$vib_vob_removal == 0} {
      set_instance_parameter_value  in_vib_resp      PIPELINE_READY             [get_parameter_value PIPELINE_READY]
      set_instance_parameter_value  in_vib_resp      MULTI_CONTEXT_SUPPORT      0
      set_instance_parameter_value  in_vib_resp      VIB_MODE                   LITE
      set_instance_parameter_value  in_vib_resp      READY_LATENCY_1            1
      set_instance_parameter_value  in_vib_resp      DEFAULT_LINE_LENGTH        1920
      set_instance_parameter_value  in_vib_resp      VIDEO_PROTOCOL_NO          1
      set_instance_parameter_value  in_vib_resp      SRC_WIDTH                  8
      set_instance_parameter_value  in_vib_resp      DST_WIDTH                  8
      set_instance_parameter_value  in_vib_resp      CONTEXT_WIDTH              8
      set_instance_parameter_value  in_vib_resp      TASK_WIDTH                 8
      set_instance_parameter_value  in_vib_resp      RESP_SRC_ADDRESS           0
      set_instance_parameter_value  in_vib_resp      RESP_DST_ADDRESS           0
      set_instance_parameter_value  in_vib_resp      DATA_SRC_ADDRESS           0
      set_instance_parameter_value  in_vib_resp      PIXELS_IN_PARALLEL            $pixels_in_par
      set_instance_parameter_value  in_vib_resp      BITS_PER_SYMBOL               $bps
      set_instance_parameter_value  in_vib_resp      NUMBER_OF_COLOR_PLANES        $num_symbols
      set_instance_parameter_value  in_vib_resp      COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  in_vib_resp      ENABLE_RESOLUTION_CHECK       0

      set_instance_parameter_value  other_vib_resp   PIPELINE_READY             [get_parameter_value PIPELINE_READY]
      set_instance_parameter_value  other_vib_resp   MULTI_CONTEXT_SUPPORT      0
      set_instance_parameter_value  other_vib_resp   VIB_MODE                   LITE
      set_instance_parameter_value  other_vib_resp   READY_LATENCY_1            1
      set_instance_parameter_value  other_vib_resp   DEFAULT_LINE_LENGTH        1920
      set_instance_parameter_value  other_vib_resp   VIDEO_PROTOCOL_NO          1
      set_instance_parameter_value  other_vib_resp   SRC_WIDTH                  8
      set_instance_parameter_value  other_vib_resp   DST_WIDTH                  8
      set_instance_parameter_value  other_vib_resp   CONTEXT_WIDTH              8
      set_instance_parameter_value  other_vib_resp   TASK_WIDTH                 8
      set_instance_parameter_value  other_vib_resp   RESP_SRC_ADDRESS           0
      set_instance_parameter_value  other_vib_resp   RESP_DST_ADDRESS           0
      set_instance_parameter_value  other_vib_resp   DATA_SRC_ADDRESS           0
      set_instance_parameter_value  other_vib_resp   PIXELS_IN_PARALLEL            $pixels_in_par
      set_instance_parameter_value  other_vib_resp   BITS_PER_SYMBOL               $bps
      set_instance_parameter_value  other_vib_resp   NUMBER_OF_COLOR_PLANES        $num_symbols
      set_instance_parameter_value  other_vib_resp   COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  other_vib_resp   ENABLE_RESOLUTION_CHECK       0

      set_instance_parameter_value  fb_vib_resp      PIPELINE_READY             [get_parameter_value PIPELINE_READY]
      set_instance_parameter_value  fb_vib_resp      MULTI_CONTEXT_SUPPORT      0
      set_instance_parameter_value  fb_vib_resp      VIB_MODE                   LITE
      set_instance_parameter_value  fb_vib_resp      READY_LATENCY_1            1
      set_instance_parameter_value  fb_vib_resp      DEFAULT_LINE_LENGTH        1920
      set_instance_parameter_value  fb_vib_resp      VIDEO_PROTOCOL_NO          1
      set_instance_parameter_value  fb_vib_resp      SRC_WIDTH                  8
      set_instance_parameter_value  fb_vib_resp      DST_WIDTH                  8
      set_instance_parameter_value  fb_vib_resp      CONTEXT_WIDTH              8
      set_instance_parameter_value  fb_vib_resp      TASK_WIDTH                 8
      set_instance_parameter_value  fb_vib_resp      RESP_SRC_ADDRESS           0
      set_instance_parameter_value  fb_vib_resp      RESP_DST_ADDRESS           0
      set_instance_parameter_value  fb_vib_resp      DATA_SRC_ADDRESS           0
      set_instance_parameter_value  fb_vib_resp      PIXELS_IN_PARALLEL         $pixels_in_par
      set_instance_parameter_value  fb_vib_resp      BITS_PER_SYMBOL            $bps
      set_instance_parameter_value  fb_vib_resp      NUMBER_OF_COLOR_PLANES     $num_symbols
      set_instance_parameter_value  fb_vib_resp      COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
      set_instance_parameter_value  fb_vib_resp      ENABLE_RESOLUTION_CHECK       0
   }

   set_instance_parameter_value  in_vib_cmd      PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  in_vib_cmd      SRC_WIDTH                  8
   set_instance_parameter_value  in_vib_cmd      DST_WIDTH                  8
   set_instance_parameter_value  in_vib_cmd      CONTEXT_WIDTH              8
   set_instance_parameter_value  in_vib_cmd      TASK_WIDTH                 8
   set_instance_parameter_value  in_vib_cmd      DATA_SRC_ADDRESS           0
   set_instance_parameter_value  in_vib_cmd      PIXELS_IN_PARALLEL            $pixels_in_par
   set_instance_parameter_value  in_vib_cmd      BITS_PER_SYMBOL               $bps
   set_instance_parameter_value  in_vib_cmd      NUMBER_OF_COLOR_PLANES        $num_symbols
   set_instance_parameter_value  in_vib_cmd      COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]

   set_instance_parameter_value  other_vib_cmd   PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  other_vib_cmd   SRC_WIDTH                  8
   set_instance_parameter_value  other_vib_cmd   DST_WIDTH                  8
   set_instance_parameter_value  other_vib_cmd   CONTEXT_WIDTH              8
   set_instance_parameter_value  other_vib_cmd   TASK_WIDTH                 8
   set_instance_parameter_value  other_vib_cmd   DATA_SRC_ADDRESS           0
   set_instance_parameter_value  other_vib_cmd   PIXELS_IN_PARALLEL            $pixels_in_par
   set_instance_parameter_value  other_vib_cmd   BITS_PER_SYMBOL               $bps
   set_instance_parameter_value  other_vib_cmd   NUMBER_OF_COLOR_PLANES        $num_symbols
   set_instance_parameter_value  other_vib_cmd   COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]

   set_instance_parameter_value  fb_vib_cmd      PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  fb_vib_cmd      SRC_WIDTH                  8
   set_instance_parameter_value  fb_vib_cmd      DST_WIDTH                  8
   set_instance_parameter_value  fb_vib_cmd      CONTEXT_WIDTH              8
   set_instance_parameter_value  fb_vib_cmd      TASK_WIDTH                 8
   set_instance_parameter_value  fb_vib_cmd      DATA_SRC_ADDRESS           0
   set_instance_parameter_value  fb_vib_cmd      PIXELS_IN_PARALLEL         $pixels_in_par
   set_instance_parameter_value  fb_vib_cmd      BITS_PER_SYMBOL            $bps
   set_instance_parameter_value  fb_vib_cmd      NUMBER_OF_COLOR_PLANES     $num_symbols
   set_instance_parameter_value  fb_vib_cmd      COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]

   set_instance_parameter_value  scheduler   PIPELINE_READY             [get_parameter_value PIPELINE_READY]

   set_instance_parameter_value  in_demux    CMD_RESP_INTERFACE         0
   set_instance_parameter_value  in_demux    NUM_OUTPUTS                2
   set_instance_parameter_value  in_demux    CLIP_ADDRESS_BITS          0
   set_instance_parameter_value  in_demux    REGISTER_OUTPUT            1
   set_instance_parameter_value  in_demux    PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  in_demux    SRC_WIDTH                  8
   set_instance_parameter_value  in_demux    DST_WIDTH                  8
   set_instance_parameter_value  in_demux    CONTEXT_WIDTH              8
   set_instance_parameter_value  in_demux    TASK_WIDTH                 8
   set_instance_parameter_value  in_demux    USER_WIDTH                 0
   set_instance_parameter_value  in_demux    DATA_WIDTH                 $data_width
   set_instance_parameter_value  in_demux    PIXELS_IN_PARALLEL         $pixels_in_par

   set_instance_parameter_value  other_demux CMD_RESP_INTERFACE         0
   set_instance_parameter_value  other_demux NUM_OUTPUTS                2
   set_instance_parameter_value  other_demux CLIP_ADDRESS_BITS          0
   set_instance_parameter_value  other_demux REGISTER_OUTPUT            1
   set_instance_parameter_value  other_demux PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  other_demux SRC_WIDTH                  8
   set_instance_parameter_value  other_demux DST_WIDTH                  8
   set_instance_parameter_value  other_demux CONTEXT_WIDTH              8
   set_instance_parameter_value  other_demux TASK_WIDTH                 8
   set_instance_parameter_value  other_demux USER_WIDTH                 0
   set_instance_parameter_value  other_demux DATA_WIDTH                 $data_width
   set_instance_parameter_value  other_demux PIXELS_IN_PARALLEL         $pixels_in_par

   set_instance_parameter_value  fb_demux    CMD_RESP_INTERFACE         0
   set_instance_parameter_value  fb_demux    NUM_OUTPUTS                2
   set_instance_parameter_value  fb_demux    CLIP_ADDRESS_BITS          0
   set_instance_parameter_value  fb_demux    REGISTER_OUTPUT            1
   set_instance_parameter_value  fb_demux    PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  fb_demux    SRC_WIDTH                  8
   set_instance_parameter_value  fb_demux    DST_WIDTH                  8
   set_instance_parameter_value  fb_demux    CONTEXT_WIDTH              8
   set_instance_parameter_value  fb_demux    TASK_WIDTH                 8
   set_instance_parameter_value  fb_demux    USER_WIDTH                 0
   set_instance_parameter_value  fb_demux    DATA_WIDTH                 $data_width
   set_instance_parameter_value  fb_demux    PIXELS_IN_PARALLEL         $pixels_in_par

   set_instance_parameter_value  other_mux   CMD_RESP_INTERFACE         0
   set_instance_parameter_value  other_mux   NUM_INPUTS                 2
   set_instance_parameter_value  other_mux   REGISTER_OUTPUT            1
   set_instance_parameter_value  other_mux   PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  other_mux   NAME                       "other_mux"
   set_instance_parameter_value  other_mux   SRC_WIDTH                  8
   set_instance_parameter_value  other_mux   DST_WIDTH                  8
   set_instance_parameter_value  other_mux   CONTEXT_WIDTH              8
   set_instance_parameter_value  other_mux   TASK_WIDTH                 8
   set_instance_parameter_value  other_mux   USER_WIDTH                 0
   set_instance_parameter_value  other_mux   DATA_WIDTH                 $data_width
   set_instance_parameter_value  other_mux   PIXELS_IN_PARALLEL         $pixels_in_par

   set_instance_parameter_value  fb_mux      CMD_RESP_INTERFACE         0
   set_instance_parameter_value  fb_mux      NUM_INPUTS                 2
   set_instance_parameter_value  fb_mux      REGISTER_OUTPUT            1
   set_instance_parameter_value  fb_mux      PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  fb_mux      NAME                       "fb_mux"
   set_instance_parameter_value  fb_mux      SRC_WIDTH                  8
   set_instance_parameter_value  fb_mux      DST_WIDTH                  8
   set_instance_parameter_value  fb_mux      CONTEXT_WIDTH              8
   set_instance_parameter_value  fb_mux      TASK_WIDTH                 8
   set_instance_parameter_value  fb_mux      USER_WIDTH                 0
   set_instance_parameter_value  fb_mux      DATA_WIDTH                 $data_width
   set_instance_parameter_value  fb_mux      PIXELS_IN_PARALLEL         $pixels_in_par

   set_instance_parameter_value  out_mux     CMD_RESP_INTERFACE         0
   set_instance_parameter_value  out_mux     NUM_INPUTS                 2
   set_instance_parameter_value  out_mux     REGISTER_OUTPUT            1
   set_instance_parameter_value  out_mux     PIPELINE_READY             [get_parameter_value PIPELINE_READY]
   set_instance_parameter_value  out_mux     NAME                       "out_mux"
   set_instance_parameter_value  out_mux     SRC_WIDTH                  8
   set_instance_parameter_value  out_mux     DST_WIDTH                  8
   set_instance_parameter_value  out_mux     CONTEXT_WIDTH              8
   set_instance_parameter_value  out_mux     TASK_WIDTH                 8
   set_instance_parameter_value  out_mux     USER_WIDTH                 0
   set_instance_parameter_value  out_mux     DATA_WIDTH                 $data_width
   set_instance_parameter_value  out_mux     PIXELS_IN_PARALLEL         $pixels_in_par

   if {$vib_vob_removal == 0} {
      set_instance_parameter_value  other_vob   LOW_LATENCY_COMMAND_MODE   0
      set_instance_parameter_value  other_vob   SOP_PRE_ALIGNED            1
      set_instance_parameter_value  other_vob   MULTI_CONTEXT_SUPPORT      0
      set_instance_parameter_value  other_vob   VIDEO_PROTOCOL_NO          1
      set_instance_parameter_value  other_vob   SRC_WIDTH                  8
      set_instance_parameter_value  other_vob   DST_WIDTH                  8
      set_instance_parameter_value  other_vob   CONTEXT_WIDTH              8
      set_instance_parameter_value  other_vob   TASK_WIDTH                 8
      set_instance_parameter_value  other_vob   NO_CONCATENATION           1
      set_instance_parameter_value  other_vob   PIPELINE_READY             [get_parameter_value PIPELINE_READY]
      set_instance_parameter_value  other_vob   BITS_PER_SYMBOL               $bps
      set_instance_parameter_value  other_vob   PIXELS_IN_PARALLEL            $pixels_in_par
      set_instance_parameter_value  other_vob   NUMBER_OF_COLOR_PLANES        $num_symbols
      set_instance_parameter_value  other_vob   COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]


      set_instance_parameter_value  fb_vob      LOW_LATENCY_COMMAND_MODE   0
      set_instance_parameter_value  fb_vob      SOP_PRE_ALIGNED            1
      set_instance_parameter_value  fb_vob      MULTI_CONTEXT_SUPPORT      0
      set_instance_parameter_value  fb_vob      VIDEO_PROTOCOL_NO          1
      set_instance_parameter_value  fb_vob      SRC_WIDTH                  8
      set_instance_parameter_value  fb_vob      DST_WIDTH                  8
      set_instance_parameter_value  fb_vob      CONTEXT_WIDTH              8
      set_instance_parameter_value  fb_vob      TASK_WIDTH                 8
      set_instance_parameter_value  fb_vob      NO_CONCATENATION           1
      set_instance_parameter_value  fb_vob      PIPELINE_READY             [get_parameter_value PIPELINE_READY]
      set_instance_parameter_value  fb_vob      BITS_PER_SYMBOL               $bps
      set_instance_parameter_value  fb_vob      PIXELS_IN_PARALLEL            $pixels_in_par
      set_instance_parameter_value  fb_vob      NUMBER_OF_COLOR_PLANES        $num_symbols
      set_instance_parameter_value  fb_vob      COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]

      set_instance_parameter_value  out_vob     LOW_LATENCY_COMMAND_MODE   0
      set_instance_parameter_value  out_vob     SOP_PRE_ALIGNED            1
      set_instance_parameter_value  out_vob     MULTI_CONTEXT_SUPPORT      0
      set_instance_parameter_value  out_vob     VIDEO_PROTOCOL_NO          1
      set_instance_parameter_value  out_vob     SRC_WIDTH                  8
      set_instance_parameter_value  out_vob     DST_WIDTH                  8
      set_instance_parameter_value  out_vob     CONTEXT_WIDTH              8
      set_instance_parameter_value  out_vob     TASK_WIDTH                 8
      set_instance_parameter_value  out_vob     NO_CONCATENATION           1
      set_instance_parameter_value  out_vob     PIPELINE_READY             [get_parameter_value PIPELINE_READY]
      set_instance_parameter_value  out_vob     BITS_PER_SYMBOL               $bps
      set_instance_parameter_value  out_vob     PIXELS_IN_PARALLEL            $pixels_in_par
      set_instance_parameter_value  out_vob     NUMBER_OF_COLOR_PLANES        $num_symbols
      set_instance_parameter_value  out_vob     COLOR_PLANES_ARE_IN_PARALLEL  [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   }

   add_connection    clk_bridge.out_clk               reset_bridge.clk
   add_connection    clk_bridge.out_clk               scheduler.main_clock
   if {$vib_vob_removal == 0} {
      add_connection    clk_bridge.out_clk            in_vib_resp.main_clock
      add_connection    clk_bridge.out_clk            other_vib_resp.main_clock
      add_connection    clk_bridge.out_clk            fb_vib_resp.main_clock
   }
   add_connection    clk_bridge.out_clk               in_vib_cmd.main_clock
   add_connection    clk_bridge.out_clk               other_vib_cmd.main_clock
   add_connection    clk_bridge.out_clk               fb_vib_cmd.main_clock
   add_connection    clk_bridge.out_clk               in_demux.main_clock
   add_connection    clk_bridge.out_clk               other_demux.main_clock
   add_connection    clk_bridge.out_clk               fb_demux.main_clock
   add_connection    clk_bridge.out_clk               other_mux.main_clock
   add_connection    clk_bridge.out_clk               fb_mux.main_clock
   add_connection    clk_bridge.out_clk               out_mux.main_clock
   if {$vib_vob_removal == 0} {
      add_connection    clk_bridge.out_clk            other_vob.main_clock
      add_connection    clk_bridge.out_clk            fb_vob.main_clock
      add_connection    clk_bridge.out_clk            out_vob.main_clock
   }

   add_connection    reset_bridge.out_reset           scheduler.main_reset
   if {$vib_vob_removal == 0} {
      add_connection    reset_bridge.out_reset        in_vib_resp.main_reset
      add_connection    reset_bridge.out_reset        other_vib_resp.main_reset
      add_connection    reset_bridge.out_reset        fb_vib_resp.main_reset
   }
   add_connection    reset_bridge.out_reset           in_vib_cmd.main_reset
   add_connection    reset_bridge.out_reset           other_vib_cmd.main_reset
   add_connection    reset_bridge.out_reset           fb_vib_cmd.main_reset
   add_connection    reset_bridge.out_reset           in_demux.main_reset
   add_connection    reset_bridge.out_reset           other_demux.main_reset
   add_connection    reset_bridge.out_reset           fb_demux.main_reset
   add_connection    reset_bridge.out_reset           other_mux.main_reset
   add_connection    reset_bridge.out_reset           fb_mux.main_reset
   add_connection    reset_bridge.out_reset           out_mux.main_reset
   if {$vib_vob_removal == 0} {
      add_connection    reset_bridge.out_reset        other_vob.main_reset
      add_connection    reset_bridge.out_reset        fb_vob.main_reset
      add_connection    reset_bridge.out_reset        out_vob.main_reset
   }

   if {$vib_vob_removal == 0} {
      add_connection    in_vib_resp.av_st_resp                scheduler.av_st_in_vib_resp
      add_connection    other_vib_resp.av_st_resp             scheduler.av_st_other_vib_resp
      add_connection    fb_vib_resp.av_st_resp                scheduler.av_st_fb_vib_resp
   } else {
      set_interface_property  main_din_aux   export_of        scheduler.av_st_in_vib_resp
      set_interface_property  fb_din_aux     export_of        scheduler.av_st_fb_vib_resp
      set_interface_property  other_din_aux  export_of        scheduler.av_st_other_vib_resp
   }

   add_connection    scheduler.av_st_in_vib_cmd       in_vib_cmd.av_st_cmd
   add_connection    scheduler.av_st_other_vib_cmd    other_vib_cmd.av_st_cmd
   add_connection    scheduler.av_st_fb_vib_cmd       fb_vib_cmd.av_st_cmd
   add_connection    scheduler.av_st_other_pm_cmd     other_mux.av_st_cmd
   add_connection    scheduler.av_st_fb_pm_cmd        fb_mux.av_st_cmd
   add_connection    scheduler.av_st_out_pm_cmd       out_mux.av_st_cmd

   if {$vib_vob_removal == 0} {
      add_connection    scheduler.av_st_other_vob_cmd    other_vob.av_st_cmd
      add_connection    scheduler.av_st_fb_vob_cmd       fb_vob.av_st_cmd
      add_connection    scheduler.av_st_out_vob_cmd      out_vob.av_st_cmd
   } else {
      set_interface_property  main_dout_aux   export_of        scheduler.av_st_out_vob_cmd
      set_interface_property  fb_dout_aux     export_of        scheduler.av_st_fb_vob_cmd
      set_interface_property  other_dout_aux  export_of        scheduler.av_st_other_vob_cmd
   }

   if {$vib_vob_removal == 0} {
      add_connection    in_vib_resp.av_st_dout        in_vib_cmd.av_st_din
      add_connection    other_vib_resp.av_st_dout     other_vib_cmd.av_st_din
      add_connection    fb_vib_resp.av_st_dout        fb_vib_cmd.av_st_din
   } else {
      set_interface_property  main_din_data   export_of        in_vib_cmd.av_st_din
      set_interface_property  fb_din_data     export_of        fb_vib_cmd.av_st_din
      set_interface_property  other_din_data  export_of        other_vib_cmd.av_st_din
   }

   add_connection    in_vib_cmd.av_st_dout            in_demux.av_st_din
   add_connection    other_vib_cmd.av_st_dout         other_demux.av_st_din
   add_connection    fb_vib_cmd.av_st_dout            fb_demux.av_st_din

   add_connection    in_demux.av_st_dout_0            other_mux.av_st_din_0
   add_connection    in_demux.av_st_dout_1            fb_mux.av_st_din_1

   add_connection    other_demux.av_st_dout_0         fb_mux.av_st_din_0
   add_connection    other_demux.av_st_dout_1         out_mux.av_st_din_1

   add_connection    fb_demux.av_st_dout_0            out_mux.av_st_din_0
   add_connection    fb_demux.av_st_dout_1            other_mux.av_st_din_1

   if {$vib_vob_removal == 0} {
      add_connection    other_mux.av_st_dout             other_vob.av_st_din
      add_connection    fb_mux.av_st_dout                fb_vob.av_st_din
      add_connection    out_mux.av_st_dout               out_vob.av_st_din
   } else {
      set_interface_property  main_dout_data   export_of        out_mux.av_st_dout
      set_interface_property  fb_dout_data     export_of        fb_mux.av_st_dout
      set_interface_property  other_dout_data  export_of        other_mux.av_st_dout
   }

}

proc fbs_valid_callback {} {
   if { [get_parameter_value PIXELS_IN_PARALLEL] > 1 } {
      if { [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] == 0 } {
         send_message Error "All colour planes must be in parallel to enable more than 1 pixel in parallel"
      }
   }
}
