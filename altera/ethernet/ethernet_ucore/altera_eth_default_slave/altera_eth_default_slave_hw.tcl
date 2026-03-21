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


## +-----------------------------------
# | request TCL package from ACDS 9.1
# | 
package require -exact sopc 9.1
# | 
# +-----------------------------------

# +-----------------------------------
# | module altera_eth_default_slave
# | 
set_module_property NAME altera_eth_default_slave
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/Ethernet/Submodules"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Ethernet Default Slave"
set_module_property TOP_LEVEL_HDL_FILE altera_eth_default_slave.v
set_module_property TOP_LEVEL_HDL_MODULE altera_eth_default_slave
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate
# set_module_property SIMULATION_MODEL_IN_VERILOG true
# set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ANALYZE_HDL false
# | 
# +-----------------------------------

# -----------------------------------
# IEEE encryption
# ----------------------------------- 
set HDL_LIB_DIR "../lib"

add_fileset simulation_verilog SIM_VERILOG sim_ver
add_fileset simulation_vhdl SIM_VHDL sim_vhd
set_fileset_property simulation_verilog TOP_LEVEL altera_eth_default_slave

proc sim_ver {name} {
    if {1} {
        add_fileset_file mentor/altera_eth_default_slave.v VERILOG_ENCRYPT PATH "mentor/altera_eth_default_slave.v" {MENTOR_SPECIFIC}
    }
    if {1} {
        add_fileset_file aldec/altera_eth_default_slave.v VERILOG_ENCRYPT PATH "aldec/altera_eth_default_slave.v" {ALDEC_SPECIFIC}
    }
    if {1} {
        add_fileset_file cadence/altera_eth_default_slave.v VERILOG_ENCRYPT PATH "cadence/altera_eth_default_slave.v" {CADENCE_SPECIFIC}
    }
    if {1} {
        add_fileset_file synopsys/altera_eth_default_slave.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_default_slave.v" {SYNOPSYS_SPECIFIC}
    }
}

proc sim_vhd {name} {
   if {1} {
      add_fileset_file mentor/altera_eth_default_slave.v VERILOG_ENCRYPT PATH "mentor/altera_eth_default_slave.v" {MENTOR_SPECIFIC}
   }
   if {1} {
      add_fileset_file aldec/altera_eth_default_slave.v VERILOG_ENCRYPT PATH "aldec/altera_eth_default_slave.v" {ALDEC_SPECIFIC}
   }
   if {1} {
      add_fileset_file cadence/altera_eth_default_slave.v VERILOG_ENCRYPT PATH "cadence/altera_eth_default_slave.v" {CADENCE_SPECIFIC}
   }
   if {1} {
      add_fileset_file synopsys/altera_eth_default_slave.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_default_slave.v" {SYNOPSYS_SPECIFIC}
   }
}



proc validate {} {
}

proc elaborate {} {
  set csr_datapath_width 32
  set csr_address_width 1

  set_port_property csr_address WIDTH $csr_address_width 
  set_port_property csr_address VHDL_TYPE STD_LOGIC_VECTOR
  set_port_property csr_writedata WIDTH $csr_datapath_width
  set_port_property csr_readdata WIDTH $csr_datapath_width
}

# +-----------------------------------
# | files
# | 
add_file altera_eth_default_slave.v {SYNTHESIS}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_reset
# | 
add_interface clock_reset clock end

set_interface_property clock_reset ENABLED true

add_interface_port clock_reset clk clk Input 1

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point csr_reset
# |
add_interface csr_reset reset end
set_interface_property csr_reset associatedClock clock_reset
set_interface_property csr_reset synchronousEdges DEASSERT
set_interface_property csr_reset ENABLED true
add_interface_port csr_reset csr_reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point csr
# | 
add_interface csr avalon end
set_interface_property csr addressAlignment DYNAMIC
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr isMemoryDevice false
set_interface_property csr isNonVolatileStorage false
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr printableDevice false
set_interface_property csr readLatency 1
set_interface_property csr readWaitTime 0
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0

set_interface_property csr ASSOCIATED_CLOCK clock_reset
set_interface_property csr ENABLED true

add_interface_port csr csr_write write Input 1
add_interface_port csr csr_read read Input 1
add_interface_port csr csr_address address Input 1
add_interface_port csr csr_writedata writedata Input 32
add_interface_port csr csr_readdata readdata Output 32
# | 
# +-----------------------------------

