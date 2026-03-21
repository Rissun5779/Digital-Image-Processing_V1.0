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


set ed_files_a10_1g_10g_lineside_1588v2 {

    rtl/phy                         altera_eth_10gkr_phy                qsys_standalone
    rtl/address_decoder             address_decoder_channel             qsys_system
    rtl/address_decoder             address_decoder_multi_channel       qsys_system
    rtl/address_decoder             address_decoder_top                 qsys_system
    rtl/jtag_avalon_master          altera_jtag_avalon_master           qsys_system
    rtl/pll_atxpll                  nf_xcvr_10g_pll                     qsys_standalone
    rtl/pll_fpll                    nf_xcvr_1g_pll                      qsys_standalone
    rtl/pll_mpll                    io_pll                              qsys_standalone
    rtl/pll_mpll                    pll_2                               qsys_standalone
    rtl/xcvr_reset_controller       altera_xcvr_reset_controller        qsys_standalone
    rtl/altera_eth_1588_tod         altera_eth_1588_tod_1g              qsys_standalone
    rtl/altera_eth_1588_tod         altera_eth_1588_tod_10g             qsys_standalone
    rtl/altera_eth_1588_tod         altera_eth_1588_tod_master          qsys_standalone
    rtl/altera_eth_1588_tod_sync    altera_eth_1588_tod_sync_64b_1g     qsys_standalone
    rtl/altera_eth_1588_tod_sync    altera_eth_1588_tod_sync_64b_10g    qsys_standalone
    rtl/altera_eth_1588_tod_sync    altera_eth_1588_tod_sync_96b_1g     qsys_standalone
    rtl/altera_eth_1588_tod_sync    altera_eth_1588_tod_sync_96b_10g    qsys_standalone
    rtl/mac                         altera_eth_10g_mac                  qsys_standalone

}


set synth_sim_a10_1g_10g_lineside_1588v2 {

    VERILOG         altera_eth_1588_pps/altera_eth_1588_pps.v
    
    VERILOG         altera_eth_packet_classifier/altera_avalon_sc_fifo.v
    VERILOG         altera_eth_packet_classifier/altera_avalon_st_pipeline_base.v
    VERILOG         altera_eth_packet_classifier/altera_avalon_st_pipeline_stage.sv
    VERILOG         altera_eth_packet_classifier/altera_eth_packet_classifier.v
    
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_avg.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_initial.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_master_pkt_gen.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_master_pkt_rcv.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_master.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_pkt_gen.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_pkt_rcv.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_ram.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_slave_compute.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_slave_pkt_gen.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_slave_pkt_rcv.v
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/char10g1588_slave.v
    SYSTEM_VERILOG  eth_traffic_controller/eth_1588_traffic_controller/TrafficController_1588_10g/traffic_controller_1588.sv
    OTHER           eth_traffic_controller/eth_1588_traffic_controller/eth_1588_traffic_controller_top.qip
    VERILOG         eth_traffic_controller/eth_1588_traffic_controller/eth_1588_traffic_controller_top.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat16.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat24.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat32_any_byte.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat32.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat40.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat48.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat56.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat64_any_byte.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat64.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc32_dat8.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc_ethernet.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/crc_register.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_lib/xor6.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/avalon_st_to_crc_if_bridge.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/bit_endian_converter.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/byte_endian_converter.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_calculator.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_chk.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32_gen.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32.qip
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc32.sdc
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc_checksum_aligner.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/crc32/crc_comparator.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/altera_avalon_sc_fifo.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/avalon_st_gen.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/avalon_st_loopback_csr.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/avalon_st_loopback.sv
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/avalon_st_mon.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/avalon_st_prtmux.v
    OTHER           eth_traffic_controller/eth_std_traffic_controller/eth_std_traffic_controller_top.qip
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/eth_std_traffic_controller_top.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/shiftreg_ctrl.v
    VERILOG         eth_traffic_controller/eth_std_traffic_controller/shiftreg_data.v
    VERILOG         eth_traffic_controller/avl_st_mux.sv
    VERILOG         eth_traffic_controller/avl_st_sel_csr.v
    OTHER           eth_traffic_controller/eth_traffic_controller_top.qip
    SYSTEM_VERILOG  eth_traffic_controller/eth_traffic_controller_top.sv
    
    VERILOG         mdio/altera_eth_mdio.v
    OTHER           probe/source.qip
    VERILOG         probe/source.v
    SDC             reset_ctrl/altera_reset_controller.sdc
    VERILOG         reset_ctrl/altera_reset_controller.v
    VERILOG         reset_sync/altera_reset_synchronizer.v
    VERILOG         reset_csr/reset_csr.v
    VERILOG         two_wire_serial_controller/optics_control.v
    SYSTEM_VERILOG  two_wire_serial_controller/two_wire_control_tb.sv
    VERILOG         two_wire_serial_controller/two_wire_control.v
    VERILOG         two_wire_serial_controller/two_wire_iopad.v
    VERILOG         altera_eth_channel_1588.v
    SYSTEM_VERILOG  altera_eth_multi_channel_1588.sv
    
    
}

set hardware_a10_1g_10g_lineside_1588v2 {

    OTHER           system_console/channel_setting.tcl                              
    OTHER           system_console/list.tcl                                         
    OTHER           system_console/main.tcl                                                                        
    OTHER           system_console/system_base_addr_map.tcl                         
    OTHER           system_console/test_functions.tcl                               
    OTHER           system_console/basic/basic.tcl                                  
    OTHER           system_console/external_phy/bcm/bcm_phy_reg_map.tcl                        
    OTHER           system_console/external_phy/bcm/bcm_phy.tcl           
    OTHER           system_console/external_phy/marvell/marvell_phy_reg_map.tcl    
    OTHER           system_console/external_phy/marvell/marvell_phy.tcl             
    OTHER           system_console/external_phy/marvell/sfpp_i2c.tcl                
    OTHER           system_console/fifo/fifo_inc.tcl                                
    OTHER           system_console/fifo/fifo_reg_map.tcl                            
    OTHER           system_console/mac/10g_mac_reg_map.tcl                          
    OTHER           system_console/mac/mac_inc.tcl                                  
    OTHER           system_console/phy/phy_ip_inc.tcl                               
    OTHER           system_console/phy/phy_ip_reg_map.tcl                           
    OTHER           system_console/test_parameter/parameter.tcl                     
    OTHER           system_console/tod/tod_inc.tcl                                  
    OTHER           system_console/tod/tod_reg_map.tcl                              
    OTHER           system_console/traffic_controller/avalonstloopback/avalon_st_loopback_inc.tcl  
    OTHER           system_console/traffic_controller/avalonstloopback/avalon_st_loopback_reg_map.tcl
    OTHER           system_console/traffic_controller/gen/gen_inc.tcl               
    OTHER           system_console/traffic_controller/gen/gen_reg_map.tcl           
    OTHER           system_console/traffic_controller/mon/mon_inc.tcl               
    OTHER           system_console/traffic_controller/mon/mon_reg_map.tcl           
    OTHER           system_console/traffic_controller/traffic_controller.tcl        

}

set qs_files_a10_1g_10g_lineside_1588v2 {
    
    OTHER           altera_eth_top.qpf

}


set tb_a10_1g_10g_lineside_1588v2 {
    
    OTHER                       ed_sim/cadence/ncsim_wave.tcl
    OTHER                       ed_sim/cadence/tb_run.sh
    OTHER                       ed_sim/mentor/msim_wave.do
    OTHER                       ed_sim/mentor/tb_run.tcl
    SYSTEM_VERILOG              ed_sim/models/avalon_bfm_wrapper.sv
    SYSTEM_VERILOG              ed_sim/models/avalon_driver.sv
    SYSTEM_VERILOG              ed_sim/models/avalon_if_params_pkg.sv
    SYSTEM_VERILOG              ed_sim/models/avalon_st_eth_packet_monitor.sv
    SYSTEM_VERILOG              ed_sim/models/eth_mac_frame.sv
    SYSTEM_VERILOG              ed_sim/models/eth_register_map_params_pkg.sv
    SYSTEM_VERILOG              ed_sim/models/ptp_timestamp.sv
    SYSTEM_VERILOG              ed_sim/models/tb_testcase_1588.sv
    SYSTEM_VERILOG              ed_sim/models/tb_top_n_1588.sv
    OTHER                       ed_sim/synopsys/vcs/tb_run.sh
    OTHER                       ed_sim/synopsys/vcs/tb_top.ucli.txt
    OTHER                       ed_sim/synopsys/vcs/vcs_wave.tcl

}



proc a10_1g_10g_lineside_1588v2 {synthesis_option device_part_value languaue_option part_number device_family family_tag} {

    global synth_sim_a10_1g_10g_lineside_1588v2
    global ed_files_a10_1g_10g_lineside_1588v2
    global qs_files_a10_1g_10g_lineside_1588v2
    global hardware_a10_1g_10g_lineside_1588v2
    global sim_a10_1g_10g_lineside_1588v2
    global tb_a10_1g_10g_lineside_1588v2
    
    set is_qsys_pro ""

    set check_qsys_pro [is_qsys_edition QSYS_PRO]

    if {![string compare $device_family "Arria 10"] && !$check_qsys_pro} {
        set is_qsys_pro "0"  
    } else {
        set is_qsys_pro "1"
    }
     
    set variant "LL10G_1G_10G_LINESIDE_1588v2"
    set templocation [create_temp_file "${variant}_gen.tcl"] 
    
    set location [file dirname $templocation]
    file delete ${location}/${variant}_gen.tcl
    set auto_spd_list "--spd=${location}/manual.spd"

    # modify top level file 
    mod_top_and_tb_terp ../example_design/$variant $variant ./ altera_eth_top.sv SYSTEM_VERILOG
    
    # generate all the qsys file based on provided synthesis options and create spd argument list for ip-make-simscript
    foreach {from_folder file qsys_type} $ed_files_a10_1g_10g_lineside_1588v2 {
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
        foreach {type file} $synth_sim_a10_1g_10g_lineside_1588v2 {
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
#       mod_mac_terp ../example_design/$variant/rtl/mac $variant rtl/mac/altera_eth_10g_mac/sim altera_eth_10g_mac.v VERILOG 
#    }   
        
    
    if {$synthesis_option == "both" || $synthesis_option == "synth"} {
        # generate project related files
        foreach {type file} $qs_files_a10_1g_10g_lineside_1588v2 {
            add_fileset_file $variant/$file $type PATH ../example_design/$variant/$file 
            
        } 
        
        # generate hardware debugging files
        foreach {type file} $hardware_a10_1g_10g_lineside_1588v2 {
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

        # set number of channel in SDC file
        mod_sdc_terp ../example_design/$variant $variant ./ altera_eth_top.sdc SDC 
    }
    
    # add signal tap file
    add_fileset_file $variant/altera_eth_top.stp OTHER PATH ../example_design/$variant/altera_eth_top.stp.txt
    
    # generate simulation files
    if {$synthesis_option == "both" || $synthesis_option == "sim"} {       

        global env
        set qsys_path_normalize [file join $env(QUARTUS_ROOTDIR)/sopc_builder/bin/]
        
        foreach {type file} $tb_a10_1g_10g_lineside_1588v2 {
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
