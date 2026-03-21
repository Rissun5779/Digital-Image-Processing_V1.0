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


package provide alt_eth_ultra::fileset 18.1

package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::device
package require alt_xcvr::utils::ipgen
package require alt_xcvr::ip_tcl::ip_module
package require ethernet::tools
package require alt_eth_ultra::qsf_settings
package require alt_eth_ultra::rtl_tools
package require alt_eth_ultra::qsf_tools
package require alt_eth_ultra::srf_tools
package require alt_eth_ultra::sdc_tools

namespace eval ::alt_eth_ultra::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::utils::fileset::*
  namespace import ::alt_xcvr::utils::ipgen::*

  namespace export \
    declare_filesets \
    declare_files \
    add_instances
}

proc ::alt_eth_ultra::fileset::declare_filesets { } {

    # Common PHY IP files
    set phypath [::alt_xcvr::utils::fileset::abs_to_rel_path [::alt_xcvr::utils::fileset::get_altera_xcvr_generic_path]]

    ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ ${phypath} {
        altera_xcvr_functions.sv
    } {KR4_A10_PMA}

    ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${phypath}/ctrl/" {
        alt_xcvr_resync.sv
    } {KR4_A10_PMA}

    # altera_xcvr_reset_control files
    set rstpath [::alt_xcvr::utils::fileset::abs_to_rel_path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]]

    ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${rstpath}/altera_xcvr_reset_control/" {
        altera_xcvr_reset_control.sv
        alt_xcvr_reset_counter.sv
    } {KR4_A10_PMA}

    add_fileset quartus_synth  QUARTUS_SYNTH  ::alt_eth_ultra::fileset::callback_synth
    add_fileset sim_verilog    SIM_VERILOG    ::alt_eth_ultra::fileset::callback_sim
    add_fileset sim_vhdl       SIM_VHDL       ::alt_eth_ultra::fileset::callback_sim
    add_fileset example_design EXAMPLE_DESIGN ::alt_eth_ultra::fileset::callback_exa_sel

    set_fileset_property quartus_synth  ENABLE_FILE_OVERWRITE_MODE true
    set_fileset_property sim_verilog    ENABLE_FILE_OVERWRITE_MODE true
    set_fileset_property sim_vhdl       ENABLE_FILE_OVERWRITE_MODE true
    set_fileset_property example_design ENABLE_FILE_OVERWRITE_MODE true

    set_fileset_property quartus_synth  TOP_LEVEL alt_aeu_ultra_top
    set_fileset_property sim_verilog    TOP_LEVEL alt_aeu_ultra_top
    set_fileset_property sim_vhdl       TOP_LEVEL alt_aeu_ultra_top
    set_fileset_property example_design TOP_LEVEL alt_aeu_ultra_top
}

proc ::alt_eth_ultra::fileset::callback_synth { entity } {

  set IS_100G   [ip_get "parameter.IS_100G.value"]
  ::alt_eth_ultra::fileset::gen_fileset 0 $entity
  if {$IS_100G} {
        add_fileset_file debug/stp/eth_100g_a10.xml   OTHER PATH  ../100g/rtl/eth_100g_a10.txt
        add_fileset_file debug/stp/build_stp.tcl      OTHER PATH  ../100g/rtl/build_stp.tcl

     }   else    {
        add_fileset_file debug/stp/eth_40g_a10.xml   OTHER PATH  ../40g/rtl/eth_40g_a10.txt
        add_fileset_file debug/stp/build_stp.tcl     OTHER PATH  ../40g/rtl/build_stp.tcl
     }

}

proc ::alt_eth_ultra::fileset::callback_sim { entity } {
  ::alt_eth_ultra::fileset::gen_fileset 1 $entity
}

proc ::alt_eth_ultra::fileset::gen_fileset { sim entity_name } {
    set IS_100G   [ip_get "parameter.IS_100G.value"]
    set IS_PTP    [ip_get "parameter.SYNOPT_PTP.value"]
    set IS_C4_FEC [ip_get "parameter.SYNOPT_C4_RSFEC.value"]
    set ENA_KR4   [ip_get "parameter.ENA_KR4.value"]
    set family    [ip_get "parameter.DEVICE_FAMILY.value"]
    send_message info "Current dir is [pwd]"

    if {$IS_100G} { set speed 100 } else { set speed 40 }
    set top_level_name alt_aeu_${speed}_top
    ::alt_eth_ultra::rtl_tools::generate_top_level_file $top_level_name

    set ipfiles [list]

    lappend ipfiles [findFiles ../hsl18]

    if {$IS_100G} {
        lappend ipfiles [findFiles ../100g]
        } else {
        lappend ipfiles [findFiles ../40g]
        }

    if {$IS_PTP} {
        if {$IS_100G} {
            lappend ipfiles [findFiles ../100g_del_calc]
            lappend ipfiles [findFiles ../100g_ptp]
    } else {
            lappend ipfiles [findFiles ../40g_del_calc]
            lappend ipfiles [findFiles ../40g_ptp]
        }
    }

    if {$IS_100G && $IS_C4_FEC} {
        lappend ipfiles [findFiles ../hsl23a10]
        lappend ipfiles [findFiles ../100g_bm]
        lappend ipfiles [findFiles ../100g_bm_vhd]
    }

    if {!$IS_100G && !$IS_PTP && $ENA_KR4 && $family == "Arria 10"} {
        lappend ipfiles [findFiles ../40g_kr4_a10]
    }

    set ipfiles [join $ipfiles]

    if {$sim == 1} {
        # register the aldec protected files
        registerFileset $ipfiles "aldec" ALDEC_SPECIFIC
        # register the cadence protected files
        registerFileset $ipfiles "cadence" CADENCE_SPECIFIC
        # register the mentor protected files
        registerFileset $ipfiles "mentor" MENTOR_SPECIFIC
        # register the synopsys protected files
        registerFileset $ipfiles "synopsys" SYNOPSYS_SPECIFIC
        # register the non-protected simulation files
        registerFileset $ipfiles "sim_noencrypt" ""

        if {$ENA_KR4 && $family == "Arria 10"} {
            common_add_fileset_files KR4_A10_PMA [concat PLAIN [common_fileset_tags_all_simulators]]
        }
    } else {
        # if this is a synth call register all applicable non-simulator protected files
        registerFileset $ipfiles "quartus" ""

        if {$ENA_KR4 && $family == "Arria 10"} {
            common_add_fileset_files KR4_A10_PMA {PLAIN QENCRYPT}
        }
    }
}

# Only if not using external TX PLL
proc ::alt_eth_ultra::fileset::add_tx_fabric_pll { } {
    set IS_100G          [ip_get "parameter.IS_100G.value"]
    set IS_CAUI4        [ip_get "parameter.SYNOPT_CAUI4.value"]
    set IS_C4_FEC       [ip_get "parameter.SYNOPT_C4_RSFEC.value"]
    set family          [ip_get "parameter.DEVICE_FAMILY.value"]
    set PHY_REFCLK      [ip_get "parameter.PHY_REFCLK.value"]

    # Pll clock speed
                if {$PHY_REFCLK == 1} {
        set freq_int 644
        set freq_float 644.53125
                } else {
        set freq_int 322
        set freq_float 322.265625
                }

    # Determine PLL instance name
    if {$IS_100G == 1} {
        if {$IS_CAUI4} {
            if {$IS_C4_FEC} {
                set tx_fabric_pll caui4_txrs_pll_${freq_int}
                } else {
                set tx_fabric_pll caui4_tx_pll_${freq_int}
                }
            } else  {
            set tx_fabric_pll e100_tx_pll_${freq_int}
        }
                } else {
        set tx_fabric_pll e40_tx_pll_${freq_int}
                }

    # Determine PLL Type
    if {$family == "Stratix V"} {
        set pll_type altera_pll
        } else {
        if {$IS_C4_FEC} {
            set pll_type altera_xcvr_fpll_a10
            } else {
            set pll_type altera_iopll
            }
        }

    # Instantiate PLL
    add_hdl_instance $tx_fabric_pll $pll_type

        # Generic PLL name is different for A10, and it does not take a device family
        # RS-FEC also needs 312.5 MHz, so need fPLL instead

    set_instance_parameter_value $tx_fabric_pll gui_reference_clock_frequency ${freq_float}

        if {$family == "Stratix V"} {
            set_instance_parameter_value $tx_fabric_pll device_family $family
    } else {
        if {!$IS_C4_FEC} {
            set_instance_parameter_value $tx_fabric_pll system_info_device_family $family
            set_instance_parameter_value $tx_fabric_pll gui_clock_name_string0 "tx_core_clk"
        } else {
            set_instance_parameter_value $tx_fabric_pll base_device [get_parameter_value "part_trait_bd"]
            set_instance_parameter_value $tx_fabric_pll gui_number_of_output_clocks "2"
            set_instance_parameter_value $tx_fabric_pll gui_enable_fractional "true"
            set_instance_parameter_value $tx_fabric_pll gui_bw_sel  "medium"
            set_instance_parameter_value $tx_fabric_pll gui_fpll_mode "0"
        }
    }

    if {$IS_100G} {
        if {$IS_C4_FEC} {
            set_instance_parameter_value $tx_fabric_pll gui_desired_outclk0_frequency "390.625"
            set_instance_parameter_value $tx_fabric_pll gui_desired_outclk1_frequency "312.5"
        } else {
            set_instance_parameter_value $tx_fabric_pll gui_number_of_clocks "2"
            set_instance_parameter_value $tx_fabric_pll gui_output_clock_frequency0 "390.625"
            set_instance_parameter_value $tx_fabric_pll gui_output_clock_frequency1 "390.625"
        }
        } else {
            set_instance_parameter_value $tx_fabric_pll gui_number_of_clocks "2"
            set_instance_parameter_value $tx_fabric_pll gui_output_clock_frequency0 "312.5"
            set_instance_parameter_value $tx_fabric_pll gui_output_clock_frequency1 "312.5"
        }
}



#
#if {$IS_100G} {
#    if {$family == "Stratix V"} {
#        add_hdl_instance                $rx_fabric_pll altera_pll
#    } elseif {$family == "Arria 10"} {
#        if {$IS_CAUI4} {
#            if {$IS_C4_FEC} {
#                add_hdl_instance             $caui4_rx_fpll_inst altera_xcvr_fpll_a10
#            }
#        } else {
#            add_hdl_instance $rx_fabric_pll altera_iopll
#        }
#    }
#} else {
#    if {$family == "Stratix V"} {
#        add_hdl_instance $rx_fabric_pll altera_pll
#    } elseif {$family == "Arria 10"} {
#        if {$ENA_KR4} {
#            add_hdl_instance $rx_fabric_pll altera_iopll
#        }
#        add_hdl_instance $rx_fabric_pll altera_iopll
#    }
#}

proc ::alt_eth_ultra::fileset::add_kr4_iopll { } {
    set family    [ip_get "parameter.DEVICE_FAMILY.value"]

    # RX-PLL
    # Generic PLL name is different for A10, and it does not take a device family
    set rx_fabric_pll e40_rx_pll_kr4
    add_hdl_instance $rx_fabric_pll altera_iopll
    set_instance_parameter_value $rx_fabric_pll system_info_device_family $family
    # Set blank clock name to force old behavior (MJA 6/23/2015)
    set_instance_parameter_value $rx_fabric_pll gui_clock_name_string0 "rx_core_clk_kr4"
    set_instance_parameter_value $rx_fabric_pll gui_reference_clock_frequency "156.25"
    set_instance_parameter_value $rx_fabric_pll gui_number_of_clocks "2"
    set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "312.5"
    set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "312.5"

    # Force PLL into low PFC and high bandwidth for CDR cascade
    set_instance_parameter_value $rx_fabric_pll gui_en_adv_params "true"
    set_instance_parameter_value $rx_fabric_pll gui_divide_factor_n "4"
    set_instance_parameter_value $rx_fabric_pll gui_multiply_factor "16"
    set_instance_parameter_value $rx_fabric_pll gui_divide_factor_c0 "2"
    set_instance_parameter_value $rx_fabric_pll gui_divide_factor_c1 "2"
    set_instance_parameter_value $rx_fabric_pll gui_pll_bandwidth_preset "High"
}

proc ::alt_eth_ultra::fileset::add_rx_fabric_pll { } {
    set IS_100G   [ip_get "parameter.IS_100G.value"]
    set IS_CAUI4  [ip_get "parameter.SYNOPT_CAUI4.value"]
    set IS_C4_FEC [ip_get "parameter.SYNOPT_C4_RSFEC.value"]
    set family    [ip_get "parameter.DEVICE_FAMILY.value"]
    set ENA_KR4  [ip_get "parameter.ENA_KR4.value"]

    if {$ENA_KR4} {
        ::alt_eth_ultra::fileset::add_kr4_iopll
    }

    if {$IS_100G} {
        if {$family == "Stratix V"} {
            # RX-PLL
            # Generic PLL name is different for A10, and it does not take a device family
            # altera_pll for SV
            set rx_fabric_pll e100_rx_pll
            add_hdl_instance                $rx_fabric_pll altera_pll
            set_instance_parameter_value    $rx_fabric_pll device_family $family
            set_instance_parameter_value    $rx_fabric_pll gui_reference_clock_frequency "322.265625"
            set_instance_parameter_value    $rx_fabric_pll gui_number_of_clocks "2"
            if {$IS_100G} {
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "390.625"
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "390.625"
            } else {
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "312.5"
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "312.5"
            }
        } elseif {$family == "Arria 10"} {
            if {$IS_CAUI4} {
                if {$IS_C4_FEC} {
                    # Generic PLL name is different for A10, and it does not take a device family
                    # RS-FEC also needs 312.5 MHz, so need fPLL instead
                    set caui4_rx_fpll_inst caui4_rxrs_fpll
                    add_hdl_instance             $caui4_rx_fpll_inst altera_xcvr_fpll_a10

                    set_instance_parameter_value $caui4_rx_fpll_inst base_device [get_parameter_value "part_trait_bd"]
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_bw_sel "low"
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_reference_clock_frequency "390.625"
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_fpll_mode "0"
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_number_of_output_clocks "1"
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_desired_outclk0_frequency "312.5"
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_enable_fractional "false"
                    set_instance_parameter_value $caui4_rx_fpll_inst enable_pll_reconfig "1"

                    # Force fPLL to recommended low PFD and low BW due to CDR cascade
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_enable_manual_config "true"
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_pll_m_counter "80"
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_pll_n_counter "10"
                    set_instance_parameter_value $caui4_rx_fpll_inst gui_pll_c_counter_0 "5"

                }
            } else {
                # RX-PLL
                # Generic PLL name is different for A10, and it does not take a device family
                set rx_fabric_pll e100_rx_pll
                add_hdl_instance $rx_fabric_pll altera_iopll
                set_instance_parameter_value $rx_fabric_pll system_info_device_family $family
                set_instance_parameter_value $rx_fabric_pll gui_clock_name_string0 "rx_core_clk"
                set_instance_parameter_value $rx_fabric_pll gui_reference_clock_frequency "322.265625"
                set_instance_parameter_value $rx_fabric_pll gui_number_of_clocks "2"
                set_instance_parameter_value $rx_fabric_pll gui_pll_bandwidth_preset "High"
                if {$IS_100G} {
                    set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "390.625"
                    set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "390.625"
                } else {
                    set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "312.5"
                    set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "312.5"
                }
            }
        }
    } else {
        if {$family == "Stratix V"} {
            # RX-PLL
            # Generic PLL name is different for A10, and it does not take a device family
            # altera_pll for SV
            set rx_fabric_pll e40_rx_pll
            add_hdl_instance $rx_fabric_pll altera_pll
            set_instance_parameter_value $rx_fabric_pll device_family $family
            set_instance_parameter_value $rx_fabric_pll gui_reference_clock_frequency "257.8125"
            set_instance_parameter_value $rx_fabric_pll gui_number_of_clocks "2"
            if {$IS_100G} {
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "390.625"
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "390.625"
            } else {
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "312.5"
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "312.5"
            }
        } elseif {$family == "Arria 10"} {

            # RX-PLL
            # Generic PLL name is different for A10, and it does not take a device family
            set rx_fabric_pll e40_rx_pll
            add_hdl_instance $rx_fabric_pll altera_iopll
            set_instance_parameter_value $rx_fabric_pll system_info_device_family $family
            # Set blank clock name to force old behavior (MJA 6/23/2015)
            set_instance_parameter_value $rx_fabric_pll gui_clock_name_string0 "rx_core_clk"

            set_instance_parameter_value $rx_fabric_pll gui_reference_clock_frequency "257.8125"
            set_instance_parameter_value $rx_fabric_pll gui_number_of_clocks "2"
            set_instance_parameter_value $rx_fabric_pll gui_pll_bandwidth_preset "High"
            if {$IS_100G} {
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "390.625"
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "390.625"
            } else {
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency0 "312.5"
                set_instance_parameter_value $rx_fabric_pll gui_output_clock_frequency1 "312.5"
            }
        }
    }
}

proc ::alt_eth_ultra::fileset::add_atx_pll { } {
    set IS_100G   [ip_get "parameter.IS_100G.value"]
    set IS_CAUI4  [ip_get "parameter.SYNOPT_CAUI4.value"]
    set family    [ip_get "parameter.DEVICE_FAMILY.value"]
    set PHY_REFCLK  [ip_get "parameter.PHY_REFCLK.value"]

    if {$family == "Arria 10"} {
        set pll_inst arria10_atx_pll
        add_hdl_instance    $pll_inst altera_xcvr_atx_pll_a10
        set_instance_parameter_value $pll_inst base_device [get_parameter_value "part_trait_bd"]
        set_instance_parameter_value $pll_inst enable_8G_path "0"

        if {$PHY_REFCLK == 1} {
            set_instance_parameter_value $pll_inst set_auto_reference_clock_frequency "644.53125"
        } else {
            set_instance_parameter_value $pll_inst set_auto_reference_clock_frequency "322.265625"
        }

        if {$IS_100G} {
            if {$IS_CAUI4} {
                set_instance_parameter_value $pll_inst primary_pll_buffer "GT clock output buffer"
                set_instance_parameter_value $pll_inst enable_16G_path "1"
                set_instance_parameter_value $pll_inst set_output_clock_frequency "12890.625"
            } else {
                set_instance_parameter_value $pll_inst enable_16G_path "0"
                set_instance_parameter_value $pll_inst set_output_clock_frequency "5156.25"
                set_instance_parameter_value $pll_inst enable_mcgb "1"
                set_instance_parameter_value $pll_inst enable_hfreq_clk "1"
            }
        } else {
            set_instance_parameter_value $pll_inst enable_16G_path "0"
            set_instance_parameter_value $pll_inst set_output_clock_frequency "5156.25"
            set_instance_parameter_value $pll_inst enable_mcgb "1"
            set_instance_parameter_value $pll_inst enable_hfreq_clk "1"
        }
    }
}

proc ::alt_eth_ultra::fileset::add_plls { } {
    set EXT_TX_PLL  [ip_get "parameter.EXT_TX_PLL.value"]

    if {!$EXT_TX_PLL} {
        ::alt_eth_ultra::fileset::add_tx_fabric_pll
    }
    ::alt_eth_ultra::fileset::add_rx_fabric_pll
    ::alt_eth_ultra::fileset::add_atx_pll
}

proc ::alt_eth_ultra::fileset::add_xcvr { } {
    set IS_100G   [ip_get "parameter.IS_100G.value"]
    set IS_CAUI4  [ip_get "parameter.SYNOPT_CAUI4.value"]
    set IS_C4_FEC [ip_get "parameter.SYNOPT_C4_RSFEC.value"]
    set family    [ip_get "parameter.DEVICE_FAMILY.value"]
    set PHY_REFCLK  [ip_get "parameter.PHY_REFCLK.value"]
    set ENA_KR4  [ip_get "parameter.ENA_KR4.value"]
    set SYNTH_FEC  [ip_get "parameter.SYNTH_FEC.value"]
    set SYNTH_LT [ip_get "parameter.SYNTH_LT.value"]
    set USE_DEBUG_CPU [ip_get "parameter.USE_DEBUG_CPU.value"]
    set ES_DEVICE       [ip_get "parameter.ES_DEVICE.value"]
    set ADME_ENABLE     [ip_get "parameter.ADME_ENABLE.value"]
    set ODI_ENABLE      [ip_get "parameter.ODI_ENABLE_effective.value"]

      set prod_cpu_ip kr4a10_cpu_gen2
      set debg_cpu_ip kr4a10_debug_cpu_gen2

    if {$IS_100G} {
        if {$family == "Stratix V"} {
            set e100_pma_inst s5xcvr_ref
            add_hdl_instance             $e100_pma_inst altera_xcvr_native_sv

            set_instance_parameter_value $e100_pma_inst device_family "Stratix V"
            set_instance_parameter_value $e100_pma_inst channels "10"
            set_instance_parameter_value $e100_pma_inst enable_simple_interface "1"
            set_instance_parameter_value $e100_pma_inst set_data_rate "10312.5"
            set_instance_parameter_value $e100_pma_inst gui_pll_reconfig_pll0_pll_type "ATX"
            if {$PHY_REFCLK == 1} {
                set_instance_parameter_value $e100_pma_inst gui_pll_reconfig_pll0_refclk_freq "644.53125 MHz"
                set_instance_parameter_value $e100_pma_inst set_cdr_refclk_freq "644.53125 MHz"
            } else {
                set_instance_parameter_value $e100_pma_inst gui_pll_reconfig_pll0_refclk_freq "322.265625 MHz"
                set_instance_parameter_value $e100_pma_inst set_cdr_refclk_freq "322.265625 MHz"
            }
            set_instance_parameter_value $e100_pma_inst enable_port_rx_seriallpbken "1"
            set_instance_parameter_value $e100_pma_inst enable_port_tx_10g_fifo_full "1"
            set_instance_parameter_value $e100_pma_inst enable_port_tx_10g_fifo_pfull "1"
            set_instance_parameter_value $e100_pma_inst enable_port_tx_10g_fifo_empty "1"
            set_instance_parameter_value $e100_pma_inst enable_port_tx_10g_fifo_pempty "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_data_valid "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_fifo_full "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_fifo_pfull "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_fifo_empty "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_fifo_pempty "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_fifo_rd_en "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_fifo_align_clr "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_clk33out "1"
            set_instance_parameter_value $e100_pma_inst teng_rx_bitslip_enable "1"
            set_instance_parameter_value $e100_pma_inst enable_port_rx_10g_bitslip "1"
            set_instance_parameter_value $e100_pma_inst teng_pcs_pma_width "32"
            set_instance_parameter_value $e100_pma_inst teng_pld_pcs_width "32"
            set_instance_parameter_value $e100_pma_inst enable_teng "1"

            # Set up the xcvr reconfig controller for 100g

            set e100_reco_inst reco
            add_hdl_instance             $e100_reco_inst alt_xcvr_reconfig
            set_instance_parameter_value $e100_reco_inst device_family "Stratix V"
            set_instance_parameter_value $e100_reco_inst number_of_reconfig_interfaces 20
        } elseif {$family == "Arria 10"} {
            if {$IS_CAUI4} {
                if {$PHY_REFCLK == 1} {
                    set e100_caui4_pma_inst caui4_xcvr_644
                } else {
                    set e100_caui4_pma_inst caui4_xcvr_322
                }
                add_hdl_instance             $e100_caui4_pma_inst altera_xcvr_native_a10

                set_instance_parameter_value $e100_caui4_pma_inst anlg_voltage "1_1V"
                set_instance_parameter_value $e100_caui4_pma_inst enable_port_rx_pma_div_clkout "1"
                set_instance_parameter_value $e100_caui4_pma_inst rx_pma_div_clkout_divider "33"
                set_instance_parameter_value $e100_caui4_pma_inst base_device [get_parameter_value "part_trait_bd"]
                set_instance_parameter_value $e100_caui4_pma_inst device_family "Arria 10"
                set_instance_parameter_value $e100_caui4_pma_inst protocol_mode "basic_enh"
                set_instance_parameter_value $e100_caui4_pma_inst channels "4"
                set_instance_parameter_value $e100_caui4_pma_inst set_data_rate "25781.25"
                set_instance_parameter_value $e100_caui4_pma_inst enable_simple_interface "1"
                set_instance_parameter_value $e100_caui4_pma_inst enable_port_tx_pma_clkout "1"
                set_instance_parameter_value $e100_caui4_pma_inst enable_port_rx_pma_iqtxrx_clkout "1"
                set_instance_parameter_value $e100_caui4_pma_inst enable_port_rx_seriallpbken "1"

                if {$ADME_ENABLE == 1} {
                    set_instance_parameter_value $e100_caui4_pma_inst set_embedded_debug_enable "1"
                    set_instance_parameter_value $e100_caui4_pma_inst set_capability_reg_enable "1"
                    set_instance_parameter_value $e100_caui4_pma_inst rcfg_jtag_enable "1"
                    set_instance_parameter_value $e100_caui4_pma_inst set_csr_soft_logic_enable "1"
                    set_instance_parameter_value $e100_caui4_pma_inst set_prbs_soft_logic_enable "1"
                }
	        if {$ODI_ENABLE == 1} {
                    set_instance_parameter_value $e100_caui4_pma_inst dbg_odi_soft_logic_enable "1"
                    set_instance_parameter_value $e100_caui4_pma_inst dbg_embedded_debug_enable "1"
                    set_instance_parameter_value $e100_caui4_pma_inst set_odi_soft_logic_enable "1"
                }

                if {$PHY_REFCLK == 1} {
                    set_instance_parameter_value $e100_caui4_pma_inst set_cdr_refclk_freq "644.531250"
                } else {
                    set_instance_parameter_value $e100_caui4_pma_inst set_cdr_refclk_freq "322.265625"
                }

                set_instance_parameter_value $e100_caui4_pma_inst enable_port_rx_pma_clkout  "1"
                set_instance_parameter_value $e100_caui4_pma_inst enable_port_rx_enh_bitslip "1"
                if {$IS_C4_FEC} {
                    set_instance_parameter_value $e100_caui4_pma_inst enh_rx_bitslip_enable "1"
                }
                set_instance_parameter_value $e100_caui4_pma_inst enh_pcs_pma_width "64"
                set_instance_parameter_value $e100_caui4_pma_inst enh_pld_pcs_width "64"
                set_instance_parameter_value $e100_caui4_pma_inst enh_txfifo_mode "Fast register"
                set_instance_parameter_value $e100_caui4_pma_inst enh_rxfifo_mode "Register"
                set_instance_parameter_value $e100_caui4_pma_inst rcfg_enable "1"
                set_instance_parameter_value $e100_caui4_pma_inst rcfg_shared "1"
                set_instance_parameter_value $e100_caui4_pma_inst rx_pma_dfe_fixed_taps "7"
                } else {
                if {$PHY_REFCLK == 1} {
                    set e100_pma_inst gx_a10_100g_644
                } else {
                    set e100_pma_inst gx_a10_100g_322
                }
                add_hdl_instance             $e100_pma_inst altera_xcvr_native_a10

                set_instance_parameter_value $e100_pma_inst base_device [get_parameter_value "part_trait_bd"]
                set_instance_parameter_value $e100_pma_inst device_family "Arria 10"
                set_instance_parameter_value $e100_pma_inst protocol_mode "basic_enh"
                set_instance_parameter_value $e100_pma_inst channels "10"
                set_instance_parameter_value $e100_pma_inst set_data_rate "10312.5"
                set_instance_parameter_value $e100_pma_inst enable_simple_interface "1"
                if {$PHY_REFCLK == 1} {
                    set_instance_parameter_value $e100_pma_inst set_cdr_refclk_freq "644.531250"
                } else {
                    set_instance_parameter_value $e100_pma_inst set_cdr_refclk_freq "322.265625"
                }
                set_instance_parameter_value $e100_pma_inst enable_ports_rx_manual_cdr_mode "1"
                set_instance_parameter_value $e100_pma_inst enable_port_rx_seriallpbken "1"
                set_instance_parameter_value $e100_pma_inst enh_pcs_pma_width "32"
                set_instance_parameter_value $e100_pma_inst enh_pld_pcs_width "32"

                set_instance_parameter_value $e100_pma_inst enh_txfifo_mode "Basic"
                set_instance_parameter_value $e100_pma_inst enh_txfifo_pfull "13"
                set_instance_parameter_value $e100_pma_inst enh_txfifo_pempty "5"

                set_instance_parameter_value $e100_pma_inst enable_port_tx_enh_fifo_full "1"
                set_instance_parameter_value $e100_pma_inst enable_port_tx_enh_fifo_pfull "1"
                set_instance_parameter_value $e100_pma_inst enable_port_tx_enh_fifo_empty "1"
                set_instance_parameter_value $e100_pma_inst enable_port_tx_enh_fifo_pempty "1"

                set_instance_parameter_value $e100_pma_inst enh_rxfifo_mode "Basic"
                set_instance_parameter_value $e100_pma_inst enh_rxfifo_pempty "7"

                set_instance_parameter_value $e100_pma_inst enable_port_rx_enh_data_valid "1"
                set_instance_parameter_value $e100_pma_inst enable_port_rx_enh_fifo_full "1"
                set_instance_parameter_value $e100_pma_inst enable_port_rx_enh_fifo_pfull "1"
                set_instance_parameter_value $e100_pma_inst enable_port_rx_enh_fifo_empty "1"
                set_instance_parameter_value $e100_pma_inst enable_port_rx_enh_fifo_pempty "1"
                set_instance_parameter_value $e100_pma_inst enable_port_rx_enh_fifo_rd_en "1"
                set_instance_parameter_value $e100_pma_inst enable_port_rx_enh_fifo_align_clr "1"
                set_instance_parameter_value $e100_pma_inst enh_rx_bitslip_enable "1"
                set_instance_parameter_value $e100_pma_inst enable_port_rx_enh_bitslip "1"
                set_instance_parameter_value $e100_pma_inst rcfg_enable "1"
                set_instance_parameter_value $e100_pma_inst rcfg_shared "1"

                if {$ADME_ENABLE== 1} {
                    set_instance_parameter_value $e100_pma_inst set_embedded_debug_enable "1"
                    set_instance_parameter_value $e100_pma_inst set_capability_reg_enable "1"
                    set_instance_parameter_value $e100_pma_inst rcfg_jtag_enable "1"
                    set_instance_parameter_value $e100_pma_inst set_csr_soft_logic_enable "1"
                    set_instance_parameter_value $e100_pma_inst set_prbs_soft_logic_enable "1"
                }
                if {$ODI_ENABLE == 1} {
                    set_instance_parameter_value $e100_pma_inst dbg_odi_soft_logic_enable "1"
                    set_instance_parameter_value $e100_pma_inst dbg_embedded_debug_enable "1"
                    set_instance_parameter_value $e100_pma_inst set_odi_soft_logic_enable "1"

                }
                }
                }
    } else {
        if {$family == "Stratix V"} {
            set e40_pma_inst s5xcvr_ref
            add_hdl_instance             $e40_pma_inst altera_xcvr_native_sv
            set_instance_parameter_value $e40_pma_inst device_family "Stratix V"
            set_instance_parameter_value $e40_pma_inst channels "4"
            set_instance_parameter_value $e40_pma_inst enable_simple_interface "1"
            set_instance_parameter_value $e40_pma_inst set_data_rate "10312.5"
            set_instance_parameter_value $e40_pma_inst gui_pll_reconfig_pll0_pll_type "ATX"
            set_instance_parameter_value $e40_pma_inst gui_pll_reconfig_pll0_refclk_freq "644.53125 MHz"
            set_instance_parameter_value $e40_pma_inst set_cdr_refclk_freq "644.53125 MHz"
            if {$PHY_REFCLK == 1} {
                set_instance_parameter_value $e40_pma_inst gui_pll_reconfig_pll0_refclk_freq "644.53125 MHz"
                set_instance_parameter_value $e40_pma_inst set_cdr_refclk_freq "644.53125 MHz"
            } else {
                set_instance_parameter_value $e40_pma_inst gui_pll_reconfig_pll0_refclk_freq "322.265625 MHz"
                set_instance_parameter_value $e40_pma_inst set_cdr_refclk_freq "322.265625 MHz"
            }
            set_instance_parameter_value $e40_pma_inst enable_port_rx_seriallpbken "1"
            set_instance_parameter_value $e40_pma_inst enable_port_tx_10g_fifo_full "1"
            set_instance_parameter_value $e40_pma_inst enable_port_tx_10g_fifo_pfull "1"
            set_instance_parameter_value $e40_pma_inst enable_port_tx_10g_fifo_empty "1"
            set_instance_parameter_value $e40_pma_inst enable_port_tx_10g_fifo_pempty "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_data_valid "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_fifo_full "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_fifo_pfull "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_fifo_empty "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_fifo_pempty "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_fifo_rd_en "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_fifo_align_clr "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_clk33out "1"
            set_instance_parameter_value $e40_pma_inst teng_rx_bitslip_enable "1"
            set_instance_parameter_value $e40_pma_inst enable_port_rx_10g_bitslip "1"
            set_instance_parameter_value $e40_pma_inst teng_pcs_pma_width "40"
            set_instance_parameter_value $e40_pma_inst teng_pld_pcs_width "40"
            set_instance_parameter_value $e40_pma_inst enable_teng "1"

             # Set up the xcvr reconfig controller for 40g

            set e40_reco_inst e40_reco
            add_hdl_instance             $e40_reco_inst alt_xcvr_reconfig
            set_instance_parameter_value $e40_reco_inst device_family "Stratix V"
            set_instance_parameter_value $e40_reco_inst number_of_reconfig_interfaces 8
        } elseif {$family == "Arria 10"} {
            if {$ENA_KR4} {
                if {$PHY_REFCLK == 1 && !$SYNTH_FEC} {
                    set e40_pma_inst native_40g_644
                } elseif {$PHY_REFCLK == 2 && !$SYNTH_FEC} {
                    set e40_pma_inst native_40g_322
                } elseif {$PHY_REFCLK == 1 && $SYNTH_FEC} {
                    set e40_pma_inst native_40g_fec_644
                } elseif {$PHY_REFCLK == 2 && $SYNTH_FEC} {
                    set e40_pma_inst native_40g_fec_322
                }

                if {$ADME_ENABLE == 1} {
                    if {$PHY_REFCLK == 1 && !$SYNTH_FEC} {
                        set e40_pma_inst_type native_40ghp_644
                    } elseif {$PHY_REFCLK == 2 && !$SYNTH_FEC} {
                        set e40_pma_inst_type native_40ghp_322
                    } elseif {$PHY_REFCLK == 1 && $SYNTH_FEC} {
                        set e40_pma_inst_type native_40g_fechp_644
                    } elseif {$PHY_REFCLK == 2 && $SYNTH_FEC} {
                        set e40_pma_inst_type native_40g_fechp_322
                    }
                } else {
                    set e40_pma_inst_type $e40_pma_inst
                }

                if {$SYNTH_LT == 0} {
                    # if no link training, use non-adaptation xcvr
                    set e40_pma_inst_type ${e40_pma_inst_type}_ls
                }

                add_hdl_instance             $e40_pma_inst $e40_pma_inst_type
                set_instance_parameter_value $e40_pma_inst auto_device [get_parameter_value "DEVICE"]

                # this is the qsys NIOS
                if {$SYNTH_LT} {
                    set QROOT "$::env(QUARTUS_ROOTDIR)"
                    if {$ES_DEVICE} {
                        set es "_es"
                    } else {
                        set es ""
                    }

                    if {$USE_DEBUG_CPU} {
                        add_hdl_instance  kr4a10_debug_cpu  $debg_cpu_ip
                        set_instance_parameter_value kr4a10_debug_cpu imem_hex_path "$QROOT/../ip/altera/ethernet/alt_eth_ultra/40g_kr4_a10/cpu/kr4a10_debug_cpu_imem$es.hex"
                        set_instance_parameter_value kr4a10_debug_cpu dmem_hex_path "$QROOT/../ip/altera/ethernet/alt_eth_ultra/40g_kr4_a10/cpu/kr4a10_debug_cpu_dmem$es.hex"
                    } else {
                        add_hdl_instance  kr4a10_cpu  $prod_cpu_ip
                        set_instance_parameter_value kr4a10_cpu imem_hex_path "$QROOT/../ip/altera/ethernet/alt_eth_ultra/40g_kr4_a10/cpu/kr4a10_cpu_imem$es.hex"
                        set_instance_parameter_value kr4a10_cpu dmem_hex_path "$QROOT/../ip/altera/ethernet/alt_eth_ultra/40g_kr4_a10/cpu/kr4a10_cpu_dmem$es.hex"
                    }
                }
            } else {
                if {$PHY_REFCLK == 1} {
                    set e40_pma_inst gx_a10_40g_644
                } else {
                    set e40_pma_inst gx_a10_40g_322
                }

                add_hdl_instance             $e40_pma_inst altera_xcvr_native_a10

                set_instance_parameter_value $e40_pma_inst base_device [get_parameter_value "part_trait_bd"]
                set_instance_parameter_value $e40_pma_inst device_family "Arria 10"
                set_instance_parameter_value $e40_pma_inst protocol_mode "basic_enh"
                set_instance_parameter_value $e40_pma_inst channels "4"
                set_instance_parameter_value $e40_pma_inst set_data_rate "10312.5"
                set_instance_parameter_value $e40_pma_inst enable_simple_interface "1"
                if {$PHY_REFCLK == 1} {
                    set_instance_parameter_value $e40_pma_inst set_cdr_refclk_freq "644.531250"
                } else {
                    set_instance_parameter_value $e40_pma_inst set_cdr_refclk_freq "322.265625"
                }
                set_instance_parameter_value $e40_pma_inst enable_ports_rx_manual_cdr_mode "1"
                set_instance_parameter_value $e40_pma_inst enable_port_rx_seriallpbken "1"
                set_instance_parameter_value $e40_pma_inst enh_pcs_pma_width "40"
                set_instance_parameter_value $e40_pma_inst enh_pld_pcs_width "40"

                set_instance_parameter_value $e40_pma_inst enh_txfifo_mode "Basic"
                set_instance_parameter_value $e40_pma_inst enh_txfifo_pfull "13"
                set_instance_parameter_value $e40_pma_inst enh_txfifo_pempty "5"

                set_instance_parameter_value $e40_pma_inst enable_port_tx_enh_fifo_full "1"
                set_instance_parameter_value $e40_pma_inst enable_port_tx_enh_fifo_pfull "1"
                set_instance_parameter_value $e40_pma_inst enable_port_tx_enh_fifo_empty "1"
                set_instance_parameter_value $e40_pma_inst enable_port_tx_enh_fifo_pempty "1"

                set_instance_parameter_value $e40_pma_inst enh_rxfifo_mode "Basic"
                set_instance_parameter_value $e40_pma_inst enh_rxfifo_pempty "7"

                set_instance_parameter_value $e40_pma_inst enable_port_rx_enh_data_valid "1"
                set_instance_parameter_value $e40_pma_inst enable_port_rx_enh_fifo_full "1"
                set_instance_parameter_value $e40_pma_inst enable_port_rx_enh_fifo_pfull "1"
                set_instance_parameter_value $e40_pma_inst enable_port_rx_enh_fifo_empty "1"
                set_instance_parameter_value $e40_pma_inst enable_port_rx_enh_fifo_pempty "1"
                set_instance_parameter_value $e40_pma_inst enable_port_rx_enh_fifo_rd_en "1"
                set_instance_parameter_value $e40_pma_inst enable_port_rx_enh_fifo_align_clr "1"
                set_instance_parameter_value $e40_pma_inst enh_rx_bitslip_enable "1"
                set_instance_parameter_value $e40_pma_inst enable_port_rx_enh_bitslip "1"
                set_instance_parameter_value $e40_pma_inst rcfg_enable "1"
                set_instance_parameter_value $e40_pma_inst rcfg_shared "1"

                if {$ADME_ENABLE == 1} {
                    set_instance_parameter_value $e40_pma_inst set_embedded_debug_enable "1"
                    set_instance_parameter_value $e40_pma_inst set_capability_reg_enable "1"
                    set_instance_parameter_value $e40_pma_inst rcfg_jtag_enable "1"
                    set_instance_parameter_value $e40_pma_inst set_csr_soft_logic_enable "1"
                    set_instance_parameter_value $e40_pma_inst set_prbs_soft_logic_enable "1"
                }
                if {$ODI_ENABLE == 1} {
                    set_instance_parameter_value $e40_pma_inst dbg_odi_soft_logic_enable "1"
                    set_instance_parameter_value $e40_pma_inst dbg_embedded_debug_enable "1"
                    set_instance_parameter_value $e40_pma_inst set_odi_soft_logic_enable "1"
                }
            }
                }
            }
}

proc ::alt_eth_ultra::fileset::add_clkctrl { } {
    add_hdl_instance clkctrl altclkctrl
    set_instance_parameter_value clkctrl {CLOCK_TYPE} {1}
    set_instance_parameter_value clkctrl {NUMBER_OF_CLOCKS} {1}
    set_instance_parameter_value clkctrl {ENA_REGISTER_MODE} {1}
    set_instance_parameter_value clkctrl {GUI_USE_ENA} {0}
    set_instance_parameter_value clkctrl {USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION} {0}
    set_instance_parameter_value clkctrl device_family "Arria 10"
}

proc ::alt_eth_ultra::fileset::add_instances { } {
    set IS_100G   [ip_get "parameter.IS_100G.value"]
    set IS_CAUI4  [ip_get "parameter.SYNOPT_CAUI4.value"]
    set family    [ip_get "parameter.DEVICE_FAMILY.value"]

    ::alt_eth_ultra::fileset::add_plls
    ::alt_eth_ultra::fileset::add_xcvr

    if {$IS_100G} { set speed 100 } else { set speed 40 }
    set_fileset_property quartus_synth TOP_LEVEL alt_aeu_${speed}_top
    set_fileset_property sim_verilog   TOP_LEVEL alt_aeu_${speed}_top
    set_fileset_property sim_vhdl      TOP_LEVEL alt_aeu_${speed}_top

    if {($IS_100G) && ($family == "Arria 10") && ($IS_CAUI4)} {
        ::alt_eth_ultra::fileset::add_clkctrl
    }
}

# Example Design callback function
proc ::alt_eth_ultra::fileset::callback_exa_sel { entity } {
    set generate_testbench          [ip_get "parameter.GEN_SIMULATION.value"]
    set generate_synthesis_designs  [ip_get "parameter.GEN_SYNTH.value"]

    ::alt_eth_ultra::fileset::generate_ip_core
    ::alt_eth_ultra::fileset::generate_compilation_test_design

    if {$generate_testbench} {
        ::alt_eth_ultra::fileset::generate_testbench
    }

    if {$generate_synthesis_designs} {
        ::alt_eth_ultra::fileset::generate_hardware_example_project
    }

    ::alt_eth_ultra::fileset::generate_parameters_files $generate_testbench $generate_synthesis_designs
}

# This function generates the Ultra ethernet IP core
proc ::alt_eth_ultra::fileset::generate_ip_core {} {
    set DEVICE_FAMILY   [ip_get "parameter.DEVICE_FAMILY.value"]
    set DEVICE          [::alt_eth_ultra::fileset::get_board_safe_part]
    set ip_type [ip_get "module.NAME.value"]

    if {$DEVICE_FAMILY == "Stratix V"} {
        # Not used for Stratix V
    } else {
        set IS_100G       [ip_get "parameter.IS_100G.value"]
        set IS_NOT_CAUI4  [ip_get "parameter.NOT_CAUI4.value"]

        if {$IS_100G == 1} {
            if {$IS_NOT_CAUI4 == 1} {
                set variant "ex_100g"
            } else {
                set variant "ex_100g_caui4"
            }
        } else {
            set variant "ex_40g"
        }

        set templocation [create_temp_file "dummy.file"]
        set tempdir [file dirname $templocation]

        # Get a list of parameter value pairs. Ex: {ADME_ENABLE=1 PREAMBLE_PASS=0 ... }
        set parameters [::ethernet::tools::generate_parameter_value_pairs [get_parameters]]

        # Use parameter list to generate copy of IP
        ::ethernet::tools::generate_ip_core $ip_type $variant "Arria 10" $DEVICE $tempdir true $parameters

        if {[::ethernet::tools::is_pro]} {
            add_fileset_file "./${variant}.ip"     OTHER PATH [file join ${tempdir} "${variant}.ip"]
        } else {
            add_fileset_file "./${variant}.qsys"     OTHER PATH [file join ${tempdir} "${variant}.qsys"]
        }

        # add_fileset_file "./${variant}.sopcinfo" OTHER PATH [file join ${tempdir} "${variant}.sopcinfo"]

        set src [file join $tempdir $variant]
        set dst [file join "." $variant]
        ::ethernet::tools::copy_folder_abs $src $dst
    }
}

proc ::alt_eth_ultra::fileset::generate_probes { dst } {
    set family [ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_eth_ultra::fileset::get_board_safe_part]

    set ip altera_in_system_sources_probes
    set inst probe8

    lappend parameters "probe_width=8"
    lappend parameters "source_initial_value=0"
    lappend parameters "source_width=1"

    set templocation [create_temp_file "dummy.file"]
    set tempdir [file dirname $templocation]

    if {[::ethernet::tools::is_pro]} {
        set src [file join ${tempdir} "${inst}.ip"]
        set qsys_dst [file join $dst "${inst}.ip"]
    } else {
        set src [file join ${tempdir} "${inst}.qsys"]
        set qsys_dst [file join $dst "${inst}.qsys"]
    }

    ::ethernet::tools::generate_ip_core $ip $inst $family $device $tempdir false $parameters
    add_fileset_file $qsys_dst OTHER PATH $src
}

proc ::alt_eth_ultra::fileset::generate_gpio { dst } {
    set family [ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_eth_ultra::fileset::get_board_safe_part]

    set ip altera_gpio
    set inst ed_synth

    lappend parameters "PIN_TYPE_GUI=Bidir"
    lappend parameters "SIZE=1"
    lappend parameters "gui_open_drain=true"

    set templocation [create_temp_file "dummy.file"]
    set tempdir [file dirname $templocation]

    if {[::ethernet::tools::is_pro]} {
        set src [file join ${tempdir} "${inst}.ip"]
        set qsys_dst [file join $dst "${inst}.ip"]
    } else {
        set src [file join ${tempdir} "${inst}.qsys"]
        set qsys_dst [file join $dst "${inst}.qsys"]
    }

    ::ethernet::tools::generate_ip_core $ip $inst $family $device $tempdir false $parameters
    add_fileset_file $qsys_dst OTHER PATH $src
}

proc ::alt_eth_ultra::fileset::generate_jtag_bridge { dst } {
    set family [ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_eth_ultra::fileset::get_board_safe_part]

    set ip altera_jtag_avalon_master
    set inst alt_aeuex_jtag_avalon

    set templocation [create_temp_file "dummy.file"]
    set tempdir [file dirname $templocation]

    if {[::ethernet::tools::is_pro]} {
        set src [file join ${tempdir} "${inst}.ip"]
        set qsys_dst [file join $dst "${inst}.ip"]
    } else {
        set src [file join ${tempdir} "${inst}.qsys"]
        set qsys_dst [file join $dst "${inst}.qsys"]
    }

    ::ethernet::tools::generate_ip_core $ip $inst $family $device $tempdir false
    add_fileset_file $qsys_dst OTHER PATH $src
}

proc ::alt_eth_ultra::fileset::generate_iopll { dst } {
    set family [ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_eth_ultra::fileset::get_board_safe_part]

    set ip altera_iopll
    set inst alt_aeuex_iopll_a10

    lappend parameters "gui_reference_clock_frequency=50.0"
    lappend parameters "gui_refclk1_frequency=100.0"
    lappend parameters "gui_use_locked=true"

    set templocation [create_temp_file "dummy.file"]
    set tempdir [file dirname $templocation]

    if {[::ethernet::tools::is_pro]} {
        set src [file join ${tempdir} "${inst}.ip"]
        set qsys_dst [file join $dst "${inst}.ip"]
    } else {
        set src [file join ${tempdir} "${inst}.qsys"]
        set qsys_dst [file join $dst "${inst}.qsys"]
    }

    ::ethernet::tools::generate_ip_core $ip $inst $family $device $tempdir false $parameters
    add_fileset_file $qsys_dst OTHER PATH $src
}

proc ::alt_eth_ultra::fileset::generate_tod { dst } {
    set family [ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_eth_ultra::fileset::get_board_safe_part]

    set ip altera_eth_1588_tod
    set inst tod

    lappend parameters "DEFAULT_FNSEC_ADJPERIOD=10492"
    lappend parameters "DEFAULT_FNSEC_PERIOD=10492"
    lappend parameters "DEFAULT_NSEC_ADJPERIOD=2"
    lappend parameters "DEFAULT_NSEC_PERIOD=2"

    set templocation [create_temp_file "dummy.file"]
    set tempdir [file dirname $templocation]

    if {[::ethernet::tools::is_pro]} {
        set src [file join ${tempdir} "${inst}.ip"]
        set qsys_dst [file join $dst "${inst}.ip"]
    } else {
        set src [file join ${tempdir} "${inst}.qsys"]
        set qsys_dst [file join $dst "${inst}.qsys"]
    }

    ::ethernet::tools::generate_ip_core $ip $inst $family $device $tempdir false $parameters
    add_fileset_file $qsys_dst OTHER PATH $src
}

proc ::alt_eth_ultra::fileset::generate_testbench {} {
    set DEVICE_FAMILY [ip_get "parameter.DEVICE_FAMILY.value"]
    set IS_100G       [ip_get "parameter.IS_100G.value"]
    set IS_NOT_CAUI4  [ip_get "parameter.NOT_CAUI4.value"]
    set ENA_KR4       [ip_get "parameter.ENA_KR4.value"]

    if {$DEVICE_FAMILY == "Stratix V"} {
        ##
        # Figure out the variant name the user specified
        ##
        # qmegawiz legacy generation puts temp files in a directory something like
        # $TEMP/alt6338_6053517240378772636.dir/0005_$variant_gen/
        set filelocation [create_temp_file ".tempfile"]
        regexp "^.*/" $filelocation filelocation
        regsub "/$" $filelocation "" filelocation
        regsub "^.*/" $filelocation "" filelocation
        regsub "^.*?_" $filelocation "" filelocation
        regexp "^.*_" $filelocation filelocation
        regsub "_$" $filelocation "" variant

        add_fileset_file "../example_testbench/run_vsim.do" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../../../${variant}_sim" "../example_testbench/run_vsim.do"]
        add_fileset_file "../example_testbench/run_vcs.sh" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../../../${variant}_sim" "../example_testbench/run_vcs.sh"]
        add_fileset_file "../example_testbench/run_ncsim.sh" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../../../${variant}_sim" "../example_testbench/run_ncsim.sh"]

        if {$IS_100G} {
            add_fileset_file "../example_testbench/basic_avl_tb_top.v" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/100g/basic_avl_tb_top.v"]
        } else {
            add_fileset_file "../example_testbench/basic_avl_tb_top.v" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/40g/basic_avl_tb_top.v"]
        }
    } else {
        if {$IS_100G == 1} {
            if {$IS_NOT_CAUI4 == 1} {
                set variant "ex_100g"
            } else {
                set variant "ex_100g_caui4"
            }
        } else {
            set variant "ex_40g"
        }

        if {$ENA_KR4 && !$IS_100G} {
            add_fileset_file "../example_testbench/run_vsim.do" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../${variant}/sim" "../example_testbench/40g_kr4_a10/run_vsim.do"]
            add_fileset_file "../example_testbench/run_vcs.sh" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../${variant}/sim" "../example_testbench/40g_kr4_a10/run_vcs.sh"]
            add_fileset_file "../example_testbench/run_ncsim.sh" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../${variant}/sim" "../example_testbench/40g_kr4_a10/run_ncsim.sh"]
        } else {
            add_fileset_file "../example_testbench/run_vsim.do" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../${variant}/sim" "../example_testbench/run_vsim.do"]
            add_fileset_file "../example_testbench/run_vcs.sh" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../${variant}/sim" "../example_testbench/run_vcs.sh"]
            add_fileset_file "../example_testbench/run_ncsim.sh" OTHER TEXT [::alt_eth_ultra::fileset::parse_name "../${variant}/sim" "../example_testbench/run_ncsim.sh"]
        }

        if {$IS_100G} {
            if {$IS_NOT_CAUI4} {
                add_fileset_file "../example_testbench/basic_avl_tb_top.v" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/100g/basic_avl_tb_top.v"]
            } else {
                add_fileset_file "../example_testbench/basic_avl_tb_top.v" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/100g_caui4/basic_avl_tb_top.v"]
            }
        } else {
            if {$ENA_KR4} {
                add_fileset_file "../example_testbench/alt_e40_avalon_kr4_tb.sv" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/40g_kr4_a10/alt_e40_avalon_kr4_tb.sv"]
                add_fileset_file "../example_testbench/alt_e40_avalon_tb_packet_gen.v" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/40g_kr4_a10/alt_e40_avalon_tb_packet_gen.v"]
                add_fileset_file "../example_testbench/alt_e40_avalon_tb_packet_gen_sanity_check.v" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/40g_kr4_a10/alt_e40_avalon_tb_packet_gen_sanity_check.v"]
                add_fileset_file "../example_testbench/alt_e40_stat_cntr_1port.v" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/40g_kr4_a10/alt_e40_stat_cntr_1port.v"]
            } else {
                add_fileset_file "../example_testbench/basic_avl_tb_top.v" VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_testbench/40g/basic_avl_tb_top.v"]
            }
        }
    }
}

# Hardware example design generation function
proc ::alt_eth_ultra::fileset::generate_hardware_example_project {} {
    set DEVICE_FAMILY [ip_get "parameter.DEVICE_FAMILY.value"]
    set SYNOPT_AVALON [ip_get "parameter.SYNOPT_AVALON.value"]
    set SYNOPT_PTP [ip_get "parameter.SYNOPT_PTP.value"]
    set IS_NOT_CAUI4  [ip_get "parameter.NOT_CAUI4.value"]
    set IS_100G       [ip_get "parameter.IS_100G.value"]
    set ENA_KR4       [ip_get "parameter.ENA_KR4.value"]
    set DEV_BOARD     [ip_get "parameter.DEV_BOARD.value"]
    set pin_assignment_file ""

    set qsys_dst [file join "hardware_test_design" "common"]
    ::alt_eth_ultra::fileset::generate_iopll        $qsys_dst
    ::alt_eth_ultra::fileset::generate_jtag_bridge  $qsys_dst
    ::alt_eth_ultra::fileset::generate_gpio         $qsys_dst
    ::alt_eth_ultra::fileset::generate_probes       $qsys_dst

    if {$SYNOPT_PTP} {
        ::alt_eth_ultra::fileset::generate_tod [file join $qsys_dst "tod"]
    }

    # Copy v, qpf, qsf, and sdc files
    if {$DEVICE_FAMILY == "Stratix V"} {
        ##
        # Figure out the variant name the user specified
        ##
        # qmegawiz legacy generation puts temp files in a directory something like
        # $TEMP/alt6338_6053517240378772636.dir/0005_$variant_gen/
        set filelocation [create_temp_file ".tempfile"]
        regexp "^.*/" $filelocation filelocation
        regsub "/$" $filelocation "" filelocation
        regsub "^.*/" $filelocation "" filelocation
        regsub "^.*?_" $filelocation "" filelocation
        regexp "^.*_" $filelocation filelocation
        regsub "_$" $filelocation "" variant

        if {$IS_100G} {
            # Add example project
            add_fileset_file "../hardware_test_design/SDCUtils.sdc"    SDC     PATH ../example_project/100g/SDCUtils.sdc
            #hardware design
            if {$SYNOPT_AVALON == 1} {
                add_fileset_file "../hardware_test_design/eth_ex_100g_sv.qpf" OTHER   PATH ../example_project/100g_sv/eth_ex_100g_sv.qpf
                add_fileset_file "../hardware_test_design/eth_ex_100g_sv.v"   VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_project/100g_sv/eth_ex_100g_sv.v"]
                if {$DEV_BOARD != 0} {set pin_assignment_file "device_pin_setting_board_100G_5SGXEA7N2F45C2_CFP.qsf"}
                add_fileset_file "../hardware_test_design/eth_ex_100g_sv.qsf" OTHER   TEXT \
                    [::alt_eth_ultra::fileset::parse_name $variant "../example_project/100g_sv/eth_ex_100g_sv.qsf" $pin_assignment_file]
            }
        } else {
            add_fileset_file "../hardware_test_design/SDCUtils.sdc"   SDC     PATH ../example_project/40g/SDCUtils.sdc
            #hardware design
            if {$SYNOPT_AVALON == 1} {
                add_fileset_file "../hardware_test_design/eth_ex_40g_sv.qpf" OTHER   PATH ../example_project/40g_sv/eth_ex_40g_sv.qpf
                add_fileset_file "../hardware_test_design/eth_ex_40g_sv.v"   VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_project/40g_sv/eth_ex_40g_sv.v"]
                if {$DEV_BOARD != 0} {set pin_assignment_file "device_pin_setting_board_100G_5SGXEA7N2F45C2_CFP.qsf"}
                add_fileset_file "../hardware_test_design/eth_ex_40g_sv.qsf" OTHER   TEXT \
                    [::alt_eth_ultra::fileset::parse_name $variant "../example_project/40g_sv/eth_ex_40g_sv.qsf" $pin_assignment_file]
            }
        }
    } else {
        ::alt_eth_ultra::rtl_tools::generate_hardware_rtl
        ::alt_eth_ultra::qsf_tools::generate_hardware_qsf
        ::alt_eth_ultra::srf_tools::generate_hardware_srf
        ::alt_eth_ultra::sdc_tools::generate_hardware_sdc
            }

    # Copy common files
                if {$SYNOPT_AVALON == 1} {
        set folder_lst {"common"}
        foreach folder $folder_lst {
            set src [file join ".." "example_project" $folder]
            set dst [file join ".." "hardware_test_design"]
            ::alt_eth_ultra::fileset::copy_folder $src $dst recursive
        }
    }

    # Copy PTP related files
    if {$SYNOPT_PTP == 1} {
        set src [file join ".." "example_project" "tod"]
        set dst [file join ".." "hardware_test_design" "common"]
        ::alt_eth_ultra::fileset::copy_folder $src $dst
    }

    # Copy hardware test related files
    set src [file join ".." "example_project" "hwtest"]
    set dst [file join ".." "hardware_test_design"]
    ::alt_eth_ultra::fileset::copy_folder $src $dst recursive
}

# Recursively call add_fileset_file. Used to copy an
# entire directory
proc ::alt_eth_ultra::fileset::copy_folder {src dst {option ""}} {
    set dst_folder [file tail $src];
    set dst_path [file join $dst $dst_folder];
    set glob_path [file join $src "*"]
    set files [glob -nocomplain -tails -directory . -- $glob_path]

    foreach file $files {
        set is_dir  [ file isdirectory $file ]; # isfile test doesn't work
        if {$is_dir} {
            if { [string compare $option recursive] == 0 } {
                ::alt_eth_ultra::fileset::copy_folder $file $dst_path $option
            }
        } else {
            set dst_file_name [file tail $file];
            set dst_file_path [file join $dst_path $dst_file_name];
            add_fileset_file $dst_file_path OTHER PATH $file;
        }
    }
}

proc ::alt_eth_ultra::fileset::generate_compilation_test_design {} {
    set DEVICE_FAMILY [ip_get "parameter.DEVICE_FAMILY.value"]
    set SYNOPT_AVALON [ip_get "parameter.SYNOPT_AVALON.value"]
    set SYNOPT_PTP    [ip_get "parameter.SYNOPT_PTP.value"]
    set IS_NOT_CAUI4  [ip_get "parameter.NOT_CAUI4.value"]
    set IS_100G       [ip_get "parameter.IS_100G.value"]
    set ENA_KR4       [ip_get "parameter.ENA_KR4.value"]

    if {$DEVICE_FAMILY == "Stratix V"} {
        ##
        # Figure out the variant name the user specified
        ##
        # qmegawiz legacy generation puts temp files in a directory something like
        # $TEMP/alt6338_6053517240378772636.dir/0005_$variant_gen/
        set filelocation [create_temp_file ".tempfile"]
        regexp "^.*/" $filelocation filelocation
        regsub "/$" $filelocation "" filelocation
        regsub "^.*/" $filelocation "" filelocation
        regsub "^.*?_" $filelocation "" filelocation
        regexp "^.*_" $filelocation filelocation
        regsub "_$" $filelocation "" variant

        if {$IS_100G} {
            # Add example project
            add_fileset_file "../compilation_test_design/eth_100g_s5.qpf" OTHER   PATH ../example_project/100g/eth_100g_s5.qpf
            add_fileset_file "../compilation_test_design/eth_100g_s5.sdc" SDC     PATH ../example_project/100g/eth_100g_s5.sdc
            add_fileset_file "../compilation_test_design/eth_100g_s5.v"   VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_project/100g/eth_100g_s5.v"]
            add_fileset_file "../compilation_test_design/SDCUtils.sdc"    SDC     PATH ../example_project/100g/SDCUtils.sdc
            add_fileset_file "../compilation_test_design/eth_100g_s5.qsf" OTHER   TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_project/100g/eth_100g_s5.qsf"]
        } else {
            add_fileset_file "../compilation_test_design/eth_40g_s5.qpf" OTHER   PATH ../example_project/40g/eth_40g_s5.qpf
            add_fileset_file "../compilation_test_design/eth_40g_s5.sdc" SDC     PATH ../example_project/40g/eth_40g_s5.sdc
            add_fileset_file "../compilation_test_design/eth_40g_s5.v"   VERILOG TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_project/40g/eth_40g_s5.v"]
            add_fileset_file "../compilation_test_design/SDCUtils.sdc"   SDC     PATH ../example_project/40g/SDCUtils.sdc
            add_fileset_file "../compilation_test_design/eth_40g_s5.qsf" OTHER   TEXT [::alt_eth_ultra::fileset::parse_name $variant "../example_project/40g/eth_40g_s5.qsf"]
        }
    } else {
        # Variant specific settings
        if {$IS_100G} {
            set top_level_name eth_100g_a10
            set sdc_file ${top_level_name}.sdc
            if {$IS_NOT_CAUI4} {
                set src_dir "../example_project/100g"
            } else {
                set src_dir "../example_project/100g_caui4"
            }
        } else {
            set top_level_name eth_40g_a10
            set src_dir "../example_project/40g"
            if {$ENA_KR4} {
                set sdc_file eth_40g_kr4_a10.sdc
            } else {
                set sdc_file ${top_level_name}.sdc
            }
        }

        # Copy sdc, v files
        # add_fileset_file "../compilation_test_design/${top_level_name}.sdc" SDC     PATH ${src_dir}/${sdc_file}

        ::alt_eth_ultra::qsf_tools::generate_compilation_qsf
        ::alt_eth_ultra::srf_tools::generate_compilation_srf
        ::alt_eth_ultra::rtl_tools::generate_compilation_rtl
        ::alt_eth_ultra::sdc_tools::generate_compilation_sdc
    }

    # Copy common files
    if {$SYNOPT_AVALON == 1 && ($DEVICE_FAMILY == "Stratix V" || $IS_NOT_CAUI4 == 1)} {
        set folder_lst {"common" "common/alt_aeuex_sys_pll_sv_100"}
        foreach folder $folder_lst {
            set src [file join ".." "example_project" $folder]
            set dst [file join ".." "compilation_test_design"]
            ::alt_eth_ultra::fileset::copy_folder $src $dst
        }
    }

    # Copy PTP related files
    if {$SYNOPT_PTP == 1} {
        set src [file join ".." "example_project" "tod"]
        set dst [file join ".." "compilation_test_design" "common"]
        ::alt_eth_ultra::fileset::copy_folder $src $dst
    }
}

# If a board is specified, return the part it uses.
# Otherwise, return the device selected by user
proc ::alt_eth_ultra::fileset::get_board_safe_part { } {
    set IS_100G         [ip_get "parameter.IS_100G.value"]
    set IS_NOT_CAUI4    [ip_get "parameter.NOT_CAUI4.value"]
    set DEV_BOARD       [ip_get "parameter.DEV_BOARD.value"]
    set family          [ip_get "parameter.DEVICE_FAMILY.value"]
    set override_part   [ip_get "parameter.OVERRIDE_PART_NUM.value"]
    set DEVICE          [ip_get "parameter.DEVICE.value"]

    if {$override_part} {
        return $DEVICE
    } else {
        if {$DEV_BOARD == 2} {
            if {$family == "Stratix V"} {
                return 5SGXEA7N2F45C2
            } else {
                # Arria 10 GX SI dev kit
                if {!$IS_100G || $IS_NOT_CAUI4} {
                    # 10g xcvr variants
                    return 10AX115S3F45E2SGE3
                } else {
                    # 25g xcvr variants
                    return 10AT115S2F45E2SGE3
                }
            }
        } elseif {$DEV_BOARD == 1} {
            if {$family == "Stratix V"} {
                return 5SGXEA7N2F45C2
            } else {
                # Arria 10 GX SI dev kit
                if {!$IS_100G || $IS_NOT_CAUI4} {
                    # 10g xcvr variants
                    return 10AX115S3F45I2SG
                } else {
                    # 25g xcvr variants
                    return 10AT115S2F45E2SG
                }
            }
        } else {
            # Use device passed by qsys for the case that no board is selected
            return $DEVICE
        }
    }
}

proc ::alt_eth_ultra::fileset::generate_parameters_files { gen_sim gen_synth } {
    set DEVICE_FAMILY [ip_get "parameter.DEVICE_FAMILY.value"]
    set SYNOPT_AVALON [ip_get "parameter.SYNOPT_AVALON.value"]
    set SYNOPT_PTP [ip_get "parameter.SYNOPT_PTP.value"]
    set IS_C4_FEC  [ip_get "parameter.SYNOPT_C4_RSFEC.value"]
    set IS_NOT_CAUI4  [ip_get "parameter.NOT_CAUI4.value"]

    ##
    # Create the dynamic parameters file
    ##
    set file_buffer "// This is a dynamically generated parameter file for the 40g/100g example testbench and example design\n\n"
    set TARGET_CHIP [get_parameter_value TARGET_CHIP]
    if {$TARGET_CHIP == 2} {
        append file_buffer "`define STRATIX_V\n"
    } elseif {$TARGET_CHIP == 5} {
        append file_buffer "`define ARRIA_10\n"
    }
    set PHY_REFCLK [get_parameter_value PHY_REFCLK]
    if {$PHY_REFCLK == 1} {
        append file_buffer "`define REFCLK_644\n"
    } elseif {$PHY_REFCLK == 2} {
        append file_buffer "`define REFCLK_322\n"
    }
    set SYNOPT_AVALON [get_parameter_value SYNOPT_AVALON]
    if {$SYNOPT_AVALON == 1} {
        append file_buffer "`define AVALON_IF\n"
    } else {
        append file_buffer "`define CUSTOM_IF\n"
    }
    set SYNOPT_PTP [get_parameter_value SYNOPT_PTP]
    if {$SYNOPT_PTP == 1} {
        append file_buffer "`define SYNOPT_PTP\n"
    } else {
        append file_buffer "`define NO_SYNOPT_PTP\n"
    }
    set SYNOPT_96B_PTP [get_parameter_value SYNOPT_96B_PTP]
    if {$SYNOPT_96B_PTP == 1} {
        append file_buffer "`define SYNOPT_96B_PTP\n"
    }
    set SYNOPT_64B_PTP [get_parameter_value SYNOPT_64B_PTP]
    if {$SYNOPT_64B_PTP == 1} {
        append file_buffer "`define SYNOPT_64B_PTP\n"
    }
    if {$IS_C4_FEC == 1} {
        append file_buffer "`define SYNOPT_C4_RSFEC\n"
    } else {
        append file_buffer "`define NO_SYNOPT_C4_RSFEC\n"
    }
    set SYNOPT_PAUSE_TYPE [get_parameter_value SYNOPT_PAUSE_TYPE]
    if {$SYNOPT_PAUSE_TYPE == 0} {
        append file_buffer "`define NO_SYNOPT_PAUSE\n"
    } else {
        append file_buffer "`define SYNOPT_PAUSE\n"
        if {$SYNOPT_PAUSE_TYPE == 2} {
            append file_buffer "`define SYNOPT_PFC\n"
        }
        set FCBITS [get_parameter_value FCBITS]
        append file_buffer "`define FCBITS $FCBITS\n"
    }
    set SYNOPT_LINK_FAULT [get_parameter_value SYNOPT_LINK_FAULT]
    if {$SYNOPT_LINK_FAULT == 1} {
        append file_buffer "`define SYNOPT_LINK_FAULT\n"
    } else {
        append file_buffer "`define NO_SYNOPT_LINK_FAULT\n"
    }
    set EXT_TX_PLL [get_parameter_value EXT_TX_PLL]
    if {$EXT_TX_PLL == 1} {
        append file_buffer "`define EXT_TX_PLL\n"
    } else {
        append file_buffer "`define NO_EXT_TX_PLL\n"
    }
    set COMPATIBLE_PORTS [get_parameter_value COMPATIBLE_PORTS]
    if {$COMPATIBLE_PORTS == 1} {
        append file_buffer "`define COMPATIBLE_PORTS\n"
    }
    set SYNOPT_SYNC_E [get_parameter_value SYNOPT_SYNC_E]
    if {$SYNOPT_SYNC_E == 1} {
        append file_buffer "`define SYNOPT_SYNC_E\n"
    }

    set PTP_FP_WIDTH [get_parameter_value PTP_FP_WIDTH]
    append file_buffer "`define PTP_FP_WIDTH $PTP_FP_WIDTH\n"

    if {$gen_sim} {
        add_fileset_file "../example_testbench/dynamic_parameters.v" VERILOG TEXT $file_buffer
    }

    if {$gen_synth} {
        add_fileset_file "../hardware_test_design/dynamic_parameters.v" VERILOG TEXT $file_buffer
    }

    add_fileset_file "../compilation_test_design/dynamic_parameters.v" VERILOG TEXT $file_buffer
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
                if {[file ext $file] == ".v"} {
                    add_fileset_file "./[file tail $file]" VERILOG PATH $file
                } elseif {[file ext $file] == ".sv"} {
                    add_fileset_file "./[file tail $file]" SYSTEM_VERILOG PATH $file
                } elseif {[file ext $file] == ".mif"} {
                    add_fileset_file "./[file tail $file]" MIF PATH $file
                } elseif {[file ext $file] == ".hex"} {
                    add_fileset_file "./[file tail $file]" HEX PATH $file
                } elseif {[file ext $file] == ".vhd"} {
                    add_fileset_file "./[file tail $file]" VHDL PATH $file
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
        } elseif {[file ext $file] == ".vhd"} {
            if {$filetype == "quartus"} {
                add_fileset_file "./[file tail $file]" VHDL PATH $file
            } else {
                add_fileset_file "./$filetype/[file tail $file]" VHDL PATH $file $attr
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

proc ::alt_eth_ultra::fileset::local_qsysgenerate { filepath filename qsysname subdir} {
    set fh [open $filepath/$filename w]

    set qdir $::env(QUARTUS_ROOTDIR)
    set cmd "${qdir}/sopc_builder/bin/qsys-script"
    set cmd "${cmd} --script=${filepath}/${qsysname}.tcl\n"

    puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
    puts $fh "puts \$temp"

    set cmd "${qdir}/sopc_builder/bin/qsys-generate"
    set cmd "${cmd} ${filepath}/${qsysname}.qsys"
    set cmd "${cmd} --output-directory=${filepath}/${subdir}"
    set cmd "${cmd} --synthesis=VERILOG"
    set cmd "${cmd} --simulation=VERILOG"

    puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
    puts $fh "puts \$temp"

    close $fh
    set result [run_tclsh_script $filepath/$filename]
    puts "run_tclsh_script result:${result}"

    set fl [findFiles ${filepath}/${subdir}]
    foreach file $fl {
        set f_path [string map [list ${filepath} ""] $file]
        if {[file ext $file] == ".v"} {
            add_fileset_file "./$f_path" VERILOG PATH $file
        } elseif {[file ext $file] == ".sv"} {
            add_fileset_file "./$f_path" SYSTEM_VERILOG PATH $file
        } elseif {[file ext $file] == ".mif"} {
            add_fileset_file "./$f_path" MIF PATH $file
        } elseif {[file ext $file] == ".hex"} {
            add_fileset_file "./$f_path" HEX PATH $file
        } elseif {[file ext $file] == ".vhd"} {
            add_fileset_file "./$f_path" VHDL PATH $file
        } elseif {[file ext $file] == ".sdc"} {
            add_fileset_file "./$f_path" SDC PATH $file
        } else {
            add_fileset_file "./$f_path" OTHER PATH $file
        }
    }
}

proc ::alt_eth_ultra::fileset::parse_name {variant path {pin_file ""}} {
    set fp [open $path r]
    set file_buffer [read $fp]
    close $fp
    regsub -all "ENET_ENTITY_QMEGA_01312014" $file_buffer $variant file_buffer

    if { [string compare $pin_file ""] != 0 } {
        append file_buffer "\nsource common/${pin_file}\n"
    }

    return $file_buffer
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
            # if its a file append file location to list, ignore qsys files
            if {![regexp {.*\.qsys$} $file]} {
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


