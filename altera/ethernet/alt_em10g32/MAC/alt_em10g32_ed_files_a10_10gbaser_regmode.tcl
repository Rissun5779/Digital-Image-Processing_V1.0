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


set ed_files_a10_10gbaser_regmode {

    rtl/phy                     low_latency_baser           qsys_standalone
    rtl/address_decoder         address_decode              qsys_system
    rtl/fifo_dcfifo             dc_fifo                     qsys_system
    rtl/fifo_scfifo             sc_fifo                     qsys_system
    rtl/pll_atxpll              altera_xcvr_atx_pll_ip      qsys_standalone
    rtl/xcvr_reset_controller   reset_control               qsys_standalone
    rtl/IOPLL_half_clk          IOPLL_half_clk              qsys_standalone
    rtl/mac                     low_latency_mac             qsys_standalone

}


set synth_sim_a10_10gbaser_regmode {

    VERILOG         rtl/altera_eth_10g_mac_base_r_low_latency.v                         
    VERILOG         rtl/altera_eth_10g_mac_base_r_low_latency_wrap.v
    VERILOG         rtl/eth_traffic_controller/altera_avalon_sc_fifo.v                          
    VERILOG         rtl/eth_traffic_controller/avalon_st_gen.v                          
    VERILOG         rtl/eth_traffic_controller/avalon_st_loopback_csr.v                    
    SYSTEM_VERILOG  rtl/eth_traffic_controller/avalon_st_loopback.sv                    
    VERILOG         rtl/eth_traffic_controller/avalon_st_mon.v                          
    VERILOG         rtl/eth_traffic_controller/avalon_st_prtmux.v                       
    OTHER           rtl/eth_traffic_controller/eth_std_traffic_controller_top.qip
    VERILOG         rtl/eth_traffic_controller/eth_std_traffic_controller_top.v
    VERILOG         rtl/eth_traffic_controller/shiftreg_ctrl.v                          
    VERILOG         rtl/eth_traffic_controller/shiftreg_data.v                          
    VERILOG         rtl/eth_traffic_controller/crc32/avalon_st_to_crc_if_bridge.v       
    VERILOG         rtl/eth_traffic_controller/crc32/bit_endian_converter.v             
    VERILOG         rtl/eth_traffic_controller/crc32/byte_endian_converter.v            
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_calculator.v                 
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_chk.v                        
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_gen.v                        
    OTHER           rtl/eth_traffic_controller/crc32/crc32.qip                          
    SDC             rtl/eth_traffic_controller/crc32/crc32.sdc                          
    VERILOG         rtl/eth_traffic_controller/crc32/crc_checksum_aligner.v             
    VERILOG         rtl/eth_traffic_controller/crc32/crc_comparator.v                   
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat16.v            
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat24.v            
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat32_any_byte.v   
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat32.v            
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat40.v            
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat48.v            
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat56.v            
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat64_any_byte.v   
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat64.v            
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc32_dat8.v             
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc_ethernet.v           
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/crc_register.v           
    VERILOG         rtl/eth_traffic_controller/crc32/crc32_lib/xor6.v                   
}



set qs_files_a10_10gbaser_regmode {
    
    OTHER           altera_eth_top.qpf
    OTHER           altera_eth_top.sdc
    SYSTEM_VERILOG  altera_eth_top.sv
}


set tb_a10_10gbaser_regmode {
    
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
    SYSTEM_VERILOG              ed_sim/models/tb_top.sv
    OTHER                       ed_sim/synopsys/vcs/tb_run.sh
    OTHER                       ed_sim/synopsys/vcs/tb_top.ucli.txt

}

set hardware_a10_10gbaser_regmode {
    OTHER           system_console/common.tcl
    OTHER           system_console/config.tcl
    OTHER           system_console/csr_pkg.tcl
    OTHER           system_console/disable_loopback_conf.tcl
    OTHER           system_console/gen_and_mon_conf.tcl
    OTHER           system_console/gen_conf.tcl
    OTHER           system_console/loopback_conf.tcl
    OTHER           system_console/monitor_conf.tcl
    OTHER           system_console/reconfig_conf.tcl
    OTHER           system_console/reconfig.tcl
    OTHER           system_console/show_stats.tcl


}


proc a10_10gbaser_regmode {synthesis_option device_part_value languaue_option part_number device_family family_tag} {

    global synth_sim_a10_10gbaser_regmode
    global ed_files_a10_10gbaser_regmode
    global qs_files_a10_10gbaser_regmode
    global hardware_a10_10gbaser_regmode
    global tb_a10_10gbaser_regmode
    
    set is_qsys_pro ""

    set check_qsys_pro [is_qsys_edition QSYS_PRO]

    if {![string compare $device_family "Arria 10"] && !$check_qsys_pro} {
        set is_qsys_pro "0"  
    } else {
        set is_qsys_pro "1"
    }
     
    set variant "LL10G_10GBASER_RegMode"
    set templocation [create_temp_file "${variant}_gen.tcl"] 
    
    set location [file dirname $templocation]
    file delete ${location}/${variant}_gen.tcl
    set auto_spd_list "--spd=${location}/manual.spd"

    # modify top level file 
    #mod_top_and_tb_terp ../example_design/$variant $variant ./ altera_eth_top.sv SYSTEM_VERILOG
    
    # generate all the qsys file based on provided synthesis options and create spd argument list for ip-make-simscript
    foreach {from_folder file qsys_type} $ed_files_a10_10gbaser_regmode {
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
        foreach {type file} $synth_sim_a10_10gbaser_regmode {
            # for file other than qsys component, if it is family depend, "<family>" suffix can be added to the end of the filename.
            # the following code will replace it with appropriate family tag
            regsub -- "<family>" $file "$family_tag" file_source
            regsub -- "<family>" $file "" file_dest
            add_fileset_file $variant/$file_dest $type PATH ../example_design/$variant/$file 
        
        }  
    }
    
    # overwrite original generated MAC top level file (note: use mac qsys.terp instead of mac v.terp file.)
#    if {$synthesis_option == "both" || $synthesis_option == "synth"} {
#    
#       mod_mac_terp ../example_design/$variant/rtl/mac $variant rtl/mac/low_latency_mac/synth low_latency_mac.v VERILOG
#    }
#    
#    if {$synthesis_option == "both" || $synthesis_option == "sim"} {
#    
#        mod_mac_terp ../example_design/$variant/rtl/mac $variant rtl/mac/low_latency_mac/sim low_latency_mac.v VERILOG 
#    }   
        
    
    if {$synthesis_option == "both" || $synthesis_option == "synth"} {
        # generate project related files
        foreach {type file} $qs_files_a10_10gbaser_regmode {
            add_fileset_file $variant/$file $type PATH ../example_design/$variant/$file 
            
        } 
        
        # generate hardware debugging files
        foreach {type file} $hardware_a10_10gbaser_regmode {
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
    
    # add signal tap file
    add_fileset_file $variant/altera_eth_top.stp OTHER PATH ../example_design/$variant/altera_eth_top.stp.txt
    
    # generate simulation files
    if {$synthesis_option == "both" || $synthesis_option == "sim"} {       

        global env
        set qsys_path_normalize [file join $env(QUARTUS_ROOTDIR)/sopc_builder/bin/]
        
        foreach {type file} $tb_a10_10gbaser_regmode {
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
    }
    
     
}
