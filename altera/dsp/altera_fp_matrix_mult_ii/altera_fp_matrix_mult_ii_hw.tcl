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

source "../lib/tcl/avalon_streaming_util.tcl"
source "../lib/tcl/dspip_hls_common.tcl"
load_strings altera_fp_matrix_mult_ii.properties

#
# module altera_fp_matrix_mult_ii 
# 
set_module_property NAME altera_fp_matrix_mult_ii
set_module_property AUTHOR [get_string AUTHOR]
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP [get_string GROUP]
set_module_property DISPLAY_NAME "ALTERA_FP_MATRIX_MULT"
set_module_property DESCRIPTION [get_string DESCRIPTION]
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property PREFERRED_SIMULATION_LANGUAGE Verilog
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
set_module_property PARAMETER_UPGRADE_CALLBACK parameter_upgrade
set_module_property HIDE_FROM_QSYS false
set_module_property HIDE_FROM_QUARTUS false
set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10} {Stratix 10}
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1410764818924/eis1410936966508 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408

#
# set the HLS component name, which is the name of .cpp file that describes the component
#
proc get_hls_component_name {} {
   return "matrix_mult"
}

#
# file sets
#
proc add_filesets {} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset" 
    }
}

add_filesets

#
# parameters 
#
add_parameter FP_FORMAT string "SINGLE"
set_parameter_property FP_FORMAT DISPLAY_NAME [get_string FP_FORMAT_DISPLAY_NAME ]
set_parameter_property FP_FORMAT UNITS None
set_parameter_property FP_FORMAT DESCRIPTION [get_string FP_FORMAT_DESCRIPTION]
set_parameter_property FP_FORMAT ALLOWED_RANGES [list "SINGLE:[get_string FP_FORMAT_FLOAT_NAME]" \
                                                      "DOUBLE:[get_string FP_FORMAT_DOUBLE_NAME]"]
set_parameter_property FP_FORMAT AFFECTS_GENERATION true
set_parameter_property FP_FORMAT GROUP [get_string FLOATING_PT_DATA_GROUP]

add_parameter MULTIPLICATION_TYPE string "REAL"
set_parameter_property MULTIPLICATION_TYPE DISPLAY_NAME [get_string MULTIPLICATION_TYPE_DISPLAY_NAME ]
set_parameter_property MULTIPLICATION_TYPE UNITS None
set_parameter_property MULTIPLICATION_TYPE DESCRIPTION [get_string MULTIPLICATION_TYPE_DESCRIPTION]
set_parameter_property MULTIPLICATION_TYPE ALLOWED_RANGES [list "REAL:[get_string MULTIPLICATION_TYPE_REAL_NAME]" \
                                                                "COMPLEX:[get_string MULTIPLICATION_TYPE_COMPLEX_NAME]" \
                                                                "COMPLEX_KARATSUBA:[get_string MULTIPLICATION_TYPE_COMPLEX_KARATSUBA_NAME]"]
set_parameter_property MULTIPLICATION_TYPE AFFECTS_GENERATION true
set_parameter_property MULTIPLICATION_TYPE GROUP [get_string FLOATING_PT_DATA_GROUP]

add_parameter A_ROWS INTEGER 8
set_parameter_property A_ROWS DISPLAY_NAME [get_string A_ROWS_NAME ]
set_parameter_property A_ROWS DESCRIPTION [get_string A_ROWS_DESCRIPTION]
set_parameter_property A_ROWS ALLOWED_RANGES 2:256 
set_parameter_property A_ROWS AFFECTS_GENERATION true
set_parameter_property A_ROWS GROUP [get_string MATRIX_DIMENSIONS_GROUP]

add_parameter A_COLUMNS INTEGER 8
set_parameter_property A_COLUMNS DISPLAY_NAME [get_string A_COLUMNS_NAME ]
set_parameter_property A_COLUMNS DESCRIPTION [get_string A_COLUMNS_DESCRIPTION]
set_parameter_property A_COLUMNS ALLOWED_RANGES 4:256 
set_parameter_property A_COLUMNS AFFECTS_GENERATION true
set_parameter_property A_COLUMNS GROUP [get_string MATRIX_DIMENSIONS_GROUP]

add_parameter B_ROWS INTEGER 8
set_parameter_property B_ROWS DISPLAY_NAME [get_string B_ROWS_NAME ]
set_parameter_property B_ROWS DESCRIPTION [get_string B_ROWS_DESCRIPTION]
set_parameter_property B_ROWS DERIVED true
set_parameter_property B_ROWS GROUP [get_string MATRIX_DIMENSIONS_GROUP]

add_parameter B_COLUMNS INTEGER 8
set_parameter_property B_COLUMNS DISPLAY_NAME [get_string B_COLUMNS_NAME ]
set_parameter_property B_COLUMNS DESCRIPTION [get_string B_COLUMNS_DESCRIPTION]
set_parameter_property B_COLUMNS ALLOWED_RANGES 2:256 
set_parameter_property B_COLUMNS AFFECTS_GENERATION true
set_parameter_property B_COLUMNS GROUP [get_string MATRIX_DIMENSIONS_GROUP]

add_parameter VECTOR_SIZE INTEGER 8
set_parameter_property VECTOR_SIZE DISPLAY_NAME [get_string VECTOR_SIZE_NAME ]
set_parameter_property VECTOR_SIZE DESCRIPTION [get_string VECTOR_SIZE_DESCRIPTION]
set_parameter_property VECTOR_SIZE ALLOWED_RANGES {4 8 16 32 64 96 128}
set_parameter_property VECTOR_SIZE AFFECTS_GENERATION true
set_parameter_property VECTOR_SIZE GROUP [get_string IMPLEMENTATION_GROUP]

add_parameter NUM_BLOCKS INTEGER 4
set_parameter_property NUM_BLOCKS DISPLAY_NAME [get_string NUM_BLOCKS_NAME ]
set_parameter_property NUM_BLOCKS DESCRIPTION [get_string NUM_BLOCKS_DESCRIPTION]
set_parameter_property NUM_BLOCKS AFFECTS_GENERATION true
set_parameter_property NUM_BLOCKS GROUP [get_string IMPLEMENTATION_GROUP]

add_parameter OPTIMIZATION string "BALANCED"
set_parameter_property OPTIMIZATION DISPLAY_NAME [get_string OPTIMIZATION_DISPLAY_NAME ]
set_parameter_property OPTIMIZATION UNITS None
set_parameter_property OPTIMIZATION DESCRIPTION [get_string OPTIMIZATION_DESCRIPTION]
set_parameter_property OPTIMIZATION ALLOWED_RANGES [list "AREA:[get_string OPTIMIZATION_AREA_NAME]" \
                                                                "BALANCED:[get_string OPTIMIZATION_BALANCED_NAME]" \
                                                                "FMAX:[get_string OPTIMIZATION_FMAX_NAME]"]
set_parameter_property OPTIMIZATION AFFECTS_GENERATION true
set_parameter_property OPTIMIZATION GROUP [get_string IMPLEMENTATION_GROUP]

add_parameter IS_TESTING BOOLEAN false 
set_parameter_property IS_TESTING VISIBLE false 

#
# device parameters
#
add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}


#
# procs
#
proc send_message_from_strings {type id} {
    set message [get_string $id]
    send_message $type [uplevel [list subst -nocommands $message]]
}

proc get_data_width {} {
   set data_type [get_parameter_value FP_FORMAT]
   set data_width 64
   if { $data_type eq "SINGLE" } {
      set data_width 32
   } elseif { $data_type eq "DOUBLE" } {
      set data_width 64
   }
   if [is_complex] {
      set data_width [expr {$data_width * 2}]
   }
   return $data_width
}


proc elaborate {} {
   set data_width [get_data_width]

   # set derived parameters
   set_parameter_value B_ROWS [get_parameter_value A_COLUMNS] 

   add_interface clk clock end
   add_interface_port clk clk clk Input 1

   add_interface rst reset end
   set_interface_property rst associatedClock clk
   add_interface_port rst reset_n reset_n Input 1

   add_interface a avalon_streaming sink
   set_interface_property a associatedClock clk
   set_interface_property a dataBitsPerSymbol $data_width
   add_interface_port a a_valid valid Input 1
   add_interface_port a a_ready ready Output 1
   add_interface_port a a_data data Input $data_width

   add_interface b avalon_streaming sink
   set_interface_property b associatedClock clk
   set_interface_property b dataBitsPerSymbol $data_width
   add_interface_port b b_valid valid Input 1
   add_interface_port b b_ready ready Output 1
   add_interface_port b b_data data Input $data_width

   add_interface c avalon_streaming source
   set_interface_property c associatedClock clk
   set_interface_property c dataBitsPerSymbol $data_width
   add_interface_port c c_valid valid Output 1
   add_interface_port c c_ready ready Input 1
   add_interface_port c c_data data Output $data_width 
   set_interface_assignment c "ui.blockdiagram.direction" OUTPUT
}


proc validate {} {
   set vector_size   [get_parameter_value VECTOR_SIZE]
   set num_blocks    [get_parameter_value NUM_BLOCKS]
   set aa_columns    [get_parameter_value A_COLUMNS]
   set bb_columns    [get_parameter_value B_COLUMNS]

   # matix_A num cols must be an integer multiple of vector size
   # vector size must be an integer multiple of blocks
   if { ($aa_columns % $vector_size) != 0 } {
      send_message_from_strings ERROR INCORRECT_COLS_VEC_RATIO_MSG
   } 
   if { $vector_size <= $num_blocks } {
      send_message_from_strings ERROR VEC_SIZE_MUST_BE_LARGER_THAN_NUM_BLOCK_MSG
   }
   if { ($vector_size % $num_blocks) != 0 } {
      send_message_from_strings ERROR INCORRECT_VEC_BLOCK_RATIO_MSG
   }
   if { $num_blocks < $vector_size/$bb_columns } {
      send_message_from_strings ERROR NUM_BLOCKS_MUST_BE_GEQ_TO_VEC_SIZE_OVER_B_COLS
   }
}   

proc render_terp {output_name template_path} {
   set template_fd [open $template_path]
   set template [read $template_fd]
   close $template_fd

   set params(output_name) $output_name
   set params(data_width) [get_data_width] 

   set contents [altera_terp $template params]
   return $contents
}

proc get_unsigned_type { num } {
   if { $num > 2**16 - 1 } {
      set type {unsigned int}
   } elseif { $num > 255 } {
      set type {unsigned short}
   } else {
      set type {unsigned char}
   }
}

proc get_k_type { arch } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_k_type"
   }
   set c_rows [get_parameter_value A_ROWS]
   set c_cols [get_parameter_value B_COLUMNS]
   set a_cols [get_parameter_value A_COLUMNS]
   set vec_size [get_parameter_value VECTOR_SIZE]
   set max_k [expr {$c_rows * $c_cols * $a_cols/$vec_size + $c_cols}]
   return [get_unsigned_type $max_k]
}

proc get_i_type { arch } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_i_type"
   }
   set c_rows [get_parameter_value A_ROWS]
   if { $c_rows > 127 } {
      set type short
   } else {
      set type char
   }
   return $type
}

proc get_j_type { arch } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_j_type"
   }
   set c_cols [get_parameter_value B_COLUMNS]
   return [get_unsigned_type $c_cols]
}

proc get_s_type { arch } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_s_type"
   }
   set a_cols [get_parameter_value A_COLUMNS]
   set vec_size [get_parameter_value VECTOR_SIZE]
   return [get_unsigned_type [expr {$a_cols/$vec_size}]]
}

proc get_a_i_type { arch padding } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_a_i_type"
   }
   set a_cols [get_parameter_value A_COLUMNS]
   set a_rows [get_parameter_value A_ROWS]
   return [get_unsigned_type [expr {($a_cols + $padding) * $a_rows}]]
}

proc get_b_r_type { arch padding } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_b_r_type"
   }
   set b_rows [get_parameter_value B_ROWS]
   return [get_unsigned_type [expr {$b_rows + $padding}]]
}

proc get_b_c_type { arch } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_b_c_type"
   }
   set b_cols [get_parameter_value B_COLUMNS]
   return [get_unsigned_type $b_cols]
}

proc get_a_bankwidth_in_bytes { arch num_banks } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_a_bankwidth"
   }
   set num_blocks [get_parameter_value NUM_BLOCKS]
   set bank_width_in_bytes [expr {([get_data_width] / 8) * $num_blocks}]
   #when case:233068 is fixed remove the following line
   set bank_width_in_bytes [expr {int(pow(2,ceil(log($bank_width_in_bytes)/log(2)))/$num_banks)}]
   return $bank_width_in_bytes
}

proc get_b_bankwidth_in_bytes { arch num_banks } {
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_b_bankwidth"
   }
   set vec_size [get_parameter_value VECTOR_SIZE]
   set bank_width_in_bytes [expr {([get_data_width] / 8) * $vec_size}]
   #when case:233068 is fixed remove the following line
   set bank_width_in_bytes  [expr {int(pow(2,ceil(log($bank_width_in_bytes)/log(2)))/$num_banks)}]
   return $bank_width_in_bytes
}

# When a "vine" of DSP blocks implements the dot product (typical of Arria 10
# single precision implementations, as hard FP is used directly), delay lines
# feeding DSP blocks at the end of the "vine" can be reduced by 
# configuring the memory in multiple banks. 
# The parameter "num" represents dot vector width (+ padding) in the case of 
# "B" memory, and num_block (+ padding) in the case of "A" memory.
proc get_num_banks { arch num } {
   set data_type [get_parameter_value FP_FORMAT]
   if { $arch != 1 } {
      send_message ERROR "arch $arch is not supported by proc get_num_banks"
   }
   if { [is_s10_or_a10] && ( $data_type eq {SINGLE} ) } {
      set num_banks [expr {($num + 15)/16}]
   } else {
      set num_banks 1
   }
   return $num_banks
}

# Area/Frequency trade-offs are obtained via the i++ --clock option.
# When a --clock value is specified, the compiler will iterate to obtain close to the 
# specified frequency. Therefore the default "Balanced" optimisation does not specify a
# --clock value.  
#
# Returns either 0 or a clock frequency with a MHz suffix

proc get_hls_clock_freq {} {
   set data_type [get_parameter_value FP_FORMAT]
   set multiplication_type [get_parameter_value MULTIPLICATION_TYPE]
   set optimization [get_parameter_value OPTIMIZATION]
   set aa_rows [get_parameter_value A_ROWS]
   set aa_columns [get_parameter_value A_COLUMNS]
   set bb_columns [get_parameter_value B_COLUMNS]
   set vec_size [get_parameter_value VECTOR_SIZE]
   set clock_freq "0"
   if { [is_s10_or_a10] } {    ;# i.e. just A10
      if { $data_type eq {DOUBLE} } {
         if { $optimization eq {AREA} } {
            set clock_freq "300MHz"
         } elseif { $optimization eq {FMAX} } {
            set clock_freq "500MHz"
         }
      }
   } else {
      # devices other than Arria 10 -> optimise for Stratix V
      if { $data_type eq {SINGLE} } {
         if { ($multiplication_type eq {REAL}) && ($optimization eq {FMAX}) } {
            set clock_freq "500MHz"  
         } elseif { ($multiplication_type eq {COMPLEX}) && ($optimization eq {AREA}) } {
            set clock_freq "300MHz"
         } elseif { ($multiplication_type eq {COMPLEX}) && ($optimization eq {FMAX}) } {
            set clock_freq "500MHz" 
         } elseif { ($multiplication_type eq {COMPLEX_KARATSUBA}) && ($optimization eq {FMAX}) } {
            set clock_freq "500MHz"  
         }
      } else {  # DOUBLE
         if { $optimization eq {AREA} } {
            set clock_freq "300MHz"
         } elseif { $optimization eq {FMAX} } {
            set clock_freq "500MHz"
         }
      }
   }
   return $clock_freq
}

#Returns the difference between the next power of two and num
proc get_dist_to_next_pow2 { num } {
   set next_power_of_two  [expr {int(pow(2,ceil(log($num)/log(2))))}]
   return [expr {$next_power_of_two - $num}]
}

proc is_complex {} {
   set multiplication_type [get_parameter_value MULTIPLICATION_TYPE]
   if { $multiplication_type eq {REAL} } {
      set result 0
   } elseif { ($multiplication_type eq {COMPLEX}) || ($multiplication_type eq {COMPLEX_KARATSUBA}) } {
      set result 1
   } else {
      send_message ERROR "Matrix multiply mode $multiplication_type is not supported"
   }
   return $result
}

proc is_s10_or_a10 {} {
   set family [get_parameter_value selected_device_family]
   return [expr ([string match -nocase arria*10 $family] || [string match -nocase stratix*10 $family] ) ]
}

proc use_fpc {} {
   set data_type [get_parameter_value FP_FORMAT]
   if { [is_complex] } {
      set do_it 1
   } elseif { [is_s10_or_a10] && $data_type eq {SINGLE}} {
      set do_it 0
   } else {
      set do_it 1
   }
   return $do_it
}

# If the number of columns in B is less than the latency of a soft-FP addition,
# accumulation of running sums becomes a bottle-neck that the compiler tries to
# mitigate at the cost of fMax. Therefore where necessary multiple running sums
# must be maintained per column of the output matrix. 
proc get_running_sum_mult {} {
   set a_cols    [get_parameter_value A_COLUMNS]
   set b_cols    [get_parameter_value B_COLUMNS]
   set data_type [get_parameter_value FP_FORMAT]
   set vec_sz    [get_parameter_value VECTOR_SIZE]
   
   if [use_fpc] {
      if { $data_type eq {SINGLE} } {
         set accum_latency 8 
      } elseif { $data_type eq {DOUBLE} } {
         set accum_latency 12 
      } else {
         send_message ERROR "Internal Error: Invalid data format" 
      }
   } else {
      #in this case we want accum_latency comparison to be always false
      set accum_latency $b_cols
   }

   if { $b_cols < $accum_latency } {
      set num_iter_per_elem [expr {$a_cols/$vec_sz}] 
      set ideal_running_sum_mult [expr {int(ceil(double($accum_latency)/$b_cols))}]
      set running_sum_mult [expr {min($num_iter_per_elem, $ideal_running_sum_mult)}]
   } else {
      set running_sum_mult 1
   } 
   return $running_sum_mult
}

#
# currently expects acl resource to be available
#
proc call_compiler {working_dir} {
   set data_type           [get_parameter_value FP_FORMAT]
   set multiplication_type [get_parameter_value MULTIPLICATION_TYPE]
   set vec_sz              [get_parameter_value VECTOR_SIZE]
   set fp [open "$working_dir/defines.h" w]
   if { $data_type eq {SINGLE} } {
      puts $fp "#define DATA_TYPE float"
   } elseif { $data_type eq {DOUBLE} } {
      puts $fp "#define DATA_TYPE double"
   } else {
      send_message ERROR "Internal Error: Invalid data format"
   }
   if { ![is_complex] } {
      puts $fp "#define MATRIX_ELEMENT_TYPE DATA_TYPE"
      puts $fp "#define MATRIX_ELEMENT_ZERO ((DATA_TYPE)(0.0))"
      puts $fp "#define MATRIX_ELEMENT_ONE  ((DATA_TYPE)(1.0))"
      puts $fp "#define MAKE_MATRIX_ELEMENT(_REAL_VAL_,_IMAGINARY_VAL_)    ((DATA_TYPE)(_REAL_VAL_))"
      puts $fp "#define MATRIX_ELEMENT_MATCH(_OP1_,_OP2_) (((_OP1_) == (_OP2_)) ? true : false)"
      puts $fp "#define MATRIX_ELEMENT_SUB(_OP1_,_OP2_)   ((_OP1_) - (_OP2_))"
      puts $fp "#define MATRIX_ELEMENT_ABS fabs"
   } else {
      puts $fp "#define COMPLEX_DATA_TYPE"
      if { $multiplication_type eq {COMPLEX_KARATSUBA} } {
         puts $fp "#define KARATSUBA_COMPLEX_MULTIPLY"
      }
      puts $fp "typedef struct {"
      puts $fp "	DATA_TYPE real_part, imaginary_part;"
      puts $fp "} altera_complex_t;"
      puts $fp "#define MATRIX_ELEMENT_TYPE altera_complex_t"
      puts $fp "#define MATRIX_ELEMENT_ZERO ((MATRIX_ELEMENT_TYPE){(DATA_TYPE)0.0, (DATA_TYPE)0.0})"
      puts $fp "#define MATRIX_ELEMENT_ONE  ((MATRIX_ELEMENT_TYPE){(DATA_TYPE)1.0, (DATA_TYPE)0.0})"
      puts $fp "#define MAKE_MATRIX_ELEMENT(_REAL_VAL_,_IMAGINARY_VAL_) \
      		        ((MATRIX_ELEMENT_TYPE){(DATA_TYPE)(_REAL_VAL_), (DATA_TYPE)(_IMAGINARY_VAL_)})"
      puts $fp "#define MATRIX_ELEMENT_MATCH(_OP1_,_OP2_) \
      		        ((((_OP1_).real_part == (_OP2_).real_part) && \
		      	 ((_OP1_).imaginary_part == (_OP2_).imaginary_part)) ? true : false)"
      puts $fp "#define MATRIX_ELEMENT_ABS(_VAL_) ((DATA_TYPE)sqrt((((_VAL_).real_part)*((_VAL_).real_part)) \
		                                              +(((_VAL_).imaginary_part)*((_VAL_).imaginary_part))) )"
      puts $fp "#define MATRIX_ELEMENT_SUB(_OP1_,_OP2_) \
	        	((MATRIX_ELEMENT_TYPE){((_OP1_).real_part - (_OP2_).real_part), \
                        	          ((_OP1_).imaginary_part - (_OP2_).imaginary_part)})"
   }   
   puts $fp "#define A_ROWS [get_parameter_value A_ROWS]"
   puts $fp "#define A_COLS [get_parameter_value A_COLUMNS]"
   puts $fp "#define B_ROWS [get_parameter_value A_COLUMNS]"
   puts $fp "#define B_COLS [get_parameter_value B_COLUMNS]"
   puts $fp "#define C_ROWS [get_parameter_value A_ROWS]"
   puts $fp "#define C_COLS [get_parameter_value B_COLUMNS]"
   puts $fp "#define DOT_VECTOR_SIZE [get_parameter_value VECTOR_SIZE]"
   puts $fp "#define BLOCKS [get_parameter_value NUM_BLOCKS]"
   set arch 1
   puts $fp "#define ARCH $arch"
   puts $fp "#define K_TYPE [get_k_type $arch]"
   puts $fp "#define I_TYPE [get_i_type $arch]"
   puts $fp "#define J_TYPE [get_j_type $arch]"
   puts $fp "#define S_TYPE [get_s_type $arch]"
   puts $fp "#define B_C_TYPE [get_b_c_type $arch]"
   #when case:233068 is fixed we do not need to pad
   set vector_padding [get_dist_to_next_pow2 [get_parameter_value VECTOR_SIZE]]
   if { $vector_padding > 0 } {
      set b_rows_padding [get_dist_to_next_pow2 [get_parameter_value B_ROWS]]
   } else {
      set b_rows_padding 0 
   }
   puts $fp "#define VECTOR_PADDING $vector_padding"
   puts $fp "#define B_ROWS_PADDING $b_rows_padding"
   set blocks_padding [get_dist_to_next_pow2 [get_parameter_value NUM_BLOCKS]]
   if { $blocks_padding > 0 } {
      set a_cols_padding [get_dist_to_next_pow2 [get_parameter_value A_COLUMNS]]
   } else {
      set a_cols_padding 0
   }
   puts $fp "#define BLOCKS_PADDING $blocks_padding"   
   puts $fp "#define A_COLS_PADDING $a_cols_padding"
   puts $fp "#define A_I_TYPE [get_a_i_type $arch $a_cols_padding]"
   puts $fp "#define B_R_TYPE [get_b_r_type $arch $b_rows_padding]"
   puts $fp "#define RUNNING_SUM_MULT [get_running_sum_mult]"
   set a_banks [get_num_banks $arch [ expr {[get_parameter_value NUM_BLOCKS] + $blocks_padding} ] ]
   set b_banks [get_num_banks $arch [ expr {[get_parameter_value VECTOR_SIZE] + $vector_padding} ] ]
   puts $fp "#define A_BANKS $a_banks"
   puts $fp "#define B_BANKS $b_banks"
   puts $fp "#define A_BANKWIDTH [get_a_bankwidth_in_bytes $arch $a_banks]"
   puts $fp "#define B_BANKWIDTH [get_b_bankwidth_in_bytes $arch $b_banks]"
   close $fp

   # MH: the clock option encourages the compiler to produce logic that will get a decent fMax though additional
   # pipelining (with associatiated latency and area cost). In general it should only be set when a better
   # than default fMax is needed. This was originally set only for the case of double-precision on
   # devices other than Arria 10, now covers double & double complex for all devices via a mapping function.

   #defines.h is in working_dir, but we change into working_dir before calling compiler, so -I. is sufficient
   set source_file [file join [get_module_property MODULE_DIRECTORY] [get_hls_component_name].cpp]
   set device_family [get_parameter_value selected_device_family]
   set command_line [get_hls_ip_compile_command [get_hls_component_name] $device_family \
                                                [list .] [list $source_file] \
                                                [use_fpc] [get_hls_clock_freq] [list "--fp-relaxed"]]

   send_message INFO $command_line
   # Expand command_line items into separate arguments, this will not expand the items themselves
   # If we expand the individual itmes, those items cannot have spaces and we cannot support
   # paths with spaces for example
   set prev_dir [pwd]
   cd $working_dir
   if { [ catch { exec {*}$command_line } output ] } {
      #the executable may write information messages to stderr, it's only definitely an error if errorCode is not NONE
      if { $::errorCode ne {NONE} } {
         # if there is an error change directory back before erroring as execution stops at error message
         cd $prev_dir
         send_message ERROR $output
      } else {
         cd $prev_dir
      }
   } else {
      cd $prev_dir
   }

   if { [string match -nocase *error* $output] } {
      if {[regexp -nocase {error\s+starting\s+the\s+process} $output]} {
         send_message ERROR $output
      } elseif {[regexp -nocase {could\s+not\s+acquire\s+opencl\s+sdk\s+license} $output]} {
         send_message ERROR $output
      } else {
         #we most likely have an error, but we can't be sure so just print an info message, an error may follow
         send_message INFO $output
      }
   }
}

# Part-way through 16.1 development, the a++ directory layout changed (affecting standard and Pro in
# different builds). Previously the generated _hw.tcl file is in the <hls component>.prj directory;
# now the file is in the directory <hls_component>.prj/components/altera_fp_matrix_mult_ii.
# Also a top-level file is no longer generated, so the template instantiates the "internal" generated
# entity. 

proc discover_files { file_set working_dir } {
   set hls_generated_files_dir "${working_dir}/[get_hls_component_name].prj"
   if { [catch {open "${hls_generated_files_dir}/altera_fp_matrixmult_internal_hw.tcl"}  fd] } {
      set hls_generated_files_dir ${hls_generated_files_dir}/components/altera_fp_matrixmult
      if { [catch {open "${hls_generated_files_dir}/altera_fp_matrixmult_internal_hw.tcl"}  fd] } {
         send_message ERROR "IP geneneration failed at file discovery, please tell Altera"
         return -code error $fd
      }
   }
   set contents [read -nonewline $fd]
   close $fd

   set lines [split $contents "\n"]

   #skip until we see an add_fileset with the correct file set.
   #then collect all add_fileset_file commands until we see a different add_fileset or end of file
   set in_region 0
   foreach line $lines {
      if { $in_region } {
         if { [string match "add_fileset *" $line] } {
            if { ! [string match $file_set $line] } {
               set in_region 0
            }
         } elseif { [string match "add_fileset_file*" $line] } {
            #we can't run the $line directly because relative paths are relative to the generated _hw.tcl file
            #they need to be either absolute or relative to this hw.tcl file

            #split into words
            set tokens [regexp -inline -all -- {\S+} $line] 
            if { [llength $tokens] != 5 } {
               send_message ERROR "IP geneneration failed at file discovery, please tell Altera"
            }

            #this is needed to clear the list
            set cmd [list]
            #add_fileset_file
            lappend cmd [lindex $tokens 0]
            #output_file
            lappend cmd [lindex $tokens 1]
            #file_type
            lappend cmd [lindex $tokens 2]
            #file_source
            lappend cmd [lindex $tokens 3]

            #path
            #path may contain $::env(ALTERAOCLSDKROOT). So we must run subst
            lset tokens 4 [subst -nobackslashes -nocommands [lindex $tokens 4]]
            #this will leave absolute paths alone
            lappend cmd [file join "$hls_generated_files_dir" [lindex $tokens 4]] 
            
            #add the file to the list
            lappend cmd_list $cmd
         } 
      } else {
         if { [string match "add_fileset*$file_set*" $line] } {
            set in_region 1
         } 
      }
   }
   return $cmd_list
}

proc add_files { cmd_list working_dir output_name file_set } {
   set top_file_name ${output_name}.sv
   set template_path "top.sv.terp"
   set top_level_contents [render_terp $output_name $template_path]

      #execute the commands
      foreach cmd $cmd_list {
         {*}$cmd
      }

      add_fileset_file $top_file_name SYSTEM_VERILOG TEXT $top_level_contents

   if { [get_parameter_value IS_TESTING] } {
      add_fileset_file defines.h OTHER PATH $working_dir/defines.h 
   }
}

proc generate_all {output_name file_set} {
   set tmp_dir [create_temp_file ""]
   file mkdir $tmp_dir

   call_compiler $tmp_dir

   #HLS generated _hw.tcl file does not contain a SIM_VHDL fileset
   #so discover files for SIM_VERILOG instead
   if { $file_set eq {SIM_VHDL} } {
      set proxy_file_set SIM_VERILOG
   } else {
      set proxy_file_set $file_set
   }

   set cmd_list [discover_files $proxy_file_set $tmp_dir]

   add_files $cmd_list $tmp_dir $output_name $file_set
}

proc generate_quartus_synth {output_name} {  
   generate_all $output_name QUARTUS_SYNTH
}
proc generate_sim_verilog {output_name} {  
   generate_all $output_name SIM_VERILOG 
}
proc generate_sim_vhdl {output_name} {  
   generate_all $output_name SIM_VERILOG
}

# parameter_upgrade
# in version 16.1, complex data types are introduced via the MULTIPLICATION_TYPE
#    parameter - default to REAL when upgrading. 

proc parameter_upgrade {ip_core_type version old_param_value_pairs} {
   if { $version < "16.1" } {
      set_parameter_value MULTIPLICATION_TYPE "REAL"
      set_parameter_value OPTIMIZATION string "BALANCED"

      # preserve other parameters
      foreach {name value} $old_param_value_pairs {
         set_parameter_value $name $value
      }
   } else {
      # compatible version upgrade, no change
      foreach {name value} $old_param_value_pairs {
         set_parameter_value $name $value
      }
   }
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_altfp_mfug.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
