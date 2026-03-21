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


package require -exact qsys 15.1
package require altera_tcl_testlib 1.0
package require -exact altera_terp 1.0

# 
# module alt_em10g32
# 
set_module_property DESCRIPTION "Ethernet 32 Bits 10G MAC"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_32b_10g_ethernet_mac.pdf"
set_module_property NAME alt_em10g32
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Interface Protocols/Ethernet/10G to 1G Multi-rate Ethernet"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Low Latency Ethernet 10G MAC Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property REPORT_TO_TALKBACK false
set_module_property NATIVE_INTERPRETER true
set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate

# 
# file sets
# 
# Synthesis fileset callback
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH compilation_list ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL alt_em10g32
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file alt_em10g32.v VERILOG PATH alt_em10g32.v TOP_LEVEL_FILE

# Verilog simulation fileset callback
add_fileset SIM_VERILOG SIM_VERILOG sim_ver
set_fileset_property SIM_VERILOG TOP_LEVEL alt_em10g32
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false

# VHDL simulation fileset callback
add_fileset SIM_VHDL SIM_VHDL sim_ver
set_fileset_property SIM_VHDL TOP_LEVEL alt_em10g32
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false

#source ./globfind.tcl

# example design fileset callback
add_fileset EXAMPLE_DESIGN EXAMPLE_DESIGN example_design_func
set_fileset_property EXAMPLE_DESIGN ENABLE_FILE_OVERWRITE_MODE true
source ./alt_em10g32_ed_files.tcl 
#source ./alt_em10g32_ed_files_a10_phy_lineside.tcl 
source ./alt_em10g32_ed_files_a10_lineside.tcl 
#source ./alt_em10g32_ed_files_a10_phy_10GBaser_regmode.tcl
source ./alt_em10g32_ed_files_a10_lineside_1588v2.tcl
#source ./alt_em10g32_ed_files_a10_lineside_wo_1588.tcl 
source ./alt_em10g32_ed_files_a10_10gbaser_regmode.tcl
source ./alt_em10g32_ed_files_a10_1g_10g_lineside.tcl
source ./alt_em10g32_ed_files_a10_1g_10g_lineside_1588v2.tcl
source ./alt_em10g32_ed_files_a10_1G_2_5G.tcl
source ./alt_em10g32_ed_files_a10_1G_2_5G_10G.tcl
source ./alt_em10g32_ed_files_a10_1G_2_5G_1588v2.tcl
source ./alt_em10g32_ed_files_a10_10g_usxgmii.tcl
source ./alt_em10g32_ed_files_a10_10gbaser.tcl

#
# source alt_em10g32_conf.tcl for parameter list
#
source ./alt_em10g32_conf.tcl 


# 
# source alt_em10g32_gui.tcl for GUI display
# 
source ./alt_em10g32_gui.tcl


# 
# source alt_em10g32_validate.tcl for validate 
# 
source ./alt_em10g32_validate.tcl

# source fileset.tcl for all the MAC files
source ./alt_em10g32_fileset.tcl
proc sim_ver {name} {

    sim_ver_mac $name

}


proc compilation_list {name} {

    compilation_list_mac $name
}


# function for SDC
proc sdc_file_gen {} {
    set sdc_template "alt_em10g32.sdc"
    set sdc_out_file [create_temp_file low_latency_10G_ethernet.sdc]
    set out [ open $sdc_out_file w ]
    set in [open $sdc_template r]

    # SDC file parameters
    # Mapping between SDC file parameter with core parameter
    set mac_sdc_parameters {
        DATAPATH_OPTION         DATAPATH_OPTION
        PREAMBLE_PASSTHROUGH    PREAMBLE_PASSTHROUGH
        ENABLE_PFC              ENABLE_PFC
        PFC_PRIORITY_NUMBER     PFC_PRIORITY_NUMBER
        ENABLE_SUPP_ADDR        ENABLE_SUPP_ADDR
        ENABLE_TIMESTAMPING     ENABLE_TIMESTAMPING
        INSERT_ST_ADAPTOR       INSERT_ST_ADAPTOR
        INSERT_XGMII_ADAPTOR    INSERT_XGMII_ADAPTOR
        USE_ASYNC_ADAPTOR       USE_ASYNC_ADAPTOR
        ENABLE_UNIDIRECTIONAL   ENABLE_UNIDIRECTIONAL
        ENABLE_1G10G_MAC        ENABLE_1G10G_MAC
    }

    while {[gets $in line] != -1} {
        if [string match "*CORE_PARAMETERS*" $line] {
            puts $out $line

            foreach {sdc_param module_param} $mac_sdc_parameters {
                set param_value [get_parameter_value $module_param]
      
                if { [string match -nocase "BOOLEAN" [get_parameter_property $module_param TYPE]] } {
                    # Convert boolean parameter to 0/1 value
                    if {[get_parameter_value $module_param]} {
                        puts $out "set $sdc_param 1"
                    } else {
                        puts $out "set $sdc_param 0"
                    }
                } else {
                    puts $out "set $sdc_param $param_value"
                }
            }

        } else {
            puts $out $line
        }
    }
    close $in
    close $out
    add_fileset_file low_latency_10G_ethernet.sdc SDC PATH $sdc_out_file 
}




proc elaborate {} {

    set ENABLE_TIMESTAMPING [get_parameter_value ENABLE_TIMESTAMPING]
    set ENABLE_PTP_1STEP [get_parameter_value ENABLE_PTP_1STEP]
    set ENABLE_ASYMMETRY [get_parameter_value ENABLE_ASYMMETRY]
    set INSERT_ST_ADAPTOR [get_parameter_value INSERT_ST_ADAPTOR]
    set INSERT_CSR_ADAPTOR [get_parameter_value INSERT_CSR_ADAPTOR]
    set ENABLE_MEM_ECC [get_parameter_value ENABLE_MEM_ECC]
    set INSERT_XGMII_ADAPTOR [get_parameter_value INSERT_XGMII_ADAPTOR]
    set USE_ASYNC_ADAPTOR [get_parameter_value USE_ASYNC_ADAPTOR]
    set ENABLE_1G10G_MAC [get_parameter_value ENABLE_1G10G_MAC]
    set ENABLE_PFC [get_parameter_value ENABLE_PFC]
    set DATAPATH_OPTION [get_parameter_value DATAPATH_OPTION]
    set ENABLE_UNIDIRECTIONAL [get_parameter_value ENABLE_UNIDIRECTIONAL]
    set ENABLE_10GBASER_REG_MODE [get_parameter_value ENABLE_10GBASER_REG_MODE]

    declare_all_inst
    
    enable_basic_clk_reset_csr
    
    if {$ENABLE_1G10G_MAC == 3} {
        set_interface_property tx_312_5_clk ENABLED false
        set_interface_property tx_156_25_clk ENABLED true
        
        set_interface_property rx_312_5_clk ENABLED false
        set_interface_property rx_156_25_clk ENABLED true
    }
    
    if {$ENABLE_1G10G_MAC == 3} {
        terminate_xgmii_valid
        if {$INSERT_ST_ADAPTOR == 1} {
            inst_st_or_xgmii_adapter
            inst_st_adaptor
        } else {
            wo_inst_st_adaptor
        }
        
    } elseif {$ENABLE_10GBASER_REG_MODE} {
        disable_basic_312_5_clk
        enable_xcvr_clk
        inst_ultra_low_latency
        terminate_xgmii
    } elseif {$ENABLE_1G10G_MAC == 5} {
        wo_inst_xgmii_adapter
        if {$INSERT_ST_ADAPTOR == 1} {
            inst_st_or_xgmii_adapter
            inst_st_adaptor
        } else {
            wo_inst_st_adaptor
        }

    } else {
        terminate_xgmii_valid
        if {$INSERT_XGMII_ADAPTOR == 1 || $INSERT_ST_ADAPTOR == 1} {
            inst_st_or_xgmii_adapter
        }
           
        if {$INSERT_ST_ADAPTOR == 1} {
            inst_st_adaptor
        } else {
            wo_inst_st_adaptor
        }
        
        if {$INSERT_XGMII_ADAPTOR == 1} {
            inst_xgmii_adapter
            
            if {$USE_ASYNC_ADAPTOR == 1 && $ENABLE_TIMESTAMPING == 1} {
                use_async_adaptor_1588
            } else {
                no_use_async_adaptor_1588
            }
        } else {
            wo_inst_xgmii_adapter
            no_use_async_adaptor_1588
        }
    }
    
    if {$ENABLE_UNIDIRECTIONAL} {
        inst_unidirectional
    } else {
        terminate_unidirectional
    }
    
    if {$ENABLE_TIMESTAMPING} {
        inst_time_stamping
        
        if {$ENABLE_PTP_1STEP} {
            inst_ptp_step
            if {$ENABLE_ASYMMETRY} {
                inst_ptp_step_asym
            } else {
                terminate_ptp_step_asym
            }
        } else {
            terminate_ptp_step
        }
        
        if {$ENABLE_1G10G_MAC != 0} {
            inst_1g_time_stamping
            
            # 1G/2.5G does not support 10G
            if {$ENABLE_1G10G_MAC == 3} {
                terminate_10g_time_stamping
            }
        } else {
            terminate_1g_time_stamping
        }
    
    } else {
        terminate_time_stamping
    }
    
    if {$ENABLE_MEM_ECC == 1} {
        inst_ecc
    } else {
        wo_inst_ecc
    }
    
    if {$INSERT_CSR_ADAPTOR == 1} {
        inst_csr_adaptor
    } else {
        wo_inst_csr_adaptor
    }

    if {$ENABLE_1G10G_MAC == 1} {
        inst_enable_1g10g
        terminate_mii
        terminate_gmii16b
    } elseif {$ENABLE_1G10G_MAC == 2} {
        inst_enable_multi_speed
        terminate_gmii16b
    } elseif {$ENABLE_1G10G_MAC == 3} {
        inst_enable_gmii16b
    } elseif {$ENABLE_1G10G_MAC == 4} {
        inst_enable_gmii16b
    } elseif {$ENABLE_1G10G_MAC == 5} {
        inst_xgmii_valid
    } else {
        terminate_gmii_mii
        terminate_gmii16b
    }
    
    if {$ENABLE_PFC == 1} {
        if {$INSERT_ST_ADAPTOR == 1} {
            inst_pfc tx_156_25_clk rx_156_25_clk
        } else {
            inst_pfc tx_312_5_clk rx_312_5_clk
        }
        if {$DATAPATH_OPTION == 1} {
            terminate_rx_path_pfc
        } elseif {$DATAPATH_OPTION == 2} {
            terminate_tx_path_pfc
        } else {
        
        }
    } else {
        terminate_pfc
    }
    
    if {$DATAPATH_OPTION == 1} {
        if {$INSERT_ST_ADAPTOR == 1} {
            inst_tx_data_path_only tx_156_25_clk
        } else {
            inst_tx_data_path_only tx_312_5_clk
        }
        
        if {$INSERT_XGMII_ADAPTOR == 1} {
            inst_xgmii_tx_data_path_only tx_156_25_clk
        } else {
            inst_xgmii_tx_data_path_only tx_312_5_clk
        }
        
        terminate_rx_path
    } elseif {$DATAPATH_OPTION == 2} {
        if {$INSERT_ST_ADAPTOR == 1} {
            inst_rx_data_path_only rx_156_25_clk
        } else {
            inst_rx_data_path_only rx_312_5_clk
        }
        terminate_tx_path
    }
    

}

proc inst_unidirectional {} {
    set_interface_property unidirectional ENABLED true
}

proc terminate_unidirectional {} {
    set_interface_property unidirectional ENABLED false
}

proc inst_time_stamping {} {
    set TIME_OF_DAY_FORMAT [get_parameter_value TIME_OF_DAY_FORMAT]
    
    set_interface_property tx_path_delay_10g ENABLED true
    set_interface_property rx_path_delay_10g ENABLED true
    set_interface_property tx_egress_timestamp_request ENABLED true

    if {$TIME_OF_DAY_FORMAT == 0 || $TIME_OF_DAY_FORMAT == 2} {
        set_interface_property tx_time_of_day_96b_10g ENABLED true
        set_interface_property rx_time_of_day_96b_10g ENABLED true
        set_interface_property tx_egress_timestamp_96b ENABLED true
        set_interface_property rx_ingress_timestamp_96b ENABLED true
    } else {
        set_port_property tx_time_of_day_96b_10g_data DRIVEN_BY 0
        set_port_property tx_time_of_day_96b_10g_data TERMINATION true
        set_port_property tx_time_of_day_96b_10g_data TERMINATION_VALUE 0
        
        set_port_property rx_time_of_day_96b_10g_data DRIVEN_BY 0
        set_port_property rx_time_of_day_96b_10g_data TERMINATION true
        set_port_property rx_time_of_day_96b_10g_data TERMINATION_VALUE 0
        
        set_port_property tx_egress_timestamp_96b_valid DRIVEN_BY 0
        set_port_property tx_egress_timestamp_96b_valid TERMINATION true
        set_port_property tx_egress_timestamp_96b_valid TERMINATION_VALUE 0
        
        set_port_property tx_egress_timestamp_96b_data DRIVEN_BY 0
        set_port_property tx_egress_timestamp_96b_data TERMINATION true
        set_port_property tx_egress_timestamp_96b_data TERMINATION_VALUE 0
        
        set_port_property tx_egress_timestamp_96b_fingerprint DRIVEN_BY 0
        set_port_property tx_egress_timestamp_96b_fingerprint TERMINATION true
        set_port_property tx_egress_timestamp_96b_fingerprint TERMINATION_VALUE 0   
        
        set_port_property rx_ingress_timestamp_96b_valid DRIVEN_BY 0
        set_port_property rx_ingress_timestamp_96b_valid TERMINATION true
        set_port_property rx_ingress_timestamp_96b_valid TERMINATION_VALUE 0  
        
        set_port_property rx_ingress_timestamp_96b_data DRIVEN_BY 0
        set_port_property rx_ingress_timestamp_96b_data TERMINATION true
        set_port_property rx_ingress_timestamp_96b_data TERMINATION_VALUE 0    
    }

    if {$TIME_OF_DAY_FORMAT == 1 || $TIME_OF_DAY_FORMAT == 2} {  
        set_interface_property tx_time_of_day_64b_10g ENABLED true
        set_interface_property rx_time_of_day_64b_10g ENABLED true
        set_interface_property tx_egress_timestamp_64b ENABLED true
        set_interface_property rx_ingress_timestamp_64b ENABLED true
    } else {
        set_port_property tx_time_of_day_64b_10g_data DRIVEN_BY 0
        set_port_property tx_time_of_day_64b_10g_data TERMINATION true
        set_port_property tx_time_of_day_64b_10g_data TERMINATION_VALUE 0
        
        set_port_property rx_time_of_day_64b_10g_data DRIVEN_BY 0
        set_port_property rx_time_of_day_64b_10g_data TERMINATION true
        set_port_property rx_time_of_day_64b_10g_data TERMINATION_VALUE 0
        
        set_port_property tx_egress_timestamp_64b_valid DRIVEN_BY 0
        set_port_property tx_egress_timestamp_64b_valid TERMINATION true
        set_port_property tx_egress_timestamp_64b_valid TERMINATION_VALUE 0
        
        set_port_property tx_egress_timestamp_64b_data DRIVEN_BY 0
        set_port_property tx_egress_timestamp_64b_data TERMINATION true
        set_port_property tx_egress_timestamp_64b_data TERMINATION_VALUE 0
        
        set_port_property tx_egress_timestamp_64b_fingerprint DRIVEN_BY 0
        set_port_property tx_egress_timestamp_64b_fingerprint TERMINATION true
        set_port_property tx_egress_timestamp_64b_fingerprint TERMINATION_VALUE 0   
        
        set_port_property rx_ingress_timestamp_64b_valid DRIVEN_BY 0
        set_port_property rx_ingress_timestamp_64b_valid TERMINATION true
        set_port_property rx_ingress_timestamp_64b_valid TERMINATION_VALUE 0   
        
        set_port_property rx_ingress_timestamp_64b_data DRIVEN_BY 0
        set_port_property rx_ingress_timestamp_64b_data TERMINATION true
        set_port_property rx_ingress_timestamp_64b_data TERMINATION_VALUE 0    
    }
}

proc inst_1g_time_stamping {} {
    set TIME_OF_DAY_FORMAT [get_parameter_value TIME_OF_DAY_FORMAT]

    set_interface_property tx_path_delay_1g ENABLED true
    set_interface_property rx_path_delay_1g ENABLED true
    
    if {$TIME_OF_DAY_FORMAT == 0 || $TIME_OF_DAY_FORMAT == 2} {
        set_interface_property tx_time_of_day_96b_1g ENABLED true
        set_interface_property rx_time_of_day_96b_1g ENABLED true
    } else {
        set_port_property tx_time_of_day_96b_1g_data DRIVEN_BY 0
        set_port_property tx_time_of_day_96b_1g_data TERMINATION true
        set_port_property tx_time_of_day_96b_1g_data TERMINATION_VALUE 0
        
        set_port_property rx_time_of_day_96b_1g_data DRIVEN_BY 0
        set_port_property rx_time_of_day_96b_1g_data TERMINATION true
        set_port_property rx_time_of_day_96b_1g_data TERMINATION_VALUE 0
    }

    if {$TIME_OF_DAY_FORMAT == 1 || $TIME_OF_DAY_FORMAT == 2} {
        set_interface_property tx_time_of_day_64b_1g ENABLED true
        set_interface_property rx_time_of_day_64b_1g ENABLED true
    } else {
        set_port_property tx_time_of_day_64b_1g_data DRIVEN_BY 0
        set_port_property tx_time_of_day_64b_1g_data TERMINATION true
        set_port_property tx_time_of_day_64b_1g_data TERMINATION_VALUE 0
        
        set_port_property rx_time_of_day_64b_1g_data DRIVEN_BY 0
        set_port_property rx_time_of_day_64b_1g_data TERMINATION true
        set_port_property rx_time_of_day_64b_1g_data TERMINATION_VALUE 0
    }
}


proc terminate_1g_time_stamping {} {
    set_port_property tx_path_delay_1g_data DRIVEN_BY 0
    set_port_property tx_path_delay_1g_data TERMINATION true
    set_port_property tx_path_delay_1g_data TERMINATION_VALUE 0
    
    set_port_property tx_time_of_day_96b_1g_data DRIVEN_BY 0
    set_port_property tx_time_of_day_96b_1g_data TERMINATION true
    set_port_property tx_time_of_day_96b_1g_data TERMINATION_VALUE 0
    
    set_port_property tx_time_of_day_64b_1g_data DRIVEN_BY 0
    set_port_property tx_time_of_day_64b_1g_data TERMINATION true
    set_port_property tx_time_of_day_64b_1g_data TERMINATION_VALUE 0
    
    set_port_property rx_path_delay_1g_data DRIVEN_BY 0
    set_port_property rx_path_delay_1g_data TERMINATION true
    set_port_property rx_path_delay_1g_data TERMINATION_VALUE 0
    
    set_port_property rx_time_of_day_96b_1g_data DRIVEN_BY 0
    set_port_property rx_time_of_day_96b_1g_data TERMINATION true
    set_port_property rx_time_of_day_96b_1g_data TERMINATION_VALUE 0
    
    set_port_property rx_time_of_day_64b_1g_data DRIVEN_BY 0
    set_port_property rx_time_of_day_64b_1g_data TERMINATION true
    set_port_property rx_time_of_day_64b_1g_data TERMINATION_VALUE 0
}

proc terminate_10g_time_stamping {} {
    set_port_property tx_path_delay_10g_data DRIVEN_BY 0
    set_port_property tx_path_delay_10g_data TERMINATION true
    set_port_property tx_path_delay_10g_data TERMINATION_VALUE 0
    
    set_port_property tx_time_of_day_96b_10g_data DRIVEN_BY 0
    set_port_property tx_time_of_day_96b_10g_data TERMINATION true
    set_port_property tx_time_of_day_96b_10g_data TERMINATION_VALUE 0
    
    set_port_property tx_time_of_day_64b_10g_data DRIVEN_BY 0
    set_port_property tx_time_of_day_64b_10g_data TERMINATION true
    set_port_property tx_time_of_day_64b_10g_data TERMINATION_VALUE 0
    
    set_port_property rx_path_delay_10g_data DRIVEN_BY 0
    set_port_property rx_path_delay_10g_data TERMINATION true
    set_port_property rx_path_delay_10g_data TERMINATION_VALUE 0
    
    set_port_property rx_time_of_day_96b_10g_data DRIVEN_BY 0
    set_port_property rx_time_of_day_96b_10g_data TERMINATION true
    set_port_property rx_time_of_day_96b_10g_data TERMINATION_VALUE 0
    
    set_port_property rx_time_of_day_64b_10g_data DRIVEN_BY 0
    set_port_property rx_time_of_day_64b_10g_data TERMINATION true
    set_port_property rx_time_of_day_64b_10g_data TERMINATION_VALUE 0
}

proc terminate_time_stamping {} {
    set_port_property tx_path_delay_10g_data DRIVEN_BY 0
    set_port_property tx_path_delay_10g_data TERMINATION true
    set_port_property tx_path_delay_10g_data TERMINATION_VALUE 0
    
    set_port_property tx_time_of_day_96b_10g_data DRIVEN_BY 0
    set_port_property tx_time_of_day_96b_10g_data TERMINATION true
    set_port_property tx_time_of_day_96b_10g_data TERMINATION_VALUE 0
    
    set_port_property tx_time_of_day_64b_10g_data DRIVEN_BY 0
    set_port_property tx_time_of_day_64b_10g_data TERMINATION true
    set_port_property tx_time_of_day_64b_10g_data TERMINATION_VALUE 0
    
    set_port_property rx_path_delay_10g_data DRIVEN_BY 0
    set_port_property rx_path_delay_10g_data TERMINATION true
    set_port_property rx_path_delay_10g_data TERMINATION_VALUE 0
    
    set_port_property rx_time_of_day_96b_10g_data DRIVEN_BY 0
    set_port_property rx_time_of_day_96b_10g_data TERMINATION true
    set_port_property rx_time_of_day_96b_10g_data TERMINATION_VALUE 0
    
    set_port_property rx_time_of_day_64b_10g_data DRIVEN_BY 0
    set_port_property rx_time_of_day_64b_10g_data TERMINATION true
    set_port_property rx_time_of_day_64b_10g_data TERMINATION_VALUE 0
    
    set_port_property tx_egress_timestamp_96b_valid DRIVEN_BY 0
    set_port_property tx_egress_timestamp_96b_valid TERMINATION true
    set_port_property tx_egress_timestamp_96b_valid TERMINATION_VALUE 0
    
    set_port_property tx_egress_timestamp_96b_data DRIVEN_BY 0
    set_port_property tx_egress_timestamp_96b_data TERMINATION true
    set_port_property tx_egress_timestamp_96b_data TERMINATION_VALUE 0
    
    set_port_property tx_egress_timestamp_96b_fingerprint DRIVEN_BY 0
    set_port_property tx_egress_timestamp_96b_fingerprint TERMINATION true
    set_port_property tx_egress_timestamp_96b_fingerprint TERMINATION_VALUE 0
    
    set_port_property tx_egress_timestamp_64b_valid DRIVEN_BY 0
    set_port_property tx_egress_timestamp_64b_valid TERMINATION true
    set_port_property tx_egress_timestamp_64b_valid TERMINATION_VALUE 0
    
    set_port_property tx_egress_timestamp_64b_data DRIVEN_BY 0
    set_port_property tx_egress_timestamp_64b_data TERMINATION true
    set_port_property tx_egress_timestamp_64b_data TERMINATION_VALUE 0
    
    set_port_property tx_egress_timestamp_64b_fingerprint DRIVEN_BY 0
    set_port_property tx_egress_timestamp_64b_fingerprint TERMINATION true
    set_port_property tx_egress_timestamp_64b_fingerprint TERMINATION_VALUE 0
    
    set_port_property rx_ingress_timestamp_96b_valid DRIVEN_BY 0
    set_port_property rx_ingress_timestamp_96b_valid TERMINATION true
    set_port_property rx_ingress_timestamp_96b_valid TERMINATION_VALUE 0
    
    set_port_property rx_ingress_timestamp_96b_data DRIVEN_BY 0
    set_port_property rx_ingress_timestamp_96b_data TERMINATION true
    set_port_property rx_ingress_timestamp_96b_data TERMINATION_VALUE 0
    
    set_port_property rx_ingress_timestamp_64b_valid DRIVEN_BY 0
    set_port_property rx_ingress_timestamp_64b_valid TERMINATION true
    set_port_property rx_ingress_timestamp_64b_valid TERMINATION_VALUE 0
    
    set_port_property rx_ingress_timestamp_64b_data DRIVEN_BY 0
    set_port_property rx_ingress_timestamp_64b_data TERMINATION true
    set_port_property rx_ingress_timestamp_64b_data TERMINATION_VALUE 0
    
    set_port_property tx_egress_timestamp_request_valid DRIVEN_BY 0
    set_port_property tx_egress_timestamp_request_valid TERMINATION true
    set_port_property tx_egress_timestamp_request_valid TERMINATION_VALUE 0
    
    set_port_property tx_egress_timestamp_request_fingerprint DRIVEN_BY 0
    set_port_property tx_egress_timestamp_request_fingerprint TERMINATION true
    set_port_property tx_egress_timestamp_request_fingerprint TERMINATION_VALUE 0
}

proc inst_ptp_step {} {
    set TIME_OF_DAY_FORMAT [get_parameter_value TIME_OF_DAY_FORMAT]
    
    set_interface_property tx_etstamp_ins_ctrl ENABLED true

    if {$TIME_OF_DAY_FORMAT == 0} {
        set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b DRIVEN_BY 0
        set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b TERMINATION true
        set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b TERMINATION_VALUE 0
        
        set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format DRIVEN_BY 0
        set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION true
        set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION_VALUE 0   
    }
    
    if {$TIME_OF_DAY_FORMAT == 1} {
        set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b DRIVEN_BY 0
        set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b TERMINATION true
        set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b TERMINATION_VALUE 0
        
        set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format DRIVEN_BY 1
        set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION true
        set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION_VALUE 1    
    }
}

proc terminate_ptp_step {} {
    set_port_property tx_etstamp_ins_ctrl_offset_checksum_field DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_offset_checksum_field TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_offset_checksum_field TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_timestamp_insert DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_timestamp_insert TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_timestamp_insert TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_timestamp_format DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_timestamp_format TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_timestamp_format TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_residence_time_update DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_residence_time_update TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_residence_time_update TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_checksum_zero DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_checksum_zero TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_checksum_zero TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_checksum_correct DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_checksum_correct TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_checksum_correct TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_offset_timestamp DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_offset_timestamp TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_offset_timestamp TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_offset_correction_field DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_offset_correction_field TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_offset_correction_field TERMINATION_VALUE 0

    set_port_property tx_etstamp_ins_ctrl_offset_checksum_correction DRIVEN_BY 0
    set_port_property tx_etstamp_ins_ctrl_offset_checksum_correction TERMINATION true
    set_port_property tx_etstamp_ins_ctrl_offset_checksum_correction TERMINATION_VALUE 0
}

proc inst_ptp_step_asym {} {
    
    set_interface_property tx_egress_asymmetry ENABLED true

}

proc terminate_ptp_step_asym {} {
    set_port_property tx_egress_asymmetry_update DRIVEN_BY 0
    set_port_property tx_egress_asymmetry_update TERMINATION true
    set_port_property tx_egress_asymmetry_update TERMINATION_VALUE 0
}

proc declare_all_inst {} {
    set ENABLE_1G10G_MAC [get_parameter_value ENABLE_1G10G_MAC]
    
    set tx_associated_clock tx_312_5_clk
    set rx_associated_clock rx_312_5_clk
    
    if {$ENABLE_1G10G_MAC == 3} {
        set tx_associated_clock tx_156_25_clk
        set rx_associated_clock rx_156_25_clk
    }
    
    # 
    # connection point csr
    # 
    add_interface csr avalon end
    set_interface_property csr addressUnits WORDS
    set_interface_property csr associatedClock csr_clk
    set_interface_property csr associatedReset csr_rst_n
    set_interface_property csr bitsPerSymbol 8
    set_interface_property csr burstOnBurstBoundariesOnly false
    set_interface_property csr burstcountUnits WORDS
    set_interface_property csr explicitAddressSpan 0
    set_interface_property csr holdTime 0
    set_interface_property csr linewrapBursts false
    set_interface_property csr maximumPendingReadTransactions 0
    set_interface_property csr readLatency 1
    set_interface_property csr readWaitTime 0
    set_interface_property csr setupTime 0
    set_interface_property csr timingUnits Cycles
    set_interface_property csr writeWaitTime 0
    set_interface_property csr ENABLED false

    add_interface_port csr csr_read read Input 1
    add_interface_port csr csr_write write Input 1
    add_interface_port csr csr_writedata writedata Input 32
    add_interface_port csr csr_readdata readdata Output 32
    add_interface_port csr csr_waitrequest waitrequest Output 1
    add_interface_port csr csr_address address Input 13
    set_interface_assignment csr embeddedsw.configuration.isFlash 0
    set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
    set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
    set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0

    # 
    # connection point clock_sink
    # 
    add_interface tx_312_5_clk clock end
    set_interface_property tx_312_5_clk clockRate 0
    set_interface_property tx_312_5_clk ENABLED true
    add_interface_port tx_312_5_clk tx_312_5_clk clk Input 1
    
    add_interface tx_156_25_clk clock end
    set_interface_property tx_156_25_clk clockRate 0
    set_interface_property tx_156_25_clk ENABLED false
    add_interface_port tx_156_25_clk tx_156_25_clk clk Input 1
    
    # 
    # connection point clock_sink_1
    # 
    add_interface rx_312_5_clk clock end
    set_interface_property rx_312_5_clk clockRate 0
    set_interface_property rx_312_5_clk ENABLED true
    add_interface_port rx_312_5_clk rx_312_5_clk clk Input 1
    
    add_interface rx_156_25_clk clock end
    set_interface_property rx_156_25_clk clockRate 0
    set_interface_property rx_156_25_clk ENABLED false
    add_interface_port rx_156_25_clk rx_156_25_clk clk Input 1
    
    # 
    # connection point clock_sink_2
    # 
    add_interface csr_clk clock end
    set_interface_property csr_clk clockRate 0
    set_interface_property csr_clk ENABLED false

    add_interface_port csr_clk csr_clk clk Input 1

    # 
    # connection point sampling_clk
    # 
    add_interface latency_measure_sampling_clk clock end
    set_interface_property latency_measure_sampling_clk clockRate 0
    set_interface_property latency_measure_sampling_clk ENABLED false

    add_interface_port latency_measure_sampling_clk latency_measure_sampling_clk clk Input 1

    # 
    # connection point clock_sink_2_reset
    # 
    add_interface csr_rst_n reset end
    set_interface_property csr_rst_n associatedClock csr_clk
    set_interface_property csr_rst_n synchronousEdges DEASSERT
    set_interface_property csr_rst_n ENABLED false

    add_interface_port csr_rst_n csr_rst_n reset_n Input 1

    # 
    # connection point clock_sink_reset
    # 
    add_interface tx_rst_n reset end
    set_interface_property tx_rst_n associatedClock $tx_associated_clock
    set_interface_property tx_rst_n synchronousEdges DEASSERT
    set_interface_property tx_rst_n ENABLED false

    add_interface_port tx_rst_n tx_rst_n reset_n Input 1

    # 
    # connection point clock_sink_1_reset
    # 
    add_interface rx_rst_n reset end
    set_interface_property rx_rst_n associatedClock $rx_associated_clock
    set_interface_property rx_rst_n synchronousEdges DEASSERT
    set_interface_property rx_rst_n ENABLED false

    add_interface_port rx_rst_n rx_rst_n reset_n Input 1

    # 
    # connection point unidirectional
    # 
    add_interface unidirectional conduit start
    set_interface_property unidirectional associatedClock ""
    set_interface_property unidirectional associatedReset ""
    set_interface_property unidirectional ENABLED false

    add_interface_port unidirectional unidirectional_en en Output 1
    add_interface_port unidirectional unidirectional_remote_fault_dis remote_fault_dis Output 1
	add_interface_port unidirectional unidirectional_force_remote_fault force_remote_fault Output 1
    # 
    # connection point clock for Ultra low latency
    # 
    add_interface rx_xcvr_clk clock end
    set_interface_property rx_xcvr_clk clockRate 0
    set_interface_property rx_xcvr_clk ENABLED false

    add_interface_port rx_xcvr_clk rx_xcvr_clk clk Input 1

    add_interface tx_xcvr_clk clock end
    set_interface_property tx_xcvr_clk clockRate 0
    set_interface_property tx_xcvr_clk ENABLED false

    add_interface_port tx_xcvr_clk tx_xcvr_clk clk Input 1


    # 
    # connection point ultra low latency tx path
    # 
    add_interface xgmii_tx_valid conduit start
    set_interface_property xgmii_tx_valid associatedClock tx_xcvr_clk
    set_interface_property xgmii_tx_valid associatedReset ""
    set_interface_property xgmii_tx_valid ENABLED false

    add_interface_port xgmii_tx_valid xgmii_tx_valid out Output 1

    # 
    # connection point ultra low latency tx path
    # 
    # add_interface xgmii_tx_data_out conduit start
    # set_interface_property xgmii_tx_data_out associatedClock tx_xcvr_clk
    # set_interface_property xgmii_tx_data_out associatedReset ""
    # set_interface_property xgmii_tx_data_out ENABLED false

    # add_interface_port xgmii_tx_data_out xgmii_tx_data_out out Output 64

    # 
    # connection point ultra low latency tx path
    # 
    # add_interface xgmii_tx_control_out conduit start
    # set_interface_property xgmii_tx_control_out associatedClock tx_xcvr_clk
    # set_interface_property xgmii_tx_control_out associatedReset ""
    # set_interface_property xgmii_tx_control_out ENABLED false

    # add_interface_port xgmii_tx_control_out xgmii_tx_control_out out Output 8

    # 
    # connection point ultra low latency rx path
    # 
    add_interface xgmii_rx_valid conduit end
    set_interface_property xgmii_rx_valid associatedClock rx_xcvr_clk
    set_interface_property xgmii_rx_valid associatedReset ""
    set_interface_property xgmii_rx_valid ENABLED false

    add_interface_port xgmii_rx_valid xgmii_rx_valid in Input 1

    # 
    # connection point ultra low latency rx path
    # 
    # add_interface xgmii_rx_data_in conduit end
    # set_interface_property xgmii_rx_data_in associatedClock rx_xcvr_clk
    # set_interface_property xgmii_rx_data_in associatedReset ""
    # set_interface_property xgmii_rx_data_in ENABLED false

    # add_interface_port xgmii_rx_data_in xgmii_rx_data_in in Input 64

    # 
    # connection point ultra low latency rx path
    # 
    # add_interface xgmii_rx_control_in conduit end
    # set_interface_property xgmii_rx_control_in associatedClock rx_xcvr_clk
    # set_interface_property xgmii_rx_control_in associatedReset ""
    # set_interface_property xgmii_rx_control_in ENABLED false

    # add_interface_port xgmii_rx_control_in xgmii_rx_control_in in Input 8

    # 
    # connection point conduit_end
    # 
    add_interface speed_sel conduit end
    set_interface_property speed_sel associatedClock ""
    set_interface_property speed_sel associatedReset ""
    set_interface_property speed_sel ENABLED false

    add_interface_port speed_sel speed_sel export Input 2

    # 
    # connection point avalon_streaming_sink
    # 
    add_interface avalon_st_tx avalon_streaming end
    set_interface_property avalon_st_tx associatedClock $tx_associated_clock
    set_interface_property avalon_st_tx dataBitsPerSymbol 8
    set_interface_property avalon_st_tx errorDescriptor ""
    set_interface_property avalon_st_tx firstSymbolInHighOrderBits true
    set_interface_property avalon_st_tx maxChannel 0
    set_interface_property avalon_st_tx readyLatency 0
    set_interface_property avalon_st_tx ENABLED false

    add_interface_port avalon_st_tx avalon_st_tx_startofpacket startofpacket Input 1
    add_interface_port avalon_st_tx avalon_st_tx_endofpacket endofpacket Input 1
    add_interface_port avalon_st_tx avalon_st_tx_valid valid Input 1
    add_interface_port avalon_st_tx avalon_st_tx_data data Input 64
    add_interface_port avalon_st_tx avalon_st_tx_empty empty Input 3
    add_interface_port avalon_st_tx avalon_st_tx_error error Input 1
    add_interface_port avalon_st_tx avalon_st_tx_ready ready Output 1

    # 
    # connection point conduit_end_1
    # 
    add_interface link_fault_status_xgmii_tx avalon_streaming end
    set_interface_property link_fault_status_xgmii_tx associatedClock tx_312_5_clk
    set_interface_property link_fault_status_xgmii_tx dataBitsPerSymbol 2
    set_interface_property link_fault_status_xgmii_tx errorDescriptor ""
    set_interface_property link_fault_status_xgmii_tx firstSymbolInHighOrderBits true
    set_interface_property link_fault_status_xgmii_tx maxChannel 0
    set_interface_property link_fault_status_xgmii_tx readyLatency 0
    set_interface_property link_fault_status_xgmii_tx ENABLED false

    add_interface_port link_fault_status_xgmii_tx link_fault_status_xgmii_tx_data data Input 2

    # 
    # connection point conduit_end_2
    # 
    add_interface avalon_st_pause avalon_streaming end
    set_interface_property avalon_st_pause associatedClock $tx_associated_clock
    set_interface_property avalon_st_pause associatedReset tx_rst_n
    set_interface_property avalon_st_pause dataBitsPerSymbol 2
    set_interface_property avalon_st_pause errorDescriptor ""
    set_interface_property avalon_st_pause firstSymbolInHighOrderBits true
    set_interface_property avalon_st_pause maxChannel 0
    set_interface_property avalon_st_pause readyLatency 0
    set_interface_property avalon_st_pause ENABLED false

    add_interface_port avalon_st_pause avalon_st_pause_data data Input 2

    # 
    # connection point conduit_end_3
    # 
    add_interface avalon_st_tx_pfc_gen_data conduit end
    set_interface_property avalon_st_tx_pfc_gen_data associatedClock ""
    set_interface_property avalon_st_tx_pfc_gen_data ENABLED false

    add_interface_port avalon_st_tx_pfc_gen_data avalon_st_tx_pfc_gen_data export Input PFC_PRIORITY_NUMBER*2

    # 
    # connection point conduit_end_4
    # 
    add_interface xgmii_tx avalon_streaming start
    set_interface_property xgmii_tx associatedClock tx_156_25_clk
    set_interface_property xgmii_tx associatedReset tx_rst_n
    set_interface_property xgmii_tx dataBitsPerSymbol 72
    set_interface_property xgmii_tx errorDescriptor ""
    set_interface_property xgmii_tx firstSymbolInHighOrderBits true
    set_interface_property xgmii_tx maxChannel 0
    set_interface_property xgmii_tx readyLatency 0
    set_interface_property xgmii_tx ENABLED false

    add_interface_port xgmii_tx xgmii_tx data Output 72

    # 
    # connection point conduit_end_5
    # 
    add_interface xgmii_tx_data conduit end
    set_interface_property xgmii_tx_data associatedClock ""
    set_interface_property xgmii_tx_data associatedReset ""
    set_interface_property xgmii_tx_data ENABLED false

    add_interface_port xgmii_tx_data xgmii_tx_data export Output 32

    # 
    # connection point conduit_end_5
    # 
    add_interface xgmii_tx_control conduit end
    set_interface_property xgmii_tx_control associatedClock ""
    set_interface_property xgmii_tx_control associatedReset ""
    set_interface_property xgmii_tx_control ENABLED false

    add_interface_port xgmii_tx_control xgmii_tx_control export Output 4


    # 
    # connection point clock_sink_3
    # 
    add_interface gmii_tx_clk clock end
    set_interface_property gmii_tx_clk clockRate 0
    set_interface_property gmii_tx_clk ENABLED false

    add_interface_port gmii_tx_clk gmii_tx_clk clk Input 1


    # 
    # connection point conduit_end_6
    # 
    add_interface gmii_tx_d conduit end
    set_interface_property gmii_tx_d associatedClock ""
    set_interface_property gmii_tx_d associatedReset ""
    set_interface_property gmii_tx_d ENABLED false

    add_interface_port gmii_tx_d gmii_tx_d export Output 8

    add_interface gmii_tx_en conduit end
    set_interface_property gmii_tx_en associatedClock ""
    set_interface_property gmii_tx_en associatedReset ""
    set_interface_property gmii_tx_en ENABLED false

    add_interface_port gmii_tx_en gmii_tx_en export Output 1

    add_interface gmii_tx_err conduit end
    set_interface_property gmii_tx_err associatedClock ""
    set_interface_property gmii_tx_err associatedReset ""
    set_interface_property gmii_tx_err ENABLED false

    add_interface_port gmii_tx_err gmii_tx_err export Output 1

    # 
    # connection point conduit_end_7
    # 
    add_interface tx_clkena_half_rate conduit end
    set_interface_property tx_clkena_half_rate associatedClock ""
    set_interface_property tx_clkena_half_rate associatedReset ""
    set_interface_property tx_clkena_half_rate ENABLED false

    add_interface_port tx_clkena_half_rate tx_clkena_half_rate export Input 1

    # 
    # connection point gmii16b16B TX
    # 
    add_interface gmii16b_tx_clk clock end
    set_interface_property gmii16b_tx_clk clockRate 0
    set_interface_property gmii16b_tx_clk ENABLED false

    add_interface_port gmii16b_tx_clk gmii16b_tx_clk clk Input 1
    
    add_interface gmii16b_tx_d conduit end
    set_interface_property gmii16b_tx_d associatedClock ""
    set_interface_property gmii16b_tx_d associatedReset ""
    set_interface_property gmii16b_tx_d ENABLED false

    add_interface_port gmii16b_tx_d gmii16b_tx_d export Output 16

    add_interface gmii16b_tx_en conduit end
    set_interface_property gmii16b_tx_en associatedClock ""
    set_interface_property gmii16b_tx_en associatedReset ""
    set_interface_property gmii16b_tx_en ENABLED false

    add_interface_port gmii16b_tx_en gmii16b_tx_en export Output 2

    add_interface gmii16b_tx_err conduit end
    set_interface_property gmii16b_tx_err associatedClock ""
    set_interface_property gmii16b_tx_err associatedReset ""
    set_interface_property gmii16b_tx_err ENABLED false

    add_interface_port gmii16b_tx_err gmii16b_tx_err export Output 2

    # 
    # connection point conduit_end_8
    # 
    add_interface mii_tx_d conduit end
    set_interface_property mii_tx_d associatedClock ""
    set_interface_property mii_tx_d associatedReset ""
    set_interface_property mii_tx_d ENABLED false

    add_interface_port mii_tx_d mii_tx_d export Output 4

    add_interface mii_tx_en conduit end
    set_interface_property mii_tx_en associatedClock ""
    set_interface_property mii_tx_en associatedReset ""
    set_interface_property mii_tx_en ENABLED false
    add_interface_port mii_tx_en mii_tx_en export Output 1

    add_interface mii_tx_err conduit end
    set_interface_property mii_tx_err associatedClock ""
    set_interface_property mii_tx_err associatedReset ""
    set_interface_property mii_tx_err ENABLED false
    add_interface_port mii_tx_err mii_tx_err export Output 1

    # 
    # connection point avalon_streaming_source
    # 
    add_interface avalon_st_txstatus avalon_streaming start
    set_interface_property avalon_st_txstatus associatedClock $tx_associated_clock
    set_interface_property avalon_st_txstatus dataBitsPerSymbol 8
    set_interface_property avalon_st_txstatus errorDescriptor ""
    set_interface_property avalon_st_txstatus firstSymbolInHighOrderBits true
    set_interface_property avalon_st_txstatus maxChannel 0
    set_interface_property avalon_st_txstatus readyLatency 0
    set_interface_property avalon_st_txstatus ENABLED false

    add_interface_port avalon_st_txstatus avalon_st_txstatus_valid valid Output 1
    add_interface_port avalon_st_txstatus avalon_st_txstatus_data data Output 40
    add_interface_port avalon_st_txstatus avalon_st_txstatus_error error Output 7

    # 
    # connection point avalon_streaming_sink_2
    # 
    add_interface avalon_st_tx_pause_length avalon_streaming end
    set_interface_property avalon_st_tx_pause_length associatedClock $tx_associated_clock
    set_interface_property avalon_st_tx_pause_length dataBitsPerSymbol 8
    set_interface_property avalon_st_tx_pause_length errorDescriptor ""
    set_interface_property avalon_st_tx_pause_length firstSymbolInHighOrderBits true
    set_interface_property avalon_st_tx_pause_length maxChannel 0
    set_interface_property avalon_st_tx_pause_length readyLatency 0
    set_interface_property avalon_st_tx_pause_length ENABLED false

    add_interface_port avalon_st_tx_pause_length avalon_st_tx_pause_length_valid valid Input 1
    add_interface_port avalon_st_tx_pause_length avalon_st_tx_pause_length_data data Input 16

    # 
    # connection point avalon_streaming_source_1
    # 
    add_interface avalon_st_tx_pfc_status avalon_streaming start
    set_interface_property avalon_st_tx_pfc_status associatedClock $tx_associated_clock
    set_interface_property avalon_st_tx_pfc_status dataBitsPerSymbol 8
    set_interface_property avalon_st_tx_pfc_status errorDescriptor ""
    set_interface_property avalon_st_tx_pfc_status firstSymbolInHighOrderBits true
    set_interface_property avalon_st_tx_pfc_status maxChannel 0
    set_interface_property avalon_st_tx_pfc_status readyLatency 0
    set_interface_property avalon_st_tx_pfc_status ENABLED false

    add_interface_port avalon_st_tx_pfc_status avalon_st_tx_pfc_status_valid valid Output 1
    add_interface_port avalon_st_tx_pfc_status avalon_st_tx_pfc_status_data data Output 16

    # 
    # connection point conduit_end_9
    # 
    add_interface xgmii_rx avalon_streaming end
    set_interface_property xgmii_rx associatedClock rx_156_25_clk
    set_interface_property xgmii_rx dataBitsPerSymbol 72
    set_interface_property xgmii_rx errorDescriptor ""
    set_interface_property xgmii_rx firstSymbolInHighOrderBits true
    set_interface_property xgmii_rx maxChannel 0
    set_interface_property xgmii_rx readyLatency 0
    set_interface_property xgmii_rx ENABLED false

    add_interface_port xgmii_rx xgmii_rx data Input 72

    # 
    # connection point conduit_end_10
    # 
    add_interface xgmii_rx_data conduit end
    set_interface_property xgmii_rx_data associatedClock ""
    set_interface_property xgmii_rx_data associatedReset ""
    set_interface_property xgmii_rx_data ENABLED false

    add_interface_port xgmii_rx_data xgmii_rx_data export Input 32

    # 
    # connection point conduit_end_10
    # 
    add_interface xgmii_rx_control conduit end
    set_interface_property xgmii_rx_control associatedClock ""
    set_interface_property xgmii_rx_control associatedReset ""
    set_interface_property xgmii_rx_control ENABLED false

    add_interface_port xgmii_rx_control xgmii_rx_control export Input 4

    # 
    # connection point avalon_streaming_source_3
    # 
    add_interface link_fault_status_xgmii_rx avalon_streaming start
    set_interface_property link_fault_status_xgmii_rx associatedClock rx_312_5_clk
    set_interface_property link_fault_status_xgmii_rx dataBitsPerSymbol 2
    set_interface_property link_fault_status_xgmii_rx errorDescriptor ""
    set_interface_property link_fault_status_xgmii_rx firstSymbolInHighOrderBits true
    set_interface_property link_fault_status_xgmii_rx maxChannel 0
    set_interface_property link_fault_status_xgmii_rx readyLatency 0
    set_interface_property link_fault_status_xgmii_rx ENABLED false

    add_interface_port link_fault_status_xgmii_rx link_fault_status_xgmii_rx_data data Output 2

    # 
    # connection point clock_sink_4
    # 
    add_interface gmii_rx_clk clock end
    set_interface_property gmii_rx_clk clockRate 0
    set_interface_property gmii_rx_clk ENABLED false

    add_interface_port gmii_rx_clk gmii_rx_clk clk Input 1

    # 
    # connection point conduit_end_11
    # 
    add_interface gmii_rx_d conduit end
    set_interface_property gmii_rx_d associatedClock ""
    set_interface_property gmii_rx_d associatedReset ""
    set_interface_property gmii_rx_d ENABLED false

    add_interface_port gmii_rx_d gmii_rx_d export Input 8

    # 
    # connection point conduit_end_12
    # 
    add_interface gmii_rx_dv conduit end
    set_interface_property gmii_rx_dv associatedClock ""
    set_interface_property gmii_rx_dv associatedReset ""
    set_interface_property gmii_rx_dv ENABLED false

    add_interface_port gmii_rx_dv gmii_rx_dv export Input 1

    # 
    # connection point conduit_end_13
    # 
    add_interface gmii_rx_err conduit end
    set_interface_property gmii_rx_err associatedClock ""
    set_interface_property gmii_rx_err associatedReset ""
    set_interface_property gmii_rx_err ENABLED false

    add_interface_port gmii_rx_err gmii_rx_err export Input 1

    # 
    # connection point conduit_end_14
    # 
    add_interface rx_clkena conduit end
    set_interface_property rx_clkena associatedClock ""
    set_interface_property rx_clkena associatedReset ""
    set_interface_property rx_clkena ENABLED false

    add_interface_port rx_clkena rx_clkena export Input 1

    # 
    # connection point conduit_end_15
    # 
    add_interface rx_clkena_half_rate conduit end
    set_interface_property rx_clkena_half_rate associatedClock ""
    set_interface_property rx_clkena_half_rate associatedReset ""
    set_interface_property rx_clkena_half_rate ENABLED false

    add_interface_port rx_clkena_half_rate rx_clkena_half_rate export Input 1

    # 
    # connection point GMII16B RX Clock
    # 
    add_interface gmii16b_rx_clk clock end
    set_interface_property gmii16b_rx_clk clockRate 0
    set_interface_property gmii16b_rx_clk ENABLED false

    add_interface_port gmii16b_rx_clk gmii16b_rx_clk clk Input 1
    
    # 
    # connection point GMII16B RX DATA
    # 
    add_interface gmii16b_rx_d conduit end
    set_interface_property gmii16b_rx_d associatedClock ""
    set_interface_property gmii16b_rx_d associatedReset ""
    set_interface_property gmii16b_rx_d ENABLED false

    add_interface_port gmii16b_rx_d gmii16b_rx_d export Input 16

    # 
    # connection point GMII16B RX DATA VALID
    # 
    add_interface gmii16b_rx_dv conduit end
    set_interface_property gmii16b_rx_dv associatedClock ""
    set_interface_property gmii16b_rx_dv associatedReset ""
    set_interface_property gmii16b_rx_dv ENABLED false

    add_interface_port gmii16b_rx_dv gmii16b_rx_dv export Input 2

    # 
    # connection point GMII16B RX ERROR
    # 
    add_interface gmii16b_rx_err conduit end
    set_interface_property gmii16b_rx_err associatedClock ""
    set_interface_property gmii16b_rx_err associatedReset ""
    set_interface_property gmii16b_rx_err ENABLED false

    add_interface_port gmii16b_rx_err gmii16b_rx_err export Input 2

    # 
    # connection point conduit_end_16
    # 
    add_interface mii_rx_d conduit end
    set_interface_property mii_rx_d associatedClock ""
    set_interface_property mii_rx_d associatedReset ""
    set_interface_property mii_rx_d ENABLED false

    add_interface_port mii_rx_d mii_rx_d export Input 4

    # 
    # connection point conduit_end_17
    # 
    add_interface mii_rx_dv conduit end
    set_interface_property mii_rx_dv associatedClock ""
    set_interface_property mii_rx_dv associatedReset ""
    set_interface_property mii_rx_dv ENABLED false

    add_interface_port mii_rx_dv mii_rx_dv export Input 1

    # 
    # connection point conduit_end_18
    # 
    add_interface mii_rx_err conduit end
    set_interface_property mii_rx_err associatedClock ""
    set_interface_property mii_rx_err associatedReset ""
    set_interface_property mii_rx_err ENABLED false

    add_interface_port mii_rx_err mii_rx_err export Input 1

    # 
    # connection point avalon_streaming_source_4
    # 
    add_interface avalon_st_rx avalon_streaming start
    set_interface_property avalon_st_rx associatedClock $rx_associated_clock
    set_interface_property avalon_st_rx dataBitsPerSymbol 8
    set_interface_property avalon_st_rx errorDescriptor ""
    set_interface_property avalon_st_rx firstSymbolInHighOrderBits true
    set_interface_property avalon_st_rx maxChannel 0
    set_interface_property avalon_st_rx readyLatency 0
    set_interface_property avalon_st_rx ENABLED false

    add_interface_port avalon_st_rx avalon_st_rx_data data Output 64
    add_interface_port avalon_st_rx avalon_st_rx_startofpacket startofpacket Output 1
    add_interface_port avalon_st_rx avalon_st_rx_valid valid Output 1
    add_interface_port avalon_st_rx avalon_st_rx_empty empty Output 3
    add_interface_port avalon_st_rx avalon_st_rx_error error Output 6
    add_interface_port avalon_st_rx avalon_st_rx_ready ready Input 1
    add_interface_port avalon_st_rx avalon_st_rx_endofpacket endofpacket Output 1

    # 
    # connection point avalon_streaming_source_5
    # 
    add_interface avalon_st_rxstatus avalon_streaming start
    set_interface_property avalon_st_rxstatus associatedClock $rx_associated_clock
    set_interface_property avalon_st_rxstatus dataBitsPerSymbol 8
    set_interface_property avalon_st_rxstatus errorDescriptor ""
    set_interface_property avalon_st_rxstatus firstSymbolInHighOrderBits true
    set_interface_property avalon_st_rxstatus maxChannel 0
    set_interface_property avalon_st_rxstatus readyLatency 0
    set_interface_property avalon_st_rxstatus ENABLED false

    add_interface_port avalon_st_rxstatus avalon_st_rxstatus_valid valid Output 1
    add_interface_port avalon_st_rxstatus avalon_st_rxstatus_data data Output 40
    add_interface_port avalon_st_rxstatus avalon_st_rxstatus_error error Output 7

    # 
    # connection point avalon_streaming_source_6
    # 
    add_interface avalon_st_rx_pause_length avalon_streaming start
    set_interface_property avalon_st_rx_pause_length associatedClock $rx_associated_clock
    set_interface_property avalon_st_rx_pause_length associatedReset rx_rst_n
    set_interface_property avalon_st_rx_pause_length dataBitsPerSymbol 8
    set_interface_property avalon_st_rx_pause_length errorDescriptor ""
    set_interface_property avalon_st_rx_pause_length firstSymbolInHighOrderBits true
    set_interface_property avalon_st_rx_pause_length maxChannel 0
    set_interface_property avalon_st_rx_pause_length readyLatency 0
    set_interface_property avalon_st_rx_pause_length ENABLED false

    add_interface_port avalon_st_rx_pause_length avalon_st_rx_pause_length_valid valid Output 1
    add_interface_port avalon_st_rx_pause_length avalon_st_rx_pause_length_data data Output 16

    # 
    # connection point avalon_streaming_source_7
    # 
    add_interface avalon_st_rx_pfc_status avalon_streaming start
    set_interface_property avalon_st_rx_pfc_status associatedClock $rx_associated_clock
    set_interface_property avalon_st_rx_pfc_status dataBitsPerSymbol 8
    set_interface_property avalon_st_rx_pfc_status errorDescriptor ""
    set_interface_property avalon_st_rx_pfc_status firstSymbolInHighOrderBits true
    set_interface_property avalon_st_rx_pfc_status maxChannel 0
    set_interface_property avalon_st_rx_pfc_status readyLatency 0
    set_interface_property avalon_st_rx_pfc_status ENABLED false

    add_interface_port avalon_st_rx_pfc_status avalon_st_rx_pfc_status_valid valid Output 1
    add_interface_port avalon_st_rx_pfc_status avalon_st_rx_pfc_status_data data Output 16

    # 
    # connection point avalon_streaming_source_8
    # 
    add_interface avalon_st_rx_pfc_pause avalon_streaming start
    set_interface_property avalon_st_rx_pfc_pause associatedClock $rx_associated_clock
    set_interface_property avalon_st_rx_pfc_pause dataBitsPerSymbol 8
    set_interface_property avalon_st_rx_pfc_pause errorDescriptor ""
    set_interface_property avalon_st_rx_pfc_pause firstSymbolInHighOrderBits true
    set_interface_property avalon_st_rx_pfc_pause maxChannel 0
    set_interface_property avalon_st_rx_pfc_pause readyLatency 0
    set_interface_property avalon_st_rx_pfc_pause ENABLED false

    add_interface_port avalon_st_rx_pfc_pause avalon_st_rx_pfc_pause_data data Output 8

    # 
    # connection point conduit_end_55
    # 
    add_interface tx_clkena conduit end
    set_interface_property tx_clkena associatedClock ""
    set_interface_property tx_clkena associatedReset ""
    set_interface_property tx_clkena ENABLED false

    add_interface_port tx_clkena tx_clkena export Input 1

    # 
    # connection point conduit_end_19
    # 
    add_interface tx_path_delay_10g conduit end
    set_interface_property tx_path_delay_10g associatedClock ""
    set_interface_property tx_path_delay_10g associatedReset ""
    set_interface_property tx_path_delay_10g ENABLED false

    add_interface_port tx_path_delay_10g tx_path_delay_10g_data data Input 16

    # 
    # connection point conduit_end_20
    # 
    add_interface tx_time_of_day_96b_10g conduit end
    set_interface_property tx_time_of_day_96b_10g associatedClock ""
    set_interface_property tx_time_of_day_96b_10g associatedReset ""
    set_interface_property tx_time_of_day_96b_10g ENABLED false

    add_interface_port tx_time_of_day_96b_10g tx_time_of_day_96b_10g_data data Input 96

    # 
    # connection point conduit_end_21
    # 
    add_interface tx_time_of_day_64b_10g conduit end
    set_interface_property tx_time_of_day_64b_10g associatedClock ""
    set_interface_property tx_time_of_day_64b_10g associatedReset ""
    set_interface_property tx_time_of_day_64b_10g ENABLED false

    add_interface_port tx_time_of_day_64b_10g tx_time_of_day_64b_10g_data data Input 64

    # 
    # connection point conduit_end_22
    # 
    add_interface tx_path_delay_1g conduit end
    set_interface_property tx_path_delay_1g associatedClock ""
    set_interface_property tx_path_delay_1g associatedReset ""
    set_interface_property tx_path_delay_1g ENABLED false

    add_interface_port tx_path_delay_1g tx_path_delay_1g_data data Input 22

    # 
    # connection point conduit_end_23
    # 
    add_interface tx_time_of_day_96b_1g conduit end
    set_interface_property tx_time_of_day_96b_1g associatedClock ""
    set_interface_property tx_time_of_day_96b_1g associatedReset ""
    set_interface_property tx_time_of_day_96b_1g ENABLED false

    add_interface_port tx_time_of_day_96b_1g tx_time_of_day_96b_1g_data data Input 96

    # 
    # connection point conduit_end_24
    # 
    add_interface tx_time_of_day_64b_1g conduit end
    set_interface_property tx_time_of_day_64b_1g associatedClock ""
    set_interface_property tx_time_of_day_64b_1g associatedReset ""
    set_interface_property tx_time_of_day_64b_1g ENABLED false

    add_interface_port tx_time_of_day_64b_1g tx_time_of_day_64b_1g_data data Input 64

    # 
    # connection point conduit_end_25
    # 
    add_interface rx_path_delay_10g conduit end
    set_interface_property rx_path_delay_10g associatedClock ""
    set_interface_property rx_path_delay_10g associatedReset ""
    set_interface_property rx_path_delay_10g ENABLED false

    add_interface_port rx_path_delay_10g rx_path_delay_10g_data data Input 16

    # 
    # connection point conduit_end_26
    # 
    add_interface rx_time_of_day_96b_10g conduit end
    set_interface_property rx_time_of_day_96b_10g associatedClock ""
    set_interface_property rx_time_of_day_96b_10g associatedReset ""
    set_interface_property rx_time_of_day_96b_10g ENABLED false

    add_interface_port rx_time_of_day_96b_10g rx_time_of_day_96b_10g_data data Input 96

    # 
    # connection point conduit_end_27
    # 
    add_interface rx_time_of_day_64b_10g conduit end
    set_interface_property rx_time_of_day_64b_10g associatedClock ""
    set_interface_property rx_time_of_day_64b_10g associatedReset ""
    set_interface_property rx_time_of_day_64b_10g ENABLED false

    add_interface_port rx_time_of_day_64b_10g rx_time_of_day_64b_10g_data data Input 64

    # 
    # connection point conduit_end_28
    # 
    add_interface rx_path_delay_1g conduit end
    set_interface_property rx_path_delay_1g associatedClock ""
    set_interface_property rx_path_delay_1g associatedReset ""
    set_interface_property rx_path_delay_1g ENABLED false

    add_interface_port rx_path_delay_1g rx_path_delay_1g_data data Input 22

    # 
    # connection point conduit_end_29
    # 
    add_interface rx_time_of_day_96b_1g conduit end
    set_interface_property rx_time_of_day_96b_1g associatedClock ""
    set_interface_property rx_time_of_day_96b_1g associatedReset ""
    set_interface_property rx_time_of_day_96b_1g ENABLED false

    add_interface_port rx_time_of_day_96b_1g rx_time_of_day_96b_1g_data data Input 96

    # 
    # connection point conduit_end_30
    # 
    add_interface rx_time_of_day_64b_1g conduit end
    set_interface_property rx_time_of_day_64b_1g associatedClock ""
    set_interface_property rx_time_of_day_64b_1g associatedReset ""
    set_interface_property rx_time_of_day_64b_1g ENABLED false

    add_interface_port rx_time_of_day_64b_1g rx_time_of_day_64b_1g_data data Input 64

    # 
    # connection point conduit_end_31
    # 
    add_interface tx_egress_timestamp_96b conduit end
    set_interface_property tx_egress_timestamp_96b associatedClock ""
    set_interface_property tx_egress_timestamp_96b associatedReset ""
    set_interface_property tx_egress_timestamp_96b ENABLED false

    add_interface_port tx_egress_timestamp_96b tx_egress_timestamp_96b_valid valid Output 1
    add_interface_port tx_egress_timestamp_96b tx_egress_timestamp_96b_data data Output 96
    add_interface_port tx_egress_timestamp_96b tx_egress_timestamp_96b_fingerprint fingerprint Output TSTAMP_FP_WIDTH

    # 
    # connection point conduit_end_34
    # 
    add_interface tx_egress_timestamp_64b conduit end
    set_interface_property tx_egress_timestamp_64b associatedClock ""
    set_interface_property tx_egress_timestamp_64b associatedReset ""
    set_interface_property tx_egress_timestamp_64b ENABLED false

    add_interface_port tx_egress_timestamp_64b tx_egress_timestamp_64b_valid valid Output 1
    add_interface_port tx_egress_timestamp_64b tx_egress_timestamp_64b_data data Output 64
    add_interface_port tx_egress_timestamp_64b tx_egress_timestamp_64b_fingerprint fingerprint Output TSTAMP_FP_WIDTH

    # 
    # connection point conduit_end_37
    # 
    add_interface rx_ingress_timestamp_96b conduit start
    set_interface_property rx_ingress_timestamp_96b associatedClock ""
    set_interface_property rx_ingress_timestamp_96b associatedReset ""
    set_interface_property rx_ingress_timestamp_96b ENABLED false

    add_interface_port rx_ingress_timestamp_96b rx_ingress_timestamp_96b_valid valid Output 1
    add_interface_port rx_ingress_timestamp_96b rx_ingress_timestamp_96b_data data Output 96

    # 
    # connection point conduit_end_39
    # 
    add_interface rx_ingress_timestamp_64b conduit end
    set_interface_property rx_ingress_timestamp_64b associatedClock ""
    set_interface_property rx_ingress_timestamp_64b associatedReset ""
    set_interface_property rx_ingress_timestamp_64b ENABLED false

    add_interface_port rx_ingress_timestamp_64b rx_ingress_timestamp_64b_valid valid Output 1
    add_interface_port rx_ingress_timestamp_64b rx_ingress_timestamp_64b_data data Output 64

    # 
    # connection point conduit_end_41
    # 
    add_interface tx_egress_timestamp_request conduit end
    set_interface_property tx_egress_timestamp_request associatedClock ""
    set_interface_property tx_egress_timestamp_request associatedReset ""
    set_interface_property tx_egress_timestamp_request ENABLED false

    add_interface_port tx_egress_timestamp_request tx_egress_timestamp_request_valid valid Input 1
    add_interface_port tx_egress_timestamp_request tx_egress_timestamp_request_fingerprint fingerprint Input TSTAMP_FP_WIDTH

    # 
    # connection point conduit_end_43
    # 
    add_interface tx_etstamp_ins_ctrl conduit end
    set_interface_property tx_etstamp_ins_ctrl associatedClock ""
    set_interface_property tx_etstamp_ins_ctrl associatedReset ""
    set_interface_property tx_etstamp_ins_ctrl ENABLED false

    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_timestamp_insert timestamp_insert Input 1
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_timestamp_format timestamp_format Input 1
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_residence_time_update residence_time_update Input 1
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_ingress_timestamp_96b ingress_timestamp_96b Input 96
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_ingress_timestamp_64b ingress_timestamp_64b Input 64
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_residence_time_calc_format residence_time_calc_format Input 1
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_checksum_zero checksum_zero Input 1
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_checksum_correct checksum_correct Input 1
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_offset_timestamp offset_timestamp Input 16
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_offset_correction_field offset_correction_field Input 16
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_offset_checksum_field offset_checksum_field Input 16
    add_interface_port tx_etstamp_ins_ctrl tx_etstamp_ins_ctrl_offset_checksum_correction offset_checksum_correction Input 16
    
    # 
    # connection point conduit_end_55
    # 
    add_interface tx_egress_asymmetry conduit end
    set_interface_property tx_egress_asymmetry associatedClock ""
    set_interface_property tx_egress_asymmetry associatedReset ""
    set_interface_property tx_egress_asymmetry ENABLED false

    add_interface_port tx_egress_asymmetry tx_egress_asymmetry_update update Input 1
    
    add_interface ecc_err_det conduit start
    set_interface_property ecc_err_det associatedClock ""
    set_interface_property ecc_err_det associatedReset ""
    set_interface_property ecc_err_det ENABLED false

    add_interface_port ecc_err_det ecc_err_det_corr corr Output 1
    add_interface_port ecc_err_det ecc_err_det_uncorr uncorr Output 1
}


proc enable_basic_clk_reset_csr {} {
    set_interface_property tx_312_5_clk ENABLED true
    set_interface_property rx_312_5_clk ENABLED true
    set_interface_property csr_clk ENABLED true
    set_interface_property csr_rst_n ENABLED true
    set_interface_property tx_rst_n ENABLED true
    set_interface_property rx_rst_n ENABLED true
    set_interface_property csr ENABLED true
}

proc disable_basic_312_5_clk {} {
    set_interface_property tx_312_5_clk ENABLED false
    set_interface_property rx_312_5_clk ENABLED false

    set_port_property tx_312_5_clk DRIVEN_BY 0
    set_port_property tx_312_5_clk TERMINATION true
    set_port_property tx_312_5_clk TERMINATION_VALUE 0

    set_port_property rx_312_5_clk DRIVEN_BY 0
    set_port_property rx_312_5_clk TERMINATION true
    set_port_property rx_312_5_clk TERMINATION_VALUE 0
}

proc enable_xcvr_clk {} {
    set_interface_property rx_xcvr_clk ENABLED true 
    set_interface_property tx_xcvr_clk ENABLED true 
    set_interface_property tx_rst_n associatedClock tx_xcvr_clk
    set_interface_property rx_rst_n associatedClock rx_xcvr_clk
}

proc terminate_xgmii {} {
    set_interface_property xgmii_rx ENABLED false
    set_interface_property xgmii_tx ENABLED false

    set_port_property xgmii_tx DRIVEN_BY 0
    set_port_property xgmii_tx TERMINATION true
    set_port_property xgmii_tx TERMINATION_VALUE 0

    set_port_property xgmii_rx DRIVEN_BY 0
    set_port_property xgmii_rx TERMINATION true
    set_port_property xgmii_rx TERMINATION_VALUE 0
}

proc inst_xgmii_valid {} {

    set_interface_property xgmii_tx_valid associatedClock tx_312_5_clk
    set_interface_property xgmii_tx_valid associatedReset tx_rst_n
    set_interface_property xgmii_tx_valid ENABLED true  

    set_interface_property xgmii_rx_valid associatedClock tx_312_5_clk
    set_interface_property xgmii_rx_valid associatedReset rx_rst_n
    set_interface_property xgmii_rx_valid ENABLED true

	set_interface_property speed_sel ENABLED true
    set_port_property speed_sel WIDTH_EXPR 3

}

proc terminate_xgmii_valid {} {

    # termination valid is 1. so that the remaining logic will work properly. 
    set_port_property xgmii_tx_valid DRIVEN_BY 0
    set_port_property xgmii_tx_valid TERMINATION true
    set_port_property xgmii_tx_valid TERMINATION_VALUE 1

    # termination valid is 1. so that the remaining logic will work properly. 
    set_port_property xgmii_rx_valid DRIVEN_BY 0
    set_port_property xgmii_rx_valid TERMINATION true
    set_port_property xgmii_rx_valid TERMINATION_VALUE 1

}


proc inst_ultra_low_latency {} {
    #xgmii
    set_interface_property xgmii_tx_valid associatedClock tx_xcvr_clk
    set_interface_property xgmii_tx_valid associatedReset tx_rst_n
    set_interface_property xgmii_tx_valid ENABLED true

    set_interface_property xgmii_tx_data associatedClock tx_xcvr_clk
    set_interface_property xgmii_tx_data associatedReset tx_rst_n
    set_interface_property xgmii_tx_data ENABLED true
    set_port_property xgmii_tx_data WIDTH_EXPR 64

    set_interface_property xgmii_tx_control associatedClock tx_xcvr_clk
    set_interface_property xgmii_tx_control associatedReset tx_rst_n
    set_interface_property xgmii_tx_control ENABLED true
    set_port_property xgmii_tx_control WIDTH_EXPR 8

    set_interface_property xgmii_rx_valid associatedClock rx_xcvr_clk
    set_interface_property xgmii_rx_valid associatedReset rx_rst_n
    set_interface_property xgmii_rx_valid ENABLED true

    set_interface_property xgmii_rx_data associatedClock rx_xcvr_clk
    set_interface_property xgmii_rx_data associatedReset rx_rst_n
    set_interface_property xgmii_rx_data ENABLED true
    set_port_property xgmii_rx_data WIDTH_EXPR 64

    set_interface_property xgmii_rx_control associatedClock rx_xcvr_clk
    set_interface_property xgmii_rx_control associatedReset rx_rst_n
    set_interface_property xgmii_rx_control ENABLED true
    set_port_property xgmii_rx_control WIDTH_EXPR 8

    #ST
    set_interface_property avalon_st_tx ENABLED true
    set_interface_property avalon_st_tx associatedClock tx_xcvr_clk
    set_interface_property avalon_st_tx associatedReset tx_rst_n
    set_port_property avalon_st_tx_data WIDTH_EXPR 32
    set_port_property avalon_st_tx_empty WIDTH_EXPR 2

    set_interface_property avalon_st_pause ENABLED true
    set_interface_property avalon_st_pause associatedClock tx_xcvr_clk
    set_interface_property avalon_st_pause associatedReset tx_rst_n

    set_interface_property avalon_st_txstatus ENABLED true
    set_interface_property avalon_st_txstatus associatedClock tx_xcvr_clk
    set_interface_property avalon_st_txstatus associatedReset tx_rst_n

    set_interface_property link_fault_status_xgmii_rx ENABLED true
    set_interface_property link_fault_status_xgmii_rx associatedClock rx_xcvr_clk
    set_interface_property link_fault_status_xgmii_rx associatedReset rx_rst_n

    set_interface_property avalon_st_rx ENABLED true
    set_interface_property avalon_st_rx associatedClock rx_xcvr_clk
    set_interface_property avalon_st_rx associatedReset rx_rst_n
    set_port_property avalon_st_rx_data WIDTH_EXPR 32
    set_port_property avalon_st_rx_empty WIDTH_EXPR 2

    set_interface_property avalon_st_rxstatus ENABLED true
    set_interface_property avalon_st_rxstatus associatedClock rx_xcvr_clk
    set_interface_property avalon_st_rxstatus associatedReset rx_rst_n
}

proc inst_st_or_xgmii_adapter {} {
    set_interface_property tx_156_25_clk ENABLED true
    set_interface_property rx_156_25_clk ENABLED true
}

proc inst_xgmii_adapter {} {
    set_interface_property xgmii_tx associatedClock tx_156_25_clk
    set_interface_property xgmii_tx associatedReset tx_rst_n
    set_interface_property xgmii_tx ENABLED true

    set_interface_property xgmii_rx associatedClock rx_156_25_clk
    set_interface_property xgmii_rx associatedReset rx_rst_n
    set_interface_property xgmii_rx ENABLED true

    set_port_property xgmii_tx_data DRIVEN_BY 0
    set_port_property xgmii_tx_data TERMINATION true
    set_port_property xgmii_tx_data TERMINATION_VALUE 0 

    set_port_property xgmii_tx_control DRIVEN_BY 0
    set_port_property xgmii_tx_control TERMINATION true
    set_port_property xgmii_tx_control TERMINATION_VALUE 0 

    set_port_property xgmii_rx_data DRIVEN_BY 0
    set_port_property xgmii_rx_data TERMINATION true
    set_port_property xgmii_rx_data TERMINATION_VALUE 0 

    set_port_property xgmii_rx_control DRIVEN_BY 0
    set_port_property xgmii_rx_control TERMINATION true
    set_port_property xgmii_rx_control TERMINATION_VALUE 0 
}

proc wo_inst_xgmii_adapter {} {
    set_interface_property xgmii_tx_data ENABLED true
    set_interface_property xgmii_tx_control ENABLED true

    set_interface_property xgmii_rx_data ENABLED true
    set_interface_property xgmii_rx_control ENABLED true

    set_port_property xgmii_tx DRIVEN_BY 0
    set_port_property xgmii_tx TERMINATION true
    set_port_property xgmii_tx TERMINATION_VALUE 0 

    set_port_property xgmii_rx DRIVEN_BY 0
    set_port_property xgmii_rx TERMINATION true
    set_port_property xgmii_rx TERMINATION_VALUE 0 
}

proc use_async_adaptor_1588 {} {
    set_interface_property latency_measure_sampling_clk ENABLED true
}

proc no_use_async_adaptor_1588 {} {
    set_interface_property latency_measure_sampling_clk ENABLED false

    set_port_property latency_measure_sampling_clk DRIVEN_BY 0
    set_port_property latency_measure_sampling_clk TERMINATION true
    set_port_property latency_measure_sampling_clk TERMINATION_VALUE 0
}

proc inst_st_adaptor {} {
    set ENABLE_1G10G_MAC [get_parameter_value ENABLE_1G10G_MAC]

    set_interface_property avalon_st_tx associatedClock tx_156_25_clk
    set_interface_property avalon_st_tx associatedReset tx_rst_n
    set_interface_property avalon_st_tx ENABLED true

    set_interface_property avalon_st_pause associatedClock tx_156_25_clk
    set_interface_property avalon_st_pause associatedReset tx_rst_n
    set_interface_property avalon_st_pause ENABLED true

    set_interface_property avalon_st_txstatus associatedClock tx_156_25_clk
    set_interface_property avalon_st_txstatus associatedReset tx_rst_n
    set_interface_property avalon_st_txstatus ENABLED true

    # RX link fault is not used for 1G/2.5G speed mode
    if {$ENABLE_1G10G_MAC != 3} {
        set_interface_property link_fault_status_xgmii_rx associatedClock rx_156_25_clk
        set_interface_property link_fault_status_xgmii_rx associatedReset rx_rst_n
        set_interface_property link_fault_status_xgmii_rx ENABLED true
    }

    set_interface_property avalon_st_rx associatedClock rx_156_25_clk
    set_interface_property avalon_st_rx associatedReset rx_rst_n
    set_interface_property avalon_st_rx ENABLED true

    set_interface_property avalon_st_rxstatus associatedClock rx_156_25_clk
    set_interface_property avalon_st_rxstatus associatedReset rx_rst_n
    set_interface_property avalon_st_rxstatus ENABLED true
}

proc wo_inst_st_adaptor {} {
    set ENABLE_1G10G_MAC [get_parameter_value ENABLE_1G10G_MAC]
    
    set tx_associated_clock tx_312_5_clk
    set rx_associated_clock rx_312_5_clk
    
    if {$ENABLE_1G10G_MAC == 3} {
        set tx_associated_clock tx_156_25_clk
        set rx_associated_clock rx_156_25_clk
    }
    
    set_interface_property avalon_st_tx associatedClock $tx_associated_clock
    set_interface_property avalon_st_tx associatedReset tx_rst_n
    set_interface_property avalon_st_tx ENABLED true
    set_port_property avalon_st_tx_data WIDTH_EXPR 32
    set_port_property avalon_st_tx_empty WIDTH_EXPR 2

    set_interface_property avalon_st_pause associatedClock $tx_associated_clock
    set_interface_property avalon_st_pause associatedReset tx_rst_n
    set_interface_property avalon_st_pause ENABLED true

    set_interface_property avalon_st_txstatus associatedClock $tx_associated_clock
    set_interface_property avalon_st_txstatus associatedReset tx_rst_n
    set_interface_property avalon_st_txstatus ENABLED true

    # RX link fault is not used for 1G/2.5G speed mode
    if {$ENABLE_1G10G_MAC != 3} {
        set_interface_property link_fault_status_xgmii_rx associatedClock rx_312_5_clk
        set_interface_property link_fault_status_xgmii_rx associatedReset rx_rst_n
        set_interface_property link_fault_status_xgmii_rx ENABLED true
    }

    set_interface_property avalon_st_rx associatedClock $rx_associated_clock
    set_interface_property avalon_st_rx associatedReset rx_rst_n
    set_interface_property avalon_st_rx ENABLED true
    set_port_property avalon_st_rx_data WIDTH_EXPR 32
    set_port_property avalon_st_rx_empty WIDTH_EXPR 2

    set_interface_property avalon_st_rxstatus associatedClock $rx_associated_clock
    set_interface_property avalon_st_rxstatus associatedReset rx_rst_n
    set_interface_property avalon_st_rxstatus ENABLED true
}

proc wo_inst_csr_adaptor {} {
    set_port_property csr_address WIDTH_EXPR 10
}

proc inst_csr_adaptor {} {
    set_port_property csr_address WIDTH_EXPR 13
}

proc inst_enable_1g10g {} {
    set_interface_property speed_sel ENABLED true
    set_interface_property gmii_tx_clk ENABLED true
    set_interface_property gmii_tx_d ENABLED true
    set_interface_property gmii_tx_en ENABLED true
    set_interface_property gmii_tx_err ENABLED true

    set_port_property tx_clkena DRIVEN_BY 1
    set_port_property tx_clkena TERMINATION true
    set_port_property tx_clkena TERMINATION_VALUE 1 

    set_port_property tx_clkena_half_rate DRIVEN_BY 1
    set_port_property tx_clkena_half_rate TERMINATION true
    set_port_property tx_clkena_half_rate TERMINATION_VALUE 1 

    set_interface_property gmii_rx_clk ENABLED true
    set_interface_property gmii_rx_d ENABLED true
    set_interface_property gmii_rx_dv ENABLED true
    set_interface_property gmii_rx_err ENABLED true

    set_port_property rx_clkena DRIVEN_BY 1
    set_port_property rx_clkena TERMINATION true
    set_port_property rx_clkena TERMINATION_VALUE 1 

    set_port_property rx_clkena_half_rate DRIVEN_BY 1
    set_port_property rx_clkena_half_rate TERMINATION true
    set_port_property rx_clkena_half_rate TERMINATION_VALUE 1 
}

proc inst_enable_multi_speed {} {
    set_interface_property speed_sel ENABLED true
    set_interface_property gmii_tx_clk ENABLED true
    set_interface_property gmii_tx_d ENABLED true
    set_interface_property gmii_tx_en ENABLED true
    set_interface_property gmii_tx_err ENABLED true
    set_interface_property mii_tx_d ENABLED true
    set_interface_property mii_tx_en ENABLED true
    set_interface_property mii_tx_err ENABLED true

    set_interface_property tx_clkena ENABLED true
    set_interface_property tx_clkena_half_rate ENABLED true

    set_interface_property gmii_rx_clk ENABLED true
    set_interface_property gmii_rx_d ENABLED true
    set_interface_property gmii_rx_dv ENABLED true
    set_interface_property gmii_rx_err ENABLED true
    set_interface_property mii_rx_d ENABLED true
    set_interface_property mii_rx_dv ENABLED true
    set_interface_property mii_rx_err ENABLED true

    set_interface_property rx_clkena ENABLED true
    set_interface_property rx_clkena_half_rate ENABLED true
}

proc inst_enable_gmii16b {} {
    set_interface_property speed_sel ENABLED true
    set_port_property speed_sel WIDTH_EXPR 3

    set_interface_property gmii16b_tx_clk ENABLED true
    set_interface_property gmii16b_tx_d ENABLED true
    set_interface_property gmii16b_tx_en ENABLED true
    set_interface_property gmii16b_tx_err ENABLED true

    set_interface_property gmii16b_rx_clk ENABLED true
    set_interface_property gmii16b_rx_d ENABLED true
    set_interface_property gmii16b_rx_dv ENABLED true
    set_interface_property gmii16b_rx_err ENABLED true
}

proc terminate_gmii16b {} {
    set_port_property gmii16b_tx_clk DRIVEN_BY 0
    set_port_property gmii16b_tx_clk TERMINATION true
    set_port_property gmii16b_tx_clk TERMINATION_VALUE 0
    
    set_port_property gmii16b_tx_d TERMINATION true
    
    set_port_property gmii16b_tx_en TERMINATION true
    
    set_port_property gmii16b_tx_err TERMINATION true
    
    set_port_property gmii16b_rx_clk DRIVEN_BY 0
    set_port_property gmii16b_rx_clk TERMINATION true
    set_port_property gmii16b_rx_clk TERMINATION_VALUE 0
    
    set_port_property gmii16b_rx_d DRIVEN_BY 0
    set_port_property gmii16b_rx_d TERMINATION true
    set_port_property gmii16b_rx_d TERMINATION_VALUE 0

    set_port_property gmii16b_rx_dv DRIVEN_BY 0
    set_port_property gmii16b_rx_dv TERMINATION true
    set_port_property gmii16b_rx_dv TERMINATION_VALUE 0

    set_port_property gmii16b_rx_err DRIVEN_BY 0
    set_port_property gmii16b_rx_err TERMINATION true
    set_port_property gmii16b_rx_err TERMINATION_VALUE 0
}

proc terminate_mii {} {
    set_port_property mii_tx_d DRIVEN_BY 0
    set_port_property mii_tx_d TERMINATION true
    set_port_property mii_tx_d TERMINATION_VALUE 0 

    set_port_property mii_tx_en DRIVEN_BY 0
    set_port_property mii_tx_en TERMINATION true
    set_port_property mii_tx_en TERMINATION_VALUE 0

    set_port_property mii_tx_err DRIVEN_BY 0
    set_port_property mii_tx_err TERMINATION true
    set_port_property mii_tx_err TERMINATION_VALUE 0 

    set_port_property mii_rx_d DRIVEN_BY 0
    set_port_property mii_rx_d TERMINATION true
    set_port_property mii_rx_d TERMINATION_VALUE 0 

    set_port_property mii_rx_dv DRIVEN_BY 0
    set_port_property mii_rx_dv TERMINATION true
    set_port_property mii_rx_dv TERMINATION_VALUE 0 

    set_port_property mii_rx_err DRIVEN_BY 0
    set_port_property mii_rx_err TERMINATION true
    set_port_property mii_rx_err TERMINATION_VALUE 0 
}

proc terminate_gmii_mii {} {
    set_port_property speed_sel DRIVEN_BY 0
    set_port_property speed_sel TERMINATION true
    set_port_property speed_sel TERMINATION_VALUE 0 

    set_port_property gmii_tx_clk DRIVEN_BY 0
    set_port_property gmii_tx_clk TERMINATION true
    set_port_property gmii_tx_clk TERMINATION_VALUE 0 

    set_port_property gmii_tx_d DRIVEN_BY 0
    set_port_property gmii_tx_d TERMINATION true
    set_port_property gmii_tx_d TERMINATION_VALUE 0

    set_port_property gmii_tx_en DRIVEN_BY 0
    set_port_property gmii_tx_en TERMINATION true
    set_port_property gmii_tx_en TERMINATION_VALUE 0 

    set_port_property gmii_tx_err DRIVEN_BY 0
    set_port_property gmii_tx_err TERMINATION true
    set_port_property gmii_tx_err TERMINATION_VALUE 0 

    set_port_property mii_tx_d DRIVEN_BY 0
    set_port_property mii_tx_d TERMINATION true
    set_port_property mii_tx_d TERMINATION_VALUE 0 

    set_port_property mii_tx_en DRIVEN_BY 0
    set_port_property mii_tx_en TERMINATION true
    set_port_property mii_tx_en TERMINATION_VALUE 0

    set_port_property mii_tx_err DRIVEN_BY 0
    set_port_property mii_tx_err TERMINATION true
    set_port_property mii_tx_err TERMINATION_VALUE 0    

    set_port_property tx_clkena DRIVEN_BY 1
    set_port_property tx_clkena TERMINATION true
    set_port_property tx_clkena TERMINATION_VALUE 1 

    set_port_property tx_clkena_half_rate DRIVEN_BY 1
    set_port_property tx_clkena_half_rate TERMINATION true
    set_port_property tx_clkena_half_rate TERMINATION_VALUE 1 

    set_port_property gmii_rx_clk DRIVEN_BY 0
    set_port_property gmii_rx_clk TERMINATION true
    set_port_property gmii_rx_clk TERMINATION_VALUE 0

    set_port_property gmii_rx_d DRIVEN_BY 0
    set_port_property gmii_rx_d TERMINATION true
    set_port_property gmii_rx_d TERMINATION_VALUE 0

    set_port_property gmii_rx_dv DRIVEN_BY 0
    set_port_property gmii_rx_dv TERMINATION true
    set_port_property gmii_rx_dv TERMINATION_VALUE 0

    set_port_property gmii_rx_err DRIVEN_BY 0
    set_port_property gmii_rx_err TERMINATION true
    set_port_property gmii_rx_err TERMINATION_VALUE 0

    set_port_property mii_rx_d DRIVEN_BY 0
    set_port_property mii_rx_d TERMINATION true
    set_port_property mii_rx_d TERMINATION_VALUE 0

    set_port_property mii_rx_dv DRIVEN_BY 0
    set_port_property mii_rx_dv TERMINATION true
    set_port_property mii_rx_dv TERMINATION_VALUE 0

    set_port_property mii_rx_err DRIVEN_BY 0
    set_port_property mii_rx_err TERMINATION true
    set_port_property mii_rx_err TERMINATION_VALUE 0

    set_port_property rx_clkena DRIVEN_BY 1
    set_port_property rx_clkena TERMINATION true
    set_port_property rx_clkena TERMINATION_VALUE 1

    set_port_property rx_clkena_half_rate DRIVEN_BY 1
    set_port_property rx_clkena_half_rate TERMINATION true
    set_port_property rx_clkena_half_rate TERMINATION_VALUE 1
}

proc inst_pfc {tx_clk rx_clk} {
    set_interface_property avalon_st_tx_pfc_gen_data associatedClock "$tx_clk"
    set_interface_property avalon_st_tx_pfc_gen_data ENABLED true

    set_interface_property avalon_st_tx_pfc_status associatedClock $tx_clk
    set_interface_property avalon_st_tx_pfc_status ENABLED true

    set_interface_property avalon_st_rx_pfc_status associatedClock $rx_clk
    set_interface_property avalon_st_rx_pfc_status ENABLED true

    set_interface_property avalon_st_rx_pfc_pause associatedClock $rx_clk
    set_interface_property avalon_st_rx_pfc_pause ENABLED true
}

proc terminate_pfc {} {
    terminate_tx_path_pfc
    terminate_rx_path_pfc
}

proc inst_tx_data_path_only {tx_clk} {
    set_interface_property avalon_st_tx_pause_length associatedClock $tx_clk
    set_interface_property avalon_st_tx_pause_length associatedReset tx_rst_n
    set_interface_property avalon_st_tx_pause_length ENABLED true
}

proc inst_xgmii_tx_data_path_only {tx_clk} {
    set_interface_property link_fault_status_xgmii_tx associatedClock $tx_clk
    set_interface_property link_fault_status_xgmii_tx ENABLED true
}


proc terminate_rx_path {} {
    #terminate clock and reset
    set_interface_property rx_312_5_clk ENABLED false
    set_interface_property rx_156_25_clk ENABLED false
    set_interface_property rx_rst_n ENABLED false

    set_port_property rx_312_5_clk DRIVEN_BY 0
    set_port_property rx_312_5_clk TERMINATION true
    set_port_property rx_312_5_clk TERMINATION_VALUE 0

    set_port_property rx_156_25_clk DRIVEN_BY 0
    set_port_property rx_156_25_clk TERMINATION true
    set_port_property rx_156_25_clk TERMINATION_VALUE 0

    set_port_property rx_rst_n DRIVEN_BY 0
    set_port_property rx_rst_n TERMINATION true
    set_port_property rx_rst_n TERMINATION_VALUE 0

    #terminate ports
    set_interface_property avalon_st_rx ENABLED false
    set_interface_property avalon_st_rxstatus ENABLED false
    set_interface_property xgmii_rx ENABLED false
    set_interface_property xgmii_rx_control ENABLED false
    set_interface_property link_fault_status_xgmii_rx ENABLED false

    set_port_property avalon_st_rx_data DRIVEN_BY 0
    set_port_property avalon_st_rx_data TERMINATION true
    set_port_property avalon_st_rx_data TERMINATION_VALUE 0

    set_port_property avalon_st_rx_startofpacket DRIVEN_BY 0
    set_port_property avalon_st_rx_startofpacket TERMINATION true
    set_port_property avalon_st_rx_startofpacket TERMINATION_VALUE 0

    set_port_property avalon_st_rx_valid DRIVEN_BY 0
    set_port_property avalon_st_rx_valid TERMINATION true
    set_port_property avalon_st_rx_valid TERMINATION_VALUE 0

    set_port_property avalon_st_rx_empty DRIVEN_BY 0
    set_port_property avalon_st_rx_empty TERMINATION true
    set_port_property avalon_st_rx_empty TERMINATION_VALUE 0

    set_port_property avalon_st_rx_error DRIVEN_BY 0
    set_port_property avalon_st_rx_error TERMINATION true
    set_port_property avalon_st_rx_error TERMINATION_VALUE 0

    set_port_property avalon_st_rx_ready DRIVEN_BY 0
    set_port_property avalon_st_rx_ready TERMINATION true
    set_port_property avalon_st_rx_ready TERMINATION_VALUE 0

    set_port_property avalon_st_rx_endofpacket DRIVEN_BY 0
    set_port_property avalon_st_rx_endofpacket TERMINATION true
    set_port_property avalon_st_rx_endofpacket TERMINATION_VALUE 0


    set_port_property avalon_st_rxstatus_valid DRIVEN_BY 0
    set_port_property avalon_st_rxstatus_valid TERMINATION true
    set_port_property avalon_st_rxstatus_valid TERMINATION_VALUE 0

    set_port_property avalon_st_rxstatus_data DRIVEN_BY 0
    set_port_property avalon_st_rxstatus_data TERMINATION true
    set_port_property avalon_st_rxstatus_data TERMINATION_VALUE 0

    set_port_property avalon_st_rxstatus_error DRIVEN_BY 0
    set_port_property avalon_st_rxstatus_error TERMINATION true
    set_port_property avalon_st_rxstatus_error TERMINATION_VALUE 0

    set_port_property xgmii_rx_data DRIVEN_BY 0
    set_port_property xgmii_rx_data TERMINATION true
    set_port_property xgmii_rx_data TERMINATION_VALUE 0

    set_port_property xgmii_rx_control DRIVEN_BY 0
    set_port_property xgmii_rx_control TERMINATION true
    set_port_property xgmii_rx_control TERMINATION_VALUE 0

    set_port_property link_fault_status_xgmii_rx_data DRIVEN_BY 0
    set_port_property link_fault_status_xgmii_rx_data TERMINATION true
    set_port_property link_fault_status_xgmii_rx_data TERMINATION_VALUE 0
}

proc inst_ecc {} {
    set_interface_property ecc_err_det ENABLED true
}

proc wo_inst_ecc {} {
    set_interface_property ecc_err_det ENABLED false
}

proc inst_rx_data_path_only {rx_clk} {
    set_interface_property avalon_st_rx_pause_length associatedClock $rx_clk
    set_interface_property avalon_st_rx_pause_length ENABLED true
}

proc terminate_tx_path_pfc {} {
    set_port_property avalon_st_tx_pfc_gen_data DRIVEN_BY 0
    set_port_property avalon_st_tx_pfc_gen_data TERMINATION true
    set_port_property avalon_st_tx_pfc_gen_data TERMINATION_VALUE 0

    set_port_property avalon_st_tx_pfc_status_valid DRIVEN_BY 0
    set_port_property avalon_st_tx_pfc_status_valid TERMINATION true
    set_port_property avalon_st_tx_pfc_status_valid TERMINATION_VALUE 0

    set_port_property avalon_st_tx_pfc_status_data DRIVEN_BY 0
    set_port_property avalon_st_tx_pfc_status_data TERMINATION true
    set_port_property avalon_st_tx_pfc_status_data TERMINATION_VALUE 0
}

proc terminate_rx_path_pfc {} {
    set_port_property avalon_st_rx_pfc_status_valid DRIVEN_BY 0
    set_port_property avalon_st_rx_pfc_status_valid TERMINATION true
    set_port_property avalon_st_rx_pfc_status_valid TERMINATION_VALUE 0

    set_port_property avalon_st_rx_pfc_status_data DRIVEN_BY 0
    set_port_property avalon_st_rx_pfc_status_data TERMINATION true
    set_port_property avalon_st_rx_pfc_status_data TERMINATION_VALUE 0

    set_port_property avalon_st_rx_pfc_pause_data DRIVEN_BY 0
    set_port_property avalon_st_rx_pfc_pause_data TERMINATION true
    set_port_property avalon_st_rx_pfc_pause_data TERMINATION_VALUE 0

}

proc terminate_tx_path {} {
    #terminate clock and reset
    set_interface_property tx_312_5_clk ENABLED false
    set_interface_property tx_156_25_clk ENABLED false
    set_interface_property tx_rst_n ENABLED false

    set_port_property tx_312_5_clk DRIVEN_BY 0
    set_port_property tx_312_5_clk TERMINATION true
    set_port_property tx_312_5_clk TERMINATION_VALUE 0

    set_port_property tx_156_25_clk DRIVEN_BY 0
    set_port_property tx_156_25_clk TERMINATION true
    set_port_property tx_156_25_clk TERMINATION_VALUE 0

    set_port_property tx_rst_n DRIVEN_BY 0
    set_port_property tx_rst_n TERMINATION true
    set_port_property tx_rst_n TERMINATION_VALUE 0

    #terminate ports
    set_interface_property avalon_st_tx ENABLED false
    set_port_property avalon_st_tx_startofpacket DRIVEN_BY 0
    set_port_property avalon_st_tx_startofpacket TERMINATION true
    set_port_property avalon_st_tx_startofpacket TERMINATION_VALUE 0

    set_port_property avalon_st_tx_endofpacket DRIVEN_BY 0
    set_port_property avalon_st_tx_endofpacket TERMINATION true
    set_port_property avalon_st_tx_endofpacket TERMINATION_VALUE 0

    set_port_property avalon_st_tx_valid DRIVEN_BY 0
    set_port_property avalon_st_tx_valid TERMINATION true
    set_port_property avalon_st_tx_valid TERMINATION_VALUE 0

    set_port_property avalon_st_tx_data DRIVEN_BY 0
    set_port_property avalon_st_tx_data TERMINATION true
    set_port_property avalon_st_tx_data TERMINATION_VALUE 0

    set_port_property avalon_st_tx_empty DRIVEN_BY 0
    set_port_property avalon_st_tx_empty TERMINATION true
    set_port_property avalon_st_tx_empty TERMINATION_VALUE 0

    set_port_property avalon_st_tx_error DRIVEN_BY 0
    set_port_property avalon_st_tx_error TERMINATION true
    set_port_property avalon_st_tx_error TERMINATION_VALUE 0

    set_port_property avalon_st_tx_ready DRIVEN_BY 0
    set_port_property avalon_st_tx_ready TERMINATION true
    set_port_property avalon_st_tx_ready TERMINATION_VALUE 0

    set_interface_property avalon_st_txstatus ENABLED false
    set_port_property avalon_st_txstatus_valid DRIVEN_BY 0
    set_port_property avalon_st_txstatus_valid TERMINATION true
    set_port_property avalon_st_txstatus_valid TERMINATION_VALUE 0

    set_port_property avalon_st_txstatus_data DRIVEN_BY 0
    set_port_property avalon_st_txstatus_data TERMINATION true
    set_port_property avalon_st_txstatus_data TERMINATION_VALUE 0

    set_port_property avalon_st_txstatus_error DRIVEN_BY 0
    set_port_property avalon_st_txstatus_error TERMINATION true
    set_port_property avalon_st_txstatus_error TERMINATION_VALUE 0

    set_interface_property avalon_st_pause ENABLED false
    set_port_property avalon_st_pause_data DRIVEN_BY 0
    set_port_property avalon_st_pause_data TERMINATION true
    set_port_property avalon_st_pause_data TERMINATION_VALUE 0

    set_interface_property xgmii_tx ENABLED false
    set_port_property xgmii_tx_data DRIVEN_BY 0
    set_port_property xgmii_tx_data TERMINATION true
    set_port_property xgmii_tx_data TERMINATION_VALUE 0

    set_interface_property xgmii_tx_control ENABLED false
    set_port_property xgmii_tx_control DRIVEN_BY 0
    set_port_property xgmii_tx_control TERMINATION true
    set_port_property xgmii_tx_control TERMINATION_VALUE 0

    set_interface_property link_fault_status_xgmii_tx ENABLED false
    set_port_property link_fault_status_xgmii_tx_data DRIVEN_BY 0
    set_port_property link_fault_status_xgmii_tx_data TERMINATION true
    set_port_property link_fault_status_xgmii_tx_data TERMINATION_VALUE 0
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.intel.com/content/www/us/en/programmable/documentation/bhc1395127830032.html
add_documentation_link "Release Notes" https://www.intel.com/content/www/us/en/programmable/documentation/hco1421697864914.html
add_documentation_link "Example Design User Guide" https://www.intel.com/content/www/us/en/programmable/documentation/nfa1438753448747.html

