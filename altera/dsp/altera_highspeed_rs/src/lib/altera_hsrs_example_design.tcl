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

    #Generate Test Program
    send_message INFO "Generating Testbench Data"
    set source_files_path src
    if {[get_parameter_value RSDESIGN]==0} {
        set template_path "../src/testbench/hsrs_testbench.sv.terp"
    } else {
        set template_path "../src/testbench/hsrs_frac100_testbench.sv.terp"
    }
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
    set hsrs_example_name "core" 
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
    puts $f_handle    "add_instance ${hsrs_example_name} altera_highspeed_rs"
    foreach param [lsort [get_parameters]] {
        if {[get_parameter_property $param DERIVED] == 0} {
            #Screen for design environment, only QSYS flow is supported, because Native steps all over the BFMs by creating conduits
            if { $param ne "design_env" } { 
                puts $f_handle "set_instance_parameter_value $hsrs_example_name $param \"[get_parameter_value $param]\""
            } else {
                puts $f_handle "set_instance_parameter_value $hsrs_example_name $param \"QSYS\""
            }
        }
    }
    puts $f_handle    "add_interface ${hsrs_example_name}_rst reset sink"
    puts $f_handle    "set_interface_property ${hsrs_example_name}_rst EXPORT_OF ${hsrs_example_name}.reset"
    puts $f_handle    "add_interface ${hsrs_example_name}_clk clock sink"
    puts $f_handle    "set_interface_property ${hsrs_example_name}_clk EXPORT_OF ${hsrs_example_name}.clk"
    puts $f_handle    "add_interface ${hsrs_example_name}_sink avalon_sink sink"
    puts $f_handle    "set_interface_property ${hsrs_example_name}_sink EXPORT_OF ${hsrs_example_name}.out"
    puts $f_handle    "add_interface ${hsrs_example_name}_source avalon_source source"
    puts $f_handle    "set_interface_property ${hsrs_example_name}_source EXPORT_OF ${hsrs_example_name}.in"
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
        send_message ERROR "Highspeed RS Example Testbench Generation Fail"
    } else {
        send_message NOTE "Highspeed RS Example Testbench Generation Complete"
    }        
   

    set simulator_list { \
             {mentor   modelsim} \
             {aldec    riviera} \
             {synopsys vcs} \
             {cadence  ncsim} \
           }

    set test_file_dir [file join "${temp_dir}"]
    set all_files [get_all_file_abs $test_file_dir]
    
    set all_tails {}
    foreach module [lsearch -inline -all -glob $all_files *] {
        if { [regexp  {.*(\.hex$)|(\.mif$)|(\.v$)|(\.vo$)|(\.vho$)} [file tail $module] ] == 1 } {
            set ext [filetype submodule]
            add_fileset_file [file join "src" [file tail $module]] $ext PATH $module
        }
        if { [regexp  {.*(\.sv$)|(\.vhd$)} [file tail $module] ] == 1 } {

            switch -glob $module {
               *.vhd    { set language VHDL}
               *.sv     { set language SYSTEM_VERILOG}
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
        } elseif { [regexp  {.*((\.vo)|(\.vho)|(pkg\.v)|(pkg\.sv)|(pkg\.vhd)|(mat\.sv))} $cur_file] == 1 } {
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
    set generic_files_temp $generic_files
    if {[ get_parameter_value RS ] == "Decoder"} {
        set priority_files {rsx_parameters_auto.vhd rsx_functions.vhd rsx_package.vhd rsx_roots_auto.vhd rsx_bm_auto.vhd  rsx_inverse_ROM_bkp.vhd rsx_inverse_ROM_auto.vhd}
    } else {
        set priority_files {}
    }
    set priority_file_list [list ]

    foreach priority_file $priority_files {
        foreach current_file $generic_files_temp {
            if {[string match -nocase [file tail $current_file]  $priority_file]} {
                # add the file to the priority list
                lappend priority_file_list $current_file
                set pos [lsearch $generic_files $current_file]
                # remove the file to the generic_files
                set generic_files [lreplace $generic_files $pos $pos]
            }
        }
    }


    #puting the package files first
    set rtl_files [concat $packages $priority_file_list $generic_files]


  ###################################################################################################
  send_message INFO "Generating Simulation Scripts"
  # set the spd
   puts $sim_script "<simPackage>"
   set library "work"
   
   
   foreach file $rtl_files {
      if { [lsearch $all_files $file] != -1 } {
         # remove the current element from the list
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         if { [string match -nocase SYSTEM_VERILOG $file_type]==1 || [string match -nocase VHDL $file_type]==1 } { 
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
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\"  simulator=\"${simulator}\"/>"
   } elseif { $type == "VHDL_ENCRYPT" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\" simulator=\"${simulator}\"/>"
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
   set params(output_name) $output_name
   if {[get_parameter_value RS] == "Encoder"} {
       set params(CHANNEL)         1 
   } else {
       set params(CHANNEL)         [get_parameter_value CHANNEL]  
   }
   set params(CHECK)          [expr [get_parameter_value N] - [get_parameter_value K] ]
   set params(sim)            $sim 
   set params(PRO)            [is_qsys_edition QSYS_PRO]

  
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
    set rsdesign            [ get_parameter_value RSDESIGN ]
    set channel             [ get_parameter_value CHANNEL ]
    set n                   [ get_parameter_value N ]
    set k                   [ get_parameter_value K ]
    set module              [ get_parameter_value RS ]     
    set bps                 [ get_parameter_value BITSPERSYMBOL ]
    set par                 [ get_parameter_value PAR ] 
    set use_bypass          [ get_parameter_value USE_BYPASS ] 
    set use_sync            [ get_parameter_value USE_SYNC ] 
    
    if {$module == "Encoder"} {   
        set nb_cwd             [expr 10]
        set nk                 $k
    } else {
        set nb_cwd             [expr 10*$channel]
        set nk                 $n
    }    
    
    if {$rsdesign == 1} {
        set n                   528
        set k                   514
        set bps                 10
        set par                 8 
        set use_bypass          0
        set use_sync            0
        set list_of_modes       [list 2 2]
        set nb_cwd              8
    }
    
    set check               [expr $n-$k]
    
    
    set cwd [pwd]
    file mkdir $test_data_dir
    cd $test_data_dir
    

    set list_of_sync_codeword  [list]
    if {$nk%$par==0} {
        set nb_symb [expr {int($nk/$par)-1}]
    } else {
        set nb_symb [expr {int($nk/$par)}]
    }
    for {set cc 0} {$cc < $nb_cwd} {incr cc} {
        lappend list_of_sync_codeword $nb_symb
    }    
    if {$use_sync} {
        # 1/4 of codewords never ends
        set nb_unsync   [expr $nb_cwd/4]
        for {set j 0} {$j < $nb_unsync} {incr j} {
            set sync_position [expr {int(rand()*$nb_cwd)}]
            set sync_value [expr {int(rand()*($nb_symb-1))}]
            lset list_of_sync_codeword $sync_position $sync_value
        }
        lset list_of_sync_codeword end $nb_symb
        set s_name     "${output_name}_sync.txt"        
    }
    
    
    
    set list_of_input_values  [list]
    set list_of_input_values1  [list]
    set list_of_input_values2  [list]
    set list_of_input_values3  [list]
    set list_of_input_values4  [list]
    set list_of_bypassed_codeword  [list]
    
    
    if {$module == "Encoder"} {    
        for {set cc 0} {$cc < $nb_cwd} {incr cc} {
            
            set k_temp $k
            if {[lindex $list_of_sync_codeword $cc] < $nb_symb} {
                set k_temp [expr ([lindex $list_of_sync_codeword $cc]+1)*$par]
            }
            if {$k_temp>$k} {
                set k_temp $k
            }
            
            
            for {set j 0} {$j < $k_temp} {incr j} {
                set x [expr {int(rand()*(2**($bps)))}]
                lappend list_of_input_values $x
                if {$rsdesign==1} {       
                    if {$cc % 4 == 0} {
                        lappend list_of_input_values1 $x
                    } elseif {$cc%4 == 1} {
                        lappend list_of_input_values2 $x
                    } elseif {$cc%4 == 2} {
                        lappend list_of_input_values3 $x
                    } else {
                        lappend list_of_input_values4 $x
                    }
                }
                
            }
            if {$k==$k_temp &&($k%$par)!=0} {set kextra [expr $par-($k%$par)]} else {set kextra 0}
            for {set j 0} {$j < $kextra} {incr j} {
                lappend list_of_input_values 0
                if {$rsdesign==1} {       
                    if {$cc % 4 == 0} {
                        lappend list_of_input_values1 0
                    } elseif {$cc%4 == 1} {
                        lappend list_of_input_values2 0
                    } elseif {$cc%4 == 2} {
                        lappend list_of_input_values3 0
                    } else {
                        lappend list_of_input_values4 0
                    }
                }
            }
        }
        set f_name "${output_name}_data.txt"
        set f1_name     "${output_name}_data_1.txt"
        set f2_name     "${output_name}_data_2.txt"
        set f3_name     "${output_name}_data_3.txt"
        set f4_name     "${output_name}_data_4.txt"
        
    } else {
        for {set cc 0} {$cc < $nb_cwd} {incr cc} {

            lappend list_of_bypassed_codeword [expr {int(rand()*2)}]
            
            set list_of_error_positions       [list]
            set nb_errors_per_cwd    [expr {int(rand()*($check>>1)+1)}]
            
 # if {$is_era==0} {send_message warning "cc is $cc, n is $n, check is $check, nb_error is $nb_errors_per_cwd"} 
            set list_of_error_positions_temp  [list]
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

            set n_temp $n
            if {[lindex $list_of_sync_codeword $cc] < $nb_symb} {
                set n_temp [expr ([lindex $list_of_sync_codeword $cc]+1)*$par]
            }
            if {$n_temp>$n} {
                set n_temp $n
            }
            
            
            set error_position_index 0
            for {set j 0} {$j < $n_temp} {incr j} {
                set x 0
                set current_error_pos [lindex $list_of_error_positions $error_position_index]
                set current_pos       $j
                if {$current_error_pos==$current_pos} {
                    set x [expr {int(rand()*(2**($bps)))}]
                    if {$error_position_index != [llength $list_of_error_positions]} {incr error_position_index}
                } else {
                    set x  0
                }
                lappend list_of_input_values $x   
                if {$rsdesign==1} {       
                    if {$cc % 4 == 0} {
                        lappend list_of_input_values1 $x
                    } elseif {$cc%4 == 1} {
                        lappend list_of_input_values2 $x
                    } elseif {$cc%4 == 2} {
                        lappend list_of_input_values3 $x
                    } else {
                        lappend list_of_input_values4 $x
                    }
                }
            }
            if {$n==$n_temp && ($n%$par)!=0} {set nextra [expr $par-($n%$par)]} else {set nextra 0}
            for {set j 0} {$j < $nextra} {incr j} {
                lappend list_of_input_values 0
                # we shoulf add zeors for mode 0. we avoid using this mode
                # if {$rsdesign==1} {       
                    # if {$cc % 4 == 0} {
                        # lappend list_of_input_values1 0
                    # } elseif {$cc % 4 == 1} {
                        # lappend list_of_input_values2 0
                    # } elseif {$cc % 4 == 2} {
                        # lappend list_of_input_values3 0
                    # } else {
                        # lappend list_of_input_values4 0
                    # }
                # }
            }
            

        }
        set f_name     "${output_name}_received_words.txt"
        set f1_name     "${output_name}_received_words_1.txt"
        set f2_name     "${output_name}_received_words_2.txt"
        set f3_name     "${output_name}_received_words_3.txt"
        set f4_name     "${output_name}_received_words_4.txt"
        set b_name     "${output_name}_bypassed_codewords.txt"
    }

    # writing into a file
    if {$rsdesign==0} {
        set f_handle [open $f_name w+]
        foreach val $list_of_input_values {puts $f_handle $val}
        close $f_handle
        add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"
        
        if {$use_bypass} {
            set f_handle [open $b_name w+]
            foreach val $list_of_bypassed_codeword {puts $f_handle $val}
            close $f_handle
            add_fileset_file [file join "test_data" $b_name] OTHER PATH "[file join $test_data_dir $b_name]"
        }
        
        if {$use_sync} {
            set f_handle [open $s_name w+]
            foreach val $list_of_sync_codeword {puts $f_handle $val}
            close $f_handle
            add_fileset_file [file join "test_data" $s_name] OTHER PATH "[file join $test_data_dir $s_name]"
        }
        
    }
    if {$rsdesign==1} {
        set f_handle [open ${output_name}_modes.txt w+]
        foreach val $list_of_modes {puts $f_handle $val}
        close $f_handle
        add_fileset_file [file join "test_data" ${output_name}_modes.txt] OTHER PATH "[file join $test_data_dir ${output_name}_modes.txt]"
        set f_handle [open $f1_name w+]
        foreach val $list_of_input_values1 {puts $f_handle $val}
        close $f_handle
        add_fileset_file [file join "test_data" $f1_name] OTHER PATH "[file join $test_data_dir $f1_name]"
        set f_handle [open $f2_name w+]
        foreach val $list_of_input_values2 {puts $f_handle $val}
        close $f_handle
        add_fileset_file [file join "test_data" $f2_name] OTHER PATH "[file join $test_data_dir $f2_name]"
        set f_handle [open $f3_name w+]
        foreach val $list_of_input_values3 {puts $f_handle $val}
        close $f_handle
        add_fileset_file [file join "test_data" $f3_name] OTHER PATH "[file join $test_data_dir $f3_name]"
        set f_handle [open $f4_name w+]
        foreach val $list_of_input_values4 {puts $f_handle $val}
        close $f_handle
        add_fileset_file [file join "test_data" $f4_name] OTHER PATH "[file join $test_data_dir $f4_name]"
    }
    
    cd $cwd
}








