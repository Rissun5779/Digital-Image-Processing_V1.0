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



# Ensure this component works in 9.1 environment
#---------------------------------------------------------------------
package require -exact sopc 10.0


# Module settings
#---------------------------------------------------------------------
set_module_property DESCRIPTION "Altera Ethernet Link Fault Generation with Unidirectional Transport"
set_module_property NAME altera_eth_link_fault_generation_unidirectional
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/Ethernet/Submodules"
set_module_property DISPLAY_NAME "Ethernet Link Fault Generation with Unidirectional Transport"
set_module_property TOP_LEVEL_HDL_FILE altera_eth_link_fault_generation_unidirectional.v
set_module_property TOP_LEVEL_HDL_MODULE altera_eth_link_fault_generation_unidirectional
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
# set_module_property SIMULATION_MODEL_IN_VERILOG true
# set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ANALYZE_HDL false

# -----------------------------------
# IEEE encryption
# ----------------------------------- 
set HDL_LIB_DIR "../lib"

add_fileset simulation_verilog SIM_VERILOG sim_ver
add_fileset simulation_vhdl SIM_VHDL sim_vhd
set_fileset_property simulation_verilog TOP_LEVEL altera_eth_link_fault_generation_unidirectional

proc sim_ver {name} {
    if {1} {
        add_fileset_file mentor/altera_eth_link_fault_generation_unidirectional.v VERILOG_ENCRYPT PATH "mentor/altera_eth_link_fault_generation_unidirectional.v" {MENTOR_SPECIFIC}
    }
    if {1} {
        add_fileset_file aldec/altera_eth_link_fault_generation_unidirectional.v VERILOG_ENCRYPT PATH "aldec/altera_eth_link_fault_generation_unidirectional.v" {ALDEC_SPECIFIC}
    }
    if {1} {
        add_fileset_file cadence/altera_eth_link_fault_generation_unidirectional.v VERILOG_ENCRYPT PATH "cadence/altera_eth_link_fault_generation_unidirectional.v" {CADENCE_SPECIFIC}
    }
    if {1} {
        add_fileset_file synopsys/altera_eth_link_fault_generation_unidirectional.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_link_fault_generation_unidirectional.v" {SYNOPSYS_SPECIFIC}
    }
}

proc sim_vhd {name} {
   if {1} {
      add_fileset_file mentor/altera_eth_link_fault_generation_unidirectional.v VERILOG_ENCRYPT PATH "mentor/altera_eth_link_fault_generation_unidirectional.v" {MENTOR_SPECIFIC}
   }
   if {1} {
      add_fileset_file aldec/altera_eth_link_fault_generation_unidirectional.v VERILOG_ENCRYPT PATH "aldec/altera_eth_link_fault_generation_unidirectional.v" {ALDEC_SPECIFIC}
   }
   if {1} {
      add_fileset_file cadence/altera_eth_link_fault_generation_unidirectional.v VERILOG_ENCRYPT PATH "cadence/altera_eth_link_fault_generation_unidirectional.v" {CADENCE_SPECIFIC}
   }
   if {1} {
      add_fileset_file synopsys/altera_eth_link_fault_generation_unidirectional.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_link_fault_generation_unidirectional.v" {SYNOPSYS_SPECIFIC}
   }
}

# Files
#---------------------------------------------------------------------
add_file altera_eth_link_fault_generation_unidirectional.v {SYNTHESIS}
add_file altera_eth_link_fault_generation_unidirectional.ocp {SYNTHESIS}

# Parameters Default Values
#---------------------------------------------------------------------
set MII_SYMBOLSPERBEAT_VALUE                    8
set MII_SYMBOLSPERCOLUMN_VALUE                  4


# Constants
#---------------------------------------------------------------------
set MII_BITSPERSYMBOLS_VALUE                    9

set LINK_FAULT_BITSPERSYMBOLS_VALUE             2
set LINK_FAULT_SYMBOLSPERBEAT_VALUE             1





#  Avalon Slave 
#---------------------------------------------------------------------
# N/A



#  Avalon Streaming Sink and Source
#---------------------------------------------------------------------
# N/A





set CLOCK_INTERFACE                             "clk"
set MII_SINK_INTERFACE                          "mii_sink"
set MII_SRC_INTERFACE                           "mii_src"
set LINK_FAULT_SINK_INTERFACE                   "link_fault_sink"
set CSR_INTERFACE                               "csr"


# connection point - clock
#---------------------------------------------------------------------
add_interface       $CLOCK_INTERFACE clock sink
add_interface_port  $CLOCK_INTERFACE clk clk Input 1
add_interface_port  $CLOCK_INTERFACE reset reset Input 1

#  Avalon Slave connection point 
#---------------------------------------------------------------------
# +-----------------------------------
# | connection point csr
# | 
add_interface $CSR_INTERFACE avalon end
set_interface_property $CSR_INTERFACE addressAlignment DYNAMIC
set_interface_property $CSR_INTERFACE bridgesToMaster ""
set_interface_property $CSR_INTERFACE burstOnBurstBoundariesOnly false
set_interface_property $CSR_INTERFACE holdTime 0
set_interface_property $CSR_INTERFACE isMemoryDevice false
set_interface_property $CSR_INTERFACE isNonVolatileStorage false
set_interface_property $CSR_INTERFACE linewrapBursts false
set_interface_property $CSR_INTERFACE maximumPendingReadTransactions 0
set_interface_property $CSR_INTERFACE printableDevice false
set_interface_property $CSR_INTERFACE readLatency 1
set_interface_property $CSR_INTERFACE readWaitTime 0
set_interface_property $CSR_INTERFACE setupTime 0
set_interface_property $CSR_INTERFACE timingUnits Cycles
set_interface_property $CSR_INTERFACE writeWaitTime 0

set_interface_property $CSR_INTERFACE ASSOCIATED_CLOCK $CLOCK_INTERFACE
set_interface_property $CSR_INTERFACE ENABLED true

add_interface_port $CSR_INTERFACE csr_read read Input 1
add_interface_port $CSR_INTERFACE csr_write write Input 1
add_interface_port $CSR_INTERFACE csr_address address Input 1
add_interface_port $CSR_INTERFACE csr_writedata writedata Input 32
add_interface_port $CSR_INTERFACE csr_readdata readdata Output 32

# +-----------------------------------
# | connection point csr_reset
# |
add_interface csr_reset reset end
set_interface_property csr_reset associatedClock $CLOCK_INTERFACE
set_interface_property csr_reset synchronousEdges DEASSERT
set_interface_property csr_reset ENABLED true
add_interface_port csr_reset csr_reset reset Input 1
# | 
# +-----------------------------------

#  Avalon Streaming Sink and Source connection point 
#---------------------------------------------------------------------
add_interface $MII_SINK_INTERFACE avalon_streaming sink
set_interface_property $MII_SINK_INTERFACE ENABLED true
set_interface_property $MII_SINK_INTERFACE ASSOCIATED_CLOCK $CLOCK_INTERFACE
set_interface_property $MII_SINK_INTERFACE dataBitsPerSymbol $MII_BITSPERSYMBOLS_VALUE
set_interface_property $MII_SINK_INTERFACE errorDescriptor ""
set_interface_property $MII_SINK_INTERFACE maxChannel 0
set_interface_property $MII_SINK_INTERFACE readyLatency 0
set_interface_property $MII_SINK_INTERFACE symbolsPerBeat $MII_SYMBOLSPERBEAT_VALUE

add_interface_port $MII_SINK_INTERFACE mii_sink_data data Input [expr {$MII_BITSPERSYMBOLS_VALUE * $MII_SYMBOLSPERBEAT_VALUE }]



add_interface $MII_SRC_INTERFACE avalon_streaming source
set_interface_property $MII_SRC_INTERFACE ENABLED true
set_interface_property $MII_SRC_INTERFACE ASSOCIATED_CLOCK $CLOCK_INTERFACE
set_interface_property $MII_SRC_INTERFACE dataBitsPerSymbol $MII_BITSPERSYMBOLS_VALUE
set_interface_property $MII_SRC_INTERFACE errorDescriptor ""
set_interface_property $MII_SRC_INTERFACE maxChannel 0
set_interface_property $MII_SRC_INTERFACE readyLatency 0
set_interface_property $MII_SRC_INTERFACE symbolsPerBeat $MII_SYMBOLSPERBEAT_VALUE

add_interface_port $MII_SRC_INTERFACE mii_src_data data Output [expr {$MII_BITSPERSYMBOLS_VALUE * $MII_SYMBOLSPERBEAT_VALUE }]



#  Avalon Streaming Sink connection point 
#---------------------------------------------------------------------
add_interface $LINK_FAULT_SINK_INTERFACE avalon_streaming sink
set_interface_property $LINK_FAULT_SINK_INTERFACE ENABLED true
set_interface_property $LINK_FAULT_SINK_INTERFACE ASSOCIATED_CLOCK $CLOCK_INTERFACE
set_interface_property $LINK_FAULT_SINK_INTERFACE dataBitsPerSymbol $LINK_FAULT_BITSPERSYMBOLS_VALUE
set_interface_property $LINK_FAULT_SINK_INTERFACE errorDescriptor ""
set_interface_property $LINK_FAULT_SINK_INTERFACE maxChannel 0
set_interface_property $LINK_FAULT_SINK_INTERFACE readyLatency 0
set_interface_property $LINK_FAULT_SINK_INTERFACE symbolsPerBeat $LINK_FAULT_SYMBOLSPERBEAT_VALUE

add_interface_port $LINK_FAULT_SINK_INTERFACE link_fault_sink_data data Input [expr {$LINK_FAULT_BITSPERSYMBOLS_VALUE * $LINK_FAULT_SYMBOLSPERBEAT_VALUE }]

# +-----------------------------------
# | connection point unidirectional_en and unidirectional_remote_fault_dis
# |
add_interface unidirectional_en conduit end
set_interface_property unidirectional_en ENABLED true
add_interface_port unidirectional_en unidirectional_en export Output 1

add_interface unidirectional_remote_fault_dis conduit end
set_interface_property unidirectional_remote_fault_dis ENABLED true
add_interface_port unidirectional_remote_fault_dis unidirectional_remote_fault_dis export Output 1

add_interface unidirectional_force_remote_fault conduit end
set_interface_property unidirectional_force_remote_fault ENABLED true
add_interface_port unidirectional_force_remote_fault unidirectional_force_remote_fault export Output 1
# | 
# +-----------------------------------