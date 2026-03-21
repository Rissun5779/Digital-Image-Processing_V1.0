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

source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl


# Common module properties for VIP components 
declare_general_component_info

# Component specific properties
set_module_property   NAME                   alt_vip_gamma_corrector_alg_core
set_module_property   DISPLAY_NAME           "Gamma Corrector Algorithmic Core"
set_module_property   DESCRIPTION            ""
set_module_property   ELABORATION_CALLBACK   gamma_corrector_alg_core_elaboration_callback
set_module_property   VALIDATION_CALLBACK    gamma_corrector_alg_core_validation_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
add_alt_vip_common_pkg_files                 ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_static_sv_file                           src_hdl/alt_vip_gamma_corrector_alg_core.sv
add_static_misc_file                         src_hdl/alt_vip_gamma_corrector_alg_core.ocp
setup_filesets                               "" generate_cb

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

add_pixels_in_parallel_parameters                     {1 2 4 8}
set_parameter_property  PIXELS_IN_PARALLEL            HDL_PARAMETER     false

add_parameter           RUNTIME_CONTROL               INTEGER              1
set_parameter_property  RUNTIME_CONTROL               DISPLAY_NAME         "Enable runtime control of LUT contents"
set_parameter_property  RUNTIME_CONTROL               ALLOWED_RANGES       0:1
set_parameter_property  RUNTIME_CONTROL               DISPLAY_HINT         boolean
set_parameter_property  RUNTIME_CONTROL               HDL_PARAMETER        false
set_parameter_property  RUNTIME_CONTROL               AFFECTS_ELABORATION  true

add_parameter           ENABLE_TWO_BANKS              INTEGER              0
set_parameter_property  ENABLE_TWO_BANKS              DISPLAY_NAME         "Enable 2 banks of LUT coefficients"
set_parameter_property  ENABLE_TWO_BANKS              ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_TWO_BANKS              DISPLAY_HINT         boolean
set_parameter_property  ENABLE_TWO_BANKS              HDL_PARAMETER        false
set_parameter_property  ENABLE_TWO_BANKS              AFFECTS_ELABORATION  true

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Pipeline Av-ST ready signals"
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        false
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION  false

add_av_st_event_parameters 
set_parameter_property  SRC_WIDTH                     HDL_PARAMETER     false
set_parameter_property  DST_WIDTH                     HDL_PARAMETER     false
set_parameter_property  TASK_WIDTH                    HDL_PARAMETER     false
set_parameter_property  CONTEXT_WIDTH                 HDL_PARAMETER     false

add_parameter           SOURCE_ID                     INTEGER              0
set_parameter_property  SOURCE_ID                     DISPLAY_NAME         "Output source ID"
set_parameter_property  SOURCE_ID                     HDL_PARAMETER        false
set_parameter_property  SOURCE_ID                     AFFECTS_ELABORATION  true


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Static ports (clock & reset)                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   

add_main_clock_port

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameter checking (validation callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   

proc gamma_corrector_alg_core_validation_callback {} {

   if { [get_parameter_value RUNTIME_CONTROL] == 0 } {
      if { [get_parameter_value ENABLE_TWO_BANKS] > 0 } {
         send_message Error "2 banks of LUT coefficients can only be enabled when runtime control is turned on"
      }
   }

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

}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic Ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   

proc gamma_corrector_alg_core_elaboration_callback {} {

   if { [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] == 1 } {
      set   are_in_par        1
   } else {
      set   are_in_par        0
   }
   set   in_bps               [get_parameter_value INPUT_BITS_PER_SYMBOL]
   set   out_bps              [get_parameter_value OUTPUT_BITS_PER_SYMBOL]
   set   num_colours          [get_parameter_value NUMBER_OF_COLOR_PLANES]
   if { $are_in_par } {
      set   data_width_in     [expr $in_bps * $num_colours]
      set   data_width_out    [expr $out_bps * $num_colours]
      set   pip               [get_parameter_value PIXELS_IN_PARALLEL]
   } else {
      set   data_width_in     $in_bps
      set   data_width_out    $out_bps
      set   pip               1 
   }

   set   src_width            [get_parameter_value SRC_WIDTH]
   set   dst_width            [get_parameter_value DST_WIDTH]
   set   context_width        [get_parameter_value CONTEXT_WIDTH]
   set   task_width           [get_parameter_value TASK_WIDTH]
   set   src_id               [get_parameter_value SOURCE_ID]

   add_av_st_data_sink_port   av_st_din      $data_width_in    $pip   $dst_width   $src_width   $task_width  $context_width   0   main_clock  $src_id
   add_av_st_data_source_port av_st_dout     $data_width_out   $pip   $dst_width   $src_width   $task_width  $context_width   0   main_clock  $src_id

   if { [get_parameter_value RUNTIME_CONTROL] > 0 } {
      set   mem_size_per_colour  1
      for { set i 0 } { $i < $in_bps } { incr i } {  
         set   mem_size_per_colour  [expr 2 * $mem_size_per_colour]
      }
      if { [get_parameter_value ENABLE_TWO_BANKS] > 0 } {
         set   coeff_addr_space   [expr 2 * $mem_size_per_colour * $num_colours]
      } else {
         set   coeff_addr_space   [expr $mem_size_per_colour * $num_colours]
      }
      set   coeff_addr_width  [clogb2_pure $coeff_addr_space]
      set   coeff_width       [expr $out_bps + $coeff_addr_width]
      add_av_st_cmd_sink_port    av_st_cmd                     1     $dst_width   $src_width   $task_width   $context_width      main_clock  $src_id
      add_av_st_resp_source_port av_st_resp                    1     $dst_width   $src_width   $task_width   $context_width      main_clock  $src_id
      add_av_st_data_sink_port   av_st_coeff    $coeff_width   1     $dst_width   $src_width   $task_width  $context_width   0   main_clock  $src_id
   }

}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Preset gamma conversions for no-runtime control (generation callback)                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
proc generate_cb {output_name} {

   set   template_file  "alt_vip_gamma_corrector_alg_core.sv.terp"
   set   template       [ read [ open $template_file r ] ]

   set   num_colours    [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   in_bps         [get_parameter_value INPUT_BITS_PER_SYMBOL]
   set   out_bps        [get_parameter_value OUTPUT_BITS_PER_SYMBOL] 
   set   pip            [get_parameter_value PIXELS_IN_PARALLEL]  
   if { [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] > 0 } {
      set   data_width_in   [expr $in_bps * $num_colours * $pip]
      set   data_width_out  [expr $out_bps * $num_colours * $pip]
   } else {
      set   data_width_in   $in_bps
      set   data_width_out  $out_bps
   }
   
   set   src_width      [get_parameter_value SRC_WIDTH]
   set   dst_width      [get_parameter_value DST_WIDTH]
   set   context_width  [get_parameter_value CONTEXT_WIDTH]
   set   task_width     [get_parameter_value TASK_WIDTH]
   set   empty_width    [clogb2_pure $pip]
   set   empty_width    [expr $pip > 1 ? $empty_width : 0]
   set   data_width_in  [expr $data_width_in + $dst_width + $src_width + $task_width + $context_width + 2*$empty_width]
   set   data_width_out [expr $data_width_out + $dst_width + $src_width + $task_width + $context_width + 2*$empty_width]
   set   cmd_width      [expr 32 + $dst_width + $src_width + $task_width + $context_width]
   if { [get_parameter_value RUNTIME_CONTROL] > 0 } {
      set   mem_size_per_colour  1
      for { set i 0 } { $i < $in_bps } { incr i } {  
         set   mem_size_per_colour  [expr 2 * $mem_size_per_colour]
      }
      if { [get_parameter_value ENABLE_TWO_BANKS] > 0 } {
         set   coeff_addr_space   [expr 2 * $mem_size_per_colour * $num_colours]
      } else {
         set   coeff_addr_space   [expr $mem_size_per_colour * $num_colours]
      }
      set   coeff_addr_width  [clogb2_pure $coeff_addr_space]
      set   coeff_width       [expr $out_bps + $coeff_addr_width + $dst_width + $src_width + $task_width + $context_width]
   } else {
      set   coeff_width       1
   }

   #Collect parameter values for Terp
   set   params(output_name)        $output_name
   set   params(num_colours)        [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set   params(pip)                [get_parameter_value PIXELS_IN_PARALLEL]
   set   params(colours_are_in_par) [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set   params(bps_in)             [get_parameter_value INPUT_BITS_PER_SYMBOL]
   set   params(bps_out)            [get_parameter_value OUTPUT_BITS_PER_SYMBOL]
   set   params(runtime_control)    [get_parameter_value RUNTIME_CONTROL]
   set   params(two_banks)          [get_parameter_value ENABLE_TWO_BANKS]
   set   params(src_width)          [get_parameter_value SRC_WIDTH]
   set   params(dst_width)          [get_parameter_value DST_WIDTH]
   set   params(context_width)      [get_parameter_value CONTEXT_WIDTH]
   set   params(task_width)         [get_parameter_value TASK_WIDTH]
   set   params(src_addr)           [get_parameter_value SOURCE_ID]
   for { set i 0 } { $i < 4 } { incr i } {
      if { $i < $num_colours } {
         if { [get_parameter_value RUNTIME_CONTROL] == 0 } {
            set   coeff_file_name   "${output_name}_coeff_${i}.hex"
         } else {
            set   coeff_file_name   "no_file_required.hex"
         }
      } else {
         set    coeff_file_name  "no_file_required.hex"
      }
      set   coeff_file_formatted [format "%s%s%s" "\"" ${coeff_file_name} "\""]
      set   params(coeff_file_$i)          ${coeff_file_formatted}
   }
   set   params(pipeline)           [get_parameter_value PIPELINE_READY]
   set   params(cmd_width)          $cmd_width
   set   params(data_width_in)      $data_width_in
   set   params(data_width_out)     $data_width_out
   set   params(coeff_width)        $coeff_width

   set   result          [altera_terp $template params]
   set   filename        ${output_name}.sv
    
   add_fileset_file  $filename   SYSTEM_VERILOG TEXT   $result

}
