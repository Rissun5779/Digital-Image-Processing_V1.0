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


package require -exact qsys 14.0
package require altera_terp

source ../lib/tcl/avalon_streaming_util.tcl
source "../lib/tcl/dspip_common.tcl"

load_strings altera_fft_ii.properties

# 
# module fft_ii
# 
set_module_property NAME altera_fft_ii
set_module_property DISPLAY_NAME "FFT" 
#set_module_property DISPLAY_NAME [get_string DISPLAY_NAME]
set_module_property DESCRIPTION [get_string DESCRIPTION]
set_module_property GROUP "DSP/Transforms" 
#set_module_property GROUP [get_string GROUP]
set_module_property VERSION  18.1
set_module_property AUTHOR [get_string AUTHOR]
set_module_property INTERNAL false
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QSYS false
set_module_property HELPER_JAR fft_helper.jar
set_module_property SUPPORTED_DEVICE_FAMILIES \
{\
{Stratix 10} {Arria 10} {Arria V} {Arria V GZ} {Arria II GX} {Arria II GZ} \
{Cyclone 10 LP} {Cyclone V} {Cyclone IV E} {Cyclone IV GX}\
{Max 10 FPGA}\
{Stratix V} {Stratix IV}\
}

set_module_property VALIDATION_CALLBACK validate_input
set_module_property ELABORATION_CALLBACK elaboration_callback

add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_verilog SIM_VERILOG generate_sim_verilog
add_fileset sim_vhdl SIM_VHDL generate_sim_vhdl
add_fileset example_design EXAMPLE_DESIGN example_fileset "FFT II Example Design"

#
# documentation
#
## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/hco1419012539637/hco1419012438961
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697815758

# 
# file sets
# 


# 
# parameters
# 
add_parameter length POSITIVE 1024
set_parameter_property length DISPLAY_NAME [get_string LENGTH_DISPLAY_NAME] 
set_parameter_property length UNITS None
set_parameter_property length ALLOWED_RANGES \
{8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144}
set_parameter_property length DESCRIPTION [get_string LENGTH_DESCRIPTION] 
set_parameter_property length AFFECTS_GENERATION true 

add_parameter data_flow STRING "Variable Streaming" 
set_parameter_property data_flow DISPLAY_NAME [get_string DATA_FLOW_DISPLAY_NAME] 
#set_parameter_property data_flow DISPLAY_HINT "radio"
set_parameter_property data_flow UNITS None
set_parameter_property data_flow ALLOWED_RANGES {"Buffered Burst" "Burst" "Streaming" "Variable Streaming"} 
set_parameter_property data_flow DESCRIPTION [get_string DATA_FLOW_DESCRIPTION] 
set_parameter_property data_flow LONG_DESCRIPTION [get_string DATA_FLOW_LONG_DESCRIPTION] 
set_parameter_property data_flow AFFECTS_GENERATION true

add_parameter direction STRING "Bi-directional" 
set_parameter_property direction DISPLAY_NAME [get_string DIRECTION_DISPLAY_NAME] 
set_parameter_property direction UNITS None
set_parameter_property direction ALLOWED_RANGES {"Forward" "Reverse" "Bi-directional"} 
set_parameter_property direction DESCRIPTION [get_string DIRECTION_DESCRIPTION] 
set_parameter_property direction AFFECTS_GENERATION true

add_parameter data_rep STRING "Fixed Point" 
set_parameter_property data_rep DISPLAY_NAME [get_string DATA_REP_DISPLAY_NAME] 
#set_parameter_property data_rep DISPLAY_HINT "radio"
set_parameter_property data_rep UNITS None
set_parameter_property data_rep ALLOWED_RANGES {"Fixed Point" "Single Floating Point" "Block Floating Point"} 
set_parameter_property data_rep DESCRIPTION [get_string DATA_REP_DESCRIPTION] 
set_parameter_property data_rep AFFECTS_GENERATION true

add_parameter in_width POSITIVE 18
set_parameter_property in_width DISPLAY_NAME [get_string IN_WIDTH_DISPLAY_NAME] 
set_parameter_property in_width UNITS Bits
set_parameter_property in_width ALLOWED_RANGES {8 10 12 14 16 18 20 24 28 32}
set_parameter_property in_width DESCRIPTION [get_string IN_WIDTH_DESCRIPTION] 
set_parameter_property in_width AFFECTS_GENERATION true 

add_parameter in_width_derived POSITIVE 18
set_parameter_property in_width_derived DISPLAY_NAME "Data Input Width"
set_parameter_property in_width_derived UNITS Bits
set_parameter_property in_width_derived DERIVED true 
set_parameter_property in_width_derived DESCRIPTION "Data input width"
set_parameter_property in_width_derived AFFECTS_GENERATION true 

add_parameter out_width POSITIVE 29
set_parameter_property out_width DISPLAY_NAME [get_string OUT_WIDTH_DISPLAY_NAME] 
set_parameter_property out_width UNITS Bits
set_parameter_property out_width DESCRIPTION [get_string OUT_WIDTH_DESCRIPTION] 
set_parameter_property out_width AFFECTS_GENERATION true 

add_parameter out_width_derived POSITIVE 29
set_parameter_property out_width_derived DISPLAY_NAME "Data Output Width"
set_parameter_property out_width_derived UNITS Bits
set_parameter_property out_width_derived DERIVED true
set_parameter_property out_width_derived DESCRIPTION "Data output width"
set_parameter_property out_width_derived AFFECTS_GENERATION true 

add_parameter twid_width POSITIVE 18
set_parameter_property twid_width DISPLAY_NAME [get_string TWID_WIDTH_DISPLAY_NAME] 
set_parameter_property twid_width UNITS Bits
set_parameter_property twid_width ALLOWED_RANGES {8 10 12 14 16 18 20 24 28 32}
set_parameter_property twid_width DESCRIPTION [get_string TWID_WIDTH_DESCRIPTION] 
set_parameter_property twid_width AFFECTS_GENERATION true 

add_parameter twid_width_derived POSITIVE 18
set_parameter_property twid_width_derived DISPLAY_NAME "Twiddle Width"
set_parameter_property twid_width_derived UNITS Bits
set_parameter_property twid_width_derived DERIVED true 
set_parameter_property twid_width_derived DESCRIPTION "Twiddle width"
set_parameter_property twid_width_derived AFFECTS_GENERATION true 

add_parameter in_order STRING "Natural" 
set_parameter_property in_order DISPLAY_NAME [get_string IN_ORDER_DISPLAY_NAME] 
set_parameter_property in_order UNITS None
set_parameter_property in_order ALLOWED_RANGES {"Natural" "Digit Reverse"} 
set_parameter_property in_order DESCRIPTION [get_string IN_ORDER_DESCRIPTION] 
set_parameter_property in_order AFFECTS_GENERATION true

add_parameter out_order STRING "Digit Reverse" 
set_parameter_property out_order DISPLAY_NAME [get_string OUT_ORDER_DISPLAY_NAME] 
set_parameter_property out_order UNITS None
set_parameter_property out_order ALLOWED_RANGES {"Natural" "Digit Reverse"} 
set_parameter_property out_order DESCRIPTION [get_string OUT_ORDER_DESCRIPTION] 
set_parameter_property out_order AFFECTS_GENERATION true

add_parameter engine_arch STRING "Quad Output" 
set_parameter_property engine_arch DISPLAY_NAME [get_string ENGINE_ARCH_DISPLAY_NAME] 
set_parameter_property engine_arch UNITS None
set_parameter_property engine_arch ALLOWED_RANGES {"Quad Output" "Single Output"} 
set_parameter_property engine_arch DESCRIPTION [get_string ENGINE_ARCH_DESCRIPTION] 
set_parameter_property engine_arch AFFECTS_GENERATION true

add_parameter num_engines POSITIVE 1 
set_parameter_property num_engines DISPLAY_NAME [get_string NUM_ENGINES_DISPLAY_NAME] 
set_parameter_property num_engines UNITS None
set_parameter_property num_engines ALLOWED_RANGES {1 2 4} 
set_parameter_property num_engines DESCRIPTION [get_string NUM_ENGINES_DESCRIPTION] 
set_parameter_property num_engines AFFECTS_GENERATION true

add_parameter num_engines_derived POSITIVE 1 
set_parameter_property num_engines_derived VISIBLE false
set_parameter_property num_engines_derived DERIVED true 
set_parameter_property num_engines_derived ALLOWED_RANGES {1 2 4} 
set_parameter_property num_engines_derived AFFECTS_GENERATION true

add_parameter dsp_resource_opt boolean false 
set_parameter_property dsp_resource_opt DISPLAY_NAME [get_string DSP_RESOURCE_OPT_DISPLAY_NAME] 
set_parameter_property dsp_resource_opt UNITS None
set_parameter_property dsp_resource_opt DESCRIPTION [get_string DSP_RESOURCE_OPT_DESCRIPTION] 
set_parameter_property dsp_resource_opt AFFECTS_GENERATION true

add_parameter hard_fp boolean false 
set_parameter_property hard_fp DISPLAY_NAME [get_string HARD_FP_DISPLAY_NAME] 
set_parameter_property hard_fp UNITS None
set_parameter_property hard_fp DESCRIPTION [get_string HARD_FP_DESCRIPTION] 
set_parameter_property hard_fp AFFECTS_GENERATION true

add_parameter hyper_opt boolean false 
set_parameter_property hyper_opt DISPLAY_NAME [get_string HYPER_OPT_DISPLAY_NAME] 
set_parameter_property hyper_opt UNITS None
set_parameter_property hyper_opt DESCRIPTION [get_string HYPER_OPT_DESCRIPTION] 
set_parameter_property hyper_opt AFFECTS_GENERATION true

add_parameter CALC_LATENCY POSITIVE 1
set_parameter_property CALC_LATENCY DISPLAY_NAME [get_string CALC_LATENCY_DISPLAY_NAME] 
set_parameter_property CALC_LATENCY UNITS Cycles
set_parameter_property CALC_LATENCY DESCRIPTION [get_string CALC_LATENCY_DESCRIPTION] 
set_parameter_property CALC_LATENCY AFFECTS_GENERATION true 
set_parameter_property CALC_LATENCY DERIVED true 


add_parameter THROUGHPUT_LATENCY POSITIVE 1
set_parameter_property THROUGHPUT_LATENCY DISPLAY_NAME [get_string THROUGHPUT_LATENCY_DISPLAY_NAME] 
set_parameter_property THROUGHPUT_LATENCY UNITS Cycles
set_parameter_property THROUGHPUT_LATENCY DESCRIPTION [get_string THROUGHPUT_LATENCY_DESCRIPTION] 
set_parameter_property THROUGHPUT_LATENCY AFFECTS_GENERATION true 
set_parameter_property THROUGHPUT_LATENCY DERIVED true 


#
# display items
#
add_display_item "" Basic GROUP
set_display_item_property Basic DISPLAY_HINT TAB
add_display_item "" Advanced GROUP
set_display_item_property Advanced DISPLAY_HINT TAB

add_display_item Basic Transform GROUP
add_display_item Basic "I/O" GROUP
add_display_item Basic "Data and Twiddle" GROUP
add_display_item Basic "Latency Estimates" GROUP
add_display_item Advanced "FFT Engine Option" GROUP
add_display_item Advanced "Complex Multiplier Options" GROUP
add_display_item Advanced "Stratix 10 Options" GROUP

set_display_item_property "FFT Engine Option" VISIBLE false
set_display_item_property "Complex Multiplier Options" VISIBLE false
set_display_item_property "Stratix 10 Options" VISIBLE false

add_display_item "I/O" data_flow PARAMETER
add_display_item "I/O" in_order PARAMETER
add_display_item "I/O" out_order PARAMETER

add_display_item Transform length PARAMETER
add_display_item Transform direction PARAMETER

add_display_item "Data and Twiddle" data_rep PARAMETER
add_display_item "Data and Twiddle" in_width PARAMETER
add_display_item "Data and Twiddle" twid_width PARAMETER
add_display_item "Data and Twiddle" out_width PARAMETER
add_display_item "Data and Twiddle" in_width_derived PARAMETER
add_display_item "Data and Twiddle" out_width_derived PARAMETER
add_display_item "Data and Twiddle" twid_width_derived PARAMETER

add_display_item "FFT Engine Option" engine_arch PARAMETER
add_display_item "FFT Engine Option" num_engines PARAMETER

add_display_item "Complex Multiplier Options" hard_fp PARAMETER
add_display_item "Complex Multiplier Options" dsp_resource_opt PARAMETER
add_display_item "Stratix 10 Options" hyper_opt PARAMETER
add_display_item "Latency Estimates" CALC_LATENCY PARAMETER
add_display_item "Latency Estimates" THROUGHPUT_LATENCY PARAMETER


# 
# device parameters
# 
add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}

# Quartus doesn't honour the DEDICATED_MULTIPLIER_CIRCUITRY
# hint on SIII/SIV/AII devices. Instead it produces a warning message.
# Worse, it complains about DEDICATED_MULTIPLIER_CIRCUITRY in the altmult_add
# megafunction even if we  don't set that parameter explicitly. Quartus doesn't
# even like the default AUTO setting. So we're going to suppress all those
# messages here, so that  the IP conforms to Altera's warning-free
# standards.
set_qip_strings {"set_instance_assignment -entity %entityName% -library %libraryName% -name MESSAGE_DISABLE 270007"} 

proc validate_input {} {
   validate_direction
   validate_length
   validate_io_orders
   validate_data_rep_and_width 
   validate_fft_engine_option
   validate_dsp_opt
   validate_hyper_opt
   validate_advanced_tab
   show_digitrev_base
}


proc show_digitrev_base {} {
   if {[is_floating_variable_streaming] && [get_dsp_arch] ne 3} {
      send_message INFO "Radix-4 digit reverse implied"
   } else {
      send_message INFO "Radix-2 digit reverse implied"
   }
}


proc validate_direction {} {
   if { ! [is_floating_variable_streaming] || [get_dsp_arch] == 3 } {
      set direction [get_parameter_value direction] 
      if { $direction ne "Bi-directional" } {
         send_message ERROR "$direction direction is only valid for Variable Streaming data flow and Single Floating Point representation with hard floating point blocks disabled" 
      }
   } 
}

proc validate_length {} {
   if { ! [is_variable_streaming] } {
      set length [get_parameter_value length] 
      if { $length < 64 || $length > 65536 } {
         send_message ERROR "Length is limited to the 64 to 65536 range for [get_parameter_value data_flow] data flow"
      }
   }
}

proc validate_io_orders {} {
   if { [is_variable_streaming] } {
      if { [is_single_floating_point] && [get_dsp_arch] ne 3 } {
         set direction [get_parameter_value direction]
         switch -exact $direction {
            Forward {
               set_parameter_property in_order ALLOWED_RANGES {"Natural"}
               set_parameter_property out_order ALLOWED_RANGES {"Natural" "Digit Reverse"}
            }

            Reverse {
               set_parameter_property in_order ALLOWED_RANGES {"Digit Reverse"}
               set_parameter_property out_order ALLOWED_RANGES {"Natural"}
            }

            Bi-directional {
               set_parameter_property in_order ALLOWED_RANGES {"Natural"}
               set_parameter_property out_order ALLOWED_RANGES {"Digit Reverse"}
            }
         }
      } else {
            set_parameter_property in_order ALLOWED_RANGES {"Natural" "Digit Reverse"}
            set_parameter_property out_order ALLOWED_RANGES {"Natural" "Digit Reverse"}
      }
   } else {
            set_parameter_property in_order ALLOWED_RANGES {"Natural"}
            set_parameter_property out_order ALLOWED_RANGES {"Natural"}
   }
}

proc validate_data_rep_and_width {} {
   if { [is_variable_streaming] } {
      if { [is_block_floating_point] } {
         send_message ERROR "Block Floating Point representation is not available for Variable Streaming data flow"
      }

      if { [is_fixed_point] } {
         set in_width [get_parameter_value in_width]
         set length [get_parameter_value length]
         set_parameter_property out_width ALLOWED_RANGES $in_width:[expr {int($in_width + [log2 $length]) + 1}] 
         set_parameter_property in_width VISIBLE true
         set_parameter_property out_width VISIBLE true 
         set_parameter_property twid_width VISIBLE true
         set_parameter_property in_width_derived VISIBLE false 
         set_parameter_property out_width_derived VISIBLE false 
         set_parameter_property twid_width_derived VISIBLE false 
         set_parameter_value in_width_derived [get_parameter_value in_width]         
         set_parameter_value out_width_derived [get_parameter_value out_width]         
         set_parameter_value twid_width_derived [get_parameter_value twid_width]         
      } else {
         set_parameter_property in_width VISIBLE false
         set_parameter_property out_width VISIBLE false 
         set_parameter_property twid_width VISIBLE false
         set_parameter_property in_width_derived VISIBLE false 
         set_parameter_property out_width_derived VISIBLE false 
         set_parameter_property twid_width_derived VISIBLE false 
         set_parameter_value in_width_derived 32         
         set_parameter_value out_width_derived 32         
         set_parameter_value twid_width_derived 32         
      }
   } else {
      if { ![is_block_floating_point] } {
         send_message ERROR "Only the Block Floating Point representation is available for [get_parameter_value data_flow] data flow"
      }
      set_parameter_property in_width VISIBLE true
      set_parameter_property out_width VISIBLE false 
      set_parameter_property twid_width VISIBLE true 
      set_parameter_property in_width_derived VISIBLE false 
      set_parameter_property out_width_derived VISIBLE true 
      set_parameter_property twid_width_derived VISIBLE false 
      set_parameter_value in_width_derived [get_parameter_value in_width]         
      set_parameter_value out_width_derived [get_parameter_value in_width]         
      set_parameter_value twid_width_derived [get_parameter_value twid_width]         
   }

   if { ![get_parameter_property out_width VISIBLE] } {
     # clear allowed range, to stop validation errors which are no longer applicable
     # for example, if a user changed length and got this error and then selected 
     # streaming, then this is no longer applicable.
     set_parameter_property out_width ALLOWED_RANGES 0:999
   }
}


proc validate_fft_engine_option {} {
   set arch [get_parameter_value data_flow]
   set_parameter_value num_engines_derived [get_parameter_value num_engines]
   if { [string first "Burst" $arch] ne -1 } {
      set_display_item_property "FFT Engine Option" VISIBLE true
      set engine_arch [get_parameter_value engine_arch]
      set num_engines [get_parameter_value num_engines_derived]
      if { $engine_arch eq {Single Output} } {
         if { $arch eq {Buffered Burst} } {
            send_message ERROR "Single Output architecture is only available for Burst data flow" 
         }
         if { $num_engines == 4 } {
            send_message ERROR "Single Output architectrue can only support a maximum of 2 engines"
         } 
      } else {
         set length [get_parameter_value length]
         if { $length < 256 && $num_engines == 4 } {
            send_message ERROR "Transform length must be at least 256 for 4 engines"
         }
      }
   } else {
      if { $arch eq {Streaming} } {
         set length [get_parameter_value length]
         set_parameter_value num_engines_derived [expr {$length > 1024 ? 2 : 1}]
      } 
      set_display_item_property "FFT Engine Option" VISIBLE false
   }
}

proc validate_dsp_opt {} {
   set family [get_parameter_value selected_device_family]
   set hard_fp [get_parameter_value hard_fp]
   set_parameter_property hard_fp visible false
   set_parameter_property dsp_resource_opt VISIBLE false 
   if { [is_variable_streaming] } {
      if { $family eq "Stratix V" || $family eq "Arria V GZ" } {
         set_display_item_property "Complex Multiplier Options" VISIBLE true
         set_parameter_property dsp_resource_opt VISIBLE true 
      } else {
         if { [is_single_floating_point] && ($family eq "Arria V" || $family eq "Cyclone V") } {
            set_display_item_property "Complex Multiplier Options" VISIBLE true
            set_parameter_property dsp_resource_opt VISIBLE true 
         } elseif { [is_single_floating_point] && (($family eq "Arria 10") || ($family eq "Stratix 10")) } { 
            set_parameter_property hard_fp visible true    
            if { $hard_fp } {
               set_parameter_property dsp_resource_opt VISIBLE false 
               set_display_item_property "Complex Multiplier Options" VISIBLE true
            }  else {
               set_parameter_property dsp_resource_opt VISIBLE true 
               set_display_item_property "Complex Multiplier Options" VISIBLE true
            }      
         } else { 
            set_display_item_property "Complex Multiplier Options" VISIBLE false
            set_parameter_property dsp_resource_opt VISIBLE false 
         }
      }
   } else {
      set_display_item_property "Complex Multiplier Options" VISIBLE false
      set_parameter_property dsp_resource_opt VISIBLE false 
   }

}

proc validate_hyper_opt {} {
   set family [get_parameter_value selected_device_family]
   if {($family eq "Arria 10" || $family eq "Stratix 10") && [is_variable_streaming]} {
      set_display_item_property "Stratix 10 Options" VISIBLE true
   } else {
      set_display_item_property "Stratix 10 Options" VISIBLE false
   }
}

proc validate_advanced_tab {} {
   if { [get_display_item_property "FFT Engine Option" VISIBLE] ||
        [get_display_item_property "Complex Multiplier Options" VISIBLE] || 
        [get_display_item_property "Stratix 10 Options" VISIBLE] } {
      set_display_item_property "Advanced" VISIBLE true 
   } else {
      set_display_item_property "Advanced" VISIBLE false 
   } 
}

proc elaboration_callback {} {
   set in_width [get_parameter_value in_width_derived]
   set out_width [get_parameter_value out_width_derived]

   set sink_data_width [expr {$in_width + $in_width}] 
   set source_data_width [expr {$out_width + $out_width}] 
   set sink_data_fragment_list "sink_real $in_width sink_imag $in_width"
   set source_data_fragment_list "source_real $out_width source_imag $out_width"

   if { [is_variable_streaming] } {
      set length_width [expr {[get_length_msb]+1}]
      set sink_data_width [expr {$sink_data_width + $length_width}] 
      set source_data_width [expr {$source_data_width + $length_width}] 
      append sink_data_fragment_list " fftpts_in $length_width"
      append source_data_fragment_list " fftpts_out $length_width"
   } else {
      set source_data_width [expr {$source_data_width + 6}]
      append source_data_fragment_list " source_exp 6"
   }

   if { [is_bidirectional] } {
      set sink_data_width [expr {$sink_data_width + 1}]
      append sink_data_fragment_list " inverse 1"
   }

   add_interface clk clock end
   add_interface_port clk clk clk Input 1

   add_interface rst reset end
   set_interface_property rst associatedClock clk
   add_interface_port rst reset_n reset_n Input 1

   dsp_add_streaming_interface sink sink
   dsp_set_interface_property sink associatedClock clk
   dsp_set_interface_property sink dataBitsPerSymbol $sink_data_width
   dsp_add_interface_port sink sink_valid valid Input 1
   dsp_add_interface_port sink sink_ready ready Output 1
   dsp_add_interface_port sink sink_error error Input 2
   dsp_add_interface_port sink sink_sop startofpacket Input 1
   dsp_add_interface_port sink sink_eop endofpacket Input 1
   dsp_add_interface_port sink sink_data data Input $sink_data_width $sink_data_fragment_list 

   dsp_add_streaming_interface source source
   dsp_set_interface_property source associatedClock clk
   dsp_set_interface_property source dataBitsPerSymbol $source_data_width
   dsp_add_interface_port source source_valid valid Output 1
   dsp_add_interface_port source source_ready ready Input 1
   dsp_add_interface_port source source_error error Output 2
   dsp_add_interface_port source source_sop startofpacket Output 1
   dsp_add_interface_port source source_eop endofpacket Output 1
   dsp_add_interface_port source source_data data Output $source_data_width $source_data_fragment_list 

   FFTCycleCalculator
}


proc generate_synth {entity} {
   generate_all QUARTUS_SYNTH $entity
}
proc generate_sim_verilog {entity} {
   generate_all SIM_VERILOG $entity
}
proc generate_sim_vhdl {entity} {
   generate_all SIM_VHDL $entity
}
proc generate_all {fileset entity} {
   array set output [get_rom_files $entity]
   if {$output(status) != "success"} {
      send_message error $output(message)
   } else {
      foreach rom_name [array names output] {
         if { $rom_name ne {status} } {
            add_fileset_file $rom_name HEX TEXT $output($rom_name) 
            send_message INFO "--- add file: $rom_name"
         }
      }
      foreach current_file [get_common_files] {
         dsp_add_fileset_file $current_file $fileset [get_simulator_list]
      }
      set filename ${entity}.sv
      set template_path "src/rtl/top.sv.terp"
      set top_level_contents [render_terp $entity $template_path ]
      add_fileset_file $filename SYSTEM_VERILOG TEXT $top_level_contents

      # generate the c model files for simulation fileset
      if {$fileset != "QUARTUS_SYNTH"} {
         foreach c_file [get_c_model_files] {
            add_fileset_file $c_file OTHER PATH $c_file
         }
      }
   }
}

proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}



proc get_rom_files { entity } {
   set params(name) $entity
   set params(length) [get_parameter_value length]
   set params(twid_width) [get_parameter_value twid_width_derived]

   if { [is_variable_streaming] } {
      if { [is_fixed_point] } {
         set params(kind) vsfixed
      } else {
         if {[get_dsp_arch] == 3} {
            set params(kind) vsfloat_hdfp
         } else {
            set params(kind) vsfloat
         }
      }
   } else {
         set params(kind) old_arch
         set params(nume) [get_parameter_value num_engines_derived]
   } 

   array set output [call_helper get_twiddle_roms [array get params]]
   if {! [info exists output(status)]} {
      send_message error "generate call_helper returned unexpected output"
   }

   return [array get output] 
}

proc get_common_files {} {
      set files {
         "../lib/packages/auk_dspip_text_pkg.vhd"
         "../lib/packages/auk_dspip_math_pkg.vhd"
         "../lib/packages/auk_dspip_lib_pkg.vhd"
         "./src/rtl/lib/common/avalon_streaming/auk_dspip_avalon_streaming_block_sink.vhd"
         "./src/rtl/lib/common/avalon_streaming/auk_dspip_avalon_streaming_block_source.vhd"
         "../lib/fu/roundsat/rtl/auk_dspip_roundsat.vhd"
      }

      if { [is_variable_streaming] } {
         if { [is_fixed_point] || [get_dsp_arch] == 3} {
            # if variable streaming and fixed point/hard floating point, use r22 architecture
            lappend files src/rtl/lib/old_arch/apn_fft_mult_can.vhd
            lappend files src/rtl/lib/old_arch/apn_fft_mult_cpx_1825.v
            lappend files src/rtl/lib/old_arch/apn_fft_mult_cpx.vhd
            lappend files src/rtl/ocp/auk_dspip_r22sdf_top.ocp
            if { [is_hyper_opt] } {
               lappend files src/rtl/lib/common/hyper_opt_pkg/hyper_opt_ON_pkg.vhd
            } else {
               lappend files src/rtl/lib/common/hyper_opt_pkg/hyper_opt_OFF_pkg.vhd
            }
            set directories [list src/rtl/lib/common src/rtl/lib/r22sdf/pkg src/rtl/lib/r22sdf]
         } else {
            lappend files "./src/rtl/lib/common/avalon_streaming/auk_dspip_avalon_streaming_block_sink_fftfprvs.vhd"
            lappend files src/rtl/ocp/apn_fftfp_top.ocp
            lappend files src/rtl/ocp/apn_fftfpbdr_top.ocp
            lappend files src/rtl/ocp/apn_fftfprvs_top.ocp
            set directories [list src/rtl/lib/common src/rtl/lib/mr42]
         }
      } else {
            lappend files "../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_sink.vhd"
            lappend files "../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_source.vhd"
            lappend files "../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_controller.vhd"
            lappend files src/rtl/ocp/asj_fft_sglstream.ocp
            lappend files src/rtl/ocp/asj_fft_dualstream.ocp
            lappend files src/rtl/ocp/asj_fft_si_de_so_b.ocp
            lappend files src/rtl/ocp/asj_fft_si_de_so_bb.ocp
            lappend files src/rtl/ocp/asj_fft_si_qe_so_b.ocp
            lappend files src/rtl/ocp/asj_fft_si_qe_so_bb.ocp
            lappend files src/rtl/ocp/asj_fft_si_se_so_b.ocp
            lappend files src/rtl/ocp/asj_fft_si_se_so_bb.ocp
            lappend files src/rtl/ocp/asj_fft_si_so_se_so_b.ocp
            lappend files src/rtl/ocp/asj_fft_si_sose_so_b.ocp

            set directories [list src/rtl/lib/common src/rtl/lib/old_arch/pkg src/rtl/lib/old_arch]
      }
      foreach dir $directories {
         set lib_files [glob -tails -directory $dir *.vhd]
         foreach lib_file $lib_files {
               lappend files "$dir/$lib_file"
         } 
         set lib_files [glob -nocomplain -tails -directory $dir *.v]
         foreach lib_file $lib_files {
               lappend files "$dir/$lib_file"
         } 
         set lib_files [glob -nocomplain -tails -directory $dir *.sv]
         foreach lib_file $lib_files {
               lappend files "$dir/$lib_file"
         } 
      }
      return $files
}

proc render_terp {output_name template_path} {
    
   set template_fd [open $template_path]
   set template [read $template_fd]
   close $template_fd
   

   foreach param [lsort [get_parameters]] {
      set params($param) [get_parameter_value $param]
   }
   set params(module_name) [get_module_name] 
   set params(output_name) $output_name
   set params(device_family) [get_parameter_value selected_device_family] 
   set params(max_fftpts) [get_parameter_value length] 
   set params(in_width) [get_parameter_value in_width_derived] 
   set params(out_width) [get_parameter_value out_width_derived] 
   set params(twid_width) [get_parameter_value twid_width_derived] 
   set params(length_msb) [get_length_msb]  
   set params(dsp_arch) [get_dsp_arch]
   set params(has_inverse) [get_has_inverse_port]
   set params(is_variable_streaming) [is_variable_streaming]
   set params(arch)  [get_parameter_value data_flow]
   set params(is_fixed_point) [is_fixed_point] 
   if { $params(is_variable_streaming) } {
      set params(num_stages) [get_num_stages] 
      set params(prune) [get_prune_str]
      set params(max_grow) [get_growth] 
      set params(representation) [get_hdl_rep_str]
      set params(in_order) [get_hdl_io_order_str [get_parameter_value in_order]]
      set params(out_order) [get_hdl_io_order_str [get_parameter_value out_order]]
   } else {
      set params(nume) [get_parameter_value num_engines_derived]
      set params(throughput) [expr {[get_parameter_value engine_arch] eq "Quad Output" ? 4 : 1}]
      if { [get_parameter_value num_engines_derived] == 4 } { 
         array set last_twids [get_quad_engine_last_pass_twiddle]
         set params(x1) $last_twids(x1)
         set params(x2) $last_twids(x2)
      }
   }
  
  set contents [altera_terp $template params]
  
  return $contents
}


proc is_variable_streaming {} {
   set arch [get_parameter_value data_flow]
   return [expr {$arch eq {Variable Streaming}}]
}
proc is_burst {} {
   set arch [get_parameter_value data_flow]
   return [expr {$arch eq {Burst}}]
}
proc is_streaming {} {
   set arch [get_parameter_value data_flow]
   return [expr {$arch eq {Streaming}}]
}
proc is_buffered_burst {} {
   set arch [get_parameter_value data_flow]
   return [expr {$arch eq {Buffered Burst}}]
}

proc is_fixed_point {} {
   set data_format [get_parameter_value data_rep]
   return [expr {$data_format eq {Fixed Point}}]
}

proc is_single_floating_point {} {
   set data_format [get_parameter_value data_rep]
   return [expr {$data_format eq {Single Floating Point}}]
}

proc is_block_floating_point {} {
   set data_format [get_parameter_value data_rep]
   return [expr {$data_format eq {Block Floating Point}}]
}

proc is_floating_variable_streaming {} {
   return [expr {[is_variable_streaming] && [is_single_floating_point]}] 
}

proc is_bidirectional {} {
   set direction [get_parameter_value direction]
   # the bidirectional only matters when (single floating point) (variable streaming) architecture and (not using hard floating point blocks)
   if { [is_floating_variable_streaming] && [get_dsp_arch] ne 3 } {
      return [expr {$direction eq {Bi-directional}}]
   } else {
      return 1
   }
}

proc get_growth {} {
   if { [is_variable_streaming] } {
      if { [is_fixed_point] } {
         return [expr {[get_parameter_value out_width] - [get_parameter_value in_width]}]
      } else {
         return 0
      }
   } else {
      send_message ERROR "get_growth calld for invalid architecture"
   }
}

proc get_max_growth {} {
   if { [is_variable_streaming] } {
      if { [is_fixed_point] } {
         set len [get_parameter_value length]
         return expr {int( ceil( [log2 $len] + 1 ) )}
      }
   } else {
      send_message ERROR "get_growth calld for invalid architecture"
   }
}

proc get_num_stages {} {
   if { [is_variable_streaming] } {
      return [expr {int(ceil( [log4 [get_parameter_value length]]))}]
   } else {
      send_message ERROR "get_num_stages calld for invalid architecture"
   }
}

proc log2 { num } {
   return [expr {log($num)/log(2)}]
}

proc log4 { num } {
   return [expr {log($num)/log(4)}]
}

proc get_hdl_io_order_str { gui_string } {
   if { [get_dsp_arch] ne 3 && [is_floating_variable_streaming]} {
      # the old floating point architecture uses "DIGIT_REVERSED" keyword
      switch -exact $gui_string {
         Natural { return NATURAL_ORDER }
         "Digit Reverse" { return DIGIT_REVERSED }
         default { send_message ERROR "$gui_string is an invalid IO order"}  
      }
   } else {
      # the R22 architecture uses "BIT_REVERSED" keyword
      switch -exact $gui_string {
         Natural { return NATURAL_ORDER }
         "Digit Reverse" { return BIT_REVERSED }
         default { send_message ERROR "$gui_string is an invalid IO order"}  
      }
   }
   
}

proc get_hdl_rep_str {} {
   set gui_string [get_parameter_value data_rep]
   switch -exact $gui_string {
      "Fixed Point" { return FIXEDPT }
      "Single Floating Point" { return FLOATPT }
      default { send_message ERROR "$gui_string is an invalid representation"}
   }
}

proc is_hyper_opt {} {
   set hyper_opt [get_parameter_value hyper_opt]
   set family [get_parameter_value selected_device_family]
   if {($family eq "Arria 10") || ($family eq "Stratix 10") && [is_variable_streaming]} {
      return $hyper_opt
   } else {
      return false
   }
}

proc get_dsp_arch {} {
   set dsp_opt [get_parameter_value dsp_resource_opt]
   set family [get_parameter_value selected_device_family]
   set hard_fp [get_parameter_value hard_fp]
   if { (($family eq "Arria 10") || ($family eq "Stratix 10"))  && [is_single_floating_point] } {
      if { $hard_fp } {
         set dsp_arch 3 
      } else {
         set dsp_arch [expr {[is_single_floating_point] && !$dsp_opt ? 0 : 2}]
      }
   } elseif { $family eq "Stratix V"} {
      set dsp_arch [expr {$dsp_opt ? 1 : 0}]
   } elseif {$family eq "Arria V GZ" && ![is_fixed_point]} {
      set dsp_arch [expr {$dsp_opt ? 1 : 0}]
   } elseif { $family eq "Arria V" || $family eq "Cyclone V" } {
      set dsp_arch [expr {[is_single_floating_point] && !$dsp_opt ? 0 : 2}]
   } else {
      set dsp_arch 0
   }
   return $dsp_arch 
}

proc get_prune_str {} {
   set params(length) [get_parameter_value length]
   set params(out_width) [get_parameter_value out_width_derived]
   set params(in_width) [get_parameter_value in_width_derived]
   set params(num_stages) [get_num_stages]
   set params(bit_reversed_input) [expr { [get_parameter_value in_order] eq "Digit Reverse" ? true : false} ]
   return [call_helper get_prune_str [array get params]] 
}

proc get_quad_engine_last_pass_twiddle {} {
   set params(twid_width) [get_parameter_value twid_width_derived]
   return [call_helper get_quad_engine_last_pass_twiddle [array get params]]
}

proc get_length_msb {} {
   set length [get_parameter_value length] 
   return [expr int(log($length)/log(2))]
}

proc get_module_name {} {
   if { [is_variable_streaming] } {
      if { [is_fixed_point] || [get_dsp_arch] == 3 } {
         return auk_dspip_r22sdf_top
      } else {
         set direction [get_parameter_value direction]
         switch $direction {
            Forward { return apn_fftfp_top }
            Reverse { return apn_fftfprvs_top }
            Bi-directional { return apn_fftfpbdr_top }
         }
      }
   } else {
      set arch [get_parameter_value data_flow]
      set num_engines [get_parameter_value num_engines_derived]
      set engine_arch [get_parameter_value engine_arch]
      switch  $arch {
         Streaming { 
            if { $num_engines == 1 } { 
               return asj_fft_sglstream
            } elseif { $num_engines == 2 } {
               return asj_fft_dualstream
            } else {
               send_message DEBUG "Unexpected num_engines_derived value of $num_engines for $arch"
            }
         }
         Burst { 
            if { $engine_arch eq "Single Output" } {
               return asj_fft_si_sose_so_b 
            } elseif { $num_engines == 1 } {
               return asj_fft_si_se_so_b
            } elseif { $num_engines == 2 } { 
               return asj_fft_si_de_so_b
            } elseif { $num_engines == 4 } {
               return asj_fft_si_qe_so_b
            }
         }
         {Buffered Burst} {
            if { $num_engines == 1 } {
               return asj_fft_si_se_so_bb
            } elseif { $num_engines == 2 } { 
               return asj_fft_si_de_so_bb
            } elseif { $num_engines == 4 } {
               return asj_fft_si_qe_so_bb
            }
         }
      }
   } 
}

proc get_has_inverse_port {} {
   if { [is_variable_streaming] } {
      if { [is_bidirectional] } {
         return 1
      } else {
         return 0
      }
   } else {
      return 1
   }
}


proc filetype { file_name } {
   switch -glob $file_name {
      *.vhd {     return VHDL}
      *.v {       return VERILOG}
      *.sv {      return SYSTEM_VERILOG}
      *.svo {     return SYSTEM_VERILOG}
      *.vho {     return VHDL}
      *.vo {      return VERILOG}
      default {   return OTHER }
   }
}

proc folder_worker { item } {
   foreach top_item [glob -directory [file join [pwd] $item] -tails *] {
      set relative_item [file join $item $top_item]
      set absolute_path [file join [pwd] $relative_item]
      if {[file isdirectory $relative_item] == 1 } {
         folder_worker $relative_item 
      } else {
         add_fileset_file [file join "simulation_scripts" $relative_item] OTHER PATH $absolute_path
      }
   }
}
proc add_files_recursive { root } {
   set old_path [pwd] 
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      if {[file isdirectory $top_item] == 1 } {
         folder_worker $top_item
      } else {
         add_fileset_file [file join "simulation_scripts" $top_item] OTHER PATH $absolute_path
      }
   }
   cd $old_path
}

proc get_all_file_abs {root_dir} {
    set cur_dir [pwd]
    cd $root_dir
    set all_files {}
    foreach item [glob -nocomplain -type d * ] {
        lappend all_files {*}[get_all_file_abs $item ]
    } 
    foreach item [glob -nocomplain  -type f * ] {
        lappend all_files $item
    } 
    cd $cur_dir
    return $all_files
}


#Example Fileset Generates: (in order)
#                             Matlab functions for modelling the FIR
#                             A SystemVerilog Test program
#                             Test stimuli
#                             A parameterized FIR simulation model
#                             SystemVerilog Bus Functional models to drive the simulation
#                             Simulation scripts for the simulators using ip-make-simscript
proc example_fileset {output_name} {

   set cwd [pwd]

   send_message INFO "Creating MATLAB Models"
   set matlab_dir "Matlab_model"
   #Generate MATLAB Scripts
   set template_path "src/matlab/matlab_tb.template"
   set terp_contents [render_terp $output_name $template_path ]
   set filename "${output_name}_tb.m" 
   add_fileset_file "${matlab_dir}/$filename" OTHER TEXT $terp_contents

   set template_path "src/matlab/matlab_model.template"
   set terp_contents [render_terp $output_name $template_path ]
   set filename "${output_name}_model.m" 
   add_fileset_file "${matlab_dir}/$filename" OTHER TEXT $terp_contents

   foreach filename [get_matlab_model_files] {
       add_fileset_file "${matlab_dir}/$filename" OTHER PATH "src/matlab/lib/$filename"
   }


   send_message INFO "Generating Test Program"

   #Generate Test Program
   set source_files_path src
   set template_path "src/testbench/fft_testbench.sv.terp"
   set terp_contents [render_terp $output_name $template_path ]
   set test_program_file "${output_name}_test_program.sv" 
   add_fileset_file "[file join $source_files_path $test_program_file]" [filetype $test_program_file] TEXT $terp_contents
   send_message INFO "Generating Test Data"

   #Generate Test Data
   set direction        [get_parameter_value direction]
   set arch             [get_parameter_value data_flow]
   set input_format     [get_parameter_value data_rep]
   set fft_size         [get_parameter_value length] 
   set input_width      [get_parameter_value in_width_derived] 
   set test_data_dir [create_temp_file ""]
   generate_test_data $test_data_dir $output_name $direction $arch $input_format $fft_size $input_width


   send_message INFO "Generating Testbench System"

   #Generate Testbenching System
   set family "[get_parameter_value selected_device_family]"
   set fft_example_name "core" 
   set qsys_system "${output_name}.qsys"



   #Generate the testbench files
   set source_files [get_common_files]
   set temp_dir  [create_temp_file ""]
   file mkdir $temp_dir
   cd $temp_dir

   set script_name "$temp_dir/${output_name}.tcl"
   set sim_script_name "$temp_dir/${output_name}_tmp.spd"
   set sim_script [open $sim_script_name w+]


   set f_handle [open $script_name w+]

   puts $f_handle    "package require -exact qsys 14.0"
   puts $f_handle    "set_project_property DEVICE_FAMILY \"${family}\""
   puts $f_handle    "add_instance ${fft_example_name} altera_fft_ii"
   foreach param [lsort [get_parameters]] {
      if {[get_parameter_property $param DERIVED] == 0} {
         #Screen for design environment, only QSYS flow is supported, because Native steps all over the BFMs by creating conduits
         if { $param ne "design_env" } { 
            puts $f_handle "set_instance_parameter_value $fft_example_name $param \"[get_parameter_value $param]\""
         } else {
            puts $f_handle "set_instance_parameter_value $fft_example_name $param \"QSYS\""

         }
      }
   }
   puts $f_handle    "add_interface ${fft_example_name}_rst reset sink"
   puts $f_handle    "set_interface_property ${fft_example_name}_rst EXPORT_OF ${fft_example_name}.rst"
   puts $f_handle    "add_interface ${fft_example_name}_clk clock sink"
   puts $f_handle    "set_interface_property ${fft_example_name}_clk EXPORT_OF ${fft_example_name}.clk"
   puts $f_handle    "add_interface ${fft_example_name}_sink avalon_sink sink"
   puts $f_handle    "set_interface_property ${fft_example_name}_sink EXPORT_OF ${fft_example_name}.sink"
   puts $f_handle    "add_interface ${fft_example_name}_source avalon_source source"
   puts $f_handle    "set_interface_property ${fft_example_name}_source EXPORT_OF ${fft_example_name}.source"
   puts $f_handle    "save_system ${qsys_system}"

   close $f_handle
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-script"] 


   set cmd [list  $program --script=$script_name ]
   #send_message INFO "$cmd"
   set status [catch {exec {*}$cmd} err]


   #now use this qsys SYSTEM to generate files and find out the correct compile order of these files
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-generate"] 
   set cmd "$program $qsys_system --testbench=STANDARD --testbench-simulation=VERILOG";
   set status [catch {exec {*}$cmd} err]

   # The report varies based on whether its the new fileset or old.
   set filename "$temp_dir/${output_name}/${output_name}_generation.rpt"
   if { [file exists $filename ] == 0 } {
      set filename "$temp_dir/${output_name}_tb/${output_name}_generation.rpt"
   } 
   set pattern {ERROR:.*}
   set count 0

   set fid [open $filename r]
   while {[gets $fid line] != -1} {
       incr count [regexp -all -- $pattern $line]
   }
   close $fid



   if {$count > 0} {
        send_message ERROR [get_string EXAMPLE_DESIGN_TB_ERROR]
   } else {
        send_message NOTE "FFT Example Testbench Generation Complete"
   }        


   set simulator_list { \
             {mentor   modelsim} \
             {aldec    riviera} \
             {synopsys vcs} \
             {cadence  ncsim} \
           }

   set test_file_dir [file join "${temp_dir}"]
   send_message INFO "--- Looking in $test_file_dir ---"

   # add c_model files to the example design first
   set c_model_location [find_c_model_dir ${test_file_dir}]
   foreach c_file [get_c_model_files] {
      add_fileset_file $c_file OTHER PATH "${c_model_location}/../${c_file}"
   }

   # add all the RTL files etc.
   set all_files [get_all_file_abs $test_file_dir]
   foreach module [lsearch -inline -all -glob $all_files *] {
        if { [regexp  {.*(\.hex$)|(\.mif$)|(\.vo$)|(\.vho$)} [file tail $module] ] == 1 } {
            set ext [filetype submodule]
            add_fileset_file [file join "src" [file tail $module]] $ext PATH $module
        }
        if { [regexp  {.*(\.sv$)|(\.vhd$)|(\.v$)} [file tail $module] ] == 1 } {
            switch -glob $module {
               *.vhd    { set language VHDL}
               *.sv     { set language SYSTEM_VERILOG}
               *.v      { set language VERILOG}
            }

            set added 0
            foreach simulator $simulator_list {
                set sim [lindex $simulator 0]
                # if it has encryption it will be located in the simulator sub-directory
                if {[string match *$sim*  $module ] == 1} {
                    add_fileset_file [file join "src/$sim" [file tail $module]] ${language}_ENCRYPT PATH $module [string toupper $sim]_SPECIFIC
                    set added 1
                    break
                }
            }
            if {!$added} {
                add_fileset_file [file join "src" [file tail $module]] $language PATH $module
            }
        }
   }

   set packages {}
   set top_files {}
   set generic_files {}
   set memory_files {}

   foreach cur_file $all_files {
       if { [regexp  {.*(tb\.)(v|(sv)|(vhd))} $cur_file ] == 1 } {
           lappend top_files $cur_file
       } elseif { [regexp  {.*((\.vo)|(\.vho)|(pack\.vhd)|(pkg\.v)|(pkg\.sv)|(pkg\.vhd))} $cur_file] == 1 } {
           lappend packages $cur_file
       } elseif { [regexp  {.*\.(v|(sv)|(vhd))} $cur_file] == 1 } {
           lappend generic_files $cur_file
       } elseif { [regexp  {.*\.((hex)|(mif))}  $cur_file] == 1 } {
           lappend memory_files $cur_file
       }
   }
   # use the source file list as the priority list, determines which file to add/compile first
   set rtl_files [concat $packages $generic_files]
   set rtl_files_temp [concat $packages $generic_files]
   set priority_files $source_files
   set priority_file_list [list ]
   foreach priority_file $priority_files {
       foreach current_file $rtl_files_temp {
           if {[file tail $current_file] eq [file tail $priority_file]} {
               # add the file to the priority list
               lappend priority_file_list $current_file
               set pos [lsearch $rtl_files $current_file]
               # remove the file to the generic_files
               set rtl_files [lreplace $rtl_files $pos $pos]
           }
       }
   }
   set rtl_files [concat $priority_file_list $rtl_files]


   send_message INFO "Generating Simulation Scripts"

   #set the spd
   puts $sim_script "<simPackage>"
   set library "work"
   foreach file $rtl_files {
      if { [lsearch $all_files $file] != -1 } {
         # remove the current element from the list
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         if { [string match -nocase SYSTEM_VERILOG $file_type]==1 || [string match -nocase VHDL $file_type]==1 || [string match -nocase VERILOG $file_type]==1} { 
            set added 0
            foreach simulator $simulator_list {
                set sim [lindex $simulator 0]
                set tool [lindex $simulator 1]
                if {[string match *$sim*  $file ] == 1} {
                    set file_name [file join $source_files_path $sim [file tail $file]]
                    puts $sim_script [convert_to_spd_xml  $file_name ${file_type}_ENCRYPT $library $tool]
                    set added 1
                    break
                } 
            }
            if {!$added} {
                set file_name [file join $source_files_path [file tail $file]]
                puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]
            }
         } else { 
             set file_name [file join $source_files_path [file tail $file]]
             puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]
         }
      }
   }
   foreach file $memory_files {
      if { [lsearch $all_files $file] != -1 } {
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         set file_name [file join $source_files_path [file tail $file]]
         puts $sim_script [convert_to_spd_xml  $file_name "Memory" $library]
      }
   }
   foreach file $top_files {
      set file_type [filetype $file]
      set file_name [file join $source_files_path [file tail $file]]
      puts $sim_script [convert_to_spd_xml  $file_name $file_type $library]
   }

   #Add the top level 
   set file_name [file join $source_files_path $test_program_file]
   set file_type [filetype $file_name]
   puts $sim_script [convert_to_spd_xml  $file_name $file_type $library]


   #add input files
   set input_files [glob -directory $test_data_dir  -tails *{.txt}]
   foreach file $input_files {
      set file_type "Memory"
      set file_name [file tail $file]
      puts $sim_script [convert_to_spd_xml  [file join "test_data" $file_name] $file_type 0]
   }
   puts $sim_script "<topLevel name=\"test_program\"/>"
   puts $sim_script "<deviceFamily name=\"[get_parameter_value selected_device_family]\"/>"
   puts $sim_script "</simPackage>"
   close $sim_script

   file mkdir "sim_scripts"
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "ip-make-simscript"] 
   set cmd [list  $program --spd=$sim_script_name --use-relativepaths --output_directory=[file join [pwd] "sim_scripts"]]
   send_message INFO "$cmd"
   set status [catch {exec {*}$cmd} err]
   send_message INFO "$err"
   set root     [file join [pwd] "sim_scripts" ] 
   add_files_recursive $root

   

   cd $cwd
}

proc float2hex {val} {
   # get IEEE floating point format in big endian order, then convert to hex
   binary scan [binary format R $val] H* hex
   return $hex
}

proc generate_test_data {test_data_dir output_name direction arch input_format fft_size input_width} {
   set cwd [pwd]
   #set temp_dir "/tmp"
   #cd $temp_dir
   file mkdir $test_data_dir
   cd $test_data_dir

   lappend fft_size_out $fft_size

   #sort out the fft size first
   if { [string first "Variable Streaming" $arch] ne -1 } {
      lappend fft_size_out [expr max(8, $fft_size/2)]
      lappend fft_size_out [expr max(8, $fft_size/4)]
      lappend fft_size_out [expr max(8, $fft_size/8)]

      set f_name "${output_name}_blksize_report.txt"
      set f_handle [open $f_name w+]
      foreach fft_val $fft_size_out {
         puts $f_handle    $fft_val
      }
      close $f_handle
      add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"

   } else {
      lappend fft_size_out $fft_size
      lappend fft_size_out $fft_size      
   }

   #Then sort the FFT direction
   set forward 0 
   set backward 1
   if { $direction  eq "Bi-directional" } {
      set direction_list [list $forward $backward $forward $backward]
   } elseif { $direction eq "Forward" } {
      set direction_list [list $forward $forward $forward $forward]
   } else {
      set direction_list [list $backward $backward $backward $backward]
   }

   set f_name "${output_name}_inverse_report.txt"
   set f_handle [open $f_name w+]
   foreach dir_val $direction_list {
      puts $f_handle    $dir_val
   }
   close $f_handle
   add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"

   set pi 3.1415926535897931
   set frequency 4
   foreach cur_dir $direction_list cur_size $fft_size_out {
      if {$cur_dir == $forward } { 
         for {set j 0} {$j < $cur_size} {incr j} {
            lappend real [expr cos(( 2 * $pi * $j * $frequency)/$cur_size ) ]
            lappend imag 0
         }
      } else {
         for {set j 0} {$j < $cur_size} {incr j} {
            if { $j == 0 } {
               lappend real 1
               lappend imag 1
            } else {
               lappend real 0
               lappend imag 0
            }
         }
      }
   }
   set f_i_name "${output_name}_imag_input.txt"
   set f_r_name "${output_name}_real_input.txt"
   set f_i_handle [open $f_i_name w+]
   set f_r_handle [open $f_r_name w+]


   if { $input_format eq "Single Floating Point"} {
      foreach i_val $imag r_val $real {
         puts $f_i_handle [float2hex $i_val]
         puts $f_r_handle [float2hex $r_val]
      }
   } else {
      # the valid range is from -(2 ** ($input_width-1)) to 2 ** ($input_width-1) - 1
      # since we want to represent 1 and stay within range scale by 2 ** ($input_width-1) - 1 
      set scale_factor [expr {2 ** ($input_width - 1) - 1}]
      foreach i_val $imag r_val $real {
         puts $f_i_handle [expr {round($i_val * $scale_factor)}]
         puts $f_r_handle [expr {round($r_val * $scale_factor)}]
      }
   }

   close $f_i_handle
   close $f_r_handle


   add_fileset_file [file join "test_data" $f_i_name] OTHER PATH "[file join $test_data_dir $f_i_name]"
   add_fileset_file [file join "test_data" $f_r_name] OTHER PATH "[file join $test_data_dir $f_r_name]"


   cd $cwd
}


proc NeedBitReverseCore {} {
   set input_order [get_parameter_value in_order]
   set output_order [get_parameter_value out_order]

   if { ($input_order eq "Digit Reverse" && $output_order eq "Natural"  )
   || ($input_order eq "Natural" && $output_order eq "Digit Reverse"  )  } {
      return 0
   }
   return 1
}

#Translated from old fft/src/software/gui/altera/ipbu/flowbase/netlist/model/FFTModelClass.java
#Back by popular demand
proc FFTCycleCalculator {} {
   set calc_cycles 0
   set throughput_cycles 0 
   set arch [get_parameter_value data_flow]
   set length [get_parameter_value length]
   set num_passes [expr ceil(log($length)/log(4))]
   set engines [get_parameter_value num_engines_derived]
   if { [is_variable_streaming] } {
      if { [NeedBitReverseCore] == 1 } {
         set calc_cycles [expr 2*$length] 
      } else {
         set calc_cycles [expr $length] 
      }
      set throughput_cycles $length
   }
   if { [is_buffered_burst]} {
      switch $length {
         64 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+20))+17]
            set throughput_cycles [expr $length + ($length/(4*$engines)) + 11 ]
         }
         128 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+17))+13]
            set throughput_cycles [expr $length + ($length/(4*$engines)) + 11 ]
         }
         256 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+17))+15]
            set throughput_cycles [expr $length + ($length/(4*$engines)) + 11 ]
         }
         512 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+17))+9]
            set throughput_cycles [expr $length + ($length/(4*$engines)) + 11 ]
         }
         1024 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+17))+11]
            set throughput_cycles [expr $length + ($length/(4*$engines)) + 11 ]
         }
         2048 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+15))+15]
            if { $engines == 1 } {
                  set throughput_cycles [expr $length + 2*($length/4) + 24]
               } else {
                  set throughput_cycles [expr $length + ($length/(4*$engines)) ]
               }
         }
         4096 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+15))+17]
            if { $engines == 1 } {
                  set throughput_cycles [expr $length + 2*($length/(4*$engines)) + 24]
               } else {
                  set throughput_cycles [expr $length + ($length/(4*$engines)) ]
               }
         }
         8192 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+15))+13]
            if { $engines == 1 } {
                  set throughput_cycles [expr $length + 3*($length/4) + 37]
               } else {
                  set throughput_cycles [expr $length + ($length/(4*$engines)) ]
               }
         }
         16384 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+15))+15]
            if { $engines == 1 } {
                  set throughput_cycles [expr $length + 3*($length/4) + 37]
               } else {
                  set throughput_cycles [expr $length + ($length/(4*$engines)) ]
               }
         }
         32768 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+15))+19]
            if { $engines == 1 } {
                  set throughput_cycles [expr 2*$length + 50]
               } else {
                  set throughput_cycles [expr $length + ($length/(4*$engines)) ]
               }
         }
         65536 {
            set calc_cycles [expr (($num_passes-1)*(($length/(4*$engines))+15))+21]
            if { $engines == 1 } {
                  set throughput_cycles [expr 2*$length + 50]
               } else {
                  set throughput_cycles [expr $length + ($length/(4*$engines)) ]
               }
         }
      }


   }
   if { [is_burst] } {
      set calc_cycles [expr ($num_passes-1)*floor(($length/(4*$engines)) + 19) + 13]
      set throughput_cycles [expr $calc_cycles+ 1 + 2*$length]
   }
   if { [is_streaming]} {
      set calc_cycles $length
      set throughput_cycles $length
   }
   set_parameter_value CALC_LATENCY $throughput_cycles
   set_parameter_value THROUGHPUT_LATENCY $calc_cycles

}

proc find_c_model_dir { cur_dir } {
   #send_message WARNING "searching $cur_dir"
   set found_dir "nothing"
   foreach sub_dir [glob -nocomplain -type d -directory $cur_dir *] {
      #send_message WARNING "found $sub_dir"
      if {[string match *c_model*  $sub_dir ] == 1} {
         set found_dir $sub_dir
         #send_message WARNING "!! found c_model"
         return $found_dir
      } else {
         set found_dir [find_c_model_dir $sub_dir]
      }
      if {[string match *c_model*  $found_dir ] == 1} {
         return $found_dir
      }
   }
   return $found_dir
}

proc get_c_model_files {} {
   set c_model_files {
        c_model/mr42/How_To_Build.txt
	c_model/mr42/SVSfftmodel.mexglx
	c_model/mr42/SVSfftmodel.mexw32
	c_model/mr42/expression.cpp
	c_model/mr42/expression.h
	c_model/mr42/fft.cpp
	c_model/mr42/fft.h
	c_model/mr42/fpCompiler.cpp
	c_model/mr42/fpCompiler.h
	c_model/mr42/model_c_wrapper.cpp
	c_model/mr42/util.cpp
	c_model/mr42/util.h
	c_model/old_arch/Sfftmodel.c
	c_model/old_arch/Sfftmodel.mexa64
	c_model/old_arch/Sfftmodel.mexglx
	c_model/old_arch/Sfftmodel.mexw32
	c_model/old_arch/imag_input.txt
	c_model/old_arch/model.c
	c_model/old_arch/model_c_wrapper.c
	c_model/old_arch/real_input.txt
	c_model/old_arch/run_c_wrapper.sh
	c_model/old_arch/run_model_c.sh
	c_model/old_arch/tbcmex.m
	c_model/r22sdf/SVSfftmodel.mexa64
	c_model/r22sdf/SVSfftmodel.mexglx
	c_model/r22sdf/SVSfftmodel.mexw32
	c_model/r22sdf/blksize_report.txt
	c_model/r22sdf/create_static_library.sh
	c_model/r22sdf/expected_imag_out.txt
	c_model/r22sdf/expected_real_out.txt
	c_model/r22sdf/expression.cpp
	c_model/r22sdf/expression.h
	c_model/r22sdf/fft.cpp
	c_model/r22sdf/fft.h
	c_model/r22sdf/fft_model.m
	c_model/r22sdf/fft_tb.m
	c_model/r22sdf/fpCompiler.cpp
	c_model/r22sdf/fpCompiler.h
	c_model/r22sdf/how_to_compile.txt
	c_model/r22sdf/imag_input.txt
	c_model/r22sdf/main.cpp
	c_model/r22sdf/model.cpp
	c_model/r22sdf/model_c_wrapper.cpp
	c_model/r22sdf/readme.txt
	c_model/r22sdf/real_input.txt
	c_model/r22sdf/sink.cpp
	c_model/r22sdf/sink.h
	c_model/r22sdf/source.cpp
	c_model/r22sdf/source.h
	c_model/r22sdf/system.cpp
	c_model/r22sdf/system.h
	c_model/r22sdf/util.cpp
	c_model/r22sdf/util.h
   }
   return $c_model_files
}

proc get_matlab_model_files {} {
   set matlab_model_files {
       Sfftmodel.mexa64
       Sfftmodel.mexglx
       Sfftmodel.mexw32
       Sfftmodel.mexw64
       SVSfftmodel.mexa64
       SVSfftmodel.mexw64
   }
   return $matlab_model_files
}


