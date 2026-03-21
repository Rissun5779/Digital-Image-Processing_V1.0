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


package require -exact qsys 13.0
# | 
# +-----------------------------------

# +-----------------------------------
# | 
set_module_property DESCRIPTION " A bridge to be placed in front of the master to align the address based on ratio of data-widths between the master and slaves connected to it"
set_module_property NAME altera_avalon_mm_unaligned_burst_expansion_bridge
set_module_property VERSION 18.1
set_module_property GROUP "Basic Functions/Bridges and Adaptors/Memory Mapped"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Avalon-MM Unaligned Burst Expansion Bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property HIDE_FROM_QUARTUS true
set_module_property ELABORATION_CALLBACK elaborate
# | 
# +-----------------------------------

# +-----------------------------------
# | Define fileset
# | 
add_fileset sim_verilog SIM_VERILOG quartus_synth_proc
set_fileset_property sim_verilog top_level altera_avalon_mm_unaligned_burst_expansion_bridge

add_fileset quartus_synth QUARTUS_SYNTH quartus_synth_proc
set_fileset_property quartus_synth top_level altera_avalon_mm_unaligned_burst_expansion_bridge

proc quartus_synth_proc {altera_avalon_mm_unaligned_burst_expansion_bridge} {
    add_fileset_file altera_avalon_mm_unaligned_burst_expansion_bridge.sv SYSTEM_VERILOG PATH "./altera_avalon_mm_unaligned_burst_expansion_bridge.sv" 
    add_fileset_file altera_avalon_sc_fifo.v VERILOG PATH $::env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/altera_avalon_sc_fifo/altera_avalon_sc_fifo.v
}

# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 

add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME {Data width}
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH DISPLAY_HINT ""
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true
set_parameter_property DATA_WIDTH ALLOWED_RANGES {8,16,32,64,128,256,512,1024,2048}
set_parameter_property DATA_WIDTH DESCRIPTION {Bridge data width}


add_parameter ADDRESS_WIDTH INTEGER 29
set_parameter_property ADDRESS_WIDTH DEFAULT_VALUE 29
set_parameter_property ADDRESS_WIDTH DISPLAY_NAME {Address width (in WORDS)}
set_parameter_property ADDRESS_WIDTH TYPE INTEGER
set_parameter_property ADDRESS_WIDTH UNITS None
set_parameter_property ADDRESS_WIDTH DISPLAY_HINT ""
set_parameter_property ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property ADDRESS_WIDTH ALLOWED_RANGES {1:64}
set_parameter_property ADDRESS_WIDTH DESCRIPTION {Bridge address width}

add_parameter BURSTCOUNT_WIDTH INTEGER 7
set_parameter_property BURSTCOUNT_WIDTH DEFAULT_VALUE 7
set_parameter_property BURSTCOUNT_WIDTH DISPLAY_NAME {Burstcount width}
set_parameter_property BURSTCOUNT_WIDTH TYPE INTEGER
set_parameter_property BURSTCOUNT_WIDTH UNITS None
set_parameter_property BURSTCOUNT_WIDTH DISPLAY_HINT ""
set_parameter_property BURSTCOUNT_WIDTH AFFECTS_GENERATION false
set_parameter_property BURSTCOUNT_WIDTH HDL_PARAMETER true
set_parameter_property BURSTCOUNT_WIDTH ALLOWED_RANGES {1:11}
set_parameter_property BURSTCOUNT_WIDTH DESCRIPTION {Bridge burstcount width}

add_parameter MAX_PENDING_RESPONSES INTEGER 8
set_parameter_property MAX_PENDING_RESPONSES DEFAULT_VALUE 8
set_parameter_property MAX_PENDING_RESPONSES DISPLAY_NAME {Maximum pending read transactions}
set_parameter_property MAX_PENDING_RESPONSES TYPE INTEGER
set_parameter_property MAX_PENDING_RESPONSES UNITS None
set_parameter_property MAX_PENDING_RESPONSES DISPLAY_HINT ""
set_parameter_property MAX_PENDING_RESPONSES AFFECTS_GENERATION false
set_parameter_property MAX_PENDING_RESPONSES HDL_PARAMETER true
set_parameter_property MAX_PENDING_RESPONSES ALLOWED_RANGES {1:64}
set_parameter_property MAX_PENDING_RESPONSES DESCRIPTION {Controls the Avalon-MM maximum pending read transactions interface property of the bridge}

add_parameter SLAVE_DATA_WIDTH INTEGER 64
set_parameter_property SLAVE_DATA_WIDTH DEFAULT_VALUE 64
set_parameter_property SLAVE_DATA_WIDTH DISPLAY_NAME "Width of slave to optimize for"
set_parameter_property SLAVE_DATA_WIDTH DESCRIPTION {This is the data-width of the connected slave. NOTE: if connecting multiple slaves, all slaves must have the same data width}
set_parameter_property SLAVE_DATA_WIDTH TYPE INTEGER
set_parameter_property SLAVE_DATA_WIDTH UNITS None
set_parameter_property SLAVE_DATA_WIDTH DISPLAY_HINT ""
set_parameter_property SLAVE_DATA_WIDTH ALLOWED_RANGES {16,32,64,128,256,512,1024,2048,4096}
set_parameter_property SLAVE_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property SLAVE_DATA_WIDTH HDL_PARAMETER false

add_parameter RATIO INTEGER 2
set_parameter_property RATIO AFFECTS_GENERATION false
set_parameter_property RATIO HDL_PARAMETER true
set_parameter_property RATIO VISIBLE false
set_parameter_property RATIO DERIVED true

add_parameter PIPELINE_COMMAND INTEGER 1
set_parameter_property PIPELINE_COMMAND DEFAULT_VALUE 1
set_parameter_property PIPELINE_COMMAND DISPLAY_NAME "Pipeline command signals"
set_parameter_property PIPELINE_COMMAND DESCRIPTION {When enabled, the command path is pipelined, minimizing the bridge’s critical path at the expense of increased logic usage and latency}
set_parameter_property PIPELINE_COMMAND TYPE INTEGER
set_parameter_property PIPELINE_COMMAND UNITS None
set_parameter_property PIPELINE_COMMAND DISPLAY_HINT "boolean"
set_parameter_property PIPELINE_COMMAND AFFECTS_GENERATION false
set_parameter_property PIPELINE_COMMAND HDL_PARAMETER true

proc elaborate { } {
    set bridge_data_width   [ get_parameter_value DATA_WIDTH ]
    set slave_data_width    [ get_parameter_value SLAVE_DATA_WIDTH ]
    set sym_width           8
    set byteen_width        [ expr $bridge_data_width / $sym_width ]
    set mprt                [ get_parameter_value MAX_PENDING_RESPONSES ]
    set in_burstcount_width [ get_parameter_value BURSTCOUNT_WIDTH ]
    set ratio               [ expr $slave_data_width / $bridge_data_width ]
    set address_width       [ get_parameter_value ADDRESS_WIDTH ]
        
    if {2**($in_burstcount_width - 1) > $ratio} {
        set out_burstcount_width [expr $in_burstcount_width+1 ]
    } else {
        set out_burstcount_width_before_convert_to_int [ expr [ expr {log(2*$ratio)/log(2)} ] +1 ]
        set out_burstcount_width [ expr int([ expr {log(2*$ratio)/log(2)} ] +1) ]
        if {$out_burstcount_width_before_convert_to_int > $out_burstcount_width} {
            set out_burstcount_width [expr $out_burstcount_width+1 ]
        }
    }
    
    set log2_ratio_before_convert_to_int [expr {log($ratio)/log(2)} ]    
    set log2_ratio [ expr int([expr {log($ratio)/log(2)} ]) ] 
    if {$log2_ratio_before_convert_to_int > $log2_ratio} {
        set log2_ratio [expr $log2_ratio+1 ]
    }
    set expected_address_width [ expr $log2_ratio + 1 ]
    if { $log2_ratio > $address_width - 1 } {
        send_message error "ADDRESS_WIDTH must at least set to $expected_address_width if the Width of slave to optimize for is $slave_data_width"
    }
    
    if { $bridge_data_width >= $slave_data_width } {
        send_message error "This bridge is not required if the the Width of slave to optimize for is equal to or less than Bridge Data Width"
    } else {
        set_parameter_value RATIO $ratio
    }
        

    # | 
    # +-----------------------------------
    
    # +-----------------------------------
    # | connection point clk
    # | 
    add_interface clk clock end
    add_interface reset reset end
    
    set_interface_property clk ENABLED true
    set_interface_property reset ENABLED true
    set_interface_property reset ASSOCIATED_CLOCK clk
    
    add_interface_port clk clk clk Input 1
    add_interface_port reset reset reset Input 1
    # | 
    # +-----------------------------------
    
    # +-----------------------------------
    # | connection point s0
    # | 
    add_interface s0 avalon end
    set_interface_property s0 addressAlignment DYNAMIC
    set_interface_property s0 associatedClock clk
    set_interface_property s0 bridgesToMaster m0
    set_interface_property s0 burstOnBurstBoundariesOnly false
    set_interface_property s0 explicitAddressSpan 0
    set_interface_property s0 holdTime 0
    set_interface_property s0 isMemoryDevice false
    set_interface_property s0 isNonVolatileStorage false
    set_interface_property s0 linewrapBursts false
    set_interface_property s0 maximumPendingReadTransactions $mprt
    set_interface_property s0 printableDevice false
    set_interface_property s0 readLatency 0
    set_interface_property s0 readWaitTime 0
    set_interface_property s0 setupTime 0
    set_interface_property s0 timingUnits Cycles
    set_interface_property s0 writeWaitTime 0
    set_interface_property s0 addressUnits "WORDS"
    set_interface_property s0 bitsPerSymbol 8
        
    set_interface_property s0 ASSOCIATED_CLOCK clk
    set_interface_property s0 associatedReset reset
    set_interface_property s0 ENABLED true
    
    add_interface_port s0 s0_waitrequest waitrequest Output 1
    add_interface_port s0 s0_readdata readdata Output $bridge_data_width
    add_interface_port s0 s0_readdatavalid readdatavalid Output 1
    add_interface_port s0 s0_burstcount burstcount Input $in_burstcount_width
    add_interface_port s0 s0_writedata writedata Input $bridge_data_width
    add_interface_port s0 s0_address address Input $address_width
    add_interface_port s0 s0_write write Input 1
    add_interface_port s0 s0_read read Input 1
    add_interface_port s0 s0_debugaccess debugaccess Input 1
    add_interface_port s0 s0_byteenable byteenable Input $byteen_width
    
    # | 
    # +-----------------------------------
    
    # +-----------------------------------
    # | connection point m0
    # | 
    add_interface m0 avalon start
    set_interface_property m0 associatedClock clk
    set_interface_property m0 burstOnBurstBoundariesOnly false
    set_interface_property m0 doStreamReads false
    set_interface_property m0 doStreamWrites false
    set_interface_property m0 linewrapBursts false
    set_interface_property m0 addressUnits "WORDS"
    set_interface_property m0 bitsPerSymbol 8
    
    set_interface_property m0 ASSOCIATED_CLOCK clk
    set_interface_property m0 associatedReset reset
    set_interface_property m0 ENABLED true
    
    add_interface_port m0 m0_waitrequest waitrequest Input 1
    add_interface_port m0 m0_readdata readdata Input $bridge_data_width
    add_interface_port m0 m0_readdatavalid readdatavalid Input 1
    add_interface_port m0 m0_burstcount burstcount Output $out_burstcount_width
    add_interface_port m0 m0_writedata writedata Output $bridge_data_width
    add_interface_port m0 m0_address address Output $address_width
    add_interface_port m0 m0_write write Output 1
    add_interface_port m0 m0_read read Output 1
    add_interface_port m0 m0_debugaccess debugaccess Output 1
    add_interface_port m0 m0_byteenable byteenable Output $byteen_width
    
    # | 
    # +-----------------------------------

}

 


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409959280085
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1416836145555/hco1416836653221
