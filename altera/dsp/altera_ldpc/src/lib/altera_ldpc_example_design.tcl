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



#Example Fileset Generates: (in order)
#                             Matlab functions for modelling the FIR
#                             A SystemVerilog Test program
#                             Test stimuli
#                             A parameterized FIR simulation model
#                             SystemVerilog Bus Functional models to drive the simulation
#                             Simulation scripts for the simulators using ip-make-simscript

proc example_fileset {output_name} {

    set cwd [pwd]

    # Generating C models
    #send_message INFO "Generating C Models"
    #add_fileset_file "c_model/testbench.c" OTHER PATH "../src/models/c_model/testbench.c"
    #add_fileset_file "c_model/parity.c" OTHER PATH "../src/models/c_model/parity.c"
    #add_fileset_file "c_model/decode_ldpc_docsis.c" OTHER PATH "../src/models/c_model/decode_ldpc_docsis.c"
    
    
    #Generate MATLAB Scripts
    send_message INFO "Generating MATLAB Models"
    generate_matlab_files
    # set template_path "src/matlab/matlab_tb.template"
    # set terp_contents [render_terp $output_name 0 $template_path ]
    # set filename "${output_name}_tb.m" 
    # add_fileset_file "$filename" OTHER TEXT $terp_contents

    # set template_path "src/matlab/matlab_model.template"
    # set terp_contents [render_terp $output_name 0 $template_path ]
    # set filename "${output_name}_model.m" 
    # add_fileset_file "$filename" OTHER TEXT $terp_contents
    # send_message INFO "Generating Test Program"

    #Generate Test Program
    send_message INFO "Generating Testbench Data"
    set source_files_path src
    set template_path "../src/testbench/ldpc_testbench.sv.terp"
    set terp_contents [render_terp $output_name 0 $template_path ]
    set test_program_file "${output_name}_test_program.sv" 
    add_fileset_file "[file join $source_files_path $test_program_file]" [filetype $test_program_file] TEXT $terp_contents
    

    #Generate Test Data
    send_message INFO "Generating Test Data"
    set test_data_dir [create_temp_file ""]
    generate_test_data $test_data_dir $output_name 


    send_message INFO "Generating Testbench System"
    #Generate Testbenching System
    set family "[get_parameter_value selected_device_family]"
    set ldpc_example_name "core" 
    set qsys_system "${output_name}.qsys"

    #Generate the testbench files
    set temp_dir  [create_temp_file ""] 
    file mkdir $temp_dir
    cd $temp_dir

    set script_name "$temp_dir/${output_name}.tcl"
    set sim_script_name "$temp_dir/${output_name}_tmp.spd"
    set sim_script [open $sim_script_name w+]

    #----------------------------------------------------------------------------------------------------------------------------
    set f_handle [open $script_name w+]

    puts $f_handle    "package require -exact qsys 14.0"
    puts $f_handle    "set_project_property DEVICE_FAMILY \"${family}\""
    puts $f_handle    "add_instance ${ldpc_example_name} altera_ldpc"
    foreach param [lsort [get_parameters]] {
        if {[get_parameter_property $param DERIVED] == 0} {
            #Screen for design environment, only QSYS flow is supported, because Native steps all over the BFMs by creating conduits
            if { $param ne "design_env" } { 
                puts $f_handle "set_instance_parameter_value $ldpc_example_name $param \"[get_parameter_value $param]\""
            } else {
                puts $f_handle "set_instance_parameter_value $ldpc_example_name $param \"QSYS\""
            }
        }
    }
    puts $f_handle    "add_interface ${ldpc_example_name}_rst reset sink"
    puts $f_handle    "set_interface_property ${ldpc_example_name}_rst EXPORT_OF ${ldpc_example_name}.reset"
    puts $f_handle    "add_interface ${ldpc_example_name}_clk clock sink"
    puts $f_handle    "set_interface_property ${ldpc_example_name}_clk EXPORT_OF ${ldpc_example_name}.clk"
    puts $f_handle    "add_interface ${ldpc_example_name}_sink avalon_sink sink"
    puts $f_handle    "set_interface_property ${ldpc_example_name}_sink EXPORT_OF ${ldpc_example_name}.out"
    puts $f_handle    "add_interface ${ldpc_example_name}_source avalon_source source"
    puts $f_handle    "set_interface_property ${ldpc_example_name}_source EXPORT_OF ${ldpc_example_name}.in"
    puts $f_handle    "save_system ${qsys_system}"

    close $f_handle
    #----------------------------------------------------------------------------------------------------------------------------
   
    set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-script"] 
    set cmd [list  $program --script=$script_name ]
    set status [catch {exec {*}$cmd} err]

    #now use this qsys SYSTEM
    set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-generate"] 
    set cmd "$program $qsys_system --testbench=STANDARD --testbench-simulation=VERILOG";
    set status [catch {exec {*}$cmd} err]

    if {$status != 1 } {
        send_message ERROR "LDPC Example Testbench Generation Fail"
    } else {
        send_message NOTE "LDPC Example Testbench Generation Complete"
    }        
   

    set simulator_list { \
             {mentor   1   modelsim} \
             {aldec    1    riviera} \
             {synopsys 1 vcs} \
             {cadence  1  ncsim} \
           }

    set test_file_dir [file join "${temp_dir}"]
    set all_files [get_all_file_abs $test_file_dir]

    set all_tails {}
    foreach module [lsearch -inline -all -glob $all_files *] {

        if { [regexp  {.*(\.hex$)|(\.mif$)|(\.v$)|(\.vhd$)|(\.vo$)|(\.vho$)} [file tail $module] ] == 1 } {
            if { [lsearch $all_tails [file tail $module] ] == -1} {
                lappend all_tails [file tail $module]
                set all_files [lreplace $all_files [lsearch $all_files $module] [lsearch $all_files $module] ]
                set ext [filetype submodule]
                add_fileset_file [file join "src" [file tail $module]] $ext PATH $module
            }
        }


        if { [regexp  {.*(\.sv$)} [file tail $module] ] == 1 } {
            if { [lsearch $all_tails [file tail $module] ] == -1} {

                set all_files [lreplace $all_files [lsearch $all_files $module] [lsearch $all_files $module] ]

                if {[string match *altera_ldpc*  [file tail $module] ] == 1} {
                    set not_encrypted_file 1
                    foreach simulator $simulator_list {
                        set sim [lindex $simulator 0]
                        if {[string match *$sim*  $module ] == 1} {
                            set supported [lindex $simulator 1]
                            if {$supported} {
                                add_fileset_file [file join "src/$sim" [file tail $module]] SYSTEM_VERILOG_ENCRYPT PATH $module [string toupper $sim]_SPECIFIC
                            } else {
                                add_fileset_file [file join "src" [file tail $module]] SYSTEM_VERILOG PATH $module
                            }
                            set not_encrypted_file 0
                        }
                    }
                    # DEBUG
                    if {$not_encrypted_file} {
                        add_fileset_file [file join "src" [file tail $module]] SYSTEM_VERILOG PATH $module
                    }
                } else {
                    lappend all_tails [file tail $module]
                    add_fileset_file [file join "src" [file tail $module]] SYSTEM_VERILOG PATH $module
                }

            }

        }
    }
    set all_files      [get_all_file_abs $test_file_dir]
    set file_tails {} 
    foreach full_name $all_files {
        lappend file_tails [file tail $full_name]   
    } 
    set all_files      [lsort -unique $file_tails]
    set packages {}
    set top_files {}
    set generic_files {}
    set memory_files {}
    foreach cur_file $all_files {
        if { [regexp  {.*(tb\.)(v|(sv)|(vhd))} $cur_file ] == 1 } {
            lappend top_files $cur_file
        } elseif { [regexp  {.*((\.vo)|(\.vho)|(pkg\.v)|(pkg\.sv)|(pkg\.vhd))} $cur_file] == 1 } {
            lappend packages $cur_file
        } elseif { [regexp  {.*\.(v|(sv)|(vhd))} $cur_file] == 1 } {
            if {[regexp  {.*((_inst\.)|(_bb\.))(v|(sv)|(vhd))} $cur_file ] == 0} {
                lappend generic_files $cur_file
            }
        } elseif { [regexp  {.*\.((hex)|(mif))}  $cur_file] == 1 } {
            lappend memory_files $cur_file
        }
    }
    foreach cur_file $all_files {
        if { [regexp  {.*((mat\.sv))} $cur_file] == 1 } {
            lappend packages $cur_file
        }
    }


   send_message INFO "Generating Simulation Scripts"

  # #set the spd
   puts $sim_script "<simPackage>"
   set library "work"
   foreach file $packages {
      if { [lsearch $all_files $file] != -1 } {
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         if { [string match -nocase SYSTEM_VERILOG $file_type]==1 && [string match *altera_ldpc*  [file tail $file] ]==1} { 
                    set clear_file_already_added 0
                    foreach simulator $simulator_list {
                        set sim [lindex $simulator 0]
                        set supported [lindex $simulator 1]
                        set tool [lindex $simulator 2]
                        if {$supported} {
                            set file_name [file join $source_files_path $sim [file tail $file]]
                            puts $sim_script [convert_to_spd_xml  $file_name SYSTEM_VERILOG_ENCRYPT $library $tool]
                        } else {
                            if {!$clear_file_already_added} {
                                set file_name [file join $source_files_path [file tail $file]]
                                puts $sim_script [convert_to_spd_xml  $file_name SYSTEM_VERILOG $library ""]
                                set clear_file_already_added 1
                            }
                        }
                    }
         } else { 
             set file_name [file join $source_files_path [file tail $file]]
             puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]
         }
      }
   }
   foreach file $generic_files {
      if { [lsearch $all_files $file] != -1 } {
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         if { [string match -nocase SYSTEM_VERILOG $file_type]==1 && [string match *altera_ldpc*  [file tail $file]]==1} { 
                    set clear_file_already_added 0
                    foreach simulator $simulator_list {
                        set sim [lindex $simulator 0]
                        set supported [lindex $simulator 1]
                        set tool [lindex $simulator 2]
                        if {$supported} {
                            set file_name [file join $source_files_path $sim [file tail $file]]
                            puts $sim_script [convert_to_spd_xml  $file_name SYSTEM_VERILOG_ENCRYPT $library $tool]
                        } else {
                            if {!$clear_file_already_added} {
                                set file_name [file join $source_files_path [file tail $file]]
                                puts $sim_script [convert_to_spd_xml  $file_name SYSTEM_VERILOG $library ""]
                                set clear_file_already_added 1
                            }
                        }
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
   set input_files [glob -directory $test_data_dir  -tails *{.txt}]
   foreach file $input_files {
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

proc convert_to_spd_xml { file_name type library  simulator} {
   if { $type == "SYSTEM_VERILOG_ENCRYPT" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\"   simulator=\"${simulator}\"/>"
   } elseif { $type == "SYSTEM_VERILOG" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\" />"
   } elseif { $type == "Memory" } {
       return "<file path=\"$file_name\" type=\"MEM_INIT\" initParamName=\"[file rootname $file_name ]\" memoryPath=\"test_program\" />"
   } else {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\"/>"
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

proc render_terp {output_name sim template_path} {
    
   set template_fd [open $template_path]
   set template [read $template_fd]
   close $template_fd
   

   foreach param [lsort [get_parameters]] {
      set params($param) [get_parameter_value $param]
   }
   # set params(module_name) [get_module_name] 
   set params(output_name) $output_name
   # set params(device_family) [get_parameter_value selected_device_family] 
   set params(MODULE) [get_parameter_value MODULE] 
   set params(N) [get_parameter_value N] 
   set params(SOFTBITS) [get_parameter_value SOFTBITS] 
   set params(BITSPERSYMBOL) [get_parameter_value BITSPERSYMBOL] 
   set params(LLRPERSYMBOL) [get_parameter_value LLRPERSYMBOL]  
   
    if {[string equal [get_parameter_value MODULE]  "Encoder"]} {
        set isencoder 1
    } else {
        set isencoder 0
    }
            
    if {[string equal [get_parameter_value LDPC_TYPE]  "DVB"]} {
        set matrix_number       [ get_DVB_matrixnumber [get_parameter_value N] [get_parameter_value RATE]]
        get_DVB_parameters nbcheckgroup nbvargroup n $matrix_number
    }
    if {[string equal [get_parameter_value LDPC_TYPE] "NASA"]} {
        get_NASA_parameters nbcheckgroup nbvargroup n [ get_parameter_value N ] $isencoder
    }
    if {[string equal [get_parameter_value LDPC_TYPE] "WiMedia"]} {
        get_Wimedia_parameters nbcheckgroup nbvargroup n [ get_parameter_value N ] [get_parameter_value RATE] $isencoder
    }
    if {[string equal [get_parameter_value LDPC_TYPE] "DOCSIS"]} {
        get_DOCSIS_parameters nbcheckgroup nbvargroup n [get_parameter_value RATE]
    }
   
   set params(NBCHECKGROUP) $nbcheckgroup
   set params(NBVARGROUP)   $nbvargroup
   set params(sim)          $sim 

  
  set contents [altera_terp $template params]
  
  return $contents
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





proc generate_test_data {test_data_dir output_name} {

    expr srand(0)


    set n                   [ get_parameter_value N ]
    set module              [ get_parameter_value MODULE ]
    set ldpc_type           [ get_parameter_value LDPC_TYPE ]   
    if {$module == "Encoder"} {set bps [ get_parameter_value BITSPERSYMBOL ]} else {set bps [ get_parameter_value LLRPERSYMBOL ] }      
    set softbits            [ get_parameter_value SOFTBITS ]
    set isvarrate            [ get_parameter_value ISVARRATE ]

    if {[string equal $module "Encoder"]} {
        set isencoder 1
    } else {
        set isencoder 0
    }
    
    if {[string equal [get_parameter_value LDPC_TYPE]  "DVB"]} {
        set matrix_number       [ get_DVB_matrixnumber [get_parameter_value N] [get_parameter_value RATE]]
        get_DVB_parameters nbcheckgroup nbvargroup n $matrix_number
        set k                   [expr $n-$nbcheckgroup*360]
    }
    if {[string equal [get_parameter_value LDPC_TYPE] "NASA"]} {
        get_NASA_parameters nbcheckgroup nbvargroup n [get_parameter_value N] $isencoder
        set k  [expr 14*511-18*[get_parameter_value N]]
    }
    if {[string equal [get_parameter_value LDPC_TYPE] "WiMedia"]} {
        get_Wimedia_parameters nbcheckgroup nbvargroup n [get_parameter_value N] [get_parameter_value RATE] $isencoder
        set nbcode 4
        set ntable [list $n $n $n $n ]
        set ktable [list 960 900 750 600 ]
        set k      [lindex $ktable [get_parameter_value RATE]]
    }
    if {[string equal $ldpc_type "DOCSIS"]} {
        get_DOCSIS_parameters nbcheckgroup nbvargroup n [get_parameter_value RATE]
        set isvarrate 1
        set nbcode 3
        set ntable [list 16200 5940 1120]
        set ktable [list 14400 5040 840 ]
    }
    
    
    
    set cwd [pwd]
    file mkdir $test_data_dir
    cd $test_data_dir

    
    
    set nb_cwd               5
    
    if {$isvarrate==1} {
        set list_of_rates  [list]
        set list_of_n  [list]
        set list_of_k  [list]
        for {set cc 0} {$cc < $nb_cwd} {incr cc} {
            set rr [expr {int(rand()*($nbcode)+1)}]
            lappend list_of_rates $rr
            lappend list_of_n [lindex $ntable [expr $rr-1]]
            lappend list_of_k [lindex $ktable [expr $rr-1]]
        }
        set f_name "${output_name}_rate.txt"
        # writing into a file
        set f_handle [open $f_name w+]
        foreach val $list_of_rates {
            puts $f_handle $val
        }
        close $f_handle
        add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"
    }
    
    if {$module == "Encoder"} {  
        set list_of_input_values  [list]
        for {set cc 0} {$cc < $nb_cwd} {incr cc} {
    
            if {$isvarrate==1} {set k [lindex $list_of_k $cc]} 

            for {set j 0} {$j < $k} {incr j} {
                lappend list_of_input_values [expr {int(rand()*2)}]
            }
        }
        set f_name "${output_name}_data.txt"
    } else {
        set inv_input_ber        200
        
        set list_of_input_values  [list]
        
        for {set cc 0} {$cc < $nb_cwd} {incr cc} {

            if {$isvarrate==1} {set n [lindex $list_of_n $cc]} 
            set list_of_error_positions_temp  [list]
            set list_of_error_positions  [list]
            set nb_errors_per_cwd    [expr $n/$inv_input_ber]
            
            for {set j 0} {$j < $nb_errors_per_cwd} {incr j} {
                lappend list_of_error_positions_temp  [expr {int(rand()*($n+1))}]
            }
            set sorted_list_of_error_positions  [lsort -integer $list_of_error_positions_temp]
            # removing identical values
            set ref_index 0
            lappend list_of_error_positions [lindex $sorted_list_of_error_positions 0]
            for {set j 1} {$j < $nb_errors_per_cwd} {incr j} {
                if {[lindex $sorted_list_of_error_positions $j]!=[lindex $sorted_list_of_error_positions $ref_index]} {
                    lappend list_of_error_positions [lindex $sorted_list_of_error_positions $j]
                    set ref_index $j
                }
            }

            set error_position_index 0
            for {set j 0} {$j < $n} {incr j} {
                set x 0
                set current_error_pos [lindex $list_of_error_positions $error_position_index]
                set current_pos       $j
                    if {$current_error_pos==$current_pos} {
                        set x [expr (1<<($softbits-1)) + int(rand()*((1<<($softbits-2))))]
                        if {$error_position_index != [llength $list_of_error_positions]} {incr error_position_index}
                    } else {
                        set x  [expr (1<<($softbits-1))-1]
                    }
                lappend list_of_input_values $x    
            }
        }
        set f_name "${output_name}_received_llr.txt"
    }
    
    # writing into a file
    set f_handle [open $f_name w+]
    foreach val $list_of_input_values {
        puts $f_handle $val
    }
    close $f_handle
    add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"


    cd $cwd
    

}


proc generate_matlab_files {} {
    set ldpc_type   [ get_parameter_value LDPC_TYPE ]
    set n_number    [ get_parameter_value N ]
    set rate_number [ get_parameter_value RATE ]
    set lps         [ get_parameter_value LLRPERSYMBOL ]
    set ite         [ get_parameter_value NB_ITE ]
    set atte_nb     [ get_parameter_value ATTENUATION ]
    set softbits    [ get_parameter_value SOFTBITS ]
    set softbits_msa  [ get_parameter_value S ]
    set islayered     [ get_parameter_value ISLAYERED ]


    # writing into set_test_parameters.m
    set text ""
    
    if {[string equal $ldpc_type "DVB"]} {
        add_fileset_file "matlab_model/EXAMPLE_TESTBENCH_DVB.m" OTHER PATH "../src/models/matlab_model/EXAMPLE_TESTBENCH_DVB.m"
        add_fileset_file "matlab_model/LDPC_encoder_DVB.p" OTHER PATH "../src/models/matlab_model/LDPC_encoder_DVB.hex"
        add_fileset_file "matlab_model/get_ldpc_dvb_index.p" OTHER PATH "../src/models/matlab_model/get_ldpc_dvb_index.hex"
        set isdecoder 0
        if {$n_number==0} {incr rate_number 1} else {incr rate_number 12}
        
        append text     "% codeword number:\n";
        append text     "%  1:long frame rate=1/4,    2:long frame rate=1/3,   3:long frame rate=2/5,  4:long frame rate=1/2 \n";
        append text     "%  5:long frame rate=3/5,    6:long frame rate=2/3,   7:long frame rate=3/4,  8:long frame rate=4/5 \n";
        append text     "%  9:long frame rate=5/6,   10:long frame rate=8/9,  11:long frame rate=9/10 \n";
        append text     "%  12:short frame rate=1/4, 13:short frame rate=1/3, 14:short frame rate=2/5, 15:short frame rate=1/2 \n";
        append text     "%  16:short frame rate=3/5, 17:short frame rate=2/3, 18:short frame rate=3/4, 19:short frame rate=4/5 \n";
        append text     "%  20:short frame rate=5/6, 21:short frame rate=8/9 \n";
        append text     "  param.Test_code_number = $rate_number;        % code \n";
    }
    
    append text     "  param.Test_nb          = 10;         % number of codeword\n";
    
    
    if {[string equal $ldpc_type "DOCSIS"]} {
        add_fileset_file "matlab_model/EXAMPLE_TESTBENCH_Docsis.m" OTHER PATH "../src/models/matlab_model/EXAMPLE_TESTBENCH_Docsis.m"
        add_fileset_file "matlab_model/HG_Docsis89.mat" OTHER PATH "../src/models/matlab_model/HG_Docsis89.hex"
        add_fileset_file "matlab_model/HG_Docsis75.mat" OTHER PATH "../src/models/matlab_model/HG_Docsis75.hex"
        add_fileset_file "matlab_model/HG_Docsis85.mat" OTHER PATH "../src/models/matlab_model/HG_Docsis85.hex"
        add_fileset_file "matlab_model/LDPC_decoder_Docsis.mexa64" OTHER PATH "../src/models/matlab_model/LDPC_decoder_Docsis.mexa64"
        add_fileset_file "matlab_model/LDPC_decoder_Docsis.mexw64" OTHER PATH "../src/models/matlab_model/LDPC_decoder_Docsis.mexw64"
        set isdecoder 1
    }
    
    if {[string equal $ldpc_type "WiMedia"]} {
        add_fileset_file "matlab_model/EXAMPLE_TESTBENCH_WiMedia.m" OTHER PATH "../src/models/matlab_model/EXAMPLE_TESTBENCH_WiMedia.m"
        add_fileset_file "matlab_model/HG_0.5WiMedia.mat" OTHER PATH "../src/models/matlab_model/HG_0.5WiMedia.hex"
        add_fileset_file "matlab_model/HG_0.625WiMedia.mat" OTHER PATH "../src/models/matlab_model/HG_0.625WiMedia.hex"
        add_fileset_file "matlab_model/HG_0.75WiMedia.mat" OTHER PATH "../src/models/matlab_model/HG_0.75WiMedia.hex"
        add_fileset_file "matlab_model/HG_0.8WiMedia.mat" OTHER PATH "../src/models/matlab_model/HG_0.8WiMedia.hex"
        add_fileset_file "matlab_model/LDPC_decoder_WiMedia.mexa64" OTHER PATH "../src/models/matlab_model/LDPC_decoder_WiMedia.mexa64"
        add_fileset_file "matlab_model/LDPC_decoder_WiMedia.mexw64" OTHER PATH "../src/models/matlab_model/LDPC_decoder_WiMedia.mexw64"
        add_fileset_file "matlab_model/LDPC_encoder_WiMedia.p" OTHER PATH "../src/models/matlab_model/LDPC_encoder_WiMedia.hex"
        set isdecoder 1
        if {$n_number==0} {set n 1320} else {set n 1200}
        append text     "  param.Test_cwd_length  = $n;        % codeword length \(1320 or 1200\) \n";
        append text     "  param.Test_par         = $lps;        % decoder parallelism \n";
    }
    
    if {[string equal $ldpc_type "NASA"]} {
        add_fileset_file "matlab_model/EXAMPLE_TESTBENCH_NASA.m" OTHER PATH "../src/models/matlab_model/EXAMPLE_TESTBENCH_NASA.m"
        add_fileset_file "matlab_model/HG_78NASA.mat" OTHER PATH "../src/models/matlab_model/HG_78NASA.hex"
        add_fileset_file "matlab_model/LDPC_decoder_NASA.mexa64" OTHER PATH "../src/models/matlab_model/LDPC_decoder_NASA.mexa64"
        add_fileset_file "matlab_model/LDPC_decoder_NASA.mexw64" OTHER PATH "../src/models/matlab_model/LDPC_decoder_NASA.mexw64"
        set isdecoder 1
        if {$n_number==0} {set n 8176} else {set n 8160}
        append text     "  param.Test_cwd_length  = $n;        % codeword length \(8176 or 8160\) \n";
        append text     "  param.Test_par         = $lps;        % decoder parallelism \n";
        append text     "  param.Test_layer       = $islayered;        % use layered decoding algorithm \n";
    }
    
    
    
    
    
    
    if {$isdecoder} {
        set att_list [list 1 0.875 0.75 0.625 0.5 0.375 0.25]
        add_fileset_file "matlab_model/quantiz_oct.m" OTHER PATH "../src/models/matlab_model/quantiz_oct.m"
        
        
        append text     "  param.Test_decwidth         = $softbits_msa;          % decoding LLR width\n";
        append text     "  param.Test_nb_iterattions   = $ite;         % maximum number of iterations\n";
        append text     "  param.Test_attenuation      = [lindex $att_list [expr $atte_nb-1]];      % attenuation factor\n";
        
        append text     "  param.Test_SNR         = 10;         % Eb/N0\n";
        append text     "  param.Test_inwidth     = $softbits;          % input LLR width\n";
    }
     
    add_fileset_file "matlab_model/set_test_parameters.m" OTHER TEXT $text 
}





