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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/altera_dual_boot/altera_dual_boot/altera_dual_boot_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1

# Source files
source altera_dual_boot_hw_proc.tcl

# +-----------------------------------
# | module Fault Injection
# +-----------------------------------
set_module_property NAME altera_dual_boot
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Dual Configuration Intel FPGA IP"
set_module_property DESCRIPTION "Altera Dual Configuration allow customers to perform design update."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
#set_module_property DATASHEET_URL ""
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true

set supported_device_families_list {"MAX 10"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list

# +-----------------------------------
# | Device family
# +-----------------------------------
add_parameter INTENDED_DEVICE_FAMILY STRING
set_parameter_property INTENDED_DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE false
set_parameter_property INTENDED_DEVICE_FAMILY HDL_PARAMETER true
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}

# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------
# Clock Frequency
add_parameter CLOCK_FREQUENCY FLOAT "80"
set_parameter_property CLOCK_FREQUENCY DISPLAY_NAME "Clock frequency"
set_parameter_property CLOCK_FREQUENCY DESCRIPTION "Specifies the clock frequency"
set_parameter_property CLOCK_FREQUENCY UNITS "megahertz"
set_parameter_property CLOCK_FREQUENCY DISPLAY_HINT ""
set_parameter_property CLOCK_FREQUENCY HDL_PARAMETER false
set_parameter_property CLOCK_FREQUENCY ENABLED true
set_parameter_property CLOCK_FREQUENCY ALLOWED_RANGES "1:80"
# +-----------------------------------
# | Parameters - Project Settings 
# +-----------------------------------
add_parameter CONFIG_CYCLE INTEGER 28
set_parameter_property CONFIG_CYCLE VISIBLE false
set_parameter_property CONFIG_CYCLE ENABLED true
set_parameter_property CONFIG_CYCLE HDL_PARAMETER true
set_parameter_property CONFIG_CYCLE DERIVED true

add_parameter RESET_TIMER_CYCLE INTEGER 40
set_parameter_property RESET_TIMER_CYCLE VISIBLE false
set_parameter_property RESET_TIMER_CYCLE ENABLED true
set_parameter_property RESET_TIMER_CYCLE HDL_PARAMETER true
set_parameter_property RESET_TIMER_CYCLE DERIVED true
# +-----------------------------------
# | Block Interface
# +-----------------------------------
#clk port
set CLK_INTERFACE "clk"
add_interface $CLK_INTERFACE clock end
add_interface_port $CLK_INTERFACE $CLK_INTERFACE clk Input 1

#nreset port
set NRESET_INTERFACE "nreset"
add_interface $NRESET_INTERFACE reset end
set_interface_property $NRESET_INTERFACE associatedClock clk
add_interface_port $NRESET_INTERFACE $NRESET_INTERFACE reset_n Input 1

# Avalon-MM slave interface
add_interface avalon avalon slave
set_interface_property avalon ENABLED true
set_interface_property avalon addressUnits {WORDS}
set_interface_property avalon associatedClock {clk}
set_interface_property avalon associatedReset {nreset}
set_interface_property avalon bitsPerSymbol {8}
set_interface_property avalon burstOnBurstBoundariesOnly {0}
set_interface_property avalon burstcountUnits {WORDS}
set_interface_property avalon constantBurstBehavior {0}
set_interface_property avalon holdTime {0}
set_interface_property avalon linewrapBursts {0}
set_interface_property avalon maximumPendingReadTransactions {0}
set_interface_property avalon readLatency {0}
set_interface_property avalon readWaitStates {1}
set_interface_property avalon readWaitTime {1}
set_interface_property avalon registerIncomingSignals {0}
set_interface_property avalon registerOutgoingSignals {0}
set_interface_property avalon setupTime {0}
set_interface_property avalon timingUnits {Cycles}
set_interface_property avalon writeLatency {0}
set_interface_property avalon writeWaitStates {0}
set_interface_property avalon writeWaitTime {0}

add_interface_port avalon avmm_rcv_address address Input 3
add_interface_port avalon avmm_rcv_read read Input 1
add_interface_port avalon avmm_rcv_writedata writedata Input 32
add_interface_port avalon avmm_rcv_write write Input 1
add_interface_port avalon avmm_rcv_readdata readdata Output 32

# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
set_module_property ELABORATION_CALLBACK elaboration_callback

# +-----------------------------------
# | Fileset Generation
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
set_fileset_property quartus_synth TOP_LEVEL altera_dual_boot

#simulation
add_fileset sim_vhdl SIM_VHDL generate_vhdl_sim
set_fileset_property sim_vhdl TOP_LEVEL altera_dual_boot

add_fileset sim_verilog SIM_VERILOG generate_vhdl_sim
set_fileset_property sim_verilog TOP_LEVEL altera_dual_boot


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sss1393988509894/sss1397214804121
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1416836145555/hco1416836653221
