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
    set template_path "../src/testbench/viterbi_testbench.sv.terp"
    set terp_contents [render_terp $output_name $template_path ]
    set test_program_file "${output_name}_test_program.sv" 
    add_fileset_file "[file join $source_files_path $test_program_file]" [filetype $test_program_file] TEXT $terp_contents
    

    #Generate Test Data
    send_message INFO "Generating Test Data"
    set test_data_dir [create_temp_file ""]
    generate_test_data $test_data_dir $output_name 


    send_message INFO "Generating Testbench System"
    #Generate Testbenching System
    set family "[get_parameter_value selected_device_family]"
    set viterbi_example_name "core" 
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
    puts $f_handle    "add_instance ${viterbi_example_name} altera_viterbi_ii"
    foreach param [lsort [get_parameters]] {
        if {[get_parameter_property $param DERIVED] == 0} {
            #Screen for design environment, only QSYS flow is supported, because Native steps all over the BFMs by creating conduits
            if { $param ne "design_env" } { 
                puts $f_handle "set_instance_parameter_value $viterbi_example_name $param \"[get_parameter_value $param]\""
            } else {
                puts $f_handle "set_instance_parameter_value $viterbi_example_name $param \"QSYS\""
            }
        }
    }
    puts $f_handle    "add_interface ${viterbi_example_name}_rst reset sink"
    puts $f_handle    "set_interface_property ${viterbi_example_name}_rst EXPORT_OF ${viterbi_example_name}.rst"
    puts $f_handle    "add_interface ${viterbi_example_name}_clk clock sink"
    puts $f_handle    "set_interface_property ${viterbi_example_name}_clk EXPORT_OF ${viterbi_example_name}.clk"
    
    puts $f_handle    "add_interface ${viterbi_example_name}_sink avalon_sink sink"
    puts $f_handle    "set_interface_property ${viterbi_example_name}_sink EXPORT_OF ${viterbi_example_name}.out"
    puts $f_handle    "add_interface ${viterbi_example_name}_source avalon_source source"
    puts $f_handle    "set_interface_property ${viterbi_example_name}_source EXPORT_OF ${viterbi_example_name}.in"
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
        send_message ERROR "Viterbi II Example Testbench Generation Fail"
    } else {
        send_message NOTE "Viterbi II Example Testbench Generation Complete"
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
       if {[string match *Makefile*  $c_file ] == 1} {
          add_fileset_file "c_model/Makefile" OTHER PATH "${c_model_location}/../c_model/Makefile"
       } else {
          add_fileset_file $c_file OTHER PATH "${c_model_location}/../${c_file}"
       }
    }


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

    set priority_files {vi_interface.vhd vi_functions.vhd auk_vit_par_trb_atl.vhd auk_vit_hyb_trb_atl.vhd}

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
                puts $sim_script [convert_to_spd_xml2  $file_name $file_type $library ""]
            }
         } else { 
             set file_name [file join $source_files_path [file tail $file]]
             puts $sim_script [convert_to_spd_xml2  $file_name $file_type $library ""]
         }
      }
   }

   foreach file $memory_files {
      if { [lsearch $all_files $file] != -1 } {
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         set file_name [file join $source_files_path [file tail $file]]
         puts $sim_script [convert_to_spd_xml2  $file_name "Memory" $library ""]
      }
   }
   foreach file $top_files {
      set file_type [filetype $file]
      set file_name [file join $source_files_path [file tail $file]]
      puts $sim_script [convert_to_spd_xml2  $file_name $file_type $library ""]
   }

   # Add the top level 
   set file_name [file join $source_files_path $test_program_file]
   set file_type [filetype $file_name]
   puts $sim_script [convert_to_spd_xml2  $file_name $file_type $library ""]


   # add input files
   set input_files [glob -directory $test_data_dir  -tails *{.txt}]
   foreach file $input_files {
      set file_type "Memory"
      set file_name [file tail $file]
      puts $sim_script [convert_to_spd_xml2  [file join "test_data" $file_name] $file_type 0 ""]
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


proc convert_to_spd_xml2 { file_name type library  simulator } {
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

proc render_terp {output_name template_path} {
    
   set template_fd [open $template_path]
   set template [read $template_fd]
   close $template_fd
   

   foreach param [lsort [get_parameters]] {
      if {[get_parameter_property $param AFFECTS_GENERATION]==1} {
          set params($param) [get_parameter_value $param]
      }
   }
   set params(output_name) $output_name
  
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

    set k                     1000
    set r                     [ get_parameter_value N ]

    set softbits              [ get_parameter_value SOFTBITS ]
    set viterbi_type          [ get_parameter_value viterbi_type ]
    set parallel_optimization [ get_parameter_value parallel_optimization ]
    set N                     [ get_parameter_value n ]
    set L                     [ get_parameter_value L ]
    set ga                    [ get_parameter_value ga ]
    set gb                    [ get_parameter_value gb ]
    set gc                    [ get_parameter_value gc ]
    set gd                    [ get_parameter_value gd ]
    set ge                    [ get_parameter_value ge ]
    set gf                    [ get_parameter_value gf ]
    set gg                    [ get_parameter_value gg ]
    set v                     [ get_parameter_value v ]
    
    
    set g_list [list $ga $gb $gc $gd $ge $gf $gg]
    set G [list]
    for {set nn 0} {$nn < $N} {incr nn} {
        set bin [format  %${L}b [lindex $g_list $nn]]
        lappend G [split $bin {}]   
    }

    set cwd [pwd]
    file mkdir $test_data_dir
    cd $test_data_dir

    
    
    set nb_cwd               5
    if {$viterbi_type=="Parallel" & $parallel_optimization=="Continuous"} {
        set nb_cwd  1
        set k       5000
    }
    if {$viterbi_type=="Parallel" & $parallel_optimization=="Block"} {
        set k       $v
    }
    
    set n [expr $k*$r]    
    

        set inv_input_ber        1000
        
        set list_of_data_values  [list]
        set list_of_cwd_values   [list]
        set list_of_input_values  [list]
        
        for {set cc 0} {$cc < $nb_cwd} {incr cc} {
 
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

            set reg [list ]
            for {set rr 0} {$rr < $L} {incr rr} {
                lappend reg 0
            }
            
            set error_position_index 0
            for {set j 0} {$j < $k} {incr j} {
                set x 0
              
                set data [expr {int(rand()*2)}]
                #set data 1
                lappend list_of_data_values $data
                
                
                set reg_new [list ]
                lappend reg_new $data
                for {set rr 0} {$rr < $L-1} {incr rr} {
                    lappend reg_new [lindex $reg $rr]
                }
                set reg $reg_new
                

                
            # if {$j < 10}  {
                # send_message warning "reg are $reg"
            # }                    
                for {set nn 0} {$nn < $N} {incr nn} {
                
                    set current_error_pos [lindex $list_of_error_positions $error_position_index]
                    set current_pos       [expr $j*$N+$nn]
                
                
                    set xor [lindex $G $nn]
                    set output 0
                    for {set ll 0} {$ll < $L} {incr ll} {
                        set output [expr $output ^ ([lindex $xor $ll] & [lindex $reg $ll])]
                    }
            # if {$j < 10} {
                    # send_message warning "------index are $xor, output\[$nn\] = $output"
            # }
                    lappend list_of_cwd_values $output
                    
                    
                    if {$current_error_pos==$current_pos} {
                        set randerr [expr 1 + int(rand()*((1<<($softbits-2))))]

                        if {$output==0} {
                            set x [expr (1<<($softbits-1)) + $randerr]
                        } else {
                            set x [expr (1<<($softbits-1))-1 - $randerr]
                        }
                        if {$error_position_index != [llength $list_of_error_positions]} {incr error_position_index}
                    } else {
                        set x  [expr (1<<($softbits-1))-(1-$output)]
                    }
                    lappend list_of_input_values $x 


                }


            }
        }
        
    # writing into a file
    set f_name "${output_name}_received_words.txt"
    set f_handle [open $f_name w+]
    foreach val $list_of_input_values {
        puts $f_handle $val
    }
    close $f_handle
    add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"
    
    set f_name "${output_name}_data.txt"
    set f_handle [open $f_name w+]
    foreach val $list_of_data_values {
        puts $f_handle $val
    }
    close $f_handle
    add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"

    set f_name "${output_name}_cwd.txt"
    set f_handle [open $f_name w+]
    foreach val $list_of_cwd_values {
        puts $f_handle $val
    }
    close $f_handle
    add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"
    
    cd $cwd
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




