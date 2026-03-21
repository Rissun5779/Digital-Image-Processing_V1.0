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


# $Id: //acds/rel/18.1std/ip/sld/mm/altera_mm_debug_link/altera_mm_debug_link_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# +-----------------------------------
# |
package require -exact sopc 11.0
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_mm_debug_link
# |
set_module_property NAME altera_mm_debug_link
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Verification/Debug & Performance"
set_module_property DISPLAY_NAME "Avalon-MM Debug Link"
set_module_property DESCRIPTION ""
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property COMPOSE_CALLBACK compose
set_module_property ANALYZE_HDL false
set_module_property OPAQUE_ADDRESS_MAP true
# |
# +-----------------------------------
set_module_assignment embeddedsw.dts.compatible {altr,mm-debug-link-1.0}
set_module_assignment embeddedsw.dts.vendor altr
set_module_assignment embeddedsw.dts.group debug

# If the parameter is 1, enables CSR_MASTER_INTERFACE, else enables mm_mgmt
# User can either choose CSR_MASTER_INTERFACE or mm_mgmt
# CSR_MASTER_INTERFACE should not be used in new project (Hidden Parameter)
add_parameter ENABLE_CSR_MASTER_INTERFACE INTEGER 0
set_parameter_property ENABLE_CSR_MASTER_INTERFACE status experimental
set_parameter_property ENABLE_CSR_MASTER_INTERFACE DEFAULT_VALUE 0
set_parameter_property ENABLE_CSR_MASTER_INTERFACE DISPLAY_NAME ENABLE_CSR_MASTER_INTERFACE
set_parameter_property ENABLE_CSR_MASTER_INTERFACE TYPE INTEGER
set_parameter_property ENABLE_CSR_MASTER_INTERFACE UNITS None
set_parameter_property ENABLE_CSR_MASTER_INTERFACE ALLOWED_RANGES {0 1}
set_parameter_property ENABLE_CSR_MASTER_INTERFACE AFFECTS_ELABORATION true

add_parameter FIFO_DEPTH INTEGER 32
set_parameter_property FIFO_DEPTH DISPLAY_NAME {Depth of h2t and t2h FIFOs}
set_parameter_property FIFO_DEPTH UNITS None
# The allowed values for FIFO_DEPTH can be whatever altera_avalon_fifo 
# supports for its fifoDepth parameter. Currently the range is further
# restricted, to those values which have been tested.
set_parameter_property FIFO_DEPTH ALLOWED_RANGES {32 64 128}
set_parameter_property FIFO_DEPTH AFFECTS_ELABORATION true

proc compose {} {
  set fifoDepth [ get_parameter_value FIFO_DEPTH ]

  #  Clock, reset 
  add_instance clock_bridge altera_clock_bridge  

  add_instance reset_bridge altera_reset_bridge
  set_instance_parameter reset_bridge SYNCHRONOUS_EDGES deassert

  # Bridge to export the avalon-MM slave interface
  add_instance export_slave altera_avalon_mm_bridge
  set_instance_parameter export_slave DATA_WIDTH 32
  set_instance_parameter export_slave SYMBOL_WIDTH 8
  set_instance_parameter export_slave ADDRESS_WIDTH 7
  set_instance_parameter export_slave ADDRESS_UNITS SYMBOLS
  set_instance_parameter export_slave MAX_BURST_SIZE 1
  set_instance_parameter export_slave MAX_PENDING_RESPONSES 1
  set_instance_parameter export_slave LINEWRAPBURSTS 0
  set_instance_parameter export_slave PIPELINE_COMMAND 0
  set_instance_parameter export_slave PIPELINE_RESPONSE 0

  # write-only slave to ST source
  add_instance write_slave_to_source altera_avalon_fifo
  set_instance_parameter_value write_slave_to_source avalonMMAvalonMMDataWidth {32}
  set_instance_parameter_value write_slave_to_source avalonMMAvalonSTDataWidth {32}
  set_instance_parameter_value write_slave_to_source bitsPerSymbol {8}
  set_instance_parameter_value write_slave_to_source channelWidth {0}
  set_instance_parameter_value write_slave_to_source errorWidth {0}
  set_instance_parameter_value write_slave_to_source fifoDepth $fifoDepth
  set_instance_parameter_value write_slave_to_source fifoInputInterfaceOptions {AVALONMM_WRITE}
  set_instance_parameter_value write_slave_to_source fifoOutputInterfaceOptions {AVALONST_SOURCE}
  set_instance_parameter_value write_slave_to_source showHiddenFeatures {0}
  set_instance_parameter_value write_slave_to_source singleClockMode {1}
  set_instance_parameter_value write_slave_to_source singleResetMode {0}
  set_instance_parameter_value write_slave_to_source symbolsPerBeat {4}
  set_instance_parameter_value write_slave_to_source useBackpressure {1}
  set_instance_parameter_value write_slave_to_source useIRQ {0}
  set_instance_parameter_value write_slave_to_source usePacket {0}
  set_instance_parameter_value write_slave_to_source useReadControl {0}
  set_instance_parameter_value write_slave_to_source useRegister {0}
  set_instance_parameter_value write_slave_to_source useWriteControl {1}

  add_instance write_slave_addr_fixer altera_mm_debug_link_addr_fixer

  # write FIFO capcity - in bytes
  # Although the write FIFO is parameterized at 32 bit data width above,
  # only 8 of those bits actually show up in the hardware. The 
  # write-fifo-capacity value must match what's actually in the hardware.
  add_instance write_fifo_capacity altera_mm_debug_link_constant 
  set_instance_parameter_value write_fifo_capacity VALUE $fifoDepth

  # h2t_timing_adapter
  add_instance h2t_timing_adapter timing_adapter 
  set_instance_parameter_value h2t_timing_adapter inBitsPerSymbol {8}
  set_instance_parameter_value h2t_timing_adapter inChannelWidth {0}
  set_instance_parameter_value h2t_timing_adapter inErrorDescriptor {}
  set_instance_parameter_value h2t_timing_adapter inErrorWidth {0}
  set_instance_parameter_value h2t_timing_adapter inMaxChannel {0}
  set_instance_parameter_value h2t_timing_adapter inReadyLatency {1}
  set_instance_parameter_value h2t_timing_adapter inSymbolsPerBeat {4}
  set_instance_parameter_value h2t_timing_adapter inUseEmpty {0}
  set_instance_parameter_value h2t_timing_adapter inUseEmptyPort {AUTO}
  set_instance_parameter_value h2t_timing_adapter inUsePackets {0}
  set_instance_parameter_value h2t_timing_adapter inUseReady {1}
  set_instance_parameter_value h2t_timing_adapter inUseValid {1}
  set_instance_parameter_value h2t_timing_adapter outReadyLatency {0}
  set_instance_parameter_value h2t_timing_adapter outUseReady {1}
  set_instance_parameter_value h2t_timing_adapter outUseValid {1}

  # h2t_data_matcher
  add_instance h2t_data_matcher altera_mm_debug_link_datawidth_matcher 
  set_instance_parameter_value h2t_data_matcher SOURCE_DATAWIDTH 8
  set_instance_parameter_value h2t_data_matcher SINK_DATAWIDTH 32

  # h2t_packet_source
  add_instance h2t_packet_source altera_avalon_st_bytes_to_packets 
  set_instance_parameter_value h2t_packet_source CHANNEL_WIDTH {8}
  set_instance_parameter_value h2t_packet_source ENCODING {0}

  # h2t_channel_adapter
  add_instance h2t_channel_adapter channel_adapter 
  set_instance_parameter_value h2t_channel_adapter inBitsPerSymbol {8}
  set_instance_parameter_value h2t_channel_adapter inChannelWidth {8}
  set_instance_parameter_value h2t_channel_adapter inErrorDescriptor {}
  set_instance_parameter_value h2t_channel_adapter inErrorWidth {0}
  set_instance_parameter_value h2t_channel_adapter inMaxChannel {255}
  set_instance_parameter_value h2t_channel_adapter inReadyLatency {0}
  set_instance_parameter_value h2t_channel_adapter inSymbolsPerBeat {1}
  set_instance_parameter_value h2t_channel_adapter inUseEmpty {0}
  set_instance_parameter_value h2t_channel_adapter inUseEmptyPort {AUTO}
  set_instance_parameter_value h2t_channel_adapter inUsePackets {1}
  set_instance_parameter_value h2t_channel_adapter inUseReady {1}
  set_instance_parameter_value h2t_channel_adapter outChannelWidth {1}
  set_instance_parameter_value h2t_channel_adapter outMaxChannel {1}
  
 # t2h_channel_adapter
  add_instance t2h_channel_adapter channel_adapter 
  set_instance_parameter_value t2h_channel_adapter inBitsPerSymbol {8}
  set_instance_parameter_value t2h_channel_adapter inChannelWidth {1}
  set_instance_parameter_value t2h_channel_adapter inErrorDescriptor {}
  set_instance_parameter_value t2h_channel_adapter inErrorWidth {0}
  set_instance_parameter_value t2h_channel_adapter inMaxChannel {1}
  set_instance_parameter_value t2h_channel_adapter inReadyLatency {0}
  set_instance_parameter_value t2h_channel_adapter inSymbolsPerBeat {1}
  set_instance_parameter_value t2h_channel_adapter inUseEmpty {0}
  set_instance_parameter_value t2h_channel_adapter inUseEmptyPort {AUTO}
  set_instance_parameter_value t2h_channel_adapter inUsePackets {1}
  set_instance_parameter_value t2h_channel_adapter inUseReady {1}
  set_instance_parameter_value t2h_channel_adapter outChannelWidth {8}
  set_instance_parameter_value t2h_channel_adapter outMaxChannel {255}

  # t2h_byte_source
  add_instance t2h_byte_source altera_avalon_st_packets_to_bytes
  set_instance_parameter_value t2h_byte_source CHANNEL_WIDTH {8}
  set_instance_parameter_value t2h_byte_source ENCODING {0}

  # t2h_data_matcher
  add_instance t2h_data_matcher altera_mm_debug_link_datawidth_matcher
  set_instance_parameter_value t2h_data_matcher SOURCE_DATAWIDTH 32
  set_instance_parameter_value t2h_data_matcher SINK_DATAWIDTH 8

  # t2h_timing_adapter
  add_instance t2h_timing_adapter timing_adapter
  set_instance_parameter_value t2h_timing_adapter inBitsPerSymbol {8}
  set_instance_parameter_value t2h_timing_adapter inChannelWidth {0}
  set_instance_parameter_value t2h_timing_adapter inErrorDescriptor {}
  set_instance_parameter_value t2h_timing_adapter inErrorWidth {0}
  set_instance_parameter_value t2h_timing_adapter inMaxChannel {0}
  set_instance_parameter_value t2h_timing_adapter inReadyLatency {0}
  set_instance_parameter_value t2h_timing_adapter inSymbolsPerBeat {4}
  set_instance_parameter_value t2h_timing_adapter inUseEmpty {0}
  set_instance_parameter_value t2h_timing_adapter inUseEmptyPort {AUTO}
  set_instance_parameter_value t2h_timing_adapter inUsePackets {0}
  set_instance_parameter_value t2h_timing_adapter inUseReady {1}
  set_instance_parameter_value t2h_timing_adapter inUseValid {1}
  set_instance_parameter_value t2h_timing_adapter outReadyLatency {1}
  set_instance_parameter_value t2h_timing_adapter outUseReady {1}
  set_instance_parameter_value t2h_timing_adapter outUseValid {1}

  # sink_to_read_slave
  add_instance sink_to_read_slave altera_avalon_fifo
  set_instance_parameter_value sink_to_read_slave avalonMMAvalonMMDataWidth {32}
  set_instance_parameter_value sink_to_read_slave avalonMMAvalonSTDataWidth {32}
  set_instance_parameter_value sink_to_read_slave bitsPerSymbol {8}
  set_instance_parameter_value sink_to_read_slave channelWidth {0}
  set_instance_parameter_value sink_to_read_slave errorWidth {0}
  set_instance_parameter_value sink_to_read_slave fifoDepth $fifoDepth
  set_instance_parameter_value sink_to_read_slave fifoInputInterfaceOptions {AVALONST_SINK}
  set_instance_parameter_value sink_to_read_slave fifoOutputInterfaceOptions {AVALONMM_READ}
  set_instance_parameter_value sink_to_read_slave showHiddenFeatures {0}
  set_instance_parameter_value sink_to_read_slave singleClockMode {1}
  set_instance_parameter_value sink_to_read_slave singleResetMode {0}
  set_instance_parameter_value sink_to_read_slave symbolsPerBeat {4}
  set_instance_parameter_value sink_to_read_slave useBackpressure {1}
  set_instance_parameter_value sink_to_read_slave useIRQ {0}
  set_instance_parameter_value sink_to_read_slave usePacket {0}
  set_instance_parameter_value sink_to_read_slave useReadControl {0}
  set_instance_parameter_value sink_to_read_slave useRegister {0}
  set_instance_parameter_value sink_to_read_slave useWriteControl {1}

  add_instance read_slave_addr_fixer altera_mm_debug_link_addr_fixer

  # read FIFO capacity - in bytes
  # (See note about actual hardware FIFO capacities, near the write FIFO.)
  add_instance read_fifo_capacity altera_mm_debug_link_constant 
  set_instance_parameter_value read_fifo_capacity VALUE $fifoDepth

  # connection id rom
  add_instance connection_id_rom altera_connection_identification_rom_wrapper
  set_instance_parameter connection_id_rom LATENCY 2

  # Interface exports
  add_interface clk clock end
  set_interface_property clk export_of clock_bridge.in_clk
  add_interface reset reset end
  set_interface_property reset export_of reset_bridge.in_reset
  add_interface s0 avalon end
  set_interface_property s0 export_of export_slave.s0

  add_interface h2t avalon_streaming start
  set_interface_property h2t export_of h2t_channel_adapter.out

  set_interface_assignment h2t debug.hostConnection {type tcp}
  set_interface_assignment h2t debug.interfaceGroup {associatedT2h t2h associatedMgmt mgmt}
  set_interface_assignment h2t debug.providesServices packet

  add_interface t2h avalon_streaming end
  set_interface_property t2h export_of t2h_channel_adapter.in

  add_connection clock_bridge.out_clk reset_bridge.clk

  add_connection clock_bridge.out_clk write_slave_to_source.clk_in
  add_connection reset_bridge.out_reset write_slave_to_source.reset_in
  add_connection clock_bridge.out_clk write_slave_addr_fixer.clock
  add_connection reset_bridge.out_reset write_slave_addr_fixer.reset
  add_connection clock_bridge.out_clk write_fifo_capacity.clock
  add_connection reset_bridge.out_reset write_fifo_capacity.reset
  add_connection clock_bridge.out_clk sink_to_read_slave.clk_in
  add_connection reset_bridge.out_reset sink_to_read_slave.reset_in
  add_connection clock_bridge.out_clk read_fifo_capacity.clock
  add_connection reset_bridge.out_reset read_fifo_capacity.reset
  add_connection clock_bridge.out_clk export_slave.clk
  add_connection reset_bridge.out_reset export_slave.reset
  add_connection export_slave.m0 write_slave_addr_fixer.s0
  add_connection write_slave_addr_fixer.m0 write_slave_to_source.in
  add_connection export_slave.m0 write_fifo_capacity.s0

  add_connection export_slave.m0 read_slave_addr_fixer.s0
  add_connection read_slave_addr_fixer.m0 sink_to_read_slave.out
  add_connection clock_bridge.out_clk read_slave_addr_fixer.clock
  add_connection reset_bridge.out_reset read_slave_addr_fixer.reset

  add_connection export_slave.m0 read_fifo_capacity.s0
  add_connection clock_bridge.out_clk h2t_data_matcher.clock
  add_connection reset_bridge.out_reset h2t_data_matcher.reset
  add_connection clock_bridge.out_clk h2t_timing_adapter.clk
  add_connection reset_bridge.out_reset h2t_timing_adapter.reset
  add_connection write_slave_to_source.out h2t_timing_adapter.in
  add_connection h2t_timing_adapter.out h2t_data_matcher.sink
  add_connection clock_bridge.out_clk h2t_packet_source.clk
  add_connection reset_bridge.out_reset h2t_packet_source.clk_reset
  add_connection h2t_data_matcher.source h2t_packet_source.in_bytes_stream
  add_connection clock_bridge.out_clk t2h_byte_source.clk
  add_connection reset_bridge.out_reset t2h_byte_source.clk_reset
  add_connection clock_bridge.out_clk t2h_data_matcher.clock
  add_connection reset_bridge.out_reset t2h_data_matcher.reset
  add_connection t2h_byte_source.out_bytes_stream t2h_data_matcher.sink
  add_connection t2h_channel_adapter.out t2h_byte_source.in_packets_stream
  add_connection clock_bridge.out_clk t2h_channel_adapter.clk
  add_connection reset_bridge.out_reset t2h_channel_adapter.reset
  add_connection h2t_packet_source.out_packets_stream h2t_channel_adapter.in
  add_connection clock_bridge.out_clk h2t_channel_adapter.clk
  add_connection reset_bridge.out_reset h2t_channel_adapter.reset
  add_connection clock_bridge.out_clk t2h_timing_adapter.clk
  add_connection reset_bridge.out_reset t2h_timing_adapter.reset
  add_connection t2h_timing_adapter.out sink_to_read_slave.in
  add_connection t2h_data_matcher.source t2h_timing_adapter.in
  add_connection export_slave.m0 write_slave_to_source.in_csr
  add_connection export_slave.m0 sink_to_read_slave.in_csr

  add_connection clock_bridge.out_clk connection_id_rom.clock
  add_connection reset_bridge.out_reset connection_id_rom.reset
  add_connection export_slave.m0 connection_id_rom.s0

  set_connection_parameter_value export_slave.m0/write_slave_addr_fixer.s0 arbitrationPriority {1}
  set_connection_parameter_value export_slave.m0/write_slave_addr_fixer.s0 baseAddress {0}

  set_connection_parameter_value write_slave_addr_fixer.m0/write_slave_to_source.in arbitrationPriority {1}
  set_connection_parameter_value write_slave_addr_fixer.m0/write_slave_to_source.in baseAddress {0}

  set_connection_parameter_value export_slave.m0/write_fifo_capacity.s0 arbitrationPriority {1}
  set_connection_parameter_value export_slave.m0/write_fifo_capacity.s0 baseAddress {4}

  set_connection_parameter_value export_slave.m0/read_slave_addr_fixer.s0 arbitrationPriority {1}
  set_connection_parameter_value export_slave.m0/read_slave_addr_fixer.s0 baseAddress {8}

  set_connection_parameter_value read_slave_addr_fixer.m0/sink_to_read_slave.out arbitrationPriority {1}
  set_connection_parameter_value read_slave_addr_fixer.m0/sink_to_read_slave.out baseAddress {0}

  set_connection_parameter_value export_slave.m0/read_fifo_capacity.s0 arbitrationPriority {1}
  set_connection_parameter_value export_slave.m0/read_fifo_capacity.s0 baseAddress {0xC}

  set_connection_parameter_value export_slave.m0/write_slave_to_source.in_csr arbitrationPriority {1}
  set_connection_parameter_value export_slave.m0/write_slave_to_source.in_csr baseAddress {0x20}

  set_connection_parameter_value export_slave.m0/sink_to_read_slave.in_csr arbitrationPriority {1}
  set_connection_parameter_value export_slave.m0/sink_to_read_slave.in_csr baseAddress {0x40}

  set_connection_parameter_value export_slave.m0/connection_id_rom.s0 arbitrationPriority {1}
  set_connection_parameter_value export_slave.m0/connection_id_rom.s0 baseAddress {0x60}

  ###### CSR_MASTER_INTERFACE ######
  if { [ get_parameter_value ENABLE_CSR_MASTER_INTERFACE ] } {
    # The csr_bridge exports a 16-byte-span wedge of export_slave.s0's
    # address space.  The purpose is to allow an internal connection from the
    # debug link to the sld hub controller's csr slave.
    add_instance csr_bridge altera_avalon_mm_bridge
    set_instance_parameter csr_bridge DATA_WIDTH 32
    set_instance_parameter csr_bridge SYMBOL_WIDTH 8
    set_instance_parameter csr_bridge ADDRESS_WIDTH 4
    set_instance_parameter csr_bridge ADDRESS_UNITS SYMBOLS
    set_instance_parameter csr_bridge MAX_BURST_SIZE 1
    set_instance_parameter csr_bridge MAX_PENDING_RESPONSES 1
    set_instance_parameter csr_bridge LINEWRAPBURSTS 0
    set_instance_parameter csr_bridge PIPELINE_COMMAND 0
    set_instance_parameter csr_bridge PIPELINE_RESPONSE 0

    add_connection clock_bridge.out_clk csr_bridge.clk
    add_connection reset_bridge.out_reset csr_bridge.reset

    add_connection export_slave.m0 csr_bridge.s0
    set_connection_parameter_value export_slave.m0/csr_bridge.s0 arbitrationPriority {1}
    set_connection_parameter_value export_slave.m0/csr_bridge.s0 baseAddress {0x70} 

    add_interface csr_master avalon start
    set_interface_property csr_master export_of csr_bridge.m0
  } else {
    ###### mm_mgmt_wrapper ######
    add_instance mm_mgmt altera_mm_mgmt_wrapper
    set_instance_parameter mm_mgmt CHANNEL_WIDTH 8

    add_connection clock_bridge.out_clk mm_mgmt.clk
    add_connection reset_bridge.out_reset mm_mgmt.reset

    add_connection export_slave.m0 mm_mgmt.csr
    set_connection_parameter_value export_slave.m0/mm_mgmt.csr arbitrationPriority {1}
    set_connection_parameter_value export_slave.m0/mm_mgmt.csr baseAddress {0x70}

    # Interface Exports (mm_mgmt)
    add_interface mgmt avalon_streaming start
    set_interface_property mgmt export_of mm_mgmt.mgmt

    add_interface debug_reset reset start
    set_interface_property debug_reset export_of mm_mgmt.debug_reset
  }
}

