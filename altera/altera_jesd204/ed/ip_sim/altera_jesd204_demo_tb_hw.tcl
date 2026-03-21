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


#################################################################################################
# Testbench generator using EXAMPLE_DESIGN fileset callback
##################################################################################################



add_fileset example_design EXAMPLE_DESIGN exampledesignproc

proc exampledesignproc {name} {
   global env
   
   set qdir $env(QUARTUS_ROOTDIR)
   set tbdir "${qdir}/../ip/altera/altera_jesd204/ed/ip_sim"
   set ed_sim_scripts_dir "${qdir}/../ip/altera/altera_jesd204/ed/ed_sim/scripts"
   set ed_sim_dir "${qdir}/../ip/altera/altera_jesd204/ed/ed_sim"
   set ed_synth_dir "${qdir}/../ip/altera/altera_jesd204/ed/ed_synth"
   set nios_dir "${qdir}/../ip/altera/altera_jesd204/ed/ed_nios"
   set tmpdir "."
   set entityname "altera_jesd204"
   set hdl {
      verilog  SIM_VERILOG
      vhdl     SIM_VHDL
   }
    
    set ED_TYPE [get_parameter_value "ED_TYPE"]
    
    set generic_ed_type ""
    if {[param_matches DEVICE_FAMILY "Arria 10"]} {
        set generic_ed_type [get_parameter_value ED_GENERIC_A10]
    } else {
        set generic_ed_type [get_parameter_value ED_GENERIC_5SERIES]
    }
    
    # block example design generation when both available and generic example design set to none/no
    if {[string equal $ED_TYPE "NONE"] && [string equal $generic_ed_type "No"]} {
        send_message error "No example design have been selected for generation"
    }
    
    # make qsys/ip-catalog infra blocks user from example design generation when no example design fileset is enabled
    #   assumption made: greyed-out fileset parameter means the current selected example design does not support that fileset
    set ED_FILESET_SYNTH    [get_parameter_value ED_FILESET_SYNTH]
    set ED_FILESET_SIM      [get_parameter_value ED_FILESET_SIM]
    if {[get_parameter_property "ED_FILESET_SIM" ENABLED] && [get_parameter_property "ED_FILESET_SYNTH" ENABLED]} {
        if {[string equal $ED_FILESET_SIM false] && [string equal $ED_FILESET_SYNTH false]} {
            send_message error "No example design files selected for generation. Please select at least one example design files"
        }
    } elseif {[get_parameter_property "ED_FILESET_SIM" ENABLED] && ![get_parameter_property "ED_FILESET_SYNTH" ENABLED]} {
        if {[string equal $ED_FILESET_SIM false]} {
            send_message error "No example design files selected for generation. Please select at least one example design files"
        }
    } elseif {![get_parameter_property "ED_FILESET_SIM" ENABLED] && [get_parameter_property "ED_FILESET_SYNTH" ENABLED]} {
        if {[string equal $ED_FILESET_SYNTH false]} {
            send_message error "No example design files selected for generation. Please select at least one example design files"
        }
    }
   
   source $ed_sim_scripts_dir/ed_hw.tcl

   send_message info "entityname is $entityname"
   

   send_message info "Generate scripts to run ip_sim testbench"
   add_tb_scripts $entityname $tbdir

   send_message info "Generate scripts to run ed_sim testbench"
   add_tb_top_scripts $entityname $tbdir $ed_sim_scripts_dir

   send_message info "Generate testbench and add customer testbench components for simulation"
   add_cust_tb_components $entityname $tbdir

   send_message info "Generate example design and top level testbench components for simulation"
   add_top_level_components $entityname $ed_sim_scripts_dir $ed_sim_dir

  #if {[string equal $ED_TYPE "RTL"]} {
   send_message info "Generate README.txt"
   add_fileset_file ip_sim/README.txt OTHER PATH $tbdir/README.txt

   send_message info "Generate simulation model generation scripts"
  #}
   
   ##########################################################################
   # IP_SIM component
   # Generate the run script file to generate Verilog & Vhdl simulation model

   set quartus_pro [expr {[is_software_edition QUARTUS_PRIME_PRO]} ]
   if { $quartus_pro } {
      set component_param "component-parameter"
   } else {
      set component_param "component-param"
   }

   foreach {language sim_language} $hdl {
      set dut_device_family [get_parameter_value DEVICE_FAMILY]
      set dut_device_part [get_parameter_value part_trait_dp]
      set verilog_run_script_file "$tbdir/gen_sim.tcl"
      set verilog_output_run_script_file [create_temp_file gen_sim.tcl]
      set out [ open $verilog_output_run_script_file w ]
      set in [open $verilog_run_script_file r]
   
      while {[gets $in line] != -1} {
         if {[string match "*INFO*" $line]} {
            puts $out $line 
            puts $out "puts \"Generating JESD204B simulation model for supported configurations.\""
            puts $out "puts \"Configuring DUT as simplex mode.\""
            if {[param_matches wrapper_opt "base"] || [param_matches DATA_PATH "TX"] || [expr {[get_parameter_value "REFCLK_FREQ"] < 60 }] } {
               puts $out "puts \"Overwriting parameters wrapper_opt=base_phy and REFCLK_FREQ=[derive_cust_tb_refclk].\""
            } else {
               puts $out "puts \"Overwriting parameters wrapper_opt=base_phy.\""
            }
            if {[device_is_xseries]} {
               puts $out "puts \"Adding Transceiver Reset Controller and Transceiver ATX PLL to supports JESD204B customer testbench.\""
            }
         } elseif {[string match "*GENERAL_PARAMETERS*" $line]} { 
            puts $out $line 
            #puts $out "set DEVICE_FAMILY \"[get_parameter_value "DEVICE_FAMILY"]\""
            puts $out "set dut_device_family \"$dut_device_family\""
            puts $out "set dut_device_part \"$dut_device_part\""
            puts $out "set sim_gen $sim_language"
            puts $out "set qdir \$::env(QUARTUS_ROOTDIR)"
            puts $out "set tx_dut_parameters \[list\]"
            puts $out "set rx_dut_parameters \[list\]"
         } elseif {[string match "*TX_DUT_PARAMETERS*" $line]} {
            puts $out $line         
            puts $out "set tx_variant_name ${entityname}_tx"

            foreach {param_name} [get_parameters] {
               set is_derived_param [get_parameter_property $param_name DERIVED]
               set param_value [get_parameter_value $param_name]

               # Print out the DUT parameters that are not derived
               if {$is_derived_param == 1} {
                  continue
               } else {
                  if {$param_name == "DATA_PATH"} {
                     puts $out "lappend tx_dut_parameters \"--$component_param=$param_name=TX\""

                  } elseif {$param_name == "wrapper_opt"} {
                     puts $out "lappend tx_dut_parameters \"--$component_param=$param_name=base_phy\""

                  } elseif {$param_name == "REFCLK_FREQ"} {
                     puts $out "lappend tx_dut_parameters \"--$component_param=$param_name=[derive_cust_tb_refclk]\""

       	          } elseif {$param_name == "TEST_COMPONENTS_EN"} {
                     puts $out "lappend tx_dut_parameters \"--$component_param=$param_name=true\""

       	          } elseif {$param_name == "TERMINATE_RECONFIG_EN"} {
                     if {[device_is_vseries]} {
                        puts $out "lappend tx_dut_parameters \"--$component_param=$param_name=true\""
                     } else {
                        puts $out "lappend tx_dut_parameters \"--$component_param=$param_name=false\""
                     }

                  } else {
                     puts $out "lappend tx_dut_parameters \"--$component_param=$param_name=$param_value\""

                  }
               }
            }

         } elseif {[string match "*RX_DUT_PARAMETERS*" $line]} {
            puts $out $line
            puts $out "set rx_variant_name ${entityname}_rx"

            foreach {param_name} [get_parameters] {
               set is_derived_param [get_parameter_property $param_name DERIVED]
               set param_value [get_parameter_value $param_name]

               # Print out the DUT parameters that are not derived
               if {$is_derived_param == 1} {
                  continue
               } else {
                  if {$param_name == "DATA_PATH"} {
                     puts $out "lappend rx_dut_parameters \"--$component_param=$param_name=RX\""

                  } elseif {$param_name == "wrapper_opt"} {
                     puts $out "lappend rx_dut_parameters \"--$component_param=$param_name=base_phy\""

                  } elseif {$param_name == "REFCLK_FREQ"} {
                     puts $out "lappend rx_dut_parameters \"--$component_param=$param_name=[derive_cust_tb_refclk]\""

       	          } elseif {$param_name == "TEST_COMPONENTS_EN"} {
                     puts $out "lappend rx_dut_parameters \"--$component_param=$param_name=true\""

       	          } elseif {$param_name == "TERMINATE_RECONFIG_EN"} {
                     if {[device_is_vseries]} {
                        puts $out "lappend rx_dut_parameters \"--$component_param=$param_name=true\""
                     } else {
                        puts $out "lappend rx_dut_parameters \"--$component_param=$param_name=false\""
                     }

                  } else {
                     puts $out "lappend rx_dut_parameters \"--$component_param=$param_name=$param_value\""

                  }
               }
            }

         } elseif {[string match "*GENERATE_TX_DUT*" $line]} {
            puts $out $line
            if { $quartus_pro } {
               puts $out "set tx_spd_filename \[file join testbench \$tx_variant_name \$\{tx_variant_name\}.spd\]"
               puts $out "catch \{eval \[concat \[list exec \"ip-deploy\" --component-name=altera_jesd204\] \$tx_dut_parameters --output-name=\$tx_variant_name --output-directory=./testbench \]\} temp"
               puts $out "puts \$temp"
               puts $out "catch \{eval \[concat \[list exec \"qsys-generate\" ./testbench/\$\{tx_variant_name\}.ip \] --simulation=$language \]\} temp"
               puts $out "puts \$temp"
            } else {
               puts $out "set tx_arg_list \[list\]"
               puts $out "set tx_output_dir \[file join testbench \$tx_variant_name\]"
               puts $out "set tx_spd_filename \[file join \$tx_output_dir \$\{tx_variant_name\}.spd\]"
               puts $out ""
               puts $out "lappend tx_arg_list \"--file-set=\$sim_gen\""
               puts $out "lappend tx_arg_list \"--system-info=DEVICE_FAMILY=\$dut_device_family\""
               puts $out "lappend tx_arg_list \"--system-info=DEVICE=\$dut_device_part\""
               puts $out "lappend tx_arg_list \"--output-name=\$tx_variant_name\""
               puts $out "lappend tx_arg_list \"--output-dir=\$tx_output_dir\""
               puts $out "lappend tx_arg_list \"--report-file=spd:\$tx_spd_filename\""
               puts $out ""
               puts $out "catch \{eval \[concat \[list exec \"\$qdir/sopc_builder/bin/ip-generate\" --component-name=altera_jesd204\] \$tx_arg_list \$tx_dut_parameters\]\} temp"
               puts $out "puts \$temp"
            }
         } elseif {[string match "*GENERATE_RX_DUT*" $line]} {
            puts $out $line
            if { $quartus_pro } {
               puts $out "set rx_spd_filename \[file join testbench \$rx_variant_name \$\{rx_variant_name\}.spd\]"
               puts $out "catch \{eval \[concat \[list exec \"ip-deploy\" --component-name=altera_jesd204\] \$rx_dut_parameters --output-name=\$rx_variant_name --output-directory=./testbench \]\} temp"
               puts $out "puts \$temp"
               puts $out "catch \{eval \[concat \[list exec \"qsys-generate\" ./testbench/\$\{rx_variant_name\}.ip \] --simulation=$language \]\} temp"
               puts $out "puts \$temp"
            } else {
               puts $out "set rx_arg_list \[list\]"
               puts $out "set rx_output_dir \[file join testbench \$rx_variant_name\]"
               puts $out "set rx_spd_filename \[file join \$rx_output_dir \$\{rx_variant_name\}.spd\]"
               puts $out ""
               puts $out "lappend rx_arg_list \"--file-set=\$sim_gen\""
               puts $out "lappend rx_arg_list \"--system-info=DEVICE_FAMILY=\$dut_device_family\""
               puts $out "lappend rx_arg_list \"--system-info=DEVICE=\$dut_device_part\""
               puts $out "lappend rx_arg_list \"--output-name=\$rx_variant_name\""
               puts $out "lappend rx_arg_list \"--output-dir=\$rx_output_dir\""
               puts $out "lappend rx_arg_list \"--report-file=spd:\$rx_spd_filename\""
               puts $out ""
               puts $out "catch \{eval \[concat \[list exec \"\$qdir/sopc_builder/bin/ip-generate\" --component-name=altera_jesd204\] \$rx_arg_list \$rx_dut_parameters\]\} temp"
               puts $out "puts \$temp"
            }
         } else {
            puts $out $line
         }
      }
      close $in
      close $out
      #if {[string equal $ED_TYPE "RTL"]} {	  
         add_fileset_file ip_sim/gen_sim_$language.tcl OTHER PATH $verilog_output_run_script_file 
      #}
      
   }

}


# This proc do the following tasks:
# - Creates testbench run script
# - Create waveform do file that is called in testbench run script
proc add_tb_scripts {entityname tbdir} {
     
   #set ED_TYPE [get_parameter_value "ED_TYPE"]
   # Testbench run script
   set supported_simulators {"mentor" "vcsmx" "vcs" "aldec" "cadence"}
   foreach simulator $supported_simulators {
      # mentor & aldec support
      if {$simulator == "mentor" || $simulator == "aldec"} {
         set run_script "$tbdir/run_tb.tcl"
         set run_script_output_file [create_temp_file run_$entityname\_tb.tcl]
         set out [ open $run_script_output_file w ]
         set in [open $run_script r]
         set simulator_source_script [get_source_script $simulator]

         while {[gets $in line] != -1} {
            if {[string match "*RUN_SCRIPT_PARAMETERS*" $line]} {
               puts $out $line
               # Patch run script with suitable parameter value
               puts $out "set SETUP_SCRIPTS ../setup_scripts"
               puts $out "set dut_wave_do $entityname\_wave.do"
               puts $out "set testbench_model_dir ../models"
   
            } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
               puts $out "source \$SETUP_SCRIPTS/$simulator/$simulator_source_script"

            } elseif {[string match "*MODELSIM_FIX*" $line]} {
	       if {$simulator == "mentor"} {
                  puts $out  "# Some packages file has changed. Refresh the work libraries (Vsim-13)"
                  puts $out  "vlog -work work -refresh -force_refresh"	       
	       }
            
            } else {
               puts $out $line
            }
         }
         close $in
         close $out
         #if {[string equal $ED_TYPE "RTL"]} {
            add_fileset_file ip_sim/testbench/$simulator/run_$entityname\_tb.tcl OTHER PATH $run_script_output_file 
         #}	 

      # Waveform do file
         set wave_do "$tbdir/wave.do"
         set wave_do_output_file [create_temp_file $entityname\_wave.do]
         set out [ open $wave_do_output_file w ]
         set in [open $wave_do r]

         while {[gets $in line] != -1} {
            if {[string match "*TX - PHY Reset Controller*" $line] && [device_is_xseries]} {
               set replaced_line [string map {\/altera_jesd204_tx_inst\/ \/} $line]
               puts $out $replaced_line
            } elseif {[string match "*RX - PHY Reset Controller*" $line] && [device_is_xseries]} {
               set replaced_line [string map {\/altera_jesd204_rx_inst\/ \/} $line]
               puts $out $replaced_line
            } else {
               puts $out $line
            }
         }
         close $in
         close $out
         #if {[string equal $ED_TYPE "RTL"]} {
            add_fileset_file ip_sim/testbench/$simulator/$entityname\_wave.do OTHER PATH $wave_do_output_file 
	     #}

     } elseif {$simulator == "vcsmx"} {
	#vcsmx support     
         set run_script "$tbdir/run_tb.sh"
         set run_script_output_file [create_temp_file run_$entityname\_tb.sh]
         set out [ open $run_script_output_file w ]
         set in [open $run_script r]
         set simulator_source_script [get_source_script $simulator]

         while {[gets $in line] != -1} {
            if {[string match "*RUN_SCRIPT_PARAMETERS*" $line]} {
               puts $out $line
               # Patch run script with suitable parameter value
               puts $out "SETUP_SCRIPTS=\"../../setup_scripts/synopsys/$simulator/$simulator_source_script\""
               puts $out "dut_wave_do=\"$entityname\_wave.do\""
               puts $out "testbench_model_dir=\"../../models\""
   
            } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
	       puts $out "cp ../../setup_scripts/synopsys/$simulator/synopsys_sim.setup ."
               puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_jesd204\" SKIP_ELAB=1 SKIP_SIM=1"
       
            } elseif {[string match "*TESTBENCH_ELAB*" $line]} {
               puts $out "vcs -lca -t ps \$TOP_LEVEL_NAME -debug_pp"

            } elseif {[string match "*TESTBENCH_SIM*" $line]} {
               puts $out "./simv -ucli -l sim.log -do \$dut_wave_do"

            } else {
               puts $out $line
            }
         }
	 close $in
         close $out
         #if {[string equal $ED_TYPE "RTL"]} {
            add_fileset_file ip_sim/testbench/synopsys/$simulator/run_$entityname\_tb.sh OTHER PATH $run_script_output_file 
         #}
    
       # Waveform do file
         set wave_do "$tbdir/wave_synopsys.do"
         set wave_do_output_file [create_temp_file $entityname\_wave.do]
         set out [ open $wave_do_output_file w ]
         set in [open $wave_do r]

         while {[gets $in line] != -1} {
         puts $out $line
         }

         close $in
         close $out
         #if {[string equal $ED_TYPE "RTL"]} {
            add_fileset_file ip_sim/testbench/synopsys/$simulator/$entityname\_wave.do OTHER PATH $wave_do_output_file 
         #}
     } elseif {$simulator == "vcs"} {
	#vcs support     
         set run_script "$tbdir/run_tb.sh"
         set run_script_output_file [create_temp_file run_$entityname\_tb.sh]
         set out [ open $run_script_output_file w ]
         set in [open $run_script r]
         set simulator_source_script [get_source_script $simulator]

         while {[gets $in line] != -1} {
            if {[string match "*RUN_SCRIPT_PARAMETERS*" $line]} {
               puts $out $line
               # Patch run script with suitable parameter value
               puts $out "SETUP_SCRIPTS=\"../../setup_scripts/synopsys/$simulator/$simulator_source_script\""
               puts $out "dut_wave_do=\"$entityname\_wave.do\""
               puts $out "testbench_model_dir=\"../../models\""
   
            } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
               puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_jesd204\" SKIP_ELAB=1 SKIP_SIM=1 USER_DEFINED_ELAB_OPTIONS=\"-debug_pp\" "
       
            } elseif {[string match "*TESTBENCH_SIM*" $line]} {
               puts $out "./simv -ucli -l sim.log -do \$dut_wave_do"

            } else {
               puts $out $line
            }
         }
	 close $in
         close $out
         #if {[string equal $ED_TYPE "RTL"]} {
            add_fileset_file ip_sim/testbench/synopsys/$simulator/run_$entityname\_tb.sh OTHER PATH $run_script_output_file 
         #}
		 # Waveform do file
         set wave_do "$tbdir/wave_synopsys.do"
         set wave_do_output_file [create_temp_file $entityname\_wave.do]
         set out [ open $wave_do_output_file w ]
         set in [open $wave_do r]

         while {[gets $in line] != -1} {
         puts $out $line
         }

         close $in
         close $out
         #if {[string equal $ED_TYPE "RTL"]} {
            add_fileset_file ip_sim/testbench/synopsys/$simulator/$entityname\_wave.do OTHER PATH $wave_do_output_file 
         #}
     } elseif {$simulator == "cadence"} {
	#cadence support     
         set run_script "$tbdir/run_tb.sh"
         set run_script_output_file [create_temp_file run_$entityname\_tb.sh]
         set out [ open $run_script_output_file w ]
         set in [open $run_script r]
         set simulator_source_script [get_source_script $simulator]

         while {[gets $in line] != -1} {
            if {[string match "*RUN_SCRIPT_PARAMETERS*" $line]} {
               puts $out $line
               # Patch run script with suitable parameter value
               puts $out "SETUP_SCRIPTS=\"../setup_scripts/$simulator/$simulator_source_script\""
               puts $out "dut_wave_do=\"$entityname\_wave.tcl\""
               puts $out "testbench_model_dir=\"../models\""
   
            } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
	       puts $out "cp ../setup_scripts/$simulator/cds.lib ."
	       puts $out "cp -r ../setup_scripts/$simulator/cds_libs ."
	       puts $out "cp ../setup_scripts/$simulator/hdl.var ."
               puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_jesd204\" SKIP_ELAB=1 SKIP_SIM=1"

            } elseif {[string match "*TESTBENCH_ELAB*" $line]} {
               puts $out "export GENERIC_PARAM_COMPAT_CHECK=1"
               puts $out "ncelab -timescale 1ns/1ps -access +w+r+c -namemap_mixgen -relax \$TOP_LEVEL_NAME"

            } elseif {[string match "*TESTBENCH_SIM*" $line]} {
               puts $out "ncsim -tcl -input \$dut_wave_do \$TOP_LEVEL_NAME"

            } else {
               puts $out $line
            }
         }
	 close $in
         close $out
         #if {[string equal $ED_TYPE "RTL"]} {
            add_fileset_file ip_sim/testbench/$simulator/run_$entityname\_tb.sh OTHER PATH $run_script_output_file 
	     #}
    
       # Waveform tcl file
         set wave_do "$tbdir/wave.tcl"
         set wave_do_output_file [create_temp_file $entityname\_wave.tcl]
         set out [ open $wave_do_output_file w ]
         set in [open $wave_do r]

         while {[gets $in line] != -1} {
         puts $out $line
         }

         close $in
         close $out
         #if {[string equal $ED_TYPE "RTL"]} {
            add_fileset_file ip_sim/testbench/$simulator/$entityname\_wave.tcl OTHER PATH $wave_do_output_file 
	     #}

     }

  }
}


proc add_cust_tb_components {entityname tbdir} {
   # ---------------------------------
   #   Terp for top level testbench
   # ---------------------------------
   set tb_L [get_parameter_value "L"]
   set device_family [get_parameter_value "DEVICE_FAMILY"]
   set tb_scr [get_parameter_value "SCR"]
   set g_lane_rate [get_parameter_value "lane_rate"]
   set refclk_period_ns  [format %0.6f [expr { 1000.000000/[derive_cust_tb_refclk]}] ]
   set linkclk_period_ns  [format %0.6f [expr {40.000000*1000/$g_lane_rate}] ]
   set pcs_options [get_parameter_value "PCS_CONFIG"]
   set g_reconfig_en  [ get_parameter_value "pll_reconfig_enable" ]
   set g_rcfg_shared  [ get_parameter_value "rcfg_shared" ]
   set g_rcfg_addr_width [ get_parameter_value "RECONFIG_ADDRESS_WIDTH" ]

    #Do Terp
    set template_file [ file join $tbdir "tb_jesd204.sv.terp" ]  
    set template   [ read [ open $template_file r ] ]
    set params(tb_L) $tb_L
    set params(tb_scr) $tb_scr
    set params(device_family) $device_family
    set params(refclk_period_ns) $refclk_period_ns
    set params(linkclk_period_ns) $linkclk_period_ns
    set params(pcs_options) $pcs_options
    set params(reconfig_en) $g_reconfig_en
    set params(rcfg_shared) $g_rcfg_shared
    set params(rcfg_addr_width) $g_rcfg_addr_width
    set result   [ altera_terp $template params ]
	#set ED_TYPE [get_parameter_value "ED_TYPE"]

   # Add top level testbench
    #if {[string equal $ED_TYPE "RTL"]} {
       add_fileset_file ip_sim/testbench/models/tb_jesd204.sv SYSTEM_VERILOG TEXT $result 
    #}
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

# This function is used to derive the PLL and CDR reference clock for JESD204B customer testbench.
# Note : the PLL and CDR reference clocks are set to selected lane rate divided by pma width for JESD204B customer testbench.  
proc derive_cust_tb_refclk { } {
    if {[param_matches wrapper_opt "base"] || [param_matches DATA_PATH "TX"] || [expr {[get_parameter_value "REFCLK_FREQ"] < 60 }] } {
       set lane_rate [get_parameter_value "lane_rate"]
       set pma_width [expr {[param_matches PCS_CONFIG "JESD_PCS_CFG1"] ? 20 : [param_matches PCS_CONFIG "JESD_PCS_CFG2"] ? 40 : [param_matches PCS_CONFIG "JESD_PCS_CFG4"] ? 80 : 10 }]
       set ref_clk [ format %0.3f [expr {$lane_rate*1.000/$pma_width}] ]  
    } else {
       set ref_clk [get_parameter_value "REFCLK_FREQ"]
    }

   return $ref_clk
}

