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
    # Executable must be reference from QUARTUS_ROOTDIR, or else might have risk of failing in customer installation
    set quartus_sh_exe "$::env(QUARTUS_BINDIR)/quartus_sh"
    set tmpdir [create_temp_file {}]
    
    # Get device family name from parameter and derive source directory and ed proj name
    set device_fam [concat [string tolower [lindex [get_parameter_value FAMILY] 0]]_[lindex [get_parameter_value FAMILY] 1]]
    set fam_short [string index $device_fam 0]
    set ed_src_dir "${qdir}/../ip/altera/altera_hdmi/hw_demo/${device_fam}"
    set ed_name     ${fam_short}10_hdmi2_demo

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

    if { [get_parameter_value FAMILY] == "Cyclone 10 GX" } {
            file copy $ed_src_dir/../arria_10/rtl/i2c_master/oc_i2c_master_hw.tcl "rtl/i2c_master/"
    }

        # //////////////////////////////////////////////////////////////////////////////
        #   Create .qsys file and generate
        # //////////////////////////////////////////////////////////////////////////////
        #   Create HDMI Rx Sys
        # //////////////////////////////////////////////////////////////////////////////
        send_message INFO "Generating hdmi_rx IP"
        cd $tmpdir/rtl/hdmi_rx
        gen_qsys_terp   "hdmi_rx"   
        # //////////////////////////////////////////////////////////////////////////////
        #   Create HDMI Tx Sys    
        # //////////////////////////////////////////////////////////////////////////////
        send_message INFO "Generating hdmi_tx IP"
        cd $tmpdir/rtl/hdmi_tx
        gen_qsys_terp   "hdmi_tx"
        # //////////////////////////////////////////////////////////////////////////////
        #   Create HDMI Clkrec Sys    
        # //////////////////////////////////////////////////////////////////////////////
   
        send_message INFO "Generating gxb IPs"
        cd $tmpdir/rtl/gxb
        gen_qsys_terp "gxb_rx"
        gen_qsys_terp "gxb_rx_reset"
        gen_qsys_terp "gxb_tx"
        gen_qsys_terp "gxb_tx_fpll"
        gen_qsys_terp "gxb_tx_reset"

        send_message INFO "Generating pll IPs"
        cd $tmpdir/rtl/pll
        gen_qsys "pll_hdmi"
        
        set quartus_ini [open "quartus.ini" w]
        puts $quartus_ini "permit_nf_pll_reconfig_out_of_lock=on"
        close $quartus_ini
        
        gen_qsys "pll_hdmi_reconfig"

        send_message INFO "Generating edid_ram and output_buf_i2c IPs"
        cd $tmpdir/rtl/i2c_slave
        gen_qsys "edid_ram"
        cd $tmpdir/rtl/common
        gen_qsys "output_buf_i2c"

        # //////////////////////////////////////////////////////////////////////////////
        #   Create CPU Sys
        # //////////////////////////////////////////////////////////////////////////////
        send_message INFO "Generating cpu subsystem IP"
        cd $tmpdir/rtl
        gen_qsys "nios"
        cd $tmpdir/rtl/common
        gen_qsys "clock_control"
        
        # //////////////////////////////////////////////////////////////////////////////
        #   Create Reset Controller
        # //////////////////////////////////////////////////////////////////////////////
        cd $tmpdir/rtl/common
        gen_qsys "reset_controller"
		
        # //////////////////////////////////////////////////////////////////////////////
        #   Create HDR Sys
        # //////////////////////////////////////////////////////////////////////////////
        send_message INFO "Generating Avalon-ST multiplexer IP"
        cd $tmpdir/rtl/hdr
        gen_qsys "avalon_st_multiplexer"
        
        # //////////////////////////////////////////////////////////////////////////////
        #   Create DCFIFO
        # //////////////////////////////////////////////////////////////////////////////
        send_message INFO "Generating dcfifo IPs"
        cd $tmpdir/rtl/common
        gen_qsys_terp "fifo"

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
        catch { [exec $quartus_sh_exe -t $createproj_filename] } temp
        file delete -force -- $assignment_filename $createproj_filename
   
        # //////////////////////////////////////////////////////////////////////////////
        #   Create Software file
        # //////////////////////////////////////////////////////////////////////////////
        send_message INFO "Creating software"
        cd  $tmpdir
        file copy $ed_src_dir/software "."
        cd $tmpdir/script
        #catch { [exec ./build_sw.sh] } temp
        if { $OS_WIN == 1} {
                set cmd [list "${windows_nios2_cmd_shell}" "sh" "build_sw.sh" ]
                catch {eval [concat [list exec "--"] $cmd]} temp
        } else {
                set cmd [list "${linux_nios2_cmd_shell}" "sh" "build_sw.sh" ]
                catch {eval [concat [list exec "--"] $cmd]} temp
        }
    }

    # //////////////////////////////////////////////////////////////////////////////
    #   Create Simulation file
    # //////////////////////////////////////////////////////////////////////////////
    if { [get_parameter_value ENABLE_ED_FILESET_SIM] == 1 } {
        send_message INFO "Creating Simulation"
        cd  $tmpdir
        file copy   "$ed_src_dir/simulation" "."
        cd  $tmpdir/simulation/hdmi_tx
        gen_qsys_terp   "hdmi_tx"
	cd  $tmpdir/simulation/hdmi_rx
        gen_qsys_terp   "hdmi_rx"

	cd $tmpdir/simulation
        gen_sim_setup
	if {1} {
	file rename "aldec.do"          "aldec/aldec.do"
	}
	if {1} {
	file rename "ncsim.sh"          "cadence/ncsim.sh"
	}
	if {1} {
	file rename "mentor.do"         "mentor/mentor.do"
	}
	if {1} {
	file rename "vcsmx_sim.sh"      "synopsys/vcsmx/vcsmx_sim.sh"
	if { [get_parameter_value SELECT_ED_FILESET] == "VERILOG" } {
		# For some reasons, makefile can't be updated when file is named as filelist.f.terp.
		# Named it as vcs_filelist.sh.terp in ACDS folder, but outputing it as filelist.f
		file rename "vcs_filelist.sh"   "synopsys/vcs/filelist.f"
		file rename "vcs_sim.sh"        "synopsys/vcs/vcs_sim.sh"
	} else {
		file delete -force -- "vcs_filelist.sh"
		file delete -force -- "vcs_sim.sh"

	}
	}
    }
    
    # //////////////////////////////////////////////////////////////////////////////
    #   Propagate files from temp dir to user specified directory
    # //////////////////////////////////////////////////////////////////////////////
    cd $tmpdir
    send_message INFO "Adding files from $tmpdir to your directory"
    glob_recursive [pwd] {} $ed_name

    if { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 1 } {
        # Top level .v
        set top_v_terp [get_terp_content "$ed_src_dir/rtl/$ed_name.v.terp" \
                        [list $ed_name \
                              [get_parameter_value SYMBOLS_PER_CLOCK] \
                              [get_parameter_value SUPPORT_AUXILIARY] \
                              [get_parameter_value SUPPORT_AUDIO] \
                              [get_parameter_value SUPPORT_DEEP_COLOR]]]
        add_fileset_file "rtl/$ed_name.v"   VERILOG     TEXT    $top_v_terp

        set top_v_terp [get_terp_content "$ed_src_dir/rtl/hdmi_tx/hdmi_tx_top.v.terp" \
                        [list $ed_name \
                              [get_parameter_value SYMBOLS_PER_CLOCK] \
                              [get_parameter_value SUPPORT_AUXILIARY] \
                              [get_parameter_value SUPPORT_AUDIO] \
                              [get_parameter_value SUPPORT_DEEP_COLOR]]]
        add_fileset_file "rtl/hdmi_tx/hdmi_tx_top.v"   VERILOG     TEXT    $top_v_terp

        set top_v_terp [get_terp_content "$ed_src_dir/rtl/hdmi_tx/mr_hdmi_tx_core_top.v.terp" \
                        [list $ed_name \
                              [get_parameter_value SYMBOLS_PER_CLOCK] \
                              [get_parameter_value SUPPORT_AUXILIARY] \
                              [get_parameter_value SUPPORT_AUDIO] \
                              [get_parameter_value SUPPORT_DEEP_COLOR]]]
        add_fileset_file "rtl/hdmi_tx/mr_hdmi_tx_core_top.v"   VERILOG     TEXT    $top_v_terp

        set top_v_terp [get_terp_content "$ed_src_dir/rtl/hdmi_rx/hdmi_rx_top.v.terp" \
                        [list $ed_name \
                              [get_parameter_value SYMBOLS_PER_CLOCK] \
                              [get_parameter_value SUPPORT_AUXILIARY] \
                              [get_parameter_value SUPPORT_AUDIO] \
                              [get_parameter_value SUPPORT_DEEP_COLOR]]]
        add_fileset_file "rtl/hdmi_rx/hdmi_rx_top.v"   VERILOG     TEXT    $top_v_terp

        set top_v_terp [get_terp_content "$ed_src_dir/rtl/hdmi_rx/mr_hdmi_rx_core_top.v.terp" \
                        [list $ed_name \
                              [get_parameter_value SYMBOLS_PER_CLOCK] \
                              [get_parameter_value SUPPORT_AUXILIARY] \
                              [get_parameter_value SUPPORT_AUDIO] \
                              [get_parameter_value SUPPORT_DEEP_COLOR]]]
        add_fileset_file "rtl/hdmi_rx/mr_hdmi_rx_core_top.v"   VERILOG     TEXT    $top_v_terp

        set top_v_terp [get_terp_content "$ed_src_dir/rtl/sdc/rxtx_link.sdc.terp" \
                        [list $ed_name \
                              [get_parameter_value SYMBOLS_PER_CLOCK] \
                              [get_parameter_value SUPPORT_AUXILIARY] \
                              [get_parameter_value SUPPORT_AUDIO] \
                              [get_parameter_value SUPPORT_DEEP_COLOR]]]
        add_fileset_file "rtl/sdc/rxtx_link.sdc"   SDC     TEXT    $top_v_terp

        append projname $ed_name ".qpf"
        send_message INFO "You may now open the project file $projname to compile the design"

    }


    if { [get_parameter_value ENABLE_ED_FILESET_SIM] == 1 } {
        set top_v_terp [get_terp_content "$ed_src_dir/simulation/bitec_hdmi_tb.sv.terp" \
                        [list $ed_name \
                              [get_parameter_value SYMBOLS_PER_CLOCK] \
                              [get_parameter_value SUPPORT_AUXILIARY] \
                              [get_parameter_value SUPPORT_AUDIO] \
                              [get_parameter_value SUPPORT_DEEP_COLOR]]]
        add_fileset_file "simulation/bitec_hdmi_tb.sv"   VERILOG     TEXT    $top_v_terp

    }

}
# ------------------------------------------------------------------------------------
#   Function to create .qsys file and generate it (more enhancements required)
# ------------------------------------------------------------------------------------

proc gen_ip_from_qsys {inst_name} {
    set qsys_generate_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate"
    append inst_qsys        $inst_name ".qsys"

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
#   Function to create .qsys file and generate it (more enhancements required)
# ------------------------------------------------------------------------------------

proc gen_qsys {inst_name} {

	
    append inst_filename    $inst_name ".tcl"
    append inst_qsys        $inst_name ".qsys"
	
        # Executable must be reference from QUARTUS_ROOTDIR, or else might have risk of failing in customer installation
		set qsys_script_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
		set qsys_generate_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate"
	
		catch {eval [exec $qsys_script_exe --script=$inst_filename --quartus-project=none] } temp
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
                          [get_parameter_value SYMBOLS_PER_CLOCK] \
                          [get_parameter_value SUPPORT_AUXILIARY] \
                          [get_parameter_value SUPPORT_AUDIO] \
                          [get_parameter_value SUPPORT_DEEP_COLOR]]]
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
proc glob_recursive {src_dir dest_dir top_name} {
    set contents [glob -directory $src_dir *]

    foreach item $contents {
        set filename [file tail $item]
        # go into subdirectories
        if { [file isdirectory $item] } {
            glob_recursive $item [file join $dest_dir $filename] $top_name
        } elseif { [file isfile $item] } {
            addfile_to_user $item $dest_dir $top_name
        }
    }
}

# ------------------------------------------------------------------------------------
#   Function to propagate files to user specified dir
# ------------------------------------------------------------------------------------
proc addfile_to_user { full_path dest_dir top_name } {
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

proc generate_copy_ed {name} {
    global env
    set qdir $env(QUARTUS_ROOTDIR)
    set tmpdir [create_temp_file {}]
    # Family specific string now (Arria_10) has to be enhanced in the future
    set ed_src_dir "${qdir}/../ip/altera/altera_hdmi/hw_demo/$name"
    set ed_name     $name

    send_message INFO "Creating fixed parameters (ignoring your setting) design example"
    # //////////////////////////////////////////////////////////////////////////////
    #   Copy all files and folders from ACDS to temp directory
    # //////////////////////////////////////////////////////////////////////////////
    cd  $tmpdir

    file copy $ed_src_dir "."

    cd $tmpdir/$name
    catch { [exec "quartus_sh" -t build_ip.tcl] } temp
    #catch { [exec ./build_sw.sh] } temp
    # Executable must be reference from QUARTUS_ROOTDIR, or else might have risk of failing in customer installation
    set windows_nios2_cmd_shell "$qdir/../nios2eds/Nios II Command Shell.bat"
    set linux_nios2_cmd_shell "$qdir/../nios2eds/nios2_command_shell.sh"
    set OS_WIN 0
    if {[file exists $windows_nios2_cmd_shell]} {
                    set OS_WIN 1
    }
    if { $OS_WIN == 1} {
            set cmd [list "${windows_nios2_cmd_shell}" "sh" "build_sw.sh" ]
            catch {eval [concat [list exec "--"] $cmd]} temp
    } else {
            set cmd [list "${linux_nios2_cmd_shell}" "sh" "build_sw.sh" ]
            catch {eval [concat [list exec "--"] $cmd]} temp
    }

    # //////////////////////////////////////////////////////////////////////////////
    #   Propagate files from temp dir to user specified directory
    # //////////////////////////////////////////////////////////////////////////////
    #cd $tmpdir
    send_message INFO "Adding files from $tmpdir to your directory"
    glob_recursive [pwd] {} $ed_name
    append projname $ed_name "_demo.qpf"
    send_message INFO "You may now open the project file $projname to compile the design"

}

proc gen_sim_setup {} {

    set hdmi_tx_spd_list [join [glob -directory "./hdmi_tx/" */*.spd] ,]
    set hdmi_rx_spd_list [join [glob -directory "./hdmi_rx/" */*.spd] ,]
    set spd_list [join [list $hdmi_tx_spd_list $hdmi_rx_spd_list] ,]
    # Executable must be reference from QUARTUS_ROOTDIR, or else might have risk of failing in customer installation
    set qsys_ip_make_simscript_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/ip-make-simscript"
    catch {eval [exec $qsys_ip_make_simscript_exe "--spd=$spd_list"] } temp
	 
}

