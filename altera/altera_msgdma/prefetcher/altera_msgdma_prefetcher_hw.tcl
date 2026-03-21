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

# +-----------------------------------
# | module SGDMA_prefetcher
# | 
set_module_property DESCRIPTION "SGDMA prefetching block"
set_module_property NAME altera_msgdma_prefetcher
set_module_property VERSION 18.1
set_module_property GROUP "Basic Functions/DMA/mSGDMA Sub-core"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Modular SGDMA Prefetcher Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property INTERNAL false
set_module_property HIDE_FROM_QUARTUS true
set_module_property ELABORATION_CALLBACK elaborate_me
set_module_property VALIDATION_CALLBACK validate_me
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_msgdma_prefetcher
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_msgdma_prefetcher.v VERILOG PATH altera_msgdma_prefetcher.v TOP_LEVEL_FILE
add_fileset_file altera_msgdma_prefetcher_read.v VERILOG PATH altera_msgdma_prefetcher_read.v 
add_fileset_file altera_msgdma_prefetcher_write_back.v VERILOG PATH altera_msgdma_prefetcher_write_back.v 
add_fileset_file altera_msgdma_prefetcher_fifo.v VERILOG PATH altera_msgdma_prefetcher_fifo.v 
add_fileset_file altera_msgdma_prefetcher_interrrupt.v VERILOG PATH altera_msgdma_prefetcher_interrupt.v 
add_fileset_file altera_msgdma_prefetcher_csr.v VERILOG PATH altera_msgdma_prefetcher_csr.v 

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_msgdma_prefetcher
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_msgdma_prefetcher.v VERILOG PATH altera_msgdma_prefetcher.v TOP_LEVEL_FILE
add_fileset_file altera_msgdma_prefetcher_read.v VERILOG PATH altera_msgdma_prefetcher_read.v 
add_fileset_file altera_msgdma_prefetcher_write_back.v VERILOG PATH altera_msgdma_prefetcher_write_back.v 
add_fileset_file altera_msgdma_prefetcher_fifo.v VERILOG PATH altera_msgdma_prefetcher_fifo.v 
add_fileset_file altera_msgdma_prefetcher_interrrupt.v VERILOG PATH altera_msgdma_prefetcher_interrupt.v 
add_fileset_file altera_msgdma_prefetcher_csr.v VERILOG PATH altera_msgdma_prefetcher_csr.v 

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL altera_msgdma_prefetcher
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_msgdma_prefetcher.v VERILOG PATH altera_msgdma_prefetcher.v TOP_LEVEL_FILE
add_fileset_file altera_msgdma_prefetcher_read.v VERILOG PATH altera_msgdma_prefetcher_read.v 
add_fileset_file altera_msgdma_prefetcher_write_back.v VERILOG PATH altera_msgdma_prefetcher_write_back.v 
add_fileset_file altera_msgdma_prefetcher_fifo.v VERILOG PATH altera_msgdma_prefetcher_fifo.v 
add_fileset_file altera_msgdma_prefetcher_interrrupt.v VERILOG PATH altera_msgdma_prefetcher_interrupt.v 
add_fileset_file altera_msgdma_prefetcher_csr.v VERILOG PATH altera_msgdma_prefetcher_csr.v 


# | 
# +-----------------------------------


set_module_property ELABORATION_CALLBACK elaborate_me
set_module_property VALIDATION_CALLBACK validate_me

add_parameter ENHANCED_FEATURES INTEGER 0
set_parameter_property ENHANCED_FEATURES DISPLAY_NAME "Enable Extended Feature Support"
set_parameter_property ENHANCED_FEATURES UNITS None
set_parameter_property ENHANCED_FEATURES AFFECTS_ELABORATION true
set_parameter_property ENHANCED_FEATURES AFFECTS_GENERATION true
set_parameter_property ENHANCED_FEATURES DERIVED false
set_parameter_property ENHANCED_FEATURES HDL_PARAMETER true
set_parameter_property ENHANCED_FEATURES DISPLAY_HINT boolean

add_parameter ENABLE_READ_BURST INTEGER 0 "Enable read burst will turn on the bursting capabilities of the prefetcher's read descriptor interface." 
set_parameter_property ENABLE_READ_BURST DISPLAY_NAME "Enable bursting on descriptor read master"
set_parameter_property ENABLE_READ_BURST DISPLAY_HINT boolean
set_parameter_property ENABLE_READ_BURST AFFECTS_GENERATION true
set_parameter_property ENABLE_READ_BURST HDL_PARAMETER true
set_parameter_property ENABLE_READ_BURST DERIVED false
set_parameter_property ENABLE_READ_BURST AFFECTS_ELABORATION true

add_parameter GUI_MAX_READ_BURST_COUNT INTEGER 2 "Maximum burst count."
set_parameter_property GUI_MAX_READ_BURST_COUNT ALLOWED_RANGES {2 4 8 16}
set_parameter_property GUI_MAX_READ_BURST_COUNT DISPLAY_NAME "Maximum Burst Count on descriptor read master"
set_parameter_property GUI_MAX_READ_BURST_COUNT AFFECTS_GENERATION true
set_parameter_property GUI_MAX_READ_BURST_COUNT HDL_PARAMETER false
set_parameter_property GUI_MAX_READ_BURST_COUNT DERIVED false
set_parameter_property GUI_MAX_READ_BURST_COUNT AFFECTS_ELABORATION true

add_parameter MAX_READ_BURST_COUNT INTEGER 2
set_parameter_property MAX_READ_BURST_COUNT AFFECTS_GENERATION true
set_parameter_property MAX_READ_BURST_COUNT DERIVED true
set_parameter_property MAX_READ_BURST_COUNT HDL_PARAMETER true
set_parameter_property MAX_READ_BURST_COUNT AFFECTS_ELABORATION true
set_parameter_property MAX_READ_BURST_COUNT VISIBLE false

add_parameter MAX_READ_BURST_COUNT_WIDTH INTEGER 2
set_parameter_property MAX_READ_BURST_COUNT_WIDTH AFFECTS_GENERATION true
set_parameter_property MAX_READ_BURST_COUNT_WIDTH DERIVED true
set_parameter_property MAX_READ_BURST_COUNT_WIDTH HDL_PARAMETER true
set_parameter_property MAX_READ_BURST_COUNT_WIDTH AFFECTS_ELABORATION true
set_parameter_property MAX_READ_BURST_COUNT_WIDTH VISIBLE false

add_parameter DATA_WIDTH INTEGER 32 "Width of the Avalon MM descriptor read/write data path."
set_parameter_property DATA_WIDTH ALLOWED_RANGES {32 64 128 256 512}
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data Width of Descriptor read/write master data path"
set_parameter_property DATA_WIDTH AFFECTS_GENERATION true
set_parameter_property DATA_WIDTH DERIVED false
set_parameter_property DATA_WIDTH HDL_PARAMETER true
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true

add_parameter DATA_BYTEENABLE_WIDTH INTEGER 4
set_parameter_property DATA_BYTEENABLE_WIDTH AFFECTS_GENERATION true
set_parameter_property DATA_BYTEENABLE_WIDTH DERIVED true
set_parameter_property DATA_BYTEENABLE_WIDTH HDL_PARAMETER true
set_parameter_property DATA_BYTEENABLE_WIDTH AFFECTS_ELABORATION true
set_parameter_property DATA_BYTEENABLE_WIDTH VISIBLE false

add_parameter DESCRIPTOR_WIDTH INTEGER 128
set_parameter_property DESCRIPTOR_WIDTH AFFECTS_GENERATION true
set_parameter_property DESCRIPTOR_WIDTH DERIVED true
set_parameter_property DESCRIPTOR_WIDTH HDL_PARAMETER true
set_parameter_property DESCRIPTOR_WIDTH AFFECTS_ELABORATION true
set_parameter_property DESCRIPTOR_WIDTH VISIBLE false

add_parameter AUTO_ADDRESS_WIDTH INTEGER 32
set_parameter_property AUTO_ADDRESS_WIDTH AFFECTS_GENERATION true
set_parameter_property AUTO_ADDRESS_WIDTH DERIVED true
set_parameter_property AUTO_ADDRESS_WIDTH HDL_PARAMETER false
set_parameter_property AUTO_ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property AUTO_ADDRESS_WIDTH VISIBLE false
set_parameter_property AUTO_ADDRESS_WIDTH SYSTEM_INFO {ADDRESS_WIDTH Descriptor_Read_Master}

add_parameter ADDRESS_WIDTH INTEGER 32
set_parameter_property ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDRESS_WIDTH DERIVED true
set_parameter_property ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADDRESS_WIDTH VISIBLE false

add_parameter GUI_DESCRIPTOR_FIFO_DEPTH INTEGER 128
set_parameter_property GUI_DESCRIPTOR_FIFO_DEPTH DISPLAY_NAME "Descriptor FIFO Depth"
set_parameter_property GUI_DESCRIPTOR_FIFO_DEPTH UNITS None
set_parameter_property GUI_DESCRIPTOR_FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property GUI_DESCRIPTOR_FIFO_DEPTH AFFECTS_GENERATION true
set_parameter_property GUI_DESCRIPTOR_FIFO_DEPTH DERIVED false
set_parameter_property GUI_DESCRIPTOR_FIFO_DEPTH HDL_PARAMETER false
set_parameter_property GUI_DESCRIPTOR_FIFO_DEPTH ALLOWED_RANGES { 8 16 32 64 128 256 512 1024 }

add_parameter RESPONSE_FIFO_DEPTH INTEGER 32
set_parameter_property RESPONSE_FIFO_DEPTH AFFECTS_GENERATION false
set_parameter_property RESPONSE_FIFO_DEPTH DERIVED true
set_parameter_property RESPONSE_FIFO_DEPTH HDL_PARAMETER true
set_parameter_property RESPONSE_FIFO_DEPTH AFFECTS_ELABORATION false
set_parameter_property RESPONSE_FIFO_DEPTH VISIBLE false

add_parameter RESPONSE_FIFO_DEPTH_LOG2 INTEGER 5
set_parameter_property RESPONSE_FIFO_DEPTH_LOG2 AFFECTS_GENERATION false
set_parameter_property RESPONSE_FIFO_DEPTH_LOG2 DERIVED true
set_parameter_property RESPONSE_FIFO_DEPTH_LOG2 HDL_PARAMETER true
set_parameter_property RESPONSE_FIFO_DEPTH_LOG2 AFFECTS_ELABORATION false
set_parameter_property RESPONSE_FIFO_DEPTH_LOG2 VISIBLE false

add_parameter USE_FIX_ADDRESS_WIDTH Integer 0 "Use pre-determined master address width instead of automatically-determined master address width"
set_parameter_property USE_FIX_ADDRESS_WIDTH DISPLAY_NAME "Use pre-determined master address width"
set_parameter_property USE_FIX_ADDRESS_WIDTH DISPLAY_HINT boolean
set_parameter_property USE_FIX_ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property USE_FIX_ADDRESS_WIDTH DERIVED false
set_parameter_property USE_FIX_ADDRESS_WIDTH HDL_PARAMETER false
set_parameter_property USE_FIX_ADDRESS_WIDTH AFFECTS_ELABORATION true

add_parameter FIX_ADDRESS_WIDTH INTEGER 32 "Minimum master address width that is required to address memory slave."
set_parameter_property FIX_ADDRESS_WIDTH DISPLAY_NAME "Pre-determined master address width:"
set_parameter_property FIX_ADDRESS_WIDTH ALLOWED_RANGES 1:64
set_parameter_property FIX_ADDRESS_WIDTH AFFECTS_GENERATION true
set_parameter_property FIX_ADDRESS_WIDTH DERIVED false
set_parameter_property FIX_ADDRESS_WIDTH HDL_PARAMETER false
set_parameter_property FIX_ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property FIX_ADDRESS_WIDTH VISIBLE true

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Clock
# | 
add_interface Clock clock end
set_interface_property Clock ptfSchematicName ""

set_interface_property Clock ENABLED true

add_interface_port Clock clk clk Input 1
add_interface_port Clock reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Descriptor_Read_Master
# | 
add_interface Descriptor_Read_Master avalon start
set_interface_property Descriptor_Read_Master adaptsTo ""
set_interface_property Descriptor_Read_Master doStreamReads false
set_interface_property Descriptor_Read_Master doStreamWrites false
set_interface_property Descriptor_Read_Master linewrapBursts false

set_interface_property Descriptor_Read_Master ASSOCIATED_CLOCK Clock
set_interface_property Descriptor_Read_Master ENABLED true

add_interface_port Descriptor_Read_Master mm_read_address address Output -1
add_interface_port Descriptor_Read_Master mm_read_read read Output 1
add_interface_port Descriptor_Read_Master mm_read_readdata readdata Input -1
add_interface_port Descriptor_Read_Master mm_read_waitrequest waitrequest Input 1
add_interface_port Descriptor_Read_Master mm_read_readdatavalid readdatavalid Input 1
add_interface_port Descriptor_Read_Master mm_read_burstcount burstcount Output -1

set_port_property mm_read_burstcount VHDL_TYPE STD_LOGIC_VECTOR
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Descriptor_Writer_Master (write back)
# | 
add_interface Descriptor_Write_Master avalon start
set_interface_property Descriptor_Write_Master adaptsTo ""
set_interface_property Descriptor_Write_Master doStreamReads false
set_interface_property Descriptor_Write_Master doStreamWrites false
set_interface_property Descriptor_Write_Master linewrapBursts false
set_interface_property Descriptor_Write_Master maximumPendingWriteTransactions 3

set_interface_property Descriptor_Write_Master ASSOCIATED_CLOCK Clock
set_interface_property Descriptor_Write_Master ENABLED true

add_interface_port Descriptor_Write_Master mm_write_address address Output -1
add_interface_port Descriptor_Write_Master mm_write_write write Output 1
add_interface_port Descriptor_Write_Master mm_write_byteenable byteenable Output -1
add_interface_port Descriptor_Write_Master mm_write_writedata writedata Output -1
add_interface_port Descriptor_Write_Master mm_write_waitrequest waitrequest Input 1
add_interface_port Descriptor_Write_Master mm_write_response response Input 2
add_interface_port Descriptor_Write_Master mm_write_writeresponsevalid writeresponsevalid Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Descriptor_Write_Dispatcher_Source
# | 
add_interface Descriptor_Write_Dispatcher_Source avalon_streaming start
set_interface_property Descriptor_Write_Dispatcher_Source dataBitsPerSymbol 256
set_interface_property Descriptor_Write_Dispatcher_Source errorDescriptor ""
set_interface_property Descriptor_Write_Dispatcher_Source maxChannel 0
set_interface_property Descriptor_Write_Dispatcher_Source readyLatency 0
set_interface_property Descriptor_Write_Dispatcher_Source symbolsPerBeat 1

set_interface_property Descriptor_Write_Dispatcher_Source ASSOCIATED_CLOCK Clock

add_interface_port Descriptor_Write_Dispatcher_Source st_src_descr_data data Output -1
add_interface_port Descriptor_Write_Dispatcher_Source st_src_descr_valid valid Output 1
add_interface_port Descriptor_Write_Dispatcher_Source st_src_descr_ready ready Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point st sink response
# | 
add_interface Response_Sink avalon_streaming end
set_interface_property Response_Sink dataBitsPerSymbol 256
set_interface_property Response_Sink errorDescriptor ""
set_interface_property Response_Sink maxChannel 0
set_interface_property Response_Sink readyLatency 0
set_interface_property Response_Sink symbolsPerBeat 1

set_interface_property Response_Sink ASSOCIATED_CLOCK Clock

add_interface_port Response_Sink st_snk_data data Input 256
add_interface_port Response_Sink st_snk_valid valid Input 1
add_interface_port Response_Sink st_snk_ready ready Output 1
# | 
# +-----------------------------------

# 
# connection point Csr
# 
add_interface Csr avalon end
set_interface_property Csr addressUnits WORDS
set_interface_property Csr associatedClock Clock
set_interface_property Csr bitsPerSymbol 8
set_interface_property Csr burstOnBurstBoundariesOnly false
set_interface_property Csr burstcountUnits WORDS
set_interface_property Csr explicitAddressSpan 0
set_interface_property Csr holdTime 0
set_interface_property Csr linewrapBursts false
set_interface_property Csr maximumPendingReadTransactions 0
set_interface_property Csr maximumPendingWriteTransactions 0
set_interface_property Csr readLatency 1
set_interface_property Csr readWaitStates 0
set_interface_property Csr readWaitTime 0
set_interface_property Csr setupTime 0
set_interface_property Csr timingUnits Cycles
set_interface_property Csr writeWaitTime 0
set_interface_property Csr ENABLED true
set_interface_property Csr EXPORT_OF ""
set_interface_property Csr PORT_NAME_MAP ""
set_interface_property Csr CMSIS_SVD_VARIABLES ""
set_interface_property Csr SVD_ADDRESS_GROUP ""

add_interface_port Csr mm_csr_address address Input 3
add_interface_port Csr mm_csr_read read Input 1
add_interface_port Csr mm_csr_write write Input 1
add_interface_port Csr mm_csr_writedata writedata Input 32
add_interface_port Csr mm_csr_readdata readdata Output 32
set_interface_assignment Csr embeddedsw.configuration.isFlash 0
set_interface_assignment Csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment Csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment Csr embeddedsw.configuration.isPrintableDevice 0

# +-----------------------------------
# | connection point Csr_Irq
# | 
add_interface Csr_Irq interrupt end
set_interface_property Csr_Irq associatedAddressablePoint csr

set_interface_property Csr_Irq ASSOCIATED_CLOCK Clock

add_interface_port Csr_Irq csr_irq irq Output 1
# | 
# +-----------------------------------

# the elaboration callback will be used to enable/disable signals
# based on user input as well as control the width of all the signals that have variable width
proc elaborate_me {}  {

    set_port_property mm_read_address WIDTH_EXPR [get_parameter_value ADDRESS_WIDTH]
    set_port_property mm_read_readdata WIDTH_EXPR [get_parameter_value DATA_WIDTH]
    set_port_property mm_read_burstcount WIDTH_EXPR [get_parameter_value MAX_READ_BURST_COUNT_WIDTH]
    
    set_port_property mm_write_address WIDTH_EXPR [get_parameter_value ADDRESS_WIDTH]
    set_port_property mm_write_writedata WIDTH_EXPR [get_parameter_value DATA_WIDTH]
    set_port_property mm_write_byteenable WIDTH_EXPR [get_parameter_value DATA_BYTEENABLE_WIDTH]
   
    set DESCRIPTOR_WIDTH [get_parameter_value DESCRIPTOR_WIDTH]
    set_interface_property Descriptor_Write_Dispatcher_Source dataBitsPerSymbol $DESCRIPTOR_WIDTH
    set_port_property st_src_descr_data WIDTH_EXPR $DESCRIPTOR_WIDTH


    if { [get_parameter_value ENABLE_READ_BURST] == 1 }  {
        set_port_property mm_read_burstcount TERMINATION false
    } else {
        set_port_property mm_read_burstcount TERMINATION true
    }

}

# the validation callback will be enabling/disabling GUI controls based on user input
proc validate_me {}  {

    if { [get_parameter_value ENABLE_READ_BURST] == 1 }  {
        set_parameter_property GUI_MAX_READ_BURST_COUNT ENABLED true
        set_parameter_value MAX_READ_BURST_COUNT [get_parameter_value GUI_MAX_READ_BURST_COUNT]
        set_parameter_value MAX_READ_BURST_COUNT_WIDTH [expr {(log([get_parameter_value GUI_MAX_READ_BURST_COUNT]) / log(2)) + 1}]

        if { [get_parameter_value ENHANCED_FEATURES] == 1 } {
            set_parameter_property DATA_WIDTH ALLOWED_RANGES {32 64 128 256}

            if { [get_parameter_value DATA_WIDTH] == 256 } {
                set_parameter_property GUI_MAX_READ_BURST_COUNT ALLOWED_RANGES {2}
            } elseif { [get_parameter_value DATA_WIDTH] == 128 } {
                set_parameter_property GUI_MAX_READ_BURST_COUNT ALLOWED_RANGES {2 4}
            } elseif { [get_parameter_value DATA_WIDTH] == 64 } {
                set_parameter_property GUI_MAX_READ_BURST_COUNT ALLOWED_RANGES {2 4 8}
            } elseif { [get_parameter_value DATA_WIDTH] == 32 } {
                set_parameter_property GUI_MAX_READ_BURST_COUNT ALLOWED_RANGES {2 4 8 16}
            }

        } else {
            set_parameter_property DATA_WIDTH ALLOWED_RANGES {32 64 128}
            
            if { [get_parameter_value DATA_WIDTH] == 128 } {
                set_parameter_property GUI_MAX_READ_BURST_COUNT ALLOWED_RANGES {2}
            } elseif { [get_parameter_value DATA_WIDTH] == 64 } {
                set_parameter_property GUI_MAX_READ_BURST_COUNT ALLOWED_RANGES {2 4}
            } elseif { [get_parameter_value DATA_WIDTH] == 32 } {
                set_parameter_property GUI_MAX_READ_BURST_COUNT ALLOWED_RANGES {2 4 8}
            }

        }

    } else {
        set_parameter_property GUI_MAX_READ_BURST_COUNT ENABLED false
        set_parameter_value MAX_READ_BURST_COUNT 1
        set_parameter_value MAX_READ_BURST_COUNT_WIDTH 1

        if { [get_parameter_value ENHANCED_FEATURES] == 1 } {
            set_parameter_property DATA_WIDTH ALLOWED_RANGES {32 64 128 256 512}
        } else {
            set_parameter_property DATA_WIDTH ALLOWED_RANGES {32 64 128 256}
        }

    }

    if { [get_parameter_value ENHANCED_FEATURES] == 1 }  {
        set_parameter_value DESCRIPTOR_WIDTH 256
    } else {
        set_parameter_value DESCRIPTOR_WIDTH 128
    }

    set_parameter_value DATA_BYTEENABLE_WIDTH [expr {[get_parameter_value DATA_WIDTH] / 8}]
  
    set_parameter_value RESPONSE_FIFO_DEPTH [expr {[get_parameter_value GUI_DESCRIPTOR_FIFO_DEPTH] * 2}]
    set_parameter_value RESPONSE_FIFO_DEPTH_LOG2 [expr {(log([get_parameter_value RESPONSE_FIFO_DEPTH]) / log(2))}]
  
    if { [get_parameter_value USE_FIX_ADDRESS_WIDTH] == 1 }  {
        set_parameter_property FIX_ADDRESS_WIDTH ENABLED true
        set_parameter_value ADDRESS_WIDTH [get_parameter_value FIX_ADDRESS_WIDTH]
    } else {
        set_parameter_property FIX_ADDRESS_WIDTH ENABLED false
        set_parameter_value ADDRESS_WIDTH [get_parameter_value AUTO_ADDRESS_WIDTH]
    }

}

## Add documentation links for user guide and/or release notes
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
