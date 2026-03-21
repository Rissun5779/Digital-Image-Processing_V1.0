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
    set template_path "../src/testbench/rsii_testbench.sv.terp"
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
    set rsii_example_name "core" 
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
    puts $f_handle    "add_instance ${rsii_example_name} altera_rs_ii"
    foreach param [lsort [get_parameters]] {
        if {[get_parameter_property $param DERIVED] == 0} {
            #Screen for design environment, only QSYS flow is supported, because Native steps all over the BFMs by creating conduits
            if { $param ne "design_env" } { 
                puts $f_handle "set_instance_parameter_value $rsii_example_name $param \"[get_parameter_value $param]\""
            } else {
                puts $f_handle "set_instance_parameter_value $rsii_example_name $param \"QSYS\""
            }
        }
    }
    puts $f_handle    "add_interface ${rsii_example_name}_rst reset sink"
    puts $f_handle    "set_interface_property ${rsii_example_name}_rst EXPORT_OF ${rsii_example_name}.reset"
    puts $f_handle    "add_interface ${rsii_example_name}_clk clock sink"
    puts $f_handle    "set_interface_property ${rsii_example_name}_clk EXPORT_OF ${rsii_example_name}.clk"
    puts $f_handle    "add_interface ${rsii_example_name}_sink avalon_sink sink"
    puts $f_handle    "set_interface_property ${rsii_example_name}_sink EXPORT_OF ${rsii_example_name}.out"
    puts $f_handle    "add_interface ${rsii_example_name}_source avalon_source source"
    puts $f_handle    "set_interface_property ${rsii_example_name}_source EXPORT_OF ${rsii_example_name}.in"
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
        send_message ERROR "RS_II Example Testbench Generation Fail"
    } else {
        send_message NOTE "RS_II Example Testbench Generation Complete"
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

                if {[string match *altera_rs*  [file tail $module] ] == 1} {

                    foreach simulator $simulator_list {
                        set sim [lindex $simulator 0]

                        if {[string match *$sim*  $module ] == 1} {
                            set supported [lindex $simulator 1]
                            if {$supported} {
                                add_fileset_file [file join "src/$sim" [file tail $module]] SYSTEM_VERILOG_ENCRYPT PATH $module [string toupper $sim]_SPECIFIC
                            } else {
                                add_fileset_file [file join "src" [file tail $module]] SYSTEM_VERILOG PATH $module
                            }
                        }
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
        } elseif { [regexp  {.*((\.vo)|(\.vho)|(pkg\.v)|(pkg\.sv)|(pkg\.vhd)|(mat\.sv))} $cur_file] == 1 } {
            lappend packages $cur_file
        } elseif { [regexp  {.*\.(v|(sv)|(vhd))} $cur_file] == 1 } {
            if {[regexp  {.*((_inst\.)|(_bb\.))(v|(sv)|(vhd))} $cur_file ] == 0} {
                lappend generic_files $cur_file
            }
        } elseif { [regexp  {.*\.((hex)|(mif))}  $cur_file] == 1 } {
            lappend memory_files $cur_file
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
         if { [string match -nocase SYSTEM_VERILOG $file_type]==1 && [string match *altera_rs*  [file tail $file] ]==1} {
                    foreach simulator $simulator_list {
                        set sim [lindex $simulator 0]
                        set supported [lindex $simulator 1]
                        set tool [lindex $simulator 2]
                        if {$supported} {
                            set file_name [file join $source_files_path $sim [file tail $file]]
                            puts $sim_script [convert_to_spd_xml  $file_name SYSTEM_VERILOG_ENCRYPT $library $tool]
                        } else {
                            set file_name [file join $source_files_path [file tail $file]]
                            puts $sim_script [convert_to_spd_xml  $file_name SYSTEM_VERILOG $library ""]
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
         if { [string match -nocase SYSTEM_VERILOG $file_type]==1 && [string match *altera_rs*  [file tail $file]]==1} {
                    foreach simulator $simulator_list {
                        set sim [lindex $simulator 0]
                        set supported [lindex $simulator 1]
                        set tool [lindex $simulator 2]
                        if {$supported} {
                            set file_name [file join $source_files_path $sim [file tail $file]]
                            puts $sim_script [convert_to_spd_xml  $file_name SYSTEM_VERILOG_ENCRYPT $library $tool]
                        } else {
                            set file_name [file join $source_files_path [file tail $file]]
                            puts $sim_script [convert_to_spd_xml  $file_name SYSTEM_VERILOG $library ""]
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
   set params(MODULE) [get_parameter_value RS] 
   set params(N) [get_parameter_value N] 
   set params(BITSPERSYMBOL) [get_parameter_value BITSPERSYMBOL] 
   set params(ERASURE)       [get_parameter_value ERASURE] 
   set params(VARN)          [get_parameter_value VARN] 
   set params(VARCHECK)      [get_parameter_value VARCHECK] 
   set params(USENUMN)       [get_parameter_value USENUMN] 
   set params(CHECK)         [get_parameter_value CHECK] 
   set params(CHANNEL)       [get_parameter_value CHANNEL] 
   set params(sim)           $sim 

  
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

    set channel             [ get_parameter_value CHANNEL ]
    set n                   [ get_parameter_value N ]
    set check               [ get_parameter_value CHECK ]
    set module              [ get_parameter_value RS ]     
    set bps                 [ get_parameter_value BITSPERSYMBOL ]
    set varn                [ get_parameter_value VARN ] 
    set varcheck            [ get_parameter_value VARCHECK ] 
    set usenumn             [ get_parameter_value USENUMN ] 
    set is_era              [ get_parameter_value  ERASURE ] 

    set k                   [expr $n-$check]

    set cwd [pwd]
    file mkdir $test_data_dir
    cd $test_data_dir


    
    set nb_cwd               10
    
    set list_of_n  [list]
    set list_of_check  [list]
    for {set cc 0} {$cc < $nb_cwd} {incr cc} {
    
        if {$varcheck==1} {
            set rr [expr {int(rand()*($check-1)+2)}]
            lappend list_of_check $rr
        } else {
            lappend list_of_check $check
        }    
        if {$varn==1} {
            set rr [expr {int(rand()*($n-[lindex $list_of_check $cc])+[lindex $list_of_check $cc])}]
            lappend list_of_n $rr
        } else {
            lappend list_of_n $n
        }

    }
    
    if {$varn==1} {
        set f_name "${output_name}_numn.txt"
        # writing into a file
        set f_handle [open $f_name w+]
        foreach val $list_of_n {
            puts $f_handle $val
        }
        close $f_handle
        add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"
    }
    if {$varcheck==1 } {
        set f_name "${output_name}_numcheck.txt"
        # writing into a file
        set f_handle [open $f_name w+]
        foreach val $list_of_check {
            puts $f_handle $val
        }
        close $f_handle
        add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"
    }
    
    
    
    set list_of_input_values  [list]
    set list_of_erasures      [list ]
    
    if {$module == "Encoder"} {    
        for {set cc 0} {$cc < $nb_cwd} {incr cc} {
            set k [expr [lindex $list_of_n $cc]-[lindex $list_of_check $cc]]
            for {set j 0} {$j < $k*$channel} {incr j} {
                set x [expr {int(rand()*(2**($bps)))}]
                lappend list_of_input_values $x
            }
        }
        set f_name "${output_name}_data.txt"
    } else {
        for {set cc 0} {$cc < $nb_cwd} {incr cc} {

            set n     [lindex $list_of_n $cc]
            set check [lindex $list_of_check $cc]
            
            set list_of_error_positions       [list]
            set nb_errors_per_cwd    [expr {int(rand()*($check>>1)+1)}]
            
 # if {$is_era==0} {send_message warning "cc is $cc, n is $n, check is $check, nb_error is $nb_errors_per_cwd"} 
            for {set ch 0} {$ch < $channel} {incr ch} {
                set list_of_error_positions_temp  [list]
                for {set j 0} {$j < $nb_errors_per_cwd} {incr j} {
                    lappend list_of_error_positions_temp  [expr {int(rand()*($n+1))*$channel+$ch}]
                }
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
            for {set j 0} {$j < $n*$channel} {incr j} {
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
            }
            
            if {$is_era==1} {
            
                
                set list_of_era_positions       [list]
                set nb_era_per_cwd       [expr {int(rand()*($check-($nb_errors_per_cwd<<1) +1))}]  
     # send_message warning "cc is $cc, n is $n, check is $check, nb_error is $nb_errors_per_cwd, nb_era_per_cwd, $nb_era_per_cwd"
                for {set ch 0} {$ch < $channel} {incr ch} {
                    set list_of_era_positions_temp  [list]
                    for {set j 0} {$j < $nb_era_per_cwd} {incr j} {
                        lappend list_of_era_positions_temp  [expr {int(rand()*($n+1))*$channel+$ch}]
                    }
                }
                
                set sorted_list_of_era_positions  [lsort -integer $list_of_era_positions_temp]
                # removing identical values
                set ref_index 0
                lappend list_of_era_positions [lindex $sorted_list_of_era_positions 0]
                for {set j 1} {$j < $nb_era_per_cwd} {incr j} {
                    if {[lindex $sorted_list_of_era_positions $j]!=[lindex $sorted_list_of_era_positions $ref_index]} {
                        lappend list_of_era_positions [lindex $sorted_list_of_era_positions $j]
                        set ref_index $j
                    }
                }
                set era_position_index 0
                for {set j 0} {$j < $n} {incr j} {
                    set x 0
                    set current_era_pos [lindex $list_of_era_positions $era_position_index]
                    set current_pos       $j
                        if {$current_era_pos==$current_pos} {
                            set x  1
                            if {$era_position_index != [llength $list_of_era_positions]} {incr era_position_index}
                        } else {
                            set x  0
                        }
                    lappend list_of_erasures $x   
                }
            
            }
            
            
            
        }
        set f_name_era "${output_name}_erasures.txt"  
        set f_name     "${output_name}_received_words.txt"
    }

    # writing into a file
    set f_handle [open $f_name w+]
    foreach val $list_of_input_values {
        puts $f_handle $val
    }
    close $f_handle
    add_fileset_file [file join "test_data" $f_name] OTHER PATH "[file join $test_data_dir $f_name]"


    # writing into a file
    if {$module == "Decoder" && $is_era==1} {    
        set f_handle [open $f_name_era w+]
        foreach val $list_of_erasures {
            puts $f_handle $val
        }
        close $f_handle
        add_fileset_file [file join "test_data" $f_name_era] OTHER PATH "[file join $test_data_dir $f_name_era]"
    }

    
    
    cd $cwd
}








