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
    set ed_src_dir "${qdir}/../ip/altera/sdi_ii/sdi_ii_example_design/arria_10"
    set ed_name     sdi_ii_a10_demo

    # Error checking to make sure that 1 of the Simulation or Synthesis check boxes are enabled
    if { ([get_parameter_value ENABLE_ED_FILESET_SIM] == 0 && [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 0) || [get_parameter_value SELECT_SUPPORTED_VARIANT] == 0} {
        send_message error "Neither \"Simulation\" nor \"Synthesis\" check boxes from \"Files Types Generated\" are selected to allow generation of Design Example Files."
    }
    send_message INFO "Creating design example"

    if { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 1 } {
        # //////////////////////////////////////////////////////////////////////////////
        #   Copy Quartus folder to tmp folder
        # //////////////////////////////////////////////////////////////////////////////
        cd  $tmpdir
        file copy $ed_src_dir/quartus "."

        # //////////////////////////////////////////////////////////////////////////////
        #   Create assignment.tcl file in tmp folder
        # //////////////////////////////////////////////////////////////////////////////
        cd $tmpdir/quartus
        set assignment_terp [get_terp_content "assignments.tcl.terp" [list  [get_parameter_value ED_DEVICE] \
                                                                            $ed_name \
                                                                            [get_parameter_value SELECT_TARGETED_BOARD] \
                                                                            [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                            [get_parameter_value VIDEO_STANDARD] \
                                                                            [get_parameter_value BASE_DEVICE] \
                                                                            [get_parameter_value DIRECTION] \
                                                                            [get_parameter_value ED_TXPLL_SWITCH] ]]
        set assignment_filename "assignment.tcl"
        set assignment_tcl [open $assignment_filename w]
        puts $assignment_tcl "$assignment_terp"
        close $assignment_tcl

        # //////////////////////////////////////////////////////////////////////////////
        #   Create Quartus project in tmp folder
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
        catch {eval [exec $quartus_sh_exe -t $createproj_filename] } temp
        file delete -force -- $assignment_filename $createproj_filename

        # //////////////////////////////////////////////////////////////////////////////
        #   Create hwtest folder in tmp folder
        # //////////////////////////////////////////////////////////////////////////////
        if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 3 } {
            cd  $tmpdir
            file copy $ed_src_dir/hwtest "."

            cd $tmpdir/hwtest
            set tpg_ctrl_terp [get_terp_content "tpg_ctrl.tcl.terp" [list  [get_parameter_value VIDEO_STANDARD] \
                                                                           [get_parameter_value ED_TXPLL_SWITCH] ]]
            set tpg_ctrl_filename "tpg_ctrl.tcl"
            set tpg_ctrl_tcl [open $tpg_ctrl_filename w]
            puts $tpg_ctrl_tcl "$tpg_ctrl_terp"
            close $tpg_ctrl_tcl
        }
    }

    # //////////////////////////////////////////////////////////////////////////////
    #   Create .qsys file and generate in tmp folder
    # //////////////////////////////////////////////////////////////////////////////
    cd  $tmpdir

    file copy $ed_src_dir/rtl "."
    if { [get_parameter_value VIDEO_STANDARD] == "hd" || [get_parameter_value VIDEO_STANDARD] == "threeg" } {
        file delete -force rtl/rx/sdi_ii_rx_rcfg_a10.sv
    }
    if { [get_parameter_value ED_TXPLL_SWITCH] == 0 } {
        file delete -force rtl/tx/sdi_ii_tx_rcfg_a10.sv
    }
    # Delete duplex if selected direction is simplex, or otherwise
    if { [get_parameter_value DIRECTION] == "du" } {
        file copy   "$tmpdir/rtl/tx/tx_pll.tcl.terp"        "$tmpdir/rtl/du/"
        file copy   "$tmpdir/rtl/tx/tx_pll_alt.tcl.terp"    "$tmpdir/rtl/du/"
        if { [get_parameter_value VIDEO_STANDARD] == "tr" || [get_parameter_value VIDEO_STANDARD] == "mr" } {
            file copy   "$tmpdir/rtl/rx/sdi_ii_rx_rcfg_a10.sv"  "$tmpdir/rtl/du/"
        }
        if { [get_parameter_value ED_TXPLL_SWITCH] != 0 } {
            file copy   "$tmpdir/rtl/tx/sdi_ii_tx_rcfg_a10.sv"  "$tmpdir/rtl/du/"
        }
        file delete -force -- rtl/rx
        file delete -force -- rtl/tx
    } else {
        file delete -force -- rtl/du
    }

    # Delete loopback folder for serial loopback design
    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 3 } {
        file delete -force -- rtl/loopback
    # Delete both modules for multi rate as VCXOless design is not supported and it is not using on-board Si516 osc
    } elseif { [get_parameter_value VIDEO_STANDARD] == "mr" } {
        file delete -force -- rtl/loopback/reclock
        file delete -force -- rtl/loopback/pfd
    # Delete reclocker module for non VCXOless design
    } elseif { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 1 } {
        file delete -force -- rtl/loopback/reclock
    }

    # Delete clock heartbeat file if synthesis option is disabled
    if { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 0 } {
        file delete -force rtl/clock_heartbeat.v
    }

    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 3 && [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] } {
        set pattgen_dir     $tmpdir/rtl/vid_pattgen
        if { ![file exists $pattgen_dir] } {
            file mkdir  "$pattgen_dir"
        }
        file copy   "$tmpdir/rtl/pattgen_ctrl.tcl.terp"         "$pattgen_dir"
        cd $pattgen_dir
        send_message INFO "Creating JTAG to Avalon Master bridge Qsys subsystem for System Console"
        gen_qsys    "pattgen_ctrl"
        set jtag_sdc_terp [get_terp_content "$ed_src_dir/rtl/jtag.sdc.terp" ""]
        add_fileset_file "rtl/vid_pattgen/jtag.sdc"     SDC     TEXT    $jtag_sdc_terp
    }

    if { [get_parameter_value DIRECTION] == "du" } {
        cd $tmpdir/rtl/du
        send_message INFO "Creating Duplex Qsys subsystem"
        gen_qsys    "sdi_du_sys"

        send_message INFO "Creating Tx PLL Qsys"
        gen_qsys    "tx_pll"
        if { [get_parameter_value ED_TXPLL_SWITCH] == 1 } {
            send_message INFO "Creating 2nd Tx PLL IP"
            gen_qsys    "tx_pll_alt"
        }

        if { [get_parameter_value VIDEO_STANDARD] == "tr" || [get_parameter_value VIDEO_STANDARD] == "mr" } {
            send_message INFO "Creating dummy Rx PHY Qsys"
            gen_qsys    "sdi_rx_phy"
        }
    } else {
        # Create SDI Rx Sys
        cd $tmpdir/rtl/rx
        send_message INFO "Creating Rx Qsys subsystem"
        gen_qsys    "sdi_rx_sys"
        
        # Create Tx PLL
        cd $tmpdir/rtl/tx
        send_message INFO "Creating Tx PLL Qsys"
        gen_qsys    "tx_pll"
        if { [get_parameter_value ED_TXPLL_SWITCH] == 1 } {
            send_message INFO "Creating 2nd Tx PLL IP"
            gen_qsys    "tx_pll_alt"
        }

        # Create SDI Tx Sys    
        send_message INFO "Creating Tx Qsys subsystem"
        gen_qsys    "sdi_tx_sys"
    }

    if { [get_parameter_value VIDEO_STANDARD] == "mr" && [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] } {
        # Create CLK CTRL Qsys for Multi rate design which is using daughter card
        cd $tmpdir/rtl
        send_message INFO "Creating ALTCLKCTRL Qsys"
        gen_qsys    "clk_ctrl"
    } elseif { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 1 && [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] } {
        cd $tmpdir/rtl
        send_message INFO "Creating IOPLL Qsys"
        gen_qsys    "pll_148"
    }

    # //////////////////////////////////////////////////////////////////////////////
    #   Copy simulation folder to tmp folder
    # //////////////////////////////////////////////////////////////////////////////
    if { [get_parameter_value ENABLE_ED_FILESET_SIM] == 1 } {
        cd  $tmpdir
        file copy   "$ed_src_dir/simulation"                    "."
        cd  $tmpdir/simulation
        gen_sim_setup
        if { [get_parameter_value SELECT_ED_FILESET] == "VERILOG" } {
            file rename "vcs_sim.sh"  "synopsys/vcs/vcs_sim.sh"
        } else {
            file delete -force -- "vcs_sim.sh"
        }
    }

    # //////////////////////////////////////////////////////////////////////////////
    #   Propagate files from temp dir to user specified directory
    # //////////////////////////////////////////////////////////////////////////////
    cd $tmpdir
    send_message INFO "Adding files to your directory"
    glob_recursive [pwd] {}
    
    # Adding common files from other directories (those files which are not generated in temp dir)
    add_common_rtl_files $ed_src_dir
    if { [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 1 } {
        add_synth_files $ed_src_dir $ed_name
    }

    # Testbench top and all related testbench files
    if { [get_parameter_value ENABLE_ED_FILESET_SIM] == 1 } {
        add_sim_files $ed_src_dir
    }
}

# ------------------------------------------------------------------------------------
#   Function to create .qsys file and generate it
# ------------------------------------------------------------------------------------
proc gen_qsys {inst_name} {
    set qsys_script_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
    set qsys_generate_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate"

    append inst_filename    $inst_name ".tcl"
    append inst_terp        $inst_name "_terp"
    append inst_terp_src    $inst_name ".tcl.terp"
    append inst_qsys        $inst_name ".qsys"

    set inst_terp [get_terp_content $inst_terp_src [list    [get_parameter_value ED_DEVICE] \
                                                            [get_parameter_value VIDEO_STANDARD] \
                                                            [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                            [get_parameter_value ED_TXPLL_TYPE] \
                                                            [get_parameter_value RX_CRC_ERROR_OUTPUT] \
                                                            [get_parameter_value RX_INC_ERR_TOLERANCE] \
                                                            [get_parameter_value RX_EN_VPID_EXTRACT] \
                                                            [get_parameter_value TX_EN_VPID_INSERT] \
                                                            [get_parameter_value SD_BIT_WIDTH] \
                                                            [get_parameter_value ED_TXPLL_SWITCH] ]]
    set inst_tcl [open $inst_filename w]
    puts $inst_tcl " $inst_terp"
    close $inst_tcl

    catch {eval [exec $qsys_script_exe --script=$inst_filename] } temp
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

# ------------------------------------------------------------------------------------
#   Function to generate simulation setup files for different simulators
# ------------------------------------------------------------------------------------
proc gen_sim_setup { } {
    set ip_make_simscript_exe "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/ip-make-simscript"

    if { [get_parameter_value DIRECTION] == "du" } {
        set all_spd_list [glob -directory "../rtl/du/" */*.spd]
        if { [get_parameter_value VIDEO_STANDARD] == "tr" || [get_parameter_value VIDEO_STANDARD] == "mr" } {
            # Get the dummy sdi_rx_phy from the list and remove it out
            set sdi_rx_phy_element [lsearch -regexp $all_spd_list "sdi_rx_phy"]
            set all_spd_list [lreplace $all_spd_list $sdi_rx_phy_element $sdi_rx_phy_element]
        }
        set spd_list [join $all_spd_list ,]
    } else {
        set tx_spd_list [join [glob -directory "../rtl/tx/" */*.spd] ,]
        set rx_spd_list [join [glob -directory "../rtl/rx/" */*.spd] ,]
        set spd_list [join [list $tx_spd_list $rx_spd_list] ,]
    }

    catch {eval [exec $ip_make_simscript_exe "--spd=$spd_list" "--use-relative-paths"] } temp
}

# ------------------------------------------------------------------------------------
#   Function to propagate common files to user directory
# ------------------------------------------------------------------------------------
proc add_common_rtl_files { ed_src_dir } {
    # Define folder name for Tx and Rx components
    if { [get_parameter_value DIRECTION] == "du" } {
        set tx_dir du
        set rx_dir du
    } else {
        set tx_dir tx
        set rx_dir rx
    }

    # Rcfg mgmt (Special case for this folder as we may need certain files only from here)
    if { [get_parameter_value VIDEO_STANDARD] == "tr" || [get_parameter_value VIDEO_STANDARD] == "mr" } {
        set rcfg_cdr_terp [get_terp_content "$ed_src_dir/../../sdi_ii_ed_reconfig_a10/src_hdl/rcfg_sdi_cdr.sv.terp" [get_parameter_value VIDEO_STANDARD]]
        add_fileset_file "rtl/$rx_dir/rcfg_sdi_cdr.sv"   SYSTEM_VERILOG  TEXT    $rcfg_cdr_terp
    }

    if { [get_parameter_value ED_TXPLL_SWITCH] != 0 } {
        addfile_to_user "$ed_src_dir/../../sdi_ii_ed_reconfig_a10/src_hdl/rcfg_pll_sw.sv"       "rtl/$tx_dir"
        addfile_to_user "$ed_src_dir/../../sdi_ii_ed_reconfig_a10/src_hdl/rcfg_refclk_sw.sv"    "rtl/$tx_dir"
    }
    addfile_to_user "$ed_src_dir/../../sdi_ii_ed_reconfig_a10/src_hdl/edge_detector.sv" "rtl/"

    # Reconfig arbiter
    if { [get_parameter_value VIDEO_STANDARD] == "tr" || [get_parameter_value VIDEO_STANDARD] == "mr" || [get_parameter_value ED_TXPLL_SWITCH] == 1 } {
        addfile_to_user "$ed_src_dir/../../sdi_ii_ed_reconfig_a10/src_hdl/a10_reconfig_arbiter.sv" "rtl/"
    }

    # Rx/Tx top or Du top
    if { [get_parameter_value DIRECTION] == "du" } {
        set du_top_terp [get_terp_content "$ed_src_dir/rtl/du/du_top.v.terp" [list  [get_parameter_value VIDEO_STANDARD] \
                                                                                    [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                    [get_parameter_value RX_CRC_ERROR_OUTPUT] \
                                                                                    [get_parameter_value RX_EN_VPID_EXTRACT] \
                                                                                    [get_parameter_value TX_EN_VPID_INSERT] \
                                                                                    [get_parameter_value ED_TXPLL_SWITCH] \
                                                                                    [get_parameter_value ED_TXPLL_TYPE] ]]
        add_fileset_file "rtl/du/du_top.v"          VERILOG         TEXT    $du_top_terp
    } else {
        set rx_top_terp [get_terp_content "$ed_src_dir/rtl/rx/rx_top.v.terp" [list  [get_parameter_value VIDEO_STANDARD] \
                                                                                    [get_parameter_value RX_CRC_ERROR_OUTPUT] \
                                                                                    [get_parameter_value RX_EN_VPID_EXTRACT] \
                                                                                    [get_parameter_value ED_TXPLL_SWITCH] ]]

        set tx_top_terp [get_terp_content "$ed_src_dir/rtl/tx/tx_top.v.terp" [list  [get_parameter_value VIDEO_STANDARD] \
                                                                                    [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                    [get_parameter_value TX_EN_VPID_INSERT] \
                                                                                    [get_parameter_value ED_TXPLL_SWITCH] \
                                                                                    [get_parameter_value ED_TXPLL_TYPE] ]]

        add_fileset_file "rtl/rx/rx_top.v"          VERILOG         TEXT    $rx_top_terp
        add_fileset_file "rtl/tx/tx_top.v"          VERILOG         TEXT    $tx_top_terp
    }

    # Video pattgen
    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 3 } {
        foreach item [glob -directory "$ed_src_dir/../../sdi_ii_ed_vid_pattgen/src_hdl" *] {
            addfile_to_user $item "rtl/vid_pattgen"
        }
    }
}

# ------------------------------------------------------------------------------------
#   Function to propagate synthesis files to user directory
# ------------------------------------------------------------------------------------
proc add_synth_files { ed_src_dir ed_name } {
    # Top level .v and .sdc files
    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 3 } {
        set top_v_terp [get_terp_content "$ed_src_dir/rtl/serial_top.v.terp"    [list $ed_name \
                                                                            [get_parameter_value VIDEO_STANDARD] \
                                                                            [get_parameter_value DIRECTION] \
                                                                            [get_parameter_value SD_BIT_WIDTH] \
                                                                            [get_parameter_value RX_CRC_ERROR_OUTPUT] \
                                                                            [get_parameter_value RX_EN_VPID_EXTRACT] \
                                                                            [get_parameter_value TX_EN_VPID_INSERT] \
                                                                            [get_parameter_value ED_TXPLL_SWITCH] ]]
    } else {
        set top_v_terp [get_terp_content "$ed_src_dir/rtl/top.v.terp" [list $ed_name \
                                                                        [get_parameter_value VIDEO_STANDARD] \
                                                                        [get_parameter_value DIRECTION] \
                                                                        [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                        [get_parameter_value RX_CRC_ERROR_OUTPUT] \
                                                                        [get_parameter_value RX_EN_VPID_EXTRACT] \
                                                                        [get_parameter_value TX_EN_VPID_INSERT] ]]
    }
    set top_sdc_terp [get_terp_content "$ed_src_dir/rtl/top.sdc.terp" [list [get_parameter_value VIDEO_STANDARD] \
                                                                            [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                            [get_parameter_value ED_TXPLL_SWITCH] \
                                                                            [get_parameter_value DIRECTION]]]

    add_fileset_file "rtl/$ed_name.v"               VERILOG TEXT    $top_v_terp
    add_fileset_file "rtl/$ed_name.sdc"             SDC     TEXT    $top_sdc_terp

    # Loopback path
    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] != 3 } {
        set lb_top_terp [get_terp_content "$ed_src_dir/rtl/loopback/loopback_top.v.terp" [list  [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                                [get_parameter_value VIDEO_STANDARD]]]
        add_fileset_file "rtl/loopback/loopback_top.v"  VERILOG TEXT    $lb_top_terp

        foreach item [glob -directory "$ed_src_dir/../../sdi_ii_ed_loopback/src_hdl" *] {
            addfile_to_user $item "rtl/loopback/fifo"
        }
    }
    # SDC file for PFD module
    if { [get_parameter_value VIDEO_STANDARD] != "mr" && [get_parameter_value SELECT_SUPPORTED_VARIANT] != 3 } {
        set pfd_sdc_terp [get_terp_content "$ed_src_dir/rtl/loopback/pfd/pfd.sdc.terp" [list    [get_parameter_value DIRECTION] ]]
        add_fileset_file "rtl/loopback/pfd/pfd.sdc" SDC         TEXT    $pfd_sdc_terp
    }
}

# ------------------------------------------------------------------------------------
#   Function to propagate simulation files to user directory
# ------------------------------------------------------------------------------------
proc add_sim_files { ed_src_dir } {
   if { [get_parameter_value INTERNAL_TEST] == 1 } {
        set tb_top_terp [get_terp_content "$ed_src_dir/simulation/tb_top_internal.v.terp" [list  [get_parameter_value VIDEO_STANDARD] \
                                                                                        [get_parameter_value DIRECTION] \
                                                                                        [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                        [get_parameter_value RX_CRC_ERROR_OUTPUT] \
                                                                                        [get_parameter_value RX_INC_ERR_TOLERANCE] \
                                                                                        [get_parameter_value RX_EN_VPID_EXTRACT] \
                                                                                        [get_parameter_value TX_EN_VPID_INSERT] \
                                                                                        [get_parameter_value SD_BIT_WIDTH] \
                                                                                        [get_parameter_value ED_TXPLL_SWITCH] \
                                                                                        [get_parameter_value INTERNAL_TEST] \
                                                                                        [get_parameter_value TEST_LN_OUTPUT] \
                                                                                        [get_parameter_value TEST_SYNC_OUTPUT] \
                                                                                        [get_parameter_value TEST_RECONFIG_SEQ] \
                                                                                        [get_parameter_value TEST_DISTURB_SERIAL] \
                                                                                        [get_parameter_value TEST_DL_SYNC] \
                                                                                        [get_parameter_value TEST_DATA_COMPARE] \
                                                                                        [get_parameter_value TEST_TRS_LOCKED] \
                                                                                        [get_parameter_value TEST_FRAME_LOCKED] \
                                                                                        [get_parameter_value TEST_VPID_OVERWRITE] \
                                                                                        [get_parameter_value TEST_MULTI_RECON] \
                                                                                        [get_parameter_value TEST_SERIAL_DELAY] \
                                                                                        [get_parameter_value TEST_RESET_SEQ] \
                                                                                        [get_parameter_value TEST_RESET_RECON] \
                                                                                        [get_parameter_value TEST_RST_PRE_OW] \
                                                                                        [get_parameter_value TEST_RXSAMPLE_CHK] \
                                                                                        [get_parameter_value TEST_GEN_ANC] \
                                                                                        [get_parameter_value TEST_GEN_VPID] \
                                                                                        [get_parameter_value TEST_VPID_PKT_COUNT] \
                                                                                        [get_parameter_value TEST_ERR_VPID] ]]
    } else {
        set tb_top_terp [get_terp_content "$ed_src_dir/simulation/tb_top.v.terp" [list  [get_parameter_value VIDEO_STANDARD] \
                                                                                        [get_parameter_value DIRECTION] \
                                                                                        [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                        [get_parameter_value RX_CRC_ERROR_OUTPUT] \
                                                                                        [get_parameter_value RX_INC_ERR_TOLERANCE] \
                                                                                        [get_parameter_value RX_EN_VPID_EXTRACT] \
                                                                                        [get_parameter_value TX_EN_VPID_INSERT] \
                                                                                        [get_parameter_value SD_BIT_WIDTH] \
                                                                                        [get_parameter_value ED_TXPLL_SWITCH] ]]
    }

    set mentor_do_terp [get_terp_content "$ed_src_dir/simulation/mentor.do.terp" [list  [get_parameter_value SELECT_ED_FILESET] \
                                                                                        [get_parameter_value VIDEO_STANDARD] \
                                                                                        [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                        18.1 \
                                                                                        [get_parameter_value DIRECTION] \
                                                                                        [get_parameter_value ED_TXPLL_SWITCH] ]]

    set aldec_do_terp [get_terp_content "$ed_src_dir/simulation/aldec.do.terp" [list    [get_parameter_value SELECT_ED_FILESET] \
                                                                                        [get_parameter_value VIDEO_STANDARD] \
                                                                                        [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                        18.1 \
                                                                                        [get_parameter_value DIRECTION] \
                                                                                        [get_parameter_value ED_TXPLL_SWITCH] ]]

    set vcsmx_sim_sh_terp [get_terp_content "$ed_src_dir/simulation/vcsmx_sim.sh.terp" [list    [get_parameter_value SELECT_ED_FILESET] \
                                                                                                [get_parameter_value VIDEO_STANDARD] \
                                                                                                [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                                18.1 \
                                                                                                [get_parameter_value DIRECTION] \
                                                                                                [get_parameter_value ED_TXPLL_SWITCH] ]]

    set ncsim_sh_terp [get_terp_content "$ed_src_dir/simulation/ncsim.sh.terp" [list    [get_parameter_value SELECT_ED_FILESET] \
                                                                                        [get_parameter_value VIDEO_STANDARD] \
                                                                                        [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                        18.1 \
                                                                                        [get_parameter_value DIRECTION] \
                                                                                        [get_parameter_value ED_TXPLL_SWITCH] ]]

    add_fileset_file "simulation/testbench/tb_top.v"            VERILOG TEXT    $tb_top_terp
    add_fileset_file "simulation/mentor/mentor.do"              OTHER   TEXT    $mentor_do_terp
    add_fileset_file "simulation/aldec/aldec.do"                OTHER   TEXT    $aldec_do_terp
    add_fileset_file "simulation/synopsys/vcsmx/vcsmx_sim.sh"   OTHER   TEXT    $vcsmx_sim_sh_terp
    add_fileset_file "simulation/cadence/ncsim.sh"              OTHER   TEXT    $ncsim_sh_terp

    if { [get_parameter_value SELECT_ED_FILESET] == "VERILOG" } {
        # For some reasons, makefile can't be updated when file is named as filelist.f.terp. 
        # Named it as vcs_filelist.sh.terp in ACDS folder, but outputting it as filelist.f
        set filelist_f_terp [get_terp_content "$ed_src_dir/simulation/vcs_filelist.sh.terp" [list   [get_parameter_value SELECT_ED_FILESET] \
                                                                                                    [get_parameter_value VIDEO_STANDARD] \
                                                                                                    [get_parameter_value SELECT_SUPPORTED_VARIANT] \
                                                                                                    18.1 \
                                                                                                    [get_parameter_value DIRECTION] \
                                                                                                    [get_parameter_value ED_TXPLL_SWITCH] ]]
        add_fileset_file "simulation/synopsys/vcs/filelist.f"  OTHER     TEXT    $filelist_f_terp
    }

    # Tb control
    foreach item [glob -directory "$ed_src_dir/../../sdi_ii_tb_control/src_hdl" *] {
        addfile_to_user $item "simulation/testbench/tb_control"
    }
    # Tx checker
    foreach item [glob -directory "$ed_src_dir/../../sdi_ii_tb_tx_checker/src_hdl" *] {
        addfile_to_user $item "simulation/testbench/tx_checker"
    }
    # Rx checker
    foreach item [glob -directory "$ed_src_dir/../../sdi_ii_tb_rx_checker/src_hdl" *] {
        addfile_to_user $item "simulation/testbench/rx_checker"
    }

    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] != 3} {
        # Video pattgen
        foreach item [glob -directory "$ed_src_dir/../../sdi_ii_ed_vid_pattgen/src_hdl" *] {
            addfile_to_user $item "simulation/testbench/vid_pattgen"
        }
    }
}
