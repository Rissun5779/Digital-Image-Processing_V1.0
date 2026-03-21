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

source "../../lib/altera_rs_utilities.tcl"
source "../../../../dsp/lib/tcl/avalon_streaming_util.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ser_dec
# |
set_module_property NAME altera_rs_ser_dec
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/Reed Solomon II"
set_module_property DISPLAY_NAME "Reed Solomon II Decoder"
set_module_property DESCRIPTION "Altera Reed Solomon Serial Decoder"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersDEC
add_module_parametersSTATUS
set_module_property VALIDATION_CALLBACK validateDEC
set_module_property COMPOSITION_CALLBACK compose

# |
# +-----------------------------------

# +-----------------------------------
# | Callbacks
# | 

proc compose {} {

    set bitspersymbol               [ get_parameter_value BITSPERSYMBOL ]
    set check                       [ get_parameter_value CHECK ]
    set channel                     [ get_parameter_value CHANNEL ]
    set irrpol                      [ get_parameter_value IRRPOL ]
    set genstart                    [ get_parameter_value GENSTART ]
    set rootspace                   [ get_parameter_value ROOTSPACE ]
    set n                           [ get_parameter_value N ]
    set min_n                       [ get_parameter_value MIN_N ]
    set erasure                     [ get_parameter_value ERASURE ]
    set varcheck                    [ get_parameter_value VARCHECK ]
    set varn                        [ get_parameter_value VARN ]
    set bitcounttype                [ get_parameter_value BITCOUNTTYPE ]
    set errorsymbol                 [ get_parameter_value ERRORSYMB ]
    set errorsymbcount              [ get_parameter_value ERRORSYMBCOUNT ]
    set errorbitcount               [ get_parameter_value ERRORBITCOUNT ]
    set usenumn                     [ get_parameter_value USENUMN ]
    set optimizelatency             [ get_parameter_value OPTIMIZE_LATENCY ]
    set userom                      [ get_parameter_value USEROM ]
    set bmfixedlatency              [ get_parameter_value BMFIXEDLATENCY ]
    set use_dual_basis              [ get_parameter_value USEDUALBASIS ]
    set dual_basis_of               [ get_parameter_value DUALBASISOF ]
	
    set max_channel                 [ expr $channel - 1 ]
    set channel_width               [ expr int(ceil(log($channel) / log(2))) ]
    set n_width                     [ expr int(ceil(log($n+1) / log(2))) ]
    set check_width                 [ expr int(ceil(log($check+1) / log(2))) ]

    if {$channel == 1} {
        set use_channel             0
        set splitter_channel_width  1
    } else {
        set use_channel    1
        set splitter_channel_width  $channel_width
    }


    # FIFO DEPTH = codeword length * channel * 2
    set depth                       [expr (pow(2,$bitspersymbol + $channel_width + 1))] 
    
    set in_datas_width              [ expr $bitspersymbol + $check_width*$varcheck + $n_width*$usenumn]        


    # Clock Rest Source
    add_instance clk_rst clock_source
    set_instance_parameter clk_rst resetSynchronousEdges DEASSERT
    set_instance_parameter clk_rst clockFrequencyKnown "false"

    # suppress this warning:
    # Warning: rs.clk_rst: The input clock frequency must be known or set by the parent if this is a subsystem.
    set_instance_property clk_rst SUPPRESS_ALL_WARNINGS true

    # Clock
    add_interface clk clock end
    set_interface_property clk export_of clk_rst.clk_in
    # Reset
    add_interface rst reset end
    set_interface_property rst export_of clk_rst.clk_in_reset


    # Convertion to transaction
    add_instance dec_conv altera_rs_ser_transaction_converter
    set_instance_parameter dec_conv BITSPERSYMBOL $bitspersymbol
    set_instance_parameter dec_conv CHECK $check
    set_instance_parameter dec_conv CHANNEL $channel
    set_instance_parameter dec_conv N $n
    set_instance_parameter dec_conv ERASURE $erasure
    set_instance_parameter dec_conv USENUMN  $usenumn
    set_instance_parameter dec_conv VARCHECK  $varcheck
    set_instance_parameter dec_conv design_env  [get_parameter_value design_env]

    # Data Format Adapter
    add_instance dec_dfa_in data_format_adapter
    set_instance_parameter dec_dfa_in inUsePackets "true"
    set_instance_parameter dec_dfa_in inBitsPerSymbol $in_datas_width
    set_instance_parameter dec_dfa_in inUseEmpty "false"
    set_instance_parameter dec_dfa_in inChannelWidth $channel_width
    set_instance_parameter dec_dfa_in inMaxChannel $max_channel
    set_instance_parameter dec_dfa_in inErrorWidth $erasure
    set_instance_parameter dec_dfa_in outUseEmpty "true"
    set_instance_parameter dec_dfa_in outUseEmptyPort "YES"

    # Avalon ST Splitter
    add_instance dec_st_splitter altera_avalon_st_splitter
    set_instance_parameter dec_st_splitter NUMBER_OF_OUTPUTS "2"
    set_instance_parameter dec_st_splitter QUALIFY_VALID_OUT "1"
    set_instance_parameter dec_st_splitter USE_READY "1"
    set_instance_parameter dec_st_splitter USE_VALID "1"
    set_instance_parameter dec_st_splitter USE_PACKETS "1"
    set_instance_parameter dec_st_splitter USE_CHANNEL $use_channel
    set_instance_parameter dec_st_splitter USE_ERROR $erasure
    set_instance_parameter dec_st_splitter USE_DATA "1"
    set_instance_parameter dec_st_splitter DATA_WIDTH $in_datas_width
    set_instance_parameter dec_st_splitter CHANNEL_WIDTH $splitter_channel_width
    set_instance_parameter dec_st_splitter BITS_PER_SYMBOL $in_datas_width
    set_instance_parameter dec_st_splitter MAX_CHANNELS $max_channel
    set_instance_parameter dec_st_splitter READY_LATENCY "0"
    set_instance_parameter dec_st_splitter ERROR_DESCRIPTOR "0"
    set_instance_parameter dec_st_splitter ERROR_WIDTH "1"   
  
    # Data Format Adapter
    add_instance dec_dfa0 data_format_adapter
    set_instance_parameter dec_dfa0 inUsePackets "true"
    set_instance_parameter dec_dfa0 inBitsPerSymbol $in_datas_width
    set_instance_parameter dec_dfa0 inUseEmpty "true"
    set_instance_parameter dec_dfa0 inChannelWidth $channel_width
    set_instance_parameter dec_dfa0 inMaxChannel $max_channel
    set_instance_parameter dec_dfa0 inErrorWidth $erasure
    set_instance_parameter dec_dfa0 outUseEmpty "false"
    set_instance_parameter dec_dfa0 outUseEmptyPort "NO"

    
    # Data Format Adapter
    add_instance dec_dfa1 data_format_adapter
    set_instance_parameter dec_dfa1 inUsePackets "true"
    set_instance_parameter dec_dfa1 inBitsPerSymbol $in_datas_width
    set_instance_parameter dec_dfa1 inUseEmpty "true"
    set_instance_parameter dec_dfa1 inChannelWidth $channel_width
    set_instance_parameter dec_dfa1 inMaxChannel $max_channel
    set_instance_parameter dec_dfa1 inErrorWidth $erasure
    set_instance_parameter dec_dfa1 outUseEmpty "false"
    set_instance_parameter dec_dfa1 outUseEmptyPort "NO"

    # Transaction format component
    add_instance dec_adapt altera_rs_ser_transaction_format_adapter
    set_instance_parameter dec_adapt inBitsPerSymbol $in_datas_width
    set_instance_parameter dec_adapt outBitsPerSymbol $bitspersymbol
    set_instance_parameter dec_adapt UseinError $erasure
    set_instance_parameter dec_adapt UseoutError "0"
    set_instance_parameter dec_adapt ChannelWidth $channel_width
    set_instance_parameter dec_adapt MaxChannel $max_channel    
    
    
    # Avalon ST SC Fifo
    add_instance dec_sc_fifo altera_avalon_sc_fifo
    set_instance_parameter dec_sc_fifo BITS_PER_SYMBOL $bitspersymbol
    set_instance_parameter dec_sc_fifo SYMBOLS_PER_BEAT "1"
    set_instance_parameter dec_sc_fifo FIFO_DEPTH $depth
    set_instance_parameter dec_sc_fifo USE_PACKETS "1"
    set_instance_parameter dec_sc_fifo CHANNEL_WIDTH $channel_width
    set_instance_parameter dec_sc_fifo USE_FILL_LEVEL "0"
    set_instance_parameter dec_sc_fifo USE_STORE_FORWARD "0"
    set_instance_parameter dec_sc_fifo ERROR_WIDTH "0"
    set_instance_parameter dec_sc_fifo ENABLE_EXPLICIT_MAXCHANNEL "true"
    set_instance_parameter dec_sc_fifo EXPLICIT_MAXCHANNEL $max_channel

    # Syndrome Generator
    add_instance dec_syn altera_rs_ser_syn
    set_instance_parameter dec_syn BITSPERSYMBOL $bitspersymbol
    set_instance_parameter dec_syn CHECK $check
    set_instance_parameter dec_syn CHANNEL $channel
    set_instance_parameter dec_syn IRRPOL $irrpol
    set_instance_parameter dec_syn GENSTART $genstart
    set_instance_parameter dec_syn ROOTSPACE $rootspace
    set_instance_parameter dec_syn N $n
    set_instance_parameter dec_syn MIN_N $min_n
    set_instance_parameter dec_syn ERASURE $erasure
    set_instance_parameter dec_syn VARN  $varn
    set_instance_parameter dec_syn USENUMN  $usenumn
    set_instance_parameter dec_syn VARCHECK  $varcheck
    set_instance_parameter dec_syn USEDUALBASIS $use_dual_basis
    set_instance_parameter dec_syn DUALBASISOF $dual_basis_of
    
    # Polynomial Generator (Berlekamp-Messay)
    add_instance dec_bm altera_rs_ser_bm
    set_instance_parameter dec_bm BITSPERSYMBOL $bitspersymbol
    set_instance_parameter dec_bm CHECK $check
    set_instance_parameter dec_bm IRRPOL $irrpol
    set_instance_parameter dec_bm GENSTART $genstart
    set_instance_parameter dec_bm ROOTSPACE $rootspace
    set_instance_parameter dec_bm CHANNEL $channel
    set_instance_parameter dec_bm ERASURE $erasure
    set_instance_parameter dec_bm VARN  $varn
    set_instance_parameter dec_bm VARCHECK  $varcheck
    set_instance_parameter dec_bm N $n
    set_instance_parameter dec_bm MIN_N $min_n
    set_instance_parameter dec_bm OPTIMIZE_LATENCY $optimizelatency
    set_instance_parameter dec_bm USEROM $userom
    set_instance_parameter dec_bm BMFIXEDLATENCY $bmfixedlatency

    # Search
    add_instance dec_search altera_rs_ser_search
    set_instance_parameter dec_search BITSPERSYMBOL $bitspersymbol
    set_instance_parameter dec_search CHECK $check
    set_instance_parameter dec_search CHANNEL $channel    
    set_instance_parameter dec_search IRRPOL $irrpol
    set_instance_parameter dec_search GENSTART $genstart
    set_instance_parameter dec_search ROOTSPACE $rootspace
    set_instance_parameter dec_search N $n
    set_instance_parameter dec_search ERASURE $erasure
    set_instance_parameter dec_search VARN  $varn
    set_instance_parameter dec_search OPTIMIZE_LATENCY $optimizelatency
    set_instance_parameter dec_search USEDUALBASIS $use_dual_basis
    set_instance_parameter dec_search DUALBASISOF $dual_basis_of
    
    # Corrector
    add_instance dec_correct altera_rs_ser_correct
    set_instance_parameter dec_correct design_env [get_parameter_value design_env]
    set_instance_parameter dec_correct BITSPERSYMBOL $bitspersymbol
    set_instance_parameter dec_correct CHANNEL $channel
    set_instance_parameter dec_correct CHECK $check
    set_instance_parameter dec_correct ERASURE $erasure
    set_instance_parameter dec_correct ERRORSYMB $errorsymbol
    set_instance_parameter dec_correct ERRORSYMBCOUNT $errorsymbcount
    set_instance_parameter dec_correct ERRORBITCOUNT $errorbitcount
    set_instance_parameter dec_correct BITCOUNTTYPE $bitcounttype
    # Export

    # Export In
    #add_interface in avalon_streaming end
    #set_interface_property in export_of dec_dfa_in.in
    dsp_add_streaming_interface in sink 
    set_interface_property in export_of dec_conv.in    

    # Export Out
    #add_interface out avalon_streaming start
    dsp_add_streaming_interface out source
    set_interface_property out export_of dec_correct.cw_out
    


    # Add connection
    add_connection clk_rst.clk/dec_conv.clk
    add_connection clk_rst.clk/dec_dfa_in.clk
    add_connection clk_rst.clk/dec_st_splitter.clk
    add_connection clk_rst.clk/dec_dfa0.clk
    add_connection clk_rst.clk/dec_dfa1.clk
    add_connection clk_rst.clk/dec_adapt.clk
    add_connection clk_rst.clk/dec_sc_fifo.clk
    add_connection clk_rst.clk/dec_syn.clk
    add_connection clk_rst.clk/dec_bm.clk
    add_connection clk_rst.clk/dec_search.clk
    add_connection clk_rst.clk/dec_correct.clk

    add_connection clk_rst.clk_reset/dec_conv.rst
    add_connection clk_rst.clk_reset/dec_dfa_in.reset
    add_connection clk_rst.clk_reset/dec_st_splitter.reset
    add_connection clk_rst.clk_reset/dec_dfa0.reset
    add_connection clk_rst.clk_reset/dec_dfa1.reset
    add_connection clk_rst.clk_reset/dec_adapt.rst
    add_connection clk_rst.clk_reset/dec_sc_fifo.clk_reset
    add_connection clk_rst.clk_reset/dec_syn.rst
    add_connection clk_rst.clk_reset/dec_bm.rst
    add_connection clk_rst.clk_reset/dec_search.rst
    add_connection clk_rst.clk_reset/dec_correct.rst

    add_connection dec_conv.out/dec_dfa_in.in
    add_connection dec_dfa_in.out/dec_st_splitter.in
    add_connection dec_st_splitter.out0/dec_dfa0.in
    add_connection dec_st_splitter.out1/dec_dfa1.in
    add_connection dec_dfa0.out/dec_adapt.cw_in
    add_connection dec_adapt.cw_out/dec_sc_fifo.in
    add_connection dec_dfa1.out/dec_syn.cw_in
    add_connection dec_syn.syn_out/dec_bm.syn_in
    add_connection dec_bm.bm_out/dec_search.bm_in
    add_connection dec_search.sch_out/dec_correct.sch_in
    add_connection dec_sc_fifo.out/dec_correct.cw_in

}

