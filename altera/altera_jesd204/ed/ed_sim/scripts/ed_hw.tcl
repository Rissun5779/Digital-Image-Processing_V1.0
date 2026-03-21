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



proc _ed_device_fileset {} {
    set device_family [get_parameter_value DEVICE_FAMILY]
    
    if {[string equal $device_family "Arria 10"]} {
        return 1;
    } elseif {[string equal $device_family "Stratix V"]} {
        return 0;
    } elseif {[string equal $device_family "Arria V"]} {
        return 0;
    } elseif {[string equal $device_family "Cyclone V"]} {
        return 0;
    } else {
        return 0;
    }
}

# script qsys file to convert to qsys pro
proc script_qsys_file {qsys_file} {

    set qsys_file_name [file tail $qsys_file]
	
	# Create quartus project in temp directory, use qsys file name as quartus project name
    set script_cmd [list qsys-script --package-version=16.1 --quartus-project=none --system-file=$qsys_file --cmd='save_system']
    
    set status [catch {exec {*}$script_cmd} result]
    send_message INFO "$qsys_file_name is scripted for Qsys Pro $result"
    
}

# generate qsys file for SYNTHESIS fileset in Verilog
proc generate_qsys_file {qsys_file} {

    set generate_cmd [list qsys-generate $qsys_file --synthesis=VERILOG]

    set status [catch {exec {*}$generate_cmd} result]
    set qsys_file_name [file tail $qsys_file]
    send_message INFO "$qsys_file_name is generated"
    
}

# generate qsys file for SYNTHESIS fileset in Verilog
proc generate_qsys_file_s10 {qsys_file} {

    set generate_cmd [list qsys-generate $qsys_file --synthesis=VERILOG]

    set status [catch {exec {*}$generate_cmd} result]
    set qsys_file_name [file tail $qsys_file]
    send_message INFO "$qsys_file_name is generated"
    
}

# generate qsys file for SIMULATION fileset in Verilog
proc generate_qsys_file_sim {qsys_file} {

    set generate_cmd [list qsys-generate $qsys_file --simulation=VERILOG]

    set status [catch {exec {*}$generate_cmd} result]
    set qsys_file_name [file tail $qsys_file]
    send_message INFO "$qsys_file_name is generated"
    
}

proc f_find {path} {
    package require fileutil

    set filesToUpload [fileutil::find $path]
    return $filesToUpload
}

# search for generated files and add to fileset
proc add_generated_files_to_fileset {output_location generated_location} {
    
    after 6000
    set fl [f_find ${generated_location}]
    
    foreach file $fl {
		set f_path [string map [list ${generated_location} ""] $file]
		
        if {[file ext $file] == ".v"} {
			add_fileset_file "$output_location/$f_path" VERILOG PATH $file
		} elseif {[file ext $file] == ".sv"} {
			add_fileset_file "$output_location/$f_path" SYSTEM_VERILOG PATH $file
		} elseif {[file ext $file] == ".mif"} {
			add_fileset_file "$output_location/$f_path" MIF PATH $file
		} elseif {[file ext $file] == ".hex"} {
			add_fileset_file "$output_location/$f_path" HEX PATH $file
		} elseif {[file ext $file] == ".vhd"} {
			add_fileset_file "$output_location/$f_path" VHDL PATH $file
		} elseif {[file ext $file] == ".sdc"} {
			add_fileset_file "$output_location/$f_path" SDC PATH $file
		} elseif {[file ext $file] == ".qip" || [file ext $file] == ".sopcinfo" || [file ext $file] == ".spd" || [file ext $file] == ".csv" ||
            [file ext $file] == ".sip" || [file ext $file] == ".tcl" || [file ext $file] == ".vo" || [file ext $file] == ".do" || 
            [file ext $file] == ".sh" || [file ext $file] == ".setup" || [file ext $file] == ".lib" || [file ext $file] == ".var" ||
	    [file ext $file] == ".xml" || [file ext $file] == ".txt" || [file ext $file] == ".ip"} {
			add_fileset_file "$output_location/$f_path" OTHER PATH $file
		} else {
		}		
	}
}
    
    global env
    
    set qdir                $env(QUARTUS_ROOTDIR)
    set ed_sim_scripts_dir  "${qdir}/../ip/altera/altera_jesd204/ed/ed_sim/scripts"
    set ed_sim_dir          "${qdir}/../ip/altera/altera_jesd204/ed/ed_sim"
    set ed_synth_dir        "${qdir}/../ip/altera/altera_jesd204/ed/ed_synth"
    set nios_dir            "${qdir}/../ip/altera/altera_jesd204/ed/ed_nios"

      set ED_TYPE [get_parameter_value "ED_TYPE"]
      set ED_GENERIC_A10 [get_parameter_value "ED_GENERIC_A10"]
      set ED_GENERIC_5SERIES [get_parameter_value "ED_GENERIC_5SERIES"]
      set ED_FILESET_SYNTH [get_parameter_value "ED_FILESET_SYNTH"]
      set ED_FILESET_SIM [get_parameter_value "ED_FILESET_SIM"]
      set ED_HDL_FORMAT_SIM [get_parameter_value "ED_HDL_FORMAT_SIM"]
      set ED_HDL_FORMAT_SYNTH [get_parameter_value "ED_HDL_FORMAT_SYNTH"]
      set ED_FILESET_SYNTH [get_parameter_value "ED_FILESET_SYNTH"]
      set ED_DEV_KIT [get_parameter_value "ED_DEV_KIT"]
      set device_family [get_parameter_value "DEVICE_FAMILY"]
      set device [get_parameter_value "part_trait_dp"]
      set PCS_CONFIG_gui [get_parameter_value "PCS_CONFIG"]
      set wrapper_opt [get_parameter_value "wrapper_opt"]
      set data_path [get_parameter_value "DATA_PATH"]
      set bonded_mode [get_parameter_value "bonded_mode"]
      set subclass [get_parameter_value "SUBCLASSV"]
      set lane_rate [get_parameter_value "lane_rate"]
      set pll_type [get_parameter_value "pll_type"]
      set refclk_freq [get_parameter_value "REFCLK_FREQ"]
      set pll_reconfig_enable [get_parameter_value "pll_reconfig_enable"]
      set bitrev_en [get_parameter_value "bitrev_en"]
      set L [get_parameter_value "L"]
      set M [get_parameter_value "M"]
      set N [get_parameter_value "N"]
      set N_PRIME [get_parameter_value "N_PRIME"]
      set S [get_parameter_value "S"]
      set K [get_parameter_value "K"]
      set SCR [get_parameter_value "SCR"]
      set CS [get_parameter_value "CS"]
      set CF [get_parameter_value "CF"]
      set HD [get_parameter_value "HD"]
      set ECC_EN [get_parameter_value "ECC_EN"]
      set F [get_parameter_value "F"]
      set GUI_EN_CFG_F [get_parameter_value "GUI_EN_CFG_F"]
      set GUI_CFG_F [get_parameter_value "GUI_CFG_F"]
      set ED_DEV_KIT [get_parameter_value ED_DEV_KIT] 
      set max_atxpll_channel 6
      
      # if target dev kit is selected to A10 dev kit, use dev kit's device
      if {[string equal $ED_DEV_KIT "A10_FPGA"] && [get_parameter_property ED_DEV_KIT ENABLED]} {
        set device "10AX115S3F45E2SGE3"
      }
      
      
      if {[string equal $device_family "Arria 10"] && [string equal $ED_FILESET_SYNTH "true"] && [expr [string equal $ED_TYPE "NIOS"] || [string equal $ED_GENERIC_A10 "NIOS"]]} {
        
        # overwrite example design parameter value if generic ed is selected
        if {[string equal $ED_TYPE "NONE"] && [string equal $ED_GENERIC_A10 "NIOS"]} {
            
            set L                   2
            set M                   2
            set F                   2
            set GUI_EN_CFG_F        1
            set GUI_CFG_F           2
            set K                   16
            set S                   1
            set wrapper_opt         "base_phy"
            set data_path           "RX_TX"
            set bonded_mode         "non_bonded"
            set subclass            1
            set lane_rate           6144
            set PCS_CONFIG_gui      "JESD_PCS_CFG1"
            set pll_type            "CMU"
            set pll_reconfig_enable true
            set refclk_freq         153.6
            set bitrev_en           false
            set N                   16
            set N_PRIME             16
            set CS                  0
            set CF                  0
            set HD                  0
            set SCR                 1
            set ECC_EN              1
        }
        
        if {[_ed_device_fileset]} {
           if {[expr {$L == "8"}]} {
              set verilog_run_script_file "$nios_dir/script/jesd204b_subsystem_l8.txt"
           } else {
              set verilog_run_script_file "$nios_dir/script/jesd204b_subsystem.txt"
           } 
        } else {
           send_message error "NIOS only support for Arria 10."
        }
        
        set verilog_output_run_script_file [create_temp_file jesd204b_subsystem.qsys]
        set out [ open $verilog_output_run_script_file w ]
        set in [open $verilog_run_script_file r]
        
        while {[gets $in line] != -1} {
            if {[string match "*DEVICE_PARAM*" $line]} {
                
                puts $out " <parameter name=\"deviceFamily\" value=\"$device_family\" />"
                puts $out " <parameter name=\"device\" value=\"$device\" />"
                
            } elseif {[string match "*CORE_PARAM*" $line]} {
              #puts $out $line         
              puts $out "  <parameter name=\"DEVICE_FAMILY\" value=\"$device_family\" />"
              puts $out "  <parameter name=\"PCS_CONFIG\" value=\"$PCS_CONFIG_gui\" />"
              puts $out "  <parameter name=\"bonded_mode\" value=\"$bonded_mode\" />"
              puts $out "  <parameter name=\"wrapper_opt\" value=\"$wrapper_opt\" />"
              puts $out "  <parameter name=\"DATA_PATH\" value=\"$data_path\" />"
              puts $out "  <parameter name=\"SUBCLASSV\" value=\"$subclass\" />"
              puts $out "  <parameter name=\"lane_rate\" value=\"$lane_rate\" />"
              puts $out "  <parameter name=\"pll_type\" value=\"$pll_type\" />"
              puts $out "  <parameter name=\"REFCLK_FREQ\" value=\"$refclk_freq\" />"
              puts $out "  <parameter name=\"pll_reconfig_enable\" value=\"$pll_reconfig_enable\" />"
              puts $out "  <parameter name=\"bitrev_en\" value=\"$bitrev_en\" />"
              puts $out "  <parameter name=\"L\" value=\"$L\" />"
              puts $out "  <parameter name=\"M\" value=\"$M\" />"
              puts $out "  <parameter name=\"F\" value=\"$F\" />"
              puts $out "  <parameter name=\"GUI_EN_CFG_F\" value=\"$GUI_EN_CFG_F\" />"
              puts $out "  <parameter name=\"GUI_CFG_F\" value=\"$GUI_CFG_F\" />"
              puts $out "  <parameter name=\"N\" value=\"$N\" />"
              puts $out "  <parameter name=\"N_PRIME\" value=\"$N_PRIME\" />"
              puts $out "  <parameter name=\"S\" value=\"$S\" />"
              puts $out "  <parameter name=\"K\" value=\"$K\" />"
              puts $out "  <parameter name=\"SCR\" value=\"$SCR\" />"
              puts $out "  <parameter name=\"CS\" value=\"$CS\" />"
              puts $out "  <parameter name=\"CF\" value=\"$CF\" />"
              puts $out "  <parameter name=\"HD\" value=\"$HD\" />"
              puts $out "  <parameter name=\"ECC_EN\" value=\"$ECC_EN\" />"
              puts $out "  <parameter name=\"DLB_TEST\" value=\"0\" />"
              puts $out "  <parameter name=\"sdc_constraint\" value=\"1.15\" />"

           } elseif {[string match "*LINKRESET_PARAM*" $line]} {
              puts $out "  <parameter name=\"AUTO_CLK_CLOCK_RATE\" value=\"153600000\" />"

           } elseif {[string match "*FRAMERESET_PARAM*" $line]} {
              if {[expr {$F == "8"}]} {
                 puts $out "  <parameter name=\"AUTO_CLK_CLOCK_RATE\" value=\"76800000\" />"
              } else {
                 puts $out "  <parameter name=\"AUTO_CLK_CLOCK_RATE\" value=\"153600000\" />"
              }

           } elseif {[string match "*ATSPLL_PARAM*" $line]} {
              puts $out "  <parameter name=\"set_auto_reference_clock_frequency\" value=\"$refclk_freq\" />"

           } elseif {[string match "*RSTCTRL_PARAM*" $line]} {
              puts $out "  <parameter name=\"CHANNELS\" value=\"$L\" />"
              if {[expr {$L > $max_atxpll_channel}]} {
                 puts $out "  <parameter name=\"PLLS\" value=\"2\" />"
              } else {
                 puts $out "  <parameter name=\"PLLS\" value=\"1\" />"
              }

           } elseif {[string match "*SERIALCLK_PARAM*" $line]} {
              if {[expr {$L == 1}]} {
                 puts $out " <connection"
                 puts $out "   kind=\"hssi_serial_clock\""
                 puts $out "   version=\"15.1\""
                 puts $out "   start=\"xcvr_atx_pll_a10_0.tx_serial_clk\""
                 puts $out "   end=\"jesd204b.tx_serial_clk0\" />"
              } elseif {[expr {$L > $max_atxpll_channel}]} {
                 for {set a 0} {$a < $max_atxpll_channel} {incr a} {
                    puts $out " <connection"
                    puts $out "   kind=\"hssi_serial_clock\""
                    puts $out "   version=\"15.1\""
                    puts $out "   start=\"xcvr_atx_pll_a10_0.tx_serial_clk\""
                    puts $out "   end=\"jesd204b.tx_serial_clk0_ch$a\" />"
                 }
                 for {set a $max_atxpll_channel} {$a < $L} {incr a} {
                    puts $out " <connection"
                    puts $out "   kind=\"hssi_serial_clock\""
                    puts $out "   version=\"15.1\""
                    puts $out "   start=\"xcvr_atx_pll_a10_1.tx_serial_clk\""
                    puts $out "   end=\"jesd204b.tx_serial_clk0_ch$a\" />"
                 }
              } else {
                 for {set a 0} {$a < $L} {incr a} {
                    puts $out " <connection"
                    puts $out "   kind=\"hssi_serial_clock\""
                    puts $out "   version=\"15.1\""
                    puts $out "   start=\"xcvr_atx_pll_a10_0.tx_serial_clk\""
                    puts $out "   end=\"jesd204b.tx_serial_clk0_ch$a\" />"
                 }
              }

           } elseif {[string match "*FRAME_FREQ_PARAM*" $line]} {
              if {[expr {$F == "8"}]} {
                 puts $out "  <parameter name=\"clockFrequency\" value=\"76800000\" />"
              } else {
                 puts $out "  <parameter name=\"clockFrequency\" value=\"153600000\" />"
              }

           } elseif {[string match "*LINK_FREQ_PARAM*" $line]} {
              puts $out "  <parameter name=\"clockFrequency\" value=\"153600000\" />"

           } elseif {[string match "*DEVICE_FREQ_PARAM*" $line]} {
              if {[expr {$refclk_freq == "307.2"}]} {
                 puts $out "  <parameter name=\"clockFrequency\" value=\"307200000\" />"
              } else {
                 puts $out "  <parameter name=\"clockFrequency\" value=\"153600000\" />"
              }
           } elseif {[string match "*DEVICE_PARTNAME*" $line]} {
                 regsub "DEVICE_PARTNAME" $line "$device" fpga_device
                 puts $out "$fpga_device"
           } elseif {[string match "*ATXPLLFEQ*" $line]} {
                 set LANERATE              [expr $lane_rate / 2]
                 regsub "ATXPLLFEQ" $line "$LANERATE" atxpll_feq
                 puts $out "$atxpll_feq"
           } else {
              puts $out $line
           }
        }
        close $in
        close $out
        
        add_fileset_file ed_nios/jesd204b_subsystem.qsys OTHER PATH $verilog_output_run_script_file
        set qsys_files [list]
        lappend qsys_files $verilog_output_run_script_file

        if {[_ed_device_fileset]} {
           if {[expr {$L == "8"}]} {
              set verilog_run_script_file "$nios_dir/script/jesd204b_ed_qsys_l8.txt"
           } else {
              set verilog_run_script_file "$nios_dir/script/jesd204b_ed_qsys.txt"
           } 
        } else {
           send_message error "NIOS only support for Arria 10."
        }

        set verilog_output_run_script_file [create_temp_file jesd204b_ed_qsys.qsys]
        set out [ open $verilog_output_run_script_file w ]
        set in [open $verilog_run_script_file r]

        while {[gets $in line] != -1} {
            if {[string match "*DEVICE_PARAM*" $line]} {
                
                puts $out " <parameter name=\"deviceFamily\" value=\"$device_family\" />"
                puts $out " <parameter name=\"device\" value=\"$device\" />"
                
            } elseif {[string match "*REFCLK_FREQ_PARAM*" $line]} {
              #puts $out $line         
              puts $out "  <parameter name=\"gui_reference_clock_frequency\" value=\"$refclk_freq\" />"
              puts $out "  <parameter name=\"gui_output_clock_frequency0\" value=\"153.6\" />"
              if {[expr {$F == "8"}]} {
                 puts $out "  <parameter name=\"gui_output_clock_frequency1\" value=\"76.8\" />"
              } else {
                 puts $out "  <parameter name=\"gui_output_clock_frequency1\" value=\"153.6\" />"
              }

           } elseif {[string match "*FRAME_CLOCK_PARAM*" $line]} {
              if {[expr {$F == "8"}]} {
                 puts $out "  <parameter name=\"AUTO_FRAME_CLK_CLOCK_RATE\" value=\"76800000\" />"
              } else {
                 puts $out "  <parameter name=\"AUTO_FRAME_CLK_CLOCK_RATE\" value=\"153600000\" />"
              }

              puts $out "  <parameter name=\"AUTO_LINK_CLK_CLOCK_RATE\" value=\"153600000\" />"

              if {[expr {$refclk_freq == "307.2"}]} {
                 puts $out "  <parameter name=\"AUTO_DEVICE_CLK_CLOCK_RATE\" value=\"307200000\" />"
              } else {
                 puts $out "  <parameter name=\"AUTO_DEVICE_CLK_CLOCK_RATE\" value=\"153600000\" />"
              }

           } elseif {[string match "*FRAME_FREQ_PARAM*" $line]} {
              if {[expr {$F == "8"}]} {
                 puts $out "  <parameter name=\"clockFrequency\" value=\"76800000\" />"
              } else {
                 puts $out "  <parameter name=\"clockFrequency\" value=\"153600000\" />"
              }

           } elseif {[string match "*LINK_FREQ_PARAM*" $line]} {
              puts $out "  <parameter name=\"clockFrequency\" value=\"153600000\" />"

           } elseif {[string match "*DEVICE_FREQ_PARAM*" $line]} {
              if {[expr {$refclk_freq == "307.2"}]} {
                 puts $out "  <parameter name=\"clockFrequency\" value=\"307200000\" />"
              } else {
                 puts $out "  <parameter name=\"clockFrequency\" value=\"153600000\" />"
              }
           } elseif {[string match "*DEVICE_PARTNAME*" $line]} {
                 regsub "DEVICE_PARTNAME" $line "$device" fpga_device
                 puts $out "$fpga_device"
           } else {
              puts $out $line
           }
        }
        close $in
        close $out

        add_fileset_file ed_nios/jesd204b_ed_qsys.qsys OTHER PATH $verilog_output_run_script_file
        lappend qsys_files $verilog_output_run_script_file
        
        #NIOS support up to 1 link for ed, no multilink enable
        set LINK_DERIVED 1 
        if { $F == "1"  } {
		  set F1_FRAME_DIV "4"
		  # F2 not used. set to default value.
		  set F2_FRAME_DIV "2"    
		} elseif { $F == "4" } {
		   set F1_FRAME_DIV "1" 
		   # F2 not used. set to default value.
		   set F2_FRAME_DIV "2"      
		} elseif { $F == "8" } {
		   set F1_FRAME_DIV "1"
		   # F2 not used. set to default value.
		   set F2_FRAME_DIV "2"    
		}  else {
		   # F1 not used. set to default value.
		   set F1_FRAME_DIV "2" 
		   set F2_FRAME_DIV "2"            
		}
		set F1_DIV ${F1_FRAME_DIV}
		set F2_DIV ${F2_FRAME_DIV}

        #Do Terp
        set template_file [ file join $nios_dir/script "jesd204b_ed.sv.terp" ]  
        set template   [ read [ open $template_file r ] ]
        set params(LINK_DERIVED) $LINK_DERIVED
        set params(L) $L
        set params(M) $M
        set params(F) $F
        set params(S) $S
        set params(CS) $CS
        set params(N) $N
        set params(N_PRIME) $N_PRIME
        set params(F1_DIV) $F1_DIV
        set params(F2_DIV) $F2_DIV

        set result   [ altera_terp $template params ]
        # Add top level testbench
        add_fileset_file ed_nios/jesd204b_ed.sv VERILOG TEXT $result

        #add timing file
        set template_file [ file join $nios_dir/script "jesd204b_ed.sdc.terp" ]  
        set template   [ read [ open $template_file r ] ]
        set params(L) $L
        if {[is_qsys_edition QSYS_PRO]} {
            set params(qsys_pro)    "1"
        } else {
            set params(qsys_pro)    "0"
        }
        set result   [ altera_terp $template params ]
        add_fileset_file ed_nios/jesd204b_ed.sdc OTHER TEXT $result

        set verilog_run_script_file "$nios_dir/script/nios_subsystem.txt"
        set verilog_output_run_script_file [create_temp_file nios_subsystem.qsys]
        set out [ open $verilog_output_run_script_file w ]
        set in [open $verilog_run_script_file r]

        while {[gets $in line] != -1} {
           if {[string match "*DEVICE_PARTNAME*" $line]} {
                 regsub "DEVICE_PARTNAME" $line "$device" fpga_device
                 puts $out "$fpga_device"
           } else {
              puts $out $line
           }
        }
        close $in
        close $out

        add_fileset_file ed_nios/nios_subsystem.qsys OTHER PATH $verilog_output_run_script_file
        lappend qsys_files $verilog_output_run_script_file
        
        set verilog_run_script_file "$nios_dir/script/se_outbuf_1bit.txt"
        set verilog_output_run_script_file [create_temp_file se_outbuf_1bit.qsys]
        set out [ open $verilog_output_run_script_file w ]
        set in [open $verilog_run_script_file r]

        while {[gets $in line] != -1} {
           if {[string match "*DEVICE_PARTNAME*" $line]} {
                 regsub "DEVICE_PARTNAME" $line "$device" fpga_device
                 puts $out "$fpga_device"
           } else {
              puts $out $line
           }
        }
        close $in
        close $out

        add_fileset_file ed_nios/se_outbuf_1bit.qsys OTHER PATH $verilog_output_run_script_file
        lappend qsys_files $verilog_output_run_script_file
        
        add_fileset_file ed_nios/spi_mosi_oe.v OTHER PATH $nios_dir/script/spi_mosi_oe.v
        add_fileset_file ed_nios/switch_debouncer.v OTHER PATH $nios_dir/script/switch_debouncer.v

        add_fileset_file ed_nios/pattern/alternate_checker.sv OTHER PATH $nios_dir/pattern/alternate_checker.sv
        add_fileset_file ed_nios/pattern/alternate_generator.sv OTHER PATH $nios_dir/pattern/alternate_generator.sv
        add_fileset_file ed_nios/pattern/prbs_checker.sv OTHER PATH $nios_dir/pattern/prbs_checker.sv
        add_fileset_file ed_nios/pattern/prbs_generator.sv OTHER PATH $nios_dir/pattern/prbs_generator.sv
        add_fileset_file ed_nios/pattern/ramp_checker.sv OTHER PATH $nios_dir/pattern/ramp_checker.sv
        add_fileset_file ed_nios/pattern/ramp_generator.sv OTHER PATH $nios_dir/pattern/ramp_generator.sv
        add_fileset_file ed_nios/pattern/pattern_checker_top.sv OTHER PATH $nios_dir/pattern/pattern_checker_top.sv
        add_fileset_file ed_nios/pattern/pattern_generator_top.sv OTHER PATH $nios_dir/pattern/pattern_generator_top.sv

        add_fileset_file ed_nios/transport_layer/altera_jesd204_assembler.sv OTHER PATH $nios_dir/transport_layer/altera_jesd204_assembler.sv
        add_fileset_file ed_nios/transport_layer/altera_jesd204_deassembler.sv OTHER PATH $nios_dir/transport_layer/altera_jesd204_deassembler.sv
        add_fileset_file ed_nios/transport_layer/altera_jesd204_transport_tx_top.sv OTHER PATH $nios_dir/transport_layer/altera_jesd204_transport_tx_top.sv
        add_fileset_file ed_nios/transport_layer/altera_jesd204_transport_rx_top.sv OTHER PATH $nios_dir/transport_layer/altera_jesd204_transport_rx_top.sv

        add_fileset_file ed_nios/software/source/altera_jesd204_regs.h OTHER PATH $nios_dir/software/source/altera_jesd204_regs.h
        add_fileset_file ed_nios/software/source/functions.h OTHER PATH $nios_dir/software/source/functions.h
        add_fileset_file ed_nios/software/source/macros.c OTHER PATH $nios_dir/software/source/macros.c
        add_fileset_file ed_nios/software/source/macros.h OTHER PATH $nios_dir/software/source/macros.h
        add_fileset_file ed_nios/software/source/main.c OTHER PATH $nios_dir/software/source/main.c
        add_fileset_file ed_nios/software/source/main.h OTHER PATH $nios_dir/software/source/main.h

        # Qsys file generation
        # copy all qsys files to a temp directory, generate and add generated files to fileset
        set temp_file   [create_temp_file temp.txt]
        set temp_dir    [file dirname $temp_file]
        file delete     $temp_file
        
        foreach qsys_file $qsys_files {
	if {[file dirname $temp_file] != [file dirname $qsys_file]} {
            file copy -force $qsys_file $temp_dir
	}
        }
        
		# Arria 10 does not have .ip file checked-in. Need to use qsys-script to convert the qsys file to qsys pro
        if {[is_qsys_edition QSYS_PRO] && [_ed_device_fileset]} {	
            script_qsys_file "$temp_dir/jesd204b_ed_qsys.qsys"	
            script_qsys_file "$temp_dir/nios_subsystem.qsys"	
            script_qsys_file "$temp_dir/jesd204b_subsystem.qsys"				
			script_qsys_file "$temp_dir/se_outbuf_1bit.qsys"
		}
		
        generate_qsys_file "$temp_dir/jesd204b_ed_qsys.qsys"
        generate_qsys_file "$temp_dir/se_outbuf_1bit.qsys"
		
        add_generated_files_to_fileset ed_nios $temp_dir
        
        # add Quartus project and setting file to fileset
        add_fileset_file ed_nios/jesd204b_ed.qpf OTHER PATH $nios_dir/script/jesd204b_ed.qpf
		
        set template_file           "$nios_dir/script/jesd204b_ed.qsf.terp"
        set template                [ read [ open $template_file r ] ]
        set params(device_family)   $device_family
        set params(device)          $device
        set params(ED_DEV_KIT)      $ED_DEV_KIT
        set params(L)               $L
        if {[is_qsys_edition QSYS_PRO]} {
            set params(qsys_pro)    "1"
        } else {
            set params(qsys_pro)    "0"
        }
        
        set result [altera_terp $template params]
        add_fileset_file ed_nios/jesd204b_ed.qsf OTHER TEXT $result

      }
   
   set GENERIC_ED_TYPE ""
   if {$device_family == "Arria 10"} {
      set GENERIC_ED_TYPE $ED_GENERIC_A10
   } else {
      set GENERIC_ED_TYPE $ED_GENERIC_5SERIES
   }
   
   #Editing the gen_ed_sim.tcl file
   # foreach {language sim_language} $hdl {
   
   if {[string equal $ED_HDL_FORMAT_SIM "VERILOG"]} {
      set language      verilog
      set sim_language  SIM_VERILOG
   } elseif {[string equal $ED_HDL_FORMAT_SIM "VHDL"]} {
      set language      vhdl
      set sim_language  SIM_VHDL
   }
   
      set dut_device_family [get_parameter_value DEVICE_FAMILY]
      set dut_device_part   [get_parameter_value part_trait_dp]
      
      if {[_ed_device_fileset]} {
         set verilog_run_script_file "$ed_sim_scripts_dir/gen_ed_sim_a10.tcl"
      } else {
         set verilog_run_script_file "$ed_sim_scripts_dir/gen_ed_sim.tcl"
      }
      set verilog_output_run_script_file [create_temp_file gen_sim.tcl]
      set out [ open $verilog_output_run_script_file w ]
      set in [open $verilog_run_script_file r]
      
      
      if {[string equal $dut_device_family "Cyclone V"]} {
         set refclk_freq "125.0"
         set lane_rate   "5000"
      } else {
         set refclk_freq "153.6"
         set lane_rate   "6144"
      }
      
      if {$L == "8"} {
         set refclk_freq [expr $refclk_freq * 2]
      }
      set clk $refclk_freq
      
      set PCS_CONFIG [get_parameter_value "PCS_CONFIG"]

      while {[gets $in line] != -1} {
         if {[string match "*DUT_PARAMETERS*" $line]} {
            puts $out $line         
            puts $out "set variant_name $entityname"
            puts $out "set dut_device_family \"$dut_device_family\""
            puts $out "set dut_device_part \"$dut_device_part\""
            puts $out "set sim_gen $sim_language"
            if {[_ed_device_fileset]} {
                if {[is_qsys_edition QSYS_PRO]} {
                    puts $out "set is_qsys_pro \"1\""
                } else {
                    puts $out "set is_qsys_pro \"0\""
                }
            }
            
            foreach {param_name} [get_parameters] {
               set is_derived_param [get_parameter_property $param_name DERIVED]
               set param_value [get_parameter_value $param_name]
               
               if {$is_derived_param == 1 || $param_name == "part_trait_bd" || $param_name == "part_trait_dp"} {
                  continue
               }
               
               if {[string equal $ED_TYPE "RTL"]} {
                  puts $out "lappend dut_parameters \"--component-param=$param_name=$param_value\""
               } elseif {[string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]} {
                  
                  set PCS_CONFIG "JESD_PCS_CFG1"
                  
                  if {$param_name == "L"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=2\""
                  } elseif {$param_name == "M"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=2\""
                  } elseif {$param_name == "F"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=2\""
                  } elseif {$param_name == "GUI_EN_CFG_F"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "GUI_CFG_F"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=2\""
                  } elseif {$param_name == "K"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=16\""
                  } elseif {$param_name == "S"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "wrapper_opt"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=base_phy\""
                  } elseif {$param_name == "DATA_PATH"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=RX_TX\""
                  } elseif {$param_name == "SUBCLASSV"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "lane_rate"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=$lane_rate\""
                  } elseif {$param_name == "PCS_CONFIG"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=JESD_PCS_CFG1\""
                  } elseif {$param_name == "pll_type"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=CMU\""
                  } elseif {$param_name == "REFCLK_FREQ"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=${clk}\""
                  } elseif {$param_name == "bitrev_en"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=false\""
                  } elseif {$param_name == "N"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=16\""
                  } elseif {$param_name == "N_PRIME"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=16\""
                  } elseif {$param_name == "CS"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=0\""
                  } elseif {$param_name == "CF"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=0\""
                  } elseif {$param_name == "HD"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=0\""
                  } elseif {$param_name == "SCR"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "ECC_EN"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "pll_reconfig_enable"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=false\""
                  } elseif {$param_name == "bonded_mode"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=bonded\""
                  } else {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=$param_value\""
                  }
               }
            }
            
            puts $out "set atx_pll_ref_clk $clk"
            
            if {[string equal $PCS_CONFIG "JESD_PCS_CFG1"]} {
               puts $out "set atx_pll_pma_width 20"
            } elseif {[string equal $PCS_CONFIG "JESD_PCS_CFG2"]} { 
               puts $out "set atx_pll_pma_width 40"
            } elseif {[string equal $PCS_CONFIG "JESD_PCS_CFG4"]} {
               puts $out "set atx_pll_pma_width 80"
            } else {
               puts $out "set atx_pll_pma_width 10"
            }
			
         } else {
             puts $out $line
         }
      }
      close $in
      close $out

   if {[string equal $ED_FILESET_SIM "true"] && [expr [string equal $ED_TYPE "RTL"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
      if {[string equal $ED_HDL_FORMAT_SIM "VHDL"] && [string equal $language "vhdl"]} {
         #add_fileset_file ip_sim/gen_sim_$language.tcl OTHER PATH $verilog_output_run_script_file 
         add_fileset_file ed_sim/gen_ed_sim_$language.tcl OTHER PATH $verilog_output_run_script_file
      } elseif {[string equal $ED_HDL_FORMAT_SIM "VERILOG"] && [string equal $language "verilog"]} {
         #add_fileset_file ip_sim/gen_sim_$language.tcl OTHER PATH $verilog_output_run_script_file 
         add_fileset_file ed_sim/gen_ed_sim_$language.tcl OTHER PATH $verilog_output_run_script_file
      }
      add_fileset_file ed_sim/README_EXAMPLE_DESIGN_SIMULATION.txt OTHER PATH $ed_sim_scripts_dir/README_EXAMPLE_DESIGN_SIMULATION.txt



# Generate the run script file to generate EXAMPLE DESIGN Verilog & Vhdl simulation model
      #pll
      #add_fileset_file ed_sim/testbench/pll/core_pll.v OTHER PATH $ed_sim_dir/pll/core_pll.v
      #add_fileset_file ed_sim/testbench/pll/core_pll_0002.v OTHER PATH $ed_sim_dir/pll/core_pll_0002.v
      #spi
      add_fileset_file ed_sim/testbench/spi/spi_master_24.v OTHER PATH $ed_sim_dir/spi/spi_master_24.v
      add_fileset_file ed_sim/testbench/spi/spi_master_32.v OTHER PATH $ed_sim_dir/spi/spi_master_32.v
      #transport_layer
      add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_assembler.sv OTHER PATH $ed_sim_dir/transport_layer/altera_jesd204_assembler.sv
      add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_deassembler.sv OTHER PATH $ed_sim_dir/transport_layer/altera_jesd204_deassembler.sv
      add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_transport_rx_top.sv OTHER PATH $ed_sim_dir/transport_layer/altera_jesd204_transport_rx_top.sv
      add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_transport_tx_top.sv OTHER PATH $ed_sim_dir/transport_layer/altera_jesd204_transport_tx_top.sv
      #pattern
      add_fileset_file ed_sim/testbench/pattern/alternate_checker.sv OTHER PATH $ed_sim_dir/pattern/alternate_checker.sv
      add_fileset_file ed_sim/testbench/pattern/alternate_generator.sv OTHER PATH $ed_sim_dir/pattern/alternate_generator.sv
      add_fileset_file ed_sim/testbench/pattern/pattern_checker_top.sv OTHER PATH $ed_sim_dir/pattern/pattern_checker_top.sv
      add_fileset_file ed_sim/testbench/pattern/pattern_generator_top.sv OTHER PATH $ed_sim_dir/pattern/pattern_generator_top.sv
      add_fileset_file ed_sim/testbench/pattern/prbs_checker.sv OTHER PATH $ed_sim_dir/pattern/prbs_checker.sv
      add_fileset_file ed_sim/testbench/pattern/prbs_generator.sv OTHER PATH $ed_sim_dir/pattern/prbs_generator.sv
      add_fileset_file ed_sim/testbench/pattern/ramp_checker.sv OTHER PATH $ed_sim_dir/pattern/ramp_checker.sv
      add_fileset_file ed_sim/testbench/pattern/ramp_generator.sv OTHER PATH $ed_sim_dir/pattern/ramp_generator.sv
      #control_unit
      #add_fileset_file ed_sim/testbench/control_unit/control_unit.sv OTHER PATH $ed_sim_dir/control_unit/control_unit.sv
      add_fileset_file ed_sim/testbench/control_unit/rom_1port_16.v OTHER PATH $ed_sim_dir/control_unit/rom_1port_16.v
      add_fileset_file ed_sim/testbench/control_unit/rom_1port_128.v OTHER PATH $ed_sim_dir/control_unit/rom_1port_128.v
      add_fileset_file ed_sim/testbench/control_unit/adc.mif OTHER PATH $ed_sim_dir/control_unit/adc.mif
      add_fileset_file ed_sim/testbench/control_unit/clock.mif OTHER PATH $ed_sim_dir/control_unit/clock.mif
      add_fileset_file ed_sim/testbench/control_unit/dac.mif OTHER PATH $ed_sim_dir/control_unit/dac.mif
      add_fileset_file ed_sim/testbench/control_unit/jesd.mif OTHER PATH $ed_sim_dir/control_unit/jesd.mif

      add_fileset_file ed_sim/testbench/mentor/adc.mif OTHER PATH $ed_sim_dir/control_unit/adc.mif
      add_fileset_file ed_sim/testbench/mentor/clock.mif OTHER PATH $ed_sim_dir/control_unit/clock.mif
      add_fileset_file ed_sim/testbench/mentor/dac.mif OTHER PATH $ed_sim_dir/control_unit/dac.mif
      add_fileset_file ed_sim/testbench/mentor/jesd.mif OTHER PATH $ed_sim_dir/control_unit/jesd.mif
      
      add_fileset_file ed_sim/testbench/aldec/adc.mif OTHER PATH $ed_sim_dir/control_unit/adc.mif
      add_fileset_file ed_sim/testbench/aldec/clock.mif OTHER PATH $ed_sim_dir/control_unit/clock.mif
      add_fileset_file ed_sim/testbench/aldec/dac.mif OTHER PATH $ed_sim_dir/control_unit/dac.mif
      add_fileset_file ed_sim/testbench/aldec/jesd.mif OTHER PATH $ed_sim_dir/control_unit/jesd.mif

      add_fileset_file ed_sim/testbench/synopsys/vcs/adc.mif OTHER PATH $ed_sim_dir/control_unit/adc.mif
      add_fileset_file ed_sim/testbench/synopsys/vcs/clock.mif OTHER PATH $ed_sim_dir/control_unit/clock.mif
      add_fileset_file ed_sim/testbench/synopsys/vcs/dac.mif OTHER PATH $ed_sim_dir/control_unit/dac.mif
      add_fileset_file ed_sim/testbench/synopsys/vcs/jesd.mif OTHER PATH $ed_sim_dir/control_unit/jesd.mif

      add_fileset_file ed_sim/testbench/synopsys/vcsmx/adc.mif OTHER PATH $ed_sim_dir/control_unit/adc.mif
      add_fileset_file ed_sim/testbench/synopsys/vcsmx/clock.mif OTHER PATH $ed_sim_dir/control_unit/clock.mif
      add_fileset_file ed_sim/testbench/synopsys/vcsmx/dac.mif OTHER PATH $ed_sim_dir/control_unit/dac.mif
      add_fileset_file ed_sim/testbench/synopsys/vcsmx/jesd.mif OTHER PATH $ed_sim_dir/control_unit/jesd.mif

      add_fileset_file ed_sim/testbench/cadence/adc.mif OTHER PATH $ed_sim_dir/control_unit/adc.mif
      add_fileset_file ed_sim/testbench/cadence/clock.mif OTHER PATH $ed_sim_dir/control_unit/clock.mif
      add_fileset_file ed_sim/testbench/cadence/dac.mif OTHER PATH $ed_sim_dir/control_unit/dac.mif
      add_fileset_file ed_sim/testbench/cadence/jesd.mif OTHER PATH $ed_sim_dir/control_unit/jesd.mif

   
     #Work around for altera_reset_controller
      add_fileset_file ed_sim/testbench/altera_reset_controller/altera_reset_controller.v OTHER PATH $ed_sim_dir/altera_reset_controller/altera_reset_controller.v
      add_fileset_file ed_sim/testbench/altera_reset_controller/altera_reset_synchronizer.v OTHER PATH $ed_sim_dir/altera_reset_controller/altera_reset_synchronizer.v
      
      if {[_ed_device_fileset]} {
        # Insert file sets for Arria 10 ED
        add_fileset_file ed_sim/testbench/control_unit/control_unit.sv OTHER PATH $ed_sim_dir/control_unit/control_unit_a10.sv
        add_fileset_file ed_sim/testbench/control_unit/rom_1port.v OTHER PATH $ed_sim_dir/control_unit/rom_1port.v
        add_fileset_file ed_sim/testbench/control_unit/xcvr_reconfig_mif_master.v OTHER PATH $ed_sim_dir/control_unit/xcvr_reconfig_mif_master.v
        add_fileset_file ed_sim/testbench/control_unit/xcvr_atx_pll_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_atx_pll_combined.mif
        add_fileset_file ed_sim/testbench/control_unit/xcvr_cdr_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_cdr_combined.mif
        add_fileset_file ed_sim/testbench/control_unit/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_a10.mif

        add_fileset_file ed_sim/testbench/mentor/xcvr_atx_pll_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_atx_pll_combined.mif
        add_fileset_file ed_sim/testbench/mentor/xcvr_cdr_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_cdr_combined.mif
        add_fileset_file ed_sim/testbench/mentor/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_a10.mif

        add_fileset_file ed_sim/testbench/aldec/xcvr_atx_pll_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_atx_pll_combined.mif
        add_fileset_file ed_sim/testbench/aldec/xcvr_cdr_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_cdr_combined.mif
        add_fileset_file ed_sim/testbench/aldec/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_a10.mif

        add_fileset_file ed_sim/testbench/synopsys/vcs/xcvr_atx_pll_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_atx_pll_combined.mif
        add_fileset_file ed_sim/testbench/synopsys/vcs/xcvr_cdr_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_cdr_combined.mif
        add_fileset_file ed_sim/testbench/synopsys/vcs/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_a10.mif

        add_fileset_file ed_sim/testbench/synopsys/vcsmx/xcvr_atx_pll_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_atx_pll_combined.mif
        add_fileset_file ed_sim/testbench/synopsys/vcsmx/xcvr_cdr_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_cdr_combined.mif
        add_fileset_file ed_sim/testbench/synopsys/vcsmx/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_a10.mif

        add_fileset_file ed_sim/testbench/cadence/xcvr_atx_pll_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_atx_pll_combined.mif
        add_fileset_file ed_sim/testbench/cadence/xcvr_cdr_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_cdr_combined.mif
        add_fileset_file ed_sim/testbench/cadence/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_a10.mif

        add_fileset_file ed_sim/testbench/models/core_pll_reconfig.qsys OTHER PATH $ed_sim_dir/scripts/core_pll_reconfig.qsys

        set sim_xcvr_atx_pll_qsys_input_file "$ed_sim_dir/scripts/xcvr_atx_pll.qsys"
        set sim_xcvr_atx_pll_qsys_output_file [create_temp_file xcvr_atx_pll.qsys]
        set out [ open $sim_xcvr_atx_pll_qsys_output_file w ]
        set in [open $sim_xcvr_atx_pll_qsys_input_file r]

        while {[gets $in line] != -1} {
           #Parameterize reference clock frequency
           if {[string match "*HW_TCL_PARAM_REFCLK_FREQ*" $line]} {
              regsub "HW_TCL_PARAM_REFCLK_FREQ" $line "$refclk_freq" atx_pll_refclk_freq
              puts $out "$atx_pll_refclk_freq"
           #Parameterize PMA width
           } elseif {[string match "*HW_TCL_PARAM_PMA_WIDTH*" $line]} {
              #If RTL control unit ED specified
              if {[string equal $ED_TYPE "RTL"]} {
	         if {[string equal $PCS_CONFIG_gui "JESD_PCS_CFG1"]} {
                    regsub "HW_TCL_PARAM_PMA_WIDTH" $line "20" atx_pll_pma_width
                    puts $out "$atx_pll_pma_width"
                 } elseif {[string equal $PCS_CONFIG_gui "JESD_PCS_CFG2"]} { 
                    regsub "HW_TCL_PARAM_PMA_WIDTH" $line "40" atx_pll_pma_width
                    puts $out "$atx_pll_pma_width"
                 } elseif {[string equal $PCS_CONFIG_gui "JESD_PCS_CFG4"]} {
                    regsub "HW_TCL_PARAM_PMA_WIDTH" $line "80" atx_pll_pma_width
                    puts $out "$atx_pll_pma_width"
                 } else {
                    regsub "HW_TCL_PARAM_PMA_WIDTH" $line "10" atx_pll_pma_width
                    puts $out "$atx_pll_pma_width"
                 }
              #If generic RTL control unit ED specified
              } else {
                 regsub "HW_TCL_PARAM_PMA_WIDTH" $line "20" atx_pll_pma_width
                 puts $out "$atx_pll_pma_width"
              }
           } else {
              puts $out $line
           }
        }
        close $in
        close $out

        add_fileset_file ed_sim/testbench/models/xcvr_atx_pll.qsys OTHER PATH $sim_xcvr_atx_pll_qsys_output_file

      } else {
        add_fileset_file ed_sim/testbench/control_unit/control_unit.sv OTHER PATH $ed_sim_dir/control_unit/control_unit_sv_av.sv
        add_fileset_file ed_sim/testbench/control_unit/phy_mif_rom.v OTHER PATH $ed_sim_dir/control_unit/phy_mif_rom.v
        add_fileset_file ed_sim/testbench/control_unit/phy.mif OTHER PATH $ed_sim_dir/control_unit/phy.mif
        add_fileset_file ed_sim/testbench/control_unit/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_sv_av.mif

        add_fileset_file ed_sim/testbench/mentor/phy.mif OTHER PATH $ed_sim_dir/control_unit/phy.mif
        add_fileset_file ed_sim/testbench/mentor/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_sv_av.mif

        add_fileset_file ed_sim/testbench/aldec/phy.mif OTHER PATH $ed_sim_dir/control_unit/phy.mif
        add_fileset_file ed_sim/testbench/aldec/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_sv_av.mif

        add_fileset_file ed_sim/testbench/synopsys/vcs/phy.mif OTHER PATH $ed_sim_dir/control_unit/phy.mif
        add_fileset_file ed_sim/testbench/synopsys/vcs/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_sv_av.mif

        add_fileset_file ed_sim/testbench/synopsys/vcsmx/phy.mif OTHER PATH $ed_sim_dir/control_unit/phy.mif
        add_fileset_file ed_sim/testbench/synopsys/vcsmx/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_sv_av.mif

        add_fileset_file ed_sim/testbench/cadence/phy.mif OTHER PATH $ed_sim_dir/control_unit/phy.mif
        add_fileset_file ed_sim/testbench/cadence/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_sv_av.mif

      }
   }
  # }
#}

# Generate the run script file to generate HARDWARE EXAMPLE DESIGN Verilog & Vhdl simulation model
   #foreach {language sim_language} $hdl {

      set pll_refclk_freq $clk

      set dut_device_family [get_parameter_value DEVICE_FAMILY]   
      set dut_device_part   [get_parameter_value part_trait_dp]

      if {[string equal $dut_device_family "Cyclone V"]} {
         if { $F == "8"  } {
            set pll_output_freq0 "62.5 MHz"
         }  else {
            set pll_output_freq0	"125.0 MHz"
         }
      } else {
         if { $F == "8" } {
            set pll_output_freq0 "76.8 MHz"
         }  else {
            set pll_output_freq0	"153.6 MHz"
         }
      }

      if { $F == "8" } {
         set pll_output_freq0_a10 "76.8"
      } else {
         set pll_output_freq0_a10 "153.6"
      }

      set pll_output_freq1_a10 "153.6"

   if {[string equal $ED_FILESET_SYNTH "true"] && [expr [string equal $ED_TYPE "RTL"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
      if {[_ed_device_fileset]} {
         set verilog_run_script_file "$ed_synth_dir/gen_quartus_synth_a10.tcl"
      } else {
         set verilog_run_script_file "$ed_synth_dir/gen_quartus_synth.tcl"
      }
      set verilog_output_run_script_file [create_temp_file gen_quartus_synth.tcl]
      set out [ open $verilog_output_run_script_file w ]
      set in [open $verilog_run_script_file r]
   
      set PCS_CONFIG [get_parameter_value "PCS_CONFIG"]
      
      while {[gets $in line] != -1} {
         if {[string match "*DUT_PARAMETERS*" $line]} {
            puts $out $line         
            puts $out "set variant_name $entityname"
            puts $out "set dut_device_family \"$dut_device_family\""
            puts $out "set dut_device_part \"$dut_device_part\""
            puts $out "set PLL_refclk_freq \"$pll_refclk_freq\""
            puts $out "set pll_output_clk_freq0 \"$pll_output_freq0\""
            if {[_ed_device_fileset]} {
                if {[is_qsys_edition QSYS_PRO]} {
                    puts $out "set is_qsys_pro \"1\""
                } else {
                    puts $out "set is_qsys_pro \"0\""
                }
            }

            foreach {param_name} [get_parameters] {
               set is_derived_param [get_parameter_property $param_name DERIVED]
               set param_value [get_parameter_value $param_name]
               
               if {$is_derived_param == 1 || $param_name == "part_trait_bd" || $param_name == "part_trait_dp"} {
                  continue
               }

               if {[string equal $ED_TYPE "RTL"]} {
                  puts $out "lappend dut_parameters \"--component-param=$param_name=$param_value\""
               } elseif {[string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]} {
                  
                  set PCS_CONFIG "JESD_PCS_CFG1"
                  
                  if {$param_name == "L"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=2\""
                  } elseif {$param_name == "M"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=2\""
                  } elseif {$param_name == "F"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=2\""
                  } elseif {$param_name == "GUI_EN_CFG_F"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "GUI_CFG_F"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=2\""
                  } elseif {$param_name == "K"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=16\""
                  } elseif {$param_name == "S"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "wrapper_opt"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=base_phy\""
                  } elseif {$param_name == "DATA_PATH"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=RX_TX\""
                  } elseif {$param_name == "SUBCLASSV"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "lane_rate"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=$lane_rate\""
                  } elseif {$param_name == "PCS_CONFIG"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=JESD_PCS_CFG1\""
                  } elseif {$param_name == "pll_type"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=CMU\""
                  } elseif {$param_name == "REFCLK_FREQ"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=${clk}\""
                  } elseif {$param_name == "bitrev_en"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=false\""
                  } elseif {$param_name == "N"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=16\""
                  } elseif {$param_name == "N_PRIME"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=16\""
                  } elseif {$param_name == "CS"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=0\""
                  } elseif {$param_name == "CF"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=0\""
                  } elseif {$param_name == "HD"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=0\""
                  } elseif {$param_name == "SCR"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "ECC_EN"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=1\""
                  } elseif {$param_name == "pll_reconfig_enable"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=false\""
                  } elseif {$param_name == "bonded_mode"} {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=bonded\""
                  } else {
                     puts $out "lappend dut_parameters \"--component-param=$param_name=$param_value\""
                  }
               }
            }
            
            if {[string equal $PCS_CONFIG "JESD_PCS_CFG1"]} {
               puts $out "set atx_pll_pma_width 20"
            } elseif {[string equal $PCS_CONFIG "JESD_PCS_CFG2"]} { 
               puts $out "set atx_pll_pma_width 40"
            } elseif {[string equal $PCS_CONFIG "JESD_PCS_CFG4"]} {
               puts $out "set atx_pll_pma_width 80"
            } else {
               puts $out "set atx_pll_pma_width 10"
            }
			

         } elseif {[string match "*Adding_filesets*" $line]} {
            #spi
            add_fileset_file ed_synth/example_design/spi/spi_master_24.v OTHER PATH $ed_sim_dir/spi/spi_master_24.v
            add_fileset_file ed_synth/example_design/spi/spi_master_32.v OTHER PATH $ed_sim_dir/spi/spi_master_32.v
            #transport_layer
            add_fileset_file ed_synth/example_design/transport_layer/altera_jesd204_assembler.sv OTHER PATH $ed_sim_dir/transport_layer/altera_jesd204_assembler.sv
            add_fileset_file ed_synth/example_design/transport_layer/altera_jesd204_deassembler.sv OTHER PATH $ed_sim_dir/transport_layer/altera_jesd204_deassembler.sv
            add_fileset_file ed_synth/example_design/transport_layer/altera_jesd204_transport_rx_top.sv OTHER PATH $ed_sim_dir/transport_layer/altera_jesd204_transport_rx_top.sv
            add_fileset_file ed_synth/example_design/transport_layer/altera_jesd204_transport_tx_top.sv OTHER PATH $ed_sim_dir/transport_layer/altera_jesd204_transport_tx_top.sv
            #pattern
            add_fileset_file ed_synth/example_design/pattern/alternate_checker.sv OTHER PATH $ed_sim_dir/pattern/alternate_checker.sv
            add_fileset_file ed_synth/example_design/pattern/alternate_generator.sv OTHER PATH $ed_sim_dir/pattern/alternate_generator.sv
            add_fileset_file ed_synth/example_design/pattern/pattern_checker_top.sv OTHER PATH $ed_sim_dir/pattern/pattern_checker_top.sv
            add_fileset_file ed_synth/example_design/pattern/pattern_generator_top.sv OTHER PATH $ed_sim_dir/pattern/pattern_generator_top.sv
            add_fileset_file ed_synth/example_design/pattern/prbs_checker.sv OTHER PATH $ed_sim_dir/pattern/prbs_checker.sv
            add_fileset_file ed_synth/example_design/pattern/prbs_generator.sv OTHER PATH $ed_sim_dir/pattern/prbs_generator.sv
            add_fileset_file ed_synth/example_design/pattern/ramp_checker.sv OTHER PATH $ed_sim_dir/pattern/ramp_checker.sv
            add_fileset_file ed_synth/example_design/pattern/ramp_generator.sv OTHER PATH $ed_sim_dir/pattern/ramp_generator.sv
            #control_unit
            #add_fileset_file ed_synth/example_design/control_unit/control_unit.sv OTHER PATH $ed_sim_dir/control_unit/control_unit.sv
            add_fileset_file ed_synth/example_design/control_unit/rom_1port_16.v OTHER PATH $ed_sim_dir/control_unit/rom_1port_16.v
            add_fileset_file ed_synth/example_design/control_unit/rom_1port_128.v OTHER PATH $ed_sim_dir/control_unit/rom_1port_128.v
            add_fileset_file ed_synth/example_design/control_unit/adc.mif OTHER PATH $ed_sim_dir/control_unit/adc.mif
	         add_fileset_file ed_synth/example_design/control_unit/clock.mif OTHER PATH $ed_sim_dir/control_unit/clock.mif	    
	         add_fileset_file ed_synth/example_design/control_unit/dac.mif OTHER PATH $ed_sim_dir/control_unit/dac.mif	
	         add_fileset_file ed_synth/example_design/control_unit/jesd.mif OTHER PATH $ed_sim_dir/control_unit/jesd.mif
	    

            if {[_ed_device_fileset]} {
               # Insert file sets for Arria 10 ED
               add_fileset_file ed_synth/example_design/control_unit/control_unit.sv OTHER PATH $ed_sim_dir/control_unit/control_unit_a10.sv
               add_fileset_file ed_synth/example_design/control_unit/rom_1port.v OTHER PATH $ed_sim_dir/control_unit/rom_1port.v
               add_fileset_file ed_synth/example_design/control_unit/xcvr_reconfig_mif_master.v OTHER PATH $ed_sim_dir/control_unit/xcvr_reconfig_mif_master.v
               add_fileset_file ed_synth/example_design/control_unit/xcvr_atx_pll_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_atx_pll_combined.mif
               add_fileset_file ed_synth/example_design/control_unit/xcvr_cdr_combined.mif OTHER PATH $ed_sim_dir/control_unit/xcvr_cdr_combined.mif
               add_fileset_file ed_synth/example_design/control_unit/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_a10.mif

               add_fileset_file ed_synth/example_design/altera_reset_controller/altera_reset_controller.v OTHER PATH $ed_sim_dir/altera_reset_controller/altera_reset_controller.v
               add_fileset_file ed_synth/example_design/altera_reset_controller/altera_reset_synchronizer.v OTHER PATH $ed_sim_dir/altera_reset_controller/altera_reset_synchronizer.v
            } else {
               add_fileset_file ed_synth/example_design/control_unit/control_unit.sv OTHER PATH $ed_sim_dir/control_unit/control_unit_sv_av.sv
               add_fileset_file ed_synth/example_design/control_unit/phy_mif_rom.v OTHER PATH $ed_sim_dir/control_unit/phy_mif_rom.v
               add_fileset_file ed_synth/example_design/control_unit/phy.mif OTHER PATH $ed_sim_dir/control_unit/phy.mif
               add_fileset_file ed_synth/example_design/control_unit/core_pll.mif OTHER PATH $ed_sim_dir/control_unit/core_pll_sv_av.mif
            }
         } else {
            puts $out $line
         }
      }
      close $in
      close $out
     
      add_fileset_file ed_synth/gen_quartus_synth.tcl OTHER PATH $verilog_output_run_script_file
      add_fileset_file ed_synth/README_EXAMPLE_DESIGN_COMPILATION.txt OTHER PATH $ed_sim_scripts_dir/README_EXAMPLE_DESIGN_COMPILATION.txt      

      if {[_ed_device_fileset]} {
         add_fileset_file ed_synth/example_design/core_pll_reconfig.qsys OTHER PATH $ed_sim_dir/scripts/core_pll_reconfig.qsys
   
         set qsys_input_file "$ed_sim_dir/scripts/xcvr_atx_pll.qsys"
         set qsys_output_file [create_temp_file xcvr_atx_pll.qsys]
         set out [ open $qsys_output_file w ]
         set in [open $qsys_input_file r]
   
         while {[gets $in line] != -1} {
            #Parameterize reference clock frequency
            if {[string match "*HW_TCL_PARAM_REFCLK_FREQ*" $line]} {
               regsub "HW_TCL_PARAM_REFCLK_FREQ" $line "$pll_refclk_freq" atx_pll_refclk_freq
               puts $out "$atx_pll_refclk_freq"
            #Parameterize PMA width
            } elseif {[string match "*HW_TCL_PARAM_PMA_WIDTH*" $line]} {
               #If RTL control unit ED specified
               if {[string equal $ED_TYPE "RTL"]} {
                  if {[string equal $PCS_CONFIG_gui "JESD_PCS_CFG1"]} {
                     regsub "HW_TCL_PARAM_PMA_WIDTH" $line "20" atx_pll_pma_width
                     puts $out "$atx_pll_pma_width"
                  } elseif {[string equal $PCS_CONFIG_gui "JESD_PCS_CFG2"]} { 
                     regsub "HW_TCL_PARAM_PMA_WIDTH" $line "40" atx_pll_pma_width
                     puts $out "$atx_pll_pma_width"
                  } elseif {[string equal $PCS_CONFIG_gui "JESD_PCS_CFG4"]} {
                     regsub "HW_TCL_PARAM_PMA_WIDTH" $line "80" atx_pll_pma_width
                     puts $out "$atx_pll_pma_width"
                  } else {
                     regsub "HW_TCL_PARAM_PMA_WIDTH" $line "10" atx_pll_pma_width
                     puts $out "$atx_pll_pma_width"
                  }
               #If generic RTL control unit ED specified
               } else {
                  regsub "HW_TCL_PARAM_PMA_WIDTH" $line "20" atx_pll_pma_width
                  puts $out "$atx_pll_pma_width"
               }
            } else {
               puts $out $line
            }
         }
         close $in
         close $out
   
         add_fileset_file ed_synth/example_design/xcvr_atx_pll.qsys OTHER PATH $qsys_output_file
   
         set synth_core_pll_qsys_input_file "$ed_sim_dir/scripts/core_pll.qsys"
         set synth_core_pll_qsys_output_file [create_temp_file core_pll.qsys]
         set out [ open $synth_core_pll_qsys_output_file w ]
         set in [open $synth_core_pll_qsys_input_file r]
   
         while {[gets $in line] != -1} {
            #Parameterize reference clock frequency
            if {[string match "*HW_TCL_PARAM_REFCLK_FREQ*" $line]} {
               regsub "HW_TCL_PARAM_REFCLK_FREQ" $line "$pll_refclk_freq" core_pll_refclk_freq
               puts $out "$core_pll_refclk_freq"
            #Parameterize output clock frequency 0
            } elseif {[string match "*HW_TCL_PARAM_OUTPUT_CLOCK_FREQ0*" $line]} {
               regsub "HW_TCL_PARAM_OUTPUT_CLOCK_FREQ0" $line "$pll_output_freq0_a10" core_pll_output_freq0
               puts $out "$core_pll_output_freq0"
            #Parameterize output clock frequency 1
            } elseif {[string match "*HW_TCL_PARAM_OUTPUT_CLOCK_FREQ1*" $line]} {
               regsub "HW_TCL_PARAM_OUTPUT_CLOCK_FREQ1" $line "$pll_output_freq1_a10" core_pll_output_freq1
               puts $out "$core_pll_output_freq1"
            } else {
               puts $out $line
            }
         }
         close $in
         close $out
   
         add_fileset_file ed_synth/example_design/core_pll.qsys OTHER PATH $synth_core_pll_qsys_output_file
      }

      switch -exact $dut_device_family {
         "Arria 10"     {set template_file $ed_sim_scripts_dir/create_project_a10.tcl.terp}
         "Arria V"      {set template_file $ed_sim_scripts_dir/create_project_av.tcl.terp}
         "Arria V GZ"   {set template_file $ed_sim_scripts_dir/create_project_av_gz.tcl.terp}
         "Stratix V"    {set template_file $ed_sim_scripts_dir/create_project_sv.tcl.terp}
         "Cyclone V"    {set template_file $ed_sim_scripts_dir/create_project_cv.tcl.terp}
         default        {send_message error "Device family $dut_device_family not supported"}
      }
      
      set params(dut_device_part) $dut_device_part
      if {[_ed_device_fileset]} {
         if {[is_qsys_edition QSYS_PRO]} {
	        set params(qsys_pro)        "1"
         } else {
	        set params(qsys_pro)        "0"      
         }
      } 
      
      set template   [read [open $template_file r]]
      set result     [altera_terp $template params]
      
      add_fileset_file ed_synth/example_design/create_project.tcl OTHER TEXT $result
   }

   
   

   #set device_part $part
   #set create_project_script_dir "ed_synth/example_design"
   #set project_name "jesd204b_ed"
   #set exe_dir [file join ed_synth example_design]
   #set create_project_script_name [file join [pwd] "create_project.tcl"]
   #set FH [open "$create_project_script_name" w]
   #set FH [open "$create_project_script_name" w]
   #puts $FH "project_new $project_name -overwrite"
   #puts $FH "project_open $project_name"
   #puts $FH "set_global_assignment -name FAMILY \"$dut_device_family\""
   #puts $FH "set_global_assignment -name DEVICE \"$device_part\""
   #puts $FH "set_global_assignment -name TOP_LEVEL_ENTITY jesd204b_ed"
   #puts $FH "set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files"
   #puts $FH "set_global_assignment -name MIN_CORE_JUNCTION_TEMP "-40""
   #puts $FH "set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100""
   #puts $FH "set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256"
   #puts $FH "set_global_assignment -name EDA_SIMULATION_TOOL \"ModelSim-Altera (Verilog)\""
   #puts $FH "set_global_assignment -name EDA_TIME_SCALE \"1 ps\" -section_id eda_simulation"
   #puts $FH "set_global_assignment -name EDA_OUTPUT_DATA_FORMAT \"VERILOG HDL\" -section_id eda_simulation"
   #puts $FH "set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS TEST_BENCH_MODE -section_id eda_simulation"
   #puts $FH "set_global_assignment -name EDA_TEST_BENCH_NAME uniphy_rtl_simulation -section_id eda_simulation"
   #puts $FH "set_global_assignment -name EDA_DESIGN_INSTANCE_NAME dut -section_id uniphy_rtl_simulation"
   #puts $FH "set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME ddr3_example_tb -section_id uniphy_rtl_simulation"
   #puts $FH "set_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH uniphy_rtl_simulation -section_id eda_simulation"
   #puts $FH "set_global_assignment -name EDA_MAP_ILLEGAL_CHARACTERS ON -section_id eda_simulation"
   #puts $FH "set_global_assignment -name EDA_ENABLE_GLITCH_FILTERING ON -section_id eda_simulation"
   #puts $FH "set_global_assignment -name EDA_WRITE_NODES_FOR_POWER_ESTIMATION ALL_NODES -section_id eda_simulation"
   #puts $FH "set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top"
   #puts $FH "set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top"
   #puts $FH "set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top"
   #puts $FH "set_instance_assignment -name GLOBAL_SIGNAL OFF -to altera_reset_controller*u_*rst_sync|altera_reset_synchronizer*int_chain_out"
   #puts $FH "set_global_assignment -name VERILOG_FILE core_pll_module/core_pll.v"
   #puts $FH "set_global_assignment -name VERILOG_FILE jesd204b_ed.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE transport_layer/altera_jesd204_transport_tx_top.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE transport_layer/altera_jesd204_transport_rx_top.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE transport_layer/altera_jesd204_deassembler.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE transport_layer/altera_jesd204_assembler.sv"
   #puts $FH "set_global_assignment -name VERILOG_FILE spi/spi_master_24.v"
   #puts $FH "set_global_assignment -name VERILOG_FILE spi/spi_master_32.v"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE pattern/alternate_checker.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE pattern/alternate_generator.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE pattern/pattern_checker_top.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE pattern/pattern_generator_top.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE pattern/prbs_checker.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE pattern/prbs_generator.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE pattern/ramp_checker.sv"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE pattern/ramp_generator.sv"
   #puts $FH "set_global_assignment -name VERILOG_FILE control_unit/rom_1port_16.v"
   #puts $FH "set_global_assignment -name VERILOG_FILE control_unit/rom_1port_128.v"
   #puts $FH "set_global_assignment -name SYSTEMVERILOG_FILE control_unit/control_unit.sv"
   #puts $FH "set_global_assignment -name QIP_FILE xcvr_reset_control_module/xcvr_reset_control.qip"
   #puts $FH "set_global_assignment -name QIP_FILE XCVR_reconfig_module/XCVR_reconfig.qip"
   #puts $FH "set_global_assignment -name QIP_FILE core_pll_reconfig_module/core_pll_reconfig.qip"
   #puts $FH "set_global_assignment -name QIP_FILE altera_jesd204/altera_jesd204.qip"
   #puts $FH "set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top"
   #puts $FH "set_global_assignment -name SDC_FILE ed.sdc"
   #puts $FH       set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 5_H4"
   #puts $FH "project_close"
   #close $FH

   #add_fileset_file ed_synth/example_design/create_project.tcl OTHER PATH $ed_sim_scripts_dir/create_project_av.tcl


   #cd $create_project_script_dir
   #set qdir $::env(QUARTUS_ROOTDIR)
   #catch {eval [concat [list exec "$cd example_design" ]} temp
   #set cmd  [list exec "$qdir/bin/quartus_sh" "-t" $create_project_script_name --output-directory=$create_project_script_dir]
   # catch { eval $cmd  } temp
   #puts $temp
   #return $temp
   #puts $create_project_script_dir
   #catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=alt_xcvr_reconfig ] $arg_list_xcvr_reconfig $xcvr_reconfig_parameters]} temp
   #catch {file delete -force "db"} temp_result
   #catch {file delete -force -- $create_project_script_name} temp_result



   #set project_file_dir "ed_synth/example_design/"
   #set qpf [open "$project_file/$entityname.qpf" w]
   #   puts $qpf 
   #close $qpf
   #set temp_result "$project_file/$entityname.qpf"





# We dont want to mix the ip_sim with ed_sim as the stuff may be different or in the future we may want
#add in new stuff. it may hard to integrate to the ip_sim.Therefore, creating separate will be more robust 
#in changing the flow. 
# This proc do the following tasks:
# - Creates testbench run script
# - Create waveform do file that is called in testbench run script
proc add_tb_top_scripts {entityname tbdir ed_sim_scripts_dir} {
 set ED_FILESET_SIM [get_parameter_value "ED_FILESET_SIM"]
 set ED_TYPE [get_parameter_value "ED_TYPE"]
 set device_family [get_parameter_value DEVICE_FAMILY]
 
   set GENERIC_ED_TYPE ""
   if {[param_matches DEVICE_FAMILY "Arria 10"]} {
      set GENERIC_ED_TYPE [get_parameter_value ED_GENERIC_A10]
   } else {
      set GENERIC_ED_TYPE [get_parameter_value ED_GENERIC_5SERIES]
   }
 
 if {[string equal $ED_FILESET_SIM "true"] && [expr [string equal $ED_TYPE "RTL"] || [string equal $ED_TYPE "DATAPATH"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
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
               #puts $tb_out "cp -f \$dir/control_unit/adc.mif ./ "
               #puts $tb_out "cp -f \$dir/control_unit/clock.mif ./ "
               #puts $tb_out "cp -f \$dir/control_unit/dac.mif ./ "
   
            } elseif {[string match "*SOURCE_SCRIPTS*" $line]} {
               puts $tb_out "source \$SETUP_SCRIPTS/$simulator/$simulator_source_script"

            } elseif {[string match "*TESTBENCH_COMPILE_COMMAND*" $line]} {
#               puts $out "vlog -sv -work work +incdir+\$testbench_model_dir \$testbench_model_dir/*.sv"
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
	 if {[string equal $device_family "Stratix 10"]} {
         add_fileset_file ed_sim/testbench/$simulator/tb_top_waveform.do OTHER PATH $ed_sim_scripts_dir/tb_top_waveform_s10.do
	 } else { 
	 add_fileset_file ed_sim/testbench/$simulator/tb_top_waveform.do OTHER PATH $ed_sim_scripts_dir/tb_top_waveform.do
	 }

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
              # puts $out "cp -f \$modules_dir/control_unit/adc.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/clock.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/dac.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/jesd.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/phy.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/core_pll.mif ./"
	       puts $out "cp ../../setup_scripts/synopsys/$simulator/synopsys_sim.setup ."
               puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_top\" SKIP_ELAB=1 SKIP_SIM=1"

            } elseif {[string match "*TESTBENCH_COMPILE_COMMAND*" $line]} {
#               puts $out "vlogan +v2k -sverilog -work work  \$testbench_model_dir/*.sv"
               #puts $out "vlogan +v2k -sverilog -work work" 
               #puts \$testbench_model_dir/*.v  \$modules_dir/control_unit/*.v  \$modules_dir/spi/*.v \$modules_dir/pll/*.v  \$modules_dir/transport_layer/*.sv  \$modules_dir/pattern/*.v"

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
              # puts $out "cp -f \$modules_dir/control_unit/adc.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/clock.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/dac.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/jesd.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/phy.mif ./"
              # puts $out "cp -f \$modules_dir/control_unit/core_pll.mif ./"
	       #puts $out "cp ../../setup_scripts/synopsys/$simulator/synopsys_sim.setup ."
               puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_top\" SKIP_ELAB=1 SKIP_SIM=1 USER_DEFINED_ELAB_OPTIONS=\"-debug_pp\" "
       
            } elseif {[string match "*TESTBENCH_SIM*" $line]} {
               puts $out "./simv -ucli -l sim.log -do \$dut_wave_do"
              #puts $out "vlogan +v2k -sverilog -work work  \$testbench_model_dir/*.v  \$modules_dir/control_unit/*.v  \$modules_dir/spi/*.v #\$modules_dir/pll/*.v  \$modules_dir/transport_layer/*.sv  \$modules_dir/pattern/*.v"

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
#	       puts $out ""
               puts $out "cp ../setup_scripts/$simulator/cds.lib ."
               puts $out "cp -rf ../setup_scripts/$simulator/cds_libs ."
               puts $out "cp ../setup_scripts/$simulator/hdl.var ."
              # puts $out "cp ../control_unit/adc.mif ./"
              # puts $out "cp ../control_unit/clock.mif ./"
              # puts $out "cp ../control_unit/dac.mif ./"
              # puts $out "cp ../control_unit/jesd.mif ./"
              # puts $out "cp ../control_unit/phy.mif ./"
              # puts $out "cp ../control_unit/core_pll.mif ./"
               puts $out ". \$SETUP_SCRIPTS TOP_LEVEL_NAME=\"tb_top\" SKIP_ELAB=1 SKIP_SIM=1"

            } elseif {[string match "*TESTBENCH_ELAB*" $line]} {
#               puts $out "ncvlog -sv -work work  \$testbench_model_dir/*.sv"
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
}



proc add_top_level_components {entityname ed_sim_scripts_dir ed_sim_dir} {
   
   set ED_FILESET_SYNTH [get_parameter_value "ED_FILESET_SYNTH"]
   set ED_FILESET_SIM [get_parameter_value "ED_FILESET_SIM"]
   set ED_TYPE [get_parameter_value "ED_TYPE"]
   
   set GENERIC_ED_TYPE ""
   if {[param_matches DEVICE_FAMILY "Arria 10"]} {
      set GENERIC_ED_TYPE [get_parameter_value ED_GENERIC_A10]
   } else {
      set GENERIC_ED_TYPE [get_parameter_value ED_GENERIC_5SERIES]
   }
   
   # ---------------------------------
   #   Terp for top level testbench
   # ---------------------------------
   set L_gui [get_parameter_value "L"]
   set M_gui [get_parameter_value "M"]
   set F_gui [get_parameter_value "F"]
   set S_gui [get_parameter_value "S"]
   set N_gui [get_parameter_value "N"]
   set N_PRIME_gui [get_parameter_value "N_PRIME"]
   set CS_gui [get_parameter_value "CS"]
   set device_family [get_parameter_value "DEVICE_FAMILY"]
   set pll_reconfig_enable_gui [get_parameter_value "pll_reconfig_enable"]
   set bonded_mode_gui [get_parameter_value "bonded_mode"]
  

   if {[string equal $ED_TYPE "RTL"]} {
      set L $L_gui
      set M $M_gui
      set F $F_gui
      set S $S_gui
      set N $N_gui
      set N_PRIME $N_PRIME_gui
   } elseif {[string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]} {
      set L "2"
      set M "2"
      set F "2"
      set S "1"
      set N "16"
      set N_PRIME "16"
      set pll_reconfig_enable_gui "false"
      set bonded_mode_gui "bonded"
   } else {
      return
   }

   
   
   # In ACDS 14.0, dynamic reconfiguration ED generation only supports LMF=222 and non_bonded mode.
   if { [string equal $pll_reconfig_enable_gui "true"] && [expr {$L == "2" && $M == "2" && $F == "2"}] && [string equal $bonded_mode_gui "non_bonded"] } {
      set RECONFIG_LOGIC "1"
   } else {
      set RECONFIG_LOGIC "0"
   }

   if { [string equal $bonded_mode_gui "bonded"] } {
      set BONDED_LOGIC "1"
   } else {
      set BONDED_LOGIC "0"
   }

   #foreach LINK { $L $M } {
   if { [expr {$L == "1" && $M == "1" && $F == "2"}] || [expr {$L == "2" && $M == "2" && $F == "2"}] } {
      set LINK "2"
   } else {
       set LINK	"1"  
	}
   set LINK_DERIVED ${LINK}

 # Hacking for LMF= 112 and LMF=222 as the formula will be different 
  if { [expr {$L == "1" && $M == "1" && $F == "2"}] } {
     set tx_lane_powerdown "i"
     set pll_locked "i"
     set rx_lane_powerdown "i"
     set reconfig_to_xcvr_formula "i*140+139:i*140"
     set reconfig_from_xcvr_formula "i*92+91:i*92"
   } else {
     set tx_lane_powerdown "i*L+1:i*L"
     set pll_locked "i*L+1:i*L"
     set rx_lane_powerdown "i*L+1:i*L"
     set reconfig_to_xcvr_formula "i*210+209:i*210"
     set reconfig_from_xcvr_formula "i*138+137:i*138"
   }


 #}
  if {[string equal $device_family "Cyclone V"]} {
	  if { $F == "1"  } {
		  set FREQ "125.0 MHz"
		  set F1_FRAME_DIV "4"
		  # F2 not used. set to default value.
		  set F2_FRAME_DIV "2"    
		  set c_cnt_bypass_en "false"
		  # set VCO divide by 3
		  set c_cnt_hi_div "2"    
		  set c_cnt_lo_div "1"  
		  set c_cnt_odd_div_duty_en "true"       
		} elseif { $F == "4" } {
		   set FREQ	"125.0 MHz" 
		   set F1_FRAME_DIV "1" 
		   # F2 not used. set to default value.
		   set F2_FRAME_DIV "2"
		   set c_cnt_bypass_en "false"
		   # set VCO divide by 3
		   set c_cnt_hi_div "2"    
		   set c_cnt_lo_div "1"    
		   set c_cnt_odd_div_duty_en "true"       
		} elseif { $F == "8" } {
		   set FREQ "62.5 MHz"
		   set F1_FRAME_DIV "1"
		   # F2 not used. set to default value.
		   set F2_FRAME_DIV "2"    
		   set c_cnt_bypass_en "false"
		   # set VCO divide by 6
		   set c_cnt_hi_div "3"    
		   set c_cnt_lo_div "3"  
		   set c_cnt_odd_div_duty_en "false"             
		}  else {
		   set FREQ "125.0 MHz"
		   # F1 not used. set to default value.
		   set F1_FRAME_DIV "2" 
		   set F2_FRAME_DIV "2"     
		   set c_cnt_bypass_en "false" 
		   # set VCO divide by 3
		   set c_cnt_hi_div "2"    
		   set c_cnt_lo_div "1"      
		   set c_cnt_odd_div_duty_en "true"     
		}
		set PLL_FREQUENCY ${FREQ}
		## This is the PLL VCO for Cyclone 5
		set PLL_VCO_FREQUENCY "375.0 MHz"
		set F1_DIV ${F1_FRAME_DIV}
		set F2_DIV ${F2_FRAME_DIV}
		set c_cnt_hi_div0 ${c_cnt_hi_div}
		set c_cnt_lo_div0 ${c_cnt_lo_div}
		set c_cnt_bypass_en0 ${c_cnt_bypass_en}
		set c_cnt_odd_div_duty_en0 ${c_cnt_odd_div_duty_en}
		set m_cnt_odd_div_duty_en "true"

		  set refclk "125.0 MHz"
		  set clk_period "8000"
		  set pll_refclk_period "8.000"
		  set var_clk "CLK125MHZ_PERIOD"
		  set m_cnt_bypass_en "false"
		  set m_cnt_hi_div "2"
		  set m_cnt_lo_div "1"
		  if { $BONDED_LOGIC == "1" } {
			 set pll_declaration "LINK-1:0"
			 set num_pll "LINK"
			 set pll_powerdown "i"
			 ## still write out the correct number of reconfig interface although reconfiguration only support unbonded for now
			 set reconfig_interface "L+1"
		  } else {
			 set pll_declaration "LINK*L-1:0"
			 set num_pll "LINK*L"
			 set pll_powerdown "i*L+L-1:i*L"
			 ## reconfig only support unbonded for now
			 set reconfig_interface "2 * L"
		  }

    } else {
	  if { $F == "1"  } {
		  set FREQ "153.6 MHz"
		  set F1_FRAME_DIV "4"
		  # F2 not used. set to default value.
		  set F2_FRAME_DIV "2"    
		  set c_cnt_bypass_en "false"
		  # set VCO divide by 2
		  set c_cnt_div "1"    
		  set c_cnt_odd_div_duty_en "false"         
		} elseif { $F == "4" } {
		   set FREQ	"153.6 MHz" 
		   set F1_FRAME_DIV "1" 
		   # F2 not used. set to default value.
		   set F2_FRAME_DIV "2"
		   set c_cnt_bypass_en "false"
		   # set VCO divide by 2
		   set c_cnt_div "1"   
		   set c_cnt_odd_div_duty_en "false"          
		} elseif { $F == "8" } {
		   set FREQ "76.8 MHz"
		   set F1_FRAME_DIV "1"
		   # F2 not used. set to default value.
		   set F2_FRAME_DIV "2"    
		   set c_cnt_bypass_en "false"
		   # set VCO divide by 4
		   set c_cnt_div "2"
		   set c_cnt_odd_div_duty_en "false"             
		}  else {
		   set FREQ "153.6 MHz"
		   # F1 not used. set to default value.
		   set F1_FRAME_DIV "2" 
		   set F2_FRAME_DIV "2"     
		   set c_cnt_bypass_en "false" 
		   # c counter divider bypassed. set divider value to 256
		   set c_cnt_div "1"   
		   set c_cnt_odd_div_duty_en "false"        
		}
		set PLL_FREQUENCY ${FREQ}
		## This is the PLL VCO for Stratix 5 and Arria 5. Need to revise for Arria 10
		set PLL_VCO_FREQUENCY "307.2 MHz"
		set F1_DIV ${F1_FRAME_DIV}
		set F2_DIV ${F2_FRAME_DIV}
		set c_cnt_hi_div0 ${c_cnt_div}
		set c_cnt_lo_div0 ${c_cnt_div}
		set c_cnt_bypass_en0 ${c_cnt_bypass_en}
		set c_cnt_odd_div_duty_en0 ${c_cnt_odd_div_duty_en}
		set m_cnt_odd_div_duty_en "false"

	  if { $L == "8" } {
		  set refclk "307.2 MHz"
		  set clk_period "3255"
		  set pll_refclk_period "3.255"
		  set var_clk "CLK307M2HZ_PERIOD"
		  set pll_declaration "LINK*L-1:0"
		  set num_pll "LINK*L"
		  set pll_powerdown "i*L+L-1:i*L"
		  set reconfig_interface "2 * L"
		  set m_cnt_bypass_en "true"
		  set m_cnt_hi_div "256"
		  set m_cnt_lo_div "256"

		}  else {
		  set refclk "153.6 MHz"
		  set clk_period "6510"
		  set pll_refclk_period "6.510"
		  set var_clk "CLK153M6HZ_PERIOD"
		  set m_cnt_bypass_en "false"
		  set m_cnt_hi_div "1"
		  set m_cnt_lo_div "1"

		  if { $BONDED_LOGIC == "1" } {
			 set pll_declaration "LINK-1:0"
			 set num_pll "LINK"
			 set pll_powerdown "i"
			 ## still write out the correct number of reconfig interface although reconfiguration only support unbonded for now
			 set reconfig_interface "L+1"
		  } else {
			 set pll_declaration "LINK*L-1:0"
			 set num_pll "LINK*L"
			 set pll_powerdown "i*L+L-1:i*L"
			 ## reconfig only support unbonded for now
			 set reconfig_interface "2 * L"
		  }

		}
    }
    set REFCLK ${refclk}
    set CLK_PERIOD ${clk_period}
    set VAR_CLK ${var_clk}
    set PLL_DECLARATION ${pll_declaration}
    set NUM_PLL ${num_pll}
    set RECONFIG_INTERFACE ${reconfig_interface}
    set m_cnt_hi_div ${m_cnt_hi_div}
    set m_cnt_lo_div ${m_cnt_lo_div}
    set m_cnt_bypass_en ${m_cnt_bypass_en}

    #Do Terp
    set template_file [ file join $ed_sim_scripts_dir "tb_top.sv.terp" ]  
    set template   [ read [ open $template_file r ] ]
    set params(CLK_PERIOD) $CLK_PERIOD
    set params(VAR_CLK) $VAR_CLK
    set params(LINK_DERIVED) $LINK_DERIVED
    set params(L) $L
    set params(M) $M
    set params(F) $F
    set params(S) $S
    set params(N) $N
    set params(N_PRIME) $N_PRIME
    set params(F1_DIV) $F1_DIV
    set params(F2_DIV) $F2_DIV
    set params(RECONFIG_LOGIC) $RECONFIG_LOGIC

    set result   [ altera_terp $template params ]

    if {[string equal $ED_FILESET_SIM "true"] && [expr [string equal $ED_TYPE "RTL"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
       # Add top level testbench
       add_fileset_file ed_sim/testbench/models/tb_top.sv VERILOG TEXT $result
    }


    #jesd204ed Terp

    if {[_ed_device_fileset]} {
       set template1_file [ file join $ed_sim_scripts_dir "jesd204b_ed_a10.sv.terp" ]  
    } else {
       set template1_file [ file join $ed_sim_scripts_dir "jesd204b_ed_sv_av.sv.terp" ]  
    }
    set template1   [ read [ open $template1_file r ] ]
    set params(LINK_DERIVED) $LINK_DERIVED
    set params(L) $L
    set params(M) $M
    set params(F) $F
    set params(S) $S
    set params(N) $N
    set params(N_PRIME) $N_PRIME
    set params(CS) $CS_gui
    set params(device_family) $device_family
    set params(pll_declaration) $pll_declaration
    set params(num_pll) $num_pll
    set params(reconfig_interface) $reconfig_interface
    set params(tx_lane_powerdown) $tx_lane_powerdown
    set params(pll_locked) $pll_locked
    set params(rx_lane_powerdown) $rx_lane_powerdown
    set params(pll_powerdown) $pll_powerdown
    set params(reconfig_to_xcvr_formula) $reconfig_to_xcvr_formula
    set params(reconfig_from_xcvr_formula) $reconfig_from_xcvr_formula
    set params(RECONFIG_LOGIC) $RECONFIG_LOGIC
    set params(BONDED_LOGIC) $BONDED_LOGIC
    set params(F1_DIV) $F1_DIV
    set params(F2_DIV) $F2_DIV
    
    set result   [ altera_terp $template1 params ]

    # Add top level testbench
    if {[string equal $ED_FILESET_SIM "true"] && [expr [string equal $ED_TYPE "RTL"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
       add_fileset_file ed_sim/testbench/models/jesd204b_ed.sv VERILOG TEXT $result
    } 
    if {[string equal $ED_FILESET_SYNTH "true"] && [expr [string equal $ED_TYPE "RTL"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
       add_fileset_file ed_synth/example_design/jesd204b_ed.sv VERILOG TEXT $result
    }

    if {[string equal $device_family "Cyclone V"]} {
      set template2_file [ file join $ed_sim_dir/pll "core_pll_cv.v.terp" ]  
    } else {
      set template2_file [ file join $ed_sim_dir/pll "core_pll.v.terp" ]  
    }
    set template2   [ read [ open $template2_file r ] ]
    set params(REFCLK) $REFCLK
    set params(PLL_FREQUENCY) $PLL_FREQUENCY
    set params(PLL_VCO_FREQUENCY) $PLL_VCO_FREQUENCY
    set params(device_family) $device_family
    set params(m_cnt_hi_div) $m_cnt_hi_div
    set params(m_cnt_lo_div) $m_cnt_lo_div
    set params(m_cnt_bypass_en) $m_cnt_bypass_en
    set params(c_cnt_hi_div0) $c_cnt_hi_div0
    set params(c_cnt_lo_div0) $c_cnt_lo_div0
    set params(c_cnt_bypass_en0) $c_cnt_bypass_en0
    set params(c_cnt_odd_div_duty_en0) $c_cnt_odd_div_duty_en0
    set params(m_cnt_odd_div_duty_en) $m_cnt_odd_div_duty_en
    set result   [ altera_terp $template2 params ]

   # Add pll files
    if {[string equal $ED_FILESET_SIM "true"] && [expr [string equal $ED_TYPE "RTL"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
       add_fileset_file ed_sim/testbench/pll/core_pll.v VERILOG TEXT $result
    }


    set template3_file [ file join $ed_sim_dir/scripts "ed.sdc.terp" ]  
    set template3   [ read [ open $template3_file r ] ]
    set params(PLL_REFCLK_PERIOD) $pll_refclk_period
    set result   [ altera_terp $template3 params ]

   # Add pll files
    if {[string equal $ED_FILESET_SYNTH "true"] && [expr [string equal $ED_TYPE "RTL"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
       add_fileset_file ed_synth/example_design/ed.sdc VERILOG TEXT $result
    }


   # Create package to store parameterization for IP variant
   set output_file  [ create_temp_file altera_jesd204_tb_var_functions.sv ]
   set out   [ open $output_file w ]

   puts $out "\/\/ Package Declaration"
   puts $out "package altera_jesd204_tb_var_functions\;"
      	         
   foreach param [get_parameters] {
      set type [ get_parameter_property $param TYPE ]
      
      # overwrite parameter value for generic example
      if {[string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]} {
         if {$param == "L"} {
            set value 2
         } elseif {$param == "M"} {
            set value 2
         } elseif {$param == "F"} {
            set value 2
         } elseif {$param == "GUI_EN_CFG_F"} {
            set value 1
         } elseif {$param == "GUI_CFG_F"} {
            set value 2
         } elseif {$param == "K"} {
            set value 16
         } elseif {$param == "S"} {
            set value 1
         } elseif {$param == "wrapper_opt"} {
            set value base_phy
         } elseif {$param == "DATA_PATH"} {
            set value RX_TX
         } elseif {$param == "SUBCLASSV"} {
            set value 1
         } elseif {$param == "lane_rate"} {
               if {[string equal $device_family "Cyclone V"]} {
                  set value "5000"
               } else {
                  set value "6144"
               }
         } elseif {$param == "PCS_CONFIG"} {
            set value JESD_PCS_CFG1
         } elseif {$param == "pll_type"} {
            set value CMU
         } elseif {$param == "REFCLK_FREQ"} {
            if {[string equal $device_family "Cyclone V"]} {
               set value "125.0"
            } else {
               set value "153.6"
            }
         } elseif {$param == "bitrev_en"} {
            set value false
         } elseif {$param == "N"} {
            set value 16
         } elseif {$param == "N_PRIME"} {
            set value 16
         } elseif {$param == "CS"} {
            set value 0
         } elseif {$param == "CF"} {
            set value 0
         } elseif {$param == "HD"} {
            set value 0
         } elseif {$param == "SCR"} {
            set value 1
         } elseif {$param == "ECC_EN"} {
            set value 1
         } elseif {$param == "pll_reconfig_enable"} {
            set value false
         } elseif {$param == "bonded_mode"} {
            set value bonded
         } else {
            set value [ get_parameter_value $param ]
         }
      } else {
         set value [ get_parameter_value $param ]
      }
      
      if { [ string compare -nocase $type BOOLEAN ] == 0 } {
         if { [ string compare -nocase $value true ] == 0 } {
            set argument "-parameterization.$param:1"
            puts $out "parameter ${param}    = 1\'b1\;"
         } else {
            set argument "-parameterization.$param:0"
            puts $out "parameter ${param}    =1\'b0 \;"
         }
      } elseif { [ string compare -nocase $type INTEGER ] == 0 } {
         set argument "-parameterization.$param:$value"
         puts $out "parameter ${param}    =${value}\;"
      } else {
         puts $out "parameter ${param}    =\"${value}\"\;"
      }
   }
   puts $out "endpackage"  
   close $out

   # add parameters package file
   if {[string equal $ED_FILESET_SIM "true"] && [expr [string equal $ED_TYPE "RTL"] || [expr [string equal $ED_TYPE "NONE"] && [string equal $GENERIC_ED_TYPE "RTL"]]]} {
      #add_fileset_file ip_sim/testbench/models/altera_jesd204_tb_var_functions.sv SYSTEM_VERILOG PATH ${output_file} 
      add_fileset_file ed_sim/testbench/models/altera_jesd204_tb_var_functions.sv SYSTEM_VERILOG PATH ${output_file} 
   }

}

# Generation flow for Stratix-10
if { [ string equal $device_family "Stratix 10" ] } {
    
    # Retreieve again the following parameter from GUI as they are previous hard coded to certain value in other function and cannot be reused here.
    set data_path_s10 [get_parameter_value "DATA_PATH"]
    set subclass_s10 [get_parameter_value "SUBCLASSV"]
    set lane_rate_s10 [get_parameter_value "lane_rate"]
    set PCS_CONFIG_gui_s10 [get_parameter_value "PCS_CONFIG"]
    set pll_type_s10 [get_parameter_value "pll_type"]
    set bonded_mode_s10 [get_parameter_value "bonded_mode"]
    set refclk_freq_s10 [get_parameter_value "REFCLK_FREQ"]
    set bitrev_en_s10 [get_parameter_value "bitrev_en"]
    set L_s10 [get_parameter_value "L"]
    set M_s10 [get_parameter_value "M"]
    set GUI_EN_CFG_F_s10 [get_parameter_value "GUI_EN_CFG_F"]
    set GUI_CFG_F_s10 [get_parameter_value "GUI_CFG_F"]
    set N_s10 [get_parameter_value "N"]
    set N_PRIME_s10 [get_parameter_value "N_PRIME"]
    set S_s10 [get_parameter_value "S"]
    set K_s10 [get_parameter_value "K"]
    set SCR_s10 [get_parameter_value "SCR"]
    set CS_s10 [get_parameter_value "CS"]
    set CF_s10 [get_parameter_value "CF"]
    set HD_s10 [get_parameter_value "HD"]
    set ECC_EN_s10 [get_parameter_value "ECC_EN"]
    set F_s10 [get_parameter_value "F"]
    
    # Create temp directory and copy all .ip and .qsys files to temp directory for
    # qsys-script and qsys-generate operation
    set temp_file   [create_temp_file /synth/temp.txt]
    set temp_dir    [file dirname $temp_file]
    file delete     $temp_file
    
    set temp_file2   [create_temp_file /sim/temp.txt]
    set temp_dir2    [file dirname $temp_file2]
    file delete     $temp_file2

#    send_message INFO "temp_dir : $temp_dir"
#    send_message INFO "temp_dir2 : $temp_dir2"

   if {[string equal $ED_FILESET_SIM "true"]} {
	file mkdir ${temp_dir2}/models
    	file copy -force $ed_sim_scripts_dir/ip $temp_dir2/models
	file copy -force $ed_sim_scripts_dir/jesd204b_subsystem_s10.qsys $temp_dir2/models
	file copy -force $ed_sim_scripts_dir/jesd204b_ed_qsys_sim/jesd204b_ed_qsys.qsys $temp_dir2/models
	file copy -force $ed_sim_scripts_dir/jesd204b_ed.qpf $temp_dir2/models
    }
    
    if {[string equal $ED_FILESET_SYNTH "true"]} {
        file copy -force $ed_sim_scripts_dir/ip $temp_dir
	file copy -force $ed_sim_scripts_dir/jesd204b_subsystem_s10.qsys $temp_dir
    	file copy -force $ed_sim_scripts_dir/jesd204b_ed_qsys.qsys $temp_dir
	file copy -force $ed_sim_scripts_dir/jesd204b_ed.qpf $temp_dir
    }

    # Set parameters
    if { $L_s10 == "8" } {
        set link_clk_s10  [ expr $lane_rate_s10 / 40 ]
        set frame_clk_s10 [ expr $link_clk_s10 / 2 ]
        set VAR_CLK "CLK307M2HZ_PERIOD"
    } else {
        set link_clk_s10  [ expr $lane_rate_s10 / 40 ]
        set frame_clk_s10 [ expr $link_clk_s10 ]
        set VAR_CLK "CLK153M6HZ_PERIOD"
    }
    
    set CLK_PERIOD [ expr int(1000000/$refclk_freq_s10) ]

    set refclk_freq_hz [ expr $refclk_freq_s10 * 1000000 ]
    set link_clk_hz [ expr $link_clk_s10 * 1000000 ]
    set frame_clk_hz [ expr $frame_clk_s10 * 1000000 ]

    set atx_pll_output_clock_freq [ expr $lane_rate_s10 / 2 ]

    set refclk_period_ns [ expr 1000/$refclk_freq_s10 ]

    if {[string equal $PCS_CONFIG_gui_s10 "JESD_PCS_CFG1"]} {
        set pma_width 20
    } elseif {[string equal $PCS_CONFIG_gui_s10 "JESD_PCS_CFG2"]} { 
        set pma_width 40
    } elseif {[string equal $PCS_CONFIG_gui_s10 "JESD_PCS_CFG4"]} {
        set pma_width 80
    } else {
        set pma_width 10
    }
    
    set LINK_DERIVED 1 
    set F1_DIV 2
    set F2_DIV 2

    if {[string equal $ED_FILESET_SYNTH "true"]} {
    # Generate TCL file to parameterize jesd204b_subsystem_s10 Qsys system
    set jesd204b_subsystem_tcl_generated_file [ create_temp_file /synth/jesd204b_subsystem_s10.tcl ]
    set out [ open $jesd204b_subsystem_tcl_generated_file w ]

    puts $out "package require -exact qsys 16.1"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_clk_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_clk_0 {clockFrequency} {$refclk_freq_hz}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_clk_0 {inputClockFrequency} {$refclk_freq_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_clk_1.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_clk_0 {clockFrequency} {$link_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_clk_2.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_clk_0 {clockFrequency} {$frame_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_jesd204_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {DATA_PATH} {$data_path_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {SUBCLASSV} {$subclass_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {lane_rate} {$lane_rate_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {PCS_CONFIG} {$PCS_CONFIG_gui_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {pll_type} {$pll_type_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {bonded_mode} {$bonded_mode_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {REFCLK_FREQ} {$refclk_freq_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {bitrev_en} {$bitrev_en_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {L} {$L_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {M} {$M_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {GUI_EN_CFG_F} {$GUI_EN_CFG_F_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {GUI_CFG_F} {$GUI_CFG_F_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {N} {$N_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {N_PRIME} {$N_PRIME_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {S} {$S_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {K} {$K_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {SCR} {$SCR_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {CS} {$CS_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {CF} {$CF_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {HD} {$HD_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {ECC_EN} {$ECC_EN_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {F} {$F_s10}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_3.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_reset_bridge_3 {AUTO_CLK_CLOCK_RATE} {$frame_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_2.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_reset_bridge_2 {AUTO_CLK_CLOCK_RATE} {$link_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_1.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_reset_bridge_1 {AUTO_CLK_CLOCK_RATE} {$frame_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_reset_bridge_0 {AUTO_CLK_CLOCK_RATE} {$link_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_xcvr_atx_pll_s10_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_xcvr_atx_pll_s10_0 {set_output_clock_frequency} {$atx_pll_output_clock_freq}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_xcvr_atx_pll_s10_0 {set_auto_reference_clock_frequency} {$refclk_freq_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_xcvr_atx_pll_s10_0 {pma_width} {$pma_width}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_xcvr_reset_control_s10_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_xcvr_reset_control_s10_0 {CHANNELS} {$L_s10}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/jesd204b_subsystem_s10.qsys}"
    puts $out "set_project_property DEVICE_FAMILY {$device_family}"
    puts $out "set_project_property DEVICE {$device}"
    puts $out "set_project_property HIDE_FROM_IP_CATALOG {false}"
    puts $out "sync_sysinfo_parameters"
    # Based line design is L=2. Start to add serial clock connection for channel 2 and above.
    for {set i 2} {$i < $L_s10} {incr i} {
        puts $out "add_connection xcvr_atx_pll_s10_0.mcgb_serial_clk jesd204b.tx_serial_clk0_ch$i"
    }
    puts $out "save_system"

    close $out
    }

    if {[string equal $ED_FILESET_SIM "true"]} {
    set jesd204b_subsystem_sim_tcl_generated_file [ create_temp_file /sim/jesd204b_subsystem_s10.tcl ]
    set out [ open $jesd204b_subsystem_sim_tcl_generated_file w ] 
    
    puts $out "package require -exact qsys 16.1"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_clk_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_clk_0 {clockFrequency} {$refclk_freq_hz}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_clk_0 {inputClockFrequency} {$refclk_freq_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_clk_1.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_clk_0 {clockFrequency} {$link_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_clk_2.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_clk_0 {clockFrequency} {$frame_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_jesd204_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {DATA_PATH} {$data_path_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {SUBCLASSV} {$subclass_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {lane_rate} {$lane_rate_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {PCS_CONFIG} {$PCS_CONFIG_gui_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {pll_type} {$pll_type_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {bonded_mode} {$bonded_mode_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {REFCLK_FREQ} {$refclk_freq_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {bitrev_en} {$bitrev_en_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {L} {$L_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {M} {$M_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {GUI_EN_CFG_F} {$GUI_EN_CFG_F_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {GUI_CFG_F} {$GUI_CFG_F_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {N} {$N_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {N_PRIME} {$N_PRIME_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {S} {$S_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {K} {$K_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {SCR} {$SCR_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {CS} {$CS_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {CF} {$CF_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {HD} {$HD_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {ECC_EN} {$ECC_EN_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_jesd204_0 {F} {$F_s10}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_3.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_reset_bridge_3 {AUTO_CLK_CLOCK_RATE} {$frame_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_2.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_reset_bridge_2 {AUTO_CLK_CLOCK_RATE} {$link_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_1.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_reset_bridge_1 {AUTO_CLK_CLOCK_RATE} {$frame_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_reset_bridge_0 {AUTO_CLK_CLOCK_RATE} {$link_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_xcvr_atx_pll_s10_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_xcvr_atx_pll_s10_0 {set_output_clock_frequency} {$atx_pll_output_clock_freq}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_xcvr_atx_pll_s10_0 {set_auto_reference_clock_frequency} {$refclk_freq_s10}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_xcvr_atx_pll_s10_0 {pma_width} {$pma_width}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_subsystem/jesd204b_subsystem_xcvr_reset_control_s10_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_subsystem_xcvr_reset_control_s10_0 {CHANNELS} {$L_s10}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/jesd204b_subsystem_s10.qsys}"
    puts $out "set_project_property DEVICE_FAMILY {$device_family}"
    puts $out "set_project_property DEVICE {$device}"
    puts $out "set_project_property HIDE_FROM_IP_CATALOG {false}"
    puts $out "sync_sysinfo_parameters"
    # Based line design is L=2. Start to add serial clock connection for channel 2 and above.
    for {set i 2} {$i < $L_s10} {incr i} {
        puts $out "add_connection xcvr_atx_pll_s10_0.mcgb_serial_clk jesd204b.tx_serial_clk0_ch$i"
    }
    puts $out "save_system"
    
    close $out
    }
    
    # Generate TCL file to parameterize jesd204b_ed_qsys Qsys system
    if {[string equal $ED_FILESET_SYNTH "true"]} {
    set jesd204b_ed_qsys_tcl_generated_file [ create_temp_file /synth/jesd204b_ed_qsys.tcl ]
    set out [ open $jesd204b_ed_qsys_tcl_generated_file w ]

    puts $out "package require -exact qsys 16.1"
    puts $out "load_system {$temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_clk_0 {clockFrequency} {$refclk_freq_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_1.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_clk_0 {clockFrequency} {$link_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_2.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_clk_0 {clockFrequency} {$frame_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_4.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_clk_0 {clockFrequency} {$refclk_freq_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_iopll_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_iopll_0 {gui_reference_clock_frequency} {$refclk_freq_s10}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_iopll_0 {gui_output_clock_frequency0} {$link_clk_s10}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_iopll_0 {gui_output_clock_frequency1} {$frame_clk_s10}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/jesd204b_ed_qsys.qsys}"
    puts $out "set_project_property DEVICE_FAMILY {$device_family}"
    puts $out "set_project_property DEVICE {$device}"
    puts $out "set_project_property HIDE_FROM_IP_CATALOG {false}"
    puts $out "sync_sysinfo_parameters"
    puts $out "save_system"
    puts $out "load_system {$temp_dir/ip/se_outbuf_1bit.ip}"
    puts $out "set_project_property DEVICE_FAMILY {$device_family}"
    puts $out "set_project_property DEVICE {$device}"
    puts $out "save_system"

    close $out
    }
    
    if {[string equal $ED_FILESET_SIM "true"]} {
    set jesd204b_ed_qsys_sim_tcl_generated_file [ create_temp_file /sim/jesd204b_ed_qsys.tcl ]
    set out [ open $jesd204b_ed_qsys_sim_tcl_generated_file w ]
    
    puts $out "package require -exact qsys 16.1"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_clk_0 {clockFrequency} {$refclk_freq_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_1.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_clk_0 {clockFrequency} {$link_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_2.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_clk_0 {clockFrequency} {$frame_clk_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_4.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_clk_0 {clockFrequency} {$refclk_freq_hz}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_iopll_0.ip}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_iopll_0 {gui_reference_clock_frequency} {$refclk_freq_s10}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_iopll_0 {gui_output_clock_frequency0} {$link_clk_s10}"
    puts $out "set_instance_parameter_value jesd204b_ed_qsys_iopll_0 {gui_output_clock_frequency1} {$frame_clk_s10}"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/jesd204b_ed_qsys.qsys}"
    puts $out "set_project_property DEVICE_FAMILY {$device_family}"
    puts $out "set_project_property DEVICE {$device}"
    puts $out "set_project_property HIDE_FROM_IP_CATALOG {false}"
    puts $out "sync_sysinfo_parameters"
    puts $out "save_system"
    puts $out "load_system {$temp_dir2/models/ip/se_outbuf_1bit.ip}"
    puts $out "set_project_property DEVICE_FAMILY {$device_family}"
    puts $out "set_project_property DEVICE {$device}"
    puts $out "save_system"

    close $out
    }

#    send_message INFO "synth subsystem tcl : $jesd204b_subsystem_tcl_generated_file"
#    send_message INFO "sim subsystem tcl : $jesd204b_subsystem_sim_tcl_generated_file"
#    send_message INFO "synth ed tcl : $jesd204b_ed_qsys_tcl_generated_file"
#    send_message INFO "sim ed tcl : $jesd204b_ed_qsys_sim_tcl_generated_file"

    if {[string equal $ED_FILESET_SYNTH "true"]} {
    # Run qsys-script command
    #set script_cmd [list qsys-script --script=$jesd204b_subsystem_tcl_generated_file --quartus-project=$temp_dir/jesd204b_ed.qpf]
    set script_cmd [list qsys-script --script=$jesd204b_subsystem_tcl_generated_file]
    set status [catch {exec {*}$script_cmd} result]
#    send_message INFO "synth-qsys-script 1: $result"
    add_fileset_file ed_synth/jesd204b_subsystem_s10.qsys OTHER PATH $temp_dir/jesd204b_subsystem_s10.qsys

    #set script_cmd [list qsys-script --script=$jesd204b_ed_qsys_tcl_generated_file --quartus-project=$temp_dir/jesd204b_ed.qpf --search-path=$,$temp_dir]
    set script_cmd [list qsys-script --script=$jesd204b_ed_qsys_tcl_generated_file --search-path=$,$temp_dir]
    set status [catch {exec {*}$script_cmd} result]
#    send_message INFO "synth-qsys-script 2: $result"
    add_fileset_file ed_synth/jesd204b_ed_qsys.qsys OTHER PATH $temp_dir/jesd204b_ed_qsys.qsys

    # Run qsys-generate command
    set generate_cmd [list qsys-generate $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_jesd204_0.ip --upgrade-ip-cores --part=$device]
    set status [catch {exec {*}$generate_cmd} result]
    generate_qsys_file_s10 "$temp_dir/jesd204b_ed_qsys.qsys"
    generate_qsys_file_s10 "$temp_dir/ip/se_outbuf_1bit.ip"
    add_generated_files_to_fileset ed_synth $temp_dir
    }
    
    if {[string equal $ED_FILESET_SIM "true"]} {
    # Run qsys-script command
    #set script_cmd [list qsys-script --script=$jesd204b_subsystem_sim_tcl_generated_file --quartus-project=$temp_dir/jesd204b_ed.qpf]
    set script_cmd [list qsys-script --script=$jesd204b_subsystem_sim_tcl_generated_file]
    set status [catch {exec {*}$script_cmd} result]
#    send_message INFO "synth-qsys-script 3: $result"
    add_fileset_file ed_sim/testbench/models/jesd204b_subsystem_s10.qsys OTHER PATH $temp_dir2/models/jesd204b_subsystem_s10.qsys

    #set script_cmd [list qsys-script --script=$jesd204b_ed_qsys_tcl_generated_file --quartus-project=$temp_dir/jesd204b_ed.qpf --search-path=$,$temp_dir]
    set script_cmd [list qsys-script --script=$jesd204b_ed_qsys_sim_tcl_generated_file --search-path=$,$temp_dir2/models]
    set status [catch {exec {*}$script_cmd} result]
#    send_message INFO "synth-qsys-script 4: $result"
    add_fileset_file ed_sim/testbench/models/jesd204b_ed_qsys.qsys OTHER PATH $temp_dir2/models/jesd204b_ed_qsys.qsys
    
    # Run qsys-generate command
    generate_qsys_file_sim "$temp_dir2/models/jesd204b_ed_qsys.qsys"
    generate_qsys_file_sim "$temp_dir2/models/ip/se_outbuf_1bit.ip"
    add_generated_files_to_fileset ed_sim/testbench/models $temp_dir2/models 
    }

    # Add fileset files
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_clk_0.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_clk_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_clk_1.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_clk_1.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_clk_2.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_clk_2.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_clk_3.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_clk_3.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_jesd204_0.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_jesd204_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_mm_bridge_0.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_mm_bridge_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_0.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_1.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_1.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_2.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_2.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_3.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_bridge_3.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_reset_sequencer_0.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_reset_sequencer_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_xcvr_atx_pll_s10_0.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_xcvr_atx_pll_s10_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_subsystem/jesd204b_subsystem_xcvr_reset_control_s10_0.ip OTHER PATH $temp_dir/ip/jesd204b_subsystem/jesd204b_subsystem_xcvr_reset_control_s10_0.ip
#
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_0.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_1.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_1.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_2.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_2.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_3.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_3.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_4.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_clk_4.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_iopll_0.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_iopll_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_master_0.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_master_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_pio_0.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_pio_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_pio_1.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_pio_1.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_reset_bridge_0.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_reset_bridge_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_reset_controller_0.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_reset_controller_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_spi_0.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_spi_0.ip
#    add_fileset_file ed_synth/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_spi_1.ip OTHER PATH $temp_dir/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_spi_1.ip
#
#    add_fileset_file ed_synth/ip/se_outbuf_1bit.ip OTHER PATH $temp_dir/ip/se_outbuf_1bit.ip

    # Terp jesd204b_ed.sv file
    if {[string equal $ED_FILESET_SYNTH "true"]} {
    set SIM 0
    
    set template_file [ file join $ed_sim_scripts_dir jesd204b_ed_s10.sv.terp ]
    set template [ read [ open $template_file r ] ]
    set params(L) $L_s10
    set params(M) $M_s10
    set params(F) $F_s10
    set params(S) $S_s10
    set params(CS) $CS_s10
    set params(N) $N_s10
    set params(N_PRIME) $N_PRIME_s10
    set params(SIM) $SIM
    set generated_file   [ altera_terp $template params ]
    add_fileset_file ed_synth/jesd204b_ed.sv VERILOG TEXT $generated_file
    }
    
    if {[string equal $ED_FILESET_SIM "true"]} {
    set SIM 1
    
    set template_file [ file join $ed_sim_scripts_dir jesd204b_ed_s10.sv.terp ]
    set template [ read [ open $template_file r ] ]
    set params(L) $L_s10
    set params(M) $M_s10
    set params(F) $F_s10
    set params(S) $S_s10
    set params(CS) $CS_s10
    set params(N) $N_s10
    set params(N_PRIME) $N_PRIME_s10
    set params(SIM) $SIM
    set generated_file   [ altera_terp $template params ]
    add_fileset_file ed_sim/testbench/models/jesd204b_ed.sv VERILOG TEXT $generated_file
    #add_fileset_file $temp_dir2/models/jesd204b_ed.sv VERILOG TEXT $generated_file
    
    set save_file [open "${temp_dir2}/models/jesd204b_ed.sv" w]
    puts $save_file $generated_file
    close $save_file
    }
    
    # Terp tb_top.sv file
    if {[string equal $ED_FILESET_SIM "true"]} {
    set template_file [ file join $ed_sim_scripts_dir tb_top_s10.sv.terp ]
    set template [ read [ open $template_file r ] ]
    set params(VAR_CLK) $VAR_CLK
    set params(CLK_PERIOD) $CLK_PERIOD
    set params(LINK_DERIVED) $LINK_DERIVED
    set params(L) $L_s10
    set params(M) $M_s10
    set params(F) $F_s10
    set params(S) $S_s10
    set params(N) $N_s10
    set params(N_PRIME) $N_PRIME_s10
    set params(F1_DIV) $F1_DIV
    set params(F2_DIV) $F2_DIV
    set generated_file   [ altera_terp $template params ]
    add_fileset_file ed_sim/testbench/models/tb_top.sv VERILOG TEXT $generated_file
    #add_fileset_file $temp_dir2/models/tb_top.sv VERILOG TEXT $generated_file
    
    set save_file [open "${temp_dir2}/models/tb_top.sv" w]
    puts $save_file $generated_file
    close $save_file
    }
    
    if {[string equal $ED_FILESET_SYNTH "true"]} {
    add_fileset_file ed_synth/spi_mosi_oe.v OTHER PATH $ed_sim_scripts_dir/spi_mosi_oe.v
    add_fileset_file ed_synth/switch_debouncer.v OTHER PATH $ed_sim_scripts_dir/switch_debouncer.v

    add_fileset_file ed_synth/pattern/alternate_checker.sv OTHER PATH $ed_sim_dir/pattern/alternate_checker.sv
    add_fileset_file ed_synth/pattern/alternate_generator.sv OTHER PATH $ed_sim_dir/pattern/alternate_generator.sv
    add_fileset_file ed_synth/pattern/prbs_checker.sv OTHER PATH $ed_sim_dir/pattern/prbs_checker.sv
    add_fileset_file ed_synth/pattern/prbs_generator.sv OTHER PATH $ed_sim_dir/pattern/prbs_generator.sv
    add_fileset_file ed_synth/pattern/ramp_checker.sv OTHER PATH $ed_sim_dir/pattern/ramp_checker.sv
    add_fileset_file ed_synth/pattern/ramp_generator.sv OTHER PATH $ed_sim_dir/pattern/ramp_generator.sv
    add_fileset_file ed_synth/pattern/pattern_checker_top.sv OTHER PATH $ed_sim_dir/pattern/pattern_checker_top.sv
    add_fileset_file ed_synth/pattern/pattern_generator_top.sv OTHER PATH $ed_sim_dir/pattern/pattern_generator_top.sv

    add_fileset_file ed_synth/transport_layer/altera_jesd204_assembler_nprime12.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_assembler_nprime12.sv
    add_fileset_file ed_synth/transport_layer/altera_jesd204_assembler.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_assembler.sv
    add_fileset_file ed_synth/transport_layer/altera_jesd204_deassembler_nprime12.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_deassembler_nprime12.sv
    add_fileset_file ed_synth/transport_layer/altera_jesd204_deassembler.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_deassembler.sv
    add_fileset_file ed_synth/transport_layer/altera_jesd204_transport_rx_top.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_transport_rx_top.sv
    add_fileset_file ed_synth/transport_layer/altera_jesd204_transport_tx_top.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_transport_tx_top.sv

    add_fileset_file ed_synth/jesd204b_ed.qpf OTHER PATH $ed_sim_scripts_dir/jesd204b_ed.qpf
    
    set template_file           [ file join $ed_sim_scripts_dir jesd204b_ed.qsf.terp ]
    set template                [ read [ open $template_file r ] ]
    set params(device_family)   $device_family
    set params(device)          $device

    set generated_file [altera_terp $template params]
    add_fileset_file ed_synth/jesd204b_ed.qsf OTHER TEXT $generated_file

    set template_file            [ file join $ed_sim_scripts_dir jesd204b_ed_s10.sdc.terp ]
    set template                 [ read [ open $template_file r ] ]
    set params(refclk_period_ns) $refclk_period_ns

    set generated_file [altera_terp $template params]
    add_fileset_file ed_synth/jesd204b_ed.sdc OTHER TEXT $generated_file
    }
    
    if {[string equal $ED_FILESET_SIM "true"]} {
    add_fileset_file ed_sim/testbench/spi_mosi_oe.v OTHER PATH $ed_sim_scripts_dir/spi_mosi_oe.v
    add_fileset_file ed_sim/testbench/switch_debouncer.v OTHER PATH $ed_sim_scripts_dir/switch_debouncer.v

    add_fileset_file ed_sim/testbench/pattern/alternate_checker.sv OTHER PATH $ed_sim_dir/pattern/alternate_checker.sv
    add_fileset_file ed_sim/testbench/pattern/alternate_generator.sv OTHER PATH $ed_sim_dir/pattern/alternate_generator.sv
    add_fileset_file ed_sim/testbench/pattern/prbs_checker.sv OTHER PATH $ed_sim_dir/pattern/prbs_checker.sv
    add_fileset_file ed_sim/testbench/pattern/prbs_generator.sv OTHER PATH $ed_sim_dir/pattern/prbs_generator.sv
    add_fileset_file ed_sim/testbench/pattern/ramp_checker.sv OTHER PATH $ed_sim_dir/pattern/ramp_checker.sv
    add_fileset_file ed_sim/testbench/pattern/ramp_generator.sv OTHER PATH $ed_sim_dir/pattern/ramp_generator.sv
    add_fileset_file ed_sim/testbench/pattern/pattern_checker_top.sv OTHER PATH $ed_sim_dir/pattern/pattern_checker_top.sv
    add_fileset_file ed_sim/testbench/pattern/pattern_generator_top.sv OTHER PATH $ed_sim_dir/pattern/pattern_generator_top.sv

    add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_assembler_nprime12.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_assembler_nprime12.sv
    add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_assembler.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_assembler.sv
    add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_deassembler_nprime12.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_deassembler_nprime12.sv
    add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_deassembler.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_deassembler.sv
    add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_transport_rx_top.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_transport_rx_top.sv
    add_fileset_file ed_sim/testbench/transport_layer/altera_jesd204_transport_tx_top.sv OTHER PATH $ed_sim_dir/transport_layer_s10/altera_jesd204_transport_tx_top.sv
    }
    
    #generate spd file and ip-makesim-scripts
    if {[string equal $ED_FILESET_SIM "true"]} {
    #Create spd files for modules 
     file delete -force $temp_dir2/models/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_master_0.ip
     file delete -force $temp_dir2/models/ip/jesd204b_ed_qsys/jesd204b_ed_qsys_spi_1.ip
     
     file copy -force $ed_sim_scripts_dir/manual.spd.txt $temp_dir2/manual.spd
     
     file copy -force $ed_sim_scripts_dir/spi_mosi_oe.v $temp_dir2
     file copy -force $ed_sim_scripts_dir/switch_debouncer.v $temp_dir2
     
     file mkdir ${temp_dir2}/pattern
     file copy -force $ed_sim_dir/pattern/alternate_checker.sv $temp_dir2/pattern
     file copy -force $ed_sim_dir/pattern/alternate_generator.sv $temp_dir2/pattern
     file copy -force $ed_sim_dir/pattern/pattern_checker_top.sv $temp_dir2/pattern
     file copy -force $ed_sim_dir/pattern/pattern_generator_top.sv $temp_dir2/pattern
     file copy -force $ed_sim_dir/pattern/prbs_checker.sv $temp_dir2/pattern
     file copy -force $ed_sim_dir/pattern/prbs_generator.sv $temp_dir2/pattern
     file copy -force $ed_sim_dir/pattern/ramp_checker.sv $temp_dir2/pattern
     file copy -force $ed_sim_dir/pattern/ramp_generator.sv $temp_dir2/pattern
    
     file mkdir ${temp_dir2}/transport_layer
     file copy -force $ed_sim_dir/transport_layer_s10/altera_jesd204_assembler_nprime12.sv $temp_dir2/transport_layer
     file copy -force $ed_sim_dir/transport_layer_s10/altera_jesd204_deassembler_nprime12.sv $temp_dir2/transport_layer
     file copy -force $ed_sim_dir/transport_layer_s10/altera_jesd204_assembler.sv $temp_dir2/transport_layer
     file copy -force $ed_sim_dir/transport_layer_s10/altera_jesd204_deassembler.sv $temp_dir2/transport_layer
     file copy -force $ed_sim_dir/transport_layer_s10/altera_jesd204_transport_rx_top.sv $temp_dir2/transport_layer
     file copy -force $ed_sim_dir/transport_layer_s10/altera_jesd204_transport_tx_top.sv $temp_dir2/transport_layer
     
     #Create spd files for each ip
     set auto_spd_list " --spd=$temp_dir2/manual.spd"
     append auto_spd_list " --spd=$temp_dir2/models/ip/se_outbuf_1bit/se_outbuf_1bit.spd"
     append auto_spd_list " --spd=$temp_dir2/models/jesd204b_subsystem_s10/jesd204b_subsystem_s10.spd"
     append auto_spd_list " --spd=$temp_dir2/models/jesd204b_ed_qsys/jesd204b_ed_qsys.spd"
     
     
     
     set ip_files {
	 ip/jesd204b_ed_qsys
	 ip/jesd204b_subsystem
     }
     
     foreach {file} $ip_files { 
	     foreach {ip_file} [glob -directory "$temp_dir2/models/${file}/" "*.ip"] {
		     set path_tmp [string range $ip_file 0 end-3]
		     set ip_name [string range [file tail $ip_file] 0 end-3]
		     append auto_spd_list " --spd=${path_tmp}/${ip_name}.spd"
	     }
     }
     #add_fileset_file ed_sim/testbench/auto_spd_list.spd OTHER PATH $temp_dir2/models/auto_spd_list.spd
	     
    
     #set auto_spd_list "$temp_dir/jesd204b_ed_qsys/jesd204b_ed_qsys.spd"
     
     #append auto_spd_list " --spd=$temp_dir/jesd204b_subsystem_s10/jesd204b_subsystem_s10.spd"
     #append auto_spd_list " --spd=$temp_dir/ip/*/*/*.spd"
     #append auto_spd_list " --spd=$temp_dir/ip/*/*.spd"
     
     # Create setup scripts(i.e msim_setup.tcl) by joining generated spd files
     set exec_command [list $qdir/sopc_builder/bin/ip-make-simscript {*}$auto_spd_list --output-directory=$temp_dir2 --use_relative_paths]
     set status [catch {exec {*}$exec_command} result]
     
     if {$status == 0} {
            send_message ERROR "Error when executing: $exec_command"
            send_message ERROR "Error message: $result"
        } else {
            send_message INFO "Simulation setup scripts are generated"
     }
     #add_generated_files_to_fileset ed_sim/temp $temp_dir2
     add_generated_files_to_fileset ed_sim/testbench/setup_scripts/aldec $temp_dir2/aldec
     add_generated_files_to_fileset ed_sim/testbench/setup_scripts/cadence $temp_dir2/cadence
     add_generated_files_to_fileset ed_sim/testbench/setup_scripts/mentor $temp_dir2/mentor
     add_generated_files_to_fileset ed_sim/testbench/setup_scripts/synopsys $temp_dir2/synopsys
     }    

}
