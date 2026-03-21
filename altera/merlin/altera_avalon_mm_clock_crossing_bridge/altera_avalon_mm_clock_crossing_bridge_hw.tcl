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


# +-----------------------------------
# | 
# | altera_avalon_mm_clock_crossing_bridge "Avalon-MM Clock Crossing Bridge"
# | 
# +-----------------------------------

# +-----------------------------------
# | 
package require -exact qsys 16.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module altera_avalon_mm_clock_crossing_bridge
# | 
set_module_property NAME altera_avalon_mm_clock_crossing_bridge
set_module_property VERSION 18.1
set_module_property HIDE_FROM_SOPC true
set_module_property GROUP "Basic Functions/Bridges and Adaptors/Memory Mapped"
set_module_property DISPLAY_NAME "Avalon-MM Clock Crossing Bridge"
set_module_property DESCRIPTION "Transfers Avalon-MM commands and responses between asynchronous clock domains using asynchronous FIFOs to implement the clock crossing logic."
set_module_property AUTHOR "Altera Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QUARTUS true
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_fileset          synth   QUARTUS_SYNTH {generate synth}
set_fileset_property synth   TOP_LEVEL altera_avalon_mm_clock_crossing_bridge

add_fileset          sim     SIM_VERILOG   {generate sim}
set_fileset_property sim     TOP_LEVEL altera_avalon_mm_clock_crossing_bridge

add_fileset          simvhdl SIM_VHDL      {generate sim}
set_fileset_property simvhdl TOP_LEVEL altera_avalon_mm_clock_crossing_bridge

proc generate {intent output_name} {
    add_fileset_file altera_avalon_mm_clock_crossing_bridge.v VERILOG PATH altera_avalon_mm_clock_crossing_bridge.v
    set path [file join .. .. sopc_builder_ip altera_avalon_dc_fifo altera_avalon_dc_fifo.v]
    add_fileset_file altera_avalon_dc_fifo.v VERILOG PATH $path
    set path [file join .. .. sopc_builder_ip altera_avalon_dc_fifo altera_dcfifo_synchronizer_bundle.v]
    add_fileset_file altera_dcfifo_synchronizer_bundle.v VERILOG PATH $path
    set path [file join .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $path
    if {$intent eq "synth"} {
	set path [file join .. .. sopc_builder_ip altera_avalon_dc_fifo altera_avalon_dc_fifo.sdc]
	add_fileset_file altera_avalon_dc_fifo.sdc SDC PATH $path
    }
}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data width"
set_parameter_property DATA_WIDTH DESCRIPTION {Bridge data width}
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_parameter SYMBOL_WIDTH INTEGER 8
set_parameter_property SYMBOL_WIDTH DEFAULT_VALUE 8
set_parameter_property SYMBOL_WIDTH DISPLAY_NAME "Symbol width"
set_parameter_property SYMBOL_WIDTH DESCRIPTION {Symbol (byte) width}
set_parameter_property SYMBOL_WIDTH TYPE INTEGER
set_parameter_property SYMBOL_WIDTH UNITS None
set_parameter_property SYMBOL_WIDTH AFFECTS_GENERATION false
set_parameter_property SYMBOL_WIDTH HDL_PARAMETER true

add_parameter ADDRESS_WIDTH INTEGER 10
set_parameter_property ADDRESS_WIDTH DEFAULT_VALUE 10
set_parameter_property ADDRESS_WIDTH DISPLAY_NAME "Address width"
set_parameter_property ADDRESS_WIDTH DESCRIPTION {User-defined bridge address width}
set_parameter_property ADDRESS_WIDTH TYPE INTEGER
set_parameter_property ADDRESS_WIDTH UNITS None
set_parameter_property ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDRESS_WIDTH HDL_PARAMETER false

# ------------------------------------------
# System info address width, so that we can automatically determine how
# wide the bridge's width needs to be. Note that this is in units of
# bytes.
# ------------------------------------------
add_parameter SYSINFO_ADDR_WIDTH INTEGER 10
set_parameter_property SYSINFO_ADDR_WIDTH SYSTEM_INFO { ADDRESS_WIDTH m0 }
set_parameter_property SYSINFO_ADDR_WIDTH TYPE INTEGER
set_parameter_property SYSINFO_ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property SYSINFO_ADDR_WIDTH HDL_PARAMETER false
set_parameter_property SYSINFO_ADDR_WIDTH VISIBLE false

add_parameter USE_AUTO_ADDRESS_WIDTH INTEGER 0
set_parameter_property USE_AUTO_ADDRESS_WIDTH DEFAULT_VALUE 0
set_parameter_property USE_AUTO_ADDRESS_WIDTH DISPLAY_NAME {Use automatically-determined address width}
set_parameter_property USE_AUTO_ADDRESS_WIDTH TYPE INTEGER
set_parameter_property USE_AUTO_ADDRESS_WIDTH UNITS None
set_parameter_property USE_AUTO_ADDRESS_WIDTH DISPLAY_HINT "boolean"
set_parameter_property USE_AUTO_ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property USE_AUTO_ADDRESS_WIDTH HDL_PARAMETER false
set_parameter_property USE_AUTO_ADDRESS_WIDTH DESCRIPTION {Use automatically-determined bridge address width instead of the user-defined address width}

# ------------------------------------------
# The actual automatic address width of the bridge. Different from the system info,
# because this takes the address units into account.
# ------------------------------------------
add_parameter AUTO_ADDRESS_WIDTH INTEGER 10
set_parameter_property AUTO_ADDRESS_WIDTH DEFAULT_VALUE 10
set_parameter_property AUTO_ADDRESS_WIDTH DISPLAY_NAME {Automatically-determined address width}
set_parameter_property AUTO_ADDRESS_WIDTH TYPE INTEGER
set_parameter_property AUTO_ADDRESS_WIDTH UNITS None
set_parameter_property AUTO_ADDRESS_WIDTH DISPLAY_HINT ""
set_parameter_property AUTO_ADDRESS_WIDTH DERIVED true
set_parameter_property AUTO_ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property AUTO_ADDRESS_WIDTH HDL_PARAMETER false
set_parameter_property AUTO_ADDRESS_WIDTH DESCRIPTION {The minimum bridge address width that is required to address the downstream slaves}

# ------------------------------------------
# The actual value that gets passed to the HDL
# ------------------------------------------
add_parameter HDL_ADDR_WIDTH INTEGER 10
set_parameter_property HDL_ADDR_WIDTH TYPE INTEGER
set_parameter_property HDL_ADDR_WIDTH DERIVED true
set_parameter_property HDL_ADDR_WIDTH VISIBLE false
set_parameter_property HDL_ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property HDL_ADDR_WIDTH HDL_PARAMETER true

add_parameter ADDRESS_UNITS STRING "SYMBOLS"
set_parameter_property ADDRESS_UNITS DEFAULT_VALUE "SYMBOLS"
set_parameter_property ADDRESS_UNITS DISPLAY_NAME "Address units"
set_parameter_property ADDRESS_UNITS DESCRIPTION {Address units (Symbols[bytes]/Words)}
set_parameter_property ADDRESS_UNITS TYPE STRING
set_parameter_property ADDRESS_UNITS UNITS None
set_parameter_property ADDRESS_UNITS AFFECTS_GENERATION false
set_parameter_property ADDRESS_UNITS HDL_PARAMETER false
set_parameter_property ADDRESS_UNITS ALLOWED_RANGES "SYMBOLS,WORDS"

add_parameter BURSTCOUNT_WIDTH INTEGER 1
set_parameter_property BURSTCOUNT_WIDTH DEFAULT_VALUE 1
set_parameter_property BURSTCOUNT_WIDTH DISPLAY_NAME "Burstcount width"
set_parameter_property BURSTCOUNT_WIDTH DESCRIPTION {Burstcount width}
set_parameter_property BURSTCOUNT_WIDTH TYPE INTEGER
set_parameter_property BURSTCOUNT_WIDTH UNITS None
set_parameter_property BURSTCOUNT_WIDTH AFFECTS_GENERATION false
set_parameter_property BURSTCOUNT_WIDTH HDL_PARAMETER true
set_parameter_property BURSTCOUNT_WIDTH DERIVED true
set_parameter_property BURSTCOUNT_WIDTH VISIBLE false

add_parameter MAX_BURST_SIZE INTEGER 1
set_parameter_property MAX_BURST_SIZE DISPLAY_NAME "Maximum burst size (words)"
set_parameter_property MAX_BURST_SIZE AFFECTS_GENERATION true
set_parameter_property MAX_BURST_SIZE HDL_PARAMETER false
set_parameter_property MAX_BURST_SIZE DESCRIPTION {Specifies the maximum burst size}
set_parameter_property MAX_BURST_SIZE ALLOWED_RANGES "1,2,4,8,16,32,64,128,256,512,1024"

add_parameter COMMAND_FIFO_DEPTH INTEGER 4
set_parameter_property COMMAND_FIFO_DEPTH DEFAULT_VALUE 4
set_parameter_property COMMAND_FIFO_DEPTH DISPLAY_NAME "Command FIFO depth"
set_parameter_property COMMAND_FIFO_DEPTH DESCRIPTION {Command (master-to-slave) FIFO depth}
set_parameter_property COMMAND_FIFO_DEPTH TYPE INTEGER
set_parameter_property COMMAND_FIFO_DEPTH UNITS None
set_parameter_property COMMAND_FIFO_DEPTH AFFECTS_GENERATION false
set_parameter_property COMMAND_FIFO_DEPTH HDL_PARAMETER true
set_parameter_property COMMAND_FIFO_DEPTH ALLOWED_RANGES "2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384"

add_parameter RESPONSE_FIFO_DEPTH INTEGER 4
set_parameter_property RESPONSE_FIFO_DEPTH DEFAULT_VALUE 4
set_parameter_property RESPONSE_FIFO_DEPTH DISPLAY_NAME "Response FIFO depth"
set_parameter_property RESPONSE_FIFO_DEPTH DESCRIPTION {Response (slave-to-master) FIFO depth}
set_parameter_property RESPONSE_FIFO_DEPTH TYPE INTEGER
set_parameter_property RESPONSE_FIFO_DEPTH UNITS None
set_parameter_property RESPONSE_FIFO_DEPTH AFFECTS_GENERATION false
set_parameter_property RESPONSE_FIFO_DEPTH HDL_PARAMETER true
set_parameter_property RESPONSE_FIFO_DEPTH ALLOWED_RANGES "2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384"

add_parameter MASTER_SYNC_DEPTH INTEGER 2
set_parameter_property MASTER_SYNC_DEPTH DEFAULT_VALUE 2
set_parameter_property MASTER_SYNC_DEPTH DISPLAY_NAME "Master clock domain synchronizer depth"
set_parameter_property MASTER_SYNC_DEPTH DESCRIPTION {Specifies the number of pipeline stages used to avoid metastable events}
set_parameter_property MASTER_SYNC_DEPTH TYPE INTEGER
set_parameter_property MASTER_SYNC_DEPTH UNITS None
set_parameter_property MASTER_SYNC_DEPTH AFFECTS_GENERATION false
set_parameter_property MASTER_SYNC_DEPTH HDL_PARAMETER true
add_parameter SLAVE_SYNC_DEPTH INTEGER 2
set_parameter_property SLAVE_SYNC_DEPTH DEFAULT_VALUE 2
set_parameter_property SLAVE_SYNC_DEPTH DISPLAY_NAME "Slave clock domain synchronizer depth"
set_parameter_property SLAVE_SYNC_DEPTH DESCRIPTION {Specifies the number of pipeline stages used to avoid metastable events}
set_parameter_property SLAVE_SYNC_DEPTH TYPE INTEGER
set_parameter_property SLAVE_SYNC_DEPTH UNITS None
set_parameter_property SLAVE_SYNC_DEPTH AFFECTS_GENERATION false
set_parameter_property SLAVE_SYNC_DEPTH HDL_PARAMETER true
# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 

add_display_item "Data" DATA_WIDTH parameter
add_display_item "Data" SYMBOL_WIDTH parameter

add_display_item "Address" ADDRESS_WIDTH parameter
add_display_item "Address" USE_AUTO_ADDRESS_WIDTH parameter
add_display_item "Address" AUTO_ADDRESS_WIDTH parameter
add_display_item "Address" ADDRESS_UNITS parameter

add_display_item "Burst" MAX_BURST_SIZE parameter

add_display_item "FIFOs" COMMAND_FIFO_DEPTH parameter
add_display_item "FIFOs" RESPONSE_FIFO_DEPTH parameter
add_display_item "FIFOs" MASTER_SYNC_DEPTH parameter
add_display_item "FIFOs" SLAVE_SYNC_DEPTH parameter
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point m0_clk
# | 
add_interface m0_clk clock end
add_interface m0_reset reset end

set_interface_property m0_clk ENABLED true
set_interface_property m0_reset ASSOCIATED_CLOCK "m0_clk"

add_interface_port m0_clk m0_clk clk Input 1
add_interface_port m0_reset m0_reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point s0_clk
# | 
add_interface s0_clk clock end
add_interface s0_reset reset end

set_interface_property s0_clk ENABLED true
set_interface_property s0_reset ASSOCIATED_CLOCK "s0_clk"

add_interface_port s0_clk s0_clk clk Input 1
add_interface_port s0_reset s0_reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point s0
# | 
add_interface s0 avalon end
set_interface_property s0 addressAlignment DYNAMIC
set_interface_property s0 bridgesToMaster m0
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 explicitAddressSpan 0
set_interface_property s0 holdTime 0
set_interface_property s0 isMemoryDevice false
set_interface_property s0 isNonVolatileStorage false
set_interface_property s0 linewrapBursts false
set_interface_property s0 maximumPendingReadTransactions 1
set_interface_property s0 printableDevice false
set_interface_property s0 readLatency 0
set_interface_property s0 readWaitTime 0
set_interface_property s0 setupTime 0
set_interface_property s0 timingUnits Cycles
set_interface_property s0 writeWaitTime 0

set_interface_property s0 ASSOCIATED_CLOCK "s0_clk"
set_interface_property s0 associatedReset "s0_reset"
set_interface_property s0 ENABLED true

add_interface_port s0 s0_waitrequest waitrequest Output 1
add_interface_port s0 s0_readdata readdata Output DATA_WIDTH
set_port_property s0_readdata VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port s0 s0_readdatavalid readdatavalid Output 1
add_interface_port s0 s0_burstcount burstcount Input BURSTCOUNT_WIDTH
set_port_property s0_burstcount VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port s0 s0_writedata writedata Input DATA_WIDTH
set_port_property s0_writedata VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port s0 s0_address address Input HDL_ADDR_WIDTH
set_port_property s0_address VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port s0 s0_write write Input 1
add_interface_port s0 s0_read read Input 1
add_interface_port s0 s0_byteenable byteenable Input 4
set_port_property s0_byteenable VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port s0 s0_debugaccess debugaccess Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point m0
# | 
add_interface m0 avalon start
set_interface_property m0 burstOnBurstBoundariesOnly false
set_interface_property m0 doStreamReads false
set_interface_property m0 doStreamWrites false
set_interface_property m0 linewrapBursts false

set_interface_property m0 ASSOCIATED_CLOCK "m0_clk"
set_interface_property m0 associatedReset "m0_reset"
set_interface_property m0 ENABLED true

add_interface_port m0 m0_waitrequest waitrequest Input 1
add_interface_port m0 m0_readdata readdata Input DATA_WIDTH
set_port_property m0_readdata VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port m0 m0_readdatavalid readdatavalid Input 1
add_interface_port m0 m0_burstcount burstcount Output BURSTCOUNT_WIDTH
set_port_property m0_burstcount VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port m0 m0_writedata writedata Output DATA_WIDTH
set_port_property m0_writedata VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port m0 m0_address address Output HDL_ADDR_WIDTH
set_port_property m0_address VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port m0 m0_write write Output 1
add_interface_port m0 m0_read read Output 1
add_interface_port m0 m0_byteenable byteenable Output 4
set_port_property m0_byteenable VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port m0 m0_debugaccess debugaccess Output 1
# | 
# +-----------------------------------

proc elaborate { } {
    set data_width      [ get_parameter_value DATA_WIDTH ]
    set sym_width       [ get_parameter_value SYMBOL_WIDTH ]
    set byteen_width    [ expr {$data_width / $sym_width} ]
    set addr_width      [ get_parameter_value ADDRESS_WIDTH ]
    set cmd_depth       [ get_parameter_value COMMAND_FIFO_DEPTH ]
    set rsp_depth       [ get_parameter_value RESPONSE_FIFO_DEPTH ]
    set aunits          [ get_parameter_value ADDRESS_UNITS ]
    set burst_size      [ get_parameter_value MAX_BURST_SIZE ]
    set mstr_sync_depth [ get_parameter_value MASTER_SYNC_DEPTH ]
    set slv_sync_depth  [ get_parameter_value SLAVE_SYNC_DEPTH ]
    
    if { $mstr_sync_depth < 2 } {
        send_message error "The Master Clock Domain Synchronizer depth must be at least 2, but is currently set to: $mstr_sync_depth"
    }
    if { $slv_sync_depth < 2 } {
        send_message error "The Slave Clock Domain Synchronizer depth must be at least 2, but is currently set to: $slv_sync_depth"
    }


    set_port_property m0_byteenable WIDTH_EXPR $byteen_width
    set_port_property s0_byteenable WIDTH_EXPR $byteen_width

    set_interface_property m0 bitsPerSymbol $sym_width
    set_interface_property s0 bitsPerSymbol $sym_width
 
    set_interface_property m0 addressUnits $aunits
    set_interface_property s0 addressUnits $aunits

    #+---------------------------------------
    #| The bridge implementation allows only as many pending reads 
    #| as can be held in both FIFOs. We need to limit this to
    #| a maximum, sane value. Note that this is higher than the
    #| specification's maximum, because the bridge should not
    #| be the bottleneck (accounting for its internal latency).
    #|
    #| At the moment the bridge itself does not have logic to 
    #| backpressure once the limit is reached: it depends on 
    #| the interconnect to do so.
    #+---------------------------------------
    set mprt [ expr $cmd_depth + $rsp_depth ]
    if { $mprt > 128 } {
        set mprt 128
    }

    set_interface_property s0 maximumPendingReadTransactions $mprt

    set cmd_ok_depth [ expr ( 1 << [ log2ceil $cmd_depth ] ) ]
    if { $cmd_ok_depth != $cmd_depth } {
        send_message error "command FIFO depth must be a power of two"
    }
    set rsp_ok_depth [ expr ( 1 << [ log2ceil $rsp_depth ] ) ]
    if { $rsp_ok_depth != $rsp_depth } {
        send_message error "response FIFO depth must be a power of two"
    }

    set min_depth [ expr ( 2 * $burst_size ) ]
    if  { $rsp_depth < $min_depth } {
        send_message error "response FIFO depth must be >= $min_depth"
    }

    set width [ expr int (ceil (log($burst_size) / log(2))) + 1 ]
    set_parameter_value BURSTCOUNT_WIDTH $width

    set auto_address_width [ calculate_address_widths $data_width $sym_width $aunits ]
    set_parameter_value AUTO_ADDRESS_WIDTH $auto_address_width

    set use_auto_address_width [ get_parameter_value USE_AUTO_ADDRESS_WIDTH ]
    if { $use_auto_address_width == 1 } {
        set_parameter_property ADDRESS_WIDTH ENABLED false
        set_parameter_value HDL_ADDR_WIDTH $auto_address_width
    } else {
        set_parameter_property ADDRESS_WIDTH ENABLED true
        set_parameter_value HDL_ADDR_WIDTH $addr_width
    }

    
}

proc log2ceil {num} {

    set val 0
    set i 1
    while {$i < $num} {
        set val [expr $val + 1]
        set i [expr 1 << $val]
    }

    return $val;
}

proc calculate_address_widths { data_width sym_width aunits } {

    set sysinfo_address_width [ get_parameter_value SYSINFO_ADDR_WIDTH ]
    set auto_address_width $sysinfo_address_width

    if { [ string equal $aunits "WORDS" ] } {
        set num_sym             [ expr $data_width / $sym_width ]
        set byte_to_word_offset [ expr int (ceil (log($num_sym) / log(2))) ]
        set auto_address_width  [ expr $sysinfo_address_width - $byte_to_word_offset ]
    }

    return $auto_address_width
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409959267105
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1416836145555/hco1416836653221
