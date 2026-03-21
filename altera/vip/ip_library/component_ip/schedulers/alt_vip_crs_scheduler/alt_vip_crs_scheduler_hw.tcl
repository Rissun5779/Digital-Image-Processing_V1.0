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

# Common module properties for VIP top-level IP
declare_general_component_info
set_module_property  NAME           alt_vip_crs_scheduler
set_module_property  DISPLAY_NAME   "CRS Scheduler"
set_module_property  DESCRIPTION    ""

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set_module_property  VALIDATION_CALLBACK  validation_cb
set_module_property  ELABORATION_CALLBACK elaboration_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_alt_vip_common_pkg_files ../../..
add_alt_vip_common_event_packet_decode_files ../../..
add_alt_vip_common_event_packet_encode_files ../../..
add_alt_vip_common_slave_interface_files ../../..
add_static_sv_file src_hdl/alt_vip_crs_scheduler.sv

add_static_misc_file src_hdl/alt_vip_crs_scheduler.ocp

setup_filesets alt_vip_crs_scheduler

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_parameter           ALGORITHM                     STRING               BILINEAR
set_parameter_property  ALGORITHM                     DISPLAY_NAME         "Vertical resampling algorithm"
set_parameter_property  ALGORITHM                     ALLOWED_RANGES       {NEAREST_NEIGHBOUR BILINEAR FILTERED} 
set_parameter_property  ALGORITHM                     AFFECTS_ELABORATION  false
set_parameter_property  ALGORITHM                     HDL_PARAMETER        true

add_parameter           CO_SITING                     STRING               TOP
set_parameter_property  CO_SITING                     DISPLAY_NAME         "Vertical chroma siting"
set_parameter_property  CO_SITING                     ALLOWED_RANGES       {TOP CENTRE} 
set_parameter_property  CO_SITING                     AFFECTS_ELABORATION  false
set_parameter_property  CO_SITING                     HDL_PARAMETER        true

add_parameter           VARIABLE_SIDE                 STRING               NEITHER
set_parameter_property  VARIABLE_SIDE                 DISPLAY_NAME         "Variable 3 colour interface"
set_parameter_property  VARIABLE_SIDE                 ALLOWED_RANGES       {NEITHER INPUT OUTPUT} 
set_parameter_property  VARIABLE_SIDE                 AFFECTS_ELABORATION  true
set_parameter_property  VARIABLE_SIDE                 HDL_PARAMETER        true

add_parameter           ENABLE_444_IN                 INTEGER              0
set_parameter_property  ENABLE_444_IN                 DISPLAY_NAME         "Enable 4:4:4 input"
set_parameter_property  ENABLE_444_IN                 DESCRIPTION          ""
set_parameter_property  ENABLE_444_IN                 ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_444_IN                 AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_444_IN                 HDL_PARAMETER        true
set_parameter_property  ENABLE_444_IN                 DISPLAY_HINT         boolean

add_parameter           ENABLE_422_IN                 INTEGER              1
set_parameter_property  ENABLE_422_IN                 DISPLAY_NAME         "Enable 4:2:2 input"
set_parameter_property  ENABLE_422_IN                 DESCRIPTION          ""
set_parameter_property  ENABLE_422_IN                 ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_422_IN                 AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_422_IN                 HDL_PARAMETER        true
set_parameter_property  ENABLE_422_IN                 DISPLAY_HINT         boolean

add_parameter           ENABLE_420_IN                 INTEGER              0
set_parameter_property  ENABLE_420_IN                 DISPLAY_NAME         "Enable 4:2:0 input"
set_parameter_property  ENABLE_420_IN                 DESCRIPTION          ""
set_parameter_property  ENABLE_420_IN                 ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_420_IN                 AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_420_IN                 HDL_PARAMETER        true
set_parameter_property  ENABLE_420_IN                 DISPLAY_HINT         boolean

add_parameter           ENABLE_444_OUT                INTEGER              1
set_parameter_property  ENABLE_444_OUT                DISPLAY_NAME         "Enable 4:4:4 output"
set_parameter_property  ENABLE_444_OUT                DESCRIPTION          ""
set_parameter_property  ENABLE_444_OUT                ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_444_OUT                AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_444_OUT                HDL_PARAMETER        true
set_parameter_property  ENABLE_444_OUT                DISPLAY_HINT         boolean

add_parameter           ENABLE_422_OUT                INTEGER              0
set_parameter_property  ENABLE_422_OUT                DISPLAY_NAME         "Enable 4:2:2 output"
set_parameter_property  ENABLE_422_OUT                DESCRIPTION          ""
set_parameter_property  ENABLE_422_OUT                ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_422_OUT                AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_422_OUT                HDL_PARAMETER        true
set_parameter_property  ENABLE_422_OUT                DISPLAY_HINT         boolean

add_parameter           ENABLE_420_OUT                INTEGER              0
set_parameter_property  ENABLE_420_OUT                DISPLAY_NAME         "Enable 4:2:0 output"
set_parameter_property  ENABLE_420_OUT                DESCRIPTION          ""
set_parameter_property  ENABLE_420_OUT                ALLOWED_RANGES       0:1
set_parameter_property  ENABLE_420_OUT                AFFECTS_ELABORATION  true
set_parameter_property  ENABLE_420_OUT                HDL_PARAMETER        true
set_parameter_property  ENABLE_420_OUT                DISPLAY_HINT         boolean

add_user_packet_support_parameters
set_parameter_property  USER_PACKET_FIFO_DEPTH        HDL_PARAMETER        false
set_parameter_property  USER_PACKET_SUPPORT           HDL_PARAMETER        true
set_parameter_property  USER_PACKET_FIFO_DEPTH        VISIBLE              false

add_parameter           PIPELINE_READY                INTEGER              0
set_parameter_property  PIPELINE_READY                DISPLAY_NAME         "Add extra pipelining registers"
set_parameter_property  PIPELINE_READY                DESCRIPTION          ""
set_parameter_property  PIPELINE_READY                ALLOWED_RANGES       0:1
set_parameter_property  PIPELINE_READY                AFFECTS_ELABORATION  false
set_parameter_property  PIPELINE_READY                HDL_PARAMETER        true
set_parameter_property  PIPELINE_READY                DISPLAY_HINT         boolean

add_parameter           LIMITED_READBACK              INTEGER              0
set_parameter_property  LIMITED_READBACK              DISPLAY_NAME         "Reduced control slave register readback"
set_parameter_property  LIMITED_READBACK              DESCRIPTION          ""
set_parameter_property  LIMITED_READBACK              ALLOWED_RANGES       0:1
set_parameter_property  LIMITED_READBACK              AFFECTS_ELABORATION  false
set_parameter_property  LIMITED_READBACK              HDL_PARAMETER        true
set_parameter_property  LIMITED_READBACK              DISPLAY_HINT         boolean

proc validation_cb {} {
      
   set   enable_420_in                       [get_parameter_value ENABLE_420_IN]
   set   enable_420_out                      [get_parameter_value ENABLE_420_OUT]
   set   enable_444_in                       [get_parameter_value ENABLE_444_IN]
   set   enable_422_in                       [get_parameter_value ENABLE_422_IN]
   set   enable_444_out                      [get_parameter_value ENABLE_444_OUT]
   set   enable_422_out                      [get_parameter_value ENABLE_422_OUT]
   set   modes_in                            [expr $enable_444_in + $enable_422_in + $enable_420_in]
   set   modes_out                           [expr $enable_420_out + $enable_422_out + $enable_444_out]

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
               send_message Error "The Chroma Resampler Scheduler does not support fixed 4:2:2->4:2:2 conversion"
            }
         } else {
            if { $enable_444_in > 0 } {
               if { $enable_444_out > 0 } {
                  send_message Error "The Chroma Resampler Scheduler does not support fixed 4:4:4->4:4:4 conversion"
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

}

proc elaboration_cb {} {
   global isVersion acdsVersion  

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
   set   enable_444_in                       [get_parameter_value ENABLE_444_IN]
   set   enable_422_in                       [get_parameter_value ENABLE_422_IN]
   set   enable_444_out                      [get_parameter_value ENABLE_444_OUT]
   set   enable_422_out                      [get_parameter_value ENABLE_422_OUT]
   set   modes_in                            [expr $enable_444_in + $enable_422_in + $enable_420_in]
   set   modes_out                           [expr $enable_420_out + $enable_422_out + $enable_444_out]
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
   set   enable_vib_cmd                      0
   set   enable_lb_cmd                       0
   set   enable_mm_cmd                       0
   set   enable_om_cmd                       0
   set   control_exists                      0
   if { $modes_in > 1 } {
      set   enable_vib_cmd                   1
      set   control_exists                   1
   }
   if { $modes_out > 1 } {
      set   enable_vib_cmd                   1
      set   control_exists                   1
   }
   if { $enable_user > 0 } {
      set   enable_vib_cmd                   1
   }
   if { $enable_discard > 0 } {
      set   enable_vib_cmd                   1
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
     
   add_main_clock_port
   add_av_st_resp_sink_port      av_st_resp_vib          1  8  8  8  8  main_clock  0
   if { $enable_vib_cmd > 0 } {
      add_av_st_cmd_source_port  av_st_cmd_vib           1  8  8  8  8  main_clock  0
   }
   if { $enable_mm_cmd > 0 } {
      add_av_st_cmd_source_port  av_st_cmd_middle_mux    1  8  8  8  8  main_clock  0
   }
   if { $enable_om_cmd > 0 } {
      add_av_st_cmd_source_port  av_st_cmd_output_mux    1  8  8  8  8  main_clock  0
   }
   if { $enable_420 > 0 } {
      add_av_st_cmd_source_port  av_st_cmd_line_buffer   1  8  8  8  8  main_clock  0
      add_av_st_cmd_source_port  av_st_cmd_vert_resample 1  8  8  8  8  main_clock  0
   }
   add_av_st_cmd_source_port     av_st_cmd_vob           1  8  8  8  8  main_clock  0
   if { $control_exists > 0 } {
      set   addr_width  2
      set   num_reg     4
      add_control_slave_port   av_mm_control   $addr_width   $num_reg   0   1   1   1   main_clock
   }
}
