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


proc ed_sim {} {
    global env
    set qdir $env(QUARTUS_ROOTDIR)
    set quartus_sh_exe_path "$::env(QUARTUS_BINDIR)/quartus_sh"
    set qsys_script_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
    set ed_sim_src_dir     "${qdir}/../ip/altera/seriallite_iii/example/ed_sim/src"
    set ed_sim_scripts_dir "${qdir}/../ip/altera/seriallite_iii/example/ed_sim/scripts"
    set ed_sim_dir         "${qdir}/../ip/altera/seriallite_iii/example/ed_sim"
    set common_dir         "${qdir}/../ip/altera/seriallite_iii/example/common"
    set tmpdir             "."
    set dir                [get_parameter_value direction]
    set df                 [get_parameter_value system_family]
    set language           [get_parameter_value SELECT_ED_FILESET]
    set tmp_dir_path [create_temp_file ""]
    set tmp_ex_design_dir_path "${tmp_dir_path}tmp_ex_design/"
    set tmp_tb_dir_path        "${tmp_ex_design_dir_path}/tb_components/"
    file mkdir $tmp_ex_design_dir_path
    file mkdir $tmp_tb_dir_path
	
    if {$language == 0} {
       set hdl "verilog"
    } else {
       set hdl "vhdl"
    }
	
    send_message info "Generating testbench components for simulation"
    add_cust_tb_components $tmp_tb_dir_path

    send_message info "Generating simulation kick-off scripts"
    add_run_tb_scripts

    send_message info "Generating tcl files for QSYS generation"


    if { $dir == "Duplex"} {
        set dir_qsys {"Duplex" ""}
    } else {
	    set dir_qsys {"Sink" "_sink" "Source" "_source"}
	}

    set variant_name_tx "seriallite_iii_streaming_source"
    set variant_name_rx "seriallite_iii_streaming_sink"
    set variant_name_dup "seriallite_iii_streaming"

    # Create QSYS script for IP core
    foreach {dir_qsys_tcl tail_output_name} $dir_qsys {
        set output_name "seriallite_iii_streaming${tail_output_name}"
        set gen_ip_qsys_script_file [create_temp_file gen_qsys.tcl]
        set out_ip_qsys_tcl [ open $gen_ip_qsys_script_file w ]
        puts $out_ip_qsys_tcl "package require \-exact qsys 14.1"
        puts $out_ip_qsys_tcl "create_system"
        puts $out_ip_qsys_tcl "set_project_property DEVICE_FAMILY \"[get_parameter_value "system_family"]\""
		
        if { $df == "Arria 10"} {
		   puts $out_ip_qsys_tcl "add_instance $output_name seriallite_iii_a10"
        } else {
           puts $out_ip_qsys_tcl "add_instance $output_name seriallite_iii_sv"
        }
        puts $out_ip_qsys_tcl "set_instance_property $output_name AUTO_EXPORT 1"

        foreach {param_name} [get_parameters] {
            set is_derived_param [get_parameter_property $param_name DERIVED]
            set param_value [get_parameter_value $param_name]
               
            # Print out the DUT parameters that are not derived
            if {$is_derived_param == 1} {
                continue
            } elseif {[string match "*direction*" $param_name]} {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name \"$dir_qsys_tcl\""
            } else {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name \"[get_parameter_value "$param_name"]\""
            }
        }
        puts $out_ip_qsys_tcl "save_system $output_name"
        close $out_ip_qsys_tcl
		
        file copy $gen_ip_qsys_script_file $tmp_ex_design_dir_path
        file rename ${tmp_ex_design_dir_path}gen_qsys.tcl ${tmp_ex_design_dir_path}gen_qsys_seriallite_iii_streaming${tail_output_name}.tcl   
    }

	foreach {sim_language} $hdl {

        set out_run_script_file [create_temp_file gen_ed_sim.tcl]
 
        set out [ open $out_run_script_file w ]
        set in [open ${ed_sim_scripts_dir}/gen_ed_sim.tcl r]

        while {[gets $in line] != -1} {
            if {[string match "*gen_IP_QSYS*" $line]} {
                # gen_IP_QSYS (qsys-script)
                puts $out $line
                if {$dir == "Duplex"} {
                    puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_seriallite_iii_streaming.tcl \]\} temp"					
                    puts $out "puts \$temp"
                } else {
                    puts $out "set qsys_tcl_script_tx \[file join gen_qsys_seriallite_iii_streaming_source.tcl\]"
                    puts $out "set qsys_tcl_script_rx \[file join gen_qsys_seriallite_iii_streaming_sink.tcl\]"
                    puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=\$qsys_tcl_script_tx\]\} temp"
                    puts $out "puts \$temp"
                    puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=\$qsys_tcl_script_rx\]\} temp"
                    puts $out "puts \$temp"
                }
            } elseif {[string match "*gen_IP*" $line]} {
                # gen_IP (qsys-generate)
                puts $out $line
                if {$dir == "Duplex"} {
                    puts $out "set output_dir_dup \[file join $variant_name_dup\]"
                    if {[is_qsys_edition QSYS_PRO]} {
                        puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_dup.ip --simulation=$sim_language --output-directory=\$output_dir_dup\]\} temp"
                    } else {
                        puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_dup.qsys --simulation=$sim_language --output-directory=\$output_dir_dup\]\} temp"
                    }						
					puts $out "puts \$temp"
                } else {
                    puts $out "set output_dir_tx \[file join $variant_name_tx\]"
                    puts $out "set output_dir_rx \[file join $variant_name_rx\]"
                    if {[is_qsys_edition QSYS_PRO]} {
                        puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_tx.ip --simulation=$sim_language --output-directory=\$output_dir_tx\]\} temp"
				    } else {
                        puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_tx.qsys --simulation=$sim_language --output-directory=\$output_dir_tx\]\} temp"
                    }						
                    puts $out "puts \$temp"
                    if {[is_qsys_edition QSYS_PRO]} {					
                        puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_rx.ip --simulation=$sim_language --output-directory=\$output_dir_rx\]\} temp"
					} else {
					    puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_rx.qsys --simulation=$sim_language --output-directory=\$output_dir_rx\]\} temp"
					}
                    puts $out "puts \$temp"
                }
            } elseif {[string match "*gen_simscript*" $line]} {
                # gen_simscript
                puts $out $line
                #puts $out "set atx_spd \[file join \$output_dir  altera_atx_pll_a10 altera_atx_pll_a10.spd\]"
                if {$dir == "Duplex"} {
                    puts $out "set ip_spd \[file join $variant_name_dup $variant_name_dup.spd\]"
		    if { $df == "Stratix V" ||  $df == "Arria V GZ" } {                      
				puts $out "catch \{eval \[list exec \"\$ip_make_simscript\" --spd=\$ip_spd --spd=\$tb_spd --compile-to-work\]\} temp"
		    } else {
				puts $out "catch \{eval \[list exec \"\$ip_make_simscript\" --spd=\$ip_spd --spd=\$tb_spd\]\} temp"
		    }

                    puts $out "puts \$temp"
                } else {
                     puts $out "set ip_tx_spd \[file join $variant_name_tx $variant_name_tx.spd\]"
                     puts $out "set ip_rx_spd \[file join $variant_name_rx $variant_name_rx.spd\]"
		     if { $df == "Stratix V" ||  $df == "Arria V GZ" } {                    
				puts $out "catch \{eval \[list exec \"\$ip_make_simscript\" --spd=\$ip_tx_spd --spd=\$ip_rx_spd --spd=\$tb_spd --compile-to-work\]\} temp"
		     } else {
				puts $out "catch \{eval \[list exec \"\$ip_make_simscript\" --spd=\$ip_tx_spd --spd=\$ip_rx_spd --spd=\$tb_spd\]\} temp"
		     }
                    	puts $out "puts \$temp"
                }
            } else {
                puts $out $line
            }
        }
        close $in
        close $out

    }
    file copy $out_run_script_file $tmp_ex_design_dir_path
    file rename ${tmp_ex_design_dir_path}gen_ed_sim.tcl ${tmp_ex_design_dir_path}gen_sim_${sim_language}.tcl   	
    
    set sim_gen_log_file "log_generate_eds.txt"
    set sim_gen_log_path [create_temp_file $sim_gen_log_file]
    set fh [open $sim_gen_log_path "w"]
    set hw_tcl_dir [pwd]
    cd "${tmp_ex_design_dir_path}"

    set cmd [concat [list exec $quartus_sh_exe_path -t "${tmp_ex_design_dir_path}gen_sim_${sim_language}.tcl"]]
    set cmd_fail [catch { eval $cmd } tempresult]
    cd "$hw_tcl_dir"
    puts $fh $tempresult

    close $fh
	
    set sim_files [ls_recursive "${tmp_ex_design_dir_path}" "*"]
    foreach path $sim_files {
        set file [ string range $path [string length $tmp_ex_design_dir_path] [string length $path] ]
        add_fileset_file ed_sim/$file [get_file_type $file 0 0] PATH $path
    }
	  

    add_fileset_file ed_sim/$sim_gen_log_file OTHER PATH $sim_gen_log_path
}
    

proc add_cust_tb_components {tmp_tb_dir_path} {
    
    add_fileset_file ed_sim/tb_components/prbs_generator.v  VERILOG PATH ../example/common/prbs_generator.v
    add_fileset_file ed_sim/tb_components/prbs_poly.v       VERILOG PATH ../example/common/prbs_poly.v
    add_fileset_file ed_sim/tb_components/sink_reconfig.v   VERILOG PATH ../example/common/sink_reconfig.v
    add_fileset_file ed_sim/tb_components/source_reconfig.v VERILOG PATH ../example/common/source_reconfig.v   	
    add_fileset_file ed_sim/tb_components/traffic_check.v   VERILOG PATH ../example/common/traffic_check.v
    add_fileset_file ed_sim/tb_components/traffic_gen.sv    SYSTEM_VERILOG PATH ../example/common/traffic_gen.sv
	
    add_fileset_file ed_sim/tb_components/skew_insertion.sv  SYSTEM_VERILOG PATH ../example/example_tb/src/skew_insertion.sv
    add_fileset_file ed_sim/tb_components/test_data_forwarding.v VERILOG_INCLUDE PATH ../example/example_tb/src/test_data_forwarding.v
    add_fileset_file ed_sim/tb_components/test_env.v        VERILOG PATH ../example/example_tb/src/test_env.v
    add_fileset_file ed_sim/tb_components/test_sink_crc32_error.v VERILOG_INCLUDE PATH ../example/example_tb/src/test_sink_crc32_error.v
    add_fileset_file ed_sim/tb_components/test_sink_lane_alignment_init.v   VERILOG_INCLUDE PATH ../example/example_tb/src/test_sink_lane_alignment_init.v
    add_fileset_file ed_sim/tb_components/test_sink_lane_alignment_normal.v VERILOG_INCLUDE PATH ../example/example_tb/src/test_sink_lane_alignment_normal.v  
    add_fileset_file ed_sim/tb_components/test_sink_overflow_error.v  VERILOG_INCLUDE PATH ../example/example_tb/src/test_sink_overflow_error.v
    add_fileset_file ed_sim/tb_components/test_sink_underflow_error.v VERILOG_INCLUDE PATH ../example/example_tb/src/test_sink_underflow_error.v  	
    add_fileset_file ed_sim/tb_components/test_source_error.v VERILOG_INCLUDE PATH ../example/example_tb/src/test_source_error.v  
	add_fileset_file ed_sim/tb_components/testbench.sv SYSTEM_VERILOG PATH ../example/example_tb/src/testbench.sv
    add_fileset_file ed_sim/tb_components/testbench_defs.v VERILOG_INCLUDE PATH ../example/example_tb/src/testbench_defs.v
    add_fileset_file ed_sim/tb_components/tg_defs.v        VERILOG_INCLUDE PATH ../example/example_tb/src/tg_defs.v
    
    set filelocation [create_temp_file "def_param.v"]
    set out [ open $filelocation w ]
    set file_buffer ""  
    set cmode [get_parameter_value gui_clocking_mode]
    set dir [get_parameter_value direction]
    set df  [get_parameter_value system_family]
    set ecc_en  [get_parameter_value gui_ecc_enable]
    set ccf_val [get_parameter_value gui_actual_coreclkin_frequency]
    set icf_val [get_parameter_value gui_interface_clock_frequency]
    set addr [get_parameter_value ADDR_WIDTH]
    set user_input [get_parameter_value gui_user_input]
	
    if {$user_input == 0} {
       set ucf_val [get_parameter_value gui_user_clock_frequency]
    } else {
       set ucf_val [get_parameter_value gui_actual_user_clock_frequency]
    }

    if {$df == "Arria 10"} {
       append file_buffer "`define SERIALLITE_III_FOR_A10 \n"
    }
    append file_buffer "`define  XCVR_LANES         [get_parameter_value lanes] \n"   
    set suffix e6
    set ucf_str $ucf_val$suffix
  
    append file_buffer "`define  META_FRAME_LEN     [get_parameter_value meta_frame_length] \n"   
    set xcvr_clk_freq_mhz "[get_parameter_value pll_ref_freq]"
    append file_buffer "`define  XCVR_REF_CLK_FREQ  \"$xcvr_clk_freq_mhz\" \n"   
    set ref_freq [string trimright $xcvr_clk_freq_mhz " MHz"]
    set suffix e6
    set ref_freq_var  $ref_freq$suffix
    append file_buffer "`define  XCVR_REF_CLK_VAR   $ref_freq_var \n"   
    set xcvr_out_rate [format %.4f [expr [get_parameter_value lane_rate_parameter]*1000]]
    set suffix " Mbps" 
    append file_buffer "`define  XCVR_DATA_RATE     \"$xcvr_out_rate$suffix\" \n"   
    
    if {$ecc_en} {
       set ecc_val 1
       #for source_error test
       append file_buffer "`define  ECC_ON\n"
    } else {
       set ecc_val 0
    }	  
    append file_buffer "`define  ECC_ENABLE_VAL  $ecc_val \n"
    append file_buffer "`define  BURST_GAP  [get_parameter_value BURST_GAP]  \n"
    
	if {$dir == "Duplex"} {
       append file_buffer "`define DUPLEX_MODE \n"
    }
    
	if {$cmode == "true"} {
       append file_buffer "`define ADVANCED_CLOCKING \n"
       append file_buffer "`define  USER_CLK_FREQ      $ucf_str \n"
    } else {
       append file_buffer "`define  USER_CLK_FREQ      \"$ucf_val MHz\" \n"
    }
    
    append file_buffer "`define  ADDRESS_WIDTH  $addr \n"
    append file_buffer "`define CORECLKIN_FREQ   \"[get_parameter_value gui_actual_coreclkin_frequency] MHz \" \n"

    if {$df == "Arria 10"} {
       append file_buffer "`define REFCLK_FREQ   \"[get_parameter_value int_reference_clock_frequency] MHz \" \n" 
    } else {
       append file_buffer "`define REFCLK_FREQ   \"[get_parameter_value gui_reference_clock_frequency] MHz \" \n" 
    }

  
    puts $out $file_buffer
    close $out
    add_fileset_file ed_sim/tb_components/def_a10.v  VERILOG PATH  $filelocation
    
    set tb_spd [create_temp_file tb.spd]
    set out_tb_spd [ open $tb_spd w ] 
    puts $out_tb_spd "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" 
    puts $out_tb_spd "<simPackage>"
    puts $out_tb_spd "<file path=\"def_a10.v\" type=\"VERILOG\" />"
    puts $out_tb_spd "<file path=\"skew_insertion.sv\" type=\"SYSTEM_VERILOG\" />"
    puts $out_tb_spd "<file path=\"prbs_generator.v\" type=\"VERILOG\" />"
    puts $out_tb_spd "<file path=\"prbs_poly.v\" type=\"VERILOG\" />"
    puts $out_tb_spd "<file path=\"sink_reconfig.v\" type=\"VERILOG\" />"
    puts $out_tb_spd "<file path=\"source_reconfig.v\" type=\"VERILOG\" />"
    puts $out_tb_spd "<file path=\"traffic_check.v\" type=\"VERILOG\"><include path = \"testbench_defs.v\" /></file>"
    puts $out_tb_spd "<file path=\"traffic_gen.sv\" type=\"SYSTEM_VERILOG\"><include path = \"testbench_defs.v\" /></file>"
    puts $out_tb_spd "<file path=\"test_env.v\"    type=\"VERILOG\"><include path = \"def_a10.v\" /></file>"
    puts $out_tb_spd "<file path=\"testbench.sv\" type=\"SYSTEM_VERILOG\"><include path = \"testbench_defs.v\" /><include path = \"def_a10.v\" /><include path = \"test_data_forwarding.v\" /><include path = \"test_source_error.v\" /><include path = \"test_sink_crc32_error.v\" /><include path = \"test_sink_lane_alignment_normal.v\" /></file>"
    puts $out_tb_spd "<topLevel name=\"test_env\" />"
    puts $out_tb_spd "</simPackage>"
    close $out_tb_spd
    
    file copy $tb_spd $tmp_tb_dir_path
}


proc get_source_script {simulator} {
   if {$simulator == "aldec"} {
      return "rivierapro_setup.tcl"
   } elseif {$simulator == "cadence"} {
      return "ncsim_setup.sh"
   } elseif {$simulator == "mentor"} {
      return "msim_setup.tcl"
   } elseif {$simulator == "vcsmx" } {
      return "vcsmx_setup.sh"   
   } else {
      #vcs
      return "vcs_setup.sh"
   }
}

# This proc do the following tasks:
# - Creates testbench run script
# - Create waveform do file that is called in testbench run script

proc add_run_tb_scripts {} {
     
    # Testbench run script
    set supported_simulators {"mentor" "vcsmx" "vcs" "aldec" "cadence"}

    foreach simulator $supported_simulators {
        # mentor & aldec support
        if {$simulator == "mentor" || $simulator == "aldec"} {
            set run_tb_script_output_file [create_temp_file run_tb.tcl]
            set out [ open $run_tb_script_output_file w ]
            set simulator_source_script [get_source_script $simulator]

            #puts $out "set USER_DEFINED_COMPILE_OPTIONS \"+define+SIMULATION\""
            puts $out "source ./$simulator_source_script"
            puts $out "ld"
            puts $out "run -all"

            close $out
            add_fileset_file ed_sim/$simulator/run_tb.tcl OTHER PATH $run_tb_script_output_file

        } elseif {$simulator == "vcsmx"} {
            #vcsmx support
            set run_script_output_file [create_temp_file run_tb.sh]
            set out [ open $run_script_output_file w ]
            set simulator_source_script [get_source_script $simulator]

            puts $out "source ./$simulator_source_script \\"
            #puts $out "USER_DEFINED_COMPILE_OPTIONS=\"+define+SIMULATION\" \\"
            puts $out "USER_DEFINED_SIM_OPTIONS=\"+vcs+finish+2ms\""

            close $out
            add_fileset_file ed_sim/synopsys/$simulator/run_tb.sh OTHER PATH $run_script_output_file

        } elseif {$simulator == "vcs"} {
            #vcs support     
            set run_script_output_file [create_temp_file run_tb.sh]
            set out [ open $run_script_output_file w ]
            set simulator_source_script [get_source_script $simulator]

            puts $out "source ./$simulator_source_script \\"
            #puts $out "USER_DEFINED_ELAB_OPTIONS=\"+define+SIMULATION\" \\"
            puts $out "USER_DEFINED_SIM_OPTIONS=\"+vcs+finish+2ms\""

            close $out
            add_fileset_file ed_sim/synopsys/$simulator/run_tb.sh OTHER PATH $run_script_output_file 

        } elseif {$simulator == "cadence"} {
            #cadence support
            set run_script_output_file [create_temp_file run_tb.sh]
            set out [ open $run_script_output_file w ]
            set simulator_source_script [get_source_script $simulator]

            puts $out "source ./$simulator_source_script TOP_LEVEL_NAME=\"test_env\""
            #puts $out "USER_DEFINED_COMPILE_OPTIONS=\"+define+SIMULATION\" \\"
            #puts $out "USER_DEFINED_SIM_OPTIONS=\"-input \\\"@run 2ms; exit\\\"\""
            puts $out "ncelab -timescale 1ps/1ps -access +w+r+c -namemap_mixgen -relax \$TOP_LEVEL_NAME"
	    puts $out "ncsim -licqueue \$TOP_LEVEL_NAME"

            close $out

            add_fileset_file ed_sim/$simulator/run_tb.sh OTHER PATH $run_script_output_file
        }

    }
}

proc get_file_type {file_name {rtl_only 1} {encrypted 0}} {

   set file_ext [file extension $file_name]

   if {[regexp -nocase {^[ ]*\.iv[ ]*$} [file extension $file_name]] == 1 } {
      return "VERILOG_INCLUDE"
   } elseif {[regexp -nocase {^[ ]*\.v[ ]*$} [file extension $file_name]] == 1 } {
      if {$encrypted} {
         return "VERILOG_ENCRYPT"
      } else {
         return "VERILOG"
      }
   } elseif {[regexp -nocase {^[ ]*\.sv[ ]*$} [file extension $file_name]] == 1 } {
      if {$encrypted} {
         return "SYSTEM_VERILOG_ENCRYPT"
      } else {
         return "SYSTEM_VERILOG"
      }
   } elseif {[regexp -nocase {^[ ]*\.vho[ ]*$|^[ ]*\.vhd[ ]*$|^[ ]*\.vhdl[ ]*$} [file extension $file_name]] == 1 } {
      return "VHDL"
   } elseif {[regexp -nocase {^[ ]*\.mif[ ]*$} [file extension $file_name]] == 1 } {

         return "MIF"

   } elseif {[regexp -nocase {^[ ]*\.hex[ ]*$} [file extension $file_name]] == 1 } {
      if {$rtl_only} {
         emif_ie "Attempting to return file type $file_ext for file $file_name in RTL only fileset"
      } else {
         return "HEX"
      }
   } elseif {[regexp -nocase {^[ ]*\.dat[ ]*$} [file extension $file_name]] == 1 } {
      if {$rtl_only} {
         emif_ie "Attempting to return file type $file_ext for file $file_name in RTL only fileset"
      } else {
         return "DAT"
      }
   } elseif {[regexp -nocase {^[ ]*\.sdc[ ]*$} [file extension $file_name]] == 1 } {
      if {$rtl_only} {
         emif_ie "Attempting to return file type $file_ext for file $file_name in RTL only fileset"
      } else {
         return "SDC"
      }
   } elseif {[regexp -nocase {^[ ]*\.xml[ ]*$} [file extension $file_name]] == 1 } {
      if {$rtl_only} {
         emif_ie "Attempting to return file type $file_ext for file $file_name in RTL only fileset"
      } else {
         return "HPS_ISW"
      }
   } else {
      if {$rtl_only} {
         emif_ie "Attempting to return file type $file_ext for file $file_name in RTL only fileset"
      } else {
         return "OTHER"
      }
   }
}

proc ls_recursive {base glob} {
   set files [list]

   foreach f [glob -nocomplain -types f -directory $base $glob] {
      set file_path [file join $base $f]
      lappend files $file_path
   }

   foreach d [glob -nocomplain -types d -directory $base *] {
      set files_recursive [ls_recursive [file join $base $d] $glob]
      lappend files {*}$files_recursive
   }

   return $files
}
