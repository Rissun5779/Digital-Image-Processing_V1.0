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


source ../../../common_tcl/alt_vip_helper_common.tcl
source ../../../common_tcl/alt_vip_files_common.tcl
source ../../../common_tcl/alt_vip_parameters_common.tcl
source ../../../common_tcl/alt_vip_interfaces_common.tcl

# | module alt_vip_scaler_scheduler

declare_general_component_info
set_module_property NAME alt_vip_scaler_scheduler
set_module_property DISPLAY_NAME "Scaler Scheduler"
set_module_property VALIDATION_CALLBACK  scl_sched_validation_callback
set_module_property ELABORATION_CALLBACK scl_sched_elaboration_callback

# | files

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files ../../..
add_static_sv_file src_hdl/alt_vip_scaler_scheduler.sv

add_static_misc_file src_hdl/alt_vip_scaler_scheduler.ocp

setup_filesets alt_vip_scaler_scheduler

# | parameters

add_parameter ALGORITHM STRING POLYPHASE
set_parameter_property ALGORITHM DISPLAY_NAME "Scaling algorithm"
set_parameter_property ALGORITHM DESCRIPTION ""
set_parameter_property ALGORITHM ALLOWED_RANGES {NEAREST_NEIGHBOUR BILINEAR BICUBIC POLYPHASE EDGE_ADAPT}
set_parameter_property ALGORITHM AFFECTS_ELABORATION true
set_parameter_property ALGORITHM HDL_PARAMETER true

add_parameter SEPARATE_V_H_CORE INTEGER 0
set_parameter_property SEPARATE_V_H_CORE DISPLAY_NAME "Separate vertical and horizontal cores"
set_parameter_property SEPARATE_V_H_CORE DESCRIPTION ""
set_parameter_property SEPARATE_V_H_CORE ALLOWED_RANGES 0:1
set_parameter_property SEPARATE_V_H_CORE AFFECTS_ELABORATION true
set_parameter_property SEPARATE_V_H_CORE HDL_PARAMETER true
set_parameter_property SEPARATE_V_H_CORE DISPLAY_HINT boolean

add_parameter DEFAULT_EDGE_THRESH INTEGER 7
set_parameter_property DEFAULT_EDGE_THRESH DISPLAY_NAME "Default edge threshold"
set_parameter_property DEFAULT_EDGE_THRESH DESCRIPTION ""
set_parameter_property DEFAULT_EDGE_THRESH AFFECTS_ELABORATION false
set_parameter_property DEFAULT_EDGE_THRESH HDL_PARAMETER true

add_max_in_dim_parameters
set_parameter_property MAX_IN_WIDTH  AFFECTS_ELABORATION false
set_parameter_property MAX_IN_WIDTH  HDL_PARAMETER       true
set_parameter_property MAX_IN_WIDTH  ALLOWED_RANGES      32:$vipsuite_max_width
set_parameter_property MAX_IN_HEIGHT AFFECTS_ELABORATION false
set_parameter_property MAX_IN_HEIGHT HDL_PARAMETER       true
set_parameter_property MAX_IN_HEIGHT ALLOWED_RANGES      32:$vipsuite_max_height

add_max_out_dim_parameters
set_parameter_property MAX_OUT_WIDTH  AFFECTS_ELABORATION false
set_parameter_property MAX_OUT_WIDTH  HDL_PARAMETER       true
set_parameter_property MAX_OUT_WIDTH  ALLOWED_RANGES      32:$vipsuite_max_width
set_parameter_property MAX_OUT_HEIGHT AFFECTS_ELABORATION false
set_parameter_property MAX_OUT_HEIGHT HDL_PARAMETER       true
set_parameter_property MAX_OUT_HEIGHT ALLOWED_RANGES      32:$vipsuite_max_height

add_parameter RUNTIME_CONTROL INTEGER 1
set_parameter_property RUNTIME_CONTROL DISPLAY_NAME "Enable runtime resolution control"
set_parameter_property RUNTIME_CONTROL DESCRIPTION ""
set_parameter_property RUNTIME_CONTROL ALLOWED_RANGES 0:1
set_parameter_property RUNTIME_CONTROL AFFECTS_ELABORATION true
set_parameter_property RUNTIME_CONTROL HDL_PARAMETER true
set_parameter_property RUNTIME_CONTROL DISPLAY_HINT boolean

add_parameter LOAD_AT_RUNTIME INTEGER 1
set_parameter_property LOAD_AT_RUNTIME DISPLAY_NAME "Enable runtime coefficient loading"
set_parameter_property LOAD_AT_RUNTIME DESCRIPTION ""
set_parameter_property LOAD_AT_RUNTIME ALLOWED_RANGES 0:1
set_parameter_property LOAD_AT_RUNTIME AFFECTS_ELABORATION true
set_parameter_property LOAD_AT_RUNTIME HDL_PARAMETER true
set_parameter_property LOAD_AT_RUNTIME DISPLAY_HINT boolean

add_parameter H_BANKS INTEGER 1
set_parameter_property H_BANKS DISPLAY_NAME "Horizontal scaling coefficient banks"
set_parameter_property H_BANKS DESCRIPTION ""
set_parameter_property H_BANKS ALLOWED_RANGES 1:32
set_parameter_property H_BANKS AFFECTS_ELABORATION false
set_parameter_property H_BANKS HDL_PARAMETER true

add_parameter V_BANKS INTEGER 1
set_parameter_property V_BANKS DISPLAY_NAME "Vertical scaling coefficient banks"
set_parameter_property V_BANKS DESCRIPTION ""
set_parameter_property V_BANKS ALLOWED_RANGES 1:32
set_parameter_property V_BANKS AFFECTS_ELABORATION false
set_parameter_property V_BANKS HDL_PARAMETER true

add_parameter H_PHASE_BITS INTEGER 4
set_parameter_property H_PHASE_BITS DISPLAY_NAME "Horizontal phase bits"
set_parameter_property H_PHASE_BITS DESCRIPTION ""
set_parameter_property H_PHASE_BITS ALLOWED_RANGES 1:8
set_parameter_property H_PHASE_BITS AFFECTS_ELABORATION false
set_parameter_property H_PHASE_BITS HDL_PARAMETER true

add_parameter V_PHASE_BITS INTEGER 4
set_parameter_property V_PHASE_BITS DISPLAY_NAME "Vertical phase bits"
set_parameter_property V_PHASE_BITS DESCRIPTION ""
set_parameter_property V_PHASE_BITS ALLOWED_RANGES 1:8
set_parameter_property V_PHASE_BITS AFFECTS_ELABORATION false
set_parameter_property V_PHASE_BITS HDL_PARAMETER true

add_parameter H_TAPS INTEGER 8
set_parameter_property H_TAPS DISPLAY_NAME "Horizontal taps "
set_parameter_property H_TAPS DESCRIPTION ""
set_parameter_property H_TAPS ALLOWED_RANGES 1:64
set_parameter_property H_TAPS AFFECTS_ELABORATION true
set_parameter_property H_TAPS HDL_PARAMETER true

add_parameter V_TAPS INTEGER 8
set_parameter_property V_TAPS DISPLAY_NAME "Vertical taps"
set_parameter_property V_TAPS DESCRIPTION ""
set_parameter_property V_TAPS ALLOWED_RANGES 1:64
set_parameter_property V_TAPS AFFECTS_ELABORATION true
set_parameter_property V_TAPS HDL_PARAMETER true

add_parameter NO_BLANKING INTEGER 0
set_parameter_property NO_BLANKING DISPLAY_NAME "Video has no blanking"
set_parameter_property NO_BLANKING DESCRIPTION ""
set_parameter_property NO_BLANKING ALLOWED_RANGES 0:1
set_parameter_property NO_BLANKING AFFECTS_ELABORATION false
set_parameter_property NO_BLANKING HDL_PARAMETER true
set_parameter_property NO_BLANKING DISPLAY_HINT boolean

add_parameter ARE_IDENTICAL INTEGER 0
set_parameter_property ARE_IDENTICAL DISPLAY_NAME "Share horizontal and vertical coefficients"
set_parameter_property ARE_IDENTICAL ALLOWED_RANGES 0:1
set_parameter_property ARE_IDENTICAL DISPLAY_HINT boolean
set_parameter_property ARE_IDENTICAL DESCRIPTION "Forces the bicubic and polyphase algorithms to use the same horizontal and vertical scaling coefficients"
set_parameter_property ARE_IDENTICAL HDL_PARAMETER true
set_parameter_property ARE_IDENTICAL AFFECTS_ELABORATION false

add_parameter H_COEFF_WIDTH INTEGER 7
set_parameter_property H_COEFF_WIDTH DISPLAY_NAME "Horizontal coefficient data width"
set_parameter_property H_COEFF_WIDTH DESCRIPTION ""
set_parameter_property H_COEFF_WIDTH AFFECTS_ELABORATION true
set_parameter_property H_COEFF_WIDTH HDL_PARAMETER true

add_parameter V_COEFF_WIDTH INTEGER 7
set_parameter_property V_COEFF_WIDTH DISPLAY_NAME "Vertical coefficient data width"
set_parameter_property V_COEFF_WIDTH DESCRIPTION ""
set_parameter_property V_COEFF_WIDTH AFFECTS_ELABORATION true
set_parameter_property V_COEFF_WIDTH HDL_PARAMETER true

add_user_packet_support_parameters
set_parameter_property   USER_PACKET_FIFO_DEPTH   HDL_PARAMETER             false
set_parameter_property   USER_PACKET_FIFO_DEPTH   VISIBLE                   false

add_parameter PIPELINE_READY INTEGER 0
set_parameter_property PIPELINE_READY DISPLAY_NAME "Add extra interface registers"
set_parameter_property PIPELINE_READY DESCRIPTION ""
set_parameter_property PIPELINE_READY ALLOWED_RANGES 0:1
set_parameter_property PIPELINE_READY AFFECTS_ELABORATION false
set_parameter_property PIPELINE_READY HDL_PARAMETER true
set_parameter_property PIPELINE_READY DISPLAY_HINT boolean

add_parameter LIMITED_READBACK INTEGER 0
set_parameter_property LIMITED_READBACK DISPLAY_NAME "Reduced control slave register readback"
set_parameter_property LIMITED_READBACK DESCRIPTION ""
set_parameter_property LIMITED_READBACK ALLOWED_RANGES 0:1
set_parameter_property LIMITED_READBACK AFFECTS_ELABORATION false
set_parameter_property LIMITED_READBACK HDL_PARAMETER true
set_parameter_property LIMITED_READBACK DISPLAY_HINT boolean

# | connection point clock_reset

add_main_clock_port

proc scl_sched_validation_callback {} {

   if { [get_parameter_value NO_BLANKING] > 0 } {
      set comp [get_parameter_value USER_PACKET_SUPPORT]
      set match [string compare PASSTHROUGH $comp]
      if { $match == 0 } {
         send_message ERROR "Passthrough of user packets is not supported when the support for no blanking is enabled"
      }
      set control_exists [get_parameter_value RUNTIME_CONTROL]
      if { $control_exists == 0 } {
          set alg_name [get_parameter_value ALGORITHM]
          set match [string compare EDGE_ADAPT $alg_name]
          if { $match != 0 } {
              set match [string compare POLYPHASE $alg_name]
          }
          if { $match == 0 } {
              set control_exists [get_parameter_value LOAD_AT_RUNTIME]
          }
      }
      if { $control_exists == 0 } {
         send_message ERROR "Runtime control must be enabled when no blanking is enabled"
      }  
   }

   if { [get_parameter_value ARE_IDENTICAL] > 0 } {
      set   v_coeff_width  [get_parameter_value V_COEFF_WIDTH]
      set   h_coeff_width  [get_parameter_value H_COEFF_WIDTH]
      if { $v_coeff_width != $h_coeff_width } {
         send_message ERROR "Horizontal and vertical coefficient widths must be the same if shared coefficients are enabled"
      } 
      set   v_taps         [get_parameter_value V_TAPS]
      set   h_taps         [get_parameter_value H_TAPS]
      if { $v_taps != $h_taps } {
         send_message ERROR "Horizontal and vertical taps must be the same if shared coefficients are enabled"
      } 
      set   v_phases       [get_parameter_value V_PHASE_BITS]
      set   h_phases       [get_parameter_value H_PHASE_BITS]
      if { $v_phases != $h_phases } {
         send_message ERROR "Horizontal and vertical phase bits must be the same if shared coefficients are enabled"
      }
      set   v_banks        [get_parameter_value V_BANKS]
      set   h_banks        [get_parameter_value H_BANKS]
      if { $v_banks != $h_banks } {
         send_message ERROR "Horizontal and vertical banks must be the same if shared coefficients are enabled"
      } 
   }
}

# | Dynamic ports (elaboration callback)
proc scl_sched_elaboration_callback {} {

   set control_exists [get_parameter_value RUNTIME_CONTROL]
   if { $control_exists == 0 } {
       set alg_name [get_parameter_value ALGORITHM]
       set match [string compare EDGE_ADAPT $alg_name]
       if { $match != 0 } {
           set match [string compare POLYPHASE $alg_name]
       }
       if { $match == 0 } {
           set control_exists [get_parameter_value LOAD_AT_RUNTIME]
       }
   }
   set comp [get_parameter_value USER_PACKET_SUPPORT]
   set match [string compare PASSTHROUGH $comp]
   if { $match == 0 } {
      set user_level 2
   } else {
      set match [string compare DISCARD $comp]
      if { $match == 0 } {
         set user_level 1
      } else {
         set user_level 0
      }
   }

   if { [get_parameter_value SEPARATE_V_H_CORE] > 0 } {
      set alg_name [get_parameter_value ALGORITHM]
      set match [string compare NEAREST_NEIGHBOUR $alg_name]
      if { $match != 0 } {
         set   num_ac_cmd  2
      } else {
         set   num_ac_cmd  1
      }
   } else {
      set   num_ac_cmd     1
   }

   add_av_st_resp_sink_port         av_st_resp_vib             1  8  8  8  8  main_clock  0
   add_av_st_resp_sink_port         av_st_resp_kc              1  8  8  8  8  main_clock  0
   add_av_st_resp_sink_port         av_st_resp_ac              1  8  8  8  8  main_clock  0
   add_av_st_cmd_source_port        av_st_cmd_kc               1  8  8  8  8  main_clock  0
   if { $user_level > 0 } {
      add_av_st_cmd_source_port     av_st_cmd_vib              1  8  8  8  8  main_clock  0
   }
   add_av_st_cmd_source_port        av_st_cmd_lb               1  8  8  8  8  main_clock  0
   add_av_st_array_cmd_source_port  av_st_cmd_ac   $num_ac_cmd 1  8  8  8  8  main_clock  0
   if { $user_level > 1 } {
      add_av_st_cmd_source_port     av_st_cmd_pm               1  8  8  8  8  main_clock  0
   }
   add_av_st_cmd_source_port        av_st_cmd_vob              1  8  8  8  8  main_clock  0

   if { [get_parameter_value LOAD_AT_RUNTIME] > 0 } {

      set   data_start  0
      for { set i 0 } { $i < $num_ac_cmd } { incr i } {
         if { $num_ac_cmd == 1 } {
            if { [get_parameter_value H_COEFF_WIDTH] > [get_parameter_value V_COEFF_WIDTH] } {
               set   coeff_data_width  [get_parameter_value H_COEFF_WIDTH]
            } else {
               set   coeff_data_width  [get_parameter_value V_COEFF_WIDTH]
            } 
         } else {
            if { $i == 0 } {
               set   coeff_data_width  [get_parameter_value H_COEFF_WIDTH]
            } else {
               set   coeff_data_width  [get_parameter_value V_COEFF_WIDTH]
            }
         }
         set   control_width     32
         set   data_end          [expr $data_start + $coeff_data_width + $control_width]
         
         add_interface           av_st_coeff_$i avalon_streaming  start
         set_interface_property  av_st_coeff_$i readyLatency      0
         set_interface_property  av_st_coeff_$i ASSOCIATED_CLOCK  main_clock
         set_interface_property  av_st_coeff_$i ENABLED           true
         
         add_interface_port      av_st_coeff_$i av_st_coeff_valid_$i           valid          Output   1
         add_interface_port      av_st_coeff_$i av_st_coeff_ready_$i           ready          Input    1
         add_interface_port      av_st_coeff_$i av_st_coeff_startofpacket_$i   startofpacket  Output   1
         add_interface_port      av_st_coeff_$i av_st_coeff_endofpacket_$i     endofpacket    Output   1
         add_interface_port      av_st_coeff_$i av_st_coeff_data_$i data Output [expr $coeff_data_width + $control_width]
         
         set_port_property       av_st_coeff_ready_$i          FRAGMENT_LIST  "av_st_coeff_ready@$i"
         set_port_property       av_st_coeff_valid_$i          FRAGMENT_LIST  "av_st_coeff_valid@$i"
         set_port_property       av_st_coeff_startofpacket_$i  FRAGMENT_LIST  "av_st_coeff_startofpacket@$i"
         set_port_property       av_st_coeff_endofpacket_$i    FRAGMENT_LIST  "av_st_coeff_endofpacket@$i"
         set_port_property       av_st_coeff_data_$i           FRAGMENT_LIST  "av_st_coeff_data@[expr $data_end-1]:$data_start"
         
         set   data_start        $data_end
         
         alt_vip_av_st_message_format::set_message_property           av_st_coeff_$i                PEID              0
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i argument       SYMBOLS_PER_BEAT  1
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i argument       SYMBOL_WIDTH      $coeff_data_width
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i destination    BASE              0
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i destination    SYMBOL_WIDTH      8
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i source         BASE              8
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i source         SYMBOL_WIDTH      8
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i taskid         BASE              16
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i taskid         SYMBOL_WIDTH      8
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i context        BASE              24
         alt_vip_av_st_message_format::set_message_subfield_property  av_st_coeff_$i context        SYMBOL_WIDTH      8
         alt_vip_av_st_message_format::validate_and_create            av_st_coeff_$i
      }

      if { [get_parameter_value H_TAPS] > [get_parameter_value V_TAPS] } {
         set   max_taps   [get_parameter_value H_TAPS]
      } else {
         set   max_taps   [get_parameter_value V_TAPS]
      }
      set   num_reg      [expr 14 + $max_taps]
   } else {
      set   num_reg      5
   }
   set   addr_width   7 

   if { $control_exists > 0 } {
      add_control_slave_port   av_mm_control   $addr_width   $num_reg   0   1   1   1   main_clock
   }
   
}
