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


# (C) 2001-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


package require -exact qsys 14.0
package require altera_terp

#source "src/tcl_libs/altera_turbo_helper.tcl"
source "../../lib/tcl/avalon_streaming_util.tcl"
source "../../lib/tcl/dspip_common.tcl"
load_strings altera_turbo.properties

# |
# +-----------------------------------

# +-----------------------------------
# | module altera_turbo
# |
set_module_property NAME altera_turbo
set_module_property AUTHOR [get_string AUTHOR]
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP [get_string GROUP]
set_module_property DISPLAY_NAME [get_string DISPLAY_NAME]
set_module_property DESCRIPTION [get_string DESCRIPTION]

set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QSYS false
set_module_property EDITABLE false
#set_module_property HELPER_JAR turbo_helper.jar
set_module_property ELABORATION_CALLBACK elaboration_callback
set_module_property VALIDATION_CALLBACK validation_turbo_top
set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V} {STRATIX 10}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10}
    {CYCLONE IV GX} {CYCLONE IV E} {CYCLONE V} {CYCLONE 10 LP}
    {MAX 10 FPGA}
}

add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_verilog SIM_VERILOG generate_sim_verilog
add_fileset sim_vhdl SIM_VHDL generate_sim_vhdl
add_fileset example_design EXAMPLE_DESIGN example_fileset "Turbo Example Design"

## Add documentation links for user guide and/or release notes


add_documentation_link "User Guide" https://documentation.altera.com/#/link/dmi1436868893828/dmi1436869917308
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408

###################### Parameters 

proc add_module_parameters_standard_type {} {
    add_parameter TURBO_STANDARD string "LTE"
    set_parameter_property TURBO_STANDARD DISPLAY_NAME [get_string TURBO_STANDARD_DISPLAY_NAME ]
#    set_parameter_property CODEC_TYPE UNITS None
    set_parameter_property TURBO_STANDARD DESCRIPTION [get_string TURBO_STANDARD_DESCRIPTION]
    set_parameter_property TURBO_STANDARD DISPLAY_HINT radio
    set_parameter_property TURBO_STANDARD ALLOWED_RANGES [list "LTE:[get_string LTE_NAME]" "UMTS:[get_string UMTS_NAME]"]
    set_parameter_property TURBO_STANDARD GROUP [get_string TURBO_SPEC_SECTION_NAME]
    set_parameter_property TURBO_STANDARD AFFECTS_GENERATION true
}

proc add_module_parameters_codec_type {} {
    add_parameter CODEC_TYPE string "Decoder"
    set_parameter_property CODEC_TYPE DISPLAY_NAME [get_string CODEC_TYPE_DISPLAY_NAME ]
#    set_parameter_property CODEC_TYPE UNITS None
    set_parameter_property CODEC_TYPE DESCRIPTION [get_string CODEC_TYPE_DESCRIPTION]
    set_parameter_property CODEC_TYPE DISPLAY_HINT radio
    set_parameter_property CODEC_TYPE ALLOWED_RANGES [list "Encoder:[get_string ENCODER_NAME]" "Decoder:[get_string DECODER_NAME]"]
    set_parameter_property CODEC_TYPE GROUP [get_string TURBO_SPEC_SECTION_NAME]
    set_parameter_property CODEC_TYPE AFFECTS_GENERATION true
}

proc add_module_parameters_number_of_processors {} {
    add_parameter ENGINES INTEGER 8
    set_parameter_property ENGINES DISPLAY_NAME [get_string NUM_OF_ENGINES_DISPLAY_NAME ]
    set_parameter_property ENGINES UNITS None
    set_parameter_property ENGINES DESCRIPTION [get_string NUM_OF_ENGINES_DESCRIPTION]
    set_parameter_property ENGINES GROUP [get_string TURBO_DEC_SECTION_NAME]
    set_parameter_property ENGINES AFFECTS_GENERATION true

}

proc add_module_parameters_map_decoding_type {} {
    add_parameter MAP_DEC_TYPE string "MaxLogMAP"
    set_parameter_property MAP_DEC_TYPE DISPLAY_NAME [get_string DECODING_ALGORITHM_DISPLAY_NAME ]
    set_parameter_property MAP_DEC_TYPE UNITS None
#    set_parameter_property MAP_DEC_TYPE ALLOWED_RANGES [list "MaxLogMAP:[get_string MAX_LOG_MAP_NAME]" "LogMAP:[get_string LOG_MAP_NAME]"]
    set_parameter_property MAP_DEC_TYPE ALLOWED_RANGES [list "MaxLogMAP:[get_string MAX_LOG_MAP_NAME]"]
    set_parameter_property MAP_DEC_TYPE DESCRIPTION [get_string DECODING_ALGORITHM_DESCRIPTION]
    set_parameter_property MAP_DEC_TYPE GROUP [get_string TURBO_DEC_SECTION_NAME]
    set_parameter_property MAP_DEC_TYPE AFFECTS_GENERATION true

}

proc add_module_parameters_num_of_dec_input_bits {} {
    add_parameter DEC_LPS INTEGER 1
    set_parameter_property DEC_LPS DISPLAY_NAME [get_string NUM_OF_LLR_DISPLAY_NAME ]
    set_parameter_property DEC_LPS DESCRIPTION [get_string NUM_OF_INPUTS_DESCRIPTION]
    set_parameter_property DEC_LPS GROUP [get_string TURBO_DEC_SECTION_NAME]
    set_parameter_property DEC_LPS AFFECTS_GENERATION true
    
    add_parameter DEC_INPUT_BITS INTEGER 8
    set_parameter_property DEC_INPUT_BITS DISPLAY_NAME [get_string NUM_OF_INPUTS_DISPLAY_NAME ]
    set_parameter_property DEC_INPUT_BITS UNITS None
    set_parameter_property DEC_INPUT_BITS ALLOWED_RANGES {4 5 6 7 8}
    set_parameter_property DEC_INPUT_BITS DESCRIPTION [get_string NUM_OF_INPUTS_DESCRIPTION]
    set_parameter_property DEC_INPUT_BITS GROUP [get_string TURBO_DEC_SECTION_NAME]
    set_parameter_property DEC_INPUT_BITS AFFECTS_GENERATION true
}


proc add_module_parameters_num_of_dec_output_bits {} {
    add_parameter DEC_OUTPUT_BITS INTEGER 8
    set_parameter_property DEC_OUTPUT_BITS DISPLAY_NAME [get_string NUM_OF_OUTPUTS_DISPLAY_NAME ]
    set_parameter_property DEC_OUTPUT_BITS ALLOWED_RANGES {1 8 16 32}
    set_parameter_property DEC_OUTPUT_BITS UNITS None
    set_parameter_property DEC_OUTPUT_BITS DESCRIPTION [get_string NUM_OF_OUTPUTS_DESCRIPTION] 
    set_parameter_property DEC_OUTPUT_BITS GROUP [get_string TURBO_DEC_SECTION_NAME]
    set_parameter_property DEC_OUTPUT_BITS AFFECTS_GENERATION true
    set_parameter_property DEC_OUTPUT_BITS DERIVED true

}

proc add_module_parameters_debug_option {} {
    # Set the following value to 1 to enable decoder debug ports
    set ENABLE_DEBUG 0

    add_parameter DECODER_DEBUG boolean false 
    set_parameter_property DECODER_DEBUG DISPLAY_NAME [get_string DECODER_DEBUG_DISPLAY_NAME] 
    set_parameter_property DECODER_DEBUG UNITS None
    set_parameter_property DECODER_DEBUG DESCRIPTION "This is an option to enable decoder debug ports" 
    set_parameter_property DECODER_DEBUG GROUP [get_string TURBO_DEC_SECTION_NAME]
    set_parameter_property DECODER_DEBUG AFFECTS_GENERATION true
    
    if { !$ENABLE_DEBUG } {
        set_parameter_property DECODER_DEBUG VISIBLE false
    }
}
proc is_UMTS {} {
   set codec_type [get_parameter_value TURBO_STANDARD]
   return [expr {$codec_type eq {UMTS}}]
}
#Add all parameters

add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}

add_module_parameters_standard_type
add_module_parameters_codec_type
add_module_parameters_number_of_processors
add_module_parameters_map_decoding_type
add_module_parameters_num_of_dec_input_bits
add_module_parameters_num_of_dec_output_bits
add_module_parameters_debug_option 

proc get_encrypted_source_files {{encrypt "."}} { 
  if { [is_UMTS] } {
      set source_files [list  \
          "../UMTS/${encrypt}/src/rtl/auk_dspip_ctc_umts_lib_pkg.vhd" \
          "../UMTS/${encrypt}/src/rtl/ast/auk_dspip_ctc_umts_ast_sink.vhd" \
      ]
      
      if { [is_encoder] } {
        lappend source_files "../UMTS/${encrypt}/src/rtl/encoder/auk_dspip_ctc_umts_conv_encode.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/encoder/auk_dspip_ctc_umts_enc_ast_block_sink.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/encoder/auk_dspip_ctc_umts_enc_ast_block_src.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/encoder/auk_dspip_ctc_umts_enc_input.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/encoder/auk_dspip_ctc_umts_enc_input_ram.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/encoder/auk_dspip_ctc_umts_encode.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/encoder/auk_dspip_ctc_umts_encoder.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/encoder/auk_dspip_ctc_umts_encoder_top.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umts_ditlv_seq_gen.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umts_itlv.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umts_mem.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_mul_pipe.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_mult_seq_gen.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_multmod.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_papbpc_table.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_prime_rom.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_setup_control.vhd"
      } else {
        lappend source_files "../UMTS/${encrypt}/src/rtl/auk_dspip_ctc_umts_ram.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/decoder/auk_dspip_ctc_umts_decoder_top.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/decoder/auk_dspip_ctc_umts_fifo.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/decoder/auk_dspip_ctc_umts_map_decoder.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/decoder/auk_dspip_ctc_umts_siso.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/input/auk_dspip_ctc_umts_input.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/input/auk_dspip_ctc_umts_input_ram.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/input/auk_dspip_ctc_umts_itlvr_ram.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umts_ditlv_seq_gen.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umts_itlv.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umts_mem.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_mul_pipe.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_mult_seq_gen.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_multmod.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_papbpc_table.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_prime_rom.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_umtsitlv_setup_control.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_alpha.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_beta.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_constlogmap.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_constlogmap_pipelined.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_gamma.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_llr.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_logmap.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_maxlogmap.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/map/auk_dspip_ctc_umts_map_maxlogmap_pipelined.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/output/auk_dspip_ctc_umts_out_mem.vhd"
        lappend source_files "../UMTS/${encrypt}/src/rtl/output/auk_dspip_ctc_umts_output.vhd"
      }
    } else {

      set source_files [list \
          "../LTE/${encrypt}/src/rtl/auk_dspip_ctc_lib_pkg.vhd" \
          "../LTE/${encrypt}/src/rtl/ast/auk_dspip_ctc_ast_block_sink.vhd" \
      ]
      
      if { [is_encoder] } {

        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_conv_encode.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_enc_ast_block_sink.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_enc_ast_block_src.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_enc_input.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_enc_input_ram.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_enc_lte_blk_info.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_encode.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_encoder.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/encoder/auk_dspip_ctc_encoder_top.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_lte_intlvr.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_lte_intlvr0.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_lte_intlvr1.vhd"
        lappend source_files "../LTE/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_lte_intlvr_load.vhd"
      } else {
          lappend source_files "../LTE/${encrypt}/src/rtl/auk_dspip_ctc_decoder_top.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/auk_dspip_ctc_input_ram.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/auk_dspip_ctc_ram.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/blk_info/auk_dspip_ctc_lte_blk_info.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/crc/crc_pkg.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/crc/auk_dspip_crc24ab.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/decoder/auk_dspip_ctc_map_decoder.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/decoder/auk_dspip_ctc_output.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/decoder/auk_dspip_ctc_siso_debug.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/decoder/auk_dspip_ctc_siso_out.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/decoder/auk_dspip_ctc_siso.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_lte_intlvr.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_lte_intlvr0.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_lte_intlvr1.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/interleaver/auk_dspip_ctc_lte_intlvr_load.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_input.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_alpha.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_beta.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_constlogmap.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_constlogmap_pipelined.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_gamma.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_llr.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_logmap.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_maxlogmap.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/map/auk_dspip_ctc_map_maxlogmap_pipelined.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_blkmem.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_cntl.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_getbits.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_maskgen.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_out_mem.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_output_b.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_pto1mux.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_rotleft.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/output/auk_dspip_ctc_wrblkmem.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/wrapper/auk_dspip_memory_simple_dual.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/wrapper/auk_dspip_ctc_et_ast_source.vhd"
          lappend source_files "../LTE/${encrypt}/src/rtl/wrapper/auk_dspip_ctc_decoder_et_top.vhd"

      }
  }
    return $source_files
}
proc get_common_source_files {} { 
  if { [is_UMTS] } {
      set source_files [list  \
          ../../lib/packages/auk_dspip_text_pkg.vhd \
          ../../lib/packages/auk_dspip_math_pkg.vhd \
          ../../lib/packages/auk_dspip_lib_pkg.vhd \
          ../../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_block_sink.vhd \
          ../../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_block_source.vhd \
          ../../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_source.vhd \
          ../../lib/fu/roundsat/rtl/auk_dspip_roundsat.vhd \
          ../../lib/fu/delay/rtl/auk_dspip_delay.vhd \
      ]
      
      if { [is_encoder] } {
          lappend source_files ../UMTS/src/rtl/encoder/auk_dspip_ctc_umts_encoder_top.ocp

      } else {
          lappend source_files ../UMTS/src/rtl/decoder/auk_dspip_ctc_umts_decoder_top.ocp
      }

    } else {

      set source_files [list \
          ../../lib/packages/auk_dspip_text_pkg.vhd \
          ../../lib/packages/auk_dspip_math_pkg.vhd \
          ../../lib/packages/auk_dspip_lib_pkg.vhd \
          ../../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_block_sink.vhd \
          ../../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_block_source.vhd \
          ../../lib/fu/avalon_streaming/rtl/auk_dspip_avalon_streaming_source.vhd \
          ../../lib/fu/roundsat/rtl/auk_dspip_roundsat.vhd \
          ../../lib/fu/delay/rtl/auk_dspip_delay.vhd \
      ]
      
      if { [is_encoder] } {
          lappend source_files ../LTE/src/rtl/encoder/auk_dspip_ctc_encoder_top.ocp

      } else {
          lappend source_files "../LTE/src/rtl/wrapper/auk_dspip_ctc_decoder_et_top.ocp"
      }

 
  }
    return $source_files
}

proc generate_synth {entity} {
   generate QUARTUS_SYNTH $entity
}

proc generate_sim_verilog {entity} {
   set sim 1
   generate SIM_VERILOG $entity $sim
}

proc generate_sim_vhdl {entity} {
   set sim 1
   generate SIM_VHDL $entity $sim 
}


proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}


proc generate {fileset entity {sim 0}} {
      foreach a_file [get_common_source_files] {
        add_fileset_file $a_file [get_type_from_extension $a_file] PATH $a_file
      }
      if {$sim} {
        foreach simulator [get_simulator_list] {
          set sim [lindex $simulator 0]
          set enabled [lindex $simulator 1]
          if { $enabled } {
            foreach a_file [get_encrypted_source_files [string tolower $sim]] {
              add_fileset_file $a_file [get_type_from_extension $a_file] PATH $a_file "[string toupper $sim]_SPECIFIC"
            }
          } else {
            foreach a_file [get_encrypted_source_files] {
              add_fileset_file $a_file [get_type_from_extension $a_file] PATH $a_file
            }
          }
        }
      } else {
        foreach a_file [get_encrypted_source_files] {
          add_fileset_file $a_file [get_type_from_extension $a_file] PATH $a_file
        }
      }

      set filename ${entity}.sv
      if { [is_UMTS] } {
        set template_path [file join "../" "UMTS" "src" "rtl" "ctc_umts_top.sv.terp" ]
      } else {
        set template_path [file join "../" "LTE" "src" "rtl" "ctc_top.sv.terp" ]
      }   
      set top_level_contents [ render_terp $entity $sim $template_path ]
      add_fileset_file $filename SYSTEM_VERILOG TEXT $top_level_contents
}

proc get_module_name {} {
  if { [is_UMTS] } {
    if { [is_encoder] } {
        return auk_dspip_ctc_umts_encoder_top
    } else {
        return auk_dspip_ctc_umts_decoder_top
    } 
  } else {
    if { [is_encoder] } {
        return auk_dspip_ctc_encoder_top
    } else {
        return auk_dspip_ctc_decoder_et_top
    } 
  }
}

proc render_terp {output_name sim template_path} {
    
    set template_fd [open $template_path]
    set template [read $template_fd]
    close $template_fd

    foreach param [lsort [get_parameters]] {
        set params($param) [get_parameter_value $param]
    }

    set params(module_name) [get_module_name] 
    set params(output_name) $output_name
    set params(device_family) [get_parameter_value selected_device_family]
    set params(is_encoder) [is_encoder]
    set params(sink_data_width)  [get_sink_data_width]
    set params(sink_lps)  [ get_parameter_value DEC_LPS ]
    set params(source_data_width) [get_source_data_width]
    set params(frame_size_width) [get_frame_size_width]
    set params(max_iter_width) [get_max_iter_width]
    set params(engines) [get_parameter_value ENGINES]

    set params(sim) $sim 
    set contents [altera_terp $template params]
  
    return $contents
}




proc is_encoder {} {
   set codec_type [get_parameter_value CODEC_TYPE]
   return [expr {$codec_type eq {Encoder}}]
}

proc log2 { num } {
   return [expr {log($num)/log(2)}]
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


proc get_all_files_rel {root_dir} {
    set return_files {}
    foreach folder [glob -path "$root_dir/" -nocomplain -tails -type d * ] {
       foreach cur_file [get_all_files_rel [file join $root_dir $folder]] {
         lappend return_files [file join $folder $cur_file]
       }
    } 
    foreach leaf [glob -path "$root_dir/" -nocomplain -tails -type f *] {
      lappend return_files $leaf
    }
    return $return_files
}

proc get_all_files_abs {root_dir} {
    set cur_dir [pwd]
    cd $root_dir
    set all_files {}
    foreach item [glob -nocomplain -type d * ] {
        lappend all_files {*}[get_all_files_abs $item ]
    } 
    foreach item [glob -nocomplain  -type f * ] {
        lappend all_files $item
    } 
    cd $cur_dir
    return $all_files
}


proc generate_test_data {output_name} {
    set cwd [pwd]
    #Add input files
    if { [is_UMTS] } {
        if { [is_encoder] } {
            set input_files [glob -directory "$cwd/../UMTS/test/sample_files"  ctc_umts_enc_*{.txt}]
        } else {
            set input_files [glob -directory "$cwd/../UMTS/test/sample_files"  ctc_umts_dec_*{.txt}]
        }
    } else {
        if { [is_encoder] } {
            set input_files [glob -directory "$cwd/../LTE/test/sample_files"  ctc_encoder_*{.txt}]
        } else {
            set input_files [glob -directory "$cwd/../LTE/test/sample_files"  {{ctc_input,ctc_decoded_output,ctc_output}*.txt}]
        }
    }

    foreach file $input_files {
        set file_name [file tail $file]
        add_fileset_file [file join "test_data" $file_name] OTHER PATH $file
   }
   
   return $input_files
   
}

proc generate_test_program {output_name} {
    if { [is_UMTS] } {
        if { [is_encoder] } {
            set template_path "../UMTS/src/testbench/ctc_umts_enc_testbench.sv.terp"
        } else {
            set template_path "../UMTS/src/testbench/ctc_umts_dec_testbench.sv.terp"
        }
    } else {
        if { [is_encoder] } {
            set template_path "../LTE/src/testbench/ctc_enc_testbench.sv.terp"
        } else {
            set template_path "../LTE/src/testbench/ctc_dec_testbench.sv.terp"
        }
    }

    set terp_contents [render_terp $output_name 0 $template_path ]
    set test_program_file "${output_name}_test_program.sv" 
    add_fileset_file [file join "src" $test_program_file] [filetype $test_program_file] TEXT $terp_contents
}


proc add_support_files {output_name} {
    set cwd [pwd]
    #Add input files
    if { [is_UMTS] } {
        if { [is_encoder] } {
            set input_files [glob -directory "$cwd/../UMTS/test/sample_files"  ctc_umts_enc_*{.txt}]
        } else {
            set input_files [glob -directory "$cwd/../UMTS/test/sample_files"  ctc_umts_dec_*{.txt}]
        }
    } else {
        if { [is_encoder] } {
            set input_files [glob -directory "$cwd/../LTE/test/sample_files"  ctc_encoder_*{.txt}]
        } else {
            set input_files [glob -directory "$cwd/../LTE/test/sample_files"  {{ctc_input,ctc_decoded_output,ctc_output}*.txt}]
        }
    }

    foreach file $input_files {
        set file_type "Memory"
        set file_name [file tail $file]
        set test_data_path "test_data"
        # Copy files under test/sample_files to $test_data_path folder
        add_fileset_file [file join $test_data_path $file_name] OTHER PATH $file
   }

    #Generate Test Program
    set source_files_path src
    if { [is_UMTS] } {
        if { [is_encoder] } {
            set template_path "../UMTS/src/testbench/ctc_umts_enc_testbench.sv.terp"
        } else {
            set template_path "../UMTS/src/testbench/ctc_umts_dec_testbench.sv.terp"
        }
    } else {
        if { [is_encoder] } {
            set template_path "../LTE/src/testbench/ctc_enc_testbench.sv.terp"
        } else {
            set template_path "../LTE/src/testbench/ctc_dec_testbench.sv.terp"
        }
    }

    set terp_contents [render_terp $output_name 0 $template_path ]
    set test_program_file "${output_name}_test_program.sv" 
    add_fileset_file $test_program_file [filetype $test_program_file] TEXT $terp_contents

}
#Example Fileset Generates: (in order)
#                             A SystemVerilog Test program
#                             Test stimuli
#                             SystemVerilog Bus Functional models to drive the simulation
#                             Simulation scripts for the simulators using ip-make-simscript
proc example_fileset {output_name} {
    set cwd [pwd]

    # Genarate test program
    send_message INFO "Generating Test Program"
    generate_test_program $output_name
    
    # Genarate test data
    send_message INFO "Generating test_data"
    set test_files [generate_test_data output_name]
    

    send_message INFO "Generating Testbench System"
    set family "[get_parameter_value selected_device_family]"
    set turbo_example_name "core" 
    set qsys_system "${output_name}.qsys"
    #Generate testbench files
    set temp_dir  [create_temp_file ""]

    file mkdir $temp_dir
    cd $temp_dir

    set testbench_dir  [create_temp_file ""]
    file mkdir $testbench_dir

    set script_name "$temp_dir/${output_name}.tcl"
    set sim_script_name "$temp_dir/${output_name}_tmp.spd"
    set sim_script [open $sim_script_name w+]

    set f_handle [open $script_name w+]

    puts $f_handle    "package require -exact qsys 14.1"
    puts $f_handle    "set_project_property DEVICE_FAMILY \"${family}\""
    puts $f_handle    "add_instance ${turbo_example_name} altera_turbo"
    foreach param [lsort [get_parameters]] {
        if {[get_parameter_property $param DERIVED] == 0} {
            #Screen for design environment, only QSYS flow is supported, because Native steps all over the BFMs by creating conduits
            if { $param ne "design_env" } { 
            puts $f_handle "set_instance_parameter_value $turbo_example_name $param \"[get_parameter_value $param]\""
            } else {
            puts $f_handle "set_instance_parameter_value $turbo_example_name $param \"QSYS\""

            }
        }
    }
    puts $f_handle    "add_interface ${turbo_example_name}_rst reset sink"
    puts $f_handle    "set_interface_property ${turbo_example_name}_rst EXPORT_OF ${turbo_example_name}.rst"
    puts $f_handle    "add_interface ${turbo_example_name}_clk clock sink"
    puts $f_handle    "set_interface_property ${turbo_example_name}_clk EXPORT_OF ${turbo_example_name}.clk"
    puts $f_handle    "add_interface ${turbo_example_name}_sink avalon_sink sink"
    puts $f_handle    "set_interface_property ${turbo_example_name}_sink EXPORT_OF ${turbo_example_name}.sink"
    puts $f_handle    "add_interface ${turbo_example_name}_source avalon_source source"
    puts $f_handle    "set_interface_property ${turbo_example_name}_source EXPORT_OF ${turbo_example_name}.source"
    puts $f_handle    "save_system ${qsys_system}"

    close $f_handle
    set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-script"] 


    set cmd [list  $program --script=$script_name ]
    set status [catch {exec {*}$cmd} err]


    #now use this qsys SYSTEM
    set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-generate"] 
    set cmd "$program $qsys_system --testbench=STANDARD --testbench-simulation=VERILOG --output-directory=$testbench_dir";
    set status [catch {exec {*}$cmd} err]

    # The report varies based on whether its the new fileset or old.
    set filename "$testbench_dir/${output_name}/${output_name}_generation.rpt"
    if { [file exists $filename ] == 0 } {
      set filename "$testbench_dir/${output_name}_tb/${output_name}_generation.rpt"
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
        send_message NOTE "Turbo Example Testbench Generation Complete"
    }        

    # send_message DEBUG "Looking in $testbench_dir"
    # set qsys_out_dir [file join $testbench_dir ${output_name}]
    # if { [file exists $filename ] == 0 } {
      # set qsys_out_dir "$testbench_dir/${output_name}_tb"
    # } 
    # set all_files [get_all_files_rel $qsys_out_dir]
    # foreach module $all_files {
        # if {[file exists [file join $qsys_out_dir $module] ]} {
          # set ext [get_type_from_extension $module "true"]
          # add_fileset_file $module $ext PATH [file join $qsys_out_dir $module]
        # }
    # }
    
    
    
    set simulator_list { \
             {mentor   modelsim} \
             {aldec    riviera} \
             {synopsys vcs} \
             {cadence  ncsim} \
           }
           
    set all_files [get_all_files_abs [file join "${temp_dir}"]]
    foreach module [lsearch -inline -all -glob $all_files *] {
          set ext [get_type_from_extension $module "true"]
          #add_fileset_file [file join "src" [file tail $module] ] $ext PATH $module
        if { [regexp  {.*(\.hex$)|(\.mif$)|(\.v$)|(\.sv$)|(\.vo$)|(\.vho$)} [file tail $module] ] == 1 } {
            set ext [get_type_from_extension $module "true"]
            add_fileset_file [file join "src" [file tail $module]] $ext PATH $module
        }
        if { [regexp  {.*(\.vhd$)} [file tail $module] ] == 1 } {
            set added 0
            foreach simulator $simulator_list {
                set sim [lindex $simulator 0]
                # if it has encryption it will be located in the simulator sub-directory
                if {[string match *$sim*  $module ] == 1} {
                    add_fileset_file [file join "src/$sim" [file tail $module]] VHDL PATH $module
                    set added 1
                    break
                }
            }
            if {!$added} {
                add_fileset_file [file join "src" [file tail $module]] VHDL PATH $module
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
        } elseif { [regexp  {.*((pkg\.v)|(pkg\.sv)|(pkg\.vhd)|(mat\.sv))} $cur_file] == 1 } {
            lappend packages $cur_file
        } elseif { [regexp  {.*\.((v)|(sv)|(vhd))} $cur_file] == 1 } {
            if {[regexp  {.*((_inst\.)|(_bb\.))(v|(sv)|(vhd))} $cur_file ] == 0} {
                lappend generic_files $cur_file
            }
        } elseif { [regexp  {.*\.((hex)|(mif))}  $cur_file] == 1 } {
            lappend memory_files $cur_file
        }
    }

   
    # reordering the generic file 
    set generic_files [concat $packages $generic_files]
    set generic_files_temp $generic_files
    set ordered_files [concat [get_common_source_files] [get_encrypted_source_files]]
    set ordered_file_list [list ]

    foreach order_file $ordered_files {
        foreach current_file $generic_files_temp {

            if {[string match -nocase [file tail $current_file]  [file tail $order_file]]} {
                # add the file to the priority list
                lappend ordered_file_list $current_file
                set pos [lsearch $generic_files $current_file]
                # remove the file to the generic_files
                set generic_files [lreplace $generic_files $pos $pos]
            }
        }
    }

    #puting the package files first
    set rtl_files [concat $ordered_file_list $generic_files]
    
    ###################################################################################################
   send_message INFO "Generating Simulation Scripts"
   # set the spd
   puts $sim_script "<simPackage>"
   set library "work"
   set source_files_path src
   set test_program_file "${output_name}_test_program.sv"
   
    foreach file $rtl_files {
      if { [lsearch $all_files $file] != -1 } {
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         if { [regexp  {.*(\.vhd$)} [file tail $file]] ==1} {
            set added 0
            foreach simulator $simulator_list {
                set sim [lindex $simulator 0]
                set tool [lindex $simulator 1]
                if {[string match *$sim*  $file ] == 1} {
                    set file_name [file join $source_files_path $sim [file tail $file]]
                    puts $sim_script [convert_to_spd_xml  $file_name VHDL_ENCRYPT $library $tool]
                    set added 1
                    break
                } 
            }
            if {!$added} {
                set file_name [file join $source_files_path [file tail $file]]
                puts $sim_script [convert_to_spd_xml  $file_name VHDL $library ""]
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
         puts $sim_script [convert_to_spd_xml  $file_name "Memory" $library ""]
      }
   }
   foreach file $top_files {
      set file_type [filetype $file]
      set file_name [file join $source_files_path [file tail $file]]
      puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]
   }

   # Add the top level 
   set file_name [file join $source_files_path $test_program_file]
   set file_type [filetype $file_name]
   puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]


   # add input files
   foreach file $test_files {
      set file_type "Memory"
      set file_name [file tail $file]
      puts $sim_script [convert_to_spd_xml  [file join "test_data" $file_name] $file_type 0 ""]
   }
   
   puts $sim_script "<topLevel name=\"test_program\"/>"
   puts $sim_script "<deviceFamily name=\"[get_parameter_value selected_device_family]\"/>"
   puts $sim_script "</simPackage>"
   close $sim_script

   # file mkdir "sim_scripts"
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "ip-make-simscript"] 
   set cmd [list  $program --spd=$sim_script_name --use-relativepaths --output_directory=[file join [pwd] "sim_scripts"]]
   send_message INFO "$cmd"
   set status [catch {exec {*}$cmd} err]
   set root     [file join [pwd] "sim_scripts" ] 
   add_files_recursive $root

    
    
    cd $cwd
}
proc get_frame_size_width {} {
    # Maximum frame size supported by LTE Turbo
    set MAX_FRAME_SIZE          6144  
    if { [is_UMTS] } {
        set MAX_FRAME_SIZE          5114  
      }
    set frame_size_width        [expr int(ceil(log($MAX_FRAME_SIZE)/log(2)))]
    
    return $frame_size_width
}

proc get_debug_id_width {} {
    set DEBUG_ID_WIDTH          4
    return $DEBUG_ID_WIDTH
}

proc get_track_blk_id_width {} {
    set TRACK_BLK_ID_WIDTH      3
    return $TRACK_BLK_ID_WIDTH
}

proc get_max_iter_width {} {
    set MAX_ITER_WIDTH          5 
    return $MAX_ITER_WIDTH
}

# 
proc get_sink_data_width {} {
    if { [is_encoder] } {
        return 1
    } else {
        return [expr {3*[ get_parameter_value DEC_INPUT_BITS ]}]
    }
}

proc get_source_data_width {} {
    if { [is_encoder] } {
        return 3
    } else {
        return [get_parameter_value DEC_OUTPUT_BITS]
    }
}

proc elaboration_callback {} {
    set codec_type                           [ get_parameter_value CODEC_TYPE ]
    set engines                              [ get_parameter_value ENGINES ]
    set map_dec_type                         [ get_parameter_value MAP_DEC_TYPE ]
    set dec_input_bits                       [ get_parameter_value DEC_INPUT_BITS ]
    set dec_output_bits                      [ get_parameter_value DEC_OUTPUT_BITS ]
    set dec_lps                              [ get_parameter_value DEC_LPS ]
    set debug_enabled                        [ get_parameter_value DECODER_DEBUG ]
    
    set frame_size_width [get_frame_size_width]
    set debug_id_width [get_debug_id_width]
    set track_blk_id_width [get_track_blk_id_width]
    set max_iter_width [get_max_iter_width]

    if { [is_UMTS] } {
        if { [is_encoder] } {
            set comb_sink_data_width [expr {$frame_size_width + 1}] 
            set comb_source_data_width [expr {$frame_size_width + 3}] 
            set sink_data_fragment_list "sink_blk_size $frame_size_width sink_data 1"
            set source_data_fragment_list "source_blk_size $frame_size_width source_data_s 3"
        } else { # Decoder
            set comb_sink_data_width [expr {$frame_size_width + 3*$dec_input_bits + $max_iter_width}] 
            set comb_source_data_width [expr {$dec_output_bits + $frame_size_width}]

            set sink_data_fragment_list "sink_iter $max_iter_width sink_blk_size $frame_size_width sink_data 3*$dec_input_bits"
            set source_data_fragment_list "source_blk_size $frame_size_width source_data_s $dec_output_bits"
       }
    } else {
        if { [is_encoder] } {
            set comb_sink_data_width [expr {$frame_size_width + 1}] 
            set comb_source_data_width [expr {$frame_size_width + 3}] 
            set sink_data_fragment_list "sink_blk_size $frame_size_width sink_data 1"
            set source_data_fragment_list "source_blk_size $frame_size_width source_data_s 3"
        } else { # Decoder
            set comb_sink_data_width [expr {$frame_size_width + 3*$dec_input_bits*$dec_lps + $max_iter_width + 1}] 
            set comb_source_data_width [expr {$dec_output_bits + $frame_size_width + $max_iter_width + 2}]

            set sink_data_fragment_list "sel_crc24a 1 sink_max_iter $max_iter_width sink_blk_size $frame_size_width sink_data 3*$dec_input_bits*$dec_lps"
            set source_data_fragment_list "crc_pass 1  crc_type 1 source_iter $max_iter_width source_blk_size $frame_size_width source_data_s $dec_output_bits"
            
            # set source_data_fragment_list ""
            # if { $debug_enabled } {
                # set comb_source_data_width [expr {$comb_source_data_width + 4*$debug_id_width + $track_blk_id_width}]
                # append source_data_fragment_list "source_blk_id $track_blk_id_width source_debug 4*$debug_id_width "
            # }

            # append source_data_fragment_list "CRC_Pass 1  CRC_Type 1 source_iter $max_iter_width source_blk_size $frame_size_width source_data_s $dec_output_bits"

        }
    }
    
    add_interface clk clock end
    add_interface_port clk clk clk Input 1

    add_interface rst reset end
    set_interface_property rst associatedClock clk
    add_interface_port rst reset_n reset_n Input 1

    dsp_add_streaming_interface sink sink
    dsp_set_interface_property sink associatedClock clk
    dsp_set_interface_property sink dataBitsPerSymbol $comb_sink_data_width
    dsp_add_interface_port sink sink_valid valid Input 1
    dsp_add_interface_port sink sink_ready ready Output 1
    dsp_add_interface_port sink sink_error error Input 2
    dsp_add_interface_port sink sink_sop startofpacket Input 1
    dsp_add_interface_port sink sink_eop endofpacket Input 1
    dsp_add_interface_port sink sink_data data Input $comb_sink_data_width $sink_data_fragment_list 

    dsp_add_streaming_interface source source
    dsp_set_interface_property source associatedClock clk
    dsp_set_interface_property source dataBitsPerSymbol $comb_source_data_width
    dsp_add_interface_port source source_valid valid Output 1
    dsp_add_interface_port source source_ready ready Input 1
    dsp_add_interface_port source source_error error Output 2
    dsp_add_interface_port source source_sop startofpacket Output 1
    dsp_add_interface_port source source_eop endofpacket Output 1
    dsp_add_interface_port source source_data data Output $comb_source_data_width $source_data_fragment_list 
}

# +-----------------------------------
# | Callbacks
# | 
proc validation_turbo_top {} {
    set codec_type                           [ get_parameter_value CODEC_TYPE ]
    set engines                              [ get_parameter_value ENGINES ]
    set map_dec_type                         [ get_parameter_value MAP_DEC_TYPE ]
    set dec_input_bits                       [ get_parameter_value DEC_INPUT_BITS ]
    set dec_output_bits                      [ get_parameter_value DEC_OUTPUT_BITS ]
    set dec_lps                              [ get_parameter_value DEC_LPS ]

    # Enable/Disable controls 
    set list_lps [list ${dec_lps}]
    set_parameter_property DEC_LPS VISIBLE false
    
    if { [is_encoder] } {
        set_parameter_property ENGINES ENABLED false
        set_parameter_property MAP_DEC_TYPE ENABLED false
        set_parameter_property DEC_INPUT_BITS ENABLED false
        set_parameter_property DEC_OUTPUT_BITS ENABLED false
        set_parameter_property DEC_LPS ENABLED false
        set_parameter_property ENGINES ALLOWED_RANGES {2 4 8 16 32}
        set_parameter_property DEC_LPS ALLOWED_RANGES $list_lps
    } else {
        set_parameter_property ENGINES ENABLED true
        set_parameter_property MAP_DEC_TYPE ENABLED true
        set_parameter_property DEC_INPUT_BITS ENABLED true
        set_parameter_property DEC_OUTPUT_BITS ENABLED true
        
        if { [is_UMTS] } {           
            set_parameter_value DEC_OUTPUT_BITS 1
            set_parameter_property ENGINES ALLOWED_RANGES {2 4}
            set_parameter_property DEC_LPS ENABLED false
            set_parameter_property DEC_LPS ALLOWED_RANGES $list_lps
        } else {
            if {$engines<16} {
                set_parameter_value DEC_OUTPUT_BITS 8
            } else {
                set_parameter_value DEC_OUTPUT_BITS $engines
            }
            set_parameter_property ENGINES ALLOWED_RANGES {2 4 8 16 32}
            set_parameter_property DEC_LPS VISIBLE true
            set_parameter_property DEC_LPS ENABLED true
            set list_lps [list 1 2]
            set_parameter_property DEC_LPS ALLOWED_RANGES $list_lps
        }
    }
}   
