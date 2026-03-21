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


proc validateTOP_bch {} {
  set bch_type [get_parameter_value BCH]
  if {$bch_type eq "Decoder"} {
    validateTOP_dec
  } else {
    validateTOP_enc
  }
}

proc validateTOP_dec {} {
  set N_BITS [ get_parameter_value N_BITS ]
  set M_BITS [ get_parameter_value M_BITS ]
  set T_BITS [ get_parameter_value T_BITS ]
  set irrpol_vec [list 3 7 11 19 37 67 137 285 529 1033 2053 4179 8219 17475 32771 69643]
  get_genpoly_degree_list degree_listVar t_listVar $M_BITS

  # validate the number of bits per symbol
  set_parameter_property M_BITS ALLOWED_RANGES {6 7 8 9 10 11 12 13 14}

  # update primitive polynomial
  set_parameter_value IRRPOL [lindex $irrpol_vec $M_BITS-1]

  # validate t
  # note: current t is capped between 16 and 127
  if {[lsearch $t_listVar 127]>0} {
    set t_listVar [lrange $t_listVar 0 [lsearch $t_listVar 127]]
    send_message INFO "The parameter t in the current version of BCH decoder is capped between \[8,128). Some options are removed from the choise list."
  }
  if {$T_BITS<8} {
    send_message ERROR "The parameter t must be between \[8,128). Currently t=$T_BITS."
  }
  set_parameter_property T_BITS ALLOWED_RANGES $t_listVar
  set_parameter_value PARITY_BITS $degree_listVar($T_BITS)

  # validate the codeword length
  set min_default_N [expr $degree_listVar($T_BITS)+1 ] 
  set max_default_N [expr int(pow(2,$M_BITS))-1] 
  set_parameter_property N_BITS ALLOWED_RANGES [list "$min_default_N : $max_default_N"]

  # update k
  set_parameter_value K_BITS [expr $N_BITS-$degree_listVar($T_BITS)]
  
  # validate parallel input width: 
  # (ceil(n/d)*3-2)/6 >= 2 -- required by polysys for generating mb_system
  set tmp_ratio [expr $N_BITS*3/14]
  # ceil(n/d) > 2*log2(2*t) -- required by syndromes module; each layer of the sqr procedure requires 2 clock cycles
  set num_extra_layer [expr int(log(2*$T_BITS)/log(2))]
  # send_message INFO "number of extra layers for squaring algorithm in sydromes: $num_extra_layer"
  set tmp_ratio_syn [expr $N_BITS/(2*$num_extra_layer)]
  if {$N_BITS - $tmp_ratio_syn*(2*$num_extra_layer) == 0} {
    set tmp_ratio_syn [expr $tmp_ratio_syn-1]
  }
  if {$tmp_ratio_syn < $tmp_ratio} {
    set tmp_ratio $tmp_ratio_syn
  }
  set_parameter_property DATA_WIDTH ALLOWED_RANGES [list 1:$tmp_ratio]
}

proc validateTOP_enc {} {
  set N_BITS [ get_parameter_value N_BITS ]
  set M_BITS [ get_parameter_value M_BITS ]
  set T_BITS [ get_parameter_value T_BITS ]
  set irrpol_vec [list 3 7 11 19 37 67 137 285 529 1033 2053 4179 8219 17475 32771 69643]
  get_genpoly_degree_list degree_listVar t_listVar $M_BITS

  # validate the number of bits per symbol
  set_parameter_property M_BITS ALLOWED_RANGES {3 4 5 6 7 8 9 10 11 12 13 14}

  # update primitive polynomial
  set_parameter_value IRRPOL [lindex $irrpol_vec $M_BITS-1]

  set_parameter_property T_BITS ALLOWED_RANGES $t_listVar
  set_parameter_value PARITY_BITS $degree_listVar($T_BITS)

  # validate the codeword length
  set min_default_N [expr $degree_listVar($T_BITS)+1 ] 
  set max_default_N [expr int(pow(2,$M_BITS))-1] 
  set_parameter_property N_BITS ALLOWED_RANGES [list "$min_default_N : $max_default_N"]

  # update k
  set_parameter_value K_BITS [expr $N_BITS-$degree_listVar($T_BITS)]
  
  # validate parallel input width
  set K_BITS [expr $N_BITS-$degree_listVar($T_BITS)]
  if {$degree_listVar($T_BITS) < $K_BITS} {
    set_parameter_property DATA_WIDTH ALLOWED_RANGES [list 1:$degree_listVar($T_BITS)]
  } else {
    set_parameter_property DATA_WIDTH ALLOWED_RANGES [list 1:[expr $K_BITS-1]]
  }
}


proc render_terp {output_name sim template_path} {
    
   set template_fd [open $template_path]
   set template [read $template_fd]
   close $template_fd
   
   foreach param [lsort [get_parameters]] {
      set params($param) [get_parameter_value $param]
   }
   set params(output_name) $output_name
   
   set contents [altera_terp $template params]
  
   return $contents
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

proc abs_path {file_list} {
     set abs_path_file_list [list ]
     foreach thatfile $file_list {
        lappend abs_path_file_list [file join [file rootname [file dirname $thatfile]] [file tail $thatfile]]
     }
     return $abs_path_file_list
}

proc get_common_files_bch_dec {} {
    # auto generate files according to parameters
    set gen_list [HDL_autogenerated_files_for_decoder]
    set gen_list_encrypt [list ]
    foreach thatfile $gen_list {
       lappend gen_list_encrypt  [list  $thatfile 0 ]
    }
    set file_list {bch_dec/src/bchp_functions.vhd
                   bch_dec/src/rsp_gf_add.vhd
                   bch_dec/src/rsp_gf_sqrff.vhd
                   bch_dec/src/rsp_gf_mr.vhd
                   bch_dec/src/rsp_gf_mul.vhd
                   bch_dec/src/rsp_gf_pp.vhd
                   bch_dec/src/bchp_package.vhd
                   bch_dec/src/bchp_syndromes/bchp_syndromes_sqr.vhd
                   bch_dec/src/bchp_syndromes/bchp_syndrome.vhd
                   bch_dec/src/bchp_mb/bchp_rom.vhd
                   bch_dec/src/bchp_mb/bchp_mbopt_pe6.vhd
                   bch_dec/src/bchp_mb/bchp_mb_pex.vhd
                   bch_dec/src/bchp_mb/rsp_unary.vhd
                   bch_dec/src/bchp_search/bchp_search.vhd
                   bch_dec/src/bchp_search/bchp_shift_search.vhd
                   bch_dec/src/bchp_search/bchp_shift_searches.vhd
                   bch_dec/src/bchp_del.vhd
                   bch_dec/src/bchp_decoder_core.vhd
                   bch_dec/src/bchp_decoder.vhd}
    set file_list_encrypt [list ]
    foreach thatfile $file_list {
       lappend file_list_encrypt [list  $thatfile 1 ]
    }

    set file_list_encrypt [linsert $file_list_encrypt 1 [lindex $gen_list_encrypt 4]]
    set file_list_encrypt [linsert $file_list_encrypt 2 [lindex $gen_list_encrypt 2]]
    set file_list_encrypt [linsert $file_list_encrypt 12 [lindex $gen_list_encrypt 1]]
    set file_list_encrypt [linsert $file_list_encrypt 13 [lindex $gen_list_encrypt 0]]
    set file_list_encrypt [linsert $file_list_encrypt 21 [lindex $gen_list_encrypt 3]]
    #send_message info "All support files: $file_list_encrypt"

    #set file_list [abs_path $file_list]
      
    return $file_list_encrypt
}

proc get_common_files_bch_enc {} {
    # auto generate files according to parameters
    set gen_list [HDL_autogenerated_files_for_encoder]
    set gen_list_encrypt [list ]
    foreach thatfile $gen_list {
       lappend gen_list_encrypt  [list  $thatfile 0 ]
    }
    set file_list {bch_enc/src/bch_encoder_core.vhd
                   bch_enc/src/bch_encoder.vhd}
    set file_list_encrypt [list ]
    foreach thatfile $file_list {
       lappend file_list_encrypt  [list  $thatfile 1 ]
    }
    set gen_list_encrypt [linsert $gen_list_encrypt 1 [lindex $file_list_encrypt 0]]
    set file_list_encrypt [linsert $gen_list_encrypt 2 [lindex $file_list_encrypt 1]]
    #send_message info "All support files: $file_list"

    #set file_list [abs_path $file_list]
      
    return $file_list_encrypt
}



# -----------------------------------------------------------------
# Generate the parity_array, in_array, and out_array, for the parallel IIR
# -----------------------------------------------------------------
proc HDL_autogenerated_files_for_encoder {} {
   
   # STEP 0: retrieve user input parameters
   set N_BITS [get_parameter_value N_BITS]
   set K_BITS [get_parameter_value K_BITS]
   set M_BITS [get_parameter_value M_BITS]
   set T_BITS [get_parameter_value T_BITS]
   set DATA_WIDTH [get_parameter_value DATA_WIDTH]



   # STEP 1: pick a primitive polynomial
   set irrpol [get_parameter_value IRRPOL]

   # STEP 2: generate GF(2**m) with chosen primitive polynomial
   set GF_field [GF_field_generation $irrpol $M_BITS]
   #-------------------for {set ind 0} {$ind < 2**$M_BITS} {incr ind} {
      #-------------------send_message info "ind=$ind poly=[lindex $GF_field $ind]"
   #-------------------}

   # STEP 3: for a requested bit correction ability t, add in roots from GF(2**M_BITS) to form a generator polynomial
   set poly_array [generate_BCH_poly $GF_field $T_BITS $M_BITS]
   set parity_bits [expr [llength $poly_array]-1]

   # STEP 4: using the generator polynomial, create the parity_array, in_array, and out_array
   set para_IIR [generate_para_IIR $DATA_WIDTH $poly_array]
   set parity_array [lindex $para_IIR 0]
   set in_array [lindex $para_IIR 1]
   set out_array [lindex $para_IIR 2]
   #-------------------send_message info para_IIR=$para_IIR
   #-------------------send_message info parity_array=$parity_array
   #-------------------send_message info in_array=$in_array
   #-------------------send_message info out_array=$out_array

   
   # STEP 5: write the IIR structure configuration to vhd package file

   # Record the current directory before branching into the temporary file directory
   set cwd [pwd]
   # Create a null file just to get the temporary file directory path
   set temp_dir  [create_temp_file ""]
   # Make a directory there
   file mkdir $temp_dir
   # Branching into the temporary file directory to generate the configuration file
   cd $temp_dir


   send_message info "----Writing bch_enc_package.vhd"
   set file_name "$temp_dir/bch_enc_package.vhd"
   lappend list_of_generated_files $file_name
   set f_handle [open $file_name w]
   set text ""

   append text "library ieee;\n"
   append text "use ieee.std_logic_1164.all;\n\n"

   append text "package bch_enc_package is\n\n"

   append text 	"constant CODE_LENGTH_N    : natural := $N_BITS;\n"
   append text 	"constant MESSAGE_LENGTH_K : natural := $K_BITS;\n"
   append text 	"constant PARITY_LENGTH    : natural := $parity_bits;\n"
   append text	"constant DATA_WIDTH       : natural := $DATA_WIDTH;\n\n"

   append text	"constant POLY_COEF : std_logic_vector(PARITY_LENGTH downto 0) := \""
   for {set k 0} {$k<[llength $poly_array]} {incr k} {
      append text "[lindex $poly_array $k]"
   }
   append text  "\";\n"

   append text	"type lfsr_coef_type is array (0 to DATA_WIDTH, PARITY_LENGTH downto 1) of std_logic;\n"
   append text	"type lfsr_input_coef_type is array (0 to DATA_WIDTH, DATA_WIDTH - 1 downto 0) of std_logic;\n\n"

   append text	"constant LFSR_COEF : lfsr_coef_type := (\n"
   for {set k 0} {$k<$DATA_WIDTH} {incr k} {
      append text "                                        \""
      for {set i 0} {$i<$parity_bits} {incr i} {
         append text  "[lindex $parity_array $k $i]"
      }
      append text "\",\n"
   }
   append text "                                        \""
   for {set i 0} {$i<$parity_bits} {incr i} {
      append text  "[lindex $parity_array [expr $DATA_WIDTH-1] $i]"
   }
   append text  "\");\n\n"

   append text	"constant LFSR_INPUT_COEF : lfsr_input_coef_type := (\n"
   for {set k 0} {$k<$DATA_WIDTH} {incr k} {
      append text "                                        \""
      for {set i 0} {$i<$DATA_WIDTH} {incr i} {
         append text  "[lindex $in_array $k $i]"
      }
      append text "\",\n"
   }
   append text "                                        \""
   for {set i 0} {$i<$DATA_WIDTH} {incr i} {
      append text  "[lindex $in_array [expr $DATA_WIDTH-1] $i]"
   }
   append text  "\");\n\n"

   append text	"constant LFSR_OUTPUT_COEF : lfsr_input_coef_type := (\n"
   for {set k 0} {$k<$DATA_WIDTH} {incr k} {
      append text "                                        \""
      for {set i 0} {$i<$DATA_WIDTH} {incr i} {
         append text  "[lindex $out_array $k $i]"
      }
      append text "\",\n"
   }
   append text "                                        \""
   for {set i 0} {$i<$DATA_WIDTH} {incr i} {
      append text  "[lindex $out_array [expr $DATA_WIDTH-1] $i]"
   }
   append text  "\");\n\n"

   append text "FUNCTION log2_function (constant in_data : positive) return natural;\n\n"

   append text  "end bch_enc_package;\n\n"


   append text  "package body bch_enc_package is\n\n"

   append text  "  -- log2 function\n" 
   append text  "  FUNCTION log2_function\n"
   append text  "  (constant in_data : positive)\n"
   append text  "  return natural IS\n"
   append text  "    variable temp    : integer := in_data;\n"
   append text  "    variable ret_val : integer := 0;\n"
   append text  "  begin \n\n"
                        
   append text  "    while temp > 1 loop\n"
   append text  "      ret_val := ret_val + 1;\n"
   append text  "      temp    := temp / 2;\n" 
   append text  "    end loop;\n\n"

   append text  "    return ret_val;\n"
   append text  "  END log2_function;\n\n"
      
   append text  "end bch_enc_package;"



   puts $f_handle $text
   close $f_handle

   cd $cwd

   return $list_of_generated_files
}




# -----------------------------------------------------------------
# Generate RTL codes and memory contents (bchp_mb_system.vhd, bchp_auto_package, bchp_invmem.hex, bchp_roots.vhd)
# -----------------------------------------------------------------
proc HDL_autogenerated_files_for_decoder {} {
   
   # STEP 0: retrieve user input parameters
   set N_BITS [get_parameter_value N_BITS]
   set K_BITS [get_parameter_value K_BITS]
   set M_BITS [get_parameter_value M_BITS]
   set T_BITS [get_parameter_value T_BITS]
   set DATA_WIDTH [get_parameter_value DATA_WIDTH]
   set round_clocks 6

   set IRRPOL [get_parameter_value IRRPOL]

  
   # STEP 1: generates bchp_mb_system.vhd and bchp_auto_package.vhd
   set optimize 1 
   set code_clocks [expr $N_BITS/$DATA_WIDTH]
   if {[expr $N_BITS-$code_clocks*$DATA_WIDTH] > 0} {
     set code_clocks [expr $code_clocks+1]
   }
   set polys_per_pe [expr ($code_clocks*3-2)/$round_clocks]
   #set temp [expr $code_clocks/$round_clocks - 1]
   #if {[expr $temp & 1] == 1} {
      #set polys_per_pe [expr $temp - 1]
   #} else {
      #set polys_per_pe $temp
   #}

   set full_pes [expr $T_BITS/$polys_per_pe]
   set last_polys [expr $T_BITS - $full_pes*$polys_per_pe]
   if {$last_polys > 0} {
      set pes [expr $full_pes + 1]
   } else {
      set pes $full_pes
      set last_polys $polys_per_pe
   }
   if {$full_pes == 0} {
      set polys_per_pe $T_BITS
   }

   send_message info "code_clocks = $code_clocks, polys_per_pe = $polys_per_pe, full_pes = $full_pes, pes = $pes clocks_per_last_pe = $last_polys"

   # Generates files
   lappend list_of_generated_files {*}[polysys_generate $code_clocks $polys_per_pe $pes $full_pes $last_polys $round_clocks $T_BITS $optimize]


   # STEP 2: generate bchp_roots.vhd and bchp_invmem.hex
   lappend list_of_generated_files {*}[gfm_generate $M_BITS $IRRPOL]

   # STEP 3: generate bchp_parameters.vhd
   lappend list_of_generated_files {*}[parameter_generate $N_BITS $K_BITS $M_BITS $T_BITS $IRRPOL $DATA_WIDTH]
   
   
   send_message info "files generated: $list_of_generated_files"

   return $list_of_generated_files
}




# -----------------------------------------------------------------
# generating test data for BCH encoder example design
# -----------------------------------------------------------------
proc generate_test_data_bch_enc {test_data_dir} {

   set num_test 20

   # STEP 1: pick a primitive polynomial
   set N_BITS [get_parameter_value N_BITS]
   set K_BITS [get_parameter_value K_BITS]
   set M_BITS [get_parameter_value M_BITS]
   set T_BITS [get_parameter_value T_BITS]
   set irrpol [get_parameter_value IRRPOL]
   set PARITY_BITS [expr $N_BITS-$K_BITS]

   # STEP 2: generate GF(2**m) with chosen primitive polynomial
   set GF_field [GF_field_generation $irrpol $M_BITS]

   # STEP 3: for a requested bit correction ability t, add in roots from GF(2**M_BITS) to form a generator polynomial
   set poly_array [generate_BCH_poly $GF_field $T_BITS $M_BITS]

   # STEP 4: randomly generate several message words and encoding using tcl procedure
   set cwd [pwd]
   file mkdir $test_data_dir
   cd $test_data_dir 

   set bchmsg_mx "bchmsg_mx.txt"
   set bchmsg_rx "bchmsg_rx.txt"
   set mx_handle [open $bchmsg_mx w+]
   set rx_handle [open $bchmsg_rx w+]

   # generate a set of test vectors
   for {set test_ind 0} {$test_ind<$num_test} {incr test_ind} {
     set temp_mx [list ]
     for {set n 0} {$n<$K_BITS} {incr n} {
       lappend temp_mx 0
     }  
     set max_possible_ones [expr {int(rand()*$K_BITS)+1}]
     for {set err_ind 0} {$err_ind<$max_possible_ones} {incr err_ind} {
       set rand_ind [expr {int(rand()*$K_BITS)}]
       lset temp_mx $rand_ind 1
     } 
     # send_message INFO "Test message $test_ind is: $temp_mx"
     
  
     # encode using tcl proc
     set temp_rx [bch_encoder_proc $temp_mx $PARITY_BITS $N_BITS $K_BITS $poly_array]


     # send_message INFO "Encoded to: $temp_rx"
     

     set text_mx ""
     set text_rx ""
     for {set n 0} {$n<$N_BITS} {incr n} {
       append text_mx "[lindex $temp_mx $n]"
       append text_rx "[lindex $temp_rx $n]"
     } 
     puts $mx_handle $text_mx
     puts $rx_handle $text_rx
     
     send_message INFO "Test data $test_ind generated"

   }

   close $mx_handle
   close $rx_handle

   add_fileset_file [file join "test_data" $bchmsg_mx] OTHER PATH "[file join $test_data_dir $bchmsg_mx]"
   add_fileset_file [file join "test_data" $bchmsg_rx] OTHER PATH "[file join $test_data_dir $bchmsg_rx]"

   cd $cwd

}



# -----------------------------------------------------
# Generate test data for BCH decoder example design
# -----------------------------------------------------
proc generate_test_data_bch_dec {test_data_dir} {

   set num_test 20

   # STEP 1: pick a primitive polynomial
   set N_BITS [get_parameter_value N_BITS]
   set K_BITS [get_parameter_value K_BITS]
   set M_BITS [get_parameter_value M_BITS]
   set T_BITS [get_parameter_value T_BITS]
   set irrpol [get_parameter_value IRRPOL]
   set PARITY_BITS [expr $N_BITS-$K_BITS]

   # STEP 2: generate GF(2**m) with chosen primitive polynomial
   set GF_field [GF_field_generation $irrpol $M_BITS]

   # STEP 3: for a requested bit correction ability t, add in roots from GF(2**M_BITS) to form a generator polynomial
   set poly_array [generate_BCH_poly $GF_field $T_BITS $M_BITS]

   # STEP 4: randomly generate several message words and encoding using tcl procedure
   set cwd [pwd]
   file mkdir $test_data_dir
   cd $test_data_dir 

   set bchmsg_rx "bchmsg_rx.txt"
   set bchmsg_tx "bchmsg_tx.txt"
   set rx_handle [open $bchmsg_rx w+]
   set tx_handle [open $bchmsg_tx w+]

   # generate a set of test vectors
   for {set test_ind 0} {$test_ind<$num_test} {incr test_ind} {
     set temp_mx [list ]
     for {set n 0} {$n<$K_BITS} {incr n} {
       lappend temp_mx 0
     }  
     set max_possible_ones [expr {int(rand()*$K_BITS)+1}]
     for {set err_ind 0} {$err_ind<$max_possible_ones} {incr err_ind} {
       set rand_ind [expr {int(rand()*$K_BITS)}]
       lset temp_mx $rand_ind 1
     } 
     
  
     # encode using tcl proc
     set temp_tx [bch_encoder_proc $temp_mx $PARITY_BITS $N_BITS $K_BITS $poly_array]
     
     # add in random corruption
     set temp_rx $temp_tx
     set max_possible_err [expr {int(rand()*$T_BITS)+1}]
     for {set err_ind 0} {$err_ind<$max_possible_err} {incr err_ind} {
       set rand_ind [expr {int(rand()*$N_BITS)}]
       lset temp_rx $rand_ind [expr [lindex $temp_tx $rand_ind]^1]
     } 

     set text_rx ""
     set text_tx ""
     for {set n 0} {$n<$N_BITS} {incr n} {
       append text_rx "[lindex $temp_rx $n]"
       append text_tx "[lindex $temp_tx $n]"
     }
     puts $rx_handle $text_rx
     puts $tx_handle $text_tx
     
     #send_message INFO "Test data generated"

   }
   send_message INFO "Test data generated"
   close $rx_handle
   close $tx_handle

   add_fileset_file [file join "test_data" $bchmsg_rx] OTHER PATH "[file join $test_data_dir $bchmsg_rx]"
   add_fileset_file [file join "test_data" $bchmsg_tx] OTHER PATH "[file join $test_data_dir $bchmsg_tx]"

   cd $cwd
}






proc generate_test_data_bch_dec_allzeros {test_data_dir} {

   set num_test 20
   set N_BITS [ get_parameter_value N_BITS]
   set T_BITS [ get_parameter_value T_BITS]

   set cwd [pwd]
   file mkdir $test_data_dir
   cd $test_data_dir

   set bchmsg_tx "bchmsg_tx.txt"
   set bchmsg_rx "bchmsg_rx.txt"
   set tx_handle [open $bchmsg_tx w+]
   set rx_handle [open $bchmsg_rx w+]

   # generate a set of test vectors
   for {set test_ind 0} {$test_ind<$num_test} {incr test_ind} {
     set temp_tx [list ]
     set temp_rx [list ]
     for {set n 0} {$n<$N_BITS} {incr n} {
       lappend temp_tx 0
       lappend temp_rx 0
     }  
     set max_possible_err [expr {int(rand()*$T_BITS)+1}]
     for {set err_ind 0} {$err_ind<$max_possible_err} {incr err_ind} {
       set rand_ind [expr {int(rand()*$N_BITS)}]
       lset temp_rx $rand_ind 1
     } 
     
     #set counter 0
     #for {set n 0} {$n<$N_BITS} {incr n} {
     #  set counter [expr $counter+[lindex $temp_rx $n]]
     #}  
     #send_message INFO "A total of $counter errors, maximum $max_possible_err possible errors"

     set text_tx ""
     set text_rx ""
     for {set n 0} {$n<$N_BITS} {incr n} {
       append text_tx "[lindex $temp_tx $n]"
       append text_rx "[lindex $temp_rx $n]"
     } 
     puts $tx_handle $text_tx
     puts $rx_handle $text_rx
     
   }

   close $tx_handle
   close $rx_handle

   add_fileset_file [file join "test_data" $bchmsg_tx] OTHER PATH "[file join $test_data_dir $bchmsg_tx]"
   add_fileset_file [file join "test_data" $bchmsg_rx] OTHER PATH "[file join $test_data_dir $bchmsg_rx]"

   cd $cwd
}






