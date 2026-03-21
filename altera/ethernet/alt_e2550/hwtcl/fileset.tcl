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


package provide alt_e2550::fileset 18.1

package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::device
package require alt_xcvr::utils::ipgen
package require alt_xcvr::ip_tcl::ip_module
package require ethernet::tools
package require alt_e2550::rtl_tools
package require alt_e2550::sdc_tools
package require alt_e2550::qsf_tools
package require alt_e2550::srf_tools
package require alt_e2550::sim_script_tools

namespace eval ::alt_e2550::fileset:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*
    namespace import ::alt_xcvr::utils::fileset::*
    namespace import ::alt_xcvr::utils::ipgen::*

    variable hardware_project_src
    variable compilation_project_src
    variable hardware_project_dst
    variable compilation_project_dst

    set hardware_project_src    "hardware_test"
    set compilation_project_src "compilation_test"
    set hardware_project_dst    "hardware_test_design"
    set compilation_project_dst "compilation_test_design"
}

# This function is called when the GUI is openned
# and declare the generation callback functions as
# given in the "filesets" table
proc ::alt_e2550::fileset::declare_filesets { } {
    add_fileset quartus_synth  QUARTUS_SYNTH  ::alt_e2550::fileset::callback_synth
    add_fileset sim_verilog    SIM_VERILOG    ::alt_e2550::fileset::callback_sim
    add_fileset sim_vhdl       SIM_VHDL       ::alt_e2550::fileset::callback_sim
    add_fileset example_design EXAMPLE_DESIGN ::alt_e2550::fileset::callback_exa_sel

    set_fileset_property quartus_synth  ENABLE_FILE_OVERWRITE_MODE true
    set_fileset_property sim_verilog    ENABLE_FILE_OVERWRITE_MODE true
    set_fileset_property sim_vhdl       ENABLE_FILE_OVERWRITE_MODE true
    set_fileset_property example_design ENABLE_FILE_OVERWRITE_MODE true
}

# Callback for when user clicks "Generate HDL"
proc ::alt_e2550::fileset::callback_synth { entity } {
  ::alt_e2550::fileset::gen_fileset 0 $entity
}

# This gets called after "callback_synth" if user
# chooses to include sim files
proc ::alt_e2550::fileset::callback_sim { entity } {
  ::alt_e2550::fileset::gen_fileset 1 $entity
}

# This registers all of the files in the main libraries and defines
# where they will be copied to in the IP directory.
proc ::alt_e2550::fileset::gen_fileset { sim entity_name } {
    set SPEED_CONFIG    [ip_get "parameter.SPEED_CONFIG.value"]
    set RSFEC           [ip_get "parameter.SYNOPT_RSFEC.value"]
    set DIV40           [ip_get "parameter.SYNOPT_DIV40.value"]
    set PTP_EN          [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]

    ::alt_e2550::rtl_tools::generate_top_level_file $entity_name

    set ipfiles [list]

    if {$SPEED_CONFIG == 50} {
        lappend ipfiles [findFiles ../50g]
    } else {
        lappend ipfiles [findFiles ../25g]
    }

    if {$RSFEC} {
        if {$SPEED_CONFIG == 50} {
            lappend ipfiles [findFiles ../50g_rsfec]
        } else {
            lappend ipfiles [findFiles ../25g_rsfec]
        }
    }
    
    if {$PTP_EN} {
        if {$SPEED_CONFIG == 25} {
            lappend ipfiles [findFiles ../25g_ptp]
        }
    }

    lappend ipfiles [findFiles ../hslx]
    set ipfiles [join $ipfiles]

    if {$sim == 1} {
        # register the cadence protected files
        registerFileset $ipfiles "cadence" CADENCE_SPECIFIC
        # register the mentor protected files
        registerFileset $ipfiles "mentor" MENTOR_SPECIFIC
        # register the synopsys protected files
        registerFileset $ipfiles "synopsys" SYNOPSYS_SPECIFIC
        # register the non-protected simulation files
        registerFileset $ipfiles "sim_noencrypt" ""
    } else {
        # if this is a synth call register all applicable non-simulator protected files
        registerFileset $ipfiles "quartus" ""
    }
}

# This is called during elaboration and defines the name of the
# name of the instantiated top level file and adds instances of
# any IP needed by the main IP
proc ::alt_e2550::fileset::add_instances { } {
    set SPEED_CONFIG [ip_get "parameter.SPEED_CONFIG.value"]
    set SYNOPT_RSFEC [ip_get "parameter.SYNOPT_RSFEC.value"]
    set OTN          [ip_get "parameter.SYNOPT_OTN.value"]
    set DIV40        [ip_get "parameter.SYNOPT_DIV40.value"]

    if {$SPEED_CONFIG == 25} {
        if {$OTN} {
            set top_level_name alt_e25_otn;
        }
    }

    ::alt_e2550::fileset::add_xcvr_instance
    ::alt_e2550::fileset::add_atx_pll_instance 
    ::alt_e2550::fileset::add_reset_instance
    if {$SPEED_CONFIG == 50 && $DIV40 == 1} {
        ::alt_e2550::fileset::add_rx_fpll_instance
    }
    if {$SYNOPT_RSFEC} {
        ::alt_e2550::fileset::add_hsrs_instance
    }
}

# Add RSFEC IP instance to the IP
proc ::alt_e2550::fileset::add_hsrs_instance {} {
    # Add HSRS encoder instance
    set rsenc_inst rsenc;
    add_hdl_instance $rsenc_inst altera_highspeed_rs
    set_instance_parameter_value $rsenc_inst AUTO_DEVICE [ip_get "parameter.DEVICE.value"]
    set_instance_parameter_value $rsenc_inst selected_device_family "Arria 10"
    set_instance_parameter_value $rsenc_inst AUTO_DEVICE_SPEEDGRADE "1"
    set_instance_parameter_value $rsenc_inst BITSPERSYMBOL "10"
    set_instance_parameter_value $rsenc_inst BMSPEED       "4"
    set_instance_parameter_value $rsenc_inst IRRPOL        "1033"
    set_instance_parameter_value $rsenc_inst K             "514"
    set_instance_parameter_value $rsenc_inst N             "528"
    set_instance_parameter_value $rsenc_inst PAR           "8"
    set_instance_parameter_value $rsenc_inst RS            "Encoder"
    set_instance_parameter_value $rsenc_inst USEECCFORRAM  "1"
    set_instance_parameter_value $rsenc_inst USERAM        "0"
    set_instance_parameter_value $rsenc_inst USE_BKP       "0"

    # Add HSRS decoder instance
    set rsdec_inst rsdec;
    add_hdl_instance $rsdec_inst altera_highspeed_rs
    set_instance_parameter_value $rsdec_inst AUTO_DEVICE [ip_get "parameter.DEVICE.value"]
    set_instance_parameter_value $rsdec_inst selected_device_family "Arria 10"
    set_instance_parameter_value $rsdec_inst AUTO_DEVICE_SPEEDGRADE "1"
    set_instance_parameter_value $rsdec_inst BITSPERSYMBOL  "10"
    set_instance_parameter_value $rsdec_inst BMSPEED        "6"
    set_instance_parameter_value $rsdec_inst IRRPOL         "1033"
    set_instance_parameter_value $rsdec_inst K              "514"
    set_instance_parameter_value $rsdec_inst N              "528"
    set_instance_parameter_value $rsdec_inst PAR            "8"
    set_instance_parameter_value $rsdec_inst RS             "Decoder"
    set_instance_parameter_value $rsdec_inst USEECCFORRAM   "1"
    set_instance_parameter_value $rsdec_inst USERAM         "1"
    set_instance_parameter_value $rsdec_inst USETRUEDUALRAM "0"
    set_instance_parameter_value $rsdec_inst USE_BKP        "0"
}

# Add an atx PLL instance to the IP
proc ::alt_e2550::fileset::add_atx_pll_instance {} {
    # Add atx PLL instance
    set atx_pll_inst atx_pll_e50g;  # atx PLL instance name
    add_hdl_instance $atx_pll_inst altera_xcvr_atx_pll_a10
    set_instance_parameter_value $atx_pll_inst base_device [ip_get "parameter.part_trait_bd.value"]
    set_instance_parameter_value $atx_pll_inst device [ip_get "parameter.DEVICE.value"] 
    set_instance_parameter_value $atx_pll_inst primary_pll_buffer "GT clock output buffer"
    set_instance_parameter_value $atx_pll_inst enable_8G_path "0"
    set_instance_parameter_value $atx_pll_inst enable_16G_path "1"
    set_instance_parameter_value $atx_pll_inst set_output_clock_frequency "12890.625"
    set_instance_parameter_value $atx_pll_inst set_auto_reference_clock_frequency "644.53125"
}

# Add a xcvr instance to the IP
proc ::alt_e2550::fileset::add_xcvr_instance {} {
    set SPEED_CONFIG    [ip_get "parameter.SPEED_CONFIG.value"]
    set PTP_EN [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
    set DIV40 [ip_get "parameter.SYNOPT_DIV40.value"]
    # Add xcvr instance
    set xcvr_inst a10_xcvr_25g;   # XCVR instance name
    add_hdl_instance             $xcvr_inst altera_xcvr_native_a10
    set_instance_parameter_value $xcvr_inst channels "1"
    set_instance_parameter_value $xcvr_inst base_device [ip_get "parameter.part_trait_bd.value"]
    set_instance_parameter_value $xcvr_inst device_family "Arria 10"
    set_instance_parameter_value $xcvr_inst device [ip_get "parameter.DEVICE.value"] 
    set_instance_parameter_value $xcvr_inst protocol_mode "basic_enh"
    set_instance_parameter_value $xcvr_inst set_data_rate "25781.25"
    set_instance_parameter_value $xcvr_inst set_cdr_refclk_freq "644.531250"
    set_instance_parameter_value $xcvr_inst anlg_voltage "1_1V"
    #if {$PTP_EN == 0} {
        set_instance_parameter_value $xcvr_inst enable_port_rx_enh_bitslip "1"
    #}
    set_instance_parameter_value $xcvr_inst enable_port_rx_enh_data_valid "1"
    set_instance_parameter_value $xcvr_inst enable_ports_rx_manual_cdr_mode  "1"
    set_instance_parameter_value $xcvr_inst enable_port_tx_pma_div_clkout "1"
    set_instance_parameter_value $xcvr_inst enable_port_rx_pma_div_clkout "1"
    set_instance_parameter_value $xcvr_inst enable_port_rx_enh_fifo_rd_en "1"
    set_instance_parameter_value $xcvr_inst enable_port_tx_enh_fifo_empty "1"
    set_instance_parameter_value $xcvr_inst enable_port_tx_enh_fifo_pempty "1"
    set_instance_parameter_value $xcvr_inst enable_port_tx_enh_fifo_pfull "1"
    set_instance_parameter_value $xcvr_inst enable_port_tx_enh_fifo_full "1"
    if {$PTP_EN == 0} {
        set_instance_parameter_value $xcvr_inst enh_rx_bitslip_enable "1"
    }
    set_instance_parameter_value $xcvr_inst enable_port_rx_enh_fifo_empty "1"
    set_instance_parameter_value $xcvr_inst enable_port_rx_enh_fifo_pempty "1"
    set_instance_parameter_value $xcvr_inst enable_port_rx_enh_fifo_pfull "1"
    set_instance_parameter_value $xcvr_inst enable_port_rx_enh_fifo_full "1"
    set_instance_parameter_value $xcvr_inst enable_port_rx_seriallpbken "1"
    set_instance_parameter_value $xcvr_inst enh_pcs_pma_width "64"
    set_instance_parameter_value $xcvr_inst enh_pld_pcs_width "66"
    if {$PTP_EN == 0} {
        set_instance_parameter_value $xcvr_inst enh_txfifo_mode "Basic"
        set_instance_parameter_value $xcvr_inst enh_rxfifo_mode "Basic"
    } else {
        set_instance_parameter_value $xcvr_inst enh_txfifo_mode "Fast register"
        set_instance_parameter_value $xcvr_inst enh_rxfifo_mode "Register"    
    }
    set_instance_parameter_value $xcvr_inst rcfg_enable "1"
    if {$SPEED_CONFIG == 50 && $DIV40 == 1} {
        set_instance_parameter_value $xcvr_inst rx_pma_div_clkout_divider "40"
    } else {
        set_instance_parameter_value $xcvr_inst rx_pma_div_clkout_divider "33"
    }
    set_instance_parameter_value $xcvr_inst tx_pma_div_clkout_divider "33"
    set_instance_parameter_value $xcvr_inst generate_docs "0"
    
    set adme_enable_hwtcl [ip_get "parameter.adme_enable_hwtcl.value"]
    if {$adme_enable_hwtcl == 1} {
        set_instance_parameter_value $xcvr_inst set_embedded_debug_enable "1"
        set_instance_parameter_value $xcvr_inst set_capability_reg_enable "1"
        set_instance_parameter_value $xcvr_inst rcfg_jtag_enable "1"
        set_instance_parameter_value $xcvr_inst set_csr_soft_logic_enable "1"
        set_instance_parameter_value $xcvr_inst set_prbs_soft_logic_enable "1"
    }

    set set_odi_soft_logic_enable [ip_get "parameters.set_odi_soft_logic_enable.value"]
    if {$set_odi_soft_logic_enable == 1} {
        set_instance_parameter_value $xcvr_inst dbg_odi_soft_logic_enable "1"
        set_instance_parameter_value $xcvr_inst dbg_embedded_debug_enable "1"
    }

}

# Add a PHY IP reset controller instance to the IP
proc ::alt_e2550::fileset::add_reset_instance {} {
    # Add reset instance
    set reset_inst a10_rst_ctrl;   # Reset controller instance name
    add_hdl_instance             $reset_inst altera_xcvr_reset_control
    set_instance_parameter_value $reset_inst channels "1"
    set_instance_parameter_value $reset_inst {CHANNELS} {1}
    set_instance_parameter_value $reset_inst {PLLS} {1}
    set_instance_parameter_value $reset_inst {SYS_CLK_IN_MHZ} {100}
    set_instance_parameter_value $reset_inst {SYNCHRONIZE_RESET} {1}
    set_instance_parameter_value $reset_inst {REDUCED_SIM_TIME} {1}
    set_instance_parameter_value $reset_inst {gui_split_interfaces} {0}
    set_instance_parameter_value $reset_inst {TX_PLL_ENABLE} {1}
    set_instance_parameter_value $reset_inst {T_PLL_POWERDOWN} {1000}
    set_instance_parameter_value $reset_inst {SYNCHRONIZE_PLL_RESET} {0}
    set_instance_parameter_value $reset_inst {TX_ENABLE} {1}
    set_instance_parameter_value $reset_inst {TX_PER_CHANNEL} {0}
    set_instance_parameter_value $reset_inst {gui_tx_auto_reset} {0}
    set_instance_parameter_value $reset_inst {T_TX_ANALOGRESET} {70000}
    set_instance_parameter_value $reset_inst {T_TX_DIGITALRESET} {70000}
    set_instance_parameter_value $reset_inst {T_PLL_LOCK_HYST} {0}
    set_instance_parameter_value $reset_inst {gui_pll_cal_busy} {0}
    set_instance_parameter_value $reset_inst {RX_ENABLE} {1}
    set_instance_parameter_value $reset_inst {RX_PER_CHANNEL} {0}
    set_instance_parameter_value $reset_inst {gui_rx_auto_reset} {0}
    set_instance_parameter_value $reset_inst {T_RX_ANALOGRESET} {70000}
    set_instance_parameter_value $reset_inst {T_RX_DIGITALRESET} {4000}
}
# Add an fPLL instance to the IP
proc ::alt_e2550::fileset::add_rx_fpll_instance {} {
    # Add rx fPLL instance
    set alt_e2550_rx_fpll_inst alt_e2550_rx_fpll;  # fPLL instance name
    add_hdl_instance $alt_e2550_rx_fpll_inst altera_xcvr_fpll_a10

    set_instance_parameter_value $alt_e2550_rx_fpll_inst base_device [get_parameter_value "part_trait_bd"]
    set_instance_parameter_value $alt_e2550_rx_fpll_inst gui_bw_sel "low"
    set_instance_parameter_value $alt_e2550_rx_fpll_inst gui_reference_clock_frequency "322.265625"
    set_instance_parameter_value $alt_e2550_rx_fpll_inst gui_fpll_mode "0"
    set_instance_parameter_value $alt_e2550_rx_fpll_inst gui_number_of_output_clocks "1"
    set_instance_parameter_value $alt_e2550_rx_fpll_inst gui_desired_outclk0_frequency "390.625"
    set_instance_parameter_value $alt_e2550_rx_fpll_inst gui_enable_fractional "false"
    set_instance_parameter_value $alt_e2550_rx_fpll_inst enable_pll_reconfig "1"
    set_instance_parameter_value $alt_e2550_rx_fpll_inst gui_enable_50G_support "true"
}

# Callback called when user selects "Generate example design"
proc ::alt_e2550::fileset::callback_exa_sel { entity } {
    # Stop generation of there's a perameter error
    set res [::alt_e2550::fileset::verify_legal_example_design_params]
    if {$res == -1} {
        send_message ERROR "Example design not generated"
        return
    }

    # Get simulation and synthesis checkbock values
    set generate_testbench          [ip_get "parameter.GEN_SIMULATION.value"]
    set generate_synthesis_designs  [ip_get "parameter.GEN_SYNTH.value"]

    ::alt_e2550::fileset::generate_ip_core;             # Generate our IP core
    ::alt_e2550::fileset::generate_compilation_project; # Generate the compilation project

    if {$generate_testbench} {
        ::alt_e2550::fileset::generate_testbench;
    }

    if {$generate_synthesis_designs} {
        ::alt_e2550::fileset::generate_hw_test_project
    }
}

# Error checking function used by example design callback
proc ::alt_e2550::fileset::verify_legal_example_design_params {} {
    set generate_testbench          [ip_get "parameter.GEN_SIMULATION.value"]
    set generate_synthesis_designs  [ip_get "parameter.GEN_SYNTH.value"]

    if {($generate_testbench == 0) & ($generate_synthesis_designs == 0)} {
        send_message ERROR "Must select at least one option under \"Example Design Files\""
        return -1
    }
    return 0
}

# Generate testbench project
# Basically just copy run scripts and testbench rtl file
proc ::alt_e2550::fileset::generate_testbench {} {
    set SPEED_CONFIG [ip_get "parameter.SPEED_CONFIG.value"]
    set OTN          [ip_get "parameter.SYNOPT_OTN.value"]

    if {$SPEED_CONFIG == 50} {
        set variant "ex_50g"
    } else {
        set variant "ex_25g"
    }

    # Copy testbench scripts
    add_fileset_file "../example_testbench/run_vsim.do"  OTHER TEXT [::alt_e2550::fileset::parse_name "../${variant}/sim" "../example_testbench/run_vsim.do" ]

    ::alt_e2550::sim_script_tools::generate_vcs_script
    ::alt_e2550::sim_script_tools::generate_ncsim_script
    ::alt_e2550::rtl_tools::generate_testbench_rtl
}

# Generate the compilation project
proc ::alt_e2550::fileset::generate_compilation_project { } {
    ::alt_e2550::rtl_tools::generate_compilation_rtl
    ::alt_e2550::sdc_tools::generate_compilation_sdc
    ::alt_e2550::qsf_tools::generate_compilation_qsf
    ::alt_e2550::srf_tools::generate_compilation_srf

    # Copy common files to project directory
    set dst [file join ".." "compilation_test_design"]
    set src [file join ".." "example_project" "common"]
    ::ethernet::tools::copy_folder $src $dst recursive
}

# Generate the hardware test project
proc ::alt_e2550::fileset::generate_hw_test_project {  } {
    # set ip_name [ip_get "module.NAME.value"]

    variable hardware_project_dst

    set dst_folder ${hardware_project_dst}
    set dst_common [file join $dst_folder common]

    ::alt_e2550::fileset::generate_iopll $dst_common
    ::alt_e2550::fileset::generate_jtag_bridge $dst_common
    ::alt_e2550::fileset::generate_probes $dst_common

    ::alt_e2550::rtl_tools::generate_hardware_rtl
    ::alt_e2550::sdc_tools::generate_hardware_sdc
    ::alt_e2550::qsf_tools::generate_hardware_qsf

    set dst [file join ".." "hardware_test_design"]

    # Copy example design files
    set src [file join ".." "example_project" "hwtest"]
    ::ethernet::tools::copy_folder $src $dst recursive

    # Copy hardware test related files
    set src [file join ".." "example_project" "common"]
    ::ethernet::tools::copy_folder $src $dst recursive
}

proc ::alt_e2550::fileset::generate_probes { dst } {
    set family [ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_e2550::fileset::get_board_safe_part]

    set ip altera_in_system_sources_probes
    set inst probe8

    lappend parameters "probe_width=8"
    lappend parameters "source_initial_value=0"
    lappend parameters "source_width=1"

    set templocation [create_temp_file "dummy.file"]
    set tempdir [file dirname $templocation]

    if {[is_qsys_edition QSYS_PRO]} {
        set src [file join ${tempdir} "${inst}.ip"]
        set qsys_dst [file join $dst "${inst}.ip"]
    } else {
        set src [file join ${tempdir} "${inst}.qsys"]
        set qsys_dst [file join $dst "${inst}.qsys"]
    }

    ::ethernet::tools::generate_ip_core $ip $inst $family $device $tempdir false $parameters
    add_fileset_file $qsys_dst OTHER PATH $src
}

proc ::alt_e2550::fileset::generate_jtag_bridge { dst } {
    set family [ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_e2550::fileset::get_board_safe_part]

    set ip altera_jtag_avalon_master
    set inst alt_e2550_jtag_bridge

    set templocation [create_temp_file "dummy.file"]
    set tempdir [file dirname $templocation]

    if {[is_qsys_edition QSYS_PRO]} {
        set src [file join ${tempdir} "${inst}.ip"]
        set qsys_dst [file join $dst "${inst}.ip"]
    } else {
        set src [file join ${tempdir} "${inst}.qsys"]
        set qsys_dst [file join $dst "${inst}.qsys"]
    }

    ::ethernet::tools::generate_ip_core $ip $inst $family $device $tempdir false
    add_fileset_file $qsys_dst OTHER PATH $src
}

proc ::alt_e2550::fileset::generate_iopll { dst } {
    set family [ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_e2550::fileset::get_board_safe_part]

    set ip altera_iopll
    set inst alt_e2550_sys_pll

    lappend parameters "gui_reference_clock_frequency=50.0"
    lappend parameters "gui_refclk1_frequency=100.0"
    lappend parameters "gui_use_locked=true"

    set templocation [create_temp_file "dummy.file"]
    set tempdir [file dirname $templocation]

    if {[is_qsys_edition QSYS_PRO]} {
        set src [file join ${tempdir} "${inst}.ip"]
        set qsys_dst [file join $dst "${inst}.ip"]
    } else {
        set src [file join ${tempdir} "${inst}.qsys"]
        set qsys_dst [file join $dst "${inst}.qsys"]
    }

    ::ethernet::tools::generate_ip_core $ip $inst $family $device $tempdir false $parameters
    add_fileset_file $qsys_dst OTHER PATH $src
}

# This is used by the example design callback to generate a copy of the IP core
proc ::alt_e2550::fileset::generate_ip_core {} {
    set SPEED_CONFIG        [ip_get "parameter.SPEED_CONFIG.value"]
    set DEVICE_FAMILY       [ip_get "parameter.DEVICE_FAMILY.value"]
    set ip_type             [ip_get "module.NAME.value"]
    set device              [::alt_e2550::fileset::get_board_safe_part]

    if {$SPEED_CONFIG == 50} {
        set variant "ex_50g"
    } else {
        set variant "ex_25g"
    }

    # Create temporary location to generate files
    set templocation [create_temp_file "${variant}_gen.tcl"]
    set tempdir [file dirname $templocation]

    # Get a list of parameter value pairs. Ex: {ADME_ENABLE=1 PREAMBLE_PASS=0 ... }
    set parameters [::ethernet::tools::generate_parameter_value_pairs [get_parameters]]
    # Use parameter list to generate copy of IP
    ::ethernet::tools::generate_ip_core $ip_type $variant "Arria 10" $device $tempdir true $parameters

    # Copy files from temp directory to project directory
    if {[is_qsys_edition QSYS_PRO]} {
        add_fileset_file "./${variant}.ip" OTHER PATH "${tempdir}/${variant}.ip"
    } else {
        add_fileset_file "./${variant}.qsys" OTHER PATH "${tempdir}/${variant}.qsys"
    }
    set fl [findFiles ${tempdir}/${variant}]
    foreach file $fl {
        set f_path [string map [list ${tempdir} ""] $file]
        add_fileset_file "./$f_path" OTHER PATH $file
    }
}

# If a board is specified, return the part it uses.
# Otherwise, return the device selected by user
proc ::alt_e2550::fileset::get_board_safe_part { } {
    set override_part [ip_get "parameter.OVERRIDE_PART_NUM.value"]
    set DEVICE        [ip_get "parameter.DEVICE.value"]

    if {$override_part} {
        return $DEVICE
    } else {
        set DEV_BOARD [ip_get "parameter.DEV_BOARD.value"]
        if {$DEV_BOARD == 1} {
            return 10AT115S2F45E2SG
        } else {
            # Use device passed by qsys for the case that no board is selected
            return $DEVICE
        }
    }
}


# -------------------------------------------------------------
# This function returns a list of all files in a directory tree
# -------------------------------------------------------------
proc findFiles { path } {
    set filelist {}
    # grab files and directories that exist at this level
    set file_lst [glob -nocomplain -directory $path -- *]

    # move systemverilog headers to front
    set idxs [lsearch -glob -all $file_lst *_h.sv]
    foreach idx $idxs {
        set f [lindex $file_lst $idx]
        set file_lst [lreplace $file_lst $idx $idx]
        set file_lst [linsert $file_lst 0 $f]
    }

    # move VHDL packages to front
    set vhd_pkgs [list *rsx_roots.vhd *package.vhd *functions.vhd *parameters.vhd ]
    foreach pkg $vhd_pkgs {
        set idxs [lsearch -glob -all $file_lst $pkg]
        foreach idx $idxs {
            set f [lindex $file_lst $idx]
            set file_lst [lreplace $file_lst $idx $idx]
            set file_lst [linsert $file_lst 0 $f]
        }
    }

    # for each file or directory
    foreach file ${file_lst} {   
        if {[file isdirectory $file] == 1} {
            # if its a directory call findFiles on that directory and append output to list
            set filelist [join [list $filelist [findFiles $path/[file tail $file]]]]
        } else {
            # if its a file append file location to list, ignore qsys and terp files
            if {![regexp {.*\.qsys$} $file] && ![regexp {.*\.terp$} $file]} {
                lappend filelist $path/[file tail $file]
            }
        }
    }
    # return the list
    return $filelist
}

# -------------------------------------------------------------
# This function will return a list of file paths filtered
# according to type. 
# -------------------------------------------------------------
proc filterFileset { filelist type } {

    set temp_list {}

    # if the function is specifying non-sim RTL than return a list of those filepaths
    if {$type == "quartus"} {
        foreach file ${filelist} {
            set dirname [file tail [file dirname $file]]
            if {[lsearch $file "*/aldec/*"] == -1 && [lsearch $file "*/cadence/*"] == -1 && [lsearch $file "*/mentor/*"] == -1 && [lsearch $file "*/synopsys/*"] == -1} {
                lappend temp_list $file
            }
        }
    # if the function is specifying aldec protected RTL than return a list of those filepaths
    } elseif { $type == "aldec"} {
        foreach file ${filelist} {
            set dirname [file tail [file dirname $file]]
            if {[lsearch $file "*/aldec/*"] == 0} {
                lappend temp_list $file
            }
        }
    # if the function is specifying cadence protected RTL than return a list of those filepaths
    } elseif { $type == "cadence"} {
        foreach file ${filelist} {
            set dirname [file tail [file dirname $file]]
            if {[lsearch $file "*/cadence/*"] == 0} {
                lappend temp_list $file
            }
        }
    # if the function is specifying mentor protected RTL than return a list of those filepaths
    } elseif { $type == "mentor"} {
        foreach file ${filelist} {
            set dirname [file tail [file dirname $file]]
            if {[lsearch $file "*/mentor/*"] == 0} {
                lappend temp_list $file
            }
        }
    # if the function is specifying synopsys protected RTL than return a list of those filepaths
    } elseif { $type == "synopsys"} {
        foreach file ${filelist} {
            set dirname [file tail [file dirname $file]]
            if {[lsearch $file "*/synopsys/*"] == 0} {
                lappend temp_list $file
            }
        }   
    }
    # return the list
    return $temp_list
}

# --------------------------------------------------------------
# This function will take a filelist and register it with HW.TCL
# according to the file set type and attributes
# --------------------------------------------------------------
proc registerFileset { filelist filetype attr} {

    # This block of code scans for non-protected files for simulation
    if {$filetype == "sim_noencrypt"} {
        # Build a hash table of protected files
        foreach file [filterFileset $filelist "aldec"] {
            set filehist([string map {"/aldec/" "/"} $file]) 1
        }
        # scan all non-sim files and see if they exists on the protected list
        # if they don't exist then that file is non-protected and should
        # be registered as such
        foreach file [filterFileset $filelist "quartus"] {
            if {[info exists filehist($file)] == 0} {
                send_message INFO [file tail $file]
                if {[file ext $file] == ".v"} {
                    add_fileset_file "./[file tail $file]" VERILOG PATH $file
                } elseif {[file ext $file] == ".sv"} {
                    add_fileset_file "./[file tail $file]" SYSTEM_VERILOG PATH $file
                } elseif {[file ext $file] == ".mif"} {
                    add_fileset_file "./[file tail $file]" MIF PATH $file
                } elseif {[file ext $file] == ".hex"} {
                    add_fileset_file "./[file tail $file]" HEX PATH $file
                } else {
                    add_fileset_file "./[file tail $file]" OTHER PATH $file
                }
            }
        }
        return
    }
    # for all other sim and non-sim files, register them according to the
    # file list type specified and the simulator attribute (if applicable)
    foreach file [filterFileset $filelist $filetype] {
        if {[file ext $file] == ".v"} {
            if {$filetype == "quartus"} {
                add_fileset_file "./[file tail $file]" VERILOG PATH $file
            } else {
                add_fileset_file "./$filetype/[file tail $file]" VERILOG PATH $file $attr
            }
        } elseif {[file ext $file] == ".sv"} {
            if {$filetype == "quartus"} {
                add_fileset_file "./[file tail $file]" SYSTEM_VERILOG PATH $file
            } else {
                add_fileset_file "./$filetype/[file tail $file]" SYSTEM_VERILOG PATH $file $attr
            }
        } elseif {[file ext $file] == ".mif"} {
            if {$filetype == "quartus"} {
                add_fileset_file "./[file tail $file]" MIF PATH $file
            } else {
                add_fileset_file "./$filetype/[file tail $file]" MIF PATH $file $attr
            }
        } elseif {[file ext $file] == ".hex"} {
            if {$filetype == "quartus"} {
                add_fileset_file "./[file tail $file]" HEX PATH $file
            } else {
                add_fileset_file "./$filetype/[file tail $file]" HEX PATH $file $attr
            }
        } elseif {[file ext $file] == ".sdc"} {
            if {$filetype == "quartus"} {
                add_fileset_file "./[file tail $file]" SDC PATH $file
            }
        } else {
            if {$filetype == "quartus"} {
                add_fileset_file "./[file tail $file]" OTHER PATH $file
            } else {
                add_fileset_file "./$filetype/[file tail $file]" OTHER PATH $file $attr
            }
        }
    }
}

proc ::alt_e2550::fileset::parse_name {variant path} {
	set fp [open $path r]
    set file_buffer [read $fp]
	close $fp
	regsub -all "ENET_ENTITY_QMEGA_01312014" $file_buffer $variant file_buffer
	return $file_buffer
}
