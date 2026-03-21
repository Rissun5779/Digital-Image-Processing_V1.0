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


# $Id: //acds/rel/18.1std/ip/merlin/altera_merlin_slave_agent/altera_merlin_slave_agent_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# +-----------------------------------
# | 
# | altera_merlin_slave_agent "Merlin Slave Agent" v1.0
# | null 2008.09.19.14:00:52
# | 
# | 
# | /data/jyeap/p4root/acds/main/ip_tests/sopc_builder/components/merlin/merlin_agent_integration/ip/altera_merlin_slave_agent/altera_merlin_slave_agent.sv
# | 
# |    ./altera_merlin_slave_agent.sv syn, sim
# | 
# +-----------------------------------

package require -exact qsys 12.1

source ../shared/merlin_shared.tcl

proc log2ceiling { num } {
   set val 0
   set i   1
   while { $i < $num } {
      set val [ expr $val + 1 ]
      set i   [ expr 1 << $val ]
   }

   return $val;
}

proc elaborate {} {
   # +-----------------------------------
   # | connection point clk
   # | 
   add_interface clk clock end
   set_interface_property clk ptfSchematicName ""

   add_interface_port clk clk clk Input 1

   # +-----------------------------------
   # | connection point clk_reset
   # | 
   add_interface clk_reset reset end
   add_interface_port clk_reset reset reset Input 1
   set_interface_property clk_reset associatedClock clk
   # | 
   # +-----------------------------------
   set data_width [ expr [ get_parameter_value PKT_DATA_H ] - [ get_parameter_value PKT_DATA_L ] + 1 ]
   set rdata_fifo_width [ expr $data_width + 2]
   set be_width [ expr $data_width / 8 ]
   set addr_width [ expr [ get_parameter_value PKT_ADDR_H ] - [ get_parameter_value PKT_ADDR_L ] + 1 ]

   set mid_width [ expr [ get_parameter_value PKT_SRC_ID_H ] - [ get_parameter_value PKT_SRC_ID_L ] + 1 ]
   set sid_width [ expr [ get_parameter_value PKT_DEST_ID_H ] - [ get_parameter_value PKT_DEST_ID_L ] + 1 ]
   set field_info [ get_parameter_value MERLIN_PACKET_FORMAT ]

   set pkt_width [ get_parameter_value ST_DATA_W ]
   set fifo_width [ expr $pkt_width + 1 ]
   #if { [ get_parameter_value AVS_BURSTCOUNT_SYMBOLS ] } {
   set burstcount_width [ get_parameter_value AVS_BURSTCOUNT_W ]
   set ecc_enable [get_parameter ECC_ENABLE]
   #} else {
   #    set burstcount_width [ expr [ get_parameter_value AVS_BURSTCOUNT_W ] + [ log2ceiling $be_width ] ]
   #}
   # +-----------------------------------
   # | connection point m0
   # | 
   set lw [ get_parameter_value AV_LINEWRAPBURSTS ]

   add_interface m0 avalon start
   set_interface_property m0 adaptsTo ""
   set_interface_property m0 burstOnBurstBoundariesOnly false
   set_interface_property m0 doStreamReads false
   set_interface_property m0 doStreamWrites false
   set_interface_property m0 linewrapBursts $lw
   set_interface_property m0 constantBurstBehavior false
   set_interface_property m0 burstcountUnits SYMBOLS
   set_interface_property m0 addressUnits SYMBOLS

   set_interface_property m0 associatedClock clk
   set_interface_property m0 associatedReset clk_reset

   add_interface_port m0 m0_address address Output $addr_width
   set_port_property m0_address vhdl_type std_logic_vector
   add_interface_port m0 m0_burstcount burstcount Output $burstcount_width
   set_port_property m0_burstcount vhdl_type std_logic_vector
   add_interface_port m0 m0_byteenable byteenable Output $be_width
   set_port_property m0_byteenable vhdl_type std_logic_vector
   add_interface_port m0 m0_debugaccess debugaccess Output 1
   add_interface_port m0 m0_lock lock Output 1
   add_interface_port m0 m0_readdata readdata Input $data_width
   set_port_property m0_readdata vhdl_type std_logic_vector
   add_interface_port m0 m0_readdatavalid readdatavalid Input 1
   add_interface_port m0 m0_read read Output 1
   add_interface_port m0 m0_waitrequest waitrequest Input 1
   add_interface_port m0 m0_writedata writedata Output $data_width
   set_port_property m0_writedata vhdl_type std_logic_vector
   add_interface_port m0 m0_write write Output 1
   # Response siganls
   add_interface_port m0 m0_response response Input 2
   set_port_property m0_response vhdl_type std_logic_vector
   # add_interface_port m0 m0_writeresponserequest writeresponserequest Output 1
   add_interface_port m0 m0_writeresponsevalid writeresponsevalid Input 1
   if { ([ get_parameter_value USE_READRESPONSE ] == 0) && ([ get_parameter_value USE_WRITERESPONSE ] == 0) } {
      set_port_property m0_response termination true
      set_port_property m0_response termination_value 0
   }
   if { [ get_parameter_value USE_WRITERESPONSE ] == 0 } {
      # set_port_property m0_writeresponserequest termination true
      # set_port_property m0_writeresponserequest termination_value 0
      set_port_property m0_writeresponsevalid termination true
      set_port_property m0_writeresponsevalid termination_value 0
   }
   set_interface_assignment m0 merlin.flow.rp rp
   # | 
   # +-----------------------------------

   # +-----------------------------------
   # | connection point rp
   # | 
   add_interface rp avalon_streaming start
   set_interface_property rp dataBitsPerSymbol $pkt_width
   set_interface_property rp errorDescriptor ""
   set_interface_property rp maxChannel 0
   set_interface_property rp readyLatency 0
   set_interface_property rp symbolsPerBeat 1

   set_interface_property rp associatedClock clk
   set_interface_property rp associatedReset clk_reset

   add_interface_port rp rp_endofpacket endofpacket Output 1
   add_interface_port rp rp_ready ready Input 1
   add_interface_port rp rp_valid valid Output 1
   add_interface_port rp rp_data data Output $pkt_width
   add_interface_port rp rp_startofpacket startofpacket Output 1

   set_interface_assignment rp merlin.packet_format $field_info
   # | 
   # +-----------------------------------

   # +-----------------------------------
   # | connection point cp
   # | 
   add_interface cp avalon_streaming end
   set_interface_property cp dataBitsPerSymbol $pkt_width
   set_interface_property cp errorDescriptor ""
   set_interface_property cp maxChannel 0
   set_interface_property cp readyLatency 0
   set_interface_property cp symbolsPerBeat 1

   set_interface_property cp associatedClock clk
   set_interface_property cp associatedReset clk_reset

   add_interface_port cp cp_ready ready Output 1
   add_interface_port cp cp_valid valid Input 1
   add_interface_port cp cp_data data Input $pkt_width
   set_port_property cp_data vhdl_type std_logic_vector
   add_interface_port cp cp_startofpacket startofpacket Input 1
   add_interface_port cp cp_endofpacket endofpacket Input 1
   add_interface_port cp cp_channel channel Input [ get_parameter_value ST_CHANNEL_W ]
   set_port_property cp_channel vhdl_type std_logic_vector

   set_interface_assignment cp merlin.packet_format $field_info
   set_interface_assignment cp merlin.flow.m0 m0
   # | 
   # +-----------------------------------

   # +-----------------------------------
   # | connection point rf_sink
   # | 
   add_interface rf_sink avalon_streaming end
   set_interface_property rf_sink dataBitsPerSymbol $fifo_width
   set_interface_property rf_sink errorDescriptor ""
   set_interface_property rf_sink maxChannel 0
   set_interface_property rf_sink readyLatency 0
   set_interface_property rf_sink symbolsPerBeat 1

   set_interface_property rf_sink associatedClock clk
   set_interface_property rf_sink associatedReset clk_reset

   add_interface_port rf_sink rf_sink_ready ready Output 1
   add_interface_port rf_sink rf_sink_valid valid Input 1
   add_interface_port rf_sink rf_sink_startofpacket startofpacket Input 1
   add_interface_port rf_sink rf_sink_endofpacket endofpacket Input 1
   add_interface_port rf_sink rf_sink_data data Input $fifo_width
   set_port_property rf_sink_data vhdl_type std_logic_vector
   # | 
   # +-----------------------------------

   # +-----------------------------------
   # | connection point rf_source
   # | 
   add_interface rf_source avalon_streaming start
   set_interface_property rf_source dataBitsPerSymbol $fifo_width
   set_interface_property rf_source errorDescriptor ""
   set_interface_property rf_source maxChannel 0
   set_interface_property rf_source readyLatency 0
   set_interface_property rf_source symbolsPerBeat 1

   set_interface_property rf_source associatedClock clk
   set_interface_property rf_source associatedReset clk_reset

   add_interface_port rf_source rf_source_ready ready Input 1
   add_interface_port rf_source rf_source_valid valid Output 1
   add_interface_port rf_source rf_source_startofpacket startofpacket Output 1
   add_interface_port rf_source rf_source_endofpacket endofpacket Output 1
   add_interface_port rf_source rf_source_data data Output $fifo_width
   set_port_property rf_source_data vhdl_type std_logic_vector
   # | 
   # +-----------------------------------

   # +-----------------------------------
   # | connection point rdata_fifo_sink
   # |
   add_interface rdata_fifo_sink avalon_streaming end
   set_interface_property rdata_fifo_sink dataBitsPerSymbol $rdata_fifo_width
   set_interface_property rdata_fifo_sink errorDescriptor ""
   set_interface_property rdata_fifo_sink maxChannel 0
   set_interface_property rdata_fifo_sink readyLatency 0
   set_interface_property rdata_fifo_sink symbolsPerBeat 1

   set_interface_property rdata_fifo_sink associatedClock clk
   set_interface_property rdata_fifo_sink associatedReset clk_reset

   add_interface_port rdata_fifo_sink rdata_fifo_sink_ready ready Output 1
   add_interface_port rdata_fifo_sink rdata_fifo_sink_valid valid Input 1
   add_interface_port rdata_fifo_sink rdata_fifo_sink_data data Input $rdata_fifo_width
   set_port_property rdata_fifo_sink_data vhdl_type std_logic_vector
   add_interface_port rdata_fifo_sink rdata_fifo_sink_error error Input 1
   if { $ecc_enable == 0 } {
     set_port_property rdata_fifo_sink_error TERMINATION 0 
   }
   # |
   # +-----------------------------------

   # +-----------------------------------
   # | connection point rdata_fifo_src
   # |
   add_interface rdata_fifo_src avalon_streaming start
   set_interface_property rdata_fifo_src dataBitsPerSymbol $rdata_fifo_width
   set_interface_property rdata_fifo_src errorDescriptor ""
   set_interface_property rdata_fifo_src maxChannel 0
   set_interface_property rdata_fifo_src readyLatency 0
   set_interface_property rdata_fifo_src symbolsPerBeat 1

   set_interface_property rdata_fifo_src associatedClock clk
   set_interface_property rdata_fifo_src associatedReset clk_reset

   add_interface_port rdata_fifo_src rdata_fifo_src_ready ready Input 1
   add_interface_port rdata_fifo_src rdata_fifo_src_valid valid Output 1
   add_interface_port rdata_fifo_src rdata_fifo_src_data data Output $rdata_fifo_width
   set_port_property rdata_fifo_src_data vhdl_type std_logic_vector
   # |
   # +-----------------------------------
}

# +-----------------------------------
# | module altera_merlin_slave_agent
# | 
init_merlin_module_property
set_module_property NAME altera_merlin_slave_agent
set_module_property DISPLAY_NAME "Avalon MM Slave Agent"
set_module_property DESCRIPTION "Accepts command packets and issues the resulting transactions to the Avalon interface. Refer to the Avalon Interface Specifications (http://www.altera.com/literature/manual/mnl_avalon_spec.pdf) for explanations of the bursting properties."
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 

add_fileset synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
set_fileset_property synthesis_fileset TOP_LEVEL altera_merlin_slave_agent 
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL altera_merlin_slave_agent
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure_vhdl
set_fileset_property vhdl_fileset TOP_LEVEL altera_merlin_slave_agent

proc synth_callback_procedure { entity_name } {
   add_fileset_file altera_merlin_slave_agent.sv SYSTEM_VERILOG PATH "altera_merlin_slave_agent.sv"
   add_fileset_file altera_merlin_burst_uncompressor.sv SYSTEM_VERILOG PATH "altera_merlin_burst_uncompressor.sv"
}

proc synth_callback_procedure_vhdl { entity_name } {
   if {1} {
      add_fileset_file mentor/altera_merlin_slave_agent.sv SYSTEM_VERILOG_ENCRYPT PATH "mentor/altera_merlin_slave_agent.sv" {MENTOR_SPECIFIC}
      add_fileset_file mentor/altera_merlin_burst_uncompressor.sv SYSTEM_VERILOG_ENCRYPT PATH "mentor/altera_merlin_burst_uncompressor.sv" {MENTOR_SPECIFIC}
   }
   if {1} {
      add_fileset_file aldec/altera_merlin_slave_agent.sv SYSTEM_VERILOG_ENCRYPT PATH "aldec/altera_merlin_slave_agent.sv" {ALDEC_SPECIFIC}
      add_fileset_file aldec/altera_merlin_burst_uncompressor.sv SYSTEM_VERILOG_ENCRYPT PATH "aldec/altera_merlin_burst_uncompressor.sv" {ALDEC_SPECIFIC}
   }
   if {1} {
      add_fileset_file cadence/altera_merlin_slave_agent.sv SYSTEM_VERILOG_ENCRYPT PATH "cadence/altera_merlin_slave_agent.sv" {CADENCE_SPECIFIC}
      add_fileset_file cadence/altera_merlin_burst_uncompressor.sv SYSTEM_VERILOG_ENCRYPT PATH "cadence/altera_merlin_burst_uncompressor.sv" {CADENCE_SPECIFIC}
   }
   if {1} {
      add_fileset_file synopsys/altera_merlin_slave_agent.sv SYSTEM_VERILOG_ENCRYPT PATH "synopsys/altera_merlin_slave_agent.sv" {SYNOPSYS_SPECIFIC}
      add_fileset_file synopsys/altera_merlin_burst_uncompressor.sv SYSTEM_VERILOG_ENCRYPT PATH "synopsys/altera_merlin_burst_uncompressor.sv" {SYNOPSYS_SPECIFIC}
   }    
}

# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 

# +-----------------------------------
# | packet parameters
# |
add_packet_parameter PKT_ORI_BURST_SIZE         {original burst size}         88    3
add_packet_parameter PKT_RESPONSE_STATUS        {response status}             86    2
add_packet_parameter PKT_BURST_SIZE             {burstsize}                   83    3
add_packet_parameter PKT_TRANS_LOCK             {lock transaction}            82    0
add_packet_parameter PKT_BEGIN_BURST            {begin burst}                 81    0
add_packet_parameter PKT_PROTECTION             {protection}                  80    1
add_packet_parameter PKT_BURSTWRAP              {burstwrap}                   77    3
add_packet_parameter PKT_BYTE_CNT               {byte count}                  74    3
add_packet_parameter PKT_ADDR                   {address}                     42    32
add_packet_parameter PKT_TRANS_COMPRESSED_READ  {compressed read transaction} 41    0
add_packet_parameter PKT_TRANS_POSTED           {posted transaction}          40    0
add_packet_parameter PKT_TRANS_WRITE            {write transaction}           39    0
add_packet_parameter PKT_TRANS_READ             {read transaction}            38    0
add_packet_parameter PKT_DATA                   {data}                        6     32
add_packet_parameter PKT_BYTEEN                 {byteenable}                  2     4
add_packet_parameter PKT_SRC_ID                 {source id}                   1     1
add_packet_parameter PKT_DEST_ID                {destination id}              0     1

# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter PKT_SYMBOL_W INTEGER 8
set_parameter_property PKT_SYMBOL_W DISPLAY_NAME {Packet symbol width}
set_parameter_property PKT_SYMBOL_W UNITS None
set_parameter_property PKT_SYMBOL_W AFFECTS_ELABORATION true
set_parameter_property PKT_SYMBOL_W HDL_PARAMETER true
set_parameter_property PKT_SYMBOL_W DESCRIPTION {Packet symbol width}

add_parameter ST_CHANNEL_W INTEGER 8
set_parameter_property ST_CHANNEL_W DISPLAY_NAME {Streaming channel width}
set_parameter_property ST_CHANNEL_W UNITS None
set_parameter_property ST_CHANNEL_W ALLOWED_RANGES 0:2147483647
set_parameter_property ST_CHANNEL_W DESCRIPTION {Streaming channel width}
set_parameter_property ST_CHANNEL_W AFFECTS_ELABORATION true
set_parameter_property ST_CHANNEL_W HDL_PARAMETER true

add_parameter ST_DATA_W INTEGER 96
set_parameter_property ST_DATA_W DISPLAY_NAME {Streaming data width}
set_parameter_property ST_DATA_W UNITS None
set_parameter_property ST_DATA_W AFFECTS_ELABORATION true
set_parameter_property ST_DATA_W HDL_PARAMETER true
set_parameter_property ST_DATA_W DESCRIPTION {StreamingPacket data width}

add_parameter AVS_BURSTCOUNT_SYMBOLS INTEGER 0
set_parameter_property AVS_BURSTCOUNT_SYMBOLS DISPLAY_NAME {burstcountSymbols}
set_parameter_property AVS_BURSTCOUNT_SYMBOLS UNITS None
set_parameter_property AVS_BURSTCOUNT_SYMBOLS AFFECTS_ELABORATION true
set_parameter_property AVS_BURSTCOUNT_SYMBOLS DESCRIPTION {Avalon-MM burstcountSymbols interface property - universal Avalon interface}

add_parameter AVS_BURSTCOUNT_W INTEGER 4
set_parameter_property AVS_BURSTCOUNT_W DISPLAY_NAME {burstcount width}
set_parameter_property AVS_BURSTCOUNT_W UNITS None
set_parameter_property AVS_BURSTCOUNT_W AFFECTS_ELABORATION true
set_parameter_property AVS_BURSTCOUNT_W HDL_PARAMETER true
set_parameter_property AVS_BURSTCOUNT_W DESCRIPTION {Width of the burstcount signal - universal Avalon interface}

add_parameter AV_LINEWRAPBURSTS INTEGER 0
set_parameter_property AV_LINEWRAPBURSTS DISPLAY_NAME {linewrapBursts}
set_parameter_property AV_LINEWRAPBURSTS UNITS None
set_parameter_property AV_LINEWRAPBURSTS AFFECTS_ELABORATION true
set_parameter_property AV_LINEWRAPBURSTS HDL_PARAMETER false
set_parameter_property AV_LINEWRAPBURSTS DISPLAY_HINT boolean
set_parameter_property AV_LINEWRAPBURSTS DESCRIPTION {Avalon-MM linewrapBursts interface property}

add_parameter MERLIN_PACKET_FORMAT String ""
set_parameter_property MERLIN_PACKET_FORMAT DISPLAY_NAME {Merlin packet format descriptor}
set_parameter_property MERLIN_PACKET_FORMAT UNITS None
set_parameter_property MERLIN_PACKET_FORMAT DESCRIPTION {Merlin packet format descriptor}

add_parameter SUPPRESS_0_BYTEEN_CMD INTEGER 1
set_parameter_property SUPPRESS_0_BYTEEN_CMD DISPLAY_NAME {Suppress 0-byteenable transactions}
set_parameter_property SUPPRESS_0_BYTEEN_CMD UNITS None
set_parameter_property SUPPRESS_0_BYTEEN_CMD DESCRIPTION {Suppress transactions with all byteenables deasserted}
set_parameter_property SUPPRESS_0_BYTEEN_CMD HDL_PARAMETER true

add_parameter PREVENT_FIFO_OVERFLOW INTEGER 0
set_parameter_property PREVENT_FIFO_OVERFLOW DISPLAY_NAME {Prevent FIFO overflow}
set_parameter_property PREVENT_FIFO_OVERFLOW UNITS None
set_parameter_property PREVENT_FIFO_OVERFLOW DESCRIPTION {Backpressure to prevent FIFO overflow}
set_parameter_property PREVENT_FIFO_OVERFLOW HDL_PARAMETER true

add_parameter MAX_BYTE_CNT INTEGER 8
set_parameter_property MAX_BYTE_CNT DISPLAY_NAME {Maximum byte-count value}
set_parameter_property MAX_BYTE_CNT UNITS None
set_parameter_property MAX_BYTE_CNT DESCRIPTION {Maximum byte-count value}
set_parameter_property MAX_BYTE_CNT HDL_PARAMETER false

add_parameter MAX_BURSTWRAP INTEGER 15
set_parameter_property MAX_BURSTWRAP DISPLAY_NAME {Maximum burstwrap value}
set_parameter_property MAX_BURSTWRAP UNITS None
set_parameter_property MAX_BURSTWRAP DESCRIPTION {Maximum burstwrap value}
set_parameter_property MAX_BURSTWRAP HDL_PARAMETER false

add_parameter ID INTEGER 1
set_parameter_property ID DISPLAY_NAME {Slave ID}
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER false
set_parameter_property ID DESCRIPTION {Network-domain-unique Slave ID}

add_parameter USE_READRESPONSE INTEGER 0
set_parameter_property USE_READRESPONSE AFFECTS_ELABORATION true
set_parameter_property USE_READRESPONSE HDL_PARAMETER true
set_parameter_property USE_READRESPONSE DISPLAY_HINT BOOLEAN
set_parameter_property USE_READRESPONSE DESCRIPTION {Enable the read response signal}
set_parameter_property USE_READRESPONSE DISPLAY_NAME {Use readresponse}

add_parameter USE_WRITERESPONSE INTEGER 0
set_parameter_property USE_WRITERESPONSE AFFECTS_ELABORATION true
set_parameter_property USE_WRITERESPONSE HDL_PARAMETER true
set_parameter_property USE_WRITERESPONSE DISPLAY_HINT BOOLEAN
set_parameter_property USE_WRITERESPONSE DESCRIPTION {Enable the write response signals}
set_parameter_property USE_WRITERESPONSE DISPLAY_NAME {Use writeresponse}

add_parameter ECC_ENABLE          INTEGER 0  ""
set_parameter_property ECC_ENABLE          IS_HDL_PARAMETER true
set_parameter_property ECC_ENABLE          VISIBLE false
# | 
# +-----------------------------------
# +-----------------------------------
# | Set all parameters to AFFECTS_GENERATION false
# | 
foreach parameter [get_parameters] { 
   set_parameter_property $parameter AFFECTS_GENERATION false 
}
# | 
# +-----------------------------------


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409958828732
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
