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


package require -exact qsys 14.0

# module properties
set_module_property NAME {kr_dbg_cpu_s10}
set_module_property DISPLAY_NAME {kr_dbg_cpu_s10}

# default module properties
set_module_property VERSION {1.0}
set_module_property GROUP {default group}
set_module_property DESCRIPTION {default description}
set_module_property AUTHOR {author}
set_module_property INTERNAL {true} 
set_module_property HIDE_FROM_QUARTUS {true} 
set_module_property HIDE_FROM_QSYS {true} 

set_module_property COMPOSITION_CALLBACK compose
set_module_property opaque_address_map false

# DEVICE
add_parameter DEVICE_FAMILY STRING 0 ""
set_parameter_property DEVICE_FAMILY DEFAULT_VALUE "Stratix 10"
set_parameter_property DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY

# 
# parameters
# 
add_parameter imem_hex_path STRING 0 ""
set_parameter_property imem_hex_path DEFAULT_VALUE 0
set_parameter_property imem_hex_path DISPLAY_NAME imem_hex_path
set_parameter_property imem_hex_path WIDTH ""
set_parameter_property imem_hex_path TYPE STRING
set_parameter_property imem_hex_path UNITS None
set_parameter_property imem_hex_path DESCRIPTION ""

add_parameter dmem_hex_path STRING 0 ""
set_parameter_property dmem_hex_path DEFAULT_VALUE 0
set_parameter_property dmem_hex_path DISPLAY_NAME dmem_hex_path
set_parameter_property dmem_hex_path WIDTH ""
set_parameter_property dmem_hex_path TYPE STRING
set_parameter_property dmem_hex_path UNITS None
set_parameter_property dmem_hex_path DESCRIPTION ""

add_parameter ecc_present INTEGER 0 ""
set_parameter_property ecc_present DEFAULT_VALUE 0
set_parameter_property ecc_present DISPLAY_NAME ecc_present
set_parameter_property ecc_present WIDTH ""
set_parameter_property ecc_present TYPE INTEGER
set_parameter_property ecc_present UNITS None
set_parameter_property ecc_present DESCRIPTION ""

proc compose { } {
    # Instances and instance parameters
    # (disabled instances are intentionally culled)
    add_instance ber_in_0 altera_avalon_pio 16.1
    set_instance_parameter_value ber_in_0 {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value ber_in_0 {bitModifyingOutReg} {0}
    set_instance_parameter_value ber_in_0 {captureEdge} {0}
    set_instance_parameter_value ber_in_0 {direction} {Input}
    set_instance_parameter_value ber_in_0 {edgeType} {RISING}
    set_instance_parameter_value ber_in_0 {generateIRQ} {0}
    set_instance_parameter_value ber_in_0 {irqType} {LEVEL}
    set_instance_parameter_value ber_in_0 {resetValue} {0.0}
    set_instance_parameter_value ber_in_0 {simDoTestBenchWiring} {0}
    set_instance_parameter_value ber_in_0 {simDrivenValue} {0.0}
    set_instance_parameter_value ber_in_0 {width} {16}

    add_instance ber_zero altera_avalon_pio 16.1
    set_instance_parameter_value ber_zero {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value ber_zero {bitModifyingOutReg} {0}
    set_instance_parameter_value ber_zero {captureEdge} {0}
    set_instance_parameter_value ber_zero {direction} {Output}
    set_instance_parameter_value ber_zero {edgeType} {RISING}
    set_instance_parameter_value ber_zero {generateIRQ} {0}
    set_instance_parameter_value ber_zero {irqType} {LEVEL}
    set_instance_parameter_value ber_zero {resetValue} {1.0}
    set_instance_parameter_value ber_zero {simDoTestBenchWiring} {0}
    set_instance_parameter_value ber_zero {simDrivenValue} {0.0}
    set_instance_parameter_value ber_zero {width} {1}

    add_instance bert_done altera_avalon_pio 16.1
    set_instance_parameter_value bert_done {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value bert_done {bitModifyingOutReg} {0}
    set_instance_parameter_value bert_done {captureEdge} {0}
    set_instance_parameter_value bert_done {direction} {Input}
    set_instance_parameter_value bert_done {edgeType} {RISING}
    set_instance_parameter_value bert_done {generateIRQ} {0}
    set_instance_parameter_value bert_done {irqType} {LEVEL}
    set_instance_parameter_value bert_done {resetValue} {0.0}
    set_instance_parameter_value bert_done {simDoTestBenchWiring} {0}
    set_instance_parameter_value bert_done {simDrivenValue} {0.0}
    set_instance_parameter_value bert_done {width} {1}

    add_instance clear_ber altera_avalon_pio 16.1
    set_instance_parameter_value clear_ber {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value clear_ber {bitModifyingOutReg} {0}
    set_instance_parameter_value clear_ber {captureEdge} {0}
    set_instance_parameter_value clear_ber {direction} {Output}
    set_instance_parameter_value clear_ber {edgeType} {RISING}
    set_instance_parameter_value clear_ber {generateIRQ} {0}
    set_instance_parameter_value clear_ber {irqType} {LEVEL}
    set_instance_parameter_value clear_ber {resetValue} {0.0}
    set_instance_parameter_value clear_ber {simDoTestBenchWiring} {0}
    set_instance_parameter_value clear_ber {simDrivenValue} {0.0}
    set_instance_parameter_value clear_ber {width} {1}

    add_instance clk_0 clock_source 16.1
    set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
    set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
    set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}

    add_instance dmem altera_avalon_onchip_memory2 16.1
    set_instance_parameter_value dmem {allowInSystemMemoryContentEditor} {0}
    set_instance_parameter_value dmem {blockType} {AUTO}
    set_instance_parameter_value dmem {dataWidth} {32}
    set_instance_parameter_value dmem {dataWidth2} {32}
    set_instance_parameter_value dmem {dualPort} {0}
    set_instance_parameter_value dmem {enableDiffWidth} {0}
    set_instance_parameter_value dmem {initMemContent} {1}
    set_instance_parameter_value dmem {initializationFileName} [get_parameter_value dmem_hex_path]
    set_instance_parameter_value dmem {instanceID} {NONE}
    set_instance_parameter_value dmem {memorySize} {16384.0}
    set_instance_parameter_value dmem {readDuringWriteMode} {DONT_CARE}
    set_instance_parameter_value dmem {simAllowMRAMContentsFile} {0}
    set_instance_parameter_value dmem {simMemInitOnlyFilename} {0}
    set_instance_parameter_value dmem {singleClockOperation} {0}
    set_instance_parameter_value dmem {slave1Latency} {1}
    set_instance_parameter_value dmem {slave2Latency} {1}
    set_instance_parameter_value dmem {useNonDefaultInitFile} {1}
    set_instance_parameter_value dmem {copyInitFile} {1}
    set_instance_parameter_value dmem {useShallowMemBlocks} {0}
    set_instance_parameter_value dmem {writable} {1}
    set_instance_parameter_value dmem {ecc_enabled} {0}
    set_instance_parameter_value dmem {resetrequest_enabled} {1}

    add_instance enable altera_avalon_pio 16.1
    set_instance_parameter_value enable {bitClearingEdgeCapReg} {1}
    set_instance_parameter_value enable {bitModifyingOutReg} {0}
    set_instance_parameter_value enable {captureEdge} {1}
    set_instance_parameter_value enable {direction} {Input}
    set_instance_parameter_value enable {edgeType} {FALLING}
    set_instance_parameter_value enable {generateIRQ} {0}
    set_instance_parameter_value enable {irqType} {LEVEL}
    set_instance_parameter_value enable {resetValue} {0.0}
    set_instance_parameter_value enable {simDoTestBenchWiring} {0}
    set_instance_parameter_value enable {simDrivenValue} {0.0}
    set_instance_parameter_value enable {width} {3}

    add_instance imem altera_avalon_onchip_memory2 16.1
    set_instance_parameter_value imem {allowInSystemMemoryContentEditor} {0}
    set_instance_parameter_value imem {blockType} {AUTO}
    set_instance_parameter_value imem {dataWidth} {32}
    set_instance_parameter_value imem {dataWidth2} {32}
    set_instance_parameter_value imem {dualPort} {0}
    set_instance_parameter_value imem {enableDiffWidth} {0}
    set_instance_parameter_value imem {initMemContent} {1}
    set_instance_parameter_value imem {initializationFileName} [get_parameter_value imem_hex_path]
    set_instance_parameter_value imem {instanceID} {NONE}
    set_instance_parameter_value imem {memorySize} {16384.0}
    set_instance_parameter_value imem {readDuringWriteMode} {DONT_CARE}
    set_instance_parameter_value imem {simAllowMRAMContentsFile} {0}
    set_instance_parameter_value imem {simMemInitOnlyFilename} {0}
    set_instance_parameter_value imem {singleClockOperation} {0}
    set_instance_parameter_value imem {slave1Latency} {1}
    set_instance_parameter_value imem {slave2Latency} {1}
    set_instance_parameter_value imem {useNonDefaultInitFile} {1}
    set_instance_parameter_value imem {copyInitFile} {1}
    set_instance_parameter_value imem {useShallowMemBlocks} {0}
    set_instance_parameter_value imem {writable} {1}
    set_instance_parameter_value imem {ecc_enabled} {0}
    set_instance_parameter_value imem {resetrequest_enabled} {1}

    add_instance jtag_uart_0 altera_avalon_jtag_uart 16.1
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

    add_instance mm_bridge_0 altera_avalon_mm_bridge 16.1
    set_instance_parameter_value mm_bridge_0 {DATA_WIDTH} {32}
    set_instance_parameter_value mm_bridge_0 {SYMBOL_WIDTH} {8}
    set_instance_parameter_value mm_bridge_0 {ADDRESS_WIDTH} {12}
    set_instance_parameter_value mm_bridge_0 {USE_AUTO_ADDRESS_WIDTH} {0}
    set_instance_parameter_value mm_bridge_0 {ADDRESS_UNITS} {WORDS}
    set_instance_parameter_value mm_bridge_0 {MAX_BURST_SIZE} {1}
    set_instance_parameter_value mm_bridge_0 {MAX_PENDING_RESPONSES} {4}
    set_instance_parameter_value mm_bridge_0 {LINEWRAPBURSTS} {0}
    set_instance_parameter_value mm_bridge_0 {PIPELINE_COMMAND} {1}
    set_instance_parameter_value mm_bridge_0 {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value mm_bridge_0 {USE_RESPONSE} {0}

    add_instance nios2_gen2_0 altera_nios2_gen2 16.1
    set_instance_parameter_value nios2_gen2_0 {tmr_enabled} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_disable_tmr_inj} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_showUnpublishedSettings} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_showInternalSettings} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_preciseIllegalMemAccessException} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_exportPCB} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_exportdebuginfo} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_clearXBitsLDNonBypass} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_bigEndian} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_export_large_RAMs} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_asic_enabled} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_asic_synopsys_translate_on_off} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_asic_third_party_synthesis} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_asic_add_scan_mode_input} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_oci_version} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_fast_register_read} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_exportHostDebugPort} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_oci_export_jtag_signals} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_avalonDebugPortPresent} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_alwaysEncrypt} {1}
    set_instance_parameter_value nios2_gen2_0 {io_regionbase} {0}
    set_instance_parameter_value nios2_gen2_0 {io_regionsize} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_support31bitdcachebypass} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_activateTrace} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_allow_break_inst} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_activateTestEndChecker} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_ecc_sim_test_ports} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_disableocitrace} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_activateMonitors} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_HDLSimCachesCleared} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_HBreakTest} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_breakslaveoveride} {0}
    set_instance_parameter_value nios2_gen2_0 {mpu_useLimit} {0}
    set_instance_parameter_value nios2_gen2_0 {mpu_enabled} {0}
    set_instance_parameter_value nios2_gen2_0 {mmu_enabled} {0}
    set_instance_parameter_value nios2_gen2_0 {mmu_autoAssignTlbPtrSz} {1}
    set_instance_parameter_value nios2_gen2_0 {cpuReset} {0}
    set_instance_parameter_value nios2_gen2_0 {resetrequest_enabled} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_removeRAMinit} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_tmr_output_disable} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_shadowRegisterSets} {0}
    set_instance_parameter_value nios2_gen2_0 {mpu_numOfInstRegion} {8}
    set_instance_parameter_value nios2_gen2_0 {mpu_numOfDataRegion} {8}
    set_instance_parameter_value nios2_gen2_0 {mmu_TLBMissExcOffset} {0}
    set_instance_parameter_value nios2_gen2_0 {resetOffset} {0}
    set_instance_parameter_value nios2_gen2_0 {exceptionOffset} {32}
    set_instance_parameter_value nios2_gen2_0 {cpuID} {0}
    set_instance_parameter_value nios2_gen2_0 {breakOffset} {32}
    set_instance_parameter_value nios2_gen2_0 {userDefinedSettings} {}
    set_instance_parameter_value nios2_gen2_0 {tracefilename} {}
    set_instance_parameter_value nios2_gen2_0 {resetSlave} {Absolute}
    set_instance_parameter_value nios2_gen2_0 {mmu_TLBMissExcSlave} {None}
    set_instance_parameter_value nios2_gen2_0 {exceptionSlave} {Absolute}
    set_instance_parameter_value nios2_gen2_0 {breakSlave} {None}
    set_instance_parameter_value nios2_gen2_0 {setting_interruptControllerType} {Internal}
    set_instance_parameter_value nios2_gen2_0 {setting_branchpredictiontype} {Dynamic}
    set_instance_parameter_value nios2_gen2_0 {setting_bhtPtrSz} {8}
    set_instance_parameter_value nios2_gen2_0 {cpuArchRev} {1}
    set_instance_parameter_value nios2_gen2_0 {mul_shift_choice} {0}
    set_instance_parameter_value nios2_gen2_0 {mul_32_impl} {2}
    set_instance_parameter_value nios2_gen2_0 {mul_64_impl} {0}
    set_instance_parameter_value nios2_gen2_0 {shift_rot_impl} {1}
    set_instance_parameter_value nios2_gen2_0 {dividerType} {no_div}
    set_instance_parameter_value nios2_gen2_0 {mpu_minInstRegionSize} {12}
    set_instance_parameter_value nios2_gen2_0 {mpu_minDataRegionSize} {12}
    set_instance_parameter_value nios2_gen2_0 {mmu_uitlbNumEntries} {4}
    set_instance_parameter_value nios2_gen2_0 {mmu_udtlbNumEntries} {6}
    set_instance_parameter_value nios2_gen2_0 {mmu_tlbPtrSz} {7}
    set_instance_parameter_value nios2_gen2_0 {mmu_tlbNumWays} {16}
    set_instance_parameter_value nios2_gen2_0 {mmu_processIDNumBits} {8}
    set_instance_parameter_value nios2_gen2_0 {impl} {Tiny}
    set_instance_parameter_value nios2_gen2_0 {icache_size} {4096}
    set_instance_parameter_value nios2_gen2_0 {fa_cache_line} {2}
    set_instance_parameter_value nios2_gen2_0 {fa_cache_linesize} {0}
    set_instance_parameter_value nios2_gen2_0 {icache_tagramBlockType} {Automatic}
    set_instance_parameter_value nios2_gen2_0 {icache_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_gen2_0 {icache_numTCIM} {0}
    set_instance_parameter_value nios2_gen2_0 {icache_burstType} {None}
    set_instance_parameter_value nios2_gen2_0 {dcache_bursts} {false}
    set_instance_parameter_value nios2_gen2_0 {dcache_victim_buf_impl} {ram}
    set_instance_parameter_value nios2_gen2_0 {dcache_size} {2048}
    set_instance_parameter_value nios2_gen2_0 {dcache_tagramBlockType} {Automatic}
    set_instance_parameter_value nios2_gen2_0 {dcache_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_gen2_0 {dcache_numTCDM} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_exportvectors} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_usedesignware} {0}
    set_instance_parameter_value nios2_gen2_0 {setting_ecc_present} [get_parameter_value ecc_present]
    set_instance_parameter_value nios2_gen2_0 {setting_ic_ecc_present} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_rf_ecc_present} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_mmu_ecc_present} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_dc_ecc_present} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_itcm_ecc_present} {1}
    set_instance_parameter_value nios2_gen2_0 {setting_dtcm_ecc_present} {1}
    set_instance_parameter_value nios2_gen2_0 {regfile_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_gen2_0 {ocimem_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_gen2_0 {ocimem_ramInit} {0}
    set_instance_parameter_value nios2_gen2_0 {mmu_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_gen2_0 {bht_ramBlockType} {Automatic}
    set_instance_parameter_value nios2_gen2_0 {cdx_enabled} {0}
    set_instance_parameter_value nios2_gen2_0 {mpx_enabled} {0}
    set_instance_parameter_value nios2_gen2_0 {debug_enabled} {1}
    set_instance_parameter_value nios2_gen2_0 {debug_triggerArming} {1}
    set_instance_parameter_value nios2_gen2_0 {debug_debugReqSignals} {0}
    set_instance_parameter_value nios2_gen2_0 {debug_assignJtagInstanceID} {0}
    set_instance_parameter_value nios2_gen2_0 {debug_jtagInstanceID} {0}
    set_instance_parameter_value nios2_gen2_0 {debug_OCIOnchipTrace} {_128}
    set_instance_parameter_value nios2_gen2_0 {debug_hwbreakpoint} {0}
    set_instance_parameter_value nios2_gen2_0 {debug_datatrigger} {0}
    set_instance_parameter_value nios2_gen2_0 {debug_traceType} {none}
    set_instance_parameter_value nios2_gen2_0 {debug_traceStorage} {onchip_trace}
    set_instance_parameter_value nios2_gen2_0 {master_addr_map} {0}
    set_instance_parameter_value nios2_gen2_0 {instruction_master_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {instruction_master_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {flash_instruction_master_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {flash_instruction_master_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {data_master_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {data_master_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_instruction_master_0_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_instruction_master_0_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_instruction_master_1_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_instruction_master_1_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_instruction_master_2_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_instruction_master_2_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_instruction_master_3_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_instruction_master_3_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_data_master_0_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_data_master_0_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_data_master_1_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_data_master_1_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_data_master_2_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_data_master_2_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_data_master_3_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {tightly_coupled_data_master_3_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {instruction_master_high_performance_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {instruction_master_high_performance_paddr_size} {0.0}
    set_instance_parameter_value nios2_gen2_0 {data_master_high_performance_paddr_base} {0}
    set_instance_parameter_value nios2_gen2_0 {data_master_high_performance_paddr_size} {0.0}

    add_instance rmt_cmd altera_avalon_pio 16.1
    set_instance_parameter_value rmt_cmd {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value rmt_cmd {bitModifyingOutReg} {1}
    set_instance_parameter_value rmt_cmd {captureEdge} {0}
    set_instance_parameter_value rmt_cmd {direction} {Output}
    set_instance_parameter_value rmt_cmd {edgeType} {RISING}
    set_instance_parameter_value rmt_cmd {generateIRQ} {0}
    set_instance_parameter_value rmt_cmd {irqType} {LEVEL}
    set_instance_parameter_value rmt_cmd {resetValue} {0.0}
    set_instance_parameter_value rmt_cmd {simDoTestBenchWiring} {0}
    set_instance_parameter_value rmt_cmd {simDrivenValue} {0.0}
    set_instance_parameter_value rmt_cmd {width} {8}

    add_instance rmt_cmd_new altera_avalon_pio 16.1
    set_instance_parameter_value rmt_cmd_new {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value rmt_cmd_new {bitModifyingOutReg} {0}
    set_instance_parameter_value rmt_cmd_new {captureEdge} {0}
    set_instance_parameter_value rmt_cmd_new {direction} {Output}
    set_instance_parameter_value rmt_cmd_new {edgeType} {RISING}
    set_instance_parameter_value rmt_cmd_new {generateIRQ} {0}
    set_instance_parameter_value rmt_cmd_new {irqType} {LEVEL}
    set_instance_parameter_value rmt_cmd_new {resetValue} {0.0}
    set_instance_parameter_value rmt_cmd_new {simDoTestBenchWiring} {0}
    set_instance_parameter_value rmt_cmd_new {simDrivenValue} {0.0}
    set_instance_parameter_value rmt_cmd_new {width} {1}

    add_instance rmt_sts altera_avalon_pio 16.1
    set_instance_parameter_value rmt_sts {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value rmt_sts {bitModifyingOutReg} {0}
    set_instance_parameter_value rmt_sts {captureEdge} {0}
    set_instance_parameter_value rmt_sts {direction} {Input}
    set_instance_parameter_value rmt_sts {edgeType} {RISING}
    set_instance_parameter_value rmt_sts {generateIRQ} {0}
    set_instance_parameter_value rmt_sts {irqType} {LEVEL}
    set_instance_parameter_value rmt_sts {resetValue} {0.0}
    set_instance_parameter_value rmt_sts {simDoTestBenchWiring} {0}
    set_instance_parameter_value rmt_sts {simDrivenValue} {0.0}
    set_instance_parameter_value rmt_sts {width} {6}

    add_instance rmt_sts_new altera_avalon_pio 16.1
    set_instance_parameter_value rmt_sts_new {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value rmt_sts_new {bitModifyingOutReg} {0}
    set_instance_parameter_value rmt_sts_new {captureEdge} {0}
    set_instance_parameter_value rmt_sts_new {direction} {Input}
    set_instance_parameter_value rmt_sts_new {edgeType} {RISING}
    set_instance_parameter_value rmt_sts_new {generateIRQ} {0}
    set_instance_parameter_value rmt_sts_new {irqType} {LEVEL}
    set_instance_parameter_value rmt_sts_new {resetValue} {0.0}
    set_instance_parameter_value rmt_sts_new {simDoTestBenchWiring} {0}
    set_instance_parameter_value rmt_sts_new {simDrivenValue} {0.0}
    set_instance_parameter_value rmt_sts_new {width} {1}

    add_instance rxeq_sts altera_avalon_pio 16.1
    set_instance_parameter_value rxeq_sts {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value rxeq_sts {bitModifyingOutReg} {1}
    set_instance_parameter_value rxeq_sts {captureEdge} {0}
    set_instance_parameter_value rxeq_sts {direction} {Output}
    set_instance_parameter_value rxeq_sts {edgeType} {RISING}
    set_instance_parameter_value rxeq_sts {generateIRQ} {0}
    set_instance_parameter_value rxeq_sts {irqType} {LEVEL}
    set_instance_parameter_value rxeq_sts {resetValue} {0.0}
    set_instance_parameter_value rxeq_sts {simDoTestBenchWiring} {0}
    set_instance_parameter_value rxeq_sts {simDrivenValue} {0.0}
    set_instance_parameter_value rxeq_sts {width} {9}

    add_instance training_sts altera_avalon_pio 16.1
    set_instance_parameter_value training_sts {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value training_sts {bitModifyingOutReg} {1}
    set_instance_parameter_value training_sts {captureEdge} {0}
    set_instance_parameter_value training_sts {direction} {Output}
    set_instance_parameter_value training_sts {edgeType} {RISING}
    set_instance_parameter_value training_sts {generateIRQ} {0}
    set_instance_parameter_value training_sts {irqType} {LEVEL}
    set_instance_parameter_value training_sts {resetValue} {0.0}
    set_instance_parameter_value training_sts {simDoTestBenchWiring} {0}
    set_instance_parameter_value training_sts {simDrivenValue} {0.0}
    set_instance_parameter_value training_sts {width} {5}

    # connections and connection parameters
    add_connection nios2_gen2_0.data_master jtag_uart_0.avalon_jtag_slave avalon
    set_connection_parameter_value nios2_gen2_0.data_master/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/jtag_uart_0.avalon_jtag_slave baseAddress {0x0100d0a0}
    set_connection_parameter_value nios2_gen2_0.data_master/jtag_uart_0.avalon_jtag_slave defaultConnection {0}

    add_connection nios2_gen2_0.data_master nios2_gen2_0.debug_mem_slave avalon
    set_connection_parameter_value nios2_gen2_0.data_master/nios2_gen2_0.debug_mem_slave arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/nios2_gen2_0.debug_mem_slave baseAddress {0x0100c800}
    set_connection_parameter_value nios2_gen2_0.data_master/nios2_gen2_0.debug_mem_slave defaultConnection {0}

    add_connection nios2_gen2_0.data_master mm_bridge_0.s0 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/mm_bridge_0.s0 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/mm_bridge_0.s0 baseAddress {0x00100000}
    set_connection_parameter_value nios2_gen2_0.data_master/mm_bridge_0.s0 defaultConnection {0}

    add_connection nios2_gen2_0.data_master rmt_sts.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_sts.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_sts.s1 baseAddress {0x00090020}
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_sts.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master bert_done.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/bert_done.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/bert_done.s1 baseAddress {0x00090040}
    set_connection_parameter_value nios2_gen2_0.data_master/bert_done.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master ber_in_0.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/ber_in_0.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/ber_in_0.s1 baseAddress {0x00090030}
    set_connection_parameter_value nios2_gen2_0.data_master/ber_in_0.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master clear_ber.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/clear_ber.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/clear_ber.s1 baseAddress {0x000a0000}
    set_connection_parameter_value nios2_gen2_0.data_master/clear_ber.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master rmt_cmd.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_cmd.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_cmd.s1 baseAddress {0x000a0020}
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_cmd.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master rmt_sts_new.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_sts_new.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_sts_new.s1 baseAddress {0x00090010}
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_sts_new.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master enable.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/enable.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/enable.s1 baseAddress {0x00090000}
    set_connection_parameter_value nios2_gen2_0.data_master/enable.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master dmem.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/dmem.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/dmem.s1 baseAddress {0x00080000}
    set_connection_parameter_value nios2_gen2_0.data_master/dmem.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master imem.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/imem.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/imem.s1 baseAddress {0x0000}
    set_connection_parameter_value nios2_gen2_0.data_master/imem.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master training_sts.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/training_sts.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/training_sts.s1 baseAddress {0x000a0040}
    set_connection_parameter_value nios2_gen2_0.data_master/training_sts.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master rxeq_sts.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/rxeq_sts.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/rxeq_sts.s1 baseAddress {0x000a0060}
    set_connection_parameter_value nios2_gen2_0.data_master/rxeq_sts.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master ber_zero.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/ber_zero.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/ber_zero.s1 baseAddress {0x000a0080}
    set_connection_parameter_value nios2_gen2_0.data_master/ber_zero.s1 defaultConnection {0}

    add_connection nios2_gen2_0.data_master rmt_cmd_new.s1 avalon
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_cmd_new.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_cmd_new.s1 baseAddress {0x000a0010}
    set_connection_parameter_value nios2_gen2_0.data_master/rmt_cmd_new.s1 defaultConnection {0}

    add_connection nios2_gen2_0.instruction_master nios2_gen2_0.debug_mem_slave avalon
    set_connection_parameter_value nios2_gen2_0.instruction_master/nios2_gen2_0.debug_mem_slave arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.instruction_master/nios2_gen2_0.debug_mem_slave baseAddress {0x0100c800}
    set_connection_parameter_value nios2_gen2_0.instruction_master/nios2_gen2_0.debug_mem_slave defaultConnection {0}

    add_connection nios2_gen2_0.instruction_master imem.s1 avalon
    set_connection_parameter_value nios2_gen2_0.instruction_master/imem.s1 arbitrationPriority {1}
    set_connection_parameter_value nios2_gen2_0.instruction_master/imem.s1 baseAddress {0x0000}
    set_connection_parameter_value nios2_gen2_0.instruction_master/imem.s1 defaultConnection {0}

    add_connection clk_0.clk enable.clk clock

    add_connection clk_0.clk rmt_sts_new.clk clock

    add_connection clk_0.clk rmt_sts.clk clock

    add_connection clk_0.clk ber_in_0.clk clock

    add_connection clk_0.clk rmt_cmd.clk clock

    add_connection clk_0.clk clear_ber.clk clock

    add_connection clk_0.clk training_sts.clk clock

    add_connection clk_0.clk ber_zero.clk clock

    add_connection clk_0.clk rxeq_sts.clk clock

    add_connection clk_0.clk mm_bridge_0.clk clock

    add_connection clk_0.clk jtag_uart_0.clk clock

    add_connection clk_0.clk rmt_cmd_new.clk clock

    add_connection clk_0.clk bert_done.clk clock

    add_connection clk_0.clk nios2_gen2_0.clk clock

    add_connection clk_0.clk imem.clk1 clock

    add_connection clk_0.clk dmem.clk1 clock

    add_connection clk_0.clk_reset enable.reset reset

    add_connection clk_0.clk_reset rmt_sts_new.reset reset

    add_connection clk_0.clk_reset rmt_sts.reset reset

    add_connection clk_0.clk_reset ber_in_0.reset reset

    add_connection clk_0.clk_reset rmt_cmd.reset reset

    add_connection clk_0.clk_reset clear_ber.reset reset

    add_connection clk_0.clk_reset training_sts.reset reset

    add_connection clk_0.clk_reset ber_zero.reset reset

    add_connection clk_0.clk_reset rxeq_sts.reset reset

    add_connection clk_0.clk_reset mm_bridge_0.reset reset

    add_connection clk_0.clk_reset jtag_uart_0.reset reset

    add_connection clk_0.clk_reset rmt_cmd_new.reset reset

    add_connection clk_0.clk_reset bert_done.reset reset

    add_connection clk_0.clk_reset nios2_gen2_0.reset reset

    add_connection clk_0.clk_reset imem.reset1 reset

    add_connection clk_0.clk_reset dmem.reset1 reset

    add_connection nios2_gen2_0.debug_reset_request nios2_gen2_0.reset reset

    # exported interfaces
    add_interface avmm avalon master
    set_interface_property avmm EXPORT_OF mm_bridge_0.m0
    add_interface ber_in conduit end
    set_interface_property ber_in EXPORT_OF ber_in_0.external_connection
    add_interface ber_zero conduit end
    set_interface_property ber_zero EXPORT_OF ber_zero.external_connection
    add_interface bert_done conduit end
    set_interface_property bert_done EXPORT_OF bert_done.external_connection
    add_interface clear_ber conduit end
    set_interface_property clear_ber EXPORT_OF clear_ber.external_connection
    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk_0.clk_in
    add_interface enable conduit end
    set_interface_property enable EXPORT_OF enable.external_connection
    add_interface reset reset sink
    set_interface_property reset EXPORT_OF clk_0.clk_in_reset
    add_interface rmt_cmd conduit end
    set_interface_property rmt_cmd EXPORT_OF rmt_cmd.external_connection
    add_interface rmt_cmd_new conduit end
    set_interface_property rmt_cmd_new EXPORT_OF rmt_cmd_new.external_connection
    add_interface rmt_sts conduit end
    set_interface_property rmt_sts EXPORT_OF rmt_sts.external_connection
    add_interface rmt_sts_new conduit end
    set_interface_property rmt_sts_new EXPORT_OF rmt_sts_new.external_connection
    add_interface rxeq_sts conduit end
    set_interface_property rxeq_sts EXPORT_OF rxeq_sts.external_connection
    add_interface training_sts conduit end
    set_interface_property training_sts EXPORT_OF training_sts.external_connection

    # interconnect requirements
    set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
    set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
    set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
}
