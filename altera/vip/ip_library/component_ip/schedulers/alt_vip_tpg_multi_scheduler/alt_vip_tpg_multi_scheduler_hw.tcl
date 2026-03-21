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

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information for the alt_vip_tpg_multi_scheduler module                                     --
# -- This block sources commands and sinks responses from the various components of the TPG to    --
# -- implement the required test pattern generator functionality                                  --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

# Common module properties for VIP components 
declare_general_component_info

# Component specific properties
set_module_property NAME alt_vip_tpg_multi_scheduler
set_module_property DISPLAY_NAME "Test Pattern Generator Scheduler"
set_module_property ELABORATION_CALLBACK tpg_sched_elaboration_callback

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_alt_vip_common_pkg_files                 ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files     ../../..
add_static_sv_file                           src_hdl/alt_vip_tpg_multi_scheduler.sv
add_static_misc_file                         src_hdl/alt_vip_tpg_multi_scheduler.ocp
setup_filesets                               "" generate_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

#Add BITS_PER_SYMBOL parameter
add_bits_per_symbol_parameters
set_parameter_property BITS_PER_SYMBOL          HDL_PARAMETER        false

# Add MAX_WIDTH and MAX_HEIGHT parameters
add_max_dim_parameters
set_parameter_property MAX_WIDTH                HDL_PARAMETER        false
set_parameter_property MAX_HEIGHT               HDL_PARAMETER        false

add_pixels_in_parallel_parameters
set_parameter_property PIXELS_IN_PARALLEL       HDL_PARAMETER        false

add_parameter          NUM_CORES                INTEGER              1
set_parameter_property NUM_CORES                DISPLAY_NAME         "Number of TPG cores"
set_parameter_property NUM_CORES                ALLOWED_RANGES       1:16
set_parameter_property NUM_CORES                HDL_PARAMETER        false
set_parameter_property NUM_CORES                AFFECTS_ELABORATION  true

add_runtime_control_parameters 1
set_parameter_property RUNTIME_CONTROL          HDL_PARAMETER        false
set_parameter_property LIMITED_READBACK         HDL_PARAMETER        false

add_pipeline_ready_parameters
set_parameter_property PIPELINE_READY           HDL_PARAMETER        false

add_parameter          DEFAULT_R_Y              INTEGER              16
set_parameter_property DEFAULT_R_Y              DISPLAY_NAME         "Default R/Y"
set_parameter_property DEFAULT_R_Y              HDL_PARAMETER        false
set_parameter_property DEFAULT_R_Y              AFFECTS_ELABORATION  false

add_parameter          DEFAULT_G_CB             INTEGER              16
set_parameter_property DEFAULT_G_CB             DISPLAY_NAME         "Default G/Cb"
set_parameter_property DEFAULT_G_CB             HDL_PARAMETER        false
set_parameter_property DEFAULT_G_CB             AFFECTS_ELABORATION  false

add_parameter          DEFAULT_B_CR             INTEGER              16
set_parameter_property DEFAULT_B_CR             DISPLAY_NAME         "Default B/Cr"
set_parameter_property DEFAULT_B_CR             HDL_PARAMETER        false
set_parameter_property DEFAULT_B_CR             AFFECTS_ELABORATION  false

add_parameter          DEFAULT_INTERLACE        STRING               PROGRESSIVE
set_parameter_property DEFAULT_INTERLACE        DISPLAY_NAME         "Default interlacing"
set_parameter_property DEFAULT_INTERLACE        ALLOWED_RANGES       {PROGRESSIVE F0_FIRST F1_FIRST}
set_parameter_property DEFAULT_INTERLACE        HDL_PARAMETER        false
set_parameter_property DEFAULT_INTERLACE        AFFECTS_ELABORATION  false

add_parameter          DEFAULT_BOARDER          INTEGER              0
set_parameter_property DEFAULT_BOARDER          DISPLAY_NAME         "Enable boarder"
set_parameter_property DEFAULT_BOARDER          ALLOWED_RANGES       0:1
set_parameter_property DEFAULT_BOARDER          DISPLAY_HINT         boolean
set_parameter_property DEFAULT_BOARDER          HDL_PARAMETER        false
set_parameter_property DEFAULT_BOARDER          AFFECTS_ELABORATION  false

for {set i 0} {$i < 16} {incr i} {

   add_parameter          CORE_TYPE_$i             INTEGER              0
   set_parameter_property CORE_TYPE_$i             DISPLAY_NAME         "Core $i type"
   set_parameter_property CORE_TYPE_$i             ALLOWED_RANGES       {0 1 2}
   set_parameter_property CORE_TYPE_$i             HDL_PARAMETER        false
   set_parameter_property CORE_TYPE_$i             AFFECTS_ELABORATION  false

   add_parameter          CORE_SUBSAMP_$i          INTEGER              0
   set_parameter_property CORE_SUBSAMP_$i          DISPLAY_NAME         "Core $i subsampling"
   set_parameter_property CORE_SUBSAMP_$i          ALLOWED_RANGES       {0 1 2}
   set_parameter_property CORE_SUBSAMP_$i          HDL_PARAMETER        false
   set_parameter_property CORE_SUBSAMP_$i          AFFECTS_ELABORATION  false

}

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

proc tpg_sched_elaboration_callback {} {

   set src_width       8
   set dst_width       8
   set context_width   8
   set task_width      8
   set control_exists  [get_parameter_value RUNTIME_CONTROL]
   set num_cores       [get_parameter_value NUM_CORES]

   # Static command ports
   #                           name    elements_per_beat   dst_width   src_width   task_width   context_width    clock    pe_id 
   add_av_st_cmd_source_port   av_st_cmd_ac          1  $dst_width  $src_width  $task_width  $context_width  main_clock   0
   add_av_st_cmd_source_port   av_st_cmd_vob         1  $dst_width  $src_width  $task_width  $context_width  main_clock   0

   if { $num_cores > 1 } {
      add_av_st_cmd_source_port   av_st_cmd_mux      1  $dst_width  $src_width  $task_width  $context_width  main_clock   0
   }
   
   if { $control_exists > 0 } {
      set   addr_width  4
      set   num_reg     12
      add_control_slave_port   av_mm_control   $addr_width   $num_reg   0   1   1   1   main_clock
   }
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Output file generation (generate callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------   
proc generate_cb {output_name} {
   set   template_file              "alt_vip_tpg_multi_scheduler.sv.terp"
   set   template                   [read [open $template_file r]]
   
   set   src_width                  8
   set   dst_width                  8
   set   context_width              8
   set   task_width                 8
   set   arg_width                  32
   set   be_width                   4
   set   mm_data_width              32
   set   addr_width                 4
   set   data_width                 [expr $arg_width + $src_width + $dst_width + $context_width + $task_width]
   
   #Collect parameter values for Terp
   set   params(output_name)              $output_name
   set   params(data_width)               $data_width
   set   params(num_cores)                [get_parameter_value NUM_CORES]
   set   params(runtime_control)          [get_parameter_value RUNTIME_CONTROL]
   set   params(be_width)                 $be_width          
   set   params(addr_width)               $addr_width
   set   params(mm_data_width)            $mm_data_width
   set   params(bps)                      [get_parameter_value BITS_PER_SYMBOL]
   set   params(max_width)                [get_parameter_value MAX_WIDTH]
   set   params(max_height)               [get_parameter_value MAX_HEIGHT]
   set   params(limited_readback)         [get_parameter_value LIMITED_READBACK]
   set   params(pipeline_ready)           [get_parameter_value PIPELINE_READY]
   set   params(default_r_y)              [get_parameter_value DEFAULT_R_Y]
   set   params(default_g_cb)             [get_parameter_value DEFAULT_G_CB]
   set   params(default_b_cr)             [get_parameter_value DEFAULT_B_CR]
   set   params(default_interlace)        [get_parameter_value DEFAULT_INTERLACE]    
   set   params(default_boarder)          [get_parameter_value DEFAULT_BOARDER]
   set   params(pip)                      [get_parameter_value PIXELS_IN_PARALLEL]

   for {set i 0} {$i < 16} {incr i} { 
      set   params(core_type_$i)    [get_parameter_value CORE_TYPE_$i]
      set   params(core_subsamp_$i) [get_parameter_value CORE_SUBSAMP_$i]
   }
   
   set  result                             [altera_terp $template params]
   set  filename                           ${output_name}.sv
   
   add_fileset_file $filename   SYSTEM_VERILOG TEXT  $result

}
