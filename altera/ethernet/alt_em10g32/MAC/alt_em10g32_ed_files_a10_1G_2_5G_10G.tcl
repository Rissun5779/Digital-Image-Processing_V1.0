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


set ed_files_a10_1g_2_5g_10g {

    rtl/phy                     alt_mgbaset_phy                     qsys_standalone
    rtl/address_decoder         alt_mge_rd_addrdec_mch              qsys_system
    rtl/address_decoder         alt_mge_rd_avmm_mux_xcvr_rcfg       qsys_system
    rtl/jtag_avalon_master      alt_jtag_csr_master                 qsys_standalone
    rtl/pll_atxpll              alt_mge_xcvr_atx_pll_10g            qsys_standalone
    rtl/pll_atxpll              alt_mge_xcvr_atx_pll_2p5g           qsys_standalone
    rtl/pll_fpll                alt_mge_core_pll                    qsys_standalone
    rtl/pll_fpll                alt_mge_xcvr_fpll_1g                qsys_standalone
    rtl/xcvr_reset_controller   alt_mge_xcvr_reset_ctrl_channel     qsys_standalone
    rtl/xcvr_reset_controller   alt_mge_xcvr_reset_ctrl_txpll       qsys_standalone
    rtl/mac                     alt_mgbaset_mac                     qsys_standalone

}

set synth_sim_a10_1g_2_5g_10g {

    VERILOG         reconfig/alt_mge_rcfg_a10_ch_recal.v
    VERILOG         reconfig/alt_mge_rcfg_a10_mif_master.v
    VERILOG         reconfig/alt_mge_rcfg_a10_mif_rom.v                  
    VERILOG         reconfig/alt_mge_rcfg_a10_rxcdr_switch.v       
    SYSTEM_VERILOG  reconfig/alt_mge_rcfg_a10.sv                    
    VERILOG         reconfig/alt_mge_rcfg_a10_txpll_switch.v                
    MIF             reconfig/alt_mge_rcfg_a10_xcvr_10g.mif       
    MIF             reconfig/alt_mge_rcfg_a10_xcvr_1g.mif         
    MIF             reconfig/alt_mge_rcfg_a10_xcvr_2p5g.mif      
    VERILOG         alt_mge_channel.v
    VERILOG         alt_mge_reset_synchronizer.v
    SYSTEM_VERILOG  alt_mge_rd.sv
    VERILOG         ethernet_traffic_controller/avalon_st_rx_32b_to_64b.v
    VERILOG         ethernet_traffic_controller/avalon_st_tx_64b_to_32b.v
    VERILOG         ethernet_traffic_controller/avl_st_mux.sv
    VERILOG         ethernet_traffic_controller/avl_st_sel_csr.v
    SYSTEM_VERILOG  ethernet_traffic_controller/eth_traffic_controller_32b_top.sv
    OTHER           ethernet_traffic_controller/eth_traffic_controller_top.qip
    SYSTEM_VERILOG  ethernet_traffic_controller/eth_traffic_controller_top.sv
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/eth_1588_traffic_controller_top.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_avg.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_initial.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_master_pkt_gen.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_master_pkt_rcv.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_master.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_pkt_gen.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_pkt_rcv.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_ram.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_slave_compute.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_slave_pkt_gen.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_slave_pkt_rcv.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_slave.v
    VERILOG         ethernet_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/traffic_controller_1588.sv
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/altera_avalon_sc_fifo.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/avalon_st_gen.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/avalon_st_loopback_csr.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/avalon_st_loopback.sv
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/avalon_st_mon.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/avalon_st_prtmux.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/eth_std_traffic_controller_top.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/shiftreg_ctrl.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/shiftreg_data.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/avalon_st_to_crc_if_bridge.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/bit_endian_converter.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/byte_endian_converter.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_calculator.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_chk.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_gen.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32.qip
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc_checksum_aligner.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc_comparator.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat16.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat24.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat32_any_byte.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat32.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat40.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat48.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat56.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat64_any_byte.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat64.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat8.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc_ethernet.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc_register.v
    VERILOG         ethernet_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/xor6.v
}

set hardware_a10_1g_2_5g_10g {

    OTHER           system_console/channel_setting.tcl
    OTHER           system_console/main.tcl
    OTHER           system_console/system_base_addr_map.tcl
    OTHER           system_console/test_functions.tcl
    OTHER           system_console/basic/basic.tcl
    OTHER           system_console/mac/10g_mac_reg_map.tcl
    OTHER           system_console/mac/mac_inc.tcl
    OTHER           system_console/phy/phy_ip_inc.tcl
    OTHER           system_console/phy/phy_ip_reg_map.tcl
    OTHER           system_console/rcfg/mge_rcfg_inc.tcl
    OTHER           system_console/rcfg/mge_rcfg_reg_map.tcl
    OTHER           system_console/test_parameter/parameter.tcl
    OTHER           system_console/traffic_controller/traffic_controller.tcl
    OTHER           system_console/traffic_controller/avalonstloopback/avalon_st_loopback_inc.tcl
    OTHER           system_console/traffic_controller/avalonstloopback/avalon_st_loopback_reg_map.tcl
    OTHER           system_console/traffic_controller/gen/gen_inc.tcl
    OTHER           system_console/traffic_controller/gen/gen_reg_map.tcl
    OTHER           system_console/traffic_controller/mon/mon_inc.tcl
    OTHER           system_console/traffic_controller/mon/mon_reg_map.tcl
}

set qs_files_a10_1g_2_5g_10g {
    
    OTHER           altera_eth_top.qpf                     
    SDC             altera_eth_top.sdc                        
}

set tb_a10_1g_2_5g_10g {
    
    OTHER           ed_sim/models/avalon_bfm_wrapper.sv
    OTHER           ed_sim/models/avalon_driver.sv
    OTHER           ed_sim/models/avalon_if_params_pkg.sv
    OTHER           ed_sim/models/avalon_st_eth_packet_monitor.sv
    OTHER           ed_sim/models/eth_mac_frame.sv
    OTHER           ed_sim/models/eth_register_map_params_pkg.sv
    OTHER           ed_sim/models/gen_sim_script.sh
    OTHER           ed_sim/models/avst_pkt_lb_fifo.v
    OTHER           ed_sim/mentor/tb_run.tcl
    OTHER           ed_sim/models/tb_testcase.sv
    OTHER           ed_sim/models/tb_top.sv
    OTHER           ed_sim/mentor/wave.do
    OTHER           ed_sim/cadence/ncsim_wave.tcl
    OTHER           ed_sim/cadence/tb_run.sh
    OTHER           ed_sim/synopsys/vcs/tb_run.sh
    OTHER           ed_sim/synopsys/vcs/tb_top.ucli.txt
    OTHER           ed_sim/synopsys/vcs/vcs_wave.tcl
    
}

proc a10_1g_2_5g_10g {synthesis_option device_part_value languaue_option part_number device_family family_tag} {

    global synth_sim_a10_1g_2_5g_10g
    global ed_files_a10_1g_2_5g_10g
    global qs_files_a10_1g_2_5g_10g
    global hardware_a10_1g_2_5g_10g
    global sim_a10_1g_2_5g_10g
    global tb_a10_1g_2_5g_10g
    
    set is_qsys_pro ""

    set check_qsys_pro [is_qsys_edition QSYS_PRO]

    if {![string compare $device_family "Arria 10"] && !$check_qsys_pro} {
        set is_qsys_pro "0"  
    } else {
        set is_qsys_pro "1"
    }
     
    set variant "LL10G_1G_2_5G_10G"
    set templocation [create_temp_file "${variant}_gen.tcl"] 
    
    set location [file dirname $templocation]
    file delete ${location}/${variant}_gen.tcl
    set auto_spd_list "--spd=${location}/manual.spd"

    # modify top level file 
    mod_top_and_tb_terp ../example_design/$variant $variant ./ altera_eth_top.sv SYSTEM_VERILOG
    
    # generate all the qsys file based on provided synthesis options and create spd argument list for ip-make-simscript
    foreach {from_folder file qsys_type} $ed_files_a10_1g_2_5g_10g {
        local_qsysgenerate $location $variant $from_folder ${synthesis_option} $file $qsys_type $languaue_option $part_number $device_family $family_tag $is_qsys_pro
        # if it is qsys pro and qsys system design, need to include the .spd file inside individual ip folder as well.
        if {$is_qsys_pro && $qsys_type == "qsys_system"} {
            foreach {ip_file} [glob -directory "${location}/${from_folder}/ip/${file}/" "*.ip"] {
                set path_tmp [string range $ip_file 0 end-3]
                set ip_name [string range [file tail $ip_file] 0 end-3]
                append auto_spd_list " --spd=${path_tmp}/${ip_name}.spd"                
            }
        }     
        append auto_spd_list " --spd=${location}/${from_folder}/${file}/${file}.spd"
    }
    
    
    after 6000

    find_files_copy_back $location $variant
    
    # whatever synthesis options, those files will be generated
    if {$synthesis_option == "both" || $synthesis_option == "synth" || $synthesis_option == "sim"} {
        foreach {type file} $synth_sim_a10_1g_2_5g_10g {
            # for file other than qsys component, if it is family depend, "<family>" suffix can be added to the end of the filename.
            # the following code will replace it with appropriate family tag
            regsub -- "<family>" $file "$family_tag" file_source
            regsub -- "<family>" $file "" file_dest
            add_fileset_file $variant/rtl/$file_dest $type PATH ../example_design/$variant/rtl/$file 
        
        }  
    }
    
    # overwrite original generated MAC top level file (note: use mac qsys.terp instead of mac v.terp file.)
#    if {$synthesis_option == "both" || $synthesis_option == "synth"} {
#    
#       mod_mac_terp ../example_design/$variant/rtl/mac $variant rtl/mac/altera_eth_10g_mac/synth altera_eth_10g_mac.v VERILOG
#    }
#    
#    if {$synthesis_option == "both" || $synthesis_option == "sim"} {
#    
#        mod_mac_terp ../example_design/$variant/rtl/mac $variant rtl/mac/altera_eth_10g_mac/sim altera_eth_10g_mac.v VERILOG 
#    }   
        
    
    if {$synthesis_option == "both" || $synthesis_option == "synth"} {
        # generate project related files
        foreach {type file} $qs_files_a10_1g_2_5g_10g {
            add_fileset_file $variant/$file $type PATH ../example_design/$variant/$file 
            
        } 
        
        # generate hardware debugging files
        foreach {type file} $hardware_a10_1g_2_5g_10g {
                add_fileset_file $variant/hwtesting/$file $type PATH ../example_design/$variant/hwtesting/$file 
            
        }   
        
        # replace QSF file accordingly
        if {$device_part_value == "nomatch"} {
            mod_qsf_terp ../example_design/$variant $variant ./ altera_eth_top.qsf "virtual_pin" $part_number OTHER $is_qsys_pro
        } elseif {$device_part_value == "nomatch_custom"} {
            mod_qsf_terp ../example_design/$variant $variant ./ altera_eth_top.qsf "blank" $part_number OTHER $is_qsys_pro
        } else {      
            mod_devkit_qsf_terp ../example_design/$variant $variant ./ altera_eth_top_devkit.qsf altera_eth_top.qsf $part_number OTHER $is_qsys_pro
        }
    }
    
    # generate simulation files
    if {$synthesis_option == "both" || $synthesis_option == "sim"} {       

        global env
        set qsys_path_normalize [file join $env(QUARTUS_ROOTDIR)/sopc_builder/bin/]
        
        foreach {type file} $tb_a10_1g_2_5g_10g {
            if {[string match "*.ucli.txt" $file]} {
                set file_tmp [string range $file 0 end-4]
                add_fileset_file $variant/simulation/$file_tmp $type PATH ../example_design/$variant/simulation/$file
            } else {
                add_fileset_file $variant/simulation/$file $type PATH ../example_design/$variant/simulation/$file 
            }
        
        }

        # add manual spd file
        file copy -force ../example_design/$variant/manual.spd.txt ${location}/manual.spd
        add_fileset_file $variant/manual.spd OTHER PATH ../example_design/$variant/manual.spd.txt
    
        # generate simulation setup scripts
        # Need to expand the $auto_spd_list with {*} before append to the list, else the whole $auto_spd_list will be treated as 1 argument.
        set exec_command [list $qsys_path_normalize/ip-make-simscript {*}$auto_spd_list --output-directory=${location}/simulation/ed_sim/setup_scripts --use_relative_paths]
        set status [catch {exec {*}$exec_command} result]

        if {$status == 0} {
            send_message ERROR "Error when executing: $exec_command"
            send_message ERROR "Error message: $result"
        } else {
            send_message INFO "Simulation setup scripts are generated"
        }
    
        find_files_copy_back $location/simulation/ed_sim/setup_scripts $variant/simulation/ed_sim/setup_scripts
    
        # modify tb parameter     
        mod_tb_terp  ../example_design/$variant/simulation $variant ./simulation/ed_sim/models default_test_params_pkg.sv SYSTEM_VERILOG
    }
    

}
