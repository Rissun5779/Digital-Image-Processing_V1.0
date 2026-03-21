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


# qsys scripting (.tcl) file for nios
package require -exact qsys 16.0

create_system {nios}

set_project_property DEVICE_FAMILY {Arria 10}
set_project_property DEVICE {10AX115S2F45I2SGE2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance color_depth_pio altera_avalon_pio
set_instance_parameter_value color_depth_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value color_depth_pio {bitModifyingOutReg} {0}
set_instance_parameter_value color_depth_pio {captureEdge} {1}
set_instance_parameter_value color_depth_pio {direction} {Input}
set_instance_parameter_value color_depth_pio {edgeType} {ANY}
set_instance_parameter_value color_depth_pio {generateIRQ} {1}
set_instance_parameter_value color_depth_pio {irqType} {EDGE}
set_instance_parameter_value color_depth_pio {resetValue} {0.0}
set_instance_parameter_value color_depth_pio {simDoTestBenchWiring} {1}
set_instance_parameter_value color_depth_pio {simDrivenValue} {0.0}
set_instance_parameter_value color_depth_pio {width} {2}

add_instance cpu altera_nios2_gen2
set_instance_parameter_value cpu {tmr_enabled} {0}
set_instance_parameter_value cpu {setting_disable_tmr_inj} {0}
set_instance_parameter_value cpu {setting_showUnpublishedSettings} {0}
set_instance_parameter_value cpu {setting_showInternalSettings} {0}
set_instance_parameter_value cpu {setting_preciseIllegalMemAccessException} {0}
set_instance_parameter_value cpu {setting_exportPCB} {0}
set_instance_parameter_value cpu {setting_exportdebuginfo} {0}
set_instance_parameter_value cpu {setting_clearXBitsLDNonBypass} {1}
set_instance_parameter_value cpu {setting_bigEndian} {0}
set_instance_parameter_value cpu {setting_export_large_RAMs} {0}
set_instance_parameter_value cpu {setting_asic_enabled} {0}
set_instance_parameter_value cpu {register_file_por} {0}
set_instance_parameter_value cpu {setting_asic_synopsys_translate_on_off} {0}
set_instance_parameter_value cpu {setting_asic_third_party_synthesis} {0}
set_instance_parameter_value cpu {setting_asic_add_scan_mode_input} {0}
set_instance_parameter_value cpu {setting_oci_version} {1}
set_instance_parameter_value cpu {setting_fast_register_read} {0}
set_instance_parameter_value cpu {setting_exportHostDebugPort} {0}
set_instance_parameter_value cpu {setting_oci_export_jtag_signals} {0}
set_instance_parameter_value cpu {setting_avalonDebugPortPresent} {0}
set_instance_parameter_value cpu {setting_alwaysEncrypt} {1}
set_instance_parameter_value cpu {io_regionbase} {0}
set_instance_parameter_value cpu {io_regionsize} {0}
set_instance_parameter_value cpu {setting_support31bitdcachebypass} {1}
set_instance_parameter_value cpu {setting_activateTrace} {1}
set_instance_parameter_value cpu {setting_allow_break_inst} {0}
set_instance_parameter_value cpu {setting_activateTestEndChecker} {0}
set_instance_parameter_value cpu {setting_ecc_sim_test_ports} {0}
set_instance_parameter_value cpu {setting_disableocitrace} {0}
set_instance_parameter_value cpu {setting_activateMonitors} {1}
set_instance_parameter_value cpu {setting_HDLSimCachesCleared} {1}
set_instance_parameter_value cpu {setting_HBreakTest} {0}
set_instance_parameter_value cpu {setting_breakslaveoveride} {0}
set_instance_parameter_value cpu {mpu_useLimit} {0}
set_instance_parameter_value cpu {mpu_enabled} {0}
set_instance_parameter_value cpu {mmu_enabled} {0}
set_instance_parameter_value cpu {mmu_autoAssignTlbPtrSz} {1}
set_instance_parameter_value cpu {cpuReset} {0}
set_instance_parameter_value cpu {resetrequest_enabled} {1}
set_instance_parameter_value cpu {setting_removeRAMinit} {0}
set_instance_parameter_value cpu {setting_tmr_output_disable} {0}
set_instance_parameter_value cpu {setting_shadowRegisterSets} {0}
set_instance_parameter_value cpu {mpu_numOfInstRegion} {8}
set_instance_parameter_value cpu {mpu_numOfDataRegion} {8}
set_instance_parameter_value cpu {mmu_TLBMissExcOffset} {0}
set_instance_parameter_value cpu {resetOffset} {0}
set_instance_parameter_value cpu {exceptionOffset} {32}
set_instance_parameter_value cpu {cpuID} {0}
set_instance_parameter_value cpu {breakOffset} {32}
set_instance_parameter_value cpu {userDefinedSettings} {}
set_instance_parameter_value cpu {tracefilename} {}
set_instance_parameter_value cpu {resetSlave} {cpu_ram.s1}
set_instance_parameter_value cpu {mmu_TLBMissExcSlave} {None}
set_instance_parameter_value cpu {exceptionSlave} {cpu_ram.s1}
set_instance_parameter_value cpu {breakSlave} {cpu.jtag_debug_module}
set_instance_parameter_value cpu {setting_interruptControllerType} {Internal}
set_instance_parameter_value cpu {setting_branchpredictiontype} {Dynamic}
set_instance_parameter_value cpu {setting_bhtPtrSz} {8}
set_instance_parameter_value cpu {cpuArchRev} {1}
set_instance_parameter_value cpu {mul_shift_choice} {0}
set_instance_parameter_value cpu {mul_32_impl} {3}
set_instance_parameter_value cpu {mul_64_impl} {0}
set_instance_parameter_value cpu {shift_rot_impl} {0}
set_instance_parameter_value cpu {dividerType} {no_div}
set_instance_parameter_value cpu {mpu_minInstRegionSize} {12}
set_instance_parameter_value cpu {mpu_minDataRegionSize} {12}
set_instance_parameter_value cpu {mmu_uitlbNumEntries} {4}
set_instance_parameter_value cpu {mmu_udtlbNumEntries} {6}
set_instance_parameter_value cpu {mmu_tlbPtrSz} {7}
set_instance_parameter_value cpu {mmu_tlbNumWays} {16}
set_instance_parameter_value cpu {mmu_processIDNumBits} {8}
set_instance_parameter_value cpu {impl} {Tiny}
set_instance_parameter_value cpu {icache_size} {4096}
set_instance_parameter_value cpu {fa_cache_line} {2}
set_instance_parameter_value cpu {fa_cache_linesize} {0}
set_instance_parameter_value cpu {icache_tagramBlockType} {Automatic}
set_instance_parameter_value cpu {icache_ramBlockType} {Automatic}
set_instance_parameter_value cpu {icache_numTCIM} {0}
set_instance_parameter_value cpu {icache_burstType} {None}
set_instance_parameter_value cpu {dcache_bursts} {false}
set_instance_parameter_value cpu {dcache_victim_buf_impl} {ram}
set_instance_parameter_value cpu {dcache_size} {2048}
set_instance_parameter_value cpu {dcache_tagramBlockType} {Automatic}
set_instance_parameter_value cpu {dcache_ramBlockType} {Automatic}
set_instance_parameter_value cpu {dcache_numTCDM} {0}
set_instance_parameter_value cpu {setting_exportvectors} {0}
set_instance_parameter_value cpu {setting_usedesignware} {0}
set_instance_parameter_value cpu {setting_ecc_present} {0}
set_instance_parameter_value cpu {setting_ic_ecc_present} {1}
set_instance_parameter_value cpu {setting_rf_ecc_present} {1}
set_instance_parameter_value cpu {setting_mmu_ecc_present} {1}
set_instance_parameter_value cpu {setting_dc_ecc_present} {0}
set_instance_parameter_value cpu {setting_itcm_ecc_present} {0}
set_instance_parameter_value cpu {setting_dtcm_ecc_present} {0}
set_instance_parameter_value cpu {regfile_ramBlockType} {Automatic}
set_instance_parameter_value cpu {ocimem_ramBlockType} {Automatic}
set_instance_parameter_value cpu {ocimem_ramInit} {0}
set_instance_parameter_value cpu {mmu_ramBlockType} {Automatic}
set_instance_parameter_value cpu {bht_ramBlockType} {Automatic}
set_instance_parameter_value cpu {cdx_enabled} {0}
set_instance_parameter_value cpu {mpx_enabled} {0}
set_instance_parameter_value cpu {debug_enabled} {1}
set_instance_parameter_value cpu {debug_triggerArming} {1}
set_instance_parameter_value cpu {debug_debugReqSignals} {0}
set_instance_parameter_value cpu {debug_assignJtagInstanceID} {0}
set_instance_parameter_value cpu {debug_jtagInstanceID} {0}
set_instance_parameter_value cpu {debug_OCIOnchipTrace} {_128}
set_instance_parameter_value cpu {debug_hwbreakpoint} {0}
set_instance_parameter_value cpu {debug_datatrigger} {0}
set_instance_parameter_value cpu {debug_traceType} {none}
set_instance_parameter_value cpu {debug_traceStorage} {onchip_trace}
set_instance_parameter_value cpu {master_addr_map} {0}
set_instance_parameter_value cpu {instruction_master_paddr_base} {0}
set_instance_parameter_value cpu {instruction_master_paddr_size} {0.0}
set_instance_parameter_value cpu {flash_instruction_master_paddr_base} {0}
set_instance_parameter_value cpu {flash_instruction_master_paddr_size} {0.0}
set_instance_parameter_value cpu {data_master_paddr_base} {0}
set_instance_parameter_value cpu {data_master_paddr_size} {0.0}
set_instance_parameter_value cpu {tightly_coupled_instruction_master_0_paddr_base} {0}
set_instance_parameter_value cpu {tightly_coupled_instruction_master_0_paddr_size} {0.0}
set_instance_parameter_value cpu {tightly_coupled_instruction_master_1_paddr_base} {0}
set_instance_parameter_value cpu {tightly_coupled_instruction_master_1_paddr_size} {0.0}
set_instance_parameter_value cpu {tightly_coupled_instruction_master_2_paddr_base} {0}
set_instance_parameter_value cpu {tightly_coupled_instruction_master_2_paddr_size} {0.0}
set_instance_parameter_value cpu {tightly_coupled_instruction_master_3_paddr_base} {0}
set_instance_parameter_value cpu {tightly_coupled_instruction_master_3_paddr_size} {0.0}
set_instance_parameter_value cpu {tightly_coupled_data_master_0_paddr_base} {0}
set_instance_parameter_value cpu {tightly_coupled_data_master_0_paddr_size} {0.0}
set_instance_parameter_value cpu {tightly_coupled_data_master_1_paddr_base} {0}
set_instance_parameter_value cpu {tightly_coupled_data_master_1_paddr_size} {0.0}
set_instance_parameter_value cpu {tightly_coupled_data_master_2_paddr_base} {0}
set_instance_parameter_value cpu {tightly_coupled_data_master_2_paddr_size} {0.0}
set_instance_parameter_value cpu {tightly_coupled_data_master_3_paddr_base} {0}
set_instance_parameter_value cpu {tightly_coupled_data_master_3_paddr_size} {0.0}
set_instance_parameter_value cpu {instruction_master_high_performance_paddr_base} {0}
set_instance_parameter_value cpu {instruction_master_high_performance_paddr_size} {0.0}
set_instance_parameter_value cpu {data_master_high_performance_paddr_base} {0}
set_instance_parameter_value cpu {data_master_high_performance_paddr_size} {0.0}

add_instance cpu_clk clock_source
set_instance_parameter_value cpu_clk {clockFrequency} {100000000.0}
set_instance_parameter_value cpu_clk {clockFrequencyKnown} {1}
set_instance_parameter_value cpu_clk {resetSynchronousEdges} {NONE}

add_instance cpu_ram altera_avalon_onchip_memory2
set_instance_parameter_value cpu_ram {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value cpu_ram {blockType} {AUTO}
set_instance_parameter_value cpu_ram {dataWidth} {32}
set_instance_parameter_value cpu_ram {dataWidth2} {32}
set_instance_parameter_value cpu_ram {dualPort} {0}
set_instance_parameter_value cpu_ram {enableDiffWidth} {0}
set_instance_parameter_value cpu_ram {initMemContent} {1}
set_instance_parameter_value cpu_ram {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value cpu_ram {enPRInitMode} {0}
set_instance_parameter_value cpu_ram {instanceID} {NONE}
set_instance_parameter_value cpu_ram {memorySize} {120000.0}
set_instance_parameter_value cpu_ram {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value cpu_ram {simAllowMRAMContentsFile} {0}
set_instance_parameter_value cpu_ram {simMemInitOnlyFilename} {0}
set_instance_parameter_value cpu_ram {singleClockOperation} {0}
set_instance_parameter_value cpu_ram {slave1Latency} {1}
set_instance_parameter_value cpu_ram {slave2Latency} {1}
set_instance_parameter_value cpu_ram {useNonDefaultInitFile} {0}
set_instance_parameter_value cpu_ram {copyInitFile} {0}
set_instance_parameter_value cpu_ram {useShallowMemBlocks} {0}
set_instance_parameter_value cpu_ram {writable} {1}
set_instance_parameter_value cpu_ram {ecc_enabled} {0}
set_instance_parameter_value cpu_ram {resetrequest_enabled} {1}

add_instance jtag_uart_0 altera_avalon_jtag_uart
set_instance_parameter_value jtag_uart_0 {allowMultipleConnections} {0}
set_instance_parameter_value jtag_uart_0 {hubInstanceID} {0}
set_instance_parameter_value jtag_uart_0 {readBufferDepth} {1024}
set_instance_parameter_value jtag_uart_0 {readIRQThreshold} {1}
set_instance_parameter_value jtag_uart_0 {simInputCharacterStream} {}
set_instance_parameter_value jtag_uart_0 {simInteractiveOptions} {NO_INTERACTIVE_WINDOWS}
set_instance_parameter_value jtag_uart_0 {useRegistersForReadBuffer} {0}
set_instance_parameter_value jtag_uart_0 {useRegistersForWriteBuffer} {0}
set_instance_parameter_value jtag_uart_0 {useRelativePathForSimFile} {0}
set_instance_parameter_value jtag_uart_0 {writeBufferDepth} {1024}
set_instance_parameter_value jtag_uart_0 {writeIRQThreshold} {1}

add_instance measure_pio altera_avalon_pio
set_instance_parameter_value measure_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value measure_pio {bitModifyingOutReg} {0}
set_instance_parameter_value measure_pio {captureEdge} {1}
set_instance_parameter_value measure_pio {direction} {Input}
set_instance_parameter_value measure_pio {edgeType} {ANY}
set_instance_parameter_value measure_pio {generateIRQ} {1}
set_instance_parameter_value measure_pio {irqType} {EDGE}
set_instance_parameter_value measure_pio {resetValue} {0.0}
set_instance_parameter_value measure_pio {simDoTestBenchWiring} {1}
set_instance_parameter_value measure_pio {simDrivenValue} {0.0}
set_instance_parameter_value measure_pio {width} {24}

add_instance measure_valid_pio altera_avalon_pio
set_instance_parameter_value measure_valid_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value measure_valid_pio {bitModifyingOutReg} {0}
set_instance_parameter_value measure_valid_pio {captureEdge} {1}
set_instance_parameter_value measure_valid_pio {direction} {Input}
set_instance_parameter_value measure_valid_pio {edgeType} {ANY}
set_instance_parameter_value measure_valid_pio {generateIRQ} {1}
set_instance_parameter_value measure_valid_pio {irqType} {EDGE}
set_instance_parameter_value measure_valid_pio {resetValue} {0.0}
set_instance_parameter_value measure_valid_pio {simDoTestBenchWiring} {1}
set_instance_parameter_value measure_valid_pio {simDrivenValue} {0.0}
set_instance_parameter_value measure_valid_pio {width} {1}

add_instance oc_i2c_master_av_slave_translator altera_merlin_slave_translator
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_ADDRESS_W} {3}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_DATA_W} {32} #32
set_instance_parameter_value oc_i2c_master_av_slave_translator {UAV_DATA_W} {32} #32
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_BURSTCOUNT_W} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_BYTEENABLE_W} {4}
set_instance_parameter_value oc_i2c_master_av_slave_translator {UAV_BYTEENABLE_W} {4}
set_instance_parameter_value oc_i2c_master_av_slave_translator {UAV_ADDRESS_W} {5}
set_instance_parameter_value oc_i2c_master_av_slave_translator {UAV_BURSTCOUNT_W} {3}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_READLATENCY} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_SETUP_WAIT} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_WRITE_WAIT} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_READ_WAIT} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_DATA_HOLD} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_TIMING_UNITS} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_READDATA} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_WRITEDATA} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_READ} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_WRITE} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_BEGINBURSTTRANSFER} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_BEGINTRANSFER} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_BYTEENABLE} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_CHIPSELECT} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_ADDRESS} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_BURSTCOUNT} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_READDATAVALID} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_WAITREQUEST} {1}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_WRITEBYTEENABLE} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_LOCK} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_AV_CLKEN} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_UAV_CLKEN} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_OUTPUTENABLE} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_DEBUGACCESS} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_READRESPONSE} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {USE_WRITERESPONSE} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_SYMBOLS_PER_WORD} {4}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_ADDRESS_SYMBOLS} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_BURSTCOUNT_SYMBOLS} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {UAV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_REQUIRE_UNALIGNED_ADDRESSES} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_LINEWRAPBURSTS} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_MAX_PENDING_READ_TRANSACTIONS} {64}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_MAX_PENDING_WRITE_TRANSACTIONS} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_BURSTBOUNDARIES} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_INTERLEAVEBURSTS} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_BITS_PER_SYMBOL} {8}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_ISBIGENDIAN} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_ADDRESSGROUP} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {UAV_ADDRESSGROUP} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_REGISTEROUTGOINGSIGNALS} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_REGISTERINCOMINGSIGNALS} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {AV_ALWAYSBURSTMAXBURST} {0}
set_instance_parameter_value oc_i2c_master_av_slave_translator {CHIPSELECT_THROUGH_READLATENCY} {0}

add_instance oc_i2c_master_ti altera_merlin_slave_translator
set_instance_parameter_value oc_i2c_master_ti {AV_ADDRESS_W} {3}
set_instance_parameter_value oc_i2c_master_ti {AV_DATA_W} {32}
set_instance_parameter_value oc_i2c_master_ti {UAV_DATA_W} {32}
set_instance_parameter_value oc_i2c_master_ti {AV_BURSTCOUNT_W} {1}
set_instance_parameter_value oc_i2c_master_ti {AV_BYTEENABLE_W} {4}
set_instance_parameter_value oc_i2c_master_ti {UAV_BYTEENABLE_W} {4}
set_instance_parameter_value oc_i2c_master_ti {UAV_ADDRESS_W} {5}
set_instance_parameter_value oc_i2c_master_ti {UAV_BURSTCOUNT_W} {3}
set_instance_parameter_value oc_i2c_master_ti {AV_READLATENCY} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_SETUP_WAIT} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_WRITE_WAIT} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_READ_WAIT} {1}
set_instance_parameter_value oc_i2c_master_ti {AV_DATA_HOLD} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_TIMING_UNITS} {1}
set_instance_parameter_value oc_i2c_master_ti {USE_READDATA} {1}
set_instance_parameter_value oc_i2c_master_ti {USE_WRITEDATA} {1}
set_instance_parameter_value oc_i2c_master_ti {USE_READ} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_WRITE} {1}
set_instance_parameter_value oc_i2c_master_ti {USE_BEGINBURSTTRANSFER} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_BEGINTRANSFER} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_BYTEENABLE} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_CHIPSELECT} {1}
set_instance_parameter_value oc_i2c_master_ti {USE_ADDRESS} {1}
set_instance_parameter_value oc_i2c_master_ti {USE_BURSTCOUNT} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_READDATAVALID} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_WAITREQUEST} {1}
set_instance_parameter_value oc_i2c_master_ti {USE_WRITEBYTEENABLE} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_LOCK} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_AV_CLKEN} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_UAV_CLKEN} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_OUTPUTENABLE} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_DEBUGACCESS} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_READRESPONSE} {0}
set_instance_parameter_value oc_i2c_master_ti {USE_WRITERESPONSE} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_SYMBOLS_PER_WORD} {4}
set_instance_parameter_value oc_i2c_master_ti {AV_ADDRESS_SYMBOLS} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_BURSTCOUNT_SYMBOLS} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value oc_i2c_master_ti {UAV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_REQUIRE_UNALIGNED_ADDRESSES} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_LINEWRAPBURSTS} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_MAX_PENDING_READ_TRANSACTIONS} {64}
set_instance_parameter_value oc_i2c_master_ti {AV_MAX_PENDING_WRITE_TRANSACTIONS} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_BURSTBOUNDARIES} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_INTERLEAVEBURSTS} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_BITS_PER_SYMBOL} {8}
set_instance_parameter_value oc_i2c_master_ti {AV_ISBIGENDIAN} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_ADDRESSGROUP} {0}
set_instance_parameter_value oc_i2c_master_ti {UAV_ADDRESSGROUP} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_REGISTEROUTGOINGSIGNALS} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_REGISTERINCOMINGSIGNALS} {0}
set_instance_parameter_value oc_i2c_master_ti {AV_ALWAYSBURSTMAXBURST} {0}
set_instance_parameter_value oc_i2c_master_ti {CHIPSELECT_THROUGH_READLATENCY} {0}

add_instance sysid_qsys_0 altera_avalon_sysid_qsys
set_instance_parameter_value sysid_qsys_0 {id} {0}

add_instance tmds_bit_clock_ratio_pio altera_avalon_pio
set_instance_parameter_value tmds_bit_clock_ratio_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value tmds_bit_clock_ratio_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tmds_bit_clock_ratio_pio {captureEdge} {1}
set_instance_parameter_value tmds_bit_clock_ratio_pio {direction} {Input}
set_instance_parameter_value tmds_bit_clock_ratio_pio {edgeType} {ANY}
set_instance_parameter_value tmds_bit_clock_ratio_pio {generateIRQ} {1}
set_instance_parameter_value tmds_bit_clock_ratio_pio {irqType} {EDGE}
set_instance_parameter_value tmds_bit_clock_ratio_pio {resetValue} {0.0}
set_instance_parameter_value tmds_bit_clock_ratio_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value tmds_bit_clock_ratio_pio {simDrivenValue} {0.0}
set_instance_parameter_value tmds_bit_clock_ratio_pio {width} {1}

add_instance tx_hpd_ack_pio altera_avalon_pio
set_instance_parameter_value tx_hpd_ack_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value tx_hpd_ack_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_hpd_ack_pio {captureEdge} {0}
set_instance_parameter_value tx_hpd_ack_pio {direction} {Output}
set_instance_parameter_value tx_hpd_ack_pio {edgeType} {RISING}
set_instance_parameter_value tx_hpd_ack_pio {generateIRQ} {0}
set_instance_parameter_value tx_hpd_ack_pio {irqType} {LEVEL}
set_instance_parameter_value tx_hpd_ack_pio {resetValue} {0.0}
set_instance_parameter_value tx_hpd_ack_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value tx_hpd_ack_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_hpd_ack_pio {width} {1}

add_instance tx_hpd_req_pio altera_avalon_pio
set_instance_parameter_value tx_hpd_req_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value tx_hpd_req_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_hpd_req_pio {captureEdge} {1}
set_instance_parameter_value tx_hpd_req_pio {direction} {Input}
set_instance_parameter_value tx_hpd_req_pio {edgeType} {ANY}
set_instance_parameter_value tx_hpd_req_pio {generateIRQ} {1}
set_instance_parameter_value tx_hpd_req_pio {irqType} {EDGE}
set_instance_parameter_value tx_hpd_req_pio {resetValue} {0.0}
set_instance_parameter_value tx_hpd_req_pio {simDoTestBenchWiring} {1}
set_instance_parameter_value tx_hpd_req_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_hpd_req_pio {width} {1}

add_instance tx_iopll_rcfg_mgmt_translator altera_merlin_slave_translator
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_ADDRESS_W} {9}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_DATA_W} {32}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {UAV_DATA_W} {32}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_BURSTCOUNT_W} {1}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_BYTEENABLE_W} {4}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {UAV_BYTEENABLE_W} {4}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {UAV_ADDRESS_W} {12}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {UAV_BURSTCOUNT_W} {3}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_READLATENCY} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_SETUP_WAIT} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_WRITE_WAIT} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_READ_WAIT} {1}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_DATA_HOLD} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_TIMING_UNITS} {1}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_READDATA} {1}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_WRITEDATA} {1}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_READ} {1}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_WRITE} {1}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_BEGINBURSTTRANSFER} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_BEGINTRANSFER} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_BYTEENABLE} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_CHIPSELECT} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_ADDRESS} {1}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_BURSTCOUNT} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_READDATAVALID} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_WAITREQUEST} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_WRITEBYTEENABLE} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_LOCK} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_AV_CLKEN} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_UAV_CLKEN} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_OUTPUTENABLE} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_DEBUGACCESS} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_READRESPONSE} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {USE_WRITERESPONSE} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_SYMBOLS_PER_WORD} {4}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_ADDRESS_SYMBOLS} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_BURSTCOUNT_SYMBOLS} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {UAV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_REQUIRE_UNALIGNED_ADDRESSES} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_LINEWRAPBURSTS} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_MAX_PENDING_READ_TRANSACTIONS} {64}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_MAX_PENDING_WRITE_TRANSACTIONS} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_BURSTBOUNDARIES} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_INTERLEAVEBURSTS} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_BITS_PER_SYMBOL} {8}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_ISBIGENDIAN} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_ADDRESSGROUP} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {UAV_ADDRESSGROUP} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_REGISTEROUTGOINGSIGNALS} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_REGISTERINCOMINGSIGNALS} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {AV_ALWAYSBURSTMAXBURST} {0}
set_instance_parameter_value tx_iopll_rcfg_mgmt_translator {CHIPSELECT_THROUGH_READLATENCY} {0}

add_instance tx_iopll_waitrequest_pio altera_avalon_pio
set_instance_parameter_value tx_iopll_waitrequest_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value tx_iopll_waitrequest_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_iopll_waitrequest_pio {captureEdge} {1}
set_instance_parameter_value tx_iopll_waitrequest_pio {direction} {Input}
set_instance_parameter_value tx_iopll_waitrequest_pio {edgeType} {ANY}
set_instance_parameter_value tx_iopll_waitrequest_pio {generateIRQ} {1}
set_instance_parameter_value tx_iopll_waitrequest_pio {irqType} {EDGE}
set_instance_parameter_value tx_iopll_waitrequest_pio {resetValue} {0.0}
set_instance_parameter_value tx_iopll_waitrequest_pio {simDoTestBenchWiring} {1}
set_instance_parameter_value tx_iopll_waitrequest_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_iopll_waitrequest_pio {width} {1}

add_instance tx_os_pio altera_avalon_pio
set_instance_parameter_value tx_os_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value tx_os_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_os_pio {captureEdge} {0}
set_instance_parameter_value tx_os_pio {direction} {Output}
set_instance_parameter_value tx_os_pio {edgeType} {RISING}
set_instance_parameter_value tx_os_pio {generateIRQ} {0}
set_instance_parameter_value tx_os_pio {irqType} {LEVEL}
set_instance_parameter_value tx_os_pio {resetValue} {0.0}
set_instance_parameter_value tx_os_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value tx_os_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_os_pio {width} {2}

add_instance tx_pma_cal_busy_pio altera_avalon_pio
set_instance_parameter_value tx_pma_cal_busy_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value tx_pma_cal_busy_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_pma_cal_busy_pio {captureEdge} {1}
set_instance_parameter_value tx_pma_cal_busy_pio {direction} {Input}
set_instance_parameter_value tx_pma_cal_busy_pio {edgeType} {ANY}
set_instance_parameter_value tx_pma_cal_busy_pio {generateIRQ} {1}
set_instance_parameter_value tx_pma_cal_busy_pio {irqType} {EDGE}
set_instance_parameter_value tx_pma_cal_busy_pio {resetValue} {0.0}
set_instance_parameter_value tx_pma_cal_busy_pio {simDoTestBenchWiring} {1}
set_instance_parameter_value tx_pma_cal_busy_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_pma_cal_busy_pio {width} {1}

add_instance tx_pma_ch altera_avalon_pio
set_instance_parameter_value tx_pma_ch {bitClearingEdgeCapReg} {0}
set_instance_parameter_value tx_pma_ch {bitModifyingOutReg} {0}
set_instance_parameter_value tx_pma_ch {captureEdge} {0}
set_instance_parameter_value tx_pma_ch {direction} {Output}
set_instance_parameter_value tx_pma_ch {edgeType} {RISING}
set_instance_parameter_value tx_pma_ch {generateIRQ} {0}
set_instance_parameter_value tx_pma_ch {irqType} {LEVEL}
set_instance_parameter_value tx_pma_ch {resetValue} {0.0}
set_instance_parameter_value tx_pma_ch {simDoTestBenchWiring} {0}
set_instance_parameter_value tx_pma_ch {simDrivenValue} {0.0}
set_instance_parameter_value tx_pma_ch {width} {2}

add_instance tx_rcfg_en_pio altera_avalon_pio
set_instance_parameter_value tx_rcfg_en_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value tx_rcfg_en_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_rcfg_en_pio {captureEdge} {0}
set_instance_parameter_value tx_rcfg_en_pio {direction} {Output}
set_instance_parameter_value tx_rcfg_en_pio {edgeType} {RISING}
set_instance_parameter_value tx_rcfg_en_pio {generateIRQ} {0}
set_instance_parameter_value tx_rcfg_en_pio {irqType} {LEVEL}
set_instance_parameter_value tx_rcfg_en_pio {resetValue} {0.0}
set_instance_parameter_value tx_rcfg_en_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value tx_rcfg_en_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_rcfg_en_pio {width} {1}


add_instance edid_ram_access_pio altera_avalon_pio
set_instance_parameter_value edid_ram_access_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value edid_ram_access_pio {bitModifyingOutReg} {0}
set_instance_parameter_value edid_ram_access_pio {captureEdge} {0}
set_instance_parameter_value edid_ram_access_pio {direction} {Output}
set_instance_parameter_value edid_ram_access_pio {edgeType} {RISING}
set_instance_parameter_value edid_ram_access_pio {generateIRQ} {0}
set_instance_parameter_value edid_ram_access_pio {irqType} {LEVEL}
set_instance_parameter_value edid_ram_access_pio {resetValue} {0.0}
set_instance_parameter_value edid_ram_access_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value edid_ram_access_pio {simDrivenValue} {0.0}
set_instance_parameter_value edid_ram_access_pio {width} {1}

add_instance edid_ram_slave_translator altera_merlin_slave_translator
set_instance_parameter_value edid_ram_slave_translator {AV_ADDRESS_W} {8}
set_instance_parameter_value edid_ram_slave_translator {AV_DATA_W} {8}
set_instance_parameter_value edid_ram_slave_translator {UAV_DATA_W} {8}
set_instance_parameter_value edid_ram_slave_translator {AV_BURSTCOUNT_W} {1}
set_instance_parameter_value edid_ram_slave_translator {AV_BYTEENABLE_W} {1}
set_instance_parameter_value edid_ram_slave_translator {UAV_BYTEENABLE_W} {1}
set_instance_parameter_value edid_ram_slave_translator {UAV_ADDRESS_W} {11}
set_instance_parameter_value edid_ram_slave_translator {UAV_BURSTCOUNT_W} {3}
set_instance_parameter_value edid_ram_slave_translator {AV_READLATENCY} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_SETUP_WAIT} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_WRITE_WAIT} {1}
set_instance_parameter_value edid_ram_slave_translator {AV_READ_WAIT} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_DATA_HOLD} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_TIMING_UNITS} {1}
set_instance_parameter_value edid_ram_slave_translator {USE_READDATA} {1}
set_instance_parameter_value edid_ram_slave_translator {USE_WRITEDATA} {1}
set_instance_parameter_value edid_ram_slave_translator {USE_READ} {1}
set_instance_parameter_value edid_ram_slave_translator {USE_WRITE} {1}
set_instance_parameter_value edid_ram_slave_translator {USE_BEGINBURSTTRANSFER} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_BEGINTRANSFER} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_BYTEENABLE} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_CHIPSELECT} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_ADDRESS} {1}
set_instance_parameter_value edid_ram_slave_translator {USE_BURSTCOUNT} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_READDATAVALID} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_WAITREQUEST} {1}
set_instance_parameter_value edid_ram_slave_translator {USE_WRITEBYTEENABLE} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_LOCK} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_AV_CLKEN} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_UAV_CLKEN} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_OUTPUTENABLE} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_DEBUGACCESS} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_READRESPONSE} {0}
set_instance_parameter_value edid_ram_slave_translator {USE_WRITERESPONSE} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_SYMBOLS_PER_WORD} {4}
set_instance_parameter_value edid_ram_slave_translator {AV_ADDRESS_SYMBOLS} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_BURSTCOUNT_SYMBOLS} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value edid_ram_slave_translator {UAV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_REQUIRE_UNALIGNED_ADDRESSES} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_LINEWRAPBURSTS} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_MAX_PENDING_READ_TRANSACTIONS} {64}
set_instance_parameter_value edid_ram_slave_translator {AV_MAX_PENDING_WRITE_TRANSACTIONS} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_BURSTBOUNDARIES} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_INTERLEAVEBURSTS} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_BITS_PER_SYMBOL} {8}
set_instance_parameter_value edid_ram_slave_translator {AV_ISBIGENDIAN} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_ADDRESSGROUP} {0}
set_instance_parameter_value edid_ram_slave_translator {UAV_ADDRESSGROUP} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_REGISTEROUTGOINGSIGNALS} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_REGISTERINCOMINGSIGNALS} {0}
set_instance_parameter_value edid_ram_slave_translator {AV_ALWAYSBURSTMAXBURST} {0}
set_instance_parameter_value edid_ram_slave_translator {CHIPSELECT_THROUGH_READLATENCY} {0}

add_instance tx_pll_rcfg_mgmt_translator altera_merlin_slave_translator
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_ADDRESS_W} {10}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_DATA_W} {32}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {UAV_DATA_W} {32}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_BURSTCOUNT_W} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_BYTEENABLE_W} {4}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {UAV_BYTEENABLE_W} {4}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {UAV_ADDRESS_W} {12}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {UAV_BURSTCOUNT_W} {3}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_READLATENCY} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_SETUP_WAIT} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_WRITE_WAIT} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_READ_WAIT} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_DATA_HOLD} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_TIMING_UNITS} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_READDATA} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_WRITEDATA} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_READ} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_WRITE} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_BEGINBURSTTRANSFER} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_BEGINTRANSFER} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_BYTEENABLE} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_CHIPSELECT} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_ADDRESS} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_BURSTCOUNT} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_READDATAVALID} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_WAITREQUEST} {1}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_WRITEBYTEENABLE} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_LOCK} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_AV_CLKEN} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_UAV_CLKEN} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_OUTPUTENABLE} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_DEBUGACCESS} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_READRESPONSE} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {USE_WRITERESPONSE} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_SYMBOLS_PER_WORD} {4}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_ADDRESS_SYMBOLS} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_BURSTCOUNT_SYMBOLS} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {UAV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_REQUIRE_UNALIGNED_ADDRESSES} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_LINEWRAPBURSTS} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_MAX_PENDING_READ_TRANSACTIONS} {64}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_MAX_PENDING_WRITE_TRANSACTIONS} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_BURSTBOUNDARIES} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_INTERLEAVEBURSTS} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_BITS_PER_SYMBOL} {8}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_ISBIGENDIAN} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_ADDRESSGROUP} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {UAV_ADDRESSGROUP} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_REGISTEROUTGOINGSIGNALS} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_REGISTERINCOMINGSIGNALS} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {AV_ALWAYSBURSTMAXBURST} {0}
set_instance_parameter_value tx_pll_rcfg_mgmt_translator {CHIPSELECT_THROUGH_READLATENCY} {0}

add_instance tx_pll_waitrequest_pio altera_avalon_pio
set_instance_parameter_value tx_pll_waitrequest_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value tx_pll_waitrequest_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_pll_waitrequest_pio {captureEdge} {1}
set_instance_parameter_value tx_pll_waitrequest_pio {direction} {Input}
set_instance_parameter_value tx_pll_waitrequest_pio {edgeType} {ANY}
set_instance_parameter_value tx_pll_waitrequest_pio {generateIRQ} {1}
set_instance_parameter_value tx_pll_waitrequest_pio {irqType} {EDGE}
set_instance_parameter_value tx_pll_waitrequest_pio {resetValue} {0.0}
set_instance_parameter_value tx_pll_waitrequest_pio {simDoTestBenchWiring} {1}
set_instance_parameter_value tx_pll_waitrequest_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_pll_waitrequest_pio {width} {1}

add_instance tx_pma_rcfg_mgmt_translator altera_merlin_slave_translator
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_ADDRESS_W} {12}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_DATA_W} {32}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {UAV_DATA_W} {32}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_BURSTCOUNT_W} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_BYTEENABLE_W} {4}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {UAV_BYTEENABLE_W} {4}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {UAV_ADDRESS_W} {14}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {UAV_BURSTCOUNT_W} {3}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_READLATENCY} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_SETUP_WAIT} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_WRITE_WAIT} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_READ_WAIT} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_DATA_HOLD} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_TIMING_UNITS} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_READDATA} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_WRITEDATA} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_READ} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_WRITE} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_BEGINBURSTTRANSFER} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_BEGINTRANSFER} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_BYTEENABLE} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_CHIPSELECT} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_ADDRESS} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_BURSTCOUNT} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_READDATAVALID} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_WAITREQUEST} {1}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_WRITEBYTEENABLE} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_LOCK} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_AV_CLKEN} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_UAV_CLKEN} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_OUTPUTENABLE} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_DEBUGACCESS} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_READRESPONSE} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {USE_WRITERESPONSE} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_SYMBOLS_PER_WORD} {4}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_ADDRESS_SYMBOLS} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_BURSTCOUNT_SYMBOLS} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {UAV_CONSTANT_BURST_BEHAVIOR} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_REQUIRE_UNALIGNED_ADDRESSES} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_LINEWRAPBURSTS} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_MAX_PENDING_READ_TRANSACTIONS} {64}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_MAX_PENDING_WRITE_TRANSACTIONS} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_BURSTBOUNDARIES} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_INTERLEAVEBURSTS} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_BITS_PER_SYMBOL} {8}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_ISBIGENDIAN} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_ADDRESSGROUP} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {UAV_ADDRESSGROUP} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_REGISTEROUTGOINGSIGNALS} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_REGISTERINCOMINGSIGNALS} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {AV_ALWAYSBURSTMAXBURST} {0}
set_instance_parameter_value tx_pma_rcfg_mgmt_translator {CHIPSELECT_THROUGH_READLATENCY} {0}

add_instance tx_pma_waitrequest_pio altera_avalon_pio
set_instance_parameter_value tx_pma_waitrequest_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value tx_pma_waitrequest_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_pma_waitrequest_pio {captureEdge} {1}
set_instance_parameter_value tx_pma_waitrequest_pio {direction} {Input}
set_instance_parameter_value tx_pma_waitrequest_pio {edgeType} {ANY}
set_instance_parameter_value tx_pma_waitrequest_pio {generateIRQ} {1}
set_instance_parameter_value tx_pma_waitrequest_pio {irqType} {EDGE}
set_instance_parameter_value tx_pma_waitrequest_pio {resetValue} {0.0}
set_instance_parameter_value tx_pma_waitrequest_pio {simDoTestBenchWiring} {1}
set_instance_parameter_value tx_pma_waitrequest_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_pma_waitrequest_pio {width} {1}

add_instance tx_rst_pll_pio altera_avalon_pio
set_instance_parameter_value tx_rst_pll_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value tx_rst_pll_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_rst_pll_pio {captureEdge} {0}
set_instance_parameter_value tx_rst_pll_pio {direction} {Output}
set_instance_parameter_value tx_rst_pll_pio {edgeType} {RISING}
set_instance_parameter_value tx_rst_pll_pio {generateIRQ} {0}
set_instance_parameter_value tx_rst_pll_pio {irqType} {LEVEL}
set_instance_parameter_value tx_rst_pll_pio {resetValue} {0.0}
set_instance_parameter_value tx_rst_pll_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value tx_rst_pll_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_rst_pll_pio {width} {1}

add_instance tx_rst_xcvr_pio altera_avalon_pio
set_instance_parameter_value tx_rst_xcvr_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value tx_rst_xcvr_pio {bitModifyingOutReg} {0}
set_instance_parameter_value tx_rst_xcvr_pio {captureEdge} {0}
set_instance_parameter_value tx_rst_xcvr_pio {direction} {Output}
set_instance_parameter_value tx_rst_xcvr_pio {edgeType} {RISING}
set_instance_parameter_value tx_rst_xcvr_pio {generateIRQ} {0}
set_instance_parameter_value tx_rst_xcvr_pio {irqType} {LEVEL}
set_instance_parameter_value tx_rst_xcvr_pio {resetValue} {0.0}
set_instance_parameter_value tx_rst_xcvr_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value tx_rst_xcvr_pio {simDrivenValue} {0.0}
set_instance_parameter_value tx_rst_xcvr_pio {width} {1}

add_instance wd_timer altera_avalon_timer
set_instance_parameter_value wd_timer {alwaysRun} {0}
set_instance_parameter_value wd_timer {counterSize} {32}
set_instance_parameter_value wd_timer {fixedPeriod} {1}
set_instance_parameter_value wd_timer {period} {600}
set_instance_parameter_value wd_timer {periodUnits} {MSEC}
set_instance_parameter_value wd_timer {resetOutput} {1}
set_instance_parameter_value wd_timer {snapshot} {0}
set_instance_parameter_value wd_timer {timeoutPulseOutput} {0}
set_instance_parameter_value wd_timer {watchdogPulse} {2}

# exported interfaces
add_interface color_depth_pio_external_connection conduit end
set_interface_property color_depth_pio_external_connection EXPORT_OF color_depth_pio.external_connection
add_interface cpu clock sink
set_interface_property cpu EXPORT_OF cpu_clk.clk_in
add_interface cpu_clk reset sink
set_interface_property cpu_clk EXPORT_OF cpu_clk.clk_in_reset
add_interface measure_pio_external_connection conduit end
set_interface_property measure_pio_external_connection EXPORT_OF measure_pio.external_connection
add_interface measure_valid_pio_external_connection conduit end
set_interface_property measure_valid_pio_external_connection EXPORT_OF measure_valid_pio.external_connection
add_interface oc_i2c_master_av_slave_translator_avalon_anti_slave_0 avalon master
set_interface_property oc_i2c_master_av_slave_translator_avalon_anti_slave_0 EXPORT_OF oc_i2c_master_av_slave_translator.avalon_anti_slave_0
add_interface oc_i2c_master_ti_avalon_anti_slave avalon master
set_interface_property oc_i2c_master_ti_avalon_anti_slave EXPORT_OF oc_i2c_master_ti.avalon_anti_slave_0
add_interface tmds_bit_clock_ratio_pio_external_connection conduit end
set_interface_property tmds_bit_clock_ratio_pio_external_connection EXPORT_OF tmds_bit_clock_ratio_pio.external_connection
add_interface tx_hpd_ack_pio_external_connection conduit end
set_interface_property tx_hpd_ack_pio_external_connection EXPORT_OF tx_hpd_ack_pio.external_connection
add_interface tx_hpd_req_pio_external_connection conduit end
set_interface_property tx_hpd_req_pio_external_connection EXPORT_OF tx_hpd_req_pio.external_connection
add_interface tx_iopll_rcfg_mgmt_translator_avalon_anti_slave avalon master
set_interface_property tx_iopll_rcfg_mgmt_translator_avalon_anti_slave EXPORT_OF tx_iopll_rcfg_mgmt_translator.avalon_anti_slave_0
add_interface tx_iopll_waitrequest_pio_external_connection conduit end
set_interface_property tx_iopll_waitrequest_pio_external_connection EXPORT_OF tx_iopll_waitrequest_pio.external_connection
add_interface tx_os_pio_external_connection conduit end
set_interface_property tx_os_pio_external_connection EXPORT_OF tx_os_pio.external_connection
add_interface tx_pll_rcfg_mgmt_translator_avalon_anti_slave avalon master
set_interface_property tx_pll_rcfg_mgmt_translator_avalon_anti_slave EXPORT_OF tx_pll_rcfg_mgmt_translator.avalon_anti_slave_0
add_interface tx_pll_waitrequest_pio_external_connection conduit end
set_interface_property tx_pll_waitrequest_pio_external_connection EXPORT_OF tx_pll_waitrequest_pio.external_connection
add_interface tx_pma_ch conduit end
set_interface_property tx_pma_ch EXPORT_OF tx_pma_ch.external_connection
add_interface tx_pma_cal_busy_pio_external_connection conduit end
set_interface_property tx_pma_cal_busy_pio_external_connection EXPORT_OF tx_pma_cal_busy_pio.external_connection
add_interface tx_rcfg_en_pio_external_connection conduit end
set_interface_property tx_rcfg_en_pio_external_connection EXPORT_OF tx_rcfg_en_pio.external_connection
add_interface tx_pma_rcfg_mgmt_translator_avalon_anti_slave avalon master
set_interface_property tx_pma_rcfg_mgmt_translator_avalon_anti_slave EXPORT_OF tx_pma_rcfg_mgmt_translator.avalon_anti_slave_0
add_interface tx_pma_waitrequest_pio_external_connection conduit end
set_interface_property tx_pma_waitrequest_pio_external_connection EXPORT_OF tx_pma_waitrequest_pio.external_connection
add_interface tx_rst_pll_pio_external_connection conduit end
set_interface_property tx_rst_pll_pio_external_connection EXPORT_OF tx_rst_pll_pio.external_connection
add_interface tx_rst_xcvr_pio_external_connection conduit end
set_interface_property tx_rst_xcvr_pio_external_connection EXPORT_OF tx_rst_xcvr_pio.external_connection
add_interface wd_timer_resetrequest reset source
set_interface_property wd_timer_resetrequest EXPORT_OF wd_timer.resetrequest
add_interface edid_ram_access_pio_external_connection conduit end
set_interface_property edid_ram_access_pio_external_connection EXPORT_OF edid_ram_access_pio.external_connection
add_interface edid_ram_slave_translator avalon master
set_interface_property edid_ram_slave_translator EXPORT_OF edid_ram_slave_translator.avalon_anti_slave_0

# connections and connection parameters
add_connection cpu.data_master jtag_uart_0.avalon_jtag_slave
set_connection_parameter_value cpu.data_master/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/jtag_uart_0.avalon_jtag_slave baseAddress {0x000428f8}
set_connection_parameter_value cpu.data_master/jtag_uart_0.avalon_jtag_slave defaultConnection {0}

add_connection cpu.data_master tx_iopll_rcfg_mgmt_translator.avalon_universal_slave_0
set_connection_parameter_value cpu.data_master/tx_iopll_rcfg_mgmt_translator.avalon_universal_slave_0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_iopll_rcfg_mgmt_translator.avalon_universal_slave_0 baseAddress {0x00042000}
set_connection_parameter_value cpu.data_master/tx_iopll_rcfg_mgmt_translator.avalon_universal_slave_0 defaultConnection {0}

add_connection cpu.data_master tx_pll_rcfg_mgmt_translator.avalon_universal_slave_0
set_connection_parameter_value cpu.data_master/tx_pll_rcfg_mgmt_translator.avalon_universal_slave_0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_pll_rcfg_mgmt_translator.avalon_universal_slave_0 baseAddress {0x00040000}
set_connection_parameter_value cpu.data_master/tx_pll_rcfg_mgmt_translator.avalon_universal_slave_0 defaultConnection {0}

add_connection cpu.data_master tx_pma_rcfg_mgmt_translator.avalon_universal_slave_0
set_connection_parameter_value cpu.data_master/tx_pma_rcfg_mgmt_translator.avalon_universal_slave_0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_pma_rcfg_mgmt_translator.avalon_universal_slave_0 baseAddress {0x00000000}
set_connection_parameter_value cpu.data_master/tx_pma_rcfg_mgmt_translator.avalon_universal_slave_0 defaultConnection {0}

add_connection cpu.data_master edid_ram_slave_translator.avalon_universal_slave_0
set_connection_parameter_value cpu.data_master/edid_ram_slave_translator.avalon_universal_slave_0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/edid_ram_slave_translator.avalon_universal_slave_0 baseAddress {0x00042c00}
set_connection_parameter_value cpu.data_master/edid_ram_slave_translator.avalon_universal_slave_0 defaultConnection {0}

add_connection cpu.data_master oc_i2c_master_av_slave_translator.avalon_universal_slave_0
set_connection_parameter_value cpu.data_master/oc_i2c_master_av_slave_translator.avalon_universal_slave_0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/oc_i2c_master_av_slave_translator.avalon_universal_slave_0 baseAddress {0x00042820}
set_connection_parameter_value cpu.data_master/oc_i2c_master_av_slave_translator.avalon_universal_slave_0 defaultConnection {0}

add_connection cpu.data_master oc_i2c_master_ti.avalon_universal_slave_0
set_connection_parameter_value cpu.data_master/oc_i2c_master_ti.avalon_universal_slave_0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/oc_i2c_master_ti.avalon_universal_slave_0 baseAddress {0x00043120}
set_connection_parameter_value cpu.data_master/oc_i2c_master_ti.avalon_universal_slave_0 defaultConnection {0}

add_connection cpu.data_master sysid_qsys_0.control_slave
set_connection_parameter_value cpu.data_master/sysid_qsys_0.control_slave arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/sysid_qsys_0.control_slave baseAddress {0x000428f0}
set_connection_parameter_value cpu.data_master/sysid_qsys_0.control_slave defaultConnection {0}

add_connection cpu.data_master cpu.debug_mem_slave
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave baseAddress {0x00041800}
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave defaultConnection {0}

add_connection cpu.data_master cpu_ram.s1
set_connection_parameter_value cpu.data_master/cpu_ram.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/cpu_ram.s1 baseAddress {0x00020000}
set_connection_parameter_value cpu.data_master/cpu_ram.s1 defaultConnection {0}

add_connection cpu.data_master edid_ram_access_pio.s1
set_connection_parameter_value cpu.data_master/edid_ram_access_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/edid_ram_access_pio.s1 baseAddress {0x00043000}
set_connection_parameter_value cpu.data_master/edid_ram_access_pio.s1 defaultConnection {0}

add_connection cpu.data_master measure_pio.s1
set_connection_parameter_value cpu.data_master/measure_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/measure_pio.s1 baseAddress {0x000428e0}
set_connection_parameter_value cpu.data_master/measure_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_os_pio.s1
set_connection_parameter_value cpu.data_master/tx_os_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_os_pio.s1 baseAddress {0x000428d0}
set_connection_parameter_value cpu.data_master/tx_os_pio.s1 defaultConnection {0}

add_connection cpu.data_master measure_valid_pio.s1
set_connection_parameter_value cpu.data_master/measure_valid_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/measure_valid_pio.s1 baseAddress {0x000428c0}
set_connection_parameter_value cpu.data_master/measure_valid_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_rst_pll_pio.s1
set_connection_parameter_value cpu.data_master/tx_rst_pll_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_rst_pll_pio.s1 baseAddress {0x000428b0}
set_connection_parameter_value cpu.data_master/tx_rst_pll_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_rst_xcvr_pio.s1
set_connection_parameter_value cpu.data_master/tx_rst_xcvr_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_rst_xcvr_pio.s1 baseAddress {0x000428a0}
set_connection_parameter_value cpu.data_master/tx_rst_xcvr_pio.s1 defaultConnection {0}

add_connection cpu.data_master tmds_bit_clock_ratio_pio.s1
set_connection_parameter_value cpu.data_master/tmds_bit_clock_ratio_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tmds_bit_clock_ratio_pio.s1 baseAddress {0x00042890}
set_connection_parameter_value cpu.data_master/tmds_bit_clock_ratio_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_iopll_waitrequest_pio.s1
set_connection_parameter_value cpu.data_master/tx_iopll_waitrequest_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_iopll_waitrequest_pio.s1 baseAddress {0x00042880}
set_connection_parameter_value cpu.data_master/tx_iopll_waitrequest_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_pll_waitrequest_pio.s1
set_connection_parameter_value cpu.data_master/tx_pll_waitrequest_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_pll_waitrequest_pio.s1 baseAddress {0x00042870}
set_connection_parameter_value cpu.data_master/tx_pll_waitrequest_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_pma_ch.s1
set_connection_parameter_value cpu.data_master/tx_pma_ch.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_pma_ch.s1 baseAddress {0x00042930}
set_connection_parameter_value cpu.data_master/tx_pma_ch.s1 defaultConnection {0}

add_connection cpu.data_master tx_pma_cal_busy_pio.s1
set_connection_parameter_value cpu.data_master/tx_pma_cal_busy_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_pma_cal_busy_pio.s1 baseAddress {0x00042920}
set_connection_parameter_value cpu.data_master/tx_pma_cal_busy_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_rcfg_en_pio.s1
set_connection_parameter_value cpu.data_master/tx_rcfg_en_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_rcfg_en_pio.s1 baseAddress {0x00042900}
set_connection_parameter_value cpu.data_master/tx_rcfg_en_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_pma_waitrequest_pio.s1
set_connection_parameter_value cpu.data_master/tx_pma_waitrequest_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_pma_waitrequest_pio.s1 baseAddress {0x00042910}
set_connection_parameter_value cpu.data_master/tx_pma_waitrequest_pio.s1 defaultConnection {0}

add_connection cpu.data_master wd_timer.s1
set_connection_parameter_value cpu.data_master/wd_timer.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/wd_timer.s1 baseAddress {0x00042800}
set_connection_parameter_value cpu.data_master/wd_timer.s1 defaultConnection {0}

add_connection cpu.data_master tx_hpd_req_pio.s1
set_connection_parameter_value cpu.data_master/tx_hpd_req_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_hpd_req_pio.s1 baseAddress {0x00042860}
set_connection_parameter_value cpu.data_master/tx_hpd_req_pio.s1 defaultConnection {0}

add_connection cpu.data_master tx_hpd_ack_pio.s1
set_connection_parameter_value cpu.data_master/tx_hpd_ack_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/tx_hpd_ack_pio.s1 baseAddress {0x00042850}
set_connection_parameter_value cpu.data_master/tx_hpd_ack_pio.s1 defaultConnection {0}

add_connection cpu.data_master color_depth_pio.s1
set_connection_parameter_value cpu.data_master/color_depth_pio.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/color_depth_pio.s1 baseAddress {0x00042840}
set_connection_parameter_value cpu.data_master/color_depth_pio.s1 defaultConnection {0}

add_connection cpu.instruction_master cpu.debug_mem_slave
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave baseAddress {0x00041800}
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave defaultConnection {0}

add_connection cpu.instruction_master cpu_ram.s1
set_connection_parameter_value cpu.instruction_master/cpu_ram.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/cpu_ram.s1 baseAddress {0x00020000}
set_connection_parameter_value cpu.instruction_master/cpu_ram.s1 defaultConnection {0}

add_connection cpu_clk.clk cpu.clk

add_connection cpu_clk.clk jtag_uart_0.clk

add_connection cpu_clk.clk sysid_qsys_0.clk

add_connection cpu_clk.clk measure_valid_pio.clk

add_connection cpu_clk.clk measure_pio.clk

add_connection cpu_clk.clk tx_os_pio.clk

add_connection cpu_clk.clk tx_rst_xcvr_pio.clk

add_connection cpu_clk.clk tx_rst_pll_pio.clk

add_connection cpu_clk.clk tmds_bit_clock_ratio_pio.clk

add_connection cpu_clk.clk tx_iopll_waitrequest_pio.clk

add_connection cpu_clk.clk tx_pll_waitrequest_pio.clk

add_connection cpu_clk.clk tx_pma_ch.clk

add_connection cpu_clk.clk tx_pma_cal_busy_pio.clk

add_connection cpu_clk.clk tx_rcfg_en_pio.clk

add_connection cpu_clk.clk tx_pma_waitrequest_pio.clk

add_connection cpu_clk.clk tx_pll_rcfg_mgmt_translator.clk

add_connection cpu_clk.clk tx_pma_rcfg_mgmt_translator.clk

add_connection cpu_clk.clk tx_iopll_rcfg_mgmt_translator.clk

add_connection cpu_clk.clk edid_ram_slave_translator.clk

add_connection cpu_clk.clk edid_ram_access_pio.clk

add_connection cpu_clk.clk wd_timer.clk

add_connection cpu_clk.clk tx_hpd_req_pio.clk

add_connection cpu_clk.clk tx_hpd_ack_pio.clk

add_connection cpu_clk.clk color_depth_pio.clk

add_connection cpu_clk.clk oc_i2c_master_av_slave_translator.clk

add_connection cpu_clk.clk oc_i2c_master_ti.clk

add_connection cpu_clk.clk cpu_ram.clk1

add_connection cpu.irq jtag_uart_0.irq
set_connection_parameter_value cpu.irq/jtag_uart_0.irq irqNumber {0}

add_connection cpu.irq tmds_bit_clock_ratio_pio.irq
set_connection_parameter_value cpu.irq/tmds_bit_clock_ratio_pio.irq irqNumber {2}

add_connection cpu.irq tx_iopll_waitrequest_pio.irq
set_connection_parameter_value cpu.irq/tx_iopll_waitrequest_pio.irq irqNumber {3}

add_connection cpu.irq tx_pll_waitrequest_pio.irq
set_connection_parameter_value cpu.irq/tx_pll_waitrequest_pio.irq irqNumber {4}

add_connection cpu.irq measure_valid_pio.irq
set_connection_parameter_value cpu.irq/measure_valid_pio.irq irqNumber {5}

add_connection cpu.irq measure_pio.irq
set_connection_parameter_value cpu.irq/measure_pio.irq irqNumber {6}

add_connection cpu.irq wd_timer.irq
set_connection_parameter_value cpu.irq/wd_timer.irq irqNumber {1}

add_connection cpu.irq tx_hpd_req_pio.irq
set_connection_parameter_value cpu.irq/tx_hpd_req_pio.irq irqNumber {8}

add_connection cpu.irq color_depth_pio.irq
set_connection_parameter_value cpu.irq/color_depth_pio.irq irqNumber {9}

add_connection cpu.irq tx_pma_waitrequest_pio.irq
set_connection_parameter_value cpu.irq/tx_pma_waitrequest_pio.irq irqNumber {10}

#add_connection cpu.irq tx_pma_ch.irq
#set_connection_parameter_value cpu.irq/tx_pma_ch.irq irqNumber {11}

add_connection cpu.irq tx_pma_cal_busy_pio.irq
set_connection_parameter_value cpu.irq/tx_pma_cal_busy_pio.irq irqNumber {12}

#add_connection cpu.irq tx_rcfg_en_pio.irq
#set_connection_parameter_value cpu.irq/tx_rcfg_en_pio.irq irqNumber {13}

add_connection cpu_clk.clk_reset jtag_uart_0.reset

add_connection cpu_clk.clk_reset sysid_qsys_0.reset

add_connection cpu_clk.clk_reset cpu.reset

add_connection cpu_clk.clk_reset tmds_bit_clock_ratio_pio.reset

add_connection cpu_clk.clk_reset measure_pio.reset

add_connection cpu_clk.clk_reset measure_valid_pio.reset

add_connection cpu_clk.clk_reset tx_iopll_waitrequest_pio.reset

add_connection cpu_clk.clk_reset tx_pll_waitrequest_pio.reset

add_connection cpu_clk.clk_reset tx_pma_ch.reset

add_connection cpu_clk.clk_reset tx_pma_cal_busy_pio.reset

add_connection cpu_clk.clk_reset tx_rcfg_en_pio.reset

add_connection cpu_clk.clk_reset tx_pma_waitrequest_pio.reset

add_connection cpu_clk.clk_reset tx_rst_xcvr_pio.reset

add_connection cpu_clk.clk_reset tx_rst_pll_pio.reset

add_connection cpu_clk.clk_reset tx_os_pio.reset

add_connection cpu_clk.clk_reset tx_iopll_rcfg_mgmt_translator.reset

add_connection cpu_clk.clk_reset tx_pll_rcfg_mgmt_translator.reset

add_connection cpu_clk.clk_reset tx_pma_rcfg_mgmt_translator.reset

add_connection cpu_clk.clk_reset edid_ram_slave_translator.reset

add_connection cpu_clk.clk_reset edid_ram_access_pio.reset

add_connection cpu_clk.clk_reset wd_timer.reset

add_connection cpu_clk.clk_reset tx_hpd_req_pio.reset

add_connection cpu_clk.clk_reset tx_hpd_ack_pio.reset

add_connection cpu_clk.clk_reset color_depth_pio.reset

add_connection cpu_clk.clk_reset oc_i2c_master_av_slave_translator.reset

add_connection cpu_clk.clk_reset oc_i2c_master_ti.reset

add_connection cpu_clk.clk_reset cpu_ram.reset1

add_connection cpu.debug_reset_request cpu.reset

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {false}

save_system {nios.qsys}
