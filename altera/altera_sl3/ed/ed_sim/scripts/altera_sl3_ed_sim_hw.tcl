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
    set ed_sim_scripts_dir "${qdir}/../ip/altera/altera_sl3/ed/ed_sim/scripts"
    set ed_synth_dir       "${qdir}/../ip/altera/altera_sl3/ed/ed_synth"
    set common_dir         "${qdir}/../ip/altera/altera_sl3/ed/common"
    set tmpdir             "."
    set dir                [get_parameter_value direction]
    set df                 [get_parameter_value system_family]
    set language           [get_parameter_value SELECT_ED_FILESET]
    set user_input         [get_parameter_value gui_user_input]
    set tmp_dir_path [create_temp_file ""]
    set tmp_ex_design_dir_path "${tmp_dir_path}tmp_ex_design/"
    set tmp_tb_dir_path        "${tmp_ex_design_dir_path}/tb_components/"
    file mkdir $tmp_ex_design_dir_path
    file mkdir $tmp_tb_dir_path
    set entityname "altera_sl3_tb"
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
        set dir_qsys {"Duplex" "dup"}
    } else {
        set dir_qsys {"Tx" "tx" "Rx" "rx"}
    }

    set variant_name_tx "altera_sl3_tx"
    set variant_name_rx "altera_sl3_rx"
    set variant_name_dup "altera_sl3_dup"

    # Create QSYS script for IP core
    foreach {dir_qsys_tcl tail_output_name} $dir_qsys {
        set output_name "altera_sl3_${tail_output_name}"
        set gen_ip_qsys_script_file [create_temp_file gen_qsys.tcl]
        set out_ip_qsys_tcl [ open $gen_ip_qsys_script_file w ]
        puts $out_ip_qsys_tcl "package require \-exact qsys 14.1"
        puts $out_ip_qsys_tcl "create_system"
        puts $out_ip_qsys_tcl "set_project_property DEVICE_FAMILY \"[get_parameter_value "system_family"]\""
        puts $out_ip_qsys_tcl "add_instance $output_name altera_sl3"
        puts $out_ip_qsys_tcl "set_instance_property $output_name AUTO_EXPORT 1"

        foreach {param_name} [get_parameters] {
            set is_derived_param [get_parameter_property $param_name DERIVED]
            set param_value [get_parameter_value $param_name]
               
            # Print out the DUT parameters that are not derived
            if {$is_derived_param == 1} {
                continue
            } elseif {[string match "*DIRECTION*" $param_name]} {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name \"$dir_qsys_tcl\""
            } else {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name \"[get_parameter_value "$param_name"]\""
            }
        }
        puts $out_ip_qsys_tcl "save_system $output_name"
        close $out_ip_qsys_tcl
        file copy $gen_ip_qsys_script_file $tmp_ex_design_dir_path
        file rename ${tmp_ex_design_dir_path}gen_qsys.tcl ${tmp_ex_design_dir_path}gen_qsys_altera_sl3_${tail_output_name}.tcl   
    }
    set lanes [get_parameter_value "LANES"]
    set atx_pll_output_name "altera_sl3_atx_pll"
    set gen_qsys_pll_script_file [create_temp_file gen_qsys_atx_pll.tcl]
    set out_qsys_pll_tcl [ open $gen_qsys_pll_script_file w ]
	set atx_pll_outclk_freq [expr {[get_parameter_value "lane_rate_recommended"]*1000/2}]
	puts $out_qsys_pll_tcl "package require \-exact qsys 14.1"
	puts $out_qsys_pll_tcl "create_system"
    puts $out_qsys_pll_tcl "set_project_property DEVICE_FAMILY \"[get_parameter_value "system_family"]\""
    puts $out_qsys_pll_tcl "add_instance $atx_pll_output_name altera_xcvr_atx_pll_s10"
    puts $out_qsys_pll_tcl "set_instance_property $atx_pll_output_name AUTO_EXPORT 1"
    ##puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name part_trait_device \"[get_parameter_value "part_trait_device"]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name device_family \"[get_parameter_value "system_family"]\"" 
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name set_output_clock_frequency $atx_pll_outclk_freq"
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name set_auto_reference_clock_frequency \"[get_parameter_value "gui_pll_ref_freq"]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name usr_analog_voltage \"[get_parameter_value "gui_analog_voltage"]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name enable_mcgb \"[expr {$lanes > 6 ? 1 : 0}]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name enable_hfreq_clk \"[expr {$lanes > 6 ? 1 : 0}]\""
    puts $out_qsys_pll_tcl "save_system $atx_pll_output_name"
    close $out_qsys_pll_tcl
		
    file copy $gen_qsys_pll_script_file $tmp_ex_design_dir_path
    file rename ${tmp_ex_design_dir_path}gen_qsys_atx_pll.tcl ${tmp_ex_design_dir_path}gen_qsys_altera_sl3_atx_pll.tcl   
	
    foreach {sim_language} $hdl {

        set out_run_script_file [create_temp_file gen_ed_sim.tcl]
 
        set out [ open $out_run_script_file w ]
        set in [ open ../../ed/ed_sim/scripts/gen_ed_sim.tcl r]

        while {[gets $in line] != -1} {
            if {[string match "*gen_IP_QSYS*" $line]} {
                # gen_IP_QSYS (qsys-script)
                puts $out $line
                if {$dir == "Duplex"} {
                    puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_altera_sl3_dup.tcl \]\} temp"
                    puts $out "puts \$temp"
                } else {
                    puts $out "set qsys_tcl_script_tx \[file join gen_qsys_altera_sl3_tx.tcl\]"
                    puts $out "set qsys_tcl_script_rx \[file join gen_qsys_altera_sl3_rx.tcl\]"
                    puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=\$qsys_tcl_script_tx\]\} temp"
                    puts $out "puts \$temp"
                    puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=\$qsys_tcl_script_rx\]\} temp"
                    puts $out "puts \$temp"
                }
                puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_altera_sl3_atx_pll.tcl \]\} temp"
                puts $out "puts \$temp"				
            } elseif {[string match "*gen_IP*" $line]} {
                # gen_IP (qsys-generate)
                puts $out $line
                if {$dir == "Duplex"} {
                    puts $out "set output_dir_dup \[file join $variant_name_dup\]"
                    puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_dup.ip --simulation=$sim_language --output-directory=\$output_dir_dup\]\} temp"
                    puts $out "puts \$temp"
                } else {
                    puts $out "set output_dir_tx \[file join $variant_name_tx\]"
                    puts $out "set output_dir_rx \[file join $variant_name_rx\]"
                    puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_tx.ip --simulation=$sim_language --output-directory=\$output_dir_tx\]\} temp"
                    puts $out "puts \$temp"
                    puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_rx.ip --simulation=$sim_language --output-directory=\$output_dir_rx\]\} temp"
                    puts $out "puts \$temp"
                }
                puts $out "set output_dir_pll \[file join altera_sl3_atx_pll\]"
                puts $out "catch \{eval \[list exec \"\$qsys_generate\" altera_sl3_atx_pll.ip --simulation=$sim_language --output-directory=\$output_dir_pll\]\} temp"
                puts $out "puts \$temp"
            } elseif {[string match "*gen_simscript*" $line]} {
                # gen_simscript
                puts $out $line
                if {$dir == "Duplex"} {
                    puts $out "set ip_spd \[file join $variant_name_dup $variant_name_dup.spd\]"
                    puts $out "set atx_pll_spd \[file join altera_sl3_atx_pll altera_sl3_atx_pll.spd\]"
                    puts $out "catch \{eval \[list exec \"\$ip_make_simscript\" --spd=\$ip_spd --spd=\$atx_pll_spd --spd=\$tb_spd \]\} temp"
                    puts $out "puts \$temp"
                } else {
                    puts $out "set ip_tx_spd \[file join $variant_name_tx $variant_name_tx.spd\]"
                    puts $out "set ip_rx_spd \[file join $variant_name_rx $variant_name_rx.spd\]"
                    puts $out "set atx_pll_spd \[file join altera_sl3_atx_pll altera_sl3_atx_pll.spd\]"
                    puts $out "catch \{eval \[list exec \"\$ip_make_simscript\" --spd=\$ip_tx_spd --spd=\$ip_rx_spd --spd=\$atx_pll_spd --spd=\$tb_spd \]\} temp"
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

    #Do Terp
    set lanes             [get_parameter_value "LANES"]
    set file_test_env_path [file join "../../ed/ed_sim/src/" "test_env.sv.terp"]
    set params_test_env(lanes) $lanes
    set template_test_env_v [ read [ open $file_test_env_path r ] ]
    set result_test_env   [ altera_terp $template_test_env_v params_test_env ]

    add_fileset_file ed_sim/tb_components/test_env.sv SYSTEM_VERILOG TEXT $result_test_env 
    #add_fileset_file ed_sim/tb_components/test_env.sv SYSTEM_VERILOG PATH ../../ed/ed_sim/src/test_env.sv
    add_fileset_file ed_sim/tb_components/testbench.sv SYSTEM_VERILOG PATH ../../ed/ed_sim/src/testbench.sv
    add_fileset_file ed_sim/tb_components/skew_insertion.sv SYSTEM_VERILOG PATH ../../ed/ed_sim/src/skew_insertion.sv
    add_fileset_file ed_sim/tb_components/test_data_forwarding.v VERILOG_INCLUDE PATH ../../ed/ed_sim/src/test_data_forwarding.v
    add_fileset_file ed_sim/tb_components/testbench_defs.v VERILOG_INCLUDE PATH ../../ed/ed_sim/src/testbench_defs.v
    add_fileset_file ed_sim/tb_components/prbs_generator.v VERILOG PATH ../../ed/common/prbs_generator.v
    add_fileset_file ed_sim/tb_components/prbs_poly.v VERILOG PATH ../../ed/common/prbs_poly.v
    add_fileset_file ed_sim/tb_components/traffic_check.v VERILOG PATH ../../ed/common/traffic_check.v
    add_fileset_file ed_sim/tb_components/traffic_gen.sv SYSTEM_VERILOG PATH ../../ed/common/traffic_gen.sv

    # Create tb_params package
    set tb_params_pkg [create_temp_file altera_sl3_tb_params.sv]
    set out_tb_params [ open $tb_params_pkg w ]
    set in_tb_params [open ../../ed/ed_sim/src/altera_sl3_tb_params.sv r]
    set user_input [get_parameter_value gui_user_input]
	
    while {[gets $in_tb_params line] != -1} {
        if {[string match "*USER_CLOCK_FREQUENCY*" $line]} {
		    if {$user_input == 1} {
			    puts $out_tb_params "   parameter  USER_CLOCK_FREQUENCY       = [get_parameter_value "gui_actual_user_clock_frequency"]e6;"
            } else {
                puts $out_tb_params "   parameter  USER_CLOCK_FREQUENCY       = [get_parameter_value "gui_user_clock_frequency"]e6;"
            }
        } elseif {[string match "*LANES*" $line]} {
            puts $out_tb_params "   parameter  LANES                      = [get_parameter_value "LANES"];"
        } elseif {[string match "*PLL_REF_FREQ*" $line]} {
            puts $out_tb_params "   parameter  PLL_REF_FREQ               = [get_parameter_value "gui_pll_ref_freq"]e6;"
        } elseif {[string match "*ECC_EN*" $line]} {
            puts $out_tb_params "   parameter  ECC_EN                     = [expr { [ string compare -nocase [get_parameter_value "gui_ecc_enable"] true ] == 0 ?  1 : 0}];"
        } elseif {[string match "*BURST_GAP*" $line]} {
            puts $out_tb_params "   parameter  BURST_GAP                  = [get_parameter_value "BURST_GAP"];"
        } elseif {[string match "*ADDRESS_WIDTH*" $line]} {
            puts $out_tb_params "   parameter  ADDRESS_WIDTH              = [get_parameter_value "ADDR_WIDTH"];"
        } elseif {[string match "*DIRECTION*" $line]} {
            puts $out_tb_params "   parameter  DIRECTION                  = \"[get_parameter_value "DIRECTION"]\";"
        } elseif {[string match "*STREAM*" $line]} {
            puts $out_tb_params "   parameter  STREAM                     = \"[get_parameter_value "STREAM"]\";"
        } elseif {[string match "*ADVANCED_CLOCKING*" $line]} {
            puts $out_tb_params "   parameter  ADVANCED_CLOCKING          = [expr { [ string compare -nocase [get_parameter_value "gui_clocking_mode"] true ] == 0 ?  1 : 0}];"
        } else {
            puts $out_tb_params $line
        }

    }
    close $in_tb_params
    close $out_tb_params
    add_fileset_file ed_sim/tb_components/altera_sl3_tb_params.sv SYSTEM_VERILOG PATH $tb_params_pkg
    
	set tb_spd [create_temp_file tb.spd]
    set out_tb_spd [ open $tb_spd w ] 
    puts $out_tb_spd "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" 
    puts $out_tb_spd "<simPackage>"
    puts $out_tb_spd "<file path=\"altera_sl3_tb_params.sv\" type=\"SYSTEM_VERILOG\" />"
    puts $out_tb_spd "<file path=\"skew_insertion.sv\" type=\"SYSTEM_VERILOG\" />"
    puts $out_tb_spd "<file path=\"prbs_generator.v\" type=\"VERILOG\" />"
    puts $out_tb_spd "<file path=\"prbs_poly.v\" type=\"VERILOG\" />"
    puts $out_tb_spd "<file path=\"traffic_check.v\" type=\"VERILOG\"><include path = \"testbench_defs.v\" /></file>"
    puts $out_tb_spd "<file path=\"traffic_gen.sv\" type=\"SYSTEM_VERILOG\"><include path = \"testbench_defs.v\" /></file>"
    puts $out_tb_spd "<file path=\"test_env.sv\"    type=\"SYSTEM_VERILOG\"><include path = \"def_a10.v\" /></file>"
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

            puts $out "source ./$simulator_source_script SKIP_ELAB=1 SKIP_SIM=1 TOP_LEVEL_NAME=\"test_env\""
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
