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


    foreach {language sim_language} $hdl {
        set dut_device_family [get_parameter_value DEVICE_FAMILY]  
        if {![string compare $dut_device_family "Arria 10"]} {
            set dut_device_part "10AX115R3F40I2LG"
        } elseif {![string compare $dut_device_family "Stratix 10"]} {
            set dut_device_part "ND5_40_PART1"
        }

        set verilog_run_script_file "$ed_sim_scripts_dir/gen_ed_sim_a10.tcl"
        set verilog_output_run_script_file [create_temp_file gen_ed_sim.tcl]
        set out [ open $verilog_output_run_script_file w ]
        set in [open $verilog_run_script_file r]

        while {[gets $in line] != -1} {
            if {[string match "*DUT_PARAMETERS*" $line]} {
                puts $out $line         
                puts $out "set variant_name $entityname"
                puts $out "set dut_device_family \"$dut_device_family\""
                puts $out "set dut_device_part \"$dut_device_part\""
                if {![string compare $language "verilog"]} {
                    puts $out "set sim_gen \"VERILOG\""  
                } elseif {![string compare $language "vhdl"]} {
                    puts $out "set sim_gen \"VHDL\""  
                } else {
                    puts $out "set sim_gen \"VERILOG\"" }
            } else {
                puts $out $line }
        }
        close $in
        close $out
        add_fileset_file ed_sim/gen_ed_sim_$language.tcl OTHER PATH $verilog_output_run_script_file


        set verilog_run_script_file "$ed_synth_dir/gen_quartus_synth_a10.tcl"
        set verilog_output_run_script_file [create_temp_file gen_quartus_synth.tcl]
        set out [ open $verilog_output_run_script_file w ]
        set in [open $verilog_run_script_file r]

        while {[gets $in line] != -1} {
            if {[string match "*DUT_PARAMETERS*" $line]} {
                puts $out $line         
                puts $out "set variant_name $entityname"
                puts $out "set dut_device_family \"$dut_device_family\""
                puts $out "set dut_device_part \"$dut_device_part\""
                if {![string compare $language "verilog"]} {
                    puts $out "set sim_gen \"VERILOG\""  
                } elseif {![string compare $language "vhdl"]} {
                    puts $out "set sim_gen \"VHDL\""  
                } else {
                    puts $out "set sim_gen \"VERILOG\"" }
            } else {
                puts $out $line }
        }
        close $in
        close $out
        add_fileset_file ed_synth/gen_quartus_synth_$language.tcl OTHER PATH $verilog_output_run_script_file

    }

   
# This proc do the following tasks:
# - Creates testbench run script
# - Create waveform do file that is called in testbench run script

proc add_tb_top_scripts {entityname tbdir ed_sim_scripts_dir} {
     
    # Testbench run script
    set supported_simulators {"mentor" "vcsmx" "vcs" "aldec" "cadence"}
    foreach simulator $supported_simulators {
        # mentor & aldec support
        if {$simulator == "mentor" || $simulator == "aldec"} {
            set run_tb_script "$ed_sim_scripts_dir/run_tb_top.tcl"
            set run_tb_script_output_file [create_temp_file run_tb_top.tcl]
            set tb_out [ open $run_tb_script_output_file w ]
            set tb_in [open $run_tb_script r]
            set simulator_source_script [get_source_script $simulator]

            while {[gets $tb_in line] != -1} {
                if {[string match "*RUN_SCRIPT_PARAMETERS*" $line]} {
                    puts $tb_out $line
                    # Patch run script with suitable parameter value
                    puts $tb_out "set SETUP_SCRIPTS ../setup_scripts"
                    puts $tb_out "set tb_top_waveform tb_top_waveform.do"
                    puts $tb_out "set testbench_model_dir ../models"
	                puts $tb_out "set dir ./../ "
   
                } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
                    puts $tb_out "source \$SETUP_SCRIPTS/$simulator/$simulator_source_script"

                } elseif {[string match "*TESTBENCH_COMPILE_COMMAND*" $line]} {
                    #puts $out "vlog -sv -work work +incdir+\$testbench_model_dir \$testbench_model_dir/*.sv"
                    #puts $tb_out "vlog -sv -work work +incdir+\$testbench_model_dir \$testbench_model_dir/*.v"

                } elseif {[string match "*MODELSIM_FIX*" $line]} {
	                if {$simulator == "mentor"} {
                        puts $tb_out  "# Some packages file has changed. Refresh the work libraries (Vsim-13)"
                        puts $tb_out  "vlog -work work -refresh -force_refresh"	       
	                }
            
                } else {
                    puts $tb_out $line
                }
            }
            close $tb_in
            close $tb_out
            #add_fileset_file ip_sim/testbench/$simulator/run_$entityname\_tb.tcl OTHER PATH $run_script_output_file 
	        add_fileset_file ed_sim/testbench/$simulator/run_tb_top.tcl OTHER PATH $run_tb_script_output_file

            # Waveform do file
            set wave_ed_do "$ed_sim_scripts_dir/wave_ed.do"
            set wave_ed_do_output_file [create_temp_file tb_top_wave_ed.do]
            set top_out [ open $wave_ed_do_output_file w ]
            set top_in [open $wave_ed_do r]

            while {[gets $top_in line] != -1} {
                puts $top_out $line
            }
            close $top_in
            close $top_out
            #file copy -force $tbdir/wave_ed.do ed_sim/testbench/$simulator/
	 
            #add_fileset_file ip_sim/testbench/$simulator/$entityname\_wave.do OTHER PATH $wave_do_output_file 
	        #add_fileset_file ed_sim/testbench/$simulator/tb_top_waveform.do OTHER PATH $ed_sim_scripts_dir/tb_top_waveform.do
	        add_fileset_file ed_sim/testbench/$simulator/tb_top_waveform.do OTHER PATH $wave_ed_do_output_file

        } elseif {$simulator == "vcsmx"} {
	        #vcsmx support     
            set run_script "$ed_sim_scripts_dir/run_tb.sh"
            set run_script_output_file [create_temp_file run_tb_top.sh]
            set out [ open $run_script_output_file w ]
            set in [open $run_script r]
            set simulator_source_script [get_source_script $simulator]

            while {[gets $in line] != -1} {
                if {[string match "*RUN_SCRIPT_PARAMETERS*" $line]} {
                    puts $out $line
                    # Patch run script with suitable parameter value
                    puts $out "SETUP_SCRIPTS=\"../../setup_scripts/synopsys/$simulator/$simulator_source_script\""
                    puts $out "dut_wave_do=\"tb_top_wave_ed.do\""
                    puts $out "testbench_model_dir=\"../../models\""
                    puts $out "modules_dir=\"./../../\""
   
                } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
	                puts $out "cp ../../setup_scripts/synopsys/$simulator/synopsys_sim.setup ."
                    puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_top\" SKIP_ELAB=1 SKIP_SIM=1"

                } elseif {[string match "*TESTBENCH_COMPILE_COMMAND*" $line]} {
                    # puts $out "vlogan +v2k -sverilog -work work  \$testbench_model_dir/*.sv"
                    puts $out "vlogan +v2k -sverilog -work work" 

                } else {
                    puts $out $line
                }
            }
	        close $in
            close $out
            #add_fileset_file ip_sim/testbench/synopsys/$simulator/run_$entityname\_tb.sh OTHER PATH $run_script_output_file 
	        add_fileset_file ed_sim/testbench/synopsys/$simulator/run_tb_top.sh OTHER PATH $run_script_output_file
    
            # Waveform do file
            set wave_ed_do "$ed_sim_scripts_dir/wave_vcsmx_ed.do"
            set wave_ed_do_output_file [create_temp_file tb_top_wave_ed.do]
            set out [ open $wave_ed_do_output_file w ]
            set in [open $wave_ed_do r]

            while {[gets $in line] != -1} {
                puts $out $line
            }

            close $in
            close $out
         
	        add_fileset_file ed_sim/testbench/synopsys/$simulator/tb_top_wave_ed.do OTHER PATH $wave_ed_do_output_file 

        } elseif {$simulator == "vcs"} {
	        #vcs support     
            set run_script "$ed_sim_scripts_dir/run_tb_top.sh"
            set run_script_output_file [create_temp_file run_tb_top.sh]
            set out [ open $run_script_output_file w ]
            set in [open $run_script r]
            set simulator_source_script [get_source_script $simulator]

            while {[gets $in line] != -1} {
                if {[string match "*RUN_SCRIPT_PARAMETERS*" $line]} {
                    puts $out $line
                    # Patch run script with suitable parameter value
                    puts $out "SETUP_SCRIPTS=\"../../setup_scripts/synopsys/$simulator/$simulator_source_script\""
                    puts $out "dut_wave_do=\"tb_top_wave_ed.do\""
                    puts $out "testbench_model_dir=\"../../models\""
                    puts $out "modules_dir=\"./../../\""
   
                } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
                    puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_top\" SKIP_ELAB=1 SKIP_SIM=1 USER_DEFINED_ELAB_OPTIONS=\"-debug_pp\" "
       
                } elseif {[string match "*TESTBENCH_SIM*" $line]} {
                    puts $out "./simv -ucli -l sim.log -do \$dut_wave_do"
                } else {
                    puts $out $line
                }
            }
	        close $in
            close $out
            add_fileset_file ed_sim/testbench/synopsys/$simulator/run_tb_top.sh OTHER PATH $run_script_output_file 
    
            # Waveform do file
            set wave_do "$ed_sim_scripts_dir/wave_vcsmx_ed.do"
            set wave_do_output_file [create_temp_file tb_top_wave_ed.do]
            set out [ open $wave_ed_do_output_file w ]
            set in [open $wave_ed_do r]

            while {[gets $in line] != -1} {
                puts $out $line
            }

            close $in
            close $out
            add_fileset_file ed_sim/testbench/synopsys/$simulator/tb_top_wave_ed.do OTHER PATH $wave_ed_do_output_file 

        } elseif {$simulator == "cadence"} {
	        #cadence support     
            set run_script "$ed_sim_scripts_dir/run_tb_top.sh"
            set run_script_output_file [create_temp_file run_tb_top.sh]
            set out [ open $run_script_output_file w ]
            set in [open $run_script r]
            set simulator_source_script [get_source_script $simulator]

            while {[gets $in line] != -1} {
                if {[string match "*RUN_SCRIPT_PARAMETERS*" $line]} {
                    puts $out $line
                    # Patch run script with suitable parameter value
                    puts $out "SETUP_SCRIPTS=\"../setup_scripts/$simulator/$simulator_source_script\""
                    puts $out "dut_wave_do=\"tb_top_wave.tcl\""
                    puts $out "testbench_model_dir=\"../models\""
   
                } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
                    # puts $out ""
                    puts $out "cp ../setup_scripts/$simulator/cds.lib ."
                    puts $out "cp -rf ../setup_scripts/$simulator/cds_libs ."
                    puts $out "cp ../setup_scripts/$simulator/hdl.var ."
                    puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_top\" SKIP_ELAB=1 SKIP_SIM=1"

                } elseif {[string match "*TESTBENCH_ELAB*" $line]} {
                    # puts $out "ncvlog -sv -work work  \$testbench_model_dir/*.sv"
                    puts $out "ncelab -timescale 1ns/1ps -access +w+r+c -namemap_mixgen -relax \$TOP_LEVEL_NAME"
            
                } elseif {[string match "*TESTBENCH_SIM*" $line]} {
                    puts $out "ncsim -tcl -input \$dut_wave_do \$TOP_LEVEL_NAME"

                } else {
                    puts $out $line
                }
            }
	        close $in
            close $out
            #add_fileset_file ip_sim/testbench/$simulator/run_$entityname\_tb.sh OTHER PATH $run_script_output_file 
	        add_fileset_file ed_sim/testbench/$simulator/run_tb_top.sh OTHER PATH $run_script_output_file
    
            # Waveform tcl file
            set wave_ed_do "$ed_sim_scripts_dir/wave.tcl"
            set wave_ed_do_output_file [create_temp_file tb_top_wave.tcl]
            set out [ open $wave_ed_do_output_file w ]
            set in [open $wave_ed_do r]

            while {[gets $in line] != -1} {
            puts $out $line
            }

            close $in
            close $out

	        add_fileset_file ed_sim/testbench/$simulator/tb_top_wave.tcl OTHER PATH $wave_ed_do_output_file
        }

    }
}

