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


package provide altera_emif::ip_soft_nios::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_soft_nios::main:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}

proc ::altera_emif::ip_soft_nios::main::create_parameters {} {

   add_user_param SOFT_NIOS_MODE             string   "SOFT_NIOS_MODE_DISABLED" [enum_dropdown_entries SOFT_NIOS_MODE] ""
   add_user_param SOFT_NIOS_CLOCK_FREQUENCY  integer  100      ""                                    Megahertz
   add_user_param ENABLE_RS232_UART          boolean  true     ""                                    ""
   add_user_param RS232_UART_BAUDRATE        integer  57600    [list 9600 19200 38400 57600 115200]  BitsPerSecond
   add_user_param ENABLE_JTAG_UART           boolean  true     ""                                    ""
   add_user_param ENABLE_EXPORT_SLAVE        boolean  true     ""                                    ""

}

proc ::altera_emif::ip_soft_nios::main::composition_callback {} {

   set clk_freq            [get_parameter_value SOFT_NIOS_CLOCK_FREQUENCY]
   set enable_rs232_uart   [get_parameter_value ENABLE_RS232_UART]
   set rs232_bps           [get_parameter_value RS232_UART_BAUDRATE]
   set enable_jtag_uart    [get_parameter_value ENABLE_JTAG_UART]
   set enable_export_slave [get_parameter_value ENABLE_EXPORT_SLAVE]
   set clk_freq_hz         [expr {double($clk_freq * 1000000)}]
   set on_chip_debug_mode  [expr {[get_parameter_value SOFT_NIOS_MODE] == "SOFT_NIOS_MODE_ON_CHIP_DEBUG"}]
   set calibration_mode    [expr {[get_parameter_value SOFT_NIOS_MODE] == "SOFT_NIOS_MODE_CALIBRATION"}]

   emif_assert {$on_chip_debug_mode || $calibration_mode}

   add_instance dbg_clk_bridge altera_clock_bridge

   set_instance_parameter_value dbg_clk_bridge {EXPLICIT_CLOCK_RATE} $clk_freq_hz
   set_instance_parameter_value dbg_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

   add_instance dbg_rst_bridge altera_reset_bridge
   set_instance_parameter_value dbg_rst_bridge {SYNCHRONOUS_EDGES} {deassert}
   set_instance_parameter_value dbg_rst_bridge {NUM_RESET_OUTPUTS} {1}

   add_instance dbg_avl_bridge altera_avalon_mm_bridge
   set_instance_parameter_value dbg_avl_bridge {DATA_WIDTH} {32}
   set_instance_parameter_value dbg_avl_bridge {SYMBOL_WIDTH} {8}
   set_instance_parameter_value dbg_avl_bridge {ADDRESS_WIDTH} {24}
   set_instance_parameter_value dbg_avl_bridge {ADDRESS_UNITS} {SYMBOLS}



   set reset_exception_slave "Absolute"
   set ioaux_avalon_base  0x00000000
   set debug_module_base  0x01000000
   set c_code_memory_base 0x00000000

   if {$on_chip_debug_mode} {
      set init_hexfile [file join [pwd] "soft_nios_onchip_memory.hex"]
      set onchip_memory "onchip_memory"
      add_instance $onchip_memory altera_avalon_onchip_memory2
      set_instance_parameter_value $onchip_memory {allowInSystemMemoryContentEditor} {0}
      set_instance_parameter_value $onchip_memory {blockType} {AUTO}
      set_instance_parameter_value $onchip_memory {dataWidth} {32}
      set_instance_parameter_value $onchip_memory {dualPort} {0}
      set_instance_parameter_value $onchip_memory {initMemContent} {1}
      set_instance_parameter_value $onchip_memory {initializationFileName} $init_hexfile
      set_instance_parameter_value $onchip_memory {instanceID} {NONE}
      set_instance_parameter_value $onchip_memory {memorySize} {32768.0}
      set_instance_parameter_value $onchip_memory {readDuringWriteMode} {DONT_CARE}
      set_instance_parameter_value $onchip_memory {simAllowMRAMContentsFile} {0}
      set_instance_parameter_value $onchip_memory {simMemInitOnlyFilename} {0}
      set_instance_parameter_value $onchip_memory {singleClockOperation} {0}
      set_instance_parameter_value $onchip_memory {slave1Latency} {1}
      set_instance_parameter_value $onchip_memory {slave2Latency} {1}
      set_instance_parameter_value $onchip_memory {useNonDefaultInitFile} {1}
      set_instance_parameter_value $onchip_memory {copyInitFile} {1}
      set_instance_parameter_value $onchip_memory {useShallowMemBlocks} {0}
      set_instance_parameter_value $onchip_memory {writable} {1}
      set_instance_parameter_value $onchip_memory {ecc_enabled} {0}
      set_instance_parameter_value $onchip_memory {resetrequest_enabled} {1}

      set reset_exception_slave "${onchip_memory}.s1"
      set c_code_memory_base 0x01000000
      set debug_module_base  0x01008000
   }

   add_instance dbg_nios altera_nios2_gen2
   set_instance_parameter_value dbg_nios {tmr_enabled} {0}
   set_instance_parameter_value dbg_nios {setting_disable_tmr_inj} {0}
   set_instance_parameter_value dbg_nios {setting_showUnpublishedSettings} {0}
   set_instance_parameter_value dbg_nios {setting_showInternalSettings} {0}
   set_instance_parameter_value dbg_nios {setting_preciseIllegalMemAccessException} {0}
   set_instance_parameter_value dbg_nios {setting_exportPCB} {0}
   set_instance_parameter_value dbg_nios {setting_exportdebuginfo} {0}
   set_instance_parameter_value dbg_nios {setting_clearXBitsLDNonBypass} {1}
   set_instance_parameter_value dbg_nios {setting_bigEndian} {0}
   set_instance_parameter_value dbg_nios {setting_export_large_RAMs} {0}
   set_instance_parameter_value dbg_nios {setting_asic_enabled} {0}
   set_instance_parameter_value dbg_nios {register_file_por} {0}
   set_instance_parameter_value dbg_nios {setting_asic_synopsys_translate_on_off} {0}
   set_instance_parameter_value dbg_nios {setting_asic_third_party_synthesis} {0}
   set_instance_parameter_value dbg_nios {setting_asic_add_scan_mode_input} {0}
   set_instance_parameter_value dbg_nios {setting_oci_version} {1}
   set_instance_parameter_value dbg_nios {setting_fast_register_read} {0}
   set_instance_parameter_value dbg_nios {setting_exportHostDebugPort} {0}
   set_instance_parameter_value dbg_nios {setting_oci_export_jtag_signals} {0}
   set_instance_parameter_value dbg_nios {setting_avalonDebugPortPresent} {0}
   set_instance_parameter_value dbg_nios {setting_alwaysEncrypt} {1}
   set_instance_parameter_value dbg_nios {io_regionbase} {0}
   set_instance_parameter_value dbg_nios {io_regionsize} {0}
   set_instance_parameter_value dbg_nios {setting_support31bitdcachebypass} {1}
   set_instance_parameter_value dbg_nios {setting_activateTrace} {0}
   set_instance_parameter_value dbg_nios {setting_allow_break_inst} {0}
   set_instance_parameter_value dbg_nios {setting_activateTestEndChecker} {0}
   set_instance_parameter_value dbg_nios {setting_ecc_sim_test_ports} {0}
   set_instance_parameter_value dbg_nios {setting_disableocitrace} {0}
   set_instance_parameter_value dbg_nios {setting_activateMonitors} {1}
   set_instance_parameter_value dbg_nios {setting_HDLSimCachesCleared} {1}
   set_instance_parameter_value dbg_nios {setting_HBreakTest} {0}
   set_instance_parameter_value dbg_nios {setting_breakslaveoveride} {0}
   set_instance_parameter_value dbg_nios {mpu_useLimit} {0}
   set_instance_parameter_value dbg_nios {mpu_enabled} {0}
   set_instance_parameter_value dbg_nios {mmu_enabled} {0}
   set_instance_parameter_value dbg_nios {mmu_autoAssignTlbPtrSz} {1}
   set_instance_parameter_value dbg_nios {cpuReset} {0}
   set_instance_parameter_value dbg_nios {resetrequest_enabled} {1}
   set_instance_parameter_value dbg_nios {setting_removeRAMinit} {0}
   set_instance_parameter_value dbg_nios {setting_tmr_output_disable} {0}
   set_instance_parameter_value dbg_nios {setting_shadowRegisterSets} {0}
   set_instance_parameter_value dbg_nios {mpu_numOfInstRegion} {8}
   set_instance_parameter_value dbg_nios {mpu_numOfDataRegion} {8}
   set_instance_parameter_value dbg_nios {mmu_TLBMissExcOffset} {0}
   set_instance_parameter_value dbg_nios {resetOffset} {0}
   set_instance_parameter_value dbg_nios {exceptionOffset} {32}
   set_instance_parameter_value dbg_nios {cpuID} {0}
   set_instance_parameter_value dbg_nios {breakOffset} {32}
   set_instance_parameter_value dbg_nios {userDefinedSettings} {}
   set_instance_parameter_value dbg_nios {tracefilename} {}
   set_instance_parameter_value dbg_nios {resetSlave} $reset_exception_slave
   set_instance_parameter_value dbg_nios {mmu_TLBMissExcSlave} {None}
   set_instance_parameter_value dbg_nios {exceptionSlave} $reset_exception_slave
   set_instance_parameter_value dbg_nios {breakSlave} {dbg_nios.jtag_debug_module}
   set_instance_parameter_value dbg_nios {setting_interruptControllerType} {Internal}
   set_instance_parameter_value dbg_nios {setting_branchpredictiontype} {Dynamic}
   set_instance_parameter_value dbg_nios {setting_bhtPtrSz} {8}
   set_instance_parameter_value dbg_nios {cpuArchRev} {1}
   set_instance_parameter_value dbg_nios {mul_shift_choice} {0}
   set_instance_parameter_value dbg_nios {mul_32_impl} {2}
   set_instance_parameter_value dbg_nios {mul_64_impl} {0}
   set_instance_parameter_value dbg_nios {shift_rot_impl} {1}
   set_instance_parameter_value dbg_nios {dividerType} {no_div}
   set_instance_parameter_value dbg_nios {mpu_minInstRegionSize} {12}
   set_instance_parameter_value dbg_nios {mpu_minDataRegionSize} {12}
   set_instance_parameter_value dbg_nios {mmu_uitlbNumEntries} {4}
   set_instance_parameter_value dbg_nios {mmu_udtlbNumEntries} {6}
   set_instance_parameter_value dbg_nios {mmu_tlbPtrSz} {7}
   set_instance_parameter_value dbg_nios {mmu_tlbNumWays} {16}
   set_instance_parameter_value dbg_nios {mmu_processIDNumBits} {8}
   set_instance_parameter_value dbg_nios {impl} {Fast}
   set_instance_parameter_value dbg_nios {icache_size} {2048}
   set_instance_parameter_value dbg_nios {fa_cache_line} {2}
   set_instance_parameter_value dbg_nios {fa_cache_linesize} {0}
   set_instance_parameter_value dbg_nios {icache_tagramBlockType} {Automatic}
   set_instance_parameter_value dbg_nios {icache_ramBlockType} {Automatic}
   set_instance_parameter_value dbg_nios {icache_numTCIM} {0}
   set_instance_parameter_value dbg_nios {icache_burstType} {None}
   set_instance_parameter_value dbg_nios {dcache_bursts} {false}
   set_instance_parameter_value dbg_nios {dcache_victim_buf_impl} {ram}
   set_instance_parameter_value dbg_nios {dcache_size} {2048}
   set_instance_parameter_value dbg_nios {dcache_tagramBlockType} {Automatic}
   set_instance_parameter_value dbg_nios {dcache_ramBlockType} {Automatic}
   set_instance_parameter_value dbg_nios {dcache_numTCDM} {0}
   set_instance_parameter_value dbg_nios {setting_exportvectors} {0}
   set_instance_parameter_value dbg_nios {setting_usedesignware} {0}
   set_instance_parameter_value dbg_nios {setting_ecc_present} {0}
   set_instance_parameter_value dbg_nios {setting_ic_ecc_present} {1}
   set_instance_parameter_value dbg_nios {setting_rf_ecc_present} {1}
   set_instance_parameter_value dbg_nios {setting_mmu_ecc_present} {1}
   set_instance_parameter_value dbg_nios {setting_dc_ecc_present} {1}
   set_instance_parameter_value dbg_nios {setting_itcm_ecc_present} {1}
   set_instance_parameter_value dbg_nios {setting_dtcm_ecc_present} {1}
   set_instance_parameter_value dbg_nios {regfile_ramBlockType} {Automatic}
   set_instance_parameter_value dbg_nios {ocimem_ramBlockType} {Automatic}
   set_instance_parameter_value dbg_nios {ocimem_ramInit} {0}
   set_instance_parameter_value dbg_nios {mmu_ramBlockType} {Automatic}
   set_instance_parameter_value dbg_nios {bht_ramBlockType} {Automatic}
   set_instance_parameter_value dbg_nios {cdx_enabled} {0}
   set_instance_parameter_value dbg_nios {mpx_enabled} {0}
   set_instance_parameter_value dbg_nios {debug_enabled} {1}
   set_instance_parameter_value dbg_nios {debug_triggerArming} {1}
   set_instance_parameter_value dbg_nios {debug_debugReqSignals} {0}
   set_instance_parameter_value dbg_nios {debug_assignJtagInstanceID} {0}
   set_instance_parameter_value dbg_nios {debug_jtagInstanceID} {0}
   set_instance_parameter_value dbg_nios {debug_OCIOnchipTrace} {_128}
   set_instance_parameter_value dbg_nios {debug_hwbreakpoint} {0}
   set_instance_parameter_value dbg_nios {debug_datatrigger} {0}
   set_instance_parameter_value dbg_nios {debug_traceType} {none}
   set_instance_parameter_value dbg_nios {debug_traceStorage} {onchip_trace}
   set_instance_parameter_value dbg_nios {master_addr_map} {0}
   set_instance_parameter_value dbg_nios {instruction_master_paddr_base} {0}
   set_instance_parameter_value dbg_nios {instruction_master_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {flash_instruction_master_paddr_base} {0}
   set_instance_parameter_value dbg_nios {flash_instruction_master_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {data_master_paddr_base} {0}
   set_instance_parameter_value dbg_nios {data_master_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {tightly_coupled_instruction_master_0_paddr_base} {0}
   set_instance_parameter_value dbg_nios {tightly_coupled_instruction_master_0_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {tightly_coupled_instruction_master_1_paddr_base} {0}
   set_instance_parameter_value dbg_nios {tightly_coupled_instruction_master_1_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {tightly_coupled_instruction_master_2_paddr_base} {0}
   set_instance_parameter_value dbg_nios {tightly_coupled_instruction_master_2_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {tightly_coupled_instruction_master_3_paddr_base} {0}
   set_instance_parameter_value dbg_nios {tightly_coupled_instruction_master_3_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {tightly_coupled_data_master_0_paddr_base} {0}
   set_instance_parameter_value dbg_nios {tightly_coupled_data_master_0_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {tightly_coupled_data_master_1_paddr_base} {0}
   set_instance_parameter_value dbg_nios {tightly_coupled_data_master_1_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {tightly_coupled_data_master_2_paddr_base} {0}
   set_instance_parameter_value dbg_nios {tightly_coupled_data_master_2_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {tightly_coupled_data_master_3_paddr_base} {0}
   set_instance_parameter_value dbg_nios {tightly_coupled_data_master_3_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {instruction_master_high_performance_paddr_base} {0}
   set_instance_parameter_value dbg_nios {instruction_master_high_performance_paddr_size} {0.0}
   set_instance_parameter_value dbg_nios {data_master_high_performance_paddr_base} {0}
   set_instance_parameter_value dbg_nios {data_master_high_performance_paddr_size} {0.0}

   add_interface dbg_clk clock sink
   add_interface dbg_rst reset sink
   add_interface dbg_to_ioaux avalon master

   set_interface_property dbg_clk export_of dbg_clk_bridge.in_clk
   set_interface_property dbg_rst export_of dbg_rst_bridge.in_reset

   add_connection dbg_clk_bridge.out_clk dbg_rst_bridge.clk clock

   add_connection dbg_clk_bridge.out_clk dbg_nios.clk clock
   add_connection dbg_rst_bridge.out_reset dbg_nios.reset reset

   add_connection dbg_nios.instruction_master dbg_nios.debug_mem_slave avalon
   set_connection_parameter_value dbg_nios.instruction_master/dbg_nios.debug_mem_slave arbitrationPriority {1}
   set_connection_parameter_value dbg_nios.instruction_master/dbg_nios.debug_mem_slave baseAddress $debug_module_base
   set_connection_parameter_value dbg_nios.instruction_master/dbg_nios.debug_mem_slave defaultConnection {0}

   add_connection dbg_nios.data_master dbg_nios.debug_mem_slave avalon
   set_connection_parameter_value dbg_nios.data_master/dbg_nios.debug_mem_slave arbitrationPriority {1}
   set_connection_parameter_value dbg_nios.data_master/dbg_nios.debug_mem_slave baseAddress $debug_module_base
   set_connection_parameter_value dbg_nios.data_master/dbg_nios.debug_mem_slave defaultConnection {0}

   add_connection dbg_clk_bridge.out_clk dbg_avl_bridge.clk clock
   add_connection dbg_rst_bridge.out_reset dbg_avl_bridge.reset reset

   add_connection dbg_nios.instruction_master dbg_avl_bridge.s0 avalon
   set_connection_parameter_value dbg_nios.instruction_master/dbg_avl_bridge.s0 arbitrationPriority {1}
   set_connection_parameter_value dbg_nios.instruction_master/dbg_avl_bridge.s0 baseAddress $ioaux_avalon_base
   set_connection_parameter_value dbg_nios.instruction_master/dbg_avl_bridge.s0 defaultConnection {0}

   add_connection dbg_nios.data_master dbg_avl_bridge.s0 avalon
   set_connection_parameter_value dbg_nios.data_master/dbg_avl_bridge.s0 arbitrationPriority {1}
   set_connection_parameter_value dbg_nios.data_master/dbg_avl_bridge.s0 baseAddress $ioaux_avalon_base
   set_connection_parameter_value dbg_nios.data_master/dbg_avl_bridge.s0 defaultConnection {0}

   set_interface_property dbg_to_ioaux EXPORT_OF dbg_avl_bridge.m0

   if {$on_chip_debug_mode} {
      add_connection dbg_nios.instruction_master onchip_memory.s1 avalon
      set_connection_parameter_value dbg_nios.instruction_master/onchip_memory.s1 arbitrationPriority {1}
      set_connection_parameter_value dbg_nios.instruction_master/onchip_memory.s1 baseAddress $c_code_memory_base
      set_connection_parameter_value dbg_nios.instruction_master/onchip_memory.s1 defaultConnection {0}

      add_connection dbg_nios.data_master onchip_memory.s1 avalon
      set_connection_parameter_value dbg_nios.data_master/onchip_memory.s1 arbitrationPriority {1}
      set_connection_parameter_value dbg_nios.data_master/onchip_memory.s1 baseAddress $c_code_memory_base
      set_connection_parameter_value dbg_nios.data_master/onchip_memory.s1 defaultConnection {0}

      add_connection dbg_clk_bridge.out_clk onchip_memory.clk1 clock
      add_connection dbg_rst_bridge.out_reset onchip_memory.reset1 reset
   }

   if {$enable_jtag_uart} {
      add_instance dbg_jtag_uart altera_avalon_jtag_uart
      set_instance_parameter_value dbg_jtag_uart {allowMultipleConnections} {0}
      set_instance_parameter_value dbg_jtag_uart {hubInstanceID} {0}
      set_instance_parameter_value dbg_jtag_uart {readBufferDepth} {64}
      set_instance_parameter_value dbg_jtag_uart {readIRQThreshold} {8}
      set_instance_parameter_value dbg_jtag_uart {simInputCharacterStream} {}
      set_instance_parameter_value dbg_jtag_uart {simInteractiveOptions} {NO_INTERACTIVE_WINDOWS}
      set_instance_parameter_value dbg_jtag_uart {useRegistersForReadBuffer} {0}
      set_instance_parameter_value dbg_jtag_uart {useRegistersForWriteBuffer} {0}
      set_instance_parameter_value dbg_jtag_uart {useRelativePathForSimFile} {0}
      set_instance_parameter_value dbg_jtag_uart {writeBufferDepth} {64}
      set_instance_parameter_value dbg_jtag_uart {writeIRQThreshold} {8}

      add_connection dbg_clk_bridge.out_clk dbg_jtag_uart.clk clock
      add_connection dbg_rst_bridge.out_reset dbg_jtag_uart.reset reset

      add_connection dbg_nios.irq dbg_jtag_uart.irq interrupt
      set_connection_parameter_value dbg_nios.irq/dbg_jtag_uart.irq irqNumber {0}

      add_connection dbg_nios.data_master dbg_jtag_uart.avalon_jtag_slave avalon
      set_connection_parameter_value dbg_nios.data_master/dbg_jtag_uart.avalon_jtag_slave arbitrationPriority {1}
      set_connection_parameter_value dbg_nios.data_master/dbg_jtag_uart.avalon_jtag_slave baseAddress {0x60000000}
      set_connection_parameter_value dbg_nios.data_master/dbg_jtag_uart.avalon_jtag_slave defaultConnection {0}
   }

   if {$enable_rs232_uart} {
      add_instance dbg_uart altera_avalon_uart
      set_instance_parameter_value dbg_uart {baud} $rs232_bps
      set_instance_parameter_value dbg_uart {dataBits} {8}
      set_instance_parameter_value dbg_uart {fixedBaud} {1}
      set_instance_parameter_value dbg_uart {parity} {NONE}
      set_instance_parameter_value dbg_uart {simCharStream} {}
      set_instance_parameter_value dbg_uart {simInteractiveInputEnable} {0}
      set_instance_parameter_value dbg_uart {simInteractiveOutputEnable} {0}
      set_instance_parameter_value dbg_uart {simTrueBaud} {0}
      set_instance_parameter_value dbg_uart {stopBits} {1}
      set_instance_parameter_value dbg_uart {syncRegDepth} {2}
      set_instance_parameter_value dbg_uart {useCtsRts} {0}
      set_instance_parameter_value dbg_uart {useEopRegister} {0}
      set_instance_parameter_value dbg_uart {useRelativePathForSimFile} {0}

      add_connection dbg_clk_bridge.out_clk dbg_uart.clk clock
      add_connection dbg_rst_bridge.out_reset dbg_uart.reset reset

      add_connection dbg_nios.data_master dbg_uart.s1 avalon
      set_connection_parameter_value dbg_nios.data_master/dbg_uart.s1 arbitrationPriority {1}
      set_connection_parameter_value dbg_nios.data_master/dbg_uart.s1 baseAddress {0x58000000}
      set_connection_parameter_value dbg_nios.data_master/dbg_uart.s1 defaultConnection {0}

      add_interface dbg_rs232 conduit end
      set_interface_property dbg_rs232 EXPORT_OF dbg_uart.external_connection
   }

   if {$enable_export_slave} {
      add_interface dbg_avl_slave avalon slave

      add_instance dbg_avl_export altera_avalon_mm_bridge
      set_instance_parameter_value dbg_avl_export {DATA_WIDTH} {32}
      set_instance_parameter_value dbg_avl_export {SYMBOL_WIDTH} {8}
      set_instance_parameter_value dbg_avl_export {ADDRESS_WIDTH} {24}
      set_instance_parameter_value dbg_avl_export {USE_AUTO_ADDRESS_WIDTH} {1}
      set_instance_parameter_value dbg_avl_export {ADDRESS_UNITS} {SYMBOLS}
      set_instance_parameter_value dbg_avl_export {MAX_BURST_SIZE} {1}
      set_instance_parameter_value dbg_avl_export {MAX_PENDING_RESPONSES} {4}
      set_instance_parameter_value dbg_avl_export {LINEWRAPBURSTS} {0}
      set_instance_parameter_value dbg_avl_export {PIPELINE_COMMAND} {1}
      set_instance_parameter_value dbg_avl_export {PIPELINE_RESPONSE} {1}

      add_connection dbg_avl_export.m0 dbg_avl_bridge.s0 avalon
      set_connection_parameter_value dbg_avl_export.m0/dbg_avl_bridge.s0 arbitrationPriority {1}
      set_connection_parameter_value dbg_avl_export.m0/dbg_avl_bridge.s0 baseAddress {0x0000}
      set_connection_parameter_value dbg_avl_export.m0/dbg_avl_bridge.s0 defaultConnection {0}

      add_connection dbg_clk_bridge.out_clk dbg_avl_export.clk clock
      add_connection dbg_rst_bridge.out_reset dbg_avl_export.reset reset

      set_interface_property dbg_avl_slave EXPORT_OF dbg_avl_export.s0
   }

   return 1
}



proc ::altera_emif::ip_soft_nios::main::_init {} {
}

::altera_emif::ip_soft_nios::main::_init

