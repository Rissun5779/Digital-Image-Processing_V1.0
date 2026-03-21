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


#
# altera_hmcc
#
#======================================

#======================================
#
# request TCL package from ACDS 14.1 and TERP for RTL generation
#
package require -exact qsys 14.1
package require altera_terp
#
#======================================

#======================================
#
# module altera_hmcc
#

send_message PROGRESS "Reading TCL"

set_module_property NAME "altera_hmcc"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property HIDE_FROM_QUARTUS true
set_module_property DISPLAY_NAME "Hybrid Memory Cube Controller"
set_module_property EDITABLE false
set_module_property GROUP "Memory Interfaces and Controllers"
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Altera Hybrid Memory Cube Controller"
set_module_property supported_device_families {{Arria 10}}
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_hmcc.pdf"
set_module_property HIDE_FROM_QSYS true

add_fileset synth QUARTUS_SYNTH synth_proc

set_module_property ELABORATION_CALLBACK elaborate
#set_module_property VALIDATION_CALLBACK validate_proc

#======================================
#
# display tabs
#
#

add_display_item "" "General" GROUP
add_display_item "" "Dynamic Reconfiguration" GROUP

#=======================================================
#
# Parameters 
#
#=======================================================


add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property DEVICE_FAMILY ALLOWED_RANGES {"Arria 10"}
set_parameter_property DEVICE_FAMILY DESCRIPTION "Supports Arria 10"
add_display_item "General" DEVICE_FAMILY parameter

add_parameter CHANNELS INTEGER 16
set_parameter_property CHANNELS DEFAULT_VALUE 16
set_parameter_property CHANNELS DISPLAY_NAME "Lanes"
set_parameter_property CHANNELS DESCRIPTION "Selects full width (16 channels)\
or half width (8 channels)."
set_parameter_property CHANNELS ALLOWED_RANGES {8 16}
set_parameter_property CHANNELS HDL_PARAMETER true
add_display_item "General" CHANNELS parameter

add_parameter DATA_RATE_GUI STRING "10"
set_parameter_property DATA_RATE_GUI DEFAULT_VALUE "10"
set_parameter_property DATA_RATE_GUI DISPLAY_NAME "Data rate"
set_parameter_property DATA_RATE_GUI DESCRIPTION "Selects the data rate on each lane."
set_parameter_property DATA_RATE_GUI ALLOWED_RANGES {"10" "12.5"}
#"15" stretch goal
set_parameter_property DATA_RATE_GUI UNITS GigabitsPerSecond
add_display_item "General" DATA_RATE_GUI parameter


add_parameter DATA_RATE STRING "10000 Mbps"
set_parameter_property DATA_RATE ALLOWED_RANGES {"10000 Mbps" "12500 Mbps"}
#"15000 Mbps" stretch goal
set_parameter_property DATA_RATE VISIBLE false
set_parameter_property DATA_RATE ENABLED false
set_parameter_property DATA_RATE HDL_PARAMETER true
set_parameter_property DATA_RATE DERIVED true


add_parameter CDR_REFCLK STRING "125"
set_parameter_property CDR_REFCLK DEFAULT_VALUE "125"
set_parameter_property CDR_REFCLK DISPLAY_NAME "CDR reference clock"
set_parameter_property CDR_REFCLK DESCRIPTION "Selects the input reference\
clock for the RX CDR PLL."
set_parameter_property CDR_REFCLK ALLOWED_RANGES {"125" "156.25" "166.67" "312.5" "390.625"}
set_parameter_property CDR_REFCLK UNITS Megahertz
add_display_item "General" CDR_REFCLK parameter

add_parameter RX_MAPPING STD_LOGIC_VECTOR 64'hFEDC_BA98_7654_3210
set_parameter_property RX_MAPPING DEFAULT_VALUE 64'hFEDC_BA98_7654_3210
set_parameter_property RX_MAPPING WIDTH 64
set_parameter_property RX_MAPPING DISPLAY_NAME "Rx mapping"
set_parameter_property RX_MAPPING DESCRIPTION "Selects the RX lane mapping.\
Use caution in modifying this parameter. Refer to the user guide."
set_parameter_property RX_MAPPING HDL_PARAMETER true
add_display_item "General" RX_MAPPING parameter


add_parameter TX_MAPPING STD_LOGIC_VECTOR 64'hFEDC_BA98_7654_3210
set_parameter_property TX_MAPPING DEFAULT_VALUE 64'hFEDC_BA98_7654_3210
set_parameter_property TX_MAPPING WIDTH 64
set_parameter_property TX_MAPPING DISPLAY_NAME "Tx mapping"
set_parameter_property TX_MAPPING DESCRIPTION "Selects the TX lane mapping.\
Use caution in modifying this parameter. Refer to the user guide."
set_parameter_property TX_MAPPING HDL_PARAMETER true
add_display_item "General" TX_MAPPING parameter


add_parameter ENABLE_ADME BOOLEAN 0
set_parameter_property ENABLE_ADME DEFAULT_VALUE 0
set_parameter_property ENABLE_ADME DISPLAY_NAME "Enable ADME and Optional Reconfiguration Logic"
set_parameter_property ENABLE_ADME DESCRIPTION "Please refer to the Transceiver PHY and ATX PLL User Guides for more information."
add_display_item "General" ENABLE_ADME parameter


add_parameter ENABLE_ECC_GUI BOOLEAN 0
set_parameter_property ENABLE_ECC_GUI DEFAULT_VALUE 0
set_parameter_property ENABLE_ECC_GUI DISPLAY_NAME "Enable M20K ECC support"
set_parameter_property ENABLE_ECC_GUI DESCRIPTION "Enables built-in ECC support on\
the M20K embedded block memory for single-error correction, double-adjacent-error\
correction, and triple-adjacent-error detection."
add_display_item "General" ENABLE_ECC_GUI parameter


add_parameter ENABLE_ECC STRING "FALSE"
set_parameter_property ENABLE_ECC ALLOWED_RANGES {"TRUE" "FALSE"}
set_parameter_property ENABLE_ECC VISIBLE false
set_parameter_property ENABLE_ECC ENABLED false
set_parameter_property ENABLE_ECC HDL_PARAMETER true
set_parameter_property ENABLE_ECC DERIVED true


# PHY is device-dependent starting 14.1
add_parameter part_trait_device string ""
set_parameter_property part_trait_device SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property part_trait_device SYSTEM_INFO_ARG  DEVICE
set_parameter_property part_trait_device VISIBLE false
set_parameter_property part_trait_device ENABLED false


add_parameter base_device string ""
set_parameter_property base_device SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property base_device SYSTEM_INFO_ARG BASE_DEVICE
set_parameter_property base_device VISIBLE false
set_parameter_property base_device ENABLED false


### To be cleaned up later. All internal parameters.
# add_parameter SIMULATION_SPEEDUP BOOLEAN 1
# set_parameter_property SIMULATION_SPEEDUP DISPLAY_NAME "SIMULATION SPEEDUP"
# set_parameter_property SIMULATION_SPEEDUP DEFAULT_VALUE 1
# set_parameter_property SIMULATION_SPEEDUP DISPLAY_HINT BOOLEAN
# set_parameter_property SIMULATION_SPEEDUP VISIBLE false
# set_parameter_property SIMULATION_SPEEDUP HDL_PARAMETER true
# add_display_item "General" SIMULATION_SPEEDUP parameter


# add_parameter ENABLE_SCRAM STRING "TRUE"
# set_parameter_property ENABLE_SCRAM DEFAULT_VALUE "TRUE"
# set_parameter_property ENABLE_SCRAM ALLOWED_RANGES {"TRUE" "FALSE"}
# set_parameter_property ENABLE_SCRAM DISPLAY_HINT ""
# set_parameter_property ENABLE_SCRAM VISIBLE false
# set_parameter_property ENABLE_SCRAM HDL_PARAMETER true
# add_display_item "General" ENABLE_SCRAM parameter

# add_parameter BYPASS_LINK_INIT BOOLEAN 0
# set_parameter_property BYPASS_LINK_INIT DISPLAY_NAME "Bypass Link Initialization"
# set_parameter_property BYPASS_LINK_INIT DEFAULT_VALUE 0
# set_parameter_property BYPASS_LINK_INIT DISPLAY_HINT BOOLEAN
# set_parameter_property BYPASS_LINK_INIT VISIBLE false
# set_parameter_property BYPASS_LINK_INIT HDL_PARAMETER true
# add_display_item "General" BYPASS_LINK_INIT parameter

# add_parameter RETRY_TIMEOUT_PERIOD INTEGER 5
# set_parameter_property RETRY_TIMEOUT_PERIOD DEFAULT_VALUE 5
# set_parameter_property RETRY_TIMEOUT_PERIOD DISPLAY_NAME "Retry Timeout Period"
# set_parameter_property RETRY_TIMEOUT_PERIOD ALLOWED_RANGES {5}
# set_parameter_property RETRY_TIMEOUT_PERIOD VISIBLE false
# set_parameter_property RETRY_TIMEOUT_PERIOD HDL_PARAMETER true
# set_parameter_property RETRY_TIMEOUT_PERIOD ENABLED false
# add_display_item "General" RETRY_TIMEOUT_PERIOD parameter


# add_parameter RETRY_LIMIT INTEGER 3
# set_parameter_property RETRY_LIMIT DEFAULT_VALUE 3
# set_parameter_property RETRY_LIMIT DISPLAY_NAME "Retry Limit"
# set_parameter_property RETRY_LIMIT ALLOWED_RANGES {3}
# set_parameter_property RETRY_LIMIT VISIBLE false
# set_parameter_property RETRY_LIMIT HDL_PARAMETER true
# set_parameter_property RETRY_LIMIT ENABLED false
# add_display_item "General" RETRY_LIMIT parameter

# add_parameter IRTRY_INSERT_COUNT INTEGER 8
# set_parameter_property IRTRY_INSERT_COUNT DEFAULT_VALUE 8
# set_parameter_property IRTRY_INSERT_COUNT DISPLAY_NAME "Retry Insert Count"
# set_parameter_property IRTRY_INSERT_COUNT ALLOWED_RANGES {8}
# set_parameter_property IRTRY_INSERT_COUNT VISIBLE false
# set_parameter_property IRTRY_INSERT_COUNT HDL_PARAMETER true
# set_parameter_property IRTRY_INSERT_COUNT ENABLED false
# add_display_item "General" IRTRY_INSERT_COUNT parameter


# add_parameter IRTRY_DETECT_COUNT INTEGER 4
# set_parameter_property IRTRY_DETECT_COUNT DEFAULT_VALUE 4
# set_parameter_property IRTRY_DETECT_COUNT DISPLAY_NAME "Retry Detect Count"
# set_parameter_property IRTRY_DETECT_COUNT ALLOWED_RANGES {4}
# set_parameter_property IRTRY_DETECT_COUNT VISIBLE false
# set_parameter_property IRTRY_DETECT_COUNT HDL_PARAMETER true
# set_parameter_property IRTRY_DETECT_COUNT ENABLED false
# add_display_item "General" IRTRY_DETECT_COUNT parameter


#====================================
#
# Add fileset for simulation
# 

add_fileset simulation_verilog SIM_VERILOG sim_ver

#
#
#======================================


#====================================

# Add fileset for example design
# 
add_fileset example_design EXAMPLE_DESIGN example_design
#
#
#======================================


#===========================================

proc elaborate {} {
    upvar altera_xcvr_name altera_xcvr_name
    upvar altera_hmcc_xcvr_reset_name altera_hmcc_xcvr_reset_name

    set    altera_xcvr_name               "altera_xcvr_"
    set    altera_hmcc_xcvr_reset_name "altera_hmcc_xcvr_reset_"

    set data_rate_is_10g "0"

    if {[string match [get_parameter_value DATA_RATE_GUI] "10"] == 1} {
        set_parameter_value DATA_RATE "10000 Mbps"
	send_message INFO "An external PLL with an output frequency of 5000MHz must be connected to the tx_bonding_clocks inputs. See User guide for more information."
        if {[string match [get_parameter_value CDR_REFCLK] "390.625"]} {
            send_message ERROR "CDR reference clock must be driven at 125, 156.25, 166.67, or 312.5 MHz."
        }
        set_parameter_property CDR_REFCLK ALLOWED_RANGES {"125" "156.25" "166.67" "312.5"}
        set pll_ref_num_int "312"
        set data_rate_num "10000"
        set data_rate_is_10g "1"
    } elseif {[string match [get_parameter_value DATA_RATE_GUI] "12.5"] == 1} {
        set_parameter_value DATA_RATE "12500 Mbps"
	send_message INFO "An external PLL with an output frequency of 6250MHz must be connected to the tx_bonding_clocks inputs. See User guide for more information."
        if {[string match [get_parameter_value CDR_REFCLK] "312.5"]} {
            send_message ERROR "CDR reference clock must be driven at 125, 156.25, or 390.625 MHz."
        }
        set_parameter_property CDR_REFCLK ALLOWED_RANGES {"125" "156.25" "390.625"}
        set pll_ref_num_int "390"
        set data_rate_num "12500"
        set data_rate_is_10g "0"
    }

    if {[string is true [get_parameter_value ENABLE_ECC_GUI]]} {
        set_parameter_value ENABLE_ECC "TRUE"
    } else {
        set_parameter_value ENABLE_ECC "FALSE"
    }



    if {[string match [get_parameter_value CHANNELS] "8"] == 1} {
        send_message INFO "Only the 32 LSbits (8 LS hex-digits) of the Rx/Tx mapping parameters are considered for variations with 8 lanes."
    }
    
    if {[string match [get_parameter_value CDR_REFCLK] "125"] == 1} {
        set cdr_ref_num "125.000000"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "156.25"] == 1} {
        set cdr_ref_num "156.250000"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "166.67"] == 1} {
        set cdr_ref_num "166.666667"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "312.5"] == 1} {
        set cdr_ref_num "312.500000"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "390.625"] == 1} {
        set cdr_ref_num "390.625000"
    }

    validate_mapping [get_parameter_value RX_MAPPING] [get_parameter_value CHANNELS] "Rx"
    validate_mapping [get_parameter_value TX_MAPPING] [get_parameter_value CHANNELS] "Tx"

    append altera_xcvr_name "[expr {[get_parameter_value CHANNELS]/4}]f[get_parameter_value CHANNELS]l_[expr {${data_rate_num}/1000}]g_${pll_ref_num_int}cdr"

    ########## add XCVR    ###############
    add_hdl_instance $altera_xcvr_name altera_xcvr_native_a10  18.1
    set altera_hmcc_xcvr_param_val_list [list  \
        protocol_mode                       "basic_enh" \
        channels                            "[get_parameter_value CHANNELS]" \
        set_data_rate                       "$data_rate_num" \
        enable_simple_interface             "1" \
        bonded_mode                         "pma_pcs" \
        set_pcs_bonding_master              "[expr {[get_parameter_value CHANNELS]/2}]" \
        enable_port_rx_seriallpbken_tx      "1" \
        \
        set_cdr_refclk_freq                 "$cdr_ref_num" \
        enable_port_rx_is_lockedtoref       "0" \
        enable_port_rx_seriallpbken         "1" \
        \
        enh_pcs_pma_width                   "32" \
        enh_pld_pcs_width                   "32" \
        enh_low_latency_enable              "$data_rate_is_10g" \
        enh_rxfifo_mode                     "Basic" \
        enable_port_rx_enh_fifo_full        "1" \
        enable_port_rx_enh_fifo_pfull       "1" \
        enable_port_rx_enh_fifo_empty       "1" \
        enable_port_rx_enh_fifo_pempty      "1" \
        enable_port_rx_enh_fifo_rd_en       "1" \
        enh_rx_bitslip_enable               "1" \
        enable_port_rx_enh_bitslip          "1" \
        \
        rcfg_enable                         "1" \
        rcfg_shared                         "1" \
        rcfg_jtag_enable                    "[get_parameter_value ENABLE_ADME]" \
        set_capability_reg_enable           "[get_parameter_value ENABLE_ADME]" \
        set_csr_soft_logic_enable           "[get_parameter_value ENABLE_ADME]" \
        set_prbs_soft_logic_enable          "[get_parameter_value ENABLE_ADME]" \
        set_odi_soft_logic_enable           "[get_parameter_value ENABLE_ADME]" \
        ]


    foreach {param val} $altera_hmcc_xcvr_param_val_list {
        set_instance_parameter_value $altera_xcvr_name $param $val
    }

    set local_base_device [get_parameter_value "base_device"]
    if { [string compare -nocase $local_base_device "unknown"] == 0 } {
       set local_device [get_parameter_value "part_trait_device"]
       send_message error "The current selected device \"$local_device\" is invalid, please select a valid device to generate the IP."
    }
    set_instance_parameter_value $altera_xcvr_name   base_device   [get_parameter_value "base_device"]
    # set_instance_property altera_hmcc_xcvr HDLINSTANCE_USE_GENERATED_NAME true 
    append altera_hmcc_xcvr_reset_name "[expr {[get_parameter_value CHANNELS]/4}]f[get_parameter_value CHANNELS]l_${pll_ref_num_int}cdr"
    
    ########## add XCVR reset    ###############
    add_hdl_instance $altera_hmcc_xcvr_reset_name altera_xcvr_reset_control  18.1
    set altera_hmcc_xcvr_reset_param_val_list [list \
        CHANNELS                        "[get_parameter_value CHANNELS]" \
        SYS_CLK_IN_MHZ                  "$pll_ref_num_int" \
        SYNCHRONIZE_RESET               "1" \
        SYNCHRONIZE_PLL_RESET           "1" \
        gui_tx_auto_reset               "0" \
        T_PLL_LOCK_HYST                 "10000" \
	    T_TX_ANALOGRESET                "70000" \
	    T_TX_DIGITALRESET               "70000" \
	    T_RX_ANALOGRESET                "70000" \
        ]
    foreach {param val} $altera_hmcc_xcvr_reset_param_val_list {
        set_instance_parameter_value $altera_hmcc_xcvr_reset_name $param $val
    }
    # set_instance_property altera_hmcc_xcvr_reset HDLINSTANCE_USE_GENERATED_NAME true 


    # Clock and Reset
    add_conduit rst_n               end     Input   1
    add_conduit rx_cdr_refclk0      end     Input   1
    add_conduit tx_bonding_clocks   end     Input   [expr {[get_parameter_value CHANNELS] * 6}]
    add_conduit pll_powerdown       end     Output  1
    add_conduit pll_cal_busy        end     Input   1
    add_conduit pll_locked          end     Input   1
    add_conduit core_clk            end     Output  1
    add_conduit core_rst_n          end     Output  1

    # HMC Interface
    add_conduit hmc_lxrx    end     Input   [get_parameter_value CHANNELS]
    add_conduit hmc_lxtx    end     Output  [get_parameter_value CHANNELS]
    add_conduit hmc_lxrxps  end     Input   1
    add_conduit hmc_lxtxps  end     Output  1
    add_conduit hmc_ferr_n  end     Input   1
    add_conduit hmc_p_rst_n end     Output  1

    # HMC I2C Interface
    add_conduit i2c_registers_loaded    end     Input   1
    add_conduit i2c_load_registers      end     Output  1

    # User Request Interface
    add_conduit dp_req_ready    end     Output  1
    add_conduit dp_req_tag      end     Input   9
    add_conduit dp_req_cube     end     Input   3
    add_conduit dp_req_addr     end     Input   34
    add_conduit dp_req_cmd      end     Input   6
    add_conduit dp_req_data     end     Input   [expr {[get_parameter_value CHANNELS] * 32}]
    add_conduit dp_req_valid    end     Input   1

    # User Response Interface
    add_conduit dp_rsp_tag      end     Output  9
    add_conduit dp_rsp_size     end     Output  3
    add_conduit dp_rsp_cmd      end     Output  6
    add_conduit dp_rsp_error    end     Output  1
    add_conduit dp_rsp_data     end     Output  [expr {[get_parameter_value CHANNELS] * 32}]
    add_conduit dp_rsp_valid    end     Output  1
    add_conduit dp_req_sop      end     Input   1
    add_conduit dp_req_eop      end     Input   1
    add_conduit dp_rsp_sop      end     Output  1
    add_conduit dp_rsp_eop      end     Output  1        

    # Control/Status AVMM Interface
    add_conduit csr_address         end     Input   6
    add_conduit csr_read            end     Input   1
    add_conduit csr_write           end     Input   1
    add_conduit csr_writedata       end     Input   32
    add_conduit csr_readdatavalid   end     Output  1
    add_conduit csr_readdata        end     Output  32
    add_conduit csr_irq             end     Output  1

    # Debug/Status Output Signals
    add_conduit link_init_complete  end     Output  1
    add_conduit debug_tx_data       end     Output  [expr {[get_parameter_value CHANNELS] * 32}]
    add_conduit debug_rx_data       end     Output  [expr {[get_parameter_value CHANNELS] * 32}]
    
    if {[string match [get_parameter_value CHANNELS] "16"] == 1} {
        set reconfig_addr_width 14
    } else {
        set reconfig_addr_width 13
    }

    # Transceiver Reconfiguration
    add_conduit reconfig_clk            end     Input   1
    add_conduit reconfig_reset          end     Input   1
    add_conduit reconfig_write          end     Input   1
    add_conduit reconfig_read           end     Input   1
    add_conduit reconfig_address        end     Input   $reconfig_addr_width
    add_conduit reconfig_writedata      end     Input   32
    add_conduit reconfig_readdata       end     Output  32
    add_conduit reconfig_waitrequest    end     Output  1
}

#==============================================
#| procedure to validate mapping
#|
proc validate_mapping {mapping_dec channel_num type} {
    # Process upper 32 bits and lower 32 bits separately in case 32-bit TCL interpreter is being used.
    set mapping_hex_high [format %08X [expr {$mapping_dec >> 32}]]
    set mapping_hex_low [format %08X [expr {$mapping_dec & 0x00000000FFFFFFFF}]]
    # Could use format %016Xll $mapping_dec
    set mapping_hex "${mapping_hex_high}${mapping_hex_low}"

    if {$channel_num == 16} {
        if {$mapping_dec > 18446744073709551615} {
            send_message ERROR "${type} mapping must be 16 hex-digits long."
        } else {
            foreach unique_hex [list 0 1 2 3 4 5 6 7 8 9 A B C D E F] {

                set match_found 0
                set i 0
                while {!$match_found && $i < 16} {
                    if {[string match $unique_hex [string range $mapping_hex $i $i]]} {
                        set match_found 1
                    } else {
                        incr i
                    }
                }
                if {!$match_found} {
                    send_message ERROR "${type} mapping is an invalid mapping: $unique_hex is not mapped. Enter a mapping consisting of 16 unique hex-digits. E.g:0x0123456789ABCDEF"
                    return;
                }
            }
        }
    } else {
        foreach unique_hex [list 0 1 2 3 4 5 6 7] {
            set match_found 0
            set i 8
            while {!$match_found && $i < 16} {
                if {[string match $unique_hex [string range $mapping_hex $i $i]]} {
                    set match_found 1
                } else {
                    incr i
                }
            }
            if {!$match_found} {
                send_message ERROR "${type} mapping is an invalid mapping: $unique_hex is not mapped. Enter a mapping consisting of 8 unique hex-digits. E.g:0x0000000076543210"
                return;
            }
        }            
    }
}



#+--------------------------------------
#| procedure to add conduit interfaces
#|

proc add_conduit {iface_name type dir width} {

    add_interface $iface_name conduit $type
    add_interface_port $iface_name $iface_name export $dir $width
  
}


#=============================================
#
# Synthesis Proc: Specify files for generation
#
#=============================================

proc synth_proc {outputName} {
    global altera_xcvr_name              
    global altera_hmcc_xcvr_reset_name

    set 4f16l_src_files     "altera_hmcc_crc_1 altera_hmcc_crc_2 altera_hmcc_crc_3 altera_hmcc_crc_9 altera_hmcc_delimiter altera_hmcc_error_response_queue altera_hmcc_irtry_counter altera_hmcc_packer altera_hmcc_packet_creation altera_hmcc_response_queue altera_hmcc_retry_buffer altera_hmcc_retry_counter altera_hmcc_rx altera_hmcc_seq_checker altera_hmcc_token_buffer altera_hmcc_tx altera_hmcc_tx_crc32k"
    set 2f8l_src_files      "altera_hmcc_crc_1 altera_hmcc_crc_9 altera_hmcc_delimiter altera_hmcc_error_response_queue altera_hmcc_irtry_counter altera_hmcc_packer altera_hmcc_packet_creation altera_hmcc_response_queue altera_hmcc_retry_buffer altera_hmcc_retry_counter altera_hmcc_rx altera_hmcc_seq_checker altera_hmcc_tx altera_hmcc_tx_crc32k"
    set common_src_files_v  "altera_hmcc_a10mlab altera_hmcc_delay_mlab altera_hmcc_delay_regs_ena altera_hmcc_eq_5_ena altera_hmcc_mx5r altera_hmcc_neq_5_ena altera_hmcc_s5mlab altera_hmcc_scfifo_mlab altera_hmcc_sync_regs_aclr"
    set common_src_files_sv "altera_hmcc_and_r altera_hmcc_dcore altera_hmcc_descrambler altera_hmcc_destriper altera_hmcc_error altera_hmcc_extractor altera_hmcc_flow_packets altera_hmcc_init_sm altera_hmcc_irtry altera_hmcc_lane_aligner altera_hmcc_lane_swapper altera_hmcc_null_detector altera_hmcc_or_r altera_hmcc_registers altera_hmcc_retry_pointer altera_hmcc_retry_sm altera_hmcc_rrp_pret altera_hmcc_rrp_register altera_hmcc_scfifo_block_ram altera_hmcc_scfifo_ecc altera_hmcc_scrambler altera_hmcc_striper altera_hmcc_token_counter altera_hmcc_tx_crc32k_evo64_x2 altera_hmcc_tx_crc32k_evo64_x4 altera_hmcc_tx_crc32k_evo64_x6 altera_hmcc_tx_crc32k_evo64_x8 altera_hmcc_tx_crc32k_evo64_x10 altera_hmcc_tx_crc32k_evo64_x12 altera_hmcc_tx_crc32k_sig64_evo64_x1_head altera_hmcc_tx_crc32k_sig64_evo64_x3_head altera_hmcc_tx_crc32k_sig64_evo64_x5_head altera_hmcc_tx_crc32k_sig64_evo64_x9_head altera_hmcc_tx_crc32k_sig64_rrp altera_hmcc_tx_crc32k_sig64_tail altera_hmcc_tx_crc32k_sig128_evo64_x1 altera_hmcc_tx_crc32k_sig128_evo64_x3 altera_hmcc_tx_crc32k_sig128_evo64_x5 altera_hmcc_tx_crc32k_sig128_evo64_x7 altera_hmcc_word_aligner altera_hmcc_wys_lut"

    set common_folder_v_files [split "$common_src_files_v" " "]
    set common_folder_sv_files [split "$common_src_files_sv" " "]

    foreach vfile $common_folder_v_files {
       add_fileset_file src/${vfile}.v VERILOG PATH ../common/${vfile}.v
    }

    foreach svfile $common_folder_sv_files {
       add_fileset_file src/${svfile}.sv SYSTEM_VERILOG PATH ../common/${svfile}.sv
    }
    add_fileset_file src/altera_hmcc_wys_lut_inc.iv SYSTEM_VERILOG_INCLUDE PATH ../common/altera_hmcc_wys_lut_inc.iv
    

    if {[string match [get_parameter_value CHANNELS] "16"] == 1} {
        # Files in the src folder
        set src_folder_sv_files "$4f16l_src_files"

        foreach svfile $src_folder_sv_files {
            add_fileset_file src/${svfile}_4f16l.sv SYSTEM_VERILOG PATH ../4f16l/${svfile}_4f16l.sv
        }
        # Add Full-Width OCP file
        add_fileset_file src/altera_hmcc_tx_4f16l.ocp OTHER PATH ../4f16l/altera_hmcc_tx_4f16l.ocp
    } elseif {[string match [get_parameter_value CHANNELS] "8"] == 1} {
        # Files in the src folder
        set src_folder_sv_files "$2f8l_src_files"

        foreach svfile $src_folder_sv_files {
            add_fileset_file src/${svfile}_2f8l.sv SYSTEM_VERILOG PATH ../2f8l/${svfile}_2f8l.sv
        }
        # Add Half-Width OCP file
        add_fileset_file src/altera_hmcc_tx_2f8l.ocp OTHER PATH ../2f8l/altera_hmcc_tx_2f8l.ocp
    }

    if {[string match [get_parameter_value DATA_RATE] "10000 Mbps"] == 1} {
        set terp_data_rate "10"
    } elseif {[string match [get_parameter_value DATA_RATE] "12500 Mbps"] == 1} {
        set terp_data_rate "12.5"
    }
    
    set params(channels)                        [get_parameter_value CHANNELS]
    set params(data_rate)                       $terp_data_rate
    set params(top_level_name)                  $outputName 
    set params(altera_xcvr_name)                $altera_xcvr_name              
    set params(altera_hmcc_xcvr_reset_name)     $altera_hmcc_xcvr_reset_name
    interpret_terp src/${outputName}.sdc ../common/altera_hmcc.sdc.terp [array get params] "SDC"
    interpret_terp src/${outputName}.sv  ../common/altera_hmcc.sv.terp  [array get params]
}


proc sim_ver {outputName} {
    global altera_xcvr_name              
    global altera_hmcc_xcvr_reset_name

    set 4f16l_src_files     "altera_hmcc_crc_1 altera_hmcc_crc_2 altera_hmcc_crc_3 altera_hmcc_crc_9 altera_hmcc_delimiter altera_hmcc_error_response_queue altera_hmcc_irtry_counter altera_hmcc_packer altera_hmcc_packet_creation altera_hmcc_response_queue altera_hmcc_retry_buffer altera_hmcc_retry_counter altera_hmcc_rx altera_hmcc_seq_checker altera_hmcc_token_buffer altera_hmcc_tx altera_hmcc_tx_crc32k"
    set 2f8l_src_files      "altera_hmcc_crc_1 altera_hmcc_crc_9 altera_hmcc_delimiter altera_hmcc_error_response_queue altera_hmcc_irtry_counter altera_hmcc_packer altera_hmcc_packet_creation altera_hmcc_response_queue altera_hmcc_retry_buffer altera_hmcc_retry_counter altera_hmcc_rx altera_hmcc_seq_checker altera_hmcc_tx altera_hmcc_tx_crc32k"
    set common_src_files_v  "altera_hmcc_a10mlab altera_hmcc_delay_mlab altera_hmcc_delay_regs_ena altera_hmcc_eq_5_ena altera_hmcc_mx5r altera_hmcc_neq_5_ena altera_hmcc_s5mlab altera_hmcc_scfifo_mlab altera_hmcc_sync_regs_aclr"
    set common_src_files_sv "altera_hmcc_and_r altera_hmcc_dcore altera_hmcc_descrambler altera_hmcc_destriper altera_hmcc_error altera_hmcc_extractor altera_hmcc_flow_packets altera_hmcc_init_sm altera_hmcc_irtry altera_hmcc_lane_aligner altera_hmcc_lane_swapper altera_hmcc_null_detector altera_hmcc_or_r altera_hmcc_registers altera_hmcc_retry_pointer altera_hmcc_retry_sm altera_hmcc_rrp_pret altera_hmcc_rrp_register altera_hmcc_scfifo_block_ram altera_hmcc_scfifo_ecc altera_hmcc_scrambler altera_hmcc_striper altera_hmcc_token_counter altera_hmcc_tx_crc32k_evo64_x2 altera_hmcc_tx_crc32k_evo64_x4 altera_hmcc_tx_crc32k_evo64_x6 altera_hmcc_tx_crc32k_evo64_x8 altera_hmcc_tx_crc32k_evo64_x10 altera_hmcc_tx_crc32k_evo64_x12 altera_hmcc_tx_crc32k_sig64_evo64_x1_head altera_hmcc_tx_crc32k_sig64_evo64_x3_head altera_hmcc_tx_crc32k_sig64_evo64_x5_head altera_hmcc_tx_crc32k_sig64_evo64_x9_head altera_hmcc_tx_crc32k_sig64_rrp altera_hmcc_tx_crc32k_sig64_tail altera_hmcc_tx_crc32k_sig128_evo64_x1 altera_hmcc_tx_crc32k_sig128_evo64_x3 altera_hmcc_tx_crc32k_sig128_evo64_x5 altera_hmcc_tx_crc32k_sig128_evo64_x7 altera_hmcc_word_aligner altera_hmcc_wys_lut"

    set common_folder_v_files [split "$common_src_files_v" " "]
    set common_folder_sv_files [split "$common_src_files_sv" " "]


    foreach vfile $common_folder_v_files {
        if {1} {
            add_fileset_file src/synopsys/${vfile}.v VERILOG_ENCRYPT PATH ../common/synopsys/${vfile}.v SYNOPSYS_SPECIFIC
        }
        if {1} {
            add_fileset_file src/mentor/${vfile}.v VERILOG_ENCRYPT PATH ../common/mentor/${vfile}.v MENTOR_SPECIFIC
        }
        if {1} {
            add_fileset_file src/cadence/${vfile}.v VERILOG_ENCRYPT PATH ../common/cadence/${vfile}.v CADENCE_SPECIFIC
        }
    }
    if {1} {
        add_fileset_file src/synopsys/altera_hmcc_wys_lut_inc.ivp SYSTEM_VERILOG_INCLUDE PATH ../common/synopsys/altera_hmcc_wys_lut_inc.ivp SYNOPSYS_SPECIFIC
    }

    foreach svfile $common_folder_sv_files {
        if {1} {
            add_fileset_file src/synopsys/${svfile}.sv SYSTEM_VERILOG_ENCRYPT PATH ../common/synopsys/${svfile}.sv SYNOPSYS_SPECIFIC
        }
        if {1} {
            add_fileset_file src/mentor/${svfile}.sv SYSTEM_VERILOG_ENCRYPT PATH ../common/mentor/${svfile}.sv MENTOR_SPECIFIC
        }
        if {1} {
            add_fileset_file src/cadence/${svfile}.sv SYSTEM_VERILOG_ENCRYPT PATH ../common/cadence/${svfile}.sv CADENCE_SPECIFIC
        }
    }


    if {[string match [get_parameter_value CHANNELS] "16"] == 1} {
        # Files in the src folder
        set src_folder_sv_files "$4f16l_src_files"

        foreach svfile $src_folder_sv_files {
            if {1} {
                add_fileset_file src/synopsys/${svfile}_4f16l.sv SYSTEM_VERILOG_ENCRYPT PATH ../4f16l/synopsys/${svfile}_4f16l.sv SYNOPSYS_SPECIFIC
            }
            if {1} {
                add_fileset_file src/mentor/${svfile}_4f16l.sv SYSTEM_VERILOG_ENCRYPT PATH ../4f16l/mentor/${svfile}_4f16l.sv MENTOR_SPECIFIC
            }
            if {1} {
                add_fileset_file src/cadence/${svfile}_4f16l.sv SYSTEM_VERILOG_ENCRYPT PATH ../4f16l/cadence/${svfile}_4f16l.sv CADENCE_SPECIFIC
            }
        }

    } elseif {[string match [get_parameter_value CHANNELS] "8"] == 1} {
        # Files in the src folder
        set src_folder_sv_files "$2f8l_src_files"

        foreach svfile $src_folder_sv_files {
            if {1} {
                add_fileset_file src/synopsys/${svfile}_2f8l.sv SYSTEM_VERILOG_ENCRYPT PATH ../2f8l/synopsys/${svfile}_2f8l.sv SYNOPSYS_SPECIFIC
            }
            if {1} {
                add_fileset_file src/mentor/${svfile}_2f8l.sv SYSTEM_VERILOG_ENCRYPT PATH ../2f8l/mentor/${svfile}_2f8l.sv MENTOR_SPECIFIC
            }
            if {1} {
                add_fileset_file src/cadence/${svfile}_2f8l.sv SYSTEM_VERILOG_ENCRYPT PATH ../2f8l/cadence/${svfile}_2f8l.sv CADENCE_SPECIFIC
            }
        }

    }

    if {[string match [get_parameter_value DATA_RATE] "10000 Mbps"] == 1} {
        set terp_data_rate "10"
    } elseif {[string match [get_parameter_value DATA_RATE] "12500 Mbps"] == 1} {
        set terp_data_rate "12.5"
    }

    set params(channels)                        [get_parameter_value CHANNELS]
    set params(data_rate)                       $terp_data_rate
    set params(top_level_name)                  $outputName 
    set params(altera_xcvr_name)                $altera_xcvr_name              
    set params(altera_hmcc_xcvr_reset_name)     $altera_hmcc_xcvr_reset_name
    interpret_terp src/${outputName}.sdc ../common/altera_hmcc.sdc.terp [array get params] "SDC"
    interpret_terp src/${outputName}.sv  ../common/altera_hmcc.sv.terp  [array get params]
}

proc example_design {outputName} {
    if { [string match "10AX115S?F45??SG*" [get_parameter_value part_trait_device]] == 0 } {
        send_message WARNING "The example design was intended for 10AX115S3F45I2SGES and its speedgrade variants. The compilation will give warnings regarding pin assignments, and may fail under some circumstances."
    }

    send_message INFO "Generating required IP cores."
    generate_related_ip_files $outputName

    send_message INFO "Generating example design source files."

    set    files_in_example_design_folder { \
        par/hmcc_example.qpf \
        par/hmcc_example.sdc \
        sim/ncsim_wave_gen.tcl \
        sim/vsim.do \
        src/atx_pll_recal.sv \
        src/i2c_32sub.v \
        src/i2c_control.sv \
    }


    foreach file $files_in_example_design_folder {
       add_fileset_file example_design/${file} OTHER PATH ../a10_example_design/${file}
    }
    add_fileset_file example_design/sim/Makefile OTHER PATH ../a10_example_design/sim/Makefile.mk
    add_fileset_file example_design/sim/make.bat OTHER PATH ../a10_example_design/sim/Makefile_windows.mk

    set num_lanes [get_parameter_value CHANNELS]

    add_fileset_file example_design/src/m20k_2port.v            OTHER PATH  "../a10_example_design/src/m20k_2port_${num_lanes}l.v"
    add_fileset_file example_design/src/request_generator.sv    OTHER PATH  "../a10_example_design/src/request_generator_${num_lanes}l.sv"
    add_fileset_file example_design/src/response_monitor.sv     OTHER PATH  "../a10_example_design/src/response_monitor_${num_lanes}l.sv" 

    if {[string match [get_parameter_value DATA_RATE] "10000 Mbps"] == 1} {
        set terp_data_rate "10"
    } elseif {[string match [get_parameter_value DATA_RATE] "12500 Mbps"] == 1} {
        set terp_data_rate "12.5"
    }


    if {[string match [get_parameter_value CDR_REFCLK] "125"] == 1} {
        set terp_cdr_clk_period "8000"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "156.25"] == 1} {
        set terp_cdr_clk_period "6400"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "166.67"] == 1} {
        set terp_cdr_clk_period "6000"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "312.5"] == 1} {
        set terp_cdr_clk_period "3200"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "390.625"] == 1} {
        set terp_cdr_clk_period "2560"
    } 


    set params(cdr_clk_period)                  $terp_cdr_clk_period
    set params(cdr_refclk)                      [get_parameter_value CDR_REFCLK]
    set params(data_rate)                       $terp_data_rate
    set params(data_rate_mbps)                  [get_parameter_value DATA_RATE]
    set params(device_part)                     [get_parameter_value part_trait_device] 
    set params(num_channels)                    [get_parameter_value CHANNELS]
    set params(num_flits)                       [get_parameter_value CHANNELS]/4 ; # Temporary. 


    interpret_terp ../example_design/sim/hmc_cfg.sv         ../a10_example_design/sim/hmc_cfg.sv.terp       [array get params]
    interpret_terp ../example_design/sim/hmcc_tb.sv         ../a10_example_design/sim/hmcc_tb.sv.terp       [array get params]
    interpret_terp ../example_design/par/hmcc_example.qsf   ../a10_example_design/par/hmcc_example.qsf.terp [array get params] "OTHER"
    interpret_terp ../example_design/src/hmcc_example.sv    ../a10_example_design/src/hmcc_example.sv.terp  [array get params]

    # array unset params; #in case params conflict

}


proc interpret_terp {output_file_path terp_file_path passed_in_params {file_type "SYSTEM_VERILOG"}} {
    array set params $passed_in_params

    # get template
    set template_path $terp_file_path; # path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it

    # process template with parameters
    set contents [altera_terp $template params] ;# pass parameter array in by reference
    add_fileset_file $output_file_path $file_type TEXT $contents
}


# proc: generate_related_ip_files
#
# Callback function invoked by the infrastructure to generate the HMCC IP and PLL IP.
# Taken from Ethernet! :)
#
proc generate_related_ip_files {outputName} {
    set subdir "ip"; # Save IP files to understandable location.
    create_temp_file "$subdir/.mk_dir" ; # Dummy file to create folder location.

    # Instantiate an HMCC IP.
    set hmcc_name "altera_hmcc_ip"

    set templocation [create_temp_file "${hmcc_name}_gen.tcl"]; # Create gen tcl first

    set fileId [open [file dirname $templocation]/$hmcc_name.tcl "w"]
    puts $fileId "package require -exact qsys 14.1"
    puts $fileId "create_system ${hmcc_name}_system"

    puts $fileId "add_instance $hmcc_name altera_hmcc  18.1"
    puts $fileId "set_instance_property $hmcc_name autoexport 1"

    foreach p [get_parameters] {
        if {[get_parameter_property $p DERIVED] == 0} {
            set val \"[get_parameter_value $p]\"
            if {$p eq "DEVICE_FAMILY"} {
                puts $fileId "set_project_property DEVICE_FAMILY $val"
            }
            puts $fileId "set_instance_parameter_value $hmcc_name $p $val"
        }
    }
    puts $fileId "set_project_property DEVICE        \"[get_parameter_value part_trait_device]\""

    # Save .qsys
    puts $fileId "save_system [file dirname $templocation]/$subdir/$hmcc_name.qsys"
    close $fileId


    # Instantiate ATX PLL
    set pll_name "altera_atx_pll_ip"

    create_temp_file "${pll_name}_gen.tcl"  ;# also for pll
    set fileId [open [file dirname $templocation]/$pll_name.tcl "w"]

    puts $fileId "package require -exact qsys 14.1"
    puts $fileId "create_system ${pll_name}_system"
    puts $fileId "set_project_property DEVICE_FAMILY \"[get_parameter_value DEVICE_FAMILY]\""
    puts $fileId "set_project_property DEVICE        \"[get_parameter_value part_trait_device]\""
    puts $fileId "add_instance $pll_name altera_xcvr_atx_pll_a10  18.1"
    puts $fileId "set_instance_property $pll_name autoexport 1"

    if {[string match [get_parameter_value DATA_RATE_GUI] "10"] == 1} {
        set data_rate_num "10000"
    } else { 
        set data_rate_num "12500"
    }

    if {[string match [get_parameter_value CDR_REFCLK] "125"] == 1} {
        set cdr_ref_num "125.0"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "156.25"] == 1} {
        set cdr_ref_num "156.25"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "166.67"] == 1} {
        set cdr_ref_num "166.666667"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "312.5"] == 1} {
        set cdr_ref_num "312.5"
    } elseif {[string match [get_parameter_value CDR_REFCLK] "390.625"] == 1} {
        set cdr_ref_num "390.625"
    }
    
    puts $fileId "set_instance_parameter_value $pll_name set_output_clock_frequency           \"[expr {$data_rate_num/2}]\""
    puts $fileId "set_instance_parameter_value $pll_name set_auto_reference_clock_frequency   \"$cdr_ref_num\""
    puts $fileId "set_instance_parameter_value $pll_name enable_mcgb                          \"1\""
    puts $fileId "set_instance_parameter_value $pll_name enable_bonding_clks                  \"1\""
    puts $fileId "set_instance_parameter_value $pll_name pma_width                            \"32\""
    puts $fileId "set_instance_parameter_value $pll_name rcfg_jtag_enable       \"[get_parameter_value ENABLE_ADME]\""
    puts $fileId "set_instance_parameter_value $pll_name enable_pll_reconfig    \"1\""

    puts $fileId "save_system [file dirname $templocation]/$subdir/$pll_name.qsys"
    close $fileId
    
    # Instantiate a GPIO IP
    set gpio_name "bidir_pin"

    set templocation [create_temp_file "${gpio_name}_gen.tcl"]; # Create gen tcl first

    set fileId [open [file dirname $templocation]/$gpio_name.tcl "w"]
    puts $fileId "package require -exact qsys 14.1"
    puts $fileId "create_system ${gpio_name}_system"

    puts $fileId "add_instance $gpio_name altera_gpio  18.1"
    puts $fileId "set_instance_property $gpio_name autoexport 1"

    puts $fileId "set_project_property DEVICE_FAMILY \"[get_parameter_value DEVICE_FAMILY]\""
    puts $fileId "set_project_property DEVICE        \"[get_parameter_value part_trait_device]\""
    
    puts $fileId "set_instance_parameter_value $gpio_name PIN_TYPE_GUI      \"Bidir\""
    puts $fileId "set_instance_parameter_value $gpio_name SIZE    \"1\""

    # Save .qsys
    puts $fileId "save_system [file dirname $templocation]/$subdir/$gpio_name.qsys"
    close $fileId

    send_message INFO "Generating Transceiver ATX PLL IP core."
    local_qsysgenerate [file dirname $templocation] ${pll_name}_gen.tcl  $pll_name $subdir
    send_message INFO "Done generating Transceiver ATX PLL IP core."

    send_message INFO "Generating HMC Controller IP core."
    local_qsysgenerate [file dirname $templocation] ${hmcc_name}_gen.tcl $hmcc_name $subdir
    send_message INFO "Done generating HMC Controller IP core."
    
    send_message INFO "Generating GPIO IP core."
    local_qsysgenerate [file dirname $templocation] ${gpio_name}_gen.tcl $gpio_name $subdir
    send_message INFO "Done generating GPIO IP core."

    set qdir $::env(QUARTUS_ROOTDIR)
    send_message INFO "Generating AVMM system."
    exec -ignorestderr "${qdir}/sopc_builder/bin/qsys-generate" "../a10_example_design/src/AVMM.qsys" "--synthesis=VERILOG" "--output-directory=[file dirname $templocation]/$subdir/AVMM" "--part=[get_parameter_value part_trait_device]" "--family=[get_parameter_value DEVICE_FAMILY]"
    send_message INFO "Done generating AVMM system."

    send_message INFO "Copying over files."
    copy_over_files [file dirname $templocation] $subdir

    # To do: grep result file for ip generate success. If not, give error and refer user to it.

}

# proc: local_qsysgenerate
#
# Helper function used in generating the QSYS which is then used in generating IP cores.
# Taken from Ethernet and slightly changed! :)
#
proc local_qsysgenerate { filepath filename qsysname subdir } { 
    set fh [open $filepath/$filename w]

    set qdir $::env(QUARTUS_ROOTDIR)
    set cmd "${qdir}/sopc_builder/bin/qsys-script"
    set cmd "${cmd} --script=${filepath}/${qsysname}.tcl\n"

    puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
    puts $fh "puts \$temp"

    set cmd "${qdir}/sopc_builder/bin/qsys-generate"
    set cmd "${cmd} ${filepath}/${subdir}/${qsysname}.qsys"
    set cmd "${cmd} --synthesis=VERILOG"
    set cmd "${cmd} --simulation=VERILOG"
    set cmd "${cmd} --part=[get_parameter_value part_trait_device]"

    puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
    puts $fh "puts \$temp"
    close $fh

    set result [run_tclsh_script $filepath/$filename]
    set error_fh [open $filepath/$subdir/results_$qsysname.txt w]
    puts $error_fh "Results of qsys-generate of $qsysname:" 
    puts $error_fh $result
    close $error_fh
    send_message INFO "Please check 'results_$qsysname.txt' file for more IP generation information."
}

proc copy_over_files { filepath subdir } {
    set fl [findFiles ${filepath}/${subdir}]
    foreach file $fl {
        set f_path [string map [list ${filepath} ""] $file]
        if {[file ext $file] == ".v"} {
            add_fileset_file "./$f_path" VERILOG PATH $file
        } elseif {[file ext $file] == ".sv"} {
            add_fileset_file "./$f_path" SYSTEM_VERILOG PATH $file
        } elseif {[file ext $file] == ".iv" || [file ext $file] == ".ivp"} {
            add_fileset_file "./$f_path" SYSTEM_VERILOG_INCLUDE PATH $file
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

# Taken from Ethernet :)
# -------------------------------------------------------------
# This function returns a list of all files in a directory tree
# -------------------------------------------------------------
proc findFiles { path } {
    set filelist {}
    # grab files and directories that exist at this level
    set file_lst [glob -nocomplain -directory $path -- *]
    
    # for each file or directory
    foreach file ${file_lst} {   
        if {[file isdirectory $file] == 1} {
            # if its a directory call findFiles on that directory and append output to list
            set filelist [join [list $filelist [findFiles $path/[file tail $file]]]]
        } else {
            # if its a file append file location to list
            lappend filelist $path/[file tail $file]
        }
    }
    # return the list
    return $filelist
}


# proc: get_quartus_bindir
#
#   Returns the QUARTUS_BINDIR value without requring it to be set in the environment.
#   Works in both the Jacl & Native tcl interpreters
#   Taken from alt_xcvr :)
#
# returns:
#
#   Directory containing the Quartus binaries which match the bitness of the current tcl interpreter
#
proc get_quartus_bindir {} {

    set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

    set PLATFORM $::tcl_platform(platform)
    if { $PLATFORM == "java" } {
        set PLATFORM $::tcl_platform(host_platform)
    }

    if { [catch {set QUARTUS_BINDIR $::quartus(binpath)} errmsg] } {
        if { $PLATFORM == "windows" } {
            set BINDIRNAME "bin"
        } else {
            set BINDIRNAME "linux"
        }

        # Only the native tcl interpreter has 'tcl_platform(pointerSize)'
        # In Jacl however 'tcl_platform(machine)' is set to the JVM bitness, not the OS bitness
        if { [catch {set POINTERSIZE $::tcl_platform(pointerSize)} errmsg] } {
            if {[string match "*64" $::tcl_platform(machine)]} {
                set POINTERSIZE 8
            } else {
                set POINTERSIZE 4
            }
        }
        if { $POINTERSIZE == 8 } {
            set BINDIRNAME "${BINDIRNAME}64"
        }

        set QUARTUS_BINDIR "$QUARTUS_ROOTDIR/$BINDIRNAME"
    }

    return $QUARTUS_BINDIR
}


#   Taken from alt_xcvr :)
proc run_tclsh_script {filename} {
    set qbindir [get_quartus_bindir]
    set cmd [concat [list exec "${qbindir}/tclsh" $filename]]
    #_dprint 1 "Running the command: $cmd"
    set cmd_fail [catch { eval $cmd } tempresult]

    set lines [split $tempresult "\n"]
    set num_errors 0
    foreach line $lines {
        #_dprint 1 "Returned: $line"
        if {[regexp -nocase -- {[ ]+error[ ]*:[ ]*(.*)[ ]*$} $line match error_msg]} {
            # e.g: 2011.09.15.17:38:15 Error: core1_p0_altdqdqs: "Memory frequency" (INPUT_FREQ) (800) out of range (120,600)
            #_eprint "Error during execution of script $filename: $error_msg" 1
            incr num_errors
        } elseif {[regexp -nocase -- {^[ ]*couldn.*execute.*$} $line match]} {
            # e.g: couldn't execute "quartus_ma": no such file or directory
            #_eprint "Error during execution of script $filename: $match" 1
            incr num_errors
        } elseif {[regexp -nocase -- {child process exited abnormally} $line match]} {
            #_eprint "Error during execution of script $filename: $match" 1
            incr num_errors
        } elseif {[regexp -nocase -- {Quartus Prime.*Shell was unsuccessful} $line match]} {
            # e.g: Error: Quartus II 64-Bit Shell was unsuccessful. 1 error, 0 warnings
            # This one doesn't match any useful single line error message, so don't print anything right now.
            # The entire error output will be printed outside of this loop.
            incr num_errors
        }
    }

    if {$num_errors > 0 || $cmd_fail} {
        #_eprint "Execution of script $filename failed" 1
        # For some reason printing $tempresult with _iprint doesn't work.
        # It might contain weird control characters. Instead, loop and print every line.
        foreach line $lines {
            #_eprint "$line" 1
        }
    } else {
        #_dprint 1 "Execution of script $filename was a success"
    }

    return $tempresult
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/nik1412377950681/nik1412377908032
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/ewo1424301491510
