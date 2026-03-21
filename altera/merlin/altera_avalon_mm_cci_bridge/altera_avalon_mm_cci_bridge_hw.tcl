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
# | altera_avalon_mm_cci_bridge "Avalon-MM to CCI Bridge"
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 14.1
# | 
package require -exact qsys 14.1
# | 
# +-----------------------------------

# +-----------------------------------
# | module altera_avalon_mm_cci_bridge
# | 
set_module_property DESCRIPTION "This component creates a bridge between an Avalon-MM master and a CCI Standard interface."
set_module_property NAME altera_avalon_mm_cci_bridge
set_module_property VERSION 18.1
set_module_property GROUP "Basic Functions/Bridges and Adaptors/Memory Mapped"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Avalon-MM to CCI Bridge"
set_module_property AUTHOR "Altera Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ELABORATION_CALLBACK elaborate
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QUARTUS true
set_module_property HIDE_FROM_QSYS true
set_module_property DATASHEET_URL http://www.altera.com/#update_me_with_actual_link
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_fileset bridge_synth QUARTUS_SYNTH add_files
add_fileset bridge_sim   SIM_VERILOG   add_files
set_fileset_property 	 bridge_synth TOP_LEVEL altera_avalon_mm_cci_bridge
set_fileset_property 	 bridge_sim   TOP_LEVEL altera_avalon_mm_cci_bridge

proc add_files { toplevel } {
	add_fileset_file altera_avalon_mm_cci_bridge.v VERILOG PATH ./altera_avalon_mm_cci_bridge.v TOP_LEVEL_FILE
	add_fileset_file cci_read_granter.v VERILOG PATH ./cci_read_granter.v
	add_fileset_file cci_write_granter.v VERILOG PATH ./cci_write_granter.v
	add_fileset_file cci_requester.v VERILOG PATH ./cci_requester.v
	add_fileset_file parallel_match.v VERILOG PATH ./parallel_match.v
}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk
# | 
add_interface clk clock end
add_interface reset_n reset end

set_interface_property clk ENABLED true
set_interface_property reset_n ENABLED true
set_interface_property reset_n ASSOCIATED_CLOCK clk

add_interface_port clk clk clk Input 1
add_interface_port reset_n reset_n reset_n Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point CCI Conduit
# | 
add_interface cci0 conduit start

add_interface_port cci0 InitDone         InitDone input 1
add_interface_port cci0 rx_c0_header     rx_c0_header input 18
add_interface_port cci0 rx_c0_data       rx_c0_data input 512
add_interface_port cci0 rx_c0_rdvalid    rx_c0_rdvalid input 1
add_interface_port cci0 rx_c0_wrvalid    rx_c0_wrvalid input 1
add_interface_port cci0 rx_c0_cfgvalid   rx_c0_cfgvalid input 1
add_interface_port cci0 rx_c0_ugvalid    rx_c0_ugvalid input 1
add_interface_port cci0 rx_c0_irvalid    rx_c0_irvalid input 1
add_interface_port cci0 tx_c0_header     tx_c0_header output 61
add_interface_port cci0 tx_c0_rdvalid    tx_c0_rdvalid output 1
add_interface_port cci0 tx_c0_almostfull tx_c0_almostfull input 1
add_interface_port cci0 rx_c1_header     rx_c1_header input 18
add_interface_port cci0 rx_c1_wrvalid    rx_c1_wrvalid input 1
add_interface_port cci0 rx_c1_irvalid    rx_c1_irvalid input 1
add_interface_port cci0 tx_c1_header     tx_c1_header output 61
add_interface_port cci0 tx_c1_data       tx_c1_data output 512
add_interface_port cci0 tx_c1_wrvalid    tx_c1_wrvalid output 1
add_interface_port cci0 tx_c1_irvalid    tx_c1_irvalid output 1
add_interface_port cci0 tx_c1_almostfull tx_c1_almostfull input 1

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Avalon-MM Slave for CCI
# | 
add_interface avmm avalon end
set_interface_property avmm associatedClock clk

set_interface_property avmm ASSOCIATED_CLOCK clk
set_interface_property avmm associatedReset reset_n
set_interface_property avmm ENABLED true
set_interface_property avmm maximumPendingReadTransactions 16

add_interface_port avmm avmm_waitrequest waitrequest output 1
add_interface_port avmm avmm_readdata readdata output 512
add_interface_port avmm avmm_readdatavalid readdatavalid output 1
add_interface_port avmm avmm_writedata writedata input 512
add_interface_port avmm avmm_address address input 32
add_interface_port avmm avmm_byteenable byteenable input 64
add_interface_port avmm avmm_write write input 1
add_interface_port avmm avmm_read read input 1

# Future use signals
# add_interface_port avmm avmm_byteenable byteenable input 64
# add_interface_port avmm avmm_burstcount burstcount input 2
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Avalon-MM Slave for CCI Config
# | 
add_interface cciconfig avalon start
set_interface_property cciconfig associatedClock clk
set_interface_property cciconfig ASSOCIATED_CLOCK clk
set_interface_property cciconfig associatedReset reset_n
set_interface_property cciconfig ENABLED true

add_interface_port cciconfig cciconfig_writedata writedata output 32
add_interface_port cciconfig cciconfig_address   address output 12
add_interface_port cciconfig cciconfig_write     write output 1
add_interface_port cciconfig cciconfig_waitrequest  waitrequest input 1

add_interface bp0 conduit start
add_interface_port bp0 write_pending write_pending output 1

# | 
# +-----------------------------------

# +-----------------------------------
# | Elaboration
# | 
proc elaborate {} {

}
# | 
# +-----------------------------------

