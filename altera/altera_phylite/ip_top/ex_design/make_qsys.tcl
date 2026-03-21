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


package require -exact qsys 15.0

if {! [info exists ip_params] || ! [info exists ed_params]} {
   source "params.tcl"
}  


proc create_synth_design {} {

    upvar ip_params ip_params
    upvar ed_params ed_params
    upvar num_grps num_grps
    upvar phylites phylites
    upvar drivers drivers
    upvar sim_ctrls sim_ctrls
    upvar addr_cmds addr_cmds
    upvar mems mems    
    upvar family family
    
    upvar dyn_cfg dyn_cfg
    upvar use_avl_ctrl use_avl_ctrl
    upvar enable_debug_design enable_debug_design

foreach phylite $phylites {
   if { $family == "Stratix 10" } {    
      add_instance $phylite altera_phylite_s10
   } else {   
      add_instance $phylite altera_phylite
   }   
}

foreach inst $phylites {
   foreach param_name [array names ip_params] {
      set_instance_parameter_value $inst $param_name $ip_params($param_name)
   }

       set_instance_parameter_value $inst GENERATE_SDC_FILE "true"
}

foreach phylite $phylites {

   add_interface ref_clk_clock_sink conduit end
   set_interface_property ref_clk_clock_sink EXPORT_OF ${phylite}.ref_clk_clock_sink
   
   add_interface reset_reset_sink conduit end
   set_interface_property reset_reset_sink EXPORT_OF ${phylite}.reset_reset_sink

   for {set i 0} {$i < $num_grps} {incr i} {
      add_interface group_${i}_io_interface_conduit_end conduit end
      set_interface_property group_${i}_io_interface_conduit_end EXPORT_OF ${phylite}.group_${i}_io_interface_conduit_end

      add_interface group_${i}_core_interface_conduit_end conduit end
      set_interface_property group_${i}_core_interface_conduit_end EXPORT_OF ${phylite}.group_${i}_core_interface_conduit_end
   }

   if { ([string compare -nocase $dyn_cfg "true"] == 0) } {
      add_interface avalon_interface_conduit_end conduit end
      set_interface_property avalon_interface_conduit_end EXPORT_OF ${phylite}.avalon_interface_conduit_end
   }

   add_interface lock_conduit_end conduit end
   set_interface_property lock_conduit_end EXPORT_OF ${phylite}.lock_conduit_end
   
   add_interface core_clk_conduit_end conduit end
   set_interface_property core_clk_conduit_end EXPORT_OF ${phylite}.core_clk_conduit_end
   
}
}

proc create_dyn_reconfig_design {} {

    upvar ip_params ip_params
    upvar ed_params ed_params
    upvar num_grps num_grps
    upvar phylites phylites
    upvar drivers drivers
    upvar sim_ctrls sim_ctrls
    upvar addr_cmds addr_cmds
    upvar mems mems    
    upvar family family
    
    upvar dyn_cfg dyn_cfg
    upvar use_avl_ctrl use_avl_ctrl
    upvar enable_debug_design enable_debug_design
    
    set phylite [lindex $phylites end]
        
    if { [string compare -nocase $use_avl_ctrl  "true"] == 0 } {
    	set avl_ctrl "avl_ctrl_inst"
    	add_instance $avl_ctrl altera_phylite_avl_ctrl
    	remove_interface avalon_interface_conduit_end
	add_connection ${avl_ctrl}.avalon_out_interface_conduit_end ${phylite}.avalon_interface_conduit_end
    }

    add_instance clk_0 clock_source 
    set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
    set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
    set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}

    add_instance col_reconfig_bridge altera_avalon_mm_bridge 
    set_instance_parameter_value col_reconfig_bridge {DATA_WIDTH} {32}
    set_instance_parameter_value col_reconfig_bridge {SYMBOL_WIDTH} {8}
    set_instance_parameter_value col_reconfig_bridge {ADDRESS_WIDTH} {24}
    set_instance_parameter_value col_reconfig_bridge {USE_AUTO_ADDRESS_WIDTH} {0}
    set_instance_parameter_value col_reconfig_bridge {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value col_reconfig_bridge {MAX_BURST_SIZE} {1}
    set_instance_parameter_value col_reconfig_bridge {MAX_PENDING_RESPONSES} {4}
    set_instance_parameter_value col_reconfig_bridge {LINEWRAPBURSTS} {0}
    set_instance_parameter_value col_reconfig_bridge {PIPELINE_COMMAND} {1}
    set_instance_parameter_value col_reconfig_bridge {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value col_reconfig_bridge {USE_RESPONSE} {0}

    add_instance data_mem altera_avalon_onchip_memory2 
    set_instance_parameter_value data_mem {allowInSystemMemoryContentEditor} {0}
    set_instance_parameter_value data_mem {blockType} {AUTO}
    set_instance_parameter_value data_mem {dataWidth} {32}
    set_instance_parameter_value data_mem {dualPort} {0}
    set_instance_parameter_value data_mem {initMemContent} {1}
    set_instance_parameter_value data_mem {initializationFileName} {onchip_mem.hex}
    set_instance_parameter_value data_mem {instanceID} {NONE}
    set_instance_parameter_value data_mem {memorySize} {262144.0}
    set_instance_parameter_value data_mem {readDuringWriteMode} {DONT_CARE}
    set_instance_parameter_value data_mem {simAllowMRAMContentsFile} {0}
    set_instance_parameter_value data_mem {simMemInitOnlyFilename} {0}
    set_instance_parameter_value data_mem {singleClockOperation} {0}
    set_instance_parameter_value data_mem {slave1Latency} {1}
    set_instance_parameter_value data_mem {slave2Latency} {1}
    set_instance_parameter_value data_mem {useNonDefaultInitFile} {0}
    set_instance_parameter_value data_mem {copyInitFile} {0}
    set_instance_parameter_value data_mem {useShallowMemBlocks} {0}
    set_instance_parameter_value data_mem {writable} {1}
    set_instance_parameter_value data_mem {ecc_enabled} {0}
    set_instance_parameter_value data_mem {resetrequest_enabled} {1}

    add_instance inst_mem altera_avalon_onchip_memory2 
    set_instance_parameter_value inst_mem {allowInSystemMemoryContentEditor} {0}
    set_instance_parameter_value inst_mem {blockType} {AUTO}
    set_instance_parameter_value inst_mem {dataWidth} {32}
    set_instance_parameter_value inst_mem {dualPort} {0}
    set_instance_parameter_value inst_mem {initMemContent} {1}
    set_instance_parameter_value inst_mem {initializationFileName} {onchip_mem.hex}
    set_instance_parameter_value inst_mem {instanceID} {NONE}
    set_instance_parameter_value inst_mem {memorySize} {262144.0}
    set_instance_parameter_value inst_mem {readDuringWriteMode} {DONT_CARE}
    set_instance_parameter_value inst_mem {simAllowMRAMContentsFile} {0}
    set_instance_parameter_value inst_mem {simMemInitOnlyFilename} {0}
    set_instance_parameter_value inst_mem {singleClockOperation} {0}
    set_instance_parameter_value inst_mem {slave1Latency} {1}
    set_instance_parameter_value inst_mem {slave2Latency} {1}
    set_instance_parameter_value inst_mem {useNonDefaultInitFile} {0}
    set_instance_parameter_value inst_mem {copyInitFile} {0}
    set_instance_parameter_value inst_mem {useShallowMemBlocks} {0}
    set_instance_parameter_value inst_mem {writable} {1}
    set_instance_parameter_value inst_mem {ecc_enabled} {0}
    set_instance_parameter_value inst_mem {resetrequest_enabled} {1}

    add_instance jtag_uart_0 altera_avalon_jtag_uart 
    set_instance_parameter_value jtag_uart_0 {allowMultipleConnections} {0}
    set_instance_parameter_value jtag_uart_0 {hubInstanceID} {0}
    set_instance_parameter_value jtag_uart_0 {readBufferDepth} {64}
    set_instance_parameter_value jtag_uart_0 {readIRQThreshold} {8}
    set_instance_parameter_value jtag_uart_0 {simInputCharacterStream} {}
    set_instance_parameter_value jtag_uart_0 {simInteractiveOptions} {NO_INTERACTIVE_WINDOWS}
    set_instance_parameter_value jtag_uart_0 {useRegistersForReadBuffer} {0}
    set_instance_parameter_value jtag_uart_0 {useRegistersForWriteBuffer} {0}
    set_instance_parameter_value jtag_uart_0 {useRelativePathForSimFile} {0}
    set_instance_parameter_value jtag_uart_0 {writeBufferDepth} {64}
    set_instance_parameter_value jtag_uart_0 {writeIRQThreshold} {8}

    add_instance nios2_qsys_0 altera_nios2_gen2 
    set_instance_parameter_value nios2_qsys_0 {tmr_enabled} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_disable_tmr_inj} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_showUnpublishedSettings} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_showInternalSettings} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_preciseIllegalMemAccessException} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_exportPCB} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_exportdebuginfo} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_clearXBitsLDNonBypass} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_bigEndian} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_export_large_RAMs} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_asic_enabled} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_asic_synopsys_translate_on_off} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_asic_third_party_synthesis} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_asic_add_scan_mode_input} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_oci_version} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_fast_register_read} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_exportHostDebugPort} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_oci_export_jtag_signals} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_avalonDebugPortPresent} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_alwaysEncrypt} {1}
    set_instance_parameter_value nios2_qsys_0 {io_regionbase} {0}
    set_instance_parameter_value nios2_qsys_0 {io_regionsize} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_support31bitdcachebypass} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_activateTrace} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_allow_break_inst} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_activateTestEndChecker} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_ecc_sim_test_ports} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_disableocitrace} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_activateMonitors} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_HDLSimCachesCleared} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_HBreakTest} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_breakslaveoveride} {0}
    set_instance_parameter_value nios2_qsys_0 {mpu_useLimit} {0}
    set_instance_parameter_value nios2_qsys_0 {mpu_enabled} {0}
    set_instance_parameter_value nios2_qsys_0 {mmu_enabled} {0}
    set_instance_parameter_value nios2_qsys_0 {mmu_autoAssignTlbPtrSz} {1}
    set_instance_parameter_value nios2_qsys_0 {cpuReset} {0}
    set_instance_parameter_value nios2_qsys_0 {resetrequest_enabled} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_removeRAMinit} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_shadowRegisterSets} {0}
    set_instance_parameter_value nios2_qsys_0 {mpu_numOfInstRegion} {8}
    set_instance_parameter_value nios2_qsys_0 {mpu_numOfDataRegion} {8}
    set_instance_parameter_value nios2_qsys_0 {mmu_TLBMissExcOffset} {0}
    set_instance_parameter_value nios2_qsys_0 {resetOffset} {0}
    set_instance_parameter_value nios2_qsys_0 {exceptionOffset} {32}
    set_instance_parameter_value nios2_qsys_0 {cpuID} {0}
    set_instance_parameter_value nios2_qsys_0 {breakOffset} {32}
    set_instance_parameter_value nios2_qsys_0 {userDefinedSettings} {}
    set_instance_parameter_value nios2_qsys_0 {tracefilename} {}
    set_instance_parameter_value nios2_qsys_0 {resetSlave} {inst_mem.s1}
    set_instance_parameter_value nios2_qsys_0 {mmu_TLBMissExcSlave} {None}
    set_instance_parameter_value nios2_qsys_0 {exceptionSlave} {inst_mem.s1}
    set_instance_parameter_value nios2_qsys_0 {breakSlave} {nios2_qsys_0.jtag_debug_module}
    set_instance_parameter_value nios2_qsys_0 {setting_interruptControllerType} {Internal}
    set_instance_parameter_value nios2_qsys_0 {setting_branchpredictiontype} {Dynamic}
    set_instance_parameter_value nios2_qsys_0 {setting_bhtPtrSz} {8}
    set_instance_parameter_value nios2_qsys_0 {cpuArchRev} {1}
    set_instance_parameter_value nios2_qsys_0 {mul_shift_choice} {0}
    set_instance_parameter_value nios2_qsys_0 {mul_32_impl} {3}
    set_instance_parameter_value nios2_qsys_0 {mul_64_impl} {0}
    set_instance_parameter_value nios2_qsys_0 {shift_rot_impl} {0}
    set_instance_parameter_value nios2_qsys_0 {dividerType} {no_div}
    set_instance_parameter_value nios2_qsys_0 {mpu_minInstRegionSize} {12}
    set_instance_parameter_value nios2_qsys_0 {mpu_minDataRegionSize} {12}
    set_instance_parameter_value nios2_qsys_0 {mmu_uitlbNumEntries} {4}
    set_instance_parameter_value nios2_qsys_0 {mmu_udtlbNumEntries} {6}
    set_instance_parameter_value nios2_qsys_0 {mmu_tlbPtrSz} {7}
    set_instance_parameter_value nios2_qsys_0 {mmu_tlbNumWays} {16}
    set_instance_parameter_value nios2_qsys_0 {mmu_processIDNumBits} {8}
    set_instance_parameter_value nios2_qsys_0 {impl} {Tiny}
    set_instance_parameter_value nios2_qsys_0 {icache_size} {4096}
    set_instance_parameter_value nios2_qsys_0 {fa_cache_line} {2}
    set_instance_parameter_value nios2_qsys_0 {fa_cache_linesize} {0}
    set_instance_parameter_value nios2_qsys_0 {icache_tagramBlockType} {Automatic}
    set_instance_parameter_value nios2_qsys_0 {icache_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_qsys_0 {icache_numTCIM} {0}
    set_instance_parameter_value nios2_qsys_0 {icache_burstType} {None}
    set_instance_parameter_value nios2_qsys_0 {dcache_bursts} {false}
    set_instance_parameter_value nios2_qsys_0 {dcache_victim_buf_impl} {ram}
    set_instance_parameter_value nios2_qsys_0 {dcache_size} {2048}
    set_instance_parameter_value nios2_qsys_0 {dcache_tagramBlockType} {Automatic}
    set_instance_parameter_value nios2_qsys_0 {dcache_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_qsys_0 {dcache_numTCDM} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_exportvectors} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_usedesignware} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_ecc_present} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_ic_ecc_present} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_rf_ecc_present} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_mmu_ecc_present} {1}
    set_instance_parameter_value nios2_qsys_0 {setting_dc_ecc_present} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_itcm_ecc_present} {0}
    set_instance_parameter_value nios2_qsys_0 {setting_dtcm_ecc_present} {0}
    set_instance_parameter_value nios2_qsys_0 {regfile_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_qsys_0 {ocimem_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_qsys_0 {ocimem_ramInit} {0}
    set_instance_parameter_value nios2_qsys_0 {mmu_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_qsys_0 {bht_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_qsys_0 {cdx_enabled} {0}
    set_instance_parameter_value nios2_qsys_0 {mpx_enabled} {0}
    set_instance_parameter_value nios2_qsys_0 {debug_enabled} {1}
    set_instance_parameter_value nios2_qsys_0 {debug_triggerArming} {1}
    set_instance_parameter_value nios2_qsys_0 {debug_debugReqSignals} {0}
    set_instance_parameter_value nios2_qsys_0 {debug_assignJtagInstanceID} {0}
    set_instance_parameter_value nios2_qsys_0 {debug_jtagInstanceID} {0}
    set_instance_parameter_value nios2_qsys_0 {debug_OCIOnchipTrace} {_128}
    set_instance_parameter_value nios2_qsys_0 {debug_hwbreakpoint} {0}
    set_instance_parameter_value nios2_qsys_0 {debug_datatrigger} {0}
    set_instance_parameter_value nios2_qsys_0 {debug_traceType} {none}
    set_instance_parameter_value nios2_qsys_0 {debug_traceStorage} {onchip_trace}
    set_instance_parameter_value nios2_qsys_0 {master_addr_map} {0}
    set_instance_parameter_value nios2_qsys_0 {instruction_master_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {instruction_master_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {flash_instruction_master_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {flash_instruction_master_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {data_master_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {data_master_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_instruction_master_0_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_instruction_master_0_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_instruction_master_1_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_instruction_master_1_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_instruction_master_2_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_instruction_master_2_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_instruction_master_3_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_instruction_master_3_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_data_master_0_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_data_master_0_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_data_master_1_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_data_master_1_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_data_master_2_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_data_master_2_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_data_master_3_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {tightly_coupled_data_master_3_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {instruction_master_high_performance_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {instruction_master_high_performance_paddr_size} {0.0}
    set_instance_parameter_value nios2_qsys_0 {data_master_high_performance_paddr_base} {0}
    set_instance_parameter_value nios2_qsys_0 {data_master_high_performance_paddr_size} {0.0}

 

    add_instance phylite_niosii_bridge_0 phylite_niosii_bridge 1.0
 
    add_instance issp_rst altera_in_system_sources_probes 
    set_instance_parameter_value issp_rst {gui_use_auto_index} {1}
    set_instance_parameter_value issp_rst {sld_instance_index} {0}
    set_instance_parameter_value issp_rst {instance_id} {RST}
    set_instance_parameter_value issp_rst {probe_width} {0}
    set_instance_parameter_value issp_rst {source_width} {1}
    set_instance_parameter_value issp_rst {source_initial_value} {0}
    set_instance_parameter_value issp_rst {create_source_clock} {0}
    set_instance_parameter_value issp_rst {create_source_clock_enable} {0}


    add_instance issp_lock altera_in_system_sources_probes 
    set_instance_parameter_value issp_lock {gui_use_auto_index} {1}
    set_instance_parameter_value issp_lock {sld_instance_index} {0}
    set_instance_parameter_value issp_lock {instance_id} {LOCK}
    set_instance_parameter_value issp_lock {probe_width} {1}
    set_instance_parameter_value issp_lock {source_width} {0}
    set_instance_parameter_value issp_lock {source_initial_value} {0}
    set_instance_parameter_value issp_lock {create_source_clock} {0}
    set_instance_parameter_value issp_lock {create_source_clock_enable} {0}


    add_instance issp_done altera_in_system_sources_probes 
    set_instance_parameter_value issp_done {gui_use_auto_index} {1}
    set_instance_parameter_value issp_done {sld_instance_index} {0}
    set_instance_parameter_value issp_done {instance_id} {DONE}
    set_instance_parameter_value issp_done {probe_width} {1}
    set_instance_parameter_value issp_done {source_width} {0}
    set_instance_parameter_value issp_done {source_initial_value} {0}
    set_instance_parameter_value issp_done {create_source_clock} {0}
    set_instance_parameter_value issp_done {create_source_clock_enable} {0}

    add_instance pio_nios_done altera_avalon_pio 
    set_instance_parameter_value pio_nios_done {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value pio_nios_done {bitModifyingOutReg} {0}
    set_instance_parameter_value pio_nios_done {captureEdge} {0}
    set_instance_parameter_value pio_nios_done {direction} {Output}
    set_instance_parameter_value pio_nios_done {edgeType} {RISING}
    set_instance_parameter_value pio_nios_done {generateIRQ} {0}
    set_instance_parameter_value pio_nios_done {irqType} {LEVEL}
    set_instance_parameter_value pio_nios_done {resetValue} {0.0}
    set_instance_parameter_value pio_nios_done {simDoTestBenchWiring} {0}
    set_instance_parameter_value pio_nios_done {simDrivenValue} {0.0}
    set_instance_parameter_value pio_nios_done {width} {1}

    add_connection nios2_qsys_0.data_master jtag_uart_0.avalon_jtag_slave avalon
    set_connection_parameter_value nios2_qsys_0.data_master/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
    set_connection_parameter_value nios2_qsys_0.data_master/jtag_uart_0.avalon_jtag_slave baseAddress {0x1000}
    set_connection_parameter_value nios2_qsys_0.data_master/jtag_uart_0.avalon_jtag_slave defaultConnection {0}

    add_connection nios2_qsys_0.data_master nios2_qsys_0.debug_mem_slave avalon
    set_connection_parameter_value nios2_qsys_0.data_master/nios2_qsys_0.debug_mem_slave arbitrationPriority {1}
    set_connection_parameter_value nios2_qsys_0.data_master/nios2_qsys_0.debug_mem_slave baseAddress {0x0800}
    set_connection_parameter_value nios2_qsys_0.data_master/nios2_qsys_0.debug_mem_slave defaultConnection {0}

    add_connection nios2_qsys_0.data_master col_reconfig_bridge.s0 avalon
    set_connection_parameter_value nios2_qsys_0.data_master/col_reconfig_bridge.s0 arbitrationPriority {1}
    set_connection_parameter_value nios2_qsys_0.data_master/col_reconfig_bridge.s0 baseAddress {0x04000000}
    set_connection_parameter_value nios2_qsys_0.data_master/col_reconfig_bridge.s0 defaultConnection {0}

    add_connection nios2_qsys_0.data_master data_mem.s1 avalon
    set_connection_parameter_value nios2_qsys_0.data_master/data_mem.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_qsys_0.data_master/data_mem.s1 baseAddress {0x00080000}
    set_connection_parameter_value nios2_qsys_0.data_master/data_mem.s1 defaultConnection {0}

    add_connection nios2_qsys_0.data_master inst_mem.s1 avalon
    set_connection_parameter_value nios2_qsys_0.data_master/inst_mem.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_qsys_0.data_master/inst_mem.s1 baseAddress {0x00040000}
    set_connection_parameter_value nios2_qsys_0.data_master/inst_mem.s1 defaultConnection {0}

 
    add_connection nios2_qsys_0.instruction_master nios2_qsys_0.debug_mem_slave avalon
    set_connection_parameter_value nios2_qsys_0.instruction_master/nios2_qsys_0.debug_mem_slave arbitrationPriority {1}
    set_connection_parameter_value nios2_qsys_0.instruction_master/nios2_qsys_0.debug_mem_slave baseAddress {0x0800}
    set_connection_parameter_value nios2_qsys_0.instruction_master/nios2_qsys_0.debug_mem_slave defaultConnection {0}

    add_connection nios2_qsys_0.instruction_master inst_mem.s1 avalon
    set_connection_parameter_value nios2_qsys_0.instruction_master/inst_mem.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_qsys_0.instruction_master/inst_mem.s1 baseAddress {0x00040000}
    set_connection_parameter_value nios2_qsys_0.instruction_master/inst_mem.s1 defaultConnection {0}

    add_connection clk_0.clk nios2_qsys_0.clk clock

    add_connection clk_0.clk col_reconfig_bridge.clk clock

    add_connection clk_0.clk jtag_uart_0.clk clock


    add_connection clk_0.clk data_mem.clk1 clock

    add_connection clk_0.clk inst_mem.clk1 clock

    add_connection nios2_qsys_0.irq jtag_uart_0.irq interrupt
    set_connection_parameter_value nios2_qsys_0.irq/jtag_uart_0.irq irqNumber {0}

    add_connection clk_0.clk_reset nios2_qsys_0.reset reset

    add_connection clk_0.clk_reset col_reconfig_bridge.reset reset

    add_connection clk_0.clk_reset jtag_uart_0.reset reset


    add_connection clk_0.clk_reset data_mem.reset1 reset

    add_connection clk_0.clk_reset inst_mem.reset1 reset

    add_connection nios2_qsys_0.debug_reset_request nios2_qsys_0.reset reset

    add_connection nios2_qsys_0.debug_reset_request jtag_uart_0.reset reset

    add_connection nios2_qsys_0.debug_reset_request col_reconfig_bridge.reset reset

    add_connection nios2_qsys_0.debug_reset_request inst_mem.reset1 reset

    add_connection nios2_qsys_0.debug_reset_request data_mem.reset1 reset

    add_connection phylite_niosii_bridge_0.clock_source_to_system ${phylite}.ref_clk_clock_sink clock
    add_connection phylite_niosii_bridge_0.core_clk_in ${phylite}.core_clk_conduit_end conduit
    set_connection_parameter_value phylite_niosii_bridge_0.core_clk_in/${phylite}.core_clk_conduit_end endPort {}
    set_connection_parameter_value phylite_niosii_bridge_0.core_clk_in/${phylite}.core_clk_conduit_end endPortLSB {0}
    set_connection_parameter_value phylite_niosii_bridge_0.core_clk_in/${phylite}.core_clk_conduit_end startPort {}
    set_connection_parameter_value phylite_niosii_bridge_0.core_clk_in/${phylite}.core_clk_conduit_end startPortLSB {0}
    set_connection_parameter_value phylite_niosii_bridge_0.core_clk_in/${phylite}.core_clk_conduit_end width {0}

    add_connection ${phylite}.lock_conduit_end phylite_niosii_bridge_0.interface_lock_in conduit
    set_connection_parameter_value ${phylite}.lock_conduit_end/phylite_niosii_bridge_0.interface_lock_in endPort {}
    set_connection_parameter_value ${phylite}.lock_conduit_end/phylite_niosii_bridge_0.interface_lock_in endPortLSB {0}
    set_connection_parameter_value ${phylite}.lock_conduit_end/phylite_niosii_bridge_0.interface_lock_in startPort {}
    set_connection_parameter_value ${phylite}.lock_conduit_end/phylite_niosii_bridge_0.interface_lock_in startPortLSB {0}
    set_connection_parameter_value ${phylite}.lock_conduit_end/phylite_niosii_bridge_0.interface_lock_in width {0}

    if { [string compare -nocase $use_avl_ctrl "true"] == 0 }  {
            set_instance_parameter_value phylite_niosii_bridge_0 ADDR_WIDTH 32
	    set_instance_parameter_value phylite_niosii_bridge_0 USE_AVL_CTRL 1
	    add_connection phylite_niosii_bridge_0.avl_out_interface_conduit ${avl_ctrl}.avalon_in_interface_conduit_end conduit
	    set_connection_parameter_value phylite_niosii_bridge_0.avl_out_interface_conduit/${avl_ctrl}.avalon_in_interface_conduit_end endPort {}
	    set_connection_parameter_value phylite_niosii_bridge_0.avl_out_interface_conduit/${avl_ctrl}.avalon_in_interface_conduit_end endPortLSB {0}
	    set_connection_parameter_value phylite_niosii_bridge_0.avl_out_interface_conduit/${avl_ctrl}.avalon_in_interface_conduit_end startPort {}
	    set_connection_parameter_value phylite_niosii_bridge_0.avl_out_interface_conduit/${avl_ctrl}.avalon_in_interface_conduit_end startPortLSB {0}
	    set_connection_parameter_value phylite_niosii_bridge_0.avl_out_interface_conduit/${avl_ctrl}.avalon_in_interface_conduit_end width {0}
    } else {
            set_instance_parameter_value phylite_niosii_bridge_0 ADDR_WIDTH 28
	    set_instance_parameter_value phylite_niosii_bridge_0 USE_AVL_CTRL 0
	    add_connection ${phylite}.avalon_interface_conduit_end phylite_niosii_bridge_0.avl_out_interface_conduit conduit
	    set_connection_parameter_value phylite_0_example_design.avalon_interface_conduit_end/phylite_niosii_bridge_0.avl_out_interface_conduit endPort {}
	    set_connection_parameter_value phylite_0_example_design.avalon_interface_conduit_end/phylite_niosii_bridge_0.avl_out_interface_conduit endPortLSB {0}
	    set_connection_parameter_value phylite_0_example_design.avalon_interface_conduit_end/phylite_niosii_bridge_0.avl_out_interface_conduit startPort {}
	    set_connection_parameter_value phylite_0_example_design.avalon_interface_conduit_end/phylite_niosii_bridge_0.avl_out_interface_conduit startPortLSB {0}
	    set_connection_parameter_value phylite_0_example_design.avalon_interface_conduit_end/phylite_niosii_bridge_0.avl_out_interface_conduit width {0}  
    }
   
    add_connection issp_rst.sources phylite_niosii_bridge_0.reset_input_for_system conduit
    set_connection_parameter_value issp_rst.sources/phylite_niosii_bridge_0.reset_input_for_system endPort {}
    set_connection_parameter_value issp_rst.sources/phylite_niosii_bridge_0.reset_input_for_system endPortLSB {0}
    set_connection_parameter_value issp_rst.sources/phylite_niosii_bridge_0.reset_input_for_system startPort {}
    set_connection_parameter_value issp_rst.sources/phylite_niosii_bridge_0.reset_input_for_system startPortLSB {0}
    set_connection_parameter_value issp_rst.sources/phylite_niosii_bridge_0.reset_input_for_system width {0}

    add_connection phylite_niosii_bridge_0.reset_source ${phylite}.reset_reset_sink reset
    add_connection phylite_niosii_bridge_0.nios_clock clk_0.clk_in clock

    add_connection phylite_niosii_bridge_0.nios_reset clk_0.clk_in_reset reset

    add_connection col_reconfig_bridge.m0 phylite_niosii_bridge_0.mm_avalon_slave avalon
    set_connection_parameter_value col_reconfig_bridge.m0/phylite_niosii_bridge_0.mm_avalon_slave arbitrationPriority {1}
    set_connection_parameter_value col_reconfig_bridge.m0/phylite_niosii_bridge_0.mm_avalon_slave baseAddress {0x0000}
    set_connection_parameter_value col_reconfig_bridge.m0/phylite_niosii_bridge_0.mm_avalon_slave defaultConnection {0}

	add_connection issp_lock.probes phylite_niosii_bridge_0.interface_lock_probe conduit
    set_connection_parameter_value issp_lock.probes/phylite_niosii_bridge_0.interface_lock_probe endPort {}
    set_connection_parameter_value issp_lock.probes/phylite_niosii_bridge_0.interface_lock_probe endPortLSB {0}
    set_connection_parameter_value issp_lock.probes/phylite_niosii_bridge_0.interface_lock_probe startPort {}
    set_connection_parameter_value issp_lock.probes/phylite_niosii_bridge_0.interface_lock_probe startPortLSB {0}
    set_connection_parameter_value issp_lock.probes/phylite_niosii_bridge_0.interface_lock_probe width {0}


	add_connection issp_done.probes phylite_niosii_bridge_0.nios_done_probe conduit
    set_connection_parameter_value issp_done.probes/phylite_niosii_bridge_0.nios_done_probe endPort {}
    set_connection_parameter_value issp_done.probes/phylite_niosii_bridge_0.nios_done_probe endPortLSB {0}
    set_connection_parameter_value issp_done.probes/phylite_niosii_bridge_0.nios_done_probe startPort {}
    set_connection_parameter_value issp_done.probes/phylite_niosii_bridge_0.nios_done_probe startPortLSB {0}
    set_connection_parameter_value issp_done.probes/phylite_niosii_bridge_0.nios_done_probe width {0}

    add_connection clk_0.clk pio_nios_done.clk clock

    add_connection clk_0.clk_reset pio_nios_done.reset reset

    add_connection nios2_qsys_0.data_master pio_nios_done.s1 avalon
    set_connection_parameter_value nios2_qsys_0.data_master/pio_nios_done.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_qsys_0.data_master/pio_nios_done.s1 baseAddress {0x0000}
    set_connection_parameter_value nios2_qsys_0.data_master/pio_nios_done.s1 defaultConnection {0}

    add_connection phylite_niosii_bridge_0.nios_done_in pio_nios_done.external_connection conduit
    set_connection_parameter_value phylite_niosii_bridge_0.nios_done_in/pio_nios_done.external_connection endPort {}
    set_connection_parameter_value phylite_niosii_bridge_0.nios_done_in/pio_nios_done.external_connection endPortLSB {0}
    set_connection_parameter_value phylite_niosii_bridge_0.nios_done_in/pio_nios_done.external_connection startPort {}
    set_connection_parameter_value phylite_niosii_bridge_0.nios_done_in/pio_nios_done.external_connection startPortLSB {0}
    set_connection_parameter_value phylite_niosii_bridge_0.nios_done_in/pio_nios_done.external_connection width {0}


     add_interface phylite_niosii_bridge_0_clock_input_for_system conduit end
    set_interface_property phylite_niosii_bridge_0_clock_input_for_system EXPORT_OF phylite_niosii_bridge_0.clock_input_for_system

    set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
    set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
    set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
    set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
}

proc create_sim_design {} {

    upvar ip_params ip_params
    upvar ed_params ed_params    
    upvar num_grps num_grps
    upvar phylites phylites
    upvar drivers drivers
    upvar sim_ctrls sim_ctrls
    upvar addr_cmds addr_cmds
    upvar mems mems    
    upvar family family
    
    upvar dyn_cfg dyn_cfg
    upvar use_avl_ctrl use_avl_ctrl
    upvar enable_debug_design enable_debug_design

    set phylite [lindex $phylites end]

set ref_clk_freq_mhz  [get_instance_parameter_value $phylite "PHYLITE_REF_CLK_FREQ_MHZ"]

set clock_if "ref_clk_gen"
add_instance $clock_if altera_avalon_clock_source
set_instance_parameter_value $clock_if CLOCK_RATE [expr {round($ref_clk_freq_mhz * 1000000.0)}]
set_instance_parameter_value $clock_if CLOCK_UNIT 1

if { [string compare -nocase $dyn_cfg "true"] == 0 } {
   set avl_ctrl "avl_ctrl_inst"
   add_instance $avl_ctrl altera_phylite_avl_ctrl

   set cfg_ctrl "cfg_ctrl_inst"
   add_instance $cfg_ctrl altera_phylite_cfg_ctrl
}

set reset_if "reset_gen"
add_instance $reset_if altera_avalon_reset_source
set_instance_parameter_value $reset_if ASSERT_HIGH_RESET 0
set_instance_parameter_value $reset_if INITIAL_RESET_CYCLES 5

add_connection ${clock_if}.clk   ${reset_if}.clk

foreach sim_ctrl $sim_ctrls driver $drivers phylite $phylites {

   add_instance $driver altera_phylite_driver
   add_instance $sim_ctrl altera_phylite_sim_ctrl

   foreach param_name [array names ip_params] {
      set_instance_parameter_value $sim_ctrl $param_name $ip_params($param_name)
      set_instance_parameter_value $driver $param_name $ip_params($param_name)
   }
}

foreach addr_cmd $addr_cmds {
   if { $family == "Stratix 10" } {
	   add_instance $addr_cmd altera_phylite_s10
	   set_instance_parameter_value $addr_cmd PHYLITE_ADDR_CMD "true"
   } else {
	   add_instance $addr_cmd altera_phylite
   }
   set_instance_parameter_value $addr_cmd PHYLITE_NUM_GROUPS                1
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_PIN_TYPE              "OUTPUT"
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_PIN_WIDTH             [expr 3 + ${num_grps}]
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_DDR_SDR_MODE          "SDR"
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_STROBE_CONFIG         "SINGLE_ENDED"
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_DATA_CONFIG           "SGL_ENDED"
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_READ_LATENCY          7
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_CAPTURE_PHASE_SHIFT   0
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_WRITE_LATENCY         0
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_USE_OUTPUT_STROBE     1
   set_instance_parameter_value $addr_cmd GUI_GROUP_0_OUTPUT_STROBE_PHASE   0

   foreach param_name [array names ip_params] {
      if {[string first "GUI_PHYLITE_" $param_name] == 0} {
         set_instance_parameter_value $addr_cmd $param_name $ip_params($param_name)
      } elseif {[string first "DIAG_" $param_name] == 0} {
         set_instance_parameter_value $addr_cmd $param_name $ip_params($param_name)
      }
   }

   set_instance_parameter_value $addr_cmd GUI_PHYLITE_USE_DYNAMIC_RECONFIGURATION 0
   set_instance_parameter_value $addr_cmd GUI_PHYLITE_GENERATE_DEBUG_DESIGN 0
   set_instance_parameter_value $addr_cmd GUI_PHYLITE_USE_PHYLITE_AVL_CONTROLLER 0
}

foreach phylite $phylites driver $drivers sim_ctrl $sim_ctrls addr_cmd $addr_cmds {
   for {set i 0} {$i < $num_grps} {incr i} {
      set mem [lindex $mems $i]

      add_instance $mem altera_phylite_agent

      set_instance_parameter_value $mem AGENT_GROUP_INDEX $i
      foreach param_name [array names ip_params] {
         set_instance_parameter_value $mem $param_name $ip_params($param_name)
      }

      remove_interface group_${i}_core_interface_conduit_end
      set core_if group_${i}_core_interface_conduit_end
      add_connection ${driver}.${core_if} ${phylite}.${core_if}

      remove_interface group_${i}_io_interface_conduit_end
      
      add_connection ${phylite}.group_${i}_io_interface_conduit_end ${mem}.io_interface_conduit_end

      if {$i == 0} {
         add_connection ${sim_ctrl}.side_interface_conduit_end ${mem}.side_interface_conduit_end
      } else {
         add_connection [lindex $mems [expr $i - 1]].side_next_interface_conduit_end ${mem}.side_interface_conduit_end
      }

      if {$i == 0} {
         add_connection ${addr_cmd}.group_0_io_interface_conduit_end ${mem}.mem_cmd_interface_conduit_end
      } else {
         add_connection [lindex $mems [expr $i - 1]].mem_cmd_next_interface_conduit_end ${mem}.mem_cmd_interface_conduit_end
      }

   }

   remove_interface ref_clk_clock_sink
   remove_interface reset_reset_sink
   remove_interface lock_conduit_end
   remove_interface core_clk_conduit_end

   if { [string compare -nocase $dyn_cfg "true"] == 0 } {
      remove_interface avalon_interface_conduit_end
   }

   add_connection ${phylite}.lock_conduit_end     ${driver}.start_in_conduit_end
   add_connection ${phylite}.core_clk_conduit_end ${driver}.core_clk_in_conduit_end

   add_connection ${driver}.sim_ctrl_conduit_end     ${sim_ctrl}.sim_ctrl_conduit_end
   add_connection ${driver}.core_clk_out_conduit_end ${sim_ctrl}.core_clk_out_conduit_end
   add_connection ${driver}.start_out_conduit_end    ${sim_ctrl}.dut_lock_conduit_end

   add_connection ${sim_ctrl}.core_cmd_interface_conduit_end ${addr_cmd}.group_0_core_interface_conduit_end
	   add_connection ${addr_cmd}.lock_conduit_end  ${sim_ctrl}.addr_cmd_lock_conduit_end
	   add_connection ${clock_if}.clk   ${addr_cmd}.ref_clk_clock_sink
	   add_connection ${reset_if}.reset ${addr_cmd}.reset_reset_sink 
   add_connection ${sim_ctrl}.mem_cmd_interface_conduit_end  [lindex $mems [expr $num_grps - 1]].mem_cmd_next_interface_conduit_end

   add_connection ${clock_if}.clk   ${phylite}.ref_clk_clock_sink
   add_connection ${reset_if}.reset ${phylite}.reset_reset_sink

   if { [string compare -nocase $dyn_cfg "true"] == 0 } {
      add_connection ${sim_ctrl}.cfg_clk_rst_conduit_end   ${cfg_ctrl}.core_clk_rst_conduit_end

      add_connection ${sim_ctrl}.cfg_ctrl_conduit_end ${cfg_ctrl}.cfg_ctrl_conduit_end
      add_connection ${cfg_ctrl}.avalon_interface_conduit_end ${avl_ctrl}.avalon_in_interface_conduit_end
      add_connection ${avl_ctrl}.avalon_out_interface_conduit_end ${phylite}.avalon_interface_conduit_end
   }

}
}

set num_grps    [list $ip_params(PHYLITE_NUM_GROUPS)]
set phylites    [list $ed_params(PHYLITE_NAME)]
set drivers     [list "driver_0"]
set sim_ctrls   [list "sim_ctrl_0"]
set addr_cmds   [list "addr_cmd_0"]
set mems        [list]
set family     $ip_params(SYS_INFO_DEVICE_FAMILY)
for { set i 0 } { $i < $num_grps } { incr i } {
   lappend mems "mem_$i"
}

set dyn_cfg $ip_params(GUI_PHYLITE_USE_DYNAMIC_RECONFIGURATION)
set use_avl_ctrl $ip_params(GUI_PHYLITE_USE_PHYLITE_AVL_CONTROLLER) 
set enable_debug_design $ip_params(GUI_PHYLITE_GENERATE_DEBUG_DESIGN) 

create_system
set_project_property DEVICE_FAMILY $ip_params(SYS_INFO_DEVICE_FAMILY)
set_project_property DEVICE $ip_params(SYS_INFO_DEVICE)

create_synth_design
save_system $ed_params(TMP_SYNTH_QSYS_PATH)

if { ([string compare -nocase $dyn_cfg "true"] == 0) && $enable_debug_design } {
    create_system
    set_project_property DEVICE_FAMILY $ip_params(SYS_INFO_DEVICE_FAMILY)
    set_project_property DEVICE $ip_params(SYS_INFO_DEVICE)
    create_synth_design
    create_dyn_reconfig_design
    save_system $ed_params(TMP_PHY_NIOS_QSYS_PATH)
}

create_system
set_project_property DEVICE_FAMILY $ip_params(SYS_INFO_DEVICE_FAMILY)
set_project_property DEVICE $ip_params(SYS_INFO_DEVICE)
create_synth_design
create_sim_design
save_system $ed_params(TMP_SIM_QSYS_PATH)

