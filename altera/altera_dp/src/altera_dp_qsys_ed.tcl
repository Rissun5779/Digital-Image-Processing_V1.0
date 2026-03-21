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


proc generate_qsys_ed { } {
    global env
    set qdir $env(QUARTUS_ROOTDIR)
    set quartus_sh_exe "$::env(QUARTUS_BINDIR)/quartus_sh"
    set tmpdir [create_temp_file {}]
    # Family specific string now (Arria_10) has to be enhanced in the future
    set ed_src_dir "${qdir}/../ip/altera/altera_dp/de_gen/arria_10"
    set ed_name     a10_dp_demo
	set windows_nios2_cmd_shell "$qdir/../nios2eds/Nios II Command Shell.bat"
	set linux_nios2_cmd_shell "$qdir/../nios2eds/nios2_command_shell.sh"
	set OS_WIN 0

	if {[file exists $windows_nios2_cmd_shell]} {
			set OS_WIN 1
	}

    # Error checking to make sure that 1 of the Simulation or Synthesis check boxes are enabled
    if { ([get_parameter_value ENABLE_ED_FILESET_SIM] == 0 && [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 0) || [get_parameter_value SELECT_SUPPORTED_VARIANT] == 0} {
        send_message error "Neither \"Simulation\" nor \"Synthesis\" check boxes from \"Files Types Generated\" are selected to allow generation of Design Example Files."
    } else {
        send_message INFO "Creating design example"
    }

    # //////////////////////////////////////////////////////////////////////////////
    #   Copy all files and folders from ACDS to temp directory
    # //////////////////////////////////////////////////////////////////////////////
    if { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 1 } {
        cd  $tmpdir

        file copy $ed_src_dir/rtl "."
        if { ([get_parameter_value RX_AUX_GPU] == 1) } {
            file delete ./rtl/core/edid_memory.hex
        }
        #file copy $ed_src_dir/../common/clkrec "./rtl/."
        file delete ./rtl/clkrec/clkrec_pll_av.v
        file delete ./rtl/clkrec/clkrec_pll_cv.v
        file delete ./rtl/clkrec/clkrec_pll_sv.v
        file delete ./rtl/clkrec/clkrec_pll135_av.v
        file delete ./rtl/clkrec/clkrec_pll135_cv.v
        file delete ./rtl/clkrec/clkrec_pll135_sv.v
        # //////////////////////////////////////////////////////////////////////////////
        #   Create .qsys file and generate
        # //////////////////////////////////////////////////////////////////////////////
        #   Create DisplayPort Core Sys
        # //////////////////////////////////////////////////////////////////////////////
        cd $tmpdir/rtl/core
        send_message INFO "Creating Core Qsys subsystem"
        gen_qsys_terp   "dp_rx"
        gen_qsys_terp   "dp_tx"
        gen_qsys_terp   "dp_core"

        # //////////////////////////////////////////////////////////////////////////////
        #   Create DisplayPort Rx Sys
        # //////////////////////////////////////////////////////////////////////////////
        cd $tmpdir/rtl/rx_phy
        send_message INFO "Creating Rx Qsys subsystem"
        gen_qsys_terp   "gxb_rx"
        gen_qsys_terp   "gxb_rx_reset"
    
        # //////////////////////////////////////////////////////////////////////////////
        #   Create DisplayPort Tx Sys    
        # //////////////////////////////////////////////////////////////////////////////
        cd $tmpdir/rtl/tx_phy
        send_message INFO "Creating Tx Qsys subsystem"
        gen_qsys_terp   "gxb_tx"
        gen_qsys_terp   "gxb_tx_reset"
        gen_qsys_terp   "gxb_tx_fpll"
    
        # //////////////////////////////////////////////////////////////////////////////
        #   Create DisplayPort Clkrec Sys    
        # //////////////////////////////////////////////////////////////////////////////
        cd $tmpdir/rtl/clkrec
        send_message INFO "Creating Clkrec Qsys subsystem"
        gen_qsys        "clkrec_pll_a10"
        gen_qsys        "clkrec_pll135_a10"
        gen_qsys        "clkrec_reset_a10"
    
        # //////////////////////////////////////////////////////////////////////////////
        #   Create Misc Sys
        # //////////////////////////////////////////////////////////////////////////////
        cd $tmpdir/rtl
        send_message INFO "Creating Misc Qsys subsystem"
        #gen_qsys        "i2c_gpio_buf"
        gen_qsys        "video_pll_a10"

        # //////////////////////////////////////////////////////////////////////////////
        #   Create Quartus and Script file
        # //////////////////////////////////////////////////////////////////////////////
        cd  $tmpdir
        file copy $ed_src_dir/quartus "."
        file copy $ed_src_dir/script "."

        # //////////////////////////////////////////////////////////////////////////////
        #   Create assignment.tcl file
        # //////////////////////////////////////////////////////////////////////////////
        cd $tmpdir/quartus
        set assignment_terp [get_terp_content "assignments.tcl.terp" [list [get_parameter_value ED_DEVICE] $ed_name [get_parameter_value SELECT_TARGETED_BOARD]] ]
        set assignment_filename "assignment.tcl"
        set assignment_tcl [open $assignment_filename w]
        puts $assignment_tcl "$assignment_terp"
        close $assignment_tcl

        # //////////////////////////////////////////////////////////////////////////////
        #   Create Quartus project
        # //////////////////////////////////////////////////////////////////////////////
        set createproj_filename create_proj.tcl
        set create_proj_tcl [open $createproj_filename w]
        puts $create_proj_tcl "load_package flow"
        puts $create_proj_tcl "load_package project"
        puts $create_proj_tcl "project_new $ed_name -overwrite"
        puts $create_proj_tcl "source $assignment_filename"
        puts $create_proj_tcl "export_assignments"
        puts $create_proj_tcl "project_close"
        close $create_proj_tcl
        catch {[exec "quartus_sh" -t $createproj_filename]} temp
        file delete -force -- $assignment_filename $createproj_filename
    
        # //////////////////////////////////////////////////////////////////////////////
        #   Create Software file
        # //////////////////////////////////////////////////////////////////////////////
        send_message INFO "Creating Software"
        cd  $tmpdir
        file copy $ed_src_dir/software "."
        cd $tmpdir/script
		catch { [exec ./build_sw.sh] } temp
		#send_message INFO $temp		
		# 17.0 and earlier
		#if { $OS_WIN == 1} {
		#	set cmd [list "${windows_nios2_cmd_shell}" "sh build_sw.sh" ]
		#	catch {eval [concat [list exec "--"] $cmd]} temp
		#} else {
		#	set cmd [list "${linux_nios2_cmd_shell}" "sh build_sw.sh" ]
		#	catch {eval [concat [list exec "--"] $cmd]} temp
		#}
    }

    # //////////////////////////////////////////////////////////////////////////////
    #   Create Simulation file
    # //////////////////////////////////////////////////////////////////////////////
    if { [get_parameter_value ENABLE_ED_FILESET_SIM] == 1 } {
        send_message INFO "Creating Simulation"
        cd  $tmpdir
        file copy   "$ed_src_dir/simulation" "."
        cd  $tmpdir/simulation/core      
        gen_qsys_terp   "dp_rx"
        gen_qsys_terp   "dp_tx"
        gen_qsys_terp   "dp_core"

        cd $tmpdir/simulation/rx_phy
        gen_qsys_terp   "gxb_rx"
        gen_qsys_terp   "gxb_rx_reset"
    
        cd $tmpdir/simulation/tx_phy
        gen_qsys_terp   "gxb_tx"
        gen_qsys_terp   "gxb_tx_reset"
        gen_qsys_terp   "gxb_tx_fpll"

        cd $tmpdir/simulation
        gen_qsys        "video_pll_a10"
        
        gen_sim_setup

        file rename "aldec.do"          "aldec/aldec.do"
        file rename "ncsim.sh"          "cadence/ncsim.sh"
        file rename "mentor.do"         "mentor/mentor.do"
        if { [get_parameter_value SELECT_ED_FILESET] == "VERILOG" } {
        # For some reasons, makefile can't be updated when file is named as filelist.f.terp. 
        # Named it as vcs_filelist.sh.terp in ACDS folder, but outputing it as filelist.f
        file rename "vcs_filelist.sh"   "synopsys/vcs/filelist.f"
        file rename "vcs_sim.sh"        "synopsys/vcs/vcs_sim.sh"
        } else {
            file delete -force -- "vcs_filelist.sh"
            file delete -force -- "vcs_sim.sh"
        }
        file rename "vcsmx_sim.sh"      "synopsys/vcsmx/vcsmx_sim.sh"
    }
    
    # //////////////////////////////////////////////////////////////////////////////
    #   Propagate files from temp dir to user specified directory
    # //////////////////////////////////////////////////////////////////////////////
    cd $tmpdir
    send_message INFO "Adding files to your directory"
    glob_recursive [pwd] {}
    
    if { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 1 } {
        # Top level .v 
        set top_v_terp [get_terp_content "$ed_src_dir/rtl/top.v.terp" \
                        [list $ed_name \
                              [get_parameter_value RX_MAX_LANE_COUNT] \
                              [get_parameter_value RX_SYMBOLS_PER_CLOCK] \
                              [get_parameter_value RX_PIXELS_PER_CLOCK] \
                              [get_parameter_value RX_VIDEO_BPS] \
                              [get_parameter_value RX_SUPPORT_SS] \
                              [get_parameter_value RX_SUPPORT_AUDIO] \
                              [get_parameter_value RX_AUDIO_CHANS] \
                              [get_parameter_value RX_EXPORT_MSA] \
                              [get_parameter_value RX_AUX_GPU] \
                              [get_parameter_value TX_MAX_LANE_COUNT] \
                              [get_parameter_value TX_SYMBOLS_PER_CLOCK] \
                              [get_parameter_value TX_PIXELS_PER_CLOCK] \
                              [get_parameter_value TX_VIDEO_BPS] \
                              [get_parameter_value TX_SUPPORT_SS] \
                              [get_parameter_value TX_SUPPORT_AUDIO] \
                              [get_parameter_value TX_AUDIO_CHANS] \
                              [get_parameter_value TX_SUPPORT_ANALOG_RECONFIG]]]
        add_fileset_file "rtl/$ed_name.v"   VERILOG     TEXT    $top_v_terp

        set rx_phy_top_terp [get_terp_content "$ed_src_dir/rtl/rx_phy/rx_phy_top.v.terp" [list [get_parameter_value RX_AUX_GPU]]]
        add_fileset_file "rtl/rx_phy/rx_phy_top.v"  VERILOG     TEXT    $rx_phy_top_terp
        set tx_phy_top_terp [get_terp_content "$ed_src_dir/rtl/tx_phy/tx_phy_top.v.terp" [list [get_parameter_value TX_SUPPORT_ANALOG_RECONFIG]]]
        add_fileset_file "rtl/tx_phy/tx_phy_top.v"  VERILOG     TEXT    $tx_phy_top_terp
    }
    
        if { [get_parameter_value ENABLE_ED_FILESET_SIM] == 1 } {
        # Top level .v 
        set harness_v_terp [get_terp_content "$ed_src_dir/simulation/testbench/a10_dp_harness.sv.terp" \
                            [list $ed_name \
                            [get_parameter_value RX_MAX_LANE_COUNT] \
                            [get_parameter_value RX_SYMBOLS_PER_CLOCK] \
                            [get_parameter_value RX_PIXELS_PER_CLOCK] \
                            [get_parameter_value RX_VIDEO_BPS] \
                            [get_parameter_value TX_MAX_LANE_COUNT] \
                            [get_parameter_value TX_SYMBOLS_PER_CLOCK] \
                            [get_parameter_value TX_PIXELS_PER_CLOCK] \
                            [get_parameter_value TX_VIDEO_BPS]]]
        add_fileset_file "simulation/testbench/a10_dp_harness.sv" VERILOG TEXT $harness_v_terp

       set top_v_terp [get_terp_content "$ed_src_dir/simulation/top.v.terp" \
                        [list $ed_name \
                              [get_parameter_value RX_MAX_LANE_COUNT] \
                              [get_parameter_value RX_SYMBOLS_PER_CLOCK] \
                              [get_parameter_value RX_PIXELS_PER_CLOCK] \
                              [get_parameter_value RX_VIDEO_BPS] \
                              [get_parameter_value RX_SUPPORT_SS] \
                              [get_parameter_value RX_SUPPORT_AUDIO] \
                              [get_parameter_value RX_AUDIO_CHANS] \
                              [get_parameter_value RX_EXPORT_MSA] \
                              [get_parameter_value RX_AUX_GPU] \
                              [get_parameter_value TX_MAX_LANE_COUNT] \
                              [get_parameter_value TX_SYMBOLS_PER_CLOCK] \
                              [get_parameter_value TX_PIXELS_PER_CLOCK] \
                              [get_parameter_value TX_VIDEO_BPS] \
                              [get_parameter_value TX_SUPPORT_SS] \
                              [get_parameter_value TX_SUPPORT_AUDIO] \
                              [get_parameter_value TX_AUDIO_CHANS] \
                              [get_parameter_value TX_SUPPORT_ANALOG_RECONFIG]]]
        add_fileset_file "simulation/$ed_name.v"   VERILOG     TEXT    $top_v_terp

        set rx_phy_top_terp [get_terp_content "$ed_src_dir/simulation/rx_phy/rx_phy_top.v.terp" [list [get_parameter_value RX_AUX_GPU]]]
        add_fileset_file "simulation/rx_phy/rx_phy_top.v"  VERILOG     TEXT    $rx_phy_top_terp
        set tx_phy_top_terp [get_terp_content "$ed_src_dir/simulation/tx_phy/tx_phy_top.v.terp" [list [get_parameter_value TX_SUPPORT_ANALOG_RECONFIG]]]
        add_fileset_file "simulation/tx_phy/tx_phy_top.v"  VERILOG     TEXT    $tx_phy_top_terp
    }
}

# ------------------------------------------------------------------------------------
#   Function to create .qsys file and generate it (more enhancements required)
# ------------------------------------------------------------------------------------
proc gen_qsys {inst_name} {
    set qsys_script_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
    set qsys_generate_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate"
    append inst_filename    $inst_name ".tcl"
    append inst_qsys        $inst_name ".qsys"

    catch {eval [exec $qsys_script_exe "--script=$inst_filename"] } temp
    file delete -force -- $inst_filename

    if { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] && [get_parameter_value ENABLE_ED_FILESET_SIM] } {
        catch {eval [exec $qsys_generate_exe $inst_qsys --synthesis=[get_parameter_value SELECT_ED_FILESET] --simulation=[get_parameter_value SELECT_ED_FILESET] \
                        --part=[get_parameter_value ED_DEVICE] --output-directory=$inst_name] } temp
    } elseif { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] } {
        catch {eval [exec $qsys_generate_exe $inst_qsys --synthesis=[get_parameter_value SELECT_ED_FILESET] --part=[get_parameter_value ED_DEVICE] --output-directory=$inst_name] } temp
    } elseif { [get_parameter_value ENABLE_ED_FILESET_SIM] } {
        catch {eval [exec $qsys_generate_exe $inst_qsys --simulation=[get_parameter_value SELECT_ED_FILESET] --part=[get_parameter_value ED_DEVICE] --output-directory=$inst_name] } temp
    }
}

proc gen_qsys_terp {inst_name} {
    set qsys_script_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
    set qsys_generate_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate"
    append inst_filename    $inst_name ".tcl"
    append inst_terp        $inst_name "_terp"
    append inst_terp_src    $inst_name ".tcl.terp"
    append inst_qsys        $inst_name ".qsys"

    set inst_terp [get_terp_content $inst_terp_src \
                    [list [get_parameter_value ED_DEVICE] \
                          [get_parameter_value RX_MAX_LINK_RATE] \
                          [get_parameter_value RX_MAX_LANE_COUNT] \
                          [get_parameter_value RX_SYMBOLS_PER_CLOCK] \
                          [get_parameter_value RX_PIXELS_PER_CLOCK] \
                          [get_parameter_value RX_VIDEO_BPS] \
                          [get_parameter_value RX_SUPPORT_SS] \
                          [get_parameter_value RX_SUPPORT_AUDIO] \
                          [get_parameter_value RX_AUDIO_CHANS] \
                          [get_parameter_value RX_AUX_GPU] \
                          [get_parameter_value RX_SUPPORT_AUTOMATED_TEST] \
                          [get_parameter_value RX_SCRAMBLER_SEED] \
                          [get_parameter_value RX_AUX_DEBUG] \
                          [get_parameter_value RX_EXPORT_MSA] \
                          [get_parameter_value TX_MAX_LINK_RATE] \
                          [get_parameter_value TX_MAX_LANE_COUNT] \
                          [get_parameter_value TX_SYMBOLS_PER_CLOCK] \
                          [get_parameter_value TX_PIXELS_PER_CLOCK] \
                          [get_parameter_value TX_VIDEO_BPS] \
                          [get_parameter_value TX_SUPPORT_SS] \
                          [get_parameter_value TX_SUPPORT_AUDIO] \
                          [get_parameter_value TX_AUDIO_CHANS] \
                          [get_parameter_value TX_SUPPORT_ANALOG_RECONFIG] \
                          [get_parameter_value TX_SUPPORT_AUTOMATED_TEST] \
                          [get_parameter_value TX_SCRAMBLER_SEED] \
                          [get_parameter_value TX_AUX_DEBUG]]]
    set inst_tcl [open $inst_filename w]
    puts $inst_tcl " $inst_terp"
    close $inst_tcl

    catch {eval [exec $qsys_script_exe "--script=$inst_filename"] } temp
    file delete -force -- $inst_filename

    if { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] && [get_parameter_value ENABLE_ED_FILESET_SIM] } {
        catch {eval [exec $qsys_generate_exe $inst_qsys --synthesis=[get_parameter_value SELECT_ED_FILESET] --simulation=[get_parameter_value SELECT_ED_FILESET] \
                        --part=[get_parameter_value ED_DEVICE] --output-directory=$inst_name] } temp
    } elseif { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] } {
        catch {eval [exec $qsys_generate_exe $inst_qsys --synthesis=[get_parameter_value SELECT_ED_FILESET] --part=[get_parameter_value ED_DEVICE] --output-directory=$inst_name] } temp
    } elseif { [get_parameter_value ENABLE_ED_FILESET_SIM] } {
        catch {eval [exec $qsys_generate_exe $inst_qsys --simulation=[get_parameter_value SELECT_ED_FILESET] --part=[get_parameter_value ED_DEVICE] --output-directory=$inst_name] } temp
    }
}


# ------------------------------------------------------------------------------------
#   Function to glob through all the subdirectories and add files to dest dir
# ------------------------------------------------------------------------------------
proc glob_recursive {src_dir dest_dir} {
    set contents [glob -directory $src_dir *]

    foreach item $contents {
        set filename [file tail $item]
        # go into subdirectories
        if { [file isdirectory $item] } {
            glob_recursive $item [file join $dest_dir $filename]
        } elseif { [file isfile $item] } {
            addfile_to_user $item $dest_dir
        }
    }
}

# ------------------------------------------------------------------------------------
#   Function to propagate files to user specified dir
# ------------------------------------------------------------------------------------
proc addfile_to_user { full_path dest_dir } {
    set filename [file tail $full_path]

    if {[regexp {.*\.vh[do]} $full_path] } {
        set file_type "VHDL"
    } elseif {[regexp {.*\.v} $full_path] } {
        set file_type "VERILOG"
    } elseif {[regexp {.*\.hex} $full_path]} {
        set file_type "HEX"
    } elseif {[regexp {.*\.sdc} $full_path]} {
        set file_type "SDC"
    } elseif {[regexp {.*\.sv} $full_path]} {
        set file_type "SYSTEM_VERILOG"
    } else {
        set file_type "OTHER"
    }
    if { ![regexp {.*\.terp$} $filename] } {
        add_fileset_file [file join $dest_dir $filename] $file_type PATH $full_path
    }
}

# ------------------------------------------------------------------------------------
#   Function to generate the final content based on specified terp file
# ------------------------------------------------------------------------------------
proc get_terp_content { filepath param_value } {
      # Open and read terp file
      set terp_path     $filepath
      set terp_fd       [open $terp_path]
      set terp_contents [read $terp_fd]
      close $terp_fd

      for {set i 0} {$i < [llength $param_value]} {incr i} {
        set terp_params(param$i)  [lindex $param_value $i]
      }
      # Expand terp w/ parameters into design file
      set top_file_contents [altera_terp $terp_contents terp_params]
      return $top_file_contents
      # set filename [file tail $filepath]
      # set output_name [regsub {.terp} $filename ""]
      # add_fileset_file "$dest_dir/$output_name"  SYSTEM_VERILOG  TEXT    $top_file_contents
}

proc gen_sim_setup {} {
    set ip_make_simscript_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/ip-make-simscript"

    set top_spd_list    [join [glob -directory "./" */*.spd] ,]
    set core_spd_list   [join [glob -directory "./core/" */*.spd] ,]
    set tx_spd_list [join [glob -directory "./tx_phy/" */*.spd] ,]
    set rx_spd_list [join [glob -directory "./rx_phy/" */*.spd] ,]
    set spd_list [join [list $top_spd_list $core_spd_list $tx_spd_list $rx_spd_list] ,]
    
    catch {eval [exec $ip_make_simscript_exe "--spd=$spd_list"] } temp
}
